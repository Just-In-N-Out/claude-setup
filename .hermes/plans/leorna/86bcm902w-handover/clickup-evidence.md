# 86bcm902w ClickUp evidence draft (post only when Justin says "post")

Card: [Content usage analytics (which items get used)](https://app.clickup.com/t/90141510532/86bcm902w) (status "to do", no attachments yet; read 2026-10-29). Never change its status or checkboxes.

At "post": fill in the `<…>` merge facts from fresh `gh` reads (PR numbers, merge SHAs, CI run URL), upload the files below (images only), add the comment, and read both back.

## Comment

```
✅ Closing evidence — Content usage analytics (which items get used) (86bcm902w)

WHAT WAS DONE
- leorna-control-plane PR #<n> (merged <date>, merge <sha7>, +2445/-18, 18 files): a spike write-up with a machine-checked table of which tools record item use; the usage upload now also accepts item uses (identifiers only, validated before any write) into a new additive ClickHouse table item_uses_v1; a new admin-only page /admin/content-usage shows where usage can be measured, counts per pack and per item, and "Not measurable" (never 0) where a tool can't record it.
- leorna-client PR #<n> (merged <date>, merge <sha7>, +3383/-150, 17 files): an explicit import-content-usage command that reads transcripts an engineer picks, counts uses of the skills and prompts the last Sync installed (Claude Code and Codex), and uploads only identifiers; reads the desktop database read-only.

SPIKE RESULT (per tool, verified 2026-10-29)
- Claude Code 2.1.312: skills yes (Skill tool calls and typed /name commands), prompts yes (typed /name commands), agents not measurable (sub-agents are named, but Leorna installs no agents yet).
- Codex 0.165.0: skills yes, inferred (counted once per session when Codex reads the skill's SKILL.md), prompts no (Codex removed custom prompts in 0.117.0), agents not measurable.
- Cursor 3.20.17 / 3.23.23: not measurable for skills, prompts or agents (the chat fields Leorna can read name neither).
Full write-up: internal/metric/content-usage-spike.md in the control plane.

WHAT WAS VERIFIED
| Acceptance criterion | Test / evidence | Result |
| --- | --- | --- |
| AC1: Given a spike, then we document per tool whether item usage can be detected from transcripts | TestContentUsageAC1SpikeMatchesSupportTable (the write-up's table must equal the page's table row for row) + ac1-spike-table-de5fbe0.png | ✅ |
| AC2: Given supported tools, then item usage counts are shown per pack and item | TestContentUsageAC2CountsPerPackAndItemWithPostgres (real Postgres + ClickHouse, the client's real upload body, a replay counts once) + ac2-before-uploads-de5fbe0.png, ac2-by-pack-de5fbe0.png, ac2-by-item-de5fbe0.png | ✅ |
| AC3: Given unsupported tools, then the UI states that usage is not measurable there | TestContentUsageAC3NotMeasurableIsStated + ac3-not-measurable-de5fbe0.png | ✅ |
| AC4 (approved with the plan): only the company's admins can open the page; another company sees none of its uses; uploads count for the signed-in user and company | TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres (6 subtests) + ac4-guards-de5fbe0.png | ✅ |
| AC5 (approved with the plan): an item use carries only identifiers; anything else is refused and nothing is stored | TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres + ac5-ingest-de5fbe0.png | ✅ |
- Each AC test passed on control plane de5fbe0 (client db3e6b0) for an independent verifier and again for a blind auditor, and fails on the base. Acceptance check: ALL ACCEPTED, 5 of 5.
- Gates on control plane de5fbe0: make check ✅ (lint 0 issues · govulncheck no called vulnerability · gitleaks no leaks · library gate passed) · module-add ✅ · DB tests 607 passed, 0 failed, no unexpected skip ✅
- Gates on client db3e6b0: make check ✅ · UI tests 39/39 ✅ · lint 0 ✅ · audit ✅ · real Claude Code 2.1.312 check ✅ · golden upload body and OpenAPI identical in both repos ✅
- Mutation checks: the auditor's 26 clause mutants across AC1–AC5 were all caught.
- CI: not run yet, not pushed. → at post: Go quality gates ✅ · <client checks> ✅ — <Actions run URLs>
- Live run: none needed; no acceptance criterion is live. The page screenshots come from a real server binary built from de5fbe0 on this machine (dev mode, loopback, throwaway database) after real uploads.

NOT VERIFIED
- Nothing left for the acceptance criteria.
```

## Files to attach (images only; never `.log` or `.txt`)

Every file below was opened and read in full (none is taller than 1,822 px, so no band split was needed). None shows a server domain, URL bar, tenant ID, token, device code or email. All are from the accepted heads (control plane `de5fbe0`, client `db3e6b0`), none from the builder's `e184d9b`.

| AC | Local file (absolute path) | Bytes | Upload as | What it shows |
| --- | --- | --- | --- | --- |
| AC1 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/verifier/ac1-spike-table.png` | 216441 | `ac1-spike-table-de5fbe0.png` | Labelled local rendering (goldmark + headless Chrome) of the spike write-up at de5fbe0: the 9-row tool × kind table (measured yes/no, basis, verified on). |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor/ac2-empty-before.png` | 230219 | `ac2-before-uploads-de5fbe0.png` | The real Content usage page before any upload: Item uses 0, Items used 0 of 8, "No item uses were recorded in this period.", both packs and every item listed with 0 or "Not measurable". |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor/ac2-by-pack.png` | 18352 | `ac2-by-pack-de5fbe0.png` | "By pack" after the uploads: Leorna starter pack 1.2.0, 6 items, 3 used, 4 uses; Platform pack, 4 items, 3 used, 7 uses (an item in both packs counts in each). |
| AC2 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor/ac2-by-item.png` | 92138 | `ac2-by-item-de5fbe0.png` | "By item" after the uploads: per item its packs, Claude Code and Codex counts, total, people and last used (for example code-review-and-quality: Claude Code 3, Codex 1, total 4); a replayed batch counted once. |
| AC3 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor/ac3-not-measurable.png` | 176850 | `ac3-not-measurable-de5fbe0.png` | "Where usage can be measured" (Measured or Not measurable with the reason for each tool and kind) and the tables where every Cursor cell, the Codex prompt cells and every agent cell read "Not measurable", never 0. |
| AC4 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor/ac4-guards-terminal.png` | 126860 | `ac4-guards-de5fbe0.png` | Rendering of the auditor's AC4 run log at de5fbe0: the command, all 6 subtests PASS (member 403, signed-out to sign-in, body can't name a tenant or user, uploads count for the signed-in user and tenant, other tenant sees none, store refuses members and a mismatched tenant), `EXIT=0`. |
| AC5 | `/home/justin/.hermes/plans/leorna/evidence/86bcm902w/auditor/ac5-ingest-terminal.png` | 51803 | `ac5-ingest-de5fbe0.png` | Rendering of the auditor's AC5 run log at de5fbe0: the command, PASS, `EXIT=0`. |

Total: 7 files, 912,663 bytes. After upload, compare each returned title and `size` with this table.

Not attached, on purpose:
- The verifier's alternatives on the same head (`verifier/ac2-before-uploads.png`, `ac2-counts-per-pack-and-item.png`, `ac3-not-measurable.png`, `ac4-de5fbe0-terminal.png`, `ac5-de5fbe0-terminal.png`) are equally clean; the auditor's set is used because its demo has two packs (shows the overlap rule) and its AC4/AC5 renderings show the full command.
- The builder's `e184d9b` captures (an earlier head).
- No gate screenshot exists on these heads; the gate results are in the comment text and the logs stay local as receipts. If Justin wants a `gates-de5fbe0.png`, render the verifier's two `SUMMARY.txt` files at "post" time.
