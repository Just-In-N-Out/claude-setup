---
name: claude-md-loads-at-session-start
description: Edits to ~/.claude/CLAUDE.md reach only sessions started afterwards; restart sessions to apply them
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2c0f653f-8021-4c94-84cf-9276a410e30a
  modified: 2026-10-24T00:10:23.505Z
---

A running Claude Code session keeps the CLAUDE.md text it loaded at start. On 2026-10-23 a test subagent still had the old copy, without the "You Are the Orchestrator" section, after the file on disk was changed.

**Why:** Justin runs several long sessions at once. Rule changes (the orchestrator pipeline, AC checks) silently don't apply to sessions that were already open.

**How to apply:** after changing CLAUDE.md, tell Justin which running sessions still follow the old rules, and offer restart prompts. When testing a CLAUDE.md change, start a fresh session (or have the agent Read the file) instead of trusting its loaded context.

Related: [[claude-code-hook-internals]]
