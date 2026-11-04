# 86bcm927y — Integrations catalog tiles

## Questions for plan approval

1. How many saved configurations should a company have for one service?
   - **A — One per service (recommended).** A GitHub, ClickUp or Google Workspace tile has one saved setup; saving again edits it. No extra name field.
   - B — Several named setups. This needs instance naming, duplicate MCP-server-name rules and a revised plan before implementation.
2. Docker Desktop is currently unavailable inside Ubuntu. Which build prerequisite should we record?
   - **A — Prepare the local test environment (recommended).** Justin starts Docker Desktop and enables its Ubuntu WSL integration; the builder verifies access, creates its own disposable test services and provisions missing CI tools in an owned tool directory through the normal permission path.
   - B — Keep implementation on hold. Approve the design now, then resume when Docker access is available.

This plan uses A/A. A separate **go** is required. Answering these questions alone does not authorize implementation. Full was already selected. No user-only live AC is proposed: all four criteria and the recorded browser demo can be checked using an isolated local server and synthetic data. Docker availability is an execution prerequisite, not proof that a criterion passed.

## Playback and scope

Give a company administrator a grid of predefined integrations, a small form containing that variant's company-specific settings, and a saved MCP item that can be selected in the existing pack builder. Each actual configuration creation/change writes a tenant-scoped audit record in the same transaction.

Implement only in `leorna-control-plane`: server-rendered admin UI; configuration validation/storage; tenant/role/CSRF enforcement; library/pack selection; audit; migration; tests; recorded local demonstration; short documentation. Reuse embedded tile definitions, existing rendering, the cloud tile pattern, library filters, immutable pack snapshots and the current preview-before-save flow.

Excluded: new providers or arbitrary custom integrations, provider connection tests, OAuth/token collection, secret storage, client changes, automatic assignment/sync, live provider qualification, promotion from preview to stable, deployment, CI workflow changes, real tool-home writes, ClickUp writes, push, PR creation and local/remote main merges. The preview definitions' sign-in/provider limits remain visible. Google Workspace currently declares an OAuth client ID: use that existing field; do not silently invent the prerequisite card's ideal zero-field cloud experience. Cloud variants that declare no parameters have a direct Save integration action.

## Acceptance criteria

