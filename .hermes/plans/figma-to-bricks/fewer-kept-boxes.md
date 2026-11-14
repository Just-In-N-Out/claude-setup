# fewer-kept-boxes: leave out the wrapper boxes the paste still keeps, moving their values onto the element, with nothing moved on the page (plan, Full, 2026-11-13)

Planner: Fable 5.2 high. Plan only: no source or test changed, nothing committed, no agent started, no live site
loaded (bdryswi.com, B-Dry staging and darksalmon never opened), no WordPress written.
Evidence (`<E>` below): `~/.hermes/plans/figma-to-bricks/evidence/fewer-kept-boxes/planner/` (`README.md` lists every
file). Scratch trees: `~/.cache/fk-pl/` (may be gone; every script takes its trees as arguments).
Measured on: importer-parity-build `33a73f41` (it holds site-no-div up to fix 2 and site-shared-styles' fix head
`7b7501bd`; it moved to `1f407006` while this was written: `convert.ts` only, none of the fold files), plugin-parity-build
`fcdec6e2`, site-no-div-final `4a4bfa17` (on main; its `fold-boxes.ts` is the measured one less importer-parity's names;
it moved to `cf4f887d` while this was written: one test file),
main `7f54b0a5` (Build 2026-11-12.3). The importer prototype is `<E>/proto-fold-boxes.diff` (applies to `33a73f41`'s
`src/core/site/fold-boxes.ts` after `<E>/instrument-*.diff`); the plugin prototype is `<E>/probe/plugin-fold.ts` (it
works on a finished paste, outside the repo).

## Playback

1. Both tools still paste boxes that hold exactly one element and draw nothing: a Block around a Heading only to give
   it a margin, a width or its place in a row. A person building in Bricks would put that margin or width on the
   Heading itself.
2. Today the importer keeps such a box, with a note, whenever taking it out could move the page; the plugin keeps
   every Figma frame, even one that only wraps one text.
3. This plan takes those boxes out wherever their values can be written onto the element so that nothing moves by more
   than half a pixel at any width, tier, hover, focus or scroll position, and keeps (and names) the ones that can't.

## Questions (⭐ = the ruling taken; Justin was asleep, so each ⭐ is my best-reasoned answer after research. "go with recommended" takes them all)

1. **Where does a left-out box's padding go?** ⭐ **A: onto the element's own padding when the element paints nothing
   (a Heading, a Rich Text, a plain Block), and as the element's margin when it paints (a Button, a card) and sits in a
   flex or grid row or column; anywhere else the box stays.** That is where a Bricks builder puts it, and both are
   exact. B: padding only onto elements that paint nothing (about 12 more boxes stay on Justin's scan).
2. **Boxes inside menus, pop-ups and closed FAQ answers.** The scan measured no box sizes there (the capture reads
   sizes only of what shows on the page), so nothing proves a fold moves nothing. ⭐ **A: they stay in this job, each
   named "the capture measured no box of it"; a follow-up job makes the capture measure opened boxes and closed
   answers (it needs a new scan).** On Justin's scan that is 42 boxes with `--elementor` (10 in the menu and pop-ups,
   32 in answers and drawer lists; the 10 as counted after the prototype's folds). B: fold them on the declared CSS alone (not proven; a menu could shift).
3. **An Elementor container holding only another Elementor container** (7 on the scan, 10 on the stand-in). ⭐ **A: both
   stay: each is a box the site's builder made with its own layout, padding or background, and nearly all are flex
   boxes that place their child.** B: fold where one of them adds nothing (few would).
4. **A sticky bar inside a box no taller than it** (it never sticks on the site, and sticks once the box is gone:
   site-no-div's follow-up V-1). ⭐ **A: when its box goes, the bar is written `position: relative` with no offsets
   (and `z-index: 0` where it had none, so it paints in the same order); a bar that does travel inside its box keeps
   the box (a part's root then stays one Block, named).** B: always keep the box around anything sticky.
5. **The Figma plugin's part.** A Figma frame around one layer is kept today (hydraulics: 227 of 388 boxes hold one
   element; Services 453 of 734; Repairs 100 of 187; brainstorm 46 of 244; GRO 24 of 197). ⭐ **A: Figma designs only
   (a website capture converted in the panel stays byte for byte, as plugin-parity's Q8); frames that only lay out,
   pad, space or size their one layer are left out, one kind of value at a time, each kind shipped only once the five
   real saves show nothing moved.** B: only frames that do nothing but lay out (51, 4, 8, 2 and 1 boxes), the rest in
   a later job.
6. **Labels.** ⭐ **A: the element takes the left-out box's label when that label was a real name (a Figma layer name
   the designer typed, a widget label such as "Icon" or "Heading") and the element's own is a made-up one (Box, Row,
   Column) or none; a made-up label goes with the box.**
7. **Notes.** ⭐ **A: the importer's notes keep the line "kept as Blocks: N boxes (reasons)", now counting each kept
   one-element Block once (site-no-div's V-2 over-count goes) and with the new reasons in plain words; the plugin
   writes no note per box: `npm run replay` prints one line with the counts, the panel shows nothing new.**
8. **A wrapper that is an `a`, `li`, `ul`, `button` or `span`.** ⭐ **A: stays: the tag is the link, the list or the
   control; the 26 spans on the scan's plain route are flex or inline boxes holding an icon (tried in the prototype:
   none folded).**
9. **For Justin to know, no choice:** an element that takes a box's values gets another class (the importer names a
   class after its rules), so on a re-paste Bricks shows those as new classes; pages already pasted keep their boxes
   until re-pasted.

## What was measured

### The importer: every paste box that holds exactly one element, by why it stayed (`<E>/tables/importer-reasons-base-vs-proto.txt`)

Counted on the pastes themselves (a Section, Container, Block holding one element), each by rule N's or the Elementor
fold's own first refusal (the trees instrumented by `<E>/instrument-*.diff`; `<E>/probe/wrappers.ts`). "scan" is
Justin's 2026-11-11 scan (read-only copy `evidence/media-clickable/run/`), "stand-in" the offline B-Dry stand-in
(`evidence/site-native-structure/inputs/standin-capture-b2435de.json`); el = `--elementor`.

