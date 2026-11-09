# site-reviews: another company's widget pastes live (website importer)

Planner: fresh Opus 5.5 (high), 2026-11-09, Mini pipeline. Base: `main` `fd1986dcdbc8cf35f114b80be456e94279346743`
(Build 2026-11-09.3). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-reviews/planner/` (`<E>` below).
The builder copies this file to `docs/plans/2026-11-09-site-reviews.md` in its first commit (repo rule: plans live in
git) and keeps its ledger in `.superpowers/sdd/2026-11-09-site-reviews/progress.md`.

## Questions (the standing auto-go takes the ⭐ answers)

- **Q1 What a paste holds for another company's widget** (a reviews strip, a booking or a gallery widget drawn by a
  script of another host, pasted where it goes on the old site). ⭐ **A:** the widget's own code, live: one Bricks Code
  element where it showed, holding the slot's markup as the old site served it (its loader `<script>`), so it shows
  today's reviews, and its arrows, "Read more" and phone swipe work as on the site. The capture's copy of it is left
  out. B: live, plus the capture's copy kept hidden as a fallback that shows when the script doesn't run (doubles the
  widget's markup: 401 elements on B-Dry; and a visitor sees the stale copy flash while the loader starts). C: the copy
  as today (stale words, dead arrows).
- **Q2 The slot's markup.** ⭐ **A:** byte for byte as the old site served it (web-embeds ruling W2), the page
  builder's own class names and `data-*` on its wrappers included: a widget may find its place by them (an
  `elfsight-app-<id>` class is the widget's key), and they style nothing on a Bricks site. The site's styles of the
  slot itself come from the paste's own class on it (`<page>__…`), as for every element. B: strip `class`, `id`,
  `data-*` from the slot's elements (breaks widgets keyed on a class).
- **Q3 A capture that didn't take the widget's code** (every capture before this build, Justin's 2026-11-09 one
  included: it holds no loader address at all, `<E>/scan-capture.txt`). ⭐ **A:** pasted exactly as today (the copy),
  with the note saying so and "capture again with this build"; nothing guessed. B: refuse to convert.
- **Q4 Floating extras of another company** (a chat bubble) in the code method. ⭐ **A:** not this job (a follow-up):
  the code method doesn't paste floating extras yet, and B-Dry has none to paste (its reCAPTCHA badge belongs with the
  form, OneTap is a plugin). B: add them now.
- **Q5 site:check and a live widget.** ⭐ **A:** the check draws a live widget's slot at the size the capture read at
  each width (its script never runs there: the check's Chrome reaches no other host) and compares the slot's box,
  nothing inside it. B: let the check load the widget (network, other content every day: never stable).
- **Q6 A widget a WordPress plugin renders on the old site** (server-side markup from a plugin's shortcode, its script
  served from the site's own `wp-content/plugins/…`). ⭐ **A:** out of scope: it is the site's own markup, copied as
  today; a follow-up names the plugin to install on the new site (as the floating extras' "install <plugin>" note does).
  Not B-Dry's case: bdryswi.com's reviews are Trustindex's hosted loader in an Elementor HTML widget (proof below), and
  B-Dry staging has no Trustindex plugin (`<E>/staging-homev2-2026-11-09.html`: no plugin folder named, no `loader.js`,
  43 `cdn.trustindex.io` picture addresses of the pasted copy). B: build a plugin-to-shortcode table now.

## Playback

Justin pasted the importer's whole page of bdryswi.com (capture build 2026-11-09.1, paste build 2026-11-09.3,
`--elementor`) on B-Dry staging `/homev2/`. The "Customer Reviews" strip (Trustindex: cards, ‹ › arrows, "224 reviews",
"Write a review") shows only the three reviews the capture read; on bdryswi.com › brings more; on a phone it shows one
card with a swipe bar that does nothing (images/6.png, images/8.png). The paste's notes say "401 elements a script made
are copied as the capture read them (another company's widget, such as reviews: the words of the capture day; its
controls do nothing)". web-embeds (build 2026-11-03.2) was meant to make such a widget a Code element holding only its
own script. He wants: paste once, and the reviews work like the site.

## What the site does and what the paste does (proof)

- **The site serves one line where the reviews go** (`<E>/served-slot.txt`, from the saved 2026-10-29 page
  `evidence/quote-button-hover/planner/bdryswi-home.html` offset 550581): an Elementor HTML widget `f414ab0` whose
  `elementor-widget-container` holds only
  `<script defer async src='https://cdn.trustindex.io/loader.js?0ba3c27414da21862f7681d05e9'></script>`.
- **The loader replaces its own script tag with the widget.** Planner probe (`<E>/probe-trustindex.ts`, run by
  `<E>/run-probe.sh`, output `<E>/probe-trustindex.json`): that exact slot served on 127.0.0.1 (never bdryswi.com),
  the capture's own `tracker` and `embedFacts`, the real loader from `cdn.trustindex.io` (GET only). After a mouse move
  the widget filled in 3.6 s with 20 `.ti-review-item`s; the container then holds `div.ti-widget` and a `style`, both
  marked made by `https://cdn.trustindex.io/loader.js?0ba3c…`, and **no `script[src]` is left anywhere in the page**;
  `embedFacts` returned `[]`. It also shows the widget renders on an address that isn't B-Dry's (127.0.0.1).
