# Pictures to WordPress show as grey placeholders, and photos get no alt text

## Context

With "Pictures go: to WordPress", the panel uploads (or reuses) every picture and the copied JSON is correct. But after the paste into Bricks 2.3.9, every pasted picture turns into Bricks' grey 800×600 placeholder, in the editor and on the saved page. Separately, most photos get no alt text.

**What I checked (evidence, not assumptions):**
- **The paste (`Picturetowordpress`):** 134 Image elements. Each has `{id, filename, size: "full", full, url}`, the same shape as `ExampleBricks`.
  - Suspect 3 doesn't hold: `toMedia` in `src/ui/uploader.ts:28` already builds that shape.
  - All 68 media ids exist (public REST), and all 67 URLs answer 200. The AVIFs come back as `text/plain`, but Chrome draws them, as it does on the live Home page.
  - No `_background.image` or CSS `url()` pictures in this file. No class-name clashes with the site.
- **The cause, read in Bricks 2.3.9's own builder code** (`/wp-content/themes/bricks/assets/js/main.min.js` on the user's site):
  - On paste, `A = sourceUrl && sourceUrl !== bricksData.siteUrl`.
  - When `A` is true, every `image` / `image-gallery` / `svg` element whose image setting has an `id` is replaced by `{url: placeholderImage, full: placeholderImage, isPlaceholder: true}`.
  - The real picture is brought back only if the Bricks setting `pasteAndImportImage` is on.
  - On copy, Bricks writes `sourceUrl: bricksData.siteUrl`. `bricksData` has both `siteUrl` and `homeUrl`, so `siteUrl` is WordPress's site address. That matches the REST index field `url` (`https://darksalmon-badger-335429.hostingersite.com`) and `ExampleBricks`.
  - v2 always emits `sourceUrl: "https://www.figma.com"` (`src/core/emit/payload.ts:36`), so Bricks swaps every uploaded picture.
  - The header in the user's screenshot is the site's own header template, which is why its logo showed.
- **Alt text:** WordPress has alt text for the 6 pictures with descriptive names (Atlas Copco, Terex…).
  - The 27 photos and tiles are named like `12fba13f-…`, so they get none by rule.
  - v2's panel has nowhere to type a description.
  - A reused upload never re-sends its alt (M4a ruling; its "cost if wrong" has now happened).
  - Bricks' Image does show the media library's alt: the live Home page prints media 233's `alt_text` with no `altText` setting. That M4a check is now done.
- **Side finding:** the host serves only about 20 PHP requests at once. The rest get "Error establishing a database connection". This may leave a few pictures blank in the editor right after a paste. Save and reload clears it.

**User decisions this session:** bring back a descriptions list in the panel. Don't use v1 as a reference for WordPress mode, because it was never tested.

## Part A: the paste names the WordPress site as its source

- `src/ui/wordpress.ts`: new `siteAddress(wp)`.
  - It sends `GET restUrl(wp, "", { _fields: "url" })`, which works with both REST URL styles.
  - It takes `url`, uses the connection's scheme when the host is the same (as `get_site_url()` does on an https page), and drops the trailing slash.
  - On any failure it falls back to `siteRoot(wp.site)`.
- `src/ui/run.ts`:
  - When the uploader runs, `siteAddress` starts alongside the uploads.
  - In `done()`, after `fillAssets`, `payload.sourceUrl` is set to that address.
  - Inline mode and not-connected runs keep `https://www.figma.com`; their pictures have no `id`, so Bricks leaves them alone.
  - New note: "Paste into a page on <site>. On any other site Bricks shows its grey placeholder instead of these pictures."
- This one payload-level value covers every place a picture sits: Image elements, `_background.image` and CSS `url()`. Bricks only swaps image-type controls, and only when `sourceUrl` doesn't match.

## Part B: picture descriptions

**Storage.** Descriptions live in the Figma file: `figma.root` plugin data `"f2b-alts"` = JSON `{ "hash:<imageHash>" | "<nodeId>": {alt, decorative} }`.
- Photos are keyed by the image file, which matches WordPress keeping one alt per file.
- Rendered and SVG pictures are keyed by layer.
- No problems with layers inside instances. The descriptions are shared with anyone who opens the file.
- Per-layer `f2b-alt` is still read.
- Order: annotation, then file store, then layer data, then descriptive name.

**Files:**
- **Extract:** `PluginApi` gets `rootData(key)` / `setRootData(key, value)` (`src/plugin/extract/api.ts`). The snapshot gets an optional `alts?: string` (raw JSON, `src/core/snapshot/schema.ts`), filled where the snapshot is assembled. Old debug files simply lack it.
- **Normalise:** `notesOf(n, alts)` (`src/core/normalise/notes.ts`; `ctx.snap.alts` in `normalise.ts`).
  - It looks up by node id, else by the hash of the node's first visible image fill.
  - Also fix the M4a deferred minor: an annotation's `alt:` clears a saved `decorative`.
- **Core:** `Asset` gets `describe: boolean` (`src/core/model/assets.ts`; merged with OR in `add`).
  - Set in `style.ts` `picture()`: true unless the alt came from the icon rule.
  - Background fills from `paint.ts` stay false, since CSS backgrounds carry no alt.
  - `PictureInfo` gets `nodeId` and `describe` (`src/shared/messages.ts`, `src/plugin/convert.ts:19`).
- **Plugin messages (`src/plugin/main.ts`):**
  - `saveAlts {items}` merges into the file store and answers `altsSaved {saved, error?}`. A view-only file says so.
  - `show {nodeId}` selects the layer and zooms to it.
