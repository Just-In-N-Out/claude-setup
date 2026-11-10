# site-media-upload: a scanned page's pictures go to Justin's WordPress media library, from the command line (plan, 2026-11-10)

Planned against main `2879e496` (Build 2026-11-10.3, site-slider merged). Full pipeline. Website importer job: one
real-bug review (the project's importer rule), edge cases to follow-ups; every AC accepted with no cap.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-media-upload/` (the builder's, reviewers', verifier's and
auditor's folders). The planner's probes are in `~/.cache/smu-p/probe/` (scripts and their outputs, named below).

**This job writes to WordPress, which every other tool and agent still may not.** Agents build and test it only
against a local stand-in (`test/fixtures/wp-standin.ts`, 127.0.0.1). No agent runs it against Justin's staging site or
any live site, asks for his Application Password or holds it. The two `(live)` ACs are his, in his own terminal.

## Questions (⭐ = taken under the standing auto-go unless Justin changes it)

1. **The command's shape.** ⭐ **A:** a command of its own, `npm run site:upload -- <capture> <outDir> <site address>
   [--user <name>] [--dry-run] [--svg] [--elementor] [--part …] [--basic-text] [--record <file>]`: it reads the site,
   uploads, writes `<outDir>/media.json` (each picture's address → its media item; no secret in it) and then the same
   paste files `npm run site` writes, made with those pictures. `npm run site` itself gains only `--media
   <media.json>` (reads a local file, still never opens a connection), so a paste can be remade offline any time.
   *Costs you:* one new command to learn; the paste flags are typed on it as on `npm run site`. B: a `--upload <site>`
   flag on `npm run site` (one command, but the offline converter would then hold network and password code). C: an
   upload-only command and a second `npm run site --media` run every time (two commands each time).
2. **How the password gets in.** ⭐ **A:** typed (or pasted) at a prompt that shows nothing, on the terminal, each
   run; never a command-line argument, never an environment variable, never saved. A run whose input isn't a terminal
   is refused for any address but 127.0.0.1/localhost (the tests' stand-in), so nothing but a person at a keyboard can
   upload to a real site. *Costs you:* you paste the Application Password (WordPress → Users → Profile → Application
   Passwords) each run, and you run it in your own terminal window, not through Claude's `!`. B: also accept
   `F2B_WP_PASSWORD` (no typing, but every program you start, agents included, can read it while it is set).
3. **Which pictures go up.** ⭐ **A:** every picture the site's own markup shows in the paste: each Image element's
   picture and each CSS picture (`background-image`, `background`, `mask-image`, `-webkit-mask-image`) whose file the
   capture holds, matched by its full-size address (a CDN's sizes of one file, Jetpack's `i0.wp.com/…?w=`/`?fit=`, are
   one file: `src/web/read/cdn.ts` `fullSize`), each file once by its bytes wherever it shows (header, page, footer,
   slides, closed answers). Left on their addresses, each named in the summary: pictures another company's script drew
   (review widgets' stars and avatars: `~` paths), a live widget's own code, Code elements' markup (inline SVG, video
   posters), pictures already inside the paste (`data:`). *Costs you:* none on B-Dry (its 118 Trustindex stars, 18
   Google and 2 Facebook avatars are all script-made); a partner badge another site serves is uploaded like the site's
   own. B: upload script-made pictures too (copies of another company's pictures and of reviewers' faces).
4. **A picture the capture has no file for.** ⭐ **A:** it keeps its old address, named in the summary; a later
   capture job can keep every picture the site's code names (follow-up). *Costs you:* on B-Dry's 2026-11-09 capture one
   background file (`Untitled-1600-x-300-px-1.png`, the services band, 2 rules) stays on bdryswi.com and breaks when
   the old site goes. B: the upload fetches such a file from its old address while it runs (a plain GET of the old
   site, no login; one more site the tool talks to).
5. **SVG files.** ⭐ **A:** not sent unless you add `--svg`: WordPress refuses SVG uploads until a plugin or Bricks
   (Settings → SVG uploads) allows them; without the flag they keep their addresses, named with that step; with it,
   the first refusal stops trying the rest. *Costs you:* nothing on B-Dry (no SVG file in its own markup's pictures).
   B: always try them (a refused upload each run on most sites).
6. **Formats and sizes.** ⭐ **A:** each file goes up exactly as the old site served it (its JPEG, PNG, GIF, WebP or
   AVIF bytes), never re-encoded or resized: the command line has no image encoder, the site's files are already sized
   for the web, and WordPress makes its own sizes (Bricks prints them as `srcset`). AVIF stays AVIF; a site that can't
   take AVIF stops the run with the panel's reason (what to ask the host), never a quiet swap ("never fall back
   silently"). A file over the site's upload limit keeps its address, named. *Costs you:* on B-Dry the 4 AVIF files
   need your WordPress to take AVIF (Tools → Site Health → Info → Media Handling). B: re-encode through Chrome (a
   browser per run, slower; not "like the plugin" either, whose capture pictures go up as they are).
7. **Alt text.** ⭐ **A:** the library's alt is the old site's alt for that file (its first one with words, in page
   order); `alt=""` and no alt send none (decorative stays decorative). The paste carries no Custom alt text where the
   element's own alt is the library's (Bricks shows the library's: CLAUDE.md "Picture descriptions"); an element whose
   own alt differs (other words, or `""` where the library has words) keeps its own as Custom alt text. A later run
   never changes an alt already in WordPress, so your edits there stay. *Costs you:* nothing. B: always write Custom
   alt text as today (then editing the alt in Media changes nothing on the page).
8. **alttext.ai.** ⭐ **A:** not in this job: pictures with no alt are listed (as today's note) for you to describe in
   Media; a follow-up can add an opt-in `--describe` (your key at a hidden prompt, only pictures with no alt, never
   `alt=""`). *Costs you:* none on B-Dry (every picture of its own markup has an alt attribute). B: build `--describe`
   now (your paid credits, a second hidden prompt, more to test).
9. **Remembering what went up.** ⭐ **A:** a record per computer, `~/.config/figma-to-bricks/site-uploads.json` (by
   site, then by file fingerprint → media id, address, file name; the panel's own upload-cache shape and keys; no
   password), saved after every upload; `--record <file>` picks another. A re-run uploads nothing new; a picture
   deleted in WordPress since goes up again (checked with one read of the library). A picture the Figma panel uploaded
   isn't known to it (the panel's record lives inside Figma): it goes up once more. *Costs you:* one small file in your
   home folder. B: the record in the out folder (a new folder uploads everything again).
10. **Before anything goes up.** ⭐ **A:** https only (plain http only for 127.0.0.1); the tool first reads the site's
    public REST index (no password) and refuses when WordPress's own address names another site than the one typed, or
    when the address redirects (it names where to); it prints the site's name and address; then asks the user name (or
    takes `--user`) and the password; checks the login can upload; then prints "Upload 23 new pictures (5 already in
    your library) to <address> as <name>? Type yes:" and goes on only on `yes`. No flag skips that line. *Costs you:*
    typing `yes` each run. B: a `--yes` flag.
11. **A run that stops half-way** (the site stops answering, refuses AVIF, refuses a file). ⭐ **A:** what went up is
    kept, in the record and in the pastes; every other picture keeps its old address; the summary lists both and the
    exit code is 1; running it again uploads only what is missing. *Costs you:* nothing. B: write no pastes unless
    every picture went up.

## Playback

1. You asked how alt text is handled on a scanned page. Today `npm run site` leaves every picture on the old site's
   address (bdryswi.com or its Jetpack CDN) and puts the old site's alt text in each Image's Custom alt text.
2. You want those pictures in your own WordPress media library, "like how it is in the plugin": uploaded once, with
   their alt text in Media, and the paste pointing at your site's copies, so the page keeps working when the old site
   goes.
3. You chose to run it from the command line (not the Figma panel), and the Full pipeline.
4. This is the first tool allowed to write to a WordPress site. Your rule that agents never write to a site and never
   use a login still binds every agent: they test it only against a local stand-in, and only you run it against your
   site, with your Application Password typed at its prompt.

## What exists (file:line on `2879e496`)

- **The panel's upload code runs in plain Node, unchanged** (probe `~/.cache/smu-p/probe/node-upload.ts`: `uploadAll`
  against a local HTTP server, user `u`, password `p`: run 1 uploaded a PNG and a 5 MB PNG as they were, the SVG was
  refused and named; run 2 reused both with one `GET wp/v2/media?include=` but sent the refused SVG again, which is why
  Q5 holds SVGs back by default): `src/ui/uploader.ts:292` `uploadAll` / `:129` `createUploader` (three lanes, one upload per file
  fingerprint, a cache hit checked against the library at the end, `:190-206`, a deleted one uploaded again,
  `:264-274`; a fatal answer stops the run and hands back what went up, `:275-278`); `:49` `uploadItem` (an SVG
  variant first with `iconFormat: "svg"`, then the bytes); `:63` `avifRefused` (AVIF never goes up as something else,
  `:78`); `:212-230` `syncAlts` (a cache hit whose typed alt differs is changed in WordPress: `POST wp/v2/media/<id>`).
  `src/ui/wordpress.ts:58` `wpFetch` (Basic auth from `user:pass`, whitespace stripped, `:64`; every failure a sentence),
  `:86` `testConnection` (pretty then plain permalinks; needs `upload_files`), `:106` `uploadMedia` (`POST wp/v2/media`,
  `Content-Disposition` filename, `?slug=&alt_text=`), `:117` `mediaAlts`, `:169` `siteAddress` (the REST index's
  `url`, what Bricks compares letter for letter). `src/ui/files.ts:4` `fingerprint`, `:33` `safeFilename` (always ends
  in `-image`: an unattached upload owns `/<name>/`, CLAUDE.md). `src/ui/photos.ts:53` `processing` (with `original`
  and a file ≤ 4 MB nothing changes; over 4 MB it would shrink, but without a canvas `prepareFile` falls back to the
  original: probe, a 5 MB PNG went up whole as `big-image.png`). `src/ui/env.ts:22-27` (fetch, decode, canvas: only
  fetch is needed here; Node 22 has `fetch`, `Blob`, `btoa`, `TextEncoder`). `src/ui/settings.ts:66` `cacheFor` (the
  cache by `siteRoot(site).toLowerCase()`); the panel's settings and cache live in Figma's client storage (`:1`
  "on this computer only"), out of the command line's reach. `src/ui/run.ts:153-159` (the panel's paste: every
  picture filled from the media, `sourceUrl = await siteAddress(wp)` once any picture went up). `src/ui/describe.ts:40`
  `wantsDescription(p, keepWords)` (a capture's pictures keep the old site's words, Justin's answer 10, HANDOFF
  web-panel). The panel's media shape for Bricks: `uploader.ts:45` `{ id, filename, size: "full", full, url }`.
- **The code route's pictures today.** `src/core/site/kinds.ts:91-96`: an `<img>` is `{ image: { url: <src>, external:
  true, filename }, altText? }` (`src` is Chrome's `currentSrc` at the read width, `src/web/read/code-facts.ts:89`;
  `srcset`/`sizes` are kept in `attrs` but not pasted; a `<picture>` is a box around its `img`, no `<source>` kept).
  `src/core/site/convert.ts:169-184` `rewrite`: a `background-image` `url()` becomes the capture's bytes as `data:` only
  in `pictures: "data"` mode; `src/core/site/parts.ts:48-53` whole pages are `pictures: "address"` (so every url stays
  the old site's); `mask-image` urls are never touched. `convert.ts:163-167` names pictures with no alt. Every paste's
  `sourceUrl` is `https://www.figma.com` (`src/core/emit/payload.ts:46`). `tools/site.ts:40-75` writes the parts
  (ASCII-only JSON, `:22`).
- **The capture's picture files.** `web.pictures` is keyed by SHA-1 of the bytes, each with `url` = the address as the
  page wrote it (`src/web/assemble.ts:172-176`), fetched at full size (`src/web/read/pictures.ts:81`, `fullSize`), and
  pruned to the files the measured-box layers fill with (`assemble.ts:177-183`). So the code route's `src` is often
  another size's address of a held file, or not held at all.
- **On Justin's B-Dry capture** (`/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, build 2026-11-09.1; probes
  `pictures.ts` → `bdry-el.txt`, `made.ts`, `near.ts`, `props.ts`): the whole page with `--elementor` has 153 Image
  elements (38 addresses) and 71 CSS picture urls. By exact address the capture holds 14 of the images and 55 of the
  urls. 138 images are script-made (Trustindex stars and logos, Google and Facebook avatars, one with an access token
  in its address), all under `~` paths; the 15 of the site's own markup are on `bdryswi.com` (2) and Jetpack
  `i0.wp.com` (13). Matched by `fullSize`, every own-markup image is held (e.g. `8.png?resize=1024%2C1024` → the held
  `8.png?w=1080`) and every own CSS url but `Untitled-1600-x-300-px-1.png?fit=1600%2C300` (no file at any size).
  Files: 64 (46 PNG, 14 JPEG, 4 AVIF), the largest 1.55 MB. No `data:` image source; every `.svg` image the paste
  shows is script-made (Trustindex).
