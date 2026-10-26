# HOLD — SUPERSEDED ORIGINAL-CANDIDATE OPUS BRIEF — DO NOT DISPATCH

Justin now authorized **Sol fixes before Opus full review**, then Sol fixes valid Opus findings. Fixer sa-0-cb9f50f7/deleg_cfd35f91 is running under `86bcm901u-content-quality-gate-sol-fix-r1.md`. This document retains historical original-head ranges/findings only; EVERY earlier wait-for-both/no-finisher-yet instruction below is superseded. After fix return, parent must verify corrected exact heads, full feature ranges, gates and evidence and write a NEW Opus review brief against that candidate. Do NOT launch Opus against the old ranges below or infer a quota reset. New standing skill `review-fix-cadence` governs. All independent-review and no-publication holds remain.

# Historical REVIEWER-OPUS — original 86bcm901u candidate (reference only)

**Your role tag is `opus`.** Use it for every <role> path/name in the assignment below. You are a fresh full reviewer, never the builder.

**Sequencing approved by Justin 2026-10-22T20:04:28Z:** you are the SECOND full reviewer, after the existing fresh Sol review returns. The parent must verify actual Claude quota before dispatch; no second Sol substitution was authorized and the reset is not assumed. Independently review both exact candidates; do not treat the first reviewer as your oracle. Both full reports precede the finisher. This ordering exception is round 1 only; verifier remains fresh Opus.

## SECOND REVIEW READY — Sol has returned; wait only for verified Opus quota

Sol full review `deleg_4047b8b5` completed with **two introduced blockers**, no fixes. Both original candidate heads remain unchanged/clean, and both Sol detached review worktrees are clean. Parent verified the report SHA-256 `4af26b75adc0c5e25e19e0a5bff5dc13fdd5dbb2dc151e46ee06a5b88ec2b784` and all mandatory successful skill loads. Justin chose **Opus second, no Sol substitute**. Live quota at 2026-10-22T20:41Z was 92% session used, reset due 2026-10-22 17:19 EDT; parent must verify actual availability before dispatch, not assume reset.

You still perform a FULL independent review of both exact ranges below, not merely confirm the first review. After your independent audit, reproduce/corroborate or challenge these reported findings with real controls:

1. **sol-01 (P1, introduced, blocking)** — “Detected secret-bearing values can be copied into compatibility reports and stderr through schema errors or real transformer warnings. The workflow uploads completed reports even when the gate fails, creating a retained disclosure channel despite scanner redaction.” Key evidence: “Two runtime-generated noncredential canary cases: real gitleaks detected github-pat in each; both JSON and Markdown reports retained the original canary. The schema-error case also echoed it to stderr. Both CLI executions exited 1; reproduction harness exited 0.” Source control-plane 3317d09, gate.go:194-207/225-241/350-366, report.go:22-29/59-69, CLI main.go:88, ci.yml:138-145. This is disclosure, NOT a claimed passing-gate bypass.
2. **sol-02 (P2, introduced, blocking)** — “The CLI escapes stdout annotations but prints content-derived failures verbatim to stderr. Invalid item metadata containing a newline and an Actions notice command emits a standalone workflow-command line, bypassing the annotation helper's escaping.” Key evidence: “Healthy control exited 0; malformed metadata exited 1 and emitted one raw command line on stderr while its stdout annotation correctly contained %0A. Pinned primary Actions runner source confirms both streams enter command processing.” Source CLI main.go:88 and :69. This is real local CLI output + pinned primary runner-source analysis, NOT a hosted exploit or required-job success bypass.

Complete received findings (parent saved from final result, not a truncated transcript): `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-sol-review-received-r1.json`. Original report/receipts: `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-review-sol-r1/{report.md,report.json,redaction-repro.json,log-command-repro.json}`. Primary runner source and provenance are in that same evidence dir.

