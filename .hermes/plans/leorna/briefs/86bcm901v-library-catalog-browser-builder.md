# BUILDER — 86bcm901v Library catalog browser

## Assignment and permission

Implement the **approved** server-rendered, read-only admin library catalog in the control plane, following the complete plan without a research restart or redesign. Justin approved 2026-10-22 16:04 EDT with **go**, after explicitly selecting **1A 2A 3A**. You are the **Sol 6.1 xhigh BUILDER**, a native child of this conversation. Finish at `ready-for-review` only with genuine required build checks; no new independent chat, CLI agent, child or process-agent spawn.

### Justin's words
> go

Recorded form answers:
1. A — Safe formatted content preview; config/MCP shown as escaped code
2. A — All saved versions, each clearly labeled
3. A — Add pinned goldmark Markdown library, with raw HTML and active links/images disabled

## Start here — required fresh skills and project context

First freshly load `leorna`, then `engineering-best-practices`, then `test-driven-development`, `mutation-testing-discipline`, `ux-frontend-workbench`, `frontend-testing-workflow`, `security-best-practices`, `multi-tenant-auth-management`, and `concurrent-state-validation`. Load `git-commit-rules` before any commit. Load `systematic-debugging` for unexpected failures. Read relevant references and the Leorna Step 1 notes/AGENTS for your repo; the existing complete plan replaces broad design research, not project rules. Follow BUILDER role, not Leorna's default planner dispatch. No child/process spawning.

Read the **complete approved plan**: `/Users/justin/.hermes/plans/leorna/86bcm901v-library-catalog-browser.md`. It contains concrete interfaces, proposed source/test code, every AC, RED/GREEN commands, performance protocol, screenshots/manual-demo points, risks and final Docs & records task. Read `clickup-evidence.md` from the shared Leorna notes. Get ClickUp card `86bcm901v` live read-only (including Verify/DoD); planner live prerequisite `86bcm9018` was complete. A changed material contract must be reported, not silently redesigned. Do not fetch the entire PI or rewrite other stories' notes.

Audit applicable skill loop sections and return `skills_loaded[]` and `defect_loop_skills[]`. Plan audit is `[]`, not permission to skip a newly applicable loop. Both fresh full reviews remain mandatory regardless.

## Verified work area and ownership

