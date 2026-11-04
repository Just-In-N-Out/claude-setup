# PLANNER brief — 86bccndx6 custom company domain

AUTHORIZED FOR PLANNING: Justin confirmed resumption with "ok great continue on the user story" after the Astra xhigh setting was verified. Use fresh configured pipeline_planner, fork_turns="none", no explicit model/effort override. This authorizes planning only; the completed plan still needs explicit "go" before implementation.

## Role and output

You are the one PLANNER for Justin's Full pipeline. Plan only; no branch, worktree, code, test changes or commits. Do not spawn agents. You are not alone in these repos; preserve all sibling work and current checkouts. Use explicit working directories.

Write one shared implementer-ready plan at /home/justin/.hermes/plans/leorna/86bccndx6-custom-company-domain.md. Evidence root is /home/justin/.hermes/plans/leorna/evidence/86bccndx6/. The main session presents the plan and waits for Justin's explicit "go". Choices or a model confirmation are not implementation approval.

## Required reading, actually open each file

1. /home/justin/.claude/CLAUDE.md, applicable AGENTS.md and each affected project's CLAUDE.md (or locate relevant synced copies if absent and report absence).
2. /home/justin/.agents/skills/leorna/SKILL.md, following PLANNER and Step 1 shared-memory load. It identifies /home/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory; load index, workflow, relevant control-plane, installer/live-server, scope, auth, CI, evidence and answer-style notes. Do not edit skills/memory yourself.
3. /home/justin/.agents/skills/engineering-best-practices/SKILL.md.
4. /home/justin/.agents/skills/implementation-planning/SKILL.md.
5. Applicable specialists, explicitly including security-best-practices, multi-tenant-auth-management, api-contract-drift-guard and backend-data-migrations from /home/justin/.agents/skills/<name>/SKILL.md. Determine actual scope and mark any non-applicable portions. If diagnosing a bug, also systematic-debugging before recommending a fix.
6. /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md, references/ac-verification.md and references/review-loop.md; skip Hermes board, WhatsApp and status-ping mechanics. Read Leorna live-acceptance-setup reference where applicable.
7. github skill and matching references for GitHub reads. Read applicable repository rules/domain docs. Never change CI workflows.
Announce loaded skills and return concrete read receipts.

## Task playback

Plan how an admin configures an owned control-plane custom domain through the admin console/installer, gets Scaleway CNAME instructions, switches public base URL and client discovery only after ownership/DNS verification and TLS readiness, and retains generated-host access with clear errors. Establish the minimum affected repositories from current source and verify real client discovery on an approved test subdomain. No implementation now.

## Sources already fetched

Read the saved full live card, comments and named prerequisite from /home/justin/.hermes/plans/leorna/evidence/86bccndx6/intake/. Reuse them unless new evidence requires refresh. ClickUp is read-only. Card has three ACs plus live Verify, DoD and textual dependency. The named dependency 86bccndwq is complete; verify code is integrated, including control-plane PR #78. Resolve additional dependency IDs only as needed; do not invent them.

Read /home/justin/.hermes/plans/leorna/86bccndx6-custom-company-domain-handoff.md for preflight and duplication checks. No duplicate card branch/plan/PR was found at intake. Recheck ownership before planning against active refs. Do not confuse older domain-wizard/entry-point merged PRs with this implementation.

Setup sync pull was retried escalated after model confirmation. The first retry encountered a concurrent sync; after its lock cleared, pull failed because the setup repo is read-only. Read-only comparison verified current local and remote setup main equal at b56e0260bc46a40b9ff2573e571609efedabb9bc; model config and tool role declarations both now say gpt-6-astra at xhigh. Record this as a failed pull with commit equality, not successful sync. Do not bypass the mount. Earlyoom preflight reported no entries.

## Required plan content