- **Panel logic, DOM-free:** new `src/ui/alts.ts`.
  - `storeKey(pictureKey)`: `fill:<h>` becomes `hash:<h>`, and `svg:`/`node:<id>` becomes `<id>`.
  - `altRows(pictures)`: pictures with `describe`, missing first, prefilled (alt `""` means Decorative is ticked).
  - `changedAlts(rows, typed)`.
  - `pushAlts(changes, media, wp, cache)` updates WordPress three at a time and returns counts and failures.
- **WordPress:** new `setMediaAlt(wp, id, alt)`, which POSTs `wp/v2/media/<id>` with JSON `{alt_text}`.
- **Panel UI (`src/ui/index.html`, `main.ts`):**
  - A `<details id="altBox">` titled "Picture descriptions (N missing)".
  - Each row: name, text box, Decorative tick, and "Show".
  - "Save descriptions" saves to the Figma file and updates WordPress for pictures from the last run.
  - Status: "N saved in the Figma file, M updated in WordPress. Bricks reads WordPress' alt text, so no new paste is needed."
  - In inline mode: "They reach the page when pictures go to WordPress."
  - `main.ts` keeps the last run's pictures and its key → media id map (`Outcome` gets `media: Record<string, number>`).
- **Reused uploads send changed alt:**
  - `MediaEntry` gets `alt?: string` (`src/ui/wordpress.ts`), set to what was sent at upload.
  - In `finish()` (`src/ui/uploader.ts`), after `checkHits`, live hits whose picture alt is non-null and differs from `entry.alt` (unknown counts as different) get `setMediaAlt`, three at a time.
  - A null alt never erases what someone typed in WordPress.
  - A failure is a note and never fails the picture.
  - The Images note adds "(N alt texts updated in WordPress)".

## Tests first (generic fixtures; panel stand-ins in `test/fixtures/panel.ts`)

- **New `test/fixtures/bricks-paste.ts`:** Bricks 2.3.9's paste rule as read from its code. It swaps id'd image settings on image elements when `sourceUrl` isn't the site.
- **`test/unit/ui-run.test.ts`:**
  - A WordPress run whose payload holds an Image element, a Div with `_background.image`, and a `_cssCustom` `url()` token.
  - After `bricks-paste` with the site's address, all three keep their media.
  - With the old `sourceUrl`, the Image would be swapped. This proves the fixture catches the bug.
  - The address comes from the index `url` (scheme aligned, slash dropped), and falls back to the typed site if the index fails.
  - Inline and not-connected runs keep figma.com.
- **`test/unit/ui-wordpress.test.ts`:** `siteAddress` in both REST styles; `setMediaAlt` request shape.
- **`test/unit/ui-uploader.test.ts`:** a reused upload with a changed or unknown alt gets one update; an equal or null alt gets none; a failed update is a note; a new upload stores its alt.
- **Core tests:**
  - `normalise-notes.test.ts`: file store by node id and by image hash, order of sources, annotation alt clears decorative.
  - `style-alt.test.ts`: `describe` is false for icons and backgrounds.
  - `plugin-convert.test.ts`: `PictureInfo` fields.
- **New `test/unit/ui-alts.test.ts`:** `storeKey`, `altRows`, `changedAlts`, `pushAlts` (WordPress updates, cache alt set, failures).
- **Plugin `saveAlts` merge:** fake `PluginApi`; a view-only refusal is reported.
- **Fixture changes:**
  - `media` in `test/fixtures/panel.ts` answers the REST index without using up an id.
  - The browser `STUB` in `test/browser/panel.test.ts` answers `media/<id>` updates and the index.
- **Proof:** in a scratchpad copy, undo each fix and check that its test fails.

## Process (CLAUDE.md)

1. Back up the repo to the scratchpad (`rsync -a --exclude node_modules --exclude corpus/out`). Copy this plan to `docs/plans/2026-10-07-wordpress-pictures.md`, with a ledger in `.superpowers/sdd/`.
2. Run `npm run corpus` before and after. Replay payloads must stay byte-identical; the fix lives in the panel.
3. Bump `BUILD` in `src/shared/build.ts`: read it first (now `2026-10-07.17`), then `.18`.
4. Run `npm run check`, then `npm run build` and the browser panel test.
5. One fresh review on opus, then one fix pass, test first. Move the ledger to `docs/plans/`.
6. Docs:
   - `reference/bricks/README.md`: the paste rule, with its source.
   - `docs/HANDOFF.md`: the fix, the descriptions list, the M4a check done, and the reversed ruling on reused alts.
   - `CLAUDE.md`:
     - Working-in-repo bullet: Bricks swaps pasted pictures unless `sourceUrl` is the site's address.
     - Decisions: the descriptions list (user, 2026-10-07).
     - Note that the user never tested v1's WordPress mode.

## Verification

- **Automated:** `npm run check` green; the new tests fail on the unfixed copy; `npm run corpus` no worse; replay byte-identical.
- **User steps in Figma and Bricks** (reported in plain words at the end):
  1. Reload the plugin; the panel shows build `2026-10-07.18`.
  2. In Bricks, delete the sections pasted before. Their pictures were saved as placeholders and won't come back.
  3. Convert with "to WordPress". Expect "0 uploaded, 92 reused" and the "Paste into a page on darksalmon-badger…" note.
  4. Paste into a page on that site. If a few pictures stay blank right after the paste (the host's 20-request limit), press Save and reload.
  5. View the page: the gallery and card photos show.
  6. Open "Picture descriptions (… missing)" and press Show on a row to find the layer. Type a description and press Save descriptions.
  7. In WordPress Media, that photo's Alternative Text field shows it. On the live page, right-click the photo, choose Inspect, and the `alt="…"` is there.
