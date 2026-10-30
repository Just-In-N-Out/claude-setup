# 86bcm901z: integration check (finisher, 2026-10-29)

Everything below is a **prediction** made in detached scratch copies. The story branch, its worktree and every ref except `refs/remotes/origin/main` and the scratch copies' own `FETCH_HEAD` are unchanged. Nothing was committed, pushed or merged.

## Where things stand (read 2026-10-29 23:59 UTC)

| Ref | SHA | How it was read |
| --- | --- | --- |
| Story head (`feat/86bcm901z-customise-shipped-item`) | `4904333a8fe0def527ad32603e115f2499c6cef8` | `git rev-parse HEAD`; worktree clean (`git status --porcelain` empty) |
| Story base | `b65f797ff6cdc56a802dfaf417b0adec96463317` | plan |
| GitHub `main` | `8aa32a1f68fadacb8b0514566dd465ff14b883b9` | HTTPS fetch through gh into `refs/remotes/origin/main` at 23:52 UTC, equal to `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` at 23:52, 23:59 and 2026-10-30 00:08 |
| Open PR #103 (content usage analytics, 86bcm902w) | `b4acb2f82016990587371a46279c88f416152c42` | `pull/103/head` fetched into a scratch copy's `FETCH_HEAD`; equal to `gh pr view 103 --json headRefOid` at 2026-10-30 00:08 UTC. It was `fabbec0` at 23:55; two commits landed while this was written, so both heads were trialled |

