# FIXER 1 — 86bcm927y integrations catalog tiles
Role: fresh pipeline_fixer, Astra xhigh; Full pipeline. Read this brief and follow exactly.
Worktree: /home/justin/Leorna/86bcm927y-integrations-catalog-tiles
Branch: feat/86bcm927y-integrations-catalog-tiles
Base: 3aa979df41568c9039007f66d7f32193e66a8533
Starting HEAD: 381f870345064c533d2c3f802f6cdddac62aef7a
Approved immutable plan: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/plan-approved.md
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Own evidence: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/fixer-1/
Review inputs: review-1/review.json, review-report.json, and cited probes/receipts in review-1/.
Read actual review inputs and all needed evidence; the orchestrator has not judged the findings.

## Ownership and scope
Verify each R1-1 through R1-3 via receiving-code-review. Fix valid findings test-first, or reject with concrete evidence. Own only changes necessary to these findings, their regression/AC tests and directly affected contract/docs/delivery records on this worktree. Do not rebase, amend/rewrite earlier commits or merge anything. New commits must use the ClickUp ID scope, e.g. fix(86bcm927y): ...; inherited authorship only, no AI trailers.
The reviewer also recorded P3 R1-4 (six existing commit subjects use integrations scope). Leave prior history intact; report it for handover/follow-ups. Do not create extra unreviewed tail commits after your report.
You are not alone: the custom-domain story works in /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain. Do not revert others' work, touch sibling branches/resources, reset shared DBs or prune worktrees.
No nested agents. No push, PR, ClickUp write/post, merge, CI workflow change, real provider/network/deployment operation, real tool-home writes, or auth/settings changes.
Authorization for implementation and local isolated checks is settled: Justin said go and later enabled Docker. No renewed permission question for that scope.

## Actually open required skills and rules
Load leorna first, then engineering-best-practices, receiving-code-review, requesting-code-review, code-review-practice, review-fix-cadence, test-driven-development, mutation-testing-discipline, systematic-debugging, security-best-practices, multi-tenant-auth-management, api-contract-drift-guard, backend-data-migrations and git-commit-rules, from /home/justin/.agents/skills/<name>/SKILL.md. Follow applicable references and mandatory validation/defect-loop sections. Record successful reads.
Read /home/justin/.claude/CLAUDE.md, /home/justin/.codex/AGENTS.md, applicable AGENTS.md and any existing project CLAUDE.md (none found in planning; do not invent/edit one). Read Leorna shared memory and control-plane context, preserving other sessions.
Read feature-dispatch/references/review-loop.md and ac-verification.md under /home/justin/.hermes/skills/autonomous-ai-agents/. The main session runs independent review/verifier/auditor; do not dispatch them.

## Referee output — verbatim
R1-1  P2  internal/integration/service.go:73  Google Workspace drops the required configured clientId from the selectable item and copied pack. Save persists the value in configuration.values, but Render only substitutes servers JSON; this tile consumes clientId exclusively in signIn metadata. The common resolver copies item fields, not values/signIn, so native preview and saved pack omit the configured setting. This violates the approved AC3 copied-company-setting assertion.
R1-2  P2  internal/integration/service.go:61  Saving a valid IPv6 HTTPS origin panics. The newly exposed Variant.resolve call reaches unchanged render.go:135-137, which strips IPv6 brackets while rebuilding the URL, and render.go:104-105 ignores the parse error and dereferences a nil URL. The real HTTP POST terminates with EOF.
R1-3  P2  internal/integration/service.go:61  Out-of-range numeric ports are accepted as valid settings. The new save path relies on normalize at render.go:136-139, which copies parsed.Port without validating the TCP port range. Posting https://git.example.test:65536 returns 303 and persists unusable settings instead of rejecting the malformed address before writes (AC2).
R1-4  P3  git commit 381f870345064c533d2c3f802f6cdddac62aef7a:subject (and preceding five story commits)  All six local commit subjects use the integrations scope instead of the ClickUp story ID required by the Leorna skill (commits feat(<id>): ...). Authorship and absence of AI trailers are correct.
REVIEW AGAIN: 3 P0-P2 finding(s) in review-1 at 381f870: fix them, then review again (Full: round 2 reviews the whole story from 3aa979d; Mini: review the fix commits)

