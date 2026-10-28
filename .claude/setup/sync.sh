#!/usr/bin/env bash
# Setup sync (manual version). Keeps Justin's Claude Code + Hermes setup files in step
# between machines through the private repo Just-In-N-Out/claude-setup: a bare repo at
# ~/.claude-setup.git whose work tree is $HOME, so every file stays at its normal path.
# Guide: ~/.github/README.md (what syncs, rules, daily flow), ~/.claude/setup/mac.md,
# ~/.claude/setup/desktop.md. The automatic version (hooks + launchd) is planned in
# ~/.hermes/plans/claude-setup/setup-sync.md and will replace this script.
#
#   sync.sh              commit this machine's changes, pull the other machine's, push
#   sync.sh pull         commit this machine's changes, pull the other machine's, no push
#   sync.sh status       stage, check and secret-scan only; show what would be committed
#   sync.sh init         Mac, once: create ~/.claude-setup.git
#   sync.sh attach       new machine, once, after the bare clone (see desktop.md)
#   sync.sh links        (re)create desktop memory links and project CLAUDE.md files
#   sync.sh changed      exit 0 when there is anything to sync, 1 when not (no lock, network or staging)
# --allow-deletes lets one commit delete more than 25 files.
# Every sync also rebuilds the Codex files made from synced sources (~/.codex/AGENTS.md, the role
# files' model lines) with ~/.claude/setup/codex/build-codex.sh, when this machine has ~/.codex.
set -euo pipefail

GD="${SETUP_SYNC_GIT_DIR:-$HOME/.claude-setup.git}"
SETUP="$HOME/.claude/setup"
URL="${SETUP_SYNC_URL:-https://github.com/Just-In-N-Out/claude-setup.git}"
GH_USER="${SETUP_SYNC_GH_USER:-Just-In-N-Out}"
LIB="$HOME/.hermes/skills-library"
PATCHF="$HOME/.hermes/skills-library-local.patch"
LOCK="$GD/setup-sync.lock"
MAX_BYTES=5242880 # 5 MB
MAX_DELETES=25
# Never synced, whatever manifest.txt and exclude.txt say.
DENY_RE='(^|/)\.env($|\.)|(^|/)auth\.json$|(^|/)config\.yaml$|(^|/)state\.db($|-)|^\.claude\.json|(^|/)evidence/|(^|/)private/|^\.ssh/|^\.gnupg/|^\.claude-setup\.git/|^\.hermes/(cache|sessions|hermes-agent|skills-library)/|^\.claude/(history\.jsonl|sessions/|file-history/|plugins/|session-env/|shell-snapshots/|telemetry/|paste-cache/|debug/|daemon|hooks/state/|skills/)|\.(pem|key|p12|pfx)$|(^|/)id_(rsa|ed25519|ecdsa)|^\.codex/(auth\.json|config\.toml|AGENTS(\.override)?\.md$|backups/|history\.jsonl|session_index\.jsonl|models_cache\.json|version\.json|installation_id|.*\.sqlite|sessions/|log/|logs|cache/|\.tmp/|tmp/|skills/|plugins/|memories/|packages/|shell_snapshots/|app-server|ipc/|thread-writer-locks/|tui-|\.personality|\.sandbox|rules/default\.rules|hooks/state/)|^\.codex-probe/|^\.agents/'

CMD=sync
ALLOW_DELETES=0
for a in "$@"; do
  case "$a" in
    sync | pull | status | init | attach | links | changed) CMD=$a ;;
    --allow-deletes) ALLOW_DELETES=1 ;;
    -h | --help) sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "setup-sync: unknown argument: $a (try --help)" >&2; exit 2 ;;
  esac
done

cd "$HOME" # git resolves paths against the current folder; every path here is $HOME-relative
g() { git -c core.quotePath=false --git-dir="$GD" --work-tree="$HOME" "$@"; }
say() { echo "setup-sync: $*"; }
die() { echo "setup-sync: $*" >&2; exit 1; }

