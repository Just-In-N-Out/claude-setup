# 86bcm902w follow-ups (consolidated, de-duplicated; refreshed for the PR heads)

Heads: control plane PR #103 at `b4acb2f`, client PR #23 at `cf3df7f` (both open, not merged; read 2026-10-30 01:05 UTC). The numbers below are the ones posted in the ClickUp closing comment (2026-10-30 01:11 UTC). ClickUp's plain-text read-back drops the list numbers; the posted markdown has them.

Sources: `evidence/86bcm902w/follow-ups.md` (every P3 from the reviews, verifiers and auditors, through review 4 at `b4acb2f`, client review 3 at `cf3df7f` and the PR auditor), the 86bcm902w entries in `found-else.md`, the plan's "Follow-ups" and "Risks", the two PR bodies' Follow-ups sections, plus two receipts the first finisher found unfiled (marked "finisher"). None blocks the PRs; no P0–P2 is open.

## Control plane

| # | Severity | Where | Follow-up | Source | PR #103 follow-up |
| --- | --- | --- | --- | --- | --- |
| 1 | P3 | `internal/web/usage_ingest.go:132-139` | No test sends an item use with a `projectId` at runtime: mutants storing the raw client `projectId`, dropping attribution, or refusing any `projectId` with 400 all survive AC5 and the whole web/metric suites, while the client import sends `-project` by default. Model test: `evidence/86bcm902w/auditor/probe-ac5-project_test.go.txt`. | review 1 R1-2 + blind auditor | 1 |
| 2 | P3 | `internal/web/usage_ingest.go:78-87` | A batch without the `events` key (or `"events": null`) is accepted when it has item uses, although the contract keeps `required: [events]`. | review 1 R1-3 | 2 |
| 3 | P3 | `internal/web/content_usage.go` | Test strength: the page filter's "only from and to, each once" rule (mutant V7 survived review 2) and the equal-`CreatedAt` tie-break in `preferPackVersion` (verifier 1 V4) each survive a mutant. | review 2 R2-1, verifier 1 V1-P3-a | 3 |
| 4 | P3 | `internal/web/content_usage.go` (`contentPacks`) | The page loads each pack's latest version in full (`Preview`) to list its items; add a lighter metadata query if the page slows. | plan Risks | 6 |
| 5 | feature | page | CSV export for content usage; team and project filters. | plan Follow-ups | 6 |
| 6 | P3 | `internal/web/handler.go:782` | No test pins the admin nav's "Content usage" link (mutant M1 passes all `internal/web` tests). | review 3 R3-3 | 7 |
| 7 | P3 | `internal/web/content_usage.go:84-93` | A release line's newest version is picked by `created_at`, while the role-based starter packs catalog (PR #102) uses `starter_number`; they disagree only if a later release's row has an earlier `created_at` (two new binaries racing before the advisory lock, or a seed rollback on a database a newer binary created). Optional fix: return `starter_number` from `ListByTenant` and order starter lines by it. | review 4 R4-1 | Assumptions (pack rows) |
| 8 | P3 | `internal/pack/version_service.go:106` | The History comment still says "the tenant's versions plus the seed base"; it also returns the role starter packs (docs only). | review 4 R4-2 | — |
| 9 | P3 | `internal/web/content_usage_test.go` (AC2) | AC2's replay check depends on timing: mutant K03 (FINAL dropped from the per-tool item-use query) passed AC2 in 2 of 4 runs because ClickHouse merges duplicate parts within milliseconds; `TestItemUsageQueryCountsReplayPeriodAndTenantWithClickHouse` kills it every time. Optional: make AC2's replay read deterministic. | PR auditor at `b4acb2f` | — |
| 10 | decision | page | Every shared role starter pack shows as a pack row whether or not a team has it; a company that ran quick start never sees a newer shared starter it later assigns. Justin 2026-10-29: "Keep your rule"; revisit if pack rows should follow assignments. | review 3 R3-2 | 7 |

## Client

