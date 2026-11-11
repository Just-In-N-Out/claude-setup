# Role: reviewer (round 2, a delta: fix pass 1; report only): site-one-command

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change no source or
test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees (read them with `git show`). **Never load bdryswi.com, B-Dry staging or any live site** (local fixture
servers and saved files only); no logins; **never write to any WordPress site: `site:upload` and `site:import` run
only against the local stand-in (`test/fixtures/wp-standin.ts`, 127.0.0.1)**; never ask for, hold or look for a real
password (tests use a made-up one). Nothing may hide that the importer's Chrome is automated. Justin may be running
his own Chrome and terminal: never stop a Chrome you didn't start; touch nothing under `~/Downloads` (every tool run
gets `--out` in a scratch folder and a scratch `HOME`).

**Importer rule (Justin, 2026-11-02):** P0–P2 only for a bug a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. **This job's guards are P0/P1 when they fail:** the Application Password
reaches an argument, an environment variable, a file, a log, a printed line or a child process; anything but a read
goes to WordPress before a `yes` typed after the upload question shows; a run with no person at the terminal reaches a
real site. From round 2 in Mini the referee asks Justin when a round leaves only P2: rate each finding exactly.

## What happened before you
`npm run site:import -- <old page> <https://wordpress-site>` asks for WordPress details first, tests the login, scans,
lists the pictures, waits for a typed `yes`, uploads with `site:upload`'s uploader and writes the pastes. Review 1
(`evidence/site-one-command/review-1/review.json`) found R1-1 (P1: a `yes` typed during the scan with no Enter, then
Enter alone at the question, uploaded: the typed-ahead drop read in line mode) and R1-2 (P2: `--no-shots` always
refused by the scan gate), plus P3s. Justin then changed Q5 ("Only real failures (Recommended)"): after the scan the
run stops only for what `site:upload` itself refuses (a failed scan; a page that isn't the site's page; a range read
without the site's styles; `site:upload`'s own conversion refusals), and every smaller problem `capture:check` names
is a `Warning:` line before the picture list. The planner amended the plan (A7–A11). Fixer 1 applied it: the drop
reads in raw mode for its 150 ms settle (finished lines and unfinished letters alike; a `finally` restores line
mode; Ctrl+C inside it ends with 130); the owned-site question is asked fresh too (R1-5); `scanProblem` returns
`{stop, warnings}`; `--no-shots` gives one warning; R1-6, R1-7, R1-9 fixed; a test-only seam `Terminal.settleMs`.

