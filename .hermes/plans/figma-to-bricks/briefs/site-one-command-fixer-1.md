# Role: fixer (round 1: review 1's R1-1 and R1-2, and Justin's new scan-gate rule): site-one-command

Review 1 (a full review with the verifier's AC work) ended `REVIEW AGAIN: 2 P0-P2 finding(s)`. Justin then changed
one of the plan's answers (asked in a question on 2026-11-10; his words: **"Only real failures (Recommended)"**), and
the planner amended the plan (A7–A11). You apply all of it in one pass.

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix test-first, then stop at `ready-for-next-review`.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging or any live site**
(local fixture servers and saved files only); no logins; **never write to any WordPress site: `site:upload` and
`site:import` run only against the local stand-in (`test/fixtures/wp-standin.ts`, 127.0.0.1)**; never ask for, hold
or look for a real password (tests use a made-up one). Nothing paid. Nothing may hide that the importer's Chrome is
automated. Justin may be running his own Chrome and terminal: never stop a Chrome you didn't start; touch nothing
under `~/Downloads` (every run of the tools gets `--out` in a scratch folder and a scratch `HOME`).

**Skills to load:** `receiving-code-review` (verify each finding before fixing it; push back with evidence if one is
wrong), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the guards: the fresh
yes; "nothing but reads before the yes"; a warning never changes what goes up), `authorized-write-safety`,
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md` (the terminal line: the pty driver `test/fixtures/pty-run.py`, one Prompter per
process, a typed-ahead drop reads in raw mode, a leak probe leaves the driver out) and the repo `CLAUDE.md` in the
main folder (the standing rule "One tool writes to WordPress").

## Your copy (you start in your own worktree)
`git checkout -B site-one-command-fix1 e0e62e0c3cdda6fe55632ed52cc3aa5d5666f79d` (the reviewed head, branch
`site-one-command-build`, on main `11e885fda5d08863a5875f939085350c007ac732`, Build 2026-11-10.8). Check `git rev-parse
main` before your final gates: if main moved, rebase onto it (HANDOFF: this job's section first, then main's lines
exactly as main has them), say which commits conflicted, and report main's SHA as your review base. Report your
branch.

## Inputs
- **The approved plan, amended twice** (read-only; A1–A11 in the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/plan-approved.md`. Read A7–A11, the amended
  Q5, AC3 and AC6 sentences, the Interfaces section (`scanProblem`, the warnings' exact sentences, the fresh drop),
  step 7 of the order, Task 3, and "Risks" / "Deferred". The planner's proofs: `evidence/site-one-command/planner/amend2/`
  (`three.log`: what `capture:check` and `site:upload --dry-run` do with review 1's three captures).
- Review 1: `evidence/site-one-command/review-1/review.json`; its probes `review-1/probes/` (`runs/ahead-noenter-pty`:
  R1-1's proof; `fix-sketch`: the reviewer's raw-mode sketch; `noshots-svg-pipe`, `noshots-offline.log`: R1-2;
  `broken-picture`, `memory-vs-file.log`, `bdry-standin-gate-offline.log`: R1-3; `double-enter-pty`: R1-5). The
  reviewer's AC work: `evidence/site-one-command/verifier/` (read; a fresh verifier proves the ACs again after you).

## What to fix (each verified on your base first, then test-first: RED by its own assertion, then GREEN)
1. **R1-1 (P1) — the fresh yes takes letters typed before it shows.** `yes` typed during the scan with no Enter, then
   Enter alone at the question, uploads (7 POSTs). Fix as the amended plan says (A8): on a terminal, a `fresh`
   question reads the terminal in raw mode for the settle and drops everything that arrives, finished lines and
   unfinished letters alike; line mode is put back in a `finally` on every path (an error, a stop: prove the
   terminal's echo and line mode are back after Ctrl+C during the settle; a Ctrl+C among the dropped keys ends the
   tool with 130); in a pipe only the Prompter's buffer is dropped, with no wait. AC3's cited test gains the no-Enter
   case through the pty driver (title unchanged): `Not yes`, exit 2, no POST. **`site:import`'s owned question is
   asked fresh too (R1-5)**, with the supporting case the plan names. `site:upload` itself stays byte for byte (AC11's
   pin): its own typed-ahead window is a recorded follow-up, not yours.
2. **Justin's Q5, "Only real failures" (A7) — the scan gate.** After the scan the run stops only for the four stops
   the plan lists (a failed scan; a page that isn't the site's page; a width range read without the site's styles;
   what `site:upload`'s own conversion refuses), each with the exit code and the exact last line the plan gives;
   every other problem `capture:check` names is one `Warning: …` line per kind, printed after the scan's lines and
   before the found list (the dry run prints them too), with the plan's exact sentences; then the run goes on to the
   list and the yes question. **A warning never changes what goes up:** the list is exactly what `site:upload
   --dry-run` prints for that capture (prove it on the three captures of `amend2/three.log` and on two fixture pages
   of your own: one with a 404 picture, one clean). AC6's cited test is renamed as the plan says ("AC6 after the scan
   only a real failure stops the run and every smaller problem is a warning before the list", same file): rename it
   and make it assert the new rule, each stop and each warning kind.
3. **R1-2 (P2) — `--no-shots` (A9):** it stays and works: its missing layer pictures give the one warning line the
   plan names, never a stop; an end-to-end run with the flag against the stand-in exits 0 and writes the same pastes
   as without it.
4. **The small ones the plan says to fix now (A10):** R1-6 (in the lines `site:import` prints from the capture, the
   panel's "press Capture to try again" becomes "run the same command again"; a failed scan ends with the plan's
   line; `npm run capture`'s own lines stay byte for byte), R1-7 (`upload()`'s optional `stopped(inLibrary, total)`
   line for `site:import`; `site:upload` passes none and stays byte for byte), R1-9 (the two test headers name base
   `11e885fd`; AC2's failure message names a leaked form by its kind, never its text). **Recorded follow-ups, not
   yours:** R1-4, R1-8, R1-10 (write them into HANDOFF "Deferred" if they aren't there).
5. Copy the approved plan over `docs/plans/2026-11-10-site-one-command.md` (byte for byte; `cmp`); bring the ledger
   ("Fix pass 1": each finding verified, the rule as built, RED and GREEN, the mutants, the gates) and HANDOFF's
   section in line (what it asks; what stops and what warns; `--no-shots`; Q5 is now Justin's own answer, Q1–Q4 "not
   yet confirmed"; the two lines the reviewer found untrue), and the ledger's CLAUDE.md lines for the merge finisher.

## Mutants (4 GB cap; a refusal-removing one with networking off: `unshare -rn sh -c 'ip link set lo up && exec
unshare --user --map-user=1000 --map-group=1000 node --test …'`), each killed by a cited test on its own assertion
The drop back in line mode; the drop skipped for the owned question; a warning turned into a stop; a stop (the
unstyled range) turned into a warning; a warning that removes a picture from the list; the settle leaving raw mode on.

## Gates before stopping
Both typechecks (`tsconfig.sandbox.json` too); `npm run check` (0 failures; tallies against base `11e885fd` by name;
8G scope for the parallel unit suite); every site-import test file and the existing upload, owned, human-check,
capture-cli, capture-unreachable and capture-not-the-page files (each web file alone under `systemd-run --user
--scope -p MemoryMax=4G -p MemorySwapMax=0`; export variables first; no `--setenv=PATH`); AC11's and AC12's story pins
(`F2B_STORY_PINS=1`, `F2B_BASE_TREE` = a `git archive` of your review base); your own pty probes for the yes question
(the reviewer's nine rows of "Requests before the yes": every one ends as his table says, and the no-Enter row now
ends `Not yes`, exit 2, 0 POST); the password grep of AC2 still clean; `dist/code.js` and `dist/ui.html` byte-identical
to base's build. Each log starts `HEAD=` and ends with one line `EXIT=`. Run `gitleaks` over your evidence folder
from a script file before handing back (a mutant can print the made-up password: redact).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/soc-f1/t1`,
a separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (close every Chrome **you** start: stop it by
the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git
archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command, a heredoc or a shell function is refused in your Bash: write such steps to
a script file with Write and run `bash <file>`; `git -C <absolute path>`). A driver script never sits directly in
`test/fixtures/` (four unit tests import every file there): `test/fixtures/drivers/`. Use `tail -n 3`, never `tail
-3`. Scripts under `~/.cache/site-one-command-fixer1/`; evidence in
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/fixer-1/`. SIGTERM / 143 / 137 or "Killed" may be
earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted
three times this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line; after a restart
check `git status` and `git cat-file -t HEAD`, read your finished logs first.

## Commits
Plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff --cached
--name-only` without CLAUDE.md.

## Report (as text; don't write report files)
`status: ready-for-next-review`, branch, base, last commit (full SHA) and the first fix commit; per finding: verified
or not, the rule as built, the test, RED/GREEN paths; the gate's table (each stop and each warning kind → what is
printed, exit code); the yes table; the mutants and what killed each; gates vs base; deviations from the amended
plan; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never
edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
