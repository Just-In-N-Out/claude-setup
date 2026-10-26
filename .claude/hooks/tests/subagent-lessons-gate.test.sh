#!/usr/bin/env bash
# Tests for ../subagent-lessons-gate.sh. Run: bash ~/.claude/hooks/tests/subagent-lessons-gate.test.sh
set -uo pipefail

HOOK="$(cd "$(dirname "$0")/.." && pwd)/subagent-lessons-gate.sh"
fails=0

ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; fails=$((fails + 1)); }

# stop <message> [stop_hook_active] [agent_type] [event] -> hook stdout in $out, exit code in $rc
stop() {
  local input
  input=$(jq -nc --arg m "$1" --argjson active "${2:-false}" --arg t "${3:-general-purpose}" \
    --arg e "${4:-SubagentStop}" \
    '{hook_event_name: $e, session_id: "s1", agent_id: "a1", agent_type: $t,
      stop_hook_active: $active, last_assistant_message: $m}')
  out=$(printf '%s' "$input" | bash "$HOOK" 2>/dev/null)
  rc=$?
}

blocked() {
  jq -e '.decision == "block"
         and (.reason | test("skill_lessons"))
         and (.reason | test("[Dd]o not edit"))
         and (.reason | test("MAIN SESSION: check and save these skill_lessons now"))
         and (.reason | test("complete final report"))
         and (.reason | test("normal answer"))' <<<"$out" >/dev/null 2>&1
}

# 1. a report without lessons is sent back once, with the full instruction
stop "Done. Built the thing; all gates green."
[[ $rc == 0 ]] && blocked && ok "report without skill_lessons is sent back" \
  || fail "missing lessons: rc=$rc out=$out"

# 2. a report that lists lessons (even none) finishes
stop $'Report.\n\nskill_lessons: []'
[[ $rc == 0 && -z $out ]] && ok "skill_lessons: [] lets the agent finish" || fail "empty list: rc=$rc out=$out"
stop $'Report.\n\n## Skill lessons\n- leorna: gotcha X (evidence: log Y)'
[[ $rc == 0 && -z $out ]] && ok "a Skill lessons heading lets the agent finish" || fail "heading: rc=$rc out=$out"
stop $'{"status":"ready","skill_lessons":[{"skill":"leorna","lesson":"x","evidence":"y"}]}'
[[ $rc == 0 && -z $out ]] && ok "a JSON skill_lessons field lets the agent finish" || fail "json field: rc=$rc out=$out"

# 3. sent back at most once: a stop that is already continuing from this hook finishes
stop "Done, still no lessons." true
[[ $rc == 0 && -z $out ]] && ok "stop_hook_active=true is never blocked again" || fail "loop guard: rc=$rc out=$out"

# 4. skipped agent types finish without lessons
stop "Status line set." false statusline-setup
[[ $rc == 0 && -z $out ]] && ok "statusline-setup is skipped by default" || fail "default skip: rc=$rc out=$out"
out=$(jq -nc '{hook_event_name: "SubagentStop", stop_hook_active: false, agent_type: "Explore",
               last_assistant_message: "found it"}' | SUBAGENT_LESSONS_SKIP="Plan Explore" bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "SUBAGENT_LESSONS_SKIP adds skipped types" || fail "custom skip: rc=$rc out=$out"
stop "found it" false Explore
[[ $rc == 0 ]] && blocked && ok "other agent types (Explore) are gated" || fail "Explore not gated: rc=$rc out=$out"

# 5. only SubagentStop is gated
stop "no lessons" false general-purpose Stop
[[ $rc == 0 && -z $out ]] && ok "main-session Stop is ignored" || fail "Stop event: rc=$rc out=$out"
stop "no lessons" false general-purpose PostToolUse
[[ $rc == 0 && -z $out ]] && ok "PostToolUse is ignored" || fail "PostToolUse event: rc=$rc out=$out"

