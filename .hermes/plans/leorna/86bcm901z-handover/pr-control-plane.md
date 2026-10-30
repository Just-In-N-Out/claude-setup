## Summary

Lets an admin make a company copy of a shipped skill, agent or prompt, edit it, and keep it close to the original. "Customise for your company" on a shipped item's page creates a **company variant**: a tenant-owned row in a new `library_variants` table with its own name (prefilled `<name>-custom`), version 1.0.0, and a link to the exact library item version it came from. When a later control-plane release ships a newer version of that item, the Content library and the variant page show "Update available" with the upstream diff. The admin can **merge** it (a three-way line merge; where both sides changed the same lines nothing is saved until the admin resolves the conflict in a text box) or **ignore** that version (a newer release brings the notice back). Admins edit a variant's description and main text; supporting files follow upstream. Every save goes through the item editor's gate (item rules, per-tool renders, gitleaks). Inside packs a variant behaves exactly like a shipped item: it can be ticked, ordered, removed, assigned and synced, and the pack API's id lists accept its id. Pack versions copy its content, so editing or deleting a variant never changes a saved pack version. Configs and MCP templates can't be customised: their policy gate runs only on shipped content. This PR also includes a fix to the existing item editor that Justin added during review: a suspected secret now clears every typed field, not just the first one the scanner names.

