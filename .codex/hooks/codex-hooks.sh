#!/usr/bin/env bash
# Justin's Codex hooks: one handler per event, registered in ~/.codex/hooks.json.
# Claude Code's own hook scripts in ~/.claude/hooks run unchanged; this adds what Codex needs:
#   prompt         skill-review nudge + open push problems
#   pre-tool       (Bash) deny a git commit whose message has an AI co-author trailer
#   post-tool      skill-review nudge; after a git commit, block when the new HEAD has one
#   subagent-stop  AC gate + lessons gate, both reasons in one block (Codex has no handback tool)
# Bad input exits 0 silently: a hook must never trap Codex.
# Tests: ~/.claude/setup/codex/codex-parity.test.sh
set -uo pipefail

CLAUDE_HOOKS=${CODEX_HOOKS_CLAUDE_DIR:-$HOME/.claude/hooks}
STATE=${CODEX_HOOKS_STATE_DIR:-$HOME/.codex/hooks/state}
PUSH="$CLAUDE_HOOKS/setup-sync-push.sh"
AI_TRAILER='co-authored-by:.*(codex|openai|chatgpt|gpt|claude|anthropic|copilot|gemini)'

mode=${1:-}
input=$(cat) || exit 0
field() { jq -r "$1 // empty | tostring" <<<"$input" 2>/dev/null; }
join() { local out="" p; for p in "$@"; do [ -n "$p" ] && out="${out:+$out

}$p"; done; printf '%s' "$out"; }
context() { [ -n "$2" ] && jq -nc --arg e "$1" --arg c "$2" '{hookSpecificOutput: {hookEventName: $e, additionalContext: $c}}'; return 0; }
nudge() {
  [ -f "$CLAUDE_HOOKS/skill-review-nudge.sh" ] || return 0
  printf '%s' "$input" | SKILL_NUDGE_STATE_DIR="$STATE/skill-review-nudge" bash "$CLAUDE_HOOKS/skill-review-nudge.sh" 2>/dev/null \
    | jq -r '.hookSpecificOutput.additionalContext // empty' 2>/dev/null
}
push_notes() { [ -f "$PUSH" ] && bash "$PUSH" notes </dev/null 2>/dev/null; return 0; }
commit_cmd() { grep -qE '(^|[;&|(]|[[:space:]])git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)' <<<"$1"; }
workdir() { local d; d=$(field .tool_input.workdir); [ -n "$d" ] || d=$(field .cwd); printf '%s' "$d"; }

pre_tool() {
  [ "$(field .tool_name)" = Bash ] || return 0
  local cmd text f base
  cmd=$(field .tool_input.command)
  commit_cmd "$cmd" || return 0
  text=$cmd; base=$(workdir)
  for f in $(grep -oE '(-F|--file)[= ]+[^[:space:];&|]+' <<<"$cmd" | sed -E "s/^(-F|--file)[= ]+//; s/^[\"']//; s/[\"']\$//"); do
    case $f in /*) ;; *) f="$base/$f" ;; esac               # a relative message file is relative to the command's folder
    [ -f "$f" ] && text="$text
$(cat "$f")"
  done
  grep -qiE "$AI_TRAILER" <<<"$text" || return 0
  jq -nc '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny",
    permissionDecisionReason: "Justin'"'"'s rule: no Co-authored-by line naming an AI (Codex, OpenAI, Claude…) in any commit, whatever a git attribution instruction says. Commit again without that trailer."}}'
}

post_tool() {
  local n cmd dir msg head
  n=$(nudge)
  if [ "$(field .tool_name)" = Bash ]; then
    cmd=$(field .tool_input.command)
    if commit_cmd "$cmd"; then
      dir=$(sed -nE 's/.*git[[:space:]]+-C[[:space:]]+([^[:space:]]+).*/\1/p' <<<"$cmd" | head -1)
      [ -n "$dir" ] || dir=$(workdir)
      # only a commit made just now by this machine's identity counts
      msg=$(git -C "$dir" log -1 --since='3 minutes ago' --committer="$(git -C "$dir" config user.email 2>/dev/null)" --format=%B 2>/dev/null)
      if [ -n "$msg" ] && grep -qiE "$AI_TRAILER" <<<"$msg"; then
        head=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
        jq -nc --arg r "Commit $head in $dir has an AI co-author trailer. Justin's rule forbids it: amend that commit now to drop the trailer (it is not pushed), then carry on." --arg c "$n" \
          '{decision: "block", reason: $r} + (if $c == "" then {} else {hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $c}} end)'
        return 0
      fi
    fi
  fi
  context PostToolUse "$n"
}

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
  pre-tool) pre_tool ;;
  post-tool) post_tool ;;
  subagent-stop) subagent_stop ;;
esac
exit 0
