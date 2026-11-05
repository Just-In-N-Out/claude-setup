# FIXER 4 — independent AC4 audit finding, 86bcm927y

Fresh configured pipeline_fixer, Astra xhigh, fork_turns none. Main orchestrates, no nested agents. Dispatch only after parent paired ac-check reports NOT ACCEPTED for this attempt; read its actual output, never infer acceptance from this brief.

Worktree /home/justin/Leorna/86bcm927y-integrations-catalog-tiles
Branch feat/86bcm927y-integrations-catalog-tiles
Starting HEAD 1f8562aadc5f233f8cf66f07daa3d0e0134e81f4
Story base 3aa979df41568c9039007f66d7f32193e66a8533
Evidence root /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Own output evidence root/fixer-4/
Approved plan evidence root/plan-approved.md, unchanged-architecture/gates annex plan-approved-v1-original.md, authority amendment-approval.json
Inputs: parent ac-check-attempt-1.txt, verifier/ac.json and verification-report.json/found-else.json; auditor/ac.json and its final structured report/actual supporting probes; all review-1 through review-3/review.json plus earlier fixer dispositions. Preserve these historical files unchanged.

## Assignment and approval

Parent paired gate on 2026-11-05 returned exactly:
```
AC1  ACCEPTED
AC2  ACCEPTED
AC3  ACCEPTED
AC4  NOT ACCEPTED: auditor did not accept it
REVIEWS  CLEAN: review-3 at 1f8562a is clean
NOT ACCEPTED: 1 of 4 ACs on 1f8562a
```
Exit1. Auditor final structured report is auditor/audit-report.json. Finding AUD-1 P2 at internal/web/integrations_test.go:730: the update revision assertions are conditional on an integration.update row already existing; M8 relabels all updates integration.configure and named AC4 still passes. Browser test and stronger auditor diagnostic reject M8; diagnostic passes unchanged head. The auditor's supplemental rollback terminal screenshot is missing after a stalled capture, though its actual AC4 browser screenshot and rollback logs exist. Complete current-head evidence in your own folder; preserve prior omission honestly.

Verify the auditor's concrete finding using receiving-code-review, reproduce its mutation/sensitivity result, and fix valid findings or reject with evidence. Ownership: the AC4 audit acceptance test and directly related supporting regression coverage. Current product behavior has been observed correct; the reported gap is that the primary test accepts update events mislabeled as integration.configure. Establish the truth yourself. Do not broaden to unrelated product changes. If a real in-scope product defect is proven, report and fix it test-first; don't manufacture one to justify a test improvement.

Use the applicable TDD/mutation rules for coverage-only work: preserve proof the original test survives the deliberate defect, demonstrate strengthened assertions reject it at the intended reason, and prove unchanged correct behavior still passes. Ensure the named AC4 test enforces every approved assertion implicated by the finding; avoid merely adding another supporting test while leaving the same named-test gap. Reconcile the entire approved AC4 assertion list and the auditor's report before changing it; never weaken expectations. Supporting rollback/deeper-guard evidence and its honest found_else limits remain part of the contract.

Justin's original implementation go and repeated explicit B selection authorize this local repair. Active amendment's historical proposed/not-approved prose is superseded by amendment-approval.json. Google is informational/unavailable, save/update409 after auth/CSRF, new selection including legacy UUIDs denied, old rows/snapshots preserved; native Google client-ID capability explicitly deferred. Do not reopen choice or falsely pass historical Google positive evidence. Preserve all approved GitHub/ClickUp and URL/tenant/audit behavior. Original commit-subject P3 remains follow-up; no history rewrite/rebase.

## Required skills and rules — actually open

/home/justin/.agents/skills/<name>/SKILL.md: leorna FIRST, engineering-best-practices, receiving-code-review, requesting-code-review, code-review-practice, review-fix-cadence, test-driven-development, mutation-testing-discipline, systematic-debugging, security-best-practices, multi-tenant-auth-management, api-contract-drift-guard, backend-data-migrations, git-commit-rules. Read required references/mandatory loops and retain successful read receipts. Main supplies independent roles; no nested agents.

Read actual /home/justin/.claude/CLAUDE.md, /home/justin/.codex/AGENTS.md, applicable project/ancestor AGENTS/actual CLAUDE and Leorna shared context. Never edit generated AGENTS or commit CLAUDE. Read dispatcher references/review-loop.md and ac-verification.md under /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/.

## Approved criteria and completion

