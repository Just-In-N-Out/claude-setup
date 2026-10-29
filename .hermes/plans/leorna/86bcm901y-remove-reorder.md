# 86bcm901y — Remove and reorder items in a pack version (control plane)

## Questions for Justin (⭐ = recommended; answered ⭐ under the away grant)

**Q1. How do we prove the card's "files removed from their tools (or flagged)"?**
- **A ⭐ Control-plane sync test, plus the client's existing Sync test**
- B. Also add a client test-only branch for whole-item removal

The desktop already deletes files that a new lockfile no longer lists, and keeps (flags) a file the engineer edited. That shipped in client commit `3eec75d` (Yan, 2026-10-24) and is tested there. With A, this story's AC2 test proves the server half end to end: remove → assign → the desktop's lockfile drops exactly that item's files. The verifier and auditor also run the client's own Sync e2e test read-only as a supporting receipt. Nothing changes in `leorna-client`.
If B: add a second worktree `~/Leorna/leorna-client/.claude/worktrees/86bcm901y-remove-reorder` on `feat/86bcm901y-remove-reorder` with one new test, `TestSyncRemovesADroppedItemFromEveryToolAndKeepsAnEditedOne` (`application/sync_removal_e2e_test.go`). It would run the client gates (`make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit`), which have never been run on this WSL desktop, and need a second PR. It can't be one of `ac-check.sh`'s ACs, because that script checks one repo. About +1.5 h.

**Q2. How does an admin reorder items in the console?**
- **A ⭐ "Move up" / "Move down" buttons; each click saves a version**
- B. Position boxes plus one "Save order" button

With A, there's no JavaScript, it works under the console's CSP, and each click is one audited version. Big rearrangements go through the API's `order` field in one save.
If B: each list row gets `<input type="number" name="position">` and the form gets one submit. `itemOperationChange` becomes `positionsToOrder` (it must reject gaps, repeats and out-of-range values), the AC3 and AC4 console subtests post positions instead of buttons, and the captures fill the boxes. About +45 min.

**Q3. Should the item order reach engineers' tools?**
- **A ⭐ No: order shows in the console and API; Sync is unchanged**
- B. Yes: add the order to the bundle contract (client change too)

No tool output depends on item order. The client writes one file per item and sorts MCP servers by name (`leorna-client toolconnector/transform.go:177`). The bundle and lockfile are sorted by path (`internal/bundle/bundle.go:78`). With A, a reorder-only version syncs byte-identical files, and AC3's test proves it.
If B: `BundleFile` gains `position`. That changes every assigned pack's digest (a one-time re-sync for everyone) and needs a client regeneration plus storage. It is client work outside this Size-S card. Add a follow-up card instead.

## Away grant (Justin, 2026-10-29)

Justin's words: "just keep everything going and follow what the recommended agent says." The main session reads that as **go** on this plan with every ⭐ answer above (Q1-A, Q2-A, Q3-A) and its ACs, including the proposed AC4. The grant covers plan approval and ⭐ answers **only**. Push, a PR, any ClickUp post or status change, and any merge stay **unauthorized** until Justin says the word himself.

