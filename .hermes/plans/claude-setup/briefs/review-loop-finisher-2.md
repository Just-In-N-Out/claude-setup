# Brief: FINISHER (step 1, round 2: rebase onto the moved main and run the gates), story `review-loop`

## Role
You are the **finisher** for Justin's setup story `review-loop`. This brief is **step 1 only**:
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
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Accepted head `aae49fd2c35a3c6d0c3b1e41f95eff46de71bd0f`, base `c40a51cea5dce2ee9b04e1f3064847b78a81559b`.
- **Acceptance:** `ac-check.sh` printed `READY FOR THE USER: 17 of 18 ACs proven on aae49fd` (AC18 is live, owed to Justin), both live and with the worktree's `ac-check.sh --reviews` (REVIEWS CLEAN: review-7).
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Its finisher section describes the later activation steps. Read it for context only and don't do them now.
- **`main` keeps moving.** Other sessions on this desktop sync setup files every few minutes, Since the base `c40a51c` they touched one file this story also edits: `.hermes/skills/software-development/leorna/SKILL.md`.

## Steps
1. **Check the start state:** HEAD is `aae49fd`, and `git status --porcelain --untracked-files=all` is empty.
2. **Look before rebasing:** `git merge-tree main HEAD`, recorded to evidence.
3. **Rebase:** `git rebase main`. Resolve every conflict **keeping both meanings**: main's new content and the story's review-loop rule text. Never drop either side.
   - feature-dispatch `SKILL.md` must stay under 100,000 characters. If it doesn't, fold rather than append, and say what you folded.
4. **Gates on the rebased head:**
   - `bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`, offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
   - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`;
   - feature-dispatch `SKILL.md` under 100,000 characters;
   - every commit in `main..HEAD` is authored by `Justin <issajustin04@gmail.com>`, with no `Co-authored-by` and no AI trailer;
   - `git status --porcelain --untracked-files=all` is clean.
5. **Run the referee read-only and save its last line:** `bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base $(git merge-base HEAD main) ~/.hermes/plans/claude-setup/evidence/review-loop`. Write no records.
6. **Stop** and report.

## Commits
Plain `git commit`, or `git rebase --continue` with the original messages. The identity is `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer.** No author overrides.

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/finisher-2/`:
- `merge-tree` before the rebase;
- each conflict, with both sides kept;
- the gate logs on the new head;
- the `range-diff` of `aae49fd` against the new head.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-finisher2/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so keep large things in `~/.cache/review-loop-finisher2/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep`.
  - Never `pkill -f`.
  - `$!` after `setsid … &` is setsid's own PID.

## Output
- `status`: `rebased-ready`, or `stopped` with the reason.
- `old_head`, `new_base_sha` (`git merge-base HEAD main`), `new_head`.
- `conflicts[{file, resolution}]`.
- `range_diff_summary`: whether any story patch changed beyond conflict resolution, with `git range-diff aae49fd...HEAD` saved to evidence.
- `gates[]`.
- `referee_last_line`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line check proposal.
  - An empty list is normal. Never edit skills or memory.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
