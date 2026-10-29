# Brief: VERIFIER 1, story `review-loop` (Full pipeline)

## Role
You are the fresh, **read-only verifier** for Justin's setup story `review-loop`. You never saw the build.
- You re-run the gates, confirm the latest findings are closed, and prove every acceptance criterion (AC) with receipts.
- Change no source, make no commit, start no agents.
- Never write the live `~/.claude`, `~/.hermes/skills`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.
- Write only into your own folder, `~/.hermes/plans/claude-setup/evidence/review-loop/verifier/`. It is new and empty.

## Skills to load first
- `engineering-best-practices`
- `mutation-testing-discipline`: use it to check that a test exercises every clause of its AC.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. It covers the run recipe, the base-commit check, screenshots, the `ac.json` format and the self-check. Also read the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which defines the exact `ac.json` format.

## What to verify
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Head:** `aba309358277f1845febe2c23f87db27665bfbe6`.
- **Base:** `git -C <worktree> merge-base HEAD main`, which should be `691651c1e942896f42f4e64ed547a1a2a121ef3c`. Record what it prints.
- **Before you start,** confirm HEAD equals `aba3093` and that `git status --porcelain --untracked-files=all` is empty. The repo has `status.showUntrackedFiles=no`. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option.
- **The plan was amended twice** (AC text reconciled with fixes made from review findings). Read its Amendments list. The read-only `plan-approved.md` is the amended one.
- **ACs:** AC1–AC18, each with one named test in `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`. Run one with `bash <that file> <test_name>`; it prints numbered TAP.
  - AC18 is `(live)`: `"accepted": false, "not_run": "live: …"`.
  - AC11 and AC17 run only when named. AC17 is a regression AC; if it rightly passes on base, give it a `base_exempt` reason.

## The work
1. **Gates on head:**
   - `review-check.test.sh` offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
   - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`;
   - the same offline suite and `ac-check.test.sh` under real bash 3.2.57, in the local Docker image `review-loop-r2-bash32:local` (bash at `/usr/local/bin/bash`).
2. **The review loop closed:** run the worktree's referee on the story's records and confirm the last line is `MOVE ON` at `aba3093`:
   `bash /home/justin/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/.claude-setup-wt/review-loop --base <base> ~/.hermes/plans/claude-setup/evidence/review-loop`
3. **Prove each AC** per `ac-verification.md`:
   - a log of its own test on head (`HEAD=` first line, `EXIT=` last line);
   - the same test on the base commit in a separate detached copy with head's test file, where it must fail (or carry a `base_exempt` reason);
   - one PNG terminal capture per AC;
   - for any clause the test seems not to exercise, a mutation in your own copy.
4. **Write the report** to `verifier/ac.json` in the `ac-check.sh` format. Self-check it blind, as `ac-verification.md` says: `cp` your files to a scratch folder and run `ac-check.sh` on your report and the copy. Then delete the copy.

## Scratch and the desktop
- Keep all scratch in your own `<scratchpad>/review-loop-verifier1/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so point `TMPDIR`, Chrome profiles and anything large at `~/.cache/review-loop-verifier1/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
  - Headless Chrome needs `env -u DISPLAY -u WAYLAND_DISPLAY` and `--disable-software-rasterizer`.
  - Never `pkill -f`: use `pgrep -f`, drop shells, then kill the rest. Kill background runs by session id.
  - `$!` after `setsid … &` is setsid's own PID.

## Output (final message)
- `verdict`: `clean` only when every non-live AC is accepted, the gates pass and the referee says MOVE ON at head. Otherwise `not-clean`.
- `ac_status[{ac, accepted, test, log, base_log or base_exempt, screenshot, evidence}]`, the same as `ac.json`.
- `findings[{id, severity, file_line, scenario, problem, evidence}]`. Every P0–P2 finding must name a concrete real-use scenario; without one, it is P3.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line check proposal.
  - An empty list is normal. Never edit skills or memory.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
