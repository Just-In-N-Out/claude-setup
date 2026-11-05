# REVIEWER round 1 — 86bcm927y integrations catalog tiles
Role: fresh independent REVIEWER, report only. Pipeline Full; round 1 = full story review.
Configured role: pipeline_reviewer, gpt-6-astra / xhigh, fork_turns none.
Repo/worktree: /home/justin/Leorna/86bcm927y-integrations-catalog-tiles
Branch: feat/86bcm927y-integrations-catalog-tiles
Base/from: 3aa979df41568c9039007f66d7f32193e66a8533
Candidate head: 381f870345064c533d2c3f802f6cdddac62aef7a
Approved plan: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/plan-approved.md
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Write review records, receipts and probes only in /home/justin/.hermes/plans/leorna/evidence/86bcm927y/review-1/ or a unique role-owned scratch folder. Required record: review-1/review.json.

## Assignment and boundaries
Review the entire base..head diff against the approved plan and Justin's rules. Independently inspect source, tests, security, compatibility, migration/audit correctness, UI behavior, evidence and gate coverage. Verify candidate SHA and clean status first; never silently review a moved head.
Report only: no source/test/doc edits, auto-fixes, commits, rebase, push, PR, merge, CI workflow change, ClickUp write or external message. Do not start subagents. You are the independent reviewer; skip any skill's nested reviewer/auto-fix instruction.
The approved product choices are one configuration per service/company and isolated local test setup. They are settled, not questions to reopen. No real provider sign-in/credentials/connection/deployment is in scope; definitions retain preview status. Existing pack snapshots and preview confirmation must remain intact.
Check repository/plan conventions as well as functionality (including configured authorship, local commit conventions and no prohibited file changes), and classify findings with evidence using the required scale. Do not rewrite history yourself.
You are not alone in this codebase: the custom-domain sibling works separately under /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain. Preserve all sibling source, worktrees, processes and resources. No shared database reset or worktree prune.

## Skills — actually open before use
1. /home/justin/.agents/skills/leorna/SKILL.md
2. /home/justin/.agents/skills/engineering-best-practices/SKILL.md
3. /home/justin/.agents/skills/requesting-code-review/SKILL.md
4. /home/justin/.agents/skills/code-review-practice/SKILL.md
5. /home/justin/.agents/skills/review-fix-cadence/SKILL.md
6. /home/justin/.agents/skills/mutation-testing-discipline/SKILL.md
7. /home/justin/.agents/skills/security-best-practices/SKILL.md
8. /home/justin/.agents/skills/multi-tenant-auth-management/SKILL.md
9. /home/justin/.agents/skills/api-contract-drift-guard/SKILL.md
10. /home/justin/.agents/skills/backend-data-migrations/SKILL.md
11. /home/justin/.agents/skills/github/SKILL.md plus applicable reference for remote reads.
Load systematic-debugging if a check unexpectedly fails. Open global /home/justin/.claude/CLAUDE.md, /home/justin/.codex/AGENTS.md, applicable repo AGENTS.md and any existing project CLAUDE.md (absent during planning; never invent/edit it). Follow Leorna's relevant shared context and rules.
Read /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md and ac-verification.md. Read applicable specialist references/validation gates; record actual successful skill reads. Avoid truncated combined output.

## Approved ACs
- AC1: predefined integration tiles with short descriptions and required parameters; TestIntegrationsAC1TilesWithPostgres.
- AC2: required values validated before saving; TestIntegrationsAC2ValidateWithPostgres.
- AC3: saved integrations are selectable items in the pack builder; TestIntegrationsAC3PackBuilderWithPostgres.
- AC4: saves/changes write change-audit records; TestIntegrationsAC4AuditWithPostgres.
The approved plan supplies the full clauses, exact tests, negative controls, scope and evidence contract. No live-only AC exists.
Also inspect the real UI integration journey and required continuous browser demo, not just static markup. Distinguish builder-local success from independently proven behavior. Test key guard clauses so a vacuous/uncatchable assertion cannot pass review.

