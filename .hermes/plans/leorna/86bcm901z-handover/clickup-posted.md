# 86bcm901z: ClickUp closing evidence as posted (2026-10-30)

Card: [Customise a shipped item (company variant)](https://app.clickup.com/t/86bcm901z). Posted by the "post" finisher after Justin said "ok post". Card status left as "in progress"; no field, checkbox, tag or assignee changed.

- PR #105 at post time: OPEN, not merged, head `caf5d9659953cbab3e6141eddd4193762f96aeff`, mergeable CLEAN (read 2026-10-30 15:41 UTC). CI run 41061511703: 3 of 3 checks pass on that head.
- Comment id `90140275747138`, posted 2026-10-30T15:43:11Z, 5,391 characters, `notify_all: false`. Read back with `clickup_get_task_comments`: the only comment on the card, and its text equals the posted text word for word (750 words; the read-back strips table pipes and bullets).
- Attachments: uploaded with `clickup_request_attachment_upload` + curl, all HTTP 200, 2026-10-30 15:42:32–15:42:47 UTC. Read back with `clickup_get_task include=[attachments]`: exactly these six, each once, each `size` equal to the local byte count. No wrong or duplicate upload, so nothing for Justin to delete.

| AC | ClickUp title | ClickUp id | Bytes (local = ClickUp) | Mime | Local file |
| --- | --- | --- | --- | --- | --- |
| AC1 | 86bcm901z-ac1-variant-created-caf5d96.png | 54b2209a-051f-4602-b67b-62e20ab165bf.png | 81,584 | image/png | /home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor-pr/ac1-variant-created.png |
| AC2 | 86bcm901z-ac2-update-available-caf5d96.png | c7f44303-5800-47f8-b32a-d63d9c864863.png | 96,425 | image/png | /home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier-pr/ac2-update-available.png |
| AC2 | 86bcm901z-ac2-after-merge-caf5d96.png | aff98e1e-19e6-4179-8239-5dc8cd86c0ab.png | 87,054 | image/png | /home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor-pr/ac2-after-merge.png |
| AC3 | 86bcm901z-ac3-pack-with-variant-caf5d96.png | c4fd99ca-cd37-403f-b9a4-976b58137b97.png | 73,080 | image/png | /home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier-pr/ac3-pack-with-variant.png |
| AC4 | 86bcm901z-ac4-secret-refused-caf5d96.png | 4a36cf2c-9470-4863-8916-99c9030291af.png | 499,544 | image/png | /home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier-pr/ac4-secret-refused.png |
| AC4 | 86bcm901z-ac4-test-run-caf5d96.png | 76e83446-f02b-4a22-ac94-e16f6a784ce2.png | 297,475 | image/png | /home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor-pr/ac4-refused-terminal.png |

Each file's magic bytes are PNG (`89 50 4E 47`), matching `.png`. Each was inspected visually (the 1440×4322 refusal page in four 1,300 px bands): no server domain, URL bar, tenant ID, token, device code, auth-item id or email.

## Posted comment text

```
✅ Closing evidence — Customise a shipped item (company variant) (86bcm901z)

WHAT WAS DONE
leorna-control-plane PR #105: https://github.com/LeornaAI/leorna-control-plane/pull/105
State: open. Ready to merge; not merged yet (read 2026-10-30 15:41 UTC). Head caf5d96. +5522/-101, 34 files. GitHub: mergeable, clean.
An admin can customise a shipped skill, agent or prompt into a company variant, linked to the library item and the exact version it came from.
When a newer version ships, the variant shows "Update available" with upstream's diff, and the admin can merge it (three-way, with a conflict resolver) or ignore that version.
A variant goes into packs exactly like a shipped item: tick it, reorder or remove it, assign the pack and Sync.
One new table, library_variants (migration 27, additive). Every variant page and form is admin-only, CSRF-checked, audited and limited to the admin's own company.

WHAT WAS VERIFIED (all on head caf5d96)

| AC | Test | Screenshots | Result |
| --- | --- | --- | --- |
| AC1: Given a library item, when I customise it, then a tenant-owned variant is created linked to the upstream item + version | TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres (7 subtests) | 86bcm901z-ac1-variant-created-caf5d96.png | ✅ pass |
| AC2: Given a newer upstream version, then the admin sees an 'update available' notice with a diff and can merge or ignore | TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres (5 subtests) | 86bcm901z-ac2-update-available-caf5d96.png, 86bcm901z-ac2-after-merge-caf5d96.png | ✅ pass |
| AC3: Given a variant, then it is used in packs exactly like a library item | TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres (8 subtests) | 86bcm901z-ac3-pack-with-variant-caf5d96.png | ✅ pass |
| AC4 (proposed, approved with the plan): refused variant requests write nothing and stay inside the company | TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres (14 subtests) | 86bcm901z-ac4-secret-refused-caf5d96.png, 86bcm901z-ac4-test-run-caf5d96.png | ✅ pass |

What the screenshots show:
- ac1-variant-created: the new variant incident-postmortem-acme, version 1.0.0, "Based on incident-postmortem 1.1.0".
- ac2-update-available: after restarting on the same database with a release that ships incident-postmortem 1.2.0: "Update available: incident-postmortem 1.2.0", upstream's diff, "Merging is clean", Merge 1.2.0 and Ignore 1.2.0. ac2-after-merge: the variant at 1.2.0, based on 1.2.0, still holding the company's own added line.
- ac3-pack-with-variant: "Acme incident pack" version 1 holding a shipped skill and the variant, each with Move up, Move down and Remove.
- ac4-secret-refused: a variant edit holding a fake GitHub token is refused ("suspected secret in main body"); the version stays 1.1.0, the boxes are cleared and no part of the token is on the page. ac4-test-run: the AC4 test on caf5d96 (the blind auditor's log, rendered as an image and labelled so): 14 subtests pass, EXIT=0. The cases: a member, signed out, a bad CSRF token, another company, configs and MCP templates, name rules, stale and unchanged edits, five suspected-secret cases, merge or ignore with no newer upstream, unknown ids.

Gates and checks
- Local gates on caf5d96, with CI's tool versions, run by the independent verifier: make check ✅ (lint 0 issues · govulncheck no called vulnerability · gitleaks no leaks · library gate passed) · test-module-add ✅ · Postgres tests over the database packages: 348 of 355 top-level tests pass, 0 fail, only the 9 known environment skips (ClickHouse, evidence folder, live Scaleway) ✅ · gitleaks over the branch's commits and the merged files ✅
- Each AC test fails on main before this change (9135f4e, where it doesn't build) and passes on caf5d96.
- An independent verifier and a blind auditor each accepted 4 of 4 ACs on caf5d96. Mutation checks: the AC tests caught 30 of 30 (verifier) and 23 of 23 (auditor) deliberate breaks.
- Six fresh code reviews, the last one on caf5d96 clean. The three P2 findings of rounds 1 to 3 were fixed (an agent rename blocking a merge, a secret shown back, emptied file boxes).
- CI: run 41061511703, all 3 checks pass on caf5d96 (Go quality gates, Publish control-plane image, Package admin-portal distribution): https://github.com/LeornaAI/leorna-control-plane/actions/runs/41061511703
- Console run (2026-10-30): the console screenshots come from real binaries built at caf5d96, run locally in dev mode on throwaway databases with headless Chrome. "Acme" is the demo company.
- Live run: none needed, no AC is live.

Justin's decisions
- The item editor's same secret-echo defect was fixed in this story too: a suspected-secret refusal clears every typed field, and supporting-file boxes it empties are marked required.
- main was brought in twice (#101 to #104), and the migration was renumbered to 000027_library_variants with the same SQL.

Follow-ups (not in this PR): edit a variant's supporting files, a variant JSON API, replace-with-upstream and rename, tell admins when an update arrives, a rare diff tie-break case in clean merges, and a test for the 2,000-line diff cap. The full list is in PR #105.

NOT VERIFIED
Nothing left for the acceptance criteria. PR #105 is not merged yet, so there is no CI run on main for it.
```