## Approved acceptance contract
AC1: predefined tiles, descriptions and required parameters; TestIntegrationsAC1TilesWithPostgres.
AC2: validate required settings before save; TestIntegrationsAC2ValidateWithPostgres.
AC3: configured selectable items/immutable pack snapshot; TestIntegrationsAC3PackBuilderWithPostgres.
AC4: transactional change-audit on save/change; TestIntegrationsAC4AuditWithPostgres.
Read full plan clauses and test/evidence requirements. No live-only AC. Preserve all approved tests/expectations; do not weaken them to green or relabel an unmet clause.
One config per service/company. No provider sign-in, credentials, connectivity tests or stable promotion. Existing preview confirmation and pack snapshots remain intact. Fix configured-setting propagation through supported representations, without pretending unsupported auth flow has been built. If a fix genuinely requires changed product scope/AC, report that exact decision to parent before doing dependent work.

## Required execution and handback
1. Verify clean assigned head; reproduce each finding on starting head and retain RED tests/evidence before source fixes.
2. Apply minimal coherent fixes, regression tests and appropriate negative/guard controls. Strengthen the named AC coverage where the finding revealed a missing clause; do not rely only on supporting tests.
3. Rerun required affected checks and complete local gates on final candidate per plan/skills. Preserve real command exits, skips and failures. DB-required tests need the real isolated Postgres binding; audit per-test JSON rather than summary-green skips. Regenerate contract outputs only when required and keep clean generation.
4. Capture genuine current screenshots for every AC and a real browser journey/continuous recording if changed behavior makes prior evidence stale. Inspect all image/recording outputs before claiming them. Keep receipts stamped with exact HEAD and label precommit/tree receipts honestly; independent agents will reprove.
5. Local commits only, correct configured Leorna identity; CLAUDE.md must not be staged, generated AGENTS.md never edited. Keep working tree clean. Return ready-for-next-review, final SHA, each finding disposition with evidence/test/commit, exact gates/remaining issues, changed paths, ac_status, defect_loop_skills, found_else, skill_lessons.
Write structured evidence/receipts in own folder; return prose in final message. Do not edit skills/memory.

## Isolated environment and resource safety
Create fresh role-owned scratch via mktemp under /home/justin/.hermes/cache/scratch (large build/browser files must stay off shared RAM-backed /tmp). Use short owned disk TMPDIR for Chrome SingletonSocket limits. Never write another role's evidence. Prior reviewer/builder owned containers were removed.
Prepared tools: /home/justin/.local/leorna-toolchain/go/bin/go, /home/justin/.local/leorna-toolchain/bin/golangci-lint and govulncheck. Private checksum-verified Helm3.18.4/OpenTofu1.12.6/Trivy0.70.0 remain at /home/justin/.hermes/cache/scratch/86bcm927y-builder-JZLvCI/bin. Builder preflight receipts document other tools. Verify tools and bind task-locally with supported Make variables, not global settings.
Use own uniquely named resource-bounded Postgres/ClickHouse containers and _test DB, loopback ports. Public image pulls may use task-owned anonymous Docker config when Windows helper fails, without copying credentials. Do not touch existing leorna-pg/sibling services.
Mutation runs ALWAYS under systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0. If private user-manager connection returns No data available, verify existing same-user DBUS_SESSION_BUS_ADDRESS and use documented task-local env -u XDG_RUNTIME_DIR fallback with the same cap (first test capped true); never uncapped.
Any SIGTERM/137/143/Killed requires earlyoom journal check before interpreting it; report and diagnose memory runaway before rerun under cap. Full browser journey passed in review after heavy container build finished, following an initial load-related timeout; retain failures and avoid resource-heavy recording/build overlap where practical. Serialize timed screenshots with navigation and bound captures.
Do not read /home/justin/.hermes/.env or expose secrets. Setup sync remains read-only even escalated; keep artifacts local and do not bypass. The user manually completed required pre-planning pull.

## Skill lessons
Return skill_lessons[{skill,lesson,evidence,enforce}], enforce none or a one-line check proposal specifying kind/check/location. Empty is normal; new reusable proven lessons only. Existing Chrome path, session-bus fallback and serialized recording lessons are already saved. Main session saves lessons; you never edit skills or shared memory.
End exactly: MAIN SESSION: check and save these skill_lessons now.

