# ClickUp evidence draft: 86bcm901y, PR #99 (Justin said "post" on 2026-10-29)

Card: [Remove and reorder items in a pack version](https://app.clickup.com/t/86bcm901y). Read on 2026-10-29 at about 17:51 UTC: status "to do", **0 attachments, 0 comments**. Nothing has been uploaded or posted. The main session uploads and posts. Never change the card's status or checkboxes.

Refreshed by the post-prep finisher on 2026-10-29, ~17:50–17:58 UTC, for PR #99 at head `008c6124af3f58bbae9bd580b86c7c50cf8ffc29`.

## Facts behind the comment (read this session)

- **PR #99** (`gh pr view 99`, read 17:50:35 UTC): OPEN, not merged (`mergedAt` null), not a draft, `mergeStateStatus` CLEAN, mergeable, head `008c612`, +1855/-54, 21 files.
- **CI** (`gh pr checks 99`, read 17:50:41 UTC, rc 0): run 40916770447. Go quality gates pass (10m41s), Package admin-portal distribution pass (53s), Publish control-plane image pass (2m17s).
- **Local gates on 008c612** (verifier, `evidence/86bcm901y/verifier-pr/SUMMARY-gates-008c612.txt`, every line `EXIT=0`): make check (lint 0 issues twice, govulncheck "No vulnerabilities found" twice, gitleaks "no leaks found", library-gate PASSED, `EXIT=0`), test-module-add, the Postgres `go test -json` stream read per test (523 pass, 4 accepted skips, 257 of 257 declared top-level tests with a final event), story gate (5 tests OK), generated contracts, scope and authorship; worktree clean after the gates. Tools: Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0, gitleaks 8.30.1.
- **AC acceptance on 008c612**: verifier (`verifier-pr/`) and blind auditor (`auditor-pr/`) clean; `ac-check.sh` (main session): `ALL ACCEPTED: 4 of 4 ACs on 008c612`.
- **Each AC test on main `dd006b7`** (auditor, `auditor-pr/ac<n>-base-dd006b7.log`): ac1 6 FAIL lines, ac2 4, ac3 7, ac4 15, each `EXIT=1`. On 008c612 each passes with `EXIT=0`.
- **No AC is `(live)`** (approved plan, line 37). No live run was needed or done.

## Format choice

The memory format (`clickup-evidence.md`) shows the AC → test → result mapping as a Markdown table. The comment below gives the same mapping as one short block per AC (AC, Test, Screenshots, Result) instead, because `clickup_get_task_comments` reads a comment back as plain text with table pipes stripped and a table's last cell running into the next line (memory note, 86bcm901a), and this brief asks for short plain lines. No server domain, tenant ID, token or email appears in it.

## Before posting

1. Re-read the PR: `gh pr view 99 -R LeornaAI/leorna-control-plane --json state,headRefOid,mergedAt,mergeCommit` and `gh pr checks 99 -R LeornaAI/leorna-control-plane`.
   - Still open at `008c612`: post the comment exactly as in `clickup-comment.txt`.
   - Merged by then: change the second WHAT WAS DONE line to `- State: merged <date>, merge <sha7>. Head 008c612. +1855/-54, 21 files.`, and add the main CI run for the merge commit (`gh run list -R LeornaAI/leorna-control-plane --branch main`) after the PR's CI line.
   - Head moved past `008c612`: stop. The evidence is for `008c612` only.
2. Re-read the card: still 0 attachments and 0 comments, or the post would duplicate something.

## Closing comment (exactly as posted; same text as `clickup-comment.txt`)

```
✅ Closing evidence — Remove and reorder items in a pack version (86bcm901y)

WHAT WAS DONE
- leorna-control-plane PR #99: https://github.com/LeornaAI/leorna-control-plane/pull/99
- State: open, not merged (read 2026-10-29 17:50 UTC). Head 008c612. +1855/-54, 21 files.
- A pack's edit view now lists its items in order, each with Move up, Move down and Remove.
- Each click saves a new version and writes an audit record. The version you started from stays unchanged.
- The admin API takes an optional "order" when it saves a new version.
- A removed item's files leave engineers' tools on their next Sync, once the new version is assigned to their team.

WHAT WAS VERIFIED (all on head 008c612)

AC1: Given a pack version, when I remove an item, then a new version is saved without it and audited
- Test: TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres (5 subtests)
- Screenshots: 86bcm901y-ac1-remove-before.png → 86bcm901y-ac1-remove-after.png (version 2 with github-mcp → version 3 without it), 86bcm901y-ac1-remove-audit.png (the removal's audit record)
- Result: ✅ pass

AC2: Given a removal, when engineers next sync, then the item's files are removed from their tools (or flagged) consistently with the lockfile
- Test: TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres (4 subtests). Nothing changes for engineers until the new version is assigned. Then the lockfile drops exactly the item's files, every other file keeps its hash, and the old download is refused.
- Desktop side: leorna-client's existing Sync tests pass, unchanged. Sync deletes dropped files and keeps a file the engineer edited.
- Screenshots: 86bcm901y-ac2-sync-lockfile-log.png, 86bcm901y-ac2-client-sync-f105e27.png
- Result: ✅ pass

AC3: Given a pack version, when I reorder its items (Move up / Move down, or "order" in the API), then a new version is saved in the new order, the console and the API show it, the parent keeps its old order, the save is audited with the order before and after, and it syncs the same files and hashes
- Test: TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres (6 subtests)
- Screenshots: 86bcm901y-ac3-reorder-before.png → 86bcm901y-ac3-reorder-after.png (version 1 → version 2, items 4 and 5 swapped), 86bcm901y-ac3-reorder-audit.png (both orders in the audit record)
- Result: ✅ pass

AC4: Given a remove or reorder that is invalid or not allowed, then it is refused with a clear status or alert and nothing is written
- Test: TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres (22 subtests)
- Cases: one valid order first, then 21 refusals: the only item, first item up, last item down, an item not in this version, an outdated version, bad orders, a member, a bad CSRF token, another company's pack, signed out, a form over 4 KiB …
- Screenshots: 86bcm901y-ac4-refused-log.png, 86bcm901y-ac4-only-item-cannot-be-removed.png (a one-item pack: its buttons are disabled)
- Result: ✅ pass

Gates and checks
- Local gates on 008c612, with CI's tool versions: make check ✅ (lint 0 issues · govulncheck no vulnerabilities · gitleaks no leaks · library gate passed) · test-module-add ✅ · Postgres tests 523 pass, 0 fail, only the 4 known environment skips ✅ · story gate ✅ · generated contracts ✅
- Each AC test fails on main before this change (dd006b7) and passes on 008c612.
- An independent verifier and a blind auditor each accepted 4 of 4 ACs on 008c612.
- CI: run 40916770447, all 3 checks pass on 008c612 (Go quality gates, Package admin-portal distribution, Publish control-plane image): https://github.com/LeornaAI/leorna-control-plane/actions/runs/40916770447
- Console run (2026-10-29): the console screenshots come from a server built at 008c612, run locally in dev mode on a throwaway database. The ids on the audit pages belong to that throwaway database.
- Live run: none needed, no AC is live.

NOT VERIFIED
- Nothing left for the acceptance criteria. No desktop Sync was run against a deployed server: AC2 is proven by the server's sync test plus the desktop's own Sync tests.

Note: 86bcm901y-ac1-remove-before.png is the same page as 86bcm901y-ac3-reorder-after.png, because the removal starts from the reordered version 2.
```

## Files to attach (images only, no `.log` or `.txt`), in upload order

The same list as JSON is in `clickup-attachments.json`. All ten images come from the blind auditor's run on PR head `008c612` (`evidence/86bcm901y/auditor-pr/`): one consistent set. The console pages were captured from a demo server built at `008c612` (`auditor-pr/code/demo-binary-vcs.txt`: `vcs.revision=008c6124…`, `vcs.modified=false`), run on 127.0.0.1 in dev mode against its own throwaway `_test` database (`auditor-pr/code/serve.sh.txt`). Its capture log (`auditor-pr/code/capture-run-008c612.log`) records each page's item list as checked before saving and each file's byte count, which match the sizes below.

**Inspection (finisher, 2026-10-29 ~17:52 UTC):** every image was opened. The tall ones were read in bands cut with a Go stdlib cropper in scratch: ac3-reorder-audit 2 bands, ac1-remove-audit 3 bands, ac4-refused-log 2 bands. No image shows a URL bar, server domain, tenant ID, token, email, device code or auth identifier. The visible UUIDs are the demo admin's actor id (`356ebd07-…`) and the demo pack id (`e2e44e22-…`), both from the throwaway database; the version ids are timestamps. Each log image is labelled "local rendering of <log>, unchanged" and matches its `.log` receipt line for line.

| # | Upload name (`file_name`) | Local path | Bytes | What it shows (checked) |
| --- | --- | --- | --- | --- |
| 1 | `86bcm901y-ac3-reorder-before.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac3-reorder-before.png` | 97159 | "Editing Platform team pack · version 1": 1 code-reviewer, 2 github-mcp, 3 pr-description, **4 code-review-and-quality, 5 debugging-and-error-recovery**. The first Move up and last Move down are disabled. |
| 2 | `86bcm901y-ac3-reorder-after.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac3-reorder-after.png` | 99657 | "version 2", "Saved … from version 1": **4 debugging-and-error-recovery, 5 code-review-and-quality** (swapped); the other three unchanged. |
| 3 | `86bcm901y-ac3-reorder-audit.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac3-reorder-audit.png` | 183383 | Change history, newest first: `pack.version.create` with before `order` (… code-review-and-quality, debugging-and-error-recovery), number 1; after `diff.reordered: true`, `order` (… debugging-and-error-recovery, code-review-and-quality), number 2, parentVersion = version 1. Below it, the `pack.create` of version 1. |
| 4 | `86bcm901y-ac1-remove-before.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac1-remove-before.png` | 99657 | Version 2 with five items, **2 github-mcp** listed. Byte-identical to #2 (same sha256): the removal starts from the reordered version 2. Kept so the removal's before/after pair is complete; the comment says so. |
| 5 | `86bcm901y-ac1-remove-after.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac1-remove-after.png` | 91569 | "version 3", "Saved … from version 2": four items, **github-mcp gone**, the rest in the same order. |
| 6 | `86bcm901y-ac1-remove-audit.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac1-remove-audit.png` | 237874 | Newest record `pack.version.create`: before number 2, itemCount 5; after `diff.removed: [mcp_template github-mcp 3.0.0]`, number 3, itemCount 4, parentVersion = version 2, **no `order` key**. The reorder and create records follow. |
| 7 | `86bcm901y-ac2-sync-lockfile-log.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac2-sync-lockfile-log.png` | 113837 | Rendering of `auditor-pr/ac2-008c612.log`: `HEAD=008c6124af3f…`, `go test -v -run '^TestPackItemsAC2…WithPostgres$' ./internal/web`, 4 subtests and the parent PASS, `ok … internal/web`, `EXIT=0`. |
| 8 | `86bcm901y-ac2-client-sync-f105e27.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac2-client-sync-f105e27.png` | 86664 | Rendering of `auditor-pr/ac2-client-sync-f105e27.log`: leorna-client `f105e27`, `TestSyncEndToEndWithLoginMockTLSAndRealWriters`, `TestApplyRemovesOnlyUnchangedManagedFile`, `TestApplyRestoresRemovedFileWhenLaterInstallFails` PASS, `EXIT1=0`, `EXIT2=0`, `EXIT=0`. Included because the card's Verify names a client sync integration test and this is the only image of the desktop half of AC2. |
| 9 | `86bcm901y-ac4-refused-log.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac4-refused-log.png` | 363743 | Rendering of `auditor-pr/ac4-008c612.log`: `HEAD=008c6124af3f…`, 22 subtests (a valid order first, then 21 refusals) and the parent PASS, `ok … internal/web`, `EXIT=0`. |
| 10 | `86bcm901y-ac4-only-item-cannot-be-removed.png` | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/ac4-only-item-cannot-be-removed.png` | 62057 | "Editing Solo pack · version 1" with one item (test-driven-development); Move up, Move down and Remove all disabled. |

Total 1,435,600 bytes.

**Log receipts behind #7–#9** (stay local, never uploaded): `ac2-008c612.log` 5 PASS, 0 FAIL, `EXIT=0`; `ac2-client-sync-f105e27.log` 3 PASS, `EXIT=0`; `ac4-008c612.log` 23 PASS, 0 FAIL, 0 SKIP, `EXIT=0`. All three grep clean for `postgres://`, `password`, `bearer`, `token`, emails, URLs and `tenant`.

## Upload order on "post" (`clickup-evidence.md` step 5)

1. Request all 10 tickets (`clickup_request_attachment_upload`, task 86bcm901y, `file_name` = the upload name above) before the first `curl`. Stop on any denial, so the card never gets a partial set.
2. Upload each file within the ticket's ~3 minutes: `curl -sS -X POST <upload_url> -H 'X-Upload-Ticket: <ticket>' -F 'attachment=@<path>;filename=<file_name>;type=image/png'`.
3. Post the comment from `clickup-comment.txt` with `clickup_create_comment(entity_type=task, entity_id=86bcm901y)`.
4. Read back with `clickup_get_task include=[attachments]`: compare the 10 titles and each `size` with the byte counts above. Then check `clickup_get_task_comments` against `clickup-comment.txt` word by word (the read-back is plain text).
