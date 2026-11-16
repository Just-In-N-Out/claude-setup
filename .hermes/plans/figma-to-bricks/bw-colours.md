# bw-colours: a background photo the old site drew at its file's own size pastes at that size (Mini, bug)

Planner: Fable 5.2 high, 2026-11-16. Base: `main` = `ebc7b1d9` (Build 2026-11-16.2). Plan only: nothing built, nothing committed.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/bw-colours/planner/` (scripts, measures, crops).

## Questions for Justin (⭐ = taken under the standing auto-go unless he says otherwise)

- **Q1. Where does the paste get the size the old site drew the photo at?**
  ⭐ **A: the scan measures it.** Exact on any site and any picture service. A page already scanned needs one new scan
  (the B-Dry pages too); until then its pastes stay as today and the notes name the photos.
  B: A, plus for pages already scanned whose picture address carries its size (bdryswi.com's Jetpack addresses,
  `…jpg?fit=768,1024`), work the size out from those numbers. No new scan for B-Dry, but it is a second route for one
  picture service, it can be one pixel off (on his page `fit=1024,683` of a 2560x1706 file is 682.4 px high), and it
  makes the job bigger than Mini.
- **Q2. When is the size written?**
  ⭐ **A: always, when the photo goes to the media library and the site drew it at the file's own size**: Background →
  Size reads `Custom` with the site's size (`768px 1024px`) instead of `Auto`. A photo swapped in Bricks later keeps
  the pattern's size.
  B: only when the library's file has another size than the site's; else it stays `Auto` (less changes, more code: the
  uploader's 2560 px rule would have to be known to the conversion).
- **Nothing to decide on the header bar** (finding 1 below: not a bug). If he wants the bar to stand still or move
  another way than the site's, that is a design change and its own job.

## What was asked (playback)

1. On B-Dry staging's Basement Waterproofing page the header bar's gradient looks different from bdryswi.com's.
2. The band under the hero photo (behind "Basement Waterproofing In Southwest Indiana") looks lighter and bluer on
   staging, darker with a finer pattern on the site.

## What the screenshots really show (measured, `planner/px*.ts`, `fit.ts`, `draw2.ts`)

Both screenshots were taken at 75% browser zoom (WordPress' 32 px admin bar is 24 px in both), so 1905 screen px are
2540 CSS px.

**1. Header bar: not a bug. The bar's gradient moves, and the two screenshots caught two moments of it.**
- The site's bar has a `::after` layer twice the bar's size with a five-stop gradient that an 8-second endless animation
  slides across (`shimmerGradient`: background-position 100% → 0% → 100%); the scan holds it
  (`web.code.nodes["body/div:0/header:0/div:0"].pseudo.after`, `web.code.keyframes.shimmerGradient`).
- The paste holds the same layer, colours, size and animation (header.json, class
  `basement-waterproofing__call-us-whbw`: `::after { animation-duration: 8s; animation-name: …shimmer-gradient-zxvk;
  background-image: linear-gradient(-120deg, var(--color-004774, rgb(0, 71, 116)) 0%, …); background-size: 200% 200% }`).
- Fitting that one gradient to each screenshot's bar (465 pixels each, `planner/header-fit.txt`): the staging
  screenshot is the gradient at position 42.4% (mean channel error 0.44, worst 0.9 of 255), the bdryswi.com screenshot
  the same gradient at 30.5% (0.43, worst 0.9). Neither is the resting position (errors 19 to 52 there), so both bars
  were moving. Same colours, same stops, same angle: only the moment differs (0.5 s apart in the loop).
- Drawn offline with Bricks 2.4.2's and 2.3.9's own CSS and a hostile Theme Style, the paste's bar is that gradient
  within 0.9 of 255 (`planner/pasted-2.4.2-measures.txt`): Bricks changes nothing, and no palette link changed a colour
  (a changed palette colour would not fit the site's stops).
- Measured colours along the bar's top (staging / site): left `#001d69` / `#00135b`, middle `#003a84` / `#00337d`,
  right `#0076c2` / `#0067b3`: the same ramp, slid about 300 CSS px.

