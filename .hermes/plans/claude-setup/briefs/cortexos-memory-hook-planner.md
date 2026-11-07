# PLANNER brief: cortexos-memory-hook (claude-setup) — Mini pipeline

Role: PLANNER for Justin's personal setup repo (Just-In-N-Out/claude-setup: bare repo ~/.claude-setup.git, work tree $HOME).
Write a plan Justin will approve; don't build anything. Make no edits outside the plan file, no commits, no hook installs.
Mini mode: load only the code/docs sections this touches; skip a broad context load; aim to finish within about 15–25 steps.
If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## Skills to load (Skill tool), one line each when you do
`engineering-best-practices`, `implementation-planning`. Also read `update-config` (hooks in settings.json) for hook mechanics.
Setup guides: ~/.github/README.md, ~/.claude/setup/desktop.md, ~/.claude/setup/mac.md ("Codex" sections),
~/.hermes/plans/claude-setup/codex-parity.md. Existing hooks and their tests: ~/.claude/hooks/, ~/.claude/hooks/tests/,
~/.claude/settings.json. Follow their style and test approach.

## Justin's request and answers (2026-11-06)
"Create a hook so it works": make Claude Code use the local CortexOS memory service.
- Pipeline: Mini.
- Scope: **search + save lessons**.
  - SEARCH: on each user message (UserPromptSubmit), query CortexOS and add the top few notes to Claude's context.
  - SAVE: the skill_lessons and memory notes the main session already approves and saves get copied into CortexOS too.
    **No raw chat is ever sent.** Decide the trigger (e.g. a PostToolUse hook on Write/Edit under the memory dir and
    ~/.claude/skills/*/SKILL.md, or a script the main session calls) and justify it.
- Machines: **this PC only.** The hook is synced to both machines but must stay silent and fast where no CortexOS is reachable
  (the Mac has none). Never open CortexOS beyond 127.0.0.1.

## The service (running now on this desktop)
- Repo ~/Leorna/cortexos, started with
  `docker compose -f docker-compose.yml -f local/docker-compose.override.yml -f local/docker-compose.dev.yml up -d`
  (untracked dev override; do not change it or the repo). API http://127.0.0.1:8080, health /healthz.
- Auth: headers `X-API-Key` (value in ~/Leorna/cortexos/.env as CORTEXOS_API_KEY) and `X-Betwixt-Channel: desktop`.
  The key is granted tenant `leorna`, any space. Without the key → 401; no channel header → 403; other tenant → 403.
- Save: POST /v1/objects `{"tenant_id","space_id","object_type":"Fact","content":{"text":...}}` → 200 `{"id","version"}`.
  Search: POST /v1/query `{"tenant_id","space_id","query"}`. Context packs: POST /v1/context-packs (see docs/developer-reference.md, openapi/).
- **Observed search quality:** a saved fact "The Leorna control plane is written in Go and stores its data in Postgres." was found by
  the query "Leorna control plane" (score 0.36) but NOT by the paraphrase "which programming language is the server built with?"
  (0 results, route "fast", verification "abstain: no supporting results"), although the object has an embedding. Investigate the
  request options (route/strategy/min score, context-packs vs query) with real calls and pick what gives useful recall for the hook.
  A test memory with that text exists in tenant leorna, space fleet; you may add and delete your own test objects in a space you
  name for testing (e.g. `planner-test`), and must delete them before finishing.

## Design constraints to settle in the plan
- **Fail open, always:** a hard timeout (≤1 s total for search), no output and exit 0 when CortexOS is down, the key is missing,
  or anything errors. A hook bug must never block or slow a session noticeably.
- **Secrets:** the API key must not land in the synced setup repo (gitleaks runs on sync). Say where the hook reads it from.
- **Scoping:** propose how tenant/space map to Justin's work (e.g. one space per project derived from cwd, plus a shared one),
  and how the search output is capped (count, characters) and labelled as background context, not instructions.
- **Codex parity:** Codex shares this setup (codex-parity.md). Say whether Codex gets the same hook now or as a follow-up.
- Desktop memory rule: run any heavy command capped (`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`); a
  SIGTERM/143/137/"Killed" may be an earlyoom kill — check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`.
- Do not touch other Docker containers (leorna-pg, ndx6-*).

## Deliver
Plan file: `~/.hermes/plans/claude-setup/cortexos-memory-hook.md` (Mini short form): questions at the top; playback; design;
**numbered ACs AC1, AC2… marked proposed**, one named test each, `(live)` tag on any only Justin can check; tasks; touched files;
one-line Docs & records task (setup README/desktop.md).

## Report
Return `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[],
overlaps, found_else[], skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
