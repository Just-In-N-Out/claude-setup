# site-native-structure: the website importer's paste reads like a Figma paste in Bricks' Structure panel (plan, 2026-11-09)

Planner: site-native-structure (Opus 5.5, high). Base: main `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3).
**[amended]** (amendment 5) Base now: main `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4, `git merge-base HEAD main`); fixer 2
rebased the branch onto it. The tallies, pins and planner receipts below that name `fd1986dc` were taken there.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/planner/` (scripts and their outputs named
below). Website importer rules apply (repo CLAUDE.md: one real-bug review per job, edge cases to follow-ups). Pipeline:
Full. Plan copy for the repo: `docs/plans/2026-11-09-site-native-structure.md` (the builder copies this file there in
Task 1's commit).

## Amendments (2026-11-10, planner amendment 1, wording only; head `0581852c7fd95092ad6be1e2650cc3beb8c1808b`)

Changed lines are marked **[amended]** with the amendment's number. The pre-amendment text is the approved copy
`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`, the same text as
`git show 0581852c:docs/plans/2026-11-09-site-native-structure.md`. No criterion is added, removed or renumbered; every
cited test name is unchanged (each already sits whole on its criterion's line). **Amendments 1 and 2 (and the rule text
of 3) are the fixers' and reviewers' reading under Justin's standing "go with recommended", to be confirmed with
Justin:** on B-Dry's stand-in 15 of 17 Buttons and 4 of 5 linked pictures stand alone; the three that keep a box are a
header button whose widget box is 74% wide (`ef454b9`), a footer button in a padded holder pulled out by -5px margins
(`58a7a74`) and the phone header's logo in a 60% wide widget box (`ba89ea2`).

1. The Button criterion (sixth): a Button stands for its widget box with no box around it only where fold rule 10
   proves its place on the capture's boxes; elsewhere its widget box stays, labelled, named in the notes (review 2's
   R2-2, the reviewer's wording, with one correction from the head: where the wrappers can't fold into the widget box
   they stay inside it, so "one box" isn't always one: B-Dry's footer button `58a7a74` keeps the box labelled Button and
   two unlabelled Divs, `fixer-2/gates/ac14-out/footer.json`; fixer 1's rule 10 after verifier 1 found a Div labelled
   "Button" around every real Button).
2. The linked-picture criterion (tenth): the same reading for a linked picture's Image (R2-2: "and AC10 for the
   linked picture").
3. "The general rule" gains fold rule 10, "Placed bodies", with its refusals, the padded holder of a placed native and
   the share across beside side margins, as the head has them (`src/core/site/elementor-place.ts`; fixers 1 and 2,
   reviews 2 and 3).
4. The B-Dry criterion (fourteenth): it pins the counts above and a note for every kept box, and names its input: the
   saved 2026-10-29 home served on 127.0.0.1 (never the live site), by sha256, and not Justin's 2026-11-09 capture,
   which main refuses since Build 2026-11-09.4 (fixer 2; R2-2's "pin the count").
5. The byte-identical criterion (thirteenth) and the header: the base is now main `3cfc54ac`; the pins recorded on
   `fd1986dc` stay meaningful (review 3's R3-5).
6. The Sections criterion (first): "a section paste's root as before" says what before was (a boxed root a Section, a
   nested full one a Block), following HANDOFF's builder's ruling "a nested full container picked as a section paste's
   root stays a Block, as before" (`elementor-fold.ts`: `top || (e.boxed && e.path === root)`, as base's
   `e.boxed && e.path === root`).
7. The holder-padding criterion (eleventh): it states the head's whole condition (a block-level body with a px or no
   padding of its own there, `border-box` wherever a box of its chain sizes that axis), as approved Task 12 already
   said "isn't inline-level" and review 1's R1-3 found the `border-box` condition (right to refuse; the capture's fault).

**Receipts that still encode the old expectation** (sorters run on the job's heads: builder `d83b68c7`, fixer 1
`6988ba59` and its rebase `db582920`, fixer 2 `0581852c`):
- Amendment 1: the builder's and verifier 1's AC6 receipts (`verifier-1-d83b68c7/ac6-d83b68c.log`, the builder's gates)
  ran a test asserting the wrappers folded into one Div labelled "Button" around the Button; now the Button is alone
  where rule 10 proves its place. Only receipts from `6988ba59` on count. Sorters (1 0 0 0, then 0 1 1 1):
  `git show <head>:test/unit/site-elementor-button.test.ts | grep -c '"the wrappers folded into one box"'`
  `git show <head>:test/unit/site-elementor-button.test.ts | grep -c 'alone in its container, no box around it'`
- Amendment 2: the cited linked-picture test is unchanged from `d83b68c7` to `0581852c` (it never asserted the box
  around), so its receipts stay valid for what it asserts; the standing alone is proved by rule 10's supporting tests,
  which exist from fixer 1 on (`test/web/site-elementor-places.test.ts`, its first test named in "The general rule").
  Sorter (0 on `d83b68c7`, no such file; 1 on the rest):
  `git show <head>:src/core/site/elementor-place.ts | grep -c 'export function placedBoxes'`
- Amendment 4: every B-Dry receipt before fixer 2 (the builder's, `verifier-1-d83b68c7/ac14-d83b68c.log`, fixer 1's)
  ran a test that counted alone Buttons only as more than 0. Fixer 2's receipt `fixer-2/gates/ac14-0581852c.log` holds
  the new expectation (alone: 15 of 17 Buttons, 4 of 5 linked pictures; boxes around `ef454b9`, `58a7a74`, `ba89ea2`;
  worst 1.09 px). Sorter (0 on `d83b68c7`, `6988ba59`, `db582920`; 2 on `0581852c`):
  `git show <head>:test/web/site-native-bdry.test.ts | grep -c 'SAVED_PAGE_COUNTS'`
- Amendments 5, 6, 7: wording only; the cited tests and the pins file are unchanged from `d83b68c7` to `0581852c`, so
  their receipts stay valid. Check (prints nothing):
  `git diff --stat d83b68c7 0581852c -- test/unit/site-native-unchanged.test.ts test/fixtures/site-native-pins.json test/unit/site-native-sections.test.ts test/unit/site-elementor-fold.test.ts`

## Questions (⭐ = the answer the standing auto-go takes)

1. **What "within 2 px" means once the paste uses Bricks' own elements.** ⭐ **A:** the promise stays. A Bricks native
   element (Section, Button, Divider, a linked Image) replaces the site's elements only where a rule proves it draws the
   same boxes (like the Elementor fold's nine rules: judged on every kept range, the first broken rule named in a note
   and the widget keeping today's elements). Every native is proved 1:1 on a generic fixture in Chrome at every width,
   and B-Dry's whole saved page stays within 2 px with the step on. B: let Bricks' own looks show where they differ
   (button padding, divider line), a few px off.
2. **Which route.** ⭐ **A:** the Elementor step (`--elementor`) only: it is the route that knows what each box is (a
   button, a divider, a page section); without the step every paste stays the code method's, byte for byte, and Figma
   designs are untouched. B: also give the plain code route Sections and labels by structure alone (a follow-up).
3. **The part's root (the "Div, Div, Div" in the screenshot: header root, page root, footer root).** ⭐ **A:** a root
   (and any single-child wrapper down to its sections) that draws nothing and lays out nothing is left out: the paste's
   top elements are the page's sections, as in a Figma paste and as Bricks' Header/Footer templates expect; each
   section carries the reset class and what the page passes down. A root that draws or lays out (padding, a gap, a
   background, a positioned box…) stays, as one Block labelled "Header", "Page" or "Footer". B: always keep the root as
   that labelled Block.
4. **Which Elementor containers are Sections.** ⭐ **A:** every top-level Elementor container (no Elementor element
   above it, its tag `div` or `section`) is a Section; a boxed one's `e-con-inner` is its Container; every nested
   container stays a Block. This replaces elementor-map's Q3 A ("a Section only when it is the paste's root", not yet
   confirmed): today a whole-page paste has no Section at all.
5. **Labels in the Structure panel.** ⭐ **A:** a Section is labelled with its first words (at most 5 words, 40
   characters, "…" when cut), the header's and footer's sections starting "Header · " / "Footer · "; a section without
   words "Section" (Header/Footer likewise). A Block made from a container is labelled by its role (Row, Column, Grid,
   Box, Photo); a widget the step keeps as page code is labelled by its Elementor type ("Icon list", "Social icons",
   "Flip box", "Site logo", "Spacer", "HTML"…); Bricks' own elements (Heading, Rich Text, Image, Button, Divider,
   Accordion, Container) get no label (Bricks names them). B: no labels.
6. **Buttons.** ⭐ **A:** an Elementor `button` widget becomes one Bricks **Button**: its words in Bricks' Text, its link
   in Link to, no Style (Bricks' Theme Style "primary" can't paint over the site's own look), the site's look on its
   class. A button whose svg icon sits beside its words keeps it as the Button's `::before`/`::after`, drawn from the
   icon's own svg as a CSS mask in the words' colour (so a hover colour follows), as the Figma route draws button icons.
   A button whose words have a look of their own, hold an element, or whose icon is a font glyph keeps its elements
   (named). B: Bricks' Icon control for the icon (needs a media-library upload or an icon font: not 1:1).
7. **Icons on their own (icon widget, icon list, social icons).** ⭐ **A:** keep the site's own drawing (its svg or its
   font glyph), labelled; no Bricks Icon element: Bricks' Icon takes only an icon-library glyph (Font Awesome 6,
   Ionicons, Themify: another drawing than the site's) or an SVG from the media library (an upload the paste can't
   carry). B: Bricks' Icon with Font Awesome where Elementor's icon is a Font Awesome one (may differ by a few px).
8. **Bricks controls instead of custom CSS.** ⭐ **A:** unchanged rule: a value goes in a Bricks control only where it is
   plain and changes only at Bricks' own breakpoints (991/767/478); the site's own switch points (1366, 1024, 921…)
   stay custom CSS, because a control would move them to Bricks' widths and the page would differ there. B: round the
   site's switch points to Bricks' (not 1:1 between them).
9. **A shallower tree.** ⭐ **A:** two fold refinements in this job, each proved 1:1 on a fixture: (a) a holder's
   padding moves onto a body that paints nothing, sizes nothing on that axis and has no margin on that side ("its
   holder pads": 15 of B-Dry's widgets, e.g. heading 9c53d85); (b) margins on one side inside a widget box that is a
   flex or grid item become one margin, summed and collapsed as the browser does ("two margins on one side": 18
   widgets, e.g. heading e704deb). B: leave the fold rules as they are (a follow-up).
10. **Linked pictures (the site logo).** ⭐ **A:** an image or site-logo widget whose picture is linked becomes one Bricks
    Image with Link to (Bricks prints it as `<a class="brxe-image tag"><img></a>`); the link's look on the Image's class,
    the picture's own on its `img`. B: keep today's Div > Div > a > img (elementor-map's "a linked image stays as it is").
11. **Order.** ⭐ **A:** two waves in this one job: wave 1 (Tasks 2–6: Sections, the part root, labels) is what Justin's
    screenshot asks for and commits alone; wave 2 (Tasks 7–13: Button, Divider, linked Image, the two fold
    refinements) follows. Build beside the other five jobs; merge after staging-fit's renderer job (job C) if it merges
    first (rebase onto it: its `.cls.brxe-<element>` printing is what the native elements are weighed against),
    otherwise before it; independent of staging-fit's capture job A.

## Playback

1. Justin captured bdryswi.com (`/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, build 2026-11-09.1, 48
   widths), ran the importer with the Elementor step (build 2026-11-09.3) and pasted the whole page
   (`/home/justin/f2b-test/paste-el3/whole.json`, the main session's hand-join of `header.json`, `page.json`,
   `footer.json`) onto B-Dry staging `/homev2/`.
