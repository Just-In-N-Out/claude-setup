# Role: fixer 1 (review 1 finding): page-faq-slide
Fresh fixer, **Opus 5.5, high**, about 2 hours. First read and follow the machine and safety rules in /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md (written for reviewers: you DO
commit, to your own branch only). Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`; the project skill directly with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; both `repeat-mistakes.md` first. Plain `git commit -m`, no author override, no AI or Co-Authored-By
lines, never CLAUDE.md; don't push; don't bump BUILD; don't edit the main folder; never bare `git stash`. Files only with Write/Edit (no
heredocs, no `sed -i`). TMPDIR ~/.cache/pff1/t1. In a two-tab site-vs-paste probe, `Page.bringToFront` before each click and wait.

## State
- Plan (read-only): /home/justin/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/plan-approved.md (AC1–AC9; AC9 live). Head **0627468c167aa3542c7e7e46957d01f4cc49cd86** (branch
  `page-faq-slide-build`), base **f8807e60b6b01355da712653962375459151f3b5** (native-widgets' head, not merged; don't move it now).
- Review 1: /home/justin/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/review-1/review.json; the reviewer's logs `~/.cache/pfr1/pay-base.log`, `pay-head.log`, `pay-head-r2off.log`, `pay-base-none.log`.

## Fix, test first (RED on 0627468c, GREEN, a one-line mutant killed)
- **R1-1** `src/core/site/plain-natives.ts:236`: rule R2 refuses every aria list where a closed title sits over a still-drawn answer,
  including a list with an item open at load, which the base pastes as a working Accordion (0.00 px from the site in four states; the head
  pastes dead Blocks, 43.50 px off, 2 of 3 answers unreachable). This restores the base's working behaviour (a bug, not a new design pick):
  refuse only when no title is expanded at load; otherwise keep the Accordion with the scan's timing (the reviewer's R2-off run gave
  `{expandItem:"0", transition:"300"}` with the ease-in-out slide class, 0.00 px on both Bricks versions). Bring back the base web test's
  click comparison for that list. AC3's wording (from plan Q8, measured on an older importer-parity head) changes with it: write an
  "Amendment (2026-11-15, review 1 R1-1: R2 only when no title is open at load)" block under AC3 in `docs/plans/<this plan>.md` and the same
  text in `/home/justin/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/fixer-1/amendment.txt` (the main session re-issues plan-approved.md from it); AC3's unit and web cases change with it, nothing wider.
- R1-2..R1-7 are P3 (/home/justin/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/follow-ups.md): don't fix.

## Gates
Both typechecks, `npm run check` (8G); every AC's test by plan name into `/home/justin/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/fixer-1/receipt-<head7>.log` (`HEAD=` first, `EXIT=` last);
the story pins with `F2B_BASE_TREE` (as the builder ran them) and `F2B_PIN_BASE=1 F2B_STORY_PINS=1`. Ledger: a "Fixer 1" section. Stop at `ready-for-review`.

Report (as text): new head (full SHA); RED/GREEN, mutant; gates; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (never
edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