Original reproducer/helper scripts are now archived byte-identically with hash/size verification under `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-review-sol-r1-tools/` (archive-manifest.json, seven files). **These originals retain their historical absolute scratch/output bindings.** Inspect and adapt a SEPARATE runnable copy to your worktrees/output roots; do not overwrite accepted evidence or rerun report/finalizer writers. Original scratch remains provenance, not a durable runtime dependency. Raw redaction reports intentionally contain synthetic canaries, NOT real credentials, and are NOT uploadable evidence.

No finisher has run. Both full reports must exist before the parent merges findings and assigns the Sol fix pass; fresh re-review and independent Opus loop verification remain mandatory afterward. Do not fix anything yourself or relabel passing existing tests as closure of these adversarial failures. No publication, hosted execution or ClickUp write is authorized.

# Full independent review — 86bcm901u-content-quality-gate, round 1

## Assignment and immutable candidate

You are a fresh REVIEWER, not the builder or finisher. Perform a **full review of BOTH repositories** against the approved Opus plan and all story acceptance criteria. This is not a source-only review or permission to fix anything. Your dispatch context specifies your model and unique role tag (sol or opus).

Approved plan: `/Users/justin/.hermes/plans/leorna/86bcm901u-content-quality-gate.md`.
Builder evidence (read-only): `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u/`.
Read `build-report.md`, `build-handoff.json`, `gates-summary.json`, `final-repo-state.json`, `screenshots.json`, mutation receipts and raw logs as needed. These are builder claims to verify, not a substitute for your own checks.

Review exact immutable ranges:
- Client root `/Users/justin/Leorna/leorna-client`; **base** `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c`, **head** `5544e7e9a34d3d16ca02792003cb2ce09510b52a`; 3 changed files, two local commits.
- Control-plane root `/Users/justin/Leorna/leorna-control-plane`; **base** `0da9f5443a2a49b157cf24b5d30301345d371d3e`, **head** `3317d09b91a430368d6a1615a2abc77bb140dbca`; 29 changed files, two local commits.

Parent independently checked both exact heads, clean worktree/index status, Justin's Leorna author identity and scoped diff stats. Builder evidence manifest `artifact-inventory.json` SHA-256 is `f2105fa2592b14ed9a21635faaba241d81bff6af2eb436908d1960bdbc3a4cbb`; parent verified all **260 enumerated files**, size/hash equality and no missing/extra payload files. Manifest itself is additional. Evidence already lives durably, not only in scratch. Do not edit it or regenerate its receipts.

## Mandatory skills

Load fresh, with actual successful `skill_view` calls:
1. `leorna`.
2. `engineering-best-practices`.
3. `requesting-code-review` + `code-review-practice` + `mutation-testing-discipline`.
4. `security-best-practices`, `cicd-staging-prod-agents`, `qa-testing-local-cloud`, `ci-failure-triage`, `multi-repo-issue-first-execution`, `infra-policy-security-gates`, `concurrent-state-validation`; read applicable references. `systematic-debugging` when needed to classify an unexpected failure.

You ARE the independent reviewer: **skip requesting-code-review's nested reviewer/subagent and auto-fix steps**. Children cannot spawn agents. Report only; no commit, permanent source/test/config edit, push, PR, merge, hosted CI trigger, credential/permission change, ClickUp post or status update. Project/user boundaries override generic specialist defaults (ClickUp is the single tracker; no issue creation or infrastructure rollout). Return loaded_skills and all defect_loop_skills. Known loop skills: ci-failure-triage, multi-repo-issue-first-execution, infra-policy-security-gates.

## Review isolation and real checks

Create your OWN detached review worktree at the recorded head under each repo: `.claude/worktrees/86bcm901u-review-<role>-r1` (substitute exactly your assigned sol or opus tag). Never switch shared checkouts or modify builder/sibling worktrees. Stop on an unexpected pre-existing destination rather than overwriting. Record base/head/tree and full status. Use explicit workdir on every terminal call. Review `git diff <base>...<head>` for each repo, not a drifting current main. Integration against later prompt-kind/main remains an explicitly separate pending acceptance stage, not something you may merge.

