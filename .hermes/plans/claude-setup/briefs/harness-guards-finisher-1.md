# Brief: FINISHER (step 1: rebase and gates), story `harness-guards`

## Role
You are the **finisher** for Justin's setup story `harness-guards`. This brief is **step 1 only**:
- commit anything left;
- rebase the branch onto current local `main`;
- resolve conflicts keeping both sides;
- run every gate;
- stop and report the new HEAD.

You **don't** merge into `main`, push, run the real `~/.claude/setup/sync.sh`, set any global git config, or edit the live `~/.claude`/`~/.hermes` files. Those happen after the main session re-verifies the rebased head.

## Skills to load first
- `engineering-best-practices`
- `git-commit-rules`
- If something fails unexpectedly, use `systematic-debugging`.

## State
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. Accepted head `e4469c0fbf1c2df672d74ecf010094f902740ab2`, base `3864d61abe128113f5fd6aeda8a55b02df46377d`.
- **Acceptance:** `ac-check.sh` printed `READY FOR THE USER: 20 of 22 ACs proven on e4469c0` (AC21 and AC22 are live, owed to Justin).
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Its finisher section describes the later activation steps. Read it for context only and don't do them now.
- **`main` keeps moving.** Other sessions on this desktop sync setup files every few minutes, about 30 commits since the base. Their commits touch `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` and `.hermes/skills/software-development/leorna/SKILL.md`, which this story also edits.

## Steps
1. **Check the start state:** HEAD is `e4469c0`, and `git status --porcelain --untracked-files=all` is empty.
2. **Look before rebasing:** `git merge-tree main HEAD`, recorded to evidence.
3. **Rebase:** `git rebase main`. Resolve every conflict **keeping both meanings**: main's new content and the story's (the `enforce`/backlog text, the "URL written out" clause). Never drop either side.
   - feature-dispatch `SKILL.md` must stay under 100,000 characters. If it doesn't, fold rather than append, and say what you folded.
4. **Gates on the rebased head:**
   - `bash .claude/hooks/tests/harness-guards.test.sh`, offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
   - `bash .claude/hooks/tests/harness-guards.test.sh ac19_existing_suites_pass`, with `TMPDIR` unset and with `TMPDIR` under `~/.cache`;
   - every commit in `main..HEAD` is authored by `Justin <issajustin04@gmail.com>`, with no `Co-authored-by` and no staged CLAUDE.md outside the setup repo's allowed files;
   - `git status --porcelain --untracked-files=all` is clean.
5. **Tidy (optional, only these):**
   - leftover failed-run folders under `~/.cache/harness-guards-tests/` from earlier agents (the suite keeps them on failure);
   - empty `/tmp/hg.*` folders older than one hour.
   Don't remove anything else, and never remove a folder another running process is using.
6. **Stop** and report.

## Commits
Plain `git commit`, or `git rebase --continue` with the original messages. The identity is `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer.** No author overrides.

## Evidence
`~/.hermes/plans/claude-setup/evidence/harness-guards/finisher/`:
- `merge-tree` before the rebase;
- each conflict, with both sides kept;
- the gate logs on the new head;
- the `range-diff` of `e4469c0` against the new head.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/harness-guards-finisher/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so keep large things in `~/.cache/harness-guards-finisher/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep`.
  - Never `pkill -f`.
  - `$!` after `setsid … &` is setsid's own PID.

## Output
- `status`: `rebased-ready`, or `stopped` with the reason.
- `old_head`, `new_base_sha` (`git merge-base HEAD main`), `new_head`.
- `conflicts[{file, resolution}]`.
- `range_diff_summary`: whether any story patch changed beyond conflict resolution.
- `gates[]`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line check proposal.
  - An empty list is normal. Never edit skills or memory.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
