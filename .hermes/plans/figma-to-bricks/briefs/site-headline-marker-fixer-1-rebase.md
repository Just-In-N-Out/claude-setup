# Role: fixer (move onto importer-parity's newest head): site-headline-marker
Fresh fixer, **Opus 5.5, high**, about 2.5 hours. First read and follow the machine and safety rules in /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md (it's written for reviewers: you
DO commit, to your own branch only). Load `engineering-best-practices`, `test-driven-development`, `git-commit-rules`; the project skill
directly with `references/testing-pitfalls.md`; both `repeat-mistakes.md` first. Plain `git commit -m`, no author override, no AI or
Co-Authored-By lines, never CLAUDE.md; don't push; don't bump BUILD; don't edit the main folder; never bare `git stash`. Files only with
Write/Edit (no heredocs, no `sed -i`). `git diff --check` before every `git add`/`rebase --continue` in a conflict. TMPDIR ~/.cache/shf1/t1.

## State
- Plan (read-only): /home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/plan-approved.md (AC1–AC14; AC14 live). Review 1 clean on head **75392d9d7cf8e350fdef3b6d805b25ff96916dc4** (branch
  `site-headline-marker-build`) on importer-parity's older head `a049bb4baa7329b8184cb3777e3ffabf47e1252a`.
- importer-parity is now **34e02b9062596891d33377e2eb829c1ffebee046** (branch `importer-parity-fix4`, on main `e2fc35aaa6b7e3a662d0c3cce37ec636495a5405`
  with shared-palette's site colours), in its final review.

## Do
1. `git checkout -B site-headline-marker-fix1 75392d9d…`; `git rebase --onto 34e02b90… a049bb4b… `. Record conflicts in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/fixer-1/conflicts.txt`.
   Review 1's merge-tree found, all keep-both: `src/core/site/convert.ts` (ConvertOptions: `siteColours`, `paletteFile` beside `marker`),
   `src/core/site/elementor-fold.ts` (`Folded`: fix 4's `byId` beside `markers`, type and return), `src/core/site/share.ts` (`pageInk` gains
   `site: SiteColours`; the marker-colour loop stays inside).
2. After the move (each its own commit, test first where it's code):
   - the headline branch's two `fold()` calls go through fix 4's by-id name count;
   - the marker colour goes through `ink.css`: with `--colours` it links the site's own palette variable; AC8's test gains one case with
     site colours (its regex `var(--color-<hex>` holds only without them);
   - record the AC11 and AC12 pin files again on the new base (fix 4 moved pastes), with the old oracle, a mutant that drops `marker: false`;
   - merged jobs' story pins that byte-pin `src` (`test/fixtures/later-jobs.ts`) allow this job's new `src/core/site` files by name.
3. Gates on the moved head: both typechecks, `npm run check` (8G); every AC's test by plan name (B-Dry/scan ones in the namespace; others with
   the network) into `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/fixer-1/receipt-<head7>.log` (`HEAD=` first, `EXIT=` last); pins with `F2B_PIN_BASE=1 F2B_STORY_PINS=1`; AC13 on
   Justin's scan. Ledger: a "Fixer 1 (move)" section. Stop at `ready-for-review`.
4. Review 1's P3s are in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/follow-ups.md`; don't fix them.

Report (as text): new head (full SHA) and its base; conflicts; each change RED/GREEN; gates; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