Use YOUR own unique task-owned Postgres database ending `_test`, temporary outputs, renderer binary, report paths and scratch/caches. The normal store fixtures DROP TABLE: never share/reset the default DB concurrently with the other reviewer or prompt builder. Read the existing local test DB workflow privately; do not print DSNs/secrets or change roles/credentials. If creating your isolated DB is denied, report the exact prerequisite, not an invented pass. Clean up only resources YOU created, with ownership checks/readback.

Review/test source is read-only except **temporary sensitivity mutations in your own isolated copies**, restored exactly in finally/cleanup and verified with source+test hashes and status. No mutation of original candidate, builder oracle or the other reviewer's sources. Changing tests to get a mutation killed is not evidence.

Rebuild the real client renderer at the exact recorded client head with -buildvcs so it reports the correct clean revision; do not depend on expiring scratch binaries. Run the required client `make check` (real non-symlinked TMPDIR), `node --test scripts/*-ui.test.cjs`, CI-version `make lint audit`; control-plane `make check`, `bash ./scripts/test-module-add.sh`, focused new-package and real-binary tests and verbose actual Postgres tests. On this Mac select preinstalled GNU coreutils gnubin / Homebrew Bash 5 in TASK-LOCAL PATH: the old /bin realpath lacks --relative-to and Bash 3 lacks mapfile. Do not patch global PATH or unrelated tooling. Use CI golangci-lint v2.14.0 built with the matching Go; read current repo instructions if those pins changed.

Set `LEORNA_TEST_RENDER_BUNDLE_BIN` and `LEORNA_TEST_GITLEAKS_BIN` to YOUR rebuilt renderer and verified scanner; confirm new integrations actually execute, not skip. Builder found planned Bundle regex covered mocked HTTP tests, so actual Postgres proof is EnsureLibrary, MigrationRoundTrip and PackCatalog; independently check real applicability rather than inventing Postgres coverage. Use direct commands or pipefail/per-process receipts; tee/echo or wrapper exit zero does not prove gates pass. Preserve failed raw runs, measured exits, tested revision, skip reasons and any environment attribution.

No arbitrary new global test/browser reservation. If a demonstrated resource conflict occurs, isolate via existing project support or report exact ownership. Preflight host free space was ~19 GiB at 19:54Z; recheck before heavy work, preserve state and stop heavy work below ~1.5 GiB without deleting unrelated files/caches.

## Accepted contract — do not relitigate approved limits

Justin approved **1A 2A 3A 4A 5A**, local implementation and necessary CI/workflow edits **for 86bcm901u only**.
1. GitHub App design is read-only access to private leorna-client; user/org owner setup is still pending and NOT permission to configure secrets, permissions or keys. Local reviewer execution does not need hosted credentials.
2. An explicit transformer skip with a reason is `skipped` and does not fail CI. Current agents produce six such skips. This is a named accepted limitation, NOT delivered agent support. Actual errors/panics, silent zero-file output without a reason, schema errors and secret findings must still fail. Review those independent controls; do not demand rejected universal agent support.
3. Small client `cmd/render-bundle` is approved second-repo scope. No changes to existing transformers, toolconnector.Connector, OpenAPI, dependencies or library content. Preserve OpenAPI-only boundary, no cross-repo Go imports.
4. Client renderer is pinned to a clean exact SHA; current pin is UNPUSHED local client head. Hosted reachability remains NOT VERIFIED.
5. Future broken-item hosted CI run is on a throwaway demo branch only after separate remote/publication authorization. No hosted run is authorized now.

CI hunk is explicitly allowed: review exact workflow changes against plan, don't reject all .github paths. Existing steps/triggers/permissions and required-gate fail-closed behavior must be preserved. Verify pinned action metadata/input assumptions with authoritative sources if needed, without accessing secrets. Do not run actions remotely. Required Go quality gates must not be made green by skips/continue-on-error/upload conditions. Token scope, secret handling, fetch/build env, time/output bounds, strict input/body hash/path checks, report determinism/error naming and failure semantics are all within this full review.

