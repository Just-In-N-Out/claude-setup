✅ Closing evidence — Create a pack by picking library items (86bcm901w)

WHAT WAS DONE
- leorna-control-plane PR #96 (merged 2026-10-29, merge 6c1709e, +6713/-1420, 24 files; most of the lines are regenerated OpenAPI code): admins tick items on the Content library page, name the pack and save, which creates version 1. Reopening the pack and ticking or unticking items saves version 2, 3, … as new immutable versions with ParentVersion set. Every save writes a change record (actor, action, diff). An admin-only JSON API (/v1/packs) does the same and is in the OpenAPI contract. Migration 23 adds packs with names unique per company and makes saved pack versions impossible to edit or delete in the database.

WHAT WAS VERIFIED
| Acceptance criterion | Test / evidence | Result |
| --- | --- | --- |
| AC1: Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items | `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres` (3 subtests, real Postgres) + ac1-new-pack-version-1-5a9aa2f.png | ✅ |
| AC2: Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set | `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres` (4 subtests; the database refuses UPDATE/DELETE of saved versions) + ac2-pack-version-2-5a9aa2f.png | ✅ |
| AC3: Given a save, then a change-audit record is written (actor, action, diff) | `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres` (6 subtests; a failed audit write saves nothing) + ac3-audit-history-5a9aa2f.png | ✅ |
| AC4 (added with the plan): an invalid or not-allowed save is refused with a clear status and writes nothing (no name, no items, unknown or repeated item, name taken, nothing changed, pack left empty, outdated version, member, bad CSRF, another company's pack, and more) | `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres` (15 subtests) + ac4-refused-saves-log-5a9aa2f.png (log rendering) | ✅ |
- All 4 ACs were proven on the merged PR head 5a9aa2f twice, separately: by an independent verifier and by a blind AC auditor that never saw the verifier's report.
- Each AC test fails on the old code (main before this story, a8d1465): build failure, because the pack builder doesn't exist there.
- Gates on 5a9aa2f (independent verifier, own test database): make check ✅ (fmt, vet, race tests, lint 0 issues, govulncheck no called vulnerability, gitleaks no leaks, library gate PASSED) · module-add ✅ · Postgres tests 554 pass, 0 fail, only the 4 known opt-in skips ✅ · story gate ✅ · secret scan of the story's commits and of the 4 files merged with main ✅ (gates-5a9aa2f.png).
- Mutation testing: blind AC auditor on 5a9aa2f 20/20 mutants killed; independent verifier on 8a50486 39/39 killed (the story's own files are unchanged since, apart from the merge with main in 4 shared files).
- CI on the PR head 5a9aa2f: Go quality gates ✅ · Publish control-plane image ✅ · Package admin-portal distribution ✅ — https://github.com/LeornaAI/leorna-control-plane/actions/runs/40804136869
- CI on main after merge (6c1709e): Go quality gates ✅ · Publish control-plane image ✅ · Package admin-portal distribution ✅ — https://github.com/LeornaAI/leorna-control-plane/actions/runs/40832867438
- Story shippable check (scripts/check-story-shippable.py 86bcm901w) on main 6c1709e: ✅ "Merge/CI gate passed".
- Live run: none needed; no AC needs a live server. Demo: the admin console in dev mode on a throwaway local database, with a binary built at 5a9aa2f. 4 items ticked and Create pack gave "Backend team pack · version 1" with exactly those items; github-mcp unticked and security-auditor ticked gave version 2 "from version 1"; the pack's change history showed pack.create and pack.version.create with actor, before and diff. Screenshots attached.

NOT VERIFIED
- Nothing for AC1–AC4.