- AC1: Given the admin console, then predefined integrations appear as tiles with a short description and the parameters they need. Test: `TestIntegrationsAC1TilesWithPostgres`.
- AC2: Given a tile, when I enter the required values (e.g. my company CRM's URL), then the form validates them before saving. Test: `TestIntegrationsAC2ValidateWithPostgres`.
- AC3: Given a configured integration, then it becomes an item I can add to any pack (and appears in the pack builder). Test: `TestIntegrationsAC3PackBuilderWithPostgres`.
- AC4: Given a save or change, then a change-audit record is written. Test: `TestIntegrationsAC4AuditWithPostgres`.

These are the card's criteria, not replacements or newly proposed criteria. Each line has exactly one primary test. Supporting tests below cover guards and failure paths without adding product scope.

Run each primary test separately with its full name, for example `go test -race -count=1 ./internal/web -run '^TestIntegrationsAC1TilesWithPostgres$' -v`, substituting AC2Validate, AC3PackBuilder or AC4Audit for the other three. A skipped test is not a pass. The builder, verifier and auditor each retain their own command, exit status, exact head/base SHA and genuine screenshot per AC.

| AC | Required assertions and negative control | Evidence under the role's evidence folder |
|---|---|---|
| AC1 | Exactly the embedded providers; each card's description and parameter labels belong to that card/variant; preview and tool/sign-in guidance truthful; link from admin and library. Unauthenticated/member access denied; an omitted card or parameter label makes the test fail. | `AC1/tiles-desktop.png`, plus mobile/keyboard supporting captures and test log. |
| AC2 | Required, malformed, oversized, undeclared and duplicate parameters rejected before writes; valid normalized value persists; zero-param cloud save works; update/conflict behavior explicit. Removing server validation must fail even when native HTML validation is bypassed. | `AC2/invalid-field.png`, `AC2/saved-settings.png`, actual test log and row-count checks. |
| AC3 | Saved item visible/filterable in catalog and selectable in a new and an existing pack; rendered company setting present in copied MCP body; earlier pack snapshots unchanged after edit. Another tenant's UUID cannot be selected. Native review/confirmation still required. | `AC3/builder-selection.png`, `AC3/native-preview.png`, actual snapshot/isolation test log. |
| AC4 | Create and change each produce exactly one audit event with actor, tenant, stable target and useful redacted metadata; rejection/no-op/stale write writes none; forced audit failure rolls back settings. Removing audit or breaking transaction atomicity fails. | `AC4/audit.png` with synthetic identifiers cropped/redacted, or genuine terminal-run capture for rollback proof, plus test log. |

Card Verify additionally requires the UI integration journey and **recorded demo**, specified below. DoD additionally requires full project gates, happy/failure unit and DB integration tests, contract consistency and module documentation. Hosted CI is explicitly unrun until a separately authorized push/PR.

## Verified baseline and ownership

Research is against freshly fetched **`3aa979df41568c9039007f66d7f32193e66a8533`**, not the stale main checkout. Read-only GitHub `commits/main` agreed. Active gh identity was `Justin-Leorna`; no account, remote or credential configuration was changed. Fetch used the authorized literal-URL recipe:

```bash
git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main
```

Local main remains `e2254e0100a482b9201edf9b96f01936e4486d44`, 94 commits behind the verified remote main, tracked files clean, untracked `.claude/` containing sibling worktrees. The planner has not switched or advanced it. No open PRs were returned at inspection time; this is not evidence that no other local work exists.

| Prerequisite | Verified implementation |
|---|---|
| 86bcm927v — integration tile model | PR 87 merged 2026-10-24, merge `6e74ced843642439d1dac9f25673440fb0f285f5`; `internal/integration/` embedded definitions, parameter validation, rendering and tests are in pinned main. |
| 86bcm901v — library catalog browser | PR 88 merged 2026-10-24, merge `b446a89caa98b180148179dd732cbf0594df5ee9`; `internal/library/catalog.go`, Postgres catalog and admin browser are in pinned main. |

Newer main also contains tenant variants and draft native-file preview/confirmation. Those are part of the baseline to preserve, even though the story predates them. The complete card plus both prerequisite descriptions were read from `evidence/86bcm927y/intake/clickup-snapshot.json`; no comments, attachments, subtasks or extra checklists were present.

Future branch: `feat/86bcm927y-integrations-catalog-tiles`. Future dedicated worktree: `/home/justin/Leorna/86bcm927y-integrations-catalog-tiles`. Only the builder may create it after go. Re-fetch/recheck main and inspect new changes before branching. Coordinate any safe fast-forward of the shared clean main per Leorna rules; never switch/reset/stash another session's checkout. If shared-main ownership prevents advancing it, report that exact condition and use the approved isolated branch base procedure rather than forcing it. Record actual branch base; revalidate this plan if the owning interfaces changed.

**Overlap check required before build:** another Codex session has an active `custom_domain_planner` for 86bccndx6. Its final affected paths were not yet available. Likely shared composition/routes/docs areas are `cmd/control-plane/main.go`, `internal/web/handler.go`, migration numbering and `delivery/stories.json`. Compare its completed plan and actual branch diff before editing these files; use separate worktrees/databases/evidence and additive hunks. Planning does not reserve files. Existing local worktrees for 901a, 901b, 901j, 901r, 901w, 901y, 901z, 902a and 902w were observed; do not reuse their processes, databases, caches or resources. Shared library/pack files are also likely integration conflict points if any of those branches resumes. Do not merge sibling branches into this story.

## Source map and smallest complete path

All line references below refer to pinned main and may move later.

| Existing owner | Evidence and consequence |
|---|---|
| `internal/integration/catalog.go:21`, `tile.go`, `tiles/*.json` | Embedded GitHub, ClickUp, Google Workspace definitions already own provider/variant/parameter/sign-in/tool metadata. No duplicate definition array in HTML or database. |
| `internal/integration/render.go:26`, `:81`, `:119` | `Tile.Render` validates declared values and produces an MCP seed item; `Variant.resolve` canonicalizes values, with derived hostname values. Reuse these rules; persist only declared keys, never derived helper keys. No outbound connection occurs. |
| `internal/web/client_integrations.go` | Existing read-only client definition endpoint. Leave its wire shape/behavior intact; it is not a configuration store. |
| `internal/web/cloud.go:90`, `library.go:114` | Existing responsive tile/grid and library design patterns. Use their spacing/type/button conventions without a framework or shared visual redesign. |
| `internal/web/handler.go:295`, `cloud_plan.go:99` | Session/admin middleware and `adminFormLimit` already own role, content-type, body bounds and CSRF rules. Reuse them. |
| `internal/web/library_variants.go:56` | `catalogEntries` currently returns early when variants are nil. Add integrations independently of optional variant wiring; test integrations with variants absent. |
| `internal/library/catalog.go:20` | `Entry` supports catalog metadata; add a distinct integration marker, not an invented library variant. |
| `internal/store/postgres/library_catalog.go`, `migrations/000027_library_variants.up.sql` | Shared library has no tenant ownership; variants are tied to shipped skill/agent/prompt rows. Neither is an appropriate integration configuration table. |
| `internal/store/postgres/teams.go:31`, `audit.go:13` | `beginOrg` binds tenant context to actor and rechecks persisted membership/role; `appendAudit` writes through the same transaction. Reuse both. |
| `internal/store/postgres/pack_builder.go:299` | `loadCatalogItems` resolves shared library and tenant variants for both drafts and saved packs. Add configurations here so all existing pack APIs and browser paths get the same tenant-scoped resolver. |
| `internal/web/pack_builder.go:314`, `:365`, `pack_draft_review.go:45` | Browser saves now require a real target and preview digest in production. Do not disable assignments to make UI tests/demo succeed. |
| `internal/web/pack_builder.go:479` | Existing checked items do not automatically become new versions when catalog contents change. Preserve immutable snapshots; explicitly remove/re-add to select a newer integration revision. |
| `cmd/control-plane/main.go:199`–`:215` | Composition for library, variants and pack builder; bind the integration service alongside these. |
| `contracts/control-plane.openapi.yaml:1883`, `:1907` | Existing UUID arrays describe shared items and company variants. Extend descriptions to include saved company integrations; retain their names, formats and schemas. |
| `internal/web/packs_test.go:26`, `pack_builder_draft_postgres_test.go:15` | TLS server + real Postgres fixtures already provide admin/member/other tenant and `confirmPackForm`; reuse actual native preview confirmation. |

This is a new feature, not a diagnosed regression. The missing configuration persistence/UI is evidenced by the existing read-only definitions and catalog resolution; no unrelated bug fix is included.

## Design decisions and interfaces

### Configuration and validation

Create `internal/integration/configuration.go` and `service.go` in the existing package. The following are **new, planned interfaces**, not claims about current code:

```go
// Fragment for internal/integration/configuration.go; standard context/time
// and the existing library, library/gate, pack and store packages are imported.
type Configuration struct {
    ID, TileID, TileVersion, VariantID string
    Revision int64
    Values map[string]string
    Item library.Item
    CreatedAt, UpdatedAt time.Time
}
type SaveSpec struct {
    TileID, TileVersion, VariantID string
    ExpectedRevision int64 // 0 means create, otherwise compare under row lock
    Values map[string]string
    Item library.Item // fully validated, rendered snapshot; never browser-supplied
}
type Store interface {
    ListIntegrationConfigurations(context.Context, store.Principal) ([]Configuration, error)
    GetIntegrationConfiguration(context.Context, store.Principal, string) (Configuration, error) // tile ID, scoped to actor
    SaveIntegrationConfiguration(context.Context, store.Principal, SaveSpec) (Configuration, error)
}
type Configure struct {
    TileID, VariantID string
    ExpectedRevision int64
    Values map[string]string
}
// NewService(repository Store, tiles []Tile, scanner gate.Scanner) *Service
// Tiles() []Tile
// Configurations(ctx context.Context, actor store.Principal) ([]Configuration, error)
// Configuration(ctx context.Context, actor store.Principal, tileID string) (Configuration, error)
// Save(ctx context.Context, actor store.Principal, in Configure) (Configuration, error)
```

The service selects an embedded tile/variant, rejects negative/overflow revisions, canonicalizes only that variant's parameters and calls `Tile.Render`. Make a new map containing declared keys after `resolve`, omitting internal `.hostname` substitutions. Never accept template body, item kind, tenant, actor, name, revision output or tool support from the form. Persist the definition version and rendered body so upgrading an embedded definition does not rewrite existing settings or packs.

Choose deterministic item name `integration-<tile-id>` and version `1.0.<revision-1>` for the company configuration; preserve the provider tile version separately. This distinguishes the configured item from existing `github-mcp` content and gives a stable name across edits. Respect pack/item length limits and signed bigint overflow. Build `library.Item` with kind `mcp_template`, category/tag `integrations`, appropriate description/example, supported tools from the selected variant, no supporting files and the rendered JSON body. Never claim Codex support for a variant that does not declare it. Preserve provider preview status as distinct metadata.

Validate the derived item with existing item/render rules and `gate.CheckTenantItem` using the production gitleaks scanner. Secret detection, scanner failure and render failure fail closed before persistence. Never echo rejected unknown/raw secret-looking values in HTML, logs or audit. The UI collects configuration only; do not label a saved tile Connected. Sign-in remains on the engineer's device. There are no outbound network calls, SSRF probes, shell execution of templates or connection tests.

Conflict behavior: create expects revision 0; an existing tenant/tile returns a typed conflict. Update expects the current positive revision; stale revision returns 409. An unchanged canonical save returns a no-change response with no write/audit (400 plus clear explanation is consistent with existing editor behavior). Updates retain the configuration UUID. Tile/variant changes are allowed only through the same validation and a new revision. Never silently overwrite another admin's edits.

### Durable storage and audit

Create `internal/store/postgres/integrations.go`. Use one new migration pair `000028_integration_configurations.up.sql` / `.down.sql`, **renumber only if a newly merged migration has claimed 28 before branching**. Append-only migration history; no edits to previous migrations.

Schema contract: `integration_configurations(id uuid PK, tenant_id uuid FK tenants ON DELETE RESTRICT, tile_id text, tile_version text, variant_id text, revision bigint CHECK > 0, values jsonb object, item_name text, item_version text, description text, body text, tools jsonb array, created_at timestamptz, updated_at timestamptz)`. Unique `(tenant_id,tile_id)` and `(tenant_id,item_name)`; bounds aligned with existing tile/item validators (body at most 65536 bytes, description at most 2000 characters, name at most 200, version at most 50). JSON values must stay a bounded string map accepted by the service; reject invalid direct store specs too. Metadata needed for the catalog must be stored or deterministically derived from the saved snapshot, not a newly upgraded definition. Down migration drops only this table.

All store methods call `beginOrg` and tenant-filter queries using actor context, not an input tenant ID. Require admin for configuration operations and recheck persisted role. Read/edit a tile only within the actor's tenant. Unknown tile/configuration becomes 404 at the HTTP boundary; direct pack selection of missing/foreign UUID retains existing `org.ErrInvalid` behavior rather than inventing a new enumeration oracle. Lock updates, compare expected revision within the transaction and make concurrent create uniqueness violations safe typed conflicts. Return field-safe errors.

Call `appendAudit` in that same transaction before commit: `integration.configure` on creation, `integration.update` on change; target is stable configuration UUID. Before/after contain tile ID, definition version, variant ID, revision and sorted changed parameter **names**, not values, body, client identifiers, token material or full URLs. Creation before is null. This is a useful diff without duplicating company connection details in audit. A database failure writing audit rolls back settings. Invalid, denied, unchanged and conflicting submissions write neither settings nor audit.

### UI, catalog and pack behavior

Add `internal/web/integrations.go` and `Handler.SetIntegrations(*integration.Service)`; wire production in `cmd/control-plane/main.go` with `integration.Embedded()` and `gate.NewGitleaks("gitleaks")`. Use the existing startup error path if embedded definitions fail. Add navigation from `/admin` and `/admin/library`.

Routes: GET `/admin/integrations`; GET `/admin/integrations/{tileID}`; POST `/admin/integrations/{tileID}`. Wrap GET/POST in the same session/admin policy as library/cloud routes. Both GET pages use the existing nonce/CSP and no-store HTML writer. Unknown provider/variant is 404/400, missing configured service 503. No unguarded fallback or invented auth.

Index renders three embedded cards, descriptive text, declared parameter labels grouped by variant, preview badge, supported tools/sign-in guidance and Configure/Edit state. Detail uses server-rendered variant selection (`?variant=<id>` with a GET form); no new JavaScript is needed. Render only selected variant's inputs with label/help/required/url/text constraints, and hidden `csrfToken`, `variant`, `expected_revision`. Parameter names use `param.<declared-name>`. Reject duplicate scalar/control values and undeclared `param.*`; use `adminFormLimit` for form-only body size/CSRF. Server validation remains authoritative. On failure, associate a useful message with the field or form and show no success state. On save, 303 back to that tile with a clear Saved indication and link to add it through the library. Edit prepopulates existing values, preview/tool limits remain visible, and the page explains that existing pack versions keep their saved settings.

Add `Integration *IntegrationOf` on `library.Entry` with string metadata (`TileID`, `TileVersion`, `VariantID`, preview stage) and a `NameClash` boolean if needed by current collision handling. Keep it distinct from `VariantOf` and avoid an integration/library import cycle. Append configurations in `catalogEntries` independently of whether variants are enabled. Render a Configured integration badge and correct edit link; retain shared-item detail and variant links unchanged. Use current catalog filtering/facets/tool matching. Configured rows are tenant-owned; they never appear in the public shipped library or another tenant's list.

Extend the common `loadCatalogItems` query to include the actor's `integration_configurations`, returning the same item snapshot shape as existing sources. Draft, create and new-version paths must all use this resolver. Preserve collision detection by item kind/name, bounded selection counts, transactional snapshot copies and error semantics. If a later shipped item collides with a deterministic integration name, disable the ambiguous pick with the existing collision pattern and fail the store selection rather than picking nondeterministically. Do not overwrite existing pack versions. Updating an integration changes future selections; replacing a previously selected snapshot uses the existing remove/re-add/new-version workflow. No automatic pack assignment or Sync.

No new JSON API operation is needed. The existing pack UUID fields now accept one more tenant-scoped catalog source. Update the two OpenAPI field descriptions and regenerate `packages/contracts/controlplane.gen.go`; run contract checks and old-client/request round trips. Browser POST form bodies are not silently added to the public API. If implementation requires a new JSON endpoint or client change, stop for scope review rather than inventing one.

## Ordered implementation tasks — after go only

All tasks are test-first. Start the named test before its production change, observe an assertion failure once it compiles, implement only that behavior, rerun the same test, then its affected regression family. A missing symbol/fixture/DB is setup failure, not behavioral RED. Use 2–5 minute editing increments within these stages. Preserve all existing tests. Scoped local commits use explicit files and configured authorship; `git-commit-rules` must be loaded first. Never commit generated AGENTS, CLAUDE, evidence, secrets or another story's edits.

1. **Admit the baseline and collect before evidence.** Recheck current remote main, clean/owned worktree, sibling overlap and migration slot. Verify Docker and tool versions, create role-owned services/database, export test variables, and run the existing focused integration/library/pack tests on base. Record baseline failures without fixing unrelated code. Before any UI edit, capture base `/admin/library` and the absence of the integrations route, preserving SHA and browser viewport. Prepare the story branch/worktree only under the approved base rule. No production edit yet.
2. **AC1, first vertical slice.** In new `internal/web/integrations_test.go`, add the AC1 test from Appendix A and its fixture adapter; first introduce the small setter/service wiring needed to compile, with no integration routes, then observe route 404. Add the tile index/detail read path in `internal/web/integrations.go`, field/setter/routes/navigation in `handler.go`, composition in `main.go`, and library navigation in `library.go`. Green AC1 and existing cloud/library tests. Capture the actual responsive cards. Do not add save behavior before its RED test.
3. **AC2, validate/render.** New `internal/integration/configuration_test.go` and `service_test.go`: use table cases covering missing URL; HTTP, credentials/path/query/fragment URLs; wrong GitHub domain; oversized/control values; unknown field; valid normalization; zero-param cloud; invalid/valid Google client ID; escaped text; negative and overflow revision. Test canonical values and rendered output separately, not exact implementation calls. Run `go test -race -count=1 ./internal/integration -run 'TestConfiguration|TestService' -v`. Add the configuration/service types and pure preparation logic. The existing Render golden/security tests must stay green. Inject scanner failures in service tests and verify zero store calls, then production uses real gitleaks.
4. **AC2, persist a successful save.** New `internal/store/postgres/integrations_test.go`: `TestIntegrationConfigurationSaveWithPostgres` starts with real migration/table and tests round-trip, two tenants, member/demoted admin, mismatched context, create uniqueness race, stale update, no-op and canonical revision/body. Add migration pair and `integrations.go`; update migration up/down/reset table lists in `internal/store/postgres/store_test.go`. Start with the failing save test, then implement the smallest transactional method. Run `go test -race -count=1 ./internal/store/postgres -run 'TestIntegrationConfiguration|TestMigrationRoundTrip' -v`. Validate up/down/up in the isolated DB. No destructive migration against any shared/deployed database.
5. **AC2, HTTP save/edit.** Add AC2 from Appendix A before POST handling, then its full rejection matrix. Add POST parsing, typed safe errors and field feedback in `internal/web/integrations.go`. Include GET/POST anonymous/member, CSRF, content type, oversized request, duplicate controls/parameters, forged tile/variant, no raw secret echo, and unchanged/stale revision assertions. Green AC2; repeat integration service/store and existing admin CSRF tests. Browser native `required`/URL validation is additional coverage; direct HTTP rejection must work independently.
6. **AC3, tenant catalog source.** Add `TestConfiguredIntegrationCatalogWithPostgres` in `internal/web/integrations_test.go` and `TestIntegrationCatalogResolutionWithPostgres` in `internal/store/postgres/integrations_test.go`; tests must enable integrations with variants absent, test filters and another tenant's IDs, and provoke a shared-name collision. Edit `internal/library/catalog.go`, `internal/web/library_variants.go`, `internal/web/library.go` and Postgres common resolver only after RED. Do not alter shared-library rows or add an integration-specific pack API.
7. **AC3, new/existing pack and immutable copies.** Add AC3 Appendix A and expand it to add the integration to an existing pack using the current browser form/confirmation helper; assert copied native content, edit saved settings and prove the earlier pack version body stays byte-identical, then remove/re-add to a new version and prove new content. Production-like fixture wires Teams, Projects, PackAssignments and PackVersions. Missing target/unconfirmed/changed preview digest must not save; editing an integration between preview and confirm must invalidate that preview. Modify only the common catalog resolver/metadata formatting needed for these failures. Run primary AC3 plus `go test -race -count=1 ./internal/web ./internal/store/postgres -run 'Test.*(Builder|Pack|Integration)' -v`. Do not relax the preview guard.
8. **AC4, transaction and redacted audit.** Add AC4 Appendix A and `TestIntegrationAuditRollbackWithPostgres` before audit logic. Verify exact create/update metadata and actor/tenant/target, zero records for every rejected path and isolation in ListAudit. Cause an actual test-local audit insert failure (temporary constraint/trigger in the fixture schema) after a valid save is prepared; assert both configuration and audit unchanged. Add the two action records in `integrations.go` using `appendAudit` inside the transaction. Do not mock away rollback. Green AC4 and existing audit tests.
9. **Real UI integration and recorded demo.** Add `internal/web/integrations_browser_test.go` containing `TestIntegrationsBrowserJourneyWithPostgres`, using the existing chromedp dependency, TLS/Postgres fixture and a task-owned Chrome profile. Explicitly enable this test in the evidence run; it may be env-gated in normal developer runs, but a skipped evidence run fails the task. Exercise keyboard navigation, selected-variant field switching, validation, zero-field save, edit, catalog filters, new/existing pack selection, actual preview/confirm and audit display at desktop and narrow viewport. Assert no overflow and no unexpected console/network errors. Capture per-AC images during the passing journey and the continuous GIF below. No screenshot of a log substitutes for visible UI.
10. **Qualification and guard falsification.** Run the exact complete gates below once on the final candidate; fix only introduced/in-scope failures through the required debugging/TDD process. Apply each mutation in an owned disposable copy: remove POST validation; drop tenant predicate from integration lookup; bypass admin/CSRF; omit audit call; move audit outside transaction; skip preview digest checking for integration selection. Each mutant must compile, reach the relevant assertion and fail; a build error, missing DB, scanner error or earlyoom kill is not a caught mutation. Restore/recreate only owned mutation copies; run under the 4 GiB cap. Produce bounded failure output, not entire page/tree diffs.
11. **Docs & records.** Update `internal/integration/README.md` (configure/edit, preview limits, no credentials, immutable pack behavior, local demonstration), `internal/web/README.md` (admin routes/guards), `internal/pack/README.md` (configured item source and snapshot behavior), `internal/audit/README.md` (two event names/redaction), and the two OpenAPI descriptions plus regenerated contracts. Add a concise Configured integration term to `GLOSSARY.md` only if the existing terminology lacks it. Update `delivery/stories.json` with the actual story link/acceptance/verification record using the existing schema; PR list stays empty until a real authorized PR exists. Do not invent a PR number or claim hosted CI. The orchestrator freezes this plan as `<evidence>/plan-approved.md` after go. Save build/gate/evidence manifests and eventual handover under the evidence root, not as project source. Finisher produces `<evidence>/handover.md`, `pr-description.md`, `review-prompt.md`, `clickup-comment-draft.md`, `team-message-draft.md` and `follow-ups.md`, with real branch/head/diff/stat/results, screenshot/demo paths and outstanding limitations. No evidence posting or team messaging. A team message states PR not created when no real PR exists. No project CLAUDE file is fabricated.

## Executable acceptance-test seed

Appendix A below is complete proposed test code, using existing fixture helpers plus the explicitly proposed setter/service interface. It is a starting behavioral spine, not a waiver of the required subcases in tasks 3–10. Add the relevant subtests before each corresponding production change. The constructor and handler setter must first compile as minimal scaffolding; then capture route/validation/catalog/audit assertion RED. No tests or code from this plan have been executed or installed by the planner.

```go
// New file: internal/web/integrations_test.go
package web

import (
    "context"
    "encoding/json"
    "html"
    "net/http"
    "net/url"
    "strings"
    "testing"

    "github.com/LeornaAI/leorna-control-plane/internal/integration"
    "github.com/LeornaAI/leorna-control-plane/internal/library/gate"
    "github.com/LeornaAI/leorna-control-plane/internal/pack"
    "github.com/LeornaAI/leorna-control-plane/internal/store"
    "github.com/LeornaAI/leorna-control-plane/internal/store/postgres"
)

func newIntegrationFixture(t *testing.T) packFixture {
    t.Helper()
    tiles, err := integration.Embedded()
    if err != nil { t.Fatal(err) }
    return newPackFixture(t, func(h *Handler, db *postgres.Store) {
        h.SetLibrary(db)
        h.SetPackBuilder(pack.NewBuilderService(db))
        h.SetPackVersions(pack.NewVersionService(db))
        h.SetTeams(db)
        h.SetProjects(db)
        h.SetPackAssignments(db)
        h.SetIntegrations(integration.NewService(db, tiles, gate.NewGitleaks("gitleaks")))
    })
}

func saveIntegrationForm(t *testing.T, f packFixture, client *http.Client, variant, revision, server string, want int) {
    t.Helper()
    form := url.Values{"csrfToken": {f.csrf}, "variant": {variant}, "expected_revision": {revision}}
    if server != "" { form.Set("param.server", server) }
    response := packForm(t, client, f.server.URL+"/admin/integrations/github", form)
    readStatus(t, response, want)
}

func integrationState(t *testing.T, f packFixture) (id string, revision int64, body string) {
    t.Helper()
    err := f.pool.QueryRow(context.Background(), `SELECT id::text,revision,body FROM integration_configurations WHERE tenant_id=$1 AND tile_id='github'`, f.admin.TenantID).Scan(&id, &revision, &body)
    if err != nil { t.Fatal(err) }
    return
}

func TestIntegrationsAC1TilesWithPostgres(t *testing.T) {
    f := newIntegrationFixture(t)
    client := f.login(t, f.admin, strings.Repeat("a", 43))
    page := f.get(t, client, "/admin/integrations", http.StatusOK)
    tiles, err := integration.Embedded()
    if err != nil { t.Fatal(err) }
    for _, tile := range tiles {
        start := strings.Index(page, `data-integration="`+tile.ID+`"`)
        if start < 0 { t.Fatalf("missing integration card %s", tile.ID) }
        end := strings.Index(page[start:], "</article>")
        if end < 0 { t.Fatalf("unclosed integration card %s", tile.ID) }
        card := page[start:start+end]
        for _, text := range []string{tile.Name, tile.Description} {
            if !strings.Contains(card, html.EscapeString(text)) { t.Fatalf("card %s omits its text", tile.ID) }
        }
        for _, variant := range tile.Variants {
            for _, param := range variant.Params {
                if !strings.Contains(card, html.EscapeString(param.Label)) { t.Fatalf("card %s omits parameter %s", tile.ID, param.Name) }
            }
        }
    }
    if strings.Count(page, `data-integration="`) != len(tiles) { t.Fatal("wrong provider card count") }
    member := f.login(t, f.member, strings.Repeat("b", 43))
    f.get(t, member, "/admin/integrations", http.StatusForbidden)
}