Parent created and read back a clean isolated worktree:
- Exact workdir for **every terminal command**: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-library-catalog-browser`.
- Branch **`feat/86bcm901v-library-catalog-browser`**, initial HEAD/base **`0da9f5443a2a49b157cf24b5d30301345d371d3e`** from freshly fetched `origin/main`; local main equaled that base at admission.
- The shared checkout's pre-existing `.claude/` and `deploy/local/` are not yours. Do not switch/reset/stash/clean shared main or other worktrees. Parent owns shared refs and integration; you own this worktree's Git index and scoped commits while assigned.
- Identity must remain `Justin Issa <justin@leorna.com>` via includeIf; never override or add AI attribution.
- Admission: `/Users/justin/.hermes/plans/leorna/evidence/86bcm901v/planning/builder-admission.json`.

Permitted source/test/module paths:
- `cmd/control-plane/main.go`
- `go.mod`
- `go.sum`
- `internal/library/catalog.go`
- `internal/library/catalog_test.go`
- `internal/store/postgres/library_catalog.go`
- `internal/store/postgres/library_catalog_test.go`
- `internal/web/handler.go`
- `internal/web/library.go`
- `internal/web/library_browser_test.go`
- `internal/web/library_performance_test.go`
- `internal/web/library_preview.go`
- `internal/web/library_preview_test.go`
- `internal/web/library_test.go`

This is an explicit narrower writer boundary for the parallel build. **Do not edit `internal/library/README.md` or `delivery/stories.json` yet.** Return exact proposed additions as private evidence drafts; the coordinated finisher owns that final docs task after overlap reconciliation. Do not modify parent-owned board, handoff, shared notes, other plans or this approval plan; return proposed record updates instead. Request admission for a genuinely necessary additional path rather than broadening silently.

Other-session owners (absence from your local agent list does not mean dead):
- 86bcm9016-prompt-kind — `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9016-prompt-kind`, observed HEAD `5a3b5c6ed26ef983d46f3e87e6c759580dbfda09`; source overlap = none, shared records = delivery/stories.json, internal/library/README.md.
- 86bcm901u-content-quality-gate — `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-content-quality-gate`, observed HEAD `3317d09b91a430368d6a1615a2abc77bb140dbca`; source overlap = none, shared records = internal/library/README.md.

At parent launch, prompt-kind is building; quality-gate has a Sol full reviewer and separately held Opus reviewer. Preserve both and their client worktrees/review snapshots. Our CI exception is **none**; quality-gate's CI exception does not transfer. New tests go in our new files, not sibling tests. Follow recommended later integration order prompt-kind → quality-gate → catalog, with combined-head gates after integration; no integration or merge is authorized in this builder role. Whoever integrates later preserves both features and revalidates the actual combined candidate.

## Acceptance and safety

1. AC1: admin library kind/category/tag/supported-tool filters plus literal text search, combinable with stable pagination and clear empty/error states.
2. AC2: item description, example, immutable version, supported tools and safely rendered preview. Content preview only; no per-tool conversion, tool execution or network activity. Config/MCP is escaped source. goldmark v1.7.17 raw HTML disabled, links/autolinks/images inert; run normal dependency provenance/license/vulnerability gates.
3. AC3: 200+ real items, strict **every measured sample <300 ms server time** under the approved measurement contract; seed 240 and keep actual timing logs, not a screenshot substitute or relaxed p95.
4. Current persisted admin authorization on routes and direct store reads; mismatch/revoked role/member/absent actor fail closed. Library content is global/shared across tenants by design; tenant-owned packs/user/audit data must never leak.
5. No client, migration, OpenAPI/generated contract, loader, auth/session implementation, existing packs source/tests, content or workflow changes. Never add dev login/auth bypass. If a plan interface is wrong or a material decision is missing, preserve work and stop with the concrete mismatch/options for the authorized planner; do not redesign on your own.

## TDD, actual checks and resource coordination

Execute the plan's vertical slices RED → unchanged GREEN → regression family; undefined-symbol/setup failures are not behavioral RED. Run named real-Postgres tests verbose and confirm they did not skip. Apply focused compile-valid guard mutations and restore all temporary mutations. Load Git commit rules first, stage only explicit owned paths, and commit green slices on the assigned branch; never `git add .`.

Required control-plane gates: **make check** and **bash ./scripts/test-module-add.sh**, exact commands/heads/output retained. Check selected GNU `realpath --relative-to` capability first; use installed coreutils gnubin in task-only PATH if needed, no global config/unrelated code repair. Obtain the existing approved `leorna-test-pg` setup without echoing secrets. Shared DB/CPU/browser capacity is not isolated by worktrees: use unique schema/profile/output/ports for owned focused tests; check actual sibling activity immediately before shared-reset/full store gates or latency measurement. Do not race a proven sibling shared-schema reset or performance run. Continue independent work; if a concrete owner/resource conflict cannot be resolved safely, return the exact waiting owner/release condition rather than inventing a global reservation or bypassing the test.

No application test has run for this story yet. Do not inherit a passed label from planner static snippets, sibling gates or historical output. Preserve first failures, distinguish baseline/environment from introduced regression, and never weaken assertions/gates. At most two focused repair/recheck cycles on one unexpected failing approach, then narrow or return evidence-backed blocker. If a project gate cannot be made green in scope, return stopped/blocked with receipts, not ready-for-review.

Disk observation at admission: ~19 GiB free, mutable. Recheck before heavy output; below ~1.5 GiB commit what safely passes and stop. Never delete unrelated files, caches, worktrees or containers to create space.

## Evidence task E — collect during work, not at hand-over

Create a fresh uniquely named run directory **atomically** under `/Users/justin/.hermes/plans/leorna/evidence/86bcm901v/` (e.g. build-<UTC stamp>); preserve earlier planning/provider archives. Keep inventory/checkpoints/real logs here, outside repo. Before your **first source edit**, get meaningful real untouched admin/Packs before pictures using the authorized local test fixture/browser; if unavailable record why, never mock or reconstruct a before later.

Capture at execution points from the plan:
- AC1 GREEN/manual filter journey: `ac1-library-filters.png`, with real selected combined filters/search and result.
- AC2 detail journey: `ac2-library-detail.png`, description/example/version/tools/rendered body; inert malicious-content proof and narrow/keyboard states.
- AC3 real 240-item run: `ac3-library-240-items.png` **plus** `performance-<sha7>.txt` with exact actual samples.
- Final candidate: `gates-<sha7>.txt`, `mutations-<sha7>.txt`, exact command/head/exit and non-skipped PostgreSQL tests.
- Actual rendered browser + manual demo from approved fixture: dated `manual-demo-<sha7>.md` and actual photo, recording actions/results/omissions. A test-log image is not a live UI photo; automated HTTP alone is not manual Verify.

Use the plan's local test-only TLS fixture; no permission to modify real `~/.claude` or `~/.codex`, provision/deploy an external server, probe Christian/Yan servers, or delete anything. A real installed-server/demo needing new access is **NOT VERIFIED with reason**, not inferred authorization. Visually inspect photos and redact/crop URL bars, server domains, tenant IDs, tokens and emails before any outgoing use. No ClickUp uploads/comments/status changes; closing draft only, actual post waits for Justin's **post**.

## Pace, stopping point and return

Forecast already shown: 4–7h build, medium-low confidence, plus review/fixes; advisory, not a hard expiry or license to explore. Record actual start, use useful 5–15min slices, read clock at least every 15min/material failure and retain original/latest remaining forecast in your own evidence handoff. Prioritize one demonstrable approved behavior and write progress early; do not re-research the whole project or replace the approved design. If steps/context run low, commit green owned work, preserve dirty/unverified remainder, and return `stopped` / `out of steps` with exact HEAD/worktree, next unmet criterion and artifact paths. Do not spawn a successor yourself.

At true build acceptance return `ready-for-review` with exact branch/head, full changed paths/diff stat, gate/mutation/manual/performance receipts, evidence inventory and `shots[]`, rulings/deviations, actual skills/loop flags, and private README/delivery drafts. Leave all application source committed and clean, temporary mutations restored. Docs & records remains a coordinated finisher task; don't claim it finished. Return missing proof explicitly, not a false complete milestone.

Parent then assigns **two fresh independent full reviewers, Opus 5.5 xhigh + Sol 6.1 xhigh**. Both results precede Sol finisher. Applicable Agent Defect Loop uses a fresh independent Opus verifier; unavailable Opus requires Justin's choice. Never self-review or skip this pipeline. No push, PR, main merge, deployment, cloud provisioning, independent chat, evidence posting or card closure authorized.
