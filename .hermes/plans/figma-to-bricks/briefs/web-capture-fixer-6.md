# Fixer brief: web-capture, fix pass 6 (after review round 6)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

`main` has moved on (other sessions' builds), so your agent worktree starts there, not on the story. Put your copy on
the reviewed head without rebasing: `git checkout --detach f66e0c0abae470be24cfff8c1984881d0197f804` then
`git switch -c web-capture-fix-6` (fix pass 5's branch is `web-capture-fix-5`). Fixers don't rebase: your commits go
on top of `f66e0c0`, and the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## What Justin chose

Round 6 raised **R6-1** (repeats R5-1): Bricks "Animation end" chained steps with a delay (a hero fading in heading,
then text, then button, 0.2 s apart) arm after the capture starts reading, so they are read at opacity 0. Justin
noticed "fade-ins come out invisible" has come back for several reviews (rounds 2–4: scroll reveals on unusual
scrollers; round 5: Bricks on-load fades; round 6: chained steps) and chose the **general fix: "Wait for all fades"**
(`review-6/justin.json`). Before reading a page (in every range's page load), the capture waits until every
**entrance** animation on it has really finished, whatever library made it (Bricks, Elementor, AOS, GSAP-style
scripts, plain CSS), within a bounded time budget, and **never opens pop-ups, panels or toggles** a visitor at the top
hasn't triggered. Design it as one general mechanism, not one more per-library undo. Keep what already works:
`revealOwned`'s reveals for content that only appears on scroll, R1-5's closed dropdowns/pop-ups kept out, F16's
partial opacity kept, the scroller and snapping fixes, reduced cost on heavy pages. Two P3s sit in the same code:
**R6-3** (sending fade ends at once ran chains below the first screen: opened a 300px panel, hid a note, opened a
chained pop-up) should be cured by the same design, so fix it; **R6-2** (the spec and F25 wrongly say scroll-offset
boxes keep waiting; the freeze's scroll-through fires Bricks' scroll triggers) is a docs fix: correct the claim.

The referee's lines: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-6/referee.txt`; the record
`review-6/review.json`; the reviewer's probe sites `bricksreal`, `revealreal`, `bricksstagger` (they run the live site's
own `bricks.min.js` 2.3.9, `frontend-light-layer.min.css`, `animate-layer.min.css` and `bricksData`, GET today),
per-tree looks and timelines in `review-6/probe/`, scripts in `review-6/scripts/`.

**Regression corpus (must all stay right, judged on painted boxes, not words-only ones):** every reveal and fade probe
from rounds 2–6:
- round 2: `review-2/probe/sites/reveal`;
- round 3: `review-3/probe/` (`bodyscroll`, `bodyonce`, `footphone`…);
- round 4: `review-4/probe/` (`bodysnap`…);
- round 5: `review-5/` (`bricksfade`);
- round 6: `review-6/probe/`;
- the fixers' `reveal/*` fixtures.

**Verify R6-1 first** with `bricksstagger` on the head; build the design test-first (a failing test on a painted
staggered chain, then the fix), as general logic; and say how long the wait adds per page load on the live homes and
the heavy page. Push back with evidence if a part of Justin's direction can't hold (for example an endless animation
that never "finishes": define what counts as an entrance and say how it's bounded).

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` (the builder's receipts are in
  `evidence/web-capture/builder/gates/`, fix passes 1–5 in `evidence/web-capture/fixer-1/` … `fixer-5/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-6/answers.md`: for R6-1, R6-2 and R6-3, **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
