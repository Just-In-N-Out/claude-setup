# 86bcm902a — integration (finisher 2, 2026-10-29: main brought in, PR #101 opened)

Branch `feat/86bcm902a-quick-start`, pushed, PR #101. All refs below were read through gh/HTTPS; times are UTC.

## GitHub `main` and what was merged

| When (UTC) | GitHub `main` | What | Result |
| --- | --- | --- | --- |
| 18:33:07 | `b985422cd78a961b8c8e70a9e56fecc51d487858` (#98, #99) | `git merge --no-ff main` into `9a9bdec` → merge `7360fca` | text conflict in `delivery/stories.json` only (resolved with `integration-receipts/resolve_stories.py`: main's 42 entries unchanged by value, 86bcm902a appended last); `internal/web/README.md`, `internal/web/handler.go` auto-merged. `merge-check-7360fca.txt`: one-side files = that side's blob (16 + 38), differs-from-both = both-sides set, auto-merged files = fresh 3-way `merge-file`, stories.json = resolver output; EXIT=0 |
| (after the merge) | — | `58f2bff` renumber `000024_quick_starts` → `000025` (rename only) + `internal/onboarding/README.md` "(migration 25)"; `be31bad` `SaveVersion(…, pack.VersionChange{AddLibraryItemIDs: …})` at `internal/web/quick_start_test.go:1146` | before the fix `go vet ./internal/web/` failed exactly as predicted (too many arguments); after: gofmt, vet, build EXIT=0 |
| 18:41:59 | `b985422` (unchanged) | gates on `be31bad` (`SUMMARY-be31bad.txt`: all EXIT=0), pushed `be31bad`, PR #101 opened, `72ae141` PR number in stories.json, pushed | CI run 40933681482 on `be31bad` cancelled (superseded); run 40934127145 on `72ae141`: "Go quality gates" success |
| 19:01:11 | **`b65f797ff6cdc56a802dfaf417b0adec96463317`** (#100 "Item editor with live preview" merged) | `git merge --no-ff origin/main` into `72ae141` → merge `bb79ec6` (local `main` was still `b985422` and was not touched) | no text conflict; `delivery/stories.json`, `internal/web/README.md`, `internal/web/handler.go` auto-merged. `merge-check-bb79ec6.txt`: one-side files = that side's blob (16 + 22), differs-from-both = both-sides set, all three = fresh 3-way `merge-file`; stories.json by value: main's 43 entries unchanged and in order, 86bcm902a last with `[101]`; EXIT=0 |
| 19:04–19:17 | `b65f797` (unchanged at 19:03:15, 19:04, 19:17:09) | gates on `bb79ec6` (`SUMMARY-bb79ec6.txt`: all EXIT=0; Postgres 604 pass, 4 accepted skips, 287 declared tests ran; 5 AC tests pass), pushed `bb79ec6` (= `origin/feat/86bcm902a-quick-start`), PR #101 body updated | CI run 40936750079 on `bb79ec6`: "Go quality gates" pass (10m20s); PR #101 MERGEABLE |

Migrations after both merges: newest `000024_pack_item_order` (#99), then `000025_quick_starts` (this story); `uniq -d` empty. Stale wording: none of this story's own lines named #98/#99/#100 or "until/once … merges"; the only "when it merges" line (`internal/onboarding/starters_test.go:12`) is about the unmerged "Role-based starter packs" branch and is still true.

## Open siblings (re-read at 19:03:15 UTC)

| Against | Head (read at) | merge-tree vs this branch | Text conflicts | Migration dupes on the merged tree | Trial (prediction, not a gate) |
| --- | --- | --- | --- | --- | --- |
| PR #100 `feat/86bcm9023-item-editor-live-preview` | `e0a07d6` (18:37:21, `FETCH_HEAD` = gh headRefOid) then `1c2f814` (18:54:47, same check) | EXIT=0 (vs `be31bad`: tree `27b5480`; vs `72ae141`: tree `d126377`, differing from `27b5480` only in stories.json) | none | none (#100 adds no migration) | on `27b5480`: gofmt, build, vet, non-DB tests EXIT=0 (`trial-pr100-be31bad.txt`). **#100 then merged into main at `b65f797` and is in this branch since `bb79ec6`.** |
| local `feat/86bcm901r-starter-packs` (no PR) | `abc60dc` (18:37:51), `805b6cd` (18:54:53, 19:03:15; it has merged `b985422` and renumbered its pair to `000025_starter_packs`) | EXIT=1 (vs `72ae141`: tree `d041c77`; vs `bb79ec6`: tree `5b34485`) | `delivery/stories.json` only | **`000025`** (`000025_starter_packs` + `000025_quick_starts`) | on `d041c77`: gofmt, build, vet EXIT=0; `go test` FAILS `TestValidateReleasedMigrationsRejectsMissingRelease` ("migration version 25 is duplicated", no DB needed); with `000025_quick_starts` renamed to `000026`: dupes none, `internal/store/postgres`, `internal/onboarding`, `internal/web` non-DB tests EXIT=0 (`trial-901r-72ae141.txt`) |

`git merge-tree origin/main 805b6cd` EXIT=0 (the starter-packs branch merges cleanly with `b65f797`). 901j and 901y are merged (#98, #99); no other open PR.

## How whoever merges second resolves "Role-based starter packs" × this story

1. `delivery/stories.json`: take the first-merged file unchanged and append the second story's entry last, as text; check every earlier entry by value.
2. Migration `000025`: the later story renames its pair to `000026` (rename only) and its "migration 25" doc line (for this story: `internal/onboarding/README.md`).
3. Product overlap (option A/B): Justin's "push the PR" was taken as B; the switch to the shared starter versions is PR follow-up 1.
4. The second merger reruns its gates on the merged tree.

Receipts: `~/.hermes/plans/leorna/evidence/86bcm902a/finisher2/` (`merge-check-*.txt`, `SUMMARY-<sha7>.txt`, `gates-*`, `pg-*`, `ac<N>-*`, `checks-*`, `gitleaks-*`, `trial-*`).

---

# Earlier check (finisher 1, before main moved; superseded above)


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