- **The 2026-11-09 capture took it as copied elements** (`<E>/scan-capture.txt`, `<E>/made-elements.txt`):
  `web.embeds` holds only the Google map (`w904`); under the footer's `div:8` 429 of 432 code nodes are script-made
  (`~`), 20 `ti-review-item`s, 140 pictures from `cdn.trustindex.io`, `lh3.googleusercontent.com`,
  `graph.facebook.com`; the capture holds no `loader.js` address anywhere (0 mentions). Its slot climb
  (`<E>/slot-climb.txt`): `ti-widget` → `elementor-widget-container` (paints nothing) → `f414ab0` (`position:
  relative`, allowed) → stops at `e-con-inner` (`padding-block: 10px`): **the slot is `f414ab0`**,
  `body/div:0/footer:0/div:8/div:0/div:0`.
- **The paste copies them; staging shows the copy.** `paste-el3/notes.txt` line 119 (401 elements copied, footer);
  the staging page today (`<E>/staging-homev2-2026-11-09.html`, read logged out with `?f2b=`) holds no `loader.js`
  and 43 `cdn.trustindex.io` picture addresses. The staging-fit planner (shared findings) also found site:check
  counting the reviews' script-made avatars as missing at every width.
- **Bricks prints a Code element holding that loader as is**: on 2026-10-29 staging `/homev2/` held an earlier hand
  paste `<div id="brxe-ahbbsg" data-script-id="ahbbsg" class="brxe-code"><script defer async
  src='https://cdn.trustindex.io/loader.js?0ba3c…'></script></div>` (`<E>/served-slot.txt`). Sample:
  `reference/bricks/code-element.json` (`code`, `executeCode: true`); no new sample needed.

## Root cause (two, both needed)

1. **Capture:** `src/web/read/embeds.ts:135-136`
   `const holds = [...slot.querySelectorAll("script[src]")].some((s) => madeBy(s) === undefined && bare(hostOf(s.src)) === host); if (!holds) continue;`
   counts a script widget only while its parser-made `<script src>` is still in the live slot. A loader that replaces
   its own tag (Trustindex; any `currentScript.replaceWith(…)` loader) leaves none, so the widget is never an embed and
   its elements are read as ordinary script-made code nodes. Proven by the probe (`embedFacts` → `[]`, `scripts: []`).
2. **Code method:** `src/core/site/convert.ts:134-136` (prepare) never reads `web.embeds`: every script-made element in
   the tree is copied and named in the "copied as the capture read them" note. This is web-code-page's ruling Q5 A
   (`docs/plans/2026-11-04-web-code-page.md:91`, "B: the widget's own loader script in a Code element … later job";
   its "Next jobs" item 3). `grep -rn embeds src/core/site` finds nothing. So even a capture with the embed would still
   paste the copy; and with fix 1 alone the old Figma route would change but not the code method Justin uses.

## The general rule

