# Phone polish, then faithful Figma animations

## Context

The user feels the iPhone output "does not look as polished as it should" and that desktop "misses animation". They asked whether machine learning could help. We decided not to use it:

- **No training data:** there are no pairs of a desktop design and its good phone version.
- **An AI call per run** would cost money, slow every run and give different output each time.
- **It wouldn't fix the causes, which are in the rules:**
  - **Fixed formulas.** Phone type is `16+(s−16)×0.45`, so 24/20/18 become 20/18/17 and heading levels merge. Spacing is halved with no limit (294 → 147).
  - **Spacing bugs.** In `addSection`, the overlap branch (`code.js` around 6231) keeps the desktop top padding on phones (120 → 119). `addInsetSection` never scales its padding.
  - **Missing phone patterns:** a real menu panel, a slider peek, 2-column small grids, 44px tap targets.
  - **States and overlays never animate out.** They fade in with `@starting-style`, but there is no `allow-discrete` exit, so they snap away.

Both saved designs use the automatic phone layout (`responsive: true`, `breakpoints: false`), and neither has Motion keyframes. "Meet Team" has the following prototype interactions:

| Interaction | Count |
|---|---|
| Hover, Dissolve | 52 |
| Hover, Instant | 24 |
| Click, Dissolve | 45 |
| Click, Smart animate | 40 |
| After delay | 3 |

So "missing animation" means these interactions convert without their exits and moves.

### Decisions the user made (2026-10-01)

1. **Order:** phone polish first, then animations, done one after the other.
2. **Phone menu:** a slide-in panel from the right over a dimmed page, with big links and a close (×) button.
3. **Header CTA:** shown in **both places** on phones, under the hero photo (as now) and at the bottom of the menu panel. This changes the earlier "each once" rule only for the hidden panel.
4. **Photo card rows on phones:** a slider (one photo per slide) **with a peek** of the next card, plus better padding and spacing.
5. **Alternating photo/text rows on phones:** **photo first, always**.
6. **Animations: nothing new or invented.** Only what's in Figma, converted faithfully. No automatic scroll reveals or hover lifts.

### Defaults chosen (no need to ask; listed so they can be reviewed)

