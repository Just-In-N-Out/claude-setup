# internal-links: a link to one of the site's own pages is Bricks' Internal link (Mini, both tools)

Planner, 2026-11-16 15:05. Base: main `c7abf6d5` (Build 2026-11-16.3). Main moved while this was planned (from
`ebc7b1d9`, Build 2026-11-16.2, the brief's base: site-sticky-cards merged and changed `convert.ts`, `parts.ts` and
the README); the proofs below were run again on `c7abf6d5`. Plan only: nothing in the repo was changed.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/internal-links/planner/` (index at the end).

## Questions for Justin (⭐ = what the builder takes under the standing auto-go)

- **Q1. The importer must read your page list to know each page's number.** Today `site:upload`, `site:import` and
  the app read only Media and WPForms' form list. This job adds two reads after the login, GET only, never a write:
  the page list (`wp/v2/pages`: number, title, address, status, drafts included) and three fields of the site's index
  (`home`, `page_on_front`, `show_on_front`: which page is the homepage). They run only when the pastes hold a link to
  the site's own pages, never on a dry run. The list is saved as `pages.json` beside `media.json` (it holds your
  pages' titles, drafts' too, on your computer only). This changes CLAUDE.md's one-uploader rule (its read list).
  - ⭐ **A. Yes, read them on every upload that needs them.** No new flag; `npm run site … --pages pages.json`
    remakes the pastes offline.
  - B. Only with a flag (`--pages-read`). Without it links stay Custom URL.
- **Q2. The logo and every linked picture keep "Other (URL)".** Bricks' Image element has no Internal link type: its
  Link To offers Lightbox, Attachment Page, Media File and Other (URL) only (read in Bricks 2.4.2's builder).
  - ⭐ **A. Keep them as they are** (`/`), named in the notes. So in paste check 3fg the logo still reads Other (URL);
    a Button and a menu link read Internal.
  - B. Put a Block link around each linked picture so it can be Internal. It adds a wrapper that does nothing else
    (against the "no wrapper" rule) and changes logo-media's shapes.
- **Q3. A Heading whose words are one bare link carries it in Link to.** B-Dry's drawer menu is 11 Headings whose
  whole text is `<a href="/page/">Name</a>`. Bricks prints a linked Heading as the same HTML, so nothing moves.
  - ⭐ **A. Yes, when its page is found:** the words lose the `<a>`, Link to shows Internal → the page. A Heading
    whose link carries a class or has words beside it stays as it is.
  - B. Leave them: the drawer's menu links stay addresses typed in the words.
- **Q4. How an old address finds its new page.**
  - ⭐ **A. By the same address only** (`/sumppump/` → the page at `/sumppump/`; capitals and the end slash don't
    matter; `/` → the homepage page). A link whose page isn't at that address stays Custom URL and the notes name it.
  - B. Also by the last word of the address when the page moved (`/services/sumppump/` → `/sumppump/`). It can pick
    a wrong page.
- **Q5. A page that isn't published yet** (a draft).
  - ⭐ **A. Link it all the same:** the link works once you publish the page; the notes name the page.
  - B. Keep Custom URL until it is published.
- **Q6. Figma plugin: a link to the homepage** (a "Home" menu word linking to `/`).
  - ⭐ **A. It goes to your homepage page** (one more read of the site's index while the panel reads your pages).
  - B. Leave homepage links as `/`.
- **Q7 (not blocking). Your own copy of an Internal link** replaces the researched sample: in Bricks, a Button with
  Link to → Internal → a page (select it, Ctrl+C, paste the text into a file); the same with "URL parameters"
  filled; and an Image with a link. From darksalmon (2.3.9) and B-Dry staging (2.4.2) if you can.

## Playback

Niklas: "the link type shouldn't be custom, it should be internal / post-page". Today both tools write every link
to the site's own pages as `link: { type: "external", url: "/contact-us/" }` (Custom URL). After this job, where the
tool knows the page on the new site, the element's Link to is Internal → that page (by its number), in both tools,
written by one shared function. Where it doesn't know the page, or Bricks has no Internal type for the element, the
link stays as it is and the notes say so. A paste with no page list is byte for byte main's.

**The Bricks-pro standard (point 5, editable content):** a pro links a page with Link to → Internal: the link
follows the page when its address changes, shows the page's title in the field, and a draft's link starts working
when the page is published. Point 2/3 untouched (no class or CSS changes). Point 6 holds: every element draws as
before (measured: the printed HTML of the home scan is the same but for the hrefs).

## What Bricks does (sources: `evidence/…/bricks-internal-link.txt`)

- **Shape:** `link: { type: "internal", postId: "<page number>", urlParams?: "?a=1#b", newTab?, rel?, title?,
  ariaLabel? }`. `postId` is a string of digits, as the picker stores it (the builder's select emits an object key
  and asks for a stored value's title only when the value has a length). `urlParams` holds a query and hash; Bricks
  prints `get_the_permalink(postId) . urlParams` (Bricks 2.2 `base.php` L2175-2189) and **no href at all** when the
  number names no post.
- **Paste rule (Bricks 2.4.2 builder, run for real in `bricks-paste-links.cjs`):** a paste whose `sourceUrl` is set
  and isn't the site's own address has the `postId` of every Internal link deleted. The plugin's default
  `sourceUrl` is `https://www.figma.com`. **So a paste holding an Internal link names its site in `sourceUrl`**, as a
  paste with library pictures already does, and is pasted on that site only. Bricks 2.2 has no such deletion (a
  number pasted on another site would name another post); 2.3.9 (darksalmon) was not read. Naming the site is right
  on all three.
