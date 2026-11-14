# clean-values: settings before Custom CSS and clean values, in both tools (plan, 2026-11-13)

Planner: clean-values (Fable 5.2, high). Pipeline: **Full** (Justin, 2026-11-13). Both tools: the website importer
(`src/core/site/`, the `site*` commands) and the Figma plugin (`src/core/style`, `adapt`, `emit`).
**Base: `main` once these have merged** (they change the same code; today `main` is `7f54b0a5`, Build 2026-11-12.3):
site-no-div (`site-no-div-fix3` `828f7dc0`; moved onto main as `site-no-div-final` `cf4f887d` while this was
planned), site-shared-styles (`site-shared-styles-fix1` `7b7501bd`), plugin-parity (`plugin-parity-build` `fcdec6e2`),
importer-parity (`importer-parity-build`, read at `33a73f41`; at `1f407006` when this plan was saved, with its
settings, renderer and hover keys built: `controls-more.ts`, `control-values.ts`), shared-palette
(`shared-palette-build` `738e300a`). Every file:line below is from a `git archive` of one of those heads
(named where it matters); the builder re-reads each on its real base before editing.
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/clean-values/planner/` (`README.md` lists every file;
the prototype's sources are in `<P>/proto/`, sums in `<P>/SHA256SUMS`).
Plan copy for the repo: `docs/plans/2026-11-13-clean-values.md` (the builder copies this file there in Task 1).
No live site was loaded, nothing was sent anywhere, nothing in the repo or `~/Downloads` was changed.

## Playback

1. Justin compared a paste with a hand-built Bricks page and named two things that still differ: styling a person
   would put in Bricks' settings sits in Custom CSS (gradients, layered backgrounds, hover looks, `clamp()` sizes),
   and values are copied exactly (17.6px) where a person would write a clean number.
2. This job moves every value that has a Bricks setting into that setting, in both tools, and leaves in Custom CSS
   only what Bricks has no setting for, each kind named with its reason in the notes.
3. It writes a clean number only where nothing moves by more than half a pixel, measured per element per width; where
   that can't be proven the exact value stays. The importer stays one to one with the site and a Figma design stays
   exact at its design width.

## Questions (⭐ = the answer taken; Justin is asleep, so each ⭐ is a ruling he can change with one word)

1. **Which Custom CSS becomes a setting?** ⭐ **A:** every declaration whose Bricks setting is proven by one of his
   own samples or by Bricks' own code (the table under "S"), and only where the setting prints exactly the same CSS.
   B: only the four he named (gradients, backgrounds, hover, `clamp()`). *Researched: `reference/bricks/*.json`,
   `ExampleBricks`, Bricks 2.2's `base.php` and `assets.php`, B-Dry staging's own Bricks 2.4.2 builder script
   (`<P>/builder-2.4.2-keys.txt`): the keys are the same in 2.2 and 2.4.2.*
2. **Hover, focus and pressed looks.** ⭐ **A:** an element's own `:hover`, `:focus` and `:active` looks go in Bricks'
   state settings (the state menu at the top of the Style tab shows exactly these three: Bricks' default list,
   `database.php` L1417-1421, and `new Set([":hover",":focus",":active"])` in the 2.4.2 builder); `:focus-visible`,
   `:focus-within`, a look on a part (`::before`) and a look another element's state sets stay Custom CSS. B: hover
   only (importer-parity's rule), which leaves a button's main colour in Custom CSS on B-Dry, because its focus look
   changes it too. *Risk taken with A: a site whose state list had `:focus` removed by hand would not print that look;
   the live check looks at it.*
3. **Gradients and layered backgrounds.** ⭐ **A:** one linear gradient is Bricks' Gradient setting; a background
   picture's position, repeat and attachment join its Background setting; several layers in one background (a
   gradient over a photo, two gradients), radial and conic gradients and an overlay drawn on `::before` stay Custom
   CSS, named in the notes. B: a gradient over a photo as Bricks' "overlay" gradient: not taken, because Bricks draws
   an overlay on `::before` and makes every child `position: relative` (`assets.php` L2557-2580), which is not what
   the site or the design draws (exact wins, point 6 of the standard).
4. **A value the site changes at a width Bricks has no breakpoint for** (bdryswi.com: 1366, 1024, 921, 834, 576, 479,
   440, 412, 393, 360; Bricks: 991, 767, 478). ⭐ **A:** as today: the whole property stays Custom CSS on its class
   (one place), counted in the notes (about one in six of what stays on his scan). B: the setting plus a short Custom
   CSS line for the band between: a later job of its own (`site-breakpoint-fit`), because that line must out-weigh
   Bricks' tier settings and needs its own proof.
5. **What "clean" means for a size.** ⭐ **A:** a px size written with a fraction becomes the nearest whole pixel
   (17.6px → 18px, 7.25px → 7px), only where no element's box moves by more than 0.5 px at any measured width;
   percentages, `em` and plain numbers (a line height of 1.65) are never rounded. B: also round to the page's nearest
   common step even when that is more than half a pixel away: not taken (it moves things).
6. **Where the half-pixel guard is measured.** ⭐ **A:** in the importer's commands, which already have a Chrome:
   `site:import` and `site:upload` draw the paste exact and rounded, offline, at one width per range the scan read, and
   keep a rounding only when it passes alone and together with the others; the decisions go in `clean.json` beside
   `media.json`, and `npm run site … --clean <clean.json>` remakes the same pastes offline. `npm run site` alone
   rounds nothing unless given `--clean` or `--round`. No Chrome: every size stays exact, with one note.
7. **Rounding in the Figma plugin.** ⭐ **A:** the plugin has no browser at Convert, so it can't measure; it cleans only
   what provably moves nothing: number noise (25.999923706054688px → 26px, under 0.01 px) and its own layout formulas,
   rewritten shorter with the same value. A designer's own 10.5px or 18.72px stays. B: measure in the panel: a later
   job if he wants it.
8. **Where a spacing or type step lives.** ⭐ **A:** on the shared classes the earlier jobs made (a text size on its
   text class, a padding on its box class), so one edit changes every use; this job adds `sizes.txt`, the page's own
   scale (each size, how often, which class). No Bricks variables in this job. B: a `variables.json` to import
   (`--space-m`): not taken now: Bricks' clipboard carries no variables, its import shape isn't in his samples, and a
   Bricks pro usually brings their own variable names.
9. **Declarations that say nothing** (Elementor writes `order: unset`, `flex-wrap: unset`, `box-shadow: none`,
   `transition: unset` on almost every box). ⭐ **A:** left out where the keyword is all the property ever says on that
   element (a closed list of 16 properties that never inherit and that no browser rule sets); written as the value it
   means where a narrower width needs it (`flex-wrap: wrap`, then `unset` on phones → Flex wrap: nowrap on phones).
   B: keep them: 2,744 lines of noise on his scan stay.
10. **Logical sides** (`padding-inline-start`). ⭐ **A:** on an element that reads left to right with lines across (the
    scan's own reading), written as the physical side's setting (Padding left). Right-to-left or vertical text keeps the
    site's names.
11. **The plugin's settings.** ⭐ **A:** Pointer events, Aspect ratio, Isolation, Visibility, Text decoration and one
    linear gradient become settings (about 500 of the 2,939 Custom CSS declarations of the five real files); layered
    and radial paints, variable-font axes, `white-space`, blur and everything on a part stay Custom CSS.
12. **A switch.** ⭐ **A:** on by default in both tools; `--no-clean` (importer) writes the paste as before this job,
    byte for byte; the plugin has no panel box (nothing to choose: nothing moves).

## What Justin will see (the planner's prototype)

**Importer, his 2026-11-11 scan of bdryswi.com, `--elementor`** (shared-palette head, `<P>/site-*.txt`):

| | Custom CSS declarations | Custom CSS lines | of the elements' own base rules |
|---|---|---|---|
| today | 13,162 | 1,367 | 7,868 |
| with importer-parity's settings (its planner's prototype, no hover) | 11,515 | 1,360 | |
| with this job's prototype on top | 8,978 | 1,311 | 3,775 |

- The stand-in (B-Dry's saved 2026-10-29 home): 7,860 → 6,727 → 4,647. Plain route: 13,284 → 8,681 and 7,881 →
  4,319. On site-no-div's head: 13,763 → 9,114 and 8,431 → 4,781 (`<P>/batch2-run.log`).
- Settings that were Custom CSS (his scan, classes holding each): this job's Transition 203, Flex wrap 91 (was 3),
  Visibility 73, Grid columns 10, Pointer events 10, Aspect ratio 5, and Margin 242 (was 147) and Padding 185 (was
  137) through the logical sides; importer-parity's Position 204, Border 171, Overflow 123, Cursor 44, Z-index 44,
  Box shadow 14 are in the same drawing. 2,744 declarations that say nothing are gone (counted per class build).
  Not yet in the prototype (counted, `<P>/kinds-*.txt`): 9 gradients (+2 at a tier), 49 hover declarations in 32
  hover rules, 36 text decorations, the background position and repeat of 19 pictures.
- **Nothing moves** (`<P>/style-diff-*.log`): the same scan converted with the prototype off and on, both drawn as
  `site:check` draws them (Bricks 2.4.2's front-end CSS, offline), every computed property of every element, its
  `::before` and `::after` and its box: first prototype 15,360 readings at 15 widths (his scan), 8,736 at 12 widths
  (stand-in), 4,568 (plain route) and 4,096 (site-no-div's head) at 4 widths: **0 differ**. The final prototype, the
  same runs again (`<P>/batch2-run.log`): the stand-in, the plain route and site-no-div's head 0 differ; his scan 2
  of 15,360: one Section's entrance animation caught mid-play (its `animation-name` on at 672 in one drawing and at
  528 in the other); those two widths drawn twice more: 0 differ (`<P>/batch3-run.log`).
- **What stays Custom CSS and why** (his scan, by where it sits): 2,166 on parts of an element (its words' inline
  elements, a flat wrapper's inside), 663 on `::before`/`::after`, about 1,700 at widths Bricks has no breakpoint for,
  about 350 under a state, and properties Bricks has no setting for (`box-sizing` 521, `outline` 667, `text-shadow`
  116, `vertical-align` 115, `word-break` 102 …). The notes say this in one line per kind.
- **Rounding** (`<P>/round-probe-justin-el.txt`, 15 widths): his scan writes 24 px sizes with a fraction; 18 are
  candidates by rule V1. 16 round to the whole pixel with no box moving more than 0.5 px, alone and together (worst
  0.453 px, at 672): 7.25px → 7px and fifteen widths a script had measured (596.75px → 597px, 160.328px → 160px …).
  2 stay exact: the font size 14.592px (38 uses; as 15px its lines grow and boxes down the page move by up to 78 px)
  and a line height of 75.6px (2.8 px). The 6 left alone by rule: letter spacings (−0.4px, 0.5px, −1.1px, −1.3px:
  three of them moved boxes by 10 to 164 px when tried) and two hairlines (1.5px, 1.3px). The stand-in
  (`<P>/round-probe-standin-el.txt`, 12 widths): 21 fractions, 17 candidates, 16 round (worst 0.453 px), the 75.6px
  line height stays.
- **Distinct size values** (settings and Custom CSS together, `<P>/distinct-sizes.txt`): his scan 158 → 156, the
  stand-in 140 → 139 from the settings alone (two spellings of one side merge); the rounding takes off what "V"
  lists. The scale stays the site's own (see "The scale").
- **Formulas**: Elementor's `calc(20px)`, `min(100%,100%)`, `calc(100% - 0px - 0px)` become `20px`, `100%`, `100%` (9 of
  his page's 21 formulas, 77 uses), so they fit a setting.

**Plugin, the five real files on this machine, "Pictures go: to WordPress"** (plugin-parity head, `<P>/plugin-*.txt`):

| | hydraulics | GRO | Repairs | brainstorm | Services |
|---|---|---|---|---|---|
| Custom CSS declarations today | 630 | 628 | 424 | 636 | 621 |
| formulas: distinct / get shorter | 59 / 44 | 148 / 118 | 47 / 32 | 49 / 38 | 61 / 42 |
| longest value, characters | 442 → 200 | 126 → 70 | 442 → 200 | 635 → 303 | 442 → 200 |
| distinct size values | 217 → 208 | 570 → 569 | 172 → 165 | 280 → 277 | 219 → 215 |

- A padding today: `clamp(20px, calc((min(201.8300018310547px, max(0px, calc(max(0px, calc(min(1648px, max(0px,
  calc(calc(100vw - 32px) - 0px))) - 0px)) - calc(0px * 2 + 0px)))) - 151px) / 2), 26px)`; after: `clamp(20px,
  (min(201.83px, max(0px, 100vw - 32px)) - 151px) / 2, 26px)`: the same value at every width (checked for 40 random
  unit sizes per formula; 363 of the five files' 364 distinct texts are formulas it reads, the other is a script;
  largest difference 0: `<P>/css-math-check.txt`).
- Settings that are Custom CSS today, over the five files (`<P>/plugin-pp-*.txt`): Pointer events 107, Aspect ratio
  103 (at tablets and phones), Isolation 91, Text decoration 62, Visibility 48, 27 single linear gradients. Stays:
  variable-font axes (404), `white-space` (481), blur, 16 radial and 3 layered paints, everything on a part.
- Moves: nothing by more than 0.01 px (the noise); the formulas give the same number.

## What is true today (file:line)

- **Importer.** One function decides (`src/core/site/controls.ts:97-130` on `main` and on every head read; importer-parity's newest head has it at
  `controls.ts:86-124`): a property is
  a setting when it is in `RULES` (L66-90: display, flex, gaps, sizes, padding, margin, typography, colour,
  background colour), every value is "plain" (L20: a number with px, %, em, vw or vh), every change falls on Bricks'
  breakpoints and no state changes it (`keep`). Everything else is the class's Custom CSS (`classes.ts:152`
  `customCss`). importer-parity (in flight; built on its branch at `1f407006`) adds position, offsets, z-index, order, overflow, flex item, opacity,
  cursor, object-fit, corners, border, one box shadow and hover-only state keys (its plan's section E, criteria five
  to eight). After it: formulas, transitions, gradients, the rest of the table below, focus and pressed looks, logical
  sides and the keywords still stay Custom CSS.
- **Why a setting is safe or not** (`test/browser/render-order.ts:1-45`, read from live Bricks 2.3.9 and 2.4.2): a
  class's settings print as `.<class>.brxe-<element>` (0,2,0): desktop settings, then the class's Custom CSS
  (`.<class>`, 0,1,0), then tier settings; a state key prints `.<class>.brxe-<element>:hover` (0,3,0). So a setting
  always beats the same class's Custom CSS, and anything else in the paste that writes the property for that element
  at class weight would lose to it: such a property must stay Custom CSS (importer-parity's K1–K4; the prototype met
  three: the stay class's `position` on a top Section, a Slider's own transition, a border colour a hover changes).
- **Bricks writes a number or text setting as given** (`assets.php` 2.2 L2841-2869, L2355-2385, L2800-2815: only a
  bare number gets `px`), so `calc()`, `clamp()`, `min()`, `max()`, `var()` and `rem` go out untouched. The plugin
  already writes `clamp()` in Padding and Font size on darksalmon.
- **Plugin.** `Style.css: string[]` (`src/core/style/types.ts:84`) holds "declarations Bricks has no setting for",
  but five of them have one (`_aspectRatio` `base.php` L463, `_visibility` L696, `_isolation` L810, `_pointerEvents`
  L842, `_gradient` L1349). Their producers push strings: `style/hotspots.ts:94,113,124`, `picture.ts:66,77,82`,
  `art.ts:12`, `video.ts:26`, `style.ts:84,179,320`, `classes.ts:86`, `photo-width.ts:102`, `states.ts:139,142`,
  `adapt/rules/compose.ts:40`, `menu.ts:63,82`, `drawn.ts:21,51`, `band.ts:19`, `media.ts:15`, `unpin.ts:83`,
  `diagram.ts:18,20`, `art.ts:37,79,117`, `side-stack.ts:204`, and a paint's gradient (`style/paint.ts:47,121,166-169`).
- **The plugin's formulas** are composed as text by the layout plan (`adapt/layout.ts:131,200`, `least.ts:132`,
  `style/place.ts:128,145,175`), each wrapping the last, and carry Figma's float noise (`201.8300018310547px`).
- **Neither tool rounds.** The importer writes the site's `14.592px`; the plugin rounds its own lengths to whole
  pixels (`emit/settings.ts:14-15` `len`) and font sizes to two decimals (`fine`), but not numbers inside a formula.

## The rules (general, for every scanned site and every Figma design)

### S. A value with a Bricks setting goes in that setting (importer)

One rule decides, as today: a property is a setting when every value it takes fits, every change falls on Bricks'
breakpoints with nothing bounded below, and nothing else in the paste writes it for the element (importer-parity's
K1–K4). A group (a transition's longhands, a background's parts) is all or nothing, so a setting never meets its own
property in the Custom CSS. This job adds, beside importer-parity's table:

| CSS | Setting | It fits when | Key and shape proven by |
|---|---|---|---|
| any length the table (its and this one) takes, written as `calc()`, `clamp()`, `min()`, `max()`, `var()` or with `rem`, `ch`, `vmin`, `vmax`, `svh`… | the property's own setting, the text as written (after "M") | brackets balanced, no `!important`, no `;` `{` `}`; never a bare number in Flex basis | `assets.php` L2841-2869 (number), L2355-2385 (spacing), L2800-2815 (typography) |
| `transition-property`, `-duration`, `-timing-function`, `-delay`, `-behavior` (or `transition`) | `_cssTransition`, one text: `<property> <duration> <easing> <delay>, …` | every longhand a list of real values, `-behavior` all `normal` | `base.php` L1489; the 2.4.2 builder `_cssTransition:{type:"text"}`; the plugin writes it (`emit/settings.ts`) |
| `font-style` | `_typography["font-style"]` | `normal`, `italic`, `oblique` | `reference/bricks/form-schema.json` `_typography`; `emit/settings.ts` `typography()` |
| `text-decoration-line` with its colour, style and thickness absent or `initial` (or `text-decoration` of one word) | `_typography["text-decoration"]` | `none`, `underline`, `line-through`, `overline` | the same; `assets.php` L2800-2815 prints `text-decoration: <v>` |
| `aspect-ratio` | `_aspectRatio` (text) | `a / b`, a number, with or without `auto` | `base.php` L463-477 |
| `visibility` | `_visibility` | `visible`, `hidden`, `collapse` | `base.php` L696 |
| `isolation` | `_isolation` | `auto`, `isolate` | `base.php` L810 |
| `pointer-events` | `_pointerEvents` (text) | `none`, `auto` | `base.php` L842 |
| `grid-template-columns` | `_gridTemplateColumns` | a layout element; no keyword that passes a value on | `ExampleBricks` (`"1fr 1fr 1fr"`, with tier keys) |
| `transform` | `_transform` `{ translateX, translateY, scaleX, scaleY }` in the written order | only `translate()`, `translateX()`, `translateY()`, `scale()`, `scaleX()`, `scaleY()`, each once; lengths with their unit | `base.php` L1388; `assets.php` L2702-2735; his `_transform:hover` `{ translateY: "-3" }` |
| `background-image`: one `linear-gradient()` | `_gradient` `{ angle?, colors: [{ id, color, stop? }] }` | rule G | `reference/bricks/hero-video-buttons.json`, `staff-card.json`; `assets.php` L2436-2600 |
| `background-repeat`, `-attachment`, `-position-x` + `-position-y`, `-size` beside a Background image or Gradient setting | `_background` `{ repeat, attachment, position: "custom", positionX, positionY, size \| size: "custom", custom }` | one value each (no comma list); the image itself is a setting | `assets.php` L2056-2108; `test/browser/render.ts` (media-clickable) prints them |

Borders, corners, box shadows, position, offsets, overflow and the flex item values are importer-parity's table and
are not repeated here; this job only lets them take a formula (the first row). Rotation, skew and 3D transforms stay
Custom CSS (Bricks cuts a rotation to whole degrees, `assets.php` L2716-2722).
Colours of the new settings (a gradient's stops, a state's colour) go through site-shared-styles' `inked`, so they link
to the palette like every other.

**G. One linear gradient.** The class's `background-image` at every width it is set is one `linear-gradient()` and
nothing else (no second layer, no `url()`, no `background` shorthand in the class, no Background image setting on
it); its direction is an angle in `deg`, one of `to top | right | bottom | left` (0, 90, 180, 270) or absent (180);
every stop is a colour (`#hex`, `rgb()`, `rgba()`) with at most one position; no colour hint. Then `_gradient` =
`{ angle: "<n>", colors: [{ id, color: <as a colour setting>, stop: "<n>" (a percentage) or "<length>" }] }`, the ids
from `shortId("gradient:<class key>:<n>")`. A width where the picture is `none`, a repeating, radial or conic
gradient, or a state that changes it, keeps the whole group Custom CSS; the notes say which (`several layers`, `a
gradient over a picture`, `a radial or conic gradient`, `it changes between Bricks' breakpoints`).

### H. States

- An element's own `hover`, `focus` and `active` looks (no part, read at the design width's range as today): each
  declaration that fits a setting by the rules above, whose base is a setting too, is written under that state's key
  (`_background:hover`, `_typography:focus`, `_border:active`, `_boxShadow:hover`, `_transform:hover`, `_opacity:hover`
  …) and leaves the class's state rule; what doesn't fit stays in that rule.
- The keys are written in the site's own rule order for the three states (the capture's `states` order). Bricks
  prints one rule per selector in the order the keys first name it (`assets.php` L3121-3133), so where an element is
  hovered and focused at once the same look wins as on the site.
- A property that a `focus-visible` or `focus-within` look, a look on a part, or another element's state changes
  stays Custom CSS whole (importer-parity's K1, unchanged), under either of a side's two names (a state that writes
  `padding-inline-start` keeps `padding-left` too).
- This replaces importer-parity's "hover only where no other state changes the property" with "hover, focus and
  active"; its hover keys stay as they are.

### T. Tidy: one name per side, and nothing that says nothing

Applied where the paste's values per range are made (before the shared looks and the settings read them), so two
boxes that differ only by such a line can share a look:
- **T1 Logical sides.** `padding-` and `margin-inline-start | inline-end | block-start | block-end` are written as
  `-left | -right | -top | -bottom` on an element whose direction is `ltr` and whose lines run across: the scan's
  context says `ltr`, and neither the element nor any box above it in the paste declares another `direction` or a
  `writing-mode` at any width. Not when the class holds the physical name of the same side at some width (an older
  capture that kept both names), nor when a state writes either name. Else the site's names stay.
- **T2 A keyword that says nothing.** For `order`, `flex-grow`, `flex-shrink`, `flex-basis`, `flex-wrap`,
  `flex-direction`, `align-self`, `align-items`, `align-content`, `justify-content`, `justify-items`, `justify-self`,
  `row-gap`, `column-gap` (none inherits; no browser style sheet sets one on any element; under the paste's reset
  the browser's own value is the starting value): `unset`, `initial`, `revert` or the starting value itself is left out at every
  width from the widest down to the first real value (so a property that never takes one is gone whole); a keyword
  that takes a real value back at a narrower width is written as the value it means (`0`, `1`, `auto`, `nowrap`,
  `row`, `normal`), so the property can be a setting. (The prototype writes the starting value at the wide widths
  too; leaving it out there draws the same and shows less.)
- **T3 A transition or a shadow never set.** `transition-*` all `unset | initial | revert`, or `box-shadow` only
  `none` or such a keyword, at every width: left out.
- Never: a property that inherits (`color: unset` passes the parent's colour on), a keyword on a property outside
  the list, a property a state changes, a class written on the site's element inside a flat wrapper.
- The builder may add a property to T2 only with a fixture and the drawn proof of the seventh criterion.

### M. Formulas, written once, by both tools

`src/core/model/css-math.ts` (new, imports nothing; prototype `<P>/proto/css-math.ts`, 190 lines): a formula is read
into a typed tree (`parse`), simplified by rules that never change its value (`simplify`), printed once (`print`):
sums flattened and like terms added (`calc(100% - 0px - 0px)` → `100%`), a product with a plain number worked out
(`0px * 2 + 0px` → `0px`, `x / 1` → `x`), nested `calc()` dropped, nested `min`/`max` of one kind joined, constants
of one unit compared (`min(201.83px, 1648px, …)` → `min(201.83px, …)`), `max(0px, x)` → `x` where `x` can't be
negative. Text it can't read whole is returned exactly as written; a `var()` is kept as written and never taken out
of its sum. `tidy(e, 2)` rounds px numbers to two decimals (the plugin's float noise); `cleanLen(text, digits?)` is
the one call both tools use for a length they write.
- **Importer:** every declared value the paste writes for a size, spacing, offset or typography property goes
  through `cleanLen(text)` (no digits: a site's numbers are its own) in `convert.ts` `rewrite`, except on an element
  shown as a table part (`display: table-*`: a percentage in a formula is laid out differently from a bare one
  there). A formula that becomes a plain value then fits the settings of today.
- **Plugin:** `emit/settings.ts` `len`, `fine`, `asText`, `sides` and `gapOf` pass a text length through
  `cleanLen(text, 2)`. Numbers the plugin rounds already stay as they are.

### V. Clean values, measured (importer)

- **V1 Candidates.** Every px number with a fraction, 4 px or more, that the paste writes as the whole value (or one
  side) of `font-size`, `line-height`, a padding, margin or gap, a corner, a width or height (and their min and max)
  or an offset, in a setting or in Custom CSS. Never a letter spacing or a border width (a fraction there is the
  design: a hairline, a tracking), never a value under 4 px (rounding 0.4px gives nothing, 1.5px gives a third more);
  never inside a formula, a shadow, a transform or a gradient; never a percentage, an `em`, a plain number, a time or
  a colour. The clean value is the nearest whole pixel (a half rounds up).
- **V2 The pure part.** `ConvertOptions.clean.rounded: Record<string, string>` (`{ "7.25px": "7px" }`): `rewrite`
  writes the clean value wherever V1's rule finds that exact value, through the typed tokens (`value.ts`); nothing
  else of the paste changes. Without it nothing is rounded.
- **V3 The guard** (`tools/lib/site-clean.ts`, new): the paste is converted exact and drawn as `site:check` draws it
  (the test renderer with Bricks' front-end CSS, the offline Chrome of `tools/lib/site-chrome.ts`), one tab per part,
  at one width per range the capture read (each range's anchor); every element's box is read. Each candidate value is
  then drawn alone (the tab's style text swapped, no reload) and passes when no box's left, top, width or height
  differs from the exact drawing by more than 0.5 px at any width. All that passed are drawn together; while any box
  moves by more than 0.5 px, the one with the largest move of its own is taken out (ties: the later value in text
  order) and the rest drawn again. What is left is the rounding.
- **V4 The record.** `<outDir>/clean.json`: `{ version: 1, bricks, widths, rounded: { "<value>": "<clean>" }, kept:
  { "<value>": { to, move, at } }, worst }` (`worst`: the largest move of the final paste, at most 0.5).
  `site:import` and `site:upload` measure by default (`--no-round`: none) and write it; `npm run site` takes `--clean
  <clean.json>` (reuse, offline, byte for byte the same pastes) or `--round` (measure now); with neither it rounds
  nothing. Chrome not found: nothing is rounded, one note says so. `--no-clean` switches the whole job off.
  `site:check` and `site:live` take the same `--clean <clean.json>` and `--no-clean`, so they draw and map the paste
  that was really pasted (their class names are made from the classes' rules, so a page pasted before this job is
  checked with `--no-clean`).
- **V5 The notes.** `Values: <n> px sizes rounded to whole pixels (7.25px → 7px ×1, …); <k> kept exact because a box
  would move more than 0.5 px (14.592px → 15px: 2.8 px at 1440, …)`.
- Measured (`<P>/round-probe-justin-el.txt`, `<P>/round-probe-standin-el.txt`: every fraction, its move alone, the
  set that passes together): on his scan 16 of 18 candidates round, worst move 0.453 px; `14.592px` and `75.6px` stay.
  The probe tried every fraction, also the ones V1 leaves alone: rounding a letter spacing of 0.5px to 1px moved a box
  by 164 px, which is why V1 never takes one.

### The scale: where a step lives

- A hand-built page has a few type and spacing steps. A scanned page has the steps its builder used (his scan: 40
  font sizes, 72 spacing values, counting each width's), and a one-to-one copy can't merge two of them: 15px and 16px
  are one step to a person, but making them one moves every line set in either by more than half a pixel. So the
  scale is the page's own set of values, each written clean where V proves it (a whole pixel) and exact where not.
- A step lives on a shared class: a font size on its text class (site-shared-styles' and plugin-parity's text looks),
  a padding on its box class, a gap on its layout class; a one-off sits on the element's own class. Changing the
  step there changes every use. `sizes.txt` shows the scale to the person who wants to tidy it by hand: each value,
  its uses, the class that carries it, most used first.
- No Bricks variable is made (Q8).

### P. The plugin

- **P1 Typed fields.** `Style` gains `aspectRatio?: string`, `isolation?: "isolate" | "auto"`, `pointerEvents?:
  "none" | "auto"`, `visibility?: "hidden" | "visible"` and `background.gradient?: { angle: number; stops: Array<{
  color: RGBA; at?: number }> }`; `font.decoration` already exists. Every producer listed under "What is true today"
  sets the field instead of pushing a string on the element's own `css` (strings inside `parts`, `around`,
  `motionParts`, `stillParts`, `fromDesign` and `fromLaptop` stay strings: a part has no settings). `adapt/rules/
  art.ts:79` reads `style.isolation === "isolate"` instead of searching the strings.
- **P2 Emit.** `emit/settings.ts` `bricksSettings` writes `_aspectRatio`, `_isolation`, `_pointerEvents`,
  `_visibility` and, through `emit/gradient-shape.ts` (new, imports `./ids.ts` only; the importer calls the same
  function), `_gradient`; a link's `text-decoration: none` (`style/style.ts:179`) becomes `font.decoration: "none"`
  (its `color: inherit` stays Custom CSS). `emit/css.ts` `cssDecls` prints the new fields as declarations for a look
  that follows another element (as it does every typed field), so those rules stay as they are.
- **P3 One linear paint.** `style/paint.ts`: a layer's only paint that is one linear gradient (Figma's angle, stops
  inside 0–100%) sets `background.gradient`; its size, position and repeat, when the paint fills the layer (`auto`),
  are not written (a gradient is as large as the box it paints); several paints, a radial, angular or diamond
  gradient, a gradient under a picture and a paint with its own size stay as today (`background-image` in Custom
  CSS). It rides with the box look (`emit/looks.ts` `TAKES.box`/`button` hold `background`).
- **P4 Rules that wrote the same property.** Custom CSS strings "add up and never collide" (`adapt/engine.ts:14-18`);
  a typed field does. Where two rules write `aspectRatio` (or another new field) on one layer at one tier, the later
  rule in `RULES` lists the earlier in `overrides` (the later declaration won in CSS too). Anything else the engine
  reports is a stop.
- **P5 Formulas and noise:** "M".
- Not touched: an Icon's weightless rules (`style/icon.ts`: its `overflow: clip` and `height: auto` stay where
  bricks-icons put them), variable-font axes, `white-space`, `backdrop-filter`, outlines, anything under
  `fromDesign`/`fromLaptop`, the panel (`src/ui`), `src/plugin`, website captures in the plugin (`scene.capture`:
  byte for byte as before, like plugin-parity's parts).

### What stays Custom CSS, and what the notes say

Every part's notes end with one line per kind that the paste holds (importer; `npm run site` prints them too):
`Custom CSS that stays: <n> declarations: <a> at widths Bricks has no breakpoint for (1366, 1024, …), <b> on parts
(::before, ::after, words inside a text), <c> under a state Bricks has no menu for, <d> with no Bricks setting
(box-sizing, outline, text-shadow, …), <e> layered or radial backgrounds, <f> other`. `sizes.txt` lists the page's own
scale: each font size and each spacing value with its uses and the shared class that carries it.

## The standard, point by point (CLAUDE.md, top of "Decisions the user made")

1. **Structure:** not changed (no element is added, removed or renamed; site-no-div and plugin-parity own it).
2. **Classes:** a moved value stays on the class that held it (a shared look's on the look, a one-off's on the
   element's own class); T1 and T2 run before the looks are grouped, so two boxes that differed only by a logical
   name or a keyword now share one. No property is ever written by two classes of one element, or by a class's
   setting and its Custom CSS (the eighth criterion). Names are not changed here.
3. **Settings before Custom CSS:** the job itself: the tables under S, G, H and P; Custom CSS keeps only what Bricks
   has no setting for, shorter (T2, T3, M) and named by kind in the notes. Colours stay palette links. Sizes are
   clean where that moves nothing (V for the importer, M's noise for the plugin); else exact, and the notes name each.
4. **Bricks' own behaviour:** a hover, focus or pressed look is Bricks' own state setting, not a Custom CSS rule; a
   transition is Bricks' Transition field. No Code element is added.
5. **Editable content:** a gradient's colours and a picture's position and repeat sit in fields a person clicks,
   not in a CSS line.
6. **Looks stay true:** every setting must print the same CSS (the drawn proofs: every computed property equal);
   rounding is kept only within 0.5 px measured; where clean and exact conflict, exact stays and the notes say why.
   A reviewer's question for this job: "would a Bricks pro find each value where they would look for it, and does
   changing it there change the page?"

## Overlaps and order

| Job | What this plan assumes from it | Shared files |
|---|---|---|
| site-no-div | every box a Block, words Rich Text, natives by shape; nothing of it changes | `src/core/site/convert.ts`, `test/browser/render.ts` |
| site-shared-styles | one place writes a class (`class-source.ts` `fromStates`); looks split by property (`looks.ts`); `inked` links colours; `test/web/lib/style-equal.ts`, the computed-style oracle | `class-source.ts`, `looks.ts`, `share.ts`, `colours.ts`, `convert.ts`, `parts.ts` |
| importer-parity | `controls-more.ts` (`MORE_RULES`, `moreGroups`, `hoverOk`, `hoverKeys`, `anotherWrites`, `POSITION`: as built at `1f407006`), `control-values.ts`, `ControlOptions.more`, `hover`, `onlyHover` and `Split.hovered` (`controls.ts:85-116` there), the keep lists K1–K4, the renderer printing Border and Box shadow as `assets.php` does, the notes' `Settings:` line, `test/unit/lib/site-pins.ts` | `controls.ts`, `controls-more.ts`, `convert.ts`, `states.ts`, `test/browser/render.ts`, `tools/lib/site-write.ts` |
| shared-palette | a colour's one name per site (`model/shared-colour.ts`), `--colours` | `colours.ts`, `tools/site.ts`, `tools/lib/site-write.ts` |
| plugin-parity | `emit/looks.ts` (`TAKES`), `ConvertOptions.asBefore`, `Scene.capture`, `test/fixtures/drawn.ts`, `tools/lib/styles-text.ts` | `src/core/emit/settings.ts`, `emit/elements.ts`, `emit/looks.ts`, `style/types.ts`, `convert.ts` |
| bricks-icons (merged) | an Icon's box rules stay weightless Custom CSS | `style/icon.ts`, `emit/settings.ts` |

Order: all five merge first. This job's first task re-measures on that base; if importer-parity's section E landed
differently from its plan (a key, a keep list, the hover option), the builder writes the difference in the ledger and
follows the code, not this table. The class-name job (short site prefix) is independent: no name is made here.
The prototype's own Border, Position, Overflow and Flex rules (`<P>/proto/controls.diff`) duplicate importer-parity's
and are **not** built; they are in the prototype only so its numbers and drawings include them.

## Acceptance criteria (all **proposed**)

- AC1 (proposed): Given a class's declarations, each property of table S is its Bricks setting with the key and shape of his samples when its values fit (a length as `calc()`, `clamp()`, `min()`, `max()` or `var()` in the size, spacing, offset and typography settings; the transition longhands as one Transition text; font style and text decoration in Typography; aspect ratio, visibility, isolation, pointer events, grid columns; a translate and scale as Transform), and the whole property stays custom CSS when one value doesn't fit, when it changes off Bricks' breakpoints, when a state changes it, or (a grid key) on an element that isn't a layout element. Test `test/unit/site-clean-controls.test.ts` "each new property is its Bricks setting with the sample's key and shape, and stays custom CSS when a value doesn't fit".
- AC2 (proposed): Given a class whose background is one linear gradient (an angle, a side word or none; stops with one position or none), its paste holds the Gradient setting with those colours as palette links and no `background-image` line, and a picture's position, repeat, attachment and size sit in its Background setting when the picture is a setting; given two layers, a gradient over a picture, a radial gradient, a conic gradient, a repeating gradient, a `none` at one width or a hover that changes it, the whole group stays custom CSS and the notes name the reason. Test `test/unit/site-clean-gradient.test.ts` "one linear gradient is the Gradient setting; layers, a gradient over a picture, radial, conic and repeating gradients stay custom CSS with the reason in the notes".
- AC3 (proposed): Given an element whose own hover, focus and active looks change properties that are settings, each fitting declaration is that state's key, written in the site's rule order, and leaves the class's state rule; a declaration that doesn't fit stays in the rule; a property that a focus-visible or focus-within look, a look on a part or another element's state changes stays custom CSS whole, under either name of a side. Test `test/unit/site-clean-states.test.ts` "an element's own hover, focus and active looks are Bricks' state keys in the site's order; every other state keeps the property custom CSS".
- AC4 (proposed): Given a left-to-right element, a logical padding or margin side is the physical side's setting, and for T2's fourteen properties and T3's transition and shadow a keyword that is all the property says is left out and one a narrower width takes back is written as the value it means; a right-to-left or vertical element, a class holding both names of a side, an inherited property's keyword and a property a state changes are written as before. Test `test/unit/site-clean-tidy.test.ts` "a logical side is its physical setting on a left-to-right element and a keyword that says nothing is dropped; every other case is written as before".
- AC5 (proposed): Given any length formula, its simplified text gives the written one's value for every unit size tried (each rule of M has a case; the importer's and the plugin's own formulas are cases), px noise is tidied to two decimals only when asked, and text the reader can't read whole, a lone `var()` in a sum included, comes back exactly as written. Test `test/unit/css-math.test.ts` "a simplified formula gives the same value as the written one for every unit value tried, and a formula it can't read is left as written".
- AC6 (proposed): Given a payload holding Gradient, Transform, Transition, Aspect ratio, Visibility, Isolation, Pointer events, a Background position and the hover, focus and active keys, the test renderer prints for each what Bricks 2.2's `assets.php` prints (the gradient's angle and stops, a transform's parts in key order, a state's rule after the normal one in key order), and `unknownSettingKeys` lists none of them. Test `test/unit/render-clean-keys.test.ts` "the renderer prints Gradient, Transform, Transition, the text settings and the three state keys as Bricks' assets.php does".
- AC7 (proposed): Given the fixture sites `clean-values` (new), `parity-controls`, `shared-looks`, `plain-natives`, `elementor-natives`, `site-menu`, `elementor-faq` and `elementor-slider`, each captured and converted with `clean: false` and with the settings on and no rounding, both routes, drawn with Bricks 2.4.2 and with 2.3.9 at every width the capture read: every computed property of every element, its `::before` and `::after` and its box are equal, and a hovered, a focused and a pressed button of `clean-values` each draw as with the switch off. Test `test/web/site-clean-settings.test.ts` "with the settings on and no rounding every element of every fixture site draws as before at every width, hovered, focused and pressed too".
- AC8 (proposed): Given every code fixture and this job's fixtures, both routes and both text modes: no property a class holds as a setting is written for that element by the class's own custom CSS or by another class it carries at any width, and what stays in a class's own custom CSS is refused again when the rules are run on it a second time (nothing that fits a setting is left). Test `test/unit/site-clean-one-writer.test.ts` "a property that is a setting is written nowhere else for its element, and nothing that fits a setting stays custom CSS".
- AC9 (proposed): Given a rounding map, the paste differs from the exact one only where V1 finds exactly a listed px value as a whole size (a setting's value, a side, a custom CSS declaration); a listed value inside a formula, a shadow, a transform or a gradient, a letter spacing, a border width, a value under 4 px, a percentage, an `em`, a plain number and every unlisted value are untouched; an empty map or none gives the exact paste byte for byte. Test `test/unit/site-clean-round.test.ts` "a rounding map changes exactly the px sizes it lists and nothing else of the paste".
- AC10 (proposed): Given the fixture site `clean-values` (a 7.6px padding that moves nothing, a 17.6px font size whose line moves, twelve stacked boxes of 0.3px each that pass alone and fail together), `site:import` on the local stand-in WordPress writes `clean.json` with the first rounded, the second kept exact with its move and place, as many of the twelve as stay within 0.5 px together, and `worst` at most 0.5; the pastes' boxes drawn at every width differ from the exact pastes' by at most 0.5 px; `npm run site … --clean <that file>` writes the same pastes byte for byte with no Chrome; `--no-round` and a missing Chrome round nothing and say so in one note. Test `test/web/site-clean-values.test.ts` "a fraction rounds only where no box moves more than half a pixel at any width, alone and together, and the notes name each value kept exact".
- AC11 (proposed): Given B-Dry's saved 2026-10-29 home served on 127.0.0.1 (never the live site; the base's stand-in capture), with the Elementor step and without it, settings and rounding on: every box is within 0.5 px of the `clean: false` paste's at one width per range (Bricks 2.4.2 and 2.3.9), every computed property is equal except the rounded sizes' own and a simplified formula's own text, no `site:check` row is worse than the base's by more than 0.5 px, and the pastes hold at least 20% fewer custom CSS declarations than with `clean: false`. Test `test/web/site-clean-bdry.test.ts` "B-Dry's stand-in keeps every box within half a pixel with the settings and the rounding on, and its custom CSS shrinks".
- AC12 (proposed): Given `npm run site`, each part's notes hold, after the earlier jobs' lines, `Clean settings: …`, `Values: …` (when a `clean.json` is used) and `Custom CSS that stays: …` with the kinds the paste holds, and the out folder holds `sizes.txt`; with `--no-clean` none of the three lines and no `sizes.txt`. Test `test/web/site-cli.test.ts` "site writes the clean settings, values and staying custom CSS lines and sizes.txt, and none of them with --no-clean".
- AC13 (proposed): Given a Figma design, a layer's pointer events, aspect ratio, isolation, visibility, a link's text decoration and a layer painted with one linear gradient are Bricks settings on the element or its look class at the design width and at each tier a rule writes them; several paints, a radial paint, a part's rules and a look that follows another element stay custom CSS; and no `css` string of any element's or class's own style names a property that has a typed field. Test `test/unit/emit-clean-settings.test.ts` "pointer events, aspect ratio, isolation, visibility, text decoration and one linear gradient are Bricks settings, and no custom CSS of the element names a property that has a setting".
- AC14 (proposed): Given the five real files and every zero-argument fixture, every length the plugin writes in a setting is already its simplest form (`cleanLen` of it is itself), no px number in one has more than two decimals, and each changed formula gives its old value for every unit size tried. Test `test/unit/emit-clean-values.test.ts` "every formula in a paste is its simplest form with the old value, and no px number has more than two decimals".
- AC15 (proposed): Given the five real files, both picture modes, and the fixtures `landingPage`, `clean` (new: a gradient box, a hidden layer, a see-through overlay, a kept-ratio picture) and `pairPage`, converted with `asBefore: { clean: true }` and without, drawn with Bricks 2.3.9's front-end CSS at the design width, 1200, 1024, 991, 768, 478 and 390: every element's box is within 0.01 px and every computed property is equal, a painted gradient's `background-position` and `background-repeat` aside where its picture is pixel for pixel the same. Test `test/browser/clean-values-figma.test.ts` "every Figma design draws as before with the settings and clean values on".
- AC16 (proposed): Given the switch off (`clean: false` in the importer and `--no-clean` in `site`, `site:check` and `site:live`, `asBefore.clean` in the plugin), every paste of every code fixture and of the five real files, and what `site:check` writes for the code fixtures, is byte-identical to the base's; and with it on, a paste the rules find nothing to change in (one fixture of each tool), the Figma panel's website route, a website capture converted by the plugin, `capture` and `capture:check` write what the base writes. Test `test/unit/clean-values-off.test.ts` "with clean values off every paste of both tools is byte for byte as before" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC17 (proposed) (live): Justin scans bdryswi.com again with the new build (`npm run site:import -- … --elementor`), imports `palette.json`, empties B-Dry staging `/homev2/` and pastes header, page and footer: the page looks as before at 1440 and at 390; clicking a hero button and its class shows Background → Color filled and, with Bricks' state menu on `:hover`, the hover colour; changing that hover colour and saving changes the button on the live page; the blue band's class shows Style → Gradient with its colours; `notes.txt` lists the sizes rounded and those kept exact. In Figma (darksalmon): he converts a design holding a gradient box with Pictures to WordPress, pastes it, the box shows Style → Gradient with its colours, and changing one colour there changes the page.

Each cited test fails on the base for its criterion's reason (the first and fourth: proven, `<P>/red-green.txt`: 2 of 2
fail on the shared-palette head with assertion diffs, 2 of 2 pass on the prototype; the fifth passes on the prototype
module; the others are written first by the builder, each RED recorded in the ledger).

## Architecture

Pure, built-ins only, in `src/core` (`npm run typecheck` runs `tsconfig.sandbox.json`); the measuring is in `tools/`.

**Shared by both tools** (the isolation test's allow-list gains exactly these, each with a test like `editor-text`'s
of what it imports):
- `src/core/model/css-math.ts` (new, imports nothing): `Expr`, `parse`, `simplify`, `tidy`, `print`, `evaluate`,
  `cleanLen(text, digits?)`. From `<P>/proto/css-math.ts` (its `cleanMath` renamed; `cleanLen` also tidies a lone px
  number when digits are given).
- `src/core/emit/gradient-shape.ts` (new, imports `./ids.ts` only): `gradientSetting(key: string, angle: number |
  undefined, stops: Array<{ color: unknown; stop?: string }>): Settings`.
- `src/shared/breakpoints.ts`: `State = "hover" | "focus" | "active"`; `settingKey` and `parseSettingKey` take the
  three (the regex at L53 reads `(hover|focus|active)`).

**Importer** (`src/core/site/`, each file ≤ 250 lines):
- `controls-clean.ts` (new): `CLEAN_RULES` (table S), `lengthish`, the groups `transitionOf`, `decorationOf`,
  `transformOf`, `backgroundOf`, and the state keys for focus and active; `controls.ts` `controlsFor` calls it when
  `ControlOptions.clean` is set, after importer-parity's `controls-more.ts` and with its keep lists. Prototype:
  `<P>/proto/controls.proto.ts` (`MORE`, `lengthish`, the transition group; without its `globalThis` switch, its
  counters, and its Border, Position, Overflow, Flex and Shadow rules, which are importer-parity's).
- `gradient.ts` (new): `linearGradient(value: string): { angle?: number; stops: Array<{ color: string; stop?: string
  }> } | { why: string }` over `value.ts` `parse` (never a regex over the CSS text).
- `tidy.ts` (new): `tidyStates(states: CodeDecls[], ctx: { ltr: boolean; keep: ReadonlySet<string> }): { states:
  CodeDecls[]; dropped: number; renamed: number }` (T1–T3; prototype: `tidy` in `<P>/proto/controls.proto.ts`, moved
  from the blocks to the per-range states); `leftToRight(code, path): boolean`.
- `round.ts` (new): `roundCandidates(parts): Map<string, { to: string; uses: number }>` (V1) and `roundedValue(prop,
  toks, map)` used by `convert.ts` `rewrite` (V2).
- `convert.ts`: `ConvertOptions.clean?: false | { settings?: false; rounded?: Record<string, string> }`; `rewrite`
  passes a size value through `cleanLen` and `roundedValue`; the states go through `tidyStates` before
  `candidatesOf` and `fromStates`; the notes' two lines. `class-source.ts` `fromStates`: the gradient and background
  group beside media-clickable's step. `states.ts` `looksOf`: `keep` no longer holds what a hover, focus or active
  look changes when that declaration became a key (the returned `self` loses it).
- `parts.ts`: the `Custom CSS that stays` line (counts from the classes as written), `sizes` for `sizes.txt`.

**Importer tools:**
- `tools/lib/site-clean.ts` (new, ≤ 200 lines): `measureClean(capture, opts, chrome): Promise<CleanFile>` (V3; from
  `<P>/round-probe.ts`, with the style-swap instead of a reload), `readClean(file)`, `CleanFile`.
- `tools/lib/site-write.ts`: `writePastes(…, { clean })` writes `clean.json` and `sizes.txt`; `tools/site.ts`:
  `--clean <file>`, `--round`, `--no-clean`; `tools/site-upload.ts`, `tools/site-import.ts`: measure unless
  `--no-round` or `--no-clean`, after the media map is known; the usage lines and the next steps name `clean.json`;
  `tools/site-check.ts`, `tools/site-live.ts`: `--clean <file>`, `--no-clean` (read only as before: nothing else of
  either changes).

**Plugin:**
- `src/core/style/types.ts`: the fields of P1; `merge` treats them as plain values; `Gradient` type.
- The producers of P1 (the list under "What is true today"), `style/paint.ts` (P3), `emit/settings.ts` (P2, M),
  `emit/css.ts` (`cssDecls`), `emit/looks.ts` (nothing to add: `background` and its `gradient` ride in `TAKES`),
  `adapt/rules/index.ts` rules' `overrides` where P4 needs one.
- `src/core/convert.ts`: `ConvertOptions.asBefore.clean?: true` (off: the producers push strings as today, emit
  writes lengths as given), off for `scene.capture`.

**Renderer:** `test/browser/render-controls.ts` (new: `render.ts` is 455 lines; the `decls` function and `SIMPLE`
move there unchanged first, one commit, the unit pins green): Gradient (`assets.php` L2436-2545, background only),
Transform (L2702-2735, every part), Transition, Aspect ratio, Visibility, Isolation, Pointer events as text; state
blocks in key order for the three states (`render.ts` `settingsCss` loops `[null, "hover"]` today).

## Touched files

New: `src/core/model/css-math.ts`, `src/core/emit/gradient-shape.ts`, `src/core/site/controls-clean.ts`,
`gradient.ts`, `tidy.ts`, `round.ts`, `tools/lib/site-clean.ts`, `test/browser/render-controls.ts`;
`test/fixtures/site-clean-code.ts`, `test/fixtures/clean.ts`, `test/fixtures/web/sites/clean-values/` (`index.html`,
`style.css`); the fifteen test files the criteria name (`site-cli.test.ts` gains one test); `test/fixtures/
clean-values-pins.json` (the story pin's sums).
Changed: `src/shared/breakpoints.ts`, `src/core/site/controls.ts`, `convert.ts`, `class-source.ts`, `states.ts`,
`parts.ts`, `src/core/style/types.ts` and the producers of P1, `style/paint.ts`, `src/core/emit/settings.ts`,
`css.ts`, `src/core/convert.ts`, `tools/site.ts`, `site-upload.ts`, `site-import.ts`, `site-check.ts`, `site-live.ts`,
`tools/lib/site-write.ts`,
`test/browser/render.ts`, `test/unit/site-isolation.test.ts` (the allow-list), `reference/bricks/README.md`,
`docs/HANDOFF.md`, the plan copy and ledger.
Not touched: `src/ui/**`, `src/plugin/**`, `src/web/**` (the capture), `tools/capture*.ts`, `tools/lib/read-only.ts`,
`src/core/understand/**`, `src/core/normalise/**`, `reference/bricks/*.json`, `BUILD`.

## Tests that pin today's output (the builder may edit these, and only as said)

With the prototype's importer rules on by default, 25 of the 3,818 unit tests of the shared-palette head fail, in 18
files, and no other (`<P>/unit-sp.tap`: 3,752 pass, 0 fail, 66 skipped; `<P>/unit-proto-def.tap`;
`<P>/unit-proto-def-fails.txt` names each). The real base holds more pins (site-no-div's, importer-parity's); the
builder runs the unit, browser, web and performance suites on its base in Task 1, keeps the tallies by test name, and
applies only these edits, naming each file in the ledger; any other new failure is a stop (name the assertion, never
weaken it):

| The failing assertion | The one edit allowed |
|---|---|
| expects a value in the class's custom CSS that is now a setting, or pins "function values stay custom CSS" (`site-css.test.ts`, `site-text-controls.test.ts`, `site-p-box.test.ts`, `site-elementor-*.test.ts`, `site-opens*.test.ts`, `site-motion*.test.ts`, `site-*-looks.test.ts`, `site-colours.test.ts`, `site-palette.test.ts`, `shared-colour.test.ts`) | read the same value from the setting (the class's settings and custom CSS together); a test whose title says the old rule gets the new rule's title and both sides of it |
| lists the setting keys the renderer can't draw (`render.test.ts` "settings the renderer can't draw are listed…") | the keys this job draws leave the list |
| compares with a golden or a sum of the default suite (`site-slider-base/`, `site-motion-base/`, `site-no-revert-main.json` through `node tools/site-no-revert-golden.ts .`, `site-basic-golden.json`, the earlier jobs' pins the default suite runs) | made again through its own generator **only after** the sixteenth criterion's pin is green on that commit, reason "clean values" |
| a plugin golden (`test/golden/files/convert-sample.json`, `cta-names-base.json`) or a test reading `style.css` for a property that is now a typed field | the golden regenerated after the pin is green; the test reads the typed field or `_aspectRatio` … in the settings |
| an earlier job's pin of `src` files or of a tool's output that the default suite runs (`media-avif-untouched`, `site-import-figma-unchanged`, `site-scroll-lock-base`, `site-ticks-base`, `panel-embed-unchanged`, `site-figma-unchanged`, `site-elementor-unchanged`, `site-native-unchanged`, `site-media-unchanged`, `site-upload-panel-unchanged`, `shared-colour-base`) | re-pinned for this job's files, test-only, in the task that changes them, as the merges before did (bricks-icons `37687fcb`); the ledger names each sum and why |

Story pins of merged jobs (env-gated, named-only) are not regenerated.

## Tasks (test-first; commit after each passing task, files by name; never commit CLAUDE.md)

Rules for the build: the copy's `npm run check` green after each task; `git diff --cached --name-only` before every
commit; no `BUILD` bump; no bare `git stash`; browser and web gates through the desktop's Chrome wrapper
(`CHROME_PATH`, a short `TMPDIR`), one Chrome job at a time, compared by test name with the base. No live site, no
login, nothing sent anywhere: `site:import` and `site:upload` run only against `test/fixtures/wp-standin.ts`.

### Milestone 0: the base's facts

1. Copy this plan to `docs/plans/2026-11-13-clean-values.md`; start the ledger; record the base's head, the five
   merged jobs' commits, and where importer-parity's section E differs from this plan's table of assumptions.
2. Run the four suites on the base, tallies by name in the ledger. Run `<P>/measure-site.ts` and
   `<P>/measure-plugin.ts` (they take the tree's path) on the base for his scan (the read-only copy
   `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`), the stand-in
   and the five real files: the "before" of the Docs task.
3. The story pin (the sixteenth criterion's test, named-only): sums of every code fixture's pastes and the five real
   files' payloads on the base, both picture modes, written to `test/fixtures/clean-values-pins.json`.

### Milestone 1: formulas (both tools; nothing depends on anything else)

4. `src/core/model/css-math.ts` and its test (the fifth criterion) from `<P>/proto/css-math.ts` and
   `<P>/proto/css-math.test.ts`; the isolation allow-list and its import test.
5. Plugin: `emit/settings.ts` writes lengths through `cleanLen(text, 2)`; the fourteenth criterion's test first (RED:
   the five files hold formulas that aren't their simplest form). Geometry: the fifteenth criterion's test with only
   this change on (boxes within 0.01 px). Goldens after the pin.
6. Importer: `rewrite` passes size values through `cleanLen`; a unit test beside `site-css.test.ts` ("a site's
   formula is written in its simplest form, a table part's as written"); the seventh criterion's test started with
   this change alone on `elementor-natives`.

### Milestone 2: the importer's settings

7. The renderer first (the sixth criterion): `render-controls.ts` split, then each new key printed as `assets.php`
   does, state blocks in key order; `settingKey`/`parseSettingKey` take the three states.
8. `controls-clean.ts`: table S without the background rows (the first criterion; RED/GREEN as `<P>/red-green.txt`).
9. `tidy.ts` and its place in `convert.ts` (the fourth criterion).
10. `gradient.ts`, `emit/gradient-shape.ts`, the gradient and background group in `class-source.ts` (the second
    criterion), the notes' reasons.
11. States (the third criterion): focus and active keys, the site's order, `looksOf`'s `keep`.
12. The one-writer test over every fixture (the eighth criterion); the fixture site `clean-values` captured; the
    seventh criterion's test over all eight sites, both Bricks versions, both routes. A difference is a stop: find
    the other writer (a keep list is missing a property) or the setting's print, never widen the oracle. The test
    reads a page only once no animation is running on it (an entrance caught mid-play shows as `animation-name`
    differing in opposite directions at two widths: the planner's final run); it never leaves a property out.

### Milestone 3: the importer's values

13. `round.ts` and `ConvertOptions.clean.rounded` (the ninth criterion).
14. `tools/lib/site-clean.ts`, `clean.json`, the flags in `site`, `site:upload`, `site:import` (the tenth
    criterion); the notes and `sizes.txt` (the twelfth).
15. The stand-in's whole proof (the eleventh criterion).

### Milestone 4: the plugin's settings

16. `style/types.ts` fields, `emit/settings.ts` keys, `emit/css.ts` (the thirteenth criterion's test first, RED on
    the five files).
17. The producers, one commit per file group (pictures and art; hotspots and states; the adapt rules), each with
    `npm run check` green and the engine's collisions empty (P4: an `overrides` entry per real pair, named in the
    ledger).
18. `style/paint.ts` P3 and the gradient through `emit/gradient-shape.ts`.
19. The fifteenth criterion's test over the five files and the fixtures; `npm run corpus` no worse (on the desktop:
    the two repo files replayed and snapped directly, the corpus paths don't resolve there).

### Close

20. The sixteenth criterion's pin green with the switch off; goldens and sums regenerated; the base's and the head's
    suites compared by name.
21. Mutants (`mutation-testing-discipline`, each under `systemd-run --user --scope -p MemoryMax=4G -p
    MemorySwapMax=0`): a keep list ignored, the half-pixel guard at 5 px, a rounding inside a formula, T2 on an
    inherited property, a state key written in a fixed order, `simplify` dropping a non-zero term. Each killed by a
    named test.
22. Docs & records (below). `npm run check`, `npm run corpus`, the browser and web suites by name. Stop at
    `ready-for-review` with the head, the gates and the counts.

## Docs & records

- `docs/HANDOFF.md`: one section "Clean values" (newest first): the rules S, G, H, T, M, V, P in plain words, the
  ⭐ rulings not yet confirmed (all twelve), the counts before and after on his scan, the stand-in and the five files
  (Custom CSS declarations and lines, distinct size values, the worst move in px), what stays Custom CSS by kind,
  the next free paste check id (3ei is the newest on main today; the live criterion's steps, one action each), the follow-ups (`site-breakpoint-fit`,
  variables, radial gradients, measuring in the panel, a part's rules as Bricks' class selectors).
- `docs/plans/2026-11-13-clean-values-ledger.md`: every task's RED and GREEN, the gates, the mutants.
- `reference/bricks/README.md`: "Gradient", "State keys" (the three defaults, the print order), "Transform",
  "Number and text settings take a formula as given", each with the `assets.php`/`base.php`/`database.php` lines
  read (`<P>/bricks-2.2/`, sums in its `SHA256SUMS`) and the 2.4.2 builder lines (`<P>/builder-2.4.2-keys.txt`).
- CLAUDE.md (the finisher; else `~/.hermes/plans/figma-to-bricks/clean-values-claude-md-pending.md`): the build
  line; standing rules: "A length formula is written through `src/core/model/css-math.ts` by both tools"; "A website
  paste rounds a px size only from a measured `clean.json` (0.5 px per box per width); the plugin rounds only number
  noise"; "A declaration with a typed `Style` field is never pushed as a `css` string"; under "Decisions": the
  twelve rulings, each "not yet confirmed".
- `skill_lessons[]` in the builder's report (never edits a skill or memory itself).

## Risks and open points

- **Another writer of a property the builder doesn't know of.** A setting out-weighs it silently. Guard: the seventh
  criterion draws every fixture site with every computed property compared, hovered, focused and pressed too; the
  eighth is the static form. The prototype met three such writers and each showed in the drawing at once.
- **Bricks 2.4.2 against the 2.2 source.** The keys match in B-Dry staging's own builder script; the print is modelled
  from 2.2. The live criterion is the judge; a difference found there is a fix job, the keys' shapes aside.
- **The state list of a site.** `:focus` and `:active` print only while the site's list holds them (the default).
- **`calc(100% - 0px)` → `100%`** changes the value's kind; a table part lays the two out differently. Guard: table
  parts are left as written; the drawings compare boxes.
- **The guard's cost.** One draw per fraction per part; his scan holds few fractions (the probe's list). If a site
  held hundreds, the tool measures the 40 most used and keeps the rest exact, saying so (a cap named in the notes).
- **Two machines, two Chromes.** A rounding near 0.5 px can pass on one and fail on the other; `clean.json` is the
  record, and the pastes are remade from it, not measured again.
- **The plugin's typed fields change rule collisions** (P4). A collision the order doesn't explain stops the task.
- **Not prototyped:** the plugin's typed fields and paint (counted from the pastes), the gradient, background and
  state keys of the importer (counted), the style-swap in the guard (the probe reloads), the hover, focus and pressed
  drawings.
- **Radial gradients** (16 on the five files) would fit Bricks' keys (`radialSize`, `radialCustomPosition`), but no
  sample shows what the builder's fields accept: left for his own sample.

## Completion and reporting

The builder stops at `ready-for-review` and reports: head, the four suites by name against the base, the counts
table (before → after: Custom CSS declarations and lines, distinct size values, worst move), the pins regenerated and
why, every stop it hit, `skill_lessons[]`. Reviewers, the verifier and the auditor return `verdict` and `ac_status`
and ask of every changed paste: "would a Bricks pro find this value where they would look, and does changing it
there change the page?". The live criterion is owed to Justin after the merge (its paste check id from HANDOFF).
