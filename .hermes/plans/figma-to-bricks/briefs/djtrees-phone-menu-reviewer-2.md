# Role: REVIEWER, round 2 (full) — djtrees-phone-menu (DJ Trees designer note 2; Full, capped rounds)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them. This is the last
planned review (review rounds are capped): report bugs a real site or normal use hits as P0–P2; edge cases go to P3.
Self-check: run `ac-check` with your own `E/verifier/ac.json` and a `cp`'d scratch copy. Fonts as `data:` URLs with a
load check. Bound every mutation run (never `assert.deepEqual` whole IR trees).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu` (write `E/review-2/`; move the old
  `E/verifier/` to `E/verifier-review1-2153d8d/` first, then write a fresh `E/verifier/`).
- Approved plan: `E/plan-approved.md` (AC1–AC9 by test/receipt; AC10 live, paste check 3ck, DJ staging on Bricks 2.4.4).
- Fixer's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a27c25d81789a14c0`, branch
  `worktree-agent-a27c25d81789a14c0`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `594be2685ac3970f0da516aa90230a9957eb4b83` (job head
  `2153d8d` + fix `71d0ecd` + docs `594be26`). Review the WHOLE story base..head (round 2 is full), with extra care on the
  fix.

Round 1 (`E/review-1/review.json`): R1-1 P2 (a bar that never folds still got a ☰ from 767 down) and R1-5 P3 (no
reduced motion on the panel's slide) were fixed (`E/fixer-1/`): `phone.swap` leaves a menu copy to `navigation.menu`;
emit leaves out a Nav shown at no tier (keys kept in `assignIds`); `adapt/kinds.ts` `iconRow` skips the copy (a second
cause the fixer found); a reduced-motion block in the Nav's custom CSS. R1-2/R1-3/R1-4 stay P3 in `E/follow-ups.md`.

Judge especially: that leaving the unshown Nav out of emit can't drop or mis-id anything else (page-addresses relink,
paste ids, nested links, `ConvertResult.pageLinks` still listing left-out ids); that other readers of a row's children
(beyond `iconRow`) don't count the copy (search them); that `phone.swap`'s exemption can't hide another phone-only copy
(sliders, hero buttons band, intro buttons); the reduced-motion block's selector on a pasted page (Bricks gives new ids:
CLAUDE.md "Bricks gives pasted elements new ids" — check the block names the element the way the plugin's other
per-element CSS does and survives a paste); plus every AC on the new head.
