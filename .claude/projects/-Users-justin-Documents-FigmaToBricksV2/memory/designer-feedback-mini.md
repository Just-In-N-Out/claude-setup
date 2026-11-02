---
name: designer-feedback-mini
description: "Justin 2026-11-02, DJ Trees UI-designer feedback: one job per problem, mini chain planner → builder → ONE reviewer → ONE verification → merge, every fix a general rule"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8e80bfe0-369d-4e32-84a6-8d63e5215658
  modified: 2026-11-02T16:51:36.699Z
---

Justin, 2026-11-02, on his UI designer's Figma feedback for the DJ Trees page (a few desktop items, many phone items):
"Because these are small fixes and general rules, just run a single reviewer and one verification … For every fix I
want a planner, then the builder, then a reviewer, then a verification, and then we merge. So for every problem, for
mobile or desktop, you'll run a planner agent, a builder, and all that."

**The rule:** each reported problem is its own job (own name, worktree copy, plan, ACs). Chain: planner → builder →
one fresh reviewer → one verification (blind AC check) → merge into local `main` (BUILD bump, build, push), the Mini
pipeline with no second review round. Every fix changes the plugin's logic for the whole class of designs, never the
DJ Trees file alone ([[plugin-first]]).

**Why:** small fixes; he wants speed without dropping the plan/review/verify roles. **How to apply:** standing
auto-go still applies; ACs are still proven before merge. Related: [[review-round-cap]], [[run-without-stopping]].
