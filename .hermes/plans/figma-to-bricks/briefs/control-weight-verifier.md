# Role: verifier (read-only): control-weight

You are a fresh verifier who never saw the build or the reviews (**Opus 5.5, high**). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees
(read them with `git show`). **Never load bdryswi.com, B-Dry staging** or any live site (local fixture servers and
saved files only); no logins; never write to any WordPress site; never run `npm run site:upload` against anything.
Nothing may hide that the importer's Chrome is automated.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Code-route paste traps") and `references/rendering-validation.md`;
`reference/bricks/README.md`.

## Inputs
- Approved plan (read-only; amended A1–A14, the Amendments list is at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md` (AC1–AC6; none is live). The
  job: on the website importer's code route, an element its parent reads as an inline word at some widths (and its own
  element at others) carries those widths in its own class, at every depth the reading nests and across two parents'
  moves, so Bricks' class controls (printed as `.cls.brxe-<el>`) can't out-weigh the parent's `> :nth-child` rule;
  where the paste can't prove which child is which, the parent's rule stays as before. Find every cited test name with
  ac-check's own grep first (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); a name the runner
  prints with a prefix goes through a by-name checker citing a phrase that sits whole on one plan line. Judge each AC
  against the amended words; where an "Also (supporting, never the cited test)" line names files, run them too, never
  cite them. AC1's test file may hold a `todo` test for a known limit: a log containing a TODO line is rejected, so run
  AC1's cited test alone by name pattern.
- **The plan names its base as `main` `56a9379f`; main has moved once since** (panel-embed-code merged: Build
  2026-11-10.7, which says it leaves the code route's bytes as before). Head
  `90437f41fe20826125d376821cbabf41d861db54` (branch `control-weight-stack14`; the last commit is the ledger, code head
  `1ea9f5cf`); base (old code) `7ec16d6060a76b441e42581b78ad3a502461fd66` (local `main`). For the byte criterion (AC4)
  compare head with a `git archive` of `7ec16d60`, **and prove yourself that `7ec16d60`'s pastes of those captures
  equal `56a9379f`'s**, so the plan's sentence holds as written; capture every fixture site under
  `test/fixtures/web/sites/` fresh with head's capture code (panel-embed-code added five: embeds-chained,
  embeds-tracked, float-holds, tracker-stack, media-page; a capture folder saved by an earlier agent leaves them
  out).
  In your own worktree: `git checkout --detach 90437f41fe20826125d376821cbabf41d861db54`, confirm `git rev-parse HEAD`
  and a clean status (after a restart: restore tracked files of exactly 8388608 bytes; `git cat-file -t HEAD`). Old
  code: a tree from `git archive` of `7ec16d60` with head's test files, fixtures and test-only modules copied in (a
  new module that doesn't import on base is weak RED: add a labelled supporting run — base plus head's new-only
  source files — so the test fails on its own assertion; where that hybrid tree passes because the guarantee lives
  wholly in new files, prove the test can fail with a one-line mutant of a head copy instead; preservation ACs that
  rightly pass on base are `base_exempt` with a reason and your own byte receipt). An AC log cited in `ac.json` starts
  with the bare `HEAD=<sha>` (say "archive" on its second line) and ends with one line `EXIT=`, skipped 0.
- Don't read the builder's, fixers' or reviewers' reports as proof. Receipts the plan's "Receipts after the
  amendment" section names as encoding an old expectation are not proof either. A merged job's env-gated story pin
  (`F2B_STORY_PINS=1`, site-media-upload's "byte for byte as main makes it") fails on main itself since
  staging-fit-cancels merged: not this job's; don't count it.

## Work
1. Gates on head: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, `npm run corpus` (same output as
   base; v1's Mac files are missing here), the **full** `npm run test:browser` and `npm run test:web`, file by file
   under the 4 GB cap (a separate TMPDIR for each script started at the same time), compared with base by test name.
   Pre-existing failures are fine only if they also fail on base by name (five browser files fail on main on this
   desktop: composition-clipping, fonts, hero-pair, peer-sides, pill-holder; the named-only B-Dry files fail on main
   by the footer's 69 px, another job's); rerun a differing file alone before calling a regression (known flakes: the
   code-page fixture's 5.09 px load flake, `capture-windows` AC7, `capture-entrances` R8-1, `site-elementor-button`
   pixels-at-rest, `capture-opens-guards`' worker comparison; "Chrome didn't start within 20s" under load: kill that
   node child and its Chromes, rerun alone). The five Figma replays byte-identical to base;
   `test/unit/plugin-convert.test.ts`; `test/unit/sandbox-convert.test.ts`; `dist/code.js` byte-identical to base's
   build (the job touches only `src/core/site`).
2. Every AC's named test on head (must pass) and on old code; a picture or terminal capture per AC (AC1: site | paste
   of the fixture's hero at 850 and at 390, both Bricks samples).
3. **The rule, proven by you beyond the fixtures (local fixture servers of your own; draw each paste as Bricks 2.3.9
   and 2.4.2 print it, under a hostile theme, Rich and Basic Text):**
   - other ranges than the fixture's: a link that is a word of its wrapper's line at **600–899**, and one at **479
     and below**; the link holding an icon and a label (the label's size changing in the range); the same link a block
     on phones and a word on tablets (two parents' moves). At each range's edges ±1 px and one width inside: every
     listed element's display, font size, padding, colour and background equal the site's; nothing worse than base
     anywhere (measure base too: where base is already wrong, say so; where base is right, head must be).
   - the "can't prove" side: a child before the link hidden in the range; the wrapper hidden in the range; an inline
     element the paste doesn't hold: the parent's rule stays, the look is base's.
   - a page that holds the shape **and** a third-party widget slot (one of `test/fixtures/web/sites/embeds-*`'s
     shapes): the Code element and its note are byte for byte base's; the inline-read element carries its widths.
   The plan's recorded limits are not failures (R2-2, R1-3, a tablet-only child passing the count check, the
   lifted-child condition): say what you saw for them.
4. **Byte for byte as base** (AC4, AC5): `npm run site` plain and `--elementor`, both picture modes, both text modes,
   on every fixture site's fresh capture that holds no element of the shape and on the saved real captures the plan
   names (B-Dry's stand-in
   `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`, 8G scope):
   every part's bytes equal; `test/fixtures/site-no-revert-main.json` unchanged against base; no `revert` on head
   outside the exceptions `test/unit/site-no-revert.test.ts` names.
5. Your own mutants under the 4 GB cap (scratch copies, restored by hash; killed when the AC's cited test fails on its
   own assertion): the proof skipped (every inline reading moved); the wrapper's rule kept after a move; a moved
   range's lower bound dropped; the second parent's move overwriting the first.
6. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/verifier/ac.json` and logs in that
   folder; self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy
   (`--base 7ec16d6060a76b441e42581b78ad3a502461fd66`), as the reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/cw-ver/t1`, `t2`, …); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too; close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`:
  it kills the tool's own shell). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has
  neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink
  the main folder's `node_modules` in; a piped, chained or redirected git command is refused: `git archive -o <file>
  <sha>` in its own call, then untar in the next; never chain a git command after a `cd` into a scratch folder: `git
  -C <absolute path>`). Point `corpus.json` at the repo's copies as testing-pitfalls says (in a scratch copy, never
  the worktree). Run multi-step commands from a script file written with Write, paths spelled out; scripts and logs
  under `~/.cache/control-weight-verifier/`.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (the parallel
  unit suite and B-Dry runs may need 8G; export variables first, no `--setenv=PATH`); `compare-corpus.test.ts` needs
  `--test-timeout=3600000`. The PC restarted three times this week and agents were stopped by a usage limit twice:
  never the `/tmp` scratchpad, write each log's `EXIT=` line (wait on `^EXIT=`) so finished runs count after a
  restart, start long drivers with `setsid --fork`, and when resumed read your finished logs first and never start a
  second driver on a suite one is still working through.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s, and wait in the
  foreground with a bounded loop script (ending the turn while drivers run can end you early).

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; the rule's table (shape and range → site, base, head at
each width); the byte receipt (captures, pastes, `56a9379f` = `7ec16d60`); your mutants; gates; `verdict`;
`ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; `enforce` is `none` or a
one-line check proposal; never edit skills or memory), ending with `MAIN SESSION: check and save these skill_lessons
now.`