| # | Severity | Where | Follow-up | Source | PR #23 follow-up |
| --- | --- | --- | --- | --- | --- |
| 11 | P3 | `usage/items_codex.go:16` | The Codex detector counts a read of any `.agents/skills/<name>/SKILL.md`, not only `$HOME/.agents/skills`; Codex 0.165 also loads repository-scoped `.agents/skills`, so a repository's own skill with a synced item's name is counted as that item. | review 1 R1-5 | 1 |
| 12 | P3 | `cmd/import-content-usage/main.go:140` | The `-server` path rule (only an empty path or `/`) has no test (mutant K6 survives). | review 1 R1-4 | 2 |
| 13 | P3 | `application/managed_items.go:78` | `ManagedItems` takes each tool's newest successful Sync from `run_logs`, which records no company or server: after switching company, the earlier company's Codex Sync still marks its skills as managed until a Codex Sync for the new company runs. Scope Sync baselines before "Upload usage automatically after Sync" reuses this. | review 2 R2-3 | 3 |
| 14 | P3 | `usage/items_real_test.go:112` | The env-gated real Claude Code test pins only typed `/commands`; a model-driven `Skill` call has no real-binary check. | review 2 R2-4 | 4 |
| 15 | P3 | `usage/items_claudecode.go`, `usage/items_codex.go` | Test strength: detector guards K13 "Claude Code lines without a uuid are skipped" and K14 "a Codex use needs the session ID" survive a mutant (`client/review-1/mutants-review1-client-db3e6b0.txt`); `sameFolder`'s symlink fallback (review 2 R2-2, mutant V10) is now pinned in the Windows client job by `TestStoredClaudeRootMatchesTranscriptFolderForms`, but on Linux only with a symlinked `TMPDIR`. | finisher (unfiled receipt) + review 2 R2-2 | 2, 5 |
| 16 | P3 | `usage/items_claudecode.go:136-146` | `sameFolder` misses Windows folder aliases beyond 8.3/case/slashes: junctions (Go ≥1.23 winsymlink), UNC aliases (`\\localhost\C$`, `\\wsl$` vs `\\wsl.localhost`), `\\?\` prefixes; such a session counts 0 (under-count only). Optional fix: an `os.SameFile` fallback; the new test's comment overclaims. Main's `chat.SameDir` has the same limit. | client review 3 R3-1 | — |
| 17 | decision | `usage/items_claudecode.go:74` | Claude Code running inside WSL with the WSL project chosen in the Windows desktop app: stored root `\\wsl.localhost\<distro>\…` vs transcript cwd `/home/<u>/<proj>` never match, so the import counts 0. Justin's call: document native-only in the README, or map `\\wsl.localhost` roots to their Linux path. | client review 3 R3-2 | — |
| 18 | feature | client | Automatic upload after Sync (the "Upload usage automatically after Sync" card, To Do) should call these detectors and `ManagedItems` rather than add parallel ones; it also gives `/v1/client/usage` its first client caller (today the importers authenticate with the admin console's session and CSRF values from the environment). | plan Follow-ups + planner found-else | Assumptions |

## Both repos

| # | Severity | Follow-up | Source | PR follow-up |
| --- | --- | --- | --- | --- |
| 19 | P3 | A CI check that the client's `api/control-plane.openapi.yaml` equals the control plane's `contracts/control-plane.openapi.yaml` (byte-equal today, verified by `cmp` on `cf3df7f`/`b4acb2f`; nothing stops drift). Needs its own story (no CI changes inside a story). | plan Follow-ups + planner found-else | #103 5 |
| 20 | feature | Cursor: check on a real store whether `toolFormerData` parameters name a skill file or command; flip the support rows only with a test. | plan Follow-ups | #103 4 |
| 21 | feature | Agents: once a transformer installs agents, count Claude Code `Agent`/`Task` `subagent_type` and Codex `spawn_agent.agent_type`, and flip those rows. | plan Follow-ups | #103 4 |
| 22 | process | Re-verify each detector when Claude Code or Codex ships a new transcript format (undocumented formats; detection can break silently). | plan Risks | — |

## Not PR follow-ups (local housekeeping and process; for the main session)

- Local: the ClickHouse test container `leorna-test-ch-86bcm902w` and its own anonymous volume (`25b69beb…`) were removed by the post finisher at 2026-10-30 01:13 UTC (`docker rm -f -v`, exit 0). The pinned image `clickhouse-server@sha256:0152dd51…` stays.
- Local: an older anonymous volume `451637eaa73d…` is still there, left from an earlier instance of that container removed without `-v` (the image declares `VOLUME /var/lib/clickhouse`). Untouched per the brief; `docker volume rm` it when convenient.
- Local: the builder's Postgres DB `leorna_86bcm902w_builder_test` stays until the story is merged (the brief kept it). Drop it after merge.
- Stale PR text (Justin's call whether to edit; the post finisher changed nothing): both live PR bodies still say a fresh verifier and auditor run "next" (they have since run: ALL ACCEPTED 5 of 5 on `b4acb2f`), the #103 Test Plan names the client at `db3e6b0` (now `cf3df7f`), and the #23 Test Plan names the control plane at `fabbec0` (now `b4acb2f`).
- Info: the verifier's client mutant CV4 (drop the `response_item` record filter in the Codex detector) survived; the payload-type switch below it already skips every other record type, so it looks equivalent. No finding recorded.
- Process (already in `found-else.md`): the plan's "Common environment" PATH lacked `/usr/local/bin`, where gitleaks lives; `review-check.sh` takes one `--repo`, so two-repo stories need one review record and one referee run per repo.
