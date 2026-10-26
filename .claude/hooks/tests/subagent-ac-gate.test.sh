#!/usr/bin/env bash
# Tests for ../subagent-ac-gate.sh. Run: bash ~/.claude/hooks/tests/subagent-ac-gate.test.sh
set -uo pipefail

HOOK="$(cd "$(dirname "$0")/.." && pwd)/subagent-ac-gate.sh"
fails=0

ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; fails=$((fails + 1)); }

# stop <message> [stop_hook_active] [agent_type] [event] -> hook stdout in $out, exit code in $rc
stop() {
  local input
  input=$(jq -nc --arg m "$1" --argjson active "${2:-false}" --arg t "${3-general-purpose}" \
    --arg e "${4:-SubagentStop}" \
    '{hook_event_name: $e, session_id: "s1", agent_id: "a1", stop_hook_active: $active,
      last_assistant_message: $m} + (if $t == "" then {} else {agent_type: $t} end)')
  out=$(printf '%s' "$input" | bash "$HOOK" 2>/dev/null)
  rc=$?
}

blocked() {
  jq -e '.decision == "block"
         and (.reason | test("ac_status\\[\\{ac, accepted, test, screenshot, evidence\\}\\]"))
         and (.reason | test("ac_status: \\[\\]"))
         and (.reason | test("complete final report"))' <<<"$out" >/dev/null 2>&1
}

# 1. a reviewer/verifier report with a verdict but no ac_status is sent back once
stop $'Verdict: clean\nAll findings closed.'
[[ $rc == 0 ]] && blocked && ok "verdict without ac_status is sent back" || fail "plain verdict: rc=$rc out=$out"
stop '{"verdict":"findings","findings":[]}'
[[ $rc == 0 ]] && blocked && ok "a JSON verdict field is gated" || fail "json verdict: rc=$rc out=$out"
stop $'**Verdict:** APPROVED\n\nNo blockers.'
[[ $rc == 0 ]] && blocked && ok "a bold Verdict: label is gated" || fail "bold verdict: rc=$rc out=$out"
stop $'Review done.\n\n## Verdict\nclean'
[[ $rc == 0 ]] && blocked && ok "a Verdict heading is gated" || fail "verdict heading: rc=$rc out=$out"
stop $'Review done.\n\n## Final verdict\nclean'
[[ $rc == 0 ]] && blocked && ok "a heading that contains verdict is gated" || fail "final verdict heading: rc=$rc out=$out"
stop 'Verdict — clean'
[[ $rc == 0 ]] && blocked && ok "Verdict followed by a dash is gated" || fail "dash verdict: rc=$rc out=$out"
stop $'| Field | Value |\n|---|---|\n| Verdict | clean |'
[[ $rc == 0 ]] && blocked && ok "a Verdict table row is gated" || fail "table verdict: rc=$rc out=$out"
stop $'**Verdict**\nclean'
[[ $rc == 0 ]] && blocked && ok "a bold Verdict label on its own line is gated" || fail "bold line verdict: rc=$rc out=$out"

# 2. a verdict report that carries ac_status finishes
stop '{"verdict":"clean","ac_status":[{"ac":"AC1","accepted":true,"test":"t","screenshot":"s","evidence":"e"}]}'
[[ $rc == 0 && -z $out ]] && ok "verdict with a JSON ac_status finishes" || fail "json ac_status: rc=$rc out=$out"
stop $'Verdict: clean\n\nac_status: []'
[[ $rc == 0 && -z $out ]] && ok "ac_status: [] finishes" || fail "empty ac_status: rc=$rc out=$out"
stop $'Verdict: findings\n\n## AC status\n| AC1 | accepted |'
[[ $rc == 0 && -z $out ]] && ok "an AC status heading finishes" || fail "ac heading: rc=$rc out=$out"

# 3. reports with no verdict (planner, builder, search) are never gated
stop "Built it on feat/x; gates green; status: ready-for-review."
[[ $rc == 0 && -z $out ]] && ok "a builder report without a verdict finishes" || fail "builder: rc=$rc out=$out"
stop "Plan saved. Waiting for the verifier's verdict after the build."
[[ $rc == 0 && -z $out ]] && ok "the word verdict in prose is not a verdict" || fail "prose: rc=$rc out=$out"

# 4. sent back at most once, and internal helpers are never gated
stop "Verdict: clean" true
[[ $rc == 0 && -z $out ]] && ok "stop_hook_active=true is never blocked again" || fail "loop guard: rc=$rc out=$out"
stop "Verdict: clean" false ""
[[ $rc == 0 && -z $out ]] && ok "agents with no agent_type are skipped" || fail "no type: rc=$rc out=$out"
stop "Verdict: clean" false Explore
[[ $rc == 0 ]] && blocked && ok "other agent types (Explore) are gated" || fail "Explore: rc=$rc out=$out"

