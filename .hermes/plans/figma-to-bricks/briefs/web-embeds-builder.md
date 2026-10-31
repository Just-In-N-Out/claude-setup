# Builder brief: web-embeds (J5 of the website importer)

**Role:** builder (fresh Opus 5.5, xhigh). You build the approved plan test-first and stop at `ready-for-review`.
Justin (2026-10-31): "I need this to be built fast … focus on building." Take the plan's ⭐ answers; where the plan is
silent or wrong, decide and record the ruling (not yet confirmed) in the ledger and your report. Never stop to ask.
**Keep iterating until every AC passes its test** (never hand back with an AC failing); build for speed: do each
task's work and its test, run the gates once at the close,
and skip optional extra probing beyond what the plan's tasks and ACs require. `(live)` ACs are owed to Justin; name them.

**Skills:** load `engineering-best-practices` and `test-driven-development` with the Skill tool (add
`mutation-testing-discipline` only where the plan asks for mutants); read the project skill with Read:
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md` and `references/core-constraints.md`.

## Start

Your agent worktree is a copy of `~/Documents/FigmaToBricksV2`. Wave 1 (J1 web-capture and J0 web-compare) is combined, every gate green, on
branch `web-compare-final` at `89022abbef4e3584a93a68cd7118dea69aa93f2b` (its acceptance checks and merge into `main` run while you
build; the main session tells you if they change wave-1 code). Put your copy there and bring the plan in:
`git checkout --detach 89022abbef4e3584a93a68cd7118dea69aa93f2b`, `git switch -c web-embeds`, `git cherry-pick a428659` (the planner's commit(s), made on
`3ea33bb`; it only adds `docs/plans/2026-10-30-web-embeds.md`). Then `diff docs/plans/2026-10-30-web-embeds.md ~/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md`
must be empty. Your base is `89022abbef4e3584a93a68cd7118dea69aa93f2b`; at the finish your branch moves onto `main` with `git rebase --onto main 89022ab`, so only your own commits move. Planner probes: `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/planner/`.

**Task 0 matters more than usual:** wave 1's last fix passes (web-capture fix 10: % bases of grid items and placed boxes,
`font`/`grid-template` shorthands through `var()`, notes only where a site value was lost; web-compare fix 7: section
heights carry their remainder) were merged without a further review at Justin's word. Re-check every wave-1 fact your
plan depends on against the combined code (`docs/specs/web-capture.md`, HANDOFF's web-capture and web-compare sections,
`src/web/`, `test/web/lib/`), adapt the task a changed fact feeds (never an AC's meaning), and record each in the ledger.
If a fact breaks an AC, record it and carry on with the rest; say so in your report.

## Rules

- Test first (a failing test before each change); commit to your branch after each passing task (plain `git commit -m`,
  no author override, no AI lines; `git diff --cached --name-only` holds no CLAUDE.md). Don't push, don't bump `BUILD`,
  don't edit CLAUDE.md, never bare `git stash`, don't rebase. Ledger as the plan names it under `.superpowers/sdd/`.
- **Running beside {'web-tiers': 'web-panel (J4) and web-embeds (J5)', 'web-panel': 'web-tiers (J2) and web-embeds (J5)', 'web-embeds': 'web-tiers (J2) and web-panel (J4)'}** in their own copies: stay in the files your plan owns; small hunks in shared files, as the
  plan's overlaps section says. Whoever merges second rebases and keeps both. Leave the other copies alone.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH; keep `TMPDIR` short (`~/.cache/wembeds/tmp`). A browser or web
  run counts only with `skipped 0` (bar what the plan names). Long gates as a script with `exec > <log> 2>&1` and
  `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`; `node --test` options go before file paths. In this
  worktree-isolated session write multi-step scripts with the Write tool and run `bash <file>`; run git add, diff and
  commit as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- General logic only (repo CLAUDE.md): nothing keyed on one site's names, ids, classes, texts or sizes. Architecture rules
  stand: `src/web` is never imported by core/plugin/shared/ui; the five real Figma files replay byte-identical.

## Evidence (one test and one capture per AC)

In `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/builder/`: per AC its test's run output (`ac<n>-test.txt`, the
tally visible) and a screenshot where the AC has something visual; gate receipts in `gates/`. Copy any scratch script
you rely on into `builder/scripts/` as soon as you write it.

## Report back (ready-for-review)

Branch, head SHA, base (`89022abbef4e3584a93a68cd7118dea69aa93f2b`), commits in order; each AC → test → evidence file; gate tallies against Task 0 by test
name; Task 0's changed facts; rulings you made; `(live)` ACs owed; anything left undone and why. Then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable lessons only; `enforce` is `none` or a one-line check
proposal; empty is normal; never edit skills or memory yourself), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
