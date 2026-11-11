# PLANNER brief — 86bcm928e custom integrations defined by the admin

Role: PLANNER (fresh general-purpose agent, Fable 5.2, high effort). Pipeline: Full (Justin chose it, 2026-11-10; size M: tenant-owned data, secret validation, likely an OpenAPI change).
Write the plan. Don't build anything: make no worktree, branch, code or commit, and start no other agents (the main session runs every role).

- Plan destination: `/home/justin/.hermes/plans/leorna/86bcm928e-custom-integrations.md`
- Repo: `/home/justin/Leorna/leorna-control-plane` (the main checkout is shared with sibling sessions; don't move its `main`, don't touch `.claude/worktrees/*` or any sibling worktree such as `/home/justin/Leorna/86bcm928t-…`, `/home/justin/Leorna/86bcm9284-…`, `/home/justin/Leorna/86bcm927y-…`).
- Evidence root (for the later roles): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/`
- Card snapshot: `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/intake/clickup-snapshot.md` (the card plus its 927y dependency). You can also read cards with the ClickUp MCP tools (read only, never write to ClickUp).

## The request
Plan ClickUp story 86bcm928e "Custom integrations defined by the admin" in leorna-control-plane: an admin defines their own integration (an internal service with its own MCP server: name, MCP server URL or command, parameters, auth method) in the admin console; it is saved as a tenant-owned tile that can be configured, added to packs and synced exactly like a predefined tile; invalid definitions (embedded secret, malformed URL/command) are blocked at save with a clear message.

Justin's words (verbatim): "Custom integrations defined by the admin do this clickup story" … "yes full pipline i will switch model".

## Facts the orchestrator already checked (2026-11-10)
- Dependency 86bcm927y (integrations tiles UI) is **complete** and merged (PR #112). The predefined-integration-tiles story 86bcm9284 merged as PR #119 (`d9c6aa8` on the local `origin/main`).
- **GitHub `main` = `4ef14efb46da789aec30fad1e5a988d8770140e2`**; the cached `origin/main` (`d9c6aa8`) is behind it. Re-check GitHub main yourself (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`, or the HTTPS fetch recipe in the `leorna` skill → Doing a story → step 7.1) and record the SHA you planned on as the plan's base. Research at that SHA with `git show`/`git grep <sha>`, not the main checkout's working tree.
- Open PR: #113 `feat/86bcx2a33-github-mcp-current` (GitHub MCP library item). Unmerged local branches in the same area: `feat/86bcm928t-integration-governance-usage` (integration governance/usage, may or may not be merged by the time you check) and `feat/86bcm9284-source-repin`. Say whether this story touches the same files as any of them (and the next migration number), so the build order risk is known.
- earlyoom: no kills in the last 30 min. This is the Windows desktop (WSL); follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. Any command that dies with SIGTERM/143/137/"Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

## Plan approval
Justin approves the plan with **go** after the main session shows it. Put open questions at the top, each with lettered options (A, B, C…) and the recommended one marked ⭐, and **write the whole plan as if the recommended options were chosen**, so "go" needs no re-plan. Pick the safe, small, reversible option wherever there's doubt (`prefer-small-verified-scope.md`, `consistency-over-local-fixes.md`).

