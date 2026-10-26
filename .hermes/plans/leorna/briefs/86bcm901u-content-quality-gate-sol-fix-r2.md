# SOL FIX R2 — after Opus full review — 86bcm901u content quality gate

## Approved stage and stopping point

Role: **Sol 6.1 xhigh FINISHER**, second scoped fix pass. Justin already authorized: “sol 6.1 fix these blockers and then we get opus 5.5 xhigh to review then get sol to fix again”. That cadence applies now: original Sol review → Sol fix r1 → full independent Opus review COMPLETE with findings → THIS Sol fix r2 → fresh independent re-review → separate applicable Opus loop verifier. This is authorized local correction, not another build/product approval round or release permission.

Original sol-01/sol-02 were independently closed by Opus. Preserve both protections and their regressions. Verify all three new Opus findings before fixing; fix valid in-scope defects test-first. Include the two small introduced P3 diagnostics/help regressions in this scoped pass if the report is reproduced and the change preserves accepted choices. Do not broaden product behavior or undo a user choice to satisfy a suggestion. Return evidence-backed pushback for invalid/pre-existing findings.

Stop **ready-for-next-review**, not ready/released/accepted. No push/PR/merge/remote CI/App/credentials/permissions/deployment/cloud/ClickUp changes. Required later review, verifier and hosted/live acceptance remain unmet.

## Actually load role/context

