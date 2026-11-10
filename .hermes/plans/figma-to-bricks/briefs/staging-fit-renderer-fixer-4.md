# Role: fixer (round 4: review 4's R4-1 and R4-2, both P2, where `site:live` meets the stacked jobs): staging-fit-renderer

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 4's two P2 findings test-first, plus two small
P3 steps named below, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase,
leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging, an embed host or any live site
(local stand-in servers and saved files only); no logins; never write to any WordPress site. Nothing paid. Nothing may
hide that the tool's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Holding a Chrome to read-only"; "Measure a published Bricks page against its paste
by structure") and `references/rendering-validation.md`, and the repo `CLAUDE.md`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-renderer-stack1-fix4 898e0ebd71533244fe87fdc0eaf2c3c537a3ce3f` (the reviewed head, branch
`staging-fit-renderer-stack1`), confirm `git rev-parse HEAD` and a clean status. The job sits on a stack:
`main 3cfc54ac ← site-faq-stack1 ← site-reviews-stack1 ← site-slider-stack1-fix3 (7d9754ed) ← this job`. Report your
branch; work only in your own copy.

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`
  (AC2, AC5). Don't change the plan or any AC.
- Review 4: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-4/review.json`; its probes
  `~/.cache/sfr-r4/probes/slider-live.ts`, `widget-drawing.ts` and logs `~/.cache/sfr-r4/logs/slider-live.log`,
  `widget-drawing.log`.

## The findings
**R4-1 (P2, `tools/site-live.ts:177`):** `site:live` maps the paste onto Splide's loop copies of a looping Slider
(Nestable). The mapping walk `kids()` counts every brxe element, `.splide__slide--clone` copies included, and puts each
slide's `data-f2b` mark on the copy at that index (the rebase kept `find()`'s "the real slide, never a Splide copy" rule
only for the `{id}` locator; the marks are placed by this walk). The elementor-slider fixture's whole `--elementor`
paste, printed as Bricks 2.4.2 prints it, gives "not mapped: … the page has 7 elements under it, the paste 3", three
slides "not the paste's element", FAIL, exit 1; the same page with the slider's type "slide" (no copies) is OK at 0 px.
Real use: AC5's run on B-Dry's re-pasted `--elementor` home, whose hero is a looping slider.

**R4-2 (P2, `tools/site-live.ts:200`):** `site:live`'s renderer drawing adds no stand-in for a pasted live widget, and
the renderer swaps every https script src for `about:blank` (`test/browser/render.ts:238`), so a widget loaded over
https (B-Dry's Trustindex reviews) draws nothing in the drawing while the published page runs it: the slot is 1312×160
against 1312×0 at 1440 and 262×220 against 262×0 at 390, and everything below the slot, and the part root, is off by
the widget's height ("Renderer (Bricks 2.4.2) against the page: FAIL", naming no widget).

## Work
1. Verify both yourself first (the reviewer's probes, or your own).
2. **R4-1, as a rule for every structural walk in this job's tools, not only `kids()`:** a copy an element library makes
   of a pasted element (Splide's `.splide__slide--clone`, and anything inside one) is never one of the paste's elements:
   the walk skips it, marks land on the real elements, and counts compare real elements only. Grep `tools/` and
   `test/web/lib/` for every walk over `brxe-` elements and treat them alike (one shared predicate, used by `find()`'s
   id rule too). Test first: a `site:live` web test whose published stand-in holds a looping Slider (Nestable) as Bricks
   prints and Splide mounts it (reuse site-slider's fixtures and renderer pieces already on this stack; several slides
   in view, so copies sit before the real slides): every slide maps, the run is OK within the tool's tolerance, exit 0;
   and the control without copies stays OK. RED on `898e0ebd`, then GREEN.
3. **R4-2:** in `site:live`'s drawing each live slot is stood in at the **published page's own slot box at that width**
   (measured from the page being read), so what sits below it is compared at the right place; the slot and the boxes
   inside it are left out of `compareDrawings` and named in `report.json` and in the tool's line (which widgets, how
   many boxes). Reuse `site:check`'s live stand-in code (`liveStandIn`, `siteParts`' `live`) rather than a second copy.
   Test first: a `site:live` web test on a published stand-in holding a live widget in a slot (a local stand-in script
   served from 127.0.0.1 standing for the widget's host; site-reviews' `live-widget` fixtures show how), with content
   below it: OK, the widget named, exit 0; RED on `898e0ebd` (160 px / 220 px off), then GREEN. The read-only guard
   still lets nothing but GET/HEAD/OPTIONS reach the published stand-in.
4. **Small, each a few lines with a test:**
   - R4-3: `site:live` refuses a capture holding a width range read without the site's styles exactly as `site` and
     `site:check` do (`unstyledLine`, exit 2, the same line), before any page is opened.
   - R4-5: `shootSection` (`test/web/lib/site-check.ts:366`) gets a branch for the `{ css }` locator, or throws a plain
     error naming it, so a later caller can't silently shoot the wrong box.
5. Mutate what you add (the copy predicate removed from each walk; the stand-in removed; the slot not left out of the
   compare; the refusal removed), under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
6. Records batched into your commits: HANDOFF's staging-fit-renderer section (what `site:live` does with a looping
   slider and a live widget; the refusal) and the ledger ("Fix pass 4").
7. Gates on a `git archive` scratch copy of your head: both typechecks, `npm run check`, this job's story files
   (`evidence/staging-fit-renderer/stack-1/logs/head-story/` lists them) plus your new tests, each alone under the 4 GB
   cap (one Chrome job at a time; `site-live-reports` takes about 90 s), and the stacked jobs' AC web files the stack
   finisher ran (`stack-1/logs/head-stack/`): all exit 0. `report.json` of a plain page (no slider, no widget) from
   your head equals `898e0ebd`'s apart from the fields that must differ. Commit after each passing step (plain
   `git commit -m`, or `-F <file>` when the message holds a backslash or parentheses with colons; no author override,
   no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/fixer-4/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-f4/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: check by your own profile path that none of yours is left after each probe, and never signal a process
  group other agents' Chromes are in. A worktree's `node_modules` may lack `.bin` and a scratch tree has no `tsc` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Multi-step commands from a script file written
  with Write; scripts and logs under `~/.cache/sfr-f4/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); say so, find what grew, rerun under the cap.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA), per finding: verified?, the rule, fix, tests, RED/GREEN
paths, mutation; the small steps; gates vs the reviewed head; `found_else`; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
