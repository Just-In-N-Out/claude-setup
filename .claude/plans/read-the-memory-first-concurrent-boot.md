# 86bbu3xr4 — Onboarding wizard

## Context
Justin's next story (ClickUp https://app.clickup.com/t/90141510532/86bbu3xr4). The branch `feat/86bbu3xr4-onboarding-wizard` already exists, cut from main `9da14bb`.

**Card acceptance criteria:**
- (AC1) First run: login + pick a DB → provisioning runs and the seed pack loads.
- (AC2) On completion the console shows a ready state with the base pack available.
- (AC3) A failed step can be retried without restarting.

**Verify:** "wizard e2e happy path with mocked cloud; step-retry test".

**DoD:** unit + integration tests (happy path + 1 failure), OpenAPI only if the API is touched, CI green, demoable, README note.

**Closeout note:** reuse Complete setup/SeedPack. "Do not count the seed form alone as the onboarding wizard." It needs database selection/provisioning, seed-loader integration, and step retry.

**What exists today:**
- **Login:** Google OAuth lands the user on `/admin`.
- **Provisioning:** `provision.Service.Provision` creates a `cloud_connections` row and moves it to `ready` or `failed` in a goroutine (`internal/cloud/provision/service.go:128`). It requires a stored Scaleway credential; without one it returns `ErrCredentialNotReady`.
- **Connecting Scaleway** happens outside the browser: the launcher calls `POST /v1/cloud/scaleway/connect`.
- **Seed loading:** `EnsureSeedBase` (base version, startup only) and `SeedPack` (tenant catalog, `POST /admin/packs/seed`).
- **What's missing:**
  - There's no onboarding state, no way to list a tenant's connections, and no HTML inline-error pattern (`writeProblem` is JSON only).
  - The web layer can't reach `EnsureSeedBase`.

**Justin's decisions:**
- Entry is a **banner on `/admin`** linking to `/admin/setup`, not a forced redirect.
- The DB step is **reuse or provision**: an existing ready database is reused, otherwise a new one is provisioned.

## Design
State is **worked out from data that already exists**, so there's no new table and no migration. That also avoids clashing with PR #46, which takes migration 17.
- **Login:** done, because the admin is signed in.
- **Database (Scaleway):**
  - done if any connection is `ready` (the newest ready one is used);
  - in progress if the newest is `provisioning`;
  - failed (retry offered) if the newest is `failed`;
  - "connect Scaleway first" if there's no credential;
  - otherwise the provision form.
- **Starter pack:** blocked until the database is ready. Done when the tenant's catalog is loaded.
- **Ready:** the database is ready and the pack is loaded.

Each step's POST is safe to repeat. Retrying one step never touches the others, which covers AC3.

