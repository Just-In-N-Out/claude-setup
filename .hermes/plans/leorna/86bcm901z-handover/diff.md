# 86bcm901z: stop and show (head `4904333`)

Branch `feat/86bcm901z-customise-shipped-item`, head `4904333a8fe0def527ad32603e115f2499c6cef8`, 19 commits on base `b65f797`. Local only: nothing pushed, no PR. The worktree is clean (`git status --porcelain` empty).

## Diff stat (`git diff --stat b65f797...HEAD`)

```
 GLOSSARY.md                                        |    4 +
 cmd/control-plane/main.go                          |    4 +
 contracts/control-plane.openapi.yaml               |    5 +-
 delivery/stories.json                              |    6 +
 internal/audit/README.md                           |    7 +
 internal/library/README.md                         |   72 ++
 internal/library/catalog.go                        |   12 +
 internal/pack/README.md                            |   10 +
 internal/pack/builder.go                           |   12 +-
 internal/store/postgres/library_variants.go        |  376 ++++++
 internal/store/postgres/library_variants_test.go   |  570 +++++++++
 .../migrations/000025_library_variants.down.sql    |    1 +
 .../migrations/000025_library_variants.up.sql      |   22 +
 internal/store/postgres/pack_builder.go            |   20 +-
 internal/store/postgres/store_test.go              |    6 +-
 internal/textdiff/textdiff.go                      |  303 +++++
 internal/textdiff/textdiff_test.go                 |  216 ++++
 internal/variant/draft.go                          |  158 +++
 internal/variant/service.go                        |  149 +++
 internal/variant/service_test.go                   |  272 +++++
 internal/variant/variant.go                        |  101 ++
 internal/variant/variant_test.go                   |  374 ++++++
 internal/web/README.md                             |   61 +-
 internal/web/handler.go                            |    7 +
 internal/web/item_create.go                        |   49 +-
 internal/web/item_create_integration_test.go       |  311 +++++
 internal/web/library.go                            |   65 +-
 internal/web/library_variants.go                   |  705 +++++++++++
 internal/web/library_variants_packs_test.go        |  264 +++++
 internal/web/library_variants_test.go              | 1220 ++++++++++++++++++++
 internal/web/pack_builder.go                       |    7 +-
 internal/web/pack_versions.go                      |   18 +-
 internal/web/pack_versions_test.go                 |  193 +++-
 packages/contracts/controlplane.gen.go             |   23 +-
 34 files changed, 5522 insertions(+), 101 deletions(-)
```

- `git diff --name-only b65f797...HEAD -- .github/` → **empty** (no CI exception was granted; none needed).
- No `CLAUDE.md` in the diff.
- The base is `b65f797` and GitHub `main` is now `8aa32a1`. `b65f797...HEAD` is the branch's own change; `origin/main...HEAD` gives the same list, because the merge base is still `b65f797`. The migration number changes to 27 when main is brought in (`integration.md`).
- Contract: description-only change to `createPack` and the two pack id lists (they accept company variant ids too). `packages/contracts/controlplane.gen.go` is the regenerated embedded spec. The client needs no change (no new field or route).

## Commits (`git log --oneline b65f797..HEAD`)

```
4904333 fix(86bcm901z): require supporting file boxes a refusal emptied
08c09b8 fix(86bcm901z): clear all typed text when the item editor finds a suspected secret
1e9e8fe fix(86bcm901z): clear all typed text when a variant save holds a suspected secret
b534978 fix(86bcm901z): leave an agent's customise rename out of "Your changes"
c5bd6be fix(86bcm901z): merge an agent variant against upstream renamed to the variant's name
99382cc feat(86bcm901z): show Customise under the item's facts with a wider name field
24334f9 docs(86bcm901z): document company variants
7a3087a feat(86bcm901z): wire company variants into the control plane
678739b docs(86bcm901z): pack id lists accept company variant ids
866fb88 test(86bcm901z): refused variant requests write nothing and stay in their tenant
48cdb22 feat(86bcm901z): tick, order, assign and sync a variant like a library item
282ecc2 feat(86bcm901z): show upstream updates with a diff; merge or ignore them
7a8f982 feat(86bcm901z): edit and delete a company variant
e9a7349 feat(86bcm901z): customise a shipped item from the library console
e43e4ed feat(86bcm901z): packs copy a company's own variants like library items
c2c406d feat(86bcm901z): customise, edit, merge, ignore and delete variants
426e4ee feat(86bcm901z): store company variants (migration 25)
0cdd140 feat(86bcm901z): variant domain: draft, versions and merge preview
747d71b feat(86bcm901z): add a bounded line diff and three-way merge
```

