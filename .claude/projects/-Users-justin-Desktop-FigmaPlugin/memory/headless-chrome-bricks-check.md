---
name: headless-chrome-bricks-check
description: "How to check the plugin's Bricks output in a real browser without Bricks — render elements as #brxe-<id> HTML, measure in headless Chrome via an iframe (Chrome won't open windows under 500px)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 6e7be283-c3c3-4f5a-9bfb-65cf1b03e472
  modified: 2026-10-01T21:47:16.800Z
---

Built 28 Sep 2026 to verify the 1440/64/36/16 container and the phone-slider fallback. The unit tests only check JSON, so
layout claims need a browser:

- Build elements with `tests/harness.js` `loadCode` + fixtures, call `addSection` then `finalizeCss(ctx, ctx.elements)`.
- Render each element as `<div id="brxe-ID" class="brxe-ID brxe-NAME {_cssClasses}">`, settings → CSS per breakpoint
  (`:tablet_portrait` 991, `:mobile_landscape` 767, `:mobile_portrait` 478), then each element's `_cssCustom`. Approximate
  Bricks base CSS: `.brxe-container{width:1100px;max-width:100%;margin:0 auto;display:flex;flex-direction:column}`, etc.
- Slider (Nestable): `.brxe-slider-nested.splide > .splide__track > .splide__list > .brxe-block`, Splide 4.1.4 from
  jsdelivr, started like Bricks' `bricksSplideFn` (add `splide__slide`, `new Splide(el).mount()`).
- **Headless Chrome (`--headless=new --dump-dom`) clamps the window to 500px minimum**, so 375px measurements need the page
  in an `<iframe style="width:375px">`; the page `postMessage`s its measurements to the frame page, whose DOM is dumped.
- Bricks theme source (for checking element markup) is the GitHub mirror enriquo/bricks-builder-theme.
- **Checking transitions/animations (2026-10-01):** `--virtual-time-budget` + `--dump-dom` is useless for timing. The
  sandbox blocks the network (Google Fonts links, placehold.co images), so `load` only fires once the budget runs out,
  and after that nothing animates. Real-time works: launch Chrome with `--remote-debugging-port`, drive it over CDP with
  Node 22's built-in `WebSocket` (`Runtime.evaluate`, `awaitPromise`), and **strip the `fonts.googleapis` `<link>`s**
  first (they block parsing forever: `readyState` stays "loading").
- **Pick a visible trigger:** interactive components also live inside other components' hidden states (copies with
  `display: none` ancestors), and nothing animates there. Filter with `el.getClientRects().length`.
- A fresh element needs a style flush (`getComputedStyle`) before the change, or no transition starts. `snap.js` takes
  5+ minutes per width (one Chrome per section), and two snap runs at once deadlock on the shared profile.

See [[bricks-slider-auto-height-collapse]] for the earlier Splide repro done the same way.
