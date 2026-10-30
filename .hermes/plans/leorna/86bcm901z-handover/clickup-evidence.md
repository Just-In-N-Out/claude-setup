# 86bcm901z: ClickUp closing evidence (DRAFT, post only when Justin says "post")

Card: [Customise a shipped item (company variant)](https://app.clickup.com/t/86bcm901z). Status "in progress"; no attachments yet (read 2026-10-29). Never change its status or checkboxes.

Before posting, fill in the `<…>` merge facts (PR number, merge date and SHA, +/− and file count from the PR, the CI run). If the head that merges isn't `4904333` (it won't be: bringing main in adds a merge commit), keep the images as they are: they show `4904333`, whose code the merge keeps. Replace the gates line with the run on the merged head, and say which head each image is from.

## Comment text

```
✅ Closing evidence — Customise a shipped item (company variant) (86bcm901z)

WHAT WAS DONE
- leorna-control-plane PR #<n> (merged <date>, merge <sha7>, +<add>/-<del>, <N> files): an admin can customise a shipped skill, agent or prompt into a company variant linked to its upstream item and version, see "Update available" with a diff when a newer version ships, merge it (three-way, with a conflict resolver) or ignore that version, and use the variant in packs exactly like a shipped item. One new table (migration 27, additive). Also fixes the item editor so a suspected secret clears every typed field and cleared file boxes are required.

WHAT WAS VERIFIED
| Acceptance criterion | Test / evidence | Result |
| --- | --- | --- |
| AC1: Given a library item, when I customise it, then a tenant-owned variant is created linked to the upstream item + version | `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres` (7 subtests) + ac1-variant-created-4904333.png, ac1-library-lists-variant-4904333.png | ✅ |
| AC2: Given a newer upstream version, then the admin sees an 'update available' notice with a diff and can merge or ignore | `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres` (5 subtests) + ac2-update-available-4904333.png, ac2-library-update-chip-4904333.png, ac2-after-merge-4904333.png | ✅ |
| AC3: Given a variant, then it is used in packs exactly like a library item | `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres` (8 subtests) + ac3-pack-with-variant-4904333.png | ✅ |
| AC4: Refused variant requests (member, signed out, bad CSRF, another company, config/MCP, names, stale edits, suspected secret, no newer upstream, unknown id) write nothing, never echo a secret and stay inside the company | `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres` (14 subtests) + ac4-secret-refused-4904333.png, ac4-name-taken-alert-4904333.png, ac4-test-run-4904333.png | ✅ |
- Each AC test passed on 4904333 for two independent agents (pipeline verifier and blind auditor), with 0 skips, and fails on the base commit. ac-check: ALL ACCEPTED, 4 of 4 ACs, on a head every commit of which a clean review covers.
- Gates on 4904333: make check ✅ (fmt, vet, go test -race with real PostgreSQL, golangci-lint 0 issues, govulncheck no called vulnerability, gitleaks no leaks, library gate PASSED) · test-module-add ✅ · Postgres tests read per test: 318/320 top-level passed, the 2 others plus 2 subtests are the allowed skips (ClickHouse, live Scaleway, evidence dir) · gitleaks over the story's 19 commits ✅ · mutation checks: 36/36 (verifier) and 16/16 (auditor) killed (gates-4904333.png)
- Item editor fix (added during review): item-editor-refused-files-required-4904333.jpg
- CI on merge: <Go quality gates ✅ · Publish control-plane image ✅ · Package admin-portal distribution ✅ — Actions run <id>>   (not run yet: nothing is pushed)
- Live run: none needed, no AC is live. The card's "UI demo" was run by agents on real binaries: release A, then a release B carrying a newer incident-postmortem 1.2.0, restarted on the same database, in dev mode on loopback with headless Chrome. The screenshots above come from it.

NOT VERIFIED
- <nothing left, once CI on merge is green>
```

## Files to attach (images only; no `.log` or `.txt`)

Every image was opened and read. Tall ones were checked in 1,300 px bands. None shows a server domain, URL bar, tenant ID, token, device code or email: they are headless Chrome renders with no browser frame, and "Acme" is the demo company. Upload each with `clickup_request_attachment_upload` + curl, using the upload name below (`file_name` renames it). Then read the card back and compare titles and sizes.