- **Main has moved past the base.** Since `b65f797`, GitHub `main` merged **#101** (one-click quick start, migration `000025_quick_starts`) and **#102** (role-based starter packs, migration `000026_starter_packs`). Both are `MERGED` (`gh pr view`).
- Only one PR is open: **#103**. It already contains `main` `8aa32a1` and adds no migration.
- No PR exists for this branch (`gh pr list --head feat/86bcm901z-customise-shipped-item --state all` is empty), and no PR title or body names this card.
- The shared main checkout `~/Leorna/leorna-control-plane` is still on local `main` `e2254e0` (#101's merge), behind GitHub `8aa32a1`. I left it alone (read-only role). The bring-in uses `origin/main`, so it doesn't depend on it.

## 1. This branch against GitHub `main` (`8aa32a1`)

`git merge-tree --write-tree --name-only HEAD origin/main` → exit 1, four text conflicts (the same four as review 4's R4-1):

| File | What each side did | Resolution (trialled) |
| --- | --- | --- |
| `delivery/stories.json` | Both appended an entry after `86bcm901y` (main: `86bcm902a` [101] and `86bcm901r` []; this story: `86bcm901z` []) | Take main's file unchanged and append this story's entry last, **as text** (main's final `\n}\n` → `,\n  "86bcm901z": {…}\n}\n`). Checked by value: main's 45 entries are equal and in order, `86bcm901z` is the 46th and last. |
| `internal/audit/README.md` | Both added a paragraph after the pack-builder one (main: quick start `quickstart.skip`/`quickstart.complete`; this story: the five `library.variant.*` actions) | Keep both paragraphs: main's quick start paragraph first, then this story's, one blank line between. |
| `internal/store/postgres/store_test.go` | Same three lines on both sides: the two `TestMigrationRoundTrip` table lists and `resetDatabase`'s `DROP TABLE` list (main adds `quick_starts`; this story adds `library_variants`) | Both tables in all three: `…, "pack_lineages", "quick_starts", "library_variants", "schema_migrations"` (twice) and `DROP TABLE IF EXISTS quick_starts, pack_script_approvals, library_variants, library_items, …`. No other line of the file differs from either side. |
| `internal/web/library.go` | Same template spot: this story rewrote the lede to mention "your company's variants"; #102 kept the old lede and added the Starter packs section right after it | This story's lede line, then #102's whole Starter packs section unchanged. The other hunks in the file (CSS, page data, `renderLibrary`) merged cleanly. |

**Migration renumber (required).** Main now has `000025_quick_starts` and `000026_starter_packs`, and the story adds `000025_library_variants`: there is no text conflict, but two migrations with version 25 make `readMigrationSet` refuse to start and every Postgres test fail. The next free number is **27**:
- `git mv` both files to `internal/store/postgres/migrations/000027_library_variants.{up,down}.sql` (bytes unchanged, checked with `cmp`);
- `internal/library/README.md`: "(migration 25)" → "(migration 27)" (Lineage bullet) and "migration 25's down" → "migration 27's down" (Rollback bullet). These are the only two places the story's text names the number (grep of every added line of the story's diff for `25`/`000025`). The commit message `426e4ee feat(86bcm901z): store company variants (migration 25)` stays as history.
- On the trial merge, `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` prints nothing (the same for `.down.sql`); the list ends `000025_quick_starts`, `000026_starter_packs`, `000027_library_variants`.
- GitHub `main` never had this story's migration, so no shared database holds version 25 as `library_variants`. Only this story's own `_test` databases ran it as 25: drop them, or, since the SQL bytes are unchanged and the checksum leaves out the number, `UPDATE schema_migrations SET version=27 WHERE version=25` would recover one (not tried here; none needs keeping).

**Checks on the trial merge (predicted tree `fda4f695c0353bca974b6152b1b534755065327c`):**
- Hand-resolved files are exactly the four conflicts plus `internal/library/README.md` (the renumber). The other both-sides files (`cmd/control-plane/main.go`, `internal/pack/README.md`, `internal/web/README.md`, `internal/web/handler.go`) equal `git merge-file -p` of their three blobs, git's clean 3-way result.
- Every file only one side changed equals that side's blob (story-only files equal `4904333`'s, main-only files equal `8aa32a1`'s; none deleted).
- The files whose merged content differs from both parents are exactly the 9 both-sides files plus the renamed migration pair (different from both by design). No file neither side changed was touched.
- The story's own patch survives line for line in all 34 files (`git diff -U0 b65f797 4904333` against `git diff -U0 8aa32a1 <tree>`, index and `@@` lines stripped, the rename mapped). The only differences are the two README number lines and the three `store_test.go` lines that now hold both tables.
- Stale wording: no line the story added names a sibling or says "until/once … merges". No text in the tree defers anything to this story (grep of `86bcm901z`, "company variant", "tenant variant" next to until/once/later finds only a code comment about a later release). Main's new text doesn't mention variants.
- `delivery/stories.json`: valid JSON, earlier entries equal by value, this story last; CI's `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` → 5 tests OK (that unittest doesn't read the file, so the by-value check above is the real proof).

**Prediction gates on the trial copy** (go1.27.3, golangci-lint 2.14.0 bound through `GOLANGCI_LINT`; **no database**, so every Postgres-backed test skipped):

| Gate | Result |
| --- | --- |
| `make fmt` | EXIT=0 |
| `make vet` | EXIT=0 |
| `make build` | EXIT=0 |
| `make test` (`-race`, no `LEORNA_TEST_DATABASE_URL`) | EXIT=0, 0 FAIL lines |
| `make lint` | EXIT=0, 0 issues in both modules |
| `make contracts-check` | EXIT=0 |
| `make library-check` | EXIT=0, library-gate PASSED |

This is not a gate run: the Postgres tests, `make check` as a whole, `test-module-add.sh` and the AC tests have not run on a merged head.

The resolution is saved as `trial-main-resolution.patch` (the story head's version of each hand-resolved file → the predicted merge, with the rename) in this folder.

## 2. Against the open sibling PR #103 (content usage analytics)

#103's head moved from `fabbec0` to `b4acb2f` during this check: two commits (`7f05c9c` hides replaced shared pack versions, `b4acb2f` is docs). They touch 8 files, none of them this story's, but two this story builds on (`internal/pack/version.go`, `internal/store/postgres/pack_versions.go`). Both heads were trialled; the results are the same.

- `git merge-tree origin/main <#103 head>` → exit 0 for both heads: #103 is up to date with `main`.
- `git merge-tree HEAD fabbec0` → exit 1, the same four conflicts as above. They come from `main`'s content inside #103, not from #103's own work.
- **#103 stacked on the predicted merge** (`git merge-tree --write-tree --merge-base=8aa32a1 fda4f69 <#103 head>`): one conflict, `delivery/stories.json`, where both append last. `contracts/control-plane.openapi.yaml`, `packages/contracts/controlplane.gen.go` and `internal/web/handler.go` (files #103 and this story both change) merge cleanly.
  - Resolution, whichever merges second: take the other's merged file and append its own entry last as text. Trialled with #103 first: #103's 46 entries equal and in order, `86bcm901z` 47th. #103's `stories.json` is the same at both heads.
  - Stacked trees `b1bc17bbd6009f9606d2a73427bb045b7419668e` (`fabbec0`) and `c60877c1d5e10ea73a863a60d4b5584530484902` (`b4acb2f`): `make fmt`, `vet`, `build`, `test` (no DB), `lint`, `contracts-check` and `library-check` all EXIT=0 on both. `contracts-check` matters here: it regenerates the client and server code from the merged OpenAPI file and compares, so the cleanly merged generated file is consistent.
  - No migration clash: #103 adds none (its new table is ClickHouse `item_uses_v1`).
  - Behaviour: #103 counts item uses by kind and name from pack versions' items. A variant in a pack is copied into the pack version under its own name, so it is counted like any other item. Nothing to change on either side.

## 3. What "bring main in" will do (asks for Justin's OK together with "make a PR")

One phrase, e.g. **"bring main in and make a PR"** plus a letter for the question at the end, would approve this. Not done yet; nothing below has run on the real branch.

1. In the story worktree: fetch GitHub `main` over HTTPS through gh again and record its SHA. If it is still `8aa32a1`, the trial applies as written; if it moved, re-run this check first.
2. `git merge --no-ff --no-commit origin/main` (no rebase, no force-push), with the resolutions above:
   - `delivery/stories.json`: main's file plus this entry last, as text; check by value;
   - `internal/audit/README.md`: both paragraphs, main's first;
   - `internal/store/postgres/store_test.go`: both tables in all three lists;
   - `internal/web/library.go`: this story's lede, then #102's Starter packs section.
3. In the same merge commit, renumber `000025_library_variants.{up,down}.sql` → `000027_…` with `git mv`, and change the two "migration 25" lines in `internal/library/README.md` to 27. Check the `uniq -d` list is empty.
4. Commit with `git commit -m "Merge branch 'main' into feat/86bcm901z-customise-shipped-item"` (not `--no-edit`). If main hasn't moved, `git rev-parse HEAD^{tree}` must equal the predicted `fda4f695c0353bca974b6152b1b534755065327c`.
5. Prove the merge as the `leorna` skill's step 7.2 describes:
   - one-side files equal their side;
   - the both-sides set matches the files that differ from both parents;
   - the story's own patch survives;
   - the renamed blobs are equal;
   - `gitleaks dir` over the both-sides files from the merged tree.
6. Re-run the gates on the merged head in a detached copy with its own `_test` database:
   - `make check` with CI's linter and govulncheck bound;
   - `bash ./scripts/test-module-add.sh`;
   - the per-test Postgres `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/variant ./internal/onboarding`;
   - AC1–AC4 by name;
   - #101's and #102's own tests (`TestMigrationRoundTrip` with all three new tables);
   - a startup probe of the real binary on a fresh DB (`EnsureLibrary` then the starter-pack load, then `/admin/library` and a variant page), since #102 adds startup rows this story's fixtures predate.
7. Then "make a PR" (`leorna` step 7): re-run the gates on the exact head, push, open the PR, then add the PR number to `delivery/stories.json` in a small follow-up commit.

**Justin's decision with the OK: verify again after the merge?** The standing rule (memory note "no re-verify while main moves") is gates plus AC tests only after a bring-in, and a full verifier → blind auditor → `ac-check.sh` once the last sibling (#103) has merged, on the PR's head. But it also says to ask when a bring-in resolves real code, not only record files. This one does: the `library.go` template, the `store_test.go` table lists and the migration renumber.
- A ⭐ gates + AC tests on the merged head now, plus a fresh review of the merge commit; the full verifier → auditor → `ac-check.sh` after #103 merges. The review covers the hand-resolved code and lets `ac-check.sh --reviews` accept the merge commit later.
- B gates + AC tests only; full verification after #103 merges.
- C the full fresh review → verifier → auditor → `ac-check.sh` now, and again after #103 merges.

If #103 merges first, step 2's `stories.json` resolution takes #103's file and appends this entry last. Nothing else changes; the stacked trial above covers it.