- **Bricks' paste rule** (`reference/bricks/README.md:47-63`): a paste whose `sourceUrl` isn't the site's own address
  swaps every Image whose picture has an `id` for its grey placeholder, for good; external addresses are left alone;
  `test/fixtures/bricks-paste.ts:10` `bricksPaste(payload, siteUrl)` models it.
- **WordPress's own answers** (read from WordPress 6.8's source, saved in `~/.cache/smu-p/wp-src/`:
  `class-wp-rest-attachments-controller.php`, `user.php`, `functions.php`): `create_item` `:187-279` (201, `Location`,
  `alt_text` from the request, query parameters included, `:208-210`); `upload_from_data` `:1105-1206` (400
  `rest_upload_no_data`, `rest_upload_no_content_type`, `rest_upload_no_content_disposition`,
  `rest_upload_invalid_disposition`; 500 `rest_upload_sideload_error` with `wp_handle_sideload`'s words, e.g. a type
  not allowed); `:150-173` (400 `rest_upload_image_type_not_supported` for an image type the server can't resize, AVIF
  on a host without it); `user.php:372-505` `wp_authenticate_application_password` (`invalid_username`,
  `incorrect_password` "The provided password is an invalid application password."); `:5055`
  `wp_is_application_passwords_supported` (SSL, or a `local` environment); `functions.php:2553` `wp_unique_filename`;
  `class-wp-rest-users-controller.php:536-541` (`users/me` with no login: 401 `rest_not_logged_in`);
  `check_upload_size` `:1407-1410` (a single site checks no size itself: an oversized body is refused by the web
  server, 413, or PHP drops it and WordPress answers 400 `rest_upload_no_data`; `wordpress.ts:49` names 413).
