---
name: headless-claude-isolated-call
description: "Flags for a headless `claude -p` call that loads none of Justin's setup (no hooks, CLAUDE.md, transcript) on the subscription login, and for confining edits to one folder"
metadata:
  node_type: memory
  type: reference
  originSessionId: e126e11b-3efb-4c0a-ba28-710cd6032a81
  modified: 2026-11-11T06:56:14.450Z
---

A headless call that loads none of the user's setup, on the subscription login (CLI 2.1.322, proven 2026-11-09 by the dream-pass planner with four real calls; flags confirmed in `claude --help`):

`claude -p --no-session-persistence --safe-mode --setting-sources "" --strict-mcp-config --disable-slash-commands --permission-prompts none --tools "" --output-format json --json-schema <schema>`

- Prompt on stdin (or `</dev/null`, otherwise it waits 3 s and warns). The answer is in `.structured_output`.
- Result: no hook fired, no `CLAUDE.md` loaded (609 input tokens in total), no transcript written.
- `--bare` does not work here: it needs an API key, not the subscription login.
- To let it edit files in one folder only: add `--restricted --tools Read,Grep,Glob,Edit,Write --permission-mode acceptEdits` with that folder as cwd. Refused paths show in `.permission_denials`.

- **Refusal fallback:** when the model's safeguards flag a message, the CLI by default carries the turn on to an older Opus (`claude-opus-4-8`) and `modelUsage` names both models. To keep every turn on the pinned model, set `CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK=1` in the environment and/or put `"switchModelsOnFlag": false` in the `--settings` file (it works with `--setting-sources ""`); the call then stops instead, and the result's `safety_stops` counts it. Found 2026-11-10 by the dream-pass fixer 10 (`~/.claude/cache/changelog.md` line 654; one live editor call reported both models).
- Before spending real calls on a CLI question, look in `~/.claude/cache/changelog.md` and the strings of `~/.local/share/claude/versions/<version>`.

The CLI updates itself (2.1.321 to 2.1.322 the same day), so check `claude --help` for these flags before relying on them. Plan that uses this: `~/.hermes/plans/claude-setup/dream-pass.md`.
