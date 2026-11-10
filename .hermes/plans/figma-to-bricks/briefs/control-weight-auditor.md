# BLIND AC AUDITOR (read only): control-weight (on the website importer's code route, an element its parent reads as an inline word at some widths carries those widths in its own class)

You are a fresh auditor (**Opus 5.5, xhigh**). Independently prove the approved acceptance criteria. You have never
seen a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/` except `plan-approved.md` and your own `auditor/`
folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `stack-*`, `planner/`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes; nor other agents'
scratch folders under `~/.cache/` (`cw-*`, `control-weight-*` other than your own). Source and tests are read-only;
commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (saved captures and local fixture servers only); no logins;
never write to any WordPress site; never run `npm run site:upload` or `site:import` against anything.

## The only inputs
- Approved plan (amended A1–A14; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md` (AC1–AC6; no live AC). Judge
  each AC by its amended words. Use each exact test name the plan cites: find them all first with ac-check's own grep
  (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); where the runner prints a name differently,
  cite a phrase that sits whole on one plan line and run the test by its full printed name through a by-name checker,
  as `ac-verification.md` says. Run the supporting tests the plan names beside the cited ones, and never cite them.
  **Read each cited test before you run it:** a test that only asserts what a sibling test in its file collects must
  be run with its whole file (alone by name it passes with nothing checked, on old code too); a log containing a TODO
  line is rejected.
- **The plan names its base as `main` `56a9379f`; main has moved once since** (another job merged as Build
  2026-11-10.7; it says it leaves the code route's bytes as before). Head `90437f41fe20826125d376821cbabf41d861db54`
  (branch `control-weight-stack14`), base `7ec16d6060a76b441e42581b78ad3a502461fd66` (local `main`), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/auditor/` (empty). For the byte criterion
  compare head with a `git archive` of `7ec16d60`, **and prove yourself that `7ec16d60`'s pastes of those captures
  equal `56a9379f`'s**, so the plan's sentence holds as written; capture every fixture site under
  `test/fixtures/web/sites/` fresh with head's capture code (a saved capture folder leaves out the sites the newer
  main added).
- Saved inputs the plan's named-only clauses use (read the tests for their variables; search the plan and the repo
  docs for the paths): saved captures under `~/.hermes/plans/figma-to-bricks/evidence/` of other jobs may be read as
  **input files only** (B-Dry's stand-in
  `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`;
  `~/.hermes/plans/figma-to-bricks/evidence/bdryswi-com-home-2026-11-04-code.f2b-capture.json`): open nothing else in
  those folders. Say which files you used, by path and sha256, and that they are saved files, not the live site.

## Your copy
In your own worktree: `git checkout --detach 90437f41fe20826125d376821cbabf41d861db54`, confirm `git rev-parse HEAD` and
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
rightly passes on base is `base_exempt` with a specific reason, backed by your own byte-identity probe and a mutant
its cited test kills; a test with a known load flake — anything running `site:check --all` on the code-page fixture
can read 5.09 px once in a while — is rerun alone before it is judged). Also:
- **The rule, proven by you beyond the fixtures — the thing to prove hardest.** Pages of your own shape on local
  fixture servers, captured with head's code and pasted (Rich and Basic Text), each paste drawn in Chrome as Bricks
  2.3.9 and 2.4.2 print it under a hostile theme, measured against the site at each range's edges ±1 px and one width
  inside, on head and on base: (1) a painted link its wrapper turns into an inline word at a range that is not the
  fixture's (one in the middle of the widths, one at the narrowest phones); (2) the link holding an icon and a label
  whose size changes in the range; (3) one element two parents move at two ranges that don't meet; (4) the cases the
  paste can't prove (a child before the link hidden in the range; the wrapper hidden there; an inline element the
  paste doesn't hold): the parent's rule stays and the paste is base's. Head equals the site wherever the rule
  applies; nothing is worse than base anywhere. Show each probe can fail (a mutant of a head copy that drops the
  move: the probe reports base's differences).
- Your own mutation proof for the rule's guards under the 4 GB cap (each on a scratch copy, restored by hash; killed
  when the AC's named test fails on its own assertion): the one-for-one proof skipped; the wrapper's rule kept after
  a move; a moved range's bound dropped; a second move overwriting the first; an unproved nested level moved; a Figma
  stage importing the importer's converter.
- AC1: your own pictures (site | paste of the fixture's hero inside the range and at 390, both Bricks samples).
- Preservation: every fixture site without the shape and the two saved real captures, code and `--elementor` routes,
  both picture modes, both text modes: byte for byte the base tree's; `test/fixtures/site-no-revert-main.json`
  unchanged against base and no `revert` outside the exceptions the no-revert test names; the five Figma replays of
  the repo's real files and `dist/code.js` byte-identical.
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p 7ec16d60..HEAD -- <each AC's test files>` and read every assertion against the amended plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base 7ec16d6060a76b441e42581b78ad3a502461fd66`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/cw-audit/t1`, `t2`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too, and Justin may be
  running his own: close every Chrome **you** start (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A browser or web run counts only with `skipped 0` for the AC's tests. A worktree's `node_modules` may
  lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
  piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar in
  the next; never chain a git command after a `cd` into a scratch folder: use `git -C <absolute path>`). Use `tail -n
  3`, never `tail -3`. Run multi-step commands from a script file written with Write, paths spelled out; keep scripts
  and logs under `~/.cache/control-weight-auditor/` and copy them to `auditor/scripts` (a restart empties `/tmp`).
  Never edit a script a background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (the parallel unit suite and B-Dry runs may need 8G; export variables first, no
  `--setenv=PATH`; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s (wait on
  `^EXIT=`), and wait for background drivers in the foreground with a bounded loop script. The PC restarted three
  times this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line; when resumed, read
  your finished logs first and never start a second driver on a run still going.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, rule (your pages, ranges, differences on head and on base, the probes' controls), found_else[],
skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every AC accepted. Empty skill_lessons is normal; never
edit skills or memory (`enforce` is `none` or a one-line check proposal). End with `MAIN SESSION: check and save these
skill_lessons now.`