- **Image:** no Internal type (Q2). Taxonomy links are `type: "taxonomy", term: "taxonomy::id"`; this job reads
  pages only, so posts, categories and archives stay Custom URL, named.
- **`reference/bricks/` holds no Internal sample** (README L844-846: "never written"). Bricks' own code is enough
  to build on (shape, printing and paste rule all read from it); Justin's copy (Q7) replaces the researched sample
  when it arrives.

## Where each tool gets the page's number

- **Importer:** new `tools/lib/site-upload/pages.ts` `findPages(login, parts, outDir, out)`, called beside
  `findForms` (after the login, before the yes; `site:import` through `after-scan.ts`). It reads only when a paste
  holds a link to a site path (`siteLinksIn`), with the panel's own reader `sitePages(login.wp)`
  (`src/ui/site-read.ts`: `wp/v2/pages`, 100 a time, drafts where the user may see them, at most 2,000) and one
  index read (`_fields=home,page_on_front,show_on_front`). It writes `pages.json`:
  `{ site, front, pages: [{ id, path, title, status }], truncated? }`; `site` is `login.index.url` (the same value
  `media.json` holds), `path` the page's address under the site's home (`addressOf`, exported from
  `ui/site-pages.ts`), `front` the homepage page (`show_on_front === "page"`; when the index doesn't say, the
  published page whose address is the home address; else `null`). A read that fails is one plain line, links keep
  Custom URL, never a stop. `npm run site … --pages <pages.json>` remakes offline; the app's "Make pastes again"
  passes it when the file is there.
- **Plugin:** nothing new to read for pages: the panel already matches each page link to a site page
  (`checkLinks` → `Match.page.id`). After `relink`, a new `internalLinks(payload, matches, front)` turns each
  matched element link into an Internal link. For Q6 the check also reads the index's homepage fields and runs when
  the paste holds an element link to `/`.
- **Matching (importer, Q4 A):** `pageAt(pages, url)`: only a site path (`/…`, never `//…`, `#…`, `tel:`,
  another host); the path decoded, lower case, end slashes off; `/` → `front`; several pages at one address: the
  published one, then the lowest number; the query and hash go to `urlParams`.

## Acceptance criteria (all proposed; one test each)

