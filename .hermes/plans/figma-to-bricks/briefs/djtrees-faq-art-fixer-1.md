# Role: FIXER, round 1 — djtrees-faq-art (DJ Trees designer note 10; Justin's mini chain: no second review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it (Chrome, fonts, ticks as
a JSON string, bounded mutation runs: never `assert.deepEqual` whole IR trees, never end your turn to wait).

Fix the two P2 findings of review 1 test-first. No second review follows (Justin's mini chain): a fresh verifier and
a blind auditor check your fix, so leave clean evidence. Leave the P3s (R1-3, R1-4, R1-5) in `E/follow-ups.md`.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faq-art`; you write in `E/fixer/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` with its probes
  (`review-1/probes/`: `probe-paint.ts`, `row-painted-390.png`, `intro-painted-390.png`, the icon-row probe, mutants).
- Job head `c9b50da8ea31be16526379ec911f0f4d58bf79dc` on branch `worktree-agent-af58a4e32ccf64c0f`, base
  `e1dc5a6912f7d15c9505148651bc4bc7974f7c84` (djtrees-side-art's head). **Task 0:** in your own worktree,
  `git reset --hard c9b50da8ea31be16526379ec911f0f4d58bf79dc`. Commit on your branch. Don't rebase.
- Ledger: append a "Review 1 fixes" section to `.superpowers/sdd/2026-11-02-djtrees-faq-art/progress.md`; add one line
  per fix to the job's HANDOFF section.

## Skills

`receiving-code-review` (verify each finding first; push back with evidence where it doesn't hold), the project skill
(FIXER role), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`.

## The findings

1. **R1-1 · P2 · `src/core/adapt/rules/art.ts:116`** (`under` set at `compose.ts:130`): art marked `under` gets
   `z-index: -1` inside its isolated section, so it goes under every painted box there, not only the words. With the
   heading's column or its row painted (an intro card; a white panel around intro and questions), the moved art is
   hidden from 991 down (9/9 probe points covered at 390/767/991; unpainted control 0/9; DJ's own FAQ unaffected).
   Reviewer's suggestion: set `under` only when no box between the art's parent and the heading has its own paint;
   otherwise paint it as drawn (job 4's `beside`). Add the painted-panel and painted-intro cases as tests (the art must
   stay visible AND off the questions/words).
2. **R1-2 · P2 · `src/core/understand/compose.ts:119`**: R is always the heading's nearest row of two or more items, so
   a heading beside a small icon makes R that small row and the art moves only at upright phones (≤478); from 991 to
   479 it stays over the questions (note 10's bug). Reviewer's suggestion: take the nearest row of two or more items
   whose box the art's box meets; add the icon-row case as a positive test.

Keep every approved AC test green with its meaning (AC1–AC6) and the DJ replay/witness receipts (AC5, AC6) unchanged
for DJ (its FAQ must still be byte-identical to the job head's output, or explain each difference). Re-run `npm run
check`, the side-art tests, both receipts with ticks off and on, and mutants for each new condition.

## Return

Per finding: verified or pushed back (evidence), the fix, the red→green test names and logs, mutants. New head (full
SHA), branch, gates, `found_else`, `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
