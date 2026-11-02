# Role: REVIEWER (the one review) — djtrees-top-align (DJ Trees designer note 5)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC7 by test/receipt; AC8 live, paste check 3cn).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a955a6278526de73d`, branch
  `worktree-agent-a955a6278526de73d`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `c2a3d2cc37957e30e27d10c9d18d7b59a14034f0`.

The request: on phones, four label/value items in two columns (BASED IN / EVANSVILLE, COVERAGE / LICENSED & INSURED…)
were centred against each other once a value wrapped, so one label sat lower. The plan's general rule: a label box
counts as "a button in all but name" (`style/shares.ts` `button()`) only when its parts sit side by side, or it is
painted or outlined; so rows of unpainted label-over-value boxes drawn the same height stretch (the existing
"boxes drawn the same height stay the same height" rule) and keep their words at the top.

The builder reports one change outside the plan's list: fixture `arrowStrip`'s "Topics track" (14 unpainted
glyph-over-caption columns) changes `_alignItems` flex-start → stretch with identical rects. Judge it.

Things worth probing: every other reader of `button()`/`labelBox` (pills, tags, nav items, badges, avatars, menus,
chip rows, CTAs, hover layers), stat rows whose items hug different heights, a label/value pair whose value is a
link or a phone number, a row with one painted and three unpainted items, nested wrappers, rows drawn without auto
layout, rows that keep their line on tablets, and the brainstorm partner row the plan expects to change.
