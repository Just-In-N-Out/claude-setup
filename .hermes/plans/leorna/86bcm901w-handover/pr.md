Title: feat(86bcm901w): create a pack by picking library items

## Summary

Admins can now build a pack straight from the Content library page: tick items, name the pack and save. That creates version 1 with exactly the ticked items. Reopening the pack (`/admin/library/packs/{packId}`) shows its items ticked; ticking or unticking and saving creates version 2, 3, … as new immutable rows whose ParentVersion is the version before. Every save writes a `pack.create` or `pack.version.create` change record in the same transaction (actor, action, and a diff of added, removed and changed items, without item bodies). An admin-only JSON API does the same: `GET`/`POST /v1/packs`, `GET /v1/packs/{packId}` and `POST /v1/packs/{packId}/versions`, added to the OpenAPI contract. A "pack" is a new `pack_lineages` row (migration 23) with a name unique per company, ignoring case. Migration 23 also adds database triggers that refuse any UPDATE or DELETE of a saved pack version or its items. New versions are never assigned automatically, so nothing reaches engineers until an admin assigns one on Assignments. No CI change.

ClickUp: [Create a pack by picking library items](https://app.clickup.com/t/86bcm901w)

## Changes

- `internal/store/postgres/migrations/000023_pack_builder.{up,down}.sql`:
  - new `pack_lineages` (name 1–200 characters, unique per tenant on `lower(btrim(name))`);
  - `pack_versions.pack_id`/`pack_number` with a tenant-keyed FK, a both-or-neither CHECK and `UNIQUE (pack_id, pack_number)`;
  - triggers that reject UPDATE/DELETE on `pack_versions` and `pack_version_items` with SQLSTATE 42501.
- `internal/pack/builder.go`: pure `ApplyChange` (removals, then additions; an empty, repeated or impossible change is invalid) and `DiffItems`; the create/save specs; `BuilderService` (version ids like `VersionService`, one retry on a used id); `ErrNameTaken` and `ErrStaleParent` (both conflicts).
- `internal/store/postgres/pack_builder.go`: `CreatePack`, `SavePackVersion`, `GetPack` and `ListPacks`.
  - Each write is one transaction: the admin re-check (`beginOrg`), the library rows read by id, the version insert and `appendAudit`.
  - A save locks the pack row and must start from the latest version, or it gets 409 `PACK_CHANGED`.
  - Pack ids are lower-cased after validation, so the change history filtered by pack id finds every save.
- `internal/store/postgres/pack_versions.go`: the item insert loop moves into `insertVersionItems`, shared with the builder. No behaviour change.
- `internal/web/pack_builder.go`: the four JSON handlers and the console form handlers.
  - JSON guard: `X-CSRF-Token` must match the CSRF cookie, bodies are capped at 64 KiB, and the JSON is strict (unknown fields refused).
  - Problems: `PACK_NAME_TAKEN` and `PACK_CHANGED` (409), `INVALID_PACK` (400), `ADMIN_REQUIRED`/`FORBIDDEN` (403), `NOT_FOUND` (404).
  - Inline alerts on the page for refused saves.
- `internal/web/library.go`: an Include checkbox before each row's name, a "Build a pack" form, and the edit view with the pack's items ticked and marked "in pack". It shows notes for items that aren't in the library and for scripts that need approval.
- `internal/web/cloud_plan.go`: `adminFormLimit`, which is `adminForm` with a caller-chosen body bound. The pack forms use 64 KiB; every other form keeps 4 KiB.
- `internal/web/handler.go`, `cmd/control-plane/main.go`: three console routes and four `/v1/packs` routes, all `requireSession(requireAdmin(…))`; the builder is wired at startup.
- `contracts/control-plane.openapi.yaml`, `packages/contracts/controlplane.gen.go`, `packages/contracts/roundtrip_test.go`:
  - 4 operations and 7 schemas, additive only (0 lines removed);
  - the item kind is a named `PackItemKind` schema, so the contract-kind tests in both repos still see exactly 2 inline kind enums;
  - the generated code is regenerated (all 1,258 base declarations kept).
- Docs:
  - `internal/pack/README.md`: a "Build a pack from the library (86bcm901w)" section;
  - `internal/web/README.md`: the builder controls, routes, 64 KiB bound, and which ticks a refused save shows;
  - `internal/audit/README.md`: the two new actions.
- Tests:
  - the four AC tests in `internal/web/pack_builder_test.go` (real Postgres);
  - `pack_builder_form_test.go` (tick → change);
  - store `TestPackBuilderStoreWithPostgres` (create, save, stale parent, tenant isolation, member refusal, immutability, a used version id, upper-case ids, the database constraints);
  - unit tests in `internal/pack/builder_test.go`;
  - `TestMigrationRoundTrip` knows the new table and function;
  - `contract_kinds_test.go` pins `PackItemKind`.
- `delivery/stories.json`: the 86bcm901w entry (PR list filled in once this PR has a number).

## Test Plan

These ran on head `8a50486` on 2026-10-28. The pipeline's independent verifier ran them in a detached copy with its own `_test` database, and the blind AC auditor reran the ACs. Tools: Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0, gitleaks 8.30.1, PostgreSQL 18.6 (CI's image). When this PR is made, the gates run again on the exact pushed head and this list is updated.