## Changes
1. **`internal/onboarding` (new, pure, no DB):** `Evaluate(Facts) Progress`.
   - Facts: provider connected, the tenant's connections newest-first, pack loaded.
   - Progress: per-step status (done / in progress / failed / needs-connect / todo / blocked), the selected database, the done count, and whether it's ready.
   - Adds `state_test.go` (table-driven unit tests, which covers the DoD's "unit") and a short `README.md`.
2. **Store:** `ListConnections(ctx, tenantID, provider)` in `internal/store/postgres/cloud_connections.go`. Tenant-scoped, newest first, no secrets. Added to `provision.ConnectionStore`, with a `Service.ListConnections` passthrough returning `[]ConnectionView`. The fakes in `internal/cloud/provision/provision_test.go` get the method. Adds a store test covering order, the provider filter and tenant isolation.
3. **Web:** `internal/web/setup.go` (handler + inline template, following the `packVersionsView` / `writePackPage` pattern with nonce CSP and no scripts).
   - `GET /admin/setup` renders the 3 steps plus the ready panel. The ready panel shows the pack name and version with a link to `/admin/packs`.
   - `POST /admin/setup/database` (`adminForm` for CSRF) takes region/engine/size/name with the same defaults as `cloud_plan.go`, calls `Provision`, then 303s to `/admin/setup`. On error it re-renders the page with an inline error in that step: 424 "Connect Scaleway first", 500 "Provisioning could not start, try again".
   - `POST /admin/setup/pack` calls `EnsureSeedBase`, then `SeedPack`, treating `ErrAlreadyLoaded` as success, then 303s. On error it re-renders with an inline error in that step (500 for `pack.ErrSeedLoad`), plus a retry button.
   - Routes use `requireSession(requireAdmin(...))`, with a redirect for the GET. The provider is fixed to `scaleway`.
   - **Wiring:** `SetSetup(databases, credentials provision.CredentialReader, seeds interface{ EnsureSeedBase })`. If it's nil the routes answer 503. The packs repo and seed come from the existing `SetPacks`.
   - **Banner:** `/admin` (`handler.go` `admin()` + template) shows "Setup: N of 3 done → Continue setup" or "Setup complete", but only when `SetSetup` is wired, so existing admin tests don't change.
4. **`cmd/control-plane/main.go`:** hold the provision service in a variable, then call `SetProvisioning(svc)` and `SetSetup(svc, repository, repository)`.
5. **Docs:**
   - `internal/web/README.md`: a "Setup wizard" section.
   - `internal/onboarding/README.md`.
   - `internal/pack/README.md`: change "is expected to call" to "calls".
   - Root `README.md`: role table rows for `/admin/setup`.
   - `delivery/stories.json`: `86bbu3xr4` entry, with the PR number added after it opens.
   - OpenAPI unchanged (HTML only).

## Tests (test first; one subtest per acceptance criterion)
`TestSetupWizardWithPostgres` in `internal/web/setup_test.go`. Each subtest gets a fresh schema fixture, like `newPackFixture`: the real `provision.Service`, the mocked cloud `auditWorkflowProvider` (`cloud_audit_test.go`, which has a fail toggle), and a credential stored through the vault to simulate the launcher connect. Async provisioning is waited on by polling `GET /admin/setup`, like the `wait` helper in `teams_test.go:631`.
- **AC1:**
  - With no credential, the DB step says "connect Scaleway first".
  - Store the credential, then POST database: it's in progress, then done.
  - POST pack: done. The base version row exists and the catalog is loaded.
- **AC2:**
  - The ready panel shows the pack name and version with a link to `/admin/packs`.
  - The banner says "Setup complete".
  - A second tenant sees nothing done.
  - "Reuse" is covered: an existing ready connection makes the DB step done with no new provisioning.
- **AC3:**
  - The provider fails: the DB step shows failed plus a retry form, and login stays done. Turn the failure off and retry: done.
  - Seed write failure (`CHECK(false) NOT VALID` on `pack_version_items`): the pack step shows an inline error, and the DB step stays done. Drop the constraint and retry: ready.
- **Boundaries:** a member gets 403, a wrong CSRF gets 403, and an unauthenticated GET gets 302 to login.
- **Fakes:** a small fake-repo test for the 503s when unwired.

HTML assertions are scoped per step element, not whole-body `Contains`. Every hardened assertion gets a mutation check.

## Verification
- `go test ./internal/onboarding ./internal/web ./internal/store/postgres ./internal/cloud/provision -run 'Setup|Onboarding|ListConnections|Evaluate' -v` with `LEORNA_TEST_DATABASE_URL` set (confirm nothing skipped).
- `make check`, `bash ./scripts/test-module-add.sh`, and the stories.json unit test.
- Demo: the setup test with `-v` logs each rendered step.
- Stop and show the diff, with paste-ready PR text. No push until Justin says so.

## Assumptions (for the PR)
- The provider is Scaleway, the only one that can connect. Connecting still happens through the launcher; the wizard checks it and explains how.
- "Select" means reusing the newest ready database. Connecting a database made outside Leorna waits on 86bbu3xew. Picking between several ready databases isn't offered, because nothing uses that choice yet and storing it would need a migration.
- The seed goes into the control plane's own Postgres, as Christian confirmed for 86bbu3xfg.
- Errors on wizard pages render inline in HTML, a new pattern used only on these pages, so a step can be retried in place.
