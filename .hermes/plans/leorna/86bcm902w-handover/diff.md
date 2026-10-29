# 86bcm902w stop and show (finisher, 2026-10-29)

Nothing pushed, no PR, nothing posted. Both worktrees clean (`git status --porcelain` empty).

## Control plane: `feat/86bcm902w-content-usage-analytics` @ `de5fbe0` (base `b65f797`, 12 commits)

`git diff --stat b65f797...HEAD`:

```
 README.md                                          |   2 +
 contracts/control-plane.openapi.yaml               |  43 +-
 delivery/stories.json                              |   7 +
 internal/metric/README.md                          |  48 ++
 internal/metric/clickhouse/item_uses.go            | 124 +++++
 internal/metric/clickhouse/item_uses_test.go       | 260 +++++++++++
 internal/metric/clickhouse/store.go                |   8 +-
 internal/metric/content-usage-spike.md             | 126 +++++
 internal/metric/content_usage.go                   | 243 ++++++++++
 internal/metric/content_usage_spike_test.go        | 122 +++++
 internal/metric/content_usage_test.go              | 256 ++++++++++
 internal/web/content_usage.go                      | 212 +++++++++
 internal/web/content_usage_component_test.go       | 342 ++++++++++++++
 internal/web/content_usage_test.go                 | 519 +++++++++++++++++++++
 internal/web/handler.go                            |   3 +-
 .../web/testdata/content_usage_client_upload.json  |  33 ++
 internal/web/usage_ingest.go                       |  71 ++-
 packages/contracts/controlplane.gen.go             |  44 +-
 18 files changed, 2445 insertions(+), 18 deletions(-)
```

`git diff --name-only b65f797...HEAD -- .github/` → **empty** (no CI exception was granted; none needed). No `CLAUDE.md`, no Postgres migration.

Commits (all `Justin Issa`, Leorna identity; no AI attribution lines):
`3df10c3` spike write-up and support table (AC1) · `6a5bcc6` usage batch carries optional item uses · `85153ec` item-use validation and the report (pure) · `4b159d6` `item_uses_v1` table, writer, admin-only query · `e11fb61` ingest accepts item uses, validated before any write (AC5) · `7398536` admin-only page with per-tool measurability (AC3) · `f7b19c0` counts per pack and item, admin-only and tenant-isolated (AC2, AC4) · `eb6d905` docs and the story record · `e184d9b` pin the admin route guard and FINAL tenant-bound reads · `088af45` the company's own pack version wins over a newer shared seed (R1-1) · `7eb18e4` document that rule · `de5fbe0` each seed-rule subtest reports its own failure.

### Key hunks

Contract (`contracts/control-plane.openapi.yaml`): `UsageBatch` gains optional `itemUses` (max 1,000); `events` keeps `required` but loses `minItems: 1` so an item-only batch can send `"events": []`; new `ItemUse` (`id`, `tool`, `kind`, `name`, `timestamp`, optional `projectId`, `additionalProperties: false`, slug patterns on `tool` and `name`) and `ItemUseKind` (`skill|agent|prompt`).

Ingest (`internal/web/usage_ingest.go`, shared by `/v1/usage` and `/v1/client/usage`):
```go
if len(batch.Events)+len(itemUses) == 0 || len(batch.Events) > 1000 || len(itemUses) > 1000 { … 400 }
…
use := metric.ItemUse{ID: value.Id, Tool: value.Tool, Kind: string(value.Kind), Name: value.Name, Timestamp: value.Timestamp}
if !metric.ValidItemUse(use) { … 400 }          // item name + a (tool, kind) pair the support table can measure
…
// The two inserts are not one transaction: if the second fails the answer is
// 503 and a retry is safe, because stable IDs and FINAL reads count once.
```
Everything is validated before anything is written; tenant and user come from the session, never the body (`DisallowUnknownFields`).

Storage (`internal/metric/clickhouse/store.go`, additive):
```sql
CREATE TABLE IF NOT EXISTS item_uses_v1 (
 tenant_id UUID, user_id UUID, use_id String, occurred_at DateTime64(6,'UTC'),
 tool LowCardinality(String), kind LowCardinality(String), name String,
 team_id String DEFAULT 'unknown', project_id String DEFAULT 'unknown'
 ) ENGINE = ReplacingMergeTree ORDER BY (tenant_id,user_id,use_id)
```
Queries (`item_uses.go`) read `FROM item_uses_v1 FINAL WHERE tenant_id={tenant:UUID} AND occurred_at …` with `LIMIT 10001` (→ `ErrTooManyRows`), after `authorize(ctx, actor, true)` (admin only).

Support table (`internal/metric/content_usage.go`, machine-checked against the spike write-up by AC1):
```go
{"claude-code", "skill", true, …}, {"claude-code", "prompt", true, …}, {"claude-code", "agent", false, …},
{"codex", "skill", true, "Inferred: counted once per session when Codex reads the skill's SKILL.md."},
{"codex", "prompt", false, …}, {"codex", "agent", false, …},
{"cursor", "skill", false, …}, {"cursor", "prompt", false, …}, {"cursor", "agent", false, …},
```

Page (`internal/web/content_usage.go`, route `GET /admin/content-usage` behind `requireSession(requireAdmin(…))`): pack rows follow Justin's R1-1 rule "Company's own pack wins":
```go
if version.TenantID != tenant && version.TenantID != "" { continue }   // never another company's version
…
func preferPackVersion(candidate, current pack.PackVersion, tenant string) bool {
	if owned, currentOwned := candidate.TenantID == tenant, current.TenantID == tenant; owned != currentOwned {
		return owned
	}
	return candidate.CreatedAt.After(current.CreatedAt) || candidate.CreatedAt.Equal(current.CreatedAt) && candidate.Version > current.Version
}
```
Handler: one route line and a "Content usage" link in the admin nav.

