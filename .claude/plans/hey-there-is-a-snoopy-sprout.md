# Live map on the Contact page (wordless-maps)

## Context

Justin: "for the contact page please make it so that the map is embedded and the user can scroll on it." His Figma
"Contact Page Final" (1728 wide) has a Google map captured from a web page, running edge to edge under the hero. The
live Contact page (read 2026-10-23, saved 18:15 GMT, LiteSpeed bypassed) shows it as a flat picture. The section holds
no iframe and not one text layer.

Three general gaps, each confirmed against the code (and by the planning agent with fixtures):
1. **Not recognised** (`src/core/normalise/maps.ts:73`). A map needs one of Google's own words (SIGNS) or a maps link.
   This capture has neither: Google's place card came through empty, and the zoom/fullscreen/layer controls came
   through as pictures. So the map is skipped, and the panel gives no note.
2. **No address** (`maps.ts:115`). `nearestAddress` stops at the map's section. Justin's address is in the next section
   ("Contact Details"). This was a deferred item of 20.10.
3. **Not edge to edge.** `section.ts:127` keeps a map from being a wrapper or band, and `fullPart` (`:152`) needs a
   section drawn without auto layout. So a live map in an auto-layout section lands in the 1440 Container, with
   gutters. Today's picture also has gutters below the design width (`wide.ts` widens only from the design width up).

**Justin chose "Edge to edge"**: a live map drawn across its section's whole width touches both sides of the window on
every screen. This answers the open question "Should a full-width map leave the 1440 Container?"

**Scroll:** Google's keyless embed (`emit/maps.ts`) is unchanged. It drags, has + and −, pinches on phones, and zooms
with Ctrl/⌘ + wheel. Wheel zoom without Ctrl needs a Google Maps API key; I've told Justin.

## Approach

### A. A map recognised by its controls (`src/core/normalise/maps.ts` only; no new data)

