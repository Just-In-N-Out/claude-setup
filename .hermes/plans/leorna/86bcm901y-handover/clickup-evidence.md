# ClickUp evidence draft: 86bcm901y (post only when Justin says "post")

Card: [Remove and reorder items in a pack version](https://app.clickup.com/t/86bcm901y). It had 0 attachments when read on 2026-10-29 around 14:37 UTC. **Not uploaded and not posted.** Fill in the `<…>` merge facts on "post". Never change the card's status or checkboxes.

## Closing comment (paste after the merge facts are filled in)

```
✅ Closing evidence — Remove and reorder items in a pack version (86bcm901y)

WHAT WAS DONE
- leorna-control-plane PR #<n> (merged <date>, merge <sha7>, +1855/-54, 21 files): a pack's edit view lists its items in order with Move up, Move down and Remove. Each click saves a new immutable version (parent unchanged) and an audit record. The admin API takes an optional `order`. A removed item's files leave engineers' tools on their next Sync once the new version is assigned.

WHAT WAS VERIFIED
| Acceptance criterion | Test / evidence | Result |
| --- | --- | --- |
| AC1: Given a pack version, when I remove an item, then a new version is saved without it and audited | `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres` (5 subtests) + ac1-remove-before.png → ac1-remove-after.png (version 2 with github-mcp → version 3 without it) + ac1-remove-audit.png | ✅ |
| AC2: Given a removal, when engineers next sync, then the item's files are removed from their tools (or flagged) consistently with the lockfile | `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres` (4 subtests: nothing changes until the new version is assigned; then the lockfile drops exactly the item's files, other hashes unchanged, old digest refused) + ac2-sync-lockfile-log.png. Desktop half: the client's existing Sync tests pass, read-only (it deletes dropped files and keeps an edited one) | ✅ |
| AC3: Given a pack version, when I reorder its items (Move up / Move down or the API's order), then a new version is saved in the new order, shown in the console and API, the parent keeps its order, the save is audited with both orders, and it syncs the same files and hashes | `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres` (6 subtests) + ac3-reorder-before.png → ac3-reorder-after.png (version 1 → version 2, items 4 and 5 swapped) + ac3-reorder-audit.png | ✅ |
| AC4: Given an invalid or not allowed remove or reorder, then it is refused with a clear status or alert and nothing is written | `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres` (22 subtests: only item, first up, last down, unknown item, outdated version, bad orders, member, bad CSRF, another company's pack, signed out, form over 4 KiB …) + ac4-refused-log.png + ac4-only-item-cannot-be-removed.png | ✅ |
- Gates on 3e8d181: make check ✅ (lint 0 issues · govulncheck no vulnerabilities · gitleaks no leaks · library gate PASSED) · test-module-add ✅ · Postgres tests 523 pass, 0 fail, only the 4 accepted skips ✅ · story gate ✅ · container build ✅
- Each AC test fails on the old code (6c1709e) and passes on 3e8d181. An independent verifier and a blind auditor each accepted 4 of 4 ACs.
- CI on merge: Go quality gates <✅> — <Actions run URL>
- Console run (2026-10-29): a binary built at 3e8d181, in dev mode on a throwaway database. Reordered and removed items in the admin console and checked the change history. The screenshots attached are from that run.

NOT VERIFIED
- Nothing left for the acceptance criteria. No criterion needed a live run on a deployed server, and none was done: the removal reaching tools is proven by the server's sync test plus the client's own Sync tests, not by a desktop Sync against a server.
```

**Before posting**, replace `<n>`, `<date>`, `<sha7>`, `<✅>` and the Actions run URL with the real values. Read them with `gh pr view <n> --json mergedAt,mergeCommit` and `gh run list --branch main`. Until the PR is pushed, the CI line reads "CI: not run yet, not pushed".

## Files to attach (images only, no `.log` or `.txt`)

All the images come from the blind auditor's run on head `3e8d181`. It used one consistent set, from a binary built at `3e8d181` with `vcs.modified=false` (`evidence/86bcm901y/auditor/capture-3e8d181.log`, which also records each page's item list as checked before saving). I chose it over the verifier's set because it has one audit page per action, which is what Justin asked for. Each image was opened and checked by the finisher on 2026-10-29. The two tall audit pages were read in two bands each. None shows a URL bar, server domain, tenant ID, token or email. The visible UUIDs (actor and pack ids) and version ids belong to the throwaway demo database.

