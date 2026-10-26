#!/usr/bin/env bash
# Hermes-style self-improvement nudge for Claude Code.
#
# Every SKILL_NUDGE_TOOLS tool calls (PostToolUse, default 15) and every
# SKILL_NUDGE_PROMPTS user messages (UserPromptSubmit, default 10) in the main
# session, remind Claude to save what it learned into a skill or memory right
# away, so nothing waits for a session end that may never come.
# Subagents (input has agent_id) get their own counter per agent, tool calls
# only, and a different nudge: note lessons in the final report's
# skill_lessons, never edit skills, because the main session saves them.
# Any bad input exits 0 silently: this hook must never block a tool call or a
# prompt.
# Tests: tests/skill-review-nudge.test.sh
set -uo pipefail

TOOLS_EVERY=${SKILL_NUDGE_TOOLS:-15}
PROMPTS_EVERY=${SKILL_NUDGE_PROMPTS:-10}
STATE_DIR=${SKILL_NUDGE_STATE_DIR:-$HOME/.claude/hooks/state/skill-review-nudge}

fields=$(jq -r '[.hook_event_name // "", .session_id // "", .agent_id // ""] | @tsv' 2>/dev/null) || exit 0
IFS=$'\t' read -r event session agent <<<"$fields"
session=${session//[^A-Za-z0-9_-]/}
[[ -n $session ]] || exit 0

if [[ -n $agent ]]; then
  [[ $event == PostToolUse ]] || exit 0
  agent=${agent//[^A-Za-z0-9_-]/}
  [[ -n $agent ]] || exit 0
  every=$TOOLS_EVERY; kind="$agent.tools"; what="$TOOLS_EVERY of your tool calls"
else
  case $event in
    PostToolUse)      every=$TOOLS_EVERY;   kind=tools;    what="$TOOLS_EVERY tool calls" ;;
    UserPromptSubmit) every=$PROMPTS_EVERY; kind=prompts;  what="$PROMPTS_EVERY messages" ;;
    *) exit 0 ;;
  esac
fi
[[ $every =~ ^[1-9][0-9]*$ ]] || exit 0

mkdir -p "$STATE_DIR" 2>/dev/null || exit 0
file="$STATE_DIR/$session.$kind"
if [[ ! -e $file ]]; then
  # new session: drop counters from sessions idle for a week
  find "$STATE_DIR" -type f -mtime +7 -delete 2>/dev/null
fi
count=$(cat "$file" 2>/dev/null)
[[ $count =~ ^[0-9]+$ ]] || count=0
count=$((count + 1))
echo "$count" >"$file" 2>/dev/null || exit 0
((count % every == 0)) || exit 0

if [[ -n $agent ]]; then
msg="Skill-lesson check (automatic hook, every $what). Finish the step you are on first. \
If you learned something reusable since the last check (a gotcha, an approach that worked after one failed, or a skill step that was wrong, missing or stale), note it for your final report: list it in skill_lessons[{skill, lesson, evidence}] and a 'Skill lessons' section, naming the skill it belongs in (or memory for a fact). \
You do not edit SKILL.md files, skills or memory yourself: the main session saves them, so parallel agents never overwrite each other. \
skill_lessons: [] is the normal answer: list only something a future task would need that the skill doesn't already say, never a lesson for the sake of one. \
If nothing qualifies, say nothing about this check and carry on."
else
msg="Self-improvement check (automatic hook, every $what). Finish the step you are on first, then look back at the work since the last check. \
Save something only if it is new, reusable and proven, and save it now instead of waiting for the session to end: a correction from the user, an approach that worked after a failed one, a gotcha, or a skill step that was wrong or missing. \
A reusable procedure goes into the matching SKILL.md under ~/.claude/skills (these are the user's Hermes skills, shared with Hermes; never edit plugin skills): search the skill first, then fold the lesson into an existing line, replace the line it makes outdated or delete one it proves wrong, rather than appending a new one. \
A fact or preference goes into your memory directory, following its rules. \
Tell the user in one line what you saved and where. Nothing new is the normal outcome: then say nothing about this check and carry on."
fi

jq -nc --arg event "$event" --arg msg "$msg" \
  '{hookSpecificOutput: {hookEventName: $event, additionalContext: $msg}}'
