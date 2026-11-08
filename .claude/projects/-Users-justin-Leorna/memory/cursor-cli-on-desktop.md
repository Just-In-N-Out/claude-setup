---
name: cursor-cli-on-desktop
description: Cursor CLI is installed on the WSL desktop (2026-11-07); where it lives and which folders even --version writes
metadata:
  node_type: memory
  type: reference
  originSessionId: e3537075-7b25-4c2b-a45d-3e318d6f86d8
  modified: 2026-11-08T01:45:25.927Z
---

Installed 2026-11-07 at Justin's request (story 86bctmuwy) with Cursor's `https://cursor.com/install` script: `~/.local/bin/cursor-agent` and `~/.local/bin/agent` link to `~/.local/share/cursor-agent/versions/<version>/cursor-agent` (first version `2026.11.05-86047df`). The installer touches only those paths; it edits no shell file and creates no `~/.cursor`. The Mac may not have it.

Even `cursor-agent --version` writes `$XDG_CONFIG_HOME/cursor/cli-config.json` (default `~/.config/cursor`) and `~/.cache/cursor-compile-cache`, so a test that must leave the real home alone sets `HOME`, `XDG_CONFIG_HOME` and `CURSOR_CONFIG_DIR` to a throwaway folder before *any* call.

Related: [[codex-cli-offline-checks]], [[claude-code-headless-agent-runs]]
