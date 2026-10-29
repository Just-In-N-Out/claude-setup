# 86bcm902w integration check (finisher, 2026-10-29, read-only)

Story heads: control plane `de5fbe0755a41e0528815ef3b72509aeadb20c3c` (base `b65f797`, 12 commits), client `db3e6b0f76652088c11fafa8c3c54509f62116f7` (base `f105e27`, 6 commits). Both worktrees clean; nothing committed, pushed or changed by this check.

## GitHub `main` (fetched over HTTPS through gh, compared with `gh api repos/LeornaAI/<repo>/commits/main`)

| Repo | GitHub `main` | `origin/main` after fetch | Moved since the story's base? |
| --- | --- | --- | --- |
| leorna-control-plane | `e2254e0100a482b9201edf9b96f01936e4486d44` | same | **Yes**: PR #101 "One-click quick start" merged 20:23 UTC (27 commits, 19 files) |
| leorna-client | `f105e27814b6efbec67059687963e722933acec2` | same | No (= base) |

Fetched 22:01 UTC; rechecked at 22:06 and 22:15 UTC (both `main`s unchanged; #102 still at `1aa8ca3`; story heads unchanged and clean).

## Open sibling PRs

- 22:01 UTC: none open in either repo.
- 22:06 UTC: control plane **#102** "Role-based starter packs" opened (head `1aa8ca3107d1a0dbde3da57737ae7ac2e8182e4c`, base `main`, MERGEABLE). `pull/102/head` was fetched read-only into a scratch copy's `FETCH_HEAD`; `FETCH_HEAD` = `headRefOid` before any merge-tree was trusted.
- Client: none open.

## Control plane: this story vs GitHub `main` (`e2254e0`)

`git merge-tree --write-tree --name-only HEAD origin/main` → **exit 1**, one conflicted file:

| File | Both sides changed? | Result | Resolution |
| --- | --- | --- | --- |
| `delivery/stories.json` | yes (#101 appended 86bcm902a; this story appended 86bcm902w) | **text conflict** | Take main's file unchanged and append the 86bcm902w entry last, as text (never re-dump the JSON). Every earlier entry stays equal by value. |
| `internal/web/handler.go` | yes | auto-merged | Keep both sides: #101's three `/admin/quick-start` routes, its `Handler` fields and setup-banner link; this story's `GET /admin/content-usage` route and its "Content usage" nav link. #101 doesn't touch the nav line. The merged file equals git's clean 3-way `merge-file` result. |
| `README.md` | yes | auto-merged | Keep both sections: #101's quick-start rows and paragraph; this story's `/admin/content-usage` sentence under "Usage dashboard and captured metrics". Equals git's clean 3-way result. |

**Migrations:** this story adds **no** Postgres migration (only the additive ClickHouse table `item_uses_v1`). Main has `000024_pack_item_order` (#99) and `000025_quick_starts` (#101). The trial merge has no duplicate version (`ls … | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` is empty).

**Contract:** #101 changed no OpenAPI or generated file, so the client's copy still equals the control plane's after the merge (both `cmp` checks below).

### Trial of that resolution (a prediction, not a gate)

Done in a detached scratch worktree at `de5fbe0` (`git merge --no-commit --no-ff origin/main`, resolution staged, never committed; the worktree was removed afterwards with `git worktree remove --force <own path>`). The story branch was not touched.

- `stories.json`: 44 → 45 entries; every earlier entry unchanged by value and in the same order; the last entry is 86bcm902w and equals the branch's entry by value. Resolved file sha256 `57bbc8781f91f640…`.
- **Predicted merged tree: `369322c6686ae1407030225092c6b64304e7ad63`.** If GitHub `main` is still `e2254e0` when main is brought in, the real merge commit's `git rev-parse HEAD^{tree}` must equal this id; that one comparison proves the merge equals this trial.
- Files only one side changed: all 15 story-only and all 16 main-only files equal their side's blob.
- Files whose merged content differs from both parents: exactly the three both-sides files above (no evil-merge edit elsewhere).
- This story's own patch survives file by file (`git diff -U0`, all 18 story files, index and `@@` lines stripped): 0 mismatches.
- No stale "until/once … merges/later" wording naming this card or 86bcm902a anywhere in the tracked tree.
- Toolchain Go 1.27.3 (`GOTOOLCHAIN=local`), `/usr/local/bin` kept on PATH, no DB variables set:
  - gofmt on every tracked `.go` file: clean (EXIT=0)
  - `go build -buildvcs=false ./...`: EXIT=0
  - `go vet ./...`: EXIT=0
  - `go test -count=1 ./...` (DB tests skip without the variables): EXIT=0, 44 packages ok, 0 FAIL
  - `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: 5 tests OK
  - `cmp` client `usage/testdata/items/upload.golden.json` (db3e6b0) ↔ trial `internal/web/testdata/content_usage_client_upload.json`: EXIT=0
  - `cmp` client `api/control-plane.openapi.yaml` (db3e6b0) ↔ trial `contracts/control-plane.openapi.yaml`: EXIT=0
- Not run in the trial (they run on the real merged head): Postgres/ClickHouse tests, `make check` (lint, govulncheck, gitleaks, library gate, contracts-check), `test-module-add.sh`.

## Control plane: this story vs open PR #102 (86bcm901r starter packs, `1aa8ca3`)

- `git merge-tree --write-tree --name-only de5fbe0 FETCH_HEAD` → exit 1, only `delivery/stories.json` (`handler.go` and `README.md` auto-merge).
- `git merge-tree origin/main FETCH_HEAD` → exit 0 (#102 already has `e2254e0` merged in, so it doesn't conflict with main).
- Overlap with this story: `delivery/stories.json`, `internal/web/handler.go`. #102 adds migration `000026_starter_packs`; this story adds none, so no renumbering either way.
- Stacked trial (prediction): `git merge-tree --write-tree --merge-base=e2254e0 369322c6… 1aa8ca3` (main + this story, then #102) → only `stories.json` conflicts. Resolved as #102's file unchanged + 86bcm902w last (45 → 46 entries, #102's entries equal by value). No conflict markers left, no duplicate migration (24, 25, 26), both `/admin/content-usage` and #102's routes present. Build/vet/non-DB tests on that tree: see "Stacked trial result" below.
- **Whichever of #102 and this PR merges second** resolves `stories.json` the same way (main's file unchanged, its own entry last) and needs nothing else.

### Stacked trial result

On the archived stacked tree (`961c0eff…` with `stories.json` resolved), Go 1.27.3, no DB variables: gofmt clean, `go build -buildvcs=false ./...` EXIT=0, `go vet ./...` EXIT=0, `go test -count=1 ./...` EXIT=0 (44 packages ok, 0 FAIL), `test_story_shippable.py` 5 OK. A prediction only: no Postgres/ClickHouse tests, lint or audit ran on it.

## Local sibling branches (not PRs; read-only refs, for the record)

| Branch | Head | vs this story | vs `main` | Notes |
| --- | --- | --- | --- | --- |
| `feat/86bcm901b-prompts-collection` | `1c1d276` | clean | clean | 1 commit ahead of main. |
| `feat/86bcm901z-customise-shipped-item` | `08c09b8` | `stories.json` only | **conflicts with main** (its own `000025_library_variants` collides with #101's `000025_quick_starts`) | Also edits `contracts/control-plane.openapi.yaml` and `packages/contracts/controlplane.gen.go`, which merge with this story's edits without a text conflict. Whichever of the two merges second must re-run `make check` (its `contracts-check` regenerates and compares) and, if 901z's spec is already on main, copy the merged spec to the client again so the client snapshot stays equal (this story's `cmp` tie). |

## Client: this story vs GitHub `main` (`f105e27`)

- `origin/main` is the story's base and an ancestor of `db3e6b0`: `git merge-tree --write-tree --name-only HEAD origin/main` → exit 0, no conflict. Nothing to bring in.
- No open client PR.
- The client README links to the control plane's `internal/metric/content-usage-spike.md` on GitHub `main`; that link resolves once the control-plane PR merges (one more reason for D11's order: control plane first).

## Merge order (plan D11)

1. Control plane first, then the client.
2. Only the control plane merged: the page works (empty until uploads); `/v1/usage` and `/v1/client/usage` accept item uses; nothing sends them yet. Harmless.
3. Only the client merged: `import-content-usage` fails with "usage upload rejected; verify login and server availability" (the old server refuses the unknown `itemUses` field with 400); nothing is stored; `import-codex-usage` is unaffected.

## "Bring main in": what the one-word OK does (asked together with "make a PR")

Approving **"bring main in"** with **"make a PR"** authorizes exactly this, control plane only (the client needs no bring-in):

1. In the control-plane story worktree on `feat/86bcm902w-content-usage-analytics`, fetch GitHub `main` over HTTPS through gh and record its SHA. If it is still `e2254e0`, continue; if it moved (for example #102 merged), re-run the trial against the new `main` first and stop if anything beyond `stories.json` conflicts.
2. `git merge --no-ff origin/main` (no rebase, no force-push). Resolve `delivery/stories.json` exactly as above (main's file unchanged + the 86bcm902w entry appended last as text; earlier entries checked by value); take git's automatic merge for `README.md` and `internal/web/handler.go`.
3. Prove it: `git rev-parse HEAD^{tree}` after the merge equals the trial's `369322c6686ae1407030225092c6b64304e7ad63` (when `main` is still `e2254e0`); otherwise the full one-side/both-sides/patch-survives checks above.
4. Commit with `git commit -m "Merge branch 'main' into feat/86bcm902w-content-usage-analytics"` as the Leorna identity (no AI lines).
5. On the merged head: the control-plane gates (`make check` with CI's golangci-lint 2.14.0 and govulncheck v1.7.0 bound and `/usr/local/bin` on PATH, `test-module-add.sh`, the `go test -json` skip check over the DB packages with Postgres and a ClickHouse container restarted from the plan's pinned image as in T0.5), each AC test by name, and both `cmp` ties with the client head. Per the standing rule after ALL ACCEPTED, no new verifier/auditor for a record-file-only bring-in; the full verifier → blind auditor → `ac-check.sh` runs again on the PR head once the last sibling has merged.
6. Then "make a PR" proceeds as the `leorna` skill's step 7 (push both branches, open both PRs, control plane first), and a later small commit records both PR numbers in `stories.json`.

Nothing in this list merges a PR or posts to ClickUp.

## 2026-10-29 22:31–22:35 UTC: main brought in (PR finisher, Justin approved "bring main in" + "make a PR")

- GitHub `main` fetched over HTTPS through gh at 22:31 UTC and compared with `gh api repos/LeornaAI/<repo>/commits/main`:
  - control plane `8aa32a1f68fadacb8b0514566dd465ff14b883b9` (PR #102 "Role-based starter packs" merged as a merge commit on top of `e2254e0`); `origin/main` equals it. `git rev-parse 8aa32a1^{tree}` = `1aa8ca3^{tree}` = `65a09dd2…`, so main is exactly the #102 head the stacked trial used.
  - client `f105e27814b6efbec67059687963e722933acec2` = the story's base: nothing to bring in.
- `git merge-tree --write-tree --name-only de5fbe0 origin/main` → exit 1, only `delivery/stories.json` conflicts; `README.md` and `internal/web/handler.go` auto-merge (as trialled).
- `git merge --no-ff origin/main` in the story worktree; `delivery/stories.json` resolved as main's file unchanged plus the 86bcm902w entry appended last, as text: 45 → 46 entries, every earlier entry equal by value and in the same order, the last entry equals the branch's entry by value; no conflict markers; `test_story_shippable.py` 5 tests OK. Resolved file sha256 `b640b719…`.
- **Merge commit `b78905b7acc2de7b8494ead1cde28a704004a774`** (parents `de5fbe0`, `8aa32a1`), message `Merge branch 'main' into feat/86bcm902w-content-usage-analytics`, author Leorna OK, no AI lines.

### Merge proof (7.2) on `b78905b`

| Check | Result |
| --- | --- |
| Files changed on one side only equal that side's blob | 44 of 44 (15 story-only = `de5fbe0`'s blob, 29 main-only = `8aa32a1`'s blob); no deletions on either side |
| Files whose merged content differs from both parents (`comm -12` of each parent's diff) | `README.md`, `delivery/stories.json`, `internal/web/handler.go` = exactly the both-sides set: no evil merge |
| Both-sides files vs git's clean 3-way `merge-file` | `README.md`, `internal/web/handler.go` equal it (0 conflicts); only `stories.json` is hand-resolved (checked by value above) |
| Story's own patch survives (`git diff -U0`, `index`/`@@` lines stripped, `b65f797→de5fbe0` vs `8aa32a1→b78905b`) | 18 of 18 files identical |
| Duplicated migration version (`… grep '\.up\.sql$' \| cut -d_ -f1 \| sort \| uniq -d`) | empty; newest are `000024_pack_item_order`, `000025_quick_starts`, `000026_starter_packs`; this story adds none |
| `gitleaks dir` over the 3 both-sides files taken from the merged tree (gitleaks 8.30.1) | no leaks, EXIT=0 |
| Stale wording: this card's ID next to until/once/later anywhere in the tracked tree | none |

- Note for the review of the new commits: #102's role starter packs are shared pack versions with no tenant (`internal/pack/starter.go`: "shared like the seed base"). The content usage page's pack rule already covers shared versions (company's own version wins; a shared version counts only when the company has none of that name), so starter packs appear as pack rows like the seed. No code conflict; the gates below run on the merged tree.
- Open PRs at 22:35 UTC: none in either repo.

### Gates on the pushed heads (22:35–22:37 UTC) and the PRs

- Gates: `~/.hermes/plans/leorna/evidence/86bcm902w/pr/SUMMARY.txt` (one log per gate). Control plane `b78905b`: pre-flight, AC1–AC5 (no skips), `make check` (CI's golangci-lint 2.14.0 / govulncheck v1.7.0 bound), `test-module-add.sh`, gitleaks `b65f797..HEAD`, story-shippable unittest, `go test -json` skip check (703 pass, 0 fail, 339/339 declared top-level ran, only the two accepted skips): all EXIT=0, on `leorna_86bcm902w_pr_test` + `leorna-test-ch-86bcm902w` (CI's pinned image). Client `db3e6b0`: `make check`, node UI tests 39/39, `make lint audit` (0 issues, no vulns), 15 story tests, real Claude Code 2.1.312, `cmp` golden and OpenAPI against `b78905b`'s files: all EXIT=0. The client's first pre-flight log is EXIT=1 only because it also scanned the whole tracked tree and matched main's vendored `vendor/github.com/labstack/echo/v4/CLAUDE.md`; the rerun with the rule as written (no `CLAUDE.md` in the diff) is `client-db3e6b0-preflight-diff-only.log`, EXIT=0.
- Pushed `feat/86bcm902w-content-usage-analytics` to both repos over HTTPS through gh (account Justin-Leorna); fetched back into `origin/<branch>`, upstream set, `HEAD` = `origin/<branch>` in both.
- **Control-plane PR #103** (opened at `b78905b`), then `fabbec0` "docs(86bcm902w): record PRs #103 and LeornaAI/leorna-client#23 in the delivery inventory" (only the 86bcm902w PR lists change; story-shippable unittest OK) pushed on top: PR head `fabbec00fa8428bf7e014ba06350efe796002c1c`, MERGEABLE.
- **Client PR #23** at `db3e6b0f76652088c11fafa8c3c54509f62116f7`, MERGEABLE; its body says it merges after LeornaAI/leorna-control-plane#103.
- Hosted CI: control plane run 40967518059 on `b78905b`: all 3 jobs success. Client run 40968292489 on `db3e6b0`: "Go quality gates" and "Clean Windows tool installation" success, **"Windows client executable" failure, from the branch**: `TestManagedItemsFromLastSuccessfulSync` and `TestOpenReadOnlyNeverMigrates` (`application/managed_items_test.go`, added in `164014f`) compare the managed Claude project root with the fixture's `t.TempDir()` path, which on the Windows runner is the 8.3 short form (`C:\Users\RUNNER~1\…`) while `ManagedItems` returns the long form (`C:\Users\runneradmin\…`); the second test's TempDir cleanup error ("leorna.db … used by another process") follows from its `t.Fatalf` skipping `app.Close()`. Client `main`'s latest run (`f105e27`) passed this job. Not fixed by the finisher.
- 23:11 UTC: control plane run 40969718620 on the PR head `fabbec0`: "Go quality gates", "Publish control-plane image", "Package admin-portal distribution" all success. `gh pr checks`: #103 3 pass; client #23 2 pass, 1 fail (Windows, above). Open PRs at 23:11 UTC: only #103 and client #23; GitHub `main` still `8aa32a1` / `f105e27`. Both PR bodies updated with the final heads and run URLs (live body equals the file copy).
- Cleanup: `leorna-test-ch-86bcm902w` removed with its anonymous volume; `leorna_86bcm902w_pr_test` dropped; `leorna_86bcm902w_builder_test` left in place.
