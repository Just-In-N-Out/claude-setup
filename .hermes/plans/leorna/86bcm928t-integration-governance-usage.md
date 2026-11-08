# 86bcm928t — Integration governance and usage (plan)

Card: [Integration governance and usage](https://app.clickup.com/t/86bcm928t) (Justin, E14, size M, tags pi-2, pillar-governance, pillar-visibility). Repo: `leorna-control-plane` only. Pipeline: Full, every role a fresh Opus 5.5 high agent. Planned 2026-11-08T05:40Z by the planner.
**Approval:** Justin pre-approved this plan with its ⭐ options while away ("keep building the user story and go with recommended for the plan as I wont be on"). The plan is written as if every ⭐ option was chosen. **No question below blocks the build.** Hand-over only: no push, PR or ClickUp post until Justin says so.

## Questions (answered by the ⭐ options unless Justin says otherwise)

**Q1. Nothing Leorna records today says which integration an engineer used. What does AC2 show?**
Usage records carry tool, user, tokens, cost, model, project and team, and the client sends only `action: "model_response"`; item uses carry only skills, prompts and agents (evidence in "What is measurable today"). So integration *use* can't be counted. What *is* measurable is which integrations each team's current packs give it.
- ⭐ **A.** On the Content usage dashboard, a new "Integrations by team" table: each team, each configured integration its current packs assign (team default or project override), and a Uses column that says **Not measurable** with the reason. Counting uses is a named follow-up.
- B. Only a "Not measurable" notice on the dashboard, plus the follow-up. Smaller, but shows admins nothing they can act on.
- C. Also build integration-use counting now (client detects MCP calls, server accepts a new item-use kind). Two repos, needs its own spike like 902w; roughly an L story.

**Q2. The desktop tile list (`GET /v1/client/integration-tiles`) shows every shipped tile to every engineer of the company.**
It carries only the shipped catalogue (names, sign-in method, token variable names), no company settings and no MCP templates, and grants no access. The in-progress client story 86bcm928h reads it to explain sign-in for integrations that are already in the engineer's bundle.
- ⭐ **A.** Keep it as is: it's the shipped catalogue, not a company's integration. AC1's test pins that it carries no company settings or templates.
- B. Filter it to tiles in the engineer's assigned packs. Needs a project parameter (API change in both repos) and changes what 928h builds on.

**Q3. One older admin form can change a configured integration's MCP item with no audit record.**
`POST /admin/packs/versions/edit` (the one-item editor's form path) saves any item kind, including an MCP template named `integration-github` with a different server, into a new pack version. Older pack-version saves write no audit record for any kind (`CreateVersion`, `internal/store/postgres/pack_versions.go:21-75`).
- ⭐ **A.** That form refuses MCP items in the reserved `integration-…` name space ("Change a configured integration on its Integrations page"). No new audit path; the Integrations page and the pack builder stay the only ways to change one, and both are audited.
- B. Leave it and list it as a follow-up. Then AC3 is not fully true.
- C. Add an audit record to that form. That's a second audit path for older saves of every kind, a repo-wide change; not recommended.

**Q4. There is no delete or turn-off for a configured integration today.**
927y built configure and edit only. An admin stops an integration reaching a team by removing it from the pack (audited) or changing the assignment (audited).
- ⭐ **A.** Don't add one in this story. "Turn off or delete an integration" is a follow-up.
- B. Add "Turn off" now: a new audited action, a migration and pack-snapshot rules. Scope growth for an M story.

## Acceptance criteria

The card's three criteria, word for word, each with the one test that proves it (`internal/web`, Postgres-backed). Supporting tests are listed under Tests.

- AC1: Given an integration, then it reaches engineers only through packs assigned to their team/project — proven by `TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres`: the team default and a project override deliver it (manifest + bodies) to that team's engineer, a project override without it wins, another team's engineer gets 404 (and the store refuses the project), another company's engineer gets 403 at the desktop API and the store refuses the project, the tile list carries no company settings, and removing it from the assigned pack stops delivery.
- AC2: Given the dashboards, then integration usage (which integrations, by team) is shown where measurable — proven by `TestIntegrationGovernanceAC2DashboardByTeamWithPostgres`: `/admin/content-usage` shows "Integrations by team" with exactly the team/integration rows the current assignments give (team default and unexpired project overrides; no expired override, no unassigned integration), Uses "Not measurable" with the reason, company B sees only its own rows, and a member gets 403.
- AC3: Given any integration change, then it appears in the change audit — proven by `TestIntegrationGovernanceAC3ChangeAuditWithPostgres`: configure and edit write `integration.configure`/`integration.update` on the configuration, adding, removing and re-adding it in a pack write `pack.create`/`pack.version.create` naming `mcp_template/integration-github` and its version, assigning the pack writes `pack.assign`, the older one-item form refuses to change the integration item (422, no version, no record), no record carries settings, company B sees none, and `/admin/audit` lists them.

No AC is `(live)`: every check runs on this desktop against a local Postgres (and ClickHouse for the existing content-usage suite).

**Base behaviour expected by the verifier and auditor** (base = `f0a326b`):
- AC1 **passes on base** on purpose: pack-gated delivery predates this story (`ResolveForProject`, `internal/store/postgres/pack_assignments.go:169-198`; `requireClient`, `internal/web/client_auth.go:140-162`). Its ac.json row uses `base_exempt`: "delivery was already pack-gated before this story; AC1 proves it for integrations", backed by the mutation receipts M1 and M2 (Task 9), which show the test fails when either gate breaks.
- AC2 fails on base on its own assertion: `page has no section #integrations-by-team`.
- AC3 fails on base on its own assertion: `older form status=200 (commit=""), want 422`. (Task 1 confirms this before any code; see its stop condition.)

## Playback

Admins should control which teams get which integrations, see how integrations are used, and find every integration change in the change audit. Justin's notes: AC1 tests must show another team and another company can't get an integration; AC2 shows usage by team on the existing E12 dashboards only where measurable, and names everything else as a follow-up; AC3 reuses 927y's audit records, with no second audit path.

## Base, dependencies and host

- **Base:** GitHub `main` = `f0a326b83aae9d181e4f6681645685ae4b1fff91` (checked with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` at 2026-11-08T05:2xZ; equals the cached `origin/main`; the main checkout's local `main` is also at `f0a326b` now). The builder re-reads GitHub main before branching and records the SHA it used; if main moved, it branches from the new main and notes it.
- **86bcm927y** (integrations tiles UI): **merged**, PR #112, merge `f0a326b`. Its branch-only commit `9bffa93` (stories.json PR number) is not on main; ignore it. Don't touch its branch or worktree `/home/justin/Leorna/86bcm927y-integrations-catalog-tiles`.
- **86bcm902h** (usage records with team, project and model): complete, on main.
- **Branch / worktree:** `feat/86bcm928t-integration-governance-usage` in `/home/justin/Leorna/86bcm928t-integration-governance-usage`, made by the builder from fresh GitHub main (`git -C /home/justin/Leorna/leorna-control-plane worktree add -b feat/86bcm928t-integration-governance-usage /home/justin/Leorna/86bcm928t-integration-governance-usage <fresh main sha>`). Don't move the main checkout's `main`; don't touch `.claude/worktrees/*` or any sibling worktree.
- **Evidence root:** `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/` (builder writes `builder/`, reviews `review-<n>/`, verifier `verifier/`, auditor `auditor/`).
- **Host (checked 2026-11-08, read-only):** `go` is not on PATH; the toolchain is `~/.local/leorna-toolchain/go/bin/go` (go1.27.3 = `go.work`). CI-pinned tools present: `~/.local/leorna-toolchain/bin/golangci-lint` 2.14.0 (ci.yml:137) and `~/.local/leorna-toolchain/bin/govulncheck` v1.7.0 (ci.yml:151). `gcc` 15.2 at `/usr/bin/gcc` and `go env CGO_ENABLED` = 1, so `go test -race` works (the memory note saying WSL has no C compiler is stale). `make` 4.4.1, `gitleaks` 8.30.1 at `/usr/local/bin`, `docker` works, Chrome for Testing at `~/.cache/chrome-for-testing/chrome-linux64/chrome`. No `psql` (not needed). The shared `leorna-test-pg` container is **stopped** (Exited 255 seven days ago): don't restart or reuse it; the builder runs its own containers (Task 0). Nothing is missing, so no host question.

## What is measurable today (AC2 evidence)

| Record | What it carries | Integration-level? | Evidence |
| --- | --- | --- | --- |
| Usage event (902h) | id, tool, action, timestamp, tokens, cost, currency, model, projectId; team derived | No field names an MCP server or integration | `internal/metric/metric.go:57-70`; OpenAPI `UsageEvent` (`contracts/control-plane.openapi.yaml:1457-1499`) |
| Usage event `action` | always `"model_response"` from the client | No | client main `7a83443`: `usage/claudecode.go:67`, `usage/codex.go:43`, `usage/cursor.go:52`, `application/usage_after_sync.go:96` |
| ClickHouse `usage_events_v1` | tenant, user, event, time, tool, action, tokens, cost, currency, team_id, project_id, model | No | `internal/metric/clickhouse/store.go:103-110` |
| Item use (902w) | tool, kind ∈ {skill, agent, prompt}, item name, time, project | No: `mcp_template` is not an item-use kind | OpenAPI `ItemUseKind`; `item_uses_v1` at `store.go:112-116`; `internal/metric/content-usage-spike.md` |
| Pack assignments + pack version items + company configurations (Postgres) | which pack version each team default and project override assigns, its items, the company's configured `integration-<tile>` items | **Yes: which integrations each team is assigned** | `ListAssignments` (`pack_assignments.go:200-245`), `GetByID`, `ListIntegrationConfigurations` (`integrations.go:121-141`) |

So the dashboard shows **which integrations, by team** from assignments, and **Uses: Not measurable** with the reason. Follow-up F1 (count integration use) names what's missing.

## Where integrations reach engineers (AC1 trace)

- A configured integration becomes an ordinary `mcp_template` pack item named `integration-<tile>` (`internal/integration/service.go:76`), copied into a pack version by the pack builder (`loadCatalogItems`, `internal/store/postgres/pack_builder.go:300-348`).
- Engineers receive pack content only through the desktop API: `GET /v1/client/projects/{id}/bundle` and `…/bundles/{digest}/content` (`internal/web/client_bundle.go:60-85`, `client_bundle_content.go:55-105`), both resolved by `ResolveForProject` (project override over team default; expired project denied; `GetProject` enforces team membership for non-admins, `projects.go:62-66` via `withProject`).
- `requireClient` admits only the deployment's own company (`client_auth.go:156-160`: other tenant → 403 `TENANT_MISMATCH`).
- Every other route that reads packs or integrations is admin-only (`internal/web/handler.go:225-348`: `/v1/packs*`, `/admin/*`). Member-readable `GET /v1/teams*` and `GET /v1/projects*` return no pack contents.
- `GET /v1/client/integration-tiles` returns the shipped catalogue only (`client_integrations.go:13-29`): Q2 ⭐A keeps it; AC1 pins that it carries no company settings or templates.
- Admin principals skip team membership on project reads (`withProject`), so an admin's desktop client can sync any project of the company. That is the existing admin design, not an engineer path; AC1 uses member principals throughout (lesson from 86bcm901r auditor 2).
- **No bypass of pack assignment was found**, so AC1 adds proof, not code.

## Every integration change and its audit record (AC3 inventory)

| Change | Path | Audit record (reused, already on main) | Gap |
| --- | --- | --- | --- |
| Configure (first save) | `POST /admin/integrations/{tile}` → `SaveIntegrationConfiguration` | `integration.configure`, target = configuration ID (`integrations.go:71-81`) | none |
| Edit settings | same | `integration.update` | none |
| Save with no change | same | none (no change, `ErrNoChange`) | n/a |
| Google save | same | refused 409, no record (927y) | n/a |
| Delete / turn off | does not exist | — | Q4 ⭐A: follow-up F2 |
| Add to a new pack | pack builder `CreatePack` | `pack.create`, `diff.added` names `mcp_template/integration-<tile>@1.0.N` (`pack_builder.go:92-135`, `pack.DiffItems`) | none |
| Add / remove / re-add in a pack version | pack builder `SavePackVersion` (also the library page's pack forms) | `pack.version.create` with `diff.added/removed/changed` | none |
| Give a team or project the pack | `AssignTeam` / `AssignProject` | `pack.assign` (`pack_assignments.go:20-89`) | none |
| Older one-item form edits the integration item | `POST /admin/packs/versions/edit` (url-encoded) → `itembuilder.SaveLegacy` → `VersionService.SaveEditedVersion` → `CreateVersion` | **none** (`CreateVersion` writes no audit) | **Q3 ⭐A: refuse it** |
| Multipart item editor / new item | `itembuilder.Create/Edit/Replace` | n/a: `validate()` allows only skill, agent, prompt (`internal/itembuilder/validate.go:42`) | none |
| Fork a version that holds it | `VersionService.Fork` | none, but the integration item is copied unchanged; giving the fork to a team writes `pack.assign` | not an integration change |

## Approach

1. **AC1:** one Postgres-backed end-to-end test through the real desktop API and store. No product change.
2. **AC2:** a pure function `integration.ReachByTeam` turns the company's configurations, current assignments and their pack versions into rows; the Content usage page (`/admin/content-usage`, already an admin-only E12 dashboard with the "Not measurable" pattern) renders them in a new last section "Integrations by team". It reads only Postgres through existing store methods (`Configurations`, `ListAssignments`, `PreviewByID`). No migration, no API change, no ClickHouse change.
3. **AC3:** reuse every existing audit record; close the one unaudited path by refusing `integration-…` MCP items in the older one-item form (`itembuilder.prepareLegacy`, shared by its preview and save). The reserved-name rule lives in `internal/integration` (`ConfiguredItemName`) next to the code that names those items.

## Choices

- Show the new table on the existing Content usage page, last on the page, so existing positional page checks are untouched (Q1 ⭐A).
- "Assigned through" lists each source: "Team default: <pack> <version>" or "Project <name>: <pack> <version>", with the integration item's version. An expired project's override is left out (it delivers nothing: `ResolveForProject` denies expired projects). A team default is listed even if every project of the team has an override: the row says "assigned", not "synced".
- Integrations are matched by the company's own configurations (`item_name` of `integration_configurations`), so another company's or a hand-made item never counts; a legacy Google item in an old pack still counts, because it still reaches engineers.
- When the integrations service or assignment store isn't wired (older test fixtures), the section says "Integration assignments are unavailable on this server" instead of an empty table. Production always wires both (`cmd/control-plane/main.go:205,218`).
- A read error in the new section fails the page like the existing reads (`contentUsageFailure`: 403 / 503), never a partial page.
- Refusal reason in the older form: `Change a configured integration on its Integrations page`; HTTP 422 `INVALID_DRAFT` (the preview step runs first whenever assignments are wired, `pack_versions.go:226-240`).
- The reserved name space is the whole `integration-` prefix for MCP templates (what 927y names every configured item), trimmed like `pack.ItemKey`. Skills or prompts named `integration-…` are unaffected.

## Assumptions

- "The existing E12 dashboards" includes the Content usage page (86bcm902w), which already shows delivered content and "Not measurable" cells.
- "Which integrations, by team" can be met by assignments now; use counts are a follow-up (Q1 ⭐A).
- Admins using the desktop client keep seeing every project of their company (existing design).
- No admin data uses an MCP template named `integration-…` other than configured integrations (927y owns that name space).
- 86bcm928h will keep reading the unfiltered tile list (Q2 ⭐A).

## Files and areas touched

- `internal/integration/reach.go` (new): `ItemNamePrefix`, `ConfiguredItemName`, `UsageNotMeasurable`, `Reach`, `ReachSource`, `ReachByTeam`.
- `internal/integration/reach_test.go` (new): `TestReachByTeam`, `TestConfiguredItemName`.
- `internal/itembuilder/builder.go`: refusal at the top of `prepareLegacy` (+5 lines, one import).
- `internal/itembuilder/legacy_integration_test.go` (new): `TestLegacyEditRefusesConfiguredIntegrationItem`.
- `internal/web/content_usage.go`: `integrationReach`, three page fields, the new template section.
- `internal/web/integration_governance_test.go` (new): the three AC tests and their fixture.
- `internal/web/integration_governance_component_test.go` (new): `TestContentUsageIntegrationsUnavailableWithoutWiring`.
- Optional, only if the builder's own probe finds it needed: `internal/integration/service.go:76` may use `ItemNamePrefix` (pure refactor, same string).
- Docs: `internal/integration/README.md` (new section), `internal/metric/README.md` (Content usage section, one paragraph), `internal/pack/README.md` (one line near line 192 on the older form). `delivery/stories.json` (append entry).
- **Not touched:** `contracts/*` (no API change; `make contracts-check` proves nothing regenerates), migrations (none; next free number on main would be 29, no sibling adds one), `.github/workflows/*`, `toolconnector.Connector` (client), ClickHouse schema, `cmd/control-plane/main.go`.

## Overlap with sibling branches (checked 2026-11-08 05:3xZ)

No open PRs in either repo. Unmerged local branches with commits not on main:
- **86bcm9284 predefined tiles** (Justin, Full pipeline, builder stage; worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles` at `f0a326b` with only untracked `cmd/library-gate/tiles_test.go` + testdata so far; plan `~/.hermes/plans/leorna/86bcm9284-predefined-integration-tiles.md` "Files and areas touched"). Shared files: `internal/integration/README.md` (both add a section; likely a text conflict, resolve by keeping both sections) and `delivery/stories.json` (both append; the later merge re-appends its entry last). 9284 bumps tile versions to 0.2.0 and adds Codex to ClickUp; this story's tests read tile names and item versions from data, never tile versions, so no test coupling.
- **86bccndx6 custom company domain** (READY FOR THE USER, 14 commits, head `e4cb538`, not pushed): touches `internal/web/handler.go`, `client_discovery.go`, `client_auth.go`, `internal/web/README.md`, the spec and `delivery/stories.json`. Only `stories.json` is shared. Its canonical-host check needs tests that call the desktop API to set `discovery.BackendUrl` and `discoveryHost` to the test server (its diff to `quick_start_test.go`, `client_bundle_test.go`); this plan's fixture already does, so AC1 keeps passing whichever merges first. If ndx6 merges first, the finisher re-runs AC1 on the brought-in main.
- **86bcm901b** (1 commit: `stories.json`), **86bcm927y** (`9bffa93`: `stories.json`): `stories.json` only.
- **86bcm902w** (dashboards): merged (PR #103); its branch has no commits beyond main. This story edits its page (`internal/web/content_usage.go`) on main, so the existing `TestContentUsage*` suites (component and the five ClickHouse-backed `…WithPostgres`) must run green with ClickHouse (Task 8).
- Client 86bcm928h (in progress) reads `/v1/client/integration-tiles`; unchanged here (Q2 ⭐A).

## Tasks

Every role keeps its scratch in its own new folder (`mkdir` without `-p`): builder `~/.cache/86bcm928t-builder/`. Every `go test` that runs Postgres or a mutation runs under a memory cap: `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (8G for `make check`). A command that dies with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

### Task 0 — Worktree, tools and owned databases (≈10 min)

1. `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` → record as `BASE`. Fetch it: `git -C /home/justin/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, then check `git -C /home/justin/Leorna/leorna-control-plane rev-parse origin/main` equals `BASE`.
2. `git -C /home/justin/Leorna/leorna-control-plane worktree add -b feat/86bcm928t-integration-governance-usage /home/justin/Leorna/86bcm928t-integration-governance-usage "$BASE"`. Add `CLAUDE.md` to that repo's `.git/info/exclude` if a `CLAUDE.md` exists there (never commit it).
3. `mkdir ~/.cache/86bcm928t-builder ~/.cache/86bcm928t-builder/tmp`. Write the Postgres password to a 600 env file, never on a command line:
   ```bash
   umask 077; B=~/.cache/86bcm928t-builder
   printf 'POSTGRES_PASSWORD=%s\nPOSTGRES_USER=leorna\nPOSTGRES_DB=leorna_928t_builder_test\n' "$(openssl rand -hex 16)" > "$B/pg.env"
   docker run -d --rm --name 928t-builder-pg --memory 1g --env-file "$B/pg.env" -p 127.0.0.1::5432 \
     mirror.gcr.io/library/postgres:18.6-alpine3.23@sha256:697c180dbf244d3ce4a8f4cbc0156cde840af055c1bf8b76aebe422a4822086f
   docker run -d --rm --name 928t-builder-ch --memory 2g -e CLICKHOUSE_DB=leorna_metrics -e CLICKHOUSE_USER=leorna_test -e CLICKHOUSE_PASSWORD=local-integration-only -p 127.0.0.1::8123 \
     mirror.gcr.io/clickhouse/clickhouse-server:25.8@sha256:0152dd511befe6a2c2ef53e930726179669b08116da78500b37c51c96ff5ee77
   ```
   (Images and settings are CI's, `.github/workflows/ci.yml:31-60`. `--rm` removes each container's anonymous volume when it stops. The ClickHouse password is CI's public test value.) Wait for `docker exec 928t-builder-pg pg_isready -U leorna` and `curl -s http://127.0.0.1:<chport>/ping`. Create the base-run DB: `docker exec 928t-builder-pg createdb -U leorna leorna_928t_base_test`.
4. Write `~/.cache/86bcm928t-builder/env.sh` and `source` it in every shell:
   ```bash
   B=$HOME/.cache/86bcm928t-builder
   export PATH=$HOME/.local/leorna-toolchain/go/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local TMPDIR=$B/tmp
   export LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks
   export GOLANGCI_LINT=$HOME/.local/leorna-toolchain/bin/golangci-lint GOVULNCHECK=$HOME/.local/leorna-toolchain/bin/govulncheck
   pw=$(sed -n 's/^POSTGRES_PASSWORD=//p' "$B/pg.env"); [ -n "$pw" ] || { echo "empty Postgres password" >&2; return 1; }
   pgport=$(docker port 928t-builder-pg 5432/tcp | sed 's/.*://'); chport=$(docker port 928t-builder-ch 8123/tcp | sed 's/.*://')
   export LEORNA_TEST_DATABASE_URL="postgres://leorna:${pw}@127.0.0.1:${pgport}/leorna_928t_builder_test?sslmode=disable"
   export LEORNA_TEST_BASE_DATABASE_URL="postgres://leorna:${pw}@127.0.0.1:${pgport}/leorna_928t_base_test?sslmode=disable"
   export LEORNA_TEST_CLICKHOUSE_URL="http://127.0.0.1:${chport}"
   ```
   Check `go version` (go1.27.3), `"$GOLANGCI_LINT" --version` (2.14.0) and `go version -m "$GOVULNCHECK" | grep 'mod.*golang.org/x/vuln'` (v1.7.0). Never print the DB URL; logs say "Postgres: owned container".
5. **Done:** worktree on `BASE`, two containers healthy, env file sourced.

### Task 1 — Prove the planned REDs on base before any code (≈10 min)

1. `git -C /home/justin/Leorna/86bcm928t-integration-governance-usage worktree add --detach ~/.cache/86bcm928t-builder/base "$BASE"`.
2. Copy only `internal/web/integration_governance_test.go` (Task 2's file, all three tests) into the base copy, then, with `LEORNA_TEST_DATABASE_URL="$LEORNA_TEST_BASE_DATABASE_URL"`, run each AC test alone, under the cap, from the base copy:
   `( set -o pipefail; echo "HEAD=$(git rev-parse HEAD)"; go test -count=1 -v -run '^TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres$' ./internal/web; echo "EXIT=$?" ) > ~/.hermes/plans/leorna/evidence/86bcm928t/builder/red-ac1-base.log 2>&1` (same for AC2 and AC3).
3. Expected: **AC1 PASS** (every subtest), **AC2 FAIL** with `page has no section #integrations-by-team`, **AC3 FAIL** in subtest "the older pack version form cannot change the integration item" with `older form status=200 (commit=""), want 422`. The other AC3 subtests pass on base.
4. **Stop conditions:**
   - AC1 fails on base for a reason other than fixture setup: a real path bypasses pack assignment. Stop, load `systematic-debugging`, and report the log to the orchestrator; don't patch around it.
   - AC3's older-form subtest already gets a non-200 status on base: the form already refuses the item. Skip Task 5's product change, keep the test (AC3 then uses `base_exempt`), and say so in the report.
   - Any fixture step fails on base (a helper behaves differently than this plan assumes): fix the test fixture only, keep each assertion's meaning, and record the change in the report.
5. Remove the base copy: `git -C /home/justin/Leorna/86bcm928t-integration-governance-usage worktree remove --force ~/.cache/86bcm928t-builder/base`.
6. **Before-state screenshot:** capture `/admin/content-usage` on base with the evidence probe (Task 7) → `evidence/86bcm928t/builder/ac2-before-base.png`.

### Task 2 — AC1: integration delivery is pack-gated (≈10 min, slice A)

1. Create `internal/web/integration_governance_test.go` with the fixture, helpers and `TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres` from "Code: AC test file" below (leave the AC2 and AC3 functions for Tasks 4 and 5, or add the whole file now and expect those two to fail until then).
2. Run: `go test -count=1 -v -run '^TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres$' ./internal/web` → PASS (7 subtests). This is a characterization test: it starts green by design (see AC1's base note).
3. Commit: `test(86bcm928t): prove integrations reach engineers only through assigned packs` (explicit paths).

### Task 3 — `integration.ReachByTeam` (≈10 min, slice B part 1)

1. Write `internal/integration/reach_test.go` (code below). RED: `go test -count=1 -run '^TestReachByTeam$|^TestConfiguredItemName$' ./internal/integration` → build failure `undefined: ReachByTeam` (helper RED; the behaviour RED is AC2 on base).
2. Write `internal/integration/reach.go` (code below). GREEN: same command → ok. Then `go test -count=1 ./internal/integration`.

### Task 4 — AC2: "Integrations by team" on the Content usage dashboard (≈15 min, slice B part 2)

1. Add `TestIntegrationGovernanceAC2DashboardByTeamWithPostgres` (code below) and `internal/web/integration_governance_component_test.go` (code below). RED: `go test -count=1 -v -run '^TestIntegrationGovernanceAC2DashboardByTeamWithPostgres$|^TestContentUsageIntegrationsUnavailableWithoutWiring$' ./internal/web` → both fail with `page has no section #integrations-by-team`.
2. Apply the `internal/web/content_usage.go` part of "Code: production patch" below. GREEN: same command → PASS.
3. Regression family: `go test -count=1 -run 'TestContentUsage|TestIntegrations|TestConfiguredIntegration' ./internal/web` (with ClickHouse set: the five `TestContentUsage*WithPostgres` must run, not skip).
4. Commit: `feat(86bcm928t): show which integrations each team's packs assign on Content usage`.

### Task 5 — AC3: the older one-item form can't change a configured integration (≈10 min, slice C)

1. Add `TestIntegrationGovernanceAC3ChangeAuditWithPostgres` (+ `readdedGitHubBody`) and `internal/itembuilder/legacy_integration_test.go` (code below). RED: `go test -count=1 -v -run '^TestIntegrationGovernanceAC3ChangeAuditWithPostgres$' ./internal/web` → fails `older form status=200 (commit=""), want 422`; `go test -count=1 -run '^TestLegacyEditRefusesConfiguredIntegrationItem$' ./internal/itembuilder` → fails `PreviewLegacy "integration-github" err=<nil>, want ErrInvalid`.
2. Apply the `internal/itembuilder/builder.go` part of the production patch. GREEN: both commands pass.
3. Regression family: `go test -count=1 ./internal/itembuilder` and `go test -count=1 -run 'TestItem|TestPackVersions|TestPackDraft|TestPrompt' ./internal/web`.
4. Commit: `feat(86bcm928t): keep configured integration items out of the older item form`.

### Task 6 — Docs and delivery record (≈10 min)

1. `internal/integration/README.md`, append:
   ```markdown
   ## Governance and usage (86bcm928t)

   A configured integration reaches engineers only as an item of a pack assigned to
   their team (team default) or project (project override): the desktop bundle and its
   content are resolved by `ResolveForProject`, which checks team membership, expiry
   and company. `GET /v1/client/integration-tiles` is the shipped catalogue only (no
   company settings or templates).

   **Content usage → Integrations by team** (`/admin/content-usage`, admins only) lists,
   per team, each configured integration its current assignments hold: the team default
   and every unexpired project override, with the pack, version and item version. Uses
   are **Not measurable**: usage records name the tool, model, project and team, but not
   which integration's tools were called.

   Every integration change is in the change history: `integration.configure` and
   `integration.update` on the configuration, `pack.create` and `pack.version.create`
   (their diff names `mcp_template/integration-<tile>` and its version) and
   `pack.assign`. MCP items named `integration-…` are reserved for configured
   integrations: the older one-item form (`POST /admin/packs/versions/edit`) refuses
   them, so no unaudited path changes one. There is no delete or turn-off yet.

   Tests: `TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres`,
   `TestIntegrationGovernanceAC2DashboardByTeamWithPostgres` and
   `TestIntegrationGovernanceAC3ChangeAuditWithPostgres` in `internal/web`;
   `TestReachByTeam` here; `TestLegacyEditRefusesConfiguredIntegrationItem` in
   `internal/itembuilder`.
   ```
2. `internal/metric/README.md`, end of "## Content usage (story 86bcm902w)": one paragraph: "**Integrations by team (86bcm928t).** The page's last section lists the configured integrations each team's current pack assignments hold (Postgres: assignments, pack versions, company configurations; no ClickHouse read). Integration use is shown as Not measurable: no usage record or item use names an integration."
3. `internal/pack/README.md`, next to the `POST /admin/packs/versions/edit` line (~192): "It refuses MCP templates named `integration-…`, which only the Integrations page writes (86bcm928t)."
4. `delivery/stories.json`: append the entry **as text** before the final `}` (don't re-dump the file):
   ```json
     "86bcm928t": {
       "name": "Integration governance and usage",
       "prs": {
         "LeornaAI/leorna-control-plane": []
       }
     }
   ```
   (a comma after the previous last entry's `}`). Check by value: every earlier entry equals main's and keeps its order, this one is last. Run `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`.
5. Commit: `docs(86bcm928t): integration governance and usage notes and delivery record`.

### Task 7 — Evidence: one screenshot per AC (≈20 min)

Folder `~/.hermes/plans/leorna/evidence/86bcm928t/builder/`. All data is synthetic (`*.example.test`); no server domain, tenant ID, token or email may be visible (team/project names and the fixture's UUID-free text only; crop if a UUID shows).

- **Evidence probe (real pages, agent-run):** a throwaway test kept outside the repo at `builder/evidence_probe_test.go.txt`, mapped into `internal/web` with `go test -overlay` (the worktree stays clean). It builds `newGovernanceFixture`, wires the empty metrics fake and `pack.NewVersionService`, posts one GitHub settings edit (so the audit shows `integration.update`), then drives Chrome for Testing (`~/.cache/chrome-for-testing/chrome-linux64/chrome`, own `--user-data-dir` under the builder scratch, flags and cookie setup as `TestIntegrationsBrowserJourneyWithPostgres`, `internal/web/integrations_browser_test.go:63-124`) to:
  - `/admin/content-usage` → element screenshot of `#integrations-by-team` → **`ac2-integrations-by-team.png`**, plus a full page `ac2-content-usage-page.png`;
  - `/admin/audit` → full page → **`ac3-change-audit.png`** (rows `integration.configure`, `integration.update`, `pack.create`, `pack.assign`), and `/admin/audit?target=<config id>` → `ac3-change-audit-integration.png`;
  - on base (Task 1.6) the same content-usage capture → `ac2-before-base.png`.
  `FullScreenshot(&buf, 100)` and element screenshots must be PNG: check the first bytes are `\x89PNG` before naming a file `.png`. Run it under the 4G cap. Use `run` with one action list per navigation (chromedp builds arguments when the list is built).
- **Terminal captures** for the test runs (no image tool on WSL): run each AC test with `-v` into `ac<n>-<head7>.log` (first line `HEAD=…`, last `EXIT=…`), render the log HTML-escaped inside `<pre>` on a dark page titled "Terminal capture (rendered on the WSL desktop) — <command>", screenshot with headless Chrome `--screenshot --window-size=1400,<height>` (height from `--dump-dom` line count), and check the bottom shows `EXIT=0`: **`ac1-pack-assignment-only.png`** (AC1 has nothing visual: its proof is the run), `ac2-test-run.png`, `ac3-test-run.png`.
- Gate log per head: `gates-<sha7>.txt` (+ `SUMMARY.txt` with one `label EXIT=<rc>` per gate).
- Inspect every PNG visually (Read, in ≤1,300 px bands for tall pages) before listing it.

### Task 8 — Gates on the final head (≈25 min, serial)

From the story worktree, `source ~/.cache/86bcm928t-builder/env.sh`, one script writing each gate's log and a `SUMMARY.txt`:
1. `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 make check` with `GOLANGCI_LINT` and `GOVULNCHECK` bound (env.sh). `make check` = workspace, contracts-check, fmt, vet, `go test -race`, lint, audit, secrets, library-check, build. It must leave `git status --porcelain` empty.
2. `bash ./scripts/test-module-add.sh` (after `make check`, never alongside it).
3. `python3 -m unittest scripts/test_release.py`.
4. **Postgres + ClickHouse no-skip check:** `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web > pg-<sha7>.json`, then read it per test (Action plus that test's own Output; never `-v` text):
   ```bash
   python3 -I - pg-<sha7>.json <<'PY'
   import json, sys
   out, last = {}, {}
   for line in open(sys.argv[1]):
       try: e = json.loads(line)
       except ValueError: continue
       if not e.get("Test"): continue
       key = (e["Package"], e["Test"])
       if e["Action"] == "output": out.setdefault(key, []).append(e["Output"])
       elif e["Action"] in ("pass", "fail", "skip"): last[key] = e["Action"]
   fails = sorted(k for k, a in last.items() if a == "fail")
   skips = {k: "".join(out.get(k, [])) for k, a in last.items() if a == "skip"}
   env = sorted(k for k, o in skips.items() if "LEORNA_TEST_DATABASE_URL" in o or "LEORNA_TEST_CLICKHOUSE_URL" in o)
   need = ["TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres", "TestIntegrationGovernanceAC2DashboardByTeamWithPostgres", "TestIntegrationGovernanceAC3ChangeAuditWithPostgres", "TestContentUsageIntegrationsUnavailableWithoutWiring"]
   missing = [n for n in need if last.get(("github.com/LeornaAI/leorna-control-plane/internal/web", n)) != "pass"]
   for k, o in sorted(skips.items()): print("SKIP", k[1], "|", " ".join(o.split())[-160:])
   print("FAILS", fails); print("ENV-SKIPS", env); print("MISSING", missing)
   sys.exit(1 if fails or env or missing else 0)
   PY
   ```
   Allowed skips are only env-gated live/evidence tests with their own reason (e.g. `TestIntegrationsBrowserJourneyWithPostgres`, `TestEvidenceThirdPartyContentPage`, `TestProvisionManagedPostgresLive`); list each in the log. With ClickHouse set, no skip may name `LEORNA_TEST_CLICKHOUSE_URL`.
5. Container image (CI's quality job also does it): in a detached copy, `DOCKER_CONFIG=<scratch>/docker BUILDX_CONFIG=<scratch>/buildx docker build --no-cache --file Containerfile --tag 928t-builder:<sha7> .`, then `docker run --rm --entrypoint /usr/local/bin/gitleaks 928t-builder:<sha7> version` prints `8.30.1`; remove the tag after.
6. `git diff --name-only "$BASE"...HEAD` has no `.github/` path and no `contracts/` or migration path; `git log --format='%an <%ae>' "$BASE"..HEAD` is only Justin's Leorna identity (print "authors: 1 identity, Leorna OK", never the address); no commit body matches `^co-authored-by:|generated with|noreply@anthropic|🤖` (case-insensitive).

### Task 9 — Mutation proofs (≈15 min)

Load `mutation-testing-discipline`. Each mutant is a scratch copy of one file mapped with `go test -overlay` (worktree stays clean), run under the 4G cap, with the receipt in `builder/mutation/`:
- **M1 (AC1, project override):** in `ResolveForProject` (`internal/store/postgres/pack_assignments.go`), make the project-override query never match (`… AND project_id=$2 AND 1=0`). Expected: AC1 subtest "project override without the integration wins over the team default" fails.
- **M2 (AC1, other team):** in `withProject` (`internal/store/postgres/projects.go`), make the team-membership condition true for every user of the tenant. Expected: AC1 subtest "another team's engineer cannot get it" fails.
- **M3 (AC2, expiry):** in `ReachByTeam`, drop the `ProjectExpired` skip. Expected: AC2 fails (a Team Z row appears) and `TestReachByTeam` fails.
- **M4 (AC2, matching):** in `ReachByTeam`, drop the `item.Kind != pack.KindMCPTemplate` check. Expected: `TestReachByTeam` fails (Gamma's skill named `integration-github`).
- **M5 (AC3):** remove the refusal in `prepareLegacy`. Expected: AC3 and `TestLegacyEditRefusesConfiguredIntegrationItem` fail.
- **M6 (AC3, scope):** make `ConfiguredItemName` ignore the kind. Expected: `TestLegacyEditRefusesConfiguredIntegrationItem` fails on the `integration-notes` skill.
Count mutants by ID with their final outcome. A surviving mutant is a test gap to fix before ready-for-review.

### Task 10 — Ready for review

Report to the orchestrator: branch, head SHA, base SHA, commits, `git diff --stat "$BASE"...HEAD`, the RED/GREEN logs per AC, gate SUMMARY, mutation table, evidence list (each PNG checked), skips list, and anything that differed from this plan. Stop at `ready-for-review`. Leave both containers running for the review and verification roles; the finisher removes them (`docker stop 928t-builder-pg 928t-builder-ch`) after the hand-over.

## Tests

| AC | Test (exact name) | Package | Kind | Base | Head |
| --- | --- | --- | --- | --- | --- |
| AC1 | `TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres` | `internal/web` | Postgres, desktop API + store | pass (base_exempt + M1/M2) | pass |
| AC2 | `TestIntegrationGovernanceAC2DashboardByTeamWithPostgres` | `internal/web` | Postgres, admin page | fail: no section | pass |
| AC3 | `TestIntegrationGovernanceAC3ChangeAuditWithPostgres` | `internal/web` | Postgres, audit + older form | fail: form 200 | pass |
| supporting | `TestReachByTeam`, `TestConfiguredItemName` | `internal/integration` | unit | build fail | pass |
| supporting | `TestContentUsageIntegrationsUnavailableWithoutWiring` | `internal/web` | component, no DB | fail: no section | pass |
| supporting | `TestLegacyEditRefusesConfiguredIntegrationItem` | `internal/itembuilder` | unit, fakes | build ok, fail | pass |

Failure cases per AC (DoD "happy path + 1 failure"): AC1 other team 404, other company 403 + store not found, override without it, removal; AC2 expired override excluded, unassigned integration excluded, other company isolated, member 403, unwired service; AC3 older form refused with no version and no record, no settings in records, other company sees none.

ClickHouse: none of the AC tests needs it (the section reads Postgres; the AC tests use the in-memory item-usage fake already used by `content_usage_component_test.go`). It is still required locally because this story edits the page that the five `TestContentUsage*WithPostgres` tests render; they skip with "LEORNA_TEST_CLICKHOUSE_URL not set" without it. CI has a ClickHouse service.

## DoD

- Unit + integration tests per AC with a failure case: above.
- OpenAPI: no API change (HTML page and an existing form's refusal only). `make contracts-check` proves nothing regenerates; both repos regenerate nothing (`api-contract-drift-guard`: contract diff empty, nothing to version).
- Migrations: none (`backend-data-migrations` n/a). The next free number on main is 29; no live sibling branch adds one.
- Lint/format/CI: `make check` (gitleaks + golangci-lint 2.14.0 + govulncheck v1.7.0), module-add script, release unittest, Postgres/ClickHouse no-skip check, image build.
- Demoable in isolation: the evidence probe's real pages on a local fixture server.
- Short module README note: Task 6.
- `delivery/stories.json` entry: Task 6.
- No CI change, no auth bypass (tests use the fixture's sessions and the real device-sign-in service), no repo-wide pattern change.

## Docs & records

Files the build and finish update:
- Plan: this file; at "go" the orchestrator's read-only copy `evidence/86bcm928t/plan-approved.md`.
- `internal/integration/README.md`, `internal/metric/README.md`, `internal/pack/README.md` (Task 6).
- `delivery/stories.json` (Task 6; PR number added later only when a PR exists and Justin says so).
- Evidence: `evidence/86bcm928t/builder/` (logs, PNGs, mutation receipts, probe source), `review-<n>/review.json`, `verifier/ac.json`, `auditor/ac.json`, `follow-ups.md` (F1–F4 below plus review P3s).
- Shared notes (finisher / orchestrator): `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` story state line (branch, head, base, not pushed, no PR); hand-over drafts in `~/.hermes/cache/scratch/leorna-pr-86bcm928t-integration-governance-usage.md`, review prompt, ClickUp evidence draft and team message (posted only on Justin's words).

## Risks

- **Sibling merge order:** 9284 and this story both add a section to `internal/integration/README.md` and an entry to `stories.json` (text conflicts, mechanical). If ndx6 merges first, its canonical-host check applies; the fixture already sets `BackendUrl`/`discoveryHost`, but AC1 must be re-run on the brought-in main.
- **Page cost:** the new section reads one pack version per distinct assigned version (deduplicated). Fine for pilot-size companies; a company with many distinct project overrides adds queries per page load (follow-up if it shows).
- **"Assigned" vs "synced":** the table says which integrations the current assignments hold, not who has synced them; the note says so.
- **Reserved name space:** a company that hand-made an MCP template named `integration-…` through the older form can no longer edit it there (it can still be edited as a configured integration only if it is one). Unlikely; documented.
- **AC1 starts green:** accepted only with `base_exempt` plus killed mutants M1/M2; a reviewer may ask for more; the mutation receipts are the answer.
- **Content usage depends on ClickHouse:** when ClickHouse is unavailable the whole page is 503 (existing behaviour), so the new section is unavailable too.

## Follow-ups (named, not built)

- **F1 Count integration use** (both repos, spike first like 902w): check per tool whether local transcripts name calls to a Sync-installed MCP server, then a client detector, an `mcp_template` item-use kind in the OpenAPI `ItemUseKind`, and a real Uses count in this table. Reason: no record names an integration today.
- **F2 Turn off or delete a configured integration** (a new audited action). Reason: 927y built configure and edit only (Q4 ⭐A).
- **F3 Older pack-version saves write no audit record** for any item kind (`CreateVersion` via fork and the one-item form). Reason: pre-existing, repo-wide; this story only closes the integration name space.
- **F4 Filter the desktop tile list** to assigned integrations, only if 86bcm928h or a security review needs it (Q2 ⭐A).

## Other things found

- P3: older pack-version saves (`internal/store/postgres/pack_versions.go:21-75`, used by fork and `POST /admin/packs/versions/edit`) write no audit record for any item kind; `itembuilder.prepareLegacy` (`internal/itembuilder/builder.go:192-217`) skips the kind check `validate()` applies (`validate.go:42`), so that form can save MCP templates and configs. This story refuses only `integration-…` MCP items (F3).
- P3 (known, Justin's call): `delivery/stories.json` on main lists 86bcm927y with `"prs": {"LeornaAI/leorna-control-plane": []}`; PR #112 is recorded only on branch-only commit `9bffa93`. `check-story-shippable.py 86bcm927y` passes vacuously on an empty list.
- Info: the shared `leorna-test-pg` container is stopped (Exited 255, 7 days ago); this plan uses owned containers.
- Info: memory says the WSL desktop has no C compiler; it now has gcc 15.2 and `CGO_ENABLED=1` with `~/.local/leorna-toolchain/go`.

## Completion contract

The builder stops at `ready-for-review` with the Task 10 report. Review → fix rounds follow `review-fix-cadence` until `review-check.sh` prints MOVE ON; then a fresh verifier and a blind auditor prove AC1–AC3 on the reviewed head (`ac-check.sh --reviews` must print ALL ACCEPTED; there is no live AC). Then the finisher prepares the hand-over (PR text, review prompt, ClickUp evidence draft, team message). Nothing is pushed, no PR is opened and nothing is posted until Justin says "push", "make a PR" or "post".

## Code

All code below was type-checked by the planner on 2026-11-08 against a `git archive` export of `f0a326b`: `go build ./internal/... ./cmd/...` and `go vet ./internal/integration ./internal/itembuilder ./internal/web` pass with every file applied, the template parses at package init, `gofmt -l` is clean, and `internal/web/integration_governance_test.go` alone also vets on unchanged base (so AC2/AC3 fail on base by their own assertions, not a build error). No test was run. SHA-256 of each file as written here is given so a builder can check a copy.

### Code: internal/integration/reach.go (new)

sha256 `66fd28c61f47690f53d99cc08ad8e5951fe96306c8fa9bf067a1b8f721849290`

```go
package integration

import (
	"cmp"
	"slices"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// ItemNamePrefix starts every configured integration's pack item name
// (integration-<tile id>). Only the Integrations page writes such items.
const ItemNamePrefix = "integration-"

// ConfiguredItemName reports whether an item uses the name space reserved for
// configured integrations (86bcm928t): an MCP template named integration-….
func ConfiguredItemName(kind pack.Kind, name string) bool {
	return kind == pack.KindMCPTemplate && strings.HasPrefix(strings.TrimSpace(name), ItemNamePrefix)
}

// UsageNotMeasurable says why the dashboard shows no integration use counts.
const UsageNotMeasurable = "Uses are not measurable yet: usage records name the tool, model, project and team, but not which integration's tools were called."

// ReachSource is one current assignment that hands a team an integration.
// Project is empty for the team default.
type ReachSource struct {
	Project, Pack, PackVersion, ItemVersion string
}

// Reach is one configured integration that a team's current pack
// assignments hold.
type Reach struct {
	TeamID, TeamName string
	TileID, TileName string
	Sources          []ReachSource
}

// ReachByTeam lists, per team, the company's configured integrations held by
// its current assignments: the team default and every unexpired project
// override. versions maps pack version IDs to loaded versions; an assignment
// whose version is missing is skipped. Only MCP template items whose name is a
// configuration's item name count. Rows sort by team name, team ID, then
// integration name and ID; a row's sources sort with the team default first,
// then by project, pack and version.
func ReachByTeam(tiles []Tile, configs []Configuration, assignments []pack.Assignment, versions map[string]pack.PackVersion) []Reach {
	names := make(map[string]string, len(tiles))
	for _, tile := range tiles {
		names[tile.ID] = tile.Name
	}
	byItem := make(map[string]string, len(configs))
	for _, config := range configs {
		byItem[config.Item.Name] = config.TileID
	}
	rows := map[[2]string]*Reach{}
	for _, assignment := range assignments {
		if assignment.ProjectExpired {
			continue
		}
		version, ok := versions[assignment.PackVersionID]
		if !ok {
			continue
		}
		for _, item := range version.Items {
			tileID, configured := byItem[item.Name]
			if item.Kind != pack.KindMCPTemplate || !configured {
				continue
			}
			key := [2]string{assignment.TeamID, tileID}
			row := rows[key]
			if row == nil {
				name := names[tileID]
				if name == "" {
					name = tileID
				}
				row = &Reach{TeamID: assignment.TeamID, TeamName: assignment.TeamName, TileID: tileID, TileName: name}
				rows[key] = row
			}
			row.Sources = append(row.Sources, ReachSource{Project: assignment.ProjectName, Pack: version.Name, PackVersion: version.Version, ItemVersion: item.Version})
		}
	}
	out := make([]Reach, 0, len(rows))
	for _, row := range rows {
		slices.SortFunc(row.Sources, func(a, b ReachSource) int {
			return cmp.Or(cmp.Compare(a.Project, b.Project), cmp.Compare(a.Pack, b.Pack), cmp.Compare(a.PackVersion, b.PackVersion))
		})
		out = append(out, *row)
	}
	slices.SortFunc(out, func(a, b Reach) int {
		return cmp.Or(cmp.Compare(a.TeamName, b.TeamName), cmp.Compare(a.TeamID, b.TeamID), cmp.Compare(a.TileName, b.TileName), cmp.Compare(a.TileID, b.TileID))
	})
	return out
}
```

### Code: internal/integration/reach_test.go (new)

sha256 `62ca52cd47ec6c292e46dff6f666f221530c6c41fd8b5d48947984e82c22dfd7`

```go
package integration

import (
	"reflect"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

func TestReachByTeam(t *testing.T) {
	tiles := []Tile{{ID: "github", Name: "GitHub"}, {ID: "clickup", Name: "ClickUp"}}
	configs := []Configuration{{TileID: "github", Item: library.Item{Name: "integration-github"}}, {TileID: "clickup", Item: library.Item{Name: "integration-clickup"}}, {TileID: "retired", Item: library.Item{Name: "integration-retired"}}}
	item := func(kind pack.Kind, name, version string) pack.Item {
		return pack.Item{Kind: kind, Name: name, Version: version}
	}
	versions := map[string]pack.PackVersion{
		"v-gh":    {Name: "With GitHub", Version: "p1", Items: []pack.Item{item(pack.KindSkill, "review", "1.0.0"), item(pack.KindMCPTemplate, "integration-github", "1.0.0")}},
		"v-both":  {Name: "Both", Version: "p2", Items: []pack.Item{item(pack.KindMCPTemplate, "integration-clickup", "1.0.2"), item(pack.KindMCPTemplate, "integration-github", "1.0.1"), item(pack.KindMCPTemplate, "integration-retired", "1.0.0")}},
		"v-plain": {Name: "Plain", Version: "p3", Items: []pack.Item{item(pack.KindSkill, "integration-github", "1.0.0"), item(pack.KindMCPTemplate, "github-mcp", "1.0.0")}},
	}
	assignments := []pack.Assignment{
		{TeamID: "t2", TeamName: "Beta", PackVersionID: "v-both", ProjectName: "web"},
		{TeamID: "t1", TeamName: "Alpha", PackVersionID: "v-gh"},
		{TeamID: "t1", TeamName: "Alpha", PackVersionID: "v-both", ProjectName: "api"},
		{TeamID: "t1", TeamName: "Alpha", PackVersionID: "v-gh", ProjectName: "old", ProjectExpired: true},
		{TeamID: "t3", TeamName: "Gamma", PackVersionID: "v-plain"},
		{TeamID: "t4", TeamName: "Delta", PackVersionID: "missing"},
	}
	got := ReachByTeam(tiles, configs, assignments, versions)
	want := []Reach{
		{TeamID: "t1", TeamName: "Alpha", TileID: "clickup", TileName: "ClickUp", Sources: []ReachSource{{Project: "api", Pack: "Both", PackVersion: "p2", ItemVersion: "1.0.2"}}},
		{TeamID: "t1", TeamName: "Alpha", TileID: "github", TileName: "GitHub", Sources: []ReachSource{{Pack: "With GitHub", PackVersion: "p1", ItemVersion: "1.0.0"}, {Project: "api", Pack: "Both", PackVersion: "p2", ItemVersion: "1.0.1"}}},
		{TeamID: "t1", TeamName: "Alpha", TileID: "retired", TileName: "retired", Sources: []ReachSource{{Project: "api", Pack: "Both", PackVersion: "p2", ItemVersion: "1.0.0"}}},
		{TeamID: "t2", TeamName: "Beta", TileID: "clickup", TileName: "ClickUp", Sources: []ReachSource{{Project: "web", Pack: "Both", PackVersion: "p2", ItemVersion: "1.0.2"}}},
		{TeamID: "t2", TeamName: "Beta", TileID: "github", TileName: "GitHub", Sources: []ReachSource{{Project: "web", Pack: "Both", PackVersion: "p2", ItemVersion: "1.0.1"}}},
		{TeamID: "t2", TeamName: "Beta", TileID: "retired", TileName: "retired", Sources: []ReachSource{{Project: "web", Pack: "Both", PackVersion: "p2", ItemVersion: "1.0.0"}}},
	}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("ReachByTeam =\n%+v\nwant\n%+v", got, want)
	}
	if got := ReachByTeam(tiles, nil, assignments, versions); len(got) != 0 {
		t.Fatalf("no configurations: %+v", got)
	}
}

func TestConfiguredItemName(t *testing.T) {
	for _, c := range []struct {
		kind pack.Kind
		name string
		want bool
	}{{pack.KindMCPTemplate, "integration-github", true}, {pack.KindMCPTemplate, " integration-x", true}, {pack.KindMCPTemplate, "github-mcp", false}, {pack.KindSkill, "integration-github", false}, {pack.KindMCPTemplate, "integration", false}} {
		if got := ConfiguredItemName(c.kind, c.name); got != c.want {
			t.Fatalf("ConfiguredItemName(%s, %q)=%v", c.kind, c.name, got)
		}
	}
}
```

### Code: internal/itembuilder/legacy_integration_test.go (new)

sha256 `ef8dcdb2da93cadb01dc10401c5c9239ab84fba3073d9f0db9d56be3bde9bdb2`

```go
package itembuilder

import (
	"context"
	"errors"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// Story 86bcm928t: the older one-item form must not change a configured
// integration's item, which only the Integrations page (and its audit) may.
func TestLegacyEditRefusesConfiguredIntegrationItem(t *testing.T) {
	actor := store.Principal{TenantID: "tenant", UserID: "admin"}
	body := `{"mcpServers":{"github":{"url":"https://elsewhere.example.test/mcp"}}}`
	for _, name := range []string{"integration-github", " integration-clickup", "integration-anything"} {
		v := &versions{parent: pack.PackVersion{Name: "Engineering", Version: "v1"}}
		in := Input{ParentVersion: "v1", Kind: pack.KindMCPTemplate, Name: name, Version: "1.0.9", Description: "GitHub", Body: body}
		if _, err := New(v, scanner{}).PreviewLegacy(context.Background(), actor, in); !errors.Is(err, ErrInvalid) {
			t.Fatalf("PreviewLegacy %q err=%v, want ErrInvalid", name, err)
		}
		if _, err := New(v, scanner{}).SaveLegacy(context.Background(), actor, in); !errors.Is(err, ErrInvalid) || v.calls != 0 {
			t.Fatalf("SaveLegacy %q err=%v calls=%d, want ErrInvalid and no save", name, err, v.calls)
		}
	}
	// Other names and kinds keep working: the rule is the reserved name space only.
	v := &versions{parent: pack.PackVersion{Name: "Engineering", Version: "v1"}}
	in := Input{ParentVersion: "v1", Kind: pack.KindSkill, Name: "integration-notes", Version: "1.0.0", Description: "Notes", Body: "# Notes\n"}
	if _, err := New(v, scanner{}).SaveLegacy(context.Background(), actor, in); err != nil || v.calls != 1 {
		t.Fatalf("a skill named integration-notes err=%v calls=%d", err, v.calls)
	}
}
```

### Code: internal/web/integration_governance_component_test.go (new)

sha256 `8e0b6ee7d0a4cdc4172eb0ca1a736f07e1db423801235ca6cb061ad747307ae6`

```go
package web

import (
	"net/http"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/metric"
)

// Story 86bcm928t: without the integrations service the content usage page
// says integration assignments are unavailable instead of an empty table.
func TestContentUsageIntegrationsUnavailableWithoutWiring(t *testing.T) {
	_, base, client := contentUsageHandler(t, func(metric.ItemUsageFilter) (metric.ItemUsageData, error) {
		return metric.ItemUsageData{}, nil
	})
	response := request(t, client, http.MethodGet, base+"/admin/content-usage", "", "")
	assertStatus(t, response, http.StatusOK)
	section := pageSection(t, readBody(t, response), "integrations-by-team")
	if !strings.Contains(section, `id="integrations-unavailable"`) || strings.Contains(section, "<table") {
		t.Fatalf("unwired integrations section: %s", section)
	}
}
```

### Code: internal/web/integration_governance_test.go (new): AC test file

sha256 `503c3ec4659b60a0cb8ac41223aa717024374fffd4b848863871d14b6fbbb288`

```go
package web

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/url"
	"os"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/audit"
	"github.com/LeornaAI/leorna-control-plane/internal/integration"
	"github.com/LeornaAI/leorna-control-plane/internal/itembuilder"
	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
	"github.com/LeornaAI/leorna-control-plane/internal/metric"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/project"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"
	"github.com/google/uuid"
)

// Story 86bcm928t. Company A configures GitHub Enterprise Server at
// governanceAlphaOrigin, company B at governanceBetaOrigin; each origin appears
// only inside its own company's rendered MCP item.
const (
	governanceAlphaOrigin = "https://github.alpha-governance.example.test"
	governanceBetaOrigin  = "https://github.beta-governance.example.test"
)

// governanceFixture: company A has five teams.
//   - Team X: default "With GitHub". Project X uses it; Project X2 overrides with "Plain".
//   - Team Y: default "Plain". Project Y1 overrides with "With GitHub"; Project Y2 uses the default.
//   - Team Z: default "Plain". Project Z overrides with "With GitHub" but is expired.
//   - Team W: default "Plain" only.
//   - Team N: no assignment.
//
// ClickUp is configured but in no pack. Company B has one team whose default
// pack holds its own GitHub configuration.
type governanceFixture struct {
	packFixture
	github, clickup, betaGitHub                 integration.Configuration
	teamX, teamY, teamZ, teamW, teamN, betaTeam org.Team
	projectX, projectX2, projectY1, projectY2   project.Project
	projectZ, projectW, projectN, betaProject   project.Project
	engineerX, engineerY, engineerN, betaMember store.Principal
	withGitHub, plain, betaPack                 pack.BuiltVersion
	alphaScoped, betaScoped                     context.Context
}

func newGovernanceFixture(t *testing.T) governanceFixture {
	t.Helper()
	f := newIntegrationFixture(t)
	f.handler.SetBundleServer(f.repository)
	f.handler.SetClientAuth(f.repository)
	// One deployment serves one company: the desktop API admits only company A's tokens.
	// BackendUrl and discoveryHost name the test server, as the custom-domain
	// story's (86bccndx6) canonical-host check expects once it is on main.
	f.handler.discovery = &contracts.ClientDiscovery{BackendUrl: f.server.URL, TenantId: uuid.MustParse(string(f.admin.TenantID)), TenantName: "Alpha"}
	f.handler.discoveryHost = strings.TrimPrefix(f.server.URL, "https://")
	g := governanceFixture{packFixture: f}
	g.alphaScoped = store.WithTenant(context.Background(), f.admin.TenantID)
	g.betaScoped = store.WithTenant(context.Background(), f.other.TenantID)

	admin := f.login(t, f.admin, strings.Repeat("a", 43))
	postIntegration(t, f, admin, "github", integrationForm(f, "enterprise-server", "0", governanceAlphaOrigin), 303)
	postIntegration(t, f, admin, "clickup", integrationForm(f, "cloud", "0", ""), 303)
	beta := f.login(t, f.other, strings.Repeat("b", 43))
	postIntegration(t, f, beta, "github", integrationForm(f, "enterprise-server", "0", governanceBetaOrigin), 303)
	var err error
	if g.github, err = f.repository.GetIntegrationConfiguration(g.alphaScoped, f.admin, "github"); err != nil {
		t.Fatal(err)
	}
	if g.clickup, err = f.repository.GetIntegrationConfiguration(g.alphaScoped, f.admin, "clickup"); err != nil {
		t.Fatal(err)
	}
	if g.betaGitHub, err = f.repository.GetIntegrationConfiguration(g.betaScoped, f.other, "github"); err != nil {
		t.Fatal(err)
	}

	skillID := governanceSkill(t, f)
	builder := pack.NewBuilderService(f.repository)
	if g.withGitHub, err = builder.CreatePack(g.alphaScoped, f.admin, "With GitHub", []string{skillID, g.github.ID}); err != nil {
		t.Fatal(err)
	}
	if g.plain, err = builder.CreatePack(g.alphaScoped, f.admin, "Plain", []string{skillID}); err != nil {
		t.Fatal(err)
	}
	if g.betaPack, err = builder.CreatePack(g.betaScoped, f.other, "Beta GitHub", []string{skillID, g.betaGitHub.ID}); err != nil {
		t.Fatal(err)
	}

	g.engineerX = f.member
	g.engineerY = governanceUser(t, f, f.admin.TenantID, "governance-y")
	g.engineerN = governanceUser(t, f, f.admin.TenantID, "governance-n")
	g.betaMember = governanceUser(t, f, f.other.TenantID, "governance-beta")
	team := func(scoped context.Context, owner store.Principal, name string, members ...store.Principal) org.Team {
		t.Helper()
		created, err := f.repository.CreateTeam(scoped, owner, name)
		if err != nil {
			t.Fatal(err)
		}
		for _, member := range members {
			if err := f.repository.AddTeamMember(scoped, owner, created.ID, string(member.UserID)); err != nil {
				t.Fatal(err)
			}
		}
		return created
	}
	g.teamX = team(g.alphaScoped, f.admin, "Team X", g.engineerX)
	g.teamY = team(g.alphaScoped, f.admin, "Team Y", g.engineerY)
	g.teamZ = team(g.alphaScoped, f.admin, "Team Z")
	g.teamW = team(g.alphaScoped, f.admin, "Team W")
	g.teamN = team(g.alphaScoped, f.admin, "Team N", g.engineerN)
	g.betaTeam = team(g.betaScoped, f.other, "Beta team", g.betaMember)
	newProject := func(scoped context.Context, owner store.Principal, teamID, name string) project.Project {
		t.Helper()
		created, err := f.repository.CreateProject(scoped, owner, teamID, name, time.Now().Add(24*time.Hour))
		if err != nil {
			t.Fatal(err)
		}
		return created
	}
	g.projectX = newProject(g.alphaScoped, f.admin, g.teamX.ID, "x-main")
	g.projectX2 = newProject(g.alphaScoped, f.admin, g.teamX.ID, "x-side")
	g.projectY1 = newProject(g.alphaScoped, f.admin, g.teamY.ID, "y-one")
	g.projectY2 = newProject(g.alphaScoped, f.admin, g.teamY.ID, "y-two")
	g.projectZ = newProject(g.alphaScoped, f.admin, g.teamZ.ID, "z-old")
	g.projectW = newProject(g.alphaScoped, f.admin, g.teamW.ID, "w-main")
	g.projectN = newProject(g.alphaScoped, f.admin, g.teamN.ID, "n-main")
	g.betaProject = newProject(g.betaScoped, f.other, g.betaTeam.ID, "beta-main")

	assignTeam := func(scoped context.Context, owner store.Principal, teamID string, built pack.BuiltVersion) {
		t.Helper()
		if _, err := f.repository.AssignTeam(scoped, owner, teamID, built.Version.Version); err != nil {
			t.Fatal(err)
		}
	}
	assignProject := func(projectID string, built pack.BuiltVersion) {
		t.Helper()
		if _, err := f.repository.AssignProject(g.alphaScoped, f.admin, projectID, built.Version.Version); err != nil {
			t.Fatal(err)
		}
	}
	assignTeam(g.alphaScoped, f.admin, g.teamX.ID, g.withGitHub)
	assignProject(g.projectX2.ID, g.plain)
	assignTeam(g.alphaScoped, f.admin, g.teamY.ID, g.plain)
	assignProject(g.projectY1.ID, g.withGitHub)
	assignTeam(g.alphaScoped, f.admin, g.teamZ.ID, g.plain)
	assignProject(g.projectZ.ID, g.withGitHub)
	assignTeam(g.alphaScoped, f.admin, g.teamW.ID, g.plain)
	assignTeam(g.betaScoped, f.other, g.betaTeam.ID, g.betaPack)
	if _, err := f.pool.Exec(context.Background(), `UPDATE projects SET expires_at=now()-interval '1 hour' WHERE id=$1`, g.projectZ.ID); err != nil {
		t.Fatal(err)
	}
	return g
}

// governanceSkill stores one shipped single-file skill as a library row, so
// both companies' packs can hold it next to their integration.
func governanceSkill(t *testing.T, f packFixture) string {
	t.Helper()
	shipped, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	for _, item := range shipped.Items {
		if item.Kind == pack.KindSkill && len(item.Files) == 0 {
			for _, id := range insertLibraryItems(t, f.pool, item) {
				return id
			}
		}
	}
	t.Fatal("no shipped single-file skill")
	return ""
}

func governanceUser(t *testing.T, f packFixture, tenant store.TenantID, subject string) store.Principal {
	t.Helper()
	principal := store.Principal{UserID: store.UserID(uuid.NewString()), TenantID: tenant}
	if err := f.repository.CreateUser(store.WithTenant(context.Background(), tenant), store.User{ID: principal.UserID, TenantID: tenant, Provider: "google", ProviderSubject: subject, Email: subject + "@example.com", DisplayName: subject}); err != nil {
		t.Fatal(err)
	}
	return principal
}

// governanceClient sends one desktop request with a bearer token and returns
// the status and a bounded body.
func governanceClient(t *testing.T, g governanceFixture, token, path string) (int, string) {
	t.Helper()
	request, err := http.NewRequest(http.MethodGet, g.server.URL+path, nil)
	if err != nil {
		t.Fatal(err)
	}
	request.Header.Set("Authorization", "Bearer "+token)
	response, err := g.server.Client().Do(request)
	if err != nil {
		t.Fatal(err)
	}
	defer func() { _ = response.Body.Close() }()
	return response.StatusCode, readBody(t, response)
}

// governanceSync runs the desktop Sync reads for one project: the manifest,
// then the bodies for its digest. It returns the manifest status, the
// manifest's item names and the joined item bodies.
func governanceSync(t *testing.T, g governanceFixture, token, projectID string) (int, contracts.ClientBundleStatus, []string, string) {
	t.Helper()
	status, body := governanceClient(t, g, token, "/v1/client/projects/"+projectID+"/bundle")
	if status != http.StatusOK {
		return status, "", nil, ""
	}
	var bundle contracts.ClientBundle
	if err := json.Unmarshal([]byte(body), &bundle); err != nil {
		t.Fatal(err)
	}
	names := []string{}
	for _, file := range bundle.Manifest.Files {
		names = append(names, string(file.Kind)+"/"+file.Name)
	}
	if bundle.Status != contracts.Assigned {
		return status, bundle.Status, names, ""
	}
	contentStatus, content := governanceClient(t, g, token, "/v1/client/projects/"+projectID+"/bundles/"+bundle.Lockfile.Digest+"/content")
	if contentStatus != http.StatusOK {
		t.Fatalf("bundle content status=%d want 200", contentStatus)
	}
	var items contracts.ClientBundleContent
	if err := json.Unmarshal([]byte(content), &items); err != nil {
		t.Fatal(err)
	}
	bodies := []string{}
	for _, item := range items.Items {
		bodies = append(bodies, item.Body)
	}
	return status, bundle.Status, names, strings.Join(bodies, "\n")
}

const governanceGitHubItem = "mcp_template/integration-github"

func TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres(t *testing.T) {
	g := newGovernanceFixture(t)
	tokenX := mintStarterDesktopToken(t, g.packFixture, g.engineerX)
	tokenY := mintStarterDesktopToken(t, g.packFixture, g.engineerY)
	tokenN := mintStarterDesktopToken(t, g.packFixture, g.engineerN)
	tokenBeta := mintStarterDesktopToken(t, g.packFixture, g.betaMember)

	t.Run("team default hands the team's engineer the integration", func(t *testing.T) {
		status, bundle, names, bodies := governanceSync(t, g, tokenX, g.projectX.ID)
		if status != 200 || bundle != contracts.Assigned || !slices.Contains(names, governanceGitHubItem) || !strings.Contains(bodies, governanceAlphaOrigin) {
			t.Fatalf("Project X: status=%d bundle=%q names=%v", status, bundle, names)
		}
		if strings.Contains(bodies, governanceBetaOrigin) {
			t.Fatal("company A's engineer received company B's integration")
		}
	})
	t.Run("project override without the integration wins over the team default", func(t *testing.T) {
		status, bundle, names, bodies := governanceSync(t, g, tokenX, g.projectX2.ID)
		if status != 200 || bundle != contracts.Assigned || slices.Contains(names, governanceGitHubItem) || strings.Contains(bodies, governanceAlphaOrigin) {
			t.Fatalf("Project X2: status=%d bundle=%q names=%v", status, bundle, names)
		}
	})
	t.Run("project override hands one project of another team the integration", func(t *testing.T) {
		if _, _, names, bodies := governanceSync(t, g, tokenY, g.projectY1.ID); !slices.Contains(names, governanceGitHubItem) || !strings.Contains(bodies, governanceAlphaOrigin) {
			t.Fatalf("Project Y1 names=%v", names)
		}
		if _, _, names, bodies := governanceSync(t, g, tokenY, g.projectY2.ID); slices.Contains(names, governanceGitHubItem) || strings.Contains(bodies, governanceAlphaOrigin) {
			t.Fatalf("Project Y2 names=%v", names)
		}
	})
	t.Run("another team's engineer cannot get it", func(t *testing.T) {
		for _, path := range []string{"/v1/client/projects/" + g.projectX.ID + "/bundle", "/v1/client/projects/" + g.projectX.ID + "/bundles/" + strings.Repeat("0", 64) + "/content"} {
			if status, body := governanceClient(t, g, tokenY, path); status != http.StatusNotFound || strings.Contains(body, governanceAlphaOrigin) {
				t.Fatalf("Team Y engineer %s status=%d", path, status)
			}
		}
		if _, err := g.repository.ResolveForProject(g.alphaScoped, g.engineerY, g.projectX.ID); !errors.Is(err, store.ErrNotFound) {
			t.Fatalf("store resolved Team X's project for a Team Y engineer: %v", err)
		}
		if status, bundle, names, _ := governanceSync(t, g, tokenN, g.projectN.ID); status != 200 || bundle != contracts.Empty || len(names) != 0 {
			t.Fatalf("unassigned team: status=%d bundle=%q names=%v", status, bundle, names)
		}
	})
	t.Run("another company's engineer cannot get it", func(t *testing.T) {
		for _, path := range []string{"/v1/client/projects/" + g.projectX.ID + "/bundle", "/v1/client/projects/" + g.projectY1.ID + "/bundle", "/v1/client/projects/" + g.projectX.ID + "/bundles/" + strings.Repeat("0", 64) + "/content", "/v1/client/integration-tiles"} {
			if status, body := governanceClient(t, g, tokenBeta, path); status != http.StatusForbidden || strings.Contains(body, governanceAlphaOrigin) {
				t.Fatalf("company B engineer %s status=%d, want 403", path, status)
			}
		}
		// Below the desktop API's company check, the store itself never
		// resolves another company's project.
		for _, projectID := range []string{g.projectX.ID, g.projectY1.ID} {
			if _, err := g.repository.ResolveForProject(g.betaScoped, g.betaMember, projectID); !errors.Is(err, store.ErrNotFound) {
				t.Fatalf("store resolved company A's project for company B: %v", err)
			}
		}
		own, err := g.repository.ResolveForProject(g.betaScoped, g.betaMember, g.betaProject.ID)
		if err != nil {
			t.Fatal(err)
		}
		var bodies []string
		for _, item := range own.Items {
			bodies = append(bodies, item.Body)
		}
		if joined := strings.Join(bodies, "\n"); !strings.Contains(joined, governanceBetaOrigin) || strings.Contains(joined, governanceAlphaOrigin) {
			t.Fatal("company B's own pack does not carry only its own integration")
		}
	})
	t.Run("the desktop tile list carries no company settings", func(t *testing.T) {
		for _, token := range []string{tokenX, tokenY, tokenN} {
			status, body := governanceClient(t, g, token, "/v1/client/integration-tiles")
			if status != 200 || strings.Contains(body, governanceAlphaOrigin) || strings.Contains(body, governanceBetaOrigin) || strings.Contains(body, "mcpServers") {
				t.Fatalf("tile list status=%d leaks company settings or templates", status)
			}
		}
	})
	t.Run("removing it from the assigned pack stops delivery", func(t *testing.T) {
		builder := pack.NewBuilderService(g.repository)
		next, err := builder.SaveVersion(g.alphaScoped, g.admin, g.withGitHub.PackID, g.withGitHub.Version.Version, pack.VersionChange{Remove: []pack.ItemKey{{Kind: pack.KindMCPTemplate, Name: "integration-github"}}})
		if err != nil {
			t.Fatal(err)
		}
		if _, err := g.repository.AssignTeam(g.alphaScoped, g.admin, g.teamX.ID, next.Version.Version); err != nil {
			t.Fatal(err)
		}
		if _, _, names, bodies := governanceSync(t, g, tokenX, g.projectX.ID); slices.Contains(names, governanceGitHubItem) || strings.Contains(bodies, governanceAlphaOrigin) {
			t.Fatalf("after removal names=%v", names)
		}
	})
}

func TestIntegrationGovernanceAC2DashboardByTeamWithPostgres(t *testing.T) {
	g := newGovernanceFixture(t)
	empty := itemUsageReaderFunc(func(context.Context, store.Principal, metric.ItemUsageFilter) (metric.ItemUsageData, error) {
		return metric.ItemUsageData{}, nil
	})
	g.handler.SetMetrics(empty)
	g.handler.SetPackVersions(pack.NewVersionService(g.repository))
	admin := g.login(t, g.admin, strings.Repeat("d", 43))

	page := g.get(t, admin, "/admin/content-usage", http.StatusOK)
	section := pageSection(t, page, "integrations-by-team")
	got := sectionRows(section)
	want := [][]string{
		{"Team X", "GitHub", "Team default: With GitHub " + g.withGitHub.Version.Version + " item " + g.github.Item.Version, "Not measurable"},
		{"Team Y", "GitHub", "Project y-one: With GitHub " + g.withGitHub.Version.Version + " item " + g.github.Item.Version, "Not measurable"},
	}
	if !slices.EqualFunc(got, want, slices.Equal[[]string]) {
		t.Fatalf("integrations by team rows=%q want %q", got, want)
	}
	for _, wantText := range []string{
		`data-team="` + g.teamX.ID + `" data-integration="github"`,
		`data-team="` + g.teamY.ID + `" data-integration="github"`,
		"Uses are not measurable yet: usage records name the tool, model, project and team, but not which integration&#39;s tools were called.",
	} {
		if !strings.Contains(section, wantText) {
			t.Fatalf("integrations section lacks %q", wantText)
		}
	}
	for _, absent := range []string{"Team Z", "Team W", "Team N", "ClickUp", "Beta team", g.betaTeam.ID} {
		if strings.Contains(section, absent) {
			t.Fatalf("integrations section shows %q", absent)
		}
	}

	beta := g.login(t, g.other, strings.Repeat("e", 43))
	betaSection := pageSection(t, g.get(t, beta, "/admin/content-usage", http.StatusOK), "integrations-by-team")
	if rows := sectionRows(betaSection); len(rows) != 1 || rows[0][0] != "Beta team" || rows[0][1] != "GitHub" {
		t.Fatalf("company B rows=%q", rows)
	}
	for _, absent := range []string{"Team X", "Team Y", g.teamX.ID} {
		if strings.Contains(betaSection, absent) {
			t.Fatalf("company B sees company A's %q", absent)
		}
	}

	member := g.login(t, g.member, strings.Repeat("m", 43))
	response := request(t, member, http.MethodGet, g.server.URL+"/admin/content-usage", "", "")
	defer func() { _ = response.Body.Close() }()
	if response.StatusCode != http.StatusForbidden {
		t.Fatalf("member content usage status=%d want 403", response.StatusCode)
	}
}

func TestIntegrationGovernanceAC3ChangeAuditWithPostgres(t *testing.T) {
	f := newIntegrationFixture(t)
	versions := pack.NewVersionService(f.repository)
	f.handler.SetPackVersions(versions)
	scanner := os.Getenv("LEORNA_TEST_GITLEAKS_BIN")
	if scanner == "" {
		scanner = "gitleaks"
	}
	f.handler.SetItemBuilder(itembuilder.New(versions, gate.NewGitleaks(scanner)))
	scoped := store.WithTenant(context.Background(), f.admin.TenantID)
	client := f.login(t, f.admin, strings.Repeat("a", 43))
	const first, second = "https://audit-first.example.test", "https://audit-second.example.test"

	postIntegration(t, f, client, "github", integrationForm(f, "enterprise-server", "0", first), 303)
	config := integrationState(t, f)
	team, err := f.repository.CreateTeam(scoped, f.admin, "Audit team")
	if err != nil {
		t.Fatal(err)
	}
	skillID := governanceSkill(t, f)
	builder := pack.NewBuilderService(f.repository)
	created, err := builder.CreatePack(scoped, f.admin, "Audited pack", []string{skillID, config.ID})
	if err != nil {
		t.Fatal(err)
	}
	if _, err := f.repository.AssignTeam(scoped, f.admin, team.ID, created.Version.Version); err != nil {
		t.Fatal(err)
	}
	postIntegration(t, f, client, "github", integrationForm(f, "enterprise-server", "1", second), 303)
	removed, err := builder.SaveVersion(scoped, f.admin, created.PackID, created.Version.Version, pack.VersionChange{Remove: []pack.ItemKey{{Kind: pack.KindMCPTemplate, Name: "integration-github"}}})
	if err != nil {
		t.Fatal(err)
	}
	readded, err := builder.SaveVersion(scoped, f.admin, created.PackID, removed.Version.Version, pack.VersionChange{AddLibraryItemIDs: []string{config.ID}})
	if err != nil {
		t.Fatal(err)
	}
	if _, err := f.repository.AssignTeam(scoped, f.admin, team.ID, readded.Version.Version); err != nil {
		t.Fatal(err)
	}

	read := func(filter audit.Filter) []audit.Record {
		t.Helper()
		filter.Limit = 100
		records, err := f.repository.ListAudit(scoped, f.admin, filter)
		if err != nil {
			t.Fatal(err)
		}
		return records
	}
	itemRefs := func(raw json.RawMessage, list string) []pack.ItemRef {
		t.Helper()
		var record struct {
			Diff map[string][]pack.ItemRef `json:"diff"`
		}
		if err := json.Unmarshal(raw, &record); err != nil {
			t.Fatal(err)
		}
		return record.Diff[list]
	}
	hasGitHub := func(refs []pack.ItemRef, version string) bool {
		return slices.ContainsFunc(refs, func(ref pack.ItemRef) bool {
			return ref.Kind == pack.KindMCPTemplate && ref.Name == "integration-github" && ref.Version == version
		})
	}

	t.Run("settings changes are integration records on the configuration", func(t *testing.T) {
		var actions []string
		for _, record := range read(audit.Filter{Target: config.ID}) {
			actions = append(actions, record.Action)
		}
		if !slices.Equal(actions, []string{"integration.update", "integration.configure"}) {
			t.Fatalf("configuration audit actions=%v", actions)
		}
	})
	t.Run("pack adds and removes name the integration item", func(t *testing.T) {
		records := read(audit.Filter{Target: created.PackID})
		var actions []string
		for _, record := range records {
			actions = append(actions, record.Action)
		}
		if !slices.Equal(actions, []string{"pack.version.create", "pack.version.create", "pack.create"}) {
			t.Fatalf("pack audit actions=%v", actions)
		}
		if !hasGitHub(itemRefs(records[2].After, "added"), "1.0.0") {
			t.Fatal("pack.create does not list the added integration")
		}
		if !hasGitHub(itemRefs(records[1].After, "removed"), "1.0.0") {
			t.Fatal("pack.version.create does not list the removed integration")
		}
		if !hasGitHub(itemRefs(records[0].After, "added"), "1.0.1") {
			t.Fatal("pack.version.create does not list the re-added integration revision")
		}
	})
	t.Run("assigning a pack that holds it is recorded", func(t *testing.T) {
		count := 0
		for _, record := range read(audit.Filter{}) {
			if record.Action == "pack.assign" && strings.Contains(string(record.After), team.ID) {
				count++
			}
		}
		if count != 2 {
			t.Fatalf("pack.assign records for the team=%d want 2", count)
		}
	})
	t.Run("the older pack version form cannot change the integration item", func(t *testing.T) {
		before := len(read(audit.Filter{}))
		history, err := versions.History(scoped, f.admin)
		if err != nil {
			t.Fatal(err)
		}
		body := strings.ReplaceAll(readdedGitHubBody(t, readded), second, "https://elsewhere.example.test")
		for _, commit := range []string{"", "1"} {
			form := url.Values{"csrfToken": {f.csrf}, "parent_version": {readded.Version.Version}, "kind": {"mcp_template"}, "name": {"integration-github"}, "version": {"1.0.9"}, "description": {config.Item.Description}, "body": {body}, "target_key": {"team:" + team.ID}, "draft_inline": {"1"}}
			if commit == "1" {
				form.Set("commit", "1")
				form.Set("preview_digest", strings.Repeat("0", 64))
				form.Del("draft_inline")
			}
			response, err := client.PostForm(f.server.URL+"/admin/packs/versions/edit", form)
			if err != nil {
				t.Fatal(err)
			}
			_ = response.Body.Close()
			if response.StatusCode != http.StatusUnprocessableEntity {
				t.Fatalf("older form status=%d (commit=%q), want 422", response.StatusCode, commit)
			}
		}
		after, err := versions.History(scoped, f.admin)
		if err != nil {
			t.Fatal(err)
		}
		if len(after) != len(history) || len(read(audit.Filter{})) != before {
			t.Fatal("refused change wrote a version or an audit record")
		}
	})
	t.Run("records carry no settings and stay in the company", func(t *testing.T) {
		for _, record := range read(audit.Filter{}) {
			raw := string(record.Before) + string(record.After)
			for _, secret := range []string{first, second, "elsewhere.example.test", "mcpServers"} {
				if strings.Contains(raw, secret) {
					t.Fatalf("%s record contains %q", record.Action, secret)
				}
			}
		}
		other := store.WithTenant(context.Background(), f.other.TenantID)
		for _, target := range []string{config.ID, created.PackID} {
			records, err := f.repository.ListAudit(other, f.other, audit.Filter{Target: target, Limit: 100})
			if err != nil || len(records) != 0 {
				t.Fatalf("company B sees %d records for %s (err %v)", len(records), target, err)
			}
		}
	})
	t.Run("the change history page shows them", func(t *testing.T) {
		page := f.get(t, client, "/admin/audit", http.StatusOK)
		for _, action := range []string{"integration.configure", "integration.update", "pack.create", "pack.version.create", "pack.assign"} {
			if !strings.Contains(page, "<code>"+action+"</code>") {
				t.Fatalf("change history lacks %s", action)
			}
		}
	})
}

func readdedGitHubBody(t *testing.T, built pack.BuiltVersion) string {
	t.Helper()
	for _, item := range built.Version.Items {
		if item.Kind == pack.KindMCPTemplate && item.Name == "integration-github" {
			return item.Body
		}
	}
	t.Fatal("re-added version lacks the integration")
	return ""
}
```

### Code: Production patch for internal/itembuilder/builder.go and internal/web/content_usage.go (apply with `git apply`; checked with `git apply --check` on base)

sha256 `8bc790412e0d0fe9193b4694427e1038808631fe0c18a9f7e26992af1ef1a5e4`

```diff
--- a/internal/itembuilder/builder.go
+++ b/internal/itembuilder/builder.go
@@ -5,6 +5,7 @@
 	"context"
 	"errors"
 
+	"github.com/LeornaAI/leorna-control-plane/internal/integration"
 	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
 	"github.com/LeornaAI/leorna-control-plane/internal/pack"
 	"github.com/LeornaAI/leorna-control-plane/internal/store"
@@ -190,6 +191,11 @@
 }
 
 func (b *Builder) prepareLegacy(ctx context.Context, actor store.Principal, in Input) (pack.ItemEdit, []gate.ToolResult, error) {
+	// A configured integration's item changes only on the Integrations page,
+	// whose saves write the integration audit records (86bcm928t).
+	if integration.ConfiguredItemName(in.Kind, in.Name) {
+		return pack.ItemEdit{}, nil, invalid("name", "Change a configured integration on its Integrations page")
+	}
 	parent, err := b.versions.Preview(ctx, actor, in.ParentVersion)
 	if err != nil {
 		return pack.ItemEdit{}, nil, err
--- a/internal/web/content_usage.go
+++ b/internal/web/content_usage.go
@@ -9,6 +9,7 @@
 	"strings"
 	"time"
 
+	"github.com/LeornaAI/leorna-control-plane/internal/integration"
 	"github.com/LeornaAI/leorna-control-plane/internal/metric"
 	"github.com/LeornaAI/leorna-control-plane/internal/org"
 	"github.com/LeornaAI/leorna-control-plane/internal/pack"
@@ -49,15 +50,23 @@
 		handler.contentUsageFailure(w, r, err)
 		return
 	}
+	reach, reachable, err := handler.integrationReach(r)
+	if err != nil {
+		handler.contentUsageFailure(w, r, err)
+		return
+	}
 	data, err := reader.QueryItemUsage(r.Context(), teamActor(r), filter)
 	if err != nil {
 		handler.contentUsageFailure(w, r, err)
 		return
 	}
 	page := contentUsagePage{
-		From:   filter.Start.Format(time.DateOnly),
-		To:     filter.End.AddDate(0, 0, -1).Format(time.DateOnly),
-		Report: metric.BuildContentUsageReport(packs, data),
+		From:                  filter.Start.Format(time.DateOnly),
+		To:                    filter.End.AddDate(0, 0, -1).Format(time.DateOnly),
+		Report:                metric.BuildContentUsageReport(packs, data),
+		Integrations:          reach,
+		IntegrationsAvailable: reachable,
+		IntegrationsNote:      integration.UsageNotMeasurable,
 	}
 	page.Support = supportRows(page.Report.Support)
 	handler.renderContentUsagePage(w, r, page, http.StatusOK)
@@ -121,6 +130,40 @@
 	return packs, nil
 }
 
+// integrationReach lists the configured integrations each team's current
+// pack assignments hold (86bcm928t). The second result is false when the integrations
+// service or the assignment store is not wired, so the page says so instead
+// of showing an empty table. Every read is the admin's own tenant.
+func (handler *Handler) integrationReach(r *http.Request) ([]integration.Reach, bool, error) {
+	if handler.integrations == nil || handler.packAssignments == nil {
+		return nil, false, nil
+	}
+	actor := teamActor(r)
+	configs, err := handler.integrations.Configurations(r.Context(), actor)
+	if err != nil {
+		return nil, false, err
+	}
+	if len(configs) == 0 {
+		return []integration.Reach{}, true, nil
+	}
+	assignments, err := handler.packAssignments.ListAssignments(r.Context(), actor)
+	if err != nil {
+		return nil, false, err
+	}
+	versions := make(map[string]pack.PackVersion, len(assignments))
+	for _, assignment := range assignments {
+		if _, seen := versions[assignment.PackVersionID]; seen || assignment.ProjectExpired {
+			continue
+		}
+		version, err := handler.packVersions.PreviewByID(r.Context(), actor, assignment.PackVersionID)
+		if err != nil {
+			return nil, false, err
+		}
+		versions[assignment.PackVersionID] = version
+	}
+	return integration.ReachByTeam(handler.integrations.Tiles(), configs, assignments, versions), true, nil
+}
+
 // preferPackVersion reports whether candidate replaces current as a pack's
 // version: the company's own (TenantID equal to tenant) beats a shared
 // version, then the newer CreatedAt, then on equal CreatedAt the larger version
@@ -196,6 +239,9 @@
 	From, To, Nonce, FilterError string
 	Report                       metric.ContentUsageReport
 	Support                      []supportRow
+	Integrations                 []integration.Reach
+	IntegrationsAvailable        bool
+	IntegrationsNote             string
 }
 
 func contentToolLabel(tool string) string {
@@ -228,4 +274,5 @@
 {{if eq .Report.TotalUses 0}}<p class="card" id="empty">No item uses were recorded in this period.</p>{{end}}
 <section id="measurability" aria-labelledby="measurability-title"><h2 id="measurability-title">Where usage can be measured</h2><div class="table-wrap"><table><thead><tr><th>Tool</th><th>Skills</th><th>Prompts</th><th>Agents</th></tr></thead><tbody>{{range .Support}}<tr><td>{{tool .Tool}}</td>{{range .Cells}}<td data-tool="{{.Tool}}" data-kind="{{.Kind}}">{{if .Measured}}<span class="measured">Measured</span>{{else}}<span class="not-measurable">Not measurable</span>{{end}}<small>{{.Basis}}</small></td>{{end}}</tr>{{end}}</tbody></table></div></section>
 <section id="by-pack" aria-labelledby="by-pack-title"><h2 id="by-pack-title">By pack</h2><div class="table-wrap"><table><thead><tr><th>Pack</th><th>Latest version</th><th>Items</th><th>Items used</th><th>Uses</th></tr></thead><tbody>{{range .Report.Packs}}<tr><td>{{.Name}}</td><td>{{.Version}}</td><td>{{.Items}}</td><td>{{.ItemsUsed}}</td><td>{{.Uses}}</td></tr>{{else}}<tr><td colspan="5">No packs hold skills, prompts or agents yet.</td></tr>{{end}}</tbody></table></div></section>
-<section id="by-item" aria-labelledby="by-item-title"><h2 id="by-item-title">By item</h2><div class="table-wrap"><table><thead><tr><th>Item</th><th>Kind</th><th>Packs</th><th>Claude Code</th><th>Codex</th><th>Cursor</th><th>Total</th><th>People</th><th>Last used</th></tr></thead><tbody>{{range .Report.Items}}<tr data-kind="{{.Item.Kind}}" data-item="{{.Item.Name}}"><td>{{.Item.Name}}</td><td>{{.Item.Kind}}</td><td>{{if .Packs}}{{packs .Packs}}{{else}}<span class="muted">Not in a current pack</span>{{end}}</td>{{range .Cells}}<td data-tool="{{.Tool}}">{{if .Measured}}{{.Uses}}{{else}}<span class="not-measurable">Not measurable</span>{{end}}</td>{{end}}<td>{{if .Measurable}}{{.Total}}{{else}}—{{end}}</td><td>{{if .Measurable}}{{.People}}{{else}}—{{end}}</td><td>{{date .LastUsed}}</td></tr>{{else}}<tr><td colspan="9">No skills, prompts or agents are in a current pack or were used in this period.</td></tr>{{end}}</tbody></table></div></section>{{end}}</main></body></html>`))
+<section id="by-item" aria-labelledby="by-item-title"><h2 id="by-item-title">By item</h2><div class="table-wrap"><table><thead><tr><th>Item</th><th>Kind</th><th>Packs</th><th>Claude Code</th><th>Codex</th><th>Cursor</th><th>Total</th><th>People</th><th>Last used</th></tr></thead><tbody>{{range .Report.Items}}<tr data-kind="{{.Item.Kind}}" data-item="{{.Item.Name}}"><td>{{.Item.Name}}</td><td>{{.Item.Kind}}</td><td>{{if .Packs}}{{packs .Packs}}{{else}}<span class="muted">Not in a current pack</span>{{end}}</td>{{range .Cells}}<td data-tool="{{.Tool}}">{{if .Measured}}{{.Uses}}{{else}}<span class="not-measurable">Not measurable</span>{{end}}</td>{{end}}<td>{{if .Measurable}}{{.Total}}{{else}}—{{end}}</td><td>{{if .Measurable}}{{.People}}{{else}}—{{end}}</td><td>{{date .LastUsed}}</td></tr>{{else}}<tr><td colspan="9">No skills, prompts or agents are in a current pack or were used in this period.</td></tr>{{end}}</tbody></table></div></section>
+<section id="integrations-by-team" aria-labelledby="integrations-title"><h2 id="integrations-title">Integrations by team</h2><p class="note">Configured integrations that each team's current packs assign: the team default and every unexpired project override. {{.IntegrationsNote}}</p>{{if not .IntegrationsAvailable}}<p class="card" id="integrations-unavailable">Integration assignments are unavailable on this server.</p>{{else}}<div class="table-wrap"><table><thead><tr><th>Team</th><th>Integration</th><th>Assigned through</th><th>Uses</th></tr></thead><tbody>{{range .Integrations}}<tr data-team="{{.TeamID}}" data-integration="{{.TileID}}"><td>{{.TeamName}}</td><td>{{.TileName}}</td><td>{{range $i, $source := .Sources}}{{if $i}}<br>{{end}}{{if $source.Project}}Project {{$source.Project}}{{else}}Team default{{end}}: {{$source.Pack}} {{$source.PackVersion}} <small>item {{$source.ItemVersion}}</small>{{end}}</td><td data-uses><span class="not-measurable">Not measurable</span></td></tr>{{else}}<tr><td colspan="4">No team's current packs assign a configured integration.</td></tr>{{end}}</tbody></table></div>{{end}}</section>{{end}}</main></body></html>`))
```
