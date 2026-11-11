# 86bcxnymy — Client self-update to the admin-approved version, with staged rollout

## Questions (answer with letters; **go** alone takes every ⭐)

**Q1. Where does a client download the new exe from?** Both repos are private on GitHub (`gh repo view`: PRIVATE), so a client without a GitHub login gets 404 from the Release link the card names.
- A) ⭐ A link per approved version; default the GitHub Release
- B) The control plane proxies the download with a GitHub token
- C) Admin uploads the exe; clients download it from the server

Why ⭐: A is what the card describes and the smallest build. The admin can type any HTTPS link when approving a version, so your live test works today from any HTTPS host. Real customers can update only once the release file can be downloaded without a GitHub login (a public release or mirror): that is Christian's and Yan's decision, not this story's. B puts a Leorna GitHub token on every customer's server. C stores 35 MB files in Postgres and is a bigger build.

**Q2. What is "a group" in a staged rollout?**
- A) ⭐ Teams, plus clients the admin ticks in a list
- B) Teams only
- C) Ticked clients only

Why ⭐: teams are the product's existing groups (pack assignments, cost alerts). But on a dev-mode server every client signs in as the same demo admin, so teams alone can't separate your two Windows clients in the card's Verify, and no agent can prove "only that group updates" end to end. Ticked clients solve both. With B, card AC1 would need a re-plan (its end-to-end test can't run on a dev server) and the live test needs two real Google users.

**Q3. Build the percentage rollout in this story?** The card's context says "optionally to a percentage or a group"; its ACs name only the group.
- A) ⭐ Yes, as proposed AC5
- B) No, a follow-up card

Why ⭐: it is one small pure function, one column and one form field once the group rollout exists.

**Q4. Which clients count in "how many clients run each version"?**
- A) ⭐ Each installation seen in the last 30 days
- B) Each installation seen in the last 7 days
- C) Every installation ever seen

Why ⭐: a client checks in at every launch and every 6 hours while open; 30 days keeps holiday laptops and drops retired ones. The page also says how many older installations are left out.

**Q5. What does "fails to start" mean?**
- A) ⭐ The new version's window never loaded on its first launch
- B) Two launches in a row without a loaded window
- C) A, plus a test launch of the new exe before switching

Why ⭐: A is the card's words ("on the next launch"). The client marks a new version "started" when its window has loaded; if the first launch never got there and that process is gone, the next launch puts the previous exe (and the local database copy made before the first launch) back and reports `start_failed`. C runs the new version's database migration before the switch, which is its own risk.

**Q6. Where does the control plane get the SHA-256?**
- A) ⭐ The admin pastes it from the release's `.sha256` file
- B) The control plane fetches it from GitHub

Why ⭐: B needs a GitHub token on the customer's server (private repo) and makes GitHub, not the customer's control plane, the source of the checksum. A keeps the admin's approval the single trusted step.

**Q7. When does the client restart for an update?**
- A) ⭐ Right away, when no Sync, Restore or install is running
- B) Never while open; the new version starts at the next launch
- C) It shows a "Restart now" button

Why ⭐: the card says "replaces itself and restarts". The window shows a line first ("Updating Leorna to v…").

**Q8. This is about 6,500 lines over two repos, more than any build so far (the largest was about 4,600). How should it be built?**
- A) ⭐ One plan, two builders in a row: control plane, then client
- B) One builder for both repos (as in 86bcm902w)
- C) Two cards: control plane now, client as a follow-up card

