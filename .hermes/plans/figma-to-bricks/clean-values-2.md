# clean-values-2: what a person clicks shows in Bricks' own controls, in both tools (plan, 2026-11-16)

- **Pipeline:** Full. **Tools:** the website importer and the Figma plugin. **Planner:** Fable 5.2 high.
- **Base to build on:** tier-spacing's head `2abf11969eed5a7831d2e7acb782a11841c67a2e` (a direct descendant of main
  `2c570217`, Build 2026-11-16.8). If tier-spacing has merged, branch from main; if not, the builder's copy starts from
  that head. Every number below was measured on that head and on main.
- **Replaces** the paused plan `~/.hermes/plans/figma-to-bricks/clean-values.md` (2026-11-13, base 7f54b0a5). What it
  proved and still holds is reused here (the rules S, T, H, G, M, P); its measured rounding (rule V, `clean.json`) is
  left to a later job (question 2).
- **Evidence:** `~/.hermes/plans/figma-to-bricks/evidence/clean-values-2/planner/` (`README.txt` lists every file).
- The project's copy of this plan goes to `docs/plans/2026-11-16-clean-values-2.md` in the builder's Task 0.

## Playback

Justin, 2026-11-16: "A job so that font sizes, padding, all element characteristics are inserted into Bricks and not
only CSS", then: "I want it to focus on when someone clicks an element in Bricks, it actually shows the number like
someone typed it into the Bricks controls on the left, and not the CSS."

So: click any element, or one of its classes, in the Bricks editor → Style tab → Typography, Layout, Background,
Border, Box shadow, Transform, Transition show the values that element draws, at the Desktop, Tablet, Phone sideways
and Phone tabs and under Bricks' state menu (hover, focus, active), as a person would have typed them. Custom CSS
keeps only what Bricks has no control for, and the paste's notes name it. Nothing moves: every element draws as
before (within 0.5 px, Bricks 2.4.2 and 2.3.9), and the exact value wins over a round one.

## Questions (⭐ = the answer taken under the standing auto-go; one word from Justin changes it)

