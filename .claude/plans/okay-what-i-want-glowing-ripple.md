# AI picture descriptions (alttext.ai) for WordPress uploads

## Context

When the panel sends pictures to WordPress, each upload already carries an alt text (`alt_text` on `POST wp/v2/media`,
`src/ui/wordpress.ts` `uploadMedia`). That text comes from a Figma annotation, the panel's "Picture descriptions" list
(saved in the file as `f2b-alts`) or a layer name, which is usually missing or poor ("Rectangle 12" gives none). The
user wants every photo uploaded to WordPress to arrive with a real description written by **alttext.ai**, using
their API key. Bricks shows the media library's alt text, so this is what reaches the page.

**What we checked:**
- The API is `POST https://alttext.ai/api/v1/images` with the key in an `X-API-Key` header. The body is
  `{image: {raw: <base64>, asset_id}}` and the answer carries `alt_text`. `GET /account` returns `usage` and
  `usage_limit`.
- Errors come back as `error_code`: `invalid_api_key` (HTTP 403), `insufficient_credits` and `invalid_params`.
  HTTP 429 means more than 4 calls a second.
- It accepts JPEG, PNG, GIF, WebP and BMP up to 16 MB, but **not AVIF**.
- **CORS is open** (`access-control-allow-origin: *`, `x-api-key` allowed; checked with a preflight). The panel can
  call it directly, with no server in between. The manifest already allows every domain.

**The user's rulings (2026-10-14):**
1. **The AI writes every photo.** On a photo's first AI pass it replaces typed descriptions, annotations and layer
   names.
2. **Photos only.** That means image fills listed in "Picture descriptions" (`kind === "fill" && describe`). Drawings,
   rendered layers, icons and backgrounds are left alone.
3. **The description goes in WordPress's alt field.** It is not written into the file's metadata.
4. **Review comes after the upload.** Convert describes and uploads straight away. The AI's words then show in the
   list, marked **AI**. Edit one and Save, and the fix goes to WordPress and into the Figma file.

**My rulings (please confirm when you review the plan):**
- **Decorative stays decorative.** A photo marked Decorative (by annotation or in the list) is never sent to the AI;
  the Decorative mark means "no description", it isn't one.
- **Each photo is described once.** The AI's words are saved in the Figma file automatically, so a later run never
  spends a credit on that photo again. After that, the list is where you change it: your fix there beats a later
  annotation.
- **A logo placed as a PNG image fill counts as a photo** (Figma calls it an image). alttext.ai reads text in logos.
- **Language and length come from your alttext.ai account settings** (the dashboard). The plugin sends neither.
- **Only when pictures go to WordPress.** In inline mode the paste carries no alt text, so the AI isn't called.

## How it works

1. **Key.** A new "alttext.ai" box in the panel has a key field, "Save and test" (shows "N credits left" from
   `GET /account`) and a checkbox "Describe photos with alttext.ai (1 credit per new photo)", on by default.
   - The key is stored like the WordPress password: `figma.clientStorage`, on this computer only. It is never in the
     Figma file, the paste or the debug file.
2. **When a photo arrives** (`run.add`), with WordPress connected, a tested key and the checkbox on, the panel starts
   its description. This happens only if it is a listed image fill, not Decorative, has bytes, and the file has no
   saved AI words for it (`aiAlt === null`).
   - **What is sent:** a small copy of Figma's original file: at most 1024 px on its longest side, as WebP (PNG where
     the panel can't make WebP), never the AVIF.
   - **`asset_id`** is Figma's image hash. alttext.ai then hands back the description it already has for the same
     picture instead of writing a new one (the live check measures whether that also saves the credit).
   - **Pace:** three at a time. On a 429 it waits and tries once more.
3. **Upload waits for it.** The uploader gets each photo's description as a promise. A new upload awaits it just
   before its POST (AVIF encoding runs meanwhile) and sends it as `alt_text`. An earlier upload (a cache hit) gets it
   through `syncAlts`. The AI's words count as typed, so they replace whatever WordPress had.
   - **If the AI fails** (timeout, refused photo), the photo goes up with the description it had before. A note names
     it.
   - **A refused key, or no credits left, stops further AI calls for that run** (one note), but never the upload.
4. **After the run:**
   - The AI's words are saved in the file automatically (`saveAlts` with `ai`).
   - The list shows them with an **AI** tag. The tag stays while the text is still the AI's own.
   - A note says "alttext.ai described N photos".
   - If the file can't keep them (view-only), a note says the next run will describe those photos again.

## Changes

**Core** (pure; carries what the file says the AI already wrote; the paste is unchanged):
- **`src/core/normalise/notes.ts`:**
  - `described()` / `saved()` read an entry's `ai` (the AI's words).
  - `notesOf`: when the saved entry has `ai`, an annotation's `alt:` no longer replaces it (`decorative` still does).
- **`src/core/normalise/scene.ts`:** `Notes.aiAlt: string | null`.
- **`src/core/style/style.ts:201`:** `AltInfo` gets `aiAlt`.
- **`src/core/model/assets.ts`:** `Asset.aiAlt`. When a picture is used twice, merging keeps the first non-null value.

**Messages and plugin:**
- **`src/shared/messages.ts`:** `PictureInfo.aiAlt: string | null`; `AltEdit.ai?: string`.
- **`src/plugin/convert.ts:19` and `src/plugin/extract/export.ts:12`:** copy `aiAlt`.
- **`src/plugin/alts.ts` `saveAlts`:** stores `ai` from the item, and keeps an entry's earlier `ai` when a later edit
  doesn't send one. That way a fix made in the list keeps the photo marked "described".