func TestIntegrationsAC2ValidateWithPostgres(t *testing.T) {
    f := newIntegrationFixture(t)
    client := f.login(t, f.admin, strings.Repeat("a", 43))
    f.get(t, client, "/admin/integrations/github?variant=enterprise-server", http.StatusOK)
    saveIntegrationForm(t, f, client, "enterprise-server", "0", "http://git.example.invalid", http.StatusBadRequest)
    var count int
    if err := f.pool.QueryRow(context.Background(), `SELECT count(*) FROM integration_configurations`).Scan(&count); err != nil { t.Fatal(err) }
    if count != 0 { t.Fatal("invalid values were persisted") }
    saveIntegrationForm(t, f, client, "enterprise-server", "0", "https://git.example.invalid/", http.StatusSeeOther)
    _, revision, body := integrationState(t, f)
    if revision != 1 || !strings.Contains(body, "https://git.example.invalid") { t.Fatal("valid settings were not rendered and stored") }
    saveIntegrationForm(t, f, client, "enterprise-server", "0", "https://second.example.invalid", http.StatusConflict)
    _, after, unchanged := integrationState(t, f)
    if after != revision || unchanged != body { t.Fatal("stale form overwrote saved settings") }
}

func TestIntegrationsAC3PackBuilderWithPostgres(t *testing.T) {
    f := newIntegrationFixture(t)
    client := f.login(t, f.admin, strings.Repeat("a", 43))
    saveIntegrationForm(t, f, client, "enterprise-server", "0", "https://git.example.invalid", http.StatusSeeOther)
    id, _, body := integrationState(t, f)
    page := f.get(t, client, "/admin/library?kind=mcp_template", http.StatusOK)
    if !strings.Contains(page, `name="item" value="`+id+`"`) { t.Fatal("configured integration not selectable") }
    scoped := store.WithTenant(context.Background(), f.admin.TenantID)
    team, err := f.repository.CreateTeam(scoped, f.admin, "Integration demo")
    if err != nil { t.Fatal(err) }
    form := url.Values{"csrfToken": {f.csrf}, "name": {"Integration pack"}, "item": {id}}
    response := confirmPackForm(t, client, f.server.URL+"/admin/library/packs", form, "team:"+team.ID)
    readStatus(t, response, http.StatusSeeOther)
    packs, err := f.repository.ListPacks(scoped, f.admin)
    if err != nil || len(packs) != 1 { t.Fatalf("pack count=%d err=%v", len(packs), err) }
    saved, err := f.repository.GetPack(scoped, f.admin, packs[0].ID)
    if err != nil { t.Fatal(err) }
    if len(saved.Version.Items) != 1 || saved.Version.Items[0].Body != body { t.Fatal("pack did not copy configured template") }
    saveIntegrationForm(t, f, client, "enterprise-server", "1", "https://second.example.invalid", http.StatusSeeOther)
    old, err := f.repository.GetPack(scoped, f.admin, packs[0].ID)
    if err != nil { t.Fatal(err) }
    if old.Version.Items[0].Body != body { t.Fatal("editing settings changed an existing pack") }
    foreign := store.WithTenant(context.Background(), f.other.TenantID)
    _, err = f.repository.CreatePack(foreign, f.other, pack.NewPack{Name: "Foreign", Version: "v1", LibraryItemIDs: []string{id}})
    if err == nil { t.Fatal("other tenant selected private integration") }
}

