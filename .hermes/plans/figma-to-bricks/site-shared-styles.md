# site-shared-styles: an importer paste whose looks live in shared classes and palette colours (plan, 2026-11-11)

Planner: site-shared-styles (Fable 5.2, high). Pipeline: **Full**. Website importer rules apply (repo CLAUDE.md: one
real-bug review per job, edge cases to follow-ups).
**Base: `main` once `site-no-div` has merged** (its plan: `~/.hermes/plans/figma-to-bricks/site-no-div.md`; its base is
site-native-structure, today `site-native-structure-stack6` `e6bcfed6`; main is `02481763`, Build 2026-11-11.3). Every
file:line below is from the planner's prototype tree, which is site-no-div's own prototype (`~/.cache/snd/p4`: every box
a Block, a span of words a Rich Text, Button and Text link by shape, the neutral-wrapper fold) plus this job
(`~/.cache/sss/proto`); the builder re-reads each on its real base before editing.
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/planner/` (`README.md` lists every
file; the three new source files and the prototype's diff are in `<P>/proto/`, sums in `<P>/sha256.txt`).
Plan copy for the repo: `docs/plans/2026-11-11-site-shared-styles.md` (the builder copies this file there in Task 1).

## Playback

1. After a paste Justin wants to change a thing once and see it change everywhere: click a text, change the font in
   its class, and every text with that class follows; change a colour, and every place that shows it follows.
2. Today every element of a scanned page has its own class holding everything about it, and every colour is written
   out again in each place, so a change is made element by element.
3. This job gives words, buttons, boxes and layouts that look the same one shared class each, links every colour to a
   Bricks palette colour, and makes words Rich Text (headings stay Headings), for any scanned site, with the page
   still looking exactly as before.

## Questions (⭐ = the answer the standing auto-go takes)

1. **When do two texts "look the same"?** ⭐ **A:** when they draw with the same font, size at every width, weight
   and line height (plus letter spacing, case and slant where the site sets one), read from what the browser really
   drew, so it doesn't matter whether the site set the font on the text itself, on a box around it or on the whole
   page. No tolerance: 16px and 17px are two looks. The colour is not part of the text class: it is linked to the
   palette (a white heading and a blue heading share one class). B: the colour inside the text class too (about 4
   more text classes on B-Dry, and a class per colour of each heading).
2. **How many elements must share a look before it is a class?** ⭐ **A:** 2 for words and buttons, 3 for boxes and
   layouts (a class for a pair of boxes helps nobody). A look fewer elements have stays in the element's own class,
   as today ("a button that looks different gets its own"). B: 2 everywhere (about 5 more box and layout classes on
   B-Dry). C: 3 everywhere.
3. **Class names.** ⭐ **A:** the page's name, the purpose, then four letters made from the class's own rules:
   `home__h2-rtek`, `home__text-clir`, `home__button-xmub`, `home__card-ocmj`, `home__column-heff`. The letters keep a
   name on one look for good: a later scan never gives the name to another look, and Bricks only asks "Import
   classes" about a class Justin changed himself (answer "keep" to keep his change). B: numbered by use (`home__h2`,
   `home__h2-2`): nicer to read, but a page that gains one look renumbers the others (the planner's run: adding one
   embed to a fixture page renamed its header's text class), so the same name would mean another look after a
   re-scan and Bricks would ask on every re-paste.
4. **Palette colour names.** ⭐ **A:** the page's name and the colour's hex: `--home-004774`, in a palette named
   `home (bdryswi.com)`, one palette per scanned page (as two pages share no class). The hex keeps a name on one
   colour for good. B: colour words (`home-blue`, `home-orange-2`): on B-Dry that gives `blue` to `blue-13`, and a
   re-scan can move a name to another colour, which would show the wrong colour until the palette is imported again.
5. **Which colours go in the palette?** ⭐ **A:** every solid colour the page's classes show, even one used once (22
   on B-Dry). See-through colours (a 50% black overlay), `transparent` and colours inside a drawing's own markup stay
   as the site wrote them. B: only colours two or more elements show (18).
6. **A link that is only words** (site-no-div makes an unpainted one Bricks' Text link). ⭐ **A:** a Block that
   carries the link with a Rich Text inside, as on the Figma route ("i want the text to be rich text"); a painted
   link stays a Button. This changes site-no-div's Q3 A for unpainted links only; if site-no-div is built with its
   Q3 B there is nothing to change. B: keep Bricks' Text link for menu and footer links (it carries the same text
   class).
7. **Where it applies.** ⭐ **A:** every paste the code method makes, with no flag: `npm run site`, `site:upload`,
   `site:import`, section pastes, the plain route and `--elementor`, the boxes a button opens. The Figma panel's
   website route and every Figma design stay byte for byte. B: behind a flag.

## What Justin will see (the planner's prototype on his 2026-11-11 capture, `--elementor`)

495 elements, as after site-no-div. **57 shared classes** carried by 234 of the 495 elements
(`<P>/run-justin-el.txt`):

| Kind | Classes | On | Examples (what the class holds) |
|---|---|---|---|
| Text | 17 | 88 of the 120 elements that draw words | `home__heading-mhrv` ×15 (Roboto 600, 20px, line height 26px), `home__text-clir` ×8 (Roboto 400, 21px, 16px on phones, 1.65), `home__h2-asmj` ×5 (50px, 21px on phones) |
| Button | 5 | 15 of 23 Buttons | `home__button-xmub` ×5 (white, blue words, 15px 500, padding 12/24, its hover), `home__button-eaib` ×3 (blue, gold words) |
| Box | 21 | 99 boxes | `home__card-ocmj` ×6 (gold background, padding 35), `home__container-xbxl` ×8 (padding 10/0), `home__section-gduo` ×5 |
| Layout | 14 | 84 boxes | `home__column-heff` ×13 (flex, column, no wrap), `home__row-bmmw` ×8 (flex, centred), `home__grid-dfbt` ×3 |

The 32 texts, 8 buttons and the boxes whose look no other element has keep it in their own class, as today. Every
element still has its own class for what is only its own (margins, position, sizes, order), so the class list grows
from 309 classes to 362 (305 of them own, 57 shared) while each shared look is written once instead of 2 to 15 times.
**22 palette colours** in `palette.json` (`--home-004774` blue on 94 elements, `--home-ffffff`, `--home-ffb356` gold,
…), each place written as `var(--home-004774, #004774)` so the page looks right before the palette is imported. The
plain route of the same capture: 654 elements, 60 shared classes (19 text, 1 button, 25 box, 15 layout) on 268
elements, 22 colours (`<P>/run-justin-plain.txt`).

**Nothing moves (measured on the B-Dry stand-in, `evidence/site-native-structure/inputs/standin-capture-0581852c.json`):**
- `site:check --all --elementor`: all 114 rows (3 parts × 38 widths) equal to site-no-div's prototype, and the two
  `report.json` files equal leaf for leaf (`<P>/chk-looks-el.log`; the base's known rows, the footer's 69 px and the
  page's 64 px, are footer-icon-list's and unchanged).
- The stronger check this plan makes a test (`<P>/style-diff.ts`): the same capture converted with the shared classes
  and the palette off and on, both drawn with Bricks' front-end CSS, and **every element's computed style (every
  property, its `::before` and `::after`) and box compared**: 8,688 element readings at 12 widths, 0 differ, with the
  classes (`<P>/style-diff-standin-el-2.log`); with the classes and the palette, 2,896 readings at 4 widths, 0 differ
  on the Elementor route (`<P>/style-diff-standin-el-palette.log`) and the plain route
  (`<P>/style-diff-standin-plain-palette.log`). The first run (`<P>/style-diff-standin-el.log`) showed the one shape
  the check must leave out: a flat Rich Text's wrapper (`display: contents`, no box) now carries its text class, so
  its own computed font changed while its paragraph, the only thing drawn, did not.

## Why it is one class per element today (file:line, prototype tree)

1. `src/core/site/convert.ts` `prepare` builds one class per site element from all its declarations (the loop from
   `for (const t of tree.nodes)`: `blocksOfStates(states)` → `controlsFor` → `ClassCss`), and `nameClasses` gives two
   elements one name only when the whole class is equal within one section's scope (`convert.ts` "identical classes
   (same settings and CSS, within one scope) share one name"). Two paragraphs with the same font and other margins
   are two classes.
2. A class holds only what the site **declared** on that element (`CodeNode.decls`); what it inherits (the body's
   font, a wrapper's colour) sits on a box above it, or on each part's top elements (`withInherited`, `convert.ts`).
   So a paragraph's font is often in no class of its own at all. Measured on Justin's capture: the biggest group of
   words by declared typography is 23 elements that declare only `font-size: 100%; font-weight: 400; font-style:
   inherit` (a reset), while by what they draw with they are five different looks (`<P>/an.py`).
3. Colours are written as plain text in every class (`controls.ts` `colourOf` → `{hex}`/`{rgb}`; custom CSS as the
   site wrote it). The Figma route's palette (`src/core/emit/palette.ts`, `src/core/model/palette.ts`) is not used by
   `src/core/site/`.
4. Words: the code method already writes Rich Text in its default mode (`kinds.ts` `rich`, `asTyped`); after
   site-no-div the one text element that is neither a Heading, a Rich Text nor a Button's own words is the Text link
   (`kinds.ts`: `outer(ctx.native.painted(path) ? "button" : "text-link", …)`).

## The grouping rule (one rule set for every scanned site)

Read from structure, declared CSS and the capture's computed text settings only: never a site's ids, class names or
words. It runs once per page, over the header, the page and the footer together (one class table, as today), after
the Elementor step, the fold and the tree, and before the classes are named.

**R1. Four kinds of look, each a fixed list of properties** (`looks.ts`):

| Kind | Elements | Properties the look takes | Shared from | Named |
|---|---|---|---|---|
| text | every element that draws words and carries a class: Heading, Rich Text, a Block around words (`li`, `label`, a link), Basic Text in the proof's mode | font family, size, weight, slant, line height, letter spacing, case: **the values the capture's browser drew with** (R2) | 2 | `h1`…`h6` when every element is a Heading of that tag, `heading` for mixed Headings, else `text` |
| button | Bricks Button | everything but where it sits (R3): its text values and colour as drawn, its background, border, corners, shadow, padding, display, its `::before`/`::after`, its absorbed parts, and what its own hover and focus change | 2 | `button` |
| box | Section, Container, Block (a site box) | `background*`, `border*` (corners too), `box-shadow`, `padding*`, when it paints or pads something (a look of only `border-radius: 0` or `background-image: none` is never a class) | 3 | `section` or `container` when only those carry it, `card` when it paints (a background, a border, a shadow, round corners), else `box` |
| layout | Section, Container, Block (a site box) | `display`, `flex-direction`, `flex-wrap`, `flex-flow`, `justify-content`, `justify-items`, `align-items`, `align-content`, `place-items`, `place-content`, the gaps, `grid-template*`, `grid-auto*`, when it is a flex or grid box at some width | 3 | `grid`, `column` or `row` by its widest flex or grid range |

**R2. A text's values are what it draws with**, per kept range: the body's computed text settings
(`web.code.context`), then each ancestor's and its own computed changes (`CodeNode.inherited`; the chain `weightsOf`
already folds for the weight). So words that look the same share a class however the site declared it. A property
is **left where the site wrote it** (not in the look) when:
- its value is the browser's own at every width (`font-style: normal`, `letter-spacing: normal`,
  `text-transform: none`);
