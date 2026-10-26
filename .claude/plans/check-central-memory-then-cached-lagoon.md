# 86bbu3xew: Connect an existing database (control plane)

## Context
Card: https://app.clickup.com/t/90141510532/86bbu3xew (Size S). An admin should be able to connect a database they already have instead of provisioning one. The dependency is met: the `ConnectExisting` port is on main (`internal/cloud/provider.go:13`, from Christian's #36), and Scaleway's version is a stub that only checks fields. Its comment says the live connection test belongs to this story (`internal/cloud/scaleway/scaleway.go:71-79`).

Justin's decisions:
- The form goes in the **setup wizard only**. It's HTML, so there's no JSON API and no OpenAPI change.
- **TLS is required but the certificate isn't verified** (`sslmode=require`). Verifying it (verify-full) is a follow-up.

Result: the wizard's Database step gets a "Connect an existing database" form. On submit, a real Postgres connection test runs:
- If it passes, the DSN is stored encrypted and the connection is marked `ready` in one transaction, and the wizard moves on to the pack step.
- If it fails, the step shows one specific error inline and nothing is stored.

## Setup
`git checkout main && git pull --ff-only origin main` (main = `74a44dc`), then `git checkout -b feat/86bbu3xew-connect-existing-db`. Leave `deploy/local/` alone. No migration is needed: `cloud_connections.status` is free text and both tables already exist.

## Build (test first for each step; commits `feat(86bbu3xew): ...`)

### 1. Connection test: new package `internal/cloud/dbcheck`
- `Checker{SSLMode string; AllowAddress func(netip.Addr) bool; Timeout time.Duration}`. Zero values mean `require`, the default address guard and 10 s. Production uses the zero value. Tests set `SSLMode: "disable"` and allow loopback, because CI's Postgres has no TLS and runs on 127.0.0.1.
- `Check(ctx, cloud.ConnectExistingRequest) (dsn string, err error)` works in four steps:
  - It parses the endpoint strictly (`host[:port]`, default 5432). Paths are rejected, since pgx treats `/…` as a unix socket.
  - It builds the DSN with `url.URL`, so the user, password and database name are escaped.
  - It connects with pgx and a `LookupFunc` that refuses loopback, link-local (including 169.254.169.254), unspecified and multicast addresses. Private 10.x addresses are allowed, because the chart's database egress is `10.0.0.0/8`.
  - It runs `SELECT 1`, closes the connection and returns the DSN it tested.
- Specific failures are new sentinels in `internal/cloud/errors.go`, next to `ErrAuthFailed`. Each maps from a real error:

| Sentinel | Comes from |
| --- | --- |
| `ErrDatabaseDetailsInvalid` | a malformed endpoint or a missing field |
| `ErrDatabaseAddressRefused` | an address the guard refuses |
| `ErrDatabaseUnreachable` | a dial error or a DNS error |
| `ErrDatabaseTimeout` | a deadline or a network timeout |
| `ErrDatabaseTLS` | "server refused TLS connection" |
| `ErrDatabaseAuth` | SQLSTATE 28P01 or 28000 |
| `ErrDatabaseNotFound` | SQLSTATE 3D000 |

- Raw server error text is never passed up, so no hostnames or messages leak.

### 2. Scaleway adapter (`internal/cloud/scaleway/scaleway.go`)
- Add a `databases` checker field. `New()` wires `dbcheck.Checker{}`.
- `ConnectExisting` keeps the required-field check, now wrapping `ErrDatabaseDetailsInvalid`, and then runs the check.
- It returns `NewCredential(ID, "host:port/database", dsn, ["existing-db"], zero)`. The credential's secret becomes the tested DSN, so what gets stored is exactly what was tested. The port signature doesn't change.
- Update `TestConnectExistingReturnsCredential` to use a fake checker, and add a case where the check fails.

### 3. Store (`internal/store/postgres/cloud_connections.go`)
New `AttachReadyConnection(ctx, connectionRef, secretRef, tenantID, provider, resourceID, ciphertext)`, in one transaction through `beginCloudMutation(ctx, tenant, false)`, so only a current admin can call it:
- insert the secret row;
- insert the connection row with status `ready`, `resource_id`, `secret_ref` and `actor_id`;
- write two audit records, `cloud.connection.secret` and `cloud.connection.attach`, with no secret in either.

### 4. Service (`internal/cloud/provision/service.go`)
- Add `AttachReadyConnection` to the `ConnectionStore` interface and update the fakes in `provision_test.go`.
- New `Service.ConnectExisting(ctx, tenantID, provider, request) (ConnectionView, error)` does this in order:
  - looks up the adapter, returning `cloud.ErrUnsupported` if it lacks the `ConnectExisting` capability;
  - calls `adapter.ConnectExisting`, and on an error returns straight away with nothing stored;
  - on success, generates the refs with the existing `randomUUID`, seals the DSN with the existing encryptor, calls `AttachReadyConnection` and returns a ready view.

