---
name: hook-payload-cwd-drift
description: "Claude Code hook payload cwd follows the session's cd (worktrees too); map to the project via transcript_path's folder instead"
metadata:
  node_type: memory
  type: reference
  originSessionId: a9335c8b-35f9-4848-b6b7-031b4326a629
  modified: 2026-11-07T15:12:19.726Z
---

A Claude Code hook payload's `cwd` follows the session's `cd`, worktrees included: 19 of 65 recent main-session transcripts (2026-11-07) had typed prompts from more than one folder. So a hook that maps `cwd` to `~/.claude/projects/<key>` loses the project mid-session. The session's own project folder is the directory holding `transcript_path`; fall back to it (or walk up `cwd`'s parents first).

**Why:** cortexos-memory-hook review 1 (R1-2), evidence in ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/review-1/cwd-drift.txt.
**How to apply:** any hook or script keyed on the session's project folder ([[cortexos-local]]).
