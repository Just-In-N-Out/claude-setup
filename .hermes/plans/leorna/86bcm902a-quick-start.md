# 86bcm902a — One-click quick start (starter pack → team → sync) (control plane)

**Flag (read first):** 86bcm901r "Role-based starter packs" is still **to do**, and no role starter pack exists anywhere today. With ⭐ Q1-A this story builds a **stand-in** for part of 901r: the four role packs from 901r's *proposed* mapping (the card says "to confirm") are written as a small list in `internal/onboarding/starters.go`, and a company's pack is created from the content library only when an admin picks it in the quick start. 901r still owns: confirming the mapping, showing the agreed packs in the catalog on every fresh install (its AC1), the three-tool sync proof (its AC2), and picking up new library versions on each release (its AC3). When 901r lands, it replaces that one list; packs already made by the quick start stay as they are (pack versions never change).

**Away grant:** Justin (2026-10-29): "just keep everything going and follow what the recommended agent says." This covers plan approval and the ⭐ answers below, nothing else. Push, PR, ClickUp posting and merge stay unauthorized.

## Questions (each ⭐ is the safe, scoped choice; the plan below is written as if every ⭐ were chosen)

**Q1. Role starter packs (86bcm901r) don't exist yet. What does the quick start offer?**
- **A ⭐ A stand-in: 901r's four proposed packs, made on pick**
- B. Only packs the company already has (no roles)
- C. Wait: build 86bcm901r first as its own story
- D. Build all of 86bcm901r inside this story

What each builds and what Justin sees:
- **A:** a short list in `internal/onboarding/starters.go` names 901r's proposed items per role (Backend, Frontend, Platform/DevOps, Secure coding). The setup page's quick start shows four cards with their items. Picking one makes "Backend starter pack" (version 1) from the newest library items through 901w's `CreatePack`, then makes it the team's default pack. Takes on from 901r: the mapping (as a stand-in) and creating a role pack for a company. Leaves to 901r: everything listed in the Flag line.
- **B:** the quick start lists the company's built packs plus the seed "Leorna starter pack". On a fresh install that is one pack, with no role choice, so AC1's "role-based" is **not met**. No 901r work. The Flag line would say AC1 is narrowed.
- **C:** nothing builds now; this story waits for 901r.
- **D:** 901r's three ACs (catalog on every fresh install, three-tool sync proof, version pickup on library release) land here too. Size grows to about L, and 901r's card would be done by this branch.

**Q2. Where is "skipped" remembered?**
- **A ⭐ One row per company (new table, migration 24)**
- B. Nowhere: the offer stays until a team gets a pack

If B: no migration and no store file. "Skip for now" is a link back to the admin home that writes nothing, the setup page keeps showing the offer, and "done" is worked out from "some team has a default pack". AC3's test becomes "skip writes nothing and the offer is still there later".

**Q3. A fresh install has no teams. How does the admin pick one?**
- **A ⭐ Pick a team, or type a new team's name**
- B. Existing teams only (link to the Teams page)

If B: the team step lists teams only. With none, it says "Create a team first" and links to `/admin/teams`. `Apply` drops `CreateTeam`, AC4 drops its two team-name cases, and the fresh-install demo adds a team on the Teams page before resuming the quick start.

**Q4. The card's Verify asks for a recorded end-to-end demo on a fresh install. Who records it?**
- **A ⭐ An agent, locally: screenshot series plus logs**
- B. Justin records a screen video himself

If B: AC5 gets the live tag and is owed to Justin; the agent still runs AC5's test. With A there is no video, because this desktop has no `ffmpeg`. The "recording" is a numbered, timestamped series of real console screenshots from the real binary on an empty database, plus the demo log.

## Story

