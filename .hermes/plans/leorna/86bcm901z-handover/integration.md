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

---

# 2026-10-30: bring main in + make a PR (PR finisher)

Justin: "ok push pr" (no letter, so the recommended **A**: gates and AC tests on the merged head before pushing; the fresh review of the merge and the full verifier → auditor → `ac-check.sh` after the PR opens).

## Refs (read 2026-10-30 03:43–03:55 UTC)

| Ref | SHA | How it was read |
| --- | --- | --- |
| GitHub `main` | `5e6863d45bfca25d6c64be115cf9b5142eac7447` (#103 merged; parents `8aa32a1` + `b4acb2f`) | HTTPS fetch through gh at 03:43, equal to `gh api …/commits/main` at 03:43 and 03:54 |
| Story head before | `4904333a8fe0def527ad32603e115f2499c6cef8` | worktree, clean |
| **Merge commit** | **`f10da155b9f35e72c35645efea3d20121b72d69f`** (parents `4904333` + `5e6863d`, tree `c60877c1d5e10ea73a863a60d4b5584530484902`) | `git commit -m "Merge branch 'main' into feat/86bcm901z-customise-shipped-item"`, Leorna identity |
| Open PR #104 (many packs overview) | `0568191b1e7ade702538d2c3b43153fe63eb8e20` | `pull/104/head` into this worktree's `FETCH_HEAD`, equal to `gh pr view 104 --json headRefOid` at 03:47 |

## The merge

- `5e6863d`'s tree equals #103's head `b4acb2f`'s tree, so section 2's stacked trial (`--merge-base=8aa32a1 fda4f69 b4acb2f`) was an exact prediction: **`git write-tree` before committing gave `c60877c`, the stacked trial tree, byte for byte.**
- Conflicts: exactly the predicted four (`delivery/stories.json`, `internal/audit/README.md`, `internal/store/postgres/store_test.go`, `internal/web/library.go`). Resolved by `~/.cache/86bcm901z-pr/resolve.py`, which asserts for each block that removing one side's addition gives back the other side's text:
  - `stories.json`: main's file unchanged plus this entry appended last as text (main's 46 entries equal by value and in order, `86bcm901z` 47th);
  - audit README: main's quick start paragraph, blank line, this story's paragraph;
  - `store_test.go`: `"quick_starts", "library_variants"` in both table lists and `quick_starts, pack_script_approvals, library_variants, library_items` in `resetDatabase`;
  - `library.go`: this story's lede line, then #102's Starter packs section unchanged.
- Renumber: `git mv` `000025_library_variants.{up,down}.sql` → `000027_…` (blobs `e712ef5` / `1c6d804` unchanged); `internal/library/README.md` "(migration 25)" → 27 and "migration 25's down" → 27. `uniq -d` over up and down versions: empty; the list ends 25 `quick_starts`, 26 `starter_packs`, 27 `library_variants`.
- Both-sides set (11): `cmd/control-plane/main.go`, `contracts/control-plane.openapi.yaml`, `delivery/stories.json`, `internal/audit/README.md`, `internal/library/README.md`, `internal/pack/README.md`, `internal/store/postgres/store_test.go`, `internal/web/README.md`, `internal/web/handler.go`, `internal/web/library.go`, `packages/contracts/controlplane.gen.go`. #103 added `openapi.yaml` and `controlplane.gen.go` to the set (both merge cleanly).

## Merge proof (`evidence/86bcm901z/pr/merge-proof-f10da15.log`, FAIL COUNT=0)

- One-side files: 21 story-only files equal `4904333`'s blob (plus the renamed pair, absent at the old path); 38 main-only files equal `5e6863d`'s; no deletions on either side.
- Renumber: the 27 blobs equal the old 25 blobs; `internal/library/README.md` equals `git merge-file -p` except two lines that differ only by 25 → 27.
- Seven both-sides files equal git's clean 3-way result (`git merge-file -p`); the four conflicted ones are the hand-resolved set.
- Evil merge: files differing from both parents = the 11 both-sides files + the two `000027` files, nothing else.
- Patch survived: 32 of 34 story files identical line for line (`-U0`, headers stripped, rename mapped); the two others differ only in the README number lines and the three `store_test.go` lines that now hold both tables.
- `gitleaks dir` over the 11 both-sides files + the renamed pair from the merged tree: no leaks.
- Stale wording: no added line names a sibling card or "until/once … merges"; the only `86bcm901z`/"company variant" line near until/once/later is the known `pack_builder.go:378` code comment about a later release.

