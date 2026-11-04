---
name: keep-agents-busy
description: "Don't park jobs waiting for another job's merge; rebase onto an accepted head early so several agents keep working"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e44fb4fd-1fa0-420d-83da-4c2f613513cb
  modified: 2026-11-04T20:28:21.155Z
---

Don't leave jobs idle waiting for an earlier job to merge. When job B depends on job A and A's head is already reviewed and accepted (blind auditor clean), rebase B onto A's accepted head right away and keep building B; if A then fast-forwards into main unchanged, B is already in place.

**Why:** 2026-11-04, four designer-note jobs: I held icon-buttons and rich-text until element-link merged, leaving one agent running; Justin asked "why is there only one agent working?".

**How to apply:** after each agent returns, check every job's next step; start any that only waits on a merge by rebasing onto the accepted branch head. Related: [[run-without-stopping]], [[git-and-parallel-agents]].
