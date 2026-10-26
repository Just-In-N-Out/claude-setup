# Fonts dropped on the panel go to WordPress

## Context

The user's UI designer sends the font files used on a page (often a .zip, mostly desktop TTF/OTF, sometimes web
WOFF2 kits). Today the panel only loads Google Fonts. Any other family gets one note: "Not on Google Fonts, upload
these in Bricks → Custom Fonts", and until someone uploads it by hand the page shows a wider stand-in font (GRO's
Aswatama). The user wants to drag the files onto the plugin and have them on WordPress automatically, so the
pasted page shows the right font.

**Decided with the user (AskUserQuestion, 2026-10-20): use WordPress's own Font Library, and every paste loads the
fonts.** Bricks Custom Fonts can't be created from the plugin. Bricks makes them only through admin-ajax with the
builder's logged-in session; its post type isn't in REST, as the user's site's `/wp/v2/types` shows. Bricks also
doesn't read WP's Font Library. So:

- The panel uploads the files over the REST connection it already has: `/wp/v2/font-families` and its
  `font-faces`. Both routes are on the user's site (WordPress 7.0.x, Bricks 2.4.x).
- Each paste carries `@font-face` rules pointing at those files, the same way Google fonts ride today
  (`withFontCss`, the first element's `_cssCustom`).
- The fonts are not in Bricks' font dropdown (accepted).
- `src/core` doesn't change. The paste keeps `font-family: <Figma family>`, so the corpus stays byte-identical.

## Where the work happens

- Create a worktree **`fonts`** (EnterWorktree, branch `worktree-fonts`) off local `main`, now at build `2026-10-20.10`.
- Follow the milestone flow in CLAUDE.md:
  - a plan `docs/plans/2026-10-20-font-drop.md` (writing-plans skill), run without stopping;
  - `npm run corpus` before Task 1 and at the end;
  - test first, with a ledger `.superpowers/sdd/2026-10-20-font-drop/progress.md`;
  - one opus review, then a fix pass, each fix test first;
  - the ledger moves to `docs/plans/2026-10-20-font-drop-ledger.md`.
- Finish by the global steps "Worktrees from claude -w":
  - rebase on `main`, re-run check and corpus;
  - ExitWorktree keep, then `git merge --ff-only`;
  - bump BUILD, `npm run build`, commit, push `main`;
  - update the main folder's CLAUDE.md. Its bullet "Fonts not on Google Fonts…" changes.
- Plain commits only: no author override, and CLAUDE.md never staged.

## WordPress Font Library contract (verified in wordpress-develop 7.0 source)

- **Permission:** every capability is `edit_theme_options`, which means **Administrator**, for reading too. The panel's
  "a separate Author account is safest" hint must say fonts need an Administrator.
- **Create a family:** POST `wp/v2/font-families` with `font_family_settings` = a **JSON string** `{name, slug, fontFamily}`
  (no other keys). A duplicate slug gives `rest_duplicate_font_family` (400): re-read with `?slug=` and reuse it.
  `fontFamily` is stored quoted when it contains spaces; read back with the quotes stripped and the first comma item.
- **Create a face:** POST `wp/v2/font-families/<id>/font-faces`, as multipart FormData.
  - `font_face_settings` = a JSON string `{fontFamily, fontWeight, fontStyle, fontDisplay:"swap", src:"file-0"}`, plus
    the file appended as `file-0`. Every file sent must be named in `src`.
  - `fontWeight` may be `"100 900"`.
  - The 201 answer has `font_face_settings.src` = the file's URL (in `wp-content/uploads/fonts/`).
  - Errors: `rest_duplicate_font_face` counts as already there; `rest_font_upload_invalid_file_type` (400) and
    `rest_font_upload_unknown_error` (500) carry WordPress's own message.
  - Upload faces **one at a time** (Gutenberg does: the fonts folder race).
- **Allowed types:** otf, ttf (`font/sfnt`), woff, woff2. The extension must match the content. Newer libmagic reports
  TTF as `font/ttf`, which a future host would refuse; wrapping TTF/OTF as WOFF avoids that.
- **Listing:** families page by page (`per_page=100`, `rest_post_invalid_page_number` past the end). `slug` filter
  works. Faces are read per family. `_fields=id,font_family_settings` / `id,font_face_settings`. No `context=edit`.
- **CORS:** same as today's media uploads (origin `null` is echoed). Never set Content-Type on FormData.
- **WordPress doesn't print these faces itself** unless the user activates the family in Appearance → Fonts (new in
  7.0 for every theme). If they do, the result is harmless: the same files, downloaded once.

