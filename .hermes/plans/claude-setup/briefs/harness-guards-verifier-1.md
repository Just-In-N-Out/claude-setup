# Brief: VERIFIER 1, story `harness-guards` (Full pipeline)

## Role
You are the fresh, **read-only verifier** for Justin's setup story `harness-guards`. You never saw the build.
- You re-run the gates, confirm both review rounds' findings are closed, and prove every acceptance criterion (AC) with receipts.
- Change no source, make no commit, start no agents.
- Never write the live `~/.claude`, `~/.hermes/skills`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.
- Write only into your own folder, `~/.hermes/plans/claude-setup/evidence/harness-guards/verifier/`.

## Skills to load first
- `engineering-best-practices`
- `mutation-testing-discipline`: use it to check that a test exercises every clause of its AC.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. It covers the run recipe, the base-commit check, screenshots, the `ac.json` format and the self-check. Also read the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which defines the exact `ac.json` format.

## What to verify
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Head:** `dccc042b4ccbc28e758439140d10b38976ef7e8c`.
- **Base:** `3f8c53ce389590e6f92c2dab46ed001618436869`, which equals `git -C <worktree> merge-base HEAD main`.
- **Before you start,** confirm HEAD equals `dccc042` and that `git status --porcelain --untracked-files=all` is empty. The repo has `status.showUntrackedFiles=no`, so `ac-check.sh` can't see untracked files. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option.
- **ACs:** AC1–AC22, each with one named test in `.claude/hooks/tests/harness-guards.test.sh`. Run one with `bash .claude/hooks/tests/harness-guards.test.sh <test_name>`; it prints numbered TAP, `ok 1 - <name>`.
  - AC21 and AC22 are `(live)`, Justin's checks after activation: `"accepted": false, "not_run": "live: …"`.
  - AC19 (existing suites still pass) is a regression AC. If its test rightly passes on base too, give it a `base_exempt` reason.

## The work
1. **Gates on head:**
   - `harness-guards.test.sh` offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
   - `ac19_existing_suites_pass`.
2. **Findings closed:** check that both review rounds' findings are closed on head, by reproducing each one's original probe:
   - review 1: F1–F12 (`evidence/harness-guards/review-1/`, especially `probe-bypass-forms.txt`, `repro-githooks.sh`, `repro-orchestrator-skills-library.txt`);
   - review 2: F1–F8 (`review-2/bypass-repro.log`, `review-2/githooks-probe.log`).
   You may read those review folders to get the probes. Don't treat any earlier folder (`builder/`, `fix-1/`, `fix-2/`) as proof.
3. **No false denies:** run your own replay of the real Bash commands (with recorded cwd) and main-session Edit/Write targets from `~/.claude/projects/**/*.jsonl` through both guards on head. Every deny or ask must be a deliberate rule.
4. **Prove each AC** per `ac-verification.md`:
   - a log of its own test on head (`HEAD=` first line, `EXIT=` last line);
   - the same test on the base commit in a separate detached copy with head's test file, where it must fail (or carry a `base_exempt` reason);
   - one PNG terminal capture per AC;
   - for any clause the test seems not to exercise, a mutation in your own copy, showing the test fails on the line for that clause.
5. **Write the report** to `verifier/ac.json` in the `ac-check.sh` format. Self-check it blind, as `ac-verification.md` says: `cp` your files to a scratch folder and run `ac-check.sh` on your report and the copy. Then delete the copy.

## Scratch and the desktop
- Keep all scratch in your own `<scratchpad>/harness-guards-verifier/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- The WSL desktop's `/tmp` is a shared 7.9 GB RAM tmpfs. Point `TMPDIR`, Chrome profiles and anything large at `~/.cache/harness-guards-verifier/`.
- **Gotchas:**
  - In Claude Code's Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
  - Headless Chrome needs `env -u DISPLAY -u WAYLAND_DISPLAY` and `--disable-software-rasterizer` (see `ac-verification.md`).
  - Never `pkill -f`: list PIDs with `pgrep -f`, drop shells, then kill the rest.
  - A `setsid` background run can outlive its "completed" notice, so wait on its PID.

## Output (final message)
- `verdict`: `clean` only when every non-live AC is accepted, the gates pass, every earlier finding is closed and the replay shows no false deny or ask. Otherwise `not-clean`.
- `ac_status[{ac, accepted, test, log, base_log or base_exempt, screenshot, evidence}]`, the same as `ac.json`.
- `findings[{id, severity, file_line, problem, evidence}]`, for anything not closed or newly broken.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - An empty list is the normal answer. Never edit skills or memory yourself.

If you list any lessons, end with the line `MAIN SESSION: check and save these skill_lessons now.`
