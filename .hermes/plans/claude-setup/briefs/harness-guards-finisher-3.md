# Brief: FINISHER (after-merge steps), story `harness-guards`

## Role
You are the **finisher** for Justin's setup story `harness-guards`. The story is already merged: the setup repo `~/.claude-setup.git` (work tree `$HOME`) has local `main` at `dc5d4f5` with the story on top. Its files are live in `$HOME`.

You do the after-merge steps from the approved plan's finisher section: `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md`. Read that section first.
- Don't change any story code.
- Don't run `git config --global` for anything except the one command below.
- Never `gh auth switch`, and never change a remote or credential helper.

**The new guards are live, including on your own Bash calls.** A deny from `git-guard.sh` is the guard working. Don't try to get around it; report it.

## Skills to load first
- `git-commit-rules`
- `engineering-best-practices`

## Steps
1. **Switch on the git hooks on this desktop** with exactly the plan's command:
   `git config --global core.hooksPath '~/.claude/githooks'`
   Then show `git config --global --get core.hooksPath`.
2. **Smoke test (not AC21, which is Justin's):**
   - Make a scratch repo **outside every temp folder**, with `TMPDIR` unset: for example `env -u TMPDIR` and a repo in `~/.cache/hg-activation-check/r`.
   - Show that:
     - (a) a normal commit passes;
     - (b) a commit with a staged `CLAUDE.md` is refused by `githooks (pre-commit)`;
     - (c) a commit message with a `Co-authored-by: Claude <noreply@anthropic.com>` trailer is refused by `githooks (commit-msg)`.
   - Then remove that folder by its literal absolute path.
   - Don't use `-c user.email` or `--author`; git-guard denies them. To test the email check, rely on the folder rule only if the plan's finisher section says to.
3. **Push to GitHub:** run `~/.claude/setup/sync.sh`. It commits pending setup files and pushes `main`, now including the story's commits. Its own commit now goes through the new git hooks, which is a good real-world check that the setup repo's CLAUDE.md exception and the personal email pass.
   - Then confirm `git --git-dir=$HOME/.claude-setup.git ls-remote origin refs/heads/main` equals local `main`.
   - If `sync.sh` reports CONFLICT, a secret, or a refusal by a hook, stop and report it word for word.
4. **Codex:** check that `~/.codex/AGENTS.md` was rebuilt and carries the new guard lines (`build-codex.sh` runs on sync). Don't edit it.
5. **Don't** remove the worktree `~/.claude-setup-wt/harness-guards` or its branch.

## Evidence
`~/.hermes/plans/claude-setup/evidence/harness-guards/finisher-3/`: the logs of each step.

## Output
- `status`: `done` or `stopped` with the reason.
- `core_hooks_path`.
- `smoke{normal, claude_md, ai_trailer}`.
- `sync_output`, `local_main`, `remote_main`.
- `agents_md_rebuilt`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
