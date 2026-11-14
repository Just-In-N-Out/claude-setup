---
name: finish-before-starting
description: 2026-11-14 lesson — 17 agents at load 60–80 and jobs stacked on unmerged heads merged one job in 12 h; finish near-merge jobs first, hold new starts above load ~40, don't stack builds on unmerged heads
metadata:
  type: feedback
---

On the night of 2026-11-13/14 I kept up to 17 agents running (7 builders started early on unmerged heads, plus reviewers, fixers,
verifiers, auditors). Load ran 40–80, every Chrome suite ran several times slower and flaked under load, so verifiers and reviewers
reran files; and because builds sat on unmerged heads (site-no-div → site-shared-styles → importer-parity → forms-wpforms…), each job
could merge only after the one under it. Result: **one merge (Build 2026-11-14.1) in 12 hours.** Justin: "Only one job merged in 12 hours
wow ok", then asked that this be written down so agents don't start too many and fail.

**Why:** throughput is merges, not busy agents. Load slows every agent at once, and a stack of unmerged heads turns parallel work into a
queue with rebases at each step.

**How to apply (orchestrator):**
- **Near-merge first:** a job in review, verification or audit gets the machine before any new builder starts.
- **Hold new dispatches while load (1-min, `/proc/loadavg`) is above ~40**, and keep at most ~3 Chrome-heavy roles (verifier, auditor, a
  builder's close gates) running at once; check load before every dispatch. This was already in [[run-without-stopping]] (2026-11-11) and
  I didn't follow it.
- **Don't build on an unmerged head** unless the job underneath is already accepted (verifier and auditor clean); otherwise wait for its
  merge. Plans that say "base: main once X merges" mean that.
- "No agent cap" (Justin, 2026-11-11) still stands; this is about order and load, not a fixed number. Related: [[keep-agents-busy]].
