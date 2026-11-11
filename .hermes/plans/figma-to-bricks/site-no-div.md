# site-no-div: an importer paste with no Div, built like a person built it in Bricks (plan, 2026-11-11)

Planner: site-no-div (Fable 5.2, high). Pipeline: **Full**. Website importer rules apply (repo CLAUDE.md: one real-bug
review per job, edge cases to follow-ups).
**Base: `main` once `site-native-structure` has merged** (today its head is `site-native-structure-fix3` `138799bb`, on
main `7eeca437`; it is being moved onto main as `site-native-structure-stack6`; main is `02481763`, Build 2026-11-11.3).
Every file:line below is from `git show site-native-structure-fix3:<path>` unless it says "main"; the builder re-reads
each on its real base before editing. Evidence (scripts, outputs, prototype diffs):
`~/.hermes/plans/figma-to-bricks/evidence/site-no-div/planner/` (`README.md` lists every file).
Plan copy for the repo: `docs/plans/2026-11-11-site-no-div.md` (the builder copies this file there in Task 1's commit).

## Playback

1. Justin pasted his bdryswi.com scan (Build 2026-11-11.3) into Bricks and the Structure panel is mostly "Div" inside
   "Div": 523 of the paste's 880 elements are Divs.
2. He wants no Div at all: a button is a Button, a picture an Image, words a Text, the layout Sections, Containers and
   Blocks, so the page reads as if someone built it in Bricks, for every scanned site, not only B-Dry.
3. The page must still look exactly like the old site at every width; a box Bricks has no element for becomes a Block
   (his answer), styled so nothing moves.

## Questions (⭐ = the answer the standing auto-go takes)

1. **A box Bricks has no element for** (a flip box's faces, a hotspot's layers, an icon list's rows, a holder that pads).
   ⭐ **A:** a **Block**, with a label saying what it is ("Row", "List item", "Icon", "Flip box"…) and the site's look on
   its class (Justin's answer). B: one Code element per such widget (one item in the panel, but its insides can't be
   edited in Bricks and it needs code signatures).
2. **Where it applies.** ⭐ **A:** every paste the code method makes, with no flag: the plain route and `--elementor`,
   `npm run site`, `site:upload`, `site:import`, and the boxes a button opens (Offcanvas). This replaces
   site-native-structure's "without the Elementor step every paste is byte for byte as before". The Figma panel's
   website route is not the code method (it goes through the Figma converter, which the 2026-11-04 decision retires
   for websites) and stays byte for byte, like every Figma design. B: only with `--elementor`.
3. **A link that is only words.** ⭐ **A:** painted (its own box has a background or an outline) → Bricks **Button**;
   not painted → Bricks **Text link** (what a person uses for a menu or footer link); words that hold an element (a bold
   part, a line break) → a Block carrying the link with a Rich Text inside (the Figma route's rule: "a text that is all
   one link is Rich Text inside a Block that carries the link"). B: every link a Block with a Rich Text inside.
4. **A `<button>` tag that is no link** (it opens a menu, sends a form). ⭐ **A:** a Block labelled "Button" that keeps
   the `button` tag: Bricks' Button prints a `span` or a link, never a `button`, so the keyboard behaviour and the
   browser's own button look would change. B: Bricks' Button (a span).
5. **Words in a `span`.** ⭐ **A:** one Rich Text, shown in the line as the span was (today: a Div holding a Rich Text).
   Words in a tag that means something (`li`, `label`, `figcaption`, `blockquote`, `strong`…) keep that tag: a Block
   with the tag holding the Rich Text, labelled ("List item", "Label", "Caption", "Quote").
6. **How shallow.** ⭐ **A:** this job folds a wrapper only where one small rule proves it adds nothing (the
   neutral-wrapper rule below: on B-Dry 51 boxes go on the plain route, 16 more after the Elementor step, and no
   measured row moves). A wrapper that pads, has a margin or lays out its element stays a Block. B: also move paddings
   and margins onto the element inside for any site (the planner's probe of Elementor's ten fold rules on every wrapper
   moved 55 of 114 measured rows, by up to 114 px: a later job with its own rules).
7. **Icons and drawings.** ⭐ **A:** as today, now labelled: the site's own `svg` stays a Code element ("SVG"), a
   font-glyph icon a Block ("Icon"). Bricks' Icon and SVG elements take a file from the media library, so that is a
   later job on top of `site:upload --svg` and media-clickable. B: in this job.
8. **Lists and menus.** ⭐ **A:** `ul`/`ol`/`li`/`nav` keep their tags (search engines and screen readers read them) as
   Blocks labelled "List", "List item", "Menu". Bricks' Nav (Nestable) for a site's menu is a later job (it needs
   Justin's Nav sample; CLAUDE.md "Never write those emitters from memory").
9. **Bricks controls instead of custom CSS.** ⭐ **A:** unchanged in this job: plain values that change only at Bricks'
   breakpoints are already controls (his paste: 524 classes; Typography on 166, Padding 141, Margin 142, Width 205,
   Background 60; all 524 also hold custom CSS for the site's own switch points, 75 hold only custom CSS). More
   controls (border, radius, shadow, position, grid) are a later job, "site-controls".
10. **Sections on a site without Elementor.** ⭐ **A:** by structure alone: a part's top boxes are Sections, a
    Section's only box its Container, every box inside a Block; a part root that draws nothing is left out, as
    site-native-structure does for Elementor. B: one Block per part.
11. **Order.** ⭐ **A:** build after site-native-structure merges (footer-icon-list merges before it). The Minis running
    now (media-clickable, site-menu-motion, site-sticky-header, site-scroll-lock) merge whenever they are ready; this
    job rebases onto them ("Overlaps" names the shared files).

## What Justin will see (prototype numbers, his 2026-11-11 capture, `--elementor`)

Today's paste on the base head: 526 elements, **243 Divs**. After this job (the planner's prototype of the rename, the
span, the Button and Text link by shape and rule N; `~/.cache/snd/p4`): **495 elements, 0 Divs**: 30 Sections, 16
Containers, 278 Blocks (66 are the site's rows, columns and grids; the rest are labelled boxes inside widgets Bricks
has no element for: flip boxes about 70, the FAQ's insides 40, icon lists 24, hotspot 17, holders that pad or have
margins about 40…), 51 Headings, 64 Rich Texts, 23 Buttons (17 from Elementor's button widgets, 6 painted links found
by shape), 15 Images, the Slider, the Accordion, a Divider and 15 Code elements (the site's svg icons, two embeds). The
phone menu and the pop-ups (Offcanvas, on main since Build 2026-11-11.2) add Blocks labelled "Menu", "List", "List
item" and Text links for the menu's links. So the panel reads Section › Container › Block "Row" › Heading / Text /
Button / Image. What still reads as "a box in a box" is inside the widgets listed under "Later jobs". The same capture
on the plain route: 734 → 654 elements, 568 → 0 Divs. Drawn by `site:check` on the B-Dry stand-in, no measured row
moves on either route (`chk-p4-el.log`, `chk-p4-plain.log` against `chk-base.log`, `chk-base-plain.log`: 0 of 114 rows
worse by more than 0.5 px).

## Today's Divs by cause

Counted by `divs.ts` (evidence), each Div matched to its site element in the capture.

**A. The base head's paste with the Elementor step** (Justin's capture; 526 elements, 243 Divs; `divs-sns-el.txt`):

| Where | Divs | What they are |
|---|---|---|
| Inside widgets "kept as page code" | 148 | flip-box 72, icon-list 24, hotspot 17, icon 10, spacer 8, animated-headline 7, social-icons 6, html 2, the carousel's widget box and holder 2 |
| Inside the FAQ (Accordion) | 40 | the site's own title rows, icons and answer boxes inside each item |
| Widget box and holder of a widget whose fold was refused | 55 | heading 26, text-editor 16, image 8, button 4, site-logo 1 ("its holder pads", "margin box", "inside a sized widget box", …) |

| Shape | Divs |
|---|---|
| A wrapper around one box | 100 |
| A wrapper around one Heading 12, Text 11, Code (svg) 12, Image 5, Button 2, Slider 1 | 43 |
| A layout box around several elements (30 `div`, 1 `h3`, 1 `span`) | 32 |
| Words in a tag Rich Text can't print, as Div + Rich Text: `span` 14, `a` 6, `li` 5 | 25 |
| An empty box: `i` drawing a font glyph 12, `div` (spacer, overlay) 8 | 20 |
| A link box `a`: around several 12, around one box 2 | 14 |
| A list: `ul` 2, `ol` 1, `li` boxes 5 | 9 |

**B. Justin's own paste (main, Build 2026-11-11.3, `~/Downloads/bdry-test/paste/`; `divs-main-justin.txt`):** 880
elements, **523 Divs**: the same causes without site-native-structure's Buttons, Sections and folds (button widgets'
insides 82, heading boxes 50…), plus **129 Divs inside the 5 Offcanvases** (the phone menu and the pop-ups: the boxes a
button opens are pasted by the plain code method).

**C. The plain route (no `--elementor`) of the same capture (`divs-sns-plain.txt`):** 734 elements, **568 Divs** (77%):
wrapper around one box 274, layout box 78+, around a Heading 39, words in `span` 31, around a Text 26, link boxes 36,
around a picture 9, empty boxes 19, lists 5.

**D. A site without Elementor (the plain-HTML fixture `code-page`; `divs-code-page-plain.txt`):** 105 elements, **51
Divs**: layout boxes (`div`, `section`, `nav`, `main`, `article`, `form`, `footer`, `p`, `h2`) 20, wrappers around one
element 12, words in `span` 4, `a` 3, `strong` 2, `li`, `article`, `button` 1 each, link boxes 3, a list 2, an empty `i` 1.

## Why (file:line)

1. **Every site box is a Div**: `src/core/site/kinds.ts:78` `if (n.kind === "box") return outer("div", …)` (main:
   `kinds.ts:80`). The code method keeps one Bricks element per site element by design (`tree.ts:1-4`).
2. **Words in any tag but h1–h6, `div` and `p` are a Div holding a Rich Text**: `kinds.ts:89` (main `:91`) `return {
   ...outer("div", tagged(DIV_TAGS)), wrap: … }`.
3. **The Elementor step maps widgets by type only**: `elementor-fold.ts` `BODIES` (heading, image, text-editor) plus
   the button, linked-picture, divider, slider and accordion branches; every other widget is "kept as page code"
   (`elementor-fold.ts` near the end of `foldElementor`: `notes.push(\`kept as page code: …\`)`), so its insides fall to
   causes 1 and 2. An accordion's fragments are picked as Divs by name: `elementor-accordion.ts:112` `picks.set(c, {
   name: "div", … })`.
4. **A refused fold keeps the widget box and holder** (cause 1 again), and **the plain route has no Section, no
   Container, no label and no fold at all** (site-native-structure Q2 A kept it byte for byte).
5. **The boxes a button opens** go through the same `prepare` (main `open-paste.ts:20-31`), so they get causes 1 and 2.

## The general rule

One rule set for every scanned site, read from structure and declared CSS only (tags, children, the capture's ranges
and boxes), never a site's ids, class names or words. It runs after the Elementor step when that is on (a pick made by
the Elementor step, the slider, the FAQ, a live widget or an opened box's wiring is never changed), and alone on the
plain route.

**Why nothing moves:** Bricks' own looks for these elements sit in `@layer bricks`
(`reference/bricks/frontend-2.4.2/frontend-light-layer.min.css` and `frontend-2.3.9/…`), and the paste's first class,
`site-reset-<4>` (`classes.ts` `RESET`: `all: revert`, unlayered), cancels every layered rule for every element under
the paste. A class's controls print as `.cls.brxe-<element>` (0,2,0) for a Block as for a Div
(`reference/bricks/README.md` "Class selectors"). Block and Div are the same Bricks class with the same 84 controls
(`Element_Block extends Element_Container`, `Element_Div extends Element_Container`: Bricks 2.2
`evidence/djtrees-phone-menu/research/source-2.2/block.php`, `div.php`; schema 2.4.3 `block.json` = `div.json` but the
name), so the Tag control, Custom tag and Link carry over unchanged. **Measured:** with every box a Block, `site:check`
of the B-Dry stand-in gives the same `report.json` as the base head, drawn with Bricks 2.4.2 and with 2.3.9, and the
same for the plain fixture site (`chk-base*.log`, `chk-p1*.log`, `code-page-chk-*.log`). With the span, the Text link and
Button by shape and rule N added (prototype `p4`), still no row moves on the stand-in (both routes) and the plain
fixture stays at 0.01 px (`chk-p4-el.log`, `chk-p4-plain.log`, `cp-chk-p4.log`). Not prototyped (the builder proves
them): rule S's Sections and Containers on the plain route, the labels, the linked picture by shape.

### The mapping

| The site's element | Becomes | What Bricks adds by default, and how the paste undoes it |
|---|---|---|
| A part's top box (Elementor: a top-level container; else: by structure, rule S below) | **Section** (label: its first words, "Header · "/"Footer · " first) | `.brxe-section{display:flex;flex-direction:column;align-items:center;margin:auto;width:100%}`, wraps from 767 down: layered, cancelled by the reset; prints `<section>` where the site had a `div` (no CSS names the tag) |
| A Section's only box (Elementor: `e-con-inner`; else: its only shown child when that is a box) | **Container** | `.brxe-container{width:1100px;margin:auto;display:flex;flex-direction:column;align-items:flex-start}`: layered, cancelled |
| Any other box that holds elements (row, column, grid, card, `a` around several, `ul`, `ol`, `li`, `nav`, `form`, `figure`, `picture`, a heading tag holding elements) | **Block** with the site's tag (Tag control, else Custom tag) and its link when it is an `a` | `.brxe-block{display:flex;flex-direction:column;align-items:flex-start;width:100%}`, wraps from 767 down, `[class*=brxe-]{max-width:100%}`: layered, cancelled. Layout keys (`_direction`, `_rowGap`…) are valid on a Block (layout element). Never `_alignSelf: stretch` (nothing writes it) |
| A `div` that adds nothing around its one element (rule N below) | **left out**: its element takes its place | nothing |
| An empty box (a spacer, an overlay, an `i` or `span` drawing a font glyph with `::before`, a background photo) | **Block**, labelled Spacer / Shape / Icon / Photo | as a Block; in the Bricks editor an empty Block shows the editor's own drop zone, as an empty Div does today |
| h1–h6 of words | **Heading** (as today) | layered, cancelled |
| `div` or `p` of words, words beside elements | **Rich Text** (as today) | `site-text` / `site-flat` (as today) |
| `span` of words | **Rich Text** carrying the class, with `display: inline` where the site declares no display there | prints a `div`: the added `display: inline` is the span's own browser default |
| `a` of plain words with a link, its own box painted (a background colour or picture, or a visible border, in any kept range where it shows) | **Button**: `text` the words, `link`, no Style | `.bricks-button{display:inline-flex;gap:10px;padding:.5em 1em;letter-spacing:.5px;border-width:0;…}`: layered, cancelled; prints `<a class="brxe-button … bricks-button">` (`reference/bricks/README.md` "button-plain.json") |
| `a` of plain words with a link, not painted | **Text link**: `text`, `link` | `.brxe-text-link{display:inline-flex;gap:5px;align-items:center}`: layered, cancelled; prints `<a class="brxe-text-link …">words</a>` (Bricks 2.2 `text-link.php` L182-207; Justin's own two in `ExampleBricks`) |
| `a` of words that hold an element, an `a` with no link or a link left off | **Block** (tag `a`, link) holding a flat Rich Text, labelled "Link" | as a Block |
| Words in any other tag (`li`, `label`, `figcaption`, `blockquote`, `strong`, `em`, `button`, `td`, `summary`…) | **Block** with that tag holding a flat Rich Text, labelled by the tag | as a Block |
| `a` holding exactly one picture and nothing else, link kept, the picture with no hover look | **Image** with Link to (as site-native-structure's linked picture, now for any site): the `a`'s look on the class, the `img`'s under ` > img` | `a.brxe-image{display:inline-block}`, `:where(.brxe-image).tag{…}`, `:where(.brxe-image) img{height:100%;width:100%}`: layered, cancelled |
| `img` | **Image** (as today) | layered, cancelled |
| `svg`, `iframe`, `video`, form fields, another company's live widget | **Code** (as today), now labelled SVG / Embed / Video / Field / Widget | `site-flat` (as today). Code only where the markup itself must be kept |
| Elementor's button, divider, linked picture, carousel, FAQ, heading, image, text editor | as site-native-structure, site-slider and site-faq make them | unchanged |

A `<button>` tag is never Bricks' Button (Q4 A). Basic-text mode (`--basic-text`, the proof's) keeps Basic Text for
words and gets Blocks for boxes.

**Rule S, a part's sections without a page builder's map** (`select.ts` `sectionsOf` already finds them for the class
names): go down from the part's root through boxes holding exactly one shown child; the first box holding anything
else holds the sections. They are its shown children when every one is a box; else that box is the part's one Section.
Each is a Section. The boxes above them are left out when `lift.ts` `liftOf` proves each draws and lays out nothing;
else they stay Blocks (the root labelled "Header", "Page" or "Footer") with the note `the <part>'s root stays: <why>`,
as on the Elementor step. A section paste's root (`--section`, `--path`) is a Section. An opened box's root is a Block
(it sits inside the Offcanvas's Content).

**Rule N, the neutral wrapper** (a new, small rule; the ten Elementor fold rules are not reused outside Elementor's
widgets: the planner's probe of them on every wrapper moved 55 of 114 rows). A `div` W whose only shown child is the
element C is left out, C taking its place and W's declarations merged onto C by `merge` (`elementor-fold.ts`), when
all of these hold; else W stays a Block:
- N1. W is a `div` holding exactly one child (no words beside it, no hidden element, no drawn space), with no
  `::before`/`::after` and no look under a state.
- N2. At every kept range W's declarations draw and lay out nothing: `lift.ts` `drawsAt` is null after leaving out
  `transition-*`, `-webkit-tap-highlight-color` and a `position: relative` with no offset and no `z-index` (`merge`
  keeps `position: relative` on C, so a placed descendant keeps its containing block).
- N3. W and C show in the same ranges.
- N4. Wherever C shows it is block-level (`elementor-place.ts` `displayOf`, `BLOCK_LEVEL`), not floated, not
  `absolute`/`fixed`, and declares no flex or grid item property of its own (`ITEM`, `itemNeutral`).
- N5. The capture's boxes say W's box is C's: W has no layer of its own (the capture folded it into its only child:
  `src/web/map/tree.ts:4-6`, "has the child's box (±1px)") and C has one; or W's box equals C's within 0.5 px at every
  measured width of a kept range.
- N6. Neither W nor C is an element another step chose or needs: a pick (`TreePick`), a `pasteHidden` or lifted path,
  anything inside an accordion item (`Folded.scopes`), a live widget's slot or a box above it, an opened box's opener
  or ×, the part's root.
It repeats down a chain (W1 › W2 › C). Prototype: `proto-p3-fold.diff` (`foldBoxesProto`), measured on the B-Dry
stand-in: plain route 51 folded, with the Elementor step 16 more, 0 of 114 rows worse by more than 0.5 px
(`chk-base-plain.log` vs `chk-p3-plain.log`, `chk-base.log` vs `chk-p3-el.log`).

**Labels** (every Block and every Code element; Bricks' own Heading, Rich Text, Image, Button, Text link, Divider,
Slider, Accordion, Container get none; a label the Elementor step, the slider, the FAQ or the Offcanvas gave wins):
a Section its first words (site-native-structure Q5 A); a box by its tag where the tag says it (`ul`/`ol` "List", `li`
"List item", `nav` "Menu", `form` "Form", `figure` "Figure", `a` "Link", `button` "Button", h1–h6 "Heading",
`details` "Details", `summary` "Summary", `table`/`tr`/`td`/`th` "Table"/"Table row"/"Cell", `label` "Label",
`figcaption` "Caption", `blockquote` "Quote"); an empty box "Icon" (it draws a `::before`/`::after` with content),
"Photo" (a background picture), "Spacer" (it paints nothing) or "Shape"; any other box by its role (`classes.ts`
`roleOf`: "Row", "Column", "Grid", "Box", "Photo"); words in another tag "Text"; a Code element "SVG", "Embed"
(`iframe`), "Video", "Audio", "Field" (form fields), "Widget" (a live widget).

**Notes** (per part, one line each, first): `Structure: <n> elements, no Div: <a> Sections, <b> Containers, <c> Blocks,
<d> Headings, <e> Texts, <f> Buttons, <g> Text links, <h> Images, <i> Code` and, when any, `folded: <k> boxes that add
nothing` and `kept as Blocks: <n> boxes (<count> <reason>, …)` with rule N's first refusal per box counted by reason.
`npm run site` also writes `<outDir>/structure.txt`: each part's tree as the Structure panel shows it (two spaces per
level, the label or Bricks' own name).

**Class names** stay `<page>__<name>` (the decision); new roles: `button`, `link` (Text link and link Blocks), `media`.

## How far this job goes, and later jobs

In this job: no Div anywhere; Sections, Containers and labelled Blocks on every site; Button, Text link, linked Image
and inline Rich Text by shape; the neutral-wrapper fold; the notes and `structure.txt`.
Later jobs (each its own plan; named in HANDOFF "Deferred"):
- **site-icons:** the site's svg and font icons as Bricks Icon/SVG elements from the media library (with `site:upload
  --svg`; beside media-clickable).
- **site-widgets:** cleaner native structures for widgets kept as the site's own boxes (flip box, hotspot, icon list,
  social icons, animated headline) and for the FAQ's insides.
- **site-fold-more:** wrappers that pad or have margins outside Elementor's widgets (rules of their own, measured).
- **site-nav:** a site's menu as Bricks' Nav (Nestable) (needs Justin's sample).
- **site-controls:** border, radius, shadow, position and grid as Bricks controls.
- **Video, Form:** Bricks' Video for a site's video, the Bricks Form job (already named in the notes).

## Overlaps and order

| Job | State | Shared files | How they meet |
|---|---|---|---|
| site-native-structure (base) | review-clean, being moved onto main (stack 6) | all of `src/core/site/` | merges first; this job builds on it and reuses `lift.ts`, `labels.ts`, `merge`, `TreePick`, the linked-picture pick |
| footer-icon-list | before site-native-structure | renderer, `test/web/` B-Dry tests | merges first (the footer's 69 px row) |
| media-clickable (Mini, planning) | running | `src/core/site/media.ts` (`imageSettings`), `kinds.ts` (img), `convert.ts` | this job's linked Image by shape builds its `image` setting through `imageSettings`, so it carries the media id the same way; rebase keeps both |
| site-menu-motion (Mini) | running | `opens.ts`, `open-paste.ts`, the menu's sub-list elements | this job renames the sub-list's boxes (Block) and may make its links Text links; N6 keeps openers and ×; its selectors must name classes, never `brxe-div` (none does today) |
| site-sticky-header (Mini) | running | `parts.ts`, `lift.ts`, the header's root | a header root or section that is `sticky`/`fixed` is never left out by rule S (`drawsAt`: "positions") and never folded by rule N |
| site-scroll-lock (Mini) | running | page-wide CSS on the paste's top elements | this job changes which element is a part's top element on the plain route (Sections): its lock must sit on every top element (`t.parent === 0`), as the reset does |

Order: footer-icon-list → site-native-structure → (the Minis as they finish) → **site-no-div**. The builder starts
only when `git log main` shows site-native-structure's build commit; it rebases onto main before `ready-for-review`.

## Acceptance criteria (all **proposed**)

"Within 2 px" is measured as site-native-structure measures it: each part drawn as Bricks draws it (its front-end CSS,
the paste's classes printed as Bricks prints them, pictures from the capture's bytes), every element paired by the
paste's sources, at every width the capture read. Fixtures are generic, never copies of B-Dry.

- AC1 (proposed): Given any captured page, no element of any paste is a Div (`name: "div"`): the plain route and the Elementor step, rich and basic text, both picture modes, section pastes, whole pages, and the boxes a button opens. Test `test/unit/site-no-div.test.ts` "no paste holds a Div: every code fixture, both routes, both text modes, sections, whole pages and opened boxes".
- AC2 (proposed): Given the mapping table above, each kind of site element becomes its Bricks element: a box that holds elements a Block with the site's tag and link; a `span` of words one Rich Text with `display: inline` where the site declares none; a linked `a` of plain words a Button when its own box is painted in a kept range where it shows, else a Text link, each with `text` and `link` and no child; an `a` whose words hold an element, an `a` without a kept link, and words in any other tag (`li`, `label`, `button`…) a Block with that tag holding one Rich Text; an `a` holding exactly one picture an Image with Link to, the picture's own look under ` > img` (an `a` holding words too, or a picture with a hover look, stays a Block around an Image); a `button` tag never a Bricks Button. Test `test/unit/site-native-kinds.test.ts` "each kind of site element becomes its Bricks element: Block, Rich Text, Text link, Button, linked Image".
- AC3 (proposed): Given any paste, every Block and every Code element has a label by what it is (the table under "Labels"), a label given by the Elementor step, the slider, the FAQ or the Offcanvas wins, and no Heading, Rich Text, Image, Button, Text link, Divider, Slider, Accordion or Container has one. Test `test/unit/site-native-labels.test.ts` "every Block and Code element of any paste has a label by what it is, on both routes".
- AC4 (proposed): Given a page without a page builder's map (or without `--elementor`), each part's sections by rule S are Sections labelled with their first words, a Section's only shown child that is a box its Container, every other box a Block; a part root (and one-child boxes down to its sections) that draws and lays out nothing is left out, one that pads, paints, positions or lays out stays one Block labelled with its part with the note `the <part>'s root stays: <why>`; a section paste's root is a Section; an opened box's root is a Block. Test `test/unit/site-plain-sections.test.ts` "without a page builder's map a part's top boxes are Sections, a Section's only box its Container, a neutral root left out".
- AC5 (proposed): Given rule N, a `div` that adds nothing folds into its only element on both routes (its declarations merged onto the element, a chain of them too), and each of these stays a Block, counted by its reason in the notes: another tag than `div`; words, a hidden element or a drawn space beside the element; a pseudo element; a look under a state; other shown ranges than its element; a declaration that pads, paints, clips, sizes, positions (an offset or a `z-index`), has a margin or lays out; an inline-level, floated, `absolute`/`fixed` or flex-item element; a box of its own that isn't its element's; a path another step chose (a pick, an accordion item's inside, a live slot or a box above it, an opener or ×, the part's root). Test `test/unit/site-fold-boxes.test.ts` "a div that adds nothing folds into its only element; one that draws, lays out, changes under a state or is needed stays a Block".
- AC6 (proposed): Given the generic plain-HTML fixture site `plain-natives` (header, page, footer; no page builder), its whole page pastes with no Div, Sections at the top of each part, its painted links Buttons, its plain links Text links, its linked logo an Image, its neutral wrappers gone, and every part is within 2 px of the site at every width the capture read, drawn with Bricks 2.4.2's front-end CSS and with 2.3.9's. Test `test/web/site-no-div-plain.test.ts` "a plain HTML site pastes with no Div and within 2 px at every width, drawn with Bricks 2.4.2 and 2.3.9".
- AC7 (proposed): Given that fixture's Button, Text link and linked Image made by shape, hovering and focusing each shows the site's own hover and focus look (colour, background, underline, transform) within 2 px at 1440 and 390. Test `test/web/site-no-div-plain.test.ts` "a Button, a Text link and a linked Image made by shape show the site's hover and focus look".
- AC8 (proposed): Given the Elementor fixture site `elementor-natives` with the Elementor step, its whole page pastes with no Div, every Block and Code element labelled, and stays within 2 px at every width the capture read, drawn with Bricks 2.4.2 and with 2.3.9. Test `test/web/site-no-div-elementor.test.ts` "the Elementor natives fixture pastes with no Div and within 2 px at every width, drawn with Bricks 2.4.2 and 2.3.9".
- AC9 (proposed): Given B-Dry's saved 2026-10-29 home served on 127.0.0.1 (never the live site; the stand-in capture of the base's B-Dry test), its header, page and footer paste with no Div with the Elementor step and without it, every Block and Code element labelled, fewer elements than the base's paste of the same capture on each route, and every part within 2 px at every width the capture read on both routes, drawn with Bricks 2.4.2 and with 2.3.9. Test `test/web/site-no-div-bdry.test.ts` "B-Dry's saved page pastes with no Div on both routes and within 2 px at every width" (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, optional `F2B_ELEMENTOR_STANDIN`).
- AC10 (proposed): Given a page whose button opens a box (a drawer, a pop-up), the Offcanvas's content holds no Div, every opener and every proven × still carries its Interaction (Click → Toggle offcanvas) whatever Bricks element it became, and a closed `details` still pastes its hidden content. Test `test/unit/site-no-div-opens.test.ts` "a box a button opens pastes with no Div and its openers and × keep their Interaction".
- AC11 (proposed): Given the native step switched off (`ConvertOptions.native: false`, a test and diagnosis switch), every paste of every code fixture equals the base's paste element for element, class for class, except that each `div` is named `block`. Test `test/unit/site-no-div-names.test.ts` "with the native step off every paste equals the base's but for Div named Block" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC12 (proposed): Given any Figma design, its conversion is byte-identical to the base's (`npm run corpus` no worse, `test/unit/plugin-convert.test.ts` passes). Test `test/unit/site-no-div-figma.test.ts` "every Figma replay is byte-identical to the base's" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC13 (proposed): Given `npm run site`, each part's notes start with the `Structure:` line (its counts by Bricks element, "no Div"), then `folded:` and `kept as Blocks:` when any, and `<outDir>/structure.txt` holds each part's tree as the Structure panel shows it (labels, else Bricks' names; no line reads "Div"). Test `test/web/site-cli.test.ts` "site writes the Structure line per part and structure.txt, and no line names a Div".
- AC14 (proposed) (live): Justin scans bdryswi.com again with the new build, runs the import with `--elementor`, empties B-Dry staging `/homev2/` and pastes header, page and footer: Bricks' Structure panel shows Section, Container, Block (labelled), Heading, Rich Text, Button, Text link, Image and no "Div"; clicking a hero button shows Bricks' Button controls with its words; at 1440 and at 390 the page looks as it did before. Test: Justin's paste check `<site-no-div id at merge>` (HANDOFF "End-of-run check list").

