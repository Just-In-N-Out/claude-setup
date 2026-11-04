# Role: builder (Mini): web-reload-settled (a site's own reload that lands on the real page is the real page)

You are a fresh builder for FigmaToBricksV2. Build the approved plan test-first and stop at `ready-for-review`. Never
touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, never push or
merge, don't bump `BUILD`, leave every other worktree alone, start no agents.

## The plan (approved under the standing auto-go, ⭐ Q1–Q3 taken: same address ignoring `#` and `www.`; a log-in is a shown password field; plain captures judged by the same rule)

- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-reload-settled/plan-approved.md`
  (AC1–AC7; AC7 `(live)`, Justin's). Use each AC's exact test name from the plan.
- In git: branch `web-reload-settled` at `7767ff7e` (on main `31321bb4`), checked out in the planner's worktree, so in
  yours: `git switch -c web-reload-settled-build 7767ff7e`. Report this branch and its last commit.
- The planner's reproduction: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-reload-settled/planner/repro.test.ts`
  (RED on main). The plan's task 0 base tally (human-check and human-reload suites on base) was not run: run it first.
- Mini: stop with `status: stopped`, `stop_reason: escalate to full` only if it needs a design decision or anything that
  would hide automation.

**Hard rule:** nothing hides that the browser is automated (no new flags, navigator patches, user agents, stealth
scripts, nothing that clicks or types into a site's check; a test's click stands in for Justin only in tests). Never load
bdryswi.com.

## Work

Load `engineering-best-practices`, `test-driven-development` and `systematic-debugging`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`.
1. Ledger `.superpowers/sdd/2026-11-04-web-reload-settled/progress.md`.
2. Each task test-first: RED saved, then GREEN; commit after each passing task (plain `git commit -m`, no author override,
   no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. Records: HANDOFF section (newest first) with the paste check "id given at the merge" naming AC7's steps for Justin
   (restart the helper, reload the plugin, capture `bdryswi.com`, press I am human when asked, the capture box opens with
   no "page reloaded itself" note), ruling R1 replaced by Justin's 2026-11-04 ruling, follow-ups R1-1/R1-2 closed; spec line.
4. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-reload-settled`): per AC its test
   log (`HEAD=` first, `EXIT=` last, skipped 0; the opt-in real-window subtest may be left out with
   `--test-skip-pattern`, said in the evidence) and a terminal image; RED logs; gates: both typechecks, `npm run check`,
   the whole `test:web` file by file against main `31321bb4` (0 changed by name except the intended AC2 flip), the five
   Figma replays byte-identical, `git diff --stat 31321bb4 -- src/core src/plugin src/shared src/ui` empty. Prove the new
   tests catch the bug (`git checkout HEAD~1 -- <fix files>` → RED, then restore).
5. Stop at `ready-for-review` with the branch clean.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wrs-b/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a
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
