# Figma to Bricks v2: clean rewrite

## Context

v1 (`~/Desktop/figmaplugin`, one 9,824-line `code.js`) converts a desktop-only Figma page into Bricks paste JSON.
The **desktop result in Bricks is great**. Two things are not:

1. **Phone and tablet versions don't look nice.** Designers only draw desktop, so the plugin has to invent them.
2. **Interactions look or behave badly:** hover, mobile menu, dropdowns, accordions, tabs, pop-ups and sliders.

v2 starts over in `~/Documents/FigmaToBricksV2` (empty now) with clean, small modules. v1 is the **reference for the
rules it learned** (sizing, text, fills, upload), not for its code structure.

### Why v1's phones look bad

The causes are structural, not individual bugs:

- **Desktop is emitted pinned:** fixed widths, min-heights, `nowrap`, absolute positions. Each breakpoint then has to
  unpin values one by one, and whatever is missed leaks through to 390px.
- **Rows are decided by pixel arithmetic, not by what they are.** `rowPlan` uses checks like `content > 696` without
  knowing whether a row is a card row, a text+photo split or a nav bar. Pattern detectors are duplicated and drift
  apart (`isPhotoCard`, `photoShaped`, `sliderSet`, `heroOf`…).
- **Page-level intent comes too late.** `phonePostPass` guesses it from settings already emitted, regex-edits the CSS
  strings and fights earlier passes over the same keys.
- **Values are scaled one at a time** (`scaleSpace` ×0.5, `scaleType` ×0.45), so spacing rhythm and type hierarchy
  are lost.
- **Tablet is never designed,** only inherited.
- **Nothing measures the output,** so rules regress silently.

## Decisions (user, 2026-10-06)

| Topic | Decision |
|---|---|
| Interactions | **Native Bricks elements** where one exists: Nav Nestable with its own mobile menu, Accordion and Tabs Nestable, Slider Nestable, Dropdown, Offcanvas. CSS only for hover and motion. This replaces v1's radio/`:has()` approach. |
| Code setup | **TypeScript + esbuild.** Small one-job modules bundled into the `code.js` and `ui.html` Figma loads. |
| Phone rules | **Keep v1's rules** (CLAUDE.md, 2026-10-01) and build each one cleanly as a tested rule. Review screenshots and change any that still look wrong. Includes header CTA copied under the hero (phone-only box) and kept in the menu. |
| Keep | WordPress upload, AVIF/WebP, Figma Motion → CSS, Google Fonts, text styles → global classes, debug file + replay |
| Leave out | The design-check findings list (audit). Breakpoint designs: rare, deferred. Listed in README as deferred along with marquee, video, masks, state machines, so nothing is silently lost. |
| Git | **None.** Plain folder, no commits. |
| Bricks version | Unknown; read from the sample elements the user copies out of Bricks |
| Carried from v1 | Generalise by structure, never by layer name, id or file. Container 1440 max, gutters 64 / 36 / 16. Bricks default breakpoints 991 / 767 / 478 (`:tablet_portrait`, `:mobile_landscape`, `:mobile_portrait` key suffixes). No invented motion. Navigate → `/slug/`. Figma's SES rules (no `import(` or HTML comment markers in the bundle). |

## Architecture

```
extract    (only code that calls figma.*)  → Snapshot     plain JSON; this IS the debug file
normalise  (pure)                          → Scene        resolved geometry, paints, text; a Flow for every frame
understand (pure)                          → IR           roles (section, container, stack, grid, card, cardRow,
                                                          split, hero, nav, footer, composition, widgets) + PageFacts
style      (pure)                          → StyleModel   typed desktop declarations, fluid tokens, hover states
adapt      (pure)                          → StyleModel   + breakpoint layers, written only by rulebook rules
emit       (pure)                          → Bricks payload + asset/font manifest
ui                                         → encode, upload, fonts, swap asset tokens, clipboard
```

**Rules that always hold:**

