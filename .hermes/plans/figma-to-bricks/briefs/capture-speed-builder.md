# Role: builder: capture-speed

You are a fresh builder for FigmaToBricksV2 (Opus 5.5, xhigh). Build the approved plan test-first and stop at
`ready-for-review`. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never bare
`git stash`, never push or merge into main, don't bump `BUILD`, leave every other worktree alone (read other branches with
`git show <branch>:<path>`), start no agents. **Never load bdryswi.com** (AC11 is Justin's live run); no logins; never
write to any WordPress site. Nothing paid. Nothing may hide that the importer's Chrome is automated (CLAUDE.md).

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `perf-regression-hunter`, plus
`mutation-testing-discipline` for the guards (the derive-from-descendants self-check, retry, human-once); read the project
skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (Access: where a capture's minutes go), the repo `CLAUDE.md`.

## The plan (approved under the standing auto-go, ⭐ Q1–Q5 taken)
- Read-only copy: `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/plan-approved.md` (AC1–AC11; AC11
  live, Justin's). Use each AC's exact test name. Planner's probes: `evidence/capture-speed/planner/`.
- Your copy: branch `capture-speed-build` from local `main` (`9b248818`, Build 2026-11-07.1); cherry-pick the plan commit
  `5dbc75f2157c8a4edf03ffed11d7d81be1ca12b7` (branch `worktree-agent-a6e3169462bc325a8`). Record the base SHA.
- **Other jobs touching the same files:** elementor-map (being verified, then merged; it changes `src/web/code.ts` and so
  captures) and site-motion (being built on elementor-map; it reads hover/keyframes over CDP). When elementor-map lands on
  `main` (`git merge-base --is-ancestor worktree-agent-a93c32bbf9bbc5ed4 main`), `git rebase main` before stopping (keep both
  sides' meaning, record conflicts), and rerun AC1/AC2's base comparisons against the new base so byte-for-byte compares
  the right code. Say in the report which base your receipts use.

## Work
1. Ledger `.superpowers/sdd/2026-11-07-capture-speed/progress.md` (commit it); baselines as the plan's Task 0 says.
2. Each task test-first: RED saved, then GREEN; commit after each passing task (plain `git commit -m`, no author override,
   no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed`): per AC its test log
   (`HEAD=` first, `EXIT=` last, skipped 0), a terminal capture (timings for AC3), RED logs.
4. Gates before stopping: both typechecks, `npm run check`, `npm run corpus`, `npm run test:web` and `npm run
   test:browser` file by file, compared by name with base.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cs-b/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: timings (AC3) compare base
  and head in the same run, as the plan says. Close every Chrome you start (kill by its profile path if Node dies).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`). B-Dry runs with 4 windows need `systemd-run --user --scope -p MemoryMax=6G -p MemorySwapMax=0`
  (planner measured 3.3 GB); everything else 4G; mutation runs always capped.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch and last commit (full SHA), base SHA, per task one line, per AC its test, RED/GREEN and
evidence paths, measured times (base vs head), gates, `found_else`, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
