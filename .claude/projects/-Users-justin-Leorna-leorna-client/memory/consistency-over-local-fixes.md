---
name: consistency-over-local-fixes
description: Do not change a repo-wide pattern inside one feature story; keep the feature consistent and raise the pattern change separately
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e54e7fd6-b3b2-43ef-895f-ae478c9748f1
  modified: 2026-09-21T16:51:33.862Z
---

When a review or my own reading flags behaviour that is the repo's existing pattern, do not fix it only inside the feature being built. Keep the feature consistent with its siblings and note the pattern change as a follow-up.

**Why:** Justin said (2026-09-18, control-plane pack story) that a feature story should not decide repo-wide behaviour unilaterally. In the client this also covers the preserved `toolconnector.Connector` API that AGENTS.md says not to change.

**How to apply:** Classify findings as "this branch introduced it" (fix here) vs "pre-existing pattern" (list under follow-ups). Design gaps in someone else's area go in the PR's Assumptions list and Justin raises them with the owner himself. See [[leorna-workflow]].
