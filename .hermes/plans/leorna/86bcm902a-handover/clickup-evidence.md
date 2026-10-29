# 86bcm902a — ClickUp closing evidence (bb79ec6; POSTED 2026-10-29 20:40 UTC, see clickup-posted.md)

Card: [One-click quick start (starter pack → team → sync)](https://app.clickup.com/t/86bcm902a). Read 2026-10-29 20:19 UTC (finisher 3): status "in progress", 0 attachments, 0 comments, no checklists. Leave the status, checkboxes and fields alone.

Refreshed by finisher 3 for head bb79ec6 (2026-10-29 ~20:25 UTC). It replaces finisher 2's draft, which still pointed at 9a9bdec images (they're in `evidence/86bcm902a/archive-9a9bdec/` and are not attached). Acceptance on bb79ec6: `ac-check.sh --reviews` → `ALL ACCEPTED: 5 of 5 ACs on bb79ec6`, `REVIEWS CLEAN: review-4 at bb79ec6 is clean` (`evidence/86bcm902a/ac-check-reviews-bb79ec6.txt`). Decision recorded: Justin's A/B answer was taken as B for now.

The "State:" line is filled from a fresh `gh pr view 101` right before posting. If the PR merged, it gets the merge SHA and main's CI run on it. If not, it says "Ready to merge; not merged yet". Merge facts are never guessed. The text actually posted is saved in `clickup-posted.md`.

## Comment text