## Pre-flight (`preflight-f10da15.log`)

Porcelain empty; authors: 1 identity, Leorna OK (20 commits: `HEAD ^b65f797 ^origin/main`); committers likewise; 0 attribution lines; no `.github` path in `origin/main...HEAD` or `b65f797...HEAD`; no `CLAUDE.md`; `merge-tree HEAD origin/main` EXIT=0 and `origin/main` is an ancestor of HEAD.

## Gates on `f10da15` (`evidence/86bcm901z/pr/SUMMARY.txt`)

| Gate | Result | Log |
| --- | --- | --- |
| `make check` (CI's golangci-lint 2.14.0 / govulncheck v1.7.0 bound, fresh `leorna_86bcm901z_pr_test`) | EXIT=0 | `make-check-f10da15.log` |
| `scripts/test-module-add.sh` | EXIT=0 | `module-add-f10da15.log` |
| Postgres `go test -json` stream (dbcheck, store/postgres, web, variant, textdiff) | go test EXIT=0; first reading VERDICT BAD = exactly #103's five `TestContentUsage*` skipping on `LEORNA_TEST_CLICKHOUSE_URL` (the reader's allowlist predated #103); re-read with those allowed: VERDICT OK, 349 declared, 342 pass, 424 subtests pass, 7 allowed skips, 0 fail, no DB-URL skip | `pg-summary-f10da15.txt`, `pg-summary-f10da15-clickhouse-allowed.txt`, `pg-f10da15.json` |
| gitleaks `b65f797..HEAD` (80 commits) | EXIT=0 | `gitleaks-story-f10da15.log` |
| story-shippable unittest | EXIT=0, 5 tests | `story-shippable-unittest-f10da15.log` |
| `stories.json` by value | EXIT=0 | `stories-by-value-f10da15.log` |
| AC1–AC4 alone by name | each EXIT=0, 0 fail, 0 skip (7/5/8/14 subtests) | `ac1..4-f10da15.log` |
| Startup probe (real binary `vcs.revision=f10da15`, `vcs.modified=false`, dev mode, loopback, fresh DB, HTTP only) | EXIT=0 on rerun: library 43 + 4 starter packs loaded; Starter packs section, builder and lede; customise → variant page; chip; builder checkbox; `/admin/packs` 200; 0 error lines. First run's only BAD was the probe's own check expecting `&#39;` for literal template text | `startup-probe-f10da15.log`, `startup-probe-f10da15-lede-check-bug.log` |

## Sibling PR #104 (`sibling-104-f10da15.log`)

- #104 is based on `8aa32a1` (main `5e6863d` is not in it) and adds no migration.
- `git merge-tree origin/main #104` → EXIT=1: `delivery/stories.json` and `internal/store/postgres/pack_versions.go`. These are #104's own conflicts with #103's content on main.
- `git merge-tree f10da15 #104` → EXIT=1: the same two. This story doesn't touch `pack_versions.go`, so only `stories.json` (both append last) is this story's; whichever merges second takes the other's file and appends its own entry.
- Seven files both change (`cmd/control-plane/main.go`, `delivery/stories.json`, `internal/pack/README.md`, `internal/web/README.md`, `internal/web/handler.go`, `internal/web/pack_versions.go`, `pack_versions_test.go`) otherwise auto-merge. No top-level name added by both in the same package; #104's added lines call none of the four functions this story changed or removed (`loadLibraryItems`, `clearFileBodies`, `newItemErrorWithFiles`, a renamed test).
- Not done: a compile trial of the stacked tree, because it needs #104's own `pack_versions.go` resolution against main (a choice for #104's owner).
