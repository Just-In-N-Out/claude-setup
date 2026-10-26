# Fix iPad/iPhone output + real Bricks Slider for image sets (Figma → Bricks plugin)

## Context

Desktop pastes come out exact. The tablet (≤991px) and phone (≤767px) versions the plugin generates are the
problem. These come from "Adapt for iPad and iPhone", which is on by default when only the desktop frame is
selected. They come out misaligned and cut off. Sections with several images end up piled on top of each other or
stacked one under another.

What the user decided:
- **Phones (≤767px):** multiple images or photo cards become a real Bricks **Slider (Nestable)** with swipe,
  arrows and dots.
- **Desktop and tablet:** keep the designed row, grid or collage.
- The content exists twice in Bricks: the desktop version is hidden at ≤767px and the slider is hidden at ≥768px.
- "Breakpoint designs" mode is untouched: it already switches these heuristics off (`convert()`, `code.js:3666`).

Root causes in `code.js`:
1. **Free-form layouts never adapt.**
   - A frame without auto layout whose layers overlap or sit irregularly becomes `mode: "NONE"` (`infer()` →
     `absoluteAll()`, lines 1060 and 1133).
   - Every layer is then `position:absolute` at its desktop px position. The box keeps its desktop height on every
     device (`addBox` line 2748, section container line 3024; in non-pixel mode `sec._heightMin`).
   - `absoluteAll` gives zero padding, so such sections also lose their side gutters on phones.
2. **The phone "slider" is only a CSS scroll-snap strip** (`sliderStyles` line 1556, 82% widths in
   `placeOnDevices`, grid version in `gridStyles`/`gridItemStyles`).
   - For many rows it only starts at ≤478px (`sliderKey = MOBILE`).
   - `leadingPhoto` only counts cards whose *first* layer is the photo, so other photo cards stack.
3. **Overflow sources:**
   - Hug text stays `nowrap` until 767px (line 2075), so it runs off iPads.
   - Cross-axis offsets rebuilt as px `margin-left` (line 2790) push items off phones.
   - Absolute badges keep desktop px `left` inside cards that shrink.
   - `_widthMin` is never released.
   - One overflowing element widens the whole page on iOS.

## Changes (all in `/Users/justin/Desktop/FigmaPlugin/code.js`, only when `ctx.opts.responsive`)

### 1. Real Bricks Slider (Nestable) on phones

**Slider element**
- `sliderSettings(gap)` is the only place that holds Splide keys. The keys come from Bricks docs and forum dumps:
  `type:"slide"`, `perPage:"1"`, `perMove:"1"`, `gap:"<phone gap>px"`, `height:"auto"`, `arrows:true`,
  `pagination:true`.
- Leave out the peek and the custom `options` JSON. Their keys are unconfirmed, and decimal `perPage` breaks Splide.

**`makeSlider(ctx, parentEl, pairs, gap)`**
- Appends a `slider-nested` element with settings
  `{_display:"none", "_display:mobile_landscape":"block", _width:"100%"}` to the same parent.
- For each `{k, el}` pair, it adds a `block` labelled "Slide" and puts a second conversion of `k` inside it
  (`copyForSlide`).
- It hides the originals on phones with `hideOnPhones(ctx, el)`. That sets `_display:mobile_landscape:"none"`
  plus an `addRule` of `display:none` at `PHONE_MEDIA`, because some elements carry a base `display:` CSS rule.

**`copyForSlide(ctx, k, slideId)`**
- Converts `k` again with `convertNode(k, slideId, "VERTICAL", ctx)` and records the copy in `ctx.copies[id]`.
- Guards around the copy:
  - Swap `ctx.nodeEl` to `Object.create(saved)` and restore it afterwards. `makeNav` and `makeAccordion` look
    elements up by node id.
  - Set `ctx.inSlide` so the copy never builds a slider inside a slide.
- `fillSlide(ctx, el)` normalises the copy's root:
  - Delete every device variant of `_width`, `_widthMin`, `_widthMax`, `_flexGrow`, `_flexBasis`,
    `_flexShrink`, `_margin` and `_alignSelf`.
  - Drop its `(min-width: 479px)` rules and `align-self` rules.
  - Set `_width:"100%"`.
