# Fixer brief: web-capture, fix pass 3 (after review round 3)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

`main` is at `61bb5fc` (build 29.3), so your agent worktree starts there, not on the story. Put your copy on the
reviewed head without rebasing: `git checkout --detach 453d2dc0521dff8b53323f7368b99613e10be86e` then
`git switch -c web-capture-fix-3` (fix pass 2's branch is `web-capture-fix-2`). Fixers don't rebase: your commits go
on top of `453d2dc`, and the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## The findings

The referee's lines, verbatim: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-3/referee.txt`; the record
`review-3/review.json`; the reviewer's probe sites, outputs and summaries in `review-3/probe/`, scripts in
`review-3/scripts/`. Fix the three P2s, each a repeat with a new fact:
- **R3-1** (repeats R2-5): the reveal check scrolls only the window, so on a page whose body is its own scroller
  (`html, body {height:100%; overflow-x:hidden}`) sections below the first screen that a reveal hides are dropped
  without a note. Scroll the page's own scroller (the window, or body when body scrolls) and put it back; keep
  carousels and sideways scrollers unscrolled (R2-5's window-only reason).
- **R3-2** (repeats R2-1): on a page with no `<main>`, the page part is built only from boxes shown at the design
  width, so a phone-only box between the parts is in no part. Probe `footphone` and its twins.
- **R3-3** (repeats R2-3): the switch-point facts are still a hand-written list (transform-only, `column-count`-only,
  `justify-items`-only changes are missed). End the class: compare every computed property minus a short, named skip
  list, keeping `steady()` and the drift rule so moving sliders still don't make switch points; revisit ruling F17.
**Verify each first** with the reviewer's probe or your own; fix test-first, as general logic. Push back with evidence
on any that doesn't hold. The P3s (R3-4…R3-6 and earlier rounds') are follow-ups unless a fix naturally covers one
(R3-6, `shot()`'s `scrollIntoView`, sits next to R3-1's work: fix it too if it falls out naturally, and say so).

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` (the builder's receipts are in
  `evidence/web-capture/builder/gates/`, fix passes 1–2 in `evidence/web-capture/fixer-1/` and `fixer-2/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-3/answers.md`: for each of R3-1…R3-3, **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
