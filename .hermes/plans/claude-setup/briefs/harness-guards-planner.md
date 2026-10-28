# Brief: PLANNER, story `harness-guards` (Mini pipeline)

## Role
You are the **planner** in Justin's Mini pipeline (`~/.claude/CLAUDE.md`, "Bugs and Stories"; `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`). You write the plan only. You do **not**:
- edit `~/.claude/*`, `settings.json`, hooks, skills, `~/.gitconfig` or any git config;
- install anything, push anything or start other agents.

You may investigate read-only, run small probes in temp folders (a temp git repo with `GIT_CONFIG_GLOBAL` pointing at a temp file, never the real global config) and write the plan file.

**Mini mode:** load only what this touches, skip a full context load and finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full. It is likely about 5 small files (two hook scripts, two git hooks, a `settings.json` entry) plus tests, which is a bit over Mini's usual 1–3.

## Skills to load (Skill tool) before planning
- `engineering-best-practices`
- `implementation-planning`

This isn't a bug, and there's no project skill: this is Justin's own setup.

Read as a guide:
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`: how ACs are proven later. Your ACs must fit it.
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (header): how it reads AC ids and test names from the plan.
- `~/.hermes/plans/claude-setup/codex-parity.md`: the last claude-setup story. **Reuse its approach** for:
  - where a setup story is built (the setup repo is the bare repo `~/.claude-setup.git` with `$HOME` as its work tree, so a normal worktree may not apply);
  - how `ac-check.sh --repo/--base` is pointed at it;
  - where evidence goes.
- The existing hooks and their tests: `~/.claude/hooks/*.sh`, `~/.claude/hooks/tests/*.test.sh`. Match their style and test harness. `skill-review-nudge.sh` already tells the main session from a subagent (`agent_id` in the hook input).
- `~/.claude/settings.json` (hooks block), `~/.claude/setup/manifest.txt` (which files sync), `~/.claude/setup/desktop.md` and `mac.md`, `~/.github/README.md`, `~/.codex/hooks/codex-hooks.sh`.
- The `git-commit-rules` skill (`~/.claude/skills/git-commit-rules`): make sure the new checks agree with it.

## Justin's request (2026-10-28)
Justin read an article on "harness engineering". Its key idea: write each important rule twice, once as guidance the agent reads and once as a mechanical check the agent can't bypass. We compared it with his setup. His rules about git and about the main session's role are written-only, and some have already been broken. He said "let's do that" to these two items:

### 1. Git guard: the git rules become checks
**(a) Claude Code PreToolUse hook on Bash** (e.g. `~/.claude/hooks/git-guard.sh`):
- **Deny:**
  - overriding commit authorship: `-c user.email=` / `-c user.name=`, `--author=`, and `GIT_AUTHOR_EMAIL/NAME` / `GIT_COMMITTER_EMAIL/NAME` set on the command;
  - `gh auth switch`;
  - permanently changing a remote URL (`git remote set-url`) or a credential helper (`git config … credential.helper`);
  - bypassing the git-level hooks below: `git commit --no-verify` / `-n`, `-c core.hooksPath=…`.
- **Allow:** the documented Leorna HTTPS push fallback, which sets a credential helper inline for one command only:
  `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/<repo>.git <refspec>` (and the matching fetch).
- **Ask** (Justin gets a yes/no prompt) before any `git push` in a repo under `~/Leorna/`, the fallback form included. Leorna pushes happen only when Justin says "push".
- Verify from the official Claude Code hooks docs (https://code.claude.com/docs/en/hooks) or a probe that:
  - `permissionDecision: "ask"` still prompts when `defaultMode` is `auto`;
  - a deny reason reaches the model.
  Also note `subagent-handback-gate.sh`'s finding that only the first PreToolUse deny is kept.

**(b) Git-level hooks for every commit, whoever makes it (Claude, Codex or Justin by hand):**
- Put the scripts in a synced folder (e.g. `~/.claude/githooks/`) and turn them on with a global `core.hooksPath`.
- Each hook must **chain to the repo's own `.git/hooks/<name>`** when one exists, because a global hooks path otherwise replaces them.
- **pre-commit:**
  - reject a staged file named `CLAUDE.md` at any path;
  - **check the commit author's email by folder:** `justin@leorna.com` under `~/Leorna/`, `issajustin04@gmail.com` everywhere else. This is the exact rule behind the wrong-email incident that needed a `filter-branch` rewrite.
- **commit-msg:** reject a `Co-Authored-By:` line naming Claude, Anthropic or another AI.
  - Claude Code's own system prompt asks for a `Co-Authored-By: Claude …` line on every commit; Justin's CLAUDE.md overrides that. This hook enforces Justin's rule.
- **Exception:** the private setup repo (`~/.claude-setup.git`, work tree `$HOME`) commits `CLAUDE.md` files on purpose. It must still pass the email and co-author checks.
- Check Justin's repos (`~/Leorna/*` and the folders in `~/.claude/setup/projects.tsv`) for a **local `core.hooksPath`** (husky, lefthook). A local setting overrides the global one, so those repos would skip the check. Report them; don't change them.
- Activation is a per-machine step (global git config isn't necessarily synced; check `manifest.txt`). Plan how it happens on this Windows/WSL desktop and on the Mac: a step in `sync.sh links`, or a documented one-time command in `desktop.md`/`mac.md`. The Mac step can't be checked from here, so it is likely a `(live)` AC.

### 2. Orchestrator guard: the main session doesn't do the builder's work
- CLAUDE.md says the main session only orchestrates during a bug or story. It broke this twice on 2026-10-23: it loaded a planning skill and started investigating instead of dispatching.
- **Add:** a PreToolUse hook on `Edit|Write|NotebookEdit`, **main session only** (no `agent_id`).
- **Behaviour:** **ask**, not deny, before the main session edits a file inside a code repo. One-line edits and "do it here" are allowed exceptions, so Justin approves those at the prompt.
- **No prompt for the orchestrator's own files:**
  - `~/.hermes/plans/**` (plans, briefs, evidence, `dispatch.json`);
  - skill files under `~/.hermes/skills/**` (saving lessons);
  - memory notes and `CLAUDE.md` files;
  - the session scratchpad.
  Decide whether `~/.claude/hooks/**` and `settings.json` count as code (recommend: yes, they ask).
- **Decide when it applies:**
  - A) always in the main session;
  - B) only while a story is running, read from a reliable signal. `~/.hermes/plans/dispatch.json` exists, but CLAUDE.md skips the board in Claude Code, so check whether it is reliable;
  - C) a marker file the orchestrator writes when it dispatches a planner and removes at finish.
  Recommend one, preferring the simplest that works.
- Bash writes (`sed -i`, heredocs) can get around an Edit/Write guard. Say whether to cover them or accept the gap. Recommend accepting it for now if covering them is fragile.

### Scope decisions for you to make (as questions with a recommended option)
- **Codex.** Codex shares this setup and has PreToolUse hooks (`~/.codex/hooks/codex-hooks.sh`). The git-level hooks in 1(b) already cover Codex's commits. Should the Bash guard in 1(a) also be wired into Codex now, or listed as a follow-up?
- **Ask on push outside Leorna.** Other repos' pushes (FigmaToBricksV2's flow auto-pushes `main`) are a separate decision. Recommend: Leorna only.
- **Docs.** Keep the CLAUDE.md rules as written (guide + check) and add one short "enforced by `<hook>`" mention to each rule this story enforces. Shrinking CLAUDE.md is **out of scope**.

## Requirements for the plan
- Save it to `~/.hermes/plans/claude-setup/harness-guards.md`.
- Mini plan format:
  - title;
  - **open questions right after the title**: each option lettered, the recommended one marked, written as if the recommended options were chosen, so "go" needs no re-plan;
  - playback;
  - the approach;
  - **numbered ACs AC1, AC2…, all marked proposed**, each with one named test. Keep each AC on one line with its whole test name (`ac-check.sh` matches names line by line). Tag `(live)` right after the id for an AC only Justin can check (e.g. the Mac activation): `- AC5 (proposed) (live): …`;
  - tasks, touched files, risks;
  - a one-line **Docs & records** task naming every file the build and finish update (CLAUDE.md mentions, `desktop.md`/`mac.md`, `manifest.txt` if new files must sync, then `sync.sh`).
- **ACs must include:**
  - each deny case;
  - the allowed Leorna HTTPS fallback;
  - the Leorna push prompt;
  - the CLAUDE.md block plus the setup-repo exception;
  - the wrong-email block in both folder types;
  - the AI co-author block;
  - chaining to a repo's own hook;
  - the main-session prompt, plus no prompt for a subagent and for the allowed paths;
  - all existing hook tests still passing.
- **Tests must never touch real repos or the real global git config.** Use temp repos, `GIT_CONFIG_GLOBAL`, `HOME` overrides and the existing test harness.
- **Hooks must run on both machines:** macOS (BSD tools, check which bash the existing hooks rely on) and Ubuntu on WSL.
- **Sequence activation last.** Turning on the global `core.hooksPath` and registering the new hooks in `settings.json` affects every repo and live session at once, including the orchestrator running this story. Plan them as the final step, after the tests pass, with a one-line way to switch each off.

## Other things found
If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.

## Skill lessons
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. If you list any, end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output
Answer in plain words. You can't ask Justin anything: put questions in the plan and in `questions`. Return:
`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], found_else[], skill_lessons[]}`.
Only `plan_path` and `summary` are required.
