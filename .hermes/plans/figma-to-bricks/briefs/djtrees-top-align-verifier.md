# Role: VERIFIER — djtrees-top-align (after the review-1 fix)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align`
- Approved plan: `E/plan-approved.md` (AC1–AC7 by test/receipt; AC8 live, 3cn).
- Fixer's worktree (the job's head now; for `ac-check --repo`): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-ae6561d4d73a3f9f7`,
  branch `worktree-agent-ae6561d4d73a3f9f7`.
- **head** `d5e3eac8ffac0de857c7f10493e889271eb55c86` (fix code at `9792338`), pre-fix head `c2a3d2c`, **base**
  `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- The finding: `E/review-1/review.json` R1-1 (P2, a painted frame around an unpainted label column stopped counting
  as a button and stretched). The fix carries the boxes above through `button()`'s single-child recursion. AC6 (the DJ
  Trees label tops in Chrome) wasn't re-measured by the fixer: run it.