- **Card:** [Remove and reorder items in a pack version](https://app.clickup.com/t/86bcm901y) (E11 Pack Builder, PI-2, Size S, p2-medium, assigned to Justin, "to do"). Its only dependency, [Create a pack by picking library items](https://app.clickup.com/t/86bcm901w), is **complete** (PR #96 merged as `6c1709e`). No ClickUp card depends on 901y. 9026, 902a and 902d depend on 901w, and this plan leaves room for them (D11).
- **Repo / worktree / branch:** `leorna-control-plane` only (Q1-A). Worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder`, branch `feat/86bcm901y-remove-reorder`.
- **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (Merge PR #96, 86bcm901w). Checked 2026-10-29 09:48 UTC: HTTPS fetch through gh, then `git merge --ff-only origin/main` in the main checkout ("Already up to date"). Local `main` = `origin/main` = GitHub `main` (`gh api repos/LeornaAI/leorna-control-plane/commits/main`) = base. The main checkout is on `main` with only an untracked `.claude/`. The client's GitHub `main` is `f105e27`.
- **Pipeline:** Full. Every role is a fresh Opus 5.5 xhigh agent. Nothing is pushed, posted or merged.

## Acceptance criteria

AC1 and AC2 are the card's, in its own words. AC3 is Justin's reorder addition. AC4 is mine (proposed): it covers the DoD's failure case and the guards. No AC needs Justin's hands, so none is `(live)`. Each test's whole name sits on its AC line.

- AC1: Given a pack version, when I remove an item, then a new version is saved without it and audited — test `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`
- AC2: Given a removal, when engineers next sync, then the item's files are removed from their tools (or flagged) consistently with the lockfile — test `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`
- AC3 (Justin): Given a pack version, when I reorder its items (Move up / Move down in the console's item list, or `order` in the API), then a new version is saved with its items in the new order, the console list and the API show that order, the parent keeps its old order, the save is audited with the order before and after, and once assigned it syncs the same files and hashes as its parent — test `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres`
- AC4 (proposed): Given a remove or reorder that is invalid or not allowed (removing the only item, moving the first item up or the last down, an item not in this version, an order that misses, repeats or invents an item, an order that changes nothing, an outdated version, a member, a bad CSRF token, another company's pack, signed out), then it is refused with a clear status or inline alert and nothing is written (no version, no audit record) — test `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres`

## Playback and summary

**Playback:** an admin can remove items from a pack and change their order without starting over. Each remove or reorder saves a new immutable version (ParentVersion = the version it came from) and writes an audit record. A removed item's files leave engineers' tools on their next Sync, consistently with the lockfile. A new order shows in the console and the API, and Sync is unaffected because no tool depends on order.

**Summary:**
1. **Migration 24** adds `pack_version_items.position` (default 0, unique per version when > 0). Built versions store 1…n. Every other version keeps 0 and lists by kind, then name, as before.
2. **`pack.ApplyChange`** gains an optional full `Order`. `DiffItems` gains `reordered`, and the audit record carries the order before and after, but only when a save reorders.
3. **The edit view** `/admin/library/packs/{packId}` gets an ordered **"Items in version N"** list with Move up / Move down / Remove buttons. Each button posts to the new route `POST /admin/library/packs/{packId}/items`, which saves the next version.
4. **`POST /v1/packs/{packId}/versions`** gains an optional `order` (additive OpenAPI change; no client regeneration).
5. **AC2's test** drives the real desktop bundle endpoints. Removal reaching tools is client behaviour that already exists (Q1-A).

## What already exists (901w, merged) versus what 901y adds

| Capability | On `main` at base (`6c1709e`) | 901y |
| --- | --- | --- |
| Remove a **library** item from a built pack, new version with ParentVersion, `pack.version.create` audit with `diff.removed` | Yes: untick on the edit view (`ticksToChange`, `internal/web/pack_builder.go:415`), or `removeItems` in `POST /v1/packs/{id}/versions` (`internal/pack/builder.go:111` `ApplyChange`) | Unchanged. AC1's test also covers the API path, as a regression check. |
| Remove **any** item, including one the library page doesn't show (filtered out, or no longer in the library) | API only. The console can only untick rows it shows; "N item(s)… stay as they are" (`internal/web/library.go:254`) | **New code:** the item list's Remove button |
| Store and show an item order | **No.** `loadVersionItems` lists `ORDER BY i.kind,i.name` (`internal/store/postgres/pack_versions.go:303`); the API has no order field | **New code:** migration 24, `Order`, the item list, `order` in the API |
| Audit a reorder | No (a reorder's diff would be empty) | **New code:** `diff.reordered`, plus `order` in before and after |
| Sync of an assigned version: the bundle and lockfile list only its items, sorted by path | Yes (`internal/bundle/bundle.go:41-80`, `internal/web/client_bundle.go`, since 86bbu3xga) | **Proven, not changed:** AC2's test (removal) and AC3's sync subtest (reorder) |
| Desktop deletes files the new lockfile dropped; keeps and flags a file the engineer edited | Yes, in the client: `application/sync.go:243-265` (`bundle.Remove` = paths in the previous successful Sync record but not in the new bundle), `toolconnector/nativewrite/write.go:255-300` (deletes only if the SHA-256 still matches; otherwise `ErrConflict` and the tool reports `write_failed` with files unchanged). Tested by `TestSyncEndToEndWithLoginMockTLSAndRealWriters` (`application/sync_e2e_test.go:277-297`: support files that left the bundle are gone in all 3 tools) and `TestApplyRemovesOnlyUnchangedManagedFile` (`toolconnector/nativewrite/write_test.go:17`) | **Not changed (Q1-A):** run read-only as a supporting receipt for AC2 |

## Skills (build roles)

| Role | Loads, in order |
| --- | --- |
| Every role | `leorna` (role rules only; this plan already did its Step 1), `engineering-best-practices` |
| Builder | + `test-driven-development`; `mutation-testing-discipline` for the immutability, permission, tenant, CSRF, order-validation and audit guards (mutants M1–M14 below); `security-best-practices` (read `references/golang-general-backend-security.md`: GO-HTTP-002 body bounds, GO-HTTP-006 CSRF, GO-XSS-001 html/template, GO-INJECT-001 parameterized SQL, GO-REDIRECT-001); `multi-tenant-auth-management`; `api-contract-drift-guard` **[ends with Mandatory Validation and Agent Defect Loop]**; `backend-data-migrations` **[ends with Mandatory Validation and Agent Defect Loop]** |
| Reviewers 1 and 2 | + `requesting-code-review`, `code-review-practice` (report only), and the four specialists above |
| Fixers / finisher | + `receiving-code-review`, `test-driven-development`, `git-commit-rules` (finisher), and the specialists for the area touched |
| Verifier / AC auditor | + `references/ac-verification.md` (feature-dispatch), the specialists |

Two of these skills end with the Defect Loop, so the hand-over waits for a clean verifier and then the blind auditor and `ac-check.sh`. Agents don't start agents; the main session runs that loop. Not a bug, so no `systematic-debugging`.

**Every brief carries these rules:**
- List reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and never edit skills or memory. List other problems found in `found_else` (one line each, with evidence and severity) and don't fix them.
- Every role keeps its small scratch in a fresh `<scratchpad>/86bcm901y-<role>/` (created with `mkdir`, no `-p`) and removes only that folder, by its literal absolute path.
- `/tmp` is a small RAM tmpfs shared by every session here. Big temporary files (Go `TMPDIR`/`GOTMPDIR`, Chrome profiles, built binaries, detached copies) go in `~/.cache/86bcm901y-<role>/`, also removed at the end.

## Current context (facts this plan relies on, at `6c1709e`)

**Packs and versions**
- `internal/pack/builder.go`:
  - `ApplyChange` (`:111-143`): Remove first, then Add. Kept items keep the parent's order and adds are appended. Its comment (`:99-102`) says "Versions do not store an order… reordering is story 86bcm901y."
  - `DiffItems` (`:58-88`) gives `added`/`removed`/`changed`, sorted.
  - `PackChange` (`:165-188`) and `BuilderService.SaveVersion(ctx, actor, packID, parentVersion, add []string, remove []ItemKey)` (`:252-256`).
- `internal/store/postgres/pack_builder.go`:
  - `SavePackVersion` (`:69-125`) locks the lineage row (`FOR UPDATE`), refuses a stale parent (`pack.ErrStaleParent`), runs `ApplyChange` and inserts through `insertBuiltVersion` (`:265-295`). It appends `pack.version.create` with before `{version, number, itemCount}` and after `packAuditRecord` (`:299-312`).
- `internal/store/postgres/pack_versions.go`:
  - `insertVersionItems` (`:81-106`) is shared by `CreateVersion` (fork, single-item edit, create-item) and `insertBuiltVersion`.
  - `EnsureSeedBase` (`:224-287`) inserts seed items itself.
  - `loadVersionItems` (`:296-327`) is the one reader for every version (`GetByID`, `GetByVersion`, `GetPack`, bundle resolution) and orders `i.kind,i.name`.
- Migration 23 (`000023_pack_builder.up.sql`) puts `BEFORE UPDATE OR DELETE` row triggers on `pack_versions` and `pack_version_items` (SQLSTATE 42501). DDL such as `ADD COLUMN … DEFAULT` fires no row trigger. The last migration on `main` is **23**.
- Every saved version gets new item row ids. Script approvals are keyed by item row id (`loadVersionItems` joins `pack_script_approvals` on `pack_version_item_id`), so a new version's scripts need approval again before it can be served (README line 225, known since 901w).

**Console**
- Routes (`internal/web/handler.go:283-287`):
  - `POST /admin/library/packs` (create);
  - `GET /admin/library/packs/{packId}` (edit view, `libraryPackView`);
  - `POST /admin/library/packs/{packId}/versions` (ticks form, `packBuilderSaveForm`);
  - the four `/v1/packs…` JSON routes behind `requireSession(requireAdmin(packGuard(api)))`.
- `libraryTemplate` (`internal/web/library.go:236-292`):
  - The builder section is `{{with .Builder}}<section class="builder">…`, with heading `<span id="pack-version-heading">version N</span>`, the ticks form `#pack-builder` with a hidden `parent_version`, and "Your packs".
  - The library table rows are `<tr class="item">` with a checkbox per row.
- `adminForm` (`internal/web/cloud_plan.go:93`) checks CSRF and bounds the body to 4 KiB; `adminFormLimit` takes a caller's bound.
- `requireAdmin` answers 403 `ADMIN_REQUIRED` (`roles.go:19`). `requireSession` answers 401 `AUTH_REQUIRED` for POST. `packFormAlert`/`newerVersionAlert`/`writePackBuilderError` live in `pack_builder.go:84-101,393-408`.
- The library list is sorted by kind, then name, in byte order (`internal/store/postgres/library_catalog.go:36-41`). A console create therefore saves its ticks in that order.

**API contract**
- `PackVersionChange` (`contracts/control-plane.openapi.yaml:1767-1789`) has `parentVersion`, `addLibraryItemIds` and `removeItems` (`PackItemKey` = `{kind, name}`, `additionalProperties: false`). Its description already says "Later stories add optional fields (for example an item order)".
- The server decodes it strictly (`packJSON`, `DisallowUnknownFields`), so on base an `order` field is refused with 400 `INVALID_PACK`.
- `contract_kinds_test.go` (both repos) requires exactly 2 inline kind enums. `PackItemKey` already refers to the named `PackItemKind`.
- The client generates code from **its own snapshot** `api/control-plane.openapi.yaml`, which is already behind the server's: it lacks 901w's `/v1/packs` paths. The desktop never calls these admin endpoints.

**Tests and fixtures**
- `newPackBuilderFixture` (`internal/web/pack_builder_test.go:73`) gives library rows A `skill/code-review-checklist@1.0.0`, B `agent/test-writer@2.0.0`, C `skill/multi-file-demo@1.0.0` (with a **script**, so it can't be served until approved) and D `mcp_template/github-mcp@2.0.0`.
- Other helpers there: `packAPI`, `packForm`, `readStatus`, `decodeStrict`, `problemCode`, `countRows`, `jsonKeys`, `packAuditAfter`, `firstMatch`, `builderHeadingPattern`, `builderAlertPattern`, `tickState`.
- `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres` pins the audit after-keys to exactly `diff, itemCount, name, number, packId, parentVersion, version`, with strict decoding of `before` and `diff`. **So any new audit key must be omitted when a save doesn't reorder.**
- `TestDiffItemsEncodesEmptyListsAndOmitsPreviousVersionWhenAdded` (`internal/pack/builder_test.go:183`) pins the diff JSON `{"added":[],"removed":[],"changed":[]}`.
- The desktop path in tests is `TestPromptItemPublishToClientBundleWithPostgres` (`internal/web/prompt_publish_test.go`). It uses `SetPackAssignments`, `SetBundleServer`, `SetClientAuth` and `handler.discovery`, a real `clientauth` Begin → Approve → Exchange mint, a team assignment form (`team_id`, `version`), and `GET /v1/client/projects/{id}/bundle` and `/bundles/{digest}/content`.
- There are no admin-console node UI tests in this repo (`scripts/` has no `*-ui.test.cjs`). Console behaviour is tested by HTML assertions in Go, and screenshots come from chromedp v0.16.0 (already in `go.mod`), as in 901w (`~/.hermes/plans/leorna/evidence/86bcm901w/verifier/capture-main.go`).

## Host prerequisites (checked 2026-10-29, WSL Ubuntu desktop)

| Need | Found | Status |
| --- | --- | --- |
| Go 1.27.3 (go.mod / go.work) | `~/.local/leorna-toolchain/go/bin/go` → go1.27.3 (not on PATH) | OK, use with `GOTOOLCHAIN=local` |
| make | `/usr/bin/make` 4.4.1 | OK |
| gcc / cgo (`make test` runs `-race`) | gcc 15.2.0; `go env CGO_ENABLED` = 1 | OK |
| golangci-lint (CI pins 2.14.0) | `~/.local/leorna-toolchain/bin/golangci-lint` 2.14.0 | OK, bind `GOLANGCI_LINT=` |
| govulncheck (CI pins v1.7.0) | `~/.local/leorna-toolchain/bin/govulncheck` v1.7.0 | OK, bind `GOVULNCHECK=` |
| gitleaks (CI pins 8.30.1) | `/usr/local/bin/gitleaks` 8.30.1 | OK |
| Docker + `leorna-test-pg` | `docker ps` works (group `docker`); `leorna-test-pg` (postgres:18.6-alpine3.23) up, **published on 127.0.0.1:55432** | OK. **Not 5432:** 127.0.0.1:5432 is a different container, `leorna-pg` (postgres:16). |
| Chrome for Testing | `~/.cache/chrome-for-testing/chrome-linux64/chrome` + `~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` | OK |
| psql | absent | use `docker exec leorna-test-pg psql -U leorna …` |
| Disk | `/tmp` tmpfs 7.9 GB (19% used); `/` 920 GB free | big files go in `~/.cache/86bcm901y-<role>/` |

Nothing is missing, so there is no host question.

## Design

### D1. Order storage: migration 24 (`000024_pack_item_order`)

`internal/store/postgres/migrations/000024_pack_item_order.up.sql`:

```sql
-- Item order inside a pack version (story 86bcm901y). Versions saved by the
-- pack builder store positions 1, 2, 3...; every other version keeps 0 and
-- lists its items by kind, then name, as before. Adding a column with a
-- constant default changes no stored row, so migration 23's no-edit triggers
-- never fire.
ALTER TABLE pack_version_items
 ADD COLUMN position integer NOT NULL DEFAULT 0
 CONSTRAINT pack_version_items_position_check CHECK (position >= 0);
-- No two items of one ordered version share a position.
CREATE UNIQUE INDEX pack_version_items_position ON pack_version_items (pack_version_id, position) WHERE position > 0;
```

`000024_pack_item_order.down.sql`:

```sql
DROP INDEX pack_version_items_position;
ALTER TABLE pack_version_items DROP COLUMN position;
```

- **Order rule (every reader):** `ORDER BY i.position, i.kind, i.name`.
  - Seed base, forks, single-item edits and create-item (position 0) list exactly as today.
  - Built versions saved before migration 24 (position 0) also list by kind, then name. Their next save writes positions 1…n in that order.
- **Expand-only migration:** no backfill, no `UPDATE`, nothing rewritten. Rollback drops the column, and every version then lists by kind, then name again. Prefer fix-forward.
- **`TestMigrationRoundTrip` needs no change** (no new table or function). `resetDatabase` drops `pack_version_items` with `CASCADE`.

### D2. Domain (`internal/pack/builder.go`)

Replace the `Change` type and `ApplyChange` (`:99-143`), and add three helpers:

```go
// Change is one save's edit to a parent version's items: Remove applies first,
// then Add, then Order. Without Order, kept items keep the parent's order and
// added items follow in the order given. Order, when set, lists every
// resulting item exactly once, first item first (story 86bcm901y).
type Change struct {
	Add    []SeedItem
	Remove []ItemKey
	Order  []ItemKey
}

// ApplyChange returns the next version's items and never modifies parent.
// An empty change, removing an item the parent lacks, naming an item twice,
// adding one that is still present after the removals, an order that does
// not name every resulting item exactly once, or an order-only change that
// keeps the parent's order is invalid.
func ApplyChange(parent []SeedItem, change Change) ([]SeedItem, error) {
	if len(change.Add) == 0 && len(change.Remove) == 0 && len(change.Order) == 0 {
		return nil, invalid("change")
	}
	present := make(map[ItemKey]bool, len(parent))
	for _, item := range parent {
		present[item.Key()] = true
	}
	removing := make(map[ItemKey]bool, len(change.Remove))
	for _, key := range change.Remove {
		key.Name = strings.TrimSpace(key.Name)
		if !key.Kind.Valid() || !present[key] || removing[key] {
			return nil, invalid("item to remove")
		}
		removing[key] = true
	}
	next := make([]SeedItem, 0, len(parent)+len(change.Add))
	kept := make(map[ItemKey]bool, len(parent)+len(change.Add))
	for _, item := range parent {
		if !removing[item.Key()] {
			next = append(next, item)
			kept[item.Key()] = true
		}
	}
	for _, item := range change.Add {
		if kept[item.Key()] {
			return nil, invalid("item to add")
		}
		kept[item.Key()] = true
		next = append(next, item)
	}
	if len(change.Order) == 0 {
		return next, nil
	}
	ordered, err := applyOrder(next, change.Order)
	if err != nil {
		return nil, err
	}
	if len(change.Add) == 0 && len(change.Remove) == 0 && sameOrder(parent, ordered) {
		return nil, invalid("change")
	}
	return ordered, nil
}

// applyOrder returns items in the given order, which must name every item
// exactly once.
func applyOrder(items []SeedItem, order []ItemKey) ([]SeedItem, error) {
	if len(order) != len(items) {
		return nil, invalid("item order")
	}
	byKey := make(map[ItemKey]SeedItem, len(items))
	for _, item := range items {
		byKey[item.Key()] = item
	}
	used := make(map[ItemKey]bool, len(order))
	ordered := make([]SeedItem, 0, len(items))
	for _, key := range order {
		key.Name = strings.TrimSpace(key.Name)
		item, found := byKey[key]
		if !found || used[key] {
			return nil, invalid("item order")
		}
		used[key] = true
		ordered = append(ordered, item)
	}
	return ordered, nil
}

func sameOrder(a, b []SeedItem) bool {
	return slices.EqualFunc(a, b, func(x, y SeedItem) bool { return x.Key() == y.Key() })
}

// reordered reports whether after lists the items it kept from before in a
// different relative order, or puts an added item ahead of a kept one.
func reordered(before, after []SeedItem) bool {
	inBefore := make(map[ItemKey]bool, len(before))
	for _, item := range before {
		inBefore[item.Key()] = true
	}
	inAfter := make(map[ItemKey]bool, len(after))
	for _, item := range after {
		inAfter[item.Key()] = true
	}
	expected := make([]ItemKey, 0, len(after))
	for _, item := range before {
		if inAfter[item.Key()] {
			expected = append(expected, item.Key())
		}
	}
	for _, item := range after {
		if !inBefore[item.Key()] {
			expected = append(expected, item.Key())
		}
	}
	for index, item := range after {
		if index >= len(expected) || item.Key() != expected[index] {
			return true
		}
	}
	return false
}
```

`Diff` gains one field, and `DiffItems` sets it just before `return diff`:

```go
type Diff struct {
	Added   []ItemRef `json:"added"`
	Removed []ItemRef `json:"removed"`
	Changed []ItemRef `json:"changed"`
	// Reordered: the items kept from the parent changed their relative order,
	// or an added item went ahead of a kept one. Omitted when false, so saves
	// that only add or remove keep 86bcm901w's audit shape.
	Reordered bool `json:"reordered,omitempty"`
}
// in DiffItems, after the sort loop:
	diff.Reordered = reordered(before, after)
	return diff
```

`PackChange` gains `Order`, and its `Validate` accepts an order-only change:

```go
type PackChange struct {
	PackID            string
	ParentVersion     string // must be the pack's latest version id
	Version           string // generated version id of the new version
	AddLibraryItemIDs []string
	Remove            []ItemKey
	Order             []ItemKey // optional: every resulting item once, in its new order
}

func (spec PackChange) Validate() error {
	if !validTrimmed(spec.ParentVersion, 1, maxVersionRunes) {
		return invalid("parent version")
	}
	if !validTrimmed(spec.Version, 1, maxVersionRunes) {
		return invalid("pack version")
	}
	if len(spec.AddLibraryItemIDs) == 0 && len(spec.Remove) == 0 && len(spec.Order) == 0 {
		return invalid("change")
	}
	if len(spec.Remove) > MaxItems {
		return invalid("items to remove")
	}
	if len(spec.Order) > MaxItems {
		return invalid("item order")
	}
	return validLibraryIDs(spec.AddLibraryItemIDs, 0)
}
```

The service takes one struct instead of two positional slices. The old signature has 7 callers, and all are updated in B3:

```go
// VersionChange is one save's edit to a built pack's latest version.
type VersionChange struct {
	AddLibraryItemIDs []string  // library_items row ids to add, in this order
	Remove            []ItemKey // items to remove
	Order             []ItemKey // optional: every resulting item once, in its new order
}

// SaveVersion saves the pack's next version from its latest one.
func (s *BuilderService) SaveVersion(ctx context.Context, actor store.Principal, packID, parentVersion string, change VersionChange) (BuiltVersion, error) {
	return s.retry(func(version string) (BuiltVersion, error) {
		return s.store.SavePackVersion(ctx, actor, PackChange{PackID: packID, ParentVersion: parentVersion, Version: version,
			AddLibraryItemIDs: change.AddLibraryItemIDs, Remove: change.Remove, Order: change.Order})
	})
}
```

### D3. Store

`internal/store/postgres/pack_versions.go`:

```go
// insertVersionItems inserts one immutable version's items. An ordered
// version (the pack builder's) stores positions 1..n in the given order;
// any other keeps position 0 and lists by kind, then name. Database and
// encoding errors are already mapped through orgError.
func (database *Store) insertVersionItems(ctx context.Context, tx pgx.Tx, versionID string, items []pack.SeedItem, ordered bool) error {
	for index, item := range items {
		filesJSON, err := json.Marshal(append([]pack.SupportFile{}, item.Files...))
		if err != nil {
			return orgError(err)
		}
		itemID, err := newUUID(database.random)
		if err != nil {
			return err
		}
		position := 0
		if ordered {
			position = index + 1
		}
		if _, err := tx.Exec(ctx,
			`INSERT INTO pack_version_items(id,pack_version_id,kind,name,version,description,body,files,position)
			 VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
			itemID, versionID,
			string(item.Kind),
			strings.TrimSpace(item.Name),
			strings.TrimSpace(item.Version),
			item.Description,
			item.Body,
			filesJSON,
			position,
		); err != nil {
			return orgError(err)
		}
	}
	return nil
}
```

- `CreateVersion` (`:66`) calls it with `false`. `insertBuiltVersion` (`pack_builder.go:287`) calls it with `true`.
- `EnsureSeedBase` is unchanged (the column default gives 0).
- `loadVersionItems` (`:303`) becomes `ORDER BY i.position,i.kind,i.name`.

`internal/store/postgres/pack_builder.go`, in `SavePackVersion`:

```go
	next, err := pack.ApplyChange(parentItems, pack.Change{Add: add, Remove: spec.Remove, Order: spec.Order})
	// … unchanged Validate and insertBuiltVersion …
	built.Diff = pack.DiffItems(parentItems, next)
	before := map[string]any{"version": parent.Version.Version, "number": parent.Number, "itemCount": len(parentItems)}
	after := auditAfter(built)
	if built.Diff.Reordered {
		before["order"] = itemOrder(parentItems)
		after.Order = itemOrder(next)
	}
	if err := database.appendAudit(ctx, tx, actor, "pack.version.create", packID, before, after); err != nil {
		return pack.BuiltVersion{}, orgError(err)
	}
