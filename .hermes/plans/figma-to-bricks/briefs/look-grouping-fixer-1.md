# Role: fixer 1 (review 1 findings + Justin's naming ruling): look-grouping
Fresh fixer, **Opus 5.5, high**, about 2.5 hours. First read and follow the machine and safety rules in /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md (written for reviewers: you DO
commit, to your own branch only). Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`; the project skill directly with `references/testing-pitfalls.md`; both
`repeat-mistakes.md` first. Plain `git commit -m`, no author override, no AI or Co-Authored-By lines, never CLAUDE.md; don't push; don't
bump BUILD; don't edit the main folder; never bare `git stash`. Files only with Write/Edit (no heredocs, no `sed -i`). TMPDIR ~/.cache/lgf1/t1.

## State
- Plan (read-only): /home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/plan-approved.md (AC1–AC23; AC23 live). Head **04ec1e785415f435f22ebdda17d1fc82fd332b0d** (branch
  `look-grouping-build`), base **425d9ebf09e931f275307e013c9caa781df531ca** (built early on importer-parity + plugin-parity + shared-palette;
  don't move it now: it is rebased after those merge).
- Review 1: /home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/review-1/review.json and its probes beside it (`two-pages-names-probe.txt`, `site-copies-web.log`).

## Fix, each test first (RED on 04ec1e78, GREEN, a one-line mutant killed)
- **R1-1 + Justin's ruling** (/home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/review-1/justin.json, "By look, same everywhere"): a shared class is named by its look only, never by its
  elements' words: the plugin's `look:<print>|<slug>` key and name (`src/core/emit/looks.ts:182-187`) drop the words part, so one look has
  one class name and id on every page, whatever words its elements hold; the importer the same where it names classes. This replaces the
  plan's Q5 A / C4 naming: write an "Amendment (Justin, 2026-11-15, names by look)" block under the AC it changes (AC21, and C4) in the
  repo's plan copy `docs/plans/2026-11-13-look-grouping.md` and the same text in `/home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/fixer-1/amendment.txt` (the main session re-issues
  plan-approved.md from it). AC21's test converts a second page where the call class also holds a Button of other words and asserts the call
  Buttons' class name and id equal the first page's. Remake the name-dependent sums (`plugin-copies-base.sha256.json`, copies-names
  expectations) by their own tools, proving copies off still equals the base.
- **R1-4** `test/web/site-copies.test.ts:69`: AC7's forced-focus reading after a fixed 450 ms wait fails under load against
  `transition: all .3s`: wait for the transitions to finish (`getAnimations()` settled or `transitionend`), not a fixed time; prove it
  passes 3 of 3 at load and still fails a mutant that changes a copy's look.
- R1-2, R1-3 are P3 (/home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/follow-ups.md): don't fix.
- Note for later (no code now): plugin-parity's coming Theme Style fix moves a button look's theme-reachable values into the class's Custom
  CSS with palette variables; a copy's kept value must still win at `#brxe-<id>`.

## Gates
Both typechecks, `npm run check` (8G; the 3 base failures shared-colour/site-colours are the base's); every AC's test by plan name into
`/home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/fixer-1/receipt-<head7>.log` (`HEAD=` first, `EXIT=` last); pins with `F2B_PIN_BASE=1 F2B_STORY_PINS=1`. Ledger: a "Fixer 1" section.
Stop at `ready-for-review`.

Report (as text): new head (full SHA); per finding RED/GREEN, mutant; gates; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`
(never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
