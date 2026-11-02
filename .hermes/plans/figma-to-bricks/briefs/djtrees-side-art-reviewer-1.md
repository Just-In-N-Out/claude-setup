# Role: REVIEWER, round 1 (full) — djtrees-side-art (DJ Trees designer note 4; Full, capped rounds)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them (this job is
Full at its planner's ⭐, so a second review may follow a fix; you do round 1). Self-check correction: run `ac-check`
with your own `E/verifier/ac.json` and a `cp`'d scratch copy (the same file twice exits 2). Fonts: inject the local
copies in `E/builder/fonts/` into rendered pages (djtrees-common.md "Fonts"), or design-width geometry won't match.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art`
- Approved plan: `E/plan-approved.md` (ACs AC1–AC9 by test/receipt; AC10 live, paste check 3cm).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a5392028d6f9d6031`, branch
  `worktree-agent-a5392028d6f9d6031`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `011e0f9e28a4138eeba12d81eac0ce9a209081f9`.

The request: on phones the "What we do" section opened with a tall empty space above its words, a big faint tree
hanging off the right. Two general rules:
- **R1 `section.top`** (`src/core/adapt/rules/section-top.ts`): a fixed-height section drawn without auto layout with
  its words against its bottom gets, from 991 down, its drawn top space as stepped top padding (96 → 67 → 48),
  content from the top, min-height only what top-pinned placed layers need; layers across the bottom edge keep their
  bottom distance (`top: auto; bottom: …`). Shares `unpin.ts` `reach` (exported with a `skip`).
- **R2 side art** (`compose.ts` `beside`/`faint`, `rules/art.ts` `artBeside`): a faint placed picture or drawing (no
  words, no link, < 90% wide) meeting the section's first heading moves, from the tier where the heading's row stops
  keeping its line or the art no longer fits, beside the heading: width `min(W·k, 40% of the column)`, in flow with
  `order: -1`, a negative bottom margin so the words never move, keeping its opacity and paint order.

The builder reports (judge each): DJ 02's tree moves from 767 down (the "no longer fits" trigger) where the plan's Q5
note predicted 478; trees in 05 and 08 stay painted over the ends of their words (as drawn, per Q2) and cover letters
on phones until djtrees-faint-picture lands; 08's first heading is the image-filled "24/7"; two brainstorm sections
change (they lost min-height on tablets on base); DJ 06's tablet top space goes 64 → 67; R1's tablet min-height still
counts side art's drawn reach; a Container narrower than the screen leaves side art at the section's edge; 5 R2
survivors (two equivalents, an unreachable group, the drawn-phone guard, the `!k.compose` guard).

Things worth probing: sections with a decoration pinned to the top (must keep its place), sections with fixed height
and centred words (not this rule), an auto-layout section (untouched), bottom-pinned hills/waves along the bottom edge,
the header tick's spacer, the hero (excluded), side art on the left, art that is a photo (opaque: excluded), art whose
heading is long (no room beside it), 320 phones, the FAQ section's tree (job 10 builds on R2: is R2's API usable for
art lying in the empty space of the heading's row?), and the faq-art plan's needs recorded in the ledger.
