# Figma to Bricks v2: older Status build entries (lines moved whole from the project CLAUDE.md Status)

## Older builds

- **Current build `2026-11-10.1`** (read `src/shared/build.ts`; another session may have bumped it). The latest
  features, each with its HANDOFF section:
  - **2026-11-08.1 elementor-map (website importer):** with `--elementor`, `npm run site`/`site:check` fold Elementor's
    wrappers so each Elementor element is one Bricks element, and Elementor's and ElementsKit's FAQs become one Bricks
    Accordion (Nestable) that opens and closes like the site, within 2 px at every width (B-Dry's FAQ 0 px at 39 widths);
    the capture keeps hidden parts of shown elements; without the flag pastes are as before. Paste check **3dk** (AC9,
    AC10, live).
  - **2026-11-07.1 web-code-page (website importer):** the code method pastes a captured page whole: header, page and
    footer by the site's own elements, classes and CSS, within 2 px at every width (B-Dry 1.09 px at 53 widths), alt
    text and page-builder markers kept, bold and italic as on the site; every class starts with the page's name
    (`home__…`) but `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` (Justin, 2026-11-07, "Prefix every
    name"); a site's CSS animations stay still (no `@keyframes`; site-motion, 2026-11-09.1, carries them). Paste
    check **3di** (AC12, AC19, live).
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
