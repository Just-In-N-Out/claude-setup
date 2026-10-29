# 86bcm902a — integration check (finisher, read-only)

Story head: `9a9bdecc2f6ab53356fddddbc62b06b6533a4867` (`feat/86bcm902a-quick-start`, 21 commits on `6c1709e`, clean, not pushed).
Checked 2026-10-29 15:39–15:46 UTC; every ref below re-read at 15:46:31 UTC and unchanged.

## GitHub `main`

- HTTPS fetch through gh (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`): EXIT=0, `origin/main` = `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`.
- `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` = `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (same at 15:46:31).
- **`main` has not moved past `6c1709e`.** `git merge-tree --write-tree --name-only HEAD origin/main` EXIT=0, tree `aced059…` = HEAD's own tree (`main` is an ancestor of HEAD, so merging is a fast-forward). No gate rerun is needed for `main`.

## Open siblings

| Against | Head used (read at) | merge-tree vs 902a | Text conflicts | Migration dupes (`ls … | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d`) | Trial (prediction, not a gate) |
| --- | --- | --- | --- | --- | --- |
| PR #98 `feat/86bcm901j-mcp-templates` (GitHub) | `17f2ccf09d79d53a2b8ffa0eac03011271b0a111` (`pull/98/head` fetched into a scratch worktree; `FETCH_HEAD` = `gh pr view 98 --json headRefOid`, 15:39:49) | EXIT=1, tree `2f4e27f` | `delivery/stories.json` only | none (901j adds no migration) | resolved: gofmt, build, vet, non-DB tests all EXIT=0 (45 packages) |
| local `feat/86bcm901j-mcp-templates` | `f2892bc2dddb829b46d6c4be3557c3ecdfa89538` (8 commits past the PR head, not pushed yet) | EXIT=1, tree `f498979` | `delivery/stories.json` only | none | resolved: gofmt, build, vet, non-DB tests all EXIT=0 |
| local `feat/86bcm901r-starter-packs` | `398af64906adc26726f79cae81ce4d00355b7092` | EXIT=1, tree `bf548dc` (auto-merged `cmd/control-plane/main.go`, `internal/web/handler.go`) | `delivery/stories.json` only | **`000024`** (`000024_starter_packs` + `000024_quick_starts`) | after the renumber below: no dupes; gofmt, build, vet, non-DB tests all EXIT=0 |
| local `feat/86bcm901y-remove-reorder` | `3e8d18197575c772c6d34fcdd10f06e5911168fc` | EXIT=1, tree `7309d87` (auto-merged `internal/web/README.md`, `internal/web/handler.go`) | `delivery/stories.json` only | **`000024`** (`000024_pack_item_order` + `000024_quick_starts`) | after the renumber: gofmt, build EXIT=0, but **`go vet` and the `internal/web` test build FAIL** (below); after the one-line fix: all EXIT=0 |

Every sibling is based on `6c1709e`, so `git merge-tree origin/main <sibling>` is EXIT=0 for all four heads: no sibling conflicts with `main` itself.

## How whoever merges second resolves each

1. **`delivery/stories.json` (all four):** take the first-merged file unchanged and append the second story's own entry last, **as text** (never re-dump the JSON). Proven in scratch both ways for each sibling with a by-value check: 41 earlier entries unchanged, the appended entry equal to its branch's value, file still ASCII.
2. **Migration `000024` (901r and 901y):** the later story renames its own pair to the next free number (rename only, no SQL change). For 902a that is `000024_quick_starts.{up,down}.sql` → `000025_…` plus one doc line, `internal/onboarding/README.md:51` "(migration 24)" → "(migration 25)" (the only place the branch names the number; no test pins a migration version). With all three stories merged, the order decides 24 / 25 / 26.
3. **901y's `SaveVersion` signature (902a × 901y only):** 901y changes `BuilderService.SaveVersion(…, add, remove)` to `SaveVersion(…, pack.VersionChange)`. The texts merge cleanly, but 902a's test caller then fails to compile:
   ```
   vet: internal/web/quick_start_test.go:1146:139: too many arguments in call to pack.NewBuilderService(fixture.repository).SaveVersion
   	have (context.Context, store.Principal, string, string, []string, nil)
   	want (context.Context, store.Principal, string, string, pack.VersionChange)
   ```
   Fix (proven in the trial tree: gofmt, build, vet, non-DB tests EXIT=0):
   `…SaveVersion(ctx, fixture.admin, own.PackID, own.Version.Version, pack.VersionChange{AddLibraryItemIDs: []string{added}})`.
   Whoever merges second makes it; 901y's PR draft already says so (`leorna-pr-86bcm901y-remove-reorder.md`).
4. **901r overlap in product terms (not a text conflict):** with both merged, a company that runs this quick start gets its own "Backend starter pack" next to 901r's shared "Backend starter pack" version. That is the open A/B decision (pr.md, top).
5. After any of these, the second merger reruns its gates on the merged tree (`make check` with the Postgres suite, module-add, the story gate).

## What the trials did and did not run

- Trees came from `git merge-tree --write-tree` and `git archive` into `~/.cache/86bcm902a-finisher/trees/` (no worktree checkout of any sibling, no branch touched). gofmt, `go build`, `go vet` and `go test -count=1 ./... ./packages/contracts/...` ran there with no `LEORNA_TEST_DATABASE_URL`, so **the Postgres tests skipped**: this is a prediction, not a gate.
- The Postgres suite was not run on the trial trees (the finisher brief rules out touching databases). Review 1 ran it on earlier heads (902a `7b45d43` × 901r `aa57092`, and × 901y): `TestMigrationRoundTrip` fails with "migration version 24 is duplicated" as merged, and onboarding, postgres, web, pack and library tests all pass once 902a's pair is renumbered (`evidence/86bcm902a/review1/trial-merge-901r.txt`, `trial-merge-901y.txt`). 901r and 901y have moved since; the second merger's own gates settle it.
- The `SaveVersion` break is new since review 1: the caller at `quick_start_test.go:1146` was added by fixer 2 after `707a4c0`.
- Receipts: `integration-receipts/` next to this file (`mt-*.txt` merge-tree output, `trial-*.txt` per tree, the resolver and trial scripts, `901y-saveversion-fix.diff`). `trial-901y.txt` is the run **after** the one-line fix; the failing run's `go vet` output is quoted in step 3 above.