1. **The Figma plugin's Buttons (his decision, no answer taken).** On 2026-11-15 he ruled "Class Custom CSS": a
   Button look class keeps its font, colours, background, border, corners, shadow and padding in its own Custom CSS at
   `html:root .<class>.brxe-button.bricks-button`, so a Theme Style can't repaint it. That is exactly what he now
   asks not to see: click a Button's class today and Typography, Padding, Background, Border and Box shadow are empty
   (76 Buttons on the five real files). The two can't both hold as built. **A:** leave it (the Button stays the one
   named leftover on a Figma paste). **B (the planner's recommendation):** the numbers go in the class's own
   controls and the Button's Style is left empty instead of Primary, so a Theme Style's Primary rules never match it
   (its plain-button rule is weaker than a class's controls); built only if the drawn proof against the hostile Theme
   Style passes on both Bricks versions. **C:** the numbers in the controls and Style: Primary kept; a Theme Style
   that styles Primary buttons would then repaint them. **Milestone 5 (the plugin's Buttons) is built only on his
   word; everything else doesn't wait for it.** The importer's Buttons already hold their numbers in controls.
2. **Round numbers (18, not 17.6).** ⭐ **A:** this job puts every value in its control exactly as the page draws
   it and only tidies what changes nothing (a formula that is one length, a `0px` term, float noise under 0.01 px
   such as `25.999923706054688px` → `26px`). Rounding a real value (17.6 → 18) moves things unless a browser measures
   it at import; it is its own job (`clean-round`, the old plan's rule V), after this one. **B:** build the measured
   rounding here too (about a third more work; the old probe found only 16 values on B-Dry's home that could round).
3. **Fluid sizes in the plugin's Desktop tab.** A Figma paste's Desktop tab holds `clamp(138px, calc(43.65px +
   9.511vw), 208px)` where the design says 208 (1,191 such formulas on the five files, 100 longer than 60
   characters). ⭐ **A:** the formula stays in the control (one value a Bricks builder can edit; the design's number is
   its last term), each machine-long formula is written in its shortest equal form, and the notes say how to read it.
   **B:** the Desktop tab holds the design's plain number and the fluid part moves to a band in Custom CSS between the
   Tablet breakpoint and the design width (as tier-spacing does for the importer): the tabs show only numbers, but a
   number typed in Desktop then doesn't reach laptops until the band is edited too.
4. **Font family on a scanned site.** On his B-Dry pastes the family is in Custom CSS under the page's name
   (`"home__Roboto"`, 297 elements), because the importer app's Fonts option wasn't ticked. ⭐ **A:** unchanged: with
   Fonts ticked (`--fonts`, site-fonts-import) Typography → Font family shows the plain family; the notes' leftover
   line says so. **B:** tick it by default (every import then needs the Custom Fonts step first).
5. **White space, text wrap and variable-font axes.** Bricks 2.4.2's Typography has these fields (read from B-Dry
   staging's builder script); darksalmon runs 2.3.9, where they are unproven, and a value a field doesn't show is worse
   than Custom CSS. ⭐ **A:** they stay Custom CSS in both tools, named, until his own copy of a 2.3.9 Typography
   setting holding them exists. **B:** use the fields on the importer only (B-Dry staging is 2.4.2).
6. **Hover, focus and pressed looks.** ⭐ **A:** an element's own `:hover`, `:focus` and `:active` looks go in Bricks'
   state settings where the property's normal value is a setting (colour, background colour, border colour, shadow,
   opacity, text decoration, transform); `:focus-visible`, `:focus-within`, a look on a part or one that follows
   another element stay Custom CSS. **B:** hover only (as today).
7. **Words that say nothing.** B-Dry's classes carry about 2,000 lines such as `order: unset`, `flex-basis: unset`,
   `transition: unset`. ⭐ **A:** left out where the keyword is all the property ever says for that element (the
   page's reset already gives it); written as the value it means where a narrower width sets a real one. **B:** keep.
8. **A switch.** ⭐ **A:** on for every paste of both tools; `ConvertOptions.clean: false` (importer) and
   `asBefore.clean` (plugin) are test and diagnosis switches only, byte for byte the pastes before this job; no
   command flag and no panel option. A page pasted before this job gets its changed classes as new classes on a
   re-paste (their names end in a hash of their settings).

## What was measured (step 1; `census.ts`, files `census-*.txt`)

A "click" below is one element × one property a person looks for: where does the value the element draws at Desktop
sit, counting the element's own settings and every class it carries. "Control share" = control / (control + CSS).

### Importer: his five B-Dry scans as the app makes them (`--elementor --media`), 836 elements, 724 classes

| | main 2c570217 | tier-spacing head (today's base) | the prototype of this plan |
|---|---|---|---|
| Custom CSS declarations | 13,380 | 11,952 | 8,193 |
| … of them on the element's own selector, for a property Bricks has a control for | 7,023 | 5,592 | 1,833 |
| … own selector, no Bricks control (box-sizing, outline, vertical-align…) | 2,396 | 2,396 | 2,396 |
| … on a child selector / on ::before, ::after / @keyframes, @font-face | 2,335 / 1,551 / 78 | same | same |
| clicks answered by a control / by Custom CSS | 5,801 / 2,568 | 6,512 / 1,885 | 7,623 / 999 |
| control share | 69% | 77% | 88% |
| tab values in a control / in an `@media` rule at a Bricks breakpoint | — | 543 / 323 | 775 / 101 |
| state looks in a control / in a `:hover`, `:focus` rule | 0 / 168 | 0 / 168 | 0 / 168 (not prototyped) |

By tab on the base (control / CSS / share): Typography 1,342 / 706 / 66%; Layout 4,543 / 596 / 88%; Background 205 /
59 / 78%; Gradient 0 / 17; Border 416 / 64 / 87%; Transform 0 / 33; Transition 0 / 410; Image 6 / 0.
With the prototype: Typography 1,551 / 497 / 76%; Layout 5,012 / 401 / 93%; Background 237 / 27 / 90%; Border 416 / 15
/ 97%; Transition 401 / 9 / 98%; Gradient and Transform unchanged (not prototyped).

Per property on the base (control | CSS): font-size 316|0; font-weight 304|0; line-height 301|0; font-family 0|297;
colour 256|21; text-align 94|73; text-shadow 0|80; font-style 0|68; letter-spacing 1|61; white-space 0|56;
text-decoration 0|50; margin 462|16; padding 441|12; display 346|92; position 366|65; width 327|22; height 327|22;
max-width 191|94; gap 225|1; justify-content 90|45; align-items 96|26; z-index 81|21; visibility 0|56; flex-wrap
26|0 (140 more in tablet/phone rules); pointer-events 0|18; grid columns/rows/flow 0|39; aspect-ratio 0|14;
background-color 111|42; background-position/repeat 0|17; gradient 0|17; border 168|13; radius 225|0; box-shadow
23|51; transform 0|30; transition 0|410.

### Plugin: the five real files, pictures to WordPress, 3,453 elements, 341 classes (main and the base agree)

Custom CSS 3,194 declarations (2,069 on the element's own selector for a property with a control). Clicks: control
22,105, CSS 1,055, control share 95% (Typography 98%, Layout 97%, Border 79%, Background 41%, Gradient 0 of 46).
Tab values: 6,540 in controls, 634 in `@media` rules. State looks: 183 in controls, 398 in rules. 1,191 control values
are formulas (question 3). What sits in CSS: the Button look classes (colour, padding, background, border, radius,
shadow: 76 Buttons, question 1); pointer-events 107, isolation 95, visibility 48, `text-decoration: none` 62 (link
Blocks), gradient 46 with its size, position and repeat, gap on non-layout elements 42, aspect-ratio (107 at tiers),
white-space and text-wrap at tiers and bands (question 5), filter 8.

### The prototype draws the same (`cv2-oracle.ts`, `oracle-all-2.4.2.txt`, `oracle-all-2.3.9.txt`)

The prototype (`prototype.diff`: rule T, the transition group X, formulas and other units, font style, letter
spacing, text decoration, transparent, visibility, pointer events, isolation, aspect ratio, the grid keys) against the
base, his five scans as whole pastes on the Elementor route, drawn offline at 38–40 widths each: **89,041 element
readings with Bricks 2.4.2 and 89,041 with 2.3.9, 0 differ** (box within 0.5 px, 70 computed properties of the element,
its ::before and ::after, the transition lists by their meaning). With the prototype's switch off its pastes are the
base's byte for byte. RED/GREEN on the plan's first cases: `site-clean-red.test.ts` fails 3 of 3 on the base
(`red-base.log`) and passes 3 of 3 in the prototype (`green-proto.log`).

## Why a value stays Custom CSS today, and the rule that moves it (steps 1–2)

Importer, declarations once per class | weighted by the elements carrying it (`census-ts-all.txt`):

| Reason today | Count | Top properties | Rule |
|---|---|---|---|
| a keyword that says nothing (`unset`, `initial`, `inherit`, `revert`) | 1,975 \| 2,737 | order, align-self, text-align, flex-basis, flex-wrap, align-content | T |
| the transition longhands (no rule writes Transition) | 1,549 \| 2,035 | transition-* | X |
| Bricks has the control, the importer has no rule for it | 331 \| 377 | font-style, visibility, pointer-events, text-shadow, background-position/repeat, grid keys, aspect-ratio | S |
| the starting value as a word the rule doesn't take | 227 \| 301 | text-align start, letter-spacing normal, box-shadow none, background-color transparent | S, T |
| all or nothing: another width's value doesn't fit the setting | 183 \| 323 | flex-wrap, text-decoration, border, max-width | follows from S, T |
| several values in one | 182 \| 346 | font-family (question 4), text-shadow, aspect-ratio `auto 500 / 191` | S |
| a change at a width Bricks has no breakpoint for | 175 \| 268 | background-image, padding, max-width | tier-spacing's bands, now also for formulas |
| a formula (`min(100%,100%)`, `calc(100% - 0px - 0px)`, `calc(20px)`, `min(100%,767px)`) | 130 \| 149 | max-width 111 | M |
| the element's own `:hover`, `:focus`, `:active` | 100 \| 212 | colour, box-shadow, transform, background-color, text-decoration, border | H |
| a keyword the rule doesn't take (position on a top element, `display: contents`) | 98 \| 186 | position 60 | stays (standing rule), named |
| reduced motion, a condition (`.open`, `:not()`), `:focus-visible`, another element's state | 218 | | stays, named |
| a palette link kept in CSS because a state changes the property | 26 \| 52 | colour, border | H |
| a gradient | 17 | | G |
| a logical name on a line the tier step didn't rename | 19 | padding, margin, border, inset | T |

Plugin (`census-ts-figma-all.txt`): 395 "Bricks has the control, no typed field" (pointer-events 107, isolation 91,
align-content 47, background repeat/size/position 132, filter 8); 113 | 505 the Button look classes; 198 a look that
follows another element's state (stays); 370 white-space at widths between breakpoints (question 5); 118 aspect-ratio
and several shadows; 80 shorthands (gap on a Button, border, radius); 65 `text-decoration: none`; 62 own hover
(transform, shadow); 37 gradients.

## What Bricks' controls hold (facts, each read from Bricks' code)

- **A number, spacing or text setting is written as given**; only a bare number gets `px` (Bricks 2.2 `assets.php`
  L2841–2869; 2.4.2's builder reads `calc|var|clamp|min|max(` as one "function" value: `builder-2.4.2-css-to-settings.txt`).
  So `_widthMax: "min(100%,1140px)"`, `_padding.top: "calc(50% - 10px)"`, `_width: "5rem"` print exactly.
- **Typography prints every sub-key as given** (`assets.php` L2732–2800): `font-style`, `text-decoration`,
  `letter-spacing: normal` are plain fields; `text-shadow` is `{ values: { offsetX, offsetY, blur }, color }`.
- **Style keys of every element** (Bricks 2.2 `base.php`, the GPL source, older than both his versions):
  `_visibility`, `_pointerEvents`, `_isolation`, `_aspectRatio`, `_mixBlendMode`, `_cssTransition` (text →
  `transition: <text>`), `_transform`, `_transformOrigin`, `_cssFilters`, `_gradient`, `_overflow`, `_cursor`, `_order`.
  Grid keys are on the layout elements (`reference/bricks/README.md` "Layout keys by element").
- **States:** a setting key ending `:hover`, `:focus` or `:active` prints `.<class>.brxe-<el>:hover` (0,3,0), above
  every tab setting; 2.4.2's builder lists exactly these three (`ti=new Set([":hover",":focus",":active"])`).
- **Bricks 2.4.2 does this mapping itself** when CSS is pasted into its builder (`builder-2.4.2-css-to-settings.txt`):
  typography (family without `var()`, size, weight, style, line height, letter spacing, align incl. `start`/`end`,
  transform, decoration, colour), spacing incl. the logical names, background colour/image/size/position/repeat/
  attachment, border, and every number/text/select control, under the three states. This job's table S is that table.
- **Where a control can't hold the value:** flex `align-content` (only the grid key exists), `display: contents`,
  several shadows or gradients, a rotation with a fraction of a degree (Transform cuts to whole degrees), a
  `background-image` layer list, `:focus-visible`. `_display: grid` also prints `align-items: initial` (`base.php`
  L658–695), so a grid's `align-items` must be a setting too or stay with its display in CSS.
- **Never** `_alignSelf: stretch`, a bare Flex basis number, layout-only keys on a non-layout element (CLAUDE.md).

## The rules (general: every scanned site, every Figma design)

All importer rules run in the one place declarations become a class (`src/core/site/class-source.ts` `fromStates`,
then `controls.ts` `controlsFor`), so an element's own class, a shared look and a copy's own difference follow them
alike. A property still follows today's conditions: nothing else of the paste writes it (K1–K4), a state doesn't
change it unless rule H takes that state, every value fits, and its changes fall on Bricks' breakpoints or
tier-spacing's plan gives tabs plus bands.

### T. Tidy first (new `src/core/site/tidy.ts`, on the per-range declarations, before the side names and the blocks)

- **T1 keywords that say nothing.** For a property no element inherits and no browser rule sets on the element's tag
  (order, flex-grow, flex-shrink, flex-basis, flex-wrap, flex-direction, align-self, align-items, align-content,
  justify-content, justify-items, justify-self, row-gap, column-gap; and, probed by the planner with 0 of 21,900
  readings differing and 246 more lines gone (`prototype-more.diff`, `oracle-more-*.txt`): width, height, the min/max
  sizes, z-index, the offsets, and `text-align` only ever `unset`/`inherit`; the builder keeps each of these only
  while AC7 and AC9 stay green): where every range says `unset`, `initial` or `revert`, the
  property leaves (the reset's `all: revert` already gives it); where some range says a real value, the keyword is
  written as the value it means (`flex-wrap: unset` → `nowrap`), so the property fits its setting at every tab.
  **Never for a copy's own difference** (`copies.ts`: there the keyword is the copy's value against its class; it is
  written as the value it means) **and never a literal value** (`flex-direction: row` stays a setting: the planner's
  first prototype dropped it and a copy's `_direction: row` went, moving a column: README.txt "The first prototype"). A layout element's `flex-direction` keyword is written `row` (Bricks' own default there is column).
- **T2 never set.** The transition longhands all `unset`/`initial`/`revert` at every range leave together; a
  `box-shadow` only ever `none` or a keyword leaves. `font-style` or `letter-spacing` only ever `inherit` leaves on a
  tag the browser doesn't style for it (not `i`, `em`, `cite`, `var`, `dfn`, `address`).
- **T3 one word.** `text-decoration-line` with the other three longhands absent or `initial` is `text-decoration:
  <line>`. `text-align: start`/`end` is `left`/`right` on an element whose lines run left to right and across
  (tier-spacing's `acrossOf`), where no `direction` is written. `grid-column-gap`, `grid-row-gap` are `column-gap`,
  `row-gap`.
- **T4 a formula that is one length** (rule M): `min(A, A)` → `A`; `calc(A)` → `A`; a `± 0px` term leaves.

### S. A value with a Bricks setting goes in that setting (importer; additions to `RULES`/`MORE_RULES`)

| Property | Setting | Values taken |
|---|---|---|
| every length setting of today (sizes, spacing sides, gaps, font size, line height, letter spacing, offsets, flex basis, radius, border width) | as today | plus `rem`, `vmin`, `vmax`, `ch`, `ex`, `svh`… and one balanced `calc()`, `clamp()`, `min()`, `max()` or `var()` with no `;`, `{`, `}` or `!important` (new `lengthish` in `control-values.ts`) |
| font-style | `_typography["font-style"]` | normal, italic, oblique |
| letter-spacing | `_typography["letter-spacing"]` | a length or `normal` |
| text-decoration (after T3) | `_typography["text-decoration"]` | none, underline, overline, line-through |
| text-shadow | `_typography["text-shadow"]` | one shadow of two or three px lengths and a colour (`none` stays CSS) |
| background-color | `_background.color` | a colour, or `transparent` as `{ raw: "transparent" }` |
| background-position, -repeat, -attachment | `_background.position` (with `positionX/Y` for custom), `.repeat`, `.attachment` | only where the picture itself is the Background → Image setting (media-clickable) |
| visibility | `_visibility` | visible, hidden |
| pointer-events | `_pointerEvents` | none, auto, all, visible |
| isolation, mix-blend-mode | `_isolation`, `_mixBlendMode` | their keywords |
| aspect-ratio | `_aspectRatio` | `W / H`, a number, `auto W / H` |
| display | `_display` | also `inline` |
| grid-template-columns/rows, grid-auto-flow, justify-items, align-content on a grid | `_gridTemplateColumns`, `_gridTemplateRows`, `_gridAutoFlow`, `_justifyItemsGrid`, `_alignContentGrid` | layout elements only; a grid whose `align-items` is no setting keeps display and these in CSS |
| transform | `_transform` | one or more of translateX/Y, scaleX/Y (`scale(n)` as both), rotate in whole degrees, skew; `translate3d`, a matrix, a fraction of a degree stay CSS |
| transform-origin | `_transformOrigin` | as given |
| box-shadow | `_boxShadow` | as today, plus `inset` written last |

### X. Transition (new group in `controls-more.ts`)

The longhands of every block, each block on a Bricks breakpoint, become one `_cssTransition` text per tab:
`background 0.3s, border 0.3s, box-shadow 0.3s, transform 0.4s` (the easing only when it isn't `ease` or a delay
follows, the delay only when it isn't `0s`; lists cycle as CSS does). A `transition` shorthand, a keyword, a
`transition-behavior` other than `normal`, or a state changing any of them keeps the whole group CSS.

### H. States (extends `hoverKeys`/`hoverOk`, `class-source.ts` `hoverOf`)

The element's own `:hover`, `:focus` and `:active` looks (no part, no condition): each property whose normal value is
a setting and whose state value fits is that state's key (`_typography:hover`, `_background:focus`, `_border:hover`,
`_boxShadow:hover`, `_opacity:hover`, `_transform:hover`…), written in the site's rule order so the later state still
wins where two hold at once, and leaves the class's state rule. A property a `:focus-visible`/`:focus-within` look, a
part's look or another element's state also changes stays as today (its base stays CSS too). The palette link of a
colour moves with it. `src/shared/breakpoints.ts` `State` and `parseSettingKey` take `focus` and `active`.

### G. Gradient (new `src/core/emit/gradient-shape.ts`, shared by both tools; new `src/core/site/gradient.ts`)

A `background-image` that is exactly one `linear-gradient()` (an angle, a side word or none; two or more colour
stops, each a colour or a palette link with one position or none) at every range is `_gradient` with those stops
(colours as Bricks colour objects, palette links kept) and no `background-image` line. A radial or conic gradient,
two layers, a gradient over a picture, a hover that changes it and a part's gradient stay CSS. Not prototyped: Task
G1 first proves Bricks' printing of `_gradient` against `assets.php` and his `reference/bricks/` samples; if the
printed text can't be made to equal the site's computed value, G is dropped and gradients are a named leftover.

### M. Formulas (new `src/core/model/css-math.ts`, pure, used by both tools)

`cleanLen(text)`: reads a length formula of numbers, units, `+ - * /`, `calc`, `min`, `max`, `clamp` and gives its
shortest equal text: identical arguments of `min`/`max`, a `calc()` around one length, `± 0px` terms, nested `calc`,
`max(0px, x)` around something never negative only where it can prove it, numbers to at most two decimals where the
change is under 0.01 px. Anything it can't read whole (a lone `var()` in a sum, an unknown function) comes back as
written. The plugin runs every setting length through it in emit (question 3); the importer in T4.

### P. The plugin (typed fields; CSS stays typed until emit)

- **P1** `Style` (`src/core/style/types.ts`) gains `pointerEvents`, `isolation`, `visibility`, `aspectRatio`,
  `textDecoration`, `mixBlendMode` and a background `gradient` with `size`/`position`/`repeat`; the style stage's
  writers that put these in `css: string[]` today (`style/hotspots.ts`, `picture.ts`, `states.ts`, `style.ts`,
  `paint.ts`, `photo-width.ts`…) set the field where the declaration is on the element itself (a part's stays in its
  part); `emit/settings.ts` writes the keys of table S; `adapt` rules that write these at a tier write the field.
  Never a string match on CSS.
- **P2** a Button's or other non-layout element's `gap` is `_gap` (`reference/bricks/README.md` "Layout keys by
  element"), today `#brxe-<id> { gap }`.
- **P3** every setting length through `cleanLen` (rule M).
- **P4 (question 1, Milestone 5, gated)** the Button look.
- A look that follows another element (a marker class), a part's rules, several paints and the plugin's own classes
  (`text-balance`, `tap-area`, `focus-ring`) stay as they are.

### What stays Custom CSS, and how the paste says so

Properties Bricks has no control for (box-sizing, outline, vertical-align, list-style, word-break, font-feature-
settings, clear, direction…); child and part selectors; `::before`/`::after`; `@keyframes` and `@font-face`; reduced-
motion blocks; looks under a condition or another element's state; `:focus-visible`; tier-spacing's bands; a top
element's position (standing rule); `display: contents`; flex `align-content`; white-space, text-wrap and font
axes (question 5); the page-named font family without Fonts (question 4); a Section's `text-shadow: none`.
`npm run site` adds one line per part to the notes, after the earlier jobs' lines: `Custom CSS that stays: <n>
lines, by kind: …` with each kind in plain words and its count, and `styles.txt` lists the same per class. The
plugin's warnings get the same line.

## What a person sees when they click (step 3)

Full before/after settings: `click-bdry-ts.txt` (today), `click-bdry-proto-on.txt` (prototype), `click-figma-ts.txt`.

**B-Dry home, the hero Heading** ("The Tri-State's Waterproofing Experts", classes `home__h1-…` and its own):
- Today: Typography shows size 68 / Tablet 54 / Phone sideways 31, weight 600, line height 64px, colour; Layout shows
  padding 25 / 0 / 25 / 80 (Phone sideways 12 all round), margin 0, width 100%. Its own class's Custom CSS holds 17
  lines: `text-align: start` and `center` from 767, `font-style: inherit`, `flex-basis: unset`, `order: unset`, five
  transition lines, the text shadow, box-sizing, outline, vertical-align.
- After: Typography also shows **Text align left, Phone sideways center**, and (not prototyped) **Text shadow 0 0 19
  rgba(0,0,0,0.3)**; Transition shows `background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s, transform
  0.4s`. Custom CSS: 7 lines, all of properties Bricks has no control for (6 once the shadow moves).
  `"_typography": {"text-align":"left","color":{…}}, "_typography:mobile_landscape": {"text-align":"center"},
  "_cssTransition": "background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s, transform 0.4s"`
- Font family stays `"home__Roboto Flex"` in Custom CSS unless Fonts is ticked (question 4).

**B-Dry home, the Button** ("Schedule An Inspection", class `home__button-…`, Style: Primary):
- Today: Typography size 25 / Phone sideways 23, weight 700, line height 1, align center; padding 12 / 24; radius 3;
  Box shadow 0 0 10. Custom CSS: 30 lines: background transparent plus an orange gradient, colour, four
  text-decoration lines, five transition lines, `:hover` and `:focus` rules (background `#004774`, colour, `scale(1.1)`).
- After (prototype): Typography also **Text decoration none**; **Transition `transform .3s`**; its own class shows **Max
  width 100%, Phone sideways `calc(100% - 24px)`**. Custom CSS: 20 lines.
- After (whole job, H and G): **Gradient** 180° `#FFA332` → `#FFA332` (the copy's own second stop `#FFB356` on the
  element's Gradient), Typography colour white, and with Bricks' state menu on `:hover` and `:focus`: **Background
  `#004774`, colour white, Transform scale 1.1**. Custom CSS: font-family, fill, box-sizing, the focus-visible
  outline, reduced motion.

**B-Dry home, the first Section** ("Protecting Your Home From The…"):
- Today: Typography colour, weight 400, line height 1.65, size 16 (Phone sideways 14.592), transform none; Layout
  display flex, column, center, gaps 0, width 100%, margin and padding 0; overflow visible; radius 0. Custom CSS: about
  35 lines of the page's baseline (`font-style: normal`, `letter-spacing: normal`, `visibility: visible`, `flex-wrap:
  unset` and `wrap` from 767, `order: unset`, `max-width: min(100%,100%)`, four transition lines…).
- After: Typography also **Font style normal, Letter spacing normal**; Layout **Wrap nowrap, Phone sideways wrap, Max
  width 100%, Visibility visible**; **Transition** `background 0.3s, border 0.3s, box-shadow 0.3s, transform 0.4s`.
  Custom CSS: 25 lines, none of them a value with a control except the system font stack, `text-shadow: none`,
  `white-space: normal` and `position: relative` (a top element's, standing rule).

**B-Dry home, a card** (the blue hero column, classes `home__card-…`, `home__column-…` and its own):
- Today: Background `#004774D6`, radius 0, padding 0; direction column, align flex-start; width 54.847% / Tablet 716px
  / Phone sideways 100%; margin left −12 at Tablet. Custom CSS: 17 lines (`flex-wrap: unset`, `wrap` at 767,
  `align-content: unset`, `justify-content: unset`, `align-self: unset`, `order: unset`, five transition lines…).
- After: Layout also **Wrap nowrap, Phone sideways wrap**; **Transition** as above. Custom CSS: 6 lines (`box-sizing`,
  three keywords of properties outside T1's list, and tier-spacing's band for 992–1024).

**Figma (hydraulics), a Heading** (the hero H1): today Typography already shows family Saira Condensed, weight 800,
line height 0.85, letter spacing −0.02em, uppercase, size `clamp(150px, calc(71.83px + 7.88vw), 208px)`, Tablet 150,
Phone 102. After: the same (question 3: the formula stays, shortest form); nothing of it is in Custom CSS but the
plugin's own `text-balance`.

**Figma, a Button** ("Call Us Now", look class `button-…`): today the class's Style tab shows only Justify center;
padding 15 / 26, colour `#15171B`, background `#F4C20D`, radius 999, border 1px solid, shadow 0 8 24 are 16 lines of
Custom CSS at `html:root .button-….brxe-button.bricks-button`, and the Phone padding is a 150-character formula with
`25.999923706054688px`. After, with question 1 = B: **Padding 15 / 26 / 15 / 26, Typography colour, Background, Border
1 solid radius 999, Box shadow** in the class's controls, Phone padding `clamp(20px, calc((min(201.83px, 100vw −
32px) − 151px) / 2), 26px)`; the icon's `::after` and reduced motion stay. With question 1 = A: only the formula is
tidied. Either way the element's own `gap: 8.85px` becomes **Gap 8.85** (P2).

**Figma, a Section** (Hero): today padding `clamp(98px, calc(27.91px + 7.065vw), 150px)` / Tablet 98 / Phone 66, min
height 1010, background `#141619`, overflow hidden in controls; `isolation: isolate` in Custom CSS. After:
**Isolation isolate** in Layout; Custom CSS empty.

**Figma, a card** (a hero data cell, class `card-…`): padding 24, border right 1 solid `rgba(255,255,255,0.1)`, Tablet
border 0, align flex-start, gap 7 are already all controls; nothing changes.

## The standard, point by point (CLAUDE.md "THE STANDARD FOR EVERY PASTE")

1. **Structure:** unchanged; no element, label or tree changes.
2. **Classes:** the same classes hold the same properties; a class's name changes only by its hash where its
   settings change. A copy's difference stays on the element, now as a setting where it fits. Never two writers: AC8.
3. **Settings before custom CSS:** this job. Custom CSS only where Bricks has no control, named in the notes.
4. **Bricks' own behaviour:** hover, focus and active in Bricks' state menu; Transition in its field.
5. **Editable content:** unchanged.
6. **Looks stay true:** AC7, AC9, AC14: nothing moves; where clean and exact conflict, exact wins (question 2).

A reviewer asks of each class in `styles.txt`: would a Bricks builder find every number where they look for it?

## Overlaps, shared files and the order to build in

| Job | State | Files shared with this one | Order |
|---|---|---|---|
| tier-spacing | merging | `src/core/site/controls.ts`, `class-source.ts`, `classes.ts`, `tiers.ts`, `convert.ts`, `parts.ts`, `copies.ts`, `blocks.ts`, `tools/lib/site-write.ts`, `test/fixtures/site-no-revert-main.json` | **base**: its tabs and bands stay; this job only widens what its plan accepts (formulas, new rules) |
| mobile-fit | building | `src/core/site/convert.ts` (and its own `fit-width.ts`, `normalise/infer.ts`) | independent rules; whoever merges second rebases `convert.ts` (this job touches only the `ConvertOptions` line and the `fromStates` call sites) and re-runs both jobs' drawn tests |
| multi-page-scan, saved-password | tools only | `tools/lib/importer-app/commands.ts` not touched here (no new option) | none |
| short-class-names (paused) | — | `class-source.ts` `classKey`, `names.ts` | after this job (names hash the settings this job changes) |
| fewer-kept-boxes, link-keeps-name (paused) | — | `convert.ts` | after; no shared rule |
| clean-round (new, question 2) | not started | `controls.ts`, `tools/site*.ts` | after this job |

Plugin files (no job in flight on them): `src/core/style/types.ts`, the style writers named in P1, `src/core/emit/
settings.ts`, `css.ts`, `looks.ts`, `look-css.ts`, `payload.ts`, `src/core/convert.ts` (`AsBefore`). Both tools:
`src/shared/breakpoints.ts` (states), `test/browser/render.ts` (the renderer's keys), new `src/core/model/css-math.ts`,
`src/core/emit/gradient-shape.ts`.

## Acceptance criteria (all **proposed**; "the switch" is `ConvertOptions.clean: false` / `asBefore.clean`)

- AC1 (proposed): Given a class's declarations per range, each property of table S is its Bricks setting with the key and shape named there when every value fits (a length as a formula or another unit included), at Desktop and at each tab; a value outside the table's list, a layout key on a non-layout element and a property something else of the paste writes stay Custom CSS, whole. Test `test/unit/site-clean-controls.test.ts` "each property with a Bricks setting is that setting when its values fit"
- AC2 (proposed): Given rule T: a keyword that is all a listed property says leaves and one among real values is written as the value it means; a copy's own difference and a literal value never leave; a layout element's direction keyword is `row`; the four text-decoration longhands are one word; `start`/`end` is `left`/`right` only on a left-to-right line; a right-to-left element, an inherited property on a tag the browser styles and a property a state changes are untouched. Test `test/unit/site-clean-tidy.test.ts` "a keyword that says nothing leaves and a copy's own value stays"
- AC3 (proposed): Given transition longhands on Bricks' breakpoints, the class holds one Transition text per tab that computes to the same four lists, and no transition line in its Custom CSS; a shorthand, a keyword, a behaviour other than normal or a state changing one keeps them all CSS. Test `test/unit/site-clean-transition.test.ts` "the transition longhands are one Transition setting per tab"
- AC4 (proposed): Given an element's own hover, focus and active looks, each fitting property whose normal value is a setting is that state's key, in the site's rule order, and leaves the state rule; a focus-visible or focus-within look, a part's look and another element's state keep the property as today. Test `test/unit/site-clean-states.test.ts` "an element's own hover, focus and active looks are that state's settings"
- AC5 (proposed): Given one linear gradient at every range, the class holds the Gradient setting with its angle and stops (palette links kept) and no background-image line, and a library picture's position, repeat and attachment sit in its Background setting; two layers, a radial gradient, a gradient over a picture and a hover's gradient stay CSS. Test `test/unit/site-clean-background.test.ts` "one linear gradient is the Gradient setting and a picture's position and repeat sit in Background"
- AC6 (proposed): Given any length formula, `cleanLen` gives a text whose value equals the written one's for every unit size tried (each rule of M has a case, the importer's and the plugin's own formulas are cases), and text it can't read whole comes back as written. Test `test/unit/css-math.test.ts` "a simplified formula gives the written one's value"
- AC7 (proposed): Given the fixture sites `clean-values` (new) and `tier-spacing`, captured from 127.0.0.1 and converted with the switch off and on, with the Elementor step and without, drawn with Bricks 2.4.2 and 2.3.9: at both edges of every range and at 1440, 991, 767, 478, 390 and 320 every element's box is within 0.5 px and every computed property (its ::before and ::after too; `start` and `left` equal on a left-to-right line, transition lists compared by their meaning) is equal, and under a forced hover, focus and active too. Test `test/web/site-clean-equal.test.ts` "with the settings on no element draws differently at any captured width"
- AC8 (proposed): Given every code fixture and this job's, both routes: no property a class or element holds as a setting is also written for that element by its own Custom CSS or by another class it carries, outside tier-spacing's bands; and running the rules on what stayed finds nothing that fits a setting. Test `test/unit/site-clean-one-writer.test.ts` "no property is written twice and nothing that fits a setting is left"
- AC9 (proposed): Given copies of his scans (named only, `F2B_CLEAN_SCANS=<capture>,…`, never the originals), each made into its whole paste on the Elementor route: drawn against the switch-off paste at the scan's range edges, Bricks' breakpoints and the phone widths, Bricks 2.4.2 and 2.3.9, no element differs; and of the clicks the census counts, at least 85% are answered by a control (88% in the prototype; 77% on the base), with no transition, text-decoration or listed keyword line left on an element's own selector. Test `test/web/site-clean-scans.test.ts` "on the named scans the controls hold the numbers and nothing moves"
- AC10 (proposed): Given `npm run site` on a fixture capture, each part's notes hold the line `Custom CSS that stays:` with every kind the paste holds and its count, `styles.txt` lists them per class, and with the switch off neither appears. Test `test/web/site-cli.test.ts` "site names the Custom CSS that stays"
- AC11 (proposed): Given the renderer and a payload holding each new key (Visibility, Pointer events, Isolation, Aspect ratio, the grid keys, Transition, Typography's font style, text decoration and text shadow, Background position, Gradient, Transform, the focus and active keys), it prints what Bricks' `assets.php` prints for each and `unknownSettingKeys` lists none. Test `test/browser/render-clean-keys.test.ts` "the renderer prints each new setting as Bricks does"
- AC12 (proposed): Given a Figma design, a layer's own pointer events, isolation, visibility, aspect ratio, text decoration, one linear gradient paint and a non-layout element's gap are Bricks settings on the element or its look class at the design width and at each tier a rule writes them, and none of them is in that element's Custom CSS; a part's rules, several paints and a look that follows another element stay CSS. Test `test/unit/emit-clean-settings.test.ts` "a layer's own pointer events, isolation, visibility, ratio, decoration, gradient and gap are settings"
- AC13 (proposed): Given the five real files and every zero-argument fixture, every length the plugin writes in a setting is its simplest form (`cleanLen` of it is itself), no px number has more than two decimals, and each changed formula gives its old value for every unit size tried. Test `test/unit/emit-clean-values.test.ts` "every formula in a paste is its simplest form with the same value"
- AC14 (proposed): Given the five real files (both picture modes) and the fixtures `landingPage` and `clean` (new: a gradient box, a hidden layer, a see-through overlay, a kept-ratio picture, an icon Button), converted with the switch off and on and drawn with Bricks 2.3.9's and 2.4.2's front-end CSS at the design width, 1200, 1024, 991, 768, 478 and 390: every element's box is within 0.5 px and every computed property equal, with and without the hostile Theme Style. Test `test/browser/clean-values-figma.test.ts` "a Figma paste draws the same with its values in settings"
- AC15 (proposed): Given Justin's word on question 1 (B or C; skipped with a note while it is A or open): a Button look class holds its padding, typography, background, border and shadow in its own settings, its Custom CSS holds none of them, and the Button draws the same as the switch-off paste with and without the hostile Theme Style on both Bricks versions. Test `test/browser/clean-button-look.test.ts` "a Button's look sits in its class's controls and no Theme Style repaints it"
- AC16 (proposed): Given the switch off, every paste of every code fixture (the tier-spacing pin list plus this job's fixture) and of the five real files, with its notes and `styles.txt`, is byte-identical to the base's; and with it on, a paste the rules find nothing to change in is byte-identical too. Test `test/unit/clean-values-off.test.ts` "with the switch off every paste is the base's, byte for byte"
- AC17 (proposed): Given the five real files and his scans' fixtures, `npm run check`, `npm run corpus` (no width worse than the base), `test:browser` and `test:web` pass, and the plugin's conversion equals `npm run replay` byte for byte. Test `test/unit/plugin-convert.test.ts` "the plugin's paste is exactly what a replay of the same snapshot gives"
- AC18 (proposed) (live): Paste check **3fm**. Justin, with the new build: importer app → home scan → Make pastes again → paste on B-Dry staging; in Figma convert a page and paste on darksalmon. Click a Heading, a Button, a Section and a card on each: Typography, Layout, Border, Background (and Transition) show the numbers at Desktop, Tablet and Phone, Bricks' state menu on `:hover` shows the Button's hover colour, the page looks as before at 1440 and 390, and Custom CSS holds only the leftovers the notes name.

## Architecture and touched files

- **New:** `src/core/site/tidy.ts` (T), `src/core/site/gradient.ts` (G), `src/core/emit/gradient-shape.ts` (G, both
  tools), `src/core/model/css-math.ts` (M), `src/core/site/clean-notes.ts` (the leftover line), `tools/lib/click-census.ts`
  (the planner's `census.ts` made a library, used by AC9 and `styles.txt`), `test/fixtures/web/sites/clean-values/` (the
  fixture site, beside `tier-spacing`), `test/fixtures/site-clean-code.ts`, `test/unit/lib/site-clean-pins.ts`, the test files named above.
- **Changed, importer:** `control-values.ts` (`lengthish`), `controls.ts` (rules of S, the display keyword),
  `controls-more.ts` (X, H, shadow with trailing inset, transform), `class-source.ts` (`fromStates` runs T; a `copy`
  flag from `copies.ts`), `background.ts` (position, repeat), `states.ts`/`classes.ts` (the state rules lose what H
  took), `convert.ts` (`ConvertOptions.clean`, passed where `tiers` is), `parts.ts`, `tier-notes.ts`/`site-write.ts`
  (notes, `styles.txt`), `form.ts` (its `controlsFor` call keeps today's rules: `clean` not passed).
- **Changed, plugin:** `style/types.ts`, the writers of P1, `emit/settings.ts`, `emit/css.ts`, `emit/payload.ts`
  (`payloadProblems` knows the new keys), `convert.ts` (`AsBefore.clean`), Milestone 5: `emit/looks.ts`, `look-css.ts`.
- **Both:** `src/shared/breakpoints.ts` (`State = "hover" | "focus" | "active"`), `test/browser/render.ts` (+ a
  small `render-controls.ts` if it passes 600 lines).
- Sandbox rule: `css-math.ts`, `gradient-shape.ts` and everything under `src/core` use only language built-ins.
- The prototype (`prototype.diff`, 197 lines against the base) is a reference for T, X and part of S, not the code
  to ship: it switches on a global, has no state, gradient, transform or shadow rule and no notes.

## Tests that pin today's output (what the builder may change, and how)

- With the switch **off** nothing may change: `test/unit/lib/site-tier-pins.ts`' list, `site-no-div-pins`, the
  plugin's goldens. AC16 records the base's hashes from a `git clone --local` copy of the base (never `git archive`:
  the pins import from a tree's root and need `node_modules`).
- With the switch **on**, importer pins that hash a whole paste change by design: `test/fixtures/site-no-revert-main.json`
  (made again with `node tools/site-no-revert-golden.ts .`), `test/fixtures/convert-sample.json`, `site-copies-pins.json`,
  `site-headline-pins.json`, tier-spacing's own on-pins. Each is regenerated in the task that changes it, and that
  task's commit message lists the classes that changed and why; a pin that changes for another reason stops the task.
- Tests that assert a declaration sits in Custom CSS (grep `_cssCustom` in `test/unit/site-*.test.ts` for
  `transition`, `text-decoration`, `font-style`, `unset`) are edited to read the setting through one helper
  (`test/fixtures/drawn.ts` pattern: "a tool that reads a paste's rules reads an element's own too").
- Before Task 1 the builder runs every importer test with the prototype's three rules on (`F2B_CV2=1` in the
  planner's clone) and lists which fail, so each pin edit is planned, not discovered.

## Tasks (test-first; one commit per passing task, files by name; never commit CLAUDE.md; no BUILD bump)

Run under the desktop rules: Chrome tests with `CHROME_PATH`, every drawn or mutation run under `systemd-run --user
--scope -p MemoryMax=8G -p MemorySwapMax=0` (4G for mutation runs); a run that dies with SIGTERM, 137, 143 or
"Killed" is checked against the earlyoom log before it is read as a result. Ledger: `.superpowers/sdd/2026-11-16-clean-values-2/progress.md`.

### Milestone 0: the base
0. Copy this plan to `docs/plans/2026-11-16-clean-values-2.md`; run `npm run check` and `npm run corpus` and record
   the tallies; record the switch-off hashes (`test/unit/lib/site-clean-pins.ts`, from the base) for the off-pin test;
   run the census on the base's fixture pastes and keep the numbers in the ledger.

### Milestone 1: formulas and the renderer (nothing depends on the importer)
1. `css-math.ts` with its test (RED: the module doesn't exist, so the RED is the test file's first assertion per rule
   written against a stub that returns its input; GREEN per rule).
2. `test/browser/render.ts`: the new keys and the focus/active states, each against `assets.php`'s printing
   (`render-clean-keys`); `payloadProblems` and `unknownSettingKeys` know them.

### Milestone 2: the importer's settings (the order keeps every commit green)
3. The switch and the fixture: `ConvertOptions.clean`, `test/fixtures/web/sites/clean-values/` (a page with: keyword-only
   properties and one that turns real at 767; transition longhands; a formula max-width; logical sides; a
   right-to-left box; a copy keeping its own direction; own hover + focus + active on a button with a gradient; a
   focus-visible outline; a text shadow; a grid; an `em` in a paragraph; a transform; a top bar with position), the
   off-pin test green, `site-clean-equal` written and green with nothing changed yet.
4. T (tidy) behind the switch: `site-clean-tidy` RED (the planner's `site-clean-red.test.ts` test 2 is its first
   case: fails on the base with `_flexWrap` undefined, passes in the prototype), then GREEN; `site-clean-equal` stays
   green; regenerate the on-pins this changes.
5. S, lengths and formulas (`lengthish`, T4): `site-clean-controls` RED/GREEN (probe test 3).
6. S, the new keyword and typography rules (font style, letter spacing, decoration, visibility, pointer events,
   isolation, ratio, display inline, transparent, grid keys with the `align-items` guard).
7. X transition: `site-clean-transition` RED/GREEN (probe test 1).
8. S, text shadow, box shadow's inset, transform and its origin; background position/repeat/attachment.
9. H states: `breakpoints.ts`, `hoverOf` → all three states, `site-clean-states`; the equal test's forced states.
10. G gradient: first the printing proof (Task G1 in rule G); then `site-clean-background`, or the named leftover.
11. `site-clean-one-writer`; the notes line and `styles.txt` (`site-cli`); the census library and
    `site-clean-scans` run on copies of his five scans (`~/.cache/<job>/`, never `~/Downloads`), its numbers in the ledger.

### Milestone 3: the plugin's settings
12. `AsBefore.clean` and the off-pin half; the `clean` fixture.
13. P1 one field at a time (pointer events, isolation, visibility, ratio, decoration, blend), each: the style
    writer sets the field, emit writes the key, `emit-clean-settings` case RED/GREEN, `clean-values-figma` green,
    rule-collision test green (two rules writing one field at one tier still fail).
14. P1 gradient and its size/position/repeat through `gradient-shape.ts`; P2 gap.
15. P3 `cleanLen` over every setting length (`emit-clean-values`); `npm run corpus` no worse.

### Milestone 4: close
16. `npm run check`, `test:browser`, `test:web`, `npm run corpus`; one screenshot per AC (Bricks-like panel
    listings from `click.ts` for the control ACs, the drawn pages for AC7/AC9/AC14); HANDOFF section; stop at
    `ready-for-review`.

### Milestone 5: the plugin's Buttons (only on Justin's word for question 1)
17. With B: the look's values as settings on the look class, Style left empty, `clean-button-look` against the
    hostile Theme Style on both versions; if a Theme Style still repaints it, stop and report (the answer falls
    back to A). With C: the same with Style: Primary kept and the note saying a Theme Style may repaint.

## Docs & records (the finisher)

- `docs/HANDOFF.md`: a clean-values-2 section: the rules, the eight rulings not yet confirmed, the counts before and
  after on his scans and the five files, what stays Custom CSS, paste check 3fm, follow-ups (`clean-round`).
- CLAUDE.md Status: one line; standing rules: "a site paste's tidy never drops a copy's own value or a literal
  value", "every new setting key is added to `test/browser/render.ts` and `render-clean-keys`", and the changed
  Button ruling if question 1 becomes B or C (it replaces "A Button look class keeps its look in its own Custom CSS").
- `reference/bricks/README.md`: the controls table (from `builder-2.4.2-controls.txt`), the state keys, what 2.3.9
  is unproven for (question 5).
- `tools/lib/importer-app/commands.ts`: nothing (no option).

## Risks and open points

- **Not prototyped:** H (states), G (gradient), transform, text shadow, background position, the plugin's P. Their
  counts come from the census; each has its own drawn test before it merges, and G has a way out.
- **A class's settings print at `.cls.brxe-<el>` (0,2,0), its Custom CSS at `.cls` (0,1,0):** moving a declaration
  up a weight is safe only because no other class of the element writes the property and the element's own
  `#brxe-` rules already win. AC8 guards it; a new look producer must keep to it.
- **Renderer vs Bricks:** the renderer only approximates Bricks; the live check 3fm is the judge, above all for the
  state keys, Gradient and Transform in 2.3.9.
- **`text-align: left` for `start`** is equal only on a left-to-right line; the rule reads tier-spacing's `acrossOf`.
- **A Section's baseline** (font style, letter spacing, visibility as settings) is honest but adds values to every
  top Section; if Justin finds it noisy, the alternative is to leave the baseline whole in Custom CSS (one word).
- **Empty controls that don't mean Bricks' default:** the page's reset (`all: revert`) cancels Bricks' own element
  defaults, so an empty Direction on a Block draws `row`, not Bricks' column. That is true today; T1 keeps a layout
  element's direction written for that reason. Other such defaults (a Block's width 100%, wrap from 767) are not
  made explicit here; a follow-up if a pro trips on one.
- **mobile-fit** merging between this job's build and finish means a rebase of `convert.ts` and a re-run of AC7/AC9.
- **Round numbers** are not in this job (question 2); B-Dry's `14.592px` stays `14.592px`.

## Completion and reporting

The builder stops at `ready-for-review` with: the ledger, the census before/after on the fixture and on the copies
of his scans, the drawn tests' tallies on both Bricks versions, every pin regenerated and why, anything of S it
left CSS and why, and `skill_lessons`. Website-importer review cap: one review reporting bugs a real site or normal
use hits; the plugin half gets the same single review. Then verifier and blind auditor side by side, `ac-check.sh`.
The live AC (3fm) is owed to Justin.