```
✅ Closing evidence — One-click quick start (starter pack → team → sync) (86bcm902a)

WHAT WAS DONE
leorna-control-plane PR #101: https://github.com/LeornaAI/leorna-control-plane/pull/101
State: merged into main 2026-10-29 20:23 UTC by Justin-Leorna, merge commit e2254e0. Main's tree after the merge equals the accepted head's. Head bb79ec6. +3294/-10, 19 files.
Right after setup finishes, the setup page offers a one-click quick start: four role starter packs (Backend, Frontend, Platform/DevOps, Secure coding (regulated)), each card listing its items.
The admin picks a pack and a team, or names a new team. The quick start creates that pack from the content library and makes it the team's default pack, so the team's engineers get it on their next sync.
"Skip for now" is remembered per company. "Resume quick start" on the setup page and on the admin home's setup banner brings it back.
One new table (migration 000025). No OpenAPI or client change: engineers sync through the existing bundle endpoint.
Decision (Justin, option B for now): the four packs are a stand-in. Switching to the shared packs of [Role-based starter packs](https://app.clickup.com/t/86bcm901r) is follow-up 1 on the PR.

WHAT WAS VERIFIED (all on head bb79ec6)

AC1: Given a fresh install, when I finish setup, then the quick start offers role-based starter packs
Test: TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres (3 subtests)
Screenshot: 86bcm902a-ac1-setup-done-quick-start-offered-bb79ec6.png (setup page "3 of 3 steps done · Your workspace is ready", then the quick start with the four role packs and their items)
Result: ✅ pass

AC2: Given I choose a pack and a team, then the assignment is created and engineers' next sync delivers it
Test: TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres (4 subtests). A team member's sync is empty before the pick. After it, the sync serves "Backend starter pack" (26 files, 16 items), each body equal to the shipped library's.
Screenshot: 86bcm902a-ac2-pack-assigned-to-team-bb79ec6.png ("Done: Backend starter pack (version 1) was made the default pack for Backend team. Engineers in that team get it on their next sync.")
Result: ✅ pass

AC3: Given the quick start, then it can be skipped and resumed later
Test: TestQuickStartAC3SkipThenResumeLaterWithPostgres (3 subtests)
Screenshots: 86bcm902a-ac3-skipped-resume-offered-bb79ec6.png (after "Skip for now": "You skipped the quick start. You can pick it up any time." with "Resume quick start") → 86bcm902a-ac3-resumed-later-bb79ec6.png (after Resume: "You skipped this earlier. Pick a pack to finish it." with the four packs)
Result: ✅ pass

AC4 (proposed, approved with the plan): Given a quick-start request that is invalid or not allowed, then it is refused with a clear status and nothing is written, and one company's quick start never shows or changes another's
Test: TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres (13 subtests): unknown starter, no team, blank new team name, both a team and a new name, unknown team, another company's team, team name already used, setup not finished, a member, bad CSRF token, signed out, setup lock busy, another company's state kept separate. Each refusal leaves teams, packs, versions, assignments, quick-start rows and audit records unchanged.
Screenshot: 86bcm902a-ac4-refused-requests-test-log-bb79ec6.png (local rendering of the test log: 13 subtests pass, EXIT=0; this AC has nothing visual)
Result: ✅ pass

AC5 (proposed, approved with the plan): Given a fresh install (empty database, auto setup), when the admin signs in for the first time, picks Backend and names a new team, then setup finishes with no clicks, the team's default pack is created, and an engineer in that team gets the pack's files on their first sync
Test: TestQuickStartAC5FreshInstallEndToEndWithPostgres
Screenshot: 86bcm902a-ac5-fresh-install-test-log-bb79ec6.png (local rendering of the test log: the engineer's sync gets "Backend starter pack", 26 files, 16 items equal to the shipped library, EXIT=0)
Result: ✅ pass

Verify (card): end-to-end demo on a fresh install (recorded)
An agent recorded it on the real control-plane binary built at bb79ec6, on an empty database with auto setup, run locally in dev mode: first sign-in with no setup click → four starter packs → Skip → Resume → Backend + new team "Backend team" → done → the client's device sign-in and first sync get "Backend starter pack" (26 files, 16 items, each body equal to the shipped library's). The demo client signs in as the dev admin (dev mode has one user); the team member's sync is proven by the AC5 test.
Screenshot: 86bcm902a-verify-real-binary-demo-bb79ec6.png (local rendering of the demo log; no token, device code or tenant id was recorded)

Gates and checks
Local gates on bb79ec6: make check ✅ (fmt, vet, go test -race, golangci-lint 0 issues, govulncheck no vulnerabilities, gitleaks no leaks, library gate passed) · test-module-add ✅ · Postgres tests 604 pass, 0 fail, only the 4 known environment skips ✅ · story gate ✅ · gitleaks on the branch ✅ · container image build ✅
Each AC test fails on main before this change (b65f797, where the quick start doesn't exist) and passes on bb79ec6.
Four fresh code reviews; the last (review 4, on bb79ec6) is clean. An independent verifier and a blind auditor each accepted 5 of 5 ACs on bb79ec6.
Mutation checks: the auditor's 25 mutants, 23 killed by the AC tests. The 2 survivors are test-strength follow-ups; the code is right in both (the auditor's own probe kills one). The verifier's 5 targeted mutants all behaved as expected.
CI on the merge: run 40948633595 on main at e2254e0, all 3 checks pass (Go quality gates, Publish control-plane image, Package admin-portal distribution): https://github.com/LeornaAI/leorna-control-plane/actions/runs/40948633595
CI on the PR head bb79ec6: run 40936750079, all 3 checks pass: https://github.com/LeornaAI/leorna-control-plane/actions/runs/40936750079
Console run (2026-10-29): the console screenshots come from a server built at bb79ec6, run locally in dev mode on a throwaway database.
Live run: none needed, no AC is live. AC5's recorded fresh-install demo is an agent-recorded screenshot series on the real head binary.

Follow-ups (listed on the PR, not part of this card): the switch to the shared starter packs above, plus test-strength and UX items.

NOT VERIFIED
Nothing left for the acceptance criteria. No desktop app Sync was run against a deployed server: delivery is proven by the AC2 and AC5 tests and the recorded demo's client sync.
```

## Files to attach (images only; one per AC, two for AC3, plus one for the card's Verify line)

All are from the bb79ec6 sets. Each was opened and inspected by finisher 3 on 2026-10-29; the tall ones were viewed in bands of 1,250 px or less, cut with a pure-Python band cropper in `~/.cache/86bcm902a-post/`. None shows a URL bar, server domain, tenant ID, token, device code, auth-item id or email. None of the chosen images shows a `*.leorna.invalid` placeholder either.

