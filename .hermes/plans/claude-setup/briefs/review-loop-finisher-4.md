# Brief: FINISHER (final rounds and merge under Justin's decision A), story `review-loop`

## Role
You are the **finisher** for Justin's setup story `review-loop`.
- You repeat finisher 3's round (rebase onto current local `main`, Justin's three decision-A conditions, gates) until one round finishes with `main` unchanged.
- Then you **immediately** fast-forward `main` yourself. That removes the gap between your report and the merge.
- You don't push, run the real `sync.sh`, set global git config, or edit any other live file.

## Why
Other sessions commit to the setup repo's `main` every 1–6 minutes, and one round takes about 6 minutes. Finisher 3's round 2 passed all three conditions on `a489a1e`, but `main` moved during its gates.

## Justin's decision A (2026-10-29)
Merge without another full re-check when a script confirms all three, even if other chats edited other parts of the same files:
1. no clashes;
2. the story's own `+`/`-` lines are byte-identical to the accepted head `aae49fd2c35a3c6d0c3b1e41f95eff46de71bd0f` (against base `c40a51cea5dce2ee9b04e1f3064847b78a81559b`);
3. every gate passes.

## Steps
1. **Read finisher 3's work:** `~/.hermes/plans/claude-setup/evidence/review-loop/finisher-3/`, especially `round.sh`, `extract.awk`, `gates.sh` and `condition2-comparison.txt`. Reuse `round.sh`, fixing it only if needed.
2. **Start state:** worktree `/home/justin/.claude-setup-wt/review-loop` at `a489a1ead247fe5d0c9b9b5e9a4213bdb0af389f`, clean.
3. **Loop,** up to 8 rounds or 60 minutes:
   - (a) record `M0 = $(git --git-dir=$HOME/.claude-setup.git rev-parse main)`;
   - (b) `git rebase main` in the worktree. On a conflict, run `git rebase --abort` and stop with `needs-reverify`;
   - (c) condition 2. If it fails, stop with `needs-reverify`;
   - (d) the gates (condition 3). If a gate fails, stop with `needs-reverify`;
   - (e) if `git --git-dir=$HOME/.claude-setup.git rev-parse main` still equals `M0`, **merge at once:**
     `git --git-dir=$HOME/.claude-setup.git --work-tree=$HOME merge --ff-only review-loop`
     - If it refuses because `main` moved in that instant, go back to (a).
     - If it refuses because of uncommitted changes in `$HOME`, stop and report the files word for word. **Never** stash, commit or discard anyone's changes, and never force.
   - (f) if `main` moved, go back to (a).
4. **After a successful merge:**
   - confirm `git --git-dir=$HOME/.claude-setup.git log --oneline -1 main` is the story head;
   - confirm `~/.claude/projects/-home-justin/memory/review-loop-until-clean.md` is gone, and `MEMORY.md` no longer lists it;
   - confirm the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh` exists.
   - **Don't** run `sync.sh`; the main session does.
5. **Report.**

## Skills to load first
- `git-commit-rules`
- `engineering-best-practices`

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/finisher-4/`: one subfolder per round, plus the merge output.

## Scratch
- Keep scratch in your own `<scratchpad>/review-loop-finisher4/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` in `~/.cache/review-loop-finisher4/`.
- In the Bash tool, `grep` is ugrep, so use `command grep`. Use `tail -n N`.
- Run each round in the background, then wait in foreground calls of at most 170 s with `timeout 170 tail --pid=<pid> -f /dev/null`.

## Output
- `status`: `merged`, `no-quiet-window` or `needs-reverify` (with the reason).
- `rounds[{n, base, head, cond1, cond2, gates, main_moved}]`.
- `merged_head`, `main_after`.
- `after_merge_checks`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
