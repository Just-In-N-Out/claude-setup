#!/usr/bin/env bash
# land.sh: land a trim branch (story dream-trim, ~/.hermes/plans/claude-setup/dream-trim.md) on the setup repo's main.
#   land.sh <commit> --map <map path in the repo> [--suites all|none] [--ledger <pass-2 ledger>] [--dry-run]
# <commit> is the branch tip to land. On a scratch worktree at main's tip, it replays the branch's commits in order:
# the pass-1 commit (subject "trim: pass 1, move to references (lossless)") is never replayed but made again by the
# mover from main's own files (skipped when main already has it); every other commit is cherry-picked (skipped when
# main already has it). Then it checks the result: trim-check.py pass1 and size (the map's targets) on the new pass-1
# commit, headings, protect and pass2 (with --ledger) when a "trim: pass 2, merge duplicates" commit is included (it
# has no size target, so landing it after pass 1 checks no size), and the three suites
# (harness-guards, review-check, codex-parity: every test that passes on main must pass on the result; --suites none
# skips them, for the scratch test only). Any failure stops it with nothing merged.
# Only then does it take sync.sh's own lock ($GD/setup-sync.lock), so no sync commits and no copy_in runs while it
# lands, and, holding it for seconds: checks main has not moved, checks the touched files under $HOME have no
# uncommitted change and every touched project CLAUDE.md copy still equals its project's own file (else a session is
# mid-edit: it stops, to be rerun after the next sync), fast-forwards main (`git merge --ff-only`), copies each
# touched copy over its project's own CLAUDE.md and compares them, then releases the lock. The slow part runs before
# the lock because sync.sh clears a lock older than 10 minutes. It never stashes, resets, forces or edits a file
# another session is editing.
# Exit 0 landed (or --dry-run passed), 1 a check, conflict or dirty file stopped it, 2 usage, 3 main moved: rerun.
# Env: HOME (the setup repo's work tree), SETUP_SYNC_GIT_DIR (default $HOME/.claude-setup.git), SETUP_SYNC_PATH_COL.
set -uo pipefail

P1_SUBJECT='trim: pass 1, move to references (lossless)'
P2_SUBJECT='trim: pass 2, merge duplicates'
GD="${SETUP_SYNC_GIT_DIR:-$HOME/.claude-setup.git}"
LOCK="$GD/setup-sync.lock"
TIP= MAP= SUITES=all LEDGER= DRY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --map) MAP=${2:-}; shift 2 ;;
    --suites) SUITES=${2:-}; shift 2 ;;
    --ledger) LEDGER=${2:-}; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    -h | --help) sed -n '2,22p' "$0"; exit 0 ;;
    -*) echo "land: unknown option $1" >&2; exit 2 ;;
    *) TIP=$1; shift ;;
  esac
done
say() { echo "land: $*"; }
stop() { echo "land: STOPPED: $*" >&2; exit "${2:-1}"; }
[ -n "$TIP" ] && [ -n "$MAP" ] || { sed -n '2,3p' "$0" >&2; exit 2; }
case "$SUITES" in all | none) ;; *) stop "--suites takes all or none" 2 ;; esac
[ -z "$LEDGER" ] || [ -f "$LEDGER" ] || stop "no ledger at $LEDGER" 2
cd "$HOME" || stop "no HOME" 2
g() { git -c core.quotePath=false --git-dir="$GD" --work-tree="$HOME" "$@"; }
TIP=$(g rev-parse -q --verify "$TIP^{commit}") || stop "no commit $TIP in $GD" 2
MAIN=$(g rev-parse -q --verify refs/heads/main) || stop "no main in $GD" 2
MB=$(g merge-base "$MAIN" "$TIP") || stop "no merge base of main and $TIP" 2
COMMITS=$(g rev-list --reverse --no-merges "$MB..$TIP")
[ -n "$COMMITS" ] || stop "nothing to land: main already holds $TIP" 0

