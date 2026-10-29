# Brief: FINISHER (step 1b: final update under Justin's decision A), story `review-loop`

## Role
You are the **finisher** for Justin's setup story `review-loop`. You rebase the branch onto current local `main`, prove Justin's three conditions mechanically, run the gates, and report the new HEAD.
- You **don't** merge, push, run the real `sync.sh`, set global git config, or edit the live `~/.claude`/`~/.hermes`.
- **Work fast:** `main` moves every few minutes.

## Justin's decision A (2026-10-29)
Merge after a final update without another full re-check if a script confirms all three of these, even if other chats edited other parts of the same files:
1. **No clashes:** the rebase applies with no conflict. If it stops, run `git rebase --abort` and stop with `needs-reverify`.
2. **The story's own changed lines are identical to the accepted head's.**
   - Accepted head: `aae49fd2c35a3c6d0c3b1e41f95eff46de71bd0f` on base `c40a51cea5dce2ee9b04e1f3064847b78a81559b`, as checked by `ac-check.sh` with READY FOR THE USER 17/18 and REVIEWS CLEAN.
   - **Compare** the `+`/`-` lines of `git diff c40a51c aae49fd` with those of `git diff <new merge-base> HEAD`, per file and in order, ignoring hunk headers and context lines.
   - **The file lists must match**, and every file's `+`/`-` lines must be byte-identical.
   - **Save** both extracts and the comparison.
3. **Every test passes** on the new head:
   - `review-check.test.sh` offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
   - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`;
   - feature-dispatch `SKILL.md` under 100,000 characters;
   - all commits in `main..HEAD` are `Justin <issajustin04@gmail.com>` with no AI trailer;
   - `git status --porcelain --untracked-files=all` is clean.

If any condition fails, stop with `needs-reverify` and say which one.

## Steps
1. **Start state:** in `/home/justin/.claude-setup-wt/review-loop`, HEAD is `25c2f3c5a8ac1c6c37877938faab53f2f6e3bfd9` (review 8 is clean there) and the tree is clean.
2. **Rebase:** `git rebase main`, then check condition 1.
3. **Condition 2.**
4. **Condition 3.**
5. **Check `main` hasn't moved:** run `git merge-base --is-ancestor main HEAD`. If `main` moved during the gates, repeat steps 2–4 **once**.
6. **Stop** and report.

## Skills to load first
- `git-commit-rules`
- `engineering-best-practices`

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/finisher-3/`.

## Scratch
- Keep scratch in your own `<scratchpad>/review-loop-finisher3/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` in `~/.cache/review-loop-finisher3/`.
- In the Bash tool, `grep` is ugrep, so use `command grep`. Use `tail -n N`.
- For long gates, use `run_in_background`, then wait in foreground calls of at most 170 s with `timeout 170 tail --pid=<pid> -f /dev/null`.

## Output
- `status`: `rebased-ready` or `needs-reverify`.
- `new_head`, `new_base`, `main_at_end`.
- `checks{no_conflicts, story_lines_identical, gates}`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
