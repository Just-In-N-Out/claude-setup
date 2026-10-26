# GRO phones: free-floating designs on tablets and phones — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans. The user chose native execution with no
> stop between plan and run. Steps use checkbox (`- [ ]`) syntax. First action of the run: copy this file to
> `docs/plans/2026-10-07-gro-phones.md`.

**Goal:** a design drawn without auto layout reads well on tablets and phones, while the design width stays exact.

## Context

GRO desktop made designs drawn **without auto layout** exact at the design width. That's rounds 1 and 2, now build
`2026-10-07.17`, done by another session that has finished. Below 992 the user's GRO homepage
(`corpus/files/gro-home.json`, 1440 wide) still breaks.

`npm run snap -- corpus/files/gro-home.json <out> 390,768 --detail` on build .17 gives:
- **390:** 7 errors, 9 warnings;
- **768:** 18 errors, 14 warnings.

Seen in the 390 shots:
- **Picture headings cut off** (outlined fonts): "BLENDING IN", "BOUTIQUE-AGENCY ATTENTION", "EXPERIENCED ENOUGH",
  "TOMORROW".
- **The hero:** the sideways locator runs through its heading, and the buttons are squeezed into a thin right
  column.
- **Section 02:** the cactus and the mountains blown up over the text.
- **Section 04:** BUILD/GROW/CREATE sit on the photos.
- **Section 05:** "ALREADY" is drawn over "The website" and "exists.".
- **Section 06:** the outline "02" and the second work card pile over the first card.
- **Section 07:** "06 — ADVERTISING & PERFORMANCE" is squeezed beside its aside, and the bottom mountains lie over
  "TRADITIONAL ADVERTISING".
- **Section 08:** the steps mix pieces of different steps (04, 03, 02…).
- **Section 09:** the testimonial quote is cut off.
- **Section 10:** the team photo is a 390×864 sliver.
- **Section 11:** the four cards read band by band (01 02 03 04, then the titles, then the texts).

