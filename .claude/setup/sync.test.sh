#!/usr/bin/env bash
# Tests ~/.claude/setup/sync.sh with two fake homes ("mac", "desk") and a local bare remote.
# Touches nothing real: no ~/.claude-setup.git, no GitHub. Needs git, gitleaks, a git identity.
#   bash ~/.claude/setup/sync.test.sh   -> "passed N, failed 0"
set -uo pipefail
SYNC="$HOME/.claude/setup/sync.sh"
REAL_SETUP="$HOME/.claude/setup"
S=$(mktemp -d "${TMPDIR:-/tmp}/sync-test.XXXX")
R="$S/remote.git"; A="$S/mac"; B="$S/desk"
git init -q --bare -b main "$R"; mkdir -p "$A" "$B"; cp ~/.gitconfig "$A/.gitconfig"; cp ~/.gitconfig "$B/.gitconfig"
pass=0; fail=0
ok() { if eval "$2"; then echo "ok - $1"; pass=$((pass+1)); else echo "NOT OK - $1"; fail=$((fail+1)); fi; }
runA() { mkdir -p "$A/proj"; cd "$A/proj"; HOME="$A" SETUP_SYNC_URL="$R" SETUP_SYNC_PATH_COL=2 bash "$SYNC" "$@"; }
runB() { mkdir -p "$B/proj"; cd "$B/proj"; HOME="$B" SETUP_SYNC_URL="$R" SETUP_SYNC_PATH_COL=3 bash "$SYNC" "$@"; }
tree() { git --git-dir="$R" ls-tree -r --name-only main; }

# --- fake Mac home
mkdir -p "$A/.claude/setup" "$A/.claude/hooks/tests" "$A/.claude/projects/-mac-proj/memory" \
  "$A/.hermes/skills/sd/foo" "$A/.hermes/skills/codex-imports" "$A/.hermes/plans/p/evidence" \
  "$A/.hermes/plans/p/private" "$A/.hermes/plans/p/briefs" "$A/.hermes/memories" "$A/proj" "$S/lib/bar"
cp "$REAL_SETUP"/{manifest.txt,exclude.txt,gitleaks.toml,sync.sh} "$A/.claude/setup/"
printf '# t\nalpha\t%s\t%s\t%s\tyes\n' "$A/proj" "$B/proj" "-mac-proj" > "$A/.claude/setup/projects.tsv"
echo "global rules" > "$A/.claude/CLAUDE.md"; echo '{}' > "$A/.claude/settings.json"
echo 'echo hi' > "$A/.claude/hooks/h.sh"; echo t > "$A/.claude/hooks/tests/h.test.sh"
echo "mem note" > "$A/.claude/projects/-mac-proj/memory/MEMORY.md"
ln -s ../-mac-proj/memory "$A/.claude/projects/-other/memory" 2>/dev/null || { mkdir -p "$A/.claude/projects/-other"; ln -s ../-mac-proj/memory "$A/.claude/projects/-other/memory"; }
echo "skill v1" > "$A/.hermes/skills/sd/foo/SKILL.md"
echo "x: 1" > "$A/.hermes/skills/sd/foo/config.yaml"
echo '{}' > "$A/.hermes/skills/.usage.json"
ln -s "$S/lib/bar" "$A/.hermes/skills/codex-imports/bar"
echo "plan" > "$A/.hermes/plans/p/plan.md"; echo "brief" > "$A/.hermes/plans/p/briefs/b.md"
echo "ev" > "$A/.hermes/plans/p/evidence/e.md"; echo "pv" > "$A/.hermes/plans/p/private/x.md"
echo "SECRET=1" > "$A/.hermes/.env"; echo "soul" > "$A/.hermes/SOUL.md"; echo m > "$A/.hermes/memories/MEMORY.md"
echo "project rules v1" > "$A/proj/CLAUDE.md"

echo "== init + first sync (A)"
runA init >/dev/null
runA status | tail -3
runA
T=$(tree)
ok "skill synced" 'grep -qx .hermes/skills/sd/foo/SKILL.md <<<"$T"'
ok "CLAUDE.md, settings, hook, test, memory synced" 'grep -qx .claude/CLAUDE.md <<<"$T" && grep -qx .claude/settings.json <<<"$T" && grep -qx .claude/hooks/h.sh <<<"$T" && grep -qx .claude/hooks/tests/h.test.sh <<<"$T" && grep -qx .claude/projects/-mac-proj/memory/MEMORY.md <<<"$T"'
ok "plan + brief synced" 'grep -qx .hermes/plans/p/plan.md <<<"$T" && grep -qx .hermes/plans/p/briefs/b.md <<<"$T"'
ok "project CLAUDE.md copied in" 'grep -qx .claude/project-docs/alpha/CLAUDE.md <<<"$T"'
ok "no evidence/private/.env/.usage/config.yaml" '! grep -qE "evidence/|private/|\.env|\.usage\.json|config\.yaml" <<<"$T"'
ok "no symlinks in repo" '! grep -qE "codex-imports/bar|-other/memory" <<<"$T" && [ -z "$(git --git-dir="$R" ls-tree -r main | awk "\$1==\"120000\"")" ]'
ok "author is the personal identity" '[ "$(git --git-dir="$R" log -1 --format=%ae main)" = "$(git config --global user.email)" ]'

