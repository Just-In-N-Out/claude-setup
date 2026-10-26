# Links that open a picture, and links that stay right (link-hrefs)

**Approved by Justin 2026-10-20** (answers 1A 2A 3A 4A 5A, all recommended).

Planner: Hermes (figma-to-bricks PLANNER), 2026-10-20. Main at build `2026-10-20.13` (`b2b3a7e`), clean apart from the
user's debug file. Status: **waiting for Justin's "go"**. No worktree, branch, code or commit yet.

## 1. The request, played back

Justin (WhatsApp, a screenshot of a pasted "MORE SERVICES / Explore what else we do." section, an "ALL SERVICES"
button and four service cards in a 2×2 grid, each with an ↗ arrow):

> "When it comes to hyperlink the one on the bottom left for reason when I clicked on it, it downloaded a photo and
> didn't take me to the page can we make it so that the plugin first does not take hyperlink as photos and make them as
> webpages and moreover make it so that it is accurate with hyperlinks"

How I understand it:
1. On the live site you clicked the bottom-left service card. Instead of opening that service's page, the browser
   downloaded (or opened) a picture.
2. **First ask:** a link the plugin writes must always open a web page, never a picture file.
3. **Second ask:** links must be accurate: each card opens its own service's real page on the site, and stays
   right as you add more pages.

The catch: this already happened once (build 20.8, the Remanufactured row downloading an `.avif`). 20.8 closed the one
door it came through. This plan closes the other doors and repairs the pages you've already pasted.

## 2. What I found (root cause, with evidence)

### 2a. On the live site (read 2026-10-20 over HTTP, read only)

