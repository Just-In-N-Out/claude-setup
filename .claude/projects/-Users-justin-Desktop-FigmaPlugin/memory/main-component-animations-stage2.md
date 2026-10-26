---
name: main-component-animations-stage2
description: "Figma interactions → web (build 2026-10-01.1). States, overlays, links, carousels, toggles, scroll-in Motion, sticky/fixed; stacking rule; every kind reads Figma copies; Bricks calibration items open"
metadata:
  node_type: memory
  type: project
  originSessionId: 4558d3c7-5f56-4617-a410-0dbd5e0bae9c
  modified: 2026-09-30T23:06:34.483Z
---

On 2026-09-30 (builds .6 to .8) the plugin gained prototype interactions → plain HTML/CSS in `code.js`. Tests: `tests/machines.test.js`, `tests/interactions.test.js`.
- **Interactive components ("Change to"):**
  - `collectMachines` classifies each machine: style hover (`hoverStyles`, with inner layers and moves via `ctx.hoverParts`), marquee, motion loop, toggle (`toggleOf`, a checkbox), or states (`addMachine` / `addMachineSection`: label+radio clicks, `:has()` hover overlays, phone tap radios).
  - Timers that go round the states autoplay as a cross-fade (`autoplaySteps` / `autoplayKeyframes`).
  - `makeProxy` builds the other variants, keeping the instance's overrides.
- **Links:** `collectLinks` / `linkOf(node, ctx)`. Navigate to a frame → `/slug-of-frame-name/` (`pageUrl`; a Home… frame → `/`); to a converted section, or Scroll to → a `#f2b-…` anchor via `_cssId`; `openInNewTab` → `link.newTab`.
- **Overlays:** `collectOverlays` / `wireOverlays` / `addOverlays` / `addDropdown`. Pop-ups sit at root level (`f2b-ov`); MANUAL overlays become dropdowns beside their trigger; one radio group per set of overlays that swap into each other; timed pop-ups have a dismiss checkbox.
- **Fixed when scrolling:** `fixedKids` (`numberOfFixedChildren`) in `pageSections`; a top band becomes a sticky section (`stickySection`); other fixed layers go through `addFixedLayers` (`position: fixed`).
- **Motion:** plays on scroll-in below 900px (`@supports (animation-timeline: view())`); on load otherwise.

**Why:** the user wants every Figma animation or interaction working on the live page, general for any file (project `CLAUDE.md`).

**How to apply:**
- **Unverified in Bricks itself** (check first if the user reports clicks or jumps not working): custom tags `label`/`input`, `_attributes` type/name, `_cssId`, `link.newTab`.
- **Headless-Chrome check:** a generic page built with the fixtures, probed via a `page(payload, {tail: script})` injection; rewrite `:hover` to a class to emulate hover.
- **The user's real debug file** (`figma-to-bricks-debug-final-design.json`) predates the debug-file fixes that save whole component sets. Its nested menu dropdowns only replay fully from a newer debug file.

Related: [[headless-chrome-bricks-check]], [[figma-ses-import-rejection]].

**Other states = the variant as designed + the instance's real content (build 2026-10-01.1; replaces the .10–.13 "keep every override Figma keeps" rule).**
- **Look:** `makeProxy` takes `LOOK_KEYS` / `TEXT_LOOK_KEYS` from the variant layer (fills, strokes, effects, radii, text colours and styling).
- **Content kept:**
  - the instance's words and pictures where they really differ from its own main (`instanceContent`, via `ctx.sources`);
  - visibility, and `LAYOUT_KEYS` (padding/spacing), under Figma's rule.
- **`figmaState`** (clone + `setProperties`, plugin data `f2b-temp`, removed in a `finally`) still supplies the layout and the pairing (`origId` = `sourceId`), but not the look.
- **Why:** the user's doctors instance was recoloured for a light page (light bg, dark heading, light button text). Figma's copy carried that into the navy hover variants: a white button with light words, and Dr. Conrad's text kept as a same-words override. The user said the variant as designed in the component set is "how it should be". Figma's prototype player keeps the colours, so it differs from the site.
- **Figma's truth for debugging:** debug files carry `statePictures` (Figma's switched copies, overrides kept); `replay.js` writes `figma-state-*.png`. The replay can't clone, so it uses the `makeProxy` fallback.
- **Also fixed:** gradient text fills (`textGradient`).

**Stacking and all kinds share the fixes (builds 2026-09-30.12–.13).**
- **Stacking rule:** a component keeps its place in Figma's layer order.
  - Inline machine wrappers get `isolation: isolate` only under `:has(.T-h:hover, .T-p:active)`, never a z-index. Tap-radio elements are isolated under `(hover: none)`.
  - Machine section wrappers are `isolation: isolate` (+`z-index: 1` when raised, like sections).
  - Floating layers sit above: dropdowns 50 (`raiseOpenDropdowns` lifts their stacking ancestors while open), fixed 90, sticky 100, pop-ups 9999.
  - A layer filling a section goes behind the Container's absolute layers when Figma paints it below them (`behindContainer`).
  - **Why:** the pill in the user's page is a plain absolute layer, later in Figma order than the doctors component. Build .12's inline lift (`z-index: 1` while hovered) put the hovered component over it. Only a stacking rule of "keep Figma's order" fixes every such file.
- **All kinds read Figma's copy:** style hovers (`collectHovers`) and toggles read `stateCopy` (memoised `figmaState`/`makeProxy`), with moves measured on the variant.
- **When hover rules are used:** `hoverExpressible` keeps hover rules only for flat colours, outline colour, corners, shadows, and uniform text weight/italic/spacing/case/underline. Anything else becomes states. Timer loops with `lookChanges` become autoplay carousels.
- **`lookChanges` compares visually:** a colour by its value, not its variable id; a picture crop within 1px. A marquee logo had a sub-pixel crop difference.
- **User decision (2026-10-01):** a state's look follows the variant as designed in the component set, not Figma's switched copy with the instance's colour changes.