func TestIntegrationsAC4AuditWithPostgres(t *testing.T) {
    f := newIntegrationFixture(t)
    client := f.login(t, f.admin, strings.Repeat("a", 43))
    saveIntegrationForm(t, f, client, "enterprise-server", "0", "https://git.example.invalid", http.StatusSeeOther)
    id, _, _ := integrationState(t, f)
    saveIntegrationForm(t, f, client, "enterprise-server", "1", "https://second.example.invalid", http.StatusSeeOther)
    saveIntegrationForm(t, f, client, "enterprise-server", "1", "https://third.example.invalid", http.StatusConflict)
    rows, err := f.pool.Query(context.Background(), `SELECT actor::text,action,target,before_value,after_value FROM audit_records WHERE tenant_id=$1 AND action LIKE 'integration.%' ORDER BY occurred_at,id`, f.admin.TenantID)
    if err != nil { t.Fatal(err) }
    defer rows.Close()
    count := 0
    actions := map[string]int{}
    for rows.Next() {
        var actor, action, target string
        var before, after []byte
        if err := rows.Scan(&actor, &action, &target, &before, &after); err != nil { t.Fatal(err) }
        if actor != string(f.admin.UserID) || target != id { t.Fatal("audit identity or target incorrect") }
        var metadata map[string]any
        if err := json.Unmarshal(after, &metadata); err != nil { t.Fatal(err) }
        if metadata["tileId"] != "github" || metadata["variantId"] != "enterprise-server" { t.Fatal("audit omits integration identity") }
        if strings.Contains(string(before)+string(after), ".example.invalid") { t.Fatal("audit leaked connection values") }
        actions[action]++
        count++
    }
    if err := rows.Err(); err != nil { t.Fatal(err) }
    if count != 2 || actions["integration.configure"] != 1 || actions["integration.update"] != 1 { t.Fatal("successful mutations were not audited exactly once") }
}
```

For independent **base** replay, keep every AC assertion unchanged. Copy only the new tests into a disposable checkout of the actual branch base; replace `newIntegrationFixture` with the same existing library/pack/teams/projects/assignments setup minus `SetIntegrations`, since base has no such service/setter. Remove the now-unused `gate` import. No new production implementation or migration may be copied onto base. This narrow compilation adapter is recorded/diffed in each report. The first `/admin/integrations` or save request must fail at runtime with the missing feature (404), not at compilation or because no database exists. Head runs use production integration wiring. Supporting tests whose new public types cannot compile on base may use an equivalent HTTP probe; document that separately, never count a compiler error as AC rejection.

## Host prerequisites and complete validation

Observed on this host: Go is absent from default PATH but `/home/justin/.local/leorna-toolchain/go/bin/go` reports **go1.27.3 linux/amd64**; cgo is 1 and gcc is available. `make` is available. `/home/justin/.local/leorna-toolchain/bin/golangci-lint` reports **2.14.0**; govulncheck reports **1.7.0**. Current CI pins those versions plus gitleaks **8.30.1**, and the installed gitleaks reports 8.30.1. `helm`, `tofu` and `trivy` are absent from default PATH; preflight must locate verified existing installations or provision the CI-compatible tools in an owned directory. CI installs Helm 3.18.4 and OpenTofu 1.12.6; its Trivy action is pinned at `ed142fd0673e97e23eac54620cfb913e5ce36c25`. Resolve that action's exact scanner version before obtaining a local equivalent. Chrome and cached libraries exist at the paths below; browser launch is not yet tested. ffmpeg is unavailable, so recording uses Go's standard GIF encoder. No dependency or host setting was installed/changed during planning.

Docker currently resolves to the Windows shim and fails with “docker could not be found in this WSL2 distro”; Ubuntu integration must be restored. Do not claim Docker, Postgres, browser or runtime gates passed. Do not reuse sibling Postgres binaries/containers. Each role uses its own bounded containers and `_test` database; record actual ownership and connection details privately and redact passwords from evidence. The inspected CI pins Postgres `mirror.gcr.io/library/postgres:18.6-alpine3.23@sha256:697c180dbf244d3ce4a8f4cbc0156cde840af055c1bf8b76aebe422a4822086f` and ClickHouse `mirror.gcr.io/clickhouse/clickhouse-server:25.8@sha256:0152dd511befe6a2c2ef53e930726179669b08116da78500b37c51c96ff5ee77`; bind loopback only. No mutable image tag substitution, shared volume deletion or shared database reset. Provisioning exact loopback port/container names is a bounded preflight task after Docker is available; existing services must not be commandeered.

Within the builder's owned worktree, the role sets `LEORNA_TEST_DATABASE_URL` to its own database ending `_test`, and `LEORNA_TEST_CLICKHOUSE_URL` to its owned ClickHouse loopback endpoint; both variable names were verified in `.github/workflows/ci.yml`. Use the existing fixture's ClickHouse database/user contract from that workflow and test sources. Do not log credentials/full database DSNs. Keep Go build caches and browser profiles in owned disk-backed folders under `/home/justin/.hermes`; temporary source validation scratch may use an owned small `mktemp -d` directory.

```bash
export PATH="/home/justin/.local/leorna-toolchain/go/bin:/home/justin/.local/leorna-toolchain/bin:$PATH"
export CGO_ENABLED=1
export GOTOOLCHAIN=local
export LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks
test -n "$LEORNA_TEST_DATABASE_URL"
go version
go env CGO_ENABLED CC
golangci-lint --version
govulncheck -version
gitleaks version
docker info
go test -race -count=1 ./internal/integration -v
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC1TilesWithPostgres$' -v
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC2ValidateWithPostgres$' -v
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC3PackBuilderWithPostgres$' -v
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC4AuditWithPostgres$' -v
go test -json -race -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web
make generate
make check GOLANGCI_LINT=/home/justin/.local/leorna-toolchain/bin/golangci-lint GOVULNCHECK=/home/justin/.local/leorna-toolchain/bin/govulncheck
bash ./scripts/test-module-add.sh
python3 -m unittest discover -s scripts -p 'test_story_shippable.py'
git diff --check
```

Capture each command separately with its actual exit status; use a runner with pipefail if teeing output. The snippets show commands, not permission to proceed past a failing prerequisite. `make check` includes workspace, generated contracts, format, vet, all-module race tests, golangci-lint, vulnerability audit, gitleaks, library quality and build. Do not replace it with hand-picked equivalents or omit tools. The module-add script may touch generated workspace fixtures: run in the owned candidate copy and retain/restore only its own expected artifacts. No `go mod tidy` or lockfile churn unless proven necessary.

Parse the `go test -json` output per test and package. The four AC nodes and their subtests must have real `run`/`pass` events, no skip. Reject every database-required skip whose output says `LEORNA_TEST_DATABASE_URL is not set`, including tests not ending WithPostgres. Assert the DB setup truly reached migrations and SQL. Inventory all other skips with exact reason: opt-in evidence directory, unavailable explicitly optional ClickHouse or unset `SCW_LIVE` are separate named limits, not implicit passes. Prefer enabling owned ClickHouse to cover the complete local suite. The browser journey gets its own explicit non-skipped run.

Also run the existing container/Helm/OpenTofu checks prescribed by repo CI, without editing the workflow:

```bash
docker build --no-cache --file Containerfile --tag leorna-control-plane:86bcm927y-local .
docker run --rm --entrypoint /usr/local/bin/gitleaks leorna-control-plane:86bcm927y-local version
make helm-lint
make helm-template
go test -race -count=1 ./internal/cloud/scaleway -run '^TestGoldenHCLPassesTofuValidate$' -v
trivy image --exit-code 1 --ignore-unfixed --scanners vuln --vuln-type os,library --severity CRITICAL,HIGH leorna-control-plane:86bcm927y-local
```

Packaged gitleaks must print exactly 8.30.1. The OpenTofu test is included in `make test`; its explicit run is proof it did not skip because tofu was absent. The real gitleaks test variable above prevents existing secret-scan integration tests from silently skipping. Required tool absence is a preflight blocker, not a skipped green gate. Infrastructure deployment/apply, hosted image publish and live Scaleway checks remain unauthorized. Record local outcomes separately from hosted CI, which can only be reported after an authorized PR actually triggers it.

Mutation runs always use:

```bash
systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 go test -race -count=1 ./internal/web -run '^TestIntegrationsAC2ValidateWithPostgres$' -v
```

Use the relevant test name/package for each mutant. If this cap facility fails, stop mutation execution and report the missing resource guard. A SIGTERM, 137, 143 or Killed result requires `journalctl -u earlyoom --since "-30 min" -o short-iso` inspection before classification. Report kills with command/time/memory and rerun under the cap. Never print huge HTML/JSON trees in assertions.

## Browser and recorded-demo procedure

Use `TestIntegrationsBrowserJourneyWithPostgres` with **new test-only** opt-ins `LEORNA_INTEGRATIONS_EVIDENCE_DIR` and `LEORNA_INTEGRATIONS_CHROME_BIN`; these are planned fixture controls, not existing product settings. Reuse `newIntegrationFixture`, whose auth is the existing test session fixture, never a production bypass. Transfer its synthetic session cookies into the isolated Chrome context; use the fixture's TLS URL, allowing its self-signed certificate only in that browser. No real login, provider credentials or tenant identifier is necessary.

```bash
env -u DISPLAY -u WAYLAND_DISPLAY \
  LD_LIBRARY_PATH=/home/justin/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu \
  LEORNA_INTEGRATIONS_CHROME_BIN=/home/justin/.cache/chrome-for-testing/chrome-linux64/chrome \
  LEORNA_INTEGRATIONS_EVIDENCE_DIR=/home/justin/.hermes/plans/leorna/evidence/86bcm927y/builder \
  go test -count=1 ./internal/web -run '^TestIntegrationsBrowserJourneyWithPostgres$' -v
