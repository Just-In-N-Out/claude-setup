# BUILDER — 86bcm927y integrations catalog tiles
Role: BUILDER. Full pipeline. Native pipeline_builder, gpt-6-astra / xhigh, fresh context.
Approved plan (read entirely): /home/justin/.hermes/plans/leorna/evidence/86bcm927y/plan-approved.md
Approval record: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/approval.json
Story: Integrations catalog - tiles UI in the admin console, https://app.clickup.com/t/86bcm927y
Main repo: /home/justin/Leorna/leorna-control-plane
Owned branch: feat/86bcm927y-integrations-catalog-tiles
Owned worktree to create after admission checks: /home/justin/Leorna/86bcm927y-integrations-catalog-tiles
Evidence: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/builder/
Owned scratch/tools: create a unique disk-backed directory under /home/justin/.hermes/cache/scratch/ with the story and role in its name.

## Authorization
Justin's latest words: "go". This explicitly approves the saved plan and recommended choices 1A and 2A:
- One saved configuration per service/company; later saves edit it.
- Prepare local test environment before building. Justin handles starting Docker Desktop/enabling Ubuntu WSL integration; you verify access, prepare your own bounded disposable services and provision needed tools in your owned directory through the normal permission path.
Implement the approved plan test-first, collect evidence, and stop at ready-for-review when local gates pass. Never bypass a missing prerequisite or claim skipped tests passed. The main session will dispatch all independent reviews/fixes/verifier/auditor and finish roles.
No need to re-request accepted scope/plan approval. A go is not proof Docker has started. Recheck it promptly and notify the main session immediately if still unavailable, with the exact error and the minimum user action; continue useful independent authorized tool/evidence preparation while waiting. Do not start production edits until the plan's baseline/evidence prerequisites are met.

## Required rules and actual skill loading
Open /home/justin/.claude/CLAUDE.md, current /home/justin/.codex/AGENTS.md and applicable repo AGENTS.md; locate/read any existing project CLAUDE.md (absent at planning; do not fabricate one).
Actually open these SKILL.md files, in order, and announce use:
1. /home/justin/.agents/skills/leorna/SKILL.md — BUILDER, shared context, approved branch, gates/evidence and stopping point.
2. /home/justin/.agents/skills/engineering-best-practices/SKILL.md
3. /home/justin/.agents/skills/test-driven-development/SKILL.md
4. /home/justin/.agents/skills/systematic-debugging/SKILL.md — use on every unexpected failure before proposing fixes.
5. /home/justin/.agents/skills/mutation-testing-discipline/SKILL.md — permission, tenant, identity, validation, transactional integrity and preview guards.
6. /home/justin/.agents/skills/security-best-practices/SKILL.md
7. /home/justin/.agents/skills/multi-tenant-auth-management/SKILL.md
8. /home/justin/.agents/skills/api-contract-drift-guard/SKILL.md
9. /home/justin/.agents/skills/backend-data-migrations/SKILL.md
10. /home/justin/.agents/skills/git-commit-rules/SKILL.md before local story commits; /home/justin/.agents/skills/github/SKILL.md + relevant reference for remote reads.
Read relevant references, plus dispatcher review-loop.md and ac-verification.md to preserve later evidence compatibility. Functions.exec outer output defaults to 10k tokens; split large reads or use appropriate output pragma so instructions are not lost. Return actual read receipts, not just a skill list.
All nested subagent/review steps in skills belong to the orchestrator. Do not start subagents. You are not the independent reviewer.

