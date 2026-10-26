# Leorna repos — read-through done, small follow-ups

## Context
Justin asked me to read the shared memory, `leorna-control-plane` and `leorna-client`,
and confirm I understand both. That's done; no code change was requested. The read-through
turned up a few stale facts and one thing the wizard branch will hit before its PR. The
steps below only run if Justin says so.

## What I read
- **Memory:** all 8 files. One folder serves both repos. It was updated by another session
  at 06:45 today and still calls #46 "open".
- **Control plane:** Go server plus server-rendered admin console.
  - Google login and tenants, teams and roles, projects, audit log.
  - Packs: a catalog, immutable versions, fork, and assignment to a team or project.
  - Bundle API for the client (`/v1/client/.../bundle`: manifest and hashes, no file bodies).
  - Scaleway connect via the launcher's console token, then OpenTofu provisioning.
  - Tenant isolation lives in application code (not Postgres row-level security), and
    other-tenant IDs get a 404.
- **Wizard branch** (`feat/86bbu3xr4-onboarding-wizard`): 5 local commits, not pushed.
  - `onboarding.Evaluate` works out setup progress from what's already stored (no new
    table), plus `ListConnections`.
  - `/admin/setup` with its database and pack steps, a banner on `/admin`, tests, READMEs,
    and a stories.json entry with no PR number yet.
- **Client:** Windows Wails app.
  - Flow: company domain → discovery → device-code login (token in the OS keyring) →
    detect tools → install Claude Code.
  - Keep `toolconnector.Connector` as is. PR #7 added the Codex/Cursor transformers.
  - Nothing consumes the bundle endpoint yet. The client's OpenAPI copy predates it, and
    the bundle's shape ≠ the client's `Pack` type. That gap is the real work behind
    "Daily auto-update on startup".

## Findings that matter now
1. **Main moved since the wizard branch was cut.** As of the last fetch (06:44 today),
   `origin/main` has 4 new merged PRs:
   - #46 console-session capture (migration 17)
   - #48 launcher
   - #49 launcher mint + sealed bootstrap credential
   - #50 zero-setup launcher

   The wizard branch and main both edit `cmd/control-plane/main.go`, right next to the
   `SetProvisioning` line, and the import block of `internal/web/handler.go`. Expect two
   small conflicts on rebase.
2. **The client repo's local git is 6 days stale.** The last fetch was 2026-09-21, so local
   `main` (`c618eb9`) lacks PR #7's merge (`0b453fe`). The checked-out branch is the
   already-merged #7 branch.
3. **Memory is behind git.** #46 is merged, and #48–#50 aren't recorded at all.
4. **Minor, pre-existing (not for the wizard PR):** `.env.example` leaves out
   `LEORNA_SECRET_ENCRYPTION_KEY`.

## Proposed steps (only on Justin's go; no push, no PR)
1. Update `leorna-workflow.md` in memory: #46 merged, #48–#50 launcher merged, and the
   client repo needs a fetch.
2. `git fetch origin` in both repos. This only updates remote refs, not any branch.
3. After Justin's independent review of the wizard is back and fixed:
   1. Rebase `feat/86bbu3xr4-onboarding-wizard` onto `origin/main`.
   2. Resolve the `main.go` / `handler.go` conflicts, keeping both sides: `SetConsoleSessions`
      + bootstrap credential, and `SetSetup` on the shared `provisioning`.
   3. Rerun the gate, then stop and show the diff.

## Verification
- Before step 3.1: `git log --oneline main..origin/main` shows the 4 new PRs.
- After step 3.1:
  - `export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_test?sslmode=disable'`
  - `go test ./internal/web -run 'TestSetup' -v` shows no SKIPs.
  - `make check` and `bash ./scripts/test-module-add.sh` both pass.
  - `git diff --stat origin/main..HEAD` touches only the wizard's 17 files.
