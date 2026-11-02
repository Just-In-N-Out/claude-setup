# Role: REVIEWER (the one review) — djtrees-panel-edge (DJ Trees designer note 1, desktop)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them. Self-check
correction: run `ac-check` with your own `E/verifier/ac.json` and a `cp`'d scratch copy (the same file twice exits 2).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-panel-edge`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC10 by test/receipt; AC11 live, paste check 3cj).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a270eaf5b45b4d563`, branch
  `worktree-agent-a270eaf5b45b4d563`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `4ec8614aaef638f4359d712502291cdf99010f90` (code as
  of `33c418d`).

The request (desktop): the green panel of the "24/7 Emergency Tree Services" band should reach the right edge so no
photo shows past it. The plan's general rule: on screens wider than the page's Container, a panel drawn against one
side of its section reaches that side of the window: the layers painting its backdrop (a covering drawing, picture
or wordless painted layer, or the panel's own flat colour, plus 31.2's grouped photos in clipping groups) grow to the
window's edge like section photos; its words, buttons and placed layers stay; nothing changes up to the Container's
width (or the design width when narrower). Files: `src/core/style/edge-photo.ts`, `wide.ts`, `style.ts`.

The builder's rulings (not yet confirmed; in HANDOFF): a flat panel with an outline is left as before; the flat colour
continues as a one-sided `border-image` outside the box (not a shadow copy); a clipping panel gets `overflow: visible`
plus a one-sided `clip-path`; an element already carrying another rule's design-width CSS keeps that width. Judge
each: `clip-path` vs the panel's own placed layers, hover states, focus rings and drop shadows; `border-image` vs
rounded corners, gradients, a panel's own border; `overflow: visible` letting other children spill past the panel.

Things worth probing: panels against the left vs right, a panel drawn without auto layout vs in auto layout, a panel
whose backdrop is a photo, a gradient or a picture fill (the plan keeps those as today), a panel with a hover state, a
panel holding a slider/strip or a form, a band with the header tick's spacer, designs at 1280, 1440, 1728 and 1920
wide, screens from 1441 to 2560, a page with a Windows-style classic scrollbar (100vw), RTL, and that the five other
real files stay byte-identical.
