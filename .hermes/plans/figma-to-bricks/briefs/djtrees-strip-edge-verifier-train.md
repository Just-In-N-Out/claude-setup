# Role: VERIFIER — djtrees-strip-edge (merge-train car 3)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it, with these
differences: review-1's P2 was fixed (R1-1, hand-placed strip cards); the job was then rebased onto main's build
commit (HANDOFF-only conflicts). Prove every AC on the rebased head, confirm R1-1 is closed, judge the rebase
(report-only).

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** before every browser test, snap or Chrome
probe, wait until no `node --test.*test/(browser|web)` and no `chrome-linux64/chrome.*--headless` process runs (check
from a script file; `pgrep -f chrome-f2b` never matches). One Chrome job at a time.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-strip-edge` (write `E/verifier/`, fresh).
- Approved plan: `E/plan-approved.md` (AC1–AC6 by test/receipt; AC7 live, 3cu).
- **head** `779c830c` (branch `train-strip-edge`; `git rev-parse train-strip-edge` for the full SHA), **base** =
  `9a2a9667d1100cf5e8b4e66a380be661841114f5` (main, Build 2026-11-02.2). Use your own worktree, detached at the head, as
  `ac-check --repo` (it is the same commit).
- Finding closed? `E/review-1/review.json` R1-1 and `E/fixer/` (witness `E/review-1/r1-1-free-track.log`; the fixer's
  `r1-1-free-track-fix*`). Rebase: `E/rebase/conflicts.md`; `git range-diff` against the fixer's head `3a2f915`.
- Ticks as a JSON string (`s.site = JSON.stringify({header: true, footer: true})` or `replay --site`).
