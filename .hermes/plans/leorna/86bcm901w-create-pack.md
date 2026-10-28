# 86bcm901w — Create a pack by picking library items (control plane)

- **Status:** Approved by Justin 2026-10-28 (away grant: "keep this running… just go with the recommended stuff the agent says"). Every ⭐ answer applies; see "Justin's answers" below the questions. Still no push, PR or ClickUp post without his word.
- **Card:** [Create a pack by picking library items](https://app.clickup.com/t/86bcm901w) (E11 Pack Builder, PI-2, Size M, p1-high).
- **Repo / worktree / branch:** `leorna-control-plane`, `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, `feat/86bcm901w-create-pack`.
- **Base:** `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (Merge PR #93). Checked 2026-10-28 18:41 UTC: HTTPS fetch through gh, `origin/main` = local `main` = GitHub `main` (`gh api repos/LeornaAI/leorna-control-plane/commits/main`) = `1ee7157`. No fast-forward was needed; the worktree is clean at that SHA.
- **Pipeline:** Full. Every role is a fresh Opus 5.5 xhigh agent. No push, PR, merge or ClickUp post without Justin's word.

## Questions for Justin (answer before "go")

**Q1. Can two packs in one company have the same name?**
- **A ⭐ No: names are unique per company, ignoring case (409).**
- B. Yes: allow duplicate names.

If B: drop the unique index `pack_lineages_tenant_name` and `pack.ErrNameTaken`, and remove the duplicate-name row from AC4's test and mutant M9. Nothing else changes.

**Q2. Can the existing starter-pack versions and forks be edited here?**
- **A ⭐ No: only packs made in the library get versions 1, 2, …**
- B. Yes: add a "Turn into a pack" button on Pack Versions.

If B: add `POST /admin/packs/versions/adopt`, which makes the chosen version version 1 of a new pack. It copies the items into a new immutable row, since rows can't be edited. It needs its own audit action `pack.adopt`, one extra subtest in AC1, and about 1 hour more work.

**Q3. This Ubuntu has no Go, no `make`, no Docker access and no test Postgres. How do we get them?** (The same question and ⭐ as 86bcm901a's question D, so one answer and one setup serve 901a, 901w and the other siblings.)
Checked 2026-10-28: there is no `go` anywhere and `command -v make` finds nothing. `docker` prints "could not be found in this WSL 2 distro… activate the WSL integration in Docker Desktop". Nothing listens on port 5432. Already present: gitleaks 8.30.1 (CI's version) at `/usr/local/bin/gitleaks`, and Chrome for Testing 156 at `~/.cache/chrome-for-testing/chrome-linux64/chrome`, which runs with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` (without it: "libnspr4.so: cannot open shared object file").
- **A ⭐ You: Docker WSL toggle + apt make; agent adds Go/linters.**
- B. Build this story on the Mac instead.
- C. You install everything first; builder only checks.

With A, Justin does two things: (1) Docker Desktop → Settings → Resources → WSL integration → turn on "Ubuntu" → Apply & restart; (2) in Ubuntu, `sudo apt-get install -y make`. The builder then installs Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0, each checksum-checked, into `~/.local/leorna-toolchain/` (the folder 901a's plan uses; reused if a sibling already filled it), uses the existing `/usr/local/bin/gitleaks`, sets PATH per command only, and starts `leorna-test-pg` from CI's pinned image if that container doesn't exist yet (task B0).
If B: every path becomes `/Users/justin/...`, and the macOS recipes in the `leorna` skill apply (Terminal capture, Homebrew gnubin and bash). If C: B0 only checks versions and stops `blocked` until they match.

## Justin's answers (2026-10-28)

The questions above are answered. Justin's words, before stepping away: "Okay, look, I'm gonna go shower, so just keep this running, okay? Just go with the recommended stuff the agent says, alright?" The main session took that as **go** on this plan with every ⭐ answer. The grant lasts until Justin says otherwise, and it never covers push, a PR or a ClickUp post.

- **Q1 → A:** pack names are unique per company, ignoring case (409).
- **Q2 → A:** only packs made in the library get versions 1, 2, …; starter-pack versions and forks are not adoptable here.
- **Q3 → A:** Justin turns on Docker's WSL integration for Ubuntu and runs `sudo apt-get install -y make`; agents install Go, golangci-lint and govulncheck into `~/.local/leorna-toolchain/`. **Owed by Justin:** both of his steps were still undone at approval time (checked 2026-10-28: `docker` is only the Windows stub, and there's no `make`).
- **ACs approved with this go:** AC1–AC3 from the card, plus AC4 (proposed). None is `(live)`.
- **Main-session ruling (while Justin is away, not his):** until his two Q3 steps are done, the builder does only the B0 steps that don't need `make` or Docker (worktree check, fetch, tool installs, Chrome check), then B1 and B2. Those are pure Go, test-first with plain `go test`, no database and no `make`. Then it stops `blocked: make, docker`. B0.6 (base baseline) and B0.7 (before-screenshot) run from a detached copy at `BASE` once unblocked, so B1/B2's commits can't affect them. Every other step follows the plan unchanged.
- **Builder 1 result (2026-10-28):** B1+B2 committed (`479211b`, `18ed1b7`), then stopped `blocked: make, docker, gcc`. **Q3 now also needs gcc:** `make test` runs `go test -race`, which needs cgo, and this Ubuntu has no C compiler. Justin's line becomes `sudo apt-get install -y make gcc` (environment only; no design change). The continuation builder's brief is `briefs/86bcm901w-create-pack-builder-2.md`.

## Acceptance criteria

The card's three ACs come first, in its own wording. AC4 is mine and is marked proposed. None needs Justin's live check, so none is tagged live. Each test's name sits whole on its AC line.

- AC1: Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items — test `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`
- AC2: Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set — test `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`
- AC3: Given a save, then a change-audit record is written (actor, action, diff) — test `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`
- AC4 (proposed): Given a save that is invalid or not allowed (no name, no items, an unknown or repeated item, a name already used, nothing changed, a pack left empty, an outdated version, a member, a bad CSRF token, another company's pack), then it is refused with a clear status and nothing is written (no pack, no version, no audit record) — test `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`

AC4 makes the card's DoD "happy path + 1 failure" concrete and covers the tenant, permission and CSRF guards.

## Playback and summary

**Playback:** an admin ticks items on the admin console's Content library page (built in 86bcm901v), names the pack and saves it, which creates version 1 with exactly those items. Ticking or unticking items on that pack later saves version 2, 3, … as new immutable rows with ParentVersion set. Every save writes an audit record with the actor, the action and the diff. A JSON API in the OpenAPI contract does the same, so 901y, 9026, 902a and 902d can build on it.

**What gets built:**
1. **Migration 23** adds:
   - a small `pack_lineages` table: the "pack" with its name, unique per company;
   - two columns on `pack_versions`, `pack_id` and `pack_number`;
   - database triggers that refuse any UPDATE or DELETE of saved pack versions and their items.
2. **Package `pack`** gets the pure `ApplyChange` and `DiffItems` functions and a small `BuilderService`.
3. **The Postgres store** gets `CreatePack`, `SavePackVersion`, `GetPack` and `ListPacks`. Each write runs in one transaction with the admin re-check and its `pack.create` or `pack.version.create` audit record.
4. **Four admin-only JSON endpoints:**
   - `GET /v1/packs`
   - `POST /v1/packs`
   - `GET /v1/packs/{packId}`
   - `POST /v1/packs/{packId}/versions`
5. **The library page** gets a checkbox column, a "Build a pack" form, and an edit view at `/admin/library/packs/{packId}` with the boxes already ticked.

## Skills (build roles)

| Role | Loads, in order |
| --- | --- |
| Every role | `leorna` (role rules only; this plan already did its Step 1), `engineering-best-practices` |
| Builder | + `test-driven-development`, `mutation-testing-discipline` (immutability, permission, tenant, CSRF and audit-atomicity guards: mutants M1–M10 below), `security-best-practices` (read `references/golang-general-backend-security.md`: GO-HTTP-002 body bounds, GO-HTTP-006 CSRF, GO-XSS-001 html/template, GO-INJECT-001 parameterized SQL, GO-REDIRECT-001), `multi-tenant-auth-management`, `api-contract-drift-guard` **[ends with Mandatory Validation and Agent Defect Loop]**, `backend-data-migrations` **[ends with Mandatory Validation and Agent Defect Loop]** |
| Reviewers 1 and 2 | + `requesting-code-review`, `code-review-practice` (report only), the four specialists above |
| Fixers / finisher | + `receiving-code-review`, `test-driven-development`, `git-commit-rules` (finisher), the specialists for the area touched |
| Verifier / AC auditor | + `references/ac-verification.md` (feature-dispatch), the specialists |

The two Defect Loop skills mean the hand-over waits for a clean verifier. Agents don't start agents: the main session runs that loop.

Every brief carries this rule: list reusable lessons in `skill_lessons[{skill, lesson, evidence}]` and never edit skills or memory. Every role keeps its scratch in a fresh `<scratchpad>/86bcm901w-<role>/` (created with `mkdir`, no `-p`) and removes only that folder.

## Current context (facts this plan relies on, at `1ee7157`)

**Pack versions and the library**
- `internal/pack/version_service.go:50-58` `SaveEditedVersion` → `applyEdit` (`:98-120`) only replaces or appends one item, matched by kind and name. `Fork` (`:40-48`) copies a whole version. Version ids come from `defaultVersionID()` (`:34-36`), for example `v20261028T184121.123456789Z`, with one retry on `ErrVersionExists` (`:76-87`).
- `internal/pack/version.go:20-28` `PackVersion{ID, TenantID, Name, Version, ParentVersion, CreatedAt, Items}`.
  - There is no pack identity and no version number. A "pack" today is a chain of `parent_version` strings.
  - `UNIQUE(tenant_id, version)` (migration 15) means a version string can't be "1" for two packs.
- `internal/store/postgres/pack_versions.go`:
  - `CreateVersion` (`:21-97`) writes **no audit record**.
  - Items are inserted in a loop (`:66-88`).
  - `loadVersionItems` (`:287-318`) returns items `ORDER BY i.kind,i.name`, so **no item order is stored**.
- `internal/store/postgres/migrations/000015_pack_versions.up.sql`: `pack_versions` and `pack_version_items` (`UNIQUE(pack_version_id, kind, name)`). Migration 22 adds `files jsonb` and `pack_script_approvals`. The last migration on main is **22**.
- `internal/store/postgres/library_catalog.go`:
  - `ListLibraryItems` (`:21-57`) returns the newest version per kind and name, metadata only, sorted in Go by byte order.
  - `GetLibraryItem` (`:61-82`) does **not** read `files`.
  - `library_items` rows (migration 20) are shared product content (no `tenant_id`) and never rewritten.

**Audit, auth and the admin console**
- `internal/store/postgres/audit.go:13-28` `appendAudit(ctx, tx, actor, action, target, before, after)` writes `audit_records` in the caller's transaction. Migration 4's trigger `reject_audit_edit` makes those records immutable, and `/admin/audit?target=<id>` and `GET /v1/audit` show them. `pack.assign` (`pack_assignments.go:49`) and `pack.seed` (`packs.go:66`) already use it.
- `internal/store/postgres/teams.go`:
  - `beginOrg(ctx, actor, write)` (`:31-49`) re-reads the role inside the transaction and returns `org.ErrForbidden` for a non-admin write.
  - `orgError` (`:250-270`) maps 23505 to `store.ErrConflict` and no rows to `store.ErrNotFound`. It passes `org.ErrInvalid`, `org.ErrForbidden` and anything wrapping `store.ErrConflict` through unchanged.
- `internal/web/library.go`:
  - The page lives at `GET /admin/library` (`handler.go:277`).
  - `libraryFilter` (`:25-47`) **rejects any query key other than kind, category, tag, tool and q** (the existing test asserts that `?colour=red` returns 400). So edit mode must be a path (`/admin/library/packs/{packId}`), not a query parameter.
  - The template is at `:217-251`.
- `internal/web/library_test.go:84-85`: the row regex `<tr class="item">.*?</tr>` and the link regex `<a class="item-name" href=…>NAME</a><div class="muted">…</div></td><td>KIND</td>`. A checkbox cell must therefore come **before** the name cell, and nothing may sit between the description `div` and the kind cell.
- `internal/web/cloud_plan.go:93-116` `adminForm` caps form bodies at 4 KiB (`maxFormBytes`, `handler.go:47`). That is too small for about 55 rows that each carry an `item` and a `shown` field.
- `internal/web/teams.go:21-38` `teamGuard` is the JSON pattern: the `X-CSRF-Token` header must match the `__Host-leorna-csrf` cookie on non-GET requests, and the body is bounded. Routes look like `requireSession(requireAdmin(guard(api)), false)` (`handler.go:240-246`).

**The OpenAPI contract and its tests**
- The contract is `contracts/control-plane.openapi.yaml`. Its generated server is `packages/contracts/controlplane.gen.go` (std-http and strict), and `make contracts-check` fails on drift.
- `packages/contracts/roundtrip_test.go:36-…` `roundTripServer` must implement every `StrictServerInterface` method, so new operations need stubs there.
- `internal/web/contract_kinds_test.go` **and the client's** `application/contract_kinds_test.go` both require **exactly 2** inline `kind: {type: string, enum: […]}` lines in the spec. New kind enums must go in a named schema, not that inline form.

**Tests, fixtures and sync output**
- Web test fixture: `newPackFixture` (`internal/web/packs_test.go:41-115`) gives each test its own Postgres schema, an admin, a member and an admin of another tenant. `newLibraryFixture` and `insertLibraryItems` (`library_test.go:27-59`) insert library rows; they don't insert `files` today.
- Store test helpers: `resetDatabase` (`internal/store/postgres/store_test.go:489-505`) and the two table lists in `TestMigrationRoundTrip` (`:34`, `:104`) must learn about new tables and functions. `waitForLockWait` is in `pack_versions_test.go:325`.
- Sync output is order-free: `internal/bundle/bundle.go:41,78` and `content.go:96` sort files and items by path. A new version reaches engineers only after an admin assigns it (`pack_assignments.go`).

**Other things in flight**
- Yan's **PR #94** (86bcm9021, OPEN, created 2026-10-28 18:23 UTC, head `e7e2fba`) edits:
  - `internal/pack/version_service.go` (adds `CreateItem`, `ErrItemExists`), `internal/pack/README.md`;
  - `internal/web/handler.go` (field `itemBuilder` and routes `/admin/packs/versions/new`), `internal/web/pack_versions.go`, `cmd/control-plane/main.go`;
  - `delivery/stories.json`;
  - and adds a new `GLOSSARY.md`.

  It has no migration.
- The client (`~/Leorna/leorna-client`, `f105e27`) generates types and clients with oapi-codegen v2.8.0 from **its own snapshot** `api/control-plane.openapi.yaml`, which is identical to the server's at `1ee7157`. Its `make contracts-check` compares that snapshot with its own generated code.

## Design

### D1. Data model and migration 23 (`000023_pack_builder`)

A **pack** is a named lineage of immutable pack versions numbered 1, 2, 3, … per pack:
- the number is what admins see ("version 2");
- the existing unique version id string stays the key that assignments and Sync use.

Old versions (the seed base, forks, single-item edits, Yan's created items) keep `pack_id` NULL and behave as before (Q2-A).

`internal/store/postgres/migrations/000023_pack_builder.up.sql`:

```sql
-- Packs built from content library items (story 86bcm901w). A pack is a named
-- lineage of immutable pack versions numbered 1, 2, 3... Older pack versions
-- (seed base, forks, single-item edits) keep pack_id NULL and are unchanged.
CREATE TABLE pack_lineages (
 id uuid PRIMARY KEY,
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
 name text NOT NULL CHECK (char_length(btrim(name)) BETWEEN 1 AND 200),
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE (tenant_id, id)
);
-- One pack per name per tenant, ignoring case and surrounding spaces (Q1-A).
CREATE UNIQUE INDEX pack_lineages_tenant_name ON pack_lineages (tenant_id, lower(btrim(name)));

ALTER TABLE pack_versions
 ADD COLUMN pack_id uuid NULL,
 ADD COLUMN pack_number integer NULL CHECK (pack_number >= 1),
 ADD CONSTRAINT pack_versions_pack_fk FOREIGN KEY (tenant_id, pack_id) REFERENCES pack_lineages (tenant_id, id) ON DELETE RESTRICT,
 ADD CONSTRAINT pack_versions_pack_pair CHECK ((pack_id IS NULL) = (pack_number IS NULL)),
 ADD CONSTRAINT pack_versions_pack_tenant CHECK (pack_id IS NULL OR tenant_id IS NOT NULL),
 ADD CONSTRAINT pack_versions_pack_number_key UNIQUE (pack_id, pack_number);

-- Saved pack versions and their items never change: new content is a new version.
CREATE FUNCTION reject_pack_version_edit() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 RAISE EXCEPTION 'pack versions are immutable' USING ERRCODE = '42501';
END;
$$;
CREATE TRIGGER pack_versions_no_edits BEFORE UPDATE OR DELETE ON pack_versions
 FOR EACH ROW EXECUTE FUNCTION reject_pack_version_edit();
CREATE TRIGGER pack_version_items_no_edits BEFORE UPDATE OR DELETE ON pack_version_items
 FOR EACH ROW EXECUTE FUNCTION reject_pack_version_edit();
```

`000023_pack_builder.down.sql`:

```sql
DROP TRIGGER pack_version_items_no_edits ON pack_version_items;
DROP TRIGGER pack_versions_no_edits ON pack_versions;
DROP FUNCTION reject_pack_version_edit();
ALTER TABLE pack_versions
 DROP CONSTRAINT pack_versions_pack_number_key,
 DROP CONSTRAINT pack_versions_pack_tenant,
 DROP CONSTRAINT pack_versions_pack_pair,
 DROP CONSTRAINT pack_versions_pack_fk,
 DROP COLUMN pack_number,
 DROP COLUMN pack_id;
DROP TABLE pack_lineages;
```

Notes:
- The composite FK with `MATCH SIMPLE` is skipped when any column is NULL. `pack_versions_pack_tenant` closes the "tenant_id NULL but pack_id set" gap, so a built version always belongs to its lineage's tenant.
- No code path updates or deletes pack versions; checked with `grep -rn "UPDATE pack_version\|DELETE FROM pack_version"`. Only the down migrations 18 and 21 delete rows, and they run after 23's down has dropped the triggers.
- `releasedMigrationHashes` pins only 1 and 2 (`migrate.go:22-25`), so 23 needs no hash entry.
- Expand-only change: older binaries ignore the new columns, and a NULL `pack_id` keeps every old row valid.
- Rollback: `RollbackMigrations` drops the lineages, so built versions remain as plain versions (they lose their pack name link and number). That is safe but lossy; prefer fix-forward, as migration 21 already advises.

### D2. Domain: `internal/pack/builder.go` (new file; `version_service.go` is untouched to stay clear of PR #94)

```go
package pack

import (
	"cmp"
	"context"
	"errors"
	"fmt"
	"slices"
	"strings"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// ErrNameTaken reports that the tenant already has a pack with this name,
// compared without case or surrounding spaces.
var ErrNameTaken = fmt.Errorf("a pack with this name already exists: %w", store.ErrConflict)

// ErrStaleParent reports that a save was based on a version that is no longer
// the pack's latest, so saving it would silently drop another admin's change.
var ErrStaleParent = fmt.Errorf("the pack has a newer version: %w", store.ErrConflict)

// ItemKey identifies an item inside one pack version: its kind and name.
type ItemKey struct {
	Kind Kind
	Name string
}

// Key returns the item's key.
func (item SeedItem) Key() ItemKey { return ItemKey{Kind: item.Kind, Name: strings.TrimSpace(item.Name)} }

// AsSeedItem returns a stored item as the spec that copies it into a new version.
func (item Item) AsSeedItem() SeedItem {
	return SeedItem{Kind: item.Kind, Name: item.Name, Version: item.Version, Description: item.Description, Body: item.Body, Files: item.Files}
}

// ItemRef names one item version in a diff or audit record. It never carries
// item bodies or files.
type ItemRef struct {
	Kind            Kind   `json:"kind"`
	Name            string `json:"name"`
	Version         string `json:"version"`
	PreviousVersion string `json:"previousVersion,omitempty"`
}

// Diff is what one save changed, by kind and name. Each list is sorted by
// kind, then name (byte order), and is never nil so it encodes as [].
type Diff struct {
	Added   []ItemRef `json:"added"`
	Removed []ItemRef `json:"removed"`
	Changed []ItemRef `json:"changed"`
}

// DiffItems compares two item sets. A key in both whose version, description,
// body or files differ is Changed, with PreviousVersion set.
func DiffItems(before, after []SeedItem) Diff {
	diff := Diff{Added: []ItemRef{}, Removed: []ItemRef{}, Changed: []ItemRef{}}
	previous := make(map[ItemKey]SeedItem, len(before))
	for _, item := range before {
		previous[item.Key()] = item
	}
	present := make(map[ItemKey]bool, len(after))
	for _, item := range after {
		present[item.Key()] = true
		old, existed := previous[item.Key()]
		switch {
		case !existed:
			diff.Added = append(diff.Added, refOf(item))
		case !sameContent(old, item):
			changed := refOf(item)
			changed.PreviousVersion = strings.TrimSpace(old.Version)
			diff.Changed = append(diff.Changed, changed)
		}
	}
	for _, item := range before {
		if !present[item.Key()] {
			diff.Removed = append(diff.Removed, refOf(item))
		}
	}
	for _, list := range [][]ItemRef{diff.Added, diff.Removed, diff.Changed} {
		slices.SortFunc(list, func(a, b ItemRef) int {
			return cmp.Or(cmp.Compare(a.Kind, b.Kind), cmp.Compare(a.Name, b.Name))
		})
	}
	return diff
}

func refOf(item SeedItem) ItemRef {
	return ItemRef{Kind: item.Kind, Name: strings.TrimSpace(item.Name), Version: strings.TrimSpace(item.Version)}
}

func sameContent(a, b SeedItem) bool {
	return strings.TrimSpace(a.Version) == strings.TrimSpace(b.Version) && a.Description == b.Description &&
		a.Body == b.Body && slices.Equal(a.Files, b.Files)
}

// Change is one save's edit to a parent version's items: Remove applies first,
// then Add. Kept items keep their order and added items follow in the order
// given. Versions do not store an order (they list items by kind, then name);
// reordering is story 86bcm901y.
type Change struct {
	Add    []SeedItem
	Remove []ItemKey
}

// ApplyChange returns the next version's items and never modifies parent.
// An empty change, removing an item the parent lacks, naming an item twice,
// or adding one that is still present after the removals is invalid.
func ApplyChange(parent []SeedItem, change Change) ([]SeedItem, error) {
	if len(change.Add) == 0 && len(change.Remove) == 0 {
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
	return next, nil
}

// NewPack is the create spec for a pack built from content library items.
type NewPack struct {
	Name           string
	Version        string   // generated version id of version 1
	LibraryItemIDs []string // library_items row ids, in the order ticked
}

// Validate checks the spec's bounds without echoing values. The store checks
// that every id is a stored library item.
func (spec NewPack) Validate() error {
	if !validTrimmed(spec.Name, 1, maxNameRunes) {
		return invalid("pack name")
	}
	if !validTrimmed(spec.Version, 1, maxVersionRunes) {
		return invalid("pack version")
	}
	return validLibraryIDs(spec.LibraryItemIDs, 1)
}

// PackChange is the spec for the next version of a built pack.
type PackChange struct {
	PackID            string
	ParentVersion     string // must be the pack's latest version id
	Version           string // generated version id of the new version
	AddLibraryItemIDs []string
	Remove            []ItemKey
}

// Validate checks the spec's bounds without echoing values.
func (spec PackChange) Validate() error {
	if !validTrimmed(spec.ParentVersion, 1, maxVersionRunes) {
		return invalid("parent version")
	}
	if !validTrimmed(spec.Version, 1, maxVersionRunes) {
		return invalid("pack version")
	}
	if len(spec.AddLibraryItemIDs) == 0 && len(spec.Remove) == 0 {
		return invalid("change")
	}
	if len(spec.Remove) > MaxItems {
		return invalid("items to remove")
	}
	return validLibraryIDs(spec.AddLibraryItemIDs, 0)
}

func validLibraryIDs(ids []string, minimum int) error {
	if len(ids) < minimum || len(ids) > MaxItems {
		return invalid("library item count")
	}
	seen := make(map[string]bool, len(ids))
	for _, id := range ids {
		key := strings.ToLower(id)
		if id == "" || seen[key] {
			return invalid("library item")
		}
		seen[key] = true
	}
	return nil
}

// PackSummary is one built pack and its latest version, for lists.
type PackSummary struct {
	ID            string
	Name          string
	LatestNumber  int
	LatestVersion string
	CreatedAt     time.Time // when version 1 was saved
	UpdatedAt     time.Time // when the latest version was saved
}

// BuiltVersion is one numbered version of a built pack.
type BuiltVersion struct {
	PackID  string
	Number  int
	Version PackVersion // the immutable version and its items
	Diff    Diff        // what this save changed; empty when only read
}

// BuilderStore persists built packs. Writes re-check the admin role, run in
// one transaction and append their audit record in it.
type BuilderStore interface {
	CreatePack(ctx context.Context, actor store.Principal, spec NewPack) (BuiltVersion, error)
	SavePackVersion(ctx context.Context, actor store.Principal, spec PackChange) (BuiltVersion, error)
	ListPacks(ctx context.Context, actor store.Principal) ([]PackSummary, error)
	GetPack(ctx context.Context, actor store.Principal, packID string) (BuiltVersion, error)
}

// BuilderService creates packs from content library items and saves their
// next versions, generating version ids like VersionService.
type BuilderService struct {
	store      BuilderStore
	newVersion func() string
}

// NewBuilderService composes the service with the default version-id generator.
func NewBuilderService(store BuilderStore) *BuilderService {
	return &BuilderService{store: store, newVersion: defaultVersionID}
}

// CreatePack saves a new pack at version 1 with exactly the given library items.
func (s *BuilderService) CreatePack(ctx context.Context, actor store.Principal, name string, libraryItemIDs []string) (BuiltVersion, error) {
	return s.retry(func(version string) (BuiltVersion, error) {
		return s.store.CreatePack(ctx, actor, NewPack{Name: name, Version: version, LibraryItemIDs: libraryItemIDs})
	})
}

// SaveVersion saves the pack's next version from its latest one.
func (s *BuilderService) SaveVersion(ctx context.Context, actor store.Principal, packID, parentVersion string, add []string, remove []ItemKey) (BuiltVersion, error) {
	return s.retry(func(version string) (BuiltVersion, error) {
		return s.store.SavePackVersion(ctx, actor, PackChange{PackID: packID, ParentVersion: parentVersion, Version: version, AddLibraryItemIDs: add, Remove: remove})
	})
}

// Packs lists the tenant's built packs.
func (s *BuilderService) Packs(ctx context.Context, actor store.Principal) ([]PackSummary, error) {
	return s.store.ListPacks(ctx, actor)
}

// Pack reads a built pack's latest version with its items.
func (s *BuilderService) Pack(ctx context.Context, actor store.Principal, packID string) (BuiltVersion, error) {
	return s.store.GetPack(ctx, actor, packID)
}

// retry tries a fresh version id once more if the generated one collides.
func (s *BuilderService) retry(save func(version string) (BuiltVersion, error)) (BuiltVersion, error) {
	var lastErr error
	for attempt := 0; attempt < 2; attempt++ {
		built, err := save(s.newVersion())
		if !errors.Is(err, ErrVersionExists) {
			return built, err
		}
		lastErr = err
	}
	return BuiltVersion{}, lastErr
}
```

Notes:
- `invalid`, `validTrimmed`, `maxNameRunes`, `maxVersionRunes`, `MaxItems` and `defaultVersionID` already exist in package `pack` (`pack.go:33-41,187-275`, `version_service.go:34-36`).
- `toSeedItems` in `version_service.go` stays as it is: no edit there, to avoid conflicting with #94.

### D3. Store: `internal/store/postgres/pack_builder.go` (new file)

`var _ pack.BuilderStore = (*Store)(nil)`. Every query uses parameters and is keyed by `actor.TenantID`, except the shared, read-only `library_items`.

**Refactor first, behaviour unchanged:** move the item-insert loop of `CreateVersion` (`pack_versions.go:66-88`) into

```go
// insertVersionItems inserts one immutable version's items.
func (database *Store) insertVersionItems(ctx context.Context, tx pgx.Tx, versionID string, items []pack.SeedItem) error
```

using the same SQL. Call it from `CreateVersion` (covered by `TestPackVersionStore`) and from the new code. `EnsureSeedBase` stays untouched, because its errors name the step.

New helpers:

```go
// uniqueViolation reports a 23505 and the constraint it hit.
func uniqueViolation(err error) (string, bool) {
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) && pgErr.Code == "23505" {
		return pgErr.ConstraintName, true
	}
	return "", false
}

// loadLibraryItems copies content library rows into item specs, in the order
// of ids. Every id must be a stored library item; the library is shared
// product content, so the read is not tenant-keyed (the caller's transaction
// is already tenant-scoped through beginOrg).
func loadLibraryItems(ctx context.Context, tx pgx.Tx, ids []string) ([]pack.SeedItem, error) {
	if len(ids) == 0 {
		return []pack.SeedItem{}, nil
	}
	for _, id := range ids {
		if !validUUID(id) {
			return nil, fmt.Errorf("pack library item is invalid: %w", org.ErrInvalid)
		}
	}
	rows, err := tx.Query(ctx,
		`SELECT id::text,kind,name,version,description,body,files FROM library_items WHERE id = ANY($1::uuid[])`, ids)
	if err != nil {
		return nil, orgError(err)
	}
	defer rows.Close()
	found := make(map[string]pack.SeedItem, len(ids))
	for rows.Next() {
		var id, kind string
		var filesJSON []byte
		var item pack.SeedItem
		if err := rows.Scan(&id, &kind, &item.Name, &item.Version, &item.Description, &item.Body, &filesJSON); err != nil {
			return nil, orgError(err)
		}
		if err := json.Unmarshal(filesJSON, &item.Files); err != nil {
			return nil, orgError(err)
		}
		item.Kind = pack.Kind(kind)
		found[id] = item
	}
	if err := rows.Err(); err != nil {
		return nil, orgError(err)
	}
	items := make([]pack.SeedItem, 0, len(ids))
	for _, id := range ids {
		item, ok := found[strings.ToLower(id)]
		if !ok {
			return nil, fmt.Errorf("pack library item is invalid: %w", org.ErrInvalid)
		}
		items = append(items, item)
	}
	return items, nil
}
```

If pgx refuses to encode `[]string` as `uuid[]`, use `WHERE id::text = ANY($1::text[])` with lower-cased ids. The store test proves whichever is used.

```go
// insertBuiltVersion writes a numbered version of a built pack and reads it back.
func (database *Store) insertBuiltVersion(ctx context.Context, tx pgx.Tx, actor store.Principal, packID, name string, number int, parentVersion, version string, items []pack.SeedItem) (pack.BuiltVersion, error) {
	id, err := newUUID(database.random)
	if err != nil {
		return pack.BuiltVersion{}, err
	}
	built := pack.BuiltVersion{PackID: packID, Number: number}
	built.Version.TenantID = string(actor.TenantID)
	err = tx.QueryRow(ctx,
		`INSERT INTO pack_versions(id,tenant_id,name,version,parent_version,pack_id,pack_number)
		 VALUES($1,$2,$3,$4,$5,$6,$7)
		 RETURNING id,name,version,parent_version,created_at`,
		id, actor.TenantID, name, strings.TrimSpace(version), parentVersion, packID, number,
	).Scan(&built.Version.ID, &built.Version.Name, &built.Version.Version, &built.Version.ParentVersion, &built.Version.CreatedAt)
	if constraint, ok := uniqueViolation(err); ok {
		if constraint == "pack_versions_pack_number_key" {
			return pack.BuiltVersion{}, pack.ErrStaleParent
		}
		return pack.BuiltVersion{}, pack.ErrVersionExists
	}
	if err != nil {
		return pack.BuiltVersion{}, orgError(err)
	}
	if err := database.insertVersionItems(ctx, tx, id, items); err != nil {
		return pack.BuiltVersion{}, orgError(err)
	}
	built.Version.Items, err = loadVersionItems(ctx, tx, id, string(actor.TenantID))
	if err != nil {
		return pack.BuiltVersion{}, orgError(err)
	}
	return built, nil
}

// latestBuiltVersion reads a pack's newest version and its items.
func latestBuiltVersion(ctx context.Context, tx pgx.Tx, actor store.Principal, packID string) (pack.BuiltVersion, error) {
	built := pack.BuiltVersion{PackID: packID}
	built.Version.TenantID = string(actor.TenantID)
	err := tx.QueryRow(ctx,
		`SELECT id,name,version,parent_version,created_at,pack_number FROM pack_versions
		 WHERE tenant_id=$1 AND pack_id=$2 ORDER BY pack_number DESC LIMIT 1`,
		actor.TenantID, packID,
	).Scan(&built.Version.ID, &built.Version.Name, &built.Version.Version, &built.Version.ParentVersion, &built.Version.CreatedAt, &built.Number)
	if err != nil {
		return pack.BuiltVersion{}, orgError(err)
	}
	built.Version.Items, err = loadVersionItems(ctx, tx, built.Version.ID, string(actor.TenantID))
	if err != nil {
		return pack.BuiltVersion{}, orgError(err)
	}
	return built, nil
}

// packAuditRecord is the after-value of pack.create and pack.version.create:
// identifiers, counts and the diff, never item bodies or files.
type packAuditRecord struct {
	PackID        string    `json:"packId"`
	Name          string    `json:"name"`
	Version       string    `json:"version"`
	Number        int       `json:"number"`
	ParentVersion string    `json:"parentVersion"`
	ItemCount     int       `json:"itemCount"`
	Diff          pack.Diff `json:"diff"`
}

func auditAfter(built pack.BuiltVersion) packAuditRecord {
	return packAuditRecord{PackID: built.PackID, Name: built.Version.Name, Version: built.Version.Version, Number: built.Number,
		ParentVersion: built.Version.ParentVersion, ItemCount: len(built.Version.Items), Diff: built.Diff}
}
```

**`CreatePack(ctx, actor, spec pack.NewPack)`**, in order:
1. `spec.Validate()`, then `beginOrg(ctx, actor, true)`, which is the admin re-check. `defer` rollback.
2. `loadLibraryItems`.
3. `name := strings.TrimSpace(spec.Name)` and `pack.NewPackVersion{Name: name, Version: spec.Version, Items: items}.Validate()`. That validation rejects two versions of one library item.
4. `packID := newUUID`, then `INSERT INTO pack_lineages(id,tenant_id,name) VALUES($1,$2,$3)`. Any `uniqueViolation` returns `pack.ErrNameTaken`; other errors go through `orgError`.
5. `built := insertBuiltVersion(..., packID, name, 1, "", spec.Version, items)`.
6. `built.Diff = pack.DiffItems(nil, items)`.
7. `appendAudit(ctx, tx, actor, "pack.create", packID, nil, auditAfter(built))`; an error goes through `orgError`.
8. `tx.Commit`, then return `built`.

**`SavePackVersion(ctx, actor, spec pack.PackChange)`**, in order:
1. If `!validUUID(spec.PackID)`, return `store.ErrNotFound`. Then `spec.Validate()`, then `beginOrg(ctx, actor, true)`.
2. `SELECT name FROM pack_lineages WHERE tenant_id=$1 AND id=$2 FOR UPDATE`. No rows means `store.ErrNotFound`, and that includes another tenant's pack. This row lock serializes saves to one pack.
3. `parent := latestBuiltVersion(...)`. If `parent.Version.Version != strings.TrimSpace(spec.ParentVersion)`, return `pack.ErrStaleParent`.
4. `parentItems`: `item.AsSeedItem()` for each parent item.
5. `add := loadLibraryItems(spec.AddLibraryItemIDs)`.
6. `next := pack.ApplyChange(parentItems, pack.Change{Add: add, Remove: spec.Remove})`.
7. `pack.NewPackVersion{Name: name, Version: spec.Version, ParentVersion: parent.Version.Version, Items: next}.Validate()`. This rejects an empty pack ("item count").
8. `built := insertBuiltVersion(..., name, parent.Number+1, parent.Version.Version, spec.Version, next)`.
9. `built.Diff = pack.DiffItems(parentItems, next)`.
10. `appendAudit(ctx, tx, actor, "pack.version.create", spec.PackID, map[string]any{"version": parent.Version.Version, "number": parent.Number, "itemCount": len(parentItems)}, auditAfter(built))`.
11. Commit.

**`GetPack(ctx, actor, packID)`:**
1. If `!validUUID`, return `store.ErrNotFound`.
2. `beginOrg(ctx, actor, false)`: a current user of the tenant; the route adds the admin check, as for the catalog.
3. `SELECT EXISTS(SELECT 1 FROM pack_lineages WHERE tenant_id=$1 AND id=$2)`; false means `store.ErrNotFound`.
4. Return `latestBuiltVersion`.

**`ListPacks(ctx, actor)`** runs `beginOrg(ctx, actor, false)`, then:

```sql
SELECT l.id, l.name, l.created_at, v.version, v.pack_number, v.created_at
FROM pack_lineages l
JOIN LATERAL (SELECT version, pack_number, created_at FROM pack_versions
              WHERE tenant_id = l.tenant_id AND pack_id = l.id
              ORDER BY pack_number DESC LIMIT 1) v ON true
WHERE l.tenant_id = $1
```

It then sorts in Go by `strings.ToLower(Name)`, then `ID`, and returns `[]pack.PackSummary{}` (never nil) when there are none.

### D4. JSON API and OpenAPI (`contracts/control-plane.openapi.yaml`)

Insert these paths before `components:` (after `/v1/teams/{teamId}/members/{userId}`):

```yaml
  /v1/packs:
    get:
      operationId: listPacks
      summary: List the tenant's packs built from content library items, with each pack's latest version
      security:
        - sessionCookie: []
      responses:
        "200":
          description: Packs sorted by name
          content:
            application/json:
              schema:
                type: array
                items: {$ref: "#/components/schemas/PackSummary"}
        "401": {$ref: "#/components/responses/Unauthorized"}
        "403": {$ref: "#/components/responses/Forbidden"}
        "500": {$ref: "#/components/responses/InternalError"}
        "503":
          description: Pack builder unavailable
    post:
      operationId: createPack
      summary: Create a pack at version 1 holding exactly the given content library items
      security:
        - sessionCookie: []
      parameters:
        - name: X-CSRF-Token
          in: header
          required: true
          schema: {type: string, minLength: 43, maxLength: 43}
          description: Must match the __Host-leorna-csrf cookie from the current browser login.
      requestBody:
        required: true
        content:
          application/json:
            schema: {$ref: "#/components/schemas/PackCreate"}
      responses:
        "201":
          description: Version 1 of the new pack
          content:
            application/json:
              schema: {$ref: "#/components/schemas/PackVersionDetail"}
        "400": {$ref: "#/components/responses/InvalidRequest"}
        "401": {$ref: "#/components/responses/Unauthorized"}
        "403": {$ref: "#/components/responses/Forbidden"}
        "409": {$ref: "#/components/responses/Conflict"}
        "500": {$ref: "#/components/responses/InternalError"}
        "503":
          description: Pack builder unavailable
  /v1/packs/{packId}:
    get:
      operationId: getPack
      summary: Read a pack's latest version with its items
      security:
        - sessionCookie: []
      parameters:
        - {name: packId, in: path, required: true, schema: {type: string, format: uuid}}
      responses:
        "200":
          description: The pack's latest version
          content:
            application/json:
              schema: {$ref: "#/components/schemas/PackVersionDetail"}
        "400": {$ref: "#/components/responses/InvalidRequest"}
        "401": {$ref: "#/components/responses/Unauthorized"}
        "403": {$ref: "#/components/responses/Forbidden"}
        "404": {$ref: "#/components/responses/NotFound"}
        "500": {$ref: "#/components/responses/InternalError"}
        "503":
          description: Pack builder unavailable
  /v1/packs/{packId}/versions:
    post:
      operationId: createPackVersion
      summary: Save the pack's next immutable version by adding and removing items
      security:
        - sessionCookie: []
      parameters:
        - {name: packId, in: path, required: true, schema: {type: string, format: uuid}}
        - name: X-CSRF-Token
          in: header
          required: true
          schema: {type: string, minLength: 43, maxLength: 43}
          description: Must match the __Host-leorna-csrf cookie from the current browser login.
      requestBody:
        required: true
        content:
          application/json:
            schema: {$ref: "#/components/schemas/PackVersionChange"}
      responses:
        "201":
          description: The new version, numbered after the parent
          content:
            application/json:
              schema: {$ref: "#/components/schemas/PackVersionDetail"}
        "400": {$ref: "#/components/responses/InvalidRequest"}
        "401": {$ref: "#/components/responses/Unauthorized"}
        "403": {$ref: "#/components/responses/Forbidden"}
        "404": {$ref: "#/components/responses/NotFound"}
        "409": {$ref: "#/components/responses/Conflict"}
        "500": {$ref: "#/components/responses/InternalError"}
        "503":
          description: Pack builder unavailable
```

Append these schemas at the end of `components.schemas`. **Never use the inline `kind: {type: string, enum: […]}` form here** (see Current context):

```yaml
    PackItemKind:
      type: string
      enum: [skill, agent, config, mcp_template, prompt]
    PackItemKey:
      type: object
      additionalProperties: false
      required: [kind, name]
      properties:
        kind: {$ref: "#/components/schemas/PackItemKind"}
        name: {type: string, minLength: 1, maxLength: 200}
    PackCreate:
      type: object
      additionalProperties: false
      required: [name, libraryItemIds]
      properties:
        name: {type: string, minLength: 1, maxLength: 200}
        libraryItemIds:
          type: array
          minItems: 1
          maxItems: 500
          uniqueItems: true
          items: {type: string, format: uuid}
    PackVersionChange:
      type: object
      additionalProperties: false
      required: [parentVersion]
      description: >-
        One save's edit to the pack's latest version: removals apply first, then additions.
        Later stories add optional fields (for example an item order); send only the fields you use.
      properties:
        parentVersion:
          type: string
          minLength: 1
          maxLength: 50
          description: Must be the pack's latest version id, or the save is refused with 409.
        addLibraryItemIds:
          type: array
          maxItems: 500
          uniqueItems: true
          items: {type: string, format: uuid}
        removeItems:
          type: array
          maxItems: 500
          items: {$ref: "#/components/schemas/PackItemKey"}
    PackSummary:
      type: object
      additionalProperties: false
      required: [id, name, latestNumber, latestVersion, createdAt, updatedAt]
      properties:
        id: {type: string, format: uuid}
        name: {type: string}
        latestNumber: {type: integer, minimum: 1}
        latestVersion: {type: string}
        createdAt: {type: string, format: date-time}
        updatedAt: {type: string, format: date-time}
    PackVersionDetail:
      type: object
      additionalProperties: false
      required: [packId, name, number, version, parentVersion, createdAt, items]
      properties:
        packId: {type: string, format: uuid}
        name: {type: string}
        number: {type: integer, minimum: 1}
        version: {type: string, description: Version id that assignments and Sync use}
        parentVersion: {type: string, description: Version id this version was saved from; empty for version 1}
        createdAt: {type: string, format: date-time}
        items:
          type: array
          items: {$ref: "#/components/schemas/PackVersionItem"}
    PackVersionItem:
      type: object
      additionalProperties: false
      required: [id, kind, name, version, description]
      properties:
        id: {type: string, format: uuid}
        kind: {$ref: "#/components/schemas/PackItemKind"}
        name: {type: string}
        version: {type: string}
        description: {type: string}
```

Then:
- `make generate` regenerates `packages/contracts/controlplane.gen.go`.
- Add four stubs to `packages/contracts/roundtrip_test.go`, in the style of the existing ones: `ListPacks`, `CreatePack`, `GetPack` and `CreatePackVersion` each return `nil, errors.New("unexpected <Op> call")`.
- Extend `TestContractItemKindsMatchPackKinds`:
  - keep its `len(matches) != 2` check;
  - add `regexp.MustCompile("(?m)^    PackItemKind:\n      type: string\n      enum: \\[([^\\]]*)\\]\\s*$")`;
  - require one match and compare its set to `pack.Kinds()` exactly as for the other two;
  - check `contracts.PackItemKind(kind).Valid()` for every domain kind.

Contract classification (`api-contract-drift-guard`): **additive only**. There are 4 new operations and 7 new schemas; nothing existing changes, and no client-facing `/v1/client/*` path is touched. Keep the diff artifact as `evidence/86bcm901w/contract-diff-<sha7>.txt`, produced by `git diff 1ee7157 -- contracts/control-plane.openapi.yaml`.

### D5. Web: `internal/web/pack_builder.go` (new) plus small edits

**Wiring and routes:**
- `handler.go` adds the field `packBuilder packBuilder` to `Handler`.
- Add these routes next to the library routes:

```go
routes.Handle("POST /admin/library/packs", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.packBuilderCreateForm)), false))
routes.Handle("GET /admin/library/packs/{packId}", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryPackView)), true))
routes.Handle("POST /admin/library/packs/{packId}/versions", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.packBuilderSaveForm)), false))
for _, pattern := range []string{"GET /v1/packs", "POST /v1/packs", "GET /v1/packs/{packId}", "POST /v1/packs/{packId}/versions"} {
	routes.Handle(pattern, handler.requireSession(handler.requireAdmin(handler.packGuard(api)), false))
}
```

- `cmd/control-plane/main.go`: add `application.SetPackBuilder(pack.NewBuilderService(repository))` **after `application.SetBundleServer(repository)`** (`main.go:186`). PR #94 rewrites the `SetPackVersions` line right after `SetLibrary`, so a line inserted there would conflict; two unchanged lines (`SetPackAssignments`, `SetBundleServer`) keep the hunks apart.

**`internal/web/pack_builder.go` contents:**
- `const maxPackRequestBytes = 64 << 10`. 500 ticked items plus 500 `shown` markers come to about 45 KiB, and a JSON body to about 20 KiB (GO-HTTP-002).
- `type packBuilder interface { CreatePack(...) ; SaveVersion(...) ; Packs(...) ; Pack(...) }`, with the same signatures as `BuilderService`. Add `func (handler *Handler) SetPackBuilder(builder packBuilder)`.
- `packGuard(next)` copies `teamGuard`:
  - on non-GET, the `X-CSRF-Token` header must equal the CSRF cookie (`subtle.ConstantTimeCompare`, `validBrowserToken`), else 403 `CSRF_REJECTED`;
  - `handler.packBuilder == nil` gives 503 `PACK_BUILDER_UNAVAILABLE`;
  - then `http.MaxBytesReader(w, r.Body, maxPackRequestBytes)`.
- `packJSON(w, r, value)` copies `projectJSON` (`projects.go:47-65`): `application/json` only, `DisallowUnknownFields`, no trailing data. Errors go to `writePackBuilderError(..., org.ErrInvalid)`.

**JSON operations** (generated `ServerInterface`):
- `ListPacks(w, r)` returns 200 `[]contracts.PackSummary`.
- `CreatePack(w, r, _ contracts.CreatePackParams)` decodes `contracts.PackCreate`, calls `packBuilder.CreatePack(ctx, teamActor(r), body.Name, ids)` and returns 201 `contracts.PackVersionDetail`.
- `GetPack(w, r, packId openapi_types.UUID)` returns 200.
- `CreatePackVersion(w, r, packId openapi_types.UUID, _ contracts.CreatePackVersionParams)` decodes `contracts.PackVersionChange`. Optional arrays arrive as pointers; treat nil as empty. `removeItems` maps to `pack.ItemKey{Kind: pack.Kind(k.Kind), Name: k.Name}`. Returns 201.
- Successful responses set `Cache-Control: no-store`, `X-Content-Type-Options: nosniff` and JSON, like `teamResult`.
- `packVersionDetail(built)` maps to the contract type. A `uuid.Parse` error on a stored id gives 500.

**`writePackBuilderError` mapping** (check the specific errors first):

| Error | Status | Code |
| --- | --- | --- |
| `pack.ErrNameTaken` | 409 | `PACK_NAME_TAKEN` |
| `pack.ErrStaleParent` | 409 | `PACK_CHANGED` |
| `org.ErrInvalid` | 400 | `INVALID_PACK` |
| `org.ErrForbidden` | 403 | `FORBIDDEN` |
| `store.ErrNotFound` | 404 | `NOT_FOUND` |
| anything else | 500 | `PACK_FAILED` (log the cause) |

The route's `requireAdmin` answers members with 403 `ADMIN_REQUIRED`, which is distinct from the store's `FORBIDDEN`. That lets the tests tell the two guards apart.

**Console (library page):**
- `libraryView` becomes `handler.renderLibrary(w, r, http.StatusOK, libraryState{})`, and its current body moves into `renderLibrary(w, r, status, state)`. The behaviour stays the same, and `newLibraryPage(entries, filter)` keeps its signature.
- `type libraryState struct { pack *pack.BuiltVersion; ticked []string; name, alert string }` holds the pack being edited (nil means create mode) and, after a refused save, the ticks, typed name and alert to keep.
- `renderLibrary` builds the page as today, including filter errors (400). Then, if `handler.packBuilder != nil` **and** the CSRF cookie is valid, it sets `page.Builder`. If the cookie is missing, the page renders exactly as before, without builder controls (no new 403 on a GET).
  - Create mode: `Action "/admin/library/packs"`, `FilterAction "/admin/library"`.
  - Edit mode: `Action "/admin/library/packs/<id>/versions"`, `FilterAction "/admin/library/packs/<id>"`, plus the pack fields: name, number, version id, saved time, parent number, next number, and whether it has scripts.
  - Also: `Packs` (from `packBuilder.Packs`), `OtherItems` (pack items whose kind and name match no library entry), `CSRF`, `Name`, `Error`.
- Rows: `libraryRow` gains `Kind pack.Kind`, `Ticked bool` and `InPackVersion string`. With `state.ticked != nil`, `Ticked` means the id is in that list; in edit mode, it means the row's kind and name are in the pack. `InPackVersion` is the pack's version of that item.
- `libraryPackView(w, r)`: if `packBuilder == nil`, 503. It calls `Pack(ctx, actor, r.PathValue("packId"))` (errors go to `writePackBuilderError`, so an unknown, malformed or foreign id gives 404), then `renderLibrary(..., libraryState{pack: &built})`.
- `packBuilderCreateForm(w, r)`:
  - `packBuilder == nil || libraryCatalog == nil` gives 503;
  - `adminFormLimit(w, r, maxPackRequestBytes)`;
  - `len(form["name"]) != 1` gives 400 `INVALID_REQUEST`;
  - a blank name re-renders 400 with "Name the pack.", and no `item` re-renders 400 with "Tick at least one item.";
  - otherwise it calls `CreatePack(ctx, principal, name, form["item"])`. Success gives 303 to `/admin/library/packs/<packId>` with `Cache-Control: no-store`. The id comes from the server, so this is not an open redirect.
  - Errors go through `packFormAlert`. Invalid or conflict re-renders the page with that status, the alert, the typed name and the ticks kept; anything else gets the JSON problem.
- `packBuilderSaveForm(w, r)`:
  - `adminFormLimit`, then `current := Pack(packId)` (404 problem if missing);
  - if `form.Get("parent_version") != current.Version.Version`, re-render the **latest** version with 409 and "This pack has a newer version (version N). Review the ticks and save again.";
  - load entries with `libraryCatalog.ListLibraryItems` and run `ticksToChange`. An error re-renders 400 with "The form no longer matches the library. Reload the page.";
  - an empty change re-renders 400 with "Nothing changed: tick or untick at least one item, then save.";
  - otherwise call `SaveVersion(ctx, principal, packID, parent, add, remove)`. Success gives 303 to `/admin/library/packs/<packId>`; errors go through `packFormAlert`.
  - The handler's parent check is only a hint for the message. The store's check under the row lock is the one that counts.
- The pure function, unit-tested:

```go
// ticksToChange turns the edit form into a change against the pack's items.
// Only rows the page showed count: a shown row that is unticked and in the
// pack is removed; a ticked row not in the pack is added; anything else stays.
// Every shown or ticked id must be a listed library entry, every ticked id
// must also be shown, and no id may repeat.
func ticksToChange(current []pack.Item, entries map[string]library.Entry, shown, ticked []string) (add []string, remove []pack.ItemKey, err error)
```

- `packFormAlert(err) (status int, message string, ok bool)`:
  - `ErrNameTaken`: 409, "A pack with this name already exists. Choose another name."
  - `ErrStaleParent`: 409, the newer-version message.
  - `org.ErrInvalid`: 400, "The pack could not be saved: it needs a name of up to 200 characters, at least one item, and one version of each item."
  - Anything else: `ok=false`.
- `cloud_plan.go`: `adminForm(w, r)` becomes `return handler.adminFormLimit(w, r, maxFormBytes)`. `adminFormLimit(w, r, limit int64)` holds today's body with `limit` in place of `maxFormBytes`, so other callers see no change.

**Template edits in `libraryTemplate` (`library.go:217-251`):**

Right after the lede paragraph:

```html
  {{with .Builder}}
  <section class="builder" aria-labelledby="builder-title">
    {{if .Editing}}
    <h2 id="builder-title">Editing {{.PackName}} · <span id="pack-version-heading">version {{.Number}}</span></h2>
    <p class="muted">Saved {{.SavedAt}}{{if .ParentNumber}} from version {{.ParentNumber}}{{end}}. Version id <code>{{.Version}}</code>. Tick items to add and untick items to remove, then save: that creates version {{.NextNumber}} and leaves this one unchanged. Teams keep their assigned version until you assign the new one on <a href="/admin/packs/assignments">Assignments</a>.</p>
    {{if .OtherItems}}<p class="muted">{{.OtherItems}} item(s) in this pack are not in the library and stay as they are.</p>{{end}}
    {{if .HasScripts}}<p class="muted">This version has scripts: review and approve them on <a href="/admin/packs/versions?version={{.Version | urlquery}}">Pack Versions</a> before assigning it.</p>{{end}}
    {{else}}
    <h2 id="builder-title">Build a pack</h2>
    <p class="muted">Tick the items to include, name the pack, then create it. It is saved as version 1 with exactly the ticked items.</p>
    {{end}}
    {{if .Error}}<p role="alert" class="alert" id="builder-error">{{.Error}}</p>{{end}}
    <form id="pack-builder" method="post" action="{{.Action}}">
      <input type="hidden" name="csrfToken" value="{{.CSRF}}">
      {{if .Editing}}<input type="hidden" name="parent_version" value="{{.Version}}">
      <button type="submit" id="save-version">Save as version {{.NextNumber}}</button>{{else}}
      <label>Pack name <input type="text" id="pack-name" name="name" value="{{.Name}}" maxlength="200" required></label>
      <button type="submit" id="create-pack">Create pack</button>{{end}}
    </form>
    {{if .Packs}}<p class="muted" id="your-packs">Your packs: {{range $i, $p := .Packs}}{{if $i}} · {{end}}<a href="/admin/library/packs/{{$p.ID}}">{{$p.Name}} (version {{$p.LatestNumber}})</a>{{end}}{{if .Editing}} · <a href="/admin/library">Start a new pack</a>{{end}}</p>{{end}}
  </section>
  {{end}}
```

Other template changes:
- Filter form: `action="{{if .Builder}}{{.Builder.FilterAction}}{{else}}/admin/library{{end}}"`. The "Clear filters" links use the same expression. In create mode this still renders exactly `<form class="filters" method="get" action="/admin/library"`, which the existing test asserts.
- Table header: prepend `{{if .Builder}}<th scope="col">Include</th>{{end}}`.
- Row: insert the cell **first**:

```html
{{if $.Builder}}<td><input type="checkbox" name="item" value="{{.ID}}" form="pack-builder" aria-label="Include {{.Name}}"{{if .Ticked}} checked{{end}}>{{if $.Builder.Editing}}<input type="hidden" name="shown" value="{{.ID}}" form="pack-builder">{{end}}{{if .InPackVersion}}<span class="chip">in pack{{if ne .InPackVersion .Version}} ({{.InPackVersion}}){{end}}</span>{{end}}</td>{{end}}
```

- Append to `libraryCSS`: `.builder{margin:1rem 0;padding:1rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem}`.

With `Builder == nil` (any handler without `SetPackBuilder`, as in every existing library test) the page is byte-for-byte today's markup apart from the shared CSS. `TestLibraryPageIntroNamesEveryKind` keeps passing.

### D6. Auth, tenant and input boundaries

| Boundary | Enforced by |
| --- | --- |
| Signed in | `requireSession`: HTML GET → 302 to sign-in, JSON and POST → 401 `AUTH_REQUIRED` |
| Admin | Route `requireAdmin` (403 `ADMIN_REQUIRED`), then `beginOrg(…, true)` inside every write transaction (403 `FORBIDDEN` if demoted mid-request) |
| CSRF | Forms: `csrfToken` field = cookie (`adminFormLimit`). JSON: `X-CSRF-Token` header = cookie (`packGuard`). Both 403 `CSRF_REJECTED` |
| Tenant | Every lineage and version query keyed by `actor.TenantID`. Another tenant's pack → 404, never 403. Composite FK `(tenant_id, pack_id)` makes a cross-tenant link impossible in the database |
| Body size | 64 KiB on both entry points; JSON rejects unknown fields and trailing data |
| Output | `html/template` only; ids in links are server-made UUIDs; no item body is ever written to the audit record |
| SQL | Parameterized only |

### D7. Audit record (AC3), reusing `audit_records` through `appendAudit` in the same transaction

| Field | `pack.create` | `pack.version.create` |
| --- | --- | --- |
| `actor` | `actor.UserID` | `actor.UserID` |
| `action` | `pack.create` | `pack.version.create` |
| `target` | pack id (lineage id), so `/admin/audit?target=<packId>` is the pack's history | same |
| `before_value` | `null` | `{"version": <parent version id>, "number": n-1, "itemCount": k}` |
| `after_value` | `{"packId","name","version","number":1,"parentVersion":"","itemCount", "diff":{"added":[all items],"removed":[],"changed":[]}}` | the same keys with `number: n`, `parentVersion: <parent id>` and the diff against the parent |

Each diff entry is `{"kind","name","version"}`; changed entries also carry `"previousVersion"`. A failed audit insert rolls back the whole save, and the AC3 test forces that.

### D8. Immutability (AC2)

Three layers:
1. No code path updates or deletes `pack_versions` or `pack_version_items`.
2. `ApplyChange` copies the parent's items and never writes them back.
3. Migration 23's triggers refuse UPDATE and DELETE with SQLSTATE 42501, the same pattern as `audit_records`.

### D9. Item order, the sync output, and the line with 86bcm901y

**This card:**
- Removes *library* items from a pack on the control plane only: unticking on the library page, or `removeItems` in the API. The result is a new immutable version without them, and the parent stays untouched.
- Item order: not stored and not changed. Versions list items by kind, then name. `ApplyChange` keeps the parent's order and appends added items, but the store doesn't keep that order. The API has no order field.
- Sync output: unchanged. A new version is **not** assigned automatically, so engineers get nothing new until an admin assigns it on Assignments. After assignment, the bundle and lockfile simply lack the removed item, since both are sorted by path.

**86bcm901y:**
- Reordering: a stored `position` on `pack_version_items` plus an optional `order` field on `PackVersionChange`.
- Removing any item, including items that didn't come from the library, for example from the version preview.
- What the desktop client does with the files of an item that disappeared from the bundle (remove or flag, consistent with the lockfile). That is client repo work with its own sync integration test.

901y reuses `ApplyChange`, `SavePackVersion`, `pack.version.create` and its diff unchanged.

### D10. Extension points (keep the API easy to extend)

- **901y:** add optional fields to `PackVersionChange` and `pack.Change`. Old callers don't send them.
- **9026 (preview and diff before publishing):** a read-only `POST /v1/packs/{packId}/versions/preview` can run `ApplyChange` and `DiffItems` without writing; per-tool rendering is that story's part.
- **902a (quick start):** calls `BuilderService.CreatePack` with a starter set's library ids, then `AssignTeam`.
- **902d (many packs on one screen):** `GET /v1/packs` is already the list. Version history with authors and diffs can come from `GET /v1/audit?target=<packId>` (`pack.create` and `pack.version.create`), or from a new `GET /v1/packs/{packId}/versions`.
- **86bcm901b AC3 (prompt's required skills flagged as a dependency in the pack builder). Not built here; follow-up F1:**
  - **data:** `library.Item` (`internal/library/library.go`, struct at about `:70-84`) gains `Requires []string` (`"kind/name"` keys), loaded from each item's metadata and stored in a new `library_items.requires text[]` column;
  - **check:** a pure `pack.MissingRequirements(items []SeedItem, requires map[ItemKey][]ItemKey) []Requirement`, called in `internal/store/postgres/pack_builder.go` `CreatePack` and `SavePackVersion` right after `ApplyChange` (or `loadLibraryItems` for create), before the insert;
  - **API:** an optional `dependencyWarnings` array on `PackVersionDetail` (additive), plus a "needs: skill X" chip in the library page's Include cell;
  - **flag vs block:** warning only (flag), unless the team decides to block.

### D11. OpenAPI and the client

- **The spec changes:** additive, as in D4.
- **Client regeneration: not required.** The client's `make contracts-check` compares the client's own snapshot with its own generated code. It keeps passing, and the desktop never calls these admin endpoints. Copying the new spec into the client later is optional: it adds unused types and client methods, and its `TestContractItemKindsAreAcceptedBySync` still counts 2 inline kind enums because D4 keeps the new ones in `PackItemKind` (follow-up F3).
- No cross-repo Go imports (`scripts/verify-workspace.sh`).

## Tasks (builder, test-first)

Common variables (adjust `SCR` to your scratchpad):

```bash
WT=~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack
BASE=1ee7157f5dfeb24ddf2df7e3bb5363833385d50d
SCR=<scratchpad>/86bcm901w-builder        # mkdir "$SCR" (no -p)
EVID=~/.hermes/plans/leorna/evidence/86bcm901w
TOOLS=$HOME/.local/leorna-toolchain     # shared with 901a's plan (Q3-A)
GITLEAKS_BIN=/usr/local/bin/gitleaks    # 8.30.1, CI's version, already installed
export PATH="$TOOLS/go/bin:$TOOLS/bin:$PATH" GOTOOLCHAIN=local
export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901w_test?sslmode=disable'
export LEORNA_TEST_GITLEAKS_BIN="$GITLEAKS_BIN"
```

Never print the DB URL in a capture; it lives inside scripts only. Never touch `.claude/worktrees/86bcm901{a,b,j}-*`, their branches, their `leorna_86bcm901{a,b,j}_*` databases or their evidence folders.

### B0. Worktree and environment check (stop conditions)

1. `git -C "$WT" status --porcelain` is empty, `git -C "$WT" rev-parse HEAD` = `$BASE`, and the branch is `feat/86bcm901w-create-pack`. Otherwise stop and report.
2. Run the HTTPS fetch through gh (the `leorna` skill, step 7.1). If GitHub `main` moved past `$BASE`:
   - record the new SHA;
   - list whether the new commits touch any file this plan edits (`git diff --name-only $BASE origin/main`);
   - run `git -C "$WT" merge --ff-only origin/main` (the branch has no commits yet), and use the new SHA as `BASE` from here on.
   If PR #94 has merged, read its final `handler.go`, `main.go` and `internal/pack/README.md` first, so your edits sit beside its lines.
3. **Tools (Q3-A):** under `flock "$TOOLS/.install.lock"`, install whatever is missing. Reuse anything already installed whose version matches.
   - Go 1.27.3: `https://go.dev/dl/go1.27.3.linux-amd64.tar.gz`, sha256 from `https://go.dev/dl/?mode=json&include=all` (entry `go1.27.3.linux-amd64.tar.gz`). Extract to `$TOOLS/go`.
   - First stop with `blocked: make` unless `command -v make` succeeds (Justin's `sudo apt-get install -y make`; agents don't run sudo).
   - gitleaks: use `$GITLEAKS_BIN` if `"$GITLEAKS_BIN" version` prints `8.30.1`. Only if it doesn't: install CI's tarball checked with **CI's pinned sha256 `551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb`** (`ci.yml:69`) to `$TOOLS/bin/gitleaks` and set `GITLEAKS_BIN` to it.
   - golangci-lint 2.14.0: CI's URL and **pinned sha256 `ab90aeb7b066f92a33415b638a50fe5344bbb75a0d32ad30cc248d88f81032ab`** (`ci.yml:124`). Install to `$TOOLS/bin/golangci-lint`.
   - `GOBIN="$TOOLS/bin" go install golang.org/x/vuln/cmd/govulncheck@v1.7.0`.
   - Write `go version`, `gitleaks version`, `golangci-lint --version` and `govulncheck -version` into `$EVID/tools.txt`.
   - Don't edit `~/.bashrc` or any global PATH.
4. **Postgres:**
   - `docker version` must work (Q3-A's WSL integration). If it doesn't, stop and report `blocked: docker`.
   - If `docker ps -a --format '{{.Names}}'` has no `leorna-test-pg`: `docker run -d --name leorna-test-pg -e POSTGRES_USER=leorna -e POSTGRES_PASSWORD=ci-only-password -e POSTGRES_DB=leorna_test -p 127.0.0.1:5432:5432 mirror.gcr.io/library/postgres:18.6-alpine3.23@sha256:697c180dbf244d3ce4a8f4cbc0156cde840af055c1bf8b76aebe422a4822086f` (CI's pinned image, `ci.yml:48`). If `docker run` fails because the name is taken, a sibling created it first: reuse it. If it exists but is stopped, `docker start leorna-test-pg`.
   - Create **only** this story's DBs: `docker exec leorna-test-pg createdb -U leorna leorna_86bcm901w_test` and `leorna_86bcm901w_base_test`.
5. **Chrome:** `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu ~/.cache/chrome-for-testing/chrome-linux64/chrome --version` prints a version. Save that line in `tools.txt`.
6. **Base baseline** in a separate detached worktree:
   - `git -C "$WT" worktree add --detach "$SCR/base-${BASE:0:7}" "$BASE"`;
   - run there, with `LEORNA_TEST_DATABASE_URL` pointing at `leorna_86bcm901w_base_test`: `GOLANGCI_LINT="$TOOLS/bin/golangci-lint" GOVULNCHECK="$TOOLS/bin/govulncheck" GITLEAKS="$GITLEAKS_BIN" make check` and `bash ./scripts/test-module-add.sh`;
   - save the logs as `$EVID/baseline-${BASE:0:7}.txt` with `EXIT=` lines;
   - remove the worktree.
   Any failure there is pre-existing: record its identity and don't fix it.
7. **Before-state screenshot of the library page:** run E1 below against `$WT` at `$BASE` and capture `$EVID/before-library-${BASE:0:7}.png` of `/admin/library`.

### B1. Domain: `ApplyChange`, `DiffItems`, keys (`internal/pack/builder.go`, `internal/pack/builder_test.go`)

1. **RED.** Write the tests:
   - `TestApplyChangeRemovesThenAddsWithoutTouchingParent`: parent {a, b, c}, Remove {b}, Add {d} gives [a, c, d]. Afterwards the parent slice is deep-equal to a copy taken before the call.
   - `TestApplyChangeRejectsBadChanges`: table of empty change; removing a missing key; removing an invalid kind; the same key twice in Remove; Add of a still-present key; the same key twice in Add. Each returns `errors.Is(err, org.ErrInvalid)`.
   - `TestApplyChangeReplacesWhenRemovedAndAddedTogether`: remove a@1 and add a@2 gives [a@2].
   - `TestDiffItemsListsAddedRemovedChangedSorted`: unsorted input; check the three lists exactly, `previousVersion` on changed, `[]` (not nil) when empty, and that no body text appears in `json.Marshal(diff)`.
   Run `go test -count=1 -run 'ApplyChange|DiffItems' ./internal/pack/`. Expect `undefined: ApplyChange` (build failure) and save it as `$EVID/red-b1.log`.
2. **GREEN.** Add the D2 code down to `ApplyChange` (types, `Key`, `AsSeedItem`, `ItemRef`, `Diff`, `DiffItems`, `Change`, `ApplyChange`) and rerun: pass.
3. Commit: `feat(86bcm901w): apply and diff item changes for pack versions`.

### B2. Specs and `BuilderService` (same files)

1. **RED.** Tests:
   - `TestNewPackValidate` and `TestPackChangeValidate`: blank or over-200-rune name, blank version, 0 ids, 501 ids, a repeated id (case-insensitive), an empty change, 501 removals. Each is `org.ErrInvalid`.
   - `TestBuilderServiceRetriesAVersionCollisionOnce`: a fake `BuilderStore` returns `ErrVersionExists` once, then succeeds. Check two calls with two different version ids. A fake that always collides makes the service return `ErrVersionExists` after exactly 2 calls.
   - `TestBuilderServicePassesSpecsThrough`: the fake records `NewPack` and `PackChange` exactly.
   Run `go test -count=1 -run 'NewPackValidate|PackChangeValidate|BuilderService' ./internal/pack/`. Expect an undefined-symbol failure; save it as `red-b2.log`.
2. **GREEN.** Add the rest of D2. Run `go test -count=1 ./internal/pack/`: everything passes.
3. Commit: `feat(86bcm901w): pack builder service and specs`.

### B3. Migration 23 and immutability

1. **RED.** In `internal/store/postgres/store_test.go`:
   - add `"pack_lineages"` to **both** table lists in `TestMigrationRoundTrip`;
   - add `pack_lineages` to `resetDatabase`'s DROP list, and add `DROP FUNCTION IF EXISTS reject_pack_version_edit()` after `reject_audit_edit`.
   New `internal/store/postgres/pack_builder_test.go`, test `TestPackBuilderStoreWithPostgres`, subtest `saved_versions_are_immutable_in_the_database`:
   - create a version with `CreateVersion`;
   - check that `UPDATE pack_versions SET name='x' WHERE id=$1`, `UPDATE pack_version_items SET body='x' WHERE pack_version_id=$1`, `DELETE FROM pack_version_items WHERE pack_version_id=$1` and `DELETE FROM pack_versions WHERE id=$1` each fail with `*pgconn.PgError` Code `42501`;
   - the row is unchanged afterwards.
   Run `go test -count=1 -run 'TestMigrationRoundTrip|TestPackBuilderStoreWithPostgres' ./internal/store/postgres/`. Expect "table pack_lineages does not exist" and no error from the UPDATE. Save as `red-b3.log`.
2. **GREEN.** Add both migration files (D1). Rerun: pass. Also run `go test -count=1 -run 'TestPackVersionStore|TestEnsureSeedBase|TestPromptKind|TestAssign' ./internal/store/postgres/` to make sure the triggers break nothing.
3. Commit: `feat(86bcm901w): migration 23 adds packs and makes pack versions immutable`.

### B4. Store: `CreatePack` (+ `insertVersionItems` refactor)

1. **RED.** Subtests in `TestPackBuilderStoreWithPostgres`. Insert library rows directly with SQL, one of them a skill with two supporting files.
   - `create_writes_version_1_with_library_copies_and_audit`: the result has `Number` 1 and `ParentVersion ""`. Its items equal the library rows by kind, name, version, description, body and files, compared as a set sorted in Go. Exactly 1 `audit_records` row, `pack.create`.
   - `names_are_unique_per_tenant_ignoring_case`: `" backend PACK "` after `"Backend pack"` gives `ErrNameTaken`. The other tenant can create `"Backend pack"`.
   - `member_cannot_create`: `org.ErrForbidden`.
   - `unknown_or_malformed_library_item_is_invalid`: a random UUID, `"not-a-uuid"`, and two versions of one item are each `org.ErrInvalid`, and none writes a row.
   Save the failure as `red-b4.log`.
2. **GREEN.**
   - Refactor `CreateVersion` onto `insertVersionItems`, and rerun `TestPackVersionStore` (it must still pass).
   - Add `uniqueViolation`, `loadLibraryItems`, `insertBuiltVersion`, `packAuditRecord`/`auditAfter` and `CreatePack` (D3).
3. Commit: `feat(86bcm901w): store creates packs from library items with audit`.

### B5. Store: `SavePackVersion`, `GetPack`, `ListPacks`

1. **RED.** Subtests:
   - `save_numbers_the_next_version_from_the_latest`: v1 {A, C}, then add B and remove C, gives v2: number 2, `ParentVersion` = v1 id, items {A, B}. v1 is reread unchanged (same item ids and content). Audit `pack.version.create` with `before.number` 1 and diff added [B], removed [C].
   - `stale_parent_is_refused`: saving from v1 after v2 exists gives `ErrStaleParent` and nothing is written.
   - `concurrent_save_waits_for_the_lock_then_sees_the_newer_version`:
     - tx X runs `SELECT … FROM pack_lineages WHERE id=$1 FOR UPDATE`;
     - start `SavePackVersion` from v2 in a goroutine and `waitForLockWait(t, pool)`;
     - in tx X, insert a version row number 3 plus one item with direct SQL, then commit;
     - the goroutine returns `ErrStaleParent`.
   - `other_tenant_cannot_read_list_or_save`: `GetPack` and `SavePackVersion` give `store.ErrNotFound`, and `ListPacks` doesn't list it.
   - `member_cannot_save`: `org.ErrForbidden`; `member_can_read`: `GetPack` works for a member (the route adds the admin check).
   - `removing_every_item_is_invalid`: `org.ErrInvalid`.
   - `list_shows_latest_number_sorted_by_name`.
   Save the failure as `red-b5.log`.
2. **GREEN.** Add `latestBuiltVersion`, `SavePackVersion`, `GetPack` and `ListPacks` (D3). Run `go test -count=1 -run 'TestPackBuilderStoreWithPostgres|TestPackVersionStore|TestMigrationRoundTrip' ./internal/store/postgres/`: pass.
3. Commit: `feat(86bcm901w): store saves numbered pack versions under a row lock`.

### B6. OpenAPI and generated code

1. **RED.** Extend `TestContractItemKindsMatchPackKinds` (D4). `go test -count=1 -run TestContractItemKindsMatchPackKinds ./internal/web/` fails to build (`undefined: contracts.PackItemKind`). Save as `red-b6.log`.
2. **GREEN.**
   - Edit the spec (D4) and run `make generate`.
   - Add the 4 stubs to `packages/contracts/roundtrip_test.go`.
   - Add temporary method stubs on `*Handler`: `ListPacks`, `CreatePack`, `GetPack` and `CreatePackVersion` each return `handler.writeProblem(w, r, 501, "NOT_IMPLEMENTED", "Not implemented")`. That way `var _ contracts.ServerInterface = (*Handler)(nil)` builds, and the AC tests get a real 501 RED in B7.
   - Run `make contracts-check` (exit 0), `go test -count=1 ./packages/contracts/... ./internal/web/ -run 'Contract|RoundTrip'`, then `go build ./...`.
   - Save `git diff $BASE -- contracts/control-plane.openapi.yaml > $EVID/contract-diff-<sha7>.txt`.
3. Commit: `feat(86bcm901w): OpenAPI pack builder endpoints`.

### B7. AC tests first, then the JSON API

1. **RED.** Create `internal/web/pack_builder_test.go` with the 4 AC tests (spec in "AC tests" below) and their helpers.

   The fixture:

   ```go
   newPackBuilderFixture := func(t *testing.T) packFixture {
       return newPackFixture(t, func(h *Handler, s *postgres.Store) {
           h.SetLibrary(s)
           h.SetPackBuilder(pack.NewBuilderService(s))
           h.SetPackVersions(pack.NewVersionService(s))
       })
   }
   ```

   Extend `insertLibraryItems` (`library_test.go:35-59`) to insert the `files` column with `json.Marshal(append([]library.SupportFile{}, item.Files...))`; existing callers see no change.

   Run all four with `-run '^TestPackBuilderAC[1-4]'` (AC commands below). Expect `SetPackBuilder` undefined, or 501/404 once B6's stubs exist. Save the build-failure log as `red-ac-build.log`. Then add a one-line `SetPackBuilder` and the field, and save the status-mismatch RED as `red-ac-501.log`.
2. **GREEN (JSON).** Add `packGuard`, `packJSON`, `packResult`, `packVersionDetail`, `writePackBuilderError` and the four real operations (D5), plus the `/v1/packs` routes. The JSON subtests of AC1–AC4 now pass; the console subtests still fail with 404/405.
3. Commit: `feat(86bcm901w): admin JSON API to create packs and save versions`.

### B8. Library page: create, edit, ticks

1. **RED.** `internal/web/pack_builder_form_test.go`:
   - `TestTicksToChange`, table-driven: add only; remove only (shown and unticked); a ticked in-pack row is kept; a hidden (not shown) in-pack row is kept; an unknown id, a ticked-not-shown id and a repeated id are each `org.ErrInvalid`; nothing changed gives empty results.
   - `TestLibraryPageWithoutBuilderIsUnchanged`: render with no builder and assert there is no `pack-builder`, no `Include` header, and the filter action `/admin/library`.
   - `TestAdminFormLimitKeepsFourKiBForOtherForms`: a 5 KiB body to `/admin/teams` is still refused.
   The AC console subtests are already RED from B7.
2. **GREEN.**
   - `adminFormLimit`; `renderLibrary`/`libraryState`; the builder form data and row marking.
   - `libraryPackView`, `packBuilderCreateForm`, `packBuilderSaveForm`, `ticksToChange`, `packFormAlert`; the template and CSS (D5); the three console routes.
   - Then run `go test -count=1 -run 'TestPackBuilder|TestTicksToChange|TestLibrary|TestAdminFormLimit' ./internal/web/`: everything passes, including every existing `TestLibrary*`.
3. Commit: `feat(86bcm901w): tick library items to build a pack in the admin console`.

### B9. Wiring

Add `application.SetPackBuilder(pack.NewBuilderService(repository))` in `cmd/control-plane/main.go`, then run `go build ./cmd/control-plane`. Commit: `feat(86bcm901w): wire the pack builder`.

### B10. Mutation checks (`mutation-testing-discipline`)

Rules:
- Make each mutant with `go test -overlay` (a JSON map to a mutated copy in `$SCR`) for `.go` files.
- For the embedded SQL (M1, M9), edit the file in place, run, then `git checkout -- <file>` and confirm `git status --porcelain` is empty.
- Use a never-true comparison instead of `false` where a variable would become unused.
- Log every mutant to `$EVID/mutations-<sha7>.txt`: mutant, command, the test that failed, `EXIT`. Each must fail; restore and confirm green after.

| # | Mutant | Must be caught by |
| --- | --- | --- |
| M1 | Delete both `CREATE TRIGGER` statements in 000023 up | AC2 `saved_versions_cannot_be_edited_or_deleted`; store `saved_versions_are_immutable_in_the_database` |
| M2 | `SavePackVersion` lineage query without `tenant_id=$1 AND` | AC4 other-tenant rows; store `other_tenant_cannot_read_list_or_save` |
| M3 | `CreatePack`/`SavePackVersion`: `beginOrg(ctx, actor, false)` | store `member_cannot_create` / `member_cannot_save` |
| M4 | `/v1/packs` routes without `requireAdmin` | AC4 member JSON rows (expects `ADMIN_REQUIRED`) |
| M5 | Remove the `parent.Version.Version != spec.ParentVersion` check (and the form's hint) | AC4 outdated-version rows; store `stale_parent_is_refused` |
| M6 | `appendAudit` error ignored (`_ =`) in `CreatePack` | AC3 `a_failed_audit_write_saves_nothing` |
| M7 | `ApplyChange` skips `removing` (keeps every parent item) | AC2 console and JSON subtests |
| M8 | `DiffItems` appends to `Removed` where it should append to `Added` | AC3 diff subtests |
| M9 | Drop `pack_lineages_tenant_name` from 000023 up | AC4 duplicate-name rows |
| M10 | `packGuard` skips the header comparison | AC4 CSRF JSON rows |

### B11. Docs and records (see the section below), then the gates (see Gates), then the evidence (E1–E3)

### B12. Hand back at `ready-for-review`

The report includes:
- `git diff --stat $BASE..HEAD` and `git diff --name-only $BASE...HEAD`: no `.github/` paths;
- each commit's author is `Justin Issa <justin@leorna.com>`;
- the AC → test → log → screenshot table and the gate logs with their `EXIT` lines;
- the mutation table and deviations from this plan with reasons;
- `found_else`, `skill_lessons`, and one proposed status line for `leorna-workflow.md`, which the main session writes.

No push, PR or ClickUp post.

## AC tests (in `internal/web/pack_builder_test.go`)

Shared fixture data: `insertLibraryItems` with
- A `skill/code-review-checklist@1.0.0`
- B `agent/test-writer@2.0.0`
- C `skill/multi-file-demo@1.0.0` with files `references/guide.md` and `scripts/check.sh` (`Script: true`)
- D `mcp_template/github-mcp@2.0.0`
- E `skill/code-review-checklist@1.1.0`, a newer version of A. It is **not** in the shared data: the page lists only the newest version of each item, so E would replace A's row and break AC2's `shown` list. AC4 inserts E inside its repeated-item case, which runs last.

Item bodies carry a marker such as `BODY-MARKER-<name>` so the tests can prove bodies never reach audit records. Helpers:
- `packAPI(t, client, method, url, csrf, body string) *http.Response` sets `Content-Type: application/json` and `X-CSRF-Token`;
- `packForm(t, client, path string, values url.Values) *http.Response`;
- `decodeStrict[T]` uses `DisallowUnknownFields`;
- `countRows(t, pool)` returns counts of `pack_lineages`, `pack_versions WHERE tenant_id IS NOT NULL` and `audit_records WHERE action LIKE 'pack.%'`.

Item sets are compared as `kind/name@version` lists sorted in Go, never in database order.

### AC1 `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`
- `library_page_offers_a_checkbox_per_item_and_a_pack_name`: `GET /admin/library` (admin). Every `<tr class="item">` row has `<input type="checkbox" name="item" value="<its id>" form="pack-builder"`. The page has `<form id="pack-builder" method="post" action="/admin/library/packs">` with the CSRF field and `id="pack-name"`. `libraryNames(body)` is unchanged.
- `console_form_creates_version_1_with_exactly_the_ticked_items`:
  - POST `/admin/library/packs` with `csrfToken`, `name=Backend pack`, `item=A`, `item=C` gives 303 with `Location` matching `^/admin/library/packs/[0-9a-f-]{36}$`.
  - `repository.GetPack` gives `Number` 1 and `Version.ParentVersion` `""`. The items are exactly {A, C}: kind, name, version, description and body equal the library rows, and C's 2 files are equal byte for byte. B and D are absent.
  - GET `Location` gives 200: `id="pack-version-heading"` contains `version 1`, A's and C's checkboxes are `checked`, B's and D's aren't, and `parent_version` = the version id.
- `json_api_creates_version_1_with_exactly_the_listed_items`:
  - POST `/v1/packs` `{"name":"Frontend pack","libraryItemIds":[B]}` gives 201, decoded strictly into `contracts.PackVersionDetail`: `number` 1, `parentVersion` "", items [B].
  - `GET /v1/packs` lists both packs with `latestNumber` 1.
  - `GET /v1/packs/{id}` equals the 201 body.

### AC2 `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`
Setup: create "Backend pack" {A, C} through the service, and snapshot v1 by rereading it with `GetByVersion`.
- `console_form_adds_and_removes_library_items_as_version_2`:
  - GET `/admin/library/packs/{id}` shows A and C ticked, a `shown` field for every row, and `parent_version` = v1.
  - POST `/admin/library/packs/{id}/versions` with `parent_version=v1`, `shown`=A,B,C,D, `item`=A,B gives 303.
  - Now `Number` 2, `ParentVersion` = v1, items exactly {A, B}.
  - v1 reread is deep-equal to the snapshot (same item ids, content and files).
  - The page shows `version 2` and "from version 1".
- `json_api_adds_and_removes_as_version_3`: POST `/v1/packs/{id}/versions` `{"parentVersion":v2,"addLibraryItemIds":[C],"removeItems":[{"kind":"skill","name":"code-review-checklist"}]}` gives 201: `number` 3, `parentVersion` = v2, items {B, C}. v2 is unchanged.
- `saved_versions_cannot_be_edited_or_deleted`: on `fixture.pool`, check that `UPDATE pack_versions SET name='changed' WHERE id=v1.ID`, `UPDATE pack_version_items SET body='changed' WHERE pack_version_id=v1.ID`, `DELETE FROM pack_version_items WHERE pack_version_id=v1.ID` and `DELETE FROM pack_versions WHERE id=v1.ID` each fail with SQLSTATE 42501, and that v1 still equals the snapshot.
- `the_new_version_can_be_previewed_and_assigned_like_any_version`: `GET /admin/packs/versions?version=<v3>` gives 200 and lists B and C. This shows built versions plug into the existing preview, script approval and assignment flow.

### AC3 `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`
- `creating_a_pack_records_actor_action_and_diff`: console create {A, C}. `repository.ListAudit(scoped, admin, audit.Filter{Target: packID, Limit: 10})` returns exactly 1 record:
  - `Actor` = admin user id, `Action` `pack.create`, `Target` = pack id, `Before` = `null`;
  - `After` decodes strictly to a struct with exactly the keys `packId, name, version, number, parentVersion, itemCount, diff`, with `number` 1, `parentVersion` "", `itemCount` 2;
  - `diff.added` = [skill/code-review-checklist@1.0.0, skill/multi-file-demo@1.0.0], and `removed` and `changed` are `[]`;
  - the raw `After` contains no `BODY-MARKER` and no file body.
- `adding_and_removing_records_the_diff_against_the_parent`: console save to v2 as in AC2 gives exactly 2 records for the target. The newest has `Action` `pack.version.create`, `Before` = `{"version":v1,"number":1,"itemCount":2}`, `After.number` 2, `After.parentVersion` = v1, `diff.added` [agent/test-writer@2.0.0] and `diff.removed` [skill/multi-file-demo@1.0.0].
- `json_api_saves_are_audited_too`: one JSON create and one JSON save each add exactly one record with the right action.
- `a_failed_audit_write_saves_nothing`:
  - run `ALTER TABLE audit_records ADD CONSTRAINT pack_audit_blocked CHECK (action NOT LIKE 'pack.%') NOT VALID` on `fixture.pool`;
  - console create gives 500 `PACK_FAILED` with an `X-Trace-ID`, and `countRows` is unchanged (no lineage, no version);
  - JSON save gives 500, also with unchanged counts;
  - drop the constraint and retry: 303/201, with exactly one new record each.
- `the_audit_page_shows_the_pack_history`: `GET /admin/audit?target=<packId>` gives 200, with `<code>pack.create</code>` and `<code>pack.version.create</code>` in the rows.

### AC4 `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`

Table-driven. Each row checks the status, the problem code or the inline `role="alert"` text, and that `countRows` is unchanged. Setup: "Backend pack" v1 {A}, v2 {A, B} in tenant 1.

| Case | Request | Want |
| --- | --- | --- |
| no name (form) | POST create, `name=`, `item=A` | 400 + alert "Name the pack." and A still ticked |
| no items (form / JSON) | `name=X`, no `item` / `libraryItemIds: []` | 400 alert / 400 (generated binding or `INVALID_PACK`) |
| unknown library item | random UUID | 400 `INVALID_PACK` / 400 alert |
| malformed id (JSON) | `"libraryItemIds":["nope"]` | 400 |
| repeated item (runs last; inserts E first) | JSON with A and E (two versions of one item); JSON with A twice | 400 |
| name already used | `" backend PACK "` (form and JSON) | 409 alert "already exists" / 409 `PACK_NAME_TAKEN` |
| nothing changed (form) | edit with every row's tick unchanged | 400 alert "Nothing changed" |
| pack left empty | JSON remove A and B from v2 | 400 `INVALID_PACK` |
| outdated version | JSON and form with `parentVersion` = v1 | 409 `PACK_CHANGED` / 409 alert naming version 2 |
| member | form create, JSON create, JSON save, GET edit page | 403 `ADMIN_REQUIRED` |
| bad CSRF | form with a wrong `csrfToken`; JSON with a wrong or missing header | 403 `CSRF_REJECTED` |
| another company's pack | tenant 2 admin: `GET /v1/packs/{id}`, `GET /admin/library/packs/{id}`, `POST /v1/packs/{id}/versions`, form save | 404 `NOT_FOUND`; tenant 2's `GET /v1/packs` doesn't list it |
| malformed pack id | `GET /admin/library/packs/nope` → 404; `GET /v1/packs/nope` → 400 | as stated |
| signed out | `GET /admin/library/packs/{id}` → 302 to `/v1/auth/google/login`; `POST /v1/packs` → 401 `AUTH_REQUIRED` | as stated |
| strict JSON | unknown field `{"name":"x","libraryItemIds":[A],"extra":1}`; `text/plain` content type; a body over 64 KiB | 400 |

## Per-AC proof

Run everything from `$WT` with `LEORNA_TEST_DATABASE_URL` set to the role's own `_test` DB.

| AC | Command (runs only that test) | Why it fails on base `1ee7157` (old-code check) | Evidence |
| --- | --- | --- | --- |
| AC1 | `go test -v -count=1 -run '^TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres$' ./internal/web/` | Copying `internal/web/pack_builder_test.go` into a base worktree gives `[build failed]`, `undefined: (*Handler).SetPackBuilder` / `pack.NewBuilderService` / `contracts.PackVersionDetail`. Base has no pack builder, no `/admin/library/packs` and no `/v1/packs`. | `ac1-new-pack-version-1.png` (real admin console: edit view right after Create pack, "version 1", the ticked items checked) + `ac1-<sha7>.log`; extra `ac1-ticked-before-save.png` |
| AC2 | `go test -v -count=1 -run '^TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres$' ./internal/web/` | Same build failure; base can't add or remove library items as a numbered version, and has no immutability triggers. | `ac2-pack-version-2.png` (edit view after unticking and ticking: "version 2 … from version 1") + `ac2-<sha7>.log` |
| AC3 | `go test -v -count=1 -run '^TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres$' ./internal/web/` | Same build failure. On base, pack version saves write no audit record at all (`pack_versions.go:21-97`). | `ac3-audit-diff.png` (real `/admin/audit?target=<packId>` with `pack.create` and `pack.version.create` rows, actor, before/after diff) + `ac3-<sha7>.log` |
| AC4 | `go test -v -count=1 -run '^TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres$' ./internal/web/` | Same build failure (the routes and service don't exist). | `ac4-refused-saves-terminal.png` (rendered log of the test run: command, `--- PASS` lines, `EXIT=0`) + `ac4-<sha7>.log`; extra `ac4-duplicate-name-alert.png` (real page with the inline alert) |

None of these is `base_exempt`. For the verifier and auditor, per `ac-verification.md`, the base copy needs only `internal/web/pack_builder_test.go`. No new package is created, so no other test files are needed; the failure is `[build failed]` with `undefined:`.

## Evidence capture on this desktop (E1–E3)

There is no `osascript`, `screencapture`, PIL or ImageMagick here. Use the repo's own browser driver (chromedp v0.16.0, already in `go.mod`) and Chrome for Testing.

**E1. Run the real admin console locally** (dev mode, loopback only, throwaway DB; it adds no auth code):

```bash
docker exec leorna-test-pg createdb -U leorna leorna_86bcm901w_demo
go build -o "$SCR/control-plane" ./cmd/control-plane
python3 -I -c 'import json,sys; m=json.load(open(sys.argv[1])); m["server"]["address"]="127.0.0.1:18432"; json.dump(m, open(sys.argv[2],"w"), indent=2)' config/manifest.example.json "$SCR/manifest.json"
ss -ltn 'sport = :18432' | grep -q LISTEN && { echo "port busy: pick another"; exit 1; }
env LEORNA_MANIFEST_PATH="$SCR/manifest.json" \
    LEORNA_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901w_demo?sslmode=disable' \
    LEORNA_DEV_MODE=1 LEORNA_PUBLIC_BASE_URL='https://pending.leorna.invalid' \
    LEORNA_SECRET_ENCRYPTION_KEY="$(openssl rand -base64 32)" \
    "$SCR/control-plane" > "$SCR/demo-server.log" 2>&1 &
echo $! > "$SCR/demo-server.pid"
```

Run the last command as a background job and never print the key. Poll `curl -fsS http://127.0.0.1:18432/readyz` (≤ 60 s). The log must show the content library loaded and the dev-mode warning; if the binary refuses to start, keep the log and report. If B0's manifest key or the readiness path differs, read `config/manifest.example.json` and `internal/health` and adapt; don't change product code.

**E2. Drive and capture** with a scratch module `$SCR/capture`:
- `go.mod`: `module capture`, `require github.com/chromedp/chromedp v0.16.0`. Copy `$WT/go.sum`, then run `go mod tidy`.
- `main.go` takes flags `-base`, `-out`, `-chrome`, `-profile`, an allocator with `chromedp.ExecPath`, `chromedp.UserDataDir` (a `mktemp -d` profile in `$SCR`) and `chromedp.WindowSize(1440, 1800)`.
- Steps, saving each with `chromedp.FullScreenshot(&png, 100)` (PNG):
  1. `Navigate(base + "/dev/login?next=" + url.QueryEscape("/admin/library"))` and `WaitVisible("#pack-builder", chromedp.ByQuery)`.
  2. Tick `input[aria-label="Include code-review-checklist"]`, `…"Include commit-message-style"]`, `…"Include github-mcp"]` and `…"Include code-reviewer"]` (shipped items). Type `Backend team pack` into `#pack-name`. Save **`ac1-ticked-before-save.png`**.
  3. Click `#create-pack`, `WaitVisible("#pack-version-heading")`, read `Location` (the pack id is the last path segment). Save **`ac1-new-pack-version-1.png`**.
  4. Untick `github-mcp`, tick `test-driven-development`, click `#save-version`, wait until `#pack-version-heading` text is `version 2`. Save **`ac2-pack-version-2.png`**.
  5. `Navigate(base + "/admin/audit?target=" + packID)`. Save **`ac3-audit-diff.png`**. If the JSON cells make the page too wide to read, also save `ac3-audit-api-rendering.png` from a `<pre>` rendering of `GET /v1/audit?target=<packId>` (labelled "rendering" in EVIDENCE.md); the real page stays the AC's screenshot.
  6. `Navigate(base + "/admin/library")`, tick one item, type `backend TEAM pack`, click `#create-pack`. Save **`ac4-duplicate-name-alert.png`** (the 409 inline alert).
- Run it with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu go run . -base http://127.0.0.1:18432 -out "$EVID" -chrome ~/.cache/chrome-for-testing/chrome-linux64/chrome -profile "$(mktemp -d "$SCR/chrome-XXXX")"`. If Chrome refuses to start under its sandbox, add `chromedp.NoSandbox` for this local capture only and record that.
- The **before** shot (B0.7) uses the same program with only step 1 at base, saved as `before-library-1ee7157.png`.

**E3. Terminal captures:**
1. For each AC, run its command on the final head, writing `( set -o pipefail; echo "HEAD=$(git rev-parse HEAD)"; echo "\$ <command>"; <command>; echo "EXIT=$?" ) > "$EVID/ac<n>-<sha7>.log" 2>&1`.
2. Render the AC4 log as HTML: `python3 -I -c 'import html,sys; print("<!doctype html><meta charset=utf-8><style>body{background:#0b0f14;color:#e6edf3;font:13px/1.35 ui-monospace,monospace;margin:16px}</style><pre>"+html.escape(open(sys.argv[1]).read())+"</pre>")' "$EVID/ac4-<sha7>.log" > "$SCR/ac4.html"`.
3. Screenshot it: `LD_LIBRARY_PATH=… chrome --headless=new --disable-gpu --hide-scrollbars --user-data-dir="$(mktemp -d "$SCR/chrome-XXXX")" --window-size=1400,2400 --screenshot="$EVID/ac4-refused-saves-terminal.png" "file://$SCR/ac4.html"`.
4. Open the PNG and check that the first command line and `EXIT=0` are visible; if not, raise the height.
5. Label it "log rendering" in EVIDENCE.md.

**Clean up:** `kill "$(cat "$SCR/demo-server.pid")"`, confirm with `ps -p` that it's gone, then `docker exec leorna-test-pg dropdb -U leorna leorna_86bcm901w_demo` (only this DB).

**Privacy check before listing any file:** look at every PNG and grep every log. No server domain, URL bar, tenant ID, token, email, `/dev/login` text or DB password may show. Never capture `/admin`, which shows the email and tenant ID. The audit page shows actor and pack UUIDs from the throwaway demo DB, which is acceptable; note it.

**`$EVID/EVIDENCE.md`:**
- the head and base SHAs and one line per AC (AC → test → log → screenshot → what it shows);
- gate logs with the `EXIT=` you read in each;
- the mutation table and the demo run notes (port, DB created and dropped);
- the tools, and anything NOT VERIFIED with its reason.

## Gates (builder runs them on the final head; the verifier reruns them in a detached copy at the same SHA)

1. `GOLANGCI_LINT="$TOOLS/bin/golangci-lint" GOVULNCHECK="$TOOLS/bin/govulncheck" GITLEAKS="$GITLEAKS_BIN" make check` → `$EVID/gates-<sha7>.txt` with `EXIT=`.
   - `make check` = workspace, contracts-check, fmt, vet, test (race), lint, audit, secrets, library-check, build.
   - Echo `golangci-lint --version` and `govulncheck -version` first, from the same PATH.
   - Read the Make recipe to confirm the bound binaries are the ones used.
2. `bash ./scripts/test-module-add.sh` → `$EVID/module-add-<sha7>.txt`.
3. Prove the Postgres tests ran: run `go test -json -count=1 -run 'WithPostgres|TestMigrationRoundTrip|TestPackBuilderStoreWithPostgres' ./internal/web/ ./internal/store/postgres/ > $EVID/pg-<sha7>.json`. Read the stream per test (Action plus that test's own Output), not `-v` text.
   - Every `TestPackBuilder*` test and subtest passes, with no skip.
   - The only skips allowed are the known ones: TestTeamsAPIWithPostgres's two ClickHouse subtests without `LEORNA_TEST_CLICKHOUSE_URL`, and the tofu tests without `tofu`. Name each skip.
4. `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` (CI's story-gate step, after the `stories.json` edit).
5. Story-only secret scan: `gitleaks git --redact --log-opts="$BASE..HEAD"` → `$EVID/gitleaks-story-<sha7>.txt`.
   `make secrets` scans every local ref, including the sibling branches in this shared repo. If it fails on a commit that isn't ours, record it, and don't touch their branches.
6. Check that `git diff --name-only $BASE...HEAD` has no `.github/` path.

The repo has no JS or browser UI test suite. The "UI tests" are Go tests that assert on rendered HTML; they are the AC tests and `TestLibrary*`.

## Docs and records

- **Module README**, `internal/pack/README.md`: a new section "## Build a pack from the library (86bcm901w)", about 15 lines, covering:
  - what it does and the console path;
  - the 4 JSON endpoints;
  - pack = lineage with versions numbered 1, 2, …, the unique names (Q1), and that saves must start from the latest version (409);
  - immutability: no code path plus migration 23's triggers;
  - the audit actions and target and the diff shape, never bodies;
  - order not stored, sync unchanged until assigned, and the 901y line;
  - scripts need approval again in each new version;
  - rollback (lossy; prefer fix-forward);
  - the verification tests by name;
  - the demo steps.
  If #94 merged first, put the section after its "Creating a tenant item from scratch".
- **`internal/web/README.md`:** add to "Library catalog browser": the builder controls, `/admin/library/packs/{packId}`, both POST routes and the 64 KiB bound.
- **`internal/audit/README.md`:** one sentence listing `pack.create` and `pack.version.create` (target = pack id, diff without bodies).
- **OpenAPI:** `contracts/control-plane.openapi.yaml` plus the generated `packages/contracts/controlplane.gen.go`, plus the contract diff artifact.
- **`delivery/stories.json`:** append `"86bcm901w": {"name": "Create a pack by picking library items", "prs": {"LeornaAI/leorna-control-plane": []}}` as the **last** entry, as text (keep the file's formatting); check earlier entries unchanged by value.
- **GLOSSARY.md:** it doesn't exist at `1ee7157`; PR #94 adds it. If it exists on the base you build on, add a **Pack** entry ("a named lineage of immutable pack versions numbered 1, 2, 3…; built from content library items"). Otherwise skip it and leave follow-up F7.
- **Plan copy:** at "go" the main session runs `mkdir -p ~/.hermes/plans/leorna/evidence/86bcm901w && install -m 444 <this plan> ~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md`.
- **Evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm901w/`. The builder works at the root, the verifier only in `verifier/`, the auditor only in `auditor/`.
- **`leorna-workflow.md`:** agents don't edit memory. Each role's report ends with a one-line proposed status line, and the main session records it.
- **CI files:** no `.github/` change (default rule).

## Follow-ups (not in this story)

- **F1** (86bcm901b AC3): dependency flag at the plug-in point in D10: `library.Item.Requires`, then `library_items.requires`, then `pack.MissingRequirements`, called in `CreatePack`/`SavePackVersion` after `ApplyChange`, surfaced as `PackVersionDetail.dependencyWarnings` plus a chip on the library page.
- **F2** (86bcm901y): reorder (stored position plus an `order` field), remove non-library items, and client sync removal or flagging consistent with the lockfile (D9).
- **F3** (client, optional): copy the new spec into `leorna-client/api/` and run `make generate`. That adds unused types only; no code change.
- **F4:** `Fork`, `SaveEditedVersion`, add-library-item (and #94's `CreateItem`) create pack versions without an audit record. That is a pre-existing gap; see Other things found.
- **F5:** carry a script approval forward to a new version when the item's `ScriptContentSHA256` is unchanged. Today every add or remove forces re-approval of untouched script items.
- **F6** (902d): show "pack name · version N" on Assignments and Pack Versions for built packs, plus rename and delete.
- **F7:** add the GLOSSARY.md **Pack** entry once #94 lands.

## Risks (and how the hand-over resolves each)

**Files siblings or open PRs probably edit too**
- **`delivery/stories.json`:** 901a, 901b, 901j and PR #94 all append entries. At hand-over, take main's file unchanged and append this story's entry last as text, then check every earlier entry is unchanged by value (the `leorna` skill, step 7.2).
- **PR #94 (86bcm9021):**
  - `cmd/control-plane/main.go`: #94 rewrites `SetPackVersions`; this story's line goes after `SetBundleServer`, two unchanged lines away, so the merge should be clean;
  - `internal/web/handler.go`: a field next to `packVersions`, routes next to `/admin/packs/versions*`;
  - `internal/pack/README.md`: both add sections;
  - `GLOSSARY.md`: new there.

  Expect text conflicts in all of these. Keep both sides, then rerun this story's gates on the merged content. Our code is in new files wherever possible; this plan doesn't touch `version_service.go` or `pack_versions.go` in `internal/web`.
- **Migration number 23:** nothing open uses it today; #94 has no migration. If a sibling (901b, if it stores `requires`) or another PR merges a `000023_*` first, rename ours to the next free number at hand-over. Only 1 and 2 are hash-pinned. Then rerun `TestMigrationRoundTrip`.
- **Library content** (`internal/library/content/**`, `content.lock.json`, `THIRD_PARTY_NOTICES.md`, `internal/library/README.md`, the 945u upstream records): 901a, 901b and 901j edit these. This story doesn't. Its AC tests use fixture library rows, so new shipped items don't change them. `TestLibraryShowsTheShippedLibraryWithPostgres` keeps working because the checkbox cell sits before the name cell.
- **OpenAPI spec:** the siblings are content stories and aren't expected to touch it; #94 says "No public OpenAPI change". If one does, merge both blocks and rerun `make contracts-check`.
- **`internal/web/library.go` / `library_test.go`:** not expected in the siblings. 901b might add a dependency chip only if Justin chooses to build F1 there.

**Environment and shared resources**
- **Environment (Q3):** without Docker, Go and the tools, no gate can run here. B0 stops with `blocked`.
- **Shared resources:**
  - `leorna-test-pg`: each story uses only its own DBs (`leorna_86bcm901w_{test,base_test,demo}`, reviewers `leorna_86bcm901w_review1_test` and so on); never drop anyone else's.
  - `$TOOLS`: the install runs under `flock`.
  - Demo port 18432: checked with `ss` first.
- **`make secrets` scans every local branch**, siblings' included; see Gates 5.

**Design**
- **Behaviour change for everyone:** the triggers make *all* pack versions undeletable and uneditable in the database, not just built ones. Nothing in the code does that today (grep-checked). A future "delete a pack" feature must change this deliberately.
- **`adminFormLimit` refactor:** `adminForm` keeps its 4 KiB bound; a test proves it.
- **pgx `[]string` → `uuid[]`:** the fallback is given in D3; the store test decides which is used.

## Assumptions (made openly; easy to change)

1. "Version 1" is the per-pack number shown to admins. The unique version id string stays the key that assignments, the bundle and Sync use.
2. A save must start from the pack's latest version, or it is refused with 409 and nothing is saved. Branching from an older version is not offered; it would silently drop another admin's change.
3. New versions are never assigned automatically.
4. Everything here is admin-only, reads included.
5. The JSON responses don't carry the diff (the audit record does).
6. Through the API, adding an item already in the pack is refused. Removing and adding it in one call replaces it, and the diff records that as "changed". The library page never sends that combination.
7. Ticks don't survive a filter change (filtering reloads the page). Filter first, then tick, or save in several versions.
8. Library item ids are the shared `library_items` row ids of this deployment.
9. Pack rename and delete are out of scope.

## Other things found (not fixed here)

- **P2:** pack versions made by `Fork`, `SaveEditedVersion` and add-library-item write no audit record (`internal/store/postgres/pack_versions.go:21-97` has no `appendAudit`; `internal/pack/version_service.go:40-60`). `internal/audit/README.md` says "Future domain mutation methods must call appendAudit inside their transaction." PR #94's `CreateItem` uses the same path.
- **P2 (environment):** this WSL desktop has no Go toolchain, no `make`, no Docker access in Ubuntu (Docker Desktop's WSL integration is off) and no test Postgres. Every Leorna story's gates are blocked here until fixed; this also hits 901a, 901b and 901j.
- **P3:** both repos' contract-kind tests require exactly 2 inline `kind: {type: string, enum: [...]}` lines (`internal/web/contract_kinds_test.go`, client `application/contract_kinds_test.go`). Any new schema written that way breaks them, even if the new enum is correct. This plan avoids it with a named `PackItemKind`.
- **P3:** every new version gets new item ids, so script approvals never carry over, even for unchanged items (`000022_multifile_items.up.sql` comment, `pack_versions.go:71`). See F5.
- **P3:** `GetLibraryItem` doesn't read `files` (`internal/store/postgres/library_catalog.go:73-75`), so the library item page can't show a multi-file skill's supporting files (scripts included) before an admin ticks it. This story reads library rows itself, so it is unaffected.

## Estimate and completion contract

- **Builder:** about 4–6 h of agent time (B0 environment 30–60 min, once Q3-A's click is done; B1–B9 about 3 h; mutations, docs, gates and evidence about 1.5 h).
- **Done** means:
  - AC1–AC4 each pass their named test on one head, with the old-code check failing on `1ee7157`;
  - one screenshot per AC, inspected;
  - `make check` and `test-module-add.sh` at `EXIT=0`;
  - M1–M10 killed;
  - the docs and records above written;
  - the worktree committed and clean.

  Then review → fix → review → fix → verifier → blind auditor → `ac-check.sh`, expected `ALL ACCEPTED` (no live ACs).
- **Never:** push, open a PR, merge, post to ClickUp, or touch the sibling stories' worktrees, branches, DBs or evidence.
