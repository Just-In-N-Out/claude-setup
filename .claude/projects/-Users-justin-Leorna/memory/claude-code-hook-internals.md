---
name: claude-code-hook-internals
description: How Claude Code merges hook results (first PreToolUse deny wins) and how to read that from its binary
metadata:
  node_type: memory
  type: reference
  originSessionId: 2c0f653f-8021-4c94-84cf-9276a410e30a
  modified: 2026-10-29T13:37:50.000Z
---

Checked in Claude Code 2.1.310 on 2026-10-23 (binary: `~/.local/share/claude/versions/<version>`):

- **PreToolUse:** when several hooks deny the same call, only the **first** deny reason reaches the agent (`case"deny":if(Je<wpe.deny)`); the rest are dropped. Two once-only gates on one PreToolUse event would both spend their denial while the agent sees one reason. That's why `~/.claude/hooks/subagent-handback-gate.sh` runs the lessons and AC gates and returns one combined deny.
- **Stop / SubagentStop:** every hook's block reason is delivered. Claude Code ends the turn after 8 consecutive blocks (`CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`).
- **SubagentStop input:** `stop_hook_active`, `agent_id`, `agent_type`, `agent_transcript_path`, `last_assistant_message`. Background agents hand back through a `SubagentHandback` tool call, so their SubagentStop has no `last_assistant_message`.

**How to check:** find offsets with `LC_ALL=C command grep -a -b -o -F '<text>'` and read around them with `dd` (a `.{400}` regex over the ~290 MB binary timed out at 120 s; 901j fixer 7), or read the binary with Python `re` over bytes in a fixed window around a key such as `hook_event_name:"SubagentStop"` or `case"deny":if(`. `grep -a -o '.{0,400}KEY.{0,400}'` fails here with ugrep's "exceeds complexity limits": in Claude Code's Bash tool `grep` is a shell function running its built-in ugrep, so use `command grep` (hooks run in a plain shell and get the system grep).

Related: [[zsh-bash-tool-gotchas]], [[claude-md-loads-at-session-start]]

- A hook that starts a background worker with `perl -e 'POSIX::setsid(); exec …' &` loses it when the caller kills the hook's process group right after it returns (5/5 in an experiment). Fork, setsid and a pipe handshake, so the hook returns only once the child is in its own session (codex-parity `setup-sync-push.sh`, 2026-10-28).
