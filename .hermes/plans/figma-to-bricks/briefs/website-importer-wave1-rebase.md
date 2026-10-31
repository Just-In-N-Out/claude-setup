# Finisher brief: website importer wave 1, rebase onto the new main

**Role:** finisher (fresh Opus 5.5, xhigh). Justin (2026-10-31): "I need this to be built fast." Never stop to ask;
decide and record.

**Where things stand:** the first wave-1 finisher put web-capture (J1) and web-compare (J0) in one line on main
`04ab9b1`: branch `web-compare-final` = `89022abbef4e3584a93a68cd7118dea69aa93f2b` (162 commits; its report's gates all
matched main by test name; one combine-only fix, `159e4eb`, in `test/web/lib/timing-read.ts` with `nativeKeyframes`
exported from `test/browser/render-motion.ts`). While it ran, local `main` moved to
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` ("Build 2026-10-31.2: landing-page six", released). Your job: move the
combined line onto that main, prove the combined tree passes, and stop.

**Skills:** load `git-commit-rules` and `engineering-best-practices` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging" step 1) and
`references/testing-pitfalls.md`.

## Steps (in your agent worktree)

1. `git checkout --detach 89022abbef4e3584a93a68cd7118dea69aa93f2b`, `git switch -c wave1-final`, then
   `git rebase 1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
2. **Conflicts:** keep both sides' meaning. HANDOFF: the compare section first, then the capture section, then main's
   blocks unchanged; prove it with the first finisher's
   `~/.hermes/plans/figma-to-bricks/evidence/website-importer-wave1/finisher/scripts/check-handoff-union.mjs` (adapt
   its paths). Main changed `test/browser/render.ts` (default `background-position`) and `test/browser/text-visibility.ts`;
   keep both sides there. After the rebase: `grep -c '"test:web"' package.json` is 1 and every other `scripts` key
   appears once; `src/shared/build.ts` equals main's (`2026-10-31.2`); every commit that didn't conflict has the same
   patch-id as before.
3. **Gates on the rebased head**, each compared by test name with main `1aef12f`: both typechecks, `npm run check`,
   `npm run test:web` first among the browser suites (`skipped 0` apart from AC14, which needs `F2B_WEB_CAPTURES`; main's
   renderer change can break the compare tool only there), `npm run test:browser`, `npm run corpus`, and the five real
   Figma files (hydraulics, GRO, Repairs, brainstorm, Services from `2199895`; plain and `--site`) replayed
   byte-identical with main. Reuse the first finisher's scripts in `evidence/website-importer-wave1/finisher/scripts/`
   (`prep-trees.sh`, `repoint-corpus.mjs`, `gates-final.sh`, `diff-reports.mjs`, `compare-tap.mjs`), pointed at the new
   trees. A failure main doesn't have that comes from the combination: fix it test first in the smallest way (RED log,
   mutants of the new rule), commit, list it. A failure main has too: name it, don't fix it. Never weaken a test.
4. **Stop and report.** Don't merge, push, bump `BUILD` or touch the main folder. If main moves again before you finish,
   say so and stop; don't chase it.

## Rules

- Plain `git commit -m`, no author override, no AI lines; `git diff --cached --name-only` holds no CLAUDE.md. Never bare
  `git stash`; leave `web-compare-final`, `web-capture-final` and every other branch and copy alone.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` short (`~/.cache/w1-rebase/tmp`). Long gates as a
  script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`; wait inside tool calls, never by ending your turn.
  Write multi-step scripts with the Write tool and run `bash <file>`; run git commands as separate plain calls. Kill
  only your own Chromes, by PID (never `pkill -f`). Three wave-2 builders share this machine: run the browser suites
  one at a time.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it.** Live reads only of
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
  Never write to any WordPress site.
- Receipts and logs in `~/.hermes/plans/figma-to-bricks/evidence/website-importer-wave1/rebase/`.

## Report

The `wave1-final` head (full SHA), what the rebase did (conflicts and how resolved), gate tallies against main by test
name (say plainly any that failed or didn't run), any fix you made, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
