---
name: sync-overwrites-copies
description: "Two files sync.sh rewrites from another source, so edits or reverts made only to them are silently undone - project-docs CLAUDE.md copies and skills-library-local.patch"
metadata:
  node_type: memory
  type: reference
  originSessionId: e126e11b-3efb-4c0a-ba28-710cd6032a81
  modified: 2026-11-10T03:03:13.443Z
---

`~/.claude/setup/sync.sh` regenerates two synced files from another source before every commit, so changing only the synced file does nothing lasting:

- **Project `CLAUDE.md` copies.** `copy_in` copies `<project>/CLAUDE.md` over `~/.claude/project-docs/<name>/CLAUDE.md` whenever they differ. On a machine that has the project cloned, edit the project's own `CLAUDE.md` (or both); an edit to the copy alone is overwritten with no message.
- **`~/.hermes/skills-library-local.patch`.** `save_lib_patch` writes `git diff` of the clone `~/.hermes/skills-library` into it. Reverting a setup-repo commit that changed the patch leaves the clone edited, and the next sync writes the edit back. To really undo: `git -C ~/.hermes/skills-library checkout -- .` and then `git apply` the reverted patch.

Verified 2026-11-09 in `sync.sh` (`copy_in`, `save_lib_patch`); found by the dream-trim and dream-pass planners.
