---
name: designer-feedback-mini
description: "Justin 2026-11-02, DJ Trees UI-designer feedback: one job per problem, mini chain planner → builder → ONE reviewer → ONE verification → merge, every fix a general rule"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8e80bfe0-369d-4e32-84a6-8d63e5215658
  modified: 2026-11-02T16:58:23.258Z
---

Justin, 2026-11-02, on his UI designer's Figma feedback for the DJ Trees page (a few desktop items, many phone items):
"Because these are small fixes and general rules, just run a single reviewer and one verification … For every fix I
want a planner, then the builder, then a reviewer, then a verification, and then we merge. So for every problem, for
mobile or desktop, you'll run a planner agent, a builder, and all that."

**The rule:** each reported problem is its own job (own name, worktree copy, plan, ACs). Chain: planner → builder →
one fresh reviewer → one verification (blind AC check) → merge into local `main` (BUILD bump, build, push), the Mini
pipeline with no second review round. Every fix changes the plugin's logic for the whole class of designs, never the
DJ Trees file alone ([[plugin-first]]).

**His answers the same day:** if the one reviewer finds a real bug, a fixer just fixes it and the verification checks
it (no re-review; `ac-check.sh --reviews` will refuse the fix commit, so run it without `--reviews` and say so). Jobs
are never combined: each branches off `main`, runs in parallel, and rebases onto the newest `main` before its merge.
Live page: djtreeservice.staging.growithgro.com/home/. Debug file (build 2026-10-31.2, "DJ Tree Service — Homepage |
Evansville Final Content", 1440 wide), read-only copy for every planner:
`~/.hermes/plans/figma-to-bricks/evidence/djtrees-designer/figma-to-bricks-debug-djtrees-home.json` (this machine
only; evidence folders don't sync).

**Planner's call stands (Justin, 2026-11-02, leaving):** "Going forward whatever the planner agent recommends go
with it": take every ⭐ answer and run each job to merge without asking; report rulings at the end.

**Why:** small fixes; he wants speed without dropping the plan/review/verify roles. **How to apply:** standing
auto-go still applies; ACs are still proven before merge. Related: [[review-round-cap]], [[run-without-stopping]].

**Outcome (2026-11-03):** all 12 notes merged (builds 2026-11-02.1–.4 and 2026-11-03.1; Build .5 is the importer's),
plus one extra job found while planning (faded pictures). What made it work: a merge train (each job rebased onto the
previous, one BUILD commit per batch), and the blind auditor in every job, which caught a defect the reviewer and
verifier both missed (it turned out to be the test renderer's linked-Image markup). Paste checks 3ct, 3cl, 3cq, 3cu, 3cn,
3cv, 3cj, 3cr, 3co, 3cp, 3cm, 3cs, 3ck are owed by Justin.
