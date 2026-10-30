# 86bcm901z: ClickUp closing evidence (refreshed for head caf5d96, 2026-10-30; Justin said "ok post")

Card: [Customise a shipped item (company variant)](https://app.clickup.com/t/86bcm901z). Status "in progress", no attachments and no comments (read 2026-10-30 15:40 UTC). Never change its status or checkboxes.

This replaces the 2026-10-29 draft written for head `4904333`, whose images came from `verifier/`, `auditor/` and `fix-3/`. Every image below was taken on the PR head `caf5d96`, in `verifier-pr/` or `auditor-pr/`. PR #105 was still open when this was written (not merged), so the comment states PR facts, not merge facts.

## Comment text

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

## Files to attach (images only; no `.log` or `.txt`)

All six are real PNGs (magic bytes `89 50 4E 47`, matching `.png`), each opened and inspected; the tall one in four bands of 1,300 px (100 px overlap). None shows a server domain, URL bar, tenant ID, token, device code, auth-item id or email: they are headless Chrome renders with no browser frame, "Acme" is the demo company, and the pack's "version id" is a timestamp. Upload each with `clickup_request_attachment_upload` + curl under the name below, then read the card back and compare titles and sizes.

| AC | Local file (absolute path) | Bytes | Upload as (mime) | Inspected | What it shows |
| --- | --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor-pr/ac1-variant-created.png` | 81,584 | `86bcm901z-ac1-variant-created-caf5d96.png` (image/png) | yes, whole (1440×800) | "COMPANY VARIANT · SKILL", `incident-postmortem-acme`, Version 1.0.0, Based on incident-postmortem 1.1.0, "No changes from incident-postmortem 1.1.0 yet", preview |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier-pr/ac2-update-available.png` | 96,425 | `86bcm901z-ac2-update-available-caf5d96.png` (image/png) | yes, whole (1152×672) | "Update available: incident-postmortem 1.2.0", "Your variant is based on 1.1.0", upstream's main-text diff (two hunks), no supporting-file changes, "Merging is clean", Merge 1.2.0 / Ignore 1.2.0 (byte-identical to `auditor-pr/ac2-update-available.png`) |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor-pr/ac2-after-merge.png` | 87,054 | `86bcm901z-ac2-after-merge-caf5d96.png` (image/png) | yes, whole (1440×800) | After Merge: Version 1.2.0, Based on incident-postmortem 1.2.0, "Your changes" keeps "Attach the Acme status page link." |
| AC3 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier-pr/ac3-pack-with-variant.png` | 73,080 | `86bcm901z-ac3-pack-with-variant-caf5d96.png` (image/png) | yes, whole (1152×409) | "Editing Acme incident pack · version 1": `debugging-and-error-recovery` 1.0.0 and `incident-postmortem-acme` 1.2.0, each with Move up / Move down / Remove |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier-pr/ac4-secret-refused.png` | 499,544 | `86bcm901z-ac4-secret-refused-caf5d96.png` (image/png) | yes, 4 bands (1440×4322) | Alert "suspected secret in main body (rule github-pat). Remove it before saving", Version 1.1.0, Description and Main text boxes empty, no token text anywhere on the page |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor-pr/ac4-refused-terminal.png` | 297,475 | `86bcm901z-ac4-test-run-caf5d96.png` (image/png) | yes, whole (1440×800); matches `auditor-pr/ac4-caf5d96.log` line for line | Labelled "86bcm901z AC auditor (PR head): AC4 test run, log ac4-caf5d96.log rendered as text": `HEAD=caf5d96…`, 14 subtests PASS, `ok … internal/web 5.479s`, `EXIT=0` |

No gates image: none exists for `caf5d96` in the evidence folders, so the gates are stated in the comment text and backed by CI run 41061511703. `gates-4904333.png` and `fix-3/item-editor-refused-files-required-4904333.png` (a JPEG named `.png`) are history and are not attached.

Kept local (receipts, not uploaded): `verifier-pr/*.log`, `verifier-pr/*.txt`, `verifier-pr/pg-caf5d96.json`, `verifier-pr/mutants/`, `auditor-pr/*.log`, `auditor-pr/mutants-caf5d96.log`.