- **Status:** written 2026-10-29 09:55 UTC; waiting for the main session's go.
- **Card:** [One-click quick start (starter pack → team → sync)](https://app.clickup.com/t/86bcm902a) (E11 Pack Builder, PI-2, Size M, p1-high). Dependencies: [Create a pack by picking library items](https://app.clickup.com/t/86bcm901w) (complete, PR #96) and [Role-based starter packs](https://app.clickup.com/t/86bcm901r) (to do, Justin's own card).
- **Repo / worktree / branch:** `leorna-control-plane` only, `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start`, `feat/86bcm902a-quick-start`. No client change.
- **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (Merge PR #96, 86bcm901w). Checked 2026-10-29 09:55 UTC: HTTPS fetch through gh, then `git merge --ff-only origin/main` ("Already up to date"); `main` = `origin/main` = GitHub `main` (`gh api …/commits/main`) = `6c1709e`.
- **Pipeline:** Full. Every role is a fresh Opus 5.5 xhigh agent.

## Acceptance criteria

The card's three ACs come first, in its own wording. AC4 and AC5 are mine and marked proposed. No AC needs Justin's live check, so none is tagged live. Each test's whole name sits on its AC line.

- AC1: Given a fresh install, when I finish setup, then the quick start offers role-based starter packs — test `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres`
- AC2: Given I choose a pack and a team, then the assignment is created and engineers' next sync delivers it — test `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres`
- AC3: Given the quick start, then it can be skipped and resumed later — test `TestQuickStartAC3SkipThenResumeLaterWithPostgres`
- AC4 (proposed): Given a quick-start request that is invalid or not allowed (an unknown pack, no team or both a team and a new name, an unknown or another company's team, a team name already used, setup not finished, a member, a bad CSRF token, signed out), then it is refused with a clear status and nothing is written (no team, pack, assignment, quick-start row or audit record), and one company's quick start never shows or changes another's — test `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres`
- AC5 (proposed): Given a fresh install (empty database, auto setup on, as the installer runs it), when the admin signs in for the first time, picks the Backend starter pack and names a new team, then setup finishes with no clicks, the team's default pack is created, and an engineer added to that team's project gets the pack's files on their desktop client's first sync; an agent records this on the real binary as a screenshot series (Q4-A) — test `TestQuickStartAC5FreshInstallEndToEndWithPostgres`

AC4 makes the DoD's "happy path + 1 failure" concrete and covers the permission, tenant and CSRF guards. AC5 is the card's Verify line.

## Playback and summary

**Playback:** right after a new admin finishes setup, the setup page offers four role starter packs; the admin picks one and a team (or names a new team), and the quick start makes that pack the team's default, so the team's engineers get it on their next sync. The admin can skip it and resume it later from the setup page or the admin home.

**What gets built (control plane only):**
1. `internal/onboarding`: the stand-in starter list (`starters.go`) and a small `QuickStart` service (`quickstart.go`) that composes existing pieces: the library catalog, 901w's `CreatePack`, the existing `AssignTeam` and `CreateTeam`, and a new state store.
2. Migration 24 `quick_starts` (one row per company: skipped or done) and `internal/store/postgres/quick_starts.go`, audited as `quickstart.skip` and `quickstart.complete`.
3. Admin console: a quick-start panel under the setup page's "Your workspace is ready", a page at `/admin/quick-start` (resume, done, refusal alerts), `POST /admin/quick-start` and `POST /admin/quick-start/skip`, and a "Resume quick start" link in the admin home's setup banner.
4. No OpenAPI change and no client change: the engineer's sync is the existing `GET /v1/client/projects/{projectId}/bundle` (+ `/content`), which already serves a team's default pack to every project in the team.

## Skills (build roles)

| Role | Loads, in order |
| --- | --- |
| Every role | `leorna` (role rules only; this plan already did its Step 1), `engineering-best-practices` |
| Builder | + `test-driven-development`, `mutation-testing-discipline` (permission, tenant, CSRF, setup-gate, write-order and audit guards: mutants M1–M12 below), `security-best-practices` (read `references/golang-general-backend-security.md`: GO-HTTP-002 body bounds, GO-HTTP-006 CSRF, GO-XSS-001 html/template, GO-INJECT-001 parameterized SQL), `multi-tenant-auth-management`, `backend-data-migrations` **[ends with Mandatory Validation and Agent Defect Loop]** |
| Reviewers 1 and 2 | + `requesting-code-review`, `code-review-practice` (report only), the specialists above |
| Fixers / finisher | + `receiving-code-review`, `test-driven-development`, `git-commit-rules` (finisher), the specialists for the area touched |
| Verifier / AC auditor | + `references/ac-verification.md` (feature-dispatch), the specialists |

`api-contract-drift-guard` (also a Defect Loop skill) is **not** needed: the OpenAPI contract does not change. A reviewer who finds a contract change should flag it as out of plan. The Defect Loop of `backend-data-migrations` means the hand-over waits for a clean verifier; agents don't start agents, so the main session runs that loop.

Every brief carries: list reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and never edit skills or memory. Every role keeps scratch in a fresh `<scratchpad>/86bcm902a-<role>/` (created with `mkdir`, no `-p`) and removes only that folder by its literal absolute path. `/tmp` is a small shared RAM tmpfs here: big temp files (Go `TMPDIR`, Chrome profiles, binaries, detached copies) go to `~/.cache/86bcm902a-<role>/`, removed afterwards.

## Current context (facts this plan relies on, at `6c1709e`)

**Setup wizard ("finish setup")**
- `internal/web/setup.go`: `GET /admin/setup` (`setupView`) renders three steps; `setupState` (`:91-119`) builds `onboarding.Facts` and calls `onboarding.Evaluate`. **"Finish setup" = `Progress.Ready`** (database done and starter pack loaded), which renders `<section class="card" id="setup-ready">` with "Your workspace is ready" (`:421-429`). The quick start hooks in right after that section.
- Auto setup (`handler.autoSetup`, `LEORNA_AUTO_SETUP=1`, set by the graphical installer; `internal/config/runtime.go:29-31,63-64`, `main.go:143-144`): on page load it treats the control-plane database as ready and runs the pack step (`runPackLoad`, `:317-340`: `EnsureSeedBase`, `EnsureLibrary`, `SeedPack`). A fresh install reaches `Ready` with no clicks, and the page stops refreshing (`setupIsAdvancing`).
- `TrySetupLock(ctx, tenantID, fn)` (`internal/store/postgres/setup_lock.go`) is a per-tenant `pg_try_advisory_lock` that never waits. Setup POSTs run their check and write inside it.
- `internal/onboarding` (`state.go`, `README.md`) is a pure function over stored facts; it is imported only by `internal/web` (`handler.go`, `setup.go`). Its imports would be `library`, `pack`, `org`, `store`, none of which imports `onboarding`, so there is no cycle.
- Admin home `/admin` (`handler.go:533-581`) shows `<section class="card" id="setup-banner">` ("Setup complete. Review setup", `:754-755`). That page also shows the admin's email and tenant ID, so it is **never** screenshotted.

**Packs, library, assignment, sync**
- 901w: `pack.BuilderService` (`internal/pack/builder.go:236-…`): `CreatePack(ctx, actor, name, libraryItemIDs)` saves a named pack (a `pack_lineages` row, unique per tenant on `lower(btrim(name))`) at version 1 with generated version id `v<timestamp>Z`, audited `pack.create`; `Packs(ctx, actor)` returns `[]pack.PackSummary{ID, Name, LatestNumber, LatestVersion, …}`. `pack.ErrNameTaken` wraps `store.ErrConflict`. Store: `internal/store/postgres/pack_builder.go`.
- Library: `library.Catalog.ListLibraryItems(ctx, actor)` (`internal/store/postgres/library_catalog.go:21-57`) returns the **newest stored version** of every item with its `ID`. `library.Embedded()` is the shipped library (one version per kind/name); `Library.Required(item)` (`internal/library/library.go:380-395`) returns an item's `requires` (prompts name the skills they invoke). The library README (`:505-510`) says the role starter packs read `Required` "to install a prompt together with its skills".
- All 901r items exist in library 0.7.0 (checked at `6c1709e`): the 25 skills, prompts `spec`, `planning`, `build`, `test`, `review`, `ship`, `webperf`, agents `security-auditor`, `web-performance-auditor`. 901r's "/plan" ships as prompt **`planning`** (Claude Code has a built-in `/plan`; library README `:491-493`). No library item has a script file, so no starter pack needs script approval today.
- Assignment: `AssignTeam(ctx, actor, teamID, version)` (`internal/store/postgres/pack_assignments.go:19-49`) upserts the team default (one per team) and audits `pack.assign`; it refuses a version with unapproved scripts (`pack.ErrScriptApprovalRequired`). HTML forms at `/admin/packs/assignments` (`internal/web/pack_assignments.go`). There is **no JSON assignment API**.
- Sync: the desktop client (`leorna-client` `distribution/controlplane.go`, `application/startup_sync.go`, read-only) syncs a selected project with `GET /v1/client/projects/{projectId}/bundle` then `GET …/bundles/{digest}/content`. `ResolveForProject` (`pack_assignments.go:156-188`) serves the project override, else the **team default**, so every project in the team gets the pack on its next sync. Members see projects of teams they belong to (`projects.go:73`).
- Teams: `CreateTeam` (`teams.go:82-105`, audited `team.create`; `teams` has `UNIQUE(tenant_id, name)`, so a repeat name is `store.ErrConflict`); `GetTeam` returns `store.ErrNotFound` for unknown, malformed or other-tenant ids (`withTeam`, `:51-80`).

**Tests and fixtures**
- `newPackFixture` (`internal/web/packs_test.go:41-115`) gives a throwaway schema, `admin`, `member` (same tenant), `other` (another tenant's admin), `login`, `get`, `handler`, `pool`, `repository`. `newSetupFixture` (`setup_test.go:60-81`) adds the real provisioning service over a mocked cloud, `connectScaleway`, `post`, `postRedirect`, `waitForStep` (5 s; under load it once timed out and passed alone, so rerun alone before calling a regression), `setupStep`, `assertStep`.
- Desktop token pattern: `mint` in `internal/web/prompt_publish_test.go:73-89` (real `clientauth` Begin/Approve/Exchange against Postgres), then `Authorization: Bearer` on `/v1/client/…`; that test also sets `handler.discovery`.
- Store tests: `testPool` + `resetDatabase` (`internal/store/postgres/store_test.go:489-…`) share one DB and drop every table, and `TestMigrationRoundTrip` (`:26-…`) lists every table twice (`:34`, `:104`). A new table goes into both lists and the `resetDatabase` drop list (`:499`).
- Migrations: the last is `000023_pack_builder`. `readMigrationSet` (`migrate.go`) refuses a duplicated version number ("migration version N is duplicated").

**Host prerequisites (checked 2026-10-29 on this desktop): nothing missing, so no question.**
- `go` 1.27.3 at `~/.local/leorna-toolchain/go/bin/go` (not on PATH; use a task-local PATH), `golangci-lint` 2.14.0 and `govulncheck` v1.7.0 in `~/.local/leorna-toolchain/bin` (CI's pins: `ci.yml:124-125,139`), `gitleaks` 8.30.1 at `/usr/local/bin/gitleaks`, GNU Make 4.4.1, gcc 15.2.0 (cgo for `-race`).
- `docker` works (user is in the `docker` group). `leorna-test-pg` is up on **127.0.0.1:55432** (read it with `docker port leorna-test-pg 5432`); `leorna-pg` holds 5432 and is not ours: never touch it. No `psql`: use `docker exec leorna-test-pg psql …`.
- Chrome for Testing 156.0.8078.47 runs with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`. No `ffmpeg`, `osascript`, `screencapture`, PIL or ImageMagick.

**Other work in flight (Risks has the details)**
- PR #98 (86bcm901j, OPEN, head `17f2ccf`, base `6c1709e`): `delivery/stories.json` plus library content, gate and README files; no overlap besides `stories.json`.
- 86bcm901y "Remove and reorder items in a pack version": being planned now (no plan file, worktree or branch yet). It probably adds a migration (an item position), and edits the pack builder store and service, the library page, the OpenAPI spec, `internal/web/README.md`, `store_test.go`'s table lists and `stories.json`.
- Stale worktrees of merged stories: `86bcm901a-agent-definitions`, `86bcm901b-prompts-collection`, `86bcm901w-create-pack`; `86bcm901j-mcp-templates` is PR #98. Never touch any of them.

## Design

### D1. Where the quick start appears and how it is triggered
- **Trigger:** when the setup page renders with `Progress.Ready` (manual wizard or auto setup), it shows `<section class="card" id="quick-start">` right **after** `#setup-ready` (a sibling, not nested, so the existing `setupReadyPanel` regex in tests is unchanged). No redirect: the admin finishes setup on `/admin/setup` and the offer is right there.
- **The panel by state:**
  - *offered* (no row): heading "Quick start: give a team a starter pack", one line of help, the offer form (D5) and a "Skip for now" button.
  - *skipped*: "You skipped the quick start. You can pick it up any time." and `<a id="quick-start-resume" href="/admin/quick-start">Resume quick start →</a>`; no offer form.
  - *done*: `<p id="quick-start-done">` "Done: **Backend starter pack** is the default pack for **Backend team**. Engineers in that team get it on their next sync." plus links "Give another team a starter pack" (`/admin/quick-start`), "See pack assignments", "Add engineers to the team" (`/admin/teams`), "Add a project" (`/admin/projects`).
- **`/admin/quick-start` page:** the resume and result page. Not ready → `#quick-start-not-ready` "Finish setup first" with a link to `/admin/setup`, and no form. Ready → an optional alert `<p class="error" role="alert" id="quick-start-alert">`, the done panel when done, a skipped note `#quick-start-skipped-note` when skipped, then the offer form (the skip button only when not done).
- **Admin home banner:** when setup is ready and the quick start isn't done, `#setup-banner` adds ` · <a id="quick-start-banner" href="/admin/quick-start">Resume quick start</a>` (skipped) or `Start the quick start` (offered).

### D2. Starter packs (stand-in for 86bcm901r, Q1-A)
`internal/onboarding/starters.go`: the four starters as data, in 901r's proposed order. Each names library items by kind and name only; the version is the newest stored one at pick time (the same one the catalog shows).

| Key | Role | Pack name | Listed items (901r's proposal) |
| --- | --- | --- | --- |
| `backend` | Backend | Backend starter pack | skills spec-driven-development, planning-and-task-breakdown, incremental-implementation, test-driven-development, api-and-interface-design, code-review-and-quality, debugging-and-error-recovery; prompts spec, planning, build, test, review |
| `frontend` | Frontend | Frontend starter pack | skills frontend-ui-engineering, browser-testing-with-devtools, performance-optimization; agent web-performance-auditor; prompt webperf |
| `platform-devops` | Platform/DevOps | Platform/DevOps starter pack | skills ci-cd-and-automation, git-workflow-and-versioning, observability-and-instrumentation, shipping-and-launch, deprecation-and-migration; prompt ship |
| `secure-coding` | Secure coding (regulated) | Secure coding starter pack | skills security-and-hardening, code-review-and-quality, doubt-driven-development, documentation-and-adrs, source-driven-development; agent security-auditor; prompt review |

`ResolveStarters(lib)` adds every item a listed item requires (`Library.Required`, followed until nothing new), after the listed ones, each once. At `6c1709e` that adds to Backend: doubt-driven-development (build), browser-testing-with-devtools (test), performance-optimization and security-and-hardening (review); to Secure coding: performance-optimization (review). Tests never pin these counts (they would break the next library change); they check the rules instead.

### D3. Quick-start state, storage and migration 24 (Q2-A)
- **Per company** (tenant), not per admin: the assignment is company-wide, and a second admin shouldn't be asked again after the first one skipped. Who skipped or finished is in the audit record.
- No row = *offered*. *skipped* and *done* are stored. Skip on *skipped* or *done* changes nothing (no write, no audit). Completing always records *done* with the latest starter, pack and team. Resume needs no write: the offer stays available until it is done.
- `internal/store/postgres/migrations/000024_quick_starts.up.sql`:

```sql
-- One-click quick start (story 86bcm902a). One row per tenant once an admin
-- has skipped or finished the quick start; no row means it is still offered.
CREATE TABLE quick_starts (
 tenant_id uuid PRIMARY KEY REFERENCES tenants(id) ON DELETE RESTRICT,
 status text NOT NULL CHECK (status IN ('skipped','done')),
 starter text NULL CHECK (char_length(starter) <= 64 AND starter ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
 pack_id uuid NULL,
 -- The tenant check is in CompleteQuickStart; this key only clears a deleted team.
 team_id uuid NULL REFERENCES teams(id) ON DELETE SET NULL,
 updated_by uuid NOT NULL,
 updated_at timestamptz NOT NULL DEFAULT now(),
 CONSTRAINT quick_starts_done_shape CHECK ((status = 'done') = (starter IS NOT NULL AND pack_id IS NOT NULL)),
 CONSTRAINT quick_starts_skipped_has_no_team CHECK (status = 'done' OR team_id IS NULL),
 CONSTRAINT quick_starts_pack_fk FOREIGN KEY (tenant_id, pack_id) REFERENCES pack_lineages (tenant_id, id) ON DELETE RESTRICT
);
```

`000024_quick_starts.down.sql`: `DROP TABLE quick_starts;`

- `updated_by` has no foreign key, like `audit_records.actor`. The pack key is composite, so another tenant's pack fails with 23503 (`orgError` → `store.ErrNotFound`). The team key is single-column on purpose: `ON DELETE SET NULL (team_id)` with a column list needs PostgreSQL 15+ and would otherwise null `tenant_id`. So `CompleteQuickStart` checks the team's tenant inside its transaction, and reads join `teams` on `tenant_id` too.
- Rollback: the down migration drops only this table; lossless except the skip/done flags (the offer reappears). Packs, teams and assignments the quick start made stay.

### D4. Domain service `internal/onboarding/quickstart.go`

```go
package onboarding

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// Quick start errors. The web layer maps them to statuses; none echoes input.
var (
	ErrUnknownStarter        = fmt.Errorf("quick start pack is unknown: %w", org.ErrInvalid)
	ErrTeamChoice            = fmt.Errorf("choose one team or name a new one: %w", org.ErrInvalid)
	ErrTeamNameTaken         = fmt.Errorf("a team with this name already exists: %w", store.ErrConflict)
	ErrStarterContentMissing = errors.New("starter pack content is not loaded")
)

// QuickStartStatus is where a tenant is in the quick start.
type QuickStartStatus string

const (
	QuickStartOffered QuickStartStatus = "offered" // no answer yet
	QuickStartSkipped QuickStartStatus = "skipped"
	QuickStartDone    QuickStartStatus = "done"
)

// QuickStartState is the tenant's quick start answer as the console shows it.
// TeamID and TeamName are empty when the team was deleted later.
type QuickStartState struct {
	Status    QuickStartStatus
	Starter   string
	PackID    string
	PackName  string
	TeamID    string
	TeamName  string
	UpdatedAt time.Time
}

// QuickStartCompletion is what a finished quick start records.
type QuickStartCompletion struct{ Starter, PackID, TeamID string }

// QuickStartChoice is the admin's pick: a starter key and either an existing
// team id or a new team's name.
type QuickStartChoice struct{ Starter, TeamID, NewTeamName string }

// QuickStartResult is what Apply did.
type QuickStartResult struct {
	Offer       StarterOffer
	PackID      string
	Version     string // the pack version assigned
	Number      int    // its number in the pack (1 for a new pack)
	Team        org.Team
	CreatedPack bool
	CreatedTeam bool
	State       QuickStartState
}

// StarterItem is one library item a starter installs.
type StarterItem struct {
	Kind        pack.Kind
	Name        string
	Description string
}

// Ref returns the library's "kind/name" form.
func (item StarterItem) Ref() string { return string(item.Kind) + "/" + item.Name }

// StarterOffer is a starter with every library item it installs.
type StarterOffer struct {
	Starter
	Items []StarterItem
}

// The ports. Each is a subset of an existing store or service.
type (
	LibraryCatalog interface {
		ListLibraryItems(ctx context.Context, actor store.Principal) ([]library.Entry, error)
	}
	PackMaker interface {
		CreatePack(ctx context.Context, actor store.Principal, name string, libraryItemIDs []string) (pack.BuiltVersion, error)
		Packs(ctx context.Context, actor store.Principal) ([]pack.PackSummary, error)
	}
	TeamAssigner interface {
		AssignTeam(ctx context.Context, actor store.Principal, teamID, version string) (pack.Assignment, error)
	}
	TeamMaker interface {
		GetTeam(ctx context.Context, actor store.Principal, id string) (org.Team, error)
		CreateTeam(ctx context.Context, actor store.Principal, name string) (org.Team, error)
	}
	QuickStartStore interface {
		GetQuickStart(ctx context.Context, actor store.Principal) (QuickStartState, error)
		SkipQuickStart(ctx context.Context, actor store.Principal) (QuickStartState, error)
		CompleteQuickStart(ctx context.Context, actor store.Principal, done QuickStartCompletion) (QuickStartState, error)
	}
)

// QuickStart offers role starter packs after setup and makes the chosen one a
// team's default pack (story 86bcm902a).
type QuickStart struct {
	offers  []StarterOffer
	catalog LibraryCatalog
	packs   PackMaker
	assign  TeamAssigner
	teams   TeamMaker
	state   QuickStartStore
}

// NewQuickStart resolves every starter against the shipped library, so a
// starter naming a missing item stops startup instead of failing a pick.
func NewQuickStart(lib library.Library, catalog LibraryCatalog, packs PackMaker, assign TeamAssigner, teams TeamMaker, state QuickStartStore) (*QuickStart, error) {
	offers, err := ResolveStarters(lib)
	if err != nil {
		return nil, err
	}
	return &QuickStart{offers: offers, catalog: catalog, packs: packs, assign: assign, teams: teams, state: state}, nil
}

// ResolveStarters returns each starter with its listed items first, in order,
// then every item they require (Library.Required, followed until nothing new),
// each item once.
func ResolveStarters(lib library.Library) ([]StarterOffer, error) {
	byRef := make(map[string]library.Item, len(lib.Items))
	for _, item := range lib.Items {
		byRef[string(item.Kind)+"/"+item.Name] = item
	}
	offers := make([]StarterOffer, 0, len(starters))
	for _, starter := range Starters() {
		seen := map[string]bool{}
		items := make([]StarterItem, 0, len(starter.Items))
		queue := make([]library.Item, 0, len(starter.Items))
		add := func(item library.Item) {
			ref := string(item.Kind) + "/" + item.Name
			if seen[ref] {
				return
			}
			seen[ref] = true
			items = append(items, StarterItem{Kind: item.Kind, Name: item.Name, Description: item.Description})
			queue = append(queue, item)
		}
		for _, ref := range starter.Items {
			item, ok := byRef[ref.String()]
			if !ok {
				return nil, fmt.Errorf("starter %s lists %s, which is not in the library", starter.Key, ref)
			}
			add(item)
		}
		for next := 0; next < len(queue); next++ {
			for _, required := range lib.Required(queue[next]) {
				add(required)
			}
		}
		if len(items) > pack.MaxItems {
			return nil, fmt.Errorf("starter %s has more than %d items", starter.Key, pack.MaxItems)
		}
		offers = append(offers, StarterOffer{Starter: starter, Items: items})
	}
	return offers, nil
}

// Offers returns the starters for display (a copy).
func (q *QuickStart) Offers() []StarterOffer {
	out := make([]StarterOffer, len(q.offers))
	for i, offer := range q.offers {
		offer.Items = append([]StarterItem(nil), offer.Items...)
		offer.Starter.Items = append([]StarterRef(nil), offer.Starter.Items...)
		out[i] = offer
	}
	return out
}

// State reads the tenant's quick start answer.
func (q *QuickStart) State(ctx context.Context, actor store.Principal) (QuickStartState, error) {
	return q.state.GetQuickStart(ctx, actor)
}

// Skip records that the admin skipped the quick start (done stays done).
func (q *QuickStart) Skip(ctx context.Context, actor store.Principal) (QuickStartState, error) {
	return q.state.SkipQuickStart(ctx, actor)
}

// Apply makes the chosen starter the team's default pack. Every check that can
// refuse the request runs before the first write. Each write is idempotent, so a
// retry after a failure part-way finishes the job: the team (when new) first,
// then the pack (an existing pack with the starter's name is reused), then the
// assignment, then the done record.
func (q *QuickStart) Apply(ctx context.Context, actor store.Principal, choice QuickStartChoice) (QuickStartResult, error) {
	offer, ok := q.offer(choice.Starter)
	if !ok {
		return QuickStartResult{}, ErrUnknownStarter
	}
	teamID, newTeam := strings.TrimSpace(choice.TeamID), strings.TrimSpace(choice.NewTeamName)
	if (teamID == "") == (newTeam == "") {
		return QuickStartResult{}, ErrTeamChoice
	}
	ids, err := q.libraryIDs(ctx, actor, offer)
	if err != nil {
		return QuickStartResult{}, err
	}
	var team org.Team
	if teamID != "" {
		team, err = q.teams.GetTeam(ctx, actor, teamID)
	} else {
		team, err = q.teams.CreateTeam(ctx, actor, newTeam)
		if errors.Is(err, store.ErrConflict) {
			err = ErrTeamNameTaken
		}
	}
	if err != nil {
		return QuickStartResult{}, err
	}
	result := QuickStartResult{Offer: offer, Team: team, CreatedTeam: newTeam != ""}
	if err := q.starterPack(ctx, actor, offer, ids, &result); err != nil {
		return QuickStartResult{}, err
	}
	if _, err := q.assign.AssignTeam(ctx, actor, team.ID, result.Version); err != nil {
		return QuickStartResult{}, err
	}
	result.State, err = q.state.CompleteQuickStart(ctx, actor, QuickStartCompletion{Starter: offer.Key, PackID: result.PackID, TeamID: team.ID})
	if err != nil {
		return QuickStartResult{}, err
	}
	return result, nil
}

func (q *QuickStart) offer(key string) (StarterOffer, bool) {
	for _, offer := range q.offers {
		if offer.Key == key {
			return offer, true
		}
	}
	return StarterOffer{}, false
}

// libraryIDs maps the offer's items to the newest stored library rows.
func (q *QuickStart) libraryIDs(ctx context.Context, actor store.Principal, offer StarterOffer) ([]string, error) {
	entries, err := q.catalog.ListLibraryItems(ctx, actor)
	if err != nil {
		return nil, err
	}
	byRef := make(map[string]string, len(entries))
	for _, entry := range entries {
		byRef[string(entry.Item.Kind)+"/"+entry.Item.Name] = entry.ID
	}
	ids := make([]string, 0, len(offer.Items))
	for _, item := range offer.Items {
		id, ok := byRef[item.Ref()]
		if !ok {
			return nil, fmt.Errorf("%w: %s", ErrStarterContentMissing, item.Ref())
		}
		ids = append(ids, id)
	}
	return ids, nil
}

// starterPack fills result with the tenant's pack for the offer: an existing
// pack with the offer's name (compared like the unique index: trimmed, any
// case) at its latest version, else a new pack at version 1.
func (q *QuickStart) starterPack(ctx context.Context, actor store.Principal, offer StarterOffer, ids []string, result *QuickStartResult) error {
	if found, ok, err := q.existingPack(ctx, actor, offer.PackName); err != nil || ok {
		result.PackID, result.Version, result.Number = found.ID, found.LatestVersion, found.LatestNumber
		return err
	}
	built, err := q.packs.CreatePack(ctx, actor, offer.PackName, ids)
	if errors.Is(err, pack.ErrNameTaken) {
		// Another admin saved a pack with this name a moment ago: use it.
		found, ok, listErr := q.existingPack(ctx, actor, offer.PackName)
		if listErr != nil {
			return listErr
		}
		if !ok {
			return errors.New("starter pack name is taken but the pack is not listed")
		}
		result.PackID, result.Version, result.Number = found.ID, found.LatestVersion, found.LatestNumber
		return nil
	}
	if err != nil {
		return err
	}
	result.PackID, result.Version, result.Number, result.CreatedPack = built.PackID, built.Version.Version, built.Number, true
	return nil
}

func (q *QuickStart) existingPack(ctx context.Context, actor store.Principal, name string) (pack.PackSummary, bool, error) {
	packs, err := q.packs.Packs(ctx, actor)
	if err != nil {
		return pack.PackSummary{}, false, err
	}
	for _, summary := range packs {
		if strings.EqualFold(strings.TrimSpace(summary.Name), strings.TrimSpace(name)) {
			return summary, true, nil
		}
	}
	return pack.PackSummary{}, false, nil
}
```

Notes:
- The `ErrNameTaken` fallback returns a plain error when the pack can't be listed, so it maps to 500, never to the team-name 409.
- `GetTeam` before any write makes an unknown or other-company team refuse with nothing written (AC4). A failure after `CreateTeam` leaves the new team; a retry with the same name then gets the 409 and the admin picks it from the list (Assumption 3).
- `Apply` runs inside the web layer's `TrySetupLock` (D6), so a double submit runs once.

`internal/onboarding/starters.go`:

```go
package onboarding

import "github.com/LeornaAI/leorna-control-plane/internal/pack"

// StarterRef names one library item by kind and name. The quick start uses the
// newest stored version when it creates the pack.
type StarterRef struct {
	Kind pack.Kind
	Name string
}

// String returns the library's "kind/name" reference form.
func (ref StarterRef) String() string { return string(ref.Kind) + "/" + ref.Name }

// Starter is one role starter pack.
type Starter struct {
	Key         string // form value, a slug
	Role        string // the choice's title
	PackName    string // the pack's name in the tenant
	Description string
	Items       []StarterRef
}

func skill(name string) StarterRef  { return StarterRef{Kind: pack.KindSkill, Name: name} }
func prompt(name string) StarterRef { return StarterRef{Kind: pack.KindPrompt, Name: name} }
func agent(name string) StarterRef  { return StarterRef{Kind: pack.KindAgent, Name: name} }

// starters is a stand-in for 86bcm901r "Role-based starter packs", which is
// still open: the roles and items are that card's proposed mapping ("to
// confirm"), with upstream's /plan command shipped as prompt "planning".
// 86bcm901r replaces this list.
var starters = []Starter{
	{
		Key: "backend", Role: "Backend", PackName: "Backend starter pack",
		Description: "Spec, plan, build, test and review backend services and APIs.",
		Items: []StarterRef{
			skill("spec-driven-development"), skill("planning-and-task-breakdown"), skill("incremental-implementation"),
			skill("test-driven-development"), skill("api-and-interface-design"), skill("code-review-and-quality"),
			skill("debugging-and-error-recovery"),
			prompt("spec"), prompt("planning"), prompt("build"), prompt("test"), prompt("review"),
		},
	},
	{
		Key: "frontend", Role: "Frontend", PackName: "Frontend starter pack",
		Description: "Build and test user interfaces and keep pages fast.",
		Items: []StarterRef{
			skill("frontend-ui-engineering"), skill("browser-testing-with-devtools"), skill("performance-optimization"),
			agent("web-performance-auditor"), prompt("webperf"),
		},
	},
	{
		Key: "platform-devops", Role: "Platform/DevOps", PackName: "Platform/DevOps starter pack",
		Description: "CI/CD, versioning, observability, launches and migrations.",
		Items: []StarterRef{
			skill("ci-cd-and-automation"), skill("git-workflow-and-versioning"), skill("observability-and-instrumentation"),
			skill("shipping-and-launch"), skill("deprecation-and-migration"), prompt("ship"),
		},
	},
	{
		Key: "secure-coding", Role: "Secure coding (regulated)", PackName: "Secure coding starter pack",
		Description: "Security hardening, careful review and recorded decisions for regulated teams.",
		Items: []StarterRef{
			skill("security-and-hardening"), skill("code-review-and-quality"), skill("doubt-driven-development"),
			skill("documentation-and-adrs"), skill("source-driven-development"), agent("security-auditor"), prompt("review"),
		},
	},
}

// Starters returns a copy of the role starter packs, in display order.
func Starters() []Starter {
	out := make([]Starter, len(starters))
	for i, starter := range starters {
		starter.Items = append([]StarterRef(nil), starter.Items...)
		out[i] = starter
	}
	return out
}
```

### D5. Store `internal/store/postgres/quick_starts.go`

```go
package postgres

import (
	"context"
	"errors"
	"regexp"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/onboarding"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/jackc/pgx/v5"
)

var _ onboarding.QuickStartStore = (*Store)(nil)

var starterKey = regexp.MustCompile(`^[a-z0-9]+(-[a-z0-9]+)*$`)

// GetQuickStart reads the tenant's quick start answer; no row is "offered".
// Any current user of the tenant may read it; the routes add the admin check.
func (database *Store) GetQuickStart(ctx context.Context, actor store.Principal) (onboarding.QuickStartState, error) {
	tx, _, err := database.beginOrg(ctx, actor, false)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	state, err := quickStartTx(ctx, tx, actor.TenantID, false)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	return state, orgError(tx.Commit(ctx))
}

// SkipQuickStart records "skipped" when the quick start is still offered, with
// its quickstart.skip audit record in the same transaction. A skipped or done
// quick start is returned unchanged and nothing is written. Admin only.
func (database *Store) SkipQuickStart(ctx context.Context, actor store.Principal) (onboarding.QuickStartState, error) {
	tx, _, err := database.beginOrg(ctx, actor, true)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	before, err := quickStartTx(ctx, tx, actor.TenantID, true)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	if before.Status != onboarding.QuickStartOffered {
		return before, orgError(tx.Commit(ctx))
	}
	tag, err := tx.Exec(ctx, `INSERT INTO quick_starts(tenant_id,status,updated_by) VALUES($1,'skipped',$2) ON CONFLICT (tenant_id) DO NOTHING`, actor.TenantID, actor.UserID)
	if err != nil {
		return onboarding.QuickStartState{}, orgError(err)
	}
	after, err := quickStartTx(ctx, tx, actor.TenantID, false)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	if tag.RowsAffected() == 1 {
		if err := database.appendAudit(ctx, tx, actor, "quickstart.skip", string(actor.TenantID), quickStartAudit(before), quickStartAudit(after)); err != nil {
			return onboarding.QuickStartState{}, orgError(err)
		}
	}
	return after, orgError(tx.Commit(ctx))
}

// CompleteQuickStart records "done" with the starter, pack and team, with its
// quickstart.complete audit record in the same transaction. The team and the
// pack must be the actor's tenant's. Admin only.
func (database *Store) CompleteQuickStart(ctx context.Context, actor store.Principal, done onboarding.QuickStartCompletion) (onboarding.QuickStartState, error) {
	if len(done.Starter) > 64 || !starterKey.MatchString(done.Starter) || !validUUID(done.PackID) || !validUUID(done.TeamID) {
		return onboarding.QuickStartState{}, org.ErrInvalid
	}
	packID, teamID := strings.ToLower(done.PackID), strings.ToLower(done.TeamID)
	tx, _, err := database.beginOrg(ctx, actor, true)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	// team_id's foreign key alone would accept another tenant's team.
	var ownTeam bool
	if err := tx.QueryRow(ctx, `SELECT EXISTS(SELECT 1 FROM teams WHERE tenant_id=$1 AND id=$2)`, actor.TenantID, teamID).Scan(&ownTeam); err != nil {
		return onboarding.QuickStartState{}, orgError(err)
	}
	if !ownTeam {
		return onboarding.QuickStartState{}, store.ErrNotFound
	}
	before, err := quickStartTx(ctx, tx, actor.TenantID, true)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	if _, err := tx.Exec(ctx,
		`INSERT INTO quick_starts(tenant_id,status,starter,pack_id,team_id,updated_by) VALUES($1,'done',$2,$3,$4,$5)
		 ON CONFLICT (tenant_id) DO UPDATE SET status='done', starter=EXCLUDED.starter, pack_id=EXCLUDED.pack_id,
		   team_id=EXCLUDED.team_id, updated_by=EXCLUDED.updated_by, updated_at=now()`,
		actor.TenantID, done.Starter, packID, teamID, actor.UserID); err != nil {
		return onboarding.QuickStartState{}, orgError(err) // another tenant's pack: 23503 -> store.ErrNotFound
	}
	after, err := quickStartTx(ctx, tx, actor.TenantID, false)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	if err := database.appendAudit(ctx, tx, actor, "quickstart.complete", string(actor.TenantID), quickStartAudit(before), quickStartAudit(after)); err != nil {
		return onboarding.QuickStartState{}, orgError(err)
	}
	return after, orgError(tx.Commit(ctx))
}

// quickStartTx reads the tenant's row with its pack and team names. Both joins
// are tenant-scoped, so another tenant's name can never show.
func quickStartTx(ctx context.Context, tx pgx.Tx, tenantID store.TenantID, lock bool) (onboarding.QuickStartState, error) {
	query := `SELECT q.status, COALESCE(q.starter,''), COALESCE(q.pack_id::text,''), COALESCE(l.name,''),
	                 COALESCE(q.team_id::text,''), COALESCE(t.name,''), q.updated_at
	          FROM quick_starts q
	          LEFT JOIN pack_lineages l ON l.tenant_id=q.tenant_id AND l.id=q.pack_id
	          LEFT JOIN teams t ON t.tenant_id=q.tenant_id AND t.id=q.team_id
	          WHERE q.tenant_id=$1`
	if lock {
		query += ` FOR UPDATE OF q`
	}
	var state onboarding.QuickStartState
	var status string
	err := tx.QueryRow(ctx, query, tenantID).Scan(&status, &state.Starter, &state.PackID, &state.PackName, &state.TeamID, &state.TeamName, &state.UpdatedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return onboarding.QuickStartState{Status: onboarding.QuickStartOffered}, nil
	}
	if err != nil {
		return onboarding.QuickStartState{}, orgError(err)
	}
	state.Status = onboarding.QuickStartStatus(status)
	if state.TeamName == "" {
		state.TeamID = ""
	}
	return state, nil
}

// quickStartAudit is the audit value: identifiers and status, never names.
func quickStartAudit(state onboarding.QuickStartState) map[string]string {
	return map[string]string{"status": string(state.Status), "starter": state.Starter, "packId": state.PackID, "teamId": state.TeamID}
}
```

The `onboarding` import in `internal/store/postgres` is new; `onboarding` doesn't import `postgres`, so there is no cycle. Run `go build ./...` after adding it.

### D6. Web: `internal/web/quick_start.go` (new) plus small edits
**Routes** (`handler.go`, right after the four `/admin/setup` routes):

```go
routes.Handle("GET /admin/quick-start", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.quickStartPage)), true))
routes.Handle("POST /admin/quick-start", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.quickStartAssign)), false))
routes.Handle("POST /admin/quick-start/skip", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.quickStartSkip)), false))
```

Field on `Handler`: `quickStart quickStarter`. Also add `QuickStart *onboarding.QuickStartState` to `adminPageData`.

**Handlers** (complete logic; the builder may only reflow it):

```go
package web

// quickStarter is the quick start service (onboarding.QuickStart).
type quickStarter interface {
	Offers() []onboarding.StarterOffer
	State(ctx context.Context, actor store.Principal) (onboarding.QuickStartState, error)
	Apply(ctx context.Context, actor store.Principal, choice onboarding.QuickStartChoice) (onboarding.QuickStartResult, error)
	Skip(ctx context.Context, actor store.Principal) (onboarding.QuickStartState, error)
}

// SetQuickStart binds the quick start during startup, before serving requests.
func (handler *Handler) SetQuickStart(quickStart quickStarter) { handler.quickStart = quickStart }

func (handler *Handler) quickStartWired() bool {
	return handler.quickStart != nil && handler.teams != nil && handler.setupWired()
}

// quickStartPanel is the quick start's template data, on the setup page and on
// its own page. The Starter/TeamID/TeamName fields refill the form after a refusal.
type quickStartPanel struct {
	Wired, SetupReady bool
	CSRF              string
	State             onboarding.QuickStartState
	Offers            []onboarding.StarterOffer
	Teams             []org.Team
	Notice            string
	Starter, TeamID   string
	TeamName          string
}

func (handler *Handler) loadQuickStartPanel(ctx context.Context, actor store.Principal, csrf string, ready bool) (quickStartPanel, error) {
	panel := quickStartPanel{Wired: true, SetupReady: ready, CSRF: csrf, Offers: handler.quickStart.Offers()}
	state, err := handler.quickStart.State(ctx, actor)
	if err != nil {
		return quickStartPanel{}, err
	}
	teams, err := handler.teams.ListTeams(ctx, actor)
	if err != nil {
		return quickStartPanel{}, err
	}
	panel.State, panel.Teams = state, teams
	return panel, nil
}

func (handler *Handler) quickStartPage(w http.ResponseWriter, r *http.Request) {
	if !handler.quickStartWired() {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "QUICK_START_UNAVAILABLE", "The quick start is unavailable")
		return
	}
	handler.renderQuickStart(w, r, http.StatusOK, quickStartPanel{})
}

// renderQuickStart renders /admin/quick-start with the refill's notice and form values.
func (handler *Handler) renderQuickStart(w http.ResponseWriter, r *http.Request, status int, refill quickStartPanel) {
	cookie, err := r.Cookie(csrfCookieName)
	if err != nil || !validBrowserToken(cookie.Value) {
		handler.writeProblem(w, r, http.StatusForbidden, "CSRF_REQUIRED", "Sign in again to continue the quick start")
		return
	}
	actor := teamActor(r)
	progress, _, err := handler.setupState(r.Context(), actor)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "QUICK_START_FAILED", "The quick start could not be loaded", err)
		return
	}
	panel, err := handler.loadQuickStartPanel(r.Context(), actor, cookie.Value, progress.Ready)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "QUICK_START_FAILED", "The quick start could not be loaded", err)
		return
	}
	panel.Notice, panel.Starter, panel.TeamID, panel.TeamName = refill.Notice, refill.Starter, refill.TeamID, refill.TeamName
	nonce, err := handler.randomHex(16)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The quick start could not be rendered", err)
		return
	}
	var page bytes.Buffer
	if err := quickStartTemplate.Execute(&page, quickStartPageData{Nonce: nonce, QuickStart: panel}); err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The quick start could not be rendered", err)
		return
	}
	handler.writeHTMLPage(w, nonce, status, &page)
}

type quickStartPageData struct {
	Nonce      string
	QuickStart quickStartPanel
}

const quickStartNotReady = "Finish setup first, then pick a starter pack."

func (handler *Handler) quickStartAssign(w http.ResponseWriter, r *http.Request) {
	if !handler.quickStartWired() {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "QUICK_START_UNAVAILABLE", "The quick start is unavailable")
		return
	}
	session, form, ok := handler.adminForm(w, r)
	if !ok {
		return
	}
	choice := onboarding.QuickStartChoice{Starter: form.Get("starter"), TeamID: strings.TrimSpace(form.Get("team_id")), NewTeamName: strings.TrimSpace(form.Get("team_name"))}
	refill := quickStartPanel{Starter: choice.Starter, TeamID: choice.TeamID, TeamName: choice.NewTeamName}
	var notReady bool
	var applyErr error
	ran, err := handler.setupStore.TrySetupLock(r.Context(), session.Principal.TenantID, func() error {
		progress, _, stateErr := handler.setupState(r.Context(), session.Principal)
		if stateErr != nil {
			return stateErr
		}
		if !progress.Ready {
			notReady = true
			return nil
		}
		_, applyErr = handler.quickStart.Apply(r.Context(), session.Principal, choice)
		return nil
	})
	switch {
	case err != nil:
		handler.writeProblem(w, r, http.StatusInternalServerError, "QUICK_START_FAILED", "The quick start could not finish", err)
	case !ran:
		// Another setup or quick-start step is running; the page shows its result.
		handler.redirectToQuickStart(w, r)
	case notReady:
		refill.Notice = quickStartNotReady
		handler.renderQuickStart(w, r, http.StatusConflict, refill)
	case errors.Is(applyErr, org.ErrForbidden):
		handler.writeProblem(w, r, http.StatusForbidden, "FORBIDDEN", "Administration rights are required")
	case applyErr != nil:
		status, notice := quickStartFailure(applyErr)
		if status == http.StatusInternalServerError {
			handler.logSetupFailure(w, r, "QUICK_START_FAILED", applyErr)
		}
		refill.Notice = notice
		handler.renderQuickStart(w, r, status, refill)
	default:
		handler.redirectToQuickStart(w, r)
	}
}

// quickStartFailure maps a refused or failed pick to a status and an inline
// notice. The specific errors come before the generic ones they wrap.
func quickStartFailure(err error) (int, string) {
	switch {
	case errors.Is(err, onboarding.ErrTeamNameTaken):
		return http.StatusConflict, "A team with that name already exists. Pick it from the list instead."
	case errors.Is(err, pack.ErrScriptApprovalRequired):
		return http.StatusConflict, "This starter pack has scripts to review first. Approve them on Pack versions, then try again."
	case errors.Is(err, store.ErrNotFound):
		return http.StatusNotFound, "That team isn't available. Pick one from the list or name a new team."
	case errors.Is(err, org.ErrInvalid):
		return http.StatusBadRequest, "Pick one starter pack, and either one team or a new team name."
	default:
		return http.StatusInternalServerError, "The quick start could not finish. It is safe to try again."
	}
}

func (handler *Handler) quickStartSkip(w http.ResponseWriter, r *http.Request) {
	if !handler.quickStartWired() {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "QUICK_START_UNAVAILABLE", "The quick start is unavailable")
		return
	}
	session, _, ok := handler.adminForm(w, r)
	if !ok {
		return
	}
	progress, _, err := handler.setupState(r.Context(), session.Principal)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "QUICK_START_FAILED", "The quick start could not be skipped", err)
		return
	}
	if !progress.Ready {
		handler.renderQuickStart(w, r, http.StatusConflict, quickStartPanel{Notice: quickStartNotReady})
		return
	}
	if _, err := handler.quickStart.Skip(r.Context(), session.Principal); err != nil {
		if errors.Is(err, org.ErrForbidden) {
			handler.writeProblem(w, r, http.StatusForbidden, "FORBIDDEN", "Administration rights are required")
			return
		}
		handler.writeProblem(w, r, http.StatusInternalServerError, "QUICK_START_FAILED", "The quick start could not be skipped", err)
		return
	}
	handler.redirectToSetup(w, r)
}

func (handler *Handler) redirectToQuickStart(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Cache-Control", "no-store")
	http.Redirect(w, r, "/admin/quick-start", http.StatusSeeOther)
}
```

Never echo the raw `starter` value in a notice; the form refill goes through `html/template`, which escapes it.

**Templates** (same file). `quickStartCSS` is shared by both pages; `quickStartOfferHTML` defines the form; the page template is `quickStartPageHTML + quickStartOfferHTML`, and `setupTemplate` appends `quickStartOfferHTML` after its existing `existing-database` define. Element ids the tests and captures rely on:

```go
const quickStartCSS = `
    fieldset { border: 1px solid #2b4058; border-radius: .75rem; padding: 1rem; margin: 1rem 0; }
    legend { color: #9db0c7; padding: 0 .5rem; }
    .starters { display: grid; grid-template-columns: repeat(auto-fit,minmax(16rem,1fr)); gap: .75rem; }
    .starter { display: block; padding: .75rem 1rem; border: 1px solid #2b4058; border-radius: .75rem; background: #07111f; }
    .starter input { margin-right: .5rem; }
    .starter-items { margin: .5rem 0 0; padding-left: 1.1rem; font-size: .9rem; color: #c8d6e5; }
    select { min-height: 44px; padding: .5rem; border: 1px solid #2b4058; border-radius: .5rem; background: #07111f; color: #eef6ff; }
`

const quickStartOfferHTML = `{{define "quick-start-offer"}}
<form method="post" action="/admin/quick-start" id="quick-start-form">
  <input type="hidden" name="csrfToken" value="{{.CSRF}}">
  <fieldset id="quick-start-packs">
    <legend>1. Pick a role's starter pack</legend>
    <div class="starters">
    {{$chosen := .Starter}}
    {{range .Offers}}
      <label class="starter" id="starter-{{.Key}}">
        <input type="radio" name="starter" value="{{.Key}}" required{{if eq $chosen .Key}} checked{{end}}>
        <strong>{{.Role}}</strong> <span class="meta">{{.PackName}} · {{len .Items}} items</span>
        <span class="meta">{{.Description}}</span>
        <ul class="starter-items">{{range .Items}}<li data-item="{{.Kind}}/{{.Name}}"><span class="badge">{{.Kind}}</span> {{if eq .Kind "prompt"}}/{{end}}{{.Name}}</li>{{end}}</ul>
      </label>
    {{end}}
    </div>
  </fieldset>
  <fieldset id="quick-start-team">
    <legend>2. Pick the team that gets it</legend>
    {{$teamID := .TeamID}}
    {{if .Teams}}
    <label for="quick-start-team-id">A team</label>
    <select id="quick-start-team-id" name="team_id"><option value="">Choose a team…</option>{{range .Teams}}<option value="{{.ID}}"{{if eq $teamID .ID}} selected{{end}}>{{.Name}}</option>{{end}}</select>
    <label for="quick-start-team-name">Or name a new team</label>
    {{else}}
    <label for="quick-start-team-name">Name a new team</label>
    {{end}}
    <input id="quick-start-team-name" name="team_name" maxlength="200" autocomplete="off" value="{{.TeamName}}">
  </fieldset>
  <button type="submit" id="quick-start-assign">Assign the starter pack</button>
</form>
{{if ne .State.Status "done"}}
<form method="post" action="/admin/quick-start/skip" id="quick-start-skip-form">
  <input type="hidden" name="csrfToken" value="{{.CSRF}}">
  <button type="submit" id="quick-start-skip">Skip for now</button>
</form>
{{end}}
{{end}}`
```

Page template (`quickStartPageHTML`): same `<head>` pattern as the setup page (charset, viewport, `<title>Leorna — Quick start</title>`, `<style nonce="{{.Nonce}}">` with `packStyles`, `.error`, `label`, `input` (copy the setup page's three rules) and `quickStartCSS`), header `<strong>Leorna Control Plane</strong> — <a href="/admin/setup">back to setup</a>`, then in `<main>`:
- `<p class="eyebrow">First-run setup</p><h1>Quick start</h1>`
- `{{with .QuickStart}}`
- not ready: `<section class="card" id="quick-start-not-ready"><p>Finish setup first, then come back to pick a starter pack.</p><p><a class="view" href="/admin/setup">Continue setup</a></p></section>`
- ready: `{{if .Notice}}<p class="error" role="alert" id="quick-start-alert">{{.Notice}}</p>{{end}}`; done → `<section class="card" id="quick-start-done-panel">` with the same done sentence as D1 (id `quick-start-done`) and its links, then `<h2>Give another team a starter pack</h2>`; skipped → `<p class="meta" id="quick-start-skipped-note">You skipped this earlier. Pick a pack to finish it.</p>`; then `{{template "quick-start-offer" .}}`.
- `{{end}}` closes the `with`.

```go
var quickStartTemplate = template.Must(template.New("quick-start").Parse(quickStartPageHTML + quickStartOfferHTML))
```

In `setup.go`, append `+ quickStartOfferHTML` to the raw string passed to `setupTemplate`'s `Parse`, right after its `{{define "existing-database"}}…{{end}}` block.

Setup page (`setup.go`):
- `setupPageData` gets `QuickStart quickStartPanel`.
- In `renderSetupPage`, after the auto-advance re-read and before the nonce:

```go
	var quickStart quickStartPanel
	if progress.Ready && handler.quickStartWired() {
		// The panel is a convenience on this page: a read error hides it, as the
		// admin home does with the setup banner.
		if panel, err := handler.loadQuickStartPanel(r.Context(), actor, cookie.Value, true); err == nil {
			quickStart = panel
		} else {
			handler.logger.Warn("quick start panel unavailable", "error", err)
		}
	}
```

- Template: inside `{{if .Progress.Ready}}`, right after the `#setup-ready` section's `</section>`:

```html
    {{if .QuickStart.Wired}}
    <section class="card" id="quick-start">
      <h2>Quick start: give a team a starter pack</h2>
      {{if eq .QuickStart.State.Status "done"}}
      <p id="quick-start-done">Done: <strong>{{.QuickStart.State.PackName}}</strong> is the default pack for {{if .QuickStart.State.TeamName}}<strong>{{.QuickStart.State.TeamName}}</strong>{{else}}a team that was deleted{{end}}. Engineers in that team get it on their next sync.</p>
      <p class="meta"><a href="/admin/quick-start">Give another team a starter pack</a> · <a href="/admin/packs/assignments">See pack assignments</a> · <a href="/admin/teams">Add engineers to the team</a> · <a href="/admin/projects">Add a project</a></p>
      {{else if eq .QuickStart.State.Status "skipped"}}
      <p id="quick-start-skipped">You skipped the quick start. You can pick it up any time.</p>
      <p><a class="view" id="quick-start-resume" href="/admin/quick-start">Resume quick start →</a></p>
      {{else}}
      <p class="meta">Pick a role's starter pack and a team. Engineers in that team get it the next time their Leorna client syncs.</p>
      {{template "quick-start-offer" .QuickStart}}
      {{end}}
    </section>
    {{end}}
```

The panel must contain **no** nested `<section>`, so a `(?s)<section class="card" id="quick-start">(.*?)</section>` regex captures it whole. Add `quickStartCSS` to the setup page's `<style>`.

Admin home (`handler.go:754-755`): in the `Setup.Ready` branch, after `Review setup</a>`:

```html
{{if .QuickStart}}{{if ne .QuickStart.Status "done"}} · <a id="quick-start-banner" href="/admin/quick-start">{{if eq .QuickStart.Status "skipped"}}Resume quick start{{else}}Start the quick start{{end}}</a>{{end}}{{end}}
```

In `admin()`, after the setup banner block:

```go
	var quickStart *onboarding.QuickStartState
	if setup != nil && setup.Ready && handler.quickStartWired() {
		if state, err := handler.quickStart.State(r.Context(), session.Principal); err == nil {
			quickStart = &state
		} else {
			handler.logger.Warn("quick start banner unavailable", "error", err)
		}
	}
```

and pass `QuickStart: quickStart` in `adminPageData`.

**Wiring** (`cmd/control-plane/main.go:191`):

```go
	builder := pack.NewBuilderService(repository)
	application.SetPackBuilder(builder)
	quickStart, err := onboarding.NewQuickStart(shippedLibrary, repository, builder, repository, repository, repository)
	if err != nil {
		return err
	}
	application.SetQuickStart(quickStart)
```

### D7. Auth, tenant and input boundaries
- Every route is `requireSession(requireAdmin(…))`: a member gets 403, a signed-out GET gets 302 to login, a signed-out POST 401.
- Both POSTs go through `adminForm`: form-encoded only, 4 KiB body bound (GO-HTTP-002), CSRF token equal to the cookie (GO-HTTP-006).
- Every store write re-checks the admin role inside its transaction (`beginOrg(…, true)`: `CreateTeam`, `CreatePack`, `AssignTeam`, `SkipQuickStart`, `CompleteQuickStart`).
- Tenant: state is keyed by `actor.TenantID` only; teams resolve within the tenant (`GetTeam`/`withTeam`); `CompleteQuickStart` re-checks the team's tenant and the composite pack key refuses another tenant's pack; reads join names on `tenant_id`. Body fields never carry a tenant.
- Input: `starter` must be one of the four keys (never echoed); team id via `GetTeam` (malformed → not found); new team name trimmed, 1–200 runes (`validTeamName`), unique per tenant.
- Ordering: every refusal (unknown starter, team choice, unknown team, setup not ready, member, CSRF) happens before the first write; a taken team name is the first write's own refusal, so nothing else is written.
- Concurrency: `TrySetupLock` serializes picks per tenant (a second submit just redirects); skip and complete serialize on the row (`FOR UPDATE`, `ON CONFLICT`).
- Templates are `html/template` (GO-XSS-001); SQL is parameterized (GO-INJECT-001); redirects are fixed paths.

### D8. How the next sync delivers the pack (AC2)
No new sync code. After `AssignTeam`, `ResolveForProject` returns the pack version for every project in the team without its own override, so an engineer who is a team member gets `status: "assigned"`, `packName: "Backend starter pack"`, one manifest entry per item (multi-file items add their supporting files), and `/content` returns the bodies. AC2's test proves it through the real HTTP endpoints with a member's real desktop token. A project with its own override keeps that override (unchanged behaviour; Assumption 5).

### D9. OpenAPI and the client
No OpenAPI change: the quick start is admin-console HTML, like the setup wizard, and engineers keep using the existing bundle endpoints. `make contracts-check` stays green with no edit. `leorna-client` generates code from its own snapshot `api/control-plane.openapi.yaml`; nothing to regenerate, no client branch.

## Tasks (builder, test-first)

Common variables (adjust `SCR` to your scratchpad):

```bash
WT=~/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start
BASE=6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f
SCR=<scratchpad>/86bcm902a-builder          # mkdir "$SCR" (no -p)
BIG=$HOME/.cache/86bcm902a-builder           # mkdir; TMPDIR, Chrome profiles, binaries, detached copies
EVID=$HOME/.hermes/plans/leorna/evidence/86bcm902a
TOOLS=$HOME/.local/leorna-toolchain
GITLEAKS_BIN=/usr/local/bin/gitleaks          # 8.30.1, CI's version
export PATH="$TOOLS/go/bin:$TOOLS/bin:$PATH" GOTOOLCHAIN=local TMPDIR="$BIG/tmp"
PGPORT=$(docker port leorna-test-pg 5432 | sed -n 's/.*://p' | head -1)        # 55432 today
PGPASS=$(docker inspect leorna-test-pg --format '{{range .Config.Env}}{{println .}}{{end}}' | sed -n 's/^POSTGRES_PASSWORD=//p')
[ -n "$PGPASS" ] || { echo "empty test-pg password"; exit 1; }
export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPASS}@127.0.0.1:${PGPORT}/leorna_86bcm902a_test?sslmode=disable"
```

Keep the DB URL and password inside scripts; never print them in a capture or log. Never touch `.claude/worktrees/86bcm901*`, their branches, their `leorna_86bcm901*` databases, their evidence folders, or the `leorna-pg` container.

### B0. Worktree and environment (stop conditions)
1. From `~/Leorna/leorna-control-plane` (on `main`, clean apart from untracked `.claude/`): run the HTTPS fetch through gh (`leorna` skill step 7.1). If GitHub `main` moved past `$BASE`, fast-forward the main checkout's `main` (`git merge --ff-only origin/main`), use the new SHA as `BASE` and list `git diff --name-only 6c1709e origin/main`. If a `000024_*` migration arrived (901y), use the next free number for ours everywhere this plan says 24.
2. `git worktree add -b feat/86bcm902a-quick-start "$WT" "$BASE"`; then `git -C "$WT" status --porcelain` is empty and `rev-parse HEAD` = `$BASE`. Otherwise stop and report.
3. Tools: `go version` = 1.27.3, `golangci-lint --version` = 2.14.0, `govulncheck -version` = v1.7.0, `gitleaks version` = 8.30.1, `make` and `gcc` present, `go env CGO_ENABLED` = 1. Write them to `$EVID/tools.txt` (`mkdir -p "$EVID"`). If one is missing or another version, stop `blocked: tools`.
4. Postgres: `docker exec leorna-test-pg createdb -U leorna leorna_86bcm902a_test` and `leorna_86bcm902a_base_test` (only these). If the container is stopped, `docker start leorna-test-pg`.
5. Chrome: `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu ~/.cache/chrome-for-testing/chrome-linux64/chrome --version` → append to `tools.txt`.
6. Base baseline in a separate detached worktree: `git -C "$WT" worktree add --detach "$BIG/base-6c1709e" "$BASE"`; there, with `LEORNA_TEST_DATABASE_URL` pointing at `leorna_86bcm902a_base_test`, run `GOLANGCI_LINT="$TOOLS/bin/golangci-lint" GOVULNCHECK="$TOOLS/bin/govulncheck" GITLEAKS="$GITLEAKS_BIN" make check` and `bash ./scripts/test-module-add.sh`; save `$EVID/baseline-6c1709e.txt` with `EXIT=` lines. Any failure there is pre-existing: record its identity, don't fix it. Keep the copy for B0.7, then remove it with `git worktree remove`.
7. Before-state captures (E2 with `-phase before`) from a binary built in the base copy: `ac1-setup-ready-before-6c1709e.png` (fresh install, auto setup: the ready panel with no quick start) and `ac2-assignments-before-6c1709e.png` (`/admin/packs/assignments`: "No assignments yet").

### B1. Starters and resolution (`internal/onboarding/starters.go`, `quickstart.go`, `quickstart_test.go`)
1. **RED** (`quickstart_test.go`, package `onboarding`, no DB):
   - `TestResolveStartersCoversRoleMappingAndRequirements`: `lib, _ := library.Embedded()`; `offers, err := ResolveStarters(lib)`; no error; keys in order `backend`, `frontend`, `platform-devops`, `secure-coding`; for each offer, its first `len(Starter.Items)` items are exactly the listed refs in order; every item's `Requires` (look the item up in `lib`) is in the same offer; no ref appears twice; `len(Items) <= pack.MaxItems`. Plus one fixed fact that ties the closure to real content: Backend contains `skill/security-and-hardening` (required by prompt `review`) although the card's Backend list doesn't name it.
   - `TestResolveStartersRejectsMissingItem`: copy `lib`, drop `prompt/webperf` from `Items`; the error names `frontend` and `prompt/webperf`.
   - `TestStartersReturnsACopy`: changing `Starters()[0].Items[0]` doesn't change the next call.
   - Run `go test ./internal/onboarding/` → fails to build (`undefined: ResolveStarters`). That's the expected RED.
2. **GREEN:** add `starters.go` and the types plus `ResolveStarters` from D4. Same command passes; `TestEvaluate` still passes.

### B2. `QuickStart.Apply`, `Skip`, `State` (same files)
1. **RED** with in-file fakes (`fakeCatalog`, `fakePacks`, `fakeAssigner`, `fakeTeams`, `fakeState`), each recording calls in order into one shared `[]string` log:
   - `TestQuickStartApplyRefusesBeforeAnyWrite`: unknown starter → `ErrUnknownStarter`; both team id and name → `ErrTeamChoice`; neither → `ErrTeamChoice`; catalog missing an item → `ErrStarterContentMissing`; `GetTeam` returning `store.ErrNotFound` → that error. In each case the log holds no `CreateTeam`, `CreatePack`, `AssignTeam` or `CompleteQuickStart`.
   - `TestQuickStartApplyCreatesTeamFirstAndStopsOnTakenName`: `CreateTeam` returns `store.ErrConflict` → `errors.Is(err, ErrTeamNameTaken)` and no `CreatePack`.
   - `TestQuickStartApplyOrderAndResult`: new pack path. The log is exactly `ListLibraryItems, GetTeam, Packs, CreatePack, AssignTeam, CompleteQuickStart`; `CreatePack` gets the offer's pack name and the catalog IDs in offer order; `AssignTeam` gets the created version; the completion carries starter key, pack id and team id; `CreatedPack` true.
   - `TestQuickStartApplyReusesStarterPackByName`: `Packs` returns `" backend STARTER pack "` → no `CreatePack`; assigns its `LatestVersion`; `CreatedPack` false. And `CreatePack` → `pack.ErrNameTaken`, then `Packs` lists it → reused, no error.
   - `TestQuickStartApplyStopsWhenAssignFails`: `AssignTeam` error → returned; no `CompleteQuickStart`.
2. **GREEN:** the service from D4. Run `go test -count=1 ./internal/onboarding/`.

### B3. Migration 24 and the store (`internal/store/postgres/…`)
1. **RED** `internal/store/postgres/quick_starts_test.go`, `TestQuickStartStoreWithPostgres` (pattern of `TestPackBuilderStoreWithPostgres`: `testPool`, `resetDatabase`, `ApplyMigrations`, `RollbackMigrations` in cleanup; admin, member, other-tenant admin; one library row via `insertBuilderLibraryItem`; a pack via `repository.CreatePack`; teams via `CreateTeam`). Subtests:
   - `no_row_is_offered`
   - `skip_records_skipped_with_one_audit_record` (`quickstart.skip`, target = tenant id, after has `status: skipped`)
   - `skip_again_or_after_done_changes_nothing` (no new audit row, status unchanged)
   - `complete_records_done_with_names_and_audit` (state has pack and team names; `quickstart.complete` with before/after)
   - `complete_again_replaces_the_record`
   - `member_cannot_skip_or_complete` (`org.ErrForbidden`, no row, no audit)
   - `other_tenant_team_or_pack_is_not_found` (`store.ErrNotFound`, nothing written)
   - `invalid_completion_is_refused` (bad starter slug, malformed ids → `org.ErrInvalid`)
   - `other_tenant_never_sees_this_state`
   - `deleting_the_team_keeps_done_without_a_team_name`
   - `done_shape_is_enforced_by_the_database` (direct INSERT of `status='done'` without a starter → SQLSTATE 23514)
   Run `go test -count=1 -run '^TestQuickStartStoreWithPostgres$' ./internal/store/postgres/` → build fails (expected RED).
2. **GREEN:** add the two migration files (D3) and `quick_starts.go` (D5). Add `"quick_starts"` to both table lists in `TestMigrationRoundTrip` (`store_test.go:34`, `:104`) and to the `resetDatabase` drop list (`:499`), before `pack_lineages`, `teams` and `tenants`. Run the store test and `TestMigrationRoundTrip`.

### B4. AC tests first (`internal/web/quick_start_test.go`), then the web layer
1. Write the fixture and the five AC tests (see "AC tests" below). Run each AC command → `[build failed]` (`undefined: onboarding.NewQuickStart`, `(*Handler).SetQuickStart`). That's the RED.
2. **GREEN:** `quick_start.go` (D6), the `handler.go` routes, field, `adminPageData` and banner, the `setup.go` panel and data, `main.go` wiring.
3. Run the five AC tests, then the existing neighbours unchanged: `TestSetupWizardWithPostgres`, `TestConnectExistingDatabaseWithPostgres`, `TestAutoSetupUsesControlPlaneDatabase`, `TestSetupIsAdvancing`, `TestSetupUnavailableWithoutDependencies`, the `admin_ui_test.go` tests, `TestPromptItemPublishToClientBundleWithPostgres`, `TestPackBuilder*`, `TestAssign*`. If `waitForStep` times out once under load, rerun that test alone before calling it a regression.

### B5. Mutation checks (`mutation-testing-discipline`)
Apply each mutant alone, run the named test(s), confirm it fails on the line that checks that guard, restore, confirm green. Record them in `$EVID/mutations-<sha7>.txt` (mutant, file:line, command, failing assertion line, restored). Use never-true comparisons, not `false`, so the build stays valid.

| # | Mutant | Must fail |
| --- | --- | --- |
| M1 | `GET /admin/quick-start` route without `requireAdmin` | AC4 `member` subtest |
| M2 | `SkipQuickStart` opens `beginOrg(…, false)` | store `member_cannot_skip_or_complete` |
| M3 | `CompleteQuickStart` drops the team tenant check | store `other_tenant_team_or_pack_is_not_found`; AC4 `other_company_team` stays green (GetTeam catches it first), which is expected |
| M4 | `quickStartTx` drops `WHERE q.tenant_id=$1` | store `other_tenant_never_sees_this_state`; AC4 `other_company_state_is_separate` |
| M5 | `SkipQuickStart` writes even when done | AC3 `skip_after_done_changes_nothing`; store subtest |
| M6 | `Apply` skips `GetTeam` and assigns the raw id | AC4 `unknown_team` (a pack gets written) |
| M7 | `quickStartAssign` ignores `!progress.Ready` | AC4 `setup_not_finished` |
| M8 | `ResolveStarters` skips the `Required` loop | `TestResolveStartersCoversRoleMappingAndRequirements`; AC2 item set |
| M9 | `CompleteQuickStart` drops `appendAudit` | store `complete_records_done_with_names_and_audit`; AC2 audit check |
| M10 | `Apply` creates the pack before the team | `TestQuickStartApplyCreatesTeamFirstAndStopsOnTakenName`; AC4 `team_name_already_used` |
| M11 | setup panel shown only when **not** ready | AC1 |
| M12 | `existingPack` compares names case-sensitively | `TestQuickStartApplyReusesStarterPackByName` |

### B6. Docs and records, then the gates, then the evidence (E1–E4)
See the sections below.

### B7. Hand back at `ready-for-review`
Return the head SHA, `git diff --stat $BASE...HEAD`, the gate summary with each `EXIT=`, the AC → test → log → screenshot table, the mutation table, anything NOT VERIFIED with its reason, `found_else[]`, `skill_lessons[]`, and a one-line proposed status line for `leorna-workflow.md`. Commit as you go, `feat(86bcm902a): …`, explicit paths, plain `git commit` (never override the author), no `CLAUDE.md`, no `.github/`. Don't push.

## AC tests (`internal/web/quick_start_test.go`)

**Fixture** (one file; helpers prefixed `quickStart` to avoid name clashes with existing test helpers):

```go
type quickStartFixture struct {
	setupFixture
	quick  *onboarding.QuickStart
	offers []onboarding.StarterOffer
	lib    library.Library
}

func newQuickStartFixture(t *testing.T) quickStartFixture {
	t.Helper()
	fixture := newSetupFixture(t) // skips without LEORNA_TEST_DATABASE_URL
	repo, handler := fixture.repository, fixture.handler
	handler.SetTeams(repo)
	handler.SetProjects(repo)
	handler.SetLibrary(repo)
	handler.SetPackVersions(pack.NewVersionService(repo))
	handler.SetPackAssignments(repo)
	handler.SetBundleServer(repo)
	handler.SetClientAuth(repo)
	handler.discovery = &contracts.ClientDiscovery{BackendUrl: "https://cp.example", TenantId: uuid.MustParse(string(fixture.admin.TenantID)), TenantName: "Example"}
	builder := pack.NewBuilderService(repo)
	handler.SetPackBuilder(builder)
	lib, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	quick, err := onboarding.NewQuickStart(lib, repo, builder, repo, repo, repo)
	if err != nil {
		t.Fatal(err)
	}
	handler.SetQuickStart(quick)
	return quickStartFixture{setupFixture: fixture, quick: quick, offers: quick.Offers(), lib: lib}
}
```

Helpers to write in the same file:
- `finishSetupAuto(t, client)`: `fixture.handler.EnableAutoSetup()`, then `waitForStep(t, client, "pack", "done")`, returning the page body.
- `finishSetupManual(t, client)`: `connectScaleway`, `postRedirect` to `/admin/setup/database` with `databaseForm("leorna-db")`, `waitForStep(…, "database", "done")`, `postRedirect` to `/admin/setup/pack`, return `get("/admin/setup")`.
- `quickStartPanelHTML(t, body)`: the inner HTML of `(?s)<section class="card" id="quick-start">(.*?)</section>` (fails if absent); `quickStartStarterHTML(t, panel, key)`: inner HTML of `(?s)<label class="starter" id="starter-KEY">(.*?)</label>`.
- `quickStartPost(t, client, path, form) *http.Response`: adds `csrfToken` unless set, posts form-encoded, doesn't follow redirects (the test client already doesn't; check `newTestClient`).
- `quickStartCounts(t) map[string]int`: `count(*)` of `teams`, `pack_lineages`, `pack_versions`, `pack_assignments`, `quick_starts`, `audit_records` over the fixture schema (`fixture.pool`).
- `quickStartMint(t, principal) string`: copy of `mint` from `prompt_publish_test.go:73-89`.
- `quickStartBundle(t, token, projectID) contracts.ClientBundle` and `quickStartContent(t, token, projectID, digest) contracts.ClientBundleContent`: GET with `Authorization: Bearer`, assert 200, unmarshal.
- `expectedItems(offer)`: the set of `kind/name` from `offer.Items`.

Scope every HTML assertion to its element (panel, starter label, alert), never whole-body `Contains`. Assert JSON by unmarshalling. Never hardcode item versions or counts: read them from `fixture.offers`, `fixture.lib` and `ListLibraryItems`.

### AC1 `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres`
- `before_setup_is_finished_there_is_no_offer`: fresh fixture; `GET /admin/setup` has no `id="quick-start"`; `GET /admin/quick-start` → 200 with `#quick-start-not-ready` and no `id="quick-start-form"`.
- `finishing_the_wizard_offers_the_four_role_packs`: `finishSetupManual`; the panel has exactly four `name="starter"` radios with values `backend`, `frontend`, `platform-devops`, `secure-coding`, in that order; each `starter-<key>` label contains its `Role`, its `PackName` and one `data-item="kind/name"` per item of that offer (and no other `data-item`); the panel has `#quick-start-team-name`, no `<select` (no teams yet), `id="quick-start-assign"` and `id="quick-start-skip"`. Nothing was written: `quick_starts` and `pack_lineages` are 0.
- `existing_teams_are_offered`: create two teams with `repository.CreateTeam`; the panel's `<select id="quick-start-team-id">` lists both names with their ids.

### AC2 `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres`
Setup: `finishSetupAuto`; team T "Backend team" (`CreateTeam`); `AddTeamMember(T, member)`; project P in T expiring in 24 h (`CreateProject`); `engineer := quickStartMint(t, fixture.member)`.
- `backend_pack_reaches_the_engineers_next_sync`:
  - Before: `quickStartBundle(engineer, P)` has `Status == contracts.Empty` and no files.
  - `POST /admin/quick-start` with `starter=backend`, `team_id=T` → 303, `Location: /admin/quick-start`.
  - `GET /admin/quick-start` → `#quick-start-done` names "Backend starter pack" and "Backend team".
  - Store: `ListPacks` has exactly one pack, named "Backend starter pack", `LatestNumber` 1. `GetPack` items as `kind/name/version` equal the backend offer's items, each at the version `ListLibraryItems` reports for that kind and name.
  - `ListAssignments`: exactly one, a team default for T with `Version` = that pack's version.
  - Audit (direct query on `audit_records` for the admin's tenant): one `pack.create` (target = pack id), one `pack.assign`, one `quickstart.complete` (target = tenant id); all with actor = admin.
  - After: `quickStartBundle(engineer, P)` has `Status == contracts.Assigned`, `Manifest.PackName == "Backend starter pack"`, `Manifest.PackVersion` = the version, and the set of `kind/name` over manifest files equals `expectedItems(backend)`. `quickStartContent(engineer, P, Lockfile.Digest)` returns one item per expected ref, each `Body` equal to the shipped library body of that kind and name (`fixture.lib`).
- `a_new_team_named_in_the_quick_start_gets_the_pack`: `starter=frontend`, `team_name=Web team` → 303; a team "Web team" exists (audit `team.create`), its default assignment is the "Frontend starter pack" version, and the state is done with starter `frontend`.
- `the_same_starter_again_reuses_its_pack`: `starter=backend`, `team_name=Platform team` → 303; still exactly one "Backend starter pack" pack, with one version; the new team's default is that same version.
- `two_submits_at_once_make_one_pack`: on a fresh fixture, two goroutines post `starter=secure-coding`, `team_id=<team>` at once; each gets 303; afterwards exactly one "Secure coding starter pack" pack and one default for the team.

### AC3 `TestQuickStartAC3SkipThenResumeLaterWithPostgres`
Setup: `finishSetupAuto`.
- `skip_records_it_and_moves_the_offer_out_of_the_way`: `POST /admin/quick-start/skip` → 303, `Location: /admin/setup`. "Later": a **new** session for the same admin (`fixture.login` with another token). `GET /admin/setup`: the panel has `#quick-start-skipped` and `<a … id="quick-start-resume" href="/admin/quick-start">`, and no `id="quick-start-form"`. `GET /admin` → `#setup-banner` has `id="quick-start-banner"` with "Resume quick start". Nothing but the skip was written: `quick_starts` = 1 (status skipped), `pack_lineages` = 0, `pack_assignments` = 0, one `quickstart.skip` audit row.
- `resume_later_offers_the_packs_again_and_finishes`: `GET /admin/quick-start` → `#quick-start-skipped-note` and the four starter radios; `POST /admin/quick-start` `starter=secure-coding`, `team_name=Security team` → 303; `GET /admin/setup` panel has `#quick-start-done` naming "Secure coding starter pack" and "Security team"; `GET /admin` banner has no `quick-start-banner`; `quick_starts` status done.
- `skip_after_done_changes_nothing`: `POST /admin/quick-start/skip` → 303; status still done; no second `quickstart.skip` audit row.

### AC4 `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres`
Setup: `finishSetupAuto`; team T in the admin's tenant; `fixture.other` (another tenant's admin) finishes auto setup in their own session and creates team OT. Each subtest takes `quickStartCounts` before, sends the request, checks the status (and `#quick-start-alert` text for 4xx HTML replies), and checks the counts are unchanged.
- `unknown_starter`: `starter=devops-everything`, `team_id=T` → 400.
- `no_team`: `starter=backend` only → 400. `blank_new_team_name`: `team_name=   ` → 400.
- `team_and_new_team`: both `team_id=T` and `team_name=New` → 400.
- `unknown_team`: random UUID → 404; malformed id `not-a-uuid` → 404.
- `other_company_team`: `team_id=OT` → 404.
- `team_name_already_used`: `team_name=<T's name>` → 409, alert "A team with that name already exists"; the form keeps the typed name and the chosen radio.
- `setup_not_finished` (its own fresh fixture, no setup): `POST /admin/quick-start` → 409 with the "Finish setup first" alert; `POST /admin/quick-start/skip` → 409.
- `member`: `GET /admin/quick-start`, `POST /admin/quick-start`, `POST /admin/quick-start/skip` → 403 each.
- `bad_csrf`: both POSTs with `csrfToken` = 43 other characters → 403.
- `signed_out`: `GET /admin/quick-start` → 302 to `/v1/auth/google/login`; `POST /admin/quick-start` → 401.
- `other_company_state_is_separate`: the admin skips (this one writes: check exactly `quick_starts` +1 and `audit_records` +1); then the other company's `GET /admin/quick-start` shows the offer with no skipped note, and its own skip leaves the admin's row unchanged.

### AC5 `TestQuickStartAC5FreshInstallEndToEndWithPostgres`
A fresh install, as the installer runs it: a new fixture (empty schema, no seed base, no library rows), `EnableAutoSetup()`, and the admin's first sign-in (the fixture's `ResolveOrCreateGoogleUser` made the tenant).
1. `GET /admin/setup` until the pack step is done (`waitForStep`), with no POST: the database step says the control-plane database, and the quick-start panel offers the four packs.
2. `POST /admin/quick-start` `starter=backend`, `team_name=Backend team` → 303.
3. Through the real admin forms: `POST /admin/teams/{teamId}/members` with `userId=<member>` → 303; `POST /admin/projects` with `teamId`, `name=Payments API`, `expiresAt=<now+7 days, 2006-01-02T15:04>` → 303 (read the redirect targets from `teams_view.go` and `projects_view.go`).
4. `engineer := quickStartMint(t, fixture.member)`. `GET /v1/client/projects` lists "Payments API"; its bundle is `assigned` with "Backend starter pack" and the backend item set; `/content` returns the bodies.
5. `GET /admin/setup` panel shows `#quick-start-done`.

## Per-AC proof

Run each from `$WT` with `LEORNA_TEST_DATABASE_URL` set to your own `_test` DB.

| AC | Command (runs only that test) | Why it fails on base `6c1709e` (old-code check) | Evidence (in `$EVID`) |
| --- | --- | --- | --- |
| AC1 | `go test -v -count=1 -run '^TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres$' ./internal/web/` | Base plus `internal/web/quick_start_test.go` gives `[build failed]`: `undefined: onboarding.NewQuickStart`, `(*Handler).SetQuickStart`. Base's setup page has no `#quick-start` and there is no `/admin/quick-start`. | `ac1-quick-start-offered.png` (real setup page right after a fresh install's auto setup: "Your workspace is ready" and the four starter cards); before: `ac1-setup-ready-before-6c1709e.png`; log `ac1-<sha7>.log` |
| AC2 | `go test -v -count=1 -run '^TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres$' ./internal/web/` | Same build failure. Base has no way to pick a starter or assign it from setup. | `ac2-assignment-created.png` (real `/admin/packs/assignments`: "Team default · Backend team · <version>"); before: `ac2-assignments-before-6c1709e.png`; extras `ac2-pack-and-team-chosen.png` (form filled, before submit), `ac2-quick-start-done.png`, `ac2-sync-terminal.png` (log rendering of the AC2 run: empty before, assigned after); log `ac2-<sha7>.log` |
| AC3 | `go test -v -count=1 -run '^TestQuickStartAC3SkipThenResumeLaterWithPostgres$' ./internal/web/` | Same build failure; base has no skip or resume. | `ac3-skipped-after.png` (setup page after Skip: "You skipped…", "Resume quick start →"); before: `ac3-skip-before.png` (the offer with "Skip for now"); extras `ac3-resume-offer.png` (`/admin/quick-start` after clicking Resume), `ac3-resumed-done.png`, `ac3-banner-resume.png` (**element** screenshot of `#setup-banner` only; never the whole `/admin` page); log `ac3-<sha7>.log` |
| AC4 | `go test -v -count=1 -run '^TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres$' ./internal/web/` | Same build failure. | `ac4-refused-terminal.png` (log rendering: command, every PASS line, `EXIT=0`); extra `ac4-team-name-taken-alert.png` (real page with the 409 alert); log `ac4-<sha7>.log` |
| AC5 | `go test -v -count=1 -run '^TestQuickStartAC5FreshInstallEndToEndWithPostgres$' ./internal/web/` | Same build failure. | The recording (E2): `ac5-01-…png` to `ac5-08-…png` from the real binary on an empty DB, `ac5-demo-<sha7>.log` (timestamped steps and redacted API results), and `ac5-08-desktop-sync.png` as its main screenshot; log `ac5-<sha7>.log` |

None of these is `base_exempt`. For the verifier and auditor (`ac-verification.md`): the base copy needs only `internal/web/quick_start_test.go`. It imports `internal/onboarding`, which exists on base, so the failure is `[build failed]` with `undefined:`, not `[setup failed]`. No AC test has a subtest that can skip once `LEORNA_TEST_DATABASE_URL` is set.

## Evidence capture on this desktop (E1–E4)

No `osascript`, `screencapture`, PIL, ImageMagick or `ffmpeg` here. Use chromedp v0.16.0 (already in `go.mod`) with Chrome for Testing, as 86bcm901w did. Start from a copy of `~/.hermes/plans/leorna/evidence/86bcm901w/verifier/capture-main.go` (read-only; copy it into `$SCR/capture/`): its allocator flags (`NoSandbox`, `DisableGPU`, `disable-software-rasterizer`, `headless=new`) and its `waitFor` loop (poll `chromedp.Evaluate` every 250 ms, ignore errors while the page navigates, until content only the new page has is there and `document.readyState == 'complete'`, up to 30 s) work here. A plain `WaitVisible` after a redirecting submit can match the old page.

**E1. Run the real console on an empty database** (dev mode, loopback only, throwaway DB; adds no auth code):

```bash
docker exec leorna-test-pg createdb -U leorna leorna_86bcm902a_demo
go build -o "$BIG/control-plane" ./cmd/control-plane
python3 -I -c 'import json,sys; m=json.load(open(sys.argv[1])); m["server"]["address"]="127.0.0.1:18452"; json.dump(m, open(sys.argv[2],"w"), indent=2)' config/manifest.example.json "$BIG/manifest.json"
ss -ltn 'sport = :18452' | grep -q LISTEN && { echo "port busy: pick another"; exit 1; }
env LEORNA_MANIFEST_PATH="$BIG/manifest.json" \
    LEORNA_DATABASE_URL="postgres://leorna:${PGPASS}@127.0.0.1:${PGPORT}/leorna_86bcm902a_demo?sslmode=disable" \
    LEORNA_DEV_MODE=1 LEORNA_AUTO_SETUP=1 LEORNA_PUBLIC_BASE_URL='https://pending.leorna.invalid' \
    LEORNA_SECRET_ENCRYPTION_KEY="$(openssl rand -base64 32)" \
    "$BIG/control-plane" > "$BIG/demo-server.log" 2>&1 &
echo $! > "$BIG/demo-server.pid"
```

Use port `$PGPORT` (55432), **not** 5432 (that is `leorna-pg`; 901w's plan had this wrong, found-else #15). Run it as a background job; never print the key or the URL. Poll `curl -fsS http://127.0.0.1:18452/readyz` (≤ 60 s). If the manifest key or readiness path differs, read `config/manifest.example.json` and `internal/health` and adapt; don't change product code. `LEORNA_AUTO_SETUP=1` is the installer's fresh-install mode; the placeholder public URL hides the client card. For B0.7, build and run the base copy's binary the same way on `leorna_86bcm902a_base_demo`.

**E2. Drive and capture: one continuous run = the AC5 recording** (`$SCR/capture`, flags `-base`, `-out`, `-chrome`, `-profile` (a `mktemp -d "$BIG/chrome-XXXX"` dir), `-phase before|head`; window 1440×1800; `chromedp.FullScreenshot(&png, 100)`; log each step with a UTC timestamp to `ac5-demo-<sha7>.log`):

| Step | Action | Capture |
| --- | --- | --- |
| 1 | `Navigate(base + "/dev/login?next=" + url.QueryEscape("/admin/setup"))`; `waitFor` `#setup-ready` and `#quick-start` | `ac5-01-setup-ready-with-quick-start.png`; copy to `ac1-quick-start-offered.png` and `ac3-skip-before.png` |
| 2 | Click `#quick-start-skip`; `waitFor` `#quick-start-resume` | `ac5-02-skipped.png` = `ac3-skipped-after.png` |
| 3 | Navigate `/admin` and take an **element** screenshot of `#setup-banner` only (`chromedp.Screenshot("#setup-banner", &png, chromedp.ByQuery)`) | `ac3-banner-resume.png` |
| 4 | Navigate `/admin/setup`, click `#quick-start-resume`; `waitFor` `#quick-start-form` and `#quick-start-skipped-note` | `ac5-03-resume.png` = `ac3-resume-offer.png` |
| 5 | Click `#starter-backend input`; type `Backend team` into `#quick-start-team-name` | `ac5-04-backend-and-team.png` = `ac2-pack-and-team-chosen.png` |
| 6 | Click `#quick-start-assign`; `waitFor` `#quick-start-done` | `ac5-05-done.png` = `ac2-quick-start-done.png` = `ac3-resumed-done.png` |
| 7 | Navigate `/admin/packs/assignments` | `ac2-assignment-created.png` |
| 8 | Navigate `/admin/projects`, create "Payments API" for Backend team (expiry in 7 days) | `ac5-06-project.png` |
| 9 | Desktop sign-in like the client (Go `net/http` in the same program): `POST /v1/client/authorizations` (body per the contract's `ClientAuthStart`, with a PKCE-style verifier you generate), then in the browser `Navigate(base + "/client/authorize?user_code=<code>")` and approve. **Don't screenshot that page** (it shows the code). Then `POST /v1/client/token` (`ClientAuthExchange`) → token, kept in memory only | none |
| 10 | `GET /v1/client/projects` → find Payments API; `GET …/bundle`; `GET …/bundles/<digest>/content` | write to the demo log: status, packName, packVersion, number of files, each file's path and sha256, the lockfile digest, and the content items' kind/name/sha256. Never the token, tenant id, user code or bodies |
| 11 | On `/admin/quick-start`, pick Frontend and type `Backend team` again; submit | `ac5-07-team-name-taken.png` = `ac4-team-name-taken-alert.png` |
| 12 | Render the demo log's step 10 block as HTML `<pre>` (E3 recipe) | `ac5-08-desktop-sync.png` (labelled "rendering of the real API responses") |

The demo's desktop client signs in as the demo admin: dev mode has one user and no way to add a second one, so the member-engineer case is proven by AC2's and AC5's tests, not by the recording; EVIDENCE.md says so. If `/client/authorize` or the token call needs something this recipe doesn't cover, read `internal/web/client_auth.go` and the contract and adapt the driver only. If it can't be done, keep steps 1–8, 11 and 12 (from the API calls you could make) and mark the desktop-sync part of the recording **NOT VERIFIED** with the reason.

`-phase before` (B0.7, base binary): step 1 only, saved as `ac1-setup-ready-before-6c1709e.png`, plus `/admin/packs/assignments` as `ac2-assignments-before-6c1709e.png`.

**E3. Terminal captures:** for each AC, on the final head: `( set -o pipefail; echo "HEAD=$(git rev-parse HEAD)"; echo "\$ <command>"; <command>; echo "EXIT=$?" ) > "$EVID/ac<n>-<sha7>.log" 2>&1`. Render a log as HTML with `python3 -I -c 'import html,sys; print("<!doctype html><meta charset=utf-8><style>body{background:#0b0f14;color:#e6edf3;font:13px/1.35 ui-monospace,monospace;margin:16px}</style><pre>"+html.escape(open(sys.argv[1]).read())+"</pre>")' <log> > "$SCR/<name>.html"` and screenshot it with `env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu ~/.cache/chrome-for-testing/chrome-linux64/chrome --headless=new --no-sandbox --disable-gpu --disable-software-rasterizer --hide-scrollbars --user-data-dir="$(mktemp -d "$BIG/chrome-XXXX")" --window-size=1400,<h> --screenshot=<png> "file://$SCR/<name>.html"`. Open each PNG: the `HEAD=` line, the command and `EXIT=0` must be on screen; raise `<h>` if not. Produces `ac4-refused-terminal.png`, `ac2-sync-terminal.png`, `ac5-08-desktop-sync.png`.

**E4. Clean up and privacy:** `kill "$(cat "$BIG/demo-server.pid")"` and confirm with `ps -p` it's gone; `docker exec leorna-test-pg dropdb -U leorna leorna_86bcm902a_demo` (and the base demo DB). Look at every PNG and grep every log: no server domain, URL bar, tenant ID, token, user code, email, DB URL or password. Never capture `/admin` whole (email and tenant ID) or `/client/authorize` (the code). Team, pack and project names and the version ids from the throwaway DB are fine.

**`$EVID/EVIDENCE.md`:** head and base SHAs; one row per AC (AC → test → log → screenshot → what it shows); the AC5 recording's frame list with timestamps; gate logs with the `EXIT=` you read in each; the mutation table; the demo run notes (port, DBs created and dropped); tools; and anything NOT VERIFIED with its reason.

## Gates (builder on the final head; the verifier reruns them in a detached copy at the same SHA)

1. `GOLANGCI_LINT="$TOOLS/bin/golangci-lint" GOVULNCHECK="$TOOLS/bin/govulncheck" GITLEAKS="$GITLEAKS_BIN" make check` → `$EVID/gates-<sha7>.txt` with `EXIT=`. Echo `golangci-lint --version` and `govulncheck -version` first from the same PATH, and `make -n -s lint audit secrets` to show the bound binaries.
2. `bash ./scripts/test-module-add.sh` → `$EVID/module-add-<sha7>.txt`.
3. Postgres tests ran: `go test -json -count=1 -run 'WithPostgres|TestMigrationRoundTrip' ./internal/web/ ./internal/store/postgres/ ./internal/cloud/dbcheck/ > $EVID/pg-<sha7>.json`, read per test (Action plus that test's own Output). Every `TestQuickStart*` test and subtest passes with no skip. The only skips allowed are `TestTeamsAPIWithPostgres`'s two ClickHouse subtests (`LEORNA_TEST_CLICKHOUSE_URL not set`); any skip naming `LEORNA_TEST_DATABASE_URL` fails the gate.
4. `go test -count=1 ./internal/onboarding/` (the unit tests) → `$EVID/unit-<sha7>.txt`.
5. `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` after the `stories.json` edit → `story-gate-<sha7>.txt`.
6. Story-only secret scan: `gitleaks git --redact --log-opts="$BASE..HEAD"` → `gitleaks-story-<sha7>.txt`. `make secrets` scans every local ref, including sibling branches; if it fails on a commit that isn't ours, record it and don't touch their branches.
7. Since PR #94, CI also builds the image and checks its packaged scanner: in a detached copy, `docker build --no-cache --file Containerfile --tag leorna-86bcm902a:<sha7> .` (check the `RUN go build` step says DONE, not CACHED), then `docker run --rm --entrypoint /usr/local/bin/gitleaks leorna-86bcm902a:<sha7> version` prints `8.30.1`; remove the tag → `image-<sha7>.txt`.
8. `git diff --name-only $BASE...HEAD` has no `.github/` path and no `CLAUDE.md` → `changed-files-<sha7>.txt`.

There is no JS or browser UI test suite in this repo; the console's "UI tests" are the Go tests asserting on rendered HTML (the AC tests here).

## Docs and records

- **Module README, `internal/onboarding/README.md`:** a new section "## Quick start (86bcm902a)", about 15 lines: where it shows (setup ready panel, `/admin/quick-start`, admin banner); the four stand-in starters and that 86bcm901r replaces `starters.go`; required items added (`Library.Required`); newest stored versions; packs made through `CreatePack` and reused by name; team default through `AssignTeam`; new team inline; stored state (the one piece of onboarding with its own row: migration 24, skip/done, audited `quickstart.skip`/`quickstart.complete`, target = tenant id); refusals and the setup lock; the sync path unchanged; the tests by name; the demo steps. Also change the intro's "so the wizard keeps no state of its own" to say the quick start's answer is the one stored fact.
- **`internal/web/README.md`:** in "Setup wizard", rows for `GET /admin/quick-start`, `POST /admin/quick-start`, `POST /admin/quick-start/skip`, and a sentence on the ready panel and the banner link.
- **Root `README.md`:** in the authorization table, a row "`/admin/quick-start` and its skip | 403 | Allowed within tenant"; in "Setup wizard", one sentence: after setup, the quick start offers role starter packs and assigns one to a team.
- **`internal/audit/README.md`:** one sentence listing `quickstart.skip` and `quickstart.complete` (target = tenant id; status, starter, pack and team ids; no names).
- **OpenAPI:** no change (D9). Say so in the PR text.
- **`delivery/stories.json`:** append `"86bcm902a": {"name": "One-click quick start (starter pack -> team -> sync)", "prs": {"LeornaAI/leorna-control-plane": []}}` as the **last** entry, as text in the file's own 2-space format; the file is ASCII today, so the arrows are `->`. Check every earlier entry is unchanged by value.
- **Plan copy:** at go, the main session runs `mkdir -p ~/.hermes/plans/leorna/evidence/86bcm902a && install -m 444 <this plan> ~/.hermes/plans/leorna/evidence/86bcm902a/plan-approved.md`.
- **Evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm902a/`. The builder works at the root, the verifier only in `verifier/`, the auditor only in `auditor/`.
- **`leorna-workflow.md`:** agents don't edit memory. Each role's report ends with a one-line proposed status line; the main session records it.
- **CI files:** no `.github/` change (default rule).

## Follow-ups (not in this story)

- **F1 (86bcm901r):** confirm the role mapping; decide where starter definitions live (likely the content library); show the agreed packs in the catalog on every fresh install; prove sync in all three tools; re-version starter packs when library items get new versions. Replace `internal/onboarding/starters.go`'s list; the quick start reads only `Starters()`.
- **F2:** after 901r, decide whether setup still loads the seed "Leorna starter pack" as the base pack (its demo items overlap library 0.5–0.7 replacements; library README `:73-77`).
- **F3:** let the quick start add engineers and a first project inline; today it links to Teams and Projects.
- **F4 (902d / 901w F6):** Pack Assignments show the version id, not "pack name · version N".
- **F5:** a JSON API for the quick start if the installer or a CLI needs one (OpenAPI change then).

## Risks (and how the hand-over resolves each)

| # | Risk | Resolution |
| --- | --- | --- |
| R1 | **Migration number:** 901y will probably add a migration, and both stories would add `000024_*`. Different file names merge with no conflict, but `readMigrationSet` then refuses "migration version 24 is duplicated" and every DB test fails. | Whoever merges second renames its two migration files to the next free number (no SQL change) and re-runs the gates. At hand-over, the finisher lists `ls internal/store/postgres/migrations | cut -d_ -f1 | sort | uniq -d` on the trial merge with main and each open sibling head. |
| R2 | `delivery/stories.json`: #98 (901j) and 901y append last too. | Take main's file unchanged and append this story's entry last, as text; check earlier entries by value. |
| R3 | `store_test.go`'s two table lists and the `resetDatabase` drop list are single long lines; 901y adding a table conflicts there. | Keep both stories' table names in each list; run `TestMigrationRoundTrip`. |
| R4 | 901y may change `pack.BuilderService.CreatePack` (an order argument) or 901w's store. | This story calls only `CreatePack(ctx, actor, name, ids)` and `Packs(ctx, actor)` through the `PackMaker` port; adapt the call at merge (compile error, not silent). |
| R5 | `internal/web/handler.go` route block and `internal/web/README.md`: 901y may add lines nearby. | Keep both; the routes are independent. |
| R6 | #98 bumps library item versions (config, MCP). | No starter uses those items, and tests read versions from the library, never hardcode them. |
| R7 | Stand-in drift: if 901r confirms a different mapping, companies that already ran the quick start keep their stand-in pack (versions never change). | 901r decides; noted in F1 and the README. |
| R8 | The existing setup tests' regexes (`setupReadyPanel`, `setupStepSection`). | The panel is a sibling section with no nested `<section>`; run the neighbour tests in B4.3. |
| R9 | `waitForStep`'s 5 s deadline under heavy load. | Rerun alone before calling a regression (known flake). |
| R10 | Sibling worktrees under `.claude/worktrees/` in the main checkout. | Run gates from the story worktree or a detached copy, never the main checkout (`verify-workspace.sh` and `format-workspace.sh` would see sibling modules). |

Siblings checked 2026-10-29: open PR #98 (901j) only; 901y is being planned (no plan file, worktree or branch yet); worktrees `86bcm901a-…`, `86bcm901b-…`, `86bcm901w-…` belong to merged stories.

## Assumptions (made openly; easy to change)

1. Quick-start state is per company, not per admin.
2. Skip and pick are offered only once setup is ready (409 before).
3. A new team made by the quick start stays if a later step fails; a retry with that name gets the 409 and the admin picks it from the list.
4. An existing pack with the starter's name is reused at its latest version, whatever an admin put in it; the done panel names exactly what was assigned.
5. The quick start sets the **team default**; a project override keeps winning for that project.
6. Required items are added to a starter (`Library.Required`), as the library README says starter packs should.
7. Pack names are "<Role> starter pack"; Platform/DevOps keeps its slash.
8. The team step can name a new team; members and projects are added on the existing pages.
9. No JSON API or OpenAPI change, like the setup wizard.
10. The "recording" is a timestamped series of real screenshots plus logs (Q4-A); no video tool here.

## Other things found (not fixed here)

- 901r's card proposes "/plan", but the library ships upstream's plan command as prompt `planning` because Claude Code has a built-in `/plan` (library README `:491-493`). The stand-in uses `prompt/planning`. (Info, for 901r.)
- 901r's card says "Repo: content", but every content card so far (9019, 901b, 901a, 901j) was built in this repo's `internal/library`; 901r will likely land here too. (Info.)
- The admin home `/admin` shows the admin's email and tenant ID, so evidence can only take element screenshots of its banner. (Info, pre-existing; already in 901w's notes.)
- `internal/onboarding/README.md` says the wizard keeps no state of its own; this story changes that sentence (Docs task).

## Estimate and completion contract

- **Estimate:** builder 3–4 h of active work (B1–B2 45 min, B3 45 min, B4 90 min, B5 30 min, docs, gates and evidence 60 min, gates themselves ~10 min each); medium confidence. Reviews, fixes, verifier and auditor follow the pipeline.
- **Done (builder):** `ready-for-review` with every AC test passing on one head, the gates green, the mutation table complete, EVIDENCE.md filled, and nothing pushed.
- **Done (story):** `ac-check.sh` prints `ALL ACCEPTED` on the head, then the `leorna` hand-over (PR text, review prompt, ClickUp evidence draft). Push, PR, ClickUp post and merge each wait for Justin's own word.
