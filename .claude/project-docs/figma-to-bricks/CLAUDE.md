# Figma to Bricks v2: instructions for every agent

**Status and what's next:** `docs/HANDOFF.md` (milestones, how work is done, what the user must provide).

## Start here: handoff of 2026-10-19 (the previous chat was cleared; read this first)

**Current build `2026-10-28.1`.** Builds 21.13–22.9 were recorded only in `docs/HANDOFF.md` (their agents
couldn't write this file; their queued edits are in `~/.hermes/plans/figma-to-bricks/*-claude-md-pending.md`).
- **Flip cards (28.1, flip-cards):**
  - **Justin's ask** (bdryswi.com's home page, "Our Services"): six photo cards in a 3-column grid that turn over like
    a playing card under the mouse, showing a back with the title, a sentence and a button to the service's page; a
    general plugin feature for any Figma file. Figma has no flip animation, so the designer marks the card.
  - **In Figma (Q1A):** the card is a component with two variants, front and back; the front has While hovering (or
    Mouse enter) → Change to the back; a Figma **annotation** `flip` sits on the component set, the main component or
    one instance (Dev Mode → Annotate). `flip left` / `up` / `down` choose the way (`flip` alone turns right); the
    Change to's time and easing are the turn's (Instant: 0.6s ease-in-out). **Without the mark nothing changes.** A
    mark that can't flip (no hover Change to; a Button, text, picture or section; a form on a face; an instance holding
    a layer its main doesn't) is one panel note and converts as unmarked. No extract or debug-file change.
  - **What the paste holds** (`understand/flip.ts`, `style/flip.ts`, `style/classes.ts` `flipClass`): the card
    (`flip-card`, the instance's Div or Block: its size and place only, a one-cell grid) holding a "Front"
    (`flip-front`: the instance's layers, paint and padding) and a live "Back" (`flip-back`: the hover variant, paired
    as hover layers pair it, its Button keeping its link). One class holds the turn (`perspective: 1000px`, `backface-visibility:
    hidden`). The card is as tall as its taller face on every screen, as wide as unmarked, and never grows on hover.
  - **How it behaves:** the mouse turns it; Tab onto a link on the back turns it (a card whose back holds no link takes
    the focus itself, `tabindex="0"`); phones (Q2A, CSS only): a tap turns it without opening the link, the next tap
    opens it, a tap elsewhere turns it back; less motion (Q4A): the faces swap after 50ms without turning; the back
    takes the pointer 50ms after the turn (`transition-behavior: allow-discrete`), so a tap's own click never lands on
    its link; a card that is a link (Q3A) puts the link on its back; each card's back words as drawn (Q5A).
  - **Phones and tablets:** laid out as the same card unmarked (`ir.ts` `faceOf`: recognise and the layout plan judge
    a flip card by its front); a photo card's phone slider holds copies that flip too. Never a product card, a hover
    layer or a CTA (its back's Buttons are CTAs); unmarked photo cards beside it keep their zoom.
  - **Nested links** (review 2, F1): a link inside another is a test-only invariant (`emit-nested-links`, every
    fixture and corpus page), not a paste refusal: review 1's refusal broke pastes main made. A list's PDF wins over a
    link around its row, card or footer (one note per address); the hero's phone band copy finds links at every depth.
  - **The ⭐ answers Q1A–Q5A**, taken under Justin's auto-go (not yet confirmed).
  - **Rulings, not yet confirmed:**
    - planner R1–R10: drawn heights are minimums; perspective 1000px, right unless named; Instant → 0.6s ease-in-out;
      Tab focuses the card only when its back has nothing to tab to; "Front" / "Back" labels; no zoom or fade-in on
      the card; one note per component, one per mark that can't flip; the back's title takes its front twin's level;
      the back's words aren't searched for numbers or page names; up/down turns clip sideways;
    - builder: the card takes the focus when its back holds no link, even with an unlinked Button (Bricks renders it a
      `span`); the turned look reads `:has(> .flip-back:focus-within)`;
    - fixer 1: a card inside a link takes no `tabindex`; a back drawn wider than its card wraps its words from the
      design width; the 50ms swap counts as "at once"; a pill-shaped flip card is no CTA;
    - fixer 2: a nested link never refuses the paste; a list's PDF wins over a link around it; the back's pointer waits
      50ms in both motion modes (at once where `transition-behavior` is missing, Safari before 17.4); the layout plan
      reads a flip card by its front everywhere, its back adds nothing.
  - **Review:** two fresh opus reviews, all findings fixed test-first: review 1 F1–F7 (less motion's first tap opened
    the link; a hugging card widened by its back; a nested link; CTA marks; mutants; element type; a short instance),
    review 2 F1–F6 (high: the nested-link guard refused main's own pastes; high: the layout plan gave a flip card no
    room, so its row never stacked; the site check lost its links; Safari's pointer; test gaps; a linked card's front).
  - **Checks:** check 2351 + 6, 0 fail (60 corpus skips on the WSL desktop: Mac paths); browser 373: 360 pass, the same
    12 font failures and 1 Mac-only skip as main; corpus-backed tests in `git archive` trees 0 fail; hydraulics, GRO,
    debug-page-1, brainstorm and Services replays byte-identical (none has an annotation). AC1–AC12 proven by the
    verifier and the blind auditor; AC13 is the live paste. Owed on a Mac: v1's three files' corpus tests and replays.
  - **Paste check 3bn owed** (HANDOFF steps, one action at a time): make a card a component with a back variant,
    While hovering → Change to, annotate `flip`, convert, paste, LiteSpeed Purge All (no code: no signatures); point,
    click, Tab; on the iPhone tap where the button will be (turns, opens nothing), again (opens), elsewhere (turns
    back), then the same with Reduce Motion; save a debug file of the page.
  - **Limits** (HANDOFF "Limits"): Safari may show a turned-away face's composited children (a `will-change` picture, a
    video, a CTA's fade-in) through `backface-visibility` (a fix hides the back from screen readers: a question for
    Justin after 3bn); Chrome never hit-tests a turned-away face, so the faces' `pointer-events: none` is pinned by the
    CSS test only; a divided row of flip cards keeps its lines on phones; the near edge grows mid-turn (a clipping
    parent cuts it); the Bricks editor shows the back only under the pointer; Figma text properties aren't read; every
    card carries its back. Not in scope: a flip on click, push/slide/zoom flips. The bdry paste comes next.
- **Space under an open FAQ answer (26.1, faq-answer-space):**
  - **Justin's ask** (screenshot of the live Home page): "Can we add more space under the FAQ when it's open? Under
    the answer." The open answer's last line sat right on the divider above the next question.
  - **The cause:** Home's answer is a website import: a box without auto layout fixed at 105px, its words (80px) at
    its top, so Figma shows about 25px under them. The plugin wrote that height as a min height (`style/sizing.ts`),
    which fills up once the words wrap more (0 at 1024 on main) and is set to 0 from 991px down (`size.unpin`).
    Repairs is drawn the same way (79px boxes, 26px under the words).
  - **What it does now** (`understand/accordion.ts` `spaceUnder`, `underAnswers`): an answer box Figma draws at a
    fixed height with its words at its top hugs its words, and the space drawn under them becomes the item Content's
    bottom padding, the same on every screen. Closed items' placeholder answers get the open answer's space. A box
    that paints something of its own (a fill, an outline on any side, a shadow, a frosted backdrop) or holds a placed
    layer keeps today's min height, as do a box centring its words, a wrapping grid and a column whose last layer is
    pushed to the bottom.
  - **The ⭐ answers 1A 2A 3A**, taken under Justin's auto-go (not yet confirmed): placeholders get the drawn open
    answer's space, not its min height; only a box whose layers sit at its top counts; whole pixels, under 1px none.
  - **Review:** fresh opus, approve with fixes; F1 (medium: a painted or outlined box's space moved outside its
    paint), F2 (low: a badge pinned to the box's bottom rode up onto the words), F3 (low: no test for the box's own
    padding or a row's offset), all fixed test-first.
  - **Checks:** check 2314 + 6, 0 fail (55 + 5 corpus tests skip on the WSL desktop: Mac paths in `corpus.json`);
    browser suite equal to main's by name (366: 353 pass, the same 12 failures and 1 Mac-only skip as main, this
    machine's Chrome and fonts). AC1–AC6 proven by the verifier and the blind auditor; AC7 is the live paste.
  - **Pastes:** Home's 5 answers lose `_heightMin` 105 (and its tablet 0) and their Content blocks get bottom padding
    25px; Repairs the same with 79 / 26px. GRO, brainstorm and Services byte-identical; lint identical at 390–1728.
  - **My rulings, not yet confirmed:** a row counts by lining its layers up at its top, a column's nudges are part of
    the answer; a painted, outlined, shadowed or placed-layer answer box keeps its min height (exact at the design
    width, its space gone from 991px down, as on main).
  - **Paste check 3bl owed:** copy the 4 answers Justin typed in Bricks for Home's closed FAQ items first (they come
    back as placeholders), then empty Home and re-paste "Home Page Final" (folds into 3bj), and re-paste "Hydraulic
    Cylinder Repairs Final"; type the answers back, Regenerate code signatures, LiteSpeed Purge All.
  - **Follow-ups** (HANDOFF "Not changed"): a badge pinned to the bottom of a fixed-height box lands on its words on
    phones (on main too: `size.unpin` drops the min height from 991px down); the same frozen space exists outside
    FAQs.
- **A captured map with no words, and a map edge to edge (23.3, wordless-maps):**
  - **Justin's ask:** "for the contact page please make it so that the map is embedded and the user can scroll on
    it." The live Contact page's map was a flat picture: its capture kept Google's tiles and controls as pictures,
    no words, and the address sat in the next section.
  - **What it does now:**
    - **Recognition** (`normalise/maps.ts` `controlled`, `cornerOf`): a mosaic is a map when its own controls sit in
      two corners of its tiles or more. A control is painted, never words, more than 2px, at most half the tiles each
      way, near one side and one end only (within 32px).
    - **Address:** `nearestAddress` searches up to the whole page, so the map's own section still wins.
    - **Edge to edge** (`understand/section.ts` `mapAcross`, `aroundMap`, `mapPart`): a map across its section goes
      straight in the section; one across a painted band goes in the band; one inside a single unlinked wrapper
      makes that wrapper a band.
  - **Justin chose "Edge to edge"**, which answers "Should a full-width map leave the 1440 Container?". Scroll: the
    keyless embed is unchanged, so the wheel zooms only with Ctrl/⌘; plain wheel zoom needs an API key.
  - **Review:** fresh opus, approve with fixes; F1 (high: the space above a map in a free section was lost) to F6,
    all fixed test-first.
  - **Checks:** check 2297 + 6, browser 362/362; corpus pastes byte-identical.
  - **Paste check 3bk owed:** re-paste Contact with the header tick on (its spacer is gone on the live page).
  - **Also found:** Home's "Home Page Final" frame itself holds a whole Services page (not two pastes stacked). Waiting
    on Justin's Layers screenshot.
- **The header tick follows the site (23.2, site-ticks):**
  - **Justin's report:** with "My site already has its header" ticked, a second header still showed on phones and
    tablets, and Home was "all over the place".
  - **What the live site showed** (read past LiteSpeed with `?f2b=<random>`): 7 pages were right. Home and
    Hydraulic Cylinder Repairs Final were pasted from a Convert with the tick off: no `section.site-header-room`,
    the Figma header kept. At 1440 it hid behind the taller fixed site header; narrower, it grew and showed. Home
    also holds a whole Services page in its second section: the "Home Page Final" frame itself holds it (a fresh paste
    into an emptied page kept it), not an older paste.
  - **The cause:** the core's leaving-out works when ticked. The tick lives per Figma file, and nothing said a paste
    still held a header.
  - **What it does now:**
    - every Convert says where the header and footer went: `DesignLeft.shown`, `includedNote`, `partsFate` →
      `ResultData.parts`, and one line under the ticks (`ui/site.ts` `partsText`, red when the paste may double the
      site's);
    - the panel remembers the ticks by WordPress site (`Stored.siteParts`). A file that never saved ticks
      (`init.siteKept`) takes the connected site's and saves them into the file;
    - the ticks box now lives in `ui/site-box.ts`.
  - **Pastes are byte-identical** for the same ticks.
  - **Review:** fresh opus, approve with fixes. F1 (the footer ticked alone with an unticked header changed the
    paste) and F2 (a stale red line) were fixed test-first. Check 2277 + 6, browser 360/360.
  - **Justin's next step:** HANDOFF "The header tick follows your site"; paste check **3bj** owed: empty Home and
    re-paste "Home Page Final", re-paste Repairs, both with the ticks on.
- **Web addresses read without the URL class (23.1, sandbox-urls):** Justin's Services "Download Full Inventory
  (PDF)" button opened the PDF in the same tab, even from a fresh 22.10 paste. Figma's plugin sandbox has no `URL`
  (only built-ins, `figma`, `console`, timers and `fetch`). Four `new URL` checks inside `try` always said no in
  Figma, though every Node test passed. So PDF links never got their new tab or `download` (21.18 and 22.7), picture
  links were never dropped (20.14), CSV document columns never linked (21.16) and map links never named their place
  (20.10). Now `src/core/model/url.ts` (`parseAddress`, `queryValues`) reads addresses without it.
  - Guards: `test/unit/sandbox-convert.test.ts` runs the bundled core in a `node:vm` context like Figma's (fixtures
    plus all corpus pages must equal Node); `test/unit/model-url.test.ts` compares the reader with URL;
    `npm run typecheck` checks Figma-run code against `tsconfig.sandbox.json`.
  - Fresh opus review: approve; its two reader fixes were made test-first. Corpus pastes are byte-identical. Check
    2262 + 6, browser 352/352.
  - A first diagnosis blamed a stale Figma panel; that was wrong.
  - Follow-up: `localeCompare` may sort fonts differently under Figma's SES.
  - HANDOFF "Web addresses read without the URL class"; paste check **3be** owed again.
- **A picture frame's faint outline over a photo (22.10, photo-frame-outline):** Justin's Repairs hero showed "a
  subtle white border outline" around the cylinder's box. It is in the design (`div.prod`: 1px white stroke at 10%,
  radial glow), drawn on the truck photo. **Justin chose "Only over a photo":** `normalise/photo-frames.ts`
  `leaveFaintFrames` (after `build()`, before `inferLayouts`, in Figma's paint order) drops the stroke of a
  see-through box (fills ≤ 20%, no background blur) outlined by a faint hairline on every side (≤ 20%, ≤ 2px), holding
  a photo-sized picture (≥ 80px, no words), on a photo (the topmost layer covering ≥ 90% is a photo or video; no
  opaque layer over more than 10% of the box), with no hover. Paste = as if deleted in Figma; one note. Boxes on plain
  colours keep theirs. Fresh opus review F1–F7 fixed test first (dividers, icon rings, partial panels, videos waiting
  for their address); 36/36 mutants killed. Check 2246 + 6, browser 352/352; corpus pastes/HTML byte-identical (same
  18 items as main). Repairs: only "Prod" changes. HANDOFF "A picture frame's faint outline over a photo"; paste check
  **3bh** owed.
- **Checks (as of 21.12):** `npm run check` 1479/1479 unit/rule plus 6/6 serial performance; browser (`npm run test:browser`)
  154/154, no skips/failures. The three stale panel upload-name expectations are fixed; all newer B2 tests remain.
  Five .11/main versus .12 pastes and full HTML byte-identical; full findings/heights/fonts equal at 29 widths.
  Separately labelled matched-policy recapture gives exactly equal complete reports, same 17 existing v1
  differences. Legacy moving-animation scores remain non-comparable; budgets/tolerances unchanged.
- **Test cleanup (21.12, test-cleanup):** the three stale upload-name panel tests are green; list/marquee/map
  guards have independent mutation tests; picture/shape styling is split out without changing pastes. Snap pairs
  wrapped sections top-to-bottom with corpus fonts. Tool captures use finite-end/infinite-zero; interactive tests
  remain live. WordPress Font Library stand-ins are source-backed; timing gates are serial, not relaxed. Fresh
  review passed; integrated check 1479 unit/rule + 6 performance, browser 154/154, no skips, all B2 tests retained.
  Five pastes/HTML unchanged from .11; complete matched-font/motion reports equal at 29 widths, same 17 existing
  v1 differences. F7/F9/fontStatus remain open. HANDOFF "Test cleanup"; **no paste check or user action owed**.
- **Text breaks (21.10, text-breaks):** phone numbers move together when they fit; an impossibly narrow box may wrap
  digits without overflow or a lone closing period. Proven fixed-width flowing prose reflows through an isolated
  sentence-ending wrap; sentence-a-line items and addresses retain their deliberate separators. Fresh review F1/F2
  fixed test-first. Services review 10 → 8 lines at 390; same five at 1728. Check 1446; browser 142/145 with only the
  three pre-existing panel failures; matched corpus no worse, same 17 known v1 comparison items. HANDOFF "Text breaks";
  paste check **3ak** owed.
- **Google partial fonts (21.9, google-partial-fonts):** a successful Google answer confirms only faces covered by
  its returned family/weight/slant descriptors. Omitted weights say missing unless usable exact site coverage wins;
  accepted CSS, Figma requests and request counts stay unchanged. Fresh review passed; check 1430; browser 137/140
  (the same three stale tests); five corpus pastes/HTML and full per-width lint/heights/fonts identical to main .8.
  Conversion/panel check **3aj**; **paste check: none owed**. Double loading and the header-template setting remain
  separate. HANDOFF "Google partial fonts".
- **CTA label wrap (21.8, cta-label-wrap):** a button's words stay on one line as Figma draws them: the layout plan
  keeps items side by side only while each holds its buttons (alike cards stack rather than squeeze a pill), a kept
  row gives a button its one-line width where CSS holds it, `white-space: nowrap` on its words. Hydraulics Info
  cards' "Call Us Now" one line at 768–480. Laptop pills (design at 1200) still wrap: pill-clip batch. Paste check
  **3ai** owed. HANDOFF "Button words that wrapped in narrow cards".
- **Equal card fixes (21.7, equal-card-fixes):** the recheck of 20.15's equal cards. A card's frozen bottom space is
  trimmed only where the freed space falls under its words: row cards centred or at the bottom, wrapping row cards and
  cards a min height holds open keep their drawn bottom (and their centring), so nothing moves at the design width; a
  small photo in a stretched card stays square on tablets (flex-grow 0 once stacked). Justin's pages byte-identical:
  no paste check owed. check 1376; HANDOFF "Equal card fixes (recheck R1–R7)".
- **Fonts cleanup, stage 1 (21.6, fonts-cleanup):** a usable same-family/slant variable face already on the site
  covers a dropped static weight in its range, so it says "Already on your site" without another upload. A known
  missing face's note names the weights this paste actually supplies, or says no replacement is confirmed; it never
  picks a replacement or promises the physical font. Fresh pastes already keep Figma's text weights through their
  typography classes; regression tests now hold that against a body weight of 800. The header template still needs
  its own 600 by hand (3af). Item 1 (fonts loaded twice) deferred: needs a live paste proof; F1 (an HTTP-200 Google
  answer missing a weight counted as complete) still open. check 1358 at its merge; HANDOFF "Fonts cleanup, stage 1";
  paste check 3ah owed.
- **Words linked to another frame (21.5, frame-text-links):** words a designer links to another frame in Figma (Cmd+K
  → a frame's link) link to that frame's page, a part of a frame to its frame's page, and with WordPress connected
  the panel sends them to the site's page named like it (or takes them off where only a picture is at the address);
  a deleted frame's words stay plain, named. Behaviour change for Justin to confirm: such words, like typed-address
  ones, keep their card from becoming a whole-card link and a pill from being a Button. check 1330; HANDOFF "Words
  linked to another frame"; paste check 3ag owed.
- **Phone side padding (21.4, phone-side-padding):** upright phones get a box's own (space.ramp) side padding back in
  writing after a sideways phone's squeeze (Justin's P1A; P2B: a tablet's squeeze still carries on to sideways
  phones). A row split by its items' own one-sided outlines (stats with a line between each) evens out once it
  breaks: the lines go, sides even to the row's smallest, the space they made becomes the gap, a wrapping row's items
  share each line (`adapt/divided.ts`). check 1309; HANDOFF "Phone side padding"; paste check 3ae owed.
- **Font weights (21.3, font-weight-gaps):** the user: the header's "SCHEDULE NOW" shows in Times; Saira Condensed
  Thin / ExtraLight went up as 250 / 275.
  - **The cause:** the paste's site `@font-face` lines wrote a variable face as `font-weight: 100 900`; Bricks copies
    every weight beside a Google font into its one Google Fonts link, and Google answers a link holding a range with
    400, so every Google font Bricks loads on the page (header, footer, Theme Style) was lost. `sfnt.ts` took a
    file's OS/2 250 / 275 as they are.
  - **What it does (panel only, `src/core` untouched, corpus pastes byte-identical):** a variable face gets one
    single-weight rule per design weight; weights uploaded or read from the site are whole hundreds (an in-between
    weight takes its style name's, else the nearest hundred, a tie toward 400; a site face stored so with no weight
    word in its file name is left out, and Google fills it).
  - Self-reviewed by the finisher (8 mutations, two tests added). Re-paste the 8 pages (covers 21.1 too) after the
    header button's weight is set to 600 in Bricks. HANDOFF "Weight ranges broke Bricks' Google Fonts link"; paste
    check 3af owed.
- **Line breaks that only copy Figma's wrap (21.2, early-line-breaks):**
  - **The user:** in the hydraulics homepage's Info cards the words broke too early at full width ("…hurry? Give" /
    "us a call…", "Copco in" alone).
  - **The cause:** a website import left a typed `\n` where each line wrapped. It went out as `<br>`, hidden only
    below the design width (1728), but at 1728 the card is 363px in the 1440 Container (Figma 432), so the browser
    wrapped early and the `<br>` added a short line.
  - **The user chose (L1A L2A):** in a fixed-width text box such breaks become spaces, so the words wrap by the box on
    every screen; a text hugging its words keeps today's rule.
  - **What it does** (`style/rag.ts`): soft only for prose (`.!?` somewhere) whose breaks copy Figma's wrap, counted
    in letters (≤ 1 to spare on the longest line, which Figma's ink measures; ≤ a tenth of the guessed letters on a
    shorter line). Addresses, hours, headings and a designer's own break keep their `<br>`.
  - Reviewed on opus and fixed (letter count and prose only: my rulings under Justin's auto-go; leading spaces; FAQ
    placeholders). Corpus lint unchanged, hydraulics 0.5211 → 0.6039; design/final-design/GRO pastes byte-identical.
    HANDOFF "Line breaks that only copy Figma's wrap"; paste check 3ad owed (after 3ac's re-paste).
- **Site fonts kept per family (21.1, emergency-cta-width):**
  - **The user:** on the pasted hydraulics homepage the outlined "Emergency Call 24/7" pill looks too long and loose
    next to Figma, on a computer (phones are full width by his CTA rule, unchanged).
  - **The cause:** the pill is Figma's width, but its words were drawn in **Saira Condensed** (142px against 196).
    WordPress answers `font-families/<id>/font-faces` with every face on the site, so the paste's `@font-face` lines
    (fonts, 20.11) listed the same 13 site files under Archivo, Saira and Saira Condensed, and the last one won.
  - **The user chose (E1A desktop only, E2A, E3A):** fix the fonts; buttons keep Figma's width; he converts and
    pastes the 8 affected pages again (Home, Hydraulic Cylinder Repairs Final, Remanufactured, Contact, Core
    Exchanges, Rods, Services, About; Gallery is clean). A Convert alone repairs nothing on those pages.
  - **What it does:** `src/ui/site-fonts.ts` keeps a family's faces by their `parent` (by their own font family name
    when the answer has none) and reads the list 100 at a time. The panel's "on your site" rows and "Already on your
    site" are right again. `src/core` untouched, corpus pastes byte-identical.
  - Self-reviewed (no separate reviewer, to save plan usage): checked against WordPress trunk and 7 mutations; one
    test added. HANDOFF "Fonts from the site's library mixed between families"; paste check 3ac owed.