case "$(uname -s)" in Darwin) PATH_COL=2 ;; *) PATH_COL=3 ;; esac
PATH_COL="${SETUP_SYNC_PATH_COL:-$PATH_COL}" # tests only

# projects.tsv rows as: name, this machine's path, memory folder, claude_md
projects() {
  [ -f "$SETUP/projects.tsv" ] || return 0
  awk -F'\t' -v c="$PATH_COL" '!/^#/ && NF >= 5 { print $1 "\t" $c "\t" $4 "\t" $5 }' "$SETUP/projects.tsv"
}

configure() {
  g config core.bare false
  g config core.worktree "$HOME"
  g config status.showUntrackedFiles no
  g config remote.origin.url >/dev/null 2>&1 || g config remote.origin.url "$URL"
  g config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  g config branch.main.remote origin
  g config branch.main.merge refs/heads/main
  # GitHub auth: the Just-In-N-Out token from gh, without switching gh's active account.
  g config --unset-all credential.helper 2>/dev/null || true
  g config --add credential.helper ''
  g config --add credential.helper "!f() { test \"\$1\" = get || exit 0; echo username=$GH_USER; echo \"password=\$(gh auth token --user $GH_USER)\"; }; f"
}

write_exclude() {
  mkdir -p "$GD/info"
  {
    cat "$SETUP/exclude.txt"
    echo "# symlinks: each machine builds its own (update-skills-library.sh, sync.sh links)"
    {
      (cd "$HOME" && find .hermes/skills .claude/skills -type l 2>/dev/null) || true
      (cd "$HOME" && find .claude/projects -maxdepth 2 -type l 2>/dev/null) || true
    } | sed 's|^|/|'
  } >"$GD/info/exclude"
}

lock() {
  local err
  if ! err=$(mkdir "$LOCK" 2>&1); then
    if [ ! -d "$LOCK" ] && ! grep -qi 'exists' <<<"$err"; then # not a held lock: the repo can't be written here
      die "can't create $LOCK, so $GD is not writable here ($err). In Codex's sandbox, run sync.sh with escalation (sandbox_permissions require_escalated): ~/.codex/rules/setup-sync.rules approves it."
    fi
    if [ -n "$(find "$LOCK" -maxdepth 0 -mmin +10 2>/dev/null)" ]; then
      rm -rf "$LOCK" && mkdir "$LOCK"
    else
      die "another sync is running ($LOCK); try again in a minute."
    fi
  fi
  trap 'rm -rf "$LOCK"' EXIT
}

exclude_claude_md() { # keep CLAUDE.md out of the project's own repo
  [ -d "$1/.git" ] || return 0
  mkdir -p "$1/.git/info"
  grep -qxF CLAUDE.md "$1/.git/info/exclude" 2>/dev/null || echo CLAUDE.md >>"$1/.git/info/exclude"
}

# project CLAUDE.md -> ~/.claude/project-docs/<name>/CLAUDE.md (before every commit)
copy_in() {
  projects | while IFS=$'\t' read -r name path mem cm; do
    [ "$cm" = yes ] && [ -f "$path/CLAUDE.md" ] || continue
    dst="$HOME/.claude/project-docs/$name/CLAUDE.md"
    cmp -s "$path/CLAUDE.md" "$dst" && continue
    mkdir -p "${dst%/*}" && cp "$path/CLAUDE.md" "$dst"
  done
}

# ~/.claude/project-docs/<name>/CLAUDE.md -> project, for copies the pull changed ($1: changed paths)
copy_out() {
  projects | while IFS=$'\t' read -r name path mem cm; do
    [ "$cm" = yes ] || continue
    src="$HOME/.claude/project-docs/$name/CLAUDE.md"
    printf '%s\n' "$1" | grep -xF ".claude/project-docs/$name/CLAUDE.md" >/dev/null || continue
    [ -f "$src" ] && [ -d "$path" ] || continue
    cmp -s "$src" "$path/CLAUDE.md" && continue
    cp "$src" "$path/CLAUDE.md" && say "updated $path/CLAUDE.md"
    exclude_claude_md "$path"
  done
}