# 5. only SubagentStop and the handback call are gated
stop "Verdict: clean" false general-purpose Stop
[[ $rc == 0 && -z $out ]] && ok "main-session Stop is ignored" || fail "Stop event: rc=$rc out=$out"
stop "Verdict: clean" false general-purpose PostToolUse
[[ $rc == 0 && -z $out ]] && ok "PostToolUse is ignored" || fail "PostToolUse: rc=$rc out=$out"

# 6. bad input never traps an agent: exit 0, no output
out=$(printf 'not json' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "invalid JSON is ignored" || fail "invalid JSON: rc=$rc out=$out"
out=$(printf '' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "empty input is ignored" || fail "empty input: rc=$rc out=$out"
out=$(jq -nc '{hook_event_name: "SubagentStop", stop_hook_active: false, agent_type: "Explore",
               agent_transcript_path: "/nonexistent"}' | bash "$HOOK"); rc=$?
[[ $rc == 0 && -z $out ]] && ok "SubagentStop without last_assistant_message is left to the handback gate" \
  || fail "bg stop: rc=$rc out=$out"

# 7. background agents hand back with a SubagentHandback tool call: deny it once per agent
export SUBAGENT_AC_STATE_DIR
root=$(mktemp -d)
SUBAGENT_AC_STATE_DIR=$root/state
trap 'rm -rf "$root"' EXIT
hand() { # hand <message> [agent_id] [tool]
  out=$(jq -nc --arg m "$1" --arg a "${2-b1}" --arg tool "${3-SubagentHandback}" \
    '{hook_event_name: "PreToolUse", session_id: "s1", tool_name: $tool, tool_input: {message: $m}}
     + (if $a == "" then {} else {agent_id: $a, agent_type: "general-purpose"} end)' \
    | bash "$HOOK" 2>/dev/null); rc=$?
}
denied() {
  jq -e '.hookSpecificOutput.hookEventName == "PreToolUse"
         and .hookSpecificOutput.permissionDecision == "deny"
         and (.hookSpecificOutput.permissionDecisionReason | test("ac_status: \\[\\]"))
         and (.hookSpecificOutput.permissionDecisionReason | test("SubagentHandback again"))' \
    <<<"$out" >/dev/null 2>&1
}
hand "Verdict: findings"
[[ $rc == 0 ]] && denied && ok "background verdict without ac_status is denied" || fail "handback deny: rc=$rc out=$out"
hand "Verdict: findings"
[[ $rc == 0 && -z $out ]] && ok "the same agent is denied only once" || fail "second handback: rc=$rc out=$out"
hand "Verdict: clean" b2
[[ $rc == 0 ]] && denied && ok "each agent has its own once-only denial" || fail "other agent: rc=$rc out=$out"
hand $'Verdict: clean\nac_status: []' b3
[[ $rc == 0 && -z $out ]] && ok "handback with ac_status goes through" || fail "handback ac: rc=$rc out=$out"
hand "Built it; ready-for-review." b4
[[ $rc == 0 && -z $out ]] && ok "handback without a verdict goes through" || fail "handback builder: rc=$rc out=$out"
hand "Verdict: clean" b5 Bash
[[ $rc == 0 && -z $out ]] && ok "other tools are ignored" || fail "other tool: rc=$rc out=$out"
hand "Verdict: clean" ""
[[ $rc == 0 && -z $out ]] && ok "a call without agent_id or agent_type is ignored" || fail "no agent: rc=$rc out=$out"
out=$(jq -nc '{hook_event_name: "PreToolUse", session_id: "s1", tool_name: "SubagentHandback",
               agent_type: "general-purpose", tool_input: {message: "Verdict: clean"}}' | bash "$HOOK" 2>/dev/null); rc=$?
[[ $rc == 0 && -z $out ]] && ok "a call with agent_type but no agent_id is ignored" || fail "type, no id: rc=$rc out=$out"
# the marker is "<session>.<agent_id>.denied": with a real s1.x folder, an unsanitized
# agent_id x/../../evil would resolve to a file next to the state folder
mkdir -p "$SUBAGENT_AC_STATE_DIR/s1.x"
hand "Verdict: clean" "x/../../evil"
[[ -z $(find "$root" -name "*evil*" ! -path "$SUBAGENT_AC_STATE_DIR/*" 2>/dev/null) ]] \
  && ok "agent_id cannot escape the state folder" || fail "path escape via agent_id"
# same for session_id, the marker's first component
mkdir -p "$SUBAGENT_AC_STATE_DIR/x"
out=$(jq -nc '{hook_event_name: "PreToolUse", session_id: "x/../../sevil", agent_id: "b9", agent_type: "general-purpose",
               tool_name: "SubagentHandback", tool_input: {message: "Verdict: clean"}}' | bash "$HOOK" 2>/dev/null)
[[ -z $(find "$root" -name "*sevil*" ! -path "$SUBAGENT_AC_STATE_DIR/*" 2>/dev/null) ]] \
  && ok "session_id cannot escape the state folder" || fail "path escape via session_id"

echo
[[ $fails == 0 ]] && echo "all passed" || echo "$fails failed"
exit $((fails > 0))