**2. Band under the hero: ours. The photo behind the blue is drawn 2.5 times too big.**
- Colour: the blue layer is right. Mean of the band outside the words: staging `#074974`, site `#044671` (3 of 255
  apart). The site's own colour `#004774` under a 95% layer of the same colour, as the paste writes it (`::before {
  background-color: var(--color-004774, #004774); opacity: 0.95 }`). No layer, opacity or blend is lost.
- Pattern: the rafters photo repeats every 576 screen px on bdryswi.com (768 CSS px: four times across his window) and
  every 1440 screen px on staging (1920 CSS px: once and a bit). So staging shows a few large light beams where the
  site shows a fine dark pattern: that is the "lighter and bluer" (`planner/band-full-stretched.png`, staging on top).
- No orange is in the site's band beyond its words (red channel at most 13 of 255 outside them).
- Reproduced offline: Justin's own pastes drawn with Bricks' CSS (2.4.2 and 2.3.9) are 1.11 of 255 from his staging
  screenshot and 5.40 from his bdryswi.com screenshot; with only the band's Background size changed from `auto` to
  `768px 1024px` (the prototype, `planner/patch.ts`) they are 5.31 from staging and **1.04 from bdryswi.com**
  (`planner/pasted-2.4.2-measures.txt`, `fixed-2.4.2-measures.txt`, same numbers on 2.3.9). At 390 the band's mean
  colour moves from `#285b78` to `#275b79` with the fix (the photo's part shown there changes too).
- Bricks itself is not the cause: the offline drawing uses Bricks' own front-end CSS and prints `background-size: auto`
  exactly as the paste's setting says; the size is the only thing that had to change to match the site.

## Root cause (band), with file:line

1. The site's CSS names a resized copy of the photo and draws it at that copy's own size:
   `background-image: url("https://i0.wp.com/…/20240930_090252.jpg?fit=768%2C1024&ssl=1")`, no `background-size`
   (so `auto`), repeating (capture, `web.code.nodes["body/div:0/div:0/div:0/div:0/div:2"].decls["1367-up"]`). Jetpack
   serves that address as a 768x1024 picture.
2. The scan fetches the full-size file instead, on purpose, so the best file goes to the media library:
   `src/web/read/cdn.ts:9-16` (`fullSize` drops `fit`, `resize`, `w`…), used at `src/web/read/pictures.ts:82` and `:87`.
   The scan holds that address with a 1920x2560 file (`web.pictures.e90f36cc…`: width 1920, height 2560), and nowhere
   the 768x1024 the site drew. The upload sends that file (as AVIF, own size up to 2560).
3. The conversion keeps the site's "file's own size" for a file that is no longer the site's:
   `src/core/site/background.ts:44` reads a missing `background-size` as `auto`, `:61` writes it as the setting's
   size and `:62` points the setting at the library's full file. Paste: page.json, class
   `basement-waterproofing__basement-waterproofing-drsj`, `_background: { image: { id: 299, … size: "full" }, size:
   "auto" }`. Bricks prints `background-size: auto`, the browser draws the library file at 1920x2560.
   The custom-CSS route has the same hole: `src/core/site/media.ts:76-80` (`toLibrary`) swaps the address in a
   `::before`/`::after` layer or a layered value and leaves its `auto` size (`src/core/site/convert.ts:565-585`).
   So does a photo Image at natural size (`src/core/site/photo-box.ts:45`, `auto` → `object-fit: none`).
4. Why no check saw it: `site:check`, the tests and the importer app's preview compare boxes, not pixels, and draw a
   library picture from the scan's bytes, which are the same full-size file
   (`test/web/lib/site-check.ts:264-266`, `tools/lib/importer-app/preview-child.ts:25-29`).

The general rule broken: **a paste may not lean on a library file's own size.** The file in the library is not the
file the site's address served (a picture service's resized copy, the uploader's 2560 px limit, WordPress' own
scaling), so "draw it at the file's size" means another size after the upload.

On his scans (`planner/counts-on-his-scans.txt`, sizes worked out from the addresses, to be confirmed by a new scan):
Basement Waterproofing has 8 such backgrounds, 6 with another size than the uploaded file (768x1024 against
1920x2560; three at 768x512 and two at about 1024x683 against 2560x1707); the home page 9, of them 6 (the flip
cards' photo, 1024x640 against 1600x1000).

## The fix

The stage that knows the size records it; the conversion writes it.

1. **Scan** (`src/web`): a new optional record `web.natural: { [address]: { width, height } }`: the size each
   background picture came at, keyed by the address exactly as the page's CSS names it (the addresses the code
   reading's `background-image`/`background` values name, own and `::before`/`::after`, every range). An address the
   scan fetched as written takes its file's own size (no request). An address the scan fetched at another address
   (`fullSize(u) !== u`) is measured in the design width's own tab, as the page loads it: `new Image()` with the
   address as written, its `naturalWidth` x `naturalHeight`, 10 s at most. An SVG gets no entry (a drawing without a
   size of its own fills its box under `auto`: its file is uploaded as it is, so `auto` stays true). An address that
   can't be measured gets no entry and one capture note. Scans made before this build have no record.
2. **Conversion** (`src/core/site`, pure): before anything reads the site's code, a copy of it in which a background
   the site drew at its file's own size says that size. New `src/core/site/natural-size.ts`:
   `withDrawnSizes(code, natural, media)` returns `code` itself when there is no record or no media map; else, for
   each node's own declarations and each `::before`/`::after` layer, range by range on the full values (the ranges
   are stored as changes, widest first): each comma-separated layer of `background-image` that is exactly one `url()`
   whose address the media map holds and the record holds, and whose `background-size` there is `auto`, `auto auto`,
   unset, `initial` or `unset`, gets `<width>px <height>px` (the other layers keep theirs; the list is written
   out for every layer). Written back as changes per range. Applied once at the two entries (`siteParts` in
   `src/core/site/parts.ts`, `siteToBricks` in `src/core/site/convert.ts`) on a copy of the capture, so the class
   split, the Background → Image setting (`background.ts:61` already writes `Custom` + the size), the photo step,
   copies and shared looks all read the same thing. `background.ts` and `photo-box.ts` are not edited.
3. **Older scans with a media map** (no record): pastes byte for byte as before; each part's notes get one line:
   `N background photo(s) (<files>) are drawn at their file's own size, and this scan doesn't hold the size the old
   site drew them at: if one looks bigger or smaller than on the site, scan the page again with this build`.

Rulings the builder takes (in HANDOFF as "not yet confirmed"):
- R1: a size the site wrote itself (`cover`, `contain`, `50% auto`, `auto 100%`, lengths) is never touched.
- R2: with the size written, a box that only shows such a photo is no photo Image on main ("an Image has no setting
  for that size", photo-box-image's own sentence); photo-image-all takes px sizes when it merges.
- R3: a photo whose address changes between two of the site's widths inside one Bricks tier now also changes its
  size there, so media-clickable keeps it custom CSS with its existing reason ("it changes between Bricks'
  breakpoints at …px"). Exact wins over clickable.
- R4: without a media map (the picture keeps the old site's address, or travels inside the paste) nothing changes.

Bricks-pro standard: the value sits in Bricks' own field (Background → Image, Size: Custom `768px 1024px`), not in
custom CSS; the look is the site's ("exact wins"); a swapped photo keeps the pattern's size.
General logic: nothing is keyed on B-Dry, Jetpack or a file name; the rule is "a library background drawn at its
file's own size", on any site.
Plugin: the Figma route is not touched and not proven wrong. Recorded as a suspicion only (prove on a plugin
conversion first): `src/core/style/paint.ts:144` writes a tiled Figma fill as `size: "auto"` and nothing reads
Figma's tile scale (`scalingFactor` appears nowhere in `src/`).

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a local fixture page with one box whose background address is a resized copy on a picture service (the name `i0.wp.com` mapped to the fixture server: the full file 400x300, the address with `?fit=100,75` answered 100x75), one box whose background is a plain 64x48 file, one SVG background and one address that never loads, when it is scanned, then `web.natural` holds 100x75 at the first address exactly as written and 64x48 at the second, holds nothing for the SVG and the failing address, the capture's notes name the failing one, and `web.pictures` still holds the 400x300 file. Test: `AC1: a scan records the size each background picture came at` in `test/web/capture-natural-size.test.ts`.
- AC2 (proposed): Given a capture whose record holds 100x75 at a box's background address and a media map holding that address, when it is converted, then the box's class has Background → Image with `size: "custom"`, `custom: "100px 75px"` and no `auto`; an address that changes at a Bricks breakpoint writes that tier's own size; a `::before` layer and a two-layer value (photo over gradient: `100px 75px, auto`) carry it in the class's custom CSS; a size the site wrote (`cover`, `contain`, `50% auto`), an SVG, an address outside the media map and an address without a record stay exactly as written; and with no record or no media map `withDrawnSizes` returns the code it was given. Test: `AC2: a library background drawn at its file's own size is written at the size the site drew` in `test/unit/site-natural-size.test.ts`.
- AC3 (proposed): Given the fixture page of the first criterion, its tile a hard-edged four-colour picture, repeating, once bare and once under a half see-through colour layer, when the paste made with a media map is drawn as `site:check` draws it (the library picture from the scan's bytes) with Bricks 2.4.2's and 2.3.9's CSS at 1440, 768 and 390, then each box's pixels are within 16 of 255 of the fixture page's own drawing at that width. Test: `AC3: a natural-size library background draws as the site's at every width` in `test/browser/render-site-natural-size.test.ts`.
- AC4 (proposed): Given every capture of photo-box-image's story pin lists (the hand-made code captures, the saved fixture-site captures, Justin's saved scan when given), none holding the record, converted on both routes without and with a media map, whole and each section alone, then every payload is the base's (`ebc7b1d9`) byte for byte, and every result too but for the one notes line per part of the fix's point 3 where a media map sends a natural-size background to the library; and a capture given the record but no media map is the base's byte for byte, notes included. Test: `AC4: without a recorded size or a media map the paste is main's byte for byte` in `test/unit/natural-size-site-pins.test.ts` (a story pin: `F2B_STORY_PINS=1`, `F2B_BASE_TREE`, `F2B_BDRY_CAPTURE`, `F2B_BDRY_MEDIA`).
- AC5 (proposed): Given Justin's saved Basement Waterproofing run (its capture and `media.json`, folder in `F2B_BW_RUN`), when its pastes are made again as `npm run site -- <capture> <out> --elementor --media <media.json>` writes them, then header.json, page.json and footer.json are byte for byte the files in his folder (Build 2026-11-16.2), the page's notes hold the line naming exactly these six files (20240930-090252, close-up-of-white-plastic-pipe-drain…, construction-tools-and-safety-wear-concept…, happy-young-woman-handshaking…, worker-specialized-in-mounting-pvc-membranes…, 20241007-094230, each `-image.avif`), the footer's notes the line naming 20240930-090242-image-1.avif, and the header's notes no such line. Test: `AC5: his saved Basement Waterproofing scan pastes as before and names its seven photos` in `test/unit/site-natural-size-run.test.ts` (named-only).
- AC6 (proposed) (live): paste check **3ff**. In the importer app scan bdryswi.com/basement-waterproofing/ again with this build, Make pastes, upload (nothing new goes up), paste on B-Dry staging: at 1440 and 390 the band under the hero shows the rafters photo at bdryswi.com's size (at his 1905 px window, four repeats across, as on the site), its class's Style → Background reads Size Custom `768px 1024px`, and the header bar's gradient moves as the site's (watch both for 8 seconds; one screenshot of each catches two different moments).

Each test fails on `ebc7b1d9`: the first on the missing record, the second and fourth on the missing module, the third
on pixels (the tile is drawn four times too big there), the fifth on the missing notes line.

## Tasks (builder, test first, one commit a task)

Mini pipeline: if this needs a design decision or more than the files below, stop with `escalate to full`.
Forecast: 70 to 110 minutes. `npm run check` and `npm run corpus` before Task 1 and at the close (project rule).
Every drawing offline (`launchOffline`), under the memory cap; never bdryswi.com, B-Dry staging or any live site.

1. **Record type and scan.** `src/core/snapshot/web.ts`: `natural?: Record<string, { width: number; height: number }>`
   on `WebCapture`, with the comment of the fix's point 1 (check `src/core/snapshot/load.ts` lets it through).
   New `src/web/read/natural.ts`: the pure choice (which addresses take the file's size, which are measured, SVG left
   out) and the page expression that measures one address. `src/web/capture.ts`, in the pictures step (around
   L399-424, after `downloadAll`): fill the record, measuring through the design width's tab (`ws.page`), before the
   presses. Red then green: the first criterion's test. The fixture server answers `?fit=100,75` with a 100x75 PNG
   and the bare path with the 400x300 one (`encodePng`, `test/browser/png.ts`); the capture's Chrome is launched with
   `maps: ["MAP i0.wp.com 127.0.0.1"]` (`test/web/lib/offline-chrome.ts`) and the capture's `fetcher` option sends
   the name to the fixture server. If the capture harness can't map the name, stop and report; don't weaken the test.
   Captures of pages without a CSS background picture gain an empty or absent record only: run the capture tests
   that compare a fresh capture with a saved one (`capture-speed-same`, `capture-file`, `capture-corpus`) and write
   the record only when it has an entry if one of them needs it.
2. **The pure rule.** New `src/core/site/natural-size.ts` (`withDrawnSizes`, and `unsized(code, rootPath, media)`:
   the library files of a part's natural-size backgrounds, for the notes line). Values through `value.ts` `parse`/
   `serialize` and `media.ts` `pictureAt`; full values per range through `ranges.ts` (`statesOf`), written back as
   changes (photo-box.ts has an `encode` for its own copy: import it if exported, else a local one; don't edit
   photo-box.ts). Red then green: the second criterion's unit cases on hand-built nodes.
3. **Wire it.** `src/core/site/parts.ts` (`siteParts`) and `src/core/site/convert.ts` (`siteToBricks`): convert a
   copy of the capture whose `web.code` is `withDrawnSizes(…)` when `opts.media` is given; the notes line of point 3
   where a media map is given and the capture has no record. Check with `grep -n "web!\?\.code" src/core/site/*.ts`
   that nothing reads the capture's code past the copy. Red then green: the second criterion's conversion cases,
   then the fourth and fifth (`F2B_BASE_TREE` a `git archive` of `ebc7b1d9` with `node_modules` linked, as
   photo-box-image's pin; `F2B_BW_RUN` a copy of `~/Downloads/bdryswi-com-basement-waterproofing/` under
   `~/.cache/`). An existing default-run test whose exact notes gain the new line gets that line (test-only edit,
   named in HANDOFF).
4. **The drawing.** `test/browser/render-site-natural-size.test.ts` on the harness of
   `test/browser/render-site-photo-box.test.ts` (both `BRICKS_VERSIONS`, `renderSitePaste`, `pastePictures`): the
   fixture page drawn by itself against its paste. Prove it red by `git checkout HEAD~1 -- src/core/site/parts.ts
   src/core/site/convert.ts` style revert of Task 3's wiring, then restore.
5. **Docs and records.** `docs/HANDOFF.md`: a section "A background drawn at its file's own size" (what changed, Q1
   and Q2 ⭐ and R1 to R4 as not yet confirmed, the header finding in two lines, paste check 3ff, the follow-ups
   below); the ledger in `.superpowers/sdd/bw-colours/progress.md`. One screenshot per criterion (the third's side by
   side at 1440 and 390; a terminal capture for the others).

## Touched files

Source: `src/core/snapshot/web.ts`, `src/web/read/natural.ts` (new), `src/web/capture.ts`,
`src/core/site/natural-size.ts` (new), `src/core/site/parts.ts`, `src/core/site/convert.ts` (two small edits each).
Six files, two of them new and small: a little over Mini's "about 3", with no design decision left. With Q1 B it is
a Full-sized job.
Tests: the five new files above, a fixture page beside them. Docs: `docs/HANDOFF.md`, the ledger.

**Shared with other jobs:** `src/core/site/convert.ts` (site-fonts-import, photo-image-all, logo-media,
site-sticky-cards), `src/core/site/parts.ts` (site-fonts-import, site-sticky-cards), `docs/HANDOFF.md` (all).
Not touched: `photo-box.ts`, `background.ts`, `media.ts`, `src/web/read/code.ts`, `tools/`. Paused jobs
(short-class-names, fewer-kept-boxes, clean-values, link-keeps-name) meet this one only in `convert.ts`.

## Follow-ups (not in this job)

- F1: a paste that carries the picture inside itself, and the importer app's preview and `site:check` of a paste
  without a media map, draw a resized-copy background at the full file's size (the live paste, which loads the old
  address, is right).
- F2: a picture service's cut (`resize=`, `crop=`) has another shape than the full file: under `cover`, `contain` or
  `100% auto` the paste shows the whole photo, not the cut. The record now holds what is needed to name it.
- F3: masks (`mask-size: auto`), `image-set()` and a hover's photo keep the file's own size.
- F4 (suspicion, plugin): a tiled Figma fill's scale is not read (`src/core/style/paint.ts:144`).
- F5 (suspicion): an `<img>` the site sizes only by its file, on a resized-copy address.
- F6 (seen in his screenshots, another job's area): "Basement Waterproofing  In Southwest Indiana" is bolder on
  staging than on bdryswi.com.

## Report contract

`ready-for-review` with the head, each criterion's test and log, the screenshots, the corpus tallies, `found_else`,
`skill_lessons[{skill, lesson, evidence, enforce}]`.