First `engineering-best-practices`, then fresh `leorna`, `feature-dispatch`, `review-fix-cadence`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`, `security-best-practices`, `software-security-testing`, `cicd-staging-prod-agents`, `qa-testing-local-cloud`, `concurrent-state-validation`, `ci-failure-triage`, `multi-repo-issue-first-execution`, `infra-policy-security-gates`, and `github` as needed for read-only metadata. Unexpected failures require actual `systematic-debugging`. Read relevant project AGENTS/shared notes and each applicable loop skill's actual Required Validation/Iteration/Exit clauses. Record successful tool loads and executed gates; a checklist alone is insufficient. No nested agent spawning or self-review.

Approved plan `/Users/justin/.hermes/plans/leorna/86bcm901u-content-quality-gate.md`; accepted1A–5A remain. Story-only CI exception permits necessary workflow changes but no weakened check or unrelated CI cleanup.

## Exact input and ownership

Writable feature worktrees ONLY:
- CP `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-content-quality-gate`, branch `feat/86bcm901u-content-quality-gate`, starting HEAD **5f7a79180533244fbed850c708e2c3e2cff78e10**, feature base **0da9f5443a2a49b157cf24b5d30301345d371d3e**.
- Client `/Users/justin/Leorna/leorna-client/.claude/worktrees/86bcm901u-content-quality-gate`, same branch, starting HEAD **5544e7e9a34d3d16ca02792003cb2ce09510b52a**, base **8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c**. Expected unchanged; do not churn it without actual necessity.

Parent rechecked exact tips and full clean status. Recheck before writing; stop on an unexpected writer/head/delta. Preserve both main checkouts, prompt/catalog siblings and their DBs/caches, all prior detached review worktrees and untracked deploy/local/. Do not reset, rebase, recreate branches, integrate siblings or change personal tool homes. Identity Justin Issa <justin@leorna.com>, no AI attribution.

Claim NEW output `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-sol-fix-r2/` atomically; stop if it already exists. Use own scratch under TMPDIR and owned cache/DB names. Prior evidence is immutable, including the Opus review. Propose shared Docs & records changes for parent only; no shared board/notes/handoffs/skills edits.

## Complete review source and preserved proof

Authoritative full Opus report root `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-review-opus-after-fix-r1/`:
- report.md SHA-256 **8f3eeba10a5e7226cd4a1efb16c3dfa549b66ebed37d62d9e067708a84f54fd5**.
- report.json SHA-256 **97627364b9b7d0526837b13e8820e329d0db262e7568288409047733c48cb8c7**.
- `adv-summary.json`, `adversarial/`, `gitleaks-probes/`, mutation summaries/logs/harness and private-proof inventory. Parent verified report hashes, actual177 evidence-file count, and16 actual successful review skill loads; recorded per-file intake OUTSIDE the review root at `evidence/86bcm901u-opus-after-fix-r1-parent-file-intake.json`. This is metadata intake, not parent app verification.

Prior Sol fix r1 evidence `evidence/86bcm901u-sol-fix-r1/` (127 sealed payloads, manifest502f17a86dd09f928f24e86dfe2e748a36652f3688913009464585dc98b0118a) and original first-review evidence remain useful provenance, NOT writable runtime output. Raw six Opus synthetic-token fixtures are private under scratch/86bcm901u-opus-after-fix-r1/adv-private and expire with scratch retention; use their inventory/harness as leads and generate your own noncredential regressions. Do not copy raw canary bodies into publication evidence or depend on ephemeral absolute paths in committed tests. Never replay report/finalizer writers over accepted artifacts.

## Findings — preserve IDs and reproduce independently

### opus-01 — P2 blocking, introduced by ORIGINAL gate d6f5895 (not main/pre-existing)

A library-root `.gitleaksignore` silences the gate's secret scan. gitleaks8.30.1 still reads `<library>/.gitleaksignore` even with `--gitleaks-ignore-path` pointing at an empty directory. Gate parse rejects symlinks but loader does not enumerate root entries. README91–92 and secrets.go comment falsely claim the ignore file is not honored.

Real compiled-CLI witness: shipped library plus runtime synthetic github-pat in `items/skill/code-review-checklist/body.md:10` exits1 with secret-scan finding. Add root `.gitleaksignore` containing `<absolute library path>/items/skill/code-review-checklist/body.md:github-pat:10` and same CLI exits0/PASS with secrets pass. Relative fingerprint does NOT suppress it; a root `.gitleaks.toml` is correctly overridden by explicit config. Locations `internal/library/gate/secrets.go:16–19,62–70`, gate.go parse263–283, library/source.go61–103, library/README.md91–92. Evidence adversarial/ignore-bypass, secret-item, gitleaks-probes and adv-summary.

Important bound: repo-wide `gitleaks git` still catches the nested-ignore secret (scratch-repo exit1/one finding). Therefore this is a proven per-library/local-gate bypass, NOT proof that this repo's full hosted required job succeeds with secrets. No hosted run happened.

Small scoped direction: fail schema/gate independently of scanner suppression when root contains anything except library.json and items/ (or an equally strong tested correction preventing in-library suppression). Prefer gate-local validation if it avoids widening a shared loader contract unnecessarily. Verify shipped library layout, all unknown-entry/ignore/path/symlink behavior and useful nonleaking diagnostics. Correct documentation claims. Add lasting REAL gitleaks8.30.1/compiled-CLI regression using the actual absolute fingerprint; show vulnerable RED/PASS-with-secret, corrected gate failure, ordinary good library still passes, and a mutation disabling the new guard is killed by the intended regression. Do not remove scanner, skip failures, weaken repo history scan, add allowlists or claim fix solely from a mocked scanner.

### opus-02 — P3, introduced by Sol fix r1

When a secret is detected and an operational error also occurs, safe withholding erases the non-content failure category and points at rule/path/line evidence never emitted. Actual secret plus pin file1111…1: exit2, only “diagnostic withheld…see secret-scan rule/path/line evidence”, no report or structured findings shown. Without secret, operator sees pin-mismatch category. errors.Is is retained internally but CLI prints Error(). Locations gate.go199/224/228/232/237–238, diagnostics.go19–29, CLI main.go72–78; evidence secret-plus-unpinned/unpinned-control.

Verify and preserve a SAFE constant/sentinel classification and/or actual structured evidence on this operational path; never reintroduce raw source/child diagnostic disclosure, print untrusted pin/path values unsafely, or promise a nonexistent report. Test real compiled CLI combining actual secret+pin mismatch and other useful operational controls, keep exit2, prior sol-01 privacy and sol-02 encoding/genuine annotation protections.

### opus-03 — P3 nit, introduced by Sol fix r1

Trusted help/flag usage is encoded as one unreadable line (`Usage of content-gate:%0A ... %09...`) for -h, unknown/missing flags. main.go44–53. Safe/exit2 unchanged; readability regression. Verify and encode trusted usage line-by-line while keeping untrusted flag content/any derived text safe from Actions commands or raw controls. Test actual CLI help/unknown/missing flags and malicious flag values, legitimate readable line structure, no executable injected commands and unchanged exit classification. Do not globally bypass the encoder or undo sol-02.

## Required executed proof and preserved behavior

- Verify each claim with meaningful control before changes; lasting TDD regressions fail for the intended behavior, not missing tools/parser/setup errors. Fix blockers first, then verified small same-scope P3s. Existing gates green do not contradict adversarial bypass; do not weaken inherited tests to obtain green.
- Preserve closed sol-01 and sol-02, accepted reasoned agent skips, real errors/panics/schema/secrets failing, silent zero-output rejection, OpenAPI-only repo boundary, transformer/Connector interfaces, immutable40-character client pin and true item/tool/structured evidence.
- Execute applicable canonical CP make check + test-module-add, focused/race real-binary regression/sensitivity suites, true shipped/broken/scanner/renderer/CLI operational controls, and required client gates per approved role contract (client make check,39 UI tests, CI-version lint/audit on unchanged head). Record actual candidate/consumed-source hashes, commands/exits/toolchain versions/test identities/skips. Use installed matching Go1.27.3, lint2.14.0 built with matching Go, govulncheck1.7.0, gitleaks8.30.1, GNU realpath and compatible Bash. No missing required tool/test silently skipped.
- Opus's initial client make check failed because its OWN GOPROXY=off blocked the oapi-codegen deprecation lookup. It preserved the failure, selected a task-local offline `file:///Users/justin/go/pkg/mod/cache/download` module-cache proxy with checksum DB left ON, then canonical make check passed. Reuse a correctly scoped environment if relevant; do not change global config or disable checksums. Wrapper exit0 never substitutes for actual gate exit2/1.
- Use a task-owned local test DB ending `_test`, e.g. leorna_86bcm901u_sol_fix_r2_test; verify fixture guard, OID/owner and actual required DB-backed methods. Drop ONLY your DB and read absence back. Do not touch sibling leorna_catalog_review_opus_r1_test or any existing DB/container.
- Meaningful targeted mutants with intended failed tests and positive controls, original oracles unchanged, exact source restored in finally; passing final affected gates after restoration. Distinguish aggregate/negative-control exits from required failures. No full-suite count invented from nonverbose make output.
- **Capture ClickUp evidence DURING fixes:** real before/after controls and logs/screenshots, corrected exact-head privacy-safe AC/report proof. Label saved-local output previews as local, NOT hosted CI/native app/manual server proof. Raw synthetic canary bodies stay private; publication candidates separately enumerated/scanned, never upload without post. Preserve original failed witnesses/report hashes and all current mutation restoration receipts.
- Commit only scoped passing changes locally on the SAME feature branch. Run final gates against exact committed head or bind precommit consumed bytes exactly and explicitly. Both feature worktrees clean at handoff; no AI attribution.

