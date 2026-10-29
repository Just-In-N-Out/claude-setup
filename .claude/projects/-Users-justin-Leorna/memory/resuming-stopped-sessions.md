---
name: resuming-stopped-sessions
description: "Where a stopped Claude Code session's pipeline state lives (subagent reports, models, typed messages) when writing a resume prompt"
metadata:
  node_type: memory
  type: reference
  originSessionId: 2c0f653f-8021-4c94-84cf-9276a410e30a
  modified: 2026-10-29T12:37:29.934Z
---

Found on 2026-10-23 while writing restart prompts for three stopped Leorna sessions:

- **Subagent transcripts** are in `~/.claude/projects/<project>/<session-id>/subagents/agent-<id>.jsonl`. `<project>` is the folder's absolute path with every non-alphanumeric character replaced by `-`, plus a hash suffix past 200 characters (binary 2.1.310). So `/Users/justin/.hermes` becomes `-Users-justin--hermes`, and WSL's `/home/justin/Leorna` becomes `-home-justin-Leorna`. A background agent's final report is in its `SubagentHandback` tool_use input, or in its last text block (Plan-type agents can end with plain text). Check both: the 901v planner's 120 KB plan was only in the last text block.
- **Real model and effort** of an agent: `agent-<id>.meta.json` (`model`, `effort`). The agent itself can't see its effort.
- **Messages Justin typed straight into a running subagent** appear only in that subagent's transcript, as `attachment.type == "queued_command"`.
- **Plan mode** lets the session write only its plan file. Lessons or notes kept only in chat are lost when the session is stopped.
- **A stopped background agent can be resumed** from the reopened session with `SendMessage` to its agentId (the "didn't finish before the previous session ended" notification gives it); it continues from its transcript (2026-10-28, 901w planner). Tell it the current state (files written, git SHAs). On the WSL desktop `/tmp` is a tmpfs, so a restart can wipe the session scratchpad and every agent's scratch folder while `~/.cache/<story>-<role>/` copies, test databases and evidence survive: tell the resumed agent which is which, and have it reuse finished receipts rather than redo them (901j verifier, 2026-10-28). A hard WSL crash (`uptime` shows a fresh boot) also leaves files written in its last seconds 0 bytes or NUL-filled: a new worktree's `.git` and files (git: "invalid gitfile format"), its admin folder under `.git/worktrees/`, its branch ref ("ignoring broken ref"), `FETCH_HEAD`, and the agent transcript's tail (a strict JSON parse fails; strip NULs per line to read it). Before resuming, check `git fsck --connectivity-only`, `find -size 0 -newermt <agent start>` and NUL counts in the plan, briefs and skill files; brief the next builder to verify the leftovers are all empty, then remove them and `git worktree prune` (902a builder, 30 s in; 2026-10-29). **First check the old process is really gone:** after Justin "clicked out", the old process kept running, so the resume made a second process on the same session (two `~/.claude/sessions/<pid>.json` with one `sessionId`; ListAgents shows both under different names). Both got the planner's result and recorded the same approval within seconds, and two planner copies wrote one plan file (901w, 2026-10-28). Find a duplicate with `grep -l <session-id> ~/.claude/sessions/*.json` and confirm its pid is alive (`ps -p <pid>`): the json files outlive a WSL restart, so a stale one isn't a duplicate (901w, 17:54 restart). Tell a live duplicate process to hold with SendMessage to its name before dispatching, and tell a resumed agent to read and edit an existing output, never overwrite it. Only if the resume fails, re-dispatch from the saved brief: hence the CLAUDE.md rule to save every brief under `~/.hermes/plans/<project>/briefs/` before dispatching.
- The state of the three sessions stopped at 20:00 EDT, and their unsaved plan and brief, are in `~/.hermes/plans/leorna/restart-2026-10-23/`.

Related: [[claude-md-loads-at-session-start]], [[concurrent-sessions-share-skill-files]]