```

The runner uses headless Chrome, disabled GPU/software rasterizer, an owned profile and bounded lifetime, using existing chromedp/CDP packages. Capture desktop 1280×900 and narrow 390×844. The local journey is: view three tiles → choose GitHub enterprise variant → submit invalid HTTP value through the form/direct-HTTP companion check → save a synthetic HTTPS origin → inspect catalog → select it into a new pack → view actual native preview → confirm → add it to an existing pack via the current UI → edit configuration → inspect audit/history and unchanged earlier pack. Also save a zero-parameter cloud variant and exercise Google client-ID validation in test coverage. Never send requests to the synthetic provider URL.

During this **single actual browser run**, record browser frames at approximately 4 fps using CDP screenshot/screencast capture, including validation/error/success transitions and real input/click steps. Quantize/encode incrementally or with bounded frames using Go `image/gif`, maximum 120 seconds and a role-owned memory cap; keep the original action/timing log. Save `<role>/demo/integrations-<short-head>.gif` and `<role>/demo/manifest.json` (source SHA, viewport, test command, timestamps, duration, frame count and hash). This is a recording of the running app, not a slideshow reconstructed from final screenshots. Inspect decoded frame count/duration and view the animation before claiming the card's recorded-demo requirement complete. If browser capture/encoding cannot be made reliable within existing dependencies, report an evidence blocker; do not silently substitute PNGs.

Per-AC screenshots come from that run at the described capture points. Crop/redact synthetic UUIDs, session data and address chrome as needed; keep original private raw files with the role's evidence and document redactions. Every visible capture must identify the exact head and corresponding action in the manifest. For the audit rollback result, capture actual terminal output or a clearly labelled rendering of an actual preserved run log, never a fabricated green result.

Verifier and blind auditor use separate fixtures and evidence folders. They may use the same committed browser test but must execute and inspect it themselves. They each run all AC checks on head and baseline; the baseline should fail the new route/feature assertions. Preserve existing regression results rather than forcing a correct old behavior red.

## Full review, verification and handover

The orchestrator alone dispatches fresh configured roles (currently Astra xhigh, fresh context). Every role loads `leorna`, then `engineering-best-practices`, and applicable `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. Builder adds `test-driven-development` and `mutation-testing-discipline`; reviewers add `requesting-code-review`, `code-review-practice`, `review-fix-cadence`; fixers add `receiving-code-review`, TDD and systematic-debugging for unexpected failures; verifier/auditor add `adversarial-verification-loop` and the AC-verification reference. Commit-capable roles load `git-commit-rules`; GitHub readers load `github`. No child spawns agents.