- Assets already dedupe by key, and `note()` dedupes by name. `buildWarnings` must skip `ctx.copies` when it counts
  H1s.

**Rows** (`rowPlan`, `applyRowPlan`, `placeOnDevices`)
- The slider always starts at `:mobile_landscape`. Drop `sliderKey`, and set `landscape = null` for slider rows.
- On phones the row becomes `_direction:… "column"` with `_alignItems:… "stretch"`, holding just the slider.
- Delete `sliderStyles`, the 82% widths and scroll-snap, and the unused `a.collapse`.

**Grids** (`gridStyles`, `gridItemStyles`)
- `g.slider = !ctx.inSlide && sliderSet(a.flow)`.
- With a slider, the grid goes to one column at `PHONE_MEDIA`, and `collapseMedia` is at most `PHONE_MEDIA`.
- Remove the scroll-snap rules.

**Hook in `convertChildren`**
- Collect `{k, el}` pairs for the flow children.
- After `makeNav` and before the absolute-children loop, call `makeSlider` when `a.plan.phone === "slider"` or
  `a.grid.slider`. That makes the slider follow the last flow child.

**Detection**
- `cardPhoto(n, depth)` replaces `leadingPhoto`: the largest `isPhoto` within 3 levels.
- In `sliderSet`, a card counts when that photo is at least 60% of the card's width and at least 30% of its area.
- The pairs check in `rowPlan` uses `cardPhoto`.
- The logo-strip exclusion stays.

### 2. Free-form layouts (`mode "NONE"`) on tablet and phone

At the end of `convertChildren`, `if (responsive && a.mode === "NONE")`, call
`looseOnDevices(ctx, boxEl, box{w, h, shift}, items[{k, el, b}])`. Layers that cover the parent keep
`stretchToParent`.

- **Picture-only** (`countTexts === 0`): `scaleOnDevices` at ≤991px.
  - Each child's `_left`, `_top`, `_width` and `_height` become `%` of the parent. The child also gets
    `_heightMin:"0"`.
  - The parent gets `_height:"auto"` and `_heightMin:"0"`, plus `aspect-ratio: W / H` at `TABLET_MEDIA`.
  - The collage scales down and never cuts off.
  - On phones, with ≥2 photos and not inside a slide, it becomes a slider instead: the parent gets
    `aspect-ratio: auto` there.
- **With text: overlap groups first.**
  - `overlapGroups(node, kids)` finds layers that overlap each other (union-find).
  - Each group goes into a generated `div` ("Group"), placed absolutely at the group's bounding box. `place()` gains
    an `origin` argument so members sit relative to the group.
  - Desktop looks identical. Skip grouping when another layer sits between the members in paint order.
  - Each group gets its own `looseOnDevices` call, so a photo cluster scales on tablet and becomes a slider on
    phones, in its reading slot.
- **With text, card set** (`sliderSet` of the items):
  - Tablet: two per row (`calc(50% - gap)`) when W > 688.
  - Phones: a slider.
- **With text, otherwise:** `stackOnDevices` from the first tier where W no longer fits (`fitTier(w)`).
  - **Parent:** flex column with `_rowGap`, `_height:auto` and `_heightMin:0`. It also gets device side padding
    from `devicePad`, extracted from `addSection`'s `sides()`.
  - **Items:** `_position:relative` and `_top`/`_left:auto`, CSS `order` from `readingOrder`, and
    `_alignSelf:center` when the item is centred in the design.
  - **Decorative shapes** (no text, no picture): hidden.
  - **`readingOrder(items)`:** bands by vertical overlap, columns by horizontal overlap left to right, then top to
    bottom.

### 3. Overflow fixes

- **Hug text** (`addText`): also relax `nowrap` at `TABLET_MEDIA` when its width at the tablet font size is more
  than 688/2.