## Handoff and unwaived holds

Write report.md/report.json, candidate/source state, executed gate receipts/logs, each finding disposition with RED/GREEN/control/mutation evidence, exact old/new heads/commit/files, screenshots/manifests/hashes/privacy, scoped failed-attempt diagnoses, actual loaded skills/loop Required Validation Gates, DB absence and precise remaining acceptance holds. Seal a complete artifact inventory; parent intake must remain outside it.

Return ready-for-next-review; parent performs fresh independent re-review, then applicable separate Opus verifier. Do not label final acceptance complete. NOT VERIFIED: hosted good/broken Actions runs/artifact/job summary, user/org-owner App/private client acquisition, pushed client pin reachability/workflow auth, prompt-kind integration/refreshed compatible pin/combined candidate checks. The pre-existing GO-2026-5932 module-only advisory is out of scope: no dependency upgrade/ignore or weakened audit.

No push, PR, merge, remote CI run, credential/permission/App/cloud/deploy action, real tool-home write, ClickUp status/post or other-owner cleanup. Preserve existing approval boundaries. Check actual disk before heavy work, reuse installed caches/tools and stop heavy writes below1.5Gi rather than exhaust disk or delete someone else's files. Report genuine permission/design/resource blockers rather than inventing output or silently broadening scope.
