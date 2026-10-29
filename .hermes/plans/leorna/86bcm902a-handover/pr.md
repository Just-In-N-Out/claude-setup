Title: feat(86bcm902a): one-click quick start (starter pack → team → sync)
PR: #101 https://github.com/LeornaAI/leorna-control-plane/pull/101 (open, not merged; head bb79ec683832542bca271307b7a3fb31085664d0; "Go quality gates" pass on bb79ec6, run 40936750079). Body below = ~/.hermes/cache/scratch/leorna-pr-86bcm902a-quick-start.md, as posted with gh pr edit on 2026-10-29.

## Summary

Right after a new admin finishes setup, the setup page now offers a one-click quick start: four role starter packs (Backend, Frontend, Platform/DevOps, Secure coding (regulated)), each card listing its items. The admin picks one and either picks a team or names a new one. The quick start creates that pack from the content library's newest items (through `CreatePack` from #96) and makes it the team's default pack, so every engineer in the team gets it on their next desktop sync. "Skip for now" is remembered per company; "Resume quick start" on the setup page and the admin home's setup banner brings it back. The four packs are a stand-in for the proposed mapping on the "Role-based starter packs" card, with that story's pack names. A new table remembers each company's answer (migration 000025). There is no OpenAPI or client change: the engineer's sync is the existing bundle endpoint, which already serves a team's default pack.