2. In Bricks' **Structure** panel the page is three bare **Div**s (screenshot 11: Div, Div, Div), and inside them mostly
   more Divs.
3. He wants the structure the Figma plugin gives: Sections, Containers and Blocks for the layout, Headings, Rich Text,
   real **Buttons**, pictures as Images, classes named by purpose, a shallow tree, while the page still looks like the
   site ("I want the structure to work like the plug-in when we copy it from Figma to Bricks — how the buttons are laid
   out, the area stuff we did. I don't want it to be all div div div.").

## What the site is and what the paste does (proof)

**The site (capture, `widgets.ts` → `widgets.txt`, `roots.ts` → `roots.txt`, `buttons.ts` → `buttons.txt`):**
- Three parts, each an Elementor document: header `body/div:0/header:0` (`header.elementor.elementor-location-header`, 3
  shown top-level containers), page `…/article:0/div:0/div:0` (`div.elementor.elementor-9`, 17), footer
  `body/div:0/footer:0` (`footer.elementor-location-footer`, 11). 31 page sections in all, each a top-level Elementor
  container (`e-parent`, boxed or full).
- The part roots draw nothing: own declarations only `box-sizing: inherit` (and `margin-bottom: 0` on the page root);
  header and footer roots have Elementor's clearfix `::before { content: ""; display: table; clear: both }`; no states.
- Widgets shown (header / page / footer): containers 9/62/20, heading 2/31/11, button 2/18/2, image 0/11/3, text editor
  0/13/12, icon 3/0/0, theme-site-logo 3/0/0, spacer 1/0/1, icon-list 0/0/2, social-icons 0/0/1, html 0/0/2, divider
  0/1/0, flip-box 0/6/0, nested-carousel 0/1/0, animated-headline 0/1/0, hotspot 0/1/0, elementskit-accordion 0/1/0.
- Every button widget is `widget box > elementor-widget-container > elementor-button-wrapper > a.elementor-button >
  span.elementor-button-content-wrapper (display: flex; flex-direction: row; justify-content: center) >
  span.elementor-button-text (display: inline-block; plain words)`; the `a` carries the look (`display: inline-block`,
  background or gradient, colour, `fill` = colour, 3 px radius, `padding: 12px 24px`, `line-height: 1`, `text-align:
  center`) and states (hover/focus: background, colour, transform grow). No B-Dry button has an icon.
- The divider is `widget box > holder > div.elementor-divider (display: flex; padding-block 15px) >
  span.elementor-divider-separator (display: flex; width: 100%)`.

**The paste (`hist.mjs` → `hist-whole.txt`):** 1112 elements: **div 624**, block 93, image 153, heading 51, text 158,
code 16, container 16, accordion-nested 1; **no section, no button, no icon, no divider, no label**; max depth 16
(average 8.2); every one of the 447 classes carries `_cssCustom`. The three roots are Divs. Divs by printed tag: div
443, span 123, a 32, i 12, li 10, ul 2, ol 1, h3 1. The notes (`/home/justin/f2b-test/paste-el3/notes.txt`): Elementor
220 elements, 120 as Bricks elements, 100 kept as page code: button 17, flip-box 6, theme-site-logo 2, spacer 2,
icon-list 2, icon 2, html 2, social-icons 1, nested-carousel 1, hotspot 1, divider 1, animated-headline 1; refused folds
"its holder pads" 15, "two margins on one side" 18, "doesn't fill its widget box" 5, "its picture is linked" 3.

**For comparison, Justin's own Bricks build (`ExampleBricks`, `example.mjs`):** 151 elements, section 8, container 5,
block 28, div 37, heading 18, text-basic 19, text 6, button 7, icon 10, divider 2, image 6, Nestables 4; max depth 6;
element custom CSS on 7. Bricks 2.3.9 prints them as `<section class="brxe-section">`, `<a class="brxe-button <classes>
bricks-button bricks-background-primary" href…><i class="ion-md-call"></i>call us today</a>`, `<div class="brxe-divider
horizontal"><div class="line"></div></div>` (darksalmon's home read today, GET only: `darksalmon/home.html`).

**On staging (Bricks 2.4.2, from staging-fit's saved CSS, `staging-rules.mjs` → `staging-rules.txt`):** Bricks' own
rules for Section, Container, Block, `.bricks-button` (gap 10px, padding .5em 1em, letter-spacing .5px, inline-flex) and
the Divider all sit in `frontend-light-layer.min.css` (`@layer bricks`), so `site-reset`'s unlayered `all: revert`
already cancels them for every element under the paste, as it does today for the 93 Blocks and 16 Containers; no theme
style on staging names `.brxe-section`, `.brxe-button` or `.bricks-button` outside `@layer`. Bricks prints a class's
controls as `.cls.brxe-<element>` (0,2,0) (staging-fit R3): a native element's class controls are weighed there, and
staging-fit job C makes the renderer print them so.

## Root cause (file:line)

1. **Every site box is a Div.** `src/core/site/kinds.ts:71` `if (n.kind === "box") return outer("div", …)`; words in a tag
   Rich Text can't print become a Div holding a Rich Text (`kinds.ts:82`). The code method (web-code-proof Q2 A) keeps
   one Bricks element per site element by design (`src/core/site/tree.ts:1-4`).
2. **The Elementor step makes a Section only of the paste's root.** `src/core/site/elementor-fold.ts:258`
   `e.boxed && e.path === root ? section : block`. In a part paste the root is the part's root (an Elementor document
   div/header/footer, `src/core/site/parts.ts:53` `prepare(capture, x.root, …)`), never a container, so a whole-page
   paste has no Section at all.
3. **The part roots are pasted as plain Divs with no label.** The root is a `header`/`main`-like box (`kinds.ts:32`
   `PLAIN` → Div, Bricks owns those landmarks), named `<page>__site-<part>` (`parts.ts:79`), and nothing writes Bricks'
   `label` (`src/core/site/convert.ts:314-317` `payloadOf` builds `{ id, name, parent, children, settings }` only; the
   Figma route writes `el.label`, `src/core/emit/elements.ts:190`). So the Structure panel's top level is exactly
   "Div, Div, Div".
4. **Buttons, dividers and linked pictures have no Bricks element.** `src/core/site/elementor-fold.ts:91-112` `BODIES`
   maps only `heading`, `image` (refusing a linked one, `:95`) and `text-editor`; every other widget is "kept as page
   code" (`:282`), i.e. one Div per wrapper (17 buttons × 6 elements on B-Dry).
5. **Two fold rules refuse common Elementor widgets:** "pads" (`elementor-fold.ts:46` `[/^padding-/, zero, "pads"]`, any
   wrapper padding) and "two margins on one side" (`:163`), so 33 headings, images and text editors keep their
   widget box and holder Divs.

## The general rule

On the Elementor step, the paste is built from Elementor's own element kinds and widget types (never a site's ids, words
or class names, as elementor-map reads them): a part's root that draws nothing is left out; each top-level container is
a **Section** (its boxed inner a **Container**), nested containers **Blocks**; headings **Headings**, text **Rich Text**,
pictures **Images** (a linked one with Link to), buttons **Buttons**, dividers **Dividers**, accordions **Accordion
(Nestable)** (elementor-map), with Bricks labels saying what the rest is; and only where a rule proves the same boxes. A
widget no rule can prove keeps today's elements, named in the notes. Classes stay named by purpose (unchanged); values
go to Bricks controls where today's rule allows (unchanged, Q8).

**[amended]** (amendment 3; to be confirmed with Justin) **Fold rule 10, "Placed bodies"** (`src/core/site/elementor-place.ts`,
called from `foldable` in `elementor-fold.ts`): a Button's or linked picture's body (the `a`, an inline-block `img`) is
inline-level, so folded into its widget box it becomes its container's item; it folds only where that draws the same
boxes, proved on the capture's boxes at every width of every kept range within 0.5 px (the widget box read from the
first wrapper the capture holds a box for). The widget box must be a flex or grid item wherever the body shows. In a
widget box stretched across a flex column or a grid cell (no alignment, width or cap of its own) the merged element
takes `align-self` (column) or `justify-self` (grid) of its line's text-align (start, center, end) and a `width: 100%`
taken from the widget box is left off; anywhere else nothing is written and the body must already have its widget
box's place. For a Button or linked Image a wrapper's px padding around the body becomes the merged element's margin
(no margin of a box inside on that side, no size of the widget box's own on that axis; a `max-width: 100%` becomes
`calc(100% - <the paddings>)`). A body's own % width, min-width or max-width beside side margins (px, 0 or more) of the
boxes around it is written `calc(p% - p·M/100 px)` where the widget box is stretched with no width of its own, and
refused elsewhere. Refused, each named `not folded: button <id>: <rule>` (`not folded: image <id>: …`, `not folded:
theme-site-logo <id>: …`) with the widget box kept around the native, labelled by the widget's type ("Button", "Image",
"Site logo"), its wrappers folded into that one box where the fold rules allow, else kept inside it (B-Dry's footer
button `58a7a74`: the box labelled Button, then two unlabelled Divs, then the Button): a body that doesn't fill its widget box (a sized or grown widget box, a row's item past its box's start), a
body not where its line's text-align puts it, a padded holder that can't become a margin, a `width: 100%` (any %)
button in a row or a centring column ("a share of its widget box"), a padded body a never-wrapping row shrinks ("sized
by its row"), a widget box stretched taller than its body (rule 9), a body inline in a block parent, a body placed at
a side of a right-to-left line (`direction: rtl`), a share beside a margin it can't subtract. Proofs:
`test/unit/site-elementor-button.test.ts` "a Button stands for its widget box only where its place is proven; else one box stays around it, named",
`test/web/site-elementor-places.test.ts` "a captured button or linked picture stands alone in its container, placed as its line's text-align placed it: within 2 px at every width"
and "beside its widget box's side margins a button or picture sized by a share keeps the site's box: within 0.5 px at every width".

## Acceptance criteria (all **proposed**)

Fixture names are generic (`test/fixtures/web/sites/elementor-natives/`, `test/fixtures/site-elementor-code.ts`), never
copies of B-Dry. "1:1" means measured as `site:check` measures (drawn as Bricks draws it, pictures from the capture's
bytes, every box and word from the part's top-left at every width the capture read): within 2 px.

- AC1 (proposed): Given a whole-page conversion with the Elementor step, every top-level Elementor container of each part (tag div or section) is a Bricks Section, a boxed one's `e-con-inner` its Container, nested containers Blocks; a section paste's root as before (a boxed root a Section, a nested full one a Block) **[amended]** (amendment 6). Test `test/unit/site-native-sections.test.ts` "every top-level Elementor container of a part is a Section, its boxed inner a Container".
- AC2 (proposed): Given a part whose root (and single-child wrappers down to its sections) draws and lays out nothing (declarations only neutral at every kept range; a `::before`/`::after` only an empty `display: table|block` pseudo beside a section with no margin on that side), its sections are the paste's top elements, each first-classed with the reset (and the font class where the part has one) and carrying what the page passes down; no element of the paste is the root. Test `test/unit/site-native-sections.test.ts` "a part's root that draws nothing is left out: its sections are the paste's top elements".
- AC3 (proposed): Given a part root that pads, has a gap, paints, is positioned, is flex/grid, or draws a pseudo that isn't empty, the root stays as one Block labelled with its part ("Header", "Page", "Footer"), and the notes say why (`the page's root stays: it pads (padding-top)`). Test `test/unit/site-native-sections.test.ts` "a part's root that draws or lays out stays one Block labelled with its part".
- AC4 (proposed): Given the Elementor step's paste, every Section has the label of Q5 A (its first words, header/footer prefixed, "Section" with none), every Block made from a container its role, every kept widget's box its Elementor type, and no Bricks native element (heading, text, image, button, divider, accordion-nested, container) a label. Test `test/unit/site-native-labels.test.ts` "every Section, Block and kept widget of the Elementor step's paste has a label by its purpose".
- AC5 (proposed): Given the generic fixture site `elementor-natives` (header, page and footer documents), its whole page with the Elementor step has Sections at the top (no part root, no top-level Div) and is 1:1 with the site at every width the capture read. Test `test/web/site-native-structure.test.ts` "the natives fixture with the Elementor step: Sections at the top, within 2 px at every width".
- AC6 (proposed): **[amended]** (amendment 1; to be confirmed with Justin) Given an Elementor button widget whose content wrapper and words declare only layout-neutral values and whose words are plain, it is one Bricks Button (name `button`): `text` its words, `link` its link (none when it has none), no `style`, its class the merged look of its `a` and of the wrappers folded into it; an svg icon beside the words is its class's `::before` (icon first) or `::after`, a CSS mask of the icon's own svg in `currentColor`; it stands for its widget box in its container, with no box around it, wherever fold rule 10 proves its place on the capture's boxes at every width of every kept range (`align-self` or `justify-self` from its line's text-align in a stretched column or grid cell); elsewhere its widget box stays around it, labelled Button (its wrappers folded into that one box where the fold rules allow, else kept inside it), and the notes say why (`not folded: button <id>: <rule>`). Test `test/unit/site-elementor-button.test.ts` "an Elementor button widget is one Bricks Button with its words and link".
- AC7 (proposed): Given the fixture's buttons (words only; an svg icon left; an svg icon right; full-width stretched; unlinked), each pasted as a Bricks Button is 1:1 with the site at every width, and hovering each shows the site's hover look (background, colour, transform) within 2 px. Test `test/web/site-elementor-button.test.ts` "buttons as Bricks Buttons: within 2 px at every width, hover as on the site".
- AC8 (proposed): Given a button whose words have a look of their own (a declared colour, font or padding), whose words hold an element, whose content wrapper's `justify-content` disagrees with the `a`'s `text-align`, or whose icon is a font glyph (`<i>`), it keeps today's elements and the notes name the rule (`not a Button: button b100003: its words have a look of their own (color)`). Test `test/unit/site-elementor-button.test.ts` "a button whose words have a look of their own, hold an element or draw a font icon keeps its elements, named".
- AC9 (proposed): Given an Elementor divider widget, it is one Bricks Divider whose box is the merged widget box, holder and `elementor-divider`, and whose line (`> .line`) takes the separator's look, 1:1 at every width; a divider with text or an icon in its line keeps its elements (named). Test `test/web/site-elementor-divider.test.ts` "a divider widget is one Bricks Divider: within 2 px at every width".
- AC10 (proposed): **[amended]** (amendment 2; to be confirmed with Justin) Given an image or site-logo widget whose picture is linked, it is one Bricks Image with Link to (`<a class="brxe-image tag"><img></a>`), the `a`'s merged look on the Image's class and the `img`'s own look on `> img`, 1:1 at every width and its hover as on the site; it stands for its widget box in its container, with no box around it, wherever fold rule 10 proves its place on the capture's boxes at every width of every kept range (`align-self` or `justify-self` from its line's text-align in a stretched column or grid cell); elsewhere its widget box stays around it, labelled with its widget's type (Image, Site logo; its wrappers folded into that one box where the fold rules allow, else kept inside it), and the notes say why (`not folded: <image|theme-site-logo> <id>: <rule>`). Test `test/web/site-elementor-linked-image.test.ts` "a linked picture is one Image with Link to: within 2 px at every width".
- AC11 (proposed): Given a heading, image or text-editor widget whose holder pads (px) and whose body is block-level, paints nothing under any state, declares no size on that axis, no margin on that side and a px padding there or none, and is `border-box` wherever a box of its chain declares a size on that axis (`100%` included) **[amended]** (amendment 7), the widget folds with the padding added to the body's own, 1:1 at every width; any other padded holder still refuses ("its holder pads"). Test `test/web/site-elementor-pads.test.ts` "a holder's padding moves onto a body that paints nothing: within 2 px at every width".
- AC12 (proposed): Given a widget whose widget box is a flex or grid item and whose chain holds non-negative margins on one side, the fold writes one margin there: the widget box's own plus the inner margins collapsed as the browser collapses adjoining block margins (CSS 2.1 §8.3.1), 1:1 at every width; negative margins, or margins the browser wouldn't collapse that way, still refuse. Test `test/web/site-elementor-margins.test.ts` "margins on one side inside a flex or grid item fold as the browser adds and collapses them: within 2 px at every width".
- AC13 (proposed): Without the Elementor step every paste (every code fixture, both text modes, both picture modes, section and whole page) is byte-identical to the base's (main `3cfc54ac`, `git merge-base HEAD main`; the pins recorded on `fd1986dc` stand for it: `fd1986dc..3cfc54ac` changes nothing a paste is built from, only the capture, its types and its checks) **[amended]** (amendment 5), and every Figma conversion too (`npm run corpus` no worse, `test/unit/plugin-convert.test.ts` passes). Test `test/unit/site-native-unchanged.test.ts` "without the Elementor step every paste is byte-identical to main's" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC14 (proposed): B-Dry's saved 2026-10-29 page with the Elementor step stays 1:1 at every width its capture read (the existing named test), and its whole page has no part root, only Sections at the top of each part (labelled), and every shown button widget is a Bricks Button but those a button rule names; **[amended]** (amendment 4; the counts to be confirmed with Justin) of its 17 Buttons 15 stand alone and of its 5 linked pictures 4, the boxes kept around exactly button `ef454b9`, button `58a7a74` and theme-site-logo `ba89ea2`, each with its `not folded:` note; run on the saved home served on 127.0.0.1 (never the live site, nor Justin's 2026-11-09 capture, which main refuses since Build 2026-11-09.4), its input named by sha256 below the criteria. Test `test/web/site-native-bdry.test.ts` "B-Dry's page with the Elementor step: Sections at the top, labelled, its buttons Bricks Buttons, within 2 px at every width" (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, optional `F2B_ELEMENTOR_STANDIN`).
- AC15 (proposed) (live): Justin pastes the new whole page (`npm run site … --elementor`, joined as before) into B-Dry staging `/homev2/` (emptied first), Purge All: Bricks' Structure panel lists Sections labelled with their first words (header's, page's and footer's, no "Div, Div, Div"), the hero's and every other button is a Button whose Text field edits its words, the divider a Divider, the logo an Image; at 1440 and 390 the page looks as it did before the job; hovering a button looks as on bdryswi.com. Test: Justin's paste check `<site-native-structure id at merge>` (HANDOFF "End-of-run check list").

No AC changes a Figma design or the plain code route (AC13). AC1, AC2, AC4–AC12 and AC14 are RED on main (no Section
outside a section paste's root, the part roots present, no labels, no Button/Divider/linked Image, the refused folds);
AC3 is RED on main for its label and note (the root is an unlabelled Div); AC13 is a regression pin (green on main by
construction: its hashes are main's).

**[amended]** (amendment 4) The fourteenth criterion's input, as fixer 2 ran it (`~/.cache/sns-f2/scripts/gates-ac-web.sh`, receipt
`fixer-2/gates/ac14-0581852c.log`): `F2B_CODE_PROOF_BDRY=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/inputs/bdry-2026-10-29`
(the saved 2026-10-29 home: `home.html` sha256 `13f8ea27aeceb9764d2177a51424b8e58daaab974f0d8f0173150319028d7f1e`,
`css1.css` `ec14d2af043c8f6b48f612e6f91f9df00a6dcbfe4ef4491c39d6a28f4caddfdb`, `css2.css`
`e08e3dc84fc4bd6a6740d7eeeae5b069ea5a5a94a1a6528afb181fbca178e44e`, `css-urls.txt`
`c58a8d82eabbee80caa61ed07b5075161dbcd30d89b14827cfcbe1a1c76c07b0`), `F2B_CODE_PROOF_CAPTURE=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/planner/capture.json`
(sha256 `47e97124a8a44a850c5f6268139425d94d711b0e962d90f3f7bc93242ee47795`), and
`F2B_ELEMENTOR_STANDIN=/home/justin/.cache/sns-f2/bdry/standin-capture-0581852c.json` (sha256
`b01b4e08051be22de95ea116dce19cee74cbc6d7ff135accbba40cd3cd55e647`: that saved home served on 127.0.0.1 and captured by
the head's own capture, Build 2026-11-09.4, 38 widths, 12 ranges, by `test/web/site-elementor-page-bdry.test.ts` with
`F2B_ELEMENTOR_PAGE_OUT`). The verifier and auditor of one head use that same file (or, without `F2B_ELEMENTOR_STANDIN`,
the test captures the served saved home itself). Justin's re-capture of bdryswi.com replaces it once it exists; the
fifteenth criterion (live) carries the live proof.

## Architecture

Pure, in `src/core/site/` (no `figma.*`, no web classes: `tsconfig.sandbox.json` doesn't cover `src/core/site` today,
but keep to built-ins anyway). Each new rule judges every kept range's full declarations (`statesOnKept`), as the fold
does. The Elementor step's choices stay in `foldElementor` (`elementor-fold.ts`), which returns `TreePick`s; `tree.ts`
builds elements from them; `convert.ts` `prepare` builds each element's class (`specs`); `parts.ts` names classes and
builds the part pastes.

New pieces:
- `TreePick.label?: string` and `TreeNode.label?: string` (`tree.ts`); `payloadOf` writes `label` on the element when
  set (`convert.ts`), as the Figma route does (`emit/payload.ts:41` already keeps `label`). Every job (slider, FAQ,
  menu) may set its own pick's label; the label pass (below) fills only elements without one.
- `TreePick.absorb?: { text: string }` (Button): the body's subtree under it is not emitted (its words become the
  Button's `text`); its descendants' declarations are merged by `elementor-button.ts` before (see Task 8).
- `TreeOptions.lift?: ReadonlySet<string>`: paths whose element isn't emitted; their kept children take their place
  (parent 0 at the top). `prepare` passes it; `t.parent === 0` keeps meaning "a top element" everywhere (`withInherited`,
  the reset and font classes in `payloadOf`).
- `src/core/site/lift.ts`: `liftOf(code, pr, root, sections): { lift: string[] } | { why: string }`: the chain from the
  part's root to its sections' parent (every box with one shown child, then that parent) when every box in it is
  neutral at every kept range (Task 4's table).
- `src/core/site/labels.ts`: `labelOf(t, ctx): string | undefined` (Q5 A).
- `src/core/site/elementor-button.ts`, `src/core/site/elementor-divider.ts`: the widgets' shape, their refusal rules and
  merges, called from `foldElementor`'s widget branch.
- `ClassCss.parts?: Array<[string, Block[]]>` (`classes.ts`): rules of the class under a sub-selector (` > .line` for the
  Divider's line, ` > img` for a linked Image's picture), written after its own blocks; a class without parts is written
  byte for byte as today.

Renderer (tests only, `test/browser/render.ts`, site route only, i.e. when `bricksCss` is given): a Button prints as
Bricks 2.3.9 prints it (`<a|span id class="brxe-button <classes> bricks-button">words</a>`, plus
`bricks-background-<style>` only when `style` is set), a Divider as `<div class="brxe-divider horizontal"><div
class="line"></div></div>` with no inline style when it has no settings. The Figma route's rendering is unchanged.

## Tasks (test-first; commit after each passing task, files by name; never commit CLAUDE.md)

Setup (every task): worktree from `claude -w site-native-structure` or the session's agent copy; `export
PATH=/home/justin/.local/node-v22.23.3/bin:$PATH TMPDIR=/home/justin/.cache/sns-b/tmp
CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; heavy runs under `systemd-run --user --scope -p
MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G). Base tallies (planner, `unit-base.txt`): `node --test "test/unit/**/*.test.ts"`
on `fd1986dc`: 3453 tests, 3384 pass, 0 fail, 69 skipped. Run `npm run corpus` before Task 2 and at the close.

### Task 1: Bricks samples, plan copy, ledger
- Copy this plan to `docs/plans/2026-11-09-site-native-structure.md`; start `.superpowers/sdd/2026-11-09-site-native-structure/progress.md`.
- **Samples (gate for Tasks 7–10, not for wave 1):** `reference/bricks/` holds no Button without a Style and no plain
  Divider. ExampleBricks (Justin's own Bricks 2.3.9 copies) gives the keys: Button `{text, style, icon, link}`, Divider
  `{height, style, color}`, Section/Container/Block, `label`. Until Justin's copies arrive, write a researched stand-in
  `reference/bricks/button-plain.json` + `divider-plain.json` (README entry "researched, replace with Justin's copy"),
  as `nav-nested.json` was made: Bricks' GPL `includes/elements/button.php` and `divider.php` (2.2,
  `gh api repos/saqib6571/bricksbuilder/contents/<path> -H "Accept: application/vnd.github.raw" > <scratch file>`, one
  file per call) for the printed markup and classes with no `style`, no `size`, no icon, compared with darksalmon's live
  Button/Divider (`evidence/site-native-structure/planner/darksalmon/home.html`) and staging's 2.4.2
  `frontend-light-layer.min.css`. Record in the README: whether a Button with no `style` prints any
  `bricks-background-*` class, whether `text` is printed raw or escaped, and the Divider's markup with no settings.
  **Stop condition:** if the source shows Bricks prints a default style class for a Button with no `style` and that
  class is styled outside `@layer bricks`, stop Tasks 7–8 and report (Q6 needs Justin).
- Justin's sample request (main session asks him; not blocking wave 1): in Bricks, add a **Button**, clear **Style**
  (none), set **Link to** any URL, copy it; add a **Divider**, change nothing, copy it. They replace the stand-ins.

### Task 2 (AC1): top-level containers are Sections
- RED: `test/unit/site-native-sections.test.ts`, test "every top-level Elementor container of a part is a Section, its
  boxed inner a Container": `siteParts(elementorCode(), { elementor: true })` (fixture `test/fixtures/site-elementor-code.ts`,
  whose page part holds two parent containers `PATHS.section` and `PATHS.second`); find each element by `sources`;
  assert `PATHS.section` and `PATHS.second` are `section`, `PATHS.inner` `container`, `PATHS.row` and `PATHS.nested`
  `block`, `PATHS.nestedInner` `container`; a container whose site tag is `a` (patch `PATHS.second` tag `a` with an
  href) is a `block`. On main: `block` for both parents (elementor-fold.ts:258).
- GREEN: `elementor-fold.ts` container branch: `const top = e.parent === null && /^(div|section)$/.test(code.nodes[e.path].tag)`;
  `name: top || e.path === root ? "section" : "block"`, role `section`/`block` as today; the inner rule unchanged.
- Update the tests whose expectation the rule changes (list them in the ledger with the line): whole-part shapes that
  expected `block` for a part's top-level container (search `test/unit/site-elementor-*.test.ts`,
  `test/web/site-elementor-*.test.ts` for `"block"` at a parent container). Section pastes are unchanged.

### Task 3 (AC2, AC3 unit): the part's root left out when it draws nothing
- Fixture: `elementorCode` gains an option `over.header` (a `header.elementor.elementor-location-header` part root
  listed in `web.parts` as the header part, holding one full parent container with a heading widget "Call us today"),
  off by default so every existing test is unchanged.
- RED: two tests in `site-native-sections.test.ts`:
  - "a part's root that draws nothing is left out: its sections are the paste's top elements": `siteParts` of the
    fixture with the step; the page paste's top elements (parent 0) are exactly the two sections, in order; no element's
    `sources` path is the page root; each top element's `_cssGlobalClasses` starts with the reset class id; the page
    root's inherited `font-family` (patch the root's `inherited` with a family) reaches each section's class (its
    `_typography.font-family` or custom CSS, as `withInherited` writes it today for the root); the page root patched
    with Elementor's clearfix `::before` (`pseudo.before: { content: '""', display: "table", clear: "both" }`) is left
    out too; the header part (fixture option below) is left out the same way.
  - "a part's root that draws or lays out stays one Block labelled with its part": patch the page root in turn with
    `padding-top: 20px`, `row-gap: 10px` + `display: flex`, `background-color: #eee`, `position: relative`, a
    `::before` with `content: "x"`, and the clearfix `::before` while the first section has `margin-top: 8px`:
    each time the root is the one top element, name `block`, `label` "Page", and the notes hold `the page's root
    stays: it pads (padding-top)` (resp. `lays out (row-gap)`, `paints (background-color)`, `positions (position:
    relative)`, `draws a ::before`, `its ::before keeps its first section's margin-top`).
- GREEN: `src/core/site/lift.ts` (new, ≤ 120 lines): `liftOf(code, pr, root, sections)`. Neutral at every kept range
  (`statesOnKept`): `box-sizing` any; `display` unset/`block`/`flow-root` absent → `block`, else "lays out (display)";
  `margin-*`, `padding-*` zero ("pads"), `border-*-style` none or width zero ("paints"), the PAINT table of
  `elementor-fold.ts` (export it) ("paints"/"clips"), `position` static/unset ("positions"), sizes in `NEUTRAL_SIZE`
  (export) ("sizes"), any `gap`/`row-gap`/`column-gap`/`grid-*`/`flex-*` → "lays out"; inherited properties are
  carried (not judged). Pseudo: `content` `""`/`none` with `display` `table`/`block`/`none` and nothing else but
  `clear`/`box-sizing`, and the adjoining section's `margin-top` (before) / `margin-bottom` (after) zero at every range.
  `prepare(capture, root, opts, pr, skip, lift)` passes `lift` to `buildTree` (`TreeOptions.lift`): a lifted path is
  visited but not emitted; its children get its parent (null → top). `parts.ts`: on the Elementor route only, `liftOf`
  per part with `sectionsOf(capture, part)`; on refusal, the root's pick is `{ name: "block", settings: {}, label:
  Title(part) }` and the note `the <part>'s root stays: <why>`. `baseOf` checks "is a section" before "is the part's
  root" (a top element that is a section takes the section's slug). Plain route: no `liftOf` call (AC13).
- Checkers: the part root is no longer in the paste. `test/web/lib/site-page-check.ts` `checkPage` and
  `tools/site-check.ts` read the paste side from a wrapper the render puts around each part's top elements
  (`renderSitePaste(payload, head, theme, { … wrap: true })` → `<div data-f2b-part>…</div>`, block, no styles), the
  site side from the part root as today: under AC2's rule the root's top-left is its first section's. `PartResult` gains
  `lifted: boolean`. Prove with the existing whole-page tests (`test/web/site-page-proof.test.ts`,
  `test/web/site-elementor-proof.test.ts`) still green.

### Task 4 (AC4): labels
- RED: `test/unit/site-native-labels.test.ts` "every Section, Block and kept widget of the Elementor step's paste has a
  label by its purpose": the fixture's whole page with the step: the first section's label is its first words cut at 5
  words / 40 characters with "…"; a header section's "Header · …"; a section with no words "Section"; the row container
  "Row", a column container "Column", a grid "Grid"; the html widget's box (kept as page code) "HTML"; every element
  named heading/text/image/button/divider/accordion-nested/container has no label; without the step no element has a
  label.
- GREEN: `src/core/site/labels.ts` `labelOf(t, { part, words, entry, role })`; `foldElementor` sets `label` on the
  container picks it makes (Section: computed in `parts.ts` from the section's first words, the same walk as `slugs`;
  Block: `roleOf`'s role capitalised: row→Row, column→Column, grid→Grid, box→Box, photo→Photo, inner→Box) and on each
  kept widget's box (`kept as page code` branch): the widget type with `theme-`/`nested-`/`elementskit-` dropped,
  dashes to spaces, first letter capital, `html`→`HTML`. `payloadOf` writes `label` when set.

### Task 5 (AC5): the generic natives fixture, wave-1 proof in Chrome
- Fixture `test/fixtures/web/sites/elementor-natives/` (`index.html`, `style.css`; not a copy of any site): Elementor
  markers as `elementor-pbox` writes them (`elementor-element`, `data-id`, `data-element_type`, `data-widget_type`).
  `body > header.elementor.elementor-1.elementor-location-header` (clearfix `::before`) holding one full parent container
  (row: a linked logo image widget, a heading widget, a button widget); `main > div.elementor.elementor-2` holding three
  parent containers: (1) boxed: heading (holder `padding: 10px 0 0 0`), text editor (one `p`), a row container of two
  button widgets (words only; svg icon left), a divider widget; (2) full grid of three image widgets; (3) boxed: heading
  inside a flex-item widget box with `margin-bottom: 20px` on the box and `margin-bottom: 10px` on the `h2`, an unlinked
  button, a button with an svg icon right; `body > footer.elementor.elementor-3.elementor-location-footer` (clearfix)
  holding a boxed container with a text editor and an icon-list widget. Elementor's real CSS rules for these classes
  (button: `.elementor-button{display:inline-block;line-height:1;…}`, `.elementor-button-content-wrapper{display:flex;
  flex-direction:row;justify-content:center;gap:…}`, `.elementor-button-text{display:inline-block}`; divider:
  `.elementor-divider{display:flex;padding-block:15px}`, `.elementor-divider-separator{display:flex;width:100%;
  border-block-start:2px solid #ccc}`), three breakpoints (1025-up, 768-1024, 0-767) changing paddings and font sizes,
  hover looks on the buttons (`background`, `color`, `transform: scale(1.1)` with `transition`).
- RED: `test/web/site-native-structure.test.ts` "the natives fixture with the Elementor step: Sections at the top, within
  2 px at every width": capture the fixture (`captureFixture("elementor-natives", …)`), server closed, `siteParts(cap, {
  elementor: true })`; each part's top elements are all `section` (header 1, page 3, footer 1); measured as
  `site-elementor-pbox.test.ts` measures, through `checkPage` (with Task 3's wrapper), worst ≤ 2 px at every width, words
  and pictures included. On main: the top elements are Divs (fails the shape assertion first).
- Commit wave 1 here (AC1–AC5 green, `npm run check` green).

### Task 6: wave-1 B-Dry receipt (no bar)
- Run the existing named `test/web/site-elementor-page-bdry.test.ts` with `F2B_CODE_PROOF_BDRY`,
  `F2B_CODE_PROOF_CAPTURE` (and `F2B_ELEMENTOR_STANDIN` if a stand-in is saved) on the wave-1 head: still within 2 px.
  Record `hist.mjs` counts of the new `npm run site … --elementor` output of
  `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` in the ledger (sections, divs, labels, depth).

### Task 7: renderer prints Button and Divider as Bricks does (site route)
- RED: `test/browser/render-site-natives.test.ts` "on the site route a Button prints Bricks' bricks-button and a Divider
  its bare line": `renderSitePaste` of a two-element paste (a linked Button with no style, a Divider with no settings):
  the `a` has classes `brxe-button … bricks-button` and no `bricks-background-*`, the words as its text; the Divider is
  `div.brxe-divider.horizontal > div.line` with no `style` attribute. On main the Divider's `.line` has an inline
  `border-top` (render.ts:225-228) and the Button lacks `bricks-button`.
- GREEN: `test/browser/render.ts` `node()`: when the render is the site route (thread `site` already passed to `body`),
  add `bricks-button` (and `bricks-background-<style>` when `s.style`) to a Button's classes; for a Divider with no
  `height`/`style`/`color`, print `<div class="line"></div>` and add `horizontal`. Figma renders byte-identical (the
  existing render tests).

### Task 8 (AC6, AC8): the Button
- RED: `test/unit/site-elementor-button.test.ts`, extend `test/fixtures/site-elementor-code.ts` with button widgets
  (`PATHS.buttons`: words only; svg icon left; svg icon right; unlinked; words with `color`; words holding `<strong>`;
  content wrapper `justify-content: flex-start` under an `a` with `text-align: center`; a font icon `<i>`):
  - "an Elementor button widget is one Bricks Button with its words and link": the first is one element `button`,
    `settings.text` "Get a quote", `settings.link` `{ type: "external", url }`, no `style`, no child; its class's custom
    CSS holds the `a`'s background, padding, radius, `display: inline-block`, line-height and its hover state; the
    icon-left one's class holds `::before { content: ""; … -webkit-mask: url("data:image/svg+xml,…") center / contain
    no-repeat; mask: …; background-color: currentColor; width/height as the svg; margin as the wrapper's gap }`, the
    `a` takes the content wrapper's `display: inline-flex` (from `inline-block`), `align-items`, `gap`; the unlinked one
    no `link`; the notes no longer hold `kept as page code: button …` for them.
  - "a button whose words have a look of their own, hold an element or draw a font icon keeps its elements, named":
    the four refusals keep today's elements and the notes hold `not a Button: button <id>: its words have a look of their
    own (color)`, `…: its words hold an element (strong)`, `…: its words are placed by its content box (justify-content:
    flex-start)`, `…: its icon is a font glyph`.
- GREEN: `src/core/site/elementor-button.ts` (new): `buttonShape(code, pr, e)` → `{ chain, a, content, words, icon? }` by
  Elementor's framework classes (`elementor-button`, `elementor-button-content-wrapper`, `elementor-button-text`,
  `elementor-button-icon`) read through `markersOf`; rules (every kept range): the chain widget box → `a` passes
  `foldable` (export it); the content wrapper and words declare only `display`, `flex-direction`, `justify-content`,
  `align-items`, `gap`/`row-gap`/`column-gap`, `flex-grow`, `flex-shrink`, `order`, `align-self`, `box-sizing` and
  neutral paint (`background-image: none`, transparent); the words are one `words` node whose html has no element;
  `justify-content` (`center`/`flex-start`/`start`/`normal`/`flex-end`/`end`) agrees with the `a`'s `text-align`
  (`center`/`left`/`start`/`right`/`end`), or the `a` is `display: inline-block`/`inline-flex` with no width declared
  (its content box is its words' width); an icon is one `svg` whose fill is `currentColor` or equals the `a`'s `color` at
  every range and state, else "its icon has a colour of its own". Merge: `merge(code, chain)` for the wrappers into the
  `a` (unchanged), then with an icon the content wrapper's flex declarations onto the `a` (`display: inline-block` →
  `inline-flex`, `block` → `flex`), and the icon's box (width, height, margins, `order` → before/after) into
  `pseudo.before|after` of the `a` node: `{ content: '""', display: "block", width, height, "flex-shrink": "0",
  "-webkit-mask": url(…) …, mask: …, "background-color": "currentColor" }` (svg markup URL-encoded as
  `emit/button-icons.ts` does). Pick: `{ name: "button", settings: { text, ...link }, role: "button", absorb: true }`;
  `tree.ts` skips the absorbed subtree. **Stop condition:** if the icon variant isn't within 2 px on the fixture after
  one honest attempt (inline-flex vs inline-block baseline), drop icons from this job (`its icon keeps its elements`
  note), record it in follow-ups, and continue with words-only buttons.
- Text encoding: as the Figma route writes a Button's `text` (the style stage's escaped words), confirmed against the
  Task 1 research (raw or escaped).

### Task 9 (AC7): buttons 1:1 in Chrome, hover included
- RED: `test/web/site-elementor-button.test.ts` "buttons as Bricks Buttons: within 2 px at every width, hover as on the
  site": the natives fixture captured; each button widget is one `button` element; boxes and words within 2 px at every
  width; for each button, `page.hover` on the site and on the paste (as `test/web/site-motion-proof.test.ts` drives
  states) after the transition ends: the button's box (transform included) and computed `background-image`,
  `background-color`, `color` equal (boxes within 2 px). On main: no `button` element.

### Task 10 (AC9): the Divider
- RED: `test/unit/site-elementor-divider.test.ts` "an Elementor divider widget is one Bricks Divider whose line is the
  separator" (one `divider` element, no child; its class's custom CSS holds the merged `elementor-divider` box and
  `.<class> > .line { … }` with the separator's declarations; a divider whose separator holds text or an icon (Elementor's
  `elementor-divider__text`) keeps its elements, `not a Divider: divider <id>: its line holds words`), then
  `test/web/site-elementor-divider.test.ts` "a divider widget is one Bricks Divider: within 2 px at every width" on the
  natives fixture (the separator's box measured against the paste's `.line`: `sources` maps the separator's path to the
  Divider's id with a `> .line` locator).
- GREEN: `src/core/site/elementor-divider.ts`; `ClassCss.parts` (`classes.ts`, written after the own blocks as
  `.<name> > .line { … }` per block, `customCss` unchanged when `parts` is absent); `prepare` fills `parts` from the
  separator's states.

### Task 11 (AC10): linked pictures
- RED: `test/web/site-elementor-linked-image.test.ts` "a linked picture is one Image with Link to: within 2 px at every
  width" (the fixture's header logo: one `image` element with `link`, no tag; boxes within 2 px; hovering the logo shows
  the site's look) plus a unit case in `test/unit/site-elementor-fold.test.ts` "a linked picture folds into one Image
  with Link to; its img's own look on > img".
- GREEN: `elementor-fold.ts` `BODIES.image`: a chain whose last box above the `img` is an `a` with an href no longer
  refuses: the chain's wrappers through the `a` merge into the `a` (the Image's class), the `img`'s own declarations go
  to `ClassCss.parts` under ` > img` (Bricks prints the linked Image's id and classes on the `a`, render.ts:190-193); the
  pick carries the link (`siteLink`). An `a` that paints differently from its `img` box under a state other than hover
  colour keeps its elements (named).

### Task 12 (AC11): a holder's padding moves onto a paintless body
- RED: `test/unit/site-elementor-fold.test.ts` "a holder's padding folds only onto a body that paints nothing, sizes
  nothing on that axis and has no margin there" (fold with `padding-top: 10px` holder; refusals for a body with a
  background, a `width` with horizontal padding, a `margin-top` with top padding, a `%` or `em` padding: each named
  "its holder pads (padding-…)" as today), then `test/web/site-elementor-pads.test.ts` "a holder's padding moves onto a
  body that paints nothing: within 2 px at every width" on the natives fixture.
- GREEN: in `foldable` (`elementor-fold.ts:131`, the PAINT loop), a wrapper's `padding-<side>` in px passes when
  the body (last box) paints nothing at any range or state (PAINT table, borders, outline, `states`), declares no size
  on that axis (`AXIS`), has no non-zero margin on that side, and isn't inline-level; `merge` adds the wrappers' px
  paddings to the body's own per side (logical `padding-block-start` etc. mapped to physical as the capture writes
  them; both forms summed once).

### Task 13 (AC12): margins inside a flex or grid item
- RED: `test/unit/site-elementor-fold.test.ts` "margins on one side inside a flex or grid item fold to the widget box's
  plus the collapsed inner margins" (widget box `margin-bottom: 20px` in a flex column, `h2` `margin-bottom: 10px` →
  merged `margin-bottom: 30px`; holder `margin-top: 8px` + `h2` `margin-top: 12px` (holder block, no padding/border on
  top) → 12px inside, plus the box's own; refusals: a negative margin, a holder with `display: flex` (no collapse),
  a parent that isn't flex/grid at a range: "two margins on one side" as today), then `test/web/site-elementor-margins.test.ts`
  "margins on one side inside a flex or grid item fold as the browser adds and collapses them: within 2 px at every
  width" on the natives fixture.
- GREEN: replace the "two margins on one side" refusal (`elementor-fold.ts:163`) by a `marginsOf(chain, st, r,
  side)` in a new `src/core/site/elementor-margins.ts`: the widget box's parent is flex/grid at that range (else the
  old refusal), all margins ≥ 0, inner adjoining margins collapse (max) only between block boxes with no padding/border
  on that side, no `overflow` other than visible, not flex/grid themselves, and (bottom) `height` auto; the result is
  the widget box's own + the collapsed inner value; `merge` writes that value. Rule 8 (elementor-phone-fit) and rule 6
  keep their refusals first.

### Task 14 (AC13): the plain route and Figma untouched
- `test/unit/site-native-unchanged.test.ts` "without the Elementor step every paste is byte-identical to main's",
  skipped unless `F2B_PIN_BASE=1`: SHA-256 of `JSON.stringify` of `siteParts` and `siteToBricks` (every section) of
  `pageCode()`, `elementorCode()` (step off), the `test/fixtures/site-motion-*` code fixtures if present, in rich/basic
  and data/address, recorded by running the same function on `fd1986dc` (a `git archive fd1986dc` scratch tree, full,
  with `corpus/files` and `reference`). `npm run corpus` (no worse than base) and `test/unit/plugin-convert.test.ts`.

### Task 15 (AC14): B-Dry named
- `test/web/site-native-bdry.test.ts` "B-Dry's page with the Elementor step: Sections at the top, labelled, its buttons
  Bricks Buttons, within 2 px at every width": reuse `site-elementor-page-bdry.test.ts`'s setup (stand-in served on
  127.0.0.1, `buildStandIn`, `checkPage`); assert each part's top elements are labelled Sections (no part root), every
  shown `button` widget is a `button` element unless the notes name it under `not a Button:`, and every row ≤ 2 px.
  Also run `site-elementor-page-bdry.test.ts` (must stay green). Record the per-part counts (`hist.mjs`) for the
  2026-11-09 capture in the ledger and HANDOFF.

### Task 16: records
- HANDOFF section "The importer's paste in Bricks' own elements (site-native-structure, website importer; paste check
  <id at merge> owed)": what changed in plain words, the ⭐ rulings (not yet confirmed), the rules and their notes, the
  B-Dry counts before/after, follow-ups, and Justin's AC15 steps in the end-of-run check list: `npm run site --
  <capture> <out> --elementor`, join the three files as before, paste into emptied `/homev2/`, Purge All, open
  Structure (Sections with names), click a button and edit its Text, compare 1440 and 390 with bdryswi.com, hover the
  buttons. Ledger moved at the finish.

## Overlaps with the other five jobs (files, rules, merge order)

| job | its files | overlap with this job | how to build side by side |
|---|---|---|---|
| staging-fit A (capture) | `src/web/*`, new `src/core/site/styled-ranges.ts`, `tools/site*.ts` refusal | `tools/site-check.ts` (Task 3's wrapper) | small textual conflict only; independent |
| staging-fit B (no `revert`) | `src/core/site/blocks.ts`, maybe `classes.ts` | `classes.ts` (`ClassCss.parts`, Task 10) | `parts` rules use `blocksOfStates` like the own blocks: they follow job B's bounded blocks automatically |
| staging-fit C (renderer) | `test/browser/render*.ts`, `test/web/lib/site-check.ts`, `reference/bricks/` 2.4.2 | Task 3 (render wrapper), Task 7 (Button/Divider printing) | merge after C if it lands first; C's `.cls.brxe-<element>` printing must cover `button`, `divider`, `section` (tell its builder) |
| site-faq | `elementor-accordion.ts`, `elementor-fold.ts` accordion branch | `foldElementor` loop (Section/label/button branches added beside) | no rule conflict; accordion elements get no label (Bricks names them); its picks may set `label` |
| site-slider | new n-carousel branch in `foldElementor`, slides as Blocks, Slider (Nestable) | the hero section is a top-level container → Section (this job); its carousel inside; slide containers are nested → Blocks either way | the slider's picks win over the label pass; a slide's buttons become Buttons when this job is in (slide copies share classes by scope, as accordion items do) |
| site-menu | header part: the ☰ icon widget → Toggle/Offcanvas (Nav) | the header root is lifted (Q3 A): the Offcanvas lands as a top element of the header paste, a sibling of its Sections; the icon widget is not touched by this job (Q7 A) | the menu job must not assume a header root element; with this job off it still has one |
| site-reviews | html widget (Trustindex) → embed | the html widget's box is labelled "HTML" when kept as page code | its pick's label wins |

Either way the others merge first or after: they emit inside Sections (this job) or inside the part root's Block/Div
(without it). A job that adds a widget branch to `foldElementor` should set `label` on its pick (or leave it to Bricks'
name for a native). Merge order ⭐: staging-fit A, staging-fit C, this job, then site-faq/site-slider/site-menu/
site-reviews in any order (each rebases onto `foldElementor`'s new branches; HANDOFF sections both kept).

## Risks

- **Theme Styles on other sites:** a Bricks Theme Style that prints unlayered `.brxe-section`/`.bricks-button` rules
  at higher specificity than `site-reset` (0,1,0) would show (staging has none). The paste check names it.
- **Bricks Button internals:** a Bricks version that wraps the Button's words in a span or adds `bricks-background-*`
  without a style would change the words' box (Task 1 research; AC15 live).
- **Lifted roots and Bricks' header template:** `#brx-header.brx-sticky>.brxe-section{transition:inherit}` and
  left/right header layouts' `height:100%` apply to top-level Sections (not to today's Div root); harmless for top headers.
- **Class names move:** the Elementor route's names are fingerprints of their rules; lifted sections now carry the
  inherited text settings and a Button/Divider class carries merged rules, so many names change once (Bricks' Import
  classes never fires: names are new).
- **Counts change in older tests:** the step's "N as Bricks elements" notes and shapes in elementor-map/footer-fit/
  phone-fit tests; each change listed in the ledger with the rule that caused it.

## Follow-ups (not this job)

The plain code route's structure (Q2 B); Bricks Icon for Font Awesome icons (Q7 B); flip-box → the plugin's flip cards;
icon-list → Bricks list/Icon boxes; spacer widget → nothing; animated headline; a several-block text editor as one Rich
Text; `npm run site --whole` writing the joined whole-page file (memory "importer-whole-page-paste").

## Completion contract

Builder: wave 1 (Tasks 1–6) committed and green (`npm run check`, the new tests, the existing whole-page web tests), then
wave 2 (Tasks 7–15), Task 16 records; stops at `ready-for-review` with the ledger, the B-Dry receipt and one screenshot
per AC (Structure-like dumps for unit ACs: the paste's tree printed by `hist.mjs`). `skill_lessons` in the report.
