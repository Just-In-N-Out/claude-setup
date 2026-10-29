# Brief: blind AC AUDITOR, story `review-loop`

## Role
You are the fresh, blind **AC auditor** for Justin's setup story `review-loop`. You prove every acceptance criterion (AC) on your own, from the approved plan and the code alone.
- **Read-only:** change no source, make no commit, start no agents.
- Never write the live `~/.claude`, `~/.hermes/skills`, `~/.hermes/skills-library`, global git config, any ref or admin file of `~/.claude-setup.git`, or GitHub.
- Write only into your own folder, `~/.hermes/plans/claude-setup/evidence/review-loop/auditor/`.
- **Stay blind:**
  - Don't open any other folder under `~/.hermes/plans/claude-setup/evidence/review-loop/` (only `plan-approved.md` and your own `auditor/`; every other file and folder there is other agents' and off limits, including `plan-approved-v0-at-go.md`).
  - Don't open any brief in `~/.hermes/plans/claude-setup/briefs/` except this one.
  - Don't open other agents' scratch.

## Skills to load first
- `engineering-best-practices`
- `mutation-testing-discipline`: use it to check that a test exercises every clause of its AC.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. It covers the run recipe, the base-commit check, screenshots, the `ac.json` format and the blind self-check. Also read the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which defines the exact `ac.json` format.

## What you get
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option. It carries two amendments, listed at its top; the amended text is what you prove.
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Head:** `aba309358277f1845febe2c23f87db27665bfbe6`.
- **Base:** `691651c1e942896f42f4e64ed547a1a2a121ef3c`. Confirm it with `git -C <worktree> merge-base HEAD main`.
- **Before you start,** confirm HEAD equals `aba3093` and that `git status --porcelain --untracked-files=all` is empty. The repo has `status.showUntrackedFiles=no`. If either check fails, stop and report it.

## The work
- **For every AC (AC1–AC18) in the plan,** decide for yourself whether head meets every clause, and prove it with receipts per `ac-verification.md`:
  - a log of the AC's own named test on head (`bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh <test_name>`, numbered TAP; `HEAD=` first line, `EXIT=` last line);
  - the same test on the base commit with head's test file, where it must fail (or carry a `base_exempt` reason for a regression AC);
  - one PNG terminal capture per AC;
  - for any clause the test seems not to exercise, a mutation in your own copy, showing the test fails on that clause.
- **Don't stop at the test.** Probe the clauses with real git, real bash and hand-made review records in a temp folder, wherever the plan's wording claims more than the test shows.
- **Base and mutation copies:** use `git clone -q ~/.claude-setup.git ~/.cache/review-loop-auditor1/<name>` then `git -C … checkout -q --detach <sha>`. Don't use `git worktree add`, which writes admin files into the setup repo.
- **Live ACs:** AC18 is `(live)`, Justin's check on the Mac: `"accepted": false, "not_run": "live: <why>"`. AC11 and AC17 run only when named. Real bash 3.2.57 is in the local Docker image `review-loop-r2-bash32:local` (bash at `/usr/local/bin/bash`), if you want it for AC16.
- **Write the report** to `auditor/ac.json` in the `ac-check.sh` format. Self-check it blind, as `ac-verification.md` says: `cp` your files to a scratch folder and run `ac-check.sh` with your report for both report arguments. Then delete the copy.

## Scratch and the desktop
- Keep all scratch in your own `<scratchpad>/review-loop-auditor1/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so point `TMPDIR`, Chrome profiles and anything large at `~/.cache/review-loop-auditor1/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
  - Headless Chrome needs `env -u DISPLAY -u WAYLAND_DISPLAY` and `--disable-software-rasterizer`.
  - Never `pkill -f`: use `pgrep -f`, drop shells, then kill the rest. Kill background runs by session id.
  - `$!` after `setsid … &` is setsid's own PID.

## Output (final message)
- `verdict`: `clean` when every non-live AC is accepted; otherwise `not-clean`.
- `ac_status[{ac, accepted, test, log, base_log or base_exempt, screenshot, evidence}]`, the same as `ac.json`.
- `findings[{id, severity, file_line, scenario, problem, evidence}]`. Every P0–P2 finding must name a concrete real-use scenario; without one, it is P3.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line check proposal.
  - An empty list is normal. Never edit skills or memory.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
