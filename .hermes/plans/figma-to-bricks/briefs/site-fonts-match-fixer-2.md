# Role: fixer (after the rebase): site-fonts-match — AC7's base sums on the new main

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development`, the project
skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first. Never load bdryswi.com or any live site; never write to any WordPress site; touch nothing under
`~/Downloads`. Commit to your branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`.
Plain `git` in your own worktree, each command alone (never `git -C` the main folder). Change no file under `src/` or `tools/`.

## State
site-fonts-match (accepted on `dde55059`, base `e61c0ca0`) was rebased onto local main `56b5076b5c1d665abd5bad4bcc78861739cc01e9` (Build
2026-11-12.1) → branch `site-fonts-match-final`, head `45b9c3e0bb66a76f579e4b998c5fb5f0dc1c86a5` (source conflicts in `src/core/site/convert.ts`
and `parts.ts` resolved, both kept; a test-only re-pin commit). Records: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/rebase/`
(`conflicts.md`, `receipt-45b9c3e.log`, `ac7-four-trees.log`); trees `~/.cache/sffr/trees/` (main, old base, old head).

AC7's test ("AC7 a capture read before this build pastes its fonts as before") fails on the new head only because its committed `BASE_SUMS`
are e61c0ca0's: main's site-native-structure moved the 3 `elementor` sums (header, page, footer); new head equals main on all 9.

## Do
1. Your own worktree: `git checkout -B site-fonts-match-fix2 45b9c3e0bb66a76f579e4b998c5fb5f0dc1c86a5`.
2. Verify the claim yourself (main 56b5076b's own tree vs head, all 9 sums). Regenerate only the 3 `elementor` entries with the builder's own
   generator (`~/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/builder/scripts/base-sums.ts`) run on a fresh `git archive` of
   `56b5076b`; record the base commit in the test's header comment; the `plain` and `failed` sums unchanged. RED (before) / GREEN (after) on
   head; a mutant of head's AC7 guard (`carriedFamilies` ignoring `fontsRead`) still fails it; the test passes on main's own tree with
   head's test file (it is a keep-as-before AC). One commit, test-only.
3. A new receipt on your head: every AC1–AC8 test by plan name (plan:
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/plan-approved.md`) into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok`, `EXIT=` last,
   skipped 0); `npm run check` (8G scope). Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sff2/t1`); scripts under `~/.cache/sff2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s.

## Report (as text)
Branch, head; the sums before/after and the tree they came from; RED/GREEN/mutant; receipt path and last line; gates; `skill_lessons[]`,
ending with: `MAIN SESSION: check and save these skill_lessons now.`