# 6. bad input never traps an agent: exit 0, no output
out=$(printf 'not json' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "invalid JSON is ignored" || fail "invalid JSON: rc=$rc out=$out"
out=$(jq -nc '{hook_event_name: "SubagentStop", stop_hook_active: false, agent_type: "general-purpose"}' \
  | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "missing last_assistant_message is ignored" || fail "no message: rc=$rc out=$out"
out=$(printf '' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "empty input is ignored" || fail "empty input: rc=$rc out=$out"

# 7. background agents hand back with a SubagentHandback tool call, and their SubagentStop
#    input has no last_assistant_message (seen live 2026-10-23); a block there comes after
#    the report is delivered and the agent never runs again. So the gate is PreToolUse on
#    SubagentHandback: deny it once per agent when the message has no lessons.
export SUBAGENT_LESSONS_STATE_DIR
SUBAGENT_LESSONS_STATE_DIR=$(mktemp -d)
trap 'rm -rf "$SUBAGENT_LESSONS_STATE_DIR"' EXIT
hand() { # hand <message> [agent_id] [tool] [agent_type]
  out=$(jq -nc --arg m "$1" --arg a "${2-b1}" --arg tool "${3-SubagentHandback}" --arg t "${4-Explore}" \
    '{hook_event_name: "PreToolUse", session_id: "s1", tool_name: $tool, tool_input: {message: $m}}
     + (if $a == "" then {} else {agent_id: $a, agent_type: $t} end)' | bash "$HOOK" 2>/dev/null); rc=$?
}
denied() {
  jq -e '.hookSpecificOutput.hookEventName == "PreToolUse"
         and .hookSpecificOutput.permissionDecision == "deny"
         and (.hookSpecificOutput.permissionDecisionReason | test("skill_lessons"))
         and (.hookSpecificOutput.permissionDecisionReason | test("[Dd]o not edit"))
         and (.hookSpecificOutput.permissionDecisionReason | test("MAIN SESSION: check and save these skill_lessons now"))' \
    <<<"$out" >/dev/null 2>&1
}
hand "a.sh, b.sh"
[[ $rc == 0 ]] && denied && ok "background handback without lessons is denied" || fail "handback deny: rc=$rc out=$out"
hand "a.sh, b.sh"
[[ $rc == 0 && -z $out ]] && ok "the same agent is denied only once" || fail "second handback: rc=$rc out=$out"
hand "x" b2
[[ $rc == 0 ]] && denied && ok "each agent has its own once-only denial" || fail "other agent: rc=$rc out=$out"
hand $'a.sh\n\nskill_lessons: []' b3
[[ $rc == 0 && -z $out ]] && ok "handback with lessons goes through" || fail "handback lessons: rc=$rc out=$out"
hand "ls output" b4 Bash
[[ $rc == 0 && -z $out ]] && ok "other tools are ignored" || fail "other tool: rc=$rc out=$out"
hand "no lessons" ""
[[ $rc == 0 && -z $out ]] && ok "a call without agent_id is ignored" || fail "no agent: rc=$rc out=$out"
hand "no lessons" b5 SubagentHandback statusline-setup
[[ $rc == 0 && -z $out ]] && ok "skipped agent types can hand back" || fail "skip type: rc=$rc out=$out"
hand "x" "../../evil-$$"
[[ -z $(find "$SUBAGENT_LESSONS_STATE_DIR/.." -maxdepth 2 -name "*evil-$$*" ! -path "$SUBAGENT_LESSONS_STATE_DIR/*" 2>/dev/null) ]] \
  && ok "agent_id cannot escape the state folder" || fail "path escape via agent_id"
out=$(jq -nc '{hook_event_name: "SubagentStop", stop_hook_active: false, agent_type: "Explore",
               agent_transcript_path: "/nonexistent"}' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "SubagentStop without last_assistant_message is left to the handback gate" \
  || fail "bg stop: rc=$rc out=$out"

echo
[[ $fails == 0 ]] && echo "all passed" || echo "$fails failed"
exit $((fails > 0))
