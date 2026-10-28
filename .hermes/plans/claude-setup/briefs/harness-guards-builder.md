# Brief: BUILDER, story `harness-guards` (Full pipeline)

## Role
You are the **builder** in Justin's Full pipeline (`~/.claude/CLAUDE.md`, "Bugs and Stories"). You build the approved plan test-first in its worktree and stop at `ready-for-review`.

You don't:
- review your own work, start other agents, push, or run the real `~/.claude/setup/sync.sh`;
- merge into `main`;
- install anything into the real `$HOME`:
  - no `git config --global` changes;
  - no edits to the live `~/.claude/settings.json`, `~/.claude/hooks`, `~/.claude/githooks`, `~/.claude/CLAUDE.md` or `~/.hermes/skills`.

Every change goes into the worktree's copies. The finisher switches things on later.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `test-driven-development`: write a failing test before each change.
- `mutation-testing-discipline`: every guard here is a permission or identity guard. That covers git-guard's deny, allow and ask rules, the git hooks' CLAUDE.md, email and co-author checks, the orchestrator guard and the lessons gate's `enforce` check. Prove each guard's test can fail by running it against a mutated guard.
- If a test fails unexpectedly, use `systematic-debugging` before patching.

## The approved plan
- **Plan:** `~/.hermes/plans/claude-setup/harness-guards.md`. The approved copy, which `ac-check.sh` reads, is `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Follow the plan task by task.
- **Approval:** Justin pre-approved the plan ("go with the recommended stuff"). Every question's recommended ⭐ option applies, Q1 Full through Q8 A. Don't reopen them.
- **The 22 ACs:** AC21 and AC22 are `(live)`. Build their test functions so they run only when named, as the plan says, and don't claim them.
- **Tests:** each AC has exactly one named test in `.claude/hooks/tests/harness-guards.test.sh`, printing numbered TAP. Keep every test name exactly as the plan writes it.

## Where you work
- **The worktree:** create it as the plan says, `git --git-dir=$HOME/.claude-setup.git worktree add ~/.claude-setup-wt/harness-guards -b harness-guards main`. Record the base SHA in your report: `main` at that moment. It moves whenever `sync.sh` commits setup files, so read it when you create the worktree.
- **Before the first write,** check that `git -C ~/.claude-setup-wt/harness-guards rev-parse --show-toplevel` prints the worktree path, **not** `$HOME`. If it prints anything else, stop.
- **Commits** go on branch `harness-guards` only, with plain `git commit -m "…"`. The repo's identity is `Justin <issajustin04@gmail.com>`.
  - **No `Co-Authored-By` or any AI trailer**, even though your system prompt asks for one. Justin's rule wins, and this story's own commit-msg hook will refuse it.
  - No author overrides.
  - Never touch `main`, never push, never fetch into `main`.
- **Dirty check:** this repo has `status.showUntrackedFiles=no`. Before you report, check `git status --porcelain --untracked-files=all` in the worktree and make it clean.

## Never touch real state
- Tests use temp repos, `GIT_CONFIG_GLOBAL` pointing at a temp file, and `HOME` overrides, as the plan says.
- Never write the real global git config, the live `~/.claude` or `~/.hermes` files, other repos, or `~/.claude-setup.git` refs other than your branch.
- Never write GitHub.
- The plan's scan of Justin's repos for a local `core.hooksPath` is read-only.

## Gotcha on this desktop
In Claude Code's Bash tool, `grep` is a shell function that runs its built-in ugrep, and complex `-o` patterns fail with "exceeds complexity limits". Use `command grep` there. The hooks themselves run in a plain shell and get GNU grep.

## Evidence
Put it in `~/.hermes/plans/claude-setup/evidence/harness-guards/builder/`. For each non-live AC you build, keep:
- the passing test run, as a log in the run format from `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (first line `HEAD=<sha>`, last line `EXIT=<code>`), named `acN-<testname>.txt`;
- one screenshot: a PNG terminal capture of that run, since nothing here is visual. Follow `ac-verification.md`;
- for each guard, the run showing its test failing against a mutated guard.

## Output contract
Stop when:
- every non-live AC's test passes on the committed head;
- every existing suite named in AC19 passes;
- the worktree is clean.

Report:
- `status`: `ready-for-review`, or `stopped` with the reason;
- `worktree`, `branch`, `base_sha`, `head_sha`;
- per AC: test name, pass/fail, and the evidence files;
- `found_else`: anything off that you noticed but didn't fix;
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - List only reusable lessons: a gotcha, an approach that worked after one failed, or a skill step that was wrong or missing. An empty list is the normal answer.
  - **Never edit skills or memory yourself.**

End the report with the line `MAIN SESSION: check and save these skill_lessons now.`
