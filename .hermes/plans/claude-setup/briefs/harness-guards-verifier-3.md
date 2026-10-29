# Brief: VERIFIER 3, story `harness-guards` (Full pipeline)

## Role
You are the fresh, **read-only verifier** for Justin's setup story `harness-guards`. You never saw the build.
- You re-run the gates, confirm the latest findings are closed, and prove every acceptance criterion (AC) with receipts.
- Change no source, make no commit, start no agents.
- Never write the live `~/.claude`, `~/.hermes/skills`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.
- Write only into your own folder, `~/.hermes/plans/claude-setup/evidence/harness-guards/verifier/`. It is new and empty: an earlier round's folder was moved aside, and you don't need it.

## Skills to load first
- `engineering-best-practices`
- `mutation-testing-discipline`: use it to check that a test exercises every clause of its AC.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. It covers the run recipe, the base-commit check, screenshots, the `ac.json` format and the self-check. Also read the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which defines the exact `ac.json` format.

## What to verify
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Head:** `6b57a5b5ecc89ad42c6a4f02aa7a618564be6e77`.
- **Base:** `git -C <worktree> merge-base HEAD main`, which should be `80ef3a8e6979abe6c2754b06d2acd61850f1ac5d`. Record what it prints.
- **Before you start,** confirm HEAD equals `6b57a5b` and that `git status --porcelain --untracked-files=all` is empty. The repo has `status.showUntrackedFiles=no`. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option.
- **ACs:** AC1–AC22, each with one named test in `.claude/hooks/tests/harness-guards.test.sh`. Run one with `bash .claude/hooks/tests/harness-guards.test.sh <test_name>`; it prints numbered TAP.
  - AC21 and AC22 are `(live)`: `"accepted": false, "not_run": "live: …"`.
  - AC19 is a regression AC. If it rightly passes on base, give it a `base_exempt` reason.

## The work
1. **Gates on head:**
   - `harness-guards.test.sh` offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
   - `ac19_existing_suites_pass`, with `TMPDIR` unset and again with `TMPDIR` under `~/.cache`.
2. **What changed since the last accepted head:**
   - This head is a rebase of the accepted head `e4469c0` onto a newer `main`. `git range-diff e4469c0...6b57a5b` shows every one of the 45 story patches unchanged.
   - `main`'s own commits in between changed `feature-dispatch/SKILL.md` and `leorna/SKILL.md`, which the story also edits.
   - Confirm that both files carry both sides, and that `feature-dispatch/SKILL.md` is under 100,000 characters.
   - Pay attention to AC17 and AC18's doc checks.
3. **No false denies:** run your own replay of the real Bash commands (with recorded cwd) and main-session Edit/Write targets from `~/.claude/projects/**/*.jsonl` through both guards on head. Every deny or ask must be a deliberate rule.
4. **Prove each AC** per `ac-verification.md`:
   - a log of its own test on head (`HEAD=` first line, `EXIT=` last line);
   - the same test on the base commit in a separate detached copy with head's test file, where it must fail (or carry a `base_exempt` reason);
   - one PNG terminal capture per AC;
   - for any clause the test seems not to exercise, a mutation in your own copy.
5. **Write the report** to `verifier/ac.json` in the `ac-check.sh` format. Self-check it blind, as `ac-verification.md` says: `cp` your files to a scratch folder and run `ac-check.sh` on your report and the copy. Then delete the copy.

## Scratch and the desktop
- Keep all scratch in your own `<scratchpad>/harness-guards-verifier3/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so point `TMPDIR`, Chrome profiles and anything large at `~/.cache/harness-guards-verifier3/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
  - Headless Chrome needs `env -u DISPLAY -u WAYLAND_DISPLAY` and `--disable-software-rasterizer`.
  - Never `pkill -f`: use `pgrep -f`, drop shells, then kill the rest. Kill background runs by session id.
  - `$!` after `setsid … &` is setsid's own PID.

## Output (final message)
- `verdict`: `clean` only when every non-live AC is accepted, the gates pass, the rebase changed no story behaviour and the replay shows no false deny or ask. Otherwise `not-clean`.
- `ac_status[{ac, accepted, test, log, base_log or base_exempt, screenshot, evidence}]`, the same as `ac.json`.
- `findings[{id, severity, file_line, scenario, problem, evidence}]`. Every P0–P2 finding must name a concrete real-use scenario; without one, it is P3.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line check proposal.
  - An empty list is normal. Never edit skills or memory.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
