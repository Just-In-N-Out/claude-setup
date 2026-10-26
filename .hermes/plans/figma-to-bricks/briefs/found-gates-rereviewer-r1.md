# found-gates — NEW independent review after FG-R1 correction

## Role and immutable target
You are a fresh read-only reviewer, not the builder, original reviewer or finisher. Parent manages; you own technical investigation and independent execution. Read the approved /Users/justin/.hermes/plans/figma-to-bricks/found-gates.md and both evidence handoffs.
Worktree: /Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/found-gates
Branch: worktree-found-gates
Candidate: 693245e515885b1f27a6868773d8616a63577013
Previously reviewed: 3dda965481a7564fb5ee159da9b42fa7adfb86b6
Exact integration base: b4ed333631dba923b73e1731ad420a4f92d880f1
Review correction delta AND confirm the whole base-to-candidate contract. Parent verified candidate HEAD and tracked clean except preserved .superpowers; main/origin remained b4ed333 at handoff. Recheck identity yourself.

Load figma-to-bricks first, engineering-best-practices and peer-review-strategy, requesting-code-review (report only, no auto-fix or nested spawning), code-review-practice, mutation-testing-discipline, systematic-debugging and qa-testing-local-cloud. Add relevant specialists; return actual defect_loop_skills. Parent dispatches any verifier required by loaded skills, children cannot spawn.

## Finding and corrective claim
FG-R1 was P2 introduced: the public runLint wrapper assumed a nonnegative left-origin horizontal scroll range. An RTL scroller with scrollWidth600/clientWidth280 falsely reported 310px picture clipping at scrollLeft0; scrolling to -320 revealed the whole picture, hit(50,20) confirmed it. The SAME bug also wrongly exempted unreachable RTL right/start-side overflow; that is corrected within this assigned finding, not a new unrelated source feature.

Finisher claims direction-aware right-origin scroll-zero extent with actual scrollLeft. LTR, vertical handling, default lint without opt-in contracts, selector validation and unsupported-geometry fail-closed behavior should remain unchanged. Public tests reportedly exercise LTR/RTL initial/intermediate/end offsets, real scrolling/hit testing without changing scroller position, unreachable start-side overflow and viewports outside their clip. Independently attack these claims, not just test names; ensure actual public-wrapper sensitivity, no exemption of arbitrary negative geometry.

Original reviewer evidence: /Users/justin/.hermes/plans/figma-to-bricks/evidence/found-gates/reviewer-3dda965/
Correction evidence: /Users/justin/.hermes/plans/figma-to-bricks/evidence/found-gates/finisher-r1/
Read verification-summary.json, reviewer-red.log, regression-red.log, final-focused-green.json, mutation-results.json, browser-complete.json and corpus-comparison-v2.json; verify manifests and consumed source bindings rather than trusting counts.

Finisher SELF-REPORTS (not your independent results): focused33, geometry13; three isolated variants killed (old left-origin, all-overflow exemption, ignored viewport containment), restored candidate; check2113 unit/rule+6 perf; browser263, no skip/cancel. Corpus exit1 held for same17 historical v1 differences and genuine missing Garamond. Five full payload/HTML pairs and all34 width observations/full file reports match the earlier reviewed candidate except root createdAt. A foreground420s timeout's partial raw log and initial timestamp-comparator refusal were preserved; unchanged background browser retry completed. Distinguish product failures, capture timeouts and reader errors. Original137-file reviewer manifest unchanged; finisher70 files/10132413bytes, manifest SHA256246f27c1058c0aac895a70ce9c8a932e2afd3b4cf1b5fdeb4e79d754d127d3ce; 565 committed pins reported. Verify these if citing.

## Required review and resource boundary
Perform spec conformance, quality/design and fresh adversarial review. Independently reproduce the original public-wrapper failure on its original source and prove the corrected candidate closes it; keep valid LTR/RTL/vertical/unsupported/default controls and sensitivity mutations. Run established applicable project gates safely and validate final source-bound evidence; don't inherit the finisher's green summaries or assert a new full gate from static inspection. If a gate cannot run, state exactly what is unrun and what evidence is historical.

Actual Data free space at parent handoff is ONLY2.1GiB (later than finisher's3.3). Reassess immediately before heavy gates and coordinate actual owners: contacts reviewer, layout and tiles fixers, plus separately authorized desktop work on the shared board. No idle global browser reservation; no arbitrary new dispatcher cycle/time caps. Avoid duplicating existing multi-MB captures or scratch node_modules archives. Preserve every original raw artifact; do not erase sibling/user/evidence/worktree data or kill live sibling processes. If safe execution is blocked, return the concrete resource requirement and partial review rather than waive a gate or fill disk. Source review and bounded focused execution can proceed when safe. Keep new evidence under evidence/found-gates/rereviewer-693245e/ without overwriting originals; exact source snapshots and manifests must remain reconciled.

READ ONLY: no source/test/docs changes, commits, rebase, merge, push, BUILD bump or cleanup. Any isolated mutation must restore exact hashes and be disclosed; prefer disposable small copies. Layout/tiles consumer adoption stays separately owned and partial, no canonical tooling finding can be called released here. Garamond Condensed stays UNVERIFIED/non-comparable, with no font substitution, expectation narrowing or historical waiver extension. W-B held, ALONE unchanged; no CLAUDE writes/retries, dependencies or site writes. A clean technical review cannot clear the font/release hold.

Return verdict and findings (severity, introduced, file/line, reproducible evidence), explicit FG-R1 disposition including false exemption control, tested SHA, actual independent gates and historical-proof checks, manifest/evidence paths, pending gates, found_else and defect_loop_skills. Stop without release. Parent routes any correction and required verification.