- **Nothing after extract touches Figma.** Replaying a debug file is just `convert(snapshot)` in Node, with no stubs.
- **No stage edits an earlier stage's output.** No element changes type after it's made, and nothing is converted twice.
- **CSS stays typed** (`{bp, state, part, decls, origin}`) until emit serialises it once. Each value goes to a Bricks
  control key where one exists, so it stays editable in Bricks; the rest goes in one `_cssCustom` per element.
- **Every breakpoint declaration records which rule wrote it.** Two rules writing the same node, breakpoint and
  property fail a test unless one declares that it overrides the other.
- **Recognisers use structure only.** A layer name can raise confidence but never decides a role. Each match records a
  `why`.
- **Ids are deterministic:** a hash of the IR key. The same snapshot gives a byte-identical payload, so golden files
  and diffs between builds are meaningful.
- **Breakpoints, media queries and gutters are defined once,** in `src/shared/breakpoints.ts`.
- **v1 debug files load from day one** through `upgrade-v1.ts`.

## Responsive strategy

1. **Fluid desktop by construction, exact at the design width W.**
   - **Sizing:** fill → `flex: 1 1 0` or `100%`; hug → `auto`. Fixed widths go only on leaves (media, icons, buttons),
     always with `max-width: 100%`. Containers never get fixed heights.
   - **Spacing ≥ 40px and type ≥ 28px:** `clamp()`, exact at W, sliding to the tablet value at 992.
   - **Text:** Figma's line breaks and one-line `nowrap` apply only at `min-width: W`. Below W text wraps naturally,
     with `text-wrap: balance` for headings and `pretty` for paragraphs.
   - **Absolute layers** exist only inside a `composition` node, and every composition has a phone plan.
2. **Page-wide scales (PageFacts).** The page's font sizes and spacings go onto monotone tablet and phone ramps, so
   hierarchy and rhythm survive. Type: phone ramp 16/18/20/24/28/32/40, and the longest word must fit. Spacing: 8px
   steps, capped on phones at 64 for sections and 48 for gaps. Rules read from the ramps; they never scale numbers
   themselves.
3. **Rulebook:** `src/core/adapt/rules/<id>.ts`. Each rule is `{id, roles, when(node, facts), apply(node, facts, out),
   decision}` and has its own test with a fixture that should match, one that shouldn't, and a lint run at 390 and 768.

   | Rule | What it does |
   |---|---|
   | `space.ramp`, `type.ramp` | Spacing and type from the page ramps |
   | `row.reflow` | Hug items wrap. 3+ items that keep ≥180px each go two per row; otherwise they stack. Thin dividers hide once the row breaks. |
   | `split.stack`, `split.zigzag` | Text+media stacks when the text would drop under about 320px. Zigzag rows show the photo first in every row. |
   | `cardRow.tablet`, `cardRow.phone` | Tablet: 3+ alike cards → 2 columns. Phone: photo cards swipe one per view, gap ≤16. Text cards → 1 column. Stats and logos → 2–3 columns. Where cards can't slide they keep the photo's shape, two per row. |
   | `hero.overlay`, `hero.split` | Photo behind text: crop to the subject, text stays on the photo, every CTA under it (the header CTA as a phone-only copy). Photo beside text: text, photo, buttons. |
   | `cta.fullWidth`, `intro.ctaAfterText` | Phone CTAs go full width (not tags, icon buttons or floating layers). Section intro: heading, text, then button. |
   | `nav.mobileMenu` | Native Nav Nestable mobile menu: a panel from the right over the dimmed page, links 20px+ on 48px rows, header button under them, toggle turns into ×. |
   | `footer.center`, `media.shape`, `composition.phone`, `tap.targets` | Footer centred and last. Photos keep their aspect ratio. Absolute groups stack or scale. 44px hit areas. |

   **Phone sliders:** a spike in M2 decides between one Slider Nestable with slides-per-view set per breakpoint and a
   CSS scroll-snap track. Hidden duplicate copies are the last resort.

## Interactions (M3)

- **Elements:** emitters for Nav Nestable, Accordion Nestable, Tabs Nestable, Slider Nestable, Dropdown and Offcanvas
  are written against **canonical samples copied from your Bricks install** (`reference/bricks/*.json`).
