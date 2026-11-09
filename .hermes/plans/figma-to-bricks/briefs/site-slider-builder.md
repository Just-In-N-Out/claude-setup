# Role: builder (Full): site-slider (website importer)

You are a fresh builder for FigmaToBricksV2 (Opus 5.5, high). Build the approved plan test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com**; no logins; never
write to any WordPress site. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (guards),
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md`, `references/live-site-reading.md` and `references/rendering-validation.md`, the repo
`CLAUDE.md` ("Build general logic": nothing keyed on B-Dry) and `reference/bricks/README.md`.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md`. Take every ⭐
  answer (Justin: "whatever the plan agent recommends just go with that"). The planner's evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/site-slider/planner/` (and staging-fit's `evidence/staging-fit/planner/README.md`).
- Your own worktree (you start in it): `git checkout -B site-slider-build fd1986dcdbc8cf35f114b80be456e94279346743` (local
  `main`, Build 2026-11-09.3; check `git rev-parse main` and say if it moved: if so, use it). Report your branch.
- Overlaps (from the plan): staging-fit-capture merges first (both touch `test/browser/render.ts` and
  `test/web/lib/site-check.ts`); site-faq and site-menu share small insertion points (`elementor-fold.ts` widget branches,
  `classes.ts` `SHARED_CSS`, `convert.ts` appended looks, the renderer's Bricks script list): keep the slider in its own
  module; site-reviews may reuse your settings writer; site-native-structure may fold the widget's wrappers. The planner
  saved byte copies of Bricks' `splide-layer.min.css`, `splide.min.js` (4.1.4) and the slider element CSS in
  `evidence/site-slider/planner/bricks-assets/` for `reference/bricks/frontend-2.3.9/`. Never load bdryswi.com.
- The paste check id: write `<site-slider id at merge>` in HANDOFF.

## Work
1. Follow the plan's tasks in order, each test first (RED on base, then GREEN), one commit each; copy the plan to
   `docs/plans/2026-11-09-site-slider.md` as Task 0; ledger in `docs/plans/2026-11-09-site-slider-ledger.md` (in git, committed with
   each task); `npm run corpus` before Task 1 and at the close.
2. Mutate the guards under the cap.
3. Gates before stopping: both typechecks, `npm run check`, `npm run corpus` (same as base; v1's Mac files are missing),
   every AC's test with a log starting `HEAD=` and ending `EXIT=`, `test:web` and `test:browser` file by file under the
   4 GB cap compared by name with base (run base's side too), the five replays byte-identical, a screenshot per AC (a
   terminal image for a non-visual AC).
4. HANDOFF: a site-slider section (the rule, the ⭐ rulings as "not yet confirmed", known limits, paste check
   `<site-slider id at merge>` for the live AC).
5. Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only`
   without CLAUDE.md. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/builder/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ssl-b/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start (kill by its profile path if Node dies). Worktree `node_modules` may lack `.bin`:
  see testing-pitfalls. One `bash <file>` per Bash call (scripts written with Write); wait on a driver's final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry captures and renders 8G) with a bounded `--test-timeout`;
  `compare-corpus.test.ts` needs 3600000 ms. Waits under 115 s.
- After a machine restart, look for tracked files of exactly 8388608 bytes (`git status`) and restore them before a run.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), per AC: test, RED/GREEN paths, screenshot; mutation;
gates vs base; deviations from the plan; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
