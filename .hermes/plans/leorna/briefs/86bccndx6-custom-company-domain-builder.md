# BUILDER — 86bccndx6 custom company domain

## Assignment and authority

You are the fresh configured pipeline_builder (Astra xhigh) for Justin's Full pipeline. Build the single approved plan test-first, then stop at ready-for-review. No subagents: the main session dispatches every role. You are not alone in the codebase. Do not revert, stash, reset, prune, overwrite or otherwise disturb sibling work; use your own worktree and accommodate concurrent changes.

Justin explicitly said **go** after the plan and all recommended options were presented. Read `/home/justin/.hermes/plans/leorna/evidence/86bccndx6/approval.json` and the immutable `/home/justin/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. This is the single source of approved implementation scope. All A choices and AC1–AC6 are approved. Do not redesign or change ACs yourself; report a concrete conflict to the orchestrator for a planner amendment.

The feature lets an admin configure an owned control-plane domain through the local installer, see the required Scaleway CNAME, activate only after DNS/TLS readiness, retain generated-host API access/safe browser navigation, and recover without resource deletion. The admin console displays the active and fallback domains. One unused direct-CNAME subdomain is the approved release scope. Existing authentication is preserved.

Local code, tests, evidence and branch commits are authorized. No push, PR creation, ClickUp write/status/post, evidence upload, CI workflow edits, story merge into main, live cloud/DNS mutation, new server provisioning, registry push, real tool-home writes, credential changes or resource deletion are authorized. No concrete live test FQDN/target/grant exists yet. AC4 remains owed until scoped live acceptance after local review. Do not treat code-plan go, past server notes or unavailable Docker as a waiver of a gate.

## Required reading — actually open every applicable SKILL.md

1. `/home/justin/.claude/CLAUDE.md`; applicable AGENTS.md and project CLAUDE.md. Root project CLAUDE.md was absent at planning; check applicable files and do not invent missing contents.
2. `/home/justin/.agents/skills/leorna/SKILL.md`, then the shared memory it identifies, including workflow, control-plane workflow, own install/live-server/test-branch, evidence, auth/CI/scope and handover notes. Read current dated status; do not reuse historical server authority.
3. `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`.
4. `/home/justin/.agents/skills/test-driven-development/SKILL.md` and `/home/justin/.agents/skills/mutation-testing-discipline/SKILL.md`.
5. `/home/justin/.agents/skills/security-best-practices/SKILL.md`, `/home/justin/.agents/skills/multi-tenant-auth-management/SKILL.md`, `/home/justin/.agents/skills/api-contract-drift-guard/SKILL.md`, `/home/justin/.agents/skills/backend-data-migrations/SKILL.md`. No DB migration is planned; apply schema/cache compatibility discipline as scoped by the plan.
6. `/home/justin/.agents/skills/git-commit-rules/SKILL.md` and `/home/justin/.agents/skills/github/SKILL.md` with applicable references before git/GitHub work. The configured Leorna identity must be inherited, never overridden.
7. `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`, `references/ac-verification.md`, `references/review-loop.md`; skip Hermes board/WhatsApp/status ping mechanics. Read Leorna live-acceptance reference when relevant.
8. If any test fails unexpectedly, load `/home/justin/.agents/skills/systematic-debugging/SKILL.md` before proposing a fix. For correctness/security-critical validation, load `/home/justin/.agents/skills/adversarial-verification-loop/SKILL.md`; independent roles are run by main, never spawn them yourself.

Announce the loaded skills and return read receipts. Never edit shared skills or memory yourself.

## Repository, base, ownership and preflight

Implementation repo `/home/justin/Leorna/leorna-control-plane`. Approved planning base `3aa979df41568c9039007f66d7f32193e66a8533`. Branch `feat/86bccndx6-custom-company-domain`; use a dedicated worktree under `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain` if unoccupied. Check duplicates before creating. The main checkout was on stale local main with only untracked `.claude/`; do not mistake sibling worktrees for dirt to delete. Fetch current main through the authorized literal HTTPS + gh credential recipe, confirm current SHA and assess changed plan-owned files if it moved. Leorna's clean shared-main fast-forward may only bring origin/main into the shared main as base preparation; never merge story changes into main. If another session owns/moves the shared checkout, preserve it and report rather than forcing it. All product edits occur in your worktree.

Client `/home/justin/Leorna/leorna-client` remains production-read-only, pinned consumer SHA `feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6`. Use an owned archive for actual resolver/compatibility execution per plan. No cross-repo Go imports. A genuine required client production change needs a scope amendment; do not weaken its redirect/origin validation.

Concurrent story 86bcm927y (integrations catalog) has a completed plan awaiting its own go in shared memory: `/home/justin/.hermes/plans/leorna/86bcm927y-integrations-catalog-tiles.md`. Its session owns its work, independently of this job. Read its ownership/touch summary and reconcile common composition/admin/contracts/delivery files before writing; use independent worktrees, no arbitrary serialization absent a real conflict. Existing older sibling worktrees are also untouched. No worktree prune; remove only your own disposable copies when authorized.

The setup pull was attempted repeatedly escalated, but setup gitdir is read-only. Local/remote setup equality was verified at intake; do not claim sync succeeded or bypass the mount. Current pipeline model was verified Astra xhigh. No earlyoom kill at dispatch.

Q3A authorizes using enabled Docker Desktop WSL integration, not the claim it is enabled. Recheck `docker info`, cached Go/Make/gcc/linter/audit and remaining canonical-gate tools first. The plan identifies cached Go tool paths and CI versions. If Docker remains unavailable, message main with the exact prerequisite and continue approved independent TDD/unit work; retain integration/image gates as blocked. Do not install global tools or change CI/product dependencies to repair the environment. Task-owned tool installation must follow existing permissions and project rules. Let main obtain missing operator action while you progress.

## Ownership update at dispatch

2026-11-04 22:52 UTC: shared memory now says 86bcm927y is approved, with /root/integrations_builder running in its separate session, brief `/home/justin/.hermes/plans/leorna/briefs/86bcm927y-integrations-catalog-tiles-builder.md`. This supersedes the earlier awaiting-go status. Check current main/worktree and shared-file/test-resource ownership; preserve independent progress and avoid shared DB/browser/scratch state.

## Approved acceptance contract

- AC1: create the selected container's domain binding and show CNAME instructions — `TestCustomDomainRegistrationShowsCNAME`.
- AC2: activate only after DNS/TLS readiness and preserve generated-host access — `TestCustomDomainActivationPreservesGeneratedAccess`.
- AC3: clear invalid/unverified/provider/TLS errors without breaking generated access — `TestCustomDomainFailureKeepsGeneratedAccess`.
- AC4 (live): actual custom HTTPS discovery plus real client resolution — `TestCustomDomainLiveClientDiscovery`; no target/grant yet, never replace it with fixture proof.
- AC5 (approved proposal): installer/project/network/tenant authority boundaries and safe retry — `TestCustomDomainGuardsAndRetry`.
- AC6 (approved proposal): resume/interruption reconciliation, old-server compatibility guard and non-destructive generated recovery — `TestCustomDomainResumeAndRecovery`.

All canonical tests live in control-plane as prescribed by the approved plan. Preserve each clause; focused package tests and real unchanged-client probes supplement them. Review current assertions before narrowing anything. Include opt-in live test code in the candidate to be reviewed, while labelling actual live execution not_run.

## Execution and evidence

Follow the plan's ordered slices and file ownership. Test-first RED/GREEN for each substantive behavior. Preserve exact failing/passing command receipts; do not mistake a missing executable/helper, no test matches, skipped test or failing environment for proof. Capture meaningful UI before-state while available and real UI results when states run. Do not reconstruct a missed UI state with a log screenshot.

Evidence root `/home/justin/.hermes/plans/leorna/evidence/86bccndx6`; write builder artifacts in `builder/` and approved per-AC screenshots/logs. Preserve immutable `plan-approved.md`; no verifier/auditor files. Screenshot each AC: `ac1-cname.png`, `ac2-active-domains.png`, `ac3-unverified-domain.png`, `ac5-guards.png`, `ac6-recovery.png`; AC4 stays pending until approved live proof. Visual criteria need actual handler/UI captures; guard-only receipts can be real terminal/log renders. Record exact head with each qualification receipt and retain failures. Raw real server addresses/secrets never go into chat/commits/public artifacts.

Full required local gates per current repo and Leorna: canonical `make check`, `bash ./scripts/test-module-add.sh`, contract generation/check, format/lint/security and applicable image/deployment checks; prove PostgreSQL tests ran via test-level go-test JSON and reject missing-DSN skips. Use your own database ending `_test`; never reuse/drop siblings' DBs. Run the real unchanged-client consumer and prescribed client gates in scratch with all platform limitations explicit. Bind actual selected linter and govulncheck absolute executables where Make permits, not merely a version probe. No CI workflow changes.

Guard mutations must fail for their intended reason. WSL mutations always run with `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; use small scalar assertions. SIGTERM/137/143/Killed may mean earlyoom, not a test result: check `journalctl -u earlyoom`, identify growth, report, and rerun under cap. Use an owned disk scratch folder under `/home/justin/.hermes/cache/scratch/86bccndx6-builder-<unique>` for Go TMPDIR, Chrome profiles, binaries and archives; /tmp is RAM-backed and only for small temporary files. Never share scratch with sibling roles. Use explicit workdir for shell commands.