```

Add `Order []string `json:"order,omitempty"`` as the last field of `packAuditRecord`, plus:

```go
// itemOrder lists items as "kind/name" in their order, for the audit record.
func itemOrder(items []pack.SeedItem) []string {
	order := make([]string, 0, len(items))
	for _, item := range items {
		key := item.Key()
		order = append(order, string(key.Kind)+"/"+key.Name)
	}
	return order
}
```

- `CreatePack` is unchanged apart from the positions `insertBuiltVersion` now writes: version 1 lists its items in the order given (API `libraryItemIds`; console: ticks in page order, which is kind then name).
- The audit for a create never carries `order`, because `DiffItems(nil, items)` is never `reordered`.

### D4. JSON API and OpenAPI (`contracts/control-plane.openapi.yaml`)

All changes are additive:
- `createPackVersion` `summary`: "Save the pack's next immutable version by adding, removing or reordering items".
- `PackCreate.libraryItemIds`: add `description: Version 1 lists the items in this order.`
- `PackVersionChange`:

```yaml
    PackVersionChange:
      type: object
      additionalProperties: false
      required: [parentVersion]
      description: >-
        One save's edit to the pack's latest version: removals apply first, then additions,
        then the order. Send only the fields you use; at least one of addLibraryItemIds,
        removeItems or order must change the pack.
      properties:
        parentVersion: …unchanged…
        addLibraryItemIds: …unchanged…
        removeItems: …unchanged…
        order:
          type: array
          maxItems: 500
          description: >-
            The complete order of the new version's items after removals and additions, first
            item first: every resulting item exactly once. Leave it out to keep the parent's
            order, with added items last. An order that changes nothing is refused (400).
          items: {$ref: "#/components/schemas/PackItemKey"}
```

- `PackVersionDetail.items`: add `description: In the version's item order. Versions saved before story 86bcm901y list items by kind, then name.`
- Regenerate with `make generate` and commit `packages/contracts/controlplane.gen.go` (`PackVersionChange.Order *[]PackItemKey`). There is no new operation, so `roundtrip_test.go` and `handler.go`'s `var _ contracts.ServerInterface` need no stub.

`internal/web/pack_builder.go` `CreatePackVersion` builds a `pack.VersionChange`:

```go
	var change pack.VersionChange
	if body.AddLibraryItemIds != nil {
		change.AddLibraryItemIDs = uuidStrings(*body.AddLibraryItemIds)
	}
	if body.RemoveItems != nil {
		for _, key := range *body.RemoveItems {
			change.Remove = append(change.Remove, pack.ItemKey{Kind: pack.Kind(key.Kind), Name: key.Name})
		}
	}
	if body.Order != nil {
		for _, key := range *body.Order {
			change.Order = append(change.Order, pack.ItemKey{Kind: pack.Kind(key.Kind), Name: key.Name})
		}
	}
	built, err := handler.packBuilder.SaveVersion(r.Context(), teamActor(r), packID.String(), body.ParentVersion, change)
	handler.packVersionResult(w, r, http.StatusCreated, built, err)
```

- The `packBuilder` interface (`:30-35`) becomes `SaveVersion(ctx context.Context, actor store.Principal, packID, parentVersion string, change pack.VersionChange) (pack.BuiltVersion, error)`.
- `packBuilderSaveForm` (`:375`) passes `pack.VersionChange{AddLibraryItemIDs: add, Remove: remove}`.
- No `position` field is added to `PackVersionItem`: the array order is the order (YAGNI).

### D5. Console: the item list on the edit view

**New file `internal/web/pack_items.go`:**

```go
package web

import (
	"errors"
	"net/http"
	"net/url"
	"slices"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// Story 86bcm901y: the edit view lists the pack's items in order, each with
// Move up, Move down and Remove. Every click saves the pack's next version
// through the pack builder, like the ticks form, and leaves the shown
// version unchanged.

// packItemRow is one item of the edited version in the console's item list.
type packItemRow struct {
	ID, Key, Name, KindLabel, Version string
	First, Last, Only, InLibrary      bool
}

func packItemRows(items []pack.Item, inLibrary map[pack.ItemKey]bool) []packItemRow {
	rows := make([]packItemRow, 0, len(items))
	for index, item := range items {
		key := pack.ItemKey{Kind: item.Kind, Name: strings.TrimSpace(item.Name)}
		rows = append(rows, packItemRow{
			ID: item.ID, Key: string(key.Kind) + "/" + key.Name, Name: item.Name, KindLabel: item.Kind.Label(), Version: item.Version,
			First: index == 0, Last: index == len(items)-1, Only: len(items) == 1, InLibrary: inLibrary[key],
		})
	}
	return rows
}

// packItemOperations are the item list's buttons, by form field name.
var packItemOperations = []string{"remove", "move_up", "move_down"}

// packItemOperation reads the one button the form carries: its operation and
// the item id it names. No button, two buttons or a repeated one is invalid.
func packItemOperation(form url.Values) (string, string, bool) {
	operation, itemID := "", ""
	for _, name := range packItemOperations {
		values, present := form[name]
		if !present {
			continue
		}
		if operation != "" || len(values) != 1 || values[0] == "" {
			return "", "", false
		}
		operation, itemID = name, values[0]
	}
	return operation, itemID, operation != ""
}

const staleItemListAlert = "The item list no longer matches this version. Reload the page."

// itemOperationChange turns one button into a change against the version's
// items, or returns the alert to show when the button can't apply.
func itemOperationChange(items []pack.Item, operation, itemID string) (pack.VersionChange, string) {
	index := slices.IndexFunc(items, func(item pack.Item) bool { return item.ID == itemID })
	if index < 0 {
		return pack.VersionChange{}, staleItemListAlert
	}
	keys := make([]pack.ItemKey, 0, len(items))
	for _, item := range items {
		keys = append(keys, pack.ItemKey{Kind: item.Kind, Name: strings.TrimSpace(item.Name)})
	}
	switch operation {
	case "remove":
		if len(items) == 1 {
			return pack.VersionChange{}, "A pack needs at least one item: add another item before removing this one."
		}
		return pack.VersionChange{Remove: []pack.ItemKey{keys[index]}}, ""
	case "move_up":
		if index == 0 {
			return pack.VersionChange{}, "That item is already first."
		}
		keys[index-1], keys[index] = keys[index], keys[index-1]
	case "move_down":
		if index == len(items)-1 {
			return pack.VersionChange{}, "That item is already last."
		}
		keys[index], keys[index+1] = keys[index+1], keys[index]
	default:
		return pack.VersionChange{}, staleItemListAlert
	}
	return pack.VersionChange{Order: keys}, ""
}

// packItemsForm applies one item-list button to the edited pack and saves
// the result as its next version.
func (handler *Handler) packItemsForm(w http.ResponseWriter, r *http.Request) {
	if handler.packBuilder == nil || handler.libraryCatalog == nil {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "PACK_BUILDER_UNAVAILABLE", "The pack builder is unavailable")
		return
	}
	session, form, ok := handler.adminForm(w, r)
	if !ok {
		return
	}
	operation, itemID, ok := packItemOperation(form)
	if !ok || len(form["parent_version"]) != 1 {
		handler.writeProblem(w, r, http.StatusBadRequest, "INVALID_REQUEST", "The request is invalid")
		return
	}
	packID := r.PathValue("packId")
	current, err := handler.packBuilder.Pack(r.Context(), session.Principal, packID)
	if err != nil {
		handler.writePackBuilderError(w, r, err)
		return
	}
	// Only a hint for the message: the store's check under the pack's row
	// lock is the one that counts.
	parent := form.Get("parent_version")
	if parent != current.Version.Version {
		handler.renderLibrary(w, r, http.StatusConflict, libraryState{pack: &current, alert: newerVersionAlert(current.Number)})
		return
	}
	change, alert := itemOperationChange(current.Version.Items, operation, itemID)
	if alert != "" {
		handler.renderLibrary(w, r, http.StatusBadRequest, libraryState{pack: &current, alert: alert})
		return
	}
	if _, err := handler.packBuilder.SaveVersion(r.Context(), session.Principal, packID, parent, change); err != nil {
		if errors.Is(err, pack.ErrStaleParent) {
			if latest, readErr := handler.packBuilder.Pack(r.Context(), session.Principal, packID); readErr == nil {
				handler.renderLibrary(w, r, http.StatusConflict, libraryState{pack: &latest, alert: newerVersionAlert(latest.Number)})
				return
			}
		}
		if status, message, ok := packFormAlert(err); ok {
			handler.renderLibrary(w, r, status, libraryState{pack: &current, alert: message})
			return
		}
		handler.writePackBuilderError(w, r, err)
		return
	}
	// The pack id comes from the server, so this is not an open redirect (GO-REDIRECT-001).
	w.Header().Set("Cache-Control", "no-store")
	http.Redirect(w, r, "/admin/library/packs/"+current.PackID, http.StatusSeeOther)
}
```

