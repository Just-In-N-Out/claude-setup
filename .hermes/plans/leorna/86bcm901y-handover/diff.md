# 86bcm901y stop and show: `feat/86bcm901y-remove-reorder` at `3e8d181` (not pushed)

Base `6c1709e` (= GitHub `main`, rechecked 2026-10-29 14:32 UTC). The worktree is clean. There are 13 commits, and nothing is pushed, opened or merged.

## `git diff --stat 6c1709e...HEAD`

```
 contracts/control-plane.openapi.yaml               |  19 +-
 delivery/stories.json                              |   6 +
 internal/bundle/README.md                          |   2 +
 internal/pack/README.md                            |  35 +-
 internal/pack/builder.go                           | 106 ++-
 internal/pack/builder_order_test.go                | 163 ++++
 internal/pack/builder_test.go                      |  12 +-
 .../migrations/000024_pack_item_order.down.sql     |   2 +
 .../migrations/000024_pack_item_order.up.sql       |  10 +
 internal/store/postgres/pack_builder.go            |  26 +-
 internal/store/postgres/pack_items_test.go         | 325 ++++++++
 internal/store/postgres/pack_versions.go           |  21 +-
 internal/web/README.md                             |  12 +
 internal/web/handler.go                            |   1 +
 internal/web/library.go                            |  15 +-
 internal/web/pack_builder.go                       |  28 +-
 internal/web/pack_builder_test.go                  |   2 +-
 internal/web/pack_items.go                         | 143 ++++
 internal/web/pack_items_form_test.go               |  85 ++
 internal/web/pack_items_test.go                    | 858 +++++++++++++++++++++
 packages/contracts/controlplane.gen.go             |  38 +-
 21 files changed, 1855 insertions(+), 54 deletions(-)
```

## Commits (`git log --oneline 6c1709e..HEAD`)

```
3e8d181 fix(86bcm901y): say the audit records the order whenever a save names one
b35d111 fix(86bcm901y): document that versions derived on Pack Versions drop the order
f2eccd5 fix(86bcm901y): test the item form's parent_version and 4 KiB bounds
bc5b410 fix(86bcm901y): audit the order of every save that names one
70bf9b9 fix(86bcm901y): refuse a present but empty item order
c574cdd docs(86bcm901y): remove and reorder items
fd03953 feat(86bcm901y): remove and reorder items from the pack's item list
c5b2631 test(86bcm901y): acceptance tests for remove and reorder
13a18e2 feat(86bcm901y): add an item order to the pack version contract
cc518b5 feat(86bcm901y): store item positions in built pack versions
9425046 feat(86bcm901y): carry an item order through the pack builder service
70cb520 feat(86bcm901y): mark reorders in the pack diff
750d135 feat(86bcm901y): order a pack version's items in ApplyChange
```

## Pre-flight (read-only, run 2026-10-29 by the finisher)

- `git log --format='%an <%ae> | %cn <%ce>' 6c1709e..HEAD | sort | uniq -c` gives `13 Justin Issa <justin@leorna.com> | Justin Issa <justin@leorna.com>`.
- AI-attribution lines in commit bodies: `git log --format='%H%n%B' 6c1709e..HEAD | grep -inE '^co-authored-by:|generated with|noreply@anthropic|🤖'` finds **none**.
- `git diff --name-only 6c1709e...HEAD -- .github/` is **empty**.
- `git ls-files | grep -i claude.md`: none. `git status --porcelain`: empty.

## Key hunks

### Migration 24 (`internal/store/postgres/migrations/000024_pack_item_order.*.sql`)

```sql
-- up
ALTER TABLE pack_version_items
 ADD COLUMN position integer NOT NULL DEFAULT 0
 CONSTRAINT pack_version_items_position_check CHECK (position >= 0);
-- No two items of one ordered version share a position.
CREATE UNIQUE INDEX pack_version_items_position ON pack_version_items (pack_version_id, position) WHERE position > 0;
-- down
DROP INDEX pack_version_items_position;
ALTER TABLE pack_version_items DROP COLUMN position;
```

