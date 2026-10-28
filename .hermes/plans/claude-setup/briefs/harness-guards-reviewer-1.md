# Brief: REVIEWER 1, story `harness-guards` (Full pipeline)

## Role
You are the fresh, full **reviewer 1** for Justin's setup story `harness-guards`. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write to the live `~/.claude`, `~/.hermes/skills`, global git config, `~/.claude-setup.git` refs or GitHub.

You never saw the build. The order is reviewer 1 (you) → fixer → reviewer 2 → fixer → verifier → blind AC auditor.

## Skills to load first (say so in your first steps)
1. `engineering-best-practices`
2. `requesting-code-review`: use its security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer.
3. `code-review-practice`
4. `security-best-practices`: these are guards that parse shell commands and decide deny, ask or allow.
5. `mutation-testing-discipline`: check that the AC tests and guards can actually fail.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Candidate head:** `c7c296611bc085318344747a05153aaf05ba6153`. **Base:** `3f8c53ce389590e6f92c2dab46ed001618436869`. Review `git diff 3f8c53c...c7c2966`, all 12 commits.
- **Before you start,** confirm HEAD equals `c7c2966` and that `git status --porcelain --untracked-files=all` is empty. The repo has `status.showUntrackedFiles=no`. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option, Q1 Full through Q8 A.
- **ACs:** AC1–AC22. AC21 and AC22 are `(live)`, Justin's checks after activation, so mark them `not_run` for that reason. Their tests live in `.claude/hooks/tests/harness-guards.test.sh`.

### The builder's deviations from the plan (rule on each: valid, or a finding)
1. **codex-parity `ac23_docs_updated` also lost a story-time pin.**
   - It already failed on the untouched base: "CLAUDE.md is not exactly one added line".
   - The builder rewrote its CLAUDE.md check to look for the single Codex line. The plan said "ac7 only".
2. **The `subagent-lessons-gate.test.sh` JSON fixture gained `"enforce":"none"`,** because AC16 now sends back a structured list without `enforce`.
3. **AC17's wording led the builder to edit 4 old plan-mode records in `.claude/plans/`** to the four-field lessons shape.
4. **orchestrator-guard counts a `.git` folder only when it holds `HEAD`** (or a `.git` file), because this desktop has an empty `~/.claude/.git` folder.
5. **git-guard additions beyond the plan:**
   - `GIT_CONFIG_COUNT/KEY_n/VALUE_n` and `GIT_CONFIG_PARAMETERS` are treated like `-c`;
   - abbreviated `--no-verify` is caught;
   - `git config --edit` is denied, and so is `--remove-section` of `core`, `user`, `credential` and `remote.*`;
   - `timeout` and shell keywords are stripped;
   - heredoc bodies are scanned as commands;
   - the pre-filter is a plain substring test.
6. **githook.sh changes from the plan's snippet:**
   - staged paths are read NUL-separated;
   - the trailer check stops at the `commit -v` scissors line and skips `#` lines;
   - AI names need a letter boundary on each side.

### Focus areas (on top of a normal full review)
- **AC truth:** does each test prove every clause of its AC?
- **False denies and asks (high weight).** Once switched on, git-guard runs on every Bash call by every agent, and the git hooks run on every commit in every repo. A wrong deny or ask breaks the pipeline itself.
  - Exercise against the guard script, with fake hook input, the commands the pipeline really uses:
    - `git status/log/diff/add/commit -m` (heredoc messages included), `rebase main`, `merge --ff-only`, `worktree add/list/remove`, `merge-base`;
    - `git -C <path> …` and `git --git-dir=$HOME/.claude-setup.git --work-tree=$HOME …`;
    - `~/.claude/setup/sync.sh` and what it runs, `ac-check.sh`;
    - `gh pr view/create`, `gh auth status`;
    - the Leorna HTTPS push/fetch fallback;
    - the documented one-time `core.hooksPath` command.
  - Read `sync.sh` to see which git commands it runs.
