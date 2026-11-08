# Figma to Bricks v2: instructions for every agent

**Status and history:** `docs/HANDOFF.md` (newest first: every feature's section with its rulings, paste check and
follow-ups) and `docs/plans/<date>-<name>.md` with its `-ledger.md`. This file keeps only the current status and the
standing rules. **Don't add build narratives here:** a feature's details go in HANDOFF and its ledger. Only the build
line, one line per new feature, a new standing rule, a user decision or a gotcha every agent needs comes here.

## Status (2026-11-08)

- **Current build `2026-11-08.2`** (read `src/shared/build.ts`; another session may have bumped it). The latest
  features, each with its HANDOFF section:
  - **2026-11-08.2 capture-speed (website importer):** `npm run capture` reads up to 4 width ranges side by side in
    separate Chrome windows (`--windows <n>`), asks Chrome's matched styles once per element, asks the site for the page
    once per kind of visitor (public addresses), loads a failed page again in the same window and stops with one plain
    line when the connection stays down (a lost connection is seen in the page's own requests too), asks "I am human" at
    most once per kind, and prints `Took …`; the saved B-Dry home captures in 3.4–3.7 min (base 33–35 min), the same
    capture as before. Paste check **3dm** (AC11, live: bdryswi.com under 10 min).
  - **2026-11-08.1 elementor-map (website importer):** with `--elementor`, `npm run site`/`site:check` fold Elementor's
    wrappers so each Elementor element is one Bricks element, and Elementor's and ElementsKit's FAQs become one Bricks
    Accordion (Nestable) that opens and closes like the site, within 2 px at every width (B-Dry's FAQ 0 px at 39 widths);
    the capture keeps hidden parts of shown elements; without the flag pastes are as before. Paste check **3dk** (AC9,
    AC10, live).
  - **2026-11-07.1 web-code-page (website importer):** the code method pastes a captured page whole: header, page and
    footer by the site's own elements, classes and CSS, within 2 px at every width (B-Dry 1.09 px at 53 widths), alt
    text and page-builder markers kept, bold and italic as on the site; every class starts with the page's name
    (`home__…`) but `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` (Justin, 2026-11-07, "Prefix every
    name"); a site's CSS animations stay still (no `@keyframes`). Paste check **3di** (AC12, AC19, live).
  - **2026-11-04.8 icon-buttons:** a pill of words and drawn icons is Bricks' own Button drawing its icons in CSS; a
    button-shaped box inside a link is a Button with no link; a label wholly linked makes a linked Button. Paste check
    **3dg** (AC8, live: hydraulics' hero).
  - **2026-11-04.8 rich-text:** every text but a heading is Rich Text; a text that is all one link is Rich Text inside
    a Block carrying the link in Link to; no Basic Text is emitted. Paste check **3dh** (AC8, live: the structure panel
    shows no Basic Text).
  - **2026-11-04.7 web-code-proof (website importer, new method):** the importer's new route copies a site's own HTML
    and CSS (its elements, classes and per-width rules) into Bricks: `npm run capture` records the code, `npm run site`
    writes one section's paste, `npm run site:check` measures it against the capture (2 px at every width). Proved 0 px
    on the saved bdryswi.com section at 53 widths; the panel still uses the old route. Paste check **3dc** (AC9, live).
  - **2026-11-04.6 element-link:** a text that is all one link (an email, a phone number, a whole Figma or page link,
    headings too) carries it in Bricks' Link to (External URL), never as an `<a>` in its words; a link inside a
    sentence stays inline. Paste check **3df** (AC10, live).
  - **2026-11-04.5 cta-names:** every call to action that is its own control has an accessible name: a linked one in
    `link.ariaLabel`, an unlinked one as an `aria-label` custom attribute, none inside a link; vague words ("Learn
    more") add their card's title. Paste check **3de** (AC6, live).
  - **2026-11-04.4 dark-structure-recognition:** structural header/footer ownership, authored footer destinations and
    a note for the static numbered-review candidate. Paste check **3dd** (AC8, live: Figma/Bricks 2.3.9/Safari/iPhone).
  - **2026-11-04.3 web-human-reload (website importer):** after an "I am human" check the capture reads the site's
    switch points and title from the passed page (never the check page), a pass counts once the page stays put for
    2 s, and a site's own reloads are waited out (3 tries, then one plain line). Paste check **3db** (AC8, live:
    bdryswi.com's full capture with real switch points).
  - **2026-11-04.2 web-photo-crop (website importer):** a captured picture the old site shows whole (its boxes keep one
    shape at every width) pastes with its shape (`aspect-ratio`, no fixed height), so it is never cut; pictures the site
    crops stay cropped; Figma designs convert byte for byte as before. Paste check **3da** (AC6, live: bdryswi.com's
    three problem cards).
  - **2026-11-04.1 web-human-check (website importer):** when a site answers the capture with an "I am human" check,
    the helper opens a visible Chrome window; Justin presses the button there and the capture carries on in that
    window (every width, every page with `--all`), then closes it. Nothing hides that the browser is automated. Paste
    check **3cz** (AC8, live: bdryswi.com).
  - **2026-11-03.2 web-embeds (website importer J5):** a captured page's own widgets (another company's script in a
    box), maps and floating extras (a call button, a chat bubble) come across: widgets as Code elements with only the
    script that made them, maps as live Google maps of the same address, floating extras fixed at the end of the
    footer part. Paste check **3cw** (AC12, live; bdryswi.com's AC13 once its bot check lets the capture in).
    Amendment 1 (AC2: only JavaScript counts, an inline script only when it loads or calls the widget's host) is the
    main session's ruling, not yet confirmed.
  - **2026-11-03.1 djtrees-phone-menu:** a bar proven to be the site's menu folds into Bricks' Nav (Nestable) where it
    no longer fits: logo left and smaller, ☰ right, a panel from the right with the links and the bar's action; a
    frosted bar keeps its blur. Paste check **3ck** (DJ staging, real iPhone).
  - **2026-11-02.5 web-address (website importer):** type a site's address in the panel and press Capture; the
    importer helper (`npm run capture:serve`, once per work session) captures it and the capture box opens. Paste
    check **3cy** (AC13, live).
  - **2026-11-02.5 web-panel (website importer J4):** drop a `.f2b-capture.json` on the panel (or Open website
    capture…), choose Page, Header or Footer and Convert and copy; pictures, the old site's alt text and font files
    come from the file. Paste check **3cx** (AC16, live; bdryswi.com's captures once its bot check lets them in).
  - **2026-11-02.5 web-tiers (website importer J2):** a captured page keeps the old site's own layout at Bricks'
    tablet and phone tiers (one rule, `site.tiers`); Figma designs convert byte for byte as before. No paste check of
    its own (seen in 3cx); AC15 (bdryswi.com, live) owed.
  - **2026-11-02.5 web-capture, web-compare (website importer wave 1, tooling):** `npm run capture -- <address>` saves
    a live page as a capture file; `npm run compare` measures a paste against the live site. No paste check; AC15
    (every bdryswi.com page, live) owed once Justin allow-lists the capture.
  - **2026-11-02.4 djtrees-faq-art:** faint art in the empty space of the row under a section's heading moves beside
    the heading once that row stacks, under its words (the FAQ tree). Paste check **3cs**.
  - **2026-11-02.4 djtrees-side-art:** faint art over a section's first heading moves beside it, smaller, once its row
    stacks; a frozen section with its words at its bottom keeps its top space, stepped, from 991 down. Paste check
    **3cm**.
  - **2026-11-02.4 djtrees-step-sides:** steps each drawing a line along their top line up on phones, each line midway
    between two steps' words. Paste check **3cp**.
  - **2026-11-02.4 djtrees-stack-lines:** a divided row stacked one per line gets a line like its dividers between every
    two points, midway. Paste check **3co**.
  - **2026-11-02.4 djtrees-stack-gaps:** a broken divided row's points keep their own top and bottom as the space
    between them, no gap added on top. Paste check **3cr**.
  - **2026-11-02.3 djtrees-strip-edge:** a carousel strip Figma leaves unclipped runs its cards on to the window's
    right edge from 992 up, its first card where drawn. Paste check **3cu**.
  - **2026-11-02.3 djtrees-top-align:** label/value pairs stacked as label over value line up at the top once a value
    wraps. Paste check **3cn**.
  - **2026-11-02.3 djtrees-faint-picture:** a picture shown from its own file keeps its fill's opacity (the FAQ tree is
    faint again). Paste check **3cv**.
  - **2026-11-02.3 djtrees-panel-edge:** a panel drawn against a section's side reaches the window's side on screens
    wider than 1440; its words stay in place. Paste check **3cj**.
  - **2026-11-02.2 djtrees-cta-center:** on phones a stretched call-to-action pill centres its words and icon together;
    a pill's own hover layer never wraps it. Paste check **3cl**.
  - **2026-11-02.2 djtrees-storm-photo:** a section whose photo fill sits on one side fading into its colour stacks
    from 991 down: photo on top fading into the section colour, words below; a section holding a placed layer keeps its
    old look. Paste check **3cq**.
  - **2026-11-02.1 djtrees-phone-headline:** big headings of two or more words are at most 72px upright and 93px
    sideways on phones; a tight one opens to line height 1 where its words wrap into more lines than drawn. Paste
    check **3ct**.
  - **31.2 landing-page-six (merged at Justin's direction; proof limits remain):** responsive records, navigation,
    grouped photos and native reviews. Paste check **3ci** owed; AC7 required/non-live/source wrap held, AC13 live
    Figma/installed Bricks/Safari/iPhone proof owed; blind audit not run.
  - **31.1 landing-page-loop (test integration; full validation held):** centered sticky navigation, inset panels,
    editable diagram and manual review slider. Paste check **3ch** on an isolated installation owed; original AC17
    required/non-live/held (headline font/source mode), AC18 live/owed (Figma/installed Bricks/Safari/iPhone).
  - **30.20 social-links (in session):** social icons link to the profiles in the site's Yoast SEO. Paste check **3cg**.
  - **30.19 djtrees-side-panel (quick fix in session):** content drawn against one side of a section reaches that side;
    a lone layer with a Center constraint stays centred. Paste check **3cf**.
  - **30.18 djtrees-drawn-map (quick fix in session):** a picture with a pin over its middle, named as a map or pin,
    becomes a live Google map of the address near it. Paste check **3ce**.
  - **30.16 djtrees-ruled-rows (quick fix in session):** a row divided by thin line layers evens its items' sides once it
    wraps or stacks. Paste check **3cd**.
  - **30.15 djtrees-hover-label (quick fix in session):** a button's hover copy keeps its words on one line where the
    button's do; 30.17: from the design width up too. Paste check **3cc**.
  - **30.12 djtrees-wide-hero (quick fix in session, no reviews):** section photos fill wide screens edge to edge (Justin's
    new choice); a menu bar drawn over the hero is pinned above tablets. Paste check **3cb**.
  - **30.11 djtrees-side-photo (quick fix in session, no reviews):** a section's Crop photo drawn against one side reaches
    that side of wide screens. Paste check **3ca**.
  - **30.7 djtrees-carousel (quick fix in session, no reviews):** an unclipped frame Figma scrolls sideways is a strip;
    a row of back/on buttons and bars under it moves it and lights the bar; 30.8: no scrollbar, the current or hovered
    card lifts 8px; 30.9: arrows step one card at a time; 30.10: no arrows on phones; 30.13: unlit bars take their most visible look; 30.14: one bar a card. Paste check **3bz** (needs code execution on and signed code on the site).
  - **30.6 djtrees-landing (quick fix in session, no reviews):** a logo lockup (mark + name) makes a header; a pasted
    solid header sticks; a row drawn edge to edge drops the Container's side margin above tablets. Paste check **3by**.
  - **30.4/30.5 djtrees-links (quick fixes, reviews waived):** header menus inside the hero now link too; the logo
    goes home and footer links stay. Full-file clicks proven; failed paste check **3bw** needs a fresh-paste retest.
  - **30.4/30.5 djtrees-faq (quick fixes, reviews waived):** wrapped titles pair as native FAQ items; the first open
    answer/look stays and decorative art cannot block taps. Five answers need text; **3bx** needs a fresh-paste retest.
  - **30.2/30.3 faq-gaps, faq-still (quick fixes in session):** a row gap drawn past its own box becomes Auto spacing
    (the FAQ + at the right edge); a label and its small icon keep one line at laptop widths; FAQ questions don't
    hover. Paste check **3bv** owed.
  - **30.1 cut-outs (quick fix in session, no review rounds at Justin's word):** a see-through picture Figma shows
    whole is `contain`, so a cut-out of another shape swapped in Bricks shows whole. Paste check **3bu** owed.
  - **29.3 header-bar:** with the header tick on, a site's top bar (logo, phone line, button, ☰) is recognised as its
    header and left out, a call bar's nav bar with it; unticked, its logo links home, its phone number calls, and its
    row spans wide screens. Paste check **3bs** owed (paste the B-Dry header into the staging site's Header template).
  - **29.2 after-faq-sections:** a footer frame that stacks page sections above its links keeps those sections when
    the footer is ticked, painted as drawn. Paste check **3bt** owed (paste the three sections under the FAQ on
    /homev2/).
  - **29.1 headline-marker:** a stroke draws around styled words; released at Justin's direction with drawn-phone
    and exact-design-width ring overflow still open. Paste check **3br** owed (AC13: Figma Trim, Bricks, Safari/iPhone).
  - **28.5 closing-cta (section rhythm):** between every two sections the page's section space (the space most
    sections draw) separates their words, stepping down on tablets and phones; no divider lines between them; buttons
    always get that space under them; the space beside a left-out site header/footer stays. Paste check **3bq** owed
    (re-paste Home with the ticks on).
  - **28.4 photo-hotspots:** Manual Open overlay makes a card beside its dot; optional `pulse` annotation. Paste check
    **3bp** owed (AC12: Figma Manual offset, Bricks, mouse/Tab, real iPhone and Reduce Motion).
  - **28.3 slider-autoplay:** a component whose variants loop After delay becomes a Slider (Nestable) that plays by
    itself. Paste check **3bo** owed (AC13/AC14: Bricks round trip and Figma's real timings).
  - **28.2 label-floor:** pill words at least 13px, Learn-more-style links at least 15px; tight rows give way. Paste
    check **3bm** owed.
  - **28.1 flip-cards:** a hover component marked `flip` turns over. Paste check **3bn** owed (mouse, Tab, iPhone taps,
    Reduce Motion).
  - **26.1 faq-answer-space:** space under an open FAQ answer. Paste check **3bl** owed.
- **Paste checks owed:** HANDOFF "End-of-run check list" (3c onward); each feature's HANDOFF heading names its check.
  3bj, 3bl, 3bm and 3bq all empty Home and re-paste "Home Page Final" with the header/footer ticks as on the site: copy
  the FAQ answers Justin typed in Bricks first and type them back after. 3bt pastes `after-faq-sections.json` under
  the FAQ on B-Dry's staging /homev2/; 3bs pastes `header-paste.json` into B-Dry staging's Header template. Several
  older pages need a re-paste too (3ac).
- **Milestones:** M0–M4b of the design (`docs/specs/2026-10-06-v2-design.md`) are done. Next: the user's end-of-run
  check, then the sample-bound parts (M2d phone menu, Tabs, Dropdown, Offcanvas, pop-ups).
- **Corpus:** 17 results are worse than v1, all from Bricks' cap of every element at its parent's width (live-site
  looks, not regressions; HANDOFF "Bricks caps every element at its parent's width").
- **Queued CLAUDE.md edits:** `~/.hermes/plans/figma-to-bricks/*-claude-md-pending.md` hold edits finishers couldn't
  write here (builds 21.13 onward). Their history is already in HANDOFF; only standing rules from them belong here.

**The user's live site:** `darksalmon-badger-335429.hostingersite.com` (Hostinger, WordPress, Bricks 2.3.9; LiteSpeed
Cache, WP Mail SMTP, Yoast, WPForms Pro, AltText.ai). After a paste that holds code (lists, card arrows, maps, the
header spacer) the user runs Bricks → Settings → Custom code → **Regenerate code signatures**; after any CSS change,
**LiteSpeed → Purge All**. Read it past the cache with `?f2b=<random>`.

**Files the user works with:**
- `figma-to-bricks-debug-page-1.json` (repo root): "Hydraulic Cylinder Repairs Final" (build 2026-10-20.6, 1728
  wide). `git show 2199895:figma-to-bricks-debug-page-1.json` is "Services Page Final" (the parts inventory: 78 rows,
  search, 6 pills, a 560px scroll box). Ask for a new save when you need another page.
- `docs/data/reman-cylinders.csv`: the 78 cylinders, matching the designer's table row for row.
- `reference/wpforms/`: the WPForms notes and `need-a-repair-559.css`.
- The scratchpad of an older chat is gone or stale; never rely on it.

**Waiting on the user (don't guess these):**
- **Should headings keep Figma's case** when the site theme uppercases them?
- **WPForms:** whether the plugin gets a "Forms become: Bricks form / WPForms" option, and which starts selected. It
  needs their WPForms export file.
- **Rulings to confirm:** the list rules (HANDOFF "Searchable lists"), the form rulings, and every "not yet
  confirmed" ruling in each feature's HANDOFF section.
- **Bricks samples:** Nav (Nestable) for the phone menu (the right copy contains `nav-nested`; a researched sample,
  `reference/bricks/nav-nested.json` from Bricks' code and live sites, stands in until his own copy replaces it),
  Tabs, Dropdown, Offcanvas + Toggle, a working Interaction, a `popover` Div. Never write those emitters from memory.
- **M4b** (Figma Motion as CSS keyframes) is built against Figma's typings only: it needs the user's Motion test file.
- **"Home Page Final"** holds a whole Services page inside its own frame: waiting on Justin's Layers screenshot.

**Known open bugs and limits** (details in HANDOFF):
- **Lists:** card grids (cards in columns, with pills) aren't recognised as lists; deferred minors (the panel's empty
  list name, two lists with desktop + phone frames, the status after Remove, no large-CSV warning, tab-separated
  files).
- **Zooming in (150%+):** contact cards are cramped (at 768 too) and the menu breaks into a grid (needs the Nav
  sample).
- **Space frozen into a fixed-height box:** outside FAQs, a box drawn at a fixed height loses the space under its words
  once they wrap more and from 991px down; a badge pinned to the bottom of such a box lands on its words on phones.
- **Flip cards:** Safari may show a turned-away face's composited children (a `will-change` picture, a video, a CTA's
  fade-in); a divided row of flip cards keeps its lines on tablets and phones.
- **Photo hotspots:** any clipping ancestor can cut a hanging card; long labels may meet on narrow phones. Combining
  `pulse` with CTA/product animations and the generic class name's possible site collision remain follow-ups.
- **Section rhythm:** a drawing pinned beside a closing's buttons or to its top can land on full-width phone buttons or
  a wrapped heading from 478 down (base too; HANDOFF follow-ups).
- **Header tick:** GRO's and brainstorm's nav drawn inside the hero stays in the paste. A strip under a call bar that
  has a picture, four short items and a button is read by its words (two-word menus stay, one-word bands leave);
  Justin wants it read as the main header (follow-up).
- **Fonts:** fonts may load twice (needs a live paste proof); `localeCompare` may sort fonts differently under Figma's
  SES.

**How the user works (see memory too):**
- They answer with screenshots and short messages.
- They want plain, numbered steps naming exactly what is on their screen, one action at a time.
- They expect general fixes. Ask before a design decision with trade-offs (AskUserQuestion with previews worked well).
- They said "build straight through": run each milestone without stopping, and report rulings and deferred minors in
  plain words at the end.

v2 is a clean rewrite of v1 (`~/Desktop/figmaplugin`, read-only reference). The approved design is
`docs/specs/2026-10-06-v2-design.md`; read it before changing the architecture. v1 is the reference for **rules it
learned**, never for its code structure.

## Build general logic, never one-file fixes

This plugin converts **any** Figma file into Bricks, not only the design in front of you. It is used across many
different files by many different designers. Treat every request (a new feature, a bug report, "this section looks
wrong") as one example of a whole class of designs, and change the logic so the entire class converts correctly.

- **Every change goes into the plugin** (Justin, 2026-10-29: "every single change needs to be inside the plug-in, not
  just for copy-pasting purposes"). A fix found on one site's paste (the B-Dry copy of bdryswi.com) is also a general
  plugin change so every converted website gets it; a paste-only patch is at most a stop-gap beside the plugin job. A
  paste-only plan names the plugin code involved and the general rule, or says why the plugin can't be.
- **Prove it on the plugin first** (Justin, 2026-10-29): a problem seen on a hand-built paste becomes a plugin job only
  once a real plugin conversion shows it; until then it's recorded as a suspicion.
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
  - A tier that goes back to the designed value writes it explicitly: Bricks cascades tablet → sideways phones →
    upright phones, so writing nothing keeps the narrower tier's squeeze.
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

- **A size change made after Figma must reach the layout plan as a planned width.** Shares and row shapes read
  drawn widths unless the earlier pass records growth (`IRNode.giveWay`, `grownAlong`, `plannedWidth`, `rowGapAt`).
  Counting grown words only in `least()` can make laptops wrap rows tablets keep (label-floor, GRO's hero).
- **Space drawn next to a part the site already has stays** (`designs.ts` `keepBeside`): leaving the header or footer
  out never takes the gap beside it.
- **Bricks prints a linked Image as its link** (`<a id class="brxe-image … tag"><img>`, `a.brxe-image{display:inline-block}`);
  `test/browser/render.ts` follows it since 2026-11-03 — browser receipts that measure a linkable picture run both
  picture modes.
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
  (user, 2026-10-23): the session only orchestrates; fresh Opus 5.5 xhigh `general-purpose` agents plan, build,
  review, fix, verify and audit, and `ac-check.sh` decides when every AC is accepted. Never plan, build or review in
  the session itself (this replaces the single-session `superpowers:writing-plans` flow). This repo's specifics:
  - **Start:** in a terminal in the main folder, `claude -w <feature-name>` (`.claude/worktrees/<feature-name>` on
    branch `worktree-<feature-name>`, with what `.worktreeinclude` lists: this file, `node_modules/` and v1's corpus
    output). One session per feature, so no agent sees another's half-done work; two or three features at a time,
    touching different stages or rules, or merges get harder.
  - **Plan:** `docs/plans/<date>-<name>.md` (in git, not `~/.hermes/plans`), numbered AC1, AC2… with one test each
    (`implementation-planning`).
    **Standing auto-go** ("no stop between plan and run"): show the plan message (questions with ⭐ answers, proposed
    and `(live)` ACs) and dispatch the builder at once, taking the ⭐ answers, unless the user replies **stop** or
    changes something. Make the read-only copy first: `mkdir -p <evidence> && install -m 444 <plan>
    <evidence>/plan-approved.md`. Evidence goes in `~/.hermes/plans/figma-to-bricks/evidence/<name>/`.
  - **Build and review:** the builder keeps a ledger in `.superpowers/sdd/<plan>/progress.md` and runs `npm run
    corpus` before Task 1 and at the close. Then two fresh Opus reviews with a fix pass after each (each fix test
    first), then the verifier, the blind AC auditor and `ac-check.sh`, looping until every AC is accepted (global
    CLAUDE.md steps 5–6).
    **Review rounds are capped** (Justin, 2026-10-31: "I need this to be built fast"; memory `review-round-cap`):
    every AC is still met and accepted with no cap, but review → fix rounds stop after 3 in all (1–2 for major bugs,
    the rest for the main edge cases); what a later review would still find goes to `follow-ups.md` and HANDOFF
    "Deferred". This overrides the global "no round cap" for review rounds only. **Website importer, tightened
    (2026-11-02: "focus on building and not too much of edge cases"):** one review per job, reporting only bugs a
    real site or normal use hits; edge cases go straight to follow-ups; a second review only to check a major fix. The review diff is `git diff main...HEAD` in the copy, or `git diff <commit before the
    milestone>` on `main`.
  - **Rules for every agent in a copy:**
    - Run `npm run check` and `npm run corpus` there.
    - Commit to the branch after each passing task. The branch stays on the Mac: don't push it (merges are local).
    - Don't bump `BUILD`, and don't edit the main folder.
    - Don't edit the copy's CLAUDE.md: it's a snapshot from the start, deleted with the copy. Status notes go in
      `docs/HANDOFF.md` and the ledger, which are in git.
    - Never use bare `git stash`: the stash list is shared by every copy.
  - **Finish, once `ac-check.sh` says ALL ACCEPTED or READY FOR THE USER** (no need to wait for the user), as the
    global "Worktrees from `claude -w`" says:
    1. **Finisher agent, in the copy:** move the ledger to `docs/plans/<plan>-ledger.md`, commit everything, then
       `git rebase main`. On a conflict keep both sides' meaning; HANDOFF sections usually both stay. Run `npm run
       check` and `npm run corpus` again on the rebased branch: two features that pass alone can break together. It
       stops and reports the new HEAD. If HEAD now differs from the head `ac-check.sh` accepted, the AC receipts no
       longer match: the session runs verifier → auditor → `ac-check.sh` again on the new head before step 2 (agents
       don't start agents).
    2. **Session: leave the copy.** Call the ExitWorktree tool with action `"keep"` (the user's standing permission).
       Claude Code refuses git commands and edits aimed at the main folder from inside a copy (`git -C …`
       included), so the merge runs from the main folder. If ExitWorktree finds no worktree session, EnterWorktree
       with `path` set to the main folder; only if both fail, give the user the one `!` merge command and say why.
       Then, in the main folder: `git merge --ff-only worktree-<feature-name>`. If it refuses, main moved (go back
       into the copy with EnterWorktree and its `path`, repeat from 1) or the main folder has uncommitted changes
       (stop and tell the user). Never force it.
    3. **Finisher agent, in the main folder:** bump `BUILD` (read it first), `npm run build` (Figma loads that `dist/`),
       commit "Build <BUILD>: <feature>" and `git push` (`main` only). Then update this file's **Status** (the build
       line, one line for the feature with its paste check) and add any new standing rule or user decision to the
       sections below; everything else goes in HANDOFF. If writing this file is refused, leave exactly those lines in
       `~/.hermes/plans/figma-to-bricks/<name>-claude-md-pending.md`.
    4. **Session:** check that `git log --oneline main` shows the feature's commits, then tell the user it's merged,
       with every ruling and deferred minor in plain words and any `(live)` ACs owed. When they close the session,
       Claude Code offers to delete the copy; the branch goes with `git branch -d`.
  - **A quick fix the user asks to do right here** (no pipeline, a session started without `-w`) is committed
    straight to `main`, by file, before the next merge.
- **Setup:** TypeScript + esbuild. Dev dependencies only: `typescript`, `esbuild`, and the type packages
  `@figma/plugin-typings` and `@types/node`. No runtime dependencies; the browser tools use Node built-ins and the
  system Chrome.
  - `npm run build` writes `dist/code.js` and `dist/ui.html`, which `manifest.json` loads.
  - `npm run watch` rebuilds while you work.
- **The panel** (`src/ui/`): DOM-free modules plus `main.ts`. Browser features (fetch, image decoding, canvas, Web
  Workers) go through `src/ui/env.ts`, so tests stand in for them (`test/fixtures/panel.ts`).
- **The website importer's helper:** the panel reaches the importer helper only at `http://127.0.0.1:47811` with its
  pairing code; Figma desktop runs with Chrome's LocalNetworkAccessChecks off (Figma in a browser can't reach it). The
  helper binds 127.0.0.1 only and never writes to a site.
- **The importer never hides that its Chrome is automated** (no `AutomationControlled` flag, no `navigator.webdriver`
  patch, no new user agent, no stealth script, nothing that clicks or types into a site's check): a person passes a
  person check in the visible window (web-human-check).
- **The plugin's conversion** (`src/plugin/convert.ts`) must stay byte-identical to `npm run replay` for the same
  snapshot (`test/unit/plugin-convert.test.ts`).
- **Checks:** `npm run check` runs typecheck, build and the unit and rule tests. Tests use `node --test` on `.ts` files
  directly (Node 22 type stripping), so use only erasable TypeScript syntax: no `enum`, no `namespace`, no parameter
  properties.
- **Build number:** bump `BUILD` in `src/shared/build.ts` (`YYYY-MM-DD.N`) for every change the user will load in
  Figma. Read the current value first, because another session may have bumped it. In an agent's copy, leave it: the
  merge into `main` bumps it ("Finish", step 3).
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
- **Bricks gives pasted elements new ids,** rewriting each id only inside its own element (`reference/bricks/README.md`
  "Ids on paste"). Never name another element's id in custom CSS or a script: a look that follows another element
  names it by a marker class (`trigger-<hash>`), and scripts find elements by class (test `emit-paste-ids`).
- **Bricks caps every element at its parent's width** (`[class*=brxe-]{max-width:100%}`): a moving row needs
  `max-width: none`, and every width taken from Figma's box grows by a text's trailing letter-spacing
  (`style/tracking.ts`).
- **Bricks wraps every Section, Container and Block from 767px down** (its front-end CSS): a row the layout plan keeps
  on one line there writes `_flexWrap: "nowrap"` (`row.reflow`); the renderer copies the wrap.
- **Bricks writes text controls as given:** Flex basis numbers go out in px (`flex-basis: 323` is CSS the browser
  drops); `payloadProblems` refuses a bare one (`reference/bricks/README.md` "Text controls").
- **An empty global class is `settings: []`,** as Bricks keeps it; `{}` makes Bricks ask "Import classes" on every
  paste.
- **Bricks' Form prints labels only with `showLabels`** and the star only with `requiredAsterisk` (both off by
  default); its button Width setting doesn't reach the page, so custom CSS spans it.
- **Figma gives a plugin only a video's `videoHash`** (its SHA-1), never the file, and its PNG export draws no video
  frame, so a video fill has no poster. The site sends no CORS header on uploads, so videos are matched by name.
- **Every link kind** (an element's link or a text run's) goes through `emit/page-addresses.ts` and the panel's
  `ui/site-pages.ts` `relink`; addresses typed in Figma are never changed.
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
- **Test fixtures built from one column inside a section can surprise you.** A section's only child that spans it
  becomes the section's Container (or a band when painted), and its label disappears. Give such fixtures a sibling
  (a text above) when a test looks the box up by label. An auto-layout `column`/`row` fixture hugs its flowing
  children: a wrapper holding an absolute layer needs its own width and height, or it is only as wide as its words.
  Texts in the scene carry no fills (their colour is in the text data), so a "painted" check never counts plain words.
  A page column of only two parts reads as one section: give a fixture page three. `vector(name, opts)` ignores `fills`
  (spread it and set `fills` after); a hover becomes a hover copy (`overlay`) only for a change CSS can't draw, such
  as an icon's colour.
- **An element's own custom CSS never writes `display`** (icon-buttons, 2026-11-04): Bricks prints `#brxe-<id>{…}`
  after the control CSS, so it beats every tier `_display: none` a rule writes (phone.swap, compose.hide, the menu
  fold). Bricks' `.bricks-button` already gives a Button `inline-flex`, centring and gap.
- **Words elements hold a `<p>` since rich-text** (`div.brxe-text > p`): browser tests measure the inner `p`
  (`el.querySelector(':scope > p') || el`); `Range.selectNodeContents(el).getClientRects()` also returns the `p`'s own
  box (one line too many) and `el.firstChild` is the `p`, not the text node.
- **Rich Text HTML always goes through `emit/rich-text.ts` `asTyped`:** Bricks prints Rich Text through
  `parse_editor_content` (wptexturize + wpautop), so `asTyped` writes the designer's quotes, dashes, dots and `x` as
  numeric entities and breaks `<br><br>` with `<wbr>`; `test/browser/editor-content.ts` models it in the renderer. A
  saved edit in Bricks' rich editor may turn the entities back into plain characters.
- **`test/browser/render.ts` lacks Bricks' `.brxe-block{align-items:flex-start}`:** a browser receipt that depends on a
  Block being a block box injects that rule itself, or a dropped-`_display` mutant survives.
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
  - It drives the system Chrome over CDP (`test/browser/chrome.ts`), so viewports are exact at any width. Browser
    tests drive a touch screen with `Page.touch` / `Page.tap`, never `Input.synthesizeTapGesture` (headless, it sends
    no mouse events).
  - `--site[=header,footer]` converts with the panel's ticks; `--header=<px>[,<phone px>]` adds a fixed stand-in site
    header.
- **Wrapped one-liners:** `npm run wraps -- <debug.json> [widths]` lists one-line Figma texts that wrap on the page.
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
  - **Hover:** exactly as in Figma; on phones a tap does the hover. **Except call-to-action buttons** (below) and
    **FAQ questions** (Justin, 2026-10-30: "they should stay the same until clicked"): an accordion item and its
    question never hover; only opening changes them (build `2026-10-30.3`).
  - **Motion:** plays when scrolled into view.
  - **Only Figma's animations** (2026-10-01): convert what the design sets up, faithfully (entering and leaving). Never
    invent motion the design doesn't have: no automatic scroll reveals, hover lifts or added transitions. The
    exceptions are call-to-action buttons, product and team cards, logo marquees, flip cards and a marked `pulse` (below).
  - **Photo hotspots** (Justin, 2026-10-26: a small card beside the dot, no Bricks pop-up; Q1A–Q4A defaults under the
    auto-go, not yet confirmed; details and rulings in HANDOFF "Photo hotspots"):
    - A designer's placed layer in a photo box with **Open overlay → Manual** opens the card beside it: While hovering
      / Mouse enter under the pointer, On click / On tap on a click; Tab/focus also opens it and its links stay live.
      A hover card closes after the pointer leaves both; moving focus onward or tapping elsewhere closes a click
      card (CSS only; no Escape). Unsupported overlays are named.
    - **Phones keep the photo and dots.** The photo's ratio is a floor that flowing words may grow; dots keep their
      drawn size and spots, cards their width up to the photo's. Nothing in a trigger becomes a CTA or a hero button.
    - **Optional beat, only marked:** a whole-line `pulse` annotation on a layer, its corresponding main layer or an
      instance's main/set makes it beat (0.7s each way, 10%, ease). It works on other layers too; its own Figma Motion
      wins and is named. Reduced motion stops the beat and shows cards without a fade. Unmarked layers gain no beat.
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
  - **Sliders that play by themselves** (user: the source page's hero, as a general feature; build `2026-10-28.3`,
    HANDOFF "A slider that plays by itself"): only a component instance whose variants change to one another After
    delay, in a loop back to its own variant, becomes Bricks' Slider (Nestable), one slide per variant, pausing under
    the mouse. Bricks' interval is Figma's wait plus the change's duration (Justin confirmed); arrows and dots drawn in
    every slide become the slider's own.
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
    - **Words on one line, Figma's width** (2026-10-21, W1A, E1A): a button's words stay on one line as Figma draws
      them, and above phones a button keeps Figma's width.
    - **An accessible name on every CTA** (the designer, through Justin, 2026-11-04; ⭐ Q1A/Q2A not yet confirmed;
      HANDOFF "CTA names"): its visible words (a trailing arrow dropped), "<words> about <card title>" when they name
      nothing; in `link.ariaLabel` when linked, an `aria-label` custom attribute when not, none inside a link
      (`understand/cta-names.ts`, `emit/cta-names.ts`).
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
    - **A strip Figma leaves unclipped runs on to the window's edge** (DJ Trees designer note 12, 2026-11-02; the
      planner's ⭐ answers under Justin's "whatever the planner agent recommends", not yet confirmed): from 992 up its
      cards run on to the window's right edge with the first card where drawn and scrolling stops at the page margin;
      this replaces 30.7's "the track stays clipped at its own box" (HANDOFF "DJ Trees services strip").
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
  - **A tight row gives way to bigger words** (Justin, 2026-10-26, "Space gives way"): an exactly filled row gives
    equal gaps up to half each screen's step, then widens into column room; nested hugging rows hand growth to an
    ancestor that can decide. Without room its words keep drawn sizes and the panel names the row
    (`understand/give-way.ts`). From design width through laptops and tablets where the row stays on one line.
  - **The same space between every two sections** (Justin, 2026-10-28: "Do it for every section, like in the photo …
    including the gap between sections … every call-to-action button"; build `2026-10-28.5`): between two sections,
    the space from one section's words to the next one's is the page's section space S (the space most of its sections
    draw), stepping down like section padding, with no divider line there. A painted section keeps its padding inside
    its paint. These keep their own spacing: the page's top (its bars and the hero), painted bands that touch, tight
    strips without a call to action, and sections drawn without auto layout or at a fixed height.
    - **Buttons always get S under them** (Justin: "put it in a way where it looks more aesthetic"). A bar holding a
      call to action is never a tight strip. A section with a layer placed on it still gets S under its ending buttons,
      unless the layer would land on them or leave its edge (`understand/rhythm-buttons.ts`).
    - A page with no shared space converts as drawn (`understand/rhythm.ts`). The rulings are not yet confirmed
      (HANDOFF).
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
    - **A panel against a section's side reaches the window's side** (DJ Trees designer note 1, 2026-11-02, ⭐ answers
      not yet confirmed): above the Container's width its colour, drawing or grouped photo continues to the window's
      edge; words and buttons stay in the Container.
  - **A photo behind a section fills wider screens edge to edge** (Justin, 2026-10-30, chose "Fill edge to edge" over
    "Keep 1440, blurred sides" and "Keep as it is", after the DJ Trees hero showed black sides; build `2026-10-30.12`):
    it covers the whole width, growing with the screen, so a little more of its top and bottom is cut off. This
    replaces the 2026-10-19 rule (drawn size in the middle, fading into the section's colour). A Crop photo drawn against
    one side reaches that side of the screen, its inner edge where drawn (30.11).
  - **A side photo goes on top on tablets and phones** (DJ Trees designer note 8, 2026-11-02; the planner's ⭐ answers
    under Justin's "whatever the planner agent recommends", not yet confirmed): a section's own photo fill cropped
    against one side, fading (or not) into its solid colour with the words on the other side, stacks from 991 down —
    photo on top as tall as its drawn shape up to 480/320/360px, its lower half fading into the shade's colour, the
    words below (rule photo.stack); heroes and sections holding a placed layer keep today's look.
  - **A menu bar drawn over the first section's top scrolls with the page** (Justin, 2026-10-30, build `2026-10-30.12`):
    above tablets its content is pinned at the window's top, solid once the page scrolls; tablets and phones keep it in
    place (its menu wraps there until the phone menu is built). A painted bar only.
  - **Content Figma draws inside the 64px margin** (user, 2026-10-07; e.g. a sideways text at x=27): exact at the
    design width, hanging into the margin. From tablets down it sits inside the tier's gutter (36/16).
- **Faint outlines around pictures on a photo** (user, 2026-10-22: "a subtle white border outline around it … needs
  to be removed", then chose "Only over a photo" over "every faint photo frame" and "remove it in Figma"): a
  see-through box with a faint outline around a picture loses the outline only where it is drawn on a photo; boxes on
  plain backgrounds, filled cards and divider lines keep theirs, as drawn (`normalise/photo-frames.ts`).
- **Swapped cut-outs stay whole** (Justin, 2026-10-30: "I need this fix on all pages … It should be a plug-in fix"; he
  swaps the plugin's pictures in Bricks for his own cut-out photos of other shapes): a picture whose file has
  see-through parts and which Figma shows whole is `object-fit: contain`; solid or cropped photos keep `cover`
  (HANDOFF "Cut-outs stay whole when swapped").
- **Native Buttons by shape alone** (2026-10-06): a painted box around one short centred label becomes a Bricks Button,
  linked or not and whatever its name. Form fields (words starting at the left) and table cells (a rule on one side)
  aren't buttons. Tags and pills of the same shape may become Buttons; the user accepted that. A pill of words and one
  or two drawn SVG icons (one each side at most, beside the words, in its middle) is a Button too, its icons its
  ::before/::after from their Figma SVG (icon-buttons Q1 A, not yet confirmed; emit/button-icons.ts); inside a link it
  is a Button with no link (Q2 A). A pill under 44px whose own hover changes its icon or more than CSS draws stays a
  Div.
  - **A Button stretched wider than its content centres its words and icon** (Justin, 2026-11-04, chose "Centred": the
    phone-menu panel's "Schedule Now").
- **Every text is Rich Text except headings** (Justin, 2026-11-04, on the designer's "rich text for paragraphs": "I do
  not want it for paragraph i want it for everything"; chose in a question): Bricks Heading stays, with its tag; a text
  that is all one link is Rich Text inside a Block that carries the link in Link to (both designer notes hold); no
  Basic Text is emitted.
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
  - **The phone menu is Bricks' Nav (Nestable)** (DJ Trees designer note 2, 2026-11-02/03; the planner's ⭐ answers
    under Justin's "whatever the planner agent recommends", not yet confirmed): a bar the plugin proves is the site's
    navigation folds where its row no longer keeps one line; a bar that fits everywhere gets no ☰; a captured site's
    bar keeps the site's own layout; a frosted bar's blur moves to its ::before; built on a researched Nav sample
    (`reference/bricks/nav-nested.json`) until Justin's own copy replaces it.
  - **Photo/text zigzag rows:** photo first in every row once stacked.
  - **Photo-card slider:** one slide per view, nothing of the next card showing (the user tried a peek and dropped
    it, 2026-10-01); at most 16px between cards; stacked rows of alike cards swipe as one slider.
  - **Spacing:** one capped, whole-pixel, monotone scale: sections at most 64px top and bottom, gaps 48.
  - **Section intro on phones:** heading, text, then its button. Photo cards keep their photo's shape, two per row
    where they can't slide. Stacked items' divider padding evens out.
  - **A row split by dividers** (DJ Trees designer notes 6, 7 and 9, 2026-11-02; the planner's ⭐ answers under Justin's
    "whatever the planner agent recommends", not yet confirmed; replaces "loses the lines once it wraps, goes two per
    row or stacks, its sides even out and the space becomes its gap"): once it wraps or goes two per row it loses its
    lines and its sides even out; its points' own top and bottom even out and are the space between them, the gap only
    topping it up; once it stacks one per line a line like its dividers runs between every two points, midway between
    their words, at least 16px from each. Steps each drawing a line along their top keep it; stacked, their sides even
    out and the steps under a line line up, each line midway.
  - **Side padding** (2026-10-21, P1A P2B: "padding must look clean on any layout"): upright phones get a box's own
    side padding back after a sideways phone's squeeze; a tablet's squeeze carries on to sideways phones.
  - **Hero, photo beside text:** text, then photo, then buttons.
  - **Hero without a photo** (a colour or gradient behind its words; the user left it to what looks nicer,
    2026-10-07): its buttons stay where they are, right under its words, full width. No buttons band.
  - **Every call-to-action button is full width** on phones, cards included (not tags, floating layers, icon buttons).
  - **Stretched buttons centre their content** (DJ Trees designer note 3, 2026-11-02; the planner's ⭐ answers under
    Justin's "whatever the planner agent recommends", not yet confirmed): from 767 down a call-to-action pill Figma
    draws with its content in the middle centres its words and icon together (rule cta.center), long words wrapping
    onto centred lines; buttons drawn off-centre keep their drawing; tablets and desktops unchanged.
  - **One photo per slide.** A photo group without text splits into slides; a card with text keeps its largest photo.
  - **Footer** last on the page and centred; text and spacing: whole-pixel type, balanced headings, capped gaps.
  - **Big multi-word headings on phones** (DJ Trees designer note 11, 2026-11-02; the planner's ⭐ answers under
    Justin's "whatever the planner agent recommends", not yet confirmed): a text of two or more words is at most 72px
    upright and 93px sideways (21% of the narrowest column; one word keeps its step); one drawn at 28px+ tighter than
    line height 1 gets line height 1 from the widest tier where its words wrap into more lines than Figma drew
    (facts.ts displayCap/wrapsMore, rule type.leading).
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
  - **Faint art by a heading** (DJ Trees designer notes 4 and 10, 2026-11-02; the planner's ⭐ answers under Justin's
    "whatever the planner agent recommends", not yet confirmed): faint placed art over or near a section's heading moves
    beside the heading once the layout stacks, smaller, under the words where nothing is painted between; the words
    never move. A frozen section's (fixed height, words at its bottom) top space steps down as section padding.
- **Website rules** (2026-10-02: HTML5 semantics, WCAG 2.2 AA, search and speed basics; the user means technical
  rules, not laws). The design stays as drawn except for the two label minimums below and the section rhythm
  (Layout):
  - **The design breaks a rule** (faint text, small targets, tiny text): never recolour or resize, except Justin's
    two minimums (2026-10-26, Sai Varsha's "too tiny"): pill words at least 13px, Learn-more-style links at least 15px
    (`understand/min-font.ts`, exclusions in HANDOFF). Other text stays drawn. The design-check findings list is
    **left out of v2** (2026-10-06).
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
- **A text that is all one link carries it in Link to** (the designer Niklas, through Justin, 2026-11-04; ⭐ answers
  not yet confirmed): email `mailto:`, phone `tel:`, a whole Figma link or page link go in the element's Link to
  (External URL), never as an `<a>` in its words; a link inside a sentence stays inline; headings too
  (`understand/text-link.ts`, `elementLink(ir)`).
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
    count as the designer's link, like typed-address ones: their card gets no whole-card link and a pill whose words
    are wholly the designer's link is a Button carrying it (icon-buttons Q3 A, not yet confirmed).
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
- **Footer destinations** (Justin, 2026-11-04, option A): belonging to a footer column never supplies a destination;
  unauthored labels stay plain with one note per included affected Figma design. Source element/text/ancestor links,
  captured hrefs and existing independent contact/social/arrow/go-word rules keep their own policy; structural
  membership, headings and omission remain. Genuine page labels need a link in Figma or Bricks.
- **The site's own header and footer** (user, 2026-10-20: "if there is already a header and footer in bricks then the
  plugin will remove the header and footer"):
  - **Asking:** two ticks in the panel (chosen over asking on every Convert), remembered per WordPress site since
    2026-10-23 (a file that never saved ticks takes the connected site's). Every Convert says where the header and
    footer went, in red when the paste may double the site's.
  - **The room under the site's header:** measured by a script (chosen over Figma's header height). The site's header
    is `position: fixed` (Bricks' Sticky header too), so it takes no room of its own.
  - **Which bar is the header** (Justin, 2026-10-29, "Careful rules"; build `2026-10-29.3`): new behaviour only where a
    bar is clearly a site header (a call bar ending in its ☰; a drawn logo, a menu of 4+ and a call to action; a logo
    and its ☰); everything else converts exactly as before. A call bar right over a plain nav bar is one header
    ("Both are the header"). Wanted, not built: a picture, four short items and a button right under a call bar is
    the main header too ("Main header, as before", follow-up; HANDOFF header-bar review 8).
- **Social icons link to the business's profiles in Yoast SEO** (Justin, 2026-10-30, chose "From Yoast" over a panel
  box or links set in Figma; build `2026-10-30.20`): the panel reads Yoast's Other profiles when connected and saves them
  in the file; small icons named after a network link to them. HANDOFF "Social icons link".
- **Fonts not on Google Fonts** (user, 2026-10-20: "the fonts will be put on WordPress automatically like a drag
  them"): files, a folder or a .zip dropped on the panel go to WordPress's own Font Library (`wp/v2/font-families`),
  chosen over Bricks Custom Fonts (admin-ajax only, not in REST) plus a helper plugin. It needs an Administrator's
  Application Password. Every paste carries `@font-face` rules for the design's families, after Google's.
- **Videos** (user, 2026-10-19: "just do what v1 did"): an address in the layer name (`Video: https://…`) or an Open
  link to a video makes Bricks' Video, muted and looping where it is a background behind words. Without one, the
  panel finds the file in WordPress Media by its exact name, or the user chooses it in the panel's Videos box.
- **Website captures** (Justin, 2026-11-02, on the capture plan, confirmed; HANDOFF "Capturing a live page"):
  - **A part's own fixed content stays in its part** (AC4, "Keep it in the Header"): a sticky header bar stays inside
    its part's root, marked `web.position: "fixed"`; every other fixed box (chat bubbles, plugin buttons, the site's
    own call button, cookie bars) goes to the footer part's floating extras.
  - **bdryswi.com's pages are a live check owed to him** (AC14/AC15, "Mark it mine, merge now"): its bot check stops
    every automated Chrome, so every sitemap page is captured and checked only once he allow-lists the capture; AC14
    covers the other corpus sites' homes.
- **The website importer copies the site's own code** (Justin, 2026-11-04: "I want a method that can help us get one
  to one, not relying on photos or images but actual code"; method review
  `~/.hermes/plans/figma-to-bricks/evidence/method-review/report.md`): a site's elements, classes and CSS rules go into
  Bricks as they are; the measured-box route through the Figma converter is retired for websites once the whole page
  passes.
- **Code-method class names start with the page's name** (Justin, 2026-11-07, "Never use bare names", then "Prefix
  every name"): `<page>__<name>`, only `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` keep theirs; a static
  slider keeps all its slides ("Keep all its slides").
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
  styles → global classes, debug file. **Deferred** (2026-10-06): tablet designs (a third drawn width), the audit
  list, masks, and v1's Figma timer loops that slide logos. Don't build these unless the user asks.
- **Unverified in Bricks:** anything not in `reference/bricks/`. Check it with a paste-and-copy-back round trip first:
  custom tags, `_attributes`, `_cssId`, `link.newTab`, `display: contents`, `%root%` in custom CSS, Block
  `tag: "nav"`, Image `altText`/`loading`, and `aria-*`/`fetchpriority`/`tabindex` attributes.
  - Also unverified:
    - `_flexDirection` and `_gap` on non-layout elements;
    - the Colors import of the panel's palette file;
    - a palette reference whose `raw` carries a fallback (`var(--x, #HEX)`).
