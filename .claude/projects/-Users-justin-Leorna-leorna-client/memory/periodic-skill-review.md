---
name: periodic-skill-review
description: "A global hook nudges Claude every 15 tool calls / 10 messages to save lessons into skills or memory mid-session (periodic, never end-of-session); a finish gate makes every subagent report carry skill_lessons"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 38414736-10f6-48f2-9f8b-07a5010cf422
  modified: 2026-10-23T23:45:00Z
---

Justin wants lessons saved **during** a session, not at its end: "what if I end a session earlier". Set up 2026-10-22 as a Hermes-style background review.

**Why:** Hermes keeps its skills current through a periodic review (every 15 tool calls / 10 turns). Claude Code had nothing like it, and an end-of-session hook misses sessions he closes early.

**How to apply:**
- `~/.claude/hooks/skill-review-nudge.sh` runs on PostToolUse and UserPromptSubmit (wired in `~/.claude/settings.json`). In the main session, every 15 tool calls or 10 messages it injects a "self-improvement check".
- When the check fires: finish the current step, then save any durable lesson. A procedure goes in the matching SKILL.md under `~/.claude/skills`; those are links to `~/.hermes/skills`, so Hermes gets the same edit. A fact or preference goes in memory. Say what was saved in one line, or stay silent if nothing qualifies.
- **Subagents too (Justin, 2026-10-23: "make it so that the agent note stuff that can be put in skills"):** a subagent's PostToolUse (input has `agent_id`) has its own counter per agent (`<session>.<agent>.tools`). Every 15 of its tool calls it gets a *skill-lesson check*: note lessons in its final report's `skill_lessons[{skill, lesson, evidence}]` and never edit skills or memory itself. The main session checks and saves them on intake (rule also in `feature-dispatch` and `~/.claude/CLAUDE.md`). Why not let agents edit: parallel agents would overwrite shared skill files, and reviewers are read-only.
- **Finish gate (Justin, 2026-10-23: "add finish hook"):** `~/.claude/hooks/subagent-lessons-gate.sh` sends an agent back once when its report has no `skill_lessons`/"Skill lessons". The report must then end with `MAIN SESSION: check and save these skill_lessons now.`, which is the main session's cue to save lessons before the next dispatch. It is wired twice in `~/.claude/settings.json`: on SubagentStop, and on PreToolUse with matcher `SubagentHandback`. Facts proven live on 2026-10-23 with debug logging and four haiku Explore checks:
  - A **foreground** agent's SubagentStop has `last_assistant_message`, and `decision: block` works there.
  - A **background** agent ends with a `SubagentHandback` tool call (`tool_input.message` is the report). Its SubagentStop has **no** `last_assistant_message`, and a block there arrives after delivery, so the agent never runs again (checks 1–3 failed this way). Denying the `SubagentHandback` PreToolUse call once per agent works: check 4 came back with lessons and the MAIN SESSION line. The once-per-agent marker is `~/.claude/hooks/state/subagent-lessons-gate/<session>.<agent>.denied`.
  - Many SubagentStop events come from Claude Code's internal helpers with an **empty `agent_type`**, which the gate skips.
  - Bash `read` with a tab IFS merges an empty field into the next one, so fields are joined with `\x1f` instead.
  - SubagentStop and PreToolUse hooks in user settings are picked up mid-session, with no restart.
  - Tests: `bash ~/.claude/hooks/tests/subagent-lessons-gate.test.sh` (22 cases). Skip list env `SUBAGENT_LESSONS_SKIP` (default `statusline-setup`).
- Intervals: env `SKILL_NUDGE_TOOLS` / `SKILL_NUDGE_PROMPTS` in the hook command. Counters live in `~/.claude/hooks/state/skill-review-nudge/`. Tests: `bash ~/.claude/hooks/tests/skill-review-nudge.test.sh` (16 cases; the path-escape tests use a per-run unique name because a stray `evil.tools` from an older run sits in `$TMPDIR/..`).

Related: [[leorna-workflow]], [[justin-profile]].
