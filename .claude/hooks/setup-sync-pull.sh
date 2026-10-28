#!/usr/bin/env bash
# SessionStart: runs `sync.sh pull` so every session, and the planner it sends out,
# starts from the newest setup files on GitHub (skills, CLAUDE.md, hooks, memory).
# Stopgap until the automatic sync in ~/.hermes/plans/claude-setup/setup-sync.md is
# built; that plan's own setup-sync-pull.sh replaces this file.
# The user always sees one line. The model is told only when something needs action
# (CONFLICT, a failure, a warning, GitHub unreachable) or new files arrived.
# Never blocks the session: always exits 0.
# Tests: tests/setup-sync-pull.test.sh
set -uo pipefail

SYNC=${SETUP_SYNC_SCRIPT:-$HOME/.claude/setup/sync.sh}
GD=${SETUP_SYNC_GIT_DIR:-$HOME/.claude-setup.git}

cat >/dev/null 2>&1 # the hook input isn't needed
[[ -x $SYNC && -d $GD ]] || exit 0

# Fail fast instead of hanging on a credential prompt or a stalled connection.
out=$(GIT_TERMINAL_PROMPT=0 GIT_HTTP_LOW_SPEED_LIMIT=1000 GIT_HTTP_LOW_SPEED_TIME=15 "$SYNC" pull 2>&1)
rc=$?
head=$(git --git-dir="$GD" rev-parse --short HEAD 2>/dev/null) || head='?'

emit() { # emit <line for the user> [context for the model]
  jq -nc --arg msg "$1" --arg ctx "${2-}" \
    '{systemMessage: $msg}
     + if $ctx == "" then {} else {hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}} end'
}

if [[ $out == *CONFLICT* ]]; then
  emit "Setup sync: CONFLICT pulling from GitHub, nothing was pushed. Merge it before starting work." \
    "The session-start setup sync hit a CONFLICT. Before any other work, merge both versions by hand (keep both machines' meaning, never drop the other's edit), then run ~/.claude/setup/sync.sh. Output:
$out"
elif [[ $out == *"another sync is running"* ]]; then
  emit "Setup sync: skipped, another session is syncing right now."
elif ((rc != 0)); then
  emit "Setup sync: pull FAILED (exit $rc). Setup files may be stale." \
    "The session-start setup sync failed (exit $rc), so skills and setup files may be stale. Tell the user, and get ~/.claude/setup/sync.sh pull working before planning. Output:
$out"
elif [[ $out == *"GitHub unreachable"* ]]; then
  emit "Setup sync: GitHub unreachable, using local setup files ($head)." \
    "The session-start setup sync couldn't reach GitHub, so this machine may be missing the other machine's latest setup edits. Run ~/.claude/setup/sync.sh pull again before planning."
elif [[ $out == *"pulled from GitHub"* ]]; then
  n=$(grep -c '^  ' <<<"$out")
  emit "Setup sync: pulled $n file(s) from GitHub, now at $head." \
    "The session-start setup sync pulled new setup files from GitHub (now at $head). Files already loaded this session, like CLAUDE.md, may be the old text until the next session. Output:
$out"
elif [[ $out == *WARNING* ]]; then
  emit "Setup sync: up to date with GitHub ($head), with warnings." \
    "The session-start setup sync is up to date but printed warnings. Tell the user. Output:
$out"
else
  emit "Setup sync: up to date with GitHub ($head)."
fi
exit 0