- AC1, TestIntegrationsAC1TilesWithPostgres: three descriptive tiles/declared labels; Google unavailable without editable/save/false-ready UI, GitHub/ClickUp forms.
- AC2, TestIntegrationsAC2ValidateWithPostgres: approved validation/save/update/revision behavior, valid DNS/IPv6/ports; malformed values/refused Google writes leave settings/revisions/audit unchanged, proper auth/CSRF precedence/no echo.
- AC3, TestIntegrationsAC3PackBuilderWithPostgres: supported settings in actual new/existing packs/native previews, immutable snapshots/digests/tenant isolation, Google IDs denied.
- AC4, TestIntegrationsAC4AuditWithPostgres: exactly correct create/update audit records, actor/tenant/target/redacted metadata/revisions, no events for rejected/noop/stale operations, transaction rollback.

Full frozen clauses and assertions control; none live. Don't change plan/approval or relabel unrun local checks live.

Verify exact starting SHA and full tracked/untracked clean state. Preserve genuine RED/green/mutation evidence and source/commit binding. Run required complete project gates and affected tests on final source, real PG/ClickHouse bindings, per-test JSON audit, all required services actually exercised. Retain exact exits and optional skips. Browser evidence and per-AC captures/recording must match final head as required by approved contract; inspect actual images/recording. No fabricated replay or filename-only success.

Commit relevant narrow changes locally using configured Leorna identity and scope fix(86bcm927y), explicit staged paths, CLAUDE unstaged, no AI trailer or metadata override. All relevant edits go into reviewed fix commit; no unchecked tail. Return ready-for-next-review only when required qualification complete, with actual final SHA/clean state, changed paths, each finding disposition and test/commit, gate/skip inventory, ac_status/evidence map, defect_loop_skills, found_else, skill_lessons.

Next parent stage: fresh DELTA review4 from 1f8562aadc5f233f8cf66f07daa3d0e0134e81f4 to your head and touched code -> review-check until MOVE ON -> fresh verifier2 -> fresh blind auditor2 -> paired ac-check. Parent will use new acceptance-attempt folders to preserve previous reports. Do not perform those roles yourself.

## Environment, resources and boundaries

You are not alone in this codebase. Preserve other agents' changes, branches, processes, databases and worktrees, including sibling custom-domain story under /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain. No shared DB resets or worktree prune. No client changes, CI workflow edits, push, PR, merge, ClickUp writes/uploads, external messages, provider sign-in/cloud actions or real credential/tool-home writes.

Create fresh owned disk scratch under /home/justin/.hermes/cache/scratch; explicitly bind writable GOCACHE and disk TMPDIR before Go commands. Keep large caches/build/browser files off RAM-backed /tmp; short Chrome TMPDIR/profile. Prepared Go at /home/justin/.local/leorna-toolchain/go/bin/go, linter/govulncheck under /home/justin/.local/leorna-toolchain/bin, Helm/OpenTofu/Trivy binaries under /home/justin/.hermes/cache/scratch/86bcm927y-builder-JZLvCI/bin; verify versions/survival. No global PATH/auth/settings changes; task-local Make bindings only. Owned anonymous Docker/Buildx state allowed for public image operations; don't copy credentials.

Fresh unique bounded loopback PostgreSQL/ClickHouse fixtures and _test databases, authenticated readiness before gates. PostgreSQL must enforce password/SCRAM; trust invalidates wrong-password checks. Serialize any checks/mutations/migration operations that reset the same schema, or use distinct owned databases for parallel runs. Never report interference/setup failure as product behavior. Audit all required DB tests, including 7web/4knowledge ClickHouse cases. Optional provider tests stay honestly skipped; hosted CI unrun absent publication.

All mutations under systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0, documented same-user session-bus fallback only after verifying it; no uncapped/global restart. SIGTERM/137/143/Killed: check earlyoom, report command/time/size and diagnose before capped retry. Browser unset DISPLAY/WAYLAND_DISPLAY; documented flags, bounded serialized captures/navigation; nonce-CSP errors require real response navigation. Avoid heavy builds overlapping capture.

For this run retain owned scratch and list its paths at handback instead of launching filesystem removal calls. Stop/remove only own services/image if feasible, retain evidence. Prior scratch belongs to other roles; don't remove it. Do not read /home/justin/.hermes/.env or expose secrets. Setup sync known read-only even escalated; parent handles, no bypass.

## Lessons

Never edit skills/shared memory. Return skill_lessons[{skill,lesson,evidence,enforce}], enforce none or proposed check kind/what/where. Empty normal; only new reusable proven lessons, no duplicate of already documented memory cap/cache/browser handling.
End exactly: MAIN SESSION: check and save these skill_lessons now.
