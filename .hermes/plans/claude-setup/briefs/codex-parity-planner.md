# Brief: PLANNER, story `codex-parity` (Full pipeline)

## Role
You are the **planner** in Justin's Full pipeline (see `~/.claude/CLAUDE.md`, "Bugs and Stories"). You write the implementation plan only. You do **not** write code, edit `~/.codex/*`, `~/.claude/*`, hooks, skills or the setup repo, push anything, spend Justin's ChatGPT quota on more than a few tiny probe runs, or start other agents. Read-only investigation, small probes in temp folders, plus writing the plan file.

## Skills to load (Skill tool) before planning
- `engineering-best-practices`
- `implementation-planning`

(This isn't a bug, so `systematic-debugging` isn't needed. There's no project skill: this is Justin's own setup.)

Also read, as a guide:
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, which explains how ACs are proven later. Your ACs must fit it.
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which shows how it reads AC ids from the plan.

## Justin's request (2026-10-28, condensed)
Justin also has a ChatGPT subscription. He wants **Codex (OpenAI's Codex CLI, signed in with ChatGPT)** to work like his Claude Code setup on both machines:
- it knows the rules and the pipeline;
- it uses the same skills;
- it syncs through the same setup repo.

Two steps, both in this story:
1. **Rules, skills, sync.** `~/.codex/AGENTS.md` points Codex at the same rulebook. The same Hermes skills are linked for Codex. Codex's setup files sync through `Just-In-N-Out/claude-setup`.
2. **The full pipeline in Codex:**
   - Codex agent roles for planner, builder, reviewer, fixer, verifier, auditor and finisher;
   - Justin's gate hooks adapted to Codex's hook system and tested;
   - `ac-check.sh` used unchanged.

His follow-up questions are requirements:
- "On Ubuntu on my desktop I should be able to run Codex and it should work correctly."
- "Will Codex work hand in hand with Claude, and will it update the files and everything correctly?"

## Facts already established (2026-10-28, on this Mac)

**Codex on the Mac**
- Codex CLI `0.163.0` is at `/opt/homebrew/bin/codex`, installed as the npm global `@openai/codex`. The native binary is `/opt/homebrew/lib/node_modules/@openai/codex/node_modules/@openai/codex-darwin-arm64/vendor/aarch64-apple-darwin/bin/codex`. Node and npm are in `/opt/homebrew/bin`. Codex is signed in with ChatGPT.
- `~/.codex/config.toml` (mode 600) contains:
  - `model = "gpt-5.6-luna"`, `model_reasoning_effort = "medium"`, `personality = "pragmatic"`;
  - one trusted project, `/Users/justin/Documents/weightstone-journal`;
  - `[plugins."github@openai-curated"] enabled = true`.
- `~/.codex/models_cache.json` lists the models available to Justin.
- Other contents of `~/.codex`: `auth.json` (secret), sqlite DBs, `history.jsonl`, `sessions/`, `logs`, `cache/`, `.tmp/`, `plugins/cache/`, `memories/`.
  - `~/.codex/skills/` holds only `.system/` (imagegen, openai-docs, plugin-creator, review-agent, skill-creator, skill-installer).
  - There is no `~/.codex/agents/`, no `~/.codex/hooks.json` and no `~/.agents/`.
- `codex features list` reports these flags:
  - `hooks` stable, on;
  - `multi_agent` stable, on;
  - `multi_agent_v2` stable, off;
  - `memories` stable, off;
  - `skill_search` stable, on;
  - `plugins` on.
- **Seen in the binary's strings only. Verify each against the official Codex docs (developers.openai.com/codex, or the `openai-docs` system skill) or a probe run before relying on it:**
  - Instruction files: `AGENTS.md` and `AGENTS.override.md`, with the `project_doc_max_bytes` and `project_doc_fallback_filenames` settings.
  - Skill folders: `.agents/skills` and `$CODEX_HOME/skills` (default `~/.codex/skills`).
  - Hooks: `.codex/hooks.json`, with the events PreToolUse, PermissionRequest, PostToolUse, PreCompact, PostCompact, SessionStart, UserPromptSubmit, Stop and SubagentStop.
    - Handler types: command, prompt, agent, mcp_tool.
    - Handler fields: timeout, async, statusMessage, additionalContext.
    - "PreToolUse hook exited with code 2 but did not write a blocking reason to stderr" is an error string.
  - Custom agent roles: `AgentRoleToml` with `description`, `config_file` and `nickname_candidates`, plus a `.codex/agents` path.
  - An external-agent config detect/migration that knows `CLAUDE.md` and `settings.json`.

**Setup repo and sync**
- `~/.claude/CLAUDE.md` is 20,470 bytes and full of Claude-only tool names: Agent tool, Skill tool, AskUserQuestion, ExitWorktree/EnterWorktree, SubagentHandback.
- **The setup sync system is built and live (2026-10-26).** It is manual, not automatic. The older plan `~/.hermes/plans/claude-setup/setup-sync.md` was never built; ignore it except for background.
  - The repo is bare, at `~/.claude-setup.git`, with work tree `$HOME`. `main` is at `932581b`.
  - The pieces: `~/.claude/setup/{sync.sh, sync.test.sh (28 checks: fake homes plus a local bare remote), manifest.txt, exclude.txt, gitleaks.toml, projects.tsv, mac.md, desktop.md}`, plus `~/.github/README.md`.
  - `sync.sh` holds a `DENY_RE`, a mkdir lock (stale after 10 min), a gitleaks gate, a 5 MB cap and a 25-deletion guard.
  - The README's "How the repo works" explains the design. Read `sync.sh` itself for the details.
- **The Windows desktop** runs Claude Code inside WSL2 Ubuntu (user `justin`), attached to the setup repo. The round trip was proven both ways (commits `b51d56e` and `e032618`). Node isn't known to be installed there; Claude Code was installed with `claude.ai/install.sh`.
- **Claude hooks:** `~/.claude/hooks/{subagent-ac-gate, subagent-lessons-gate, subagent-handback-gate, skill-review-nudge}.sh`, with tests in `~/.claude/hooks/tests/`. They are registered in `~/.claude/settings.json`. Claude's hooks and their behaviour must not change.
- **Skill links:** `~/.hermes/scripts/update-skills-library.sh` builds the `~/.claude/skills/*` links from `~/.hermes/skills-library-claude.txt`, and the Hermes library links from `skills-library-keep.txt`. Its `find` runs without `-L`.
  - `~/.hermes/skills/codex-imports/` and the repo `~/Leorna/codex-skills` hold Leorna's Codex-oriented skills. Watch for duplicate skill names between those, the Hermes skills and Codex's `.system` skills.
- **Docker isn't running right now** (`docker info` fails). Last time the Linux run used `ubuntu:24.04` in Docker. Plan the Linux run so it works when Docker Desktop is started, and otherwise tag it `(live)` for the desktop's WSL.
- **Standing rules Codex must follow too** (in `~/.claude/CLAUDE.md` and `git-commit-rules`):
  - git authorship by folder, with no author overrides;
  - no AI `Co-Authored-By` lines (check whether Codex adds any);
  - never `gh auth switch`;
  - Leorna push and PR rules;
  - CLAUDE.md privacy;
  - Leorna code repos are never auto-pulled.

## Things the plan must settle
1. **Where it's built and how it's reviewed.** These files live in `$HOME`. `ac-check.sh` needs `--repo <worktree> --base <base>` and a head SHA. Consider a worktree of the setup repo itself: `git --git-dir=$HOME/.claude-setup.git worktree add <dir> -b codex-parity main`. It has the `$HOME`-relative layout, its base is `main`, and the finisher merges it and checks it out into `$HOME`. Pick that or a better option, and say why. Tests never touch the real `~/.codex`, `~/.claude`, `~/.hermes`, GitHub or the real setup repo; they use a fake `$HOME` / `CODEX_HOME` and a local bare remote.
2. **AGENTS.md design.** Decide between an adapter that tells Codex to read and follow `~/.claude/CLAUDE.md` with a tool-mapping table, a generated file, or a copy. Recommend one and justify it, covering:
   - one source of truth;
   - the size limit;
   - what Codex actually loads at session start;
   - how Codex finds and loads a skill by name.
3. **Skills for Codex.** Decide which folder (`~/.agents/skills` or `~/.codex/skills`), proven by a probe or the docs. Extend `update-skills-library.sh`, don't duplicate it. Cover:
   - name collisions;
   - whether Codex accepts Hermes `SKILL.md` frontmatter (`metadata.hermes`, description length);
   - broken-link checks;
   - Linux behaviour.
4. **Pipeline roles in Codex.** For each role, decide:
   - the role file;
   - how it is registered (does Codex auto-discover `~/.codex/agents/*.toml`, or does `config.toml` need entries?);
   - the model and reasoning effort (a question for Justin; recommend from `models_cache.json`).

   Also map the Claude pipeline onto Codex: Agent tool → spawned subagent, AskUserQuestion → asking in chat, the plan-approval stop, briefs saved to files, and `ac-check.sh`.
5. **Hooks for Codex.** Port the four gates to `hooks.json`, reusing the existing scripts' logic through an adapter or shared core rather than a fork.
   - Capture real Codex hook payload shapes, for example with a logging hook in a temp `CODEX_HOME` and one tiny `codex exec`, and test against those recordings.
   - Say which Claude events have no Codex equivalent (SubagentHandback) and what replaces them.
   - The Claude hook tests must still pass unchanged.
6. **Sync.**
   - `manifest.txt` additions: `~/.codex/AGENTS.md`, roles, `hooks.json`, any Codex hook scripts.
   - `exclude.txt` and `DENY_RE` additions: `~/.codex/auth.json`, `config.toml`, sqlite, sessions, history, logs, cache, `.tmp`, `skills/.system`, plugins, memories.
   - `config.toml` stays per machine: it has machine paths and can hold MCP secrets. If Codex needs some keys in it (roles, hooks, sandbox), plan an idempotent setup step that merges just those keys on each machine and backs up first.
   - Extend `sync.test.sh` to cover all of this.
7. **Working hand in hand with Claude (Justin's question).** On one machine both tools share the same files on disk. Plan and test the following:
   - (a) Codex runs `~/.claude/setup/sync.sh pull` before planning and `sync.sh` after editing synced files, like Claude.
   - (b) **Codex's sandbox lets it do that.** By default it blocks writes outside the workspace and network access. Find the narrowest setting (writable roots or permission profile) that allows writing `~/.hermes`, `~/.claude`, `~/.claude-setup.git` and pushing, and nothing broader than needed.
   - (c) Both tools re-read a skill or rules file right before writing it (see `~/.claude/projects/-Users-justin-Leorna/memory/concurrent-sessions-share-skill-files.md`).
   - (d) `sync.sh`'s lock holds when Claude and Codex sync at the same moment.
   - (e) Codex saves `skill_lessons` and memory notes the same way: the lean-skills rule, and the same memory folders and format. Say how Codex finds the project's Claude memory notes.
   - (f) Codex's commits use the folder's identity with no AI co-author line.
8. **The desktop (WSL Ubuntu).**
   - How Codex is installed there (npm needs Node; or the standalone release binary) and signed in with ChatGPT.
   - Add a Codex section to `desktop.md`, `mac.md` and `~/.github/README.md`. Add a short Codex line to `~/.claude/CLAUDE.md`'s Setup Sync section, only if needed.
9. **The finisher's steps, in order:**
   - merge into `main`;
   - install into the real `~/.codex`, backing up anything it overwrites;
   - run `update-skills-library.sh`;
   - run `sync.sh`, which pushes through the gitleaks gate;
   - a small real smoke test with `codex exec`.
   - Never `--force`, never rewrite history.

## Output
Write `~/.hermes/plans/claude-setup/codex-parity.md`. Evidence goes in `~/.hermes/plans/claude-setup/evidence/codex-parity/`, which exists. Include:

- **Questions at the top.** At least:
  - the GPT model and effort per role (give your recommendation);
  - whether to turn on Codex's own `memories` or point Codex at the Claude memory notes only;
  - the sandbox choice in 7(b).
- **The playback,** in two or three lines.
- **Numbered acceptance criteria `AC1`, `AC2`, …, all marked `(proposed)`,** each with **one named test**. Tag `(live)` right after the id for an AC only Justin can check, e.g. `- AC9 (proposed) (live): …`. Cover at least:
  - Codex loads `AGENTS.md` and it points to the rules (a real `codex exec` probe in a temp `CODEX_HOME` is fine);
  - Codex sees every skill that Claude sees, with no broken links and no duplicate names;
  - each role file is valid and loads;
  - each ported gate blocks and allows exactly like its Claude twin, on recorded Codex payloads;
  - the Claude hook tests still pass;
  - Codex files sync, and Codex secrets and state are never staged;
  - `sync.test.sh` is extended and green;
  - Codex can run `sync.sh` from inside its sandbox;
  - the concurrent-sync lock holds;
  - a skill edit made through Codex reaches the other machine;
  - the docs are updated;
  - **(live)** Codex in desktop Ubuntu loads the same rules and skills;
  - **(live)** a small real story run in Codex goes planner → … → `ac-check.sh`;
  - the Linux test run (Docker or `(live)`).
- **Tasks**, in order, test-first, with exact files.
- **Risks.**

## skill_lessons rule
List reusable lessons in `skill_lessons[{skill, lesson, evidence}]`: a gotcha, an approach that worked after one failed, or a skill step that was wrong or missing. Never edit skills or memory yourself. An empty list is the normal answer.

## Return
A short report with:
- `plan_path`;
- `summary` (three to five lines);
- `questions` (for Justin);
- the AC list, one line each;
- `skill_lessons`.

End the report with the line `MAIN SESSION: check and save these skill_lessons now.`
