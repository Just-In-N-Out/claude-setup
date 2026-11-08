# PLANNER brief: 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** PLANNER. Write a plan Justin will approve. Build nothing: no worktree, branch, code edit or commit.
**Model/effort:** Opus 5.5, high (Justin, 2026-11-07).
**Pipeline:** Full.

## The ask (rewritten)

ClickUp card **86bctmuwy**, "Install Agent items into local Claude Code, Codex and Cursor tool directories". Repo: `~/Leorna/leorna-client` (Go/Wails desktop app + tool connectors).

Today all three tool connectors (Claude Code, Codex, Cursor) skip items of kind Agent during Sync. This story makes Sync install Agent items into each tool's native local agent location, where the tool supports one.

The card's ACs are only proposed. Write firm, numbered ACs (AC1, AC2…), each marked **proposed**, for Justin to approve with the plan.

### Justin's planner notes (must be reflected in the plan)
1. Check each tool's **current native Agent format from official docs** (web) before designing paths: file location (user-level and/or project-level), file format, frontmatter fields, naming rules. Cite the doc URLs and the date checked in the plan.
2. A tool with no supported native Agent format must report an **explicit skip** (visible per-item status/reason), never a false success.
3. Plan **safe handling of existing user files**: never overwrite or delete a file Leorna did not write; handle name collisions, approvals, updates of Leorna-installed agents, and removal when an item is unassigned/deleted. Follow how existing item kinds (skills, prompts/commands, rules, MCP, etc.) already do this in the connectors.
4. **Do not change `toolconnector.Connector`** (the interface) in this story. If the clean design needs it, list that as a follow-up and design within the current interface.
5. **Every test runs in an isolated HOME** (and isolated tool config dirs) and never touches the real `~/.claude`, `~/.codex`, `~/.cursor` or the real HOME.
6. Hand-over only at the end: no push, PR or ClickUp post until Justin says.

### Justin's words (verbatim)
> Leorna story, ClickUp card 86bctmuwy: "Install Agent items into local Claude Code, Codex and Cursor tool directories". Repo: leorna-client. Pipeline: Full (three tool connectors; it writes into users' tool folders).
> Read the card. Its ACs are only proposed: the planner writes firm numbered ACs, marked proposed, for me to approve with the plan.
> Planner notes: today all three connectors skip Agent items. Check each tool's current native Agent format from official docs before designing paths. A tool with no supported format must report an explicit skip, never a false success. Plan safe handling of existing user files, approvals, updates and removal. Don't change toolconnector.Connector inside this story; list that as a follow-up if needed. Every test runs in an isolated HOME and never touches the real one.
> Hand-over only: no push, PR or ClickUp post until I say.

If this rewrite and his words disagree, follow his words.

## Skills to load (say so in your first steps)
1. `leorna` (PLANNER role; do its Step 1 context load). Memory folder on this machine (WSL desktop): check which of `~/.claude/projects/-home-justin-Leorna-leorna-client/memory` and `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory` is the real one (one is likely a symlink) and use it.
2. `engineering-best-practices`
3. `implementation-planning`
4. Specialists you judge needed (e.g. `authorized-write-safety` — this writes into users' tool folders; `security-best-practices`). Name them in the plan's `## Skills` section, marking any whose SKILL.md has `## Mandatory Validation and Agent Defect Loop`.

## Steps
- Read the card yourself from ClickUp (`mcp__clickup__clickup_get_task`, ID `86bctmuwy`): description, ACs, Verify, DoD, notes, dependencies. Never write to ClickUp.
- Leorna Step 1.5: fetch GitHub `main` over HTTPS through gh (command in the `leorna` skill, Doing a story → 7.1) and record the SHA as the plan's base. Do NOT fast-forward the shared main checkout (that's the builder's worktree task).
- Search code with `git grep` in the main checkout (a recursive grep also reads sibling worktrees under `.claude/worktrees/`).
- Find where each connector skips Agent items today (file:line), and how the existing item kinds handle install, ownership records, collisions, approvals, update and removal — reuse that pattern for consistency.
- Research each tool's native agent format from official docs (Claude Code subagents, Codex, Cursor). If a tool has no documented native agent format, the plan says so with the evidence and plans an explicit skip.
- Host prerequisites on this WSL desktop: check `command -v go make gcc golangci-lint govulncheck node` and note CI's pinned linter/govulncheck versions; anything missing becomes a plan question.

## The plan file
Save to `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`. Self-contained, so a fresh builder with no context can build it without redesigning:
- Title, then **Questions** right after it (each with lettered options, under ~60 chars each, recommended one marked ⭐; write the plan as if the ⭐ options were chosen).
- **Base SHA** of GitHub main.
- Playback of the request.
- **ACs near the top:** `- AC1 (proposed): … — test: <TestName>`, each AC whole on one line with its test by exact name (`ac-check.sh` matches names line by line). Tag `(live)` right after the id only for an AC only Justin can check (his real server, the app window, his real sign-in): `- AC3 (proposed) (live): …`. Prefer agent-run checks (isolated HOME, dev server in scratch HOME per `leorna-control-plane-workflow.md`) over `(live)`.
- Doc research: per tool, the native format, path(s), fields, doc URL, date checked, and supported/skip decision.
- Approach, files/areas touched, interfaces and data shapes, tasks (test-first order), one test per AC, plus failure-case tests (collision with a user file, update, removal, unsupported tool skip, isolation).
- Evidence capture task (per AC: what to show, when, artifact path under `~/.hermes/plans/leorna/evidence/86bctmuwy/`, `ac<n>-<what>.png`; terminal capture for non-visual ACs — note this is the WSL desktop, not macOS, so the macOS Terminal recipe doesn't apply; propose a working capture method here).
- Gates: client `make check` (real non-symlinked TMPDIR), `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's linter version.
- Choices, assumptions, risks, follow-ups (e.g. any `toolconnector.Connector` change).
- `## Skills` section.
- **Docs & records** task naming every file the build and finish will update (plan copy, memory notes such as `leorna-workflow.md`, evidence folder, PR text draft, etc.).
- "Other things found" section at the end.
- Say whether this overlaps files with any other open Leorna story/worktree (check `git worktree list` and recent branches).

## Rules
- Answer in plain words. You can't ask Justin anything: put questions in `questions`.
- If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in "Other things found".
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- Windows desktop memory: a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill — check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result; rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Never touch the real `~/.claude`, `~/.codex` or `~/.cursor` beyond reading docs-equivalent info you need (prefer official docs; don't write there at all).

## Return (report)
`{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}`. End the report with `MAIN SESSION: check and save these skill_lessons now.`