Applicable mandatory Agent Defect Loops: **backend-data-migrations** and **api-contract-drift-guard**, plus correctness/security independent verification. Implementer → independent finder/reviewer → fixer when necessary → fresh review → independent verifier, repeated until clean. Full pipeline round 1 and 2 reviews cover the whole story; later rounds follow `review-check.sh`'s scope. A builder report stops `ready-for-review`, never accepted.

Each review writes `<evidence>/review-N/review.json`. Main runs `review-check.sh --repo <worktree> --base <actual-base> <evidence>` and obeys REVIEW AGAIN / MOVE ON / ASK JUSTIN. Only after MOVE ON for current head, a fresh read-only verifier reruns all gates/ACs and writes `verifier/ac.json`; a fresh blind AC auditor receives approved plan, worktree, head/base and only its own `auditor/` destination, and proves every AC independently. Main then runs:

```text
~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base <merge-base-of-head-and-integration-branch> --plan <evidence>/plan-approved.md --reviews <evidence> <evidence>/verifier/ac.json <evidence>/auditor/ac.json
```

Angle-bracket values here are an argument contract for the future role brief, not a runnable shell command. Actual values must be recorded before execution. A fixer changing head requires a fresh review then verifier/auditor/ac-check again. No unreviewed final doc/contract commit. Only ALL ACCEPTED, or READY FOR THE USER with explicitly owed live checks, permits handover. This plan has no live-only AC, so missing local demo/DB proof cannot be reclassified as a user check to finish. Reviewers/verifiers/auditors return verdict, ac_status and skill_lessons; main checks earlyoom after every agent.

