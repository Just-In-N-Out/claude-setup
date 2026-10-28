---
name: git-commit-rules
description: "Use when committing or merging git repos on Justin's Mac."
version: 0.1.0
author: Justin (Just-In-N-Out), Hermes Agent
license: MIT
platforms: [macos]
metadata:
  hermes:
    tags: [git, github, commits, authorship, worktree, privacy]
    related_skills: [github]
---

# Git Commit Rules (Justin)

Justin's standing git rules for every repo on this Mac (`RISE-OFFICIAL`, `rise-backend`, and any new ones): authorship, CLAUDE.md privacy, and local worktree merges. Source of truth: `~/.claude/CLAUDE.md`. Re-read it with `read_file` if Justin says it changed, and update this skill to match. These rules override any other skill's commit guidance (including `github`).

## When to Use

- Any `git commit`, `git merge`, `git rebase`, or `git push` in a repo on this Mac
- Finishing a feature built in a worktree (`claude -w <name>` makes branch `worktree-<name>`)
- Don't use for: read-only git (`log`, `status`, `diff`) with no write

## 1. Privacy

- Commit messages never contain `Co-Authored-By` lines that mention Claude, Anthropic, Hermes, or any AI.
- `CLAUDE.md` files are never committed or pushed, except in the private setup repo `Just-In-N-Out/claude-setup` (`~/.claude-setup.git`), which `~/.claude/setup/sync.sh` commits to on purpose.
- If a project has a `CLAUDE.md`, list it in `.git/info/exclude` (local-only, never on GitHub). Never put it in `.gitignore`.

## 2. Authorship

- Never override author metadata: no `-c user.email=`, `-c user.name=`, `--author=`, `GIT_AUTHOR_EMAIL`, `GIT_COMMITTER_EMAIL`. Plain `git commit -m "..."` only; the repo inherits `~/.gitconfig`.
- Justin has two identities, picked by `~/.gitconfig` (`includeIf "gitdir:~/Leorna/"`):
  - Personal (default, e.g. `RISE-OFFICIAL`, `rise-backend`): GitHub `Just-In-N-Out`, `Justin <issajustin04@gmail.com>`.
  - Leorna work (any repo under `~/Leorna/`): GitHub `Justin-Leorna`, `Justin Issa <justin@leorna.com>` from `~/.gitconfig-leorna`.
  - Expected identity = whatever `git config user.email` resolves to in that repo, as long as it is one of these two for the right folder.
