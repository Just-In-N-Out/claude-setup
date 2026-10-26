#!/usr/bin/env bash
# Tests for ../subagent-handback-gate.sh. Run: bash ~/.claude/hooks/tests/subagent-handback-gate.test.sh
set -uo pipefail

HOOK="$(cd "$(dirname "$0")/.." && pwd)/subagent-handback-gate.sh"
fails=0

ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; fails=$((fails + 1)); }

root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
export SUBAGENT_LESSONS_STATE_DIR=$root/lessons SUBAGENT_AC_STATE_DIR=$root/ac

hand() { # hand <message> [agent_id] [tool] -> $out, $rc
  out=$(jq -nc --arg m "$1" --arg a "${2-b1}" --arg tool "${3-SubagentHandback}" \
    '{hook_event_name: "PreToolUse", session_id: "s1", tool_name: $tool, tool_input: {message: $m},
      agent_id: $a, agent_type: "general-purpose"}' | bash "$HOOK" 2>/dev/null); rc=$?
  reason=$(jq -r '.hookSpecificOutput.permissionDecisionReason // empty' <<<"$out" 2>/dev/null)
}
denied() { jq -e '.hookSpecificOutput.hookEventName == "PreToolUse"
                  and .hookSpecificOutput.permissionDecision == "deny"' <<<"$out" >/dev/null 2>&1; }
has() { grep -qF -- "$1" <<<"$reason"; }
lessons_line="MAIN SESSION: check and save these skill_lessons now."

# 1. Claude Code keeps only the first PreToolUse deny, so one deny must carry both reasons
hand "Verdict: findings"
[[ $rc == 0 ]] && denied && has "ac_status: []" && has "$lessons_line" \
  && ok "missing lessons and ac_status: one deny names both" || fail "combined: rc=$rc out=$out"
denied && [[ $(grep -c "" <<<"$out") == 1 ]] && ok "the output is a single JSON object" || fail "output lines: $out"
# the lessons reason, which sets the report's last line, comes last
[[ ${reason%%"$lessons_line"*} == *"ac_status: []"* ]] && ok "the ac_status reason comes before the lessons reason" \
  || fail "order: $reason"

# 2. both gates spent their once-only denial on that call
hand "Verdict: findings"
[[ $rc == 0 && -z $out ]] && ok "the same agent is not denied twice" || fail "second call: rc=$rc out=$out"

# 3. one gate denying alone gives just its reason
hand $'Verdict: clean\nac_status: []' b2
[[ $rc == 0 ]] && denied && has "$lessons_line" && ! has "ac_status: []" \
  && ok "only lessons missing: just the lessons reason" || fail "lessons only: rc=$rc out=$out"
hand $'Verdict: clean\nskill_lessons: []' b3
[[ $rc == 0 ]] && denied && has "ac_status: []" && ! has "$lessons_line" \
  && ok "only ac_status missing: just the ac_status reason" || fail "ac only: rc=$rc out=$out"

# 3b. at most once per gate: lessons first, then ac_status, then through
hand "Built it." b7
[[ $rc == 0 ]] && denied && has "$lessons_line" && ! has "ac_status: []" && ok "call 1 without lessons: lessons deny" \
  || fail "per-gate 1: rc=$rc out=$out"
hand $'Verdict: clean\nskill_lessons: []' b7
[[ $rc == 0 ]] && denied && has "ac_status: []" && ! has "$lessons_line" && ok "call 2 with a verdict but no ac_status: AC deny" \
  || fail "per-gate 2: rc=$rc out=$out"
hand "Verdict: clean" b7
[[ $rc == 0 && -z $out ]] && ok "call 3: both gates spent, the agent hands back" || fail "per-gate 3: rc=$rc out=$out"

# 4. nothing missing, or not a handback: no output
hand $'Built it.\nskill_lessons: []' b4
[[ $rc == 0 && -z $out ]] && ok "a complete report goes through" || fail "complete: rc=$rc out=$out"
hand "Verdict: findings" b5 Bash
[[ $rc == 0 && -z $out ]] && ok "other tools are ignored" || fail "other tool: rc=$rc out=$out"

# 5. never traps an agent
out=$(printf 'not json' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "invalid JSON is ignored" || fail "invalid JSON: rc=$rc out=$out"
out=$(jq -nc '{hook_event_name: "PreToolUse", session_id: "s1", tool_name: "SubagentHandback",
               agent_id: "b6", agent_type: "general-purpose", tool_input: {message: "Verdict: x"}}' \
      | SUBAGENT_HANDBACK_GATES="/nonexistent/gate.sh subagent-ac-gate.sh" bash "$HOOK" 2>/dev/null); rc=$?
reason=$(jq -r '.hookSpecificOutput.permissionDecisionReason // empty' <<<"$out" 2>/dev/null)
[[ $rc == 0 ]] && denied && has "ac_status: []" && ok "a missing gate is skipped; the others still run" \
  || fail "missing gate: rc=$rc out=$out"

echo
[[ $fails == 0 ]] && echo "all passed" || echo "$fails failed"
exit $((fails > 0))
