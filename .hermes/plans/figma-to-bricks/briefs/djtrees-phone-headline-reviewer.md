# Role: REVIEWER (the one review) — djtrees-phone-headline (DJ Trees designer note 11)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-headline`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC7 by test/check; AC8 live, paste check 3ct).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a83fd9594f25d3b40`, branch
  `worktree-agent-a83fd9594f25d3b40`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `4a403053108b1783c797366e20a948ad2276d81d`.

The request: the closing heading "Ready to get the job done?" came out huge on phones with its four lines almost
touching. The plan's general rules: a phone display cap in `PageFacts` (`displayCap`, 21% of the phone tier's
narrowest column: 72 upright / 93 sideways) for texts of two or more words; a new rule `type.leading`
(`src/core/adapt/rules/leading.ts`) giving line height 1 to a 2+-word text drawn ≥ 28px with line height < 1, from the
widest tier where `wrapsMore` estimates more lines than Figma drew. The hero is included.

The builder reports one departure from the planner's prototype (an empty line between typed breaks counts as a line
in `wrapsMore`) and one equivalent surviving mutant (M16, the rotation guard). Judge both.

Things worth probing: headings whose font is much wider/narrower than the 0.72em letter estimate, a heading in a
narrow card column vs full width, a 2-word heading that fits one line, numbers and prices ("$1,299"), headings with
typed line breaks, a text whose line height comes from its global class, a heading with a hover state or a CTA's
label, `textSize` staying monotone across tiers, the fluid clamp at the design width (desktop unchanged), the
interplay with `type.ramp` (`overrides`, rule order, collisions), and the hydraulics sections that grow 3–42px on
phones.