A candidate frame (the climb is unchanged: the outermost frame of the tiles' box holding no designer words) is a map
when one of these holds:
- it has a sign word (as now);
- it has a maps link (as now);
- **new:** its own controls sit in **at least two different corners** of the tiles' box.

A control is a layer inside the map frame that meets all of these:
- not the tiles, and not a frame the climb passed through;
- not text;
- painted: an image or vector, or fills, a stroke or a shadow;
- bigger than a speck (more than 2px each way), at most `CARD_AREA` (40%) of the tiles' area, and inside the tiles' box
  (±`SAME_BOX`);
- in a corner: within `CORNER` = 32px of its nearer left/right side and of its nearer top/bottom side.

Helpers:
- `painted(k)`
- `cornerOf(r, tiles): string | null`
- `controlled(map, tiles, around: Set<SceneNode>): boolean`

The guard becomes `if (!linked && !texts(map).some(sign) && !controlled(map, tiles, around)) continue;`. Update the
header comment.

Two corners, not one, because B now looks across the page. One corner badge on a tiled wall must not become a Google map
of the footer's address. When the check fails, the map stays a picture, as today.

**No layer-name hint** (`gmnoprint`, `gm-style`, `leaflet-`). The structure catches the class. A name would be the only
signal in some files, which CLAUDE.md rules out.

The planning agent checked the two real captures (hydraulics, page-1): each has controls in three corners. Justin's
live CSS shows the place card at (8,8), top left, and the fullscreen control at the bottom right, so it qualifies.

### B. The address past the map's section (`nearestAddress`)

- Remove `if (top(a)) return null;` and the `top` parameter. The climb runs to the page root. At each level the nearest
  address (by height from the map's middle) wins, so a map whose section holds an address is unchanged.
- One Figma frame is one page, so a drawn phone design never takes the desktop's address.
- A footer's address is used only when nothing is nearer. Normalise must not read leave-out (stage order).
- The panel's `mapNote` already names the address used.
- With no address on the page, the warning still fires, reworded "beside it" → "on the page". Update the existing
  test's `startsWith`.

### C. Edge to edge (`src/core/understand/section.ts` only)

Add `const mapAcross = (k, f) => k.map !== null && !k.absolute && spansFrame(k, f);`.

- **C1, the map in the section.** `fullPart(k)` is also true when `mapAcross(k, n)`. The map goes through the existing
  "full-width part" branch (`:180-185`): straight in the section, `{ w: "fill", h: "fixed" }`. Words around it share a
  Container, as with bands. Also set `el.parentFlow = null` for maps there: a section's children stack in a column,
  and a row flow would give flex-grow with no width (`style/sizing.ts:214-217`), a 0px map.
- **C2, a map spanning a painted band.** In `bandContent`, a non-inferred band whose kid is `mapAcross` puts the map
  beside the band's Container (`h: "fixed"`, `parentFlow = null`). The band keeps its paint and the section's zero side
  padding.
- **C3, one unpainted wrapper with top and bottom padding only.** `wrapperOf` refuses a wrapper whose kids include a
  map spanning it. `fullPart` accepts a section-spanning frame holding one, so the band path builds it and C2 places
  the map.

Downstream needs no change:
- `adapt/map-box.ts` keeps the drawn height.
- `wide.ts`: a 100% flow layer in a section that spans the window is already wide.
- `payloadProblems`: only `_width`, `_heightMin`, `_position`, `_overflow`.
- `layout.ts` under-reports its width, but nothing reads it there; add a comment.

**Not changed:** a map that is itself a section, and a map in a link (it stays a picture, with its note).

## Tests first (each seen failing; generic fixtures, never Justin's names or address)

**Fixtures** (`test/fixtures/maps.ts`):
- `wordlessMap({ width = 1600, height = 420 })`:
  - `Map` (clips), holding:
    - `Map view` (#E5E3DF, clips), holding `tileGrid`, a `Layer switch` (white 64px box with a small image, bottom
      left) and a `Fullscreen` vector (40px, bottom right);
    - `Place box` (white 300×76, top left, holding only a pin vector).
- `tiledWall(w, h, extra[])`.
- `wideMapPage(part, { width, address, footer?, … })`: Hero (words), `Map section` (column, padding 0) holding the part,
  Details ("Address" plus an address), an optional Footer.

**`test/unit/normalise-maps.test.ts`**
- A wordless capture is a map by its controls in two corners; its query is the next section's address.
- These stay pictures (`[]`):
  - one corner badge;
  - controls in the middle (a play button, a logo);
  - empty unpainted frames in corners;
  - a 2px speck;
  - a tint over 40%;
  - a box past the edge;
  - a tiled hero whose logo and button sit outside the backdrop's frame (it also keeps its words).
- B: the next section's address beats the footer's; a nearer address above wins; the map's own section still wins over
  a nearer one in the next section.
- B: no address on the page gives `[]` and the reworded warning.
- All existing tests stay as they are.

**`test/unit/convert-maps.test.ts`**
- C1: the code element's parent is the `section`. It has `_width: "100%"`, height 420, and no `_margin`, `_widthMax`,
  `_left` or `_right` at any breakpoint. The section's side padding is 0, `payloadProblems` is `[]`, and the note names
  the address.
- C2: the parent is the painted band, which keeps `_background`. C3: the parent is the wrapper, directly in the
  section.
- A one-row section holding only the map gives `_width: "100%"`, with no `_flexGrow` or `_flexBasis`.
- Narrower maps stay in the Container: the card map, and a 1472px map inside 64px padding.
- In a drawn phone pair, both maps sit in their sections.
- A wordless map in a linked card stays a picture, with the link note.
- Strengthen the existing `:47` test: the parent is the section.

**Browser** (new `test/browser/maps.test.ts`, modelled on `wide.test.ts`):
- At 390, 768, 1024, 1440, 1600 and 2560, the map's left is 0, its width is `clientWidth`, its height is 420, and the
  page has no sideways scroll.
- At 1440, a card map's left is at least 64.

**Mutations to kill:**
- `>= 2` changed to `>= 1`;
- the corner check, the area cap or the speck check removed;
- the `top(a)` stop put back;
- `parentFlow = null` removed.

## Process (main folder, committed straight to `main`, as site-ticks was)

1. Load the skills `engineering-best-practices`, then `test-driven-development`.
2. Plan doc `docs/plans/2026-10-23-wordless-maps.md` and a ledger.
3. Run `npm run corpus` before Task 1, and copy `corpus/paste/*/bricks.json` and its HTML to the scratchpad.
4. Work in TDD vertical slices (A, then B, then C1, C2/C3, then the browser test). Commit each passing slice by file,
   never `CLAUDE.md` or the modified debug file.
5. Run the gates:
   - `npm run check`, including `sandbox-convert` (the new code uses only `Set`/`Math`);
   - `npm run test:browser`;
   - `npm run corpus`: every corpus paste must be byte-identical (its three maps have words, an in-section address and
     are 746 wide), and lint and the 17 known items unchanged.
6. Get a fresh opus review (`requesting-code-review` + `code-review-practice`), then fix test-first
   (`receiving-code-review`).
7. Finish:
   - add the HANDOFF section "A captured map with no words, and a map edge to edge" with paste check **3bk**;
   - move the ledger to `docs/plans/`;
   - read `BUILD`, bump it (to `2026-10-23.3` unless it moved) and run `npm run build`;
   - commit "Build …: wordless-maps", plain `git commit -m`, and `git push` `main` only;
   - update `CLAUDE.md` locally (not committed): "Start here", the answered open question, and a line under "On
     screens wider than the design".

## Verification, end to end

**On my side:** the fixtures and the browser test above, and the corpus byte-identical.

**Justin's steps, one at a time, after the build:**
1. Reopen the plugin and check the build number.
2. Keep "My site already has its header" ticked: Contact lost its spacer.
3. In Bricks, empty the Contact page.
4. Convert "Contact Page Final" and paste, then Cmd+S. The panel should list "…: a live Google map".
5. Run Bricks → Settings → Custom code → Regenerate code signatures.
6. Run LiteSpeed → Purge All.

**Then I check the live page** (cache-busted) at 390/768/1440/1728:
- an `<iframe>` of Google's map for "12836 Hwy 57, Evansville, IN 47725" sits under the hero;
- it touches both sides of the window and drags;
- the page starts with `site-header-room`.

If the map is still a picture, its corners didn't qualify. Then ask for a "Save debug file" of Contact Page Final.

**Still owed alongside:** Home's Layers screenshot (a Services page inside "Home Page Final"), and the 3bj re-pastes.

**Estimate:** about 2–3 hours including the review (medium confidence), then Justin's paste and my live check.