## Modules

All are in `src/ui/` and pure, except `main.ts`. Node 22 has CompressionStream, Blob, FormData and File for tests.

| File | Job |
|---|---|
| `font-names.ts` (new) | `familyKey` (NFD, lowercase, letters and digits only), `fontSlug`, `faceLabel` (shared with `loadGoogleFonts`' missing list), `cssString`, `firstFamily` |
| `inflate.ts` (new) | `inflate(bytes, "deflate" \| "deflate-raw", limit)` (stops past the limit), `deflate(bytes)`; reuses `blobOf` from `photos.ts` |
| `sfnt.ts` (new) | `formatOf(bytes)`: TTF, OTF, WOFF or WOFF2 by magic number. Refuses with a reason: a font collection (ttcf), EOT, SVG, junk. `readFontInfo` reads the `name` table (16 before 1, 17 before 2; Windows UTF-16BE first, Mac as latin1), `OS/2` (usWeightClass; fsSelection italic and oblique bits), `fvar` (wght → `"min max"`) and `head`; WOFF tables are inflated. A bounds error means "damaged". |
| `unzip.ts` (new) | Reads the end-of-central-directory, then each entry by its local header. Methods: stored and deflate. Skips `__MACOSX/` and `._*`; keeps only .woff2 .woff .ttf .otf. Refuses encrypted and ZIP64 archives; has a size cap. No CRC check. |
| `drop.ts` (new) | `droppedFiles(items)` walks folders (`webkitGetAsEntry`, `readEntries` until it returns nothing, a depth and count cap, skips `.DS_Store`). Falls back to the plain files when the entries are null. Takes a structural `EntryLike` type, so Node can fake it. |
| `font-files.ts` (new) | `pickFonts(dropped, designFonts)`: unzip, read each file, pair it with a design family, deduplicate, wrap as WOFF, check it loads (steps below). |
| `woff.ts` (new, last task) | `toWoff(sfnt)`: 44-byte header, tag-sorted directory, 4-byte alignment, zlib per table (stored when that's no smaller), checksums copied |
| `site-fonts.ts` (new) | `siteFonts(wp, families)` reads faces only for families matched by key (name, fontFamily or slug). `addFonts(wp, fonts, progress)` reads fresh, creates missing families and posts faces in sequence; a fatal error stops everything; a type, size or upload error fails only that file. `fontError(e)` gives the wording: 403 → Administrator needed, `rest_no_route` → no Font Library (WordPress 6.5+), invalid type → WordPress refused this kind of file. |
| `font-sources.ts` (new) | `siteFaceCss(design, site, https)`: every face of each matched family, under the design's exact name, with `format()` and `swap`; http becomes https. `fontPlan(design, site, google)` gives rows (site / google / missing / unchecked) and what's missing. `fontNotes`, `rowText`, `fontReport`. |
| `env.ts` | + `fontLoads(bytes)`: `new FontFace(...).load()` |
| `wordpress.ts` | `testConnection` also returns `fonts: !!capabilities.edit_theme_options`, and the connection status names the Administrator need. `explain()` is untouched. |
| `fonts.ts` | `missing` labels through `faceLabel` |
| `run.ts` | Starts `siteFonts` beside `checkLinks` when `s.wp.connected && result.fonts.length`. In `done()`, writes Google's CSS **then** the site's (CSS Fonts 4: the last same-descriptor rule wins, face by face, and Google fills the weights the site lacks). Replaces the "Bricks → Custom Fonts" note with "drop their files on the panel (Fonts)" or "connect an Administrator". Adds `Outcome.fonts: FontRow[]`. The `statusLine` test object gets `fonts: []`. |
| `index.html` + `main.ts` | A **Fonts** `<details>` box is always present: a dashed drop area ("Drop the designer's font files, a folder or a .zip"), a "Choose font files" button (multiple; .woff2 .woff .ttf .otf .zip) and a status line. Dropping anywhere on the panel works (window dragover/drop, for Files only, with a highlight). After Convert the box lists the design's families and weights with where each comes from, and opens when one is missing. main.ts gains about 50 lines of wiring only: `lastFonts`, `siteForFonts`, `sendFonts`, `showFonts`, the drop handlers, the button in `setBusy`. |

**`pickFonts` steps:**
1. Unzip any .zip.
2. Read each file's info. A WOFF2 can't be read in Chrome (no Brotli; never use Node's), so it takes, in order:
   - a sibling file with the same stem (X-Bold.woff2 beside X-Bold.ttf);
   - the longest design family whose key is a prefix of the file's key ("Grot Black" beats "Grot");
   - name tokens, after stripping `webfont`/`web`/`subset`/`latin`. Weights go through core's `weightOf`; `[wght]` or
     `Variable` in the name means "100 900"; 400 normal when nothing says otherwise.
3. The family becomes the design's exact name when the keys match ("CaviarDreams" → "Caviar Dreams").
4. Deduplicate by (family, weight, italic): woff2 before woff before ttf/otf; a variable file beats static ones.
5. TTF/OTF are wrapped as WOFF, keeping the original if the wrap doesn't load.
6. `env.fontLoads` checks each one; a file that won't load is refused with a reason.

**After an upload:** the box shows each file as added, already on your site, or refused (with why). If a conversion
has run this session, the same frames convert again (`startConvert(…, true)`, as `sendVideo` does). Otherwise:
"Added. Convert to use them." While converting: "wait for the conversion". Not connected: "connect WordPress below
with an Administrator".

**Reuse:**
- `wpFetch`, `WPError` and `restUrl` (`wordpress.ts`);
- the paging and `rest_post_invalid_page_number` handling (`site-read.ts`);
- `withFontCss` (`fonts.ts`);
- `weightOf` (`src/core/normalise/text.ts`);
- `blobOf` (`photos.ts`);
- the `sendVideo`/`showVideos` flow and `setBusy` (`main.ts`);
- `fetchLog`, `json` and `fail` (`test/fixtures/panel.ts`).

## Tasks (test first; generic fixtures only, never a real font in the repo)

1. **Fixtures:**
   - `test/fixtures/fonts.ts` builds a synthetic sfnt (head, name, OS/2, optional fvar, compressible glyf) and
     `woffOf`/`zipOf`, with `node:zlib`. The code under test never builds its own fixtures. WOFF2 is a stub.
   - `panel.ts` gets `fontsLoad(ok)` and a `fontLibrary(state)` fake fetch that records the FormData.
   - Names are generic: "Sample Sans", "Grot", "Grot Black".
2. **`sfnt.ts` + `inflate.ts`:** name priorities, Mac-only names, weight scales, italic/oblique, OTF and `true` magic,
   fvar range, WOFF compressed and stored tables read the same as the sfnt, refusals never throw, truncated → damaged.
3. **`unzip.ts` + `drop.ts`:** stored and deflated entries come out exact, as do folders, a zip comment and data
   descriptors; junk entries are skipped; encrypted, ZIP64, too-big and non-zip files are refused; for drops,
   batched `readEntries`, null entries and `.DS_Store` are handled.
4. **`font-names.ts` + `font-files.ts`:** keys, sibling naming, longest prefix, tokens, variable names, the design's
   exact name, deduplication, a zip inside a drop, a load refusal, `uploadName`.
5. **`site-fonts.ts` + `testConnection`:**
   - two pages and exactly 100; quoted fontFamily; src as a string or an array;
   - the exact FormData and JSON strings, with no Content-Type; faces sent in sequence;
   - existing families and faces are reused or skipped; both duplicate codes;
   - 403 gives the Administrator wording, never "Author"; `rest_no_route`; one bad type doesn't stop the rest;
   - `fonts` comes from `edit_theme_options`.
6. **`font-sources.ts` + `run.ts`:**
   - the CSS has the escaped exact name, the URL, `format()` and swap; unused families are left out; http → https;
     a weight range covers a weight;
   - rows; in a run the site is read in parallel and its CSS comes after Google's;
   - the notes connected and not connected; a 403 read is noted only when something is missing; `Outcome.fonts`.
7. **Panel (`index.html`, `main.ts`, `test/browser/panel.test.ts`):** the STUB gets FontFace and Font Library routes.
   - A drop of `SampleSans-Bold.woff2` → one family POST and one face POST (700, `file-0`) → `again: true` → the result
     has the `@font-face` with the uploaded URL, and the row says "your site".
   - A kit zip, with `__MACOSX` and the CSS skipped.
   - Not connected; 403; "Choose font files"; a drop while converting; a file that won't load.
8. **`woff.ts`:**
   - unit: header fields, sorted and aligned directory, each table inflates back to the original, stored tables, and
     `readFontInfo(toWoff(x))` equals `readFontInfo(x)`;
   - Chrome (`test/browser/woff.test.ts`): wrap `/System/Library/Fonts/Supplemental/Arial.ttf` at test time (skipped if
     absent); both the original and the wrap load as FontFace and measure the same width.
9. **Docs:**
   - a HANDOFF section "Fonts dropped on the panel";
   - end-of-run paste check 3v: a drop in Figma desktop, the paste shows the font in the editor and live, after
     LiteSpeed Purge All;
   - the ledger, the rulings below, and the WP box hint.

## Rulings (my calls, reported to the user at the end)

- Fonts are read whenever WordPress is connected, not only when pictures go there.
- The site's copy beats Google's, face by face, by CSS order.
- Every face of a used family goes in the CSS (only used ones download).
- Oblique is written as italic.
- Within one kit, formats rank woff2 > woff > ttf/otf, and variable files beat static ones.
- TTF/OTF go up as WOFF (about half the size), checked in the browser first.
- A face the site already has is skipped, never replaced.
- A licence note isn't shown in the panel; I mention it to the user once.

## Risks

- **Fonts need an Administrator's Application Password.** The user can revoke it.
- **Unverified:** whether Figma desktop passes file drops from Finder into a plugin's panel. "Choose font files"
  always works, and paste check 3v covers drops.
- **WOFF2-only kits with odd names** can get the wrong weight. The box shows what was read; Appearance → Fonts
  deletes a wrong one.
- **Pages pasted before** don't gain the fonts, since they ride in each paste's first element.
- **Re-converting re-exports pictures,** which is slow on big pages. The upload cache prevents re-uploads.

## Verification

- `npm run check` (typecheck, build, unit and rule tests) and `npm run test:browser` (panel and woff) pass.
- `npm run corpus` gives byte-identical pastes before and after (core untouched).
- Replay a debug file with a non-Google family through a faked site in `ui-run`. The paste's first element has the
  `@font-face` after Google's.
- Before saying it's merged:
  - `git log --oneline main` shows the feature commits;
  - `dist/` is rebuilt with the new BUILD;
  - the user's live check (3v) is listed as owed, with numbered steps: Administrator Application Password, drop the
    files, Convert, paste, Cmd+S, view the page.
