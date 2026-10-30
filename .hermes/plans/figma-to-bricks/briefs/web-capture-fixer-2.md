# Fixer brief: web-capture, fix pass 2 (after review round 2)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

`main` has moved to `61bb5fc` (build 29.3, header-bar), so your agent worktree starts there, not on the story. Put
your copy on the reviewed head without rebasing: `git checkout --detach 519dab4f5ca94d14ddbf68b05aac4c3df517257f`
then `git switch -c web-capture-fix-2` (the story's branch is `worktree-agent-a5c3517dbdc6d2bb8`). Fixers don't
rebase: your commits go on top of `519dab4`, and the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## The findings

The referee's lines, verbatim: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-2/referee.txt`; the record
`review-2/review.json`; the reviewer's probe sites in `review-2/probe/sites/{nomain,footonly,hdrbars,facts,reveal}/`,
its captures and readouts in `review-2/probe/`, scripts in `review-2/scripts/`. Fix the five P2s **R2-1 … R2-5**:
pages with no `<main>` (and footer-only pages) get a page part; a header whose desktop bar is fixed beside a
phone-only in-flow bar keeps that bar in the Header root; look-only media queries (background picture, `<picture>`
source, colour, corners, shadows, grid areas) are switch points (R2-3 repeats R1-1 with a new fact); the per-width
record writes every field the spec promises (`docs/specs/web-capture.md`), including a swapped background picture;
reveal-on-scroll content that hides itself again off screen is not dropped (R2-5 is a regression of the R1-5 fix:
keep R1-5's closed dropdowns and pop-ups out). **Verify each first** with the reviewer's probe or your own; fix the
valid ones test-first (a failing test, then the fix), as general logic. Push back with evidence on any that doesn't
hold. The P3s (R2-6…R2-8 and round 1's R1-14, R1-15, R1-17, R1-18) are follow-ups: leave them unless a P2 fix naturally
covers one, and say which.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` (the builder's receipts are in
  `evidence/web-capture/builder/gates/`, fix pass 1's in `evidence/web-capture/fixer-1/gates/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`; fix the receipts' wrong commit labels
  (R1-19's first half) as you re-take them.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-2/answers.md`: for each of R2-1…R2-5, **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
