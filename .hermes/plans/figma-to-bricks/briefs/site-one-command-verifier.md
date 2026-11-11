# Role: verifier (read-only): site-one-command

You are a fresh verifier who never saw the build, the reviews or the fix (**Opus 5.5, high**). Prove each acceptance
criterion yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other
worktrees (read them with `git show`). **Never load bdryswi.com, B-Dry staging or any live site** (local fixture
servers and saved files only); no logins; **never write to any WordPress site: `site:upload` and `site:import` run
only against the local stand-in (`test/fixtures/wp-standin.ts`, 127.0.0.1)**; never ask for, hold or look for a real
password (tests use a made-up one). Nothing may hide that the importer's Chrome is automated. Justin may be running
his own Chrome and terminal: never stop a Chrome you didn't start; touch nothing under `~/Downloads` (every tool run
gets `--out` in a scratch folder and a scratch `HOME`).

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format at the top of `scripts/ac-check.sh`) and follow it; load `authorized-write-safety`; the
project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` (the terminal lines: the pty driver `test/fixtures/pty-run.py`, a typed-ahead drop
reads in raw mode, prove echo and line mode during the run, a leak probe leaves the driver out; async spawn beside an
in-process fixture server).

## Inputs
- Approved plan (read-only; amended A1–A11, the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/plan-approved.md` (AC1–AC14; AC13 and AC14 are
  `(live)`, Justin's own run and paste: mark them `not_run`, owed). The job: `npm run site:import -- <old page>
  <https://wordpress-site>` asks for WordPress details first and tests the login, scans, stops only for a real failure
  and warns for smaller problems (Justin's Q5, "Only real failures"), lists the pictures, waits for a `yes` typed after
  the question shows, uploads with `site:upload`'s uploader and writes the pastes; the four existing commands and the
  Figma plugin stay as they were. Find every cited test name with ac-check's own grep first (`command grep -E
  "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); a name the runner prints with a prefix goes through a by-name
  checker citing a phrase that sits whole on one plan line. **AC6's cited test was renamed by amendment A7** (use the
  plan's current name). Read each cited test before you run it (a test that only asserts what a sibling collects is
  run with its whole file). AC11 and AC12 are story pins: they run only with `F2B_STORY_PINS=1` and
  `F2B_BASE_TREE=<a git archive of the base>`.
- Head `8c872ad2163382848a53170eef5d4bd7152779fb` (branch `site-one-command-fix1`; code head `963d6d01`), base (old
  code) main `11e885fda5d08863a5875f939085350c007ac732` (Build 2026-11-10.8). In your own worktree: `git checkout
  --detach 8c872ad2163382848a53170eef5d4bd7152779fb`, confirm `git rev-parse HEAD` and a clean status. Old code: a
  tree from `git archive` of `11e885fd` with head's test files, fixtures and test-only modules copied in. **The new
  CLI doesn't exist on base, so most RED there is weak:** where the guarantee lives wholly in new files, prove the
  test can fail with a one-line mutant of a head copy (a refusal-removing mutant with networking off: `unshare -rn sh
  -c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000 node --test …'`); preservation ACs
  that rightly pass on base are `base_exempt` with a reason and your own byte receipt. An AC log cited in `ac.json`
  starts with the bare `HEAD=<sha>` (say "archive" on its second line) and ends with one line `EXIT=`, skipped 0.
- Don't read the builder's, fixer's or reviewers' reports or folders as proof (`builder/`, `fixer-1/`, `review-*/`,
  `verifier-review1-*/`). Write only in `evidence/site-one-command/verifier/` (empty).

## Work
1. **Gates on head against base by name:** both typechecks (`tsconfig.sandbox.json` too), `npm run check` (8G scope),
   `npm run corpus` (same output as base; v1's Mac files are missing here), every `site-import-*` web file,
   `site-upload-ask-fresh`, and the existing upload, owned, human-check, capture-cli, capture-unreachable,
   capture-not-the-page and site-upload-page files, each web file alone under `systemd-run --user --scope -p
   MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`); `test/unit/plugin-convert.test.ts`;
   `dist/code.js` and `dist/ui.html` byte-identical to base's build. Known flakes rerun alone before they are judged.
2. Every AC's named test on head (must pass) and on old code, with a terminal capture each (a PNG of the log, or the
   pty transcript).
3. **The guards, proven by you beyond the tests** (your own runs, a made-up password, scratch `HOME`, fresh stand-ins):
   - **The password:** a success run, a wrong password, a failed scan, a warning run, `--no-shots`, a dry run, a stop
     at each stage (password, owned question, scan, yes, upload) and a crash: grep every form (as typed, without
     spaces, the Basic `user:password` base64 in standard, base64url, unpadded, URL-encoded and JSON-escaped forms) in
     every file left, both outputs, and `/proc/<pid>/cmdline` and `environ` of the tool and every Chrome process the
     scan starts, sampled during the scan and at the yes question. Run `gitleaks` over your folder from a script file
     before handing back (redact anything a mutant printed).
   - **Nothing but reads before a fresh yes** (the stand-in's request log per row), in a real terminal through the pty
     driver: `yes`+Enter during the scan; `yes` with no Enter during the scan, then Enter alone at the question; `yes`
     as the owned answer; `yes` pasted before the question; Enter held; Ctrl+C at each question. Prove the terminal's
     echo and line mode during the run (the echo of an answer typed after the question), not after it. On a pipe with
     a real site address: refused at once, no request.
   - **Justin's Q5:** each of the four stops (a failed scan, a page that isn't the site's, a range read without the
     site's styles, `site:upload`'s own conversion refusal) stops before the list with the plan's line and exit code;
     each warning kind prints before the list and the list equals `site:upload --dry-run`'s for the same capture, line
     for line, and the POST count equals its "would go up" count (a fixture page with one 404 picture; a clean page;
     the saved B-Dry stand-in `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`
     as an input file only, through `afterScan` and `site:upload --dry-run`, nothing sent).
4. **The four existing commands as on base** (AC11's sense, beyond the pin): `npm run capture` (one page, `--list`, a
   refused owned question, a missing Chrome), `capture:check`, `site` and `site:upload` (dry run, run, second run,
   not yes, a stop) from both trees against stand-ins on one fixed port: outputs, files and request logs equal.
5. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/verifier/ac.json` and logs in that
   folder; self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy
   (`--base 11e885fda5d08863a5875f939085350c007ac732`, no `--reviews`), as the reference says.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/soc-v/t1`,
`t2`, …; a Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by the PIDs
of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" (gitleaks included) may be refused: write such steps to a script file with Write
and run `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running
against. Scripts and logs under `~/.cache/site-one-command-verifier/`. SIGTERM / 143 / 137 or "Killed" may be
earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`) or a probe's own kill: say which.
Waits under 115 s; start long drivers with `setsid --fork` and wait on `^EXIT=` in bounded loops. The PC restarted
three times this week: write each log's `EXIT=` line; when resumed, read your finished logs first and never start a
second driver on a suite one is still working through.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result (or the mutant that proves it can fail), evidence path; the password table;
the requests-before-yes table; the stop/warning table; the four commands against base; gates; `verdict`; `ac_status`;
then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; `enforce` is `none` or a one-line check
proposal; never edit skills or memory), ending with `MAIN SESSION: check and save these skill_lessons now.`