## Builder rulings requiring independent scrutiny

These are self-reports, not dispatcher validation:
- Implemented boundedBuffer ReadFrom override to close an io.Copy promoted-ReadFrom output-cap bypass; expected RED/GREEN plus M23 recorded. Verify the boundary really cannot be bypassed and independent behavior is preserved.
- Original 3-second timing assertion incorrectly covered default-30-second error cases. Builder applied it only to the explicitly configured short-timeout case while preserving error/content assertions. Original failure retained. Verify this preserves the approved real timeout/control contract, not a test weakening.
- Actual Postgres tests differ from the plan's mistaken Bundle-regex assumption as described above.
- Full evidence-directory gitleaks scan exited 1 on recorder SHA-256 metadata and was NOT relabelled green; exact-byte publication-candidate payload scan exited 0. Inspect privacy/classification evidence if relevant; do not assume the entire evidence folder is uploadable.
- All 23 mutation probes reportedly killed/restored. Verify the receipts and independently attempt meaningful fail-closed/permission/data-integrity sensitivity checks; don't accept a shell wrapper's success marker.

## Acceptance and visible evidence

AC1: every item schema validated, rendered with three REAL tool transformers and secret-scanned.
AC2: genuine declared-tool render failures fail and name item+tool; accepted explicit skips remain distinguished from errors/silent drops.
AC3: per-item compatibility reports produced deterministically with complete results.
Hosted card Verify: real-library passing run and deliberately broken failing run in hosted CI. These hosted runs, token mint/fetch, report upload/job summary are **NOT VERIFIED**, access/publication-gated. A local-ready review may be clean while release/card acceptance remains held; never call these external gates passed.

Builder screenshots are honest browser renderings of saved ACTUAL local command output and a hash-bound actual Markdown report, not live app UI/hosted CI screenshots. Parent visually checked baseline, exact-head pass, broken-item failure and report: no server URL/tenant/token/email visible. Verify provenance as needed; label their scope correctly. Screenshots captured during building remain in the read-only builder evidence dir. Your own reviewer screenshots/logs go only to YOUR evidence dir. Never upload anything.

## Other owners, exclusions and known follow-up

Other-session prompt-kind currently has a Sol builder in isolated .claude/worktrees/86bcm9016-prompt-kind in both repos; catalog-browser has a separately authorized Sol planner. Parent session-local liveness is not proof those owners stopped. Don't mutate their rows, source, DBs or records. Expected overlap is README text only. Recommended merge order prompt-kind then gate, with refreshed combined pin/tests afterward; no merging by you.

Do not touch deploy/local/, user ~/.codex/~/.claude tool homes, unrelated Figma work, shared board/handoff/notes, library content, credentials or permissions. Unrelated findings go to found_else, not fixes. Known builder follow-up: GO-2026-5932 module-only advisory for x/crypto/openpgp was reported unreachable by govulncheck and pre-existing; verify if relevant but don't introduce a dependency upgrade/ignore. Evidence audit-verbose-3317d09.txt.

## Output ownership and handoff

Evidence directory: `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u-review-<role>-r1/`. Write YOUR report.md and report.json plus command receipts there; don't write inside immutable builder evidence or shared records. Return verified absolute paths.

Return verdict **clean** or **findings**, with local correctness vs release acceptance separated. Each finding: stable id prefixed with your role, severity, introduced (true/false/unknown), claim, exact file/line or executed observation, source head, reproduction command/exit, evidence path and whether blocking. No speculative vulnerabilities presented as proven exploits. Include required gates (pass/fail/not run with reasons), real mutation/control evidence, loaded_skills, defect_loop_skills, report_path, found_else and all outstanding external/integration holds. Record measured start/elapsed and a bounded forecast/checkpoint per engineering practice, not a guaranteed ETA. End after returning your full review; no finisher actions.