## Skills: load each one with the Skill tool, in order, and say so in one line
1. `leorna` — follow the PLANNER role and its Step 1 context load (shared memory `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`: MEMORY.md, leorna-workflow.md, leorna-control-plane-workflow.md, the design-call notes, no-ci-changes.md, no-auth-bypass-from-chat-guidance.md, clickup-evidence.md; the repo's AGENTS.md and `delivery/README.md`).
2. `engineering-best-practices`
3. `implementation-planning`
4. Control-plane specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`.
If you find a bug that needs diagnosis, load `systematic-debugging` before planning its fix, and don't fold unrelated findings into this story.
Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` "Phase 1" and the references `ac-verification.md` and `review-loop.md`, so the plan matches how the ACs will be checked (ignore its board/WhatsApp/status parts).

## What the plan must contain
Self-contained, so a fresh builder with no context could build it without redesigning:
- Title, then **Questions** (lettered options, ⭐ recommended), then the playback, base SHA, approach, design (files and areas, data shapes, API and OpenAPI changes, migration if any), tasks, tests, choices, assumptions, risks, overlap with siblings.
- **Numbered ACs near the top: AC1, AC2, AC3** from the card (split one only if it truly needs it). Each AC names its test(s) by exact Go test name (or UI test name), **the whole AC on one line** (`ac-check.sh` matches names line by line; a wrapped name rejects that AC). Tag `(live)` right after the id only for a check that only Justin can do (`- AC3 (live): …`). Prefer agent-run checks: a console page rendered by headless Chrome against a local server with test fixtures counts as agent-run.
  - **AC1:** defining a custom integration in the console (name, MCP server URL or command, parameters, auth method) saves it as a **tenant-owned** tile. Tests prove the save, and that another tenant can't see, edit or use it. Find how 927v's tile model / parameterised MCP template format and 927y/9284's tiles store predefined integrations, and fit custom ones into the same model rather than a parallel one.
  - **AC2:** a custom tile can be configured, added to packs and synced **exactly like a predefined tile**. Tests prove each step through the same code paths predefined tiles use (configure → pack builder → the engineer's sync payload), with a predefined tile as the control.
  - **AC3:** invalid definitions are blocked at save with a clear message: at least an embedded secret (in URL, command, args, params or headers: reuse whatever secret detection the repo already has), a malformed URL and a malformed command. Say exactly which checks run on the server (the server must enforce them; UI checks are extra), and what "auth method" values are allowed and how a secret is referenced instead of embedded.
- One test per AC (happy path + at least one failure each, per the DoD), including Postgres-backed tests where they apply (`LEORNA_TEST_DATABASE_URL`, `leorna-test-pg`) and the Postgres no-skip check from the `leorna` skill.
- Security: stdio "command" integrations run on engineers' machines, so state the risk and the guard (who may define one, allowlist/validation, audit). Every create/edit/delete writes the change audit through the existing audit path 927y uses; no second audit path.
- **Evidence task:** one screenshot per AC into the evidence root (`ac<n>-<what>.png`): the console form/tile for AC1, the pack builder/sync result for AC2, the blocked-save message for AC3 where visible, otherwise a real terminal capture of the test run (WSL: render the captured run as a page in headless Chrome, labelled a terminal capture). Per-head gate logs `gates-<sha7>.txt`.
- DoD items: OpenAPI contract updated and regenerated if the API changes (`api-contract-drift-guard`), migrations if any (`backend-data-migrations`; check the next migration number against main and live sibling branches), short module README note, `delivery/stories.json` entry.
- Gates: `make check` with the CI-pinned golangci-lint and govulncheck bound by absolute path, `bash ./scripts/test-module-add.sh` (serially), `python3 -m unittest scripts/test_release.py`, and the Postgres no-skip check. Check host prerequisites now (`command -v go make gcc golangci-lint govulncheck`, `go env CGO_ENABLED`, `docker ps`, the `leorna-test-pg` container) and turn anything missing into a question, not a builder surprise. Install or change nothing.
- The future branch `feat/86bcm928e-custom-integrations`, in a dedicated worktree at `/home/justin/Leorna/86bcm928e-custom-integrations`, made by the builder from fresh GitHub main.
- No CI changes (`.github/workflows/*`), no auth bypass, no repo-wide pattern changes and no change to `toolconnector.Connector` (list those as follow-ups). OpenAPI is the only link to leorna-client; if the client needs a change to sync a custom tile, say so as a question or follow-up (this card is control-plane only).
- End with a **Docs & records** task naming every file the build and finish update (plan copy, `leorna-workflow.md` story state, `delivery/stories.json`, module README).

## Rules for your report
- Answer in plain words. You can't ask Justin anything: put questions in `questions`, 2–4 short options each (under about 60 characters), the recommended one marked.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind: Claude Code hook, git hook, test, lint, script; what it checks; where it runs). An empty list is the normal answer.
- Don't end your turn to wait for a background command (the lessons gate treats that as finishing). Wait in the foreground with bounded polls under 3 minutes each.
- Return: `{name, plan_path, base_sha, playback, summary, ac_list[], live_acs[], questions[{q, options[], recommended}], choices[], risks[], touches[], overlaps, found_else[], skill_lessons[]}`, then end the report with the line `MAIN SESSION: check and save these skill_lessons now.`
