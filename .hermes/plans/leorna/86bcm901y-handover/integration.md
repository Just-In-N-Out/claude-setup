# 86bcm901y integration (fixer 3 brought main in, 2026-10-29 16:29–16:36 UTC)

Branch `feat/86bcm901y-remove-reorder`, head **`d84fd046994d606e1f79c2faa4b2c15cc063dab3`**: the merge of the reviewed head `3e8d181` with GitHub `main` `dd006b7`. Story base `6c1709e`. Nothing pushed, and no PR is open for this branch. The worktree is clean. Earlier check: the finisher's 14:30–14:45 UTC check on `3e8d181` found `main` still at `6c1709e`.

## GitHub `main` moved: #98 merged, and this branch now includes it

- HTTPS fetch through gh at 16:29:40 UTC (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`), rc 0. `origin/main` moved `6c1709e` → **`dd006b79f9908976e853c57489032bd5d9d471df`**. `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` gave the same SHA.
- `dd006b7` is "Merge pull request #98" (86bcm901j MCP templates), merged 16:13:39 UTC. #98's final head was `f2892bc`, which is newer than the `17f2ccf` the finisher trialled. Main is 32 commits past `6c1709e`.
- Main changed 21 files: `delivery/stories.json` (the 86bcm901j entry), library content (`github-mcp` 3.0.0, `claude-code-settings`, `codex-defaults`, `library.json` 0.8.0, `content.lock.json`, `internal/library/README.md`), and the library gate (`internal/library/gate/*`, `cmd/library-gate/main_test.go`). It added no migration (newest is still 23), no `.github` change and no Go code that this story touches.
- **Merge commit `d84fd04`** (parents `3e8d181` and `dd006b7`), message `Merge branch 'main' into feat/86bcm901y-remove-reorder`, written the same way as #98's own bring-ins. Author and committer are the Leorna identity, with no attribution lines.

## How `delivery/stories.json` was resolved

This was the only conflict and the only file both sides changed. Each side had appended one entry after `86bcm901w`: main's `86bcm901j` (PR `[98]`), and this branch's `86bcm901y` (PRs `[]`). The resolution takes main's file unchanged and appends the `86bcm901y` entry last, **as text**: main's text minus its closing `  }\n}\n`, then `  },\n`, the branch's entry copied verbatim, and `}\n`. The JSON is never re-dumped. Result: 42 entries, with `86bcm901y` last. All 41 of main's entries are unchanged by value and in main's order, and `86bcm901y` equals the branch's entry by value. `git diff origin/main -- delivery/stories.json` is a pure 6-line append. The check catches each mutant: dropping main's hunk, dropping the story's hunk, and re-dumping the JSON each fail it (`evidence/86bcm901y/fixer3/stories-resolution.txt`).

## Merge proof (`evidence/86bcm901y/fixer3/`)

- `merge-proof-staged.txt` (the staged tree, before committing) and `merge-proof-d84fd04.txt` (the commit; tree `bfb099e`, the same tree):
  - all 20 files changed on the story side only equal `3e8d181`'s blobs;
  - all 20 files changed on main's side only equal `dd006b7`'s blobs (blobs read with `git ls-tree`, so a deletion would show as absent);
  - the merge changed no file outside the two change sets;
  - the only file both sides changed is `delivery/stories.json`, read above.
- `dup-migrations-d84fd04.txt`: `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` is empty. The newest are 22, 23 and **24 `pack_item_order`**.
- `gitleaks-git-d84fd04.txt`: `gitleaks git` over `origin/main..HEAD` found no leaks. `gitleaks-dir-both-sides-d84fd04.txt`: `gitleaks dir` on `delivery/stories.json` taken from the merged tree found no leaks.
- `story-diff-unchanged-d84fd04.txt`: outside `stories.json`, `git diff origin/main...HEAD` is byte-identical to the reviewed `git diff 6c1709e 3e8d181` (sha256 `74504c2…`). In `stories.json` only the context lines differ (`[98]` instead of `[96]`).
- `stale-grep-d84fd04.txt`: the branch's diff against main has no `86bcm901j`, `#98` or "until/once … merges" wording, and no sibling card ID. The PR text's stale lines (base "still GitHub `main`", "#98 at `17f2ccf`") are rewritten in the refreshed body.
- `preflight-d84fd04.txt`:
  - clean status;
  - 14 story commits (13 plus the merge), all with 1 identity (Leorna OK);
  - 0 attribution lines;
  - no `.github` or `CLAUDE.md` path;
  - `git merge-tree --write-tree --name-only HEAD origin/main` exits 0.

## Gates on `d84fd04` (fixer 3, 16:33–16:35 UTC, own DB `leorna_86bcm901y_fix3_test`)

Every step in `evidence/86bcm901y/gates-summary-d84fd04.txt` is EXIT=0:
- `make check`: lint 0 issues in both modules, govulncheck "No vulnerabilities found" in both modules, gitleaks no leaks, library-gate PASSED on main's library 0.8.0 (43 items);
- `test-module-add.sh`;
- the Postgres `go test -json` stream, read per test: 527 entries, 523 pass, the 4 accepted skips, 0 missing, and all 106 story and builder entries pass;
- the four AC tests by name, plus `TestPackItemOrderStoreWithPostgres`;
- gitleaks on `origin/main..HEAD`;
- scope;
- the contract diff, unchanged since `3e8d181`, and `check-generated-contracts.sh`;
- `test_story_shippable.py`.

## Siblings (refs read only, 16:33:30–16:33:53 UTC; `evidence/86bcm901y/fixer3/siblings-d84fd04.txt`)

`gh pr list --state open` is **empty**: no PR is open, and #98 is merged. Neither sibling has moved since the finisher's 14:44 UTC check. Both are still on base `6c1709e` and don't include main yet.

| Sibling | Ref (last commit) | `git merge-tree HEAD <sibling>` (HEAD = `d84fd04`) | `git merge-tree origin/main <sibling>` | Migration 24 on the trial tree | Clash greps |
| --- | --- | --- | --- | --- | --- |
| `feat/86bcm901r-starter-packs` (local, not pushed) | `398af64` (14:01:25 UTC) | rc 1: `delivery/stories.json`, `internal/pack/README.md`, `internal/web/library.go`, and **`internal/library/README.md`**, which is new: it comes from main, and 901y doesn't touch it | **rc 1** (new): `delivery/stories.json`, `internal/library/README.md` | `000024` duplicated (`starter_packs`) | `starter_packs.go:140` still calls `insertVersionItems` with 4 arguments; `starter_packs_test.go:221` still declares `mintDesktopToken` |
| `feat/86bcm902a-quick-start` (local, not pushed) | `9a9bdec` (14:44:49 UTC) | rc 1: `delivery/stories.json` only | **rc 1** (new): `delivery/stories.json` | `000024` duplicated (`quick_starts`) | `quick_start_test.go:1146` still calls `SaveVersion` with `[]string{added}, nil` |

**The finisher's resolutions below still hold** for these two heads. Their files and the clashing lines are unchanged, and this merge brought in no Go code they touch. The only new item is that both siblings now conflict with main itself (each on `stories.json`; 901r also on `internal/library/README.md`). Each sibling resolves that when it brings main in, and only the paths 901y touches are this story's. The finisher's trial builds ran on `6c1709e`-based trees and are predictions, not gates. Whichever story merges second reruns its gates on the merged tree.

## How whichever story merges second resolves each conflict

### `delivery/stories.json` (with 901r and 902a)
Take main's file unchanged and append the later story's entry last, **as text** (don't re-dump the JSON). Then check that every earlier entry is unchanged by value. This is how this branch took main's `86bcm901j` entry above. The finisher proved the same rule for 901y against each sibling's file. If 901y merges first, each sibling appends its own entry after `86bcm901y`.

### Migration 24 (with 901r and with 902a, no text conflict)
After the second merge the runner refuses with "migration version 24 is duplicated". This fails every Postgres test and also the non-DB `TestValidateReleasedMigrationsRejectsMissingRelease`. **The later story renames its own pair to the next free number** (25, or 26 if two others merged first) and reruns its gates. Each story's references to rename:
- **901y** (if it goes second): `internal/store/postgres/migrations/000024_pack_item_order.{up,down}.sql` → `000025_…`, plus "migration 24" in `internal/pack/README.md:241` and `:255`, and the comment in `internal/store/postgres/pack_items_test.go:18`.
- **901r** (if it goes second): `000024_starter_packs.{up,down}.sql`, plus "migration 24" in `internal/library/starter.go:27`, `internal/pack/README.md` (its section: three places), and `internal/store/postgres/starter_packs_test.go:625`.
- **902a** (if it goes second): `000024_quick_starts.{up,down}.sql`, plus "migration 24" in `internal/onboarding/README.md:47`.

Proven on the trials: renaming 901y's pair to `000025` empties the duplicate list. Non-DB `go test ./internal/store/postgres ./internal/web ./internal/pack` then exits 0 on the 902a@`707a4c0` trial and the 901r trial, and non-DB `go test ./...` exits 0 on the 902a@`19baa19` trial (with the `SaveVersion` fix below).

### 901r only: `internal/web/library.go` (`libraryCSS`)
Both stories extend the one-line `libraryCSS` constant after the same `.builder{…}` rule. 901y adds `#pack-items…`/`.pack-item…` and 901r adds `.starter…`. Keep main's prefix, then both suffixes. In the trial I checked the shared prefix is byte-identical on both sides and appended 901r's suffix after 901y's rules.

### 901r only: `internal/pack/README.md`
Both stories append a section at the end of the file ("Remove and reorder items (86bcm901y)" and "Role starter packs (86bcm901r)"). Keep both sections, with the first-merged story's section first. Then fix the later story's "migration 24" references to its new number.

### 901r only: `insertVersionItems` (no text conflict, build breaks)
901y changes the signature to `insertVersionItems(ctx, tx, versionID, items, ordered bool)`. 901r adds a new caller with the old four arguments (`internal/store/postgres/starter_packs.go:140`). After both merge, `go build` fails with "not enough arguments in call to database.insertVersionItems". **The later story passes `false`** at that call: `database.insertVersionItems(ctx, tx, id, items, false)`. Starter versions are shared, non-builder versions, so position 0 keeps them listing by kind, then name. That is exactly how they list on 901r today. Passing `true` (keep the curated order) would be a product change for 901r to decide. With `false`, the trial builds.

### 901r only: `mintDesktopToken` declared twice (no text conflict, tests don't compile)
Each story adds a test helper with this name to package `web`, with different signatures: 901y in `internal/web/pack_items_test.go:124` (`*postgres.Store`), and 901r in `internal/web/starter_packs_test.go:221` (`packFixture`). Each has three occurrences (the definition and two uses), all in its own file. `go build` passes, but `go vet` and `go test ./internal/web` fail with "mintDesktopToken redeclared in this block". **The later story renames its own helper** in its own file, for example `mintPackItemsDesktopToken` (901y) or `mintStarterDesktopToken` (901r). Either rename makes vet exit 0 in the trial.

### 902a only: `BuilderService.SaveVersion` signature (no text conflict, tests don't compile)
901y changes `SaveVersion(ctx, actor, packID, parentVersion, add []string, remove []ItemKey)` to `SaveVersion(ctx, actor, packID, parentVersion, change pack.VersionChange)`. 902a's fixer added a test call with the old arguments at `19baa19:internal/web/quick_start_test.go:1146` (the commit is newer than `707a4c0`). After both merge, `go build` passes, but `go vet` and `go test ./internal/web` fail with "too many arguments in call to … SaveVersion". **The later story changes that call** to `SaveVersion(ctx, fixture.admin, own.PackID, own.Version.Version, pack.VersionChange{AddLibraryItemIDs: []string{added}})`. On the trial of 901y with 902a@`19baa19` (tree `92c691c`), I applied this fix, appended `stories.json` as text and renamed 901y's migration to `000025`. Then vet exited 0, and non-DB `go test ./...` exited 0. 901r and #98 add no `SaveVersion` caller: their counts equal base's 7.


### Sibling heads move: recheck at the time
At 14:40–14:44 UTC, 902a gained 7 commits during the finisher's check (`789791b` … `19baa19`, then `28c0944` and `9a9bdec`). At 16:33 UTC both siblings were still at the heads in the table (901r `398af64`, 902a `9a9bdec`). Whoever merges second must rerun `git merge-tree` and `go vet ./...` against the sibling's head at that time, not this file's SHA.

### Rerun after the second merge
Every story whose merge comes second reruns G1 `make check`, G2 `test-module-add.sh`, G3 (the Postgres `go test -json` stream, read per test) and G4 (its AC tests) on the merged tree. For 901y that is also `TestPackItemOrderStoreWithPostgres` and `TestMigrationRoundTrip`. The finisher's 901r trial, with all four resolutions, passed non-DB build, vet and `go test` for `internal/store/postgres`, `internal/web` and `internal/pack`.

## Not this story's
- 901r and 902a also duplicate each other's migration 24, and both touch `cmd/control-plane/main.go` and `internal/web/handler.go` (`found-else.md`, 902a builder).
- Since #98 merged, both siblings conflict with `main` on `delivery/stories.json`, and 901r also on `internal/library/README.md`. 901y doesn't change `internal/library/README.md`.