## Client: `feat/86bcm902w-content-usage-analytics` @ `db3e6b0` (base `f105e27`, 6 commits)

`git diff --stat f105e27...HEAD`:

```
 README.md                                 |   42 +
 api/control-plane.openapi.yaml            |  236 ++++-
 api/controlplane.gen.go                   | 1417 ++++++++++++++++++++++++++---
 application/application.go                |   14 +-
 application/file_check.go                 |    5 +
 application/managed_items.go              |  131 +++
 application/managed_items_test.go         |  233 +++++
 cmd/import-content-usage/main.go          |  182 ++++
 cmd/import-content-usage/main_test.go     |  285 ++++++
 usage/items.go                            |  134 +++
 usage/items_claudecode.go                 |  146 +++
 usage/items_codex.go                      |   84 ++
 usage/items_real_test.go                  |  221 +++++
 usage/items_test.go                       |  346 +++++++
 usage/testdata/items/claude-session.jsonl |   15 +
 usage/testdata/items/codex-rollout.jsonl  |    9 +
 usage/testdata/items/upload.golden.json   |   33 +
 17 files changed, 3383 insertions(+), 150 deletions(-)
```

`git diff --name-only f105e27...HEAD -- .github/` → **empty**. No `CLAUDE.md` changed (the only tracked one is vendored `vendor/github.com/labstack/echo/v4/CLAUDE.md`, already on base).

Commits (all Leorna identity, no AI lines): `f7d106c` copy the control-plane contract and regenerate · `77bce26` detect uses of synced items in Claude Code and Codex transcripts (identifiers only) · `164014f` read what the last Sync installed, read-only · `1ab7f51` `import-content-usage` command · `7ff90bc` env-gated real Claude Code check · `db3e6b0` docs.

### Key hunks

- `api/control-plane.openapi.yaml` + `api/controlplane.gen.go`: a byte-identical copy of the control-plane spec (it also catches up the 901w/901y `/v1/packs…` operations the client snapshot was missing; generated code only).
- `application/managed_items.go`: `OpenReadOnly` opens the desktop database with a `file:…?mode=ro` URI and never migrates; `ManagedItems` reads what the newest successful Sync per tool installed (`run_logs`) so only those items can leave the machine (Q2 a).
- `usage/items*.go`: Claude Code detector (each `Skill` tool call and each genuine user-typed `/name` command, sessions whose `cwd` is the synced project); Codex detector (first read of `.agents/skills/<name>/SKILL.md` per session, all three call shapes). `ItemUse` carries only id, tool, kind, name, time, project. `usage.Detectable()` must equal the spike's measured rows.
- `cmd/import-content-usage/main.go`: explicit transcripts only; `-tool cursor` stops with "item use is not measurable for Cursor; nothing was sent"; `-server` HTTPS, or HTTP only to a literal loopback IP; session/CSRF from the environment, never printed; output is counts only.

## Gate results on these heads (from the verifier's and the auditor's logs; each opened and its EXIT line read)

Verifier 1 (`evidence/86bcm902w/verifier/`), control plane `de5fbe0`, 21:29–21:31 UTC, own `_test` DB and the story ClickHouse container, Go 1.27.3:

| Gate | Result |
| --- | --- |
| `make check` (golangci-lint 2.14.0, govulncheck v1.7.0 bound) | EXIT=0: race tests ok, lint 0 issues (both modules), govulncheck no called vulnerability, gitleaks no leaks (518 commits), library gate PASSED (0.8.0, 43 items), build |
| `bash ./scripts/test-module-add.sh` | EXIT=0 |
| gitleaks over `b65f797..HEAD` | EXIT=0, 12 commits, no leaks |
| `go test -json` over the DB packages + skip check | EXIT=0: 607 pass, 2 allowed skips (`TestEvidenceThirdPartyContentPage`, `TestProvisionManagedPostgresLive`), 319 of 319 declared top-level tests ran, no skip naming a test DB/ClickHouse variable |
| AC1–AC5 tests, one by one | each `--- PASS`, EXIT=0; each fails to build on base `b65f797` |

Verifier 1, client `db3e6b0`, 21:32–21:33 UTC:

| Gate | Result |
| --- | --- |
| `make check` (boundary, generate-api check, vet, `go test -race`, build) | EXIT=0 |
| `node --test scripts/*-ui.test.cjs` | EXIT=0, 39/39 |
| `make lint audit` (golangci-lint 2.14.0 first on PATH) | EXIT=0, 0 issues, no vulnerabilities |
| story supporting tests (usage, application, import command) | EXIT=0 |
| env-gated real Claude Code 2.1.312 test | EXIT=0 (sessions=3, prompt uses=1, skill uses=1) |
| `cmp` golden upload body; `cmp` OpenAPI | EXIT=0 both |

Blind auditor (`evidence/86bcm902w/auditor/`), control plane `de5fbe0` and client `db3e6b0`, 21:48–21:57 UTC: AC1–AC5 each PASS, EXIT=0 and fail on base; 26 clause mutants killed across AC1–AC5 plus 5 write-up data mutants; client supporting tests (15) PASS; real Claude Code test PASS; both `cmp` EXIT=0.

Referees (run by the main session): `ac-check.sh --reviews` → `ALL ACCEPTED: 5 of 5 ACs on de5fbe0`, `REVIEWS CLEAN: review-2 at de5fbe0`; client `review-check.sh` → `MOVE ON: review-2 at db3e6b0 is clean`.

Integration with GitHub `main` and open PR #102: `integration.md` (one record-file conflict, `delivery/stories.json`; trials build, vet and pass non-DB tests).
