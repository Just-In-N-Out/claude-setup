# importer-parity: the website importer builds what the Figma plugin builds (plan, 2026-11-11)

Planner: importer-parity (Fable 5.2, high). Pipeline: **Full**. Website importer rules apply (repo CLAUDE.md: one
real-bug review per job, edge cases to follow-ups).
**Base: `main` once site-no-div and site-shared-styles have merged** (their plans: `~/.hermes/plans/figma-to-bricks/
site-no-div.md`, `site-shared-styles.md`; their base is site-native-structure, today `site-native-structure-stack6`
`2a38027f` on main `02481763`, Build 2026-11-11.3). Every file:line below is from `git show
site-native-structure-stack6:<path>` (the planner's tree `~/.cache/ipp/base`) unless it says otherwise; the two jobs
above are not built yet, so what this plan takes from them is listed under "What this plan assumes" and the builder
re-reads every line on its real base before editing.
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/importer-parity/planner/` (`README.md` lists every
file; the prototype is `<P>/proto-controls.diff`, the Bricks 2.2 source files read are in `<P>/bricks-2.2/`).
Plan copy for the repo: `docs/plans/2026-11-11-importer-parity.md` (the builder copies this file there in Task 1).

## Playback

1. Justin asked for a double check that the website importer sets a page up in Bricks the way the Figma plugin does. A
   read-only audit found six things the plugin builds and the importer doesn't
   (`evidence/structure-parity/report.md`, gaps 1, 3, 4, 5, 8 and "Button style").
2. This job closes them for every scanned site: the site's accessibility names are kept; a menu is Bricks' Nav
   (Nestable); a form is Bricks' Form and a video Bricks' Video; a line, a list of questions and a slider are Bricks'
   Divider, Accordion and Slider on sites without Elementor too; border, corners, shadow, position, overflow and the
   flex item values are Bricks settings instead of custom CSS; a painted Button has Style: Primary.
3. Every paste must still look exactly like the old site at every width, and every Figma design must convert byte for
   byte as before.

## Questions (⭐ = the answer the standing auto-go takes; Justin's "go with recommended")

1. **Where it applies.** ⭐ **A:** every paste the code method makes, with no flag: `npm run site`, `site:upload`,
   `site:import`, section pastes, the plain route and `--elementor`, as site-no-div and site-shared-styles. The Figma
   panel's website route and every Figma design stay byte for byte. B: behind a flag.
2. **One job or three.** The work is three waves that don't depend on each other's code. ⭐ **A:** one job, built
   wave by wave, one merge at the end. Wave 1 (names, settings instead of CSS, Button style) is everything
   bdryswi.com's home page shows: its header has no menu list (its menu is a pop-up of boxes), and the page has no
   form, video, plain line or `details` (`<P>/survey-justin.txt`). B: merge wave 1 first (its criteria are the first
   ten plus the two pins), then waves 2 and 3 as their own jobs: B-Dry shows wave 1 sooner, at the cost of three
   review and verification rounds.
3. **Which names are kept.** ⭐ **A:** `aria-label`, `role`, `title`, `aria-hidden`, `aria-current`, `lang`, `dir`,
   `tabindex`, and a link's `rel`. Never an attribute that names another element by id (`aria-controls`,
   `aria-labelledby`, `aria-describedby`, `for`) or a state Bricks' own script owns (`aria-expanded`): Bricks gives
   every pasted element a new id, so they would point nowhere. They are counted in the notes.
4. **A menu.** ⭐ **A:** the menu bar becomes Bricks' Nav (Nestable) holding the site's own list (Nav items › List
   item › the link), with Bricks' own phone menu switched off (Mobile menu: Never). The site's own ☰ button keeps
   opening the site's own menu box, the Offcanvas site-menu builds (with site-menu-motion's slide), so phones look
   and work exactly as on the old site. Bricks' Toggle is not used: it draws Bricks' own three bars and can hold
   nothing, so it can't show the site's icon (it can once icons are Bricks icons: the bricks-icons job). B: Bricks'
   Toggle and Bricks' own phone panel (the plugin's way): native, but it won't look like the old site's menu.
5. **A menu's sub-lists.** ⭐ **A:** they stay the site's own lists inside their item and open as on the site (its
   own hover rules, which the capture reads). Bricks' Dropdown is a later job (its only sample is a researched one,
   and its box structure differs from a site's `li › a + ul`). B: Bricks' Dropdown now.
6. **A menu inside a box a button opens** (the phone menu's own list). ⭐ **A:** unchanged: site-menu and
   site-menu-motion own it. B: also a Nav (Nestable) (two Navs on a page, Bricks' focus handling inside the Offcanvas
   unproven).
7. **What a site's form sends to.** ⭐ **A:** a Bricks Form that sends an email to the WordPress admin address with
   Bricks' own texts, exactly as the plugin's forms do; the old site's form address is named in the notes and never
   posted to (it belongs to the old site, and would send visitors' data there). B: leave forms as the site's code
   that sends nothing (today).
8. **Which forms.** ⭐ **A:** simple forms only: every field is a label and one box (text, email, phone, number,
   address, password, a text area, a drop-down) sitting directly in the form, plus one send button. A form with
   fields in rows and columns, tick boxes, radio buttons, file uploads, several steps or a captcha stays as today
   and the notes say why. B: all forms now (a much larger job; rows and tick boxes can't be drawn the same in
   Bricks' Form without rules of their own).
9. **Which videos.** ⭐ **A:** a `<video>` with one file address → Bricks Video (File); a YouTube or Vimeo frame →
   Bricks Video (YouTube / Vimeo). Any other frame (a map, a booking widget) stays a Code element labelled Embed. A
   video with captions or several files stays Code and is named.
10. **A slider on a site without Elementor.** ⭐ **A:** where the capture recorded a Swiper or Splide slider with two
    or more real slides, one Bricks Slider (Nestable), as the Elementor step builds one. This replaces "Keep all its
    slides" (2026-11-07) for those sliders only; a slider it can't rebuild (Slick, an unknown library, slides in
    several rows) stays static with all its slides, as today. A row that scrolls sideways by CSS alone (scroll snap)
    stays the site's own: it already scrolls and snaps in the paste, and the plugin keeps its own sideways rows that
    way too. B: keep every such slider static.
11. **`details` lists.** ⭐ **A:** two or more `details` in a row, each holding its `summary` and one box, with the
    browser's own triangle hidden by the site → Bricks' Accordion (Nestable). A single `details`, or one showing the
    browser's triangle, stays a Block that opens by itself, as today. Lists built with ARIA (`aria-expanded` on the
    question, `aria-controls` naming the answer) become an Accordion too, on captures made with this build. B: never
    change `details`.
12. **A plain line.** ⭐ **A:** an `hr`, and an empty box that draws only a line 4 px thick or less, becomes Bricks'
    Divider. The site's whole look sits on the Divider itself and Bricks' inner `line` draws nothing, so the boxes are
    the same by construction. B: the look on the inner `line` (closer to a hand-built Divider, but an `hr` is one box
    and Bricks' is two: margins and sizes would have to be split between them).
13. **Which settings instead of CSS.** ⭐ **A:** border (width, style, colour), corners, one box shadow, position and
    its offsets, z-index, overflow, flex grow, shrink and basis, align self, order, opacity, cursor, object fit; and
    what the element's own hover changes of a setting, as Bricks' `:hover` setting. Only where the value is plain and
    changes on Bricks' breakpoints (the rule every setting follows today), and only where Bricks prints the same
    CSS. Focus looks, transitions, transforms, gradients, grids and several shadows stay custom CSS.
14. **Button style.** ⭐ **A:** every painted Button (Elementor's, and a painted link found by shape) gets Style:
    Primary, as the plugin's buttons and `ExampleBricks`; its look stays in its class. Measured: nothing moves
    (`<P>/primary-diff-standin-242.log`, `-239.log`). What changes is under "Button style" below. B: Primary for a
    filled button, Primary + Outline for one painted only by its border. C: stay with no Style.

## What Justin will see (the planner's prototype on the B-Dry stand-in capture, `--elementor`)

- **Settings instead of CSS** (`<P>/controls-diff-standin-el-all.log`): of the paste's 308 classes, Position is now a
  setting on 180, Border on 153, Flex grow / shrink on 109 / 108, Flex basis on 82, Overflow on 76, Align self on 36,
  Z-index on 35, Cursor on 34, Box shadow on 11; the classes' custom CSS shrinks from 274,366 to 245,772
  characters. Every class still holds some custom CSS (transitions, Elementor's `unset` values, the site's own
  switch points at 1024 and 1366 px), so no class becomes "settings only". **Nothing moves: 9,132 element readings at
  12 widths, every computed property of every element, 0 differ** (Bricks 2.4.2; 3,044 readings equal with 2.3.9;
  3,612 equal on the plain route).
- **Names** (`<P>/survey-justin.txt`, `<P>/names-justin-el.txt`): his 2026-11-11 capture holds 21 `aria-label`, 46
  `role` (32 are `button`) and 39 `aria-hidden`; today's paste writes none (0 attributes, 0 link names). After this
  job the ☰ button reads "Menu" again, icon buttons keep their names and decorative icons stay hidden from screen
  readers.
- **Buttons:** clicking a hero button in Bricks shows Style: Primary.
- **Not on bdryswi.com's home:** a Nav, a Form, a Video, a plain Divider or `details`. They are proven on fixture
  sites and will show on the first page that has them (the contact page's form, for one).

## Why the importer lacks them today (file:line, base tree)

1. **Names.** `src/core/site/kinds.ts:74-80` builds an element's settings from its tag and link only (`link: { type,
   url, newTab }`); no other attribute is read. The capture keeps `role`, `aria-label`, `title`, `aria-hidden`,
   `lang`, `dir` on every element (`src/web/read/code.ts:28-29` `KEPT`; `src/core/snapshot/web.ts:49`), but not
   `tabindex`. Only the Offcanvas writes a name (`opens.ts:103`, `labelOf` `:154`). The plugin writes custom
   attributes and link names (`src/core/emit/elements.ts:157-170`, `emit/cta-names.ts`).
2. **Menu.** A `nav`, its `ul` and `li` are boxes like any other (`kinds.ts:80`); site-no-div labels them "Menu",
   "List", "List item" and defers "site-nav" for a sample that exists: `reference/bricks/nav-nested.json` (researched,
   README:417), which the plugin's `src/core/emit/nav.ts` already writes from.
3. **Form, video.** A `form` is a box and its fields Code elements, with the note "a form shows as drawn and sends
   nothing (the Bricks Form job)" (`convert.ts:41`, `:214`); `video` and `iframe` are Code (`kinds.ts:100-102`; the
   capture's `OTHER` set, `src/web/read/code-facts.ts:23`). The plugin has `emit/form.ts` and `emit/video.ts`.
4. **Divider, Accordion, Slider.** Only the Elementor step makes them, from Elementor's widget types
   (`elementor-fold.ts:384`, `:402`, `:455`). The shape readers themselves read structure
   (`elementor-accordion.ts:42` `accordionShape`, `elementor-slider.ts:157` `sliderOf` over the capture's
   `web.sliders` record). Without Elementor a slider is kept static (`widgets.ts:10`, `:26`), an `hr` is a box.
5. **Settings.** `controls.ts:66-90` `RULES` ends at padding, margin, sizes, typography and background colour; every
   other property is custom CSS. A property any state of the element changes is kept out of settings
   (`states.ts:19` `keep`, `convert.ts:315-318`), because Bricks prints a class's tier settings after its custom CSS.
6. **Button style.** `elementor-fold.ts:428` writes a Button with `text` and `link` and no `style`
   (site-native-structure Q6 A); site-no-div's Button by shape does the same.

## What this plan assumes from site-no-div and site-shared-styles

If either lands with other names, the builder maps them and says so in the ledger.
- **site-no-div:** no Div (`block`); `ConvertOptions.native`; `natives.ts` (`paintsBox`, `linkedPictures`);
  `fold-boxes.ts` (`foldBoxes`, rule N and its keep set N6); `lift.ts` `plainSections` (rule S); `labels.ts`
  (`boxLabel`, `wordsLabel`, `codeLabel`); the `Structure:` note and `structure.txt` (`tools/lib/site-write.ts`); the
  fixture sites `plain-natives` and `elementor-natives`; `test/unit/lib/site-pins.ts` and its recorder; the standing
  rule "a website paste never holds a Div (`test/unit/site-no-div.test.ts`; add every new element producer to it)".
- **site-shared-styles:** `class-source.ts` (`fromStates`, the one place declarations become a class's settings and
  CSS; `ownClass`, `lookClass`, `classKey`); `looks.ts`, `share.ts`; `colours.ts` (`siteInk`, `inked`); `sitePage`;
  `ConvertOptions.looks` / `palette`; its Q6 A (an unpainted link of plain words is a Block with the link holding a
  Rich Text; no Text link); the fixture site `shared-looks`; **`test/web/lib/style-equal.ts`**, its oracle (two
  conversions of one capture drawn as `site:check` draws a paste, every element's computed style and box compared),
  which this plan's equality criteria reuse.

## The general rules

Every rule reads structure, declared CSS, the attributes the capture keeps and the capture's own records only: never a
site's ids, class names or words. Framework classes of a slider library (Swiper's, Splide's) are read from
`CodeNode.marks.class`, as Elementor's are (`elementor-map.ts` `markersOf`), and never printed.

### A. Names (wave 1)

| The site's attribute | On | Goes to (source) |
|---|---|---|
| `aria-label` | an element whose Bricks element carries `link` (Button, a Block or Image with Link to) | `link.ariaLabel` (Bricks `base.php` L2366-2368, `<P>/bricks-2.2/base.php`; `reference/bricks/link-schema.json`; the plugin's `emit/cta-names.ts`) |
| `title`, `rel` | the same | `link.title`, `link.rel` as the site wrote them (`base.php` L2352-2363) |
| `aria-label` | an Offcanvas (today), a Nav (Nestable) | the element's own `ariaLabel` (`nav-nested.php` L1141; the element prints its own, a custom attribute would be joined to it) |
| `aria-label`, `title` | any other element | `_attributes` |
| `role`, `aria-hidden`, `aria-current`, `lang`, `dir`, `tabindex` | any element | `_attributes` |

- `_attributes` is `[{ id, name, value }]`, the shape `emit/elements.ts:157-170` writes: `id` =
  `shortId("attr:<the element's id key>:<name>")` (`emit/ids.ts`), in the table's order. Bricks prints them on the
  element's root and they replace a same-named attribute it set before (`base.php` L1905-1930, L2509-2538).
- An opener of an Offcanvas keeps the site's `aria-label` and `tabindex`: Bricks' Interaction adds `tabindex="0"`,
  `aria-expanded` and `aria-label="Open"` only where none is set (`interactions.php` L640-651,
  `evidence/site-menu/planner/interactions-2.2.php`).
- Never pasted: `id`; `aria-controls`, `aria-expanded`, `aria-labelledby`, `aria-describedby`, `for` (Q3 A); the
  site's `role` on an element Bricks gives its own role or state (an Accordion's titles and panels, a Slider and its
  slides, a Nav (Nestable), a Bricks Form's parts).
- A wrapper that folds into its element (the Elementor fold, site-no-div's rule N) hands its attributes to the element
  that stands for it where that element has none of the same name; the element's own wins and the clash is counted. An
  element a Button or Divider absorbs hands its `aria-label` to the absorbing element the same way.
- Words' inline elements already keep their attributes in the HTML (`code-facts.ts:78`); a Code element's markup keeps
  its own (`markup.ts`). Unchanged.
- Notes (per part): `Names: <n> kept (<a> in link controls, <b> as attributes)`; when any: `<k> names point at
  another element by id and are left out (Bricks gives pasted elements new ids)`, `<k> names sat on elements the paste
  doesn't hold`.
- The capture (new captures only): `KEPT` gains `tabindex`, `aria-current`, `aria-expanded`, `aria-controls`, `for`,
  `action`, `method` (the last five are read by sections C and D, never pasted), and `WebCode.keeps: string[]` lists
  the names added since version 3, so the converter can tell an older capture (absent) and say once: `this capture
  was made before the importer kept tabindex and form addresses: capture again for them`.

### E. Settings instead of custom CSS (wave 1; "site-controls")

One rule decides, as today (`controls.ts:97-109`): a property is a setting when every value it takes is plain, every
change falls on Bricks' breakpoints with nothing bounded below, and nothing else in the paste writes it for the
element at class weight. New properties (keys as `emit/settings.ts` writes them; each key's shape is in Justin's own
copies, `ExampleBricks` and `reference/bricks/staff-card.json`, `hero-video-buttons.json`,
`cta-button-interactions.json`):

| CSS | Setting | A plain value |
|---|---|---|
| `position` | `_position` | `relative`, `absolute`, `fixed`, `sticky`, `static` |
| `top`, `right`, `bottom`, `left` | `_top` … `_left` | a number with `px`, `%`, `em`, `vw`, `vh`, or `0` |
| `z-index`, `order` | `_zIndex`, `_order` | a whole number |
| `overflow-x` + `overflow-y` | `_overflow` | both equal in every block: `hidden`, `visible`, `auto`, `scroll` |
| `flex-grow`, `flex-shrink` | `_flexGrow`, `_flexShrink` | a number |
| `flex-basis` | `_flexBasis` | a length with its unit, or `auto` (never a bare number: `payloadProblems` refuses one) |
| `align-self` | `_alignSelf` | `flex-start`, `center`, `flex-end`, `baseline`, `auto` (never `stretch`: CLAUDE.md) |
| `opacity`, `cursor`, `object-fit` | `_opacity`, `_cursor`, `_objectFit` | a number; a cursor word; a fit word |
| the four corners | `_border.radius` `{ top, right, bottom, left }` = top-left, top-right, bottom-right, bottom-left | each a plain length |
| `border`, or `border-<side>-width / -style / -color` | `_border` `{ width, style, color }` | rules B1–B5 |
| `box-shadow` | `_boxShadow` `{ values: { offsetX, offsetY, blur, spread }, color, inset? }` | one shadow: two to four px lengths and a hex or `rgb()` colour; `none` and several shadows stay CSS |

**Border, as Bricks prints the control** (`assets.php` L2111-2298,
`evidence/site-shared-styles/planner/bricks-2.2/assets.php`): four equal widths with a style → `border: W style
colour` (Bricks' own border colour when the key holds none); four zero widths → `border: 0`, then the key's style and
colour; other widths → `border-<side>: W style colour` when the key holds a style and a colour, else
`border-<side>-width` with one `-style` / `-color` per side that has a width; a style or colour with no width →
`border-style` / `border-color`. So a block's border is a setting only when (prototype `borderOf`):
- B1. It is the `border` shorthand alone (`0`, `none`, or `W style colour` with a plain width, a real style and a hex
  or `rgb()` colour), or side longhands only: no `border-width`, `border-style`, `border-color`, `border-<side>`
  shorthand, logical side or border image beside them.
- B2. Every side that names a style names the same one, all four of them; the same for the colour.
- B3. Four equal non-zero widths with a style also hold the colour.
- B4. Four zero widths either hold the style and colour too, or nothing of the element declares a style or colour
  anywhere (`border: 0` resets both).
- B5. Fewer than four widths hold neither a style nor a colour in that block.
Else the whole border group stays custom CSS, every block of it (a group is all or nothing, so a setting never meets
its own property in the custom CSS).

**Kept as CSS whatever its value:**
- K1. A property a `focus`, `focus-visible` or `focus-within` look of the element changes, or another element's state
  (`states.ts` `keep`, as today).
- K2. `position`, the offsets and `z-index` of every top element of a part (the page-wide classes meet it at class
  weight: site-sticky-header's `.N.N { position: sticky; top; z-index }`, the reset, site-scroll-lock's class).
- K3. A property another rule of the paste writes for that element: an Accordion's open look
  (`elementor-accordion.ts` `lookCss`), a Slider's look (`slider-look.ts`), site-menu-motion's slide, an opened box's
  `pointer-events`. The builder lists every writer of `_cssCustom` and hands `controlsFor` their properties in
  `ControlOptions.keep`.
- K4. Everything of a class written on the site's element inside a flat wrapper (no settings at all, as today).

**Hover.** A property only the element's own `hover` look changes (no other state, no part) whose base is a setting
and whose hover value passes the same rule is written as Bricks' hover key: `_typography:hover`, `_background:hover`,
`_border:hover` (a colour alone recolours the border: the shape of Justin's own `_border:hover` in `ExampleBricks`),
`_boxShadow:hover`, `_opacity:hover`, `_cursor:hover` (`shared/breakpoints.ts` `settingKey(key, "base", "hover")`,
as `emit/states.ts` writes them). It leaves the class's `:hover` rule. Bricks prints it `.cls.brxe-<el>:hover`
(0,3,0), above every tier setting, as the class's own `:hover` rule is above its tier blocks today.

**Colours** of the new settings go through site-shared-styles' `inked`, so a border or shadow colour links to the
palette like every other.

**Proof.** The prototype (`<P>/proto-controls.diff`: `MORE_RULES`, `borderOf`, `shadowOf`, the groups, the hover keys)
drawn against the base with the test renderer printing Border and Box shadow exactly as `assets.php` does: 0 of 9,132
readings differ on the B-Dry stand-in (above). Not prototyped: K2, K3, the hover keys for border and shadow (the
stand-in gave one hover setting), the palette on the new colours.

### F. Button style (wave 1)

A painted Button (the Elementor step's, `elementor-fold.ts:428`; site-no-div's by shape, `kinds.ts`) gets `style:
"primary"`, as `emit/elements.ts:115` and `ExampleBricks`. **What changes:**
1. Bricks prints one more class on it, `bricks-background-primary` (`button.php`, `reference/bricks/README.md:544`).
   Its only rule, `.bricks-background-primary { background-color: var(--bricks-color-primary) }`, is inside Bricks'
   layer in 2.3.9 and 2.4.2 (`reference/bricks/frontend-*/frontend-light-layer.min.css`), so the paste's reset
   cancels it and the Button's own class paints it. Measured on the stand-in's Buttons: 1,522 readings at 1440 and
   390, 0 differ, with 2.4.2 and with 2.3.9.
2. In Bricks the Button's Style reads "Primary" instead of empty.
3. **A Theme Style for buttons on the site that receives the paste.** Bricks prints Theme Style → Buttons → Primary
   as `:root .bricks-button[class*="primary"]` (typography, border, shadow) and `…:not(.outline)` (background): 0,3,0
   and 0,4,0, heavier than any class (`<P>/bricks-2.2/theme-element-button.php`). Where the site sets those, they
   win over the old site's look, as they would for a Button Justin built by hand with Style: Primary. A Button with
   no Style isn't safe either: Theme Style → Buttons → Background is `.bricks-button:not([class*=
   "bricks-background-"]):not([class*="bricks-color-"]):not(.outline)` (0,4,0) and repaints it
   (`<P>/primary-diff-standin-theme.log`). B-Dry staging sets neither (its saved CSS holds no `.bricks-button` rule
   outside Bricks' layer, `evidence/staging-fit/planner/staging/css/`). The notes say once: `Buttons carry Style:
   Primary; a Theme Style for primary buttons on your site would restyle them (clear it there, or clear Style on the
   button)`. Reading the receiving site's Theme Style is a follow-up.

### D. Divider, Accordion and Slider by structure (wave 2)

One step, `plain natives`, after the Elementor step (when on) and on the plain route alone, never over an existing
pick, a live widget's slot, a path inside an opened box, or a part's root.

**Divider.** A box that is an `hr`, or a `div`/`span` with no child, no words and no `::before`/`::after`, block-level
wherever it shows, drawing only a line: a visible border on exactly one side with no height of its own, or a
background colour with a height of 4 px or less. It becomes Bricks' Divider (`reference/bricks/divider-plain.json`:
no settings): the class holds all its declarations (an `hr` also the browser's own `hr` look where the site sets
neither name: `kinds.ts` `BOX_LOOK` gains `hr`), Bricks' inner `div.line` draws nothing (its only rule is in Bricks'
layer, `<P>/bricks-2.2/el-divider.min.css`), and `_attributes` holds `role="separator"` (an `hr`'s own role, which
the printed `div` lacks). Refused, staying a Block: a look under a state, a transition, an inline line.

**Accordion.** A box whose two or more shown children are alike items of a title and a panel (`accordionShape`, given
the list's path in place of an Elementor entry), where either
- every item is a `details` whose two element children are its `summary` and one box, and the site hides the
  browser's triangle (the `summary` declares a `display` other than `list-item`, or its drawn `list-style-type` is
  `none`); or
- (captures with `keeps`) every title holds an element with `aria-expanded` whose `aria-controls` is the `id` of an
  element at or under the same item's panel.
It becomes Bricks' Accordion (Nestable) through `accordionPicks` and `openLook`, exactly as the Elementor step's: the
items the capture shows open are open at load (site-faq), the open look follows `.brx-open`, and the `details` and
`summary` tags are not kept (the picks write plain Blocks, so the browser's own opening never meets Bricks'). A `details`' `open`
attribute and `details[open]` rules are read through the capture's shown ranges, as today. Refused, staying as today
(a `details` opens by itself): a single item, items that aren't alike, a `summary` showing the browser's triangle,
more than a summary and one box, a list inside an opened box.

**Slider.** A `web.sliders` record of library `swiper` or `splide` outside every Elementor widget, with two or more
real slides that are all children of one row under the record's root → Bricks' Slider (Nestable) through `sliderOf`
(its entry argument generalised to a root path): Swiper's captured params as today, Splide's `data-splide` options
by their own names (Bricks' Slider is Splide: `perPage`, `gap`, `type`, `autoplay`, `interval`, `speed`, `arrows`,
`pagination`, `breakpoints`), what the page shows for a part no setting names, the site's arrows and dots taking
Bricks' places and look (`slider-look.ts`, by the library's framework classes). `widgets.ts` no longer marks such a
slider's loop copies "kept static". Refused, static with all its slides as today, named: Slick, a record with no
settings and nothing shown to read, slides in several rows, fewer than two slides.

### C. Video and Form (wave 2: video; wave 3: form)

**Video** (keys from `reference/bricks/video-schema.json`, written through the plugin's own writer, see Architecture).
- A `video` whose markup holds one file address (its `src`, or one `source`), no `track`: `videoType: "file"`,
  `fileUrl`, and exactly the attributes it has: `autoplay` → `fileAutoplay`, `loop` → `fileLoop`, `muted` →
  `fileMute`, `playsinline` → `fileInline`, `controls` → `fileControls`, `preload` → `filePreload`; `poster` →
  `videoPoster` through `media.ts` `imageSettings` (the library's picture with a media map).
- An `iframe` whose address is YouTube's (`youtube.com/embed/<id>`, `youtube-nocookie.com/embed/<id>`) or Vimeo's
  (`player.vimeo.com/video/<id>`): `videoType: "youtube"` / `"vimeo"`, the id, the address's parameters the
  schema has a key for (`autoplay`, `mute`, `loop`, `controls`, `playsinline`, `start`, `end`, `rel`), `title` →
  `iframeTitle`. Every other parameter of the address is named in the notes.
- Bricks prints `div.brxe-video › video` or `› iframe` (`<P>/bricks-2.2/video.php` render, L670 on). The Video is
  written flat like a Code element today (`site-flat` on the wrapper), its class's rules landing on ` > video` /
  ` > iframe` (`Where.self`), so the site's element keeps its own box; its `width`/`height` attributes are already
  declarations of the class (the capture reads an element's presentational attributes).
- Refused, staying Code (labelled Video / Embed): several files, a `track`, no address, an older capture without the
  element's markup, any other frame.

**Form** (keys from `reference/bricks/form-basic.json`, `form-schema.json`; Bricks prints `form.brxe-form ›
div.form-group › [label] + input | textarea | select … › div.form-group.submit-button-wrapper › button`,
`<P>/bricks-2.2/form.php` render L2570 on).
- **F1.** A shown `form`, not in a live widget's slot or an opened box, holding one send control (a `button` that is
  no `type="button"`/`"reset"`, or an `input type="submit"`) and one or more fields of type text, email, tel, number,
  url, password, `textarea` or `select`. Hidden inputs are left out and counted (they belong to the old site).
- **F2.** Going down from the form through boxes that add nothing (rule N), its shown children are the field groups
  and the send group, in order. A field group is the control alone, or a box whose shown children are exactly one
  label of plain words and then the control. The send group is the send control alone or a box holding only it.
- **F3.** The label is the group's `label` (on captures with `keeps`, a `label` whose `for` names another control
  refuses the form). No label: the field's `label` is its `aria-label`, else its placeholder, and the form doesn't
  show labels.
- **F4.** Settings: `fields` `{ id, type, label, placeholder?, required?, options? }` (a select's options one per
  line, `value : label` where they differ; an empty first option is the placeholder), `submitButtonText` the send
  control's words, `submitButtonStyle: "primary"`, `showLabels` when any group has a label, and the plugin's sending
  settings unchanged (`actions: ["email"]`, `emailTo: "admin_email"`, Bricks' own subject and messages).
- **F5.** The look: the form's class on the Form; each group's declarations under `.cls > .form-group:nth-child(k)`,
  its label's under `… > label`, its control's under `… > input` / `textarea` / `select` with the control's own
  hover and focus looks, the send group's under `.cls > .submit-button-wrapper`, the button's under `… > button`
  (the class's `parts`, as a Divider's line and an Image's `img` are written today). A new shared class
  `site-form-<4>` restores what the reset cancels of Bricks' form CSS and the form needs to work: the button's
  loading mark hidden until it sends, the message box after sending (`<P>/bricks-2.2/el-form.min.css`: the `.loading`,
  `.sending`, `.message` and `.form-group-error-message` rules).
- **F6.** Notes: `the form is a Bricks Form: it sends an email to the WordPress admin address (Form → Actions); on
  the old site it posted to <action> (<method>)`; `<k> hidden fields of the old site's form are left out`; for a
  refused form, why (`fields in rows`, `a tick box`, `a captcha`, …) before today's note.
- Refused, staying as today: anything outside F1–F3, a label holding an element, a control inside a `label`, a
  `fieldset`.

### B. Menu (wave 3)

- **M1.** A box with tag `nav` or `role="navigation"`, shown in the design width's range, outside every opened box
  and live slot, that holds below it exactly one menu list: a `ul`/`ol` whose two or more shown children are all `li`
  holding a link (a sub-list inside an `li` belongs to that item), or, with no list at all, its own two or more shown
  children being all links (`<nav><a>…</a><a>…</a></nav>`). Two lists, or links mixed with other things at the
  nav's own level, are no menu here and stay Blocks, named.
- **M2.** The `nav` → `nav-nested` with `mobileMenu: "never"` (`nav-nested.php` L867-868, L1144-1172: no toggle CSS is
  printed) and `ariaLabel` the site's `aria-label` (Bricks prints "Menu" where there is none, named in the notes).
  The list → the Block "Nav items" with `tag: "ul"` and `_hidden._cssClasses` exactly `brx-nav-nested-items`
  (`reference/bricks/nav-nested.json`; the plugin's constant). Each `li` → a Block with `tag: "li"`: Bricks wraps a
  child of the items block in `li.menu-item` only when its HTML doesn't start with `<li` (`container.php` L970-1015,
  `evidence/djtrees-phone-menu/research/source-2.2/`), so the site's own `li` stays the item, with its class. Links
  inside are what site-no-div and site-shared-styles make them. Anything else the nav holds (a logo, a button) stays
  where it is, a child of the Nav.
- **M3.** A nav of bare links: the items block is a new Block (no site element; id from `site:<nav path>:items`,
  `site-flat`, so it takes no box) and the class of the Nav gets one part, ` > .brx-nav-nested-items > .menu-item {
  display: contents; }`, so Bricks' own `ul` and `li` take no box and the links stay the nav's own flex or inline
  children.
- **M4.** Bricks' nav CSS is inside its layer and cancelled by the reset; the site's own classes paint the bar.
  Bricks' nav script only adds arrow-key movement between the links (`bricksNavNested`, `frontend-2.3.9/bricks.min.js`).
- **M5.** Sub-lists, the ☰ and the phone menu: unchanged (Q4 A, Q5 A, Q6 A). An opener keeps its Interaction whatever
  element it is (site-no-div's tenth criterion).
- Notes: `the menu is a Bricks Nav (Nestable): <n> items; its phone menu is the site's own (an Offcanvas)` or, with no
  opened box, `…; Bricks' own phone menu is off (Mobile menu: Never)`.

## Overlaps and order

| Job | State | Shared files | How they meet |
|---|---|---|---|
| site-no-div (base) | planned | `kinds.ts`, `natives.ts`, `fold-boxes.ts`, `labels.ts`, `lift.ts`, `convert.ts`, `tree.ts` | merges first. Rule N gains "a wrapper's names move to its element"; its labels win ("Menu" gives way to Bricks' own name for a Nav); its no-Div test gains this job's producers |
| site-shared-styles (base) | planned | `class-source.ts` (`fromStates`), `controls.ts`, `looks.ts`, `colours.ts`, `parts.ts`, `kinds.ts` | merges first. The new settings are made inside `controlsFor`, so own and shared classes get them alike; `inked` must reach the new colour settings; a Button's look class holds its hover settings |
| site-sticky-header (Mini) | running | `stay.ts`, `parts.ts`, `controls.ts` (read), `src/web/read/code.ts` | its `.N.N { position; top; z-index }` relies on those never being class settings on the header's root: rule K2 keeps that true. Rebase keeps both `KEPT` edits |
| site-scroll-lock (Mini) | running | `classes.ts`, `parts.ts` | its lock sits on top elements; K2 leaves their position in CSS; a Nav or Form is never a part's top element |
| site-menu-motion (Mini) | running | `slide.ts`, `open-paste.ts`, `opens.ts`, `src/web/readers/details.ts`, `src/web/read/code.ts` | menus and `details` inside opened boxes are left to it (Q6 A; section D refuses a list inside an opened box); K3 keeps the properties its slide writes in CSS |
| media-clickable (Mini) | running | `media.ts` (`imageSettings`), `background.ts`, `convert.ts` | a Video's poster uses `imageSettings`; its Background step and the new settings both sit in `fromStates` |
| media-avif-alt | running | `media.ts`, the upload flow | no shared line expected; a poster follows whatever the media map holds |
| shared-palette (Mini) | planned | `colours.ts` | the new colour settings take whatever names it settles |
| bricks-icons | planned | `kinds.ts` (icons), the Toggle's icon | once icons are Bricks icons, the ☰ can become Bricks' Toggle (Q4) |
| plugin-parity | planned | `src/core/emit/nav.ts`, `form.ts`, `video.ts` | this job only moves three small shapes into modules of their own (Architecture); whoever merges second rebases the import lines |

Order: … → site-no-div → site-shared-styles → **importer-parity**. The builder starts only when `git log main` holds
site-shared-styles' build commit, and rebases onto main before `ready-for-review`.

## Acceptance criteria (all **proposed**)

Fixtures are generic, never copies of B-Dry. "Drawn" means as `site:check` draws a paste (Bricks' front-end CSS, the
hostile theme, pictures from the capture's bytes). "The switch off" is `ConvertOptions.parity: false`, a test and
diagnosis switch no command line can set; single features switch with `parity: { names, controls, style, divider,
accordion, slider, video, form, nav }`. "Within 2 px" is measured as site-native-structure measures it.

- AC1 (proposed): Given a captured page whose elements carry `aria-label`, `role`, `title`, `aria-hidden`, `aria-current`, `lang`, `dir`, `tabindex` or a link's `rel`, the Bricks element that stands for each carries them: an element with a link holds the `aria-label`, `title` and `rel` in its link control (`link.ariaLabel`, `link.title`, `link.rel`), an Offcanvas and a Nav (Nestable) the `aria-label` in their own `ariaLabel`, every other case custom attributes `_attributes: [{ id, name, value }]` with the same ids on every run; `id`, `aria-controls`, `aria-expanded`, `aria-labelledby`, `aria-describedby` and `for` are never pasted. Test `test/unit/site-names.test.ts` "a site element's name, role, title and tabindex reach its Bricks element: a link's in its link control, the rest as attributes".
- AC2 (proposed): Given a wrapper that folds into its element (the Elementor fold and the neutral-wrapper fold), an element a Button absorbs, an opener of an Offcanvas, and an Accordion's titles and panels: the wrapper's and the absorbed element's attributes sit on the element that stands for them where it has none of that name (its own wins), the opener keeps the site's `aria-label` beside its Interaction, an Accordion's titles and panels and a Slider's slides carry none of the site's `role`, and each part's notes hold `Names: <n> kept (<a> in link controls, <b> as attributes)` and one line for each kind of name that couldn't be kept. Test `test/unit/site-names.test.ts` "a folded wrapper's and an absorbed element's names move to the element that stands for them, and what can't be kept is named".
- AC3 (proposed): Given the fixture site `parity-names` (an icon-only link with `aria-label`, a linked icon picture with `alt`, a menu button with `aria-label` that opens a drawer, a `div role="button" tabindex="0"`, a decorative `aria-hidden` box, a `nav` with `aria-label`, a link with `title` and `rel`) captured and pasted, in Chrome's accessibility tree every such element of the drawn paste has the role and the name it has on the site page, the `div role="button"` takes the keyboard focus, and every part is within 2 px of the site at every width the capture read, drawn with Bricks 2.4.2 and with 2.3.9. Test `test/web/site-names.test.ts` "icon links, a menu button and named boxes read with the site's own role and name in the drawn paste".
- AC4 (proposed): Given a capture made with this build, every element keeps `tabindex`, `aria-current`, `aria-expanded`, `aria-controls`, `for`, `action` and `method` beside the attributes kept before and `web.code.keeps` lists them; a capture without `keeps` converts with no error, pastes what it holds and says once to capture again for tabindex and form addresses. Test `test/web/capture-attrs.test.ts` "a capture keeps tabindex, aria-current, aria-expanded, aria-controls, for, action and method, and an older capture still converts".
- AC5 (proposed): Given a class's declarations, `position`, the offsets, `z-index`, `order`, equal `overflow-x` and `overflow-y`, `flex-grow`, `flex-shrink`, `flex-basis`, `align-self`, `opacity`, `cursor`, `object-fit`, the four corners, a border by rules B1–B5 and one box shadow are Bricks settings with the keys and shapes of the table under "Settings instead of custom CSS" when every value is plain and changes only on Bricks' breakpoints, and leave the custom CSS; each refusal keeps the whole property or group in the custom CSS: a value that isn't plain, a change at a width of the site's own, a block bounded below, `align-self: stretch`, a bare `flex-basis`, unequal overflow axes, each of B1–B5 broken, `box-shadow: none` or two shadows, a top element's position (K2), a property another rule of the paste writes (K3), a class written inside a flat wrapper (K4); a colour of a new setting links to the palette. Test `test/unit/site-controls-more.test.ts` "border, corners, one shadow, position, overflow and the flex item values are Bricks settings where every value is plain and on Bricks' breakpoints, else the class's CSS".
- AC6 (proposed): Given an element whose own `hover` look changes a property that is a setting, with a plain value, the change is the setting's `:hover` key (typography colour, background colour, border colour, box shadow, opacity, cursor) and leaves the class's `:hover` rule; a property a `focus`, `focus-visible` or `focus-within` look also changes, one another element's hover changes, one changed on `::before`, and a hover value that isn't plain all stay custom CSS with their base. Test `test/unit/site-controls-more.test.ts` "what only the element's own hover changes of a setting is Bricks' :hover setting; a focus look keeps the property in CSS".
- AC7 (proposed): Given a class with a Border or Box shadow setting, the site route's test renderer prints what Bricks' `assets.php` prints for it: `border: 0` for four zero widths, `border: W style colour` for four equal widths with a style, `border-<side>: W style colour` or the side longhands otherwise, `border-style` / `border-color` alone, `border-radius` with one or four values or the corner longhands, `box-shadow: [inset] x y blur spread colour`; the Figma route's printing is unchanged. Test `test/browser/render-site-controls.test.ts` "the site route prints Border and Box shadow settings as Bricks' assets.php does".
- AC8 (proposed): Given the fixture sites `parity-controls` (new), `plain-natives`, `elementor-natives`, `shared-looks`, `site-menu`, `elementor-faq` and `elementor-slider`, each captured and converted with `parity: { controls: false }` and with it on, drawn with Bricks 2.4.2 and with 2.3.9 at every width the capture read: every element that takes a box has the same computed style (every property, its `::before` and `::after`) and the same box in both drawings, also while each element with a hover setting is hovered, an Accordion's first closed item is opened and a drawer is open. Test `test/web/site-controls.test.ts` "with the new settings every element draws as without them, at rest, hovered and opened, at every width, Bricks 2.4.2 and 2.3.9".
- AC9 (proposed): Given a painted Button (an Elementor button widget's, and a painted link of plain words found by shape), its settings hold `style: "primary"`, a Button painted nowhere it shows holds none, and the fixture sites `plain-natives` and `elementor-natives` converted with `parity: { style: false }` and with it on draw every element with the same computed style and box at every width the capture read, hovered too, with Bricks 2.4.2 and with 2.3.9; the notes say once that Buttons carry Style: Primary. Test `test/web/site-button-style.test.ts` "a painted Button carries Style: Primary and draws exactly as with no Style".
- AC10 (proposed): Given B-Dry's saved 2026-10-29 home served on 127.0.0.1 (never the live site; the stand-in capture of the base's B-Dry test), with the Elementor step and without it: the pastes hold names, the new settings and Style: Primary, every element that takes a box draws as with the switch off at one width per range (Bricks 2.4.2 and 2.3.9), and no `site:check` row is worse than the base's by more than 0.5 px. Test `test/web/site-parity-bdry.test.ts` "B-Dry's saved page draws the same with names, the new settings and Style: Primary, on both routes" (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, optional `F2B_ELEMENTOR_STANDIN`).
- AC11 (proposed): Given the fixture site `parity-natives` (no page builder), its `hr`, its empty box drawing a 1 px line and its empty 3 px coloured box each paste as one Bricks Divider with no settings but `role="separator"` on the `hr`'s, the look on its class, while a 12 px spacer, a line that changes on hover and an inline line stay Blocks; every part is within 2 px of the site at every width the capture read, drawn with Bricks 2.4.2 and with 2.3.9. Test `test/web/site-plain-natives.test.ts` "a plain line is a Bricks Divider that draws as the site's".
- AC12 (proposed): Given `parity-natives`, its three `details` in a row (triangle hidden, a summary and one box each, the second open) and its ARIA list (`aria-expanded` questions whose `aria-controls` name their answers) each paste as one Bricks Accordion (Nestable) with the site's open item open at load; in the drawn paste a click on a closed question opens it with the site's open look and the paste is within 2 px of the site with the same items open; a single `details`, a `details` showing the browser's triangle and one holding two boxes after its summary stay Blocks that open by themselves; a capture without `keeps` leaves the ARIA list as before. Test `test/web/site-plain-natives.test.ts` "details in a row and an ARIA list of questions are a Bricks Accordion that opens as the site's".
- AC13 (proposed): Given `parity-natives`, its Swiper slider and its Splide slider (three slides each, arrows and dots, one autoplaying) each paste as one Bricks Slider (Nestable) holding the real slides in order with the library's own timing, per view and gap, and Bricks' arrows and dots where the site draws them; held on its first slide the paste is within 2 px of the site at every width the capture read (Bricks 2.4.2 and 2.3.9) and Bricks' next arrow shows the second slide; a Swiper with one slide stays as today, and a `web.sliders` record of another library converted from the same capture (its library renamed in a copy) stays static with all its slides and its note. Test `test/web/site-plain-natives.test.ts` "a Swiper or Splide slider outside Elementor is a Bricks Slider that draws and moves as the site's".
- AC14 (proposed): Given the fixture site `parity-media`, its `video` with one file (muted, looping, autoplaying, inline, with a poster) and its `video` with controls each paste as a Bricks Video (File) holding exactly those switches, the file's address and the poster; its YouTube frame and its Vimeo frame as Bricks Video (YouTube, Vimeo) with the id and the frame's title; a map frame, a `video` with two files and one with a caption track stay Code elements labelled Embed or Video and are named; every part is within 2 px of the site at every width the capture read (Bricks 2.4.2 and 2.3.9), and with a media map the poster is the library's picture. Test `test/web/site-video.test.ts` "a video file and a YouTube or Vimeo frame are Bricks Videos that take the site's box".
- AC15 (proposed): Given the fixture site `parity-menu`, its header `nav` holding one list (four links, one item with a sub-list that opens on hover) pastes as Nav (Nestable) › Nav items (`tag: "ul"`, hidden class exactly `brx-nav-nested-items`) › four Blocks with `tag: "li"` holding the site's links, `mobileMenu: "never"`, `ariaLabel` the site's; its footer `nav` of bare links as a Nav whose items block takes no box; a `nav` holding two lists and the menu inside the drawer stay Blocks; in the drawn paste each `li` is printed once (no `li` inside an `li`), the bar is within 2 px of the site at every width the capture read (Bricks 2.4.2 and 2.3.9), hovering the item shows its sub-list as on the site, and the ☰ still opens the drawer. Test `test/web/site-nav.test.ts` "a menu bar is a Bricks Nav (Nestable) that draws as the site's, its sub-list and its phone menu working as before".
- AC16 (proposed): Given a simple form (rules F1–F3), its paste is one Bricks Form whose `fields` hold each field's type, label, placeholder, required mark and a drop-down's options in order, `submitButtonText` the send control's words, `showLabels` when a label shows, and the plugin's sending settings (`actions: ["email"]`, `emailTo: "admin_email"`); every key is in `reference/bricks/form-schema.json`; no setting and no class holds the old site's form address; hidden inputs are left out and counted; and each of these stays as before with its reason in the notes: fields in rows or columns, a tick box, a radio group, a file field, a captcha, a `fieldset`, a control inside its label, a label holding an element, two send controls, a form inside an opened box. Test `test/unit/site-form.test.ts` "a simple form is a Bricks Form that emails the admin; any other form stays as before and says why".
- AC17 (proposed): Given the fixture site `parity-form` (a contact form: name, email, phone, a drop-down, a message, a send button, each field a label over its box, a focus look on the boxes, a hover look on the button), the paste's Form drawn with Bricks 2.4.2 and with 2.3.9 puts every label, box and the button within 2 px of the site's at every width the capture read, a focused box and the hovered button show the site's look, the loading mark is hidden, and the page's second form (two fields in a row) is drawn as before. Test `test/web/site-form.test.ts` "a simple form draws as the site's inside Bricks' Form, focused and hovered too".
- AC18 (proposed): Given every code fixture and this job's fixtures (both routes, both text modes, parts and sections), no paste holds a Div; every Block and Code element has a label and no Nav (Nestable), Form, Video, Divider, Accordion or Slider has one of the importer's; no two classes of one element write one property; every class name starts with the page's name or is one of the fixed shared names (`site-form-<4>` among them); `payloadProblems` finds nothing; and the same capture converted twice gives byte-identical pastes. Test `test/unit/site-parity-invariants.test.ts` "the new elements keep the importer's standing rules: no Div, labels, one writer, page-named classes, valid payloads".
- AC19 (proposed): Given the switch off, every paste of every code fixture (the list `test/unit/lib/site-pins.ts` gives) is byte-identical to the base's paste. Test `test/unit/site-parity-off.test.ts` "with importer-parity off every paste is byte for byte as before it" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC20 (proposed): Given any Figma design and the Figma panel's website route, the conversion is byte-identical to the base's (`npm run corpus` no worse, `test/unit/plugin-convert.test.ts`, `emit-form`, `emit-video` and the phone-menu tests pass). Test `test/unit/site-parity-figma.test.ts` "every Figma replay and the panel's website route are byte-identical to the base's" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC21 (proposed): Given `npm run site`, each part's notes hold, after site-shared-styles' lines, `Names: …`, `Settings: <n> more values are Bricks settings (border <a>, position <b>, flex item <c>, shadow <d>, hover <e>)` and, when any, `Natives: <list of Nav (Nestable), Form, Video, Divider, Accordion, Slider with counts>` plus each feature's own lines; `structure.txt` shows the new elements by Bricks' names; the usage lines are unchanged. Test `test/web/site-cli.test.ts` "site names the kept names, the new settings and the native elements in its notes and structure.txt".
- AC22 (proposed) (live): Justin scans bdryswi.com again with the new build, runs the import with `--elementor`, empties B-Dry staging `/homev2/` and pastes header, page and footer: the page looks as before at 1440 and at 390; clicking a hero button shows Style: Primary; its class shows Border and Position filled in Bricks' own fields; right-click the ☰ in the browser → Inspect → Accessibility shows its name "Menu" (not "Open"). Test: Justin's paste check `<importer-parity id at merge>` (HANDOFF "End-of-run check list").

RED on the base: the first nine, the eleventh to the seventeenth and the twenty-first (no `_attributes`, no new
setting, no Style, no Divider, Accordion or Slider outside Elementor, no Video, Form or Nav, no such note). Regression
pins: the tenth's rows, the eighteenth (green on the base for what the base has), the nineteenth and twentieth
(recorded in Task 1). Owed to Justin beyond the last criterion, when he imports a page that has one: a menu list, a
form, a video, a plain line, `details` (HANDOFF names them; bdryswi.com's home has none).

## Architecture

Pure, in `src/core/site/` (built-ins only), except three shapes moved inside `src/core/emit/` and one list in the
capture. Nothing under `src/core/adapt`, `style`, `understand`, `normalise`, `src/plugin` or `src/ui` changes.

**Shared with the plugin without forking** (`test/unit/site-isolation.test.ts` lets `src/core/site/` import from
`src/core/emit/` only modules that reach no Figma stage, as `emit/editor-text.ts` was split for Rich Text; the
plugin's writers import the same modules, so both tools write one shape and the Figma bytes stay as they are):
- `src/core/emit/nav-shape.ts` (new, imports nothing): `ITEMS_CLASS`, `CLOSE_CLASS`, `navItems(): Settings` (`{ tag:
  "ul", _hidden: { _cssClasses: ITEMS_CLASS } }`). `emit/nav.ts:17-18,39` imports them.
- `src/core/emit/form-shape.ts` (new, imports `./ids.ts` only): `SENDING` (moved from `emit/form.ts:26-30`) and
  `fieldSetting(id: string, f: { type: string; label: string; placeholder?: string; required?: boolean; options:
  string[]; width?: string }): Settings` (the body of `formSettings`' `fields.map`). `emit/form.ts` calls both.
- `src/core/emit/video-shape.ts` (new, imports nothing): `videoKeys(source: "file" | "youtube" | "vimeo", url: string,
  flags: { autoplay?: boolean; loop?: boolean; mute?: boolean; inline?: boolean; controls?: boolean; preload?:
  string }, fit?: string): Settings`. `emit/video.ts` `videoSettings` becomes a call with its two flag sets
  (`plays` → autoplay, mute, loop, inline; else controls), key order kept.
- The isolation test's allow-list gains exactly these three, and a test like its `editor-text` one checks what each
  imports.

**New files in `src/core/site/`** (each ≤ 200 lines):
- `names.ts`: `NAMEABLE`, `namesOf(attrs, el: { name: string; settings: Settings }, key: string): { settings:
  Settings; kept: { link: number; attr: number }; lost: string[] }`; `handDown(wrapper: CodeNode, element: CodeNode):
  { attrs: Record<string, string>; clashes: number }` (used by both folds).
- `controls-more.ts`: the prototype's `MORE_RULES`, `borderOf`, `shadowOf`, the overflow, corner, border and shadow
  groups and the hover keys (`<P>/proto-controls.diff`, without its `globalThis` switch and its counters);
  `controls.ts` `controlsFor` calls it when `ControlOptions.more` is set and gains `hover?: CodeDecls`, `onlyHover?:
  ReadonlySet<string>`, returning `hovered: Set<string>` (the hover properties it took).
- `plain-natives.ts`: `plainNatives(capture, code, pr, root, taken): { picks: Map<string, TreePick>; nodes; looks:
  AccordionLook[]; sliders: SliderLook[]; pasteHidden: Set<string>; notes: string[] }` = `dividerAt`, the accordion
  finder over `accordionShape` / `accordionPicks` / `openLook`, the slider finder over `sliderOf`.
- `video.ts`: `videoOf(n: CodeNode, markup: string, media?): { settings: Settings; inner: "video" | "iframe"; notes:
  string[] } | { why: string }` (attributes read from the element's own markup with one small tag reader beside
  `markup.ts`; never from CSS).
- `form.ts`: `formShape(code, pr, path): FormShape | { why: string }`, `formPick(shape, …): { pick: TreePick; parts:
  Array<[string, string]>; notes: string[] }`; `SITE_FORM` and its CSS in `classes.ts` (`versioned("site-form",
  …)`, as `site-slider-<4>`).
- `nav.ts`: `menuShape(code, pr, path, opened): MenuShape | { why: string }`, `navPicks(shape, …)`.

**Changed files:**
- `src/web/read/code.ts`: `KEPT` + the seven names; the reading sets `keeps`. `src/core/snapshot/web.ts`:
  `WebCode.keeps?: string[]`, the `attrs` comment. `src/web/code.ts` passes it through.
- `convert.ts`: `ConvertOptions.parity?: false | Partial<Record<"names" | "controls" | "style" | "divider" |
  "accordion" | "slider" | "video" | "form" | "nav", boolean>>` (default all on). In `prepare`: after the Elementor
  step and before site-no-div's natives, `plainNatives`, then `menuShape` / `formShape` picks (never over a pick);
  the element's own hover handed to `fromStates`; `keep` gains K2 and K3; the notes. At most 40 lines here (the file
  is over the 300-line rule already; logic lives in the new files).
- `tree.ts`: `TreeNode` settings pass through `namesOf` after `picked` (the wrap's Block carries them); `TreePick`
  gains `inner?: string` (a Video's ` > video`), read by `whereOf`.
- `kinds.ts`: a painted Button's `style: "primary"`; a `video` / video frame → `videoOf`; `BOX_LOOK.hr`.
- `elementor-fold.ts`: `:428` adds `style: "primary"`; the fold hands a folded wrapper's attributes down
  (`handDown`); `sliderOf`, `accordionShape` and `dividerShape` take a path where they took an Elementor entry
  (their Elementor callers pass `e.path` / `e.holder`).
- `fold-boxes.ts` (site-no-div's): `handDown` on a fold.
- `widgets.ts`: a slider `plainNatives` rebuilds is not marked static.
- `class-source.ts` (site-shared-styles'): `fromStates` passes `more`, `hover`, `onlyHover`; `inked` covers
  `_border.color`, `_boxShadow.color` and the `:hover` keys.
- `parts.ts` / `open-paste.ts`: a Nav's `ariaLabel`; the notes' new lines; `SITE_FORM` in the shared classes.
- `labels.ts`: no label for the new natives; "Embed" / "Video" stay for refused ones.
- Renderer (tests only; `test/browser/render.ts`, `render-form.ts`, `render-nav.ts`, site route only, each printed
  shape pinned by a renderer unit test citing the saved PHP): `_border` and `_boxShadow` as `assets.php`;
  `_attributes`, `link.ariaLabel`, `link.title` on every element that has them (it prints `link.rel` at `:142` and
  `_attributes` at `:174` today: the builder checks each element kind); `video` as `video.php`; `form` as `form.php`
  (labels with `for`, `form-group`, the send button with its `loading` span); `nav-nested` with `data-toggle` and the
  `<li` rule of `container.php`.
- `reference/bricks/`: `frontend-2.2-researched/el-form.min.css`, `el-video.min.css`, `el-divider.min.css` (the GPL
  2.2 copies in `<P>/bricks-2.2/`, with `SHA256SUMS`), and README entries: custom attributes and link names
  (`base.php` lines), how Border and Box shadow print (`assets.php` lines), the Theme Style's button selectors, the
  Nav's `li` rule and `mobileMenu: "never"`, the Form's and Video's printed structure; each marked "read in Bricks
  2.2's source, not seen on 2.3.9 / 2.4.2".
- `tools/`: none (every command reaches this through `sitePage`); `tools/site-no-revert-golden.ts` is run, not
  changed.

## Tasks (test-first; commit after each passing task, files by name; never commit CLAUDE.md)

Setup (every task): the job's worktree; `export PATH=/home/justin/.local/node-v22.23.3/bin:$PATH
TMPDIR=/home/justin/.cache/ipb/t1 CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; heavy runs under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G); a command that dies with SIGTERM, 143, 137
or "Killed" may be earlyoom: check its journal first. Receipts go under a folder given by a variable
(`F2B_PARITY_OUT`), never one fixed shared folder. Read `figma-to-bricks/references/repeat-mistakes.md` and
`feature-dispatch/references/repeat-mistakes.md` first. Close every Chrome a run starts. Never load bdryswi.com,
B-Dry staging or any live site.

### Milestone 0: the base's facts

**Task 1 (records and pins).**
- Check `git log --oneline main` holds site-shared-styles' build commit; else stop and report.
- Copy this plan to `docs/plans/2026-11-11-importer-parity.md`; start
  `.superpowers/sdd/2026-11-11-importer-parity/progress.md`.
- Base tallies into the ledger: `node --test "test/unit/**/*.test.ts"`, `npm run corpus`, the web site tests and
  browser tests by file with pass or fail (a base failure is named, not fixed here).
- On a `git archive <base>` tree record `test/fixtures/site-parity-pins.json` (the sha256 of every paste
  `test/unit/lib/site-pins.ts` lists) and `test/fixtures/site-parity-replay-pins.json` (the sha256 of `bricks.json`
  from `npm run replay` for each corpus file and of each hand-made panel capture's conversion), with site-no-div's
  recorder given other output paths; write the two named-only tests (the nineteenth and twentieth criteria). Add
  `parity` to `ConvertOptions` (read nowhere yet). Commit.
- Re-read every file:line of "Why the importer lacks them today" on the base and write the real lines in the ledger.

### Wave 1: names, settings, Button style (what bdryswi.com's home shows)

**Task 2 (the shared shapes; no behaviour change).** Add `emit/nav-shape.ts`, `emit/form-shape.ts`,
`emit/video-shape.ts`; point `emit/nav.ts`, `form.ts`, `video.ts` at them; extend the isolation test's allow-list
and add its "imports nothing but ids" test. Gate: `npm run check`; `F2B_PIN_BASE=1 node --test
test/unit/site-parity-figma.test.ts` green (every replay byte for byte); `test/unit/emit-form.test.ts`,
`emit-video.test.ts` and the phone-menu unit tests pass unchanged. Commit.

**Task 3 (the capture; the fourth criterion).**
- RED: `test/web/capture-attrs.test.ts` captures `parity-names` (Task 5's fixture; write the fixture's HTML first)
  and asserts the seven attributes on their nodes and `web.code.keeps`; converts a hand-made capture without `keeps`
  and asserts the note. Fails: the attributes are absent.
- GREEN: `KEPT`, `keeps`, the note in `prepare`.
- Captures of fixtures whose pages hold these attributes change (`site-menu`: `aria-controls`, `aria-expanded`;
  `code-page`: `action`, `method`): regenerate each saved capture and golden through its own generator and name it
  in the ledger with the reason "the capture keeps more attributes". A paste may change only where a words node's
  inline HTML gains a kept attribute; name each.

**Task 4 (names; the first and second criteria).**
- RED: `test/unit/site-names.test.ts` on `pageCode()` / `elementorCode()` with `patch`es: one case per row of the
  table in section A and per bullet under it. Fails: no `_attributes`, no `link.ariaLabel`.
- GREEN: `names.ts`; `tree.ts` applies `namesOf`; `handDown` in `elementor-fold.ts` and `fold-boxes.ts`; the
  Offcanvas's and openers' cases; the notes. The Nav (Nestable)'s row of the table is asserted from Task 16 on (with
  Q2 B that clause of the first criterion moves to wave 3's job).
- Mutation check (names are an accessibility guard): for each row of the table remove its arm and see a named case
  fail; the table goes in the ledger.

**Task 5 (the third criterion).** Fixture `test/fixtures/web/sites/parity-names/` (`index.html`, `style.css`,
`drawer.js` shaped like `site-menu`'s). `test/web/site-names.test.ts`: `captureFixture`, `sitePage`, draw each part;
read both pages' accessibility trees over CDP (`Accessibility.getFullAXTree`), pair elements by the paste's
`sources`, compare `role` and `name`; press Tab to the `div role="button"`; the 2 px rows through `checkPage`, once
per Bricks version. The renderer prints `_attributes`, `link.ariaLabel` and `link.title` wherever Bricks does
(Architecture); its unit test first.

**Task 6 (the seventh criterion: the renderer).** RED → GREEN `test/browser/render-site-controls.test.ts` (each case
of `assets.php` L2111-2337 as printed text) and the site route's `_border` / `_boxShadow` printing
(`<P>/proto-controls.diff`'s `render.ts` hunk is the working code; keep the Figma route's printing as it is: the
criterion's last clause is a byte check of one Figma fixture's rendered CSS before and after).

**Task 7 (the fifth criterion: settings).**
- RED: `test/unit/site-controls-more.test.ts`, first test: one case per table row and per refusal the criterion
  names, through `controlsFor` and through `sitePage` on a `patch`ed fixture (K2, K3, K4, the palette).
- GREEN: `controls-more.ts` from the prototype; `controlsFor`'s `more`; `fromStates`; `prepare`'s `keep` for K2
  (`t.parent === 0`) and K3. For K3, list every writer of `_cssCustom` (`grep -n "_cssCustom" src/core/site/*.ts`),
  write in the ledger which properties each writes for which element, and hand them in `keep`.
- **Stop condition:** a setting whose printed CSS the eighth criterion's oracle shows different on any fixture →
  tighten its rule or drop that property from the table (it stays CSS), name it in the ledger; never change the
  oracle.

**Task 8 (the sixth criterion: hover).** RED: the file's second test. GREEN: `hover` / `onlyHover` from the element's
own looks (`<P>/proto-controls.diff`'s `convert.ts` hunk, moved into `fromStates`), the `:hover` keys, the taken
properties leaving `ClassCss.states`.

**Task 9 (the eighth criterion: nothing moves).** Fixture `parity-controls` (boxes with a border on one side, on four
sides, corners, one shadow and two shadows, a positioned badge with offsets and a z-index, a clipped card, flex items
that grow and shrink, a hover that changes a border colour and a shadow, a focus look, values that change at 767 and
at the site's own 900). `test/web/site-controls.test.ts` over `test/web/lib/style-equal.ts` with three passes: at
rest; each element with a hover setting hovered (CDP `CSS.forcePseudoState`, as `snap`'s hover scripts do); an
Accordion item and a drawer opened (Bricks' own scripts, as the FAQ's and site-menu's tests do).

**Task 10 (the ninth criterion: Button style).** RED → GREEN `test/web/site-button-style.test.ts`; `style: "primary"`
at the two producers; the note. Then run site-shared-styles' button-look tests: a Button's look class must not hold
`style` (it is the element's own setting).

**Task 11 (the tenth criterion and wave 1's gate).** `test/web/site-parity-bdry.test.ts` (shaped like
`test/web/site-shared-styles-bdry.test.ts`, same variables). Gate: `npm run check`; `node --test
"test/web/site-*.test.ts"` (capped); the nineteenth and twentieth criteria's pins; goldens that hold whole pastes
(`site-basic-golden.json`, `site-slider-base/`, `site-motion-base/`, `site-native-pins.json`,
`site-no-div-pins.json`, `site-no-revert-main.json` through `node tools/site-no-revert-golden.ts .`) made again
through their own generators **only after** the switch-off pin is green, reason "names, settings, Button style";
story pins of merged jobs are not regenerated. Commit. With Q2 B this is where wave 1 stops at `ready-for-review`.

### Wave 2: Divider, Accordion, Slider, Video

**Task 12 (the eleventh criterion: Divider).** Fixture `parity-natives` (its lines first). Unit cases in
`test/unit/site-plain-natives.test.ts` (each shape and refusal), then `test/web/site-plain-natives.test.ts`' first
test. GREEN: `plain-natives.ts` `dividerAt`; `BOX_LOOK.hr` (Chrome's `html.css`: `margin-block: 0.5em`,
`margin-inline: auto`, `border-style: inset`, `border-width: 1px`, `overflow: hidden`, `color: gray`; the builder
reads the values from Chrome's computed style of a bare `hr` in a test, not from memory). **Stop condition:** an `hr`
row off by more than 2 px → the `hr` stays a Block with its own tag, named.

**Task 13 (the twelfth criterion: Accordion).** `accordionShape` takes `{ path, holder }` (no Elementor type); the
finder for `details` runs and for ARIA lists; the picks, the open look and the scopes join the Elementor step's own
lists in `prepare` (`looks`, `scopes`, `pasteHidden`). The web test opens an item by a click, as
the FAQ's web tests do (`test/web/site-elementor-proof.test.ts`). **Stop condition:** a `details` list that can't be drawn within 2 px
open and closed → `details` are left out of this job (Q11 falls to B), named.

**Task 14 (the thirteenth criterion: Slider).** `sliderOf(capture, code, pr, root, boxes, el?)`; Splide's options →
Bricks' keys by name (a unit row per key, as `test/unit/site-slider.test.ts` has for Swiper's); `widgets.ts`. The
fixture's Swiper is the copy `elementor-swiper8` serves; its Splide is Bricks' own
(`reference/bricks/frontend-2.3.9/splide.min.js`, `splide-layer.min.css`). **Stop condition:** Splide can't be held
within 2 px → Swiper only, Splide stays static, named.

**Task 15 (the fourteenth criterion: Video).** Fixture `parity-media` (the files' addresses answer 404: only the
boxes and the poster are compared). `video.ts`, `kinds.ts`, `TreePick.inner` / `whereOf`; the renderer prints a Video
as `video.php` (unit first). Wave 2's gate as Task 11's.

### Wave 3: Nav, Form

**Task 16 (the fifteenth criterion: Nav).** Fixture `parity-menu`. Add the Nav's `ariaLabel` case to
`test/unit/site-names.test.ts`' first test. Unit cases in `test/unit/site-nav.test.ts` (M1–M3
and each refusal), then the web test. GREEN: `nav.ts`; the renderer prints `nav-nested` on the site route as
`nav-nested.php` L1138-1190 does, with `container.php`'s `<li` rule (unit first), and runs Bricks' own
`bricksNavNested()` as the Figma route's `render-nav.ts` does. **Stop conditions:** the `li` rule can't be shown to
hold (a printed `li` inside an `li` in any version's render) → list menus keep Blocks and only the report changes;
the bare-link menu isn't within 2 px → M3 is dropped, named.

**Task 17 (the sixteenth criterion: Form shape).** `test/unit/site-form.test.ts` on a hand-made capture fixture
`test/fixtures/site-form-code.ts` (`formCode(over?)`): the simple form and one case per refusal. GREEN: `form.ts`
`formShape`, `formPick` through `fieldSetting` and `SENDING`; a key check against `form-schema.json` as
`test/unit/emit-form.test.ts` does.

**Task 18 (the seventeenth criterion: Form drawn).** Fixture `parity-form`; `SITE_FORM`; the renderer prints the
site route's Form as `form.php` (unit first); `test/web/site-form.test.ts` with focus and hover forced. **Stop
condition:** the simple form isn't within 2 px → the Form stays out of this job (Q7 falls to B), the shape reader and
its notes stay (they name why), reported.

### Close

**Task 19 (the eighteenth and twenty-first criteria).** `test/unit/site-parity-invariants.test.ts` (site-no-div's and
site-shared-styles' invariants over this job's fixtures and elements; add each new producer to
`test/unit/site-no-div.test.ts`); the notes and `structure.txt`; `test/web/site-cli.test.ts`' new test.

**Task 20 (gates).** `npm run check`, `npm run corpus` (no worse than Task 1's), `npm run test:browser`, `npm run
test:web`, the named-only tests (`F2B_PIN_BASE=1`; the tenth criterion's variables), each receipt in the evidence
folder with its head. One screenshot per criterion that is visual (the third, eighth to fifteenth and seventeenth:
site | paste at 1440 and 390, written by `F2B_PARITY_OUT`), a terminal capture for the others. Rebase onto main if it
moved; rerun what the rebase touched. Stop at `ready-for-review`.

**Task 21 (Docs & records).**
- This plan in `docs/plans/2026-11-11-importer-parity.md` (Task 1); the finisher moves the ledger to
  `docs/plans/2026-11-11-importer-parity-ledger.md` before the final premerge commit and rebase.
- `docs/HANDOFF.md`: a new section above the previous top `## ` heading ("An importer paste keeps the site's names
  and uses Bricks' own settings and elements": the rules A–F, what is refused and why, the planner's and builder's
  numbers, the rulings "not yet confirmed" for Q1–Q14, "Deferred": Bricks' Dropdown and Toggle, forms with rows, tick
  boxes and files, Slick, focus looks as settings, transforms and transitions as settings, `::placeholder` looks,
  reading the receiving site's Theme Style, a byte comparison of the 2.2 form, video and divider CSS with 2.3.9's and
  2.4.2's), and its paste check at the top of "End-of-run check list" with the next free id (checked free on main and
  on every local branch), build "set at the merge", with the checks owed when a page has a menu, a form, a video, a
  line or `details`.
- `reference/bricks/README.md`: the entries Architecture names.
- `BUILD` bumped by the merge finisher; main `CLAUDE.md` after the merge: the Status build line and one line for this
  feature with its paste check; standing rules: "**A website paste keeps the site's accessibility names**
  (`test/unit/site-names.test.ts`; never an attribute that names an id)", "**The importer and the plugin write a Nav,
  a Form's fields and a Video's keys through `emit/nav-shape.ts`, `form-shape.ts`, `video-shape.ts`**", "**A top
  element's position stays custom CSS on the importer** (page-wide classes meet it at class weight)"; decisions: "a
  scanned site's form is a Bricks Form that emails the admin; the old site's form address is never posted to", "a
  Swiper or Splide slider outside Elementor is a Bricks Slider (replaces 'Keep all its slides' for those)", "a painted
  importer Button has Style: Primary (replaces site-native-structure Q6 A)"; and "Waiting on the user → Bricks
  samples" loses nothing (the Nav and Offcanvas stand-ins stay owed as copies). If the write is refused:
  `~/.hermes/plans/figma-to-bricks/importer-parity-claude-md-pending.md`.

## Tests and validation

| Test (file, name) | Kind | Criterion |
|---|---|---|
| `test/unit/site-names.test.ts` (two tests) | unit + mutation table | first, second |
| `test/web/site-names.test.ts` | Chrome, accessibility tree | third |
| `test/web/capture-attrs.test.ts` | capture | fourth |
| `test/unit/site-controls-more.test.ts` (two tests) | unit | fifth, sixth |
| `test/browser/render-site-controls.test.ts` | renderer unit | seventh |
| `test/web/site-controls.test.ts` | Chrome, computed style | eighth |
| `test/web/site-button-style.test.ts` | Chrome, computed style | ninth |
| `test/web/site-parity-bdry.test.ts` | Chrome, named-only | tenth |
| `test/web/site-plain-natives.test.ts` (three tests) | Chrome | eleventh to thirteenth |
| `test/web/site-video.test.ts` | Chrome | fourteenth |
| `test/web/site-nav.test.ts` | Chrome | fifteenth |
| `test/unit/site-form.test.ts`, `test/web/site-form.test.ts` | unit, Chrome | sixteenth, seventeenth |
| `test/unit/site-parity-invariants.test.ts` | unit, default suite | eighteenth |
| `test/unit/site-parity-off.test.ts`, `site-parity-figma.test.ts` | named-only pins | nineteenth, twentieth |
| `test/web/site-cli.test.ts` (new test) | CLI | twenty-first |
| Justin's paste check | live | twenty-second |

Supporting unit tests (not criteria): `test/unit/site-plain-natives.test.ts`, `site-nav.test.ts`,
`site-video.test.ts`, the renderer units for Video, Form and Nav, the three shape modules' import test.

## Risks and open points

- **Size.** Three waves, each about one importer job. Wave 1 is prototyped for its riskiest part (the settings);
  waves 2 and 3 are not prototyped: each task has a stop condition that leaves the shape as it is today, named, and
  never raises a tolerance. If two or more stop conditions fire in wave 3, report before going on.
- **Read in Bricks 2.2's source, not seen on 2.3.9 or 2.4.2:** how custom attributes and link names print, the Border
  and Box shadow printing, the Nav's `li` rule (`@since 2.0`) and `mobileMenu: "never"`, the Form's and Video's
  printed structure, the form, video and divider CSS. The settings' key shapes are Justin's own copies; the plugin
  has written `_attributes`, `_border`, `_boxShadow` and `_position` to his live sites since October. The planner
  loaded no live site; a public byte comparison with darksalmon's (2.3.9) and B-Dry staging's (2.4.2) element CSS is
  a follow-up the main session can ask Justin about.
- **Still unverified in Bricks by a round trip** (CLAUDE.md "Unverified in Bricks"): `_attributes` with `aria-*`,
  `tabindex` and `role` pasted from outside. The live criterion's ☰ name is the first proof.
- **A Theme Style for buttons on the receiving site** repaints Buttons with or without a Style (section F). Not
  solved here; named in the notes and HANDOFF.
- **A site with Bricks' cascade layer switched off** prints Bricks' element CSS unlayered: the reset then no longer
  cancels a Divider's inner line, a Form's own looks or the Nav's own layout. Already true of every native the
  importer writes (site-native-structure's risk); HANDOFF says what to look at.
- **Bricks' Nav adds `aria-label="Menu"`** to a menu the old site gave no label, and arrow-key movement between the
  links. Both are additions, named.
- **`::placeholder` looks** aren't captured: a Form's placeholder words take the browser's grey where the site set a
  colour. Named; a capture change of its own.
- **Goldens of merged jobs move by design** (Task 3, Task 11); each is regenerated by its own generator and named.
  Captures change shape for seven attribute names only; older captures convert as before.
- **`convert.ts` and `elementor-fold.ts` are over the 300-line rule** on the base; this job adds its logic in new
  files.
- **The live criterion covers wave 1 only** (bdryswi.com's home holds nothing of waves 2 and 3). The first page of
  his that holds a form or a menu list is those waves' live check; HANDOFF lists them as owed.

## Completion and reporting

The builder stops at `ready-for-review` with: the head, every criterion's receipt and screenshot, the ledger, the
before and after counts of settings and custom CSS characters on the natives fixtures and the B-Dry stand-in, the
mutation table, the K3 list, each golden regenerated with its reason, every stop condition met and what it left as
before, and `skill_lessons[{skill, lesson, evidence, enforce}]`. Not claimed by this plan: anything on B-Dry staging
or bdryswi.com (the last criterion is Justin's), and anything seen on Bricks 2.3.9 or 2.4.2 itself beyond what
`reference/bricks/` already holds.
