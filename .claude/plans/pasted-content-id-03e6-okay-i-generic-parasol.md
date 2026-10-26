# Leave out the header and footer the site already has

## Context

The user builds each client's header and footer once as Bricks templates. Every page they convert still carries
Figma's header and footer, so they delete them after pasting. Deleting the header moves the whole page up, and its
top hides behind the site's header (the user, 2026-10-20: "everything is moved up and hidden behind the bricks
template header"). The footer side is fine; it only showed twice.

**Why it hides (read on the live site, 2026-10-20):** the header template's section `#brxe-pmmkrh` is
`position: fixed; top: 0; z-index: 999` (about 89px tall on desktop), so it takes no room and `#brx-content` starts at
y=0. Bricks' own "Sticky header" is fixed too (`#brx-header.brx-sticky{position:fixed}` in its frontend CSS), so any
Bricks site with a sticky header has this problem. The footer template is in flow.

**Automatic detection isn't possible:** `bricks_template` isn't a REST type on the site, Bricks' template feed
answers `my_templates_access_disabled`, and the page HTML sends no CORS header to the panel.

**The user chose (questions, 2026-10-20):**
1. **Two ticks in the panel, remembered in the Figma file:** "My site already has its header" and "My site already
   has its footer". Every page converted from that file then leaves them out.
2. **The plugin measures the site's header:** the paste starts with an invisible spacer. A small script sets its
   height to the part of the site header that floats over the page, on every screen. This needs Regenerate code
   signatures after the paste (as for lists and maps). Without the script the spacer is 0 tall, as today.

**My rulings (report to the user at the end, not yet confirmed):**
- **With the header tick on, the spacer is always in the paste**, in one of two modes:
  - **push:** the header was drawn above the first section. The spacer is the site header's whole floating height.
  - **under:** the header was drawn over the first section, or no header was found. The spacer is only the part of
    that height the first section's own top padding doesn't already leave. A photo drawn under the header stays under
    it, and the words still clear it on phones, where `space.ramp` caps the top padding at 64px.
- **A header drawn inside the hero's own frame** (GRO's loose nav, final-design's glass bar) **is not left out in this
  milestone.** Removing it shifts the hero's inferred rows. The panel names it ("drawn inside …: delete it in
  Bricks"), and the under spacer keeps the words clear. The user's three files draw it as its own bar, so they don't
  need this. It is a follow-up.
- **A footer needs a © / copyright line plus two or more columns of short labels.** A last section without them, such
  as a contact form, stays. The note says why.
- **The palette file still lists colours used only in the header or footer** (it comes from normalise). Deferred minor.

## How it works

### 1. Storage (file data → snapshot, like `f2b-lists` / `f2b-videos`)
- `src/core/snapshot/schema.ts`: `site?: string`, raw JSON `{"header":bool,"footer":bool}`, written only when set.
  Old files and the corpus are unchanged.
- `src/plugin/extract/dump.ts`: `SITE_KEY = "f2b-site"`. In `src/plugin/extract/snapshot.ts:55-77`, read it in a
  try/catch like videos and spread `...(site ? { site } : {})`.
- New `src/core/normalise/site.ts`: `SiteParts {header, footer}` and a tolerant `parseSite()`. Add `Scene.site`
  (`normalise/scene.ts`), filled in `normalise.ts`.
- New `src/plugin/site.ts` `saveSite(api, site)`, modelled on `plugin/lists.ts:66-76`, with the same view-only error
  wording.
- `src/shared/messages.ts`: `saveSite` (UI → plugin), `init.site`, `siteSaved {error}`. `plugin/main.ts` reads
  `f2b-site` on `ready` and handles `saveSite`. The `convert` message is unchanged.
- This way the debug file carries the ticks, replay reproduces the user's paste, and
  `test/unit/plugin-convert.test.ts` stays byte-identical. `tools/replay.ts` and `tools/snap.ts` get
  `--site header,footer`, which sets `s.site`.

### 2. Recognition (understand, from structure, never names)
- **New `understand/bars.ts`:** `BAR_MAX = 200`, `BAR_SHARE = 0.8` and `topBars(sections, width)` (up to 2 leading
  sections, ≤200px tall, ≥80% of the width), moved out of `recognise.ts:70-128`. `heroOf` uses it, with the same
  results.
- **New `understand/site-header.ts`, per design:**
  - **A menu**, found in one of three ways:
    1. a row of 3+ menu items: one short one-line text each (≤ `LABEL_MAX`), icons allowed. This passes the user's
       Services dropdown wrapper, which `chipRow` refuses;
    2. 3+ distinct link or click targets;
    3. logo-left + action-right (a phone header).
  - **Blocked:** a bar holding a text ≥1.6× the body size, a sentence of 8+ words in the menu bar, a form, list,
    accordion, or a photo ≥120×120.
  - **What goes:** the bars from the top through the last bar with a menu. A breadcrumb bar under it stays. A page
    is never left with no section.
  - **Mode:** push when the overlap with the first kept section is ≤50% of the left-out height, else under.
