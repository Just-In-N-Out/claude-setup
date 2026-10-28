# Brief: REVIEWER 2, story `harness-guards` (Full pipeline)

## Role
You are the fresh, full **reviewer 2** for Justin's setup story `harness-guards`. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

You never saw the build or the first review. The order is reviewer 1 → fixer 1 → reviewer 2 (you) → fixer 2 → verifier → blind AC auditor.

## Skills to load first (say so in your first steps)
1. `engineering-best-practices`
2. `requesting-code-review`: use its security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer.
3. `code-review-practice`
4. `security-best-practices`: these are guards that parse shell commands and decide deny, ask or allow.
5. `mutation-testing-discipline`: check that the AC tests and guards can actually fail.

## What the story is
Justin's written rules become mechanical checks:
1. **`git-guard.sh`:** a Claude Code PreToolUse hook on Bash. It denies identity overrides, gh account switches, remote and credential-helper changes and hook bypasses, allows the documented Leorna HTTPS fallback, and asks before Leorna pushes.
2. **Global git hooks in `~/.claude/githooks`,** turned on by a global `core.hooksPath`:
   - they refuse a staged `CLAUDE.md` (the setup repo is excepted), the wrong email for the folder, and AI co-author trailers;
   - they hand over to each repo's own hooks.
3. **`orchestrator-guard.sh`:** a PreToolUse hook on Edit/Write/NotebookEdit. It asks before the main session edits code, and never asks for the orchestrator's own files.
4. **`skill_lessons` gets an `enforce` field,** and the lessons gate checks it in a structured list.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Candidate head:** `7b30f168c9a638f98646e19adae9eb9912142f8a`. **Base:** `3f8c53ce389590e6f92c2dab46ed001618436869`.
- **Review the whole story,** `git diff 3f8c53c...7b30f16`, independently.
- **Weight the fix-round commits most** (`git log c7c2966..7b30f16`, 12 commits). They rewrote parts of `git-guard.sh` (heredocs, `$(…)`/backticks, shell variables and `export`, subshell folders, the pre-filter), `githook.sh` (the physical Leorna path, `push-to-checkout`, merge/cherry-pick/revert, the scissors cut) and `orchestrator-guard.sh` (skills-library files). New parsing code is where new false denies and new bypasses hide.
- **Before you start,** confirm HEAD equals `7b30f16` and that `git status --porcelain --untracked-files=all` is empty. The repo has `status.showUntrackedFiles=no`. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option.
- **ACs:** AC1–AC22. AC21 and AC22 are `(live)`, Justin's checks after activation, so mark them `not_run`. Their tests are in `.claude/hooks/tests/harness-guards.test.sh`.

### Focus areas
- **AC truth:** does each test prove every clause of its AC, on this desktop's real layout? For example:
  - `~/.claude/skills/*` and `~/.hermes/skills/<cat>/*` are symlinks, many of them into the git clone `~/.hermes/skills-library`;
  - `~/.claude` and `~/.hermes` each hold an empty `.git` folder.
- **False denies and asks (high weight).** Once switched on, git-guard runs on every Bash call by every agent, and the githooks run on every commit in every repo.
  - **Replay the real commands** from `~/.claude/projects/**/*.jsonl` (the Bash `tool_use` commands with their recorded cwd, and the main-session Edit/Write targets) through both guards. Write your own replay; don't reuse earlier rounds' scripts or results. Every deny or ask must be a deliberate rule, not data or a parsing slip.
  - Exercise the commands the pipeline uses:
    - `git status/log/diff/add/commit` (heredoc and `$(cat <<'EOF' …)` messages included), `rebase`, `merge --ff-only`, `worktree`, `merge-base`;
    - `git -C …` and `git --git-dir=$HOME/.claude-setup.git --work-tree=$HOME …`;
    - `~/.claude/setup/sync.sh` and the git commands it runs, `ac-check.sh`;
    - `gh pr view/create`, `gh auth status`;
    - the Leorna HTTPS push/fetch fallback;
    - the documented one-time `core.hooksPath` command.
