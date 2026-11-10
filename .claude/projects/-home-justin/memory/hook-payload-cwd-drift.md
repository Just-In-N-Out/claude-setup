---
name: hook-payload-cwd-drift
description: "Claude Code hook payload cwd follows the session's cd (worktrees too); map to the project via transcript_path's folder instead"
metadata:
  node_type: memory
  type: reference
  originSessionId: a9335c8b-35f9-4848-b6b7-031b4326a629
  modified: 2026-11-07T15:12:19.726Z
---

A Claude Code hook payload's `cwd` follows the session's `cd`, worktrees included: 19 of 65 recent main-session transcripts (2026-11-07) had typed prompts from more than one folder. So a hook that maps `cwd` to `~/.claude/projects/<key>` loses the project mid-session. The session's own project folder is the directory holding `transcript_path`; fall back to it (or walk up `cwd`'s parents first, but never above the cwd's git repository: a nested repo such as `~/Leorna/cortexos` otherwise picks up the non-repo parent's `~/Leorna` space; stop at `git rev-parse --show-toplevel`, and for a linked worktree use its main repo via `--git-common-dir`; probe with a fixture repo nested under a folder that has memory, review 2 R2-1).

**Why:** cortexos-memory-hook review 1 (R1-2), evidence in ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/review-1/cwd-drift.txt.
**How to apply:** any hook or script keyed on the session's project folder ([[cortexos-local]]).

**Memory folder is per git repository, not per transcript folder (2026-11-10, dream-pass fixer 2, from code.claude.com/docs/en/memory and real keys):** worktrees and subdirectories of one repo share the repo root's `~/.claude/projects/<key>/memory`; outside a git repo the project root is used. So a session started in a worktree has its transcript under the worktree's key but loads memory from the repo's key (the control-plane worktree key has no memory folder; `-home-justin-Leorna-leorna-control-plane/memory` exists). Resolve it with `git rev-parse --path-format=absolute --git-common-dir` from the transcript's `cwd`; don't guess from the key's prefix (the sibling folder `~/Leorna/86bcm927y-…` is a worktree of leorna-control-plane).
