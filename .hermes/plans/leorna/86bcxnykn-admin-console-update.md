# 86bcxnykn: Update the control plane in place from the admin console (with rollback)

Repo: `leorna-control-plane` only. Pipeline: Full. Size L. Plan written 2026-11-10 by the planner (Fable 5.2 high). Nothing is built yet.
Card: [Update the control plane in place from the admin console (with rollback)](https://app.clickup.com/t/86bcxnykn)

## Questions (answer before "go"; the plan is written as if every ⭐ option is chosen)

**Q1. Leorna's GitHub repo is private, so a customer's server can't read its Releases without a token (anonymous call answers 404). What should this story do?**
- A ⭐ Read GitHub Releases, with an optional read-only token setting. Works on your dev server now; customers need the releases made public later (follow-up card).
- B Also publish a small public manifest with each release. Needs a CI workflow change (Yan's pipeline, and a CI exception from you).
- C Discover versions from the public image registry instead. Needs no token, but there are no release notes, so card AC1 isn't fully met.

**Q2. The running server has no Scaleway key that may redeploy its own container. Where does that key come from?**
- A ⭐ The installer mints a Containers-only key and passes it (new installs, and existing ones after one `resume`). Built in this story.
- B Server side only now; you set the key on the container by hand. Installer change becomes a follow-up card.
- C Reuse the installer's wide deploy key (5 permission sets). Not recommended.

**Q3. If the failed version already changed the database, the previous version refuses to start on it (`migrate.go:298`). What should rollback do then?**
- A ⭐ Don't redeploy the old image. Say why in the console; the admin fixes forward. No data risk.
- B Let the previous version start on the newer schema. Needs additive-only migrations and a change to the migration guard (repo-wide pattern).
- C Run the failed version's down migrations, then redeploy. The card says forward-only.

**Q4. The card's Verify needs your real Scaleway dev server (proposed AC5, live). When and how do you want to run it?**
- A ⭐ Before the PR, after the reviews: two locally built images plus a small test feed, following the README runbook.
- B After merge, once two real stable tags exist (the story stays "live acceptance pending" until then).
- C Drop the live check and accept the agent-run checks only.

## Playback

You asked me to plan ClickUp story 86bcxnykn. The admin console should show when a newer stable Leorna release exists, with its release notes, and let an admin update with one click. The control plane then redeploys itself to that release's image digest and runs its forward-only migrations. If the new version fails its health check, the previous digest comes back automatically and the admin sees why. Every update and rollback is audited. Delivery is a pull the admin approves, in the customer's own Scaleway account.

## Acceptance criteria

The first four are the card's, unchanged in meaning. The fifth is **proposed** (the card's Verify step, which only Justin's real server can prove).

- AC1: Given a newer stable release, then the admin console shows the version and its release notes, and only admins see the update action. Test: `TestControlPlaneUpdateAC1OfferWithPostgres`
- AC2: Given the admin approves, then the control plane redeploys itself to that release's image digest, runs its forward-only migrations, and the console shows the new version when it is back. Test: `TestControlPlaneUpdateAC2RedeployWithPostgres`
- AC3: Given the new version fails its health check, then the previous digest is redeployed automatically and the admin sees why. Test: `TestControlPlaneUpdateAC3RollbackWithPostgres`
- AC4: Given every update or rollback, then an audit event records who, from which version, to which version, and the result. Test: `TestControlPlaneUpdateAC4AuditWithPostgres`
- AC5 (proposed) (live): On Justin's dev Scaleway server, an update from vX to vX+1 from the console succeeds and shows vX+1; then a failing release is rolled back automatically, the console shows why, and Change history holds the update and rollback events. Runbook: "Live check" in `internal/update/README.md`.

All four agent-run tests live in `internal/web`, run against real Postgres, a fake release feed (httptest) and a fake Scaleway Containers API (httptest). Command for each: `go test ./internal/web -run '^<TestName>$' -count=1 -v` with `LEORNA_TEST_DATABASE_URL` set. On the base commit each fails to build (`undefined: update…`), which counts as failing there.

## Base and facts checked (2026-11-10)

- **Base SHA: `4ef14efb46da789aec30fad1e5a988d8770140e2`** (GitHub `main`, 2026-11-10T07:54:26Z, read with `gh api`; local `origin/main` is the same SHA; the main checkout's local `main` is 4 behind at `d9c6aa8` and was not moved).
- **What the release pipeline (86bcm9033) shipped** (`.github/workflows/ci.yml`, `scripts/release.py`):
  - Tags `vX.Y.Z` are the **stable** channel and `vX.Y.Z-rc.N` the **beta** channel (`release.py:16`, `classify`). There is no edge tag; `main` pushes publish `:latest` and `:<sha>`.
  - Images: `ghcr.io/leornaai/control-plane:<tag>`, aliased from the digest the tag's CI run built (`release.py image-alias`; a version tag is never moved).
  - The GitHub Release body is generated and **names the digest** on one fixed line (`release.py:131`): ``Control-plane image: `ghcr.io/leornaai/control-plane:{tag}` (`{digest}`)``. Beta releases are marked prerelease (`release.py publish`).
  - Assets: the Windows installer, its `.sha256`, `leorna-portal-dist-<tag>.tar.gz` (its `manifest.json` also holds `ref@digest`) and its `.sha256`. There is **no** standalone machine-readable manifest.
  - Only one release exists: `v0.2.0-rc.1` (prerelease). **No stable release exists yet.**
- **The repo is private.** `curl https://api.github.com/repos/LeornaAI/leorna-control-plane/releases/latest` → 404 without a token. **The image is public:** an anonymous GHCR token lists the tags and `HEAD …/manifests/v0.2.0-rc.1` returns the same digest the release notes name.
- **The installer's redeploy** (`internal/installer/scaleway/container.go:138`, `redeployExisting`): Scaleway Serverless Containers API, `UpdateContainer` (image + env + secret env) → wait until settled → `RedeployContainer` → wait for `ready`. It runs on the admin's laptop with the wide deploy key (`internal/launcher/deploy.go:13`, 5 permission sets).
- **The running server has no key that can touch its container.** It gets only DB/Mongo/ClickHouse secrets, the encryption key, an RDB-only bootstrap key and an optional read-only IAM directory key (`internal/installer/orchestrator/steps.go:157-173`).
- **Scaleway keeps the old version serving after a failed deployment, for up to 24 hours, and has no rollback of its own** (Scaleway docs, "Containers limitations → Versioning and rollback", read from `scaleway/docs-content`). So the old process is alive to notice a failure and redeploy the previous digest.
- **The image doesn't know its version.** `Containerfile:15` builds with `-ldflags="-s -w -buildid="` and `.dockerignore` drops `.git`. CI passes no version build arg.
- **Migrations run at startup** (`cmd/control-plane/main.go:93`, `postgres.ApplyMigrations`), forward only (`RollbackMigrations` is "never startup", `migrate.go:109`). A binary **refuses to start** when the database has a migration it doesn't know (`migrate.go:282-298`: "applied migration N is missing from embedded migrations").
- **Health:** `GET /healthz` (always ok) and `GET /readyz` (ready flag + Postgres/ClickHouse/Mongo pings) on the app's port (`internal/health/handler.go`, `internal/adapters/httpops/server.go`).
- **Audit:** one path. Store methods call `appendAudit` inside their own transaction (`internal/store/postgres/audit.go:13`); records are immutable; `GET /admin/audit` and `GET /v1/audit` read them, admin only.
- **Admin console:** every `/admin/*` page and write is behind `requireSession` + `requireAdmin` (`internal/web/handler.go:240-352`, `roles.go:10`); stores recheck the admin role in the write transaction (`beginOrg`, `teams.go:31`). Markdown is rendered safely by `library.RenderMarkdown` (`internal/library/preview.go:45`: goldmark without `WithUnsafe`, under the admin CSP `default-src 'none'`).
- **Next migration number: `000032`** (main ends at `000031_cost_alert_refresh`; no unmerged branch adds a migration).
- **Host (Windows desktop, WSL):** `make`, `gcc` (cgo on), `docker`, `gitleaks` 8.30.1 and `python3` are on PATH. Go 1.27.3, golangci-lint 2.14.0 and govulncheck are installed **off PATH** under `~/.local/leorna-tools/` (CI pins the same versions). Chrome for Testing is at `~/.cache/chrome-for-testing/chrome-linux64/chrome`. `leorna-test-pg` exists but is stopped; port 5432 belongs to `leorna-pg` (not ours). `tofu` is not on PATH (copies in `~/.cache/86bccndx6-*/bin/tofu`). Helm and Trivy are absent (CI only). Nothing is missing that needs Justin; the builder binds the tools by absolute path and runs its own Postgres container.

## Approach

### 1. Who performs the redeploy, and what survives the restart

The **running control plane** calls the Scaleway Containers API itself, with a dedicated key. The work is a small state machine stored in Postgres, advanced by a reconciler loop that runs in every control-plane process. No step depends on one process staying alive:

- The admin's click writes one row in a new table `control_plane_updates` (who, from version and image, to version and image, the database schema version before the update, status). Nothing has been sent to Scaleway yet.
- The reconciler (a goroutine started in `main.go`, like the cost-alert runners at `main.go:288`) takes the row with `SELECT … FOR UPDATE SKIP LOCKED`, makes at most one Scaleway call, and writes the new status and its audit record in the same transaction. If the process dies, the lock goes with its connection and the next process continues from the saved status.
- The update sets the image **by digest** and three plain (non-secret) environment values in the same `UpdateContainer` call: `LEORNA_RELEASE_VERSION`, `LEORNA_RELEASE_IMAGE` and `LEORNA_UPDATE_ID`. Environment values belong to a container revision, so the new version's process sees the new values and the old process keeps its own. That is how a process knows "I am the version this update was waiting for" without a build-time version stamp.
- The **previous image** (exactly as Scaleway reported it before the update) and the previous version are in the row, so a rollback works after the process that started the update is gone.
- The **new version confirms itself**: when its own readiness check passes and its environment names this update, it marks the row `succeeded`. The **old version** (which Scaleway keeps serving while a deployment fails) or any other live process handles failure: Scaleway says `error`, or nobody confirmed before the deadline.

**Why not call `redeployExisting`:** it is unexported, needs a full `ContainerSpec` including every secret (the server must not resend secrets it can't read back), re-verifies the custom domain, and blocks in `WaitForContainer`. The new adapter follows the same proven call order (update → settled → redeploy) with the image and plain env only; secret env is left out of the request, so Scaleway keeps it unchanged.

**Security boundary**
- The key: `ContainersFullAccess` on the install's one Scaleway project (Scaleway has no per-container scope). It arrives as secret env `LEORNA_SCW_UPDATE_ACCESS_KEY` / `LEORNA_SCW_UPDATE_SECRET_KEY`, with `LEORNA_SCW_UPDATE_PROJECT_ID` and `LEORNA_SCW_UPDATE_REGION`. It is never logged, stored in Postgres, put in an audit record, or sent to the browser. Without it the console still shows releases, with the update action off and the sentence "In-place update isn't set up on this server. Run the installer's resume once to enable it."
- The server finds its own container by the installer's fixed names (namespace `leorna`, container `control-plane`) and **proves it is itself** before any write: the container's `LEORNA_PUBLIC_BASE_URL` must equal this server's own configured public URL. Otherwise it refuses.
- Only admins can start an update, enforced on the server three times: the route guard (`requireSession` + `requireAdmin`), the CSRF check, and the store's own admin recheck inside the write transaction (`beginOrg(write)`). The update is deployment-wide, so the admin must also belong to the deployment's own company (the configured `LEORNA_CLIENT_TENANT_ID`, else the sole tenant); another tenant's admin gets 403.
- The browser sends only a version string. The server compares it with the release it cached itself and builds the image reference from its own configured repository plus the digest it read. A request can never supply an image, a digest or a tag.
- The database refuses a target that isn't a digest (`CHECK (to_image ~ '@sha256:[0-9a-f]{64}$')`), and a partial unique index allows one update in flight for the whole deployment.

### 2. Release discovery

- Source: the GitHub Releases API shape, from `LEORNA_UPDATE_FEED_URL` (default `https://api.github.com/repos/LeornaAI/leorna-control-plane/releases?per_page=30`). Optional `LEORNA_UPDATE_FEED_TOKEN` is sent as a Bearer header to that URL only. HTTPS is required; redirects are not followed; the body is capped at 1 MiB and the call at 10 s.
- A release counts only when `draft` is false, `prerelease` is false and `tag_name` matches `^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$` (the stable half of `release.py`'s tag rule). So `-rc.N` betas, `portal-dist` and drafts are ignored twice over (flag and pattern).
- The digest comes from the generated notes line, which must appear exactly once, name the same tag, and carry `sha256:` plus 64 hex characters. A release without it is shown as "can't be installed from here" with no update action. The image deployed is `<repository>@<digest>`, never a tag. `<repository>` is `LEORNA_UPDATE_IMAGE_REPOSITORY`, default `ghcr.io/leornaai/control-plane`.
- "Newer" means a higher version than the running one. When the running version is unknown (installs made before this story), the newest stable release is offered unless the container already runs its digest.
- Caching: the newest good answer is kept in memory for 6 hours; the reconciler refreshes it in the background, so page views never wait on GitHub. After a failure it retries in 15 minutes (or after `Retry-After` / `X-RateLimit-Reset`, at most 6 hours). The page keeps showing the last good answer with "Last checked …", or, if there never was one, a plain reason (not readable without a token, rate limited, unreachable). A "Check now" button (admin, CSRF, at most once a minute) forces a refresh.
- Tests use `httptest` servers only. No test calls GitHub.
- A Go test pins the notes-line format against `scripts/release.py` itself (it reads the script and requires the exact format string), so a change to the release notes can't silently break discovery.

### 3. Health check and rollback trigger

- **Healthy** means: before the deadline, a process whose environment names this update (`LEORNA_UPDATE_ID` and `LEORNA_RELEASE_IMAGE`) passes the same check `/readyz` answers with (ready flag plus Postgres, ClickHouse and Mongo pings), and records `succeeded`. That process has already run its migrations, because `main.go` applies them before it starts serving or reconciling.
- **Failed** means: Scaleway reports the container in `error` after the redeploy (image can't be pulled, crash at startup, port never opens), **or** the deadline passes with no confirmation. The deadline is `LEORNA_UPDATE_HEALTH_TIMEOUT` after the update is configured (default 10 minutes, allowed 1 to 30).
- **Who notices:** whichever process is alive. Normally that is the old version, which Scaleway keeps serving while the new deployment fails. If the new version did start but never becomes ready, it reaches the deadline itself and rolls itself back.
- **Rollback:** the same two calls with the previous image and the previous three environment values. The restored version confirms itself the same way (`rolled_back`). If Scaleway reports `error` or the rollback deadline passes, the row ends `rollback_failed` and the page says to run the installer's resume.
- **The admin sees why** on `/admin/updates` and in a banner on `/admin`: the attempt's status sentence and its reason. The reason is Scaleway's own error message (cleaned: control characters removed, at most 500 characters, HTML-escaped by the template) or "The new version did not report healthy within 10 minutes."
- Not in this story: setting a Scaleway startup probe on `/readyz`. It would hold traffic on the old version until the new one is ready, but its live behaviour is unproven and it would change the container's probe settings. It is listed as a follow-up.

### 4. Forward-only migrations and rollback (a real risk, Q3)

- The new version migrates at startup, in one transaction. A failure before or during migration leaves the schema unchanged, and the old image starts fine. **This is the case the automatic rollback covers.**
- A failure **after** the new version's migrations committed leaves a schema the old image refuses to start on (`migrate.go:298`). Redeploying the old image would trade one failure for another. So the row records the schema version before the update (`from_schema_version`), and at failure time the reconciler compares it with the database:
  - unchanged → roll back to the previous digest;
  - advanced → **no redeploy**; status `rollback_blocked`, with the reason "version X already changed the database (schema A → B); the previous version can't start on it", an audit record with result `blocked`, and README steps for the admin (retry the same update, update to a fixed release, or the installer's resume). Scaleway keeps the old revision serving for up to 24 hours, so the console stays reachable to show this.
- No down migration ever runs outside tests.

### 5. Audit

The existing change-history path, nothing new: the three store methods that change an update row call `appendAudit` in the same transaction, with the admin who started the update as actor (kept on the row, as cloud connections do for work that finishes later) and target `controlplane.update/<update id>`.

| Action | When | before | after |
|---|---|---|---|
| `controlplane.update.request` | the admin's click is accepted | `{"version": from, "image": from image}` | `{"version": to, "image": to image, "result": "requested"}` |
| `controlplane.update` | the update ends | `{"version": from, "image": from image}` | `{"version": to, "image": to image, "result": "succeeded" or "failed", "reason": …}` |
| `controlplane.rollback` | the rollback ends | `{"version": to, "image": to image}` | `{"version": from, "image": from image, "result": "succeeded", "failed" or "blocked", "reason": …}` |

A failed audit insert rolls the status change back, as everywhere else. Records hold versions, image references, result and reason: no keys, tokens or environment values.

### 6. Admin console UI

- New page `GET /admin/updates` ("Updates"), linked from the admin home's link row, and a banner section `#update-banner` on `/admin` when a newer release exists, an update is running, or the last attempt failed.
- The page shows: current version (`#update-current`); the newest stable release with its date and notes (`#update-available`, notes in `#update-notes` through `library.RenderMarkdown`, so raw HTML and script URLs are dropped and the CSP blocks images); the form `#update-form` (hidden `csrfToken` and `version`, button "Update to vX.Y.Z"); or `#update-unavailable` with the reason; progress while an update runs (`#update-progress`, with a 5-second meta refresh); the last attempt (`#update-last`, reason in `#update-reason`); the last 10 attempts (`#update-history`); and "Check now" (`#update-check-form`).
- Writes: `POST /admin/updates` (start, form), `POST /admin/updates/check` (refresh). JSON twins for the contract: `GET /v1/control-plane/update` and `POST /v1/control-plane/updates`.
- There is no non-admin console: a member gets 403 `ADMIN_REQUIRED` on every one of these routes, so "only admins see the update action" is enforced on the server, not by hiding a button.

### 7. Demoable in isolation, and the card's Verify

- Agent-run: the four AC tests, plus an opt-in browser journey (`TestControlPlaneUpdateBrowserJourneyWithPostgres`) that drives the real handler, real Postgres, the fake feed and the fake Scaleway API through headless Chrome and writes the AC screenshots. The restart is simulated in-process (a second reconciler with the new revision's identity); the screenshots are labelled as a local run with a fake Scaleway API.
- Live (AC5, Justin): a real Scaleway redeploy, a real restart and a real failed deployment. The README runbook gives the steps for Q4's option A. No server domain, URL or tenant ID goes into any file that leaves the machine.

## Data model: migration `000032_control_plane_updates`

`internal/store/postgres/migrations/000032_control_plane_updates.up.sql`

```sql
CREATE TABLE control_plane_updates (
 id uuid PRIMARY KEY,
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
 requested_by uuid NOT NULL,
 from_version text NOT NULL,
 from_image text NOT NULL,
 from_schema_version bigint NOT NULL,
 to_version text NOT NULL,
 to_image text NOT NULL CHECK (to_image ~ '^[a-z0-9][a-z0-9./_-]*(:[0-9]+)?(/[a-z0-9][a-z0-9._-]*)+@sha256:[0-9a-f]{64}$'),
 to_schema_version bigint,
 status text NOT NULL CHECK (status IN ('requested','deploying','succeeded','failed','rolling_back','rolled_back','rollback_failed','rollback_blocked')),
 step text NOT NULL DEFAULT 'pending' CHECK (step IN ('pending','configured','redeployed')),
 reason text NOT NULL DEFAULT '' CHECK (char_length(reason) <= 500),
 requested_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 deadline timestamptz,
 finished_at timestamptz
);
CREATE UNIQUE INDEX control_plane_updates_one_active ON control_plane_updates ((true)) WHERE status IN ('requested','deploying','rolling_back');
CREATE INDEX control_plane_updates_recent_idx ON control_plane_updates (requested_at DESC, id);
```

`…000032_control_plane_updates.down.sql`: `DROP TABLE control_plane_updates;`

Additive only: one new table and no change to existing rows or tables. Rollback note for the PR: a release without this migration still refuses to start on a database that has it (the guard at `migrate.go:298`), so going back past this story needs the down file run first, like every earlier migration. Add the table to both lists in `TestMigrationRoundTrip` and to `resetDatabase`'s drop list (`store_test.go:34`, `:499`), first in the drop list.

## Interfaces (new package `internal/update`)

```go
// Identity is what this process is, read once from the environment at startup.
type Identity struct {
	Version  string // LEORNA_RELEASE_VERSION when it is a stable or beta tag, else ""
	Image    string // LEORNA_RELEASE_IMAGE
	UpdateID string // LEORNA_UPDATE_ID when it is a UUID, else ""
}

// Release is one installable stable release.
type Release struct {
	Version     string    // "v0.3.0"
	Digest      string    // "sha256:<64 hex>"
	Notes       string    // Markdown, at most 64 KiB
	URL         string    // the release page, shown as text
	PublishedAt time.Time
}

// Source returns the stable releases a feed lists, newest version first.
type Source interface {
	Stable(ctx context.Context) ([]Release, error)
}

// ContainerState is this server's own container as Scaleway reports it.
type ContainerState struct {
	ID, Image, Status, ErrorMessage string
	Env                             map[string]string
}

// Deployer changes this server's own container. No method waits for a deployment.
type Deployer interface {
	Current(ctx context.Context) (ContainerState, error)
	Configure(ctx context.Context, containerID, image string, env map[string]string) error
	Redeploy(ctx context.Context, containerID string) error
}

// Store is implemented by *postgres.Store.
type Store interface {
	StartControlPlaneUpdate(ctx context.Context, actor store.Principal, in NewUpdate) (Update, error)
	AdvanceControlPlaneUpdate(ctx context.Context, decide func(Update) (Transition, error)) (bool, error)
	ListControlPlaneUpdates(ctx context.Context, actor store.Principal, limit int) ([]Update, error)
	SchemaVersion(ctx context.Context) (int64, error)
}
```

- `Update` mirrors the table row. `NewUpdate` holds from/to version and image and `FromSchemaVersion`. `Transition` holds the new `Status`, `Step`, `Reason`, `Deadline`, `ToSchemaVersion` and a list of audit events (`Action`, `Before`, `After`); the zero value means "no change this tick".
- `StartControlPlaneUpdate`: `beginOrg(ctx, actor, true)` (admin recheck), insert the row as `requested`/`pending`, `appendAudit` the request record, commit. A unique-index hit (`23505` on `control_plane_updates_one_active`) returns `update.ErrInProgress`.
- `AdvanceControlPlaneUpdate`: one transaction: `SELECT … WHERE status IN ('requested','deploying','rolling_back') FOR UPDATE SKIP LOCKED`; no row → `false`. Else call `decide`, apply the transition and its audit events with the row's own `tenant_id` and `requested_by` as actor, set `finished_at` on a final status, commit. `decide` runs with a 30-second context.
- `ListControlPlaneUpdates`: `beginOrg(ctx, actor, false)` and require admin; newest first; limit 1 to 50.
- `SchemaVersion`: `SELECT COALESCE(max(version),0) FROM schema_migrations`.
- `Service` (constructed in `main.go`): `Status(ctx, actor) (Status, error)`, `Start(ctx, actor, version string) (Update, error)`, `CheckNow(ctx) error`. Errors: `ErrNotConfigured`, `ErrNoRelease`, `ErrVersionMismatch`, `ErrInProgress`, `ErrNotOwner`, `ErrUnknownContainer`, `ErrContainerBusy`.
- `Service.Start` order: owner-tenant check → version equals the cached offer → `Deployer.Current` → identity proof (`Env["LEORNA_PUBLIC_BASE_URL"]` equals the configured public URL) → container `ready` → `Store.SchemaVersion` → `StartControlPlaneUpdate` with `from_image = Current().Image` and `from_version = Identity.Version` only when `Identity.Image == Current().Image`, else `""`.
- `Reconciler{Store, Deployer, Identity, Ready func(context.Context) error, Now func() time.Time, HealthTimeout, Source cache, Logger}` with `Tick(ctx) error` and `Run(ctx)` (5 s between ticks while a row is active, 60 s otherwise; refreshes the release cache when stale). `Tick` is what tests call; `Run` only loops.
- Scaleway adapter `NewScalewayDeployer(cfg ScalewayConfig, opts ...scw.ClientOption)`: `Current` lists the namespace `leorna` and the container `control-plane` in the configured project and region; `Configure` is `UpdateContainer` whose PATCH body is exactly `{"image": …, "environment_variables": {…}}`: the pinned SDK also serialises zero-value `privacy`, `protocol` and `sandbox`, so replace the request body with a hand-built one, the way the custom-domain code does (`internal/installer/scaleway/domain.go:357-367`); `Redeploy` is `RedeployContainer`. Tests pass `scw.WithAPIURL(fake.URL)` (the pattern in `internal/installer/scaleway/destroy_test.go:95`). Errors returned to callers are cleaned by one function `cleanReason(string) string` (strip control characters, cap 500).
- `internal/health`: add `func (state *State) Check(ctx context.Context) error`, nil exactly when `/readyz` would answer 200; the `/readyz` handler calls it. The reconciler's `Ready` is that method.

## State machine (`Reconciler.Tick`, row locked; `c` is `Deployer.Current()`, "settled" is status `ready` or `error`, "target" is `Identity.UpdateID == row.id && Identity.Image == row.to_image`, "restored" is `Identity.UpdateID == row.id && Identity.Image == row.from_image`)

| Row | Condition | Action | Next |
|---|---|---|---|
| requested / pending | `Current` fails | nothing; after 5 minutes: audit update `failed` | same, then `failed` |
| requested / pending | `c` not settled | wait | same |
| requested / pending | `c.Image != from_image` | audit update `failed` ("the container changed after the update was requested") | `failed` |
| requested / pending | otherwise | `Configure(c.ID, to_image, env + the 3 values)`; on error: audit update `failed`, nothing changed | `deploying` / `configured`, deadline = now + timeout; or `failed` |
| deploying / any | target and `Ready()` is nil | audit update `succeeded`; `to_schema_version` = schema version | `succeeded` |
| deploying / configured | `c` settled | `Redeploy(c.ID)`; on error: begin rollback | `deploying` / `redeployed` |
| deploying / redeployed | `c.Status == error` | begin rollback, reason "Scaleway reported: " + message | see below |
| deploying / any | now > deadline | begin rollback, reason "The new version did not report healthy within N minutes." | see below |
| begin rollback | schema version > `from_schema_version` | audit update `failed`; audit rollback `blocked` | `rollback_blocked` |
| begin rollback | otherwise | audit update `failed` | `rolling_back` / `pending`, deadline = now + timeout |
| rolling_back / any | restored and `Ready()` is nil | audit rollback `succeeded` | `rolled_back` |
| rolling_back / pending | `c` settled | `Configure(c.ID, from_image, env + previous 3 values)`; errors retry until the deadline | `rolling_back` / `configured` |
| rolling_back / configured | `c` settled | `Redeploy(c.ID)` | `rolling_back` / `redeployed` |
| rolling_back / redeployed | `c.Status == error`, or now > deadline (any step) | audit rollback `failed` | `rollback_failed` |

"env + the 3 values" copies every existing plain environment value (so the public URL, custom-domain and dev settings survive) and sets `LEORNA_RELEASE_VERSION`, `LEORNA_RELEASE_IMAGE`, `LEORNA_UPDATE_ID`. On rollback `LEORNA_RELEASE_VERSION` is the previous version, or removed when that was unknown. Rows are checked in the order shown; the first match wins.

## OpenAPI (`contracts/control-plane.openapi.yaml`, additive only)

Two operations and five schemas; nothing existing changes, so no client is affected (the client repo's copy already lags and isn't touched).

- `GET /v1/control-plane/update`, `operationId: getControlPlaneUpdate`, `security: sessionCookie`. Responses: 200 `ControlPlaneUpdateStatus`; 401, 403, 500 shared; 503 "Updates are unavailable".
- `POST /v1/control-plane/updates`, `operationId: startControlPlaneUpdate`, `security: sessionCookie`, header `X-CSRF-Token` (required), body `ControlPlaneUpdateRequest`. Responses: 202 `ControlPlaneUpdate`; 400, 401, 403, 409 `Conflict`, 500 shared; 503.
- Schemas:
  - `ControlPlaneUpdateState`: a **named** string enum (multi-line form, like `PackItemKind`): `requested, deploying, succeeded, failed, rolling_back, rolled_back, rollback_failed, rollback_blocked`. Never the inline `{type: string, enum: [...]}` form (`internal/web/contract_kinds_test.go` allows exactly 2 of those).
  - `ControlPlaneRelease`: required `version`, `imageDigest`, `notes`; optional `publishedAt` (date-time), `url`.
  - `ControlPlaneUpdate`: required `id` (uuid), `fromVersion`, `toVersion`, `status` (`$ref` state), `reason`, `requestedAt`; optional `finishedAt`.
  - `ControlPlaneUpdateStatus`: required `currentVersion` (empty when unknown), `canUpdate` (boolean); optional `unavailableReason`, `available` (`$ref` release), `latest` (`$ref` update), `checkedAt`.
  - `ControlPlaneUpdateRequest`: required `version` (string, `maxLength: 32`).
- Regenerate with `make generate`; `make contracts-check` must pass. Add the two stubs to `roundTripServer` (`packages/contracts/roundtrip_test.go`) and the two methods to `*web.Handler`. Spec bounds are documentation only here (no request-validation middleware), so the handler enforces `version` length and pattern itself.

## Tasks (test first; one commit per task, each green; branch `feat/86bcxnykn-admin-console-update`)

**T0. Workspace.** Fetch `main` over HTTPS through gh (the `leorna` skill's command), then create the dedicated worktree `/home/justin/Leorna/86bcxnykn-admin-console-update` on a new branch `feat/86bcxnykn-admin-console-update` from fresh `origin/main` (record the SHA; if it moved past `4ef14ef`, say so in the report). Never touch the main checkout's `main`, `.claude/worktrees/*` or any sibling branch. Scratch goes in `~/.cache/86bcxnykn-builder/` (created with `mkdir`, no `-p`), with `TMPDIR` there, never on `/tmp`. Start an own Postgres container from CI's pinned image (`.github/workflows/ci.yml`) on a free loopback port with database `leorna_86bcxnykn_test`; wait with `docker exec <name> pg_isready -h 127.0.0.1`. Check `uptime` first: the machine was at load 22 during planning.

**T1. Release parsing and version order** (`internal/update/release.go`, `release_test.go`).
- `ParseStable(tag string) (Version, bool)`, `Version.Less`, `DigestFromNotes(tag, body string) (string, error)`, `ReleaseFromGitHub(item githubRelease) (Release, error)`.
- Tests (`TestParseStableAndOrder`, `TestDigestFromNotes`, `TestReleaseFromGitHub`): `v0.10.0 > v0.9.9`; `v1.0.0-rc.1`, `v01.2.3`, `latest`, `portal-dist` rejected; draft and prerelease rejected; digest line missing, repeated, naming another tag, or with a short digest rejected; `DigestFromNotes` reads the digest from the real `v0.2.0-rc.1` body (fixture `testdata/release-v0.2.0-rc.1.json`, copied from `gh release view`), while `ReleaseFromGitHub` refuses that same entry because it is a prerelease; notes over 64 KiB are cut with a marker line.
- `TestReleaseNotesLineMatchesReleaseScript`: reads `../../scripts/release.py` and requires the exact f-string of `release.py:131`.

**T2. Feed client and cache** (`feed.go`, `feed_test.go`). `NewGitHubSource(url, token string, client *http.Client)`; `Cache{Source, Now}` with `Get() (Release, time.Time, error)` and `Refresh(ctx)`.
- Tests with `httptest.NewTLSServer`: newest stable chosen among mixed stable, beta and draft entries; Bearer header sent only when a token is set and never to another host (a redirect to a second server is not followed and that server sees no request); 404 → "not readable without an access token"; 403 with `X-RateLimit-Remaining: 0` and 429 → rate-limited reason and next-check time; body over 1 MiB refused; malformed JSON refused; cache serves the last good answer after a later failure and reports the failure time; no network call inside the TTL (request counter).

**T3. Migration and store** (`migrations/000032_*`, `internal/store/postgres/control_plane_updates.go` + `_test.go`, `migrate.go`, `store_test.go`).
- `migrate.go`: thread an `fs.FS` through `readMigrations`/`readPairedMigrations` (keep today's signatures as wrappers) and export `ApplyMigrationsFS(ctx, pool, files fs.FS) error` and `MigrationFiles() fs.FS`; `ApplyMigrations` calls `ApplyMigrationsFS` with the embedded set. No behaviour change: `TestMigrationRoundTrip` and the existing migration tests stay green unchanged apart from the two table lists.
- Tests (`TestControlPlaneUpdateStoreWithPostgres`): member and other-tenant actor refused by `Start` with no row; a second `Start` while one is active → `ErrInProgress`; a tag image (`…:latest`) refused by the CHECK (SQLSTATE 23514); `Advance` applies status, step, deadline and audit in one transaction, and a forced audit failure (`ALTER TABLE audit_records ADD CONSTRAINT probe CHECK(false) NOT VALID`) rolls the status change back, then succeeds once the constraint is dropped; two concurrent `Advance` calls: the second returns `false` while the first holds the row (use an uncommitted transaction and `waitForLockWait`-style proof that it did **not** wait: `SKIP LOCKED`); `SchemaVersion` equals the newest embedded version; `TestApplyMigrationsFSNextRelease`: embedded set plus a probe pair `000900_update_probe` applies forward, keeps existing rows, and the plain embedded `ApplyMigrations` then fails with "applied migration 900 is missing from embedded migrations".
- Prove the migration on existing rows the `backend-data-migrations` way: fill a throwaway database from the base binary, start head's binary (applies 000032), per-table md5 unchanged, run the down file plus `DELETE FROM schema_migrations WHERE version=32` in one `psql --single-transaction`, start head's again. Keep the log in the evidence folder as `migration-000032-<sha7>.txt`.

**T4. State machine** (`reconciler.go`, `service.go`, `reconciler_test.go`, `service_test.go`) with in-memory fakes of `Store`, `Deployer` and `Source`. One table-driven test row per line of the state machine table above (14 rows), plus: `Start` refuses a version that isn't the cached offer, an unknown container (public URL differs), a busy container, a missing key (`ErrNotConfigured`), a non-owner tenant; env copy keeps unrelated keys and never contains a key starting `LEORNA_SCW_` it didn't read; rollback restores or removes `LEORNA_RELEASE_VERSION`; `Tick` with no active row makes no Scaleway call.

**T5. Scaleway adapter and shared fakes** (`scaleway.go`, `scaleway_test.go`, new helper package `internal/update/updatetest`).
- `updatetest.Scaleway`: a stateful fake of the Containers API (list namespaces, list containers, get, PATCH, POST `/redeploy`) that records calls and lets a test set the container's status and error message; `updatetest.Feed`: a fake Releases endpoint with editable entries. Both are plain `httptest` servers and hold no real data.
- Tests: `Current` finds the container by namespace and name in the configured project; `Configure` sends exactly `image` and `environment_variables` (the recorded PATCH body's key set is those two and nothing else: no `secret_environment_variables`, `privacy`, `protocol` or `sandbox`; the image is `…@sha256:…`); `Redeploy` posts to `/redeploy`; a 403 from the fake becomes a cleaned reason with no key material; the secret key never appears in any returned error (search the error text for the fake key).

**T6. Config and wiring** (`internal/config/runtime.go` + test, `internal/health/handler.go` + test, `cmd/control-plane/main.go`, `.env.example`).
- Config: the settings named in Approach 1 to 3. Rules: feed URL and repository validated (HTTPS URL without credentials; repository `host/path` with no tag or digest); the four `LEORNA_SCW_UPDATE_*` values are all set or all empty, else startup fails with "update credential settings are incomplete"; timeout 1m to 30m. Tests cover each rule and that no value is echoed in an error.
- `main.go`: build `Identity`, the feed cache, the deployer (nil without the key), the service and the reconciler after `SetAudit`; `application.SetControlPlaneUpdates(service, ownerTenant)`; set the reconciler's `Ready` to `readiness.Check` inside the existing `RegisterOperations` callback, and start `go reconciler.Run(ctx)` there. Log one line at startup: version (or "unknown"), whether in-place update is configured. Never log the feed token or key.

**T7. Web: page, forms, API, banner** (`internal/web/control_plane_update.go`, `handler.go`, `contracts/…yaml`, generated code, `roundtrip_test.go`), with the four AC tests in `internal/web/control_plane_update_test.go`. Shared fixture `newUpdateFixture(t)` builds on `newPackFixture` (`packs_test.go:41`), wiring two "processes" over the fixture's one store, `updatetest.Scaleway` and `updatetest.Feed`: the old process (identity `v0.2.0`) and the new revision (identity = the update's ID and target image, built once the update row exists). Each is a real `update.Service`, `update.Reconciler` and `web.Handler` with its own test server; `Ready` and the clock are test-controlled; the fixture admin's tenant is the owner. A third identity (update ID plus the previous image) plays the restored revision in AC3.

- Covers AC1, `TestControlPlaneUpdateAC1OfferWithPostgres`: the feed lists stable `v0.3.0` (notes with a heading, a list, a `<script>` tag and a `javascript:` link), a newer beta `v0.4.0-rc.1` and a draft `v0.5.0`; the server runs `v0.2.0`. Admin `GET /admin/updates` → 200; `#update-current` says `v0.2.0`; `#update-available` names `v0.3.0` and not the beta or draft; `#update-notes` holds the rendered heading and list and neither `<script` nor `javascript:`; `#update-form` has the CSRF token and `version=v0.3.0`. Admin `GET /admin` holds `#update-banner` naming `v0.3.0`. Admin `GET /v1/control-plane/update` → 200 with `available.version == "v0.3.0"` and `canUpdate == true` (decoded, key set checked). Member: `GET /admin/updates`, `GET /v1/control-plane/update`, `POST /admin/updates`, `POST /v1/control-plane/updates` each → 403 `ADMIN_REQUIRED`, zero rows, zero Scaleway calls. Other-tenant admin `POST` → 403, zero rows. No session: page → 302 to sign-in, API → 401. Wrong CSRF → 403 `CSRF_REJECTED`, zero rows. Failure case: with the feed answering 404 the page is 200, shows `#update-unavailable` with the token sentence and has no `#update-form`. Same version as running → "up to date", no form.
- Covers AC2, `TestControlPlaneUpdateAC2RedeployWithPostgres`: admin `POST /admin/updates` (`version=v0.3.0`) → 303 to `/admin/updates`; page shows `#update-progress`. Old-process `Tick` twice: the fake recorded one PATCH whose image is exactly `ghcr.io/leornaai/control-plane@sha256:<the feed's digest>` (no tag anywhere in the body), whose env kept `LEORNA_PUBLIC_BASE_URL` and an unrelated key and added the three values, and one `/redeploy`. Then the test boots "the new release" as the binary would: `postgres.ApplyMigrationsFS` with the embedded set plus probe `000900` (forward-only: every earlier table and the in-flight row still there, `schema_migrations` only grew). New-revision `Tick` with `Ready` nil → row `succeeded`, `to_schema_version == 900`. `GET /admin/updates` served by the new revision's handler shows `#update-current` = `v0.3.0` and the last attempt "Updated from v0.2.0 to v0.3.0". Failure cases in the same test: posting `version=v9.9.9` (not the offer) → 409 and no row; a second click while one is active → 409 and still one PATCH; a new revision whose `Ready` returns an error does **not** mark `succeeded`.
- Covers AC3, `TestControlPlaneUpdateAC3RollbackWithPostgres`, three subtests. (a) "scaleway error": after the redeploy the fake reports `error` with message "container failed to start"; old-process ticks → a second PATCH with the **previous** image exactly as it was before (`…@sha256:<old digest>`) and the previous three values, then a second `/redeploy`; a restored-revision tick → `rolled_back`; the page's `#update-last` says the update failed and the server went back to `v0.2.0`, and `#update-reason` holds "Scaleway reported: container failed to start"; `#update-current` says `v0.2.0`; a message containing `<b>` and a control character is shown escaped and cleaned. (b) "no confirmation": the fake stays `ready`, the clock passes the deadline → the same rollback, reason "did not report healthy within 10 minutes". (c) "database already migrated": the probe migration is applied before the failure → **no** rollback PATCH, row `rollback_blocked`, `#update-reason` names schema `32 → 900` and says the previous version can't start on it; a supporting assertion shows why: `postgres.ApplyMigrations` on that database fails with "applied migration 900 is missing from embedded migrations".
- Covers AC4, `TestControlPlaneUpdateAC4AuditWithPostgres`: after a successful update `ListAudit` (target `controlplane.update/<id>`) returns exactly `controlplane.update.request` and `controlplane.update`; each has actor = the admin's user ID, before `version` `v0.2.0`, after `version` `v0.3.0`, and results `requested` and `succeeded`. After a rolled-back update: request, `controlplane.update` with result `failed` and the reason, and `controlplane.rollback` with before `v0.3.0`, after `v0.2.0`, result `succeeded`. After the blocked case: `controlplane.rollback` with result `blocked`. `GET /admin/audit?target=…` as admin shows the three rows; the member gets 403; the other tenant's `ListAudit` returns none. No record's JSON contains the fake Scaleway key or the feed token. Failure case: with an audit insert forced to fail, the click answers 500 and no update row exists.
- Also in T7: `POST /admin/updates/check` (CSRF, admin, 1 per minute → 429 with `Retry-After` after that); handler unit tests with a fake service for the branches Postgres can't reach (`ErrNotConfigured` → 503 on the API and the "isn't set up" sentence on the page; `ErrUnknownContainer` → 409 with a plain sentence).

**T8. Installer: mint and pass the update key** (Q2 option A; `internal/launcher/reusekey.go` + test, `internal/installer/orchestrator/steps.go` + test, `cmd/launcher/main.go`, plus every place `mint-directory` appears).
- `updateKind = keyKind{prefix: "leorna-update", permissionSets: []string{"ContainersFullAccess"}}` and `NewUpdateMinter()`; project-scoped; reused through the key cache like the others.
- `orchestrator.Secrets` gains `UpdateAccessKey`, `UpdateSecretKey`, `UpdateProjectID`, `UpdateRegion`; `Deps` gains `ReleaseVersion`. `controlPlaneStep` adds the two key values to secret env and the project and region to plain env only when all four are set, and always sets `LEORNA_RELEASE_IMAGE` to the image it deploys, `LEORNA_RELEASE_VERSION` to `ReleaseVersion` or `dev`, and `LEORNA_UPDATE_ID` to `none` (so a resume never leaves stale values from an earlier in-place update).
- `launcher.ReleaseVersionFor(version, imageRef string) string`: the installer's stamped version only when it is a release tag and the image is the installer's own digest-pinned default; else `""`. Table test.
- `cmd/launcher/main.go`: after the directory key, a best-effort "mint-update" step, mirrored on every `mint-directory` occurrence (`grep -rn mint-directory internal/launcher cmd/launcher`). A failure never stops the install; the console then says the update isn't set up.
- Tests: `steps_test.go` (env present only when complete; identity values always set), `reusekey_test.go` (kind name and scope).

**T9. Guards proven by mutation** (`mutation-testing-discipline`, capped: `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …`). One mutant per guard, each killed by a named test, unmutated control green: route `requireAdmin` removed from `POST /admin/updates`; store `beginOrg(write)` → read; owner-tenant check dropped; CSRF compare dropped; version-equals-offer check dropped; identity proof (public URL) dropped; image built from tag instead of digest; schema comparison in "begin rollback" inverted; `target` identity check weakened to version only; prerelease filter dropped. Record in `mutants-<sha7>.txt`.

**T10. Docs and delivery record** (see "Docs & records").

**T11. Evidence** (see "Evidence").

**T12. Gates, then stop at `ready-for-review`** (see "Gates"). Show `git diff --stat origin/main...HEAD`, and prove `git diff --name-only origin/main...HEAD` has no `.github/` path.

## Evidence (builder task; folder `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`)

Real console captures come from the opt-in journey `TestControlPlaneUpdateBrowserJourneyWithPostgres` (`internal/web/control_plane_update_browser_test.go`, modelled on `integrations_browser_test.go:33`). It skips with exactly "set LEORNA_UPDATE_EVIDENCE_DIR and LEORNA_UPDATE_CHROME_BIN for the recorded browser journey" unless both are set. It uses the T7 fixture, signs in through cookies set over CDP, and captures sections with `chromedp.Screenshot("#<id>", …)` (the CSP blocks inline scripts, so no in-page height trick). Chrome needs `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--disable-gpu --disable-software-rasterizer`, and a short `--user-data-dir` and `TMPDIR` such as `~/.cache/xnyk/{u,t}`.

| File | What it must show |
|---|---|
| `ac1-update-offer.png` | `/admin/updates` as admin: current `v0.2.0`, release `v0.3.0`, rendered notes, the "Update to v0.3.0" button |
| `ac1-member-denied.png` | the same URL as a member: the 403 `ADMIN_REQUIRED` answer, no update action |
| `ac2-updating.png` | the page while the update runs (`#update-progress`) |
| `ac2-new-version.png` | after the simulated restart: current `v0.3.0`, "Updated from v0.2.0 to v0.3.0" |
| `ac3-rollback-reason.png` | the failed attempt, "went back to v0.2.0", and the reason from Scaleway |
| `ac3-rollback-blocked.png` | the blocked case and its reason |
| `ac4-audit-events.png` | `/admin/audit` filtered to the update: request, update and rollback rows, with UUIDs replaced by `[id]` through `chromedp.Evaluate` and a visible banner saying how many were replaced |
| `gates-<sha7>.txt` | the gate run for that head, one `label EXIT=<rc>` line per gate |

Each image carries a one-line caption in the evidence `INVENTORY.md`: "local run, fake Scaleway API and fake release feed, restart simulated in-process". Look at every PNG before citing it (bands of at most 1,300 px for tall ones): no domain, URL bar, tenant ID, email or token may show. Live proof for AC5 is Justin's and is listed as owed until he runs it. Never rebuild a missed capture from a log.

## Tests at a glance

- One test per AC (above), each with at least one failure case, all Postgres-backed.
- Supporting: T1 to T6 and T8 unit tests; the store test; the migration fill; the mutants.
- Boundaries every web test keeps: member 403, wrong CSRF 403, other tenant 403 with no write, no session 302/401, and no secret in any body, log line or audit record (assert on a logger that records, not `discardLogger`, in one test).
- New permitted skip when the suite runs without the two evidence variables: the journey's exact skip text above. No other new skip.

## Gates (on every head that is handed on)

Run from the story worktree or a detached copy at the same SHA, never from the main checkout. Bind the tools by absolute path and keep `/usr/local/bin` (gitleaks) on PATH:

```
T=$HOME/.local/leorna-tools
export PATH="$T/go/bin:<own bin with tofu 1.12.6>:/usr/local/bin:/usr/bin:/bin"
export LEORNA_TEST_DATABASE_URL='postgres://leorna:<read from docker inspect>@127.0.0.1:<own port>/leorna_86bcxnykn_test?sslmode=disable'
GOLANGCI_LINT="$T/golangci-lint-2.14.0-linux-amd64/golangci-lint" GOVULNCHECK="$T/bin/govulncheck" make check
bash ./scripts/test-module-add.sh          # serially, never alongside make check
python3 -m unittest scripts/test_release.py
python3 -m unittest discover -s scripts -p 'test_story_shippable.py'
```

- **Postgres no-skip check:** a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/update/...`, read per test; fail on any skip whose reason names `LEORNA_TEST_DATABASE_URL`. Permitted skips are the exact texts the `leorna` skill's `references/gates.md` lists, plus this story's journey skip.
- `make check` needs the network (`tofu init` in `internal/cloud/scaleway`); check `command -v tofu` first so that test doesn't skip silently.
- Also build the image as CI does (`docker build --file Containerfile --tag xnykn:<sha7> .`, then `docker run --rm --entrypoint /usr/local/bin/gitleaks xnykn:<sha7> version` → `8.30.1`) and remove the tag afterwards.
- A command that dies with SIGTERM, 137, 143 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result, say so, and rerun under the 4G cap.
- Authorship check prints a result only ("authors: 1 identity, Leorna OK"), compared against `$(git config user.email)`.

## Choices made

1. The control plane redeploys itself with its own narrow key; state lives in Postgres; a reconciler in every process advances it. (Not the installer, and not a blocking call inside the HTTP request.)
2. Process identity comes from three environment values set in the same Scaleway call as the image, because the image carries no version stamp and CI can't be changed here.
3. One discovery path: the GitHub Releases shape. The digest is read from the pipeline's generated notes line and pinned to `release.py` by a test. No second lookup against the registry: pulling by digest is the integrity check the card names, and cosign comes with the SBOM story.
4. A new focused Scaleway adapter instead of `redeployExisting` (reasons in Approach 1).
5. No Scaleway startup probe in this story (follow-up).
6. Rollback only when the database schema is unchanged; otherwise blocked with the reason (Q3).
7. Three audit actions on the existing path; the request is audited at click time so "who approved" survives a crash.
8. AC tests assert on rendered HTML and JSON in Postgres-backed HTTP tests (the repo's convention); the browser journey is opt-in evidence, so no AC depends on Chrome.
9. `ApplyMigrationsFS` is exported so a test can model "the next release's migrations". It is the same runner with the file set as a parameter.
10. Release notes reuse `library.RenderMarkdown`; no new HTML sanitiser.

## Assumptions

- "Stable channel" means GitHub Releases that are neither draft nor prerelease, with a `vX.Y.Z` tag. That is what the pipeline publishes.
- The installer's fixed names (`leorna` / `control-plane`) identify the container; the public-URL proof guards the rest.
- Installs made before this story show "current version unknown" until their first in-place update or a resume with a new installer. An unpinned previous image (`…:latest`, or a locally built `:demo`) is rolled back to the same reference, and the page says the rollback target isn't pinned to a digest. Versioned installers always deploy a digest (`scripts/dist.sh`), so customer installs are pinned.
- Helm/Kubernetes installs have no Scaleway key, so they show releases with the update action off. No chart change.
- The client repo needs no change. Its OpenAPI copy already lags and these two operations are admin-only.
- PR Assumptions will also say: customers can't read releases until they are public (Q1), and the release-notes line is now an interface the release script must keep.

## Risks

- **Scaleway behaviour not yet seen live:** whether `UpdateContainer` alone starts a deployment, how long a failed deployment takes to show `error`, that the old revision really keeps serving, and that an update which leaves secret env out keeps the secrets (the custom-domain activation already sends an env-only update the same way, `domain.go:357-367`). The state machine tolerates each (settled-then-redeploy, deadline, any process acts), but only AC5 proves it. Highest risk in the story.
- **Rollback is blocked after a migrating release fails** (Q3). Until a later story (startup probe, or a migration-compatibility rule), a bad release that migrates leaves the server on the failing version, with 24 hours of the old revision serving. The page and README say so plainly.
- **A dead image with no survivor:** if Scaleway ever stops the old revision before the new one works, nothing inside can roll back. Recovery is the installer's resume. Documented.
- **Wider server privilege:** a compromised control plane holding `ContainersFullAccess` could deploy any image to containers in that project. The key is optional, separate and project-scoped; the README states the trade.
- **Dev-mode installs:** the installer deploys with dev mode on (`internal/launcher/installer_secrets.go:45`), where `/dev/login` makes anyone an admin. On such a server anyone who can reach it can start an update, though only to a newer Leorna stable release from the configured repository. Existing condition; noted under "Other things found".
- **IAM key quota:** one more key per project (the organisation's quota of 100 filled once on 2026-11-08). The mint is best-effort and reuses a cached key.
- **Private repo:** on real customers the feed answers 404 until releases are public (Q1). The page explains it.
- **False rollback:** a 10-minute outage of ClickHouse or Mongo during an update makes a good release look unhealthy and rolls it back. Conservative by design; the reason is shown.
- **Size:** about 30 files. Forecast for the builder: 4 to 6 hours of agent time, medium confidence; the installer part (T8) and the state machine (T4) are the two places a slip is most likely.

## Files and areas touched

- New: `internal/update/` (`release.go`, `feed.go`, `service.go`, `reconciler.go`, `scaleway.go`, tests, `testdata/`, `README.md`), `internal/update/updatetest/`.
- New: `internal/store/postgres/control_plane_updates.go` + test; `migrations/000032_control_plane_updates.{up,down}.sql`.
- Changed: `internal/store/postgres/migrate.go`, `store_test.go` (two table lists and the drop list).
- New: `internal/web/control_plane_update.go`, `control_plane_update_test.go`, `control_plane_update_browser_test.go`. Changed: `internal/web/handler.go` (fields, five routes, admin home banner and link), `internal/web/README.md`.
- Changed: `contracts/control-plane.openapi.yaml`, `packages/contracts/controlplane.gen.go` (generated), `packages/contracts/roundtrip_test.go`.
- Changed: `internal/config/runtime.go` + test, `internal/health/handler.go` + test, `cmd/control-plane/main.go`, `.env.example`.
- Changed (installer, Q2 A): `internal/launcher/reusekey.go` + test, new `ReleaseVersionFor` + test, `internal/installer/orchestrator/steps.go` + test, `cmd/launcher/main.go`, `internal/installer/README.md`.
- Changed: `internal/audit/README.md`, `delivery/stories.json`.
- Not touched: `.github/workflows/*`, `scripts/release.py`, `Containerfile`, the Helm chart, `deploy/local/`, the client repo.

## Overlap with siblings (checked at the base SHA)

- Open PR #113 (`feat/86bcx2a33-github-mcp-current`, currently `DIRTY` against main): library content and `delivery/stories.json` only.
- Local unmerged branches `feat/86bcm928t-integration-governance-usage`, `feat/86bccndx6-custom-company-domain`, `feat/86bcm927y-integrations-catalog-tiles`, `feat/86bcm901b-prompts-collection`: each is one commit ahead touching only `delivery/stories.json`. `feat/86bcm9284-source-repin`: no shared file.
- So the only shared file is **`delivery/stories.json`** (every story appends last; whoever merges second resolves it by taking main's file and appending its own entry as text). **No sibling adds a migration, changes the OpenAPI spec, the audit code, `handler.go`'s routes, `main.go`, `runtime.go` or the installer.** `000032` is free.
- The client self-update story 86bcxnymy is being planned in parallel in the client repo. It doesn't share files with this one, but it meets the same private-repo fact (Q1); one answer should cover both.

## Other things found (not part of this story)

1. **The repo is private, so nothing outside can read its Releases** (anonymous `GET …/releases/latest` → 404), while the card and the pipeline assume customers can. Affects this story (Q1) and the client self-update story. Severity: high for both update stories; a decision for Justin/Yan.
2. **The control-plane image has no version stamp** (`Containerfile:15`), so a server can't say which release it is without this story's environment values. Severity: low.
3. **No stable release exists yet**: only `v0.2.0-rc.1` (prerelease). On a real feed there is nothing to offer until the first `vX.Y.Z` tag. Severity: info.
4. **Every installer deploy runs in dev mode** (`internal/launcher/installer_secrets.go:45`, `DevMode: true`), so `/dev/login` makes any visitor an admin on installed servers. Known for the test servers; it widens what an in-place update exposes. Severity: high before any customer install; existing.
5. **`leorna-test-pg` is stopped on the desktop** (`Exited (255)`, 10 days), and six other story containers are left exited. Severity: housekeeping.
6. **Scaleway removes both revisions 24 hours after a failed deployment** (their docs). An unattended failed install or resume turns into an outage a day later. Severity: info for the installer's README.

## Docs & records (build and finish update all of these)

- `internal/update/README.md` (the short module note the DoD asks for): what the module does, the settings, the security boundary, the state machine in one table, what rollback can't do, the incident steps for `rollback_blocked` and `rollback_failed`, and the **Live check** runbook for AC5 (how to build and push two images, write the test feed, set the three settings, run the update and the failing release, and what to look for; no domain or URL in the file).
- `internal/audit/README.md`: one paragraph naming the three actions, their before/after fields and the tests.
- `internal/web/README.md`: the page, its routes and guards.
- `internal/installer/README.md`: the update key (what it may do, that it is optional, that resume adds it).
- `.env.example`: the optional settings, commented.
- `delivery/stories.json`: append `"86bcxnykn": {"name": "Update the control plane in place from the admin console (with rollback)", "prs": {"LeornaAI/leorna-control-plane": []}}` as text at the end; the PR number goes in after the PR opens (one small commit).
- Plan copy: `evidence/86bcxnykn/plan-approved.md` (the orchestrator makes it at "go").
- Shared notes: story state in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` (branch, head, review state, AC5 owed), and the Scaleway and private-repo facts in `leorna-control-plane-workflow.md`. Agents report these as lessons; the main session writes them.
- Hand-over (finisher): PR text in the plain style with security, migration and rollback notes, the review prompt, the team message, and the ClickUp evidence draft (images only). Nothing is pushed or posted until Justin says so.
- Follow-up cards to offer: make releases readable by customers (or a public manifest); a Scaleway startup probe on `/readyz`; a rule or check that lets a previous version run on a newer schema; version stamp in the image; dev mode off for customer installs.
