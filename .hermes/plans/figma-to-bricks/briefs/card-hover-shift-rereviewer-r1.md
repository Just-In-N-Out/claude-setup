# Fresh focused RE-REVIEW — card-hover-shift R1

You are a NEW independent reviewer, read-only, Sol 6.1 xhigh (Justin explicitly chose this model for the remaining pipeline).

## Skills and role

Load figma-to-bricks (REVIEWER), engineering-best-practices, requesting-code-review, code-review-practice, mutation-testing-discipline and frontend-ui-repair. You are already the fresh reviewer: skip nested reviewer spawn and auto-fix steps. Parent owns independent verifier later.

## Verified state

Existing worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/card-hover-shift`, branch worktree-card-hover-shift. Parent verified tip `15a55d6e4e060fa7dfa585448d0f0805f7c9025f`, only untracked .superpowers/. Reviewed old tip `7e13764ebf77c5d57b709a8f37a17a9414e8501a`. Focus on `7e13764..15a55d6`, while confirming whole `main...HEAD` still holds. Do not recreate/reset this copy. Plan `/Users/justin/.hermes/plans/figma-to-bricks/card-hover-shift.md`; original review brief `briefs/card-hover-shift-reviewer.md` and corrective brief `briefs/card-hover-shift-finisher-r1.md` in same plans directory.

## R1 — prior independent finding, verbatim

P2 introduced: 'Wrapper matching is not one-to-one: two hover wrappers can both claim the same unmatched original layer. Genuinely added sibling content then receives replacement-only compensation, shrinking its flow footprint and moving later content. Introduced in Q3B0263b58 and retained in this candidate. Reserve proven matches once, or reject ambiguous matches, while leaving newly added content uncompensated.'

Evidence: overlay.ts47–56,105–117 failed to reserve standsFor; adversarial-unit.tap got2 compensated wrappers for1 original; duplicate-v2/evidence.json distinct Service/New offer added88px wrapper erroneously margin-right:-8px1440/990; downstream words308→296 at1440 (4px legitimate+8px erroneous). Prior review evidence `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/reviewer-b330f86/`.

## Finisher's answer (self-report, independently verify)

15a55d6 rejects ambiguous wrapper/original ownership before compensation, independently of sibling order; added content keeps full footprint, proven single/multiple replacements still compensate. least.ts and strict motion oracle unchanged. Twelve new unit cases; original probe RED28pass/1intendedfail then GREEN; four isolated ownership mutants and reviewed-source browser causal revert killed. Final check2133+6 and browser249/249 zero skips share566 source/test/tool/config hashes. Fresh base/corrected corpus same18 baseline findings, five complete reports/payload/fullHTML equal29widths. Real input60base/60corrected comparisons, no layout/containment/motion failure,24hover lint no added findings. New130-artifact manifest and7shots verified, prior322/333/21 archives untouched.

Correction evidence `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/fix-r1/`. Check original probes/receipts rather than trust prose. Preserve failed preliminary run; final passing run does not erase its attribution. Candidate is a FIX-ONLY checkpoint, not released.

## Review scope and execution

1. Independently reproduce old R1 with original probe, execute corrected regression/negative and positive controls, inspect ambiguity/sibling-order/one-to-one behavior and ensure conservative matching does not silently disable legitimate compensation. Confirm all previously approved general sizing/motion behavior survives.
2. Independently run applicable established plan/project gates on corrected revision; do not credit inherited runs as your own. You may focus the delta and reuse preserved prior evidence to avoid redundant reconstruction; still confirm whole diff holds and state actual executed/missing checks. Use the working runtime recorded in prior receipts; initial browser hangs were runtime-dependent, not accepted assertion failures.
3. Preserve strict ±1px oracle; no changed look/new layout policy. Keep normal card layout untouched. Check other-session hero-media-row ownership, don't edit shared interfaces or unrelated copies. Do not waive font incompleteness.
4. No code/test fixes, commit, merge, push, BUILD, CLAUDE edits or cleanup. Isolate and restore mutations exactly. Explicit workdir always. Save new evidence separately under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/rereviewer-15a55d6/`; verify manifest and source identity.
5. Return verdict, findings with ids/severity/introduced/claim/evidence, R1 closure, exact executed checks, missing gates, evidence path and defect_loop_skills. List unrelated defects separately, don't expand scope.

## Release holds remain even if review approves

- Justin has NOT answered 360px acceptance question: original normal card already puts Assembly title below Service05. Hover now matches it; forcing both on same row was over-specified by dispatcher. Do not silently satisfy/reinterpret literal same-row criterion or change normal layout. Independent first reviewer confirmed original y25/y63.140625, hover24.5/63.640625 and own layout unchanged60cases.
- Genuine Garamond Condensed missing on both main/candidate stays UNVERIFIED. No stand-in, narrowed expectations or feature waiver.
- Independent verifier remains parent-owned and required before release, plus authorized release/docs and installed-Bricks/live paste checks.

Original ask: stop title dropping and arrows disappearing when linked service cards hover on tablets/phones. Approved all-width sizing preservation, wrapper compensation and narrow responsive-room accounting. Justin's model words: 'cant you resume with 6.1 sol'.
