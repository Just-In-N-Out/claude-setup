## Summary

Adds content usage analytics: admins can now see which delivered skills, prompts and agents engineers actually use. A spike first checked, per tool and per kind, what each tool's local transcripts record. The result is a write-up with a machine-checked support table: Claude Code records skill calls and typed `/name` commands; Codex shows a skill only when it reads the skill's `SKILL.md` (inferred, counted once per session); Cursor records neither; and no tool's agent use can be tied to a Leorna item, because Leorna installs no agents yet. The usage upload (`POST /v1/usage` and `POST /v1/client/usage`) now also accepts item uses: identifiers only (id, tool, kind, item name, time, optional project), validated before anything is written, and only for a tool and kind the table can measure. They go to a new additive ClickHouse table, `item_uses_v1`, separate from the usage events, so existing usage, cost, adoption and monthly figures don't change. A new admin-only page, `/admin/content-usage`, shows where usage can be measured, counts per pack and per item, and "Not measurable" (never 0) where a tool can't record a use. The desktop client's import command that sends these uses is in the matching client PR (same branch name). No Postgres migration, no new route on the API, no CI change.

ClickUp: [Content usage analytics (which items get used)](https://app.clickup.com/t/90141510532/86bcm902w)

## Changes

- `internal/metric/content-usage-spike.md`: the spike write-up: method, per-tool evidence, the support table between `item-use-support` markers (tool × kind, measured yes/no, basis, verified on: Claude Code 2.1.312, Codex 0.165.0, Cursor 3.20.17/3.23.23), version notes, matching rules, privacy and follow-ups.
- `internal/metric/content_usage.go`: the support table (`ItemUseSupport`, `Measured`), `ItemUse`, `ValidItemUse` (slug name of at most 64 characters, a known tool and kind, a measurable pair), the reader/writer interfaces, and `BuildContentUsageReport` (pure: per-pack and per-item rows; unmeasured cells stay "not measurable"; an item in several packs counts in each).
- `contracts/control-plane.openapi.yaml`, `packages/contracts/controlplane.gen.go`: `UsageBatch` gains optional `itemUses` (at most 1,000); new `ItemUse` and `ItemUseKind`. `events` stays required but may be empty, so an item-only batch sends `"events": []`; a batch with neither is still 400.
- `internal/web/usage_ingest.go`: decodes strictly (unknown fields 400), checks both lists' bounds, validates every item use, resolves an item use's project through the existing attribution, then writes events and item uses. Tenant and user come from the session, never the body. The "store can write" check now runs after decoding and only for the parts the batch has.
- `internal/metric/clickhouse/store.go`, `internal/metric/clickhouse/item_uses.go`: `CREATE TABLE IF NOT EXISTS item_uses_v1` (ReplacingMergeTree keyed by tenant, user and use ID, so a re-import counts once); `WriteItemUses`; admin-only `QueryItemUsage` reading `FINAL` rows of the actor's tenant, bounded at 10,000 rows (more → 400 "too many rows").
- `internal/web/content_usage.go`, `internal/web/handler.go`: `GET /admin/content-usage` behind the session and admin guards, a "Content usage" link in the admin nav, a UTC date filter, "Where usage can be measured", "By pack" and "By item". Pack rows: per pack name the company's own newest version; the shared seed's newest version only when the company has none of that name; another company's version never counts. A failing store answers 503 without its error text.
- Tests:
  - `internal/metric/content_usage_spike_test.go`: AC1 (the write-up's table equals the code's table, row for row and basis for basis).
  - `internal/metric/content_usage_test.go`: validation, the period filter and the report.
  - `internal/metric/clickhouse/item_uses_test.go`: the query tests on real ClickHouse (replay counts once, period bounds, tenant isolation), the additive migration, FINAL tenant-bound reads, fail-closed store.
  - `internal/web/content_usage_test.go`: AC2, AC4, AC5 on real Postgres and ClickHouse, and the "company's own pack wins" rule with the real seed base.
  - `internal/web/content_usage_component_test.go`: AC3, newest version per pack, and the company-version rule at the handler.
  - `internal/web/testdata/content_usage_client_upload.json`: the client's golden upload body, byte-identical to the client's own copy; AC2 posts it.
- Docs: `internal/metric/README.md` section "Content usage (story 86bcm902w)"; one sentence in the root `README.md` naming `/admin/content-usage`.
- `delivery/stories.json`: the 86bcm902w entry, appended last, listing this PR and the client PR.

## Test Plan

Everything below ran on 2026-10-29 on head `b78905b`: this branch's `de5fbe0` with GitHub `main` brought in at `8aa32a1` (after #101 "One-click quick start" and #102 "Role-based starter packs"), with the client at `db3e6b0`. Tools: Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0 (CI's pins), gitleaks 8.30.1; real Postgres in a test container and real ClickHouse from CI's pinned image (`clickhouse-server:25.8@sha256:0152dd51…`).

