# PR text: 86bcm901y

Proposed title (pass with `--title`; the body file below has no title line):

```
feat(86bcm901y): remove and reorder items in a pack version
```

Body file: `/home/justin/.hermes/cache/scratch/leorna-pr-86bcm901y-remove-reorder.md`, refreshed by fixer 3 for head `d84fd04` (GitHub `main` `dd006b7` merged in). Use it with `gh pr create --body-file`. After the PR exists, add its number to `delivery/stories.json` (a small commit, which needs a fresh gate run), move the Evidence head to that commit, and fill in the Evidence block's CI run.

---

## Summary

Admins can now remove items from a pack and change their order without starting over. A pack's edit view (`/admin/library/packs/{packId}`) lists the version's items in order. Each item has **Move up**, **Move down** and **Remove**. Each click saves the next immutable version (ParentVersion = the version shown, which stays unchanged) and writes a `pack.version.create` change record. Remove works for every item, including items the library page doesn't show (filtered out, or no longer in the library). The admin JSON API takes an optional `order` in `POST /v1/packs/{packId}/versions`: the complete order of the new version's items, applied after removals and additions. Order is stored per item as `pack_version_items.position` (migration 24). Versions saved by the pack builder store 1…n. Every other version keeps 0 and still lists by kind, then name. A removal reaches engineers once an admin assigns the new version: its lockfile no longer lists the item's files, and the desktop (unchanged) deletes them unless an engineer edited them. Order never reaches the bundle, so a reorder-only version syncs the same files and hashes. No CI change, and no client change.

