# VERIFIER (read only) — card-hover-shift

## Role and skills

You are the fresh independent **VERIFIER** for the Agent Defect Loop. You have never seen this build. Load, in order: `figma-to-bricks`, `engineering-best-practices`, `frontend-ui-repair`, `mutation-testing-discipline`. You can't spawn agents. **Change nothing**: no commits, merge, push, BUILD bump, CLAUDE.md edits or cleanup. Any temporary mutation must be isolated and restored exactly, with proof. Model: Sol 6.1 xhigh (Justin's explicit pick for this feature).

## What the feature does

Justin reported that hovering a linked service card on tablets and phones made its title drop onto a new line and its arrow disappear or leave the card. Approved fix:

1. Hover-copy layers that the hover variant draws at the same size take the card's own sizing (fill, hug, fixed), at every width. Intentional hover resizes keep the variant's size.
2. An extra wrapper the hover variant adds around a layer (here the arrow's transform wrapper) takes no more row room than the card's own layer. This includes a narrow change to responsive room/minimum accounting in `least.ts`.
3. The hover motion stays as designed, checked by a strict ±1px browser test.

## State to verify

- Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/card-hover-shift`, branch `worktree-card-hover-shift`.
- Final tip `3564fd19c3e5dbead5d8568c12aa4de03147abd0` (records only). Tested integrated source `060b71353de3953b26799e571d04e28a42acc95e`. Base: local `main` at `8f538bb0ad2ea287f7ae5f8dfce58ae9e01949e0` (Build 2026-10-22.6, button-link-routing). Recheck main: it may have moved.
- Plan: `/Users/justin/.hermes/plans/figma-to-bricks/card-hover-shift.md`.

## Review history to confirm closed

- First fresh review (`evidence/card-hover-shift/reviewer-b330f86/`): verdict changes_requested. **R1, P2, introduced:** "Wrapper matching is not one-to-one: two hover wrappers can both claim the same unmatched original layer. Genuinely added sibling content then receives replacement-only compensation, shrinking its flow footprint and moving later content." Evidence: an added 88px wrapper got `margin-right:-8px` at 1440 and 990; downstream words moved 308→296px at 1440.
- Finisher's answer (commit `15a55d6`): ambiguous wrapper/original ownership is rejected before compensation, in either sibling order. Added content keeps its full footprint. Unique and multiple proven replacements still compensate.
- Focused re-review (`evidence/card-hover-shift/rereviewer-15a55d6/`): approved for R1, zero findings.
- Integration finisher (`evidence/card-hover-shift/integration-8f538bb/`): rebased onto main `8f538bb`. Only mechanical HANDOFF conflicts. Reports:
  - check: 2176 + 6 passing;
  - browser: 253/253 on Node 22.19.0;
  - corpus: the same 18 baseline findings on base and branch;
  - 60/60 real-input measurements with no failures;
  - the only changes versus main are 11 hover descendants.

These are **reports, not your proof**.

## Required validation

1. Re-run the `frontend-ui-repair` Required Validation Gates and the project's gates yourself on the integrated source: `npm run check`, `npm run test:browser` and `npm run corpus` with a same-base comparison. Use the Node 22.19.0 runtime earlier reviewers used; earlier Node 22.22 browser teardown hangs were runtime problems, not assertion failures.
2. Confirm R1 is closed with the original reviewer probe and your own controls, and confirm the strict ±1px 375px motion oracle is byte-identical to the original and actually passes.
3. Look for regressions the fixes or the rebase caused, especially to button-link-routing (shared `ir.ts`) and to normal (unhovered) card layout. Measure real hover geometry at tablet and phone widths.
4. Report the missing Garamond Condensed font honestly as pre-existing and UNVERIFIED. No stand-in font, and no narrowing of the expected set.
5. Save evidence under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/verifier-3564fd1/` with a verified manifest.

## Open decisions (not yours to settle)

- **360px wording:** the original brief said Assembly's title shares its label's row at 360. The unhovered card already stacks it below the label, and the hover now matches. Justin is choosing between keeping the existing layout (recommended) and a base-layout change. Report what you measure; don't reinterpret the criterion.
- **Release:** the Garamond release decision is pending with Justin.

Return: `verdict` (clean or findings), `findings[{id, severity, claim, evidence}]`, executed checks, remaining gates, evidence path. List unrelated issues in `found_else`. Always pass an explicit `workdir`.
