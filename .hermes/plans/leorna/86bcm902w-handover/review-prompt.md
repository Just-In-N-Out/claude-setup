# Review prompt: 86bcm902w Content usage analytics (both repos)

Paste everything below the line into a fresh agent on Justin's Windows desktop (WSL Ubuntu). The branches are local only.

---

You are an independent reviewer for a Leorna story that spans two Go repositories. **Review only:** no commit, push, PR, merge or ClickUp change; restore anything you change; leave `deploy/local/` alone; never touch other stories' worktrees, branches, databases or containers; never run `git worktree prune`. **Don't trust anyone's summary or the shared memory, including this prompt's claims: check everything yourself.** Never print a password, token, server domain, tenant ID or email.

## What to review

| | Control plane | Client |
| --- | --- | --- |
| Repo (local) | `~/Leorna/leorna-control-plane` | `~/Leorna/leorna-client` |
| Branch | `feat/86bcm902w-content-usage-analytics` (not pushed) | `feat/86bcm902w-content-usage-analytics` (not pushed) |
| Range | `b65f797ff6cdc56a802dfaf417b0adec96463317..de5fbe0755a41e0528815ef3b72509aeadb20c3c` (12 commits) | `f105e27814b6efbec67059687963e722933acec2..db3e6b0f76652088c11fafa8c3c54509f62116f7` (6 commits) |

