# REVIEWER 1 — 86bccndx6 custom company domain

DISPATCH HOLD: prepared during the build. Main must fill reviewed HEAD and confirm builder handback before dispatch. This file does not authorize an agent launch by itself.

## Role, candidate and scope

Fresh configured pipeline_reviewer, Astra xhigh, fork_turns none. Round 1 FULL review, report only. Do not change product files, fix code/tests, commit, rebase, publish or spawn agents. You are not alone; preserve sibling work and use owned scratch. Do not invoke a separate reviewer: you are the independent reviewer.

Repo/worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`.
Branch: `feat/86bccndx6-custom-company-domain`.
Planned base: `3aa979df41568c9039007f66d7f32193e66a8533` (main must confirm actual review base at dispatch).
Reviewed HEAD: PENDING_BUILDER_HANDBACK.
Approved plan: `/home/justin/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`.
Evidence: `/home/justin/.hermes/plans/leorna/evidence/86bccndx6`.
Your report/probes/receipts only: `<evidence>/review-1/` and your owned scratch.

Justin approved all recommended plan choices and AC1–AC6. Scope is installer-owned configuration for one unused direct-CNAME subdomain, hosted-admin display, DNS/TLS-gated activation, generated-host continuity, strict boundaries and non-destructive recovery. Control-plane-only production changes; unchanged pinned client is a real consumer check. No live target/grant exists unless main supplies a later exact user grant. AC4 is live and remains owed if unavailable. No new auth bypass, cross-repo Go imports or weakened client origin/redirect rules.

## Read the actual rules and skills

Open `/home/justin/.claude/CLAUDE.md`, applicable AGENTS.md/project CLAUDE.md, the approved plan and Leorna shared memory. Open these files in order:
- `/home/justin/.agents/skills/leorna/SKILL.md`.
- `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`.
- `/home/justin/.agents/skills/requesting-code-review/SKILL.md` and `/home/justin/.agents/skills/code-review-practice/SKILL.md`.
- `/home/justin/.agents/skills/review-fix-cadence/SKILL.md` and `/home/justin/.agents/skills/mutation-testing-discipline/SKILL.md`.
- `/home/justin/.agents/skills/security-best-practices/SKILL.md`, `/home/justin/.agents/skills/multi-tenant-auth-management/SKILL.md`, `/home/justin/.agents/skills/api-contract-drift-guard/SKILL.md`, `/home/justin/.agents/skills/backend-data-migrations/SKILL.md` and applicable references.
- `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and `references/ac-verification.md`.
- GitHub skill/references if checking GitHub; systematic-debugging if investigating an unexpected failure. No auto-fix steps or nested agents, regardless of a skill default.

Return required-skill read receipts. Read live source/current scoped artifacts, not just the builder narrative. Main orchestrates only; do not ask it to adjudicate correctness.

## Acceptance contract and review work

- AC1 `TestCustomDomainRegistrationShowsCNAME`: selected binding/CNAME instructions.
- AC2 `TestCustomDomainActivationPreservesGeneratedAccess`: verified activation and old-host continuity.
- AC3 `TestCustomDomainFailureKeepsGeneratedAccess`: clear failures with existing access working.
- AC4 (live) `TestCustomDomainLiveClientDiscovery`: approved live TLS + actual client resolver, not fixture proof.
- AC5 `TestCustomDomainGuardsAndRetry`: installer/project/network/tenant guards and valid controls.
- AC6 `TestCustomDomainResumeAndRecovery`: resume, interruption, old-server rejection, generated recovery without deletion.

Review the entire candidate diff against base, approved scope and every AC clause. Inspect test assertion changes and meaningful negative/positive controls; falsify important guards under the memory cap. Run required security/quality checks and sufficient independent tests to support findings. A missing environment is not a passing check; reproduce suspected baseline/tool issues on an isolated base if needed. Preserve exact current-head provenance and identify skipped/unavailable checks.

Use the full Leorna gate discipline: actual selected CI-compatible tools; Postgres JSON test-level skip accounting; own `_test` database; no sibling DB resets; own scratch/Chrome profiles; unchanged-client actual resolver where applicable. Do not run an unbounded full mutation suite. WSL mutation commands always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. SIGTERM, 137/143 or Killed: inspect earlyoom before calling it a test failure/mutant kill; report any runaway and rerun under cap. Keep large TMPDIR/Go/Chrome/binaries in owned disk scratch under `/home/justin/.hermes/cache/scratch`, not RAM-backed /tmp.

## Severity and machine-readable record

Write `<evidence>/review-1/review.json` with round 1, scope full, from exact base SHA, head exact candidate SHA, findings array. Each finding has id R1-N, severity P0/P1/P2/P3, file_line, claim, and concrete real-use scenario (at least five words for P0–P2). P0/P1: security hole, guard bypass, false AC or wrong block breaking normal work. P2: plausible user/agent bug or realistic edge case, AC/UI failure or ineffective test. P3: cosmetic/docs, deliberate evasion only or unsupported-machine setup. No concrete real-use scenario means P3. Do not inflate findings from hypotheticals; do not downgrade substantive AC failures.

Self-check the JSON with review-check.sh for your repo/base/evidence, fixing only report format if exit 2. Main follows the referee's result; you do not fix findings or advance the pipeline. Return verdict, findings, ac_status per AC, exact gates/probes with outcomes, report path, head/base and skill_lessons. A report must not label live AC4 passed without actual authorized proof.

ClickUp is read-only. Never push, open/merge a PR, post evidence, modify CI workflows, alter real tool homes or mutate cloud/DNS resources. Do not expose server URLs/tokens/account or tenant secrets. Known sibling integrations-catalog story has its own builder; preserve independent ownership and report concrete integration risks with evidence, not untested guesses.

Other problems outside scope go to found_else. Do not edit skills/memory. Report only new reusable proven `skill_lessons[{skill, lesson, evidence, enforce}]`; enforce is none or a one-line hook/test/lint/script proposal stating what and where. Empty is normal. End `MAIN SESSION: check and save these skill_lessons now.`
