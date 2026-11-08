# PLANNER brief — 86bcm928t integration governance and usage

Role: PLANNER (fresh general-purpose agent, Opus 5.5, high effort). Pipeline: Full (Justin chose it; size M: access control, dashboards and audit).
Write the plan. Don't build anything: make no worktree, branch, code or commit, and start no other agents (the main session runs every role).

- Plan destination: `/home/justin/.hermes/plans/leorna/86bcm928t-integration-governance-usage.md`
- Repo: `/home/justin/Leorna/leorna-control-plane` (the main checkout is shared with sibling sessions; don't move its `main`, don't touch `.claude/worktrees/*` or any sibling worktree).
- Evidence root (for the later roles): `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/`
- Card snapshot: `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/intake/clickup-snapshot.md` (the whole card plus the 902h dependency card). You can also read the cards with the ClickUp MCP tools (read only, never write to ClickUp).

## The request
Plan ClickUp story 86bcm928t "Integration governance and usage" in leorna-control-plane: admins control which teams get which integrations, see how integrations are used, and every integration change lands in the change audit.

Justin's words (verbatim):
> Leorna story, ClickUp card 86bcm928t: "Integration governance and usage". Repo: leorna-control-plane. Pipeline: Full (size M; access control plus dashboards plus audit).
> Read the card for the ACs.
> Dependencies: 86bcm902h (usage records with team, project and model, Christian's) is complete. 86bcm927y (integrations tiles UI, mine) is still in verification, in its own session and worktree (branch feat/86bcm927y-…). Check whether it is merged on main first. If it isn't, plan on top of that branch's current head and record the SHA in the plan. Don't touch its worktree or branch. The builder starts only after 927y is merged on main and I say go.
> Planner notes: load security-best-practices, multi-tenant-auth-management, api-contract-drift-guard and backend-data-migrations. AC1: an integration reaches engineers only through packs assigned to their team or project; test that another team and another tenant can't get it. AC2: show integration usage by team on the existing E12 dashboards "where measurable"; say in the plan what is measurable today from 902h's records, and mark anything else as a follow-up. AC3: every integration change lands in the change audit; reuse the audit records 927y writes, don't add a second audit path.
> Hand-over only: no push, PR or ClickUp post until I say.

Later, while away: "keep building the user story and go with recommended for the plan as I wont be on".

## Facts the orchestrator already checked (2026-11-08)
- **927y is merged:** PR #112 merged into GitHub `main` at 2026-11-08T05:07:45Z. GitHub `main` = `f0a326b83aae9d181e4f6681645685ae4b1fff91` (= the cached `origin/main`). Plan on GitHub main, not on the 927y branch. Its branch has one later commit, `9bffa93` (stories.json PR-number record), which isn't on main; ignore it, and don't touch the 927y branch or its worktree `/home/justin/Leorna/86bcm927y-integrations-catalog-tiles`.
- Re-check GitHub main yourself (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`, or the HTTPS fetch recipe in the `leorna` skill) and record the SHA you planned on as the plan's base. The main checkout's local `main` is 33 commits behind: research at `origin/main` with `git show`/`git grep <sha>`, not the stale working tree. The builder fast-forwards later.
- No open PRs right now. Sibling story worktrees exist under `.claude/worktrees/` (e.g. `86bcm902w-content-usage-analytics`, an E12 dashboard story). Say whether this story touches the same files as any unmerged sibling branch that's still live, especially 902w (dashboards/usage), so the risk is known.
- earlyoom: no kills in the last hour. This is the Windows desktop (WSL); follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. Any command that dies with SIGTERM/143/137/"Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

## Plan approval is already given (important)
Justin pre-approved the plan with its **recommended** options, because he's away. So:
- Still put open questions at the top, each with lettered options (A, B, C…) and the recommended one marked ⭐, but **write the whole plan as if the recommended options were chosen**. The builder will build it as written with no redesign.
- Pick the safe, small, reversible option wherever there's doubt (`prefer-small-verified-scope.md`, `consistency-over-local-fixes.md`).
- Anything Justin must decide that no safe default covers: put it in `questions` and say plainly that it blocks the build.

## Skills: load each one with the Skill tool, in order, and say so in one line
1. `leorna` — follow the PLANNER role and its Step 1 context load (shared memory `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`: MEMORY.md, leorna-workflow.md, leorna-control-plane-workflow.md, the design-call notes, no-ci-changes.md, clickup-evidence.md; the repo's AGENTS.md and `delivery/README.md`).
2. `engineering-best-practices`
3. `implementation-planning`
4. The control-plane specialists Justin named: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`.
If you find a bug that needs diagnosis, load `systematic-debugging` before planning its fix, and don't fold unrelated findings into this story.
Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` "Phase 1" and the references `ac-verification.md` and `review-loop.md`, so the plan matches how the ACs will be checked (ignore its board/WhatsApp/status parts).

## What the plan must contain
Self-contained, so a fresh builder with no context could build it:
- Title, then **Questions** (lettered options, ⭐ recommended), then the playback, base SHA, approach, tasks, tests, choices, assumptions, risks, the files and areas it touches, overlap with siblings.
- **Numbered ACs near the top: AC1, AC2, AC3** (add more only if the card truly needs them). Each AC names its test(s) by exact Go test name, **the whole AC on one line** (`ac-check.sh` matches names line by line; a wrapped name rejects that AC). Tag `(live)` right after the id only for a check that only Justin can do (`- AC3 (live): …`). Prefer agent-run checks: a dashboard page rendered by headless Chrome against a local server with test fixtures counts as agent-run.
  - **AC1:** an integration reaches engineers only through packs assigned to their team or project. Tests must prove the positive path and that **another team** and **another tenant** can't get it (whatever "reach" means in the code: the sync/bundle the client pulls, the engineer-facing API, both). Find where integrations (927y's tiles / MCP templates, 927v's model) enter the engineer's sync payload today, and close any path that bypasses pack assignment.
  - **AC2:** integration usage by team on the **existing E12 dashboards**, "where measurable". Say exactly what is measurable today from 902h's usage records (read the real schema: `internal/metric`, the ClickHouse/Postgres tables, the OpenAPI usage schema, what the client actually sends). Show only what the records really carry. Everything else is a named **follow-up** in the plan (with a one-line reason), not built here. If nothing integration-level is measurable, say so with evidence and propose the smallest honest AC2 (e.g. "not measurable" shown on the dashboard plus the follow-up), as a question with a recommended option.
  - **AC3:** every integration change (create, edit, delete, enable/disable, pack add/remove: list the real operations) appears in the change audit. **Reuse the audit records 927y writes; don't add a second audit path.** Find 927y's audit actions/revisions on main (`fix(86bcm927y): require exact integration audit actions and revisions`) and list any integration change that doesn't yet write one.
- One test per AC (happy path + at least one failure each, per the DoD), including Postgres-backed tests where they apply (`LEORNA_TEST_DATABASE_URL`, `leorna-test-pg`) and ClickHouse where a dashboard query needs it (note which skip without `LEORNA_TEST_CLICKHOUSE_URL`, and how the builder runs them: CI has a ClickHouse service; say whether a local one exists or can be started in a capped container).
- **Evidence task:** one screenshot per AC into the evidence root (`ac<n>-<what>.png`): a dashboard capture for AC2 and the admin audit view for AC3 if they're visible, otherwise a real terminal capture of the test run on Linux (this is WSL, not the Mac: say how, e.g. render the captured run as a page in headless Chrome, labelled a terminal capture). Per-head gate logs `gates-<sha7>.txt`.
- DoD items: OpenAPI contract updated and regenerated if the API changes (`api-contract-drift-guard`), migrations if any (`backend-data-migrations`; check next migration number against main and live sibling branches), short module README note, `delivery/stories.json` entry.
- Gates: `make check` with the CI-pinned golangci-lint and govulncheck bound by absolute path, `bash ./scripts/test-module-add.sh` (serially), `python3 -m unittest scripts/test_release.py`, and the Postgres no-skip check from the `leorna` skill. Check host prerequisites now (`command -v go make gcc golangci-lint govulncheck`, `go env CGO_ENABLED`, `docker ps`, the `leorna-test-pg` container) and turn anything missing into a question, not a builder surprise. Install or change nothing.
- The future branch `feat/86bcm928t-integration-governance-usage`, in a dedicated worktree at `/home/justin/Leorna/86bcm928t-integration-governance-usage`, made by the builder from fresh main.
- No CI changes (`.github/workflows/*`), no auth bypass, no repo-wide pattern changes (list those as follow-ups).
- End with a **Docs & records** task naming every file the build and finish update (plan copy, `leorna-workflow.md` story state, `delivery/stories.json`, module README).

## Rules for your report
- Answer in plain words. You can't ask Justin anything: put questions in `questions`, 2–4 short options each (under about 60 characters), the recommended one marked.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind: Claude Code hook, git hook, test, lint, script; what it checks; where it runs). An empty list is the normal answer.
- Don't end your turn to wait for a background command (the lessons gate treats that as finishing). Wait in the foreground with bounded polls under 3 minutes each.
- Return: `{name, plan_path, base_sha, playback, summary, ac_list[], live_acs[], questions[{q, options[], recommended}], choices[], risks[], touches[], overlaps, found_else[], skill_lessons[]}`, then end the report with the line `MAIN SESSION: check and save these skill_lessons now.`