| AC | Local file (absolute path) | Bytes | Upload as (`file_name`) | Inspected: what it shows | Traced to its bb79ec6 run |
| --- | --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac1-setup-ready-quick-start-offered.png` | 263959 | `86bcm902a-ac1-setup-done-quick-start-offered-bb79ec6.png` | 1440×2459, 3 bands. Header "Leorna Control Plane — back to admin", "Set up your workspace · 3 of 3 steps done · Your workspace is ready", then the quick start with Backend (16 items), Frontend (5), Platform/DevOps (6), Secure coding (regulated) (8) and their items, "Name a new team", "Assign the starter pack", "Skip for now", and the three done steps ("Signed in with Google." text only) | `verifier/console-run-bb79ec6.log` line 10 (263959 bytes; server "built from bb79ec6") |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac2-quick-start-done.png` | 215248 | `86bcm902a-ac2-pack-assigned-to-team-bb79ec6.png` | 1440×1684, 2 bands. "Quick start": "Done: **Backend starter pack** (version 1) was made the default pack for **Backend team**. Engineers in that team get it on their next sync." plus links and the "Give another team a starter pack" form | console-run line 24 (215248 bytes). The page has no id or time on it, so it is byte-identical across runs |
| AC3 (skip) | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac3-skipped-resume-offered.png` | 90695 | `86bcm902a-ac3-skipped-resume-offered-bb79ec6.png` | 1440×1256, whole. Setup page "3 of 3 steps done", quick start "You skipped the quick start. You can pick it up any time." with "Resume quick start →" | console-run line 13 |
| AC3 (resume) | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac3-resumed-offer.png` | 188806 | `86bcm902a-ac3-resumed-later-bb79ec6.png` | 1440×1469, 2 bands. "Quick start · You skipped this earlier. Pick a pack to finish it." with the four packs, "Name a new team", Assign / Skip | console-run line 19 |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac4-refused-terminal.png` | 212074 | `86bcm902a-ac4-refused-requests-test-log-bb79ec6.png` | 1400×700, whole. Labelled "Local rendering (auditor 2) of ac4-bb79ec6.log": `HEAD=bb79ec6…`, the `go test -v -count=1 -run '^TestQuickStartAC4…$' ./internal/web/` command, 13 subtests PASS, `EXIT=0` | `auditor/ac4-bb79ec6.log`: HEAD=bb79ec6, EXIT=0 |
| AC5 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac5-test-terminal.png` | 80372 | `86bcm902a-ac5-fresh-install-test-log-bb79ec6.png` | 1400×700, whole. Labelled local rendering of ac5-bb79ec6.log: `status=assigned pack="Backend starter pack" … files=26`, 16 items each equal to the shipped library, PASS, `EXIT=0` | `auditor/ac5-bb79ec6.log`: HEAD=bb79ec6, EXIT=0. The `v2026…Z` version id comes from the test's throwaway DB |
| Verify | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac5-08-desktop-first-sync.png` | 871084 | `86bcm902a-verify-real-binary-demo-bb79ec6.png` | 1400×2514, 3 bands. Labelled local rendering of ac5-demo-bb79ec6.log: steps 1–12 from first sign-in to first sync. Page and API paths only (`/admin/setup`, `/v1/client/token`, `GET …/bundle`); "token, code and tenant id kept in memory only"; the approval page not captured; sha256 of public library files; the "team name already exists" alert | `auditor/ac.json` AC5 screenshot. The lockfile digest and version id come from a throwaway DB |

Checked and not chosen:
- `verifier/ac2-assignment-created.png`: clean, but its form dropdown shows the blank-form default "Leorna starter pack - 1.2.0", and the saved row shows only a version id. A reader could take the default as what was assigned. The AC2 done page names the pack and team instead.
- The auditor's element crops `ac1-quick-start-offered.png`, `ac2-quick-start-done.png` and `ac3-skipped-with-resume.png`: clean, but the verifier's full pages show the same states with the setup context.
- `verifier/ac4-head-log-rendering.png`, `verifier/ac5-head-log-rendering.png`: equivalent to the auditor's; one set is enough.
- Gate logs stay local as receipts (`verifier/gates-SUMMARY-bb79ec6.txt`, `pg-bb79ec6-summary.txt`, etc.). No `.log` or `.txt` file is uploaded.
