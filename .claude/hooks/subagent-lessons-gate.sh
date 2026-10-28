#!/usr/bin/env bash
# Skill-lessons gate: every subagent's final report must carry skill_lessons.
#
# A report "has lessons" when it mentions skill_lessons (a field or a list) or
# has a "Skill lessons" heading. A report without them is sent back once with
# the instruction: restate the full report, add the lessons
# skill_lessons[{skill, lesson, evidence, enforce}], never edit skills, and end
# with a line telling the main session to save them. SubagentStop can't write
# into the parent's context, so that last line is the main session's reminder.
# A report with lessons in the structured form a script can read reliably
# (skill_lessons: [{…}] or "skill_lessons": [ {…} ], also across lines) but no
# enforce anywhere is sent back once too, asking for enforce on each lesson; a
# list quoted as an example (`…`, "…", '…') doesn't count.
# Markdown-only lessons aren't parsed, and an empty list passes. Both checks
# share the once-only mechanisms below, so an agent is sent back at most once.
#
# Two ways an agent finishes, checked live 2026-10-23:
# - Foreground: SubagentStop carries last_assistant_message. Block with
#   decision=block; stop_hook_active=true means it was already sent back once.
# - Background: the agent hands its report back with a SubagentHandback tool
#   call, and its SubagentStop has no last_assistant_message. A block there
#   comes after delivery and the agent never runs again, so the gate is
#   PreToolUse on SubagentHandback: deny the call, once per agent.
# Agents with no agent_type (Claude Code's internal helpers) and the types in
# SUBAGENT_LESSONS_SKIP (space separated) are never gated.
# Any bad input exits 0 silently: this hook must never trap an agent.
# Tests: tests/subagent-lessons-gate.test.sh
set -uo pipefail

SKIP=${SUBAGENT_LESSONS_SKIP:-statusline-setup}
STATE_DIR=${SUBAGENT_LESSONS_STATE_DIR:-$HOME/.claude/hooks/state/subagent-lessons-gate}

input=$(cat) || exit 0
# fields joined by the unit separator: a tab IFS would merge an empty field into the next one
fields=$(jq -r '[.hook_event_name // "", (.stop_hook_active // false | tostring), .agent_type // "",
                 (has("last_assistant_message") | tostring), .tool_name // "", .session_id // "", .agent_id // ""]
                | map(tostring | gsub("\u001f"; "")) | join("\u001f")' <<<"$input" 2>/dev/null) || exit 0
IFS=$'\x1f' read -r event active agent_type has_message tool session agent <<<"$fields"

[[ -n $agent_type ]] || exit 0
for t in $SKIP; do [[ $agent_type == "$t" ]] && exit 0; done

has_lessons() { grep -qiE 'skill_lessons|skill lessons' <<<"$1"; }
# a non-empty structured list (JSON, or an unquoted key) with no enforce anywhere in the report. A list quoted in
# `…`, "…" or '…' is an example, not the report's own, so it doesn't count; a ``` fence's content still does, and
# so does a JSON "skill_lessons" key (its quotes are kept apart first). An apostrophe inside a word isn't a quote.
missing_enforce() {
  local one
  one=$(tr '\n' ' ' <<<" $1 " | sed -E 's/```[[:alnum:]_-]*//g; s/"skill_lessons"/skill_lessons/g; s/`[^`]*`//g; s/"[^"]*"//g' \
    | sed -E "s/([^[:alnum:]])'[^']*'([^[:alnum:]])/\1\2/g")
  grep -qE 'skill_lessons[[:space:]]*[:=][[:space:]]*\[[[:space:]]*\{' <<<"$one" && ! grep -qi 'enforce' <<<"$1"
}

reason="Before you finish: your final report has no skill lessons. Restate your complete final report \
in full (the parent keeps only your newest report), then add a 'Skill lessons' section listing \
skill_lessons[{skill, lesson, evidence, enforce}]: reusable gotchas, an approach that worked after one failed, \
or a skill step that was wrong, missing or stale, naming the skill it belongs in (or memory for a fact). \
enforce is none, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal \
for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks \
and where it runs. \
'skill_lessons: []' is the normal answer when you learned nothing new: list only what a future task would need \
that the skill doesn't already say. Do not edit any SKILL.md, skill or memory file yourself. \
End with this exact last line: MAIN SESSION: check and save these skill_lessons now."
enforce_reason="Your skill_lessons entries have no enforce field. Restate your complete final report in full \
(the parent keeps only your newest report), adding enforce to each lesson: none, or, when the lesson is about \
a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (its kind: \
Claude Code hook, git hook, test, lint or script; what it checks; where it runs). Do not edit any SKILL.md, skill \
or memory file yourself. End with this exact last line: MAIN SESSION: check and save these skill_lessons now."
# send_back <message>: true, with the reason in $why, when the report must go back (no lessons first)
send_back() {
  if ! has_lessons "$1"; then why=$reason
  elif missing_enforce "$1"; then why=$enforce_reason
  else return 1; fi
}

case $event in
  SubagentStop)
    [[ $active == false && $has_message == true ]] || exit 0
    message=$(jq -r '.last_assistant_message // "" | tostring' <<<"$input" 2>/dev/null) || exit 0
    [[ -n $message ]] && send_back "$message" || exit 0
    jq -nc --arg reason "$why" '{decision: "block", reason: $reason}'
    ;;
  PreToolUse)
    [[ $tool == SubagentHandback ]] || exit 0
    session=${session//[^A-Za-z0-9_-]/}; agent=${agent//[^A-Za-z0-9_-]/}
    [[ -n $agent ]] || exit 0
    message=$(jq -r '.tool_input.message // "" | tostring' <<<"$input" 2>/dev/null) || exit 0
    send_back "$message" || exit 0
    mkdir -p "$STATE_DIR" 2>/dev/null || exit 0
    marker="$STATE_DIR/${session:-nosession}.$agent.denied"
    [[ -e $marker ]] && exit 0 # sent back once already: let it hand back
    find "$STATE_DIR" -type f -mtime +7 -delete 2>/dev/null
    : >"$marker" 2>/dev/null || exit 0
    jq -nc --arg reason "$why Then call SubagentHandback again with that full message." \
      '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
    ;;
esac
exit 0