Pre-flight (read-only, this session):
- authors: 1 identity, Leorna OK;
- committers: 1 identity, Leorna OK;
- AI attribution lines in commit bodies: 0.

## Key hunks

**Migration (one new table, additive)**: `internal/store/postgres/migrations/000025_library_variants.up.sql` (27 after the bring-in):

```sql
CREATE TABLE library_variants (
 id uuid PRIMARY KEY,
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
 kind text NOT NULL CHECK (kind IN ('skill','agent','prompt')),
 name text NOT NULL CHECK (char_length(name) BETWEEN 1 AND 64 AND name ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
 version text NOT NULL CHECK (version ~ '^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'),
 description text NOT NULL CHECK (char_length(btrim(description)) BETWEEN 1 AND 2000),
 body text NOT NULL CHECK (octet_length(body) BETWEEN 1 AND 65536),
 files jsonb NOT NULL DEFAULT '[]'::jsonb CHECK (jsonb_typeof(files) = 'array'),
 upstream_item_id uuid NOT NULL REFERENCES library_items(id) ON DELETE RESTRICT,
 ignored_upstream_version text NULL CHECK (...semver...),
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now(),
 CONSTRAINT library_variants_tenant_kind_name UNIQUE (tenant_id, kind, name)
);
CREATE INDEX library_variants_upstream_item ON library_variants (upstream_item_id);
```
The down file is `DROP TABLE library_variants;`.

**Packs take a variant id wherever they take a library item id, tenant-keyed**: `internal/store/postgres/pack_builder.go`:

```go
-	items, err := loadLibraryItems(ctx, tx, spec.LibraryItemIDs)
+	items, err := loadCatalogItems(ctx, tx, actor.TenantID, spec.LibraryItemIDs)
...
-		`SELECT id::text,kind,name,version,description,body,files FROM library_items WHERE id = ANY($1::uuid[])`, ids)
+		`SELECT id::text,kind,name,version,description,body,files FROM library_items WHERE id = ANY($1::uuid[])
+		 UNION ALL
+		 SELECT id::text,kind,name,version,description,body,files FROM library_variants WHERE tenant_id = $2 AND id = ANY($1::uuid[])`, ids, tenantID)
```
Another company's variant id is refused exactly like an unknown id. Pack versions copy the content, so Move, Remove, assignment and Sync are unchanged.

**Admin-only routes** (`internal/web/handler.go`; every store write also re-checks the admin role inside its transaction through `beginOrg(ctx, actor, true)`):

```go
+	routes.Handle("POST /admin/library/items/{itemId}/customise", handler.requireSession(handler.requireAdmin(...libraryCustomiseForm)), false))
+	routes.Handle("GET /admin/library/variants/{variantId}", handler.requireSession(handler.requireAdmin(...variantView)), true))
+	routes.Handle("POST /admin/library/variants/{variantId}/edit", ...variantEditForm...)
+	routes.Handle("POST /admin/library/variants/{variantId}/merge", ...variantMergeForm...)
+	routes.Handle("POST /admin/library/variants/{variantId}/ignore", ...variantIgnoreForm...)
+	routes.Handle("POST /admin/library/variants/{variantId}/delete", ...variantDeleteForm...)
```

**Every save goes through the item editor's gate** (`cmd/control-plane/main.go`, `internal/variant/service.go`): `application.SetVariants(variant.NewService(repository, gate.NewGitleaks("gitleaks")))`. Customise, edit and merge run `itembuilder` validation plus `gate.CheckTenantItem` (renders for Claude Code, Codex and Cursor, plus gitleaks) before writing. Without gitleaks they answer 503 and save nothing.

