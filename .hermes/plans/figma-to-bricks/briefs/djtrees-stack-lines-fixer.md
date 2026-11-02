# Role: FIXER — djtrees-stack-lines (DJ Trees designer note 6; after the one review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it.

Justin's chain: one review; if it finds a P0–P2, a fixer fixes it and the verification checks the fix (no second
review). You are that fixer. Fix only the P2 below, test-first. The P3s are recorded in `E/follow-ups.md`: leave them.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines`; you write in `E/fixer/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json`, the reviewer's probes in
  `E/review-1/` (`probe.ts`, `probe.log`, `probe-shots/zigzag-390.png`).
- The job's head `8464f71d751a76845223e5c3621d5c2549449923` is on branch `worktree-agent-a605ace0a8e3f3af3` (the
  builder's worktree; don't write there). **Task 0:** in your own worktree, `git merge --ff-only 8464f71d751a76845223e5c3621d5c2549449923`.
  Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`. Commit your fix on your own branch.
- Ledger: append a "Review 1 fix" section to `.superpowers/sdd/2026-11-02-djtrees-stack-lines/progress.md`.

## Skills (load first, one line each when you do)

1. `receiving-code-review`: verify the finding yourself before fixing it; push back with evidence if it doesn't hold.
2. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FIXER role. 3. `engineering-best-practices`.
4. `test-driven-development` (a failing test first). 5. `mutation-testing-discipline` for the new guard.

## The finding

**R1-1 · P2 · `src/core/adapt/rules/rows.ts:51`:** `acrossLines` doesn't allow for a row that `split.order`
(`split.ts:15`) shows reversed once stacked (`column-reverse`, `n.split?.reverse`); `drawAcross` puts the line on the
top of items 2…n in source order (`rows.ts:75`). In a zigzag photo/text pair split by a thin line, phones show a stray
line above the photo and none between the photo and its words, and the gap 0 + 16px paddings cut the photo↔words
space from 60 to 28px (base draws no line there). The reviewer's smallest fix: refuse the across tiers when
`n.split?.reverse`, or draw the lines in the order they show. Pick the general one that keeps every AC's meaning (say
why), and add the zigzag (thin layer and outline variants) as a control test.

## Done means

The finding fixed (or rejected with evidence) with a test that fails on `8464f71` and passes on your head; every AC's
test still passes; `npm run check` green; the DJ Trees and other real-file diffs unchanged from the builder's (only the
3 divided rows; brainstorm only its index row); HANDOFF updated if the rule's wording changes; committed; worktree
clean; status `ready-for-verification`.

## Return

`status`, `worktree`, `branch`, `last_commit` (full SHA), commits, files changed, the finding's outcome, gates with
results, `found_else`, `skill_lessons`.
