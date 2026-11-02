# Role: FIXER, round 1 — djtrees-side-art (DJ Trees designer note 4; Full, capped rounds)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` (note its new "Ticks" line) and follow it.

Fix the P0–P2 findings of review round 1 test-first; a fresh round-2 review follows. Leave the P3s (in
`E/follow-ups.md`).

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art`; you write in `E/fixer-1/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` with its probes
  (`tick-probe.log`, `photo-first-probe.log`, `shots/photo-first-390.png`, `wave-probe.log`, scripts).
- Job head `011e0f9e28a4138eeba12d81eac0ce9a209081f9` on branch `worktree-agent-a5392028d6f9d6031`. **Task 0:** in your
  own worktree, `git reset --hard 011e0f9e28a4138eeba12d81eac0ce9a209081f9`. Base `1aef12f`. Commit on your branch.
  Don't rebase (a rebaser does that after the round-2 review).
- Ledger: append a "Review 1 fixes" section to `.superpowers/sdd/2026-11-02-djtrees-side-art/progress.md`.

## Skills

`receiving-code-review` (verify each finding first; push back with evidence where it doesn't hold), the project skill
(FIXER role), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`.

## The findings

1. **R1-1 · P1 · `src/core/adapt/rules/section-top.ts:30`:** Convert throws with "My site already has its header"
   ticked: `frozenTop` calls `heroOf(ctx.page)` at adapt time, after `planRoom` (`understand.ts:106`) put the src-less
   header-room spacer first; `heroOf` reads `next.src!.box` (`recognise.ts:131`). Hits DJ Trees Home, brainstorm and
   the job's own fixture with the tick; base converts them all. Keep the hero excluded once the spacer is present
   (filter `role: "spacer"` as `adapt/layout.ts:54` does), and keep the space `designs.ts` `keepBeside` adds above a
   section next to a left-out header (from 991 down `section.top` replaces that padding: check it with a probe). Add a
   test converting with the ticks on (and run AC9's witness with the ticks on too).
2. **R1-2 · P2 · `src/core/understand/compose.ts:64`:** the guard "the heading lies in its parent's first flowing
   part" never holds anything back for a section (its first flowing part is the Container holding all its words), so
   when a section's column opens with a photo and then the heading, faint art over the heading moves to the section's
   top, ~210px above its heading at 390 (under the photo). Make the art go beside its heading (or stay as drawn when
   it can't), with a photo-first control test.
3. **R1-3 · P2 · `src/core/adapt/rules/section-top.ts:34`:** hills/a wave drawn as wide as the section across the
   bottom edge of a frozen section get `top`/`bottom` written at tablet by both `section.top` and `art.edge`, neither
   listing the other in `overrides`: 2 collisions where base has none. Resolve it per the architecture rules (skip
   such layers here, and keep them out of the min-height `reach`, or a declared override), with a test asserting
   `collisions` is `[]`.

## Done means

Each finding fixed (or rejected with evidence) with a test that fails on `011e0f9` and passes on your head; every AC's
test still passes; `npm run check` green; the six real files converted with and without the ticks (no throw, no
collisions, changes only where AC9 allows); committed; worktree clean; status `ready-for-review`.

## Return

`status`, `worktree`, `branch`, `last_commit` (full SHA), commits, files changed, each finding's outcome, gates with
results, `found_else`, `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