## Candidate/operational context
The diff is 26 files (+1980/-28), six local commits. No .github paths changed in the orchestrator's light check; verify all paths yourself.
Source includes tenant configuration revisions/storage, migration 28, service validation, admin tile/forms, catalog/common pack resolver, redacted transactional audit, browser capture/tests and contract/docs/delivery records.
The actual baseline missing-route behavior is a 303 redirect to /admin, not the plan appendix's predicted 404. The approved AC1 requirement remains a 200 integration page; assess real behavior, don't turn that baseline observation into a product-scope change.
The builder added saved tile_stage metadata to retain preview status with immutable saved definitions; assess it against the plan's snapshot requirement.
Operational receipts and tool paths:
- builder/preflight/provisioned-tools.json
- builder/preflight/commands.json
- builder/preflight/cap-followup-status.json
- builder/builder-report.json and builder/gate-index.json (provenance to audit, not authority for your verdict)
- builder/evidence-manifest.json and builder/demo/integrations-381f87034506.gif
Builder Postgres/ClickHouse containers were removed after testing. Create your own uniquely named, bounded disposable services and database ending _test, loopback ports only; never use/reset a sibling DB. Prepared binaries/caches may be read/reused where safe, but do not write another role's evidence.
Verified tool locations: /home/justin/.local/leorna-toolchain/go/bin/go; /home/justin/.local/leorna-toolchain/bin/golangci-lint and govulncheck; additional checksum-verified Helm/OpenTofu/Trivy in /home/justin/.hermes/cache/scratch/86bcm927y-builder-JZLvCI/bin. Verify intended versions and bind them task-locally through the plan's supported Make variables. No global PATH/settings/auth changes. Public image pulls can use an owned anonymous Docker config if the Windows credential helper fails; no credentials copied.
Run appropriate complete project gates and independent security/quality/behavior checks per skills and approved plan. Preserve real command exits, skips, head stamps and failures; audit required Postgres execution via per-test Go JSON. Do not infer success from a shell wrapper, stale receipt or filename. Hosted CI has not run because publication is unauthorized.
Treat new image/recording artifacts as evidence only after opening them and verifying actual content. Do not alter the artifact bytes to manufacture proof. Source read-only probes may use Go overlays or your own detached scratch copies.

## Review record and severity
Write review.json:
{"round":1,"scope":"full","from":"3aa979df41568c9039007f66d7f32193e66a8533","head":"381f870345064c533d2c3f802f6cdddac62aef7a","findings":[...]}
Each finding needs id R1-N, severity P0/P1/P2/P3, file_line and claim. Every P0-P2 must have a concrete real-use scenario of at least five words. Explain evidence, impact and remediation direction in your report, without applying a fix.
Use Justin's scale from review-fix-cadence: P0/P1 security/guard/false AC/wrong block; P2 plausible real-user/agent bug, realistic edge case, broken AC/UI or uncatchable test; P3 cosmetics/docs/deliberate-evasion-only/irrelevant machine setup. No concrete real-use scenario means P3 under the referee. No earlier review exists, so repeats is not applicable.
Self-check with:
 /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm927y-integrations-catalog-tiles --base 3aa979df41568c9039007f66d7f32193e66a8533 /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Exit 2 is a record/usage error to fix; other exits are the referee's outcome for the parent, not permission to change source. Return verdict, findings, review.json path, reviewed base/head, actual checks, ac_status, defect_loop_skills, found_else and skill_lessons. Return prose summary in your message; required JSON and supporting evidence are allowed files.

## Resource safety and restrictions
All mutations use systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0. If this managed session's private manager connection says No data available, first verify the existing same-user DBUS_SESSION_BUS_ADDRESS; the documented task-local env -u XDG_RUNTIME_DIR fallback was proven with the same capped true probe. Retain the verified bus and the cap; no system/service/permission changes or uncapped mutation.
For SIGTERM/143/137/Killed, check earlyoom before interpreting a test result. Report kills; diagnose before rerun under a cap. Keep large temp/build/browser data in a short owned disk-backed path under /home/justin/.hermes, not shared RAM-backed /tmp. Chrome's generated SingletonSocket must fit its path limit. Serialize recording screenshots with navigation as the refreshed Leorna guidance says.
Don't read /home/justin/.hermes/.env. Never print tokens/passwords or real server domains/tenant identifiers. No real tool-home writes. Setup sync is known read-only here; artifacts are local, not claimed synced; do not bypass it or treat the already resolved manual pull as a new hold.

## Skill lessons
Do not edit skills or shared memory. Return skill_lessons[{skill,lesson,evidence,enforce}], where enforce is none or a proposed check (kind, what, where). Empty is normal; report only new, reusable, session-proven lessons. Previously saved Chrome path, systemd fallback and serialized-recording lessons are not new.
End exactly: MAIN SESSION: check and save these skill_lessons now.