- [x] `make check`, exit 0:
  - workspace, contracts-check, fmt, vet;
  - `go test -race -count=1` on every package;
  - lint 0 issues in both modules;
  - govulncheck: no called vulnerability (the "1 vulnerability in modules you require" note is the same on main `1ee7157`);
  - gitleaks: no leaks;
  - library gate PASSED (32 items);
  - build.
- [x] `scripts/test-module-add.sh`: exit 0
- [x] Postgres tests (`go test -json` over `internal/pack`, `internal/store/postgres`, `internal/web` and `internal/cloud/dbcheck`, read per test): 536 pass, 0 fail, 0 missing. The only 4 skips are the accepted ones: the two ClickHouse subtests of `TestTeamsAPIWithPostgres`, the live Scaleway test and the opt-in evidence-dir test. All 55 `TestPackBuilder*`/`TestMigrationRoundTrip` entries pass.
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: OK (5 tests)
- [x] gitleaks over the branch's 18 commits: no leaks. No `.github` change.
- [x] `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres` (3 subtests): pass
- [x] `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres` (4 subtests): pass
- [x] `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres` (6 subtests): pass
- [x] `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres` (15 subtests: no name, no items, unknown/malformed/repeated item, name taken, nothing changed, pack left empty, outdated version, member, bad CSRF, another company's pack, malformed pack id, signed out, strict JSON): pass
- [x] Each AC test fails on base `1ee7157` (build failure: the builder, routes and contract types don't exist there).
- [x] Mutation checks on this head:
  - the verifier: 39 mutants, all killed. They cover the triggers, admin and tenant checks, CSRF, the stale-parent check, the unique name, audit atomicity, the diff and the tick handling.
  - the blind auditor: 15 mutants, all killed.
  - Two builder mutants are documented equivalents: M2 (the tenant key on one lock query, also enforced by the composite FK) and M6 (an ignored audit error, also caught because Postgres aborts the transaction).
- [x] Admin console in dev mode on a throwaway database, with a binary built at `8a50486` (auditor): tick 4 items and Create pack gives "version 1" with those 4 ticked; untick one and tick another gives "version 2 … from version 1"; the change history for the pack shows `pack.create` and `pack.version.create` with actor and diff; the same name in other case gives the inline 409 alert.
- [ ] Hosted CI "Go quality gates": not run yet. Nothing is pushed.

## Security, migration, rollback

- **Security:**
  - Every route is admin-only, reads included (`requireAdmin`; a member gets 403 `ADMIN_REQUIRED`). The store re-checks the role inside each write transaction.
  - Another company's pack is 404, and every query is tenant-keyed. The lineage FK is `(tenant_id, pack_id)`, so the database refuses a cross-tenant link.
  - JSON writes need `X-CSRF-Token` equal to the CSRF cookie; console forms use the existing form CSRF check.
  - Bodies are capped at 64 KiB, and JSON is strict.
  - SQL is parameterized; HTML is rendered by `html/template`.
  - Audit records hold ids, counts and kind/name/version refs, never item bodies or files.
  - No auth bypass or dev-login change.
- **Migration:** 23 is expand-only:
  - a new table, two nullable columns, constraints that existing rows already satisfy (both columns NULL), and two triggers;
  - existing pack versions (seed base, forks, single-item edits) keep `pack_id` NULL and behave as before.
  - **Behaviour change for every pack version:** the triggers make all saved pack versions and items impossible to UPDATE or DELETE, not only built ones. No code path does either today (checked). A future "delete a pack" or tenant offboarding must change this deliberately.
- **Rollback:**
  - Revert the PR, then run migration 23's down. It drops the triggers and their function, the four constraints, both columns and `pack_lineages`.
  - Built versions stay as ordinary pack versions, without their pack name or number.
  - Rolling back further also works: 23's down drops the triggers before the older downs delete items (`TestMigrationRoundTrip`).
  - The rollback loses data (names and numbers), so prefer fix-forward.

## Assumptions

- Justin's answers on the plan (2026-10-28):
  - pack names are unique per company, ignoring case and surrounding spaces (409);
  - only packs made in the library get numbered versions; starter-pack versions and forks can't be edited here.
- "Version N" is the number admins see per pack. The version id string stays the key that assignments, the bundle and Sync use.
- A save must start from the pack's latest version, or it gets 409 and nothing is saved. Branching from an older version isn't offered.
- New versions are never assigned automatically. Ticks don't survive a filter change (filter first, then tick).
- Item order isn't stored; versions list items by kind, then name. Reordering and removing non-library items is 86bcm901y.
- Every new version gets new item ids, so script items need approval again on Pack Versions, even unchanged ones (follow-up below).
- Through the JSON API, adding an item already in the pack is refused. Removing and adding it in one call replaces it, and the diff records that as "changed".
- Test Postgres ran on 127.0.0.1:55432, because 5432 was taken on the build machine. CI uses its own service.
- The client keeps its own copy of the OpenAPI spec. Refreshing it (`leorna-client/api/`, `make generate`) is optional: it adds unused types only.
- **Sibling stories from the same base:**
  - PR #94 (86bcm9021) conflicts in one place, `internal/web/handler.go`: both add a field after `packVersions`. Keep both. `main.go`, the pack README and `stories.json` merge cleanly. A trial merge built, vetted and passed the non-database tests.
  - 86bcm901a, 86bcm901b and 86bcm901j conflict only in `delivery/stories.json`: take main's file and append this entry last. None of them adds a migration, so 23 stays free.
  - Whichever merges second reruns its gates on the merged code.
- **Follow-ups** (not in this PR):
  1. 86bcm901b's `requires`: when an admin ticks a prompt, add or warn about its required library items (`Library.Required`). The plug-in point is after `ApplyChange` in `CreatePack`/`SavePackVersion`.
  2. 86bcm901y: reorder items (stored position), remove items that didn't come from the library, and the client's matching removal.
  3. Fork, SaveEditedVersion and add-library-item (and #94's `CreateItem`) create pack versions without a change record. This is pre-existing; `internal/audit/README.md` says every mutation must call `appendAudit`.
  4. Add a **Pack** entry to `GLOSSARY.md` once #94 lands.
  5. Carry a script approval forward when an item's script is unchanged.
  6. 86bcm902d: show "pack name · version N" on Assignments and Pack Versions, plus rename and delete.
  7. The JSON API accepts any stored library item id, including older versions the catalog no longer lists (the page only offers the newest). Decide whether to refuse superseded ids once 86bcm901a's code-reviewer 2.0.0 lands.
  8. By code reading (not yet probed), team and project console actions file change records under the raw path id, so a save from an upper-case UUID URL may be missing from that item's history. It is the same pattern this PR fixes for packs, pre-existing on main (`internal/store/postgres/teams.go`, `projects.go`).

## Evidence

- Head: `8a5048694d40ee975c7b3c276ca1b8af521cae5d` (base `1ee7157`)
- Required check: "Go quality gates"
- Actions run: pending until pushed