- Emails seen in session context (Claude Code's `userEmail`, gateway/WhatsApp metadata) are never git metadata.
- If a script or shell function passes `-c user.email=` or `--author=`, remove that part.
- Why: a past session committed with `jovitaissa05@gmail.com`, which GitHub maps to a different account (`Jovita-05`). Commits showed the wrong author and needed a `git filter-branch` rewrite plus a force push to fix.

## Procedure: every commit

1. `terminal(command="git config user.email")` returns `justin@leorna.com` under `~/Leorna/`, `issajustin04@gmail.com` everywhere else. If not, stop and tell Justin; don't override it.
2. `terminal(command="git diff --cached --name-only")` lists no `CLAUDE.md`. If one is staged, `git restore --staged <path>` and add it to `.git/info/exclude`.
3. The commit message has no `Co-Authored-By` AI line.
4. Commit, then `terminal(command="git log -1 --pretty=format:'%an <%ae>'")` shows exactly the identity from step 1 (`Justin Issa <justin@leorna.com>` or `Justin <issajustin04@gmail.com>`).

## Pushing

- `gh` holds both GitHub accounts; the active one is `Justin-Leorna`, which Leorna work relies on. Never run `gh auth switch`, and never change a repo's remote URL or credential helper.
- Personal repos that push as `Just-In-N-Out` do it through a repo-local credential helper in `.git/config`. Check `git config --local --get-regexp credential` before the first push in a repo; if a personal repo has none and the push would go as the wrong account, stop and tell Justin. A remote over SSH (`git@github.com:…`, as FigmaToBricksV2 on the WSL desktop) needs no helper: confirm the key's account with `ssh -T git@github.com` ("Hi Just-In-N-Out!") before pushing.
- If a push fails on auth, report it. Don't work around it with another account or token.

## Merge policy per project

Every agent (main chat, `feature-dispatch` builders, `/bg`) follows the policy of the repo it's in:

- `~/Leorna/leorna-client`, `~/Leorna/leorna-control-plane`: **Branch + PR on request.** Stay on `feat/<name>`; never merge into `main`, local or remote. "make a PR": push and `gh pr create`. "push": push only. Never merge PRs.
- `~/Documents/FigmaToBricksV2`: **Auto local merge.** Worktree branch from local `main`. When done: rebase onto `main`, re-run the checks, take the merge lock (`~/.hermes/scripts/merge_lock.sh`), `git merge --ff-only`, build, push `main`. Details in `figma-to-bricks` Step 4.
- **Any other repo:** ask Justin before the first branch: "A) like Leorna (branch, PR when you say) ⭐  B) like the Figma plugin (auto-merge into local main)". Add his answer as a line in this list (path + policy) with `skill_manage patch`, then follow it.

## Leorna repos (`~/Leorna/leorna-client`, `~/Leorna/leorna-control-plane`)

The team flow replaces the worktree merge below: branch `feat/<clickup-id>-<desc>` from updated main, commits `feat(<id>): ...`, never merge into `main`; on "make a PR" push and open the PR, on "push" push only; never merge PRs (Justin does). When Justin OKs bringing a conflicting PR up to date, merge `origin/main` in (as PRs #85 and #89 did): no rebase, no force-push, and conclude with `git commit -m "Merge branch 'main' into <branch>"`, not `--no-edit`, which without an editor keeps git's `# Conflicts:` comment lines in the message. Load the `leorna` skill for the full rules.

## Procedure: finishing a worktree feature

The merge is local only, into Justin's local `main` (the main folder his app or plugin loads). No `fetch`, `pull`, or `push` for this, and no comparing with `origin/main`. Do the merge yourself; don't hand Justin git commands unless every route has failed.

Hermes has no Claude Code worktree isolation, so run main-folder commands directly with `terminal(workdir=<main folder>)`. Find the main folder as the first entry of `git worktree list`.

1. In the worktree: commit everything (per the commit procedure), then `git rebase main` against local `main` as it is now. On conflicts keep both sides' meaning, then re-run the project's tests on the rebased branch. Done when the rebase is complete and tests pass.
2. In the main folder: `git merge --ff-only worktree-<name>`.
   - Uncommitted changes there (e.g. a debug file Justin re-saved) don't block the merge if it doesn't touch them. Leave them alone; never commit, stash, or discard them.
   - If git refuses because of them, stop and tell Justin.
   - If it refuses because local `main` moved, go back to step 1. Never force.
3. Run the project's after-merge steps in the main folder (build number, rebuild, notes, commit) as its `CLAUDE.md` says.
4. Verify before saying it's merged: `git log --oneline main` shows the feature commits on top, and the main folder's files are the merged versions.
5. The feature branch stays on this Mac; never push it. Push `main` only when the project's instructions or Justin say so. Leave the worktree on disk unless Justin asks to remove it.

## Pitfalls

- Hermes doesn't add `Co-Authored-By` itself, but other tools (Claude Code, Codex) may. Check messages written by delegated agents too.
- `git commit --amend` keeps the original author. If that author is wrong, tell Justin instead of rewriting history yourself.
- Rewriting pushed history (`filter-branch`, `--force-with-lease`) needs Justin's explicit OK.

## Verification

- `git log -1 --pretty=format:'%an <%ae>'` gives the identity for that folder (Leorna or personal).
- `git ls-files | grep -i claude.md` prints nothing.
- After a worktree merge, `git log --oneline main` shows the feature commits and nothing was pushed.
