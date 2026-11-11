# BLIND AC AUDITOR (read only): site-one-command (`npm run site:import`: one command that asks for WordPress first, then scans, uploads and writes the paste)

You are a fresh auditor (**Opus 5.5, xhigh**). Independently prove the approved acceptance criteria. You have never
seen a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/` except `plan-approved.md` and your own
`auditor/` folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `planner/`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes; nor other agents'
scratch folders under `~/.cache/` (`soc-*`, `site-one-command-*` other than your own). Source and tests are read-only;
commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (local fixture servers and saved files only); no logins;
**never write to any WordPress site: `site:upload` and `site:import` run only against the local stand-in
(`test/fixtures/wp-standin.ts`, 127.0.0.1)**; never ask for, hold or look for a real password (a made-up one only).
Nothing may hide that the importer's Chrome is automated. Justin may be running his own Chrome and terminal: never stop
a Chrome you didn't start; touch nothing under `~/Downloads` (every tool run gets `--out` in a scratch folder and a
scratch `HOME`).

## The only inputs
- Approved plan (amended A1–A11; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/plan-approved.md` (AC1–AC14; AC13 and AC14 are
  `(live)`: mark them `not_run`). Judge each AC by its amended words. Use each exact test name the plan cites: find
  them all first with ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`);
  where the runner prints a name differently, cite a phrase that sits whole on one plan line and run the test by its
  full printed name through a by-name checker, as `ac-verification.md` says. Read each cited test before you run it
  (a test that only asserts what a sibling collects is run with its whole file). AC11 and AC12 are story pins: they
  run only with `F2B_STORY_PINS=1` and `F2B_BASE_TREE=<a git archive of the base>`. Run the supporting tests the plan
  names beside the cited ones, and never cite them.
- Head `8c872ad2163382848a53170eef5d4bd7152779fb` (branch `site-one-command-fix1`), base
  `11e885fda5d08863a5875f939085350c007ac732` (local `main`, Build 2026-11-10.8), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/auditor/` (empty). The saved B-Dry stand-in
  capture may be read as an **input file only**:
  `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json` (say its
  sha256, and that it is a saved file, not the live site); open nothing else in that folder.

## Your copy
In your own worktree: `git checkout --detach 8c872ad2163382848a53170eef5d4bd7152779fb`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly
8388608 bytes and restore them with `git checkout --`; `git cat-file -t HEAD`). Your `ac.json` names this head and
base. Never write in any other worktree or the main folder.

## Work
Load `engineering-best-practices` and `authorized-write-safety`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the terminal
lines: the pty driver `test/fixtures/pty-run.py`, a typed-ahead drop reads in raw mode, prove echo and line mode
during the run not after it, a leak probe leaves the driver out, a preload that logs every connect to prove "nothing
sent"); read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report
format at the top of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every AC make your own
head and base runs (an AC log starts with the bare `HEAD=<sha>` and ends with one line `EXIT=`, skipped 0; base: a
tree from `git archive` of the base with head's test files, fixtures and test-only modules copied in, labelled in the
log's second line). **The command doesn't exist on base, so a base failure there is weak:** prove each AC's test can
fail with a one-line mutant of a head copy (under the 4 GB cap, restored by hash; a mutant that removes a refusal runs
with networking off: `unshare -rn sh -c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000
node --test …'`); preservation ACs that rightly pass on base are `base_exempt` with a specific reason, backed by your
own byte receipt. Also:
- **The guards, proven by you hardest** (your own runs, a made-up password, fresh stand-ins):
  - the password: through a success, a wrong password, a failed scan, a warning run, a dry run and a stop at each
    stage, grep every form (as typed, without spaces, the Basic `user:password` base64 in standard, base64url,
    unpadded, URL-encoded and JSON-escaped forms) in every file left, both outputs, and `/proc/<pid>/cmdline` and
    `environ` of the tool and every Chrome process (sampled during the scan and at the yes question); `gitleaks` over
    your folder from a script file before handing back (redact what a mutant printed);
  - in a real terminal (pty): only reads reach the stand-in before a `yes` typed after the question shows — `yes`
    typed during the scan with and without Enter (then Enter alone at the question), `yes` as the answer to the
    owned-site question, a pasted `yes`; the terminal's echo and line mode during the run;
  - with no person at the terminal (a pipe), a real site address is refused at once with no connection attempt.
- **Justin's Q5 ("Only real failures"):** each stop the plan names stops before the list; each warning kind prints
  before the list and the list then equals `site:upload --dry-run`'s for the same capture, line for line, with the
  POST count equal to its "would go up" count (a fixture page with one 404 picture, a clean page, the saved stand-in
  through the command's after-scan step with nothing sent).
- **The four existing commands as on base:** `capture`, `capture:check`, `site`, `site:upload` from both trees against
  stand-ins on one fixed port: outputs, files and request logs equal.
- A terminal capture per AC (a picture of the log or the pty transcript).
- Run `git log -p 11e885fd..HEAD -- <each AC's test files>` and read every assertion against the amended plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base 11e885fda5d08863a5875f939085350c007ac732`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/soc-audit/t1`, `t2`; a Chrome profile under a long TMPDIR dies with
  "Socket path too long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you**
  start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack
  `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
  piped, chained or redirected git command, a heredoc, a shell function or a word containing "git" (gitleaks included)
  may be refused: write such steps to a script file with Write and run `bash <file>`; `git -C <absolute path>`). A
  script hosting a fixture server or the stand-in in its own process starts the CLI with async `spawn`, never
  `spawnSync`. Use `tail -n 3`, never `tail -3`. Keep scripts and logs under `~/.cache/site-one-command-auditor/` and
  copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a tree a test is running against.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`) or a probe's own kill: say which; heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (the parallel unit suite 8G; export variables first, no
  `--setenv=PATH`).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s (wait on
  `^EXIT=`). The PC restarted three times this week: write each log's `EXIT=` line; when resumed, read your finished
  logs first and never start a second driver on a run still going.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, guards (the password table, the requests-before-yes table, the stops and warnings), found_else[],
skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every agent-run AC accepted. Empty skill_lessons is
normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with `MAIN SESSION: check
and save these skill_lessons now.`
