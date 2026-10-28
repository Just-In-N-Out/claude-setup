#!/usr/bin/env bash
# Tests for ../setup-sync-pull.sh. Run: bash ~/.claude/hooks/tests/setup-sync-pull.test.sh
set -uo pipefail

HOOK="$(cd "$(dirname "$0")/.." && pwd)/setup-sync-pull.sh"
fails=0

ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; fails=$((fails + 1)); }

root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
git init -q --bare "$root/setup.git"
export SETUP_SYNC_GIT_DIR=$root/setup.git SETUP_SYNC_SCRIPT=$root/sync.sh

stub() { # stub <exit code> <output>: a fake sync.sh that prints <output>
  printf '#!/usr/bin/env bash\n[ "$1" = pull ] || exit 9\ncat <<'"'"'EOF'"'"'\n%s\nEOF\nexit %s\n' "$2" "$1" >"$SETUP_SYNC_SCRIPT"
  chmod +x "$SETUP_SYNC_SCRIPT"
}
run() { # -> $out, $rc, $msg, $ctx
  out=$(echo '{"hook_event_name":"SessionStart","source":"startup"}' | bash "$HOOK" 2>/dev/null); rc=$?
  msg=$(jq -r '.systemMessage // empty' <<<"$out" 2>/dev/null)
  ctx=$(jq -r '.hookSpecificOutput.additionalContext // empty' <<<"$out" 2>/dev/null)
}

# 1. up to date: one line for the user, nothing for the model
stub 0 ""
run
[[ $rc == 0 && $msg == "Setup sync: up to date with GitHub"* && -z $ctx ]] \
  && ok "up to date: user line only" || fail "up to date: rc=$rc out=$out"

# 2. files pulled: counted for the user, listed for the model
stub 0 $'setup-sync: pulled from GitHub:\n  .claude/CLAUDE.md\n  .hermes/skills/a/SKILL.md'
run
[[ $rc == 0 && $msg == *"pulled 2 file(s)"* && $ctx == *".hermes/skills/a/SKILL.md"* ]] \
  && ok "pulled: count and file list" || fail "pulled: rc=$rc out=$out"

# 3. conflict: flagged to both, with the merge rule
stub 1 "setup-sync: CONFLICT: this machine and GitHub both changed the same file (above)"
run
[[ $rc == 0 && $msg == *CONFLICT* && $ctx == *"keep both machines' meaning"* ]] \
  && ok "conflict: exits 0 and tells the model to merge" || fail "conflict: rc=$rc out=$out"

# 4. another session holds the lock: quiet skip, not a failure
stub 1 "setup-sync: another sync is running (/x/setup-sync.lock); try again in a minute."
run
[[ $rc == 0 && $msg == *"skipped, another session"* && -z $ctx ]] \
  && ok "lock held: quiet skip" || fail "lock: rc=$rc out=$out"

# 5. any other failure (e.g. the secret scan): flagged as stale
stub 1 "setup-sync: gitleaks found what looks like a secret (above)."
run
[[ $rc == 0 && $msg == *"FAILED (exit 1)"* && $ctx == *gitleaks* ]] \
  && ok "failure: exits 0, says stale, passes the output" || fail "failure: rc=$rc out=$out"

# 6. offline
stub 0 "setup-sync: GitHub unreachable; changes are committed here and go up on the next sync."
run
[[ $rc == 0 && $msg == *"GitHub unreachable"* && $ctx == *"pull again"* ]] \
  && ok "offline: says so and asks for a later pull" || fail "offline: rc=$rc out=$out"

# 7. warnings on an otherwise clean pull reach the model
stub 0 "setup-sync: WARNING: over 5 MB, not synced: big.bin"
run
[[ $rc == 0 && $msg == *"with warnings"* && $ctx == *"big.bin"* ]] \
  && ok "warning: passed to the model" || fail "warning: rc=$rc out=$out"

# 8. no setup repo on this machine: silent
SETUP_SYNC_GIT_DIR=$root/missing.git run
[[ $rc == 0 && -z $out ]] && ok "no setup repo: silent" || fail "no repo: rc=$rc out=$out"

echo
((fails == 0)) && echo "all passed" || { echo "$fails failed"; exit 1; }