**Route** (`internal/web/handler.go`, right after the `…/versions` line at `:285`):

```go
	routes.Handle("POST /admin/library/packs/{packId}/items", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.packItemsForm)), false))
```

**`internal/web/pack_builder.go`:** `libraryBuilder` gains `PackID string` and `PackItems []packItemRow`. In `newLibraryBuilder`'s `if built := state.pack; built != nil {…}` block, after `inLibrary` is filled, add `builder.PackID = built.PackID` and `builder.PackItems = packItemRows(built.Version.Items, inLibrary)`.

**Template** (`internal/web/library.go`):

1. Replace the `OtherItems` line with:

   `{{if .OtherItems}}<p class="muted">{{.OtherItems}} item(s) in this pack are not in the library: they stay unless you remove them from the list below.</p>{{end}}`

2. Insert this block **after** the `</form>` that closes `#pack-builder` and **before** `{{if .Packs}}`. Keep it after that form, so the first `parent_version` on the page stays the ticks form's, which 901w's `builderParentPattern` reads.

```html
    {{if .Editing}}
    <form id="pack-items-form" method="post" action="/admin/library/packs/{{.PackID}}/items">
      <input type="hidden" name="csrfToken" value="{{.CSRF}}">
      <input type="hidden" name="parent_version" value="{{.Version}}">
    </form>
    <h3 id="pack-items-title">Items in version {{.Number}}, in order</h3>
    <p class="muted">Move an item up or down, or remove it: each click saves version {{.NextNumber}} and leaves version {{.Number}} unchanged.</p>
    <ol id="pack-items" aria-labelledby="pack-items-title">{{range .PackItems}}
      <li class="pack-item" data-key="{{.Key}}"><span class="pack-item-name">{{.Name}}</span> <span class="chip">{{.KindLabel}}</span> <span class="muted">{{.Version}}{{if not .InLibrary}} · not in the library{{end}}</span> <span class="pack-item-actions"><button type="submit" form="pack-items-form" name="move_up" value="{{.ID}}" aria-label="Move {{.Name}} ({{.KindLabel}}) up"{{if .First}} disabled{{end}}>Move up</button> <button type="submit" form="pack-items-form" name="move_down" value="{{.ID}}" aria-label="Move {{.Name}} ({{.KindLabel}}) down"{{if .Last}} disabled{{end}}>Move down</button> <button type="submit" form="pack-items-form" name="remove" value="{{.ID}}" aria-label="Remove {{.Name}} ({{.KindLabel}})"{{if .Only}} disabled{{end}}>Remove</button></span></li>{{end}}
    </ol>
    {{end}}
```

3. Append to `libraryCSS`:

   `#pack-items{margin:.5rem 0 1rem;padding-left:1.75rem}.pack-item{margin:.4rem 0}.pack-item-name{font-weight:700}.pack-item-actions{margin-left:.5rem}.pack-item-actions button{margin-right:.25rem}.pack-item-actions button[disabled]{opacity:.45;cursor:not-allowed}`

- Keep every `<li class="pack-item" …>` row on one line, exactly as above: the tests' regexes read one row per line.
- Keep `<tr class="item">` rows untouched: the regexes at `library_test.go:84-85` read those.
- The 901w ticks form keeps working unchanged. Unticking a library row still removes it.

### D6. Auth, tenant and input boundaries

| Boundary | Enforced by |
| --- | --- |
| Signed in | `requireSession` (POST → 401 `AUTH_REQUIRED`) |
| Admin | Route `requireAdmin` (403 `ADMIN_REQUIRED`), then `beginOrg(…, true)` inside `SavePackVersion` (403 `FORBIDDEN` if demoted mid-request) |
| CSRF | Item form: `csrfToken` field = cookie (`adminForm`). JSON: `X-CSRF-Token` = cookie (`packGuard`). Both 403 `CSRF_REJECTED` |
| Tenant | `Pack()` and `SavePackVersion` are keyed by `actor.TenantID`, so another tenant's pack is 404 `NOT_FOUND`. Item ids are matched only against the current version's own items, so an id from another version or tenant is "not in this version" (400 alert). |
| Body | Item form: 4 KiB (`adminForm`). JSON: 64 KiB (`packGuard`), unknown fields refused, `order` ≤ 500 (`PackChange.Validate`) |
| Output | `html/template` only (names and keys escaped). Redirects go only to the server-made pack id. No item body or file is written to the audit record. |
| SQL | Parameterized only |

### D7. Audit record (reuses `appendAudit` and `pack.version.create`)

| Save | `before_value` | `after_value` |
| --- | --- | --- |
| Remove and/or add, order kept | `{"itemCount","number","version"}` (unchanged from 901w) | 901w's keys exactly, with `diff.removed`/`diff.added`, and **no** `reordered` or `order` key |
| Reorder (alone or with remove/add) | the same keys plus `"order":["kind/name",…]` (the parent's order) | 901w's keys plus `"order":[…]` (the new order), with `diff.reordered: true` |

One action for every save keeps 902d's future history reader simple. A failed audit insert still rolls the whole save back (901w's AC3 subtest `a_failed_audit_write_saves_nothing` covers the shared path).

### D8. Immutability

Unchanged layers: no code path updates or deletes versions or items; `ApplyChange` copies; migration 23's triggers. Positions are written only by `INSERT`. Migration 24 adds no `UPDATE`.

AC1 and AC3 each assert that the parent version keeps its items and order. The store test asserts that the triggers still refuse `UPDATE … SET position` (42501).

### D9. Sync and the lockfile (AC2; Q1-A, Q3-A)

- **Server:**
  - A new version reaches engineers only when an admin assigns it (unchanged, 901w).
  - `ResolveForProject` → `loadVersionItems` → `bundle.Resolve` builds one file per item body and per supporting file, sorted by path. The lockfile digest is SHA-256 over that manifest, which includes `packVersion`.
  - So after a removal is assigned, the lockfile lacks exactly that item's paths, every other path keeps its SHA-256, and the digest changes. Content for the old digest answers 409, so the desktop must refresh rather than mix revisions.
  - After a reorder-only version is assigned, the paths and hashes are identical and only `packVersion` and the digest change.
- **Client (existing, Q1-A):**
  - The next Sync computes `Remove` = paths recorded by the tool's last successful Sync of the same selection that the new bundle lacks (`application/sync.go:243-265`).
  - It deletes each one only if its SHA-256 still matches the record. A file the engineer edited makes that tool's update fail with `write_failed` ("Native files were not changed for this tool"), and the file stays on disk: the "flagged" case (`toolconnector/nativewrite/write.go:286-300`).
  - A reorder-only assignment changes the digest, so a Sync re-fetches and writes byte-identical files.

### D10. OpenAPI and the client

- **The spec changes additively:** one optional request property, plus descriptions.
- **Client regeneration: not required.** The client builds from its own snapshot, which is already behind (it has no `/v1/packs`). The desktop never calls these admin endpoints, and the client's `contract_kinds_test.go` count is unaffected.
- No cross-repo Go imports (`scripts/verify-workspace.sh`).

### D11. Room for the next stories

- **9026 (preview + diff, Yan):** `ApplyChange` with `Order` and `DiffItems` (now with `reordered`) are pure. A read-only preview can call them with the same `pack.Change`.
- **902d (many packs, history with authors and diffs, Yan):** each save's audit row carries the diff, plus the orders when it reordered.
- **902a (quick start, Justin):** `BuilderService.CreatePack` is unchanged. Version 1 lists items in the ids' order, so a starter set can ship in a chosen order.

## Tasks (builder, test-first)

Common variables (set once per shell; never print the DB URL):

```bash
WT=~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder
BASE=6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f   # re-check in B0; use the newer SHA if GitHub main moved
SCR=<scratchpad>/86bcm901y-builder                # mkdir "$SCR" (no -p): small files only
C=$HOME/.cache/86bcm901y-builder                  # mkdir "$C": TMPDIR, Chrome profile, binaries, detached copies
EVID=~/.hermes/plans/leorna/evidence/86bcm901y
TOOLS=$HOME/.local/leorna-toolchain
export PATH="$TOOLS/go/bin:$TOOLS/bin:/usr/local/bin:/usr/bin:/bin" GOTOOLCHAIN=local
export TMPDIR="$C/tmp" GOTMPDIR="$C/tmp"
export GOLANGCI_LINT="$TOOLS/bin/golangci-lint" GOVULNCHECK="$TOOLS/bin/govulncheck" GITLEAKS=/usr/local/bin/gitleaks
export LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks
PGPW=$(/usr/bin/docker exec leorna-test-pg printenv POSTGRES_PASSWORD); [ -n "$PGPW" ] || { echo "empty leorna-test-pg password"; exit 1; }
PGPORT=$(/usr/bin/docker port leorna-test-pg 5432 | head -1 | sed 's/.*://')   # 55432 here; never hard-code 5432
export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:${PGPORT}/leorna_86bcm901y_test?sslmode=disable"
```

Save this as `$EVID/env.sh.txt` (the password stays a command, never a literal).

**Databases (all in `leorna-test-pg`, created with `docker exec leorna-test-pg psql -U leorna -d leorna_test -c 'CREATE DATABASE <name>'`, dropped with `DROP DATABASE <name> WITH (FORCE)` when the role ends):**
- builder: `leorna_86bcm901y_test`; base baseline: `leorna_86bcm901y_base_test`; console demo: `leorna_86bcm901y_demo_test`;
- later roles: `leorna_86bcm901y_<role>_test` and `leorna_86bcm901y_<role>_base_test`.

Never touch another story's database, worktree (`.claude/worktrees/86bcm901{a,b,j,w}-*`, and any `86bcm902a-*` or `86bcm901r-*` that appears), branch or evidence folder.

### B0. Worktree and environment (stop conditions in bold)

1. In the main checkout:
   - `git -C ~/Leorna/leorna-control-plane status --porcelain --untracked-files=no` must be empty. **If not, stop.**
   - Fetch GitHub `main`: `git -C ~/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main` (URL written out).
   - `git -C ~/Leorna/leorna-control-plane merge --ff-only origin/main`. **If it refuses, stop.**
   - Record `git rev-parse main origin/main` (equal).
2. If `origin/main` ≠ `6c1709e`:
   - Run `git diff --name-only 6c1709e origin/main`.
   - If it touches any file this plan edits other than `delivery/stories.json` or `internal/library/**`, **stop and report the list**.
   - Otherwise set `BASE` to the new SHA and record it in `$EVID/base.txt`. Migration 24 must still be free: `ls internal/store/postgres/migrations | tail -2`. If a sibling took 24, use the next free number and say so.
3. Create the worktree: `git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm901y-remove-reorder "$WT" "$BASE"`. Then `git -C "$WT" status --porcelain` must be empty, and `git -C "$WT" log -1 --format='%H %an <%ae>'` equals `$BASE`.
4. Folders: `mkdir "$SCR" "$C" "$C/tmp"`; `mkdir -p "$EVID"`. Create the builder DB.
5. Tools: echo `go version`, `"$GOLANGCI_LINT" --version`, `"$GOVULNCHECK" -version`, `gitleaks version` and `docker ps --format '{{.Names}} {{.Ports}}' | grep leorna-test-pg` into `$EVID/tools.txt`. They must show go1.27.3, 2.14.0, v1.7.0, 8.30.1 and port 55432. **Stop if any differs.**
6. Run `make -n -s lint audit secrets` in `$WT` and append it to `tools.txt`. It shows the bound absolute binaries.

### B0.5. Base baseline (detached copy, own DB)

- `git -C "$WT" worktree add --detach "$C/base-tree" "$BASE"`.
- With `LEORNA_TEST_DATABASE_URL` pointing at `leorna_86bcm901y_base_test`, run `make check` and `bash ./scripts/test-module-add.sh` there. Record both `EXIT=` lines in `$EVID/baseline-<base7>.txt`.
- Expected: both exit 0. A failure there is a baseline fact; compare by test identity later.
- Then `git -C "$WT" worktree remove --force "$C/base-tree"`.

### E0. Before-state capture (base binary, before any code change)

Follow "Evidence capture" below with `-mode base` on a binary built from a detached copy at `BASE`. Write `$EVID/before-edit-view-<base7>.png`: the edit view at base, with ticks only and no item list. Look at it.

