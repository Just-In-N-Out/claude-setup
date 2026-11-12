# Role: reviewer (round 3, a delta: the move onto site-scroll-lock's main; report only): site-sticky-header

You are a fresh reviewer (**Opus 5.5, high**). Review only; change nothing, commit nothing, start no agents; never load any live
site; never write to any WordPress site. **Time box: 30 minutes.** Importer rule: P0–P2 only for bugs a real paste hits, with a
concrete scenario; edge cases P3.

## What happened
site-sticky-header was accepted on `c370ffa23f5157776d5c7bb710f6a4c9608b7cb6` (base `02481763`). It was rebased onto main
`11f07742` (Build 2026-11-11.5: media-clickable + site-scroll-lock) as branch `site-sticky-header-final`, head
`dac22907cfea2d79df9d27ef794e3521eb217e97`. Conflicts: `src/core/site/parts.ts` (two hunks, resolved by the plans' rule: names
reset, lock, stay; roots lock, stay (header only), fonts — with `rootClasses(i)`, outside the hunk, now starting with
`lockClass(classId)`) and `docs/HANDOFF.md`. A new stack commit `dac22907` makes `tools/site-sticky-header-sums.ts` strip the lock
too. Record: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/stack/` (`conflicts.md`, `parts.resolved.ts`,
`range-diff.txt`, sums logs). Proven merge to compare: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/builder/stack/parts.merged.ts`.

## Check (your own worktree, `git checkout --detach dac22907…`)
1. `parts.ts`: both jobs' behaviour kept; every part root holds the lock first; the header root holds lock then stay; fonts last;
   one class id each; equal to the proven merge.
2. The story's diff outside `parts.ts`, HANDOFF, the slider test and the sums helper equals the accepted head's (hunk numbers
   removed: `sed -E 's/^@@ -[0-9,]+ \+[0-9,]+ @@/@@/'`).
3. The sums helper change: strips the lock the way `site-slider-unchanged`'s `unlockedParts` does; a part with no lock fails; run
   it with `--base 11f07742` → 8/8 equal main's sums; `--write` leaves the file unchanged.
4. Together: on the code-page fixture drawn as Bricks 2.4.2 at 1440 and 390, the header sticks after a scroll, nothing moves
   sideways, and with a No-scroll Offcanvas open the page and header hold (both classes present). Run
   `test/web/site-sticky-header.test.ts` and `test/web/site-scroll-lock.test.ts` alone under 4G scopes.
5. HANDOFF: both sections whole, no line lost or doubled.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/review-3/review.json` (round 3, a delta from `c370ffa2`;
full SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
worktree> --base 11f07742 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header` (full SHA of 11f07742 from `git
rev-parse`). Load `requesting-code-review` and `code-review-practice`; read the project skill's `references/testing-pitfalls.md`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sh3/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; every Chrome run under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; write scripts with the Write tool, run as `bash <file>`; `git -C
<absolute path>`. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings or "none"; each check; `verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these
skill_lessons now.`