| Page (published) | Its grid, in order (2 columns) | Bottom-left card | Bottom-left link | What that address does |
|---|---|---|---|---|
| Hydraulic Cylinder Repairs Final | 02, 03, 04, 05 | 04 Rods | `/rods-1-15-rechroming-rods/` | **301 → `/wp-content/uploads/2026/10/rods-1-15-rechroming-rods.png`** |
| Remanufactured Hydraulics Cylinders Final | 01, 03, 04, 05 | 04 Rods | `/rods-1-15-rechroming-rods/` | **same picture** |
| Core Exchanges Final | 01, 02, 04, 05 | 04 Rods | `/rods-1-15-rechroming-rods/` | **same picture** |
| Rods 1″–15″ & Rechroming Rods Final (your screenshot's grid: 01–04) | 01, 02, 03, 04 | 03 Core Exchanges | `/core-exchanges-final/` | 200, the real page |

- On 3 of the 4 published service pages, the bottom-left card is "Rods", and its link opens the Rods picture
  (media 647, a PNG uploaded 2026-10-20 19:42, attached to no page). The Rods page itself is at
  `/rods-1-15-rechroming-rods-final/` (page 645).
- Your screenshot's own grid (01–04) is the Rods page. Its four links all open real pages today, so that page was
  most likely pasted after the Rods page existed. I can't be sure which page you clicked on. The picture link is on
  the other three.
- Other guessed addresses: `/core-exchanges/` 301s to `/core-exchanges-final/` (WordPress's own "did you mean"
  guess, because no picture holds it: the Core Exchanges picture got `core-exchanges-2`).
  `/assembly-test-paint-delivery/` is a 404 (that page isn't published).
  `/remanufactured-hydraulic-cylinders/` still opens media 514 (`.avif`; Hostinger serves AVIF as `text/plain`, so
  Chrome downloads it). No page links there now.
- **Every card's link is on the right card.** On all four pages each card's `href` comes from its own title. No link
  sits on the wrong element. The problem is **stale guessed addresses**, not links put on the wrong card.

### 2b. In the debug file (`figma-to-bricks-debug-page-1.json`, "Hydraulic Cylinder Repairs Final", build .6)

- `section.others` → `div.grid` holds four instances of "Component 3" (753×82, painted). Each one holds
  `div.oc-n` ("Service 0N"), `div.oc-t` (the title) and `div.oc-arrow` (a 16px ↗ icon). 04 Rods sits at (0, 96),
  bottom-left.
- **No card has a Figma link or hyperlink.** Their only reaction is `ON_HOVER → CHANGE_TO` (the hover variant). "All
  Services" is the same. No Figma text hyperlink exists anywhere in this file or the corpus files. So every link in
  this section is one **the plugin makes** (19.17's arrow rule): card → its title → `/slug-of-title/`.
- The page's hero picture is named exactly like the page minus "Final" (picture "Hydraulic Cylinder Repairs" in frame
  "Hydraulic Cylinder Repairs Final"). Each service page follows this pattern, the Rods page included.

### 2c. In the code: four doors a picture gets through

1. **The core guesses an address no page owns.** `src/core/normalise/page-links.ts:80`
   `pageAddress(hit.name)` gives `/rods-1-15-rechroming-rods/`, the slug of the card's title.
2. **The site check runs once, at Convert time, against the pages that exist then.**
   `src/ui/site-read.ts:109-118` `checkLinks` → `src/ui/site-pages.ts:90-103` `matchPages`. When the Hydraulic,
   Remanufactured and Core pages were converted, the Rods page didn't exist yet. So the Rods link kept its guess, with
   only a note (`site-pages.ts:97`, note at `:152`). Its picture check (`site-read.ts:113-116`
   `pictureAddresses`) ran then too and found nothing, because the picture came later.
3. **Uploads only avoid the addresses the current paste links to.** `src/ui/files.ts:24` `safeFilename(…, taken)`,
   with `taken` built in `src/ui/run.ts:57` from this paste's own page links. Converting the Rods page uploaded its
   hero picture named after the service, so it took `/rods-1-15-rechroming-rods/` from every other page's earlier
   paste. Uploaded videos have no guard at all (`src/ui/videos.ts:177` `videoUploadName`).
   - Open point for the builder: the Rods page's own grid lists Rods, so 20.8's `taken` should have renamed media 647
     (20.8 was live from 06:38). The builder must check every upload path against it (fresh upload, the WebP-refused
     fallback at `uploader.ts:83`, the SVG→PNG fallback, the cache).
4. **WordPress gives every upload not attached to a page the top-level address `/<file name>/`.** Since WordPress 6.4
   (attachment pages off) that address redirects to the file itself. So a guessed page address plus a picture of the
   same name gives a link that opens a picture.

There's also a smaller gap: nothing in the core stops a link that **is** a picture file. A Figma "Open link" or text
hyperlink typed as `…/photo.png` passes `safeUrl` (`normalise/links.ts:13`). Text hyperlinks skip `safeUrl` entirely
(`normalise/text.ts:40` `hyperlinkOf`). `emit/elements.ts:107` writes whatever arrives.

## 3. Approach (general, nothing keyed on this design)

Five rules, each true for any design and any WordPress site:

1. **A link is never a picture or video file.** Whatever made it (a Figma Open link, a text hyperlink, the plugin's
   arrows and words), an address whose path ends in a picture or video file type (`png jpg jpeg gif webp avif svg
   bmp ico tif tiff heic heif mp4 webm mov m4v ogv`) is never written as a link. The panel names each one dropped.
   Documents (PDF and the like) stay allowed: "Download full inventory (PDF)" is meant to be a file link. A video's
   Open link stays the video's source, as it is today (`normalise.ts:138`). `payloadProblems` refuses a picture-file
   link, so no later change can bring one back.
2. **The plugin's uploads never take an address a page could have.** Every picture the panel uploads ends in
   `-image` and every video in `-video` (unless the name already ends in that word), so WordPress gives them
   `/<name>-image/`. No page name produces that. This covers the case 20.8 missed: a page's hero named like the page
   itself, and pages pasted earlier. Pictures already uploaded are reused from the upload cache, so nothing goes up
   twice. Pictures inside the JSON (embed mode) keep their names.
3. **Every link address is checked against the media library on every Convert,** not only links with no page: the
   core's guessed address of every listed link, in one `wp/v2/media?slug=` request.
   - **A picture the plugin itself uploaded** (its media id is in the panel's upload cache) sitting on a page's
     address gets its WordPress address changed to `<slug>-image` (`POST wp/v2/media/<id>` `{slug}`). Its file, its
     URL and every pasted image stay exactly as they are; only the address WordPress lent it is freed. Then WordPress's
     own guess (already seen on your site: `/core-exchanges/` → `/core-exchanges-final/`) sends the old address to the
     real page. **This fixes the three pages you've already pasted without re-pasting them.**
   - **A picture someone else uploaded** on a link's address: the plugin leaves it alone and the link comes off, as
     in 20.8. The panel names it.
   - If WordPress refuses the change (permissions): the link comes off, and the note says why.
4. **A link to a page that doesn't exist yet keeps its address,** now safe from pictures. The note says plainly that
   it starts working once that page is published (WordPress forwards `/x/` to `/x-final/`), or to convert again
   after creating it. Pages that exist are linked to their real address, as 20.7/20.8 do.
5. **Links stay on the right element.** A generic fixture locks in the pattern: a grid of alike cards, each linking
   to its own title, and the panel's element list (`PageAddress.ids`) naming each card's own element, so a relink can
   never move an address to a sibling.

Where it lives: rule 1 in normalise (`links.ts`, `text.ts`) and emit's `payloadProblems`; rules 2–4 in the panel
(`ui/files.ts`, `ui/uploader.ts`, `ui/videos.ts`, `ui/site-read.ts`, `ui/site-pages.ts`, `ui/run.ts`); rule 5 is
tests. No stage edits another stage's output: the core never knows about WordPress, and the panel changes only the
elements the core listed, as today.

## 4. Tasks (test first; commit after each passing task)

0. **Setup.** Step 2 worktree `link-hrefs`, `npm run check` green, then `npm run corpus` and keep its numbers. Copy this
   plan to `docs/plans/2026-10-20-link-hrefs.md`, and start the ledger `.superpowers/sdd/2026-10-20-link-hrefs/progress.md`.
1. **No link is a file (core).**
   - RED: `test/unit/normalise.test.ts` (or a new `normalise-links.test.ts`):
     - `linkOf` drops `https://site.test/wp-content/uploads/2026/10/a.png`, `/photo.AVIF?x=1` and
       `https://cdn.test/clip.mp4#t=3`, each with one warning;
     - it keeps `/services/`, `https://site.test/inventory.pdf`, `mailto:`, `tel:`, `#top` and a bare domain;
     - a Figma text hyperlink gets the same treatment and now goes through `safeUrl` (`javascript:` dropped);
     - an Open link to a video is still the video's source, not a dropped link.
   - RED: `payloadProblems` refuses an element whose `settings.link.url` is a picture or video file.
   - GREEN: `fileAddress(url)` in `normalise/links.ts` (path's last part, query and hash ignored, case-insensitive),
     used by `linkOf` and `hyperlinkOf`; the check in `emit/payload.ts`.
   - Corpus invariant in `test/unit/corpus-page-links.test.ts`: on every corpus file, no link and no `<a href>` in rich
     text is a picture/video file.
2. **Uploads never look like a page.**
   - RED: `test/unit/ui-files.test.ts`: `safeFilename("Rods & Things", "png")` gives `rods-things-image.png`;
     `"Team Image"` stays `team-image.png`; embed names stay as before. `videoUploadName` gives `…-video.mp4`.
   - RED: `test/unit/ui-uploader.test.ts`: every path uploads the suffixed name (fresh, WebP-refused fallback,
     SVG→PNG fallback). Find out why media 647 kept its plain name under 20.8 (§2c point 3) and cover that path.
   - GREEN: `ui/files.ts` (the `taken` set becomes unnecessary: remove it and its plumbing in `run.ts`/`uploader.ts`
     if nothing else needs it), `ui/videos.ts`.
3. **Check every link against the media library; free the plugin's own pictures.**
   - RED: `test/unit/ui-site-read.test.ts`, with the panel fixtures:
     - one `wp/v2/media?slug=` request covers every listed link's address (matched or not);
     - a picture in the upload cache on `/service-d/`: `POST wp/v2/media/<id>` with `slug: "service-d-image"`; the link
       stays `/service-d/` when no page matches it, or goes to the matched page as before; one note names the freed
       picture;
     - a picture not in the cache: no POST, the link comes off (20.8's behaviour), a note;
     - the POST refused (403, `rest_cannot_edit`): the link comes off, the note gives WordPress's reason;
     - a media read that fails: links are left as matched, nothing renamed.
   - GREEN: `site-read.ts` (`pictureAddresses` over all addresses; new `freeAddress`), `checkLinks(wp, links, own)`
     with `own` = the upload cache's media ids passed from `run.ts` `startRun`; `site-pages.ts` `Match` gets
     `freed: boolean`; `relink` unchanged in spirit (only listed elements, only while the link still reads the old
     address).
4. **Notes say what happens next.**
   - RED: `test/unit/ui-site-pages.test.ts`:
     - a link to no page: "… no page on <site> is named like it yet; the link goes to /x/, which opens the page once
       you publish one named like it (or convert again after creating it)";
     - a freed picture: "\"Service D\": the picture service-d.png was using /service-d/ on <site>; its address is
       now /service-d-image/, so the link opens the page";
     - the summary line counts freed and removed links.
   - GREEN: `linkNotes`.
5. **Links stay on their own card (generic fixture).**
   - New `test/fixtures/service-grid.ts`: a section with a kicker and heading row, an "All services ↗" pill, and a
     2×2 grid of alike painted cards (a "Service 0N" kicker, a title, a 16px ↗ icon drawn as two strokes), with
     generic titles ("Window Cleaning", "Gutter Repair", …) and hover-only reactions. Give it a sibling text so it
     isn't swallowed as the section's Container (CLAUDE.md fixture note).
   - Tests in `test/unit/convert-page-links.test.ts`:
     - each card's `settings.link.url` is its own title's slug, and the pill's is `/services/`;
     - `pageLinks[i].ids` is exactly the id of the card carrying that address;
     - after `relink` with one card's page found, only that card changes;
     - no card's link is a picture file;
     - phone copies carry their own card's address.
6. **Close.**
   - Replay the user's debug file: the grid's four cards link to `/remanufactured-hydraulic-cylinders/`,
     `/core-exchanges/`, `/rods-1-15-rechroming-rods/` and `/assembly-test-paint-delivery/`, the pill to `/services/`.
   - Run a dry run of `checkLinks` against stubbed answers copied from the live site's REST (pages and media 647/514
     as read on 2026-10-20). Rods is then freed and goes to `/rods-1-15-rechroming-rods-final/`. Reman goes to
     `/remanufactured-hydraulics-cylinders-final/`, and 514 is freed only if it's in the cache.
   - `npm run check`, and `npm run corpus`, which must be no worse on any file (pastes expected byte-identical: no
     corpus link is a file).
   - Stop at `ready-for-review` (the main chat runs the opus review; the finisher does the fix pass).
7. **Docs & records** (Justin asked for this explicitly).
   - **Plan:** copied into the copy as `docs/plans/2026-10-20-link-hrefs.md` (Task 0), with any change made while
     building noted in it.
   - **Ledger:** `.superpowers/sdd/2026-10-20-link-hrefs/progress.md` moved to
     `docs/plans/2026-10-20-link-hrefs-ledger.md` once built and reviewed (rulings, review fixes, deferred minors).
   - **`docs/HANDOFF.md`:** a new section "Links that opened a picture, and links kept right" (the report, the live-site
     table above, the four doors, the fixes, tests, corpus, deferred). It also gets:
     - a line under "A link that downloaded a picture" pointing to it;
     - a new paste check **3aa** in "End-of-run check list": convert any service page again with WordPress connected;
       check that the panel says it freed the Rods picture's address; Purge All in LiteSpeed; on the Hydraulic, Reman
       and Core pages, the bottom-left Rods card opens `/rods-1-15-rechroming-rods-final/` without a re-paste; a new
       upload's name ends in `-image`.
   - **`BUILD`:** bumped in `src/shared/build.ts` by the finisher at the merge (`2026-10-20.14` or the next free
     number), never in the copy.
   - **Main folder `CLAUDE.md`:** after the merge, the finisher updates "Start here" (new build, what changed, paste
     check 3aa) and "Where things stand" (a "Links that opened a picture" entry), following figma-to-bricks Step 4.6.
   - **New `CLAUDE.md` rules** for future sessions, added by the finisher, never edited in the copy:
     - *Working in this repo:* "A WordPress upload not attached to a page owns the address `/<its file name>/`, and
       since WP 6.4 that address redirects to the file. So the panel's uploads always end in `-image`/`-video`, and a
       link is never a picture or video file (`payloadProblems` refuses one)."
     - *Decisions → Links to pages:* the rulings chosen in §6 below (freeing the plugin's own pictures; links to pages
       not yet created keep their address).

## 5. Tests in one list

`normalise` (links, text hyperlinks), `emit` `payloadProblems`, `corpus-page-links` (no file links on any corpus
file), `ui-files`, `ui-uploader` (every upload path), `ui-site-read` (one media read, free, remove, refused, failed),
`ui-site-pages` (notes), `convert-page-links` + fixture `service-grid.ts` (own card, ids, relink, phone copies). Each
new test is written first and seen failing. For the uploader path behind media 647, the fix is proven by checking out
the old files (CLAUDE.md "Prove a new test catches the bug").

## 6. Choices made (the recommended answers below; "go" builds exactly this)

1. Upload names always end in `-image` / `-video` (not only when they match this page or its links).
2. A link to a page not created yet keeps its address (it starts working once the page exists); it isn't removed.
3. The plugin changes the WordPress address of **its own** uploaded pictures that sit on a page's address; it never
   touches media it didn't upload (those links come off, as in 20.8).
4. A link typed in Figma to a picture or video file is dropped and named in the panel; documents (PDF) stay.
5. Figma text links that point to another frame (dropped today, none in your files) are left for a later fix.
6. Not changed: how the plugin picks the card, the title and the arrow (19.17), and the name matching (20.7/20.8).
   The live pages show those are right.

## 7. Open questions (each written as if the recommended option were chosen)

1. Upload names: **A) Always add -image / -video (recommended)**; B) Only when named like a page link.
2. A link to a page you haven't created yet: **A) Keep it; works once the page exists (recommended)**; B) Remove it
   until the page exists.
3. The Rods picture already holding a page's address: **A) Plugin renames its own picture's address (recommended)**;
   B) Leave media alone; I re-paste those pages.
4. A Figma link typed to a picture file: **A) Drop it and name it in the panel (recommended)**; B) Keep the designer's
   own link.