ClickUp: [One-click quick start (starter pack → team → sync)](https://app.clickup.com/t/86bcm902a)

## Changes

- `internal/onboarding/starters.go`: the four role starters (key, role, pack name, description, `kind/name` items), the stand-in that "Role-based starter packs" replaces.
- `internal/onboarding/quickstart.go`: `ResolveStarters` (the listed items, then every item they require via `Library.Required`, each once; startup stops if a starter names an item not in the library) and the `QuickStart` service.
  - `Apply`: every check that can refuse runs before the first write. Then, in order: the new team, the pack (version 1, or the company's pack with the same name at its latest version), the team default (`AssignTeam`), the done record.
  - The same pick again writes nothing: no new assignment, audit record or done record.
  - `Skip` and `State`.
- `internal/store/postgres/migrations/000025_quick_starts.{up,down}.sql`: one new table `quick_starts`, one row per company (skipped or done, with starter, pack, version number, reused flag and team). A two-sided CHECK fixes the done/skipped shape, and a `(tenant_id, pack_id)` foreign key keeps the pack in the same company.
- `internal/store/postgres/quick_starts.go`: `GetQuickStart`, `SkipQuickStart`, `CompleteQuickStart` (each write in one transaction with its `quickstart.skip` / `quickstart.complete` audit record; the team must be the company's own) and `PackByName` (matches exactly what the pack name index matches, `lower(btrim(name))`).
- `internal/web/quick_start.go`: the quick-start panel and page, `GET /admin/quick-start`, `POST /admin/quick-start` and `POST /admin/quick-start/skip`.
  - A pick runs inside the per-company setup lock and keeps running if the browser goes away, bounded by 30 s.
  - A second submit while one runs gets "busy, nothing saved".
  - Refusals map to 400 / 404 / 409 with fixed inline notices that never echo input.
- `internal/web/setup.go`: the panel under "Your workspace is ready" (offer, skipped with Resume, or done).
- `internal/web/handler.go`: the three routes, all `requireSession(requireAdmin(…))`, and "Resume quick start" in the admin home's setup banner.
- `cmd/control-plane/main.go`: wires the quick start at startup.
- Docs:
  - `internal/onboarding/README.md`: a "Quick start (86bcm902a)" section. The intro now says the quick start's answer is the one stored fact.
  - `internal/web/README.md`: the routes, the panel and the banner link.
  - Root `README.md`: the authorization row and a setup sentence.
  - `internal/audit/README.md`: the two new actions.
- Tests:
  - `internal/web/quick_start_test.go`: the five AC tests (real Postgres, the real setup wizard, a desktop token minted through the real device flow) plus done-sentence, browser-gone, time-bound and same-pick-again tests.
  - Unit tests `internal/onboarding/quickstart_test.go` and `starters_test.go`, plus the store test `quick_starts_test.go`.
  - `TestMigrationRoundTrip` knows the new table.
- `delivery/stories.json`: the 86bcm902a entry, appended last, with this PR's number.
- Bringing `main` in, as merge commits with no rebase:
  - #98 and #99 (`b985422`, merge `7360fca`): only `delivery/stories.json` conflicted. Main's file is kept unchanged and this story's entry appended last; `internal/web/README.md` and `internal/web/handler.go` merged cleanly.
  - #99 added `000024_pack_item_order`, so this story's pair was renamed `000024_quick_starts` → `000025_quick_starts` (no SQL change), with the one README line.
  - #99 changed `SaveVersion` to take a `pack.VersionChange`, so one quick start test call passes the added item that way.
  - #100 (`b65f797`, merge `bb79ec6`): no conflict and no new migration. `delivery/stories.json`, `internal/web/README.md` and `internal/web/handler.go` merged cleanly.

## Test Plan

Everything below ran on 2026-10-29 on head `bb79ec6`, after GitHub `main` moved to `b65f797` (#100) and was merged in, with its own `_test` database. Tools: Go 1.27.3 and CI's pinned golangci-lint 2.14.0, govulncheck v1.7.0 and gitleaks 8.30.1. Before #100 merged, the same local gates passed on the PR's first head `be31bad`, and hosted CI passed on `72ae141`.

- [x] `make check`: exit 0
  - workspace, generated contracts, fmt, vet and `go test -race` on every package (`internal/store/postgres` and `internal/web` ran against Postgres);
  - lint 0 issues in both modules;
  - govulncheck: no called vulnerability (the "1 vulnerability in modules you require" note comes from main's dependencies; no `go.mod`/`go.sum` change here);
  - gitleaks: no leaks; library gate PASSED (43 items).
- [x] `scripts/test-module-add.sh`: exit 0
- [x] Postgres tests (`go test -json` over `internal/web`, `internal/store/postgres` and `internal/cloud/dbcheck`, read per test):
  - 608 results: 604 pass, 0 fail; all 287 declared top-level tests ran.
  - The only 4 skips are the accepted ones: the two ClickHouse subtests of `TestTeamsAPIWithPostgres`, the live Scaleway test and the opt-in evidence-dir test. No skip names `LEORNA_TEST_DATABASE_URL`.
  - All 50 `TestQuickStart*` results pass, and `TestMigrationRoundTrip` passes with migrations 000024 and 000025 both applied.
- [x] `go test ./internal/onboarding/` (11 tests): pass
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: OK (5 tests)
- [x] Each AC test on its own (`go test -v -count=1 -run '^<name>$' ./internal/web/`):
  - `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres` (3 subtests): pass
  - `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres` (4 subtests): pass. A team member's sync is empty before, then serves "Backend starter pack" (26 files).
  - `TestQuickStartAC3SkipThenResumeLaterWithPostgres` (3 subtests): pass
  - `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres` (13 subtests): pass. Each refusal also checks the row counts of teams, packs, versions, assignments, `quick_starts` and audit records.
  - `TestQuickStartAC5FreshInstallEndToEndWithPostgres`: pass
- [x] Both merge commits were checked file by file:
  - every file changed on one side only equals that side's version;
  - the only files that differ from both parents are the three both sides changed;
  - each auto-merged file equals a fresh 3-way merge, and `7360fca`'s `delivery/stories.json` equals the scripted resolution (main's entries unchanged by value, this story's entry last).
- [x] `gitleaks git` over this branch's commits not on main: no leaks. `gitleaks dir` over each merge's three both-sides files: no leaks.
- [x] Scope:
  - no `.github` change and no OpenAPI change;
  - migration versions have no duplicate (newest: 000024 from #99, then 000025 here);
  - all 26 branch commits (21 story commits, two merges, two fixes and the PR number) are by the Leorna identity, with no AI attribution lines;
  - `git merge-tree` against main is clean.
- [x] Re-verified on `bb79ec6` after this PR opened: a fresh review of both merges and the fixes since `9a9bdec` (clean, one P3 note), a fresh verifier (gates, merge checks, migration 25 up/down/up on filled rows, a real-binary sync) and a blind AC auditor (25 mutants, real-console screenshots, a real-binary first sync). `ac-check.sh --reviews`: `ALL ACCEPTED: 5 of 5 ACs on bb79ec6`, reviews clean. The first acceptance was on `9a9bdec`, before main came in.
- [x] Hosted CI "Go quality gates" on `bb79ec6`: pass (see Evidence).

## Security, migration, rollback

- **Security:**
  - All three routes are admin-only (`requireAdmin`; a member gets 403 `ADMIN_REQUIRED`). The store re-checks the role inside each write transaction.
  - Forms use the existing CSRF check, with the 4 KiB body bound.
  - Every query is tenant-keyed. Another company's team is 404, and its quick start state is never shown or changed. The `(tenant_id, pack_id)` foreign key and an own-team check in `CompleteQuickStart` keep cross-tenant links out.
  - SQL is parameterized; HTML is rendered by `html/template`. Notices are fixed sentences.
  - Audit values hold ids, the status, the starter key and the version number, never names.
  - No auth bypass or dev-login change. No API contract change.
- **Migration:** 000025 adds one table only (`quick_starts`); no existing table or row changes. It runs after #99's 000024 and does not depend on it. No row means "offered", so every existing company sees the offer once setup is ready.
- **Rollback:** revert the PR, then run 000025's down (`DROP TABLE quick_starts`). Only the skip/done answers are lost. The teams, packs and team defaults a pick made stay as ordinary rows.

## Assumptions

- This PR ships with the stand-in starter packs (the plan's option B). The switch to the shared packs of "Role-based starter packs" (no PR yet) is follow-up 1. If the shared packs are wanted first (option A), this PR waits for that story before it is merged.
- Stand-in: the four packs follow the "Role-based starter packs" card's proposed mapping ("to confirm"), with `/plan` shipped as `/planning`, and use that story's pack names. That story replaces `starters.go` later. Companies that already picked keep their pack, because pack versions never change.
- "Role-based starter packs" (no PR yet) now adds its own migration 000025 on its branch. Whichever of the two merges later renames its pair to 000026, with its "migration 25" doc line. A trial of this head merged with that branch shows the duplicate fails `internal/store/postgres` even without a database, and the rename clears it (a prediction, not a gate).
- Pack reuse by name (approved Assumption 4): a company's existing pack with the starter's name (as the pack name index compares it) is reused at its latest version, whatever an admin put in it. The done sentence names exactly what was assigned and says when it reused an existing pack. Whether to stop reusing a pack an admin has edited is Justin's call.
- A pick runs to its end even when the browser goes away, bounded by 30 s (the server's default write timeout; a pick takes well under a second).
- The quick start sets the team's default pack; a project override still wins for that project.
- The quick-start state is per company. Skip and pick are offered only once setup is ready (409 before).
- Required items are added to a starter (`Library.Required`).
- A new team made by a pick that later fails stays; a retry picks it from the list.
- AC4 and AC5 were proposed and approved with the plan. AC5's recorded demo is an agent-recorded screenshot series plus logs; this machine has no video tool.
- The setup seed ("Leorna starter pack" 1.2.0) is unchanged. The "Role-based starter packs" PR draft leaves its refresh, and the "starter pack" wording, to this story or its own card; follow-up 2.
- Test Postgres ran on 127.0.0.1:55432, because 5432 is another container on the build machine. CI uses its own service.
- **Follow-ups** (not in this PR):
  1. Switch the quick start to the shared starter versions of "Role-based starter packs" and delete the stand-in, with a `quick_starts` migration that records the assigned version.
  2. After "Role-based starter packs": decide whether setup still loads the seed "Leorna starter pack" as the base pack, and settle the "starter pack" wording (that story's follow-ups 1 and 10).
  3. Let the quick start add engineers and a first project inline (today it links to Teams and Projects).
  4. "Manage many packs per tenant in one screen": Pack Assignments show the version id, not "pack name · version N".
  5. A JSON API for the quick start if the installer or a CLI needs one (an OpenAPI change then).
  6. Pre-existing: `AssignTeam` appends a `pack.assign` audit record even when the team default doesn't change. The quick start avoids calling it then.
  7. Test strength: pin the starter card's role title in AC1 (auditor mutant M1c).
  8. Pre-existing: `TrySetupLock` returns the same "not run" for "another setup step is running" and "every pool slot is busy".
  9. UX nit: a resubmit after a pick whose browser went away shows the done sentence with the 409 "team name already exists" alert above it.
  10. Test helper `readBody` (`internal/web/handler_test.go`) caps replies at 64 KiB, too small for a starter pack's `/content` (~290 KB). The AC tests read it with their own 8 MiB bound.
  11. Test strength, production code correct in each: the "same pick again" check with several assignment rows; the bounded-pick lock checked from a fresh database session; an unknown starter sent together with a new team name (AC4).

## Evidence

- Head: `bb79ec683832542bca271307b7a3fb31085664d0` (main `b65f797` merged in). The local gates above ran on this head.
- Required check "Go quality gates" on `bb79ec6`: pass (10m20s).
- Actions run: https://github.com/LeornaAI/leorna-control-plane/actions/runs/40936750079
- Earlier head `72ae141` (before #100 merged): "Go quality gates" success, https://github.com/LeornaAI/leorna-control-plane/actions/runs/40934127145
- Local gates on `bb79ec6` (2026-10-29), each exit 0 and kept with the story's evidence (one log per gate plus a summary).
