# Hero video: do what v1 did

## Context

The user's hero (hydraulics home page, `corpus/files/hydraulics-home.json`, node `513:2115`) has a rectangle with a
Figma **video fill**. It pastes as an empty Div (`rcdagt`), so the hero shows only the section colour and overlay: black.

**Root cause:**
- `normalise/paints.ts:40-44` `paintsOf` drops `type: "VIDEO"` paints with no warning.
- The layer then has no fills, so `normalise.ts:49` makes it a `"shape"` and `style.ts:266` an empty Div.
- v2 never ported v1's video support (README lists video as "deferred").

**Figma's limit:**
- Plugins get only a `videoHash`, never the video file.
- v1 (`~/Desktop/figmaplugin/code.js:5775-5832`, README "Video") worked around this: a video layer becomes a Bricks
  Video element when it has an address, either in its name (`Video: https://…/hero.mp4`) or as a prototype Open link.
  Without one it stays a picture and a warning names it.

**The user's ruling (2026-10-19): "just do what v1 did".** So there is no new panel box or upload. The address comes
from the layer, as in v1.

**For their hero:** one change in Figma, then Convert. Rename the layer, or give it an Open link, to the video already
on their site: `Video: https://darksalmon-badger-335429.hostingersite.com/wp-content/uploads/2026/09/All-Type-Hydraulic-Cylinders-Reliable-Hydraulic-Cylinder-Solut-1.mp4`.

**Bricks keys:**
- from Bricks' official Video schema (`academy.bricksbuilder.io/schema-resolved/elements/video.json`, the same source
  as `form-schema.json`). v1 used the same keys, "from Bricks' published schemas";
- confirmed by the user's own sample `reference/bricks/hero-video-buttons.json` (`videoType: "file"`, `fileUrl`,
  `fileAutoplay`).

## v1's rules, carried over

