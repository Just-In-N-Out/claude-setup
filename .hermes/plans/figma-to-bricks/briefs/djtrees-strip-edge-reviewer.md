# Role: REVIEWER (the one review) — djtrees-strip-edge (DJ Trees designer note 12)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-strip-edge`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC6 by test/receipt; AC7 live, paste check 3cu).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a6c9fc7c6ea4e0695`, branch
  `worktree-agent-a6c9fc7c6ea4e0695`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `a14d43929666e729698b10f3359f822d8fcac7ec`.

The request (desktop): "make the cards go all the way to the right so that there's no spacing to the right." The
plan's general rule (replacing the unconfirmed 30.7 ruling "the track stays clipped at its own box"): a strip Figma
scrolls sideways and leaves unclipped and unpainted, across its section's centred Container content column, with
nothing between them that clips or paints, spans the window from 992 up: first card where drawn, cards visible to the
window's edges, scrolled cards passing the left edge, the last card stopping at the drawn right edge; one
`@media (min-width: 992px)` block on the strip (`E = max(64px, calc(50vw - C/2 px))`), the holder section
`overflow: clip visible`. Files: `src/core/understand/strips.ts` (`runOut`), `src/core/style/strips.ts`.

The builder reports: fixture options added (`panel: "paint" | "clip"` so each guard has its own control), one
load-flaky hotspots test, and a classic-scrollbar note (100vw counting a Windows scrollbar overhangs by half a
scrollbar each side above 1408px, hidden by the section's clip). Judge each, especially the scrollbar case: Justin's
team views on Windows desktops.

Things worth probing: the strip's Code element script (`emit/arrows.ts`) with the wider box (scroll positions,
`startOf`, the lit bar, round at the ends, controls hidden where the strip doesn't scroll), card arrows (the
2026-10-08 rule), snapping, keyboard/Tab scrolling, a strip beside an intro column, a strip in a narrower painted
card, designs wider than 1440, 992–1100 laptops, the section's own overflow already set (hidden/clip), sticky
ancestors, pages with the site header tick, and that tablets/phones (the phone slider copies) are unchanged.
