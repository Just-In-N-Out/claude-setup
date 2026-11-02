# Role: VERIFIER — djtrees-storm-photo (after the review-1 fix)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-storm-photo`
- Approved plan: `E/plan-approved.md` (AC1–AC11 by test/receipt; AC12 live, 3cq).
- Fixer's worktree (the job's head now; for `ac-check --repo`): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a5b96bb4405e7c349`,
  branch `worktree-agent-a5b96bb4405e7c349`.
- **head** `e16982d4e2d947e093876a0456cc08601876d501` (code at `8a71689`), pre-fix head `a10aed1`, **base**
  `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- The finding: `E/review-1/review.json` R1-1 (P2, layers placed in a stacked box kept their drawn top while the words
  moved down). The fixer's ruling (HANDOFF, not yet confirmed): a box holding a placed layer, or under a layer placed
  over it in any box out to the section (hover layers and phone copies aside), doesn't stack; it keeps `crop.subject`.
  Check the fix is general and that the plan's AC7 meaning ("only side photos beside their words stack", the negative
  controls) holds with the new exclusion. The browser test with the DJ Trees file needs `F2B_SIDE_PHOTO_FILE`.
