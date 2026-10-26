# fixed-tile-shrink — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release build: **2026-10-21.25** (`5474523`, pushed); paste check **3ay owed**.

**Apply after the older ones, in build order** (.13 … .24 pending files, last one `hero-photo-blend-`).
**None of these edits landed, and none was attempted.** Older pending files are still unapplied (CLAUDE.md's build
line is behind main), so per the skill this finisher wrote this file instead of landing ahead of them, and used no
terminal/execute_code/main-chat route. Rename to `-applied.md` only after all three edits land.

## Edit 1 — "Start here", new bullet directly after the hero-photo-blend (21.24) bullet

```
- **Fixed tiles keep their size on tablets and phones (21.25, fixed-tile-shrink):** a small box (≤96px) drawn fixed
  both ways in a kept row (a 64×64 numbered tile) no longer shrinks to 59×63 at 990 / 52×63 at 768. `adapt/kinds.ts`
  `compactBox` → `compactTile` → `tileWidth` (the width desktop CSS already holds it at, within 1px of drawn; 0 when
  desktop holds it at its words); the plan reserves it from tablets down (`firmAt`, never `fluid`, never in a list's
  record/column-titles line), and size.unpin writes `min(<w>px, 100%)` at tablet_portrait so the drawn-height rule
  keeps its height. Only where the row is sized by its items (hugs, or fills up to a box that hugs) does it also write
  `_width:tablet_portrait` (Chrome ignores the floor's % there). A tile that is an icon row's words stays row.icons'.
  Grid cells, placed layers, native Buttons, empty shapes, fill/hug twins, >96px untouched. Rulings not yet confirmed:
  a word-held tile is never wider on tablets than desktop; a non-button tile beside a 210px paragraph + wide column
  goes two per row on tablets (F3). Known limits: laptops 992–1199 still share the tile (58.9×64 @992); in a hugging
  row a tile whose words render wider than its drawn size is fixed at drawn width (word spills ~4.5px, D1). Real files:
  only page-1/Services' 3 floors change, no geometry change at 21 widths. check 1961 + 6; browser 203/203; corpus
  otherwise byte-identical. HANDOFF "Fixed tiles that shrank on tablets"; paste check **3ay** owed.
```

## Edit 2 — "Where things stand", layout/rows section: new rule line

```
- **Fixed tiles (2026-10-21, fixed-tile-shrink):** on tablets/phones a compact tile drawn fixed both ways in a kept
  row is held at the width desktop holds it (`tileWidth`), plan and CSS from the same function; a tile's px `width`
  goes out only where the row is sized by its items (hugging row rule, see the capped-floor pitfall). Laptops are not
  covered (deferred). List record/column-title lines never hold a tile (list.ts lets their cells go).
```

## Edit 3 — "Start here" build line (send last)

Replace the current-build line (whatever older pending files set it to, e.g. `**Current build `2026-10-21.24`.**`) with

```
**Current build `2026-10-21.25`.**
```

and in the **Checks** bullet the counts become: `npm run check` 1961/1961 unit/rule plus 6/6 serial performance;
browser 203/203.
