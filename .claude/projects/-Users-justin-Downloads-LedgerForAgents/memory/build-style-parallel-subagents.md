---
name: build-style-parallel-subagents
description: "Justin chose parallel subagents for independent implementation slices, with the controller committing per slice"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f79f5b9f-5a9e-4fdd-b5ea-707da1d9ed2d
  modified: 2026-09-13T20:33:30.832Z
---

When a plan has independent slices that share no files, Justin prefers they be built by parallel subagents rather than sequentially by one agent, even though it costs more tokens.

**Why:** Asked explicitly during the Ledger build (September 2026) and chose "Parallel subagents for Phase 2 (Recommended)" over "Sequential, single agent". Speed mattered more than token cost.

**How to apply:** Offer the parallel option when a spec or plan defines file-disjoint slices. Have implementers not commit (git index contention); the controller commits each slice with `git add <owned files>` after review. See [[ledger-project-notes]].
