# BLIND AC AUDITOR (read only): capture-refused-styles (a site whose check comes back partway through a scan; a site that keeps refusing)

You are a fresh auditor (**Opus 5.5, xhigh**). Independently prove the approved acceptance criteria. You have never
seen a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/` except `plan-approved.md` and your own
`auditor/` folder (never `builder/`, `fixer-*`, `review-*`, `stack-*`, `verifier*`, `planner/`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes; nor other agents'
scratch folders under `~/.cache/` (`crs*`, `capture-refused-styles-*` other than your own). Source and tests are
read-only; commit nothing; start no agents. (Justin chose to run you alongside the verifier's last steps to save time:
you work on your own, as always.)
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`. The plan's
recorded limits are not failures.
**Never load bdryswi.com** in any way, B-Dry staging or any live site: the capture runs only against local fixture
servers. No logins; never write to any WordPress site; `site:import` only against the tests' own 127.0.0.1 stand-in
with a made-up password. **Nothing may hide that the importer's Chrome is automated** (no cookie copied into Node,
nothing that presses or types into a check). Other agents and Justin run Chrome on this machine: never stop a Chrome
you didn't start; touch nothing under `~/Downloads`.

## The only inputs
- Approved plan (amended A1–A6; its Amendments list at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md` (AC1–AC10; AC9 live:
  mark it `not_run`). Judge each AC by its amended words. Use each exact test name the plan cites: find them all first
  with ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); where the runner
  prints a name differently, cite a phrase that sits whole on one plan line and run the test by its full printed name
  through a by-name checker. Read each cited test before you run it (a test that only asserts what a sibling collects
  is run with its whole file; AC3 is named only: run it with `F2B_BASE_TREE` = a `git archive` of the base, at the
  lowest load you can get, never retried until green). Run the supporting tests the plan names, never cite them.
- Head `ebd4dfc8ed78e511b3671985eb2bb3d7f165013e` (branch `capture-refused-styles-stack2`), base
  `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9` (local `main`, Build 2026-11-11.2), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/auditor/` (empty).

## Your copy
In your own worktree: `git checkout --detach ebd4dfc8ed78e511b3671985eb2bb3d7f165013e`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a restart: tracked files of exactly 8388608 bytes →
`git checkout --`; `git cat-file -t HEAD`). Your `ac.json` names this head and base.

## Work
Load `engineering-best-practices`; read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`; the project
skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (fixture
triggers for the scan's end key on `Sec-Fetch-Dest`; Node can't resolve `*.localhost`; a picture test needs a raster
file; a press that tries a write counts for nothing) and `references/live-site-reading.md` ("Access": "A check that
comes back partway through a scan"); `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
and the report format at the top of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every AC
make your own head and base runs (an AC log starts with the bare `HEAD=<sha>` and ends with one line `EXIT=`, skipped
0; base: a tree from `git archive` of the base with head's test files, fixtures and test-only modules copied in,
labelled in the log's second line; where a base run is only an import failure of a new module, prove the test can
fail with a one-line mutant of a head copy under the 4 GB cap, restored by hash — a load-hook mutant checks its
replaced text occurs exactly once; a clause that rightly passes on base is `base_exempt` with a specific reason and
your own byte receipt). Also:
- **The fix, proven by you hardest**, on a fixture site of your own (local server logging every request with its
  headers): a check whose pass runs out during the ranges, during the pictures (raster, plus a menu box showing the
  site's own picture), during the font files; a site that keeps refusing; a site refusing every own stylesheet from
  the first load; a site that refuses nothing. Through `npm run capture` **and** `npm run site:import` (stand-in, made-up
  password, answered "no"): clean captures equal to the clean one with every picture, `capture:check` ok; the refusal
  line names who refused what and what to type, with the log and no clean capture left; nothing refused → no renewal,
  requests equal to base; no cookie in any Node request; `navigator.webdriver` and the user agent as before; the press
  guard still holds (0 writes, page loads or sockets from presses).
- A terminal capture per AC.
- Run `git log -p e16d3d1e..HEAD -- <each AC's test files>` and read every assertion against the amended plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`, no `--reviews`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters and a separate one per
script started at the same time (`~/.cache/crsa/t1`, `t2`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
Close every Chrome **you** start (by the PIDs of its own profile path; never `pkill -f <pattern>`). A `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" may be refused: write such steps to a script file with Write and run `bash
<file>`; `git -C <absolute path>`). A script hosting a fixture server in its own process starts the CLI with async
`spawn`. Use `tail -n 3`. Keep scripts and logs under `~/.cache/capture-refused-styles-auditor/` and copy them to
`auditor/scripts`. Never edit a tree a test is running against. Heavy and mutation runs under `systemd-run --user
--scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (the parallel unit suite 8G; export variables first, no
`--setenv=PATH`). SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
short-iso | grep -E 'sending SIG[A-Z]* to process'`). Waits under 115 s (wait on `^EXIT=`). The PC restarted four
times this week: write each log's `EXIT=` line; when resumed, read your finished logs first. Put any summary in your
report, not a file. Send one final report when `ac.json` exists; no interim hand-backs.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, fixture (shape × route → exit, pictures, capture:check, equal, cookies, guard), found_else[],
skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every agent-run AC accepted. Empty skill_lessons is
normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with `MAIN SESSION: check
and save these skill_lessons now.`
