# media-clickable: uploaded photos that show on the Bricks page but can't be clicked as pictures (Mini, a bug)

Planner: Fable 5.2 high, 2026-11-11. Base: `main` at Build 2026-11-11.3 (`02481763`). The builder copies this file to
`docs/plans/2026-11-11-media-clickable.md`. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/`
(`planner/`: the scripts and their outputs, Bricks' `assets.php`; `run/`: a copy of Justin's scan, media.json and pastes).

## Playback

1. Justin scanned bdryswi.com's home, uploaded its pictures to B-Dry staging (34 files, media ids 174–207) and pasted.
   Some of those photos show on the page but, in Bricks, can't be clicked and swapped as pictures.
2. He guessed the cause is missing alt text. It isn't: all 23 such photos are **backgrounds of boxes** (the old site
   draws them with CSS behind words or in a card), and the paste writes them as text in the class's custom CSS, so
   Bricks' builder has no picture to show. They have no alt only because a background never has one.
3. The fix: a box's own background photo from the media library goes into Bricks' own **Background → Image** setting
   (with its media id), where the builder shows it and opens the library when it is clicked; the page looks the same.

## Questions (⭐ = the answer the builder takes under the standing auto-go)

- **Q1. How should a background photo be reachable in Bricks?**
  - ⭐ **A. Bricks' Background → Image setting of the box** (the library picture with its id). Click the box, open
    Style → Background: the photo is there and a click on it opens Media. The page can't look different: Bricks prints
    the same `background-image` the custom CSS printed. This is also what the old site was (Elementor container
    backgrounds), and what Justin's own hand-built hero does (`reference/bricks/hero-video-buttons.json`).
  - B. Each background becomes its own Image element laid behind the words. It would be a separate item in Structure,
    but it changes the structure and can change the look: fixed (parallax) backgrounds, positions like `73px -73px`, a
    photo per screen width (two or three Images per box) and words stacking over a picture all have to be rebuilt by
    hand-written rules. Not a Mini job: Full, with a look check per width.
  - C. Only boxes with nothing inside become Image elements (3 on this page); the rest take A.
- **Q2. Where does the setting sit?**
  - ⭐ **A. In the box's class**, where the paste already keeps the box's width, height and background colour: click
    the box, click its class name above the Style tab, then Background. Any width change stays exact.
  - B. On the box itself (shows without clicking the class). Bricks prints an element's own setting above every class
    rule, so it only works for a photo that is the same on every screen width; photos that change per width (6 boxes
    here) would stay in the class anyway.
- **Q3. A background that can't be a setting without changing the look** (a colour fade drawn over the photo in the
  same rule, a photo on a `::before`/`::after` layer, a hover look, a photo that changes between Bricks' breakpoints
  while the box shows): ⭐ **A. stays CSS as today and notes.txt names it with the reason.** B-Dry's home has none.

## The pictures of this run (measured: `planner/uses.txt`, `bg.txt`, `shown.txt`, `rest.txt`)

The capture holds 49 picture files; 34 went up (media.json: 35 addresses, 34 files). In the three pastes:

| How the paste carries it | Files | Media ids | Alt in Media | Its own clickable picture in Bricks' builder? |
|---|---|---|---|---|
| Image element with the library `id` (`settings.image.id`, the site as `sourceUrl`) | 11 | 174, 175, 177–182, 205–207 | 8 have one; 181, 205, 207 have none | **Yes** (all 11, with or without alt) |
| A box's own CSS background, one photo at every width: `background-image: url(…)` in the class's custom CSS (9 classes) | 7 | 176, 184, 185, 186, 188, 202, 204 | none | **No**: text in custom CSS, no id |
| The same, written as `image-set()` of one photo (1 class) | 1 | 183 | none | **No** |
| Flip-card faces: the photo on wide screens, `none` from 1024 down, where the cards are hidden (9 classes, 12 boxes) | 7 | 187–193 | none | **No** |
| Tablet and phone cards, shown from 1024 down: one photo to 768, another from 767 (6 classes) | 10 | 187, 194–201, 203 | none | **No** |
| `<img>` inside a Code element or Rich Text | 0 | – | – | – (no library picture is carried this way) |

(187 and 188 are counted in two rows: 23 different background files in all, ids 176 and 183–204.)

Not uploaded, and not part of this job: 12 files the capture holds without an address, 3 WPForms plugin files (a
spinner SVG, two flag sprites), 4 `data:` SVG backgrounds already inside the paste, and one background left on its old
address because the capture holds no file of it (`Untitled-1600-x-300-px-1.png?fit=1600%2C300`; a follow-up).

**Alt text does not decide it.** Three Image elements have no alt in Media (181, 205, 207) and are clickable Images;
every non-clickable photo is a CSS background. The code never reads alt to choose the element: `imageSettings`
(`src/core/site/media.ts:22-27`) makes an Image for every `<img>` the map holds, and `uploadList` gives a file an alt
only from an `<img>` (`tools/lib/site-upload/pictures.ts:143`), so a background's file always goes up without one.

## Root cause (one cause for all 23)

- The site route has no Bricks control for a background picture: `src/core/site/controls.ts:66-90` (`RULES`) ends at
  `background-color` (line 89); `background-image` and `background-size` have no rule, so `controlsFor` leaves them in
  `custom` (`controls.ts:124-128`) and they are printed as the class's `_cssCustom`.
- The media map only swaps the address inside that CSS text: `src/core/site/convert.ts:226-232` (`rewrite` →
  `toLibrary`, `media.ts:67-72`). The media id reaches the paste only through `imageSettings`, for `<img>` elements.
- So Bricks' builder holds no picture for these boxes. What Bricks needs is the Background control's image:
  `_background.image = {id, filename, size, full, url}` (the shape Bricks' own control wrote in Justin's sample,
  `reference/bricks/hero-video-buttons.json`; `reference/bricks/README.md` "Paste rules": a pasted `_background.image`
  is left alone, never swapped for the placeholder).

## What Bricks does with the control (read from its code, not memory)

`planner/bricks-2.2-assets.php` (Bricks 2.2, public GPL copy), control type `background`, lines 1971–2108:

- `image`: prints `background-image: url(<image.url>)` (L2019, L2027, L2051). The id is only for the builder.
- `size`: prints `background-size: <size>` unless it is `custom`; then `custom` holds the value (L2091-2101).
- **An image without `size` gets `background-size: cover`** (L1967 `$background_size`, L2104-2107). So a control that
  holds an image must always hold its size, in the same object (base and each `:<breakpoint>` object alike).
- `repeat`, `position`, `attachment`, `blendMode` print only when set (L2056-2089): unset, nothing is printed.
- Bricks prints a class's controls as `.<class>.brxe-<element>` (weight 0,2,0): its base controls, then its custom
  CSS (`.<class>`, 0,1,0), then its tier controls (`test/browser/render-order.ts:1-5,22-25`, read from B-Dry staging).
  So a control out-weighs the class's own custom CSS at every width: `background-image` and `background-size` are
  either wholly controls or wholly custom CSS, never split. The other background properties stay custom CSS as today.

## The fix (general: every scanned site, only with a media map)

New pure module `src/core/site/background.ts`, called from `convert.ts` where a class's blocks are made (around
`convert.ts:279-288`), only when `opts.media` is set:

```ts
// states: the element's full declarations per range (widest first), as the paste writes them (after rewrite/fix/named)
// ranges: pr.ranges; shown: t.node.shown (range ids where the element shows; [] = never shown: every range counts)
export function backgroundControl(states: CodeDecls[], ranges: string[], shown: string[], media: SiteMedia):
  { settings: Settings } | { why: string } | null   // null: no library picture in its own background