| Why the box stayed (base) | scan el | stand-in el | scan plain | stand-in plain | This plan |
|---|---|---|---|---|---|
| The standard shape: Section › Container, a Container or Section holding one element | 29 | 27 | 30 | 30 | stays (it is the hand-built shape) |
| Elementor fold refused: a negative margin the widget box floors at 0 (rule 8) | 16 | 16 | 0 | 0 | the widget box folds by rule N; the floored box stays (6 of 16 go) |
| Elementor fold refused: a margin inside a sized widget box | 14 | 14 | 0 | 0 | size written less the margins (the prototype, without that rewrite: 6 of 14 go) |
| Elementor fold refused: its holder pads | 14 | 10 | 0 | 0 | padding moved (Q1; the prototype's simpler rule took 2) |
| Elementor fold refused: widget box stretched past its body (rule 9) | 2 | 2 | 0 | 0 | the equal half folds (1 of 2) |
| Elementor fold: a box left around a Button or linked Image (rule 10: an inline `a` placed by `text-align`) | 4 | 2 | 0 | 0 | stays (the box gives the line the Button sits on) |
| Held: a label a step gave (a widget kept as page code: Icon, Spacer, Animated headline…) | 21 | 18 | 0 | 0 | the label moves down (all 21 freed; then judged) |
| Held: a state look's trigger | 6 | 6 | 8 | 8 | a wrapper may fold into the trigger |
| Held: an accordion's scoped element 12, an opener 0–10, a box a script styled 0–3, a pick (an Elementor container, a Slider, an Image) 5–24 | 47 | 34 | 19 | 5 | stays (needed; Q3 for a container in a container) |
| A box the paste itself makes (an Offcanvas's content) | 5 | 0 | 5 | 0 | stays |
| Rule N: lays out | 7 | 6 | 114 | 105 | 95 were gaps and `unset` values on a box that is no flex or grid: they say nothing; a real flex, grid or inline-block stays |
| Rule N: has a margin | 11 | 9 | 35 | 33 | moved (all) |
| Rule N: pads | 7 | 6 | 54 | 46 | moved (Q1) |
| Rule N: sizes, positions (an offset or a z-index), flex or grid item properties | 1 | 1 | 27 | 16 | moved |
| Rule N: paints 11–15, clips 1–6, a look under a state 12, a pseudo element 0–7 | 30 | 22 | 40 | 31 | stays (it draws) |
| Rule N: its element is inline-level | 3 | 4 | 30 | 31 | stays (the line it sits on) |
| Rule N: another tag (`span` 8–26, `a` 2–19, `li` 3, `ul` 1, `button` 0–1) | 15 | 13 | 50 | 47 | stays (Q8) |
| Rule N: a box of its own that isn't its element's | 4 | 0 | 15 | 5 | the box equation (below) |
| Rule N: words, a hidden element or a space beside it 2–11, other shown ranges 0–1 | 3 | 0 | 12 | 9 | stays |
| Rule N: a percentage of its wrapper | 0 | 0 | 1 | 1 | rewritten against the outer box |
| Rule N: sticky, a relative font size on both, a text setting read another way, two margins on one side | 0 | 0 | 0 | 0 | rewritten (in the brief; none on these pages; unit rows and the fixture cover them) |
| Never visited: a never-shown box (closed answers, drawer lists) | 32 | 13 | 19 | 0 | stays (Q2) |
| Never visited: words in a `li`, `label`, `legend`, `button` (a Block with its tag around one Rich Text) | 18 | 5 | 18 | 5 | not this job (a Rich Text has no tag control) |
| **All one-element boxes** | **289** | **208** | **477** | **372** | |

The reasons the brief names (a percentage of the wrapper, sticky, relative font sizes, a text setting read another
way, two margins) are almost absent from Justin's page: what keeps its boxes is margins, sizes and item properties,
padding, declarations that say nothing, labels a step gave, and refused Elementor chains.

### The importer prototype (`<E>/proto-fold-boxes.diff`: M0, M1, M2a, M3, the box equation, the freed holds; not Q1's padding as margin, the percentage and font rewrites, or sticky)

| | Blocks base → prototype | wrappers folded base → prototype | drawn: elements that moved |
|---|---|---|---|
| scan el | 401 → 368 | 7 → 40 | 0 of 14,820 readings at 15 widths (`<E>/logs/d5-scan-el.log`; one reading differs by an entrance animation's opacity, 0 px) |
| scan plain | 585 → 471 | 40 → 157 | 0 of 15,375 at 15 widths (`d5-scan-plain.log`) |
| stand-in el | 284 → 250 | 7 → 41 | 0 of 8,292 at 12 widths (`d4-standin-el.log`) |
| stand-in plain | 434 → 319 | 40 → 155 | 0 of 8,388 at 12 widths (`d4-standin-plain.log`) |

"Moved" is `<E>/probe/box-diff.ts`: the same capture converted by the base tree and by the prototype tree, each part
drawn as `site:check` draws it (Bricks' front-end CSS, pictures from the capture's bytes, no host but 127.0.0.1 and
Google Fonts), every element both pastes hold compared at one width per range: content box within 0.5 px, painted
border box, 23 text and paint settings. Two things the prototype got wrong on the way, both caught by that drawing and
now part of the design: (1) a wrapper the capture gave no box of its own, around an element with a negative bottom
margin inside a flex item, folded and the page came out 3.8 px shorter (the box equation must count the element's
margins where the wrapper contains them); (2) the probe keyed elements by id and the page has three `#eicon-close`.
The whole unit suite on the prototype (`<E>/logs/unit-proto.tap` beside `unit-base.tap`, by test name): 3,813 tests,
the base's 1 failure plus 9: the 8 pins under "Tests that pin today's behaviour" and the sandbox-globals test (the
prototype reads `process.env` in `src/core`; the real switch is an option).

### The plugin: boxes holding one element on the five real saves, plugin-parity head (`<E>/tables/plugin-single-child-boxes.txt`, `<E>/logs/pf-*.log`)

| Save | boxes | hold one element | left out by "only lays out" (drawn) | with padding, margin, least sizes, item (drawn) |
|---|---|---|---|---|
| Services (git 2199895) | 734 | 453 | 4 (0 moved, 3 widths) | 107 (moved: not exact yet; 231 more are painted table cells, which stay) |
| hydraulics | 388 | 227 | 51 (0 px, 5 widths) | 102–104 (one section 1.5 px shorter: padding on one kind of row; the rest of the 241 are hidden boxes the probe misreads) |
| Repairs | 187 | 100 | 8 (0 moved) | 24 (0 moved at 9 widths, 2,826 readings) |
| brainstorm | 244 | 46 | 2 (0 px) | 8 (6 readings moved, worst 20 px at one width) |
| GRO | 197 | 24 | 1 (0 moved) | 1 (0 moved at 10 widths) |

So the plugin's own wrappers are real and many on designs brought in from HTML (hydraulics, Services, Repairs), few on
free-drawn ones (GRO, brainstorm). "Only lays out" is exact as prototyped; the value-moving kinds are exact on Repairs
and GRO and not yet on the other three, which is why each kind ships behind the drawn guard (Q5 A).

## Design

One rule for both tools, in the words a Bricks builder would use: **a box that holds one element and draws nothing
is left out when everything it gives that element can be written on the element itself, exactly; else it stays, with
its reason.** The importer proves it from the site's declared CSS and the capture's measured boxes
(`src/core/site`); the plugin from its own typed styles at every tier (`src/core/emit`). The two share no code
(`test/unit/site-isolation.test.ts`), only this rule and its reasons' words.

### A. Importer: rule N with moves (`fold-boxes.ts`, new `fold-moves.ts`)

W is the wrapper, C its only element, P the box that holds W. N1 (a `div`, one child, no pseudo element, no state
look) and N3 (same shown ranges) stay. At each kept range:

**M0, what says nothing** is ignored, not refused: a declaration that lays out children (`gap`, `row-gap`,
`column-gap`, `flex-direction`, `flex-wrap`, `flex-flow`, `justify-content`, `align-items`, `align-content`,
`justify-items`, `place-items`, `place-content`, `grid-template-*`, `grid-auto-*`) on a W whose `display` there is no
flex or grid; and any flex, grid, gap, order or alignment declaration whose value is `unset`, `initial` or `revert`.
None of these changes anything on C (the merge never copies a wrapper's child layout, and an `unset` item property is
the default C already has).

**M1, a margin** on a side moves to C where C has none there (any value, `auto` too). Both non-zero: they add when W
is a flex or grid item (px only) and on the left or right in a block container (px only); top or bottom in a block
container stays "two margins on one side".

**M2, a padding** in px moves (Q1 A): (a) onto C's own padding (added to C's px padding) when C is plain: a box or
words (never a picture or other replaced element), no `::before`/`::after`, no state look, nothing painted or clipped
at any kept range, no size of its own on that axis but `auto`, `none`, `0` (or `100%` with `box-sizing: border-box`),
no margin on that side; C's box is then W's, so C joins `standsFor` (the checks read W's captured box for it, as the
Elementor fold's padded bodies do). (b) Else, as C's margin (added to C's px margin there) when P is a flex or grid
container at that range. Else the box stays "pads".

**M3, sizes and place** move to C: W's `width`, `min-width`, `max-width`, `height`, `min-height`, `max-height` that
aren't neutral, its flex and grid item properties, and a `position: relative` with its offsets and `z-index`, when C
sets no size of its own on that axis (a `100%` there is replaced), declares no item property (N4 today) and is static
or `relative` with no offset and no `z-index`. Where C has a padding or border on an axis whose size it takes and
isn't `border-box`, it is written `box-sizing: border-box` (it had no size there, so nothing else changes). Rewrites
that keep the size true:
- a `width`, `min-width`, `max-width` or `flex-basis` in px or % that held C's side margins (its own, or M2b's) inside
  it is written less them: `calc(13% - 22px)`, `calc(12% + 8px)` for negative ones; any other unit beside such
  margins stays "a margin inside a sized box";
- C's `height: 100%` (or `width: 100%` in a flex or grid row) of a W whose size there is `auto` is dropped: C stands in
  W's place and is `auto` as W was;
- **M4, a percentage against the outer box:** C's percentage padding, margin, `text-indent`, `left` or `right` read
  W's width; where W declares that width in px it is written as the px product, where W declares q% as `(p·q/100)%`;
  where W's width is its block parent's (today's rule) it stays as it is; anything else stays "its element is sized by
  a percentage of its wrapper".

**M5, fonts and text settings:** (a) W's and C's font sizes both relative (`em`, `%`): C carries the product in `em`
(today: only an absolute W). (b) A text setting W declares that C never read (the capture's computed values on C,
`CodeNode.inherited`, differ from W's: a browser heading size, bold, a link colour) is not carried onto C; where W set
the font size and C's own size was relative to it (the browser's `h2 { font-size: 1.5em }`), C is written the px the
capture computed. (c) W's `em`, `ex`, `ch` or `%` text setting (`line-height: 1.5em`) that C would read against a font
size of its own is written as the px it computed to at W (`elementor-measured.ts fontPx`). Where the capture holds no
computed value to write, the box stays "its element would read a text setting of its wrapper another way".

**N2′:** what W declares after M0–M5 must draw and lay out nothing (`lift.ts drawsAt`, unchanged).
**N4′:** C still must be block-level, not floated, not absolute or fixed, no item of its own; sticky by S1 below.

**N5′, the box equation** (replaces "W has no box, or W's box is C's"): at every width the capture measured in a kept
range, W's box (C's own where the capture gave W none: it had folded W into its only child) equals, within 0.5 px, C's
box grown by W's moved px padding and by C's px margins: the left and right ones always, the top and bottom ones
where W is a flex or grid item or pads that side (there W contains them; in a block container they pass through W and
meet the same neighbours after the fold). It is what catches a floored negative margin (rule 8's shape), a stretched
box (rule 9's) and a least height. Neither box measured (an opened box, a never-shown answer): stays "the capture
measured no box of it" (Q2 A).

**N6′, what still holds a box:** a pick (an Elementor container, a native element), a pasted hidden part and all
inside it, a left-out root's chain, an accordion's scoped elements, an opener or ×, an opened box's entrance, a live
widget's slot and the boxes above it, a box a script styled, an element the paste leaves out. **Freed:** a label a
step gave (it moves to C when C has none or a made-up one: Q6 A); a chain the Elementor fold refused (each pair is
judged by this rule's own proof; the ten Elementor rules and `merge` are unchanged, so the Elementor step's own folds
are byte for byte as before); a state look's trigger as C (it stays itself; W as a trigger still holds).

**S, sticky (Q4 A; `sticky-room.ts`, used by rule N and by `lift.ts liftOf`):** a sticky element's room to travel is
how far its containing box reaches past it on the side it sticks toward (below it for `top`, above for `bottom`), read
from the capture's boxes at every measured width of a kept range. S1 (rule N, C sticky in W): no room anywhere (within
0.5 px) → W folds and C is written `position: relative`, its `top`, `right`, `bottom`, `left` dropped, `z-index: 0`
where it had none; room → stays "its element is sticky". S2 (rule S and the Elementor step's lift of a part's root):
a section that is sticky at some range and has no room inside the last lifted box → the root lifts and the section is
rewritten as in S1; with room → the root stays one Block labelled with its part, noted "the header's root stays: it
bounds how far a sticky bar travels". A header the site's script keeps at the top (`web.position: "fixed"`, the stay
class) is untouched.

**Notes (Q7 A):** `Prepared.structure` counts a kept box only when the paste holds it as a Block with one element
(`structure.ts`), so "kept as Blocks: N" is the paste's own number; reasons as above, in these words.

**Switch (tests and diagnosis only):** `ConvertOptions.moves: false` (through `siteParts`, `siteToBricks`,
`prepare`) gives rule N as it is today and no sticky rewrite: every paste byte for byte the base's.

### B. Plugin: frames that only wrap one layer (`emit/wrappers.ts`, used by `emit/elements.ts`)

Decided at emit, after adapt, on the typed styles (base, every tier, the `fluid` tier, class styles), as
plugin-parity's shared looks are: understand, style and adapt see the same IR as today, so every rule plans the page
as before and no stage edits an earlier one's output; emit just doesn't make the element and writes its values on its
one child. Never on a website capture (`snapshot.source === "web"`).

W (a `block` or `div` IR node) is left out when all hold:
- it has exactly one child that shows, its parent is a Section, Container, Block or Div, and it is a plain box: no link
  (`elementLink`), no state look, not a trigger of another element's look, no overlay, flip, hotspot, marquee, slider,
  accordion, menu, list, form, strip, showcase or spacer part, no `show` of its own, no custom CSS, no attributes;
- its own style (its classes' included), at base and at every tier, holds only: layout of its children (`display:
  flex`, `direction`, `wrap`, `justify`, `align`, gaps), which goes with it; and what moves: `width`, `widthMax`,
  `widthMin`, `heightMin`, `flexGrow`, `flexShrink`, `flexBasis`, `order`, `padding`, `margin`. Anything else (a
  background, border, shadow, overflow, opacity, position, height, motion…) and it stays, counted by that word;
- a class it carries holds only layout (it goes with W); a class carrying what would move stays with W unless every
  value in it moves (then C carries the class: one writer per property still holds, checked);
- one of these shapes, at base and at every tier:
  - **fills:** W `width: 100%` and C `width: 100%` → C takes W's place;
  - **hugs:** W `width: auto` (no least width that differs from C's) and C hugging → C takes W's `flexShrink`, `widthMax`;
  - **a text at the start of a filling column:** W `width: 100%`, column, `align` and `justify` at the start, C a Rich
    Text or Heading with no width, margin or max width of its own → C gets `width: 100%` (its words start where they
    did and wrap at the same width);
- what moves lands on C without a clash: C has no value for that key at that tier, or the same value; padding and
  margin merge side by side; padding onto the padding of a C that paints nothing (text, heading, a plain box), as the
  margin of one that paints (a Button, a picture: every Block is a flex box, Q1 A); a least height only where W
  starts its child at the top.
C keeps its id; no other element's id changes; a paste never names a left-out W (`#brxe-<id>` in custom CSS, a
trigger class, a script). C takes W's label by Q6 A. `ConvertResult.structure = { folded, kept: Record<reason,
number> }`; `npm run replay` prints one line. **Switch:** `asBefore.wrappers` (beside plugin-parity's) converts as
before, byte for byte.

Each moving kind (padding; margin; least sizes; item properties; the text at the start of a filling column) is its own
task and ships only when the drawn guard shows nothing moved on the five saves; a kind that can't be made exact is
left out of the build and named in HANDOFF "Deferred" with its measured move.

### C. The guard (both tools)

- **Importer:** the same capture converted with `moves: false` and with the moves, each part drawn (Bricks 2.4.2 and
  2.3.9), every element both hold compared at every width the capture read: content box and painted border box within
  0.5 px, the text and paint settings equal; the same with `:hover` and `:focus-visible` forced on every element that
  has a state look, and with the whole page scrolled 400 and 1200 px (`test/web/lib/box-diff.ts`, from
  `<E>/probe/box-diff.ts`: keys unique per element, a slider's slides compared without their sideways place). On the
  fixture site the paste is also compared with the site itself within 0.5 px.
- **Plugin:** the same save converted with `asBefore.wrappers` and without, both drawn by `test/browser/render.ts`,
  every element both hold compared at the design width and one width in every tier (1280, 900, 600, 390), at laptop
  widths 1366 and 1100, at 375, 360 and 320, with each hover trigger forced at the design width and 390, and scrolled
  400 px: content box within 0.5 px (a Rich Text's or Heading's by its inner `p`: where its words start, their lines
  and height), text settings equal (`test/browser/lib/paste-diff.ts`, from `<E>/probe/plugin-fold.ts`).

## The standard, point by point

1. **Structure:** this is the point the job serves: "no wrapper that does nothing". A Block that stays draws,
   clips, places its child on a line, reacts to hover, is the site builder's own container or carries a tag that means
   something; the notes say which. Section › Container stays. The element takes a real label (Q6).
2. **Classes:** a moved margin, padding or width lands in the element's own class, or in a shared layout or box class
   when site-shared-styles finds the same look repeated; no class is left on a box that is gone; never two classes
   writing one property (plugin: the class rule above; importer: one class per element as today).
3. **Settings before custom CSS:** the plugin writes the moved values in Bricks' own controls on the element
   (Spacing, Width, Flex grow…), where the builder looks first. The importer writes them where its classes hold such
   values today (that is the clean-values job's field, untouched here). A `calc()` width is the exact value and stays
   as written (exact wins).
4. **Bricks' own behaviour:** nothing added; a sticky bar that never stuck is plain `position: relative`, no script.
5. **Editable content:** unchanged; fewer boxes to click through to reach the words.
6. **Looks stay true:** the guard is the gate: nothing moves by more than 0.5 px at any width or tier, hovered,
   focused or scrolled; where "clean" and "exact" conflict the box stays and the notes say why.

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a wrapper whose only values are a margin, a px padding, a size, flex or grid item properties, a relative position with its offsets, or declarations that say nothing, when the page is pasted, then the wrapper is left out and its element's class carries those values (padding on a plain element's padding, as its margin on a painted element in a flex or grid parent; a chain of such wrappers too). Test (`test/unit/site-fold-moves.test.ts`):
  `AC1 a wrapper whose margin, padding, size, item place or position can move folds and its element carries them`
- AC2 (proposed): Given a wrapper whose element would read a value another way once it is gone, then the value is rewritten so it draws the same: a size written less the side margins inside it (`calc`), a `height: 100%` of an auto-height wrapper dropped, a percentage written against the outer box, two relative font sizes multiplied out, a text setting the element never read left off and a font-relative one written in the px it computed to; and where no exact rewrite exists the wrapper stays with that reason. Test (`test/unit/site-fold-moves.test.ts`):
  `AC2 a value the element would read another way is rewritten to draw the same, or the wrapper stays`
- AC3 (proposed): Given the capture's measured boxes, a wrapper folds only when, at every measured width of a kept range, its box is its element's box grown by the moved padding and by the element's margins it contains; a floored negative margin, a stretched box, a least height, a 2 px difference at one width, or no measured box (an opened box, a never-shown answer) keeps it. Test (`test/unit/site-fold-moves.test.ts`):
  `AC3 the box equation folds a wrapper only where the capture's boxes agree at every measured width`
- AC4 (proposed): Given a wrapper that paints, clips, lays its element out (a flex, grid or inline-block box), changes under a state, has a pseudo element, is not a `div`, holds words or a hidden element beside its element, shows in other ranges, has two margins on one side that can't be told as one, or whose element is inline-level, floated, absolute, fixed or an item of its own, then it stays a labelled Block and the notes count it under that reason. Test (`test/unit/site-fold-moves.test.ts`):
  `AC4 a wrapper that draws, places its element or carries a tag stays a Block counted by its reason`
- AC5 (proposed): Given a wrapper a step labelled, a chain the Elementor fold refused, and a wrapper around a state look's trigger, then each folds by rule N's proof (the label moving to the element); and a pick, a pasted hidden part, an accordion's scoped element, an opener or ×, an entrance, a live widget's slot, a scripted box and a left-out element still hold their boxes; the Elementor step's own folds are unchanged. Test (`test/unit/site-fold-moves.test.ts`):
  `AC5 a label moves down with the fold and a refused chain folds by rule N while picks, openers, scopes and live slots hold`
- AC6 (proposed): Given a sticky element whose containing box gives it no room to travel at any measured width, when that box folds (rule N) or lifts (a part's root), then the element is written `position: relative` without offsets (`z-index: 0` where it had none); given room, the box stays (a part's root one Block, noted). Test (`test/unit/site-sticky-room.test.ts`):
  `AC6 a sticky element with no room to travel is written non-sticky when its box goes and one with room keeps its box`
- AC7 (proposed): Given the fixture site `kept-boxes` (a header whose bar is sticky inside a box no taller than it, and a page section with a sticky label that does travel), captured and pasted whole into one page on both routes, when the site and the paste are scrolled 0, 400 and 1200 px at 1440 and 390, then every compared element is within 0.5 px of the site (the bar scrolls away as on the site; the label sticks as on the site). Test (`test/web/site-kept-boxes-sticky.test.ts`):
  `AC7 a sticky bar that never stuck on the site does not stick in the whole-page paste when scrolled`
- AC8 (proposed): Given the fixture site `kept-boxes` (one section per move and per rewrite of AC1 and AC2, one per staying reason of AC4, plain HTML and an Elementor-marked twin), captured with this job's code and pasted on both routes, then each part is within 0.5 px of the site at every width the capture read, with Bricks 2.4.2's and 2.3.9's front-end CSS, each state look forced (`:hover`, `:focus-visible`) included, and the pastes hold none of the wrappers AC1 and AC2 name. Test (`test/web/site-kept-boxes.test.ts`):
  `AC8 the kept-boxes fixture pastes within half a pixel of its site at every width with hover and focus`
- AC9 (proposed): Given the offline B-Dry stand-in and, when `F2B_JUSTIN_SCAN` names it, Justin's 2026-11-11 scan, converted with the moves off and on (both routes), then every element both pastes hold is within 0.5 px (content box, painted box) with equal text and paint settings at every width the capture read, hovered and scrolled 400 px too (the scan's default path: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`, read only); and the Blocks are fewer by at least 30 with `--elementor` and at least 100 without, on each capture. Named-only (`F2B_REAL_CAPTURES`, as `site-no-div-bdry`). Test (`test/web/site-kept-boxes-bdry.test.ts`):
  `AC9 on the B-Dry stand-in and the scan nothing moves by half a pixel with the moves on and the Blocks fall`
- AC10 (proposed): Given any paste, the notes' "kept as Blocks: N boxes (…)" counts exactly the Blocks the paste holds with one element that rule N judged, each once under its first reason, and "folded: N" the boxes left out. Test (`test/unit/site-fold-moves.test.ts`):
  `AC10 the notes count each kept one-element Block once and the count is the paste's own`
- AC11 (proposed): Given `moves: false`, every paste of every code fixture and fixture capture (whole page and section pastes, both routes) is byte for byte the base's, notes included; with the moves on, a paste differs from the base's only in the wrappers left out, the elements that took their values and labels, a sticky element rewritten, and the two notes lines. Test (`test/unit/site-fold-moves-off.test.ts`):
  `AC11 with the moves off every fixture paste is the base's byte for byte`
- AC12 (proposed): Given a Figma frame that only lays out its one layer, or also pads, spaces, gives a least size or an item place to it, when the design converts, then the frame is left out and the layer carries those values in its own settings at base and at every tier, keeps its id, and takes the frame's label when that was a typed name. Test (`test/unit/plugin-wrappers.test.ts`):
  `AC12 a Figma frame that only wraps one layer is left out and the layer carries its values at every tier`
- AC13 (proposed): Given a frame that paints, clips, links, is placed, reacts to hover or is another element's trigger, is a part of a slider, accordion, menu, list, form, marquee, flip card or hotspot, carries custom CSS or attributes, holds a class whose values can't all move, or whose values would clash with its layer's, then it stays; and no paste names a left-out frame's id in custom CSS, a trigger or a script. Test (`test/unit/plugin-wrappers.test.ts`):
  `AC13 a frame that draws, links, reacts or is a part stays and no paste names a left-out frame`
- AC14 (proposed): Given the five real saves (hydraulics, GRO, Repairs, brainstorm, Services from git 2199895) and the wrapper fixtures, converted with `asBefore.wrappers` and without, then every element both pastes hold is within 0.5 px (content box; a text by where its words start, their lines and height) with equal text settings at the design width, 1366, 1280, 1100, 900, 600, 390, 375, 360 and 320, with each hover trigger forced at the design width and 390 and scrolled 400 px; and hydraulics holds at least 45 fewer Blocks, Repairs at least 8 fewer. Test (`test/browser/plugin-wrappers-pages.test.ts`):
  `AC14 leaving wrappers out moves no element of the real pages by half a pixel at any tier`
- AC15 (proposed): Given `asBefore.wrappers`, every Figma replay is byte for byte the base's (the five saves and every fixture); and a website capture converted by the Figma converter (the panel's route) is byte for byte the base's without the switch; the plugin's own conversion still equals a replay. Test (`test/unit/plugin-wrappers-off.test.ts`):
  `AC15 with the wrappers switch a Figma paste is the base's byte for byte and a website capture never folds`
