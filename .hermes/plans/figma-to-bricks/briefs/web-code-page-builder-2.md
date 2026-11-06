# Role: builder: web-code-page (the code method for the whole page: header, page body, footer)

You are a fresh builder for FigmaToBricksV2 (Opus 5.5, xhigh at Justin's word, 2026-11-06). Build the approved plan test-first
and stop at `ready-for-review`. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never
bare `git stash`, never push or merge, don't bump `BUILD`, leave every other worktree alone, start no agents. Never load
bdryswi.com: work from the saved 2026-10-29 page served locally and Justin's 11-04 capture (plan's inputs).

## The plan (resumed 2026-11-06 with Amendment 1, approved under the standing auto-go, ⭐ Q1–Q14 taken)

- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md`
  (tasks 0–16 plus A1–A8, ACs AC1–AC19; AC12 and AC19 `(live)`, Justin's; its status block at the top says what is done). Use each AC's exact test name from the plan.
- **Resuming:** work in the existing copy `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a631038f87d3d7d43`,
  branch `web-code-page-build` at `34d50f76` (tasks 3 step 1, 4, 5, 6 done; amendment committed). First `git rebase main`
  (local main `ea504778`, one commit ahead: the BUILD bump + HANDOFF lines), then finish Task 0's baselines on the new
  base, fill and commit the untracked ledger, and carry on in the plan's order. Gates compare against `ea504778`, not
  `b86671a2`. web-capture-steady is **parked** (Justin, 2026-11-06): still leave `tools/capture.ts`'s Chrome finder alone.
- The planner's inputs and probes: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/planner/`
  (`probe/`, `capture.json` = Justin's 11-04 capture copy; the saved page's inputs are in
  `evidence/web-code-proof/planner/inputs/`).
- **Overlap:** another job, web-capture-steady, is building in `src/web/session.ts`, `src/web/human.ts`,
  `tools/capture.ts` and `tools/lib/helper-chrome.ts` (it gives `npm run capture` the helper's Chrome finder and adds
  `chromeMissingText`). Don't build a second Chrome finder for `tools/capture.ts`: your tools (`tools/site*.ts`) use the
  existing `tools/lib/helper-chrome.ts` `findChrome`, and leave `tools/capture.ts`'s finder to that job (say so in
  HANDOFF). If your reader v2 must touch `session.ts`, keep the change small and list it for the later rebase.
- Figma designs must convert byte for byte as on main (AC10). The route lives in `src/core/site/` + `src/web/read/code*.ts`;
  nothing in the Figma converter changes behaviour (the `asTyped` move is byte-neutral).
- If a task proves the plan wrong (a Bricks rule, the reset's print order, a control that can't hold a site value), stop
  that task, record the evidence, and report `status: stopped` with what you found and what you'd change; don't bend the
  plan silently.

## Work

Load `engineering-best-practices` and `test-driven-development`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; the repo `CLAUDE.md` (architecture rules) and `reference/bricks/README.md`.
1. Ledger `.superpowers/sdd/2026-11-04-web-code-page/progress.md`; T0 baselines as the plan says.
2. Each task test-first: RED saved, then GREEN; commit after each passing task (plain `git commit -m`, no author override,
   no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. Records: spec section, HANDOFF section (newest first) with paste check "id given at the merge" and AC12's steps for
   Justin in plain numbered words (a fresh `npm run capture`, `site:check --all`, the three pastes into the Header and
   Footer templates and the page, Regenerate code signatures, Purge All, compare at 1440/1024/768/390).
4. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page`): per AC its test log
   (`HEAD=` first, `EXIT=` last, skipped 0) and a picture (AC7/AC9: real render shots side by side at 1440, 1024, 768, 390;
   AC10: the whole-page check report on Justin's capture); RED logs; gates: both typechecks, `npm run check`, `test:web` file by file against main
   `ea504778` (0 changed by name), renderer tests, the five Figma replays byte-identical, corpus equal to main. Prove the
   new tests catch the bug class (falsification runs the plan names).
5. Stop at `ready-for-review` with the branch clean.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wpg-b/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` or the CPU wrapper
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
