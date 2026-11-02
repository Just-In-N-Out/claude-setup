---
name: run-without-stopping
description: "Build straight through without check-ins (2026-10-07); when away take the recommended options, tell lost agents to research, resume limit-stopped agents, full report on return; agents in parallel again (2026-10-29); review rounds capped at 3 after ACs (2026-10-31)"
metadata:
  type: feedback
---

On 2026-10-07, after M3a, the user said: "just continue building we will check everything at the end. Do the rest of
M3 then start M4 do not stop till done. Make sure you keep updating the central memory for the next agent."

**Why:** they'd rather do one paste check at the end than one per milestone, and they expect other agents to pick up
the work, so the shared notes must always be current.
**How to apply:** run each milestone (plan, native execution, opus review, fix pass) back to back without asking. After
each milestone update docs/HANDOFF.md and [[v2-rewrite]]. Under the refreshed 2026-10-28 project rules, CLAUDE.md keeps only compact **Status** (build and one feature line) plus standing rules/decisions; full narratives stay in HANDOFF and the ledger. The finisher moves the ledger before the premerge commit/rebase. Don't stop for paste checks:
pile up what each one needs in HANDOFF and hand it over at the end. Still never write a native Bricks emitter from
memory (CLAUDE.md): work that needs a sample the user hasn't sent is listed as waiting, not guessed. See [[user-workflow]].

On 2026-10-27, going to sleep mid-pipeline (label-floor), he said: keep it running whatever happens, "go with the recommended stuff" for anything the agents ask, and if an agent is lost, "tell it to go do research and try to implement its best"; resume anything a usage limit stopped (and, proven twice on 2026-10-31, every background agent stops when the session closes or WSL restarts: on return, check each agent's worktree (branch head, uncommitted work) and resume it with SendMessage at once, naming where it was; agents run only while a session is open; to tell why, `powershell.exe Get-WinEvent` System log Ids 41/6008 (crash), 1074 (power off from the Start menu, 10-31 twice), 109+6006 alone (clean restart, 11-02 13:45), 41+6008 at 11-02 15:16 and again 15:34 (unexpected crashes with 11, then 9 agents running Chrome suites; 6 ran without a crash): Justin then said "run it by waves" (≤4 at once), and later the same day, asked how the DJ Trees and website-importer sessions should share it, "raise the limit to 8": at most 8 agents on the PC across all sessions (split agreed by message: DJ Trees 5, importer 3), browser suites one at a time, a new agent only as one finishes, and `journalctl --list-boots`); "When I'm back, I want a full report on everything that happened." So while he's away: take every ⭐/recommended option without asking, tell stuck agents to research and implement their best (recorded as rulings), resume rate-limited agents with SendMessage, run the pipeline through to the merge, and keep a running log for the full report.

On 2026-10-28, after the usage limit kept stopping four parallel agents, he asked for one agent at a time. **On 2026-10-29 he lifted it:** "If you're an orchestrator, you can start multiple plans and orchestrate multiple agents and everything", and asked that a finished plan go straight to its builder. So run separate jobs side by side again (rule now in `~/.claude/CLAUDE.md` "Several jobs at once"); if usage limits start stopping agents again, say so and ask.

**2026-10-30 (low usage):** asked Full or Mini for a plugin fix, he answered "we're super low on usage, I need this to be a quick fix. No need for review rounds", then "just keep it going not say yes everytime and log it". When he explicitly asks for that quick-fix route, follow his requested execution: in-session, or direct separate builder agents when he asks to delegate (DJ Trees, later on 2026-10-30: "give it to each agent" and "no need for reviews or anything"). Skip the planner/review pipeline for that named work, keep focused regression tests, `npm run check` and available real-file replay evidence, then integrate to main, bump/build/push, and log it in HANDOFF + CLAUDE.md Status instead of stopping to ask; edit prompts come from the permission mode (Shift+Tab → accept edits is his switch). See [[plugin-first]].

**2026-10-31:** review rounds are capped (goals and ACs first, then at most 3 review→fix rounds): [[review-round-cap]]. Tell him early when a loop reaches small edge cases.
