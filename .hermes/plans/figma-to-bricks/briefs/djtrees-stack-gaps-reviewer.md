# Role: REVIEWER (the one review) — djtrees-stack-gaps (DJ Trees designer note 9)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them. Self-check
correction: run `ac-check` with your own `E/verifier/ac.json` and a `cp`'d scratch copy (the same file twice exits 2).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC8 by test/receipt; AC9 live, paste check 3cr).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-af85fd290cf656db8`, branch
  `worktree-agent-af85fd290cf656db8`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `8a6deac6ec9a86ca9764afce620ed234af44955e`.

The request: on phones, four stacked credential points had large empty gaps between them. The plan's general rule:
once a row divided by lines breaks (two per row, wrapping or stacked), its points' own top and bottom padding is the
space between them, evened out to the row's ends (`Divided.ends`/`endsOf` in `divided.ts`, `evenedSide` in
`sides.ts`), and the row gap only tops it up to the tier's gap S: `max(0, S − top − bottom)` (`dividedRowGap` in
`rules/rows.ts`), so two points' words end up `max(S, top + bottom)` apart.

The builder reports: the bottom end is the bottom padding of the point drawn tallest (ties within 1px: the smallest);
the `wasRowGap` part of the skip is defensive (no killing mutant); a divided row wrapping on laptops still adds its gap
(Deferred); hydraulics' `div.wrap` changes 37/24 → 0 on tablets/phones (intended). Judge each.

Sibling jobs editing the same files: djtrees-stack-lines (made across lines between stacked points, its own padding
writes from `row.reflow` on the across tiers; fixed head `d0a81c9`), djtrees-step-sides (`Divided.edge` rows,
`lineGap`), djtrees-top-align (shares.ts, a different file). Judge this job on its own head, but name every rebase clash
you can see (which rule owns which tiers, double padding writes, `engine.ts` "undoes" collisions) as a P3 with the
exact guard needed.

Things worth probing: dividers as thin layers vs side outlines, points with uneven top/bottom padding, a point drawn
much taller (a long text), rows of 2 and 6, two-per-row tablets, items that are cards (painted: excluded), lists/FAQs
(excluded), rows without dividers, rows drawn without auto layout, and the 320 phone.
