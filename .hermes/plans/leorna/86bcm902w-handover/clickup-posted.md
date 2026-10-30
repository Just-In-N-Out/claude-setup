# 86bcm902w — ClickUp evidence as posted (post finisher, 2026-10-29 local / 2026-10-30 UTC)

Card: [Content usage analytics (which items get used)](https://app.clickup.com/t/86bcm902w). Posted on Justin's "post on ClickUp" (2026-10-29). Only the comment and its 6 image attachments were added. Status ("in progress"), checkboxes, description, tags, assignees and every field were left unchanged. Nothing was merged, pushed, committed or edited on GitHub.

- Control plane PR #103: OPEN, not merged, head `b4acb2f82016990587371a46279c88f416152c42`, MERGEABLE, +2734/-23, 21 files. CI run 40976971544 on that head: Go quality gates pass (10m31s), Publish control-plane image pass, Package admin-portal distribution pass. https://github.com/LeornaAI/leorna-control-plane/pull/103 (read with `gh pr view`/`gh pr checks` at 2026-10-30 01:05:18–01:05:30 UTC).
- Client PR #23: OPEN, not merged, head `cf3df7f8cb2af1a6d0a2ef42a6e08b1387ca7f20`, MERGEABLE, +3437/-150, 17 files. CI run 40973788926 on that head: Go quality gates pass, Windows client executable pass, Clean Windows tool installation pass. https://github.com/LeornaAI/leorna-client/pull/23 (same read).
- Both live PR bodies equal the local copies in `~/.hermes/cache/scratch/leorna-pr-86bcm902w-content-usage-analytics-{control-plane,client}.md` (`diff` empty).
- Acceptance behind the comment: `ac-check.sh --reviews` → `ALL ACCEPTED: 5 of 5 ACs on b4acb2f`, `REVIEWS CLEAN: review-4 at b4acb2f is clean`; client referee `MOVE ON: review-3 at cf3df7f is clean`.
- Before posting (read 2026-10-30 ~01:06 UTC): status "in progress", 0 attachments, 0 comments, `date_updated` 1793318628183 (00:03:48 UTC). No earlier closing comment existed.
- Uploads: 6 tickets requested in one batch (all granted, none denied; expiry 01:13:39–01:13:40 UTC), then 6 `curl` multipart POSTs to `https://mcp.clickup.com/upload` (field `attachment`, header `X-Upload-Ticket`), all HTTP 200, 01:11:11–01:11:26 UTC. Tickets were not stored.
- Comment: id `90140275460826`, posted 2026-10-30 01:11:57 UTC (ClickUp date 1793322717866), 9680 characters (9725 bytes) as posted, with `clickup_create_comment(entity_type=task, entity_id=86bcm902w)`.
- Read back: `clickup_get_task include=[attachments]` lists exactly these 6 attachments, each title once, each size equal to the local bytes. `clickup_get_task_comments` returns count 1 (this comment, reply_count 0). Its plain-text `comment_text` (9561 characters) equals the posted text exactly once the 42 markdown list markers are removed (20 `- ` bullets and the 22 `1.`–`22.` follow-up numbers): word diff empty (1459 words each). After posting, status is still "in progress"; only `date_updated` moved (1793322717866, the comment's time).
- Afterwards: ClickHouse test container `leorna-test-ch-86bcm902w` (with its own anonymous volume `25b69beb…`) removed with `docker rm -f -v` at 2026-10-30 01:13 UTC, exit 0; the pinned image `clickhouse-server@sha256:0152dd51…` stays; the older orphan volume `451637eaa73d…` and the builder DB `leorna_86bcm902w_builder_test` were left alone.

## Attachments

| AC | Local file | Bytes | ClickUp title | ClickUp attachment id | Read-back size |
| --- | --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor-pr/ac1-spike-table.png` | 183886 | `86bcm902w-ac1-spike-support-table-b4acb2f.png` | `ccda37ef-1e0c-4c8f-ab2a-fce756b67211.png` | 183886 (equal) |
| AC2 (before) | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor-pr/ac2-empty-before.png` | 113576 | `86bcm902w-ac2-before-uploads-b4acb2f.png` | `db164ee7-0b91-446f-87e4-fb99e9298a37.png` | 113576 (equal) |
| AC2 (after) | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor-pr/ac2-counts-after.png` | 522051 | `86bcm902w-ac2-counts-per-pack-and-item-b4acb2f.png` | `b0bfca44-5ffd-4ef7-a257-c2eb8ca7d2f7.png` | 522051 (equal) |
| AC3 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/verifier-pr/ac3-not-measurable-b4acb2f.png` | 517028 | `86bcm902w-ac3-not-measurable-b4acb2f.png` | `6d214904-b77a-4b55-aab3-50735a962979.png` | 517028 (equal) |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor-pr/ac4-guards-terminal.png` | 131146 | `86bcm902w-ac4-admin-only-and-isolated-log-b4acb2f.png` | `83fc72a7-3c9d-40a3-a9b6-e3f0882dffdf.png` | 131146 (equal) |
| AC5 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor-pr/ac5-ingest-terminal.png` | 50641 | `86bcm902w-ac5-identifiers-only-log-b4acb2f.png` | `da15f7ae-8f20-48be-b7e6-b5ed87964411.png` | 50641 (equal) |

Each image was opened and inspected before upload (tall ones in bands of 1,250 px). None shows a URL bar, server domain, tenant ID, token, device code or email. The picks and the rejected candidates are in `clickup-evidence.md`. No attachment needs deleting.

## Comment text as posted

````
✅ Closing evidence — Content usage analytics (which items get used) (86bcm902w)

WHAT WAS DONE
leorna-control-plane PR #103: https://github.com/LeornaAI/leorna-control-plane/pull/103
State: open, not merged (Justin merges; this one first). Head b4acb2f. +2734/-23, 21 files.
- A spike write-up (internal/metric/content-usage-spike.md) with a machine-checked table of what each tool's local transcripts record, per tool and per kind.
- The usage upload now also accepts item uses: identifiers only (id, tool, kind, item name, time, optional project), validated before anything is written, and only for a tool and kind the table can measure. They go to a new additive ClickHouse table, item_uses_v1, so existing usage, cost and adoption figures don't change. No Postgres migration.
- A new admin-only Content usage page in the admin console: where usage can be measured, counts per pack and per item, and "Not measurable" (never 0) where a tool can't record a use.

leorna-client PR #23: https://github.com/LeornaAI/leorna-client/pull/23
State: open, not merged (merge after #103). Head cf3df7f. +3437/-150, 17 files.
- A new import-content-usage command: it reads transcripts an engineer picks, counts uses of the skills and prompts the last Sync installed (Claude Code and Codex), and uploads only identifiers, never transcript text, arguments, paths or personal skill names. It reads the desktop database read-only. Nothing uploads automatically.

Spike result (per tool, verified 2026-10-29)
- Claude Code 2.1.312: skills yes (Skill tool calls and typed /name commands), prompts yes (typed /name commands), agents not measurable (Leorna installs no agents yet).
- Codex 0.165.0: skills yes, inferred (counted once per session when Codex reads the skill's SKILL.md); prompts no (Codex removed custom prompts in 0.117.0); agents not measurable.
- Cursor 3.20.17 / 3.23.23: skills, prompts and agents not measurable (the chat fields Leorna can read name none of them).

Decisions along the way
- Reviews found two real bugs in the control plane, each fixed with Justin's call: (1) a newly shipped seed release hid the company's own edited pack, fixed with "Company's own pack wins"; (2) after the role-based starter packs (PR #102) merged into main, a renamed starter pack showed as a stale second row, fixed with "Hide replaced packs".
- Justin kept the rule that every current shared starter pack shows as a row, assigned to a team or not.
- One client CI failure (Windows client executable job): two tests compared folder paths in a form that isn't portable to Windows' short temp paths. Test-only fix; the product was right.

WHAT WAS VERIFIED (all on control plane b4acb2f and client cf3df7f)

AC1: Given a spike, then we document per tool whether item usage can be detected from transcripts
Test: TestContentUsageAC1SpikeMatchesSupportTable (the write-up's table must equal the page's table, row for row and basis for basis)
Screenshot: 86bcm902w-ac1-spike-support-table-b4acb2f.png (local rendering of the write-up's title and its 9-row tool × kind table)
Result: ✅ pass

AC2: Given supported tools, then item usage counts are shown per pack and item
Test: TestContentUsageAC2CountsPerPackAndItemWithPostgres (real Postgres and ClickHouse, the client's real upload body, a replayed upload counts once)
Screenshots: 86bcm902w-ac2-before-uploads-b4acb2f.png (the real page on a fresh install: 0 uses, the seed pack and the four role starter packs) → 86bcm902w-ac2-counts-per-pack-and-item-b4acb2f.png (after real uploads, the client's body sent twice and counted once: 15 uses, 8 of 36 items; By pack, e.g. Backend starter pack 4 items used, 9 uses; By item, per tool, e.g. code-review-and-quality Claude Code 3, Codex 1, total 4)
Result: ✅ pass

AC3: Given unsupported tools, then the UI states that usage is not measurable there
Test: TestContentUsageAC3NotMeasurableIsStated
Screenshot: 86bcm902w-ac3-not-measurable-b4acb2f.png (a second demo, run after a quick start: "Where usage can be measured" gives the reason for each tool and kind; every Cursor cell, the Codex prompt cells and every agent cell say "Not measurable", never 0; By pack shows the company's own quick-start Backend starter pack winning its row)
Result: ✅ pass

AC4 (proposed, approved with the plan): Only the company's admins can open the page; another company sees none of its uses; uploads count for the signed-in user and company
Test: TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres (6 subtests: a member gets 403, a signed-out visitor goes to sign-in, the body can't name a company or user, uploads count for the signed-in user and company, another company's admin sees none, the store refuses members and a mismatched company)
Screenshot: 86bcm902w-ac4-admin-only-and-isolated-log-b4acb2f.png (rendering of the test log: 6 subtests pass, EXIT=0; this AC has nothing visual)
Result: ✅ pass

AC5 (proposed, approved with the plan): An item use carries only identifiers; anything else is refused and nothing is stored
Test: TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres (14 refused batches each answer 400 and store nothing; the valid one stores exactly its row)
Screenshot: 86bcm902w-ac5-identifiers-only-log-b4acb2f.png (rendering of the test log: pass, EXIT=0)
Result: ✅ pass

Gates and checks
- Control plane b4acb2f: make check ✅ (race tests, lint 0 issues, govulncheck no called vulnerability, gitleaks no leaks, library gate passed) · test-module-add ✅ · DB tests 709 pass, 0 fail, 341 of 341 tests ran, only the 2 known environment skips ✅ · gitleaks on the branch ✅ · story gate unit tests ✅
- Client cf3df7f: make check ✅ · UI tests 39/39 ✅ · lint 0 issues and audit no vulnerabilities ✅ · real Claude Code 2.1.312 check ✅ · upload body and OpenAPI file identical in both repos ✅
- Each AC test fails on main before this change (8aa32a1, where the feature doesn't exist) and passes on b4acb2f.
- Reviews: 4 fresh reviews of the control plane, the last (review 4, on b4acb2f) clean; 3 of the client, the last (review 3, on cf3df7f) clean. An independent verifier and a blind auditor each accepted 5 of 5 ACs on these heads.
- Mutation checks: the auditor's 26 mutants, 24 killed every time by the AC tests; one (counting a replayed upload twice) is killed by AC2 in 2 of 4 runs and every time by the store test (follow-up 9); one is an expected survivor (the store still caps). The verifier's 16 targeted mutants were all killed.
- CI on the control-plane PR head b4acb2f: run 40976971544, all 3 checks pass (Go quality gates, Publish control-plane image, Package admin-portal distribution): https://github.com/LeornaAI/leorna-control-plane/actions/runs/40976971544
- CI on the client PR head cf3df7f: run 40973788926, all 3 checks pass (Go quality gates, Windows client executable, Clean Windows tool installation): https://github.com/LeornaAI/leorna-client/actions/runs/40973788926
- No gate screenshot exists on these heads; the gate results above come from the verifier's logs, kept locally as receipts.
- The page screenshots come from real control-plane binaries built at b4acb2f, run locally in dev mode on throwaway databases, after real uploads of the client's upload body.
- Live run: none needed, no AC is live.

Follow-ups (on the PRs; none blocks this card)
Control plane
1. Test an upload whose item uses carry a project (dropping or refusing the project survives today's tests).
2. A batch without "events" is accepted when it has item uses, though the contract marks events required.
3. Test strength: the page's date-filter rule and the equal-time pack tie-break each survive a mutant.
4. A lighter pack query if the page slows (it loads each pack's latest version in full).
5. CSV export and team/project filters for content usage.
6. A test that pins the admin nav's "Content usage" link.
7. The page picks a starter line's newest release by creation time, the Content library catalog by release number; they differ only if two releases start up at the same instant.
8. One code comment in the pack version history is out of date (docs only).
9. Make AC2's replay check independent of ClickHouse's background merges (the store test already pins it).
10. Whether pack rows should follow team assignments now that shared starter packs are many (Justin kept today's rule).
Client
11. Codex: count only skills under the user's own .agents/skills (a repository's own skill with a synced item's name counts today).
12. Test the -server path rule.
13. Scope Sync baselines per company: after switching company, the earlier company's Codex Sync still marks its skills as managed until a Codex Sync for the new company runs.
14. A real-binary check of a model-driven Skill call in Claude Code.
15. Test strength: two detector guards (Claude Code lines without an id, Codex uses without a session id) and the folder match through symlinks on Linux.
16. Windows folder aliases beyond short names, case and slashes (junctions, network-style paths) count 0 today (under-count only).
17. Claude Code run inside WSL with the WSL project chosen in the Windows app counts 0: document native-only, or map WSL paths (Justin's call).
18. "Upload usage automatically after Sync" should reuse these detectors.
Both repos
19. A CI check that the client's OpenAPI copy equals the control plane's.
20. Cursor: check on a real store whether tool-call fields name a skill or command.
21. Agents: count them once Leorna installs agents.
22. Re-verify the detectors when Claude Code or Codex change their transcript format.

NOT VERIFIED
Nothing left for the acceptance criteria. Both PRs are open: CI on the merge and the post-merge story check run after Justin merges.
````