- **Existing stand-ins** (`test/fixtures/panel.ts:43`, `test/fixtures/site-media.ts`) are fetch stubs written from what
  the panel expects; the command line needs a real HTTP server it can be pointed at, written from WordPress's code.
- **Fixtures to build on:** `test/fixtures/site-page-code.ts` `pageCode(over)` (a hand-made whole page: a picture with
  a malformed address `IMG`, one in a `<picture>`, a decorative one, one with no alt, a background photo, a script-made
  copy `TWIN`; `over.pictures`, `over.patch`); `test/fixtures/web/serve.ts` (fixture sites on 127.0.0.1, pictures
  made on request `/img/<name>-<w>x<h>.png`, a second origin for another company's scripts);
  `test/web/lib/site-page-check.ts:32` `checkPage` and `test/web/lib/site-check.ts:167` `pastePictures` (draws a
  paste's pictures from the capture's bytes).

## Approach

**One shared uploader, two front ends.** The command line builds the panel's own `PictureItem`s from the capture and
runs the panel's `uploadAll` unchanged but for one new option (`syncAlts: false`: a re-run never changes an alt in
WordPress; the panel keeps `true`). Naming (`safeFilename`), fingerprints, the cache shape and keys, the dead-item
check, AVIF refusal, SVG fallback and the error sentences are the panel's. Node supplies `env.fetch` as a guard (the
typed site's origin only, `redirect: "error"`).