- **Bypasses within the plan's rules** (AC1–AC12), especially through the new parsing: env assignments, `export`, nested shells, `eval`, substitutions and heredocs fed to shells.
  - These are already recorded as follow-ups outside the plan; list them in `found_else` only if you find something new about them:
    - `url.*.insteadOf`;
    - inline `-c remote.<n>.url`;
    - `include.path` / `includeIf.*.path`;
    - git alias definitions;
    - `xargs`/`nice`/`sudo` wrappers;
    - `remote remove` + `add`;
    - `gh auth login/logout/refresh`;
    - `filter-branch`/`filter-repo`;
    - `g''it` quoting;
    - variable resolution in `-C` paths;
    - `sudo`/`ssh` heredocs;
    - git's translated cut text;
    - Bash file writes past the orchestrator guard.
- **githooks:**
  - **Chaining:** all 16 wrappers pass args, stdin and exit code through.
  - **Git operations:** `push-to-checkout`'s default behaviour (compare it with git's own `push-to-checkout.sample` and `updateInstead`), rebase, merge (conflicted too), cherry-pick, revert, am, amend, `commit -v`, `pre-merge-commit`.
  - **Repo and folder detection:** the setup repo (bare git dir, work tree `$HOME`), and the Leorna folder logically and physically.
  - **Exclusions and speed:** the temp-folder skip, vendored `CLAUDE.md`, and how long each hook takes.
- **Both machines:**
  - macOS: BSD tools, `/bin/bash` 3.2, `python3` that may be the Xcode stub, `jq` that may be missing;
  - Ubuntu on WSL.
  - Run the suites again as `PATH=/usr/bin:/bin /bin/bash`.
- **orchestrator-guard:** main session versus subagent, the permission-mode quiet rule, own files versus code through every symlink hop, and the empty-`.git` rule.
- **Lessons gate:**
  - false send-backs;
  - the once-only behaviour;
  - the handback gate's combined deny;
  - an empty list and markdown-only lessons still pass.
- **Activation safety:**
  - `settings.json` is valid and keeps every existing hook;
  - each new hook has a timeout;
  - failure modes warn and allow;
  - the off-switches work.
- **Docs:**
  - CLAUDE.md edits are accurate and lean;
  - feature-dispatch `SKILL.md` stays under 100,000 characters;
  - `~/.codex/AGENTS.md` is generated (`build-codex.sh`) and never hand-edited;
  - `agents-header.md`, the codex `pipeline-*.toml` files, `manifest.txt`, and the github skill's `pr-workflow.md`.

## How
- Run the suites yourself on head:
  - `bash .claude/hooks/tests/harness-guards.test.sh` (offline), also under `PATH=/usr/bin:/bin /bin/bash`;
  - the test `ac19_existing_suites_pass`, which covers the older suites.
- Use a temp `HOME` and `GIT_CONFIG_GLOBAL` for anything that would touch real config. Do mutation checks in a copy outside the worktree (for example `git archive`).
- Write evidence only into `~/.hermes/plans/claude-setup/evidence/harness-guards/review-2/`. Keep scratch in your own temp folder and remove only that.
- Don't treat earlier evidence folders (`builder/`, `review-1/`, `fix-1/`) as proof; check the facts yourself.
- **Gotchas on this desktop:**
  - In Claude Code's Bash tool, `grep` is a function running its built-in ugrep, so use `command grep` for complex patterns.
  - Headless Chrome under WSLg needs `env -u DISPLAY -u WAYLAND_DISPLAY`.
  - A background harness started with `setsid` can outlive its "completed" notice, so wait on its PID.

## Severity
- **P0/P1:** a guard that can be bypassed within its rules; a false deny or ask that breaks normal pipeline work; an AC that is false; activation that could break live sessions or repos.
- **P2:** a real bug, or a test that can't fail.
- **P3:** quality or docs.

Each finding needs file:line evidence and a concrete fix. Mark the recommended option with ⭐ when there are several.

## Rules
- A problem outside this story's scope goes in `found_else` (one line each, with evidence and severity).
- List reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]`. Never edit skills or memory yourself.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - An empty list is the normal answer.

## Output (final message)
- `verdict`: `approve` or `changes-needed`.
- `findings[{id, severity, file_line, problem, evidence, fix}]`.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC22. AC21 and AC22: `accepted: false, not_run: "live: …"`.
- `found_else[]`, `skill_lessons[]`.

If you list any lessons, end with the line `MAIN SESSION: check and save these skill_lessons now.`