- **A menu the designer drew** (Meet Team's 417px menu variant) stays as designed, just fitted to the phone width.
- **Panel links** are at least 20px text and 48px tall. Phone display type is capped around 56px.
- **Jump links (`#section`) in the panel** can't close it without a script. Most nav links go to other pages, which closes it anyway. This is listed in the README.
- **The 16px input rule is skipped:** the plugin builds no text fields.
- **Smart animate movement** between different states only on desktop widths. Phones keep the fade.
- **Navigate page transitions are skipped:** Meet Team's are all Instant.

### Constraints

- Another session is editing `code.js` (hero code; the build went from `.4` to `.5` while we planned). Start only after it lands, re-read `PLUGIN_BUILD` before each bump, and don't touch `heroOf`/`heroOnPhones` except for item 1f's CTA rule.
- Follow `CLAUDE.md`:
  - general rules, no hardcoding from the file under test;
  - a generic fixture per rule;
  - no script on the page;
  - keep the stacking levels (fixed 90, sticky header 100, pop-ups 9999);
  - slider `height: "auto"`, never `autoHeight`;
  - whole-pixel type, full-width CTAs, centred footer;
  - the SES `import` comment rule.

---

## Phase 0: Audit and baseline (scratchpad only)

Set `S` to this session's scratchpad. Copy `code.js` to `$S/base/` under its build number.

1. **Renders:**
   ```
   node tests/tools/replay.js figma-to-bricks-debug-final-design.json $S/base/meet-replay
   node tests/tools/snap.js figma-to-bricks-debug-final-design.json $S/base/meet 1440,430,390,375
   node tests/tools/snap.js figma-to-bricks-debug-design.json $S/base/landing 1440,430,390,375
   ```
   Then run `overview.js` for side-by-side sheets.
2. **Normalized JSON baseline** for diffs. Ids come from `Math.random`, and the harness passes the host `Math` in, so seed it:
   ```
   node -e 'let s=42;Math.random=()=>(s=(s*16807)%2147483647)/2147483647;
     const {replay}=require("./tests/tools/replay"),fs=require("fs");const [f,o]=process.argv.slice(1);
     replay(JSON.parse(fs.readFileSync(f,"utf8"))).then(r=>{const m={};r.payload.content.forEach((e,i)=>m[e.id]="e"+i);
     fs.writeFileSync(o,JSON.stringify(r.payload,null,1).replace(/\b[a-z0-9]{6}\b/g,x=>m[x]||x));fs.writeFileSync(o+".warn",r.warnings.join("\n"))})' \
     <debug.json> $S/base/<name>.norm.json
   ```
   After each build, run the same command into `$S/new/` and `diff -u` it against the base.
3. **Tooling fixes** (test tools only):
   - `tests/tools/snap.js`: descend through single-child wrapper frames when slicing Figma sections. Meet Team today gives one `figma-s1.png`.
   - `tests/tools/render.js:104`: stop hardcoding the `data-splide` options, so the peek and gap show in renders.
4. **Probes at 375** with `probe.js`:
   - clickables under 44px;
   - section paddings and gaps;
   - stacked sliders per section;
   - single-column runs of small items.

   These confirm the order below. Show the user the before sheets.

---

## Phase 1: Phone polish (in this order, each its own tested build)

### 1b. Spacing rhythm (highest impact)

One monotone, capped, whole-pixel phone-spacing rule with a **role**, so a bigger desktop space never ends up smaller than a smaller one.

- Extend `scaleSpace(v, threshold, role)` (`code.js` ~410) with these roles:
  - `section`: cluster the page's section paddings (within ×1.25 they share a value), computed once in `planPhones` as `ctx.phoneSpace`;
  - `band`: gaps between bands, capped about 48;
  - `stack`: replaces `STACK_GAP`;
  - `inset`: replaces the 40/20 caps in `paddingStyles`.
- Values ≤24 stay as they are; 39 and 40 still match (existing test).
- **Apply it in:**
  - `addSection`: the normal path, and the overlap branch, which should ignore overlaps ≤2px and use `min(rest, scaled)` per device;
  - `addInsetSection`;
  - `stackOnDevices`, `gridStyles`, `layoutStyles` and the marquee.
- **Tests (spacing/responsive):**
  - 80/120/160 give ordered whole-pixel phone paddings;
  - a 1px overlap doesn't keep 119;
  - an inset section's 94 scales;
  - a band gap of 294 is ≤48;
  - no fractional phone spacing.
- **Risk: high.** Many expected numbers move; list each change.

### 1e. Slider: peek, spacing, merged rows

- **Peek:** in `makeSlider` (~1968), custom CSS at `SLIDER_MEDIA` on `.splide__track`: `padding-right: <gap + ~14%>`.
  - Leave `sliderSettings()` unchanged.
  - Check whether the CSS beats Splide's inline padding in Chrome at 375/430, and use `!important` only if it doesn't.
  - Slide gap about 12–16px, dots spaced from the cards.
- **Merged rows:** consecutive sibling rows that each pass `sliderSet` with similar cards (±15% width, ±20% height), with nothing between them, become **one** slider after the last row. Meet Team's 3×2 grid gives 1 slider of 6, not 2 sliders of 3. Detect this at the parent, before `makeSlider`.
- **Tests (slider):**
  - the peek rule exists and `autoHeight` is still absent;
  - a 2×3 photo-card column gives 1 slider with 6 slides.

### 1f. Slide-in menu panel (`makeNav` ~1785)

Keep the Bricks Toggle; `brx-open` is the open state.

- **Wrapper:** wrap the links in a "Menu" block that is `display: contents` above the menu width, so desktop doesn't change.
- **Panel, at the menu width:**
  - `position: fixed; inset: 0 0 0 auto; width: min(86vw, 380px); height: 100dvh; overflow-y: auto`, laid out as a column;
  - an opaque background that contrasts with the links;
  - closed it is moved fully off-screen to the right and hidden; open it slides in;
  - reduced motion: no slide.
- **Two extra toggles** on the same `toggleSelector`:
  - a **× close** at the top of the panel, drawn with pseudo-elements;
  - a **backdrop** (fixed, `rgba(0,0,0,.45)`, fades).
- **Spin animation:** drop `animation: "spin"` from the hamburger, since its state can desync when the menu is closed elsewhere.
- **Links:** full-width rows, at least 48px tall, `max(own, 20px)` text. The nav CTA goes last, pushed down with `margin-top: auto`.
- **CTA in both places:** in `heroOnPhones`, don't hide a `navCtas` button that lives inside the panel. The copy under the hero stays. Coordinate with the hero session.
- **Stacking while open:**
  - `html:has(.<menu>.brx-open){overflow:hidden}`;
  - a header that isn't sticky gets `position:relative; z-index:100` (mirrors `raiseOpenDropdowns`);
  - ancestors with `backdrop-filter`, `transform` or `filter` get `none` so the fixed panel isn't trapped;
  - `ctasOnPhones` treats the panel as a boundary.
- **Designer-drawn menus** (a row with its own menu interaction): no plugin menu, and the designed panel gets `max-width: 100vw`.
- **Tests (nav):**
  - the wrapper and `display: contents` on desktop;
  - the panel rules;
  - both extra toggles;
  - CTA last and still under the hero;
  - scroll lock, header lift and filter reset;
  - a designer-drawn menu is left alone.

### 1c. Small items keep columns

A shared helper `smallItems(items, gap)` used by `rowPlan` (its "pairs" logic moves in) and by `gridStyles`'s portrait template (~1678, today always 1 column).

- **Pictures only, no card photo** (logos, icons): 3 columns.
- **≤3 short texts** (≤40 characters, longest line fits half a column): 2 columns.
- **Cards with paragraphs:** 1 column.
- **Odd counts:** the last item spans the row.
- **Tests (grid):** 6 icon features give 2 columns, 6 logos give 3, paragraph cards give 1.

### 1g. Tap targets

A post-pass in `phonePostPass` for links, `label` controls and toggles under 44px.

- At `(hover: none)`, expand the tap area with a free pseudo-element (`freePseudo`): `inset: min(0px, calc(50% - 22px))`, plus `position: relative` on the element.
- Skip it when both pseudo-elements are taken, or the element holds absolutely placed layers.
- The layout doesn't change.

### 1a. Type scale

- In `convertRun`, before `buildSections`, compute `ctx.typeScale` from the file's local text styles plus the page's sizes:
  - **Body** = the size that covers the most characters (≤20).
  - **Larger levels** start from today's formula, then walk upward: where the desktop ratio is ≥1.1, each level is at least `max(2, ⌈10%⌉)` above the one below. Display type is capped at about 56, in whole pixels.
- `scaleType(size, ctx)` (~403) falls back to the formula when no scale exists.
- `addButton` labels get tablet and phone sizes.
- Phone line-height is capped at 1.2 for sizes ≥28.
- **Tests:** levels strictly increase; the same size maps to the same phone size; global classes carry the scale (classes/styles tests stay stable across runs).

### 1d. Photo first in alternating rows

A post-pass `mediaFirstOnPhones`: on a page with two or more stacked two-item rows (a photo and a text column) whose photos sit on different sides, the photo gets `order: -1` at the stack width.

- Skip the hero (`ctx.phone.hero`), mirrored rows and section states.
- **Test:** two rows with the photo on opposite sides both give photo-first on phones.

---

## Phase 2: Figma animations, faithful, nothing invented

1. **Exits for states** (`stateCss` ~4731):
   - **Hover states:** the hidden rule keeps the hover-over positioning, with `opacity: 0` and `transition: opacity, display allow-discrete`, so they fade out as Figma reverses.
   - **Click states:** per pair k→j, add `:has(.T-go{j}:checked) > state_k` with the leaving values and j's timing.
   - **Dissolve:** the new state over the old. Use a cross-fade if exact layering would need a z-index or `isolation` that breaks CLAUDE.md's stacking rules.
2. **Exits for overlays** (`overlayEntry` ~4920): closed values and `allow-discrete` on the pop-up, its background and dropdowns, so closing reverses opening.
3. **Move out / Slide out / Push:** the leaving translate in `stateCss` and `overlayEntry`. Push moves both states.
4. **Springs on hovers:** `collectHovers`/`toggleOf` use `motionEasing` instead of `easingCss`.
5. **Mouse leave:**
   - Mouse enter A→B paired with Mouse leave B→A becomes a hover with separate enter and leave timing.
   - An unpaired one gets a warning in `noteInteractions` instead of being dropped silently.
6. **Smart animate between different states** (desktop widths only): pair layers (`pairLayers`, `ctx.elNode`/`origId`). The entering state's matched layers start in `@starting-style` from the source's position and size and move into place; unmatched layers fade. Only when the entering state has a single Smart-animate source.
7. **Motion plays once in view:**
   - Check `CSS.supports` in the installed Chrome for `animation-trigger`/`timeline-trigger`, confirming the exact syntax.
   - Where supported, play the timed animation on entering view.
   - Keep today's `view()` timeline and on-load as fallbacks.
8. **Audit tool** `tests/tools/states.js`. For each machine state in Meet Team:
   - force it (check the radio, or rewrite `:hover` to a class);
   - screenshot at 1440 beside `figma-state-*.png`;
   - flip it both ways and log `document.getAnimations()`;
   - compare with the debug file's transitions. Leave animations should be empty before Phase 2 and match after.
9. **Tests (interactions):**
   - exit rules per pair, `allow-discrete`;
   - spring curves;
   - Mouse leave pairing;
   - the Smart-animate `@starting-style` translate.

---

## Critical files

- `code.js`:
  - spacing: `scaleSpace`, `scaleType`, `addSection`, `addInsetSection`, `paddingStyles`, `STACK_GAP`/`stackOnDevices`;
  - layout: `gridStyles`, `rowPlan`;
  - slider: `makeSlider`, `sliderSet`;
  - menu and phone pass: `makeNav`, `phonePostPass`, `heroOnPhones` (only the nav CTA rule);
  - states and overlays: `stateCss`, `overlayEntry`, `collectHovers`, `toggleOf`, `TRIGGER_KIND`/`noteInteractions`, `applyMotion`;
  - `PLUGIN_BUILD`.
- `tests/`:
  - `spacing.test.js`, `responsive.test.js`, `slider.test.js`, `nav.test.js`, `grid.test.js`, `interactions.test.js`, `fixtures.js`;
  - `tools/render.js`, `tools/snap.js`, new `tools/states.js`.
- `README.md`: the phone table and "Animations / Interactive components".
- `CLAUDE.md`: add decisions 2–6 under "Decisions the user made".

## Verification (every item)

1. `node tests/run.js` passes, including `smoke.test.js` (the SES comment rule).
2. Prove each new test fails with the fix undone: copy `code.js` and `tests/` to the scratchpad and repoint `ROOT` in the copy's harness.
3. Diff the normalized replays of both debug files against `$S/base`. Only the intended rules may change. `figma-to-bricks-debug-design.json` must not change unexpectedly.
4. Snap at 375/390/430/1440 and compare with the Phase 0 sheets. Show the user before and after for each phone item.
5. Phase 2: run the states audit tool, which logs leave animations, plus hover emulation in headless Chrome.
6. Bump `PLUGIN_BUILD` (re-read it first). The user pastes into Bricks and checks the menu and the slider peek on a real iPhone. The Toggle and Splide CSS route is unverified in Bricks itself.