ClickUp: [Remove and reorder items in a pack version](https://app.clickup.com/t/86bcm901y)

## Changes

- `internal/store/postgres/migrations/000024_pack_item_order.{up,down}.sql`: `pack_version_items.position integer NOT NULL DEFAULT 0` with `CHECK (position >= 0)`, and a partial unique index on `(pack_version_id, position) WHERE position > 0`. The down drops both and keeps the rows.
- `internal/pack/builder.go`:
  - `Change.Order`: every resulting item exactly once, applied after Remove and Add. `ApplyChange` refuses an order that misses, repeats or invents an item, or an order-only change that keeps the parent's order.
  - `Diff.Reordered` (`omitempty`).
  - `VersionChange`; `BuilderService.SaveVersion` now takes a `VersionChange` instead of `add, remove`.
  - `PackChange.Order` is bounded at 500.
- `internal/store/postgres/pack_versions.go`:
  - `insertVersionItems(…, ordered bool)`: builder versions store 1…n, while `CreateVersion` (Fork, Edit, Add library item, a new item on Pack Versions) stores 0.
  - `loadVersionItems` orders by position, then kind, then name.
- `internal/store/postgres/pack_builder.go`: `SavePackVersion` passes the order to `ApplyChange` and stores positions. A save that names an `order` adds `order` (as `kind/name`) to both the before and after values of its audit record. Saves without one keep #96's shape.
- `internal/web/pack_items.go` (new), `internal/web/handler.go`: `POST /admin/library/packs/{packId}/items` (`requireSession(requireAdmin(…))`, form CSRF, 4 KiB body) takes exactly one button (`remove`, `move_up` or `move_down` = item id) and one `parent_version`. It gives:
  - 303 on success;
  - an inline 400 alert for removing the only item, moving the first item up, moving the last item down, or an item that isn't in this version;
  - 409 with the newer-version alert for an outdated version;
  - 400 `INVALID_REQUEST` for no button, two buttons, or a missing or repeated `parent_version`.
- `internal/web/pack_builder.go`, `internal/web/library.go`:
  - the JSON handler passes `order`, and a present but empty `order` is 400 `INVALID_PACK`, even beside other changes;
  - the edit view renders "Items in version N, in order" with the buttons (first item's Move up, last item's Move down and a lone item's Remove are disabled), marking items that aren't in the library;
  - the "not in the library" note now says those items can be removed below.
- `contracts/control-plane.openapi.yaml`, `packages/contracts/controlplane.gen.go`: optional `PackVersionChange.order` (`minItems: 1`, `maxItems: 500`, `PackItemKey` items), plus descriptions on `PackCreate.libraryItemIds` and `PackVersionDetail.items`. The change is additive: the only removed lines are the replaced `summary` and description. The generated code is regenerated.
- Docs:
  - `internal/pack/README.md`: a "Remove and reorder items (86bcm901y)" section, and the 901w bullet now points to it;
  - `internal/web/README.md`: the item list, the route and its alerts;
  - `internal/bundle/README.md`: order never reaches the bundle.
- Tests:
  - the four AC tests in `internal/web/pack_items_test.go` (real HTTP and PostgreSQL; AC2 and AC3 drive the real desktop bundle and content endpoints with a desktop token);
  - `pack_items_form_test.go` (button → change);
  - store `TestPackItemOrderStoreWithPostgres` (positions, the CHECK and index, immutability, older versions keep listing by kind then name, the audit order);
  - unit tests in `internal/pack/builder_order_test.go`;
  - existing `SaveVersion` call sites in `builder_test.go` and `pack_builder_test.go` switched to `VersionChange`.
- `delivery/stories.json`: the 86bcm901y entry (PR number added once this PR exists).

## Test Plan

Everything below ran on head `d84fd04` on 2026-10-29. That head merges GitHub `main` (`dd006b7`, which includes #98) into the reviewed head `3e8d181`. It ran in the story's worktree with its own `_test` database. Tools: Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0 and gitleaks 8.30.1 (CI's pins). Hosted CI runs on this PR.

- [x] Merge of `main`: the only conflict was `delivery/stories.json`. It was resolved by taking main's file and appending this story's entry last; every earlier entry is unchanged.
  - Every other file equals one side's version.
  - There is no duplicate migration number; this story's 24 is still the newest.
  - Outside `delivery/stories.json`, this PR's diff against `main` is byte-identical to the reviewed `3e8d181` diff.
- [x] `make check`, exit 0:
  - workspace, contracts-check, fmt, vet;
  - `go test -race` on every package;
  - lint 0 issues in both modules;
  - govulncheck "No vulnerabilities found" in both modules;
  - gitleaks no leaks;
  - library gate PASSED (main's library 0.8.0);
  - build.
- [x] `scripts/test-module-add.sh`: exit 0
- [x] Postgres tests (`go test -json` over `internal/cloud/dbcheck`, `internal/store/postgres` and `internal/web`, read per test):
  - 527 results: 523 pass, 0 fail, and 0 declared tests missing.
  - The only 4 skips are the accepted ones (the two ClickHouse subtests, the live Scaleway test and the opt-in evidence-dir test). No skip names `LEORNA_TEST_DATABASE_URL`.
  - All 106 `TestPackBuilder*`/`TestPackItems*`/`TestPackItemOrderStoreWithPostgres`/`TestMigrationRoundTrip` entries pass, including #96's suite, unchanged apart from the `SaveVersion` call sites.
- [x] `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres` (5 subtests): pass
- [x] `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres` (4 subtests): pass
- [x] `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres` (6 subtests): pass
- [x] `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres` (22 subtests; each refusal checks its status, code or alert and that no version or audit row was written): pass. The cases are: the only item, first up, last down, an item not in this version, an outdated version (console and JSON), no or two buttons, a missing or repeated `parent_version`, a form over 4 KiB, member, bad CSRF, another company's pack, signed out, and an order that misses, invents, repeats or removes an item, changes nothing, is too long, or is empty.
- [x] `TestPackItemOrderStoreWithPostgres`: pass
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: OK
- [x] gitleaks over this PR's commits (`dd006b7..d84fd04`), and over the merged `delivery/stories.json`: no leaks.
- [x] Scope: no `.github` change; the only new migration is `000024`, and no existing migration changed; all 14 commits (13 plus the merge) are by the Leorna identity with no AI attribution lines; the contract is unchanged since `3e8d181`; `check-generated-contracts.sh` exit 0.
- [ ] Acceptance on the PR head: being rerun. On the reviewed head `3e8d181`, before `main` was merged in, the pipeline's independent verifier and a blind AC auditor each ran every AC test. They also ran each AC test on base, where it fails. Their other checks were mutation checks, migration 24 over existing data, a dev-mode admin console run on a loopback server and the container build. `ac-check.sh` gave `ALL ACCEPTED: 4 of 4 ACs on 3e8d181`. A read-only run of the client's Sync tests (`f105e27`, no client change) also passed then.
- [ ] Hosted CI: running on this PR.

## Security, migration, rollback

- **Security:**
  - The new console route and the JSON `order` sit behind the same `requireSession(requireAdmin(…))` as #96's routes; a member gets 403. The store re-checks the role inside the write transaction.
  - Another company's pack is 404. Every read and lock is tenant-keyed, and migration 23's `(tenant_id, pack_id)` FK refuses a cross-tenant version.
  - The form uses the console's form CSRF check and a 4 KiB body bound; JSON keeps the `X-CSRF-Token` guard, strict decoding and the 64 KiB bound.
  - Item ids come from the shown version only. An id from any other version is a stale page (inline 400), never a lookup in another version.
  - SQL is parameterized and HTML is rendered by `html/template`. The redirect target is built from the server's pack id.
  - Audit records hold `kind/name` lists and counts, never item bodies or files.
  - No auth bypass, no dev-login change and no new dependency.
- **Migration:** 24 is add-only: a `position` column with default 0, a CHECK and a partial unique index.
  - Existing rows get 0, and a constant default rewrites no row, so migration 23's no-edit triggers don't fire.
  - Existing versions keep listing by kind, then name.
  - New pack-builder saves store 1…n.
  - Versions derived on Pack Versions (Fork, Edit, Add library item, new item) store 0, even from a built version, so they list by kind, then name and don't keep the admin's order (documented in `internal/pack/README.md`).
- **Rollback:** revert the PR, then run migration 24's down. It drops the index and the column and keeps every row. Versions then list by kind, then name. Built versions saved meanwhile keep their items, but lose their order. No data is lost except the order.

## Assumptions

- Plan approved under Justin's away grant (2026-10-29) with the recommended answers:
  - **Q1-A:** AC2 is proven by this repo's sync test (remove → assign → the desktop's lockfile drops exactly the item's files) plus a read-only run of the client's existing Sync tests. The card's Verify asks for a "client sync integration test": the client's existing `TestSyncEndToEndWithLoginMockTLSAndRealWriters` and `TestApplyRemovesOnlyUnchangedManagedFile` cover the desktop half, and no client test or code was added.
  - **Q2-A:** Move up and Move down buttons, each click saving a version. There is no JavaScript, so it works under the console's CSP. Bulk reordering goes through the API's `order`.
  - **Q3-A:** the order shows in the console and the API, and Sync is unchanged. The bundle and lockfile stay sorted by path.
- Only packs built in the library get the item list (#96's rule). Seed versions and forks keep today's Pack Versions flows.
- There is no confirmation step for Remove: the previous version stays and can be assigned again.
- The API's `order` is a complete order, not move steps. A present but empty `order` is refused (400), even beside other changes, so it is never silently ignored.
- The audit action stays `pack.version.create`. A save that names an `order` records both orders, even when it only places added items, because `diff.added` is sorted. Saves without an `order` keep #96's audit shape, and its AC3 test passes unchanged.
- AC4's setup makes version 2 through the JSON API rather than a console click, so the base-commit run reaches every refusal case.
- `BuilderService.SaveVersion` now takes `pack.VersionChange` instead of `add, remove`. Every caller on `main` is updated here. The in-flight quick-start story ("One-click quick start") adds one test caller with the old arguments (see the next point).
- The OpenAPI change is additive and optional, so the client needs no regeneration.
- Test Postgres ran on 127.0.0.1:55432, because 5432 is another container on the build machine. CI uses its own service.
- **Integration:** `main` (with #98) is merged in here. Its only conflict was `delivery/stories.json`, resolved by appending this story's entry last. Checked against the local branches of the starter-packs story ("Role-based starter packs") and the quick-start story, neither yet pushed. Whichever story merges second:
  - appends its `delivery/stories.json` entry last, as text;
  - renames its own `000024_*` migration pair to the next free number, with the "migration 24" mentions in its docs and comments, because the starter-packs and quick-start stories also add a migration 24;
  - with the starter-packs story only: keeps both `libraryCSS` additions and both README sections; passes `false` at its new `insertVersionItems` call (`starter_packs.go`); and renames one of the two `mintDesktopToken` test helpers in `internal/web`;
  - with the quick-start story only: switches its `quick_start_test.go` `SaveVersion` call to `pack.VersionChange{AddLibraryItemIDs: …}`;
  - then reruns its gates.
- **Follow-ups** (not in this PR):
  1. Client: a Sync test that removes a whole item (not only supporting files) and checks that a locally edited file is kept and flagged, in all three tools.
  2. Client: when an edited file blocks a removal, Sync says only "Native files were not changed for this tool". Name the file.
  3. Every pack-builder save, even a pure reorder, gives items new row ids, so script items need approval again. Consider carrying an approval forward when the script bytes are unchanged (a security choice, for Christian).
  4. Console: bulk reordering or drag and drop, if admins rearrange large packs often (drag and drop needs a CSP-nonced script).
  5. "Manage many packs per tenant in one screen": show `reordered` and the two orders in the version history view.
  6. If an item's order ever matters to a tool, add `position` to the bundle contract (both repos; every assigned pack re-syncs once).
  7. Test gaps found by the blind auditor, each probed as correct on this head:
     - no test lists or removes an item that is no longer in the library;
     - AC3's sync subtest reorders items without supporting files (the unit test `TestApplyChangeOrdersTheResult` covers that case);
     - AC4's other-company case posts a current `parent_version`, so the new route's 409 and 400 pages for a foreign tenant rely on #96's suite.

## Evidence

- Head: `d84fd046994d606e1f79c2faa4b2c15cc063dab3`, the merge of the reviewed head `3e8d18197575c772c6d34fcdd10f06e5911168fc` with GitHub `main` `dd006b79f9908976e853c57489032bd5d9d471df` (story base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`)
- Required check: "Go quality gates": pending
- Actions run: pending
- Local gates on this head (2026-10-29), each exit 0 and kept with the story's evidence (one log per gate, plus a summary):
  - `make check`, `test-module-add.sh`, and the Postgres `go test -json` stream read per test;
  - the four AC tests and the store order test;
  - gitleaks on this PR's commits;
  - scope and authors, and the contract and generated-code checks;
  - the story gate, and the merge proof.
- AC reports: the verifier's and the blind auditor's on `3e8d181` (`ac-check.sh`: `ALL ACCEPTED: 4 of 4 ACs on 3e8d181`); both are being rerun on this head.
