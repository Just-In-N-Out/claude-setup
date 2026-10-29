# 86bcm902w — Content usage analytics (which items get used)

**Status:** approved by Justin 2026-10-29 (~19:40 UTC): **go** with every ⭐ answer. Written 2026-10-29 ~19:30 UTC by the Opus planner.
**Bases:** control plane `b65f797ff6cdc56a802dfaf417b0adec96463317` (GitHub `main`, includes #99 901y and #100 9023); client `f105e27814b6efbec67059687963e722933acec2` (GitHub `main`). Both local `main` checkouts already equalled GitHub (`main` = `origin/main` = base); no fast-forward was needed. Rechecked 19:23 UTC.
**Card:** [Content usage analytics (which items get used)](https://app.clickup.com/t/86bcm902w) · both repos · M · PI-2 · depends on 86bcm902h (complete, control-plane #83 + client #18).

## Justin's answers (2026-10-29)

"Yeah, just go with the recommended star options." → **go** with Q1 a (explicit import command), Q2 a (only items the last Sync installed leave the machine), Q3 a (every pack holding an item shows its full count), Q4 a (disposable ClickHouse container from CI's pinned image). The plan below is written for exactly these answers; AC4 and AC5 (proposed) are approved with it.

### Justin's answer after review 1 (2026-10-29)

Review 1's R1-1 (P2): a newer shipped seed version of "Leorna starter pack" displaced the tenant's own edited starter pack on the page, because D7 keeps the newest-created version per pack name across tenant and seed versions. Justin picked **"Company's own pack wins"**: for each pack name, show the tenant's newest version; show the shared seed version only when the tenant has no version of that name. This amends D7's pack-row rule for the fixer; `plan-approved.md` (frozen at go) is unchanged and its ACs are unchanged.

## Questions (answer with letters; **go** alone takes every ⭐)

**Q1. How do item uses get from engineers' machines to the server in this story?** (Yan's [Upload usage automatically after Sync](https://app.clickup.com/t/86bcnuxce) is still To Do.)
- a) ⭐ An explicit import command, like today's Codex import
- b) The desktop uploads them automatically after each Sync
- c) A desktop button: pick a transcript, send its uses

Why ⭐: the client's consent rule today is "explicitly selected transcript, never scan private session folders" (`toolconnector/codex/README.md:3-6`, `toolconnector/cursor/README.md:3-4`), and automatic upload is Yan's card. (b) or (c) adds desktop Sync/UI wiring, a new consent rule, a Wails UI test and overlap with 86bcnuxce (both would edit the post-Sync path). Either way the detector code is the same, and Yan's card can call it later.

**Q2. Which detected uses may leave the engineer's machine?**
- a) ⭐ Only items the last Sync installed (the client checks)
- b) Every detected name; the server keeps only pack items

Why ⭐: with (a) the names of personal skills and commands never leave the machine, and a same-named personal skill in another folder is not miscounted. (b) drops the desktop-database read from the import command, but personal skill/command names are sent and the server must discard non-pack names.

**Q3. An item sits in several packs. Where does its count go "per pack"?**
- a) ⭐ Every pack holding it shows the item's full count
- b) Only the pack assigned to the project the use came from

Why ⭐: tools only see an item's name, so a use can't say which pack delivered it. (a) needs no project: the item table counts each use once, and pack totals can overlap (the page says so). (b) stores the project's assigned pack version at upload time, more store code; uses uploaded without a project never count toward any pack.

**Q4. ClickHouse isn't on this machine. How do the query tests run locally?**
- a) ⭐ Disposable ClickHouse container from CI's pinned image
- b) No local ClickHouse; those checks run only in CI

