> **HOLD: don't open this PR until Justin answers the A/B question below** (raised by review 1 on 2026-10-29; the away grant did not cover it). Remove this block when it is answered.
>
> 86bcm901r "Role-based starter packs" is being built on `feat/86bcm901r-starter-packs` with real shared starter versions, its own migration 000024, and the same four pack names. With both merged, a company that runs this quick start would see its own "Backend starter pack" next to 901r's shared one.
> - **A (review 1's pick):** merge 901r first. A planner then amends this story so the quick start assigns 901r's newest shared starter version for the role, and deletes the stand-in list (`starters.go`), `ResolveStarters` and the reuse-by-name path. This PR text would be rewritten after that rebuild.
> - **B:** ship this branch first, as written below. Whichever story merges later renumbers its migration, and the switch to 901r's packs is filed as follow-up 1.

## Summary

Right after a new admin finishes setup, the setup page now offers a one-click quick start: four role starter packs (Backend, Frontend, Platform/DevOps, Secure coding (regulated)), each card listing its items. The admin picks one and either picks a team or names a new one. The quick start creates that pack from the content library's newest items (through 86bcm901w's `CreatePack`) and makes it the team's default pack, so every engineer in the team gets it on their next desktop sync. "Skip for now" is remembered per company; "Resume quick start" on the setup page and the admin home's setup banner brings it back. The four packs are a stand-in for 86bcm901r's proposed mapping, with 901r's pack names. A new table remembers each company's answer (migration 000024). There is no OpenAPI or client change: the engineer's sync is the existing bundle endpoint, which already serves a team's default pack.