### 5. Wizard (`internal/web/setup.go`, route in `handler.go`)
- Add `ConnectExisting` to the `setupDatabases` interface.
- New `POST /admin/setup/database/existing` uses the same guards as the other wizard routes: `requireSession` + `requireAdmin`, and `adminForm` for the CSRF check.
- Inside `TrySetupLock`, it re-reads `setupState`:
  - if a database is done or provisioning, it reuses it and does nothing;
  - otherwise it runs `ConnectExisting`.
- Outcomes:
  - Success redirects to `/admin/setup`.
  - A known failure re-renders the page with status 422, the specific message inline in the Database step, and endpoint, database and username filled in again. The password is never filled in.
  - An unknown failure is logged with `logSetupFailure` (trace ID in `X-Trace-ID`), and the page shows 500 with a generic retry message.
- Template changes:
  - The existing-DB form (endpoint, database, username, `type=password` password) shows in the `todo`, `failed` and `needs-connect` states. An admin with their own database never has to connect Scaleway first.
  - The "done" wording changes from "Scaleway database" to "database".
  - No change to `internal/onboarding`: a ready connection already counts as done.
- The connection is stored under provider `scaleway`, the wizard's `setupProvider`.

### 6. Docs and delivery
- `internal/web/README.md`: a new "Connect an existing database" section covering routes, behaviour, security, limits and the test names.
- `internal/cloud/scaleway/README.md`: one line saying `ConnectExisting` now tests the connection live.
- Short `internal/cloud/dbcheck/README.md`.
- `delivery/stories.json`: add `"86bbu3xew": {"name": "Connect existing database", "prs": {"LeornaAI/leorna-control-plane": []}}`. The PR number goes in right after the PR opens.

## Tests
- **Card "Verify": `internal/cloud/dbcheck`**
  - **Unit tests, no database:** endpoint parsing and rejection; the address guard (127.0.0.1, ::1, 169.254.169.254, 0.0.0.0, fe80::1 and 224.0.0.1 are refused; 10.1.2.3 and a public IP are allowed); error classification from synthetic `PgError` and `net` errors.
  - **Against real Postgres (skipped without `LEORNA_TEST_DATABASE_URL`):**
    - `TestCheckPasses`.
    - `TestCheckFails`, with one subtest per failure:
      - wrong password → auth;
      - unknown database → not found;
      - `require` against the non-TLS test DB → TLS;
      - closed port → unreachable;
      - a listener that never answers, with a 200 ms timeout → timeout;
      - loopback under the default guard → address refused.
- **Store:** `AttachReadyConnection` stores a ready row, a secret row and two audit records.
  - A member actor is refused.
  - Tenant B can't read tenant A's row.
  - A forced failure on the connection insert (`CHECK(false) NOT VALID`) leaves no secret row, which proves the write is atomic.
- **Service:**
  - Success seals the DSN (the ciphertext doesn't contain the password, and `Open` gives the DSN back).
  - A test failure makes zero store calls and returns the specific sentinel.
  - An unsupported provider stores nothing.
- **Web: `TestConnectExistingDatabaseWithPostgres`** in `internal/web/setup_test.go`, with the fixture's provider delegating `ConnectExisting` to a real `dbcheck.Checker` against the test DB. There is one subtest per acceptance criterion:
  1. "a connection test runs and reports success or a specific failure";
  2. "a successful test stores the connection encrypted and marks it ready": check the row status, that the secret decrypts to the DSN, and that the audit has no password or `postgres://`;
  3. "bad details return a clear error and store nothing": check for zero connection, secret and audit rows.

  Plus subtests for:
  - a ready or provisioning DB being reused;
  - the form working without Scaleway connected;
  - another tenant being unaffected;
  - members, a wrong CSRF token and signed-out visitors being refused;
  - no page ever containing the password.
- **Mutation checks, each still compiling and then restored:**
  - mapping 28P01 to the wrong sentinel;
  - dropping the address guard;
  - storing before the test runs;
  - storing plaintext;
  - splitting the store transaction;
  - skipping the reuse check;
  - echoing the password into the form.

## Verification
```
docker start leorna-test-pg
export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_test?sslmode=disable'
go test ./internal/cloud/... -v -race -run 'Check|ConnectExisting'
go test ./internal/store/postgres -v -run AttachReadyConnection
go test ./internal/web -v -run 'TestConnectExistingDatabaseWithPostgres|TestSetupWizardWithPostgres'
make check
bash ./scripts/test-module-add.sh
```
Use `-v` to confirm the Postgres tests ran and weren't skipped. The demo is the web test run with `-v`, which logs each rendered step.

## After the gate (no push, no PR)
Show `git diff --stat origin/main..HEAD`, the key hunks and the results. Then give:
- PR text in the plain Summary / Test Plan style, with this Assumptions list:
  - the port on main is the agreed 86bbu3xdy port;
  - Postgres only;
  - `sslmode=require` without certificate checks;
  - which addresses are refused;
  - the chart's egress only allows `networkPolicy.databaseCIDRs` (default `10.0.0.0/8`), so a database elsewhere needs its CIDR added by an operator; the chart isn't changed here;
  - the audit action name;
  - live deployed acceptance against a real Scaleway DB is still unverified.
- A self-contained review prompt for a fresh agent.
- After merge, the short team message with the PR and ClickUp links.
