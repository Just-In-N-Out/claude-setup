# gro-composition-clipping — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release build: **2026-10-22.1** (`29325e4`, pushed); paste check **3az owed**.

**Apply after the older ones, in build order** (.13 … .25 pending files, last one `fixed-tile-shrink-`).
**None of these edits landed, and none was attempted.** CLAUDE.md's build line is still `2026-10-21.12` (behind main),
so per the skill this finisher wrote this file instead of landing ahead of the older ones, and used no
terminal/execute_code/main-chat route. Rename to `-applied.md` only after all three edits land.

## Edit 1 — "Start here", new bullet directly after the fixed-tile-shrink (21.25) bullet

```
- **GRO rows and the composed card stay inside their sections (22.1, gro-composition-clipping):** from tablets down an
  inferred row's positive sideways nudge is a share of the row's free space (its width less its flowing layers' drawn
  widths and gaps), `max(0px, calc((100% - <drawn>px) * <share>))`, plus a turned layer's own turn margin
  (`style/place.ts freeShare/freeNudge`, written at tablet_portrait by the new rule `row.nudge`,
  `adapt/rules/nudge.ts`; skipped where the row already stacks on tablets). Laptops and wider keep main's whole-width
  share exactly. A placed box `compose.stack` brings into the column lets go of its drawn height there and, joining
  across a section, takes `calc(100% - 2×gutter)` per tier (`adapt/rules/compose.ts`). Fixed on GRO: services index
  "04" (991–480), footer "Contact" (768), selected-work card in two clipped columns (390–320); G7 (16px sideways at 320)
  resolved too. Open, pre-existing (same as before): at 992–1200 the services index's 4th picture is cut at the
  section edge (a laptop fix needs the nudge to follow the tier's sliding gap; after responsive-pill); G1 card past the
  edge ≥992 (Figma's own crop), G4 992 paragraph, G6 turned hero locator 480/479. Rulings not yet confirmed: footer
  columns pack left on tablets; the "empty box joining" branch is unreachable. check 1972 + 6; browser 207/207;
  corpus: only GRO changes. HANDOFF "GRO composition clipping"; paste check **3az** owed.
```

## Edit 2 — "Where things stand", layout/rows section: new rule line

```
- **Row nudges from tablets down (2026-10-22, gro-composition-clipping):** an inferred row's positive sideways nudge
  is a share of its free space at tablet_portrait and below (`row.nudge`), never of its whole width, so a narrower row
  can't push its last layer past its edge; a turned layer keeps its turn margin beside it; placed layers and the row's
  padding don't count as room taken. Laptops keep the whole-width share (space.ramp slides wide gaps there; a laptop
  fix must follow the tier's gap, not the drawn one). A past-edge box composed into a section's column takes the
  column's width between the tier's gutters and lets go of its drawn height.
```

## Edit 3 — "Start here" build line (send last)

Replace the current-build line (whatever older pending files set it to, e.g. `**Current build `2026-10-21.25`.**`) with

```
**Current build `2026-10-22.1`.**
```

and in the **Checks** bullet the counts become: `npm run check` 1972/1972 unit/rule plus 6/6 serial performance;
browser 207/207.
