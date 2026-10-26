# gro-composition-clipping — BUILDER brief (2026-10-21 ~22:12 EDT)

Opus medium. Approved under Justin's autonomous round-4 grant (briefs/autonomous-round4-planners.md) and his away rule "take the recommended answer for every plan". Plan: ~/.hermes/plans/figma-to-bricks/gro-composition-clipping.md — approved; do not re-plan. Evidence: evidence/gro-composition-clipping/.

## Scope (from the plan)
Fix G2 ('04' cut at 991–480) and G3 (footer 'Contact' cut at 768): fixed-pixel child + percentage inferred row gaps over-allocate → the plan's free-space margin formula in place.ts nudgeStyle. Fix G5: composed content box keeps 525px height on phones → auto height in compose.ts layerStyle. Defer G1 (desktop off-edge card = intentional Figma crop) and G4 (992 paragraph, prior laptop P1A policy). No carousel/global-width redesign, no blanket overflow-visible, no clip dropping. G6/G7 are found-else, unowned.
Owned files and read-only gates exactly as in plan section 7.

## Sequencing (dispatcher ruling)
Plan section 7 allows parallel building if you start from current main and the merge happens only after fixed-tile-shrink. Start from main 3f14a32 (build .24). fixed-tile-shrink (kinds/shapes/unpin/rows) is in its second review and will merge first; no source overlap. Your finisher will rebase onto it and regenerate same-base before/after + probe. responsive-pill-planning is queued after fixed-tile; no overlap with you.

## Rules
1. New worktree .claude/worktrees/gro-composition-clipping, branch worktree-gro-composition-clipping, from main (figma-to-bricks Step 2).
2. Save full corpus baseline (report, pastes, HTML) before first source change; before/after shots incl. GRO at 991/768/480/390/375/360/320.
3. Measure phone widths 375/360/320; other corpus files' inferred rows at 992–1439 must be measured (plan risk).
4. Stop at ready-for-review: committed; check, test:browser, corpus green vs baseline. No merge, push, BUILD bump, CLAUDE.md. Paste check: next free on main at merge (3aw, 3ax taken; fixed-tile holds provisional 3ay).
5. Close nothing in found-else yourself (finisher does after merge). Other bugs → found_else. Always pass workdir to terminal. Stagger Chrome with a running reviewer.
