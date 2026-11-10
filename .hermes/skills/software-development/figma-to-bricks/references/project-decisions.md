# Figma to Bricks v2: decision details (lines moved whole from the project CLAUDE.md "Decisions the user made"; each under a copy of its headline)

## Interactions use native Bricks elements

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

## A grid of cards stays on one row on tablets

- **On tablets, a grid of cards stays on one row rather than leave one card alone below the others** (user,
  2026-10-16: "the third form goes into a new line. I need them all horizontal").
  - `adapt/layout.ts` `gridColumns`, while each column gets 160px.
  - **Rows of alike cards too** (user, 2026-10-20, three reviews: "the third review shouldn't go on a new line … It
    compacts it a bit more, but it makes it look cleaner"): `decideRow` keeps 3, 5… alike cards on one tablet row while
    each gets 160px.
  - **Phones** (user, 2026-10-20: "if on mobile make them stack. for mobile landscape put all 3 in the same row"):
    held sideways (480–767) three alike cards or a grid's three cells stay one row while each gets 120px; upright
    phones stack them. So the narrowest tablets (768–880) stay three across too.

## Layout

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

## Native Buttons by shape alone

- **Native Buttons by shape alone** (2026-10-06): a painted box around one short centred label becomes a Bricks Button,
  linked or not and whatever its name. Form fields (words starting at the left) and table cells (a rule on one side)
  aren't buttons. Tags and pills of the same shape may become Buttons; the user accepted that. A pill of words and one
  or two drawn SVG icons (one each side at most, beside the words, in its middle) is a Button too, its icons its
  ::before/::after from their Figma SVG (icon-buttons Q1 A, not yet confirmed; emit/button-icons.ts); inside a link it
  is a Button with no link (Q2 A). A pill under 44px whose own hover changes its icon or more than CSS draws stays a
  Div.
  - **A Button stretched wider than its content centres its words and icon** (Justin, 2026-11-04, chose "Centred": the
    phone-menu panel's "Schedule Now").

## Drawn phone designs

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

## Phones and tablets are generated from a desktop-only design

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

## Free-floating designs on phones

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

## Website rules

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

## AI picture descriptions with alttext.ai

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

## Figma colours in Bricks

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

## Forms

- **Forms** (user, 2026-10-16: "make the contact form and the Yes/No interactive"): a drawn form becomes Bricks' Form.
  - It sends by email to the site's admin address with Bricks' own texts; the address, message and saving are "figure
    out later".
  - My rulings, not yet confirmed: typed words in the labels' colour, no option pre-picked, a chevron box is a text
    field, the send button's icon is left out (warned).
  - **The user's team uses WPForms (Pro)** (2026-10-19). On the contact page the Bricks Form was swapped by hand for
    WPForms form 559 in a Shortcode element, styled by `reference/wpforms/need-a-repair-559.css` in Bricks → Settings →
    Custom code (the user: "it worked"). A plugin option "Forms become: Bricks form / WPForms" is proposed, not built:
    it waits for the team's WPForms export file and which option starts selected (`reference/wpforms/README.md`).

## Call and email links

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

## Links to pages

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

## The site's own header and footer

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
