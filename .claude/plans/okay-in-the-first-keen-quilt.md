# Automatic iPad and iPhone versions

## Context
Desktop output now matches Figma. On iPad and iPhone it "does not look good at all".

Today, with only a desktop design, the plugin adapts only at iPhone width (Bricks `mobile_portrait`, ≤478px), through `phoneValue()`, and only in pixel mode:
- big type ×0.62;
- padding and gaps ×0.5;
- heights released;
- wide rows stacked;
- grids down to 1 column (3+ columns go to 2 at ≤991px).

From 479 to 991px (iPad portrait, big phones) every desktop value stays: 224px side padding, 120px headings. Above 991px (iPad landscape, laptops) the desktop layout is just squeezed. On iPhone, photos and cards stack.

**What the user asked for:** when copied, the page adapts automatically for desktop, iPad and iPhone.

**Decisions:**
- **iPhone:** rows of photos and rows of image cards become swipe sliders (the next card peeks in); cards without photos stack.
- **iPad:** card rows stay side by side; fonts, spacing and everything else are scaled.
- **Header:** gets a menu (hamburger) button where the nav no longer fits.
- **How values are written:** as Bricks per-device settings (tablet / phone keys), editable in Bricks. Widths between iPad and desktop scale smoothly; desktop stays exact at the design width.
- **Real phone/tablet designs:** when they are supplied (Breakpoint designs, `ctx.opts.responsive = false`), they still replace all of this.

## Ground rules
- **Bricks cascades desktop → tablet_portrait (≤991) → mobile_landscape (≤767) → mobile_portrait (≤478).** Every decision is checked at the narrowest width each tier covers:

  | Tier | Narrowest width | Content width |
  |---|---|---|
  | tablet | 768 | ~688 |
  | landscape (inherits tablet) | 479 | ~399 |
  | phone | 375 | 335 |

- **Scaled type and spacing apply in pixel mode only.** Normal mode already scales fluidly with `fluid()`. The layout rules (rows, sliders, grids, menu) apply whenever `ctx.opts.responsive` is on.
- **Custom CSS beats Bricks controls at the same specificity.** Where a new device setting would lose to an existing CSS rule, use a stronger selector or narrow that rule's media query.

## Steps (all in `code.js` unless noted)

### 1. Device profile
Near `MOBILE` (line ~42), add:
- `TABLET = ":tablet_portrait"` and a `DEVICES` table (key, narrowest width, content width);
- `scaleType(size)`: 16 + (size − 16) × 0.7 for tablet and × 0.45 for phone. That gives 120 → 89 / 63 and 56 → 44 / 34;
- `scaleSpace(v)`: values of 40 or more (gaps 48 or more) are ×0.7 on tablet (at least 32) and ×0.5 on phone (at least 20);
- `setDevices(s, key, desk, tab, ph)`: writes the tablet key when it differs from desktop, and the phone key whenever it differs from what the phone would inherit;
- `deviceKeys(k)`: the key plus its breakpoint versions. It replaces the MOBILE-only delete lists in `addShape`, the accordion code and `stretchToParent`;
- a 992px floor option for `fluid()`. It gives the smooth `clamp()` for widths between 992px and the design width W: tablet value at 992, exact desktop value at W (intercept rounded up).

### 2. Type
- `typography()` returns `{ ty, tablet, phone }` and adds the 992→W clamp for sizes of 40px and more.
- **Letter-spacing scales** with the font size.
- **Changes under 1px are skipped**, so text of 18px and less is untouched.
- **Longest-word fit cap**, on the element, checked at 335px (phone) and 399px (landscape):
  - character width is estimated from one-line text (width ÷ (characters × size));
  - otherwise 0.62, or 0.72 for uppercase.
- **Classes:** `classFor` stores the tablet values and `resolveClasses` writes `_typography:tablet_portrait` as well as the phone values.
- **Wrapping on tablet:**
  - fixed-width one-line text (`nowrap`) is released at ≤991 instead of ≤767, so cards can shrink on iPad;
  - text whose font scales at tablet (`m.scaled`) also releases its pinned Figma line breaks at ≤991, in `finalizeTexts`, so lines don't come out ragged.

### 3. Spacing
`scaleSpace` / `setDevices` are used by:
- `paddingStyles`;
- the gaps in `layoutStyles` and `gridStyles`;
- the `addSection` padding: side ≤40 on tablet (as a 992→W clamp) and ≤20 on phone; vertical ×0.7 and ×0.5.

### 4. Heights and pictures
- **Heights:** fixed box and section heights are released on tablet as well as phone.
- **Guard:** a box whose layers are all absolutely positioned (`mode === "NONE"`) keeps its height. That also fixes a latent phone bug.
- **Pictures:** photos and non-background videos with a fixed height get plain CSS `aspect-ratio: w / h` (harmless on desktop) plus `_height:tablet_portrait` / `:mobile_portrait = auto`. They scale with their width instead of being cropped harder. Photos that fill the row's height are skipped.

### 5. Row plan
A new `rowPlan(node, a)`, called from `layoutStyles`, decides each row's behaviour. `place()` in `convertChildren` applies it through one `twoUp()` helper.
- **Phone, one of:**
  - **slider:** see step 6;
  - **pairs:** 3 or more small non-photo items, each 25% of the row or less (the stats), wrap two per row;
  - **stack:** today's rule;
  - **wrap:** small rows;
  - **nav:** see step 8.
