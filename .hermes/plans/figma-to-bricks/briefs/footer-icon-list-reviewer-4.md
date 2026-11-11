# Role: reviewer (round 4, a short delta: the HANDOFF-only conflicts of the move onto Build 2026-11-11.3; report only): footer-icon-list

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
**Time box: 20 minutes.** Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress
site. Never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

## What happened
footer-icon-list was accepted (`ac-check.sh --reviews`: READY FOR THE USER 9 of 10) on
`fb26a529ee24bfa97f9b563756eb2698e826c328` on main `e16d3d1e`. Main moved to
`0248176342c662b821629d462f4d15a2a2a1df98` (Build 2026-11-11.3, capture-refused-styles: no source file in common). A
finisher rebased it as branch `footer-icon-list-final`, head `731707c5e84f9495e152b60d302fe640f6f06554`: conflicts **only
in `docs/HANDOFF.md`**, at three commits (`8e42541c→ef816ba5`, `05009f88→ebe0abd2`, `fb26a529→731707c5`); it reports
the code identical (outside HANDOFF `main..HEAD` equals `e16d3d1e..fb26a529`, 23 files) and HANDOFF's added and removed
lines matching. A rebase that resolved conflicts is reviewed before the receipts can carry over.

## Check (do each yourself)
1. In your own worktree: `git checkout --detach 731707c5e84f9495e152b60d302fe640f6f06554`; confirm a clean status.
2. Outside `docs/HANDOFF.md`: `git diff 02481763 731707c5 -- . ':(exclude)docs/HANDOFF.md'` equals `git diff e16d3d1e
   fb26a529 -- . ':(exclude)docs/HANDOFF.md'` after dropping `^index ` lines (byte for byte), and every path's blob at
   the new head equals the old head's blob for this job's files and main's blob for main's.
3. HANDOFF: main's capture-refused-styles section and its 3dy check-list entry are whole and exactly as on main; this
   job's section first; no line lost, doubled or reordered; no conflict markers; no `<… id at merge>` placeholder but
   this job's own; the stray staging-fit-cancels heading the job removes is gone as on the old head.
4. `npm run check` (8G scope) on a `git archive` of the new head: exit 0.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/review-4/review.json` (round 4, a delta: the move
from `fb26a529` on `e16d3d1e` to `731707c5` on `02481763`; `head` the full SHA), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
0248176342c662b821629d462f4d15a2a2a1df98 /home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list`. Read
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first; load
`requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fr4/t1`). A `git
archive` scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink `node_modules` in). One plain git command per call, `git -C <absolute path>`; multi-step steps in a
script file run with `bash <file>`. Use `tail -n 3`. Waits under 115 s. One final report.

## Report (as text; only review.json is written)
Findings one line each or "none"; the code-identity proof; the HANDOFF check; `npm run check`; `verdict`; `ac_status`
(the move changes no AC: say so with the proof); `skill_lessons[]`; ending with: `MAIN SESSION: check and save these
skill_lessons now.`
