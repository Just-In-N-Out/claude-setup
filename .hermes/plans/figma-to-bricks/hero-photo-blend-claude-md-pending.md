# hero-photo-blend — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release build: **2026-10-21.24** (`3f14a32`, pushed); paste check **3ax owed**.

**Apply after the older ones, in build order** (.13 … .23 pending files, last one `phone-recognition-guards-`).
**None of these edits landed, and none was attempted.** Older pending files are still unapplied (CLAUDE.md's build
line is behind main), so per the skill this finisher wrote this file instead of landing ahead of them, and used no
terminal/execute_code/main-chat route. Rename to `-applied.md` only after all three edits land.

## Edit 1 — "Start here", new bullet directly after the phone-recognition-guards (21.23) bullet

```
- **Picture shadows follow the picture (21.24, hero-photo-blend, ship option 2):** a picture (WordPress `img` or
  inlined background div) with exactly **one** outer, zero-spread Figma drop shadow now gets
  `filter: drop-shadow(x y blur/2 colour)` plus `will-change: filter` in its custom CSS instead of Bricks' box shadow,
  so a see-through cut-out no longer sits in a dark square (`style/picture-shadow.ts`, `style/paint.ts`). Two or more
  shadows, inner or spread shadows, a layer blur alone, videos and painted boxes keep their earlier box shadows
  (several alpha-following shadows deferred, HPB-R2). Accepted by Justin, not fixed: iOS 18.6 can intermittently lose
  the shadow outside the box; the shadow paints over a caption right below (filter = stacking context). Known
  trade-off: `will-change` gives each such picture its own compositor layer (Chrome DPR1: page-1 5→10 layers at 1440;
  40 cut-outs 14→94 at 390, +3.4–4.6 Mpx, ~9× at DPR3; WebKit memory not measured). No WebKit in CI (unit string test
  only). Installed Bricks 2.3.9 round trip not proved. check 1928 + 6 performance; browser 195/195; corpus only the 7
  single-shadow pictures change. HANDOFF "Picture shadows that follow the picture"; paste check **3ax** owed. Old pages
  keep the square until re-converted and re-pasted.
```

## Edit 2 — "Where things stand", pictures/style section: new rule line

```
- **Picture shadows (user, 2026-10-21, A1 B1 C1 + single-shadow release + ship option 2):** only a picture's single
  outer zero-spread shadow follows its pixels, as `filter: drop-shadow()` with **half** the Figma blur radius (filter
  takes Gaussian sigma) and `will-change: filter` (Safari/iOS clip a filter on an img/background box without it).
  Never chain several `drop-shadow()`s (later ones shadow earlier results: phantom silhouette); 2+ shadows keep box
  shadows and the conversion says following them is deferred. Spread/inner shadows keep the box shadow and warn.
  Videos and painted boxes keep Bricks' shadow setting.
```

## Edit 3 — "Start here" build line (send last)

Replace the current-build line (whatever older pending files set it to, e.g. `**Current build `2026-10-21.23`.**`) with

```
**Current build `2026-10-21.24`.**
```

and in the **Checks** bullet the counts become: `npm run check` 1928/1928 unit/rule plus 6/6 serial performance;
browser 195/195.