**The converter learns a media map, offline.** `ConvertOptions.media?: SiteMedia` (`src/core/site/media.ts`): `{ site,
pictures: { [address]: { id, url, filename, alt } } }`, keyed by the exact address the capture's code names (an `img`
`src`, a CSS `url()` as written). With it: an `<img>` in the map is a library picture `{ id, filename, size: "full",
full, url }` (no `external`), its Custom alt text only where its own alt differs; a CSS url in the map becomes the
library's address; every part's `sourceUrl` is `media.site` (once the map names any picture); and each part's result
lists the pictures it used (`pictures: PictureUse[]`, only when a map is given) so the upload knows what to send.
Without a map nothing changes, byte for byte.

**The command line** (`tools/site-upload.ts` plus small modules in `tools/lib/site-upload/`): parse → refuse before
any request (http, no terminal) → dry run stops here (lists, writes nothing) → read the public REST index (refuse
another site or a redirect) → user, hidden password → `testConnection` → convert with an empty map (the upload list) →
confirm `yes` → `uploadAll` (record saved after each upload) → `media.json` → the pastes through the same writer
`npm run site` uses → summary. The password lives only in the one `WP` object in memory.

## Acceptance criteria (all proposed; Justin's "go" approves them)

- AC1 (proposed): The local WordPress stand-in answers as WordPress 6.8's own code does (each answer cites its source line): the REST index (pretty and plain permalinks), `users/me` with an Application Password (right: name and capabilities; wrong: 401 `incorrect_password`; unknown user: 401 `invalid_username`; none: 401 `rest_not_logged_in`), `POST wp/v2/media` (201 with id, slug, link, source_url, alt_text, post null; a second file of the same name gets WordPress's next unique file name and slug; no Content-Disposition 400; an SVG 500 `rest_upload_sideload_error`; AVIF on a host without it 400 `rest_upload_image_type_not_supported`; a body over the server's limit the web server's 413, which a single site's WordPress never answers itself), `GET wp/v2/media?include=`, and it serves each uploaded file at its source_url and logs every request.
  Test: `test/unit/wp-standin.test.ts` "AC1 the WordPress stand-in answers as WordPress 6.8's own code does"
- AC2 (proposed): Given a capture and a media map naming some of its pictures, every Image element whose address is in the map is a library picture `{id, filename, size: "full", full, url}` with no `external`, with no Custom alt text where its own alt equals the library's and its own alt where it differs; every CSS url in the map is the library's address; no address of the map is left anywhere in the paste (Image settings, element and class CSS, pseudo and state looks, slides, closed answers); pictures outside the map are as today; every part's `sourceUrl` is the map's site; every paste passes `assertPayload`; plain and Elementor step, rich and basic text.
  Test: `test/unit/site-media-convert.test.ts` "AC2 a media map makes each mapped picture a library picture and names the site"
- AC3 (proposed): Such a paste, run through Bricks' paste rule, keeps every library picture when pasted into the site the map names, and Bricks swaps them all for its placeholder on any other site.
  Test: `test/unit/site-media-convert.test.ts` "AC3 pasted into the site it names the library pictures stay; on another site Bricks swaps them"
- AC4 (proposed): Without a media map, or with one that names none of the page's pictures, every paste of every hand-made capture and of the four saved fixture captures, in every variant (rich/basic × address/data × code/Elementor), is byte for byte what main `2879e496` writes, and `npm run site` writes the same files as on main.
  Test: `test/unit/site-media-unchanged.test.ts` "AC4 without a media map every paste is byte for byte as main makes it"