Already fixed by the other session (don't redo):
- "Strategy" and "1.1"–"4.4" now sit on their rows (`normalise/ink.ts` measures a one-line text by its words);
- section 11 is a normal layout (`infer.ts` `backdropArt`);
- the footer's all-picture row.

Out of scope:
- the phone menu (waits for the Nav sample);
- the ~1024px items (the other session's, all done).

**Causes** (checked on build .17 with scratch scripts and a read-only review agent):
1. **Slight tilts count as sideways.** `adapt/layout.ts:62` `sideways` is any rotation not a multiple of 180°. A
   5°-tilted aside therefore counts as a side label, and its row never stacks.
2. **Column offsets are never undone.** A positive cross nudge in a column (`style/place.ts` `nudgeStyle`,
   `style/sizing.ts` `cap()`) stays below desktop: the hero buttons keep 71% and 28.9%.
3. **Inline picture floors.** An inline picture in a mixed row keeps `widthMin: min(Wpx, 100%)` (`style/style.ts`
   `emptyBox`). In a row, 100% is the whole row, so a picture heading squeezes the paragraph beside it.
4. **Bands before columns.** `normalise/infer.ts` `cut()` always cuts bands first, so cards drawn in aligned columns
   (section 11) or staggered steps (section 08) come out band by band.
5. **Content lifted out of the flow.** `lift()` floats the layer painted over the most others, even when it is
   content. The testimonial quote (text over a quote-mark drawing) is placed in px.
6. **Heading pieces.** A CUT column of two overlapping heading pieces gets one flowing and one lifted (px), so the
   second never shrinks.
7. **Layers past the section's edge.** The second work card (photo, caption drawing, two texts, link), placed past
   section 06's right edge, is five loose placed layers.
8. **Big drawings on a photo.** BUILD/GROW/CREATE and the outline "01" stay placed in px against the row; they aren't
   tied to their photo.
9. **"ALREADY".** It is a `cover` drawing in its CUT column, between two texts it doesn't touch (by ink).
10. **Backdrop vectors.** Those spanning a section are cover-fitted to the tall phone section, or pinned in px from
    its top. Only their box is known; the snapshot's `absoluteRenderBounds` (or their children) give where the ink
    is: the hero's mountains are y 728–960 of 960. Contour lines (~70% of the section's area) aren't `cover` at all,
    so they stay 1440px wide on phones.
11. **The team photo band.** Its free box keeps `heightMin` 864 on phones.

## The user's decisions (2026-10-07; all four answered)

- **Big outline words layered over other things** ("ALREADY" between "The website" and "exists.", BUILD/GROW/CREATE
  across the photos): on phones each goes on **its own line where it reads, shrunk to fit**. A word drawn across a
  photo goes just above that photo.
- **Heading pieces drawn as pictures** that overlap or stagger **shrink together as one picture**, keeping the stagger.
- **Landscape drawings** (mountains along a section's bottom, ridges, the cactus and sun): **shrink to the phone's
  width at their edge**, keeping their shape. **All-over patterns** (stars, contour lines, rain) **keep covering**.
- **Big decorative numbers** (the outline "01"/"02" by the work cards, the ridge's step numbers): **go right above the
  item they label**.
- **The sideways locator beside the hero heading:** on phones it **turns upright**, a small line above the heading.

**Rulings made here (report them to the user):**
- **Tablets too.** Tablets (≤991) get the same treatment wherever a desktop composition no longer fits.
- **Offsets slide.** A column offset slides from the design width down (`max(0px, min(S%, 100% − Wpx))`) where it
  fits at desktop, and is 0 on phones.
- **Repeated cards read by column.** Cards drawn in pieces read column by column at every width. That changes the
  desktop structure, not the look.
- **Content stays in the flow.** When content lies over a drawing, the drawing leaves the flow, not the content.
- **The team photo band** keeps its photo's shape on phones (not a tall crop).
- **No general restack of free frames.** The review found it would wreck marquee strips, a table scroller and a
  watermark in the other corpus files. Free frames keep today's behaviour; only the cases above are handled.

**Deferred minors (report them):**
- "Index 02" is a flowing item beside card 1's photo, so on phones it lands after card 1's photo, not above card 2.
- In Services "Grow", "Campaigns 3.5", its rule and "Explore Grow" are cut into the "Fig. 03" caption's band, so on
  phones they follow the caption.

## Architecture

- **normalise** records what only it knows:
  - where a vector's ink is (`SceneNode.ink`);
  - repeated cards cut into columns;
  - drawings lifted before content;
  - overlapping drawing-only CUT groups as art groups (`SceneNode.art`);
  - layers past a section's side edge as one group;
  - a big drawing lying on one picture moved into a CUT pair with it.

  Desktop renders identically: every new box sits exactly where Figma draws its layers.
- **understand** gives each affected layer a narrow-screen plan (`IRNode.compose`, in `understand/compose.ts`): `join`,
  `before`, `edge`, `cover` or `shape`.
- **style:**
  - an art group's pieces go in shares of it (`style/art.ts`);
  - a fitting positive column offset slides.
- **adapt** writes the tiers. New rules:
  - `compose.stack`;
  - `art.edge`;
  - `picture.band`;
  - `turn.upright`.

  It also extends two existing rules:
  - `space.ramp`: the offset's phone reset;
  - `size.unpin`: the picture floor's release.

**Tech Stack:** TypeScript (erasable only), Node 22 `node --test`, Chrome over CDP for snap and corpus.

**Spec:** `docs/specs/2026-10-06-v2-design.md`:
- "Absolute layers exist only inside a composition node, and every composition has a phone plan";
- "Absolute groups stack or scale".

Also binding: CLAUDE.md's phone, stacking and website rules.

## Global Constraints

- **Desktop must not change.** GRO at 1440 and 1920 keeps every section's height and lint exactly as build .17 has
  them. Check with `--sides` at 1440 against `$SP/sides-before`.
- **No other corpus file may get worse at any width.** Compare `npm run corpus` with the build-.17 v2 report.
- **Generic fixtures only** (`test/fixtures/builders.ts`). No layer names, texts, colours or positions from GRO in code.
- **Rules:**
  - only `src/core/adapt/rules/` writes breakpoint styles;
  - each new rule is one file with a `decision` line;
  - in `RULES`, a rule comes after the rules it overrides;
  - `corpus-convert.test.ts` stays collision-free.
- **No stage edits an earlier stage's output.** Scene fields are set in normalise, plans in understand.
- **CSS stays typed.** `order`, `aspect-ratio`, `transform` and `white-space` go in `css` at a tier (no Bricks
  setting). `Style.position` has no `static`, so use `"relative"` with `"auto"` offsets. Breakpoints come only from
  `src/shared/breakpoints.ts`, and spacing from `PageFacts`.
- **Files stay ≤ ~300 lines.** New normalise logic goes in new files: `columns.ts`, `past-edge.ts`, `pairs.ts`. New
  style logic goes in `style/art.ts`. `style.ts` and `infer.ts` only call them.
- **Housekeeping:** erasable TypeScript only, no git, deterministic ids, `npm run check` green after every task. Golden
  or byte-identical files change only after their diff is reviewed.

## Review Focus

1. **Columns that don't repeat** (a heading and button on the left, a paragraph and photo on the right) and the
   footer. Expected: they stay bands. Scratch simulation: the repeat test fires only on GRO's sections 08 and 11 in
   all five corpus files. Task 5.
2. **A row of small icons drawn without auto layout.** Expected: still an inferred row, not an art group (art groups
   form only for GRO's four heading pairs across the corpus). Task 7.
3. **A small number or badge on a photo card** (hydraulics' 22 "01–05" numbers over card photos) and **map
   internals**. Expected: no pair, no join; they stay as today. Tasks 9–11.
4. **Marquee strips, a table scroller and a watermark** (design "Black banner 1", hydraulics "Marquee", page-1
   "div.tbl-scroll", final-design "TriState"). Expected: unchanged. There is no free-frame restack, and the past-edge
   group takes only a section's own placed layers. Tasks 8 and 11.
5. **A 1728-wide page and auto-layout frames.** Expected: no columns-first, no pairs, no offset change. Those act on
   inferred flows only, and the offset only where it fits at desktop. Tasks 2, 5 and 9.

---

### Task 0: Start (the other session is done: build .17)

- [ ] Copy this plan to `docs/plans/2026-10-07-gro-phones.md`. Start the ledger at
  `.superpowers/sdd/2026-10-07-gro-phones/progress.md`.
- [ ] Memory: update `gro-phone-pass.md` with the user's four decoration choices (dated 2026-10-07).
- [ ] Back up: `rsync -a --exclude node_modules --exclude corpus/out ./ $SP/backup-pre-gro-phones/` ($SP is the
  session scratchpad).
- [ ] Baseline:
  - `npm run check` (expect 542);
  - `npm run corpus > $SP/corpus-before.txt`, then `cp corpus/report-v2.json $SP/report-v2-before.json`;
  - `npm run snap -- corpus/files/gro-home.json $SP/snap-before 390,768,1024,1440,1920 --detail > $SP/snap-before.txt`;
  - the same command with `--sides` at 1440 into `$SP/sides-before`.
- [ ] Keep the scratch diagnosis scripts (`$SP/why.ts`, `rows.ts`, `anchors.ts`, `cols2.ts`, `art.ts`,
  `backdrop.ts`). Re-run them after Tasks 5, 7, 8 and 9.

### Task 1: Only a quarter turn is sideways (cause 1)

**Files:** Modify `src/core/style/turn.ts` (new export `quarterTurned`; `sideways` itself unchanged, since desktop
sizing uses it) and `src/core/adapt/layout.ts:62` (`sideways` uses `quarterTurned`). Test
`test/unit/adapt-rows.test.ts`.

**Rule:** a text turned within 45° of a quarter turn runs along its neighbour. A slight tilt is an ordinary item of its
row.

**Produces:** `quarterTurned(n: SceneNode): boolean`, true when
`turned(n) && Math.abs((((n.rotation % 180) + 180) % 180) - 90) <= 45`.

- [ ] Test: a 1440 page with a free section holding a 302×17 label above an 846×246 vector, side by side with
  `turn(text("(aside)", {fontSize: 55, width: 407, autoResize: "HEIGHT"}), 355)`.
  - Expect the row's `_direction:mobile_portrait` = `"column"`.
  - The aside's one-line `nowrap` is only in its `@media (min-width: 1440px)` block.

  Watch it fail.
- [ ] Guard: `adapt-rows.test.ts:72` (a 270° label keeps its row) still passes.
- [ ] Implement. `npm run check`.

### Task 2: An offset across a column slides (cause 2)

**Files:** Modify `src/core/style/place.ts` (`nudgeStyle`), `src/core/style/sizing.ts` (`cap`) and
`src/core/adapt/rules/space.ts` (next to the negative-cross reset at ~108). Test `test/unit/content-box.test.ts:106`
(update it) and `adapt-space.test.ts`.

**Rule:**
- An item pushed across an inferred column by S% whose drawn width W fits after the offset at desktop
  (cross + W ≤ inner) gets `margin-left: max(0px, min(S%, calc(100% - Wpx)))` and `cap()` = `"100%"`.
- An item reaching past the column's edge keeps today's S% and `cap()` share.
- On phones, `space.ramp` writes `margin.left: 0` at `mobile_landscape`. Turned layers are skipped, as `space.ramp`
  does.

- [ ] Update `content-box.test.ts:106`:
  - `_margin.left` = `"max(0px, min(71.08%, calc(100% - 332px)))"`;
  - `_widthMax` = `"100%"`;
  - `_margin:mobile_landscape.left` = `"0"`.

  Watch it fail.
- [ ] Test: a box 1000 wide offset 400 in a 1312 column keeps `"30.49%"` and its `cap()` share (reaches past).
- [ ] Guard: the hang (negative offset) tests pass untouched.
- [ ] Implement. `npm run check`. Review the golden diff (`convert-sample.json`) before regenerating it.

### Task 3: A picture's floor lets go where its row gives it less (cause 3)

**Files:** Modify `src/core/adapt/rules/unpin.ts`. Test `test/unit/adapt-unpin.test.ts`.

**Rule:**
- A flowing non-icon picture whose parent is neither placed nor free gets `widthMin: 0` at the first tier where
  `ctx.layout.width(n, tier) < W − 1`.
- This covers both an inline Div (`min(Wpx, 100%)`) and an Image with a px width. It then shrinks with its row, as the
  layout plan has it.
- Icons are excluded (`row.icons` relies on them keeping their size).

- [ ] Test: a 1440 page with an inferred row of a 638×104 vector-only frame and a 422-wide paragraph, converted with
  `{inlinePictures: true}`. The picture gets `_widthMin:tablet_portrait` = `"0"`. Watch it fail.
- [ ] Guards:
  - a 200px picture gets no tier key;
  - a 40px icon gets none;
  - a picture inside a free frame gets none.
- [ ] Implement. `npm run check`.

### Task 4: Where a vector's ink is (cause 10)

**Files:** Modify `src/core/normalise/scene.ts` (`SceneNode.ink: Rect`), `src/core/normalise/normalise.ts` (`build`)
and every SceneNode literal the typecheck lists (`infer.ts` `group()`, …). Test `test/unit/normalise.test.ts`.

**Rule:**
- A vector's ink is its snapshot `absoluteRenderBounds` (page coordinates, as `boxOf` measures).
- Without it (v1 files), a vector-only container's ink is the union of its shown children's ink, clipped to its box
  when it clips content.
- Any other layer's ink is its box. A CUT group's ink is the union of its members'.

**Produces:** `SceneNode.ink: Rect`.

- [ ] Test: a clipping `frame("Hills", 1440×900)` of vectors at y 700 (1440×200), y 760 (1440×300, past the bottom) and
  y 820, with no render bounds, has ink `{x: 0, y: 700, width: 1440, height: 200}`. The same frame with
  `absoluteRenderBounds` set uses those. A plain vector's ink is its box. Watch it fail.
- [ ] Implement. `npm run check`.

### Task 5: Repeated cards are read column by column (cause 4)

**Files:** Create `src/core/normalise/columns.ts`. Modify `src/core/normalise/infer.ts` (`cut()` uses it on the y
axis). Test `test/unit/infer.test.ts`.

**Rule:**
- In `cut()`, take the y-sweep's bands. A run of ≥ 2 consecutive bands becomes one part when all of these hold:
  - its layers split in x (`sweep(…, "x")`) into ≥ 2 columns;
  - every column repeats the same pattern: ≥ 2 layers, the same kinds (`SceneNode.kind`) in the same top-to-bottom
    order;
  - the narrowest gap between columns is wider than the widest gap between those bands.
- A drawing or shape (no text, no picture) spanning ≥ 90% of the run's width (a rule across the cards) doesn't split
  it. It stays a member of the run's group, where `lift()` places it.
- The part becomes a CUT group of column CUT groups, one per x-part. `inferLayout` lays it out as a row of columns.
- Runs are taken greedily from the top, longest first.
- A layer spanning the frame edge to edge (`spansFrame`) ends a run and never joins one. A full-width part stays a band
  or full-width element in `understand/section.ts` (`fullPart`, `bandContent`). Layers already left out by
  `backdropArt` (section 08's ridge) aren't items here.
- Desktop is exact by construction. The scratch simulation fires only on GRO's 08 steps and 11 cards across the
  corpus; a looser test also merged the footer and 08's heading.

**Produces:** `byColumns(bands: SceneNode[][]): Array<{ columns: SceneNode[][]; spanning: SceneNode[] }>`.

- [ ] Test: a free 1440 section with a band of four 11px dots on a 1313×1 rule, then three bands of four aligned
  columns:
  - y 0: texts "01".."04" at x 63 / 398 / 732 / 1066;
  - y 27: 120×39 vectors;
  - y 73: 265-wide paragraphs.

  Expect one row of four CUT columns, each [dot, number, vector, paragraph], with the rule placed. Watch it fail.
- [ ] Test: four steps rising to the right (each a column of a 14px dot, a 60×93 vector, a title, a paragraph and a
  label; each step 108px higher than the one before) give a row of four columns, left to right.
- [ ] Guards:
  - a heading band spanning the section above two columns stays a band;
  - a full-width vector between two runs of cards stays a full-width part (`section.ts` `fullPart`);
  - columns with different patterns stay bands;
  - a two-band layout whose band gap is wider than its column gap stays bands;
  - existing `infer.test.ts` cases pass.
- [ ] Implement. `npm run check`. Re-run `$SP/cols2.ts`, and GRO 1440 `--sides`: 08 and 11 unchanged.

### Task 6: A drawing leaves the flow before content does (cause 5)

**Files:** Modify `src/core/normalise/infer.ts` (`lift()`) and `src/core/normalise/paint-order.ts` (`finish` puts a
lifted layer under or over by paint order). Test `test/unit/infer.test.ts`.

**Rule:**
- When the layer `lift()` would take out is content (`content()` from paint-order.ts) and it overlaps drawings painted
  under it, `lift()` takes out the drawing it overlaps most instead.
- A lifted layer goes under the flow when every flowing layer it overlaps is above it, as other left-out layers do.
  That keeps Figma's paint order.

- [ ] Test: a free frame holding a 187×65 quote-mark vector, an 876×120 text painted over it, and a 200px caption text
  below. Expect the text flowing and the mark placed, `below`. Watch it fail.
- [ ] Guard: "lifted picture on top" in `infer.test.ts` still passes (a photo over panels).
- [ ] Implement. `npm run check`; GRO 1440 `--sides`: section 09 unchanged.

### Task 7: Overlapping heading pieces shrink as one picture (cause 6)

**Files:**
- Create `src/core/style/art.ts` (`artBox`, `artPiece`; the share math shared with `coverStyle`'s bleeding branch).
- Modify:
  - `src/core/normalise/infer.ts` (`group()`);
  - `src/core/normalise/scene.ts` (`SceneNode.art: boolean`) and every SceneNode literal;
  - `src/core/understand/node.ts` (an art group's pieces are `absolute`, never `cover`);
  - `src/core/style/style.ts` (`box()` and `placement()` call `art.ts`);
  - `src/core/style/sizing.ts` (no `heightMin` for an art group).
- Test `test/unit/infer.test.ts` and `test/unit/style.test.ts`.

**Rule:**
- A CUT group whose ≥ 2 members are all drawings (vector or shape; no text, no picture), connected by overlaps, is an
  art group. `group()` skips `inferLayout`: `flow.mode` stays `"none"` and `art` is true.
- Style for the group: `width: Wpx`, `widthMax "100%"`, no height or `heightMin`, `css: aspect-ratio: W / H`
  (2 decimals).
- Style for each piece: `position absolute`, with `left`/`top`/`width`/`height` in % of the group (2 decimals).
- That is exact at the design size. Across the corpus it forms only for GRO's four heading pairs.
- The group keeps its members' place in Figma's paint order (its z is its first member's). `paint-order.ts` still
  treats it as a drawing it may sink, as it did the pieces. GRO 02/12's waves stay behind the text: check them in
  `--sides`.

**Produces:** `SceneNode.art`; `artBox(n: SceneNode): Style`; `artPiece(n: SceneNode, group: Rect): Style`.

- [ ] Test (infer): a free 1440 section with a text at 63, `vector A (52,169 744×312)`, `vector B (52,459 533×167)` and
  a text at 997. The CUT group of A and B has `flow.mode "none"`, `art true`, and both pieces are absolute. Watch it
  fail.
- [ ] Guard: three 24×24 vectors 40px apart stay an inferred row.
- [ ] Test (style):
  - B gets `top "63.46%"`, `left "0%"`, `width "71.64%"`, `height "36.54%"`;
  - the group gets `_width "744"`, `_widthMax "100%"`, aspect-ratio `744 / 457`, and no `_height` or `_heightMin`.
- [ ] Implement. `npm run check`; GRO 1440 `--sides`: 01, 08, 10 and 11 unchanged.

### Task 8: Layers past a section's side edge are one group (cause 7)

**Files:** Create `src/core/normalise/past-edge.ts`. Modify `src/core/normalise/infer.ts` (`inferLayouts` calls it for
page sections after `rebaseSections`). Test: new `test/unit/past-edge.test.ts`.

**Rule:**
- In a page section (a frame `rebaseSections` treats as one), the placed layers that reach past its left or right
  edge, and that aren't backdrop art (spanning ≥ 90% of its width), form one group when there are ≥ 2 of them and one
  holds content.
- The group is made with `infer.ts` `group()` (exported), so it is laid out like any CUT group, placed where its
  layers are.
- Layers inside a child frame (a marquee strip) are never taken.

- [ ] Test: a 1440×900 free section with a title text, an inferred row of a photo and text, and placed past the right
  edge: `image(1302,196 346×378)`, a 217×65 vector, two texts and a link frame. Expect one placed CUT group holding
  the five, laid out as a column. Watch it fail.
- [ ] Guard: a free strip frame of logos wider than its section (a marquee) is unchanged.
- [ ] Implement. `npm run check`; GRO 1440 `--sides`: section 06 unchanged.

### Task 9: A big drawing lying on a picture travels with it (cause 8)

**Files:** Create `src/core/normalise/pairs.ts`. Modify `src/core/normalise/infer.ts` (`inferLayouts`, page only, after
Task 8). Test: new `test/unit/pairs.test.ts`.

**Rule** (frames whose flow `inferred` is true):

The overlay P is a placed non-icon vector, not backdrop art, not enclosing what it overlaps.

Its anchor:
- Descending from P's frame through flowing frames, it is the one picture leaf (an image, or a frame painted with a
  photo) that ≥ 25% of P's ink overlaps.
- At each level P's ink overlaps exactly one flowing layer, and P is no taller than its anchor.
- P may hang out of its frame.

The pair is a CUT frame (`figmaType "CUT"`, id `<anchor id>~pair`) in the anchor's slot:
- same box, nudge and sizing as the anchor, except height `"hug"`;
- flow `column`, gap 0, padding 0, `inferred: true`;
- the anchor flows inside it (nudge null);
- P is placed inside it (absolute, over the anchor) and removed from its frame.

P's page box is unchanged, so desktop is unchanged.

Scratch check: GRO's four BUILD/GROW/CREATE/STRATEGY words pair with their photos, and "Index 01" with the work
photo. There are 0 pairs in the other corpus files.

- [ ] Test: a 1440 page with a free section holding an inferred row of `image("Photo", 63,100 645×828)` and a column at
  840, with `vector("Word", 431,143 600×242)` placed in the row. Expect the photo's parent to be a pair holding
  [Photo, Word]. Watch it fail.
- [ ] Tests (guards):
  - a 40×40 icon on the photo isn't paired;
  - a vector whose ink overlaps the photo by 10% isn't;
  - one overlapping the photo and the column isn't;
  - a swoosh vector enclosing a heading isn't;
  - an auto-layout row's absolute vector isn't.
- [ ] Test: converted at 1440, "Word" has `top 43`, `right -323` against the pair (Figma's spot).
- [ ] Implement. `npm run check`; GRO 1440 `--sides`: 04 and 06 unchanged.

### Task 10: Narrow-screen plans (understand)

**Files:**
- Create `src/core/understand/compose.ts`.
- Modify:
  - `src/core/understand/ir.ts` (`IRNode.compose`);
  - `src/core/understand/node.ts` (`make` sets `compose: null`);
  - `src/core/understand/understand.ts` (`planCompose(page)` after `planPhones`).
- Test: new `test/unit/understand-compose.test.ts`.

**Produces:**
```ts
// ir.ts
export type Compose =
  | { how: "join"; order: number; gap: number } // a placed layer taking its place in its column's order once it no longer fits
  | { how: "before" }                           // a pair's drawing: its own line just before its picture
  | { how: "edge"; edge: "top" | "bottom" }     // landscape art: scaled to the width at that edge
  | { how: "cover" }                            // all-over art: covers its parent at every tier
  | { how: "shape" };                           // a free box around a cover picture: keeps the picture's shape
// IRNode.compose: Compose | null
```

**Rules:**
- **Backdrop art** is a placed non-icon vector spanning ≥ 90% of its section's width. Vectors only: a plain rectangle
  is a colour panel and keeps today's placement.
  - It is `cover` when its ink leaves less than a third of its parent's height empty both above and below.
  - Otherwise it is `edge`, at the edge nearer its ink.
  - A placed vector painted under the flow whose ink overlaps backdrop art's ink (a sun, a cactus) is `edge`, at its
    nearer edge.
  - Scratch check on GRO: stars, rain and contour lines → `cover`; every mountain layer, the ridge and 07's divider →
    `edge bottom`; the team photo's ridge → `edge top`; the sun and both cacti → `edge bottom`.
- **Pair drawing** (Task 9): `before`.
- **Between drawing:** a placed non-icon vector in a column flow (not backdrop art, not a pair's) whose ink overlaps none
  of the column's flowing layers. It is `join`, ordered by its top among them; every flowing sibling gets an order
  too.
- **Past-edge group** (Task 8): `join`, after the flow.
- **Gap:** the design's space above the layer, after the one before it, when ≥ 0; otherwise 16.
- **Picture band:** a free box (`flow.mode "none"`) holding a `cover` picture, whose other layers are all placed and
  not content wider than half the box, is `shape`.

- [ ] Tests (generic fixtures):
  - a CUT column of two texts and an 876×409 vector-only frame whose ink lies between them gives the vector `join`
    order 1, between the texts;
  - a bleeding 1498×960 vector frame with ink in its bottom quarter is `edge bottom`;
  - a 1440×900 frame of 100 scattered small vectors is `cover`;
  - a sun under the flow, overlapped by the mountains' ink, is `edge bottom`;
  - a plain 1440×1100 rectangle panel gets no plan;
  - Task 9's pair drawing is `before`;
  - Task 8's group is `join` after the flow;
  - a free 1440×864 box of a cover photo, a tint and a caption is `shape`;
  - hydraulics-like numbers (a 30px text over a card photo) get no plan.
- [ ] Implement. `npm run check` (no output changes yet).

### Task 11: Rule `compose.stack`

**Files:** Create `src/core/adapt/rules/compose.ts`. Modify `src/core/adapt/rules/index.ts` (after `space.ramp`,
`size.unpin` and `media.shape`). Test: new `test/unit/adapt-compose.test.ts`.

**Rule** (`decision`: "Big words and numbers go on their own line where they read, above what they label; placed
layers take their place in reading order where they no longer fit (user, 2026-10-07)"):

The tier at which it applies:
- **`join`:** the first tier where the layer's offset from the edge it is placed by, plus its width, exceeds
  `ctx.layout.width(parent, tier)`.
- **`before`:** the first tier where the drawing's reach from its picture's left exceeds `ctx.layout.width(pair,
  tier)`.

What it writes there:
- **`join` layer:**
  - `position "relative"`, `top`/`right`/`bottom`/`left` `"auto"`;
  - `zIndex` unchanged;
  - `margin.top` = `atTier(facts.space(gap, "gap"), tier)`;
  - `css: ["order: N"]`;
  - every flowing sibling gets `css: ["order: n"]` (custom CSS never collides);
  - a drawing or group: `width` its drawn px, `widthMax "100%"`, `height "auto"`, aspect-ratio;
  - a frame: `width "auto"`.
- **`before`:** as `join`, with `css: ["order: -1"]` and `margin.bottom` = `atTier(facts.space(16, "gap"), tier)`.
- The same values go on every narrower tier, so nothing in between reverts.

`overrides: ["size.unpin", "media.shape", "space.ramp"]`.

- [ ] Test: Task 10's text–vector–text column at `tablet_portrait`:
  - the vector gets `_position "relative"`, `_top "auto"`, `order: 2`, `_widthMax "100%"` and aspect-ratio;
  - the texts get `order: 1` and `order: 3`.

  Watch it fail.
- [ ] Test: Task 9's pair: "Word" at `tablet_portrait` gets `_position "relative"` and `order: -1`.
- [ ] Test: Task 8's group goes static after the flow at `tablet_portrait`.
- [ ] Test: a 30px number on a card photo in a three-column grid gets no tier key.
- [ ] Test: the engine reports no collisions.
- [ ] Implement. `npm run check`.

### Task 12: Rule `art.edge`

**Files:** Create `src/core/adapt/rules/art.ts`. Modify `rules/index.ts`. Test: new `test/unit/adapt-art.test.ts`.

**Rule** (`decision`: "Landscape drawings shrink to the phone's width at their edge; all-over patterns keep covering
(user, 2026-10-07)"):

From `tablet_portrait` down:
- **`edge` layer:**
  - `left` and `width` as shares of its parent's width (`coverStyle`'s share math);
  - `height "auto"` and its own aspect-ratio;
  - at its edge, `bottom: 0` (or `top: 0`) with `margin: {bottom: share}`. CSS margin % follows the parent's width,
    so the bleed scales;
  - the other vertical side `"auto"`.
- **`cover` layer** that isn't already a cover placement: `left`/`top`/`width`/`height` as shares of its parent (it
  covers the taller box, cropped by its `cover` fit).

`overrides: ["size.unpin"]`.

- [ ] Test: a 1440×900 free section with a bleeding mountains frame (−29,0 1498×960, children from y 728), a sun
  (590,270 490×490) under the flow, a stars frame (scattered small vectors) and a 1440×700 contour frame at y 200
  (strokes spread over it). At `tablet_portrait`:
  - the mountains get `_left "-2.01%"`, `_width "104.03%"`, `_top "auto"`, `_bottom "0"`, `_margin.bottom "-4.17%"`
    and aspect-ratio `1498 / 960`;
  - the sun gets `_left "40.97%"`, `_width "34.03%"`, bottom-anchored;
  - the contour gets `_top "22.22%"`, `_height "77.78%"`;
  - the stars (already a cover) get no tier key.

  Watch it fail.
- [ ] Implement. `npm run check`.

### Task 13: Rule `picture.band`

**Files:** Create `src/core/adapt/rules/band.ts`. Modify `rules/index.ts`. Test: new `test/unit/adapt-band.test.ts`.

**Rule** (`decision`: "Photos keep their aspect ratio (phone rules, 2026-10-01): a band around a cover photo keeps the
photo's shape"):
- A `shape` box gets, from `tablet_portrait` down, `heightMin 0` and `css: aspect-ratio: W / H`.
- Its placed texts keep their distance to the nearer edge: a layer in the bottom half gets `top "auto"`,
  `bottom: <px>`.

`overrides: ["size.unpin"]`.

- [ ] Test: a 1440×864 free box (cover photo, tint, caption at y 817) → at `tablet_portrait`: `_heightMin "0"`,
  aspect-ratio `1440 / 864`; the caption gets `_top "auto"`, `_bottom "32"`. Watch it fail.
- [ ] Implement. `npm run check`.

### Task 14: Rule `turn.upright`

**Files:** Create `src/core/adapt/rules/upright.ts`. Modify `rules/index.ts`. Test `test/unit/adapt-rows.test.ts`.

**Rule** (`decision`: "The sideways label beside a heading turns upright on phones, a small line above it (user,
2026-10-07)"):
- A `quarterTurned` text in a row gets, from `mobile_landscape` down, `css: ["transform: none", "white-space: normal"]`,
  `width "100%"` and `flexShrink 1`.
- At tiers where `ctx.layout.row(row, tier)` isn't `"stack"`, it also gets margins of 0 (`row.reflow` zeroes them where
  the row stacks), and the row gets `wrap: true`, so the label takes its own line where it sits.

`overrides: ["space.ramp", "row.reflow"]`.

- [ ] Test: a hero-like row on a 1440 page (a 270°-turned 10px text, a 744-wide two-piece art column, a 380-wide
  paragraph column). At `mobile_landscape`:
  - the text's tier custom CSS has `transform: none`;
  - `_width "100%"` and margins 0;
  - the row gets `_flexWrap`.

  At `mobile_portrait` nothing collides. Watch it fail.
- [ ] Implement. `npm run check`.

### Task 15: Close and verify

**Files:** `src/shared/build.ts`, `CLAUDE.md`, `docs/HANDOFF.md`, the ledger, `corpus/paste/gro/bricks.json`.

- [ ] Bump `BUILD` (read it first; expect .17 → .18). Run `npm run check` and `npm run test:browser`.
- [ ] `npm run corpus`: each file's lint at each width is no worse than `$SP/report-v2-before.json`. Look at design,
  final-design, page-1 and hydraulics at 390 and 768 against the before shots.
- [ ] GRO: snap 390, 768, 1024, 1440 and 1920 with `--detail`, plus `--sides` at 1440.
  - 1440 and 1920: identical to before.
  - 1024: no worse.
  - 390 and 768: fewer errors, and each section's shot is right:
    - heading pieces whole and staggered;
    - the locator upright above the heading;
    - hero buttons full width;
    - landscapes at the bottom, patterns covering;
    - BUILD/GROW/CREATE and "01" above their photos;
    - "ALREADY" on its own line between its texts;
    - card 2 after card 1;
    - the 07 row stacked;
    - steps 01→04;
    - the quote whole;
    - the team photo in its shape;
    - section 11's cards whole.
- [ ] Update:
  - CLAUDE.md: where things stand, and the user's four decisions under "Decisions";
  - HANDOFF: a "GRO phones" section;
  - the end-of-run round trips: `order`, `aspect-ratio`, `transform` and `white-space` in tier custom CSS;
    `max()`/`min()` in `_margin`; `_position: relative` with `auto` offsets at tiers;
  - the deferred minors;
  - memory.
- [ ] One fresh review on opus (diff against `$SP/backup-pre-gro-phones`), then one fix pass, each fix test first.
- [ ] Move the ledger to `docs/plans/2026-10-07-gro-phones-ledger.md`.
- [ ] Regenerate `corpus/paste/gro/bricks.json` with snap and `pbcopy < corpus/paste/gro/bricks.json`.
- [ ] Tell the user in plain words: every ruling and deferred minor, and the phone check to do (paste into an empty
  page, Cmd+S, preview on a phone; the photos are grey stand-ins).

## Verification (end to end)

- `npm run check` and `npm run test:browser` green.
- `npm run corpus`: no width worse than build .17 for any file.
- GRO at 1440 and 1920 identical to build .17 (heights, lint, `--sides`). At 1024 no worse.
- GRO at 390 and 768: the listed problems are gone and lint errors are lower (390: 7, 768: 18 before).
- The user's phone paste check at the end of the run.