# Edits to library skills (code-review-practice…) travel as skills-library-local.patch.
save_lib_patch() {
  [ -d "$LIB/.git" ] || return 0
  local tmp
  tmp=$(mktemp)
  git -C "$LIB" diff >"$tmp"
  if [ -s "$tmp" ] && ! cmp -s "$tmp" "$PATCHF"; then mv "$tmp" "$PATCHF"; else rm -f "$tmp"; fi
}

apply_lib_patch() {
  [ -d "$LIB/.git" ] && [ -s "$PATCHF" ] || return 0
  # this machine's own library edits are already in the patch (saved before the pull)
  git -C "$LIB" checkout -q -- .
  if git -C "$LIB" apply --whitespace=nowarn "$PATCHF"; then
    say "applied library skill edits from skills-library-local.patch"
  else
    say "WARNING: skills-library-local.patch no longer applies; library skills keep upstream text. Fix by hand."
  fi
}

CODEX_BUILD="$SETUP/codex/build-codex.sh"
rebuild_codex() { # ~/.codex/AGENTS.md and the role files' model lines, from their synced sources
  [ -d "${CODEX_HOME:-$HOME/.codex}" ] && [ -f "$CODEX_BUILD" ] || return 0
  bash "$CODEX_BUILD" >/dev/null 2>&1 || say "WARNING: could not rebuild the Codex files; run $CODEX_BUILD"
}

relink() {
  local u="$HOME/.hermes/scripts/update-skills-library.sh"
  [ -x "$u" ] && [ -d "$LIB/.git" ] || return 0
  say "skill lists changed; rebuilding skill links"
  "$u" || say "WARNING: update-skills-library.sh failed"
}

stage() {
  rebuild_codex # first, so a changed pipeline-model.toml rewrites the role files this commit picks up
  copy_in
  save_lib_patch
  write_exclude
  local spec err
  while IFS= read -r spec || [ -n "$spec" ]; do
    case "$spec" in '' | '#'*) continue ;; esac
    if ! err=$(cd "$HOME" && g add -A -- "$spec" 2>&1); then
      case "$err" in *"did not match any file"*) ;; *) die "git add '$spec' failed: $err" ;; esac
    fi
  done <"$SETUP/manifest.txt"
  check_staged
}

check_staged() {
  local f n
  g ls-files -s | awk '$1 == "120000" || $1 == "160000"' | cut -f2- | while IFS= read -r f; do
    g rm -q --cached -- "$f"
    say "skipped link or embedded repo: $f"
  done
  { g ls-files | grep -E "$DENY_RE" || true; } | while IFS= read -r f; do
    g rm -q --cached -- "$f"
    say "WARNING: never-synced path skipped: $f"
  done
  { g diff --cached --name-only --diff-filter=AM || true; } | while IFS= read -r f; do
    n=$(wc -c <"$HOME/$f" | tr -d ' ')
    [ "$n" -gt "$MAX_BYTES" ] || continue
    if g cat-file -e "HEAD:$f" 2>/dev/null; then g reset -q -- "$f"; else g rm -q --cached -- "$f"; fi
    say "WARNING: over 5 MB, not synced: $f"
  done
  n=$({ g diff --cached --name-only --diff-filter=D || true; } | wc -l | tr -d ' ')
  if [ "$n" -gt "$MAX_DELETES" ] && [ "$ALLOW_DELETES" -eq 0 ]; then
    die "$n files would be deleted from the repo. If that's intended, run again with --allow-deletes."
  fi
}

