---
name: claude-code-headless-agent-runs
description: "How an agent proves a Claude Code project agent really ran, headless with claude -p (2.1.312), and the gotchas; Justin asked for live agent checks to be run for him"
metadata:
  node_type: memory
  type: reference
  originSessionId: 6a5cb64a-ef1e-4913-b9a6-0011ebf1675e
  modified: 2026-11-08T04:31:47.573Z
---

Proven 2026-10-28 by the 86bcm901a AC5 runner (receipts: `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/run-agent/`). Justin asked "can't you run it?" instead of doing the live AC by hand.

**The run:** start `claude -p '<prompt>'` from the sample project's folder with:
- `--setting-sources project --output-format stream-json --verbose --permission-prompts none --strict-mcp-config`;
- `--allowedTools` / `--disallowedTools` set as needed;
- the parent session's variables unset with `env -u CLAUDECODE -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_MESSAGING_SOCKET -u CLAUDE_CODE_MESSAGING_TOKEN -u CLAUDE_EFFORT …`.

Never use `--dangerously-skip-permissions`. `claude agents` lists background sessions, not agent definitions.

**The proof, all in the stream:**
- **Agent list:** the opening `system`/`init` event's `agents` field. It is emitted even in a throwaway HOME with no sign-in (the run then exits 1), so proving an agent loads needs no login; with `ANTHROPIC_BASE_URL` pointed at a local fake, the captured request lists each agent as `- <name>: <description> (Tools: …)` (2.1.319, 86bctmuwy planner).
- **The named agent really ran:**
  - a `tool_use` with `name: "Agent"` and `input.subagent_type` set to the agent's name (init lists the tool as `Task`, but the calls say `Agent`);
  - the `system`/`task_started` event;
  - that call's `tool_result`, whose `tool_use_result` has `agentType` and `resolvedModel`.
- **The agent's own report:** the text of that `tool_result`.

**Gotchas:**
- **`--allowedTools` isn't a strict Bash allowlist.** Commands Claude Code treats as read-only (`grep`, `head`, `git ls-files`) are auto-approved anyway, and `Bash(git diff:*)` doesn't match `git -C <dir> diff`.
- **A throwaway HOME/CLAUDE_CONFIG_DIR doesn't isolate a run whose cwd is under `$HOME`** (e.g. a project under `TMPDIR=~/.cache/...`): Claude Code walks parent folders for `.claude/skills`, so the real skills show in init's `skills`/`slash_commands` and reach the model. Put the project outside `$HOME`, or check init's skills list is empty, before claiming the run read nothing real (86bctmuwy review 2 + auditor, 2.1.319). The same init line then lists his skill names in the AC log: when rendering it for a screenshot, shorten lines over ~500 characters, say so on the page, and keep the raw log local (86bctmuwy verifier 2).
- **`~/.claude/CLAUDE.md` still loads under `--setting-sources project`.**
  - Agents under test then append the pipeline's `verdict`/`ac_status`/`skill_lessons`/`MAIN SESSION` lines. Read past them when judging a report's format.
  - The session transcripts under `~/.claude/projects/` carry Justin's email addresses, so never share them as evidence.

**How to apply:** when a planned `(live)` AC is really a CLI or agent run that a headless session can prove from its own event stream, offer to have an agent run it for Justin, with receipts. Keep interactive checks (a native menu, a live publish → Sync) for him.

- **Reusing an existing MCP OAuth (86bcm9284):** `claude -p --strict-mcp-config --mcp-config <file>` reuses Claude Code's stored OAuth when the server's name and URL match an already-authenticated user-scope server (ClickUp connected with no prompt). `--no-session-persistence` still creates an empty `~/.claude/projects/<cwd slug>/memory`; `claude purge -y <path>` removes it (`--dry-run` first).

Related: [[codex-cli-offline-checks]]
