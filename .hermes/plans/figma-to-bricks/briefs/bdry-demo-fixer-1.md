# Role: fixer (round 1, time-boxed: review 1's R1-1 and the small hand-over fixes): bdry-demo

You are a fresh fixer (**Opus 5.5, high**). **Hard time box: 35 minutes from your start (it is about 10:35; stop by
11:10 whatever is left, and report the numbers).** Review 1 found the paste within 4 px at the seven measured widths
but far off between them. Fix it test-first where it fits the box, then stop at `ready-for-next-review`.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** in any way, B-Dry staging or any
live site (the checks' Chrome reaches only 127.0.0.1 and Google Fonts). No logins; never write to any WordPress site.
Change nothing under `src/`, `dist/`, `tools/` or `manifest.json`. Never stop a Chrome you didn't start; touch nothing
under `~/Downloads`.

**Skills:** `receiving-code-review`, `engineering-best-practices`, `git-commit-rules`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Your copy
`git checkout -B bdry-demo-fix1 340a8d64f43977790f4be40ea2eb9c19c0bec4dd` (branch `bdry-demo-build`, on main
`e16d3d1e`). The paste is made only by `test/demo/bdry-home/build-demo.ts`.

## Inputs
- Approved plan (amended A1–A2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/plan-approved.md`.
- Review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/review-1/review.json`; its own sweep logs
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/verifier/checks-own/own-fit-*.log`.

## Fix, in this order (stop at the box)
1. **R1-1 (P2), the gaps between the measured widths.** The fit check passes by construction at its seven widths
   because the fixes are constants read there. Add a **sweep** mode to `demo-fit.ts` (every width the capture holds,
   48, plus Bricks' preview buttons 991, 767, 478, plus 1366 and 1920) and run it first: that is your RED. Then fix
   the worst first, as general CSS for each band of widths, not per-width constants:
   - **the FAQ** (−111.5 px at 991, −177 at 478, −110 at 1196/1366): the mascot picture is a fixed width per tier and
     the section's height follows it — give it the site's own proportional sizing (read its rule in the capture /
     saved CSS) and re-measure;
   - then Fee Construction (+76.5 at 1008, −207.9 at 2560), the red-flags heading (+69.3 at 834), About (+38.1 at
     412), Contact / Footer at 360, Footer at 1920 / 2560.
   Every width the sweep still shows over 4 px goes into `gaps.json`, named, with its px — honestly, however many.
   The seven-width ACs (AC3–AC6) must still pass.
2. **The hand-over says the truth:** `PASTE-STEPS.md` step 14 names widths the paste was checked at (1440, 1024 or
   768, 767, 390, and any you fixed); `WHAT-STAYS-OUT.md` says plainly how close it is at every width (the sweep's
   result in one or two lines) and adds the plan's A2 line (the pictures' left side is the slightly older saved page,
   so text-heavy sections don't line up exactly there).
3. **R1-2 (P3, one line):** the footer map's iframe keeps its `border:0` and rounded corners (the `style` attribute
   was renamed to `data-s`): carry them in the element's class or the iframe's own allowed attribute.
4. If time is left: R1-4 (the start file's custom CSS also makes `#brx-header`, the site's own header template, sticky
   — scope it to the pasted header only).

Rebuild with `build-demo.ts`, rerun AC1–AC10's checks and the sweep, copy the final paste and hand-over set over the
deliverable in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/` (`bdry-home-demo.json`, `shots/`,
`PASTE-STEPS.md`, `gaps.json`, `WHAT-STAYS-OUT.md`). Logs under `evidence/bdry-demo/fixer-1/`, each `HEAD=` … `EXIT=`.
Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, no CLAUDE.md staged.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bdf/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by its profile path's
PIDs; never `pkill -f`); shoot each page alone. A worktree's `node_modules` may lack `.bin` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). A piped, chained or redirected git command, a
heredoc or a shell function may be refused: script files and `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s. One final report; no interim hand-backs.

## Report (as text)
`status: ready-for-next-review`, branch, last commit (full SHA), minutes used; the sweep before and after (worst gaps
per section); AC1–AC10 results; what `gaps.json` now says in plain words; `found_else`; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
