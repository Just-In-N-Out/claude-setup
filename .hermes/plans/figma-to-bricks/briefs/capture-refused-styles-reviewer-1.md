# Role: reviewer, round 1 (Mini: the one full review, plus the verifier's AC work; report only): capture-refused-styles

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). **Never load bdryswi.com** in any way (no Chrome, no curl, no fetch: Justin's rule "never
without me"), B-Dry staging or any live site: the capture runs only against local fixture servers. No logins; never
write to any WordPress site; `site:import` / `site:upload` only against the tests' own 127.0.0.1 stand-in with a
made-up password. **Nothing may hide that the importer's Chrome is automated** (no `AutomationControlled` flag, no
`navigator.webdriver` patch, no new user agent, no stealth script, nothing that clicks or types into a site's check):
a fix that works by disguise is a P0. Justin may be running his own Chrome: never stop a Chrome you didn't start;
touch nothing under `~/Downloads`.

**Mini pipeline** (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`, step 3): you do
two jobs in one pass and write two files: the **review** (`review-1/review.json`, `review-loop.md`) and the
**verifier's AC work** (`verifier/ac.json`, `ac-verification.md`): every AC's named test on head and on old code, with
logs and a terminal capture each.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for a bug a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. This job exists because Justin cannot scan his client's site at all, so a bug
that would still stop or silently spoil his next real scan is P1.

## What the job is
Justin's two real scans of bdryswi.com (2026-11-10, Build 2026-11-10.7) ended: "Failed: … The page loads for widths
769–834 px [then 1025–1366 with one window] never got the site's stylesheet https://bdryswi.com/_jb_static/ (answered
403) in 3 tries … Press Capture to try again." The site is hosted on WordPress.com; its protection appears to re-check
the browser partway through a scan. The planner proved on a local fixture that, since capture-speed, later page loads
and the retries were answered from the capture's kept page, never by the site, so a check that comes back partway can
never be passed again. The fix: a range that lost a stylesheet is read again asking the site for its page (the person
may pass "I am human" again); a site that keeps refusing stops with a line naming who refused what and what to do, and
a `<name>.f2b-refused.json` log (no cookies, no secrets); the command's lines say what to type, the panel keeps its
words; the "refused on the way" line counts only the page's own kinds; a page load whose own stylesheets were all
refused from the first load is the site turning the capture away (new rule Q6, AC10), never saved styleless.

## Inputs
- Approved plan (read-only; amended A1–A6, the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md` (AC1–AC10; AC9 is
  `(live)`, Justin's own scan: mark it `not_run`, owed). Find every cited test name with ac-check's own grep first
  (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); read each cited test before you run it (a test
  that only asserts what a sibling collects is run with its whole file). AC3 is a timing criterion (paired,
  interleaved rounds, pooled median plus a per-site guard, request counts as the hard clause): run it at the lowest
  load you can get, never retried until green; report its table and `uptime`.
- Branch `capture-refused-styles-build`, head `cc96b92ab929f3662b4067361225d57f3b2f318f` (code head `e098a53d`), base
  main `3f4a0718d974ec66167ce788ed3fe2672df9feb6` (Build 2026-11-11.1). In your own worktree: `git checkout --detach
  cc96b92ab929f3662b4067361225d57f3b2f318f`, confirm HEAD and a clean status. Review `git diff 3f4a0718...HEAD` (the
  whole story). Old code for the AC work: a tree from `git archive` of `3f4a0718` with head's test files, fixtures and
  test-only modules copied in; preservation ACs that rightly pass on base are `base_exempt` with a reason and your
  own byte receipt. An AC log cited in `ac.json` starts with the bare `HEAD=<sha>` (say "archive" on its second line)
  and ends with one line `EXIT=`, skipped 0.
- The builder's record (read, don't trust): `evidence/capture-refused-styles/builder/` (`red/`, `task*/`, `amend/`,
  `rebase/`, `mutants*/`, `terminal/`, `timing/`, `probes/`), the ledger, HANDOFF's section; the planner's evidence
  `evidence/capture-refused-styles/planner/` (`notes.md`, the fixtures, `amend/`); `follow-ups.md` (recorded limits:
  refused stylesheets on another host or `www.`; no-store sheets refused mid-read; a check needing a press on a
  retry; refused scripts or pictures). The one real read of the site (the main session, with Justin's leave):
  `planner/one-read*` (HTTP 400 on the bare address, `server: nginx`, `host-header: WordPress.com`).

## Check hardest
1. **Does it fix Justin's failure, honestly?** On local fixtures of your own (beside the planner's edge fixture): a
   check whose pass expires after a time and only a page load can earn; after N requests; per window; per kind of
   visitor; a check that asks the person to press again on the retry (the visible window opens, the same words as
   the first check, the wait; a person who doesn't pass it gets the plain line, no capture); 4 windows and 1. Each:
   the capture ends clean and equals a capture of the same fixture with the refusal off, or stops with the refusal
   line. **And no disguise:** the retry is an ordinary page load in the same Chrome; Chrome's switches,
   `navigator.webdriver` and the user agent are as before (AC7's test, plus your own read of the launch and the
   page's view); nothing answers or clicks the check.
2. **Nothing styleless is ever saved as clean** (the real risk for Justin's next scan): every stylesheet of the page's
   own origin refused from the first load (AC10); all but one refused; refused only on the retry; a `www.` or
   another-host stylesheet refused (recorded limit — rate it: is `www.` vs bare a realistic case for a WordPress
   site, and does the capture then save styleless with exit 0?); a 503; a 429 with `Retry-After`. Each: exit code,
   the line, whether `capture:check`, `site`, `site:upload` and `site:import` refuse the file.
3. **The refusal line and the log are true and private:** the line names the whole address with its query, the
   status, the server's name and the refusal page's title, and what to type (the command's words for `npm run
   capture`, "run the same command again" for `site:import`, the panel's words in the panel); the log holds every
   refused request with its type and the first 300 bytes, and no cookie, no `Authorization`, no secret-looking query
   value (check the unit tests can fail: Chrome never hands the recorder `Set-Cookie`). The "refused on the way" line
   never fires on a passed check (the favicon, the check page itself).
4. **A site that refuses nothing is as before** (AC3): byte for byte (timings, capturedAt, build aside), each address
   asked no more often, no slower by the plan's paired rule.
5. **The join with site-one-command** (merged on main): `tools/lib/capture-pages.ts`' resolution (main's
   `capturePage` plus this job's `requests`, `again`, `fail()`, `refusedLine`), the one-line port in
   `tools/site-import.ts`; `site-import-*` web files and the new `capture-refused-import` test; site-one-command's
   guards still hold (the password nowhere; nothing but reads before a fresh `yes`).
6. **Gates on head against base by name:** both typechecks, `npm run check` (8G scope), `npm run corpus` (same as base;
   v1's Mac files are missing here), the plan's Task 9 web suites and every `site-import-*` web file, `human-check`
   whole, each web file alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables
   first; no `--setenv=PATH`), `test/unit/plugin-convert.test.ts`, `dist/` byte-identical to base's build. Two mutants
   of your own under the cap: the retry answered from the kept page again; `turnedAway` counting a `www.` sheet as
   another host's (or whichever you find untested).

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and `ac-verification.md` (the
verifier's procedure and the `ac.json` format at the top of `scripts/ac-check.sh`), and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Access": "A check that comes back partway through a scan"; "Writing readers").
Write:
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/review-1/review.json` (round 1, a full
  review; `head` the full SHA of your HEAD), then self-check:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
  3f4a0718d974ec66167ce788ed3fe2672df9feb6 /home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles`
  (exit 2 means your file is wrong: fix it);
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/verifier/ac.json` with its logs and
  captures in that folder, self-checked with `ac-check.sh` on a copy (`--base
  3f4a0718d974ec66167ce788ed3fe2672df9feb6`, no `--reviews`), as the reference says.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/crs1/t1`, a
separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop
it by the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a
`git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command, a heredoc, a shell function or a word containing "git" may be refused: write
such steps to a script file with Write and run `bash <file>`; `git -C <absolute path>`). A script hosting a fixture
server in its own process starts the CLI with async `spawn`, never `spawnSync`. Use `tail -n 3`, never `tail -3`.
Never edit a tree a test is running against. Scripts under `~/.cache/capture-refused-styles-review1/`. SIGTERM / 143 /
137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s; start
long drivers with `setsid --fork` and wait on `^EXIT=` in bounded loops. The PC restarted three times this week: write
each log's `EXIT=` line, keep notes on disk; when resumed, read them first.

## Report (as text; only the two json files, logs and captures are written)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the fixture table (shape → clean capture
/ stops, the line, exit, which tools refuse the file); the disguise check; the privacy check of the log; AC3's table and
`uptime`; per AC: test, head result, old-code result, evidence path; gates; `verdict`; `ac_status`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
