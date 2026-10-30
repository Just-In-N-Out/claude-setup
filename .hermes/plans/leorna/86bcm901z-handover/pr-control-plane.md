## Summary

Lets an admin make a company copy of a shipped skill, agent or prompt, edit it, and keep it close to the original. "Customise for your company" on a shipped item's page creates a **company variant**: a tenant-owned row in a new `library_variants` table with its own name (prefilled `<name>-custom`), version 1.0.0, and a link to the exact library item version it came from. When a later control-plane release ships a newer version of that item, the Content library and the variant page show "Update available" with the upstream diff. The admin can **merge** it (a three-way line merge; where both sides changed the same lines nothing is saved until the admin resolves the conflict in a text box) or **ignore** that version (a newer release brings the notice back). Admins edit a variant's description and main text; supporting files follow upstream. Every save goes through the item editor's gate (item rules, per-tool renders, gitleaks). Inside packs a variant behaves exactly like a shipped item: it can be ticked, ordered, removed, assigned and synced, and the pack API's id lists accept its id. Pack versions copy its content, so editing or deleting a variant never changes a saved pack version. Configs and MCP templates can't be customised: their policy gate runs only on shipped content. This PR also includes a fix to the existing item editor that Justin added during review: a suspected secret now clears every typed field, not just the first one the scanner names.

