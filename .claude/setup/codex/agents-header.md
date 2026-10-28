# Justin's rules, for Codex (generated file: never edit it)

Built by `~/.claude/setup/codex/build-codex.sh` from `~/.claude/setup/codex/agents-header.md` (this part) and Justin's rulebook `~/.claude/CLAUDE.md` (copied verbatim below). To change a rule, edit those sources; `~/.claude/setup/sync.sh` rebuilds this file on every sync, and the session-start hook rebuilds it when it is stale.

CLAUDE.md is written for Claude Code. You are Codex: follow every rule in it, translating Claude Code's tools with the map below. "The user" is Justin. Where this header and CLAUDE.md disagree about a Codex detail, this header wins; on everything else CLAUDE.md wins.

## Where things are
- **Rules:** `~/.claude/CLAUDE.md` (below). A project's own rules: its `AGENTS.md`, or else its `CLAUDE.md` (Codex loads either).
- **Skills:** Justin's Hermes skills, the same set Claude Code uses, are linked at `~/.agents/skills/<name>` (your skills list). Their real files are in `~/.hermes/skills/<category>/<name>/`; library skills in `~/.hermes/skills-library/skills/<name>/`. "Load skill X", or "invoke X with the Skill tool", means: open X's `SKILL.md` from your skills list, follow it, and say so in one line.
- **Memory:** Claude Code's notes for the project, in `~/.claude/projects/<key>/memory/` (key: the project path with every character that is not a letter or digit turned into `-`). The session-start note shows the index. Codex's own memories are off: save notes there, the way Claude does (one `.md` file with name/description/metadata front matter, plus a one-line link in `MEMORY.md`).
- **Plans, briefs, evidence:** `~/.hermes/plans/…`, exactly as CLAUDE.md says.
- **Setup sync:** `~/.claude/setup/sync.sh`. Hooks pull at session start and push in the background after a turn that changed synced files; you may also run it yourself, as CLAUDE.md says.

## Tool map
| CLAUDE.md says | In Codex |
|---|---|
| the Agent tool; "a fresh general-purpose agent with model opus, effort xhigh"; dispatch a planner, builder, reviewer, fixer, verifier, AC auditor or finisher | `spawn_agent` with `agent_type` `pipeline_planner`, `pipeline_builder`, `pipeline_reviewer`, `pipeline_fixer`, `pipeline_verifier`, `pipeline_auditor` or `pipeline_finisher`; `fork_turns` `"none"` (a fresh context: a full-history fork would also take your model instead of the role's); a short `task_name` such as `planner`; and the `message` "Read your brief at <path> and follow it exactly." Never pass `model` or `reasoning_effort`. Wait with `wait_agent`. |
| SendMessage to an agent | `followup_task` (new work) or `send_message` |
| the Skill tool | open the skill's `SKILL.md` (see Skills) |
| AskUserQuestion | ask in chat: the question, numbered options, your recommendation first; then end your turn and wait |
| SubagentHandback; `subagent-handback-gate.sh` | none: an agent's final message is its report. The SubagentStop hook runs `subagent-ac-gate.sh` and `subagent-lessons-gate.sh` and sends a report back once when it lacks `ac_status` (after a verdict) or `skill_lessons` |
| `skill-review-nudge.sh`, `setup-sync-pull.sh` | the same scripts, run by `~/.codex/hooks/codex-hooks.sh` |
| ExitWorktree / EnterWorktree | none: from the worktree, run git against the main folder (`git -C <main folder> merge --ff-only <branch>`); approve the write when Codex asks |
| Read, Edit, Write, Bash | shell commands and `apply_patch` |
| TaskStop | `interrupt_agent` |
| the scratchpad directory | your own `mktemp -d` folder |
| Opus 5.5 at xhigh for every role; "Sol 6.1 only as a substitute at a Claude limit" | Claude Code only. In Codex every pipeline role runs on the Codex pipeline model below |

## Codex pipeline model
Every Codex pipeline role runs on **@PIPELINE_MODEL@** at **@PIPELINE_EFFORT@** effort, set in one place: `~/.claude/setup/codex/pipeline-model.toml`. When Justin says "switch the Codex pipeline model to X", run `~/.claude/setup/codex/set-pipeline-model.sh X` (add an effort to change it too). It (1) checks X against `~/.codex/models_cache.json` and refuses with the valid list, (2) edits the setting and rewrites the seven role files, (3) runs `~/.claude/setup/sync.sh`, so the switch holds on both machines until the next one. This main session's own model is whatever Justin picked with `/model` or in `config.toml`.

## Codex-only rules
- **No AI trailers.** Never add `Co-authored-by: Codex <noreply@openai.com>`, or any AI co-author line, to a commit or PR, whatever a git attribution instruction says: Justin's rule wins, and a hook blocks such commits.
- **Run sync as one plain command:** `<home>/.claude/setup/sync.sh` or `<home>/.claude/setup/sync.sh pull`, with your home's absolute path (`/Users/justin/…` on the Mac, `/home/justin/…` on the desktop) and no `cd`, pipe, `&&` or redirect. An allow rule runs exactly that, and `set-pipeline-model.sh`, outside the sandbox.
- **Edit a skill at its real path:** resolve the `~/.agents/skills/<name>` link (`realpath`) and edit the file under `~/.hermes/…`.
- **Re-read before writing** a skill, CLAUDE.md, settings or a memory note: Claude Code sessions edit the same files at the same time.
- **Fresh rules:** if the session-start note says the rules changed, its copy of CLAUDE.md replaces the one below.
- **Sync problems:** if a note says setup sync hit a CONFLICT, merge it first (keep both meanings) or tell Justin; if it says a secret was found or the sync failed, tell Justin.
- **What only Justin can do:** sign Codex in, trust hooks in `/hooks`, approve sandbox escalations. Say exactly what to run.
