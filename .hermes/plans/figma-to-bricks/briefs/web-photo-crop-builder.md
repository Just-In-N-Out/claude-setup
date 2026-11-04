# Role: builder (Mini): web-photo-crop (a captured picture that keeps its shape stays whole)

You are a fresh builder for FigmaToBricksV2. Build the approved plan test-first and stop at `ready-for-review`. Never
touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, never push or
merge, don't bump `BUILD`, leave every other worktree alone, start no agents. Another job (web-human-reload) changes
`src/web/human*.ts`, `src/web/session.ts` and `test/browser/chrome.ts`: stay out of them.

## The plan (approved under the standing auto-go, ⭐ Q1A taken)

- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-photo-crop/plan-approved.md` (AC1–AC6;
  AC6 `(live)`, Justin's). Use each AC's exact test name from the plan.
- In git: branch `web-photo-crop` at `64471b0e` (on main `39d96c98`), checked out in the planner's worktree, so in yours:
  `git switch -c web-photo-crop-build 64471b0e`. Report this branch and its last commit.
- Mini: stop with `status: stopped`, `stop_reason: escalate to full` only if it needs a design decision or reaches well
  past the plan's ~3 source files.

## Work

Load `engineering-best-practices` and `test-driven-development`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`.
1. Ledger `.superpowers/sdd/2026-11-04-web-photo-crop/progress.md`; `npm run corpus` before Task 1 and at the close (Mac
   corpus paths don't resolve on this desktop: re-point to the local copies and compare with main, as testing-pitfalls says).
2. Each task test-first: RED saved, then GREEN; commit after each passing task (plain `git commit -m`, no author override,
   no AI or Co-Authored-By lines, no CLAUDE.md staged). Generic fixtures only, never a copy of bdryswi.com.
3. Records: a HANDOFF section (newest first) with the paste check "id given at the merge" naming AC6's steps for Justin
   (re-open `~/Downloads/bdryswi-com-home.f2b-capture.json` with Open website capture…, Page → Convert and copy, paste,
   the three cards whole at desktop and phone), and the one-capture-width risk.
4. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-photo-crop`): per AC its test log
   (`HEAD=` first, `EXIT=` last, skipped 0) and a terminal image (AC3: a real render shot); RED logs; gates: both
   typechecks, `npm run check`, the browser files the change can touch plus `test/browser/web-picture-ratio.test.ts`, the
   five Figma replays byte-identical, and `E/builder/capture-diff.txt` (bdryswi.com Page before/after: only marked pictures
   change). Prove the new tests catch the bug (`git checkout HEAD~1 -- <fix files>` → RED, then restore).
5. Stop at `ready-for-review` with the branch clean.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wpc-b/tmp`); Chrome found by itself or `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`. One Chrome job of your own at a
  time, closed after each step. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write multi-step scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls;
  no redirects, heredocs or the bare word `source` in a command. Never load bdryswi.com; never write to any WordPress site.
  Put any summary in your report.

## Report

`status`, branch and last commit (full SHA), per AC its test, RED/GREEN and evidence paths, gates, `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
