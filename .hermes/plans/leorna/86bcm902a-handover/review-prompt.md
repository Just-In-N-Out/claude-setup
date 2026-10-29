You are a fresh, independent reviewer for a Leorna control-plane story. **Review only:** no commit, push, PR, merge or ClickUp change; restore anything you change; leave `deploy/local/` alone; never run `git worktree prune`; never touch other stories' worktrees, branches or databases. Don't trust anyone's summary, the PR text, the evidence folder or the shared memory: check every claim yourself, in the code and with real command output.

## What to review

- Repo: `~/Leorna/leorna-control-plane` (Go). Story worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start`, branch `feat/86bcm902a-quick-start`.
- Range: `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f..9a9bdecc2f6ab53356fddddbc62b06b6533a4867` (21 commits; base = GitHub `main` as of 2026-10-29 15:46 UTC; re-check with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`).
- **Not pushed: it exists only on this machine (the Windows desktop, WSL Ubuntu), so you must run here.** Don't edit the story worktree: make your own detached copy, e.g. `git -C <worktree> worktree add --detach ~/.cache/86bcm902a-review3/head 9a9bdec`, and remove it at the end with `git worktree remove --force` on that exact path.
- 19 files, +3294/-10: `internal/onboarding/{starters,quickstart}.go` (+tests), migration `internal/store/postgres/migrations/000024_quick_starts.{up,down}.sql`, `internal/store/postgres/quick_starts.go` (+test, `store_test.go` table lists), `internal/web/quick_start.go` (+`quick_start_test.go`), small edits to `internal/web/setup.go`, `internal/web/handler.go`, `cmd/control-plane/main.go`, four READMEs and `delivery/stories.json`. No OpenAPI and no client change.

## The card: [One-click quick start (starter pack → team → sync)](https://app.clickup.com/t/86bcm902a) (E11 Pack Builder, PI-2, Size M, p1-high)

> As a new admin, I want a guided quick start that picks a starter pack and assigns it to a team, so that my engineers are syncing real content within minutes of install.
> Context: extends the existing onboarding wizard / post-install setup.
> AC (test-backed):
> - Given a fresh install, when I finish setup, then the quick start offers role-based starter packs
> - Given I choose a pack and a team, then the assignment is created and engineers' next sync delivers it
> - Given the quick start, then it can be skipped and resumed later
> Verify: end-to-end demo on a fresh install (recorded).
> DoD: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
> Dependencies: 86bcm901r "Role-based starter packs" (still to do; being built on another branch) and 86bcm901w "Create a pack by picking library items" (merged, PR #96). Repo: control-plane.

The approved plan names one test per AC and adds AC4 and AC5:
- AC1 `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres`
- AC2 `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres`
- AC3 `TestQuickStartAC3SkipThenResumeLaterWithPostgres`
- AC4 (proposed, approved): an invalid or not-allowed request (unknown pack, no team or both a team and a new name, unknown or another company's team, team name taken, setup not finished, a member, bad CSRF, signed out) is refused with a clear status and **nothing is written** (no team, pack, assignment, quick-start row or audit record), and one company's quick start never shows or changes another's: `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres`
- AC5 (proposed, approved): fresh install (empty DB, auto setup on), admin picks Backend and names a new team, setup finishes with no clicks, the team's default pack is created, and an engineer in that team's project gets the pack's files on the desktop client's first sync: `TestQuickStartAC5FreshInstallEndToEndWithPostgres`

## Decisions Justin already made (check they're implemented; don't re-argue them)

- Q1-A: a **stand-in** for 86bcm901r: the four role packs from 901r's proposed mapping in `internal/onboarding/starters.go` (Backend, Frontend, Platform/DevOps, Secure coding (regulated); `/plan` ships as prompt `planning`; pack names match 901r's branch). A company's pack is created on pick through 901w's `CreatePack` from the newest stored library items, with required items added (`Library.Required`).
- Q2-A: one `quick_starts` row per company (migration 24), audited `quickstart.skip` / `quickstart.complete`.
- Q3-A: pick an existing team or type a new team's name.
- Q4-A: AC5's "recording" is an agent-made screenshot series plus logs (no video tool here).
- Plan assumptions: state is per company; skip/pick only once setup is ready (409 before); a new team made by a failing pick stays; an existing pack with the starter's name (as the pack name index compares names) is reused at its latest version and the done sentence says so; the quick start sets the **team default** (a project override still wins); no JSON API / OpenAPI change.
- **Still open, Justin's call (don't decide it, but say if the code makes either option harder):** A) merge 86bcm901r first and rebuild this story on 901r's shared starter versions, or B) ship this branch first with the stand-in.