ClickUp: [One-click quick start (starter pack → team → sync)](https://app.clickup.com/t/86bcm902a)

## Changes

- `internal/onboarding/starters.go`: the four role starters (key, role, pack name, description, `kind/name` items), the stand-in that 86bcm901r replaces.
- `internal/onboarding/quickstart.go`: `ResolveStarters` (the listed items, then every item they require via `Library.Required`, each once; startup stops if a starter names an item not in the library) and the `QuickStart` service.
  - `Apply`: every check that can refuse runs before the first write. Then, in order: the new team, the pack (version 1, or the company's pack with the same name at its latest version), the team default (`AssignTeam`), the done record.
  - The same pick again writes nothing: no new assignment, audit record or done record.
  - `Skip` and `State`.
- `internal/store/postgres/migrations/000024_quick_starts.{up,down}.sql`: one new table `quick_starts`, one row per company (skipped or done, with starter, pack, version number, reused flag and team). A two-sided CHECK fixes the done/skipped shape, and a `(tenant_id, pack_id)` foreign key keeps the pack in the same company.
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
- `delivery/stories.json`: the 86bcm902a entry, appended last.

## Test Plan

Everything below ran on head `9a9bdec` on 2026-10-29. The pipeline's independent verifier ran the gates in a detached copy of that head with its own `_test` database, after the builder had run them too. Tools: Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0, gitleaks 8.30.1.

- [x] `make check`: exit 0 (builder and verifier)
  - workspace, fmt, vet and `go test -race` on every package;
  - lint 0 issues in both modules;
  - govulncheck: no called vulnerability (the "1 vulnerability in modules you require" note comes from main's dependencies; no `go.mod`/`go.sum` change here);
  - gitleaks: no leaks; library gate PASSED (43 items).
- [x] `scripts/test-module-add.sh`: exit 0
- [x] Postgres tests (`go test -json` over `internal/web`, `internal/store/postgres` and `internal/cloud/dbcheck`, read per test, verifier):
  - 505 results: 501 pass, 0 fail; all 260 declared top-level tests ran.
  - The only 4 skips are the accepted ones: the two ClickHouse subtests of `TestTeamsAPIWithPostgres`, the live Scaleway test and the opt-in evidence-dir test. No skip names `LEORNA_TEST_DATABASE_URL`.
  - All 50 `TestQuickStart*` results pass.
- [x] `go test ./internal/onboarding/` (11 tests): pass
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: OK (5 tests)
- [x] `gitleaks git` over `6c1709e..9a9bdec` (21 commits): no leaks
- [x] Image: `docker build --no-cache` exit 0 (the `go build` step ran, not cached), and the packaged gitleaks reports 8.30.1.
- [x] Scope: no `.github` change; no OpenAPI change; only migration `000024` is added (main's newest is `000023`); all 21 commits by the Leorna identity, with no AI attribution lines.
- [x] `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres` (3 subtests): pass
- [x] `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres` (4 subtests): pass. A team member's sync is empty before, then serves the pack with every item's body equal to the shipped library's.
- [x] `TestQuickStartAC3SkipThenResumeLaterWithPostgres` (3 subtests): pass
- [x] `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres` (13 subtests): pass. Covered: unknown pack, no team, blank new name, team and new name, unknown team, another company's team, team name taken, setup not finished, member, bad CSRF, signed out, busy setup lock, and another company's state staying separate. Each also checks the row counts of teams, packs, versions, assignments, `quick_starts` and audit records.
- [x] `TestQuickStartAC5FreshInstallEndToEndWithPostgres`: pass
- [x] The verifier and the blind AC auditor each ran every AC test on its own on `9a9bdec`. Each test also fails on base `6c1709e` with the head's test file copied in (build failed: the quick start doesn't exist there).
- [x] `ac-check.sh` over the verifier's and the auditor's AC reports: `ALL ACCEPTED: 5 of 5 ACs on 9a9bdec`.
- [x] Mutation checks on this head:
  - Builder: 79 mutants, 77 killed. Review 2 graded the 2 survivors (X30, X34) harmless.
  - Verifier: 27 mutants, all killed. V11 was first graded on the wrong subtest and was killed when graded on `unknown_team`.
  - Blind auditor: 16 mutants, 15 killed. M1c (a card's role title rendered as its key) still passes AC1; follow-up 7.
- [x] Real binary at `9a9bdec`, run on its own by the verifier and the blind auditor. Each used dev mode on loopback, an empty database, auto setup on (as the installer runs it) and a reserved `.invalid` public name:
  - setup finishes with no clicks and the four starter cards show;
  - Skip, then Resume;
  - Backend plus a new team "Backend team", and the done sentence names the pack and the team;
  - Pack Assignments shows the team default;
  - a project added for the team (the verifier also added the signed-in user to the team);
  - desktop device sign-in through the real API, then the first sync: status assigned, "Backend starter pack", 26 files, 16 items, each body equal to the shipped library's.
  - Screenshots are on the card.
- [ ] Hosted CI: not run yet (nothing pushed).
- Review history: review 1 (`7b45d43`) raised three main findings, fixed in `707a4c0`:
  - F1: a client disconnect mid-pick;
  - F2: pack reuse matching more names than the index;
  - F3: an unpinned role mapping.
  Review 2 (`707a4c0`) raised M1 (the done-shape CHECK was too loose) and four nits, fixed in `9a9bdec`. Migration 000024 was edited in place; it was never on `main` or GitHub.

## Security, migration, rollback

- **Security:**
  - All three routes are admin-only (`requireAdmin`; a member gets 403 `ADMIN_REQUIRED`). The store re-checks the role inside each write transaction.
  - Forms use the existing CSRF check, with the 4 KiB body bound.
  - Every query is tenant-keyed. Another company's team is 404, and its quick start state is never shown or changed. The `(tenant_id, pack_id)` foreign key and an own-team check in `CompleteQuickStart` keep cross-tenant links out.
  - SQL is parameterized; HTML is rendered by `html/template`. Notices are fixed sentences.
  - Audit values hold ids, the status, the starter key and the version number, never names.
  - No auth bypass or dev-login change. No API contract change.
- **Migration:** 000024 adds one table only (`quick_starts`); no existing table or row changes. No row means "offered", so every existing company sees the offer once setup is ready.
- **Rollback:** revert the PR, then run 000024's down (`DROP TABLE quick_starts`). Only the skip/done answers are lost. The teams, packs and team defaults a pick made stay as ordinary rows.

## Assumptions

- **Open (Justin):** A or B above. This text is written for B (this branch as it is).
- Stand-in: the four packs follow 86bcm901r's proposed mapping ("to confirm"), with `/plan` shipped as `/planning`, and use 901r's pack names. 86bcm901r replaces `starters.go` later. Companies that already picked keep their pack, because pack versions never change.
- Migration 000024 is also added by 86bcm901r and 86bcm901y. Whichever merges later renames its pair to the next free number, with its "migration 24" doc mentions; for this story that is one README line. If 901y merges first, this branch's one `SaveVersion` test call switches to `pack.VersionChange{AddLibraryItemIDs: …}`.
- Pack reuse by name (approved Assumption 4): a company's existing pack with the starter's name (as the pack name index compares it) is reused at its latest version, whatever an admin put in it. The done sentence names exactly what was assigned and says when it reused an existing pack. Whether to stop reusing a pack an admin has edited is Justin's call.
- A pick runs to its end even when the browser goes away, bounded by 30 s (the server's default write timeout; a pick takes well under a second).
- The quick start sets the team's default pack; a project override still wins for that project.
- The quick-start state is per company. Skip and pick are offered only once setup is ready (409 before).
- Required items are added to a starter (`Library.Required`).
- A new team made by a pick that later fails stays; a retry picks it from the list.
- AC4 and AC5 were proposed and approved with the plan. AC5's recorded demo is an agent-recorded screenshot series plus logs; this machine has no video tool.
- The setup seed ("Leorna starter pack" 1.2.0) is unchanged. 86bcm901r's PR text leaves its refresh, and the "starter pack" wording, to this story or its own card; follow-up 2.
- Test Postgres ran on 127.0.0.1:55432, because 5432 is another container on the build machine. CI uses its own service.
- **Follow-ups** (not in this PR):
  1. If B: switch the quick start to 86bcm901r's shared starter versions and delete the stand-in, with a `quick_starts` migration that records the assigned version.
  2. After 901r: decide whether setup still loads the seed "Leorna starter pack" as the base pack, and settle the "starter pack" wording (901r's follow-ups 1 and 10).
  3. Let the quick start add engineers and a first project inline (today it links to Teams and Projects).
  4. 86bcm902d: Pack Assignments show the version id, not "pack name · version N".
  5. A JSON API for the quick start if the installer or a CLI needs one (an OpenAPI change then).
  6. Pre-existing: `AssignTeam` appends a `pack.assign` audit record even when the team default doesn't change. The quick start avoids calling it then.
  7. Test strength: pin the starter card's role title in AC1 (auditor mutant M1c).
  8. Pre-existing: `TrySetupLock` returns the same "not run" for "another setup step is running" and "every pool slot is busy".
  9. UX nit: a resubmit after a pick whose browser went away shows the done sentence with the 409 "team name already exists" alert above it.
  10. Test helper `readBody` (`internal/web/handler_test.go`) caps replies at 64 KiB, too small for a starter pack's `/content` (~290 KB). The AC tests read it with their own 8 MiB bound.

## Evidence

- Head: `9a9bdecc2f6ab53356fddddbc62b06b6533a4867` (21 commits on `main` `6c1709e`).
- Required check "Go quality gates": pending until pushed.
- Actions run: pending until pushed.
- Local gates on this head (2026-10-29), run by the builder and again by the verifier, each exit 0 and kept with the story's evidence (one log per gate plus a summary).
- AC reports on this head: the verifier's and the blind auditor's. `ac-check.sh` over both: `ALL ACCEPTED: 5 of 5 ACs on 9a9bdec`.
