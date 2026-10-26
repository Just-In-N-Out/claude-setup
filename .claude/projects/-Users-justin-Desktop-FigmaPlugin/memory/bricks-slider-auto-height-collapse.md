---
name: bricks-slider-auto-height-collapse
description: Phone slider must use height "auto", never Bricks' Auto height (autoHeight) — verified in headless Chrome that Auto height collapses a slider pasted at the desktop breakpoint
metadata:
  type: feedback
---

The plugin's phone slider (`sliderSettings()` in code.js) must emit `height: "auto"` and never `autoHeight: true`, even though Justin's hand-built Bricks slider uses Auto height.

**Why:** Bricks' `bricksSplideFn` (bricks.min.js) implements Auto height by setting `.splide__list` height to the active slide's `offsetHeight` at mount and on move/resize. A pasted slider mounts while `display: none` at the desktop breakpoint, measures 0px, and because slides stretch to the list, every later measure reads 0px again: the cards never show at the phone breakpoint. Reproduced on 28 Sep 2026 with Splide 4.1.4 + Bricks' handler in headless Chrome; `height: "auto"` shows the cards. The hand-built slider only works because it was created while the phone breakpoint was visible. A Sep 25 2026 session had already found this, then reverted to Auto height "to match the hand-built one", which brought the bug back.

**How to apply:** If asked to make the slider match a hand-built one, keep `height: "auto"`; don't switch to `autoHeight`. Bricks theme JS/CSS is fetchable from the GitHub mirror enriquo/bricks-builder-theme (1.9.x) when the user's sites block curl. See [[figma-ses-import-rejection]] for another plugin-loading gotcha.
