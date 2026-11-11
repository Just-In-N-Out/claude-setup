# plugin-parity: the Figma plugin builds its paste the way the website importer will (plan, 2026-11-11)

Planner: plugin-parity (Fable 5.2, high). Pipeline: **Full**. Figma plugin rules apply (repo CLAUDE.md: general logic,
desktop exact at the design width, corpus no worse, review rounds capped at 3).
**Base: `main` once site-no-div and site-shared-styles have merged** (their plans: `~/.hermes/plans/figma-to-bricks/site-no-div.md`,
`…/site-shared-styles.md`; main today is `02481763`, Build 2026-11-11.3). Every file:line below is from main `02481763`;
the builder re-reads each on its real base before editing.
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/plugin-parity/planner/` (`README.md` lists every file;
the working prototype is `<P>/proto-all.diff`, 294 lines against main `02481763`).
Plan copy for the repo: `docs/plans/2026-11-11-plugin-parity.md` (the builder copies this file there in Task 1's commit).

## Playback

1. Justin asked that a page converted from Figma be set up in Bricks the same way a scanned website will be: no "Div"
   boxes, every Section and Block with a name in the Structure panel, and looks that repeat kept in shared classes, so
   one change in a class changes every element that carries it.
2. Today the plugin writes 102 to 459 Divs a page, leaves 94 to 274 boxes a page without a name, and shares a text's
   font only where the designer made Figma text styles (GRO and the brainstorm file: no text class at all).
3. This job changes that for every Figma design, with the page drawn exactly as before at every width, and makes the
   plugin's sticky header stay when a site's Additional CSS holds `html, body { overflow-x: hidden }`.

## Questions (⭐ = the answer the standing auto-go takes)

1. **Divs.** ⭐ **A:** every frame and drawn shape is a **Block**. Only a picture carried inside the paste (the
   panel's "Pictures go: inside the copied JSON") stays a Div: Bricks drops a picture given as data from its Image
   element and its background control, so that picture is a box showing it as a CSS background (CLAUDE.md "Pictures
   inside the paste"); with "Pictures go: to WordPress" a paste holds no Div at all. B: keep a Div for a frame that
   holds only words and pictures (Justin's own hand-built ExampleBricks has 37 Divs and 28 Blocks).
2. **Labels.** ⭐ **A:** a name the designer typed is kept. A Section without one gets its first words (the
   importer's rule: at most 5 words, 40 characters, "…" when cut; "Section" with none). A Block without one gets what
   it is: "Row", "Column", "Grid", "Box", "Shape" (a drawn rectangle or ellipse), "Photo" (an empty box showing a
   picture), "Spacer" (an empty box that paints nothing), "Link" (the Block around a text that is one link).
   Containers and Bricks' own elements (Heading, Rich Text, Image, Button, Divider…) keep Bricks' names. B: label only
   Sections.
3. **Which looks are shared.** ⭐ **A:** the importer's four kinds and counts: **text** (font, size, weight, line
   height, letter spacing, case; 2 or more texts), **button** (its font, colours, border, corners, shadow, padding; 2
   or more Buttons), **box** (background, border, corners, shadow, padding; 3 or more boxes; only a box that paints
   something, or a Section or Container), **layout** (direction, wrap, alignment, gaps, grid columns; 3 or more flex
   or grid boxes). A look fewer elements have stays on the element, as today. B: no layout classes (ExampleBricks
   shares fonts, buttons and section padding but never a row's direction or gap; on the five real files that is about 72 of
   the 169 new classes, and the 580 elements that carry them keep their layout settings on themselves). C: also a
   class for Blocks that only pad (adds classes such as "padding-bottom 0.8px ×18": the planner's count on hydraulics).
4. **Class names.** ⭐ **A:** the purpose, then four letters made from the class's own values: `text-cqsk`,
   `heading-febt`, `button-bkqt`, `card-bfij`, `section-…`, `container-…`, `row-neji`, `column-…`, `grid-…`. No page
   name in front: the plugin's classes are site-wide today (`site-container`, the Figma text styles), and the same
   look on another page of the file gets the same class. The letters keep a name on one look for good, so Bricks never
   asks "Import classes" about it. B: the size in a text's name too (`text-16-cqsk`: easier to pick from Bricks'
   class list, stale once the size is changed in the class). C: the page's name in front, as the importer.
5. **Figma text styles.** ⭐ **A:** unchanged: a text with a Figma text style keeps that style's class and name, and
   never joins a made-up text class (hydraulics, Repairs and Services keep their style classes as they are).
6. **The sticky header.** ⭐ **A:** it stays in both places: pasted in the page (today's way) and pasted into a
   Bricks Header template, and it stays when Additional CSS holds `html, body { overflow-x: hidden }` (what
   site-sticky-header gives the importer). B: only the Additional CSS guard.
7. **Offcanvas and pop-ups from Figma.** ⭐ **A:** a separate later job, "plugin-overlays". The plugin has nothing
   that needs an Offcanvas today (its phone menu is Bricks' Nav (Nestable), whose panel is Bricks' own); a Figma
   "Open overlay" that isn't a photo hotspot is only named in the notes (`src/core/normalise/overlays.ts:4-6`).
   Building it means reading Figma's overlay position, background and close settings into Bricks' Offcanvas
   (`reference/bricks/offcanvas.json`, a researched sample) with its own rules and tests: not small. B: in this job.
8. **A website capture converted in the panel** (the older route through the Figma converter). ⭐ **A:** unchanged,
   byte for byte, as site-no-div and site-shared-styles leave it. B: the same changes there.

## What Justin will see (the planner's prototype on the five real files on this machine, "Pictures go: to WordPress")

| File | Divs | Sections and Blocks without a label | Classes | Texts with their font on themselves | Elements in a shared class (text / button / box / layout) |
|---|---|---|---|---|---|
| GRO home | 115 → **0** | 129 → 0 of 183 | 8 → 52 | 211 → 16 of 221 | 195 / 0 / 26 / 96 |
| Brainstorm | 102 → **0** | 164 → 0 of 231 | 11 → 74 | 215 → 17 of 215 | 198 / 9 of 9 / 18 / 143 |
| Hydraulics home | 215 → **0** | 179 → 0 of 379 | 47 → 64 | 44 → 44 of 199 (Figma styles) | 0 / 0 / 65 / 80 |
| Repairs | 102 → **0** | 94 → 0 of 180 | 34 → 45 | 0 of 98 (Figma styles) | 0 / 4 of 17 / 10 / 44 |
| Services | 459 → **0** | 274 → 0 of 720 | 58 → 92 | 2 of 521 (Figma styles) | 0 / 30 of 46 / 342 / 217 |

(`<P>/paste-facts-base.txt`, `<P>/paste-facts-proto.txt`; the prototype leaves the "Link" Blocks unlabelled, 3 to 10
a page, which the build labels.) The paste gets smaller: GRO 264 → 232 KB, Services 858 → 665 KB; 212 to 3,167 fewer
settings on elements a page. The Structure panel of the brainstorm file's second section, before and after
(`<P>/tree-brainstorm-base.txt`, `<P>/tree-brainstorm-proto.txt`):

```
before                                   after
Container  .site-container               Container  .site-container
  Block                                    Row [Block]  .row-neji
    Heading  .text-balance                   Heading  .text-balance
    Nav · links [Div]                        Nav · links [Block]
      Rich Text                                Rich Text  .text-cqsk
      Rich Text                                Rich Text  .text-cqsk
    Button · Let's GRO [Div]                 Button · Let's GRO [Block]  .card-bfij .row-sivj
      Rich Text                                Rich Text  .text-vfcu