- **Cards drawn the same height (20.15, equal-card-heights):**
  - **The user:** the hydraulics homepage's three cards under the logo marquee line up in Figma; in Bricks "the
    first slot does not match up properly and is a bit shorter in length".
  - **The cause:** the row went out as Align items: start and each Hug card shrank to its own words (v2 stretched a
    row only when every item is Fill height). The cards looked equal in Figma only because a website import froze the
    site's stretch into their bottom paddings (30 / 39 / 63), which evens them at Figma's width alone.
  - **The user chose (1A 2A 3B 4A):** rows whose boxes Figma draws the same height stay one height; a stretched
    card's words stay at its top; the frozen extra bottom space goes (alike boxes share the smallest bottom padding),
    in the footer's link columns too.
  - **Also:** a grid's lines are found by overlap, so on the Repairs page the words beside the product photo sit in
    its middle again, as drawn.
  - Reviewed on opus and fixed (the layout plan counts a card's outline; a round box never stretches, in place of a
    96px cap; tests for each guard). HANDOFF "Cards drawn the same height in a row"; paste check 3ab owed.
- **Links that opened a picture (20.14, link-hrefs):**
  - **The user:** the bottom-left service card "downloaded a photo and didn't take me to the page … make it so that
    the plugin first does not take hyperlink as photos … and … accurate with hyperlinks".
  - **The cause** (live site read over HTTP): on the Hydraulic, Remanufactured and Core Exchanges pages the Rods card
    links to `/rods-1-15-rechroming-rods/`, the address WordPress lent media 647 (the Rods page's hero PNG, uploaded
    after those pages were pasted). Since WP 6.4 an unattached upload's `/<name>/` redirects to its file. Every card's
    link was on its own card.
  - **The user chose (1A–5A):** uploads always end in `-image` / `-video`; a link to a page not made yet keeps its
    address; the plugin moves **its own** pictures (ids in the upload cache) off a link's address; a Figma link typed
    to a picture or video file is dropped and named; text links to frames came in 21.5 (frame-text-links).
  - **What it does:** every Convert with WordPress connected reads the media on every link's address and sends `POST
    wp/v2/media/<id> {slug: "<slug>-image"}` for the plugin's own. That repairs the pages already pasted, with no
    re-paste: WordPress then forwards the old address to the page named like it.
  - Reviewed on opus and fixed (a picture attached to a page never counts, a video named a video, one change per
    media item at a time). Corpus pastes byte-identical. HANDOFF "Links that opened a picture, and links kept
    right"; paste check 3aa owed.
- **Header and footer the site already has (20.13, site-parts):**
  - **The user:** "I already have the footer and the header … When I delete the footer and the header that I
    copy-pasted, the page gets hidden"; then "it is just at the top".
  - **The cause:** their Bricks header template's section is `position: fixed` (Bricks' own Sticky header is fixed
    too), so it takes no room and the page slid under it.
  - **The user chose:** two ticks in the panel, "My site already has its header / footer", remembered in the Figma
    file (`f2b-site`), and "Measure my header".
  - **What it does:** the header (a bar at the top with a logo and a menu) and the footer (a © line with columns of
    links) are left out of the paste. With the header ticked, the paste starts with a spacer whose script measures the
    site's header on every screen.
  - **After the paste:** Regenerate code signatures, then LiteSpeed Purge All.
  - Reviewed on opus and fixed (false-positive bands, a table above a © bar, the phone footer, a header fading in, a
    header shrinking on scroll). HANDOFF "Header and footer the site already has"; paste check 3z owed.
- **Corpus: 17 results worse than v1** (18 until 20.15 evened final-design's tiles at 768), from Bricks' cap of every
  element at its parent's width, which the renderer copies since .9 (live-site looks, not regressions; HANDOFF "Bricks
  caps every element at its parent's width"). Its word-wrapping kinds are fixed since .12. The rest are layers wider
  than their box (map pin, phone columns, design's banner row) and the overlaps .12 uncovered.
- **One-line words (20.12, one-line):** the user's Services tags "SEALS & PACKING" / "UP TO 10,000 PSI" sat on two
  lines in Bricks. The user: "If you notice that it goes to a new line for some reason when it should be all on a
  single line".
  - **The cause:** a letter-spaced text's `margin-right: -<spacing>em` (`style/tracking.ts`) plus Bricks'
    `max-width:100%` in a box hugging it.
  - **The fix:** every width taken from Figma's box grows by the trailing spacing (`calc(100% + <em>)` caps and
    shares, floors). A Scale-constrained text drawn past its box keeps that share, and an auto-width one takes its
    words' room plus 3%. `size.unpin` brings the share inside where the box changes width.
  - **New tool:** `npm run wraps -- <debug.json> [widths]` lists one-line Figma texts that wrap on the page.
  - **Results:** on the user's files, the texts wrapping at the design width went Services 7 → 0, Repairs 4 → 1,
    hydraulics 6 → 0.
  - **Other causes, not changed:** content squeezed narrower than drawn, a text a hair past a fixed box below the
    design width, turned labels.
  - Reviewed on opus and fixed. Paste check 3y owed (HANDOFF "One-line words that wrapped in Bricks").
- **Fonts dropped on the panel (20.11, fonts):** the user: "I have the UI designer send me all of the fonts … all the
  fonts will be put on WordPress automatically like a drag them". The user chose **WordPress's own Font Library**
  over Bricks Custom Fonts + a helper plugin. Bricks makes Custom Fonts only through admin-ajax in its builder, and its
  post type isn't in REST.
  - **What it does:** files, a folder or a .zip dropped anywhere on the plugin (or "Choose font files" in the new
    Fonts box) go to `wp/v2/font-families` + `font-faces`. Every paste then carries `@font-face` rules for the
    design's families, after Google's, so the site's copy wins.
  - **Needs an Administrator's** Application Password (`edit_theme_options`).
  - TTF/OTF go up as WOFF. WOFF2's names come from a sibling file or the file name (Chrome has no Brotli).
  - `src/core` is untouched: the corpus pastes are byte-identical.
  - Reviewed on opus and fixed: same-named files in folders, names in other scripts, a firewall's 403.
  - Not yet tried by the user (HANDOFF "Fonts dropped on the panel", check 3x); whether Figma desktop passes a
    Finder drop into the panel is unverified.
- **Live maps (20.10, maps):** the user: "the google maps … you can like click it and move it while being on the page
  and the open in maps on the top left hyperlink works". A map captured from a web page (tiles + Google's own words)
  pastes as Google's live embed of its address in a Code element: it drags, zooms, and its "Open in Maps" opens Google
  Maps. Verified in Chrome against Google. After the paste: **Regenerate code signatures**, then LiteSpeed Purge All
  (HANDOFF "Live maps", check 3w). Reviewed on opus and fixed.
- **Marquee loop (20.9):** the user's live marquee "stutters and then restarts". Bricks' `[class*=brxe-]{max-width:
  100%}` capped the moving row at the window's width, so each loop moved a sixth of it, not one round. The
  `marquee-track`/`marquee-round` classes write `max-width: none`; verified on the live page at 390/1440/1920. The
  user must **Accept** both classes in Bricks' "Import classes" dialog on the next paste (HANDOFF check 3v).
The details of every item below are in `docs/HANDOFF.md` (search its heading) and in the ledgers in `docs/plans/`.

**What was built on 2026-10-16 → 19 (all in "Where things stand" below):**
- **Builds .1–.6 of 2026-10-16:** buttons, FAQ, maps, contact cards, contact form on phones, map heights.
- **Real forms (16.7):** with the 19.1 label fix.
- **WPForms snippet:** done by hand for the user.
- **Photos on wider screens (19.2 → 19.3):** a photo keeps its drawn size and fades at its edges.
- **Searchable lists (19.4 → 19.6):**
  - search, pills and count;
  - CSV in the panel;
  - deep, website-imported tables;
  - boxes that scroll down;
  - no empty space after filtering.
- **Call and email links (19.7):** "Call" buttons dial the page's number; every number and email shown is a link.
- **CTA buttons (19.8):** no Figma hover; every CTA lifts 3px on hover and fades in on load (the user's Bricks
  sample).
- **Product and team cards (19.9 → 19.10):** their photo zooms and glares on hover, the card fades in (the user's Staff
  card). 19.10 fixed the opus review's findings (CTA wrappers and recognition, panels, nested hovers, pictures drawn
  once); the user kept "any row of photo cards". 19.11: rows listing services or products (zigzag photo/text rows)
  zoom and glare their media under the pointer.
- **No "Import classes" dialog on later pastes (19.12, feature-2):** an empty class is written as Bricks keeps one
  (`settings: []`); Bricks compared `{}` with the site's `[]` (HANDOFF "Bricks asked about the list classes").
- **Listing media with the number above the photo (19.13, Media):** Services rows 004 and 005 had no zoom, because
  their "00N" number sat above the photo, not over it. One short flowing line in a photo box is now a label
  (HANDOFF "Listing media with the number above the photo").
- **Logo marquees (19.14, marquee):** a row of logos or short words running past the box that clips it moves toward
  the right at 60px a second, in one line on every screen (HANDOFF "Logo marquee"; plan and ledger
  `docs/plans/2026-10-19-marquee*`). Reviewed on opus and fixed. Paste check 3o owed.
- **Lists and tables on tablets and phones (19.15, fix-mobile-layout):** one line per record below the design width,
  each title over its column; a compact card per record on phones; the pills under the search from the left (HANDOFF
  "Lists and tables on tablets and phones"; ledger `docs/plans/2026-10-19-mobile-layout-ledger.md`). Reviewed on opus
  and fixed. Paste check 3p owed.
- **Hero video (19.16, fixvideo):** a Figma video fill (or v1's "video"-named picture) with an address in its name or
  an Open link becomes Bricks' Video, playing by itself (muted, looping, covering its box on every screen) where it is
  a background behind words. HANDOFF "Hero video".
- **Videos found in the WordPress Media library (20.2, fixvideo):** Figma never gives a plugin the video file, so with
  pictures going to WordPress the panel finds a video without an address on the site by its exact name. It saves the
  address in the file (`f2b-videos`) and converts the same frames again by itself; saved addresses are re-checked
  every run. The user's hero needs no rename: their Media has the same file (id 76, SHA-1 = Figma's `videoHash`). The
  site sends no CORS header on uploads, so matching is by name, not fingerprint (HANDOFF "Videos found in the
  WordPress Media library"). Reviewed on opus and fixed. Paste check 3q owed.
- **Choose a video file in the panel (20.5, video-upload):** each video the site doesn't have gets a row in the panel's
  Videos box with "Choose video file". The panel uploads the file to the Media library (its own name, web formats
  only, a 10-minute limit). It saves the address in the file and converts the same frames again. A video too big for
  the host says so with its size and where to raise PHP's upload limits (HANDOFF "Choose a video file in the panel";
  plan `docs/plans/2026-10-20-video-upload.md`). Reviewed on opus and fixed. Not yet tried by the user.
- **Links to pages (19.17, hyperlink):** a card or row with an arrow (→ ↗ ↘ ›, read from the icon's drawing) links
  whole to its title's page; an arrow button or "Learn more" to the page its words name (HANDOFF "Links to pages from
  arrows and Learn more"; plan and ledger `docs/plans/2026-10-19-page-links*`). Reviewed on opus and fixed. Paste check
  3r owed; the user's rulings and my own are below ("Links to pages").
- **Links checked against the site (20.7, hyperlink):** with WordPress connected, after Convert the panel reads the
  site's pages (drafts too) and points every page link (Figma's Navigate links and the plugin's own) at the real page
  whose name matches, "Final"/"Page"/"Our"/"Us" left out; it names drafts, missing pages and ties (HANDOFF "Links
  checked against the site's pages"; plan and ledger `docs/plans/2026-10-20-site-pages*`). Reviewed on opus and fixed.
  Paste check 3u owed. **The user's Remanufactured page on the live site was pasted from an old conversion** (its rows
  and Call buttons have no links at all, read 2026-10-20): it needs a fresh Convert and paste.
  **20.8:** singular and plural are one name ("Hydraulic" / "Hydraulics"); a link never ends on a picture (the user:
  "it always has to be a website"): with no page, a link whose address is a picture's own is taken off and named, and
  uploads are never named like an address the paste links to (HANDOFF "A link that downloaded a picture").
- **List columns on the live page (19.18):** build .15's records were each as wide as their words, centred, on the
  user's site. Bricks writes Flex basis (a text control) as given, so `_flexBasis: "323"` became CSS the browser drops.
  Flex basis numbers now go out in px, `payloadProblems` refuses a bare one, and the renderer writes it as Bricks does
  (`reference/bricks/README.md` "Text controls"). Paste check 3p owed.
- **Three reviews on one tablet row (20.1, reviews-tablet):** a row of 3, 5… alike cards stays one row on tablets
  instead of leaving one alone (as grids did since 16.5); a badge ≤ 96px (an avatar's initials) keeps its size when its
  row stacks (HANDOFF "Three reviews on one tablet row"). 20.3: on phones held sideways they stay one row too (rows
  and grids), upright phones stack them. Paste check 3s owed.
- **Rows on phones held sideways (20.4, fix-list-landscape):** Bricks wraps every Section, Container and Block from
  767px down (its front-end CSS). On the user's site, the parts list's cells each fell onto a line of their own at 766.
  - **The renderer** now copies that default.
  - **`row.reflow`:** a row the layout plan keeps on one line at mobile landscape writes `_flexWrap: "nowrap"` there
    (`Style.wrap: false`). This also fixes FAQ questions beside their icon on phones, and 20.3's three cards on one row.
  - **The list toolbar's search and pills** get a row gap once stacked, and the pills' lines one too.
  - HANDOFF "Lists and tables on tablets and phones". Paste check 3p owed.
- **Hover layers and FAQ looks after a paste (20.6, hover-ids):** the user's hovered "Not sure what you need?" card
  "runs black": its hover layer named the card by an id Bricks renames on paste. Looks that follow another element now
  name it by a marker class in its CSS classes (`trigger-…`), never its id (HANDOFF "Hover layers and FAQ looks after
  a paste"). Fixes the FAQ "+" icon too. Paste check 3t owed.

**The user's live site:** `darksalmon-badger-335429.hostingersite.com` (Hostinger, WordPress, Bricks; LiteSpeed Cache,
WP Mail SMTP, Yoast, WPForms Pro, AltText.ai plugins). After a paste that holds code (lists, card arrows) the user must
run Bricks → Settings → Custom code → **Regenerate code signatures**; after any CSS change, **LiteSpeed → Purge All**.

**Files the user works with:**
- `figma-to-bricks-debug-page-1.json` (repo root): **holds "Hydraulic Cylinder Repairs Final" (build 2026-10-20.6, 1728
  wide), committed and pushed 2026-10-26 (`cd9c1c9`)**. The earlier copy (`git show 2199895:figma-to-bricks-debug-page-1.json`,
  build .4) is the user's **"Services Page Final"** (1728 wide). It holds
  the parts inventory ("PART INVENTORY DASHBOARD": 78 rows drawn, search, 6 pills, a 560px scroll box). Earlier saves of
  that name (the contact page "Contact Page Final", one stat card) were overwritten; ask for a new save if needed.
- `corpus/…/page-1` (v1's file on the Desktop) is an older save of the same page; it now converts with the list too.
- `docs/data/reman-cylinders.csv` (also in `~/Downloads`): the 78 cylinders, matching the designer's table row for
  row.
- `reference/wpforms/`: the WPForms notes and `need-a-repair-559.css`.
- The scratchpad (backups, review scripts, screenshots) belonged to the old chat and is gone or stale; never rely on
  it.

**Git and several agents (2026-10-19):** the project is in git, with a private copy on GitHub
(`Just-In-N-Out/FigmaToBricksV2`). Several agents can each build a feature in their own copy (`claude -w <name>`). Read
"Working in this repo" before committing or merging.

**Waiting on the user (don't guess these):**
- **The inventory's "Download full inventory (PDF)" button:** they upload the PDF to WordPress Media and link it
  (Figma "Open link" on click, or in Bricks). The plugin needs no change. They were given the steps.
- **Answers:**
  - ~~**Should a full-width map leave the 1440 Container?**~~ Answered 2026-10-23 (wordless-maps): yes, a map drawn
    across its section runs edge to edge on every screen.
  - **Should headings keep Figma's case** when the site theme uppercases them?
  - **WPForms:** whether the plugin should get a "Forms become: Bricks form / WPForms" option, and which starts
    selected. It needs their WPForms export file.
  - **Rulings to confirm:** the list rules in HANDOFF "Searchable lists", and the form rulings.
- **Samples still owed:** Nav (Nestable) for the phone menu, Tabs, Dropdown, Offcanvas + Toggle, a working Interaction,
  a `popover` Div. Never write those emitters from memory.
- **Paste checks owed:** HANDOFF "End-of-run check list" 3c–3k. The user has pasted the photo (19.3) and list (19.5)
  builds; the list was confirmed working apart from the two things 19.6 fixed.

**Known open bugs and limits:**
- **Lists:**
  - **Card grids** (cards in columns, with pills) aren't recognised as lists yet.
  - **Deferred minors:** the panel's empty list name, two lists with desktop + phone frames, the status after Remove,
    no large-CSV warning, tab-separated files.
- **Zooming in (150%+):** contact cards are cramped and the menu breaks into a grid (it needs the Nav sample).
- **Space frozen into a fixed-height box** (found in faq-answer-space, 26.1): a box drawn at a fixed height with its
  words at its top loses the space under them once they wrap more, and from 991px down (`size.unpin` drops its min
  height); FAQ answers are fixed, other boxes aren't yet. A badge pinned to the bottom of such a box lands on its
  words on phones (on main too).
- **Flip cards** (28.1): Safari may show a turned-away face's composited children (a `will-change` picture, a video, a
  CTA's fade-in) through `backface-visibility` (iPhone check 3bn); a divided row of flip cards keeps its lines on
  tablets and phones.

**How the user works (see memory too):**
- They answer with screenshots and short messages.
- They want plain, numbered steps naming exactly what is on their screen, one action at a time.
- They expect general fixes. Ask before a design decision with trade-offs (AskUserQuestion with previews worked well).
- They said "build straight through": run each milestone (plan → test-first → corpus → opus review → fix pass) without
  stopping. Report rulings and deferred minors in plain words at the end.

**Where things stand (2026-10-19; the entries run in date order):**

- **M0, M1, M2a–M2e, M3a, M3b, M4a and M4b are done, reviewed and fixed** (build `2026-10-07.15`).
- **GRO desktop** (build `2026-10-07.17`, HANDOFF "GRO desktop"): designs drawn **without auto layout** now come out
  1:1 at the design width. The user reported it on their GRO homepage (`corpus/files/gro-home.json`, now a corpus file).
  - Thirteen rules: paint order, Container-box measuring, full-width parts, band spacing, bleeding art, aligned text
    boxes, trailing letter-spacing, no wrap where Figma draws one line, transparent text, the shape pin.
  - M3a: hover styles and FAQ accordions. M3b: hover layers for what CSS can't draw. How they work: HANDOFF "M3a" and
    "M3b".
  - Their own choices, not yet the user's: a hover target shows the hand (`_cursor`); closed FAQ items without an
    answer get a placeholder.
  - **The user said (2026-10-07): build straight through, they check everything at the end.** So paste checks pile
    up in HANDOFF instead of stopping the run.
- **WordPress pictures** (build `2026-10-07.18`, HANDOFF "WordPress pictures"): every picture sent to WordPress
  pasted as Bricks' grey placeholder.
  - The cause: Bricks swaps id'd images when the paste's `sourceUrl` isn't the site's address. The paste now names
    the site.
  - Also new: the panel's "Picture descriptions" list (saved in the Figma file, sent to WordPress), and reused
    uploads get changed alt text.
  - Build `.19`: the Convert click puts a note on the clipboard, so an older copy can't be pasted after the browser
    refuses the late automatic copy. Bricks' editor draws pasted pictures one server request each, so on the user's
    host some stay blank until the page is saved and viewed.
- **GRO phones** (build `2026-10-07.20`, reviewed and fixed, HANDOFF "GRO phones"): designs drawn **without auto layout** now read well
  on tablets and phones, following the user's decoration choices (below, "Free-floating designs on phones").
  - New passes: repeated cards read column by column (`normalise/columns.ts`), overlapping heading pieces as one
    picture (art groups), a big drawing on a photo paired with it (`normalise/pairs.ts`), the next card past a
    section's edge as one group (`normalise/past-edge.ts`), narrow-screen plans (`understand/compose.ts`).
  - New rules: `compose.stack`, `art.edge`, `picture.band`, `turn.upright`. Column offsets slide, picture floors let
    go in rows, paragraph cards stack instead of going two per row.
  - GRO lint errors 390 7→2, 768 18→4; every section exact at 1024/1440/1920. The other corpus files are no worse
    anywhere (design and final-design a little better).
- **Drawn phone design** (build `2026-10-08.2`, reviewed and fixed, HANDOFF "Drawn phone design"): when the desktop
  frame and a phone frame (320–767 wide) are selected together, one paste holds both.
  - The phone copy shows at 767 and below, as drawn at its width; the desktop copy shows above it.
  - Free-drawn compositions on the phone (`drawn.scale`) shrink as one below the drawn width and keep it above.
  - Detection lives in `snapshot/designs.ts`, the per-design sections in `understand/designs.ts`.
  - One frame selected is byte-identical to before.
  - Build `2026-10-08.3` (HANDOFF "Carousels on the drawn phone"): a drawn phone row running past the screen's edge
    is a Slider (Nestable) (`understand/tracks.ts`). Text ink cut by a clipping frame no longer sizes the text
    (`normalise/text.ts`). The user's pair debug file is `figma-to-bricks-debug-design-inspo-brainstorm.json`.
- **Sideways scroll strips and outline text** (build `2026-10-08.4`, HANDOFF "Sideways scroll strips"):
  - A frame Figma's prototype scrolls sideways becomes a strip that scrolls sideways (`understand/strips.ts`,
    `style/strips.ts`), with its layers drawn down to tablets (adapt engine).
  - A text drawn as an outline shows as one (`outlineStyle`).
- **Found 2026-10-08, fixed in build `2026-10-20.6`:** Bricks gives pasted elements new ids, rewriting each id only
  inside its own element (`reference/bricks/README.md` "Ids on paste").
  - `emit/states.ts` wrote a look that follows another element's hover or an accordion item's open state as
    `#brxe-TRIGGER:hover #brxe-SELF`, stale after a paste (the user's hover card "ran black", 2026-10-20).
  - Now TRIGGER carries `_cssClasses: "trigger-<hash of its key>"` and the look is `.trigger-…:hover #brxe-SELF`.
    Test `emit-paste-ids`: no element's custom CSS names another element's id, on every corpus file.
  - Never name another element's id in custom CSS or a script.
