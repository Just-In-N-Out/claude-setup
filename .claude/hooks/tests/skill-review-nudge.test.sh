#!/usr/bin/env bash
# Tests for ../skill-review-nudge.sh. Run: bash ~/.claude/hooks/tests/skill-review-nudge.test.sh
set -uo pipefail

HOOK="$(cd "$(dirname "$0")/.." && pwd)/skill-review-nudge.sh"
export SKILL_NUDGE_STATE_DIR
SKILL_NUDGE_STATE_DIR=$(mktemp -d)
trap 'rm -rf "$SKILL_NUDGE_STATE_DIR"' EXIT
fails=0
# unique per run, so a stray file from an older run can't fake a path-escape failure
EVIL="evil-$$-$RANDOM"

ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; fails=$((fails + 1)); }

# fire <event> <session> [agent_id] -> prints hook stdout; exit code in $rc
fire() {
  local input
  input=$(jq -nc --arg e "$1" --arg s "$2" --arg a "${3:-}" \
    '{hook_event_name: $e, session_id: $s} + (if $a == "" then {} else {agent_id: $a} end)')
  out=$(printf '%s' "$input" | bash "$HOOK")
  rc=$?
}

# fire_n <n> <event> <session> -> number of calls that printed something
fire_n() {
  local i hits=0
  for ((i = 1; i <= $1; i++)); do
    fire "$2" "$3"
    [[ -n $out ]] && hits=$((hits + 1))
  done
  echo "$hits"
}

# 1. default: silent for 14 tool calls, nudges on the 15th
hits=$(fire_n 14 PostToolUse s1)
[[ $hits == 0 ]] && ok "no nudge before 15 tool calls" || fail "nudged early ($hits times in 14 calls)"
fire PostToolUse s1
if [[ $rc == 0 ]] \
  && jq -e '.hookSpecificOutput.hookEventName == "PostToolUse"
            and (.hookSpecificOutput.additionalContext | test("SKILL.md"))
            and (.hookSpecificOutput.additionalContext | test("search the skill first"))
            and (.hookSpecificOutput.additionalContext | test("rather than appending"))' <<<"$out" >/dev/null 2>&1; then
  ok "15th tool call returns a PostToolUse nudge naming SKILL.md, saving only what's new by editing lines"
else
  fail "15th tool call: rc=$rc out=$out"
fi

# 2. keeps going: next nudge on the 30th
hits=$(fire_n 15 PostToolUse s1)
[[ $hits == 1 ]] && ok "exactly one more nudge by tool call 30" || fail "expected 1 nudge in calls 16-30, got $hits"

# 3. user messages: nudge on the 10th, as a UserPromptSubmit nudge
hits=$(fire_n 9 UserPromptSubmit s2)
fire UserPromptSubmit s2
if [[ $hits == 0 ]] && jq -e '.hookSpecificOutput.hookEventName == "UserPromptSubmit"' <<<"$out" >/dev/null 2>&1; then
  ok "10th user message nudges, not before"
else
  fail "user messages: early=$hits out=$out"
fi

# 4. subagents get their own nudge: note lessons for the report, never edit skills
first=0
for ((i = 1; i <= 15; i++)); do fire PostToolUse s3 agent-123; [[ -n $out && $first == 0 ]] && first=$i; done
if [[ $first == 15 && $rc == 0 ]] \
  && jq -e '.hookSpecificOutput.hookEventName == "PostToolUse"
            and (.hookSpecificOutput.additionalContext | test("skill_lessons"))
            and (.hookSpecificOutput.additionalContext | test("do not edit"))
            and (.hookSpecificOutput.additionalContext | test("normal answer"))' <<<"$out" >/dev/null 2>&1; then
  ok "subagent's 15th tool call nudges it to note skill_lessons, not edit skills, empty being normal"
else
  fail "subagent nudge: first at call $first, rc=$rc out=$out"
fi
hits=$(fire_n 14 PostToolUse s3)
[[ $hits == 0 ]] && ok "subagent calls do not advance the main counter" || fail "subagent calls were counted"
hits=0
for ((i = 1; i <= 14; i++)); do fire PostToolUse s3 agent-456; [[ -n $out ]] && hits=$((hits + 1)); done
[[ $hits == 0 ]] && ok "each subagent has its own counter" || fail "subagent counters leaked ($hits nudges)"
fire UserPromptSubmit s3 agent-123
[[ $rc == 0 && -z $out ]] && ok "subagent prompts never nudge" || fail "subagent prompt: rc=$rc out=$out"
# the first component must exist, or the OS refuses the path even with the
# sanitizer deleted and this test could never fail (mutation-testing-discipline #12)
mkdir -p "$SKILL_NUDGE_STATE_DIR/s9.x"
for ((i = 1; i <= 15; i++)); do fire PostToolUse s9 "x/../../$EVIL"; done
[[ $rc == 0 && ! -e "$SKILL_NUDGE_STATE_DIR/../$EVIL.tools" ]] \
  && ok "agent_id cannot escape the state folder" || fail "path escape via agent_id"

# 5. sessions keep separate counters
hits=$(fire_n 14 PostToolUse s4)
fire PostToolUse s5
[[ $hits == 0 && -z $out ]] && ok "sessions counted separately" || fail "session counters leaked"

# 6. interval is configurable
hits=$(SKILL_NUDGE_TOOLS=3 fire_n 6 PostToolUse s6)
[[ $hits == 2 ]] && ok "SKILL_NUDGE_TOOLS=3 nudges every 3rd call" || fail "custom interval: $hits nudges in 6 calls"

# 7. bad input never breaks the session: exit 0, no output
fire PostToolUse ""
[[ $rc == 0 && -z $out ]] && ok "missing session_id is ignored" || fail "missing session_id: rc=$rc out=$out"
fire SessionStart s7
[[ $rc == 0 && -z $out ]] && ok "other events are ignored" || fail "other event: rc=$rc out=$out"
out=$(printf 'not json' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "invalid JSON is ignored" || fail "invalid JSON: rc=$rc out=$out"
echo garbage >"$SKILL_NUDGE_STATE_DIR/s8.tools"
fire PostToolUse s8
[[ $rc == 0 && -z $out && $(cat "$SKILL_NUDGE_STATE_DIR/s8.tools") == 1 ]] \
  && ok "corrupt counter restarts at 1" || fail "corrupt counter: rc=$rc out=$out"
fire PostToolUse "../../$EVIL"
[[ $rc == 0 && ! -e "$SKILL_NUDGE_STATE_DIR/../../$EVIL.tools" ]] \
  && ok "session_id cannot escape the state folder" || fail "path escape via session_id"

echo
[[ $fails == 0 ]] && echo "all passed" || echo "$fails failed"
exit $((fails > 0))
