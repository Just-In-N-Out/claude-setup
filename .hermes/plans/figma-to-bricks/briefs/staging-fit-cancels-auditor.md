# BLIND AC AUDITOR (read only): staging-fit-cancels (the website importer's code-route paste no longer cancels a declaration at a width range with `revert`; a value a range drops is written as bounded runs)

You are a fresh auditor (**Opus 5.5, high**). Independently prove the approved acceptance criteria. You have never seen
a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/` except `plan-approved.md` and your own
`auditor/` folder (never `builder/`, `review-*`, `verifier*`, `stack-*`, `follow-ups.md`, `plan-approved-v*`); nor
HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes. Source and tests are read-only; commit nothing;
start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (saved captures and local fixture servers only); no logins;
never write to any WordPress site; never run `npm run site:upload` against anything.

## The only inputs
- Approved plan (amended; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md` (AC1–AC3; no live AC).
  Judge each AC by its amended words. Use each exact test name the plan cites: find them all first with ac-check's own
  grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); where the runner prints a name
  differently, cite a phrase that sits whole on one plan line and run the test by its full printed name through a
  by-name checker, as `ac-verification.md` says. Run the supporting tests the plan names beside the cited ones, and
  never cite them. **The plan tells you:** AC1's test file also holds a `todo` test for a known limit inside 768–991
  that AC1 does not claim (a log containing a TODO line is rejected: run AC1's cited test alone by name pattern); the
  golden AC3 names was made from an earlier main (`7eeca437`), and the base has since moved to `f40ce6ce` by a job
  that changes no paste without a media map: prove that yourself.
- Head `4a352ffd1dd34210512abfc9abe3e23df3858c2f` (branch `staging-fit-cancels-stack10`), base
  `f40ce6ce729af831186dab85c673653d7187744e` (`main`, Build 2026-11-10.5), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/auditor/` (empty).
- Saved inputs the plan's named-only clauses use (read the tests for their variables; search the plan and the repo
  docs for the paths): saved captures under `~/.hermes/plans/figma-to-bricks/evidence/` of other jobs may be read as
  **input files only** (for example B-Dry's stand-in
  `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`): open nothing
  else in those folders. Say which files you used, by path and sha256, and that they are saved files, not the live
  site.

## Your copy
In your own worktree: `git checkout --detach 4a352ffd1dd34210512abfc9abe3e23df3858c2f`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly
8388608 bytes and restore them with `git checkout --`; `git cat-file -t HEAD`). Your `ac.json` names this head and
base. Never write in any other worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` ("Code-route paste traps") and
`references/rendering-validation.md`; `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every AC make your own head and base runs
(an AC log starts with the bare `HEAD=<sha>` and ends with one line `EXIT=`, skipped 0; the named assertion must run,
pass on head and fail on base for new behaviour; base: a tree from `git archive` of the base with head's test files
and the test-only modules and fixtures they import copied in, labelled in the log's second line; a clause that
rightly passes on base is `base_exempt` with a specific reason, backed by your own byte-identity probe; a test with a
known load flake — anything running `site:check --all` on the code-page fixture can read 5.09 px once in a while — is
rerun alone before it is judged). Also:
- **The rule, proven by you beyond the fixture — the thing to prove hardest.** Convert B-Dry's stand-in (8G scope) and
  at least five fixture captures you make yourself with head's capture code (local fixture servers) with base's
  converter and with head's, plain and `--elementor`, both text modes: (1) on head no `revert` appears outside the
  site-reset class and the exceptions the plan names; (2) a class changes only where base wrote a cancel-kind
  `revert` in it, and every such class changes; (3) at every whole width from 320 to 1600, per (selector, property)
  in the changed classes, head's last matching declaration gives base's value wherever base's `revert` did not apply,
  and nothing where it did (normalise class names before comparing: a changed class renames, because names
  fingerprint their own rules); (4) in Chrome with both Bricks samples (2.3.9 and 2.4.2), a page of your own shape (a
  painted link that a wrapper turns into an inline word at one range; a box whose flex values a narrower range
  drops; a background a range drops) draws the site's look at each range's edges ±1 px outside the range the plan
  excludes. Show each probe can fail (a one-pixel-gap mutant; a "value carried on below its range" mutant).
- Your own mutation proof for the rule's guards under the 4 GB cap (each on a scratch copy, restored by hash; killed
  when the AC's named test fails on its own assertion): bounded runs turned back into `revert`; a run's lower bound
  dropped; its upper bound dropped; the exceptions' matcher widened to any selector; the "classes without a dropped
  declaration print as on main" comparison made to ignore a class.
- AC1: your own pictures (site | paste of the fixture's hero at 600 and 390, both Bricks samples).
- Preservation: `site:check --all` on the stand-in row for row between base and head on both routes (a footer
  difference of about 69 px on both trees is the base's own); the five Figma replays of the repo's real files and
  `dist/code.js` byte-identical; with a media map (the base's newest merge: `npm run site … --media`), a background a
  range drops or changes carries the library's address in head's bounded blocks.
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p f40ce6ce..HEAD -- <each AC's test files>` and read every assertion against the amended plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base f40ce6ce729af831186dab85c673653d7187744e`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/sfc-a/t1`, `t2`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too: close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill
  -f <pattern>`: it kills the tool's own shell). A browser or web run counts only with `skipped 0` for the AC's tests.
  A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules`
  (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules`
  in; a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar
  in the next; never chain a git command after a `cd` into a scratch folder: use `git -C <absolute path>`). Run
  multi-step commands from a script file written with Write, paths spelled out; keep scripts and logs under
  `~/.cache/sfc-a/` and copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a script a background
  run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (the parallel unit suite and B-Dry runs may need 8G; export variables first, no
  `--setenv=PATH`; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s (wait on
  `^EXIT=`), and wait for background drivers in the foreground with a bounded loop script. The PC lost power twice
  this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line; when resumed, read your
  finished logs first and never start a second driver on a run still going.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, rule (captures, classes changed, reverts on base and on head, the width sweep, the probes'
controls), found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every AC accepted. Empty
skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with
`MAIN SESSION: check and save these skill_lessons now.`