- **Typed spaces** (2026-10-08): spaces a designer types to indent a line or to space words out show as typed
  (`&nbsp;`, `style/typography.ts` `keptSpaces`).
- **Desktop sizing fixes** (build `2026-10-08.7`, HANDOFF "Desktop sizing fixes"), from the user's "Final homepage"
  file:
  - a fill layer no longer widens a hugging column whose width another layer sets (`sizing.ts` `addsNoWidth`);
  - a fixed one-line text in a wrapping row keeps its box;
  - a box drawn wider than an auto-layout column hangs past it (`hangs()`);
  - Figma's small capitals show (`font-variant-caps`).
  - Not yet reviewed on opus.
- **Typed lines and wide photos** (build `2026-10-08.8`, HANDOFF "Typed lines and wide photos"):
  - a text broken only at typed breaks keeps its box as its room, and holds its lines where tight (`typedLines`);
  - `wide.ts` reaches photos behind the content through full-width wrappers; a cover fills `100vw`.
  - Aswatama (a paid font) reached the user on 2026-10-09. With it every heading has Figma's lines from 1280 up;
    at 1024–1100 four headings wrap more (HANDOFF "Aswatama check").
- **AI picture descriptions** (build `2026-10-14.1`, HANDOFF "AI picture descriptions"): photos going to WordPress
  are described by alttext.ai with the user's key.
  - **Code:** `src/ui/describe.ts`. Each photo is sent once, as a ≤1024px WebP; the words go up as `alt_text` and are
    auto-saved in `f2b-alts` (`ai`).
  - Reviewed on opus and fixed: rendered photos count, describing halts when uploads stop, words stored once.
  - **Key:** in the panel's "alttext.ai" box, kept in `clientStorage`.
  - **Not yet tried with the user's key.**
- **Figma colours → Style Manager → Colors** (build `2026-10-14.2`, HANDOFF "Figma colours"): after Convert, the panel
  offers a palette file the user imports in Bricks (Style Manager → Colors → Import).
  - **What goes in:** the file's colour variables and colour styles, named as in Figma, or in a file without them the
    opaque colours its design paints (`color-<hex>`).
  - **Pasted colours** point at the palette colour they are bound to (variable or style), else at one of the same value
    (`{id, raw: "var(--name, #HEX)", light}`).
  - **Second pages:** the panel keeps every colour a file's palette has had (`keepPalette`), so re-importing never drops
    earlier pages' colours.
  - **Code:**
    - extract `src/plugin/extract/colors.ts` → `Snapshot.colors`;
    - normalise `normalise/colors.ts` and `used-colors.ts` → `Scene.palette`;
    - `model/palette.ts` (the ink used by the style stage);
    - `emit/palette.ts` (settings and the file).
  - **Older debug files** (no `colors`) convert as before.
  - **Reviewed on opus and fixed** (bindings honoured, palettes kept across pages, corpus invariant test).
  - **Not yet tried in Bricks** (HANDOFF check 3b).
- **Buttons as wide as their column** (build `2026-10-16.1`, HANDOFF "Buttons as wide as their column"): the user's
  hero buttons came out as wide as their column in Bricks. Bricks' "Align self: stretch" also writes `width: 100%`.
  - **The fix:**
    - a row whose items all fill its height uses "Align items: stretch";
    - any other stretch is custom CSS;
    - `payloadProblems` refuses `_alignSelf: stretch`;
    - the renderer draws Bricks' extra width.
  - Not yet pasted by the user. Their second example ("tall and long") never arrived.
- **FAQ questions side by side** (build `2026-10-16.2`, HANDOFF "FAQ questions side by side"): Bricks dropped the FAQ
  list's `_direction` and lined its questions up in a row. Bricks reads `_direction`, `_rowGap`, `_columnGap`,
  `_flexWrap` and the grid keys only on section, container, block and div.
  - **The fix:**
    - an FAQ list whose items touch sets no layout;
    - other elements get `_flexDirection` and `_gap`;
    - `payloadProblems` refuses the rest;
    - the renderer follows.
  - Not yet pasted by the user. The same screenshot showed the open icon wrong (the known id issue) and headings in
    capitals (the site's theme).
- **Map and grid cards** (build `2026-10-16.3`, HANDOFF "A map that didn't show, and grid cards stretched"):
  - **The map:** a page-captured map made of picture tiles is one picture (`normalise/mosaic.ts`).
  - **The cards:** a Figma grid's items sit at the top of their cells (`_alignItemsGrid`), filling or centred where
    Figma says.
  - **Open question for the user:** should a full-width map leave the 1440 Container? Not yet pasted by the user.
- **Contact form on phones** (build `2026-10-16.4`, HANDOFF "Radio options and paired fields on phones"):
  - **The layout plan** no longer shares out a section's width twice when the section and its box are one layer (a
    section drawn as a grid).
  - **Fixed boxes that fill their row** edge to edge grow with it (`style/shares.ts`).
  - Not yet pasted by the user.
- **Contact cards three across on tablets** (build `2026-10-16.5`, HANDOFF "Contact cards three across on tablets"):
  - a grid doesn't leave one card alone on a tablet row;
  - Figma grid columns are `minmax(0, Nfr)`;
  - narrow boxes give up side padding;
  - long emails and links break.
  - **Open for the user:** at 768 the cards are cramped.
- **Maps keep their height** (build `2026-10-16.6`, HANDOFF "Maps keep their height on tablets and phones"): a box a
  map shows behind, holding no words, keeps its drawn height on every screen (`adapt/map-box.ts`).
  - The lint's hole check now counts background pictures.
  - Not yet pasted by the user.
- **Real forms** (build `2026-10-16.7`, HANDOFF "Real forms"): a drawn contact form (labels over boxes, Yes/No marks,
  a send button) becomes Bricks' Form, typed in and sent by email.
  - **Code:** `understand/form.ts` (recognition, from shapes only), `style/form.ts` (the look), `emit/form.ts`
    (settings + custom CSS), `adapt/rules/form.ts` (phones). Samples: `reference/bricks/form-basic.json`, Bricks'
    schema `form-schema.json`.
  - The option drawn chosen shows when a visitor picks it; nothing is pre-picked.
  - Reviewed on opus and fixed. Paste check 3i (send a message) not yet done; the field `width` key is unverified.
  - Build `2026-10-19.1`: the user's paste showed no labels. Bricks prints labels only with `showLabels` and its star
    only with `requiredAsterisk` (both off by default); its button Width setting didn't reach the page, so the button
    spans the form by custom CSS too.