## Earlier findings and the claimed fixes (re-check each)

Review 1 on `7b45d43` → fixer 1 → `707a4c0`:
- F1 client disconnect mid-pick left a new team with no pack → the pick runs on `context.WithoutCancel(r.Context())` with a 30 s timeout; test `TestQuickStartPickFinishesWhenTheBrowserGoesAwayWithPostgres`.
- F2 pack reuse matched more names than the unique index (Go `EqualFold` folds `ſ`) → `CreatePack` first; only on `pack.ErrNameTaken` does `PackByName` read the pack with SQL `lower(btrim(name))`; the done sentence says "your existing pack"; test `TestQuickStartDoneSaysWhatThePickDidWithPostgres`.
- F3 role mapping unpinned → `TestStartersPinTheRoleMapping` (literals).
- F4/F6 setup lock unproven and a busy pick silent → AC4 `busy_setup_lock`; redirect to `/admin/quick-start?notice=busy` with a fixed sentence.
- F5 skip route without `requireAdmin` and the `quick_starts` tenant key not pinned → AC4 `member` asserts `ADMIN_REQUIRED` on all three routes; store tests.
- F7 stale "is the default pack" wording → one shared done template "X (version N) was made the default pack for Y".
- F8 card layout (CSS only).

Review 2 on `707a4c0` → fixer 2 → `9a9bdec`:
- M1 `quick_starts_done_shape` let a skipped row carry starter/pack/number/reused → two-sided CHECK, migration 000024 edited in place (never on `main`); store test `done_shape_is_enforced_by_the_database`.
- N1 the same pick again rewrote the done record as "reused" and added `pack.assign` + `quickstart.complete` → `QuickStart.changes` writes only what changed; tests `TestQuickStartApplyWritesOnlyWhatThePickChanges` (unit), `TestQuickStartTheSamePickAgainChangesNothingWithPostgres`.
- N2 "(version N)" tested only with N=1; N3 `PackByName` exactness; N4 the 30 s bound untested → `Handler.quickStartPickTimeout` (tests only) and `TestQuickStartPickIsBoundedAndReleasesTheLockWithPostgres`.

## Environment and commands

