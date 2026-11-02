# Role: REVIEWER (the one review) — djtrees-storm-photo (DJ Trees designer note 8)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-storm-photo`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC11 by test/receipt; AC12 live, paste check 3cq).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a15a7d44ced8063a2`, branch
  `worktree-agent-a15a7d44ced8063a2`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `a10aed1933d0428cdd29371943833d03b4ea1be6`.

The request: on phones and tablets the "Storm hits. We respond." section showed its side photo behind every word. The
plan's general rule (`photo.stack`, `src/core/adapt/rules/side-stack.ts`): a section whose own photo fill is cropped
against one side, with the words on the far side, stacks from 991 down: the photo on top (a `::before`, height
`min(cap, drawn ratio)`), its lower half fading into the shade's first solid colour, the words below on the shade's
solid colours; nothing changes from 992 up.

The builder reports four deviations from the plan, all inside the plan's files and recorded in HANDOFF as its rulings
(Position control for `position: relative`; the no-shade case narrowed to at most one opaque colour; a new "no layer
placed over the photo" guard; `heroOf` called with the header spacer filtered). Judge each: is it right, general, and
does any break an AC's meaning?

Things worth probing: other side-photo shapes (photo on the right, a photo covering part of the height, a shade layer
vs a fill, two fills, a see-through colour), the header tick's spacer, sticky sections, sections with placed layers
(badges, drawings) over the photo or the words, tablets 768–991 where words were beside the photo, the 320 phone,
very tall/short drawn photos against the caps, the inline-pictures mode and the WordPress mode (the photo address
written once), and that `crop.subject` still handles everything this rule doesn't take.