**A forged tick of a clashing variant is refused** (`internal/web/pack_builder.go`; the entry is left out of the ticks map, so `ticksToChange` refuses the tick as invalid):

```go
+		// A company variant whose name a later release shipped has no
+		// checkbox, so a tick of it is a forged form (86bcm901z).
+		if entry.Variant != nil && entry.Variant.NameClash {
+			continue
+		}
```

**Item editor: Justin's folded-in fix** (`internal/web/item_create.go` create mode, `internal/web/pack_versions.go` edit mode). A suspected secret now clears every typed field, not just the one the scanner names first. A supporting-file box that a refusal emptied comes back `required`:

```go
-			switch secretIssue.Location {
-			case "main body":
-				in.Body = ""
-			case "description":
-				in.Description = ""
-			...
-			}
+			in.Body, in.Description, in.Files = "", "", nil
+			cleared = clearFileBodies(draftFiles)
```

## Gate results at `4904333` (from the verifier's and auditor's own logs)

| Gate | Result | Receipt |
| --- | --- | --- |
| `make check` (workspace, contracts-check, fmt, vet, `go test -race` with real PostgreSQL, lint, audit, secrets, library-check, build); CI's golangci-lint 2.14.0 and govulncheck v1.7.0 bound | **EXIT=0**: lint 0 issues in both modules; govulncheck no called vulnerability (the "1 vulnerability in modules you require" note predates the branch, which doesn't touch `go.mod`); gitleaks no leaks (522 commits); library-gate PASSED (0.8.0, 43 items) | `verifier/make-check-4904333.log`, `verifier/gates-summary-4904333.txt` |
| `bash ./scripts/test-module-add.sh` | **EXIT=0** | `verifier/module-add-4904333.log` |
| Postgres `go test -json` stream, read per test | **VERDICT OK**: 320 declared top-level tests, 318 passed, 347 subtests passed. The 4 skips are the allowed ones: `LEORNA_EVIDENCE_DIR`, `SCW_LIVE`, the two ClickHouse subtests. All 8 required story tests passed | `verifier/pg-summary-4904333.txt`, `verifier/pg-4904333.json` |
| gitleaks over the story (`b65f797..HEAD`, 19 commits) | **EXIT=0**, no leaks | `verifier/gitleaks-story-4904333.txt` |
| AC1–AC4 by name (verifier and auditor, each separately) | **EXIT=0, 0 skips** in both: AC1 7/7, AC2 5/5, AC3 8/8, AC4 14/14 subtests. On base `b65f797` each fails to build | `verifier/ac<n>-4904333.log`, `auditor/ac<n>-4904333.log`, `*/ac<n>-base-b65f797.log` |
| Mutation checks, overlays only, sources unchanged | verifier: 36 of 36 killed (34 clause and fix mutants V1a–V4n, R1-F1, R2-old, IE-create/edit, R3-markup, plus 2 re-ported); auditor: 16 of 16 killed (A1–A4) | `verifier/mutations-4904333.txt`, `verifier/mutations-4904333-v2.txt`, `auditor/mutants/` |
| Real migration fill (base binary fills, head applies 25, down, up) | rows unchanged through up, down, up. The base binary refuses to start on a database holding 25 ("applied migration 25 is missing from embedded migrations") | `verifier/migration-fill-4904333.log` |
| `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` (finisher, on an archive of `4904333`'s `scripts/` and `delivery/`) | 5 tests OK; `stories.json` valid, `86bcm901z` last | this session |
| `ac-check.sh --reviews` (main session) | `ALL ACCEPTED: 4 of 4 ACs on 4904333`; `REVIEWS CLEAN: review-4 at 4904333 is clean` | main session |

Not re-run on `4904333`: the production image build (`docker build --no-cache`, EXIT=0 on `99382cc`; no build input changed since). Hosted CI hasn't run (nothing pushed).

Small record note: the auditor's `ac.json` prose says AC4 "15/15 subtests"; its own log and the verifier's both show 14 subtests plus the top-level test. Use 14.