scan() {
  command -v gitleaks >/dev/null || die "gitleaks is not installed; it guards every commit against secrets (see desktop.md)."
  local tmp rc=0
  tmp=$(mktemp -d)
  { g diff --cached --name-only --diff-filter=AM -z || true; } | g checkout-index -z --stdin --prefix="$tmp/"
  if [ -n "$(ls -A "$tmp")" ]; then
    gitleaks dir "$tmp" --config "$SETUP/gitleaks.toml" --redact --no-banner -v --exit-code 7 >"$tmp.out" 2>&1 || rc=$?
  fi
  rm -rf "$tmp"
  case $rc in
    0) rm -f "$tmp.out" ;;
    7) sed "s|$tmp/||" "$tmp.out" >&2; rm -f "$tmp.out"
       die "gitleaks found what looks like a secret (above). Nothing was committed or pushed. Remove it, or for a proven false positive add a narrow allowlist to ~/.claude/setup/gitleaks.toml, then run again." ;;
    *) cat "$tmp.out" >&2; rm -f "$tmp.out"; die "gitleaks failed to run (exit $rc)." ;;
  esac
}

commit() {
  if g diff --cached --quiet; then return 0; fi
  g config user.email >/dev/null || die "git has no user.email on this machine; set Justin's identity first (desktop.md, step 3)."
  local n host
  n=$(g diff --cached --name-only | wc -l | tr -d ' ')
  host=$(hostname -s 2>/dev/null || hostname)
  { echo "sync($host): $n file(s)"; echo; g diff --cached --name-status | sed -n "1,40p"; } | g commit -q -F -
  say "committed $n file(s)"
}

do_sync() {
  [ -d "$GD" ] || die "no $GD yet: run 'sync.sh init' on the Mac, or follow desktop.md on a new machine."
  lock
  stage
  scan
  commit
  local before after changed
  before=$(g rev-parse -q --verify HEAD || true)
  if ! g fetch -q origin 2>/dev/null; then
    say "GitHub unreachable; changes are committed here and go up on the next sync."
    return 0
  fi
  if g rev-parse -q --verify refs/remotes/origin/main >/dev/null; then
    if ! (cd "$HOME" && g rebase -q --autostash refs/remotes/origin/main) >"$GD/rebase.log" 2>&1; then
      g rebase --abort >/dev/null 2>&1 || true
      cat "$GD/rebase.log" >&2
      die "CONFLICT: this machine and GitHub both changed the same file (above), or a file GitHub brings already exists here untracked. Nothing was pushed. Merge both versions by hand (keep both sides' meaning), then run sync.sh again."
    fi
    after=$(g rev-parse HEAD)
    if [ -n "$before" ] && [ "$before" != "$after" ]; then
      changed=$(g diff --name-only "$before" "$after")
      if [ -n "$changed" ]; then
        say "pulled from GitHub:"
        printf '%s\n' "$changed" | sed 's/^/  /'
        copy_out "$changed"
        if printf '%s\n' "$changed" | grep -xF .hermes/skills-library-local.patch >/dev/null; then apply_lib_patch; fi
        if printf '%s\n' "$changed" | grep -E '^\.hermes/skills-library-(keep|claude)\.txt$' >/dev/null; then relink; fi
        if printf '%s\n' "$changed" | grep -E '^\.claude/(CLAUDE\.md|setup/codex/(agents-header\.md|pipeline-model\.toml))$' >/dev/null; then rebuild_codex; fi
      fi
    fi
  fi
  [ "$CMD" = pull ] && return 0
  if [ "$(g rev-parse HEAD)" = "$(g rev-parse -q --verify refs/remotes/origin/main || true)" ]; then
    say "up to date with GitHub"
  else
    g push -q origin HEAD:refs/heads/main || die "push to GitHub failed"
    g fetch -q origin || true
    say "pushed to GitHub"
  fi
}

# Anything to sync? For the push worker: no lock, no network, no staging.
# Exit 0 when a manifest path changed (new files included), library edits differ from
# skills-library-local.patch, or this machine has commits GitHub hasn't; 1 when there's nothing.
do_changed() {
  [ -d "$GD" ] || exit 1
  local specs=() spec
  while IFS= read -r spec || [ -n "$spec" ]; do
    case "$spec" in '' | '#'*) continue ;; esac
    specs+=("$spec")
  done <"$SETUP/manifest.txt"
  # --no-optional-locks: never write the index, so a sync running at this moment can't hit index.lock
  if g --no-optional-locks status --porcelain --untracked-files=all -- "${specs[@]}" 2>/dev/null | cut -c4- | grep -vE "$DENY_RE" | grep -q .; then exit 0; fi
  if [ -d "$LIB/.git" ] && [ -n "$(git -C "$LIB" --no-optional-locks diff --name-only)" ] && ! git -C "$LIB" --no-optional-locks diff | cmp -s - "$PATCHF"; then exit 0; fi
  [ -n "$(g rev-list -1 HEAD --not --remotes=origin 2>/dev/null)" ] && exit 0
  exit 1
}

