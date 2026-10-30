# Fixer brief: web-capture, fix pass 4 (after review round 4)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

`main` has moved on (now `c67128c`, builds 29.3 → 30.20 from other sessions), so your agent worktree starts there, not
on the story. Put your copy on the reviewed head without rebasing: `git checkout --detach
af506a53504bf7d5ab97310f3f6ef99aab6c45c4` then `git switch -c web-capture-fix-4` (fix pass 3's branch is
`web-capture-fix-3`). Fixers don't rebase: your commits go on top of `af506a5`, and the story's base stays `3ea33bb`.
Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## The finding

The referee's lines: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-4/referee.txt`; the record
`review-4/review.json`; probes (`bodysnap`, `nonvisual`, the heavy discover page), scripts and gates in `review-4/`.
Fix **R4-1** (P2, repeats R3-1 with a new fact): `scrollPage` finds a body scroller by a 1px test move, which a
snapping body (`scroll-snap-type: y`, proximity or mandatory) undoes, so body reads as not scrolling, the page as one
window tall, and a reveal section below the first screen is dropped with no note. Decide from html's overflow, body's
overflow-y and its scrollHeight (or move body to its far end), and keep R3-1's smooth-scroll and window cases green.
**Verify it first** with `bodysnap`, fix it test-first as general logic. The P3s are follow-ups, but two sit in code
you'll touch and cost real time on every page: **R4-2** (the every-property skip list keeps properties that draw
nothing: scroll-margin/padding/snap, overscroll-behavior, tap-highlight colour, text-size-adjust) and **R4-4**
(discovery 19.5 s → 75.9 s on a bdryswi-like page; keep each width's reading so neighbouring boundaries don't read
it twice). Fix them too if they fall out of the work naturally, test-first, and say so. R4-3 and R4-5 stay follow-ups.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` (the builder's receipts are in
  `evidence/web-capture/builder/gates/`, fix passes 1–3 in `evidence/web-capture/fixer-1/` … `fixer-3/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-4/answers.md`: for R4-1 (and any P3 you covered), **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
