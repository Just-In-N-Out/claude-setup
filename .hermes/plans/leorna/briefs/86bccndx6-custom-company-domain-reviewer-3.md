# REVIEWER 3 — 86bccndx6 custom company domain

DISPATCH HOLD: populate fixed HEAD from fixer 2 handback and check earlyoom/lessons first. This is a fresh DELTA review from the previous reviewed head, plus the code/behavior touched by those fixes. Main must obey any later review-check request for a full review.

Fresh configured pipeline_reviewer, Astra xhigh, fork_turns none. Read-only product review; report findings, never fix source or spawn other agents. You are not alone; preserve sibling work/resources.

Worktree: /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain
Branch: feat/86bccndx6-custom-company-domain
Story base: 3aa979df41568c9039007f66d7f32193e66a8533
Review from: 24c13fd1f3908836aa2cd020eee295770913fb53
Candidate HEAD: PENDING_FIXER2_HEAD
Approved plan: /home/justin/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bccndx6
Your own outputs: <evidence>/review-3/ and owned disk scratch.
Pinned unchanged client: feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6

## Context and scope

Justin approved the single plan and recommended choices 1A–5A, AC1–AC6. Full review 1 found R1-1 P1 (TLS root redirect); fixer 1 corrected it. Full review 2 confirmed that repair, but found distinct R2-1 P2: generated-domain recovery cannot restore an omitted LEORNA_GENERATED_BASE_URL alias because it first requires generated discovery to work. Custom origin still works; recovery makes no writes. Review-2's exact production probe and control are in recovery_probe_test.go, recovery-overlay.json and recovery-probe.log. Read those actual file lists/receipts, not a glob-based subset.

Review-2 returned ASK JUSTIN because one P0–P2 remained in each round. Justin chose option 1, continue fixing then review/verify; his verbatim reply "1" and continue true are in review-2/justin.json. Main reran the referee: REVIEW AGAIN, fix then review the fix commits. No finding is waived or accepted as a limitation.

Read all earlier review JSON records and reports, fix-1/report.json and fix-2/report.json/dispositions. They provide context, not independent proof. Reproduce R2-1 and the valid controls independently, assess its disposition, and review every new fix commit and the areas it touches. Check that installation/project/tenant verification, DNS/TLS readiness, redirect/public-address rules, retry/recovery and the approved AC clauses remain intact. Include test assertion and documentation changes in review. Preserve R1-1's real probe/router coverage. Do not broaden into a new whole-story review absent a concrete dependency or referee requirement; report unrelated discoveries in found_else rather than editing anything.

If a finding persists, identify repeats R2-1 or R1-1 as appropriate; new_fact must be a concrete genuinely new fact of at least five words. Never relabel a repeat to bypass the brake. A rejected fixer finding needs evidence-based assessment. Main does not judge severity or correctness.

## Mandatory actual reads

Open global /home/justin/.claude/CLAUDE.md, applicable AGENTS.md/project CLAUDE.md, approved plan and current Leorna shared memory/ownership. Actually open these SKILL.md files under /home/justin/.agents/skills/ in order: leorna, engineering-best-practices, requesting-code-review, code-review-practice, review-fix-cadence, mutation-testing-discipline, security-best-practices, multi-tenant-auth-management, api-contract-drift-guard, backend-data-migrations. Open applicable references; systematic-debugging before investigating unexpected failures; github for GitHub reads. Read /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md and ac-verification.md. Role instructions supersede skill defaults to auto-fix or spawn agents. Return read receipts.

## Acceptance and checks

- AC1 TestCustomDomainRegistrationShowsCNAME: selected binding and CNAME instructions.
- AC2 TestCustomDomainActivationPreservesGeneratedAccess: verified activation and old-host continuity.
- AC3 TestCustomDomainFailureKeepsGeneratedAccess: clear failures without breaking generated access.
- AC4 (live) TestCustomDomainLiveClientDiscovery: approved real DNS/TLS and actual client consumer; no grant/target supplied.
- AC5 TestCustomDomainGuardsAndRetry: authority/project/network/tenant checks and valid controls.
- AC6 TestCustomDomainResumeAndRecovery: safe resume, old-server rejection, interruption and generated recovery without deleting resources.

Check actual approved clauses against assertions and changed behavior. Run sufficient independent quality/security gates and meaningful negative/positive controls to assess the fix and affected ACs, retaining current-head receipts/screenshots. No live acceptance from fixture results. Reproduce baseline/tool failures in an owned isolated copy if necessary; environment absence never means pass. Use actual CI-compatible executable bindings. Database coverage requires Go JSON per-test Action/Output accounting with no missing-DSN skips. Use a separate owned _test DB for every concurrent resettable process; never reuse sibling DBs. Run scripts/test-module-add.sh serially with make/image gates because it mutates go.work. Serialize lint invocations if the tool lock is shared; preserve and clearly qualify interrupted gate receipts.

All mutations on WSL use systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 and small scalar assertions; consult the mutation skill for a session-bus failure rather than removing the cap. A killed/137/143/SIGTERM command requires earlyoom inspection before interpretation and any runaway must be reported. Scratch, TMPDIR, Go builds and Chrome profiles belong in owned disk folders under /home/justin/.hermes/cache/scratch, never shared RAM-backed /tmp. Read-only overlays or isolated scratch copies only. Preserve original source hashes/clean git state and clean only owned resources.

## Report/referee

Write <evidence>/review-3/review.json with round 3, scope delta, from 24c13fd1f3908836aa2cd020eee295770913fb53, head exact candidate SHA, findings array. IDs R3-N. Each finding needs severity, file_line, claim; P0–P2 needs a concrete real-use scenario of at least five words. P0/P1 is security/guard bypass, false AC, or wrong block breaking normal work. P2 is a plausible bug/realistic edge case, broken AC/UI or test that cannot fail. Cosmetic/docs, deliberate evasion only and unsupported-machine setups are P3. Apply the skill definitions; do not invent hypothetical blockers.

Self-check report format with review-check.sh using the story base, repo and evidence root; correct only report formatting on exit 2. Return verdict, findings/dispositions, exact head/base/from, ac_status for each AC with test/screenshot/evidence, actual checks and outcomes/limitations, review.json path, found_else and skill_lessons. Main runs the referee and advances the pipeline.

## Boundaries

ClickUp read-only. No source/test edits in candidate, commits/rebase/main bring-in, push/PR/merge, posts/uploads, CI workflow changes, cloud/DNS actions/deletions, live registry upload or real tool-home/identity changes. Existing auth mode and strict client policies remain. No real addresses, credentials, private account/tenant data in messages or drafts. Live AC4 remains not_run until exact scoped permission is supplied separately. No prior target grant carries over.

Never edit skills/memory. Report only new reusable proven skill_lessons[{skill,lesson,evidence,enforce}], enforce none or one-line hook/test/lint/script check plus where it runs. Empty is normal. End MAIN SESSION: check and save these skill_lessons now.
