---
name: concurrent-sessions-share-skill-files
description: "Several main sessions edit the same skills, CLAUDE.md and settings.json at once; re-read right before every write"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2c0f653f-8021-4c94-84cf-9276a410e30a
  modified: 2026-10-24T00:14:08.824Z
---

Justin runs several Claude Code main sessions at once, and each saves skill lessons into the same shared files: `leorna` and `feature-dispatch` SKILL.md, the library skills under `~/.hermes/skills-library`, `~/.claude/CLAUDE.md` and `~/.claude/settings.json`. On 2026-10-23, three sessions edited these files within minutes of each other.

**Why:** "only the main session writes skills" prevents races between subagents, not between sessions. A whole-file write from a stale copy silently drops another session's edit.

**How to apply:** re-read right before every write, and edit with exact anchors (the Edit tool, or a script that asserts its anchor occurs exactly once) instead of rewriting whole files. If a file changed since you read it, merge rather than overwrite. Library skills keep local edits as uncommitted changes that `update-skills-library.sh` re-applies after each pull.

Related: [[resuming-stopped-sessions]]
