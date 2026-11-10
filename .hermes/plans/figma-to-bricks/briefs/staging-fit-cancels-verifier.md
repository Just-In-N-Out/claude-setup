# Role: verifier (read-only): staging-fit-cancels

You are a fresh verifier who never saw the build or the reviews (**Opus 5.5, high**). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees
(read them with `git show`). **Never load bdryswi.com, B-Dry staging** or any live site (saved captures and local
fixture servers only); no logins; never write to any WordPress site; never run `npm run site:upload` against anything.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Code-route paste traps") and `references/rendering-validation.md`.

## Inputs
- Approved plan (read-only; amended, the Amendments list is at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md` (AC1–AC3; no live AC). The
  job: the website importer's code-route paste no longer cancels a declaration at a width range with `revert` (which
  rolled back the whole author origin); a value a range drops is written as bounded runs. Find every cited test name
  with ac-check's own grep first (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); a name the
  runner prints with a prefix goes through a by-name checker citing a phrase that sits whole on one plan line. Judge
  each AC against the amended words; where a "Supporting, not this criterion's test" line names a file, run it too,
  never cite it.
- Head `4a352ffd1dd34210512abfc9abe3e23df3858c2f` (branch `staging-fit-cancels-stack10`; the last commit is the ledger,
  code head `f05f9759`); base (old code) `f40ce6ce729af831186dab85c673653d7187744e` (local `main`, Build 2026-11-10.5).
  In your own worktree: `git checkout --detach 4a352ffd1dd34210512abfc9abe3e23df3858c2f`, confirm `git rev-parse HEAD`
  and a clean status (after a restart: restore tracked files of exactly 8388608 bytes; `git cat-file -t HEAD`). Old
  code: a tree from `git archive` of `f40ce6ce` with head's test files, fixtures and test-only modules copied in
  (label a hybrid or a stand-in in the log's second line). An AC log cited in `ac.json` starts with the bare
  `HEAD=<sha>` (say "archive" on its second line) and ends with one line `EXIT=`, skipped 0.
- **Two things the plan's Amendments tell you, so they don't trip you:**
  - `test/web/site-range-cancels.test.ts` holds a `todo` test (the known limit inside 768–991, its own job
    `control-weight`), and `ac-verification.md` rejects a log containing a TODO: run AC1's cited test **alone by name
    pattern** (`--test-name-pattern`), so its log holds no TODO line. AC1 claims nothing inside 768–991.
  - AC1's RED on the old code is on the looks a `revert` rolls back below 768 (corner radius 0 against 6 px, an
    underline): the old renderer's "link blue" no longer shows, because main's renderer prints class controls as
    `.cls.brxe-<element>`. The golden of AC3 (`test/fixtures/site-no-revert-main.json`) carries `base` `7eeca437`;
    main has since moved to `f40ce6ce` (site-media-upload), which changes no paste without a media map: prove that
    yourself (the generator on a `git archive` of `f40ce6ce` gives the committed entries; only a `base` line could
    differ) and say so.
- A merged job's env-gated story pin (`F2B_STORY_PINS=1`, site-media-upload's AC4 "byte for byte as main makes it")
  moves for `saved.elementor-stretch` by this job's design: it is that job's receipt, not regenerated, and not a
  failure of this job (the default suite is green). Don't count it against an AC; do name it in your report.
- Don't read the builder's, fixers' or reviewers' reports as proof. Receipts the plan's Amendments list names as
  encoding an old expectation are not proof either.

## Work
1. Gates on head: both typechecks, `npm run check`, `npm run corpus` (same output as base; v1's Mac files are missing
   here), the **full** `npm run test:browser` and `npm run test:web`, file by file under the 4 GB cap (a separate
   TMPDIR for each script started at the same time), compared with base by test name. **This job changes what every
   site-route paste prints in classes where a range drops a declaration, so run base's side yourself for every file
   whose result differs by name.** Pre-existing failures are fine only if they also fail on base by name (five
   browser files fail on main on this desktop: composition-clipping, fonts, hero-pair, peer-sides, pill-holder; the
   named-only B-Dry files `site-elementor-page-bdry`, `site-page-bdry` and `site-motion-bdry` fail on main by the
   footer's 69 px, another job's: they must fail the same way on head, with the same numbers); rerun a differing file
   alone before calling a regression (known flakes: the code-page fixture's 5.09 px load flake, `capture-windows` AC7,
   `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest; "Chrome didn't start within 20s" under load: kill
   that node child and its Chromes, rerun alone). The five Figma replays byte-identical to base.
2. Every AC's named test on head (must pass) and on old code (AC1 and AC2 must fail there on their own assertions;
   AC3 is preservation plus a rule: `base_exempt` with a reason and your own byte receipt where it rightly passes on
   base, or RED where its test asserts the new rule); a picture or terminal capture per AC (AC1: site | paste of the
   fixture's hero at 600 and at 390 with both Bricks samples, 2.3.9 and 2.4.2).
3. **Your own proof of the rule beyond the fixture** (saved captures and fixture captures only): convert B-Dry's
   stand-in (`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`, 8G
   scope) and three fixture captures with base's converter and with head's, plain and `--elementor`: on head no
   `revert` outside the site-reset class and the two named exceptions (an Elementor accordion's open look; a slider's
   `<button>` arrows and dots); classes change only where base wrote a `revert`; and at every whole width from 320 to
   1600 the last matching declaration per (selector, property) in the changed classes gives base's value wherever
   base's `revert` did not apply and the site's own value where it did (normalise class names before comparing: a
   changed class renames). `site:check --all` on the stand-in, both routes, row for row as base (the footer's 69 px
   is main's).
4. Where this job meets the newest merge: a media map naming a background a width range drops or changes: every
   `url()` of it in head's bounded blocks is the library's, and without a map the paste is byte for byte head's own
   no-map paste of the previous main (`ce5b38ac`, the reviewed head before the hop).
5. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/verifier/ac.json` and logs in that
   folder; self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy
   (`--base f40ce6ce729af831186dab85c673653d7187744e`), as the reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-v/t1`,
  `t2`, …); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too; close every
  Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's own
  shell). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own
  call, then untar in the next). Point `corpus.json` at the repo's copies as testing-pitfalls says (in a scratch copy,
  never the worktree). Run multi-step commands from a script file written with Write, paths spelled out.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (the parallel
  unit suite and B-Dry runs may need 8G; export variables first, no `--setenv=PATH`); `compare-corpus.test.ts` needs
  `--test-timeout=3600000`. The PC lost power twice this week and agents were stopped by a usage limit twice: keep
  scripts and logs under `~/.cache/sfc-v/`, never the `/tmp` scratchpad, write each log's `EXIT=` line (wait on
  `^EXIT=`) so finished runs count after a restart, start long drivers with `setsid --fork`, and when resumed read
  your finished logs first and never start a second driver on a suite one is still working through.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s, and wait in the
  foreground with a bounded loop script (ending the turn while drivers run can end you early).

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; the rule's proof on the saved captures (classes changed,
reverts on base and on head, the width sweep); the story pin named; gates; `verdict`; `ac_status`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; `enforce` is `none` or a one-line check
proposal; never edit skills or memory), ending with `MAIN SESSION: check and save these skill_lessons now.`