- **Photos on wider screens** (build `2026-10-19.3`, HANDOFF "Photos on wider screens and browser zoom"): zooming out
  (or a wide monitor) cut the top and bottom off a hero's photo. From the design width up, a photo behind a section,
  band or full-width box keeps its drawn size in the middle, its edges fading into the colour under it
  (`style/photo-width.ts`). Build .2's taller hero was replaced at the user's request. Zooming in found cramped contact
  cards and the missing phone menu (not yet fixed; a question to the user).
- **Searchable lists** (build `2026-10-19.4`, HANDOFF "Searchable lists from a spreadsheet"): rows drawn in Figma with
  filter pills or a search box become a working list (search, pills, count) filled from a CSV given in the panel,
  saved in the Figma file (`f2b-lists`).
  - **Code:** `understand/lists.ts` + `list-rows.ts`, `style/lists.ts`, `emit/lists.ts` (a Code element found by
    class), `ui/lists.ts`, `plugin/lists.ts`.
  - The client's data: `docs/data/reman-cylinders.csv` (78 rows).
  - Reviewed on opus and fixed (footers/pricing tables never lists, painted headers, partial binding, badges, counts).
  - Build `2026-10-19.5`, from the user's real page (imported from a website):
    - lists find their pills up to the section;
    - rows need two cells;
    - the longest rows claim a list first;
    - search words may sit in wrappers;
    - a box Figma scrolls down scrolls on the site (`scrollsY`).
    - Verified in Chrome on their file (78 rows, every pill's count right).
  - Build `2026-10-19.6`: a box Figma scrolls down lets its layers flow past its bottom (`infer.ts`) and is at most its
    drawn height, so a filtered list leaves no empty space; thin grey scrollbar.
- **Call and email links** (build `2026-10-19.7`, HANDOFF "Call and email links"): a "Call" button gets a `tel:` link
  to the page's number, and every phone number and email address shown becomes a link.
  - **Code:**
    - `normalise/contacts.ts` (finding numbers, addresses and call/email words);
    - `normalise/contact-links.ts` (a pass at the end of normalise);
    - `normalise/label-box.ts` (button shapes, shared with `understand/widgets.ts`).
  - **Buttons** get `SceneNode.contact` (apart from the designer's `link`, which always wins); understand reads
    `n.link ?? n.contact`. Numbers in words are linked pieces of the text (`Run.link`).
  - **Inline links** keep the drawn colour and underline (`color:inherit;text-decoration:inherit`).
  - **Reviewed on opus and fixed:**
    - an FAQ question is no button;
    - the designer's text links win;
    - one label per button, never a section;
    - narrower words;
    - placeholders and hidden layers don't count;
    - one number written two ways is one.
  - Paste check 3l not yet done.
- **Listing media with the number above the photo** (build `2026-10-19.13`, branch `worktree-Media`, HANDOFF of the
  same name): the user's Services rows 004 and 005 got no zoom and glare (their screenshot of "Service 004").
  - **The cause:** their Media boxes have no auto layout. The photo sits wholly below the big "00N" number, so the
    layout pass lines both up in a column. The number then counted as words (`hasFlowText`), and the row as no
    photo/text row.
  - **The fix:** `recognise.ts` `hasFlowText` treats one short flowing line (one line, `LABEL_MAX` characters at most)
    as a label. Two texts, or a sentence, are still words.
  - **Effects:** rows 004 and 005 zoom and glare, and row 005 stacks photo first on phones (the zigzag rule; my
    ruling, told to the user). No other corpus file's paste changed.
  - Not yet pasted by the user.
- **Logo marquees** (build `2026-10-19.14`, branch `worktree-marquee`, HANDOFF "Logo marquee"): the user's hydraulics
  homepage logo band was static ("the logo needs to be going from left to right"); v1 had it working.
  - **Code:**
    - `understand/marquee.ts` (recognition, one round, the loop copies `copy:marquee<i>:…`);
    - `style/marquee.ts` and `classes.ts` (`marquee`, `marquee-track`, `marquee-round`, `@keyframes marquee-right`);
    - `adapt/rules/marquee.ts` (`marquee.gap`; `Rule.moves`, the engine's shield of the moving row);
    - `emit/elements.ts` (`_attributes`: tabindex, role, aria-label, aria-hidden on copies, tabindex -1 on their
      links).
  - **The drawn row stays put** (a Container keeps its class); a moving row the plugin adds in it holds the rounds.
    Drawn across a box spanning its section, the logos run to the window's edges (the section clips sideways);
    otherwise the row clips them itself.
  - **Not marquees:** photos (120px+ each way), cards, linked words, Figma's sideways strips, sliders. A band of SVG
    logos alone (no dots or pictures) is one drawing to normalise, so it stays still (deferred).
  - **The layout lint** reads one round (it skips loop copies and the moving row's clipping).
  - **My rulings and the deferred minors:** in the ledger and HANDOFF. Not yet pasted by the user (3o: `_attributes`
    round trip).
- **Lists and tables on tablets and phones** (build `2026-10-19.15`, branch `worktree-fix-mobile-layout`, HANDOFF
  "Lists and tables on tablets and phones"): the user's parts inventory "just doesn't look clean" at 990, 766 and 477
  (records and titles wrapped, the last column held by a 465px minimum).
  - **Code:**
    - `understand/lists.ts`: the title row (`headOf`, the nearest row above the records lined up with them, its words
      of one look) and each record's column parts (`lead`, `end`, `more`, `dot`);
    - `adapt/layout.ts` `decideRow`: a record keeps its line down to phones held sideways, stacks on phones;
    - `adapt/rules/list.ts` (`list.layout`).
    - **Shared classes** for the phone card: `list-row`, `list-lead`, `list-end`, `list-more`, `list-dot`.
    - **The `_order` setting** (`Style.order`).
  - **Below the design width:** each column's basis is its drawn width, shrinking, never held by a minimum.
    - Photos, badges and Buttons keep their size.
    - Pills drawn at the toolbar's end go under the search from the left once they don't fit.
  - **Phones:** the titles hide; each record is a card. Its first column and its last share the first line, the
    others go under them with a dot between. Cells carrying the padding and rule give them to the card.
  - **Deferred:**
    - an empty value leaves a dangling dot;
    - the paste is bigger (corpus page-1 764 → 1055 KB; per-column classes would cut it);
    - the narrow-column lint warning counts the cards' values (31 → 62 on page-1's phones).
  - **Build `2026-10-19.18`:** the user's paste of .15 showed each record as wide as its words. The cause was Bricks
    writing Flex basis as given (`flex-basis: 323` on the page). It now goes out in px.
  - **Build `2026-10-20.4`:** the user's Bricks editor at 766 showed each record's cells on lines of their own (Bricks
    wraps every Block from 767px down) and the pills touching the search. Kept rows now say `nowrap` at mobile
    landscape (`adapt/rules/rows.ts`), the renderer copies Bricks' wrap, and the toolbar gets row gaps.
  - The .20.4 build is not yet pasted by the user.
- **Links to pages** (build `2026-10-19.17`, branch `worktree-hyperlink`, HANDOFF "Links to pages from arrows and
  Learn more"): the user's "Service 03 | Core Exchanges | ↗" row should open `/core-exchanges/`.
  - **Code:**
    - `normalise/svg-paths.ts` + `arrow-shape.ts`: which way an icon's exported SVG points (a head at the drawing's far
      end, mostly head and shaft; backdrops dropped; Figma bakes turns and flips into the export);
    - `normalise/page-words.ts` (what a label names; actions, other sites, pagination never), `card-title.ts` (the
      card's biggest, standing-out short name), `page-links.ts` (the pass, after `linkContacts`, on
      `SceneNode.pageLink`), `faq-shape.ts` (FAQ shape shared with `understand/accordion.ts`);
    - `understand/node.ts` reads `n.link ?? n.contact ?? n.pageLink?.url`; `understand/page-links.ts` writes one panel
      note per link; `headings.ts` keeps a linked card's (or a heading row's) heading.
  - **On the user's files:** Services Page Final "Browse Inventory ↗" ×2 → `/inventory/`; hydraulics' 5 service cards
    whole → their titles, "View Our Gallery ↗" → `/gallery/`; GRO's ten "Link · …"; brainstorm's arrow buttons.
    Headings and element counts unchanged on every corpus file; lint errors unchanged.
  - Not yet pasted by the user (3r: `tag: "a"` with a relative address, a linked text, the iPhone tap on a hover card).
- **Links checked against the site's pages** (build `2026-10-20.7`, branch `worktree-hyperlink`, HANDOFF of the same
  name): the rows went to `/core-exchanges/` while the site's page is the draft "Core Exchanges Final", and the menu's
  `/gallery-page-final/` while the site's is `/gallery/`.
  - **Code:** core `emit/page-addresses.ts` (`ConvertResult.pageLinks`: each address, its name, its elements' ids;
    `SceneNode.linkFrame` marks Navigate links); panel `ui/site-read.ts` (pages over REST, edit context, past exactly
    100, archives and posts asked before a draft takes a link) and `ui/site-pages.ts` (`pageKey`, ranking, relink by
    element, notes), run from `run.ts` `startRun`.
  - **Pastes** are byte-identical to before; only the panel rewrites, only the listed elements.
- **Three reviews on one tablet row** (build `2026-10-20.1`, branch `worktree-reviews-tablet`, HANDOFF of the same
  name): the Services page's three reviews went two plus one at 990.
  - **The cause:** `decideRow` chose "two per row" on tablets for a row of cards that don't fit 200px each with their
    labels whole; only grids (`gridColumns`) had the "never leave one alone" exception.
  - **The fix:** `layout.ts` `alikeCards` + `ALONE_MIN`: on a tablet, 3, 5… alike cards (boxes within 80% of each
    other's width) stay one row while each gets 160px. `rows.ts` `widens`: a box ≤ 96px each way (an avatar, a number
    badge) keeps its size when its row stacks (it became a pill; phones too). `unpin.ts`: the words beside an icon
    are `row.icons`' alone (a collision once the hydraulics info cards stayed three across).
  - **Phones (build `2026-10-20.3`, user: "if on mobile make them stack. for mobile landscape put all 3 in the same
    row"):** held sideways, alike cards and a grid's cells stay one row while each gets 120px (`ALONE_MIN`; at 480 a
    review is 135px); upright they stack. A grid too narrow for 120px each stacks.
  - **Effects:** the hydraulics homepage's info cards stay three across on tablets; corpus "design"'s contact row
    (address, hours, phone) too, its hours wrapping to 18 lines at 768 (accepted: the user chose three across).
  - Not yet pasted by the user (3s).
- **Hero video** (builds `2026-10-19.16` and `2026-10-20.2`, branch `worktree-fixvideo`, HANDOFF "Hero video" and
  "Videos found in the WordPress Media library"): the user's hero video pasted as an empty black Div. `paintsOf`
  dropped Figma's `VIDEO` paints.
  - **Figma's limits:** plugins get only `videoHash` (the file's SHA-1), never the file, and Figma's PNG export draws
    no frame of a video. So a video fill has no poster.
  - **v1's way, ported** (the user: "just do what v1 did"): an address in the layer name (`Video: https://…`) or an
    Open link to a video makes Bricks' Video (keys from `reference/bricks/video-schema.json`, Bricks' official schema).
  - **Plays by itself** (muted, looping, inline, no controls) where it covers the boxes around it up to one holding
    other layers (`understand/video.ts`). It covers wider screens, and phones keep it covering the hero
    (`media.shape` skips it).
  - **Frames painted with a video** keep their layers, with a video layer under them; tints over a video are drawn on
    it.
  - **The Media lookup** (`src/ui/videos.ts`, user: "go"): finds a video without an address on the WordPress site by
    exact name, saves it in the file (`f2b-videos`), and converts the same frames again (`again`). Details are in
    "Start here".
  - **Paste check 3q** is not done yet.
