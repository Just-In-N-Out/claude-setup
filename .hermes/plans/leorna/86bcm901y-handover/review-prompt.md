# Review prompt for a fresh agent: 86bcm901y (paste as is)

```
You are reviewing a finished Leorna story. REVIEW ONLY: no commit, push, PR, merge or ClickUp change. Restore anything you change, and leave `deploy/local/` alone. Don't trust anyone's summary, the PR text or the shared memory notes: check every claim yourself in code and with real command output. The work is local only (not pushed), so you must run on Justin's Windows desktop (WSL Ubuntu, user justin).

## What to review
- Repo: ~/Leorna/leorna-control-plane (Go). Worktree: ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder
- Branch: feat/86bcm901y-remove-reorder, head 3e8d18197575c772c6d34fcdd10f06e5911168fc. Base: 6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f (GitHub main on 2026-10-29: check it again with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`).
- Range: `git log 6c1709e..3e8d181` (13 commits) and `git diff 6c1709e...3e8d181` (21 files, +1855/-54). Not pushed. Not a PR yet.
- Don't edit the story worktree. Work in your own detached copy: `git -C ~/Leorna/leorna-control-plane worktree add --detach ~/.cache/86bcm901y-review3/copy 3e8d181`. When you finish, run `git -C ~/Leorna/leorna-control-plane worktree remove --force ~/.cache/86bcm901y-review3/copy`. NEVER run `git worktree prune`: it drops other stories' entries.