Finisher follows Leorna stop-and-show-diff: local story commits, exact diff/stat, gate summary, screenshots and recording, paste-ready PR description, independent review prompt, ClickUp evidence draft and team message draft. Never push, make a PR, post evidence, send a message or merge without the user's separate authorization. Do not call unrun hosted CI green.

## Risks, readiness and found_else

- **Product choice:** one configuration per provider is a stated recommendation, not a hidden database limitation. Choice B changes scope and needs replanning.
- **Environment:** Docker is currently unavailable. Go/lint/vulnerability tools are installed outside default PATH. Chrome exists but launch and capture have not been exercised. Tool/DB/browser preflight must pass before execution is called ready.
- **Concurrency:** shared composition, catalog, pack resolver, migration number and delivery record can overlap another story. Recheck actual sibling plans/diffs immediately before build and after rebasing; preserve both changes.
- **Provider readiness:** definitions are preview. Local template validation and screenshots prove configuration behavior, not live provider authorization, tool connection or stable support. Native provider sign-in/verification belongs to sibling integration stories.
- **Security/data:** tenant filtering must cover list, edit and pack resolution; persisted role and CSRF checks cannot be UI-only. Save and audit must share one transaction. Secret-bearing inputs must not leak through errors/audit. Tests and mutants explicitly cover these boundaries.
- **Snapshot semantics:** changing configuration leaves old pack copies untouched. The UI/docs must explain selection of a new revision through existing pack editing; no automatic tenant-wide propagation.
- **Evidence:** recorded demo is required and must show a real run. Screenshots alone, synthetic success logs or compile errors on base do not satisfy it.
- **Context gap:** no applicable repo/ancestor project CLAUDE.md was found, and no matching tracked setup copy was available. Global rules, repo AGENTS and shared memory were used; do not create a replacement.
- **Sync:** Justin's user-run pull fulfilled the pre-planning sync prerequisite. Main reports subsequent setup sync cannot write its read-only gitdir even with escalation. This plan is saved locally; synced status is unconfirmed. Do not bypass that restriction or reintroduce the resolved pull hold.