- AC5 (proposed): The upload list of a capture holds each file of the site's own markup once (the same bytes at several addresses or CDN sizes one item, every address it shows at listed), with the alt rule of Q7 and the panel's `-image` names, and names each picture it leaves on its address with its reason (another company's script drew it, the capture holds no file, an SVG without `--svg`); `data:` pictures and Code markup are not in it.
  Test: `test/unit/site-upload-pictures.test.ts` "AC5 the upload list holds each own picture once and names every picture it leaves on its address"
- AC6 (proposed): `npm run site:upload -- … --dry-run` sends no request at all, asks for no password and writes no file (the out folder and the record are unchanged), and lists every picture once with its name, type, size, alt (or decorative / none), where it shows and whether it would go up, is already in the record, or stays on its address and why.
  Test: `test/unit/site-upload-cli.test.ts` "AC6 a dry run sends nothing, asks no password and writes nothing"
- AC7 (proposed): A run against the stand-in uploads each listed file once with the old site's alt text (none for decorative), writes `media.json` and the pastes using the library pictures, prints the summary (uploaded, already there, left on their addresses with reasons, "paste on <site>"), exits 0; and `npm run site -- <capture> <out2> --media <out>/media.json` with no server running writes byte-identical pastes.
  Test: `test/unit/site-upload-cli.test.ts` "AC7 an upload sends each picture once with its alt text and the pastes use the library pictures"
- AC8 (proposed): The password (as typed with its spaces, without them, and inside the Basic `user:password` base64 and its URL-encoded forms) is in no file the tool wrote (out folder, record, media.json), not in its standard output or error, not in its command line or environment (`/proc/<pid>/cmdline`, `/proc/<pid>/environ` while it waits at the confirmation), and the stand-in received it only as the Authorization of requests to itself.
  Test: `test/unit/site-upload-cli.test.ts` "AC8 the password reaches no file, output, argument or environment"
- AC9 (proposed): A second run with the same record sends only GET requests (no upload, no change to any media item), uploads nothing, and writes byte-identical `media.json` and pastes; an alt text edited in WordPress since stays; a media item deleted in WordPress since goes up once again; no run ever sends DELETE, PUT, PATCH or a POST to anything but `wp/v2/media`.
  Test: `test/unit/site-upload-cli.test.ts` "AC9 a second run uploads nothing new and changes nothing already on the site"
- AC10 (proposed): Before the password is asked or sent the tool refuses, with one plain line, exit 2, and no POST anywhere: an http address other than 127.0.0.1/localhost, any non-loopback address when its input isn't a terminal, an address that redirects (naming where), a site whose WordPress address names another host; after it, a refused login (WordPress's reason) and an answer other than `yes`; and every request it sends goes to the typed site's origin only (a second local server receives nothing).
  Test: `test/unit/site-upload-cli.test.ts` "AC10 the tool refuses another site, a redirect, plain http and a run without a person before any upload"
- AC11 (proposed): When the stand-in stops answering after two uploads (and, separately, refuses AVIF), the run keeps those two in the record and the pastes, leaves every other picture on its old address, names both groups, exits 1, and the next run uploads only the missing pictures (no file twice).
  Test: `test/unit/site-upload-cli.test.ts` "AC11 a run stopped half-way leaves working pastes and the next run finishes without duplicates"
- AC12 (proposed): The Figma panel uploads as before: with its own options the uploader sends the same requests in the same order with the same bodies as on main for the recorded scenarios (new uploads, cache hits with changed and unchanged alts, a deleted item, an SVG refusal, AVIF refusal), and every existing panel test passes unchanged.
  Test: `test/unit/site-upload-panel-unchanged.test.ts` "AC12 the panel's uploads send the same requests as on main"
- AC13 (proposed): Figma designs convert byte for byte as before: `npm run replay` of every corpus file and the repo's debug files gives the payloads main gives.
  Test: `test/unit/site-upload-panel-unchanged.test.ts` "AC13 Figma designs convert byte for byte as on main"
- AC14 (proposed): The fixture site `media-page` (generic: a logo in header and footer with different alts, a photo with a `srcset`, one in a `<picture>`, a background photo, a decorative and an undescribed picture, one in a closed answer, an SVG file, a picture another origin's script draws), captured, uploaded to the stand-in and pasted, drawn with the pictures the stand-in stored, is within 2 px of the capture at every width it read with every picture shown, as the plain paste is.
  Test: `test/web/site-upload-page.test.ts` "AC14 the media page pasted with its uploaded pictures is within 2 px of the site at every width"
- AC15 (proposed) (live): Justin runs `npm run site:upload` on B-Dry's capture against his staging site in his own terminal: the summary shows the site's own pictures uploaded, the Media Library shows them with the old site's alt texts, and a second run uploads nothing.
  Test: Justin's paste check 3ds, step A "the upload and its second run"
- AC16 (proposed) (live): The whole-page paste made by that run, pasted into an emptied staging page and saved, shows every own picture from the staging site's media library (no grey placeholder, no bdryswi.com address but those the summary named), the page's alt texts as on the old site, and looks as the `npm run site` paste did.
  Test: Justin's paste check 3ds, step B "the pasted page shows the library's pictures"

## Interfaces (exact)

`src/core/site/media.ts` (new, pure, no `URL`):

```ts
// What `npm run site:upload` put in the user's WordPress media library for a scanned page's pictures (site-media-upload),
// by the exact address the capture's code names each picture at (an img's src, a CSS url() as written)
export interface MediaPicture { id: number; url: string; filename: string; alt: string | null }
export interface SiteMedia { site: string; pictures: Record<string, MediaPicture> }
// a picture the paste shows: where (the site element's path), how (an Image or a CSS url), the element's own alt (an img's;
// undefined: none) and whether a script made it or an ancestor (a `~` segment: another company's widget, live.ts scriptMade)
export interface PictureUse { address: string; path: string; via: "img" | "css"; alt?: string; made: boolean }
const words = (s: string | null | undefined): string => (s ?? "").replace(/\s+/g, " ").trim();
// the Image settings of an img: the library picture when the map holds its address, else exactly today's (kinds.ts)
export function imageSettings(src: string, alt: string | undefined, media: SiteMedia | undefined, fileOf: (u: string) => string): Record<string, unknown> {
  const m = media?.pictures[src];
  if (!m) return { image: { url: src, external: true, filename: fileOf(src) }, ...(alt !== undefined ? { altText: alt } : {}) };
  const own = words(alt), lib = words(m.alt);
  return { image: { id: m.id, filename: m.filename, size: "full", full: m.url, url: m.url }, ...(own !== lib ? { altText: alt ?? "" } : {}) };
}
export const madePath = (path: string): boolean => path.split("/").some((seg) => seg.includes("~"));
```

- `kinds.ts`: `KindContext` gains `media?: SiteMedia`; the img branch becomes `return outer("image", imageSettings(url,
  n.attrs.alt, ctx.media, fileOf));` (key order as today, so no map = same bytes). Before writing an Image with
  `altText: ""` over a library alt with words, the builder reads Bricks' `image.php` (GPL source, the file `kinds.ts:93`
  cites) for what an empty Custom alt text does with an attachment: if Bricks ignores it, the element is named in the
  notes ("shows the library's alt text; clear it in Media or set its Custom alt text"), recorded in the ledger.