- **Tablet and landscape:**
  - card rows stay side by side where each card keeps at least ~200px at 688 / 399. Otherwise they go 2-up; four cards are 2-up on tablet;
  - rows of content-sized items (buttons, tags) wrap;
  - dividers of 2px or thinner are hidden when a row wraps or stacks.
- **Rows set to wrap (`a.wrap`)** are included; imports use them for card grids.
- The hug-box `width: fit-content` rule (`sizeStyles`, line ~933) no longer blocks tablet/phone widths on those children.

### 6. iPhone slider
**Detection:**
- 2 or more flow children, of which at least ⅔ are photos (at least 120px wide and 100px tall, so logo strips don't qualify) or cards led by a photo at least 60% of the card's width;
- a card's leading photo is its first child with an image fill, looking through up to 2 single-child wrappers.

**Output at ≤478px:**
- Rows: the container is a horizontal, non-wrapping row with `overflow-x: auto`, `scroll-snap-type: x mandatory` and a hidden scrollbar. Children are `flex: 0 0 82%` with `scroll-snap-align: start`. No stacking.
- Grids: `grid-auto-flow: column; grid-auto-columns: 82%; grid-template-columns: none; overflow-x: auto` with snap, in `gridStyles` / `gridItemStyles`.
- **Tablet grids** keep their columns if (688 − gaps) ÷ columns is at least 200, otherwise they drop to 2.

### 7. Carousel
`addCarousel` writes `slidesToShow` and `gutter` per breakpoint from 688 and 335.

### 8. Header menu
**Detection (`navOf`, in `layoutStyles`):**
- where: in the first section of a page, or in a section or row named header, nav, menu or top;
- shape: a horizontal row whose first child holds the logo, plus a group of 3 or more short text links;
- structure: flat, or one level of plain wrappers (no fill, stroke or effect), which are flattened with `display: contents` at the breakpoint. Anything else is skipped.

**Where it applies:** where the row's content no longer fits 688px (else 399px or 335px).

**What `makeNav` does** (at the end of `convertChildren`):
- A Bricks **Toggle** (name `toggle`; `toggleSelector: ".f2b-nav-<hashId>"`, `animation`, `barColor`, `ariaLabel: "Menu"`) is spliced into the row's children right after the logo.
- The toggle is hidden on wider screens and shown below the breakpoint.
- The row gets `_cssClasses: f2b-nav-<hashId>` (repeatable) and wraps below the breakpoint: the logo grows, and the other groups are 100% wide and stacked.
- They're hidden with `.f2b-nav-X:not(.brx-open) > %ID% { display: none }`, so each one's own display comes back when the menu opens.
- The open menu's background comes from the section's solid fill or `backdropOf`.

### 9. UI, README, build
- `ui.html` (line ~613): "Adapt for tablets and phones (desktop stays exact)".
- `README.md`:
  - rewrite the responsive section as a per-device table (type, spacing, rows, grids, slider, menu, smooth 992→design scaling);
  - explain that 479–767px is decided by available width;
  - note that the menu and sliders work on the live page;
  - add the Toggle keys and `slidesToShow:<breakpoint>` to the "not yet confirmed" calibration list.
- Bump `PLUGIN_BUILD`.

## Tests
New `tests/responsive.test.js` and `tests/nav.test.js`, in the style of `sizing.test.js` / `accordion.test.js`, using `ctxFor(c, { pixel: true, responsive: true })`:
- **Type:**
  - a 120px heading gets tablet 89 and phone 63, or less when capped;
  - the class carries both;
  - 16px text has no override;
  - letter-spacing scales;
  - the clamp equals the desktop value at W and the tablet value at 992.
- **Cascade:** walk every element and check that any key written for tablet has its phone value decided.
- **Sections:** padding 224 → 40 on tablet and 20 on phone; vertical ×0.7 and ×0.5.
- **Heights and pictures:** a layout-less box keeps its height; a fixed photo gets `aspect-ratio` and `height: auto` on tablet.
- **Rows:**
  - 3 image cards → phone slider, not stacked;
  - 3 cards without photos → stacked;
  - 4 stats → 2-up;
  - 4 cards → 2-up on tablet;
  - a logo row → not a slider.
- **Grids:** a 3-column grid keeps 3 columns on tablet and becomes a phone slider when it holds photos.
- **Nav:**
  - toggle right after the logo, hidden on desktop;
  - class on the row, and the hide rules;
  - breakpoint chosen from the content width;
  - no stacking;
  - a footer link row untouched.
- **Off:** with `responsive: false` or breakpoint designs, nothing new is written; the output matches the old one.
- **Update existing:** `grid.test.js` (3 → 2 on tablet) and `spacing.test.js` (the phone-only padding assumptions).

## Verification
1. `node tests/run.js`: every suite passes.
2. Close and reopen the plugin, convert "Home Page Final" and paste into Bricks. The new build stamp should show.
3. In Bricks, switch the canvas to tablet, mobile landscape and mobile portrait. Check:
   - scaled headings, with 40px side padding on iPad and 20px on iPhone;
   - the gallery and service cards swipe on iPhone;
   - the stats sit two per row;
   - the header shows logo + menu button, and the menu opens on the live page or in preview;
   - the logo carousel shows fewer logos.
4. At 1728px and wider nothing changes from today's desktop output (desktop regression tests stay green).
