# bricks-icons: drawn icons become Bricks' Icon element, from the Figma plugin (plan, 2026-11-11; amended 1: the website importer half is the job bricks-icons-site)

Planner: bricks-icons (Fable 5.2, high), 2026-11-11. One of the four structure-parity jobs (audit gap 9:
`~/.hermes/plans/figma-to-bricks/evidence/structure-parity/report.md`).
**Pipeline: Full recommended** (asked as "Mini; escalate if big"): two tools, a new native element, the panel's upload
path and the WordPress uploader. Milestone 1 (the Figma plugin) alone is Mini-sized and can build now.
[amended 1] This plan is now Milestone 1 alone (the Figma plugin). Milestone 2 (the website importer) is the job
**bricks-icons-site**, plan `~/.hermes/plans/figma-to-bricks/bricks-icons-site.md`.
**Base:** M1 on `main` (`02481763`, Build 2026-11-11.3). [amended 1: M2's base line moved to bricks-icons-site.]
Evidence (scripts, outputs, prototype diffs, Bricks' source): `~/.hermes/plans/figma-to-bricks/evidence/bricks-icons/planner/`
(called `<planner>` below; `README.md` there lists every file).
Plan copy for the repo: `docs/plans/2026-11-11-bricks-icons.md` (the builder copies this file there in Task 1's commit).

## Amendments

**Amendment 1 (2026-11-12, after fix round 1 and the clean review 2, before the verifier): Milestone 2 is its own job,
and the plan's prose says the Icon's rules as they are built.** Every changed line or block is tagged `[amended 1]`.
Evidence (`<A>` below): `~/.hermes/plans/figma-to-bricks/evidence/bricks-icons/planner-amend-1/` (`README.md` lists
every file). The text before it: `git show c78fa0cf:docs/plans/2026-11-11-bricks-icons.md` (sha256
`fc7b50c56edff4d1226b9f4f5acd63cdfcffd84798b4def78b9068b0af0356a1`, byte for byte the approved copy), which the main
session keeps beside this file as `plan-approved-v1-before-amendment-1.md` when it installs this one.

Why: `ac-check.sh` accepts a plan only when every one of its criteria is proven on one head. Milestone 1 is built on
`bricks-icons-fix1` (`c78fa0cf`) and reviewed clean twice. Milestone 2 can't start until site-no-div and
site-shared-styles are on `main`. With both in one plan, Milestone 1 could not be accepted or merged before Milestone 2
was built. Q8 ⭐ A ("two milestones", Justin's "go with recommended") stands: the importer half still builds after
those two jobs, on top of this one, now under its own plan and its own acceptance.

What changed:

1. **Moved to bricks-icons-site, unchanged in meaning:** the section "M2: the website importer", the five importer
   criteria (the eighth to the twelfth here, the first to the fifth there, the fifth live), Tasks 11–16, Q4–Q6 and
   Q7's sentence about a site icon, the importer rows of "Blast radius", the importer's clause of the standing rule
   and the one limit that is only the importer's. Each place holds one `[amended 1]` line saying so.
2. **Milestone 1's criteria are byte for byte as approved:** the same seven ids, the same six cited test names, each
   whole on one line, and the same one live criterion (`<A>/regex-receipts.txt`). No criterion's wording changed.
3. **The Icon's two box rules, as fix round 1 built them** (review 1's R1-1 and R1-2; commits `35bd55e3`, `0e7b82b5`):
   the floor is `overflow: clip`, never a fixed `min-width`; the shape is `height: auto` at no weight
   (`:where(#brxe-…)`, typed `Style.weightless`), with no `aspect-ratio`. Both leave the Icon's own Width and Height
   controls in charge. Changed: "What is built" → style, the note under "Proven on a prototype", Tasks 4 and 7,
   "Docs & records", "Risks". The fourth and fifth criteria name boxes and the Width and Height controls, never these
   rules, so their wording holds as approved.
4. **Rules 2–5 of "The rule", as the builder built them** (`model/icon-svg.ts`, `understand/icon.ts` on `c78fa0cf`;
   HANDOFF's section there says the same): each difference refuses more, never less (the Playback's "where that
   can't be proven, the icon stays as it is today"), and the five real files' counts are the plan's own (18, 10, 32,
   16, 7). The second criterion says "exactly when rules 1–5 hold", so the rules it points at are brought to the head;
   its own wording is unchanged.

Receipts that still hold the approved box rules (none proves the fourth or fifth criterion on the head):

- Sorters: `git show <head>:src/core/style/icon.ts | grep -c widthMin` reads 2 up to `dc625574` (the `min-width`
  floor) and 0 from `35bd55e3`; `grep -c 'aspect-ratio: '` on the same file reads 1 up to `35bd55e3` and 0 from
  `0e7b82b5`; `git show <head>:test/browser/icon-elements.test.ts | grep -c 'height alone'` reads 0 up to `dc625574`
  and 1 from `35bd55e3` (the fifth criterion's test, its name unchanged, gained the Width and Height edits there, so
  every older receipt of that name ran a weaker test). `c78fa0cf` differs from `0e7b82b5` only in the ledger and
  HANDOFF (`<A>/regex-receipts.txt`, "heads").
- Old (all made before `35bd55e3`): `../builder/ac4-ac5-green.tap` (Task 7), `../builder/gates/` (its browser runs
  and the `mut-box-*` mutants of the approved two rules), `../builder/shots/ac4-*.png` (pictures drawn under the
  `min-width` floor; the verifier and the auditor take their own), `../fixer-1/ac5-red.log` (the expected red on
  `dc625574`), and the planner's `boxes-*.json`, `scripts/debug-squeeze.ts` and `proto-m1.diff` (the prototype's floor
  and shape; worst 0.41 px). Superseded inside fix round 1: `../fixer-1/ac4-fix.log` and `../fixer-1/mut1/` (where the
  `aspect-ratio` mutant survived, before `0e7b82b5` took the rule out).
- Current: `../fixer-1/ac45-final.log` (`0e7b82b5`: both tests ok, worst 0 px over 108 runs) and `../fixer-1/mut2/`
  (the four mutants of the built rules, each killed).
- Unchanged by the fix round (their cited test files are identical on `dc625574` and `c78fa0cf`; the code under them
  changed in `style/icon.ts`, `style/picture.ts`, `style/types.ts` and `emit/settings.ts` only): the first, second,
  third and sixth criteria's receipts; the verifier runs each again on the head all the same.

## Playback

1. In your own Bricks pages an icon is Bricks' **Icon** element (10 of them in `ExampleBricks`). Today the Figma plugin
   pastes every drawn icon as a picture, and the website importer pastes a site's icon as a Code element.
2. You want both tools to paste icons as Icon elements, so the Structure panel reads "Icon" and you can recolour and
   resize one in Bricks, for every design and every scanned site.
3. Each icon must still look exactly as drawn, at every width. Where that can't be proven, the icon stays as it is today.

## Questions (⭐ = the answer the builder takes under the standing auto-go)

- **Q1. Which Bricks icon.** ⭐ **A: the Icon element showing the drawing as an SVG file from the media library.** It is
  how you build it yourself (your staff card, your card component) and it shows the drawing itself, so it is 1:1.
  B: Bricks' icon fonts (Font Awesome 6, Ionicons, Themify): a drawn icon has no matching glyph, and a site's own icon
  font is another font (B-Dry's glyphs are ElementsKit's), so the look would change. C: Bricks' SVG element with the
  drawing typed in as code: no upload, but it needs "Regenerate code signatures" and `reference/bricks/` has no sample.
- **Q2. When the Figma plugin makes Icons.** ⭐ **A: only with "Pictures go: to WordPress" and "Icons as: SVG".** Bricks'
  Icon reads the SVG file from the media library, so the file must be there. With pictures inside the JSON, or
  "Icons as: PNG", everything pastes as today and the panel says how many icons could be Icons. B: whenever pictures go
  to WordPress, sending those icons as SVG whatever "Icons as" says.
- **Q3. Which drawn icons.** ⭐ **A: an icon of one flat colour** (up to 96 px, all outlines or all fills, no link, no
  typed description, no hover or open/closed state of its own). On your files that is 18 of hydraulics' 45 icon layers,
  16 of Repairs' 28, 7 of Services' 13, 10 of GRO's 13 and 32 of brainstorm's 35 with a drawing
  (`<planner>/count-figma-icons.txt`). The rest stay pictures: two-colour icons, icon badges drawn with their own
  box, blur or mask, linked icons. B: also icons of several colours, with no colour control (a later job: the same
  drawing shown twice can break where it uses gradients or masks).
- [amended 1] **Q4–Q6** (which site icons, where a site icon's look lives, file names in your media library) are the
  importer's: moved with their ⭐ answers, under the same numbers, to bricks-icons-site.
- **Q7. Hover.** ⭐ **A: unchanged.** A Figma icon whose own hover redraws it stays a picture with its hover copy; an
  icon that only follows its card's hover (it fades with it) is an Icon and still follows. B: hover as the Icon's own
  `:hover` colour control: no sample shows Bricks keeps it; later. [amended 1: the sentence on a site icon's hover
  colour moved to bricks-icons-site.]
- **Q8. Order.** ⭐ **A: two milestones.** M1 (Figma plugin) builds now on main. M2 (importer) builds after
  site-no-div and site-shared-styles merge. B: only M1 now, M2 as its own job later. [amended 1: A stands. M2 builds
  in the order A names, as the job bricks-icons-site with its own plan and acceptance.]

## What Bricks' Icon element is (proven, not from memory)

The brief said `reference/bricks/` has no Icon sample. It holds two copies Justin gave, both with Icons:

| Source | What it shows |
|---|---|
| `reference/bricks/staff-card.json` (Bricks 2.3.12, the copy Justin gave on 2026-10-19), element `kejzcv` | `{"name":"icon","children":[],"settings":{"icon":{"library":"svg","svg":{"id":414,"filename":"right-arrow-2.svg","url":"https://…/right-arrow-2.svg"},"height":"26","width":"26"}}}` |
| `reference/bricks/card-row-and-phone-slider.json` (2.3.9, his copy) | the same icon control on a component property, with `"stroke":{"id":"fvnsfn","raw":"var(--amber)","light":"#F4C20D"},"height":"20px","width":"20px"`; icon-font Icons `{"library":"ionicons","icon":"ion-ios-call"}` with `iconSize`, `iconColor` |
| `ExampleBricks` (2.3.9) | 10 Icon elements, all icon fonts (ionicons, themify): `icon`, `iconColor`, `iconSize`, one with `_width`, `_height`, `_padding`, `_background`, `_border` |
| Bricks 2.2 GPL `includes/elements/icon.php` (`<planner>/bricks-2.2/icon.php`) | controls: `icon` (type icon, `root: true`), `iconColor` and `iconSize` (shown only for a font icon), `link`; no children |
| Bricks 2.2 `includes/elements/base.php` L4135-4238 `render_icon` (`<planner>/bricks-2.2/base.php`) | an SVG icon prints only when `icon.svg.id` is set: it reads the media file (`get_attached_file`), refuses a file from another host whose name differs, and prints the file's own `<svg>` with the element's id and classes on its root (`render_svg` L4245-4281: the root's own `id` is dropped; class `fill` / `stroke` added when the control sets one). No id: nothing prints. A font icon prints `<i class="…">` |
| Bricks 2.2 `includes/assets.php` L1783-1786, L2596-2640 | the icon control's `width`, `height`, `strokeWidth`, `stroke`, `fill` print as CSS on the element's root (`#brxe-<id>`); each takes `:<breakpoint>` |
| `reference/bricks/frontend-2.3.9/` and `frontend-2.4.2/frontend-light-layer.min.css` | `svg.fill *{fill:inherit}`, `svg.stroke *{stroke:inherit}`, `svg:not([width]){min-width:1em}`, `svg:not([height]){min-height:1em}`, `img{height:auto;max-width:100%;vertical-align:middle}` |
| Live darksalmon 2.3.9 page CSS saved by site-slider (`evidence/site-slider/planner/bricks-assets/ds-post-68.min.css`) and Bricks 2.2 `icon.min.css` | `.brxe-icon{font-size:60px}svg.brxe-icon{font-size:inherit}` in `@layer bricks`: the same in 2.2 and 2.3.9 |

So the shape is his own; the printing is read from Bricks 2.2's code, whose icon CSS equals 2.3.9's. What only a
live paste can confirm (the `(live)` criteria): that 2.3.9 and 2.4.2 print an SVG Icon as 2.2's code does.

**Why not an icon font:** a Figma icon is any drawing, and B-Dry's font glyphs are ElementsKit's own font (14 `<i>`
glyphs in Justin's scan, `<planner>/site-icons-justin-capture.txt`); Bricks ships Font Awesome 6, Ionicons and Themify.
No glyph can be proven equal, so icon fonts are out of this job (Q1 A, Q4 A).

## M1: the Figma plugin

### The rule (general: structure and paint, never a layer name)

A layer becomes an Icon when all of these hold; otherwise it is the picture it is today.

1. It is a drawing at icon size with Figma's SVG: `src.kind === "vector" && src.icon && src.svg` (`icon` is the
   existing rule, `normalise/normalise.ts:206`: a vector-only layer at most 96 px each way) and its element is `image`.
2. **One flat colour, drawn one way** (`iconDrawing(svg)`, pure, new `src/core/model/icon-svg.ts`): every shape
   (`path`, `rect`, `circle`, `ellipse`, `line`, `polyline`, `polygon`) has the same `fill` and no outline, or the same
   `stroke` and no fill; the colour is `#RRGGBB`, `white` or `black`. Bricks' `svg.fill *{fill:inherit}` gives every
   part the control's colour, so a part with no paint of its own would be painted: such a drawing doesn't qualify.
   [amended 1, as built: a part's paint is its own, else the root's (a fill nobody sets is black, a stroke none); a
   group with a `fill` or `stroke` of its own doesn't qualify.]
3. **Nothing a second copy of it on the page can break:** no `<defs`, `url(#`, `<mask`, `<filter`, `<style`, `<use`,
   `<image`, `<text`, `<foreignObject`, no `opacity`, no `style=`, no `id=`, no `preserveAspectRatio=`. An Icon prints
   the drawing inline, so two copies (a phone copy of a card) share ids, and a reference then resolves into the hidden
   copy. One exception, dropped before the test: **Figma's own frame clip**, exactly
   `<g clip-path="url(#X)">…</g><defs><clipPath id="X"><rect width="W" height="H" fill="white"/></clipPath></defs>`
   with W and H the svg's own width and height (the svg's viewport clips there already).
   [amended 1, as built: a closed list. The drawing holds only its root, groups and the seven shape tags, and nowhere
   a comment or `<?…?>`, an `id=`, `class=`, `style=`, `href=`, `url(`, `opacity=` or `preserveAspectRatio=`; the
   frame clip is dropped only when the svg's viewBox is also `0 0 W H`.]
4. Its root tag starts `<svg `, has `viewBox`, `width` and `height`, and no `id` or `class` (Bricks' `render_svg`
   writes its own at a fixed offset). [amended 1, as built: its `width` and `height` are numbers above 0.]
5. It has no link (`elementLink(n) === null`: Bricks wraps a linked Icon in an unstyled `<a>`, which moves it), no
   typed description or Decorative mark (an inline svg has no alt), and it is not a state picture (`only`), a hover or
   overlay layer, a showcase photo, a video poster, a marquee part or a hotspot. A Button's own icons stay the
   Button's (`buttonIcons`: they are not IR elements). [amended 1, as built: nor a layer whose own hover redraws it
   (Q7 A), one that opens a card, or a stroke that draws itself; and a layer is an Icon in all its copies or in none
   (its file is one asset, so a copy that is refused keeps every copy a picture).]

### What is built

[amended 1] Some names differ on the head (`planIcons` and `iconRefusal` in `understand/icon.ts` for `iconElement`;
`tools/icons-off-golden.ts` for Task 0's script): HANDOFF's section on `c78fa0cf` names every file and test.

- **understand** decides the element once, beside the existing switch (`understand/understand.ts:115`):
  `else if (opts.icons === true) walkIR(sections, (n) => { if (iconElement(n)) n.element = "icon"; })`. Never with
  `inlinePictures` (a picture inside the JSON can't be an Icon). `ElementName` gains `"icon"`; `role` stays `vector`,
  so every adapt rule and recogniser reads the layer as before (they read `role`, never `element === "image"`:
  grep in "Blast radius").
- **style** (`style/picture.ts`, the box in a new `style/icon.ts`): the Icon takes the picture's size, placement and
  paint, **without** `objectFit`, plus the two box rules an `<svg>` root needs that an `<img>` has by itself
  [amended 1: both as fix round 1 built them, so the Icon's own Width and Height controls still size it in Bricks;
  the approved text gave the floor as `widthMin: min(<floor>px, 100%)` for a flow icon and the shape as
  `aspect-ratio: W / H` with `height: auto` in the custom CSS]:
  - the floor: in a row, a browser never squeezes an `<img>` below its own size but does squeeze an `<svg>` (measured:
    GRO's lettering 57.78 → 19.91 px at 1024), because the browser's own `overflow: hidden` makes an svg a scroll
    container, whose floor in a row is 0. The Icon takes `overflow: clip` (Bricks' `_overflow`; a picture's own
    overflow stays): it clips the same and is no scroll container, so the svg keeps an `<img>`'s own floor (the smaller
    of its width and its file's size, never past its room). A smaller Width typed in Bricks shrinks it, and a tier's
    `min-width` still replaces it. Never a fixed `min-width`: it out-weighs any Width typed below it (R1-1);
  - the shape, where nothing sets its height (a row of pictures shrinking together, a captured picture keeping its
    shape): `height: auto` at no weight, `:where(#brxe-<id>) { height: auto; }` in its custom CSS (typed
    `Style.weightless`, written once by `emit/settings.ts`). It beats the file's own `height` attribute, so the svg
    follows its width by its own viewBox as an `<img>` does by its file, and a Height typed in the icon control beats
    it (R1-2). No `aspect-ratio`: it was redundant (without it the box comparison's worst is 0 px, was 0.41).
  `Styled` gains `icon?: { kind: "fill" | "stroke"; color: RGBA }`, and the asset is the icon's markup with the frame
  clip dropped (`AssetList.icon(n, svg, info)`, same key `svg:<id>`).
- **emit** (`emit/icons.ts`, one call in `elements.ts`): `settings.icon = { library: "svg", svg: { __asset: key,
  __icon: true }, [kind]: out.setting(color) }` (a palette reference where the file names the colour), and a plain
  px `_width` / `_height` at the base move into `icon.width` / `icon.height` (as his sample; tiers stay `_width:<bp>`
  on the same root selector, printed after). `fillAssets` turns an `__icon` marker into exactly `{id, filename, url}`.
  `payloadProblems`: an `icon` element has no children and its `icon.library` is `"svg"` with an `svg`.
- **convert / plugin / panel:** `ConvertOptions.icons`; the `convert` message carries `icons`; the panel sends it only
  when `pictures === "wordpress" && wp.connected && iconFormat === "svg"` and never for a website capture
  (`convertCapture` stays as it is). `ResultData.icons = { made, could }` (how many are Icons, how many would be).
  After the uploads, an Icon whose file isn't an SVG in the library (the site refused SVG and the PNG went up, the
  upload failed or stopped) makes the panel convert once more with Icons off (the existing "Converting again…" run,
  `ui/main.ts` `startConvert(…, true)`), so no paste ever holds an Icon without its file. Notes: "N icons are Bricks
  Icon elements (their SVG files are in your media library)"; off: "N icons could be Bricks Icon elements: choose
  Pictures go: to WordPress and Icons as: SVG"; refused: "This site took no SVG files (Bricks → Settings → SVG
  uploads), so N icons stayed pictures".
- **tools:** `npm run replay -- … --icons` and `npm run snap -- … --placeholders --icons` convert with Icons on.
- **renderer** (`test/browser/render-icon.ts`, three lines in `render.ts`): an `icon` element prints as
  `render_icon` does (the file's `<svg>`, root id dropped, `id` and classes, `fill` / `stroke` class first), its
  control as CSS on the root, and Bricks' icon rules (`svg.fill *`, `svg.stroke *`, `.brxe-icon` font size) **only
  when the payload holds an Icon**: `test/unit/render.test.ts` "the whole page matches its golden file" pins
  `BASE_CSS` (it failed on the prototype, which added them there).
- **reference:** `reference/bricks/icon-svg.json` (element `kejzcv` cut from `staff-card.json`, in the clipboard
  format of the other samples) and a README section "Icon" with the table above; "Still wanted" keeps the Button with
  an SVG icon and gains "an Icon with a `:hover` colour".

### Proven on a prototype (`<planner>/proto-m1.diff`, scratch tree of `02481763`, never the repo)

- `<planner>/pixel-figma-icons*.json`: each distinct icon of the five real files drawn as today's `<img>` and as Bricks
  prints an Icon with its colour control: **0 of 255** difference on every icon at a whole-pixel size, with and without
  the frame clip dropped (20 clipped drawings); only GRO's fractional boxes differ, by anti-aliasing (31 of 255 at most).
- `<planner>/boxes-*.json` (`scripts/boxes-figma-icons.ts`): each file converted with Icons off and on, drawn at the
  design width, 1366, 1024, 768, 600 and 390, under the renderer's CSS and under Bricks 2.3.9's real CSS: ids and
  order equal, every other element byte for byte equal, **no box over 0.5 px** (worst 0.41, Repairs at 600).

  | File | Images → | Icons | Worst box difference |
  |---|---|---|---|
  | hydraulics | 92 → 74 | 18 | 0 |
  | GRO | 83 → 73 | 10 | 0.02 |
  | brainstorm | 71 → 39 | 32 | 0 |
  | Repairs (repo root) | 31 → 15 | 16 | 0.41 |
  | Services (`2199895`) | 29 → 22 | 7 | 0 |

  Without the two box rules GRO moved by 77 px and brainstorm by 34 px: they are part of the rule, not polish.
  [amended 1] These numbers are the prototype's, under the approved floor and shape. On the head, under the rules as
  built, the same comparison reads worst 0 px over 108 page, look and width runs
  (`~/.hermes/plans/figma-to-bricks/evidence/bricks-icons/fixer-1/ac45-final.log`), and taking either rule away is
  caught (`fixer-1/mut2/`: no `overflow: clip`, the old floor back, the shape at full weight, no `height: auto`).
- Unit suite: base `02481763` 3698 tests, 3619 pass, 0 fail, 79 skipped (`<planner>/unit-base-02481763.log`);
  prototype 1 fail, the render golden above (`unit-proto-m1.log`). Both typechecks pass on the prototype.

## M2: the website importer

[amended 1] Moved whole (the rule, what is built, what was proven) to `~/.hermes/plans/figma-to-bricks/bricks-icons-site.md`,
the plan of the job bricks-icons-site. Nothing of it is built or accepted under this plan.

## Acceptance criteria (all **proposed**)

Milestone 1, the Figma plugin:

- AC1 (proposed): An Icon the plugin pastes has Justin's sample's shape: `name: "icon"`, no children, and after the
  panel fills it `settings.icon` is exactly `library: "svg"`, `svg: {id, filename, url}`, one of `fill` or `stroke`
  (a colour setting) and, where the size is plain pixels, `width` and `height`; `reference/bricks/icon-svg.json` and
  its README section are in the repo.
  Test: `test/unit/bricks-shapes.test.ts` › "an emitted Icon has the sample's shape: library svg, the media file, its colour and size in the icon control"
- AC2 (proposed): With Icons on, a layer is an Icon exactly when rules 1–5 hold, and every other picture is the
  element it was: the test page holds one layer for each outcome (an outline icon, a filled icon, one with Figma's
  frame clip; and each refusal: two colours, a part with no paint, a gradient or mask, over 96 px, linked, described,
  a state picture, a Button's icon).
  Test: `test/unit/icon-elements.test.ts` › "a plain drawn icon becomes an Icon and every other picture stays as it was, each refusal by its rule"
- AC3 (proposed): With Icons off (every replay, the corpus, pictures inside the JSON, "Icons as: PNG", a website
  capture in the panel) each paste is byte for byte the one main made; with Icons on, a paste differs from the off
  paste only in the Icon elements' own `name` and `settings` (ids, order, classes and every other element equal).
  Test: `test/unit/icons-off-pin.test.ts` › "with Icons off every saved file converts to the bytes main made, and with Icons on only the icons' own elements differ"
- AC4 (proposed): Drawn in Chrome, every Icon sits where its picture sat and no other element moves: each element's
  box within 0.5 px with Icons off and on, at the design width, 1366, 1024, 768, 600 and 390, under the renderer's
  CSS and under Bricks' real front-end CSS 2.3.9 and 2.4.2, on the generic fixture page (a crowded row, a row of
  pictures that shrinks together, a phone copy) and on the repo's real files; on the fixture each icon's pixels are
  equal.
  Test: `test/browser/icon-elements.test.ts` › "Icons draw where and as the pictures did at every tier, under Bricks' own CSS"
- AC5 (proposed): The Icon's colour is its Fill or Stroke control (a palette reference where the file names the
  colour) and its size its Width and Height: with the control's colour changed in the paste, every part of the
  drawing shows the new colour in Chrome, and with its Width and Height changed its box is that size.
  Test: `test/browser/icon-elements.test.ts` › "the Icon's Fill or Stroke control colours the whole drawing and its Width and Height size it"
- AC6 (proposed): The panel asks for Icons only with "Pictures go: to WordPress", a connected site and "Icons as:
  SVG"; each Icon's file goes up as SVG and the paste names it by `id`, `filename` and `url`; when the site takes no
  SVG, or an Icon's file didn't go up, the panel converts once more with Icons off, the paste holds no Icon, and one
  note says why; with Icons not asked for, one note says how many icons could be Icons.
  Test: `test/unit/ui-run-icons.test.ts` › "Icons go up as SVG files; a site that refuses SVG gets the paste without Icons and a note"
- AC7 (proposed) (live): Justin converts a Figma page in the panel with "Pictures go: to WordPress" and "Icons as:
  SVG" and pastes it on darksalmon: the Structure panel shows Icon elements, each looks as in Figma on desktop, tablet
  and phone, and changing one Icon's colour in Bricks recolours it.

[amended 1] Was AC8–AC12 (Milestone 2, the website importer): moved with their tests to
`~/.hermes/plans/figma-to-bricks/bricks-icons-site.md`, where they are its first to fifth criteria (the fifth live).

## Tasks

One commit a task, each green (`npm run check`), test first (`test-driven-development`). Ledger:
`.superpowers/sdd/2026-11-11-bricks-icons/progress.md`, committed with each task.

### M1 (ready now, base `main`)

0. **Before any change:** `npm run corpus` (keep its numbers); record the browser suite by test name on the base
   (`npm run test:browser`, `CHROME_PATH` set); make the pin's sums on the base tree:
   `test/fixtures/icons-off-main.json` = sha256 of `JSON.stringify(convert(file, { inlinePictures }).payload)` for
   `corpus/files/*.json` and the two repo-root debug files, both picture modes (a small script
   `test/fixtures/make-icons-off-main.ts <tree>`, run on a `git archive` of the base, as `site-no-revert-golden.ts`).
   Copy this plan to `docs/plans/2026-11-11-bricks-icons.md`.
1. **The sample.** `reference/bricks/icon-svg.json` + README "Icon" (the table above, the print rules, what is
   unproven: 2.3.9/2.4.2 printing, `:hover`). Test (in `bricks-shapes.test.ts`): the sample parses, is one `icon`
   element with `library: "svg"` and `svg.id/filename/url`. Starts green (a characterisation).
2. **`model/icon-svg.ts`** `iconDrawing(svg)` and `withoutFrameClip(svg)`. Unit tests on `test/fixtures/icons.ts`
   (`ICONS`) plus new fixture drawings for each refusal and Figma's frame clip. RED: the module doesn't exist (an
   import error is the expected red for a new pure helper; its behaviour tests are the ones that count).
3. **understand + IR + convert option** (`understand/icon.ts`, `understand.ts`, `ir.ts`, `convert.ts`) with
   `test/fixtures/icon-elements.ts`: a generic page of three sections (a page of two reads as one) holding each
   outcome of AC2; texts carry no fills; a wrapper with an absolute layer needs its own size. RED on base: the test
   passes `{ icons: true }`, which base ignores, so it fails on "no Icon elements" (an assertion, not an import).
4. **style** (`style/icon.ts`, `picture.ts`, `types.ts`, `model/assets.ts`): the box rules and `Styled.icon`.
   Unit [amended 1, as `test/unit/icon-style.test.ts` holds on `c78fa0cf`]: the floor is `overflow: clip` and never
   a `min-width` (a picture's own overflow stays); `height: auto` at no weight (`Style.weightless`) only with no
   height, and no `aspect-ratio`; no `objectFit`; never `display` in custom CSS (the standing rule).
5. **emit** (`emit/icons.ts`, `elements.ts`, `payload.ts`, `fillAssets`): AC1's test; `payloadProblems` cases;
   add Icons to `test/unit/emit-paste-ids.test.ts`'s walk (no id of another element in its CSS) and to the both-modes
   loops that name `"image"` (`pdf-direct-download.test.ts:90` expects `image` with Icons off: unchanged).
6. **The pin for AC3**, `test/unit/icons-off-pin.test.ts`: the cited test runs only with `F2B_STORY_PINS=1` (a
   story pin: after the merge it would fail the next job that changes pastes on purpose); a second test in the file,
   in the default run, keeps "with Icons on only the icons' own elements differ" on the fixture page.
7. **renderer** (`test/browser/render-icon.ts`, `render.ts`) and **AC4, AC5** `test/browser/icon-elements.test.ts`:
   boxes by id with moving parts held still (`animation: none`: a marquee moves between two reads; the planner's
   first run read 97 "moved" elements that way), real CSS from `reference/bricks/frontend-*`, plus the icon rules.
   Real files: `corpus/files/*.json` and the repo-root debug files, read only. Prove the test can fail: with the two
   box rules removed (`git checkout HEAD~1 -- src/core/style/icon.ts` style), GRO's row must fail it.
   [amended 1: on the head this is fix round 1's mutants, one per built rule, `fixer-1/mut2/`.]
8. **panel + plugin** (`shared/messages.ts`, `plugin/main.ts`, `plugin/convert.ts` `resultOf`, `ui/run.ts`,
   `ui/main.ts`, `ui/settings.ts`): AC6's test with the panel stand-ins (`test/fixtures/panel.ts`, the uploader's fake
   site as `ui-uploader.test.ts`: one that takes SVG, one that refuses it). `plugin-convert.test.ts` (plugin = replay)
   and `sandbox-convert.test.ts` run with `icons: true` too. `Outcome.iconsLost` is the pure signal; `main.ts` only
   calls `startConvert(…, true)` on it, with Icons off for the runs that follow until the user starts a conversion.
9. **tools** `--icons` on replay and snap; `npm run snap -- corpus/files/hydraulics-home.json <out> --placeholders
   --icons --sides` for the before/after pictures (`shots/bricks-icons/`).
10. `npm run check`, `npm run test:browser` (by name against Task 0), `npm run corpus` (no file worse; with Icons
    off nothing changes, so the numbers must equal Task 0's).

### M2

[amended 1] Was Tasks 11–16 (gated on site-no-div and site-shared-styles): moved to
`~/.hermes/plans/figma-to-bricks/bricks-icons-site.md`.

### Docs & records (the finisher, at this job's merge) [amended 1]

- Plan copied to `docs/plans/2026-11-11-bricks-icons.md`; ledger moved to `docs/plans/2026-11-11-bricks-icons-ledger.md`
  before the final premerge commit.
- `docs/HANDOFF.md`: a new section above the previous top heading with the rulings (Q1–Q8 ⭐ "not yet confirmed"),
  the counts table, the limits below, and the paste check owed with the next free id at the merge (3dz or later:
  check main and every branch's HANDOFF); its entry at the top of "End-of-run check list".
- `BUILD` bumped at the merge; main `CLAUDE.md` Status: the build line and one line for this feature; **standing rules
  to add** [amended 1: the importer's clause, "the importer only with `--svg`", is added at bricks-icons-site's merge;
  the second rule is fix round 1's]: "Bricks' Icon prints an SVG only from the media library (`icon.svg.id`); the
  plugin makes Icons only with pictures to WordPress and Icons as SVG; an Icon's drawing holds no ids" and "an Icon's
  box rules never out-weigh its own Width and Height controls: its floor is `overflow: clip`, its shape `height: auto`
  under `:where()`, never a `min-width` floor or an `aspect-ratio`"; and correct "Bricks samples" (an Icon sample
  exists; Offcanvas is no longer owed, per the audit).
- [amended 1] The repo's copy `docs/plans/2026-11-11-bricks-icons.md` becomes this amended file in the finisher's own
  docs commit, not earlier: a commit on the reviewed head `c78fa0cf` would be one no clean review covers.
- `reference/bricks/README.md` as in Task 1.

## Blast radius and shared files

- **Nothing reads `element === "image"` but** `understand.ts:115` (the inline switch), `emit/elements.ts:142`
  (a showcase photo's figure: excluded by rule 5) and `elements.ts:164` (the asset key). Adapt rules, recognisers and
  the layout plan read `role` (`image` / `vector`), which doesn't change (`grep '"image"' src/core`).
- **Tests that pin the old output:** `test/unit/render.test.ts` golden (keep `BASE_CSS` as it is);
  `pdf-direct-download.test.ts`, `header-bar.test.ts`, `phone-menu-rule.test.ts` run both picture modes with Icons
  off: unchanged.

| Job | Shared files | How they meet |
|---|---|---|
| plugin-parity | `understand/node.ts`, `understand/labels.ts`, `style/classes.ts`, `emit/elements.ts` | it changes Divs to Blocks and adds shared classes; this job touches `elements.ts` in one line (the asset key) and `understand.ts:115`. Either order; the second rebases |
| shared-palette | `emit/palette.ts`, `normalise/colors.ts` | the Icon's colour goes through `out.setting()`, so it takes whatever names that job settles |
| site-no-div, site-shared-styles, media-clickable, media-avif-alt, importer-parity | [amended 1] the importer's files only | they meet Milestone 2: their rows moved to bricks-icons-site's table |
| site-menu-motion, site-sticky-header, site-scroll-lock | none of the icon files | no overlap |

Order: **M1 any time** (it shares only `test/browser/render.ts`, `reference/bricks/README.md` and `docs/HANDOFF.md`
with the site jobs). [amended 1] Milestone 2's order is bricks-icons-site's: after site-no-div and
site-shared-styles, on top of this job's merge (media-clickable and media-avif-alt are on `main` since 2026-11-11).

## Risks, limits and what is not in this job (each named in HANDOFF)

- **Bricks 2.3.9 / 2.4.2 printing an SVG Icon** is read from 2.2's code (the CSS is equal in 2.3.9): the live paste
  check (the seventh criterion) is the proof [amended 1: the importer's own live check is bricks-icons-site's fifth].
  If a live paste shows otherwise, the fallback is today's output (Icons off).
- **A site that changes SVG files on upload** (a sanitiser plugin) prints its own version: the live check sees it.
- **Not Icons:** icons of several colours, icon badges drawn with their own box, blur or mask (hydraulics has 16
  drawings with a mask, a blur or an opacity), linked or described icons, icons over 96 px, a Button's own icons (Bricks' Button takes the same icon control: its SVG shape
  is unseen, `README` "Still wanted"), an accordion's open/closed icon (`isAccordionIcon`). [amended 1: "a site's
  font glyphs" moved to bricks-icons-site.]
- [amended 1] **Safari before 16** has no `overflow: clip`: it keeps the svg's own `overflow: hidden`, so an Icon in a
  row too narrow for its words may be squeezed there (fix round 1's recorded limit, in HANDOFF).
- **Hover as the Icon's own control** (Q7 B) and **Bricks' SVG element** (Q1 C): later jobs, each needs a sample.
- The panel's website route (a capture through the Figma converter) makes no Icons.
- GRO's outlined lettering (up to 80 × 93 px) counts as icons by the existing 96 px rule, so it becomes Icons too.

## Report contract

Builder, reviewers, verifier and auditor return `verdict`, `ac_status` (one row per AC above, the `(live)` ones as
owed to Justin), `shots[]` (Task 9's pairs), and `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with
`MAIN SESSION: check and save these skill_lessons now.` Checks' log folders come from a flag or variable, never one
shared folder. Agents never run `site:upload` or `site:import` against a live site and never load bdryswi.com or a
staging site.
