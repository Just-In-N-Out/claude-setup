# Role: REVIEWER (the one review) — djtrees-faint-picture (job 13)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them. Self-check
correction: run `ac-check` with your own `E/verifier/ac.json` and a `cp`'d scratch copy (the same file twice exits 2).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faint-picture`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC6 by test/receipt; AC7 live, paste check 3cv).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-afabbdb7c4e4f34fc`, branch
  `worktree-agent-afabbdb7c4e4f34fc`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `c8dbbd27d6e0421a8f229db3c722ac8a05a06661`.

The request: the DJ Trees FAQ tree showed solid black on the site while Figma draws it light grey at 22%. The plan's
general rule: a picture shown from its own uploaded file (`fill:<hash>`) gets its image fill's opacity × its layer's
opacity as the element's Opacity (`_opacity`), the original file unchanged, in both picture modes (WordPress Image
element and inline Div); a faded picture with a stroke uses Figma's render (`node:<id>`, fade and stroke drawn in);
the fade carries into a CSS hover's opacity and Figma Motion's opacity keyframes, and into phone copies. Files:
`style/picture-shadow.ts`, `picture.ts`, `states.ts`, `motion.ts`.

The builder reports: M4 (removing `fillFade`'s kind check) survives as equivalent; follow-ups F1–F3 (a faded photo as a
box background stays full strength; a CSS hover/Motion stacks the layer's opacity over a Figma render; a hover-layer
frame loses its own opacity) are Deferred. Judge each, and whether F2 is made worse by this job.

Things worth probing: a faded picture inside a hover component (rest and hover), a picture with opacity animated by
Figma Motion (fade-in), product/team card photos (the zoom-and-glare showcase) and CTA fade-ins that also set
opacity (`cta-motion`'s Interaction, showcase fade-in: does `_opacity` fight them?), a faded picture that is a link,
a faded picture in a slider's phone copy, a faded cut-out (see-through file, `contain`), videos (excluded), SVG
drawings (renders), layer opacity alone (unchanged), and Bricks' `_opacity` control vs custom CSS per CLAUDE.md
("a value with a Bricks control goes in that control's key").