ClickUp: [Customise a shipped item (company variant)](https://app.clickup.com/t/86bcm901z)

## Changes

- `internal/store/postgres/migrations/000027_library_variants.{up,down}.sql`: one new table, `library_variants`.
  - Tenant-owned.
  - Columns: kind (skill, agent or prompt), name, version, description, body, files, `upstream_item_id` → the `library_items` row it is based on, and `ignored_upstream_version`.
  - `UNIQUE (tenant_id, kind, name)`, `ON DELETE RESTRICT` on both foreign keys, and an index on `upstream_item_id`.
  - The down file drops the table.
  - This branch first numbered it 25. #101 and #102 took 25 and 26, so the merge of `main` renamed the pair to 27 with the same SQL bytes.
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
- `delivery/stories.json`: this story's entry, appended last. `03319a0` records this PR's number in it.
- **Merges of `main`**, no rebase:
  - `f10da15` brought in `5e6863d` (#101, #102 and #103). Four files that both sides appended to were resolved keeping both:
    - `delivery/stories.json`: main's file unchanged, this story's entry last;
    - `internal/audit/README.md`: the quick start paragraph, then this story's;
    - `internal/store/postgres/store_test.go`: `quick_starts` and `library_variants` in both `TestMigrationRoundTrip` lists and in `resetDatabase`;
    - `internal/web/library.go`: this story's lede, then #102's Starter packs section.
    - The same commit renames the migration pair to 27 and changes "migration 25" to 27 in `internal/library/README.md`.
  - `caf5d96` brings in `9135f4e` (#104, manage many packs in one admin overview) with no conflict. The seven files both sides change merged cleanly, and #104 adds no migration.

## Test Plan

Unless an item names another commit, everything below ran on `caf5d96` (the merge of GitHub `main` `9135f4e` into `03319a0`) on 2026-10-30. The PR finisher ran it in a detached copy with its own fresh `_test` database, using Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 (as CI) and gitleaks 8.30.1.

- [x] `make check`, exit 0:
  - workspace, contracts-check, fmt and vet;
  - `go test -race -count=1` on every package with real PostgreSQL;
  - lint: 0 issues in both modules;
  - govulncheck: no called vulnerability. The "1 vulnerability in modules you require" note predates this branch, which doesn't touch `go.mod` or `go.sum`;
  - gitleaks: no leaks;
  - library gate PASSED (0.8.0, 43 items);
  - build.
- [x] `scripts/test-module-add.sh`: exit 0.
- [x] Postgres tests: a `go test -json` stream over `cmd/control-plane`, `internal/cloud/dbcheck`, `internal/store/postgres`, `internal/web`, `internal/variant`, `internal/textdiff`, `internal/pack` and `internal/library`, read per test.
  - 467 declared top-level tests: 460 passed, 630 subtests passed, 0 failures. That includes #101's to #104's tests (#104's pack overview and body diff tests among them) and `TestMigrationRoundTrip` up and down through migration 27.
  - 9 skips, all accepted: 7 top-level tests (#103's five content-usage tests, which need ClickHouse through `LEORNA_TEST_CLICKHOUSE_URL`, plus `LEORNA_EVIDENCE_DIR` and `SCW_LIVE`) and the two ClickHouse subtests of `TestTeamsAPIWithPostgres`. CI runs the ClickHouse ones with its ClickHouse service. No skip names `LEORNA_TEST_DATABASE_URL`.
- [x] AC tests, each run alone by name on `caf5d96`, 0 skips:
  - [x] AC1 `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres` (7 subtests): pass
  - [x] AC2 `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres` (5 subtests): pass
  - [x] AC3 `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres` (8 subtests): pass
  - [x] AC4 `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres` (14 subtests): pass
- [x] gitleaks: no leaks in the 84 commits from this branch's base to `caf5d96`, nor in the merged content of the 7 files both sides of `caf5d96` changed.
- [x] Real binary from `caf5d96` (`vcs.modified=false`), dev mode on loopback, fresh database, HTTP requests only (no browser):
  - the production startup loads ran: the content library (43 items) and #102's four starter packs;
  - the Content library shows the Starter packs section, the pack builder and this story's lede;
  - customising `incident-postmortem` as `incident-postmortem-acme` redirects to its variant page;
  - the library then lists it with the Company variant chip, and the pack builder offers it as a checkbox;
  - building a pack with only the variant ticked opens that pack with the variant ticked and marked "in pack";
  - #104's Pack overview lists that pack as a tenant pack, and its history page shows the variant added at 1.0.0;
  - the Packs and Pack versions pages answer 200, and the server logged no error.
- [x] Merge checks on `caf5d96`:
  - no conflict, and the merged tree equals the one a trial predicted before the merge (also the tree CI tested on `03319a0`);
  - every file only one side changed equals that side's version;
  - the 7 files both sides changed equal git's clean three-way merge, and they are exactly the files whose merged content differs from both parents;
  - this story's own patch survives line for line in all 34 files;
  - no duplicated migration version: 25 `quick_starts`, 26 `starter_packs`, 27 `library_variants`.
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: 5 tests OK. `delivery/stories.json`: main's 47 entries unchanged by value and in order, this story's entry 48th and last and unchanged, still recording this PR. `scripts/check-story-shippable.py 86bcm901z` prints only the two lines expected while this PR is open ("not merged into main" and "open follow-up references this story").
- [x] Scope: no `.github` path changed. The branch's 22 commits (19 story commits, the PR-number record and two merges of `main`) are by the Leorna identity, with no AI attribution lines. No `CLAUDE.md`.
- [ ] Hosted CI on `caf5d96`: running; see Evidence.
- [ ] Not re-run on `caf5d96` (they ran on `4904333`, see Assumptions): the mutation checks, the headless-Chrome captures, the release-B update run and the migration fill test.

## Security, migration, rollback

- **Security:**
  - Every new route is admin-only (`requireSession` + `requireAdmin`; a member gets 403, AC4). Every store write re-checks the admin role inside its transaction (`beginOrg(ctx, actor, true)`).
  - Tenant isolation: every variant read and write filters by `tenant_id`, and so does the pack builder's id lookup. Another company's variant id behaves exactly like an unknown id: 404 on its page and its forms, refused in a pack (`INVALID_PACK`), and absent from that company's library. AC4 and `TestPackBuilderCopiesOnlyTheTenantsOwnVariantsWithPostgres` check this, and the mutants that drop each filter were killed.
  - The secret gate: customise, edit and merge run the item editor's gate (item rules, renders for Claude Code, Codex and Cursor, gitleaks) before anything is written. Without gitleaks they answer 503 and save nothing.
  - No echo: a refusal for a suspected secret clears every typed field on the variant page and in the item editor, so no part of the token is shown back (five AC4 cases and the item-editor tests; the token check reads the page HTML).
  - CSRF on every form. SQL is parameterized, pages are `html/template`, and the variant preview uses #100's bounded renderer; the unbounded preview stays for shipped content only. Audit records hold ids, names and versions, never text.
  - No auth bypass or dev-login change.
- **Migration:**
  - One new table, additive. No existing table or row changes. The verifier's fill test on the pre-merge head (then numbered 25) kept every earlier row through up, down and up again.
  - It is migration 27 (#101 took 25, #102 took 26; #103 and #104 add none). The SQL is byte-for-byte the same as when this branch numbered it 25.
  - GitHub `main` never had it, so no shared database ran it as 25; only this story's own test databases did. A database that ran a pre-merge build of this branch stops at startup with "migration 25 checksum mismatch". The SQL bytes are unchanged and the checksum leaves out the number, so `UPDATE schema_migrations SET version = 27 WHERE version = 25` recovers it and keeps its variants; the next start then applies 25 and 26. Dropping `library_variants` and its `schema_migrations` row, or a fresh database, also works.
- **Rollback:**
  - **Run the down migration first, then roll back the deploy.** The older binary refuses to start on a database that still records this migration ("applied migration N is missing from embedded migrations"; seen with the base binary in the verifier's migration fill).
  - Migration 27's down file drops `library_variants`, deleting every variant. Pack versions keep their copies, so teams keep syncing them.
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
  - Bringing `main` in with this PR: "ok push pr". Then, once #104 had merged, bringing it in before the verifier and the AC auditor: "Bring #104 in first".
- **Verification so far:** the pre-merge head `4904333` passed four fresh reviews (the last one clean), a verifier and a blind AC auditor (`ac-check.sh`: all 4 ACs accepted), mutation checks (verifier 36 of 36 killed, auditor 16 of 16), a two-release run of the real binaries in headless Chrome, and a migration fill test. On this PR's head `caf5d96`, the gates, the AC tests and the startup check above ran; fresh reviews of the commits since `4904333` (the two merges of `main` and the PR-number record), then a new verifier and blind AC auditor, follow on this PR's head.
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
  - Review 4: clean, with one P3 (bring main in and renumber to 27): done in this PR's merge commit.
  - The verifier and the blind auditor were clean on `4904333`. Every other P3 is a follow-up below.
- A variant's category, tags and supported tools are its upstream version's. Its version numbers are its own (1.0.0, then a minor bump per saved change), not upstream's; pack audits and the bundle show them.
- Updates are computed when a page is read. There is no job and no notification.
- Customise also runs the gate, because the variant's name changes the rendered paths. A shipped item that fails the tenant rules couldn't be customised; `TestEveryShippedSkillAgentAndPromptCanBeCustomised` shows none does today.
- If a later release ships an item with a variant's name, the variant stays (packs that hold it keep working) but can't be ticked; the admin customises again under a new name.
- Older Pack Versions paths (fork, single-item edit, "Add library item"), the quick start (#101) and the role starter packs (#102) pick shipped items only.
- **Merging with other work** (checked 2026-10-30, 13:14 UTC): GitHub `main` is `9135f4e`. Since this branch's base it has merged #101, #102 and #103, which `f10da15` brought in, and #104 (manage many packs in one admin overview), which merged after this PR opened and which `caf5d96` brought in. The branch contains `main`, and no other PR is open.
  - #104 merged in with no conflict: it placed its `delivery/stories.json` entry before the previous last one and adds no migration. The seven files both change auto-merged, no top-level name is added by both, and #104 calls none of the functions this PR changed.
  - #104's Pack overview reads pack versions, so a pack holding a variant shows the variant like any other item (the startup check above).
  - #103's usage counts read pack items by kind and name, so a variant in a pack is counted under its own name.
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

- Head: `caf5d9659953cbab3e6141eddd4193762f96aeff`, the merge of `main` `9135f4e` into `03319a0` (the PR-number record), which sits on `f10da155b9f35e72c35645efea3d20121b72d69f`, the merge of `main` `5e6863d` into `4904333a8fe0def527ad32603e115f2499c6cef8` (story base `b65f797ff6cdc56a802dfaf417b0adec96463317`)
- Check "Go quality gates": running on `caf5d96`
- Actions run: https://github.com/LeornaAI/leorna-control-plane/actions/runs/41061511703
