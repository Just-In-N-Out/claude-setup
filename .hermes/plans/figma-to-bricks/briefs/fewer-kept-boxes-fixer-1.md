# Role: fixer 1 (review 1 findings): fewer-kept-boxes
Fresh fixer, **Opus 5.5, high**, about 3 hours. First read and follow the machine and safety rules in /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md (written for reviewers: you DO
commit, to your own branch only). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`; the project skill directly with
`references/testing-pitfalls.md` and `references/live-site-reading.md`; both `repeat-mistakes.md` first. Plain `git commit -m`, no
author override, no AI or Co-Authored-By lines, never CLAUDE.md; don't push; don't bump BUILD; don't edit the main folder; never bare
`git stash`. Files only with Write/Edit (no heredocs, no `sed -i`). TMPDIR ~/.cache/fkf1/t1.

## State
- Plan (read-only): /home/justin/.hermes/plans/figma-to-bricks/evidence/fewer-kept-boxes/plan-approved.md (AC1–AC16; AC16 live): leave out wrapper boxes, moving their values onto the element, nothing moved.
- Head **6bac37314431e7e149e5a5c66853b7a175bb49fa** (branch `fewer-kept-boxes-build`), base **46c1696a46b63b00e7f87d8c02e34117946746d8** (a merge
  of importer-parity's and plugin-parity's older heads; this job is rebased only after both merge: don't move it now).
- Review 1: /home/justin/.hermes/plans/figma-to-bricks/evidence/fewer-kept-boxes/review-1/review.json (its probe sites and scripts: `~/.cache/fkr1/`, `site-a`, `site-b`, `probe-a.ts`…`probe-e.ts`; rerun them yourself).

## Fix, each test first (RED on 6bac3731, GREEN, a one-line mutant killed)
- **R1-1** `src/core/site/fold-moves.ts:102` (M2a; `plainNode` :46): a wrapper's padding never moves onto an element that is the containing
  block of absolutely placed children (they read its padding box): keep that wrapper, named in the notes (or a move that provably keeps them).
- **R1-2** `fold-moves.ts:89-105`, `fold-proof.ts:62`: the capture's declared CSS holds no browser-default margin/padding (`p` 1em, `h2`
  0.83em, `ul` 40px): a move never writes over a value the element draws from the browser's stylesheet (read the computed value, or refuse
  for elements with UA margins/padding unless declared), named.
- **R1-3** `src/core/emit/wrappers.ts:105` (`paints`), `:171-177`: a Div that paints through its own custom CSS (every picture with
  "Pictures go: inside the copied JSON") is not quiet: keep the frame; AC14's test converts with `inlinePictures: true` too and compares the
  painted box, not only the content box.
- **R1-4** `test/web/site-kept-boxes.test.ts:29-37` and both `kept-boxes` fixture sites: one section per move and rewrite AC8 names (M2a,
  M2b padding wrappers, a calc size, a dropped 100%, a percentage across M4, fonts M5), the R1-1 and R1-2 shapes, and no `h2, h3, p { margin:
  0 }` reset hiding browser margins. Under AC8's unchanged test name.
- R1-5..R1-7 are P3 (in /home/justin/.hermes/plans/figma-to-bricks/evidence/fewer-kept-boxes/follow-ups.md): don't fix.

## Gates
Both typechecks, `npm run check` (8G); every AC's test by plan name on your head (B-Dry ones in the namespace, others with the network) into
`/home/justin/.hermes/plans/figma-to-bricks/evidence/fewer-kept-boxes/fixer-1/receipt-<head7>.log` (`HEAD=` first, `EXIT=` last); the off pins with `F2B_PIN_BASE=1 F2B_STORY_PINS=1`. Ledger: a "Fixer 1"
section. Stop at `ready-for-review`.

Report (as text): new head (full SHA); per finding verified or pushed back, RED/GREEN, mutant; gates; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
