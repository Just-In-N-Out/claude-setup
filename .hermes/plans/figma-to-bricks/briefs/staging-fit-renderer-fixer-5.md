# Role: fixer (round 5, narrow: review 5's R5-1, P2 — the drawing's locator and a slider with per-width settings): staging-fit-renderer

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 5's one P2 test-first, plus one small P3 step
named below, then stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never
bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase, leave other worktrees alone, start no agents.
Never load bdryswi.com, B-Dry staging, an embed host or any live site (local stand-in servers and saved files only); no
logins; never write to any WordPress site. Nothing paid. Nothing may hide that the tool's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify the finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Measure a published Bricks page against its paste by structure"; "Site sliders"),
and the repo `CLAUDE.md` ("Bricks gives pasted elements new ids": scripts and locators find elements by class).

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-renderer-stack1-fix5 9feaf48f9bd43f676e3b4fa921fdf5f9bc99f960` (the reviewed head, branch
`staging-fit-renderer-stack1-fix4`), confirm `git rev-parse HEAD` and a clean status. The job sits on a stack:
`main ← site-faq ← site-reviews ← site-slider (7d9754ed) ← this job`. Report your branch; work only in your own copy.

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`.
  Don't change the plan or any AC.
- Review 5: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-5/review.json`; its probes
  `~/.cache/sfr-r5/probes/` (`carousel-missing.ts`, `dump-hook.mjs`, `dump-hook2.mjs`, `slider-live.ts`) and logs
  `~/.cache/sfr-r5/logs/` (`carousels-dump4.log`).

## The finding
**R5-1 (P2, `tools/site-live.ts:247`):** `site:live`'s renderer comparison says every real slide of a slider with
per-width settings is missing from the drawing. The drawing is read by `{ id }`, which looks for `#brxe-<id>`. In the
drawing tab, Splide re-mounts a slider that has breakpoints when the tab's width changes, and the real slides come back
with Splide's own ids (`brxe-ofmgpg-slide01`; they keep their `brxe-<id>` class), so the locator finds nothing and reads
null, while the published page is found by `data-f2b` marks and has the box: "Renderer (Bricks 2.4.2) against the page:
FAIL, worst missing" at every width. Proof: the elementor-carousels fixture's exact paste — the page is OK at 0 px, the
first slide reads {x 150, w 380, h 253} on the page and null in the drawing at 1440, 768 and 390; the slider without
breakpoints keeps its ids. Real use: `npm run site:live … --elementor` on any importer paste holding an Elementor
carousel that shows 3 cards on desktop, 2 on tablets and 1 on phones (the importer writes `perPage:<bp>`).

## Work
1. Verify it yourself first.
2. **Fix as a rule for every place this job's tools find a pasted element in a drawn or published page:** an element is
   found by what survives a library re-mount and a paste (its `brxe-<id>` class or the tool's own mark), never by its
   `id` attribute alone, and never a library's copy (`libraryCopy`). Either read the drawing by the same marks the page
   is read by, or let the id locator fall back to the `brxe-<id>` class; choose the one that keeps `site:check`'s
   results byte for byte (it shares `locateInPage`) and say why. Grep `tools/` and `test/web/lib/` for other `#brxe-` /
   `getElementById("brxe-` uses in this job's tools and treat them alike.
3. **Test first (RED on `9feaf48f`):** a `site:live` web test on a published stand-in holding a slider with per-width
   settings (the elementor-carousels fixture's `--elementor` paste as Bricks prints it; the tool's drawing tab crossing
   widths): the renderer line is OK within the tool's tolerance at every width, no slide "missing", exit 0; plus the
   control (a slider without breakpoints) unchanged. And a `shoot-section`-style unit of the locator: an element whose
   id attribute a library replaced is found by its class, never a copy placed before it.
4. **Small (review 5's R5-2), a few lines with a test:** when a live widget draws nothing on the published page (its
   slot's box has no height there: the loader failed, or code signatures weren't regenerated), `site:live` says so in
   one plain line naming the widget and its host ("the page drew nothing for … : if this is a fresh paste, regenerate
   code signatures in Bricks and purge the cache"), beside the numbers it already reports; exit code unchanged.
5. Mutate what you add (the class fallback or the mark reading removed; the copy rule removed from it; the plain line
   removed), under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
6. Records batched into your commits: HANDOFF's staging-fit-renderer section and the ledger ("Fix pass 5").
7. Gates on a `git archive` scratch copy of your head: both typechecks, `npm run check`, this job's story files and its
   four round-4 tests plus yours, and the stacked jobs' AC web files (the lists in
   `evidence/staging-fit-renderer/stack-1/logs/head-story/` and `head-stack/`, and
   `evidence/staging-fit-renderer/fixer-4/gates/`), each alone under the 4 GB cap, one Chrome job at a time: all exit 0.
   **`site:check`'s `report.json` and stdout byte-identical between `9feaf48f` and your head** on the elementor-swiper8
   (`--elementor`), elementor-carousels (`--elementor`), elementor-slider (`--elementor`), live-widget and
   live-widget-places fixtures; a plain page's `site:live` `report.json` equal apart from `read`. Commit after each
   passing step (plain `git commit -m`, or `-F <file>` when the message holds a backslash or parentheses with colons; no
   author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/fixer-5/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-f5/tmp`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too: check by your own profile path that none of yours is left after each probe, and never
  signal a process group other agents' Chromes are in. A worktree's `node_modules` may lack `.bin` and a scratch tree
  has no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Multi-step commands from a
  script file written with Write; scripts and logs under `~/.cache/sfr-f5/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); say so, find what grew, rerun under the cap.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA), R5-1: verified?, the rule, the fix, tests, RED/GREEN paths,
mutation; step 4; gates vs the reviewed head; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
