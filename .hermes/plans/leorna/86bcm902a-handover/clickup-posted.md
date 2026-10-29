# 86bcm902a — ClickUp evidence as posted (finisher 3, 2026-10-29)

Card: [One-click quick start (starter pack → team → sync)](https://app.clickup.com/t/86bcm902a). Posted on Justin's "yes do that" (2026-10-29) to the offer to post the evidence comment with the AC screenshots. Only the comment and its 7 image attachments were added. Status ("in progress"), checkboxes, description, tags, assignees and every field were left unchanged.

- PR #101: MERGED 2026-10-29T20:23:41Z by `Justin-Leorna` into `main`, merge commit `e2254e0100a482b9201edf9b96f01936e4486d44` (parents `b65f797` main, `bb79ec6` the accepted head). `compare bb79ec6...e2254e0` shows 0 files, so main's tree equals the accepted head's tree.
- Main CI on the merge: run 40948633595 (push, `e2254e0`): Go quality gates success (20:23:48–20:34:36Z), Publish control-plane image success (–20:37:14Z), Package admin-portal distribution success (–20:38:05Z). https://github.com/LeornaAI/leorna-control-plane/actions/runs/40948633595
- PR head CI: run 40936750079 on `bb79ec6`, all 3 checks pass.
- Before posting (20:38Z): card status "in progress", 0 attachments, 0 comments, `date_updated` 1793300455370. Before the merge (20:19Z) it was the same.
- Uploads: 7 tickets requested in one batch (all granted, none denied), then 7 `curl` multipart POSTs to `https://mcp.clickup.com/upload`, all HTTP 200, 20:39:31–20:39:56Z.
- Comment: id `90140275372968`, posted 2026-10-29 20:40:25 UTC (ClickUp date 1793306425341), 6584 characters, posted with `clickup_create_comment(entity_type=task)`.
- Read back: `clickup_get_task include=[attachments]` lists exactly these 7 attachments, each title once, each size equal to the local bytes. `clickup_get_task_comments` returns count 1, and the text equals the posted text word for word. The only difference is that the plain-text read-back shows the markdown link `[Role-based starter packs](https://app.clickup.com/t/86bcm901r)` as its anchor text alone. After posting, status is still "in progress"; only `date_updated` moved (1793306425341, the comment's time).

## Attachments

| AC | Local file | Bytes | ClickUp title | ClickUp attachment id | Read-back size |
| --- | --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac1-setup-ready-quick-start-offered.png` | 263959 | `86bcm902a-ac1-setup-done-quick-start-offered-bb79ec6.png` | `83186cb3-87a2-433b-93ab-0d71dec9c86d.png` | 263959 (equal) |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac2-quick-start-done.png` | 215248 | `86bcm902a-ac2-pack-assigned-to-team-bb79ec6.png` | `a1708463-cd64-4208-ae3c-bc4f81b9a6de.png` | 215248 (equal) |
| AC3 (skip) | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac3-skipped-resume-offered.png` | 90695 | `86bcm902a-ac3-skipped-resume-offered-bb79ec6.png` | `26286fc7-c778-43f1-b0fe-9985aee6c3d6.png` | 90695 (equal) |
| AC3 (resume) | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/verifier/ac3-resumed-offer.png` | 188806 | `86bcm902a-ac3-resumed-later-bb79ec6.png` | `48415452-758e-45a4-9316-6ed33c7f7a53.png` | 188806 (equal) |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac4-refused-terminal.png` | 212074 | `86bcm902a-ac4-refused-requests-test-log-bb79ec6.png` | `b0117ff2-3608-4da8-8a24-e00809864f06.png` | 212074 (equal) |
| AC5 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac5-test-terminal.png` | 80372 | `86bcm902a-ac5-fresh-install-test-log-bb79ec6.png` | `cbbc53a0-bdce-4805-afc0-a4500dbac8c5.png` | 80372 (equal) |
| Verify | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac5-08-desktop-first-sync.png` | 871084 | `86bcm902a-verify-real-binary-demo-bb79ec6.png` | `90a8e480-69da-434e-b614-4528964adc82.png` | 871084 (equal) |

Each image was opened and inspected before upload (tall ones in bands of 1,250 px or less). None shows a URL bar, server domain, tenant ID, token, device code, auth-item id or email. The picks and the rejected candidates are in `clickup-evidence.md`.

## Comment text as posted

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
