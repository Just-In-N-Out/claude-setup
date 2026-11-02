# Role: FIXER — djtrees-storm-photo (DJ Trees designer note 8; after the one review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it.

Justin's chain: one review; if it finds a P0–P2, a fixer fixes it and the verification checks the fix (no second
review). You are that fixer. Fix only the P0–P2 below, test-first. The P3s are recorded in `E/follow-ups.md`: leave
them.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-storm-photo`; you write in `E/fixer/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` and the reviewer's probes in
  `E/review-1/` (`probe-placed-leaf.ts`, `r1-1-leaf-*.png`, `r1-1-leaf-head.txt`).
- The job's head `a10aed1933d0428cdd29371943833d03b4ea1be6` is on branch `worktree-agent-a15a7d44ced8063a2` (the
  builder's worktree; don't write there). **Task 0:** in your own worktree, `git merge --ff-only a10aed1933d0428cdd29371943833d03b4ea1be6`.
  Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`. Commit your fix on your own branch.
- Ledger: append a "Review 1 fix" section to `.superpowers/sdd/2026-11-02-djtrees-storm-photo/progress.md`.

## Skills (load first, one line each when you do)

1. `receiving-code-review`: verify the finding yourself before fixing it; push back with evidence if it doesn't hold.
2. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FIXER role. 3. `engineering-best-practices`.
4. `test-driven-development` (a failing test first). 5. `mutation-testing-discipline` for the new guard or carry.

## The finding

**R1-1 · P2 · `src/core/adapt/rules/side-stack.ts:187`:** layers placed directly in a stacked box keep their drawn top
(Bricks `_top`, relative to the section) while the words move down by the photo's height H (the new top padding), so
from 991 down a decoration or label placed on the words' side lands on the photo or on the moved words; the guard at
`side-stack.ts:94` only refuses layers drawn over the photo. Scenario: a leaf drawing placed at top 480 beside the
paragraph covers 3 paragraph line boxes at 390 (base: none); a badge at the top of the words' side lands on the photo.
The reviewer's fix options: carry the box's own placed layers down by H at each tier (`top: calc(H + drawn top)`,
with that tier's `min()`), or keep `crop.subject` for a box holding such a layer (besides hover layers and phone
copies). Pick the one that is general, keeps every AC's meaning and stays inside the plan's files (say why); add a
placed-drawing fixture to the AC3/AC7 tests (a decoration beside the words and a badge at the words' top).

## Done means

The finding fixed (or rejected with evidence) with a test that fails on `a10aed1` and passes on your head; every AC's
test still passes; `npm run check` green; the DJ Trees replay still differs only in the storm section and its
Container, the other five real files byte-identical; HANDOFF section updated if the rule's wording changes; committed;
worktree clean; status `ready-for-verification`.

## Return

`status`, `worktree`, `branch`, `last_commit` (full SHA), commits, files changed, the finding's outcome (fixed with
test and commit, or rejected with evidence), gates with results, `found_else`, `skill_lessons`.
