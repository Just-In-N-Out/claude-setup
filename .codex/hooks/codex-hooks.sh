#!/usr/bin/env bash
# Justin's Codex hooks: one handler per event, registered in ~/.codex/hooks.json.
# Claude Code's own hook scripts in ~/.claude/hooks run unchanged; this adds what Codex needs:
#   prompt         skill-review nudge + open push problems
#   post-tool      skill-review nudge
#   subagent-stop  AC gate + lessons gate, both reasons in one block (Codex has no handback tool)
# Bad input exits 0 silently: a hook must never trap Codex.
# Tests: ~/.claude/setup/codex/codex-parity.test.sh
set -uo pipefail

CLAUDE_HOOKS=${CODEX_HOOKS_CLAUDE_DIR:-$HOME/.claude/hooks}
STATE=${CODEX_HOOKS_STATE_DIR:-$HOME/.codex/hooks/state}
PUSH="$CLAUDE_HOOKS/setup-sync-push.sh"

mode=${1:-}
input=$(cat) || exit 0
join() { local out="" p; for p in "$@"; do [ -n "$p" ] && out="${out:+$out

}$p"; done; printf '%s' "$out"; }
context() { [ -n "$2" ] && jq -nc --arg e "$1" --arg c "$2" '{hookSpecificOutput: {hookEventName: $e, additionalContext: $c}}'; return 0; }
nudge() {
  [ -f "$CLAUDE_HOOKS/skill-review-nudge.sh" ] || return 0
  printf '%s' "$input" | SKILL_NUDGE_STATE_DIR="$STATE/skill-review-nudge" bash "$CLAUDE_HOOKS/skill-review-nudge.sh" 2>/dev/null \
    | jq -r '.hookSpecificOutput.additionalContext // empty' 2>/dev/null
}
push_notes() { [ -f "$PUSH" ] && bash "$PUSH" notes </dev/null 2>/dev/null; return 0; }

subagent_stop() {
  local g out r reasons=""
  for g in subagent-ac-gate.sh subagent-lessons-gate.sh; do   # AC first: the lessons reason sets the last line
    [ -f "$CLAUDE_HOOKS/$g" ] || continue
    out=$(printf '%s' "$input" | SUBAGENT_AC_STATE_DIR="$STATE/subagent-ac-gate" \
      SUBAGENT_LESSONS_STATE_DIR="$STATE/subagent-lessons-gate" bash "$CLAUDE_HOOKS/$g" 2>/dev/null) || continue
    r=$(jq -r 'select(.decision == "block") | .reason // empty' <<<"$out" 2>/dev/null) || continue
    reasons=$(join "$reasons" "$r")
  done
  [ -n "$reasons" ] && jq -nc --arg r "$reasons" '{decision: "block", reason: $r}'
  return 0
}

case $mode in
  prompt) context UserPromptSubmit "$(join "$(push_notes)" "$(nudge)")" ;;
  post-tool) context PostToolUse "$(nudge)" ;;
  subagent-stop) subagent_stop ;;
esac
exit 0
