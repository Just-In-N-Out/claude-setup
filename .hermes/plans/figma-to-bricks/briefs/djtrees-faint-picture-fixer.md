# Role: FIXER — djtrees-faint-picture (job 13; after the one review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it.

Justin's chain: one review; a fixer fixes its P0–P2; then one verification (no second review). Fix the P2 below
test-first. Leave the P3 (in `E/follow-ups.md`). Don't rebase: a rebaser places the job in the merge train after you.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faint-picture`; you write in `E/fixer/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` and `E/review-1/video-probe.log`.
- Job head `c8dbbd27d6e0421a8f229db3c722ac8a05a06661` on branch `worktree-agent-afabbdb7c4e4f34fc`. **Task 0:** in your
  own worktree, `git reset --hard c8dbbd27d6e0421a8f229db3c722ac8a05a06661`. Base `1aef12f`. Commit on your branch.
- Ledger: append a "Review 1 fix" section to `.superpowers/sdd/2026-11-02-djtrees-faint-picture/progress.md`.

## Skills

`receiving-code-review` (verify first), the project skill (FIXER role), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline` (re-run the builder's mutants for the functions you touch).

## The finding

**R1-1 · P2 · `src/core/style/picture-shadow.ts:41` (`fillFade`):** `picture.ts:59` returns `videoStyled` before R1
runs, so a Video rests at its layer opacity with no fade, but `states.ts:44` and `motion.ts:61-62` still multiply hover
and Figma Motion opacity by the still's fill fade. A layer marked as a video ("Video: https://…" or an Open link) whose
still is a 50% image fill: with a Motion fade-in head animates 0 → 0.5 then snaps to 1 (base 0 → 1); with a hover to
layer opacity 0.5 head writes `_opacity:hover` 0.25 (base 0.5). The plan and HANDOFF say videos are unchanged. Smallest
fix: `fillFade` returns 1 for a node shown as a video (use the same test `picture()` uses), with tests for the Motion
and the hover cases.

## Done means

The finding fixed (or rejected with evidence) with tests that fail on `c8dbbd2` and pass on your head; every AC's test
still passes; `npm run check` green; the six real files (ticks off and on, both picture modes) differ from base only in
the FAQ tree's `_opacity`; committed; worktree clean; status `ready-for-verification`.

## Return

`status`, `worktree`, `branch`, `last_commit` (full SHA), commits, files changed, the finding's outcome, gates,
`found_else`, `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