```

The rule:
1. **Ranges that count:** those the element shows in (`shown`); when it shows in none (a closed answer, a box the
   capture opened), every range. A value at a width where the box isn't drawn decides nothing.
2. **A range's picture:** its `background-image` parsed with `value.ts` `parse` is exactly one `url()` whose address is
   a library picture's `url` (reverse map of `media.pictures`), or one `image-set()` whose every `url()` is that same
   library picture **and** whose `background-size` is `cover` or `contain` (a density then can't change what is drawn).
   Its size is `background-size`, or `auto` when the range declares none.
3. **Bricks' bands:** base (992 up) and `BRICKS_TIERS` (`controls.ts:16`; 768–991, 479–767, to 478). A band's value is
   known when every counted range overlapping it has the same picture (by library `url`) and size; a band no counted
   range overlaps takes the band above.
4. **All or nothing:** every band known and holding a picture → controls; else `{why}` (the first of: several layers
   or a gradient in the value; a photo outside the library; no photo at some width it shows in; a change between
   Bricks' breakpoints at `<px>`). `convert.ts` also skips the rule (a `why`) when `background-image` or
   `background-size` is in `keep` (a state or held animation frame changes it) or `t.place === "inner"`.
5. **Settings:** `_background: {image: {id, filename, size: "full", full: url, url}, size: …}`; for each narrower band
   whose value differs from the band above, `"_background:<bp>"` with the image when the photo differs (always with
   its size, see Bricks' cover default) or the size alone. Size: `cover`/`contain`/`auto` as `size`; anything else
   `size: "custom", custom: "<value>"`.
6. **In `convert.ts`:** when it returns settings, take `background-image` and `background-size` out of every state
   before `blocksOfStates`, and merge the settings into `split.settings` key by key (`{...split.settings[k],
   ...bg[k]}`: the colour control already lives in `_background`). Position, repeat, attachment and every other
   declaration stay where they are today. `uses` and `librarySource` are untouched (`rewrite` still records them).
7. **Notes** (notes.txt, per part): one line with the count ("N background pictures are in their box's Background →
   Image setting: click the box, its class, Style → Background") and one line naming each library background that
   stays CSS with its `why`.

`src/core/site/media.ts` and `tools/lib/site-upload/` are **not edited** (the other job, media-avif-alt, works there).

**Test renderer** (`test/browser/render.ts:55-62`): print `_background` as Bricks does (above): `background-size` from
`size`/`custom`, `cover` only when an image has no size; `background-position` and `background-repeat` only when set
(today it prints `0% 0%` and `no-repeat` when unset, which at 0,2,0 would wrongly beat the class's custom CSS in
`site:check`). The Figma route always writes `size` and `repeat` (`src/core/emit/settings.ts:146-149`); if a drawn
page's browser receipt or the corpus moves, stop and report, don't touch emit.

**Expected on Justin's run** (from `planner/shown.txt`): all 22 files 183–204 become settings in page.json and
footer.json (the flip faces: base; the tablet/phone cards: base + `_background:mobile_landscape`; the map box:
base + a `custom` size on `mobile_landscape`). 176 sits in the header's opened menu box: a setting too, or named.

**Unchanged:** without a media map nothing runs (the plain `site` route, `site:check`, the panel, Figma designs: byte
for byte). With a media map, a paste with no box background from the library is byte for byte as today.

## Acceptance criteria (all **proposed**)

- AC1 (proposed): Given a capture and a media map, a box whose own background is one library picture at every width it shows in carries it as `_background.image` (`id`, `filename`, `size: "full"`, `full`, `url`) with its `size` in its class's settings, and the class's custom CSS names neither `background-image` nor `background-size`; its position, repeat and attachment stay in the custom CSS as before. Test: `test/unit/site-background-control.test.ts` "AC1 a box's own library background is its class's Background image setting"
- AC2 (proposed): A photo per screen width follows Bricks' breakpoints: another photo or size from 767 down is `_background:mobile_landscape` (an image always with its size, any size but cover/contain/auto as `custom`); a width the box isn't shown at decides nothing (a photo on wide screens with `none` where it is hidden, a box shown only from 1024 down, an `image-set()` of one library photo with cover). Test: `test/unit/site-background-control.test.ts` "AC2 a photo per Bricks breakpoint, hidden widths and image-set"
- AC3 (proposed): A background a setting can't hold without changing the look stays custom CSS exactly as today and the notes name it with its reason: a gradient or second layer in the value, a photo outside the library, a `::before`/`::after` photo, a hover look's photo, a mask, a change between Bricks' breakpoints while shown, no photo at a width it shows in. Test: `test/unit/site-background-control.test.ts` "AC3 what the setting can't hold stays custom CSS, named"
- AC4 (proposed): The page looks the same: drawn by the test renderer in Bricks' print order at every captured width, each box's computed `background-image`, `background-size`, `background-position`, `background-repeat` and `background-attachment` from the new paste equal those from the same capture and media map converted with `backgroundControl` switched off. Test: `test/browser/site-background-control.test.ts` "AC4 the setting draws the same background at every width"
- AC5 (proposed): Nothing else changes: a conversion without a media map, and one whose media map holds no box background, give the same payload as with the rule switched off, and the existing media tests pass with only the box-background expectations of `site-media-convert.test.ts` moved from custom CSS to the setting. Test: `test/unit/site-background-control.test.ts` "AC5 no media map or no box background: the paste is unchanged"
- AC6 (proposed): Justin's saved run, remade offline from the copy in the evidence folder with its media.json: every one of the 22 files with ids 183–204 is the image of a `_background` or `_background:<bp>` setting of a class in page.json or footer.json, 176 is one in header.json or is named in its notes with the reason, no class's custom CSS still names a library address in `background-image` unless the notes name it, and notes.txt carries the count line. Test: `test/unit/site-background-run.test.ts` "AC6 the saved run: every uploaded background is a Background image setting" (runs only with `F2B_MEDIA_RUN=<folder holding the capture and paste/media.json>`)
- AC7 (proposed) (live): Justin remakes the pastes from his scan with the new build (`npm run site -- <capture> <out> --elementor --media <out>/media.json`, no new upload), pastes header, page and footer on B-Dry staging, and for each box with a background photo: click the box, click its class, Style → Background shows the photo and a click on it opens the media library; the page looks the same on desktop, tablet and phone. Paste check: the next free number in HANDOFF's "End-of-run check list" (3dz if still free).

## Touched files

- New: `src/core/site/background.ts` (the rule, under 120 lines), `test/unit/site-background-control.test.ts`,
  `test/unit/site-background-run.test.ts`, `test/browser/site-background-control.test.ts`,
  `test/fixtures/site-background-code.ts` (a generic hand-made code capture, built like
  `test/fixtures/site-page-code.ts`: one box per case of the first three criteria, nothing taken from B-Dry).
- Changed: `src/core/site/convert.ts` (the call, the merge, the notes; the tests of the fourth and fifth criteria
  convert with the rule switched off through an internal option `background: false` or an exported helper, the
  builder's choice, as long as the command line can't switch it off), `test/browser/render.ts` (`_background` as
  Bricks prints it), `test/unit/site-media-convert.test.ts` (only the expectations for a box's own background).
- Read, not changed: `src/core/site/controls.ts` (`BRICKS_TIERS`, `Settings`), `media.ts`, `blocks.ts`, `value.ts`.
- **Shared with media-avif-alt** (it changes `tools/lib/site-upload/` for format and alt): no source file by this plan.
  Both may touch `test/unit/site-media-convert.test.ts`, `docs/HANDOFF.md` and media.json's values (a new file name or
  alt there changes nothing here: the rule reads `id`, `url`, `filename`). If that job edits `src/core/site/media.ts`
  (`MediaPicture`), this one only imports from it. Whoever merges second rebases and reruns both jobs' AC tests.

## Tasks (test first; one commit a task; `npm run check` green at each)

1. Before any change: `npm run check`, `npm run test:browser`, `npm run corpus` on the base, tallies into the ledger.
   Prove the command line of the saved run: `npm run site -- <run>/bdryswi-com-home.f2b-capture.json <tmp> --elementor
   --media <run>/paste/media.json` must give the saved `header.json`, `page.json`, `footer.json` byte for byte; if it
   doesn't, find the flags that do (or record the difference) before going on.
2. The fixture and the red tests for the first three criteria (`site-background-control.test.ts`): on the base they
   fail on the missing `_background.image`, not on an import (they call `siteToBricks` as
   `site-media-convert.test.ts` does). Commit with the next task.
3. `background.ts` + the call in `convert.ts` (rule steps 1–7); the three tests green; update
   `site-media-convert.test.ts`'s box-background expectations; the unchanged test (fifth criterion) green.
4. Renderer: `_background` as Bricks prints it; the browser test (fourth criterion) red before, green after;
   `npm run test:browser` and `npm run corpus` against the base tallies.
5. The saved-run test (sixth criterion) with `F2B_MEDIA_RUN` set to the evidence `run/` folder; write the remade
   pastes to `<evidence>/builder/paste/` and `site:check` them against the capture at the usual widths, recording
   that no width is worse than the saved paste's.
6. Receipts: one screenshot per criterion (terminal captures; for the fourth, a side-by-side of one fixture box at two
   widths). Mutation check for the rule's guards (drop the size from a tier image; count a hidden range; accept a
   two-layer value): each must turn a named test red (`mutation-testing-discipline`, under the memory cap).
7. Docs & records: a HANDOFF section (the rule, Q1–Q3 as "not yet confirmed", the paste check, the follow-up: the one
   background the capture holds no file of) and the ledger; no CLAUDE.md edit (the finisher's status line only).

## Risks and stop conditions

- **Mini or Full:** Mini holds for answer A (one new source file, one changed, the renderer; no look change by
  construction). Answers B or C to Q1 are a Full job (new elements, a look check per width): stop and escalate.
- The opened menu box's photo (176): its nodes may carry no `shown` ranges; the rule then counts every range. If its
  class is prepared on another path than `convert.ts:279-288` (`open-paste.ts`), wire the same call there or name it.
- If the renderer change moves any Figma browser receipt or corpus number: stop and report.
- Estimate: builder 60–100 min; one review; verifier and auditor about 20 min each.