**Panel:**
- **New `src/ui/describe.ts`** (about 150 lines), the alttext.ai client:
  - `testKey(key)` gives the credits left.
  - `createDescriber({key})` provides:
    - `describe(pic): Promise<string | null>`, which runs in lanes, shrinks the copy, posts it and reads `alt_text`
      (spaces collapsed);
    - `result()`, which gives `{described: Record<key, string>, failed, stopped}`.
  - **Reuse:** `fetchWithTimeout` and `TIMEOUTS` (`src/ui/net.ts`; add `alttext: 30000`); `decodePicture`,
    `drawPicture`, `uploadSize`, `toBlob` (`src/ui/webp.ts`); `bytesToBase64` (`src/ui/debug.ts`); `sniff`
    (`src/ui/files.ts`).
  - **No canvas** (tests or Node): it sends the original file when it is an accepted type of at most 16 MB.
- **`src/ui/uploader.ts`:**
  - `add(p, description?: Promise<string | null>)`.
  - `uploadVariant` awaits it before `uploadMedia`.
  - `syncAlts` awaits each hit's description and treats an AI text as typed.
- **`src/ui/run.ts`:**
  - Creates the describer.
  - Starts each eligible photo's description in `add`, before `uploader.add`.
  - `Outcome.described`.
  - Notes on described, failed and stopped photos.
- **`src/ui/alts.ts`:** `altRows(pictures, described)` puts the AI text in each row. `AltRow.ai` is true while the
  row's text equals the AI's words.
- **`src/ui/main.ts`:**
  - The key form and its test button.
  - `showAlts` gets `outcome.described`.
  - Auto-save after the run, through the `saveAlts` / `altsSaved` path, with the list's starting point updated.
  - The AI tag.
- **`src/ui/settings.ts`:** `Settings.ai = {key, on, tested}`, with defaults in `fromStored`.
- **`src/ui/index.html`:** the checkbox, the "alttext.ai" box (key, "Save and test", status) and the tag style.

**Elsewhere:**
- **`manifest.json`:** the network reasoning names alttext.ai.
- **`src/shared/build.ts`:** read it, then bump (currently `2026-10-08.8`, so `2026-10-14.1`).

## Process (CLAUDE.md "How each milestone runs")

1. Back up the repo to the scratchpad (`rsync -a --exclude node_modules --exclude corpus/out`), then run
   `npm run corpus`.
2. Write the plan doc `docs/plans/2026-10-14-ai-descriptions.md` with `superpowers:writing-plans`. Keep the ledger in
   `.superpowers/sdd/…/progress.md`. Run straight through, test first.
3. Run one fresh review on opus, then one fix pass, each fix test first. Then move the ledger to
   `docs/plans/…-ledger.md`.
4. **Docs:**
   - a HANDOFF section "AI picture descriptions";
   - CLAUDE.md "Where things stand" plus a decision entry with the rulings above;
   - the panel's debug-box text, which still says it holds no WordPress details, gets "or alttext.ai key" added.

## Tests (written first)

- **`test/unit/ui-describe.test.ts`** (new, using the `fetchLog` and `withCanvas` fixtures from
  `test/fixtures/panel.ts`). It covers:
  - the URL, the `X-API-Key` header, base64 without line breaks, and `asset_id` = image hash;
  - the 1024 px WebP copy, and the original file when there is no canvas;
  - `alt_text` read and tidied;
  - `invalid_api_key` and `insufficient_credits`, which stop later calls and give one reason;
  - a 429 retried once;
  - a timeout giving null;
  - at most three requests at once;
  - `testKey` credits.
- **`ui-uploader.test.ts`:**
  - a new upload waits for the description and sends it as `alt_text`;
  - a failed description (null) sends the old alt;
  - a cache hit pushes the AI text through `setMediaAlt`, even over a typed WordPress alt.
- **`ui-run.test.ts`:**
  - only listed image fills are described (not drawings, Decorative photos, photos with `aiAlt`, inline mode, or runs
    without a key);
  - `Outcome.described` and the notes.
- **`ui-alts.test.ts`:** AI rows and the tag; an edited AI row is a change and loses the tag.
- **`plugin-alts.test.ts`:** `ai` is stored and kept across a later edit.
- **`normalise-notes.test.ts`:** the saved `ai` entry beats an annotation's `alt:`; an annotation's `decorative`
  still wins; `aiAlt` reaches `PictureInfo` (`style-alt` or the convert tests).
- **`debug-file.test.ts`:** the stored key never appears in the debug file.
- **`test/browser/panel.test.ts`:** the new fields exist; the stubbed alttext.ai answer shows the AI tag.
- To prove a new test catches the bug: in a scratch copy, undo the fix and see the test fail (CLAUDE.md).

## Verification

1. `npm run check` (typecheck, build, unit and rule tests) passes.
2. `npm run corpus` is no worse anywhere. Replay stays byte-identical, because the paste carries no alt text.
3. **One live call with the user's key.** The user keeps the key in a file outside the repo (for example
   `~/.alttext-key`). It is read by a small throwaway script in the scratchpad that runs `describe.ts` in Node
   (original-file path) on one JPEG and prints the description. It also prints `GET /account` usage before and after
   a repeat call with the same `asset_id`, to learn whether a repeat costs a credit. The key is never printed or
   written into the repo.
4. **The user's check in Figma** (added to HANDOFF's end-of-run list):
   1. Paste the key into the alttext.ai box and press Save and test; it shows credits.
   2. Convert with "Pictures go: to WordPress".
   3. In WordPress → Media, each photo's Alternative Text is the AI's.
   4. "Picture descriptions" shows them marked AI.
   5. Edit one and Save: WordPress shows the change.
   6. Convert again: no new credits are used.