```

**Nothing moves (measured).** The same snapshot converted by a clean export of main and by the prototype, both
pastes drawn in one Chrome with Bricks' own front-end CSS in Bricks' print order, animations off; every element
compared by its Bricks id (ids don't change) on its box (0.5 px) and on its computed font, colour, background,
padding, border and shadow (`<P>/geometry-diff.ts`):

| Run | Files × widths | Result |
|---|---|---|
| Bricks 2.3.9 CSS, 1728 … 320 (18 widths: every tier, laptops 1100–1300, 375/360/320) | 5 real files × 18 | 90 of 90 the same (`geo-all-bricks239.log`) |
| Bricks 2.4.2 CSS, 1728 … 320 (8 widths) | 5 real files × 8 | 40 of 40 the same (`geo-all-bricks242.log`) |
| Pictures inside the paste, header and footer ticks on (5 widths) | 3 real files × 5 | 15 of 15 the same (`geo-all-inline-site.log`) |
| Every generic fixture (116 Figma, 17 captures; a drawn phone design, strips, sliders, flip cards, hotspots, lists, forms among them) at 1440, 1100, 992, 768, 600, 390, 320 | 133 × 7 | 931 of 931 the same (`geo-fixtures-bricks239.log`) |

(An earlier prototype, the same but for how a Div is found, was also the
same with Bricks 2.4.2's CSS at 55 cells, the test renderer's stand-in CSS at 40 and inline pictures with ticks at 18:
`<P>/earlier-*.log`.) Byte for byte: all 34 conversions of the 17 capture fixtures equal main's; of the Figma
fixtures only the four mark fixtures are unchanged (`<P>/fixtures-bytes.txt`). The conversion takes 658 ms
against 581 on Services (the suite's limit is 3,000).

## What is true today (main `02481763`)

1. **Divs.** `src/core/understand/node.ts:25`: `shape: "div", frame: "div"`; `:126` turns a frame into a Block only
   when one of its children is a box at the moment it is made. Two more makers: `understand/review-slider.ts:82`
   ("Review content") and `understand/hotspots.ts:61` ("Photo crop"). By cause on the five files (`<P>/base-facts.txt`):
   auto-layout frames holding only leaves 949, drawn shapes 35, frames without a layout 9 (993 Divs in all).
2. **What Bricks gives a Block that it doesn't give a Div** (`reference/bricks/README.md:176-192`):
   `.brxe-block{align-items:flex-start;display:flex;flex-direction:column;width:100%}` and, from 767 px down,
   `flex-wrap:wrap`; a Div has no default width or display. The style stage already knows: `style/layout.ts:33`
   writes `display: flex` and the direction only for a Div; `style/sizing.ts:263` writes `width: auto` for a hugging
   Block; `adapt/rules/rows.ts:205` writes `nowrap` at 767 for a row it keeps on one line.
3. **Labels.** `understand/labels.ts:7` (`labelOf`) keeps a typed layer name and drops Figma's defaults ("Frame
   12"); `node.ts:86`. Nothing names a box the designer didn't.
4. **Classes.** `style/text-classes.ts:29-52`: a class only for a text with a Figma text style (`t.styleId`); any
   other text carries its whole font on itself. Button, box and layout looks are never shared; the other classes are
   the plugin's own (`site-container`, `tap-area`, `cta-motion`, `text-balance`…: `style/classes.ts`).
5. **Sticky header.** `style/style.ts:99`: `position: sticky; top: var(--wp-admin--admin-bar--height, 0px); z-index:
   100` in the header section's own custom CSS, with no guard. **Proven on plugin pastes** (`<P>/sticky-probe.ts`,
   `<P>/sticky-probe.txt`; the hydraulics file and the fixture `centeredNavigation`, at 1440 and 390, scrolled 1200 px):

   | Case | Header's top after the scroll |
   |---|---|
   | A. the paste as it is | 0: stays |
   | B. with `html, body { overflow-x: hidden }` (Additional CSS) | −1200: scrolls away |
   | C. B plus `html:root, html:root > body { overflow-x: clip }` printed before it | 0: stays, no sideways scroll |
   | D. the guard alone | 0: stays |
   | E. the header section inside `<header id="brx-header">` (a Header template), guard and Additional CSS | −1200: scrolls away |
   | F. E plus `#brx-header:has(#brxe-<its id>) { position: sticky; top: …; z-index: 100 }` | 0: stays |

   So the audit's gap 10 is real, and a header pasted into a Header template never stuck at all.