### B1. Domain order (`internal/pack/builder_order_test.go`, new; `internal/pack/builder.go`)

1. **RED.** Write these tests, then run `go test -count=1 -run 'TestApplyChange(Orders|RejectsBadOrders)' ./internal/pack`. Expected failure: build failure `unknown field Order in struct literal of type Change`.
   - `TestApplyChangeOrdersTheResult` (table):
     - order only, `[c b a]` from `[a b c]` → `[c b a]`;
     - remove b + order `[c a]` → `[c a]`;
     - add d + order `[d a b c]` → `[d a b c]`;
     - names with surrounding spaces in `Order` are trimmed;
     - the parent slice is deep-equal to its copy afterwards (use `deepCopyItems` from `builder_test.go`).
   - `TestApplyChangeRejectsBadOrders`, each `errors.Is(err, org.ErrInvalid)` and a nil result:
     - order missing an item;
     - an extra unknown item;
     - one item twice;
     - naming a removed item;
     - an invalid kind;
     - an empty name;
     - an order-only change equal to the parent's order (the "nothing changed" case);
     - `Change{}`.
2. **GREEN:** the D2 `Change`, `ApplyChange`, `applyOrder` and `sameOrder`. Rerun the same command, then `go test -count=1 ./internal/pack`. The old `TestApplyChange*` must stay green.
3. Commit `feat(86bcm901y): order a pack version's items in ApplyChange` (explicit files).

### B2. Reorder in the diff

1. **RED:** `TestDiffItemsMarksReorders` in `builder_order_test.go`, which fails on `diff.Reordered undefined`. Cases:
   - swap two kept items → `true`;
   - remove only → `false`;
   - add appended → `false`;
   - add placed first → `true`;
   - create (`nil` before) → `false`;
   - JSON of a reorder contains `"reordered":true`, and JSON of a non-reorder has no `reordered` key.
2. **GREEN:** the D2 `Diff.Reordered` and `reordered`. `TestDiffItemsEncodesEmptyListsAndOmitsPreviousVersionWhenAdded` must stay green unchanged.
3. Commit `feat(86bcm901y): mark reorders in the pack diff`.

### B3. `PackChange.Order`, `VersionChange` and the new `SaveVersion` signature

1. **RED:** extend `TestPackChangeValidate` (`builder_test.go:268`) with:
   - order-only valid;
   - `Order` of 501 → invalid;
   - all three empty → invalid.

   Add `TestBuilderServicePassesTheOrderThrough` in `builder_order_test.go`. It calls `SaveVersion(..., VersionChange{Order: …})` and checks the fake store got `PackChange.Order`. Expected failure: build failure (`VersionChange` undefined).
2. **GREEN:** the D2 `PackChange`, `Validate`, `VersionChange` and `SaveVersion`.
3. Update the 7 callers: `internal/pack/builder_test.go:411,433,449,474`, `internal/web/pack_builder_test.go:702`, and `internal/web/pack_builder.go:203,375`. Each becomes `pack.VersionChange{AddLibraryItemIDs: <add>, Remove: <remove>}` (in-package: `VersionChange{…}`). Then update the `packBuilder` interface (D4).
4. Run `go build ./... && go vet ./internal/... && go test -count=1 ./internal/pack`.
5. Commit `feat(86bcm901y): carry an item order through the pack builder service`.

### B4. Migration 24 and stored positions (`internal/store/postgres/pack_items_test.go`, new)

1. **RED:** `TestPackItemOrderStoreWithPostgres`, using the same setup as `TestPackBuilderStoreWithPostgres` (`pack_builder_test.go:25-64`: `testPool`, `resetDatabase`, `ApplyMigrations`, a repository and library rows). Subtests:
   - `built_versions_store_positions_in_the_given_order`: `CreatePack` with ids `[D, A, B]` → `SELECT kind||'/'||name, position FROM pack_version_items WHERE pack_version_id=$1 ORDER BY position` gives positions 1, 2, 3 in that order, and `GetPack` lists D, A, B.
   - `a_save_keeps_the_parent_order_and_appends_added_items`: save add C → positions 1–4 = D, A, B, C.
   - `a_save_with_an_order_stores_that_order_and_leaves_the_parent_unchanged`: order `[C, B, A, D]` → the new version lists that order, and the parent (`GetByVersion`) still lists D, A, B, C.
   - `older_versions_keep_listing_by_kind_then_name`: `CreateVersion` with items given as `[skill/z, agent/b, skill/a]` → all positions 0, and `GetByVersion` lists agent/b, skill/a, skill/z. The seed base (`EnsureSeedBase`) also has positions 0.
   - `a_built_version_from_before_positions_lists_by_kind_then_name_and_its_next_save_numbers_them`: insert a built version by raw SQL (a `pack_lineages` row, a `pack_versions` row with `pack_id`/`pack_number=1`, and items inserted without `position`, so 0). `GetPack` then lists by kind, then name. `SavePackVersion` with a remove then gives positions 1…n in that order.
   - `positions_are_unique_and_never_negative`: inserting a second item with an existing position > 0 into a version → 23505 (`pack_version_items_position`); position −1 → 23514.
   - `positions_cannot_be_edited`: `UPDATE pack_version_items SET position=position+1 WHERE …` → SQLSTATE 42501 (migration 23's trigger).
   - `a_reorder_is_audited_with_both_orders_and_a_remove_is_not`: after an order save, the newest `pack.version.create` record's before has `order` = the parent's `kind/name` list, and its after has `order` plus `diff.reordered: true`. After a remove-only save, neither JSON has an `order` or `reordered` key.

   Run `go test -count=1 -v -run '^TestPackItemOrderStoreWithPostgres$' ./internal/store/postgres` with the env. Expected failure: SQL error `column "position" does not exist` (SQLSTATE 42703) in the first subtest.
2. **GREEN:** the D1 migration files and the D3 store changes (`insertVersionItems(…, ordered)`, the two callers, `loadVersionItems` `ORDER BY`, `SavePackVersion` Order and audit, `packAuditRecord.Order`, `itemOrder`). Rerun, then `go test -count=1 -run 'TestMigrationRoundTrip|TestPackBuilderStoreWithPostgres|TestPackVersion' ./internal/store/postgres`.
3. Commit `feat(86bcm901y): store item positions in built pack versions` (migration, store, store test).

### B5. OpenAPI and generated code

1. Save `git diff "$BASE" -- contracts/control-plane.openapi.yaml` before and after (`$EVID/contract-diff-<sha7>.txt`). Edit the spec as in D4, then `make generate`.
2. `bash ./scripts/check-generated-contracts.sh` exits 0. `go test -count=1 ./packages/contracts ./internal/web -run 'TestContract|RoundTrip'` passes (the inline kind-enum count is still 2).
3. Commit `feat(86bcm901y): add an item order to the pack version contract`.

### B6. AC tests first (`internal/web/pack_items_test.go`, new; HTTP only)

Write all four AC tests (spec in "AC tests" below) before any web code. The file uses only what exists on base: the HTTP server, form posts, JSON **strings** for API bodies, HTML regexes, `decodeStrict[contracts.PackVersionDetail]`, `fixture.repository.GetByVersion`, `ListAudit` and the 901w helpers. That way, on the base commit it compiles and fails on the missing item list, route and `order` field (a real `--- FAIL`, not `[build failed]`).

Run each AC command (below). Expected RED on the B5 head:
- AC1: `the_edit_view_lists_the_items_in_order_with_their_buttons` fails with "item list = [], want …";
- AC2: `a_removal_reaches_engineers_only_once_assigned` fails because the item list is missing;
- AC3: the console subtests fail, while `json_api_order_saves_the_next_version_in_the_given_order` may already pass after B4/B5;
- AC4: the console cases fail with 404 or "no alert".

Save the RED logs as `$EVID/red-ac<n>.log`. Commit `test(86bcm901y): acceptance tests for remove and reorder`.

### B7. Console item list (`internal/web/pack_items.go`, new; `pack_items_form_test.go`, new)

1. **RED:** `internal/web/pack_items_form_test.go` with:
   - `TestPackItemOperation`: the form has exactly one of `remove`/`move_up`/`move_down` with one non-empty value; none, two keys, a repeated key or an empty value → `ok=false`.
   - `TestItemOperationChange`: a table like `TestTicksToChange` over items `[a b c]` with ids:
     - remove b → `Remove [b]`;
     - move_up c → `Order [a c b]`;
     - move_down a → `Order [b a c]`;
     - move_up a → alert "already first";
     - move_down c → alert "already last";
     - remove the only item → alert "at least one item";
     - unknown id → the stale alert;
     - an unknown operation → the stale alert.

   Expected failure: build failure (`packItemOperation` undefined).
2. **GREEN:** `pack_items.go` (D5), the route, the `libraryBuilder` fields and fill, the template and the CSS. Run:
   - `go test -count=1 -run 'TestPackItemOperation|TestItemOperationChange|TestTicksToChange' ./internal/web`;
   - then AC1 and AC3 by name;
   - then the 901w suite: `go test -count=1 -run 'TestPackBuilder|TestLibrary' ./internal/web`.
3. Commit `feat(86bcm901y): remove and reorder items from the pack's item list`.

### B8. AC2 and AC3 sync subtests green

Both use `newPackSyncFixture` (spec below). Run AC2 and AC3 by name until green. Every failure here should be in the test's setup, never in product code; if product code must change, say why in the commit message. Commit if any test-helper fix was needed.

### B9. AC4 green

Run AC4 by name until all its cases pass, then commit.

### B10. Mutation checks (`mutation-testing-discipline`)

Run each mutant on the current head:
- with `go test -overlay` (Go source) or a reversible edit in a detached copy (SQL migration);
- running the named killer test;
- recording `KILLED` with the failing assertion line, or `SURVIVED`, in `$EVID/mutations-<sha7>.txt`;
- restoring after each.

A survivor needs a test fix (commit) and a rerun, or a written reason it is equivalent.

| # | Mutation (one place only) | Expected killer |
| --- | --- | --- |
| M1 | `ApplyChange`: `if len(change.Order) == 0 {` → `if true {` (order ignored) | AC3 `json_api_order…`, console move subtests |
| M2 | `applyOrder`: drop the `len(order) != len(items)` check | AC4 `order_missing_an_item`; `TestApplyChangeRejectsBadOrders` |
| M3 | `applyOrder`: drop `|| used[key]` | AC4 `order_naming_an_item_twice` |
| M4 | `ApplyChange`: the nothing-changed condition `sameOrder(parent, ordered)` → `sameOrder(parent, nil)` | AC4 `order_that_changes_nothing` |
| M5 | `insertBuiltVersion`: `insertVersionItems(…, true)` → `false` | AC3 console order, store `built_versions_store_positions…` |
| M6 | `loadVersionItems`: `ORDER BY i.position,i.kind,i.name` → `ORDER BY i.kind,i.name` | AC3, store test |
| M7 | `itemOperationChange` `move_up`: swap with `index+1` instead of `index-1` (guard kept) | AC3 `console_move_up…` |
| M8 | `itemOperationChange` `remove`: drop the `len(items) == 1` alert | AC4 `remove_the_only_item` (it asserts the specific alert text) |
| M9 | `DiffItems`: drop `diff.Reordered = reordered(before, after)` | AC3 `each_reorder_is_audited…` |
| M10 | `SavePackVersion`: drop `after.Order = itemOrder(next)` | AC3 audit subtest |
| M11 | `SavePackVersion`: stale check `!=` → `== "never"` (no stale refusal in the store) | AC4 `outdated_version_json` (API path, no web hint) |
| M12 | route: `handler.requireAdmin(…)` removed from the new `/items` route | AC4 `member` (expects 403 `ADMIN_REQUIRED`, the store would answer `FORBIDDEN`) |
| M13 | `packItemsForm`: `handler.adminForm` → plain `r.ParseForm()` (no CSRF) | AC4 `bad_csrf` |
| M14 | `SavePackVersion`: insert `parentItems` instead of `next` (a removal keeps the item) | AC1 console remove, AC2 lockfile drop |

### B11. Docs and records

See the "Docs and records" section below. Commit `docs(86bcm901y): remove and reorder items`.

### B12. Gates, evidence, hand back

Run the gates (below) on the final head, then capture E1–E4 (below). Hand back `ready-for-review` with:
- the head SHA and `git log --oneline "$BASE"..HEAD`;
- `git diff --stat "$BASE"...HEAD`;
- every gate's `EXIT=`, the AC → test → log → screenshot table, and the mutants;
- `skill_lessons` and `found_else`.

Drop the demo DB, remove `$C` and `$SCR` by literal absolute path, and keep the builder DB until the main session says the story is done (later roles use their own).

## AC tests (`internal/web/pack_items_test.go`, package `web`)

**Shared helpers in this file** (only base-era symbols):

```go
var packItemRowPattern = regexp.MustCompile(`<li class="pack-item" data-key="([^"]+)">.*?<button type="submit" form="pack-items-form" name="remove" value="([0-9a-f-]{36})" aria-label="[^"]*"( disabled)?>`)
var packItemUpPattern = regexp.MustCompile(`name="move_up" value="([0-9a-f-]{36})" aria-label="[^"]*"( disabled)?>`)