Apply docs/records task from the plan in the same candidate: module/launcher/web/deploy/env/contract docs, delivery note and accurate story entry with uncreated PR/live fields pending. Do not mark shipped/merged/CI-green from a local run. Keep CLAUDE.md locally excluded and unstaged; never commit it. Commit story work on its feat branch with normal inherited `Justin Issa <justin@leorna.com>` identity, no overrides and no AI trailers. No push.

## Reporting and transitions

Send main a concise checkpoint after preflight (worktree/branch/base, tools/Docker status and skill read receipts), and at meaningful blockers/slice milestones. Do not stop to wait for approval already granted; continue independent authorized tasks. Main handles questions, review/fix/verification dispatch and setup sync.

Stop at ready-for-review only when implementation and required available local gates are complete, with any actual gate block explicit. Never call missing integration/live proof passed. If a local gate cannot run, report the concrete blocked gate and all completed work so main can arrange the prerequisite and continue this builder. Do not self-review as the independent reviewer and do not claim accepted ACs on behalf of verifier/auditor.

Return repo/worktree/branch/base/head, diff stat, implemented behavior, tests RED/GREEN, gates and exact exits, one evidence path per AC, live/gate limitations, overlap handling, found_else, required-skill read receipts and skill_lessons. Any unrelated issue goes in found_else with severity/evidence, never silently fixed.

Reusable lessons only: `skill_lessons[{skill, lesson, evidence, enforce}]`, where enforce is `none` or a one-line hook/test/lint/script proposal stating what and where. Empty is normal. Do not edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
