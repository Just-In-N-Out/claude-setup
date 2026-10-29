# Brief: BUILDER, story `review-loop` (Full pipeline)

## Role
You are the **builder** in Justin's Full pipeline (`~/.claude/CLAUDE.md`, "Bugs and Stories"). You build the approved plan test-first in its worktree and stop at `ready-for-review`. You don't:
- review your own work, or start other agents;
- push, merge into `main`, or run the real `~/.claude/setup/sync.sh`;
- write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library` or global git config.

Every change goes into the worktree's copies.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks (`~/.claude/githooks`) check every commit. A deny or a refusal is the rule, not a bug to work around. Probe git behaviour through a script file in a temp `HOME`.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `test-driven-development`: write a failing test before each change.
- `mutation-testing-discipline`: `review-check.sh` and the `--reviews` gate in `ac-check.sh` are acceptance guards. Prove each rule's test can fail, including widening mutants.
- If something fails unexpectedly, use `systematic-debugging`.

## The approved plan
- **Plan:** `~/.hermes/plans/claude-setup/review-loop.md`. The approved read-only copy, which `ac-check.sh` reads, is `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md`. Follow it task by task.
- **Approval:** Justin pre-approved the plan ("make a plan agent and then go for it"; "approve either way"). Every question's recommended ⭐ option applies (Q1 Full … Q11 A). Don't reopen them.
- **ACs:** AC1–AC18. AC18 is `(live)`: build its test so it runs only when named, and don't claim it. AC11 and AC17 also run only when named, as the plan says.
- **Tests:** each AC has exactly one named test in `feature-dispatch/scripts/review-check.test.sh` (numbered TAP). Keep every test name exactly as the plan writes it.

## Where you work
- **Worktree:** create it as the plan says, `git --git-dir=$HOME/.claude-setup.git worktree add ~/.claude-setup-wt/review-loop -b review-loop main`.
  - Record the base SHA (`main` at that moment) in your report.
  - Before the first write, check that `git -C ~/.claude-setup-wt/review-loop rev-parse --show-toplevel` prints the worktree path, not `$HOME`.
- **Commits:** branch `review-loop` only, with plain `git commit -m "…"`. The identity is `Justin <issajustin04@gmail.com>`.
  - **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one; the commit-msg hook refuses it anyway.
  - No author overrides. Never touch `main`, never push.
- **Dirty check:** the repo has `status.showUntrackedFiles=no`, so before reporting check `git status --porcelain --untracked-files=all` and make it clean.
- **Moving `main`:** other sessions' `sync.sh` commits move `main` every few minutes. **Don't rebase**; the finisher does.

## Never touch real state
- Tests use temp repos, `GIT_CONFIG_GLOBAL` and `HOME` overrides, and must not touch real repos or the real global config.
- To delete the memory note (AC15), delete it **in the worktree only**. The live file goes away at the merge.

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/builder/`. For each non-live AC you build:
- the passing run as a log in `ac-verification.md`'s format (first line `HEAD=<sha>`, last line `EXIT=<code>`), named `acN-<testname>.txt`;
- one PNG terminal capture. On this desktop, use headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`;
- for each rule, the run showing its test failing against a mutant.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-builder/` folder. Create it fresh with `mkdir` without `-p`, and remove it by its literal absolute path.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so point `TMPDIR` and anything large at `~/.cache/review-loop-builder/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep`.
  - Coreutils are uutils, so use `tail -n N` and give `touch -d` an offset.
  - Never `pkill -f`. `$!` after `setsid … &` is setsid's own PID.

## Output contract
Stop when every non-live AC's test passes on the committed head, the regression run (AC17) passes, and the tree is clean. Report:
- `status`: `ready-for-review` or `stopped`;
- `worktree`, `branch`, `base_sha`, `head_sha`;
- per AC: test name, pass/fail, and evidence files;
- `found_else`: anything off you noticed but didn't fix;
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line check proposal.
  - An empty list is normal. Never edit skills or memory yourself.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
