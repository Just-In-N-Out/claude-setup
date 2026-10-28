# Brief: FIXER 1, story `harness-guards` (Full pipeline)

## Role
You are **fixer 1** for Justin's setup story `harness-guards`.
- You act on reviewer 1's findings in the story's worktree, test-first, and stop at `ready-for-review`.
- Reviewer 2, a fresh agent, reviews your corrected code next.
- You don't start other agents, push, merge into `main`, rebase, run the real `~/.claude/setup/sync.sh`, or install anything into the real `$HOME`:
  - no `git config --global` changes;
  - no edits to the live `~/.claude`, `~/.hermes/skills` or `~/.hermes/skills-library`.
  Every change goes into the worktree's copies.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `receiving-code-review`: verify each finding before fixing it. Fix the valid ones test-first, and push back with evidence on any that are wrong.
- `test-driven-development`: a failing test that reproduces the finding comes before each fix.
- `mutation-testing-discipline`: every changed guard rule needs a test you have proven can fail.
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. Current head `c7c296611bc085318344747a05153aaf05ba6153`, base `3f8c53ce389590e6f92c2dab46ed001618436869`. **Don't rebase:** `main` has moved, and the finisher rebases later.
- **Before you start,** confirm HEAD is `c7c2966` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option.
- **Don't change, add or rename ACs or their test names.** Put new cases inside the existing AC test functions in `.claude/hooks/tests/harness-guards.test.sh`, such as AC6, AC7, AC9, AC10, AC11 and AC14.
- **Commits:** plain `git commit -m "…"` on branch `harness-guards`. The identity is `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one. No author overrides.

## The review to act on
Reviewer 1's full report is at `~/.hermes/plans/claude-setup/evidence/harness-guards/review-1/` (evidence files), and its findings are copied below. Use the reviewer's repro files to reproduce each one.

**Justin's standing instruction is "go with the recommended stuff".** So apply the ⭐ fix for each finding unless you show with evidence that it is wrong or that a simpler fix meets the same need.

- **F1 (P1): git-guard reads every heredoc body as commands, so data writes get false denies and asks.**
  - Where: `.claude/hooks/git-guard.sh:106-119` (`normalize` body loop) and `:117` (quote blanking).
  - ⭐ Scan a heredoc body only when the command it feeds is a shell (`bash`/`sh`/`zsh`/`dash`/`ksh`, after `env`/`command`/`exec`/`timeout`) or `eval`. Every other heredoc body is data.
  - Add to AC7's test as expected-no-output cases:
    - `cat >> brief.md <<'EOF'` quoting the Leorna HTTPS fallback;
    - `python3 - <<'EOF'` editing a test file that contains `--no-verify`;
    - `cat > settings.json <<'EOF'` containing `"Bash(git push --force:*)"` in a Leorna folder;
    - `git commit -F - <<'MSG'` whose body line is `git config --global --unset core.hooksPath`.
  - Keep `bash <<'EOF'⏎git commit --no-verify⏎EOF` as a deny.
- **F2 (P1): orchestrator-guard asks before the main session saves lessons to library-linked skills, so AC14 is false on the real layout.**
  - Where: `.claude/hooks/orchestrator-guard.sh:62`, `:51-57`, `:72-76`.
  - Many `~/.hermes/skills/<cat>/<name>` folders are symlinks into `~/.hermes/skills-library`, a git clone. The same is true of `~/.claude/skills/*`.
  - ⭐ Add `"$home"/.hermes/skills-library/*.md` to the own-files case. Scripts there stay code through the repo walk.
  - Add an AC14 fixture with that second hop into a real git repo: `SKILL.md` and `references/*.md` get no output, and `scripts/x.sh` gets ask.
- **F3 (P2): `GIT_CONFIG_*` env is only checked on a git command in the same segment.** So `export`, `;` chains or a nested `bash -c`/`sh -c` turn hooks off in both layers.
  - Where: `git-guard.sh:289-292`, `:354`, `:305-308`.
  - ⭐ Evaluate `env_configs` on every segment's assignments (prefix, `env`, `export`), the way IDENTITY_ENV already is, and carry the env into nested shells.
  - Deny identity, `core.hooksPath` and `credential.*` keys there, with no fallback exception for env-supplied helpers.
  - Add the reviewer's probe forms to AC4 or AC7.
- **F4 (P2): command substitution inside double quotes, and backticks, hide git from the guard.**
  - Where: `git-guard.sh:72-82`.
  - ⭐ When `$(` or a backtick opens (unquoted or inside double quotes), take its body and run `scan(body, cwd, depth+1)`.
  - `git commit -m "$(cat <<'EOF' … EOF)"` must still give no output.
  - Add AC7 cases.
- **F5 (P2): when `~/Leorna` is a symlink, githook.sh refuses every correct Leorna commit and git-guard never asks before Leorna pushes.**
  - Where: `githook.sh:22,32` and `git-guard.sh:384-386`.
  - ⭐ Match both the logical and the physical folder:
    - githook.sh: `leorna=$(cd "$HOME/Leorna" 2>/dev/null && pwd -P)`, then `case "$common/" in "$home/Leorna/"*|"$leorna/"*)`;
    - git-guard: `root = os.path.realpath(os.path.join(self.home, "Leorna"))`, also matching the logical path.
  - Add a linked-`~/Leorna` fixture to AC6 and AC9.
  - Add `ls -ld ~/Leorna` to AC22's Mac scan output (the test's printed steps only; AC22 stays live).
- **F6 (P2): the `push-to-checkout` wrapper replaces git's built-in `updateInstead` update.**
  - Where: `.claude/githooks/push-to-checkout`, `githook.sh:63-67`.
  - ⭐ In githook.sh, when the hook name is `push-to-checkout` and the repo has no hook of its own, do git's default: refuse if the work tree or index is dirty, otherwise `git read-tree -u -m HEAD "$1"`. Follow git's `push-to-checkout.sample`.
  - Add an AC11 case: push into a non-bare repo with `receive.denyCurrentBranch=updateInstead` while the githooks are on. The target's work tree must equal the pushed tip and be clean.
- **F7 (P3): a conflicted merge that brings in a tracked `CLAUDE.md` is refused at commit time.** The same merge without conflicts passes.
  - Where: `githook.sh:44`.
  - Fix: when `MERGE_HEAD`, `CHERRY_PICK_HEAD` or `REVERT_HEAD` exists, skip `CLAUDE.md` paths whose staged blob equals that side's blob. Add an AC8 case.
- **F8 (P3): a scissors line passed with `-m` hides an AI trailer.**
  - Where: `githook.sh:50`.
  - Fix: cut at the scissors line only when the next line is git's "# Do not modify or remove the line above." and the text after it starts with `diff --git`. Add an AC10 case.
- **F9 (P3): R5's warning has two holes.**
  - Where: `git-guard.sh:575`, `:25`.
  - Print the systemMessage when `python3` exits non-zero, for example macOS's `/usr/bin/python3` stub.
  - Run the `*gh*`/`*git*` pre-filter on `.tool_input.command` only.
- **F10 (P3): a `cd` inside a subshell leaks into later segments.**
  - Where: `git-guard.sh:237-240`, `:296-300`.
  - Save the folder at `(` and restore it at `)`. Add an AC6 or AC7 case.
- **F11 (P3): AC17's `grep -zv` is GNU-only**, and it will run on the Mac.
  - Where: `harness-guards.test.sh:719`.
  - ⭐ `srcgit grep -lF -- "$OLD_SHAPE" -- . ':!.hermes/plans'`.
- **F12 (P3): the Codex header doesn't say the new guards are Claude Code only.**
  - Where: `.claude/setup/codex/agents-header.md` (translation table, about lines 17-27).
  - Add one row: `git-guard.sh`, `orchestrator-guard.sh` → "Claude Code only (Codex wiring is a follow-up); `~/.claude/githooks` still checks Codex's commits".
  - Never hand-edit `~/.codex/AGENTS.md`; check how it is regenerated and whether a test covers the header.
- **Docs consequence (from reviewer 1's found_else):** the github skill's `references/pr-workflow.md:123-126` documents the inline `credential.helper=!gh auth git-credential` push and fetch for any `$OWNER/$REPO`. git-guard now denies that form unless the URL is `https://github.com/LeornaAI/…`. That is intended: gh's active account is Justin-Leorna, so a personal repo pushed that way would go out as the wrong account.
  - Update that passage, in the worktree's copy, to say the form is for LeornaAI repos only and that git-guard denies it for any other owner.
  - If the github skill is a `skills-library` link that isn't in this repo, say so in the report instead.

**Not in scope (follow-ups; don't fix):**
- `url.*.insteadOf`;
- inline `-c remote.<n>.url`;
- `include.path` / `includeIf.*.path`;
- alias definitions;
- `xargs`/`nice`/`sudo` wrappers;
- `remote remove` + `add`;
- `gh auth login/logout/refresh`;
- `filter-branch`/`filter-repo`;
- `g''it` quoting;
- variable resolution;
- the empty `.git` folders.

## Done means
- **Each finding:** fixed with a test that failed first, or pushed back with evidence.
- **Re-run reviewer 1's transcript replay** (`review-1/transcript-replay-*`; reuse its script or commands) on your head. Every false deny and ask it found is gone; only the deliberate probe denies remain. Save the before/after counts.
- **Full suite:** `harness-guards.test.sh` passes offline, also as `PATH=/usr/bin:/bin /bin/bash`.
- **AC19's suites:** `ac19_existing_suites_pass` passes.
- **Mutations:** for each changed guard rule, a mutation is killed by the intended test.
- **Clean tree:** `git status --porcelain --untracked-files=all` is clean.

## Evidence
`~/.hermes/plans/claude-setup/evidence/harness-guards/fix-1/`: the RED and GREEN run for each finding, the replay before/after, the mutation runs and the suite logs.

**Gotchas on this desktop:**
- In Claude Code's Bash tool, `grep` is a function running its built-in ugrep, so use `command grep` for complex patterns.
- A mutant that can loop must send output to a file, not `$(…)`.
- Write `pkill -f` patterns so they can't match their own command line.

## Output contract
- `status`: `ready-for-review`, or `stopped` with the reason.
- `worktree`, `branch`, `base_sha`, `head_sha`.
- `fixes[{id, action: fixed|pushed-back, commits, test, evidence}]`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - An empty list is the normal answer. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
