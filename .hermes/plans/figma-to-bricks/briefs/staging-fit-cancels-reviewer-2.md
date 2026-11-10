# Role: reviewer (round 2: the move onto main and what it needed; report only): staging-fit-cancels

You are a fresh reviewer who never saw the build or the move (**Opus 5.5, high**). Review only: change no source or
test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (saved captures and
local fixtures only); never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a capture of a real site converted with `npm run site`, plain or `--elementor`, and
pasted into Bricks 2.3.9 / 2.4; Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3. A P0–P2 with no concrete real-use scenario counts as P3.

## What happened before you
The job (the code route's paste no longer cancels a declaration at a width range with `revert`, which rolled back the
whole author origin; a value a range drops is written as bounded runs) was review-clean at `b1329c43` on the old main
`3cfc54ac` (review 1: MOVE ON). Four importer jobs then merged (`main` is
`7eeca437ea100c821bcfb82cdbbe516a023ff097`, Build 2026-11-10.4: site-faq, site-reviews, site-slider,
staging-fit-renderer). A fixer rebased the job onto it and did what the move needed. **Nobody has reviewed that.**

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md`
  (AC1–AC3, proposed; Q1 A as built — a hybrid — and Q2 A, not yet confirmed by Justin). **Known, not a finding:** AC1's
  words about main ("rgb(0,0,238) on main" at 600) no longer describe the new main, whose renderer prints class
  controls at `.cls.brxe-<el>`; a planner amends the wording after this review. Do say exactly what AC1's test proves
  now, on head and on main.
- Branch `staging-fit-cancels-stack7`, head `ce5b38acbb959c12218e319560608c660c753b70`, base `main`
  `7eeca437ea100c821bcfb82cdbbe516a023ff097`; the rebased head before the fixer's own commits is
  `50802b7e2a4ae35209741db973a261b0d7a50c4f`. In your own worktree: `git checkout --detach
  ce5b38acbb959c12218e319560608c660c753b70`, confirm HEAD and a clean status. Review `git diff 7eeca437...HEAD`; the
  fixer's own work is `git diff 50802b7e..HEAD`; the reviewed pre-rebase story is `git diff 3cfc54ac...b1329c43`.
- The move's record (read, don't trust): `evidence/staging-fit-cancels/stack-7/` (`range-diff.txt`, `conflicts.md`,
  `resolutions/`, `golden.md`, `logs/`: `fourtrees.log`, `redgreen.log`, `probe-button.log`, `probe-ac1.log`,
  `ac1-main-red.log`, `repro-850.log`, `named-head2.log`, `mutants.log`). Deferred items:
  `evidence/staging-fit-cancels/follow-ups.md` (review 1's P3s; "Stack 7").
- The fixer's words, each for you to check:
  - two context-only conflicts (`controls.ts`, HANDOFF); `classes.ts` merged without one, and main's `ClassCss.inside`
    (site-reviews: the boxes inside a live slot) now prints through this job's bounded runs **with no code change**;
  - AC3's golden regenerated from main: nothing moved in its 676 entries between old main, each merged build and new
    main;
  - every `revert` on the rebased head judged: site-reviews' `max-width: revert` inside a live slot was the cancel
    kind (now a bounded block; its unit test `site-live-widget` R1-4 updated to assert the bounded block: **a merged
    job's test changed**); site-faq's accordion open look and site-slider's arrows and dots that are `<button>`s
    (`partStates`) are named exceptions (`test/fixtures/site-drops.ts` `excepted`, AC2's test, HANDOFF);
  - site-slider's `site-slider-unchanged` sums for elementor-stretch regenerated (three boxes main wrote a revert in);
  - AC1's test now draws with both Bricks samples (2.3.9 and 2.4.2);
  - **a known limit, head and main alike, recorded as its own job (`control-weight`, a planner is on it): inside
    768–991 the fixture's link is drawn `inline-block` where the site's is `inline` (28 px taller at 768, 880, 991),
    because the link's own class control `.cls.brxe-div{display:inline-block}` (0,2,0) beats the wrapper's rule
    `.wrapper > :nth-child(1)` (0,2,0, a bounded run) by order.** It is asserted by a `todo` test. Not a finding here
    unless this job makes it worse or different from main: prove whether it does.

## Check hardest
1. **The rebase against both sides:** `git range-diff 3cfc54ac..b1329c43 7eeca437..50802b7e` (commits whose own +/-
   lines changed beyond context?); the two hand resolutions; `classes.ts` on the rebased head: main's `inside`, the
   slider's class CSS (`slider-css.ts`), the live widget's and the FAQ's CSS all print as on main except where a
   range drops a declaration, and there as bounded runs that draw the same at every width (convert the merged jobs'
   fixtures on main and on head, diff by class; draw two in Chrome at each range's edges ±1 px).
2. **site-reviews' live-slot boxes under bounded runs** (the "no code change" claim and the changed test): on the
   live-widget fixtures and on a capture of your own shape, is the box inside a live slot the same size at every
   width as on main (768 exactly, 767, 767.5 at a zoomed browser — review 1's R1-1 gap: does it now also reach a live
   widget's box, and what shows there)? Is the changed assertion equal in strength to the one it replaced?
3. **The two exceptions are right, and are the only ones:** your own grep of `revert` over the source and over the
   pastes of every fixture and saved capture you can convert (plain and `--elementor`, both text modes); for each
   remaining `revert`: does it roll back anything the site's own cascade wouldn't (the open accordion item; a Splide
   `<button>` arrow or dot on a page whose theme styles buttons — is "back to the browser's own button" what the old
   site shows, or does the site's own button rule now get rolled back too: the very bug this job fixes, in another
   place)? `excepted` in the test fixture: can it hide a real cancel-kind `revert` (how narrow is its match)?
4. **The regenerated goldens are honest:** re-derive AC3's golden claim on main yourself (`git archive` of main with
   this job's generator; the file equals the committed one; nothing but the `base` line moved against old main), and
   the four-tree claim for `site-slider-unchanged`'s elementor-stretch sums (old base, old head, new main, new head).
5. **AC1 under main's renderer:** run AC1's test on head (both Bricks samples) and on main (`git archive`, the test
   laid over): what fails on main now, exactly; is the test still a real RED for this job's rule, or would a mutant
   that turns the bounded runs back into `revert` survive it on head (try it, under the 4 GB cap)? The `todo` test:
   does it assert the limit truthfully?
6. **Nothing else moved:** Figma designs byte for byte (`test/unit/plugin-convert.test.ts`; the five replays in the
   fixer's receipts); `npm run check` on head; B-Dry's stand-in
   (`evidence/site-native-structure/inputs/standin-capture-0581852c.json`, 8G scope): no `revert` outside the
   site-reset class and the named exceptions, `site:check --all` row for row as main (the footer's 69 px is main's:
   job `footer-icon-list`).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines) with
`references/testing-pitfalls.md`, `references/live-site-reading.md` ("Code-route paste traps") and
`references/rendering-validation.md`, the repo `CLAUDE.md` in the main folder ("Architecture rules": CSS stays typed,
never regex or string-match CSS; the Status lines of the four merged jobs) and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/review-2/review.json`, then
   self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 7eeca437ea100c821bcfb82cdbbe516a023ff097 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-r2/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in). Scripts written with Write; probes and logs under `~/.cache/sfc-r2/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G; export variables first, no `--setenv=PATH`). Waits under 115 s. The PC lost power twice this week and agents can
  be stopped by a usage limit: keep notes and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw;
AC1: what its test proves now on head and on main), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