- Go 1.27.3 is **not on PATH**: `export PATH=$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`. CI's pins: golangci-lint 2.14.0 and govulncheck v1.7.0 are in `~/.local/leorna-toolchain/bin`; gitleaks 8.30.1 is `/usr/local/bin/gitleaks`. Echo each `--version` from the same PATH first.
- `/tmp` is a small RAM tmpfs: set `TMPDIR=~/.cache/86bcm902a-review3/tmp`.
- Test Postgres is the `leorna-test-pg` container on **127.0.0.1:55432** (`docker port leorna-test-pg 5432`); `leorna-pg` on 5432 is not ours, never touch it. Create **your own** database only: `docker exec leorna-test-pg createdb -U leorna leorna_86bcm902a_review3_test` (the store tests drop every table and refuse a name not ending in `_test`; never share a DB with another run). Read the password without printing it: `pass=$(docker exec leorna-test-pg printenv POSTGRES_PASSWORD); [ -n "$pass" ] || exit 1`, then `export LEORNA_TEST_DATABASE_URL="postgres://leorna:${pass}@127.0.0.1:55432/leorna_86bcm902a_review3_test?sslmode=disable"`. Drop your DB at the end (`docker exec leorna-test-pg dropdb -U leorna <name>`).
- In your detached copy:
  1. `GOLANGCI_LINT=$HOME/.local/leorna-toolchain/bin/golangci-lint GOVULNCHECK=$HOME/.local/leorna-toolchain/bin/govulncheck GITLEAKS=/usr/local/bin/gitleaks make check` (check `make -n -s lint audit secrets` shows those binaries).
  2. `bash ./scripts/test-module-add.sh`
  3. `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web > pg.json`, then read **per test** (Action plus that test's own Output), not `-v` text. Fail any skip whose reason names `LEORNA_TEST_DATABASE_URL`. The only allowed skips: `TestTeamsAPIWithPostgres`'s two ClickHouse subtests, `TestEvidenceThirdPartyContentPage` ("LEORNA_EVIDENCE_DIR is not set") and `TestProvisionManagedPostgresLive` ("SCW_LIVE=1 not set"). Check every declared top-level `Test*` in those packages reported a result.
  4. `go test -count=1 -v ./internal/onboarding/`
  5. Each AC alone: `go test -v -count=1 -run '^<AC test name>$' ./internal/web/`. Then on the base: a **separate** detached copy at `6c1709e` with its **own** `_test` DB, with the head's `internal/web/quick_start_test.go` copied in, should fail (build failure is the expected reason).
  6. `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` and `gitleaks git --redact --log-opts="6c1709e..HEAD"`.
- Known traps: `waitForStep` in the setup tests has a 5 s deadline that once timed out under load: rerun that test alone before calling it a regression. The test helper `readBody` stops at 64 KiB (a starter pack's `/content` is ~290 KB; the AC tests use their own 8 MiB bound). `make secrets` scans every local ref, including sibling branches: a finding on a commit outside this range isn't this story's.

## Mutations to try (each must still compile; grade a kill only by the expected test's own failure line)

Use `go test -overlay` or a scratch copy, never the worktree. Suggested:
- drop `requireAdmin` from each of the three routes (`internal/web/handler.go`), one at a time;
- `SkipQuickStart` / `CompleteQuickStart` opening `beginOrg(…, false)` (no admin re-check);
- drop the own-team check in `CompleteQuickStart`, or widen `quickStartTx`'s `WHERE q.tenant_id=$1`;
- `Apply` creating the pack before the team check, or skipping `GetTeam` (trap: `other_company_team` can stay green because a later check refuses; grade on `unknown_team`, the first refusal that reaches it);
- `ResolveStarters` skipping the `Required` closure;
- remove `TrySetupLock` around the pick, or drop the not-ready check;
- `context.WithoutCancel` removed (the browser-gone test);
- `PackByName` matching part of a name; `SkipQuickStart` overwriting a done row;
- the setup panel shown before setup is ready; the done sentence's version number hard-coded to 1;
- the done-shape CHECK loosened (insert a skipped row with a starter).

The builder ran 79 mutants (77 killed; X30, X34 graded harmless by review 2), the verifier 27 (all killed), the auditor 16 (15 killed; M1c, a card's role title rendered as its key, passes AC1). Don't trust those numbers: try your own.

## Also check

- Security and tenant isolation: admin-only routes, form CSRF (4 KiB body bound), every query tenant-keyed, the `(tenant_id, pack_id)` FK, no cross-tenant read through the joins, notices never echo input, audit values hold ids/status/starter key/version number and no names, no auth bypass or dev-login change.
- The migration: expand-only (one table), the down drops it, `TestMigrationRoundTrip` lists the table; behaviour for companies that finished setup before this change (no row = offered).
- Docs claims true as written: `internal/onboarding/README.md` "Quick start (86bcm902a)", `internal/web/README.md`, root `README.md` authorization row, `internal/audit/README.md`.
- `delivery/stories.json`: `86bcm902a` appended last with `prs: []` (no PR yet, so empty is right), earlier entries unchanged by value.
- Commits: every author and committer `Justin Issa` with the Leorna address; no body line matching `^co-authored-by:|generated with|noreply@anthropic|🤖` (case-insensitive).
- No `.github/` change, no OpenAPI change.
- Merge risk: `git merge-tree --write-tree --name-only HEAD origin/main` (after an HTTPS fetch through gh), and against the open siblings: PR #98 (`gh pr view 98 --json headRefOid`, fetch `pull/98/head` read-only and check `FETCH_HEAD` equals it), local branches `feat/86bcm901r-starter-packs` and `feat/86bcm901y-remove-reorder` (read their refs only). Expect `delivery/stories.json` conflicts, a duplicated migration `000024` with 901r and 901y (`ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` on each trial tree), and with 901y a compile break at `internal/web/quick_start_test.go:1146` (`SaveVersion`'s new `pack.VersionChange` argument). Say whether the hand-over's resolutions are right.

## Report format

1. One-line verdict: Ready / Ready with nits / Not ready.
2. Per-AC and DoD table: criterion → test → your own run's result → evidence (command and output excerpt).
3. The real output of each gate (exit codes), the per-test Postgres read (counts, skips with reasons, missing tests).
4. Mutation table: mutant → expected test → killed/survived, with the failing line.
5. Issues, each labelled introduced or pre-existing, with severity (critical / major / minor / nit), file:line and a suggested fix. Separate the open A/B question from findings.
6. What you changed and how you restored it (worktree list and `git status` before and after; your DB dropped).