The change is add-only. A constant default rewrites no row, so migration 23's no-edit triggers never fire. The verifier applied 24 over real migration-23 rows (`verifier/m24-existing-rows.log`): every row got position 0, the rows stayed byte-identical and the listings were unchanged. Editing a position afterwards gives 42501 (immutable). The down migration keeps the rows.

### `internal/pack/builder.go` (domain)

```go
 type Diff struct {
 	...
+	// Reordered: the items kept from the parent changed their relative order,
+	// or an added item went ahead of a kept one. Omitted when false, so saves
+	// without an order keep 86bcm901w's audit shape.
+	Reordered bool `json:"reordered,omitempty"`
 }
@@ type Change struct {
 	Add    []SeedItem
 	Remove []ItemKey
+	Order  []ItemKey
 }
@@ func ApplyChange(parent []SeedItem, change Change) ([]SeedItem, error) {
-	if len(change.Add) == 0 && len(change.Remove) == 0 {
+	if len(change.Add) == 0 && len(change.Remove) == 0 && len(change.Order) == 0 {
 	...
-	return next, nil
+	if len(change.Order) == 0 {
+		return next, nil
+	}
+	ordered, err := applyOrder(next, change.Order)   // every resulting item exactly once
+	...
+	if len(change.Add) == 0 && len(change.Remove) == 0 && sameOrder(parent, ordered) {
+		return nil, invalid("change")                // an order that changes nothing
+	}
+	return ordered, nil
@@
+type VersionChange struct {
+	AddLibraryItemIDs []string
+	Remove            []ItemKey
+	Order             []ItemKey // optional: every resulting item once, in its new order
+}
-func (s *BuilderService) SaveVersion(ctx, actor, packID, parentVersion string, add []string, remove []ItemKey) (BuiltVersion, error)
+func (s *BuilderService) SaveVersion(ctx, actor, packID, parentVersion string, change VersionChange) (BuiltVersion, error)
```
`PackChange.Validate` also bounds `Order` at 500 (`MaxItems`).

### `internal/store/postgres/pack_versions.go`