- **Bypasses within the plan's rules** (AC1–AC12). Rule on each gap the builder listed as outside the plan: is it in the plan's scope, or `found_else`?
  - `url.<base>.insteadOf` / `pushInsteadOf`;
  - an inline `-c remote.<n>.url=` / `pushurl=`;
  - `GIT_CONFIG_GLOBAL=` / `HOME=` isolation (plan risk R4).
- **Git hooks:**
  - **Chaining:** all 16 wrappers pass git's args, stdin and exit code through correctly.
  - **Git operations:** rebase, merge, cherry-pick, am, amend (R6), `commit -v`, merge commits (`pre-merge-commit`).
  - **Setup repo detection:** bare git dir with work tree `$HOME`.
  - **Folder detection:** the Leorna folder through symlinks and realpath.
  - **Exclusions:** vendored `CLAUDE.md`, and the temp-folder skip (Q8).
  - **Speed:** how long each hook takes.
- **Both machines:** macOS (BSD tools, `/bin/bash` 3.2 unless the hooks use another bash, whether `python3` exists) and Ubuntu on WSL. Check the shebangs and every tool the hooks call.
- **orchestrator-guard:**
  - telling the main session from a subagent;
  - the permission-mode quiet rule (Q2 A);
  - path classification (own files versus code);
  - the empty-`.git` rule.
- **Lessons gate:**
  - false send-backs;
  - the once-only behaviour;
  - the combined deny of the handback gate;
  - an empty list and a markdown-only lessons section must still pass.
- **Activation safety:**
  - `settings.json` is valid and keeps every existing hook;
  - each new hook's timeout;
  - with `python3` missing, the guard warns and allows (R5);
  - the plan's off-switches work.
- **Docs:**
  - the CLAUDE.md edits are accurate and lean;
  - feature-dispatch `SKILL.md` stays under 100,000 characters;
  - `~/.codex/AGENTS.md` is generated, never hand-edited, so check how the story handles it;
  - the seven `.codex/agents/pipeline-*.toml` edits;
  - `manifest.txt` lists every new file that must sync.

## How
- Run the suites yourself on head:
  - `bash .claude/hooks/tests/harness-guards.test.sh` (offline);
  - the 5 older hook suites, `.claude/setup/sync.test.sh`, the `ac-check.test.sh` suite and `codex-parity.test.sh` offline.
- Use temp `HOME` and `GIT_CONFIG_GLOBAL` for anything that would otherwise touch real config. Do mutation checks in a copy outside the worktree, never in the worktree itself.
- Write evidence only into `~/.hermes/plans/claude-setup/evidence/harness-guards/review-1/`. Keep scratch in your own temp folder and remove only that.
- Don't treat the builder's evidence (`…/builder/`) as proof; check the facts yourself. You may read it to find commands.
- **Gotchas on this desktop:**
  - In Claude Code's Bash tool, `grep` is a function running its built-in ugrep. Use `command grep` for complex patterns.
  - Headless Chrome under WSLg needs `env -u DISPLAY -u WAYLAND_DISPLAY` for screenshots.

## Severity
- **P0/P1:** a guard that can be bypassed within its rules; a false deny or ask that breaks normal pipeline work; an AC that is false; activation that could break live sessions or repos.
- **P2:** a real bug, or a test that can't fail.
- **P3:** quality or docs.

Each finding needs file:line evidence and a concrete fix. Mark the recommended option with ⭐ when there are several.

## Rules
- A problem outside this story's scope goes in `found_else` (one line each, with evidence and severity), not in the findings.
- List reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]`. Never edit skills or memory yourself.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - An empty list is the normal answer.

## Output (final message)
- `verdict`: `approve` or `changes-needed`.
- `findings[{id, severity, file_line, problem, evidence, fix}]`.
- `deviations[{n, ruling, why}]` for the six items above.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC22. AC21 and AC22: `accepted: false, not_run: "live: …"`.
- `found_else[]`, `skill_lessons[]`.

If you list any lessons, end with the line `MAIN SESSION: check and save these skill_lessons now.`
