# Faster image export and upload, with AVIF photos

## Context

"Convert and copy" is slow when images are involved, most of all on a file's first run. The image path today runs in
strict sequence:

1. **Figma exports every image** (`exportAssets` in `code.js`: 4 at a time; photos are prefetched with
   `getBytesAsync` while the layers are read).
2. **Everything goes to the panel in one big message** (the `result`, holding every image's bytes).
3. **Only then does `ui.html` start uploading** (`resolveAssets`: 3 at a time). It then loads Google Fonts one
   family after another.

On a first run nothing is in the upload cache, so every photo goes up. In the user's debug file most photos are
**4096px originals**, and Pixel-perfect mode uploads them untouched unless they are over 4 MB. WordPress then scales
anything over 2560px down to a `-scaled` copy and serves that, so the extra pixels only cost upload and server time.

The user wants photos as **AVIF**. Findings:
- Figma can't export AVIF, and Chrome's `canvas.toBlob("image/avif")` quietly returns a PNG.
- The browser does have a **native AV1 encoder in WebCodecs** (`VideoEncoder`), and an AVIF file is one AV1 key frame
  in a small HEIF box structure. So the panel can make AVIF natively, with no 3 MB WebAssembly download. This is the
  "other way".
- WordPress 6.5+ accepts AVIF only when the server's GD/Imagick supports it. On 6.8+ an unsupported host answers
  `400 rest_upload_image_type_not_supported`; older versions answer "not allowed to upload this file type".

**User decisions:**
- **Photos only** are forced to `.avif`. Icons, logos, flat graphics, transparent images and tiles stay PNG/SVG or
  the original.
- If the site refuses AVIF, **stop and tell the user**: no silent WebP fallback when AVIF is chosen.
- Being honest about speed: AVIF gives the smallest files and the fastest website. For conversion time, most of the
  gain comes from (a) not sending 4096px files and (b) running export and upload at the same time. WordPress also
  makes its thumbnails in AVIF on the server, which is a bit slower than JPEG or WebP. The "Took …" line will show
  the real split after the change.

Goal: less total time on first runs (and repeat runs), with photos going up as AVIF when the site can take it.

## Approach

### 0. Spike first (go/no-go), in headless Chrome
Throwaway page in the scratchpad, run with `--headless=new` as in the memory note on headless Chrome checks:
- `VideoEncoder.isConfigSupported({ codec: "av01.0.12M.08", width: 2560, height: 1708, bitrateMode: "quantizer" })`
  - Encode one key frame from an I420 `VideoFrame` built by our own RGB→YUV step (BT.601 full range, like JPEG).
  - Wrap it with the container writer from step 3.
  - Decode it with `createImageBitmap` and compare pixels with the source: PSNR, and mean shift per channel (catches
    colour-matrix mistakes).
  - Time it for a 4096→2560 photo.
- Pick the quantizer (start at about 30 of 63) so files are clearly smaller than WebP at 0.82 with similar PSNR.
  Choose `latencyMode` "quality" or "realtime" by speed.
- **Gate:** if AV1 encoding isn't available, colours drift, or one 2560px photo takes more than about 1.5 s, stop and
  report back. Plan B is `@jsquash/avif` (WebAssembly, single thread, speed 10) in 2–3 Web Workers loaded from
  jsdelivr, or WebP as the default.
- Save a real AV1 sequence-header OBU from the spike as a test fixture.

### 1. Stream images to the panel and upload while Figma is still exporting (`code.js`, `ui.html`)
- `code.js`:
  - `exportAssets(ctx, onItem)` calls `onItem(item, done, total)` as each export finishes. Keep `runPool` and the
    current order and pool size.
  - `convert(opts, status, onAsset)`: when `onAsset` is given, every item goes out as a
    `{ type: "asset", item, done, total }` message, and `result.assets` carries only the metadata (key, name, kind,
    width, height, error; no bytes). Without `onAsset`, `result.assets` stays as it is today, so the tests keep
    working.
  - The `onmessage` "convert" branch passes the callback.
  - Only the end of `convert()` changes, after `step("exporting images")`. Another session is editing
    `collectHovers`/`finalizeTexts`/`debugData`, so the edits stay small and away from those.
- `ui.html`:
  - New `createUploader(opts)` returning `{ add(asset), finish(), cancel() }`. It holds the worker loop, `inflight`
    de-duplication, the SVG-refused flag, the no-answer streak, fatal and partial results, taken from
    `resolveAssets`.
  - Workers wait for new items until `finish()` closes the queue.
  - `resolveAssets(assets, opts)` becomes a thin wrapper (`add` each, then `finish`), so existing tests and behaviour
    stay the same.
  - Convert click: start a run holding the received assets and, when uploads are on and the site is connected, an
    uploader. Each `asset` message runs `fixSvgViewBox`, is stored, and is passed to `add`.
  - Status shows both at once: "Exporting images 12/38 · uploaded 5".
  - `handleResult` uses the run's assets. If `msg.assets` still carry bytes (tests, old code), it adds them. It awaits
    `finish()`, and an `error` message cancels the run.
  - Cache hits no longer wait on the "is it still in the media library" check before uploads start:
    - Hits are set aside.
    - At `finish()` one batched `include=` check (100 ids per request) runs alongside the last uploads.
    - Media deleted in WordPress is dropped from the cache and uploaded then.
    - A check that gets no answer still keeps the cache, as today.
- **Fonts in parallel:**
  - When the result arrives, `loadGoogleFonts` starts at the same time as the remaining uploads.
  - Inside it, the families load together (`Promise.all`, faces kept in family order).
- Timings: `export` stays the Figma-side time. `upload` becomes the wall time of the upload phase. `timingNote` says
  the two overlap.

### 2. One photo pipeline: max 2560px, AVIF → WebP → original (`ui.html`)
- Replace the `webp` checkbox's double meaning with two settings:
  - **Photo format**: a select with "AVIF (smallest)" (the default), "WebP", or "Original file".
  - **Shrink photos to 2× their display size**: the old WebP checkbox's resize, still switched on and off by the
    Pixel-perfect toggle.
  - Migrate stored settings: `webp` → `shrink`.
  - `resolveAssets`/`embedAssets` opts: `photoFormat` defaults to `optimizePhotos ? "webp" : "original"` when it isn't
    given, so today's tests keep their meaning.
- Which files count as photos (from pixels, not layer names):
  - Never icons, never `fit === "TILE"`.
  - A JPEG is a photo.
  - A PNG, or an image Figma rendered from its layer, is decoded once and sampled on a small grid:
    - Any transparency → no AVIF. WebP (it keeps alpha) or the original.
    - Few distinct colours (flat logo or graphic) → keeps a lossless PNG, only capped.
- Size: at most 2560px on the longest side, always, which is what WordPress scales to anyway. With "Shrink" on, the
  existing 2× display rule applies instead (the cover and height handling in `optimize`). Sizes round to even
  numbers for AV1 4:2:0.
- With "AVIF" chosen, every photo goes up as `.avif`, even if the AVIF comes out bigger than the original (rare with
  4096px sources). No quiet swap to another format:
  - **This browser can't make AVIF** (no WebCodecs AV1 encoder, e.g. Figma in some browsers): stop before uploading
    any photo, with a clear message ("This browser can't make AVIF: use the Figma desktop app or Chrome, or choose WebP
    under Photo format"). Photos get placeholders; icons and logos still upload.
    - Checked once per run with `VideoEncoder.isConfigSupported`, before the first photo is encoded.
  - **The site refuses AVIF**:
    - `isTypeRefusal` also matches `rest_upload_image_type_not_supported` and "cannot generate responsive image
      sizes".
    - An AVIF refusal is a new fatal `WPError` (`code: "avif_refused"`). It stops the run the same way a rejected login
      does, keeping whatever had already uploaded, with placeholders for the rest.
    - The message says the site can't take AVIF, where to check (Tools → Site Health → Info → Media Handling: AVIF must
      be listed; it needs PHP 8.1+ GD with AVIF, or Imagick with AVIF), and that "WebP" under Photo format works
      meanwhile.
    - Nothing is remembered, so the next run tries AVIF again once the server is fixed.
- With "WebP" chosen: WebP, then the original, whichever is smaller (today's `optimize` rule). With "Original file":
  unchanged files (today's pixel-mode behaviour, including the >4 MB shrink).
- Cache keys: the original bytes' fingerprint plus the format and size, e.g. `-avif2560`, like the current
  `-webp<maxW>`/`-big`. Encoding happens only on a cache miss.
  - Photos uploaded before this change as originals go up once more as AVIF on their next run. This is noted in the
    README.
- `embedAssets` (test mode) uses the same pipeline, so embedded JSON gets smaller too.

### 3. AVIF writer (`ui.html`, pure functions so Node can test them)
- `avifEncode(bitmap, w, h)`: steps 1–4 below return an `image/avif` Blob; any failure returns null.
  1. Draw to a canvas and read the pixels.
  2. BT.601 full-range RGB→I420.
  3. `new VideoFrame(yuv, { format: "I420", codedWidth, codedHeight, timestamp: 0, colorSpace: { primaries: "bt709", transfer: "iec61966-2-1", matrix: "bt470bg", fullRange: true } })`.
  4. `VideoEncoder` → one key frame (`encode(frame, { keyFrame: true, av1: { quantizer } })`, then `flush`).
- `splitObus(bytes)`: leb128-sized OBUs. Drop temporal delimiters and keep the sequence header and frame OBUs as the
  item data.
- `parseSeqHeader(obu)`: bit reader through the AV1 sequence header (timing and decoder-model info, operating points,
  frame size bits, tool flags) up to `color_config`. It gives profile, level, tier, bit depth, mono and chroma
  subsampling/position for `av1C`.
- `writeAvif({ width, height, av1C, data })`: `ftyp` (avif, mif1, miaf, MA1B) + `meta` (hdlr pict, pitm, iloc,
  iinf/infe av01, iprp: ispe, av1C, pixi 3×8, colr nclx 1/13/6/full, ipma) + `mdat`. The iloc offset points at the
  mdat payload.

### 4. Crop-aware display size (`code.js` `assetRef`)
The "Shrink to 2×" rule treats a CSS-cropped background as if it showed at box size. When `cropCss` crops, the photo
really shows at `box / t[0][0]` by `box / t[1][1]`, so it was shrunk too far. `assetRef` records the real rendered
size for `bg` assets with a crop. This is a general fix that applies to any cropped background.

## Files

- `code.js`:
  - `exportAssets`/`exportAsset` (streaming callback), the tail of `convert()`, the `onmessage` convert branch.
  - `assetRef`: crop display size.
  - `PLUGIN_BUILD` bump: re-read the line first, since the other session bumps it too.
- `ui.html`:
  - Photo format select and Shrink checkbox (with settings migration).
  - `createUploader` with `resolveAssets` as a wrapper, and the run/stream wiring in `window.onmessage` and
    `handleResult`.
  - Photo pipeline and AVIF encoder/writer, `isTypeRefusal` plus the `avif_refused` fatal error, `loadGoogleFonts` in
    parallel, timing labels.
- `README.md`:
  - The "Why the first run on a new file is slower" paragraph, the Pixel-perfect "Images" bullet, and the settings
    list.
  - Troubleshooting: "This site can't take AVIF" and "This browser can't make AVIF".
  - Small edits only, since the other session is adding a section after "Video and logo marquee".
- Tests:
  - `tests/export.test.js`: streaming order, bytes, and a result without bytes.
  - `tests/ui.test.js`:
    - Uploads start before the result arrives.
    - Hits are checked at the end, and deleted media is re-uploaded.
    - Fonts start before uploads finish.
    - An AVIF refusal stops the run with `avif_refused`, keeping what already uploaded.
    - No WebCodecs AV1 → photos get placeholders with the message; icons still upload.
    - Every photo, and only photos, goes up as `image/avif`.
    - A graphic PNG stays PNG; the 2560 cap holds.
    - Old `webp` settings migrate.
  - New `tests/avif.test.js`: OBU split, sequence-header parse against the spike fixture, box layout parsed back
    (sizes, iloc offset = mdat payload, ispe dims).
  - `tests/bg.test.js` or `media.test.js`: crop display size.

Reuse: `runPool`, `fingerprint`, `sniff`, `optimize` (its resize maths moves into the shared pipeline), `wpFetch`,
`isConnectionError`, `uploadOne`'s retry/inflight logic, `fillAssets`, `placeholder`, `TIMEOUTS`.

## Verification

1. `node tests/run.js`: all 391 current tests, plus the new ones, pass.
2. Headless Chrome (`tests/tools/avif-check.js`, kept for later): encode a real photo with the shipped
   `avifEncode`/`writeAvif`, decode it, and check PSNR, colour shift, file size against WebP, and time per photo.
3. Cross-check the file with a strict decoder if one can be installed into the scratchpad (Pillow with AVIF). This
   matters because WordPress's Imagick/GD must read it to make thumbnails.
4. In Figma (the user):
   - Close and reopen the plugin, and confirm the status shows the new build.
   - Run on the same file with **Clear image cache** first. Compare the "Took …" line with a run before the change.
   - Check in WordPress Media that the photos are `.avif` with thumbnails.
   - On a host without AVIF, check that the run stops with the AVIF message and nothing goes up in another format.
