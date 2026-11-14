# Role: reviewer (round 2, DELTA review of the rebase onto main; report only): bricks-icons-site

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`,
extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site (every Chrome that draws a site
capture or paste with `SITE_OFFLINE`); never write to any WordPress site; touch nothing under `~/Downloads`. Keep it to about 20 minutes.
This is the notes-only rebase rule (Justin, 2026-11-11): a short delta review plus the finisher's AC receipt replace a new verifier and auditor.

## Inputs
- Accepted head `a06ed92d887bd960fd3dc3df33fa7c2a620fa8f2` on base `cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4` (ac-check READY FOR THE
  USER, 4 of 5; AC5 live). Rebased by the finisher onto main `84722938b32c82e2dc5041bda6383ac12bf7793d` as branch `bricks-icons-site-final`,
  head **`acaec88522c192059769eb8d924cc6a57785596b`** (7 rebased commits; a HANDOFF-only conflict; plus `acaec885`, test-only: the story pins
  `media-avif-untouched` and `site-import-figma-unchanged` allow `src/core/site/icons.ts` (A) and `src/core/site/media.ts` (M)).
- Finisher's records: `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/rebase/` (`conflicts.txt`, `range-diff.txt`,
  `pins-*.log`, `receipt-acaec88.log`).

## Check
1. Outside `docs/HANDOFF.md` and the two pin files, `git diff 84722938..acaec885` equals `git diff cf4f887d..a06ed92d` byte for byte (hunk
   numbers and index lines removed): the code is the accepted code.
2. HANDOFF: the diff from 84722938 deletes 0 lines; its added lines are this job's own, its section first, main's site-no-div section and
   check list entry untouched; the job's `<… at merge>` placeholders kept for the after-merge finisher.
3. The pin change: it allows exactly `git diff --name-status 84722938...acaec885 -- <the pinned paths>`; a stray file and a one-byte change
   still fail both pins (`F2B_STORY_PINS=1`, the pins' named base archive 56b5076b with main's `src/shared/build.ts` laid over it).
4. The receipt: `HEAD=acaec885…` first, AC1–AC4 `ok` by their plan names (`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/plan-approved.md`),
   skipped 0, `EXIT=0` last.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/review-2/review.json` (round 2, scope delta, `from`
`a06ed92d887bd960fd3dc3df33fa7c2a620fa8f2`, full SHA `head`, a `note` saying what you checked), in review-1's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
84722938b32c82e2dc5041bda6383ac12bf7793d /home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site` and quote its last line; if it
asks for another scope, say so. Load `requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bisr2/t1`); scripts under
`~/.cache/bisr2/s/`; memory scopes `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo
(set `GIT_DIR`). Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
