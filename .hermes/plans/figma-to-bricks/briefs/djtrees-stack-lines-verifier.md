# Role: VERIFIER — djtrees-stack-lines (after the review-1 fix)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines`
- Approved plan: `E/plan-approved.md` (AC1–AC7 by test/receipt; AC8 live, 3co).
- Fixer's worktree (the job's head now; for `ac-check --repo`): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a11b1e13518a59c2f`,
  branch `worktree-agent-a11b1e13518a59c2f`.
- **head** `d0a81c96324b82351367a34150fc81fc67bdea64` (fix code at `72bf228`), pre-fix head `8464f71`, **base**
  `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- The finding: `E/review-1/review.json` R1-1 (P2, a zigzag pair shown reversed got the line on the photo's top). Use
  the fixer's screen-order probe `E/fixer/zigzag-chrome.ts` or your own: the reviewer's probe reads DOM order and can't
  see the fixed line.
- Also judge the fixer's found_else 1 (recorded in `E/follow-ups.md`): in a zigzag pair split by a divider, the line
  sits flush under a picture-covered photo, photo→words 29px vs base's 60. Is that a P0–P2 against the plan's AC3
  ("midway, never under 16px") for photo items, or a follow-up? Say which with evidence.
