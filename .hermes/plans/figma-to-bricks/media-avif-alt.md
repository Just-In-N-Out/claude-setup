# media-avif-alt: a scanned page's photos go up as AVIF, and pictures with no alt text get AI alt text (Full)

Planner: Fable 5.2 high, 2026-11-11. Base: `main` at Build 2026-11-11.3 (`02481763`). The builder copies this file to
`docs/plans/2026-11-11-media-avif-alt.md`. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/planner/`
(every probe script and its output; nothing there holds a key or a password). All ACs are **proposed**.

## Playback (plain words)

1. When `npm run site:import` / `npm run site:upload` send a scanned page's pictures to WordPress, every JPEG, PNG and
   WebP picture goes up as an `.avif` file (see-through parts kept). SVG, GIF and moving pictures go up as they are.
2. Pictures that have no alt text get one written by alttext.ai (the service the Figma panel already uses). The
   command asks for the alttext.ai key once, saves it on this computer, and never asks again.
3. Nothing else changes: only media items are added, only on the typed site, only after a typed `yes`; an alt text
   WordPress already has is never changed; a picture that can't be made AVIF stops the run and says why.

## Questions (⭐ = the answer the builder takes under the standing auto-go)

- **Q1. Pixel size of the AVIF?**
  - ⭐ **A. The picture's own size, unchanged, with one cap: 2560 px on its longest side** (the panel's cap: WordPress
    shrinks and re-encodes anything bigger itself and serves that copy). The command doesn't know how big a picture
    shows at every width, so the panel's "2x the size it shows at" isn't used.
  - B. Never resized, even past 2560 (WordPress then makes its own smaller AVIF, encoded twice).
- **Q2. When the AVIF comes out bigger than the file?** Measured on your B-Dry scan (30 pictures, read only): all
  together 17.5 MB → 10.0 MB, but 9 come out bigger: 5 see-through logos (2 to 3 times: 7 KB → 22 KB, 109 KB → 281 KB)
  and 4 already-small JPEG photos (1 to 16 % bigger).
  - ⭐ **A. Always AVIF, as you said ("for every photo")**; the list shows both sizes for each picture.
  - B. Keep the old file when the AVIF isn't smaller, named in the list (on B-Dry: 21 AVIF, 9 kept).
  - C. Photos always AVIF; see-through graphics (logos) keep their PNG when the AVIF is bigger.
- **Q3. What stays as the old site served it?** ⭐ **A. SVG, every GIF, a moving WebP, a moving PNG, a file that is
  already AVIF, and any other type** (each named in the list with why). B. A still GIF also becomes AVIF.
- **Q4. The 34 pictures already on B-Dry staging (media 174–207; 30 of them JPEG or PNG)?**
  - ⭐ **A. A new run uploads none of them again** and says "30 pictures in your library are not AVIF". Adding
    `--reupload-avif` sends an AVIF copy of each; the old items are never changed or deleted (you delete them in
    Media if you want). The pastes then show the AVIF items.
  - B. Send AVIF copies automatically on the next run (30 more items in Media without asking).
- **Q5. A way back?** ⭐ **A. `--as-served`** sends every file as the old site served it (the behaviour before this
  job), for a site that can't take AVIF. Without it nothing ever falls back. B. No such flag.
- **Q6. Which pictures get AI alt text?** On B-Dry: 8 pictures have words; 23 are backgrounds (CSS never carries an
  alt); 3 are `<img alt="">`.
  - ⭐ **A. Every picture that goes to your library with no words on the old site**: no `alt`, `alt=""`, and
    backgrounds (26 on B-Dry). Why `alt=""` too: WordPress and Elementor print `alt=""` for every picture nobody
    described, so on a WordPress site it means "no alt text", which is what you asked to fill. Left out: SVG files and
    pictures under 50 px (alttext.ai's own WordPress plugin skips those).
  - B. Only `<img>` pictures (3 on B-Dry). C. Never `alt=""` (0 on B-Dry).
- **Q7. When is alttext.ai asked?** ⭐ **A. After the upload: the command reads each picture's alt in WordPress and
  describes only those still empty**, then writes the words on that media item. So a site whose own AltText.ai plugin
  describes uploads keeps the plugin's words and the command spends no credit there. B. Before the upload, sent with
  the file (one request fewer, but pays twice on a site with that plugin).
- **Q8. Pictures already in your library with no alt (the 34)?** ⭐ **A. Filled too, only where WordPress's alt is
  empty, only for items this command uploaded.** This widens the rule "only adds media items" by one thing: "and
  fills an empty alt text of its own items". B. Only pictures uploaded in that run.
- **Q9. The key.** ⭐ **A. Asked once at a hidden prompt right after the WordPress login, tested (it shows the credits
  left), saved in `~/.config/figma-to-bricks/alttext-key` (only you can read it).** Enter alone skips AI alt text for
  that run. `--new-ai-key` asks again and replaces it; deleting that file forgets it; `--no-ai-alt` runs without AI.
- **Q10. A wrong key?** ⭐ **A. Asked again (3 times at most), never saved; after that the run stops before anything is
  uploaded.** A saved key alttext.ai refuses is asked again the same way.
- **Q11. alttext.ai down or out of credits?** ⭐ **A. The pictures still go up; the ones not described are named; a
  later run describes only those** (nothing is uploaded twice). B. Stop the upload.
- **Q12. Language and length?** ⭐ **A. Your alttext.ai account's settings**, as in the panel. B. Always English.
- **Q13. Where the AVIF encoder comes from?** ⭐ **A. The panel's own encoder file, downloaded once from
  cdn.jsdelivr.net, checked against the panel's pinned SHA-256 on every run, kept in `~/.cache/figma-to-bricks/`.**
  B. Kept inside the repo (a 3.5 MB binary in git).

## What is there today (base `02481763`, with evidence)

- **The command sends each file as served.** `tools/lib/site-upload/flow.ts:45,58` passes `photoFormat: "original",
  shrink: false`; `flow.ts:88` makes `env.decode` reject ("each file goes up as the old site served it"). HANDOFF Q6 A
  (`docs/HANDOFF.md:1149`) and Q8 A (`:1159`) are the two rulings this job reverses (`CLAUDE.md:369`, `:675`).
- **How the panel makes AVIF** (`src/ui/avif.ts`): libavif + libaom as `@jsquash/avif@2.1.1`, downloaded from jsDelivr,
  each file checked against a pinned SHA-256 (`avif.ts:9-13`), run in Web Workers (`avif.ts:20-41,66-126`), quality 80,
  alpha kept exactly (`qualityAlpha: 100`), speed 10 (`avif.ts:14-16`). The pixels come from the browser:
  `createImageBitmap` → canvas → `getImageData` (`src/ui/webp.ts:20-42`, `src/ui/env.ts:24-25`), capped at 2560
  (`webp.ts:5,10-17`). Node has no picture decoder and the repo takes no dependency, so the command can't run this
  as it is; **the system Chrome can** (probe below).
- **The panel's AVIF path can't be reused through the uploader unchanged:** `processing()` covers PNG and JPEG only
  (`src/ui/photos.ts:54`), a PNG that isn't photo-like stays PNG (`photos.ts:28-45,78-82`), and the canvas calls are
  synchronous. Justin's answer wants every PNG and WebP too.
- **The uploader never falls back from AVIF:** `src/ui/uploader.ts:86-87` (a refused AVIF stops the run, `avifRefused`
  `uploader.ts:71-73`, fatal). A picture whose bytes are already AVIF goes up as it is under `<stem>-image.avif`
  (`src/ui/files.ts:14-23,33-36`; B-Dry's 4 AVIF files went up this way).
- **The record** (`tools/lib/site-upload/record.ts:16`, `~/.config/figma-to-bricks/site-uploads.json`, 0600) keys each
  upload by the file's fingerprint (`uploader.ts:64-67`). Justin's holds 34 entries, media 174–207: 18 `.png`, 12
  `.jpg`, 4 `.avif` (planner's read of the record's shape; no secret in it).
- **Alt today:** the old site's first alt with words (`tools/lib/site-upload/pictures.ts:69-72`); `alt=""` and no alt
  send none. The alt goes up with the file (`src/ui/wordpress.ts:106-113`, the `alt_text` query). A later run never
  changes an alt (`syncAlts: false`, `flow.ts:45`).
- **alttext.ai as the panel uses it** (`src/ui/describe.ts`): base `https://alttext.ai/api/v1` (`:13`); header
  `X-API-Key` and JSON (`:55`); `GET /account` → `usage`, `usage_limit` (`:71-76`); `POST /images` with
  `{image: {raw: <base64>}}` → `alt_text` (`:131-136`); a small copy, 1024 px at most, never AVIF (`:14-16,80-98`);
  when this process can't decode a picture, the bytes it was handed are sent as they are if alttext.ai reads their
  type (`:95-97`); a refused key (`invalid_api_key`, 401, 403) or `insufficient_credits` stops the describing
  (`:43-50`); a 429 is tried once more (`:145-148`); 3 at a time (`:17`). The same facts in alttext.ai's own WordPress
  plugin (trunk, read 2026-11-11 from plugins.svn.wordpress.org: `includes/class-atai-api.php`): the same base
  address, `GET /account` needing `usage` and `usage_limit`, `POST /images` with `image.url` or `image.raw`, 401/403 as
  a refused key, and **HTTP 422 whose first `errors` message is "account has insufficient credits"**. alttext.ai's
  docs page couldn't be fetched today (the fetch tool refused the domain), so two shapes stay unverified and the tests
  cover both: the status of "no credits" (402 in the panel's test, 422 in the plugin) and whether it carries
  `error_code`.
- **alttext.ai's WordPress plugin, when a site runs it** (`includes/class-atai.php`, `class-atai-attachment.php`): on
  `add_attachment` it describes the new upload at once (unless its `atai_enabled` setting is "no") and writes the alt
  without looking whether one exists; pictures under 50 px, over 16 MB or not jpg/png/gif/webp/bmp/avif/svg are
  skipped. WordPress's REST upload sets the request's own `alt_text` after that hook
  (`class-wp-rest-attachments-controller.php` 6.8: `create_item` L187-209, `wp_insert_attachment` L361). So an alt
  sent with the file would overwrite the plugin's and both would spend a credit: Q7 A avoids it.

## Probes (planner, all local; scripts and outputs in the evidence folder)

| Probe | Result |
| --- | --- |
| `proto-avif.ts` (the panel's pinned encoder inside the system Chrome, started offline) | a 2560×1707 JPEG → AVIF in 0.2 s decode + 0.7–3 s encode; the same bytes twice; `ftypavif`; a see-through PNG keeps alpha 0 exactly; a WebP converts; a 4000×1000 picture comes out 2560×640; a JPEG with EXIF Orientation 6 (300×200 stored) comes out 200×300; a file that isn't a picture fails with Chrome's reason; a 1024 px WebP small copy is made in the same page (`proto/proto-avif.json`) |
| `proto-avif-cpu.txt` (the desktop's `chrome-f2b` CPU flags + offline) | works; the AVIF bytes are identical to the run without the flags |
| `proto-big.ts` | 64 MB of base64 goes into and out of the page in one `Runtime.evaluate`; a `fetch` from the offline page fails |
| `probe-bdry-avif.ts` (Justin's saved scan, read only, nothing sent) | 30 JPEG/PNG → AVIF in 38 s, 0 failures; 17,450,495 B → 10,028,855 B (57 %); 9 came out no smaller (Q2) |
| `probe-capture.ts` (the same scan) | 34 listed: 12 JPEG, 18 PNG, 4 AVIF; none over 2560; alt: 8 words, 3 `alt=""`, 23 none (all CSS backgrounds); all 34 in the record |
| `probe-no-src-change.ts` (unchanged base tree, local stand-in) | the panel's uploader handed AVIF bytes sends `image/avif` as `yard-image.avif`, counts it, and stops fatally with no other upload when the site refuses AVIF; re-keying the record to `<source fingerprint>-avif-max2560` makes a second run find it; the panel's describer handed the small copy sends exactly those bytes, with the key header, to `/account` then `/images` |
| `base-unit.txt` (the related unit suites on the base, `F2B_STORY_PINS=1`) | 118 tests: 116 pass, 1 skipped, **1 already fails on the base**: `AC4 without a media map every paste is byte for byte as main makes it` (site-media-upload's story pin, stale since later jobs changed pastes on purpose). Not this job's to fix; a regression claim compares by test name. |

## Design

**No file under `src/` changes.** The panel, the Figma plugin, the capture, `npm run site` and the helper stay byte
for byte (AC15). Everything new is in `tools/lib/site-upload/`, `tools/lib/site-import/`, the two command files and
tests. (Rejected: two optional hooks in `src/ui/uploader.ts`; smaller, but the panel's bundle would change.)

### 1. Which file each picture goes up as (`format.ts`, pure)

- `kindOf(bytes)` reads the file's own first bytes: JPEG (`FF D8 FF`), PNG (moving when an `acTL` chunk comes before
  the first `IDAT`), WebP (`RIFF….WEBP`; moving when its `VP8X` flags byte, offset 20, has bit `0x02`), GIF, AVIF
  (`ftypavif`/`ftypavis`), else other.
- **AVIF:** a still JPEG, PNG or WebP. **As served:** `--as-served`; SVG; GIF; moving WebP or PNG; already AVIF; other.
- **Record key:** as served → the uploader's own fingerprint, as today. AVIF → `<fingerprint of the SOURCE
  file>-avif-max2560` (the panel's own suffix for the same change, `photos.ts:56`), never the AVIF's bytes: a Chrome
  update may change a decoded pixel, and the key must not move.
- **Already uploaded as served** (the record holds the plain fingerprint and not the AVIF key): stays, unless
  `--reupload-avif` (Q4 A). The AVIF key wins when both exist.

### 2. Making the files, before the `yes` (`encoder-files.ts`, `picture-chrome.ts`, `prepare.ts`)

- **Encoder files:** the two files `src/ui/avif.ts` pins (`AVIF_ENCODER`, imported, not copied), read from
  `~/.cache/figma-to-bricks/avif-encoder-2.1.1/` (`F2B_ENCODER_CACHE` names another folder: the tests share one);
  each checked against its SHA-256 **on every run**; a missing or wrong file is downloaded again (Node's `fetch`,
  `redirect: "error"`, 60 s) and checked before it is written (a new file, then renamed). `F2B_ENCODER_SOURCE` may
  name another source **only on 127.0.0.1/localhost** (the tests' server); anything else in it is refused.
- **A Chrome of its own** (`findChrome()` of `tools/lib/helper-chrome.ts`, launched with `launchChrome` of
  `test/browser/chrome.ts` as `site:check` does, plus `--host-resolver-rules=MAP * ~NOTFOUND`: it can reach nothing),
  one `about:blank` page, a fresh profile. It is given picture bytes only: never the password, the key, the site's
  address or a cookie. It is not a capture's Chrome (`tools/site-import.ts` still launches only through `captureRun`;
  `test/unit/capture-chrome.test.ts` keeps passing). The page runs the panel's own worker source
  (`avifWorkerSource(glue)`) with `AVIF_OPTIONS`; one picture at a time (the same bytes every run):
  `createImageBitmap` (upright by EXIF; colours converted to sRGB, as the panel's) → drawn at
  `min(1, 2560 / longest side)` with `imageSmoothingQuality: "high"` → `getImageData` → the encoder. 60 s per picture.
- **Before the `yes`,** for a real run: every new picture that goes as AVIF is made (`Making AVIF: n of N` on a
  terminal, then `Made N AVIF files (X → Y).`), and a small copy (WebP, 1024 px at most) of each picture that may be
  described. Then the Chrome is closed: no Chrome runs while anything is sent. A stop (Ctrl+C, a kill, a closed
  window) here ends the Chrome and the tool with `Stopped before anything was uploaded.` (130/143/129).
- **A picture that can't be made** (Chrome can't open it, the encoder fails or doesn't finish): the run stops there,
  **before the `yes`, nothing sent**: `"<name>" couldn't be made into AVIF (<reason>). Nothing was uploaded, and
  nothing goes up in another format. Run again; or add --as-served to send every file as the old site served it.`
  Exit 2. The encoder not to be had (no connection, a wrong file) or no Chrome: the same kind of line, exit 2;
  `site:import` checks both right after the login, before the scan.
- **A site that refuses AVIF:** the uploader's own stop (`avif_refused`), reworded for this tool: WordPress 6.5+ takes
  AVIF; nothing went up in another format; `--as-served` is the way until the site takes it. Exit 1, the record keeps
  what went up (site-media-upload's Q12 stays open).

### 3. The upload (`flow.ts`)

- The panel's uploader runs as today (`photoFormat: "original"`). A new AVIF picture is handed to it with the AVIF
  bytes as its file, so it goes up as it is under `<stem>-image.avif` (`safeFilename`: the `-image` rule holds). The
  uploader files it under the AVIF bytes' fingerprint; **every save re-keys it to the source key** (`save()` moves
  `cache[<fingerprint of the AVIF>]` to `cache[<source key>]` first; the "sent, no answer yet" list is written under
  the source key too).
- **A picture the record knows as AVIF is not handed to the uploader** (no bytes are made for it). Before the `yes`,
  one read of the library (`mediaAlts`, GET) says which of them are still there; one deleted in WordPress since
  becomes a new picture (made, listed "would go up"). No answer: they stay known, as the uploader does. Nothing is
  written to the record before the `yes`.
- Files an earlier run sent without hearing back (`sent.ts`) are looked for with the bytes that were sent: the AVIF
  made in this run (a Chrome update between the two runs can make them differ: the file then goes up again, as a
  `-1` copy; a named limit).
- `--as-served --no-ai-alt` takes exactly today's path: no Chrome, no extra request, the same lines (AC14).

### 4. AI alt text (`ai-key.ts`, `alt-ai.ts`)

- **The key** (real runs only, unless `--no-ai-alt`), right after the WordPress login, in both commands:
  - saved file found → tested with `GET /account`; prints `alttext.ai: the key saved on this computer works (N credits
    left).`
  - none (or `--new-ai-key`) → hidden prompt `alttext.ai API key, for pictures with no alt text (alttext.ai → Account
    → API Keys; nothing shows as you type or paste; Enter alone skips AI alt text this run): `. Enter: `No AI alt text
    this run.` A key: tested; good → saved, `alttext.ai key works: N credits left. Saved on this computer in <file>
    (only you can read it); it won't be asked again. --new-ai-key replaces it; deleting that file forgets it.`
  - refused → `alttext.ai refused that key.` and asked again; after the third, exit 2, nothing uploaded, nothing saved.
  - alttext.ai not reachable, or 0 credits left → said, and the run goes on without AI alt text (a typed key that
    couldn't be tested is not saved).
- **The key file:** `~/.config/figma-to-bricks/alttext-key`: the key and a newline; folder made 0700 when missing; the
  file written as a new 0600 file and renamed; on reading, anything but a regular file is refused, and a file others
  can read is tightened to 0600. A key must be 8–256 printable ASCII characters with no space (a pasted line break or
  control character is refused before it can reach a header). The folder is outside everything Setup Sync carries
  (`~/.claude-setup.git` tracks nothing under `~/.config`: checked).
- **Where the key may be:** in this process's memory and that file. Never an argument, an environment variable, the
  record, the capture, `media.json`, a paste, `notes.txt`, a log or a printed line (the scrubber gets it and its
  URL-encoded form, and hides anything after `X-API-Key`); never Chrome. It is sent only to
  `https://alttext.ai/api/v1/…` (`env.fetch` becomes a router: alttext.ai's address → a fetch that follows no
  redirect; everything else → the site guard as today, which refuses any origin but the typed site).
  `F2B_ALTTEXT_API` may name a stand-in **only on 127.0.0.1/localhost** (refused otherwise, exit 2).
- **Which pictures** (Q6 A): listed pictures with no words on the old site (`item.alt === null`), not SVG, at least
  50 px on both sides (the decoded size), whose small copy could be made.
- **When** (Q7 A, Q8 A), after the uploads end and only if they weren't stopped:
  1. one read of the library for those pictures' media items (`mediaAlts`);
  2. each one whose alt is empty there is described (the panel's `createDescriber`, handed the small copy as the
     picture's bytes), 3 at a time;
  3. its words are written on that item (`setMediaAlt`: `POST wp/v2/media/<id>` with `{alt_text}` only).
  A picture WordPress already has an alt for (typed there, or written by the site's own plugin at upload) is never
  sent to alttext.ai and never changed.
- **The `yes` question** names it: `Upload N new pictures (M already in your library) to <site> as <name>, K as AVIF;
  then alttext.ai describes up to D pictures that have no alt text (1 credit each; you have L left)? Type yes: `.
  Each added part shows only when it applies (no `K as AVIF` when none is made, no alttext.ai part when AI is off or no picture lacks words). With `--as-served --no-ai-alt` it is today's sentence, letter for letter. Before the `yes`: only GETs to WordPress
  and only `GET /account` to alttext.ai.
- **Trouble** (Q11 A): alttext.ai refusing the key mid-run, running out of credits, not answering, or failing one
  picture never stops or undoes an upload. The summary lists `Alt text by alttext.ai (D):` with each picture's words,
  and `No alt text yet (K): <picture>: <reason>` with `Run again to have them described: nothing is uploaded twice.`
  Exit code as the uploads decide (0 when every picture is in the library).
- **`media.json` and the pastes:** each address's `alt` is what the library holds after the run: the old site's
  words, else WordPress's own, else alttext.ai's. The shape is unchanged (`src/core/site/media.ts:5`); an `<img>`
  with no alt of its own over a library alt shows the library's words, as today (`media.ts:22-30`).
- **A Ctrl+C while describing:** nothing new is asked, the ones under way finish (30 s at most), then `media.json`,
  the pastes and the summary are written; exit 130.

### 5. Flags, dry run, lines

- New flags, both commands: `--as-served`, `--reupload-avif`, `--no-ai-alt`, `--new-ai-key`. Refused together:
  `--as-served` with `--reupload-avif`; `--no-ai-alt` with `--new-ai-key`. `site:import`'s "finish without scanning
  again" line carries `--as-served`, `--reupload-avif` and `--no-ai-alt` when they were given.
- **`--dry-run`** (both): no login, no key asked or read, no Chrome, no encoder download, nothing to WordPress or
  alttext.ai, nothing written (the scan file for `site:import`, as today). Each picture's line says what would happen.
- **The list** (dry run; `site:import` before the `yes`). With `--as-served --no-ai-alt`: today's lines exactly.
  Otherwise line 1 of a picture reads `<n>. <stem>-image.avif  image/jpeg → AVIF, 412 KB → 180 KB, alt none
  (alttext.ai describes it)` (a dry run has no second size and says "would describe"); a picture that stays:
  `…, 20 KB, stays as served (a GIF), alt "…"`; one in the library as served: `already in your library as the old
  site served it (media 180): stays; --reupload-avif sends an AVIF copy`. The count line adds how many go as AVIF and
  how many in the library are not AVIF.
- **After `--reupload-avif`:** `The N older items stay in Media (ids …): delete them there if you no longer want
  them.`

## Interfaces (exact; all new files under `tools/lib/site-upload/`)

```ts
// format.ts (pure)
export type Kind = "jpeg" | "png" | "webp" | "gif" | "avif" | "svg" | "other";
export function kindOf(bytes: Uint8Array): { kind: Kind; moves: boolean };
export const AVIF_HOW: string;                                   // "avif-max" + MAX_SIDE (src/ui/webp.ts) = "avif-max2560"
export type StaysWhy = "asked" | "svg" | "gif" | "moves" | "avif" | "other" | "library";
export type Goes = { as: "avif"; key: string } | { as: "served"; key: string; why: StaysWhy };
// servedKey: the uploader's own fingerprint of the file as served (flow.ts:60, uploadItem(...).variants[0].fp)
export function goesAs(l: ListedPicture, servedKey: string, o: { asServed: boolean; reupload: boolean; cache: UploadCache }): Goes;

// encoder-files.ts
export interface EncoderFiles { glue: string; wasm: Uint8Array }
export class NoEncoder extends Error {}                           // its message is the plain reason
export function encoderDir(env?: NodeJS.ProcessEnv, home?: string): string;
export function encoderSource(env?: NodeJS.ProcessEnv): string;   // AVIF_ENCODER.base, or F2B_ENCODER_SOURCE on this computer only
export async function encoderFiles(o?: { dir?: string; source?: string; fetch?: typeof fetch }): Promise<EncoderFiles>;

// picture-chrome.ts
export const PICTURES_OFFLINE = "--host-resolver-rules=MAP * ~NOTFOUND";
export class CantMake extends Error {}
export interface PictureChrome {
  avif(bytes: Uint8Array, mime: string): Promise<{ bytes: Uint8Array; width: number; height: number }>;
  small(bytes: Uint8Array, mime: string): Promise<{ bytes: Uint8Array | null; width: number; height: number }>;  // WebP, 1024 at most; the picture's own size
  close(): Promise<void>; killNow(): void;
}
export async function openPictureChrome(chrome: { path: string; args: string[] }, files: EncoderFiles): Promise<PictureChrome>;

// ai-key.ts
export const keyFile: (home?: string) => string;                 // ~/.config/figma-to-bricks/alttext-key
export function readKey(file: string): string | null;            // null: none saved
export function saveKey(file: string, key: string): void;        // 0600, a new file renamed over
export interface Ai { key: string; left: number | null }
export async function aiKey(prompter: Prompter, out: Out, o: { off: boolean; fresh: boolean; file?: string }): Promise<Ai | null>;

// alt-ai.ts
export function alttextBase(env?: NodeJS.ProcessEnv): string;     // ALTTEXT_API, or F2B_ALTTEXT_API on this computer only (Refused otherwise)
export function aiFetch(base: string, real?: typeof fetch): (url: string, init?: RequestInit) => Promise<Response>;  // alttext.ai only; a 3xx is refused
export const wantsWords: (l: ListedPicture) => boolean;           // no words on the old site, not an SVG
export interface Described { words: Map<string, string>; missing: Array<{ key: string; reason: string }>; stopped: string | null }
export async function describeMissing(login: Login, ai: Ai, todo: Array<{ l: ListedPicture; id: number; small: Uint8Array }>, halt: Promise<unknown>): Promise<Described>;

// scrub.ts: one new method
secret(value: string): void;                                      // the value and its URL-encoded form
```

The page script of `picture-chrome.ts` is `proto-avif.ts`'s (`window.toAvif`, the small copy of probe G), with the
bytes passed as base64 in one `page.evaluate` per picture.

## Acceptance criteria (all proposed; Justin's "go", or the standing auto-go, approves them)

Every test runs only against `test/fixtures/wp-standin.ts`, the new `test/fixtures/alttext-standin.ts` and local
fixture sites, on 127.0.0.1, with a made-up password and a made-up key.

- AC1 (proposed): Given a scan holding a JPEG photo, a see-through PNG, a WebP, a JPEG turned by EXIF and a PNG 2600 px wide, when `npm run site:upload` runs against the stand-in with a typed `yes`, then each arrives as one media item whose file starts with an AVIF header, is named `<stem>-image.avif` and was sent as `image/avif`; read back in Chrome each has the source's pixel size (the turned one upright, 40×60; the wide one 2560 wide), the PNG's clear pixel is still fully clear and its solid pixel solid; `media.json` and every paste name those `.avif` items and no old address of these pictures; and the record keys each by `<source fingerprint>-avif-max2560`.
  Test: `test/web/site-upload-avif.test.ts` "AC1 photos, PNG and WebP pictures arrive as AVIF of the same size and the pastes show them"
- AC2 (proposed): In the same kind of run, an SVG (with `--svg`), a GIF, a moving WebP, a moving PNG and a file that is already AVIF each arrive byte for byte as the old site served them, under today's names, and the list names each as staying as served with its reason.
  Test: `test/web/site-upload-avif.test.ts` "AC2 SVG, GIF, moving and already-AVIF pictures arrive byte for byte as served"
- AC3 (proposed): Nothing ever goes up in another format in place of an AVIF: (a) a JPEG Chrome can't open stops the run before the `yes` question with one line naming the picture, the reason and `--as-served`, exit 2, and the stand-in received no POST; (b) an encoder file that can't be downloaded, and one that isn't the pinned file, each stop the run the same way with no Chrome started and the wrong file never run; (c) a site that refuses AVIF stops the run at that picture with the reason and `--as-served` named, exit 1, and no request carried that picture as JPEG, PNG or WebP; (d) the same scan with `--as-served` uploads every file as served.
  Test: `test/web/site-upload-avif.test.ts` "AC3 a picture that can't become AVIF stops the run and nothing goes up in another format"
- AC4 (proposed): Re-runs: after a run, the same command again sends no POST and writes the same `media.json`; with a record made by `--as-served` (as before this job), a default run sends no POST, keeps those items in `media.json`, and says how many pictures in the library are not AVIF, naming `--reupload-avif`; with `--reupload-avif` exactly one AVIF copy of each goes up, `media.json` and the pastes then name the AVIF items, every older item is still in the stand-in with its file and alt unchanged, and a further run sends no POST; an AVIF item deleted in the stand-in is counted as new in the next run's `yes` question and goes up again.
  Test: `test/web/site-upload-avif.test.ts` "AC4 a re-run sends nothing twice and pictures uploaded as served stay until --reupload-avif"
- AC5 (proposed): A run stopped half-way keeps what went up: after Ctrl+C during the upload the record and `media.json` hold the AVIF items that answered and the rest keep their old addresses, and the next run sends only the rest; after a run killed with no answer heard (`kill -9` once the files went), the next run finds each AVIF in the library by its bytes and sends none of them again; a Ctrl+C while the AVIF files are being made leaves no Chrome process of the run and no POST, and says nothing was uploaded.
  Test: `test/web/site-upload-avif.test.ts` "AC5 a stopped AVIF run keeps what went up and the next run sends only the rest"
- AC6 (proposed): With a key saved and `--svg`, a scan whose pictures are: one with old-site words, one `<img>` with no alt, one `alt=""`, one CSS background, one SVG with no alt and one 40 px icon with no alt: before the typed `yes` the WordPress stand-in received only GETs and the alttext.ai stand-in only `GET /account`; the question names how many pictures alttext.ai may describe, 1 credit each, and the credits left; after `yes` exactly the no-alt, `alt=""` and background pictures are sent to `POST /images`, once each, as a WebP of at most 1024 px in `image.raw` with the key in `X-API-Key`; each one's media item then has those words as its alt, the worded picture keeps the old site's alt and the SVG and the icon have none; `media.json` carries the words; the summary lists them.
  Test: `test/web/site-upload-ai-alt.test.ts` "AC6 pictures with no alt text get alttext.ai's words in the media library and the others are never sent"
- AC7 (proposed): An alt WordPress already has is never changed and costs no credit: (a) on a stand-in that writes its own alt at upload (as alttext.ai's WordPress plugin does), no picture is sent to alttext.ai and every item keeps that alt; (b) an item whose alt a person typed in WordPress after an earlier run keeps it; (c) a second run after a complete one sends nothing to `POST /images` and no POST to WordPress; (d) an item uploaded by an earlier run with an empty alt is described and filled without being uploaded again.
  Test: `test/web/site-upload-ai-alt.test.ts` "AC7 an alt text WordPress already has is never changed and costs no credit"
- AC8 (proposed): The key is asked once and saved: a first run with no key file asks at its prompt after the WordPress login, tests it, prints the credits left and saves it in `<HOME>/.config/figma-to-bricks/alttext-key` with mode 0600; a second run asks nothing and uses it; `--new-ai-key` asks and replaces it; Enter alone saves nothing, sends nothing to alttext.ai and the upload goes on; a refused key is never saved and is asked again, and after three refusals the run ends with exit 2 and no POST to WordPress; a saved key the stand-in refuses is asked again; `--no-ai-alt` neither reads the file nor contacts alttext.ai; a key holding a space or a control character is refused at the prompt.
  Test: `test/web/site-upload-ai-alt.test.ts` "AC8 the alttext.ai key is asked once, tested, saved, replaced on request and skipped with Enter"
- AC9 (proposed): alttext.ai's trouble never costs an upload: when the stand-in runs out of credits after the first picture (answered once with `error_code: insufficient_credits`, once with only the plugin's 422 `errors` message), when it stops answering, and when it refuses one picture (422), every picture is still in the library, exit 0, the described ones have their words, each other is named with its reason under `No alt text yet`, and the next run with credits back describes exactly those and uploads nothing; with alttext.ai unreachable at the key test the run says so before the `yes`, uploads, and describes nothing.
  Test: `test/web/site-upload-ai-alt.test.ts` "AC9 when alttext.ai stops mid-run every picture still goes up and a later run describes only the rest"
- AC10 (proposed): The key and the password reach nothing they shouldn't: neither (in any form `test/fixtures/site-import.ts` `namedSecretForms` lists, and the key as typed and URL-encoded) is in any file a run leaves (the out folder, the record, the encoder cache, HOME but the key file itself, TMPDIR), in the tool's output (also when either stand-in echoes the request's headers in its answer), in the tool's `/proc/<pid>/cmdline` or `environ`, or in the `cmdline` or `environ` of the picture Chrome or the scan's Chrome; the WordPress stand-in never received the key and the alttext.ai stand-in never received the password; the picture Chrome was started with the rule that resolves no host name; a key given as a flag or an extra word is refused without being printed back; `F2B_ALTTEXT_API` or `F2B_ENCODER_SOURCE` naming another computer is refused with exit 2 and nothing sent.
  Test: `test/web/site-upload-secrets.test.ts` "AC10 the key and the password reach no file, output, argument, environment, Chrome process or other site"
- AC11 (proposed): What the command may write: across a run that uploads, describes and fills, a re-run, a `--reupload-avif` run and a stopped run, every request the WordPress stand-in received is a GET, a `POST wp/v2/media` that creates an item, or a `POST wp/v2/media/<id>` whose body is exactly `{"alt_text": <words>}` for an item this computer's record holds and whose alt was empty at that moment; no item's file, title, slug or address changed after its creation and no item was deleted.
  Test: `test/web/site-upload-ai-alt.test.ts` "AC11 the command only adds media items and fills an empty alt text of its own items"
- AC12 (proposed): `npm run site:upload -- … --dry-run` (default flags, a key file present): both stand-ins' request logs stay empty, no Chrome profile appears in the run's TMPDIR, the encoder cache folder is not created, nothing is written, and the run ends the same with the key file present, absent or unreadable (it is never opened); its list says for each picture whether it would go up as AVIF or stay as served and why, which ones alttext.ai would describe, and which are in the library as served; with `--as-served --no-ai-alt` its output is the base's dry run letter for letter.
  Test: `test/unit/site-upload-dry-avif.test.ts` "AC12 a dry run sends nothing to WordPress or alttext.ai and says what would happen"
- AC13 (proposed): `npm run site:import -- <fixture page> <stand-in>` asks, in order, the WordPress user name and password, then the alttext.ai key, then scans; a wrong encoder source stops it before the scan; after the scan it makes the AVIF files, lists them with both sizes, asks the `yes` that names the AVIF count and the credits, uploads, describes, and writes `media.json` and the pastes naming `.avif` items with alttext.ai's words; a `yes` typed before the question still doesn't count; its "finish without scanning again" line carries `--reupload-avif`, `--as-served` and `--no-ai-alt` when given.
  Test: `test/web/site-import-avif.test.ts` "AC13 site:import asks the key after the login, then scans, makes AVIF, uploads and describes"
- AC14 (proposed): With `--as-served --no-ai-alt`, `npm run site:upload` (a dry run, a run, a second run, a refused login, an answer other than yes, a stop during the upload) and `npm run site:import` (a dry run, a run) print, send and write what the base tree's commands do without those flags on the same inputs: stdout, stderr, exit codes, every file written, the record, and each stand-in request's method, path, query and body hash, once paths, ports, dates and those two flags in the printed "finish" line are named alike.
  Test: `test/web/media-avif-as-served.test.ts` "AC14 with --as-served and --no-ai-alt both commands print, send and write as on the base"
- AC15 (proposed): Everything else is untouched: between the base and the head no file under `src/` differs, nor `manifest.json`, `build.mjs`, `package.json`, `tools/capture.ts`, `tools/capture-check.ts`, `tools/capture-serve.ts`, `tools/site.ts`, `tools/site-check.ts`, `tools/site-live.ts`, `tools/lib/site-write.ts`, `tools/lib/capture-run.ts` or `tools/lib/helper-chrome.ts`; and `npm run build` gives `dist/code.js` and `dist/ui.html` byte for byte as the base tree's build.
  Test: `test/unit/media-avif-untouched.test.ts` "AC15 no file of the plugin, panel, capture, site or helper differs from the base and the build is the same"
- AC16 (proposed) (live): Justin runs `npm run site:import -- https://bdryswi.com/ https://bdry.staging.growithgro.com --elementor --reupload-avif` in his own terminal: after the WordPress login it asks his alttext.ai key once (a second run doesn't ask), and after his `yes` WordPress → Media shows the page's JPEG and PNG pictures as `.avif` files, with alt text on the pictures that had none.
- AC17 (proposed) (live): The pastes that run wrote, pasted on B-Dry staging as its next steps say, show those `.avif` pictures from the staging library (no grey placeholder), and the page looks as before.

## Touched files

- **New (tools):** `tools/lib/site-upload/format.ts`, `encoder-files.ts`, `picture-chrome.ts`, `prepare.ts`,
  `ai-key.ts`, `alt-ai.ts`.
- **Changed (tools):** `tools/lib/site-upload/flow.ts` (the router for `env.fetch`, `pick`'s plan per picture, the
  bypass of known AVIF pictures, re-keying in `save()`, describing after the upload; split so no file passes about
  300 lines), `args.ts`, `summary.ts`, `scrub.ts`, `tools/lib/site-import/args.ts` (flags, `uploadLine`),
  `tools/lib/site-import/after-scan.ts`, `tools/site-upload.ts`, `tools/site-import.ts`.
- **New (tests):** `test/fixtures/alttext-standin.ts`, `test/fixtures/site-avif-page.ts` (real pictures: PNG through
  `test/browser/png.ts` `encodePng`/`pngChunk`; the JPEG, WebP and turned JPEG from the planner's
  `fixture-pictures.json`; a moving WebP and GIF as headers with made-up bytes, never decoded),
  `test/unit/site-upload-format.test.ts`, `test/unit/site-upload-dry-avif.test.ts`,
  `test/unit/media-avif-untouched.test.ts`, `test/web/site-upload-avif.test.ts`, `test/web/site-upload-ai-alt.test.ts`,
  `test/web/site-upload-secrets.test.ts`, `test/web/site-import-avif.test.ts`, `test/web/media-avif-as-served.test.ts`.
- **Changed (tests):** `test/fixtures/wp-standin.ts` (one option: a plugin that writes an alt on `add_attachment`,
  before `create_item` applies the request's own; cited from the plugin's code as its other answers cite WordPress's);
  every existing test that runs `tools/site-upload.ts` or `tools/site-import.ts` for a real run gains `--as-served
  --no-ai-alt` (their fixture pictures are made-up bytes no browser opens; the builder greps for every spawn of the two
  tools, likely: `test/unit/site-upload-cli`, `-opens`,
  `-scrub`, `-stop`, `site-import-order`, `-gate`, `-no-person`; `test/web/site-import-run`, `-same`, `-secret`,
  `-stop`, `-warnings`, `-yes`, `-scan-fails`, `-dry-run`, `capture-refused-import`, `capture-commands-sockets`,
  `site-upload-page`; `test/fixtures/site-import.ts`. `test/web/site-import-others-unchanged.test.ts` is moved to
  `test/web/media-avif-as-served.test.ts` and adapted (AC14): its old claim, `site:upload` as on base `11e885fd`
  with no flag, ended with Justin's ruling.
- **Not changed:** anything under `src/`; `package.json` (no dependency, no script); `tools/lib/site-write.ts`.
- **Docs:** `docs/plans/2026-11-11-media-avif-alt.md`, its ledger, `docs/HANDOFF.md`.

## Tasks (in order; one commit a task, each green; ledger `.superpowers/sdd/media-avif-alt/progress.md`)

Before Task 1: `npm run check` and `npm run corpus` on the copy, numbers in the ledger; build a base tree for the
story pins (`git archive 02481763` into a scratch folder with `node_modules` linked, as site-one-command's AC11 did).

1. **Flags that change nothing yet.** `--as-served` and `--no-ai-alt` accepted by both parsers and carried by
   `uploadLine`; every existing real-run test passes them; the as-served pin moves to
   `test/web/media-avif-as-served.test.ts` with its request-log comparison and two `site:import` scenarios. Green
   with the base tree, the test of AC14 (the flags are no-ops, so head and base agree).
2. **The untouched pin** (`test/unit/media-avif-untouched.test.ts`, a story pin: `F2B_STORY_PINS=1`, `F2B_BASE_REF`,
   `F2B_BASE_TREE`). Green from the start; it stays green to the end.
3. **`format.ts`** test first (`site-upload-format.test.ts`: each kind by its bytes, a moving PNG and WebP, a short
   or made-up file never throws, the record keys, the library rule with and without `--reupload-avif`).
4. **`encoder-files.ts`** test first (in `site-upload-format.test.ts` or its own unit file, with an injected fetch:
   cached and right → no request; missing → downloaded, checked, written; wrong bytes → `NoEncoder`, nothing written;
   no connection → `NoEncoder`; a cached file changed on disk → downloaded again; a source on another computer
   refused).
5. **`picture-chrome.ts`** test first (the pixel facts of AC1 at function level: size, cap, turn, alpha; a file
   Chrome can't open → `CantMake` with the reason; `small()`; the page reaches nothing; the same bytes twice).
6. **The fixture** `site-avif-page.ts` and **AC1, AC2** red (the pictures arrive as served), then `pick`'s plan,
   `prepare.ts`, the hand-over of AVIF bytes, the re-keying, the names and the list lines → green.
7. The test of **AC3** red → the stops (before the `yes`; the encoder; the reworded AVIF refusal; Chrome missing) → green.
8. The test of **AC4** red → the library rule, `--reupload-avif`, the bypass of known AVIF pictures and the read before the `yes`
   → green. **AC5** red → the sent list under the source key, the stop while making → green.
9. **`alttext-standin.ts`** (each answer citing `src/ui/describe.ts`, `docs/plans/2026-10-14-ai-descriptions.md:19-21`
   or the plugin's `class-atai-api.php`; never from what the new code expects) and the `wp-standin` option.
10. The test of **AC8** red → `ai-key.ts`, the router, `--no-ai-alt` now real, `--new-ai-key` → green.
11. The tests of **AC6, AC7** red → `alt-ai.ts`, the question, `media.json`'s alts, the summary → green. **AC9**, **AC11** → green.
12. The tests of **AC12** (dry run) and **AC13** (`site:import`: the key after the login, the early encoder check, the list with
    sizes) → green.
13. The test of **AC10** (secrets) → green; the scrubber's `secret()` and its `X-API-Key` pattern proven by the echoing
    stand-ins.
14. **Guards proven** (`mutation-testing-discipline`, each under `systemd-run --user --scope -p MemoryMax=4G -p
    MemorySwapMax=0`): the SHA-256 check before the encoder runs; the offline flag of the picture Chrome; the
    loopback-only rule of both environment names; "only where WordPress's alt is empty"; the stop before the `yes`
    on a picture that can't be made; no format fallback; the key's 0600. One mutant each, killed by its AC test by
    assertion.
15. **Close:** `npm run check`, `npm run test:web`, `npm run test:browser`, `npm run corpus` (no file worse), every AC
    test by name with its screenshot or terminal capture, the story pins with the base tree.
16. **Docs & records** (below).

RED on the base: each new CLI test fails by assertion, not by a crash: on the base the pictures arrive as
`image/jpeg`/`image/png` (AC1), `--reupload-avif` and `--new-ai-key` are unknown options (exit 2), and no request
reaches the alttext.ai stand-in. Tasks 1–2 are characterizations (green from the start; no RED is invented).

## Tests and how each is proven

- The web tests need Chrome (`CHROME_PATH`) and the real encoder: a helper in `test/fixtures/site-avif-page.ts` hands
  every run `F2B_ENCODER_CACHE` = the developer's own `~/.cache/figma-to-bricks/avif-encoder-2.1.1` (resolved before
  HOME is swapped), so it is downloaded once per computer; an offline computer with an empty cache fails with the
  tool's own line (never a skip).
- An uploaded AVIF's facts: its pixel size from its `ispe` box in Node, and its pixels by decoding it in the test's
  own Chrome (`createImageBitmap`).
- The alttext.ai stand-in: a real HTTP server on 127.0.0.1 logging every request (method, path, headers, the body's
  parsed shape, the decoded `image.raw`'s type and size); options for a refused key, credits that run out after n
  pictures (both shapes), no answer, a 429 once, one picture refused (422), and echoing the request's headers.
- `/proc` reads (AC10) as `test/web/site-import-secret.test.ts` does them; the picture Chrome is found by its
  profile folder under the run's TMPDIR while `Making AVIF` shows (the fixture's 2600 px PNG gives it time).
- Story pins (AC14, AC15) run only with `F2B_STORY_PINS=1` and the base tree; a skip is never a pass. Their log folder
  comes from a variable, so the verifier and the auditor don't overwrite the builder's receipts. On the base itself the
  test of AC14 fails (the two flags are unknown options there); the test of AC15 can't fail there (it pins that
  nothing changed), so its base receipt is `base_exempt` with that reason.
- The desktop: `TMPDIR` about 24 characters; a command ended by SIGTERM/137/143 is checked against earlyoom first.

## Standing-rule changes (CLAUDE.md; the finisher writes them at the merge)

- "One uploader writes to WordPress…": "It only adds media items" becomes "It only adds media items and fills the
  alt text of an item it uploaded itself while WordPress has none there (never changes any other field or item,
  never moves or deletes one)". Add: the alttext.ai key is typed once at a hidden prompt, saved in
  `~/.config/figma-to-bricks/alttext-key` (0600) and goes in no argument, environment variable, record, capture,
  paste, log, printed line or Chrome; agents never ask for, read or hold it and test only against
  `test/fixtures/alttext-standin.ts`; the pictures are made AVIF in a Chrome of the command's own that is offline and
  is given picture bytes only.
- The decision "A scanned page's pictures go to WordPress from the command line": **Q6 reversed** (Justin, 2026-11-11,
  "Photos + PNG pictures": JPEG, PNG and WebP go up as AVIF at their own size, 2560 at most; SVG, GIF, moving and
  already-AVIF files as served; never another format in place of an AVIF; `--as-served` is the only way back);
  **Q8 reversed** ("Ask once, save it": alttext.ai describes pictures with no alt text, after the upload, only where
  WordPress has none). Q7 and Q9–Q11 stand. This plan's ⭐ answers are "not yet confirmed" until Justin says.
- Status: the build line and one line for this feature with its paste check.

## Docs & records

- This plan copied to `docs/plans/2026-11-11-media-avif-alt.md`; the ledger moved by the finisher to
  `docs/plans/2026-11-11-media-avif-alt-ledger.md` before the final pre-merge commit and rebase.
- `docs/HANDOFF.md`: a new section above the top `## ` heading ("A scanned page's photos go up as AVIF, with AI alt
  text"): what changed in plain words; what Justin types; each ⭐ ruling as "not yet confirmed"; the two reversed
  rulings; the measured B-Dry numbers; the limits below; the end-of-run entry at the top of "End-of-run check list".
  In site-media-upload's section, Q6 A and Q8 A get one line each pointing here.
- **Paste check 3ea** (AC16, AC17, live). 3dz is media-clickable's; check 3ea is still free on `main`, on every local
  branch's HANDOFF and in the plan folder at the merge.
- `BUILD` bumped at the merge; main `CLAUDE.md` Status and the two rule changes above; the project skill's
  `rules-summary.md` edit returned by the finisher for the main session.
- Follow-ups recorded: `src/ui/describe.ts` treats "no credits" as a stop only by `error_code` (a 422 with only the
  message fails each remaining picture by name instead: harmless, no credit spent); a still GIF as AVIF (Q3 B).

## Justin's check (paste check 3ea; AC16 and AC17)

1. In Ubuntu on the Windows desktop: `cd ~/Documents/FigmaToBricksV2 && npm run site:import -- https://bdryswi.com/
   https://bdry.staging.growithgro.com --elementor --reupload-avif` (one line).
2. Type the WordPress user name, then paste the Application Password (nothing shows).
3. At `alttext.ai API key …`, paste the key from alttext.ai → Account → API Keys (nothing shows). It says how many
   credits are left and that it is saved; the next run won't ask.
4. If a Chrome window opens, pass the "I am human" check. Wait for the scan and `Made N AVIF files`.
5. Read the list and the question (how many go up as AVIF, how many alttext.ai may describe). Type `yes`.
6. In WordPress → Media: the page's pictures end in `.avif`; open one that had no alt text: Alternative Text is
   filled. The 30 older `.jpg`/`.png` items (among media 174–207) are still there: delete them if you don't want them.
7. Paste the parts as the command's next steps say and look at the page (AC17).

If B-Dry staging runs alttext.ai's own WordPress plugin with "generate on upload" on, its words are kept and the
command spends no credit for those pictures.

## Risks and limits (named in HANDOFF)

- **B-Dry staging must take AVIF** (WordPress 6.5+; a raw upload needs no image editor on the host: HANDOFF Q6's
  finding). If it refuses, the run stops and says so; `--as-served` is the way until it does.
- **9 of B-Dry's 30 files get bigger** under Q2 A (logos most). The list shows it; Q2 B or C changes it.
- **A formerly decorative `<img alt="">` shows alttext.ai's words on the page** once its library item has them
  (Bricks prints an empty Custom alt text as none, `media.ts:28-30`). Q6 C avoids it.
- **`--reupload-avif` leaves the older items in Media** (never deleted by the tool); WordPress may name the new file
  `…-image-1.avif` beside an older `…-image.png`.
- A run killed where the tool can't hear it, followed by a Chrome update before the next run, can upload that file
  once more (`-1` copy), as the existing limit for changed files.
- Between the read of an item's alt and the write of alttext.ai's words (the seconds a description takes), an alt
  typed in WordPress would be overwritten; a described picture whose alt WordPress then refuses costs its credit
  again on the next run.
- The first run needs the internet for the encoder (3.5 MB, once per computer).
- The exact shape of alttext.ai's "no credits" answer is unverified (docs not reachable today); both known shapes
  are tested and neither can stop an upload.

## Overlaps with unmerged jobs

- **media-clickable** (planned today, Mini): reads `media.json`'s `id`, `url`, `filename` and edits `src/core/site/`
  only; this job edits no file there and keeps `media.json`'s shape. Either can merge first; HANDOFF's top section and
  the end-of-run list are the only shared text (keep both).
- **site-native-structure** (unmerged): its fold writes a linked picture's Image itself; nothing here depends on it.
- No other open job touches `tools/lib/site-upload/` (`git worktree list` and the plan folder, 2026-11-11).

## Completion

`ready-for-review` when AC1–AC15 pass by their named tests on one commit, `npm run check`, `npm run test:web`,
`npm run test:browser` and `npm run corpus` are green (the stale site-media-upload pin named above aside, compared by
name with the base), each AC has its screenshot or terminal capture in
`~/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/builder/`, and AC16–AC17 are named as owed to Justin. The
builder returns `skill_lessons[{skill, lesson, evidence, enforce}]` and never runs either command against a live site.
