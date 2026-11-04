# Role: builder: web-code-proof (the site's own HTML + CSS → Bricks, proved on one section)

You are a fresh builder for FigmaToBricksV2 (Opus 5.5, high effort at Justin's word). Build the approved plan test-first
and stop at `ready-for-review`. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never
bare `git stash`, never push or merge, don't bump `BUILD`, leave every other worktree alone, start no agents. Never load
bdryswi.com: the proof runs on the saved 2026-10-29 page served locally (plan's inputs).

## The plan (approved under the standing auto-go, ⭐ Q1–Q8 taken)

- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/plan-approved.md`
  (tasks T0–T14, ACs AC1–AC10; AC9 `(live)`, Justin's). Use each AC's exact test name from the plan.
- In git: branch `web-code-proof` at `953e50ed` (on main `31321bb4`), checked out in the planner's worktree, so in yours:
  `git switch -c web-code-proof-build 953e50ed`. Report this branch and its last commit.
- The planner's inputs and probes: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/planner/`
  (`inputs/bdry-2026-10-29/`, `inputs/bricks-frontend-light-layer.min.css`, `probe/`). The plan's T5/T7 code was
  validated by the planner: reuse it.
- Figma designs must convert byte for byte as on main (AC10). The new route lives in `src/core/site/` +
  `src/web/read/code.ts` (Q3 A); nothing in the Figma converter changes behaviour.
- If a task proves the plan wrong (a Bricks rule, the reset's print order, a control that can't hold a site value), stop
  that task, record the evidence, and report `status: stopped` with what you found and what you'd change; don't bend the
  plan silently.

## Work

Load `engineering-best-practices` and `test-driven-development`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; the repo `CLAUDE.md` (architecture rules) and `reference/bricks/README.md`.
1. Ledger `.superpowers/sdd/2026-11-04-web-code-proof/progress.md`; T0 baselines as the plan says.
2. Each task test-first: RED saved, then GREEN; commit after each passing task (plain `git commit -m`, no author override,
   no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. Records (T14): spec section, HANDOFF section (newest first) with paste check "id given at the merge" (the plan names
   3dc; confirm at merge) and AC9's steps for Justin in plain numbered words.
4. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof`): per AC its test log
   (`HEAD=` first, `EXIT=` last, skipped 0) and a picture (AC5/AC6: real render shots side by side with the stand-in at
   1440, 1024, 768, 390); RED logs; gates: both typechecks, `npm run check`, `test:web` file by file against main
   `31321bb4` (0 changed by name), renderer tests, the five Figma replays byte-identical, corpus equal to main. Prove the
   new tests catch the bug class (falsification runs the plan names).
5. Stop at `ready-for-review` with the branch clean.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wcp-b/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` or the CPU wrapper
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`. One Chrome job of your own at a
  time, closed after each step. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls; no
  redirects, heredocs or the bare word `source`. Live reads (GET only) only of the Hostinger site (`?f2b=`) and
  letsgro.ai; never write to any WordPress site. Put any summary in your report.

## Report

`status`, branch and last commit (full SHA), per task one line, per AC its test, RED/GREEN and evidence paths, gates,
`found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills
or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
