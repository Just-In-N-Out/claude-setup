# Role: builder (Full): staging-fit-cancels (website importer)

You are a fresh builder for FigmaToBricksV2 (Fable 5.2, high). Build the approved plan test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging** or
any live site (local fixture servers and saved files only); no logins; never write to any WordPress site. Nothing paid.
Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`,
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md`, `references/live-site-reading.md` and `references/rendering-validation.md`, the repo
`CLAUDE.md` ("Build general logic": nothing keyed on B-Dry; "CSS stays typed": never regex or string-match CSS) and
`reference/bricks/README.md`.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md`.
  Take every ⭐ answer (Justin: "whatever the plan agent recommends just go with that"). The planner's evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (index in its `README.md`).
- Your own worktree (you start in it): `git checkout -B staging-fit-cancels-build __CAPTURE_HEAD__` — the accepted head
  of `staging-fit-capture` (on local `main` `fd1986dcdbc8cf35f114b80be456e94279346743`, Build 2026-11-09.3, or `main`
  itself once that job has merged: check `git rev-parse main` and say which you built on). Your review base is that
  commit. Report your branch.
- Also in the plan's scope, from staging-fit-capture's review 2 (R2-4, a P3 handed to this job): `revert` written for a
  shorthand's longhands. Read its line in
  `~/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/follow-ups.md` and cover it with the same rule (no
  `revert` outside `site-reset`).
- Overlaps (other jobs, not merged, building beside you; keep your edits small and in the functions the plan names so the
  later rebase is easy): site-faq (`src/core/site/elementor-accordion.ts` `lookCss` already writes bounded runs: reuse
  its helper if it is on your base, else write one shared helper it can adopt; don't edit its file), site-native-structure
  (`controls.ts`, `classes.ts`), site-slider (`blocks.ts` flags), staging-fit-renderer (the renderer's `.cls.brxe-<el>`
  selectors: not on your base, so say in HANDOFF which renderer your proofs drew with).
- B-Dry proofs: Justin's capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` is now refused (styleless
  768–991): use the code-bearing stand-ins (`~/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/planner/bdry-standin.f2b-capture.json`,
  `~/.cache/sm-b/bdry-standin-v3.f2b-capture.json`, or your own stand-in capture from the saved 2026-10-29 files, about
  7–9 min under an 8G scope) and say it is a saved stand-in, not the live site.
- The paste check id: write `<staging-fit-cancels id at merge>` in HANDOFF.

## Work
1. Follow the plan's tasks in order, each test first (RED on base, then GREEN), one commit each; copy the plan to
   `docs/plans/2026-11-09-staging-fit-cancels.md` as Task 0; ledger in `docs/plans/2026-11-09-staging-fit-cancels-ledger.md`
   (in git, committed with each task); `npm run corpus` before Task 1 and at the close.
2. Mutate the run-building logic under the cap (a run's min, its max, the unbounded widest and narrowest runs, the
   control-nesting test of Q2 A).
3. Gates before stopping: both typechecks, `npm run check`, `npm run corpus` (same as base; v1's Mac files are missing),
   every AC's test with a log starting `HEAD=` and ending `EXIT=` (each cited test name whole on one plan line: it is),
   every site proof the plan's Task 4 names within its tolerance, `test:web` and `test:browser` file by file under the
   4 GB cap compared by name with base (run base's side too), the five replays byte-identical, a screenshot per AC (the
   button at 600, site | paste, for AC1; a terminal image for a non-visual AC).
4. HANDOFF: a staging-fit-cancels section (the rule, Q1 A and Q2 A as "not yet confirmed", known limits, paste check
   `<staging-fit-cancels id at merge>`).
5. Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only`
   without CLAUDE.md. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/builder/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfx-b/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start (kill by its profile path if Node dies). Worktree `node_modules` may lack `.bin`:
  see testing-pitfalls. One `bash <file>` per Bash call (scripts written with Write, kept under `~/.cache/sfx-b/`; a
  restart empties `/tmp`); wait on a driver's final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry captures and renders 8G) with a bounded `--test-timeout`;
  `compare-corpus.test.ts` needs 3600000 ms. Waits under 115 s.
- After a machine restart, look for tracked files of exactly 8388608 bytes (`git status`) and restore them before a run.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), per AC: test, RED/GREEN paths, screenshot; mutation;
gates vs base; deviations from the plan; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
