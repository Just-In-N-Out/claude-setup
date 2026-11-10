# Role: fixer (round 2: R2-1, R2-2, R2-3): site-slider

You are a fresh fixer for FigmaToBricksV2 (**Fable 5.2, high**). Fix review 2's three P2 findings test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** or any live site
(read-only GETs of Elementor's, Pro Elements' or Bricks' public GPL source are fine); no logins; never write to any
WordPress site. Nothing paid.

**Skills to load:** `receiving-code-review` (verify each finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Site sliders") and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-slider-fix2 84e591dbdaf6fe3e6237be89098204fb9ea8c085` (branch `site-slider-fix1`, on local `main`
`fd1986dcdbc8cf35f114b80be456e94279346743`); confirm HEAD and a clean status (after a restart, restore tracked files of
exactly 8388608 bytes). Check `git rev-parse main` is still `fd1986dc` (if it moved, say so; don't rebase).

## Inputs
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md` (AC3–AC6).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/review-2/review.json` (R2-1…R2-3 P2; R2-4,
  R2-5 P3). Its scratch page built from Elementor's real Swiper 8.4.5 and Pro Elements' / core's own CSS, its probe and
  readings: `/home/justin/.cache/ssl-r2/` (`fx/real/`, `probe-real.ts`, `probe-all.sh`, `out/real-head.json`,
  `out/real-base.json`, `src/`). Use that page as the model for a committed fixture.

## Work
1. **R2-1 (`src/core/site/elementor-slider.ts:94`):** Elementor Pro's Slides widget pastes 0 px tall (the site and main's
   paste: 400 px): every slider gets `height: "auto"`, Splide writes `height: auto` inline on each slide, and that beats
   the slide's own class height; Slides sizes its slides only by `.swiper-slide { height }` with nothing in flow inside.
   General rule: a slide keeps the height the site gives it — where the site's slide (or its track) has its own height
   the paste carries it so Splide's inline `height` can't cancel it (the height on the slider's own setting per tier, or
   `!important`, or an inner box: say which and why), and `height: "auto"` stays only where the slides size by their
   content (CLAUDE.md "Phone slider: `height: "auto"`, never `autoHeight`").
2. **R2-2 (`src/core/site/slider-css.ts:27`):** the restored `.splide__slide img { vertical-align: bottom }` makes every
   default Image Carousel 7 px shorter than the site (277 → 270). General rule: the restore class brings back only what
   Bricks' layered Splide CSS needs for the slider to work, at a weight that never beats the site's own look for the
   slide's content (the site's baseline gap stays as the site draws it).
3. **R2-3 (`src/core/site/elementor-slider.ts:258`):** `placedLike` refuses the site's arrow and dot places whenever the
   Swiper root isn't positioned, but Elementor makes the root `position: static` on Image Carousel and every Pro
   main-swiper: arrows land 10 px nearer each side and 11.5 px lower, dots across the pictures' bottom edge. General
   rule: copy the site's places whenever the box the site's arrows and dots answer to is the box Bricks' own arrows and
   dots answer to in the paste (compare the containing blocks' measured boxes, not the root's `position`), and the note
   says the truth.
   Test first: commit a fixture built from Elementor's own Swiper copy and widget CSS as the review's scratch page (a
   default Image Carousel and a Pro Slides widget; keep licences/attribution as the repo does for fetched assets), and
   browser tests reading site vs paste at 390, 600, 800, 1100 and 1440 (slider height, arrow and dot boxes within 2 px,
   `site:check --all --elementor` worst ≤ 2 px) — RED on `84e591db`, then GREEN; mutate each guard under the cap.
4. R2-4 (dots per page) stays deferred: add a note naming it when the dot count differs, if that is one line; put R2-4
   and anything else you defer in HANDOFF's site-slider "Deferred" list. (R2-5, the plan's Q4 A wording, is being amended
   by a planner: don't touch the plan.)
5. Gates before stopping: both typechecks, `npm run check` (in the worktree first), AC1–AC8's tests, AC9 named on the
   saved capture (8G scope), the five replays byte-identical to main, `test:web` and `test:browser` file by file under
   the 4 GB cap compared by name with fixer 1's `evidence/site-slider/fixer-1/gates/` (a `git archive` scratch copy with
   `dist/` built, logs starting `HEAD=<sha> (archive)`; rerun only differing files on main).
6. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/fixer-2/` (logs `HEAD=` first, `EXIT=` last). Keep
   scripts and logs under `~/.cache/ssl-f2/`, never the `/tmp` scratchpad.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ssl-f2/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start. One `bash <file>` per Bash call (scripts written with Write); start long drivers
  with `setsid --fork` and wait on their final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending | grep -v 'when mem'`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs
  under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry 8G). Waits under 115 s. The PC loses
  power now and then (a failing UPS): commit often.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), per finding: verified?, the rule, fix, tests, RED/GREEN
paths, mutation; gates; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
