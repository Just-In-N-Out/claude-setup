---
name: leorna-no-reverify-while-main-moves
description: "Once a Leorna story is ALL ACCEPTED, don't re-run verifier/auditor for each bring-main-in while sibling PRs are still merging"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d0decd7d-6c54-4d08-9299-999afb0cbf85
  modified: 2026-10-29T07:12:56.000Z
---

After a Leorna story has passed verifier, blind auditor and `ac-check.sh` once, and sibling PRs are still to merge into main, don't re-run the verifier, auditor or `ac-check.sh` after each "bring main in". A fixer merges main (plus any decided changes), runs the gates and each AC test by name on its head; the "make a PR" step re-runs the gates on the pushed head (`leorna` 7.3).

**Why:** Justin, 2026-10-28 (86bcm901j, siblings #95/#96/#97 merging one by one): "We're gonna have to move main twice, so honestly, don't run it again if you already ran it before, like the fixers and the Auditors and all that. If you didn't run them at least once, just run them again." Repeating the full loop per main move costs a verifier + auditor round each time for record-file conflicts.

**How to apply:** roles that never ran for the story still run once. Once the last sibling has merged, the head Justin will merge gets a fresh verifier, blind auditor and `ac-check.sh` again (901w, 2026-10-28: "i want to merge but you need to rerun verification"). Once the last sibling has merged, the full verifier → blind auditor → `ac-check.sh` runs again, on the PR's head after the PR opens (Justin, 2026-10-29: "After you put out the PR, run verifications to make sure everything's good"). Until then, keep the ac-check acceptance recorded for the head it ran on, and say in the PR Test Plan which head the gates and AC tests ran on. If a bring-in needs a real code conflict resolution (not record files), say so and ask whether to verify again. Related: [[leorna-update-main-before-worktree]].
