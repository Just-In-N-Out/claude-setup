# 86bcm901y integration check (finisher, 2026-10-29 14:30–14:38 UTC, read-only)

Branch `feat/86bcm901y-remove-reorder`, head `3e8d18197575c772c6d34fcdd10f06e5911168fc`, base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. Nothing pushed. The worktree is clean (`git status --porcelain` is empty).

## GitHub `main`: has not moved

- HTTPS fetch through gh (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`) succeeded with rc 0. `origin/main` was `6c1709e` before the fetch and `6c1709e` after it.
- `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` returned `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`.
- **`main` has not moved past the base.** `git merge-tree --write-tree --name-only HEAD origin/main` exits 0 (tree `f0e0508`), so no conflict. The story's gates on `3e8d181` are current for today's `main`, and no rerun is needed for main.
- Open PRs (`gh pr list --state open`): **#98** only (`feat/86bcm901j-mcp-templates`, head `17f2ccf`, base `main`).

## Siblings

Each merge-tree result was then checked with a trial build. I took the tree id that `git merge-tree` prints, ran `git archive` into `~/.cache/86bcm901y-finisher/trial-*`, applied the resolutions below there, and ran gofmt, `go build ./...`, `go vet ./...` and `go test -count=1 ./...` **without** `LEORNA_TEST_DATABASE_URL`. **These results are a prediction, not a gate:** Postgres tests skip without that variable, and no database was touched. Whichever story merges second reruns its own G1–G4 on the merged tree.

| Against | Ref checked | `git merge-tree HEAD <sibling>` | `git merge-tree origin/main <sibling>` | Migration 24 | Compile |
| --- | --- | --- | --- | --- | --- |
| PR #98 (86bcm901j MCP templates) | `pull/98/head` fetched read-only. `FETCH_HEAD` = `17f2ccf09d79d53a2b8ffa0eac03011271b0a111` = `gh pr view 98 --json headRefOid` (MATCH) | rc 1: **`delivery/stories.json`** only | rc 0 (base `6c1709e`) | #98 adds no migration (newest is 23). No duplicate | trial build, vet and non-DB tests: all exit 0 |
| `feat/86bcm901r-starter-packs` (local, not pushed) | `398af64` (ref read only) | rc 1: **`delivery/stories.json`**, **`internal/pack/README.md`**, **`internal/web/library.go`** | rc 0 (base `6c1709e`) | **`000024_starter_packs`**: duplicates 901y's `000024_pack_item_order` | build **fails**: `starter_packs.go:140` calls the old 4-argument `insertVersionItems`. vet **fails**: `mintDesktopToken redeclared` in `internal/web` |
| `feat/86bcm902a-quick-start` (local, not pushed) | `707a4c0` (ref read only) | rc 1: **`delivery/stories.json`** only | rc 0 (base `6c1709e`) | **`000024_quick_starts`**: duplicates 901y's | build and vet pass. Non-DB `go test` **fails**: `TestValidateReleasedMigrationsRejectsMissingRelease: read up migrations: migration version 24 is duplicated` |

Migration numbers on each ref (newest three `.up.sql`): `main` 21/22/23; 901y …/23/**24 `pack_item_order`**; #98 21/22/23; 901r …/23/**24 `starter_packs`**; 902a …/23/**24 `quick_starts`**. On the trial trees, `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` gives empty for 901y+#98 and `000024` for both 901y+901r and 901y+902a. Only migrations 1 and 2 are hash-pinned (`releasedMigrationHashes`, `internal/store/postgres/migrate.go:22`), so renumbering 24 needs no hash edit, and no code hard-codes the number 24.

## How whichever story merges second resolves each conflict

### `delivery/stories.json` (with #98, 901r and 902a)
Take main's file unchanged and append the later story's entry last, **as text** (don't re-dump the JSON). Then check that every earlier entry is unchanged by value. I proved this for 901y going second against each sibling's file. Each had 41 entries; the merged text parses, `86bcm901y` comes last, and every earlier entry is equal by value. The same rule applies if 901y merges first and the sibling goes second.

### Migration 24 (with 901r and with 902a, no text conflict)
After the second merge the runner refuses with "migration version 24 is duplicated". This fails every Postgres test and also the non-DB `TestValidateReleasedMigrationsRejectsMissingRelease`. **The later story renames its own pair to the next free number** (25, or 26 if two others merged first) and reruns its gates. Each story's references to rename:
- **901y** (if it goes second): `internal/store/postgres/migrations/000024_pack_item_order.{up,down}.sql` → `000025_…`, plus "migration 24" in `internal/pack/README.md:241` and `:255`, and the comment in `internal/store/postgres/pack_items_test.go:18`.
- **901r** (if it goes second): `000024_starter_packs.{up,down}.sql`, plus "migration 24" in `internal/library/starter.go:27`, `internal/pack/README.md` (its section: three places), and `internal/store/postgres/starter_packs_test.go:625`.
- **902a** (if it goes second): `000024_quick_starts.{up,down}.sql`, plus "migration 24" in `internal/onboarding/README.md:47`.

Proven on the trials: renaming 901y's pair to `000025` empties the duplicate list, and `go test ./internal/store/postgres ./internal/web ./internal/pack` (non-DB) exits 0 on both the 902a trial and the 901r trial.

### 901r only: `internal/web/library.go` (`libraryCSS`)
Both stories extend the one-line `libraryCSS` constant after the same `.builder{…}` rule. 901y adds `#pack-items…`/`.pack-item…` and 901r adds `.starter…`. Keep main's prefix, then both suffixes. In the trial I checked the shared prefix is byte-identical on both sides and appended 901r's suffix after 901y's rules.

### 901r only: `internal/pack/README.md`
Both stories append a section at the end of the file ("Remove and reorder items (86bcm901y)" and "Role starter packs (86bcm901r)"). Keep both sections, with the first-merged story's section first. Then fix the later story's "migration 24" references to its new number.

### 901r only: `insertVersionItems` (no text conflict, build breaks)
901y changes the signature to `insertVersionItems(ctx, tx, versionID, items, ordered bool)`. 901r adds a new caller with the old four arguments (`internal/store/postgres/starter_packs.go:140`). After both merge, `go build` fails with "not enough arguments in call to database.insertVersionItems". **The later story passes `false`** at that call: `database.insertVersionItems(ctx, tx, id, items, false)`. Starter versions are shared, non-builder versions, so position 0 keeps them listing by kind, then name. That is exactly how they list on 901r today. Passing `true` (keep the curated order) would be a product change for 901r to decide. With `false`, the trial builds.

### 901r only: `mintDesktopToken` declared twice (no text conflict, tests don't compile)
Each story adds a test helper with this name to package `web`, with different signatures: 901y in `internal/web/pack_items_test.go:124` (`*postgres.Store`), and 901r in `internal/web/starter_packs_test.go:221` (`packFixture`). Each has three occurrences (the definition and two uses), all in its own file. `go build` passes, but `go vet` and `go test ./internal/web` fail with "mintDesktopToken redeclared in this block". **The later story renames its own helper** in its own file, for example `mintPackItemsDesktopToken` (901y) or `mintStarterDesktopToken` (901r). Either rename makes vet exit 0 in the trial.

### Rerun after the second merge
Every story whose merge comes second reruns G1 `make check`, G2 `test-module-add.sh`, G3 (the Postgres `go test -json` stream, read per test) and G4 (its AC tests) on the merged tree. For 901y that is also `TestPackItemOrderStoreWithPostgres` and `TestMigrationRoundTrip`. The 901r trial with all four resolutions passes non-DB build, vet and `go test` for `internal/store/postgres`, `internal/web` and `internal/pack`.

## Not this story's
901r and 902a also duplicate each other's migration 24, and both touch `cmd/control-plane/main.go` and `internal/web/handler.go` (`found-else.md`, 902a builder). Their merge-tree with `main` is clean.