| # | AC | File (absolute path) | Bytes | What it shows (checked) |
| --- | --- | --- | --- | --- |
| 1 | AC3 before | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac3-reorder-before.png` | 97557 | "Editing Platform team pack · version 1": 1 code-reviewer, 2 github-mcp, 3 pr-description, **4 code-review-and-quality, 5 debugging-and-error-recovery**. The first Move up and last Move down are disabled. |
| 2 | AC3 after | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac3-reorder-after.png` | 99307 | "version 2", "Saved … from version 1": items **4 debugging-and-error-recovery, 5 code-review-and-quality** (swapped); the others are unchanged. |
| 3 | AC3 audit | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac3-reorder-audit.png` | 178086 | Change history, newest first: `pack.version.create` with before `order` (…code-review-and-quality, debugging…, number 1) and after `diff.reordered: true` plus `order` (…debugging…, code-review-and-quality, number 2, parentVersion = v1). Below it, the `pack.create` of version 1. |
| 4 | AC1 before | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac1-remove-before.png` | 99307 | Version 2 with five items, **2 github-mcp** listed. This is the same page as #2 and byte-identical to it: the removal starts from the reordered version 2. Attaching both keeps each before/after pair complete; drop #4 if one copy is enough. |
| 5 | AC1 after | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac1-remove-after.png` | 91932 | "version 3", "Saved … from version 2": four items; **github-mcp is gone**. |
| 6 | AC1 audit | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac1-remove-audit.png` | 230687 | Newest record `pack.version.create`: before number 2, itemCount 5; after `diff.removed: [mcp_template github-mcp 2.0.0]`, number 3, itemCount 4, **no `order` key**. The reorder and create records follow below. |
| 7 | AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac2-sync-lockfile-log.png` | 106459 | A local rendering of `auditor/ac2-3e8d181.log`: `HEAD=3e8d181…`, the run of `TestPackItemsAC2…WithPostgres`, 4 subtests PASS, `ok … internal/web`, `EXIT=0`. |
| 8 | AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac4-refused-log.png` | 353435 | A local rendering of `auditor/ac4-3e8d181.log`: `HEAD=3e8d181…`, 22 subtests listed, every one PASS, `ok … internal/web`, `EXIT=0`. |
| 9 | AC4 (extra) | `/home/justin/.hermes/plans/leorna/evidence/86bcm901y/auditor/ac4-only-item-cannot-be-removed.png` | 62093 | "Editing Solo pack · version 1" with one item (test-driven-development), and Move up, Move down and Remove all disabled. |

Logs behind #7 and #8: `auditor/ac2-3e8d181.log` (5 PASS lines, `EXIT=0`) and `auditor/ac4-3e8d181.log` (23 PASS lines, `EXIT=0`). Both grep clean for `postgres://`, `password`, `bearer`, emails and URLs. They stay local as receipts.

## Upload order on "post" (`clickup-evidence.md` step 5)
1. Request all 9 tickets (`clickup_request_attachment_upload`, task 86bcm901y, `file_name` = the basename) before the first `curl`. Stop on any denial, so the card never gets a partial set.
2. Upload each file within the ticket's ~3 minutes.
3. Post the comment with `clickup_create_comment(entity_type=task, entity_id=86bcm901y)`.
4. Read back with `clickup_get_task include=[attachments]`: compare titles and `size` with the byte counts above. Then check `clickup_get_task_comments` against the draft word by word.
