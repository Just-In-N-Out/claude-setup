# Builder brief: web-capture (J1 of the website importer)

**Role:** builder (fresh Opus 5.5, xhigh). You build the approved plan test-first and stop at `ready-for-review`. Justin
is asleep under an away grant (`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): the plan's ⭐
answers and rulings R1–R10 are taken (R9: answer "owned" with `--owned` for the three sites the plan names, recorded in
the ledger); where the plan is silent or wrong, research, decide, and record the ruling (not yet confirmed) in the
ledger and your report. Never stop to ask.

**Skills:** load `engineering-best-practices` and `test-driven-development` with the Skill tool; read the project skill
with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/testing-pitfalls.md`
and `references/rendering-validation.md`.

## Start

You begin in your own agent worktree of `~/Documents/FigmaToBricksV2` at `dea6296`. First bring it up to the
planner's commit: `git merge --ff-only afa82aa1b7a139f5dd271a4b530f7aba9dd62fff` (branch
`worktree-agent-af6f00ddd065d655a`). The plan is then `docs/plans/2026-10-29-web-capture.md` in your copy; the
approved read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md` (they must match).
The proposal behind it: `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` §11 J1. Planner probes:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/`.

## Rules

- Build every task test-first (a failing test before each change), and commit to your branch after each passing task
  (plain `git commit -m`, no author override, no AI lines; check `git diff --cached --name-only` holds no CLAUDE.md).
  Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git stash`.
- Ledger: `.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy (task, commit, test, ruling).
- **This machine (WSL):** follow `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`
  and the Chrome CPU wrapper (`~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`, or
  your planner's own, as `CHROME_PATH`). A browser or web test run counts only when it says `skipped 0`. Long gates
  and live captures: write a script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, run it, and wait for
  `EXIT=`. Compare gates with the base by test name (base on `dea6296`: unit 2566 / 2506 pass / 60 skip; browser 405 /
  392 pass / 12 font-environment fails / 1 skip, names in
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/base-browser-failures.txt`).
- **Shared with J0 (web-compare, being built now in another copy):** the same `test:web` line and the same
  `Page.cdp(method, params)` method, character for character; HANDOFF gets its own J1 section. Whichever job merges
  second rebases onto the other.
- **Phones, mouse or touch:** your plan reads 767px and below as a touch phone (Q3 A); J0's compare tool reads every
  width with a mouse (its Q2 A). If a site's layout depends on the pointer type (`hover`/`pointer` media queries),
  record in the capture which pointer each range was read with, and name the mismatch in your report's hand-over so
  the compare side can match it. Don't build any comparison yourself.
- Live reads of public sites only (GET, read only, never logged in); never write to any WordPress site. Keep live
  captures outside git, as the plan says.
- General logic only (repo CLAUDE.md): no rule keyed on one site's names, ids, classes, texts or sizes.

## Evidence (one test and one capture per AC)

In `~/.hermes/plans/figma-to-bricks/evidence/web-capture/builder/`: for each AC, its test's run output (a terminal
capture saved as `ac<n>-test.txt`, `skipped 0` visible) and a screenshot where the AC has something visual (a capture's
render beside the live page, the replayed paste), plus gate receipts in `gates/`. Copy any scratch script you rely on
into `builder/scripts/` as soon as you write it (the scratchpad can be wiped).

## Report back (ready-for-review)

Branch, head SHA, base (`dea6296`), commits in order; each AC → test → evidence file; gate tallies against the base
by test name; rulings you made; the hand-over for wave 2 (the format doc, where the captures are, the pointer note);
anything left undone and why. Then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable lessons only;
`enforce` is `none` or a one-line check proposal; empty is normal; never edit skills or memory yourself), and end with:
`MAIN SESSION: check and save these skill_lessons now.`