- **New `understand/site-footer.ts`:**
  - **A footer:** a legal line (`©`, `(c) 2026`, "copyright", "all rights reserved", one line, in the section's
    bottom 40%) plus 2+ link columns. A column is short one-line texts sharing a left edge, stacked with gaps ≤3 line
    heights.
  - **A split footer:** a thin © bar is left out, plus the section above it when that section has the columns.
  - **Decoration:** empty bars after the footer go with it.
  - **Never:** a section with a form, list or accordion, or the first kept section.

### 3. Leaving parts out (`understand/designs.ts` `designOf`, lines 79-99)
- Restructure the loop: build every frame's section IR, then call `leaveOut()`, then run `space()` over consecutive
  kept sections. The hero then gets no stale negative margin from a header that is gone. Byte-identical with the
  ticks off.
- `DesignIR` (`ir.ts:128`) gains `left: { header, footer, room: "push" | "under" | null }`, where each part is
  `{label, height, nodes}`. Panel notes go in `page.warnings`, e.g. `Left out the header ("Frame", the 73px bar at the
  top): your site's header shows there instead`, or why nothing was found.
- **Follow-ons:**
  - `heroOf` then sees no bars, so the header's CTA isn't copied into "Phone buttons".
  - `noteMaps` (`understand/maps.ts:20-24`, which walks the scene) and the panel's video list (`convert.ts`) skip
    left-out layers. The user's footer holds the live map.
  - `adapt/layout.ts:97`: count real sections (not the spacer), and mark no footer when it was left out, so
    `footer.center` doesn't centre the new last section. `planLayout` gets the design (`engine.ts:51`).

### 4. The spacer
- **Made at the very end of `understand()`** (after line 70; earlier, `heroOf` would crash on a node with no `src`).
  With one design, `unshift` into `designs[0].sections`, which is `page.sections`. With a phone design, unshift into
  each design and rebuild `page.sections`.
- **Shape:** a Div (new role `"spacer"`, class `site-header-room`, plus `site-header-under` in under mode) holding a
  hidden Code element (`role: "script"`, the lists/arrows pattern; keys from `reference/bricks/code-element.json`).
  `style/room.ts`: width 100%, height 0, min-height 0, no padding, the `emptyBox` pin (`style.ts:272-276`), so it is
  never the editor's 90px. With two designs, `show: d.kind`.
- **New `emit/room.ts`:** the classes, `roomScript()` and `isRoomElement()`. `elements.ts` sets `_cssClasses` and
  `executeCode` + `javascriptCode`.