- **Cross-axis offsets from `infer()`:** `_margin:tablet_portrait {left:"0"}`, plus `_alignSelf:tablet_portrait`
  `flex-end` or `center` when the item was right-aligned or centred.
- **Absolute child of an auto-layout parent** (`place()`): `_left:tablet_portrait` as a % of the parent.
- **`sizeStyles`:** a `_widthMin` wider than a device's content width is set to `"0"` on that device.
- **`addSection`:**
  - Every section gets `overflow-x: clip` at `TABLET_MEDIA`. `clip` keeps sticky and overlaps between sections
    working.
  - In non-pixel mode, `_heightMin:tablet_portrait = "0"`.

### 4. CSS order and cascade

- `finalizeCss` stable-sorts the groups: rules without a media query first, then min-width and range queries, then
  pure `max-width` from widest to narrowest. That way phone rules always beat tablet rules for the same selector.
- Device overrides use Bricks control keys where they exist. CSS only for `aspect-ratio`, `order`, `overflow-x` and
  `white-space`.
- Anything added after `addEl` uses `addRule`, not `css()`.

### 5. Docs and version

- **README "Adapt for iPad and iPhone" table:**
  - Photo rows and grids: "Bricks Slider (Nestable) on phones".
  - A new free-form layouts row.
  - The overflow safety net.
- Replace the "Sliders set their own layout" and landscape bullets: the slider starts at 767px, and the content
  exists twice, so edit both copies.
- Add the `slider-nested` keys to the Calibrate list and to the `code.js` header "Not yet confirmed" comment.
- Update the `NOTES.overlapping` wording, and bump `PLUGIN_BUILD` to `2026-09-26.3`.

## Tests (`tests/responsive.test.js`, `tests/absolute.test.js`, `tests/grid.test.js`)

**Rewrite:**
- The scroll-snap tests should assert that the row or grid holds a `slider-nested` with one `block` slide per card,
  and that the originals are hidden at ≤767px.
- iPad keeps the row.
- The slide copies are `_width:"100%"` with no `min-width: 479px` rules.
- The grid goes to one column at 767px.
- "A box whose layers are all placed absolutely keeps its height on every device" should become the scaled collage:
  `_height:tablet_portrait:"auto"`, `aspect-ratio` at 991px, kids in %, and a 2-slide slider on phones.

**Add:**
- **Detection:**
  - Cards with the text above the photo form a slider.
  - A photo nested 3 deep counts.
  - The logo strip, text cards, and the device option off produce no slider.
- **Slider structure and side effects:**
  - The slider comes before an absolute badge.
  - `nodeEl` is restored after the copies.
  - The asset count is unchanged.
  - The H1 is counted once.
  - No slider inside a slide.
- **Free-form layouts:**
  - A free-form hero (heading, text, 3 overlapping photos, a decor rectangle). Tablet: stacked with `order`, the
    photos in a scaled Group, the decor hidden. Phones: a 3-slide slider in the Group.
  - An irregular card set: two per row on iPad, a slider on phones.
  - Reading order.
  - A small overlapping button gets no device keys.
- **Overflow fixes:** hug text relaxes at 991px for 500px text but not for 120px text; right-aligned offset; badge
  %; section `overflow-x: clip`; `_widthMin` released; `finalizeCss` puts tablet before phone; non-pixel
  `_heightMin` released.

## Verification

1. `node tests/run.js`: all suites pass, including the existing 190 tests.
2. In Figma desktop, close and reopen the plugin so it loads the new build. Check that the build shown after
   conversion is `2026-09-26.3`.
3. Convert a page with a photo-card row, a photo collage, and a free-form hero. Paste into Bricks. Then check:
   - Desktop is unchanged, pixel for pixel.
   - In browser devtools at 1024, 820, 768, 430, 390 and 375px wide, nothing is cut off and there is no sideways
     page scroll.
   - The slider swipes, and its arrows and dots work on a real phone.
4. If the slider doesn't move or has the wrong height, build a Slider (Nestable) by hand in Bricks, copy it, and fix
   the keys in `sliderSettings()`. This is the same calibration the README already describes for the Carousel.
