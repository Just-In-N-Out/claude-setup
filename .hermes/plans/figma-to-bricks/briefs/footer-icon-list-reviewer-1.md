# Role: reviewer (Mini round 1, the whole story; report only): footer-icon-list

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (saved captures and local fixtures
only); never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"; one real-bug review per job):**
report as P0–P2 only bugs a real site or normal use hits (a capture of a real site converted with `npm run site`,
plain or `--elementor`, and pasted into Bricks 2.3.9 / 2.4; Figma designs converting as before), each with a concrete
real-use scenario. Edge cases are P3. A P0–P2 with no concrete real-use scenario counts as P3. (Justin's rule for this
project: the full recheck of each job runs one at a time, in merge order. So you review only; you write no
`verifier/ac.json`: a verifier proves the ACs at this job's turn.)

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md`
  (AC1–AC6, proposed; AC6 live; ⭐ answers Q1 A, Q2 A, Q3 A taken under the standing auto-go). The job: a site writes
  one box side by two names (a reset's `margin-top: 0; padding-bottom: 0`, then a widget rule's `margin-block-start`,
  `padding-block-end`); the capture keeps both names; the paste turned the physical one into a Bricks class control
  (printed `.cls.brxe-<el>`, 0,2,0) that beats the logical one in custom CSS (0,1,0): B-Dry's footer contact list was
  69 px short. The fix (`src/core/site/sides.ts` `oneSide`, called from `statesOf` in `src/core/site/blocks.ts`): for a
  side written by both names with values that draw differently, only the name the capture lists later stays.
- Branch `footer-icon-list-build`, head `bdd3dde7dc8c06b8daa0ec442a87ae1961e469fa` (code head `3f989608`; later commits
  are docs), base `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097`. In your own worktree: `git checkout --detach
  bdd3dde7dc8c06b8daa0ec442a87ae1961e469fa`, confirm HEAD and a clean status. Review `git diff 7eeca437...HEAD`.
- The builder's receipts (read, don't trust): `evidence/footer-icon-list/builder/` (`ac*-*.log`, `ranges-*.log`,
  `vs-plan.log`, `mutation.log`, `web-names.log`, `browser-names.log`, `scripts/`), shots under
  `~/.hermes/plans/figma-to-bricks/shots/footer-icon-list/`. The planner's evidence and probes:
  `evidence/footer-icon-list/planner/` (`notes.md`, `probe1.log`, `probe3.log`).
- **The builder's one deviation, for you to judge:** where a wider range writes a side only by its physical name and
  a narrower range adds the logical name with another value, the plan's rule dropped the physical name at the
  narrower range, and `blocksOfStates` sent it back as `margin-top: revert` (custom CSS, sorted after
  `margin-block-start`), undoing the site's value. The builder made `oneSide(d, before)` keep the losing name **at the
  winner's value** where the wider range's state held it (`statesOf` passes `out[i - 1]`); tests
  `test/unit/site-one-side-ranges.test.ts`. AC3's sentence ("only the later-listed name … stays") no longer describes
  that case: a planner amends the wording after you; say exactly what AC3's test proves now.

## Check hardest (hand-made captures and fixture sites of your own shape; local servers only; draw in Chrome with both
Bricks samples)
1. **Which name wins is the site's winner.** "The name the capture lists later" stands for "the declaration that wins
   the site's cascade": is that true for what the capture stores (`src/web/read/code.ts`, `code-expand.ts`: per
   element, per range, declarations by name in first-written order, shorthands expanded in Chrome)? Probe sites where
   the two names come from rules of different weight and order: a reset by element selector first, a class rule with
   the logical name later (the B-Dry shape); the reverse order in the stylesheet with the class rule still winning by
   weight (the physical reset written **after** in source but weaker); `!important` on the loser; the same name
   written twice (the recorded limit: say what the paste shows); an inline `style` attribute; a media query that
   writes only one of the names at some widths (the builder's ranges case, and its reverse: the logical name in the
   wider range, the physical one added narrower); a range where the pair is equal and one where it differs. For each:
   the paste's computed side at every width against the site's. A wrong winner on a shape a real site writes is
   P0–P2.
2. **The ranges deviation.** "The losing name stays at the winner's value": at every width does the paste draw the
   site's value (Bricks' tier cascade: tablet → sideways phones → upright phones; a tier that goes back writes the
   value explicitly); can the kept name now print as a control that beats something else it shouldn't (the same
   0,2,0 against 0,1,0 the job fixes, the other way round); does it change any paste that doesn't hold a differing
   pair (`vs-plan.log` says no real capture differs from the plan's rule: re-derive on two saved captures)?
3. **What counts as "draws differently" and "one side".** Values compared as text or as computed (`0` against `0px`,
   `calc(23px/2)` against `11.5px`, `auto`, percentages, `var()`); the pairs handled: margins and paddings top /
   bottom, insets (`top` / `bottom` beside `inset-block-*`), top and bottom borders beside `border-block-*` (width,
   style, colour), sizes (`width` / `inline-size`, `height` / `block-size`, min / max): for sizes and insets, is
   "the later name wins" still right, and do the controls and custom CSS that result draw the site's box? A
   `writing-mode` the element declares (left alone) and one it only inherits (the recorded limit: what does the paste
   show for a vertical heading?); `direction: rtl` (inline sides are left alone: nothing changes?).
4. **Nothing else moved (AC4).** Your own byte comparison, base's converter beside head's, on the saved captures you
   can convert (B-Dry's stand-in `evidence/site-native-structure/inputs/standin-capture-0581852c.json` under an 8G
   scope, the 2026-11-04 B-Dry code capture, three fixture captures): parts change only where a node holds a
   differing pair; the merged jobs' recorded pins (site-slider's `site-slider-unchanged`, site-motion-base and the
   others in `test/fixtures/`) pass; Figma designs can't change (no Figma stage imports `src/core/site`: check the
   import graph); `src/core` uses only the language's built-ins (`tsconfig.sandbox.json`).
5. **B-Dry's footer for the right reason (AC1):** run the named test on head and on base with the stand-in capture
   (8G scope): 69 px on base, within 2 px on head, and the rows' own computed margins and paddings equal the
   capture's (not a compensation elsewhere). `site:check --part footer --elementor` with both Bricks samples.
6. **The tests can fail** (read `mutation.log`; two mutants of your own under the 4 GB cap, one on the ranges keep, one
   on the "draws the same" skip). The generic fixture `logical-sides` is generic (nothing of B-Dry's names or values).
7. **What the later moves will meet** (P3 notes unless wrong on this head): staging-fit-cancels also edits `blocks.ts`
   (bounded runs replace `revert`: with that job under or over this one, does the ranges deviation still hold — the
   kept name was added to avoid a `revert` that job removes; say what the stack step must re-prove); control-weight's
   `inline-own.ts` keeps its own state reader (a moved element's declarations must still pass through `oneSide`).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Code-route paste traps") and `references/rendering-validation.md`, the repo
`CLAUDE.md` ("Build general logic"; "Architecture rules": CSS stays typed, never regex or string-match CSS; a value
that has a Bricks control goes in that control's key) and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole story for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   7eeca437ea100c821bcfb82cdbbe516a023ff097 /home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list` (exit
   2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/fil-r1/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own
  call, then untar). Scripts written with Write; probes and logs under `~/.cache/fil-r1/`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G; export variables first, no `--setenv=PATH`). Known flakes: the code-page fixture's 5.09 px load flake,
  `capture-entrances` R8-1. Waits under 115 s. The PC lost power twice this week and agents were stopped by a usage
  limit twice: keep notes and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), your reading of the builder's deviation, `verdict`,
`ac_status` (per AC: what the review saw; AC3: what its test proves now), then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
