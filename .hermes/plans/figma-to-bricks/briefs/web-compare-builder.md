# Builder brief: web-compare (J0 of the website importer)

**Role:** builder (fresh Opus 5.5, xhigh). You build the approved plan test-first and stop at `ready-for-review`. Justin
is asleep under an away grant (`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): the plan's ⭐
answers are taken; where the plan is silent or wrong, research, decide, and record the ruling (not yet confirmed) in
the ledger and your report. Never stop to ask.

**Skills:** load `engineering-best-practices` and `test-driven-development` with the Skill tool; read the project skill
with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/testing-pitfalls.md`
and `references/rendering-validation.md`.

## Start

You begin in your own agent worktree of `~/Documents/FigmaToBricksV2` at `dea6296`. First bring it up to the
planner's commit: `git merge --ff-only 6ace671356e531f1e48b40cddef83c056775dd3c` (branch
`worktree-agent-a45d032c643c19f8b`). The plan is then `docs/plans/2026-10-29-web-compare.md` in your copy; the
approved read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` (they must match).
The proposal behind it: `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` §11 J0.

## Rules

- Build every task test-first (a failing test before each change), and commit to your branch after each passing task
  (plain `git commit -m`, no author override, no AI lines; check `git diff --cached --name-only` holds no CLAUDE.md).
  Don't push, don't bump `BUILD`, don't edit CLAUDE.md (the plan's Task 15 CLAUDE.md lines are for the finisher), never
  bare `git stash`.
- Ledger: `.superpowers/sdd/2026-10-29-web-compare/progress.md` in your copy (task, commit, test, ruling).
- **This machine (WSL):** follow `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`
  and the planner's wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`
  (`CHROME_PATH`). A browser or web test run counts only when it says `skipped 0`. Long gates: write a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, run it, and wait for `EXIT=`. Compare gates with the base by test
  name (planner's tallies on `dea6296` and `base-browser-failures.txt` in its evidence folder).
- **Shared files with J1 (web-capture, planned in parallel):** use exactly the plan's `test:web` script line and the
  `Page.cdp(method, params)` name; HANDOFF gets its own J0 section.
- Live reads of public sites only (read only); never write to any WordPress site.
- General logic only (repo CLAUDE.md): no rule keyed on one site's names, ids, classes or sizes.

## Evidence (one test and one capture per AC)

In `~/.hermes/plans/figma-to-bricks/evidence/web-compare/builder/`: for each AC, its test's run output (a terminal
capture saved as `ac<n>-test.txt`, `skipped 0` visible) and a screenshot where the AC has something visual (a
side-by-side PNG or the report), plus the gate receipts AC11 names in `gates/`. Copy any scratch script you rely on
into `builder/scripts/` as soon as you write it (the scratchpad can be wiped).

## Report back (ready-for-review)

Branch, head SHA, base (`dea6296`), commits in order; each AC → test → evidence file; gate tallies against the base
by test name; rulings you made; anything left undone and why. Then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable lessons only; `enforce` is `none` or a one-line check proposal; empty is normal; never edit skills or
memory yourself), and end with: `MAIN SESSION: check and save these skill_lessons now.`
