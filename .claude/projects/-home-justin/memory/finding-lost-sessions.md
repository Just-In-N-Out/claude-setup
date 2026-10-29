---
name: finding-lost-sessions
description: "How to find a Claude Code session the user says they lost, deleted or \"had in the cloud\""
metadata:
  node_type: memory
  type: reference
  originSessionId: 7b3e20cc-5d7c-48bb-9e00-e6113f3da53b
  modified: 2026-10-29T00:12:26.277Z
---

When the user asks for a lost session (voice notes call it "cloud" or "cloth" even when it was local), it is usually still on disk: closing a session doesn't delete its transcript.

- Search only the user's typed messages in `~/.claude/projects/*/*.jsonl` (strip `<system-reminder>` blocks first: they carry CLAUDE.md, which names Hermes and the harness in every session).
- Faster lead for pipeline work: the newest plan and briefs in `~/.hermes/plans/<project>/` name the story; then grep transcripts for the story name and read the opening messages.
- Folders in `~/.claude/projects` start with `-`, so `grep`/`ls`/`basename` read them as flags: prefix paths with `./` or use `--`.
- Reopen with `cd <project dir> && claude --resume <session-id>` (sessions are filed by folder).

Found 2026-10-28: the "deleted" harness-guards session was `f6b994e6`, closed mid fixer-4, transcript intact.