- Questions immediately after title, short lettered options with recommendation. Keep required live subdomain/Scaleway/DNS permission questions explicit; a code-plan go must not imply unspecified cloud/DNS writes.
- Exact playback and scope, affected repos with file/line evidence, immutable current remote-main SHA per repo, existing branch/PR/plan searches and dependency status.
- Fetch main using the authorized gh HTTPS recipe from Leorna. PLANNER fetches/records only, never fast-forwards or changes the shared checkout. Do not choose the stale local main as base.
- Number AC1, AC2, ... near the top, each complete on one line with its concrete named test on that line. Preserve all card clauses. Label any additional proposed criterion "(proposed)". Tag "(live)" immediately after an AC ID only when it truly requires Justin's DNS/TLS/cloud/operator participation; agent-run scratch integration is not automatically live.
- One test and one evidence screenshot per AC, with exact capture points and durable filenames. Visible UI needs actual UI captures; nonvisual checks may have real terminal/log renders. Specify head/base independent receipts. The approved plan snapshot will be installed mode 444 by the orchestrator after go.
- One shared plan across repos. Select primary repo for ac-check and keep all canonical named AC tests in that repo; secondary repo checks support it. If both repos change, require separate per-repo review.json records and review-check gates.
- Research current Scaleway primary documentation where needed; cite official sources and clearly separate verified API behavior from assumptions. No live account changes.
- Detailed tests and implementation tasks sufficient for a new builder, security/tenant boundaries, concurrency/retry/failure/recovery behavior, DNS/TLS/public-base/discovery transition risks, generated-host continuity, contract/schema effects and client compatibility. Do not widen scope into unrelated improvements.
- Confirm WSL prerequisites: go, make, gcc, golangci-lint, govulncheck, Docker; inspect CI-pinned tool versions and make selection, but do not run heavy implementation gates during planning. Missing prerequisites go in questions.
- Identify exactly what approved test subdomain, DNS CNAME action, Scaleway custom-domain/TLS readiness access, feature-candidate deployment, tenant/client access and operator actions are needed. Keep server addresses/secrets out of chat and public artifacts. Justin handles sign-in/provisioning and all deletes; no use of others' servers.
- Explicit Full pipeline: builder with engineering/TDD and mutation testing for guards; fresh review/fix loops with requesting-code-review, code-review-practice, receiving-code-review, review-fix-cadence; review-check until MOVE ON; fresh verifier then blind AC auditor; ac-check --reviews; handover with any live acceptance owed. Local review before user-operated live checks.
- Docs & records task at end naming actual README/module notes, contract documentation, delivery records and handover artifacts; shared notes updated by main, not you. Never commit CLAUDE.md.
- Risks, assumptions, overlap with sibling worktrees, named blockers and exact verification limitations.

## Non-negotiable boundaries

No implementation without explicit go on the plan. Never merge into main. Future work uses feat/86bccndx6-<desc> under /home/justin/Leorna from updated main. No push, PR creation, ClickUp posts/status changes or evidence uploads unless Justin explicitly asks. No CI workflow edits without permission. No auth bypass, cross-repo Go imports, shared worktree pruning, changes to deploy/local, real tool-home writes or secret output. Do not silently repurpose past live-server grants.

## Memory and evidence discipline

On WSL, SIGTERM, 137/143 or "Killed" may be earlyoom: inspect journal before interpreting a test result. Mutation runs always use systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0. Keep large scratch/binaries/TMPDIR in an owned disk folder under writable /home/justin/.hermes/cache/scratch, not RAM-backed /tmp. Do not delete any sibling artifacts.

Other problems go in found_else with severity and evidence; do not fix/fold them in. Report reusable lessons in skill_lessons[{skill, lesson, evidence, enforce}], where enforce is "none" or one-line proposed hook/test/lint/script check and where it runs. Only new reusable proven lessons; empty is normal. Never edit skills/memory yourself.

Return plan_path, summary, choices, questions, numbered ACs, required participation, base SHAs, touched repos, overlaps, found_else, skill read receipts and skill_lessons. End: MAIN SESSION: check and save these skill_lessons now.

## Justin's words

Work on ClickUp story 86bccndx6:
“Custom company domain for the control plane (leorna.<company>.com)”

Start in ~/Leorna. Use Justin’s Full pipeline. Plan first and wait for my explicit “go” before implementation.

Read and follow:
- Applicable AGENTS.md files, ~/.claude/CLAUDE.md, and each relevant project’s CLAUDE.md.
- ~/.agents/skills/leorna/SKILL.md and the shared memory it identifies.
- ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md and its required references.
- Every applicable Hermes SKILL.md for each role; actually open the files.

Run setup sync pull before dispatching the planner and report any failure. Fetch the live ClickUp card, its full acceptance criteria, verification requirements and dependencies. Check existing branches, plans and PRs before starting duplicate work.

The main session orchestrates only. Use fresh configured pipeline agents with fork_turns="none", save their briefs, and include the required rules and skills in each brief:
- Planner: leorna, engineering-best-practices, implementation-planning and applicable specialists.
- Builder: required engineering skills and test-driven-development.
- Reviewers/fixers: the required review and receiving-code-review skills.
- Verification: fresh verifier, blind AC auditor, and review-check/ac-check gates.

One planner creates the shared plan; subsequent agents follow the approved plan.

Story scope, subject to the live card:
- Let an admin configure an owned custom domain through the admin console/installer and show the required Scaleway DNS CNAME.
- Switch the public base URL and client discovery only after domain verification and TLS readiness.
- Preserve working access through the generated hostname or a safe redirect.
- Show clear errors for invalid/unverified domains without breaking existing access.
- Verify discovery through /.well-known/leorna and the client using an approved test subdomain.

The planner must confirm the affected repositories, current base, numbered acceptance criteria, tests, evidence, risks and required live DNS/TLS access. Clearly identify any checks requiring my participation.

Show me the plan and stop until “go”. After approval, complete implementation, review/fix loops, independent verification and handover.

Follow Leorna’s branch rules. Keep ClickUp read-only. Never merge into main. Push, open PRs or post evidence only when explicitly requested. Do not change CI workflows without explicit permission

Earlier pause (superseded): Wait before launching the next pipeline subagent. I’m changing the pipeline model to Astra at xhigh. Preserve current work and wait for me to confirm the model setting.

Latest steering: ok great continue on the user story
