# Role: REVIEWER (the one review) — djtrees-step-sides (DJ Trees designer note 7)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them. Self-check
correction: run `ac-check` with your own `E/verifier/ac.json` and a `cp`'d scratch copy (the same file twice exits 2).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-step-sides`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC8 by test/receipt; AC9 live, paste check 3cp).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a679766c7d46e51f2`, branch
  `worktree-agent-a679766c7d46e51f2`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `2334846865b06935215cf62c95a5ec51d3a90c90`.

The request: on phones, stacked process steps 02 and 03 kept extra space on their left and right, and each paragraph
nearly touched the line under it. The plan's general rule: a row of 2+ unpainted, unshadowed boxes that each draw
their outline only along the top (or only the bottom), with no side lines, thin line layers or list records, is a
divided row of a new kind (`edge`, `src/core/adapt/divided.ts`); wherever it stacks, wraps or goes two per row its
items' sides even out and the row gap places each line midway between two points' words, never under 16px
(`lineGap()` in `src/core/adapt/rules/rows.ts`).

The builder reports: the line isn't exactly midway when the line's own padding is under 16px (16 above, the item's own
below); `understand/give-way.ts` has its own copy of the divided-row check, not extended; R16 survives as equivalent.
Judge each.

Sibling jobs editing the same files are being fixed/built now from the same base (djtrees-stack-lines: a made across
line between stacked points, `acrossLines`/`dividerLooks`; djtrees-stack-gaps: point padding as the stacked space).
Judge this job on its own head, but name anything in its design that will clash at rebase (e.g. an `edge` row also
getting stack-lines' made line), as a P3 with the exact guard needed.

Things worth probing: steps lined on top with different thicknesses/colours (step 1 3px green, 2–3 1px), a row whose
items mix top and bottom lines, rows of 2 and of 5+, items with a top line and a painted background, a list's records
with bottom rules (the Services table, excluded), a zigzag reversed row (`split.reverse`), rows drawn without auto
layout, rows that stay on one line at every tier, and the 320 phone.
