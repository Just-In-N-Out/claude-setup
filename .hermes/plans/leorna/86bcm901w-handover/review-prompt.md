Review only, for Leorna control-plane story 86bcm901w "Create a pack by picking library items". Don't trust anyone's summary, the PR text, the evidence folder or the shared memory: check everything yourself in the code and with real commands. Make no commit, push, PR, merge or ClickUp change. Restore anything you change, and leave `deploy/local/` alone. Never touch the sibling worktrees or branches (86bcm901a, 86bcm901b, 86bcm901j), Justin's `leorna-pg` container on port 5432, or any database that isn't yours.

## What to review

- **Repo:** `~/Leorna/leorna-control-plane` on Justin's Windows desktop (WSL Ubuntu). The branch is **local only, not pushed**, so run this on that machine.
- **Branch:** `feat/86bcm901w-create-pack`, worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`. Don't edit it: make your own detached copy, for example `git clone --no-hardlinks <worktree> <your-dir>/head && git -C <your-dir>/head checkout --detach 8a5048694d40ee975c7b3c276ca1b8af521cae5d`.
- **Range:** `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d..8a5048694d40ee975c7b3c276ca1b8af521cae5d` (18 commits, 24 files, +6,713/−1,420; most of it is generated code in `packages/contracts/controlplane.gen.go`). The base is GitHub `main` as of 2026-10-28 22:59 UTC. Fetch it yourself over HTTPS through gh (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`) and say whether `main` has moved.

## The card (ClickUp 86bcm901w, E11 Pack Builder, PI-2, Size M)

> As an admin, I want to create a new pack by ticking items in the library and naming it, so that setup takes minutes, not hours.
> Context: today, fork the seed pack and edit/append items one at a time.
> Acceptance criteria (test-backed):
> - AC1: Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items.
> - AC2: Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set.
> - AC3: Given a save, then a change-audit record is written (actor, action, diff).
> Verify: unit + integration tests; audit record asserted.
> Definition of Done: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
> Dependency: Library catalog browser (86bcm901v, merged). Repo: control-plane.

**AC4 was proposed by the planner and approved by Justin:** given a save that is invalid or not allowed, it is refused with a clear status and nothing is written (no pack, no version, no audit record). The cases are:

- no name;
- no items;
- an unknown or repeated item;
- a name already used;
- nothing changed;
- a pack left empty;
- an outdated version;
- a member;
- a bad CSRF token;
- another company's pack.

**Decisions Justin already made. Check that they're implemented; don't re-argue them:**

- Pack names are unique per company, ignoring case (and surrounding spaces): 409.
- Only packs made in the library get numbered versions 1, 2, …; starter-pack versions and forks are not editable here.
- A save must start from the pack's latest version, or it gets 409 and nothing is saved.
- New versions are never assigned automatically.
- Everything is admin-only, reads included.
- Item order is not stored (that is 86bcm901y).
- Test Postgres may run on 127.0.0.1:55432, because 5432 belongs to `leorna-pg`.

Tests by AC, all in `internal/web/pack_builder_test.go`, against real Postgres:

- AC1 `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`
- AC2 `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`
- AC3 `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`
- AC4 `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`

## Earlier review findings and their claimed fixes (check each one is really fixed)

- **R1-F1 (P2):** an upper-case pack id in the URL filed the save under that text, so the pack's change history (filtered by its stored lower-case id) missed it.
  - Claimed fix `a0173dc`: `strings.ToLower` after `validUUID` in `GetPack` and `SavePackVersion` (`internal/store/postgres/pack_builder.go`).
  - Tests: store `upper_case_pack_id_reads_and_saves_under_the_stored_id` and AC3 `a_save_from_an_upper_case_pack_url_is_in_the_pack_history`.
- **R1-F2 (P3):** no test for the ticks kept after a refused form save. Claimed fix `0e2a391`: AC4 `name_already_used` and `pack_left_empty` now check the ticks.
- **R1-F3 (P3):** no test for a version-id collision. Claimed fix `e90cec8`: store `a_used_version_id_is_reported_for_a_retry`.
- **R2-F1 (P3):** migration 23's constraints were untested. Claimed fix `a143615`: store `the_database_refuses_versions_outside_their_pack`, five cases checking SQLSTATE and constraint name.
- **R2-F2 (P3):** the admin-only JSON reads were untested. Claimed fix `ecb7bab`: AC4 `member` also checks `GET /v1/packs` and `GET /v1/packs/{packId}` give 403 `ADMIN_REQUIRED`.
- **R2-F3 (P3):** the web README overstated which ticks a refused save keeps. Claimed fix `8a50486` (wording only).

