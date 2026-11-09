# Role: fixer (round 1: R1-1, R1-2, R1-3): site-slider

You are a fresh fixer for FigmaToBricksV2 (**Fable 5.2, high**). Fix review 1's three P2 findings test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** or any live site
(read-only GETs of Bricks' or Elementor's public GPL source on GitHub are fine); no logins; never write to any WordPress
site. Nothing paid.

**Skills to load:** `receiving-code-review` (verify each finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Site sliders") and `references/rendering-validation.md`, the repo `CLAUDE.md` ("Bricks
element shapes come from `reference/bricks/*.json`"; "Build general logic") and `reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-slider-fix1 1b193b4513addb99c90669a75a09c922efac1bc7` (branch `site-slider-build2`, on local `main`
`fd1986dcdbc8cf35f114b80be456e94279346743`); confirm HEAD and a clean status (after a restart, restore tracked files of
exactly 8388608 bytes). Check `git rev-parse main` is still `fd1986dc` (if it moved, say so; don't rebase). Report your branch.

## Inputs
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md` (AC2, Q4 A).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/review-1/review.json` (R1-1…R1-3 P2;
  R1-4…R1-6 P3) and anything it saved beside it.

## Work
1. **R1-1 (`elementor-slider.ts:92`, :81, :147-152):** arrows and looping are read only from Elementor core's keys
   (`navigation`, `arrows`, `infinite`); Elementor Pro's carousel base (Testimonial, Media, Reviews carousels) prints
   `show_arrows`, `loop`, `slides_per_view`, `space_between`, so such a slider pastes with no arrows and rewinds instead of
   looping. General rule: read each setting from every key family Elementor prints it under (check the families against
   Elementor's and Pro's own source, e.g. proelements `modules/carousel/widgets/base.php`), and when the settings are
   unknown or silent, decide from what the capture shows (arrow or bullet elements on the page, loop copies), never from a
   missing key; the notes say what was decided. HANDOFF and the module header claim only what is tested.
2. **R1-2 (`:76`):** a carousel without pause on hover is written `pauseOnHover: false, pauseOnFocus: false`; Bricks reads
   checkbox settings with `isset()` (2.2 GPL `slider-nested.php` `render()`: verify against the newest Bricks source you can
   read and `reference/bricks/`), so a stored `false` counts as ticked. General rule: a Bricks checkbox key is written only
   when true, never `false` (every checkbox key the slider writes: autoplay, pauseOnHover, pauseOnFocus, rewind, arrows,
   pagination…); make the renderer's `flag()` (`test/browser/render-slider.ts:16`) read them as Bricks does so a browser
   test can see it; fix the unit rows that pin `false`.
3. **R1-3 (`:60`, TIERS `:41`):** each tier is sampled at exactly 991/767/478, but Elementor's Swiper keys are 0/767/1024
   and Swiper applies key 767 from 767 px up, so the 767 sample reads the tablet values: Elementor's default Image
   Carousel (3/2/1) shows 2 per view where the site shows 1 across 479–766. General rule: a Bricks tier takes the value
   the site shows across that tier (sample inside the tier, e.g. just below its top, or map the site's breakpoints to
   Bricks' tiers by range), and where the site's value changes inside a Bricks tier say which wins and note it. Fix the
   unit row that uses key 768 to answer as Elementor does.
   Test each first: a unit case and a browser proof on a generic fixture (a Pro-family carousel with arrows and loop; a
   carousel with pause on hover off; Elementor's default 3/2/1 image carousel read at 700, 600 and 480) — RED on
   `1b193b45`, then GREEN; mutate each guard under the cap.
4. Put R1-4…R1-6 in HANDOFF's site-slider "Deferred" list (they are in `evidence/site-slider/follow-ups.md`).
5. Gates before stopping: both typechecks, `npm run check`, AC1–AC8's tests, AC9 named on the saved capture (paths in
   `evidence/site-slider/builder/cont/` logs; 8G scope), the five replays byte-identical to main, `test:web` and
   `test:browser` file by file under the 4 GB cap compared by name with the builder's `evidence/site-slider/builder/cont/gates/`
   (run long gates on a `git archive` scratch copy with `dist/` built; rerun only differing files on main).
6. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/fixer-1/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ssl-f/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start. One `bash <file>` per Bash call (scripts written with Write); start long drivers
  with `setsid --fork` and wait on their final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry 8G). Waits under 115 s.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), per finding: verified?, the rule, fix, tests, RED/GREEN
paths, mutation; gates; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
