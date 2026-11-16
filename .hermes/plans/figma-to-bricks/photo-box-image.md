# photo-box-image: a box that only shows a background photo pastes as a Bricks Image (website importer)

Mini pipeline. Planner: Fable 5.2 high, 2026-11-16. Base: `main` = `1d9a1f63` (Build 2026-11-15.7 plus the importer
app's GRO look). The builder copies this file to `docs/plans/2026-11-16-photo-box-image.md`.
Evidence (probe scripts, logs, two shots): `~/.hermes/plans/figma-to-bricks/evidence/photo-box-image/planner/`.

## Questions for Justin (the standing auto-go takes the ⭐ answers)

- **Q1. The map box stays a Block.** On phones bdryswi.com draws the map 383 px wide inside a taller box
  (`background-size: 383px auto`). A Bricks Image has no setting that draws a picture at a set size inside a bigger box,
  so the map can't be an Image and still look the same.
  - **A ⭐** It stays a Block with its photo in Background → Image (as today), and the notes say why.
  - B A later job makes such a box a Block holding an Image (one more level in Structure, same look).
- **Q2. Without uploaded pictures** (a plain `npm run site`, a dry run): the photo is still on the old site.
  - **A ⭐** Nothing changes there: the box stays a Block with its CSS background, byte for byte as today. It becomes an
    Image once the pictures are in the media library (`site:import`, `site:upload`, the importer app's upload, `--media`).
  - B An Image pointing at the old site's address.
- **Q3. The Image's HTML tag is `figure`** (Bricks' own setting, as on your staff card's photo). The figure is the old
  box, with its size and padding; the picture fills it. A bare `img` measured 5 px off beside the text in Chrome (a
  1000 px row: 500 px against the site's 505.05 px), because the box's padding has to go.
  - **A ⭐** `figure`: exact.
  - B Bare `img`, only for boxes with no padding (the truck's box has 10 px, so the truck would stay a Block).
- **Q4. The picture reaches over the box's padding**, as the site's background did. The class's custom CSS holds that
  (the picture's margins are minus the padding).
  - **A ⭐** Keep it: the look is exact.
  - B Drop the padding from such boxes (cleaner class; the box can move a few px in a row).

## Playback

1. Justin ran the importer app on B-Dry's home (Elementor, pictures uploaded to B-Dry staging).
2. The truck photo beside "Why BDry Works" pasted as a Block labelled "Photo" (`ouvvtq` in `page.json`), its photo
   (media 239) in its class's Background → Image. He selected the element and saw no media.
3. He wants: a box whose only content is a background photo pastes as a Bricks Image, the photo in Content → Image from
   the media library (so it shows as Media and takes the library's alt text), drawn the same.
4. The same shape: the map (`nejpid`, media 222) and the ☰ drawer's photo (`vhfbkb` in `header.json`, media 216).

## What main does today (evidence)

- Main remakes Justin's three pastes and notes byte for byte from his saved scan, offline:
  `node tools/site.ts <capture> <out> --elementor --media media.json --forms forms.json` (`cmp` equal on
  `header.json`, `page.json`, `footer.json`, `notes.txt`).
- The Elementor step picks every container as a Block (`src/core/site/elementor-fold.ts:407`,
  `{ name: "block", settings: {}, role: "block", label: … }`); the plain route makes every box a Block
  (`src/core/site/kinds.ts:94`). An empty box with a background picture is only labelled "Photo"
  (`src/core/site/natives.ts:72`, `src/core/site/classes.ts:110` role `photo`).
- media-clickable puts its library photo in the class's Background → Image (`src/core/site/background.ts:71`
  `backgroundControl`, called from `src/core/site/class-source.ts:37`). No step makes an Image of a box.
- B-Dry's scan (both the newest and media-clickable's saved run) holds 26 library backgrounds as settings; 3 of them sit
  on a box with nothing inside (`evidence/…/planner/bdry-count-base.txt`): the truck, the map, the drawer's photo. The
  other 23 are boxes that hold content (sections, cards): they stay as they are.
- **The Figma plugin already does this.** With "Pictures go: to WordPress" a layer that is only a picture is an Image
  element: 83, 31 and 71 Images and no empty photo Block in GRO, Hydraulic Cylinder Repairs and brainstorm
  (`evidence/…/planner/plugin-photos.txt`). With pictures inside the JSON it is a Div by Justin's own decision (Bricks
  drops picture data from an Image). **The plugin is not changed.**

## The rule (general; read from the capture's structure and declared CSS, never a site's names)

New pure module `src/core/site/photo-box.ts`; one call in `src/core/site/convert.ts` `prepare`, right after
`linkedPictures` (the native step, before `listAccordions` and rule N's `foldBoxes`, which keeps every pick), on both
routes and inside an opened box. The element is chosen before the tree is built (a `TreePick`), so no element changes
type after it is made.

**R1. A box is a photo box when all of these hold:**
1. A media map is given (`opts.media`), the native step is on, and the new switch is on (`ConvertOptions.photoBoxes`,
   on unless `false`: a test and diagnosis switch no command line sets).
2. It is a `div` box with no children in the capture, no words, shown at some width.
3. No other step chose it, except a plain Block pick (name `block`, empty settings, no absorb, parts, items, rest,
   hidden or noOwn: the Elementor step's container). Never a Section or Container, a part's root, an opened box's root or
   entrance element, an opener or closer, a live widget's slot, a pasted-hidden or left-out element.
4. Its own background, at every kept range it shows in, is one photo the media map holds, the same photo at all of
   them: `boxBackground` (media-clickable's own reader, the states' addresses first mapped with `toLibrary`) answers
   settings holding exactly one image. So a gradient, several layers, a `background` shorthand, a photo outside the
   library, no photo at a width, another photo at a narrower width, or a density `image-set` at its own size stay, each
   with media-clickable's reason (`WHY`).
5. Its size at each of those ranges is `cover`, `contain`, `auto` (or none) or `100% 100%`.
6. Its position is one keyword, length or percentage for x and one for y (none: `0%`).
7. `background-repeat` is `no-repeat`, or the size is `cover` with x and y each a keyword or a percentage (no gap can show).
8. `background-attachment`, `-origin`, `-clip` and `-blend-mode` are absent or their defaults.
9. It has no `::before` or `::after` in the capture, no state look that names a `background` property, and no named
   animation whose keyframes write one (an entrance such as a fade passes and plays as on any element).
10. Each padding side is absent, `0`, or a length in px, em or rem (no `%`, no `calc()`).
11. It draws no border, or a solid one with every corner radius `0` at that range (a border with round corners leaves
    a hairline at the corners: `probe-figure-smooth-picture.txt` C7).
12. Its `display` at each range is absent, `block`, `flex`, `grid`, `flow-root`, `inline-block`, `inline-flex`,
    `inline-grid` or `none`; its `writing-mode` is absent or `horizontal-tb`.

**R2. The element.** One Bricks Image: `{ image: { id, filename, size: "full", full, url }, tag: "figure" }` (the
library item, as `media.ts` `imageSettings` writes an img's; `tag: "figure"` as `reference/bricks/staff-card.json` and
`src/core/emit/elements.ts:189`). No `altText` (Bricks shows the library's alt), no link, no label (Bricks' own
"Image"). Pick: `{ name: "image", settings, bare: true, role: "photo", parts: [[" > img", <R4>]] }`, so its class is
`<page>__<section>__photo-<4>`. Bricks prints `<figure id class="brxe-image tag …"><img></figure>` (README "An Image as
a figure"; `test/browser/render.ts:296`).

**R3. The figure keeps the box's own declarations** (width, height, min-height, padding, margins, position, flex item
values, colour, radius, shadow, transitions, its `display: none` at a width), per range, with these changes (the step
returns the node with `decls` re-encoded, as `plain-natives.ts:220` does with `encode`):
- gone: `background-image`, `-size`, `-position` (`-x`, `-y`), `-repeat`, `-attachment`, `-origin`, `-clip`;
  `background-color` stays;
- `display`: `block`, `flex`, `grid`, `flow-root` or none → `grid`; the inline ones → `inline-grid`; `none` stays;
- gone (they lay out children it never had): `flex-direction`, `flex-wrap`, `flex-flow`, `justify-content`,
  `justify-items`, `align-items`, `align-content`, `place-items`, `place-content`, `gap`, `row-gap`, `column-gap`,
  `grid-template*`, `grid-auto*`; added: `grid-template-columns: minmax(0, 1fr)`, `grid-template-rows: minmax(0, 1fr)`;
- `height: auto` where it declares no height (Bricks' own `.brxe-image.tag { height: fit-content }` stops a row's stretch);
- each margin side `0` where the site sets neither its logical nor its physical name (a figure's own browser margin is
  `1em 40px`; the pattern of `kinds.ts` `tagLook`);
- `overflow: clip` in place of the site's overflow at ranges where a corner radius isn't `0`;
- `object-fit` here (so it becomes Bricks' Object fit setting, `controls-more.ts:29`; Bricks prints it on the img)
  only when it is one value at every range.

**R4. The img's rules** (the class's part ` > img`, custom CSS, per range): `display: block; contain: size;
width: auto; height: auto; min-width: 0; min-height: 0; max-width: none; max-height: none; place-self: stretch;
padding: 0; border: 0; border-radius: 0`, each margin side minus the figure's padding on that side (same side name),
`object-position: <x> <y>` (always written: a background starts at `0% 0%`, an img at the centre), and `object-fit`
(`cover`, `contain`, `none` for `auto`, `fill` for `100% 100%`) where R3 didn't take it. `contain: size` makes the
picture add nothing to the box's size, as an empty box; the grid cell stretches it over the padding box.

**R5. Notes** (each once per part):
- `N background photo(s) are Bricks Images (<files>): the box held nothing but its photo; the photo is in the Image's
  Content → Image, from the media library, and shows the library's alt text (clear the alt in Media where a photo is
  only decoration)`;
- for every `div` box with no children and a library photo the rule leaves:
  `the background photo of <path> (<file>) stays in its box's Background → Image setting, the box a Block: <why>`
  (the first failing point of R1.4 to R1.12, in plain words, e.g. "its photo is drawn 383px auto from 767px down: an
  Image has no setting for that size").
- media-clickable's count line counts only the backgrounds still settings.

**R6.** The photo is still listed as a picture the paste shows (`PictureUse`, the same address, path and `via: "css"`
as today), so `site:upload` and `site:import` list and upload exactly what they did.
**R7.** A photo Image carries its own class only: no shared look class and no copy (`cands` empty for it in `prepare`):
its padding and its picture's margins belong together.
**R8. Alt and names.** The site's own `aria-label`, `role`, `aria-hidden`, `title`… on the box stay as `names.ts`
writes them for an element without a link (custom attributes on the figure); an `aria-hidden` box stays hidden. A
background has no alt on the old site, so the Image shows what the library holds (Justin's choice); R5 says how to
keep one decorative.

### How it meets the standard (Bricks-pro, CLAUDE.md "Decisions")
Point 1: Bricks' own Image, not a Block. Point 3: the photo in Content → Image, Object fit in its setting. Point 5:
the picture in the media library, shown as Media, alt from the library. Point 6: exact wins: the figure and the
picture's margins are what keep the box's size; a box the rule can't draw the same stays a Block, named.

### Chrome proof of R3 and R4 (planner, Chrome 156, offline)
`evidence/…/planner/scripts/probe-smooth.ts` draws the site's empty background box and the figure Image in the same
parents, under Bricks' own Image rules (`@layer bricks`, with and without the paste's reset): 17 shapes (a stretching
row with padding, a phone min-height, px offsets over a colour, height 100%, contain, natural size, fill, a border
with radius, padding-only height, aspect-ratio, a grid cell, absolute, auto width, the padding-bottom shape, an
inline-block, a growing column item, a round photo). Every box is equal; the picture is within 8/255 on every pixel
in 16 shapes (`probe-figure-smooth-picture.txt`); the 17th is the border with round corners (R1.11 leaves it). The bare
`img` route fails on padding, grid and absolute boxes (`probe-bare-img.txt`). Not probed: Safari and Firefox (none on
this machine).

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a media map and a `div` box with no children whose own background is one library photo, when the page is converted (plain route, `--elementor` where the Elementor step picked it as a Block, and inside an opened box), then it is one Bricks Image with `settings.image` the library item and `tag: "figure"`, no `altText`, no Background image on it or its class, one class of its own and no shared look, its photo still in the paste's pictures list, and the payload passes `assertPayload`. Test: `test/unit/site-photo-box.test.ts` "AC1 a box that only shows a library photo pastes as a Bricks Image".
- AC2 (proposed): The Image's class is written from the box's own rules as R3 and R4 say, per range: fit from size (cover, contain, auto, 100% 100%), place from position (none: `0% 0%`), one fit at every width as Bricks' Object fit setting, the picture's margins minus the padding, the figure a grid with its dead layout rules gone, `height: auto` and zero margins where the site set none, `overflow: clip` under a radius, the colour kept. Test: `test/unit/site-photo-box.test.ts` "AC2 the photo's fit, place and box are written from the box's own rules".
- AC3 (proposed): In Chrome, with Bricks 2.4.2's and 2.3.9's CSS, a paste with photo Images draws every element's box within 0.5 px of the same paste made with `photoBoxes: false`, and the photo within 16/255 on every pixel (a smooth fixture picture), at every sample width, for each shape of the planner's probe but the border with round corners; where a photo's own edge lies inside its box (a fit or place that doesn't cover the box: contain, a natural size, a px offset), a pixel within one pixel of that edge may differ more, when it matches the other drawing one pixel over (Chrome sizes a background on its box's whole-pixel area, an img on its exact box, so that edge can sit up to a pixel apart). Test: `test/browser/render-site-photo-box.test.ts` "AC3 a photo Image draws as its box did at every width".
  - Amendment (Justin approved, 2026-11-16, "Allow it"): a photo's own edge inside its box may sit up to one pixel apart (fixer 1, `evidence/photo-box-image/fixer-1/amendment-proposed.txt`).
- AC4 (proposed): Every box R1 leaves (a child or words, another tag, a Section, no media map, a photo outside the library, layers or a gradient, another photo at a narrower width, a set size, a tiling repeat, a fixed attachment, a `::before`, a hover photo, a `%` padding, a border with round corners, an inline display) is the same Block with the same classes as with `photoBoxes: false`, and each childless `div` among them with a library photo is named once with its reason. Test: `test/unit/site-photo-box.test.ts` "AC4 a box the rule leaves stays its Block with its Background setting, named".
- AC5 (proposed): The Image writes no `altText`, keeps the site's `aria-label`, `role` and `aria-hidden` as custom attributes, and the part's notes hold R5's Image line naming each file. Test: `test/unit/site-photo-box.test.ts` "AC5 the Image shows the library's alt and keeps the site's names".
- AC6 (proposed): With `photoBoxes: false` every site paste is the base's (`1d9a1f63`) byte for byte, and with it on every paste that holds no photo Image is too: every hand-made capture of the base's pin lists, the saved fixture-site captures and Justin's saved scan, both routes, both text modes, both picture modes, with and without their media maps, whole and each section alone; in a paste that holds one, every element that isn't a photo Image and every class no photo Image carries or carried is the base's. Test (story pin, `F2B_STORY_PINS=1`, `F2B_BASE_TREE`, `F2B_BDRY_CAPTURE`): `test/unit/photo-box-image-site-pins.test.ts` "AC6 every paste without a photo Image is the base's byte for byte".
- AC7 (proposed): On a saved scan with its media map (`F2B_PHOTO_RUN`: a folder holding the capture and `media.json`, read only), with `--elementor`: every `div` box with no children and a library photo is either a photo Image showing the item the map gives its photo, or a Block named in the notes with its reason; the test prints both lists. Test (named-only): `test/unit/site-photo-box-run.test.ts` "AC7 the saved scan: each picture-only box is an Image or named".
- AC8 (proposed): On that saved scan, the page part with photo Images draws every element's box within 0.5 px of the same part made with `photoBoxes: false`, at one sample width of every kept range, with Bricks 2.4.2's and 2.3.9's CSS. Test (named-only, `F2B_PHOTO_RUN`): `test/browser/site-photo-box-run.test.ts` "AC8 the saved scan's photo Images draw where their boxes did".
- AC9 (proposed) (live): Paste check **3ex**, Justin: make the pastes again from his scan (the importer app's "Make pastes again", or `site:import … --elementor`), paste the page on B-Dry staging; in Structure the truck beside "Why BDry Works" is an Image; selecting it shows media 239 (`untitled-design-image.avif`) in Content → Image with its alt text; the section looks as on bdryswi.com at desktop and phone width (on his own phone too); the ☰ drawer's photo is an Image; the map is still a Block, and the notes say why.

Expected on Justin's newest scan (`~/Downloads/bdryswi-com-home/`, for the ledger, not asserted by name in a test):
2 Images (page: the truck, media 239; header: the drawer's photo, media 216), 1 named Block (the map, media 222:
`383px auto` from 767 px down). `home__column-qaty` keeps 8 of its 9 carriers, so no shared look falls under its minimum.

## Tasks (test first, one commit each; `npm run check` green after each)

0. Before Task 1: `npm run check` and `npm run corpus` on the base, tally in the ledger
   (`.superpowers/sdd/2026-11-16-photo-box-image/progress.md`); list every existing test whose fixture holds a childless
   box with a library photo (expected: `test/unit/site-background-control.test.ts`, `site-background-run.test.ts`,
   look-grouping's copy-background tests).
1. Fixture `test/fixtures/site-photo-box-code.ts`: a generic three-section page (ranges straddling Bricks' tiers), one
   box per shape of R1 (each passing shape and each refusal), a media map whose library addresses are `data:` pictures
   (a smooth picture, so Chrome draws them offline), an opened box holding one. Nothing from a real site.
2. RED then GREEN for AC1: `photo-box.ts` `photoBoxes(code, pr, root, { media, taken, skip, openers, … })` →
   `{ picks, nodes, notes, uses }`; the call in `prepare`; `ConvertOptions.photoBoxes`; R6's uses; R7's empty `cands`.
3. The rules for AC2: `photoStates` (R3) and `imgStates` (R4) in `photo-box.ts`. Keep `convert.ts` to the call and the notes (it is
   939 lines: no new logic there).
4. The refusals with their reasons, the notes of R5 and the names (the tests of AC4 and AC5).
5. The browser test of AC3 (through `launchOffline`; the base paste is the same conversion with `photoBoxes: false`).
6. Existing tests (test-only, each listed in the ledger): media-clickable's and look-grouping's fixtures keep proving
   the Background setting on boxes that hold content (give those boxes a child of words; where a byte pin names a
   class, the switch); `site-background-run` accepts "a setting or a photo Image"; `test/unit/site-no-div.test.ts`
   gains the new producer; `test/unit/site-no-revert.test.ts` stays green (remake its golden only if it fails, as
   CLAUDE.md says, and say so).
7. The story pin for AC6 (a `git archive` of `1d9a1f63` with `node_modules` linked) and the named-only tests of AC7
   and AC8, run on Justin's scan copied read-only into the evidence folder; counts and the box differences in the ledger.
   Run browser gates under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`.
8. Docs & records: a HANDOFF section (the rule, the rulings, paste check 3ex, follow-ups), the ledger, `npm run corpus`
   at the close. The finisher adds the Status line, 3ex and one standing rule to CLAUDE.md ("a website box that only
   shows a library photo is a Bricks Image, `src/core/site/photo-box.ts`; a box it leaves is named").

Touched source: `src/core/site/photo-box.ts` (new), `src/core/site/convert.ts`. No tool, panel, plugin or importer-app
change (no new command option). **Mini limit:** if the builder needs to change `controls*.ts`, `looks.ts`, `tree.ts` or
the renderer for more than a missing print of an Image's figure, it stops with `escalate to full`.

## Shared files with paused jobs (none running)

- **fewer-kept-boxes** (`evidence/fewer-kept-boxes/plan-approved.md`): `src/core/site/convert.ts` (`prepare`'s step
  order: the photo step must stay before its fold, which keeps picks), `test/browser/render.ts` (read only here).
- **short-class-names**: `src/core/site/convert.ts`, `classes.ts`, `share.ts`, `tools/lib/site-write.ts`,
  `test/fixtures/site-no-revert-main.json`: the role `photo` on an Image needs its purpose name there.
- **clean-values**: `src/core/site/convert.ts`, `class-source.ts`, `controls-more.ts`, `value.ts`,
  `test/browser/render.ts`: its tidy must leave the picture's negative margins and `minmax(0, 1fr)` as written.
- **link-keeps-name** (a planner brief only): `names.ts` is read here, not changed.

## Rulings (planner; confirm or change)

- A linked box (`a`) that only shows a photo, and any tag but `div`, stays a Block (follow-up: Image with Link to).
- A `%` padding (the padding-bottom ratio box) stays a Block, named (follow-up: an aspect-ratio).
- A photo Image shares no look class (R7).
- The alt is the library's; nothing is written to make it decorative (R8).

## Risks and limits

- Safari and Firefox are not probed here (`contain: size` on an img needs Safari 15.4+); AC9 asks for his phone.
- Bricks may print a media item's caption under an Image whose library item has one (not read in Bricks' code here;
  the uploader writes none). Follow-up: read `image.php`.
- Bricks' editor shows the figure Image through its own builder CSS; the live page is the judge (AC9).
- A pro who changes the class's Padding must change the picture's margins with it (Q4).
- Pasted on a site other than the media map's, Bricks swaps an Image's picture for its grey placeholder (README
  "Paste rules"; as every importer Image today).

## Reporting

Builder stops at `ready-for-review` with: head, the ledger path, the two B-Dry lists (Images, named Blocks), every
existing test it changed and why, rulings it made, `skill_lessons`.
