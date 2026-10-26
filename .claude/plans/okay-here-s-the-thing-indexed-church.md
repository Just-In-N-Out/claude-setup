# Phone slider (slider-nested) renders empty in Bricks — diagnosis plan

## Context

The Figma→Bricks plugin (`/Users/justin/Desktop/FigmaPlugin/code.js`) emits a Bricks
`slider-nested` element ("Phone slider") for product/photo card sets. The desktop Bento
grid is hidden from 767px down and the slider is shown there instead. On the
khaki-finch site (Bricks 2.4.1) the slider shows in the structure panel but the canvas
shows nothing below the section header at the phone breakpoint. A slider the user built
by hand on the darksalmon-badger site (Bricks 2.3.9) works.

Goal: find the root cause and fix the plugin output so the pasted slider shows the cards
exactly like the hand-built one.

## Findings so far (evidence, not guesses)

**Plugin code that builds the slider** (`code.js`):
- `sliderSettings()` 1527, `sliderDots()` 1559, `makeSlider()` 1618, `hideFrom()` 1573,
  `fillSlide()` 1580, `copyForSlide()` 1596. Slides are `addEl(ctx, "block", slider.id, "Slide", {})`.
- Callers: `convertChildren` 3183–3198 (rows/grids) and `looseOnDevices` 1668/1689.
- Tests: `tests/slider.test.js`, `tests/responsive.test.js:92–111`, `tests/loose.test.js`.

**Working hand-built slider (user's paste, Bricks 2.3.9):**
- Root settings: `_display:none`, `_display:mobile_landscape:flex`, `_display:mobile_portrait:flex`,
  `pagination:true`, `autoHeight:true`, `gap:mobile_portrait:"16"`, `paginationBottom:mobile_portrait`,
  `paginationColor(Active):mobile_portrait`. No `_width`, no `_padding`, no `_cssCustom`.
- Slides: `name:"block"`, `settings:[]`, no `_hidden`, no `_cssClasses`. Each contains one
  component instance `div`.
- Rendered front-end HTML (fetched): root is
  `class="brxe-slider-nested splide brx-auto-height" data-splide="{...}"`, slides render as plain
  `<div id="brxe-dfjzii" class="brxe-block">` — **no `splide__slide` in the HTML**, so Bricks adds
  that class at runtime. Slides do not need any class in the JSON.

**Generated slider (round-tripped from Bricks 2.4.1):**
- Root: same display keys; `gap:"16px"` at base; `paginationBottom:"8"`; `paginationColor(Active)`
  at base; extra `_width:"100%"`, `_padding:{bottom:"32"}`, `_cssCustom` (pagination margin +
  `@media (max-width:767px){#brxe-yfujyj{display:flex}}`).
- Slides: `name:"block"`, `settings:{}`, label "Slide", each wrapping the full copied card.
- Parent container has `_alignItems:flex-start` (slider keeps width via `_width:100%`).

**Conclusion of the static diff:** no structural difference that Bricks documents as required.
The first hypothesis (missing `_hidden._cssClasses:"splide__slide"` on slides) is **falsified**
by the working JSON and HTML.

**Confounds still open:** different sites and Bricks versions (2.3.9 works vs 2.4.1 fails);
unknown whether the builder was reloaded after paste; unknown front-end behaviour; unknown
Splide init state. Bricks 2.4 changelog has one slider entry: "Slider (Nestable): Prevent outer
slider styles from affecting nested sliders".

**Blocked evidence:** khaki-finch homepage and all Bricks theme/uploads assets on both sites
return a Hostinger "Checking your browser" page to curl; browser tools are not available this
session.

## Open questions (asked to user)

1. Was the plugin output pasted on khaki-finch (2.4.1)? Does the hand-built slider work when
   pasted on that same site/section?
2. Was the builder reloaded after pasting, and does the front-end show the slider at phone width?
3. DevTools on the empty area: does `#brxe-yfujyj` carry `is-initialized`, do the slide blocks
   carry `splide__slide`, any console errors?

## Plan (to be finalised after answers)

See next revision.