1. **Which layers are videos:**
   - a layer with a shown Figma **video fill** (v2 adds this, from structure; v1 missed this hero because the name
     doesn't say "video");
   - or v1's name rule: a layer whose name says "video" (`VIDEO_NAME`) and that holds no text.
2. **Its address:**
   - a URL in its name (v1's `URL_IN_NAME`, through the existing safe-URL check);
   - else its prototype Open link. That link is the video's source, so the layer is no link.
3. **Source:** `youtube.com`/`youtu.be` → YouTube (`youTubeId`), `vimeo.com` → Vimeo (`vimeoId`), anything else → a
   file (`fileUrl`).
4. **A video covering its parent, which holds other layers** (a hero background):
   - plays by itself: autoplay, mute, loop, inline, no controls;
   - covers its box (`objectFit: cover`);
   - YouTube/Vimeo players are scaled to cover (v1's iframe CSS);
   - is clipped (`overflow: hidden`) and is 100% wide.
5. **Any other video:** `fileControls` / `youtubeControls`, keeping its drawn shape.
6. **Box CSS:** `aspect-ratio: auto` (the design sets the size, not Bricks' 16:9). On the ` video` part:
   `display: block; width: 100%; height: 100%`.
7. **Poster** (`videoPoster`):
   - the layer's image fill;
   - for a video fill, Figma's PNG render of the layer (its still frame), through the existing `assets.render` path.
8. **Reduced motion:** a self-playing video is hidden and its poster shows as the element's background.
9. **No address:** it stays a picture, never an empty box. With a video fill, that picture is its still frame. The
   warning says: `Video layer "<name>" has no address, so it shows as a picture: name it "Video: https://…" or give it
   an Open link`.

## Work (CLAUDE.md "How each milestone runs": plan doc, test first, corpus before/after, opus review, fix pass)

### 0. Reference
- Save the schema as `reference/bricks/video-schema.json`.
- In `reference/bricks/README.md`, add a "Video element" section. The section background video is not used: the
  user's 2.3.9 sample has `_background.videoUrl`, but the 2.4.3 schema has `_background.video.url`.

### 1. Normalise: `src/core/normalise/videos.ts` (new)
- **`videoOf(n, link)`** returns `{ url, kind: "file" | "youtube" | "vimeo", fit } | null` (rules 1-3):
  - a video fill is shown when no opaque paint lies above it (`paintsOf(above).some(opaquePaint)`);
  - FIT → `contain`;
  - the address is safe (https), using the existing link helpers.
- **`scene.ts`:** add `SceneNode.video: SceneVideo | null`, plus `hasVideo` for a video fill with no address.
- **`normalise.ts`:**
  - `hasImageFill` counts a video fill as well, so `kindOf` gives `"image"`;
  - the node builder sets `video` and clears `link` when the link is the video's address;
  - add rule 9's warning.

### 2. Understand
- `ir.ts`: add `"video"` to `ElementName`.
- `node.ts:21,51`: an image node with `video` set is made as `element: "video"`. Its role stays `"image"`, so hero
  recognition (`recognise.ts` `photoBehind`) treats it as the photo behind the words.
- `understand.ts:58`: inline mode turns only `image` into `div`. A video stays a video.
- Add `IRNode.background`, true for rule 4: it covers its parent, and that parent has other layers. It is set here,
  where the parent is known.

### 3. Style: `src/core/style/video.ts` (new), called from `picture()` (`style.ts:207`)
- **Rules 4-8:** `objectFit`, box CSS, iframe cover CSS, `overflow: hidden`, width, reduced-motion CSS with the poster's
  `__F2B_ASSET` token. Reuse the M4a reduced-motion mechanism (grep `prefers-reduced-motion` in `src/core/style`).
- **The poster asset:**
  - `assets.fill` for an image fill, `assets.render` for a video fill;
  - `describe: false`, so it isn't listed for alt text;
  - in inline mode it is the element's CSS background, not `videoPoster` (Bricks drops data in image controls).

### 4. Emit
- **`emit/elements.ts`:** a `video` element gets rule 3/4/5's keys and `videoPoster: {__asset}` in place of `image`.
- **`emit/settings.ts:145`:** a video writes `objectFit`, not `_objectFit`.
- **Asset filling:** check that `fillAssets` (`model/assets.ts:76-89`) fills `videoPoster`.
- **`payloadProblems`:** fails on any video key not in `video-schema.json` (or a common `_` key).

### 5. Renderer
- `test/browser/render.ts` draws a `video` as `<video poster muted loop playsinline>` with its `objectFit`, and adds the
  keys to `DRAWN`.

### 6. Tests (generic fixtures)
- **Normalise:**
  - a video fill with a name URL → video `file`;
  - an Open link → video, and no link;
  - YouTube and Vimeo addresses;
  - an image-filled layer named "Hero video" with a link → video, its image as the poster;
  - a video fill with no address → an image showing its render, plus the warning;
  - an opaque solid above the video → no video;
  - a layer named "video" holding text → not a video.
- **Emit:**
  - a background video → schema-only keys, autoplay/mute/loop/inline, `objectFit: cover`, poster, reduced-motion CSS;
  - a non-background video → controls;
  - inline mode → stays a video, poster in CSS;
  - a hero with a video behind its words is recognised as a photo hero.
- **Replay matches the plugin:** `plugin-convert.test.ts` stays byte-identical.
- **Prove the test catches the bug:** `git checkout HEAD~1 -- <fix files>` → the tests fail.

### 7. Docs
- `docs/HANDOFF.md` section "Hero video": cause, v1's rules, and the user's one step in Figma.
- README: video is no longer deferred.
- At merge: the main folder's CLAUDE.md, and `BUILD` bumped in the main folder only.

## Verification
1. `npm run check` and `npm run test:browser` pass.
2. `npm run corpus`:
   - no width is worse;
   - the hydraulics hero holds an Image (its still frame, with the warning), not an empty Div;
   - the other files are unchanged.
3. Replay a copy of the hydraulics file with the layer renamed `Video: https://…Solut-1.mp4`:
   - `bricks.json` has the `video` element with that `fileUrl`;
   - `npm run snap` in Chrome shows it playing, muted, covering the hero behind the words at 1728/1440/390.
4. **Owed by the user**, one action at a time:
   1. In Figma, rename the hero's video layer to `Video: <their mp4 address>`.
   2. Convert, then paste into Bricks and save.
   3. Purge LiteSpeed.
   4. Preview: the video plays behind "We keep you moving".

**Unverified until that paste:** that Figma's PNG export of a video-filled layer shows a frame, and the Video element on
the user's Bricks 2.4.x.
