# Finisher brief: after-merge steps for site-slider (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `f708dfb6`
(Build 2026-11-10.2) to `8a13b71c46b26864e2b29ab08fae5f941c7b040e` (`site-slider-stack3`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 9/10; AC10 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com or any live site; no logins; never write to any
WordPress site. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `8a13b71c46b26864e2b29ab08fae5f941c7b040e`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.2`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.3`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found → testing-pitfalls).
   Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit suite is killed for memory, check earlyoom
   and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`.)
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-09-site-slider-ledger.md`).
   - Paste check id **3dr** (the next free after 3dq on main; confirm with `command grep -rhoE --exclude-dir=evidence
     '\b3d[a-z]\b' docs/ | sort -u`): replace every `<site-slider id at merge>` in `docs/HANDOFF.md` (the section
     heading, the paste-check line, the end-of-run list entry) and the ledger's own placeholders for this job, and every
     `<at merge>` / "build set at the merge" placeholder of this job with the new BUILD (leave the ledger's quoted
     history of other jobs' placeholders as history). Its live check is AC10 (Justin re-pastes B-Dry's whole
     `--elementor` home on staging /homev2/ from a capture made with Build 2026-11-09.4 or later, regenerates code
     signatures and purges the cache; the hero is one slider that plays every 7.5 s, its arrows and dots work, at 990
     one slide shows, not three stacked).
   - **The approved plan was amended (wording only; amendments 1–11) after the branch's plan commit:** copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md` over
     `docs/plans/2026-11-09-site-slider.md` (the repo's plan becomes the approved copy, byte for byte; `cmp` them).
   - HANDOFF's site-slider section: where it says `site:check` reads the Q4 A tier difference at the capture's width
     992, add 767 (the paste shows 1 slide where an Elementor 3/2/1 carousel shows 2; 225 px taller per carousel with
     800 px pictures; 992 reads 26 px shorter with 360 px pictures, 100 px with 800 px ones); where it speaks of "all
     48 widths" for B-Dry or of Justin's 2026-11-09 capture for AC9, say that AC9 now runs on the clean stand-in the
     plan names (38 widths; Justin's re-capture replaces it once it exists) because `main` refuses the 2026-11-09
     capture. Known limits / Deferred, add if missing, in the section's own style:
     - "Not yet confirmed by Justin: Q4 A's reading (a Bricks tier takes what the site shows across most of its widths,
       so a default 3/2/1 carousel differs from the site at 992–1023 and at exactly 767, and `site:check --all
       --elementor` fails at the capture's 992 and 767 on a carousel whose pictures fill their slides); a slide's own
       height carried as an `!important` line on the slider's class (edited there, not in the slide's Height control)."
     - "A carousel showing several slides at once gets one dot per page from Splide, the old site one per slide (named
       in the paste's note)."
     - "Inside a looping slider `site:check`'s `css` locator finds Splide's copy of a slide first: a live widget with
       served boxes in a carousel showing several slides could read as a false failure (review 4, R4-1;
       staging-fit-renderer's shared locator fixes it when it merges)."
     - "No test pins the defaults of amendment 2 (a missing speed takes 300 ms, a missing autoplay delay 3000 ms) or the
       arrow's ink against `currentColor` (the blind auditor's surviving mutants S19 and L2: test gaps; the code is
       right)."
4. Commit `Build <BUILD>: a captured Elementor carousel or hero slider pastes as Bricks' Slider (Nestable) that moves
   like the site's (site-slider)` (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff
   --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only, through the repo's
   own credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`) and one line at the top
   of the feature list in the house style:
   "**<BUILD> site-slider (website importer):** with `--elementor`, a captured Elementor carousel (Image Carousel, Nested
   Carousel, Pro's Slides and carousels; either key family) pastes as one Slider (Nestable) holding its own slides: the
   site's timing, loop or fade, pause under the mouse, arrows and dots where the site draws them, per view and gap by
   Bricks' tiers, a slide's own height kept; Bricks' own slider CSS survives the site reset; `site:check` holds a slider
   on its first slide; pastes without such a carousel, the plain route and Figma designs are byte for byte as before.
   Q4 A (tiers) and the `!important` slide height not yet confirmed. Paste check **3dr** (AC10, live: B-Dry's hero on
   staging /homev2/)."
   No standing rule changed. If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-slider-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `8a13b71c`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch. Change
  no source or test file (only `src/shared/build.ts` and docs).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
