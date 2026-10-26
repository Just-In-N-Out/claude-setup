# Faster "Exporting images" on a first run (photos unchanged)

## Context

**What the user sees:** on a new Figma file, the first copy of a page sits a long time on **"Exporting images N/N…"**.

**What they decided:**
- Photos must stay exactly as they are: original files, no resizing, no format change.
- So the fixes go at the Figma export step and at what the panel shows. The image bytes and the Bricks output stay
  the same.

**Why that step is slow:**
- **One image at a time.** `exportAssets` (code.js:4275-4316) awaits every `getBytesAsync` / `exportAsync` in a
  `for` loop.
- **Figma has to download photos first.** On a file that was just opened, Figma must first fetch each full-size photo
  from its servers. Some of the service page's photos are up to 2731×4096.
- **Downloads start too late.** They only begin after reading interactions, measuring every text line, building the
  elements and reading styles (`convert`, code.js:4652-4721). Nothing overlaps.
- **"N/N" also covers the start of the upload.** After the last export, the panel keeps saying
  "Exporting images N/N…" through three steps:
  - the one big `postMessage`;
  - the fingerprinting of every byte (ui.html:346-359);
  - the first three WordPress uploads, because "Uploading images d/N" only appears after an image *finishes*
    (ui.html:405, 690).

  So part of the wait blamed on "exporting" is uploading full-size photos.
- **An icon in SVG mode is exported twice, one after the other** (code.js:4305-4306).
- **Every named image makes a second WordPress request** just for its alt text (ui.html:254-263).

**Goal:** the Figma step overlaps and runs in parallel, and the panel always says what's really happening and how
long each step took. There is no change to any image or to the Bricks result.

## Changes

1. **Start downloading photos as soon as the run starts** (code.js `convert`).
   - Right after `allRoots` is known (code.js:4687), walk the frames being converted and collect the unique
     `imageHash`es of visible IMAGE paints (reuse `walk`, `fillsOf`, `isVisible`).
   - Fetch them in the background with at most 4 at once: `figma.getImageByHash(h).getBytesAsync()`.
   - Keep the promises in `ctx.prefetch[hash]`. Each one catches its own error, so there are no unhandled rejections.
   - The downloads then overlap with reading interactions, measuring text and building the elements. They also warm
     Figma's copy of photos that are exported as layers (crops, filters).
2. **Export a few at a time** (code.js `exportAssets`).
   - A pool of 4 replaces the serial loop, and results are written by index, so the order stays the same.
   - `source: "fill"` uses `ctx.prefetch[a.hash]`, or fetches if it's missing.
   - An icon's PNG and SVG exports run together.
   - The export settings are unchanged: same format, scale and bounds, so the bytes are identical.
   - Progress reads "Exporting images i/N…", counting finished items.
3. **The panel says what's happening** (ui.html).
   - "Preparing N images…" shows before fingerprinting.
   - "Uploading images 0/N…" shows the moment uploads start, then updates as each one finishes. An upload taking
     long now shows under "Uploading", not "Exporting".
4. **Timings.**
   - `convert` records the time for each phase (reading, text, building, export). The UI adds prepare, upload and
     fonts.
   - The final status gets one line, e.g. "Took 1 m 12 s: exporting 21 s, uploading 44 s (first run: 38 new images)".
   - `debugData` gets a `timings` field from the last run, so a slow run can be diagnosed from the debug file.
5. **Alt text in the upload request** (ui.html `upload`).
   - Send `alt_text` as a query parameter on the media POST, since WordPress sets it on create. This saves one request
     per image.
   - Fall back to the second request only if the response comes back without the alt text.
6. **README**
   - The first run uploads every image and later runs reuse them (per site and per computer).
   - The export overlaps and runs in parallel.
   - The new timing line.

## Files
- `code.js`: changes 1, 2 and 4. Keep the sandbox word rules (no "import" followed by `(`, `//` or `/*`; no
  `<!--` / `-->`), and bump `PLUGIN_BUILD`.
- `ui.html`: changes 3, 4 and 5.
- Tests:
  - new `tests/export.test.js`, using the vm harness `tests/harness.js` with a fake `figma` whose `getBytesAsync` /
    `exportAsync` resolve after a delay;
  - `tests/ui.test.js` for the UI parts.
- `README.md`

## Verification
- **`node tests/run.js`, all green.** New tests:
  - the exports return the same items, with the same bytes, in the same order as the serial loop;
  - no more than 4 are in flight at once, and it is faster than serial with delayed fakes;
  - the prefetch starts before text measuring, and each hash is fetched once, even when it is used by several layers
    or also exported as a layer;
  - a failed download still becomes that item's `error`;
  - "Uploading images 0/N…" is shown before the first upload finishes;
  - the media POST carries `alt_text` with no second request, and the fallback still works;
  - the timing line appears, and `debugData` includes `timings`.
- **Replay** the service page debug file (`tests/tools/replay.js`): the Bricks payload is identical to the current
  build.
- **The user** reruns a first copy on a new file. The status line now shows how long exporting and uploading took,
  which shows whether the remaining time is Figma or WordPress.