- `convert.ts` `ConvertOptions` gains `media?: SiteMedia`; `prepare` passes `media: opts.media` in the KindContext,
  records `uses: PictureUse[]` (only when `opts.media`): each Image (`via: "img"`, its `attrs.alt`) and, in `rewrite`,
  each url of `background-image`, `background`, `mask-image`, `-webkit-mask-image` (`via: "css"`, the element's path)
  that isn't `data:`. `rewrite`, only when `opts.media`: a url in the map → `m.url`; otherwise today's branch
  untouched (`background-image` + data mode → data, else the address). With no map the code path is today's.
- `Prepared.uses?`, `PartResult.pictures?`, `SiteResult.pictures?`: present only when `opts.media` is given.
  `parts.ts` / `siteToBricks`: after `payloadOf`, `if (opts.media && Object.keys(opts.media.pictures).length)
  payload.sourceUrl = opts.media.site`.
- `src/ui/uploader.ts` `UploadOptions` gains `syncAlts?: boolean` (default `true`); `finish()` runs `syncAlts` only
  when it isn't `false`. `src/ui/settings.ts`: export the existing `siteKey`.
- `tools/lib/site-write.ts` (new): `writePastes(capture, outDir, o: { part?, text, pictures?, elementor, media? }):
  string[]` (the lines `tools/site.ts:58-74` prints, the same files), and `writeSection(…)` for `--section/--path`;
  `tools/site.ts` keeps its argument parsing and calls them; `--media <file>` reads and checks `media.json` (site an
  http(s) address; each entry `id` a positive integer, `url` http(s), `filename` a string, `alt` string or null).
- `tools/lib/site-upload/` (new, each under ~150 lines): `args.ts` (flags; `--user` and `--record` take values;
  unknown flags exit 2), `ask.ts` (`askLine(question)`, `askHidden(question)`: on a terminal raw mode, nothing
  echoed, backspace, Ctrl+C exits 130; otherwise one line of input; never stored), `guard.ts` (`siteOf(address)`:
  https or loopback http, else refuse; `guardFetch(origin)`: the `env.fetch` replacement, throws on any other origin,
  passes `redirect: "error"`; `readIndex(root)`: unauthenticated GET of `/wp-json/?_fields=name,url` then
  `/?rest_route=/&_fields=name,url`, `redirect: "manual"`, a 3xx refused naming its Location, a host other than the
  typed one refused), `record.ts` (`loadRecord`, `saveRecord` atomic tmp + rename, mode 0600, `{ version: 1, sites: {
  [siteKey]: UploadCache } }`), `pictures.ts` (`uploadList(capture, uses, { svg })` → `{ items: Array<{ item:
  PictureItem; addresses: string[] }>; kept: Array<{ address: string; why: string }> }`; `mediaMap(site, items,
  media)` → `SiteMedia`), `summary.ts` (the dry-run table and the run's summary lines).
- `PictureItem` per file: `{ key: "site:" + fingerprint, kind: "fill", name: <file stem of fullSize(address)>, width,
  height (the capture's), fit: null, alt: <Q7>, altTyped: true, nodeId: <first path>, describe: false, aiAlt: null,
  photo: mime === "image/jpeg", bytes (null for an SVG), svg: <its text for an SVG with --svg>, error: null }`;
  `uploadAll(items, { wp, cache: record.sites[siteKey], photoFormat: "original", shrink: false, iconFormat: "svg",
  syncAlts: false, onProgress: save record })`. `env.decode` is set to reject ("no image decoding on the command
  line") so the >4 MB path says why it sent the original.
- `package.json`: `"site:upload": "node tools/site-upload.ts"` (count `"site:upload"` keys after any rebase).

## Tasks (in order; one commit a task, each green; ledger `.superpowers/sdd/site-media-upload/progress.md`)

Skills: `figma-to-bricks` (project), `engineering-best-practices`, `test-driven-development`, plus
`mutation-testing-discipline` (the guards are permission and secret guards). Every run of a test that may grow uses
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` on the desktop. Use only 127.0.0.1 servers; no test
or probe reaches any other host.

0. **Baseline and base goldens** (the copy still equals main). `npm run check`, `npm run test:browser`, `npm run
   test:web`, `npm run corpus`: record each tally in the ledger (the planner's base unit run on a `git archive` of
   `2879e496`, `~/.cache/smu-p/probe/unit-base.txt`: 3,523 tests, 3,453 pass, 0 fail, 70 skipped).
   Write `test/fixtures/site-media-base/` with main's converter: per hand-made capture (the seven of
   `site-slider-unchanged.test.ts` `MADE`) and per saved capture (reuse `test/fixtures/site-slider-base/capture.*.json.gz`,
   don't copy them) one sha256 per variant of `siteParts` and `npm run site`'s written files; the panel scenarios'
   request logs (`uploader-requests.json`: method, route, query, headers but Authorization, body bytes' sha256) from
   `uploadAll`/`createUploader` with fetch stubs; replay sums of every corpus file. Write `test/unit/site-media-unchanged.test.ts`
   and `test/unit/site-upload-panel-unchanged.test.ts` against them, named-only (`{ skip: !process.env.F2B_STORY_PINS
   && "story pin: set F2B_STORY_PINS=1" }`, so they never fail a later story by design); they start green. Commit.
1. **The stand-in** `test/fixtures/wp-standin.ts`: `startWordPress({ users, uploadLimit, avif, allowSvg, failAfter })`
   → `{ url, requests, items, files, stop() }`, an `http.createServer` on 127.0.0.1:0, each route's answer written from
   the WordPress source lines above (comments cite file:line; the builder may read more of WordPress 6.8 from
   `github.com/WordPress/wordpress-develop` and must not add an answer it can't cite). Then the test for AC1 (RED: the
   module doesn't exist). Commit.
2. **The uploader's `syncAlts` option** in `src/ui/uploader.ts`: first a test in `test/unit/ui-uploader.test.ts` ("a
   cache hit whose alt changed keeps WordPress's alt when syncAlts is false": no `POST wp/v2/media/<id>`), RED on base;
   then the option. The 25 existing uploader tests unchanged. Commit.
3. **The media map in the converter**: `media.ts`, `kinds.ts`, `convert.ts`, `parts.ts` as in Interfaces. Test file
   `test/unit/site-media-convert.test.ts` on `pageCode(over)` with pictures for every address and two `patch`es (the
   same file in header and footer with different alts; a CDN-sized address) and on `elementorCode()`; the AC2 and AC3
   tests (RED on base: `external: true` still written, `sourceUrl` still Figma's). The "no mapped address left" check
   walks every Image's settings and parses every `_cssCustom` with `value.ts` `parse`/`mapUrls` collecting urls (no
   regex on CSS). Run AC4's named test too. Commit.
4. **`tools/lib/site-write.ts`** (a move: `test/web/site-cli.test.ts` and `test/web/site-elementor-cli.test.ts` green
   unchanged, `npm run site` outputs byte-identical per AC4) and `--media` on `tools/site.ts`. Commit.
5. **The upload list** `tools/lib/site-upload/pictures.ts` + the AC5 test (hand-made captures: own markup, `TWIN`
   script-made, a missing file, an SVG with and without `--svg`, two CDN sizes of one file, one file at two addresses
   with different alts). Commit.
6. **`guard.ts`, `ask.ts`, `record.ts`, `args.ts`, `summary.ts`** with unit tests of their own (refusals, a record
   saved after each upload and readable after a kill, no echo in raw mode through a fake terminal stream). Commit.
7. **The command** `tools/site-upload.ts` and `package.json`'s script. `test/unit/site-upload-cli.test.ts` spawns
   `process.execPath tools/site-upload.ts …` (never `npm`, so the pid is the tool's) against the stand-in with a capture
   file written from `pageCode(...)`, password `abcd EFGH ijkl MNOP qrst UVWX`, user `f2b-tester`, `--record` in a temp
   folder; input through the child's stdin pipe (loopback only). The AC6–AC11 tests, each RED on base (the tool is
   missing). Mutation proofs (ledger, each mutant must fail its test): guardFetch allowing any origin (AC10);
   `redirect: "follow"` (AC10); the non-terminal refusal removed (AC10); `syncAlts` left `true` (AC9); the dry run
   calling `readIndex` (AC6); an error path printing the `WP` object (AC8); `sourceUrl` not set (AC3). Commit.
8. **The page check**: fixture site `test/fixtures/web/sites/media-page/` (generic markup; pictures from
   `/img/<name>-<w>x<h>.png`, a `srcset` of two sizes, an `.svg` file, another origin's script adding an `<img>` from
   `third-party/`); `test/web/site-upload-page.test.ts`: `captureFixture("media-page")`, the server closed, upload to
   the stand-in in-process (`uploadList` + `uploadAll` with `env.fetch` = guarded global fetch), `siteParts(capture,
   { media })`, every library picture's url swapped for a `data:` address of the bytes the stand-in stored (not the
   capture's), then `checkPage` at every width the capture read; the plain paste the same way as a control. Commit.
9. **Gates** on the last commit: `npm run check`, `npm run test:browser`, `npm run test:web`, `npm run corpus` (no
   width worse than base), `F2B_STORY_PINS=1 node --test test/unit/site-media-unchanged.test.ts
   test/unit/site-upload-panel-unchanged.test.ts`; screenshots or terminal captures per AC into
   `<evidence>/builder/`; the AC14 side-by-sides at 1440/1024/768/390. Commit the ledger.
10. **Docs and records**: plan copied to `docs/plans/2026-11-10-site-media-upload.md`; `docs/HANDOFF.md` section above
    the top `## ` heading (what it does, the ⭐ rulings "not yet confirmed", the stand-in's sources, follow-ups) and paste
    check **3ds** at the top of "End-of-run check list" (next free id on main and every branch on 2026-11-10; the second
    job to merge renumbers); the CLAUDE.md lines below go in the finisher's report (the builder never edits CLAUDE.md);
    `BUILD` is bumped at the merge only. The ledger is moved by the finisher.

## Tests and how each is proven

- RED on base for every new behaviour (the builder applies each test alone to a clean `git archive` of `2879e496`):
  the tests of AC2 and AC3 fail on assertions (the base ignores `media`); those of AC1, AC5–AC11 and AC14 fail because
  their module or tool is missing (named so in the ledger: a new tool's RED); the `syncAlts` test fails on the extra
  POST.
- The tests of AC4, AC12 and AC13 start green on base by construction (characterisation) and must stay green; their
  goldens are made by base's code only.
- Every guard test is proven by a mutant (Task 7). Timings: the CLI tests use the stand-in's `failAfter`, never sleeps.

## Standing-rule change (CLAUDE.md; the finisher writes it at the merge)

Under "Working in this repo", after "The importer never hides that its Chrome is automated", a new bullet:

> - **One tool writes to WordPress: `npm run site:upload`** (Justin, 2026-11-10: a scanned page's pictures "upload to
>   my Wordpress media library like how it is in the plugin", run "From the command line"). It only adds media items
>   (never changes, moves or deletes one; never touches pages, posts or settings), only on the site whose address was
>   typed, after reading that site and a typed `yes`; the Application Password is typed at its hidden prompt and never
>   goes in an argument, a variable, a file, the paste or a log. Only Justin runs it, in his own terminal, against his
>   own site. Agents never run it against his site or any live site, never ask for or hold his password, and test it
>   only against `test/fixtures/wp-standin.ts`. Every other tool (capture, the helper, site, site:check, compare,
>   replay) stays read-only; the helper still binds 127.0.0.1 only and never writes to a site.

Under "Decisions the user made", a bullet "**A scanned page's pictures go to WordPress from the command line**" with
Q1–Q11's taken answers marked "⭐ not yet confirmed", and the Status line at the merge. Memory
(`importer-media-upload`) and the skill's `references/rules-summary.md` get the same rule in one line each (the main
session saves them).

## Justin's check (paste check 3ds; after the merge)

A. In your own terminal window (Windows Terminal → Ubuntu), not through Claude:
1. `cd ~/Documents/FigmaToBricksV2`
2. `npm run site:upload -- ~/f2b-test/bdryswi-com-home.f2b-capture.json ~/f2b-test/paste-media <your staging address> --elementor --dry-run` and read the list.
3. The same line without `--dry-run`; type your WordPress user name, paste the Application Password (nothing shows),
   check the site name it prints, type `yes`.
4. Run step 3 again: it should say 0 uploaded.
5. In WordPress → Media, open two of the new pictures: their Alternative Text is the old site's.

B. 6. Join `header.json`, `page.json`, `footer.json` from `~/f2b-test/paste-media` as before (or ask for the joined
   file), paste into an emptied staging page, save. 7. Open the page: every picture shows (no grey box), right-click a
   photo → Copy image address: it is on your staging site. 8. Reply *pasted* + the page name.

## Risks

- A POST that WordPress finished after the tool gave up on it (60 s) leaves one duplicate on the next run; the tool
  never deletes anything, so you'd remove it in Media by hand (named in the summary as "timed out").
- Bricks prints a library picture through WordPress (`size-full wp-image-<id>`, `width`/`height`, `srcset`), the
  renderer draws only its `src`: AC14 can't see a layout effect of those attributes; AC16 is the judge.
- WordPress may rename a file (`-1`), scale one over 2560 px (`-scaled`); the paste uses the address WordPress answered.
- The panel and the command line don't share records (Q9): one picture uploaded from both goes up twice.
- On a site with Jetpack's CDN the library address WordPress answers may later be served through `i0.wp.com`; Bricks
  prints what WordPress gives.

## Overlaps with unmerged jobs

- **site-native-structure** (31 commits on `site-native-structure-fix2`): `src/core/site/convert.ts`, `parts.ts`
  (textual), and a second Image producer in `elementor-fold.ts` (its linked picture, `{ image: { url, external: true,
  filename }, altText }`): whichever merges second routes it through `media.ts` `imageSettings`, and AC2's test gains
  its linked-picture fixture (the "no mapped address left" walk then catches a missed producer).
- **site-menu** (`site-menu-fix4`): `kinds.ts` (`KindContext.link` gains a path; lines next to the img branch),
  `convert.ts`, `parts.ts`, `test/unit/site-kinds.test.ts`: small textual conflicts.
- **staging-fit-renderer** (`staging-fit-renderer-stack4`): `package.json` scripts (count each key after the rebase),
  `test/web/lib/site-check.ts`, `tools/site-check.ts` (AC14 uses `checkPage`, so rerun it on the stacked head).
- **staging-fit-cancels** (`classes.ts`, `blocks.ts`, `elementor-accordion.ts`) and **panel-embed-code** (`src/web/*`,
  `snapshot/web.ts`, `live.ts`): no shared lines; they change pastes or capture shapes by design, so this job's
  `site-media-base` goldens are regenerated from the stack's base by a fixer if either merges first (conversion step
  only, on the saved inputs).

## Completion

The builder stops at `ready-for-review` with every task committed, the ledger, `shots[]`/terminal captures per AC, the
mutation table, the gate tallies against base, and the CLAUDE.md lines for the finisher. AC15 and AC16 are owed to
Justin after the merge.
