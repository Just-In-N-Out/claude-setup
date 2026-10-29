# Brief: FINISHER (step 1b: final base-only rebase), story `harness-guards`

## Role
You are the **finisher** for Justin's setup story `harness-guards`. You do one final rebase onto local `main` and prove mechanically that it is base-only. Then you run the gates, stop, and report the new HEAD.
- You **don't** merge, push, run the real `sync.sh`, set global git config, or edit the live `~/.claude`/`~/.hermes`.
- **Work fast:** `main` must not move between your rebase and the main session's merge.

## Justin's rule for this merge (decision A, 2026-10-29)
A rebase of the accepted head may merge without another verifier/auditor round **only if all three hold**:
1. **No story patch changed:** `git range-diff 6b57a5b5ecc89ad42c6a4f02aa7a618564be6e77...HEAD` shows every story patch as `=`.
2. **No story file touched by `main`:** `main`'s new commits since the accepted base `80ef3a8e6979abe6c2754b06d2acd61850f1ac5d` touch none of the story's files. The check:
   `comm -12 <(git diff --name-only 80ef3a8 main | sort) <(git diff --name-only 80ef3a8 6b57a5b | sort)` must print nothing.
3. **Every gate passes** on the new head.

If any of the three fails, **stop with `status: needs-reverify`** and say which one failed. Don't fix anything.

## Skills to load first
- `git-commit-rules`
- `engineering-best-practices`

## Steps
1. **Start state:** in `/home/justin/.claude-setup-wt/harness-guards`, HEAD is `6b57a5b`, and `git status --porcelain --untracked-files=all` is empty.
2. **Check 2 first.** If it fails, stop.
3. **Rebase:** `git rebase main`. If it stops on a conflict, abort with `git rebase --abort` and stop with `needs-reverify`.
4. **Check 1** (`range-diff`).
5. **Gates on the new head:**
   - `bash .claude/hooks/tests/harness-guards.test.sh` offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
   - `bash .claude/hooks/tests/harness-guards.test.sh ac19_existing_suites_pass`, with `TMPDIR` unset;
   - authorship: every commit in `main..HEAD` is `Justin <issajustin04@gmail.com>`, with no `Co-authored-by`;
   - `git status --porcelain --untracked-files=all` is clean.
6. **Stop and report.**

## Evidence
`~/.hermes/plans/claude-setup/evidence/harness-guards/finisher-2/`: the check 2 output, `range-diff`, the gate logs, and `main`'s SHA at the end.

## Scratch
- Keep scratch in your own `<scratchpad>/harness-guards-finisher2/` folder (fresh `mkdir`). Remove it by its literal absolute path.
- In the Bash tool, `grep` is ugrep, so use `command grep`. Use `tail -n N`.

## Output
- `status`: `rebased-ready` or `needs-reverify`.
- `new_head`, `new_base` (= `main` at rebase time), `main_at_end`.
- `checks{range_diff_all_equal, main_touches_story_files, gates}`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