## Shared context, baseline and ownership
Shared Leorna memory: /home/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory. Read its index/workflow/control-plane workflow and relevant policy/evidence notes; fresh rules override historical notes. Do not write skills or memory.
Approved planning pin: 3aa979df41568c9039007f66d7f32193e66a8533. Prerequisite PR87 (tile model) and PR88 (library browser) are merged there.
At dispatch shared local main remains e2254e0100a482b9201edf9b96f01936e4486d44, tracked clean, 94 behind cached origin/main, with only existing untracked .claude/. No branch/worktree for this story was observed.
Re-fetch current main via Leorna's literal HTTPS/gh recipe, verify identity, inspect any new drift relevant to the approved plan and pin actual base. Follow Leorna's safe fast-forward of the main checkout before branching when it is still main, tracked clean and unowned by an in-flight edit; preserve untracked .claude/ and all sibling work. Never switch/reset/stash/commit another session's files. If shared state changed, report precise facts rather than forcing a checkout. No story merge into main.
Create the dedicated story worktree under /home/justin/Leorna only after admission. Confirm configured authorship; never override author/committer settings and never add AI trailers. Do not stage CLAUDE.md/generated AGENTS/evidence/secrets.
You are not alone in this codebase. A separate session has the custom-domain story 86bccndx6. Its completed plan/handoff:
- /home/justin/.hermes/plans/leorna/86bccndx6-custom-company-domain.md
- /home/justin/.hermes/plans/leorna/86bccndx6-custom-company-domain-handoff.md
At dispatch it is awaiting its own go, no branch observed. Inspect updated handoff/plan/worktrees before editing shared handler/main/delivery files or claiming a migration slot. Use separate worktree, databases, containers, ports, browser profiles and additive hunks. Preserve others' edits; do not merge sibling branches, prune worktrees or commandeer resources. All old .claude/worktrees are owned by other jobs.
If schema slot 28 is newly taken on main, apply the approved renumber rule and record it. If source drift changes planned product semantics, report a decision rather than silently redesigning.

## Acceptance criteria (approved)
- AC1: predefined integrations appear as tiles with short descriptions and required parameters. Primary test TestIntegrationsAC1TilesWithPostgres.
- AC2: required values validate before saving. Primary test TestIntegrationsAC2ValidateWithPostgres.
- AC3: configured integrations become pack items and appear in the pack builder. Primary test TestIntegrationsAC3PackBuilderWithPostgres.
- AC4: saves/changes write change-audit records. Primary test TestIntegrationsAC4AuditWithPostgres.
Preserve all detailed clauses, negative controls and test names in the approved plan. No live-only AC is approved, and you cannot add live tags, weaken assertions or amend the approved copy. Also required: real browser integration test and continuous recorded demo, full project gates and module documentation.

## Implementation responsibility
Own exactly the approved control-plane changes: integration service/configuration types; one additive configuration migration and tenant-filtered Postgres persistence; responsive admin tiles/forms; common tenant catalog and pack resolution; transactional redacted audit; composition, contract descriptions/generated artifacts and tests/docs/delivery record. Follow the plan's interfaces, stages and complete test seed; make scoped routine adjustments only when needed to implement the accepted behavior and report them.
Reuse existing tile definitions/rendering/security gates and native pack preview-confirmation; keep old pack versions immutable. Definitions remain preview. No OAuth/token/secret collection, live provider connection tests, new providers, custom integrations, client changes, framework/repo-wide rewrites or bypasses.
Write the failing behavioral test before each product change; record RED/GREEN. Guards require executable mutation proof under the cap. Unexpected failures go through systematic debugging. Preserve existing controls.
Capture meaningful before UI state BEFORE visible edits; do not reconstruct later.

