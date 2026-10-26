# fixed-tile-shrink — fresh REVIEWER brief (2026-10-21 21:08 EDT)

Review only, Opus xhigh. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/fixed-tile-shrink, tip 667fef0, base main 5e32aec (.22). Review `git diff main...HEAD` against the approved plan ~/.hermes/plans/figma-to-bricks/fixed-tile-shrink.md and briefs/fixed-tile-shrink-builder.md.

## Built (builder's claims — verify)
64x64 fixed tile stays 64x64 at 1200/990/768/600/375/360/320 (was 59x62.6 @990, 51.9x62.6 @768). Files kinds/shapes/unpin/rows only: compactBox (96px limit moved from rows.ts, widens unchanged), compactTile, tileWidth (desktop CSS width when within 1px of drawn), firmAt reserves tileWidth in kept rows on tablet/phone only, size.unpin writes min(Wpx,100%) at tablet_portrait. Grid cells, placed layers, native Buttons, empty shapes, fill/hug, >96px untouched; grid/ALONE decisions unchanged.
Gates claimed: check 1855+6, browser 194/194, corpus pastes/HTML byte-identical except page-1 (+3 floors, no movement over 21 widths), 9 mutations caught.

## Builder rulings to judge (not yet confirmed)
1. Fixed tile shown at its words on desktop (floor >1px under drawn width) keeps today's tablet behaviour (GRO checklist marks; prevents 'SOCIAL ACCOUNTS' etc wrapping).
2. Small photo-painted boxes count as tiles (no fixture covers it — check).
3. Native Buttons / empty boxes are not tiles.

## Check
- Measure in Chrome at 375, 360, 320 plus corpus widths: no sideways scroll, no wrapping of neighbours, tiles never wider than parent.
- Element-by-element replay diff main vs branch for every corpus file + a scratch copy of the user's debug JSON (never edit the original); measure changed elements' rects, not just lint.
- Interaction with queued responsive-pill-planning and gro-composition-clipping (shared layout outputs) — note risks.
Pre-existing, not findings (already in found-else): empty fixed box plan under-count; Repairs breadcrumb 1px spill at 320; desktop circles/marks at words' width.

Change nothing: no commit, push or merge; restore anything you touch. Kill only orphan Chrome (parent PID 1). Other bugs → found_else.
