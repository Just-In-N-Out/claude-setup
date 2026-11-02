# Role: REVIEWER (the one review) — djtrees-stack-lines (DJ Trees designer note 6)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC7 by test/receipt; AC8 live, paste check 3co).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a605ace0a8e3f3af3`, branch
  `worktree-agent-a605ace0a8e3f3af3`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `8464f71d751a76845223e5c3621d5c2549449923`.

The request: on phones the numbered points of a row divided by line layers stacked with only one stray line between
them. The plan's general rule (replacing the phone rule's "loses the lines" for rows that stack one per line): once
such a row stacks, a line like its dividers (flat colour, alpha, thickness) runs across between every two points,
midway between their words (≥ 16px each side), none above the first or below the last; written by `row.reflow`
(`src/core/adapt/rules/rows.ts`) with `dividerLooks` in `src/core/adapt/divided.ts`.

The builder reports choices within the plan (an across tier needs the row stacked with every item spanning it on that
tier and every narrower one; the line written once at the first such tier; `layerLook` reads only
`background.color`; the "stacks, then wraps" control is unbuildable) and found an existing browser assertion that
can't fail (`divided-rules.test.ts` counting `[data-label="Line"]`, found_else 1). Judge each.

Things worth probing: dividers drawn as thin layers vs items' own side outlines, dividers of different colours or
thicknesses in one row, a missing divider between two items, rows of 2 and of 6+, items with uneven top/bottom
padding, rows that go two per row before stacking, the rows' own top/bottom outlines (the credentials), a row inside
a painted card, the sibling job djtrees-step-sides' edge-lined rows (items with only a top outline: they must not
get a second line once both merge), and that the layout plan's widths still match.
