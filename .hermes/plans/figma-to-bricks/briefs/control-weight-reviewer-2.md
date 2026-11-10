# Role: reviewer (round 2: fix pass 1 and the move onto main; report only): control-weight

You are a fresh reviewer who never saw the build, the fix or the move (**Opus 5.5, high**). Review only: change no
source or test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or
other worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (saved captures
and local fixtures only); never write to any WordPress site; no logins; never run `npm run site:upload` against
anything.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits (a capture of a real
site converted with `npm run site`, plain or `--elementor`, and pasted into Bricks 2.3.9 / 2.4; Figma designs
converting as before), each with a concrete real-use scenario. Edge cases are P3. A P0–P2 with no concrete real-use
scenario counts as P3. (You review; a verifier proves the ACs at this job's turn.)

## What happened before you
- The job: on the code route, an element the capture reads as its parent's inline element at some widths (a link
  that is a word in its wrapper's line) and as its own element elsewhere was pasted with two classes, and the
  parent's `.wrapper > :nth-child(1)` rule (0,2,0) lost to the element's own class control (Bricks prints
  `.cls.brxe-<el>`, 0,2,0, after it): `inline-block`, the line 28 px taller. The fix (`src/core/site/inline-own.ts`,
  four lines in `convert.ts`): the parent's inline readings of a pasted child move onto the child's own class for
  those widths, only where the paste proves which child is which.
- Review 1 (at `a442672e`, on another job's branch) found R1-1 (P2): a moved child that is a box took the parent's
  nested readings as a shorter rule that lost to the grandchildren's own class controls (a link's label at its
  desktop size at 768–991, right before the job).
- **Fix pass 1** (`a442672e..c1874614`): the same step runs again on any moved child that holds site elements of its
  own, at every depth, each level under the same proof; an unproved level keeps its keys in the top parent's rule as
  the base wrote them (0,3,0). Two test gaps closed. A new fixture site `inline-nested`.
- **The move:** the job's own 10 commits were rebased from staging-fit-cancels' old head onto `main`
  `56a9379faf207c2bfa76211dff1365db7d74be37` (Build 2026-11-10.6: staging-fit-cancels and site-media-upload merged).
  Two conflicts, both in `docs/HANDOFF.md`; `convert.ts` applied cleanly beside site-media-upload's media code.
  **Nobody has reviewed fix pass 1 or the move.**

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md`
  (AC1–AC6, proposed; none live). **Known, not findings:** a planner is amending the plan's wording beside you (AC4's
  base `ce5b38ac` → `main`; AC1's range words: the limit is not specific to 768–991; the nested rule "at every
  depth"; the `alone` variant).
- Branch `control-weight-stack12`, head `271e7815fe06935387bacd208ee8577ef0f0068e` (the last commit is docs; the
  rebased head before it `58dcd24a`), base `main` `56a9379faf207c2bfa76211dff1365db7d74be37`. In your own worktree:
  `git checkout --detach 271e7815fe06935387bacd208ee8577ef0f0068e`, confirm HEAD and a clean status. Review `git diff
  56a9379f...HEAD` (the whole story on its new base).
- Review 1: `evidence/control-weight/review-1/review.json`, its probe sites `~/.cache/cw-r1/` (`cw-nested`, `cw-leak`,
  `cw-text`, `cw-words`). Fix pass 1's receipts (read, don't trust): `evidence/control-weight/fixer-1/` (`mut/`,
  `probes-head.log`). The move's record: `evidence/control-weight/stack-12/` (`range-diff.txt`, `conflicts.md`,
  `resolutions/`, `pins.md`, `meet/`, `logs/`). Recorded limits (don't re-report unless you rate one higher, with a
  scenario): `evidence/control-weight/follow-ups.md` and HANDOFF's "Known limits" in the job's section (words beside
  the element: the words' Rich Text counts as the first child and nothing moves, as on main; a tablet-only child
  never shown elsewhere can pass the count check; the lifted-child condition can't be tested until
  site-native-structure's `lift` is on main; the reverse shape; Bricks' Display control holding `inline`).

## Check hardest (hand-made captures and fixture sites of your own shape; local servers only; Chrome with both Bricks
samples)
1. **R1-1 is closed, at every depth, and the unproved case is exactly as main.** Your own pages: a link holding an
   icon and a label; a label inside a span inside the link (three levels); a link holding two labels where one is
   hidden at the inline widths (unproved: nothing below moves; the parent's 0,3,0 rule stays byte for byte as main
   writes it); a link holding words and a span (the words' Rich Text beside the span); a link holding an `<img>` and
   an `<svg>`; a moved child that is itself a wrapper whose own children it reads inline at another range (two
   overlapping moves). For each, at 767, 768, 769, 880, 991, 992 and at 1200, 600, 390: every element's computed
   display, font size, padding, margins and colour against the site's, and the page within 2 px. A value wrong on
   head that main draws right is a regression (P0–P2 with the shape's real-use scenario).
2. **The limit is not specific to 768–991** (staging-fit-cancels' blind auditor: its pages showed it at 600–899 and at
   479 and below): pages whose wrapper reads the link inline at 600–899, at 479 and below (phones: Bricks' tier
   cascade tablet → sideways phones → upright phones, and the job's bounded runs between them), at two separate
   ranges, and at every width but one: does the rule apply the same way at each, and does a tier that goes back to
   the own value write it explicitly?
3. **Which child is which, one level down too:** the proof's conditions at each level (one for one; none lifted; the
   counted steps exactly 0…n-1 at every range that reads any; a class of its own; not shown where it is read; the top
   parent shown there): try to move one element's look onto another with a shape a real page makes (two links, the
   first hidden on tablets; a comment or `<br>` between; a `<span>` wrapper the capture flattens; a child reordered
   with `order`). The two dead checks fixer 1 removed (commit `3ebb082d`: "can never change the outcome"): is that
   true?
4. **The move:** your own `git range-diff ce5b38ac..c1874614 56a9379f..58dcd24a`; `convert.ts` against main: exactly
   this job's lines, site-media-upload's media code untouched; the HANDOFF resolutions (this job's section first;
   main's lines kept; the merged bullet in staging-fit-cancels' Known limits says one true thing: read it against
   what the code does and what you measured in checks 1 and 2); `test/web/site-range-cancels.test.ts` is main's file
   with the `todo` turned into a real test. Where the jobs meet: a media map on a moved element (its background and
   mask at the library's address in its own class and bounded runs; a moved Image), no `revert` outside the reset
   class and the named exceptions.
5. **Nothing else moved:** your own byte comparison, main's converter beside head's, on B-Dry's stand-in
   (`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`, 8G scope)
   and ten fixture captures of your choice (the five hidden-menu fixtures among them): identical except captures
   holding the shape; `test/fixtures/site-no-revert-main.json` untouched and its test green; no Figma stage imports
   `src/core/site`; `tsconfig.sandbox.json` clean; `npm run check` on head.
6. **The tests can fail** (read `fixer-1/mut/`; two mutants of your own under the 4 GB cap: one on the recursion's
   proof at the second level, one on "an unproved level keeps its keys with the top parent"). Mutant N5's survival
   (differs only inside a recorded known limit): is that so?

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines) with
`references/testing-pitfalls.md`, `references/live-site-reading.md` ("Code-route paste traps") and
`references/rendering-validation.md`, the repo `CLAUDE.md` in the main folder ("Build general logic"; "Architecture
rules"; the standing rule "A website paste never cancels a declaration at a width range with `revert`"; "Output
style: editable structure first") and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole story for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   56a9379faf207c2bfa76211dff1365db7d74be37 /home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight` (exit 2
   means your file is wrong: fix it). Say whether R1-1 is closed.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-r2/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own
  call, then untar; never chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`). Scripts
  written with Write; probes and logs under `~/.cache/control-weight-review2/`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G; export variables first, no `--setenv=PATH`). Waits under 115 s. The PC lost power twice this week and agents were
  stopped by a usage limit twice: keep notes and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), R1-1 closed or not, `verdict`, `ac_status` (per AC:
what the review saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
`enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