## Inputs
- Approved plan (read-only; amended A1–A11, the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/plan-approved.md` (AC1–AC14; AC13, AC14 live).
- Branch `site-one-command-fix1`, head `8c872ad2163382848a53170eef5d4bd7152779fb` (code head `963d6d01`; first fix
  commit `bda8a481`), on review 1's head `e0e62e0c3cdda6fe55632ed52cc3aa5d5666f79d`, base main
  `11e885fda5d08863a5875f939085350c007ac732`. In your own worktree: `git checkout --detach
  8c872ad2163382848a53170eef5d4bd7152779fb`, confirm HEAD and a clean status. **Your scope (Mini round 2):** `git diff
  e0e62e0c..HEAD` and what it touches.
- The fixer's record (read, don't trust): `evidence/site-one-command/fixer-1/` (`red-*.log`, `green-*.log`,
  `three-captures.log`, `yes-rows.log`, `mutants/`, `check-byname.txt`); review 1's probes
  `evidence/site-one-command/review-1/probes/` (`runs/`, the pty probe set); `evidence/site-one-command/follow-ups.md`
  (recorded follow-ups R1-4, R1-8, R1-10 and the fixer's two found_else lines: don't re-report unless you rate one
  higher, with a scenario).

## Check hardest
1. **The fresh drop, in a real terminal** (the pty driver `test/fixtures/pty-run.py`; leave the driver's own process
   out of any `/proc` leak probe): rerun review 1's terminal rows on head (`yes`+Enter during the scan; `yes` with no
   Enter during the scan then Enter alone; `yes` as the owned answer; `yes` pasted at `File:` and at the list; `yes` in
   the same chunk as the user name; Enter held down; the password + two Enters at the owned question) and add your
   own: letters typed in the last 10 ms before the question shows; a paste that spans the settle (half before, half
   after); `yes` typed during the settle; Ctrl+C, Ctrl+D and Ctrl+Z during the settle; a terminal resized during it;
   a slow terminal where the question's prompt arrives after the settle started. Every row: what counts as the answer,
   what the stand-in received (0 POST unless a `yes` was typed after the question showed and the settle ended), the
   terminal's echo and line mode during and after the run (assert the echo of a later answer: Node resets the mode at
   exit, so an after-run read proves nothing), exit code. Is `Terminal.settleMs` reachable outside tests (an
   environment variable, an argument)? It must not be.
2. **Justin's Q5 as built:** `scanProblem`'s four stops and the warnings, against the amended AC6 sentence. Can a
   problem that should stop (a range read without styles; a page that isn't the site's: a bot check, an error page, a
   log-in page; a scan that never got the page) be turned into a warning and so reach the list and the yes question?
   Probe each with a capture of your own (local fixtures; review 1's `broken-picture`; the saved B-Dry stand-in as an
   input file only). For each warning case: the list equals `site:upload --dry-run`'s for the same capture, line for
   line, and the POST count equals its "would go up" count. Is the warning's wording true (the fixer notes the
   no-bytes count includes Figma-layer pictures the list never shows: does that mislead Justin into thinking pictures
   are lost?). `--no-shots`: end to end against the stand-in, exit 0, pastes byte for byte as without it.
3. **R1-6, R1-7, R1-9:** the rewritten lines are true and `npm run capture`'s and `site:upload`'s own lines are byte
   for byte as on base (AC11's pin with `F2B_STORY_PINS=1` and `F2B_BASE_TREE` = a `git archive` of `11e885fd`); the
   `site:upload …` line printed after a stop during the upload, pasted, finishes the run without a second scan;
   AC2's failure message never prints a leaked form's text (run its mutant M8 or one of your own and read the log).
4. **The password, again on the changed paths:** your own run with a made-up password through a warning run, a
   `--no-shots` run, a Ctrl+C inside the settle and a stop during the upload: grep every form (as typed, without
   spaces, the Basic base64 in standard, base64url, unpadded, URL-encoded and JSON-escaped forms) in every file left,
   both outputs, the tool's and every Chrome process's `/proc` cmdline and environ. Run `gitleaks` over your evidence
   folder from a script file before handing back.
5. **Gates:** both typechecks, `npm run check` (8G scope; by name against base `11e885fd`), every `site-import-*` web
   file, `site-upload-ask-fresh`, `capture-cli`, `human-check`, `site-upload-page`, each web file alone under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`);
   AC11's and AC12's pins; `dist/` byte-identical to base's build. Two mutants of your own under the cap: the settle
   ending before the question is printed; `scanProblem` treating `notThePage` as a warning.

## Work
Load `requesting-code-review`, `code-review-practice` and `authorized-write-safety`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the terminal
lines). Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/review-2/review.json` (round 2, a
delta from review 1's head `e0e62e0c`; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
11e885fda5d08863a5875f939085350c007ac732 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command` (exit 2
means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/soc-r2/t1`,
a separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop
it by the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and
a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command, a heredoc, a shell function or a word containing "git" (gitleaks
included) may be refused: write such steps to a script file with Write and run `bash <file>`; `git -C <absolute
path>`). Never edit a tree a test is running against. Use `tail -n 3`, never `tail -3`. Scripts under
`~/.cache/site-one-command-review2/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min"
-o short-iso | grep sending`) — or a probe's own kill: say which. Waits under 115 s. The PC restarted three times this
week: write each log's `EXIT=` line, keep notes on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the terminal table (row → answer, POSTs,
echo during the run, exit); the gate table (case → stop or warning, list equal to `site:upload --dry-run`'s?); the
password table for the changed paths; R1-1 and R1-2 closed or not; `verdict`; `ac_status` (per AC: what the review
saw); then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