```go
-func (database *Store) insertVersionItems(ctx context.Context, tx pgx.Tx, versionID string, items []pack.SeedItem) error {
-	for _, item := range items {
+func (database *Store) insertVersionItems(ctx context.Context, tx pgx.Tx, versionID string, items []pack.SeedItem, ordered bool) error {
+	for index, item := range items {
 	...
+		position := 0
+		if ordered {
+			position = index + 1
+		}
-			`INSERT INTO pack_version_items(id,pack_version_id,kind,name,version,description,body,files)
-			 VALUES($1,$2,$3,$4,$5,$6,$7,$8)`,
+			`INSERT INTO pack_version_items(id,pack_version_id,kind,name,version,description,body,files,position)
+			 VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
@@ CreateVersion
-	if err := database.insertVersionItems(ctx, tx, id, spec.Items); err != nil {
+	if err := database.insertVersionItems(ctx, tx, id, spec.Items, false); err != nil {
@@ loadVersionItems
-		 ORDER BY i.kind,i.name`,
+		 ORDER BY i.position,i.kind,i.name`,
```
(**Integration:** 901r's new `starter_packs.go:140` caller must add `, false`. See `integration.md`.)

### `internal/store/postgres/pack_builder.go`

```go
-	next, err := pack.ApplyChange(parentItems, pack.Change{Add: add, Remove: spec.Remove})
+	next, err := pack.ApplyChange(parentItems, pack.Change{Add: add, Remove: spec.Remove, Order: spec.Order})
 	...
+	after := auditAfter(built)
+	// A save that names an order records both orders (86bcm901y) ... saves without one keep 86bcm901w's audit shape.
+	if len(spec.Order) > 0 {
+		before["order"] = itemOrder(parentItems)
+		after.Order = itemOrder(next)
+	}
-	if err := database.appendAudit(ctx, tx, actor, "pack.version.create", packID, before, auditAfter(built)); err != nil {
+	if err := database.appendAudit(ctx, tx, actor, "pack.version.create", packID, before, after); err != nil {
@@ insertBuiltVersion
-	if err := database.insertVersionItems(ctx, tx, id, items); err != nil {
+	if err := database.insertVersionItems(ctx, tx, id, items, true); err != nil {
@@ type packAuditRecord struct {
+	Order         []string  `json:"order,omitempty"` // kind/name in the new order, only when the save names an order
```

### `internal/web/pack_items.go` (new) and `handler.go`

```go
+	routes.Handle("POST /admin/library/packs/{packId}/items", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.packItemsForm)), false))
```
`packItemsForm` works in these steps:
- `adminForm` checks CSRF and the 4 KiB body bound.
- The form must carry exactly one button (`remove` / `move_up` / `move_down` = item id) and exactly one `parent_version`; otherwise 400 `INVALID_REQUEST`.
- It reads the pack through `packBuilder.Pack`, which is tenant-scoped (another company's pack is 404).
- A stale `parent_version` gives 409 and the newer-version alert.
- `itemOperationChange` builds the change. Remove gives `Remove: [key]`; Move up and Move down swap neighbours and give a full `Order`. It refuses with an inline 400 alert when the button can't apply: removing the only item, moving the first item up, moving the last item down, or an id not in this version.
- `SaveVersion` runs. The store's stale check under the row lock is the one that counts.
- On success: 303 back to the edit view.

### `internal/web/pack_builder.go` (JSON API)

```go
-	built, err := handler.packBuilder.SaveVersion(r.Context(), teamActor(r), packID.String(), body.ParentVersion, add, remove)
+	if body.Order != nil {
+		// An order lists every resulting item, so a present but empty one is
+		// refused even beside other changes (minItems: 1), never ignored.
+		if len(*body.Order) == 0 {
+			handler.writePackBuilderError(w, r, org.ErrInvalid)
+			return
+		}
+		for _, key := range *body.Order { change.Order = append(change.Order, pack.ItemKey{...}) }
+	}
+	built, err := handler.packBuilder.SaveVersion(r.Context(), teamActor(r), packID.String(), body.ParentVersion, change)
```
`libraryBuilder` gains `PackID` and `PackItems`. `library.go` renders the "Items in version N, in order" `<ol>` with Move up, Move down and Remove buttons (`form="pack-items-form"`). The first item's Move up, the last item's Move down and a lone item's Remove are rendered disabled.

### OpenAPI (`contracts/control-plane.openapi.yaml`; generated code regenerated, `check-generated-contracts.sh` EXIT=0)

```yaml
       summary: Save the pack's next immutable version by adding, removing or reordering items
@@ PackVersionChange.properties
+        order:
+          type: array
+          minItems: 1
+          maxItems: 500
+          description: >-
+            The complete order of the new version's items after removals and additions, first
+            item first: every resulting item exactly once. Leave it out to keep the parent's
+            order, with added items last. An empty order, or one that changes nothing, is
+            refused (400).
+          items: {$ref: "#/components/schemas/PackItemKey"}
```
The change is additive. The only removed lines are the replaced `summary` and `PackVersionChange.description` lines. It also adds descriptions on `PackCreate.libraryItemIds` and `PackVersionDetail.items`. In `controlplane.gen.go` the change is `Order *[]PackItemKey` (`omitempty`) plus comments, 22 lines added and 16 removed.

## Gate results on `3e8d181` (verifier, detached copy, own DB)

`verifier/gates-summary-3e8d181.txt` has every step at EXIT=0:
- G1 `make check` (lint 0 issues in both modules; govulncheck "No vulnerabilities found" in both modules; gitleaks "no leaks found"; library-gate PASSED);
- G2 `test-module-add.sh`;
- G3 Postgres-ran (527 entries: 523 pass, 4 accepted skips, 0 missing declared tests, no skip naming `LEORNA_TEST_DATABASE_URL`, 106 story and builder entries all pass);
- G4 AC1–AC4, the store order test and 901w's AC3 audit shape;
- G5 story gitleaks;
- G6 scope and authors;
- G7 contract diff and generated-code check;
- G8 `test_story_shippable.py`.

G9, the container build at `3e8d181`, also passed (`verifier/image-3e8d181.txt`, build EXIT=0, gitleaks 8.30.1 in the image). `ac-check.sh`: `ALL ACCEPTED: 4 of 4 ACs on 3e8d181`.