- AC16 (proposed) (live): Justin scans bdryswi.com with the new build, runs `site:import … --elementor`, re-pastes header, page and footer on B-Dry staging `/homev2/`, and in Figma converts "Hydraulic Cylinder Repairs Final" and pastes it on darksalmon: in Bricks' Structure panel the headings and texts that had a "Box" around them sit straight in their row or column; he clicks one such Heading, changes its top margin (importer) or its padding (plugin) in Style → Layout and the gap changes as a Bricks builder expects; the pages look as before at desktop, tablet and phone widths, and B-Dry's header still stays at the top while scrolling.

### Unit rows (the fixtures of `test/unit/site-fold-boxes.test.ts`: the chain W › C in `site-page-code.ts`'s kinds section, hand-built boxes at ten widths)

Each row: W's declarations, C's, the parent P, the boxes → the outcome and what C's class must hold. Row numbers are
the ones the tasks name.

| # | For | W | C | P / boxes | Outcome |
|---|---|---|---|---|---|
| 1 | AC1 | `margin-top: 24px` | none | block; W has no box, C has | folds; C `margin-top: 24px` |
| 2 | AC1 | `max-width: 600px; margin-left: auto; margin-right: auto` | none | block; equal boxes | folds; C carries the three |
| 3 | AC1 | `padding: 16px 20px` | a plain box, `padding-top: 4px` | block; W's box = C's grown 16 and 20 | folds; C `padding: 20px 20px 16px 20px`; C stands for W in the sources |
| 4 | AC1 | `padding: 16px` | `background-color: #eee` | P `display: flex`; W's box = C's grown 16 | folds; C `margin: 16px` |
| 5 | AC1 | `width: 40%; flex-shrink: 0; align-self: center; order: 2` | none | P `display: flex`; equal boxes | folds; C carries the four |
| 6 | AC1 | `position: relative; top: -4px; z-index: 3` | none | block; equal boxes | folds; C carries the three |
| 7 | AC1 | `row-gap: 20px; column-gap: 20px; justify-content: unset; flex-direction: unset` (no `display`) | none | block | folds; C's class holds no gap |
| 8 | AC1 | W1 `margin-bottom: 10px` › W2 `width: 50%` | none | block | both fold; C carries both |
| 9 | AC2 | `width: 300px` | `margin-left: -4px; margin-right: -4px` | P `display: flex`; W's box = C's less 4 each side | folds; C `width: calc(300px + 8px)` |
| 10 | AC2 | `width: 600px` | `padding-left: 5%` (painted, content-box) | P `display: flex`; equal boxes | folds; C `width: 600px`, `padding-left: 30px`, `box-sizing: border-box` |
| 11 | AC2 | `width: 50%` | `padding-left: 10%` (painted, `box-sizing: border-box`) | P `display: flex`; equal boxes | folds; C `width: 50%`, `padding-left: 5%` |
| 12 | AC2 | none (auto height) | `height: 100%` | P `display: flex`; equal boxes | folds; C's class holds no `height` |
| 13 | AC2 | `font-size: 1.25em` | `font-size: 0.8em` | block | folds; C `font-size: 1em` |
| 14 | AC2 | `font-size: 20px; line-height: 1.5em` | an `h2` whose computed (`inherited`) `font-size: 30px; font-weight: 700` differ from W's | block | folds; C `font-size: 30px`, `line-height: 30px`, bold as read |
| 15 | AC2 | `padding: 16px` | `background-color: #eee` | block | stays "pads" |
| 16 | AC3 | none | none | W's box equal to C's at every width | folds (the control) |
| 17 | AC3 | none | `margin-bottom: -22px` | P `display: flex`; W 0 tall, C 18.2 tall | stays "a box of its own that isn't its element's" |
| 18 | AC3 | none | none | W 161 tall, C 115 tall at one width | stays, same reason |
| 19 | AC3 | none, no box of its own | `margin-bottom: -22px` | P `display: flex` → stays; P block → folds (the margin passes through) | as said |
| 20 | AC3 | `padding: 16px` | plain | W's box = C's grown 16 → folds; 2 px off at 767 only → stays | as said |
| 21 | AC3 | none | none | neither has a box | stays "the capture measured no box of it" |
| 22 | AC6 | none | `position: sticky; top: 0` | W as tall as C at every width | folds; C `position: relative`, no `top`, `z-index: 0` |
| 23 | AC6 | none | `position: sticky; top: 0` | W 400 px taller than C | stays "its element is sticky" |
| 24 | AC6 | a header's root › one box › a sticky bar (alone) | | boxes equal | the root lifts; the bar as row 22 |
| 25 | AC6 | a header's root holding a strip, then a sticky bar, then a 300 px band | | measured | the root stays a Block "Header"; note "it bounds how far a sticky bar travels" |