RED on the base: AC1–AC10 and AC13 (Divs everywhere; no Text link, no Button or linked Image outside Elementor's
widgets; no label or Section on the plain route; no fold outside Elementor's widgets; no `Structure:` line). Regression
pins: AC11 and AC12 (their goldens are recorded on the base in Task 1).

## Architecture

Pure, in `src/core/site/` (built-ins only). Nothing under `src/core/emit`, `src/core/adapt`, `src/plugin`, `src/ui`
or any Figma stage changes (the twelfth criterion); the panel's website route (the Figma converter on a capture's
layers; `src/ui` imports only `core/site/styled-ranges.ts`) is untouched. Every command-line entry (`tools/site.ts`,
`site-check.ts`, `site-live.ts`, `site-upload.ts`, `site-import.ts`, `tools/lib/site-whole.ts`) calls `siteParts` /
`siteToBricks`, so each gets the same pastes with no change of its own.

- `kinds.ts`: `elementFor` never returns `div`. `KindContext.native?: { painted: (path: string) => boolean }` (absent:
  the native step is off: boxes are Blocks, words as on the base). `boxLook` adds `display: inline` for a `span` of
  words printed as a Rich Text.
- `natives.ts` (new, ≤ 120 lines): `paintsBox(d: CodeDecls): boolean` (a background colour that isn't clear, a
  background picture, or a border side with a style and a width); `linkedPictures(code, root, link, taken):
  Map<string, TreePick>` (the `a` around one picture, as `elementor-fold.ts`'s linked branch builds its pick, the image
  setting through main's `media.ts` `imageSettings`).
- `fold-boxes.ts` (new, ≤ 150 lines): `foldBoxes(capture, root, keep): { capture, folded: number, kept: Record<string,
  number> }` (rule N; `proto-p3-fold.diff` is the working prototype). It imports `merge`, `layerBoxes`, `ITEM`
  helpers from `elementor-fold.ts` (export what it needs), `drawsAt` from `lift.ts` (export it), `keptAt` from
  `elementor-measured.ts`, `BLOCK_LEVEL`/`displayOf` from `elementor-place.ts`.
- `lift.ts`: `plainSections(capture, part): { sections: string[]; holder: string }` (rule S, over `select.ts`
  `sectionsOf`); `liftOf` is reused as it is.
- `labels.ts`: `boxLabel(code, pr, path, parentPath)`, `wordsLabel(tag)`, `codeLabel(node, live)`.
- `convert.ts` `prepare`: `ConvertOptions.native?: boolean` (default true). Order inside `prepare`: the Elementor step
  (as now) → rule S when no page builder's map ran and a part is given (picks `section`/`container`, `lift`) →
  `linkedPictures` (never over an existing pick) → `foldBoxes` (keep = every pick, `pasteHidden`, `lift`, the keys of
  `scopes`, live slots and the boxes above them, and the opener and × paths the opened-box step names on main:
  `Placed.openers` and `open.closers`, passed into `prepare`) → the tree → labels for every Block and Code element
  without one → the notes. `whereOf` needs no change (`text-link` and `button` take `ON_ELEMENT`).
- `elementor-accordion.ts:112`: the fragment pick's name `div` → `block`.
- `parts.ts`, `open-paste.ts`: unchanged calls; the `Structure:` line is built where each part's notes are joined.
- `tools/site.ts`: writes `structure.txt`. No new flag (the usage lines and their byte pins stay).
- Renderer (tests only, `test/browser/render.ts`, site route only): a `text-link` prints as Bricks prints it (`<a
  class="brxe-text-link <classes>" href>text</a>`, a `span` when unlinked; `reference/bricks/frontend-2.3.9/
  el-text-link.min.css` inside the Bricks layer). The Figma route's Nav printing (`render-nav.ts`) is untouched.
- `reference/bricks/`: `text-link-plain.json` (Justin's own Text link from `ExampleBricks`, its icon keys left off) and
  a README entry (source lines above; "from Justin's copy, icon removed").

## Tasks (test-first; commit after each passing task, files by name; never commit CLAUDE.md)

Setup (every task): the job's worktree; `export PATH=/home/justin/.local/node-v22.23.3/bin:$PATH
TMPDIR=/home/justin/.cache/snd-b/t1 CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; heavy runs under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G); a command that dies with SIGTERM, 143, 137
or "Killed" may be earlyoom: check its journal first. Receipts go under a folder given by a variable
(`F2B_NO_DIV_OUT`), never one fixed shared folder. Read `figma-to-bricks/references/repeat-mistakes.md` and
`feature-dispatch/references/repeat-mistakes.md` first.

### Milestone 0: the base's facts

**Task 1 (records and pins).**
- Check `git log --oneline main` holds site-native-structure's build commit; else stop and report.
- Copy this plan to `docs/plans/2026-11-11-site-no-div.md`; start `.superpowers/sdd/2026-11-11-site-no-div/progress.md`.
- Base tallies into the ledger: `node --test "test/unit/**/*.test.ts"` (fixer 3's on `138799bb`: 3546 tests, 0 fail),
  `npm run corpus`, and the list of `test/web/site-*.test.ts` and `test/browser/*.test.ts` files with pass/fail on the
  base (a base failure is named, not fixed here).
- Record the pins on a `git archive <base>` tree (never the worktree after edits):
  `test/fixtures/site-no-div-pins.json` = for each paste `test/unit/lib/site-pins.ts` lists, the sha256 of its payload
  with every element named `div` renamed `block` (recorder `test/unit/lib/site-no-div-pins.ts`, built on that list);
  `test/fixtures/site-no-div-replay-pins.json` = the sha256 of `bricks.json` from `npm run replay` for each corpus file
  (memory "Checks on the desktop": the local corpus copies).
- Before pictures and trees: `npm run site -- <elementor-natives capture> <out> --elementor` and the B-Dry stand-in's
  pastes on the base, their element histograms into the ledger (the "before" of `structure.txt`).
- Commit: the plan copy, the ledger, the two recorders and pins files.

### Milestone 1: no Div (what the screenshot asks)

**Task 2 (AC1, AC11): every box a Block.**
- RED: write `test/unit/site-no-div.test.ts` (every fixture maker of `test/fixtures/site-code.ts`,
  `site-page-code.ts`, `site-elementor-code.ts`, `site-live-widget.ts`, `site-opens-code.ts`, through `siteToBricks`
  and `siteParts`, `elementor` off and on, `text` rich and basic, `pictures` data and address; assert no element named
  `div`, listing the offenders' site paths) and `test/unit/site-no-div-names.test.ts` (named-only; `native: false`;
  each paste's sha256 equals the pin). Run: the first fails naming Divs, the second (with `F2B_PIN_BASE=1`) fails
  because head still writes `div` while the pins hold `block`.
- GREEN, `src/core/site/kinds.ts` (two lines) and `elementor-accordion.ts:112` (one word):
  ```ts
  if (n.kind === "box") return outer("block", PLAIN.has(n.tag) ? {} : tagged(DIV_TAGS));
  // …
  return { ...outer("block", tagged(DIV_TAGS)), wrap: { settings: rich(html), shared: [TEXT_SHARED, FLAT_SHARED] } };
  ```
  ```ts
  picks.set(c, { name: "block", settings: {}, noLink: true });
  ```
  `convert.ts` `whereOf` keeps `t.name === "block"` (drop the `"div"` arm). Add `native?: boolean` to
  `ConvertOptions` (read in later tasks; here it changes nothing).
- Existing tests that pin the old name (expect `"div"` for a site box): change only that literal to `"block"`, one
  commit, each file named in the ledger: `test/fixtures/site-elementor-code.ts`, `site-page-code.ts`, `site-code.ts`,
  `site-live-widget.ts`, `site.ts`, `test/unit/site-css.test.ts`, `site-class-names.test.ts`, `site-parts.test.ts`,
  `site-kinds.test.ts`, `site-hidden-parts.test.ts`, `site-text.test.ts`, `site-replay.test.ts`,
  `site-native-sections.test.ts`, `site-live-widget.test.ts`, `site-elementor-unchanged.test.ts`,
  `site-elementor-fold.test.ts`, `site-convert.test.ts`, `site-p-box.test.ts`, `site-elementor-widgets.test.ts`,
  `site-elementor-names.test.ts`, `site-elementor-button.test.ts`, `site-alt.test.ts`, `test/web/site-live*.test.ts`,
  `site-elementor-places.test.ts`, `site-elementor-pbox.test.ts`, `site-elementor-divider.test.ts`, `site-cli.test.ts`,
  `test/web/lib/bricks-printed.ts`, and main's `site-opens*` tests. Hand-made payloads in `test/browser/render-*.test.ts`
  that use a Div on purpose (the renderer's own tests) stay.
- Goldens that hold element names, regenerated through each one's own generator and named in the ledger with the
  reason "Div → Block": `test/fixtures/site-basic-golden.json`, `test/fixtures/site-slider-base/`,
  `test/fixtures/site-motion-base/`, `test/fixtures/site-native-pins.json` (the base job's story-time pin: re-recorded
  on this job's head and its header comment updated), `test/fixtures/site-no-revert-main.json` (`node
  tools/site-no-revert-golden.ts .`, CLAUDE.md's rule for a job that changes a site paste on purpose).
- Proof it is names only: `F2B_PIN_BASE=1 node --test test/unit/site-no-div-names.test.ts` passes.

**Task 3 (AC4): Sections, Containers and the part root on the plain route.**
- RED: `test/unit/site-plain-sections.test.ts` on `pageCode()` (`test/fixtures/site-page-code.ts`: header, main,
  footer): the page's top boxes are Sections with first-words labels; a Section's only box child is a Container, a
  Section holding two boxes has none; the neutral root is left out (`PartResult.lifted`); with `patch` a root that pads
  stays a Block labelled "Page" with the note; a part whose root holds words directly is one Section; `siteToBricks`'s
  root is a Section; with `elementor: true` and Elementor's map present the result is the base's.
- GREEN: `lift.ts` `plainSections`; in `prepare`, when `opts.native !== false`, a `part` is given and no Elementor map
  ran: picks `section` (role `section`, label `sectionLabel(firstWords(…), part)`), `container` for a Section's only
  shown child of kind box, `liftOf(code, pr, rootPath, sections)` → `picks.lift` or the root's Block and note, exactly as
  the Elementor branch does. For `siteToBricks` (no part): the root's pick is `section` unless a pick exists.
- The checks follow a lifted plain part: `tools/lib/site-measure.ts` and `site:live` read a lifted part from
  `PartResult.lifted` (site-native-structure fixer 3). Run `test/web/site-check-lifted.test.ts` and `site-live-lifted`;
  **stop condition:** if either needs Elementor's map to find a lifted part's sections, give them `plainSections` and
  say so in the ledger.

**Task 4 (AC3): labels.**
- RED: extend `test/unit/site-native-labels.test.ts` with the new test (plain `pageCode()` and `elementorCode()`:
  every `block` and `code` element has a label from the table; natives none; an Elementor widget's own label wins).
- GREEN: `labels.ts` `boxLabel`, `wordsLabel`, `codeLabel`; in `prepare` after `buildTree`, fill `label` on every
  `block` and `code` node that has none (`TreeNode.label`), reading the folded code and the kept ranges for "Icon",
  "Photo", "Spacer", "Shape".

**Task 5 (AC10): the boxes a button opens.**
- RED: `test/unit/site-no-div-opens.test.ts` on `opensCode()`, `drawerOpen`, `popupOpen` (main's
  `test/fixtures/site-opens-code.ts`): no Div in any part's content; each opener and × element has the
  `toggleOffCanvas` Interaction; the closed `details`' hidden paths are pasted.
- GREEN: nothing new is expected after Task 2; if an opener loses its Interaction, fix `open-paste.ts` `elementAt`
  for the element that stands for the path. Commit the test.

Milestone 1 gate: `npm run check`; `node --test "test/web/site-*.test.ts"` (capped); the B-Dry stand-in `site:check
--all --elementor` and `--all` rows equal to the base's (the planner's: equal reports). Commit.

### Milestone 2: natives by shape

**Task 6 (AC2): a span of words is a Rich Text.**
- RED: `test/unit/site-native-kinds.test.ts`, first cases: a `span` words node → one `text` element carrying the class
  (no `block` around it), its class's base block holding `display: inline`; a `span` whose site CSS sets `display:
  inline-block` keeps that; with `native: false` it is a Block holding a Rich Text.
- GREEN, `kinds.ts`:
  ```ts
  if (ctx.native && n.tag === "span") return outer("text", rich(html), [TEXT_SHARED]);
  ```
  placed after the `p` line, and in `boxLook` the words-on-a-Rich-Text arm adds `display: inline` for tag `span` where
  the range's declarations hold no `display` (a table `WORDS_LOOK`, read only for words, so a `span` box is untouched).
  `prepare` passes `native` in the `KindContext` when `opts.native !== false`.

**Task 7 (AC2): Text link.**
- First the sample: `reference/bricks/text-link-plain.json` and its README entry.
- RED: cases in `site-native-kinds.test.ts`: a linked `a` of plain words, not painted → `text-link` with `text` (the
  words as HTML text, entities as written), `link: { type: "external", url, newTab? }`, no child, class on the
  element; words holding `<strong>` or `<br>` → a Block (tag `a`, link) holding a Rich Text; no `href`, or a link the
  link rules leave off → a Block holding a Rich Text; `payloadProblems` accepts each.
- GREEN, `kinds.ts` (words branch, rich mode, after the span line):
  ```ts
  if (ctx.native && n.tag === "a" && href !== null && !/<[a-z!]/i.test(html))
    return outer(ctx.native.painted(path) ? "button" : "text-link", { text: html, ...link });
  ```
- Renderer: `test/browser/render.ts` prints `text-link` on the site route; a unit of the renderer's own
  (`test/browser/render-site-options.test.ts` style) pins the printed tag and classes.

**Task 8 (AC2): Button by shape.**
- RED: cases: the same `a` with a background colour, with a background picture, with a visible border, painted only in
  the phone range, each → `button` with `text`, `link`, no `style`; painted only in a range that hides it → Text link;
  a `button` tag of words → a Block with Custom tag `button` labelled "Button".
- GREEN: `natives.ts` `paintsBox`; `prepare` builds `painted(path)` over `statesOnKept(node.decls, code, pr)` at the
  ranges where the node shows. Role `button` for the class name.

**Task 9 (AC2): a linked picture by shape.**
- RED: cases: `a` (href kept) holding one `img` → one `image` element with `link`, no child, its class's ` > img` part
  holding the picture's own declarations; `a` holding an `img` and words, an `img` with a hover look, a link left off →
  a Block around an Image; with a media map (`opts.media`, main) the Image carries the library id.
- GREEN: `natives.ts` `linkedPictures`; `prepare` adds its picks where no pick exists.

**Task 10 (AC6, AC7): the plain fixture site.**
- New fixture `test/fixtures/web/sites/plain-natives/` (`index.html`, `style.css`; generic words, no builder markup):
  a header (a linked logo picture, a `nav` › `ul` › `li` › `a` menu, a painted "call" link), three page sections (a
  hero with a heading, a paragraph, two painted links with hover looks and a transition; a card row inside two neutral
  `div` wrappers and one wrapper that pads; a section with a `span` label, a list, a `figure` with a caption, an inline
  svg icon, a `button` tag), a footer (plain links with a hover underline, an `i` font-glyph stand-in drawn with
  `::before`, a small print line), with media queries at the site's own widths (1100, 820, 600) so ranges split.
- RED → GREEN: `test/web/site-no-div-plain.test.ts`, shaped like `test/web/site-native-structure.test.ts`
  (`captureFixture("plain-natives")`, `siteParts(cap, { text: "rich" })`, `checkPage`), once per Bricks version (give
  `checkPage`/`renderSitePaste` the `bricks` option `site:check --bricks` uses); asserts the element kinds the sixth
  criterion names and the 2 px rows; the second test hovers and focuses the three natives on the site page and on the
  drawn paste and compares boxes and computed colours.

Milestone 2 gate: `npm run check`; the web site tests; the stand-in rows on both routes no worse than Milestone 1's.

### Milestone 3: a shallower tree

**Task 11 (AC5): the neutral-wrapper fold.**
- RED: `test/unit/site-fold-boxes.test.ts` on `pageCode()` with `patch`es, one case per outcome AC5 names (a fold; a
  chain of two; `position: relative` and `transition` still fold; a declared `color` on the wrapper lands on the
  element's class; and each refusal with its counted reason), plus: the folded wrapper's path is in no `sources`, the
  element's parent is the wrapper's parent, `elementor: true` gives the same for a box outside every widget, and
  `native: false` folds nothing.
- GREEN: `fold-boxes.ts` from the prototype (`proto-p3-fold.diff`), with N5's "C has a box when W has none" and N6's
  keep set added; exports in `elementor-fold.ts`, `lift.ts`. Called in `prepare` (Architecture's order).
- Mutation check (the fold is a guard on the look): for each of N1–N6, remove the check and see a named case fail
  (run under the memory cap); record the table in the ledger.

**Task 12 (AC8, AC9, AC13): the fixtures' whole pages, B-Dry, the notes.**
- `test/web/site-no-div-elementor.test.ts` and `test/web/site-no-div-bdry.test.ts` (the second shaped like
  `test/web/site-native-bdry.test.ts`, same environment variables and stand-in; both routes; both Bricks versions;
  element counts below the base's, which Task 1 recorded; `F2B_NO_DIV_OUT=<dir>` writes the tables, pastes,
  `structure.txt` and site | paste pictures at 1440 and 390).
- The `Structure:` / `folded:` / `kept as Blocks:` lines and `structure.txt` (`tools/site.ts`); `test/web/site-cli.test.ts`
  gains AC13's test.
- **Stop condition:** a row over 2 px that the base's B-Dry test doesn't have → find the element (`report.json`), name
  the rule that made it, and tighten that rule or refuse the shape (the box stays a Block); never raise the tolerance.

### Close

**Task 13 (gates).** `npm run check`, `npm run corpus` (no worse than Task 1's), `npm run test:browser`, `npm run
test:web`, the named-only tests (`F2B_PIN_BASE=1` for AC11 and AC12; AC9's variables), each receipt in the evidence
folder with its head. Rebase onto main if it moved; rerun what the rebase touched. Stop at `ready-for-review`.

**Task 14 (Docs & records).**
- This plan in `docs/plans/2026-11-11-site-no-div.md` (Task 1); the finisher moves the ledger to
  `docs/plans/2026-11-11-site-no-div-ledger.md` before the final premerge commit and rebase.
- `docs/HANDOFF.md`: a new section above the previous top `## ` heading ("A website paste holds no Div": the mapping
  table, rules S and N, the labels, what stays a Block and why, the planner's and builder's counts, the rulings "not
  yet confirmed" for Q1–Q11, "Deferred": the later jobs), and its paste check at the top of "End-of-run check list"
  with the next free id (checked free on main and on every local branch, the skill's rule), build "set at the merge".
- `reference/bricks/README.md`: the Text link entry; "Block and Div are one Bricks class (same controls)".
- `BUILD` bumped by the merge finisher; main `CLAUDE.md` after the merge: the Status build line and one line for this
  feature with its paste check, and two standing rules: "**A website paste never holds a Div** (`test/unit/
  site-no-div.test.ts`; add every new element producer to it)" and "the native step is on for every importer paste
  (`ConvertOptions.native: false` is a test and diagnosis switch)"; the decision line "An importer box Bricks has no
  element for is a labelled Block (Justin, 2026-11-11)". If the write is refused: `~/.hermes/plans/figma-to-bricks/
  site-no-div-claude-md-pending.md`.
- The base job's HANDOFF lines saying the plain route is "byte for byte as before" get a pointer to this section.

## Tests and validation

| AC | Test (file, name) | Kind |
|---|---|---|
| first | `test/unit/site-no-div.test.ts` | unit, default suite |
| second | `test/unit/site-native-kinds.test.ts` | unit |
| third | `test/unit/site-native-labels.test.ts` (new test in the base's file) | unit |
| fourth | `test/unit/site-plain-sections.test.ts` | unit |
| fifth | `test/unit/site-fold-boxes.test.ts` | unit + mutation table |
| sixth, seventh | `test/web/site-no-div-plain.test.ts` (two tests) | Chrome |
| eighth | `test/web/site-no-div-elementor.test.ts` | Chrome |
| ninth | `test/web/site-no-div-bdry.test.ts` | Chrome, named-only |
| tenth | `test/unit/site-no-div-opens.test.ts` | unit |
| eleventh, twelfth | `test/unit/site-no-div-names.test.ts`, `test/unit/site-no-div-figma.test.ts` | named-only pins |
| thirteenth | `test/web/site-cli.test.ts` (new test) | CLI |
| fourteenth | Justin's paste check | live |

One terminal capture per AC goes to the evidence folder (nothing here is visual but AC6–AC9's pictures at 1440 and
390, which `F2B_NO_DIV_OUT` writes).

## Risks and open points

- **A Theme Style that styles Block, Container or Section outside Bricks' layer** would show on every Block (today it
  would show on the base's 66 Blocks only). Staging's saved CSS (`evidence/staging-fit/planner/staging/css/`) holds
  none for `.brxe-block`, `.brxe-container`, `.brxe-section` or `.brxe-text-link` without a paste class but the paste's
  own accordion and slider rules; site-native-structure checked `.brxe-section`, `.brxe-button`, `.bricks-button`. The
  live check (AC14) is the proof on B-Dry; HANDOFF says what to look at on another site.
- **Bricks' editor** shows its own drop zone in an empty Block (spacers, glyph icons), as it does in an empty Div today;
  the live page is the judge.
- **Text link and Button `text` hold the words as HTML text.** Only plain words become one (Q3 A), so the builder's
  Text field shows what the page shows.
- **Rule N is proved on the widths the capture read** (as every fold rule is); between them a `div` that adds nothing
  can't differ unless a rule the capture didn't see applies, which N2 already refuses (it reads every kept range).
- **The planner's CLI probe of the stand-in** shows the page part 64 px off at widths ≥ 768 and the footer 69.07 px
  (footer-icon-list) on the base head and on every prototype alike. AC9 is measured by the base's own B-Dry harness
  on the merged base; if the merged base itself fails its B-Dry test, the builder stops and reports (not this job's).
- **Goldens of merged jobs move by design** (Task 2's list); each is regenerated by its own generator and named.
- **Files near the 300-line rule:** `convert.ts` and `elementor-fold.ts` are over it on the base (R1-7); this job adds
  its logic in new files and at most 30 lines to `convert.ts`.
- **Not verified in Bricks by a round trip:** a Block with Custom tag `span`/`i`/`li`/`button` (Justin's pastes on
  staging hold Divs with them today, and Block is the same Bricks class), a Text link with no icon pasted from
  outside. The live criterion covers both.

## Completion and reporting

The builder stops at `ready-for-review` with: the head, every AC's test receipt, the ledger, the before and after
element histograms and `structure.txt` of the natives fixtures and the B-Dry stand-in, the mutation table, the goldens
regenerated (each with its reason), any stop condition met, and `skill_lessons[{skill, lesson, evidence, enforce}]`.
Not claimed by this plan: anything on B-Dry staging or bdryswi.com (the fourteenth criterion is Justin's).