- **Shape test:** guards each emitter against its sample.
- **Round-trip check:** paste our output, copy it back from Bricks and diff the two, to see what Bricks drops or renames.
- **Hover:** port v1's `hoverExpressible`/`hoverDiff` as typed hover layers. Anything CSS can't draw exactly becomes
  native states.
- **Pop-ups:** Bricks pop-ups are templates and can't be pasted. Plan:
  - a Div with the HTML `popover` attribute and `popovertarget` on the trigger, once the round-trip proves Bricks keeps
    them;
  - Offcanvas for side drawers;
  - otherwise Bricks Interactions, whichever the samples show works.

## Quality oracle

A layout lint runs in system Chrome through a small CDP client built on Node 22's own `WebSocket`. There are no npm
dependencies, and viewports are exact at 390px.

**Widths:** 390, 768, 1024, 1440 and W.

**Errors:**

| Check | What it catches |
|---|---|
| `overflow-x` | The page is wider than the viewport |
| `text-clipped`, `text-overlap` | Text cut off by its box, or running into other text or controls |
| `min-font` | Text below 12px |
| `words-per-line` | Paragraphs averaging fewer than 3 words per line at ≤768px |
| `image-distortion` | A picture's aspect ratio changed |
| `escaped-absolute` | An absolute layer outside its section on phones |
| `content-parity` | Text visible on desktop that can't be reached on phones (it may sit in a menu, accordion or slider), or text shown twice |

**Warnings:** body text under 14px on phones, tap targets, gutters, columns under 120px, and holes over 160px.

**Pixel score:** each section at W against Figma's render, which is stored in the debug file.

**Corpus:** v1's three real debug files, used by path and never hardcoded from. `npm run corpus` writes a report.
`tools/v1.ts` runs v1 read-only to record its baseline, and a test fails when v2 gets worse than that baseline.

## Repo layout

```
manifest.json, build.mjs (esbuild; inlines UI + AVIF worker; fails on SES-forbidden strings), package.json, tsconfig.json
src/shared/        breakpoints.ts, hash.ts, color.ts, units.ts
src/plugin/        main.ts (message router), extract/ (walk, text, components, reactions, motion, assets, renders)
src/core/          snapshot/ (schema, upgrade-v1), normalise/, understand/ (facts, recognisers/), style/, adapt/ (engine,
                   scales, rules/), emit/ (ids, elements, settings, css, classes, widgets/, payload), convert.ts
src/ui/            index.html, main.ts, wordpress.ts, avif.ts + worker, webp.ts, fonts.ts, assets.ts, debug.ts
reference/bricks/  canonical Bricks samples + bricks-version.txt
test/              unit/, rules/, golden/, fixtures/builders.ts, browser/ (cdp, render, lint, pixel)
tools/             replay.ts, snap.ts, same-look.ts, corpus.ts, v1.ts
corpus/            corpus.json (paths to debug files), baseline.json
CLAUDE.md          the pasted rules, updated for v2 (layout, commands, today's decisions)
```

- **Dev dependencies:** only `typescript` and `esbuild`.
- **Tests:** `node --test` runs the `.ts` files directly on Node 22's type stripping (`erasableSyntaxOnly`).
- **Scripts:** `build`, `watch`, `typecheck`, `test`, `test:browser`, `corpus`, `replay`, `snap`, and `check` (which
  runs typecheck + build + test).

## Milestones

Each milestone gets its own detailed task plan before work starts.

### M0: Foundation and tooling

1. Scaffold: package.json, tsconfig, build.mjs, manifest. A hello-world plugin opens in Figma and round-trips a
   message.
2. SES guard in the build, with a test that feeds it a forbidden string. `breakpoints.ts` with tests.
3. Snapshot schema and `upgrade-v1`. A test loads the three corpus files and checks their node counts (642, 317, 1470).
4. Fixture builders (`frame`, `row`, `text`, `image`, `instance`) that produce Snapshot nodes.
5. Port extract from v1's `dumpNode`/`debugData` (`code.js` ~9549–9760), also storing vector SVGs, and add the panel's
   "Save debug file".
6. Deterministic ids, the payload envelope and a golden-file helper.
7. CDP client. Port the renderer (`tests/tools/render.js`) with Bricks base CSS. Lint v0 (overflow-x, text-clipped,
   min-font, words-per-line), tested on deliberately broken pages.
