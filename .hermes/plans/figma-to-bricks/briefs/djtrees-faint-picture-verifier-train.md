# Role: VERIFIER — djtrees-faint-picture (merge-train car 5)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it, with these
differences: review-1's P2 (a video still's fade leaking into hover/Motion) was fixed (`E/fixer/`), and the job was then
rebased into the merge train (HANDOFF-only conflicts). Prove every AC on the rebased head, confirm the P2 is closed with
your own probe (a `Video: https://…` layer whose still is a faded image fill, with a Motion track and a hover variant,
the instance alone marked too), and judge the rebase (report-only).

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** before every browser test or Chrome probe wait
until no `node --test.*test/(browser|web)` and no `chrome-linux64/chrome.*--headless` process runs (check from a script
file). One Chrome job at a time.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faint-picture` (write `E/verifier/`, fresh).
- Approved plan: `E/plan-approved.md` (AC1–AC6 by test/receipt; AC7 live, 3cv).
- **head** `5b312ae24ebe2ad7138d604bc82ca17a396e7032` (branch `train-faint-picture`), **base** = train car 4
  `ea1a46ed4d870079dfbb870a5c19b78bfcc37236` (judge AC5/AC6's "only the FAQ tree's `_opacity` differs" against it).
  Use your own worktree, detached at the head, as `ac-check --repo`.
- Rebase: `E/rebase/conflicts.md`; `git range-diff 1aef12f..f2e444c <base>..<head>` changes no job line.
- Ticks as a JSON string.
