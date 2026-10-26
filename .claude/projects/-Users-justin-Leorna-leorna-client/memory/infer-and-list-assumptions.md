---
name: infer-and-list-assumptions
description: "When a story's dependency or a team answer is missing, make a reasonable reversible inference and list it as a short plain assumption in the PR; never infer facts that are the acceptance criteria"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e54e7fd6-b3b2-43ef-895f-ae478c9748f1
  modified: 2026-09-21T16:51:45.832Z
---

When a story is blocked on an unanswered team question or an unlanded dependency, do not stall and do not keep re-asking Justin. Make the smallest reasonable, reversible inference, build against it, and list it in a short, plain "Assumptions" section of the PR text (a few one-line bullets, not an essay).

**Why:** On 2026-09-21 every free intern card depended on unlanded work. Justin asked "can we not make a reasonable guess or infer something?" and later "in the PR we will have a simple assumption". He also kept a design gap (pack items have no target-tool field) in the assumptions while choosing to raise it with Christian himself.

**How to apply:** Inferable: which repo, interface shape, naming conventions, anything cheap to rename later. NOT inferable: ClickUp IDs (they go in commits and `delivery/stories.json`), and external facts that ARE the acceptance criterion (e.g. a tool's real config layout) — get those from official docs and, where the tool is installed, prove them against the real tool as a required step, not an optional one. Related: [[consistency-over-local-fixes]], [[leorna-workflow]].
