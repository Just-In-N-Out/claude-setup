# Role: FIXER — djtrees-strip-edge (DJ Trees designer note 12; after the one review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it.

Justin's chain: one review; if it finds a P0–P2, a fixer fixes it and the verification checks the fix (no second
review). You are that fixer. Fix only the P2 below, test-first. The P3s are in `E/follow-ups.md`; you may also correct
the HANDOFF classic-scrollbar wording (R1-3) since it's one sentence, nothing else.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-strip-edge`; you write in `E/fixer/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` and the reviewer's witness
  in `E/review-1/` (`r1-1-free-track.log`, `r1-1-free-track-{head,base}-{1440,1920}.png`, its scripts).
- The job's head `a14d43929666e729698b10f3359f822d8fcac7ec` is on branch `worktree-agent-a6c9fc7c6ea4e0695` (the
  builder's worktree; don't write there). **Task 0:** in your own worktree, `git merge --ff-only a14d43929666e729698b10f3359f822d8fcac7ec`.
  Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`. Commit your fix on your own branch.
- Ledger: append a "Review 1 fix" section to `.superpowers/sdd/2026-11-02-djtrees-strip-edge/progress.md`.

## Skills

1. `receiving-code-review` (verify first; push back with evidence if it doesn't hold). 2. Project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FIXER role. 3. `engineering-best-practices`.
4. `test-driven-development`. 5. `mutation-testing-discipline` for the new guard.

## The finding

**R1-1 · P2 · `src/core/understand/strips.ts:60`:** `runOut` checks the boxes between the Container and the strip but
never what the strip holds, so a strip with absolutely placed cards or decorations also runs out. Placed layers sit at
`left: Xpx` from the strip's padding box (`style/place.ts:60`), so the new padding doesn't move them: they land E px
left of the flowing cards, the scroll range shrinks by 2E, and the last card stops at the window's edge. Scenario: a
carousel drawn as a plain frame with hand-placed cards (no auto layout), Clip content off, horizontal scrolling, in an
auto-layout section: at 1920 the 4th card is drawn over the 3rd (cards 320/704/1088/1152/1536/1920 vs base's
320/704/1088/1472/1856/2240) and it stops scrolling 640px early. Reviewer's smallest fix: `runOut` returns null when
the strip holds a placed layer (looking through a Container of its own frame), or the 992-up block adds E to placed
layers' `left`. Pick the general, exact one (say why), and add that fixture to AC5's cases with a mutant.

## Done means

The finding fixed (or rejected with evidence) with a test that fails on `a14d439` and passes on your head; every AC's
test still passes; `npm run check` green; the five other real files byte-identical and DJ Trees differing only in the
two carousel tracks as before; committed; worktree clean; status `ready-for-verification`.

## Return

`status`, `worktree`, `branch`, `last_commit` (full SHA), commits, files changed, the finding's outcome, gates with
results, `found_else`, `skill_lessons`.
