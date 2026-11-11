# Role: reviewer, round 1 (Mini: the one full review, plus the verifier's AC work; report only): site-one-command

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). **Never load bdryswi.com, B-Dry staging or any live site** (local fixture servers and saved
files only); no logins; **never write to any WordPress site: `site:upload` and `site:import` run only against the
local stand-in (`test/fixtures/wp-standin.ts`, 127.0.0.1)**; never ask for, hold or look for a real password (tests
use a made-up one). Nothing may hide that the importer's Chrome is automated. Justin may be running his own Chrome and
terminal: never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Mini pipeline** (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`, step 3): you do
two jobs in one pass and write two files: the **review** (`review-1/review.json`, `review-loop.md`) and the
**verifier's AC work** (`verifier/ac.json`, `ac-verification.md`): every AC's named test on head and on old code, with
logs and a terminal capture each.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for a bug a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. **This job's guards are P0/P1 when they fail:** the Application Password reaches
an argument, an environment variable, a file, the record, the capture, a paste, a log, a printed line or a child
process (Chrome's command line and environment included); anything but a read goes to WordPress before a `yes` typed
after the upload question shows; a run with no person at the terminal reaches a real site; the tool writes anything
to WordPress but the media items `site:upload` adds, or to a site other than the typed one.

## What the job is
Justin scanned a page with `npm run capture` and expected it to ask for his WordPress details ("i expected it to ask
me for the applicaiton password to check for media"). He chose one command, Mini. `npm run site:import -- <old page
address> <https://wordpress-site> [--elementor] [--user …] [--dry-run] [--out …]` asks for the WordPress site, user
name and Application Password first and tests the login with a read, then scans the page (the person check in the
visible window if the site asks), lists the pictures and their alt text, waits for a typed `yes`, uploads with
`site:upload`'s own uploader and writes the pastes with numbered next steps. `capture`, `capture:check`, `site` and
`site:upload` stay as they are. The planner proved two hazards on the base that this job must close for its own
command: the owned-site question's answer became the upload's `yes`; a `yes` typed during the scan was taken the
moment the question appeared.

## Inputs
- Approved plan (read-only; amended A1–A6, the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/plan-approved.md` (AC1–AC14, all proposed;
  AC13 and AC14 are `(live)`, Justin's own run: mark them `not_run`, owed). Find every cited test name with
  ac-check's own grep first (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); a name the runner
  prints with a prefix goes through a by-name checker citing a phrase that sits whole on one plan line. Read each
  cited test before you run it (a test that only asserts what a sibling collects is run with its whole file). AC11
  and AC12 are story pins: they run only with `F2B_STORY_PINS=1` and `F2B_BASE_TREE=<a git archive of the base>`, as
  the plan says.
- Branch `site-one-command-build`, head `e0e62e0c3cdda6fe55632ed52cc3aa5d5666f79d` (the last commit is the ledger;
  code head `aefa0ef48b768a49b0fe2799c756602da42e1724`), base `main` `11e885fda5d08863a5875f939085350c007ac732` (Build
  2026-11-10.8). In your own worktree: `git checkout --detach e0e62e0c3cdda6fe55632ed52cc3aa5d5666f79d`, confirm HEAD
  and a clean status. Review `git diff 11e885fd...HEAD` (the whole story). Old code for the AC work: a tree from `git
  archive` of `11e885fd` with head's test files, fixtures and test-only modules copied in (a new CLI that doesn't
  exist on base is weak RED: where the guarantee lives wholly in new files, prove the test can fail with a one-line
  mutant of a head copy instead, and run refusal-removing mutants with networking off: `unshare -rn sh -c 'ip link
  set lo up && exec unshare --user --map-user=1000 --map-group=1000 node --test …'`; preservation ACs that rightly
  pass on base are `base_exempt` with a reason and your own byte receipt). An AC log cited in `ac.json` starts with
  the bare `HEAD=<sha>` (say "archive" on its second line) and ends with one line `EXIT=`, skipped 0.
- The builder's record (read, don't trust): `evidence/site-one-command/builder/` (`red/`, `gates/`, `gates-a3/`,
  `mutants/`, `held/`, `rebase/proof.txt`), the ledger, HANDOFF's section, `evidence/site-one-command/follow-ups.md`
  (recorded: `site:upload`'s own yes question still takes typed-ahead input — a follow-up, HANDOFF "Deferred";
  site-media-upload's Q12 is open; the join with the unmerged job site-menu: `tools/lib/capture-run.ts` must call
  `launchCaptureChrome` once site-menu is on main — not this review's finding).

## Check hardest
1. **The password's whole life.** From the hidden prompt to the end of every path (success, a wrong password, a
   failed scan, an unclean scan, not `yes`, Ctrl+C at the password prompt / during the scan / at the yes question /
   during the upload, a crash): where does it live, who can read it? Your own run against the stand-in with a made-up
   password, then grep for it in every form (as typed, without spaces, inside the Basic `user:password` base64 in its
   standard, base64url, URL-encoded and JSON-escaped forms): every file under the out folder and the record, both
   outputs, `/proc/<pid>/cmdline` and `environ` of the tool and of **every Chrome process and helper the scan
   starts** while it scans and while it waits at `yes`, the capture file, `media.json`, the pastes, the notes. Is the
   terminal's echo back on after every stop? Does any error path print a request's headers? Is the password ever
   passed to the capture's code or reachable from the page (CDP, a global, a closure the page could call)?
