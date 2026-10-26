# responsive-pill-planning — fresh REVIEWER brief (2026-10-22 00:19 EDT)

Review only, Opus xhigh. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/responsive-pill-planning, tip c439312, base main 5474523 (.25). NOTE: gro-composition-clipping's finisher is merging right now (it will become build .26; the re-reviewer showed the two branches apply cleanly together, union output, no collisions, only shared output is GRO 'Let's GRO' button padding — different property). Review `git diff 5474523...HEAD` against the approved plan ~/.hermes/plans/figma-to-bricks/responsive-pill-planning.md (incl. its Dispatcher ruling) and briefs/responsive-pill-planning-builder.md (incl. the pre-granted test exception rule).

## Commits
38633ef F3 peer sides (sides.ts peersOf/target/peerPhoneSide; layout.ts child pre-pass, upright-phone slot map, phone() accessor; least.ts view() plan-view only; space.ts SideView). a8b1756 G1 (separate, droppable; builder ruling: hug box judges L1A phone guard by min(maxWidth, parent slot)). 5ed5d97 list-title fix (exclude list column titles/records via kinds.ts listLine, read-only import). c439312 records.

## Judge
1. `least` unchanged (builder diagnostic shows zero least/content/row/column deltas over 5 corpus + debug copy + inspo) — verify yourself.
2. Peer definition: alike = buttonLike, same role, same drawn and styled sides; never divided rows, list lines, cards; never top/bottom. Over- or under-grouping risks.
3. G1 ruling: inspo drawn-24/4 arrow pills 20→24, a 32 hug wrapper 20→32 at 390–360 — acceptable? Corpus/debug ≤1px phones only — verify ≤2px corpus-wide claim.
4. Test exception: test/golden/files/convert-sample.json:162-163 `min(140px, <slot>) - 92px` → `<slot> - 92px` — same value? Justified?
5. Chrome at 375/360/320 (project rule for phone padding) + 390, and laptop 992–1440 unchanged (gates blind there; measure right edges). Only `_padding:mobile_portrait` on 40 real elements should change.
6. Mutations of peersOf/target/slot logic.
Pre-existing/open (not findings): arrow-row allocation, 27.52→"28" rounding, wrapped-row least W-B (deferred option A).
Change nothing; restore anything; kill only orphan Chrome; always pass workdir. Other bugs → found_else.