Why ⭐: AC2, AC4 and AC5 need real ClickHouse; with (b) no agent can accept them on this machine. (a) pulls `mirror.gcr.io/clickhouse/clickhouse-server:25.8@sha256:0152dd511befe6a2c2ef53e930726179669b08116da78500b37c51c96ff5ee77` (CI's exact image, `.github/workflows/ci.yml:35`) and runs it as `leorna-test-ch-86bcm902w` on `127.0.0.1:18123` until the finisher removes it at hand-over.

## Acceptance criteria

AC1–AC3 are the card's own (given). AC4–AC5 are **proposed** by the planner; **go** approves them. None is `(live)`: every check here runs on this machine without Justin. Every AC's one named test lives in the **control plane** (the `--repo` of `ac-check.sh`, which takes one repo; `feature-dispatch/references/ac-verification.md:29`). The client's tests are supporting receipts, tied in by a byte-identical golden upload body (AC2).

- AC1: Given a spike, then we document per tool whether item usage can be detected from transcripts. Test: `TestContentUsageAC1SpikeMatchesSupportTable`
- AC2: Given supported tools, then item usage counts are shown per pack and item. Test: `TestContentUsageAC2CountsPerPackAndItemWithPostgres`
- AC3: Given unsupported tools, then the UI states that usage is not measurable there. Test: `TestContentUsageAC3NotMeasurableIsStated`
- AC4 (proposed): Given the content usage page, then only the tenant's admins can open it (a member gets 403, a signed-out visitor goes to sign-in), another tenant's admin sees none of this tenant's item uses, and an upload is always counted for the signed-in user and tenant. Test: `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres`
- AC5 (proposed): Given an upload, then an item use carries only id, tool, kind, name, time and an optional project, and the server answers 400 and stores nothing for any other field, a name that is not an item name, an empty batch, more than 1,000 item uses, or a tool and kind the support table marks not measurable. Test: `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres`

### Per-AC detail

Common environment for every control-plane command below (from the story worktree; the password is read from the container, never typed):
```sh
export GOTOOLCHAIN=local PATH="$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:/usr/bin:/bin"
export TMPDIR="$HOME/.cache/86bcm902w-<role>/tmp"
PGPW=$(docker inspect leorna-test-pg --format '{{range .Config.Env}}{{println .}}{{end}}' | sed -n 's/^POSTGRES_PASSWORD=//p'); [ -n "$PGPW" ] || { echo "empty leorna-test-pg password"; exit 1; }
export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:$(docker port leorna-test-pg 5432 | sed 's/.*://')/leorna_86bcm902w_<role>_test?sslmode=disable"
export LEORNA_TEST_CLICKHOUSE_URL=http://127.0.0.1:18123
```
A log that shows `--- SKIP` for the AC's test is a failed check (the DB tests skip without these variables).

| AC | Repo · package | Command (only that test) | Why it fails on base `b65f797` | Evidence (folder `~/.hermes/plans/leorna/evidence/86bcm902w/`) |
| --- | --- | --- | --- | --- |
| AC1 | control plane · `./internal/metric/` | `go test -v -count=1 -run '^TestContentUsageAC1SpikeMatchesSupportTable$' ./internal/metric/` | No write-up and no `metric.ItemUseSupport`: the copied test fails to build (`undefined: metric.ItemUseSupport`). | `ac1-spike-table.png`: local rendering (goldmark + headless Chrome) of the write-up's support-table section, labelled "local rendering"; `ac1-<sha7>.log`. |
| AC2 | control plane · `./internal/web/` | `go test -v -count=1 -run '^TestContentUsageAC2CountsPerPackAndItemWithPostgres$' ./internal/web/` | No `itemUses` in the contract, no item-use store, no `/admin/content-usage`: the copied test fails to build (`contracts.ItemUse`, `metric.ItemUsageReader` undefined). | Real page captures from the demo (task T12): `ac2-empty-before.png` (page with packs and zero uses, before any upload), `ac2-per-pack-after.png` (`#by-pack`), `ac2-per-item-after.png` (`#by-item`); `ac2-<sha7>.log`; supporting `ac2-client-<client sha7>.log`, `ac2-import-terminal.png` (the real import command's run, rendered). ClickUp headline: the two `-after` images. |
| AC3 | control plane · `./internal/web/` | `go test -v -count=1 -run '^TestContentUsageAC3NotMeasurableIsStated$' ./internal/web/` | No page: build failure of the copied test (`metric.ItemUsageData` undefined). | `ac3-not-measurable.png`: the real page's `#measurability` section plus an item row with "Not measurable" cells (Cursor column, an agent row); `ac3-<sha7>.log`. |
| AC4 | control plane · `./internal/web/` | `go test -v -count=1 -run '^TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres$' ./internal/web/` | No route and no item-use store: build failure of the copied test. | `ac4-guards-terminal.png` (rendered log, every subtest PASS and `EXIT=0`); `ac4-<sha7>.log`. |
| AC5 | control plane · `./internal/web/` | `go test -v -count=1 -run '^TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres$' ./internal/web/` | Base rejects every `itemUses` body (unknown field) and has no `contracts.ItemUse`: build failure of the copied test. | `ac5-ingest-terminal.png` (rendered log); `ac5-<sha7>.log`; supporting `ac5-client-privacy-<client sha7>.log`. |

**What each AC test asserts** (exact data in task T7–T9):
- AC1: the write-up `internal/metric/content-usage-spike.md` holds one table between `<!-- item-use-support:start -->` and `<!-- item-use-support:end -->`; its rows are exactly the 9 pairs of tools {claude-code, codex, cursor} × kinds {skill, prompt, agent}; each row's yes/no equals `metric.Measured(tool, kind)`; its Basis cell equals the `Basis` text in `metric.ItemUseSupport()` byte for byte (the page shows that same text, so doc and UI can't drift); its "Verified on" cell is not empty; every tool is a valid `library.Tool` and the three `library.Tool…` constants all appear; every kind is a valid `pack.Kind`.
- AC2: real Postgres + ClickHouse; two packs, a newer version of one, the client's golden upload body posted twice (replay counts once), extra admin uses including one outside the period and one item in no pack; the page's per-pack and per-item rows show the exact numbers in T9; a September query shows only the September use.
- AC3: component test with fakes: the `#measurability` section shows "Measured" for (claude-code, skill), (claude-code, prompt), (codex, skill) and "Not measurable" with its reason for the other six pairs; an item row's Cursor cell, a prompt's Codex cell and every agent cell say "Not measurable" and never "0"; the empty state says "No item uses were recorded in this period."; a failing reader gives 503 without its error text; `metric.ErrTooManyRows` and a bad date give the 400 page with `role="alert"`.
- AC4: member 403; signed-out 302 to `/v1/auth/google/login`; tenant B's admin sees zero uses for the same item names after tenant A uploads; tenant A's member uploads and the stored rows carry A's tenant and that member's user ID (read straight from ClickHouse), whatever the body says; QueryItemUsage refuses a member principal and a mismatched tenant context with `org.ErrForbidden` (store level).
- AC5: reflection over the generated `contracts.ItemUse` JSON tags is exactly {id, tool, kind, name, timestamp, projectId}; POSTs with an extra field (`text`, `args`, `path`, `tenantId`), name `Not A Name`, name `../x`, an empty `{"events":[],"itemUses":[]}`, 1,001 item uses, (cursor, skill), (codex, prompt), (claude-code, agent) each answer 400; a valid one answers 204; afterwards ClickHouse holds exactly the valid row for that tenant.

### Supporting receipts (not ac-check rows; the verifier runs them)
- Control plane `./internal/metric/clickhouse/`: `TestItemUsageQueryCountsReplayPeriodAndTenantWithClickHouse` (the card's "query tests"), `TestItemUsesMigrateIsAdditiveWithClickHouse`; `./internal/metric/`: `TestBuildContentUsageReport*`, `TestValidItemUse`.
- Client `./usage/`: `TestContentUsageDetectsOnlySyncedItemUses`, `TestContentUsageGoldenUploadBody`, `TestItemUsesCarryNoTranscriptText`, env-gated `TestRealClaudeCodeTranscriptItemUses`; `./application/`: `TestManagedItemsFromLastSuccessfulSync`, `TestOpenReadOnlyNeverMigrates`; `./cmd/import-content-usage/`: `TestImportContentUsageSendsOnlyIdentifiers`.
- Cross-repo tie: `cmp leorna-client/usage/testdata/items/upload.golden.json leorna-control-plane/internal/web/testdata/content_usage_client_upload.json` exits 0, and `cmp leorna-client/api/control-plane.openapi.yaml leorna-control-plane/contracts/control-plane.openapi.yaml` exits 0 (both on the story heads).

## Playback and summary

**Playback:** Justin sent the To Do card 86bcm902w (the other To Do card, 86bcm901z, is a separate job): admins want to see which skills, agents and prompts engineers actually use; spike per tool first, then counts per pack and item, and "not measurable" where a tool can't tell.

**Summary:**
1. Spike: Claude Code transcripts name skill calls and typed `/commands`; Codex only shows a skill when the model reads its `SKILL.md` (inferred, once per session); Cursor's store names neither; no tool's agent use can be tied to a Leorna item because Leorna installs no agents yet.
2. Contract: `UsageBatch` gains an optional `itemUses` array (identifiers only), accepted on the existing `/v1/usage` and `/v1/client/usage`; no new route or scope.
3. Storage: a new additive ClickHouse table `item_uses_v1`; no Postgres migration.
4. Product: admin-only `/admin/content-usage` with "where usage can be measured", per-pack and per-item tables.
5. Client: detectors for Claude Code and Codex limited to what the last Sync installed, and an explicit `import-content-usage` command.

## Spike result (full write-up becomes `internal/metric/content-usage-spike.md`, task T1)

Method: structural reads only (event types, field names and counts; no content copied) of 46 local Claude Code transcripts (2.1.312) and 63 Codex rollouts (0.165.0) on the WSL desktop, 2026-10-29; the client's parsers and fixtures; the client READMEs' recorded Cursor checks (store fields on Cursor 3.20.17, 2026-10-03; command loader on 3.23.23, 2026-10-22). No Cursor store exists on this machine.

| Tool | Skill | Prompt (`/command`) | Agent |
| --- | --- | --- | --- |
| Claude Code | **Yes.** `type:"assistant"` line, `message.content[]` part `{type:"tool_use", name:"Skill", input:{skill, args?}}` (954 seen); a typed `/name` for a skill appears as below. Each call is one use. | **Yes.** `type:"user"` line, `message.content` a string that starts with `<command-name>` or `<command-message>` and holds `<command-name>/name</command-name>` (both tag orders seen). Arguments sit in `<command-args>` and are never read. Copies of these tags also appear in `api-request-blob` lines and assistant text: only genuine user lines count. | **Detectable, not attributable.** `tool_use` `name:"Agent"` (older versions `Task`) with `input.subagent_type` (200 seen), but every Leorna transformer skips agent items (`toolconnector/transform.go:23-35`), so no use is of a Leorna item → not measurable. |
| Codex | **Inferred.** No skill event exists. Codex lists skills in the developer message and the model reads the skill file: `response_item` `custom_tool_call` `name:"exec"` `input` text containing `.agents/skills/<name>/SKILL.md` (426 calls, every root `.agents/skills`, which is exactly Leorna's write root `$HOME/.agents/skills`, `toolconnector/codex/README.md:37-43`). Older rollouts use `function_call` (`arguments`) or `local_shell_call` (`action.command`): the detector reads all three. Counted once per session per skill. | **No.** Codex removed custom prompts in 0.117.0 and Leorna installs none for Codex (`toolconnector/codex/README.md:64-70`). | **Detectable, not attributable.** 0.165 records `function_call` `spawn_agent` with `agent_type` (56 seen); Leorna installs no Codex agents → not measurable. |
| Cursor | **No.** The store fields the client reads and verified on a real 3.20.17 store are `type`, `text`, `createdAt`, `tokenCount`, `toolFormerData.name` (`toolconnector/cursor/README.md:26-35,81-83`); none names a skill. | **No.** Same fields; nothing names the command. | **No.** Leorna installs no Cursor agents. |

Version dependence: Claude Code shapes verified on 2.1.312 only (the `Agent` tool was `Task` before; the `Skill` tool exists since skills shipped). Codex's rollout is a version-sensitive, undocumented format (`toolconnector/codex/README.md:25-30`); verified on 0.165.0. Cursor's store is undocumented. A tool update can break detection silently, so each detector is pinned by fixtures modelled on the verified shape, and the Claude Code one also by an env-gated real-binary test (T11).

Per-tool **and** per-kind support is needed (Claude Code: skill and prompt yes, agent no; Codex: skill only; Cursor: none), so the support table is keyed by (tool, kind).

## Design

### D1. Support table (control plane, `internal/metric/content_usage.go`)
```go
// ItemUseTools and ItemUseKinds are the tools and content kinds content usage reports on.
var ItemUseTools = []string{"claude-code", "codex", "cursor"}
var ItemUseKinds = []string{"skill", "prompt", "agent"}

// Measurability says whether uses of one kind can be counted from one tool's transcripts.
// Basis is shown on the content usage page and must equal the spike write-up's table cell.
type Measurability struct {
	Tool, Kind string
	Measured   bool
	Basis      string
}

var itemUseSupport = []Measurability{
	{"claude-code", "skill", true, "Each Skill tool call names the skill, and a typed /name command names it too."},
	{"claude-code", "prompt", true, "A typed /name command is recorded with its name."},
	{"claude-code", "agent", false, "Transcripts name sub-agents, but Leorna does not install agents yet."},
	{"codex", "skill", true, "Inferred: counted once per session when Codex reads the skill's SKILL.md."},
	{"codex", "prompt", false, "Codex removed custom prompts in 0.117.0, so Leorna installs none for Codex."},
	{"codex", "agent", false, "Codex names spawned agents, but Leorna does not install agents yet."},
	{"cursor", "skill", false, "The Cursor chat fields Leorna can read do not name the skill used."},
	{"cursor", "prompt", false, "The Cursor chat fields Leorna can read do not name the command used."},
	{"cursor", "agent", false, "Leorna does not install agents for Cursor."},
}

// ItemUseSupport returns a copy of the support table in display order.
func ItemUseSupport() []Measurability { return append([]Measurability(nil), itemUseSupport...) }

// Measured reports whether uses of kind can be counted from tool's transcripts.
func Measured(tool, kind string) bool {
	for _, row := range itemUseSupport {
		if row.Tool == tool && row.Kind == kind {
			return row.Measured
		}
	}
	return false
}
```
The client keeps its own detector list (D9) and its test pins it to exactly the three measured pairs; the spike write-up names both files, and the reviewers check them against each other (no Go crosses repos).

### D2. Contract (`contracts/control-plane.openapi.yaml`, then both repos regenerate)
Replace the `UsageBatch` schema and add two schemas after `UsageEvent`:
```yaml
    UsageBatch:
      type: object
      additionalProperties: false
      required: [events]
      description: >-
        At least one event or item use. Item uses carry identifiers only, never
        transcript text, command arguments or file paths.
      properties:
        events:
          type: array
          maxItems: 1000
          items:
            $ref: "#/components/schemas/UsageEvent"
        itemUses:
          type: array
          maxItems: 1000
          items:
            $ref: "#/components/schemas/ItemUse"
    ItemUseKind:
      type: string
      enum: [skill, agent, prompt]
    ItemUse:
      type: object
      additionalProperties: false
      required: [id, tool, kind, name, timestamp]
      description: One use of a delivered skill, agent or prompt, detected on the engineer's machine.
      properties:
        id:
          type: string
          minLength: 1
          maxLength: 128
          description: Stable source ID; re-imports and retries count once
        tool:
          type: string
          maxLength: 64
          pattern: '^[a-z0-9]+(-[a-z0-9]+)*$'
        kind:
          $ref: "#/components/schemas/ItemUseKind"
        name:
          type: string
          maxLength: 64
          pattern: '^[a-z0-9]+(-[a-z0-9]+)*$'
          description: The item name the tool saw, as installed by Sync
        timestamp:
          type: string
          format: date-time
        projectId:
          type: string
          format: uuid
          description: >-
            Leorna project the work was done in. The server derives the team from
            the project and records both as unknown when the caller cannot access it.
```
- `events` loses `minItems: 1` (an item-only batch sends `"events": []`); the server enforces "at least one of the two" (no request-validation middleware exists, `leorna-control-plane-workflow.md`).
- `kind` uses a **named** schema: both repos' contract-kind tests require exactly two inline `kind: {type: string, enum: [...]}` lines (`internal/web/contract_kinds_test.go:13`, client `application/contract_kinds_test.go`). Do not write the enum inline.
- Classification: additive for every existing consumer (the new array is optional; relaxing `minItems` keeps every old request valid). Breaking only for a new client talking to an old server (unknown field → 400), hence the merge order in D11.
- Control plane: `make generate` (runs `go generate` in `packages/contracts`), commit `packages/contracts/controlplane.gen.go`. No new operation, so `roundTripServer` and `var _ contracts.ServerInterface` need no new methods.
- Client: copy the **complete** control-plane file over `api/control-plane.openapi.yaml`, run `make generate`, commit `api/controlplane.gen.go`. The client's copy is currently 193 lines behind (901w/901y pack-builder endpoints never copied; see Other things found), so the regenerated client also gains those types; that is expected and adds no client behaviour.

### D3. Ingest (`internal/web/usage_ingest.go`, `recordUsageBatch`, shared by `POST /v1/usage` and `POST /v1/client/usage`)
Validate everything before writing anything:
```go
	var itemUses []contracts.ItemUse
	if batch.ItemUses != nil {
		itemUses = *batch.ItemUses
	}
	if len(batch.Events)+len(itemUses) == 0 || len(batch.Events) > 1000 || len(itemUses) > 1000 {
		handler.writeProblem(w, r, 400, "INVALID_REQUEST", "The usage batch is invalid")
		return
	}
	// … existing events loop builds events (unchanged) …
	uses := make([]metric.ItemUse, 0, len(itemUses))
	for _, value := range itemUses {
		use := metric.ItemUse{ID: value.Id, Tool: value.Tool, Kind: string(value.Kind), Name: value.Name, Timestamp: value.Timestamp}
		if !metric.ValidItemUse(use) { // pattern, bounds, known tool and kind, and Measured(tool, kind)
			handler.writeProblem(w, r, 400, "INVALID_REQUEST", "The usage batch is invalid")
			return
		}
		if value.ProjectId != nil {
			project, err := attribution.resolve(value.ProjectId.String())
			if err != nil {
				handler.writeProblem(w, r, 503, "USAGE_UNAVAILABLE", "Usage storage is unavailable", err)
				return
			}
			use.ProjectID, use.TeamID = project.ID, project.TeamID
		}
		uses = append(uses, use)
	}
	// then: events → metric.Writer.WriteUsage (only when len(events) > 0);
	//       uses   → metric.ItemUseWriter.WriteItemUses (only when len(uses) > 0);
	// a missing writer for a non-empty part → 503 USAGE_UNAVAILABLE; errors map as today.
```
- Move today's early `handler.metrics.(metric.Writer)` check so it applies only when the batch has events; check `metric.ItemUseWriter` only when it has item uses.
- Two ClickHouse inserts are not one transaction: if the second fails the response is 503 and a retry is safe (stable IDs + FINAL). Say so in the README.
- Tenant and user come only from the principal (`teamActor(r)`); the body has no such fields and `DisallowUnknownFields` stays.

### D4. Storage (`internal/metric/clickhouse/store.go`, new `item_uses.go`)
Append to `usageMigrations` (additive, idempotent; no change to `usage_events_v1`; the deployment user already needs CREATE TABLE, `internal/metric/README.md` "Configure"):
```sql
CREATE TABLE IF NOT EXISTS item_uses_v1 (
 tenant_id UUID, user_id UUID, use_id String, occurred_at DateTime64(6,'UTC'),
 tool LowCardinality(String), kind LowCardinality(String), name String,
 team_id String DEFAULT 'unknown', project_id String DEFAULT 'unknown'
 ) ENGINE = ReplacingMergeTree ORDER BY (tenant_id,user_id,use_id)
```
`WriteItemUses(ctx, actor, uses)`: `s.authorize(ctx, actor, false)` (admin or member, tenant context must equal the principal's); 1–1,000 uses; every use `metric.ValidItemUse`; one `INSERT INTO item_uses_v1 FORMAT JSONEachRow` with `tenant_id`/`user_id` from `actor`, `use_id`, `occurred_at` (`2006-01-02 15:04:05.000000` UTC), `tool`, `kind`, `name`, `team_id`/`project_id` via `metric.OrUnknown`. Non-empty response body → `ErrUnavailable` (same as `WriteUsage`).

No Postgres migration, so no migration-number clash with 901r/902a (both take 000025).

### D5. Query (`QueryItemUsage`, admin only)
```sql
-- per item and tool
SELECT kind, name, tool, toString(count()) AS uses, toString(max(occurred_at)) AS last_used
 FROM item_uses_v1 FINAL
 WHERE tenant_id={tenant:UUID} AND occurred_at >= {start:DateTime64(6,'UTC')} AND occurred_at < {end:DateTime64(6,'UTC')}
 GROUP BY kind, name, tool ORDER BY kind, name, tool LIMIT 10001 FORMAT JSONEachRow
-- distinct people per item
SELECT kind, name, toString(uniqExact(user_id)) AS people
 FROM item_uses_v1 FINAL
 WHERE tenant_id={tenant:UUID} AND occurred_at >= {start:DateTime64(6,'UTC')} AND occurred_at < {end:DateTime64(6,'UTC')}
 GROUP BY kind, name ORDER BY kind, name LIMIT 10001 FORMAT JSONEachRow
```
`s.authorize(ctx, actor, true)`; `metric.ValidItemUsageFilter` (same bounds as `ValidFilter`: 1970 ≤ start < end ≤ 2200, ≤ 366 days); bound parameters only; more than 10,000 rows → `metric.ErrTooManyRows`; any undecodable row → `ErrUnavailable`; empty → empty data, never an error. Parse `last_used` with layout `2006-01-02 15:04:05.000000` in UTC.

### D6. Metric types and report (`internal/metric/content_usage.go`, pure, no I/O)
```go
type ItemKey struct{ Kind, Name string }
type ItemUse struct {
	ID, Tool, Kind, Name string
	Timestamp            time.Time
	ProjectID, TeamID    string
}
type ItemUseWriter interface {
	WriteItemUses(context.Context, store.Principal, []ItemUse) error
}
type ItemUsageFilter struct{ Start, End time.Time }
type ItemToolUses struct {
	Item     ItemKey
	Tool     string
	Uses     int64
	LastUsed time.Time
}
type ItemUsageData struct {
	Rows   []ItemToolUses
	People map[ItemKey]int64
}
// Implementations enforce the admin role and tenant like Reader.
type ItemUsageReader interface {
	QueryItemUsage(context.Context, store.Principal, ItemUsageFilter) (ItemUsageData, error)
}
var itemName = regexp.MustCompile(`^[a-z0-9]+(-[a-z0-9]+)*$`)
func ValidItemUse(u ItemUse) bool // validText(ID); itemName + len ≤ 64 for Tool and Name; Kind in ItemUseKinds; Tool in ItemUseTools; Measured(Tool, Kind); 1970 ≤ year < 2200; optionalText(ProjectID/TeamID)
func ValidItemUsageFilter(f ItemUsageFilter) bool

type ContentPack struct {
	Name, Version string
	Items         []ItemKey // skill, prompt and agent items only
}
type ContentToolCell struct {
	Tool     string
	Measured bool
	Uses     int64
}
type ContentItemRow struct {
	Item         ItemKey
	Packs        []string // sorted pack names; empty = not in a current pack
	Cells        []ContentToolCell // one per ItemUseTools, in that order
	Total, People int64
	LastUsed     time.Time
	Measurable   bool // any cell measured
}
type ContentPackRow struct {
	Name, Version   string
	Items, ItemsUsed int
	Uses            int64
}
type ContentUsageReport struct {
	Support   []Measurability
	Packs     []ContentPackRow
	Items     []ContentItemRow
	TotalUses int64
	ItemsUsed int
}
func BuildContentUsageReport(packs []ContentPack, data ItemUsageData) ContentUsageReport
```
Rules (each pinned by a `TestBuildContentUsageReport…` case):
1. Items = every content item of every pack ∪ every item in `data`, once per `ItemKey`.
2. A cell's uses come from `data.Rows` for (item, tool) only when `Measured(tool, kind)`; a row for an unmeasured pair is ignored.
3. `Total` = sum of measured cells; `People` from `data.People`; `LastUsed` = latest `LastUsed` over the item's rows.
4. Pack row (Q3 ⭐a): `Items` = the pack's content items; `ItemsUsed` = those with `Total > 0`; `Uses` = sum of those items' `Total`. An item in two packs adds to both (the page says pack totals can overlap).
5. `TotalUses` = sum of item `Total` (each item once); `ItemsUsed` = items with `Total > 0`.
6. Order: packs by name (byte order); items by `Total` descending, then kind, then name.
7. Config and MCP-template items are not content items and never appear.

### D7. Admin page (`internal/web/content_usage.go`, route in `internal/web/handler.go`)
- Route, beside `/admin/adoption` (`handler.go:236`): `routes.Handle("GET /admin/content-usage", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.contentUsageView)), true))`. Add `· <a href="/admin/content-usage">Content usage</a>` after "Adoption" in the admin nav (`handler.go:764`) and in the new page's own nav.
- `contentUsageFilter(query, now)`: only `from` and `to`, each once; inclusive UTC dates; default the last 30 days (today included); end exclusive = `to` + 1 day; ≤ 366 days; anything else → `org.ErrInvalid`. Reuse the date parsing of `usageFilter` (`usage.go:21-57`).
- `contentUsageView`: bad filter → the page at 400 with `role="alert"` and the form kept; `reader, ok := handler.metrics.(metric.ItemUsageReader)`; `!ok || handler.packVersions == nil` → `writeProblem(503, "CONTENT_USAGE_UNAVAILABLE", "Content usage is temporarily unavailable")`; packs = `handler.contentPacks(r)`; data = `reader.QueryItemUsage`; errors: `org.ErrInvalid`/`metric.ErrTooManyRows` → 400 page "Narrow or correct the period."; `org.ErrForbidden` → 403 problem; anything else → 503 problem (never the error text).
- `contentPacks(r)`: `handler.packVersions.History(ctx, actor)` (tenant versions plus the shared seed base, metadata only); group by `Name`; per name take the version with the latest `CreatedAt`; load it with `handler.packVersions.Preview(ctx, actor, version)`; keep items whose kind is skill, prompt or agent. Forks and edits keep their parent's name (`internal/pack/version_service.go:103`) and built-pack versions carry the pack's name (`internal/store/postgres/pack_builder.go:281-286`), so a name is one pack.
- Rendering copies `renderAdoptionPage` (`adoption.go:147-166`): nonce CSP, `no-store`, `nosniff`, `no-referrer`; the adoption page's stylesheet. Page content, in order (tests assert these exact strings and element IDs):
  - `<h1>Content usage</h1>` and the note: "Counts come from item uses uploaded from engineers' machines with the import command. Leorna does not upload them automatically yet, so zero means no recorded use. An item in several packs counts in each of them."
  - The period form (`from`, `to`, Apply, Reset) like adoption's.
  - Cards: "Item uses<strong>N</strong>", "Items used<strong>N of M</strong>".
  - Empty state when `TotalUses == 0`: `<p class="card" id="empty">No item uses were recorded in this period.</p>` (tables still render, with zeros).
  - `<section id="measurability">` "Where usage can be measured": one row per tool (Claude Code, Codex, Cursor), columns Skills, Prompts, Agents; each cell "Measured" or "Not measurable", with the row's `Basis` in `<small>`.
  - `<section id="by-pack">` "By pack": Pack · Latest version · Items · Items used · Uses. Empty: "No packs hold skills, prompts or agents yet."
  - `<section id="by-item">` "By item": Item · Kind · Packs (comma-joined, or "Not in a current pack") · Claude Code · Codex · Cursor · Total · People · Last used (UTC date or "—"). An unmeasured cell renders `<span class="not-measurable">Not measurable</span>`, never a number; an item with no measurable tool shows Total "—".
- No CSV export (follow-up).

### D8. Auth and tenancy
- Page: `requireSession` + `requireAdmin` (same as the other dashboards) and the store's own `authorize(admin=true)` re-reading the persisted role; tenant from the principal; `store.TenantFromContext` must equal it.
- Writes: members may record only their own uses (`authorize(admin=false)`); no tenant/user in the body.
- Projects: `usageProjects.resolve` (existing): a project the caller can't access stores `unknown`.
- Guards get mutation proof (`mutation-testing-discipline`, task T10).

### D9. Client (leorna-client)
**Files:** `usage/items.go`, `usage/items_claudecode.go`, `usage/items_codex.go`, `usage/items_test.go`, `usage/items_real_test.go`, `usage/testdata/items/{claude-session.jsonl,codex-rollout.jsonl,upload.golden.json}`, `application/managed_items.go` (+ test), `application/application.go` (small refactor), `application/file_check.go` (refactor `syncBaselines`), `cmd/import-content-usage/main.go` (+ `main_test.go`), `api/control-plane.openapi.yaml`, `api/controlplane.gen.go`, `README.md`.

**`usage/items.go`:**
```go
type ItemUse = api.ItemUse

// ManagedItem is one item the last successful Sync installed for a tool.
type ManagedItem struct {
	Tool tc.ToolID
	Kind api.ItemUseKind
	Name string
}

// Managed is what Leorna installed: only uses of these items leave the machine.
type Managed struct {
	items             map[ManagedItem]struct{}
	ClaudeProjectRoot string // the Claude project folder Sync wrote to; "" = none
}
func NewManaged(claudeProjectRoot string, items ...ManagedItem) Managed
func (m Managed) Has(tool tc.ToolID, kind api.ItemUseKind, name string) bool

// Detectable lists the (tool, kind) pairs this client can count. It must equal the
// control plane's measured rows (internal/metric/content-usage-spike.md).
func Detectable() map[tc.ToolID][]api.ItemUseKind // claude-code: skill, prompt; codex: skill

// UploadItemUses sends uses in batches of 1,000 through the generated RecordUsage call,
// with "events": [] (a non-nil empty slice, so the JSON is [] not null).
func UploadItemUses(ctx context.Context, client *api.ClientWithResponses, csrf string, uses []ItemUse) error
```
IDs: `"<tool>:" + hex(sha256(<parts joined by "\x00">))[:40]`, stable across re-imports. Output sorted by (timestamp, id).

**Claude Code detector** `ItemUsesFromClaudeCode(ctx, transcript io.Reader, managed Managed, attribution Attribution) ([]ItemUse, error)`:
1. Read at most 32 MiB (`io.LimitReader`, error beyond, like `toolconnector/internal/chat` `MaxBytes`); split on `\n`; skip blank and invalid-JSON lines (as `claudecode.CaptureSession` does); honour `ctx`.
2. Decode `{type, uuid, timestamp, cwd, isMeta, message:{role, content}}`. Skip a line with no `uuid`, an unparsable `timestamp` (RFC 3339), or a `cwd` that is not the same directory as `managed.ClaudeProjectRoot` (compare `filepath.Clean`, then `filepath.EvalSymlinks` of both when they differ; `toolconnector/internal/chat.SameDir` is internal to `toolconnector/` and cannot be imported from `usage/`). Empty `ClaudeProjectRoot` → no Claude Code uses.
3. `type=="assistant"` and `message.role=="assistant"`: for each `message.content` part with `type=="tool_use"` and `name=="Skill"`, take `input.skill`, strip one leading `/`, require the item-name pattern and `managed.Has(claude-code, skill, name)` → use with ID parts (`uuid`, part `id`).
4. `type=="user"`, `message.role=="user"`, `!isMeta`, `message.content` is a JSON **string** whose left-trimmed text starts with `<command-name>` or `<command-message>`: first match of `<command-name>/([a-z0-9]+(?:-[a-z0-9]+)*)</command-name>`; `managed.Has(claude-code, prompt, n)` → prompt use, else `Has(claude-code, skill, n)` → skill use; ID parts (`uuid`, `"command"`).
5. Everything else is ignored: `Agent`/`Task` calls, `api-request-blob` lines, attachments, `isMeta` skill bodies, assistant text quoting tags, `<command-args>`.
6. De-duplicate by ID.

**Codex detector** `ItemUsesFromCodex(ctx, transcript io.Reader, managed Managed, attribution Attribution) ([]ItemUse, error)`:
1. `codex.Parse(ctx, transcript)` (existing bounded, validated reader; tolerates unknown record types; refuses mixed sessions). The session ID is `payload.id` of the `session_meta` record.
2. For each record with `type=="response_item"`: text = `payload.arguments` when `payload.type=="function_call"`, `payload.input` when `custom_tool_call`, `strings.Join(payload.action.command, " ")` when `local_shell_call`.
3. Find every `(?:^|[^A-Za-z0-9._-])\.agents/skills/([a-z0-9]+(?:-[a-z0-9]+)*)/SKILL\.md` in the text; `managed.Has(codex, skill, n)` → one use per (session, n) at the first matching record's timestamp; ID parts (session ID, `"skill"`, n). Messages (the developer skill listing) are never scanned.

**Managed items** (`application/managed_items.go`):
```go
// DefaultDatabasePath is where OpenDefault keeps the desktop database.
func DefaultDatabasePath() (string, error) // os.UserConfigDir()/Leorna/leorna.db; OpenDefault uses it
// OpenReadOnly opens an existing desktop database without migrating or writing it.
func OpenReadOnly(ctx context.Context, path string) (*Application, error)
// ManagedItems derives what the newest successful Sync installed per tool.
func (a *Application) ManagedItems(ctx context.Context) (usage.Managed, error)
```
- `OpenReadOnly`: `file:` URI with `mode=ro` (build it like `toolconnector/cursor/capture.go:173-185`), `SetMaxOpenConns(1)`, `PRAGMA user_version` must be ≥ 6 (else "open the Leorna app once to update its database"); never calls `migrate`.
- `ManagedItems`: refactor `syncBaselines` (`application/file_check.go:162`) into `syncBaselinesFor(ctx, wanted map[tc.ToolID]bool)` (the existing method calls it with the registry's IDs; behaviour unchanged); call it for claude-code, codex, cursor; ignore baselines with a non-empty `code`; apply the Claude Code rule already in `CheckSyncedFiles` (only a baseline that started at or after the current Sync selection was saved). Map recorded relative paths:
  - claude-code: `^\.claude/skills/([a-z0-9]+(?:-[a-z0-9]+)*)/SKILL\.md$` → skill; `^\.claude/commands/([a-z0-9]+(?:-[a-z0-9]+)*)\.md$` → prompt;
  - codex: `^skills/([a-z0-9]+(?:-[a-z0-9]+)*)/SKILL\.md$` → skill;
  - cursor: `^skills/(…)/SKILL\.md$` → skill, `^commands/(…)\.md$` → prompt (recorded for completeness; no Cursor detector).
  **First** confirm the exact recorded prefixes in `application/sync_e2e_test.go` / `sync_prompt_e2e_test.go` (Codex and Cursor record `skills/<name>/SKILL.md`, `file_check_e2e_test.go:123-124`; prompts end in `commands/<name>.md`, `sync_prompt_e2e_test.go:191`) and adjust the patterns to what Sync records, not to this plan.
  - `ClaudeProjectRoot` = `SyncSelection(ctx).ClaudeProjectRoot`.

**Import command** `cmd/import-content-usage` (copy the shape of `cmd/import-codex-usage/main.go`, but with a testable `run(ctx, args []string, getenv func(string) string, stdout io.Writer) error`):
- Flags: `-tool claude-code|codex` (required; `cursor` → error "Cursor item use is not measurable; nothing was sent"), `-transcript FILE` (repeatable, at least one, each an explicit file), `-server URL`, `-project UUID` (optional; default the desktop's selected remote project), `-desktop-db PATH` (optional; default `application.DefaultDatabasePath()`).
- Server URL: `https`, or `http` only when the host is a literal loopback IP (`net.ParseIP(host).IsLoopback()`, the same rule as the control plane's ClickHouse client, `internal/metric/clickhouse/store.go:46-53`); no user info, query or fragment. This lets the local demo run without TLS.
- Auth: `LEORNA_SESSION_TOKEN` and `LEORNA_CSRF_TOKEN` from the environment, sent as `__Host-leorna-session`/`__Host-leorna-csrf` cookies plus `X-CSRF-Token` (same as `import-codex-usage`); never printed.
- Flow: open the desktop DB read-only → `ManagedItems` + selection → run the tool's detector on each file → merge, de-duplicate, sort → if none: print "No uses of items Leorna installed were found; nothing was sent." and exit 0 **without a network call** → else `usage.UploadItemUses` → print "Uploaded N item uses from M transcript(s): S skill uses, P prompt uses. Re-importing the same transcripts counts nothing twice." (counts only, no names or paths). HTTP client: 20 s timeout, no redirects.

**What leaves the machine (Q2 ⭐a):** per use only `id` (a hash), `tool`, `kind`, `name` (a name Leorna itself installed), `timestamp` and the optional project ID. Never transcript text, command arguments, file paths, `cwd`, personal item names or agent names.

### D10. Docs
- Control plane: new `internal/metric/content-usage-spike.md` (the spike write-up with the machine-checked table, method, per-tool evidence, version notes, matching rules, privacy, follow-ups); `internal/metric/README.md` new section "## Content usage (story 86bcm902w)" (storage, ingest rules, query bounds, page, tests to run, link to the spike); one sentence in the root `README.md` "Usage dashboard and captured metrics" section naming `/admin/content-usage`.
- Client: `README.md` new section "## Content usage import (story 86bcm902w)" after the 86bcm902h section (command, flags, what is sent, what is not, Cursor and agents not measurable, link to the control-plane spike write-up by its GitHub path).

### D11. Merge order and partial merges
- **Control plane first**, then the client. Both PRs are listed under 86bcm902w in `delivery/stories.json`.
- Only the control plane merged: the page works (empty until uploads); `/v1/usage` and `/v1/client/usage` accept item uses; nothing sends them yet. Harmless.
- Only the client merged: `import-content-usage` fails with "usage upload rejected; verify login and server availability" (the old server refuses the unknown `itemUses` field with 400); nothing is stored; `import-codex-usage` is unaffected (its batches never set `itemUses`, which is `omitempty`).

## Skills for the build roles

Every role loads `leorna` (its role section), then `engineering-best-practices`, then:
- **Builder:** `test-driven-development`, `mutation-testing-discipline` (tenant, admin and ingest guards, T10), `api-contract-drift-guard` ⚑, `backend-data-migrations` ⚑ (additive ClickHouse table), `security-best-practices`, `multi-tenant-auth-management`.
- **Reviewers:** `requesting-code-review`, `code-review-practice` (report only), plus `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` ⚑.
- **Fixers/finisher:** `receiving-code-review`, `test-driven-development`, `git-commit-rules` (finisher).
- **Verifier/auditor:** as `feature-dispatch/references/ac-verification.md`.

⚑ = the skill ends with "Mandatory Validation and Agent Defect Loop": its loop is run by the pipeline's review → fix → verifier → auditor rounds (the main session dispatches; agents never start agents).

Every brief carries the `skill_lessons` rule and this line: scratch lives in a fresh `<scratchpad>/86bcm902w-<role>/` (`mkdir` without `-p`), removed only by its literal absolute path; `/tmp` is a small RAM tmpfs, so Go `TMPDIR`, Chrome profiles and binaries go to `~/.cache/86bcm902w-<role>/`.

## Two-repo verification mechanics (orchestrator)

`ac-check.sh` and `review-check.sh` each take one `--repo`. So:
- `ac-check.sh --repo <control-plane worktree> --base <cp base> --plan <evidence>/plan-approved.md --reviews <evidence> …` covers AC1–AC5 (all named tests are control-plane tests).
- Every reviewer reviews **both** branches and writes `<evidence>/review-<n>/review.json` (control-plane head and findings) **and** `<evidence>/client/review-<n>/review.json` (client head and findings; an empty findings list when clean). The main session runs `review-check.sh` twice: `--repo <cp worktree> --base <cp base> <evidence>` and `--repo <client worktree> --base <client base> <evidence>/client`. MOVE ON needs both.
- The verifier and auditor name the client head they checked in their reports' `evidence` lines, run the client supporting tests and gates on it, and run both `cmp` checks above. A client head change after acceptance needs the client review → verifier → auditor again, like a control-plane change.

## Host prerequisites (checked 2026-10-29 on the WSL desktop)

| Need | Result |
| --- | --- |
| `go` | Not on PATH; Go **1.27.3** at `~/.local/leorna-toolchain/go/bin` = CI (`go.work` / client `toolchain go1.27.3`). Use the task-local PATH above. |
| `make`, `gcc` | GNU Make 4.4.1, gcc 15.2.0 (cgo on for `-race` and go-sqlite3). |
| `golangci-lint`, `govulncheck` | 2.14.0 and v1.7.0 at `~/.local/leorna-toolchain/bin`, the versions both CIs pin (`ci.yml:124-139`; client `ci.yml:30-31`). Bind `GOLANGCI_LINT=`/`GOVULNCHECK=` to these absolute paths for control-plane `make check`; put that bin first on PATH for client `make lint audit` and echo `golangci-lint --version`. |
| `node` | v22.23.3 at `~/.local/bin/node` (client UI tests). |
| `gitleaks` | 8.30.1 at `/usr/local/bin` (control-plane `make secrets`, library gate). |
| Docker | Works; `leorna-test-pg` (Postgres 18.6) up on `127.0.0.1:55432`. `leorna-pg` holds 5432: never touch it. `psql` is not installed: create/drop DBs with `docker exec leorna-test-pg psql -U leorna -d leorna_test -c …`. |
| ClickHouse | **Missing** → Q4. Port 18123 free now (recheck; pick another loopback port and record it if taken). |
| Wails/GTK/WebKit | `pkg-config` and GTK/WebKit dev packages are absent, but the Wails entry point `cmd/leorna-client` is behind `//go:build desktop`, so the client's `make check` (no tag) doesn't build it. Not needed. |
| Client gates on this desktop | No recorded client `make check` run on WSL yet. Task T0's client base baseline is the first; a failure on unchanged base is recorded by test identity as a host/baseline failure and not fixed in this story. If a host failure blocks a gate the builder can't work around within the task, stop and report it (main session asks Justin). |
| Chrome for Testing | `~/.cache/chrome-for-testing/chrome-linux64/chrome` with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, under `env -u DISPLAY -u WAYLAND_DISPLAY`. `chromedp` v0.16.0 and `goldmark` v1.7.17 are control-plane dependencies (in the module cache). |
| Claude Code | 2.1.312 at `~/.local/share/claude/versions/2.1.312` (env-gated real-tool test, isolated HOME only). |
| Disk | 896 GB free on `/`; `/tmp` is the 7.9 GB shared tmpfs (keep only small files there). |

## Tasks (builder; test first; stop at `ready-for-review`)

Time forecast: 6–9 hours of focused work plus gate runs (~10 min control plane, ~5 min client per full run). Commit after each green task with `feat(86bcm902w): …`, explicit file paths, plain `git commit` (identity from `~/.gitconfig-leorna`; no AI attribution lines; never stage `CLAUDE.md`).

### T0. Workspace, data stores, baselines
1. Both main checkouts must still be on `main` = `origin/main` = the bases above (`git -C <repo> rev-parse main origin/main`). If GitHub `main` moved, stop and report (the main session re-plans the base).
2. Create the worktrees from the bases:
   `git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm902w-content-usage-analytics .claude/worktrees/86bcm902w-content-usage-analytics b65f797ff6cdc56a802dfaf417b0adec96463317`
   `git -C ~/Leorna/leorna-client worktree add -b feat/86bcm902w-content-usage-analytics .claude/worktrees/86bcm902w-content-usage-analytics f105e27814b6efbec67059687963e722933acec2`
   Then `git status --porcelain` empty in both, and `git -C <worktree> config user.email` prints `justin@leorna.com` in both (after the first commit, `git log -1 --pretty=format:'%an <%ae>'` must show `Justin Issa <justin@leorna.com>`).
3. `mkdir ~/.cache/86bcm902w-builder ~/.cache/86bcm902w-builder/tmp` (no `-p` for the first); scratchpad folder `<scratchpad>/86bcm902w-builder/`.
4. Postgres: `docker exec leorna-test-pg psql -U leorna -d leorna_test -c 'CREATE DATABASE leorna_86bcm902w_builder_test'` and `… leorna_86bcm902w_base_test`. Never touch another story's database.
5. ClickHouse (Q4 ⭐a): `docker run -d --name leorna-test-ch-86bcm902w -p 127.0.0.1:18123:8123 -e CLICKHOUSE_DB=leorna_metrics -e CLICKHOUSE_USER=leorna_test -e CLICKHOUSE_PASSWORD=local-integration-only mirror.gcr.io/clickhouse/clickhouse-server:25.8@sha256:0152dd511befe6a2c2ef53e930726179669b08116da78500b37c51c96ff5ee77`; wait until `curl -s http://127.0.0.1:18123/ping` prints `Ok.`. (Tests use random tenants, so base and head runs can share it; the credentials are the CI fixture's test-only values.)
6. Base baselines in **detached** worktrees (never the story worktree): `git -C <repo> worktree add --detach ~/.cache/86bcm902w-builder/base-<repo> <base>`. Control plane: `make check` (env as above with the `_base_test` DB, `GOLANGCI_LINT=`/`GOVULNCHECK=` bound) and `bash ./scripts/test-module-add.sh`; client: `make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit`. Save `baseline-b65f797.txt` and `baseline-client-f105e27.txt` (each gate's `EXIT=`). With ClickHouse set, `TestTeamsAPIWithPostgres`'s two ClickHouse subtests now run: record their base result. Remove these copies afterwards with `git worktree remove --force <own path>` (never `git worktree prune`).

### T1. Spike write-up and support table (AC1)
1. RED: `internal/metric/content_usage_spike_test.go` with `TestContentUsageAC1SpikeMatchesSupportTable` (assertions in "What each AC test asserts"; parse rows `| tool | kind | yes/no | basis | verified on |` between the two markers; test-only imports of `internal/library` and `internal/pack` for the tool and kind checks). Run the AC1 command: fails to build (`undefined: ItemUseSupport`).
2. GREEN: `internal/metric/content_usage.go` with D1's code; `internal/metric/content-usage-spike.md` (D10 outline; the table rows use D1's Basis text exactly; "Verified on" cells: `Claude Code 2.1.312, 2026-10-29`, `Codex 0.165.0, 2026-10-29`, `Cursor 3.20.17 store fields (2026-10-03), 3.23.23 command loader (2026-10-22)`). Describe evidence by shape only; never paste transcript content. Same command passes.
3. Falsify: change one Basis word in the doc → test fails; restore. Delete one row → fails; restore.

### T2. Contract (both repos regenerate)
1. Control plane: apply D2 to `contracts/control-plane.openapi.yaml`; `make generate`; `go build ./... ./packages/contracts/...`; `go test -count=1 -run 'TestContractItemKindsMatchPackKinds' ./internal/web/` still passes (two inline kind enums). Commit spec + generated file together.
2. Client: `cp <cp worktree>/contracts/control-plane.openapi.yaml api/control-plane.openapi.yaml`; `make generate`; `make contracts-check`; `go test -mod=vendor -count=1 -run TestContractItemKindsAreAcceptedBySync ./application/`. Commit both files.

### T3. Metric types, validation, report (pure)
1. RED: `internal/metric/content_usage_test.go`: `TestValidItemUse` (table: valid claude-code skill; bad name `Not A Name`, `../x`, 65 chars; unknown tool `windsurf`; unknown kind `config`; each unmeasured pair; zero time; year 2200) and `TestBuildContentUsageReport…` cases for D6 rules 1–7 (including: item in two packs counted in both, unmeasured row ignored, agent item `Measurable=false`, pack latest-version items passed in, ordering).
2. GREEN: D6 code in `content_usage.go`. Run `go test -count=1 ./internal/metric/`.

### T4. ClickHouse store (query tests)
1. RED: `internal/metric/clickhouse/item_uses_test.go`:
   - `TestItemUsesMigrateIsAdditiveWithClickHouse`: `Migrate` twice; a `usage_events_v1` row written before still reads back through `QueryUsage`; `item_uses_v1` exists.
   - `TestItemUsageQueryCountsReplayPeriodAndTenantWithClickHouse`: random tenant; write 3 uses (2 users) twice (replay) → counts once; a use at the period's exclusive end and one 1 µs before (only the earlier counts); another tenant's uses invisible; member principal → `org.ErrForbidden`; tenant context mismatch → `org.ErrForbidden`; empty period → empty data, nil error; `People` per item = distinct users; `LastUsed` exact; an httptest ClickHouse answering 500 → `ErrUnavailable`.
   Skip only with `LEORNA_TEST_CLICKHOUSE_URL not set` (existing convention).
2. GREEN: D4 + D5 in `item_uses.go` and the `usageMigrations` entry; `var _ metric.ItemUseWriter = (*Store)(nil)`, `var _ metric.ItemUsageReader = (*Store)(nil)`. Keep `TestMigrateSucceedsOnReplicatedClickHouse` green (the new DDL returns an empty body there too).

### T5. Ingest (AC5)
1. RED: `internal/web/content_usage_test.go` with `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres` (fixture: `newPackFixture(t, func(h *Handler, s *postgres.Store){ … })` (`packs_test.go:41`) wiring a real `clickhouse.New(clickhouse.Config{URL: endpoint, Database: "leorna_metrics", User: "leorna_test", Password: testWebClickhousePassword()}, s)` + `Migrate` + `h.SetMetrics`; skip only on the missing-variable message). Posts via `fixture.login(t, fixture.member, token)` with the CSRF cookie/header as `teams_test.go:398-403` does; reads stored rows straight from ClickHouse with a helper modelled on `storedUsageDimensions` (`teams_test.go:797`) filtered by the fixture's tenant.
2. GREEN: D3. Then `go test -count=1 -run 'TestTeamsAPIWithPostgres' ./internal/web/` (existing usage subtests unchanged).

### T6. Page skeleton and route (AC3)
1. RED: `TestContentUsageAC3NotMeasurableIsStated` in `internal/web/content_usage_component_test.go`: `newAssignHandler(t, &fakeAssigner{})` (as `adoption_test.go:28`), a fake metric value implementing `metric.Reader` + `metric.ItemUsageReader` (func type like `adoptionReaderFunc`, `adoption_test.go:17-25`), a fake `packVersioner` whose `History` returns one pack version and `Preview` returns its items (skill `review-checklist`, prompt `pr-summary`, agent `test-planner`, an `mcp_template`); assertions in "What each AC test asserts", scoped to `#measurability` and to each `#by-item` row (cut the HTML between the row's start and `</tr>`), not whole-body `Contains`.
2. GREEN: D7 code, route, nav link, template. Run AC3 command.

### T7. Counts per pack and item (AC2)
Needs the client golden body: do T9.1 (`TestContentUsageGoldenUploadBody` and its byte copy into the control plane) before this task, or write T7 after T9.
1. RED: `TestContentUsageAC2CountsPerPackAndItemWithPostgres` in `content_usage_test.go`, same fixture as T5 plus `h.SetPackVersions(pack.NewVersionService(s))`. Data (admin principal, `store.WithTenant`): `fixture.repository.CreateVersion(…, pack.NewPackVersion{Name: "Backend pack", Version: "backend-1", Items: [skill review-checklist, prompt pr-summary, agent test-planner, mcp_template ac2-tools]})`, then `"backend-2"` (ParentVersion `backend-1`) = backend-1's items + skill `release-notes`; `"Frontend pack"` `"frontend-1"` = skill review-checklist + skill ui-audit. Uploads (`POST /v1/usage`):
   - member: the file `internal/web/testdata/content_usage_client_upload.json` (byte copy of the client golden, T9) = claude-code skill review-checklist at 2026-10-01T09:00Z and 09:05Z, claude-code prompt pr-summary 09:10Z, codex skill review-checklist 10:00Z; posted **twice**;
   - admin: claude-code skill review-checklist 2026-10-02T08:00Z, claude-code skill ui-audit 08:30Z, claude-code skill personal-notes 09:00Z, claude-code skill ui-audit 2026-09-15T12:00Z.
   GET `/admin/content-usage?from=2026-10-01&to=2026-10-31` as admin → 200, and:
   - cards: "Item uses<strong>7</strong>", "Items used<strong>4 of 6</strong>" (review-checklist, pr-summary, ui-audit, personal-notes used; release-notes and test-planner not; the seed base's items, if the fixture loads it, change M: compute M from the page's own rows or assert only the "Items used" left number — the builder checks whether `newPackFixture` loads the seed base and pins the exact text);
   - `#by-pack`: Backend pack · backend-2 · 4 · 2 · 5; Frontend pack · frontend-1 · 2 · 2 · 5;
   - `#by-item`: review-checklist · skill · "Backend pack, Frontend pack" · 3 · 1 · Not measurable · 4 · 2 · 2026-10-02; pr-summary · prompt · Backend pack · 1 · Not measurable · Not measurable · 1 · 1; ui-audit · skill · Frontend pack · 1 · 0 · Not measurable · 1 · 1; personal-notes · skill · Not in a current pack · 1 · 0 · Not measurable · 1 · 1; release-notes · skill · Backend pack · 0 · 0 · Not measurable · 0 · 0 · —; test-planner · agent · Backend pack · three "Not measurable" · —; no row for `ac2-tools`;
   - GET with `from=2026-09-01&to=2026-09-30`: only ui-audit has 1, "Item uses<strong>1</strong>".
2. GREEN: whatever T4–T6 left missing. Run AC2.

### T8. Guards (AC4)
1. RED: `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres` (same fixture): `fixture.get(t, memberClient, "/admin/content-usage", 403)`; an unauthenticated client gets 302 with `Location` `/v1/auth/google/login…`; tenant A's member uploads review-checklist uses; tenant B (`fixture.other`, admin of its own tenant) creates a pack holding review-checklist and sees `0` in that row and "Item uses<strong>0</strong>"; stored rows (direct ClickHouse read) carry A's tenant and the member's user ID; a body field `"userId"` or `"tenantId"` is refused (400); store level: `QueryItemUsage` with the member principal and with a mismatched `store.WithTenant` → `org.ErrForbidden`.
2. GREEN if anything is missing. Run AC4.

### T9. Client detection, managed items, golden body
1. RED `usage/items_test.go`:
   - `TestContentUsageDetectsOnlySyncedItemUses`: `claude-session.jsonl` (synthetic, shaped like 2.1.312: `uuid`, `timestamp`, `cwd`, `sessionId`, `message`) with: a Skill call for managed `review-checklist`; a second one 5 min later; a typed `/pr-summary` command line with `<command-args>LEORNA-SECRET-ARG</command-args>` (managed prompt); a Skill call for unmanaged `personal-notes`; an `Agent` call (`subagent_type: test-planner`); an assistant text part quoting `<command-name>/pr-summary</command-name>`; an `api-request-blob` line copying the command text; a user line whose content is a list holding the tag; an `isMeta` skill-body line; a Skill call for review-checklist from another `cwd`; an invalid JSON line. `codex-rollout.jsonl` (synthetic, shaped like 0.165.0: `session_meta`, `turn_context`, a developer `message` listing `~/.agents/skills/review-checklist/SKILL.md`, two `custom_tool_call` `exec` inputs reading that file, one reading unmanaged `~/.agents/skills/other-skill/SKILL.md`, one `function_call` `shell` with `arguments` reading `/home/u/.codex/skills/review-checklist/SKILL.md` (wrong root), a `token_count`). Managed = claude-code {skill review-checklist, prompt pr-summary}, codex {skill review-checklist}, `ClaudeProjectRoot` = the fixture's cwd. Want: exactly 2 Claude skill uses, 1 Claude prompt use, 1 Codex skill use; running twice gives identical IDs; `Detectable()` equals exactly {claude-code: skill, prompt; codex: skill}.
   - `TestItemUsesCarryNoTranscriptText`: JSON of every use has keys ⊆ {id, tool, kind, name, timestamp, projectId} and contains none of `LEORNA-SECRET-ARG`, the fixture's `cwd`, any `toolu_`/line UUID, `personal-notes`, `test-planner`, `other-skill`.
   - `TestContentUsageGoldenUploadBody`: the batch the command would send for those fixtures (`api.UsageBatch{Events: []api.UsageEvent{}, ItemUses: &uses}`, `json.MarshalIndent(…, "", "  ")` + `\n`) equals `testdata/items/upload.golden.json` byte for byte (`-update` flag regenerates; read the diff before committing). Then copy that file byte for byte to control-plane `internal/web/testdata/content_usage_client_upload.json` (T7 uses it).
2. RED `application/managed_items_test.go`: `TestManagedItemsFromLastSuccessfulSync` (drive the existing Sync e2e fixture of `sync_prompt_e2e_test.go` to a successful Sync of a pack with a skill and a prompt to claude-code and codex; then a later run that fails codex keeps codex's earlier items; a `baseline_invalid` row yields no items for the tools it may have written) and `TestOpenReadOnlyNeverMigrates` (a v6 DB's bytes unchanged after `OpenReadOnly` + `ManagedItems`; a v5 DB → the "open the Leorna app once" error; a missing file → error, no file created).
3. GREEN: D9 code.
4. `go test -mod=vendor -count=1 ./usage/ ./application/`.

### T10. Import command, real-tool check, mutation proof
1. RED `cmd/import-content-usage/main_test.go`: `TestImportContentUsageSendsOnlyIdentifiers`: a desktop DB built by T9's fixture helper, an `httptest` server on 127.0.0.1 capturing the request: path `/v1/usage`, cookie + `X-CSRF-Token` present, body equals the golden; a transcript with no managed uses → no request at all and the "nothing was sent" line; `-tool cursor` → error, no request; `-server http://example.test` → error (non-loopback http); stdout holds no item name, path or token.
2. GREEN: D9 command.
3. `usage/items_real_test.go` `TestRealClaudeCodeTranscriptItemUses`, skipped unless `LEORNA_TEST_CLAUDE_BIN` is set: copy the fake-model-API and run pattern of `toolconnector/claudecode/prompt_real_test.go` (isolated HOME and `CLAUDE_CONFIG_DIR` in `t.TempDir()`, `ANTHROPIC_BASE_URL` to the httptest server, proxies to `127.0.0.1:1`); install prompt `leorna-usage-check` and skill `leorna-usage-skill` into a temp project with the real transformer and writer; run `claude -p "/leorna-usage-check LEORNA-ARG-7"` and `claude -p "/leorna-usage-skill"`; read the session `.jsonl` files under the isolated `projects/` folder; `ItemUsesFromClaudeCode` with that project as `ClaudeProjectRoot` must return exactly one prompt use and one skill use. Log (counts only) whether Claude Code also wrote a `Skill` tool call for the typed skill; if it did, the detector must still count one use (fix the detector, add that shape to the fixture, note it in the spike write-up). Run it once locally: `LEORNA_TEST_CLAUDE_BIN=$HOME/.local/share/claude/versions/2.1.312 go test -mod=vendor -v -count=1 -run '^TestRealClaudeCodeTranscriptItemUses$' ./usage/` and keep `real-claude-<client sha7>.log`. Never point it at the real `~/.claude`.
4. Mutation proof (`mutation-testing-discipline`; apply each with `go test -overlay` or a scratch copy, never leave it in the tree; record `mutants-<sha7>.txt` with the killing test per mutant):
   control plane — M1 `QueryItemUsage` authorizes with `admin=false` (AC4); M2 query without `tenant_id={tenant:UUID}` (AC4); M3 `WriteItemUses` takes the tenant from `store.TenantFromContext` without comparing it to the actor (AC4 store case); M4 `ValidItemUse` skips `Measured` (AC5); M5 decoder without `DisallowUnknownFields` (AC5); M6 route without `requireAdmin` (AC4); M7 report totals include unmeasured cells (AC3); M8 pack items from the oldest version (AC2); M9 query without `FINAL` (AC2 replay or T4); M10 item-only batch skips the "at least one" check (AC5 empty batch);
   client — C1 no `cwd` check; C2 no `managed.Has`; C3 command tag accepted anywhere in the line, not at the start; C4 Codex counts every read (no per-session de-dup); C5 messages scanned in Codex. Each must fail a test; a survivor gets a new test.

### T11. Docs and records
1. Control plane: the spike write-up (T1), `internal/metric/README.md` section, root `README.md` sentence (D10). Append this entry **last** in `delivery/stories.json`, as text (never re-dump the file), then check every earlier entry is unchanged by value:
   ```json
     "86bcm902w": {
       "name": "Content usage analytics (which items get used)",
       "prs": {
         "LeornaAI/leorna-control-plane": [],
         "LeornaAI/leorna-client": []
       }
     }
   ```
   and run `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`.
2. Client: `README.md` section (D10).
3. Evidence folder `~/.hermes/plans/leorna/evidence/86bcm902w/` with `INVENTORY.md` (AC → test → log → screenshot, head per file) and per-head gate logs. The plan copy `plan-approved.md` is made by the main session on **go**.
4. `leorna-workflow.md`: agents do not edit memory; the finisher drafts the status line in its hand-over and the main session saves it.

### T12. Gates and evidence capture
1. Gates on the story heads (logs `gates-<sha7>.txt`, `gates-client-<sha7>.txt`, each step's `EXIT=`):
   - Control plane, in the story worktree with the common environment and the `_builder_test` DB: `GOLANGCI_LINT="$HOME/.local/leorna-toolchain/bin/golangci-lint" GOVULNCHECK="$HOME/.local/leorna-toolchain/bin/govulncheck" make check`; `bash ./scripts/test-module-add.sh`; a `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/metric/...` stream read per test with no skip naming `LEORNA_TEST_DATABASE_URL` or `LEORNA_TEST_CLICKHOUSE_URL` (only `TestEvidenceThirdPartyContentPage` "LEORNA_EVIDENCE_DIR is not set" and `TestProvisionManagedPostgresLive` "SCW_LIVE=1 not set" may skip); the admin-console UI tests are these Go HTML tests (no separate browser suite exists).
   - Client, in its story worktree: `export TMPDIR=$(cd ~/.cache/86bcm902w-builder/tmp && pwd -P)`; `make check`; `node --test scripts/*-ui.test.cjs`; `PATH="$HOME/.local/leorna-toolchain/bin:$PATH" golangci-lint --version` (2.14.0) then `make lint audit` with that PATH.
   - `cmp` checks (golden body, OpenAPI file) exit 0.
   Compare with the T0 baselines by test identity; a new failure is the story's.
2. Demo and captures (real binaries; `LEORNA_DEV_MODE=1` only on `127.0.0.1` with a throwaway `_test` DB; recipe: `evidence/86bcm901y/capture.sh.txt` + `capture-main.go`, and the server line in `leorna-control-plane-workflow.md` "Status 2026-10-28 (86bcm901j finisher …)"):
   1. Build `./cmd/control-plane` from the story worktree (`go version -m` shows the head, `vcs.modified=false`); run it with `LEORNA_DEV_MODE=1`, a manifest copy, `127.0.0.1:<free port>`, `LEORNA_PUBLIC_BASE_URL=https://demo.leorna.invalid`, a random `LEORNA_SECRET_ENCRYPTION_KEY`, database `leorna_86bcm902w_demo_test` (`sslmode=disable`), and `LEORNA_CLICKHOUSE_URL=http://127.0.0.1:18123` `LEORNA_CLICKHOUSE_DATABASE=leorna_metrics` `LEORNA_CLICKHOUSE_USER=leorna_test` `LEORNA_CLICKHOUSE_PASSWORD=local-integration-only`.
   2. As the dev admin: build a pack from two embedded library skills and one prompt that support claude-code and codex (`/admin/library` → create pack), create a team and project, assign the pack.
   3. Capture `ac2-empty-before.png` (`/admin/content-usage`, packs listed, every count zero, the empty-state line).
   4. Sync for real without the window with the 86bcm901r driver (`~/.hermes/plans/leorna/86bcm901r-ac4/run.sh` + `client-sync.go`, copied into your scratch, never edited in place) for claude-code and codex into a scratch HOME and project folder; this leaves the desktop DB at `$H/.config/Leorna/leorna.db`.
   5. Write two synthetic transcripts (no real content) shaped like the fixtures: a Claude Code session with `cwd` = the scratch project using the synced skill twice and the prompt once, and a Codex rollout reading `$H/.agents/skills/<synced skill>/SKILL.md`; run the client-built `import-content-usage` under `env -i HOME=$H XDG_CONFIG_HOME=$H/.config …` with `-server http://127.0.0.1:<port>` and the session/CSRF cookie values from a curl jar of `/dev/login` (values passed by environment only, never printed or logged); keep its output as `ac2-import.log`, rendered to `ac2-import-terminal.png`.
   6. Capture `ac2-per-pack-after.png` (`#by-pack`), `ac2-per-item-after.png` (`#by-item`), `ac3-not-measurable.png` (`#measurability` plus the item table) with chromedp element screenshots (`chromedp.Screenshot("#by-pack", …, chromedp.ByQuery)`).
   7. AC1: render `internal/metric/content-usage-spike.md` with goldmark to a local HTML file and screenshot the support-table section (`ac1-spike-table.png`, page labelled "local rendering").
   8. AC4/AC5: render `ac4-<sha7>.log` / `ac5-<sha7>.log` in a `<pre>` page and screenshot with `chromedp.FullScreenshot` (`ac4-guards-terminal.png`, `ac5-ingest-terminal.png`); each shows the command, every PASS line and `EXIT=0`.
   9. Inspect every PNG (bands of ≤1,300 px) and grep each image's text source for emails, URLs, tokens and passwords before calling it done; the demo uses only the reserved `demo.leorna.invalid` name. Stop the server, drop `leorna_86bcm902w_demo_test`, keep the container (later roles need it).
3. Report `ready-for-review` with: both branch names and heads, files changed per repo, every AC → test → log → screenshot, gate results vs baselines, the mutation table, the ClickHouse container name/port, the DBs you created (drop `_base_test` and `_demo_test`; keep `_builder_test` until the finisher), `found_else`, `skill_lessons`.

## Risks, sibling overlaps and hand-over

Open siblings at planning time (`gh pr list` both repos, 19:23 UTC): control-plane **#101** 86bcm902a quick start (`bb79ec6`, MERGEABLE); no open client PR. Local-only branches: control-plane `feat/86bcm901r-starter-packs` (`805b6cd`, ALL ACCEPTED, needs a bring-main-in). 86bcm901z has no plan yet (another session). Worktrees present (names only): control plane 901a, 901b, 901j, 901r, 901w, 901y, 902a; client none.

| File | Also edited by | How the finisher resolves it |
| --- | --- | --- |
| `delivery/stories.json` | #101 (902a), 901r | Take main's file unchanged, append this story's entry last as text, check earlier entries by value (`leorna` skill step 7.2). |
| `internal/web/handler.go` (route + nav line 764) | #101 (+17/−2), 901r (+2) | Keep every side's routes; nav: keep all links. Trial-merge and run gates. |
| `README.md` (root) | #101 (+4) | Separate sections; resolve by keeping both. |
| Migrations | 901r and 902a both add `000025_*` | This story adds **no** Postgres migration: no clash. |
| `contracts/control-plane.openapi.yaml` | none open | If a sibling changes the spec first, re-copy the full file to the client and regenerate both. |
| `cmd/control-plane/main.go` | #101, 901r | This story doesn't edit it (the ClickHouse store gains interfaces; `SetMetrics` already binds it). |
| `internal/metric/*`, usage ingest | none | — |
| Client `usage/`, `application/file_check.go`, `application/application.go`, `api/*` | Yan's 86bcnuxce (To Do, not started) | If it starts first, coordinate: it should call `usage.ItemUsesFrom…` and `ManagedItems` rather than add parallel detectors. |
| 86bcm901z company variants | — | Variants are "used in packs exactly like a library item" (card AC3), so they are counted by (kind, name) with no change here. |

Other risks:
- **Detector drift on tool updates** (undocumented transcript formats). Mitigation: fixtures modelled on verified shapes, the real Claude Code test, version notes in the write-up; follow-up to re-verify per release.
- **Codex inference** undercounts (a skill used without reading `SKILL.md` through a tool call is invisible) and counts once per session. Labelled "Inferred" on the page.
- **Claude Code sessions started in a subfolder** of the synced project don't count (conservative `cwd` rule, same as `ReadChat`). Listed in the write-up.
- **Per-pack totals overlap** for shared items (Q3 ⭐a); the page says so.
- **Client OpenAPI snapshot catch-up** pulls in 901w/901y types: generated code only; `make contracts-check` and the client contract-kind test must stay green.
- **Two-repo pipeline mechanics** (above) are new to the scripts; the main session must run `review-check.sh` for the client too.
- **Pack listing cost**: `Preview` loads whole item bodies for each pack's latest version; fine for today's pack counts (≤500 items each). A lighter metadata query is a follow-up if pages slow.

## Follow-ups (not in this story)
- Automatic upload after Sync (86bcnuxce, Yan) should reuse these detectors and `ManagedItems`.
- Cursor: verify on a real store whether `toolFormerData` parameters name a skill file or command; flip the support rows only with a test.
- Agents: once a transformer installs agents (Claude Code `.claude/agents/`, Codex agents), count `Agent`/`Task` `subagent_type` and Codex `spawn_agent.agent_type` and flip those rows.
- CSV export for content usage; team/project filters.
- A CI check that the client's OpenAPI snapshot equals the control plane's (no CI changes in this story).

## Assumptions
- "Item" = (kind, name), the identity every tool sees; versions of an item count together.
- "Pack" = a pack version name; its items are those of its newest version (forks and built-pack versions keep the name).
- Codex skill use is counted from `SKILL.md` reads under `.agents/skills/` (Leorna's write root), once per session.
- Claude Code counts each `Skill` call and each typed command line; agent calls are not counted.
- Item uses carry no cost and never change the existing usage, cost, adoption or monthly figures (separate table).
- The page shows the shared seed base pack like any other assignable pack.
- The import command accepts `http` only for a literal loopback IP, so the local demo needs no TLS.
- ClickHouse fixture credentials (`leorna_test` / `local-integration-only`) are CI's public test values, not secrets.

## Other things found (not fixed here)
1. P3 — The client's OpenAPI snapshot is 193 lines behind the control plane (`api/control-plane.openapi.yaml` differs from `contracts/control-plane.openapi.yaml` from line 1006: 901w/901y `/v1/packs…` operations and `PackItemKind`… schemas never copied). Neither repo's CI compares the two, so drift goes unnoticed until a client story copies the file.
2. P3 — Both explicit importers authenticate with the admin console's session and CSRF cookies taken from environment variables (`cmd/import-codex-usage/main.go:36-39`); the desktop-token route `/v1/client/usage` has no client caller yet. Engineers can't realistically run imports today; 86bcnuxce covers the automatic path.
3. P3 (process) — `ac-check.sh` and `review-check.sh` each take one `--repo`; `ac-verification.md:29` covers ac-check for two-repo stories but nothing covers review-check, so a client branch's commits could reach hand-over unreviewed by the script. This plan's "Two-repo verification mechanics" works around it.

## Completion contract
The builder stops at `ready-for-review` (T12.3). Done for the story = review loop MOVE ON for **both** repos on their final heads → verifier → blind auditor → `ac-check.sh` ALL ACCEPTED (control-plane repo) with the client receipts and `cmp` checks recorded → finisher hand-over (PR texts for both repos, merge order control plane first, review prompt, ClickUp evidence draft, team message, ClickHouse container removal). Nothing is pushed, no PR is opened and nothing is posted until Justin says so.