## The card (ClickUp 86bcm901y, "Remove and reorder items in a pack version", E11 Pack Builder, Size S)
User story: As an admin, I want to remove or reorder items in a pack, so that I can trim a pack without starting over.
Context: applyEdit today only replaces or appends (internal/pack/version_service.go).
Acceptance criteria (test-backed):
- Given a pack version, when I remove an item, then a new version is saved without it and audited
- Given a removal, when engineers next sync, then the item's files are removed from their tools (or flagged) consistently with the lockfile
Verify: unit tests + client sync integration test
Definition of Done: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
Dependency: 86bcm901w "Create a pack by picking library items" (merged as PR #96 = 6c1709e).

## The approved acceptance criteria (each test name is exact)
- AC1 (card): remove → a new version without the item, audited. `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`
- AC2 (card): after a removal, engineers' next sync drops the item's files consistently with the lockfile. `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`
- AC3 (Justin's addition): reorder (Move up / Move down in the console's item list, or `order` in the API) → a new version in the new order. The console and the API show that order, the parent keeps its old order, the save is audited with the order before and after, and once assigned it syncs the same files and hashes as its parent. `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres`
- AC4 (proposed, approved): every invalid or disallowed remove or reorder is refused with a clear status or inline alert and writes nothing (no version, no audit record). The cases are: removing the only item, moving the first item up or the last down, an item not in this version, an order that misses, repeats or invents an item, an order that changes nothing, an outdated version, a member, a bad CSRF token, another company's pack, signed out. `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres`

## Decisions Justin already made (check they're implemented; don't re-argue them)
- Q1-A: AC2 is proven by this repo's sync test (remove → assign → the desktop's lockfile drops exactly that item's files), plus a read-only run of the client's existing Sync tests. No change in leorna-client.
- Q2-A: Move up / Move down buttons; each click saves a version; no JavaScript.
- Q3-A: order shows in the console and the API only. The bundle and lockfile stay sorted by path, and Sync is unchanged.
- Order is stored as pack_version_items.position (migration 24): 1..n for versions saved by the pack builder, 0 for every other version (they keep listing by kind, then name).
- Accepted rulings:
  - a present but empty `order` is 400 even beside other changes;
  - the audit records `order` before and after whenever a save names an `order`, and saves without one keep 86bcm901w's audit shape;
  - versions derived on Pack Versions (Fork, Edit, Add library item, a new item) store position 0, even from a built version (documented);
  - AC4 makes its version 2 through the JSON API so the base-commit run reaches every case.

## Earlier review rounds and the claimed fixes (re-check each fix)
Review 1 (on c574cdd):
- R1-F1 an empty `order` beside other changes was ignored → refused in the JSON handler, plus `minItems: 1` (70bf9b9).
- R1-F2 the item form's 4 KiB bound was untested → AC4 `oversized_form` (f2eccd5).
- R1-F3 the `parent_version` count guard was untested → AC4 `missing_or_repeated_parent_version` (f2eccd5).
- R1-F4 an order that only places added items wasn't audited → the audit records both orders whenever a save names an order (bc5b410).
- R1-F5 the README didn't say derived versions drop the order → one README line (b35d111).
Review 2 (on b35d111):
- R2-F1 a stale comment on packAuditRecord.Order, and the same stale rule in the pack.Diff.Reordered comment → comments only (3e8d181).

## Commands (run them; paste real output)
1. Tools (CI's pins). `export PATH="$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:/usr/local/bin:/usr/bin:/bin" GOTOOLCHAIN=local`. Then `go version` (expect go1.27.3), `golangci-lint version` (2.14.0), `govulncheck -version` (v1.7.0) and `gitleaks version` (8.30.1). Bind them for make: `GOLANGCI_LINT=$HOME/.local/leorna-toolchain/bin/golangci-lint GOVULNCHECK=$HOME/.local/leorna-toolchain/bin/govulncheck GITLEAKS=/usr/local/bin/gitleaks LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`. Confirm with `make -n -s lint audit secrets`.
2. Test database: the container `leorna-test-pg` on 127.0.0.1:55432. NOT 5432: that is another container. Read the password with `/usr/bin/docker exec leorna-test-pg printenv POSTGRES_PASSWORD` into a variable. Abort if it's empty, and never print it. Create your own database whose name ends in `_test`, e.g. `leorna_86bcm901y_review3_test`, and drop only that one at the end. Never touch `leorna_86bcm901y_test` or any other story's database. `export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:55432/leorna_86bcm901y_review3_test?sslmode=disable"`
3. In your copy: `make check`, then `bash ./scripts/test-module-add.sh`, then `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, then `bash ./scripts/check-generated-contracts.sh`.
4. Prove the Postgres tests ran, not skipped. Run `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web` and read it per test (Action plus that test's own Output; not `-v` text). Fail on any skip whose reason names LEORNA_TEST_DATABASE_URL. The only accepted skips are TestEvidenceThirdPartyContentPage ("LEORNA_EVIDENCE_DIR is not set"), TestProvisionManagedPostgresLive ("SCW_LIVE=1 not set") and TestTeamsAPIWithPostgres's two ClickHouse subtests.
5. The four AC tests by name with -v (`go test -v -count=1 -run '^TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres$' ./internal/web`, and the same for AC2, AC3 and AC4). Also run `TestPackItemOrderStoreWithPostgres` and `TestMigrationRoundTrip` (./internal/store/postgres), and 86bcm901w's `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`, which must pass unchanged.
6. Run each AC test on base too: a second detached copy at 6c1709e with the head's internal/web/pack_items_test.go copied in, and its own `_test` database. Each must fail with a real `--- FAIL` (expect 405 for the unrouted POST …/items, and 400 for `order` as an unknown field), not a build or setup error.
7. Migration 24: read 000024_pack_item_order.{up,down}.sql. Apply it over existing rows (base code writes packs at migration 23, then head migrates). Check that every existing row gets position 0 and stays byte-identical, that listings are unchanged, that the down keeps the rows, and that migration 23's no-edit triggers don't fire.
8. Demo it (the DoD says "demoable in isolation"): run the head binary in dev mode (LEORNA_DEV_MODE=1) on loopback against a throwaway `_test` database. Build a pack of five items on /admin/library. Then:
   - press Move up and see version 2 in the new order;
   - press Remove and see version 3 without the item;
   - open the change history: the reorder's record has `reordered: true` and both orders, and the removal's has `removed` and no order;
   - check a one-item pack's Remove is disabled.
   Keep any screenshot free of URL bars, domains, tenant ids, tokens and emails.

## Mutations to try (each must still compile; use `go test -overlay` or restore the file after each)
- internal/web/pack_items.go: drop the CSRF/admin path (route without requireAdmin); accept two buttons; skip the `parent_version` count check; allow removing the only item; skip the "already first/last" checks; raise the form bound past 4 KiB.
- internal/web/pack_builder.go: ignore an empty `order` instead of refusing it.
- internal/pack/builder.go: let applyOrder accept a repeated or missing key; drop the "order changes nothing" refusal; make `reordered` always false.
- internal/store/postgres/pack_versions.go: store position 0 for builder versions (ordered=false in insertBuiltVersion), or order loadVersionItems by kind,name only.
- internal/store/postgres/pack_builder.go: never add `order` to the audit; add it only when diff.reordered.
- The migration: drop the CHECK, make the unique index non-partial, or drop it.
- Known trap: some guards are defence in depth. A tenant clause removed from the new route is still refused by migration 23's (tenant_id, pack_id) FK, and a repeated key in an order is still refused by the duplicate-item check plus the DB unique constraint. A survivor there is not a finding unless the paired guard is also removable.

## Also check
- Security:
  - every new path is admin-only and tenant-keyed; another company's pack gives 404;
  - an item id from another version is refused as a stale page, never looked up elsewhere;
  - SQL is parameterized; the redirect is built from the server's pack id;
  - no item bodies or files go into audit records;
  - no auth bypass or dev-login change.
- OpenAPI: the change to contracts/control-plane.openapi.yaml is additive only (optional `order`, minItems 1, maxItems 500), and packages/contracts/controlplane.gen.go is regenerated, not hand-edited. The client needs no regeneration.
- Docs are true as written: internal/pack/README.md (the 86bcm901y section), internal/web/README.md, internal/bundle/README.md.
- delivery/stories.json: the 86bcm901y entry is last, its PR list is empty (no PR exists yet), and every earlier entry is unchanged.
- Commits: every author and committer is `Justin Issa <justin@leorna.com>`. `git log --format=%B 6c1709e..3e8d181 | grep -inE '^co-authored-by:|generated with|noreply@anthropic|🤖'` must print nothing. No .github change, and no CLAUDE.md.
- Merge risk:
  - `git merge-tree --write-tree --name-only 3e8d181 origin/main` after a fresh fetch;
  - against PR #98 (`pull/98/head`; check FETCH_HEAD equals `gh pr view 98 --json headRefOid`);
  - against the local branches feat/86bcm901r-starter-packs and feat/86bcm902a-quick-start (read their refs only; don't check them out).
  Known: stories.json conflicts with all three; 901r and 902a each add their own migration 000024; 901r conflicts in internal/pack/README.md and internal/web/library.go; 901r calls the old 4-argument insertVersionItems and declares its own mintDesktopToken test helper in internal/web; 902a has a test calling SaveVersion with the old arguments. Report anything beyond this, and run `go vet ./...` (not only go build) on any trial merge.

## Report format
- One-line verdict: Ready / Ready with nits / Not ready.
- A table per AC and per DoD line: requirement | evidence (test, file:line, command) | pass/fail.
- Real command output for every gate (exit codes), the Postgres per-test reading, and the base-commit failures.
- Mutation results: mutant | expected killer | killed or survived | note.
- Issues: severity (blocker/major/minor/nit) | introduced or pre-existing | file:line | evidence | suggested fix.
- Confirm that you restored everything, removed your copies with `git worktree remove --force`, and dropped only your own databases.
```