- AC1 (proposed): Importer, a page that is known. Given a pages map, an element's link to a page of it is `{ type: "internal", postId: "<id>", urlParams?, …its other keys in their order }`, the homepage link goes to the map's `front` page, the paste's `sourceUrl` is the map's site and one `Links:` note counts them and says "paste on that site only"; a draft page is linked and named. Test: `test/unit/site-page-links.test.ts` "AC1 a link to a page of the pages map is an Internal link: its page number, its query and hash in urlParams, its other keys kept".
- AC2 (proposed): Importer, everything else stays and is named. A link with no page at its address, a linked picture (Image), a link inside a text's words, another site's address and a homepage link on a site whose homepage isn't a page keep their bytes, each kind named once in the notes; a map none of whose pages is linked, and no map, leave the paste as it was. Test: `test/unit/site-page-links.test.ts` "AC2 a link with no page, a linked picture, a link in the words, and every address off the site stay as written, each kind named once".
- AC3 (proposed): Importer, a Heading whose words are one bare link to a known page carries it in Link to (words without the `<a>`), the printed page the same but for hrefs; a Heading whose link carries more than its address, or with words beside the link, is as before. Test: `test/unit/site-page-links.test.ts` "AC3 a Heading whose words are one bare link to a page carries it in Link to; any other Heading is as before".
- AC4 (proposed): Plugin panel. With a connected site, each element link `relink` sent to a matched page is an Internal link of that page's number (inline and WordPress picture modes), a link to `/` goes to the site's homepage page, the paste's `sourceUrl` is the site and one note says so; a typed address, a tied or unmatched page, a linked picture and a link inside words stay as `relink` left them; not connected: the paste is as before. Test: `test/unit/ui-internal-links.test.ts` "AC4 connected: an element's link to a matched page is an Internal link, the homepage link goes to the site's homepage page, and the paste names the site".
- AC5 (proposed): One shape, one emitter. Every Internal link either tool writes deep-equals `internalLink()` of `src/core/emit/link-shape.ts` (no other file writes `type: "internal"`), and `payloadProblems` refuses an Internal link whose `postId` isn't a string of digits, that keeps a `url`, that sits on an Image, or in a paste whose `sourceUrl` is the Figma default; the nested-links test counts an Internal link as a link. Test: `test/unit/emit-link-shape.test.ts` "AC5 both tools write an Internal link through internalLink, and the paste guard refuses one with no page, on an Image or in a paste that names no site".
- AC6 (proposed): Bricks' paste rule. Through `test/fixtures/bricks-paste.ts` (taught Bricks 2.4.2's rule from its own code), a paste from each tool pasted on its own site keeps every `postId` and the renderer prints its href; pasted from another address every Internal link is emptied; the joined paste (`wholePayload`, the app's Copy all) names the site when any part does. Test: `test/unit/bricks-paste-links.test.ts` "AC6 pasted on its own site every Internal link keeps its page; from another address Bricks empties it; the joined paste names the site when any part does".
- AC7 (proposed): The importer's read (Q1 A). Against the stand-in only: `site:upload` and `site:import`'s steps after the scan read the index's homepage fields and the page list after the login (GET only, nothing but those two routes added to what main sends), write `pages.json` beside `media.json`, and the pastes hold Internal links; a capture with no link to a site path sends neither request; `--dry-run` reads nothing; a refused or failed read is one plain line, the pastes keep Custom URL and the run doesn't stop. Test: `test/unit/site-upload-pages.test.ts` "AC7 after the login the page list is read (GET only), pages.json is written beside media.json and the pastes hold Internal links; a dry run reads nothing".
- AC8 (proposed): The stand-in answers as WordPress 6.8 does (each answer cited to its file and line in `evidence/…/wp-6.8/`): `GET wp/v2/pages` (edit context only for a user with `edit_posts`, statuses, `_fields`, 100 a page, `X-WP-Total`/`X-WP-TotalPages`, `rest_post_invalid_page_number` past the end, a draft's `link` as `?page_id=N`, `permalink_template` and `generated_slug` in the edit context only) and the index's `home`, `page_on_front`, `show_on_front`; any other method on the route is refused. Test: `test/unit/wp-standin-pages.test.ts` "AC8 the stand-in answers the page list and the homepage setting as WordPress 6.8 does".
- AC9 (proposed): Offline remake. `npm run site -- <capture> <out> --media media.json --pages pages.json` writes the upload's pastes byte for byte; a pages file that isn't one, or names another site than the media map, is refused in one plain line with nothing written; the importer app's "Make pastes again" passes `--pages <folder>/pages.json` when that file is there. Test: `test/unit/site-pages-flag.test.ts` "AC9 npm run site with --pages remakes the upload's pastes offline, a bad or other-site pages file is refused in one line, and the app passes pages.json".
- AC10 (proposed): Without a pages map nothing moves. Every site paste (both routes, both text modes, with and without a media map, whole and by section), its notes, `structure.txt`, `styles.txt` and palette are the base's (`c7abf6d5`) byte for byte. Test: `test/unit/internal-links-site-pins.test.ts` "AC10 story pin: without a pages map every site paste, its notes and its files are the base's byte for byte".
- AC11 (proposed): Figma, plugin = replay. The plugin's conversion is still a replay's byte for byte (the Internal step lives in the panel, after the conversion), and `src/core` still passes the sandbox typecheck. Test: `test/unit/plugin-convert.test.ts` "the plugin's paste is exactly what a replay of the same snapshot gives".
- AC12 (proposed) (live): Paste check **3fg**, Justin's own. In the importer app pick the home scan → Pictures to WordPress → Log in and check → yes (nothing already in the library goes up again; `pages.json` is written) → Copy header and Copy body → paste on B-Dry staging. Click a "Contact Us" Button and a drawer menu word: Link to shows Internal → the page; the logo shows Other (URL) `/` (Q2 A); the looks at 1440 and 390 as before. Later "Make pastes again" keeps the Internal links without logging in.

The test of AC11 is green on the base and must stay green (a regression criterion). The pin of AC10 is a story pin: it runs with
`F2B_STORY_PINS=1`, `F2B_BASE_TREE` (a `git archive` of `c7abf6d5` with `node_modules` linked) and
`F2B_BDRY_CAPTURE`/`F2B_BDRY_MEDIA` (copies under the builder's own `~/.cache`); a skip is never a pass.

## Proved on scratch trees (`git archive` of main plus the prototype, `evidence/…/prototype.patch`)

First on `ebc7b1d9` (`~/.cache/inl-pl/tree`), then again on `c7abf6d5` (`~/.cache/inl-pl/tree-163`; two `convert.ts`
hunks placed by `wire-163.cjs`, beside site-sticky-cards' own lines). Receipt for `c7abf6d5`: `proto-on-16.3.txt`.

- The test file of AC1 to AC3 (`evidence/…/site-page-links.test.ts`): 3 of 3 pass on the prototype, 0 of 3 on
  main (three assertion failures, not import errors: main ignores the option), on both bases
  (`ac123-proto.log`, `ac123-base.log`; `ac123-proto-163.log`, `ac123-base-163.log`).
- The saved B-Dry home scan with a made-up pages map (`pages-bdry-standin.json`; no site was read): header 2
  Buttons + 11 Headings Internal (3 logo Images kept), page 16 Buttons, footer 1 Button (1 Image, 2 inline links
  kept). The only leaves that differ from main's pastes are `button.link`, `heading.text`, `heading.link`
  (`proto-home-diff.txt`); notes differ only by the `Links:` lines; structure, styles and palette byte for byte;
  the printed HTML the same but the hrefs (`proto-home-render.txt`).
- Without `--pages` the prototype's whole output folder is main's byte for byte on both bases (`proto-home-off.txt`,
  `proto-on-16.3.txt`); `ebc7b1d9`'s is Justin's saved paste folder's.
- `npm run typecheck` (sandbox config included) passes on the prototype on both bases (`typecheck-proto.log`,
  `typecheck-proto-163.log`).
- Panel prototype (`wire-plugin.cjs`; run on `ebc7b1d9` only, the merge since touched no panel file):
  `plugin-convert` stays green; **six existing tests pin today's Custom URL through `startRun`** and change on
  purpose (task 6).
- Not run: the browser suites, the whole unit suite and the corpus (the machine was loaded); the builder runs them.

## Tasks (test first; one commit a task; `npm run check` green after each unless said)

Use the prototype in the evidence folder as the starting code (`prototype.patch` is the whole of it against
`ebc7b1d9`; on `c7abf6d5` its two `convert.ts` hunks go in as `wire-163.cjs` places them). It ran green, but read it
as a draft: it has no `readPages` check, no upload read, no guard and no app wiring yet.

1. **The shared emitter.** Add `src/core/emit/link-shape.ts` from `evidence/…/link-shape.ts` (`internalLink(link,
   postId, tail)`, `internalOffered(element)`, `isInternal(link)`; imports nothing, sandbox-safe). First confirm
   `internalOffered`: for every element name that carries `link` in either tool's pastes (button, text-link,
   heading, block, div, container, section, icon, image, the Nav's items) read Bricks 2.2's element file
   (`gh api repos/saqib6571/bricksbuilder/contents/includes/elements/<name>.php`, public GPL code, no project
   detail in the request) and check its `link` is a `'type' => 'link'` control; list the result in the ledger; any
   other exception joins `image`. RED: `test/unit/emit-link-shape.test.ts`'s shape half (key order `type, postId,
   urlParams, …rest`; `url` dropped; `postId` a string). GREEN, commit.
2. **The importer's pass.** Add `src/core/site/page-links.ts` from `evidence/…/page-links.ts` (`SitePages`,
   `pageAt`, `withPageLinks`, `pageLinkNotes`, plus `siteLinksIn(payload): boolean`). Wire it as `wire.cjs` does:
   `ConvertOptions.pages?: SitePages`; in `parts.ts` just before the Code line (the paste's last change; nothing
   reads a link after it), in `convert.ts` for a section paste after `parityNotes`. RED/GREEN:
   `node --test test/unit/site-page-links.test.ts` (copy from the evidence folder; RED = 3 assertion failures).
   The test renderer first: `test/browser/render.ts` prints an Internal link as `href="/?page_id=<postId><urlParams>"`
   (`linkAttributes`, and the `s.link.url ?` check near L242; the hunk is in `prototype.patch`).
   Add the three producers to `test/unit/emit-nested-links.test.ts` (an Internal link is a link) and teach
   `linksOf` (`emit/payload.ts` L151) to count one.
3. **The guard and Bricks' paste rule.** `payloadProblems`: an Internal link needs `postId` matching `^[1-9]\d*$`,
   no `url`, an element `internalOffered`, and a `sourceUrl` that isn't the Figma default (these shapes come only
   from this job's code, so no paste main made is refused; receipt: AC10's pin and the corpus). `test/fixtures/
   bricks-paste.ts`: add 2.4.2's rule (a set `sourceUrl` that isn't the site's → delete `postId`, `term`,
   `mediaData` by link type, deep), cited to the builder script. `tools/lib/site-whole.ts` `wholePayload`: today it
   takes the header's `sourceUrl` only; take the first part's that isn't the Figma default (refuse two parts naming
   two sites). RED/GREEN: `test/unit/emit-link-shape.test.ts` (guard half), `test/unit/bricks-paste-links.test.ts`.
4. **The stand-in.** `test/fixtures/wp-standin.ts`: options `pages` and `front`; the index answers `home`,
   `page_on_front`, `show_on_front`; `GET wp/v2/pages` as WordPress 6.8's posts controller does (every branch cited
   to `evidence/…/wp-6.8/*.php` line numbers listed in `bricks-internal-link.txt` section 6; the fixture's old
   source cache `~/.cache/smu-b/wp-src` isn't on this machine). RED/GREEN: `test/unit/wp-standin-pages.test.ts`.
5. **The read and the files.** `tools/lib/site-upload/pages.ts` (`findPages`, `writePagesMap`, `pagesLine`,
   modelled on `forms.ts`; every line through `out`), called in `flow.ts` beside the forms and in
   `site-import/after-scan.ts`; `Picked.pages`; `writePastes(…, { media, forms, pages })`. `tools/lib/site-write.ts`:
   `WriteOptions.pages`, a validated `readPages`/`BadPages` like `readForms`. `tools/site.ts`: `--pages <file>`
   (VALUED, usage line, refusal when its site isn't the media map's). `tools/lib/importer-app/commands.ts`
   `siteArgs` + `routes.ts`: `--pages <folder>/pages.json` when it exists. Export `addressOf` from
   `src/ui/site-pages.ts`. The printed lines of `site:upload`/`site:import` gain one line ("Read N pages of
   <site>; wrote pages.json") only when the read ran. RED/GREEN: `test/unit/site-upload-pages.test.ts`,
   `test/unit/site-pages-flag.test.ts`. **Expect existing pins to move** where a fixture links to its own site's
   pages: tests that compare the stand-in's whole request list or the commands' whole printed text
   (`site-upload-*`, `site-import-*`, `importer-app-*` under `test/unit` and `test/web`). Run those suites on the
   base first, record the tally, and list each pin changed with its reason in the ledger; none may change for a
   fixture with no site-path link.
6. **The panel.** `src/ui/site-pages.ts` `internalLinks(payload, matches, front)` and `src/ui/run.ts` as
   `wire-plugin.cjs` (after `relink`; then `payload.sourceUrl = await siteAddress(wp)` and one note; in inline
   picture mode too: inline pictures are Divs with no media id, so naming the site moves nothing).
   `src/ui/site-read.ts` `checkLinks` returns `front` (index `_fields=page_on_front,show_on_front`, Q6) and the run
   also starts it when the paste holds an element link to `/`. RED/GREEN: `test/unit/ui-internal-links.test.ts`.
   These existing tests pin the old shape and change with a one-line reason each (names whole, one a line):
   - `test/unit/ui-site-read.test.ts` "the run frees the pictures in its upload cache (the plugin's own), only in WordPress picture mode"
   - `test/unit/ui-site-read.test.ts` "connected: the pages are read while the run goes on, the links go to them, and their notes replace the generic ones"
   - `test/unit/ui-site-read.test.ts` "with pictures going to WordPress too, the links are checked as well"
   - `test/unit/editorial-panel.test.ts` "LP6-final-panel-payload"
   - `test/unit/recognition-panel.test.ts` "recognition-panel-contract: authored footer frames match WordPress and typed URLs stay exact"
   - `test/unit/ui-payload-guard.test.ts` "the final guard runs after relinking, not just on the initial core payload"
   In `ui-site-read` the `urlsOf` helper reads an Internal link as its page's address; typed addresses stay exact;
   the guard test keeps its meaning (make its element an `image`, whose relinked address stays, or a link inside
   words).
7. **Records.** `reference/bricks/link-internal-researched.json` (the shape, marked researched) and a README
   section "An Internal link" (shape, printing, the paste rule, Image); README "Paste rules" gains the link rule.
   HANDOFF section with the rulings, known limits and paste check 3fg. The story pin (AC10), `npm run check`,
   `npm run corpus` (before task 1 and at the close).

Runner: every test and conversion under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0` through a
script (`evidence/…/run-tests.sh`, `run-site.sh`, `run-typecheck.sh` are ready), Node
`/home/justin/.local/node-v22.23.3/bin`, one heavy run at a time; exit 143/137 or "Killed" is checked against
earlyoom before it is read as a result.

## Limits, said plainly

- Linked pictures (the logo) stay Other (URL) (Q2). Links inside a sentence stay addresses in the words (Bricks'
  rich text has no page picker for a typed `<a>`).
- Posts, categories, archives: not read, stay Custom URL, named.
- A site with plain permalinks (`?page_id=`) has no page addresses to match: links stay Custom URL, named.
- Over 2,000 pages: the first 2,000 are read; the note says so.
- The paste goes on the named site only; pasted elsewhere Bricks 2.4.2 empties its Internal links (the notes say
  so). Importer pastes with library pictures already name their site.
- 2.3.9's builder (darksalmon) wasn't read; the Image limit on 2.4.2's PHP side is unproven (Q7's copies settle
  both).
- A CSS selector on `[href="/x/"]` would stop matching (none in B-Dry's pastes; the builder greps the fixtures).

## Findings outside this job

- `wholePayload` takes only the header's `sourceUrl`: if the header held no library picture and another part did,
  Copy all would paste grey placeholders today. Task 3 fixes it for both.
- The app's "Make pastes again" passes `--media` but not `--forms`: check whether a remade paste loses its WPForms
  number (not this job's).

## Files shared with other jobs (names only)

- site-fonts-import: `src/core/site/convert.ts`, `parts.ts`, `tools/site.ts`, `tools/lib/site-write.ts`,
  `tools/lib/site-upload/flow.ts`, `args.ts`, `tools/lib/site-import/after-scan.ts`, `next.ts`,
  `tools/lib/importer-app/commands.ts`, `test/fixtures/wp-standin.ts`, `reference/bricks/README.md` (its AC7
  compares two runs' requests: both now hold the page reads).
- logo-media: `src/core/site/convert.ts`, `elementor-fold.ts`, `natives.ts`, `kinds.ts` (not edited here; its
  linked Images keep Link to `/`, as its check 3fe expects).
- photo-image-all: `test/browser/render.ts`, `convert.ts`, README. bw-colours: `convert.ts`, `parts.ts`.
  site-sticky-cards (merged as Build 2026-11-16.3): `render.ts`, `parts.ts`, `convert.ts`, README.
- Paused: short-class-names (`test/fixtures/bricks-paste.ts`, `site-write.ts`, `tools/site.ts`, `wp-standin.ts`,
  README), fewer-kept-boxes (`tools/site.ts`, `render.ts`, `convert.ts`), clean-values (`site-write.ts`,
  `render.ts`, `tools/site.ts`, `wp-standin.ts`, `convert.ts`, README), link-keeps-name (`names.ts`: `internalLink`
  keeps `ariaLabel`, `title`, `rel`). tier-spacing: planning only, no plan read.

## CLAUDE.md lines for the finisher (after Q1's answer)

- One-uploader rule: besides the media routes and `GET wpforms/v1/forms`, the uploader reads `GET wp/v2/pages` and
  the index's `home`, `page_on_front`, `show_on_front` (to put a page's number in the paste); it writes
  `pages.json` beside `media.json`.
- A paste holding an Internal link names its site in `sourceUrl` and is pasted there only; both tools write one
  through `emit/link-shape.ts`; Bricks' Image has no Internal type.

## Forecast

Builder 3–5 h (tasks 5 and 6 carry the pins), one review, verifier and auditor as Mini. Confidence medium: the
moved pins in task 5 are the unknown.

## Evidence index (`~/.hermes/plans/figma-to-bricks/evidence/internal-links/planner/`)

`bricks-internal-link.txt` (the source reads, with file, line and byte references), `SHA256SUMS.txt`, `bricks-2.2/`,
`wp-6.8/`, `bricks-paste-links.cjs` + `.txt` (Bricks' own paste function run on four `sourceUrl`s), `link-shape.ts`,
`page-links.ts`, `site-page-links.test.ts`, `wire.cjs`, `wire-plugin.cjs`, `ac123-proto.log`, `ac123-base.log`,
`prototype.patch`, `wire-163.cjs`, `proto-on-16.3.txt`, `ac123-*-163.log`, `typecheck-proto-163.log`,
`proto-home-diff.txt`, `proto-home-notes.txt`, `proto-home-render.txt`, `proto-home-off.txt`,
`pages-bdry-standin.json` (made-up numbers), `typecheck-proto.log`, `ui-base*.log`, `ui-proto*.log`, the runner
scripts.
