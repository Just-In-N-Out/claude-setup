# Role: builder (Mini): web-human-reload (the "I am human" flow: switch points from the passed page; a site's reloads never end a capture)

You are a fresh builder for FigmaToBricksV2. Build the approved plan test-first and stop at `ready-for-review`. Never
touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, never push or
merge, don't bump `BUILD`, leave every other worktree alone, start no agents. Another job (web-photo-crop) changes
`src/core/normalise/measured.ts` and `src/core/style/picture.ts`: stay out of them (this job changes nothing under
`src/core`, `src/plugin`, `src/shared`, `src/ui`).

## The plan (approved under the standing auto-go, ⭐ Q1–Q3 taken: 2 s quiet, 3 tries, also for sites with no check)

- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload/plan-approved.md`
  (AC1–AC8; AC8 `(live)`, Justin's). Use each AC's exact test name from the plan.
- In git: branch `web-human-reload-2` at `76a37dc9` (on main `39d96c98`), checked out in the planner's worktree, so in
  yours: `git switch -c web-human-reload-build 76a37dc9`. Report this branch and its last commit.
- The planner's reproduction: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload/planner/`
  (`probe-reload.ts`, `run-probe.sh`, logs): MODE=a gives bug A, MODE=b bug B on `39d96c98`. Turn them into the plan's
  tests on the stand-in (`test/fixtures/web/check-site.ts`).
- Mini: stop with `status: stopped`, `stop_reason: escalate to full` only if it needs a design decision or anything that
  would hide automation.

**Hard rule:** nothing hides that the browser is automated (no `AutomationControlled` flag, no `navigator.webdriver`
patch, no new user agent, no stealth script, nothing that clicks or types into a site's check; a test's click stands in
for Justin only in tests). Never load bdryswi.com.

## Work

Load `engineering-best-practices`, `test-driven-development` and `systematic-debugging`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`.
1. Ledger `.superpowers/sdd/2026-11-04-web-human-reload/progress.md`.
2. Each task test-first: RED saved, then GREEN; commit after each passing task (plain `git commit -m`, no author override,
   no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. Records: spec (`docs/specs/web-capture.md`'s human-check section) and a HANDOFF section (newest first) with the paste
   check "id given at the merge" naming AC8's steps for Justin (restart `npm run capture:serve`, reload the plugin, capture
   `bdryswi.com`, press I am human each time asked, the switch-point line lists real points, the box title isn't
   "Checking your browser…", Page → Convert and copy); close web-human-check's follow-up R1-5 there.
4. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload`): per AC its test
   log (`HEAD=` first, `EXIT=` last, skipped 0 except the opt-in visible-window test) and a terminal image; RED logs;
   gates: both typechecks, `npm run check`, the whole `test:web` file by file against main `39d96c98` (0 changed by name),
   the five Figma replays byte-identical, `git diff --stat 39d96c98 -- src/core src/plugin src/shared src/ui` empty.
   Prove the new tests catch the bugs (`git checkout HEAD~1 -- <fix files>` → RED, then restore).
5. Stop at `ready-for-review` with the branch clean.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/whr-b/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (or the CPU wrapper
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`). One Chrome job of your own at a
  time, closed after each step. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write multi-step scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls;
  no redirects, heredocs or the bare word `source` in a command. Live reads (GET only) only of the Hostinger site (`?f2b=`)
  and letsgro.ai; never write to any WordPress site. Put any summary in your report.

## Report

`status`, branch and last commit (full SHA), per AC its test, RED/GREEN and evidence paths, gates, `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
