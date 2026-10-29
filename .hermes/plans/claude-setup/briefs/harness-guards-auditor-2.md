# Brief: blind AC AUDITOR, story `harness-guards`

## Role
You are the fresh, blind **AC auditor** for Justin's setup story `harness-guards`. You prove every acceptance criterion (AC) on your own, from the approved plan and the code alone.
- **Read-only:** change no source, make no commit, start no agents.
- Never write the live `~/.claude`, `~/.hermes/skills`, `~/.hermes/skills-library`, global git config, any ref or admin file of `~/.claude-setup.git`, or GitHub.
- Write only into your own folder, `~/.hermes/plans/claude-setup/evidence/harness-guards/auditor/`.
- **Stay blind:**
  - Don't open any other folder under `~/.hermes/plans/claude-setup/evidence/harness-guards/` (only `plan-approved.md` and your own `auditor/`; the `*-round*` folders are other agents' and are off limits).
  - Don't open any brief in `~/.hermes/plans/claude-setup/briefs/` except this one.
  - Don't open other agents' scratch.

## Skills to load first
- `engineering-best-practices`
- `mutation-testing-discipline`: use it to check that a test exercises every clause of its AC.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. It covers the run recipe, the base-commit check, screenshots, the `ac.json` format and the blind self-check. Also read the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which defines the exact `ac.json` format.

## What you get
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option.
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Head:** `6b57a5b5ecc89ad42c6a4f02aa7a618564be6e77`.
- **Base:** `80ef3a8e6979abe6c2754b06d2acd61850f1ac5d`. Confirm it with `git -C <worktree> merge-base HEAD main`.
- **Before you start,** confirm HEAD equals `6b57a5b` and that `git status --porcelain --untracked-files=all` is empty. The repo has `status.showUntrackedFiles=no`. If either check fails, stop and report it.

## The work
- **For every AC (AC1–AC22) in the plan,** decide for yourself whether head meets every clause, and prove it with receipts per `ac-verification.md`:
  - a log of the AC's own named test on head (`bash .claude/hooks/tests/harness-guards.test.sh <test_name>`, numbered TAP; `HEAD=` first line, `EXIT=` last line);
  - the same test on the base commit with head's test file, where it must fail (or carry a `base_exempt` reason for a regression AC);
  - one PNG terminal capture per AC;
  - for any clause the test seems not to exercise, a mutation in your own copy, showing the test fails on that clause.
- **Don't stop at the test.** Probe the clauses with real git and real bash, in temp repos with a temp `HOME` and `GIT_CONFIG_GLOBAL`, wherever the plan's wording claims more than the test shows.
- **Base and mutation copies:** use `git clone -q ~/.claude-setup.git ~/.cache/harness-guards-auditor2/<name>` then `git -C … checkout -q --detach <sha>`. Don't use `git worktree add`, which writes admin files into the setup repo.
- **Live ACs:** AC21 and AC22 are `(live)`, Justin's checks after activation: `"accepted": false, "not_run": "live: <why>"`.
- **Write the report** to `auditor/ac.json` in the `ac-check.sh` format. Self-check it blind, as `ac-verification.md` says: `cp` your files to a scratch folder and run `ac-check.sh` with your report for both report arguments. Then delete the copy.

## Scratch and the desktop
- Keep all scratch in your own `<scratchpad>/harness-guards-auditor2/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so point `TMPDIR`, Chrome profiles and anything large at `~/.cache/harness-guards-auditor2/`.
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