8. Pixel comparator, corpus runner and the v1 baseline.

**Done when:** the plugin opens in Figma, `npm run check` passes, and the v1 baseline exists at every width.

### M1: Desktop parity

1. **Normalise:** geometry, mirroring, visibility; paints, gradients, strokes, radii, effects (port v1 `code.js`
   ~539–1130); Flow and sizing for auto layout and grid (~1249, ~1358–1869); free-frame inference and band/column cuts;
   text runs, line height, lists, SVG line breaks (~2722–3375).
2. **Understand v0:** page split into sections; Container, bleed and bands (port the page rules from v1's README); leaf
   roles (text, media, icon, button, link). Card, cardRow, split, hero, nav and footer are recognised but not yet acted
   on.
3. **Style:** fluid sizing and layout, typography and global classes, backgrounds, borders, effects, absolute placement
   from constraints.
4. **Emit:** elements, settings vs custom CSS, asset tokens, links and anchors.
5. **UI:** port WordPress upload, cache, AVIF/WebP, Google Fonts and clipboard from v1's `ui.html` into modules, with
   unit tests ported from v1's `ui.test.js`.
6. **Corpus parity loop.**

**Done when:**

- at W every section's pixel score is at least v1's;
- there are no lint errors at W and 1440, and no overflow at 1024 or 1920;
- the output is byte-identical across runs;
- you paste one page into Bricks and confirm the desktop matches v1.

### M2: Responsive engine

The rulebook engine, PageFacts and scales, every rule above, native Nav Nestable with its mobile menu, and the slider
spike.

**Done when:**

- there are no lint errors on fixtures and corpus at 390, 768 and 1024;
- corpus warnings are at most half of v1's;
- every v1 phone decision maps to a rule with fixtures;
- you prefer v2 over v1 in phone and tablet screenshots of all three corpus pages.

### M3: Native interactions

Hover, accordion, tabs, slider, dropdown and pop-ups, as described above.

**Done when:**

- the output matches the reference samples;
- the paste and copy-back round trip shows no difference;
- CDP click and keyboard tests pass;
- you confirm each widget on a live page.

### M4: Motion and semantics

Figma Motion to keyframes, playing when scrolled into view, reduced motion, heading outline, alt text, nav landmarks
and focus ring.

**Done when:**

- the output contains no motion without a Figma source;
- each corpus page has one h1 and no skipped heading levels.

## What I need from you (by M2/M3; not needed to start)

1. **Bricks samples.** In Bricks, build each of these once with defaults:
   - Nav Nestable with a dropdown and mobile menu
   - Accordion Nestable
   - Tabs Nestable
   - Slider Nestable with slides-per-view changed on phone
   - Dropdown
   - Offcanvas + Toggle
   - one element with a Bricks Interaction
   - a Div with a custom `popover` attribute

   Select each in the structure panel, press Ctrl/Cmd+C, and paste it into a text file. The copy includes the Bricks
   version.
2. **Paste checks** at the end of M1 and M2. Paste the output into Bricks and tell me or screenshot what looks wrong.
   The live page is the final judge, because my renderer only approximates Bricks.

## Verification

- `npm run check` (typecheck + build + unit and rule tests) after every task.
- `npm run test:browser`: the fixture renders get zero lint errors at all widths.
- `npm run corpus`: v2 against v1's baseline on the three real files, plus side-by-side PNGs (Figma / v1 / v2 at W,
  1024, 768, 390) for you to judge.
- Load `dist/` in Figma desktop (Plugins → Development → Import from manifest), convert a frame, paste it into Bricks.

## After you approve

1. Save this design to `docs/specs/2026-10-06-v2-design.md`.
2. Write v2's `CLAUDE.md` from the one you pasted. The "Build general logic" section stays word for word. The repo
   section is rewritten for the new layout. The decisions are updated (native interactions, audit dropped) and point at
   v2's modules instead of v1 function names.
3. Write the detailed task-by-task M0 plan (test first per task), then ask whether you want me to run it in this
   session or task by task with subagents.
