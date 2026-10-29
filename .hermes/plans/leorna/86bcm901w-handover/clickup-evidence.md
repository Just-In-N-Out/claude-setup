# 86bcm901w ClickUp evidence draft (post only when Justin says "post")

> **POSTED 2026-10-29 (07:15 UTC) after Justin's "post"**, brought up to the merged head: PR #96 merged 2026-10-29T07:02:18Z, merge `6c1709e`, PR head `5a9aa2f`; main push CI run 40832867438 (3/3 jobs success); `check-story-shippable.py 86bcm901w` on main 6c1709e: "Merge/CI gate passed" (EXIT=0).
> - **Comment id `90140274994943`**; the exact text posted is `~/.hermes/plans/leorna/86bcm901w-handover/clickup-comment-posted.md` (read back word for word: 548/548 words equal). It supersedes the 8a50486 comment below.
> - **Attachments (5, read back, every size equal to the local bytes):** `ac1-new-pack-version-1-5a9aa2f.png` (1,841,269 B, 1440×7794, from `auditor-5a9aa2f/ac1-new-pack-version-1.png`), `ac2-pack-version-2-5a9aa2f.png` (1,843,295 B, 1440×7813, `auditor-5a9aa2f/ac2-pack-version-2.png`), `ac3-audit-history-5a9aa2f.png` (162,286 B, 1440×1053, `auditor-5a9aa2f/ac3-audit-history.png`), `ac4-refused-saves-log-5a9aa2f.png` (236,198 B, 1500×860, `auditor-5a9aa2f/ac4-refused-saves-log.png`), `gates-5a9aa2f.png` (805,179 B, 1400×2940, the finisher's rendering of `verifier-5a9aa2f/gates-make-check-5a9aa2f.txt`, ANSI stripped, govulncheck's public DB URL line shortened and labelled; file in this folder). None of the 8a50486 files in the table below was uploaded.
> - Card status ("in progress"), assignee, tags and AC checkboxes unchanged; Justin moves the card.

