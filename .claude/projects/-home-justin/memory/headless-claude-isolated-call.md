---
name: headless-claude-isolated-call
description: "Flags for a headless `claude -p` call that loads none of Justin's setup (no hooks, CLAUDE.md, transcript) on the subscription login, and for confining edits to one folder"
metadata:
  node_type: memory
  type: reference
  originSessionId: e126e11b-3efb-4c0a-ba28-710cd6032a81
  modified: 2026-11-10T03:03:08.751Z
---

A headless call that loads none of the user's setup, on the subscription login (CLI 2.1.322, proven 2026-11-09 by the dream-pass planner with four real calls; flags confirmed in `claude --help`):

`claude -p --no-session-persistence --safe-mode --setting-sources "" --strict-mcp-config --disable-slash-commands --permission-prompts none --tools "" --output-format json --json-schema <schema>`

- Prompt on stdin (or `</dev/null`, otherwise it waits 3 s and warns). The answer is in `.structured_output`.
- Result: no hook fired, no `CLAUDE.md` loaded (609 input tokens in total), no transcript written.
- `--bare` does not work here: it needs an API key, not the subscription login.
- To let it edit files in one folder only: add `--restricted --tools Read,Grep,Glob,Edit,Write --permission-mode acceptEdits` with that folder as cwd. Refused paths show in `.permission_denials`.

The CLI updates itself (2.1.321 to 2.1.322 the same day), so check `claude --help` for these flags before relying on them. Plan that uses this: `~/.hermes/plans/claude-setup/dream-pass.md`.