ClickUp: [Customise a shipped item (company variant)](https://app.clickup.com/t/86bcm901z)

## Changes

- `internal/store/postgres/migrations/000027_library_variants.{up,down}.sql`: one new table, `library_variants`.
  - Tenant-owned.
  - Columns: kind (skill, agent or prompt), name, version, description, body, files, `upstream_item_id` → the `library_items` row it is based on, and `ignored_upstream_version`.
  - `UNIQUE (tenant_id, kind, name)`, `ON DELETE RESTRICT` on both foreign keys, and an index on `upstream_item_id`.
  - The down file drops the table.
  - (The branch wrote it as 25. Main's #101 and #102 took 25 and 26, so bringing main in renames the pair to 27 with the same SQL; see Assumptions.)
- `internal/store/postgres/library_variants.go`: `LibraryItem`, `CreateVariant`, `ListVariants`, `GetVariant`, `SaveVariant`, `IgnoreUpdate`, `DeleteVariant`.
  - Every read and write runs through `beginOrg`; writes re-check the admin role inside the transaction and filter by `tenant_id`.
  - "Update available" is computed on read: the newest stored row of the same kind and name, versions compared number by number.
  - Each write appends its audit record in the same transaction.
- `internal/store/postgres/pack_builder.go`: `loadLibraryItems` becomes `loadCatalogItems`. It reads `library_items` plus this company's own `library_variants` (`WHERE tenant_id = $2`), so another company's variant id is refused like an unknown id. Create and save-version both use it.
- `internal/textdiff/` (new, stdlib only):
  - `Diff`: a bounded line diff with three lines of context. A changed region over 2^20 line pairs becomes one replaced block.
  - `Merge3`: a three-way line merge with `<<<<<<< your variant` / `>>>>>>> upstream …` markers.
  - `HasConflictMarkers`.
- `internal/variant/` (new): the variant domain and service.
  - `Draft` copies an upstream version; an agent's frontmatter name becomes the variant's name.
  - `NextVersion` bumps the minor on every saved change (1.0.0 → 1.1.0).
  - `PreviewMerge` and `FileChanges` build the diff and merge views.
  - `Service`: Customise, Edit, Merge, Ignore and Delete. Each takes the version the admin saw (stale or unchanged saves are refused), and each save runs `itembuilder` validation plus `gate.CheckTenantItem`.
- `internal/library/catalog.go`: a catalog `Entry` can carry `Variant` (its upstream, any update version not ignored, and a name clash with a later shipped item).
- `internal/pack/builder.go`: comments only. The id lists take library item or variant ids.
- `internal/web/library_variants.go` (new), plus edits in `library.go`, `handler.go` and `pack_builder.go`:
  - the Content library lists the company's variants beside shipped items, with a "Company variant" chip and "Update available: X";
  - a shipped item's page gets "Customise for your company" (with the reason for configs and MCP templates);
  - the variant page `/admin/library/variants/{id}` shows lineage, "Your changes", the update notice with upstream's diff, Merge / Ignore, the conflict resolver, the editor, a bounded preview (#100's renderer) and Delete;
  - six admin-only routes;
  - a variant whose name a later release ships loses its checkbox, and a forged tick of it is refused.
- `internal/web/item_create.go`, `internal/web/pack_versions.go`: **the item-editor fix Justin folded in** (create and edit modes). A suspected-secret refusal clears the description, the main body and every supporting file's text, not only the field the scanner names first; paths stay. A supporting-file box a refusal emptied comes back `required`, with a note, so the browser won't send it back empty. Choosing an upload for that file lifts the requirement.
- `cmd/control-plane/main.go`: wires `variant.NewService(repository, gate.NewGitleaks("gitleaks"))`. Like the item editor, customise, edit and merge need gitleaks at runtime; without it they answer 503 and save nothing.
- `contracts/control-plane.openapi.yaml`, `packages/contracts/controlplane.gen.go`: description-only. `createPack` and the two pack id lists say they accept company variant ids. No new field or route, so the desktop client needs no change.
- Docs:
  - `internal/library/README.md`: a "Company variants" section (kinds, lineage, updates, diff, merge, ignore, editing, the gate, versions, deletion, names, migration and rollback, test names);
  - `internal/pack/README.md`: variants in packs;
  - `internal/web/README.md`: routes, statuses, the bounded preview, the item editor's clearing and `required` rule;
  - `internal/audit/README.md`: `library.variant.create|update|merge|ignore|delete`, which record keys and versions, never text;
  - `GLOSSARY.md`: "Company variant".
- Tests:
  - `internal/textdiff/textdiff_test.go`: 12 tests;
  - `internal/variant/variant_test.go` and `service_test.go`: 15 tests, including that every shipped skill, agent and prompt can be customised and that every shipped agent variant merges an upstream description change;
  - `internal/store/postgres/library_variants_test.go`: the store, an update appearing after the real library loader runs again, and the pack builder copying only the company's own variants;
  - `internal/web/library_variants_test.go` and `library_variants_packs_test.go`: AC1–AC4, edit, delete, the bounded preview, the agent rename and the name clash;
  - `internal/web/item_create_integration_test.go` and `pack_versions_test.go`: the item-editor fix;
  - `internal/store/postgres/store_test.go`: `library_variants` in `TestMigrationRoundTrip` and `resetDatabase`.
- `delivery/stories.json`: this story's entry, appended last. Its PR list stays empty until this PR exists.

## Test Plan

Everything below ran on head `4904333` on 2026-10-29 (base `b65f797`, GitHub `main` when the branch started). Two independent agents ran it: the pipeline's verifier and a blind AC auditor, each in its own detached copy with its own `_test` database.

- [x] `make check`, exit 0 (verifier):
  - workspace, contracts-check, fmt and vet;
  - `go test -race -count=1` on every package with real PostgreSQL;
  - lint: 0 issues in both modules (golangci-lint 2.14.0, as CI);
  - govulncheck v1.7.0: no called vulnerability. The "1 vulnerability in modules you require" note predates this branch, which doesn't touch `go.mod` or `go.sum`;
  - gitleaks: no leaks;
  - library gate PASSED (0.8.0, 43 items);
  - build.
- [x] `scripts/test-module-add.sh`: exit 0 (verifier).
- [x] Postgres tests (verifier): a `go test -json` stream over `internal/cloud/dbcheck`, `internal/store/postgres`, `internal/web` and `internal/variant`, read per test.
  - 320 declared top-level tests: 318 passed, 347 subtests passed, 0 failures.
  - The 4 skips are the accepted ones: the two ClickHouse subtests, `LEORNA_EVIDENCE_DIR` and `SCW_LIVE`. No skip names `LEORNA_TEST_DATABASE_URL`.
- [x] gitleaks over the branch's 19 commits: no leaks (verifier).
- [x] AC tests: the verifier and the auditor each ran them on `4904333`, 0 skips. Each also fails on base `b65f797` with the head's test files copied in: the build fails, because the variant package doesn't exist there.
  - [x] AC1 `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres` (7 subtests): pass
  - [x] AC2 `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres` (5 subtests): pass
  - [x] AC3 `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres` (8 subtests): pass
  - [x] AC4 `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres` (14 subtests): pass. Covered: member, signed out, bad CSRF, another company's variant, configs and MCP templates, names, stale and unchanged edits, five no-echo secret cases, merge or ignore with no newer upstream or after upstream moved on, unknown ids. Each case also checks that nothing was written.
- [x] `ac-check.sh` over the verifier's and the auditor's AC reports, with the review check: `ALL ACCEPTED: 4 of 4 ACs on 4904333`; `REVIEWS CLEAN: review-4 at 4904333 is clean`.
- [x] Real binaries in dev mode on loopback, own database, headless Chrome (verifier and auditor):
  - release A is `4904333` (`vcs.modified=false`). Customise `incident-postmortem` 1.1.0 → `incident-postmortem-acme` 1.0.0, "Based on incident-postmortem 1.1.0", listed in the library;
  - release B is the same head with `skill/incident-postmortem` bumped to 1.2.0 (never committed), restarted on the same database. Its startup logs "content library loaded … added 1". The library shows "Update available: 1.2.0"; the variant page shows upstream's diff, "Merging is clean" and Merge 1.2.0 / Ignore 1.2.0. After Merge, the variant is 1.2.0, based on 1.2.0, with the company's line kept;
  - a pack built from a shipped skill plus the variant lists both with Move and Remove;
  - a variant edit holding a fake GitHub token is refused with the rule named. The version stays 1.1.0, both boxes are empty, and the page HTML holds no part of the token;
  - a duplicate name is refused (409).
- [x] Mutation checks on `4904333`, overlays only (sources unchanged): verifier 36 of 36 killed; auditor 16 of 16 killed. They cover the tenant filters, the admin re-check, the version and upstream checks, the kind and shipped-name checks, the secret no-echo rule, conflict markers, the pack builder's variant ids and the item editor's `required` boxes.
- [x] Migration on real PostgreSQL (verifier). A database filled by the base binary (migrations 1–24, a tenant, the library, a pack) keeps every row through the head's up, the down file, and up again. The new table's constraints and foreign keys are present. The base binary then refuses to start on the migrated database ("applied migration 25 is missing from embedded migrations"); see Rollback.
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: 5 tests OK (finisher, on an archive of the head's `scripts/` and `delivery/`). `delivery/stories.json` is valid, with this story's entry last.
- [x] Scope: no `.github` path in `git diff --name-only b65f797...4904333`. All 19 commits are by the Leorna identity, with no AI attribution lines. No tracked `CLAUDE.md`.
- [ ] Not re-run on `4904333`: the production image build (`docker build --no-cache` exited 0 on `99382cc`; no build input changed since).
- [ ] Bringing main in: not done yet (Assumptions). A trial merge with GitHub `main` `8aa32a1` in a scratch copy, with no database, passed fmt, vet, build, the non-DB tests, lint, contracts-check and library-check. That is a prediction, not a gate. The gates and AC tests run again on the merged head before this PR is pushed.
- [ ] Hosted CI: not run yet. Nothing is pushed.

## Security, migration, rollback

- **Security:**
  - Every new route is admin-only (`requireSession` + `requireAdmin`; a member gets 403, AC4). Every store write re-checks the admin role inside its transaction (`beginOrg(ctx, actor, true)`).
  - Tenant isolation: every variant read and write filters by `tenant_id`, and so does the pack builder's id lookup. Another company's variant id behaves exactly like an unknown id: 404 on its page and its forms, refused in a pack (`INVALID_PACK`), and absent from that company's library. AC4 and `TestPackBuilderCopiesOnlyTheTenantsOwnVariantsWithPostgres` check this, and the mutants that drop each filter are killed.
  - The secret gate: customise, edit and merge run the item editor's gate (item rules, renders for Claude Code, Codex and Cursor, gitleaks) before anything is written. Without gitleaks they answer 503 and save nothing.
  - No echo: a refusal for a suspected secret clears every typed field on the variant page and in the item editor, so no part of the token is shown back (five AC4 cases and the item-editor tests; the token check reads the page HTML).
  - CSRF on every form. SQL is parameterized, pages are `html/template`, and the variant preview uses #100's bounded renderer; the unbounded preview stays for shipped content only. Audit records hold ids, names and versions, never text.
  - No auth bypass or dev-login change.
- **Migration:**
  - One new table, additive. No existing table or row changes; the fill test above shows every earlier row unchanged.
  - Its number becomes 27 when main is brought in (#101 took 25, #102 took 26). The SQL is the same as when it was 25.
  - GitHub `main` never had it, so no shared database ran it as 25. Only this story's own test databases did, and they are dropped.
- **Rollback:**
  - **Run the down migration first, then roll back the deploy.** The older binary refuses to start on a database that still records this migration ("applied migration N is missing from embedded migrations"; seen with the base binary, verifier's migration fill).
  - The down file drops `library_variants`, deleting every variant. Pack versions keep their copies, so teams keep syncing them.
  - Prefer fix-forward.

## Assumptions

- **Justin's answers on the plan** (2026-10-29, every ⭐):
  - Q1 A: a variant has its own name (prefilled `<name>-custom`), so a company can keep several variants of one item and a pack can hold the shipped item, a variant or both.
  - Q2 A: Merge is a three-way line merge, and conflicts are resolved in a text box.
  - Q3 A: Ignore records that version only; a newer release shows the notice again.
  - Q4 A: admins edit the description and main text; supporting files follow upstream, and a merge takes upstream's files.
  - The proposed AC4 (refusals write nothing and stay inside the company) is approved as written. No AC needs a live run.
- **Justin's decisions during review:**
  - After review 2: "R2-1: Keep going." On the item editor's same defect: "Fold into this fix". That is the item-editor change above, in its own commit with its own tests. AC wording unchanged.
  - Then, on cleared supporting-file text that could be resubmitted as empty files: "Mark cleared file boxes required". Built in the next fix round.
- **Migration number (pending "bring main in"):** this branch still says 25. Bringing main in renames the pair to 27 and changes "migration 25" in `internal/library/README.md` to 27. That merge also resolves four record or list conflicts with #101 and #102 (`delivery/stories.json`, `internal/audit/README.md`, `internal/store/postgres/store_test.go`, `internal/web/library.go`), keeping both sides. It needs Justin's OK with "make a PR"; the gates and AC tests run again on the merged head.
- **Rulings not yet confirmed by Justin** (accepted by the reviews and the verifier):
  - Builder:
    - deleting a library row that a variant is based on fails with SQLSTATE 23001 (`ON DELETE RESTRICT`), not 23503;
    - Customise sits under the item's facts, with a 24rem name field;
    - variant forms accept exactly their fields;
    - alert texts follow the item editor;
    - configs and MCP templates show the refusal beside their "can't be customised" note;
    - descriptions are diffed as one line;
    - two evidence shots are cropped views;
    - two extra tests beyond the plan.
  - Fixer 1:
    - "Your changes" leaves out an agent's customise rename, matching the merge;
    - a text with no frontmatter name line is compared as shipped.
  - Fixer 2:
    - every typed box is cleared on a secret refusal;
    - the item editor's edit mode is in scope;
    - cleared file text becomes `required` (Justin's choice above);
    - file paths stay (follow-up);
    - the alert text is unchanged.
  - Fixer 3:
    - the 503 scanner-unavailable page marks its emptied boxes too;
    - choosing an upload lifts the requirement;
    - a note says the text was cleared;
    - no server-side check, since `required` is a browser guard as chosen;
    - boxes are matched by file path.
- **Review findings and how each was handled:** four fresh reviews.
  - Review 1: R1-1, P2, an unedited agent variant couldn't merge an upstream description change. Fixed: the merge compares against upstream renamed to the variant's name.
  - Review 2: R2-1, P2, a suspected secret in an agent's description was shown back in the other box. Fixed, plus the item editor (Justin).
  - Review 3: R3-1, P2, cleared supporting-file text could be resubmitted as 0-byte files. Fixed with `required` (Justin).
  - Review 4: clean, with one P3 (bring main in, renumber to 27).
  - The verifier and the blind auditor were clean on `4904333`. Every P3 is a follow-up below or the pending bring-in.
- A variant's category, tags and supported tools are its upstream version's. Its version numbers are its own (1.0.0, then a minor bump per saved change), not upstream's; pack audits and the bundle show them.
- Updates are computed when a page is read. There is no job and no notification.
- Customise also runs the gate, because the variant's name changes the rendered paths. A shipped item that fails the tenant rules couldn't be customised; `TestEveryShippedSkillAgentAndPromptCanBeCustomised` shows none does today.
- If a later release ships an item with a variant's name, the variant stays (packs that hold it keep working) but can't be ticked; the admin customises again under a new name.
- Older Pack Versions paths (fork, single-item edit, "Add library item"), the quick start (#101) and the role starter packs (#102) pick shipped items only.
- **Merging with other work** (checked read-only 2026-10-30, 00:08 UTC): GitHub `main` is `8aa32a1`, with #101 and #102 merged since this branch's base. The only open PR is #103 (content usage analytics, head `b4acb2f`). It is up to date with main and adds no migration; stacked on the trial merge, its only conflict is `delivery/stories.json`, where whichever merges second appends its entry last. Its usage counts read pack items by kind and name, so a variant in a pack is counted under its own name.
- **Follow-ups:**
  1. Edit supporting files in a variant, with a per-file merge.
  2. A JSON API for variants in OpenAPI.
  3. "Replace with upstream" in one click, and renaming a variant.
  4. Tell admins when an update arrives (an admin-home badge or a message).
  5. Show the upstream's licence and source on a variant of an imported item.
  6. `internal/textdiff`: in runs of identical lines, a clean merge can drop one of the company's deletions (LCS ties favour insertion; 3 in 23,059 probe cases). Prefer deletion on ties and add the cases as tests, or document it (R2-2).
  7. Test the 2,000-shown-lines cap per diff section (`internal/web/library_variants.go:263`; R1-2).
  8. Item editor, pre-existing: a token typed into a supporting file's path is shown back in the path box after a secret refusal (paths are kept so a resubmit doesn't drop files; R3-2).
  9. Pre-existing: refusals that come before the secret scan (a variant edit's stale-version 409, the item editor's item-rule 422s) show typed text back unscanned. No secret is suspected there.
  10. Pre-existing, cosmetic: `itembuilder.validate` sorts and edits a by-value input's shared file slice, so an edit-mode error page can list supporting files in path order.
  11. Docs: an older dated plan under `docs/superpowers/plans/` (create-item templates and validation, line 56) still says a secret refusal clears "that field".
  12. A pack diff preview story can reuse `internal/textdiff`.

## Evidence

- Head: `4904333a8fe0def527ad32603e115f2499c6cef8` (base `b65f797ff6cdc56a802dfaf417b0adec96463317`); changes after bringing main in
- Check "Go quality gates": pending (not pushed)
- Actions run: pending