| AC | Local file (absolute path) | Bytes | Upload as | Inspected | What it shows |
| --- | --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor/ac1-variant-created.png` | 81,928 | `ac1-variant-created-4904333.png` (image/png) | yes, whole (1440×800) | Real console, head binary: "COMPANY VARIANT · SKILL", `incident-postmortem-acme`, Version 1.0.0, "Based on incident-postmortem 1.1.0", "No changes from incident-postmortem 1.1.0 yet", preview |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier/ac1-library-lists-variant.png` | 181,041 | `ac1-library-lists-variant-4904333.png` (image/png) | yes, whole (1440×1162) | Content library ("…and your company's variants of them"), search "incident": the shipped `incident-postmortem` 1.1.0 and `incident-postmortem-acme` with the "Company variant" chip, 1.0.0, "Based on incident-postmortem 1.1.0" |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier/ac2-update-available.png` | 96,425 | `ac2-update-available-4904333.png` (image/png) | yes, whole (1152×672) | Release B on the same DB: "Update available: incident-postmortem 1.2.0", "Your variant is based on 1.1.0", upstream's main-text diff (two hunks), "No changes to supporting files", "Merging is clean", buttons Merge 1.2.0 / Ignore 1.2.0 |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier/ac2-library-update-chip.png` | 184,069 | `ac2-library-update-chip-4904333.png` (image/png) | yes, whole (1440×1185) | Library on release B: shipped item now 1.2.0; the variant (1.1.0) carries "Company variant" and "Update available: 1.2.0" chips |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor/ac2-after-merge.png` | 87,260 | `ac2-after-merge-4904333.png` (image/png) | yes, whole (1440×800) | After Merge: variant Version 1.2.0, "Based on incident-postmortem 1.2.0"; "Your changes" still shows the company's added line ("Attach the Acme status page link") |
| AC3 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier/ac3-pack-with-variant.png` | 73,226 | `ac3-pack-with-variant-4904333.png` (image/png) | yes, whole (1152×409) | "Editing Acme incident pack · version 1": items `debugging-and-error-recovery` 1.0.0 (shipped skill) and `incident-postmortem-acme` 1.1.0 (the variant), each with Move up / Move down / Remove. The version id shown is a timestamp, not a tenant ID |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/verifier/ac4-secret-refused.png` | 499,745 | `ac4-secret-refused-4904333.png` (image/png) | yes, 4 bands (1440×4322) | Variant edit holding a fake GitHub token refused: alert "suspected secret in main body (rule github-pat). Remove it before saving", Version still 1.1.0, Description and Main text boxes empty; no part of the token anywhere on the page |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor/ac4-name-taken-alert.png` | 46,866 | `ac4-name-taken-alert-4904333.png` (image/png) | yes, whole (1152×344) | "Customise for your company": 409 alert "Your company already has a skill variant named incident-postmortem-acme. Choose another name.", the name kept, "Your variants: incident-postmortem-acme (1.1.0)" |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/auditor/ac4-refused-terminal.png` | 305,912 | `ac4-test-run-4904333.png` (image/png) | yes, whole (1400×715) | The auditor's AC4 run, rendered from its own log (labelled so at the top): `HEAD=4904333…`, the `go test -v -run '^TestVariantAC4…$' ./internal/web` command, 14 subtests PASS, `ok … 6.059s`, `EXIT=0` |
| Gates | `/home/justin/.hermes/plans/leorna/86bcm901z-handover/gates-4904333.png` | 362,229 | `gates-4904333.png` (image/png) | yes, 2 bands (1400×1758) | A rendering of the verifier's own logs, labelled as such: `gates-summary-4904333.txt` and `pg-summary-4904333.txt` verbatim, plus a `make-check-4904333.log` excerpt (omitted lines marked "…", toolchain path shown as `<toolchain>`): lint 0 issues, govulncheck no called vulnerability, gitleaks no leaks, library-gate PASSED, `EXIT=0`. Made by the finisher (source: `gates-4904333-source.html` beside it) |
| Item editor (added scope) | `/home/justin/.hermes/plans/leorna/evidence/86bcm901z/fix-3/item-editor-refused-files-required-4904333.png` | 172,196 | `item-editor-refused-files-required-4904333.jpg` (**image/jpeg**: the file is a JPEG despite its `.png` name) | yes, 3 bands (1440×2745) | Item editor "Edit Skill" after a secret refusal: alert "suspected secret in main body (rule github-pat)…", note "Supporting file text was cleared. Enter it again, upload the file again or remove the file before saving.", Description, Main body and both supporting-file boxes empty, paths kept |

Kept local (receipts, not uploaded):
- `verifier/*-4904333.log`, `verifier/pg-4904333.json` and `verifier/migration-fill-4904333.log`;
- `auditor/*.log`, `auditor/mutants/`;
- `86bcm901z-handover/gates-4904333-source.html`.

The builder's older `99382cc` captures (`ac1-customise-form.png`, `ac2-after-ignore.png`, `ac2-merge-conflict.png`, `ac3-sync-terminal.png`, the base "before" shots) are extra. Their pages didn't change after `99382cc`, but each AC already has images from the accepted head, so they're left out to keep the card short. Add them only if Justin wants the before/after and conflict views.
