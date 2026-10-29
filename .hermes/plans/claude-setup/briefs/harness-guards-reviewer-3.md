# Brief: REVIEWER 3, story `harness-guards` (Full pipeline, review-until-clean loop)

## Role
You are the fresh **reviewer 3** for Justin's setup story `harness-guards`. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

You never saw the build or the earlier reviews.

**Justin's review rule, since 2026-10-28:** review → fix repeats until a fresh review finds **no P0–P2**. Your verdict decides whether another fix round runs. After a clean review, the verifier and a blind auditor prove the ACs.

## Skills to load first (say so in your first steps)
1. `engineering-best-practices`
2. `requesting-code-review`: skip its "independent reviewer subagent" and auto-fix steps.
3. `code-review-practice`
4. `security-best-practices`
5. `mutation-testing-discipline`

## What the story is
Justin's written rules become checks:
1. **`git-guard.sh`:** a Claude Code PreToolUse hook on Bash. It denies identity overrides, gh account switches, remote and credential-helper changes and hook bypasses, allows only the documented LeornaAI HTTPS fallback, and asks before Leorna pushes.
2. **Global git hooks** in `~/.claude/githooks`: they refuse a staged CLAUDE.md (the setup repo is excepted), the wrong email for the folder and AI co-author trailers, skip temp-folder repos, and hand over to each repo's own hooks.
3. **`orchestrator-guard.sh`:** asks before the main session edits code.
4. **An `enforce` field in `skill_lessons`,** checked by the lessons gate.

## Your scope: the code no fresh reviewer has seen yet
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Candidate head:** `e4469c0fbf1c2df672d74ecf010094f902740ab2`. **Base:** `3864d61abe128113f5fd6aeda8a55b02df46377d`. The branch was rebased once.
- **Before you start,** confirm HEAD equals `e4469c0` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop and report it.
- **Review 2 last saw the story at `7b30f16`** (pre-rebase). Review everything the story changed after that. Find these commits with `git log --oneline 3864d61..e4469c0`:
  - **Fix round 2,** messages ending "(review-2 F1)" … "(review-2 F8)": in git-guard.sh, `$'…'`/`$"…"` decoding, long-option abbreviation tables, `declare`/`typeset`/`local`/`readonly`, shell input from pipes, here-strings and `source`, `(( … ))` and `<<=`, `eval` keeping `cd`/vars, `cd -`, `git am`; in githook.sh, cherry-pick author and applypatch hooks; the lessons gate's quoted-example rule.
  - **Fix round 3:** the AC11 ordering test, and one CLAUDE.md and `leorna/SKILL.md` clause about writing the fallback URL out.
  - **The rebase resolution:** `feature-dispatch/SKILL.md`'s lesson line keeps both main's sentence and the story's `enforce` text.
  - **Fix round 4,** commits `3ed7cea`, `4927065`, `5ad3941`, `a797f8b`, `a664241`, `d31fc58`, `e4469c0`: the LeornaAI fallback URL is now a strict one-name check, no value-taking options may come before the URL, `url.*`/`include.*` keys are refused in the same command; githook.sh treats a repo strictly inside `$TMPDIR` as scratch, with guards for `$HOME`, `/`, the repo itself, worktrees and Leorna.
- Use `git diff 7b30f16 e4469c0 -- <file>` and `git range-diff` to see these changes. Changes main made on its own (shown by `git diff 3f8c53c 3864d61`) are not in scope, except where the rebase merged them with the story's lines.
- You may read the rest of the story for context. A serious bug you find in older story code still counts.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option, including Q8 A: repos in temp folders skip the checks but still hand over.

### Known items to rule on (each: real P0–P2 with a scenario, or P3/follow-up)
1. **System temp folders have the same worktree hole:** a linked worktree of a real repo placed in `/tmp` or `/var/folders` skips the checks (Q8 A as approved). The `$TMPDIR` rule now refuses this case.
2. **A variable the guard can't see is allowed as the repo name** in the LeornaAI fallback (`LeornaAI/$r.git` in a `for` loop). It was kept deliberately.
3. **`TMPDIR=<a folder holding real repos> git commit` skips the hook checks.** It is the same class as `HOME=` and `GIT_CONFIG_GLOBAL=`, which plan risk R4 accepts.

**Already recorded as follow-ups** (in `~/.hermes/plans/claude-setup/evidence/harness-guards/follow-ups.md`). Raise these again only with something new.

## Severity, with Justin's rule
- **P0/P1:** a guard bypass within its rules, a false deny or ask that breaks normal work, a false AC, or activation that breaks live sessions or repos.
- **P2:** a bug a real person or agent could plausibly hit, including realistic edge cases (inputs, configs, git operations, macOS and WSL), or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion would hit, or a setup none of Justin's machines has.
- **Every P0–P2 finding must name a concrete real-use scenario: who runs what, and what goes wrong.** Without one, it is P3.

Each finding needs file:line evidence, the scenario, and a concrete fix.

## How
- Run the suites on head:
  - `bash .claude/hooks/tests/harness-guards.test.sh` offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
  - `ac19_existing_suites_pass`.
- **Replay** the real Bash commands (with recorded cwd) and main-session Edit/Write targets from `~/.claude/projects/**/*.jsonl` through both guards on head. Every deny or ask must be a deliberate rule. Write your own replay.
- **Probe** the fix-round code with real git (2.53) and real bash, in temp repos with a temp `HOME`/`GIT_CONFIG_GLOBAL`. Do mutation checks in a copy outside the worktree.
- Write evidence only into `~/.hermes/plans/claude-setup/evidence/harness-guards/review-3/`. Don't treat earlier evidence folders as proof.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/harness-guards-reviewer3/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so keep large things in `~/.cache/harness-guards-reviewer3/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
  - Never `pkill -f`: use `pgrep -f`, drop shells, then kill the rest. Kill background runs by session id.
  - `$!` after `setsid … &` is setsid's own PID.

## Output (final message)
- `verdict`: `clean` (no P0–P2) or `changes-needed`.
- `findings[{id, severity, file_line, scenario, problem, evidence, fix}]`, P0–P2 only.
- `p3[]`: one line each; these go to the follow-up list.
- `known_items[{n, ruling, why}]`.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC22. AC21 and AC22: `accepted: false, not_run: "live: …"`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line check proposal.
  - An empty list is normal. Never edit skills or memory.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
