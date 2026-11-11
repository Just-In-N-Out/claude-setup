# 86bcm928e — Custom integrations defined by the admin (plan)

Status: **plan, waiting for Justin's "go"**. Planner: Fable 5.2 high, 2026-11-10. Repo: `leorna-control-plane` only. Pipeline: Full. Size M.
Card: ClickUp 86bcm928e (E14 Integrations, PI-2). Snapshot: `~/.hermes/plans/leorna/evidence/86bcm928e/intake/clickup-snapshot.md`. Dependency 86bcm927y is merged (PR #112).

## Questions (the plan is written as if every ⭐ was chosen; a bare "go" accepts them)

1. **Which commands may a custom integration run on engineers' machines?** (A "command" integration starts a program on every engineer's computer that syncs the pack.)
   - A) ⭐ Only `npx` at an exact version or a digest-pinned `docker run` image (the rule shipped tiles already pass)
   - B) Any command the admin types (audited only)
   - C) No commands in this story: server URL only
2. **Which sign-in methods can a custom integration use?**
   - A) ⭐ A personal token kept in a variable, or browser sign-in (OAuth)
   - B) Also "no sign-in" for open internal servers (changes the shared tile format)
3. **Can an admin delete a custom integration in this story?**
   - A) ⭐ No: create and edit only; delete is a follow-up
   - B) Yes, but only before it has saved settings
4. **Should the desktop app's tile list include custom tiles?** (`GET /v1/client/integration-tiles`; only the unmerged client story 86bcm928h reads it.)
   - A) ⭐ No: API unchanged, no client work; follow-up after 928h
   - B) Yes: add the company's custom tiles to that list
5. **Test Postgres for the build** (the shared `leorna-test-pg` container has been stopped for 10 days):
   - A) ⭐ Each role runs its own throwaway Postgres container
   - B) Start the shared `leorna-test-pg` again

## Acceptance criteria (from the card, unchanged; one test each)

- AC1: Given the console, when I define a custom integration (name, MCP server URL or command, parameters, auth method), then it is saved as a tenant-owned tile — proven by `TestCustomIntegrationAC1DefineSavesTenantOwnedTileWithPostgres` (`./internal/web`): the admin posts the definition form, a row with that company's tenant id is stored, the tile shows on the Integrations page with its parameters and sign-in, a create audit record is written; another company's admin cannot see, open, edit or configure it, and a member, a signed-out visitor and a wrong CSRF token are refused.
- AC2: Given a custom tile, then it can be configured, added to packs and synced exactly like a predefined tile — proven by `TestCustomIntegrationAC2ConfigurePackSyncLikePredefinedWithPostgres` (`./internal/web`): the custom tile and the predefined GitHub tile (the control) are configured through the same form route, picked in the same pack builder, assigned to a team, and the member engineer's bundle holds both items; Claude Code, Codex and Cursor files rendered from that bundle hold both servers with the credential by reference; an invalid setting, another company's pack builder and an engineer outside the team are refused for both alike.
- AC3: Given invalid definitions (embedded secret, malformed URL/command), then save is blocked with a clear message — proven by `TestCustomIntegrationAC3InvalidDefinitionBlockedWithPostgres` (`./internal/web`): a secret in the URL, a header, an argument, an environment value and a parameter example, a malformed URL and a malformed command each get 400 with a message naming the problem, the secret is never shown back, nothing is stored or audited, and the same form without the defect saves.

No AC is `(live)`: every check is agent-run (Go tests against Postgres, plus headless-Chrome screenshots of the console on a local test server).

How they are run (the verifier's and auditor's command, one test at a time):
`go test -v -count=1 -run '^<test name>$' ./internal/web` with `LEORNA_TEST_DATABASE_URL` and gitleaks set (Task 0).

Predicted result on the base commit (Task 1 proves it before any production code): the three tests use only HTTP, SQL through `f.pool` and helpers that already exist in `internal/web` test files, so they **compile on base** and fail on their first assertion: `POST /admin/integrations/custom` is taken by today's `POST /admin/integrations/{tileID}` route with tile id `custom`, which answers 404 "Integration not found" (`internal/web/handler.go:308`, `internal/web/integrations.go:76-77`), where the tests want 303 (AC1, AC2) or 400 (AC3).

## Playback

Justin asked for ClickUp story 86bcm928e: an admin defines their own integration in the admin console (an internal service that has its own MCP server): a name, the MCP server's URL or its start command, the parameters a company fills in, and how engineers sign in. It is saved as a tile that belongs to that company. From then on it behaves like the built-in GitHub and ClickUp tiles: configure it, add it to a pack, assign the pack, and engineers get it on sync. A definition with a secret in it, a bad URL or a bad command is refused at save with a clear message.

## Base, dependencies and host

