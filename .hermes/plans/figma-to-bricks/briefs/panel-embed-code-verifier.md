# Role: verifier (read-only): panel-embed-code

You are a fresh verifier who never saw the build or the reviews (**Opus 5.5, high**). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees
(read them with `git show`). **Never load bdryswi.com, B-Dry staging, a widget vendor's host** or any live site (local
fixture servers and saved files only); no logins; never write to any WordPress site; never run `npm run site:upload`
against anything. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the embeds line: it ends with the rule for a floating widget's code and the
reviews' lessons) and `references/rendering-validation.md`.

## Inputs
- Approved plan (read-only; amended A1–A8, the Amendments list is at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md` (AC1–AC11; AC11 live,
  Justin's: mark it `not_run`, owed). The job: on both importer routes (the Figma panel's website route and `npm run
  site`) a pasted Code element runs only a widget's own code — the slot's own served markup, a served frame's own
  markup, a frame a script made as it showed, and for a floating widget the served tags of the file that drew it,
  **only when that file drew the box by itself**; what a capture can't prove is an empty box of its size (a floating
  widget: listed), with a note that says why. Find every cited test name with ac-check's own grep first (`command grep
  -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); a name the runner prints with a prefix goes through a
  by-name checker citing a phrase that sits whole on one plan line. Judge each AC against the amended words; where an
  "Also (supporting, never the cited test)" line names files, run them too, never cite them.
- Head `f961b365ee7305b2a48e459051f8cf4e282bd382` (branch `panel-embed-code-stack11`; the last commit is the ledger,
  code head `c0f504f4`); base (old code) `56a9379faf207c2bfa76211dff1365db7d74be37` (local `main`, Build 2026-11-10.6).
  In your own worktree: `git checkout --detach f961b365ee7305b2a48e459051f8cf4e282bd382`, confirm `git rev-parse HEAD`
  and a clean status (after a restart: restore tracked files of exactly 8388608 bytes; `git cat-file -t HEAD`). Old
  code: a tree from `git archive` of `56a9379f` with head's test files, fixtures and test-only modules copied in (a
  new module that doesn't import on base is weak RED: add a labelled supporting run — base plus head's new-only
  source files — so the test fails on its own assertion; **where that hybrid tree passes because the guarantee lives
  wholly in new files, prove the test can fail with a one-line mutant of a head copy instead**; preservation ACs that
  rightly pass on base are `base_exempt` with a reason and your own byte receipt). An AC log cited in `ac.json` starts
  with the bare `HEAD=<sha>` (say "archive" on its second line) and ends with one line `EXIT=`, skipped 0 (the
  "unchanged sums" run only with `F2B_UNCHANGED_SUMS=1`).
- Don't read the builder's, fixers' or reviewers' reports as proof. Receipts the plan's Amendments list names as
  encoding an old expectation are not proof either. A merged job's env-gated story pin (`F2B_STORY_PINS=1`,
  site-media-upload's "byte for byte as main makes it") fails on main itself since staging-fit-cancels merged: not
  this job's; don't count it.