2. **Nothing but reads before the fresh `yes`.** The stand-in's request log through each path: only GETs before a
   `yes` typed after the question shows. In a real terminal (the pty driver `test/fixtures/pty-run.py`): `yes` typed
   during the scan; `yes` as the answer to the owned question; `yes` pasted with a newline before the question;
   `yes\n` arriving in the same chunk as the user name; Enter held down. On a pipe with a real site: refused at once.
   `--dry-run`: no password asked, the stand-in's log empty.
3. **The move of `tools/site-upload.ts`'s body into `tools/lib/site-upload/flow.ts`** (the plan's biggest edit): is
   `site:upload` byte for byte what it was — the same questions in the same order at the same moments, the same
   printed lines, the same requests, the same exit codes, the same refusals (no terminal; a redirect; a WordPress
   naming another site; http), the same stop handling (R1-1: uploads going up answer first, then the record,
   `media.json` and the pastes)? Your own run of both trees against two fresh stand-ins on the same fixture page:
   outputs and request logs equal after the ports are normalised; `git diff 11e885fd...HEAD -- tools/lib/site-upload/`
   read line by line for anything that changes what is sent. The same for `tools/capture.ts` → `capture-run.ts` /
   `capture-pages.ts`: `npm run capture` (one page, `--list`, `--all`, a refused owned question, a missing Chrome)
   prints and writes as on base.
4. **The one command's own flow:** a wrong password stops before Chrome starts and before the old site is asked
   anything (your fixture server's log empty); the owned question; a scan that fails (a bot-check page, a closed
   port, a stylesheet that never arrives) uploads nothing and says what to type next; a scan `capture:check` refuses
   is refused before anything is listed; the found list equals `site:upload --dry-run`'s lines for that capture; the
   endings that didn't upload everything print the exact `npm run site:upload -- …` line that finishes from that
   scan, and that line works when pasted (quotes, spaces in paths, the flags carried over); the default out folder
   (`~/Downloads/<page name>/`) is computed but **never written by a test** (check the tests' folders); AC9: the one
   command's `media.json`, pastes, sources and notes equal `capture` then `site:upload`'s.
5. **The amended test** (`test/unit/capture-chrome.test.ts`, the one changed case): it still proves what it proved and
   now pins both commands to the one launch; two mutants of your own (site:import finding Chrome another way; the
   run's launch with no Chrome naming a different line) are killed on its assertions.
6. **Mini's size and scope:** is anything here a design decision the plan didn't make, or a change to what is sent to
   WordPress? `git diff 11e885fd...HEAD --stat`: files outside the plan's list; `src/core`, `src/plugin`, `src/ui`,
   `src/shared`, `manifest.json`, `build.mjs` untouched and `dist/` byte-identical to base's build (AC12). HANDOFF's
   section says what Justin types, what it asks in order, what `--dry-run` does and what each ending prints, truly.
7. **Gates on head against base by name:** both typechecks (`tsconfig.sandbox.json` too), `npm run check` (8G scope
   for the parallel unit suite), `npm run corpus` (same output as base; v1's Mac files are missing here), every
   site-import test file and the existing upload, owned, human-check, capture-cli, capture-unreachable and
   capture-not-the-page files, each web file alone under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0` (export variables first; no `--setenv=PATH`); known flakes are rerun alone before they are judged
   ("Chrome didn't start within 20s" under load: kill that node child and its own Chromes, rerun alone).

## Work
Load `requesting-code-review`, `code-review-practice` and `authorized-write-safety`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and `ac-verification.md` (the
verifier's procedure and the `ac.json` format at the top of `scripts/ac-check.sh`), and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the terminal
lines: the pty driver, one Prompter per process, async `execFile` beside an in-process fixture server). Write:
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/review-1/review.json` (round 1, a full review;
  `head` the full SHA of your HEAD), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
  --repo <your worktree> --base 11e885fda5d08863a5875f939085350c007ac732
  /home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command` (exit 2 means your file is wrong: fix it);
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/verifier/ac.json` with its logs and captures
  in that folder, self-checked with `ac-check.sh` on a copy (`--base 11e885fda5d08863a5875f939085350c007ac732`, no
  `--reviews`), as the reference says.
Run `gitleaks` over your two evidence folders before handing back (a mutant that prints the made-up password leaves
it in a log: redact).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/soc-r1/t1`,
a separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop
it by the PIDs of its own profile path; never `pkill -f <pattern>`); a worktree's `node_modules` may lack `.bin`, and
a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar; never
chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`.
Run every tool with `HOME` pointed at a scratch folder so no record or default folder under the real home is written.
Scripts written with Write under `~/.cache/site-one-command-review1/`. SIGTERM / 143 / 137 may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three
times this week: write each log's `EXIT=` line, keep notes on disk; when resumed, read them first.

## Report (as text; only the two json files, logs and captures are written)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the password table (place → found or
not, per path); the requests-before-yes table; `site:upload` and `capture` against base (equal or what differs); per
AC: test, head result, old-code result, evidence path; gates; `verdict`; `ac_status`; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
