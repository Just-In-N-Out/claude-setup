# photo-image-all (Mini): every photo shown alone in its box pastes as a Bricks Image, also when the site draws it at a size or place of its own

Planner, 2026-11-16 13:05 EST. Base: `main` = `ebc7b1d9` (Build 2026-11-16.2). Website importer only. Mini pipeline.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/photo-image-all/planner/` (scripts, probe results, the census of both scans).

## Questions for Justin (⭐ = taken at go unless he says otherwise)

- **Q1. What this job takes.** ⭐ **A:** a photo-only box whose photo is drawn at a size of its own (`383px auto`, `auto 150px`,
  `50% auto`, `120px 90px`, `auto 60%`…) and placed at the start, centre or end of each side (with a px offset where the
  site writes one), plus a place written in three or four words (`right 10px bottom 20px`) or with `calc()` on the fits
  taken today. That takes the Tri-State map and every box of that kind on any site. Everything else in the table below
  stays a Block with its Background → Image setting, named, each a follow-up. **B:** also a `%` padding (the ratio box)
  and a linked box (`a`) in this job: bigger than Mini (new shapes to probe, Bricks prints a linked figure another way).
- **Q2. Where the picture's size lives.** ⭐ **A:** in the Image class's Custom CSS on its picture (`> img { width: 383px;
  height: auto }`), beside the fit and place photo-box-image already writes there. Bricks' own Width and Height controls
  size the Image's box, not the picture inside it, so no control can hold it; the notes say where to change it. The
  picture keeps its own shape from the file (no ratio is written), so a photo swapped in Bricks for one of another shape
  still draws at `383px` wide and its own height, as a background would.
- **Q3. Half a pixel.** ⭐ **A:** a photo the site places on a part of a pixel (the map on a 390 px phone starts 3.5 px in)
  may sit up to one pixel from where the background sat: Chrome rounds a background to whole pixels and an `img` not.
  The same allowance he approved for photo-box-image's edges ("Allow it", 2026-11-16), here for the whole photo of a
  newly taken box (AC3's wording). Boxes and every other element stay within 0.5 px.

## Playback

After photo-box-image, Justin re-pasted B-Dry's home and the Tri-State map ("Basement Contractors in Southwest
Indiana", Block "Photo") was still a Block: "It should be for all the photos not only the truck". He wants every box
that shows only its own library photo to be a Bricks Image, the drawing kept so nothing moves. Photos behind words,
buttons or other content stay their box's Background → Image (out of scope, as he said).

## What refuses a photo-only box today, and what this job does with each

Measured on main with his media maps (`base-counts.txt`, `census-home.txt`, `census-about.txt`): home holds 2 photo-only
boxes and the drawer's (truck and drawer photo are Images, **the map is refused: "drawn 383px auto from 767px down"**);
About holds 1 and the drawer's (both Images, none refused). So one box is refused on his two scans, for its size.

| # | Reason in `photo-box.ts` today | Can an Image draw it exactly? | This job |
|---|---|---|---|
| 1 | a size no fit draws (`383px auto`) | Yes: the `img` is the photo's own drawn box (probe T1–T13) | **Taken** |
| 2 | a place of more than one x and one y (`right 10px bottom 20px`) | Yes: `object-position` takes the same words (probe P1–P4) | **Taken** |
| 3 | it repeats | No (an Image draws once), unless a second tile can never show | `100% 100%` with a keyword or % place now counts as once (P5), as cover does; the rest **stays** |
| 4 | fixed attachment; another origin, clip or blend | Fixed and blend: no. Origin and clip: possible, not probed | **Stays**, named |
| 5 | a `%` padding | Only where the box's width provably equals its parent's | **Stays** (follow-up, already listed) |
| 6 | a border that isn't solid | No: the photo shows through the gaps, an img sits inside the border | **Stays** |
| 7 | a border with round corners | No: a hairline at the corners | **Stays** |
| 8 | `display: inline` or another display; a vertical writing mode | Not probed, rare | **Stays** |
| 9 | a `::before` or `::after` layer | Possible for a layer placed over the box; no box on his scans has one | **Stays** (follow-up) |
| 10 | a hover or focus look changes its background | A photo change: no. A colour change: possible | **Stays** (follow-up) |
| 11 | an animation of its background | No | **Stays** |
| 12 | another photo at a narrower Bricks breakpoint | No: an Image shows one photo | **Stays** |
| 13 | media-clickable's own (a gradient or layers over the photo, a photo changing off Bricks' breakpoints) | A gradient needs a made-up overlay layer | **Stays**, media-clickable's note |
| 14 | its part's root; another step's pick; what another step needs as it is | Structure, not drawing | **Stays** |
| 15 | not a `div` (a link `a`, a `span`…), or it holds children | A linked figure prints `figure > a > img`: its own job | **Stays** (follow-up) |

A fill colour behind the photo, px/em/rem padding, an offset on cover, `contain`, natural size, another fit per width
and a solid square border are already taken on main and stay as they are.

**New refusals, each named** (inside reason 1, where an Image still can't follow):
- a size of its own that repeats (anything but `no-repeat`): "its photo repeats at a size of its own (…): an Image draws it once";
- a size of its own placed at a percentage other than 0, 50 or 100, or with `calc()`: "its photo sits <value> across/down at a size of its own: an Image's picture can only start, centre or end there" (follow-up);
- a size written with anything but `auto`, px/em/rem lengths and percentages (`vw`, `calc()`, `var()`): "its photo is drawn <size>: an Image has no setting for that size" (today's sentence).

## How Bricks prints it (both versions) and how the Image draws it

Bricks prints `<figure id class="brxe-image … tag"><img …></figure>`; its own rules, the same on 2.3.9 and 2.4.x
(`reference/bricks/README.md` "An Image as a figure", `test/browser/render.ts` L402–403): `:where(.brxe-image).tag
{display:inline-block;height:fit-content;position:relative;width:auto}` and `:where(.brxe-image) img{border-radius:
inherit;height:100%;position:static!important;transition:inherit;width:100%}`, in `@layer bricks`. No `object-fit` of
its own (the browser's `fill`); the Object fit control prints at `.cls.brxe-image:not(.tag), .cls.brxe-image img`.
`position: static !important` in a layer can't be overridden, so the picture is never positioned: it is placed as the
one-cell grid's item, as photo-box-image already does.

**The rule (general, read from the box's declared CSS only, per capture range the box shows in):**

1. **Size of its own** = `background-size` of one or two words, each `auto`, a px/em/rem length or a percentage, that
   is none of main's fits (`cover`, `contain`, `auto`/`auto auto`, `100% 100%`). One word `X` means `X auto`.
2. **The figure** at such a range: as main writes it, plus `overflow: clip` (replacing `overflow-x`/`-y`, as main does
   under a radius): a photo larger than its box is cut at the box, as a background is.
3. **The picture** (`> img`) at such a range, instead of main's stretch over the padding box:
   - `display: block; contain: none; min-width: 0; min-height: 0; max-width: none; max-height: none; padding: 0; border: 0; border-radius: 0`;
   - `width`: the size's first word (`auto`; a length as written; `p%` → `calc((100% + <padding left> + <padding right>) * p/100)`, plain `p%` where both are 0);
     `height`: the second word the same way with top and bottom padding. The photo's own shape comes from the file
     (`contain: none`, never an `aspect-ratio`; probe N1 shows `contain: size` loses it);
   - `object-fit: fill` (the fit of that range for main's rule C: Bricks' Object fit `fill` where importer-parity's settings are on and every shown range is `fill`, else in the picture's rules); `object-position` as main writes it;
   - placed by `align-self` (down) and `justify-self` (across) with margins that also take it out of the figure's size
     (`X` = `-99999px`; `pad` = the figure's padding on that side at that range, 0 where none):
     - **start** (`left`/`top`, `0%`, a bare length `L`, `left L`/`top L`): self `start`; near margin `calc(L - pad)` (`-pad` without an offset), far margin `X`;
     - **end** (`right`/`bottom`, `100%`, `right L`/`bottom L`): self `end`; far margin `calc(L - pad)`, near margin `X`;
     - **centre** (`center`, `50%`): self `center`; near margin `calc(X - (padNear - padFar) / 2)`, far margin `calc(X + (padNear - padFar) / 2)` (both `X` where the paddings are equal).
     Across, write `justify-self: left`/`right`/`center` (a background's `left` is physical). Sides are resolved to the four
     physical margins from the box's own and inherited `direction` (`CodeNode.inherited`); a side a range writes under two
     names is refused with main's "capture the page again" wording.
   - Proven in offline Chrome 156 under Bricks' rules, with and without the paste's reset: boxes equal in all 17 own-size
     shapes, pixels equal or within a one-pixel shift (`probe-own-size-smooth.txt`); without the margins the photo grows
     its figure (N4), without the clip it hangs out (N3).
4. **A box with any own-size range** writes the picture's margins by the four physical names at every range (main's
   ranges of that box keep their values: the figure's padding negated). A box with no own-size range is written exactly
   as main writes it (byte for byte).
5. **A range the box isn't shown in** keeps the drawing of the range above, as main does (`fitsOf`): fixture `HIDDEN_AT`
   (`50px auto` while hidden) must not change by a byte.
6. **Places on main's fits** (`cover`, `contain`, natural, `100% 100%`): `background-position` of one to four words, or
   `-x`/`-y` of one or two words each, every word a keyword, a length, a percentage or a `calc()`, goes to
   `object-position` as written; three words become four (`left 10px center` → `left 10px top 50%`). Split words with
   `value.ts`' parser (a `calc()` holds spaces).
7. **Repeat:** `100% 100%` with a keyword or % place counts as drawn once, as `cover` does today.
8. **Notes:** `imagesNote` unchanged; the three new refusal sentences above; nothing else new. Ruling E of photo-box-image
   (looks, palette and names decided with the step off) covers the newly taken boxes as it is: no change in `convert.ts`
   or `parts.ts`.

**Bricks-pro standard:** the photo is in Content → Image (Media, alt text), the fit in Object fit where one holds; the
picture's size and place have no Bricks control on a figure Image, so they sit in the Image's own class, short, and the
notes say so. Exact wins: the picture draws where the background did.

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a childless `div` whose own library photo has a size of its own at a shown range, is drawn once and is placed at each side's start, centre or end (with or without a length offset), when it is pasted with a media map (plain and `--elementor` routes), then it is one Bricks Image (`tag: figure`, the library's photo in `image`), its class's `> img` rules at that range hold the width, height, `contain: none`, `object-fit: fill`, self-alignment and margins of rule 3 and its figure `overflow: clip`, its other ranges are as main writes them, and no note names it as left. Test `test/unit/site-photo-own-size.test.ts`: "AC1 a photo drawn at a size of its own pastes as a Bricks Image".
- AC2 (proposed): Given a photo-only box on one of main's fits whose place is written in three or four words or with `calc()`, or whose size is `100% 100%` with the default repeat and a keyword or % place, when pasted, then it is a Bricks Image whose `object-position` holds that place (three words as four). Test `test/unit/site-photo-own-size.test.ts`: "AC2 a place of three or four words goes to the picture as written".
- AC3 (proposed): Given the fixture page's newly taken shapes, when the paste is drawn as `site:check` draws it with Bricks 2.4.2's and 2.3.9's CSS at every captured width, then every element is within 0.5 px of the same paste made with `photoBoxes: false`, each newly taken picture's box is within 0.5 px of the rectangle its background's size and place give in its box, and the photos' pixels are within 16/255 of the switch-off drawing at the same pixel or at a pixel next to it (Q3: a whole-photo shift under one pixel). Test `test/browser/render-site-photo-own-size.test.ts`: "AC3 a photo of its own size draws as its box did at every width".
- AC4 (proposed): Given each drawing the rule still leaves (every row marked "stays" above and the three new refusals), when pasted, then the box stays a Block with its Background → Image setting and one note names it with its reason. Test `test/unit/site-photo-own-size.test.ts`: "AC4 a drawing an Image can't take stays a Block with its reason".
- AC5 (proposed): Given main's tree (`ebc7b1d9`) and this tree converting the same captures (every hand-made code capture, the saved fixture-site captures and Justin's two scans, both routes, both text modes, with and without a media map, whole and each section alone), then every result is main's byte for byte except for exactly the boxes main's notes name as left for a size or a place this job takes, and each of them is an Image: every other element and class (every photo Image main already made, with its class, among them) is main's by id, name and settings, and the rest of the result differs only in the lines that count what those Images change. Test `test/unit/photo-image-all-pins.test.ts` (story pin, `F2B_STORY_PINS=1`): "AC5 every paste is main's byte for byte but for the newly taken boxes".
- AC6 (proposed): Given a saved scan with its media map (`F2B_PHOTO_RUN`), when converted as the command converts it, then every childless `div` showing only a library photo is an Image or is named with a reason this job still refuses, and none is left for a size of its own this job takes or for a place of three or four words. On Justin's scans the run prints: home 3 Images (the map among them), 0 left (main: 2 and 1); About 2 Images, 0 left (main: the same). Test `test/unit/site-photo-box-run.test.ts`: "AC6 the saved scan: no photo-only box is left for its size or place".
- AC7 (proposed): Given a saved scan with its media map (`F2B_PHOTO_RUN`), when its page part is drawn with photo Images on and off at every range's anchor widths, then every element is within 0.5 px and each newly taken photo draws within AC3's pixel rule. Test `test/browser/site-photo-box-run.test.ts`: "AC7 the saved scan's newly taken photos draw where their boxes did".
- AC8 (proposed) (live): Paste check **3fd**. In the importer app Justin picks the home scan → Make pastes again → pastes the page on B-Dry staging: in Structure the Tri-State map is an "Image"; clicking it, Content → Image shows `bdry-map-1-image.avif`; the section looks as before at 1440 and at 390.

Gates (not criteria): `npm run check`, `npm run corpus`, and the photo-box tests of main (base tally in `base-tests.txt`:
8 pass, 4 named-only skips, 0 fail) with the two edits named under "Existing tests that change".

## Tasks (test first, one commit each; the builder works in its worktree and doesn't bump `BUILD`)

0. Copy this plan to `docs/plans/2026-11-16-photo-image-all.md`; start the ledger `.superpowers/sdd/photo-image-all/progress.md`; `npm run corpus` before Task 1.
1. **Fixture** (`test/fixtures/site-photo-box-code.ts`): move `SET_SIZE` and `PLACE4` from `REFUSE` to `PASS`; add PASS shapes after the probe's cases, by declared CSS (names free): the map on phones (`383px auto`, centre, `min-height` only, a colour under, padding 10, `cover` with px offsets above 767 and hidden at one range between), lengths as offsets with uneven padding (T2), `auto 150px` at `right 15px bottom 25px` (T3), `50% auto` centre top in a `min-height`-only box (T4), `120px 90px` at `100% 0%` (T5), a photo larger than its box under a radius (T6), `auto 60%` in a `min-height`-only padded box (T8b), `40% 70%` left bottom in a stretched row item (T8c), a column-flex grower (T9 without the calc offset), an absolute box (T10), a grid cell (T11), centre under uneven padding (T12), em sizes with a solid border (T13), and P1–P5 for rule 6 and 7. Add REFUSE shapes: own size with the default repeat; own size at `20% 30%`; a `calc()` size. Append new PASS keys after the existing ones so no existing stage's path moves (`stageOf` indexes by key order): put the two moved cases at the end too and leave their old `REFUSE` slots filled by the new refusals, so `REFUSALS/div:<n>` paths of the other cases stay.
2. **RED** for AC1, AC2, AC4 in `test/unit/site-photo-own-size.test.ts` (on main `SET_SIZE` and `PLACE4` are refused: `photo-box.ts` L67–69; the existing AC4 test asserts those sentences). Then the rule: new pure `src/core/site/photo-place.ts` (the size and place readers: `ownSize(size)`, `placeOf(decls)` per side as `{ at: "start" | "center" | "end", off }` and as an `object-position`, the picture's own-size declarations from rule 3) and `src/core/site/photo-box.ts` (`rangeWhy`, `fitsOf` → `fill` at an own-size range, `photoStates` → the clip, `imgStates` → rule 3 and 4). Keep both files under ~300 lines.
3. **The drawing test (third criterion)** `test/browser/render-site-photo-own-size.test.ts` on the harness of `render-site-photo-box.test.ts` (`launchOffline`, `renderSitePaste`, both `BRICKS_VERSIONS`, `WIDTHS`); its picture oracle computes the background's rectangle from the switch-off paste's box (padding box, the declared size and place, the fixture photo's natural size) and compares the `img`'s `getBoundingClientRect`. Existing AC3 test stays as it is for main's shapes (its `innerEdges` reads an own-size picture's box edges inside its figure as edges too, or skips the new shapes: say which in the ledger).
4. **The byte pin (fifth criterion)** `test/unit/photo-image-all-pins.test.ts` after `photo-box-image-site-pins.test.ts` (same captures, env `F2B_BASE_TREE` = a `git archive ebc7b1d9` tree with `node_modules` linked, `F2B_BDRY_CAPTURE`/`F2B_BDRY_MEDIA` once per scan); the fixture is read from the base tree for the base side.
5. **The saved-scan tests (sixth and seventh criteria)**: one new test in each of the two `site-photo-box-run` files, sharing their helpers. Run both on copies of Justin's two scans (`~/Downloads/bdryswi-com-home/`, `~/Downloads/bdryswi-com-about-us/`, read-only: copy the capture and `media.json` under `~/.cache/<job>-<role>/`), record the printed counts.
6. **Existing tests that change** (name each in HANDOFF): `test/unit/site-photo-box.test.ts` AC4 (no longer lists `SET_SIZE`, `PLACE4`); any count of PASS/REFUSE shapes in `site-photo-box.test.ts`, `site-no-div.test.ts`, `photo-box-image-site-pins.test.ts` (a story pin of the earlier job: leave it, it is history).
7. One screenshot per AC (a terminal capture where nothing is visual; for AC3 and AC7 the map's shape drawn off and on at 390 and 1440), `npm run check`, `npm run corpus`, stop at `ready-for-review`.
8. **Docs & records:** a HANDOFF section "Every photo shown alone in its box is a Bricks Image" (the rule, the table above, Q1–Q3 as not yet confirmed, paste check 3fd in the end-of-run list, follow-ups: a linked box, a `%` padding, an overlay `::before`, a hover colour, an odd-% place at a size of its own, Safari and Firefox not probed); the finisher adds the CLAUDE.md Status line.

Commands (each under the memory cap, from a runner script, `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`, Node `/home/justin/.local/node-v22.23.3/bin`):
`node --test test/unit/site-photo-own-size.test.ts` · `node --test test/browser/render-site-photo-own-size.test.ts` ·
`F2B_STORY_PINS=1 F2B_BASE_TREE=<tree> F2B_BDRY_CAPTURE=<capture> F2B_BDRY_MEDIA=<media.json> node --test test/unit/photo-image-all-pins.test.ts` ·
`F2B_PHOTO_RUN=<folder> node --test test/unit/site-photo-box-run.test.ts test/browser/site-photo-box-run.test.ts`.

## Touched files

Source: `src/core/site/photo-box.ts`, new `src/core/site/photo-place.ts`. Tests: `test/fixtures/site-photo-box-code.ts`,
new `test/unit/site-photo-own-size.test.ts`, new `test/browser/render-site-photo-own-size.test.ts`, new
`test/unit/photo-image-all-pins.test.ts`, `test/unit/site-photo-box-run.test.ts`, `test/browser/site-photo-box-run.test.ts`,
`test/unit/site-photo-box.test.ts`. Docs: `docs/HANDOFF.md`, `docs/plans/2026-11-16-photo-image-all.md` and its ledger.
**Shared with other jobs:** only `docs/HANDOFF.md` (site-fonts-import, short-class-names, fewer-kept-boxes) and, at the
finish, `src/shared/build.ts` and CLAUDE.md. Not touched: `src/core/site/convert.ts`, `parts.ts`, `tools/…` (site-fonts-import
builds there), `test/browser/render.ts` (clean-values).

## Risks and limits

- **Mini fits:** two source files, no design decision beyond Q1–Q3, no upload or login code. If rule 4's physical margins
  or the fixture's path order force changes outside these files, the builder stops with "escalate to full".
- **A suspicion, not proven (no live site read):** Bricks prints a library picture with `srcset` and `sizes`; a
  natural-size photo (`background-size: auto`, main's `object-fit: none`, already taken by photo-box-image) could then
  draw at the slot's width on phones. No box on Justin's scans uses it; this job's own-size drawing doesn't depend on
  the natural size (the box is sized, the shape comes from the file). Recorded for HANDOFF as a suspicion.
- The margins use a fixed `-99999px`; a photo drawn wider or taller than that would size its figure (not a real case).
- Chrome only (156); Safari needs 16 for `overflow: clip`. As photo-box-image: Safari and Firefox not probed.
- A pro who changes the Image class's Padding must change the picture's margins with it (already a follow-up).

## Report contract

Builder: `status`, branch and last commit, the ACs with their tests and screenshots, `found_else`, `skill_lessons`.
Reviewer, verifier, auditor: `verdict`, `ac_status`; the reviewer also `review.json`.
