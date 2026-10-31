# Builder brief: web-compare, amendment 1 (the new matching)

**Role:** builder (fresh Opus 5.5, xhigh). You build plan amendment 1 test-first and stop at `ready-for-review`. Justin
is asleep under an away grant (`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`, the 2026-10-30
evening entry): the amendment's ⭐ answers Q9–Q11 (all A) are taken; where it is silent or wrong, research, decide, and
record the ruling (not yet confirmed) in the ledger and your report. Never stop to ask.

**Skills:** load `engineering-best-practices` and `test-driven-development` with the Skill tool, plus
`mutation-testing-discipline` (the property test and the corpus are the guard for every later job); read the project
skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md` and `references/testing-pitfalls.md`.

## Start

Your agent worktree starts at `main` (other sessions moved it). Put your copy on the amendment without rebasing:
`git checkout --detach 69a6fa70a3ff3528f589640591f596daae678c77` then `git switch -c web-compare-matching`. The story's
base stays `3ea33bb`; the previous reviewed head is `c69ef18`. The plan is `docs/plans/2026-10-29-web-compare.md` in
your copy ("Amendment 1: matching": design, Q9–Q11, rulings R23–R29, AC12–AC18, tasks A0–A10); the approved read-only
copy is `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` (they must match). The planner's spike,
probe set and logs: `~/.hermes/plans/figma-to-bricks/evidence/web-compare/amendment-1/planner/` (`spike/`, `logs/`).

## Rules

- Build every task test-first (a failing test before each change); commit to your branch after each passing task
  (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push, don't bump `BUILD`, don't
  edit CLAUDE.md, never bare `git stash`, don't rebase. `src/` stays untouched.
- The test rewrites Task A7 lists are the only expected changes to existing tests; any other existing test that
  changes its result is a bug to explain, not to rewrite.
- AC15 and AC16 are base-exempt against `c69ef18` (say so in your evidence); AC1–AC11 must still hold.
- Ledger: `.superpowers/sdd/2026-10-29-web-compare/progress.md` in your copy, section "Amendment 1".
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; a browser/web
  run counts only with `skipped 0`; long gates as a script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`,
  waiting for `EXIT=`; compare gates with the base by test name.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Justin re-pastes the plugin-made site between passes: compare a live
  difference with `c69ef18`'s reading taken the same day before blaming the change.
- General logic only.

## Evidence

In `~/.hermes/plans/figma-to-bricks/evidence/web-compare/amendment-1/builder/`: for each of AC12–AC18 its test's run
output (`ac<n>-test.txt`, `skipped 0` visible) and RED logs, AC1–AC11 re-run receipts, the gates in `gates/`, mutants
in `mutants/`, the cost measurement for AC17. Copy scratch scripts into `builder/scripts/` as soon as you write them.

## Report back (ready-for-review)

Branch, head SHA, the commits; each AC → test → evidence; gate tallies by test name against `c69ef18` and `3ea33bb`;
rulings you made; anything left undone and why. Then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