**Another company's widget pasted where it goes on the old site pastes live.** A capture records it as an embed when
its creating script's tag was served inside its slot, whether or not that tag is still there once the script ran (the
slot's served markup is the witness). In the code method, an embed whose slot holds script-made elements and whose
snippet holds a script the browser runs becomes one Code element at the slot: its `code` the snippet byte for byte, its
`executeCode` on, the slot's own class styling the snippet's first element (the Code element is flat, `site-flat`, as
the code method's markup elements are); nothing under the slot is pasted. Everything else converts as today: served
frames (maps, a booking iframe) keep the markup route; the site's own scripts' drawings (a slider's live region, a
drawn headline mark: `<E>/made-elements.txt` page part) stay copied; captures without the embed paste the copy (Q3).
Recognised by structure (who made an element, what the server sent), never by a host, class or site.

## Acceptance criteria

- **AC1 (proposed)** A widget whose loader replaces its own `<script>` with what it draws, served inside an unpainted
  slot, is captured as one `web.embeds` entry: kind `widget`, `how: "slot"`, its layer the slot, its snippet the slot's
  served markup byte for byte (holding the loader tag), and nothing inside the slot is a layer.
  Test: `test/web/capture-live-widget.test.ts` "AC1 a self-replacing loader's widget is one embed" (new fixture site
  `live-widget`; RED on main: `web.embeds` has no entry).
- **AC2 (proposed)** No new embeds: on the same fixture, a script of the site's own host that replaces its own tag in
  a slot stays ordinary layers, and another host's script served in `<head>` that draws into a page box stays layers;
  `test/web/capture-embeds.test.ts` passes unchanged.
  Test: `test/web/capture-live-widget.test.ts` "AC2 own-host and head-loaded scripts stay layers" + the existing file.
- **AC3 (proposed)** The code method pastes such an embed live: one Code element at the slot whose `code` is the
  snippet byte for byte and `executeCode: true`, carrying the slot's own class (its rules on `> :first-child`), the
  shared `site-flat`; no element under the slot in the paste or in `sources`; the payload's `live` list names its id;
  the notes say the widget pastes live (host named) and the signing step; the "copied as the capture read them" note
  counts only script-made elements outside live widgets.
  Test: `test/unit/site-live-widget.test.ts` "AC3 an embed's slot is one live Code element" (generic hand-made page
  code, `test/fixtures/site-page-code.ts` plus a slot of script-made cards and its embed entry; RED on main).
- **AC4 (proposed)** The pasted widget works: the `live-widget` fixture captured and converted (`siteParts`, with and
  without `elementor`), drawn by the renderer with the other origin serving: the widget's cards come from the other
  origin inside the slot, a click on its › control shows a card the first view didn't, at 390 (touch) a tap on its
  next control moves to the next card; the elements before and after the slot are within 2 px of the capture at 1440
  and 390.
  Test: `test/web/site-live-widget.test.ts` "AC4 the live widget pages and swipes in the paste" (RED on main: the
  paste holds the copy and the control does nothing).
- **AC5 (proposed)** `npm run site:check` on the fixture capture is OK within 2 px at every width: a live widget's
  slot is drawn at the capture's box at each width and compared; nothing inside it is compared.
  Test: `test/web/site-check-live-widget.test.ts` "AC5 site:check stands in for a live widget" (proven by a mutant:
  without the stand-in the elements after the slot move and it FAILs).
- **AC6 (proposed)** A capture without the widget's embed (every capture before this build) pastes byte for byte as on
  main, the note saying the copy is the capture day's and to capture again with this build.
  Test: `test/unit/site-live-widget.test.ts` "AC6 no embed: the copy as before" (the AC3 fixture without its embed
  entry; payload byte-identical to the fixture on main's code).
- **AC7 (proposed)** Nothing else changes: Figma designs (`npm run corpus`, `test/unit/plugin-convert.test.ts`), the
  code method's fixtures without another company's widget (`code-page`, every `elementor-*`, `site-page-code.ts`
  pastes) and Justin's 2026-11-09 capture's three parts (`--elementor` and plain) are byte-identical to main; only the
  notes' wording of the copied-elements note may change.
  Test: `test/unit/site-live-widget.test.ts` "AC7 pastes without a live widget are unchanged" (fixtures; golden JSON
  of main's output written in Task 0) + `test/web/site-live-widget-bdry.test.ts` "AC7 B-Dry's 2026-11-09 capture is
  unchanged" (named-only `F2B_BDRY_CAPTURE`) + `npm run corpus`.
- **AC8 (proposed)** B-Dry, named-only (network to `cdn.trustindex.io` only, GET): the saved 2026-10-29 home page
  served as the code-proof stand-in on 127.0.0.1 with its one Trustindex `<script>` kept, captured with this build,
  has the reviews as one embed at `f414ab0` whose snippet holds that loader tag byte for byte; its `--elementor`
  footer paste holds one Code element there with that snippet and none of the `ti-` elements; drawn with the network
  allowed to `cdn.trustindex.io`, the widget fills the slot with more than three reviews and › shows a review that
  wasn't showing. Test: `test/web/site-live-widget-bdry.test.ts` "AC8 B-Dry's reviews paste live" (named-only:
  `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, `F2B_LIVE_WIDGET_NET=1`).
- **AC9 (proposed) (live)** Justin re-captures bdryswi.com with this build (together with staging-fit-capture's
  re-capture: one capture for both), runs `npm run site -- <capture> <out> --elementor`, pastes the whole page on B-Dry
  staging `/homev2/`, saves, runs Regenerate code signatures and LiteSpeed Purge All. Logged out (`?f2b=<random>`):
  "Customer Reviews" shows Trustindex's live widget, › brings reviews beyond the first three, "224 reviews" (or
  today's count) and "Write a review" as on bdryswi.com; on his iPhone one card shows and swiping moves to the next.
  The Bricks editor shows the Code element without the reviews (Bricks' editor runs no pasted code). Test: Justin's
  paste check (the next free HANDOFF id at the merge).

`(live)`: AC9 only. Figma designs byte-identical (AC7); the code method changes only where a capture holds another
company's widget embed whose slot a script filled (AC3/AC6).

## Design

### 1. Capture (`src/web/read/embeds.ts`, in-page)

In the "another company's boxes" loop (lines 129-139), a pick also counts when the slot's **served** counterpart holds
a `<script src>` of the creating host that the browser runs as JavaScript:
- compute the slot's path (`helpers.pathOf(slot)`) and `servedAt(path, slot)` (already defined at line 84; reuse it,
  and keep its result on the pick so the output loop doesn't parse twice);
- parse its markup with `DOMParser` and test its `script[src]` elements: host equal (`bare(hostOf(src))`), and a
  JavaScript type as web-embeds rule 2 reads it (no or empty `type`, a JavaScript MIME type in any case with
  parameters, `module`; no `type` and a `language` naming JavaScript). The function closes over nothing: write the
  type test inline (or pass `scriptTags` from `src/web/map/snippets.ts` as a helper only if it closes over nothing).
- `holds = live parser-made tag (as today) || served tag`. Nothing else changes: the slot climb, `liveOf`, the outermost
  filter, `snippetOf` (the served slot holds the loader, so `scriptsFor` answers `how: "slot"`).
The embed layer then follows (`map/tree.ts:97`: the slot's layer becomes the empty `embed` frame), so the old Figma
route also pastes it as a Code element (web-embeds' AC13 intent).

### 2. Code method (`src/core/site/`)

- New `src/core/site/live.ts`: `liveWidgets(capture, rootPath): Map<string, { snippet: string; host: string }>` (slot
  path → its code). For each `web.embeds` entry with `kind === "widget"` and a non-null snippet: its slot path is its
  layer's `web.source.path` (walk `capture.roots` for `id === nodeId`; no schema change, so J5-era captures work too);
  kept when the slot is `rootPath` or under it, `code.nodes[slot]` is shown, some shown code node under it has a `~`
  step, and `scriptTags(snippet)` (`src/web/map/snippets.ts`, pure) has a `js` tag. A served frame's embed has no `~`
  under it, so it stays on the markup route. Pure; about 50 lines.
- `prepare` (`convert.ts`): before `scan`, `const live = liveWidgets(original, rootPath)`; add every code node path
  under each slot to `skipped` (so `scan` and `buildTree` never visit them: no hidden-copy, markup or REBUILT notes
  from inside); delete each slot from `picks.choice` and `picks.pasteHidden` (the fold's choice never overrides it);
  pass `live: (path) => live.get(path)?.snippet ?? null` in the `KindContext`.
- `kinds.ts` `elementFor`: first line, `const own = ctx.live?.(path); if (own != null) return { name: "code", settings:
  { code: own, executeCode: true }, place: "inner", shared: [FLAT_SHARED], own: true };` (the same shape as the
  markup route at line 93, so `whereOf` puts the slot's class on `> :first-child`, the snippet's slot element).
- Notes (`convert.ts:134-136`): `made` counts only tree nodes outside live slots (unchanged count when there is none);
  its wording becomes "… copied as the capture read them (another company's widget a capture before build
  <BUILD of this merge> couldn't take live, or the site's own script's drawing: the words of the capture day; its
  controls do nothing; capture again with this build)"; one note per live widget: "another company's widget (<host>)
  pastes live where it showed: its own code in a Code element (today's content; it works on the live page, not in
  the Bricks editor)". `SIGN` already follows from the Code element.
- `SiteResult` / `PartResult` get `live: string[]` (the Code elements' ids); `tools/site.ts` writes them into
  `sources-<part>.json` as a sibling file `live-<part>.json` (keep `sources` unchanged in shape).
- If a slot's path isn't in the tree after the fold (a future fold merging it away), the copy route stays and a note
  names it (no crash); with today's fold an HTML widget is page code, so B-Dry's slot is kept.

### 3. site:check (`tools/site-check.ts`)

Read `live-<part>.json` (or `siteParts(...).live`). For each width, before reading, inject one style
`#brxe-<id> > :first-child { box-sizing: border-box; height: <capture box h at w>px; overflow: hidden }` per live Code
element (the slot's capture box at that width, `captureBoxes`). The slot stays in the compared items; nothing under
it is in `sources`. (The check's Chrome reaches no other host: `tools/lib/site-chrome.ts` SITE_OFFLINE.)

### Variations considered

- Loader tag left in place (badge.js style): unchanged path (live tag). Loader removed/replaced: new served path.
- Slot climbs to a painted parent: stops there as today; the Code element's first child is the slot.
- The slot itself script-made (`how: "live"`): its snippet is the live markup without the other host's elements plus
  its scripts; still a Code element.
- Two widgets of one host in two slots: one embed each (outermost slots, as today); each snippet holds only its own
  tag (rule 2 a).
- Phones: the slot's class carries its per-range rules; the widget lays itself out (Trustindex: one card + swipe).
- A capture cut to one part (`capture-part.ts`): layers kept, so `nodeId` lookup works.

## Tasks (test first; commit after each passing task; don't bump BUILD; never load bdryswi.com)

Gates per task: `npm run check`; `npm run corpus` before Task 1 and at the close; the touched `test:web` files
(Chrome: `TMPDIR` ≤ 38 chars, its own per job; close every Chrome; heavy runs under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, B-Dry 8G).

0. **Base.** Record `npm run check`, `npm run corpus`, `test:web` tallies on the base. Write the AC7 goldens: main's
   `siteParts`/`siteToBricks` JSON for `pageCode()`, the `elementor-*` unit fixtures, and (named-only, outside the
   repo) Justin's capture's three parts plain and `--elementor` (`<evidence>/builder/golden/`).
1. **Fixture (AC1, AC2, AC4).** `test/fixtures/web/sites/live-widget/index.html`: header, a section "What clients say"
   whose unpainted `div.html-block > div.holder` holds only `<script defer async src="{{OTHER}}/carousel.js?k=demo">`
   inside a padded section box; a section of the site's own `selfswap.js` (same origin, replaces its tag with a box);
   a page box filled by `{{OTHER}}/headfill.js` loaded in `<head>`; a footer after the slot.
   `test/fixtures/web/third-party/carousel.js`: finds its own tag (`document.currentScript`, else
   `script[src*="carousel.js"]`), builds `div.cw > .cw-track` of 8 cards (3 per view above 767, 1 below), ‹ › buttons
   that page by `scrollLeft` on an `overflow:hidden` track, and on touch a next button; injects its own `<style>`;
   then `me.replaceWith(widget)`. No input wait (deterministic). Generic names only.
2. **Capture (AC1, AC2).** RED tests in `test/web/capture-live-widget.test.ts`; fix `embeds.ts` as Design 1;
   `capture-embeds.test.ts` green unchanged.
3. **Code method (AC3, AC6, AC7 unit).** RED tests in `test/unit/site-live-widget.test.ts` on `pageCode()` plus a
   slot (`${MAIN}/section:3/div:0`) of `~` cards and a `web.embeds` entry whose `nodeId` names a root layer with that
   `web.source.path`; build `live.ts`, the `prepare`/`kinds.ts`/notes/`live` changes. Prove AC3's test catches the bug
   (`git checkout HEAD~1 -- src/core/site` → RED).
4. **Paste works (AC4).** `test/web/site-live-widget.test.ts`: capture the fixture (`captureFixture("live-widget")`),
   `siteParts` plain and `elementor: true`, draw with `renderSitePaste` in a page whose Chrome reaches the fixture's
   two origins (as `capture-embeds.test.ts` AC3 does), click ›, tap at 390, measure before/after boxes.
5. **site:check (AC5).** `tools/site.ts` writes `live-<part>.json`; `tools/site-check.ts` stand-in; test runs the CLI
   on the fixture capture; mutant without the stand-in FAILs.
6. **B-Dry (AC7 named, AC8).** `test/web/site-live-widget-bdry.test.ts`: AC7 against the Task 0 goldens; AC8 with
   `buildStandIn(..., { keepScriptHosts: ["cdn.trustindex.io"] })` (a new option in
   `test/web/code-proof/standin.ts`: keep a `<script>` whose `src` host is listed, drop the rest as today) and a Chrome
   whose host rules also EXCLUDE `cdn.trustindex.io`; the capture must wake the loader (a first input: if the capture's
   wakers don't, record it and move the mouse over the slot in the test before reading, as the planner's probe did).
   Evidence: shots of the slot before/after ›, at 1440 and 390, in `<evidence>/builder/ac8/`.
7. **Records.** HANDOFF section "Another company's widget pastes live (site-reviews)" with Q1–Q6 rulings (⭐, not yet
   confirmed), the proof, limits (below), the paste check id for AC9 with Justin's steps in the end-of-run list
   (re-capture, `npm run site -- … --elementor`, paste whole, Cmd+S, Regenerate code signatures, Purge All, check
   logged out at 1440 and on iPhone); ledger to `docs/plans/2026-11-09-site-reviews-ledger.md` at finish.

## Known limits (HANDOFF)

- The live widget's content and height are another company's: site:check stands in at the capture's size (Q5 A); the
  live page is the judge (AC9).
- The Bricks editor doesn't run pasted code, so the reviews show only on the live page or Preview (CLAUDE.md).
- Trustindex (or any host) may refuse an address it wasn't set up for; the probe showed this widget drawing on
  127.0.0.1, so B-Dry staging is expected to work.
- WordPress-plugin widgets (Q6) and floating third-party extras (Q4) stay follow-ups.

## Overlaps with the other five jobs

- **staging-fit-capture** (`src/web/capture.ts`, `session.ts`, `styled.ts`, `src/core/site/blocks.ts`,
  `styled-ranges.ts`, `tools/site.ts`, `tools/site-check.ts`): both change the capture and both need Justin's
  re-capture: merge both before he re-captures, one capture for AC9 and theirs. Files shared: `tools/site.ts` (I add a
  `live-<part>.json` write) and `tools/site-check.ts` (I add a per-width style): small, separate hunks; either order.
- **staging-fit-renderer** (`test/browser/render*.ts`, `tools/site-check.ts`, `tools/lib/site-chrome.ts`,
  `tools/site-live.ts`): `site-check.ts` again (rebase keeps both hunks). If it changes SITE_OFFLINE, AC5's premise
  (no other host) must hold; a `site-live` staging measure will see the live widget's height (expected to differ).
- **site-native-structure** (element types in `kinds.ts`/`tree.ts`/`convert.ts`): the live widget is a Bricks **Code**
  element either way (Bricks has no native element for another company's widget). If native-structure adds fields to
  `KindContext` or reorders `elementFor`, the `ctx.live` check must stay its **first** line, before any native choice;
  if it moves the markup route's Code shape (`place`, `shared`), the live Code element takes the same shape. Merge
  either order; the later one resolves `kinds.ts`.
- **site-slider** (`widgets.ts` loop copies, Elementor n-carousel → Bricks Slider, maybe `convert.ts` notes): the
  slider's own script-made copies (`swiper-slide-duplicate`, `swiper-notification`) are the site's own scripts, never
  an embed: they stay in that job. Shared hunk: the copied-elements note at `convert.ts:134-136` (both may touch it);
  keep both meanings.
- **site-faq** (`elementor-accordion.ts`): no overlap.
- **site-menu** (popups capture, Offcanvas): no shared file expected; if it adds popups to the capture in
  `capture.ts`, no conflict with `embeds.ts`.

## Bricks samples

None needed: `reference/bricks/code-element.json` (Code with `code` and `executeCode`) is the shape, and staging
printed exactly such a Code element with this loader on 2026-10-29.
