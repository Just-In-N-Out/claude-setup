# SOL FIX R1 — 86bcm901u content quality gate — before Opus full review

## Current explicit user authorization overrides older review holds

Justin: “ok I think we have sol 6.1 fix these blockers and then we get opus 5.5 xhigh to review then get sol to fix again. Add this as a skill for future workflows”. THIS authorizes this local Sol fix pass now. It supersedes the old instruction to wait for both full reports before any fix. Sol full review already completed; Opus full review has NOT started. Do not wait for Opus before repairing valid findings. Stop ready-for-next-review; parent will send your corrected candidate to fresh Opus 5.5 xhigh after actual quota check. Do not dispatch other agents or edit shared workflow records.

Your role/model: FINISHER, fix-before-next-review; **Sol 6.1 xhigh**. Work only in the existing feature worktrees listed below. Preserve every explicit approved plan choice and acceptance boundary. You are NOT the final verifier.

## Actually load the role skills

First `engineering-best-practices`, then fresh `leorna`, `feature-dispatch`, `review-fix-cadence`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`, `security-best-practices`, `software-security-testing`, `cicd-staging-prod-agents`, `qa-testing-local-cloud`, `concurrent-state-validation`, `github`, `ci-failure-triage`, `multi-repo-issue-first-execution`, `infra-policy-security-gates`. Load `systematic-debugging` for unexpected failures. Read the three defect-loop skills' Stop-the-Line conditions, Planned Failures, Required Validation Gates and Current Transition sections and run the Agent Defect Loop where they apply. Successful tool results for actual loads are required, not a statement that you read them. If an active instruction contradicts this newest explicit review-order choice, this authorization wins; retain every unrelated safety/acceptance rule.

## Durable source material

- Approved plan `/Users/justin/.hermes/plans/leorna/86bcm901u-content-quality-gate.md`, including 1A–5A and story-only CI exception.
- Full Sol report `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-review-sol-r1/report.json` and `.md`.
- Exact received final findings `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-sol-review-received-r1.json`.
- Original reproducer scripts archived byte-identically under `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-review-sol-r1-tools/`; inspect archive-manifest.json. These originals bind historical absolute scratch/output paths. Copy/adapt only reproducible test entrypoints into your OWN scratch/output paths; never rerun report/finalizer writers over accepted review receipts. Do not alter archived originals.
- Builder evidence `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u/` (build-report.md, build-handoff.json, gates-summary.json, screenshots.json, artifact-inventory.json); original manifest has 260 payload files, keep it immutable.

## Exact writable worktrees and original candidate

- Client `/Users/justin/Leorna/leorna-client/.claude/worktrees/86bcm901u-content-quality-gate`, branch `feat/86bcm901u-content-quality-gate`, initial head `5544e7e9a34d3d16ca02792003cb2ce09510b52a`, feature base `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c`.
- Control plane `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-content-quality-gate`, same branch name, initial head `3317d09b91a430368d6a1615a2abc77bb140dbca`, feature base `0da9f5443a2a49b157cf24b5d30301345d371d3e`.

Both initially clean, each branched from its own main, two feature commits per repo. Verify current state before writes, and stop if an unexpected writer changed these candidate heads. Do not reset/rebase/recreate the feature branch or pull a sibling branch. Shared main, other sessions' prompt-kind and catalog worktrees, detached Sol review worktrees and untracked `deploy/local/` are not yours. Existing detached review snapshots remain immutable. If a legitimate fix needs a client edit, it is in story scope but explain why; do not churn an unaffected repo. Identity `Justin Issa <justin@leorna.com>`, no AI attribution.

## Complete first-review findings: preserve IDs and verify before fixing

### sol-01 — P1 — introduced / blocking

Claim: Detected secret-bearing values can be copied into compatibility reports and stderr through schema errors or real transformer warnings. The workflow uploads completed reports even when the gate fails, creating a retained disclosure channel despite scanner redaction.

Evidence: Two runtime-generated **noncredential synthetic canary** cases: real gitleaks detected github-pat in each; both JSON and Markdown reports retained the original canary. The schema-error case also echoed it to stderr. Both CLI executions exited 1; reproduction harness exited 0. Receipt `redaction-repro.json` under the Sol review evidence root. Original source CP3317d09: internal/library/gate/gate.go:194-207,225-241,350-366; report.go:22-29,59-69; cmd/content-gate/main.go:88; .github/workflows/ci.yml:138-145.

Direction: sanitize every content-derived diagnostic before report/log publication, including schema errors and real transformer warnings/errors. Retain item/tool/rule/path evidence safely and preserve failing exit semantics. Do not simply drop secret scanning, hide a failing gate, remove reports or erase useful item/tool identification. Review all output channels, not only scanner findings. Never test with real credentials.

### sol-02 — P2 — introduced / blocking

Claim: The CLI escapes stdout annotations but prints content-derived failures verbatim to stderr. Invalid item metadata containing a newline and an Actions notice command emits a standalone workflow-command line, bypassing the annotation helper's escaping.

Evidence: Healthy control exited 0; malformed metadata exited 1 and emitted one raw command line on stderr while its stdout annotation correctly contained %0A. Pinned primary Actions runner source confirms both streams enter command processing. Receipt `log-command-repro.json` and runner source/provenance in Sol review evidence. Source cmd/content-gate/main.go:88 and :69.

Direction: safely encode content-derived diagnostics on **every** log stream, not just stdout annotations. Full compiled-CLI stdout/stderr regression tests must demonstrate no standalone attacker-controlled workflow-command line, while genuine quality failure still exits nonzero and legitimate annotations remain useful. No hosted exploit has been run; do not claim a passing-gate bypass.

### Separate existing advisory — NOT authorized cleanup

GO-2026-5932 x/crypto/openpgp was independently corroborated as pre-existing module-only: verbose govulncheck exit0, no vulnerable imports/reachable symbols. Do not upgrade dependencies, add ignores or weaken audit merely to clean this out-of-scope advisory. Preserve as found_else evidence.

## Required proof and delivery

1. Verify findings against actual code and separately adapted runtime repros; capture vulnerable controls on original candidate before changes. Add lasting regression tests first and show RED for the actual unsafe outputs; do not count compilation failure, mocks that bypass real diagnostics, or helper-only assertions as the failure signal.
2. Implement the smallest maintainable correction. Review all schema, transformer and scanner diagnostic/report/CLI channels. Cover JSON/Markdown/stdout/stderr as relevant, weird newlines/control characters, valid diagnostics, and unchanged failure classification. Keep the planned accepted skips, OpenAPI-only repo boundary, real transformer command and immutable renderer pin model.
3. Run required local gates in every affected repo and combined renderer/gate checks. Reuse pinned real gitleaks and the real client renderer; regenerate any required local candidate-specific checks. If adding DB-dependent checks, allocate a task-owned isolated DB and verify deletion/absence afterward. No missing tool/test skipped silently, no weakening gates.
4. Run targeted sensitivity/mutation checks proving the new regressions detect restoration of each vulnerability, then restore exact passing source. Capture actual commands, exit codes, tool versions, source state and test identities. Re-run the complete applicable make check/module-add/CI-version lint/audit/matching-toolchain gates from the original role plan; document true unaffected-scope reasons rather than omit a required check. Preserve passing ordinary tests and expected fail/pass CLI controls.
5. **ClickUp evidence DURING the fix:** save real baseline-vulnerable and corrected test/report/CLI screenshots/logs, map them to both findings and affected acceptance criteria, and capture before the commits are finalized plus exact-head proof after committing. Only label a local saved-output preview as local; it is not hosted CI. Synthetic-canary-bearing raw proof stays private/local; create sanitized publication candidates and attest privacy review. No raw credentials, tokens, personal contents or synthetic-canary report bodies in screenshots/upload sets.
6. Commit scoped passing changes locally. Preserve base/history. Save final clean status, exact heads, changed files, test results and artifact hashes. Old builder/reviewer evidence is immutable; new outputs only under `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-sol-fix-r1/` and own scratch beneath configured TMPDIR. Supply updated screenshot/inventory manifests for THIS candidate.
7. Return **ready-for-next-review** if local fixes/gates pass, not done/accepted. Write `report.md` plus machine-readable `report.json` in your fix evidence directory, with old/new heads, commits/files, each finding disposition and red/green/sensitivity proof, actual test gates, screenshot provenance/privacy, any live/hosted holds, remaining risks, and the Required Validation Gates for the next independent Opus role. Propose any Docs & records updates for parent; do not edit shared board, continuity, skills or handoffs.

## Non-negotiable holds

- No push, PR, merge, remote CI execution, App/token/permission setup, cloud/deployment/cleanup or ClickUp posting. Justin must separately request these; status changes are his.
- Necessary workflow edits are allowed **for 86bcm901u only**, not unrelated CI cleanup; do not weaken existing checks.
- Real hosted good/broken runs, private client acquisition permission, published pin reachability, hosted artifact/job summary, prompt integration and final combined candidate remain NOT VERIFIED. Local screenshots/gates never satisfy missing hosted proof.
- Do not reverse accepted 1A–5A choices: reasoned transformer skips remain accepted limitations, actual errors/panics/silent zero output/schema or secret failures still fail. No import of client Go into CP, no transformer-interface or tenant/API changes.
- Do not widen into the separate pre-existing advisory or sibling feature work. Do not use a passing inherited suite as evidence that these two adversarial defects were fixed.

Parent next gate: inspect your artifacts/hashes and actual skills, verify heads/state, then fresh Opus5.5xhigh full review of updated complete ranges. After Opus, another Sol fix if valid findings remain; independent final review/verification still applies.
