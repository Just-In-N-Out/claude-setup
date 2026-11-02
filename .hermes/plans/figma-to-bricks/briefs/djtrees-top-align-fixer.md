# Role: FIXER — djtrees-top-align (DJ Trees designer note 5; after the one review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it.

Justin's chain: one review; if it finds a P0–P2, a fixer fixes it and the verification checks the fix (no second
review). You are that fixer. Fix only the P2 below, test-first. The P3s are in `E/follow-ups.md`: leave them.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align`; you write in `E/fixer/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` and the reviewer's probes in
  `E/review-1/` (`probe-*.log`, `probe2-*.log`, `fix-probe.log`: its candidate fix read paint first and crashed 2
  `rowEven` tests whose fakes have no `fills`).
- The job's head `c2a3d2cc37957e30e27d10c9d18d7b59a14034f0` is on branch `worktree-agent-a955a6278526de73d` (the
  builder's worktree; don't write there). **Task 0:** in your own worktree, `git merge --ff-only c2a3d2cc37957e30e27d10c9d18d7b59a14034f0`.
  Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`. Commit your fix on your own branch.
- Ledger: append a "Review 1 fix" section to `.superpowers/sdd/2026-11-02-djtrees-top-align/progress.md`.

## Skills (load first, one line each when you do)

1. `receiving-code-review`: verify the finding before fixing; push back with evidence if it doesn't hold.
2. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FIXER role. 3. `engineering-best-practices`.
4. `test-driven-development`. 5. `mutation-testing-discipline` for the new clause.

## The finding

**R1-1 · P2 · `src/core/style/shares.ts:44-49`:** a painted or outlined two-line button built as a painted frame
around an unpainted text column ("Call now / number") is no longer read as a button: `button()` recurses into the
frame's single child, which is now an unpainted stacked label box, so it doesn't count, and the outer frame's paint
is never checked (base read it as a button through "a box holding only one"). This breaks the approved Q1 ⭐A and the
plan's "must not change" list. Scenario: two painted contact buttons side by side, each a painted frame around a text
column; between 992 and the design width the email wraps and the Call button stretches ~30px taller (Chrome at 1100:
81 → 111px). Reviewer's smallest fix: a painted or outlined box whose only flow child is a label box counts as a
button; test the child before reading paint. Add nested painted and outlined variants to the AC3 test.

## Done means

The finding fixed (or rejected with evidence) with a test that fails on `c2a3d2c` and passes on your head; every AC's
test still passes; `npm run check` green with every existing test unedited; the six real files' diffs unchanged from
the builder's (only DJ Trees `pcvtlz` and brainstorm `gmsmdw`); committed; worktree clean; status
`ready-for-verification`.

## Return

`status`, `worktree`, `branch`, `last_commit` (full SHA), commits, files changed, the finding's outcome, gates with
results, `found_else`, `skill_lessons`.