type listedItem struct{ Key, ID string }

// itemList reads the edit view's item list in page order (one <li> per line).
func itemList(page string) []listedItem {
	items := []listedItem{}
	for _, match := range packItemRowPattern.FindAllStringSubmatch(page, -1) {
		items = append(items, listedItem{Key: html.UnescapeString(match[1]), ID: match[2]})
	}
	return items
}
```

More helpers:
- `listedKeys(items) []string`, `findListed(t, items, key) listedItem` (fatal if absent);
- `orderedKeys(items []contracts.PackVersionItem) []string`: `kind/name@version` in response order, **not sorted**;
- `itemKeysInOrder(items []pack.Item) []string`;
- `createPackJSON(t, f, client, name string, ids ...string) contracts.PackVersionDetail`: `POST /v1/packs` with a JSON string, 201, `decodeStrict`;
- `getPackJSON(t, f, client, id)`;
- `itemButton(t, f, client, packID, parentVersion, op, itemID string, csrf string) *http.Response`: `packForm` to `…/items` with `csrfToken`, `parent_version` and `op=itemID`.

**`packSyncFixture`** (for AC2 and AC3), built on `newPackBuilderFixture`:
- Call `SetPackAssignments`, `SetBundleServer` and `SetClientAuth` with `f.repository`, and set `f.handler.discovery` exactly as `prompt_publish_test.go:28-33`.
- Create team "Sync team", add the admin, and create project "Sync project" (expires in 1 h).
- Mint one desktop bearer with `mintDesktopToken(t, f.repository, f.admin)`, the `mint` closure of `prompt_publish_test.go:78-95` lifted into a helper.
- Insert a script-free multi-file library row F = `builderLibraryItem(pack.KindSkill, "guide-demo", "1.0.0", library.SupportFile{Path: "references/guide.md", Body: "# Guide\n\nFILE-MARKER-guide-demo\n"})`. Don't use C here: its script can't be served until approved.
- Helpers:
  - `assign(t, version)`: `POST /admin/packs/assignments/team` with `team_id` and `version`, expecting 303;
  - `synced(t) contracts.ClientBundle`: `GET /v1/client/projects/{id}/bundle` with the bearer, 200;
  - `content(t, digest, want int) string`;
  - `lockPaths(bundle) map[string]string`: path → sha256.

### AC1 `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`

- **Setup:** `newPackBuilderFixture`; admin client; v1 = `createPackJSON(…, "Remove pack", A, B, D)`, so the order is A, B, D.
- **Subtests:**
  1. `the_edit_view_lists_the_items_in_order_with_their_buttons`:
     - `GET /admin/library/packs/{id}` → `listedKeys` = `[skill/code-review-checklist agent/test-writer mcp_template/github-mcp]`;
     - the heading is "version 1";
     - exactly 3 Remove buttons, none disabled;
     - the first Move up is disabled.
  2. `console_remove_saves_the_next_version_without_the_item`:
     - Remove B (its listed id) with `parent_version` = v1 → 303, `Location` = `/admin/library/packs/{id}`;
     - `getPackJSON`: number 2, `parentVersion` = v1, `orderedKeys` = `[keyA keyD]` (order kept);
     - `GetByVersion(v1)` still lists `[keyA keyB keyD]`;
     - the page heading is "version 2", and its list has no `agent/test-writer`.
  3. `an_item_hidden_by_the_library_filter_can_be_removed`:
     - a new pack (A, D), then `GET …/{id}?kind=skill`: the library table shows no tick box for D's library id (`tickState`), but the item list lists `mcp_template/github-mcp`;
     - Remove it → 303, and the latest version lists only `keyA`.
  4. `json_api_remove_items_saves_the_next_version_without_the_item`:
     - `POST /v1/packs/{id}/versions` `{"parentVersion":…,"removeItems":[{"kind":"skill","name":"code-review-checklist"}]}` → 201, items `[keyD]`;
     - an existing behaviour kept.
  5. `the_removal_is_audited_with_the_removed_item`:
     - `ListAudit(target=packID)`; the record whose after `number` is 2: action `pack.version.create`, actor = admin;
     - `jsonKeys(before)` = `[itemCount number version]`;
     - `jsonKeys(after)` = 901w's 7 keys exactly (no `order`);
     - `decodeStrict[packAuditAfter]` succeeds (no `reordered` key); `diff.removed` = `[keyB]`, `added`/`changed` empty;
     - no `BODY-MARKER`/`FILE-MARKER` in the record.
- **Command:** `go test -v -count=1 -run '^TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres$' ./internal/web` (with `LEORNA_TEST_DATABASE_URL`).
- **Old-code check:** on base the edit view has no item list and `/items` is not routed (404). Subtest 1 fails ("item list = [], want …"), and so do 2, 3 and 5. A real `--- FAIL`.
- **Evidence:**
  - log `ac1-<sha7>.log`;
  - real console captures `ac1-remove-before.png` (version 2 of the demo pack, list with `github-mcp`) and **`ac1-remove-after.png`** (version 3, `github-mcp` gone; this is the AC's screenshot in `ac.json`);
  - extra `ac1-remove-audit.png` (Change history row, `diff.removed`).

### AC2 `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`

- **Setup:** `newPackSyncFixture`; v1 = `createPackJSON(…, "Sync pack", A, B, D, F)`.
- **Subtests:**
  1. `the_assigned_version_is_what_engineers_sync`:
     - assign v1; `synced` → status `assigned`, `manifest.packVersion` = v1;
     - `lockPaths` contains `skill/guide-demo` and `skill/guide-demo/references/guide.md`.

     Keep the result as L1.
  2. `a_removal_reaches_engineers_only_once_assigned`:
     - Remove F through the console item list → 303 (version 2);
     - `synced` still has `packVersion` = v1 and digest = L1's.
  3. `the_next_lockfile_drops_exactly_the_removed_items_files`:
     - assign v2; `synced` = L2 → `packVersion` = v2;
     - set(L1 paths) − set(L2 paths) = exactly `{skill/guide-demo, skill/guide-demo/references/guide.md}`;
     - set(L2) ⊂ set(L1), and every L2 path has the same sha256 as in L1;
     - the L2 digest ≠ the L1 digest;
     - the manifest files of L2 are sorted by path.
  4. `the_new_content_has_no_removed_item_and_the_old_digest_is_refused`:
     - `content(L2.digest, 200)`: items' paths = the L2 body paths, none starts with `skill/guide-demo`, and `FILE-MARKER-guide-demo` is absent;
     - `content(L1.digest, 409)`.
- **Command:** `go test -v -count=1 -run '^TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres$' ./internal/web`.
- **Old-code check:** on base, subtest 2's console Remove is 404 (the item list is missing), so the test fails with a real `--- FAIL`.
  - Said plainly: the sync half this test then checks (path-sorted bundle from the assigned version, 409 for a stale digest, the client's removal) **already exists**. The test's value is proving it end to end for a removal.
  - Its sensitivity is shown by M14 (and the auditor may add a mutant that keeps removed items in `loadVersionItems`).
- **Supporting client receipt (not `ac-check`'s test; Q1-A):** run the client's own Sync tests read-only in a clone, never in `~/Leorna/leorna-client` itself:

  ```bash
  git clone -q ~/Leorna/leorna-client "$C/client" && git -C "$C/client" checkout -q --detach f105e27
  (cd "$C/client" && GOFLAGS=-mod=vendor CGO_ENABLED=1 go test -v -count=1 -run '^(TestSyncEndToEndWithLoginMockTLSAndRealWriters)$' ./application && GOFLAGS=-mod=vendor go test -v -count=1 -run '^(TestApplyRemovesOnlyUnchangedManagedFile|TestApplyRestoresRemovedFileWhenLaterInstallFails)$' ./toolconnector/nativewrite)
  ```

  - Use the client's `go` toolchain go1.27.3 from `$TOOLS` and `TMPDIR=$C/tmp` (a real, non-symlinked folder).
  - Log `ac2-client-sync-f105e27.log`, capture `ac2-client-sync-f105e27.png`. If it can't run on this host, record **not run** with the exact error. That doesn't block AC2; say so in the hand-over.
- **Evidence:** log `ac2-<sha7>.log` and **`ac2-sync-lockfile-log.png`** (terminal capture of the AC2 run: command, 4 subtest PASS lines, `EXIT=0`), plus the client receipt above.

### AC3 `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres`

- **Setup:** `newPackSyncFixture`; v1 = `createPackJSON(…, "Order pack", A, B, D)`, so the order is A, B, D.
- **Subtests:**
  1. `console_move_up_saves_the_next_version_in_the_new_order`:
     - Move up D → 303;
     - `getPackJSON`: number 2, parent v1, `orderedKeys` = `[keyA keyD keyB]`;
     - the page heading is "version 2", the list is `[A D B]`, and the first Move up is disabled;
     - `GetByVersion(v1)` is still `[keyA keyB keyD]`.
  2. `console_move_down_saves_the_next_version_in_the_new_order`: Move down A on version 2 → version 3, `[keyD keyA keyB]`.
  3. `json_api_order_saves_the_next_version_in_the_given_order`: `{"parentVersion":v3,"order":[{"kind":"agent","name":"test-writer"},{"kind":"skill","name":"code-review-checklist"},{"kind":"mcp_template","name":"github-mcp"}]}` → 201, response items `[keyB keyA keyD]`, number 4.
  4. `json_api_can_remove_add_and_order_in_one_save`: `{"parentVersion":v4,"removeItems":[{"kind":"mcp_template","name":"github-mcp"}],"addLibraryItemIds":[F],"order":[{"kind":"skill","name":"guide-demo"},{"kind":"agent","name":"test-writer"},{"kind":"skill","name":"code-review-checklist"}]}` → 201, items `[F B A]` in that order, number 5.
  5. `each_reorder_is_audited_with_the_order_before_and_after`:
     - for numbers 2–5, the record is `pack.version.create`, `diff.reordered` is true, and before/after `order` equal the previous and new `kind/name` lists;
     - for 2–4, `diff.added`/`removed`/`changed` are all empty;
     - for 5, `removed` = `[github-mcp]` and `added` = `[guide-demo]`;
     - decode with a strict local struct (901w's keys plus `order`, and `diff` plus `reordered`).
  6. `a_reorder_syncs_the_same_files_as_its_parent`:
     - assign v1 → `synced` = L1; assign v2 (A, D, B) → L2;
     - `lockPaths(L1)` deep-equals `lockPaths(L2)` (same paths, same sha256);
     - `packVersion` is v2, and the L2 digest ≠ the L1 digest;
     - `content(L2.digest, 200)` lists the same item paths as for L1, sorted by path.
- **Command:** `go test -v -count=1 -run '^TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres$' ./internal/web`.
- **Old-code check:** on base, the console Move routes are 404 and the JSON `order` is an unknown field (400 `INVALID_PACK`), so subtests 1–5 fail. A real `--- FAIL`.
- **Evidence:**
  - log `ac3-<sha7>.log`;
  - real console captures `ac3-reorder-before.png` (version 1 list) and **`ac3-reorder-after.png`** (version 2, the moved item one place higher; the AC's screenshot);
  - extra `ac3-reorder-audit.png` (Change history: `"reordered": true`, both orders).

### AC4 (proposed) `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres`

- **Setup:** `newPackBuilderFixture`; clients for the admin, the member, the other tenant's admin and a signed-out user.
  - Pack P: v1 (A, B, D) via JSON; v2 via one console Move up (so v1 is outdated).
  - Pack S: a one-item pack (A).
- **Refusal helper:** a local `refused(t, send, want{status, code, alert})`, the same shape as `pack_builder_test.go:716-736`. It asserts the status, the problem code or the inline alert (`builderAlertPattern`), and `countRows` unchanged (lineages, versions, audits).
- **Cases:**
  1. `a_valid_order_is_accepted_first` (positive control):
     - a JSON save with a valid full order → 201;
     - on base this is 400 (unknown field), which is what makes the API cases below meaningful there.
  2. Console cases:
     - `remove_the_only_item`: on S, Remove A → 400, alert "A pack needs at least one item"; the page shows the Remove button `disabled`.
     - `move_the_first_item_up` → 400, "That item is already first".
     - `move_the_last_item_down` → 400, "That item is already last".
     - `item_not_in_this_version`: an item id from v1 posted with `parent_version` = the latest → 400, "no longer matches this version".
     - `outdated_version_console`: `parent_version` = v1 → 409, "This pack has a newer version (version N)"; the page heading shows the latest.
     - `no_button_or_two_buttons`: neither `remove` nor a move, or both `remove` and `move_up` → 400 `INVALID_REQUEST`.
     - `member`: 403 `ADMIN_REQUIRED`.
     - `bad_csrf`: 403 `CSRF_REJECTED`.
     - `another_company_pack`: the other tenant's admin → 404 `NOT_FOUND`.
     - `signed_out`: 401 `AUTH_REQUIRED`.
  3. API cases, each 400 `INVALID_PACK` unless noted:
     - `order_missing_an_item`;
     - `order_with_an_unknown_item`;
     - `order_naming_an_item_twice`;
     - `order_naming_a_removed_item` (`removeItems` B, and an order that still lists B);
     - `order_that_changes_nothing` (the latest order, nothing else);
     - `order_too_long` (501 entries);
     - `empty_order_and_nothing_else` (`"order":[]`);
     - `outdated_version_json` → 409 `PACK_CHANGED`.
- **Command:** `go test -v -count=1 -run '^TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres$' ./internal/web`.
- **Old-code check:** on base the positive control fails (400) and every console case gets 404 instead of its status and alert. A real `--- FAIL`.
- **Evidence:**
  - log `ac4-<sha7>.log`;
  - **`ac4-refused-log.png`** (terminal capture: command, every case PASS, `EXIT=0`);
  - extra real console capture `ac4-only-item-cannot-be-removed.png` (a one-item pack: the Remove button disabled).

## Evidence capture on this desktop (E0–E4)

**Folder:** `~/.hermes/plans/leorna/evidence/86bcm901y/`. The builder writes at its root; the verifier only in `verifier/`, the auditor only in `auditor/`, a fixer in `fixer<n>/`. Nothing evidence-related goes inside the worktree, because `ac-check.sh` fails on untracked files.

**Demo server (loopback only, the 901j/901w recipe):**
1. Make a detached copy of the head: `git -C "$WT" worktree add --detach "$C/head-tree" HEAD` (at `BASE` for E0).
2. `cd "$C/head-tree" && go build -o "$C/run/control-plane" ./cmd/control-plane`, and record `go version -m "$C/run/control-plane" | grep vcs` (revision = the head, `vcs.modified=false`).
3. Run it with:
   - `LEORNA_MANIFEST_PATH` = a copy of `config/manifest.example.json` with `127.0.0.1:8080` → `127.0.0.1:<free port>`;
   - `LEORNA_DATABASE_URL` = `leorna_86bcm901y_demo_test` on port `$PGPORT`, `sslmode=disable`;
   - `LEORNA_DEV_MODE=1`, `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`, and `LEORNA_SECRET_ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)`;
   - the password read inside the script (as `~/.hermes/plans/leorna/evidence/86bcm901j/handover/serve.sh.txt`), never on a command line.
4. Use a fresh demo DB for each run: drop and create it. The log should show the content library loaded.

**Capture driver:** adapt `~/.hermes/plans/leorna/evidence/86bcm901w/verifier/capture-main.go` into `$EVID/capture-main.go`, and run it as `cmd/zz-capture-901y/main.go` inside `$C/head-tree` (untracked there, never in `$WT`) with `go run ./cmd/zz-capture-901y -base http://127.0.0.1:<port> -out "$EVID" -chrome ~/.cache/chrome-for-testing/chrome-linux64/chrome -profile "$C/chrome-profile" -mode head|base`.
- Environment: `env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, with chromedp flags `headless=new`, `NoSandbox`, `DisableGPU`, `disable-software-rasterizer`, window 1440×1000.
- Keep 901w's `waitFor` (poll `chromedp.Evaluate` every 250 ms up to 30 s, ignoring errors while the 303 navigates) and its `heading(want)`.
- Add:
  - `section(name)` = `chromedp.Screenshot("section.builder", &png, chromedp.ByQuery)` (the builder section: the heading "Editing … · version N" and the item list);
  - `page(name)` = `FullScreenshot`;
  - `click(label)` = `chromedp.Click(fmt.Sprintf("button[aria-label=%q]", label), chromedp.ByQuery)`;
  - `listIs(keys…)` = `Evaluate("Array.from(document.querySelectorAll('#pack-items li')).map(li=>li.dataset.key).join(',')")`, which must equal the expected list before each shot. That makes every capture self-checking, so a wrong page fails the run instead of saving a misleading PNG.
- **Flow, `-mode head`** (shipped items at base library 0.7.0; the page orders ticks by kind, then name):
  1. `/dev/login?next=/admin/library` → tick `code-reviewer`, `github-mcp`, `pr-description`, `code-review-and-quality` and `debugging-and-error-recovery`; name "Platform team pack"; Create pack → wait for "version 1"; `listIs(agent/code-reviewer, mcp_template/github-mcp, prompt/pr-description, skill/code-review-and-quality, skill/debugging-and-error-recovery)`. **`ac3-reorder-before.png`**.
  2. `click("Move debugging-and-error-recovery (Skill) up")` → wait for "version 2"; `listIs(…, skill/debugging-and-error-recovery, skill/code-review-and-quality)`. **`ac3-reorder-after.png`**.
  3. `/admin/audit?target=<packId>` → **`ac3-reorder-audit.png`** (`page`).
  4. Back to `/admin/library/packs/<packId>` → wait for "version 2". **`ac1-remove-before.png`**.
  5. `click("Remove github-mcp (MCP template)")` → wait for "version 3"; `listIs(agent/code-reviewer, prompt/pr-description, skill/debugging-and-error-recovery, skill/code-review-and-quality)`. **`ac1-remove-after.png`**.
  6. `/admin/audit?target=<packId>` → **`ac1-remove-audit.png`**.
  7. `/admin/library` → tick `test-driven-development`, name "Solo pack", create → **`ac4-only-item-cannot-be-removed.png`**, after checking that `button[aria-label="Remove test-driven-development (Skill)"]` has `disabled`.
- **`-mode base` (E0):** step 1 only, without `listIs`; save `section` as `before-edit-view-<base7>.png`.

**Terminal captures (AC2, AC4, the client receipt):**
- Render the real log in a `<pre>` page: `python3 -I -c 'import html,sys; print("<!doctype html><meta charset=utf-8><body style=\"background:#0b1320;color:#e6edf3\"><pre style=\"font:13px monospace;white-space:pre-wrap\">"+html.escape(open(sys.argv[1]).read())+"</pre>")' <log> > "$C/<name>.html"`.
- Screenshot it: `env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=… ~/.cache/chrome-for-testing/chrome-linux64/chrome --headless=new --no-sandbox --disable-gpu --disable-software-rasterizer --hide-scrollbars --user-data-dir="$C/chrome-term" --window-size=1400,<height> --screenshot="$EVID/<name>.png" "file://$C/<name>.html"`.
- Judge success by the "bytes written" line and the PNG magic `89504e47`, not Chrome's exit code (139 after writing is known).
- Each capture shows one head's log, so re-render it whenever that AC's test changes.

**Privacy (every role, before citing a PNG):**
- Look at each image. Read it in bands of ≤1,300 px for tall audit pages (a ~40-line Go `image/png` cropper, as 901w's finisher did).
- Grep its text source for emails, URLs, tokens and passwords.
- No URL bar exists in headless shots. The audit page shows UUIDs from the throwaway demo DB, which is accepted.
- Never capture `/admin` itself.

**Named capture tasks (builder, in B12, on the final head's binary):**
- **E0:** before-state at base (above, before any code change).
- **E1 (AC1):** flow steps 4–6.
- **E2 (AC2):** terminal capture of `ac2-<sha7>.log`, plus the client receipt.
- **E3 (AC3):** flow steps 1–3. Run the flow in order 1→7: step 1's version 1 is the before-state for E3, and step 4's version 2 is the before-state for E1, each captured before its click.
- **E4 (AC4):** terminal capture of `ac4-<sha7>.log`, plus flow step 7.

If a fix later changes the template, the item list or the routes, retake E1, E3 and E4's console shots on the new head. A test-only change needs only the terminal captures re-rendered.

**Mapping (the builder's root files; the verifier and auditor take their own):**

| AC | Test log | `ac.json` screenshot | Extra captures |
| --- | --- | --- | --- |
| AC1 | `ac1-<sha7>.log` | `ac1-remove-after.png` | `ac1-remove-before.png`, `ac1-remove-audit.png` |
| AC2 | `ac2-<sha7>.log` | `ac2-sync-lockfile-log.png` | `ac2-client-sync-f105e27.log` + `.png` (supporting) |
| AC3 | `ac3-<sha7>.log` | `ac3-reorder-after.png` | `ac3-reorder-before.png`, `ac3-reorder-audit.png` |
| AC4 | `ac4-<sha7>.log` | `ac4-refused-log.png` | `ac4-only-item-cannot-be-removed.png` |
| before | — | — | `before-edit-view-<base7>.png` (E0) |

**Runs:**
- **Head runs:** each log starts `HEAD=<sha>` and ends `EXIT=<code>` (the recipe in `ac-verification.md`).
- **Base runs (verifier/auditor):**
  - a detached `git worktree add --detach <scratch>/base-<base7> <base>` with its own `_base_test` DB;
  - copy **only** `internal/web/pack_items_test.go` from head (no other test file: `pack_items_form_test.go` refers to new functions and would turn a real `--- FAIL` into `[build failed]`);
  - one AC at a time, resetting between ACs.

## Gates (builder on the final head; the verifier and auditor rerun them in a detached copy at the same SHA)

| # | Gate | Receipt | Pass rule |
| --- | --- | --- | --- |
| G1 | `make check` (workspace, contracts-check, fmt, vet, race tests, lint, audit, secrets, library-check, build), with `GOLANGCI_LINT`/`GOVULNCHECK`/`GITLEAKS` bound to the checked paths | `gates-<sha7>.txt` | `EXIT=0`. Run it in `$WT` or a detached copy, **never the main checkout** (its `.claude/worktrees/*` would be seen as modules). If `secrets` fails only on another story's branch commit, rerun `gitleaks git --redact --log-opts="$BASE..HEAD"` and report it as found_else, not a regression. |
| G2 | `bash ./scripts/test-module-add.sh` | `module-add-<sha7>.txt` | `EXIT=0` |
| G3 | Postgres tests really ran: `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web > pg-<sha7>.json`, read per test with a copy of `~/.hermes/plans/leorna/evidence/86bcm901w/verifier/pgread.py` | `pg-<sha7>-summary.txt` | `EXIT=0`; no skip whose reason names `LEORNA_TEST_DATABASE_URL`. The only allowed skips are the two ClickHouse subtests of `TestTeamsAPIWithPostgres` (`LEORNA_TEST_CLICKHOUSE_URL`). Every `TestPackItems*`, `TestPackItemOrderStoreWithPostgres` and `TestPackBuilder*` entry passes. |
| G4 | AC1–AC4 by name | `ac<n>-<sha7>.log` | each `EXIT=0`, its own pass line, no SKIP |
| G5 | Story secret scan `gitleaks git --redact --no-banner --log-opts="$BASE..HEAD"` | `gitleaks-story-<sha7>.txt` | `EXIT=0` |
| G6 | Scope: `git diff --name-only "$BASE"...HEAD` | `changed-files-<sha7>.txt` | no `.github/`, no `CLAUDE.md`, no client path; every file is in this plan's list |
| G7 | Contract diff `git diff "$BASE" -- contracts/control-plane.openapi.yaml` | `contract-diff-<sha7>.txt` | additive only: removed lines are only the replaced description/summary lines; no removed property, path or enum |
| G8 | `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` | `stories-<sha7>.txt` | `EXIT=0` |
| G9 | Verifier only, CI parity: `docker build --no-cache --file Containerfile --tag leorna-cp-86bcm901y-verify:<sha7> .` in a detached copy (the `RUN go build` step says DONE, not CACHED), then `docker run --rm --entrypoint /usr/local/bin/gitleaks <tag> version` = `8.30.1`, then `docker rmi <tag>` | `image-<sha7>.txt` | both `EXIT=0` |

- Run `TestSetupWizardWithPostgres` alone and rerun it before calling it a regression: it timed out once under load on this desktop.
- Base baseline: B0.5. There are no admin-console node UI tests in this repo, so that gate is N/A.

## Docs and records

| File | Change | Who |
| --- | --- | --- |
| `internal/pack/README.md` | New section `## Remove and reorder items (86bcm901y)` (see below). In the 901w section, replace the bullet "Item order is not stored… reordering and removing items that didn't come from the library is 86bcm901y." with "Item order and removing any item: see 86bcm901y below." | builder |
| `internal/web/README.md` | In the pack builder paragraph (`:192`), add the edit view's item list, the route `POST /admin/library/packs/{packId}/items` (one of `remove`/`move_up`/`move_down`, `parent_version`, `csrfToken`) and the alerts. | builder |
| `internal/bundle/README.md` | One line under "Bundle resolution": "An admin's item order (86bcm901y) never reaches the bundle: files stay sorted by path, so a reorder-only version syncs the same files and hashes; only `packVersion` and the digest change." | builder |
| `contracts/control-plane.openapi.yaml` + `packages/contracts/controlplane.gen.go` | D4 | builder |
| `delivery/stories.json` | Append as **text** after the last entry (keep every earlier entry byte-identical): `"86bcm901y": {"name": "Remove and reorder items in a pack version", "prs": {"LeornaAI/leorna-control-plane": []}}`. The PR number is added only after a PR exists, on Justin's word. | builder |
| `~/.hermes/plans/leorna/evidence/86bcm901y/EVIDENCE.md` | Head, base, AC table, gates, mutants, captures, privacy check | builder (later roles append their own sections in their folders) |
| `evidence/86bcm901y/plan-approved.md` | `install -m 444` of this plan at go | main session |
| `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` | Dated status lines (go, ready-for-review, hand-over) | main session only |

**`internal/pack/README.md` new section (builder writes it; keep it this short):**

```markdown
## Remove and reorder items (86bcm901y)

The edit view `/admin/library/packs/{packId}` lists the pack's items in order with **Move up**,
**Move down** and **Remove**. Each click saves the next version (ParentVersion set, previous
version unchanged) through `POST /admin/library/packs/{packId}/items`. Remove works for every
item, including ones the library page doesn't show. The JSON API takes an optional `order` in
`POST /v1/packs/{packId}/versions`: every resulting item once, applied after removals and
additions.

- Order is stored as `pack_version_items.position` (migration 24): 1…n for versions saved by the
  pack builder, 0 for everything else, which keeps listing by kind, then name. Readers order by
  position, then kind, then name.
- The audit record stays `pack.version.create`. A save that changes the order adds
  `diff.reordered: true` and `order` (as `kind/name`) to both the before and after values; other
  saves keep 86bcm901w's shape.
- Sync: a removal reaches engineers once the new version is assigned. Its lockfile no longer lists
  the item's files, and the desktop deletes them unless an engineer edited them (that tool's
  update then fails and keeps the file). Order never reaches the bundle, which stays sorted by path.
- Rollback: migration 24's down drops `position`; versions then list by kind, then name.

Verification: `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`,
`TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`,
`TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres` and
`TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres` (`internal/web`, real
PostgreSQL), `TestPackItemOrderStoreWithPostgres`, `TestItemOperationChange`, `TestPackItemOperation`
and the unit tests in `builder_order_test.go`.
```

(The README wraps test names across lines. That is fine there: `ac-check.sh` reads only this plan, where each name sits whole on its AC line.)

## Sibling stories and overlaps

Checked 2026-10-29 09:45 UTC:
- `gh pr list -R LeornaAI/leorna-control-plane --state open` lists only **#98**.
- Worktrees under `.claude/worktrees/`: `86bcm901a-agent-definitions`, `86bcm901b-prompts-collection`, `86bcm901j-mcp-templates`, `86bcm901w-create-pack`. Their stories are merged (#97, #95, #96), except 901j (#98, open).
- Two planners started in parallel with this one at 05:36 EDT (briefs only, no plans yet): **86bcm902a** quick start and **86bcm901r** starter packs.

| Sibling | State | Files it probably shares with 901y | How the finisher resolves it at hand-over |
| --- | --- | --- | --- |
| 86bcm901j MCP templates, PR #98 (head `17f2ccf`) | open, verifying | `delivery/stories.json` only. It also changes `internal/library/content/items/mcp_template/github-mcp/*`, which the capture ticks, but by name only. | If #98 merges first: bring main in, take main's `stories.json` unchanged and append the 901y entry last as text; check earlier entries are unchanged by value. Run `git merge-tree --write-tree --name-only HEAD origin/main` and `git merge-tree origin/main <#98 head>`, first checking `FETCH_HEAD` = `gh pr view 98 --json headRefOid`. |
| 86bcm902a quick start (Justin, planning) | plan not written | Likely `delivery/stories.json`, `internal/web/handler.go` (routes), maybe `internal/pack/builder.go` (it calls `CreatePack`, unchanged here), maybe the OpenAPI spec and `controlplane.gen.go`, maybe a **migration 24** (its brief asks where skip/resume state lives). | Whoever merges second: renumber an unmerged migration to the next free number (never applied anywhere); merge both spec edits by hand and **regenerate** `controlplane.gen.go` (never hand-merge the generated file); keep both route lines; append `stories.json` last. Rerun G1–G4 on the merged tree. |
| 86bcm901r starter packs (Justin, planning) | plan not written | Likely `delivery/stories.json`, `internal/library/content/**`, `library.json`/`content.lock.json`, maybe `internal/pack/seed*`. No pack-builder or console overlap expected. | `stories.json` as above. A seed or library version change only matters if the capture's shipped item names disappear; recheck the names before re-capturing. |
| 901a / 901b / 901w worktrees | merged | none | Leave them untouched. They are not this story's to remove. |

## Follow-ups (not in this story)

- **F1 (client):** a client-side Sync test that removes a whole item (not only support files) and asserts a locally edited file is kept and flagged, in all three tools (Q1-B, as its own small client story if wanted).
- **F2 (client):** the flagged case says only "Native files were not changed for this tool". Name the edited file (relative path) in the Sync result.
- **F3 (product):** every save, including a pure reorder, needs script items re-approved (approvals are per item row). Consider carrying an approval across versions when the script bytes are unchanged (decide with Christian; it's a security choice).
- **F4 (console):** if admins rearrange big packs often, add bulk reordering (Q2-B) or drag and drop (needs a CSP-nonced script).
- **F5 (902d):** show `reordered` and the two orders in the version history view.
- **F6:** if order ever matters to a tool (Q3-B), add `position` to the bundle contract as a new card in both repos.

## Risks

1. **Migration number collision** with 902a/901r (planned in parallel). Mitigation: B0 step 2 checks; the later merger renumbers its unmerged migration and reruns G1–G4.
2. **`stories.json` append conflicts** with #98 and the parallel siblings. Mitigation: append last as text at hand-over; check earlier entries by value.
3. **Shared files with 902a** (`handler.go`, the OpenAPI spec, the generated code, maybe `builder.go`). Mitigation: regenerate, never hand-merge; this plan changes `SaveVersion`'s signature, so a sibling calling it must switch to `VersionChange`. Say this in the PR's Assumptions.
4. **Order change for every reader:** `loadVersionItems` now orders by position first. Legacy rows are all 0, so their order is unchanged. Covered by the store subtests `older_versions_keep_listing_by_kind_then_name` and `a_built_version_from_before_positions…`. The 901w suite must stay green unchanged, apart from the one `SaveVersion` call site.
5. **901w's audit test pins keys:** handled by `omitempty` (D7). If a reviewer prefers always-present order keys, that is a deliberate change to 901w's AC3 test and needs the main session's say.
6. **Version churn:** each Move click makes a version and an audit row. Acceptable for S (the API `order` does bulk); F4 is a follow-up.
7. **A reorder-only assignment** makes the desktop re-fetch and rewrite identical files (the digest changes with the version id). Harmless and documented.
8. **Capture flakiness** after a 303 (901w's "Inspected target navigated or closed"): use `waitFor`, never `WaitVisible` on shared elements, and `listIs` before each shot.
9. **Load on this desktop** (parallel sessions): known flaky `TestSetupWizardWithPostgres`; rerun alone. Postgres on port 55432, never 5432.
10. **Client receipt may not run on WSL** (cgo SQLite, vendor). It is supporting only; record "not run" with the error.

## Assumptions (made openly; easy to change)

- Only packs built in the library get the item list, as 901w's Q2-A decided. Seed versions and forks keep today's Pack Versions flows.
- No confirmation step for Remove. The previous version stays; the admin can re-add the item from the library, or assign the older version again.
- Version 1 lists items in the order given (API ids; console ticks in page order, which is kind then name), so console-created packs look as they do today.
- One audit action (`pack.version.create`) for every save; order details appear only when a save reorders.
- The API `order` is a complete order, not move operations: it's idempotent against the `parentVersion` guard and simple to validate.
- Item ids in the console form are the current version's `pack_version_items.id` values, and an id from any other version is treated as a stale page.
- `newerVersionAlert`'s wording ("Review the ticks and save again") is reused for the item list's 409 rather than adding a second message.

## Other things found (not fixed here)

- **P3 (process):** on this WSL desktop, `127.0.0.1:5432` is a different Postgres container, `leorna-pg` (postgres:16), not the test container `leorna-test-pg` (`127.0.0.1:55432`, `docker ps` 2026-10-29). 901w's plan has `…@127.0.0.1:5432/leorna_86bcm901w_test` in its variables (`86bcm901w-create-pack.md:1087`), and later roles corrected it to 55432. A gate script copying the old line would talk to the wrong server.
- **P3 (product, existing):** every pack builder save gives items new row ids, so scripts need re-approval even for a pure reorder (`internal/pack/README.md:225`). See F3.
- **P3 (client, existing):** a locally edited file of a removed item fails the whole tool's update with a generic message and no file name (`leorna-client application/sync.go:276-283`). See F2.
- **Info:** the client's OpenAPI snapshot is behind the server's (no `/v1/packs`), which is known from 901w (its F3). Nothing to do here.

## Estimate and completion contract

- **Builder:** 3.5–5 h (domain and store ~1 h; console and API ~1 h; AC tests ~1.25 h; mutants ~30 min; gates ~25 min per full run; captures ~30 min). Confidence medium: the capture and sync fixtures are reused from 901w and 9016.
- **Done for the builder:** `ready-for-review` with:
  - every task committed (author `Justin Issa <justin@leorna.com>`, no AI attribution, no `CLAUDE.md`);
  - the worktree clean;
  - G1–G8 `EXIT=0` on the final head;
  - AC1–AC4 logs and screenshots (including Justin's before/after console captures for remove and reorder);
  - M1–M14 recorded;
  - the docs and records updated;
  - nothing pushed.
- **Story done (later roles):** review 1 → fix → review 2 → fix → verifier (clean) → blind AC auditor → `ac-check.sh --base <merge-base>` printing `ALL ACCEPTED: 4 of 4 ACs` (no `(live)` AC) → finisher hand-over (PR text, review prompt, ClickUp evidence draft with the four AC screenshots plus the before/after pairs). Push, PR, ClickUp post and merge wait for Justin's own words.

## Justin's answers (2026-10-29)

Approved under the away grant (Justin's words: "just keep everything going and follow what the recommended agent says"), recorded by the main session on 2026-10-29: plan **go** with Q1-A, Q2-A, Q3-A and all four ACs (AC3 is Justin's reorder addition; AC4 as proposed). No AC is `(live)`. Push, PR, ClickUp posting and merge remain unauthorized.
