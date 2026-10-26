# Better automatic iPhone layout (sliders, hero, buttons, footer, text)

## Context

When a desktop-only Figma design is converted, the plugin builds the iPhone version on its own
("Adapt for iPad and iPhone"). On the user's latest file (`figma-to-bricks-debug-final-design.json`,
build 2026-09-30.12) the iPhone result looks messy. Replaying it at 390px showed what goes wrong and why:

- **A slide with two photos.** A row "tall photo | column of 2 photos | tall photo" becomes a slider whose middle
  slide shows both stacked photos: `isPhotoCard` (code.js ~1839) counts a photo-only column as one card. Tall photos
  also come out ~860px high because each keeps its own desktop shape.
- **The page wasn't split into sections.** A small layer drawn over the page beside the page frame (the EAST/NORTH
  tabs) stops `pageSections` (~6101) from looking through the wrapper, so the whole page became one section, even with
  "full page frames" ticked. Every per-section phone rule was skipped: the footer wasn't centred, every band was inset
  16px, and the tabs ended up below the footer.
- **There is no "hero" concept.** The hero photo is a centred `cover` background behind the text, so the people don't
  show. `cropCss` writes percentage sizes that distort when the box changes shape. The header bar's buttons stack
  huge, and its logos overlap.
- **No button is ever full width on phones.** Button rows wrap at their content width.
- **Text and spacing.** Type comes out at fractional sizes (30.4px). Stacked gaps reach 121–243px. Footer columns go
  two per row with no gap. The footer's bottom bar ("space-between") is never centred. Alignment is mixed within a
  column.

The plugin has to stay general. CLAUDE.md applies: rules are detected from structure, never from names or values in
this file, and **nothing at the design width may change** (except Phase 1 splitting pages that used to fail).

## Decisions the user made in this session

