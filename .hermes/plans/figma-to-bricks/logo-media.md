# logo-media: a linked logo or picture the media library holds pastes as its Media item (Mini, bug)

Planner: Fable 5.2 high, 2026-11-16. Base: `main` = `ebc7b1d9` (Build 2026-11-16.2). Website importer only (the Elementor
step); the Figma plugin makes its Images another way and is untouched. Docs copy for the build:
`docs/plans/2026-11-16-logo-media.md`. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/logo-media/`.

## Questions for Justin (⭐ = taken under the standing auto-go)

- **Q1. The Custom alt text of these linked pictures.** Every other Image a media map moves to the library keeps its
  old-site alt as Custom alt text only where it differs from the library's words (so the logo, whose old alt is the
  library's, shows the library's and follows an edit in Media). **⭐ A: the same rule for the linked ones** (one rule
  for every Image). B: always keep the old site's alt on linked pictures.
- **Not a question, a fact:** headers and footers already pasted keep the old address until they are pasted again
  (Make pastes again, then paste the header and the footer). Nothing on WordPress has to be uploaded again: the map
  already holds these files (the logo is Media item 175).

## Playback

1. After the upload, the home and About pastes still show the header logo from `https://bdryswi.com/…` although the
   media map holds that file (item 175): in Bricks the logo's Content → Image says an outside address, not a Media item.
2. The same file's picture in the drawer photo beside it does come from Media (id 216), so the map is read; one kind of
   picture misses it.
3. Wanted: every picture the map holds pastes as its Media item, the logo still linked to the front page, nothing else
   in any paste moved, and pastes made without a media map exactly as before.

(The logo's click was looked at by Justin on the live page: it works; the front page showing the blog index is his
Settings → Reading. Not part of this job.)

## Root cause (proven)

Three places make a Bricks Image from a site `img`. Two ask the media map; the third writes the old address by hand:

| Producer | Code | Asks the map? |
|---|---|---|
| an `img` alone | `src/core/site/kinds.ts:119` → `imageSettings(url, alt, ctx.media, fileOf)` | yes |
| a link around one picture, any site (site-no-div) | `src/core/site/natives.ts:94` → `imageSettings(src, alt, media, fileOf)` | yes |
| **the Elementor step's linked picture** (an Image widget or Site Logo widget, `theme-site-logo`, whose picture is a link: site-native-structure Q10 A) | **`src/core/site/elementor-fold.ts:489`**: `settings: { image: { url, external: true, filename: fileOf(url) }, ...altText…, link }` | **no** |

- `foldElementor` never receives the map: `FoldOptions` (`elementor-fold.ts:35`) has no `media`, and its only caller
  (`src/core/site/convert.ts:214`) passes none.
- The Elementor step runs first and its pick wins: `natives.ts` `linkedPictures` skips a link another step chose
  (`convert.ts:397-399`, `taken`), so with `--elementor` every linked Image widget and Site Logo takes the hand-written
  line.
- The picture itself is listed and uploaded all the same (`convert.ts:555-557` lists every `img` as a use), which is
  why the map holds it and the paste names the site as its source, yet the element shows the old address.
- No test reached it: `test/unit/site-media-convert.test.ts` AC2's Elementor fixture has an unlinked image widget only.
  A sweep of every hand-made and saved fixture capture with a map holding every picture leaves 0 Images on an old
  address on base (`planner/sweep.log`: 84 Images, 68 library, 0 left), so the fixtures never held the shape.

**Counts on Justin's two scans** (pastes remade from his captures with his own media.json on `ebc7b1d9`, byte for byte
his files: `planner/probe.log`, `planner/count.mjs`):

| Scan | Part | Images | From Media | Old address the map holds |
|---|---|---|---|---|
| home | header | 4 | 1 | **3** (the logo: desktop bar, phone bar, drawer; link `/`) |
| home | page | 11 | 11 | 0 |
| home | footer | 3 | 0 | **3** (footer logo → `/`; two partner badges → their sites, new tab) |
| about | header | 4 | 1 | **3** (the same three) |
| about | page | 2 | 2 | 0 |
| about | footer | 3 | 0 | **3** (the same three) |

