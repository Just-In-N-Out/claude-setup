# Role: builder (Mini): elementor-footer-fit (website importer)

You are a fresh builder for FigmaToBricksV2 (Opus 5.5, high). Build the approved plan test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** or any live site; no
logins; never write to any WordPress site. Nothing paid.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (fold rule 9 is
a guard), `git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` and `references/rendering-validation.md`, the
repo `CLAUDE.md` ("Build general logic": nothing keyed on B-Dry) and `reference/bricks/README.md`.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/plan-approved.md`
  (AC1–AC6; AC6 live, Justin's). Questions Q1 and Q2: take the ⭐ answers (A, A) under the standing auto-go.
- Your own worktree (you start in it, from `origin/main`): `git checkout -B elementor-footer-fit-build dab961f9c30755b1890adc478ee9fdf3d5431516`
  (elementor-phone-fit's head, branch `elementor-phone-fit-build`, in review now; base `7ff9ba4a`). This job builds on it
  (rule 9 after rule 8); if phone-fit's head moves (a fix), you'll be told. Don't rebase onto `main`. Report your branch.
- The planner's receipts and probe: `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/planner/`
  (the saved stand-in `bdry-standin.f2b-capture.json` saves the 32-minute capture; the probe; the reverted experiment).
- Merging before this one: site-motion (adds a refusal in `foldable`'s first loop, `elementor-fold.ts` ~126) and
  elementor-phone-fit (rule 8). Keep rule 9 after rule 8 at the end of `foldable` as the plan says. The planner's
  prototype diff and probe are in its receipts; check `web.code.version` of any stand-in you reuse (phone-fit's fresh v2
  stand-in: `evidence/elementor-phone-fit/builder/ac1/head-fresh/standin-capture.json`).
- The paste check id: write `<elementor-footer-fit id at merge>` in HANDOFF (the finisher gives it the next free id; the
  plan's "3dl" may be taken by then).

## Work
1. Follow the plan's tasks in order, each test first (RED on base, then GREEN), one commit each; ledger in
   `.superpowers/sdd/2026-11-08-elementor-footer-fit/progress.md`; `npm run corpus` before Task 1 and at the close.
2. Mutate rule 9's guard (the height comparison, the tolerance, the margins and units counted, the first measured chain
   element, skipped ranges, rule 8's precedence) under the cap.
3. Gates before stopping: both typechecks, `npm run check`, `npm run corpus` (same as base; v1's Mac files are missing
   here), every AC's test with a log starting `HEAD=` and ending `EXIT=`, `test:web` and `test:browser` file by file under
   the 4 GB cap compared by name with base (run base's side too, or reuse a base tally you made in this run), the five
   replays byte-identical, a screenshot per AC (site | paste at 390 for AC1/AC2; a terminal image otherwise).
4. HANDOFF: an elementor-footer-fit section (the rule, rulings Q1 A / Q2 A as "not yet confirmed", known limits, paste
   check `<elementor-footer-fit id at merge>` for AC6), and mark elementor-map's open "Facebook" footer row (and phone-fit's known limit) as fixed by this job.
5. Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only`
   without CLAUDE.md. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/builder/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-b/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: close every Chrome you
  start (kill by its profile path if Node dies). Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run
  multi-step commands from a script file written with Write, paths spelled out.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` with a bounded `--test-timeout`.
- After a machine restart, look for tracked files of exactly 8388608 bytes (`git status`) and restore them before a run.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), per AC: test, RED/GREEN paths, screenshot; mutation;
gates vs base; deviations from the plan; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