- [x] Bringing in `main`: only `delivery/stories.json` conflicted (resolved as main's file plus this entry last, every earlier entry unchanged by value); `README.md` and `internal/web/handler.go` equal git's clean 3-way merge. Every file changed on one side only equals that side's version (44 of 44); the files that differ from both parents are exactly the 3 both sides changed; this branch's own changes survive line for line (18 of 18 files); no migration version repeats (`000024`–`000026` are main's; this PR adds none); gitleaks over the 3 both-sides files: no leaks.
- [x] `make check` with the linter and govulncheck bound to CI's versions: exit 0 (race tests, lint 0 issues in both modules, govulncheck no called vulnerability, gitleaks no leaks, library gate PASSED, build).
- [x] `bash ./scripts/test-module-add.sh`: exit 0.
- [x] gitleaks over `b65f797..b78905b` (58 commits, main's included): no leaks.
- [x] `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`: 5 tests OK.
- [x] DB tests read per test from a `go test -json` stream over `internal/cloud/dbcheck`, `internal/store/postgres`, `internal/web` and `internal/metric/...`: @@JSON@@
- [x] AC tests by name, each with no skip:
  - [x] AC1 `TestContentUsageAC1SpikeMatchesSupportTable`: pass
  - [x] AC2 `TestContentUsageAC2CountsPerPackAndItemWithPostgres`: pass
  - [x] AC3 `TestContentUsageAC3NotMeasurableIsStated`: pass
  - [x] AC4 `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres` (6 subtests): pass
  - [x] AC5 `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres`: pass
- [x] Cross-repo ties: `cmp` of the client's golden upload body (`db3e6b0`) with `internal/web/testdata/content_usage_client_upload.json`, and of the client's `api/control-plane.openapi.yaml` with `contracts/control-plane.openapi.yaml`, both from `b78905b`: @@CMP@@
- [x] Scope: no `.github/` path and no `CLAUDE.md` in the diff against `main`; all 13 of the branch's own commits (12 plus the merge) by the Leorna identity with no AI attribution lines.
- [ ] Hosted CI: @@CI@@

## Security, migration, rollback

- **Security:**
  - The page is admin-only twice over: the route's `requireAdmin` (a member gets 403 `ADMIN_REQUIRED`, a signed-out visitor goes to sign-in) and the store's own admin check on every read (AC4).
  - Every read is bound to the actor's tenant and reads `FINAL` rows; another company's admin sees none of this company's uses (AC4). ClickHouse queries use bound parameters.
  - The upload stores the session's tenant and user; the body can't name either (unknown fields are 400, AC4/AC5). An item use carries only identifiers: no transcript text, command arguments, file paths or folder names, and the contract has `additionalProperties: false` (AC5).
  - Names must be item-name slugs (at most 64 characters); a tool and kind the support table can't measure, an empty batch or more than 1,000 item uses is 400, and nothing is written when any part is invalid (AC5).
  - The page is `html/template`; a store failure answers 503 without its error text. No auth bypass, no dev-login change, no new scope.
- **Migration:** ClickHouse only. `CREATE TABLE IF NOT EXISTS item_uses_v1` joins the existing startup `Migrate` list; it is additive and touches no existing table (`TestItemUsesMigrateIsAdditiveWithClickHouse`). No Postgres migration.
- **Compatibility:** `events` may now be empty when `itemUses` is present. Existing callers always send events and are unaffected. An older server refuses `itemUses` with 400.
- **Rollback:** revert the PR. The older binary never reads or writes `item_uses_v1` and doesn't create it; an existing table stays and is harmless (read from the code, not run). To remove the data as well, drop `item_uses_v1` in ClickHouse by hand (not run). After a revert, the client's `import-content-usage` fails with "usage upload rejected" and stores nothing.

## Assumptions

- Merge order: this PR first, then the client PR. With only this PR merged, the page works (empty until uploads) and the upload accepts item uses that nothing sends yet. With only the client merged, its import fails with "usage upload rejected" and stores nothing.
- Uses reach the server through an explicit import command run on the engineer's machine (approved option). Automatic upload after Sync is the separate "Upload usage automatically after Sync" card, which should reuse the client's detectors.
- Only uses of items the last Sync installed leave the machine, so personal skill and command names are never sent (approved option).
- An item that sits in several packs counts in each pack (approved option); pack totals can overlap, and the page says so.
- Pack rows: the company's own newest version of each pack name wins; the shared seed shows only when the company has no version of that name (Justin's decision after review 1). Between two versions of one owner, the newer one wins, and on an equal creation time the larger version string.
- An item is (kind, name): versions of an item count together.
- Codex skill use is inferred from the first read of `.agents/skills/<name>/SKILL.md` per session; Claude Code counts each `Skill` call and each typed `/name` line in sessions run in the synced project folder (a session started in a subfolder doesn't count). The page labels Codex "Inferred".
- Agents are "Not measurable" everywhere until a transformer installs agents.
- The local ClickHouse tests ran against a disposable container from CI's pinned image (approved option); its credentials are CI's public test values.
- AC4 (admin only and tenant isolated) and AC5 (identifiers only) were proposed in the plan and approved with it.
- The "store can write" check now runs after decoding, so an invalid batch on a server without ClickHouse answers 400 instead of 503.
- No CI change. CI doesn't compare the client's OpenAPI snapshot with this repo's (follow-up 5).

## Follow-ups (not in this PR)

1. Test a runtime upload that carries a `projectId`: dropping project attribution, or refusing any `projectId`, survives today's tests while the client import sends one by default (review 1 R1-2, auditor). The auditor's probe is a ready model.
2. The contract marks `events` required, but a batch without `events` (or `"events": null`) is accepted when it has item uses (review 1 R1-3).
3. Test strength: the page filter's "only from and to, each once" rule (review 2 R2-1), and the equal-time pack tie-break (verifier), each survive a mutant today.
4. Cursor: check on a real store whether tool-call parameters name a skill file or command; flip those rows only with a test. Agents: count them once a transformer installs agents.
5. A CI check that the client's OpenAPI snapshot equals this repo's.
6. CSV export and team/project filters for content usage; a lighter pack metadata query if the page slows (it loads each pack's latest version).

## Evidence

- Head: @@HEAD@@ (base `main` at `8aa32a1`; the branch started from `b65f797`). The local gates above ran on `b78905b`, the merge of `main`; @@RECORD@@
- Before `main` was brought in, the pipeline's independent verifier and a blind AC auditor each accepted all 5 ACs on `de5fbe0`, with mutation checks and a run of the real binary there. A fresh verifier and auditor run on this PR's head next.
- Required check "Go quality gates": @@GQG@@
- Actions run: @@RUN@@
- Local receipts (one log per gate plus a summary, AC logs, the merge proof) are kept with the story's evidence.