SCR=$(mktemp -d "$HOME/.cache/trim-land.XXXXXX" 2>/dev/null || { mkdir -p "$HOME/.cache" && mktemp -d "$HOME/.cache/trim-land.XXXXXX"; }) || stop "no scratch folder" 2
W="$SCR/wt" LOCKED=0
cleanup() {
  [ "$LOCKED" = 1 ] && rm -rf "$LOCK"
  for d in "$W" "$SCR/main"; do  # land.sh's own scratch worktrees; whatever is left goes with $SCR below
    [ -d "$d" ] && git --git-dir="$GD" worktree remove "$d" >/dev/null 2>&1
  done
  rm -rf "$SCR"
  git --git-dir="$GD" worktree prune >/dev/null 2>&1
}
trap cleanup EXIT
git --git-dir="$GD" worktree add -q --detach "$W" "$MAIN" >/dev/null 2>&1 || stop "can't make a scratch worktree at main"
w() { git -C "$W" -c core.quotePath=false "$@"; }
say "main $MAIN, landing $(echo "$COMMITS" | wc -l | tr -d ' ') commit(s) of $TIP"

# ---- 1. replay the branch on main's tip (no lock: nothing under $HOME changes yet)
P1NEW= P2BASE= P2NEW=
for c in $COMMITS; do
  s=$(g log -1 --format=%s "$c")
  if [ "$s" = "$P1_SUBJECT" ]; then
    # grep without -q in pipes here: under pipefail, grep -q's early exit can fail the writer with SIGPIPE
    if g log --format=%s "$MB..$MAIN" | grep -xF "$P1_SUBJECT" >/dev/null; then say "skip $c (main already has pass 1)"; continue; fi
    [ -f "$W/$MAP" ] || stop "map $MAP is not in the tree (the tool commit must come first)"
    python3 -B "$W/.claude/setup/trim/move-to-references.py" --map "$W/$MAP" --root "$W" | sed 's/^/land:   /'
    [ "${PIPESTATUS[0]}" = 0 ] || stop "the mover refused main's files (an anchor changed?); nothing merged"
    paths=$(python3 -B -c 'import json,sys
m = json.load(open(sys.argv[1], encoding="utf-8"))
print("\n".join(sorted({e["path"] for e in m["files"]} | {g["target"] for e in m["files"] for g in e["groups"]})))' "$W/$MAP")
    # shellcheck disable=SC2086
    (IFS=$'\n'; w add -A -- $paths) || stop "git add failed"
    g log -1 --format=%B "$c" | w commit -q -F - || stop "could not commit pass 1"
    P1NEW=$(w rev-parse HEAD)
    say "pass 1 made again on main's files: $P1NEW"
    continue
  fi
  if [ -z "$(g cherry "$MAIN" "$c" "$c^" | grep '^+')" ]; then say "skip $c (main already has it)"; continue; fi
  [ "$s" = "$P2_SUBJECT" ] && P2BASE=$(w rev-parse HEAD)
  if ! w cherry-pick "$c" >/dev/null 2>&1; then
    if [ -z "$(w ls-files -u)" ] && w diff --cached --quiet; then
      w cherry-pick --skip >/dev/null 2>&1; say "skip $c (already in main)"; P2BASE=; continue
    fi
    w cherry-pick --abort >/dev/null 2>&1
    stop "$c ($s) conflicts with main; nothing merged"
  fi
  say "cherry-picked $c ($s)"
  [ "$s" = "$P2_SUBJECT" ] && P2NEW=$(w rev-parse HEAD)
done
NEW=$(w rev-parse HEAD)
[ "$NEW" != "$MAIN" ] || stop "nothing to land: every commit is already in main" 0

# ---- 2. checks on the result (still no lock)
CK="$W/.claude/setup/trim/trim-check.py"
[ -f "$CK" ] || stop "no trim-check.py in the result"
export_to() { mkdir -p "$SCR/$2" && w archive "$1" | tar -x -C "$SCR/$2"; }
fail=0
run_check() { # run_check <name> <what passing means> <command…>
  local name=$1 ok=$2 rc
  shift 2
  "$@" >"$SCR/check.out" 2>&1; rc=$?
  head -n 20 "$SCR/check.out" | sed 's/^/land:   /'
  if [ "$rc" = 0 ]; then say "check $name: $ok"; else say "check $name: FAILED"; fail=1; fi
}
export_to "$MAIN" t-main && export_to "$NEW" t-new || stop "could not export the trees"
if [ -n "$P1NEW" ]; then
  export_to "$P1NEW^" t-p1base && export_to "$P1NEW" t-p1 || stop "could not export pass 1"
  run_check pass1 "lossless" python3 -B "$CK" pass1 --map "$W/$MAP" --base "$SCR/t-p1base" --head "$SCR/t-p1"
  # the map's size targets are pass 1's (AC2): they bind the pass-1 commit made here, whatever a pass 2 in the same
  # landing cuts; pass 2 has no size target, so a landing without pass 1 has no size check
  sizes=$(python3 -B -c 'import json,sys
for e in json.load(open(sys.argv[1], encoding="utf-8"))["files"]:
    print(e["path"] + "=" + str(e["max_chars"]) if "max_chars" in e else e["path"])' "$W/$MAP")
  IFS=$'\n' read -r -d '' -a SIZES <<<"$sizes"
  run_check size "every file under its target" python3 -B "$CK" size --root "$SCR/t-p1" "${SIZES[@]}"
else
  say "check size: skipped (main already has pass 1; the size targets are pass 1's, pass 2 has none)"
fi
run_check headings "every heading kept, every pointer resolves" \
  python3 -B "$CK" headings --map "$W/$MAP" --base "$SCR/t-main" --head "$SCR/t-new"
if [ -n "$P2NEW" ]; then
  [ -n "$LEDGER" ] || stop "a pass-2 commit needs --ledger <pass2-ledger.md>" 2
  export_to "$P2BASE" t-p2base && export_to "$P2NEW" t-p2 || stop "could not export pass 2"
  run_check protect "every protected line intact" \
    python3 -B "$CK" protect --map "$W/$MAP" --root "$SCR/t-p2base" --check "$SCR/t-p2"
  run_check pass2 "every removal has its ledger row" \
    python3 -B "$CK" pass2 --map "$W/$MAP" --base "$SCR/t-p2base" --head "$SCR/t-p2" --ledger "$LEDGER"
fi
if [ "$SUITES" = all ]; then
  git --git-dir="$GD" worktree add -q --detach "$SCR/main" "$MAIN" >/dev/null 2>&1 || stop "can't make a worktree at main for the suites"
  for side in main wt; do
    d="$SCR/$side"; [ "$side" = wt ] && d="$W"
    for s in .claude/hooks/tests/harness-guards.test.sh \
             .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh \
             .claude/setup/codex/codex-parity.test.sh; do
      n=$(basename "$s" .test.sh)
      mkdir -p "$SCR/tmp-$side-$n"
      (cd "$d" && TMPDIR="$SCR/tmp-$side-$n" HARNESS_GUARDS_TEST_ROOT="$SCR/hg-$side" CODEX_PARITY_TEST_ROOT="$SCR/cp-$side" \
        bash "$s") >"$SCR/$side-$n.log" 2>&1
      grep -E '^(ok|not ok) [0-9]+ - ' "$SCR/$side-$n.log" | sed -E "s/^(ok|not ok) [0-9]+ - (.*)$/$n\t\2\t\1/" >>"$SCR/pins-$side.txt"
    done
  done
  awk -F'\t' 'NR == FNR { h[$1 FS $2] = $3; next } $3 == "ok" { k = $1 FS $2; if (h[k] == "ok") n++; else { print "land:   " $1 " " $2 " passes on main, not on the result"; bad = 1 } }
    END { print "land:   " n " tests that pass on main pass on the result"; exit bad }' "$SCR/pins-wt.txt" "$SCR/pins-main.txt" \
    && say "check suites: no test that passes on main fails" || { say "check suites: FAILED"; fail=1; }
else
  say "check suites: skipped (--suites none)"
fi
[ "$fail" = 0 ] || stop "a check failed; nothing merged"
[ "$DRY" = 1 ] && { say "dry run: every check passed on $NEW; nothing merged"; exit 0; }

# ---- 3. land, holding sync.sh's lock for seconds
if ! mkdir "$LOCK" 2>/dev/null; then stop "another sync is running ($LOCK); try again in a minute. Nothing merged."; fi
LOCKED=1
[ "$(g rev-parse refs/heads/main)" = "$MAIN" ] || stop "main moved while landing; rerun land.sh. Nothing merged." 3
[ "$(g symbolic-ref -q HEAD)" = refs/heads/main ] || stop "$GD's HEAD is not main"
touched=$(g diff --name-only "$MAIN" "$NEW")
dirty=$(printf '%s\n' "$touched" | while IFS= read -r p; do [ -n "$p" ] && g status --porcelain -- "$p"; done)
[ -z "$dirty" ] || stop "uncommitted changes to files this lands (another session is mid-edit; rerun after its sync):
$dirty"
case "$(uname -s)" in Darwin) COL=2 ;; *) COL=3 ;; esac
COL=${SETUP_SYNC_PATH_COL:-$COL}
PROJ=$(awk -F'\t' -v c="$COL" '!/^#/ && NF >= 5 && $5 == "yes" { print $1 "\t" $c }' "$HOME/.claude/setup/projects.tsv" 2>/dev/null |
  while IFS=$'\t' read -r name path; do
    printf '%s\n' "$touched" | grep -xF ".claude/project-docs/$name/CLAUDE.md" >/dev/null && printf '%s\t%s\n' "$name" "$path"
  done)
