---
name: leorna-update-main-before-worktree
description: "Before a Leorna story worktree, fast-forward the main checkout's local main too, even when told not to switch its branch"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d0decd7d-6c54-4d08-9299-999afb0cbf85
  modified: 2026-10-28T18:14:01.314Z
---

When starting a Leorna story in a worktree, fast-forward the main checkout's local `main` to the freshly fetched `origin/main` (`git merge --ff-only origin/main` in the main folder, which is on `main`), not only the new worktree. "Never switch the main checkout's branch" means don't check out another branch there; it doesn't mean leave `main` behind.

**Why:** on 2026-10-28 (story 86bcm901j), I made the worktree from fresh `origin/main` but left local `main` 4 commits behind and reported it; Justin corrected: "make sure it pulls the updated main branch". The `leorna` skill's Doing-a-story step 2 already says to branch from updated main.

**How to apply:** fetch over HTTPS through gh, check the main checkout has no tracked changes (an untracked `.claude/` is just the worktrees), ff-only merge, then confirm `main`, `origin/main` and the worktree HEAD are the same SHA. Stop and ask if ff-only refuses. See [[resuming-stopped-sessions]] for related session notes.
