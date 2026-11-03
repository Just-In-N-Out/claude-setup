# Role: REVIEWER (the one review) — djtrees-faq-art (DJ Trees designer note 10, phones)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them (Justin's mini
chain: ONE review; a fixer fixes any P0–P2 and the verifier then checks the fix, no second review). Self-check: run
`ac-check` with your own `E/verifier/ac.json` and a `cp`'d scratch copy (the same file twice exits 2). Fonts: inject the
DJ fonts into rendered pages (djtrees-common "Fonts"). Bound any mutation run (djtrees-common, 4 GB cap).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faq-art`
- Approved plan: `E/plan-approved.md` (AC1–AC6 by test/receipt; AC7 live, paste check 3cs).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-af58a4e32ccf64c0f`, branch
  `worktree-agent-af58a4e32ccf64c0f`.
- **base** `e1dc5a6912f7d15c9505148651bc4bc7974f7c84` (djtrees-side-art's reviewed head; this job builds on its R2
  side-art rule), **head** `c9b50da8ea31be16526379ec911f0f4d58bf79dc`. Review `git diff base..head` only (side-art was
  reviewed on its own).

The request: on phones the FAQ section's big faint tree sat over the questions. The builder added `away()` in
`compose.ts` (faint art in the empty space of the heading's row moves beside the heading where its row stacks, painted
under the words: `zIndex -1` plus `isolation: isolate` on its parent at its first tier), split job 4's shared conditions
into `sideArt()`, and let `besideHeading` read a named row.

Judge the builder's rulings (HANDOFF, not yet confirmed): empty space covers every flowing part between the art's
parent and the row; `under` only for art drawn over the flow; `row` named only where the nearest-row lookup would pick
another row; isolation on the art's parent at its first tier; the fixture's plain-words variant became three one-line
texts. And its found_else: laptops 992–1150 still overlap 2–61px (approved follow-up Q4/F2); a row keeping its line on
tablets with art under its first column meeting the second; a heading inside a small row of two.

Worth probing: `isolation: isolate` on a parent that has other z-indexed layers (photo hotspots, flip cards, a sticky
header spacer), a section that holds a hover component (CLAUDE.md: hovered components never get a z-index), art drawn
first vs over the flow, a painted section (z-index −1 must not go under the paint), ticks on (header/footer), a drawn
phone design (fits/shows only), and that side-art's own tests are unedited and green.
