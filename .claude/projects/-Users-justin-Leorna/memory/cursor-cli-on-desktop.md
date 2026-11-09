---
name: cursor-cli-on-desktop
description: Cursor CLI on the WSL desktop (2026-11-07) - where it lives, what even --version writes, how to drive it offline, and that it reads agents only from the workspace
metadata:
  node_type: memory
  type: reference
  originSessionId: e3537075-7b25-4c2b-a45d-3e318d6f86d8
  modified: 2026-11-08T01:59:46.845Z
---

Installed 2026-11-07 at Justin's request (story 86bctmuwy) with Cursor's `https://cursor.com/install` script: `~/.local/bin/cursor-agent` and `~/.local/bin/agent` link to `~/.local/share/cursor-agent/versions/<version>/cursor-agent` (first version `2026.11.05-86047df`). The installer touches only those paths; it edits no shell file and creates no `~/.cursor`. The Mac may not have it.

Even `cursor-agent --version` writes `$XDG_CONFIG_HOME/cursor/cli-config.json` (default `~/.config/cursor`) and `~/.cache/cursor-compile-cache`, so a test that must leave the real home alone sets `HOME`, `XDG_CONFIG_HOME` and `CURSOR_CONFIG_DIR` to a throwaway folder before *any* call.

**Driving it offline, no sign-in (2026.11.05, 86bctmuwy planner probe):** `--api-key <anything> -e http://127.0.0.1:<port>` plus `network.useHttp1ForAgent: true` in the scratch `cli-config.json` sends every call to a local fake. The fake answers `/auth/exchange_user_api_key` with `{"accessToken": <JWT-shaped>}`, unary `application/proto` calls with an empty 200, and `GetUsableModels`/`GetDefaultModelForCli` with one `ModelDetails`. One `RunSSE` frame carrying `ExecServerMessage{1:1, 15:"e1", 10:{}}` makes the CLI post its `RequestContext` (field 22 `custom_subagents`, plus rules and skills) to `BidiAppend`, gzipped or hex: that shows exactly what it loaded. `CURSOR_DATA_DIR` moves its data folder.
- **The CLI reads agents only from the workspace** (`.cursor/agents`, `.claude/agents`, `.grok/agents`), never `~/.cursor/agents` or `$CURSOR_CONFIG_DIR/agents`, although the docs say user-level agents work in the CLI.
- **Its frontmatter parser keeps quotes:** `description: "x"` arrives as `"x"`, and Claude's `tools: "Read, Grep"` becomes the tool names `"Read` and `Grep"`.

- **MCP without a Cursor account (86bcm9284):** `cursor-agent mcp list` and `mcp list-tools <server>` make real authenticated MCP connections with no account sign-in (`mcp login <server>` prints an OAuth URL), but tool calls need the agent and so an account. Run from a folder outside HOME: with cwd == HOME, `~/.cursor/mcp.json` is read as project config and servers show "not loaded (needs approval)".

Related: [[codex-cli-offline-checks]], [[claude-code-headless-agent-runs]]
