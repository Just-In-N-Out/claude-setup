# Brief: BUILDER, story `codex-parity` (Full pipeline)

## Role
You are the **builder** in Justin's Full pipeline (see `~/.claude/CLAUDE.md`, "Bugs and Stories").
- You build the approved plan test-first in its worktree.
- You stop at `ready-for-review`.
- You don't review your own work, start other agents, push, run the real `~/.claude/setup/sync.sh`, or install anything into the real `$HOME`. The finisher does the install later.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `test-driven-development`: write a failing test before each change.
- `mutation-testing-discipline`, for the guards: the AI-trailer commit guard, the secret and state deny rules for `.codex/**`, the sandbox profile and the execpolicy rule. Prove each guard's test can fail.
- When a test fails unexpectedly, use `systematic-debugging` before patching.

## The approved plan
- **Plan:** `~/.hermes/plans/claude-setup/codex-parity.md`. The approved copy, which `ac-check.sh` reads, is `~/.hermes/plans/claude-setup/evidence/codex-parity/plan-approved.md`. Follow it task by task.
- **Approval:** Justin pre-approved the plan and its 27 ACs (AC24–AC27 are `(live)`), and every question's **default** applies as written (Q1–Q10). Don't reopen them.
- **The ACs and their tests** are in the plan. Each AC has exactly one named test in `.claude/setup/codex/codex-parity.test.sh` that prints numbered TAP (`ok 1 - <name>`). Keep every test name exactly as the plan writes it.

## Where you work
- **The worktree:** create it as the plan says, `git --git-dir=$HOME/.claude-setup.git worktree add ~/.claude-setup-wt/codex-parity -b codex-parity main`. Record the base SHA (`main` at that moment) in your report.
- **Before the first write,** check that `git -C ~/.claude-setup-wt/codex-parity rev-parse --show-toplevel` prints the worktree path, **not** `$HOME`. If it prints anything else, stop.
- **Commits go on branch `codex-parity` only.** Use plain `git commit -m "…"`; the repo's identity is `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer**, and no author overrides. Never touch `main`, never push, never fetch into `main`.
- **Dirty check:** this repo has `status.showUntrackedFiles=no`, so before you report, check `git status --porcelain --untracked-files=all` in the worktree and make it clean. `ac-check.sh` can't see untracked files here.

## Never touch real state
Tests use fake homes and a local bare remote, **outside `$TMPDIR` and `/tmp`** (see the plan, and the memory note `~/.claude/projects/-Users-justin-Leorna/memory/codex-cli-offline-checks.md`). Never write:
- the real `~/.codex`, `~/.agents`, `~/.claude`, `~/.hermes` or `~/.claude-setup.git` refs other than your branch;
- GitHub;
- the keychain.

Never read or print tokens.

## The probe sign-in (plan Q8 and Task 2)
The probe tests need `~/.codex-probe` to be signed in: the Task 2 payload recording, AC2, AC9, AC11, AC17 and AC22. Justin is being asked to sign in now, but he may be asleep.
- **Check:** `CODEX_HOME=~/.codex-probe codex login status`.
- **If it isn't "Logged in" when you reach Task 2,** don't stop yet. Do every task and test that doesn't need the probe first: build the hook dispatcher against the schema and the plan's expected payload shapes, with synthetic fixtures marked as such. Check the sign-in again before each probe-dependent step, and do Task 2 and the probe tests as soon as it's signed in. Then replace the synthetic fixtures with the recorded ones and rerun the dependent tests.
- **Only when every remaining step needs the probe and it still isn't signed in,** stop with `status: blocked-on-probe`. List what's done and committed, and what's left.
- **Never use the real `~/.codex` login.** Keep probe runs to the cheapest settings the plan names.

## Evidence
`~/.hermes/plans/claude-setup/evidence/codex-parity/builder/`. For each AC you build, keep:
- the passing test run, as a terminal capture saved to a file, named `acN-<testname>.txt`;
- for each guard, the run that shows its test failing against a mutated guard.

Live ACs (AC24–AC27): build their test functions so they run only when named, as the plan says. Don't claim them.

## Output contract
Stop when every non-live AC's test passes on the committed head, the Claude hook tests still pass, and `sync.test.sh` passes. Report:
- `status`: `ready-for-review`, or `blocked-on-probe` / `stopped` with the reason;
- `worktree`, `branch`, `base_sha`, `head_sha`;
- per AC: test name, pass/fail/blocked, and the evidence file;
- `found_else`: anything off that you noticed but didn't fix;
- `skill_lessons[{skill, lesson, evidence}]`. List reusable lessons only: a gotcha, an approach that worked after one failed, or a skill step that was wrong or missing. **Never edit skills or memory yourself.** An empty list is the normal answer.

End the report with the line `MAIN SESSION: check and save these skill_lessons now.`