## Environment and evidence
Read the plan's exact pinned versions and gate recipes; locate existing tools first. Go/golangci-lint/govulncheck/gitleaks exist outside default PATH. Docker was unavailable at planning. Helm/OpenTofu/Trivy need verification/provisioning. Tool installation must stay in owned permitted directories, with sandbox escalation if necessary; never edit global PATH/auth/settings or CI.
Use own disposable Postgres/ClickHouse services and unique database ending _test; never share/reset a sibling DB. Bind loopback only. Never print passwords/tokens.
Run canonical make check with explicitly verified compatible tool paths, all prescribed UI/DB/container/module-add checks and focused AC tests; retain true exit codes. Prove whole DB-package tests ran via Go JSON and audit skips per Leorna rules. Do not confuse syntax checks with application tests or local gates with hosted CI.
One genuine screenshot per AC, real visible UI captures for UI behavior. Record the continuous browser GIF using the plan's method with synthetic local data, real clicks/validation/preview/audit transitions; inspect the animation and manifest. No final-state slideshow or log screenshot replacing UI/recorded demo. Evidence under your own folder with head SHA, commands/results, file hashes and provenance. Redact real identifiers/URLs/secrets before sharing.
Commit final source/tests/docs locally with allowed identity (no push); keep working tree clean for later independent review/checkers. The builder status is ready-for-review, never reviewed/verified/shipped.
If gates are blocked by a proven baseline or host failure, preserve logs and precise result; don't weaken gates, expand story or claim ready-for-review. Report the blocker and useful work completed.

## Pipeline boundaries
ClickUp read-only. No push, PR, evidence publication, messages to others, merge into main, deployment/live servers/cloud, real tool-home writes or .github/workflows changes. Don't read /home/justin/.hermes/.env. No generated AGENTS edits.
The manual user-run setup pull cleared the pre-planning hold. Setup sync of new records still fails in this managed session because .claude-setup.git is read-only even escalated. Artifacts are local, not confirmed synced; do not bypass mounts or repeatedly block authorized work on the same known setup issue.
Full review/fix loop and fresh verifier/blind auditor are mandatory after you return. Report all defect_loop_skills. Docs/delivery changes belong in your candidate before review; no unreviewed tail commits.

## WSL runaway-memory requirement
For SIGTERM, 143/137 or Killed, read earlyoom journal since the command before classifying. If earlyoom killed it, report time, process/path and memory, fix the cause and rerun under systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0. Mutation runs ALWAYS use this cap. An earlyoom kill is not a caught mutation or passing/failing test. If cap mechanism fails, report it; never rerun a mutation bare.
Use uniquely owned disk-backed scratch under /home/justin/.hermes (not large builds on /tmp RAM filesystem). Explicit workdir on commands. Delete only resources positively owned by this role, no broad process kills or shared cleanup.

## Reporting
Send brief progress at meaningful milestones, promptly report blockers to the parent with collaboration.send_message (not only your own commentary).
Return status, branch/worktree/base/head, changed-path/stat summary, skill-load receipts, AC-to-test/result/screenshot map, recorded-demo path, complete gate commands/results including skips/failures, TDD/mutation receipts, docs/delivery changes, overlapping sibling state, remaining issues/found_else, and defect_loop_skills.
Do not edit skills/memory. Report skill_lessons[{skill,lesson,evidence,enforce}], where enforce is "none" or one-line check proposal (kind, what, where). Empty list is normal; only new/reusable/proven lessons. Return structured ac_status with accepted/test/screenshot/evidence per AC, accurately limited to builder checks.
End exactly: MAIN SESSION: check and save these skill_lessons now.


## Preflight continuation state — 2026-11-04
Completed preflight receipts are in builder/preflight/. Docker remains the sole blocker; wait for Justin to report it ready, then verify Docker and resume the approved build without another go. All tools and scratch were retained at /home/justin/.hermes/cache/scratch/86bcm927y-builder-JZLvCI. Helm/OpenTofu/Trivy versions/checksums and Chrome smoke capture were verified. The user systemd cap issue is resolved by the documented task-local session-bus fallback: retain the verified existing DBUS_SESSION_BUS_ADDRESS and use env -u XDG_RUNTIME_DIR before the same systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 command. Harmless true probe exited 0 (cap-session-bus-probe.json); no service/settings changes or restart needed. Recheck the same owned bus binding if the session changes. No story worktree/source/test edits/commits exist yet. Main was advanced by the concurrent session to 3aa979df41568c9039007f66d7f32193e66a8533. Custom-domain now has its own clean-at-observation worktree; refresh overlap before editing. Both reported skill lessons were saved; do not repeat them as new.
