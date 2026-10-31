---
name: review-round-cap
description: "Justin 2026-10-31: agents iterate until their goals and ACs are accepted, then 1-2 bug-fix rounds for major issues, edge-case loops at most 3 rounds; replaces 'no round cap' for his pipeline jobs"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 519648e7-1ba1-46ba-a0a3-91e300b908f4
  modified: 2026-10-31T20:08:16.561Z
---

Justin, 2026-10-31, after the website importer's first two jobs ran 10 and 7 review→fix rounds: "Make it so agents
keep iterating until they hit their goals, then run one to two rounds of bug fixes to ensure no major issues. Loop
over edge cases, up to three rounds, covering the main ones. Hit their goals and accept acceptance criteria." (Earlier
the same day: "I need this to be built fast … stop the fixes and just keep building.")

**The rule for every pipeline job:**
1. **Goals first, no cap:** the builder (and fixers) keep going until every AC passes, and the job merges only once
   its ACs are accepted (verifier + blind auditor + `ac-check.sh`). A failed AC is always fixed and re-checked.
2. **Then 1–2 review→fix rounds for major issues** (P0/P1, and P2s that break normal use).
3. **Edge cases: at most 3 review→fix rounds in all**, covering the main ones (realistic inputs on real sites). After
   round 3, whatever a review still finds goes to `follow-ups.md` and HANDOFF "Deferred", and the job moves to the AC
   check and merge. (My reading: 3 rounds in total including the 1–2 bug rounds; ask him if it should be more.)

**Why:** the uncapped loop kept finding ever-smaller edge cases while 9 of 11 jobs waited; he wants speed, but with
the goals met and no major bugs. **How to apply:** this overrides the global CLAUDE.md "no round cap" for review rounds,
not for AC acceptance. Tell him early when a loop is down to small edge cases. Related: [[run-without-stopping]],
[[website-importer-paused]].
