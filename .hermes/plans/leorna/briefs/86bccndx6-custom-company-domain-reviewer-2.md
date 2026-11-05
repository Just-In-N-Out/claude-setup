# REVIEWER 2 — 86bccndx6 custom company domain

DISPATCH HOLD: wait for fixer handback and actual head. Round 2 is a fresh FULL review of the whole story, not only the fix. Main must replace PENDING_FIXER_HEAD before dispatch.

## Role, candidate and scope

Fresh configured pipeline_reviewer, Astra xhigh, fork_turns none. Round 2 FULL review, report only. Do not change product files, fix code/tests, commit, rebase, publish or spawn agents. You are not alone; preserve sibling work and use owned scratch. Do not invoke a separate reviewer: you are the independent reviewer.

Repo/worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`.
Branch: `feat/86bccndx6-custom-company-domain`.
Base: `3aa979df41568c9039007f66d7f32193e66a8533` (merge-base with origin/main confirmed at dispatch).
Reviewed HEAD: PENDING_FIXER_HEAD.
Approved plan: `/home/justin/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`.
Evidence: `/home/justin/.hermes/plans/leorna/evidence/86bccndx6`.
Your report/probes/receipts only: `<evidence>/review-2/` and your owned scratch.

Builder handback is `<evidence>/builder/report.md`; candidate artifacts and reproduction recipes are in that folder. Read them as context, not independent proof. Owned builder containers are stopped; create/use your own containers/DBs or explicitly reconcile ownership before any reuse, and never share one resettable DB across parallel gate processes. Docker Desktop now works. The pinned client SHA is `feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6`. Builder reports full make check, PostgreSQL test-level skip verification, image/deployment/scanner, client and 13 capped mutation checks passed. It explicitly does not claim initial named-test RED for composed AC3/AC6; focused RED/GREEN and supporting real base behavior receipts exist. Evaluate actual assertion coverage yourself. Live AC4 has no authorized target/grant. No new plan approval is needed for review.

Justin approved all recommended plan choices and AC1–AC6. Scope is installer-owned configuration for one unused direct-CNAME subdomain, hosted-admin display, DNS/TLS-gated activation, generated-host continuity, strict boundaries and non-destructive recovery. Control-plane-only production changes; unchanged pinned client is a real consumer check. No live target/grant exists unless main supplies a later exact user grant. AC4 is live and remains owed if unavailable. No new auth bypass, cross-repo Go imports or weakened client origin/redirect rules.

## Previous review and fix

Read `<evidence>/review-1/review.json`, report.json and the fixer's handback/dispositions in `<evidence>/fix-1/` once main supplies the actual paths. Previous reviewed head was 6125c7e4da64bafbe2f8d1ec413abb8a553f8f5a. R1-1 was P1: the real TLS probe rejected the actual control-plane root's normal 303 redirect, blocking activation/resume; canonical fixtures stubbed the probe. Independently rerun its actual reproduction and controls using the report's exact file list, then review the whole base-to-new-head story. Verify strict discovery redirects and DNS/TLS/project/network/tenant guards remain correct. Review assertion and plan-interpretation changes, not just the repair's passing summary.

If the same defect persists, mark repeats R1-1; new_fact must be a concrete genuinely new fact with at least five words. Do not relabel old findings to evade the loop brake. Assess rejected fixer dispositions with evidence. New full-story defects remain in scope for this second Full review.

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

Write `<evidence>/review-2/review.json` with round 2, scope full, from exact base SHA, head exact candidate SHA, findings array. Each finding has id R2-N, severity P0/P1/P2/P3, file_line, claim, and concrete real-use scenario (at least five words for P0–P2). P0/P1: security hole, guard bypass, false AC or wrong block breaking normal work. P2: plausible user/agent bug or realistic edge case, AC/UI failure or ineffective test. P3: cosmetic/docs, deliberate evasion only or unsupported-machine setup. No concrete real-use scenario means P3. Do not inflate findings from hypotheticals; do not downgrade substantive AC failures.

Self-check the JSON with review-check.sh for your repo/base/evidence, fixing only report format if exit 2. Main follows the referee's result; you do not fix findings or advance the pipeline. Return verdict, findings, ac_status per AC, exact gates/probes with outcomes, report path, head/base and skill_lessons. A report must not label live AC4 passed without actual authorized proof.

ClickUp is read-only. Never push, open/merge a PR, post evidence, modify CI workflows, alter real tool homes or mutate cloud/DNS resources. Do not expose server URLs/tokens/account or tenant secrets. Known sibling integrations-catalog story has its own builder; preserve independent ownership and report concrete integration risks with evidence, not untested guesses.

Other problems outside scope go to found_else. Do not edit skills/memory. Report only new reusable proven `skill_lessons[{skill, lesson, evidence, enforce}]`; enforce is none or a one-line hook/test/lint/script proposal stating what and where. Empty is normal. End `MAIN SESSION: check and save these skill_lessons now.`