## Work
1. Gates on head: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, `npm run corpus` (same output as
   base; v1's Mac files are missing here), the **full** `npm run test:browser` and `npm run test:web`, file by file
   under the 4 GB cap (a separate TMPDIR for each script started at the same time), compared with base by test name.
   **This job changes what the capture records for floating widgets and embeds and what the panel route pastes, so
   run base's side yourself for every file whose result differs by name.** Pre-existing failures are fine only if
   they also fail on base by name (five browser files fail on main on this desktop: composition-clipping, fonts,
   hero-pair, peer-sides, pill-holder; the named-only B-Dry files fail on main by the footer's 69 px, another job's);
   rerun a differing file alone before calling a regression (known flakes: the code-page fixture's 5.09 px load flake,
   `capture-windows` AC7, `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest; "Chrome didn't start
   within 20s" under load: kill that node child and its Chromes, rerun alone). The five Figma replays byte-identical
   to base; `test/unit/plugin-convert.test.ts`; `test/unit/sandbox-convert.test.ts`.
2. Every AC's named test on head (must pass) and on old code; a picture or terminal capture per AC.
3. **The guard, proven by you on pages of your own (local servers that log every request; draw each pasted footer and
   page on a fresh page, click it, wait 8 s, and count what your servers received):**
   - a slot widget, a served frame, a script-made frame and a live widget, each with the widget host's tracking tag
     in `<head>`, beside the slot and at the end of `<body>`, and an inline script that configures the widget and
     calls the tracker: on both routes, both picture modes, header / page / footer: no pasted Code element holds a
     tag that isn't the widget's own (base pasted them on the panel route: show it);
   - floating widgets: a served file that draws its launcher by itself (at load, in a timer, in a promise, served
     twice): its own served tags pasted; listed and never pasted: a starter script that loads the bundle which draws,
     a tag manager that injects the chat, a tag manager whose rule draws the box from an injected inline script /
     `eval` / `new Function`, a vendor file the page's inline script calls, a box the site's own script draws through
     a CDN library (rebuilt as the site's own box when it holds only the site's link or picture; the library never
     pasted). For each: what the capture records (`own`, `ownWhy`), what both routes paste to run, the note's words,
     and what reached your servers from the paste (trackers, tag managers, loaders and libraries: 0 requests). The
     plan's recorded limits are not failures (a served file that itself inserts a button as plain markup, or hands
     its own drawing function to a timer, is pasted with the honest note: Justin's pending decision); say what you
     saw for them.
   - a capture made before this job, and Justin's saved captures you can find in the repo's fixtures and under
     `~/.hermes/plans/figma-to-bricks/evidence/` as **input files only**: what each widget becomes on the panel route
     (nothing collected is pasted; the "capture the page again with this build" note where the plan says so); a
     capture carrying a reason this build doesn't know converts and gets the unproven note.
4. **The code route byte for byte as base** (the plan's preservation AC): `npm run site` plain and `--elementor` on
   the widget fixtures, on five captures without widgets and on B-Dry's stand-in
   (`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`, 8G scope):
   every part's bytes equal; with a media map naming the widget's own files, a widget's Code element is still byte
   for byte the no-map one.
5. **The capture is touched as lightly as on base:** time `npm run capture` on a heavy local fixture site on base and
   on head, twice each at the same load (a slow-down a person would notice is a finding); the capture's file differs
   from base's only by the fields the plan names; `capture:check` passes; fetch, XMLHttpRequest and sendBeacon are
   not wrapped on the captured page; the page's own `Error.stackTraceLimit` is put back.
6. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/verifier/ac.json` and logs in that
   folder; self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy
   (`--base 56a9379faf207c2bfa76211dff1365db7d74be37`), as the reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-v/t1`,
  `t2`, …); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too; close every
  Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's own
  shell). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own
  call, then untar in the next; never chain a git command after a `cd` into a scratch folder: `git -C <absolute
  path>`). Point `corpus.json` at the repo's copies as testing-pitfalls says (in a scratch copy, never the worktree).
  Run multi-step commands from a script file written with Write, paths spelled out; scripts and logs under
  `~/.cache/panel-embed-code-verifier/`.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (the parallel
  unit suite and B-Dry runs may need 8G; export variables first, no `--setenv=PATH`); `compare-corpus.test.ts` needs
  `--test-timeout=3600000`. The PC lost power twice this week and agents were stopped by a usage limit twice: never
  the `/tmp` scratchpad, write each log's `EXIT=` line (wait on `^EXIT=`) so finished runs count after a restart, start
  long drivers with `setsid --fork`, and when resumed read your finished logs first and never start a second driver
  on a suite one is still working through.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s, and wait in the
  foreground with a bounded loop script (ending the turn while drivers run can end you early).

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; the guard's table (shape → what the capture records, what
each route pastes, what reached your servers from the paste); the code route's byte receipt; the capture's time and
bytes; gates; `verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
`enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with `MAIN SESSION: check and
save these skill_lessons now.`
