# Figma to Bricks: instructions for every agent

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
- **Don't regress other files.** Fixing one design must not break another. Run `node tests/run.js` and add a test
  for the new pattern, built as a generic fixture rather than a copy of the user's file.
- **If a special case is truly unavoidable, say so first.** Explain why the request can't be generalised and ask
  before adding a targeted exception. The exception must detect a condition that could occur in any file, never
  a particular file.

## Working in this repo

- **Files:**
  - `code.js` is the Figma sandbox code, about 7000 lines; find functions with grep.
  - `ui.html` is the panel.
  - There is no build step.
- **Tests:** `node tests/run.js` uses plain Node. `tests/harness.js` loads `code.js` in a vm and exposes every top-level function; fixtures are in `tests/fixtures.js`.
- **Build number:** bump `PLUGIN_BUILD` in `code.js` (`YYYY-MM-DD.N`) for every change the user will paste. Read the current value first, because another session may have bumped it.
- **Figma's sandbox (SES) refuses to open the plugin** when `import` is followed by `(`, `//` or `/*`, or when `<!--` or `-->` appears anywhere, even in comments. Never end a comment line with the word "import". `tests/smoke.test.js` guards this.
- **Tracked edits:** the edit tool doesn't track edits made with scripts (python/sed). Re-read `code.js` before editing after one.
- **Bricks gives every Block `width: 100%`.** A layer that should size from `left` and `right` needs `_width: "auto"`; deleting `_width` isn't enough.
- **Figma's switched copies pair layers by name.** They carry text into a same-named layer of the other variant (a description pushed into a title), so only the words an instance really changed count (`instanceContent`).

## Debugging a user's design

