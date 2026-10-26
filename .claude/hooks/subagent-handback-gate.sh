#!/usr/bin/env bash
# Handback gate: runs every SubagentHandback gate and returns one combined deny.
#
# Claude Code keeps only the first PreToolUse deny and drops the rest (checked
# in the 2.1.310 binary on 2026-10-23: `case"deny":if(Je<wpe.deny)`), while
# Stop/SubagentStop deliver every block reason. Registered side by side, the
# lessons and AC gates would both spend their once-only denial on one call
# while the agent saw only one reason. So settings.json registers this script
# alone for PreToolUse on SubagentHandback; SubagentStop keeps both gates.
# Each gate still owns its check and its once-only marker, so an agent is denied
# at most once per gate: two denials at most when it fixes one item and then
# drops the other, never a loop. The AC reason goes first because the lessons
# reason sets the report's last line.
# Any bad input exits 0 silently: this hook must never trap an agent.
# Tests: tests/subagent-handback-gate.test.sh
set -uo pipefail

GATES=${SUBAGENT_HANDBACK_GATES:-subagent-ac-gate.sh subagent-lessons-gate.sh}
dir=$(cd "$(dirname "$0")" && pwd) || exit 0

input=$(cat) || exit 0
reasons=()
for gate in $GATES; do
  [[ $gate == /* ]] || gate="$dir/$gate"
  [[ -f $gate ]] || continue
  out=$(printf '%s' "$input" | bash "$gate" 2>/dev/null) || continue
  reason=$(jq -r 'select(.hookSpecificOutput.permissionDecision == "deny")
                  | .hookSpecificOutput.permissionDecisionReason // empty' <<<"$out" 2>/dev/null) || continue
  [[ -n $reason ]] && reasons+=("$reason")
done
((${#reasons[@]})) || exit 0

joined=$(printf '%s\n\n' "${reasons[@]}")
jq -nc --arg reason "${joined%$'\n\n'}" \
  '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
exit 0