6 per scan, all six the Elementor step's linked pictures; no other picture kind misses the map (no map address is
written anywhere else in any part, CSS included). With the fix (prototype): 0 left in all six parts, every Image from
Media, and each paste differs from today's only in those 6 elements' `image` and `altText` (classes, every other
element, notes, structure, styles and palette byte for byte: `planner/eldiff.log`, `planner/pins-proto.log`).

## The fix (general, 2 source files)

The Elementor step's linked picture takes its picture through `media.ts` `imageSettings`, like the other two producers.
Without a map `imageSettings` returns exactly today's keys in today's order (`media.ts:33`), so nothing changes there.
Nothing is keyed on a site, a widget id, a file name or an address. The proven diff is
`planner/prototype.diff` (sha256 `3b43122f…`):

`src/core/site/elementor-fold.ts`
```ts
import { fileOf, tagLook } from "./kinds.ts";
import { imageSettings, type SiteMedia } from "./media.ts";   // new line
```
```ts
// media (logo-media): the media map, so a linked picture is the library's like every other Image (media.ts imageSettings)
export interface FoldOptions { force?: string[]; opener?: (href: string, path: string) => string | undefined; names?: boolean; marker?: boolean; page?: string; media?: SiteMedia }
```
```ts
      // was: settings: { image: { url, external: true, filename: fileOf(url) }, ...(img.attrs.alt !== undefined ? { altText: img.attrs.alt } : {}),
      choice.set(linked.a, { name: "image", settings: { ...imageSettings(url, img.attrs.alt, opts.media, fileOf),
        link: { type: "external", url: href, ...(a.attrs.target === "_blank" ? { newTab: true } : {}) } }, role: "media", bare: true, absorb: true, parts: [[" > img", linked.img]] });
```
`src/core/site/convert.ts:214` (one line; the map after `opts.fold`, so the test-only `fold` option can't hide it)
```ts
      const f = foldElementor(original, map, rootPath, { ...opts.fold, opener, names, ...(opts.marker === false ? { marker: false } : {}), ...(opts.media ? { media: opts.media } : {}), page: pageSlugOf(original.web!.finalUrl || original.web!.url) });
```

**The Bricks-pro standard** (CLAUDE.md, point 5, editable content): the logo is a Media item a person swaps in
Content → Image, its alt the library's; Link to stays in its field. Looks: the element's classes and the rules under
` > img` are untouched, and Bricks sizes a linked Image's `img` by its own CSS (`:where(.brxe-image) img{height:100%;width:100%}`
plus the class's rules), so the library file (the same picture, made by `site:upload` from the same bytes) draws as the
old address did; the live check looks at it.

## Acceptance criteria (all proposed)

- AC1 (proposed): Given an Elementor page whose Image widget or Site Logo widget holds a linked picture and a media map holding that picture's address, when the pastes are made with the Elementor step, then the link is one Bricks Image whose `image` is the library's (`id`, `filename`, `size: "full"`, `full`, `url`), with no Custom alt text where the img's own alt is the library's, its Link to as before (new tab kept), the paste naming the map's site, the old address nowhere in the paste, and everything else in the paste as without a map. Test: `AC1 an Elementor linked picture in the media map pastes as its Media item, still linked` (`test/unit/site-media-linked.test.ts`).
- AC2 (proposed): Given the same linked picture, then its Custom alt text is written only where the old site's alt differs from the library's (an empty or missing alt over library words is written as empty, as for every other Image), and a map that doesn't hold its address (an empty map, a map naming other pictures) leaves the paste byte for byte as without one. Test: `AC2 its Custom alt text is kept only where the old site's differs from the library's; a map without its address changes nothing` (`test/unit/site-media-linked.test.ts`).
- AC3 (proposed): Given every hand-made and saved fixture capture plus the linked Elementor pictures, on both routes and both text modes, with a map holding every address an img of the capture names, then no Image is left on an old address the map holds and each linked capture's Image is the library's. Test: `AC3 with a map holding every picture no Image of any fixture capture pastes by an old address` (`test/unit/site-media-every-image.test.ts`).
- AC4 (proposed): Given the same captures in every variant (both routes, both text modes, both picture modes), without a media map, with an empty one and with one naming none of the capture's pictures, then the whole result (payload, notes, sources) is main's (`ebc7b1d9`) byte for byte. Test: `AC4 without a media map, with an empty one and with one naming none every paste is the base's byte for byte` (`test/unit/logo-media-pins.test.ts`, story pin).
- AC5 (proposed): Given the same captures with a map holding every picture, then the only difference from main is the picture and Custom alt text of exactly the Images main left on an old address the map holds, and each of them is the library's. Test: `AC5 with a map holding every picture only the Images the base left on a mapped old address change, and only their picture and Custom alt text` (`test/unit/logo-media-pins.test.ts`, story pin).
- AC6 (proposed): Given Justin's two scans (home and About Us, each with the media.json his upload wrote), when `npm run site` makes the pastes with that map as the importer app does, then header.json, page.json and footer.json hold 0 addresses the map holds (6 Images per scan move to Media: 3 in the header, 3 in the footer), and every other byte of the pastes and of notes, structure, styles and palette is main's. Test: `AC6 on the scans named in F2B_SCANS no picture the media map holds is left on its old address` (`test/unit/logo-media-pins.test.ts`, story pin).
- AC7 (proposed) (live): Paste check **3fe**, Justin: in the importer app pick the home scan → Make pastes again → Copy header → paste into B-Dry staging's Header template; click the logo: Content → Image shows the Media item (not an outside address) and Link to still reads `/`; the header looks as before at 1440 and 390.

## Tasks (builder, test first; one commit a task)

Worktree `.claude/worktrees/logo-media`, branch `worktree-logo-media`. Node `/home/justin/.local/node-v22.23.3/bin`.
The five test files are written and proven on the exact bytes below (red on `ebc7b1d9`, green with the diff above):
copy them as they are from `~/.hermes/plans/figma-to-bricks/evidence/logo-media/planner/tests/`.

| File in the evidence folder | Goes to | sha256 (first 8) |
|---|---|---|
| `site-elementor-linked.ts` | `test/fixtures/site-elementor-linked.ts` | `76f72133` |
| `site-media-every.ts` | `test/fixtures/site-media-every.ts` | `ce814d04` |
| `site-media-linked.test.ts` | `test/unit/site-media-linked.test.ts` | `be1e226d` |
| `site-media-every-image.test.ts` | `test/unit/site-media-every-image.test.ts` | `2526b927` |
| `logo-media-pins.test.ts` | `test/unit/logo-media-pins.test.ts` | `299fb64b` |

1. **Baseline.** `npm run check` and `npm run corpus` in the worktree; keep the tallies in the ledger
   (`.superpowers/sdd/2026-11-16-logo-media/progress.md`). Copy this plan to `docs/plans/2026-11-16-logo-media.md`.
2. **Red.** Copy the two fixtures and the three tests. Run
   `node --test test/unit/site-media-linked.test.ts test/unit/site-media-every-image.test.ts`: 3 fail, 0 pass. Expected
   messages (`planner/ac123-base.log`): the first test lists, for each of 8 cases, `image {"url":"https://site.test/img/crew-480x480.png","external":true,…}`,
   `Custom alt text "Our crew at work" though the img's own alt is the library's` and `the old address is still in the paste`;
   the sweep lists the 6 `linked.* elementor …` lines; the alt test gets `'Our crew at work'` where none is expected.
   Commit the tests (red is expected in this one commit; the next makes it green).
3. **Green.** Apply the diff above to `src/core/site/elementor-fold.ts` and `src/core/site/convert.ts`. The same
   command: 3 pass.
4. **The story pins.** Make the base tree: `git archive -o <dir>/base.tar ebc7b1d9` (the worktree's merge-base with
   `main` if `main` moved), untar into `<dir>/base`, link `node_modules` into it. Run the pins through a runner script
   (variables set inside the script, under the memory cap):
   `F2B_STORY_PINS=1`, `F2B_BASE_TREE=<dir>/base`, `F2B_SCANS=/home/justin/.cache/lgm-pl/home,/home/justin/.cache/lgm-pl/about`,
   `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 node --test test/unit/logo-media-pins.test.ts`.
   Expected: 3 pass, and the line `Images moved to the library, by scan and part: {…"home":{"header":3,"page":0,"footer":3},…"about":{"header":3,"page":0,"footer":3}}`
   (`planner/pins-proto.log`; about 2 minutes). The scan folders are the planner's read-only copies of Justin's
   `~/Downloads/bdryswi-com-home/` and `bdryswi-com-about-us/` (captures sha256 `cb57645c…` and `fe3055eb…`, media.json
   `047570ee…` and `fc5e4a24…`); never his Downloads, never the live sites. Save the log in
   `<evidence>/builder/`. One screenshot or terminal capture per AC (nothing visual changes: terminal captures).
5. **Gates.** `npm run check` (compare with task 1 by test name) and `npm run corpus` (unchanged: no Figma code is
   touched). `test/web/site-elementor-linked-image.test.ts` once (it uses no map; the no-map pin already holds its bytes).
6. **Docs & records.** `docs/HANDOFF.md`: a new section above the top `## ` heading, "A linked logo or picture the media
   library holds pastes as its Media item (logo-media, website importer; paste check 3fe owed)", with the root cause in
   two lines, the counts table, Q1's ⭐ answer as "not yet confirmed", and paste check **3fe** at the top of "End-of-run
   check list" (the words of the live criterion above). Ledger moved by the finisher to
   `docs/plans/2026-11-16-logo-media-ledger.md`. `BUILD` bumped at the merge. `CLAUDE.md` Status: one feature line with
   3fe. New standing rule for "Working in this repo", word for word: "**Every Image a site paste makes takes its picture
   through `media.ts` `imageSettings`** (logo-media): never a hand-written `{ url, external: true }`; add every new Image
   producer's fixture to `test/unit/site-media-every-image.test.ts`."

## Tests and what was proven here (planner, offline, under the 8 GB cap)

- The tests' red and green on the exact files: `planner/ac123-base.log` (0 pass, 3 fail), `planner/ac123-proto.log`
  (3 pass); `planner/pins-base.log` (the no-map pin passes on base as a characterization, the other two fail),
  `planner/pins-proto.log` (3 pass).
- Justin's scans, base against prototype (`planner/probe.log`): with `--elementor` and no map, the plain route, and the
  plain route with the map: every paste and every side file byte for byte; with `--elementor` and the map: header and
  footer differ (the 6 Images), the page is byte for byte.
- The whole unit suite in two `git archive` trees (`ebc7b1d9` and the prototype): 4065 tests, 3936 pass, 6 fail, 123
  skipped in both, the same 6 names (`planner/unit-base.fails` = `planner/unit-proto.fails`; they fail in an archive tree
  on base too, so they are that tree's, not this change's: the builder's worktree baseline decides). No existing test
  pins the old address. Both typechecks pass on the prototype with the new files.

## Files

- Source: `src/core/site/elementor-fold.ts` (3 lines), `src/core/site/convert.ts` (1 line, at 214).
- Tests: the five above. Docs: `docs/plans/2026-11-16-logo-media.md`, its ledger, `docs/HANDOFF.md`; at the merge
  `src/shared/build.ts` and `CLAUDE.md`.
- **Shared with other jobs:** `src/core/site/convert.ts` (site-fonts-import building, photo-image-all planning: one
  line here, at the `foldElementor` call), `docs/HANDOFF.md`, `CLAUDE.md` Status, `src/shared/build.ts`.
  `src/core/site/elementor-fold.ts` may also be touched by the paused fewer-kept-boxes and link-keeps-name (the
  linked-picture lines 476–493). `parts.ts`, `photo-box.ts` and `tools/` are not touched.

## Risks

- The library file's own size differing from the old address's file (a CDN size like `?w=500`) could draw another size
  where the site's CSS gives the `img` no size: the upload makes each file from the bytes the capture holds for that
  address, and the two producers that already use the map paste such pictures today; the live check looks at the header
  at 1440 and 390.
- A re-paste is needed for what is already on the site (the fact at the top).
- Mini fits: 2 source files, 4 lines, no design decision beyond Q1's "same rule".