- **Ask for a debug file** (the panel's "Save debug file"): `figma-to-bricks-debug-*.json`. Check its `build` and root frame name first, because users re-save it from other pages and builds.
- **Replay:** `node tests/tools/replay.js <debug.json> <outDir>` writes:
  - `bricks.json` and `warnings.txt`;
  - `figma-*.png`;
  - `figma-state-*.png`, Figma's own picture of each component state.

  The replay uses stand-in images and can't clone instances, so states use the `makeProxy` fallback.
- **Browser check:** `node tests/tools/snap.js <debug.json> <outDir> <width>` renders `bricks.html` and screenshots. Then probe with headless Chrome (`--dump-dom` plus an injected script):
  - **Hover:** emulate it by rewriting `:hover` to a class inside the `<style>` tags.
  - **What paints on top:** `elementFromPoint` skips `pointer-events: none`, so add `*{pointer-events:auto !important}` first.
  - **Small or partial areas:** Chrome windows are at least 500px wide. For narrow widths or part of a page, shoot an `<iframe>` with a negative `margin-top`.
- **Prove a new test catches the bug:** copy `code.js` and `tests/` to a scratch folder and point `ROOT` in the copy's `tests/harness.js` (it is hard-coded) at it. Undo the fix there and check that the test fails.
- **Before saying it's fixed:**
  - replay the user's file and look at it in Chrome;
  - diff the replay output against the previous build's; for a change that must not change the look,
    `node tests/tools/same-look.js <copy of the previous build> <debug.json> <outDir>` measures every element of both
    in Chrome (copy the plugin folder before you start);
  - check that `figma-to-bricks-debug-design.json` doesn't change unexpectedly.
- **User screenshots are usually the Bricks editor:** clicks there select elements, hover works, and its stacking can differ from the front end.

## Decisions the user made (don't reverse without asking)

- **Interactions:** every Figma interaction works on the live page as plain HTML and CSS, with no script: radio buttons and checkboxes in a `<label>`, `:has()`, `@starting-style`, `@keyframes`.
  - **Hover:** exactly as in Figma; on phones a tap does the hover.
  - **Motion:** plays when scrolled into view.
  - **Only Figma's animations** (2026-10-01): convert what the design sets up, faithfully (entering and leaving). Never
    invent motion the design doesn't have: no automatic scroll reveals, hover lifts or added transitions.
  - **Navigate:** goes to `/slug-of-frame-name/`; a frame named Home… goes to `/`.
- **Other states of a component show the variant as designed.**
  - **Look comes from the variant:** fills, outlines, effects, corner radii, text colours and text styling.
  - **The instance keeps only its real content:** words and photos that differ from its own main component, layers it hides, padding and spacing.
  - **Colours changed on the instance for the page are not carried over,** even though Figma's prototype player and Figma's own switched copy carry them.
  - **Figma's switched copies** (`figmaState`) are used only for layout and for pairing layers (`makeProxy`, `stateCopy`).
- **Hover styles vs. states:** use CSS hover styles only where `hoverExpressible` says `hoverDiff` draws the change exactly:
  - flat colours, outline colour, corner radii and shadows;
  - the text's weight, slant, spacing, case and underline, the same over the whole text.

  Anything else (a gradient, a photo, stacked paints, an icon's colour, a change of font or size) is built as states by the full converter. `lookChanges` compares what shows: a colour by its value, a picture's placement to within a pixel.
- **Placed layers follow their Figma constraints** when the box isn't the design's width (`convertChildren` → `place`):
  - Center → `_left: calc(50% ± …px)`;
  - Right → `_right`;
  - Left & Right → `_left` + `_right` + `_width: auto`;
  - Scale → percentages.
- **Stacking keeps Figma's layer order.**
  - Page content never rises above its section's level (z-index 1 at most).
  - A hovered component is contained with `isolation: isolate` and never gets a z-index, so a layer Figma paints above it stays above it.
  - Only floating layers go above the page: open dropdowns (50, lifting their ancestors while open), fixed layers (90), a sticky header (100) and pop-ups (9999).
- **Phones, when the plugin builds them from a desktop design** (2026-10-01; the user calls the hero "the header"):
  - **Hero, photo behind text:** photo cropped to its subject; heading and text stay on the photo; **every CTA goes
    right under the photo**, the header bar's included, each once (copies in a phone-only "Phone buttons" box). A
    header CTA in the menu panel stays there too (shown only while the menu is open).
  - **Menu:** a panel sliding in from the right over the dimmed page, links one per line (20px+, 48px lines), the
    header's button under them; the Bricks Toggle stays on top and turns into the × that closes it (`makeMenuPanel`).
  - **Photo/text zigzag rows:** photo first in every row once stacked (`photoGoesFirst`).
  - **Photo-card slider:** one slide per view, nothing of the next card showing (the user tried a peek and dropped
    it, 2026-10-01); at most 16px between cards; stacked rows of alike cards swipe as one slider (`sliderRun`).
  - **Spacing:** one capped, whole-pixel, monotone rule (`scaleSpace`): sections at most 64px top and bottom, gaps 48.
  - **Section intro on phones:** heading, text, then its button (`ctaAfterText`); photo cards keep their photo's shape
    (`photoShaped`), two per row where they can't slide; stacked items' divider padding evens out (`placeOnDevices`).
  - **Hero, photo beside text:** text, then photo, then buttons.
  - **Every call-to-action button is full width** on phones, cards included (not tags, floating layers, icon buttons).
  - **One photo per slide.** A photo group without text splits into slides; a card with text keeps its largest photo.
  - **Footer** last on the page and centred; text and spacing: whole-pixel type, balanced headings, capped gaps.
- **Website rules** (2026-10-02: HTML5 semantics, WCAG 2.2 AA, search and speed basics; the user means technical
  rules, not laws). The look never changes to follow one:
  - **The design breaks a rule** (faint text, small targets, tiny text): never recolour or resize. The list of what
    the design breaks (`auditPass`, Findings with Show) is **off unless the panel's design check is ticked** (user,
    2026-10-02: "I just want to implement these rules", not a wall of errors). The rules themselves always apply.
  - **Extras Figma never shows** only where mouse and touch users can't see them: keyboard focus ring
    (`:focus-visible`), reduced motion, a pause control that appears on Tab (`a11yCssPass`).
  - **Bricks owns** `<main>`, the skip link and the page header/footer (its templates): the plugin never emits `main`,
    `header`, `footer` or a second skip link.
  - **Headings** from structure (`headingOutline`); **alt text** annotation → panel (saved on the layer) → descriptive
    layer name; **reading order** of absolute layers only where they can't meet (`layersInReadingOrder`).
  - **Pop-ups and dropdowns move to the built-in `popover`** (still no script) as the last phase, only after the Bricks
    check page (`tests/tools/bricks-check.js`) proves Bricks keeps the attributes. Until then they stay on radios.
- **Open question for the user (not decided):** a hover component inside a link keeps its phone tap control, so on
  phones a tap shows the hover and the link doesn't open (finding `tapInLink`). Ask before changing it either way.
- **Photos as AVIF (when chosen):** never fall back silently to WebP or the original; stop and explain.
- **Phone slider:** `height: "auto"`, never Bricks' `autoHeight`; a hidden slider measures 0px.
- **Unverified in Bricks itself:** custom tags `label`/`input`, `_attributes`, `_cssId`, `link.newTab`, and
  `display: contents` (the menu panel's box, a section intro's row). Check these first if clicks, jump links, the
  menu or a moved button misbehave on the live site. Also the website rules' Block `tag: "nav"`, Image `altText`
  (empty = `alt=""`?) and `loading`, and `aria-*`/`fetchpriority`/`tabindex` attributes: paste the output of
  `node tests/tools/bricks-check.js` and read the live page's source.
