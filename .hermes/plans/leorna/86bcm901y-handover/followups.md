# 86bcm901y: other things found and follow-ups (one list for the PR)

Sources:
- the plan's Follow-ups F1–F6, Risks and "Other things found";
- `~/.hermes/plans/leorna/found-else.md` under 86bcm901y, plus the 901y auditor's two lines filed under the 902a review 2 heading;
- this finisher's integration check (`integration.md`).

None is fixed in this story.

## Product and code follow-ups (the PR's Follow-ups list)

| # | Kind | What | Where / evidence | Who decides |
| --- | --- | --- | --- | --- |
| 1 | Client test (plan F1, Q1-B) | A Sync test that removes a whole item (not only supporting files) and checks that a locally edited file is kept and flagged, in all three tools | the client's existing coverage is `TestSyncEndToEndWithLoginMockTLSAndRealWriters` (supporting files) and `TestApplyRemovesOnlyUnchangedManagedFile` | Justin (a small client story if wanted) |
| 2 | Client UX (plan F2; found-else P3, pre-existing) | When an edited file blocks a removal, Sync fails the whole tool with "Native files were not changed for this tool" and no file name. Name the file | leorna-client `application/sync.go:276-283` | client owner |
| 3 | Product/security (plan F3; found-else P3, pre-existing) | Every pack-builder save, even a pure reorder, gives items new row ids, so scripts need approval again. Consider carrying an approval forward when the script bytes are unchanged | `internal/pack/README.md:225`; approvals are keyed by `pack_version_item_id` | Christian (a security choice) |
| 4 | Console (plan F4) | Bulk reordering (position boxes) or drag and drop, if admins rearrange large packs often. Drag and drop needs a CSP-nonced script | Q2-B in the plan | Justin |
| 5 | 86bcm902d (plan F5) | Show `reordered` and the two orders in the version history view | audit record already carries them | 902d |
| 6 | Contract (plan F6, Q3-B) | If item order ever matters to a tool, add `position` to the bundle contract (both repos; every assigned pack re-syncs once) | `internal/bundle/bundle.go` sorts by path | Justin + client owner |
| 7 | Test gap (low, 901y auditor) | No repo test lists or removes an item that is no longer in the library (plan D5). Mutant MA4, which hides such items, passes AC1 and all of `./internal/web`. Probe P2 shows head handles it | `evidence/86bcm901y/auditor/mutants-3e8d181.txt`, `probes-3e8d181.log` | next story touching the item list |
| 8 | Test strength (low, 901y auditor) | AC3's sync subtest reorders items that have no supporting files, so a reorder that drops supporting files (MC7) passes AC3. `TestApplyChangeOrdersTheResult` (`internal/pack/builder_order_test.go:55`) catches it, and probe P1 shows head syncs the same 4 paths and hashes | same receipts | same |
| 9 | Test gap (nit, 901y verifier) | AC4's `another_company_pack` posts a current `parent_version`, so the new route's 409 and 400 pages for a foreign tenant rely on 901w's `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres/another_company_pack`. A foreign-tenant case with a stale `parent_version` expecting 404 would test the route directly | `evidence/86bcm901y/verifier/mutations-summary-3e8d181.txt` | same |

## Integration items (for whichever story merges second; details in `integration.md`)

| # | With | What the later story does |
| --- | --- | --- |
| I1 | #98, 901r, 902a | `delivery/stories.json`: take main's file and append its own entry last, as text; check earlier entries by value |
| I2 | 901r, 902a | Migration 24 is claimed three times (`000024_pack_item_order`, `000024_starter_packs`, `000024_quick_starts`). The later story renames its own pair to the next free number, along with the "migration 24" mentions in its docs and comments, and reruns G1–G4 |
| I3 | 901r | `internal/web/library.go` `libraryCSS`: keep both additions; `internal/pack/README.md`: keep both appended sections |
| I4 | 901r | `starter_packs.go:140` must call `insertVersionItems(ctx, tx, id, items, false)` (901y added the `ordered` argument). This keeps starter versions listing by kind, then name |
| I5 | 901r | Two test helpers named `mintDesktopToken` in package `web` (`pack_items_test.go:124` and `starter_packs_test.go:221`). The later story renames its own |
| I6 | 902a (at `19baa19` and `9a9bdec`) | `internal/web/quick_start_test.go:1146` must call `SaveVersion(…, pack.VersionChange{AddLibraryItemIDs: []string{added}})` |

## Process notes (not for the PR)

- **P3 (process, already in the `leorna` skill):** the 901y builder ran a repo-wide `git worktree prune`, which removed the stale registration of `~/.cache/86bcm901j-fixer6/head-d723e04`. That folder was already gone, and 901j's worktree and branch are intact.
- **P3 (process):** on this desktop `127.0.0.1:5432` is the `leorna-pg` container, not the test database `leorna-test-pg` (`:55432`). 901w's plan variables pointed at 5432 (`86bcm901w-create-pack.md:1087`).
- **Info:** the client's OpenAPI snapshot is behind the server's (no `/v1/packs`), as known from 901w's F3. The optional `order` changes nothing there.
- **Info (this finisher):** 86bcm902a's branch gained 7 commits (`707a4c0` → `9a9bdec`) during this hand-over, one of which added the old-signature `SaveVersion` call (I6). Recheck 902a's head at merge time.
