# Role: builder (Mini, time-boxed): bdry-demo — a hand-built one-to-one Bricks paste of B-Dry's home page

You are a fresh builder for FigmaToBricksV2 (**Opus 5.5, high** — high rather than xhigh because Justin set a hard time
limit). Build the approved plan, then stop at `ready-for-review`. **Hard time box: 75 minutes from your start** (the
whole job must be done by about 11:50; it is now about 09:32). Follow the plan's stop rule exactly: at minute 75 stop
fixing and report what's left with numbers; never loop past the box.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** in any way (no Chrome, no curl,
no fetch: its bot check), B-Dry staging or any live site; the checks' Chrome reaches only 127.0.0.1 and Google Fonts
(the plan's AC9). No logins; never write to any WordPress site. **Change nothing under `src/`, `dist/`, `tools/` or
`manifest.json`** — this is a demo, not a plugin change. Other agents and Justin run Chrome on this machine: never
stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Skills to load:** `engineering-best-practices`, `git-commit-rules`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/rendering-validation.md`
and `references/testing-pitfalls.md`; the repo `CLAUDE.md` "Working in this repo" Bricks facts; `reference/bricks/*.json`
are the only source of element shapes.

## Inputs
- **Approved plan (read-only):** `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/plan-approved.md`
  (AC1–AC11, all proposed; AC11 live, Justin's). Take every ⭐ answer. The planner's facts:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/planner/facts.md`.
- The start file, the saved page, the captures with the pictures' bytes, `bdry-paste/check.ts`: as the plan names them.
- **Your base:** local `main` `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`. In your own worktree: `git checkout -B
  bdry-demo-build e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`. Scripts and the paste copy go on that branch under
  `test/demo/bdry-home/` (no `.test.` names); commit as you go.

## Work
Follow the plan's tasks in order and its minute budget: the measuring rig first (its first run, `checks/fit-start.log`,
is the real size of the fix work — read it and fix the worst gaps first), pictures re-pointed, the native footer, the
worst gaps, the hand-over set. The paste is made only by `build-demo.ts`, never hand-edited. Each AC's check script
writes a log starting `HEAD=` and ending with one line `EXIT=`.

**Deliverable** (copy the final paste and the hand-over set here, besides the branch):
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/bdry-home-demo.json`, the 7 side-by-side pictures, the
per-section pictures at 1440, `PASTE-STEPS.md` (plain numbered steps, one action each, for B-Dry staging; say which
toggle names are from memory), `gaps.json`, and a one-paragraph `WHAT-STAYS-OUT.md` in plain words for Justin to read
to his manager. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/builder/`.

## Commits
Plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff --cached
--name-only` without CLAUDE.md.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bdb/t1`; a
Chrome profile under a long TMPDIR dies with "Socket path too long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
Close every Chrome **you** start (by the PIDs of its own profile path; never `pkill -f`). A worktree's `node_modules`
may lack `.bin` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH; symlink `node_modules` into a
scratch tree). A piped, chained or redirected git command, a heredoc or a shell function may be refused: write such
steps to a script file and run `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Shoot each page alone (a
page not in front stalls). Heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export
variables first; no `--setenv=PATH`). SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min"
-o short-iso | grep -E 'sending SIG[A-Z]* to process'`). Waits under 115 s. Send one final report; no interim
hand-backs.

## Report (as text)
`status: ready-for-review`, branch, last commit (full SHA), the minutes used, per AC: the check, its log, pass or the
numbers; `gaps.json`'s leftovers in plain words; the deliverable paths; what stays out; `found_else`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