- it can move with the window inside one range: the element or an ancestor declares it, or the font size, with `vw`,
  `vh`, `vmin`, `vmax`, a container unit, `clamp()`, `min()` or `max()` (the computed value is read at one width per
  range; size, line height and letter spacing only);
- the element doesn't declare it itself and an ancestor's hover or focus changes it (the change would stop at the
  written value);
- the element declares the `font` or `all` shorthand (a longhand in another class would meet it).
The weight is written as a whole hundred through `fonts.ts` `weightOf`, as every weight of a paste.
Measured: 0 of Justin's capture's declarations are fluid, and its 2,402 declared px font sizes all equal the computed
value (`<P>/README.md`).

**R3. Where an element sits is never shared:** margins, `position` and its offsets, `z-index`, `float`, `clear`,
`align-self`, `justify-self`, `place-self`, the flex item properties, `order`, the grid item properties, width,
height and their minimums and maximums stay in the element's own class, with everything no look takes (text align,
overflow, transitions, transforms, opacity, a `::before`/`::after`, the words' inline elements, an entrance, a look
an ancestor's hover sets).

**R4. The same look = equal as written, at every kept range and under every state of its own, no tolerance.** Two
elements share a look when the class it would make is the same class: the same Bricks controls and the same custom
CSS (colours compared as the site wrote them). A look enough elements carry (R1's count, over the whole page) is one
class; else its properties stay in the element's own class exactly as today.

**R5. One writer per property.** A property an element gives to a look leaves its own class whole: every range, and
what its own hover or focus changes of it. Each property belongs to at most one kind (the lists in R1 are disjoint;
a Button gives everything to one class), so no two classes of one element ever declare the same property under the
same condition, and the order Bricks prints classes in can't matter. A look an ancestor's state sets on the element
stays in the own class under `.<trigger>:hover .<own>` (0,3,0), which beats any class's base rule as it does today.

**R6. Where the classes print.** A shared class is on the Bricks element itself, before its own class:
`_cssGlobalClasses: [<root classes>, site-text/site-flat, <text | button | box look>, <layout look>, <own>]`. A text
class on a flat Rich Text (a `p`) sits on the wrapper Bricks prints: every text property is inherited, the wrapper is
`display: contents`, and the `p` no longer declares them, so they pass down; Typography controls can therefore be
used even there (today a flat `p` gets no control at all). Bricks prints a class's controls once per element name
that carries it (`.<class>.brxe-heading`, `.<class>.brxe-text`): read in Bricks 2.2's `includes/assets.php`
L1027-1068 and L3726-3727 (`<P>/bricks-2.2/assets.php`), which settles `reference/bricks/README.md` "Not read: what
Bricks prints for one class used by two element names".

**R7. Controls or custom CSS:** unchanged (`controls.ts`): a plain value that changes only on Bricks' breakpoints is
a control, else the class's CSS. On B-Dry the 17 text classes hold the font, weight and line height in Typography
and the size too where it changes at 767; a size that changes at the site's own 1024 or 1366 is in the class's CSS
(still one place). More controls are site-no-div's later job `site-controls`.

## The class and palette design

**Names** (Q3 A): `<page>__<purpose>-<4>` through `classes.ts` `versioned(base, rules)` (the Elementor route's own
naming), on both routes: the fingerprint is of the class as written (controls, CSS, palette links). A fingerprint
another class took moves on with a salt, as `nameClasses` does. Own classes are named as today, their fingerprints
(Elementor route) or numbers (plain route) taken after the shared names, so no own class takes a shared name.

**One page, one decision.** `siteParts` shares over its three parts. `siteToBricks` (one section) counts over the
whole page too (it prepares the parts for the count; a part that can't be mapped is left out of it) and writes only
the section, so a class a section paste and a page paste both hold has the same name, id and settings (the promise
`test/unit/site-elementor-names.test.ts` pins; the prototype's section pastes broke it until they shared the
page's decision).

**Palette** (`colours.ts`, the Figma route's shapes: `emit/palette.ts` `PaletteFile`, `model/color.ts` `cssColor`):
- Colours are found in the classes' typed declarations (their blocks, pseudo elements, inline elements, parts, the
  state looks, an entrance's blocks) and colour controls, only in properties that hold colours (`color`,
  `background*`, `border*`, `outline*`, `box-shadow`, `text-shadow`, `text-decoration*`, `fill`, `stroke`, …): hex
  (3, 4, 6, 8 digits), `rgb()`/`rgba()`, `hsl()`/`hsla()`, `white`, `black`. A colour with any transparency,
  `transparent`, `currentcolor`, any other colour word, and colours inside `@keyframes`, a slider's or FAQ's added
  look and a Code element's markup stay as written (named in the notes when any; follow-ups).
- Each solid colour is one palette colour: variable `--<page>-<hex lower case>`, id a hash of
  `site-color:<page>:<#HEX>` (`assignIds`), the list most used first (by elements), then by hex.
- A colour control holds `{ id, raw: "var(--home-004774, #004774)", light: "#004774" }`; custom CSS holds
  `var(--home-004774, #004774)` in place of the colour, inside a gradient or a shadow too; the fallback is the colour
  as the site wrote it.
- `palette.json`: Bricks' own export shape `{ id, name: "<page> (<host>)", colors: [{ id, raw: "var(--home-004774)",
  light: "#004774" }] }` (`reference/bricks/README.md` "Colour palettes"), written beside the pastes; `styles.txt`
  lists every shared class (its uses and main values) and every palette colour (its uses).
- **How it is proven.** Read in Bricks 2.2's `assets.php` (`<P>/bricks-2.2/assets.php`): an imported palette colour
  prints `:root { --home-004774: #004774; }` (`generate_inline_css_color_vars`, L742-834); an element or class
  colour with an `id` the site's palette holds prints the palette's own `var(--home-004774)`, and one whose `id` it
  doesn't hold prints its own `raw`, the variable with the fallback (`generate_css_color`, L845-871). So the paste
  shows the right colours before the import and follows the palette after it. The import's file shape was read in
  Bricks 2.4.1's builder code (README). Not yet seen on a real site: the last criterion (live) is its proof on
  Bricks 2.4.2; the tests model both states (the variable undefined, and defined in `:root` as Bricks prints it).

**Rich Text** (Q6 A): `kinds.ts` keeps Button for a painted link of plain words and sends an unpainted one to the
existing "words in a tag Rich Text can't print" shape: a Block with tag `a` and the link (site-no-div labels it
"Link") holding one flat Rich Text. Inline links and spans inside words stay where they are today: rewritten by
`links.ts` `wordsLinks`, typed characters through `emit/editor-text.ts` `asTyped`, each inline element's own look at
its place in the Rich Text's `p` (`> p > :nth-child(k of :not(wbr))`, `classes.ts` `inlineSel`), in the element's
own class. `--basic-text` stays the proof's switch.

**Notes** (per part, after site-no-div's `Structure:` line): `Shared styles: <n> classes on <m> of <k> elements
(<a> text, <b> button, <c> box, <d> layout); change one in Bricks and every element carrying it follows` and
`Colours: <p> palette colours; import palette.json once (Bricks → Style Manager → Colors → Import), then a colour
changed there changes every place`, plus one line naming what stays plain when any.

**Limits, named in HANDOFF "Deferred":** an own class left with nothing is still written (none on B-Dry, either
route); words beside elements (a Rich Text with no class) carry no text class; see-through tints of a palette
colour; colours in keyframes, slider and FAQ looks and svg markup; a name that tells the size (`text-18`); text
classes for fluid type.

## Overlaps and order

| Job | State | Shared files | How they meet |
|---|---|---|---|
| site-no-div (base) | planned | all of `src/core/site/` | merges first. This job assumes from it: no Div (`block`), `ConvertOptions.native`, the `text-link` and Button-by-shape branch in `kinds.ts`, its labels and `Structure:` note, `tools/lib/site-write.ts` writing `structure.txt`, its fixtures `plain-natives` and `elementor-natives`, its pins files. If it lands with other names, the builder maps them and says so in the ledger. Its tests that expect a Text link for an unpainted link change with Q6 A (named under Touched files) |
| media-clickable (Mini) | running | `convert.ts` (its Background image step before `blocksOfStates`), `test/browser/render.ts` | this job moves "declarations → a class's controls and CSS" into `class-source.ts` `fromStates`, used by own and shared classes. Whoever merges second puts the Background image step inside `fromStates` (so a box look holding the picture gets the setting, and looks compare with it) and reruns both jobs' tests |
| site-scroll-lock, site-sticky-header (Minis) | running | `parts.ts` (`classIdsOf([...])`, the root classes handed to `payloadOf`), `classes.ts` | their classes are root classes; this job adds the shared names to the `classIdsOf` list and puts looks after the root and plugin classes on each element. Keep all on a rebase |
| site-menu-motion (Mini) | running | `opens.ts`, `open-paste.ts` | an opened box is prepared apart: its elements take the page's shared classes by the page's decision (`applyLooks` with the page's keys), its own selectors keep naming own classes |
| site-controls, site-icons (site-no-div's later jobs) | not planned | `controls.ts` | more controls land in `fromStates` for both kinds of class |

Order: … → site-no-div → **site-shared-styles**. The builder starts only when `git log main` holds site-no-div's
build commit, and rebases onto main before `ready-for-review`.

## Acceptance criteria (all **proposed**)

Fixtures are generic, never copies of B-Dry. "Drawn" means as `site:check` draws a paste (Bricks' front-end CSS, the
hostile theme, pictures from the capture's bytes). "The switch off" is `ConvertOptions` `{ looks: false, palette:
false }`, a test and diagnosis switch no command line can set.

- AC1 (proposed): Given a page where words draw with the same font, size at every range, weight and line height, one by its own rule, one through a box around it and one through the body, each carries the same shared text class holding those values (Typography controls where plain and on Bricks' breakpoints, else the class's CSS) and its own class holds none of them; words of another size get another class; a look only one element has stays in its own class; a slant, letter spacing or case the browser's own at every width is not in the class; a size set with `clamp()` or `vw`, a property an ancestor's hover changes for words that don't declare it, and words declaring the `font` shorthand keep that property where the site wrote it; a 550 weight is written 500 or 600 as `weightOf` says. Test `test/unit/site-text-looks.test.ts` "words that draw alike share one text class, however the site declared it".
- AC2 (proposed): Given three Buttons, two alike and one with another background, the two share one button class holding their words' font and colour, background, border, corners, padding, display, their `::before` and what their hover changes, their own classes holding only where they sit (margin, width, `align-self`, position); the third keeps everything in its own class. Test `test/unit/site-button-looks.test.ts` "buttons that look the same share one class; a button that looks different keeps its own".
- AC3 (proposed): Given boxes, three or more with the same background, border, corners, shadow and padding share one box class (named `card` when it paints, `section` or `container` when only those carry it, else `box`) and three or more with the same flex or grid one layout class (`row`, `column`, `grid`); two alike share none; a look that paints and pads nothing (only `border-radius: 0`, `background-image: none`, `padding: 0`) and a layout that is never flex or grid are no class; margins, sizes, position and order stay in the own class. Test `test/unit/site-box-looks.test.ts` "three boxes with one look share a box class and a layout class; a pair and an empty look share none".
- AC4 (proposed): Given any paste of any code fixture (both routes, both text modes, parts and sections), for every element the properties its shared classes took and the properties its own class still declares are disjoint, at every range and under every state of its own, and together they are exactly the declarations the element had with the switch off (a text class's values being the drawn ones). Test `test/unit/site-looks-one-writer.test.ts` "no two classes of one element write one property, and nothing is lost or added".
- AC5 (proposed): Given a page's pastes, every shared class is named `<page>__<purpose>-<4 letters of its rules>` with the purposes of the rule's table; a class the header, page and footer pastes or a section paste and a page paste both hold has the same name, id and settings; no own class has a shared class's name; adding an element to the page changes no other look's name; the same capture converted twice gives byte-identical pastes. Test `test/unit/site-look-names.test.ts` "a shared class is named by its purpose and its rules, the same in every paste of the page".
- AC6 (proposed): Given a page's classes, every solid colour they show (hex, `rgb()`, `hsl()`, `white`, `black`; in a control, a custom CSS value, a gradient stop, a shadow, a hover look) is one palette colour `--<page>-<hex>`: a colour control holds `{ id, raw: "var(--<page>-<hex>, <as written>)", light }`, custom CSS `var(--<page>-<hex>, <as written>)`; a see-through colour, `transparent`, `currentcolor`, a colour word inside a font or animation name and a `url()` are untouched; the palette file is `{ id, name: "<page> (<host>)", colors: [{ id, raw: "var(--<page>-<hex>)", light }] }`, most used first, its ids the same on every run and different for another page. Test `test/unit/site-palette.test.ts` "every solid colour of a page's classes is one palette colour, linked with the colour as its fallback".
- AC7 (proposed): Given the fixture sites `shared-looks` (new), `plain-natives` and `elementor-natives` (site-no-div's), each captured and converted with the switch off and on, drawn with Bricks 2.4.2's front-end CSS and with 2.3.9's at every width the capture read: every element that takes a box has the same computed style (every property, its `::before` and `::after`) and the same box in both drawings, and every part of the paste with the switch on is within 2 px of the site. Test `test/web/site-shared-styles.test.ts` "with the shared classes and the palette every element draws as without them, at every width, Bricks 2.4.2 and 2.3.9".
- AC8 (proposed): Given the `shared-looks` paste drawn at 1440 and 390, changing one value in one shared class (a text class's font size, a button class's background colour, a box class's padding, a layout class's gap) changes that property's computed value on every element that carries the class and on no element outside those elements. Test `test/web/site-shared-styles.test.ts` "changing one shared class changes every element that carries it and no other".
- AC9 (proposed): Given the `shared-looks` paste drawn at 1440 and 390, with the palette not imported (no variable defined) every element draws as with the switch off; with one palette colour's variable defined in `:root` to another colour, as Bricks prints an imported palette, every element whose classes link that colour shows the new colour in the property that held it (a text, a background, a border, a gradient stop) and no other element's colours change. Test `test/web/site-shared-styles.test.ts` "changing one palette colour changes every place that shows it and no other".
- AC10 (proposed): Given any paste in the default mode, every element that holds words is a Rich Text, a Heading with its tag or a Button with its words: no Basic Text and no Text link; a linked `a` of plain words whose box isn't painted is a Block with tag `a` and the link holding one Rich Text and draws within 2 px of the site with its hover look; an inline link and span inside words keep their own look at their place in the Rich Text's `p`, and typed quotes and dashes go through `asTyped`. Test `test/unit/site-rich-text.test.ts` "words are Rich Text, a Heading or a Button's own words in every paste: no Basic Text, no Text link".
- AC11 (proposed): Given B-Dry's saved 2026-10-29 home served on 127.0.0.1 (never the live site; the stand-in capture of the base's B-Dry test), with the Elementor step and without it: the pastes hold shared classes of all four kinds and a palette, every element that takes a box draws as with the switch off at one width per range (Bricks 2.4.2 and 2.3.9), and no `site:check` row is worse than the base's by more than 0.5 px. Test `test/web/site-shared-styles-bdry.test.ts` "B-Dry's saved page draws the same with the shared classes and the palette, on both routes" (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, optional `F2B_ELEMENTOR_STANDIN`).
- AC12 (proposed): Given the switch off, every paste of every code fixture (the list `test/unit/lib/site-pins.ts` gives) is byte-identical to the paste Milestone 1's head makes (the base plus only the Rich Text change). Test `test/unit/site-shared-styles-off.test.ts` "with the shared classes and the palette off every paste is byte for byte as before them" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC13 (proposed): Given any Figma design and the Figma panel's website route, the conversion is byte-identical to the base's (`npm run corpus` no worse, `test/unit/plugin-convert.test.ts` passes). Test `test/unit/site-shared-styles-figma.test.ts` "every Figma replay and the panel's website route are byte-identical to the base's" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC14 (proposed): Given `npm run site`, it writes `palette.json` (the palette file) and `styles.txt` (every shared class with its uses, every palette colour with its uses) beside the pastes, each part's notes hold the `Shared styles:` and `Colours:` lines, a section paste writes the same two files, and the usage lines are unchanged. Test `test/web/site-cli.test.ts` "site writes palette.json and styles.txt, and the notes name the shared classes and the palette".
- AC15 (proposed) (live): Justin converts bdryswi.com's scan with the new build (`--elementor`), imports `palette.json` in Bricks on B-Dry staging (Style Manager → Colors → Import), empties `/homev2/` and pastes header, page and footer: the page looks as before; he clicks a paragraph, picks its text class, changes the font family there, and every text carrying that class changes; he changes one palette colour (the blue `home-004774`) in Style Manager → Colors and every place that showed it follows. Test: Justin's paste check `<site-shared-styles id at merge>` (HANDOFF "End-of-run check list").

RED on the base: the first eleven criteria and the fourteenth (no shared class, no palette, a Text link). Regression
pins: the twelfth and thirteenth (recorded in Tasks 1 and 3).

## Architecture

Pure, in `src/core/site/` (built-ins only; nothing under `src/core/emit`, `adapt`, `style`, `src/plugin` or `src/ui`
changes). Every command reaches it through `siteParts` / `siteToBricks` and `tools/lib/site-write.ts`.

New files (the prototype's, in `<P>/proto/`; copy them, then make the changes this section names):
- `looks.ts` (109 lines): `candidatesOf(code, pr, path, el, kind, own, self)` → an element's candidate looks
  (`Candidate { kind, props, states, self, whole? }`), `textValues`, `drawnText`, `purposeOf`, `MIN_USES`. Add to the
  prototype: the weight through `weightOf` (a `weight: (value, range index) => string` argument of `textValues`).
- `share.ts` (50 lines): `shareLooks(list, page, taken)` → counts every candidate's class over the page, names the
  shared ones, and rebuilds each carrier's own class without what its looks took. Change from the prototype: split
  in two exported steps, `lookKeys(count: Prepared[]): Map<string, Row>` (the page's decision) and `applyLooks(list:
  Prepared[], rows, names)` (so a section paste and an opened box take the page's decision); the fingerprint is taken
  of the class as written with the palette (below).
- `colours.ts` (98 lines): `colourOf(tok)`, `coloursIn(property, value)`, `siteInk(page, host, colours)` →
  `SiteInk { css(property, value), setting(value), file(), names }`, `NO_INK`, `inked(settings, ink)`.
- `class-source.ts` (new, about 60 lines; the prototype holds it as two closures in `prepare`, `rest` and `lookOf`):
  ```ts
  // what one element's class is built from, kept so it can be built again without what a shared look took
  export interface ClassSource { el: string; inner: boolean; where: Where; states: CodeDecls[]; self: StateCss[];
    keep: ReadonlySet<string>; families?: ReadonlySet<string>; css: ClassCss; extra: unknown[] }
  // declarations per kept range → a class's controls and custom blocks (the one place; media-clickable's step joins here)
  export function fromStates(states: CodeDecls[], el: string, inner: boolean, ranges: string[], o: ControlOptions): Split
  // the element's own class without the properties its looks took (whole: a Button's pseudo elements, inline elements and parts went too)
  export function ownClass(src: ClassSource, given: Candidate[], ranges: string[]): { settings: Settings; css: ClassCss }
  // a candidate's class: its states through fromStates (never inner: a text class sits on the Bricks element), its own states' changes
  export function lookClass(src: ClassSource, c: Candidate, ranges: string[]): { settings: Settings; css: ClassCss; where: Where }
  // a class's naming key as written: its controls and CSS with the palette's links
  export const classKey = (settings: Settings, css: ClassCss, where: Where, extra: unknown[], ink: SiteInk): string =>
    JSON.stringify([inked(settings, ink), customCss("\u0000", css, where, ink), ...extra]);
  ```
  `ownClass` and `lookClass` are the prototype's `rest` and `lookOf` (`<P>/proto/proto-vs-site-no-div-p4.diff`, the
  `convert.ts` hunk), taking `src` in place of the loop's variables.

Changed files:
- `convert.ts`: `ConvertOptions.looks?: boolean; palette?: boolean` (default on). `prepare` stores each element's
  `ClassSource` and `candidatesOf(...)` in its spec (`src`, `cands`) beside the class it builds today (through
  `fromStates`, byte for byte). `nameClasses(list, baseOf, scopeOf, pr, ink)` writes each class with
  `customCss(name, css, where, ink)` and `inked(settings, ink)` and fingerprints `classKey(...)`. `payloadOf` puts an
  element's shared class ids before its own and lists the shared classes in first-use order. `siteToBricks`: prepares
  the page's parts for the count (`lookKeys`), applies it to the section, takes the page's ink, and returns
  `palette?: PaletteFile` and `styles`.
- `classes.ts`: `customCss(name, css, at, ink = NO_INK)`; its one `rule` writer maps each value through
  `ink.css(property, value)` (the prototype's hunk). `states.ts` `withStates(p, names, settingsOf, ink)` writes its
  triggered rules' values through `ink.css` too.
- `parts.ts`: `sitePage(capture, opts): { parts: PartsResult; palette: PaletteFile | null; styles: SharedLook[] }`
  holds today's body plus: `lookKeys` and `applyLooks` over the prepared parts, the colours collected from every
  spec's typed CSS and colour controls and from the shared classes (the prototype's `see`), `siteInk(page, host,
  …)`, the shared names added to `classIdsOf`. `siteParts = (c, o) => sitePage(c, o).parts` (every caller unchanged).
- `controls.ts`: no rule changes; `fromStates` calls `controlsFor`.
- `kinds.ts` (Q6 A): the Button-or-Text-link line returns a Button only when painted; an unpainted link falls to the
  Block-with-Rich-Text line below it.
- `open-paste.ts` (main): an opened box's prepared root goes through `applyLooks` with the page's rows and is named
  with the page's ink.
- `tools/lib/site-write.ts`: `writePastes` and `writeSection` write `palette.json` and `styles.txt` and print one
  line for each; `writePastes(capture, outDir, o, made?)` takes `sitePage`'s result where it took `siteParts`'s
  (main's two callers, `tools/site.ts:40` and `tools/lib/site-upload/flow.ts:181`, pass none: unchanged).
- `test/unit/site-isolation.test.ts`: the allow-list of what `src/core/site/` may import gains exactly
  `../emit/palette.ts` (a type) and `../model/color.ts`.
- `reference/bricks/README.md`: "Class selectors" and "Colour palettes" say what was read in 2.2's `assets.php`.

## Touched files

New: `src/core/site/looks.ts`, `share.ts`, `colours.ts`, `class-source.ts`; `test/fixtures/site-looks-code.ts`;
`test/fixtures/web/sites/shared-looks/` (`index.html`, `style.css`); `test/unit/site-text-looks.test.ts`,
`site-button-looks.test.ts`, `site-box-looks.test.ts`, `site-looks-one-writer.test.ts`, `site-look-names.test.ts`,
`site-palette.test.ts`, `site-rich-text.test.ts`, `site-shared-styles-off.test.ts`,
`site-shared-styles-figma.test.ts`; `test/web/site-shared-styles.test.ts`, `site-shared-styles-bdry.test.ts`,
`test/web/lib/style-equal.ts`; `test/fixtures/site-shared-styles-pins.json`, `site-shared-styles-replay-pins.json`.
Changed: the source files above; `test/web/site-cli.test.ts` (one new test); `docs/HANDOFF.md`; the plan copy and
ledger.

**Existing tests this job changes on purpose** (the planner ran the whole unit suite on the prototype beside its
base, by test name: 5 tests in 3 files moved, `<P>/unit-p4.tap`, `<P>/unit-proto.tap`; the builder runs it on its
real base and applies the same three rules, naming each file in the ledger; anything else that fails is a stop):
1. A test that reads one property from an element's own class (`test/unit/site-elementor-button.test.ts` "an
   Elementor button widget is one Bricks Button with its words and link" and "a Button stands for its widget box only
   where its place is proven…") reads the element's classes together; its assertion stays as strong.
2. A test that lists the class names it allows (`test/unit/site-elementor-names.test.ts` "no class of the Elementor
   step's pastes is a bare name…") also allows `<page>__<purpose>-<4>`; the import allow-list
   (`test/unit/site-isolation.test.ts`) gains the two modules.
3. A whole-paste golden or sum of the default suite (site-no-div's and the earlier jobs': `test/fixtures/
   site-slider-base/`, `site-motion-base/`, `site-basic-golden.json`, `site-native-pins.json`,
   `site-no-div-pins.json`, `site-no-revert-main.json` through `node tools/site-no-revert-golden.ts .`) is made again
   through its own generator **only after** the twelfth criterion's pin is green (the paste without the shared styles
   is the old one), reason "shared classes and palette". Story pins (env-gated) of merged jobs are not regenerated.
4. With Q6 A: site-no-div's expectations of a Text link (`test/unit/site-native-kinds.test.ts`,
   `test/web/site-no-div-plain.test.ts`, the renderer's text-link unit) become the Block holding a Rich Text; the
   renderer's Text link printing stays.

## Tasks (test-first; commit after each passing task, files by name; never commit CLAUDE.md)

Setup (every task): the job's worktree; `export PATH=/home/justin/.local/node-v22.23.3/bin:$PATH
TMPDIR=/home/justin/.cache/sss-b/t1 CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; heavy runs under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G); a command that dies with SIGTERM, 143, 137
or "Killed" may be earlyoom: check its journal first. Receipts go under a folder given by a variable
(`F2B_SHARED_OUT`), never one fixed shared folder. Read `figma-to-bricks/references/repeat-mistakes.md` and
`feature-dispatch/references/repeat-mistakes.md` first. Close every Chrome a run starts.

### Milestone 0: the base's facts

**Task 1 (records).**
- Check `git log --oneline main` holds site-no-div's build commit; else stop and report.
- Copy this plan to `docs/plans/2026-11-11-site-shared-styles.md`; start
  `.superpowers/sdd/2026-11-11-site-shared-styles/progress.md`.
- Base tallies into the ledger: `node --test "test/unit/**/*.test.ts"`, `npm run corpus`, the web site tests and
  browser tests by file with pass or fail (a base failure is named, not fixed here).
- Record the Figma pin on a `git archive <base>` tree: `test/fixtures/site-shared-styles-replay-pins.json` = the
  sha256 of `bricks.json` from `npm run replay` for each corpus file and of each hand-made panel capture's
  conversion (as site-no-div's recorder does; reuse its recorder with another output path). Write
  `test/unit/site-shared-styles-figma.test.ts` (named-only). Commit.
- Before pictures: `npm run site` of the `elementor-natives` capture and of the B-Dry stand-in on the base, their
  class counts into the ledger.

### Milestone 1: words are Rich Text

**Task 2 (the tenth criterion).**
- RED: `test/unit/site-rich-text.test.ts`: every fixture maker of `test/fixtures/site-code.ts`, `site-page-code.ts`,
  `site-elementor-code.ts`, `site-opens-code.ts` through `siteParts` and `siteToBricks` (both routes, default mode):
  no element named `text-basic` or `text-link`; each element whose site node is `words` is `text`, `heading`,
  `button`, or a `block` holding one `text`; a linked unpainted `a` of plain words is a `block` with `tag: "a"` and
  `link` holding one `text`; a words node with an inline `<a>` and `<span>` keeps their `inline` rules in its own
  class under `> p > :nth-child(…of :not(wbr))`; a typed `"` reaches the paste as `asTyped` writes it. Fails on the
  base naming the Text links.
- GREEN, `kinds.ts`:
  ```ts
  if (ctx.native && n.tag === "a" && href !== null && !/<[a-z!]/i.test(html) && ctx.native.painted(path)) return outer("button", { text: html, ...link });
  ```
  (the unpainted link falls to the `block` + `wrap` line that follows).
- Update site-no-div's Text link expectations (rule 4 above). Run site-no-div's `test/web/site-no-div-plain.test.ts`:
  the fixture's plain links must stay within 2 px with their hover look. **Stop condition:** a plain link moves by
  more than 2 px as a Block holding a Rich Text: keep the Text link for that shape, say so in the ledger and in the
  report (Q6 falls to B for it).

**Task 3 (the twelfth criterion's pin).** On Task 2's commit, record `test/fixtures/site-shared-styles-pins.json` =
the sha256 of every paste `test/unit/lib/site-pins.ts` lists (recorder beside site-no-div's), and write
`test/unit/site-shared-styles-off.test.ts` (named-only; converts with `{ looks: false, palette: false }`). It passes
now by construction (the options don't exist yet: add them to `ConvertOptions`, read nowhere). Commit.

### Milestone 2: one place that writes a class

**Task 4 (no behaviour change).** Add `class-source.ts` (`ClassSource`, `fromStates`, `ownClass`, `lookClass`,
`classKey`); `prepare` builds every class through `fromStates` and stores `src` in its spec. Gate: the whole unit
suite as Task 1's tally, and `F2B_PIN_BASE=1 node --test test/unit/site-shared-styles-off.test.ts` green (every paste
byte for byte). Commit.

### Milestone 3: shared classes

**Task 5 (the first, fourth and fifth criteria: text).**
- The fixture `test/fixtures/site-looks-code.ts`, hand-made like `site-page-code.ts` (`looksCode(over?)`, ranges
  `1201-up`, `992-1200`, `768-991`, `0-767`): a body context of family "Site Sans", 16px, 400, line height 1.5; a
  header with two menu links (unpainted) and one painted link; a page with a first section holding an `h1`, three
  paragraphs that draw alike (one declaring family and size itself, one under a `div` that declares them, one from
  the body) and one paragraph at 18px; a second section holding three `h2` that draw alike in two colours, an `h3`
  that draws as the `h2`s, a paragraph with `font-size: clamp(1rem, 2vw, 2rem)` twice, two `span`s under a link box
  whose hover sets `color` and `font-weight`, a paragraph declaring `font: inherit`, a paragraph of weight 550; a
  third section holding three painted links (two alike with a hover look and a `::before`, one other), five boxes
  (three with the same background, radius, shadow and padding, two with another), three flex rows with the same gap
  and two grids; a footer with two paragraphs that draw as the page's. Each words node's `inherited` holds the
  computed values the rule reads (the fixture's helper computes them from the declared chain so they can't
  disagree).
- RED: `test/unit/site-text-looks.test.ts`, `site-looks-one-writer.test.ts`, `site-look-names.test.ts` (the cases
  the criteria name; the names test also converts `looksCode({ extra: one more h2 look })` and asserts the other
  looks' names didn't move, and compares a section paste's classes with the page paste's by name, id and settings).
- GREEN: copy `<P>/proto/looks.ts` and `share.ts`; `prepare` adds `cands`; `lookKeys`/`applyLooks` in `share.ts`;
  `sitePage` and `siteToBricks` call them when `opts.looks !== false`; `payloadOf` writes the shared ids and classes;
  names through `versioned`. Only the `text` kind is switched on in this task (`candidatesOf` returns the others
  from Task 6 on), so each kind lands with its own tests.
- Apply rules 1 to 3 of "Existing tests this job changes on purpose"; the off pin stays green.

**Task 6 (the second and third criteria: buttons, boxes, layouts).** RED: `test/unit/site-button-looks.test.ts`,
`site-box-looks.test.ts` on `looksCode()`. GREEN: the three other kinds in `candidatesOf` (already in the copied
file). Extend the one-writer and names tests' fixture list to every code fixture. The off pin green.

**Task 7 (the seventh and eighth criteria in Chrome).**
- The fixture site `test/fixtures/web/sites/shared-looks/` (generic words, plain HTML and one stylesheet with media
  queries at 1100, 820 and 600): the shapes of `looksCode()` as a real page (a body font, wrapper-declared and
  self-declared paragraphs, headings in two colours, a fluid heading, buttons with hover and focus looks and a
  `::before`, cards with a gradient and a shadow, rows, a grid, a link box whose hover recolours its words, an
  inline link and a span inside a paragraph).
- `test/web/lib/style-equal.ts`: `styleDiff(pageA, pageB)` → the planner's reader (`<P>/style-diff.ts` `READ` and
  its comparison): every element under the part root in document order, its tag and id, its box, every computed
  property of the element, its `::before` and `::after`; an element whose `display` is `contents` in both is compared
  by id only (it draws nothing itself).
- RED → GREEN: `test/web/site-shared-styles.test.ts`, shaped like `test/web/site-native-structure.test.ts`
  (`captureFixture`, `siteParts`, `renderSitePaste` with the `bricks` option, `checkPage`): the first test over the
  three fixture sites and both Bricks versions (`styleDiff` empty at every width; `checkPage` within 2 px); the
  second edits one class in the payload per kind (a text class's `font-size` in its control or CSS, a button
  class's `_background.color`, a box class's `_padding.top`, a layout class's `_rowGap`), draws before and after at
  1440 and 390, and asserts the property's computed value changed on every carrier (for a flat Rich Text: on its
  `p`) and on no element outside the carriers.
- Prove the first test can fail: with `looks.ts`'s "an ancestor's hover changes it" line removed, the link box's
  words must differ under forced hover; with R5 broken by hand (a property left in both classes with another
  value), `styleDiff` must name it. Put both mutants in the ledger.

### Milestone 4: the palette

**Task 8 (the sixth criterion).** RED: `test/unit/site-palette.test.ts`: `colours.ts` alone (the cases of
`<P>/colours-check.ts`, plus `hsl()` values checked against the table in the test and 4- and 8-digit hex), then
`sitePage(looksCode())`: every solid colour of the fixture is in `palette.colors` once; each class's colour control
is `{ id, raw, light }`; each custom CSS colour is `var(--…, …)`; a hover look's colour and a triggered look's colour
are linked; `rgba(0, 0, 0, 0.5)`, `transparent`, a `font-family: "Black Ops"` and a `url(…#fff.png)` are untouched;
another page name gives other ids; `{ palette: false }` writes plain colours. GREEN: copy `<P>/proto/colours.ts`;
`customCss(…, ink)`, `inked`, `withStates(…, ink)`, the collection and `siteInk` in `sitePage`; `classKey` with the
ink; `siteToBricks` takes the page's ink. The off pin green.

**Task 9 (the ninth criterion).** RED → GREEN in `test/web/site-shared-styles.test.ts`: the third test draws the
`shared-looks` paste three ways at 1440 and 390: switch off; default (no variable defined: `styleDiff` with the
first empty); default with `<style>:root { --<page>-<hex>: rgb(1, 2, 3); }</style>` added to the drawn page's head
for one palette colour that the fixture uses as a text colour, a background, a border and a gradient stop: every
element one of whose classes links that variable shows `rgb(1, 2, 3)` in that property's computed value, and
`styleDiff` against the default drawing names no element outside those elements and their descendants (inherited
`color`) and no property that holds no colour.

**Task 10 (the fourteenth criterion).** RED: the new test in `test/web/site-cli.test.ts` (runs `npm run site` on a
fixture capture; reads `palette.json`, `styles.txt`, `notes.txt`; a `--section` run too; the usage text unchanged).
GREEN: `tools/lib/site-write.ts` (both writers), the notes lines where each part's notes are joined in `parts.ts`.
Grep the tests that list an output folder (`readdirSync(out)`) or pin `site`'s printed lines and update only their
expected file lists and counts, named in the ledger.

### Milestone 5: the whole proof

**Task 11 (the eleventh and thirteenth criteria, the closing gates).**
- `test/web/site-shared-styles-bdry.test.ts` (named-only, shaped like site-no-div's B-Dry test): both routes, both
  Bricks versions, `styleDiff` at one width per range, the `site:check` rows against the base's.
- Run: `npm run check`; the whole unit suite; `npm run test:browser`; `npm run test:web`; `npm run corpus` (no file
  worse than Task 1's); `F2B_PIN_BASE=1 node --test test/unit/site-shared-styles-off.test.ts
  test/unit/site-shared-styles-figma.test.ts`; `node tools/site-no-revert-golden.ts .` and
  `test/unit/site-no-revert.test.ts` (no new `revert`).
- Receipt for the ledger: `npm run site -- ~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json <out>
  --elementor` (read-only on `~/Downloads`): the shared classes by kind and the palette's size beside the planner's
  57 and 22 (a different base moves them a little; a big gap is a stop to explain).
- After pictures of the `shared-looks` paste at 1440 and 390 (switch off beside default: the same picture) and one
  picture pair for the eighth and ninth criteria (before and after the edit) under
  `~/.hermes/plans/figma-to-bricks/shots/site-shared-styles/`; never committed.

**Task 12 (Docs & records).**
- `docs/HANDOFF.md`: a new section above the previous top heading ("An importer paste's looks live in shared classes
  and palette colours"): the rule (R1 to R7), the names, the palette and how to import it, Q1 to Q7 with their ⭐
  answers "not yet confirmed", the measured numbers, the limits under "Deferred" (the list above), what Justin can do
  now in plain words; the paste check at the top of "End-of-run check list" with the steps of the live criterion (the
  id is the next free one at the merge, checked on main's HANDOFF and every local branch).
- `reference/bricks/README.md`: the two notes read in 2.2's `assets.php`.
- The ledger moved by the finisher to `docs/plans/2026-11-11-site-shared-styles-ledger.md` before the final premerge
  commit and rebase; `BUILD` bumped at the merge; main `CLAUDE.md` Status: the build line and one feature line with
  the paste check.
- New standing rules for `CLAUDE.md` (the finisher writes them, or leaves them in
  `~/.hermes/plans/figma-to-bricks/site-shared-styles-claude-md-pending.md`): "A site paste's shared classes: a
  property has one writer per element (`looks.ts` R5); a class and a palette colour are named after their own rules
  and hex, never a rank number"; under decisions: "The importer's looks live in shared classes and a per-page Bricks
  palette (Justin, 2026-11-11); words are Rich Text on the importer route too".

## Risks

- **A text class changes what a text inherits.** Guarded by R2's four refusals, by the computed values being the
  capture's own, and by the style check at every width (the seventh criterion); the prototype's B-Dry run is equal.
  A capture older than the computed text settings (`inherited` empty) gets no text class (the look has no values).
- **Bricks 2.4.2's palette import or printing differs from 2.2's source.** The paste never depends on it (fallbacks);
  the live criterion is the proof. If the import refuses the file, Justin reports the message; the page still looks
  right.
- **More classes in Bricks' list** (309 → 362 on B-Dry). Q2 sets the count; `styles.txt` is the map.
- **A re-paste after Justin changed a shared class:** Bricks asks "Import classes"; "keep" keeps his change (said in
  the notes and HANDOFF).
- **site-no-div lands differently from its plan.** Task 1 checks; the builder maps names and reports.

## Completion and reporting

Stop at `ready-for-review` when the first fourteen criteria pass on one head, committed, rebased on main. Report: the
head, each criterion with its test and result, the tests changed under the four rules (by file), the goldens made
again (by file), the receipts' paths, Justin's capture's counts, every ruling in plain words, the live criterion
owed, `shots[]`, and `skill_lessons`.
