Brainstorm with me: a **website importer** for my Figma → Bricks plugin (FigmaToBricksV2), so a live website can be
converted into a Bricks paste by the same plugin that converts Figma designs. This is a design/brainstorm session only:
don't write code, don't change the repo, don't start a build.

## Context you need (read these first)
- The repo: `~/Documents/FigmaToBricksV2` (read only). Its `CLAUDE.md` holds the standing rules and every decision I've
  made; read at least "Build general logic, never one-file fixes", "Architecture rules", "Decisions the user made" and
  "Debugging a user's design". The approved architecture: `docs/specs/2026-10-06-v2-design.md`.
- **The key idea to build on:** the plugin is already split in two. Only `src/plugin/extract/` talks to Figma and turns a
  design into a neutral **Snapshot** (the same thing as the panel's "Save debug file"). Everything in `src/core/` is pure
  and runs in Node on a Snapshot: `normalise → understand → style → adapt → emit`, producing the Bricks paste. Tools
  already run that back half from a file: `npm run replay -- <debug.json> <out>`, `npm run snap` (renders the paste in
  Chrome at several widths), `node tools/inspect.ts`. `src/core/snapshot/upgrade-v1.ts` already converts an older
  format into a Snapshot. A website importer would be a **second front half** that produces a Snapshot from a live
  site, so every rule, fix and feature in the back half applies to websites too.
- **What we did by hand once:** for bdryswi.com (WordPress + Elementor) an earlier session captured the page in headless
  Chrome: `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` holds `home.html` (Elementor's inline CSS and popup
  templates), `tree-<width>.json` (every widget's box, type, settings, text, images and links at 1440/1024/767/390) and
  shots. The Bricks paste was then hand-built from that, which is why fixes kept landing in a paste file instead of the
  plugin. Lessons from that copy: the page capture missed the Elementor header/footer templates (sections lived in the
  footer template); lazy images were captured unloaded at phone widths; the site's own Roboto 600 face failed to load,
  so measured line counts were fallback-font metrics; animations live in Elementor's `data-settings`; a third-party
  reviews widget (Trustindex) can only be embedded, not rebuilt.
- The project drives the system Chrome over CDP already (`test/browser/chrome.ts`). The plugin uploads pictures and
  fonts to WordPress over REST (Application Password). Bricks native elements must come from real samples in
  `reference/bricks/`, never from memory.
- My rule from 2026-10-29: every change goes into the plugin, never only into one site's paste.

## What I want from this session
Think it through with me and end with a written proposal at
`~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md`. Ask me questions one at a time while we go (plain
words, short options, your recommendation marked), then write the proposal. Cover:
1. **Approaches**, with a recommendation: (A) a website → Snapshot importer feeding the existing back half; (B) importing
   the site into Figma with an existing website-to-Figma tool, then running the plugin as today; (C) anything better.
   Compare what each keeps (layout, phone layouts, hover, animations, links, forms, fonts, pictures) and what it loses.
2. **How the importer would read a site:** the headless-Chrome capture (DOM boxes, computed styles, text runs, images,
   links), several screen widths (do they map onto the plugin's "drawn phone design" path?), tidying deeply nested
   website markup into the shapes the plugin's understand stage expects, and builder-specific readers (Elementor first:
   its widgets, `data-settings` animations, header/footer location templates, popups).
3. **Where it runs and how I'd use it:** a command-line tool, a local page, or something in the plugin's panel (Figma
   plugins can't browse other sites); what I click or type, and what I get back (the same Bricks paste as today).
4. **What maps onto existing plugin features** (sliders, accordions, flip cards, hotspots, CTA buttons, call links,
   section rhythm, header/footer ticks) and what needs new work.
5. **The hard parts and limits:** third-party widgets and forms (embed notes or placeholders?), fonts and pictures
   (download, upload to WordPress), JavaScript-driven content, cookie banners, very different site builders (Wix,
   Squarespace, plain HTML), and copying only sites my client owns.
6. **A first version (MVP)** small enough to build and prove: e.g. one Elementor page at desktop + phone widths, the
   features B-Dry needed, and how we'd test it (bdryswi.com as the first real case, compared against the live site at
   1920/1440/1024/767/390).
7. **Risks, open questions for me, and a rough size** (how many plan/build/review rounds), so I can decide whether to
   start it.

Keep it general: the importer is for any website I copy, not just bdryswi.com.
