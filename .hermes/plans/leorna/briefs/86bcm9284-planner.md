# Brief: 86bcm9284 planner

**Role:** PLANNER (Full pipeline) for Leorna ClickUp card 86bcm9284, "Predefined integration tiles: GitHub, Google Workspace, ClickUp". Repo: `~/Leorna/leorna-control-plane` (content lives in `internal/library/content/`). Size L, three external services.

**You plan only.** No branch, no code, no worktree, no commits. Never write to ClickUp. Never push. Don't fast-forward the shared main checkout (it is 20 behind; that is the builder's worktree task). Base: GitHub `origin/main` = `c8abbdd` (fetched 2026-11-07; re-fetch over HTTPS via gh as the `leorna` skill says and record the SHA you plan on).

## Skills to load (Skill tool), in order
1. `leorna`: do its Step 1 context load in full (MEMORY.md, leorna-workflow.md, control-plane AGENTS.md, leorna-control-plane-workflow.md, the design-call notes). Search with `git grep`, never `grep -r` (sibling worktrees under `.claude/worktrees/`).
2. `engineering-best-practices`
3. `implementation-planning`
4. Specialists as relevant: `security-best-practices`, `multi-tenant-auth-management` (per-user sign-in), `api-contract-drift-guard` (if OpenAPI changes), `backend-data-migrations` (if any migration).

Read ClickUp with the `mcp__clickup__clickup_get_task` tool (load it with ToolSearch `select:mcp__clickup__clickup_get_task` first), read-only.

## What to find out and decide
- Read card 86bcm9284 in full: description, ACs, Verify, DoD, notes, dependencies. **AC1 is already done**: confirm with file:line or commit evidence and mark it so; don't re-plan it.
- Dependencies 86bcm927v (tile model) and 86bcm901u (content quality gate) are complete. 901u is merged on main (PR #90, merge `044e2ad`). Confirm where 927v's tile model landed on main (file:line).
- **AC2 needs engineers to connect with their own sign-in. That's 86bcm928h (per-user credentials, Justin's own card).** Check whether 928h is merged on main (git log, open PRs via `gh pr list -R LeornaAI/leorna-control-plane`, its card). If it isn't merged, say so clearly at the top of the plan and either plan around it (what can ship now without it, what waits) or propose an order. Make it a question for Justin.
- **For each service (GitHub, Google Workspace, ClickUp), vet the official or recommended MCP server:** source (repo/publisher), licence, sign-in flow (OAuth / PAT / device flow; who holds the credential), scopes requested and the minimum we need. Use real sources (WebSearch/web pages, the repos). Record it in a vetting table in the plan, and plan for it to go into the tile docs.
- **Zayd's card 86bcx2a33** (replace the deprecated GitHub MCP library item): read it and any branch or PR for it. Map the overlap with the GitHub tile. Coordinate, don't duplicate: say who owns what, and what this story reuses or waits for. If coordination needs a decision or a message to Zayd, make it a question for Justin (draft the message; don't send anything).
- **Every tile must pass the content quality gate (901u) for every declared tool.** Plan how each tile proves that (which gate command, per declared tool).
- **Live tests** against a test GitHub org, a test Google Workspace domain and a test ClickUp workspace: tag those ACs `(live)`, right after the id (`- AC3 (live): …`, or `- AC3 (proposed) (live): …`). Justin provides the accounts. Propose agent-run checks where they genuinely suffice (fakes, recorded fixtures), so only what truly needs the real service is `(live)`.
- Host prerequisites on this WSL desktop: `command -v go make gcc golangci-lint govulncheck` and `docker ps`; anything missing is a plan question.

## The plan file
Write `~/.hermes/plans/leorna/86bcm9284-predefined-integration-tiles.md` with:
- **Questions for Justin at the top** (928h order, Zayd overlap, accounts, anything else), each with your ⭐ recommended answer.
- Playback, base SHA, branch name `feat/86bcm9284-<desc>`.
- **Numbered acceptance criteria AC1, AC2…** from the card (mark any you had to propose as **proposed**; never guess a fact that is an AC), each with exactly one named test, plus the screenshot or terminal capture planned for it and its evidence path under `~/.hermes/plans/leorna/evidence/86bcm9284/` (`ac<n>-<what>.png`).
- The MCP server vetting table.
- Files/areas touched, tasks in build order (test-first), choices, assumptions, risks, follow-ups.
- Gates: control-plane `make check` with the DB-skip rules from the `leorna` skill, `scripts/test-module-add.sh` serially, the quality gate per tile.
- Hand-over only: no push, PR or ClickUp post until Justin says so.

## Desktop memory rule
This is the Windows desktop (WSL). A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Skill lessons
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none` or a one-line proposal for a check that would have caught a broken rule (kind, what it checks, where it runs). An empty list is normal.

## Report back (short)
Plan path; base SHA; the ACs one line each with their tags (proposed / live / done); 928h status and your proposed order; the 86bcx2a33 overlap in two lines; the questions for Justin with ⭐ answers; host prerequisite gaps; skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
