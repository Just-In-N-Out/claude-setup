---
name: keep-agents-busy
description: "Don't park jobs waiting for another job's merge; rebase onto an accepted head early so several agents keep working"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e44fb4fd-1fa0-420d-83da-4c2f613513cb
  modified: 2026-11-10T02:48:24.625Z
---

Don't leave jobs idle waiting for an earlier job to merge. When job B depends on job A and A's head is already reviewed and accepted (blind auditor clean), rebase B onto A's accepted head right away and keep building B; if A then fast-forwards into main unchanged, B is already in place.

**Why:** 2026-11-04, four designer-note jobs: I held icon-buttons and rich-text until element-link merged, leaving one agent running; Justin asked "why is there only one agent working?".

Again 2026-11-15 ("why are we running one agent"): five accepted jobs sat waiting while importer-parity's last test-only fixer ran; the dependents were moved onto its test-only fix head only after he asked. A blocker whose remaining fixes are test-only is head enough to move onto: move each dependent there early, then pure-rebase onto the final head.

**How to apply:** after each agent returns, check every job's next step; start any that only waits on a merge by rebasing onto the accepted branch head. Related: [[run-without-stopping]], [[git-and-parallel-agents]].

**But final rechecks go one job at a time, in merge order (Justin, 2026-11-09):** "You are running 3 blind rechecks on the merged code then when one merges then you gonna have to run it again on the other two so just run one now." When several accepted jobs wait to merge, run the verifier and blind auditor for the next job to merge only; after it merges, bring the next job onto the new main and check that one. Building, fixing, reviewing and rebasing still run in parallel; only the full recheck + blind check (the expensive, merge-sensitive steps) are serial. (I had stacked three jobs to check side by side and merge together, and told him so once; asked in a question the same evening, he chose **"One at a time"** over "Together".) For agents communicating he chose **built-in messages** over Leorna's Telepathy (`~/Leorna/telepathy`, a Rust library needing CortexOS, not wired to Claude Code): when main moves under an accepted job, SendMessage the same verifier and auditor to re-run their saved scripts on the new head instead of starting fresh agents (they keep the model they started on).