## Setup (your own resources only)

1. **Tools:**
   - `TOOLS=~/.local/leorna-toolchain; export PATH=$TOOLS/go/bin:$TOOLS/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`.
   - Check `go version` (1.27.3), `golangci-lint --version` (2.14.0, CI's), `govulncheck -version` (v1.7.0, CI's pin) and `gitleaks version` (8.30.1).
   - `make` and `gcc` come from apt, so cgo is on.
   - Put `TMPDIR` and `GOTMPDIR` in a folder you own on the real disk, such as `~/.cache/86bcm901w-review3/tmp`. `/tmp` is a small shared tmpfs and fills up.
2. **Postgres:** the `leorna-test-pg` container (CI's image `postgres:18.6-alpine3.23`).
   - Find its port with `docker port leorna-test-pg 5432` (expected `127.0.0.1:55432`).
   - Read its password with `PGPW=$(docker exec leorna-test-pg printenv POSTGRES_PASSWORD)` and abort if it is empty. Never print it.
   - If `docker` gives "permission denied", use `/mnt/c/Windows/System32/wsl.exe -e docker …`. If it gives "could not be found in this WSL 2 distro", Docker Desktop isn't running: say so and stop.
   - Create your own DBs, whose names must end in `_test`: `docker exec leorna-test-pg createdb -U leorna leorna_86bcm901w_review3_test` (and `…_review3_base_test` for base). Drop only those afterwards.
   - `export LEORNA_TEST_DATABASE_URL="postgres://leorna:$PGPW@127.0.0.1:55432/leorna_86bcm901w_review3_test?sslmode=disable"`.
3. **Gates, in your detached copy at `8a50486`:**
   - `GOLANGCI_LINT=$TOOLS/bin/golangci-lint GOVULNCHECK=$TOOLS/bin/govulncheck GITLEAKS=/usr/local/bin/gitleaks make check` (first run `make -n -s lint audit secrets` to confirm those binaries are the ones used);
   - `bash ./scripts/test-module-add.sh`;
   - `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`;
   - `gitleaks git --redact --log-opts="1ee7157..HEAD"`.
4. **Prove the Postgres tests ran, from a JSON stream, not `-v` text:**
   - `go test -json -count=1 -p 1 ./internal/cloud/dbcheck/ ./internal/store/postgres/ ./internal/web/ ./internal/pack/ > pg.json`.
   - Read it per test (Action plus that test's own Output). Fail on any skip whose reason names `LEORNA_TEST_DATABASE_URL`.
   - The only acceptable skips are:
     - the two ClickHouse subtests of `TestTeamsAPIWithPostgres` (`LEORNA_TEST_CLICKHOUSE_URL not set`);
     - `TestEvidenceThirdPartyContentPage` (`LEORNA_EVIDENCE_DIR is not set`);
     - `TestProvisionManagedPostgresLive` (`SCW_LIVE=1 not set`).
   - Some Postgres tests aren't named `WithPostgres` (for example the ones using `newPackFixture`), so read every test.
5. **Each AC by name on head:** `go test -v -count=1 -run '^<AC test>$' ./internal/web/`. Then copy only `internal/web/pack_builder_test.go` into a detached copy at `1ee7157` and show that each AC fails there, with your own base DB.
6. **Demo it (dev mode, loopback only, throwaway DB):**
   - Build `./cmd/control-plane` from your copy and run it on a free loopback port with `LEORNA_DEV_MODE=1`, a copy of `config/manifest.example.json` with the address changed, and a demo DB ending in `_test`.
   - Open `/admin/library`, tick items, name the pack and save; untick or tick and save again; then open `/admin/audit?target=<packId>`.
   - Never capture `/admin` (it shows email and tenant ID). Stop the server and drop the DB afterwards.

## Mutations to try (each must still compile; restore the exact bytes afterwards and check `git status` is clean)

- Migration 23 without its two `CREATE TRIGGER` lines: AC2 must fail.
- `SavePackVersion` without the `parent.Version.Version != spec.ParentVersion` check: AC4 `outdated_version` must fail.
- The `SELECT name FROM pack_lineages … FOR UPDATE` without `tenant_id`, **and** `latestBuiltVersion` unkeyed, **and** the FK on `pack_id` alone. The lock query alone is a documented equivalent, because the composite FK and the tenant-keyed read still refuse a cross-tenant save.
- `beginOrg(ctx, actor, false)` in `CreatePack` or `SavePackVersion`.
- The `/v1/packs` routes without `requireAdmin`, separately for the GET routes.
- `packGuard` comparing the token with itself.
- The pack forms back to `adminForm` (4 KiB): a full library edit form must fail.
- `appendAudit` moved after `Commit`, into a second transaction.
- `DiffItems` putting added items in `Removed`.
- Drop the unique index `pack_lineages_tenant_name`, and also a variant that ignores spaces but not case.
- `loadLibraryItems` silently skipping an unknown id.
- Remove the `strings.ToLower` in `GetPack` or `SavePackVersion`.

**Known traps:**

- Ignoring `appendAudit`'s error is a documented equivalent: Postgres aborts the transaction, so `Commit` fails.
- AC4 `unknown_library_item` sends only an unknown id, so the empty-pack check can mask the unknown-id guard; the store subtest catches that mutant. Say whether you think AC4 needs a valid-plus-unknown case.
- `waitForPackLineageLock` matches query text loosely. Don't rename the locked query without checking it.

## Also check

- **Security and tenant isolation:**
  - Every console and JSON route is admin-only, reads included.
  - Another company's pack is 404 for read and save, and no query leaks across tenants.
  - CSRF on JSON writes (`X-CSRF-Token` equal to the cookie) and on forms.
  - The 64 KiB body bound; strict JSON; parameterized SQL; `html/template` escaping of names and descriptions.
  - Audit after-values hold refs and counts, never item bodies or files.
- **Immutability:**
  - No code path updates or deletes `pack_versions` or `pack_version_items`.
  - The triggers cover every version, not only built ones. Is that acceptable and documented?
  - The migration round trip, including the downs of 18 and 21, which delete items, running after 23's down drops the triggers.
- **Migration 23:** expand-only, and safe on a database with existing pack versions (both new columns NULL). Its down is complete.
- **OpenAPI:**
  - Additive only (0 lines removed).
  - `make contracts-check` is clean.
  - `PackItemKind` keeps the inline kind-enum count at 2, which `internal/web/contract_kinds_test.go` and the client's `application/contract_kinds_test.go` both require.
  - The responses match the handlers (status codes and problem codes `PACK_NAME_TAKEN`, `PACK_CHANGED`, `INVALID_PACK`, `ADMIN_REQUIRED`, `NOT_FOUND`).
- **Docs true as written:** `internal/pack/README.md` "Build a pack from the library (86bcm901w)", the web README's "Library catalog browser" pack builder paragraph, and `internal/audit/README.md`.
- **`delivery/stories.json`:** the 86bcm901w entry is last and its PR list is empty (no PR exists yet). Earlier entries are unchanged.
- **Commits:** every author and committer is `Justin Issa <justin@leorna.com>`. No commit body has `Co-Authored-By`, "Generated with", `noreply@anthropic` or 🤖. No `.github/` path and no `CLAUDE.md`.
- **Merge risk:**
  - `git merge-tree --write-tree --name-only HEAD origin/main`.
  - Against Yan's PR #94 (fetch `pull/94/head` read-only, and check `FETCH_HEAD` equals `gh pr view 94 -R LeornaAI/leorna-control-plane --json headRefOid`). Expected: one conflict in `internal/web/handler.go`, where both add a struct field after `packVersions`.
  - Against the local branches `feat/86bcm901a-agent-definitions`, `feat/86bcm901b-prompts-collection` and `feat/86bcm901j-mcp-templates`. Expected: `delivery/stories.json` only.
  - Confirm no sibling adds a `000023_*` migration.

## Report format

1. A one-line verdict: Ready / Ready with nits / Not ready.
2. A table per AC and DoD item: requirement → test or command → your real result → evidence (file:line or output lines).
3. The real command output for each gate (the command, the key lines and the exit code), and your per-test reading of the JSON stream (pass, skip and fail counts, with each skip named).
4. Mutation results: mutant, the bytes changed, KILLED or SURVIVED, and which test caught it.
5. Issues found, each labelled **introduced** or **pre-existing**, with severity (P0–P4), file:line, evidence and a suggested fix. Separate real defects from nits.
6. What you couldn't check, and why.
