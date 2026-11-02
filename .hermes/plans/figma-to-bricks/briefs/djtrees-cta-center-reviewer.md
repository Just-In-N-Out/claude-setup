# Role: REVIEWER (the one review) — djtrees-cta-center (DJ Trees designer note 3)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-cta-center`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC10 by test/receipt; AC11 live, paste check 3cl).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a7e20dbd6f83af3ab`, branch
  `worktree-agent-a7e20dbd6f83af3ab`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `af337379bcb8c92ee6a84deaa7320a86510fa999`.

The request: "On mobile, let's have the text on all the buttons center-aligned." The plan's general rule: a new rule
`cta.center` (`src/core/adapt/rules/cta-center.ts`) writes `justify-content: center` on phones (767 and down) for every
call-to-action pill whose content Figma draws in the middle, and on its hover layer, centring its label lines; plus a
guard in `cta.ts` so a pill's own hover layer never makes the pill wrap (its arrow dropped under the words at 320).

The builder reports: AC1's gap oracle compares with the pill's computed `column-gap` instead of the 991 gap (the plan
allowed for `space.ramp` narrowing it); extra fixture controls; four surviving mutants (C10, G3 claimed equivalent;
C7 unreached; C14 defensive, no list/FAQ control); and found_else 2 (at 320 a wrapped label's group can sit up to
~25px off the middle, inside the approved Q2-A look) and 3 (a hover layer over a tag counts as a call to action, so
`cta.fullWidth` stretches that tag; brainstorm's nav pill). Judge each, especially whether found_else 3 is made
worse by this job and whether the survivors are really equivalent or leave a guard untested.

Things worth probing: Bricks Buttons (already centred) untouched, pills with the icon before vs after the words,
icon-only buttons, tags/chips in rows, floating pills, a pill whose content Figma spreads (space between) or draws at
the left (form-like), pills hidden on phones, the hero's phone-button copies at 600/767, hover layers drawn off-centre,
pills inside cards that stretch, very long labels at 320, and the inline vs WordPress picture modes for icon pills.
