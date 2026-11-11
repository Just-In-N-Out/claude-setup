# Role: reviewer (round 6, a delta: one pins commit; report only): site-native-structure

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never load any live site; never write to any WordPress site. **Time box: 20 minutes.**

## What to review
Branch `site-native-structure-stack7`, head `f86ab19deeef19de5a9ed4a1306b0c99d94eb33e`, one commit on the review-5-clean
head `2a38027faad44e16bcb885d264317d8be9df6f57`; base `731707c5e84f9495e152b60d302fe640f6f06554`. The commit re-records
`test/fixtures/site-native-pins.json` (AC13's 144 plain-route pins) from base `731707c5` with the pins' own generator,
because main's site-menu (Build 2026-11-11.2) reworded one note of the fixture page's header and moved 8 `pageCode`
hashes; it also updates the test's comment and skip message. Approved plan (amendment 2):
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`. Fixer receipts (read, don't
trust): `evidence/site-native-structure/fixer-5/`; planner receipts: `evidence/site-native-structure/planner-amend-2/receipts/`.

## Check
1. In your own worktree: `git checkout --detach f86ab19d…`; `git diff 2a38027f f86ab19d --stat` touches only the pins file
   and that test's text; no source.
2. The new pins equal base `731707c5`'s own output: regenerate them yourself on a `git archive 731707c5` tree with
   `test/unit/lib/site-pins.ts` (planner's `receipts/scripts/pins-dump.ts`) and `cmp`; and head's own output equals them
   (the job changes nothing on the plain route): the AC13 test by name with `F2B_PIN_BASE=1` passes on head, fails on
   `2a38027f`.
3. The 8 moved keys moved only by site-menu's note (one leaf) — not a hash that hides a real plain-route change.
4. The test can still fail: one mutant of your own (a one-character change in the plain route's output path) makes it
   `not ok`.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-6/review.json` (round 6, a delta from
`2a38027f`; `head` the full SHA), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
--repo <your worktree> --base 731707c5e84f9495e152b60d302fe640f6f06554 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`.
Load `requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sr6/t1`); a `git
archive` tree needs main's `node_modules` symlinked; piped/chained git commands may be refused (script files, `bash
<file>`; `git -C <absolute path>`). Each test run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings or "none"; the regenerate-and-cmp proof; the mutant; `verdict`; `ac_status` (AC13); `skill_lessons[]`, ending
with: `MAIN SESSION: check and save these skill_lessons now.`
