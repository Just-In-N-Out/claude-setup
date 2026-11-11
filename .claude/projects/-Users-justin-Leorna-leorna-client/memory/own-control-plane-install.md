---
name: own-control-plane-install
description: "Justin's own Leorna control-plane test server on Scaleway: server-admin rules for agents, install runbook (installer + Yan's fixes), current servers, code-verified teardown order, gotchas (2026-10-06)"
metadata:
  node_type: memory
  type: project
  originSessionId: 5c5284b3-7db9-45f0-9917-75e10c4dea95
  modified: 2026-11-08T00:14:33.000Z
---

Runbook for a personal control-plane test server, so the desktop client can sign in and sync. Done 2026-10-06 on Justin's Mac (Apple Silicon). Christian said to use the installer, that it costs "a few cents", and to delete everything once the work is tested and merged to main.

## Why a test server needs Yan's fix
- **Status 2026-10-12:** the fix is on control-plane main (PR #81 merged 2026-10-09). A reinstall can run from main; see [[control-plane-test-branch]].
- The installer always deploys in **dev mode** (`internal/launcher/installer_secrets.go` sets `DevMode: true`), so the server has no Google OAuth.
- On main, client sign-in goes `/client/authorize` → `/client/login` → Google. In dev mode that always fails with `{"code":"AUTH_START_FAILED","status":500}`. Christian's server `leornaf73eb3c0-control-plane.functions.fnc.fr-par.scw.cloud` does this; its plain `/v1/auth/google/login` fails too.
- Yan's commit **53d6abd** makes `/client/login` redirect to `/dev/login?next=/client/authorize?user_code=…` in dev mode. It sits on her unmerged control-plane PR #81 (branch `feat/86bbu3xhc-bundle-content`). Once #81 or the fix is on main, the prebuilt image will have it and these cherry-picks are no longer needed.
- No-install workaround on any dev-mode server: open `https://<domain>/dev/login` first in the browser the app opens, then click Sign in in the app. The approval page then works.

## Steps (control-plane repo, ~/Leorna/leorna-control-plane)
1. Make a local-only branch `test/own-server-dev-signin` from origin/main (`5ccbfdd`). Cherry-pick Yan's three commits; she stays the author:
   - 53d6abd: dev sign-in
   - f197abe: registry namespace name includes the project ID; main's fixed name `leorna` clashes region-wide
   - c903a2e: `docker login` before pushing the image
   The agent removed the branch's upstream. **Never push it.** The branch already exists. **Before any use, merge the latest origin/main into it and fix conflicts.** The rule and steps are in [[control-plane-test-branch]].
2. **Create an empty Scaleway project first:** Organization Dashboard → Projects → Create project. Justin's is `Justin-test`. The org's other projects already have installs (Christian's and probably Yan's).
3. Run `LEORNA_IMAGE_SOURCE=local DOCKER_DEFAULT_PLATFORM=linux/amd64 go run ./cmd/launcher` with Docker running.
   - `local` builds from the checked-out code. The default pulls `ghcr.io/leornaai/control-plane:latest`, and PR images are never pushed.
   - amd64 because this Mac is arm64 and Scaleway containers need amd64 (proven; the image reports linux/amd64). The build takes about 10 minutes.
   - The log goes to `deployment.log` in the repo folder.
   - **Since 2026-10-09 (PR #81 merged), plain `go run ./cmd/launcher` from main should work.** Main CI (run 37992707876, success) pushed `ghcr.io/leornaai/control-plane:latest`, which includes Yan's fixes. That prebuilt path needs no Docker and no 10-minute build (`internal/installer/image/image.go` `FromEnv`). **Proven 2026-10-15:** Justin's install for the admin demo video used this route (`deployment.log`: "using prebuilt control-plane image … (skipping local build)") and reached a working admin. Keep the local build only as a fallback.
4. **Log in to Scaleway inside the launcher's own Chrome window.** Its profile is `~/Library/Caches/Leorna/chrome-profile`, not normal Chrome. The first run stayed on "Waiting for you to finish Scaleway login…" for more than 14 minutes although logged in (Scaleway's login had opened a second tab). The rerun captured instantly because that profile kept the login. Root cause not found. Reading that browser's localStorage is blocked as credential access, so don't try.
5. In the picker, choose the **empty project**, region fr-par. Picking a project that already has an install shows a "Leorna is installed" page with *that* server's domain. **Never type delete there**: it would destroy Christian's or Yan's server. Close it instead.
6. When the progress tiles finish, the setup wizard opens and shows the domain.
7. Verify with curl:
   - `https://<domain>/.well-known/leorna` returns 200, and its `backendUrl` equals `https://<domain>` exactly, since the client rejects anything else.
   - `/client/login?user_code=ABCDE-FGHJK` returns 302 to `/dev/login?next=%2Fclient%2Fauthorize…`.
8. Client: `go build -mod=vendor -tags desktop,production -o <scratchpad>/leorna-client ./cmd/leorna-client` from ~/Leorna/leorna-client, then run it. Paste the domain, Connect, Sign in, approve in the browser. The app remembers the last company, so paste the new domain over the old one.
9. Before testing sync (Christian): in admin, create a team, add a project, and assign the team to the project.

## Servers
- **Status 2026-11-07 (Claude Code): new install STARTED** to test fresh main (control plane `3e5d743`, client `66d0a75`, both pulled ff-only over HTTPS via gh; SSH key locked). Launcher runs from local main via `~/.hermes/cache/scratch/leorna-install-2026-11-07/launch.sh` with `LEORNA_PREBUILT_IMAGE=ghcr.io/leornaai/control-plane:<full main SHA>` (CI's "Publish control-plane image" pushes a per-SHA tag; checked 200 on ghcr) so the server is exactly the pulled main, not whatever `latest` is; no Docker needed. Deploy log: that scratch folder's `deployment.log`. The repo's old `deployment.log` ends with the 2026-10-16 teardown failing on 2 ClickHouse deployments (`insufficient permissions: write deployment`), so leftovers may remain in that Scaleway project. **LIVE 2026-11-08 00:07:55Z: `leornacadc127b-control-plane.functions.fnc.fr-par.scw.cloud`** (tenant "Dev Admin"; discovery 200 with matching backendUrl, `/client/login` 302 → `/dev/login`, healthz/readyz 200). **DELETED 2026-11-08 00:14:09Z:** Justin asked to restart the installer window; in that run he picked this project and clicked Delete instance on the installed page (log: `delete` → "All Leorna resources deleted" in 5 s, domain 404 at 00:14:16Z). Its IAM keys remain (deploy `SCWYVRKWZJ7ZFY8NM10W`, bootstrap `SCW3KMH85FCVTT4HAHMZ`, directory key, plus the delete run's deploy `SCWN2VY5JYWVBAMVWS7A`): Destroy never deletes keys. Check the project for leftover MongoDB/ClickHouse (past Destroys missed them). **Blocked 2026-11-07 19:17Z:** after a restart (Justin asked), project selected, then `mint-deploy` 403 `quota(s) exceeded` IamApiKeys 100/100 — the same full org key quota as 2026-11-06 (Teardown step 3 note); the installer UI just spins on its loading screen instead of showing the error (the progress page only has tiles for registry/image/database/mongodb/clickhouse/control-plane, `internal/launcher/ui_installer.go:550`, and drops events for any other step at `:597`, so a `mint-*` error never shows and the SSE stream stays open), so read the deploy log. The failed mint created nothing. Next: Justin deletes his own leaked keys (the IDs listed under Teardown step 3, never Christian's/Yan's), then restart the launcher. **Unblocked 2026-11-08 00:01Z:** Justin freed keys; on the next restart (Justin asked) all three mints succeeded — this install's keys: deploy `SCWYVRKWZJ7ZFY8NM10W`, bootstrap `SCW3KMH85FCVTT4HAHMZ`, one directory key (ID not logged); registry, image (pinned SHA) done, databases provisioning. Earlier logs kept as `deployment-run1.log`/`-run2.log` in that scratch folder.
- **Status 2026-10-20 (Hermes check):** neither of the two servers below resolves in DNS any more (Christian's still does), so both are probably torn down. Confirm with Justin, check Scaleway for leftover MongoDB/ClickHouse (the installer doesn't delete them, see Gotchas) and IAM keys, then move them under Older.
- **Justin's NEWEST server (named by Justin 2026-10-16, "a real server that I have set up"):** `leorna90809ddd-control-plane.functions.fnc.fr-par.scw.cloud`, tenant "Dev Admin" `0339ae47-3012-445f-b815-e66885f11e2a`. Discovery OK, dev sign-in redirect OK, context endpoints present (2026-10-16 checks). Used for the 86bbu3xmt context-switching live test. Keep the URL private (dev mode).
- **Justin's demo server (LIVE since 2026-10-15 ~20:15Z):** `leornafed4e439-control-plane.functions.fnc.fr-par.scw.cloud`, tenant "Dev Admin" `0ffbebfe-8d71-4c56-805d-04aafa5654de`, installed from main via the prebuilt image for Justin's admin-setup video. Admin data: team `Leorna-Demo`, project `Leorna` (expires 2026-11-14), team default = Leorna starter pack 1.1.1. Scaleway project name not recorded (Justin made a new empty one). Tear it down with the steps below once Justin no longer needs it, and remind him.

### Older (2026-10-06)
- **Justin's: DELETED 2026-10-06 ~23:35Z.** Justin tore it down before client PR #14 (86bbu3xmt) merged, which was his choice. Instance and project Justin-test are deleted, and so is the seeded session. To test against a server again, reinstall with steps 2–9: new empty project, same local branch. The result is a **new domain and tenant**; sign in again in the app, then update this file and [[live-server-testing]].
  - Old details: `leornacc5e1c54-control-plane.functions.fnc.fr-par.scw.cloud`, project Justin-test (`d915000b-6024-4cdb-98d9-5d8bcd4c62b3`), tenant "Dev Admin" `633d7105-5523-4d27-848a-fc2809ad0a3c`, built from `test/own-server-dev-signin`. App sign-in, seeding and fetching all worked against it.
  - **Teardown leftovers still open:**
    - IAM objects (step 3 below).
    - Gmail sign-out in the launcher profile.
    - Unconfirmed: whether Justin deleted the 2 MongoDB and 2 ClickHouse by hand. The installer couldn't (see Gotchas), and Scaleway let the project go anyway. If unsure, check the MongoDB and Data Warehouse lists and the billing.
  - Done: `docker rmi leorna-cp-localtest:amd64`. The branch is **kept on purpose** for a reinstall; delete it once Yan's fix is on main.
- **Christian's:** `leornaf73eb3c0-…`, tenant `8ea4c35f-1db5-4408-8c0d-ae9088104610`, no dev sign-in fix. Leave it alone.

## Server rules for any agent
The rules for testing against the server (only this domain, URL private, tokens, seeding, real tool homes, cleanup) are in [[live-server-testing]]. On top of those:
- **Never delete or change another person's install.** On any "Leorna is installed" page, check the domain is Justin's current server (Servers above) before typing delete.
- **Justin clicks every delete himself.** Ask before changing Scaleway resources, IAM keys, projects or billing. Agents only explain the steps.
- **`test/own-server-dev-signin` is local only; never push it.**
  - Read the deployed server code with `git show test/own-server-dev-signin:<path>`, not origin/main, which may have moved.
  - Only check it out to install or delete. The launcher must run from it. First update it from main ([[control-plane-test-branch]]), then switch back. Leave the untracked `deploy/local/` alone.
- **No in-place update.** The installer's "installed" page only shows the server's status, the setup/admin links and Delete instance. Newer server code means delete and reinstall, which gives a new domain and an empty database. Ask Justin first.
- **Don't tear down early.** Keep the server until the stories that use it are merged, because reviewers may retest. Then remind Justin.

## Teardown (after the work is merged; order checked in code 2026-10-06)
- **Cost:** the org bill was €51.30 by 6 Oct for about two installs, mostly databases. That's roughly a few euros a day, so don't leave it running.
- Steps:
  1. Run the launcher (step 3) and pick **Justin-test**. Check that the "installed" page shows `leornacc5e1c54…`, type delete, and click **Delete instance**.
     - It runs `Destroy` in `internal/installer/scaleway/detect.go`.
     - That deletes, in the picked project only, the Leorna containers and their namespace, Postgres, MongoDB, ClickHouse and the image registry.
  2. Then delete project Justin-test in the Scaleway console (Project → Settings → Delete Project). The button refuses while resources remain ("You must remove all Project resources before proceeding"), so step 1 comes first.
  3. Delete the IAM objects in Organization → IAM. No installer code deletes them, although the installed page lists a "Scoped access key".
     - Each mint makes an IAM **application + policy + API key** (`internal/cloud/scaleway/iam_http.go`). Deploy and bootstrap keys: app `leorna-db-<projectID>-<suffix>`, policy `leorna-db-policy-<projectID>-<suffix>`. Directory key: `leorna-dir-<suffix>` / `leorna-dir-policy-<suffix>` (org-wide, not in a project). Delete the policy, then the application (its keys go with it). **The org's IAM API-key quota is 100 and was full on 2026-11-06** (`mint-deploy` 403 `quotas_exceeded`, IamApiKeys 100/100); `Destroy` never deletes keys (only the mint `rollback` does), so every run leaks keys. Justin's 6 Nov desktop runs made SCW1P0PWT1438KWBHXKT, SCW7NQ4Q6K3TKF2TKPJP, SCWA7RE6GM2JHA1SFSYC, SCWBRG1VD5K7YJVBKF9C (deploy), SCW4W17D98X2M0MXWCCQ, SCWMCW815F6Z3D2HHYCA (bootstrap) — free those first before a reinstall.
     - Justin-test install (2026-10-06 20:17Z): deploy `SCWRYNECM3GMPD5WFRF2`, bootstrap `SCW25JWCRFTD09J4XJ0N`, one directory key (ID not logged).
     - `SCW5S9B9D7P0RM4CNZZZ`: deploy key minted in Christian's project when he was picked by mistake (the run stopped at the "installed" page, so no bootstrap or directory key there). Tell Christian before deleting it.
     - Every extra launcher run mints a new set, even a run used only to reach the Delete button. The teardown run on 2026-10-06 at 23:30Z minted deploy key `SCW7Z1X0PADFBG4ZXQ8B`.
  4. Run `docker rmi leorna-cp-localtest:amd64`.
  5. Delete the local branch `test/own-server-dev-signin`.
  6. Sign out of Gmail in the launcher's Chrome profile.
  7. Update this memory and [[live-server-testing]] to say the server is gone.

## Gotchas
- **Teardown run, 2026-10-06:**
  - **The launcher won't start while its old Chrome is open.** The error is `chrome failed to start: Opening in existing browser session` (profile lock). Closing the tabs doesn't quit Chrome on macOS. Quit that window (Cmd+Q) or kill the Chrome process whose command line has `Library/Caches/Leorna/chrome-profile`.
  - **"Install Leorna" on a project that already has an install** opens the "installed" page instead of reinstalling (`cmd/launcher/main.go` ~434). If that check errors, though, it falls through to a new install. So if progress tiles appear, close the window at once.
  - **Delete instance removed the container, its namespace, the registry and Postgres, but NOT MongoDB or ClickHouse.** It failed 3 times with `insufficient permissions: write instance` / `write deployment`, even though `internal/launcher/deploy.go` gives the key MongoDBFullAccess and DataWarehouseFullAccess. The cause is unknown. A retry 1.5 minutes after the key was minted still failed. The project held **2 MongoDB and 2 ClickHouse**. Delete them by hand in the console, and tell Christian it's an installer bug.
  - **Scaleway's "Delete Project" list doesn't show MongoDB or ClickHouse**; it showed only database, namespace, container and registry bytes. Check those two products yourself.
- The desktop app hides real Go errors (`app.js:16`, `login.js:11`), so read `deployment.log` or the server's problem JSON.
- In dev mode, anyone who opens `/dev/login` becomes admin, so keep the URL private.
- `/dev/login?next=` lets `/%5Cevil.example` and `/%09/evil.example` through as an open redirect. It's pre-existing code; Justin told Yan.
- Yan deployed her own server with the installer the same way; her installer fixes prove it.

**Scaleway has no container rollback (2026-11-10, 86bcxnykn planner, from `scaleway/docs-content` `pages/serverless-containers/reference-content/containers-limitations.mdx` ~261-275):** Serverless Containers have no versioning or rollback. After a failed deployment the previous version keeps serving for up to 24 hours, then both are removed, so an unattended failed install, resume or update turns into an outage a day later.