Get the code as **detached worktrees of your own** (never a checkout in the main folders, whose branch other sessions share, and never the story's own worktrees):
```sh
mkdir ~/.cache/86bcm902w-review3            # no -p; fail if it exists
git -C ~/Leorna/leorna-control-plane worktree add --detach ~/.cache/86bcm902w-review3/cp de5fbe0755a41e0528815ef3b72509aeadb20c3c
git -C ~/Leorna/leorna-client        worktree add --detach ~/.cache/86bcm902w-review3/client db3e6b0f76652088c11fafa8c3c54509f62116f7
```
At the end remove each with `git worktree remove --force <that exact path>`, then the folder by its literal path.

## The card (ClickUp, verbatim)

> **User Story.** As an admin, I want to know which skills, agents and prompts are actually used, so that I keep what works and retire what doesn't.
> **Context.** Needs a way to attribute usage to items; feasibility per tool to be confirmed (spike first).
> **Acceptance Criteria (test-backed)**
> - Given a spike, then we document per tool whether item usage can be detected from transcripts
> - Given supported tools, then item usage counts are shown per pack and item
> - Given unsupported tools, then the UI states that usage is not measurable there
>
> **Verify.** spike write-up + query tests
> **Definition of Done.** Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
> **Dependencies.** Enrich usage records with team, project and model (done: control-plane #83, client #18). **Repo:** both. **Size:** M.

Two more ACs were proposed in the plan and approved by Justin:
- AC4: only the tenant's admins can open the content usage page (a member gets 403, a signed-out visitor goes to sign-in); another tenant's admin sees none of this tenant's item uses; an upload is always counted for the signed-in user and tenant.
- AC5: an item use carries only id, tool, kind, name, time and an optional project; the server answers 400 and stores nothing for any other field, a name that is not an item name, an empty batch, more than 1,000 item uses, or a tool and kind the support table marks not measurable.

AC tests (all in the control plane): AC1 `TestContentUsageAC1SpikeMatchesSupportTable` (`./internal/metric/`), AC2 `TestContentUsageAC2CountsPerPackAndItemWithPostgres`, AC3 `TestContentUsageAC3NotMeasurableIsStated`, AC4 `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres`, AC5 `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres` (all `./internal/web/`). The client's tests are supporting receipts, tied to the control plane by a byte-identical golden upload body and a byte-identical OpenAPI copy.

## Decisions Justin already made (check they are implemented; don't re-argue them)

1. Item uses reach the server through an **explicit import command** (`import-content-usage`), not an automatic upload after Sync.
2. **Only items the last successful Sync installed** may leave the machine; personal skill/command names are never sent.
3. An item that sits in several packs **counts in each pack** (pack totals may overlap; the page says so).
4. Local ClickHouse tests use a **disposable container from CI's pinned image**.
5. After review 1: **"Company's own pack wins"**: per pack name the page shows the company's own newest version; the shared seed's newest version only when the company has none of that name; another company's version never counts.

## Previous rounds (verify each claim)

- Review 1 (control plane `e184d9b`): **R1-1 P2** a newer shipped seed version of "Leorna starter pack" replaced the company's own edited pack on the page. Claimed fix: `088af45` (`contentPacks` skips other companies' versions; `preferPackVersion` prefers the company's own, then newer `CreatedAt`, then the larger version string), docs `7eb18e4`, test fix `de5fbe0`; new tests `TestContentUsageCompanyPackWinsOverSharedSeedWithPostgres` and `TestContentUsageChoosesTheCompanyVersionOfEachPack`. R1-2 and R1-3 (P3) left as follow-ups.
- Review 1 (client `db3e6b0`): clean of P0–P2; R1-4, R1-5 (P3).
- Review 2 (control plane `de5fbe0`, client `db3e6b0`): clean of P0–P2 in both; R2-1 … R2-4 (P3).
- Then an independent verifier and a blind auditor each accepted AC1–AC5 on `de5fbe0`.

Known P3s already recorded (don't re-report unless you find a new fact or a higher severity): no runtime test of an item use with a `projectId` (a mutant refusing every `projectId` survives); a batch without `events` is accepted when it has item uses although the contract says required; the page filter's "only from and to, each once" rule and the equal-`CreatedAt` tie-break each survive a mutant; Codex counts a repository's own `.agents/skills/<name>/SKILL.md` too; the client `-server` path rule and the symlink folder match are untested; `ManagedItems` isn't scoped to a company or server; the real Claude Code test pins only typed commands.

## Environment (control plane)

Host tools: `~/.local/leorna-toolchain/go/bin` (Go 1.27.3) and `~/.local/leorna-toolchain/bin` (golangci-lint 2.14.0, govulncheck v1.7.0, CI's pins). **Keep `/usr/local/bin` on PATH**: gitleaks lives only there, and without it six item-editor tests fail with 503 "secret scanner unavailable" (a false failure).

```sh
export GOTOOLCHAIN=local PATH="$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:/usr/local/bin:/usr/bin:/bin"
mkdir ~/.cache/86bcm902w-review3/tmp && export TMPDIR=~/.cache/86bcm902w-review3/tmp
PGPW=$(docker inspect leorna-test-pg --format '{{range .Config.Env}}{{println .}}{{end}}' | sed -n 's/^POSTGRES_PASSWORD=//p'); [ -n "$PGPW" ] || { echo "empty leorna-test-pg password"; exit 1; }
PGPORT=$(docker port leorna-test-pg 5432 | sed 's/.*://')
docker exec leorna-test-pg psql -U leorna -d leorna_test -c 'CREATE DATABASE leorna_86bcm902w_review3_test'
export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:${PGPORT}/leorna_86bcm902w_review3_test?sslmode=disable"
# your own ClickHouse from CI's pinned image (the story's container was removed at hand-over)
docker run -d --name leorna-review3-ch-86bcm902w -p 127.0.0.1:18124:8123 -e CLICKHOUSE_DB=leorna_metrics -e CLICKHOUSE_USER=leorna_test -e CLICKHOUSE_PASSWORD=local-integration-only \
  mirror.gcr.io/clickhouse/clickhouse-server:25.8@sha256:0152dd511befe6a2c2ef53e930726179669b08116da78500b37c51c96ff5ee77
until curl -s http://127.0.0.1:18124/ping | grep -q Ok; do sleep 1; done
export LEORNA_TEST_CLICKHOUSE_URL=http://127.0.0.1:18124
```
(The ClickHouse credentials are CI's public test values.) At the end: `docker rm -f -v leorna-review3-ch-86bcm902w` and drop your `_test` database. Never touch `leorna_86bcm902w_builder_test` or any other database.

## Commands to run (keep the real output)

Control plane, in `~/.cache/86bcm902w-review3/cp`:
1. `GOLANGCI_LINT="$HOME/.local/leorna-toolchain/bin/golangci-lint" GOVULNCHECK="$HOME/.local/leorna-toolchain/bin/govulncheck" make check` → exit 0 (includes contracts-check, lint, govulncheck, gitleaks, library gate).
2. `bash ./scripts/test-module-add.sh` → exit 0.
3. `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/metric/... > stream.json`, read per test: no failure; the only allowed skips are `TestEvidenceThirdPartyContentPage` ("LEORNA_EVIDENCE_DIR is not set") and `TestProvisionManagedPostgresLive` ("SCW_LIVE=1 not set"); any skip naming `LEORNA_TEST_DATABASE_URL` or `LEORNA_TEST_CLICKHOUSE_URL` is a failed check. Don't judge skips from `-v` text.
4. Each AC test alone: `go test -v -count=1 -run '^<test>$' <package>`; no `--- SKIP`.
5. ClickHouse query tests: `go test -v -count=1 -run 'ItemUs' ./internal/metric/clickhouse/`.
6. The tests above on base `b65f797` in a separate detached worktree with its own `_test` database (copy the head's test files in): they must fail.
7. `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` → OK.

Client, in `~/.cache/86bcm902w-review3/client` (`export TMPDIR=$(cd ~/.cache/86bcm902w-review3/tmp && pwd -P)`):
1. `make check`; `node --test scripts/*-ui.test.cjs`; `golangci-lint --version` (2.14.0, first on PATH) then `make lint audit`.
2. `go test -mod=vendor -v -count=1 ./usage ./application ./cmd/import-content-usage`.
3. Optional real-tool check: `LEORNA_TEST_CLAUDE_BIN=$(readlink -f ~/.local/bin/claude) go test -mod=vendor -v -count=1 -run '^TestRealClaudeCodeTranscriptItemUses$' ./usage/` (isolated home; don't point it at your real `~/.claude`).

Cross-repo: `cmp client/usage/testdata/items/upload.golden.json cp/internal/web/testdata/content_usage_client_upload.json` and `cmp client/api/control-plane.openapi.yaml cp/contracts/control-plane.openapi.yaml` → both exit 0.

## Mutations to try (each must still compile; overlay or a scratch copy, never the story worktrees; a build failure is not a kill)

- `internal/web/usage_ingest.go`: skip `metric.ValidItemUse` → AC5 must fail. Write events before validating item uses → AC5 must see a partial write.
- `internal/metric/clickhouse/item_uses.go`: drop `FINAL` → must fail. **Trap:** ClickHouse background merges can collapse duplicates before a query, so the replay assertion alone can pass; `TestItemUsageQueriesReadFinalRowsOfTheActorsTenant` checks the query text on the wire.
- Same file: drop `tenant_id={tenant:UUID}` → AC4 `other_tenant_admin_sees_none_of_these_uses`. Call `authorize(ctx, actor, false)` in `QueryItemUsage` → AC4's store subtest.
- `internal/web/handler.go`: remove `requireAdmin` from `/admin/content-usage` → AC4 `member_gets_403`. **Trap:** the store's own admin check also answers 403, so the test must check the route guard's `ADMIN_REQUIRED`.
- `internal/metric/content_usage.go`: flip (codex, prompt) to measured → AC1. Change one Basis word → AC1.
- `internal/web/content_usage.go`: render a number in an unmeasured cell → AC3; restore the old "newest version regardless of owner" rule → the two R1-1 tests.
- Client: drop `managed.Has` in the Claude Code detector → `TestContentUsageDetectsOnlySyncedItemUses`; open the desktop database without `mode=ro` → `TestOpenReadOnlyNeverMigrates`; send a transcript field in `ItemUse` → `TestItemUsesCarryNoTranscriptText`.

## Also check

- Security and tenant isolation: tenant and user come only from the session; the body can't name them; every query is tenant-bound and admin-only; the page shows no store error text; ClickHouse queries use bound parameters; no auth bypass or dev-login change.
- Privacy: no transcript text, command arguments, paths, folder names, personal item names or agent names leave the client; nothing is sent when nothing matches; output is counts only; the desktop database is never written.
- The OpenAPI change (`itemUses`, `ItemUse`, `events` may be empty) is the same in both repos and regenerated (`make check`'s contracts check; client `generate-api.sh check`).
- Docs claims are true as written: `internal/metric/content-usage-spike.md`, `internal/metric/README.md` "Content usage" section, the root README sentence, the client README "Content usage import" section (flags, error texts, what is sent).
- `delivery/stories.json`: the 86bcm902w entry is last and its PR lists are empty (no PR exists yet); every earlier entry unchanged.
- Commit authorship: every commit `Justin Issa` with the Leorna address; no `Co-Authored-By`/"Generated with"/AI lines; no `.github/` change; no `CLAUDE.md` added.
- Merge risk: control-plane GitHub `main` moved to `e2254e0` (#101 quick start); `git merge-tree --write-tree --name-only de5fbe0 origin/main` should show only `delivery/stories.json`. Open PR #102 (starter packs) should also conflict only there. No Postgres migration in this story (main has 24 and 25, #102 adds 26). Client `main` is the base.

## Report format

1. One-line verdict: **Ready**, or **Not ready** with the blocking items.
2. A table per AC (AC1–AC5) and per DoD line: evidence (test, command, real output excerpt), result.
3. The real output of every command above (exit codes; the skip-check counts).
4. Mutation results: mutant, file, expected test, KILLED/SURVIVED (with the failing line).
5. Issues: each labelled introduced or pre-existing, severity P0–P3, file:line, a concrete scenario, and a suggested fix.
6. What you couldn't run and why.
