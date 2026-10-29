# 86bcm902a — ClickUp closing evidence (draft; post only when Justin says "post")

Card: [One-click quick start (starter pack → team → sync)](https://app.clickup.com/t/86bcm902a). Checked 2026-10-29: status "to do", 0 attachments.

Written for the branch as it is (option B). If Justin picks A (86bcm901r first, then this story rebuilt on 901r's packs), this draft and its images are replaced after the rebuild. Fill in the PR number, merge date, merge SHA, +/- and the CI run at post time; never change the card's status or checkboxes.

## Comment text

```
✅ Closing evidence — One-click quick start (starter pack → team → sync) (86bcm902a)

WHAT WAS DONE
- leorna-control-plane PR #<n> (merged <date>, merge <sha7>, +3294/-10, 19 files): after setup, the setup page offers four role starter packs; the admin picks one and a team (or names a new team), and that pack becomes the team's default, so the team's engineers get it on their next sync. Skip is remembered per company and "Resume quick start" brings it back. The four packs are a stand-in for 86bcm901r's proposed mapping. No API or client change.

WHAT WAS VERIFIED
| Acceptance criterion | Test / evidence | Result |
| --- | --- | --- |
| AC1 Given a fresh install, when I finish setup, then the quick start offers role-based starter packs | `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres` (3 subtests) + 86bcm902a-ac1-quick-start-offered.png | ✅ |
| AC2 Given I choose a pack and a team, then the assignment is created and engineers' next sync delivers it | `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres` (4 subtests: a team member's sync is empty before, then serves the pack with bodies equal to the library's) + 86bcm902a-ac2-quick-start-done.png | ✅ |
| AC3 Given the quick start, then it can be skipped and resumed later | `TestQuickStartAC3SkipThenResumeLaterWithPostgres` (3 subtests) + 86bcm902a-ac3-skipped-resume.png | ✅ |
| AC4 An invalid or not-allowed request is refused with a clear status and writes nothing; one company never sees or changes another's | `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres` (13 subtests) + 86bcm902a-ac4-refused-requests-test.png | ✅ |
| AC5 Fresh install end to end: no-click setup, Backend + new team, the engineer's first desktop sync gets the pack | `TestQuickStartAC5FreshInstallEndToEndWithPostgres` + 86bcm902a-ac5-fresh-install-test.png | ✅ |
- Each AC test ran on its own on head 9a9bdec, by the independent verifier and again by a blind auditor; each fails on the base commit (the quick start doesn't exist there). ac-check: ALL ACCEPTED, 5 of 5.
- Gates on 9a9bdec (verifier's own run): make check ✅ (fmt, vet, go test -race, golangci-lint 0 issues, govulncheck, gitleaks, library gate) · test-module-add ✅ · Postgres tests 501 pass, 0 fail, only the 4 allowed skips ✅ · story gate ✅ · gitleaks on the branch ✅ · image build ✅
- Mutation checks: verifier 27/27 killed; blind auditor 15/16 killed (the survivor is a test-strength follow-up, not a defect).
- CI: <"Go quality gates" ✅ — Actions run URL> (not run yet: not pushed when this was written)
- Recorded demo (the card's Verify line), 2026-10-29: the real control-plane binary at 9a9bdec on an empty database with auto setup, run by the verifier and again by the auditor: setup finished with no clicks → four starter cards → Skip → Resume → Backend + new team → done → Pack Assignments shows the team default → project added → desktop device sign-in → first sync assigned "Backend starter pack" (26 files, 16 items, each body equal to the library's). 86bcm902a-verify-real-binary-demo.png
- Live run: none needed; no AC is a live check.

NOT VERIFIED
- Nothing left.
```

Before posting, replace the CI line with the merge facts. If CI still hasn't run, keep it as an honest "CI: not run" line and add it under NOT VERIFIED.

## Files to attach (images only; one per AC, plus one optional for the Verify line)

Every image was opened and inspected on 2026-10-29. Tall ones were cut into bands with headless Chrome and each band viewed. No URL bar, server domain, tenant ID, token, device code or email is visible in any of them.

| AC | Local file (absolute path) | Bytes | Upload as (`file_name`) | Inspected: what it shows | Caption notes |
| --- | --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac1-quick-start-offered.png` | 301314 | `86bcm902a-ac1-quick-start-offered.png` | 1440×2726, viewed in 3 bands. The real setup page on the head binary after auto setup: "3 of 3 steps done", "Your workspace is ready", then "Quick start: give a team a starter pack" with the four role cards (Backend 16 items, Frontend 5, Platform/DevOps 6, Secure coding (regulated) 8), each listing its items, "Name a new team", "Assign the starter pack" and "Skip for now" | `demo.leorna.invalid` in the domain box is an RFC 2606 reserved placeholder name that resolves nowhere. "Dev Admin" is the dev-mode workspace name |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac2-quick-start-done.png` | 215248 | `86bcm902a-ac2-quick-start-done.png` | 1440×1684, viewed whole. `/admin/quick-start` after the pick: "Done: **Backend starter pack** (version 1) was made the default pack for **Backend team**. Engineers in that team get it on their next sync." Links to assignments, team and project, and the form to give another team a pack | The page renders the same bytes in every run (no version id or time on it), so the verifier's capture is byte-identical |
| AC3 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac3-skipped-resume.png` | 127759 | `86bcm902a-ac3-skipped-resume.png` | 1440×1523, viewed whole. Setup page after "Skip for now": "You skipped the quick start. You can pick it up any time." with "Resume quick start →" | Same placeholder domain as AC1 |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac4-refused-terminal.png` | 212921 | `86bcm902a-ac4-refused-requests-test.png` | 1400×663, viewed whole. Local rendering of the auditor's head log: `HEAD=9a9bdec…`, the `go test -v -run '^TestQuickStartAC4…$'` command, the 13 subtests passing, `EXIT=0`. Matches `auditor/ac4-9a9bdec.log` (EXIT=0) | Label it "local rendering of the test log" (nothing visual in this AC) |
| AC5 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac5-fresh-install-terminal.png` | 78446 | `86bcm902a-ac5-fresh-install-test.png` | 1400×404, viewed whole. Local rendering of the auditor's head log: the engineer's sync `status=assigned pack="Backend starter pack" … files=26`, 16 items with bodies equal to the shipped library's, PASS, `EXIT=0`. Matches `auditor/ac5-9a9bdec.log` (EXIT=0) | The `v2026…Z` version id was generated in that test's throwaway database |
| Verify (optional) | `/home/justin/.hermes/plans/leorna/evidence/86bcm902a/auditor/ac5-real-binary-desktop-sync.png` | 878065 | `86bcm902a-verify-real-binary-demo.png` | 1400×2170, viewed in 3 bands (one re-cut where Chrome left a tile unpainted). Local rendering of the auditor's demo log on the real binary: every step from first sign-in to the first sync, the files with their sha256, and the "team name already exists" alert | Paths like `/admin/setup` are page paths, not a server address. The header says the token, tenant id and user code were never recorded. Version id and lockfile digest come from a throwaway database |

Checked and not chosen:
- `verifier/ac5-real-binary-first-sync-9a9bdec.png` (451578 bytes): clean of secrets, but it shows a reserved public URL (`https://verify1.leorna.invalid`) and a throwaway project UUID; the auditor's rendering above shows the same run without them.
- `verifier/ac1-…`, `ac3-…` and `ac4-…`: equivalent to the auditor's; one set is enough.

Not available: there is no gates screenshot (`gates-9a9bdec.png`) in the verified sets; the gates line cites the verifier's log `verifier/gates-9a9bdec.txt` (EXIT=0), which stays local. That log was checked and is clean (no URL, token, email or DB address), so a local rendering can be made before posting if Justin wants one.

## How to post (on "post")

Request one upload ticket per file with `clickup_request_attachment_upload(task_id=86bcm902a, file_name=<Upload as>)`, all tickets first, and stop on any denial so the card never gets a partial set. Upload each with `curl -sS -X POST <upload_url> -H 'X-Upload-Ticket: <ticket>' -F 'attachment=@<path>;filename=<name>;type=image/png'` inside the ticket's ~3 minutes. Then add the comment with `clickup_create_comment(entity_type=task, entity_id=86bcm902a, …)`. Read both back: `clickup_get_task include=[attachments]` shows the titles, and the sizes equal the bytes above; `clickup_get_task_comments` shows the comment (compare word by word, since tables come back as plain text).