while IFS=$'\t' read -r name path; do
  [ -n "$name" ] || continue
  [ ! -f "$path/CLAUDE.md" ] || cmp -s "$path/CLAUDE.md" "$HOME/.claude/project-docs/$name/CLAUDE.md" \
    || stop "$path/CLAUDE.md differs from its synced copy (a session edited it since the last sync): run sync.sh, then land again"
done <<<"$PROJ"
g merge -q --ff-only "$NEW" || stop "git merge --ff-only refused; nothing merged"
say "main fast-forwarded to $NEW"
while IFS=$'\t' read -r name path; do
  [ -n "$name" ] && [ -d "$path" ] || continue
  if [ -f "$path/CLAUDE.md" ]; then # a session may have written it during the merge: only overwrite main's old copy
    g show "$MAIN:.claude/project-docs/$name/CLAUDE.md" >"$SCR/old-copy" 2>/dev/null && cmp -s "$SCR/old-copy" "$path/CLAUDE.md" \
      || stop "main is landed, but $path/CLAUDE.md changed while landing, so it was left as it is: put the session's edit into ~/.claude/project-docs/$name/CLAUDE.md by hand, then copy that over it before the next sync"
  fi
  cp "$HOME/.claude/project-docs/$name/CLAUDE.md" "$path/CLAUDE.md" \
    && cmp -s "$HOME/.claude/project-docs/$name/CLAUDE.md" "$path/CLAUDE.md" \
    || stop "main is landed but $path/CLAUDE.md could not be updated: copy ~/.claude/project-docs/$name/CLAUDE.md over it before the next sync"
  say "updated $path/CLAUDE.md (equals the trimmed copy)"
done <<<"$PROJ"
say "landed $NEW; run ~/.claude/setup/sync.sh to push it"