5. Figma text links to another frame (dropped today): **A) Later, as its own fix (recommended)**; B) Add them now.

## 8. Risks

- **WordPress's forward from the old address:** freeing `/rods-1-15-rechroming-rods/` relies on WordPress sending it
  on to `/rods-1-15-rechroming-rods-final/` (its "guess the page" redirect, seen working for `/core-exchanges/`). It
  should, because the old-slug redirect looks for posts, not media. The builder confirms this in WordPress's source
  (`wp_old_slug_redirect`, `redirect_guess_404_permalink`, `get_page_by_path`'s attachment lookup), and paste check
  3aa confirms it on the site. If it doesn't hold, the fallback is to re-convert and re-paste the three pages.
- **LiteSpeed may cache the old redirect:** Purge All after the run (in the report steps).
- **Only pictures in the panel's upload cache are freed.** If Figma's plugin storage was cleared, media 647/514 count
  as "someone else's" and their links come off instead (still never a picture). The note says so.
- **The guess can only reach published pages:** a link to a draft opens a 404 until it's published, as today. That's
  the existing "publish it" note.
- **Changing an upload's address** changes only its attachment URL (already a redirect to the file). Its file URL, id,
  alt text and every pasted image stay the same.
- **New upload names** look slightly different in the Media library (`hero-photo-image.avif`). Search engines and the
  page don't care.
- **One more REST write** (`POST wp/v2/media/<id>`) needs the same edit right uploads already use. A refusal is
  handled (the link comes off, with a note).
- **The unexplained 20.8 gap** (media 647's plain name) could be in a path the tests don't reach yet. Task 2 hunts
  it down first.

## 9. Parts of the pipeline this touches

- **normalise:** `src/core/normalise/links.ts` (`fileAddress`, `linkOf`), `src/core/normalise/text.ts`
  (`hyperlinkOf` through `safeUrl` + the file check).
- **emit:** `src/core/emit/payload.ts` (`payloadProblems`). `page-addresses.ts` and `elements.ts` are read but not
  changed.
- **panel:** `src/ui/files.ts`, `src/ui/uploader.ts`, `src/ui/videos.ts`, `src/ui/site-read.ts`,
  `src/ui/site-pages.ts`, `src/ui/run.ts` (and `src/ui/wordpress.ts` only if the POST needs a helper).
- **tests:** the files in §5 and a new fixture `test/fixtures/service-grid.ts`.
- **docs:** `docs/plans/2026-10-20-link-hrefs*.md`, `docs/HANDOFF.md`; after the merge, `src/shared/build.ts` and the
  main folder's `CLAUDE.md` (finisher).
- **Not touched:** understand, style, adapt, the arrow and title rules, the extract (no `figma.*` change).
- **Earlier features in the same code:** 19.7 call links (`contact-links.ts`, unchanged), 19.17 page links
  (`page-links.ts`, unchanged), 20.7/20.8 site check (`site-read.ts`, `site-pages.ts`, extended), 19.16/20.5 video
  uploads (`videos.ts`, name only).

## 10. After the merge: Justin's steps (for the report)

1. Reload the plugin in Figma.
2. Convert any service page with WordPress connected (pictures "to WordPress"). The panel should say it freed the
   Rods picture's address.
3. LiteSpeed → Purge All.
4. On Hydraulic Cylinder Repairs Final, click the bottom-left "Rods" card: it should open the Rods page.
5. Paste the page you converted, if you want its fresh links too.

## Justin's answers (2026-10-20)

1A, 2A, 3A, 4A, 5A — all the recommended options. The plan as written stands.
