# Brief: FIXER 3, story `harness-guards` (Full pipeline)

## Role
You are **fixer 3** for Justin's setup story `harness-guards`. You do three things in the story's worktree, then stop at `ready-for-verify`:
1. close the verifier's one finding, test-first;
2. rebase onto current local `main`;
3. make one small docs fix.

A fresh verifier, then a blind auditor, check the result.

You don't:
- start other agents, push, merge into `main`, or run the real `~/.claude/setup/sync.sh`;
- install anything into the real `$HOME`: no `git config --global` changes, and no edits to the live `~/.claude`, `~/.hermes` or `~/.hermes/skills-library`.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `receiving-code-review`: verify the finding before fixing it.
- `test-driven-development`
- `mutation-testing-discipline`
- `git-commit-rules`, for the rebase.
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. Head `dccc042b4ccbc28e758439140d10b38976ef7e8c`; the story's base so far is `3f8c53ce389590e6f92c2dab46ed001618436869`.
- **Before you start,** confirm HEAD is `dccc042` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Don't change, add or rename ACs or test names.
- **Commits:** plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one. No author overrides.

## 1. The verifier's finding V1 (P2, test gap; head's code is right)
- **Where:** `.claude/hooks/tests/harness-guards.test.sh`, `ac11_githooks_chain_repo_hooks`, against `.claude/githooks/githook.sh:90-101`.
- **The gap:** AC11 says a repo's own hook "runs after the checks". But no fixture has an own hook that passes while a check must refuse. So mutant M11h, which moves the `exec "$own" "$@"` hand-over ahead of the checks, passes AC11 and the whole offline suite (`evidence/harness-guards/verifier/mutations/M11h*.log`).
- **Fix:** in AC11, install own `pre-commit` and `commit-msg` hooks that exit 0 and log that they ran. Then assert:
  - a wrong-email commit is refused by `githooks (pre-commit)`, and the own hook did not run;
  - an AI-trailer commit is refused by `githooks (commit-msg)`.
- **Proof:** show the RED by applying M11h to a copy (the new assertions fail), then GREEN on the real code. M11h must now be killed.

## 2. Rebase onto current local `main`
- Local `main` of `~/.claude-setup.git` has moved past `3f8c53c`. Run `git merge-tree main HEAD` first to see the conflicts.
- The verifier found a content conflict in `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`: main edited the lesson line (about line 255) that this story rewrites. `leorna/SKILL.md` was also edited on main.
- Run `git rebase main` in the worktree. **Resolve every conflict keeping both meanings:** main's new content and this story's `enforce`/backlog change. Never drop either side.
- feature-dispatch `SKILL.md` must stay under 100,000 characters; main's copy is about 96,559. If it gets too long, fold rather than append.
- **After the rebase:**
  - record the new base: `git merge-base HEAD main`, which should equal `main`'s tip at that moment;
  - re-run every gate in "Done means".

## 3. Small docs fix (from the verifier's found_else)
- **Why:** git-guard can't resolve shell variables, so a real Leorna fallback push written as `U=https://github.com/LeornaAI/…; git … push $U …` is now denied. It must be written with the URL spelled out.
- **What:** in the worktree's `.claude/CLAUDE.md`, in the Leorna push sentence that gives the HTTPS fallback, add a few words saying the URL must be written out literally, because git-guard denies a variable there. Keep it to one short clause.
- **Tests:** make sure AC17 and AC18's doc checks still pass. If the `leorna` skill gives the same fallback, add the same clause there.

## Done means
- **V1:** fixed test-first, with M11h killed.
- **Rebase:** done, with both sides kept in every conflict. The new base SHA is recorded.
- **On the rebased head:**
  - `harness-guards.test.sh` passes offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
  - `ac19_existing_suites_pass` passes;
  - feature-dispatch `SKILL.md` is under 100,000 characters.
- **Clean tree:** `git status --porcelain --untracked-files=all` is clean.

## Evidence
`~/.hermes/plans/claude-setup/evidence/harness-guards/fix-3/`: V1's RED/GREEN, the M11h kill, `merge-tree` before the rebase, how each conflict was resolved (show both sides kept), and the suite logs on the rebased head.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/harness-guards-fixer3/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- The WSL desktop's `/tmp` is a shared 7.9 GB RAM tmpfs, so put `TMPDIR` and anything large in `~/.cache/harness-guards-fixer3/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
  - Never `pkill -f`: use `pgrep -f`, drop shells, then kill the rest.
  - A `setsid` run can outlive its "completed" notice, so wait on its PID.

## Output contract
- `status`: `ready-for-verify`, or `stopped` with the reason.
- `worktree`, `branch`, `old_head`, `new_base_sha`, `head_sha`.
- `fixes[{id, action, commits, test, evidence}]`.
- `conflicts[{file, resolution}]`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - An empty list is the normal answer. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
