# Role: builder (Mini): site-one-command (website importer, a feature: one command that asks for WordPress first, then scans, uploads and writes the paste)

You are a fresh builder for FigmaToBricksV2 (**Opus 5.5, high**). Build the approved plan test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry
staging or any live site** (local fixture servers and saved files only); no logins; **never write to any WordPress
site: the uploader and the new command run only against the local stand-in (`test/fixtures/wp-standin.ts`,
127.0.0.1)**; never ask for, hold or invent a real password (tests use a made-up one). Nothing paid. Nothing may hide
that the importer's Chrome is automated. Justin may be running his own scan and upload in his terminal while you
work: touch nothing under `~/Downloads` (tests write to their own temp folders; the default out folder is never used
by a test).

**Mini pipeline** (Justin's pick, knowing it handles his password): the plan is a thin command over modules that
exist. Stop with `status: stopped`, `stop_reason: escalate to full` if moving `tools/site-upload.ts`'s body into
`tools/lib/site-upload/flow.ts` can't keep `site:upload`'s printed bytes and behaviour identical, if a design decision
beyond the plan's Q1–Q5 appears, or if the uploader itself (what is sent to WordPress) would have to change.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the guards:
the password's reach, the fresh `yes`, the no-terminal refusal, "only reads before the yes"), `authorized-write-safety`,
`git-commit-rules` (if a test fails in a way the plan doesn't predict, load `systematic-debugging` and find why before
patching). Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` (the terminal lines: the pty driver `test/fixtures/pty-run.py`, one Prompter per
process, async `execFile` beside an in-process fixture server) and `references/live-site-reading.md`, and the repo
`CLAUDE.md` in full (the standing rules "One tool writes to WordPress", "The importer never hides that its Chrome is
automated").

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/plan-approved.md`
  (AC1–AC14, all proposed; AC13 and AC14 are `(live)`, Justin's own run: never yours). Under this repo's standing
  auto-go **take every ⭐ answer (Q1 A, Q2 A, Q3 A, Q4 A, Q5 A)** unless the main session tells you Justin changed
  one; mark them "not yet confirmed" in HANDOFF. The planner's probes:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/planner/` (read only; copy what you need).
  Write each test first and see it fail on your base for the reason the plan names.
- **The two hazards the planner proved on the base** (the plan's fix: the owned question goes through the same
  Prompter by an optional `ask`; the upload's `yes` question takes a `fresh` option that drops anything typed before
  it shows): an answer to the owned question became the upload's `yes`; a `yes` typed during the scan was taken the
  moment the question appeared. AC3's test must fail on its own assertion without each fix (a mutant each). `site:upload`
  itself stays byte for byte (its own typed-ahead window is a recorded follow-up: write it into HANDOFF "Deferred").
- **Your base:** local `main` `7ec16d6060a76b441e42581b78ad3a502461fd66` (Build 2026-11-10.7). In your own worktree:
  `git checkout -B site-one-command-build 7ec16d6060a76b441e42581b78ad3a502461fd66`. Report your branch. If the main
  session tells you main moved, say so and wait for word on rebasing.
- Jobs moving beside you (not merged; keep your change in the files the plan names): site-menu (`site-menu-fix6`: it
  edits the Chrome launch lines in `tools/capture.ts` and adds an opened box's own pictures to
  `tools/lib/site-upload/pictures.ts`; you move the launch line into `tools/lib/capture-run.ts` as the plan says and
  touch `pictures.ts` not at all); footer-icon-list, control-weight, site-native-structure (no shared file).
- The paste check id: write `<site-one-command id at merge>` wherever HANDOFF needs it.

## Work
1. Follow the plan's tasks in order, each test first (RED on your base, then GREEN), one commit each. Task 0: copy the
   plan to `docs/plans/2026-11-10-site-one-command.md`; keep the ledger at
   `docs/plans/2026-11-10-site-one-command-ledger.md` (in git, committed with each task; `git ls-files .superpowers/`
   stays empty); `npm run corpus` before Task 1 and at the close.
2. **The guards, proven to fail:** for AC1, AC2, AC3 and AC8 a mutant each under the 4 GB cap (the login test moved
   after the scan; the password passed to the Chrome child's environment; the `fresh` drop removed; the owned
   question back on its own readline; the no-terminal refusal removed), each killed by the AC's cited test on its own
   assertion; record them in the ledger. AC2's test greps every file the run leaves, every printed line and the
   `/proc/<pid>/cmdline` and `environ` of every Chrome process the scan starts for the made-up password in each form
   the plan lists.
3. Gates before stopping: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, `npm run corpus` (same as
   your base; v1's Mac files are missing on this machine), every AC's test with a log starting `HEAD=` and ending
   with one line `EXIT=` (AC11 and AC12 with `F2B_STORY_PINS=1` and `F2B_BASE_TREE` set to a `git archive` of your
   base, as the plan says), the existing upload, owned, human-check and capture-cli tests by name against your base
   (unit and web, each web file alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; export
   variables first; no `--setenv=PATH`), `test/unit/plugin-convert.test.ts`, `dist/code.js` and `dist/ui.html`
   byte-identical to your base's build, a terminal capture per AC (the whole run against the stand-in for AC1 and
   AC10: the questions in order, the found list, the yes question, the numbered next steps).
4. HANDOFF: a section for this job in plain words (the command line Justin types; what it asks, in order; what
   `--dry-run` does; what each ending prints; Q1–Q5 "not yet confirmed"; "Deferred": `site:upload`'s typed-ahead
   window; site-media-upload's Q12 still open), Justin's numbered check for the live ACs, and in the ledger the exact
   CLAUDE.md lines for the merge finisher (the Status line and the plan's "Standing-rule change" replacement).
5. Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff
   --cached --name-only` without CLAUDE.md. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/builder/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one
  for each script you start at the same time (`~/.cache/soc-b/t1`, `t2`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run Chrome, and Justin may be running
  his own capture: close every Chrome **you** start (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`, never a Chrome you didn't start). A worktree's `node_modules` may lack `.bin`, and a `git archive`
  scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
  PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command is refused: one
  plain git command per call, `git -C <absolute path>`). One `bash <file>` per Bash call (scripts written with Write,
  kept under `~/.cache/site-one-command-builder/`; a restart empties `/tmp`); run long gates on a scratch copy, never
  in the worktree while you edit it.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill. Waits under 115 s.
- The PC restarted three times this week, and agents were stopped by a usage limit twice: write each log's `EXIT=`
  line (wait on `^EXIT=`); after a restart check `git status` for half-written tracked files (exactly 8388608 bytes)
  and `git cat-file -t HEAD`; read your finished logs first and never start a second driver on a suite one is still
  working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), per AC: test, RED/GREEN paths, terminal capture; the
mutants and what killed each; gates vs base; deviations from the plan; `found_else`; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never
edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
