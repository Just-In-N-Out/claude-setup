# Figma to Bricks v2: instructions for every agent

**Status and history:** `docs/HANDOFF.md` (newest first: every feature's section with its rulings, paste check and
follow-ups) and `docs/plans/<date>-<name>.md` with its `-ledger.md`. This file keeps only the current status and the
standing rules. **Don't add build narratives here:** a feature's details go in HANDOFF and its ledger. Only the build
line, one line per new feature, a new standing rule, a user decision or a gotcha every agent needs comes here.

## Status (2026-11-18)

- **Current build `2026-11-23.1`** (read `src/shared/build.ts`; another session may have bumped it). The latest
  features, each with its HANDOFF section:
  - **2026-11-23.1 header-template (website importer):** besides the capture's fixed mark, a header box gets the stay
    class when Elementor's `sticky: "top"` (no `sticky_parent`) is set or a script wrote its `position` and `top` in
    any range, and the site's own CSS fixes none (`src/core/site/stay.ts` `headerStays`), so B-Dry's home and About
    headers stay at the top too; `#brx-header:has(.stay)` at z-index 998 so the ☰ drawer in a Header template opens
    above the page; the note names the template steps; the importer app's "Header only (for a Header template)" tick
    passes `--part header` (only `header.json`, Copy header only, only the header's pictures uploaded); Make pastes
    again on saved scans, no rescan; pastes that already had the stay class get a renamed class. Q1–Q5 ⭐ A not yet
    confirmed. Paste check **3ft** (AC5, live: tick Header only, Make pastes again or scan, Copy header, paste into a
    new Header template on B-Dry staging, Conditions: Entire website, Sticky header off; on a live page in a private
    window it stays at the top at desktop and phone, ☰ opens the drawer over the page).
  - **2026-11-20.3 tablet-photo (website importer):** a flex row of words + one library-photo box whose photo shows
    under a third of its picture at every measured width 768–991 stacks in Bricks' Tablet portrait tab (rule T,
    `src/core/site/tablet-photo.ts`: Direction column, the photo full width at its picture's Aspect ratio, cover), so
    B-Dry's Basement Waterproofing "Installation Process" and "Materials Used by BDry®" cards show the whole photo
    under the words; the logo card stays; desktop and phones unchanged; the rows' shared class moves to each row's own
    class; `site:check`/`site:live` name a stacked row "stacked at Tablet on purpose"; `ConvertOptions.tablet: false`
    byte for byte as before. Q1–Q5 ⭐ A and builder rulings B1–B3 not yet confirmed. Paste check **3fs** (AC5, live:
    remake the Basement Waterproofing pastes, paste the body on B-Dry staging; at Tablet portrait both cards show their
    words full width with the whole photo under them, Desktop unchanged).
  - **2026-11-20.2 photo-repeat (website importer):** a box whose only content is its own library photo, drawn at a
    size of its own and repeating, is a Bricks Image when one tile placed as the site places it covers the box at every
    measured width within 0.5 px (`photo-place.ts` `oneTile`, `photo-box.ts` `rangeWhy`): B-Dry's Basement
    Waterproofing "Photo"s (Media 301, 302) are Images with Media's alt; a repeat that shows, `space`/`round`, auto/em
    sizes, a painted border or no measured box stay Blocks with today's notes words; every other paste byte for byte
    as before. Q1–Q3 ⭐ A and builder ruling B1 (all-or-nothing across ranges) not yet confirmed. Paste check **3fr**
    (AC5, live: remake the Basement Waterproofing pastes, paste the body on B-Dry staging; both "Photo"s are Images
    with Media's alt, looks as before at 1440 and 991).
  - **2026-11-20.1 reviews-show (website importer):** a live third-party widget the importer pastes as a Code element
    (B-Dry's Trustindex reviews) now has Bricks' Hide in builder on, followed by one Block "`<host>` widget: editor copy
    (not on the live page)" with Hide on frontend holding the scan's still copy, so the widget shows in the Bricks
    editor and only the live widget on the live page (`src/core/site/editor-copy.ts`); B-Dry's footer +404 elements,
    ~136 KB; `ConvertOptions.editorCopy: false` byte for byte as before. Q1–Q4 ⭐ A and builder rulings B1–B5 not yet
    confirmed. Paste check **3fq** (AC5, live: remake the home pastes, paste the footer on B-Dry staging, Regenerate
    code signatures once; the reviews show in the editor, the live page shows only the sliding widget).
  - **2026-11-18.3 phone-gutter (website importer):** on phones (767 px and down) the box holding words gets Phone-tab
    Padding by what its words lack to keep 16 px from each screen edge, never Custom CSS (rule G,
    `src/core/site/gutter.ts`); a column with a picture or painted box to the edge, a non-px padding, right to left or
    a range across 767 stays as the site's, named; drawers and pop-ups not read; `ConvertOptions.gutter: false` byte
    for byte as before. Q1–Q6 ⭐ A and the builder's rulings B1–B4 not yet confirmed; AC2/AC4 test wordings Justin's
    "Merge as built". Paste check **3fp** (AC5, live: remake the home pastes, paste the body on B-Dry staging; on a
    phone every block of words keeps at least 16 px from both edges).
  - **2026-11-18.2 phone-paragraph (website importer):** every importer Rich Text of 60+ characters carries the shared
    class `site-pretty` (`text-wrap: pretty` from 991 px down; rule P, `src/core/site/pretty.ts`), so B-Dry's "This
    exciting…" paragraph no longer ends on a lone "limitless." on phones (same height); a box in a flex row the site
    typed a px or % width with `min-width: 0`, holding only words, takes Min. width `min-content` (rule W,
    `src/core/site/word-floor.ts`, one notes line per part), so "Why [logo] Works" no longer splits "Wh / y" where a
    device draws a wider font; `ConvertOptions.pretty`/`floor: false` byte for byte as before. Q1–Q5 ⭐ A and builder
    ruling B1 (Min. width takes `min-content` as a setting) not yet confirmed. Paste check **3fo** (AC5, live: remake
    the home pastes, paste on B-Dry staging; on a phone the "This exciting" paragraph has no lone last word; at Tablet
    portrait and phone "Why BDry Works" keeps its words whole).
  - **2026-11-18.1 media-reuse (website importer and Figma plugin):** a picture either tool is about to upload that the
    site's Media already holds (put there for another page, by either tool, from this computer or another) is used
    from there: no second upload, alttext.ai not asked, Media's alt text kept; every upload carries its mark as its
    media item's slug (`f2b-<the file's SHA-256, 32 hex>[-<how>]-image`; the command line's AVIF by its source file's,
    the panel's mark for "Photos as: AVIF"), found by `GET wp/v2/media?slug=` (50 marks a read, the typed site only,
    before the typed yes); the panel's notes count "found in your media library" (a read that fails is one notes
    line), its Picture descriptions row is tagged Media; `site:upload`/`site:import`/the app list "N pictures already
    in Media, used as is" with Media's alt before the yes, and fill an empty Media alt with the old site's words after
    it, only on an item the tool put there whose file still matches; words a person typed still replace Media's, AI
    words go only where Media has none; Decorative empties Media's alt only for a picture this conversion uploaded; a
    run that reuses nothing byte for byte as before; uploads from before this build carry no mark (sent once more).
    Q1–Q7 ⭐ A not yet confirmed (Q3/Q4 narrowed by Justin's "Fill it from the old site" and "Yes, clear new ones").
    Paste check **3fn** (AC22, live: `npm run importer`, a B-Dry page sharing the logo and badges with one imported
    with this build → Pictures to WordPress → Log in and check: on the computer that imported the first page: the
    question counts the shared pictures 'already in your library' and Media holds them once; from the Mac: the
    'already in Media, used as is' list; in Figma another file's row tagged Media).
  - **2026-11-17.5 link-keeps-name (website importer):** when the importer folds a wrapper box into the one element it
    holds (rule N, the Elementor fold), a link, button, heading, role named by its words or picture with an alt that has
    a name of its own at every width it shows in keeps it: the wrapper's `aria-label` lands only where the element has
    none (an icon-only link, a plain box, a picture with no alt), a wrapper role that would take the words away is left
    out with it, the wrapper's `title` still goes down (rule L, `src/core/site/names.ts` `handDown`); one notes line per
    part names what was left out; every other paste byte for byte as before (B-Dry's six scans: 36 parts, 0 differ);
    the Figma plugin unchanged. Justin's "Link keeps its words" (2026-11-16); Q1–Q4 ⭐ A not yet confirmed. No paste
    check owed (none of his scans holds the shape).
  - **2026-11-17.4 clean-values-2 (website importer and Figma plugin):** a value a Bricks control holds is that control
    at its tab and state, not Custom CSS: on importer pastes Typography (font style, letter spacing, decoration, one
    text shadow), Layout (visibility, pointer events, isolation, blend mode, aspect ratio, the grid keys), Transform and
    its origin, a box shadow's inset, a library picture's position, repeat and attachment, one linear gradient as
    Background → Gradient, the four transition longhands as one Transition per tab, and the element's own `:hover` and
    `:focus` looks (colour, background, opacity, cursor, border colour, shadow, transform) as Bricks' state settings; on
    Figma pastes a tier shape as the tab's Aspect ratio, an overlay's Isolation, a Button's icon Gap, a picture's fit
    and place, a whole-degree gradient (a drawn shape's too) as Gradient; every length a setting holds is its shortest
    equal formula (`calc(calc(100vw - 32px) - 0px)` → `calc(100vw - 32px)`, `25.999923px` → `26px`); clicks answered by a
    control on his five scans 77.7% → 91% (0 of 63,893 readings differ, both Bricks versions), Custom CSS share
    hydraulics 26% → 23%, GRO 63% → 50%, nothing draws differently; no property is both a setting and Custom CSS or
    held by two classes of one element, states included (a shared look's own state sits on the look class only); a
    keyword that says nothing leaves, but a copy's own value stays on the copy and a form control's `inherit` stays; a
    Figma Button's look stays in its class's Custom CSS (Q1 A, Justin's "Keep as today": with Style empty the Theme
    Style repaints it); each part's notes and `styles.txt` name the Custom CSS that stays by kind;
    `ConvertOptions.clean: false` (`asBefore.clean`) byte for byte as before; a `:focus` state key shows only while the
    site's Bricks pseudo-class list holds `:focus`. Q2–Q8 ⭐ A and the builder's and fixers' rulings not yet confirmed.
    Paste check **3fm** (AC18, live: `npm run importer` → home scan → Make pastes again → paste on B-Dry staging, and a
    Figma page converted onto darksalmon; click a Heading, Button, Section and card: Typography, Layout, Border,
    Background, Transition show the numbers at Desktop, Tablet and Phone; `:hover` shows the Button's hover colour;
    looks as before at 1440 and 390; Custom CSS holds only the leftovers the notes name).
  - **2026-11-17.3 saved-password (website importer):** the first time WordPress accepts a login, `site:upload`,
    `site:import` and the importer app's Pictures to WordPress save the Application Password on this computer in
    `~/.config/figma-to-bricks/site-passwords.json` (0600, the folder 0700, only your own user can read it; one entry
    per site and user name), said in one line; later runs to that site ask no user name and no password, only the typed
    `yes`, naming the saved one by its last four; `--new-password` (the app's **Replace**) asks again and saves the
    typed one once accepted, `--forget-password <site> [--user <name>]` (the app's **Forget**) removes it, sending
    nothing; a refused saved one is asked for again once; one saved login covers an Upload together run of up to three
    ticked scans (one login, one yes); with one saved the app's upload request holds no password and the command reads
    the file itself; the password never goes in an argument, an environment variable, the record, the capture, a
    paste, a log or a printed line; a link, another user's or an unreadable file is named and left as it is;
    `--dry-run` reads no saved file; pastes and `media.json` byte for byte as a typed login's. Q1–Q6 ⭐ A (a 0600 file,
    not the keyring; one entry per site and user; saved after the first accepted login; Forget plus
    `--forget-password`; a saved user name used without asking; a refused one kept until a typed one is accepted) not
    yet confirmed. Paste check **3fk** (AC17, live: `npm run importer`, Pictures to WordPress on B-Dry staging, type
    the password once and `yes`; Log in and check again asks only the `yes`, step 3 shows "saved on this computer
    (ends in …)"; Forget brings the password box back).
  - **2026-11-17.2 mobile-fit (website importer and Figma plugin):** an importer paste fills a box the old site types
    short of a column it fills on wider screens (B-Dry's home FAQ, `width: 349px` from 767 down: Width 100% in that
    Bricks tab on its class, max/min-width kept, named in the part's notes), unless its only-child chain ends in one
    thing sized by its own content (words, picture, icon, video, field, button or link, a divider's line), which keeps
    its typed width; `site:check`/`site:live` list a filled box and what it holds as "wider than the site on purpose"
    and measure what follows from where its holder ends (B-Dry's home equal to main at all 48 widths); the plugin's
    rule R3 (`normalise/infer-pair.ts`) flows a frame drawn without auto layout whose only two layers are a words frame
    over a faint decoration (brainstorm's "05 · The alreadys" and "12 · Ready to GRO?" no longer 96 px off the screen);
    every other paste byte for byte as before (`ConvertOptions.fit: false` too). AC6 amended with Justin's go ("Yes,
    skip it": a single word the old site itself draws past the window, "Waterproofing", is excepted); Q2–Q3 ⭐ A and the
    builder's and fixer's rulings (B1–B3, fixes R1-1, R1-2) not yet confirmed. Paste check **3fl** (AC11, live:
    importer app → home scan → Make pastes again → Copy body → paste on B-Dry staging; at Phone and Phone sideways the
    FAQ reaches both edges of its column, Width `100%`; on a phone no paragraph runs off; brainstorm from Figma on
    darksalmon, its two sections' words stay on screen at tablet and phone).
  - **2026-11-17.1 multi-page-scan (website importer):** `npm run capture -- <a> [<b> [<c>]] [--folders]` and the
    importer app's Scan (one address per line) read up to three pages of one site in one run, one after another, the
    person check pressed once, each page in a folder of its own with its pastes; a failed page is named ("scan it again
    by itself") and the rest kept; `site:upload … --also <capture> <outDir>` (at most two) and the app's Saved scans
    "Upload together" ticks (up to three; a 4th refused) upload them with one login, one alttext.ai key question and
    one typed yes counting each file once, each folder getting its own media.json, forms.json and pastes, each page
    remade with its own scan's options; `site:import` stays one page; one page byte for byte as before. Q1–Q4 ⭐ A and
    the builder's B1–B7 not yet confirmed. Paste check **3fj** (AC18, live: `npm run importer` from his terminal, type
    three B-Dry pages not yet done, Elementor and "This is my client's site" ticked, Scan, pass "I am human" once,
    Pictures to WordPress → Log in and check → yes once, paste each page into its Bricks page on B-Dry staging; each
    looks as on bdryswi.com at 1440 and 390, Media shows no picture twice).
  - **2026-11-16.9 tier-spacing (website importer and Figma plugin):** an importer paste writes padding, margin, gaps,
    font size, width, direction, position and every other value a Bricks setting takes in Bricks' Desktop, Tablet,
    Phone sideways and Phone tabs (each tab what its breakpoint draws: 991, 767, 478), a logical side renamed physical
    only where the writing direction is proven and the side then is a setting (a formula, a range leaving it out or a
    negative side keeps the site's name in Custom CSS); where the old site changes between Bricks' breakpoints (1024,
    921, 1366) one short `html:root .<class>` band on the class holds it, named in a `Breakpoints:` note and in
    `styles.txt`; the plugin's generated tablet spacing lands on whole 4s (R5, at most 2 px), so GRO's four "Row" rows
    stay on one line at tablets, their Phone minimum widths and row gaps as Justin approved (AC13 amended twice); every
    paste draws as before, `ConvertOptions.tiers: false` byte for byte as before; a Figma look class holding a tablet
    step arrives under a new name on a re-paste. Q1–Q8 ⭐ A and the builder's rulings not yet confirmed. Paste check
    **3fh** (AC14, live: remake B-Dry's home pastes, paste on B-Dry staging and one converted Figma page on darksalmon;
    press Desktop → Tablet → Phone sideways → Phone: the spacing looks right at each, a Section's Padding shows in Style
    → Layout at each tab, a typed value changes the canvas).
  - **2026-11-16.8 internal-links (website importer and Figma plugin):** a Button, Text link, Heading (a whole-link
    Heading carries it in Link to) or linked box whose link goes to one of the new site's pages pastes as Link to →
    **Internal** → that page, so it follows the page when its address changes; the importer reads the site's page list
    and homepage setting after the login (`site:upload`, `site:import`, the importer app; GET only, only when a paste
    links to a path of the site) and writes `pages.json` beside `media.json` (`npm run site … --pages`, "Make pastes
    again" remake offline); the Figma panel with WordPress connected turns every link relink sends to a matched page
    into its Internal link (a "Home" link to Settings → Reading's homepage page); a page the site lacks, a link in a
    sentence's words, another site, `#`, `tel:`/`mailto:` keep their address, named; a linked picture keeps Other (URL)
    (an Image's Internal link unproven until his copy); every paste with one names its site in `sourceUrl` (Bricks
    empties an Internal link pasted elsewhere); without a pages map, and the plugin's conversion (= replay), byte for
    byte as before. Q1–Q6 ⭐ A and the builder's and fixer 1's rulings not yet confirmed; his copy of a Button's
    Internal link wanted (Q7). Paste check **3fg** (AC12, live: importer app → home scan → Pictures to WordPress → Log
    in and check → yes → Copy header and body → paste on B-Dry staging; a "Contact Us" Button and a drawer menu word
    show Link to → Internal → the page, the logo Other (URL) `/`; looks as before at 1440 and 390).
  - **2026-11-16.7 photo-image-all (website importer):** a box whose only content is its own library photo is a Bricks
    Image in two more cases: the site draws the photo at a size of its own (`383px auto`, `50% auto`, `120px 90px`…)
    placed at a side's start, centre or end, or places it in three or four words or with `calc()` on a fit
    photo-box-image took; B-Dry's Tri-State map (home, `383px auto` from 767 px down) is an Image now (home 3 Images,
    none left); it draws exactly as the box did (every element and the picture's rectangle within 0.5 px), the picture's
    size on the Image's class Custom CSS at ` > img` (named in the Bricks Images note: a Width typed on the Image sizes
    the box, not the photo); a repeat at a size of its own, another `%` or `calc()` place, a `calc()` size and a padding
    written by two names stay Blocks, named; pastes without such a box byte for byte as before. Q1–Q3 ⭐ A and the
    builder's R1–R5 not yet confirmed; AC7 amended with Justin's go ("Swap it": the map's pixels printed, geometry
    asserted). Paste check **3fd** (AC8, live: importer app → home scan → Make pastes again → paste on B-Dry staging;
    click the map: Content → Image shows `bdry-map-1-image.avif`; looks as before at 1440 and 390).
  - **2026-11-16.6 bw-colours (website importer):** a scan records the size each background picture came at
    (`web.natural`: a file fetched as written by its own size, a resized copy such as Jetpack's `?fit=768,1024` measured
    as the page loads it, an SVG or a picture it can't measure none, named); with a media map a background the site drew
    at its file's own size pastes at that size, Style → Background → Size **Custom** (`768px 1024px`; a layer or
    layered value in the class's custom CSS), so B-Dry's Basement Waterproofing band no longer tiles the full-size
    rafters photo 2.5 times too big; a size the site wrote itself, an opened box's backgrounds and pastes without a
    media map stay as before; older scans paste byte for byte but one notes line per part naming those photos (scan
    again); the header bar's changing gradient is the site's own 8 s animation, not a bug. Q1–Q2 ⭐ A, the planner's
    R1–R4 and the builder's B1–B4 not yet confirmed; AC5 amended with Justin's go ("Compare with main"). Paste check
    **3ff** (AC6, live: in the importer app scan bdryswi.com/basement-waterproofing/ again, Make pastes, upload, paste
    on B-Dry staging; at 1440 and 390 the band shows the rafters at the site's size, Background Size Custom
    `768px 1024px`, the header gradient moves as the site's).
  - **2026-11-16.5 site-fonts-import (website importer):** with `--fonts` (`site`, `site:upload`, `site:import`, the
    importer app's option) a family the site serves itself is written to `fonts/` with its own bytes and `fonts.txt`
    steps for Bricks → Custom Fonts (a person adds them; Bricks has no REST route), and every paste names the plain
    family in Typography (no page-named copy, no font file inside the paste); icon fonts, weight ranges, subsets, otf,
    angled oblique and older captures stay as before, named; a face that never loaded stays one `@font-face` line in
    the fonts class, named in `fonts.txt`; without `--fonts` byte for byte as before. Q1–Q8 ⭐ A and the builder's
    rulings B1–B7 not yet confirmed. Paste checks **3fb** (AC11, live: his own `site:import … --elementor --fonts` on
    B-Dry staging, add the fonts per `fonts.txt`, reload the builder, paste; Typography shows Roboto; in a private
    window the words are the site's Roboto, not Google's) and **3fc** (AC12, live: change one shared text class's
    font and back).
  - **2026-11-16.4 logo-media (website importer):** with a media map, the Elementor step's linked pictures (the Site
    Logo, a linked Image: B-Dry's header logo ×3, the footer logo and the two partner badges) paste as their Media item
    (id, the library's alt; Custom alt text only where the old site's differs), Link to and new tab as before; pastes
    without a media map byte for byte as before. Q1 ⭐ A not yet confirmed. Paste check **3fe** (AC7, live: importer
    app → home scan → Make pastes again → paste the header into B-Dry staging's Header template and the footer; click
    the logo: Content → Image shows the Media item, Link to still `/`).
  - **2026-11-16.3 site-sticky-cards (website importer):** boxes Elementor's sticky setting pins while the page
    scrolls (B-Dry's service-page cards that stack) paste with Bricks' own Position: Sticky, Top and z-index on the
    card's class at the widths the site pins them (no Code element); a page-wide guard class keeps the document from
    clipping them; the last card of a stack lets go by its parent's bottom padding sooner (50 px on B-Dry), named;
    cards that are copies share one class (Top on the element moves one); a box under a wrapper that hides overflow
    stays as before, named; pastes without such boxes byte for byte as before. Q1–Q8 ⭐ A and the builder's rulings
    not yet confirmed. Paste check **3fi** (AC13, live: scan a service page such as Basement Waterproofing again, Make
    pastes, paste on B-Dry staging; at 1440 and 991 the cards stop at the top one after another as on bdryswi.com; on
    a phone they scroll).
  - **2026-11-16.2 photo-box-image (website importer):** a box whose only content is its own library background photo
    (B-Dry's truck, About's "Who We Are", the drawer photo) pastes as Bricks' Image (`figure`) showing that Media item
    under Content → Image with the library's alt, drawn as the box did; a box that paints, holds words, a hover or
    per-tier photo or a link stays a Block, named; the looks, palette and class names around it are decided as if it
    were still its box. Q1–Q4 ⭐ A and the builder's rulings not yet confirmed; AC3's one-pixel photo edge amendment
    Justin approved. Paste check **3ex** (AC9, live: in the importer app pick the home and About scans → Make pastes
    again → paste on B-Dry staging; click the truck and the "Who We Are" photo: Content → Image shows the Media photo;
    looks as before at 1440 and 390).
  - **2026-11-16.1 offcanvas-wave (website importer scan):** after each press that opens a box (a ☰ drawer, a pop-up)
    the scan waits while a stylesheet the press asked for is on its way (Elementor's `dialog.min.css`; 0.5 s more per
    opened box per width range, at most 15 s) and reads the box's place again with it, so the ☰ drawer no longer pastes
    in the top right corner with its × in a strip at laptop widths; a range where the site refused that stylesheet takes
    the nearest range's reading, named; saved scans paste byte for byte as before (B-Dry's need a new scan). Q2–Q4 ⭐ A
    and the builder's R1–R5 not yet confirmed; the wave in About's drawer is an open suspicion (Q1, his copy of the
    Offcanvas wanted). Paste check **3ey** (AC7, live: rescan bdryswi.com's About Us and paste the header, the ☰ drawer
    sits at the right with its wave at laptop width).
  - **2026-11-16.1 about-form (website importer):** a folded Elementor text widget (a text editor of two or more
    paragraphs) no longer takes its holder's `height: 100%`, so its column no longer breaks in two on phones (About Us'
    "Who We Are" paragraphs sat to the right of the heading, cut off, 563 px off at 767; now under it, as on the site);
    About Us holds no form (the planner's finding: its scan has no WPForms markup); 4 of About's classes and 5 of
    home's change only by that height, arriving as new classes on a re-paste. Q2 A not yet confirmed; which thing "the
    form on the right" was is a question for Justin. Paste check **3ez** (AC5, live: remake About Us, "Who We Are"
    stacks under its heading at phone width).
  - **2026-11-16.1 wave-code (website importer, words only):** Bricks 2.4.2's editor window of unsigned code put one Code
    element's drawing into another when Sign all was pressed again while it worked (About's drawer: close, close, wave,
    wave, phone); `site:import`'s next steps and the importer app's line under its Copy buttons now say press Sign all
    one time only and wait, or sign from Bricks → Settings → Custom code → Regenerate code signatures; no paste changes
    by a byte. Q1 (did he press more than once?) his; Q2–Q4 ⭐ A not yet confirmed; a report to Bricks is ready for him
    to send (`evidence/wave-code/planner/bricks-bug-report.txt`). Paste check **3fa** (AC5, live: after pasting, sign
    once and every drawer Code element keeps its own drawing).
  - **2026-11-15.7 native-widgets (website importer and Figma plugin):** inside a box a button opens (a ☰ drawer, a
    pop-up), a box holding only sliding `details` lists of one slide CSS can play (B-Dry's "Services", Elementor's
    Nested Accordion) pastes as Bricks' Accordion (Nestable) › Item › Title / Content, the slide's time in Transition,
    Independent toggle on, one class `<page>__list-slide-<4>` with only the curve and reduced motion, no Code element
    (`src/core/site/list-accordion.ts`, rules R1–R5; any other list keeps its script, one note why); every Code element
    left is labelled by what it is ("Widget", "List slide (script)", SVG, Embed…) and each part's notes end with one
    **Code:** line (how many, which hosts, Regenerate code signatures, live page and Preview only); Figma pastes byte
    for byte as before, its card arrows and lists now named in the notes. Q1–Q10 ⭐ A and the builder's rulings not
    yet confirmed. Paste check **3ev** (AC10, live: scan bdryswi.com, paste the header on B-Dry staging, Structure
    shows the Accordion in the menu, "Services" slides as on the site at phone width, Transition 1000 slows it, the
    footer's reviews a Code element "Widget").
  - **2026-11-15.7 page-faq-slide (website importer):** a scan presses each list of questions in the page once at its
    end (under the press guard) and records how it opens (`web.code.lists`: time, curve, or at once, one at a time or
    not); the paste makes it Bricks' Accordion (Nestable) with that time in Transition, Independent toggle where the
    site lets several stay open (else from a Nested Accordion's setting, else the details' names), the answers open at
    load in Expand item indexes, a slide class with the curve and reduced motion (`src/core/site/list-timing.ts`); a flex
    or grid answer sits whole in Bricks' Content Block; B-Dry's Sump Pump FAQ is now an Accordion, the home FAQ slides
    at 350 ms; an aria list closed by a height of 0 with no title open, a list with a gap between title and answer
    (a question for Justin) and a capture saying nothing stay as they are, named; older scans byte for byte but a
    Nested Accordion on the Elementor route. Q1–Q9 ⭐ A, the builder's rulings and the importer-parity toggle order not
    yet confirmed. Paste check **3ew** (AC9, live: scan the Sump Pump page, paste on B-Dry staging, the FAQ an
    Accordion sliding as on bdryswi.com, Transition 1000 slows it; the rescanned home's FAQ Transition reads 350).
  - **2026-11-15.6 look-grouping (both tools):** copies of one button, heading, text, card or box share one class (by
    the same Figma component or the site's own class names where they tell, the same words and link, or the same look
    at the design width; at most two kinds of setting differ) even where a copy differs a little; the copy's real
    difference stays on itself (its own setting or `#brxe-<id>` Custom CSS), never a second class, so changing the
    class changes every copy and every element draws as before; a class is named by its look (`button-<4>`,
    `home__button-<4>`), the same on every page; a copy's own library background photo is its element's Background →
    Image setting; `npm run replay` and `styles.txt` list the copies and what each keeps; copies off
    (`ConvertOptions.copies: false`, `asBefore.copies`) byte for byte as before. Q3 A is Justin's; Q1, Q2, Q4, Q6, Q7
    ⭐ A, the builder's and fixer G3's rulings not yet confirmed (Q5 replaced by his "By look, same everywhere"). Paste
    check **3eu** (AC23, live: B-Dry's home with `--elementor` on staging, the three "Schedule An Inspection" Buttons
    follow one class's padding, the copy keeps its gradient; hydraulics from Figma on darksalmon, every "Call Us Now"
    follows its class's background at 1440 and 390).
  - **2026-11-15.5 forms-wpforms (website importer and Figma plugin):** a scanned page's WPForms form (shown or inside a
    box a button opens) pastes as one Bricks Shortcode element "WPForms form" (`[wpforms id="N"]`, one class) and the
    importer writes `wpforms-<title>.json` beside the pastes (the form's fields with the site's own ids, send text, a
    notification to `{admin_email}`, reCAPTCHA where it had one, its look as WPForms' theme, the rest on the class);
    Justin imports it (WPForms → Tools → Import); `site:upload`/`site:import` read the site's WPForms form list (GET
    only) for the number and write `forms.json` (`npm run site … --forms` remakes offline); the Figma panel's "Forms
    become: Bricks form / WPForms" (starts on Bricks form, byte for byte as before) makes the same element and file from
    a drawn form, with "Save WPForms file" and "WPForms form number"; pastes without a WPForms form byte for byte as
    before. Q1–Q10 ⭐ A and the builder's and fixers' rulings not yet confirmed (the AC6 textarea line-height amendment
    Justin approved). Paste checks **3ek** (AC17, live: `site:import` a bdryswi.com page with the contact form against
    B-Dry staging, import the file when asked, paste, compare on desktop and phone, send a test message) and **3el**
    (AC18, live: in Figma "Forms become: WPForms", save and import the file on darksalmon, paste, compare at the design
    width, send a test message).
  - **2026-11-15.4 site-headline-marker (website importer):** with `--elementor`, an Elementor Pro Animated Headline of
    style Highlight (B-Dry's red circle round "60 Years") pastes as one Bricks Heading, its words in the Text field with
    the marked words in `span.f2b-mark`, and one purpose-named class (`<page>__marker-<4>`) drawing the site's own
    drawing round the span and holding Bricks' own Interaction (Enter viewport → Start animation `f2bMarkDraw`), so it
    draws as the headline comes into view, as on the site (all nine shapes, stroke, colour, duration, second path,
    loop); its colour one line `--f2b-mark-color: var(--color-<hex>, …)` linked to the palette; whole and still in the
    builder and under reduced motion; a rotating headline or a drawing the scan can't prove pastes as before with one
    `not a marked Heading:` note; B-Dry's home 22 Code elements (was 23), everything else byte for byte; without
    `--elementor`, `marker: false`, the panel's website route and Figma designs byte for byte as before. Q1–Q6 ⭐ A,
    the planner's R1–R5 and the builder's B1–B11 not yet confirmed. Paste check **3et** (AC14, live: his own
    `site:import … --elementor` on B-Dry staging, import `palette.json`, paste /homev2/, in a private window the circle
    draws round "60 Years" as it comes into view at desktop and phone width; change the Heading's words and the
    marker's colour).
  - **2026-11-15.3 importer-parity (website importer):** every code-method paste keeps the site's accessibility names
    (aria-label, title, role, aria-hidden, aria-current, lang, dir, tabindex, a link's rel; never one that names an
    id), writes border, corners, one shadow, position and offsets, z-index, overflow, the flex item values, opacity,
    cursor and object fit as Bricks settings (an own hover's change as the `:hover` setting) where every value is plain
    and on Bricks' breakpoints, gives every painted Button Style: Primary, and makes Bricks' own Nav (Nestable) of a
    menu list (Mobile menu Never, the site's own phone menu), Form of a simple form (an email to the admin, never the
    old address), Video of a one-file video or a YouTube/Vimeo frame, Divider, Accordion (details in a row, ARIA lists)
    and Slider (Swiper, Splide) on any site, a FAQ, Divider or Nav alone in its Section standing in the Container's
    place (Justin's "Keep it flat"); everything else stays as before, named; every paste draws as before; Figma designs
    and the panel byte for byte as before. Q1–Q14 ⭐ A and the builder's and fixers' rulings not yet confirmed; answered:
    a link keeps its own words (link-keeps-name). Paste check **3es** (AC22, live: rescan
    bdryswi.com, import with `--elementor`, paste on B-Dry staging: looks as before, a hero button Style Primary,
    Border and Position in Bricks' fields, the ☰ named "Menu").
  - **2026-11-15.2 plugin-parity (Figma plugin):** a Figma paste holds no Div (only a picture carried inside the
    paste stays one): every frame and shape is a Block; every Section and Block is labelled by the designer's name,
    else a Section by its first words and a Block "Row", "Column", "Grid", "Box", "Shape", "Photo", "Spacer" or "Link";
    looks that repeat (text, button, box, layout) live in shared purpose-named classes (`text-…`, `button-…`, `card-…`,
    `row-…`…; `<purpose>-<4>`, id from the settings as written), decided in emit after adapt; a Button look keeps its
    font, colours, background, border, corners, shadow and padding in its class's Custom CSS at `html:root
    .<class>.brxe-button.bricks-button`, every opaque colour a palette link `var(--color-<hex>, …)`, a colour the palette
    lacks added to the palette file (the site's own colour where the export holds it); the sticky header stays with
    `overflow-x: hidden` in Additional CSS and in a Header template; looks the same with and without a Theme Style;
    the plugin = replay; website captures in the panel byte for byte as before. Q1–Q8 ⭐ A, the builder's rulings and
    Justin's "Class Custom CSS" and "Add them to palette" (2026-11-15) as HANDOFF names them; R7-1 (should every element
    painting a palette colour link to it?) a question for Justin. Paste check **3eq** (AC18, live: convert a page with
    Pictures to WordPress, paste on darksalmon, Import classes, Structure shows Sections, Containers and labelled
    Blocks with no Div; change one shared text or Button class and every element carrying it changes).
  - **site-tests-offline (tests only, no build):** every test Chrome launches through `launchOffline` (a host rule
    mapping every non-loopback name to nothing) and every Node fetch through `offlineFetch`, so test runs never reach
    the internet; `test/unit/site-tests-offline.test.ts` refuses a drawing file that names a plain launcher;
    `site:live`'s own Chrome is the named exception.
  - **standin-drift (tests and site:check only, no build):** main didn't get worse at drawing B-Dry's stand-in: since
    2026-11-15 agents draw offline, where Google Fonts can't be reached, so its Roboto words fell to a fallback font
    (both trees alike: 0 of 114 rows worse, main within 0.11 px with Google's fonts from a local mirror); `site:check`
    now prints `Fonts not loaded here: …` before OK/FAIL and writes `fontsNotLoaded` in `report.json` when a face it
    asked the font source for didn't load (a weight the source lacks too, Justin's "No still warn about it"), the exit
    code unchanged; `F2B_FONT_SOURCE` names the source asked instead of Google; HANDOFF names the local-mirror recipe;
    nothing under `src/` changed, every paste byte for byte as before. Q1–Q4 ⭐ A not yet confirmed. No paste check.
  - **2026-11-15.1 shared-palette (both tools):** a colour Figma doesn't name is one palette colour `--color-<hex>`
    (id from the hex) from the plugin and the importer alike, so one colour is one id and one variable across pages and
    both tools; given the site's own palette exports (Style Manager → Colors → Export, or the `palette.json` imported
    before) with `--colours a.json,b.json` on `site`/`site:upload`/`site:import`/`replay` or the panel's "Colours
    already on the site…", a colour the site holds is written as the site's (its id and variable) and the palette file
    holds only what the site lacks (a `--colours` file is never overwritten: new colours go to `palette-2.json`); the
    importer app has no colours option yet (R6-3, a question for Justin); without site colours every paste byte for byte
    as before. Q1–Q4 A, fixes 1–3's rulings (the plugin keeps a design value the site changed as `<name>-2` with a note,
    the importer links it; see-through site colours link) and plan amendment 2 not yet confirmed. Paste check **3er**
    (AC11, live: export B-Dry staging's palettes, `site:import … --elementor --colours <files>`, paste: a blue heading's
    colour control shows the site's colour, import the new `palette.json`: nothing listed twice; then the panel's
    Colours already on the site with the same files).
  - **2026-11-14.4 site-shared-styles (website importer):** every code-method paste (no flag) gives words, buttons,
    cards and boxes and rows that look the same (equal as written at every range and state, counted over header, page
    and footer) one shared purpose-named class each (`<page>__text-<4>`, `button`, `box`, `layout`; placed before the
    element's own), where an element sits staying on its own class, a one-off tweak on the element, never two classes
    writing one property; every solid colour one palette colour `--color-<hex>` (id from the hex, as the Figma plugin's),
    linked as `var(--color-<hex>, <as written>)` and written to `palette.json` beside the pastes (Style Manager →
    Colors → Import, **import the page's file first**), with `styles.txt` listing the classes; an unpainted plain link
    is a Block `a` holding a Rich Text (every text Rich Text); looks stay true (every element the same off and on at
    every width, Bricks 2.4.2 and 2.3.9); the switch off (`palette: false`) and Figma designs byte for byte as before.
    Q1–Q3, Q5–Q7 A and the builder's rulings not yet confirmed; ruling 5 (a section paste's own text classes on a site
    serving its own fonts) open for Justin. Paste check **3ep** (AC15, live: convert bdryswi.com's scan, import
    `palette.json` on B-Dry staging, paste /homev2/, change one text class and one palette colour in Bricks and see
    every carrier change).
  - **2026-11-14.3 importer-app (website importer):** `npm run importer` opens a page on 127.0.0.1 only (this run's
    key in the address, Host/Origin checks, changes only by POST) that runs `capture`, `capture:check`, `site` and
    `site:upload` as typed and shows what they write (pastes byte for byte the command line's): Scan a page, the saved
    scans of `~/Downloads` newest first, the drawing of header, body, footer or the whole page at four widths in a
    locked frame (Bricks 2.4.2 or 2.3.9), Copy header/body/footer/all, the notes, Make pastes again, Pictures to
    WordPress (List pictures; Log in and check, the password sent once to `site:upload`'s own prompt, the typed yes
    after its question; a real site only when the app was started from a terminal), the alttext.ai key (saved 0600 only
    after it tests well, shown by its last four); without the app `site:upload`/`site:import` print and write byte for
    byte as before. Q1–Q9 ⭐ A and the planner's, builder's and fixer 1's rulings not yet confirmed. Paste check
    **3eo** (AC20, live: his own `npm run importer`, scan bdryswi.com with Elementor ticked, look at the four widths,
    Copy header into B-Dry staging's Header template, upload with his user name, Application Password and alttext.ai
    key, typing yes).
  - **2026-11-14.2 bricks-icons-site (website importer):** with `--svg` on `site:upload`/`site:import`, a site's own
    `<svg>` drawing (one root with a `viewBox`, no script, style sheet, `<use>`, `#`-link or part id, not drawn by
    another company's script, not a live widget's) pastes as Bricks' Icon element showing its SVG file from the media
    library (`settings.icon`, `library: "svg"`; its look on its class, so a Fill, Width or Height typed in the Icon
    wins), drawing exactly as its Code element did; every other drawing stays a Code element, counted by reason in the
    notes; each distinct drawing goes up once after the typed yes as `icon-<8>-image.svg`, as served, never made AVIF
    and never sent to alttext.ai; a site that refuses SVG keeps Code elements, named; without `--svg`, pastes without
    a drawing in the map and Figma designs byte for byte as before. Q1, Q4–Q8 ⭐ A and the builder's rulings R1–R10 not
    yet confirmed. Paste check **3en** (AC5, live: `site:import … --elementor --svg` on bdryswi.com against B-Dry
    staging, paste on /homev2/, Structure shows Icons, the looks as on the site at desktop, tablet and phone, a typed
    Fill recolours).
  - **2026-11-14.1 site-no-div (website importer, both routes):** no paste the importer makes holds a Div (`site`,
    `site:upload`, `site:import`, with `--elementor` and without, the boxes a button opens): a box Bricks has no element
    for is a Block with the site's tag and a label by what it is ("Row", "List", "Link", "Icon"…); a part's top boxes
    are Sections and a Section's only `div` its Container on any site (rule S); a painted word link a Button, a plain
    one a Text link, a link around one picture an Image with Link to, a `span` of words one Rich Text, a `button` tag a
    Block keeping its tag; a `div` that adds nothing around its one element is folded (rule N, its refusals counted in
    the notes); every Block and Code element labelled; `structure.txt` beside the pastes and a `Structure:` note per
    part; still 1:1 with the site (B-Dry's home within 1.09 px at 38 widths); `ConvertOptions.native: false` and Figma
    designs byte for byte as before. Q1–Q11 A and the builder's rulings (a Section only for a `div`/`section` box, a
    menu's `li > a` its own element) not yet confirmed. Paste check **3ej** (AC14, live: rescan bdryswi.com, import
    with `--elementor`, paste B-Dry's home on staging /homev2/: Structure shows Sections, Containers, labelled Blocks
    and Bricks' own elements with no Div; looks as before at 1440 and 390; ☰ and one pop-up open).
  - **2026-11-12.3 bricks-icons (Figma plugin panel):** with "Pictures go: to WordPress", a connected site and "Icons
    as: SVG", a drawn icon of one flat colour (vector-only, at most 96 px, drawn all filled or all stroked, no link,
    description, hover redraw or other special role) pastes as Bricks' Icon element showing its SVG from the media
    library (`settings.icon`, `library: "svg"`; colour and size in the Icon's controls, recolourable in Bricks), drawn
    where the picture was; the panel counts the icons that could be Icons; a site that refuses SVG gets the paste
    converted again without Icons and one note; Icons off (pictures inside the JSON, Icons as PNG, website captures)
    byte for byte as before. Q1–Q8 ⭐ A not yet confirmed. The importer half is the job bricks-icons-site. Paste check
    **3ei** (AC7, live: in Figma with Pictures to WordPress and Icons as SVG, convert, paste on darksalmon, Structure
    shows Icons, the looks at three widths, recolour an Icon in Bricks).
  - **2026-11-12.2 site-fonts-match (website importer):** a scan keeps each face's file from its own `@font-face` rule
    (the last loaded face draws, so a family two rule sets declare keeps the file that loads) and asks a face that
    failed in its browser once more at the scan's end (refused: named "couldn't be kept"; `web.fontsRead: 2`); the
    paste writes a family the site serves itself under the page's name (`"home__Roboto"`, never a Typography control)
    with its own `@font-face` in the fonts class (`<page>__site-fonts-<4>`), a face visitors never get as a failing
    file so its words go to the site's next font, one note each, so Bricks' Google scan no longer adds Google's copy;
    `site:check` draws a failed face with the stand-in the capture measured; captures made before this build, the
    one-section route, Google-loaded families and Figma designs byte for byte as before. Q1 A ("show what the official
    page shows", not Google's copy of the broken heading font) and the builder's rulings not yet confirmed. Paste check
    **3eh** (AC9, live: rescan bdryswi.com with this build (`npm run site:import`), paste on B-Dry staging, compare the
    fonts at desktop and phone width).
  - **2026-11-12.1 site-native-structure (website importer):** with `--elementor` the paste is Bricks' own elements:
    every top-level Elementor container a Section, a boxed container's inner a Container, nested containers Blocks
    (Row, Column, Grid, Box); Elementor buttons Bricks Buttons (words in Text, link in Link to, no Style, an svg icon as
    the Button's ::before/::after), dividers Dividers, a linked picture or logo one Image with Link to, each standing
    alone where the site's box only holds it, else kept in one labelled box, named; a part's root that draws nothing is
    left out, its top Sections carrying the reset, scroll-lock and fonts (else one Block "Header"/"Page"/"Footer",
    named); a header kept at the top keeps its root as one Block "Header" only where two pasted top Sections show at one
    captured width (B-Dry's desktop and phone bars lift, each with the stay class); Sections labelled by their first
    words, kept widgets by their Elementor type; the plain route and Figma designs byte for byte as before. Q1–Q11 A and
    the builder's rulings (a button whose place can't be proved keeps a Div "Button" around it) not yet confirmed.
    Paste check **3eg** (AC15, live: a capture made with Build 2026-11-11.2 or later, paste B-Dry's home on staging: two
    top Sections, the bar for each width stays at the top at 1440 and 390, ☰ opens, one pop-up opens as on
    bdryswi.com).
  - **2026-11-11.10 media-avif-alt (website importer uploader):** `site:upload`/`site:import` make every still JPEG,
    PNG and WebP a `.avif` before the typed yes (the panel's pinned encoder in an offline Chrome of the tool's own; own
    size up to 2560 px, upright, alpha kept; SVG, GIFs, moving pictures and AVIF stay as served, named; a picture that
    can't be made stops the run, never another format), record keyed `<source>-avif-max2560` (earlier as-served uploads
    aren't sent again; `--reupload-avif` sends AVIF copies), and after the upload describe every picture whose alt is
    still empty in WordPress with alttext.ai (key asked once after the login, tested, saved
    `~/.config/figma-to-bricks/alttext-key` 0600; Enter skips; `--new-ai-key`, `--no-ai-alt`), writing only
    `{alt_text}` on an item this tool uploaded whose file still matches; `--as-served --no-ai-alt` is byte for byte as
    before; nothing under `src/` changed. Q1–Q13 ⭐ not yet confirmed. Paste check **3ef** (AC16, AC17, live: his own
    `site:import … --elementor --reupload-avif` on B-Dry staging, Media shows `.avif` with alt text, the pastes show
    them).
  - **2026-11-11.9 footer-icon-list (website importer):** the capture keeps each box side and size by one name, the
    one the site's cascade applied (a reset's physical `margin: 0` then Elementor's logical `margin-block-start`, at
    every range, under hover and focus, a logical side read by the element's own writing mode and direction;
    `web.code.oneName`), so B-Dry's footer contact list no longer pastes 69 px short (Bricks' class setting beat the
    custom CSS); captures made before this build paste byte for byte as before with one 'capture the page again' note
    where a top/bottom side or size has two names (Q4 A not yet confirmed); Figma designs byte for byte as before.
    Paste check **3dz** (AC6, live: re-scan bdryswi.com, re-paste B-Dry's home, `site:live`: footer within 2 px).
  - **2026-11-11.8 plugin-header-footer-ticks (Figma plugin panel):** the two boxes read "Leave the header out of the
    paste (my site already has its own; the page starts below it)" and "Leave the footer out of the paste (my site
    already has its own)" (a tick still leaves the part out, an empty box keeps it), the line under them says what the
    next paste does in all four states, and every note names a box by those words (`tickName()` in
    `src/core/normalise/site.ts`); no paste changes by a byte. Q1–Q3 A; Q2 open (if Justin's boxes were ticked when
    both parts stayed, a recognition bug: needs his debug file). Paste check **3ee** (AC6, live: in Figma tick both
    boxes, convert, paste on darksalmon, neither part is in it; with both empty the line says the paste keeps both).
  - **2026-11-11.7 site-sticky-header (website importer):** a header whose bars the site's script keeps at the top (the
    capture's `web.position: "fixed"` mark, not fixed by the site's own CSS) gets one class `<page>__site-stay-<4>` on
    the header root: `position: sticky; top: var(--wp-admin--admin-bar--height, 0px); z-index: 100` (also on
    `#brx-header:has(.N)` for a Header template), `html:root, html:root > body { overflow-x: clip }` and the two
    `no-scroll` lines, so it stays at the top pasted in the page or in a Header template (Sticky header off or on), with
    `overflow-x: hidden` in Additional CSS, and while a pop-up holds the page; headers the site's CSS keeps or that
    scroll away paste as before; Figma designs byte for byte. Q1–Q5 A not yet confirmed. Known limits: a painted
    `<header>` wrapper isn't marked; a bar fixed only after a strip scrolls away pastes in flow. Paste check **3eb**
    (AC9, live: remake the pastes from the saved scan, paste into an emptied page, the header stays at the top on
    desktop and phone in a private window).
  - **2026-11-11.6 site-menu-motion (website importer):** inside a box a button opens (a ☰ drawer, a pop-up), a
    `<details>` list whose own height the site's script animates when its summary is pressed (Elementor's Nested
    Accordion: Web Animations, 400 ms linear on B-Dry) is recorded by the scan (`CodeNode.slide`: duration, easing) and
    pastes with a marker class plus one Code element in the Offcanvas that plays the same slide opening and closing (a
    second press turns it back; Escape closes the drawer; reduced motion opens at once); needs Regenerate code
    signatures; Bricks' editor doesn't play it; captures without a slide and Figma designs are byte for byte as before.
    Q1–Q4 A not yet confirmed. Known limit: a list open at load records no slide. Paste check **3ec** (AC7, live:
    re-scan bdryswi.com with this build, paste the header, regenerate code signatures, on a phone Services slides as on
    the site).
  - **2026-11-11.5 site-scroll-lock (website importer):** every paste `site`/`site:upload`/`site:import` writes carries
    one class `site-scroll-lock-<4>` (second after the reset, on each part root) with `html, body { max-width: 100%;
    overflow-x: clip }`, `html:has(> body.no-scroll) { overflow-y: hidden }`, `body.no-scroll { overflow-y: visible }`
    and a `hidden` fallback for browsers without `clip`: a page never moves sideways on phones, sticky headers still
    stick, Bricks' No-scroll pop-ups still hold the page; it hides what sticks out, it doesn't fix it (`site:check`
    still names it); Figma designs and the panel byte for byte as before. Q1–Q3 A not yet confirmed. Paste check
    **3ed** (AC7, live: take `html, body { overflow-x: hidden }` out of Additional CSS, re-paste on B-Dry staging, on a
    phone the page doesn't move sideways, the header sticks, with ☰ open the page behind stays still).
  - **2026-11-11.4 media-clickable (website importer):** with a media map (`site:upload`/`site:import`/`site … --media`),
    a box's own media-library background photo is its class's Bricks Background → Image setting (id, size; a photo per
    Bricks breakpoint in that tier's setting), so it is clickable and swappable in Bricks; `background-image`/`-size`
    leave the class's custom CSS; what a setting can't hold (a gradient, layers, a photo changing between Bricks' tiers,
    a hover's photo, `::before`) stays CSS, named in the notes; the test renderer prints `_background` as Bricks does
    (an unset position is no longer printed); pastes without a media map and Figma designs are byte for byte as before;
    on the Elementor route the 25 changed classes of B-Dry's home arrive as new classes on a re-paste. Q1–Q3 A not yet
    confirmed. Paste check **3ea** (AC7, live: re-paste on B-Dry staging, click a box's class, Style → Background shows
    the photo and opens Media).
  - **2026-11-11.3 capture-refused-styles (website importer):** a scan of a site whose check comes back partway
    (bdryswi.com on WordPress.com) reads the range again asking the site for its page (the person may press 'I am
    human' once more), renews the pass for the pictures and font files at the scan's end (at most 3 renewal page
    loads, each tab closed once its page loads), stops a site that keeps refusing with one line naming who refused
    what and what to type plus a `.f2b-refused.json` log (no cookies), and never saves a page whose own stylesheets
    were all refused from the first load; the command's stop lines say what to type; sites that refuse nothing scan
    byte for byte as before and no slower. Q1–Q6 not yet confirmed. Known limit: after a renewal in the hidden window
    the downloads are marked HeadlessChrome (a site tying its pass to the browser name can leave pictures missing;
    Justin: fix later). Paste check **3dy** (AC9, live: Justin's own scan of bdryswi.com).
  - **2026-11-11.2 site-menu (website importer):** the capture presses a page's menu, pop-up and drawer buttons and
    reads what opens, under a guard (while it presses, no data-sending request, no page load a press starts and no
    WebSocket handshake or message leaves — sockets go through a gate in the capture's own process, every Chrome a
    capture starts launches through `launchCaptureChrome` — each stopped attempt named); the paste carries each box as
    Bricks' Offcanvas its openers toggle, opening and closing as on the site (its own animation, Escape, the dim, ×)
    and a closed `<details>` keeps its hidden content; a picture the site itself put in an opened box goes up with
    `site:upload` (Justin's 'Upload them too'); a capture without opens pastes as before with a 'capture again' note.
    Recorded limit: a page's own same-host live socket that beats during its own press can cost that press (F7-1).
    Paste check **3dx** (AC8, live: after the scan fix, re-capture bdryswi.com and paste; the ☰ opens the menu).
  - **2026-11-11.1 site-one-command (website importer):** `npm run site:import -- <old page> <https://your-site>
    [--elementor] [--user …] [--dry-run] [--no-shots] [--out …]` asks for the WordPress site, user name and Application
    Password first and tests the login (a wrong one stops in seconds, before any scan), scans the page (the person
    check in the visible window if the site asks), stops only for a real failure (a failed scan or one that isn't the
    page itself, a range read without the site's styles, `site:upload`'s own conversion refusals) and prints every
    smaller problem `capture:check` names as a warning (Justin's "Only real failures"), lists the pictures with their
    alt texts and what the library holds already, uploads with `site:upload`'s uploader only after a `yes` typed after
    the question shows (anything typed before it, with or without Enter, is dropped), and writes the pastes in
    `~/Downloads/<page name>/` with numbered next steps; `--dry-run` asks no password and sends nothing; an ending that
    didn't upload everything prints the `site:upload` line that finishes from that scan; `capture`, `capture:check`,
    `site`, `site:upload` and the Figma plugin are byte for byte as before. Q1–Q4 not yet confirmed. Paste check
    **3dw** (AC13, AC14, live: his own run against B-Dry staging, then the paste).
  - **2026-11-10.8 control-weight (website importer):** on the code route an element its parent reads as an inline
    word at some widths (a link that is a word of its wrapper's line on small tablets, its own painted button
    elsewhere) carries those widths in its own class, at every depth the reading nests (a link's icon and label) and
    across two parents' moves, so Bricks' class control (printed as `.cls.brxe-<el>`) no longer out-weighs the
    parent's rule (the link was `inline-block` and the fixture's hero 28 px taller in the range); where the paste can't
    prove which child is which (a hidden child before it, words beside it, an element the paste doesn't hold) or the
    parent is hidden there, the parent's rule stays as before; pastes without the shape and Figma designs are byte for
    byte as before. Q1 A (Display in the class's Custom CSS for these elements) and Q2 A not yet confirmed. No paste
    check owed (no page of Justin's holds the shape).
  - **2026-11-10.7 panel-embed-code (website importer):** on both routes (the Figma panel's website route and `npm run
    site`) a pasted Code element runs only a widget's own code: the slot's own served markup, a frame's own markup, a
    frame a script made as it showed, or the one frame shown at the slot from the capture's code reading; a floating
    widget's code is pasted only when the file that drew it is a tag the old page served and it drew the box by itself
    (no other file, no code with no file, none of the page's own code on its stack: Justin's "Safe rule"), else it is
    listed with one sentence saying why; a box the site's own script draws through another host's file is rebuilt as
    the site's own only when it holds just the site's links or pictures; what a capture can't prove is an empty box of
    its size (a floating one listed), named; an older capture pastes nothing collected ("capture the page again with
    this build"); the code route's bytes and Figma designs are as before. Not yet confirmed: paste a self-drawing
    served file at all, or always list floating widgets; the "unproven, add it by hand" ruling. Paste check **3dv**
    (AC11, live).
  - **2026-11-10.6 staging-fit-cancels (website importer):** a website paste no longer cancels a declaration at a
    width range with `revert` (it rolled back the whole author origin, so a wrapper's rule at a narrower range turned a
    painted button into a plain underlined link with square corners): a value a range drops is written as bounded media
    runs; classes change only where main wrote such a `revert` (B-Dry's saved home stand-in: 0 left, 18 before); two
    uses stay, named: an Elementor accordion's open look and a slider's `<button>` arrows and dots; the live widget's
    inner box prints as a bounded block too; other pastes and Figma designs are byte for byte as before. Q1 A (only
    classes where a range drops a value change) and Q2 A not yet confirmed. The link a wrapper reads as an inline word at
    some widths painted `inline-block` there until Build 2026-11-10.8 (control-weight). Paste check **3du** (B-Dry's
    hero buttons on phones, after a re-capture).
  - **2026-11-10.5 site-media-upload (website importer):** `npm run site:upload -- <capture> <outDir> <https://site>`
    (`--dry-run`, `--svg`, `--elementor`, `--part`, `--basic-text`, `--user`, `--record`) uploads a scanned page's own
    pictures to that WordPress site's media library with the panel's uploader (each file once, as served, the old
    site's alt in Media; a dry run sends nothing; the password at a hidden prompt; a typed yes), writes media.json and
    the pastes showing the library's pictures; `npm run site … --media <media.json>` remakes them offline; without it
    pastes are byte for byte as before. A stop (Ctrl+C) loses no upload and a re-run uploads no file twice (HANDOFF
    names the rare exceptions); every printed line is scrubbed of anything password-shaped. Q1–Q12 not yet confirmed.
    Paste check **3dt** (AC15, AC16, live: re-capture bdryswi.com, dry run, upload to B-Dry staging, re-paste).
  - **2026-11-10.4 staging-fit-renderer (website importer checks):** the test renderer prints a class's control CSS
    with the element's `brxe` class on the site route and Bricks 2.4.2's front-end CSS, as Bricks prints the page
    (`--bricks 2.3.9` for the older); `site:check -- <capture> --whole` draws header, page and footer together, and a
    picture the capture holds no bytes of (another host's icon) stands in at its img tag's size; new `npm run site:live
    -- <capture> <page address> [--elementor] [--bricks …]` reads a published Bricks page (reads only: everything but
    GET/HEAD/OPTIONS is refused and its Chrome is ended by kill), maps it to the paste and measures it against the
    capture and the renderer's drawing, naming an element the page holds in another's place; pastes and Figma designs
    are byte for byte as before. Paste check **3ds** (AC5, live: `site:live` on B-Dry staging /homev2/ after the
    re-paste).
  - **2026-11-10.3 site-slider (website importer):** with `--elementor`, a captured Elementor carousel (Image Carousel,
    Nested Carousel, Pro's Slides and carousels; either key family) pastes as one Slider (Nestable) holding its own
    slides: the site's timing, loop or fade, pause under the mouse, arrows and dots where the site draws them, per view
    and gap by Bricks' tiers, a slide's own height kept; Bricks' own slider CSS survives the site reset; `site:check`
    holds a slider on its first slide; pastes without such a carousel, the plain route and Figma designs are byte for
    byte as before. Q4 A (tiers) and the `!important` slide height not yet confirmed. Paste check **3dr** (AC10, live:
    B-Dry's hero on staging /homev2/).
  - **2026-11-10.2 site-reviews (website importer):** a captured page's third-party widget whose loader draws it (a
    reviews carousel) pastes as one live Code element at its own place, holding only the slot's own served markup or
    the loader's own tag (never the page's other scripts), so its arrows and swipes work in Bricks once code signatures
    are regenerated; a tag alone counts only where the capture proves it draws the widget by itself, else the still
    copy stays, named; `site:check` stands in for a live widget; the capture hears the page as the server sent it;
    pastes without such a widget and Figma designs are byte for byte as before. The panel's website route pasted the
    whole collected snippet until Build 2026-11-10.7 (panel-embed-code). Paste check **3dq** (AC9, live: B-Dry's reviews on staging /homev2/
    after a re-capture).
  - **2026-11-10.1 site-faq (website importer):** with `--elementor`, a pasted Elementor or ElementsKit FAQ opens at
    load the answers the site opens at the design width (none, one or several; a narrower width that shows other
    answers no longer stops it), and its open look (colour, arrow) follows whichever item Bricks has open, at every
    width and above Bricks' own class controls; pastes without such a FAQ and Figma designs are byte for byte as
    before. Paste check **3dp** (AC8, live: B-Dry's FAQ on staging /homev2/ after a re-capture).
  - **2026-11-09.4 staging-fit-capture (website importer):** a capture reads a width range again when it loaded
    without the site's stylesheets, and stops with one plain line (widths and stylesheet named, no file written) when
    they never arrive; `npm run site`, `site:check`, `capture:check` and the panel refuse a capture holding such a
    range (Justin's 2026-11-09 bdryswi.com capture: 768–991) with "capture the page again"; clean captures and Figma
    designs convert byte for byte as before. Paste check **3do** (AC6, live: re-capture bdryswi.com, re-paste on
    staging, tablets).
  - **2026-11-09.3 elementor-footer-fit (website importer):** with `--elementor`, a widget whose measured box is
    stretched past its body plus inner margins at a captured width keeps its own elements, named (fold rule 9), so
    B-Dry's whole page (header, page, footer) is within 2 px at every width (footer 51.89 px at 1025 before); the plain
    route and Figma designs are byte for byte as before. Paste check **3dn** (AC6, live: B-Dry staging at 1025).
  - **2026-11-09.2 elementor-phone-fit (website importer):** with `--elementor`, a widget whose inner negative margin
    outgrows its body at a captured width keeps its own elements, named (fold rule 8), so B-Dry's page is within 1.02 px
    at every width (7.59 px on phones before); the plain route and Figma designs are byte for byte as before. Paste
    check **3dl** (AC6, live: B-Dry staging at 390).
  - **2026-11-09.1 site-motion (website importer):** the capture (format 3) keeps each `@keyframes` and each element's
    hover and focus looks with their trigger; the code-method paste carries the keyframes under the page's name, keeps
    hover, focus and transition looks, plays entrances once as they come into view through Bricks' own Interaction (an
    entrance that starts hidden takes a type Bricks hides on load; an element that plays one keeps a box; a drawing
    plays from load), and stands still for reduced motion with every entrance shown; older captures and Figma designs
    paste byte for byte as before. Paste check **3dj** (AC13, AC14, live).
  - **2026-11-08.2 capture-speed (website importer):** `npm run capture` reads up to 4 width ranges side by side in
    separate Chrome windows (`--windows <n>`), asks Chrome's matched styles once per element, asks the site for the page
    once per kind of visitor (public addresses), loads a failed page again in the same window and stops with one plain
    line when the connection stays down (a lost connection is seen in the page's own requests too), asks "I am human" at
    most once per kind, and prints `Took …`; the saved B-Dry home captures in 3.4–3.7 min (base 33–35 min), the same
    capture as before. Paste check **3dm** (AC11, live: bdryswi.com under 10 min).
  - **Older builds** (2026-11-08.1 back to 26.1): `~/.hermes/skills/software-development/figma-to-bricks/references/project-status-log.md` → "Older builds".
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
- **WPForms:** decided for both tools (forms-wpforms): a scanned site's WPForms form and, with "Forms become: WPForms", a
  drawn form paste as a WPForms form. Still wanted (neither blocks): his own copy of the Shortcode element that shows
  form 559 on darksalmon (replaces `reference/bricks/shortcode-researched.json`) and his export of form 559 (WPForms →
  Tools → Export) to pin the file's shape.
- **Rulings to confirm:** the list rules (HANDOFF "Searchable lists"), the form rulings, and every "not yet
  confirmed" ruling in each feature's HANDOFF section.
- **Bricks samples:** Nav (Nestable) for the phone menu (the right copy contains `nav-nested`; a researched sample,
  `reference/bricks/nav-nested.json` from Bricks' code and live sites, stands in until his own copy replaces it),
  Tabs, Dropdown, a working Interaction, a `popover` Div. Never write those emitters from memory. Offcanvas + Toggle is
  no longer owed as a blocker: a researched `reference/bricks/offcanvas.json` (Bricks' code, site-menu, 2026-11-09)
  stands in until his own copy replaces it, like nav-nested.json. An Icon sample exists (`reference/bricks/icon-svg.json`,
  his staff card's Icon, bricks-icons).
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

- **A site paste shows something only in the Bricks editor or only live through Bricks' own `_hideElementFrontend` /
  `_hideElementBuilder`** (reviews-show, `src/core/site/editor-copy.ts`); a tool that compares a paste with the live
  page reads it through `test/browser/render.ts` `shownIn`.
- **A value with a Bricks control is that control, at its tab and state, with one writer** (clean-values-2,
  `ConvertOptions.clean`): no property is both a setting and Custom CSS or held by two classes of one element, states
  included (a shared look's own state, `took(state)` in `class-source.ts`, sits on the look class only;
  `test/unit/site-clean-one-writer.test.ts`); a copy's own value is never tidied away; a top element's position and an
  opened box's pointer events stay CSS; a Figma Button's look stays in its class's Custom CSS. With the switch off a
  paste is the base's byte for byte (`test/fixtures/site-clean-pins.json`, `figma-clean-pins.json`, remade only by
  their own recorders on the base tree).
- **A site paste's words keep the phone gutter only through `src/core/site/gutter.ts`** (phone-gutter): the room is
  the holder's Padding in the Phone tabs, never Custom CSS, never on a box holding a picture or painted box to the edge.
- **A site paste changes a row's shape at tablets only through `src/core/site/tablet-photo.ts`** (tablet-photo, rule
  T): Tablet-tab settings, never on a row whose photo isn't cut; a checker names a stacked row instead of comparing it.
- **A site paste fills a box the old site holds short of its column only through `src/core/site/fit-width.ts`**
  (mobile-fit), on the capture's declarations before any step reads them, never a box whose only-child chain ends in
  one self-sized thing (a page builder types a widget's width on its wrapper); a checker that excuses a filled box
  measures what follows from where its holder ends.
- **A site paste's value at a breakpoint is that tab's setting** (tier-spacing, `src/core/site/tiers.ts` `tierPlan`):
  only a change between Bricks' breakpoints is a bounded `@media (min-width:X) and (max-width:Y)` band printed
  `html:root .<class>` (never holding 991, 767 or 478), named in the notes; a logical side is renamed physical only
  where the side then is a setting.
- **A site paste never leans on a library file's own size** (bw-colours, `src/core/site/natural-size.ts`): a
  background the site drew at its file's own size takes the size the scan recorded (`web.natural`,
  `src/web/read/natural.ts`), since a resized copy, the uploader's 2560 px limit and WordPress' scaling all make
  another file.
- **A site's own fonts go to Bricks' Custom Fonts by hand; the paste names them by their plain family**
  (site-fonts-import, `src/core/site/fonts.ts` `bricksFonts`, `tools/lib/site-fonts-out.ts`): Bricks has no REST route
  for Custom Fonts and skips Google's copy of a family named like a Custom Font; never put a font file in a paste when
  `--fonts` is on.
- **Every Image a site paste makes takes its picture through `media.ts` `imageSettings`** (logo-media): never a
  hand-written `{ url, external: true }`; add every new Image producer's fixture to
  `test/unit/site-media-every-image.test.ts`.
- **A box the old site pins while scrolling is Bricks' Position: Sticky on its own class** (site-sticky-cards,
  `src/core/site/elementor-sticky.ts`); never a Code element; the guard class `<page>__site-pinned-<4>` keeps html/body
  from clipping it.
- **An Internal link is written only through `emit/link-shape.ts` `internalLink`, by both tools** (internal-links):
  never on an Image until a copy from Bricks proves it (`payloadProblems` refuses one), and a paste holding one names
  its site in `sourceUrl`, since Bricks empties an Internal link pasted on another site.
- **A box that only shows its own library photo is a Bricks Image (`tag: figure`)** (photo-box-image,
  `src/core/site/photo-box.ts`); looks, palette and names around it are decided with the photo step off, so nothing
  else in a paste moves. A photo drawn at a size of its own keeps that size on the class's ` > img`
  (photo-image-all, `photo-place.ts`), placed by `place-self` and four physical margins, never a `margin` shorthand
  (one width's shorthand would undo another's sides).
- **Sign pasted code once** (wave-code): Bricks 2.4.2's editor window of unsigned code writes each answer into
  whichever element is active, and Sign all stays pressable while it works; the importer's steps say press it once and
  wait, or save and use Settings → Custom code → Regenerate code signatures.
- **Every Code element a paste holds is labelled by what it is and named in the notes; add every new Code producer to
  `test/unit/site-code-inventory.test.ts` (importer) or `test/unit/emit-code-inventory.test.ts` (plugin). A sliding
  list in a box a button opens is Bricks' Accordion (Nestable) (`src/core/site/list-accordion.ts`), its time in
  Transition.** (native-widgets)
- **A scan presses a page's lists of questions once at its end, under the press guard, and records how each opens
  (`web.code.lists`); a paste's Accordion takes its Transition, Independent toggle and open items from that reading
  (`src/core/site/list-timing.ts`), never from a plugin's name. A flex or grid answer sits inside Bricks' Content
  Block, never as it.** (page-faq-slide)
- **A WPForms form is shown by Bricks' Shortcode element** (Bricks has no WPForms element; `reference/bricks/README.md`
  "There is no WPForms element"): both tools write it through `src/core/emit/shortcode-shape.ts` and the import file
  through `src/core/wpforms/file.ts`, one code for both.
- **No tool writes a form to WordPress:** the tools write an import file Justin imports himself; the only WPForms
  request any tool or the panel sends is the read of its form list (`GET wpforms/v1/forms`), tested only against
  `test/fixtures/wp-standin.ts`.
- **An importer animation that isn't an entrance takes a type with no 'in' in it** (site-headline-marker): a Bricks
  Start animation whose type holds "in" in any letter case makes Bricks hide its element until it plays
  (`reference/bricks/README.md`); the marker's type is `f2bMarkDraw`.
- **Every frame and shape of a Figma paste is a Block; only an inlined picture is a Div; a Block that was a Div writes
  `_width: auto`, `_display: block` or `_flexWrap: nowrap` where a Div had no default (`IRNode.leaf`)** (plugin-parity).
- **Shared looks are decided in emit after adapt (`emit/looks.ts`): a class carries a path completely, at every tier,
  or not at all; tests read an element's drawn settings through `test/fixtures/drawn.ts`** (plugin-parity).
- **A Button look class keeps its look in its own Custom CSS at `html:root .<class>.brxe-button.bricks-button`
  (0,4,1), above Bricks' Theme Style button rules; renaming that class in Bricks drops the look** (plugin-parity).
- **A copy's own value sits on the element (its own setting or `#brxe-<id>` rule), never in a second class; a tool that
  reads a paste's rules reads an element's own too** (look-grouping).
- **Test runs never reach the internet** (site-tests-offline): a test that draws a site capture or paste launches
  Chrome through `test/web/lib/offline-chrome.ts` `launchOffline` and fetches through `offlineFetch`; the guard test
  fails on a plain `launchChrome` in a drawing file.
- **A `site:check` run that prints `Fonts not loaded here:` (report.json `fontsNotLoaded`) drew those words with a
  fallback font: never compare its rows with the capture or with another run (standin-drift); offline, give it
  Google's fonts from a local mirror.**
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
  (user, 2026-10-23): the session only orchestrates; fresh `general-purpose` agents with their role's model and effort (the
  global file's role table) plan, build, review, fix, verify and audit, and `ac-check.sh` decides when every AC is accepted. Never plan, build or review in
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
    corpus` before Task 1 and at the close. Then two fresh full reviews, each on the model and effort the global
    routing gives its round (global CLAUDE.md "Agent models"), with a fix pass after each (each fix test first), then
    the verifier, the blind AC auditor and `ac-check.sh`, looping until every AC is accepted (global CLAUDE.md steps
    5–6).
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
       stops and reports the new HEAD. If HEAD now differs from the head `ac-check.sh` accepted, global CLAUDE.md
       step 7 decides what runs before step 2 (agents don't start agents): a rebase receipt carries the earlier
       reports only when HEAD is a pure rebase of the accepted head. The ledger commit made here before the rebase
       is a patch that head lacks, so HEAD is not a pure rebase of it and the session takes step 7's full path on
       the new head: a fresh review of what the accepted head lacks, then verifier → auditor → `ac-check.sh`.
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
- **The importer app (`npm run importer`) listens on 127.0.0.1 only and answers only its own page:** this run's key on
  every `/api` request, the Host and Origin checks, no CORS header, changes only by POST
  (`tools/lib/importer-app/guard.ts`). It converts and uploads nothing itself: it runs `capture`, `capture:check`,
  `site` and `site:upload` as typed and shows what they write, so a paste from the app is byte for byte the command
  line's. Its preview is a locked frame that loads nothing but Google's fonts and can't reach the app. The app's own
  process sends one kind of request off this computer: the key section's test to alttext.ai. A new option of those
  commands is added to the app in `tools/lib/importer-app/commands.ts`.
- **The importer never hides that its Chrome is automated** (no `AutomationControlled` flag, no `navigator.webdriver`
  patch, no new user agent, no stealth script, nothing that clicks or types into a site's check): a person passes a
  person check in the visible window (web-human-check).
- **`npm run site:live` only reads a published page** (staging-fit-renderer): its Chrome refuses every request but
  GET/HEAD/OPTIONS, with Chrome's own report uploads off, and is ended by killing its process group, never asked to
  close (a closing page sends its goodbye POSTs); it stops at a login page and never signs in. A tool that loads a
  user's site keeps to this (`tools/lib/read-only.ts`).
- **Every Chrome a capture starts launches through `launchCaptureChrome`** (`src/web/capture.ts`; site-menu, Justin,
  2026-11-10, "Block sockets"): it adds the socket gate (`src/web/socket-gate.ts`) the press guard shuts while the
  capture presses a page's menu and pop-up buttons. `launchChrome` alone starts a Chrome with no gate: its sockets
  during a press are only named as not stopped.
- **A picture is looked for in the site's Media by its mark before it goes up** (media-reuse, `src/ui/media-mark.ts`,
  both tools): never matched by name, by a same-named file or by WordPress's `-2` copy; a picture already in Media
  keeps Media's alt text (a person's typed words still replace it), and alttext.ai is asked only where Media has none.
  Decorative empties Media's alt text only for a picture this conversion uploaded; one already in Media keeps its words
  (a per-page decorative can't be pasted: Bricks prints an empty Custom alt text as none); the importer fills an empty
  Media alt with the old site's words after the yes, only on an item it put there whose file still matches.
- **One uploader writes to WordPress, reached by two commands and the importer app: `npm run site:upload`, `npm run
  site:import` and `npm run importer`** (Justin, 2026-11-10: a scanned page's pictures "upload to my Wordpress media
  library like how it is in the plugin", run "From the command line"; then "One command, Mini": WordPress asked first,
  then the scan, the upload and the paste; Justin, 2026-11-13: "a simple UI for the importer … plus a section where we
  can put the API for alt text"). All three run the same code (`tools/lib/site-upload/`): the app starts `site:upload`
  itself and has no uploader of its own (`site:upload … --also <capture> <outDir>` and the app's "Upload together"
  ticks upload up to three scans of one site in one run: one login, one typed yes; multi-page-scan). It only adds media items and fills the empty alt text of an
  item it uploaded itself (in its record, or carrying its mark) whose file still matches (never changes, moves or deletes one; never touches pages, posts or settings; besides the media routes (the media list
  read by mark included, GET `wp/v2/media?slug=`; media-reuse) it reads only the site's WPForms form list (GET
  `wpforms/v1/forms`) to put a form's number in the paste and, after the login, its page list and homepage setting (GET
  `wp/v2/pages`, internal-links) to write `pages.json`), only on the site whose address was typed, after reading that site and
  a typed `yes` asked after everything it found is shown (no flag skips it; `site:import` takes only a yes typed after
  that question). The Application Password is typed once for each site and user name, at the hidden prompt (`site:import` asks it
  before the scan) or in the app's password box, which sends it once in a request body to the app on 127.0.0.1, which
  writes it once to the upload command's input. Once WordPress accepts the login the upload command saves it in
  `~/.config/figma-to-bricks/site-passwords.json` (0600, its folder 0700, one entry per site and user name; Justin,
  2026-11-16: "saved and doesn't need to be re-entered"; saved-password), the one place a password is kept, and later
  runs of all three read it from there, for that site and user name only (`tools/lib/site-upload/saved-login.ts`, read
  by the upload command itself, never sent by the app; shown only by its last four characters; `--new-password` or the
  app's Replace replaces it, `--forget-password` or the app's Forget removes it, one WordPress refuses is asked for
  again once). Besides that one file it never goes in an argument, a shell or environment variable, an address,
  another file, the record, the capture, the paste, a log, a printed line, the page's storage or the scan's Chrome, and
  a saved password never skips the typed `yes`. The alttext.ai key is asked once (at the
  prompt or in the app's key section, which shows a saved key only as its last four characters) and saved only in
  `~/.config/figma-to-bricks/alttext-key` (0600); it never goes in an argument, a shell or environment variable, an
  address, the record, the capture, the paste, a log, a printed line, a Chrome the tools start, or the page's storage,
  and is sent only to alttext.ai. Only Justin runs any of them against his own site: the commands in his own terminal,
  the app started from his own terminal and used in his own browser. Agents never run them against his site or any
  live site, never ask for, hold or type his password,
  never read, copy or print `~/.config/figma-to-bricks/site-passwords.json` or `alttext-key` (names, modes and sizes
  only), and test them only against `test/fixtures/wp-standin.ts`, the
  alttext.ai stand-in and local fixture sites. Every other tool (capture, the helper, site,
  site:check, site:live, compare, replay) stays read-only; the helper still binds 127.0.0.1 only and never writes to a
  site.
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
- **A website paste never cancels a declaration at a width range with `revert`** (staging-fit-cancels): `revert` rolls
  back the whole author origin, so it also beats the element's own class and controls. A value a range drops is
  written as bounded runs (`src/core/site/blocks.ts`); the only `revert`s left are the site-reset class's own, an
  accordion's open look and a slider's button parts (`test/fixtures/site-drops.ts` `excepted`;
  `test/unit/site-no-revert.test.ts` fails on any other). A job that changes what a site paste writes on purpose makes
  `test/fixtures/site-no-revert-main.json` again on its own tree (`node tools/site-no-revert-golden.ts .`).
- **A website paste locks sideways scrolling with `clip`, never `hidden`, on html and body** (site-scroll-lock):
  `hidden` on both makes body a scroll container (sticky headers ride off), and any overflow on html stops Bricks'
  `body.no-scroll` reaching the window, so the lock also carries the two `no-scroll` lines.
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
- **Bricks' Icon prints an SVG only from the media library** (`icon.svg.id`; bricks-icons): the plugin makes Icons only
  with pictures to WordPress and Icons as SVG, and an Icon's drawing holds no ids. **An Icon's box rules never
  out-weigh its own Width and Height controls:** its floor is `overflow: clip`, its shape `height: auto` under
  `:where()` (`Style.weightless`), never a `min-width` floor or an `aspect-ratio` (`style/icon.ts`).
- **A website paste never holds a Div** (site-no-div; `test/unit/site-no-div.test.ts`: add every new element producer
  to it). The native step is on for every importer paste; `ConvertOptions.native: false` is a test and diagnosis
  switch only.
- **A website paste keeps the site's accessibility names** (importer-parity; `test/unit/site-names.test.ts`; never an
  attribute that names an id).
- **The importer and the plugin write a Nav, a Form's fields and a Video's keys through `emit/nav-shape.ts`,
  `form-shape.ts`, `video-shape.ts`** (importer-parity).
- **A top element's position stays custom CSS on the importer** (importer-parity; page-wide classes meet it at class
  weight).
- **The site-route renderer prints only Bricks' own layered CSS for Bricks' elements** (importer-parity builder,
  2026-11-13; `renderPage` with `bricksCss`): never the Figma route's unlayered helper CSS (`navCss`'s `revert-layer`
  lines, `FORM_BASE_CSS`), which beats `site-flat` and the site reset (a bare-link Nav drew 31 px off);
  `test/browser/render-site-nav.test.ts` and `render-site-form.test.ts` assert it.
- **A site:live test that serves a printed stand-in holds its draw with `parsedFirst`**
  (`test/web/lib/bricks-printed.ts`; importer-parity fixer 11): Chrome can draw a page before it is parsed to its end
  and lose a one-space Rich Text between `display: contents` wrappers.
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

- **THE STANDARD FOR EVERY PASTE: built like a skilled Bricks builder made it by hand** (Justin, 2026-11-13: "make it
  easy for someone who is really good at Bricks to come in and do changes to a site … the pastes are built in a logical
  way as if someone manually built it with Bricks, with logic in regards to classes, containers and everything"). It
  applies to **both tools** (the Figma plugin and the website importer), which follow the same rules and make the same
  shapes. Every plan says how its output meets it; every reviewer and auditor asks "would a Bricks pro find this
  logical and easy to change?" and reports where it isn't.
  1. **Structure:** Section → Container → Blocks, one Container per section, a shallow tree; Bricks' own elements for
     what they are (Heading, Rich Text, Button, Image, Icon, Divider, Slider, Accordion, Offcanvas, Nav, Form, Video),
     never a Div; no wrapper that does nothing; every Section and Block labelled by its purpose or first words.
  2. **Classes:** looks that repeat live in shared purpose-named classes (text styles, buttons, cards and boxes,
     spacing and layout); same-looking elements share one, different-looking ones get their own; a one-off tweak sits on
     the element; names read by purpose with a short site prefix (`bd-heading-1`, `bd-button-primary`, `bd-card`; Justin
     asked for "easy for a Bricks pro", 2026-11-13, replacing the `<page>__` names), the same name and id on every page
     of a site; never two classes writing one property; no class per element where a shared one fits.
     **The same button shares one class** (Justin, 2026-11-13: "all call me buttons should change … identify them by name"):
     copies of one button, heading or card (the same Figma component, the site's own class names, or the same words and link)
     share one class even if a copy differs a little; that copy's real difference stays on the element itself (its own
     settings, `#brxe-<id>`), so nothing moves and no two classes write one property (look-grouping Q3 A, 2026-11-13).
  3. **Settings before custom CSS:** a value with a Bricks control goes in that control; Custom CSS only where Bricks has
     none, short and on the class that owns it. Colours come from the palette (Style Manager → Colors), sizes on a clean
     scale where that moves nothing visibly (within 0.5 px; else the exact value stays).
  4. **Bricks' own behaviour:** Interactions, Offcanvas, Slider, Accordion before Code elements; Code only for a
     third-party widget that needs it, labelled and named in the notes.
  5. **Editable content:** words in the text fields, links in Link to, pictures and SVGs in the media library, icons in
     the Icon element, nothing baked into CSS that a person would expect in a field.
  6. **Looks stay true:** the importer stays one to one with the site and the plugin exact at the design width; where
     "clean" and "exact" conflict, exact wins and the paste notes say why.
- **Copies of one thing share one class** (Justin's 2026-11-13 rule, look-grouping; Q1 A and Q2 A not yet confirmed):
  a leftover look is a copy of a class by three signs (the same words and link; the same name where it was made: the
  same Figma component or the site's own class names, where the name tells; the same look at the design width), and at
  most two kinds of setting may differ; its difference stays on the element.
- **Interactions use native Bricks elements** (2026-10-06, replaces v1's radio/`:has()` CSS approach).
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Interactions use native Bricks elements".
- **On tablets, a grid of cards stays on one row rather than leave one card alone below the others** (user,
  2026-10-16: "the third form goes into a new line. I need them all horizontal").
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "A grid of cards stays on one row on tablets".
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
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Layout".
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
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Native Buttons by shape alone".
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
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Drawn phone designs".
- **Phones and tablets are generated from a desktop-only design** (designers draw desktop only). Desktop must stay
  exact at the design width; below it the page is fluid, and the rulebook (`src/core/adapt/rules/`) adapts it. The
  user calls the hero "the header". Phone rules (2026-10-01, kept on 2026-10-06):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Phones and tablets are generated from a desktop-only design".
- **Typed line breaks** (user, 2026-10-21, L1A L2A): in a text box of fixed width (Figma's fixed or auto-height box),
  typed breaks that only copy Figma's own wrap go out as spaces, so the words wrap by the box on every screen, never
  by the screen's width. A text hugging its words keeps its breaks from the design width up and loses them below.
  Breaks that are the designer's (items like addresses and hours, a sentence a line, headings, a line the next word
  would have fitted on) stay. Only prose goes soft (finisher's ruling under the user's auto-go; `style/rag.ts`).
- **Free-floating designs on phones** (the user, 2026-10-07; designs drawn without auto layout):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Free-floating designs on phones".
- **Website rules** (2026-10-02: HTML5 semantics, WCAG 2.2 AA, search and speed basics; the user means technical
  rules, not laws). The design stays as drawn except for the two label minimums below and the section rhythm
  (Layout):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Website rules".
- **Open question for the user (not decided):** a hover component inside a link keeps its phone tap control, so on
  phones a tap shows the hover and the link doesn't open. Ask before changing it either way.
- **Picture descriptions in the panel** (user, 2026-10-07): a "Picture descriptions (N missing)" list after each
  conversion (photos and drawings, not icons or backgrounds), with Decorative and Show.
  - Save keeps them in the Figma file (document plugin data `f2b-alts`, by image for photos, by layer otherwise) and
    sends them to WordPress for pictures already there.
  - Bricks shows the media library's alt (verified on the live site), so the paste carries no `altText`.
- **AI picture descriptions with alttext.ai** (user, 2026-10-14):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "AI picture descriptions with alttext.ai".
  - The AI's words replace whatever WordPress had only for new uploads and empty Media items; a picture found in Media
    by its mark keeps Media's words (media-reuse Q2/Q3 ⭐ A, not yet confirmed).
- **Figma colours in Bricks** (user and their manager, 2026-10-14):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Figma colours in Bricks".
- **Forms** (user, 2026-10-16: "make the contact form and the Yes/No interactive"): a drawn form becomes Bricks' Form.
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Forms".
- **Call and email links** (user, 2026-10-19: "whenever there's a call … button, the plugin will automatically use it
  as a hyperlink and will identify the phone number"):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Call and email links".
- **A text that is all one link carries it in Link to** (the designer Niklas, through Justin, 2026-11-04; ⭐ answers
  not yet confirmed): email `mailto:`, phone `tel:`, a whole Figma link or page link go in the element's Link to
  (External URL), never as an `<a>` in its words; a link inside a sentence stays inline; headings too
  (`understand/text-link.ts`, `elementLink(ir)`).
- **Links to pages** (user, 2026-10-19: "whenever there's a hyperlink icon … or 'take me to this' … it will
  automatically implement the hyperlink … to that page", named after "the sentence before it"; build `2026-10-19.17`).
  The user chose, in questions:
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Links to pages".
- **Footer destinations** (Justin, 2026-11-04, option A): belonging to a footer column never supplies a destination;
  unauthored labels stay plain with one note per included affected Figma design. Source element/text/ancestor links,
  captured hrefs and existing independent contact/social/arrow/go-word rules keep their own policy; structural
  membership, headings and omission remain. Genuine page labels need a link in Figma or Bricks.
- **The site's own header and footer** (user, 2026-10-20: "if there is already a header and footer in bricks then the
  plugin will remove the header and footer"):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "The site's own header and footer".
  - The panel's two boxes (2026-11-11, plugin-header-footer-ticks) read "Leave the header out of the paste (my site
    already has its own; the page starts below it)" and "Leave the footer out of the paste (my site already has its
    own)"; a tick leaves the part out, an empty box keeps it.
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
  - **A pasted Code element runs only a widget's own code** (panel-embed-code; Justin, 2026-11-10, "Panel widget code
    go" and, for floating widgets, "Safe rule"): never a tracking tag, a tag manager, a loader, a shared library,
    another widget's script or a page script. A floating widget's code is pasted only when the file that drew it is a
    tag the old page served and it drew the box by itself; anything started by a starter script, a tag manager or the
    page's own script is listed with a plain note (add its install code by hand). Where a capture can't prove a
    widget's own code nothing is pasted to run. Both routes read `src/core/snapshot/embed-code.ts`.
- **The website importer copies the site's own code** (Justin, 2026-11-04: "I want a method that can help us get one
  to one, not relying on photos or images but actual code"; method review
  `~/.hermes/plans/figma-to-bricks/evidence/method-review/report.md`): a site's elements, classes and CSS rules go into
  Bricks as they are; the measured-box route through the Figma converter is retired for websites once the whole page
  passes.
- **An importer box Bricks has no element for is a labelled Block** (Justin, 2026-11-11; site-no-div Q1 A, not yet
  confirmed): never a Div; its label says what it is.
- **A scanned site's simple form is a Bricks Form that emails the admin; the old site's form address is never posted
  to** (importer-parity Q7 A, not yet confirmed). Justin's 2026-11-13 "wpform" ruling comes first: a WPForms form is
  the job forms-wpforms', whose pick runs before importer-parity's `formShape` (keep both lines when it merges).
- **Forms on a scanned site that are WPForms forms** (Justin, 2026-11-13, "wpform"; job forms-wpforms, ⭐ answers not
  yet confirmed): a WPForms form pastes as a WPForms form (Shortcode element plus an import file he imports), its look
  WPForms' theme plus one class, messages to the new site's admin address, nothing of the old site's sending copied;
  a field type the job can't write is left out and named; reCAPTCHA on in the file, shown once his own keys are in.
- **"Forms become: Bricks form / WPForms" in the Figma panel** (forms-wpforms Q5 A, not yet confirmed): starts on
  Bricks form (every conversion byte for byte as before); on WPForms a drawn form is the importer's Shortcode element
  and file.
- **A menu's sliding list and the Code that stays** (native-widgets; ⭐ answers not yet confirmed): Q1 A, a sliding
  list inside a box a button opens becomes Bricks' Accordion (Nestable) (three known differences from the site's
  script, HANDOFF); Q7 A, the plugin's card arrows stay a script, now with a note; Q8 A, the header spacer stays a
  script.
- **A page's FAQ slides like the site's, as Bricks' Accordion** (Justin, 2026-11-13, yes; page-faq-slide, ⭐ answers not
  yet confirmed): Q3 A, scans made before this build paste byte for byte, notes included, but a Nested Accordion on the
  Elementor route (its settings are in the scan); Q4 A, a list that opens at once gets Transition 0; Q5 A, reduced
  motion opens at once; Q8 A, an aria list whose closed answers are hidden by a height of 0 (not `display: none`)
  stays as it is while no title is open at load.
- **A Swiper or Splide slider outside Elementor is a Bricks Slider** when the capture read it running (its settings);
  one whose library the capture read nothing of stays static with all its slides, named (replaces "Keep all its
  slides" for the running ones; importer-parity Q10 A, not yet confirmed).
- **A painted importer Button has Style: Primary** (replaces site-native-structure Q6 A; importer-parity Q14 A, not yet
  confirmed).
- **Code-method class names start with the page's name** (Justin, 2026-11-07, "Never use bare names", then "Prefix
  every name"): `<page>__<name>`, only `site-reset-<4>`, `site-scroll-lock-<4>`, `site-fonts`, `site-text`, `site-flat` keep
  theirs; a static slider keeps all its slides ("Keep all its slides"). **Being replaced (2026-11-13)** by a short site
  prefix read by purpose (`bd-heading-1`), shared across a site's pages: the standard at the top of this section; the
  job short-class-names carries it out, and `<page>__` stays until it merges.
- **A scanned page's pictures go to WordPress from the command line** (Justin, 2026-11-10, "From the command
  line", Full pipeline; ⭐ not yet confirmed, Q12 open, HANDOFF "A scanned page's pictures go to WordPress's media
  library"): its own command `site:upload` (Q1 A), and one command `site:import` that asks for WordPress first, then
  scans, uploads and writes the pastes (Justin, 2026-11-10, "One command, Mini"; after the scan it stops only for real
  failures and warns of the rest, Justin's Q5 "Only real failures"; site-one-command Q1–Q4 ⭐ not yet confirmed); the
  password typed once for each site and user name, then saved on this computer in a file only he can read (Q2 A
  reversed by saved-password, Justin, 2026-11-16: "saved and doesn't need to be re-entered"; Q1–Q6 ⭐ not yet
  confirmed); every
  picture the site's own markup shows, each file once, script-made ones and `data:` left, **except the site's own
  pictures inside a box the capture opened** (every script-made step made by the site's own files; Justin, 2026-11-10,
  "Upload them too"); an address that goes up is never also listed as staying (Q3 A); no file in the
  capture: its old address (Q4 A); SVG only with `--svg` (Q5 A); files as served, never re-encoded (Q6 A; reversed by media-avif-alt, Justin, 2026-11-11: AVIF for photos and PNGs); the old
  site's first alt with words in Media, an alt in WordPress never changed by a re-run (Q7 A); no alttext.ai (Q8 A; reversed by media-avif-alt, Justin, 2026-11-11: AI alt text for pictures with none; a picture found in Media by its mark keeps Media's alt (media-reuse)); a
  record per computer at `~/.config/figma-to-bricks/site-uploads.json` (Q9 A); https, the site read first, a typed yes
  (Q10 A); a stopped run keeps what went up, the next sends the rest (Q11 A).
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