- **The script names no element ids.** It avoids `<!--`, `-->`, `</script` and `import(`, and it runs once per page.
- **What the script measures:** the bottom of `#brx-header`'s fixed or absolute boxes as at the top of the page.
  Fixed boxes count at their window position, absolute ones (the header or its direct children) at their page
  position. Dropdowns, hidden menus, bottom bars and the slide-up transform are ignored. An in-flow or sticky header
  gives 0.
  - **Room:** that bottom minus the spacer's own top, and in under mode minus the next section's top padding (and
    its Container's). Clamped ≥0 and rounded.
  - **When it runs:** now, on DOMContentLoaded and load, after `document.fonts.ready`, on window resize, and from a
    ResizeObserver on the header's boxes. Never on scroll. The admin bar works out by itself.
- **Panel side:** `ui/fonts.ts:57` `withFontCss` and the section count in `plugin/convert.ts:66` skip the spacer. A
  note says to run Regenerate code signatures after pasting.

### 5. Panel
- **`ui/index.html`**, between the options and Convert: checkboxes `#siteHeader` ("My site already has its header:
  leave it out, the page starts below your site's header") and `#siteFooter` ("My site already has its footer: leave
  it out"), with the hint "Kept in this Figma file" and `#siteStatus`.
- **New `ui/site.ts`** (no DOM) for the wording.
- **`ui/main.ts`:** set the ticks from `init.site`; a change posts `saveSite`; an error puts the ticks back. Add both
  to `setBusy`. `main.ts` is already 546 lines, so new logic goes in `ui/site.ts`.

## Tasks (test first, one commit each, in the worktree `site-parts`)
0. Plan doc `docs/plans/2026-10-20-site-parts.md` (writing-plans skill) and ledger. Run `npm run corpus` and
   `shasum corpus/paste/*/bricks.json`.
1. **Storage and plumbing.** Tests: `normalise-site`, `extract` (`f2b-site` travels; none means no key), `plugin-site`,
   `plugin-convert` with `site` set.
2. **`bars.ts` and the `heroOf` refactor.** Existing recognise tests pass; corpus hashes unchanged.
3. **`designOf` restructure.** Corpus hashes unchanged; ticks-off equals no `site`, byte for byte.
4. **Header** (generic fixture `test/fixtures/site-parts.ts`). Cases:
   - stacked bar with a dropdown-wrapped menu item, left out (push, hero margin 0, no header CTA in Phone buttons);
   - a menu found by links only;
   - header drawn over the hero (under);
   - a title band with a big heading kept, with a note;
   - announcement strip + menu bar both left out; breadcrumbs under the menu kept;
   - a desktop+phone pair (two spacers, each shown on its own screens);
   - a header-only page kept;
   - a nav inside the hero not left out, with a note.
5. **Footer.** Cases:
   - © + columns left out, and the new last section isn't centred on phones;
   - a contact form with © kept;
   - a split footer;
   - © without columns kept, with a note;
   - a footer holding a map gives no map note;
   - header tick only on a one-section page: no centring.
6. **Spacer.**
   - `emit-room`: first root element, sample keys only, no ids in the script, banned strings absent,
     `payloadProblems` empty, deterministic;
   - `ui-fonts`: the font CSS skips the spacer;
   - Chrome test `test/browser/site-header.test.ts`: the renderer gets a `before` slot and `<main id="brx-content">`.
     Cases: a fixed 89px header (64px under 768) puts the first section's top at its bottom at 1440/768/390; an
     in-flow header gives 0; no script gives 0; slide-up gives no change; a cookie bar or hidden menu is ignored;
     under-mode values; a resize re-measures. Prove the test fails without the script.
7. **Panel.** `panel.test.ts`: the ticks follow `init.site`, a change posts `saveSite`, an error reverts.
8. **Look.** `npm run snap -- <file> out --site header,footer` on the user's three files and design / final-design /
   GRO at 390/768/1024/1440/1728. `snap` drops left-out frames from its Figma heights (`ConvertResult.left`). Then
   `npm run corpus`: hashes unchanged with the ticks off.
9. **Close.** An opus review, then one fix pass (each fix test first). The ledger goes to
   `docs/plans/2026-10-20-site-parts-ledger.md`. A HANDOFF section "Header and footer the site already has" and paste
   check 3z: the Div at the root, the script running once signed, the top at 1440/768/390 and with the admin bar, and
   LiteSpeed's Delay JS if the top jumps. A `reference/bricks/README.md` note.

## Verification
- `npm run check` (typecheck, build, unit and rule tests) and `npm run test:browser`, all passing.
- `npm run corpus`: no width worse, and paste hashes byte-identical with the ticks off.
- Replay the repo-root debug file with `--site header,footer`. Then:
  - the payload has no header bar and no footer;
  - its first root element is the spacer;
  - the hero has no negative margin;
  - in the Chrome test page with a fixed 89px header, the hero's top sits at 89 on desktop and at the header's phone
    height on phones.
- **Finish** (global CLAUDE.md "Worktrees"):
  1. Rebase on local `main`, then check and run the corpus again.
  2. ExitWorktree "keep", then `git merge --ff-only worktree-site-parts` in the main folder.
  3. Bump `BUILD` (`src/shared/build.ts`), `npm run build`, commit "Build …: header and footer the site already has",
     push `main`.
  4. Update the main CLAUDE.md "Start here" and "Where things stand".
  5. Never commit `CLAUDE.md` or the user's modified `figma-to-bricks-debug-page-1.json`.
- **For the user** (one action at a time):
  1. Reopen the plugin and tick both boxes.
  2. Convert and paste into an empty page.
  3. Regenerate code signatures, then LiteSpeed Purge All.
  4. Check the top of the page on desktop and on a phone.

## Critical files
- `src/core/understand/designs.ts`, `understand.ts`, `recognise.ts`, `ir.ts`, `maps.ts`
- new `src/core/understand/bars.ts`, `site-header.ts`, `site-footer.ts`
- `src/core/adapt/layout.ts`, `src/core/adapt/engine.ts`
- `src/core/style/style.ts`, new `src/core/style/room.ts`
- `src/core/emit/elements.ts`, new `src/core/emit/room.ts`
- `src/core/snapshot/schema.ts`, new `src/core/normalise/site.ts`, `src/core/normalise/scene.ts`
- `src/plugin/extract/snapshot.ts`, `dump.ts`, `src/plugin/main.ts`, new `src/plugin/site.ts`, `src/plugin/convert.ts`
- `src/shared/messages.ts`, `src/ui/index.html`, `src/ui/main.ts`, new `src/ui/site.ts`, `src/ui/fonts.ts`
- `tools/replay.ts`, `tools/snap.ts`, `test/browser/render.ts`
