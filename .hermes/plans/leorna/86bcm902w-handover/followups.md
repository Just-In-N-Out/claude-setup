# 86bcm902w follow-ups (consolidated, de-duplicated)

Sources: `evidence/86bcm902w/follow-ups.md` (every P3 from the reviews, verifier and auditor), the 86bcm902w entries in `found-else.md`, the plan's "Follow-ups" and "Risks", plus two receipts the finisher found unfiled (marked "finisher"). None blocks the PRs; no P0–P2 is open.

## Control plane

| # | Severity | Where | Follow-up | Source |
| --- | --- | --- | --- | --- |
| 1 | P3 | `internal/web/usage_ingest.go:132-139` | No test sends an item use with a `projectId` at runtime: mutants storing the raw client `projectId`, dropping attribution, or refusing any `projectId` with 400 all survive AC5 and the whole web/metric suites, while the client import sends `-project` by default. The golden body has no `projectId`. Model test: `evidence/86bcm902w/auditor/probe-ac5-project_test.go.txt`. | review 1 R1-2 + blind auditor (merged) |
| 2 | P3 | `internal/web/usage_ingest.go:78-87` | A batch without the `events` key (or `"events": null`) is accepted when it has item uses, although the contract keeps `required: [events]`. | review 1 R1-3 |
| 3 | P3 | `internal/web/content_usage.go:19-24` | The page filter's "only from and to, each once" rule is masked in its test (mutant V7 survives; AC3's `?tool=codex` case answers 400 only through the fake store's `ErrTooManyRows`). | review 2 R2-1 |
| 4 | P3 | `internal/web/content_usage.go` (`preferPackVersion`) | The equal-`CreatedAt` tie-break (larger version string wins) has no test (verifier V4, review 2 V8). Cosmetic: review 2 notes two versions of one owner never share a creation time in practice, and History's order is deterministic anyway. | verifier 1 V1-P3-a, review 2 |
| 5 | P3 | `internal/web/content_usage.go` (`contentPacks`) | The page loads each pack's latest version in full (`Preview`) to list its items; fine for today's pack sizes (≤500 items). Add a lighter metadata query if the page slows. | plan Risks |
| 6 | feature | page | CSV export for content usage; team and project filters. | plan Follow-ups |

## Client

| # | Severity | Where | Follow-up | Source |
| --- | --- | --- | --- | --- |
| 7 | P3 | `usage/items_codex.go:16` | The Codex detector counts a read of any `.agents/skills/<name>/SKILL.md`, not only `$HOME/.agents/skills`; Codex 0.165 also loads repository-scoped `.agents/skills`, so a repository's own skill with a synced item's name is counted as that item. Fix: require the user's home root, plus a fixture that must count 0; or record the limit in the spike write-up. | review 1 R1-5 |
| 8 | P3 | `cmd/import-content-usage/main.go:140` | The `-server` path rule (only an empty path or `/`, builder ruling 8) has no test (mutant K6 survives). Same host either way, so only an untested restriction. | review 1 R1-4 |
| 9 | P3 | `usage/items_claudecode.go:143-145` | `sameFolder`'s symlink fallback has no test (mutant V10 survives): every fixture resolves its temp folder first. | review 2 R2-2 |
| 10 | P3 | `application/managed_items.go:78` | `ManagedItems` takes each tool's newest successful Sync from `run_logs`, which records no company or server: after switching company, the earlier company's Codex Sync still marks its skills as managed until a Codex Sync for the new company runs. Scope Sync baselines before "Upload usage automatically after Sync" reuses this. | review 2 R2-3 |
| 11 | P3 | `usage/items_real_test.go:112` | The env-gated real Claude Code test pins only typed `/commands`; a model-driven `Skill` call has no real-binary check (review 2's probe counts exactly 1 on 2.1.312). | review 2 R2-4 |
| 12 | P3 | `usage/items_claudecode.go`, `usage/items_codex.go` | Two detector guards survive a mutant in review 1's receipt but were never filed as findings: K13 "Claude Code lines without a uuid are skipped" and K14 "a Codex use needs the session ID (no session_meta, no use)" (`client/review-1/mutants-review1-client-db3e6b0.txt`, 15 tests passed under each). | finisher (unfiled receipt) |
| 13 | feature | client | Automatic upload after Sync ("Upload usage automatically after Sync", Yan, To Do) should call these detectors and `ManagedItems` rather than add parallel ones; it also gives `/v1/client/usage` its first client caller (today both importers authenticate with the admin console's session and CSRF values from the environment, so engineers can't realistically run imports yet). | plan Follow-ups + planner found-else |

## Both repos

| # | Severity | Follow-up | Source |
| --- | --- | --- | --- |
| 14 | P3 | A CI check that the client's `api/control-plane.openapi.yaml` equals the control plane's `contracts/control-plane.openapi.yaml`. Before this story the client copy was 193 lines behind; this story's client commit `f7d106c` brought it level, but nothing stops it drifting again. Needs its own story (no CI changes inside a story). | plan Follow-ups + planner found-else |
| 15 | feature | Cursor: check on a real store whether `toolFormerData` parameters name a skill file or command; flip the support rows only with a test. | plan Follow-ups |
| 16 | feature | Agents: once a transformer installs agents (Claude Code `.claude/agents/`, Codex agents), count `Agent`/`Task` `subagent_type` and Codex `spawn_agent.agent_type`, and flip those rows. | plan Follow-ups |
| 17 | process | Re-verify each detector when Claude Code or Codex ships a new transcript format (undocumented formats; detection can break silently). | plan Risks |

## Not PR follow-ups (local housekeeping and process; for the main session)

- Local: the builder's Postgres DB `leorna_86bcm902w_builder_test` stays until the story is merged (the brief kept it; the plan's T12.3 had said the finisher drops it). Drop it after merge.
- Local: removing `leorna-test-ch-86bcm902w` with `docker rm -f` left its anonymous data volume `451637eaa73d…` (the ClickHouse image declares `VOLUME /var/lib/clickhouse`). Untouched per the brief; `docker volume rm` it when convenient.
- Info: the verifier's client mutant CV4 (drop the `response_item` record filter in the Codex detector) survived; the payload-type switch below it already skips every other record type, so it looks equivalent. Recorded no finding.
- Process (already recorded in `found-else.md`): the plan's "Common environment" PATH lacked `/usr/local/bin`, where gitleaks lives (6 false item-editor failures in review 2's first run); `review-check.sh` takes one `--repo`, so two-repo stories need one review record and one referee run per repo.