The rows for AC4 are today's staying rows of `site-fold-boxes.test.ts` (paints, clips, a state look, a pseudo element,
another tag, words beside, other shown ranges, inline-level, floated, absolute, an item of its own) plus: `display:
flex; justify-content: center` around one element; `display: inline-block`; top margins on both in a block parent.
The rows for AC5: a labelled W folds and C shows the label; a refused chain's widget box folds while its floored holder
stays; W around a trigger folds; each hold of N6′ alone still keeps its box (and removing that hold from the keep set
fails the row).

REDs: the planner wrote no test code, so no RED was run on the base; the by-name unit comparison of the prototype
(`<E>/logs/unit-proto.tap`) shows which existing tests change. The builder proves each new test RED on a clean export
of the base before its code.

## Touched files (base: main after the five jobs in flight; paths as on `33a73f41` and `fcdec6e2`)

**New (importer):** `src/core/site/fold-moves.ts` (M0–M5: what moves and the rewrites, pure, ≤ 300 lines),
`src/core/site/sticky-room.ts` (S). **Changed (importer):** `src/core/site/fold-boxes.ts` (N2′, N4′, N5′, N6′, the
label, `standsFor`, the `moves` switch; split so it stays ≤ 300 lines), `elementor-fold.ts` (exports only:
`paddingOf`, `PAD_SIDE`; `merge` and the ten rules unchanged), `elementor-measured.ts` (export `fontPx`), `lift.ts`
(`liftOf` and `plainParts`: S2), `convert.ts` (the switch, rule N's `standsFor` and labels, `Prepared.structure`),
`structure.ts` and `parts.ts` (the notes count), `tools/site.ts` help text only if a flag is added (none planned).
**New (plugin):** `src/core/emit/wrappers.ts`. **Changed (plugin):** `src/core/emit/elements.ts` (skip a left-out
frame, the child's merged style and tiers, its label), `src/core/convert.ts` (`asBefore.wrappers`,
`ConvertResult.structure`), `tools/replay.ts` (one line).
**New tests:** `test/unit/site-fold-moves.test.ts`, `site-fold-moves-off.test.ts`, `site-sticky-room.test.ts`,
`plugin-wrappers.test.ts`, `plugin-wrappers-off.test.ts`; `test/web/site-kept-boxes.test.ts`,
`site-kept-boxes-sticky.test.ts`, `site-kept-boxes-bdry.test.ts`, `test/web/lib/box-diff.ts`;
`test/browser/plugin-wrappers-pages.test.ts`, `test/browser/lib/paste-diff.ts`; fixtures
`test/fixtures/web/sites/kept-boxes/` and `kept-boxes-elementor/`, `test/fixtures/wrappers.ts`,
`test/fixtures/fewer-kept-boxes-pins.json` and `fewer-kept-boxes-replay-pins.json` (the base's pastes and replays, by
`test/unit/lib/figma-replay-pins.ts` and the site pins' tool, recorded on a `git archive` of the base).

**Tests that pin today's behaviour (the builder may edit exactly these; found by the whole unit suite on the prototype,
by name):**
- `test/unit/site-fold-boxes.test.ts`: the three `AC5 …` tests whose rows say a margin, a padding, a size, a sticky
  element, a percentage, a relative font size or a text setting keeps the box: each such row moves to the new file
  with its new outcome (folds with the rewritten value, or stays for its narrower reason); rows that still stay keep
  their assertions.
- `test/unit/site-elementor-fold.test.ts`: "a negative margin the widget box floors at 0 refuses the fold, named; one
  the body covers still folds" and "a widget box measured taller than its body and the margins between them refuses
  the fold, named; margins that explain it still fold": the Elementor refusal and its note still hold; what they
  assert of the structure under it (the widget box now folds by rule N where the box equation holds) is updated, with
  a stronger assertion that the floored or stretched box itself stays.
- `test/unit/site-slider-unchanged.test.ts` ("pastes without an Elementor slider are byte-identical"),
  `test/unit/site-motion-old.test.ts` ("AC9 a capture made before this build pastes as before, with one note") and
  `test/unit/site-upload-cli.test.ts` ("AC7 …", `notes.txt` bytes): sums and goldens of fixture pastes; each is
  remade only after proving, per variant, that the paste with `moves: false` hashes to the old sum
  (`site-slider-base`, `site-motion-base` through their own tools).
- Web suites that read the structure or the notes (`test/web/site-cli.test.ts`, `site-no-div-plain.test.ts`,
  `site-no-div-elementor.test.ts`, `site-no-div-bdry.test.ts`, `site-native-structure.test.ts`,
  `site-native-bdry.test.ts`, `site-check-lifted.test.ts`, `site-elementor-margins.test.ts`,
  `site-elementor-pads.test.ts`, `site-elementor-pull.test.ts`, `site-elementor-stretch.test.ts`): the builder runs
  them on the base and on M1's head by name before changing any; a count of Blocks or a named kept box that moves by
  design is updated to the new count with the reason asserted, never loosened.
- Story pins that are named-only (`F2B_PIN_BASE`, `F2B_STORY_PINS`) are other jobs' receipts and are not remade.
- Plugin: `test/unit/plugin-no-div.test.ts`, `plugin-leaf-blocks.test.ts`, `plugin-labels.test.ts`,
  `plugin-looks*.test.ts`, the landing-page golden and custom-CSS share budgets (`npm test` on M3's first commit
  names them): an element count or a label that changes because a frame is left out is updated; a budget is never
  raised silently.

## Tasks

Every task: the test first (its RED run named in the ledger with the assertion that failed), then the code, the same
command GREEN, `npm run check`, one commit. Chrome runs under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0` on the desktop, `TMPDIR` ≤ 38 characters, `CHROME_PATH` set; a run that dies with 143, 137 or
"Killed" is checked against earlyoom before it is read as a result.

### Milestone 0: base and records
1. Plan copied to `docs/plans/2026-11-13-fewer-kept-boxes.md`; ledger `.superpowers/sdd/2026-11-13-fewer-kept-boxes/progress.md`;
   `npm run corpus` (the two repo files by replay and snap on this machine); the base's pins recorded on a `git
   archive` of the base: every code-fixture and fixture-capture paste (`fewer-kept-boxes-pins.json`) and the five
   Figma replays (`fewer-kept-boxes-replay-pins.json`); the whole unit suite and the web site suites' tallies on the
   base, by name, in the ledger.
2. Before pictures: `npm run site -- <kept-boxes capture> …` can't run yet (the fixture is Task 3's), so: `structure.txt`
   of the B-Dry stand-in on both routes and `npm run snap -- corpus/files/hydraulics-home.json <evidence>/builder/shots/before --sides`.

### Milestone 1: the importer's moves that the prototype proved (AC1 in part, AC3, AC4, AC5, AC10, AC11)
3. The fixture sites `kept-boxes` and `kept-boxes-elementor` (generic class names, three page sections at least, no
   name or value from B-Dry) and `test/web/lib/box-diff.ts`; AC8's test written with the sections Milestone 1 covers
   (RED: the wrappers are in the paste).
4. The switch and the off pin (the test for AC11 first: with `moves: false` equal to the pins; GREEN at once on the
   untouched rule, then kept green by every later task).
5. M0 (what says nothing). Rows 7 and the stay rows for a real flex, grid and inline-block box.
6. N6′: the label moves, a refused chain and a trigger's wrapper are judged (AC5's rows; the keep-set mutants: each
   kind of hold removed alone must fail a row).
7. N5′ the box equation (AC3's rows first, hand-built boxes: equal; floored −22 px inside a flex item; stretched 161
   against 115; no box on W with a margin on C in a flex parent and in a block parent; padding grown; 2 px off at one
   width; neither measured).
8. M1 margins (rows: one side; `margin: 0 auto` with a max width; both non-zero in a flex item add; top and bottom in
   a block container stay).
9. M3 sizes, item properties, relative position (rows: `width: 40%` with `flex-shrink: 0`, `align-self`, `order` in a
   flex row; `position: relative; top: -4px; z-index: 3`; a chain W1 margin › W2 width › C; C with a size of its own
   on that axis stays).
10. The notes count (AC10) and `standsFor` for rule N.
11. Gate: `npm run check`; the web site suites by name against Task 1's tally; AC8 (Milestone 1's sections) and AC9
    on the stand-in (the Blocks at least 30 and 100 fewer; nothing moved); the three goldens remade as "Tests that
    pin" says. Commit the ledger.

### Milestone 2: padding, the rewrites and sticky (AC1 whole, AC2, AC6, AC7, AC8 whole, AC9)
12. M2a padding onto a plain element (row 3; the stay rows: a painted element in a block parent, a `%` padding, a
    sized element) and M2b as its margin in a flex or grid parent (row 4), `standsFor` for (a).
13. The size written less the margins inside it, and `height: 100%` dropped (rows 9, 12; a unit other than px or %
    beside margins stays).
14. M4 a percentage against the outer box (rows 10, 11; an auto-width wrapper in a row stays).
15. M5 fonts and text settings (rows 13, 14; the R2-2 rows of `site-fold-boxes.test.ts` move here with their new
    outcomes; a keyword size stays).
16. S: `sticky-room.ts`, rule N's S1, `liftOf`'s S2 (AC6's rows; AC7's web test: RED on the base head is the bar at 0
    after 400 px where the site has it at −311).
17. Gate as Task 11, plus AC7, AC8 whole, AC9 with `F2B_JUSTIN_SCAN` set (hover and scroll included), mutants: each
    move, each rewrite and each clause of the box equation removed alone fails its row (under the memory cap).

### Milestone 3: the plugin (AC12–AC15)
18. `test/fixtures/wrappers.ts` (generic: a column of three sections, each case a frame around one text, heading,
    button or picture; with a sibling so labels survive) and `test/browser/lib/paste-diff.ts`; the off switch and its
    pin (AC15's test first).
19. `emit/wrappers.ts`: the plain-box test and "only lays out" for the three shapes (fills, hugs, a text at the start
    of a filling column last, as its own commit). AC12's first rows, AC13's rows; AC14 on the five saves.
20. Padding. 21. Margin. 22. Least sizes. 23. Item properties. 24. A class whose values all move. Each: its AC12 rows
    RED then GREEN, then AC14 on the five saves; a kind that moves any element and can't be narrowed in one more try
    is taken out again and written in HANDOFF "Deferred" with its measured move (the prototype's findings to start
    from: padding on hydraulics shortens one section by 1.5 px; brainstorm moved 20 px at one width; Services'
    padding sits in classes).
25. `ConvertResult.structure`, replay's line, labels (Q6).
26. Gate: `npm run check`, `npm run test:browser` by name against the base, `npm run corpus` (replay and snap of the
    two repo files, the lint per width no worse), AC14 whole (hover and scroll), the plugin = replay tests.

### Milestone 4: close
27. After pictures (`structure.txt` of the stand-in, snap of hydraulics and Repairs `--sides`, site | paste pictures
    of the fixture at 1440 and 390) into `~/.hermes/plans/figma-to-bricks/shots/fewer-kept-boxes/`, never committed;
    the counts table (base → head) for the scan, the stand-in and the five saves in the ledger.
28. Docs & records (below). Stop at `ready-for-review`.

## Overlaps and order

Build after site-no-div, site-shared-styles, plugin-parity, importer-parity and shared-palette are on main.
- **site-no-div** (`site-no-div-final` 4a4bfa17): owns rule N (`fold-boxes.ts`), rule S (`lift.ts`), `natives.ts`,
  `structure.ts`. Assumed: N1–N6 as read; `Prepared.structure`; the notes' two lines; `plainParts`' header rule.
  This job rewrites N2, N4, N5 and N6's holds and adds S; its V-1 and V-2 follow-ups close here.
- **importer-parity** (`1f407006`, building): adds `names`/`handDown` to `foldBoxes` and `foldElementor` and a
  `clashes` count. Assumed: a folded wrapper's names still go down (unchanged call); more folds mean more names
  handed down, so its `site-parity-pins` move with this job's pastes (remade as the goldens above).
- **site-shared-styles** (`7b7501bd`): shared text, button, box and layout classes from each element's class source.
  Assumed: an element that took a margin, padding or width may now share (or stop sharing) a layout class; the
  computed-style oracle in AC9 covers it. `palette.json` untouched.
- **plugin-parity** (`fcdec6e2`): Div → Block, made-up labels (`understand/labels.ts`), shared looks in emit
  (`emit/looks.ts`), `asBefore`. Assumed: looks are grouped after adapt; this job runs the wrapper decision before
  the looks are assigned to elements, so a left-out frame carries no look and its child's look is computed on the
  child's merged style (stated in Task 19; one writer per property is `plugin-looks`' own test).
- **shared-palette** (`738e300a`): colours only; no overlap but `convert.ts` lines.
- **short-class-names** and **clean-values** (planned): names and controls of classes. No rule here depends on a
  class's name; whichever merges second remakes its own pins.
Shared files, so merges need care: `src/core/site/convert.ts`, `parts.ts`, `fold-boxes.ts`, `elementor-fold.ts`,
`lift.ts`, `src/core/emit/elements.ts`, `src/core/convert.ts`.

## Risks

- The proof holds at the widths the capture measured (15 on Justin's scan); between them a box could differ. Same
  limit as rule N today; the fixture is drawn at every captured width and the guard at 0.5 px.
- The repo's renderer only approximates Bricks; the live paste is the last word (AC16).
- More folds change more class fingerprints: a re-paste brings new classes (Q9).
- The plugin's moving kinds may not all reach exactness (Q5): the plan ships what does and names the rest.
- Opened boxes and closed answers keep their wrappers until the capture measures them (Q2).
- `npm run site:live` on a page pasted before this build names the wrappers that page still holds as elements "in
  another's place": re-paste first (as after any structure change).

## Docs & records

- Plan in `docs/plans/2026-11-13-fewer-kept-boxes.md`; the ledger moved by the finisher to
  `docs/plans/2026-11-13-fewer-kept-boxes-ledger.md` before the final premerge commit.
- `docs/HANDOFF.md`: a new section above the previous top heading (the rule in plain words, the moves, the box
  equation, what stays and why, the counts base → head, the ⭐ rulings "not yet confirmed", Deferred: opened boxes
  and closed answers, any plugin kind left out, words in a `li` or `label` as a Block around a Rich Text), and its
  paste check at the top of "End-of-run check list": the next free id at the merge (3ej is free on main today; the
  five jobs in flight take theirs first).
- `BUILD` bumped at the merge; `npm run build`.
- Main `CLAUDE.md` Status: the build line and one line for this feature with its paste check. Standing rules to add:
  "**A website paste leaves out a wrapper only by rule N's moves and the box equation** (`fold-moves.ts`; a new move
  needs its unit row, its fixture section and the 0.5 px guard)"; "**The plugin leaves a frame out only at emit**
  (`emit/wrappers.ts`): understand, style and adapt never see it; never on a website capture"; and in "Website
  captures": "a sticky element with no room to travel is written `position: relative` when its box goes".
- `~/.hermes/skills/software-development/figma-to-bricks/references/rules-summary.md`: the finisher returns the
  proposed one-line edit; the main session saves it.
