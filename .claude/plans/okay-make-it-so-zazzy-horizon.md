# Hover states stay inside their component; every animation kind gets the Figma-copy, fill and gradient fixes

## Context

**What the user reported:** in the hovered doctor state (a Bricks editor screenshot):
- the fixed EAST/NORTH phone pills (the page frame's "fixed when scrolling" child, built by `addFixedLayers`) are covered by the hover state;
- the "Request appointment" button disappears.

They asked for a general rule, and for all of this session's fixes to reach the other animation types too.

**Decision (user):** the button stays **as Figma draws it**. Figma's own picture of that variant (`statePictures`, B/a Variant3) shows it white on white. The fix belongs in the Figma variants, not the plugin.

**Cause of the pill problem (reproduced in headless Chrome):**
- Every section is raised to `z-index: 1` (`placeSections` → `placeSection`).
- A hover state is a copy laid over its component with `z-index: 2` (`stateCss`, code.js:4313). The component wrapper (`addMachine` / `addMachineSection`) is not a stacking layer of its own, so that 2 competes with the whole page.
- When the pill's holder ends up inside a later section (one way Bricks can place it), the section itself doesn't cover the pill but its hover copy does. That is exactly the screenshot.
- With the wrapper made its own layer at section level, the pill stays on top.

**The same class of problem elsewhere:** dropdowns get `z-index: 50`, but they sit inside a section at `z-index: 1`. A menu hanging below its section is drawn under the next section, and its click-outside cover can't reach clicks on later sections.

**The other animation kinds miss this session's fixes.** Two fixes only reach "states" machines:
- Figma's own switched copy (`figmaState`), which keeps the instance's overrides;
- the full converter (fill stacking, gradient text, images).

The gaps:
- **Style hovers** (`collectHovers` → `hoverDiff`) and **toggles** (`toggleOf`) compare the instance with the raw variant. An instance's own colour is replaced on hover by the variant's default, although Figma keeps it: the "colorway" bug class.
- **`hoverDiff`** only knows the top solid fill and a flat text colour. On an element whose paints are stacked, a gradient, an image, gradient text or mixed text ranges, a hover to a gradient or image draws nothing or the wrong layer.
- **Timer loops** (`timerLoop`) animate only moves, fades and turns, and silently drop colour changes.

## 1. Stacking rule: page content never rises above its section; floating layers stay on top

**Layers, bottom to top:**
- sections and everything in them: at most `z-index: 1` at page level;
- open dropdowns (50);
- fixed layers (90);
- sticky header (100);
- pop-ups (9999).

**Changes in code.js:**
- **`addMachineSection` (~4365):** the wrapper gets `isolation: isolate`, plus `z-index: 1` when `ctx.sectionPlace[node.id].raise` (it takes its section's level; sticky keeps its 100).
  - The state sections' own `z-index` and the hover copy's `z-index: 2` then only order the states among themselves.
  - Sections at `z-index: 1` are already stacking layers, so blend modes don't change. `isolation` doesn't stop the top margin collapsing through the wrapper, so the overlap still holds.
- **`addMachine` (~4346)** (a component inside a section): no permanent layer, so blend modes are untouched when idle. While one of its hover or press states shows, `%ID%:has(.T-h:hover, .T-p:active)` → `z-index: 1`.
  - The wrapper is already `position: relative`, so it becomes a layer only then.
  - A taller hover state still hangs over its neighbours as today, and never escapes its section.
- **`addDropdown` (~4535)**, a new helper `raiseWhileOpen(ctx, fromId, openSelector)`:
  - It walks up `ctx.byId` parents from the dropdown box.
  - Each ancestor that is a stacking layer we made (its own rules or `__css` carry `z-index` or `isolation`, or it is a section) and has a z-index below 50 gets `%ID%:has(<open>)` → `z-index: 50`.
  - `<open>` is `.D-open:checked` for a click dropdown and `.D:hover` for a hover dropdown.
  - Sticky (100) is left alone. The cover (49) then catches clicks anywhere.
- **Stays as it is:** pop-ups and fixed layers are at the page's top level already, and so is sticky.

## 2. Style hovers and toggles read Figma's own switched copy

- **New `stateCopy(variant, inst, ctx)`:** memoised in `ctx.stateCopies` by `inst.id + ">" + variant.id`. It returns `figmaState(...) || makeProxy(variant, inst, ctx)`, or the raw variant when the main is unknown and nothing can be cloned.
  - The `states` loop in `collectMachines` (code.js:3719) uses it.
  - Only states machines add their copies to `ctx.machineRoots`.
- **`collectMachines` classification (3678–3714)** becomes an async `for…of`. For 2-state machines it builds `copy = await stateCopy(v1, m.inst, ctx)` first and keeps it on `m.states[1].node`.
- **Pairing, the same in `collectHovers` (3009–3019) and `toggleOf` (3782–3785):**
  - Pairs still come from `pairLayers(inst, variant)`, and moves are still measured on the variant (`moveOf(own[a.id] || a, b)`, size-independent as now).
  - The look `hoverDiff` compares against is the copy's layer for `b`: found by `origId` in the figmaState copy, or by `id` in a `makeProxy` copy.
  - `h.dest` is the copy's root.
  - `collectHovers` gets the copy from `ctx.stateCopies` (or `stateCopy` for the few hovers it finds on its own).
- **Result:** an instance's own fill or text colour that Figma keeps across the switch is kept on hover or when toggled. Only what Figma changes gets a rule.

## 3. A change the hover rules can't draw exactly is built as states (the full converter)

**New `lookChanges(x, y)`:** the look properties that differ between two versions of a layer:
- fills, strokes, `strokeWeight`, `strokeAlign`, `dashPattern`;
- effects, `blendMode`, the corner radii;
- for a text, the look of its styled ranges (`rangesOf` / `lookOf`).

It ignores x/y, size, opacity and rotation.

**New `hoverExpressible(inst, copy)`:** true when, for the root and every `pairLayers` pair, each changed property is one `hoverDiff` draws exactly:
- **fill:** at most one visible SOLID normal-blend fill on each side;
- **stroke:** colour only, at most one visible SOLID on each side, with weight, align and dash unchanged;
- **corner radii:** any change;
- **effects:** drop and inner shadows only (`shadowSignature`);
- **text:** one range on each side, differing only in a single SOLID fill;
- **no change inside a layer drawn as one picture:** a descendant of an `isIconish` layer or an exported group.

**Where it is used:**
- **`isStyleMachine(m)`:** it also needs `hoverExpressible(m.inst, copy)`. Otherwise the machine falls through to toggle / loop / **states**: a hover state built from Figma's copy by the full converter, so fill stacking, gradients, gradient text and images apply. It is shown with Stage-2's hover overlay and now contained by §1.
- **`toggleOf`:** the same check. Otherwise → states (click radios).
- **`timerLoop`:** any `lookChanges` between the base and a state → null, so the loop is built as an **autoplay states carousel** (cross-fade) instead of dropping the colour change.
- **Breakpoint mode and hovers whose main can't be read** (`collectHovers` only): they keep today's best-effort style hover.

## Files
- **`code.js`:**
  - `stateCss` / `addMachine` / `addMachineSection` / `addDropdown` (+ `raiseWhileOpen`);
  - `collectMachines`, `isStyleMachine`, `toggleOf`, `timerLoop`, `collectHovers`;
  - new `stateCopy`, `lookChanges`, `hoverExpressible`;
  - `PLUGIN_BUILD` bump: next after whatever it is then (now `2026-09-30.11`; another session also bumps it).
- **`README.md`:** the stacking rule, and when a hover is styles vs. a state copy.
- **Memory:** update `main-component-animations-stage2.md`.

## Tests (generic fixtures; `node tests/run.js`)

**`tests/machines.test.js`:**
1. A section switching states on hover → the wrapper has `isolation: isolate` (+ `z-index: 1` when raised); the copy's `z-index: 2` rule is still there.
2. An inline hover component → wrapper `z-index: 1` only under `:has(.T-h:hover…)`, with no permanent `isolation`.
3. A style hover keeps the instance's fill override (the variants differ only in radius): `border-radius` on hover, no `background-color`. Two cases:
   - with a `clone` stub (the pattern at machines.test.js:349);
   - without one (`makeProxy` fallback).
4. The same for a toggle's knob colour.
5. A hover solid → gradient fill, a hover to gradient text, and a hover on a photo+overlay card → built as states (a copy with `linear-gradient` / `background-clip:text`). Solid → solid stays a style hover.
6. A timer loop that also changes a colour → an autoplay states carousel. A move-only loop is still motion.

**`tests/interactions.test.js`:**

7. A click dropdown in a raised section → the section gets `%ID%:has(.D-open:checked) { z-index: 50 }`, a hover dropdown `:has(.D:hover)`, and a sticky header section is not lowered.

## Verification
1. `node tests/run.js`: all pass.
2. **Replay both debug files** (`tests/tools/replay.js`) and diff against today's output.
   - The expected changes are wrapper stacking rules and dropdown raise rules.
   - Hovers whose kind changes must each have a non-solid look change.
   - The instance-override hovers must lose their spurious `background-color`/`color`.
3. **Headless Chrome on the replayed final-design page:** re-run the probe above with hover forced on a doctor card (`zprobe2.html` pattern, with `pointer-events` forced on for hit testing). The pill must be on top in both placements: holder at the top level, and holder inside the last section.
4. **Headless Chrome on a generic fixture page** (a dropdown in a section followed by another section):
   - with the dropdown open, the topmost element below the section is the dropdown;
   - a click on the next section hits the cover.
5. **The user in Bricks:**
   - the pills stay visible while hovering the doctors;
   - the button looks as in Figma (fix its colour in the Figma variants if it should stay visible).
