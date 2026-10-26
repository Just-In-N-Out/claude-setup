# Fresh REVIEWER — card-hover-shift

## Role and skills

You are a fresh independent REVIEWER, not an implementer. Load `figma-to-bricks`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline` and `frontend-ui-repair`. Follow review-only rules: you are already the independent reviewer, so skip nested-agent/auto-fix steps. The parent owns the Agent Defect Loop verifier later.

## Branch and plan

Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/card-hover-shift`; branch `worktree-card-hover-shift`; parent verified HEAD `7e13764ebf77c5d57b709a8f37a17a9414e8501a`, tracked clean with untracked `.superpowers/` only. Implementation revision `b330f864d2ea961a1d801526c28be3eaf28de9e1`; later commit records only per builder. Review the whole merge-base diff (`git diff main...HEAD`) and the approved plan `/Users/justin/.hermes/plans/figma-to-bricks/card-hover-shift.md`, including latest answers/model override. Do not assume mutable main still has its old revision.

Justin reported linked service-card titles dropping down and arrows disappearing on hover, especially tablet/phone. Approved: same-size paired hover layers inherit instance sizing, preserve intentional hover resizes; fix extra arrow wrapper's room too; narrow responsive room/minimum accounting extension; strict ±1px motion oracle retained. Model explicitly switched to Sol6.1 xhigh for remaining pipeline.

## Builder's reported evidence — independently verify

Builder returned stopped, not ready-for-review. It reports:
- Q1/Q2 implemented in d2270e7/b0c50a4. Provisional Q3B 0263b58. Latest option1 implementation b330f86 changes `least.ts` parent aggregation to subtract compensation from min/content/reading accounting, preserving painted size and motion.
- Byte-identical strict ±1px oracle passes: 375px copy padding corrected from23 to24.5px. Check2121 unit/rule +6 performance, browser246/246; eight mutations killed; all60 real-card comparisons pass, no new hovered lint.
- Corpus retry same18 baseline findings; Garamond remains unverified, not green. No font substitution or expectation narrowing permitted.
- Durable archive `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/resume-sol-b330f86/` reportedly333 artifacts. Verify the actual manifest/hashes and evidence scope rather than crediting a summary. Original stop evidence `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/builder-stop/`. Use committed ledger/HANDOFF to locate actual probes.

## Acceptance discrepancy — release expressly held

The dispatcher brief over-specified: 'Assembly shares its label’s row at360'. Builder now reports the **unhovered** original at360 already stacks label/title (y25/y63.14), corrected hover matches (y24.5/y63.64). It did NOT force the base card into one row or weaken the strict motion assertion. Current screenshots show arrow containment improved but title remains below the label. Original provisional evidence apparently shows the same base stacking.

The parent is asking Justin whether acceptance is **match the existing unhovered layout**, or investigate/change the base narrow-phone layout too. While that answer is pending, independently review implementation and established tests and determine whether this is genuinely unchanged base layout versus a missed hover defect. Clearly separate your implementation verdict from this open product/acceptance decision. Do not silently reinterpret the literal criterion or claim full plan closure. **No merge, push, BUILD bump or cleanup regardless of a green source verdict.**

## Review requirements

1. Independently inspect whole-branch correctness, shared layout-rule effects, wrapper matching/compensation, true-resize controls and preservation of intentional motion. Check expanded ownership (least.ts parent aggregation) did not consume other approved work/policies.
2. Re-run established project/plan gates yourself and relevant mutations/adversarial cases. Source reasoning, inherited test results and archival verification are not replacements for actual execution. Preserve raw failures and distinguish baseline defects from introduced ones. No arbitrary source-only restrictions or invented gates.
3. Validate the360 discrepancy using actual own/hover geometry and original proof. Verify375 strict oracle unchanged and effective, not a weakened/fake green. Keep measured evidence separate from predictions.
4. Do not waive Garamond incompleteness or count it green. No global font waiver was granted for this feature.
5. Always use explicit workdir. Other sessions may own independent branches; absence from this chat's live list does not mean dead. Do not modify their work or clear denied approvals.
6. Review only: no code/test fixes, commit, merge or push. Any temporary mutations must be isolated/restored with proof. Preserve all original evidence; put new review artifacts in a distinct durable folder under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/reviewer-b330f86/`.
7. Return verdict, findings with id/severity/introduced/claim/evidence, exact executed checks and unresolved gates, acceptance-discrepancy assessment, evidence folder and defect_loop_skills. Any unrelated findings belong in found_else, not a silent scope expansion.

## Known non-scope issues from builder

Existing own-card wrapping can stack title/arrows; existing hover-cover max-width cap makes copy2px narrower; historical unverified collapsed-picture recolours may produce no hover copy; header-link hover offsets may be designed. New diagnostic: direct body-reading `content(..., 'fluid')` throws in PageFacts.wordCap, preserved `candidate/red-reading.tap`, not repaired. Verify attribution before reporting an introduced defect.
