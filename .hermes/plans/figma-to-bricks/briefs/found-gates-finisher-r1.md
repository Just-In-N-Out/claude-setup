# FINISHER — found-gates FG-R1 correction, no release

## Assignment
Repair the independent review finding below test-first, within the approved found-gates tooling scope. You own technical investigation, tests and evidence. Parent manages assignment/status only; no artificial global heavy-slot waiting or extra dispatcher gates. Follow existing project validation and coordinate only demonstrated active file/resource conflicts.

Worktree /Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/found-gates, reviewed candidate3dda965481a7564fb5ee159da9b42fa7adfb86b6 vs mainb4ed333. Read approved plan found-gates.md and ledger docs/plans/found-gates-ledger.md. Preserve source/evidence and use explicit terminal workdir.

Load figma-to-bricks, engineering-best-practices +peer-review-strategy, receiving-code-review, git-commit-rules, test-driven-development, systematic-debugging, mutation-testing-discipline, qa-testing-local-cloud. Return actual mandatory-loop skills if added. Child cannot spawn; parent assigns fresh reviewer/verifier. Reviewer has released its test resources and reports no owned orphan runners.

## Received finding — retain original evidence
FG-R1, P2, introduced:true.
Claim: Reachable RTL scroll content is falsely reported as picture-clipped. The horizontal reachability calculation assumes a nonnegative, left-origin scroll range.
Source: test/browser/geometry.ts:66-68.
Reproduction: rtl-reachability.test.mjs; raw rtl-reachability.log.
Observations: The contained RTL track has scrollWidth600 and clientWidth280. At scrollLeft0, runLint reports310px left clipping. Setting scrollLeft to-320 exposes the complete picture and elementFromPoint(50,20) hits it. Equivalent LTR control passes.
Result: Actual public-wrapper regression test exit1; LTR control passed, RTL assertion failed.
Fix direction: Handle negative-origin reachable scroll ranges and retain unreachable-negative-overflow controls; add this regression before changing implementation.

Independent reviewer evidence /Users/justin/.hermes/plans/figma-to-bricks/evidence/found-gates/reviewer-3dda965/: verification-summary.json, reconciliation.json, mutation-results.json, png-verification.json, adversarial.json, rtl-reachability.test.mjs/log, reviewer manifest. Verify finding yourself and reuse original fixture from disk, not a guessed reconstruction. Reviewer reports independently completed check2113+6/browser259/focused27+18+5/nine mutants, full exact corpus29 original+5expanded observations, manifest/provenance verification. Corpus remains non-comparable for genuine Garamond despite same17 historicalv1 identities; none of these are release authorization.

## Corrective scope and acceptance
1. Source test/browser/geometry.ts horizontal reachability only; add generic regression to owned geometry.test.ts, retain LTR/reachable/unreachable/clip viewport/selector/unsupported geometry controls. No converter/font policy change or sibling source/test edits.
2. Confirm causal RED at public runLint wrapper; minimal fix, unchanged-oracle GREEN and relevant sensitivity tests. Do not broaden exemption to all negative off-edge content or disable clipping detection.
3. Run established relevant/full project gates as needed on corrected source; evidence and code identity must agree, original raw failures retained. Own execution; don't wait for a reserved slot that no longer exists. Report actual resource blockers without weakening checks. Keep evidence bounded, preserve others' work.
4. Update ledger/HANDOFF and exact CLAUDE pending proposal only, with final corrected source and verification state. Never write protected CLAUDE or retry denied operations.
5. Stop committed ready-for-review. Because checker semantics change, parent dispatches a NEW fresh Sol6.1 high reviewer on the delta plus whole branch. No self-review shortcut. No merge/push/BUILD bump/worktree cleanup. Consumer adoption remains layout/tiles-owned and partial.

Garamond remains UNVERIFIED, no stand-in/expectation narrowing/historical waiver extension. W-B and ALONE unchanged. No site writes/dependencies/new capabilities/permission bypass. If safe correction requires wider source or policy, stop with specific options. Return reviewedtip/newtip, verifiedfinding/fix, actual tests/mutations/evidence, found_else, pending release gates and defect_loop_skills.