- **Card:** [Create a pack by picking library items](https://app.clickup.com/t/86bcm901w) (status "in progress"; read 2026-10-28; no attachments on it yet).
- **Before posting:** fill in the `<…>` merge facts (PR number, merge date and SHA, CI run). Never change the card's status or tick its checkboxes.

## Comment (paste after filling the placeholders)

```
✅ Closing evidence — Create a pack by picking library items (86bcm901w)

WHAT WAS DONE
- leorna-control-plane PR #<n> (merged <date>, merge <sha7>, +6713/-1420, 24 files; most of the lines are regenerated OpenAPI code): admins tick items on the Content library page, name the pack and save, which creates version 1. Reopening the pack and ticking or unticking items saves version 2, 3, … as new immutable versions with ParentVersion set. Every save writes a change record (actor, action, diff). An admin-only JSON API (/v1/packs) does the same and is in the OpenAPI contract. Migration 23 adds packs with names unique per company and makes saved pack versions impossible to edit or delete in the database.

WHAT WAS VERIFIED
| Acceptance criterion | Test / evidence | Result |
| --- | --- | --- |
| AC1: Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items | `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres` (3 subtests, real Postgres) + ac1-new-pack-version-1.png | ✅ |
| AC2: Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set | `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres` (4 subtests; the database refuses UPDATE/DELETE of saved versions) + ac2-pack-version-2.png | ✅ |
| AC3: Given a save, then a change-audit record is written (actor, action, diff) | `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres` (6 subtests; a failed audit write saves nothing) + ac3-audit-diff.png | ✅ |
| AC4 (added with the plan): an invalid or not-allowed save is refused with a clear status and writes nothing (no name, no items, unknown or repeated item, name taken, nothing changed, pack left empty, outdated version, member, bad CSRF, another company's pack, and more) | `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres` (15 subtests) + ac4-refused-saves-terminal.png (log rendering) | ✅ |
- Each AC test fails on the old code (main before this story): build failure, because the pack builder doesn't exist there.
- Gates on 8a50486 (independent verifier, own test database): make check ✅ (fmt, vet, race tests, lint 0 issues, govulncheck no called vulnerability, gitleaks no leaks, library gate PASSED) · module-add ✅ · Postgres tests 536 pass, 0 fail, only the 4 known opt-in skips ✅ · story gate ✅ · story secret scan ✅ (gates-8a50486.png).
- Mutation testing on 8a50486: independent verifier 39/39 killed; blind AC auditor 15/15 killed.
- CI on merge: Go quality gates <✅/❌> — <Actions run URL>
- Live run: none needed; no AC needs a live server. Demo: the admin console in dev mode on a throwaway local database, with a binary built at 8a50486. 4 items ticked and Create pack gave version 1; one unticked and one ticked gave version 2 "from version 1"; the pack's change history showed both records with actor and diff; the same name in other case got the 409 alert. Screenshots attached.

NOT VERIFIED
- Nothing for AC1–AC4.
```

**Until the PR exists and CI has run,** the two lines that depend on them read:

- `WHAT WAS DONE`: "leorna-control-plane branch feat/86bcm901w-create-pack (not pushed yet, head 8a50486, +6713/-1420, 24 files): …"
- `CI`: "CI: not run yet, not pushed."

## Files to attach (images only; no `.log` or `.txt`)

Each image was opened and inspected by the finisher on 2026-10-28. Tall pages were inspected in 1,300 px bands (Read shrinks a 6,400 px page too far to read). None shows a URL bar, server domain, tenant ID, token, email or `/dev/login`. The console captures come from the blind AC auditor's run, with a binary built at `8a50486` (`go version -m`: `vcs.revision=8a50486…`, `vcs.modified=false`), dev mode on loopback, and a throwaway DB that was dropped afterwards (`auditor/demo-run-8a50486.txt`).

| AC | Local file (absolute path) | Bytes | Size (px) | Upload as | What it shows |
| --- | --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901w/auditor/ac1-new-pack-version-1.png` | 1,560,667 | 1440×6434 | `ac1-new-pack-version-1-8a50486.png` | "Editing Platform team pack · version 1"; exactly the 4 ticked items (github-mcp, incident-postmortem, security-and-hardening, test-driven-development) marked "in pack"; the other 28 unticked |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901w/auditor/ac2-pack-version-2.png` | 1,562,362 | 1440×6453 | `ac2-pack-version-2-8a50486.png` | "Editing Platform team pack · version 2", "Saved … from version 1"; github-mcp unticked; debugging-and-error-recovery added |
| AC3 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901w/auditor/ac3-audit-diff.png` | 164,931 | 1440×1600 | `ac3-audit-diff-8a50486.png` | Change history filtered to the pack: `pack.version.create` (before: number 1, version, item count; after: diff added debugging-and-error-recovery, removed github-mcp, number 2, parentVersion) and `pack.create` (before null; after: diff of the 4 added items, number 1). The actor and pack UUIDs come from the throwaway demo DB, which the plan accepts. No tenant ID column. |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm901w/auditor/ac4-refused-saves-terminal.png` | 233,378 | 1500×780 | `ac4-refused-saves-log-8a50486.png` | Log rendering, labelled as such, of `auditor/ac4-8a50486.log` (EXIT=0 read from the file): HEAD line, the `go test -run '^TestPackBuilderAC4…$'` command, 15 subtest PASS lines, `ok`, `EXIT=0`. No path, URL, token or DB detail. |
| Gates (extra) | `/home/justin/.hermes/plans/leorna/86bcm901w-handover/gates-8a50486.png` | 686,852 | 1400×2700 | `gates-8a50486.png` | **The finisher's rendering** (HTML `<pre>`, headless Chrome for Testing, ANSI colours stripped) of the verifier's `verifier/gates-make-check-8a50486.txt` (EXIT=0 read from the file). It shows the tool versions, the bound binaries, every package `ok`, lint `0 issues` ×2, govulncheck "No vulnerabilities found", gitleaks "no leaks found", library-gate PASSED and `EXIT=0`. The only host-like text is gitleaks' `host=github-leorna` (the SSH alias for GitHub); the DB line is a loopback port with no password. |

**Optional extras, inspected by the builder and the auditor, not by me:**

- `auditor/ac1-ticked-before-save.png` (1,464,891 bytes): before Create pack.
- `auditor/ac4-duplicate-name-alert.png` (1,554,108 bytes): the real page with the 409 alert.

Open each one before attaching it.

**Not attached:** every `.log`, `.txt` and `.json` receipt. They stay on the desktop under `~/.hermes/plans/leorna/evidence/86bcm901w/`.

## How to post (only after Justin says "post")

1. **Get every upload ticket first, then upload.** Call `clickup_request_attachment_upload(task_id="86bcm901w", file_name=<upload name>)` once per file. Tickets expire in about 3 minutes, so request them together, then `curl -sS -X POST <upload_url> -H 'X-Upload-Ticket: <ticket>' -F 'attachment=@<path>;filename=<upload name>;type=image/png'`.
   - If any ticket is denied (auto mode can deny one inside a subagent), stop before the first `curl` so the card never gets a partial set. Post from the main session instead.
2. **Comment** with `clickup_create_comment(entity_type=task, entity_id="86bcm901w", comment_text=<the comment above, filled in>)`.
3. **Read back:**
   - `clickup_get_task(include=["attachments"])`: compare each title and `size` with the bytes above.
   - The comments tool: confirm the comment is there.
4. **Never change the card's status or checkboxes.** Justin moves it.
