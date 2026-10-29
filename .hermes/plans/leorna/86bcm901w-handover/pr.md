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
- `delivery/stories.json`: the 86bcm901w entry, listing this PR (#96).

## Test Plan

Everything below ran on head `5a9aa2f` on 2026-10-28. That head is the branch with GitHub `main` (`a8d1465`, after #95, #94 and #97) merged in. The gates ran twice on it, once by the fixer that made the merge and once by the pipeline's independent verifier. Each run used a detached copy of that exact head and its own `_test` database. Tools: Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0 and gitleaks 8.30.1 (CI's pins), and PostgreSQL 18.6. The verifier and a blind AC auditor did the console runs and mutation checks on the same head.

- [x] `make check`, exit 0 (both runs):
  - workspace, contracts-check, fmt, vet;
  - `go test -race -count=1` on every package;
  - lint 0 issues in both modules;
  - govulncheck: no called vulnerability. The "1 vulnerability in modules you require" note comes from main's dependencies: this branch changes no `go.mod` or `go.sum`.
  - gitleaks: no leaks in the repository's 410 commits;
  - library gate PASSED (43 items);
  - build.
- [x] `scripts/test-module-add.sh`: exit 0 (both runs)
- [x] Postgres tests (`go test -json` over `internal/pack`, `internal/store/postgres`, `internal/web` and `internal/cloud/dbcheck`, read per test, both runs):
  - 558 results: 554 pass, 0 fail; all 289 declared top-level tests ran.
  - The only 4 skips are the accepted ones: the two ClickHouse subtests of `TestTeamsAPIWithPostgres`, the live Scaleway test and the opt-in evidence-dir test. No skip names `LEORNA_TEST_DATABASE_URL`.
  - All 55 `TestPackBuilder*`/`TestMigrationRoundTrip` entries pass.
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: OK (5 tests)
- [x] gitleaks: no leaks in either scan.
  - `gitleaks git` over `a8d1465..5a9aa2f` scanned 19 commits. It skips a merge commit's own content.
  - So `gitleaks dir` also scanned the four files both sides changed, as merged.
- [x] Scope:
  - no `.github` change;
  - no existing migration changed: only `000023` is added, and main's newest is still `000022`;
  - all 20 commits by the Leorna identity, with no AI attribution lines.
- [x] Merge check (verifier):
  - Every file only one side changed equals that side's version (113 paths, 0 mismatches).
  - The story's 20 own files are byte-identical to the pre-merge head `5e29c56`.
  - Only `internal/web/handler.go` and `delivery/stories.json` were resolved by hand.
- [x] `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres` (3 subtests): pass
- [x] `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres` (4 subtests): pass
- [x] `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres` (6 subtests): pass
- [x] `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres` (15 subtests: no name, no items, unknown/malformed/repeated item, name taken, nothing changed, pack left empty, outdated version, member, bad CSRF, another company's pack, malformed pack id, signed out, strict JSON): pass
- [x] The verifier and the auditor each ran every AC test on its own on `5a9aa2f`. Each test also fails on base `a8d1465` with the head's test file copied in: the build fails because the builder, routes and contract types don't exist there.
- [x] `ac-check.sh` over the verifier's and the auditor's AC reports: `ALL ACCEPTED: 4 of 4 ACs on 5a9aa2f`.
- [x] Mutation checks on this head:
  - The fixer and the verifier dropped each side's `handler.go` hunk (overlay mutants). Dropping this story's routes fails the four AC tests; dropping #94's routes fails #94's item-builder tests.
  - The blind auditor ran 20 mutants, all killed by the AC tests' own assertions. They cover version numbering, ticked items, parent version, the immutability triggers, the audit diff, action and actor, audit atomicity, the tenant filter, `requireAdmin`, CSRF, the unique name and the stale-parent check.
  - Earlier, on head `8a50486` (before main was merged in), the verifier's 39 mutants and the auditor's 15 were all killed. Two builder mutants there were documented equivalents. M2 is the tenant key on one lock query, which the composite FK also enforces. M6 is an ignored audit error, which is also caught because Postgres aborts the transaction.
- [x] Admin console in dev mode on a throwaway database, with a binary built at `5a9aa2f` (verifier and auditor):
  - ticking items (4 in the auditor's run; 5 in the verifier's, including items that #95 and #97 added to main) and pressing Create pack gives "version 1" with exactly those items ticked;
  - unticking one and ticking another gives "version 2 … from version 1";
  - the pack's change history shows `pack.create` and `pack.version.create` with actor and diff.
  - The same name in another case gave the inline 409 alert in the console on `8a50486`. On `5a9aa2f`, AC4's "name taken" subtest covers it.
- [x] Hosted CI on `5a9aa2f` (run 40804136869, `pull_request`): "Go quality gates" success; "Publish control-plane image" success (build and Trivy scan; the push steps are skipped on a PR); "Package admin-portal distribution" success.
- History: hosted CI on the previous head `8a50486` (run 40787263343, `pull_request`): "Go quality gates" success; "Publish control-plane image" success (build and Trivy scan; the push steps are skipped on a PR); "Package admin-portal distribution" success.

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
- Main was merged in after #95, #94 and #97 (`handler.go`: kept both the pack-builder and item-builder wiring; `stories.json`: this story's entry appended last).
- **Follow-ups** (not in this PR):
  1. 86bcm901b's `requires`: when an admin ticks a prompt, add or warn about its required library items (`Library.Required`). The plug-in point is after `ApplyChange` in `CreatePack`/`SavePackVersion`.
  2. 86bcm901y: reorder items (stored position), remove items that didn't come from the library, and the client's matching removal.
  3. Fork, SaveEditedVersion and add-library-item (and #94's `CreateItem`) create pack versions without a change record. This is pre-existing; `internal/audit/README.md` says every mutation must call `appendAudit`.
  4. Add a **Pack** entry to `GLOSSARY.md`. #94 has landed, and the glossary still has only "Pack version".
  5. Carry a script approval forward when an item's script is unchanged.
  6. 86bcm902d: show "pack name · version N" on Assignments and Pack Versions, plus rename and delete.
  7. The JSON API accepts any stored library item id, including older versions the catalog no longer lists (the page only offers the newest). Decide whether to refuse superseded ids, now that 86bcm901a's code-reviewer 2.0.0 is on main (#97).
  8. By code reading (not yet probed), team and project console actions file change records under the raw path id, so a save from an upper-case UUID URL may be missing from that item's history. It is the same pattern this PR fixes for packs, pre-existing on main (`internal/store/postgres/teams.go`, `projects.go`).

## Evidence

- Head: `5a9aa2f6c4c219234b49d9f9bd17e83942790437`. It merges GitHub `main` `a8d1465` into the branch; the branch started from `1ee7157`.
- Required check: "Go quality gates"
- Actions run: https://github.com/LeornaAI/leorna-control-plane/actions/runs/40804136869 (CI, `pull_request` on `5a9aa2f`, conclusion success: "Go quality gates", "Publish control-plane image" and "Package admin-portal distribution" all success)
- Previous head `8a50486`: https://github.com/LeornaAI/leorna-control-plane/actions/runs/40787263343 (CI, `pull_request`, conclusion success: "Go quality gates", "Publish control-plane image" and "Package admin-portal distribution" all success)
- Local gates on this head (2026-10-28), run by both the fixer and the verifier, each exit 0 and kept with the story's evidence (one log per gate plus a `SUMMARY-gates-5a9aa2f.txt`):
  - `make check` and `test-module-add.sh`;
  - the Postgres `go test -json` stream, read per test;
  - the story gate;
  - gitleaks (the commit range, plus the files both sides changed);
  - the scope checks.
- AC reports on this head: the verifier's and the blind auditor's. `ac-check.sh` over both: `ALL ACCEPTED: 4 of 4 ACs on 5a9aa2f`.