- **Base SHA: `4ef14efb46da789aec30fad1e5a988d8770140e2`** = GitHub `main` at 2026-11-11 00:58Z (`gh api repos/LeornaAI/leorna-control-plane/commits/main`), also the local `origin/main`. All research below is `git show`/`git grep` at that SHA. The main checkout's own `main` is 4 commits behind (`d9c6aa8`); Task 0 fast-forwards it.
- Merged and relied on: 86bcm927v tile format, 86bcm927y tiles UI (#112), 86bcm928t governance (#114), 86bcm9284 predefined tiles (#119).
- Host (WSL desktop), checked now: `make` and `gcc` on PATH, `go env CGO_ENABLED` = 1, gitleaks 8.30.1 at `/usr/local/bin`, Docker reachable; Go 1.27.3, golangci-lint 2.14.0 and govulncheck 1.7.0 are in `~/.local/leorna-toolchain` (`go/bin`, `bin`), off PATH, to be used through a task-local PATH; Chrome for Testing at `~/.cache/chrome-for-testing/chrome-linux64/chrome` with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`. `psql` is not installed (use `docker exec <container> psql`). **`leorna-test-pg` is `Exited (255) 10 days ago`** (question 5); the image `mirror.gcr.io/library/postgres:18.6-alpine3.23` is on disk. Port 5432 is `leorna-pg` (not ours, never touch). Load average was 27 during planning: expect slow gates and rerun a timed-out Postgres test alone before calling it a regression. earlyoom: no kills in the last 90 minutes.

## What exists today (the model custom tiles must fit)

- **Tile format** (`internal/integration/tile.go:65-116`): `Tile{ID, Name, Version, Stage, Description, Homepage, Variants[]}`; `Variant{ID, Name, Description, Params[], SignIn[], Servers}`. `Servers` is an `mcpServers` JSON object using only `command`, `args`, `env`, `url`, `headers`. `{{param}}` is filled by the control plane, `${VAR}` is the engineer's credential, read by the AI tool from the engineer's environment.
- **Tile validation** (`tile.go:152-413`): https-only URLs (`:364`), exactly one of command or url (`:361`), credential-named env keys and headers must be `${VAR}` or `Bearer ${VAR}` (`:375`, `:386`), every `${VAR}` must be declared by a sign-in (`:401`), every parameter must be used (`:408`). Sign-in methods are `oauth` (client `dynamic` or `preregistered`) and `token` (`tokenEnvVar` + https `helpUrl`) (`:288-325`).
- **Shipped tiles** are embedded JSON (`catalog.go:17-27`); every variant runs through the content library gate in CI (`cmd/library-gate/tiles.go:78-139` builds an in-memory library, `gate.Run` checks layout, schema, render per tool, format, the MCP template policy and gitleaks).
- **Template policy** (`internal/library/gate/policy.go:273-426`): credentials in env, headers, args and URLs (user:password, credential query parameters) are refused; a stdio command must be `npx` with an exact package version or `docker run` with an image pinned by digest (`launcherProblem`, `:434-499`); env keys that change what runs (`PATH`, `NODE_*`, `DOCKER_*`…) are refused (`:86-121`). Its reasons name a key or position and never repeat a value.
- **Configure** (`service.go:31-92`): `Service.Save` finds the tile in the shipped list, resolves the values, renders, runs `gate.CheckTenantItem` (render for the three tools + gitleaks) and calls `SaveIntegrationConfiguration`, which stores one row per `(tenant_id, tile_id)` in `integration_configurations` (migration 28) and writes `integration.configure`/`integration.update` audit records in the same transaction (`internal/store/postgres/integrations.go:34-86`).
- **Pack builder**: the catalog adds the company's configurations as entries (`internal/web/library_variants.go:82-93`); `loadCatalogItems` reads them `WHERE tenant_id=$2` (`internal/store/postgres/pack_builder.go:310-316`). The item is `mcp_template/integration-<tile id>`, a reserved name space (`reach.go:13-19`).
- **Sync**: pack versions copy the item; the desktop gets it through `ResolveForProject` and `/v1/client/projects/{id}/bundle` + content. `TestPredefinedTilesAC2EnableAndSyncWithPostgres` (`internal/web/predefined_tiles_test.go:162`) is the predefined path end to end and is this story's control.
- **Console**: server-rendered HTML forms under `/admin/integrations` (`internal/web/integrations.go`), not in the OpenAPI contract. `GET /v1/client/integration-tiles` (in the contract) lists shipped tiles only (`client_integrations.go:19`).

## Approach

A custom integration is **a `Tile` in the existing format, stored per company instead of embedded**. A new table holds the tile JSON. The integration service looks a tile up in "shipped tiles + this company's custom tiles"; everything after the lookup (configure → `integration_configurations` → catalog → pack builder → bundle → sync) is the code predefined tiles already use, unchanged. Definitions are checked by the checks shipped tiles already pass: `Tile.Validate`, a render with the parameters' example values, and `gate.Run` (render for Claude Code, Codex and Cursor, the template policy, gitleaks). No second tile model, no second audit path, no new sync path, no OpenAPI change.

Planner's probe (read-only, a `git archive` copy of the base, 24 tile shapes through today's `tileLibrary` + `gate.Run` with real gitleaks 8.30.1): valid URL+token, URL+OAuth, `npx` and `docker` custom tiles pass and render for all three tools; every bad shape below is refused with a value-free reason. Results are in "Probe results" at the end.

## Design

### 1. Data: migration 32

`internal/store/postgres/migrations/000032_integration_custom_tiles.up.sql` (exact):

```sql
CREATE TABLE integration_custom_tiles (
    id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
    tile_id text NOT NULL CHECK (length(tile_id) BETWEEN 8 AND 64 AND tile_id ~ '^custom-[a-z0-9]+(-[a-z0-9]+)*$'),
    revision bigint NOT NULL CHECK (revision > 0),
    definition jsonb NOT NULL CHECK (jsonb_typeof(definition) = 'object' AND octet_length(definition::text) <= 65536),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (tenant_id, tile_id)
);
```

`.down.sql`: `DROP TABLE integration_custom_tiles;`

Additive only (expand step; no existing table changes, no data fill). `definition` is the whole `Tile` JSON. Add the table to both lists in `TestMigrationRoundTrip` and to the `resetDatabase` drop list (`internal/store/postgres/store_test.go:34`, `:104`, `:499`), before `integration_configurations`. Next free number checked: base's highest is `000031_cost_alert_refresh`; no local branch and no open PR adds a migration.

### 2. Domain: `internal/integration/custom.go` (new)

- `const CustomPrefix = "custom-"`, `CustomVariantID = "default"`, `MaxCustomParams = 8`; `func IsCustom(tileID string) bool`.
- `func CustomID(name string) (string, error)`: lowercase the name; every run of characters outside `a-z0-9` becomes one `-`; trim `-`; cut to 40 characters and trim `-` again; empty → error. Result `custom-<slug>` (at most 47 characters, so the gate's item name `tile-<id>-default` stays under the library's 64). Vectors: `Acme Billing` → `custom-acme-billing`; `ACME  billing (EU)` → `custom-acme-billing-eu`; `日本語` → error; a 60-letter name → `custom-` + its first 40 letters.
- `type Definition struct` — what the admin types: `Name, Description, Homepage string; Connection string` (`url`|`command`)`; URL string; Headers []Pair; Command string; Args []string; Env []Pair; Params []Param; SignIn string` (`token`|`oauth`)`; TokenEnvVar, TokenHelpURL string`. `type Pair struct{ Name, Value string }`.
- `func (d Definition) Tile(id string, expectedRevision int64) (Tile, error)` builds the tile:
  - `ID` = id; `Version` = `1.0.<expectedRevision>` (same rule as the configured item's version); `Stage` = `preview` (Leorna has not proven it); `Name`, `Description`, `Homepage` from the form.
  - One variant: `ID` `default`, `Name` = the tile name, `Description` = `Defined by your company.`.
  - One server, **named with the tile id** (`custom-acme-billing`), so it can never collide with a shipped tile's server name. URL connection: `{"url": …, "headers": {…}}` (headers omitted when empty). Command connection: `{"command": …, "args": […], "env": {…}}` (each omitted when empty).
  - Params as typed, with `Pattern` set to `[A-Za-z0-9][A-Za-z0-9._-]{0,127}` for `text` and empty for `url`.
  - Sign-in: `token` → `{method: token, tools: [claude-code, codex, cursor], tokenEnvVar, helpUrl}`; `oauth` → `{method: oauth, tools: [same three], client: dynamic}`.
  - Returns a `DefinitionIssue` (below) for the structural rules S2 in the table.
- `func DefinitionOf(tile Tile) (Definition, error)`: the inverse, for the edit form (headers and env as sorted lines).
- `func CheckCustomShape(tile Tile) error`: the invariants above on a built tile (prefix, one `default` variant, stage `preview`, exactly one server named by the id, at most 8 params, exactly one sign-in of an allowed kind with the three tools, a command server signs in by token). Used by the service and again by the store.
- `type CustomTile struct { ID string; Tile Tile; Revision int64; CreatedAt, UpdatedAt time.Time }` (ID = row UUID, the audit target); `type CustomSpec struct { Tile Tile; ExpectedRevision int64 }` with `Validate()` = `Tile.Validate()` + `CheckCustomShape` + `Tile.Version == "1.0.<ExpectedRevision>"` + revision bounds (as `SaveSpec.Validate`).
- `type DefinitionIssue struct { Message string; Secret bool }`, `Error()` returns the message, `Unwrap()` returns `ErrInvalid`. `var ErrTaken = errors.New("custom integration name is taken")`.
- `catalog.go` `Parse` (shipped tiles only) additionally refuses a tile id that is `custom` or starts with `custom-`, so a later shipped tile can never collide with a company's tile.

### 3. The checks at save (AC3: what the server enforces)

Every check below runs on the server in `Service.Define`; the browser's `required`, `type=url`, `maxlength` attributes are extra. Order matters: the secret scan runs before any check whose message could quote something the admin typed.

| Step | Check | Refused example | Message (fixed text unless noted) |
| --- | --- | --- | --- |
| S1 | Form shape (web): each field once, no unknown field, at most 32 KiB, no control characters | a repeated `name`, a forged `tenant_id` | `Check the form and submit each field once.` |
| S2 | Structure (`Definition.Tile`): name 1–200 characters with a letter or digit; description 1–2000; homepage an https URL; connection `url` or `command`; URL starts with `https://`, at most 2048 characters, no spaces; header lines `Name: value` (HTTP token name, non-empty value, no duplicate ignoring case, at most 16); command a single word; args one per line (at most 32); env lines `NAME=value` (variable name, no duplicate, at most 16); parameter rows: lowerCamelCase name, label, type `url` or `text`, an example (required, the gate renders with it), at most 8; sign-in `token` (UPPER_CASE variable + https help link) or `oauth`; a command server signs in by token | `http://…`, `X Y: 1`, `1BAD=x` | one fixed sentence per rule, e.g. `The server URL must start with https://.`, `Each header is one line: Name: value.`, `Each parameter needs an example value.`, `The command must be one word, a reviewed launcher (npx or docker); put each argument on its own line.` |
| S3 | **Secret scan of the definition**: the tile JSON is written to a temp folder and scanned with the repo's secret scanner (`gate.Scanner`, gitleaks, the same one `gate.CheckTenantItem` uses). Covers name, description, labels, help, examples, URL, command, args, env and headers | a token pasted into a header, an argument or a parameter example | secret message (below), `Secret: true` |
| S4 | Shared tile rules (`Tile.Validate`) | `Authorization: Bearer abc` (a literal in a credential header), `${OTHER}` no sign-in declares, a parameter never used | `The definition is not valid: ` + the rule's own words after the variant prefix; a rule that says "credential" is the secret message instead |
| S5 | The token variable is not one a shipped tile declares (today `GITHUB_PERSONAL_ACCESS_TOKEN`, `GOOGLE_OAUTH_CLIENT_SECRET`): a custom server must not be handed another service's token | `GITHUB_PERSONAL_ACCESS_TOKEN` | `That variable belongs to a built-in integration. Choose a variable name of your own for this service.` |
| S6 | Render with the parameters' examples, then `gate.Run` on it: render for Claude Code, Codex and Cursor, file formats, the **template policy** (credentials in URL, args, env, headers; launcher rule; launch-setting env keys) and gitleaks on the rendered files | `https://user:pw@host/…`, `https://`, `?api_key=…`, command `bash`, `npx pkg` without a version, `--token abc`, env `PATH` | render failure: `The server URL is not a valid https:// address once the parameters' examples are filled in. Use https://host/path with no user name or password.`; policy: the gate's own reason with the leading `server "<id>" ` removed (e.g. `command is not npx; only npx with an exact package version, or docker run with an image pinned by digest, is a reviewed launcher`); a reason that says "credential", or a secrets-stage finding: the secret message |
| S7 | Store: persisted admin role, tenant, `CustomSpec.Validate`, revision | a member, a stale revision | 403 / `Another administrator changed this definition. Reload and review it before saving.` (409) |

Secret message: `This definition holds something that looks like a credential. Nothing was saved. Never paste a token, password or key: pick the sign-in method and write the engineer's own variable as ${NAME}.` On a secret refusal the form comes back **with every typed field empty**; on other refusals the typed values are shown again (HTML-escaped) so the admin can fix them. Pages are `Cache-Control: no-store` already.

"Malformed URL" therefore means: not starting with `https://` (S2/S4), not a parseable https URL with a host once examples are filled in, or holding a user name or password (S6). "Malformed command" means: not a single word (S2), not one of the reviewed launchers, an unpinned package or image, or an option the policy refuses (S6).

**At configure time** a custom tile is checked once more: after rendering with the admin's real values, the same S6 gate runs on that render (a parameter value must not undo what the examples passed, e.g. a version parameter set to `latest`). The predefined path is unchanged.

### 4. Auth methods and how a secret is referenced

- Allowed values: `token` and `oauth` (question 2 ⭐).
  - `token`: the admin names a variable (say `ACME_BILLING_TOKEN`) and gives an https link where engineers create the token. Each engineer keeps the token in that variable on their own machine. The definition refers to it as `${ACME_BILLING_TOKEN}`: a header `Authorization: Bearer ${ACME_BILLING_TOKEN}` (or any header whose whole value is `${ACME_BILLING_TOKEN}`) for a URL server, or an environment line `ACME_BILLING_TOKEN=${ACME_BILLING_TOKEN}` for a command server (the key must equal the variable; Codex forwards a variable under the key's name).
  - `oauth`: browser sign-in the AI tool runs itself with dynamic client registration; URL servers only; nothing is typed.
- A credential is never stored: not in the definition, the configuration, the pack, the audit record or the bundle. The form's help text says this next to the fields.

### 5. Service: `internal/integration/service.go`

- `Store` interface gains `ListCustomTiles(ctx, actor) ([]CustomTile, error)`, `GetCustomTile(ctx, actor, tileID string) (CustomTile, error)`, `SaveCustomTile(ctx, actor, CustomSpec) (CustomTile, error)`. The only fake to update is `configurationStore` in `service_test.go`.
- `TilesFor(ctx, actor) ([]Tile, error)`: shipped tiles in their order, then the company's custom tiles by id. `Tile(ctx, actor, tileID) (Tile, error)`: a shipped tile, or (for ids with the prefix) the company's own custom tile; `store.ErrNotFound` otherwise. `CustomTile(ctx, actor, tileID)`. `Tiles()` stays (shipped only).
- `Define(ctx, actor, Define{TileID, ExpectedRevision, Definition}) (CustomTile, error)`: an empty `TileID` creates (id from `CustomID`, expected revision 0, an existing id → `ErrTaken`); otherwise edits that custom tile (the id never changes, the name may). Runs S2–S6, then `SaveCustomTile`.
- `Save` (configure): the shipped-list loop at `service.go:35-44` becomes `service.Tile(ctx, actor, in.TileID)`; a custom tile then gets the S6 gate on its real-value render; the rest of the function is untouched and shared.
- Gate reuse: move the body of `tileLibrary` (`cmd/library-gate/tiles.go:78-139`) to `internal/integration/gatefiles.go` as `GateFiles(tiles []Tile, values func(Tile, Variant) (map[string]string, error)) (files map[string][]byte, failures []gate.Failure)` plus `ExampleValues`. `cmd/library-gate/tiles.go` keeps `tileLibrary` as a thin wrapper (`GateFiles(tiles, ExampleValues)` into `fstest.MapFS`), so the CI gate's output is unchanged and its tests stay as they are. The service writes the files into an `os.MkdirTemp` folder and runs `gate.Run(ctx, os.DirFS(root), scanner)`.

### 6. Store: `internal/store/postgres/integrations_custom.go` (new)

- `SaveCustomTile`: `spec.Validate()`; `beginOrg(ctx, actor, true)` (rechecks the persisted admin role and tenant); `SELECT … FROM integration_custom_tiles WHERE tenant_id=$1 AND tile_id=$2 FOR UPDATE`; revision compare (`ErrChanged`); no-change compare `(definition - 'version') = ($3::jsonb - 'version')` (`ErrNoChange`); `INSERT … revision 1` or `UPDATE … revision=revision+1, updated_at=now()`; a unique violation is `ErrChanged`; then `database.appendAudit(ctx, tx, actor, action, saved.ID, before, after)` and commit. Same shape as `SaveIntegrationConfiguration`.
- Audit (the existing path, `audit.go:13`): actions `integration.custom.create` and `integration.custom.update`, target = the row UUID. Before/after hold `tileId`, `version`, `revision`, `name`, `connection` (`url`|`command`), `signIn`, sorted `parameters` names and sorted `changed` (of `name`, `description`, `homepage`, `server`, `parameters`, `signIn`); create's before is null. Never the URL, command, args, headers, env or example values. Refused, unchanged and stale saves write nothing.
- `ListCustomTiles` / `GetCustomTile`: `beginOrg(ctx, actor, true)`, `WHERE tenant_id=$1` (and `tile_id=$2`), decode with the package's strict tile decoder; unknown or other-tenant id → `store.ErrNotFound`.
- `SaveIntegrationConfiguration` (`integrations.go:34`), one addition: when `integration.IsCustom(spec.TileID)`, read that company's custom tile row `FOR SHARE` in the same transaction; no row → `store.ErrNotFound`; its version differs from `spec.TileVersion` → `ErrChanged`. A direct store call can't configure a tile the company doesn't own, and a definition edited mid-save is not silently mixed with an older render.

### 7. Web: `internal/web/integrations_custom.go` (new) and small edits

Routes (admin only, same wrappers as `handler.go:306-308`):

| Route | Does |
| --- | --- |
| `GET /admin/integrations/custom/new` | empty definition form |
| `POST /admin/integrations/custom` | create → 303 `/admin/integrations/<id>?defined=1` |
| `GET /admin/integrations/custom/{tileID}/edit` | form filled from the stored definition |
| `POST /admin/integrations/custom/{tileID}` | edit (optimistic `expected_revision`) → 303 to the same configure page |

Form fields (each once): `csrfToken`, `expected_revision`, `name`, `description`, `homepage`, `connection`, `url`, `headers`, `command`, `args`, `env`, `param_name_1…8`, `param_label_N`, `param_type_N`, `param_example_N`, `param_help_N`, `param_required_N`, `signin`, `token_env`, `token_help_url`. A parameter row counts when its name is non-empty. `command` is a text input (the server decides what is allowed, so a bad command can be typed and is refused with its reason). `adminFormLimit(w, r, 32<<10)` gives the session, CSRF check and size bound.

Pages:
- Integrations grid (`integrations.go:66-68`): cards from `TilesFor`, so a custom tile is the same `<article data-integration="<id>" class="tile">` with a second chip `Custom`, its Configure/Edit settings link and an `Edit definition` link. Below the grid, outside any `<article>`: `<a class="action" id="define-custom" href="/admin/integrations/custom/new">Define a custom integration</a>` (existing tests count `<article>` cards against the shipped tiles for companies without custom tiles; that stays true).
- Configure page (`loadIntegrationPage`, `integrationSave`): tile lookup through `Service.Tile`, so `/admin/integrations/<custom id>` is the same page and form as GitHub's; a `defined=1` notice says `Custom integration saved. Save its company settings below, then add it to a pack.`; a policy refusal at configure shows the gate's reason.
- Definition form: one page with the fields above, help text for `{{parameter}}` and `${VARIABLE}`, the error in `<p class="alert" role="alert" id="custom-error">`.
- `content_usage.go:164`: `ReachByTeam` gets `TilesFor` instead of `Tiles()`, so "Integrations by team" shows a custom tile by its name.

Status mapping: `DefinitionIssue` 400; `ErrTaken`, `ErrChanged` 409 (`A custom integration with this name already exists.`); `ErrNoChange` 400 (`This definition is unchanged. Nothing was saved.`); forbidden 403; unknown or other-company id 404; scanner unavailable 503 (`The definition could not be checked. Try again later.`).

### 8. API and OpenAPI

**No API change.** The console pages are HTML, outside `contracts/control-plane.openapi.yaml`. `GET /v1/client/integration-tiles` keeps returning the shipped tiles only (a supporting test pins that a company's custom tile never appears there). `make contracts-check` and an empty `git diff <base>...HEAD -- contracts packages/contracts` are the proof. No client change: a custom tile reaches the desktop as an ordinary `mcp_template` pack item, which the client's transformers already render (the gate renders with the control plane's copy of them for all three tools before anything is saved).

### 9. Security

- **Risk:** a command integration is a program started on every engineer's machine that syncs the pack, with the engineer's rights; a URL integration receives whatever credential the definition sends it. A careless or compromised admin account is the threat.
- **Guards:** (1) admins only, by route and again from the persisted role inside the store transaction; CSRF on every POST; other companies get 404. (2) Commands are limited to the reviewed launchers (`npx` at an exact version, `docker run` of a digest-pinned image with only safe options), and env keys that change what runs are refused: the library gate's policy, reused, at define time and again on the real values at configure time. (3) No secret is stored; credential fields must be `${VAR}` references; the scanner and the policy refuse embedded ones. (4) A custom tile can't claim a shipped tile's token variable. (5) Every create and edit is audited in the write's transaction; reaching engineers still takes the audited configure → pack → assign steps; saving a definition assigns nothing. (6) Typed secrets are never shown back.
- **Left open (follow-ups):** a pinned package or image can still be a bad choice by the admin; no approval by a second admin; no delete.

## Choices (made by the planner; say "change: …" to alter one)

1. One tile model: custom tiles are `Tile` JSON in a new table, looked up beside the shipped ones; nothing downstream changes.
2. Tile id is `custom-<slug of the first name>`, fixed at creation; the reserved prefix is refused for shipped tiles.
3. One variant (`default`), one server named with the tile id, stage `preview`, all three tools declared (the gate proves each renders).
4. Text parameters use one fixed safe pattern (letters, digits, `.`, `_`, `-`); no admin-written regular expressions.
5. Version `1.0.<revision-1>`; editing a definition does not change existing settings or packs until the settings are saved again (as with shipped tile updates).
6. Secret refusals clear the form; other refusals keep what was typed.
7. The launcher policy also runs on a custom tile's real values at configure time.
8. A custom tile cannot use a shipped tile's token variable.
9. No cap on the number of custom tiles per company (admin-only writes, 64 KiB each).
10. No OpenAPI, client or CI change. Migration number 32.

## Assumptions

- "Synced" in AC2 is the engineer's bundle and its content (the sync payload), rendered per tool with the control plane's copy of the client transformers, as the predefined tiles' AC2 does. No real desktop run.
- An internal MCP server is reachable over https or started by `npx`/`docker`. A plain local binary is out (question 1).
- A homepage (documentation link, https) is required, because the shared tile format requires it.
- Engineers set the token variable themselves, as for GitHub on main today (the keyring flow is the unmerged client story 86bcm928h).

## Files and areas touched

- New: `internal/integration/custom.go`, `custom_test.go`, `gatefiles.go`; `internal/store/postgres/integrations_custom.go`, `integrations_custom_test.go`, migrations `000032_integration_custom_tiles.{up,down}.sql`; `internal/web/integrations_custom.go`, `custom_integrations_test.go`, `custom_integrations_support_test.go`, `custom_integrations_browser_test.go` (opt-in evidence).
- Edited: `internal/integration/{service.go,service_test.go,configuration.go,catalog.go,README.md}`; `cmd/library-gate/tiles.go`; `internal/store/postgres/{integrations.go,store_test.go}`; `internal/web/{handler.go,integrations.go,content_usage.go}`; `internal/audit/README.md`; `delivery/stories.json`.
- Not touched: `.github/workflows/*`, `contracts/`, `packages/contracts/`, `internal/library/gate/*` (called, not changed), `internal/library/render/*`, the client repo, `deploy/local/`.

## Overlap with siblings (checked 2026-11-11 00:58Z)

- Open PR #113 `feat/86bcx2a33-github-mcp-current` (already conflicting with main): shares only `delivery/stories.json` with this story (append-at-end; the second to merge keeps both entries). Its other files (gate tests, library content, `packs_test.go`, `item_*_integration_test.go`) are not edited here.
- `feat/86bcm9284-source-repin` (local, 1 commit): only `internal/library/render/testdata/client/SOURCE.md`. No overlap.
- `feat/86bcm928t-…`, `feat/86bcm927y-…`, `feat/86bccndx6-…` (local): their stories are merged; each has one leftover `stories.json` record commit that was never pushed. No code overlap.
- Client `feat/86bcm928h-per-user-credentials` (unmerged): reads the tile list this story leaves unchanged.
- Migration 32: free on main, in every local branch and in PR #113. If another story lands 32 first, renumber this pair (`leorna` skill, step 7.2).
- Build order: independent of all of the above; can build now.

## Tasks

Forecast: about 5–6 hours of builder time including gates; confidence medium (the web form and its tests are the largest part). Test first on every slice; one commit per slice, `feat(86bcm928e): …`, each green.

**Task 0 — Worktree, tools, database (≈10 min).** Fetch GitHub main over HTTPS through gh (`leorna` skill step 7.1), record the SHA (if it is no longer `4ef14ef`, say so in the report and carry on from the new one). Fast-forward the main checkout's `main` (`git merge --ff-only origin/main`; stop and ask if it refuses). `git worktree add -b feat/86bcm928e-custom-integrations /home/justin/Leorna/86bcm928e-custom-integrations origin/main`. Task PATH: `~/.local/leorna-toolchain/go/bin:~/.local/leorna-toolchain/bin:/usr/local/bin:/usr/bin:/bin`. Owned disk scratch `~/.cache/928e-builder/` (`mkdir` without `-p`) with `TMPDIR` inside it; never `/tmp`. Own Postgres: `docker run -d --name 928e-builder-pg -e POSTGRES_USER=leorna -e POSTGRES_PASSWORD=ci-only-password -e POSTGRES_DB=leorna_test -p 127.0.0.1::5432 mirror.gcr.io/library/postgres:18.6-alpine3.23`, port from `docker port`, `LEORNA_TEST_DATABASE_URL=postgres://leorna:ci-only-password@127.0.0.1:<port>/leorna_test?sslmode=disable`; remove it at the end with `docker rm -f -v 928e-builder-pg` (only your own). Stop if Docker, Go or gitleaks is unusable.

**Task 1 — The three criterion tests, RED on base (≈40 min).** Write `internal/web/custom_integrations_test.go` (steps under Tests) using only HTTP, `f.pool` SQL and helpers already in the package (`newPredefinedTilesFixture`, `postIntegration`, `integrationForm`, `confirmPackForm`, `quickStartMint`, `quickStartBundle`, `quickStartContent`, `syncedFiles`). Run each by name; save the three failing runs as `<evidence>/builder/red-ac<n>.log`. Stop condition: a test that passes, skips or fails to compile on base is fixed before any production code.

**Task 2 — Domain (≈35 min).** `custom.go` with `custom_test.go`: `CustomID` vectors; `Definition.Tile` builds a tile that passes `Tile.Validate` for URL+token, URL+OAuth, `npx`+token, `docker`+token; one refusal per S2 rule; `DefinitionOf(d.Tile(…))` round-trips; `CheckCustomShape` refusals; `Parse` refuses a shipped tile named `custom` or `custom-x` (`TestShippedTilesNeverUseTheCustomPrefix`).

**Task 3 — Gate reuse (≈15 min).** Move `tileLibrary`'s body to `integration.GateFiles` + `ExampleValues`; keep the wrapper in `cmd/library-gate`. Characterization: `go test ./cmd/library-gate ./internal/integration` green before and after; `make library-check` output for the shipped tiles identical before and after (save both, `cmp`).

**Task 4 — Store (≈40 min).** Migration 32, `integrations_custom.go`, tests in `integrations_custom_test.go`: create/edit/revision/no-change (`TestCustomTileStoreSaveWithPostgres`), tenant isolation and role (`TestCustomTileStoreTenantIsolationWithPostgres`: other tenant list/get/save see nothing, same id allowed in two tenants, member 403, mismatched context refused), audit metadata without values (`TestCustomTileStoreAuditWithPostgres`), audit insert failure rolls the write back (`TestCustomTileAuditRollbackWithPostgres`, the `CHECK(false) NOT VALID` trick), malformed direct specs (`TestCustomTileStoreRefusesMalformedSpecWithPostgres`), the configuration guard (`TestConfigurationOfUnknownCustomTileIsRefusedWithPostgres`), round-trip and reset lists.

**Task 5 — Service (≈40 min).** Interface, fake, `TilesFor`, `Tile`, `CustomTile`, `Define`, the custom branch in `Save`. Unit tests with the fake store and a fake scanner: every S3–S6 refusal with its message class (`TestDefineRefusals`), nothing written on refusal, `ErrTaken`, scanner missing → error not save, `TestConfigureCustomTileRechecksPolicyWithRealValues` (definition `@acme/x@{{v}}` with example `1.4.2` saves; configuring `v=latest` is refused), predefined `Save` behaviour unchanged (existing tests green).

**Task 6 — Web (≈60 min).** Routes, form page, handlers, grid, configure page, `content_usage.go`. Goal: the criterion 1 test green, then criterion 2, then criterion 3 (messages, cleared form). Existing `TestIntegrations*`, `TestPredefinedTiles*`, `TestIntegrationGovernance*` stay green untouched.

**Task 7 — Supporting web tests (≈25 min).** `custom_integrations_support_test.go`: `TestCustomTileNeverInClientTileListWithPostgres`; `TestCustomIntegrationShowsInIntegrationsByTeamWithPostgres` (governance fixture, `SetMetrics(empty)`); `TestCustomIntegrationEditKeepsPacksUntilResavedWithPostgres` (edit bumps the version, the old pack version's item is unchanged, re-saving settings makes a new revision, stale `expected_revision` 409, unchanged 400, update audit record); `TestCustomIntegrationConfigureCannotBypassLauncherPolicyWithPostgres`.

**Task 8 — Mutation proofs (≈30 min, each run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`).** One mutant per guard, each killed by a named test, restored after: drop `tenant_id=$1` from the custom tile read; drop the admin `write` flag; skip S3; skip S6 at define; skip S6 at configure; skip S5; skip the audit append; skip the custom-row check in `SaveIntegrationConfiguration`; make a secret refusal keep the typed fields; let `Parse` accept `custom-`. Use never-true comparisons, not `false`. Receipts in `<evidence>/builder/mutants/`; gitleaks-scan that folder before handing back.

**Task 9 — Docs and delivery record (≈15 min).** See Docs & records.

**Task 10 — Evidence (≈30 min).** One screenshot per criterion into `~/.hermes/plans/leorna/evidence/86bcm928e/` (builder's copies under `builder/`), taken from the opt-in `TestCustomIntegrationsBrowserEvidenceWithPostgres` (modelled on `TestIntegrationsBrowserJourneyWithPostgres`: real TLS handler, Postgres, chromedp; skips unless `LEORNA_INTEGRATIONS_EVIDENCE_DIR` and `LEORNA_INTEGRATIONS_CHROME_BIN` are set; not cited by any criterion): `ac1-define-form.png` (the filled form), `ac1-custom-tile-card.png` (the grid with the custom card), `ac2-pack-builder.png` (the library/pack builder with the custom and GitHub items selected), `ac2-sync-run.png` (terminal capture of the criterion 2 test run with its "synced" lines, rendered as a page in headless Chrome and labelled a terminal capture), `ac3-blocked-secret.png` and `ac3-blocked-command.png` (the refused saves with their messages). Run Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with a short `~/.cache/928e/{t,u}` profile path. Look at every image: no token, e-mail, domain, tenant id or `/dev/login`.

**Task 11 — Gates on the final head (≈30 min, serial, in a detached copy at the same SHA for the ones that write into the tree).** `make check GOLANGCI_LINT=<abs>/golangci-lint GOVULNCHECK=<abs>/govulncheck` (confirm the versions against `.github/workflows/ci.yml`: 2.14.0 and 1.7.0 when planned); `bash ./scripts/test-module-add.sh`; `python3 -m unittest scripts/test_release.py`; the Postgres no-skip check (`go test -json` over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`, read per test, no skip naming `LEORNA_TEST_DATABASE_URL`; `leorna` skill → `references/gates.md`); `git diff --name-only <base>...HEAD` has no `.github/`, `contracts/` or `packages/contracts/` path. Log to `gates-<sha7>.txt` with one `label EXIT=<rc>` line per gate. A command that dies with 143, 137 or "Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

**Task 12 — Stop at `ready-for-review`.** Report branch, head, diff stat (`git diff --stat origin/main...HEAD`), gate lines, the evidence list, anything deferred. No push, no PR, no ClickUp write.

## Tests

Fixture for the three criterion tests: `newPredefinedTilesFixture(t)` (admin, member, other-company admin, the gitleaks gate, the desktop routes). Definition used throughout: name `Acme Billing`, URL `https://mcp.acme.example/{{region}}/mcp`, header `Authorization: Bearer ${ACME_BILLING_TOKEN}`, parameter `region` (text, required, example `eu-west`), sign-in `token` with `ACME_BILLING_TOKEN` and `https://wiki.acme.example/tokens`. Fake secrets are built in the test from parts (never a literal token in the file) and failure messages print lengths or booleans, never the value.

Test for criterion 1 (`TestCustomIntegrationAC1DefineSavesTenantOwnedTileWithPostgres`):
1. Admin `GET /admin/integrations/custom/new` → 200 with the form fields. Admin posts the definition → 303 to `/admin/integrations/custom-acme-billing?defined=1`.
2. SQL: exactly one `integration_custom_tiles` row, `tenant_id` = the admin's, `tile_id` `custom-acme-billing`, `revision` 1, `definition->>'name'` `Acme Billing`, the server's URL, the parameter and the sign-in as posted; one `audit_records` row `integration.custom.create` for that tenant whose JSON has no URL, header or example.
3. The grid shows a card `data-integration="custom-acme-billing"` with the name, `Custom`, the parameter label and `token` sign-in per tool; the configure page shows `name="param.region"`. A second definition with a command (`npx`, `-y`, `@acme/billing-mcp@1.4.2`, env `ACME_OPS_TOKEN=${ACME_OPS_TOKEN}`) also saves.
4. Failures: the other company's admin sees no such card, gets 404 on the configure page, the edit page, an edit POST and a configure POST, and no row or audit record of theirs appears; that admin can define their own `Acme Billing` (two rows, two tenants, each company sees its own). A member gets 403 on the form and the POST; signed out gets 302 to sign-in; a wrong CSRF token gets 403; posting the same name again gets 409. After each refusal the row and audit counts are unchanged.

Test for criterion 2 (`TestCustomIntegrationAC2ConfigurePackSyncLikePredefinedWithPostgres`), GitHub (`github-com`) as the control at every step:
1. Define the custom tile. Configure both through `POST /admin/integrations/<id>` (`postIntegration`): GitHub with no parameter, custom with `param.region=eu-west` → 303 each; both have one `integration_configurations` row (`item_name` `integration-github` and `integration-custom-acme-billing`) and an `integration.configure` audit record each.
2. Failure, same for both: an invalid setting (`param.region=bad value!` for custom; an unknown parameter for GitHub) → 400, no new revision.
3. Both appear in `/admin/library?category=integrations` as selectable `Configured integration` entries. Build one pack with both ids through the pack builder's preview and confirmation (`confirmPackForm`), assign it as the team default.
4. The member engineer (never the admin token) syncs: the bundle is `assigned`, its content has exactly the two items with the saved bodies.
5. Rendered with `syncedFiles` for Claude Code, Codex and Cursor: each file holds the `github` server and the `custom-acme-billing` server; the custom one has URL `https://mcp.acme.example/eu-west/mcp` and the credential by reference (`Bearer ${ACME_BILLING_TOKEN}`, Cursor `${env:…}`, Codex `bearer_token_env_var`); no file holds a literal token.
6. Failures, same for both: the other company's admin posting either configuration id to their pack builder is refused and creates no pack; an engineer outside the team gets no bundle for the project.

Test for criterion 3 (`TestCustomIntegrationAC3InvalidDefinitionBlockedWithPostgres`), a table over the valid definition with one defect each; every case asserts status 400, a message substring inside `#custom-error`, no `integration_custom_tiles` row, no `integration.custom.%` audit row, and for secret cases that the response does not contain the fake secret and comes back with empty fields:
- secrets: user:password in the URL; `?api_key=<fake>` in the URL; a header `X-Acme: <fake token>`; `Authorization: Bearer <fake>`; an argument `--token <fake>`; an env line `ACME_BILLING_TOKEN=<fake>`; a parameter example that is a fake token → the secret message.
- malformed URL: `http://…`; `https://` alone; a URL with a space → a message containing `https://`.
- malformed command: `bash`; `npx` with `@acme/billing-mcp` (no version); a command with a space; env `PATH=/tmp/x` → a message containing `reviewed launcher`, `exact version` or the env key's reason.
- others: a parameter never used; a shipped tile's token variable; `${OTHER}` no sign-in declares.
- control: the unchanged valid definition → 303 and one row.

Supporting tests are named in Tasks 2, 4, 5 and 7. Regression: the existing integration tests (`TestIntegrations*`, `TestPredefinedTiles*`, `TestIntegrationGovernance*`, `TestConfigurationService*`, `TestShippedTilesPassTheGate`, `TestTilesGateNamesVariantAndTool`, `TestTileVettingIsDocumented`) must pass unedited.

## DoD

- Unit + integration tests, happy path and failures per criterion (above); Postgres-backed tests run, none skipped for a missing database.
- OpenAPI: not touched (no API change); `make contracts-check` green and the diff has no contract path.
- Migration 32 with its down file, in the round-trip and reset lists; PR text notes: additive table, rollback = run the down file before starting an older binary.
- lint, format, vet, govulncheck, gitleaks, library check and build green through `make check`; module-add and release tests green.
- Demoable in isolation: the browser evidence run and the screenshots.
- Module README note and `delivery/stories.json` entry.
- No `.github/workflows/*` change, no auth bypass, no change to `toolconnector.Connector` (client) or repo-wide patterns.

## Docs & records

Build (builder, in the story's commits):
- `internal/integration/README.md`: a new section "Custom integrations (86bcm928e)": what a custom tile is, where it is stored, the form, the checks S1–S7, the launcher rule and why, the two sign-in methods and `${NAME}`, edit behaviour, limits (no delete, shipped-only desktop tile list), the test names.
- `internal/audit/README.md`: `integration.custom.create` and `integration.custom.update`, their target and fields.
- `delivery/stories.json`: append, as text, after the last entry: `"86bcm928e": { "name": "Custom integrations defined by the admin", "prs": { "LeornaAI/leorna-control-plane": [] } }`; check every earlier entry is unchanged by value.
Finish (finisher):
- The approved plan copy `~/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md` (made by the main session at "go"; never edited).
- `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`: a dated status line for 86bcm928e (branch, head, base, review/verifier/auditor results, not pushed); lessons-only edits elsewhere.
- Hand-over drafts in `~/.hermes/plans/leorna/evidence/86bcm928e/handover/`: PR text (with security, migration and rollback notes, and the Assumptions and follow-ups below), review prompt, ClickUp evidence draft (posted only after merge and "post"), team message; `follow-ups.md`.
- After "make a PR": the PR number into `delivery/stories.json` in one small commit (pushed only when Justin says).

## Risks

- The definition form is the biggest new surface (about 20 fields, no JavaScript); parsing mistakes show up as review findings. Mitigation: the rules table, one test row per rule.
- `gate.Run` and the extra scan start gitleaks twice per definition save (and once more per custom configure): about a second on this machine; acceptable for an admin action.
- Reusing gate reasons as messages ties the wording to `policy.go`; tests assert short substrings only.
- The tile id comes from the first name and never changes; a renamed tile keeps its old id and item name.
- Migration 32 could be taken by another story first → renumber.
- High machine load can time out Postgres tests; rerun alone before judging.

## Follow-ups (named, not built)

- Delete or retire a custom integration (question 3), including what its packs do.
- "No sign-in" for open internal servers (question 2).
- Show the company's custom tiles in the desktop app's tile list once client 86bcm928h is merged (question 4).
- Other launchers (`uvx`, a signed company binary) through the gate policy.
- A second-admin approval for command integrations.
- Apply the launcher policy to MCP items an admin writes in the item editor (see Other things found).

## Other things found (not fixed, not folded in)

1. **Medium (security hardening).** MCP template items an admin writes or edits outside the Integrations page are checked by `gate.CheckTenantItem` (`internal/library/gate/tenant.go:40-116`: render, format, secret scan), which does not run the template policy (`checkPolicy`, `policy.go:262`). The item builder calls it at `internal/itembuilder/builder.go:87`, `:163`, `:215`. So such an item can carry a stdio command the shipped library and this story's custom tiles would refuse. Read from the code, not run.
2. **Low (host).** `leorna-test-pg` has been `Exited (255)` for 10 days and about 18 other stopped story containers remain (`nf8-pg`, `pma-ndx6-*`, `ndx6-*`, `leorna-86bccndx6-*`…). Recent stories ran their own containers; `references/gates.md` in the `leorna` skill still says `make check` needs `leorna-test-pg`.
3. **Info.** The main checkout's `main` is at `d9c6aa8`, 4 commits behind GitHub `4ef14ef`.

## Completion contract

Builder done = the three criterion tests and every supporting test pass on one committed head; gates logged for that head; one checked screenshot per criterion; docs and `stories.json` updated; nothing pushed or posted; the report names anything not run as **not run**. Then review → fix until clean, verifier, blind auditor, `ac-check.sh --reviews`, hand-over (main session).

## Probe results (planner, base `4ef14ef`, real gitleaks; the builder's Task 1 and 5 re-prove them)

| Shape | Outcome on base code |
| --- | --- |
| URL + token header `Bearer ${VAR}`; URL + OAuth; URL with a text parameter in the path; `npx -y @acme/billing-mcp@1.4.2` + env token; `docker run -i --rm -e VAR registry/img@sha256:…` | pass `Tile.Validate` and `gate.Run`; rendered for claude-code, codex, cursor |
| URL `{{server}}/mcp` (parameter as the whole origin) | `Validate`: url must start with https:// (so the form says the same) |
| header `Authorization: Bearer <literal>`; env `ACME_BILLING_TOKEN=<literal>` | `Validate`: must reference a credential, not hold one |
| header `X-Acme: <fake GitHub token>`; bare token argument; token as a parameter example | gate secrets stage: `secret rule github-pat` in `body.md` and each tool's output |
| URL `https://admin:pw@host/mcp`; `https://`; URL with a space | render: does not render to an https URL |
| URL `…?api_key=…` | policy: url holds a credential (a credential query parameter) |
| command `bash`, `/usr/local/bin/acme-mcp` | policy: command is not npx; only npx with an exact package version, or docker run with an image pinned by digest, is a reviewed launcher |
| `npx -y @acme/billing-mcp` | policy: args[1] is not an npm package at an exact version |
| `--token <value>` | policy: args[3] holds a credential (the value of a credential option) |
| env `PATH=/tmp/x` | policy: env "PATH" changes where programs are found |
| unused parameter; `${OTHER_TOKEN}` not declared | `Validate`: parameter is never used; references ${OTHER_TOKEN}, which no sign-in declares |
