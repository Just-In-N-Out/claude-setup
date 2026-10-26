---
name: stop-and-show-diff
description: "Do not push or open a PR unless explicitly asked; after implementing, stop when the gate passes and show the diff"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e54e7fd6-b3b2-43ef-895f-ae478c9748f1
  modified: 2026-10-21T00:55:00.000Z
---

**Status 2026-10-20 (Justin, via Hermes):** an agent may now open the PR, but only when Justin says "make a PR" (or "open the PR"): push the `feat/` branch and run `gh pr create` with the plain-style text, as `Justin-Leorna`. "push" alone still means push only. Still never merge into `main` (local or remote), never merge a PR, never push or open one unprompted. Story work stays on its `feat/` branch until then.

Branch and commit locally on `feat/<clickup-id>-<short-description>` from updated main, never commit to main, never push or open a PR on my own initiative. When the work is done and the gate passes, stop and show the diff; Justin decides when to push and opens PRs himself (he wants PR text handed to him to paste, not created by me).

**Why:** Stated explicitly on 2026-09-18 in the control-plane repo ("Do not open a PR and do not push. Stop after make check passes and show me the diff."). Applies to every Leorna repo.

**How to apply:** End implementation turns with `git diff --stat origin/main..HEAD`, the key hunks and the validation results. Offer PR text as a paste-able block: Summary paragraph, one line per file/area, Test Plan with results, and a short plain Assumptions list. No AI attribution lines. See [[leorna-workflow]].