do_status() {
  [ -d "$GD" ] || die "no $GD yet: run 'sync.sh init' first."
  lock
  stage
  scan
  local n
  n=$(g diff --cached --name-only | wc -l | tr -d ' ')
  say "$n file(s) staged, checked and secret-scanned (not committed). By folder:"
  g diff --cached --name-only | awk -F/ '{ print "  " $1 "/" $2 }' | sort | uniq -c
}

do_init() {
  [ -e "$GD" ] && die "$GD already exists."
  git init -q --bare -b main "$GD"
  configure
  write_exclude
  say "created $GD. Next: 'sync.sh status' to review, then 'sync.sh' to commit and push."
}

do_links() {
  projects | while IFS=$'\t' read -r name path mem cm; do
    if [ "$mem" != "-" ]; then
      key=$(printf '%s' "$path" | sed 's/[^a-zA-Z0-9]/-/g')
      d="$HOME/.claude/projects/$key"
      if [ "$key" != "$mem" ]; then
        mkdir -p "$HOME/.claude/projects/$mem/memory"
        if [ -L "$d/memory" ]; then
          :
        elif [ -d "$d/memory" ] && [ -n "$(ls -A "$d/memory")" ]; then
          say "WARNING: $d/memory has its own notes; move them into ../$mem/memory, delete the folder, then run 'sync.sh links' again."
        else
          mkdir -p "$d"
          rmdir "$d/memory" 2>/dev/null || true
          ln -s "../$mem/memory" "$d/memory"
          say "linked $name memory -> $mem"
        fi
      fi
    fi
    src="$HOME/.claude/project-docs/$name/CLAUDE.md"
    if [ "$cm" = yes ] && [ -d "$path" ] && [ -f "$src" ]; then
      if [ ! -f "$path/CLAUDE.md" ]; then
        cp "$src" "$path/CLAUDE.md"
        say "added $path/CLAUDE.md"
      elif ! cmp -s "$src" "$path/CLAUDE.md"; then
        say "note: $path/CLAUDE.md differs from the synced copy; left as it is."
      fi
      exclude_claude_md "$path"
    fi
  done
}

do_attach() {
  [ -d "$GD" ] || die "clone first (desktop.md): GH_TOKEN=\"\$(gh auth token --user $GH_USER)\" gh repo clone $GH_USER/claude-setup ~/.claude-setup.git -- --bare"
  configure
  g fetch -q origin
  local backup
  backup="$HOME/.claude-setup-backup/$(date +%Y%m%d-%H%M%S)"
  g ls-tree -r --name-only refs/remotes/origin/main | while IFS= read -r f; do
    if [ -e "$HOME/$f" ] || [ -L "$HOME/$f" ]; then
      mkdir -p "$backup/$(dirname "$f")"
      mv "$HOME/$f" "$backup/$f"
    fi
  done
  g update-ref refs/heads/main refs/remotes/origin/main
  g symbolic-ref HEAD refs/heads/main
  (cd "$HOME" && g reset -q --hard refs/heads/main)
  write_exclude
  [ -d "$backup" ] && say "files that were already here were moved to $backup"
  apply_lib_patch
  do_links
  rebuild_codex
  say "attached: $(g ls-files | wc -l | tr -d ' ') files from GitHub are in place. Next steps: desktop.md."
}

case "$CMD" in
  init) do_init ;;
  attach) do_attach ;;
  links) do_links ;;
  status) do_status ;;
  sync | pull) do_sync ;;
  changed) do_changed ;;
esac
