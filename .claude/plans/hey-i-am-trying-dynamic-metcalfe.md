# Merge main into feat/86bbu3xew-connect-existing-db (PR #61)

## Context
PR #61 can't merge because main moved on (now `7ad4bf7`, #76). Git reports conflicts in two files, and both are small. One bigger problem has no conflict marker: main's #66 changed auto-setup so it always uses the control-plane's own database. In auto-setup mode the database step is now always "done", so one subtest on this branch will fail after the merge. This plan makes the branch merge cleanly and keeps every behaviour this story adds in normal (non-demo) mode.

Approach: **merge `origin/main` into the branch** (one merge commit). This needs no force-push and keeps PR #61's review history. No push: Justin pushes.

## Step 0 — get the latest main
The local `origin/main` is `6763122` (one behind). `git fetch` currently fails with "Permission denied (publickey)", so Justin first runs:
`! ssh-add --apple-use-keychain ~/.ssh/id_ed25519_leorna`
Then `git fetch origin`. #76 touches none of this branch's files (checked through the GitHub API), so the conflict list stays the same.

## Step 1 — `git merge origin/main`, resolve the 2 conflicts

**`internal/cloud/scaleway/scaleway.go`** (Provider struct): keep both sides.
- `Provider` gets both fields: `databases DatabaseChecker` (ours) and `managed ManagedProvisioner` (main).
- Keep our `DatabaseChecker` interface, our `New()` (wires `dbcheck.Checker{}`) and our `ConnectExisting`.
- Keep main's `SetManagedProvisioner`, `Provision` dispatch and `Capabilities{... Provision: true ...}`.

**`internal/web/setup.go`** (template "done" line): combine both sides.
```
{{if eq .Progress.Selected.ResourceID "control-plane"}}<p>Using the control-plane database for your AI context.</p>{{else}}<p>Using database <span class="badge">{{.Progress.Selected.ResourceID}}</span>.</p>{{end}}
```
This keeps main's control-plane wording and our wording ("Using database", because an attached database isn't necessarily on Scaleway). An attached database's ResourceID is always `endpoint/database`, so it can never equal `"control-plane"`. No test checks either sentence.

Files that merge cleanly and need no change: `handler.go` (both sides only add routes), the rest of `setup.go` (main's `hasReadyConnection` + synthetic connection, and our `renderSetupPage(..., advance)` / `setupExistingDatabase`), and `stories.json`. I also checked for hidden clashes and found none: no new implementation of `setupDatabases` on main, no new `ConnectExisting` caller, no `cloud`/`provision`/`store` interface changes, and no new migration on our side.

## Step 2 — fix the one clash with no conflict marker (auto-setup)
On main, with `LEORNA_AUTO_SETUP` on (set only by the installer's demo/dev mode, `internal/installer/orchestrator/steps.go:95`), `setupState` adds a ready "control-plane" connection. So:
- the existing-database form is never shown (the step is "done");
- `setupExistingDatabase` sees `Done`, stores nothing and redirects.

So `internal/web/setup_test.go` subtest "with auto-setup on, a failed test stores nothing and its error stays on screen" (~line 704) will fail: it expects 422 and gets 303.

**Decision (follow main and list it as an assumption):** in demo/auto-setup mode the control-plane database is the tenant database, as Christian designed in #66. Normal installs (auto-setup off) keep the full connect-existing flow unchanged. Changing #66 would mean changing a teammate's design inside a feature story.

- Replace that subtest with **"with auto-setup on, the control-plane database is used and a submitted form stores nothing"**:
  1. Use `newSetupFixture` + `EnableAutoSetup()` + login, then `waitForStep(t, client, "pack", "done")`.
  2. Check the database step is done, the page shows "Using the control-plane database", and the page does NOT contain `action="/admin/setup/database/existing"`.
  3. `postRedirect` a valid `existingDatabase(t)` form, then check `storedRows` == 0/0/0. No second database is attached; this mirrors main's `TestAutoSetupUsesControlPlaneDatabase`.
- Keep `renderSetupPage(..., advance bool)` and the two `false` calls unchanged. Auto-setup can no longer reach them, but they still guard correctly if #66 changes, and removing them would be an unrelated refactor.
- `internal/web/README.md`:
  - line ~113: replace the auto-setup bullet with "With auto-setup on (`LEORNA_AUTO_SETUP`, the installer's demo mode), the wizard uses the control-plane's own database (#66), so this form isn't offered and a submitted one stores nothing."
  - line ~141: update the subtest description to match.

Commit the merge with git's default merge message. Make plain `git commit`s only: no author override and no Co-Authored-By line.

## Verification
1. `docker start leorna-test-pg`, then `export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_test?sslmode=disable'`
2. `go build ./...` and `go vet ./...`
3. `go test ./internal/web -run 'TestConnectExistingDatabaseWithPostgres|TestAutoSetupUsesControlPlaneDatabase|TestSetupIsAdvancing' -v`: confirm the tests ran (not skipped) and passed.
4. `go test ./internal/cloud/... ./internal/store/...`
5. Mutation check for the new subtest: temporarily drop the `Done` check in `setupExistingDatabase`. The subtest must fail because a row gets stored. Then restore.
6. `make check` + `bash ./scripts/test-module-add.sh` (full CI gate).
7. `git diff origin/main...HEAD --stat`: only this story's files plus the test/README edits.

Then stop and show the diff. Justin pushes, and PR #61 should show as mergeable.

## Follow-ups (not part of this change)
- PR #61's description: lines on auto-setup (Summary `internal/web` line, "Auto-setup (#58)" note, and the "opening the setup page starts a Scaleway provision" limitation) are now out of date. I'll give replacement text.
- `delivery/stories.json` 86bbu3xew still lacks PR `61` (AGENTS.md: keep it current). It's a one-line commit if Justin wants it in this push.