- **Hero ("header" in the user's words = the top section with a photo):** the heading and text **stay on the
  photo**. The photo is **cropped for the phone, toward its subject**. **Every call-to-action button goes right under
  the photo**, including the CTA buttons in the top bar next to the logo. One with the same label and link as a hero
  button shows once.
- **Hero with the photo beside the text:** on phones the order is text, then the cropped photo, then the buttons.
- **Full width:** **every call-to-action button** is full phone width, one per row: in sections and inside cards. Not
  the menu toggle, icon-only buttons, the logo, or floating/fixed layers.
- **Sliders:** **one photo per slide.** A photo group with no text splits into one slide per photo. A card with text
  and 2+ photos keeps only its largest photo on phones.
- **Text and spacing:** "whatever you recommend" → Phase 8.

## Architecture (Phase 0: groundwork)

- **Factor `buildSections(ctx, plan)` out of `convertRun`** (the section loop at about line 6881). It:
  - sets `ctx.firstSection` and `designWidth`;
  - calls the new pre-pass **`planPhones(ctx, sections)`**;
  - loops `addMachineSection` / `addSection`;
  - calls the new post-pass **`phonePostPass(ctx)`**.

  Tests that call `convertNode`/`addSection` directly are unaffected.
- **`planPhones` reads the Figma tree before anything is built.** It decides:
  - the hero, its text unit, its CTAs and its bottom bands;
  - the nav CTAs to move;
  - the band colour and the photo's focal point;
  - `ctx.phone.hidden`, the layers hidden at ≤767.

  It calls `analyze` with a flag that suppresses `note()`.
- **`phonePostPass` hides the moved originals and applies the full-width CTA rule.** Element ancestry is only known
  after building.
- **Copies follow the slider's pattern.** `copyForSlide(ctx, k, parentId, out)` additionally returns
  `out.map`, the node→element map of the copy, so a copy's inner elements can be adjusted. It uses `ctx.copies`, so a
  copy adds no uploads and no extra H1.
- **New helpers:**
  - `paintAt(paints, node, fx, fy)`: the colour of SOLID and gradient paints at a point, via `gradientTransform`;
  - `contrast(a, b)`: the WCAG ratio, built on `luma`;
  - `ctaKey(n, ctx)`: the normalised label plus `buttonLink`;
  - `isCta(n, ctx)` (Phase 4).
- **Desktop output stays identical.** Everything new uses `:mobile_*` keys, CSS at `PHONE_MEDIA`/`PORTRAIT_MEDIA`, or
  phone-only elements (`_display: none`, shown at `:mobile_landscape`).

## Phase 1: pages split around small layers drawn over them

- **Rule.** A small, non-fixed layer drawn over the page, inside the page frame or beside it in a wrapper (side tabs,
  a badge), isn't a section and doesn't block the split. It belongs to the section it sits over:
  - **Desktop and iPad:** exactly where Figma has it.
  - **Phones:** after that section's content, on its side.
- **Detection: a layer counts as "over the page" when all of these hold:**
  - it isn't fixed;
  - `w ≤ 0.6·page width`;
  - `h ≤ min(0.25·page height, 1000)`;
  - at least half its area lies inside the dominant page child, or inside a section at least 80% of the page wide.
- **`pageSections`:** the look-through loop accepts "one big child + over-page layers" and returns `overlays`.
- **`expandPages`:** assigns each overlay to the section with the largest vertical overlap (`ctx.pageOverlays`).
  `convertRun` adds these layers to `fixedNodes`, so components, links, hovers and images are read for them.
- **New `addPageOverlays` (called from `addSection`):**
  - `_position: absolute`, horizontal placement from its constraint (as in `place()`);
  - `_top` or `_bottom` from the nearer end of the section (negative when it hangs past it);
  - `z-index: 1`, within the stacking decision;
  - at `:mobile_landscape`: `relative`, top/left `auto`, `_alignSelf` to its side;
  - recorded in `ctx.overPage`.
- **Tests (`pages.test.js`):**
  1. A wrapper with a 4-band page and a 190×124 frame straddling the hero's bottom splits into 4 sections. The frame
     sits absolute in the hero with a negative `_bottom`, and the footer is the last element.
  2. The same layer inside the page frame.
  3. A 600px section between bands stays a section.
  4. A 70%-wide extra layer still blocks the split.

## Phase 2: footers centred on phones, wherever they are

- **Footer name.** Split the layer name into words (on non-letters and on lower→Upper changes) and look for the word
  "footer". So "SiteFooter" and "Footer2" match, "Prefooter" doesn't.
- **Unsplit page.** An unsplit page's last full-width band that touches the page bottom counts as a footer
  (`ctx.footerNodes`, centred from `addBox`).
- **Footers with states.** `addMachineSection` passes the footer flag to every state, which fixes the id mismatch.
- **`centerOnPhones` (~5831):**
  - **Two tiers:** 767 from the landscape values, then 478 from the portrait values when they differ. Rows stacked
    only at `:mobile_portrait` now get centred.
  - **A `space-between` bar with 2+ visible items** becomes a centred column with `row-gap: 12px` (copyright,
    links, credits), and its thin dividers are hidden.
  - **List texts** keep their own alignment.
- **`rowPlan` (~2186).** In a footer (`ctx.inFooter`), "pairs" becomes "stack": link columns go one per row,
  centred, with a capped gap.
- **Tests (`realpage.test.js`):**
  - Extend `footerBand` with a space-between bottom bar and a 4-column links row.
  - The bar becomes a centred column; the columns are 100% wide with a gap of 32 or less.
  - A row stacked only at portrait is centred at 478.
  - The new name matching works.
  - A footer with states is centred.
  - An unsplit page's last band is centred.

## Phase 3: one photo per slide

- **`pictures(k)`** collects visible `isPhoto` layers up to 4 deep, without looking inside a photo. Photos that
  overlap at least 50% count as one picture, represented by the largest one.
- **`makeSlider` (~1965):**
  - An item **without text and with 2+ pictures** gives one slide per picture.
  - A **text card with 2+ pictures** keeps one slide. New `keepMainPhoto` hides the other photos in the copy only
    (`_display: none` plus a rule); the original card on desktop and iPad keeps all of them.
  - Apply the same to `looseOnDevices` collages (~2038).
- **New `uniformSlides`:**
  - **Scope:** slides that are only a photo.
  - **Shape:** share one aspect ratio, `clamp(median, 4/5, 4/3)`, `object-fit: cover`, and `_height*` cleared.
  - **Already uniform:** when all ratios are equal and within that range, they stay as they are.
  - `fillSlide` is unchanged, since component states use it too.
- **Tests (`slider.test.js`):**
  - A column of 2 photos among the row gives 4 slides of one image each.
  - Photos overlapping 90% give 1 slide.
  - In a text card with 2 photos, the copy hides the smaller photo and the original is untouched.
  - 225×542 photos give `aspect-ratio: 4 / 5`; wide photos give `4 / 3`.
  - A collage gives the expected slide count.
  - Existing assertions still hold: perPage/perMove unset, height auto.

## Phase 4: every call-to-action full width on iPhone (≤478)

- **`isCta(n, ctx)`** is true if `isButton(n)` (the name-based check) passes. Otherwise it needs all of the following
  structural signs:
  - 32 ≤ h ≤ 120, w ≥ 1.5·h, w ≤ 640;
  - one text label on one line, ≤ 40 characters, font size 12–28;
  - other layers only icons (≤ 48px) or single-child wrappers, and no photo;
  - a painted box (fill ≥ 0.1 opacity, or a stroke) at least 90% of its size;
  - the label centred in that box, or even side padding (this rejects input fields);
  - **evidence:** a click, hover or press reaction or a link, an icon beside the label, or a component used 2+ times.

  This catches the other sample's unnamed "Schedule Your Visit" instance and rejects its one-off "1000+ Clients" pill.
- **`convertLayer` records CTAs** in `ctx.ctas`, copies included.
- **Post-pass `ctasOnPhones`.** At `:mobile_portrait` a CTA gets:
  - `_width` and `_widthMax` 100%, `_flexGrow` 0, `_alignSelf` stretch, side margins 0, label centred;
  - through its single-child chain: the same width;
  - parents holding only CTAs: 100% wide, a column, row gap 12;
  - hugging, unpainted ancestors up to the Container or a card: 100% wide.
- **Skipped:**
  - inside floating, fixed or over-page layers, or pop-ups;
  - absolute, or hidden on phones;
  - a wrap row of 3+ CTAs (tags), or a row of 4+.
- **Tests (`buttons.test.js`):**
  - These stretch: a named button; a repeated unnamed instance with an icon; a hugging column of 2 buttons (becomes
    100%).
  - These are untouched: a one-off badge pill, an input-like field, an icon-only button, the menu toggle, a CTA in a
    fixed or over-page layer, a wrap row of 4 tags.

## Phase 5: hero with the photo behind the text

- **Finding the hero section:**
  - Skip up to 2 leading bars (≤ 200px tall, ≥ 80% of the page width).
  - The next section is the hero if it starts within 250px of the top.
  - When sections are selected one by one, the hero is `ctx.firstSection`.
  - Skip a component with states and a marquee.
- **Finding the photo:** the hero box (or its main child) has one of:
  - its own IMAGE fill covering ≥ 40%;
  - `a.cover`;
  - a full-bleed image layer.
- **Finding the text unit:** the unit holding the largest text of 24px or more, outside the header bar.
- **Finding the CTAs:**
  - The CTAs are the `isCta` layers in the text unit, plus later siblings made only of CTAs.
  - The hide list is each CTA's largest CTA-only wrapper.
- **Bottom bands:** full-width items after the text that end at the hero's bottom, such as a logo marquee. They stay
  after the button band.
- **Focal point:**
  - Take the photo's visible area minus the side the desktop text covers, and use the centre of what's left.
  - For a CROP fill, map that centre through `imageTransform`.
  - User's file: about 51% 50%. The other sample: about 24%.
- **Band colour:**
  - Composite the hero's non-image paints and overlays at the CTAs' position.
  - Then push it toward black or white until it has 4.5:1 contrast with the text and 3:1 with unfilled button labels.
  - User's file: navy ≈ #001731.
  - If the result equals the section's own backdrop, the band has no colour of its own.
- **Build (a) `heroBackgroundOnPhones`,** right after `boxBackground`, at `PHONE_MEDIA`:
  - Image layers become `cover` at the focal point, which replaces `cropCss`'s distorting percentages on phones.
  - A sideways gradient overlay turns bottom-up.
  - A scrim is added: `linear-gradient(to top, C … transparent)`, so the text stays readable at the photo's bottom.
  - For a photo element, `object-position` plus the scrim on the section's `::after`.
  - No z-index is added to the section.
- **Build (b) `heroOnPhones`,** at `PHONE_MEDIA`:
  - min-height: `calc(min(125vw, 100svh) + band)`, with a `calc(125vw + band)` fallback;
  - `flex-grow` down the holder chain;
  - `margin-top: auto` on the first item after the header bar, so the text sits at the photo's bottom;
  - a clear strip of photo above the heading: `padding-top: clamp(120px, 35vw, 220px)`;
  - the box's bottom padding becomes 0 when the band ends it.
- **Build (c) `addCtaBand`:** a phone-only block named "Phone buttons":
  - `_display: none` on desktop, flex at `:mobile_landscape`;
  - a column, row gap 12, padding 24 on top and bottom, background C;
  - full-bleed with negative side margins of the holder's phone padding;
  - `position: relative; z-index: 1`;
  - placed after the text unit and before the bottom bands;
  - holds copies of the hero CTAs, then the nav CTAs whose `ctaKey` isn't already there, each 100% wide.
- **Build (d), post-pass:** the originals in the hide list are hidden at ≤767 (`hideFrom`).
- **Tests (new `tests/hero.test.js`):**
  - A FILL photo hero with text on the left and 2 CTAs: the band comes after the text, is phone-only and holds 2
    copies at 100%.
  - The original group is hidden at 767.
  - The phone CSS has `cover`, a focal X above 50%, a `to top` scrim and `margin-top: auto`.
  - Desktop keys and CSS equal a run with responsive off.
  - The CROP focal maths.
  - A marquee stays after the band.
  - A text panel with its own fill gets no scrim.
  - Without a hero, there's no band.

## Phase 6: header-bar buttons under the hero; header on one row

- **Header rows** are horizontal rows ≤ 160px tall, in the leading bars or within the hero's top 240px, starting
  with a logo or picture. `navOf` rows count too. Their `isCta` layers are the nav CTAs.
- **The nav CTAs are moved only when a hero exists.** They are hidden at ≤767, including inside a `navOf` menu, and
  their copies go into the band (Phase 5c). Without a hero, the current behaviour is kept.
- **`rowPlan` measures landscape and phone widths without hidden items.** So a bar of logo + menu icon stays one row
  (logo left, icon right) instead of stacking. The tablet decision is unchanged.
- **Tests (`hero.test.js`):**
  - A bar inside the hero holding [logo, group(2 CTAs + icon)], with one CTA matching a hero CTA: the band holds 3
    buttons in order, the bar's originals are hidden, and the bar stays a row.
  - A separate `navOf` header plus a hero sharing a CTA: one copy, the menu toggle intact.
  - `nav.test.js` passes unchanged.

## Phase 7: hero with the photo beside the text

- **Detection:** the hero box (or its single wrapper) is a row with:
  - a text unit holding the heading;
  - a photo item at least 25% of the width, beside it.
- **At 767:**
  - `order` is text 0, photo 1, band 2.
  - The row becomes a column if the plan didn't already stack it; mirrored rows too.
  - The photo spans 100% at `aspect-ratio: clamp(w/h, 4/5, 4/3)` with `object-fit: cover` (or a cover background).
  - The CTA band and hide list work as in Phases 5 and 6. When the colour matches the section, the band has no
    background and no negative margins.
- **Test:** a photo-left hero fixture. Neither sample has a split hero, so neither should change in this phase.

## Phase 8: text and spacing polish (recommended)

- **a. Whole-pixel type.**
  - `scaleType` (~402) rounds, and `fitSize` caps use `Math.floor`.
  - Update `responsive.test.js` (88.8 → 89, 62.8 → 63).
  - Class sizes change, so the first re-paste shows Import-classes conflicts once. Note this in the README.
- **b. Balanced lines.** At `PHONE_MEDIA`, from `addText`:
  - `text-wrap-style: balance` on headings (an h tag, or 22px and up);
  - `text-wrap-style: pretty` on texts of 60+ characters;
  - not on truncated texts or lists.

  The longhand keeps `white-space: nowrap` pins and `RESET_DECLS` working.
- **c. The long-word cap measures the real column:** the device's content width minus the padding of the boxes
  around the text, instead of the whole screen.
- **d. Spacing:**
  - `scaleSpace` (~408) on phones becomes `v ≤ 24 ? v : max(24, v·0.5)`, which removes the jump at 40.
  - `applyRowPlan` (~2215): fix the landscape gap fallback, so it takes the tablet value before the desktop one.
  - Stacked-row gaps are capped: 48 on iPad, 40 on landscape phones, 32 on portrait phones.
  - Review each changed expectation in `spacing`, `padding`, `loose` and `responsive` tests before updating it.
- **e. Consistent alignment.** In a column whose texts are all centred, hugging non-text items (icons, logos, rating
  rows) get `_alignSelf:mobile_landscape center`. Left-aligned paragraphs and lists are never centred.
- **f.** Add `-webkit-text-size-adjust: 100%` on sections, so iOS doesn't inflate text in landscape.

## Defaults I chose (can be changed at approval)

- **EAST/NORTH-type tabs:** on phones they show after the hero's content at their own side, neither hidden nor fixed
  to the screen. As buttons in a layer drawn over the page, they're excluded from the full-width rule.
- **Footer component that includes a contact band:** the whole component is centred, consistent with "a section
  named Footer".
- **Nav buttons leave the phone menu** when a hero exists, because they now sit under the photo.
- **Breakpoints:** buttons go full width at ≤478 (iPhone portrait). The band under the photo and the reordering apply
  at ≤767.
- **Missed buttons:** an unnamed, one-off button with no link, no icon and no reaction isn't recognised as a CTA.
- **To check on a real device/Bricks:** `text-wrap-style` and `svh` are progressive. Older Safari ignores them, which
  is harmless.

## Files

- `code.js`: all phases.
- `README.md`: the iPad/iPhone table and bullets (Type, Padding and gaps, Photo rows, Header, new Hero and Buttons
  rows, the slider bullet, page split, footers).
- `tests/hero.test.js` (new), `slider.test.js`, `pages.test.js`, `realpage.test.js`, `buttons.test.js`,
  `responsive.test.js`, `fixtures.js`.
- `CLAUDE.md`: add these decisions under "Decisions the user made". It is local-only and not committed (no git repo
  here).
- Save a memory note: the user says "header" for the top hero photo section.
- `PLUGIN_BUILD`: re-read it first (currently `2026-10-01.2`), then bump once per delivery.

## Verification (each phase)

1. **Tests.** `node tests/run.js` is all green.
2. **Prove each new test catches the bug.** Copy `code.js` and `tests/` to the scratchpad, repoint `ROOT` in the
   copy's `tests/harness.js`, undo the fix there, and watch the test fail.
3. **Baseline renders.** From an unmodified copy, run `node tests/tools/snap.js <file> <dir> 1512,390` for the
   user's file and `1728,390` for `figma-to-bricks-debug-design.json`. Slice the 390 render with an iframe and a
   negative margin-top, since Chrome windows are at least 500px wide.
4. **Normalised diff.** A scratch script renumbers element ids in content order, splits `_cssCustom` into rules, and
   flags any change outside `:tablet_*`/`:mobile_*` keys, media rules or phone-only elements. Desktop must be
   identical, except that Phase 1 splits the user's page into 8 sections.
5. **Look at the user's file at 390:**
   - logo left and menu icon right;
   - the photo cropped on the people, with the heading and text at its bottom over navy;
   - a band of 3 full-width buttons, then the logo marquee, then the tabs;
   - the collage at 4 slides of one photo each, about 343×429;
   - full-width buttons everywhere else;
   - whole-pixel type and no gaps over 32px;
   - the footer as the last section, centred, columns stacked, copyright centred.
6. **Look at `figma-to-bricks-debug-design.json` at 390:**
   - the hero card cropped near 24%;
   - "Schedule Your Visit" once, in the band, and gone from the opened menu (probe by adding `brx-open`);
   - the "1000+ Clients" pill untouched.
7. **Desktop pictures.** The 1512 and 1728 screenshots match the baseline, apart from the user's file's
   section split.
8. **Sandbox safety.** `tests/smoke.test.js` passes: no `import` followed by `(`, `//` or `/*`, and no `<!--` or
   `-->`.