echo "== one commit with 1500 long-named files"
mkdir -p "$A/.hermes/skills/sd/a-rather-long-folder-name-to-make-the-commit-listing-bigger"; for i in $(seq 1 1500); do echo "n$i" > "$A/.hermes/skills/sd/a-rather-long-folder-name-to-make-the-commit-listing-bigger/note-number-$i.md"; done
runA >/dev/null 2>&1; rc=$?
ok "1500-file commit is pushed (rc=$rc)" '[ $rc -eq 0 ] && tree | grep note-number-1500.md >/dev/null'

echo "== secret gate"
# the fake key is assembled at runtime so this file itself passes the secret scan
printf 'aws_access_key_id = %s%s\n' AKIA Z7XQ3MLP4RTW2KD5 > "$A/.hermes/skills/sd/foo/leak.md"
printf 'aws_secret_access_key = %s%s\n' Zx9pQ2rT7vW1yB4n M8kL3jH6gF5dS0aQwErTyUiO >> "$A/.hermes/skills/sd/foo/leak.md"
before=$(git --git-dir="$R" rev-parse main)
runA >/dev/null 2>"$S/leak.err"; rc=$?
ok "secret blocks the sync (rc=$rc)" '[ $rc -ne 0 ] && grep -q "gitleaks found" "$S/leak.err"'
ok "nothing pushed" '[ "$(git --git-dir="$R" rev-parse main)" = "$before" ]'
ok "nothing committed locally" '[ "$(git --git-dir="$A/.claude-setup.git" rev-parse main)" = "$before" ]'
rm "$A/.hermes/skills/sd/foo/leak.md"
runA >/dev/null 2>&1

echo "== big file"
head -c 6000000 /dev/zero | tr '\0' a > "$A/.hermes/skills/sd/foo/big.md"
runA >/dev/null 2>&1
ok "over-5MB file not synced" '! tree | grep big.md >/dev/null'
rm "$A/.hermes/skills/sd/foo/big.md"

echo "== attach on fresh desktop home (B)"
mkdir -p "$B/.claude" "$B/proj/.git/info"
echo '{"desktop":true}' > "$B/.claude/settings.json"
git clone -q --bare "$R" "$B/.claude-setup.git"
runB attach
ok "files checked out" '[ "$(cat "$B/.hermes/skills/sd/foo/SKILL.md")" = "skill v1" ]'
ok "existing settings.json backed up" 'ls "$B"/.claude-setup-backup/*/.claude/settings.json >/dev/null 2>&1 && [ "$(cat "$B/.claude/settings.json")" = "{}" ]'
KEY=$(printf '%s' "$B/proj" | sed 's/[^a-zA-Z0-9]/-/g')
ok "desktop memory linked to Mac memory" '[ -L "$B/.claude/projects/$KEY/memory" ] && [ "$(cat "$B/.claude/projects/$KEY/memory/MEMORY.md")" = "mem note" ]'
ok "project CLAUDE.md written + excluded" '[ "$(cat "$B/proj/CLAUDE.md")" = "project rules v1" ] && grep -qx CLAUDE.md "$B/proj/.git/info/exclude"'
ok "no .env checked out" '[ ! -e "$B/.hermes/.env" ]'

echo "== desktop edit reaches Mac"
echo "skill v2 from desktop" > "$B/.hermes/skills/sd/foo/SKILL.md"
echo "desk note" >> "$B/.claude/projects/$KEY/memory/MEMORY.md"
echo "project rules v2" > "$B/proj/CLAUDE.md"
runB >/dev/null
runA pull
ok "skill change arrived on Mac" '[ "$(cat "$A/.hermes/skills/sd/foo/SKILL.md")" = "skill v2 from desktop" ]'
ok "memory note written through link arrived" 'grep -q "desk note" "$A/.claude/projects/-mac-proj/memory/MEMORY.md"'
ok "project CLAUDE.md copied out on Mac" '[ "$(cat "$A/proj/CLAUDE.md")" = "project rules v2" ]'
ok "desktop link not committed" '! tree | grep -- "$KEY" >/dev/null'

echo "== Mac edit reaches desktop"
echo "skill v3 from mac" > "$A/.hermes/skills/sd/foo/SKILL.md"
runA >/dev/null
runB pull >/dev/null
ok "Mac change arrived on desktop" '[ "$(cat "$B/.hermes/skills/sd/foo/SKILL.md")" = "skill v3 from mac" ]'

echo "== conflict"
echo "mac side" > "$A/.claude/CLAUDE.md"; echo "desk side" > "$B/.claude/CLAUDE.md"
runA >/dev/null
before=$(git --git-dir="$R" rev-parse main)
runB >/dev/null 2>"$S/conf.err"; rc=$?
ok "conflict stops the sync" '[ $rc -ne 0 ] && grep -q CONFLICT "$S/conf.err"'
ok "nothing pushed on conflict" '[ "$(git --git-dir="$R" rev-parse main)" = "$before" ]'
ok "desktop file kept its own text" '[ "$(cat "$B/.claude/CLAUDE.md")" = "desk side" ]'
ok "no rebase left half-done" '[ ! -d "$B/.claude-setup.git/rebase-merge" ] && [ ! -d "$B/.claude-setup.git/rebase-apply" ]'
ok "lock released" '[ ! -d "$B/.claude-setup.git/setup-sync.lock" ]'

echo "== deletions"
echo "deleted on desktop" >/dev/null; rm "$A/.hermes/plans/p/plan.md"
runA >/dev/null 2>&1
ok "a deletion syncs" '! tree | grep -x .hermes/plans/p/plan.md >/dev/null'

echo; echo "passed $pass, failed $fail"; rm -rf "$S"
[ "$fail" -eq 0 ]