`found_else`: no independently confirmed unrelated product bug is proposed for repair. Docker unavailability and absent project CLAUDE are environmental/context findings above, not an excuse to expand story scope. No tests were executed in planning; no source, branch, migration, database, host configuration, ClickUp or GitHub mutation was performed except the explicitly required local remote-tracking fetch.

## Skills/context receipt and completion contract

Actual SKILL.md reads succeeded at these paths, in the required order (large outputs were split/reread for relevant omitted sections):

| Path | Application |
|---|---|
| `/home/justin/.agents/skills/leorna/SKILL.md` | Planner role, shared context, main verification, explicit go, gates/evidence and handover. |
| `/home/justin/.agents/skills/engineering-best-practices/SKILL.md` | Existing owner reuse, bounded scope, testing, security and candid receipts. |
| `/home/justin/.agents/skills/implementation-planning/SKILL.md` | Saved finite plan, numbered ACs, exact interfaces/files/tests and validation. |
| `/home/justin/.agents/skills/security-best-practices/SKILL.md` | Go server-rendered security; read Go backend reference. No new JS surface. |
| `/home/justin/.agents/skills/multi-tenant-auth-management/SKILL.md` | Persisted-role/tenant/session/CSRF enforcement; architecture checklist read. |
| `/home/justin/.agents/skills/api-contract-drift-guard/SKILL.md` | Existing pack API consumer compatibility and generated contract descriptions. |
| `/home/justin/.agents/skills/backend-data-migrations/SKILL.md` | Additive migration, transactional audit, real Postgres tests and defect loop; Postgres reference read. |
| `/home/justin/.agents/skills/github/SKILL.md` | Read-only identity/main/PR verification; PR-workflow reference read. |

Also read the supplied/global rules and actual global files, repo `AGENTS.md`, `delivery/README.md`, AGENTS-linked domain/issue-tracker/triage docs, glossary and relevant ADR; shared `MEMORY.md`, current workflow/control-plane notes and task/feedback notes including no CI changes, assumptions, no auth bypass, small verified scope, consistency, ClickUp evidence and finish/review/team-message preferences. Historical dense workflow outputs were scoped to current relevant entries; this is not a claim that every historical note was needed. Dispatcher planning/build/review instructions, `references/review-loop.md`, `references/ac-verification.md`, implementation plan-validation and frontend-quality references were consulted. The custom-domain handoff and current git/worktree state establish the overlap hold. git-commit-rules and TDD are later-role requirements; planning performed no commits or implementation.

Plan saved 2026-11-04 after tool-observed UTC timestamp. Embedded Bash blocks passed `bash -n`; both Go blocks passed `gofmt` parsing (the interface fragment was wrapped in a package declaration only). These are syntax checks, not compilation or runtime proof. The saved artifact contains AC1–AC4 exactly once as criterion definitions. Source checkout remains untouched on local main, behind 94 commits, with only its pre-existing untracked `.claude/`. Implementation forecast is **one bounded feature build plus full independent review/verification**, with runtime depending on restored Docker and existing baseline gate health; no completion-time promise is inferred from planning duration. Exact planner timing was not instrumented from its first action, so no invented elapsed receipt is supplied.

Approval means architecture/scope and recommended choices only, followed by the authorized Full pipeline when prerequisites are met. Source qualification, local browser demonstration, actual provider connection, hosted CI and production promotion remain distinct facts. The latter provider/promotion activities are outside this story. Main must present questions and plan, wait for explicit go, record answers, freeze the approved plan and brief the builder with the exact base/resources/overlap result.

Skill lessons: `skill_lessons: []`.