- **Live maps** (build `2026-10-20.10`, branch `worktree-maps`, HANDOFF "Live maps"; ledger
  `docs/plans/2026-10-20-live-maps-ledger.md`): the "Visit the Shop" map was a picture of Google's tiles.
  - **Code:**
    - `normalise/maps.ts` `findMaps` → `SceneNode.map`. A map is tiles (`tiled`) plus a map's own word (`SIGNS`:
      "Open in Maps", "Map data…") or a maps link, holding only its own words (controls, Google's place card);
    - `normalise/address.ts` `addressIn` (a street word or a postcode, a house number; contacts cut out);
    - `understand/node.ts` `mapIR` (a Code element, `IRNode.map`; never inside a link); `section.ts` never makes a
      map a wrapper or band; `understand/maps.ts` notes each map, and each one left a picture;
    - `emit/maps.ts` (Google's keyless `maps?q=…&z=15&output=embed` iframe covering the element; the live site prints
      a Code element inside `div.brxe-code`); `style.ts` `liveMap`; `adapt/map-box.ts` keeps its height.
  - **On the user's files:** hydraulics, page-1 and the current debug file each get a live map of "12836 Hwy 57,
    Evansville, IN 47725", 220px tall; the other corpus pastes are byte-identical.
  - **My rulings, not yet confirmed:** the Code element; zoom 15; a maps link, then the place card's address, then the
    nearest address in the map's section; a map inside a linked card stays a picture (noted); "Get Directions" stays
    as it was.
  - **Deferred:** an address in another section; a map that is itself a section; a hover layer drawn from a variant's
    own tiles; addresses ranked by distance only.
  - Not yet pasted by the user (3w).
- **Fonts dropped on the panel** (build `2026-10-20.11`, branch `worktree-fonts`, HANDOFF "Fonts dropped on the
  panel"; plan and ledger `docs/plans/2026-10-20-font-drop*`): fonts not on Google Fonts (GRO's Aswatama) no longer
  wait for a hand upload to Bricks → Custom Fonts. Without them the browser shows a wider stand-in, so lines wrap where
  Figma doesn't.
  - **Code:**
    - `src/ui/sfnt.ts`, `inflate.ts`, `unzip.ts`, `drop.ts`: reading fonts, zips and folders;
    - `font-files.ts` `pickFonts`: pairs each file with the design's family by Unicode key, the design's spelling
      kept; one file per face; checked by `env.fontLoads`;
    - `woff.ts`: TTF/OTF to WOFF;
    - `site-fonts.ts`: Font Library REST, one face at a time; errors worded for fonts;
    - `font-sources.ts`: the CSS, the rows and the notes;
    - `run.ts`: reads the site's fonts while the pictures go, whenever WordPress is connected;
    - `main.ts`: the Fonts box and the window-wide drop.
  - **Paste:** `@font-face` on the first element's custom CSS, after Google's. The paste's `font-family` stays
    Figma's name.
  - **My rulings, not yet confirmed:**
    - the site's copy beats Google's;
    - every static face of a used family goes in the CSS; a variable face once per design weight of its slant
      (21.3: never a weight range);
    - oblique is written as italic;
    - woff2 > woff > ttf > otf, and a variable font beats its statics;
    - a face the site has is skipped;
    - the page converts again only when the last conversion uses an added family.
  - **Deferred minors** (ledger): .ttc named "not a font", zips in zips, legacy per-weight family names, the site's
    fontWeight unchecked in the CSS, nearby weights shown missing, wording.
  - **Font weights** (build `2026-10-21.3`, branch `worktree-font-weight-gaps`, HANDOFF "Weight ranges broke Bricks'
    Google Fonts link; font weights read as standard"; plan and ledger `docs/plans/2026-10-21-font-weight-gaps*`):
    - `src/ui/font-weight.ts` (new) `standardWeight` / `namedWeight`; `sfnt.ts` `readFontInfo` returns the standard
      weight; `site-fonts.ts` `faceOf` reads a stored in-between weight from the file name (`font-files.ts`
      `nameParts`, WordPress's `-<n>` ignored unless a weight) or leaves the face out; `normal`/`bold` → 400/700;
      `font-sources.ts` `siteFaceCss` never writes a range.
    - **My rulings, not yet confirmed:** a round OS/2 hundred wins over the style name; an in-between weight with no
      weight word → nearest hundred on upload (tie toward 400), left out when read from the site; OS/2 above 900 →
      900; "Regular"/"Normal"/"Book"/"Roman" say 400, "Italic" alone none; a weight Google lacks keeps today's note.
    - Paste check 3af owed (needs the header button's weight set to 600 in Bricks first).
  - Not yet tried by the user (3x).
- **One-line words** (build `2026-10-20.12`, branch `worktree-one-line`, HANDOFF "One-line words that wrapped in
  Bricks"; plan and ledger `docs/plans/2026-10-20-one-line-text*`):
  - **The report:** the user's live Services page showed its two-colour tags on two lines. The live page was read over
    HTTP: 43px tall at every width and zoom.
  - **The cause:** two runs make no Button label, so a tag is a Div pill hugging a Text. The Text's trailing-spacing
    margin made the pill 0.56px narrower than its words, and Bricks' `[class*=brxe-]{max-width:100%}` held it there.
  - **Code:**
    - `style/tracking.ts` `tracked`/`fullWidth`/`grow`: a cap, a share and a floor taken from Figma's box all grow by
      the trailing spacing. A px cap beats Bricks' cap and grows by px; keywords stay.
    - `style/place.ts` SCALE: `scaledWidth`/`drawnRoom`; `drawnRoom` is shared with `lineCap`.
    - `adapt/rules/unpin.ts`: the hanging cap and the Scale share at tiers.
    - `tools/wraps.ts`.
  - **Tests:** `style.test.ts`, `content-box.test.ts`, `test/browser/one-line.test.ts` (proved failing without the
    fix), fixture `test/fixtures/tags.ts`.
  - **Corpus:**
    - page-1 pixel 0.71 → 0.76, hydraulics 0.40 → 0.50, final-design 0.894 → 0.905 (structure 0.74 → 0.69, its
      content moving toward Figma's places);
    - three new lint overlaps: final-design's heading over its giant word, as drawn; the 0px "Services" menu item at
      1024 on page-1 and hydraulics, a menu bug on main too, noted.
  - **My rulings, not yet confirmed:** a Scaled auto-width text may sit up to a few px wider than drawn (its words'
    room); the share comes inside its box wherever the layout plan gives the box another width.
  - Not yet pasted by the user (3y: the tags on one line; a calc in Bricks' Max. width round trip).
- **Header and footer the site already has** (build `2026-10-20.13`, branch `worktree-site-parts`, HANDOFF of the
  same name; plan and ledger `docs/plans/2026-10-20-site-parts*`):
  - **The ticks:**
    - `normalise/site.ts`, `Snapshot.site`, `plugin/site.ts`;
    - the panel's `#siteHeader` / `#siteFooter`;
    - tools `--site[=header,footer]`, and snap's `--header=<px>[,<phone px>]` (a fixed stand-in header).
  - **Recognition** (understand, from structure):
    - `bars.ts` (shared with `heroOf`);
    - `site-header.ts`: the header's own bar has a logo at its left and a menu; bars above it go, and under it only a
      row of links;
    - `site-footer.ts`: a © line with columns or a menu; a thin © bar with the columns above it unless they hold a
      heading or a scrolling box; never a form;
    - `leave-out.ts`: `designOf` builds every section, leaves the parts out, then spaces the rest. `DesignIR.left`.
  - **The spacer:**
    - `understand/room.ts` (made last, role `spacer`), `style/room.ts`, `emit/room.ts`;
    - a Section `site-header-room` (+ `site-header-under`) holding a hidden Code element;
    - its script measures `#brx-header`'s fixed or absolute boxes as at the top of the page;
    - push (drawn above), or under (less the first section's own top padding);
    - `planLayout` never counts it, and marks no footer when the footer was left out.
  - **Ticks off:** every paste is byte-identical.
  - **On the user's files:** their 73px "Frame" header and 966–988px footer go. GRO's and brainstorm's nav drawn
    inside the hero stays (noted; a follow-up).
  - **My rulings and the deferred minors:** in HANDOFF. Paste check 3z owed.
- **Links that opened a picture** (build `2026-10-20.14`, branch `worktree-link-hrefs`, HANDOFF "Links that opened a
  picture, and links kept right"; plan and ledger `docs/plans/2026-10-20-link-hrefs*`):
  - **Core:** `normalise/links.ts` `fileAddress` (a path ending in a picture or video type), `fileNote`, `notWebNote`;
    `normalise.ts` `build` and `text.ts` `hyperlinkOf` (text links through `safeUrl` too) leave such links off;
    `emit/payload.ts` `payloadProblems` refuses a link or `<a href>` to one.
  - **Panel:** `files.ts` `safeFilename` (always `-image`; `fileStem` for embed), `videos.ts` `videoUploadName`
    (`-video`; the lookup still finds those names); `site-read.ts` `heldAddresses`/`opensAt` (media on a link's
    address only where WordPress serves it: attached to no page, or its own `link`) and `wordpress.ts`
    `setMediaSlug` + `oneAtATime`; `site-pages.ts` `Held`, `Match.freed`, the notes; `run.ts` passes the upload
    cache's ids.
  - **On the user's file:** the grid's cards keep their hrefs (`/remanufactured-hydraulic-cylinders/`,
    `/core-exchanges/`, `/rods-1-15-rechroming-rods/`, `/assembly-test-paint-delivery/`); the site check sends them
    to the "… Final" pages, and with 647 in the upload cache frees `/rods-1-15-rechroming-rods/`.
  - **My rulings and the deferred minors:** in HANDOFF. Not yet tried by the user (3aa).
- **Cards drawn the same height** (build `2026-10-20.15`, branch `worktree-equal-card-heights`, HANDOFF "Cards drawn
  the same height in a row"; plan and ledger `docs/plans/2026-10-20-equal-card-heights*`):
  - **Code:**
    - `style/shares.ts`: `drawnLines` / `evenLines` (items share a line when their drawn boxes overlap up and down; a
      row that doesn't wrap is one line; even within 2px; `gridStretches` uses it), `rowEven` (a row of boxes holding
      layers, each line even; never texts, pictures, Buttons, button-like or round boxes, turned layers, art groups,
      a baseline row, a list's or a marquee's rows), `stretchesItems` (at `style.ts`'s three call sites);
    - `style/bottoms.ts` `sharedBottoms`: in a stretched line, hugging laid-out boxes alike in direction, top and side
      padding (1px) and paint share the smallest bottom padding, written in `Style.padding` so `space.ramp` steps it;
    - `style/layout.ts`: `flowStyle(…, fromTop)` drops a stretched hugging column's centre or bottom alignment;
      `innerPadding` moved here;
    - `adapt/layout.ts` `sidesAt`: the written padding plus the written outline (a CSS border inside the box), so
      the room it plans is the CSS content box.
  - **Tests:** `style-shares` (16), `style-bottoms` (7), `convert-equal-cards` (3), `adapt-layout` (2 new),
    `style-layout` (1 new), browser `equal-cards` (2); fixture `test/fixtures/equal-cards.ts` (26 variants).
  - **On the user's files:** hydraulics' Info cards one height at 1728, 1440, 990 and 700 (352.7px each at 1728; main
    312 / 362 / 337), bottom padding 30 on all three; stats strip, footer pair, Services' reviews and the Repairs
    footer pair even too; footer link columns share bottom 14 (0 on Repairs); the Repairs product words centred.
  - **Corpus:** lint errors no worse anywhere (final-design 18 → 17), hydraulics 0.4968 → 0.5177, the rest within
    noise; worse than v1 18 → 17. GRO byte-identical.
  - **My rulings, not yet confirmed:** a button-like box and a round box never stretch with their row; a stretched
    column keeps space-between; a stretched row-direction box keeps its centring; any row of boxes stretches, header
    bars included (final-design's logo group 1px taller); the Repairs product photo is its own height, centred, below
    1440.
  - **Follow-ups:** link-hrefs' three panel tests (above); ~~`space.ramp` writes no side where a phone's padding goes
    back to the drawn one~~ (fixed for upright phones in 21.4, phone side padding); `style.ts` is 353 lines; the
    footer's Opening Hours card keeps its 115px bottom.
  - Not yet pasted by the user (3ab).
  - **Equal card fixes** (build `2026-10-21.7`, branch `worktree-equal-card-fixes`, HANDOFF "Equal card fixes (recheck
    R1–R7)"; plan and ledger `docs/plans/2026-10-21-equal-card-fixes*`; Justin's Q1A, Q2A): `bottoms.ts`
    `spaceFallsBelow` trims a box only where the freed space falls under its content (a column unless space-between;
    a row only with its items at the top and not wrapping: CSS shares a wrapping row's extra height between its
    lines, review F1); `contentSetsHeight` (hug, no min height holding it open past 1px) gates the trim and `style.ts`
    `fromTop`; `adapt/rules/rows.ts` `row.reflow` sets `flexGrow: 0` on a stacked row's item that keeps its size at the
    first stacked tier (a 64×64 photo stayed 64×116); every untested guard tested, dead guards deleted. Justin's pages
    and the corpus pastes byte-identical except design's one Button `_flexGrow:tablet_portrait 0`; no paste check owed.
    R5 (the layout plan's room for an outlined 0-padding box) and the reviewer's twoShare / reflow flex-grow items are
    layout-floors'.
  - **CTA label wrap** (build `2026-10-21.8`, branch `worktree-cta-label-wrap`, HANDOFF "Button words that wrapped in
    narrow cards"; plan and ledger `docs/plans/2026-10-21-cta-label-wrap*`; W1A confirmed by Justin, W2A W3A):
    `adapt/least.ts` (`buttonLike`, the one-line width a layer needs per tier, `floored`: CSS holds a button only with
    a stepped min-width or no clipping / min-width-0 box around it); `layout.ts` keeps a row only while each item holds
    its buttons (alike cards stack, never one left alone; "two" stacks where a half can't hold its button; a held button
    leaves the others their 200px; alike pills wrap, never the cards stack); `rules/label.ts` `label.oneLine` writes
    `white-space: nowrap` per element (`_cssCustom`); `unpin` lets a button's floor go only to its line. Hydraulics
    "Call Us Now" one line at 768–480. **Still broken (handed to pill-clip):** the design's service pills wrap on
    laptops (1200). Rulings not yet confirmed: drawn fields still count as buttons (F7); per-element custom CSS kept
    (F9). Paste check **3ai** owed.
- **Fonts cleanup, stage 1** (build `2026-10-21.6`, branch `worktree-fonts-cleanup`, HANDOFF "Fonts cleanup, stage 1";
  plan and ledger `docs/plans/2026-10-21-fonts-cleanup*`):
  - **Scope:** Justin's 1B/2A, then "As for the font stuff tell it to move on": items 2/3/4 only; item 1 (fonts loaded
    twice) deferred, needs a live paste proof. The plugin's Google loader stays.
  - **Code:** `ui/font-coverage.ts` shares usable-source/weight-range/slant coverage; `site-fonts.ts` `addFonts` skips
    covered drops; `font-sources.ts` uses the same coverage for the rows and CSS, and names only alternatives the
    selected site CSS or confirmed Google faces supply. `fonts.ts` returns deduplicated family/weight/slant/source
    metadata; `run.ts` carries it to the notes. No `src/core` change, no new availability probes, no substitution, no
    site writes or deletions.
  - **Coverage:** a static inside a usable same-family/slant variable range (inclusive) is skipped; a dropped variable
    needs one existing usable variable covering its whole range. Isolated statics or partial overlap never cover a
    variable. POSTs 1→0 for a static 500 under a 100–900 variable.
  - **Notes:** e.g. "This paste supplies 400 and 700 in that style; the browser chooses a substitute. Your site's font
    settings may add other weights." Unknown: "No replacement weight is confirmed; the browser may use another font."
    **My ruling, not yet confirmed:** Google off keeps its explicit "not checked" rows.
  - **Weights protected:** an element's own or imported-class Figma weight wins over body 800; generic tests cover
    400/600/700, local overrides, Button, text link, mixed runs; Chrome 360/700/960/1360. Repairs (106) and
    Hydraulics (202) text elements: none without an effective own or class weight.
  - **Review:** fresh Sol reviewer's R1 (medium, test-only) fixed test first: the normal Google stand-in answers HTTP
    200 without the missing weight; a forced HTTP 400 is labelled failure injection. Corpus pastes byte-identical.
  - **Still open:** F1 (HTTP-200 partial Google answers counted complete); item 1; stale panel tests (test-cleanup).
  - Not yet pasted by the user (3ah).
- **Words linked to another frame** (build `2026-10-21.5`, branch `worktree-frame-text-links`, HANDOFF of the same
  name; plan and ledger `docs/plans/2026-10-21-frame-text-links*`):
  - **The ask:** in Figma, words can link to a web address or to another frame; frame links were dropped, so the
    words came out plain in Bricks. Justin chose F1A (no page yet: the guessed address, noted by the site check), F2A
    (a part of a frame: its top frame's page), F3A (a deleted frame: plain words, named).
  - **Code:** extract `plugin/extract/link-frames.ts` (snapshot `linkFrames: { <id>: { frame, inside } }`, the layer
    under the Figma page, the file or a canvas section); `normalise/text.ts` `hyperlinkOf`/`frameLink` (`Run.linkFrame`;
    notes `goneFrameNote`, `unnamedFrameNote`, `partFrameNote` in `normalise/links.ts`, the part note naming no
    address); `emit/page-addresses.ts` `runLinks` (`PageAddress.runs: [{ id, at }]`, the link's place among its
    text's `<a>`s; the front page and typed addresses never listed); panel `ui/site-pages.ts` `relink` (a text's
    listed links, last first) and `ui/text-links.ts` `relinkText` (changes a link only while its href is still the
    conversion's; a function replacement, so a `$` in an address is written as it is).
  - **Rule:** every link kind (an element's link or a text run's) goes through `emit/page-addresses.ts` and
    `ui/site-pages.ts` `relink`; addresses typed in Figma are never changed.
  - **Behaviour change, not yet confirmed by Justin (review F4):** frame-linked words count as the designer's link,
    as typed-address words already did: a card whose title or "Learn more" carries one gets no whole-card link, a
    painted pill whose label carries one is a Div with a linked text (not a Button), and a Call/Email button whose
    label carries one keeps it instead of the nearest number. Kept; reversing it for both kinds is its own fix.
  - **My rulings, not yet confirmed:** the new `linkFrames` key (not `targets`); the part note names the part and the
    frame, no address; a canvas section counts as a page holder; frame links in text are `from: "figma"` (no
    "make sure that page exists" note without WordPress, as Navigate links); a text's link found by its place.
  - **Checks:** check 1330, browser 131 of 134 (the 3 known stale panel tests); corpus pastes byte-identical to main
    (no corpus file has a text hyperlink), lint and the 17 items unchanged. Reviewed on opus (approve, 5 low), all
    fixed test first or recorded.
  - Not yet pasted by the user (3ag).
- **Phone side padding (2026-10-21, build .4, phone-side-padding):**
  - **The report:** the hydraulics homepage's three Info cards under the logo marquee had 17px sides on an upright
    phone; Figma has 30.
  - **The cause:** `space.ts` wrote nothing at a tier where a box's side goes back to its designed value, and Bricks
    cascades tablet → sideways phones → upright phones, so the sideways phone's squeeze (cards three across,
    `sideCap` 17) stayed once they stacked.
  - **Justin chose:** P1A, upright phones get Figma's padding on the space ramp, written; P2B, upright phones only
    (a tablet's squeeze carrying on to sideways phones stays: GRO's "Let's talk →" keeps 22 there, the only case in
    the corpus). His point: "padding must look clean on any layout".
  - **Divided rows (the review's F1, Justin's standing ruling: do it if small and general):** a row of unpainted boxes
    split by their own one-sided outlines (no line on the row's ends, none above or below; `adapt/divided.ts`), from
    the tier where it breaks: the lines go (row.reflow), each item's sides even out to the row's smallest on every
    narrower tier (space.ramp), the space the padding and lines made between two items' words becomes the row's gap
    both ways on the gap ramp, and in a row that wraps each item grows to share its line. v1 did this (research §6).
    final-design's stats: 2 + 1 with the third centred at 360–478, one centred column 479–768, no lines; hydraulics'
    4 stats under the hero lose their lines on tablets.
  - **Rule:** a tier that goes back to the designed value writes it explicitly (Bricks cascades landscape → portrait);
    space.ramp's margin and gap steps decide upright phones against tablets only, guarded by a test that nothing
    writes a landscape-only one.
  - **My rulings, not yet confirmed:** a wrapping divided row shares each line (its lone last item sits centred); its
    gap is the space its padding and lines made, stepped (48 tablets / sideways phones, 32 upright for final-design).
  - **Checks:** corpus lint and the 17 "worse than v1" items unchanged; pastes change only in 14 upright-phone paddings
    (each its own Figma sides) and the two divided stat rows. check 1309, browser 131 of 134.
  - **Follow-ups:** the layout plan still counts a divided item's drawn sides after its row breaks (safe, low); a phone
    number in running text wraps at its inner space (hydraulics' "Call Us Now" card at 452–478).
  - Not yet pasted by the user (3ae).
- **Line breaks that only copy Figma's wrap** (build `2026-10-21.2`, branch `worktree-early-line-breaks`, HANDOFF of
  the same name; plan and ledger `docs/plans/2026-10-21-early-line-breaks*`):
  - **Code:** `style/rag.ts`: `ragBreaks` (the old `text.breaks` test: body ≤ 24px, no heading, no blank line, v1's
    rag), `softBreaks` (not hugging its words + prose + `copiesWrap`, the letters to spare: ≤ `FONT_SLACK` 1 on the
    longest line, ≤ `GUESS_ERROR` 0.1 × guessed letters on a shorter one); `typography.ts` `textHtml(…, soft)` writes
    a space and drops the next line's typed spaces; `style.ts` never holds a soft text as typed lines;
    `adapt/rules/breaks.ts` runs only for hug texts whose words aren't replaced.
  - **Tests:** `adapt-breaks.test.ts` (13, the boundaries pinned by mutation); `pages.ts` `pairPage`'s paragraph hugs
    its words; `faq.ts` takes an `answer`.
  - **On the user's files:** hydraulics' Info cards 3 lines at 1728 (main 4 with `hurry? Give` and `Copco in` alone),
    the same as main at 1440 and 390; design's footer address and the inspo file's "…growth⏎shouldn't live…" keep
    their breaks as on main.
  - **My rulings, not yet confirmed (under Justin's auto-go):** the letter count; prose only (an address with "St."
    counts as prose); a Truncate box counts as fixed width; a soft text gets Figma's line length.
  - **Follow-ups:** `style.ts` 356 lines (test-cleanup's split).
  - Not yet pasted by the user (3ad).
- **Site fonts kept per family** (build `2026-10-21.1`, branch `worktree-emergency-cta-width`, HANDOFF "Fonts from
  the site's library mixed between families"; plan and ledger `docs/plans/2026-10-21-emergency-cta-width*`):
  - **Code:** `src/ui/site-fonts.ts` `readAll` (any WordPress list, 100 at a time, ending at a short page or
    `rest_post_invalid_page_number`; families and faces share it), `isOwn`/`facesOf` (`_fields:
    id,parent,font_face_settings`; a face is the family's when its `parent` is the family's id, or, answered without
    `parent`, when its own `fontFamily` names the family).
  - **Stand-ins:** `test/fixtures/panel.ts` `siteFaces` and the browser `panel.test.ts` `fontLibrary` answer as
    WordPress does: every face of the site under any family, newest first, each with its `parent`, `per_page`/`page`/
    `_fields` honoured; `noParent` drops `parent`; a face keeps its own posted `fontFamily`.
  - **Tests:** `ui-site-fonts` (own faces only; the parent wins over a face's own font family name; no `parent`; more
    than 100 faces; a drop only another family has goes up), `ui-font-sources` (`siteFaceCss`, `fontPlan`), `ui-run`
    (a connected Convert with two site families). All fail with main's `site-fonts.ts` or under a mutation.
  - **Proof** (stand-in rebuilt from the live `post-10.min.css`): Archivo 13 mixed files → its 3 own; Archivo 500 and
    800 come from Google, as Figma draws them.
  - **My rulings, not yet confirmed:** a face without `parent` is matched by its `fontFamily` name; faces are read per
    family, so it stays right on a WordPress that does filter by parent.
  - **Follow-ups resolved:** covered static uploads are skipped by shared usable-source/family/slant/range coverage
    in 21.6 (fonts-cleanup); Saira Condensed Thin/ExtraLight 250/275 was fixed in 21.3.
  - Not yet pasted by the user (3ac: the 8 pages again).
- **A picture frame's faint outline over a photo** (build `2026-10-22.10`, branch `worktree-photo-frame-outline`,
  HANDOFF of the same name; plan and ledger `docs/plans/2026-10-22-photo-frame-outline*`): see "Start here".
  - **Code:** `normalise/photo-frames.ts` (`leaveFaintFrames`, wired in `normalise.ts` with a per-layer set of videos
    the panel looks up); `photoPaint` moved to `normalise/paints.ts`. Fixture `test/fixtures/photo-frames.ts`, test
    `normalise-photo-frames` (the paste equals the one with the stroke deleted, every guard's boundary).
  - **My rulings, not yet confirmed:** the 20% / 2px / 90% / 10% / 80px limits; a video counts as a photo; a framed
    photo that is a link still loses it; one note per box.
  - **Deferred:** a photo inside a masked group isn't seen (outline kept); a big transparent PNG counts as a photo
    (no pixel data); `itemReverseZIndex` ignored as everywhere.
  - Not yet pasted by the user (3bh).
- **Space under an open FAQ answer** (build `2026-10-26.1`, branch `worktree-faq-answer-space`, Mini pipeline,
  HANDOFF of the same name; plan and ledger `docs/plans/2026-10-26-faq-answer-space*`): see "Start here".
  - **Code:** `understand/accordion.ts` `spaceUnder` (the space drawn under a fixed-height answer box's layers, 0 for a
    box painting its own or holding a placed layer) and `underAnswers` (the item Content's bottom padding, the answer
    box hugging its words). Tests `understand-answer-space`, `emit-accordion` (AC1, AC5), browser
    `faq-answer-space` (AC2–AC4 and the painted / outlined / padded / pinned variants), `corpus-faq-answer-space`
    (AC6); fixtures `paddedAnswer`, `pinnedAnswer` in `test/fixtures/faq.ts`.
  - **Deferred:** an item frame drawn fixed-height with the space under its answer; a fixed-height text answer taller
    than its lines; a painted or placed-layer answer box keeping its space on phones; the same frozen space outside
    FAQs.
  - Not yet pasted by the user (3bl).
- **Flip cards** (build `2026-10-28.1`, branch `worktree-flip-cards`, full pipeline, HANDOFF of the same name; plan
  and ledger `docs/plans/2026-10-26-flip-cards*`): see "Start here".
  - **Code:** new `understand/flip.ts`, `style/flip.ts`; the mark in `normalise/{scene,notes,hover,normalise}.ts`;
    `understand/overlay.ts` `variantCopy` (shared by hover layers and backs); `ir.ts` `faceOf`, `linksHere`,
    `linkFrom`; `adapt/least.ts`, `adapt/hero-pair.ts`; `emit/elements.ts` (`tabindex`), `emit/page-addresses.ts` (a
    back's link listed for the site check), `emit/payload.ts` (no nested-link refusal);
    `understand/{phone,lists,list-links,list-rows,showcase,recognise}.ts`.
  - **Tests:** `normalise-flip`, `understand-flip`, `emit-flip`, `flip-guards`, `emit-nested-links` (helper
    `test/fixtures/nested-links.ts`), browser `flip-cards`; fixture `test/fixtures/flip-cards.ts`. `chrome.ts`
    `Page.touch` / `Page.tap` drive a touch screen and a finger's tap: never `Input.synthesizeTapGesture`, which sends
    no mouse events headless.
  - **Deferred:** a divided row of flip cards; Safari's composited children; Figma text properties; a flip on click.
  - Not yet pasted by the user (3bn).
- **Paste checks:**
  - **WordPress pictures** (2026-10-07, build .19): the user's run worked; photos and icons show on the saved page.
    The descriptions list is not yet tried.
  - **M1b desktop** (2026-10-07): final-design matched at desktop.
  - **M2a–M2c on the user's phone** (hydraulics): "nothing looks wrong. Slider work and look great."
- **Open:**
  - **M2d, the phone menu,** waits for the user's **Nav (Nestable)** sample. The first time, the user pasted the
    card/slider sample by mistake; the right copy contains `nav-nested`.
- **M4a** (HANDOFF "M4a"): headings with one h1 and no skipped levels, stacked title pieces as one heading, alt text
  sent with each WordPress upload, focus ring, reduced motion.
- **M4b** (HANDOFF "M4b"): Figma Motion as CSS keyframes. It is built against Figma's typings (no corpus file has
  Motion), so it needs the user's Motion test file.
- **Next:** the user's end-of-run check (HANDOFF "End-of-run check list", now with GRO on a phone). After that come
  the sample-bound parts: M2d phone menu, Tabs, Dropdown, Offcanvas and pop-ups.
- **Waiting for the user's Bricks samples:** Tabs, Dropdown, Offcanvas + Toggle, Nav (Nestable) for the phone menu,
  a working Interaction, and a `popover` Div. Never write those emitters from memory.

v2 is a clean rewrite of v1 (`~/Desktop/figmaplugin`, read-only reference). The approved design is
`docs/specs/2026-10-06-v2-design.md`; read it before changing the architecture. v1 is the reference for **rules it
learned**, never for its code structure.

## Build general logic, never one-file fixes

This plugin converts **any** Figma file into Bricks, not only the design in front of you. It is used across many
different files by many different designers. Treat every request (a new feature, a bug report, "this section looks
wrong") as one example of a whole class of designs, and change the logic so the entire class converts correctly.

- **Fix the rule, not the instance.** When something converts wrong, work out why the logic produced that output and
  change the logic. Don't patch the result for the one file that showed the problem.
- **No hardcoding from the file under test.** Don't key behaviour on a specific layer name, node ID, text string, pixel
  value, colour, font or section order taken from the design you were shown. Detect patterns from structure and
  properties instead: auto layout, constraints, fills, sizes relative to the parent or frame, repetition, clipping.
  Layer names are a hint at most, never the only way a feature is recognised; many designers never rename layers.
- **Think about the variations before you write code.** Ask what other designs will reach this code path: other frame
  widths, deeper or shallower nesting, missing or extra layers, mixed auto layout and absolute positioning, groups
  instead of frames, other breakpoints, empty or very long text. Handle them, or fall back to safe output.
- **Don't regress other files.** Fixing one design must not break another. Run `npm run check` and add a test
  for the new pattern, built as a generic fixture rather than a copy of the user's file.
- **If a special case is truly unavoidable, say so first.** Explain why the request can't be generalised and ask
  before adding a targeted exception. The exception must detect a condition that could occur in any file, never
  a particular file.

## Architecture rules (from the design; don't break them)

- **Pipeline:** `extract → normalise → understand → style → adapt → emit`.
  - Only `src/plugin/extract/` calls `figma.*`.
  - Everything in `src/core/` is pure and runs in Node on a Snapshot (the debug file).
- **No stage edits an earlier stage's output.** No element changes type after it is made, and no content is converted
  twice. If a later stage needs something, the earlier stage that knows it must record it in its output.
- **CSS stays typed** (`{bp, state, part, decls, origin}`) until `emit` serialises it once.
  - Never regex or string-match CSS.
  - A value that has a Bricks control goes in that control's key; the rest goes in one `_cssCustom` per element.
- **Only `src/core/adapt/rules/` writes breakpoint styles.** Every declaration records which rule wrote it. Two rules
  writing the same node, breakpoint and property fail a test unless one lists the other in `overrides`.
- **Rules read sizes from the page scales** (`PageFacts`); they never multiply numbers themselves.
  - Each rule is one file in `src/core/adapt/rules/` with a `decision` line saying which user rule or spec line it
    carries out.
  - `RULES` (`rules/index.ts`) runs in order: a rule that overrides another must come after it.
  - A rule writes only what changes at a breakpoint, never the desktop value. The one exception is the `fluid` tier
    (below the design width, above tablets): emit folds its values into the desktop value as a `clamp()` exact at
    the design width, and puts its custom CSS in `@media (max-width: W−1px)`.
  - Widths at a tier come from the layout plan (`ctx.layout`, `src/core/adapt/layout.ts`): each layer's room and
    width, each row's shape and each grid's columns. Rules read it; they never estimate widths themselves.
  - A flip card is judged by its front (`ir.ts` `faceOf`, shared by `recognise.ts`, the layout plan, `adapt/least.ts`
    and `hero-pair.ts`): anything reading a layer's room or kind reads the front; its back adds nothing.
  - Shared behaviour goes in one purpose-named class the style stage makes and a rule fills: `text-balance`,
    `text-pretty` and `tap-area` are the plugin's own.
  - A design drawn for phones (selected beside the desktop one) runs only the rules marked `fits` (they keep a
    drawing whole around its width) and `shows` (the swap). The engine drops the desktop copy's phone-tier writes
    then. A new rule that only keeps shapes or lines whole sets `fits`. `ctx.design` says which design a rule is
    running on; `drawn.scale` runs only on the phone design.
  - Phone-only copies (sliders, the hero's buttons band, intro buttons) are made only at understand
    (`src/core/understand/phone.ts`, keys `copy:<purpose>:<key>`), never by a later stage. `phone.swap` shows them
    and hides their originals at `mobile_landscape`.
- **Breakpoints, media queries and gutters are defined only in `src/shared/breakpoints.ts`.**
- **Ids are deterministic** (a hash of the IR key). The same snapshot must give a byte-identical payload.
- **Keep files small and single-purpose.** If a module grows past roughly 300 lines, split it by responsibility.

## Working in this repo

- **Git, with a private GitHub copy** (user, 2026-10-19; this replaces the earlier "no git"):
  `github.com/Just-In-N-Out/FigmaToBricksV2`, branch `main`. The main folder stays on `main`, and it's the copy Figma
  loads (`manifest.json` → `dist/`).
  - **Never commit CLAUDE.md:** it's listed in `.git/info/exclude`. Check `git diff --cached --name-only` before every
    commit.
  - **Commits:** plain `git commit -m "…"`, with no `Co-Authored-By` or AI lines and no author override.
  - **Pushes go as Just-In-N-Out** through this repo's own credential helper (`.git/config`, a `gh auth token --user
    Just-In-N-Out` call). The Mac's active `gh` account is Justin-Leorna, used by other projects: never switch it, and
    don't change the remote or the helper.
  - **Not in git (rebuilt by tools):** `node_modules/`, `dist/`, `corpus/out|paste|compare/`, `corpus/report-v2.json`.
- **Every bug or feature runs the orchestrated pipeline** in the first section of the global `~/.claude/CLAUDE.md`
  (user, 2026-10-23). The session only orchestrates: fresh Opus 5.5 xhigh `general-purpose` agents plan, build,
  review, fix, verify and audit, and `ac-check.sh` decides when every AC is accepted. Never plan, build or review in
  the session itself. This repo's specifics:
  - **Start:** in a terminal in the main folder, `claude -w <feature-name>`. Claude Code makes
    `.claude/worktrees/<feature-name>` on branch `worktree-<feature-name>` and copies in what `.worktreeinclude` lists:
    this file, `node_modules/` and v1's corpus output. That session is the feature's orchestrator, and its agents work
    in the copy. Several features at once (user, 2026-10-19: "run multiple agents to do multiple features") means
    several such sessions, one feature each, so no agent sees another's half-done work.
  - **Plan approval: the user's standing auto-go for this repo** ("no stop between plan and run"): show the plan
    message (questions with ⭐ answers, proposed and `(live)` ACs) and dispatch the builder at once, taking the ⭐
    answers, unless the user replies **stop** or changes something. Make the plan's read-only copy first, as the
    global step 3 says: `mkdir -p <evidence> && install -m 444 <plan> <evidence>/plan-approved.md`.
  - **Rules for every agent in a copy:**
    - Run `npm run check` and `npm run corpus` there.
    - Commit to the branch after each passing task. The branch stays on the Mac: don't push it to GitHub (user,
      2026-10-19: merges are local).
    - Don't bump `BUILD`, and don't edit the main folder.
    - Don't edit the copy's CLAUDE.md: it's a snapshot from the start, deleted with the copy. Status notes go in
      `docs/HANDOFF.md` and the ledger, which are in git.
    - Never use bare `git stash`: the stash list is shared by every copy.
  - **Finish, once `ac-check.sh` says ALL ACCEPTED or READY FOR THE USER** (no need to wait for the user):
    1. **Finisher agent, in the copy:** commit everything, then `git rebase main`. On a conflict keep both sides'
       meaning; HANDOFF sections usually both stay. Run `npm run check` and `npm run corpus` again on the rebased
       branch: two features that pass alone can break together. It stops and reports the new HEAD. If HEAD now
       differs from the head `ac-check.sh` accepted, the AC receipts no longer match: the session runs verifier → auditor →
       `ac-check.sh` again on the new head before step 2 (agents don't start agents).
    2. **Session: leave the copy.** Call the ExitWorktree tool with action `"keep"` (the user's standing permission).
       Claude Code refuses git commands and edits aimed at the main folder from inside a copy (`git -C …`
       included), so the merge runs from the main folder. If ExitWorktree finds no worktree session, EnterWorktree
       with `path` set to the main folder; only if both fail, give the user the one `!` merge command and say why
       (global CLAUDE.md "Worktrees from `claude -w`").
    3. **Session, in the main folder:** `git merge --ff-only worktree-<feature-name>`. If it refuses, main moved (go
       back into the copy with EnterWorktree and its `path`, repeat from 1) or the main folder has uncommitted
       changes (stop and tell the user). Never force it.
    4. **Finisher agent, in the main folder:** bump `BUILD` (read it first), `npm run build` (Figma loads that
       `dist/`), commit "Build <BUILD>: <feature>" and `git push` (`main` only). Update the main folder's CLAUDE.md
       ("Start here" and "Where things stand"), since it isn't in git.
    5. **Session:** check that `git log --oneline main` shows the feature's commits, then tell the user it's merged,
       naming any `(live)` ACs owed to them. When they close the session, Claude Code offers to delete the copy; the
       branch goes with `git branch -d`.
  - **Choose features that touch different parts** (different stages or rules). Two or three at a time; more makes
    merges harder.
  - **A quick fix the user asks to do right here** (no pipeline, a session started without `-w`) is committed
    straight to `main`, by file, before the next merge.
- **Setup:** TypeScript + esbuild. Dev dependencies only: `typescript`, `esbuild`, and the type packages
  `@figma/plugin-typings` and `@types/node`. No runtime dependencies; the browser tools use Node built-ins and the
  system Chrome.
  - `npm run build` writes `dist/code.js` and `dist/ui.html`, which `manifest.json` loads.
  - `npm run watch` rebuilds while you work.
- **The panel** (`src/ui/`): DOM-free modules plus `main.ts`. Browser features (fetch, image decoding, canvas, Web
  Workers) go through `src/ui/env.ts`, so tests stand in for them (`test/fixtures/panel.ts`).
- **The plugin's conversion** (`src/plugin/convert.ts`) must stay byte-identical to `npm run replay` for the same
  snapshot (`test/unit/plugin-convert.test.ts`).
- **Checks:** `npm run check` runs typecheck, build and the unit and rule tests. Tests use `node --test` on `.ts` files
  directly (Node 22 type stripping), so use only erasable TypeScript syntax: no `enum`, no `namespace`, no parameter
  properties.
- **Build number:** bump `BUILD` in `src/shared/build.ts` (`YYYY-MM-DD.N`) for every change the user will load in
  Figma. Read the current value first, because another session may have bumped it. In an agent's copy, leave it: the
  merge into `main` bumps it ("Several agents at once", step 4).
- **Code Figma runs (`src/core`, `src/plugin`, `src/shared`) uses only the language's built-ins.** Figma's plugin
  sandbox has no `URL`, `URLSearchParams`, `TextDecoder`, `TextEncoder` or DOM. A web class inside a `try` fails
  quietly in Figma while Node tests pass (sandbox-urls). Use the pure stand-ins: `model/url.ts` for addresses,
  `plugin/extract/text.ts` `utf8` for bytes. `npm run typecheck` (`tsconfig.sandbox.json`) and
  `test/unit/sandbox-convert.test.ts` enforce it. When a live paste lacks what replay shows, diff the panel's copy
  (`pbpaste` right after Convert) with `npm run replay` first.
- **Figma's sandbox (SES) refuses to open the plugin** when `import` is followed by `(`, `//` or `/*`, or when `<!--`
  or `-->` appears anywhere, even in comments. `build.mjs` checks the bundle and fails on these; never end a comment
  line with the word "import".
- **Bricks swaps pasted pictures for its grey placeholder** unless the paste's `sourceUrl` is the site's own
  address (`bricksData.siteUrl`; read in Bricks 2.3.9's builder code, `reference/bricks/README.md` "Paste rules").
  Only `image`/`image-gallery`/`svg` elements whose image has an `id` are swapped. A paste with WordPress pictures
  must name that site (`siteAddress`).
- **A WordPress upload attached to no page owns the address `/<its file name>/`,** and since WP 6.4 that address
  redirects to the file. So the panel's uploads always end in `-image`/`-video`, and a link is never a picture or
  video file (`payloadProblems` refuses one). One attached to a page is at `/<page>/<name>/` instead.
- **A link never sits inside another link** (flip-cards, 28.1): the browser ends the outer link where the inner one
  starts. It is a test-only invariant (`emit-nested-links`: every fixture, the flip cards' linked shapes, every corpus
  page), never a paste refusal: a refusal broke pastes main made. Add every new link producer to that test.
- **WordPress's `font-families/<id>/font-faces` answers every face on the site,** whatever its family
  (`wp_font_face` isn't hierarchical, so the posts controller filters by no parent). Keep only the faces whose
  `parent` is the family (`site-fonts.ts`). A stand-in for WordPress answers as WordPress does, read from its code or
  a real answer, never from what the code expects.
- **A text's weight includes its imported typography class.** Resolve the element plus `_cssGlobalClasses` before
  saying a Figma weight is missing; never copy working class typography onto every element.
- **A usable same-family/slant variable face covers static uploads inside its range.** A dropped variable needs one
  existing usable variable spanning its whole range; isolated statics and partial overlaps don't count.
- **Font notes name the weights supplied, never promise the font the browser picks.** Keep Figma's family and
  weight; say "unknown" when no same-style source is confirmed. A Google stand-in answers like Google (HTTP 200 with
  a weight missing); a forced HTTP 400 retry test says it's failure injection.
- **Font weights in a paste are single whole hundreds.** Bricks copies every font weight it finds beside a Google font
  in the page, custom CSS included, into its one Google Fonts link (`bricks-google-fonts-css`). Google refuses the
  whole link (HTTP 400) for a range such as `100 900`, and every Google font Bricks loads on that page is lost
  (header, footer, Theme Style). Never write a weight range or a non-number weight in a paste.
- **Font weights the plugin uploads or reads are standard hundreds (100…900).** A file's in-between OS/2 weight
  (a Thin at 250) gives way to its style name.
- **Bricks' editor doesn't run a pasted Code element's script** (2026-10-22, read from the live page against the
  user's editor screenshot): the header spacer, lists and card arrows only work on the live page or Preview. The
  user's header template is being made sticky (HANDOFF check 3bi), so the editor shows the page below it too.
- **The user never tested v1's WordPress mode** (2026-10-07): v1 is no reference for uploads or the paste's media.
- **Bricks gives every Block `width: 100%`.** A layer that should size from `left` and `right` needs `_width: "auto"`;
  deleting `_width` isn't enough.
- **Layout keys depend on the element.** `_direction`, `_rowGap`, `_columnGap`, `_flexWrap` and the grid keys work only
  on section, container, block and div (`LAYOUT_ELEMENTS` in `emit/payload.ts`). Any other element's are
  `_flexDirection` and `_gap` (`reference/bricks/README.md` "Layout keys by element"). `payloadProblems` fails on the
  rest.
- **Never write Bricks' `_alignSelf: "stretch"`.** Bricks adds `width: 100%` to it, after the element's own width
  (`reference/bricks/README.md` "Align self: stretch"). A row whose items all fill its height, or whose boxes are drawn
  the same height, uses `_alignItems: "stretch"`; any other stretch goes in custom CSS (`emit/settings.ts`).
  `payloadProblems` fails on it.
- **Figma's switched copies pair layers by name.** They carry text into a same-named layer of the other variant (a
  description pushed into a title), so only the words an instance really changed count.
- **Bricks element shapes come from `reference/bricks/*.json`,** canonical samples the user copied out of their Bricks
  install. Write native-element emitters against those samples, never from memory. Re-capture them when Bricks is
  upgraded.
- **How each milestone runs** (2026-10-23: the orchestrated pipeline above replaces the single-session
  `superpowers:writing-plans` flow):
  1. The planner agent writes the plan in `docs/plans/<date>-<name>.md` (in git; this repo's plans don't go to
     `~/.hermes/plans`), with numbered AC1, AC2… and one test each (`implementation-planning`).
  2. The user wants no stop between plan and run: the builder starts right after the plan message (auto-go above).
     It builds test first, with a ledger in `.superpowers/sdd/<plan>/progress.md`.
  3. The builder runs `npm run corpus` before Task 1, and again at the close.
  4. Two fresh Opus reviews with a fix pass after each (each fix test first), then the verifier, the blind AC auditor
     and `ac-check.sh`, looping until every AC is accepted (global CLAUDE.md step 5–6). Evidence goes in
     `~/.hermes/plans/figma-to-bricks/evidence/<name>/`.
  5. The finisher moves the ledger to `docs/plans/<plan>-ledger.md`.
  6. The session reports every ruling and deferred minor to the user in plain words.
- **The review diff comes from git:** `git diff main...HEAD` in an agent's copy, or `git diff <commit before the
  milestone>` on `main`.
- **Test fixtures built from one column inside a section can surprise you.** A section's only child that spans it
  becomes the section's Container (or a band when painted), and its label disappears. Give such fixtures a sibling
  (a text above) when a test looks the box up by label. An auto-layout `column`/`row` fixture hugs its flowing
  children: a wrapper holding an absolute layer needs its own width and height, or it is only as wide as its words.
  Texts in the scene carry no fills (their colour is in the text data), so a "painted" check never counts plain words.
- **Shell quirk:** typing the escape text for U+2028/U+2029 in a shell command turns it into the raw character, which
  breaks regex literals. Write such escapes with `String.fromCharCode(92)` or edit the file with the Edit tool.

## Debugging a user's design

- **Ask for a debug file** (the panel's "Save debug file"): `figma-to-bricks-debug-*.json`. Check its `build` and root
  frame name first, because users re-save it from other pages and builds. v1 debug files load through
  `src/core/snapshot/upgrade-v1.ts`.
- **Inspect:** `node tools/inspect.ts <debug.json> [outDir]` prints what the file holds and writes Figma's pictures.
- **Replay (from M1):** `npm run replay -- <debug.json> <outDir>` writes `bricks.json`, the warnings and Figma's
  renders.
- **Browser check:** `npm run snap -- <debug.json> <outDir> [widths] [--sides] [--detail] [--placeholders]` renders the
  payload the way the user pastes it (pictures inside, vectors as their own SVG, photos as stand-ins). For each width
  (390, 768, 1024, 1440 and the design width) it prints each section's height against its Figma frame and the lint,
  and writes a shot. `--sides` writes Figma-vs-built pictures of every section at the design width.
  - It drives the system Chrome over CDP (`test/browser/chrome.ts`), so viewports are exact at any width.
  - The layout lint (`test/browser/lint.ts`) reports overflow, clipped or overlapping text, tiny type, distorted
    pictures and content missing on phones.
- **Corpus:** v1's three real debug files plus the hydraulics page and the GRO homepage (v2 files in `corpus/files/`;
  GRO is drawn entirely without auto layout, at 1440); paths in `corpus/corpus.json`. Never hardcode anything from
  these files.
  - `npm run corpus:baseline` records v1's numbers in `corpus/baseline.json`, with shots in `corpus/out/v1/`. v1
    can't read v2 files, so hydraulics and GRO have no v1 numbers.
  - `npm run corpus` runs v2 and prints lint errors and warnings per width. It fails when any width is worse than
    the baseline; until M2 is done, phones are expected to be worse than v1.
  - Re-record the baseline whenever the lint changes, so both sides are measured the same way.
- **Prove a new test catches the bug:** with the fix committed, `git checkout HEAD~1 -- <the fix's source files>`,
  check that the test fails, then `git checkout HEAD -- <those files>`.
- **Before saying it's fixed:** replay the user's file and look at it at every width, check the lint report, and run
  `npm run corpus` to make sure the other files didn't get worse.
- **Phone checks for the user:** put the paste file on their clipboard with `pbcopy < corpus/paste/<design>/bricks.json`.
  Then give one action at a time (paste into an empty page, Cmd+S, preview narrow), and say that the photos in replay
  files are grey stand-ins; real photos come from running the plugin in Figma.
- **The renderer only approximates Bricks.** The live page is the final judge. User screenshots are usually the Bricks
  editor, where clicks select elements, empty elements get a 90px minimum size, and stacking can differ from the
  front end. The editor may not draw some placehold.co stand-in photos (a different set on each load); check the
  saved page's preview before blaming the layout.

## Decisions the user made (don't reverse without asking)

- **Interactions use native Bricks elements** (2026-10-06, replaces v1's radio/`:has()` CSS approach).
  - Use Nav Nestable with its own mobile menu, Accordion and Tabs Nestable, Slider Nestable, Dropdown and Offcanvas.
  - Use CSS only for hover and motion.
  - Pop-ups: Bricks pop-ups are templates and can't be pasted. Use the HTML `popover` attribute once the round trip
    proves Bricks keeps it, Offcanvas for drawers, or Bricks Interactions.
  - **Hover:** exactly as in Figma; on phones a tap does the hover. **Except call-to-action buttons** (below).
  - **Motion:** plays when scrolled into view.
  - **Only Figma's animations** (2026-10-01): convert what the design sets up, faithfully (entering and leaving). Never
    invent motion the design doesn't have: no automatic scroll reveals, hover lifts or added transitions. The
    exceptions are call-to-action buttons, product and team cards, logo marquees and flip cards (below).
  - **Flip cards** (user, 2026-10-26: bdryswi.com's service cards, as a general feature; build `2026-10-28.1`; the ⭐
    answers Q1A–Q5A under the auto-go, not yet confirmed):
    - **Only where the designer marks it:** a component whose front has While hovering → Change to its back variant,
      with a Figma annotation `flip` (`flip left` / `up` / `down`) on the set, the main component or an instance.
      Unmarked hovers stay as they are; Figma's own timing is the turn's.
    - **The card turns over** under the pointer, on Tab and on a tap (CSS only: a tap turns it, the next opens the
      back's link, a tap elsewhere turns it back); less motion swaps the faces without turning.
    - **A card that is a link** puts the link on its back; the back's own links stay live.
    - **As tall as its taller face** on every screen, never growing on hover; laid out as the same card unmarked.
    - **Never a product card, a hover layer or a CTA** itself (its back's Buttons are CTAs).
  - **Logo marquees** (user, 2026-10-19: "this marquee … the logo needs to be going from left to right"; build
    `2026-10-19.14`): a row of logos or short words running past the box that clips it moves in an endless loop.
    - **Toward the right**, at medium speed (60px a second, v1's).
    - **It keeps moving under the mouse**, and in one line on tablets and phones (the space between logos narrows).
    - The user chose these four in a question; v1's marquee (`~/Desktop/figmaplugin` README "Video and logo marquee")
      was the guide for the rest.
  - **Call-to-action buttons** (user, 2026-10-19: "make it so that call to actions button do not have a hover
    affect", then "i want CTA button to have this animation style all CTA" with their Bricks sample
    `reference/bricks/cta-button-interactions.json`; build `2026-10-19.8`):
    - **Every CTA button, in every design:**
      - a Button 32px or taller, or a painted pill;
      - not a tag in a row of three or more, nor a menu link;
      - copies included (`understand/widgets.ts` `markCtas`, `IRNode.cta`).
    - **Figma's hover is dropped:** its own and a card's hover around it.
    - **The `cta-motion` class:**
      - it rises 3px under the pointer (`_transform:hover`);
      - it fades in when the page loads (a Bricks Interaction: fadeIn 1.5s after 0.8s);
      - it shows the hand;
      - it stands still for reduced motion.
    - **Colours stay as drawn** (the user chose "Only the lift" over a darker shade or the sample's grey).
  - **Product and team cards** (user, 2026-10-19: "when it comes to media but not every media, just media when
    displaying a product or a team, I want this animation", their Bricks sample `reference/bricks/staff-card.json`;
    build `2026-10-19.9`):
    - **Which:** photo cards (words and a big picture), 2 or more side by side (`understand/showcase.ts`).
    - **Each card fades in on load**, as the CTAs do.
    - **Under the pointer** its photo grows to 110% over 0.5s inside its frame, and a glare crosses it once on each
      hover (the user chose once over nonstop).
    - **Figma's hover on such a card is dropped** (the user chose "New zoom + glare replace it").
    - **Reduced motion:** nothing moves.
    - **An Image photo is a `figure`** (the sample's key).
    - **Rows listing services or products** (user, 2026-10-19: "for media, when it's listing something or listing a
      product, there's that hover effect"; build `2026-10-19.11`): two or more photo/text rows (a zigzag) get the zoom
      and glare on their media when the pointer is on it. No fade-in for rows.
    - **Every listing's media** (user, 2026-10-19: "I want all images that involve listing a product or something get
      this animations"; build `2026-10-19.13`): a number or tag in the media box, over the photo or above it, doesn't
      stop the row counting.
    - **The user kept "any row of photo cards"** (2026-10-19), so team, product, service, blog and case-study cards
      all count.
  - **Sideways scrolling** (user, 2026-10-08, chose "Sideways scroll" over a pinned scroll or a slider with arrows):
    - A frame Figma's prototype scrolls sideways (`overflowDirection`), whose layers run past its edge, scrolls
      sideways on the site, gently snapping to its cards.
    - Its layers keep their drawn size on every desktop and tablet width.
    - On a desktop-only design's phones it is adapted like the rest of the page.
    - It is not a pinned scroll: that moves where Figma doesn't, so ask first.
    - **Card arrows** (user, 2026-10-08, "automatically assume if it has the arrow"; build `2026-10-08.5`):
      - **On the desktop design** (desktop and tablet), a card's arrow in a strip glides the strip to the next card.
        The last card's arrow goes back to the first, and at the strip's end an arrow goes back to the start.
        Swiping still works.
      - **Detected automatically,** with no Figma interaction needed: the card's one small icon, starting in its
        right half and ending in its right quarter, with no link or Figma click of its own, not in a Button or a
        hover component (`understand/arrows.ts`).
      - **A Code element** (the user's copy, `reference/bricks/code-element.json`) holds one script that finds the
        strip, cards and arrows by the classes `strip-arrows`, `strip-card` and `strip-arrow`. Bricks gives pasted
        elements new ids, so it names no element.
      - **The scrollbar** goes only once the script runs and every card but the last has an arrow.
      - **Pasted code runs only once Bricks has signed it** (Bricks → Settings → Custom code).
  - **Navigate:** goes to `/slug-of-frame-name/`; a frame named Home… goes to `/`.
- **On tablets, a grid of cards stays on one row rather than leave one card alone below the others** (user,
  2026-10-16: "the third form goes into a new line. I need them all horizontal").
  - `adapt/layout.ts` `gridColumns`, while each column gets 160px.
  - **Rows of alike cards too** (user, 2026-10-20, three reviews: "the third review shouldn't go on a new line … It
    compacts it a bit more, but it makes it look cleaner"): `decideRow` keeps 3, 5… alike cards on one tablet row while
    each gets 160px.
  - **Phones** (user, 2026-10-20: "if on mobile make them stack. for mobile landscape put all 3 in the same row"):
    held sideways (480–767) three alike cards or a grid's three cells stay one row while each gets 120px; upright
    phones stack them. So the narrowest tablets (768–880) stay three across too.
- **Other states of a component show the variant as designed.**
  - **Look comes from the variant:** fills, outlines, effects, corner radii, text colours and text styling.
  - **The instance keeps only its real content:** words and photos that differ from its own main component, layers it
    hides, padding and spacing.
  - **Colours changed on the instance for the page are not carried over,** even though Figma's prototype player and
    Figma's own switched copy carry them.
  - **Figma's switched copies** are used only for layout and for pairing layers.
- **Hover styles vs. states:** use CSS hover styles only where they draw the change exactly:
  - flat colours, outline colour, corner radii and shadows;
  - the text's weight, slant, spacing, case and underline, the same over the whole text.

  Anything else (a gradient, a photo, stacked paints, an icon's colour, a change of font or size) is built as states.
  Compare what shows: a colour by its value, a picture's placement to within a pixel.
- **Placed layers follow their Figma constraints** when the box isn't the design's width:
  - Center → `_left: calc(50% ± …px)`;
  - Right → `_right`;
  - Left & Right → `_left` + `_right` + `_width: auto`;
  - Scale → percentages.
  - **Figma's default Left on a layer in the right half** (2026-10-07, user): it stays against the right edge, keeping
    its distance to it, so it doesn't slide out when the box is narrower than designed. A layer deliberately pinned
    another way follows that constraint. At the design width nothing changes.
- **Stacking keeps Figma's layer order.**
  - Page content never rises above its section's level (z-index 1 at most).
  - A hovered component is contained with `isolation: isolate` and never gets a z-index, so a layer Figma paints above
    it stays above it.
  - Only floating layers go above the page: open dropdowns (50, lifting their ancestors while open), fixed layers (90),
    a sticky header (100) and pop-ups (9999).
- **Layout:** one Container per section, 1440px max with gutters 64 / 36 / 16. Bricks default breakpoints:
  tablet_portrait ≤991, mobile_landscape ≤767, mobile_portrait ≤478.
  - **Designs wider than 1440 keep the 1440 Container** (confirmed 2026-10-06, after M1b): their content is squeezed to
    1312 on desktop rather than kept at the design's width. A Figma wrapper's own max width still widens its Container.
  - **Boxes drawn the same height stay the same height** (user, 2026-10-20, "1A 2A 3B" then "4A"; build
    `2026-10-20.15`): in a row or a grid, boxes Figma draws the same height stay so (the row's Align items: stretch,
    never the item's Align self). A line is the items that overlap up and down. Boxes drawn at different heights keep
    their own heights at the top (16.3). A hugging box stretched this way keeps its words at its top. In such a line,
    alike boxes (same top and side padding, painted alike, hugging their height) share the smallest bottom padding
    among them, painted or not: space a website import froze in to fake equal heights goes, and the design width
    doesn't change.
  - **On screens wider than the design** (user, 2026-10-08, "this wave does not keep going throughout the screen"):
    - Content stays in the Container, centred.
    - A layer drawn across its section's whole width, or a band's (hills, a wave, stars, a painted bar), reaches
      both edges of the window (`style/wide.ts`, build `2026-10-08.6`).
      - It keeps its drawn height and place, so it never grows over words or buttons: a landscape stretches
        sideways (its SVG may: `preserveAspectRatio="none"`), and other art fills.
      - Layers holding words (a marquee, a captioned photo band) stay put.
      - A drawn phone design keeps its own rules.
    - **A live map drawn across its section's whole width** (user, 2026-10-23, chose "Edge to edge" over "Inside the
      page width"; build `2026-10-23.3`) touches both sides of the window on every screen, phones included: it goes
      beside the Container (`understand/section.ts` `mapAcross`).
  - **A photo behind a section keeps its drawn size on wider screens** (user, 2026-10-19: "His head should always show,
    and the full landscape should show regardless of zoom"; "I want it all to be kind of like the same thing"): it
    shrinks with the words when zooming out, in the middle, its edges fading into the section's colour (the user chose
    "Hero colour" over a blurred copy of the photo). This replaces build `2026-10-08.8`'s photos reaching the screen's
    edges; art (waves, hills) still does.
  - **Content Figma draws inside the 64px margin** (user, 2026-10-07; e.g. a sideways text at x=27): exact at the
    design width, hanging into the margin. From tablets down it sits inside the tier's gutter (36/16).
- **Faint outlines around pictures on a photo** (user, 2026-10-22: "a subtle white border outline around it … needs
  to be removed", then chose "Only over a photo" over "every faint photo frame" and "remove it in Figma"): a
  see-through box with a faint outline around a picture loses the outline only where it is drawn on a photo; boxes on
  plain backgrounds, filled cards and divider lines keep theirs, as drawn (`normalise/photo-frames.ts`).
- **Native Buttons by shape alone** (2026-10-06): a painted box around one short centred label becomes a Bricks Button,
  linked or not and whatever its name. Form fields (words starting at the left) and table cells (a rule on one side)
  aren't buttons. Tags and pills of the same shape may become Buttons; the user accepted that.
- **Pictures inside the paste (2026-10-07, v1's embed mode back):** the panel's "Pictures go: inside the copied JSON
  (for testing) / to WordPress" starts on "inside the JSON".
  - Inline, every picture (photos as chosen, shrunk to 2x the size they show at; icons as PNG or SVG) travels as data.
  - The choice reaches the conversion (`ConvertOptions.inlinePictures`): pictures are built as Divs with the picture as
    a CSS background (Bricks drops data from its Image element and background control), never swapped afterwards.
  - Each Div keeps the drawing's shape (`aspect-ratio`) and a picture's minimum width (`min(Wpx, 100%)`), and is pinned
    against the editor's 90px empty-box size.
- **Drawn phone designs** (user, 2026-10-08): designers sometimes draw the page twice, desktop and phone.
  - **Select both frames:** the plugin tells them apart by width (a frame 320–767 wide beside one 768+), and the
    panel names the split before Convert.
  - **Two copies, swapped at 767:** no layer matching, so a text edit is made in both copies.
  - **Tablets** get the desktop design adapted as usual.
  - **The phone copy** is as drawn: no automatic phone rules or copies, exact at its width, stretching with its
    drawn margins. A box of layers laid over each other (a title on its photo, a collage) keeps its drawn width and
    shrinks as one on narrower phones.
  - **Carousels** (user, 2026-10-08: "also should be a slider"): a row whose cards run on past the phone's edge is a
    Slider (Nestable), as the automatic sliders: one card per view, filling it, with dots (the drawn peek needs a
    slider sample with "slides per view").
  - **On search,** the FAQ schema goes on the desktop copy only.
  - **One frame selected** keeps the automatic phone version.
  - **Not built:** tablet frames and per-section fallback (the designers draw whole pages).
- **Phones and tablets are generated from a desktop-only design** (designers draw desktop only). Desktop must stay
  exact at the design width; below it the page is fluid, and the rulebook (`src/core/adapt/rules/`) adapts it. The
  user calls the hero "the header". Phone rules (2026-10-01, kept on 2026-10-06):
  - **Hero, photo behind text:** photo cropped to its subject; heading and text stay on the photo; **every CTA goes
    right under the photo**, the header bar's included, each once (copies in a phone-only "Phone buttons" box). A
    header CTA in the menu panel stays there too (shown only while the menu is open).
  - **Menu:** a panel sliding in from the right over the dimmed page, links one per line (20px+, 48px lines), the
    header's button under them; the toggle stays on top and turns into the × that closes it.
  - **Photo/text zigzag rows:** photo first in every row once stacked.
  - **Photo-card slider:** one slide per view, nothing of the next card showing (the user tried a peek and dropped
    it, 2026-10-01); at most 16px between cards; stacked rows of alike cards swipe as one slider.
  - **Spacing:** one capped, whole-pixel, monotone scale: sections at most 64px top and bottom, gaps 48.
  - **Section intro on phones:** heading, text, then its button. Photo cards keep their photo's shape, two per row
    where they can't slide. Stacked items' divider padding evens out; a row split by its items' own divider lines
    loses the lines once it wraps, goes two per row or stacks, its sides even out and the space becomes its gap.
  - **Hero, photo beside text:** text, then photo, then buttons.
  - **Hero without a photo** (a colour or gradient behind its words; the user left it to what looks nicer,
    2026-10-07): its buttons stay where they are, right under its words, full width. No buttons band.
  - **Every call-to-action button is full width** on phones, cards included (not tags, floating layers, icon buttons).
  - **One photo per slide.** A photo group without text splits into slides; a card with text keeps its largest photo.
  - **Footer** last on the page and centred; text and spacing: whole-pixel type, balanced headings, capped gaps.
- **Typed line breaks** (user, 2026-10-21, L1A L2A): in a text box of fixed width (Figma's fixed or auto-height box),
  typed breaks that only copy Figma's own wrap go out as spaces, so the words wrap by the box on every screen, never
  by the screen's width. A text hugging its words keeps its breaks from the design width up and loses them below.
  Breaks that are the designer's (items like addresses and hours, a sentence a line, headings, a line the next word
  would have fitted on) stay. Only prose goes soft (finisher's ruling under the user's auto-go; `style/rag.ts`).
- **Free-floating designs on phones** (the user, 2026-10-07; designs drawn without auto layout):
  - **Big outline words layered over other things** (a word between two lines of a sentence, a giant word across a
    photo's corner): their own line where they read, shrunk to fit; a word across a photo goes just above it.
  - **Heading pieces drawn as pictures** that overlap or stagger shrink together as one picture, keeping the stagger.
  - **Landscape drawings** (hills along a section's bottom, ridges, a cactus or sun among them) shrink to the width at
    their edge, keeping their shape; **all-over patterns** (stars, contour lines, rain) keep covering.
  - **Big decorative numbers** go right above the item they label.
  - **A sideways label beside a heading** turns upright, a small line above it (where its row stacks; where the row
    keeps its line, the label keeps running beside it, M2b).
- **Website rules** (2026-10-02: HTML5 semantics, WCAG 2.2 AA, search and speed basics; the user means technical
  rules, not laws). The look never changes to follow one:
  - **The design breaks a rule** (faint text, small targets, tiny text): never recolour or resize. The design-check
    findings list is **left out of v2** (2026-10-06).
  - **Extras Figma never shows** only where mouse and touch users can't see them: keyboard focus ring
    (`:focus-visible`), reduced motion, a pause control that appears on Tab.
  - **Bricks owns** `<main>`, the skip link and the page header/footer (its templates): the plugin never emits `main`,
    `header`, `footer` or a second skip link.
  - **Headings** from structure; **alt text** annotation → panel (saved in the file) → descriptive layer name;
    **reading order** of absolute layers only where they can't meet.
- **Open question for the user (not decided):** a hover component inside a link keeps its phone tap control, so on
  phones a tap shows the hover and the link doesn't open. Ask before changing it either way.
- **Picture descriptions in the panel** (user, 2026-10-07): a "Picture descriptions (N missing)" list after each
  conversion (photos and drawings, not icons or backgrounds), with Decorative and Show.
  - Save keeps them in the Figma file (document plugin data `f2b-alts`, by image for photos, by layer otherwise) and
    sends them to WordPress for pictures already there.
  - Bricks shows the media library's alt (verified on the live site), so the paste carries no `altText`.
- **AI picture descriptions with alttext.ai** (user, 2026-10-14):
  - **The AI writes every photo:** on its first pass it replaces typed descriptions, annotations and layer names.
  - **Photos only:** every listed picture showing a Figma image (cropped, tinted or masked ones too, which are rendered),
    never drawings, icons or backgrounds.
  - **Into WordPress's alt field,** not the file's metadata.
  - **Review after the upload:** the list marks AI rows; edit + Save sends the fix.
  - **My rulings, not yet confirmed by the user:**
    - Decorative is never sent.
    - A photo is described once: its words are saved in the file, and then beat a later annotation's `alt:`.
    - Language and length come from the alttext.ai account.
    - Only when pictures go to WordPress.
  - **The key never goes in the file, the paste or the debug file.**
  - **alttext.ai can't read AVIF:** send it a WebP/PNG copy, never the AVIF.
- **Figma colours in Bricks** (user and their manager, 2026-10-14):
  - **Which colours:** the file's colour variables and colour styles, under their Figma names. A file without any gets
    every colour its design uses.
  - **How:** a palette file the user imports in Style Manager → Colors. The user declined a helper WordPress plugin,
    the only way to make it automatic: a paste can't carry colours and WordPress has no route for them
    (`reference/bricks/README.md` "Colour palettes").
  - **Linked:** pasted colours point at the palette, each with its plain colour as a fallback, so a paste made before
    the import still looks right.
  - **My rulings, not yet confirmed:**
    - hex names in fallback (not `color-1`);
    - opaque only;
    - default mode only;
    - library colours only when used;
    - no name prefix;
    - a reduced-opacity colour stays plain.
- **Forms** (user, 2026-10-16: "make the contact form and the Yes/No interactive"): a drawn form becomes Bricks' Form.
  - It sends by email to the site's admin address with Bricks' own texts; the address, message and saving are "figure
    out later".
  - My rulings, not yet confirmed: typed words in the labels' colour, no option pre-picked, a chevron box is a text
    field, the send button's icon is left out (warned).
  - **The user's team uses WPForms (Pro)** (2026-10-19). On the contact page the Bricks Form was swapped by hand for
    WPForms form 559 in a Shortcode element, styled by `reference/wpforms/need-a-repair-559.css` in Bricks → Settings →
    Custom code (the user: "it worked"). A plugin option "Forms become: Bricks form / WPForms" is proposed, not built:
    it waits for the team's WPForms export file and which option starts selected (`reference/wpforms/README.md`).
- **Call and email links** (user, 2026-10-19: "whenever there's a call … button, the plugin will automatically use it
  as a hyperlink and will identify the phone number"):
  - **Every number and email shown becomes a link,** inside sentences too, only the number itself, looking as drawn.
  - **A "Call" button dials:** its own number; else the closest (in its card or row); else the one whose caption shares
    a word with it; else the page's main number (shown most, then highest). "Email us" buttons work the same way.
  - **No number on the page:** the button stays unlinked and the panel names it.
  - **My rulings, not yet confirmed:**
    - "Book / schedule a call" is a booking, not a call;
    - sample numbers (555) and addresses (example.com) are never linked;
    - an icon beside a number is part of the link;
    - Figma's own text links also keep the drawn colour;
    - the words are English only;
    - a plain "Call Derek" text without a number stays plain.
- **Links to pages** (user, 2026-10-19: "whenever there's a hyperlink icon … or 'take me to this' … it will
  automatically implement the hyperlink … to that page", named after "the sentence before it"; build `2026-10-19.17`).
  The user chose, in questions:
  - **The whole card is the link,** not the arrow alone.
  - **Figma's own links win, unchanged,** frame names included (a Navigate to "Core Exchanges Final" stays
    `/core-exchanges-final/`). **Replaced on 2026-10-20 whenever WordPress is connected** (the user: "Look up my site",
    and "Yes, check them too"): every page link, Figma's included, goes to the site's page named like it, ignoring
    "Final" and "Page"; the panel names drafts and missing pages. My rulings, not yet confirmed: a final page beats a
    copy, "old" is another page; a tie keeps the oldest and is named; an address already opening a post or archive is
    kept; the connect note only when the plugin found links.
  - **A link never opens a picture** (user, 2026-10-20, answers 1A–5A of the link-hrefs plan): uploads always end in
    `-image`/`-video`; a link to a page not made yet keeps its address (it works once the page exists); every Convert
    moves the plugin's own uploaded pictures (in the upload cache) off a link's address and never touches other
    media (a link with no page there comes off); a Figma link typed to a picture or video file is dropped and named,
    documents (PDF) stay. Words linked to another frame in Figma link to that frame's page (user, 2026-10-21, F1A
    F2A F3A, build `2026-10-21.5`): a part of a frame goes to its top frame's page, a frame gone from the file leaves
    the words plain and named, and the site check sends them to the site's page as it does Navigate links. Such words
    count as the designer's link, like typed-address ones: their card gets no whole-card link and a pill whose label
    carries one is a Div with a linked text, not a Button (review F4, not yet confirmed by the user).
  - **Arrows only, read from the drawing:** → ↗ ↘ › count; + × ✓ ↓ and up/down chevrons never. An icon whose drawing
    can't be read counts only as the only icon at the right end.
  - **A button with an arrow links to the page its words name, except actions** (Submit, Get directions, Call, Book,
    Open in Maps…). The panel lists every link made.
  - **My rulings, not yet confirmed:**
    - leading go-words and fillers are dropped ("Explore our services", "All services" → `/services/`);
    - a "Learn more" outside a card gets no link;
    - a label naming another page than its card's ("Compare plans →") links only itself;
    - nothing inside a strip Figma scrolls sideways is linked (its arrows glide it);
    - an arrow is at most 64px; the title must be the card's biggest words and stand out;
    - only "Home"/"Homepage" go to `/`; other sites, page numbers and form placeholders never link;
    - a linked card, or a heading's own row, keeps its heading.
- **The site's own header and footer** (user, 2026-10-20: "if there is already a header and footer in bricks then the
  plugin will remove the header and footer"):
  - **Asking:** two ticks in the panel, remembered in the Figma file (chosen over asking on every Convert).
  - **The room under the site's header:** measured by a script (chosen over Figma's header height).
- **Lists a visitor searches and filters** (user, 2026-10-19): "In the page" (the plugin pastes every row and a small
  script; no WordPress post type) and "Spreadsheet in the panel" (a CSV per list, kept in the Figma file).
  - **On tablets and phones** (user, 2026-10-19, screenshots at 990/766/477: "whenever there's a panel, it looks clean
    and nice on mobile, mobile landscape, and tablet"; build `2026-10-19.15`):
    - "One line per record" on tablets and phones held sideways, the titles over their columns, the search full width
      with the pills under it from the left;
    - "Compact card" on phones: no titles; the first column with the last at its right, the others under them with a
      dot between.
- **Photos as AVIF (when chosen):** never fall back silently to WebP or the original; stop and explain.
- **Phone slider:** `height: "auto"`, never Bricks' `autoHeight`; a hidden slider measures 0px.
- **Output style (2026-10-06): editable structure first.** `ExampleBricks` (repo root, one Bricks 2.3.9 copy per line)
  is the user's hand-built version of a real page, and the target for what v2 emits:
  - Bricks settings instead of custom CSS (v1 put custom CSS on 84% of its elements; the example on 7 of 151);
  - classes named by purpose (`section`, `container`, `h1`, `text`, `cta-…`), not by font;
  - native `button` (with its icon), `icon`, `divider`, `accordion-nested`, `slider-nested`, `carousel`, `video`;
  - a shallow tree. Custom CSS only where Bricks has no setting. Desktop looks like Figma but isn't pixel-pinned.
- **Phone sliders are copies (2026-10-06):** the desktop row hides on phones and a phone-only Slider Nestable holds
  copies of its items, as the user builds them by hand ("Card-Desktop" / "Card - Mobile").
- **Kept features:** WordPress upload (REST + Application Password), AVIF/WebP, Figma Motion, Google Fonts, text
  styles → global classes, debug file. **Deferred** (2026-10-06): tablet designs (a third drawn width; desktop + phone
  drawn designs are done, 2026-10-08), audit list, masks and maps (video plays since 2026-10-19; a captured Google map
  is live since 2026-10-20, at the user's request), timer/state machines (logo marquees are
  built, 2026-10-19, but not v1's Figma timer loops that slide logos). Don't build
  these unless the user asks.
- **Unverified in Bricks:** anything not in `reference/bricks/`. Check it with a paste-and-copy-back round trip first:
  custom tags, `_attributes`, `_cssId`, `link.newTab`, `display: contents`, `%root%` in custom CSS, Block
  `tag: "nav"`, Image `altText`/`loading`, and `aria-*`/`fetchpriority`/`tabindex` attributes.
  - Also unverified:
    - `_flexDirection` and `_gap` on non-layout elements;
    - the Colors import of the panel's palette file;
    - a palette reference whose `raw` carries a fallback (`var(--x, #HEX)`).
