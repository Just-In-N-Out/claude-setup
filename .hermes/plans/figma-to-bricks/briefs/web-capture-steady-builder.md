# Role: builder (Mini): web-capture-steady (captures with no gaps: a later check is waited for, a settled reload is the page, the CLI finds Chrome)

You are a fresh builder for FigmaToBricksV2 (Opus 5.5, high effort: Justin's code-method jobs run on high). Build the approved plan test-first and stop at `ready-for-review`. Never
touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, never push or
merge, don't bump `BUILD`, leave every other worktree alone, start no agents.

## The plan (approved under the standing auto-go, ⭐ Q1–Q5 taken)

- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture-steady/plan-approved.md`
  (AC1–AC10; AC10 `(live)`, Justin's). Use each AC's exact test name from the plan.
- In git: branch `web-capture-steady` at `4a0878da` (on main `ea504778`, Build 2026-11-04.8), checked out in the planner's
  worktree, so in yours: `git switch -c web-capture-steady-build 4a0878da`. Report this branch and its last commit.
- The planner's reproduction: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture-steady/planner/` (`repro-late-recheck.test.ts`,
  `check-site-repro.diff`, `run-repro.sh`, `repro-base-ea504778.log`: RED on main; button at 20 s, not 8 s). Another job
  (web-code-page) builds in `src/core/site/`, `src/web/read/code*.ts`, `tools/site*.ts`: stay out of them.
- Mini: stop with `status: stopped`, `stop_reason: escalate to full` only if it needs a design decision or anything that
  would hide automation.

**Hard rule:** nothing hides that the browser is automated (no new flags, navigator patches, user agents, stealth
scripts, nothing that clicks or types into a site's check; a test's click stands in for Justin only in tests). Never load
bdryswi.com.

## Work

Load `engineering-best-practices`, `test-driven-development` and `systematic-debugging`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`.
1. Ledger `.superpowers/sdd/2026-11-04-web-capture-steady/progress.md`.
2. Each task test-first: RED saved, then GREEN; commit after each passing task (plain `git commit -m`, no author override,
   no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. Records: HANDOFF section (newest first) with the paste check "id given at the merge" naming AC10's steps for Justin
   (`cd ~/Documents/FigmaToBricksV2 && npm run capture -- https://bdryswi.com/` with no CHROME_PATH, press I am human each
   time, no "Not the page itself" line, then `npm run site:check` lists every width), web-human-reload ruling R1 replaced
   by Justin's 2026-11-04 ruling, web-reload-settled folded in; spec line.
4. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture-steady`): per AC its test
   log (`HEAD=` first, `EXIT=` last, skipped 0; the opt-in real-window subtest may be left out with
   `--test-skip-pattern`, said in the evidence) and a terminal image; RED logs; gates: both typechecks, `npm run check`,
   the whole `test:web` file by file against main `ea504778` (0 changed by name except the intended AC4 flip), the five
   Figma replays byte-identical, `git diff --stat ea504778 -- src/core src/plugin src/shared src/ui` empty. Prove the new
   tests catch the bug (`git checkout HEAD~1 -- <fix files>` → RED, then restore).
5. Stop at `ready-for-review` with the branch clean.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wcs-b/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a
  time, closed after each step. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls; no
  redirects, heredocs or the bare word `source`. Live reads (GET only) only of the Hostinger site (`?f2b=`) and
  letsgro.ai; never write to any WordPress site. Put any summary in your report.

## Report

`status`, branch and last commit (full SHA), per AC its test, RED/GREEN and evidence paths, gates, `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
