# Role: VERIFIER — djtrees-top-align (merge-train car 4)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it, with these
differences: review-1's P2 (nested painted button) was fixed and already verified on the old head
(`E/verifier-fix1-d5e3eac/`, READY); the job was then rebased into the merge train (HANDOFF-only conflicts). Prove every
AC again on the rebased head and judge the rebase (report-only).

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** before every browser test or Chrome probe wait
until no `node --test.*test/(browser|web)` and no `chrome-linux64/chrome.*--headless` process runs (check from a script
file). One Chrome job at a time.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align` (write `E/verifier/`, fresh).
- Approved plan: `E/plan-approved.md` (AC1–AC7 by test/receipt; AC8 live, 3cn). Fonts for AC6: inject the DJ fonts.
- **head** `ea1a46ed4d870079dfbb870a5c19b78bfcc37236` (branch `train-top-align`), **base** = train car 3
  `git rev-parse train-strip-edge` (djtrees-strip-edge on main `9a2a9667`). AC6/AC7's "only X differs" are judged
  against that base. Use your own worktree, detached at the head, as `ac-check --repo`.
- Rebase: `E/rebase/conflicts.md`; `git range-diff 1aef12f..d5e3eac <base>..<head>` changes no job line.
- Ticks as a JSON string.