Why ⭐: each builder holds one repo in its head, and the client builder tests against the finished control-plane branch. One plan, one "go", one evidence folder. C needs a new card and a re-plan (the card's ACs all need both halves).

## Status and bases

**Status:** plan for approval (planner, 2026-11-10 evening EST). Nothing is built. Card: [Client self-update to the admin-approved version, with staged rollout](https://app.clickup.com/t/86bcxnymy), size L, repo both, assignee Justin, status "to do", no comments.
**Bases (GitHub `main`, fetched over HTTPS through gh):** leorna-control-plane `4ef14efb46da789aec30fad1e5a988d8770140e2`; leorna-client `a7839b3af664efcfa59eb1ed3fe276ec1262a4de` (client `main` moved during planning: PR #32 merged at 2026-11-11T00:49Z; the files this plan reads are unchanged between `f3bc960` and `a7839b3`). Local main checkouts are behind and were not moved; the builders' worktrees start from these SHAs.
**Evidence folder:** `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/`.

## Playback

You sent the card with "do this clickup story". The ask: a tenant admin approves client versions, pins one for the whole tenant, can roll a version out to a group or a percentage first, and can go back to an older approved version. The control plane tells each client which version to run and that release's SHA-256, over TLS, and shows how many clients run each version. The client asks its control plane, downloads the exe, checks it against the SHA-256, replaces itself and restarts. A wrong checksum is refused (current version stays, the failure is reported). A new version that doesn't start is replaced by the previous one on the next launch. No code signing yet: the checksum is the integrity check, and the signing story [Sign the engineer client](https://app.clickup.com/t/86bcm9031) later adds an Authenticode check at one named place in the same step.

## Summary and size

- **Too big for one builder** (Q8): about 3,300 lines in the control plane and 3,200 in the client. The plan is written as two parts with two builders in a row; the contract between them (OpenAPI plus the admin form fields in D7) is fixed here so neither redesigns.
- **Control plane (Part 1):** migration `000032`, a small rules package `internal/clientupdate`, store methods, two client endpoints in the OpenAPI contract, one admin page `/admin/client-versions`, audit records.
- **Client (Part 2):** a new package `selfupdate` (check, download, verify, swap, launch guard, relaunch), three small wiring edits (`main.go`, `desktop`, the Windows build script that stamps the version), one status line in the window.
- **Every AC's named test lives in the client repo**, because `ac-check.sh` takes one repo. Card AC1, AC2 and AC4 are proven end to end: the client's real update code against the story's real control-plane binary in dev mode on this machine. The control plane's own tests run as supporting receipts.
- **Owed to you:** AC8 (live), the card's Verify with two real Windows clients.
- **Forecast (low confidence, no close comparable):** control-plane builder 3–4 h, client builder 4–5 h of agent time, then review rounds on both repos.

## Acceptance criteria

The card's own criteria are AC1–AC4, in card order. AC5–AC7 are **proposed** by the planner; **go** approves them. AC8 is the card's Verify and only you can run it. Each AC has one named test, in the client repo.

- AC1: Given the admin approves client vX.Y.Z for a group, then only clients in that group update, and the console shows how many clients run each version. Test: `TestAC1GroupRolloutUpdatesOnlyThatGroupAndConsoleCountsVersions`
- AC2: Given a downloaded file whose checksum does not match, then the client refuses it, keeps the current version and reports the failure to the control plane. Test: `TestAC2ChecksumMismatchIsRefusedKeptAndReported`
- AC3: Given an update that fails to start, then the client returns to the previous version on the next launch. Test: `TestAC3FailedStartReturnsToPreviousVersionOnNextLaunch`
- AC4: Given the admin rolls back to an older approved version, then clients move back to it. Test: `TestAC4AdminRollbackMovesClientsBackToOlderVersion`
- AC5 (proposed): Given a staged rollout to a percentage, then at 0% no client outside the group is told to update, at 100% every client is, and every client covered at a lower percentage stays covered at a higher one. Test: `TestAC5PercentageRolloutCoversAStableGrowingShare`
- AC6 (proposed): Given the OpenAPI contract, then it has the update-check and failure-report operations with exactly the fields in D2, and the client's snapshot and generated code match it. Test: `TestAC6ClientUpdateOperationsAreInTheContract`
- AC7 (proposed): Given Windows, where a running exe can't be overwritten, then the client still replaces its own running exe, and puts the previous one back after a failed start. Test: `TestAC7WindowsRunningExeIsSwappedAndRolledBack`
- AC8 (live): Given the dev environment and two real Windows clients, then a staged rollout updates only the chosen one, a tampered download is refused and shown in the console, and a rollback moves the client back to the previous version (the card's Verify; checklist in "Live checklist for AC8").

### Per-AC detail

Common environment for every client command (from the client worktree):
```sh
export GOTOOLCHAIN=local PATH="$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:/usr/bin:/bin"
export GOFLAGS=-mod=vendor GOWORK=off
export TMPDIR="$HOME/.cache/86bcxnymy-<role>/tmp"; mkdir -p "$TMPDIR"
```
Extra environment for the end-to-end tests (AC1, AC2, AC4, AC5). A log with `--- SKIP` for the AC's test is a failed check (they skip without these variables):
```sh
docker start leorna-test-pg >/dev/null   # it was "Exited" on 2026-11-10
PGPW=$(docker inspect leorna-test-pg --format '{{range .Config.Env}}{{println .}}{{end}}' | sed -n 's/^POSTGRES_PASSWORD=//p'); [ -n "$PGPW" ] || { echo "empty leorna-test-pg password"; exit 1; }
PGPORT=$(docker port leorna-test-pg 5432/tcp | head -1 | sed 's/.*://')
DB=leorna_86bcxnymy_<role>_e2e_test
docker exec leorna-test-pg psql -U leorna -d leorna_test -q -v ON_ERROR_STOP=1 -c "CREATE DATABASE $DB"
( cd <control-plane worktree> && env -u GOFLAGS -u GOWORK go build -o "$TMPDIR/control-plane" ./cmd/control-plane )
export LEORNA_E2E_CONTROL_PLANE_BIN="$TMPDIR/control-plane"
export LEORNA_E2E_CONTROL_PLANE_MANIFEST=<control-plane worktree>/config/manifest.example.json
export LEORNA_E2E_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:${PGPORT}/${DB}?sslmode=disable"
```
The password is read from the container and never printed. Drop the database when done (`DROP DATABASE … WITH (FORCE)`). The tests may share one database: each uses fresh random installation IDs and version numbers and sets the whole policy it needs first.

| AC | Package | Command (only that test) | Why it fails on client base `a7839b3` | Screenshot |
| --- | --- | --- | --- | --- |
| AC1 | `./selfupdate/` | `go test -v -count=1 -run '^TestAC1GroupRolloutUpdatesOnlyThatGroupAndConsoleCountsVersions$' ./selfupdate/` | No `selfupdate` package and no update operations in `api`: build fails with `undefined:` (probed on a clean export of the base: `[build failed]`). | `ac1-console.png`: the real Client versions page saved by the test run (counts table and rollout), rendered in headless Chrome. |
| AC2 | `./selfupdate/` | `go test -v -count=1 -run '^TestAC2ChecksumMismatchIsRefusedKeptAndReported$' ./selfupdate/` | Same build failure. | `ac2-console.png`: the real page's client row with `checksum_mismatch`. |
| AC3 | `./selfupdate/` | `go test -v -count=1 -run '^TestAC3FailedStartReturnsToPreviousVersionOnNextLaunch$' ./selfupdate/` | Same build failure. | `ac3-terminal.png`: the rendered log. |
| AC4 | `./selfupdate/` | `go test -v -count=1 -run '^TestAC4AdminRollbackMovesClientsBackToOlderVersion$' ./selfupdate/` | Same build failure. | `ac4-console.png`: the real page after the rollback (counts back on the older version). |
| AC5 | `./selfupdate/` | `go test -v -count=1 -run '^TestAC5PercentageRolloutCoversAStableGrowingShare$' ./selfupdate/` | Same build failure. | `ac5-terminal.png`. |
| AC6 | `./api/` | `go test -v -count=1 -run '^TestAC6ClientUpdateOperationsAreInTheContract$' ./api/` | `undefined: CheckClientUpdateJSONRequestBody` in the copied test. | `ac6-terminal.png`. |
| AC7 | `./selfupdate/` (Windows binary) | `CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go test -c -o "$TMPDIR/selfupdate.test.exe" ./selfupdate/ && ( cd "$TMPDIR" && ./selfupdate.test.exe -test.v -test.count=1 -test.run '^TestAC7WindowsRunningExeIsSwappedAndRolledBack$' )` | The cross-build fails with `undefined:`. | `ac7-terminal.png`. |
| AC8 (live) | — | Justin, "Live checklist for AC8" | — | his screenshots |

How each is proven without a Windows PC: AC1, AC2, AC4 and AC5 run the client's real update engine on Linux against real files and the real control plane (the "exe" is a file in a temp folder; the release file comes from a local HTTPS test server). AC3 runs real processes on Linux: copies of the test binary play the old and the new client. AC6 is a pure contract test. AC7 is the same process test built for Windows and run natively through WSL interop (probed 2026-11-10: a cgo-free Windows test binary of a `selfupdate` package importing `api`, `login` and `onboarding` built to 7 MB and ran `--- PASS` from WSL). If interop is down in a role's session, AC7 is reported as not run, never as passed.

### What each AC test asserts

All AC tests are in `package selfupdate` (internal, not `selfupdate_test`) so that on the base they fail with `undefined:`; AC6 is in `package api`.

- For AC1 (`selfupdate/ac_e2e_test.go`): start the control plane (D10), sign in, make two installations X and Y that both report `vOLD`. The admin approves `vNEW` (SHA-256 of bytes B, link to the local HTTPS server) and starts a staged rollout of `vNEW` with only X ticked. X's run returns `installed`: X's exe file now holds bytes B, `<exe>.old` holds the old bytes, the state file has a pending update to `vNEW`. Y's run returns `no_target` and Y's exe is unchanged. X then checks in as `vNEW` (result `current`). `GET /admin/client-versions` shows `data-version="vNEW" data-count="1"` and `data-version="vOLD" data-count="1"`.
- For AC2: the admin approves `vNEW` with the SHA-256 of bytes B, but the HTTPS server serves B with one byte changed; the admin pins `vNEW` for everyone. X's run returns `failed` with outcome `checksum_mismatch`; X's exe still holds the old bytes; no `<exe>.new` and no `<exe>.old` exist; the state file has no pending update; the page's row for X carries `data-failure="checksum_mismatch"` and `data-failure-target="vNEW"`. The bearer token was never sent to the download server (the server records its request headers).
- For AC3 (`selfupdate/ac3_process_test.go`, no control plane): the test binary copies itself to `<dir>/leorna-client` as "v1.0.0, healthy" and to `<dir>/leorna-client.new` as "v1.1.0, fails to start" (a trailer appended to the copy tells the helper its version and behaviour; `TestMain` runs the helper when the trailer is present). Launch 1: the v1.0.0 process installs the new file over itself (`Install`) and exits. Launch 2: the file at the path is v1.1.0; its guard records the launch and copies the database file, then the process exits 3 before confirming. Launch 3 ("the next launch"): the guard puts v1.0.0 back, restores the database copy, relaunches; the relaunched v1.0.0 confirms and writes `started v1.0.0` to a marker file. The test asserts: exe bytes equal the v1.0.0 copy; marker says v1.0.0; the state has no pending update, one queued `start_failed` report for `v1.1.0` and a 24-hour block on that SHA-256; the database file equals the pre-update copy. A second subtest: a launch of v1.1.0 while the first v1.1.0 process is still running does not roll back.
- For AC4: the admin approves `vA` and `vB` and pins `vB`; X (reporting `vA`) installs `vB`. The admin pins `vA` again (the rollback). X (now reporting `vB`) runs: `installed`, exe holds vA's bytes, pending update to `vA`; X checks in as `vA`: `current`. The page shows `data-version="vA" data-count="1"` and no row counting X on `vB`.
- For AC5: 20 fresh installations, no group ticked, no pin. At 0% every check answers no target; at 25% the covered set is S25; at 50% S50 contains all of S25; at 100% all 20 are covered. Covered is read with the engine's own result (`disabled` when a target exists and updating is off, `no_target` otherwise), so nothing is downloaded.
- For AC6 (`api/contract_update_test.go`): the snapshot `api/control-plane.openapi.yaml` has the paths `/v1/client/update-check` and `/v1/client/update-reports` with operation IDs `checkClientUpdate` and `reportClientUpdateFailure`; reflection over the generated types gives exactly the JSON fields `{installationId, currentVersion, platform}`, `{target}`, `{version, sha256, downloadUrl}` and `{installationId, fromVersion, targetVersion, outcome}`; the outcome enum is exactly `checksum_mismatch, download_failed, install_failed, start_failed`; the two literal JSON bodies in D2 decode into the generated types.
- For AC7 (`selfupdate/ac7_windows_test.go`, `//go:build windows`): the AC3 scenario on NTFS (`t.TempDir()` is under `%TEMP%`), plus: while the v1.0.0 process is running, a plain overwrite of its exe fails (the reason for rename-then-rename), and `Install` still succeeds.

### Supporting receipts (not ac-check rows; the verifier runs them and names both heads)

- Control plane, Postgres (`LEORNA_TEST_DATABASE_URL`), `./internal/web/`: `TestClientUpdateTeamRolloutTargetsOnlyMembersWithPostgres` (team targeting, which the dev-mode end-to-end run can't show), `TestClientVersionsAdminOnlyAndTenantIsolatedWithPostgres`, `TestClientUpdateCheckValidatesAndRecordsInstallationWithPostgres`, `TestClientUpdateFailureReportBelongsToCallerWithPostgres`, `TestClientVersionsPageFormsWithPostgres`; `./internal/store/postgres/`: `TestClientUpdatesMigrationUpDownUp`, `TestClientVersionPolicyRevisionConflict`, `TestClientInstallationsCappedPerUser`; `./internal/clientupdate/`: `TestResolve`, `TestBucketIsStableAndSpread`, `TestValidVersion`, `TestValidDownloadURL`.
- Client: `./selfupdate/` unit tests on fakes (`TestRun*`, `TestGuard*`, `TestDownload*`, `TestStateFile*`), `./desktop/` `TestSelfUpdateWorker*`, `node --test scripts/update-ui.test.cjs`.
- Cross-repo tie: `cmp <client>/api/control-plane.openapi.yaml <control-plane>/contracts/control-plane.openapi.yaml` exits 0 on the two story heads. Every end-to-end log prints `control plane build: vcs.revision=<sha> vcs.modified=false`; the verifier and auditor check that SHA is the control-plane story head.

## What exists today (checked at the base SHAs)

- **Release assets** (86bcm9033, complete): `leorna-client.exe` and `leorna-client.exe.sha256` (sha256sum format: `<64 hex>  leorna-client.exe`) on `vX.Y.Z` (stable), `vX.Y.Z-rc.N` (prerelease) and the rolling `client-edge` prerelease; tag grammar `^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(?:-rc\.([1-9][0-9]*))?$` (client `scripts/release.py:16`, `.github/workflows/ci.yml` job `release`, `docs/release-pipeline.md`). Published today: `v0.2.0-rc.1` and `client-edge`. Download link shape: `https://github.com/LeornaAI/leorna-client/releases/download/<tag>/leorna-client.exe`.
- **Both repos are private**, so that link answers 404 without a GitHub login (Q1).
- **The exe carries no version**: `scripts/build-windows-client.ps1` builds with `-ldflags=-H windowsgui` only. This story stamps it.
- **Client → control plane today:** generated OpenAPI client with a one-hour bearer token from the device sign-in (`login/manager.go`), scope `bundle:read usage:write`, 64 KiB response cap, redirects off; the token maps to a user and tenant (`internal/clientauth/README.md`, migration `000008`). There is **no device or installation identity and no version report or heartbeat**. The newest client → server report is the managed-file report (`POST /v1/client/projects/{projectId}/drift-reports`, `internal/web/client_drift.go`, `internal/store/postgres/drift.go`, migration `000029`, admin page `internal/web/drift_view.go`): this story follows that pattern.
- **Groups:** `teams` and `team_memberships` (migration `000003`), users have role `admin` or `member`. No client group exists.
- **Admin console:** server-rendered pages under `/admin/...` behind `requireSession(requireAdmin(...))` with a CSRF cookie + `csrfToken` form field (`internal/web/handler.go:236-330`, `internal/web/cost_alerts.go:58-74`); they are not in OpenAPI. Admin changes write audit records inside the same transaction (`appendAudit`, `internal/store/postgres/audit.go:13`).
- **Migrations:** newest is `000031_cost_alert_refresh`; this story takes `000032`.
- **Client startup:** `cmd/leorna-client/main.go` (build tag `desktop`): `application.OpenDefault` opens and migrates `%APPDATA%\Leorna\leorna.db`, then `wails.Run`; `--verify-startup` opens the database and exits (CI uses it). `desktop.Bridge.Startup` starts two background workers (startup Sync, managed-file reports) that take `syncMu`. An older client refuses a newer local database: `application/application.go:235-237` returns "unsupported local database version" and `main` exits; D8's database copy exists because of this.
- **Windows CI** tests only `./application ./login ./toolconnector/...` (`ci.yml`, job `windows-client`); a new package isn't run there, and the standing rule is no workflow edits (`no-ci-changes.md`).

## Proved on this plan's own text (planner, 2026-11-10, scratch copies only)

- **D2's YAML:** a script pulled the two fenced YAML blocks from D2, spliced them into a `git archive` copy of the control-plane base (paths before `/v1/client/context/events:`, schemas before `ClientDriftReport:`) and ran `go generate` in `packages/contracts`: exit 0, `go build ./...` exit 0. Generated: `ClientUpdateDecision{Target *ClientUpdateTarget}` (`json:"target,omitempty"`), `ClientUpdateCheck`, `ClientUpdateFailure`, server methods `CheckClientUpdate` and `ReportClientUpdateFailure`, and the outcome constants `ChecksumMismatch`, `DownloadFailed`, `InstallFailed`, `StartFailed` (type `ClientUpdateFailureOutcome`).
- **D3's SQL:** pulled from the plan and applied after the 31 base migrations on a throwaway Postgres 18.6 container (CI's image, removed afterwards): 5 tables and 2 indexes created; a bad version, an `http://` link, a percentage without a rollout version and an unapproved pin were each refused; deleting a release that is rolling out was refused by the foreign key; deleting an installation removed its rollout row; the down order and a second up both worked.
- **Base failure shape:** a test file in a new `selfupdate` folder on a clean export of client `a7839b3` fails with `undefined: Updater` / `undefined: api.CheckClientUpdateJSONRequestBody` and `[build failed]`, which `ac-check.sh` accepts as failing on the base.
- **Windows through WSL:** a cgo-free `GOOS=windows` test binary of such a package (importing `api`, `login`, `onboarding`) built (7 MB) and ran `--- PASS` natively from this WSL session.
- Not proved here (needs the feature): the Go cookie jar against the dev server (task C1 proves it first).

## Design

### D1. Versions

A version is a release tag: `vX.Y.Z` or `vX.Y.Z-rc.N` (the grammar above). The client knows its own version from a build stamp (D9); an unstamped build reports `dev`. Updating compares for **inequality**, not "newer": that is what makes a rollback work.

### D2. Contract (`contracts/control-plane.openapi.yaml`, then both repos regenerate)

Add after the `drift-reports` path:
```yaml
  /v1/client/update-check:
    post:
      operationId: checkClientUpdate
      summary: Report this desktop installation's version and learn which version the administrator wants it to run
      security:
        - clientBearer: []
      requestBody:
        required: true
        content:
          application/json:
            schema: {$ref: '#/components/schemas/ClientUpdateCheck'}
      responses:
        '200':
          description: The approved version for this installation. target is absent when no version is pinned for it.
          content:
            application/json:
              schema: {$ref: '#/components/schemas/ClientUpdateDecision'}
        '400': {$ref: '#/components/responses/InvalidRequest'}
        '401': {$ref: '#/components/responses/Unauthorized'}
        '403': {$ref: '#/components/responses/Forbidden'}
        '503': {$ref: '#/components/responses/ClientSessionUnavailable'}
  /v1/client/update-reports:
    post:
      operationId: reportClientUpdateFailure
      summary: Report that this installation could not move to the version it was told to run
      security:
        - clientBearer: []
      requestBody:
        required: true
        content:
          application/json:
            schema: {$ref: '#/components/schemas/ClientUpdateFailure'}
      responses:
        '204': {description: Failure recorded for this installation}
        '400': {$ref: '#/components/responses/InvalidRequest'}
        '401': {$ref: '#/components/responses/Unauthorized'}
        '403': {$ref: '#/components/responses/Forbidden'}
        '404': {$ref: '#/components/responses/NotFound'}
        '503': {$ref: '#/components/responses/ClientSessionUnavailable'}
```
Add under `components.schemas`:
```yaml
    ClientUpdateCheck:
      type: object
      additionalProperties: false
      required: [installationId, currentVersion, platform]
      properties:
        installationId: {type: string, format: uuid}
        currentVersion: {type: string, minLength: 1, maxLength: 64, pattern: '^[A-Za-z0-9._+-]+$'}
        platform: {type: string, enum: [windows, darwin, linux]}
    ClientUpdateTarget:
      type: object
      additionalProperties: false
      required: [version, sha256, downloadUrl]
      properties:
        version: {type: string, pattern: '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-rc\.[1-9][0-9]*)?$'}
        sha256: {type: string, pattern: '^[a-f0-9]{64}$'}
        downloadUrl: {type: string, maxLength: 2048, pattern: '^https://'}
    ClientUpdateDecision:
      type: object
      additionalProperties: false
      properties:
        target: {$ref: '#/components/schemas/ClientUpdateTarget'}
    ClientUpdateFailure:
      type: object
      additionalProperties: false
      required: [installationId, fromVersion, targetVersion, outcome]
      properties:
        installationId: {type: string, format: uuid}
        fromVersion: {type: string, minLength: 1, maxLength: 64, pattern: '^[A-Za-z0-9._+-]+$'}
        targetVersion: {type: string, minLength: 1, maxLength: 64, pattern: '^[A-Za-z0-9._+-]+$'}
        outcome: {type: string, enum: [checksum_mismatch, download_failed, install_failed, start_failed]}
```
`target` is optional, not nullable: oapi-codegen v2.8.0 then generates a plain pointer on both sides. The token's scope stays `bundle:read usage:write` (no migration, nobody signs in again). Literal bodies both repos' tests decode (the cheap cross-repo tie):
```json
{"target":{"version":"v1.3.0","sha256":"2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae","downloadUrl":"https://github.com/LeornaAI/leorna-client/releases/download/v1.3.0/leorna-client.exe"}}
```
```json
{}
```
Handlers (`internal/web/client_update.go`, following `RecordClientDriftReport`): JSON content type, 4 KiB body cap, `DisallowUnknownFields`, one JSON value; errors `INVALID_UPDATE_CHECK` / `INVALID_UPDATE_REPORT` (400), `CLIENT_UPDATES_UNAVAILABLE` (503); `Cache-Control: no-store`; both routes added to the `requireClient` list in `handler.go`. The user and tenant always come from the token, never from the body.

### D3. Tables (`internal/store/postgres/migrations/000032_client_updates.up.sql`)

```sql
CREATE TABLE client_releases (
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
 version text NOT NULL CHECK (version ~ '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-rc\.[1-9][0-9]*)?$'),
 sha256 text NOT NULL CHECK (sha256 ~ '^[a-f0-9]{64}$'),
 download_url text NOT NULL CHECK (download_url ~ '^https://' AND char_length(download_url) <= 2048),
 approved_by uuid NOT NULL,
 approved_at timestamptz NOT NULL DEFAULT now(),
 PRIMARY KEY (tenant_id, version)
);
CREATE TABLE client_version_policies (
 tenant_id uuid PRIMARY KEY REFERENCES tenants(id) ON DELETE CASCADE,
 pinned_version text NULL,
 rollout_version text NULL,
 rollout_percent integer NOT NULL DEFAULT 0 CHECK (rollout_percent BETWEEN 0 AND 100),
 revision integer NOT NULL DEFAULT 1 CHECK (revision >= 1),
 updated_by uuid NOT NULL,
 updated_at timestamptz NOT NULL DEFAULT now(),
 FOREIGN KEY (tenant_id, pinned_version) REFERENCES client_releases(tenant_id, version),
 FOREIGN KEY (tenant_id, rollout_version) REFERENCES client_releases(tenant_id, version),
 CHECK (rollout_version IS NOT NULL OR rollout_percent = 0)
);
CREATE TABLE client_installations (
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
 installation_id uuid NOT NULL,
 user_id uuid NOT NULL,
 current_version text NOT NULL CHECK (current_version ~ '^[A-Za-z0-9._+-]{1,64}$'),
 platform text NOT NULL CHECK (platform IN ('windows','darwin','linux')),
 first_seen_at timestamptz NOT NULL,
 last_seen_at timestamptz NOT NULL,
 failure_outcome text NULL CHECK (failure_outcome IN ('checksum_mismatch','download_failed','install_failed','start_failed')),
 failure_from_version text NULL,
 failure_target_version text NULL,
 failure_at timestamptz NULL,
 PRIMARY KEY (tenant_id, installation_id),
 FOREIGN KEY (tenant_id, user_id) REFERENCES users(tenant_id, id) ON DELETE CASCADE
);
CREATE INDEX client_installations_seen_idx ON client_installations (tenant_id, last_seen_at DESC);
CREATE INDEX client_installations_user_idx ON client_installations (tenant_id, user_id, last_seen_at DESC);
CREATE TABLE client_rollout_teams (
 tenant_id uuid NOT NULL REFERENCES client_version_policies(tenant_id) ON DELETE CASCADE,
 team_id uuid NOT NULL,
 PRIMARY KEY (tenant_id, team_id),
 FOREIGN KEY (tenant_id, team_id) REFERENCES teams(tenant_id, id) ON DELETE CASCADE
);
CREATE TABLE client_rollout_installations (
 tenant_id uuid NOT NULL REFERENCES client_version_policies(tenant_id) ON DELETE CASCADE,
 installation_id uuid NOT NULL,
 PRIMARY KEY (tenant_id, installation_id),
 FOREIGN KEY (tenant_id, installation_id) REFERENCES client_installations(tenant_id, installation_id) ON DELETE CASCADE
);
```
Down file: drop the five tables in reverse order. Purely additive, no data backfill, safe to roll the server back (old servers ignore the tables). Add the five names to `resetDatabase`'s drop list in `internal/store/postgres/store_test.go` (line 499). If a sibling story lands `000032` first, renumber to the next free number (the `leorna` skill, step 7.2, has the check and the recovery note for the PR).

### D4. Rules (`internal/clientupdate/clientupdate.go`, pure, no I/O)

```go
package clientupdate

const ActiveWindow = 30 * 24 * time.Hour
const MaxInstallationsPerUser = 20

type Release struct{ Version, SHA256, DownloadURL, ApprovedBy string; ApprovedAt time.Time }
type Policy struct {
	PinnedVersion, RolloutVersion string // "" = none
	RolloutPercent                int
	RolloutTeamIDs                []string
	RolloutInstallationIDs        []string
	Revision                      int // 0 = no policy saved yet
}
type CheckIn struct{ InstallationID, CurrentVersion, Platform string }
type Target struct{ Version, SHA256, DownloadURL string }
type Failure struct{ InstallationID, FromVersion, TargetVersion, Outcome string }

func ValidVersion(v string) bool      // the release tag grammar
func ValidReported(v string) bool     // ^[A-Za-z0-9._+-]{1,64}$ ("dev" is valid here)
func ValidSHA256(s string) bool       // ^[a-f0-9]{64}$
func ValidDownloadURL(raw string) bool // https, a host, no user info, no fragment, at most 2048 bytes
func ValidOutcome(s string) bool
func DefaultDownloadURL(version string) string // https://github.com/LeornaAI/leorna-client/releases/download/<version>/leorna-client.exe
func Bucket(installationID, version string) int // binary.BigEndian.Uint32(sha256(installationID+"\n"+version)[:4]) % 100
// Resolve returns the version this installation should run, or "".
func Resolve(policy Policy, installationID string, inRolloutGroup bool) string
```
`Resolve`: if `RolloutVersion != ""` and (`inRolloutGroup` or `Bucket(installationID, RolloutVersion) < RolloutPercent`) → `RolloutVersion`; otherwise `PinnedVersion`. `inRolloutGroup` is "this installation is ticked, or its user is a member of a ticked team". The bucket includes the version, so each rollout picks a different share; raising the percentage only adds clients.

Admin actions and their meaning:
- **Approve a version:** version + SHA-256 + download link (empty link = `DefaultDownloadURL`). Approving the same version again with the same values is a no-op; with different values it is refused (`store.ErrConflict`): remove it first.
- **Remove an approved version:** refused while it is pinned or rolling out.
- **Pin for everyone:** sets `pinned_version` (or "No pin") and **ends any staged rollout** (clears rollout version, percentage, teams and clients). This is also "promote the rollout" and "roll back".
- **Staged rollout:** an approved version + percentage 0–100 + ticked teams + ticked clients; replaces the previous rollout.
- **Stop rollout:** clears it; rollout clients fall back to the pin on their next check.

### D5. Store (`internal/store/postgres/client_updates.go`)

```go
func (database *Store) ApproveClientRelease(ctx context.Context, actor store.Principal, release clientupdate.Release) error
func (database *Store) RemoveClientRelease(ctx context.Context, actor store.Principal, version string) error
func (database *Store) SaveClientVersionPolicy(ctx context.Context, actor store.Principal, policy clientupdate.Policy, expectedRevision int) error
func (database *Store) GetClientVersions(ctx context.Context, actor store.Principal) (clientupdate.Overview, error)
func (database *Store) CheckInClient(ctx context.Context, actor store.Principal, checkIn clientupdate.CheckIn) (*clientupdate.Target, error)
func (database *Store) RecordClientUpdateFailure(ctx context.Context, actor store.Principal, failure clientupdate.Failure) error
```
- The first four are admin-only: `beginOrg(ctx, actor, true)` for writes (it checks the tenant in the context and the admin role inside the transaction), `CurrentRole` for the read; every query filters by `actor.TenantID`. Writes call `appendAudit` in the same transaction: actions `client_release.approve`, `client_release.remove`, `client_version_policy.update`, target `client-versions`, before/after = the release or the whole policy (no secrets exist here).
- `SaveClientVersionPolicy` takes `pg_advisory_xact_lock(hashtextextended(tenant||':client-version-policy',0))`, compares `expectedRevision` with the stored revision (0 when no row) and returns `store.ErrConflict` on a mismatch; checks every version is approved, every team and installation belongs to the tenant (`org.ErrInvalid` otherwise); upserts the row with `revision+1` and replaces the two rollout tables.
- `CheckInClient` (any signed-in member; `orgScope` first): in one transaction upsert the installation (`ON CONFLICT (tenant_id, installation_id) DO UPDATE` user, version, platform, `last_seen_at`; times from `database.now()`), delete that user's installations beyond the newest `MaxInstallationsPerUser` by `last_seen_at`, read the policy and whether the installation is in the rollout group (ticked, or `EXISTS` a ticked team joined to `team_memberships` for `actor.UserID`), call `clientupdate.Resolve`, and load the release → `*Target` (nil when the version is "").
- `RecordClientUpdateFailure`: `UPDATE client_installations SET failure_* … WHERE tenant_id=$1 AND installation_id=$2 AND user_id=$3`; zero rows → `store.ErrNotFound` (a caller can only report for its own installation). A later check-in whose `current_version` equals `failure_target_version` clears the failure.
- `Overview`: releases (newest first), policy with team and client names, counts per `current_version` for installations with `last_seen_at >= now - ActiveWindow` (ordered by count then version), the number of older installations left out, and the 200 most recently seen installations (user email, version, platform, last seen, in rollout or not, failure).

### D6. Wiring in the control plane

`internal/web/handler.go`: field `clientUpdates clientUpdateStore`, `SetClientUpdates`, the two client routes in the `requireClient` list, the three admin routes, and `· <a href="/admin/client-versions">Client versions</a>` after "Managed file status" in the admin nav (line 808). `cmd/control-plane/main.go`: `application.SetClientUpdates(repository)` next to `SetDriftStore`. A nil store answers 503 `CLIENT_UPDATES_UNAVAILABLE`. No new environment variable and no deploy change.

### D7. Admin page (`internal/web/client_versions.go`) — the form fields are a fixed contract (the client's end-to-end tests post them)

Routes: `GET /admin/client-versions` (`requireSession(requireAdmin(...), true)`), `POST /admin/client-versions` (`..., false`). The POST follows `costAlertsSave`: form-encoded only, `maxFormBytes`, CSRF cookie against `csrfToken` in constant time (403 `CSRF_REJECTED`), then `action`:

| `action` | Fields | Result |
| --- | --- | --- |
| `approve` | `version`, `sha256` (lower-cased and trimmed; a pasted `.sha256` line `"<hex>  leorna-client.exe"` is accepted and cut to the hex), `download_url` (optional) | 303 to the page; invalid → 400 page with `role="alert"`; different values for an approved version → 409 page |
| `remove` | `version` | 303; in use → 409 page |
| `pin` | `version` (empty = no pin), `expected_revision` | 303; stale revision → 409 page |
| `rollout` | `version`, `percent` (0–100), `team` (repeated team IDs), `installation` (repeated installation IDs), `expected_revision` | 303; invalid → 400 page; stale → 409 page |
| `stop-rollout` | `expected_revision` | 303 |

Any other field name, a repeated single-value field or an unknown `action` → 400. Page sections, in order: "Clients by version" (the counts, with the 30-day sentence and the left-out number), "Current policy" (pin; rollout version, percentage, teams, clients), the forms, "Approved versions" (version, SHA-256, link as text, who/when, Remove), "Clients" (engineer email, short installation ID, version, platform, last seen, in rollout, last failure). All values go through `html/template`; the page sets the same CSP/nonce headers as `driftView` and `Cache-Control: no-store`; it has no script.

Stable markers the tests read (keep them exactly):
- `<main data-revision="N">` (N = the policy revision, 0 before the first save);
- counts: `<tr data-version="v1.3.0" data-count="2">`;
- clients: `<tr data-installation="<uuid>" data-current="v1.2.0" data-in-rollout="true|false" data-failure="checksum_mismatch|…|" data-failure-target="v1.3.0|">`;
- approved versions: `<tr data-release="v1.3.0">`.

### D8. Client: package `selfupdate` (new top-level folder; pure Go, no cgo, imports only `api`, `x/sys/windows` and the standard library)

**Version (`version.go`):** `var Version = "dev"` (stamped with `-X github.com/LeornaAI/leorna-client/selfupdate.Version=<tag>`), `func ReleaseBuild() bool` (the tag grammar).

**State file (`state.go`):** `update-state.json` next to `leorna.db` (`%APPDATA%\Leorna\`), not in SQLite, because the launch guard must read it before the database opens and a broken new version may fail in the database migration. Written to a temp file, synced, then renamed; mode 0600. A file that doesn't parse is renamed to `update-state.json.corrupt` and treated as empty.
```go
type State struct {
	InstallationID string          `json:"installationId"` // uuid v4, made on first use
	Pending        *PendingUpdate  `json:"pending,omitempty"`
	Blocked        *BlockedTarget  `json:"blocked,omitempty"`
	Reports        []FailureReport `json:"reports,omitempty"` // not yet delivered, at most 20
}
type PendingUpdate struct {
	FromVersion, ToVersion, ToSHA256 string
	Launches                         int
	LaunchPID                        int
	DatabaseCopied                   bool
}
type BlockedTarget struct{ SHA256 string; Until time.Time }
type FailureReport struct{ FromVersion, TargetVersion, Outcome string }
```

**Engine (`updater.go`):**
```go
type ControlPlane interface {
	CheckClientUpdateWithResponse(context.Context, api.CheckClientUpdateJSONRequestBody, ...api.RequestEditorFn) (*api.CheckClientUpdateResponse, error)
	ReportClientUpdateFailureWithResponse(context.Context, api.ReportClientUpdateFailureJSONRequestBody, ...api.RequestEditorFn) (*api.ReportClientUpdateFailureResponse, error)
}
type Verifier interface{ Verify(ctx context.Context, path string, target Target) error }
type Updater struct {
	ExePath, StatePath, Version, Platform string
	Enabled   bool          // the caller sets ReleaseBuild() && runtime.GOOS == "windows"
	Download  *http.Client  // nil = NewDownloadClient()
	Verifiers []Verifier    // nil = []Verifier{ChecksumVerifier{}}
	MaxBytes  int64         // 0 = 256 MiB
	Now       func() time.Time
}
type Result struct{ State, Version, TargetVersion, Outcome string }
func (u *Updater) Run(ctx context.Context, cp ControlPlane) (Result, error)
```
`Run`, in order:
1. Load the state (make the installation ID). Send each queued report; drop it on 204 or 404, keep it otherwise.
2. `POST /v1/client/update-check` with the installation ID, `Version`, `Platform`. This always runs, also for `dev` builds and on macOS/Linux, so the console can count them. 404 or 405 (an older control plane) → `Result{State: "unsupported"}`; 401 → `signed_out`; other non-200 → `unavailable`.
3. No target → `no_target`. `target.Version == Version` → `current` (and a matching `Blocked` is cleared). Target SHA-256 equals `Blocked.SHA256` and `Now() < Until` → `blocked`. `!Enabled` → `disabled`. A target that fails the D2 patterns → failure `download_failed`.
4. Download `target.DownloadUrl` with `Download` to `<ExePath>.new` (remove a stale one first; create with `O_EXCL`, mode 0700): status must be 200; copy through a `MaxBytes+1` limit (over it → `download_failed`); sync and close.
5. Run every `Verifier` on the file on disk. `ChecksumVerifier` re-reads the file, hashes it with SHA-256 and compares with `target.SHA256` in constant time; a mismatch is `checksum_mismatch`. **This list is the seam for 86bcm9031:** the signing story appends an Authenticode verifier here; nothing else changes.
6. `Install`: save `Pending{FromVersion: Version, ToVersion, ToSHA256}`; remove a stale `<ExePath>.old`; rename `ExePath` → `<ExePath>.old`; rename `<ExePath>.new` → `ExePath`. If the second rename fails, rename `.old` back, clear `Pending`, failure `install_failed`. Success → `Result{State: "installed"}`; the caller restarts.
7. Any failure: delete `<ExePath>.new`, set `Blocked{target SHA-256, Now()+1h}`, report it now (queue it in `Reports` if the POST fails), return `Result{State: "failed", Outcome: …}`. The current exe is never touched before step 6.

`NewDownloadClient()`: its own `http.Client` with a 10-minute timeout; `CheckRedirect` allows at most 5 hops and only `https` (GitHub redirects release downloads to its file host). The engine refuses a non-`https` link itself. **No `Authorization` header is ever set on a download request.**

Paths: `ExePath` is `os.Executable()` resolved with `filepath.EvalSymlinks`; `.new`, `.old`, `.failed` are that path plus a fixed suffix, so they are in the same folder and volume. Nothing from the server is ever part of a path.

**Launch guard (`guard.go`):**
```go
type GuardOptions struct {
	ExePath, StatePath, DatabasePath, Version string
	PID      int
	Alive    func(pid int) bool    // processAlive: x/sys/windows OpenProcess+GetExitCodeProcess, or kill(pid, 0)
	Relaunch func(exe string) error
	Now      func() time.Time
}
func GuardLaunch(o GuardOptions) (exit bool, err error)
func ConfirmStarted(statePath, exePath, databasePath, version string) error
```
`GuardLaunch` (no network; an error is logged by the caller and startup continues):

| State file says | Running exe is | Action |
| --- | --- | --- |
| no pending update | any | continue |
| pending, `Launches == 0` | `ToVersion` | copy `leorna.db` to `leorna.db.pre-update` (when it exists), set `Launches=1`, `LaunchPID`, `DatabaseCopied`; save; continue |
| pending, `Launches >= 1`, `Alive(LaunchPID)` | `ToVersion` | another start is still under way: continue, change nothing |
| pending, `Launches >= 1`, not alive, `<exe>.old` exists | `ToVersion` | the new version failed to start: rename exe → `<exe>.failed`, `<exe>.old` → exe; if `DatabaseCopied`, move `leorna.db` to `leorna.db.failed-update` and the copy back; queue a `start_failed` report; `Blocked{ToSHA256, Now()+24h}`; clear pending; save; `Relaunch(exe)`; return `exit=true` |
| same, `<exe>.old` missing | `ToVersion` | nothing to go back to: queue `start_failed`, clear pending, continue |
| pending | `FromVersion` | the swap never finished: remove `<exe>.new`, clear pending, continue |
| pending | anything else | stale: clear pending, continue |

`ConfirmStarted` (called when the window has loaded): if a pending update to this version exists, clear it; then delete `<exe>.old`, `<exe>.failed`, `<exe>.new`, `leorna.db.pre-update` and `leorna.db.failed-update` if present (errors ignored; retried at the next start).

**Relaunch (`relaunch_windows.go`, `relaunch_other.go`):** `exec.Command(exe).Start()` without waiting; on Windows with `DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP`. The child inherits the environment (so a test profile's `APPDATA` carries over).

### D9. Client wiring

- `desktop/selfupdate.go` (no build tag, so `make check` tests it): `GuardLaunch(args []string) bool` (false at once for `--verify-startup`; builds `GuardOptions` from `os.Executable()`, `application.DefaultDatabasePath()` and `selfupdate.Version`), `ConfirmStarted()`, `Relaunch()`, the worker, and the bridge methods `SelfUpdateStatus()` (bound to the window) and `RelaunchRequested()`.
- Worker `runSelfUpdateWorker(ctx)`, started in `Bridge.Startup` beside the two existing workers and awaited in `Shutdown`: first check 3 s after startup, then every 6 hours; 5 minutes after `signed_out` or `unavailable`. Each check takes `b.syncMu` with `TryLock` (retry each second, like the drift worker) and holds it through download and install, so it never runs during a Sync, Restore or tool install. It builds the client with `b.login.Client(company)` (the existing bearer client; both new responses fit its 64 KiB cap). On `installed`: publish the status, set `b.relaunch`, call the injected `b.quit` (default `wailsruntime.Quit(b.runtimeContext)`), return.
- `cmd/leorna-client/main.go` (tag `desktop`; kept to three small edits because `make check` doesn't compile it, only the Windows CI build does): `if desktop.GuardLaunch(os.Args[1:]) { return }` as the first statement; `OnDomReady: func(context.Context) { desktop.ConfirmStarted() }`; after `wails.Run` returns, `if bridge.RelaunchRequested() { desktop.Relaunch() }`. Relaunching after `wails.Run` means the database is already closed when the new exe starts.
- Window: `<p id="update-status" role="status" aria-live="polite"></p>` in `index.html` and a new `frontend/dist/update.js` (+ one `<script>` line) that calls `SelfUpdateStatus()` and listens to the `self-update` event. Texts: "Leorna v1.2.0", "Updating Leorna to v1.3.0…", "Update to v1.3.0 was refused: the download did not match its checksum. Staying on v1.2.0.", "Update to v1.3.0 could not be installed. Staying on v1.2.0.", "Leorna went back to v1.2.0 because v1.3.0 did not start." Test: `scripts/update-ui.test.cjs` in the style of `scripts/login-ui.test.cjs`.
- `scripts/build-windows-client.ps1`: version = `$env:GITHUB_REF_NAME` when `$env:GITHUB_REF_TYPE -eq 'tag'`, else `$env:LEORNA_CLIENT_VERSION` when set, else `dev`; throw unless it is `dev` or matches the tag grammar; ldflags become `-H windowsgui -X github.com/LeornaAI/leorna-client/selfupdate.Version=$version`. No workflow edit: GitHub sets those two variables in every step. Builds from `main` (the edge channel) stay `dev`, so they report in but never replace themselves.
- `Makefile`: add `selfupdate` to the `fmt` target's folder list.

### D10. End-to-end harness (`selfupdate/e2e_harness_test.go`, used by the AC1, AC2, AC4, AC5 tests)

`newE2E(t)` skips unless the three `LEORNA_E2E_*` variables are set, then:
1. reads the binary's build info (`debug/buildinfo.ReadFile`), fails unless `vcs.revision` is set and `vcs.modified=false`, and logs `control plane build: vcs.revision=<sha> vcs.modified=false`;
2. copies the manifest with `server.address` set to a free loopback port and starts the binary with `LEORNA_MANIFEST_PATH`, `LEORNA_DEV_MODE=1`, `LEORNA_AUTO_SETUP=1`, `LEORNA_PUBLIC_BASE_URL=https://demo.leorna.invalid`, a random `LEORNA_SECRET_ENCRYPTION_KEY` (32 random bytes, base64) and `LEORNA_DATABASE_URL`; waits for `/readyz`; kills it in `t.Cleanup`. The server log goes to a temp file and is never printed whole (it may hold a tenant ID);
3. uses one `http.Client` whose transport sends `https://demo.leorna.invalid` requests to the loopback port over plain HTTP and keeps the Host header (the proven trick from `~/.hermes/plans/leorna/86bcm901r-ac4/client-sync.go`, type `loopback`), with a cookie jar. Because the URLs stay `https`, the jar keeps the `__Host-` Secure cookies and the server's host check (custom domain story) passes;
4. admin: `GET /dev/login?next=/admin/client-versions`; the CSRF value is the jar's CSRF cookie; `post(action, fields)` posts D7's form and returns the status; `page()` returns the HTML and the revision from `data-revision`;
5. client sign-in: `onboarding.HTTPResolver` on `demo.leorna.invalid`, `login.New(<in-memory vault>, client)`, `Begin`, `POST /client/authorize` with `user_code` and `csrf`, `Poll` until signed in; `manager.Client(company)` is the `ControlPlane` for every `Updater`. Several installations share the sign-in (as two PCs of one engineer would): each has its own temp folder with its own state file and "exe" file;
6. a local `httptest.NewTLSServer` serves the release bytes and records request headers; `Updater.Download` is that server's client;
7. when `LEORNA_E2E_SNAPSHOT_DIR` is set, each test writes the final page HTML to `<dir>/<test name>.html` for the screenshot (render it with headless Chrome; never screenshot the browser with a URL bar).

It prints no token, sign-in code, tenant ID or password. **First step of the client build:** prove steps 1–5 against a control-plane binary built from the control-plane base (dev login, device sign-in, `GET /v1/client/session` answers 200) before writing any AC test. If the cookie jar or host check doesn't behave as described, stop and report; the fallback is the headless-Chrome approval used by the 901r harness.

### D11. Security notes

- **Checksum source:** the SHA-256 comes only from the customer's own control plane over TLS, in an authenticated response; the download host is untrusted. A wrong file is deleted before the current exe is touched.
- **Trust limit (stated, not solved here):** whoever controls the tenant's admin console or the control plane can make clients run any exe with a matching checksum. That is inherent until 86bcm9031 adds the Authenticode check at the `Verifiers` seam; the admin page says "unsigned: the checksum is the only integrity check".
- **Tenant isolation:** every query filters by the token's or session's tenant; installation IDs, team IDs and versions from a form or body are checked to belong to that tenant inside the write transaction; counts and lists are admin-only; a member can only write its own installation's check-in and failure. Supporting test `TestClientVersionsAdminOnlyAndTenantIsolatedWithPostgres` covers: member 403 on the page and POST, signed-out redirect, tenant B's admin sees none of tenant A's versions, clients or counts, tenant A can't tick tenant B's team or installation, and tenant B's client is never handed tenant A's target.
- **Installation ID** is made by the client and is not a credential. A member who learns another member's ID could take over that row (last check-in wins); the IDs are random and shown only to admins. Rows per user are capped at 20 (oldest dropped), so a script can't flood the table or the counts beyond that.
- **Exe swap:** fixed suffixes beside the running exe; no server-supplied path parts; the download is created with `O_EXCL`; size cap 256 MiB; https only, including redirects; the bearer token is never sent to the download host.
- **Guards get mutation proof** (`mutation-testing-discipline`, under the 4G memory cap): the checksum comparison, the https-only checks, the admin check and tenant filters, the `user_id` filter in `RecordClientUpdateFailure`, the "not alive" condition in the guard.
- **No auth changes:** no dev-login stub, no new scope, no relaxed check; tests use the existing fixtures and the dev mode that already exists.

### D12. Docs

Control plane: new `internal/clientupdate/README.md` (what it does, the five tables, the two endpoints, the rules in D4, the trust limit, the test names); a short "Client versions" paragraph in `internal/web/README.md`; two lines in `docs/deploy/release-pipeline.md` (approve a version in the console with the SHA-256 from `leorna-client.exe.sha256`). Client: new `selfupdate/README.md` (flow, state file, guard table, the `Verifiers` seam for 86bcm9031, the dev/edge rule, the Windows CI gap); a "Self-update — 86bcxnymy" section in `README.md` naming the AC tests and how to run the end-to-end ones; two lines in `docs/release-pipeline.md` (the version stamp; the first self-updating version must be installed by hand once); one line in `api/README.md` (the two new operations use the ordinary 64 KiB bound).

### D13. Merge order

Control-plane PR first, then the client PR. A new client against an old control plane gets 404 from the check and stays quiet (`unsupported`); an old client never calls the new endpoints. The client's snapshot must be byte-identical to the control plane's contract at hand-over; if a sibling changes the contract on `main` first, bring `main` in, copy the snapshot again and regenerate.

## Skills

- Every role: `leorna`, then `engineering-best-practices`.
- Builders: `test-driven-development`, `mutation-testing-discipline` (the guards in D11), `security-best-practices`, `authorized-write-safety` (the client replaces its own exe; its rules on load-bearing guards and "offline proof is not acceptance" apply). Control-plane builder also: `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. Client builder also: `api-contract-drift-guard`, `frontend-testing-workflow` (the status line test).
- Reviewers: `requesting-code-review`, `code-review-practice`, plus `security-best-practices` and `multi-tenant-auth-management` for the control plane.
- Fixers: `receiving-code-review`, `test-driven-development`. Finisher: `receiving-code-review`, `git-commit-rules`, `github`.
- **These end with "Mandatory Validation and Agent Defect Loop":** `api-contract-drift-guard` and `backend-data-migrations` (checked with grep on 2026-11-10). `security-best-practices`, `multi-tenant-auth-management` and `authorized-write-safety` do not. The loop's agents are the pipeline's own fixer, reviewer and verifier; the main session starts them, no agent does.

## Two-repo verification mechanics (orchestrator)

- `ac-check.sh --repo <client worktree> --base a7839b3… --plan <evidence>/plan-approved.md --reviews <evidence> <evidence>/verifier/ac.json <evidence>/auditor/ac.json` covers AC1–AC7; AC8 is live.
- Reviews are per repo: `<evidence>/review-<n>/review.json` for the client (the `ac-check.sh` repo) and `<evidence>/control-plane/review-<n>/review.json` for the control plane (empty findings when clean). Run `review-check.sh` once per repo; MOVE ON needs both. Finding IDs stay `R<n>-<k>` in both folders.
- The verifier and the auditor each build the control-plane binary from the control-plane story head, run the supporting receipts and both repos' gates, run the `cmp`, and name both heads in their reports. A control-plane head change after acceptance needs review → verifier → auditor again, like a client change.
- Builder order (Q8): builder 1 builds Part 1 and stops at `ready-for-review` with its branch and head; builder 2 gets that head, builds Part 2 and stops. The control-plane review can start while builder 2 works.

## Host prerequisites (checked 2026-11-10 on the WSL desktop)

Go 1.27.3 at `~/.local/leorna-toolchain/go`, golangci-lint and govulncheck beside it; gcc present (cgo for the client's `make check`); `leorna-test-pg` exists but is **Exited**: `docker start leorna-test-pg`; Chrome for Testing at `~/.cache/chrome-for-testing/chrome-linux64/chrome`; gitleaks at `/usr/local/bin/gitleaks`; WSL interop runs Windows test binaries (AC7). No earlyoom kills in the last 2 hours. Gates: control plane `make check` + `bash ./scripts/test-module-add.sh`; client `make check` → `node --test scripts/*-ui.test.cjs` → `make lint audit` (`leorna` skill, `references/gates.md`). Keep `TMPDIR` short and real (`~/.cache/86bcxnymy-<role>/tmp`). Run mutation tests under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

## Tasks — Part 1: control plane (builder 1)

Worktree and branch `feat/86bcxnymy-client-self-update` from `4ef14ef…` (check GitHub `main` again first; if it moved, start from the new SHA and say so). One commit per task, `feat(86bcxnymy): …`, each green (`go build ./... && go vet ./...` plus the task's tests). Write each test first and see it fail for the stated reason. No `.github/` change.

- **P1. Rules.** `internal/clientupdate/clientupdate.go` + `clientupdate_test.go` (D4): `TestValidVersion` (accepts `v1.2.3`, `v0.2.0-rc.1`; refuses `1.2.3`, `v01.2.3`, `v1.2`, `v1.2.3-beta`, `client-edge`, 65 characters), `TestValidDownloadURL` (https only; refuses `http://`, user info, a fragment, an empty host, 2,049 bytes), `TestBucketIsStableAndSpread` (same input → same bucket; 10,000 random IDs land in every decile within 8–12%), `TestResolve` (table: no policy; pin only; rollout by group; by percentage just below and at the bucket; rollout wins over pin; outside both → pin; outside both with no pin → "").
- **P2. Migration.** `000032_client_updates.{up,down}.sql` (D3), the drop list in `store_test.go`; `TestClientUpdatesMigrationUpDownUp` (apply, drop, apply; the checks refuse a bad version, a non-hex SHA-256, an `http://` link, percentage 101, and a percentage above 0 without a rollout version).
- **P3. Store.** `internal/store/postgres/client_updates.go` + `client_updates_test.go` (D5): approve / idempotent re-approve / conflicting re-approve; remove refused while in use; policy save with revision check (`TestClientVersionPolicyRevisionConflict`), unknown version/team/installation refused, another tenant's team or installation refused; check-in upsert, the per-user cap (`TestClientInstallationsCappedPerUser`), rollout by ticked client and by team; failure record only for the caller's own installation and cleared by a later matching check-in; overview counts respect the 30-day window (inject the store clock); audit rows for all three actions; a member and another tenant's admin are refused on the admin methods.
- **P4. Contract.** D2's YAML into `contracts/control-plane.openapi.yaml`; `make generate`; add the two operations to `packages/contracts/roundtrip_test.go`'s server stub; a contracts test that decodes D2's two literal bodies. `make contracts-check` passes.
- **P5. Client endpoints.** `internal/web/client_update.go` + `client_update_test.go` (D2, D6): `TestClientUpdateCheckValidatesAndRecordsInstallationWithPostgres` (unknown field, bad UUID, bad version text, bad platform, two JSON values, 5 KiB body, wrong content type → 400; no token → 401; valid → 200 with and without `target`; the row carries the token's user and tenant), `TestClientUpdateFailureReportBelongsToCallerWithPostgres` (unknown installation and another user's installation → 404; valid → 204 and stored), `TestClientUpdateTeamRolloutTargetsOnlyMembersWithPostgres` (two members, one in the ticked team: only that one gets the target).
- **P6. Admin page.** `internal/web/client_versions.go` + `client_versions_test.go` (D7): `TestClientVersionsPageFormsWithPostgres` (every action's happy path and its 400/409 cases; the markers; CSRF missing/wrong → 403; a pasted `.sha256` line is accepted; default link when empty; pin clears the rollout), `TestClientVersionsAdminOnlyAndTenantIsolatedWithPostgres` (D11). Wire the routes, the nav link and `SetClientUpdates` (D6).
- **P7. Docs and record.** D12's control-plane files; append to `delivery/stories.json` as text, last entry: `"86bcxnymy": {"name": "Client self-update to the admin-approved version, with staged rollout", "prs": {"LeornaAI/leorna-control-plane": [], "LeornaAI/leorna-client": []}}` (check every earlier entry is unchanged by value).
- **P8. Gates, mutation proof, demo.** `make check` and `bash ./scripts/test-module-add.sh` with real exit codes saved to `<evidence>/builder-cp/`; mutation proof for D11's control-plane guards; run the server in dev mode on a throwaway database and save real page screenshots (empty page, after an approve + rollout) to `<evidence>/builder-cp/` (no URL bar, no tenant ID visible: the session card with the tenant ID is on `/admin`, not on this page). Stop at `ready-for-review`; report branch, head, and the exact form fields if anything in D7 had to differ (it shouldn't).

## Tasks — Part 2: client (builder 2)

Worktree and branch `feat/86bcxnymy-client-self-update` from `a7839b3…` (check GitHub `main` again first). Needs builder 1's control-plane head. Same commit rules; no `.github/` change; no new module (everything needed is vendored: `x/sys/windows`, `google/uuid`).

- **C1. Harness proof.** D10's first step against a control-plane binary built from the control-plane **base**: `selfupdate/e2e_harness_test.go` with a temporary `TestE2EHarnessSignsIn`. Stop and report if it can't sign in.
- **C2. Contract.** Copy the control plane's contract (builder 1's head) over `api/control-plane.openapi.yaml`, `make generate`, `make contracts-check`; `api/contract_update_test.go` with the AC6 test. The client's snapshot is already behind the control plane's contract at the bases (16 changed lines: the custom-domain header and reworded descriptions from the custom-domain, cost-alert and customise-item stories), so the whole-file copy brings those in too; keep that as its own commit (`chore(86bcxnymy): refresh the contract snapshot`) before the commit that uses the new operations, and name it in the PR text.
- **C3. State file and version.** `selfupdate/version.go`, `state.go` + tests (`TestStateFile*`: first use makes an ID and keeps it; atomic save; corrupt file set aside; at most 20 reports; mode 0600 off Windows).
- **C4. Download and verify.** `download.go`, `verify.go` + tests on a local TLS server (`TestDownload*`): 200 only; https only; a redirect to `http://` refused; more than 5 hops refused; over the size cap refused and the partial file removed; no `Authorization` header sent; `ChecksumVerifier` passes the right bytes and refuses one flipped byte and a truncated file.
- **C5. Engine.** `updater.go` + `updater_test.go` with a fake `ControlPlane` (`TestRun*`): every `Result.State` in D8; queued reports are sent first and dropped on 204/404; a failure is reported at once, or queued when the POST fails; `Blocked` stops a second attempt and is cleared when the target changes or is reached; an older target is installed like a newer one; install failure puts the old exe back.
- **C6. Guard and relaunch.** `guard.go`, `alive_windows.go`, `alive_other.go`, `relaunch_windows.go`, `relaunch_other.go` + `guard_test.go` (`TestGuard*`: one test per row of D8's table, plus `ConfirmStarted`'s cleanup) and the process tests for AC3 (`ac3_process_test.go`) and AC7 (`ac7_windows_test.go`); build and run AC7 through WSL interop.
- **C7. End-to-end ACs.** `ac_e2e_test.go` with the AC1, AC2, AC4 and AC5 tests against builder 1's control-plane head; remove C1's temporary test.
- **C8. Wiring.** `desktop/selfupdate.go` + `selfupdate_test.go` (`TestSelfUpdateWorker*`: waits for `syncMu`; `installed` sets relaunch and calls quit once; `signed_out` retries; `--verify-startup` skips the guard; shutdown stops the worker), the three edits in `main.go`, the fields in `bridge.go`; `GOOS=windows go vet` as in the gates reference; build the desktop binary with tags `desktop,production` for Linux if the host can, otherwise say that only Windows CI compiles `main.go`.
- **C9. Window line and build stamp.** `index.html`, `update.js`, `scripts/update-ui.test.cjs`; `scripts/build-windows-client.ps1` and `Makefile` (D9); a Go test that builds a tiny program importing `selfupdate` with the `-X` flag and checks it prints the stamped version (the `.ps1` itself runs only on Windows CI).
- **C10. Docs.** D12's client files.
- **C11. Gates, mutation proof, evidence.** `make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit`, with exit codes saved to `<evidence>/builder/`; mutation proof for D11's client guards; one log and one screenshot per AC1–AC7 (the page HTML from `LEORNA_E2E_SNAPSHOT_DIR` for AC1, AC2, AC4); `cmp` of the two contract files. Stop at `ready-for-review`.

## Docs & records (build and finish)

- Control plane: `internal/clientupdate/README.md` (new), `internal/web/README.md`, `docs/deploy/release-pipeline.md`, `delivery/stories.json` (entry at build time; PR numbers after the PRs exist, when Justin says so).
- Client: `selfupdate/README.md` (new), `README.md`, `docs/release-pipeline.md`, `api/README.md`; `PROJECT_MEMORY.md` progress line at "make a PR" (finisher).
- Shared Leorna notes (`~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`): a dated status line per stage (plan ready, built, reviewed, hand-over, PRs), by the main session or finisher; `MEMORY.md` one-liner if the summary changes.
- Plan: this file; the approved copy `<evidence>/plan-approved.md` (made by the main session at "go"); Justin's answers recorded at the top of this file.
- Evidence folder `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/`: `builder-cp/`, `builder/`, `review-<n>/`, `control-plane/review-<n>/`, `verifier/`, `auditor/`, `follow-ups.md`, hand-over drafts (two PR texts, review prompt, ClickUp comment draft with one screenshot per AC, team message), and the AC8 checklist with Justin's results.

## Live checklist for AC8 (Justin; after the reviews, verifier and auditor are clean)

Needs: your dev server running the story's control-plane build (local image mode); the client built twice from the story branch on Windows, `$env:LEORNA_CLIENT_VERSION='v0.0.1-rc.1'` then `'v0.0.1-rc.2'` before `scripts/build-windows-client.ps1`; `Get-FileHash` of both; both files on any HTTPS link that needs no login, plus a copy of rc.2 with one byte changed.
1. Start client A from its own folder. Start client B from another folder in a PowerShell window where `$env:APPDATA` points at an empty folder (that makes it a second installation). Both rc.1; sign both in.
2. Console → Client versions: two clients on rc.1. Approve rc.2 (SHA-256 + link). Staged rollout of rc.2 with only A ticked. Restart A (a check also runs every 6 hours): A updates itself and comes back as rc.2; B stays on rc.1. The page shows rc.2 = 1 and rc.1 = 1.
3. Approve `v0.0.1-rc.3` with rc.2's SHA-256 but the link to the changed file; staged rollout of rc.3 with only B ticked; restart B: B says the update was refused and stays on rc.1; the page shows `checksum_mismatch` for B.
4. Pin rc.1 for everyone; restart A: A goes back to rc.1; the page shows rc.1 = 2.

## Risks

- **Private repo (Q1):** with A, real customers can't download from GitHub until the release file is public; the story is demoable and testable before that, but not usable in production from the default link.
- **Local database and going back:** an older client refuses a database a newer one migrated. After a failed start the guard restores the copy it made, so that case is safe. After an **admin rollback across a release that changed the local database**, the older exe fails to start, the guard returns the client to the newer version and the console shows `start_failed`: safe, but the rollback doesn't take on those clients. A real fix (down-migrations or a longer-lived copy) is a follow-up.
- **The rollback code runs in the new version.** A new exe so broken that it can't reach the first line of `main` can't put the old one back. The checksum guarantees it is the released file, and CI launched that file on a clean Windows VM, so this needs a release that starts in CI and not at all on a customer PC.
- **A power cut between the two renames** leaves no exe at the path (`.old` and `.new` remain). Windows can't replace a running exe in one step; the window is microseconds.
- **The end-to-end tests are the AC tests**, so a harness problem fails four ACs together. C1 proves the harness before anything depends on it.
- **Windows CI doesn't run `./selfupdate`** (the workflow lists packages; no CI edits). AC7 through WSL interop and AC8 are the Windows proof; the PR's Assumptions say so.
- **Sibling stories** planned at the same time (86bcxnykn, 86bcm928p) will touch the contract, the migration number, `handler.go` and `delivery/stories.json`: see "Sibling work".
- **Installed clients today can't update themselves**; the first self-updating version is installed by hand once.
- **Builder 2 depends on builder 1's form fields.** D7 fixes them; any change there must be reported by builder 1.

## Choices made (say if you want any changed)

1. Every AC's named test is in the client repo; the control plane's tests are supporting receipts (`ac-check.sh` takes one repo; 901y and 902w set the precedent). No AC1a-style sub-IDs: `ac-check.sh` refuses them, so the split parts are AC5–AC7.
2. The admin page is server-rendered like every other admin page and is not in OpenAPI; only the two client endpoints are.
3. Installation identity is a random ID in a state file next to the local database, with no SQLite migration (so no clash with sibling client branches that add local migrations).
4. Update on inequality with the target; the client never decides "newer".
5. `dev` and edge builds, macOS and Linux check in and are counted but never replace themselves.
6. Failures keep only the latest per client (columns on the installation row), not a history table.
7. Download link stored per approved version (no new server environment variable, so no installer or Helm change).
8. A failed target is not retried for 1 hour (24 hours after a failed start), so a bad release can't loop.
9. No pre-switch test launch of the new exe and no rate limiter on the two endpoints (they are authenticated, tiny, and the per-user cap bounds the rows), matching the drift-report endpoint.
10. Check cadence: 3 s after startup and every 6 hours.

## Assumptions (for the PR texts)

- "A client" is one installation (one Windows profile's `%APPDATA%\Leorna`), counted when seen in the last 30 days.
- The admin copies the SHA-256 from the release's `.sha256` file; the control plane doesn't contact GitHub.
- The new package is not run by Windows CI (no workflow edits); it is covered on Linux CI by `make check`, natively on Windows by the AC7 run, and by the live check.
- Release files must be downloadable without a GitHub login for real use; that is a team decision outside this story.

## Follow-ups (not in this story)

- Authenticode check at the `Verifiers` seam (86bcm9031, Yan).
- Public download location for release files (team decision; Q1).
- Local database down-migrations or a kept copy, so an admin rollback across a schema change takes.
- A "Check for updates now" button and update history per client.
- Add `./selfupdate` to the Windows CI test list (needs a CI exception).

## Sibling work that may overlap

- **86bcxnykn** (update the control plane from the admin console; being planned now, control plane): likely the same next migration number `000032`, a new admin page and nav link in `internal/web/handler.go`, the OpenAPI contract and `delivery/stories.json`. Whoever merges second renumbers its migration and re-appends its `stories.json` entry.
- **86bcm928p** (connection test for integrations; being planned now, both repos): the OpenAPI contract and both generated files (`packages/contracts/controlplane.gen.go`, client `api/controlplane.gen.go`), `stories.json`. Generated files are resolved by regenerating, never by hand.
- Control plane open PR **#113** (`feat/86bcx2a33-github-mcp-current`, head `6d2c5b1`): `delivery/stories.json` only in common.
- Client open PR **#29** (`feat/86bcx2a33-github-mcp-current`, head `54df773`): `README.md` only in common.
- Client local branch `feat/86bcm928h-per-user-credentials` (`1f98596`, not pushed, already conflicting with `main`): also edits `desktop/bridge.go`, `index.html`, `README.md`; this story adds a few lines to each and puts everything else in new files.
- No open work touches `cmd/leorna-client/main.go`, `scripts/build-windows-client.ps1` or the client's startup path.

## Other things found (not fixed here)

- Both repos are private, so the card's "downloads the exe from the GitHub Release" can't work for a client without a GitHub login, and customers can't fetch any release file that way either (`gh repo view LeornaAI/leorna-client --json visibility` → PRIVATE; control plane `docs/deploy/release-pipeline.md` "no read permission for the other private repository"). Raised as Q1.
- The released `leorna-client.exe` has no version inside (`scripts/build-windows-client.ps1`: only `-H windowsgui`), so nobody can tell which version an engineer runs. This story adds the stamp.
- An older client can't open a database a newer client migrated (`application/application.go:235-237`), so any manual downgrade ends in "unsupported local database version" at startup, with no message in the window (it is a `log.Fatalf` in a windowed app). Medium; follow-up above.
- The client's contract snapshot `api/control-plane.openapi.yaml` is behind the control plane's contract (`cmp` of the two files at the bases differs from line 311; 16 changed lines from merged control-plane stories that didn't refresh the client copy). Low today (descriptions and one response header), but the "byte-identical" rule in `api/README.md` isn't being kept and nothing checks it. This story's copy fixes it in passing (task C2).
- `leorna-test-pg` has been stopped for 10 days on this desktop; every Postgres-backed test skips until `docker start leorna-test-pg`. Host note, low.

## Completion contract

Each builder returns: branch, head SHA, base SHA, the diff stat (`git diff --stat origin/main...HEAD`), the gate results with real exit codes, one line per AC or supporting test it added (name → result), anything in this plan it had to change and why, and `skill_lessons`. It stops at `ready-for-review`: no push, no PR, no ClickUp write. The story is ready for hand-over only when both repos have a clean review on their current heads, the verifier and the blind auditor accept AC1–AC7 on the client head with the control-plane head named, and `ac-check.sh --reviews` prints `READY FOR THE USER` (AC8 owed to Justin).
