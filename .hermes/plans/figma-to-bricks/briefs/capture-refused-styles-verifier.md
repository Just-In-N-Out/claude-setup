# Role: verifier (read-only): capture-refused-styles

You are a fresh verifier who never saw the build, the reviews or the fixes (**Opus 5.5, high**). Prove each acceptance
criterion yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other
worktrees (read them with `git show`). **Never load bdryswi.com** in any way, B-Dry staging or any live site: the
capture runs only against local fixture servers. No logins; never write to any WordPress site; `site:import` /
`site:upload` only against the tests' own 127.0.0.1 stand-in with a made-up password. **Nothing may hide that the
importer's Chrome is automated** (no cookie copied into Node, nothing that presses or types into a check). Justin may be
running his own Chrome: never stop a Chrome you didn't start; touch nothing under `~/Downloads`. Another job's verifier
(footer-icon-list) runs on this machine at the same time: keep your Chrome jobs one at a time and your TMPDIRs your own.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format at the top of `scripts/ac-check.sh`) and follow it; read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`
(fixture triggers for the scan's end key on `Sec-Fetch-Dest`; Node can't resolve `*.localhost`; a capture test proving a
picture was downloaded needs a raster file) and `references/live-site-reading.md` ("Access": "A check that comes back
partway through a scan"; "Holding a Chrome to read-only").

## Inputs
- Approved plan (read-only; amended A1–A6, the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md` (AC1–AC10; AC9 live:
  mark it `not_run`, owed). The job: since capture-speed, later page loads and retries were answered from the
  capture's kept page, so a site whose check comes back partway through a scan (Justin's bdryswi.com on WordPress.com)
  could never be passed again and every stylesheet got 403. Now a range that lost a stylesheet is read again asking the
  site for its page; the pictures and font files at the scan's end renew the pass the same way (at most 3 renewal page
  loads a capture, each tab closed once its page loads; refused files then fetched through the browser's tab); a site
  that keeps refusing stops with a line naming who refused what and a `.f2b-refused.json` log; a page whose own
  stylesheets are all refused from the first load is the site turning the capture away; the command's stop lines say
  what to type. Find every cited test name with ac-check's own grep first (`command grep -E
  "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); read each cited test before you run it (a test that only
  asserts what a sibling collects is run with its whole file). **AC3** (a site that refuses nothing: byte for byte, each
  address asked no more often, no slower by paired interleaved rounds) is named only: run it with `F2B_BASE_TREE` = a
  `git archive` of the base at the lowest load you can get, never retried until green; report its table and `uptime`
  (its count clause has shown load noise base shows too: say if you see it on both trees).
- Head `ebd4dfc8ed78e511b3671985eb2bb3d7f165013e` (branch `capture-refused-styles-stack2`), base (old code) main
  `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9` (Build 2026-11-11.2). In your own worktree: `git checkout --detach
  ebd4dfc8ed78e511b3671985eb2bb3d7f165013e`, confirm `git rev-parse HEAD` and a clean status. Old code: a tree from `git
  archive` of `e16d3d1e` with head's test files, fixtures and test-only modules copied in (a new module that doesn't
  import on base is weak RED: prove the test can fail with a one-line mutant of a head copy — a load-hook mutant checks
  its replaced text occurs exactly once; preservation ACs that rightly pass on base are `base_exempt` with a reason and
  your own byte receipt). An AC log cited in `ac.json` starts with the bare `HEAD=<sha>` (say "archive" on its second
  line) and ends with one line `EXIT=`, skipped 0.
- Don't read the builder's, fixers' or reviewers' reports or folders as proof (`builder/`, `fixer-*`, `review-*`,
  `stack-*`, `verifier-review1-*`, `planner/`). Write only in `evidence/capture-refused-styles/verifier/` (empty).

## Work
1. **Gates on head against base by name:** both typechecks (`tsconfig.sandbox.json` too), `npm run check` (8G scope),
   `npm run corpus` (same output as base; v1's Mac files are missing here), the plan's Task 9 web suites, every
   `site-import-*` web file, `human-check` whole and site-menu's guard files (`capture-opens`, `capture-opens-guards`,
   `press-guard-sockets`, `capture-commands-sockets`, `site-opens-proof`), each web file alone under `systemd-run
   --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`; a TMPDIR of about
   24 characters); `test/unit/plugin-convert.test.ts`; `dist/` byte-identical to base's build. Known flakes (F6-5 in
   `capture-opens-guards`; `site-upload-cli` / `-stop` timing under load): rerun alone before judging.
2. Every AC's named test on head (must pass) and on old code; a terminal capture per AC (AC1: a whole run where the
   check comes back partway and the capture ends clean; AC2: the refusal line and the log's content; AC10: the
   first-load refusal).
3. **The fix, proven by you on fixtures of your own** (beside the plan's edge fixture): a check whose pass expires
   during the ranges, during the pictures, during the font files, twice; one a person presses again in the visible
   window (Justin's route) and one that passes itself; a page with pictures (raster) and a menu button whose opened box
   shows the site's own picture. Through `npm run capture` **and** `npm run site:import` (stand-in, made-up password,
   answered "no"): each ends with a capture `capture:check` calls ok, every picture held (the menu's too), equal to the
   clean capture; the press guard still holds (0 writes, page loads or sockets from presses). A site that keeps
   refusing: the refusal line (whole address with query, status, server, title, what to type), the log, exit 1, no
   capture a later tool takes as clean. A site that refuses nothing: no renewal, no tab route, request counts equal to
   base. No disguise: Chrome's switches, `navigator.webdriver`, the user agent as before; no cookie in any Node request
   (log your fixture's request headers).
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/verifier/ac.json` and logs in that
   folder; self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy
   (`--base e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`, no `--reviews`), as the reference says.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/crsv/t1`,
`t2`, …; a Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by the PIDs
of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" may be refused: write such steps to a script file with Write and run `bash
<file>`; `git -C <absolute path>`). A script hosting a fixture server in its own process starts the CLI with async
`spawn`. Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running against. Scripts and logs under
`~/.cache/capture-refused-styles-verifier/`. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom
--since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`). Waits under 115 s; start long drivers with
`setsid --fork` and wait on `^EXIT=` in bounded loops. The PC restarted four times this week: write each log's `EXIT=`
line; when resumed, read your finished logs first and never start a second driver on a suite one is still working
through.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result (or the mutant), evidence path; the fixture table (shape × route → exit,
pictures, `capture:check`, equal to clean, guard counts); AC3's table and `uptime`; the no-disguise check; gates;
`verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; `enforce` is `none`
or a one-line check proposal; never edit skills or memory), ending with `MAIN SESSION: check and save these
skill_lessons now.`