6. **Offcanvas.** `reference/bricks/offcanvas.json` exists (README "offcanvas.json", built from Bricks' code); no
   Figma stage reads it (Q7).

## The rules (general, for every Figma design)

Read from structure and what elements draw only: never a layer name, id, text, colour or size from a file. A website
capture (`snapshot.source === "web"`) is left exactly as it is by every rule below (Q8).

### Blocks (Q1)

- **B1.** At the end of `understand`, every element that is a Div becomes a Block marked `leaf` ("it keeps a Div's
  layout"), before the pass that turns an inlined picture into a Div (`understand.ts:115`, which stays the only Div
  maker a paste shows). One place covers every Div maker (frames, shapes, "Review content", "Photo crop", a hover
  copy that gained a box later), and no understand pass reads `div` or `block` between making and this pass (the
  planner's grep: only `style/layout.ts`, `style/sizing.ts`, `emit` and `adapt/site` read the name).
- **B2.** A `leaf` Block's base style undoes Bricks' three Block defaults where the Div had none, in `style.ts` after
  the element's style is built:
  - no width of its own → `width: auto` (Bricks: `width:100%`);
  - no auto layout (free layers, an empty shape, "Photo crop") → `display: block` (Bricks: a flex column);
  - a flex layout that doesn't wrap → `wrap: false`, printed as Bricks' Flex wrap "nowrap" (Bricks wraps every Block
    from 767 px down; a rule that wraps or stacks a row at a tier still writes its own value there, which wins at that
    tier as it does today). The planner's first prototype without it moved a hover copy's one word by 2.5 px at 767
    and below on three files: a wrapping box places a taller-than-box item at its top, not centred.
- **B3.** A Block that was a Block (a frame holding a box when made) gains nothing: it keeps Bricks' defaults as
  today. Giving every Block `width: auto` or "nowrap" would change what today's Blocks do once a row stacks or
  wraps; that is no part of this job.
- **B4.** `style/layout.ts:33` needs no change: a Block writes no `display` and no `column`, which drops two settings
  from every former Div (`_display: flex`, `_direction: column`).

### Labels (Q2)

- **L1.** Last pass of `understand` (after the copies, hover layers and the room spacer, so no pass reads a made-up
  label: the phone slider's "`<row label> ?? Cards` - Phone" at `understand/phone.ts:82` stays as it is): every
  Section and Block with `label === null` gets one; nothing else changes.
- **L2.** A Section: `sectionLabel(first words)`, the first text or Button words in the order `walkIR` reads it; the
  same function the importer uses (`src/core/site/labels.ts` `sectionLabel`, site-native-structure), imported, not
  copied.
- **L3.** A Block: "Shape" for a drawn shape; with no children "Photo" (an image fill), "Shape" (another paint or a
  stroke) or "Spacer"; else by its own layout "Row", "Column", "Grid", or "Box" without one.
- **L4.** A text that is one link, which emit prints as a Block around its Rich Text (`emit/rich-text.ts:19`
  `wrappedText`: `element === "text"` with an `elementLink`), gets the label "Link" in the same pass; emit already
  writes an IR label on the element carrying the text's id, which is that Block, and the Rich Text inside has none.
  After understand only emit reads a label (`emit/elements.ts:190`; `:43` reads a marquee round's own, never null).

### Shared looks (Q3, Q4, Q5)

Decided in `emit`, after `adapt`, from the typed styles: a look includes what the rules wrote for it at every tier,
which only exists after `adapt`, and emit is where typed styles become settings (`emit/classes.ts` `twinsAlike` is
the same kind of decision). No Style, tier layer or IR node is changed, so every rule and reader sees what it sees
today. (The planner first built text looks in the style stage, as Figma text styles are: the class's steps then
reached a scrolling strip's words, which the engine keeps as drawn, and a 320 px word shrank to 271 at 1200 on the
brainstorm file: 54 elements moved at 992–1300; `<P>/rejected-text-looks-in-style-stage.*`.)

- **S1. Four kinds, each a fixed list of property paths** (a group such as padding is taken side by side):

  | Kind | Elements | Paths | From | Named |
  |---|---|---|---|---|
  | text | Heading, Rich Text (also one emit wraps in a "Link" Block) | `font.family`, `.size`, `.weight`, `.italic`, `.lineHeight`, `.letterSpacing`, `.transform`, `.axes`; only a whole font (family and size) | 2 | `heading` from 22 px (the plugin's own line, `style/style.ts:210`), else `text` |
  | button | Bricks Button | every `font.*` it carries itself, `background`, `border`, `shadow`, `shadows`, `padding`, `justify` | 2 | `button` |
  | box | Section, Container, Block | `background`, `border`, `shadow`, `shadows`, `padding`; a Block's only when it paints (a background, a border, a shadow or corners); a Section's or Container's also when it only pads | 3 | `section` or `container` when only those carry it, `card` when it paints, else `box` |
  | layout | Section, Container, Block that is a flex or grid box | `display` (flex, grid), `direction`, `wrap`, `justify`, `align`, `rowGap`, `columnGap`, `gridColumns`; never a look of `display: block` alone | 3 | `grid`, `row` or `column` |

  The colour of a text is not in its class (a white heading and a blue heading share one), as site-shared-styles Q1 A.
- **S2. The same look = equal as written, at the design width and at every tier** (the fluid range, tablets,
  sideways phones, upright phones): the element's base values for the kind's paths, and what the rules wrote for
  those paths at each tier. No tolerance. So a class carries a path completely, and an element carrying the class
  writes nothing for it at any width: one writer per property. An element whose tiers differ (a word that needs a
  smaller size on phones) keeps its own values or shares with the elements that differ the same way.
- **S3. Counted by Figma layers**, per design (desktop, and a drawn phone design apart): a phone-only copy of a layer
  counts once with it. A look enough layers draw (S1's count) is one class on every element that draws it; else its
  values stay on the element exactly as today.
- **S4. A path another class of the element sets is never taken** (a Figma text style's font, the Container
  class's side padding and width), at the design width or a tier. Where a tier writes a path the base style doesn't
  hold, that whole group stays on the element.
- **S5. What stays on the element:** where it sits and how big it is (margins, position, offsets, z-index, width,
  height and their limits, flex item values, order), text colour, alignment and decoration (a Button's are in its
  look), overflow, opacity, transitions, every custom CSS line, a Button's drawn icons, and every hover or state look
  (`emit/states.ts`), which outweighs a class as it does today.
- **S6. Names and ids** (Q4 A): `<purpose>-<4 letters>`, the letters `shortId(<design>|<kind>|<base>|<tiers>).slice(0, 4)`
  (the importer's own fingerprint: `site/classes.ts` `versioned`); a name another class of the page holds moves on
  with a salt. The class key is `look:<design>|<kind>|<base>|<tiers>`; its id through `assignIds` after the existing
  class ids. So a name, an id and the settings go together on every page of the file (but for a clash inside one
  page, which the salt moves on: rare, and named in the notes of the test that pins names).
- **S7. Order on the element:** `_cssGlobalClasses: [<today's classes>, <text | button | box look>, <layout look>]`.
  The kinds' paths never overlap and S4 keeps them off today's classes, so the order Bricks prints classes in can't
  matter.
- **S8.** `ConvertResult.shared` lists the look classes (`{ id, name, kind, uses }`); `npm run replay` prints their
  count and writes `styles.txt` (each class, its kind, its uses and its settings), as the importer writes one.

### The sticky header (Q6)

- **H1.** A section with `ir.sticky` writes, beside its three declarations, two rules through a new typed field
  (`Style.around`: declarations under a selector that isn't the element's own, `&` standing for the element):
  `html:root, html:root > body { overflow-x: clip; }` and
  `#brx-header:has(&) { position: sticky; top: var(--wp-admin--admin-bar--height, 0px); z-index: 100; }`.
  `html:root` outweighs a plain `html, body` rule wherever it is printed; `clip` makes no scroll container and still
  stops sideways scrolling; Bricks rewrites the element's own id inside its own settings on paste, so `&` stays its
  own (`reference/bricks/README.md` "Ids on paste").
- **H2.** A paste without a sticky header holds neither rule.

## Which pastes move, and how

Every Figma design's paste changes on purpose; ids, warnings, pictures, fonts, the palette file and how the page is
drawn do not.

| Change | Where in the paste |
|---|---|
| `name: "div"` → `"block"` | every frame, shape and synthetic box that was a Div (inlined pictures stay `div`) |
| `_display: "flex"` and `_direction: "column"` go; `_width: "auto"`, `_display: "block"`, `_flexWrap: "nowrap"` come where B2 says | those Blocks |
| a `label` | every Section and Block that had none |
| values leave `settings` (at the design width and at their tiers) and `_cssGlobalClasses` grows | every element in a shared look |
| new entries in `globalClasses` | the look classes, after today's |
| two more rules in `_cssCustom` | a sticky header's section |

A website capture converted in the panel: byte for byte as before. With `ConvertOptions.asBefore` (a test and
diagnosis switch, below) set for all four, every paste is byte for byte main's.

## What this plan assumes from site-no-div and site-shared-styles, shared files, order

- **From site-native-structure / site-no-div** (seen on `site-native-structure-stack6` `2a38027f`):
  `src/core/site/labels.ts` exports `sectionLabel(words, part?)` (5 words, 40 characters, "…", "Section") and the
  roles "Row", "Column", "Grid", "Box", "Photo"; site-no-div adds "Spacer" and "Shape" for empty boxes and "Link".
  This plan imports `sectionLabel` and uses the same words. If it lands under another name, the builder maps it and
  says so in the ledger; if it isn't on main, stop (the base is wrong).
- **From site-shared-styles:** its grouping rule R1–R6 (four kinds; 2/2/3/3; equal as written at every range; one
  writer per property; where an element sits is never shared; names by a fingerprint of the class's own rules).
  This plan applies the same rule to the plugin's typed styles and tiers. It shares no code with it but `shortId`.
- **site-no-div's twelfth criterion** ("every Figma replay is byte-identical to the base's", named-only, a
  story-time pin) is that story's receipt: after this job it no longer holds by design (the global rule on story
  pins: record once, move on).

| Job | Shared files | How they meet |
|---|---|---|
| site-no-div, site-shared-styles (bases) | `src/core/site/labels.ts` (read only), `test/browser/render.ts` (their site-route printing; this job doesn't edit it), `docs/HANDOFF.md`, `reference/bricks/README.md` | merge first |
| site-sticky-header (Mini) | none in code; the same guard text | its class is the importer's; this job writes the same two rules in the plugin's own typed CSS |
| importer-parity (sibling plan) | `src/core/emit/elements.ts` (it reuses `ctaAttributes`, `navSettings`, `formSettings`, `videoSettings`), `src/core/emit/states.ts` | this job adds lines around `layeredSettings` and the class list in `emitPayload`; whoever merges second keeps both and reruns both jobs' tests |
| shared-palette (sibling plan) | `src/core/emit/palette.ts`, `normalise/colors.ts` | a look class's colours are written through `colorOut`, so a new palette naming flows into the classes with no change here; a look's fingerprint is of its typed values (RGBA), not of palette names, so its name doesn't move |
| bricks-icons (sibling plan) | `src/core/understand/node.ts`, `understand/ir.ts` (`ElementName`), `src/core/emit/elements.ts` | build one after the other: an icon made an Icon element stops being a Block; its tests of "no Div" and labels then cover the Icon |
| media-clickable, site-menu-motion, site-scroll-lock, media-avif-alt | `docs/HANDOFF.md` only | sections both stay |

Order: … → site-no-div → site-shared-styles → **plugin-parity** (importer-parity, shared-palette and bricks-icons
before or after; the builder rebases onto main before `ready-for-review`). The builder starts only when `git log
main` holds site-shared-styles' build commit.

## Acceptance criteria (all **proposed**)

"The switch" is `ConvertOptions.asBefore` (`{ divs?: true; labels?: true; looks?: true; sticky?: true }`, each part
converting as before; the panel, the plugin and `replay` never set it). "The drawn set" is the generic fixtures
`samplePage`, `freePage`, `pairPage` (a drawn phone design), `stripPage`, `carouselPage`, `flipPage`, `listPage`,
`hotspotPage`, `reviewSliders`, `menuBarPage`, `faqPage`, `logoWindow`, `formPage`, `hoverCardPage`,
`centeredNavigation`, `equalCards` and the two corpus files in the repo (hydraulics, GRO). "Every tier" is 1440 (and
the design width where it differs), 1200, 1024, 800, 767 (where Bricks starts wrapping a Block), 600, 390, 375, 360
and 320. Fixtures are generic, never copies of a file.

- AC1 (proposed): Given any Figma design, no element of its paste is a Div except a picture carried inside the paste; with pictures sent to WordPress the paste holds none: every generic fixture and corpus file, both picture modes, the header and footer ticks on and off. Test `test/unit/plugin-no-div.test.ts` "a Figma paste holds no Div but an inlined picture's: every fixture and corpus file, both picture modes, ticks on and off".
- AC2 (proposed): Given the switch's `divs`, the paste with Blocks equals the paste with Divs element for element but for exactly this: each former Div is named `block`, loses `_display: "flex"` and `_direction: "column"`, and gains `_width: "auto"` where it had no `_width`, `_display: "block"` where it had no auto layout and `_flexWrap: "nowrap"` where it is a flex box with no `_flexWrap` of its own; a frame that was a Block before gains nothing; ids, order, classes and every other setting are equal. Test `test/unit/plugin-leaf-blocks.test.ts` "a Block that was a Div differs from the Div only by its name and the three Div defaults it keeps; a Block that was a Block is unchanged".
- AC3 (proposed): Given the drawn set converted with Divs and with Blocks, every element sits within 0.5 px of where it sat at every tier, drawn with Bricks 2.3.9's front-end CSS and with 2.4.2's in Bricks' print order, and the page is no wider than the window where it wasn't before. Test `test/browser/plugin-blocks.test.ts` "with Blocks for Divs every element of the drawn set sits where it sat at every tier, drawn with Bricks 2.3.9 and 2.4.2".
- AC4 (proposed): Given any Figma design, every Section and Block of its paste has a label: the designer's typed name unchanged; else a Section its first words (at most 5 words and 40 characters, "…" when cut, "Section" with none) and a Block "Row", "Column", "Grid", "Box", "Shape", "Photo" or "Spacer" by what it is, the Block around a text that is one link "Link"; a Container, a Heading, a Rich Text, an Image, a Button and a Divider have a label only where the designer typed one. Test `test/unit/plugin-labels.test.ts` "every Section and Block has a label: the designer's name, else its first words or what it is; Containers and Bricks' own elements keep theirs".
- AC5 (proposed): Given the switch's `labels`, the paste with made-up labels equals the paste without them but for the `label` of elements that had none (a phone slider's "Cards - Phone" and every typed name included: no pass reads a made-up label). Test `test/unit/plugin-labels.test.ts` "made-up labels change nothing but the label of elements that had none".
- AC6 (proposed): Given a page with texts, Buttons, painted boxes and rows that repeat, elements that draw the same share one class per kind by rules S1–S5: 2 texts or 2 Buttons, 3 boxes or 3 layouts, counted by Figma layers (a phone-only copy counts once); a look fewer layers draw stays on its element; a text with a Figma text style keeps that class and joins no text look; a Block that only pads, a box that is no flex or grid box, a text's colour and a path another class of the element sets are never taken; a look whose tier values differ between two elements is two looks. Test `test/unit/plugin-looks.test.ts` "elements that draw the same share one class per kind: counts by layers, Figma text styles kept, what a look never takes".
- AC7 (proposed): Given any Figma design, each element's settings read through its look classes (a class's value under the element's own, a group such as padding side by side, at every tier) equal its settings with the switch's `looks`, key for key, its custom CSS equal, and no path at any tier is written both by a look class and by the element or by two classes of one element. Test `test/unit/plugin-looks-resolve.test.ts` "read through its look classes every element's settings equal the paste without looks, with one writer per property: every fixture and corpus file, both picture modes".
- AC8 (proposed): Given the drawn set converted with and without looks, every element has the same box (0.5 px) and the same computed font, colours, background, padding, border, corners, shadow, display, direction, wrap, alignment and gaps at every tier, drawn with Bricks 2.3.9's front-end CSS and with 2.4.2's in Bricks' print order (a class's controls printed `.<class>.brxe-<element>`). Test `test/browser/plugin-looks.test.ts` "with shared looks every element of the drawn set draws as without them at every tier, with Bricks 2.3.9 and 2.4.2".
- AC9 (proposed): Given two pages that share looks, a look has the same class name, id and settings on both; adding an element with a new look to a page renames no other class; every look class is named `<purpose>-<4 letters>` with the purposes of S1; a class is never written with `{}` settings. Test `test/unit/plugin-looks-names.test.ts` "a look has one name, id and settings on every page, and a new look renames nothing".
- AC10 (proposed): Given Bricks' own class comparison on paste (`test/fixtures/bricks-paste.ts`), pasting a page twice, or two pages that share looks, asks about no class; a page pasted after one of its labels grew to its minimum size holds no class of the first paste's name with other settings. Test `test/unit/emit-class-paste.test.ts` "shared looks add no class conflict on a re-paste, between two pages, or after a label's minimum size".
- AC11 (proposed): Given a design whose header bar the plugin makes sticky, the header's top stays at the window's top after a 1200 px scroll at 1440 and at 390: as pasted in the page; with `html, body { overflow-x: hidden }` printed after the paste's CSS; and with its section inside `<header id="brx-header">` with that same CSS; the page never scrolls sideways. Test `test/browser/plugin-sticky-guard.test.ts` "a sticky header stays under html, body overflow-x hidden, in the page and in a Header template, at 1440 and 390".
- AC12 (proposed): Given any Figma design, only a section the plugin makes sticky carries the two rules (`html:root, html:root > body { overflow-x: clip; }` and `#brx-header:has(<its own id>) { position: sticky; … }`), once each, after its own three declarations; a paste without a sticky header holds neither. Test `test/unit/plugin-sticky-guard.test.ts` "only a sticky header's section carries the overflow guard and the Header-template rule".
- AC13 (proposed): Given a website capture converted in the panel's way (`convert` on a snapshot with `source: "web"`), the switch changes nothing: the paste holds its Divs, no made-up label and no look class, with and without it. Test `test/unit/plugin-parity-captures.test.ts` "a website capture converts the same with and without the switch: its Divs, no made-up label, no look class".
- AC14 (proposed): Given the switch set for all four parts, every Figma paste (every generic fixture, the corpus files, both picture modes, ticks on and off) equals the base's byte for byte, by sums recorded on the base in Task 1. Test `test/unit/plugin-parity-pin.test.ts` "with the switch on for all four parts every Figma paste equals the base's" (named-only: `F2B_STORY_PINS=1`, a story-time pin).
- AC15 (proposed): Given the plugin's own conversion and Figma's sandbox, the plugin's paste is exactly a replay's and the new code uses only the language's built-ins. Test `test/unit/plugin-convert.test.ts` "the plugin's paste is exactly what a replay of the same snapshot gives".
- AC16 (proposed): Given the two corpus files in the repo, the layout lint (`test/browser/lint.ts`) reports the same errors and warnings with the switch on for all four parts and off, at 390, 768, 1024, 1440 and the design width. Test `test/browser/plugin-parity-lint.test.ts` "the layout lint of each corpus file is the same with and without this job's changes at every corpus width".
- AC17 (proposed): Given `npm run replay`, its summary line names the count of shared looks and `styles.txt` lists each look class with its kind, its uses and its settings; `ConvertResult.shared` holds the same list. Test `test/unit/replay-styles.test.ts` "replay lists the shared looks: the summary's count and styles.txt".
- AC18 (proposed) (live): Justin converts a Figma page in the panel with "Pictures go: to WordPress", pastes it into an empty page on darksalmon (Bricks 2.3.9) and answers "Import classes": the Structure panel shows no "Div" and a name on every Section and Block; he clicks a text, opens its `text-…` class, changes the font size, and every text with that class follows; at 1440 and at 390 the page looks as the same page pasted from the build before; with `html, body { overflow-x: hidden }` in Additional CSS the header stays at the top while he scrolls. Test: Justin's paste check `<plugin-parity id at merge>` (HANDOFF "End-of-run check list").

RED on the base: the first twelve and the seventeenth (hydraulics alone holds 215 Divs and 179 unlabelled boxes; GRO
has no text class; no look class, `shared`, `styles.txt`, guard or `asBefore` exists). Each test that compares the
paste with and without a part first asserts that the part is there (a Block that was a Div, a made-up label, a look
class), so it can't pass on a tree where the switch does nothing. Green on the base by design, as regression pins:
the capture criterion (13), the story pin (14, its sums recorded on the base), plugin = replay (15) and the lint
criterion (16).

## Architecture

Pure, built-ins only (`npm run typecheck` runs `tsconfig.sandbox.json`). No rule in `src/core/adapt/rules/` changes
or is added; no rule or style reader sees a different Style.

- `src/core/normalise/scene.ts`, `normalise.ts`: `Scene.capture: boolean` (`snapshot.source === "web"`). `scene.web`
  is not that test: six capture fixtures (`site-code.code`, `site-drops.*`, `site-inline-own.inlineAtSome`,
  `site-motion-code.motionCode`) hold a `web` with no ranges and get no `scene.web`; keyed on `scene.web` or on a
  layer's `measured`, their pastes changed in the planner's first run (`<P>/README.md`).
- `src/core/convert.ts`: `ConvertOptions.asBefore?: { divs?: true; labels?: true; looks?: true; sticky?: true }`;
  `understand(scene, { inlinePictures, blocks: !asBefore.divs, labels: !asBefore.labels })`;
  `styleAll(page, scene, { stay: !asBefore.sticky })`; `emitPayload(page, styled, version, adapted, { looks:
  !asBefore.looks })`; `ConvertResult.shared: SharedLook[]`. Each option defaults to on where a caller leaves it
  out, and each stage turns its part off itself for a capture (`scene.capture`, `PageIR.capture`).
- `src/core/understand/ir.ts`: `IRNode.leaf?: true` ("a Block that keeps a Div's layout: Bricks' Block defaults are
  undone where it has none of its own (style.ts)").
- `src/core/understand/understand.ts`: `opts.blocks`, `opts.labels` (each on unless `false`, off for
  `scene.capture`); `PageIR.capture`. Before the inline-picture pass (`:115`):
  `if (blocks) walkIR(sections, (n) => { if (n.element === "div") { n.element = "block"; n.leaf = true; } });`
  and last, after `planFloating`: `if (labels) nameBoxes(page.sections);`. The comment says why it sits beside
  the inline-picture pass (the one other place an element's name is settled by an option, and no pass between reads it).
- `src/core/understand/labels.ts`: `nameBoxes(sections)`, `boxLabel(n)`, first words (prototype: `<P>/proto-all.diff`,
  its copy of `sectionLabel` replaced by the import from `../site/labels.ts`; "Link" for L4 added).
- `src/core/style/style.ts`: after the role switch in `visit`, for `ir.element === "block" && ir.leaf`: the three
  B2 values merged onto `out.style` (prototype hunk). `styleAll(page, scene, opts?: { stay?: boolean })`; at `:99` the
  sticky section also gets `around: { "html:root, html:root > body": ["overflow-x: clip"], "#brx-header:has(&)":
  ["position: sticky", "top: var(--wp-admin--admin-bar--height, 0px)", "z-index: 100"] }` when `stay !== false`.
- `src/core/style/types.ts`: `Style.around?: Record<string, string[]>` ("declarations under a selector that isn't
  the element's own; `&` is the element's selector; custom CSS"); `merge` adds its lists up as it does `parts`.
- `src/core/emit/settings.ts` `layeredSettings`: after the element's own rules and before its tier blocks, one rule
  per `around` entry: `rule(key.replace("&", selector), decls)`. Classes never carry `around`.
- `src/core/emit/looks.ts` (new, ≤ 200 lines; prototype in `<P>/proto-all.diff`): `sharedLooks(page, result, layers):
  Shared` (`classes: ClassDef[]`, `of: Map<IR key, { keys: string[]; paths: Set<string> }>`, `list: SharedLook[]`),
  `without(style, paths)`, `layersWithout(layers, paths)`. What the prototype lacks and the build adds: the layout
  look's "flex or grid only" test (the prototype made one junk class, `column-chsb` = `display: block`); ids through
  `assignIds`; `list`; the `design` of a phone design's looks (present) tested on `pairPage`.
- `src/core/emit/elements.ts` `emitPayload(…, opts?: { looks?: boolean })`: builds `shared` once; an element's
  settings come from `without(st.style, paths)` and `layersWithout(layers, paths)`; `_cssGlobalClasses` = today's
  then its looks; `globalClasses` = today's then the look classes in use (their settings through the existing
  `classSettings`, so a class's fluid values fold into its desktop value as an element's do). Off for
  `page.capture`.
- `src/core/emit/payload.ts` `payloadProblems`: a class holding a layout-only key (`LAYOUT_ONLY_KEYS`) that an
  element which isn't a layout element lists is a problem (a guard: `looks.ts` never makes one).
- `tools/replay.ts`, `tools/lib/styles-text.ts` (new): the summary's count and `styles.txt`.
- `test/fixtures/drawn.ts` (new): `drawnSettings(payload, el, lookIds)`: an element's settings with its look
  classes' under them (a group such as `_padding` or `_typography` key by key, tier keys too), without
  `_cssGlobalClasses`; `drawn(result)`: the whole payload so, look classes left out. `lookIds` come from
  `ConvertResult.shared`.
- Not touched: `test/browser/render.ts` (its stand-in CSS still lacks `.brxe-block{align-items:flex-start}`,
  CLAUDE.md; the browser criteria above draw with Bricks' own CSS through `bricksCss`), `src/core/adapt/**`,
  `src/core/site/**`, `src/ui/**`, `src/plugin/**`, `reference/bricks/*.json`.

## Tests that pin today's output (the builder may edit these, and only as said)

The prototype fails 62 of the 3,698 unit tests of the base (base: 3,645 pass, 0 fail, 53 skipped, with the two repo
corpus files re-pointed; `<P>/unit-base.tap.log`), in 30 files, and no other
(`<P>/unit-fail-proto-all-by-file.txt`; with Blocks alone 24: `<P>/unit-fail-blocks-only-by-file.txt`). None is a
capture, importer or panel test. Each fails because it reads a value where it used to be printed:

| When it fails | Files (tests) |
|---|---|
| with Blocks alone (24) | `understand.test.ts` (2), `style.test.ts` (2), `pdf-direct-download.test.ts` (2), `emit-accordion.test.ts` (2), `convert.test.ts` (2), `adapt-fixed-tiles-review.test.ts` (2), `understand-tracks.test.ts` (1), `record-media.test.ts` (1), `icon-buttons.test.ts` (1), `give-way.test.ts` (1), `emit-rich-text-invariant.test.ts` (2: its fixture test and its corpus test), `emit-lists.test.ts` (1), `cta-names.test.ts` (1), `corpus-faq-answer-space.test.ts` (1), `convert-contacts.test.ts` (1), `adapt-rows.test.ts` (1), `adapt-fixed-tiles.test.ts` (1) |
| once labels and looks are on too (38 more) | `adapt-rows.test.ts` (9), `min-font.test.ts` (6), `adapt-peer-sides.test.ts` (6), `give-way.test.ts` (2), `adapt-space.test.ts` (2), `adapt-list.test.ts` (2), `recognition-footer-navigation.test.ts` (1), `label-floor-flip.test.ts` (1), `icon-buttons.test.ts` (1), `hotspot-guards.test.ts` (1), `emit-flip.test.ts` (1), `emit-designs.test.ts` (1), `emit-class-paste.test.ts` (1), `convert.test.ts` (1), `convert-equal-cards.test.ts` (1), `adapt-type.test.ts` (1), `adapt-marquee.test.ts` (1) |

The edits allowed, by what the failing assertion reads (one kind per assertion; every expected value stays as written
unless the kind says otherwise):

| The assertion | The one edit allowed |
|---|---|
| names an element `div`, or a title says "Div" | expect `block`; the title says "Block" |
| reads `_display: "flex"`, `_direction: "column"` or "no width" on a former Div | assert the Block's values: no `_display`, no `_direction`, and B2's `_width: "auto"`, `_display: "block"` or `_flexWrap: "nowrap"` where B2 gives one |
| reads a value on the element that a look class now carries (e.g. `hotspot-guards`: "Cannot read properties of undefined (reading 'radius')") | read the same key through `drawnSettings` (or convert once and take `drawn(result)`) |
| compares with a golden (`test/golden/files/convert-sample.json`, `cta-names-base.json`) | the golden is regenerated in the task that changes it, after the story pin (the fourteenth criterion) passes on that commit |
| tells a wrapped text's Block by "a linked Block around words" (`emit-rich-text-invariant.test.ts`) | tell it by its "Link" label and its single Rich Text child whose id is `wordsKey`'s; a linked frame of several texts is a frame |
| asserts the classes of two pastes are byte-identical where a Button's label grew (`emit-class-paste.test.ts`: the look holding the label's size is another look, `button-gaky` for `button-tcok`) | the tenth criterion's wording: no class of one name with two settings, and the Figma text-style classes byte-identical |

The builder runs `npm run test:browser`, `npm run test:web` and `npm run test:performance` on the base in Task 1 and
keeps the tallies by test name; a browser test that fails by one of the reasons above takes the same edit, and any
other new failure stops the task (name the assertion; never weaken it).

## Tasks (test-first; commit after each passing task, files by name; never commit CLAUDE.md)

Every task: write the test, see it fail for the reason given, make it pass, run `npm run check`, commit. Keep the
ledger in `.superpowers/sdd/2026-11-11-plugin-parity/progress.md`, committed with each task. Machine: WSL; Node
`/home/justin/.local/node-v22.23.3/bin` first on PATH; `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
`TMPDIR` about 24 characters; point `corpus/corpus.json` at `corpus/files/` only in a scratch copy, never in the
worktree; a command that dies with SIGTERM, 143, 137 or "Killed" may be earlyoom: check its log before reading it as
a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

### Milestone 0: the base's facts

1. **Records.** Copy this plan to `docs/plans/2026-11-11-plugin-parity.md`. Run `npm run corpus` (on this machine:
   `snap`/`replay` of the two repo corpus files, memory `corpus-paths-on-desktop`) and keep the numbers; run the unit,
   browser, web and performance suites and keep each tally by test name in `<evidence>/builder/base/`. Add
   `ConvertOptions.asBefore` (read nowhere yet) and `test/unit/plugin-parity-pin.test.ts` with its sums file
   `test/fixtures/plugin-parity-base.sha256.json` (every zero-argument fixture export returning a Figma snapshot, as
   `<P>/fixtures-to-json.ts` finds them, plus the two corpus files; both picture modes; ticks on and off), recorded on
   this commit; it passes with `F2B_STORY_PINS=1` and is skipped without. Add `test/unit/plugin-parity-captures.test.ts`
   (green from the start; it stays green through every task). Commit.

### Milestone 1: the sticky header (the smallest; nothing else depends on it)

2. **Typed field.** `Style.around`, `merge`, `layeredSettings`. Test in `test/unit/emit-settings.test.ts` (a new
   case: an element with `around` prints each rule once, `&` as its own selector, before its tier blocks; a class
   with none prints none). RED: the key is unknown. GREEN.
3. **The guard.** `style.ts:99`, `styleAll`'s `stay`, `convert.ts` reading `asBefore.sticky`. Tests
   `test/unit/plugin-sticky-guard.test.ts` and `test/browser/plugin-sticky-guard.test.ts` (`<P>/sticky-probe.ts` is
   the working measurement: cases A to F). RED: case B and E read −1200. GREEN: 0. Existing
   `navigation-links.test.ts:67` and `centered-navigation.test.ts:64` still match (the three declarations stay first).

### Milestone 2: Blocks

4. **Blocks.** `Scene.capture`, `PageIR.capture`, `IRNode.leaf`, `understand.ts` (B1), `style.ts` (B2), `convert.ts`
   reading `asBefore.divs`. Tests
   `test/unit/plugin-no-div.test.ts`, `test/unit/plugin-leaf-blocks.test.ts`. RED: Divs everywhere. GREEN; then the
   pinned tests of the first table row and the two goldens, each edit as said, the story pin run before the goldens
   are regenerated.
5. **Drawn.** `test/browser/plugin-blocks.test.ts` (the measurement of `<P>/geometry-diff.ts`: both pastes in one
   Chrome, by id, animations off; read each page after `document.fonts.ready` and two animation frames: one first
   reading of a page was 189 px off in the planner's run and right on the second). Each of B2's three values is
   proven needed by leaving it out in a scratch copy and seeing this test fail (the ledger names the element and
   width for each; `git checkout` restores the file).

### Milestone 3: labels

6. **Labels.** `nameBoxes` (L1–L4), the `sectionLabel` import, `asBefore.labels`. Tests
   `test/unit/plugin-labels.test.ts` (both names). RED: a generic page's unnamed Sections and Blocks have no label.
   GREEN; `emit-rich-text-invariant.test.ts` edited as said.

### Milestone 4: shared looks

7. **The resolver first** (testable on hand-built payloads): `test/fixtures/drawn.ts` with its own unit test
   (`test/unit/drawn-fixture.test.ts`: a class's value under the element's own; `_padding` side by side; tier keys;
   only the ids given).
8. **`emit/looks.ts`**: the grouping (S1–S6) with `test/unit/plugin-looks.test.ts` on a new generic fixture
   `test/fixtures/shared-looks.ts` (`sharedLooksPage(o)`: three sections with a sibling text above each; texts in
   three fonts, one of them a Figma text style; two alike Buttons and one other; three alike painted cards and two
   others; four alike rows and two others; a phone-only slider of the cards; one text whose long word steps down
   further on phones; options to add an element with a new look and to draw a phone design). RED: no class. GREEN.
9. **Emit.** `emitPayload` and `convert.ts` (`asBefore.looks`, `ConvertResult.shared`), `payloadProblems`' guard.
   Tests `test/unit/plugin-looks-resolve.test.ts`, `test/unit/plugin-looks-names.test.ts`, the new case in
   `test/unit/emit-class-paste.test.ts`. Then the pinned tests of the second table row, each read through `drawn`.
10. **Drawn.** `test/browser/plugin-looks.test.ts` (computed styles as well as boxes; `renderPage` with
    `bricksOrder: true`, `before: ""` and `bricksCss` from `reference/bricks/frontend-2.3.9` and `-2.4.2`).
11. **Replay.** `tools/lib/styles-text.ts`, `tools/replay.ts`, `test/unit/replay-styles.test.ts`.

### Close

12. **The whole proof.** `test/browser/plugin-parity-lint.test.ts`; `npm run check`, `npm run test:browser`,
    `npm run test:web`, `npm run test:performance`, `npm run corpus` (the two repo files measured directly): compare
    each by test name with Task 1's tallies; every difference is one of this plan's named edits. Mutation checks
    (cap `MemoryMax=4G`): S2's tier comparison (a look taken with differing tiers must fail the resolve test), S4 (a
    path a Figma style class sets taken anyway), B2's three values, the capture exclusion, the guard's `html:root`.
    Before and after pictures: `npm run snap -- corpus/files/gro-home.json <evidence>/builder/shots/after --sides`
    against Task 1's `before` (they must look the same; the report says so) and a `structure.txt` of GRO before and
    after (`<P>/tree.ts`).
13. **Docs & records.** `docs/HANDOFF.md`: a new section above the previous top one ("A Figma paste is built like
    an importer paste: no Div, every box named, repeated looks in shared classes"), with the rulings not yet
    confirmed (Q1–Q8 ⭐), the limits below, and the paste check owed at the top of "End-of-run check list"; the
    ledger; at the merge the finisher bumps `BUILD`, updates CLAUDE.md's Status (one line) and adds these standing
    rules: "Every frame and shape of a Figma paste is a Block; only an inlined picture is a Div; a Block that was a
    Div writes `_width: auto`, `_display: block` or `_flexWrap: nowrap` where a Div had no default (`IRNode.leaf`)",
    "Shared looks are decided in emit after adapt (`emit/looks.ts`): a class carries a path completely, at every
    tier, or not at all; tests read an element's drawn settings through `test/fixtures/drawn.ts`", and the
    `structure-parity-claude-md-pending.md` edit (Offcanvas no longer owed as a sample). Deferred, named in HANDOFF:
    plugin-overlays (Q7); hover and state looks in a class; a Button's icons in its class; look classes for a
    capture converted in the panel; size in a text class's name (Q4 B).

## Risks

- **Bricks' real print of one class on two element names** (a `card` look on a Section and a Block) was read in
  Bricks 2.2's `assets.php` by site-shared-styles, not seen on a live site; the last criterion is its proof for the
  plugin. A text class on a "Link" Block reaches its words by inheritance, as a Figma style's class does today.
- **A look's name is four letters** (456,976 per purpose): two different looks on two pages of one site can take the
  same name (about 4% once a site holds 200 looks of one purpose); Bricks then asks "Import classes" once. Q4 B
  (the size in the name) cuts it; named in HANDOFF.
- **A class edited in Bricks changes many elements**: a `column` look can sit on 100 Blocks. That is what Justin
  asked for; the report says it plainly, and `styles.txt` shows each class's uses.
- **Settings Justin sees on a Block that he didn't on a Div:** `Flex wrap: nowrap` (mostly inside a layout class
  with Q3 A, on the element with Q3 B) and `Width: auto` (on the element). The Div's `Display: flex` and `Direction:
  column` go.
- **The test renderer's stand-in CSS** lacks Bricks' `align-items: flex-start` on a Block; a test that draws a
  former Div with it could pass where Bricks differs. The criteria draw with Bricks' own CSS; a new browser test of
  this job never uses the stand-in for a Block-or-Div question.
- **The 62 edited tests**: an edit that weakens an assertion would hide a real change. Each edit is one of the six
  named kinds; the reviewer's brief lists the table and asks for every other changed assertion.
- **Order**: if importer-parity or bricks-icons merges first, `emit/elements.ts` and `understand/node.ts` conflict by
  context; keep both sides and rerun both jobs' tests.

## Completion and reporting

The builder stops at `ready-for-review` with: the branch and head; each criterion with its test's result; the
corpus numbers before and after; the before/after pictures and trees; every pinned test edited, by kind; rulings
taken (the ⭐ answers); deferred minors; `skill_lessons`. The live criterion is owed to Justin: convert, paste on
darksalmon, answer "Import classes", then reply *pasted* + the page name.
