#!/usr/bin/env bash
# AC gate: a reviewer's or verifier's final report must carry ac_status.
#
# A report is a verdict when it has a verdict field, label, table row or heading
# ("verdict": …, Verdict: …, Verdict — …, | Verdict | …, **Verdict**, ## Final
# verdict). A verdict without ac_status is sent back once: restate the full
# report and add ac_status[{ac, accepted, test, screenshot, evidence}] for every
# acceptance criterion in the plan, or `ac_status: []` when the brief had none.
# Reports with no verdict (builders, searches, most planners) pass; a false
# match, such as a plan quoting `verdict: clean|findings`, costs one extra turn.
# Same two exits as subagent-lessons-gate.sh, which has the details:
# SubagentStop for foreground agents (stop_hook_active=true means already sent
# back once), PreToolUse on SubagentHandback for background ones (denied once
# per agent). Agents with no agent_type (Claude Code's internal helpers) are
# never gated.
# Any bad input exits 0 silently: this hook must never trap an agent.
# Tests: tests/subagent-ac-gate.test.sh
set -uo pipefail

STATE_DIR=${SUBAGENT_AC_STATE_DIR:-$HOME/.claude/hooks/state/subagent-ac-gate}

input=$(cat) || exit 0
# fields joined by the unit separator: a tab IFS would merge an empty field into the next one
fields=$(jq -r '[.hook_event_name // "", (.stop_hook_active // false | tostring), .agent_type // "",
                 (has("last_assistant_message") | tostring), .tool_name // "", .session_id // "", .agent_id // ""]
                | map(tostring | gsub("\u001f"; "")) | join("\u001f")' <<<"$input" 2>/dev/null) || exit 0
IFS=$'\x1f' read -r event active agent_type has_message tool session agent <<<"$fields"

[[ -n $agent_type ]] || exit 0

needs_ac() {
  grep -qiE '(^|[^a-z_])verdict[*"_ ]{0,4}([:=|]|—|–| - )|^#+ .*verdict|^[*_]{2}verdict[*_]{2} *$' <<<"$1" || return 1
  ! grep -qiE 'ac_status|ac status' <<<"$1"
}

reason="Before you finish: your report gives a verdict but no ac_status. Restate your complete final report \
in full (the parent keeps only your newest report), then add ac_status[{ac, accepted, test, screenshot, evidence}]: \
one entry per acceptance criterion in the plan or brief, accepted true only when its test passed on the reviewed \
head and its proof is real (unrun checks stay NOT VERIFIED; a (live) AC you couldn't run gets accepted false plus \
not_run with the reason). Write 'ac_status: []' if your brief gave no \
acceptance criteria. Keep your verdict, findings and skill_lessons."

case $event in
  SubagentStop)
    [[ $active == false && $has_message == true ]] || exit 0
    message=$(jq -r '.last_assistant_message // "" | tostring' <<<"$input" 2>/dev/null) || exit 0
    needs_ac "$message" || exit 0
    jq -nc --arg reason "$reason" '{decision: "block", reason: $reason}'
    ;;
  PreToolUse)
    [[ $tool == SubagentHandback ]] || exit 0
    session=${session//[^A-Za-z0-9_-]/}; agent=${agent//[^A-Za-z0-9_-]/}
    [[ -n $agent ]] || exit 0
    message=$(jq -r '.tool_input.message // "" | tostring' <<<"$input" 2>/dev/null) || exit 0
    needs_ac "$message" || exit 0
    mkdir -p "$STATE_DIR" 2>/dev/null || exit 0
    marker="$STATE_DIR/${session:-nosession}.$agent.denied"
    [[ -e $marker ]] && exit 0 # sent back once already: let it hand back
    find "$STATE_DIR" -type f -mtime +7 -delete 2>/dev/null
    : >"$marker" 2>/dev/null || exit 0
    jq -nc --arg reason "$reason Then call SubagentHandback again with that full message." \
      '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
    ;;
esac
exit 0
