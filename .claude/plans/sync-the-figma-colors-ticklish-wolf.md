# Figma colours → Bricks Style Manager → Colors

## Context

The user's manager wants Figma's colours in Bricks' **Style Manager → Colors**, with pasted pages using them, so a colour
changed in Bricks changes everywhere.

**What Bricks allows** (read 2026-10-14 in Bricks 2.4.1's `main.min.js` on the user's site):
- **A paste can't carry colours.** An element paste reads only `content`, `components`, `globalClasses`,
  `globalElements` and `sourceUrl`.
- **WordPress can't take them from outside.** Its settings route writes only core options, and `bricks/v1` has no
  palette route. Bricks' own save (`bricks_save_color_palette`) needs a logged-in builder tab.
- **Style Manager → Colors has an Import.** It takes a JSON file with schema `["id","name","colors"]`:
  - each colour is `{id, raw:"var(--name)", light}`;
  - it refuses a palette whose name already exists.
- **Elements link to a palette colour as `{id, raw:"var(--name)", light}`**, the shape in the user's ExampleBricks and
  `reference/bricks/*.json`.

**The user's choices (2026-10-14):**
1. **Which colours:** the file's named colours (colour variables and colour styles, with Figma's names). A file with
   none gets every colour its design uses.
2. **How they get in:** a palette file to import. No helper plugin; the user declined one even though it would make
   the sync automatic.
3. **Linked:** pasted elements point at the palette colours, each with the plain colour as a fallback, so a paste made
   before the import still looks right.

## Approach

### Extract: Figma's raw data only
- **New `src/plugin/extract/colors.ts`**, plus new methods on `ExtractApi` (`src/plugin/extract/api.ts:26-37`,
  implemented in `figmaApi` like `textStyle`):
  - `fileName()`
  - `localColorVariables()`, `variable(id)`, `variableCollection(id)`
  - `localPaintStyles()`, `paintStyle(id)`
- **Async calls only** (dynamic-page). Build each object field by field.
- **What it reads:**
  - local COLOR variables, plus library variables the selection binds;
  - local paint styles, plus library ones the selection uses (`fillStyleId`/`strokeStyleId`, collected in `dump.ts`
    like `textStyleId`, and added to `DUMP_PROPS`).
- **Finding bound variables:** they are collected after `addTextExtras`, by walking the dumped JSON with a pure
  `src/core/snapshot/bound.ts`, so bindings on mixed text runs count too.
- **Stored as a new optional `Snapshot.colors`** (`schema.ts`, no schema bump), raw:
  - variables with `valuesByMode` and collection `defaultModeId`;
  - styles with their `paints`;
  - `file`.
- **Errors** are caught as `snapshot.ts:37-38` does. Never write the text "figma." followed by a letter in a core
  comment, or `architecture.test.ts` fails.

### Normalise: the palette (`src/core/normalise/colors.ts` → `Scene.palette: Palette | null`)
- **Named mode:**
  - **Values:**
    - each variable takes its collection's default mode, aliases followed (with a depth cap, a cycle skipped);
    - a style counts when it is one visible SOLID paint, read through `paintsOf`/`fromFigma` so its rounding matches
      the design's paints;
    - a style that duplicates a variable (same name and value) is dropped.
  - **CSS names** are slugs of the Figma names ("Brand/Primary 500" → `brand-primary-500`):
    - on a clash, local names win, then the collection slug is added, then `-2`;
    - an empty slug gives `color-<hex>`.
  - **Ids:** `shortId("color:<file>:<figma id>")`, with clashes resolved through `assignIds`. Figma reuses variable ids
    across files, hence the file name.
- **Fallback (no named colours):** the opaque colours of solid fills, strokes and text runs that show (not hidden
  layers, not inside vector drawings), most used first.
  - Each is named by its hex (`color-f4c20d`) and given the id `shortId("color:#RRGGBB")`.
  - The names and ids stay the same on every page and every re-import. A numbered `color-1` could point at another
    colour after a re-import and recolour pages pasted earlier.
- **Matching is by value** (the `cssColor` text). Alpha 0 never matches.
  - When two palette colours have the same value, the one the design binds most wins (counted by `bound.ts`), then
    variables before styles, then Figma's order.
- **Named translucent colours:** `light` is `cssColor(c)` (`rgba()`).

### Style and emit: write linked colours
- **New `src/core/model/palette.ts`:** the `Palette` type and `inkOf(palette)` →
  `{ css(c): string; entry(c): PaletteColor | null }`, plus `PLAIN`.
  - `css` gives `var(--name, #HEX)` or `cssColor(c)`.
  - `Scene` and `Style` keep RGBA values, so every equality check (`style/states.ts` `same()`, `looks.ts`,
    `typography.ts:64`, `twinsAlike`) is unchanged.
- **Style stage:** `styleAll` makes the ink from `scene.palette` and passes it, with `PLAIN` as the default, to:
  - `backgroundStyle` (gradient stops, diamond, solid layer);
  - `boxPaint` (multiple shadows);
  - `textHtml` (coloured runs);
  - `outlineStyle`.
  - The palette is recorded on `StyleResult`. `style.ts` is already 314 lines, so add arguments only and don't let it
    grow.
- **Emit:** `bricksSettings`/`layeredSettings`, `stateSettings`, `emit/css.ts` and the slider dots (`elements.ts:51`)
  take the ink from `StyleResult`.
  - A matched colour setting is `{id, raw:"var(--name, #HEX)", light}`; any other stays `{raw}`.
  - `emitPayload`'s signature is unchanged.
- **New `src/core/emit/palette.ts`:** the import file `{id, name:"<file name> (Figma)", colors:[{id, raw:"var(--name)",
  light}]}`.
  - Its shape follows Bricks' `exportPalette` (one palette object per file), checked against the user's export once
    they send it.
  - It is returned as `ConvertResult.palette` (`src/core/convert.ts`).

### Plugin, replay and panel
- **Plugin to panel:** add `palette` to `ResultData` in `src/shared/messages.ts:22`, and pass it in `resultOf`
  (`src/plugin/convert.ts:16-21`).
- **Replay:** `tools/replay.ts` writes `palette.json` next to `bricks.json`.
- **Panel:**
  - **Module:** a new `src/ui/palette.ts` holds the file name, the how-to text and a DOM helper like `copyText`.
  - **Wiring:** two lines in `src/ui/main.ts`, which is at 298 lines, so keep it at that.
  - **Button:** "Download colour palette (N colours)", using `downloadText` (`src/ui/debug.ts:23`).
  - **How-to:** "Bricks → Style Manager → Colors → Import, drop the file. To update it, delete the old palette first."
  - **Older results:** a result without a palette shows nothing.

### Tests (test first, each step)
- **`palette.test.ts`:**
  - value match;
  - alpha 0 not matched;
  - `PLAIN`.
- **`normalise-colors.test.ts`** (generic fixtures; nothing from the corpus):
  - slugs and clash order;
  - salted ids;
  - aliases and cycles, default mode;
  - library colours kept only when bound;
  - non-solid and duplicate styles dropped;
  - tie-break order.
  - **Fallback:** opaque only, hidden and vector layers skipped, ordered by use, `null` when there is nothing.
- **Emit and style:** every slot links:
  - text, background, border, shadow and divider settings;
  - hover settings and state CSS;
  - gradient stops, the solid layer, multiple shadows;
  - coloured runs and text outline;
  - slider dots.
  - An unmatched colour stays `{raw}`.
  - A run with the base colour's value still gets no span.
- **End to end** (`convert.test.ts`):
  - every `var(--n, X)` in the payload names a palette colour whose `light` is X;
  - byte-identical across runs;
  - the palette file shape.
- **Extract** (`extract.test.ts`, with the fakes in `extract.test.ts` and `extract-components.test.ts` updated):
  - local, alias, two-mode and library variables;
  - a binding on a text run;
  - styles;
  - a throwing variables call keeps the rest.
- **"Plugin equals replay"** (`plugin-convert.test.ts`, `corpus-convert.test.ts`) also compares the palette.
- **Panel** (`ui-palette.test.ts`, `panel.test.ts`).
- **Tests whose expected values change** (update them deliberately, reviewing each diff):
  - the golden `test/golden/files/convert-sample.json` (`UPDATE_GOLDEN=1`);
  - `convert.test.ts:58,71`, `understand-hover.test.ts:94`, `emit-states.test.ts:55-60`, `emit-accordion.test.ts:53`
    and `understand-phone.test.ts:92,100`;
  - `test/browser/convert.test.ts:183-185` now reads `light ?? raw`.

### Process (CLAUDE.md)
- **Plan:** write `docs/plans/2026-10-14-figma-colours.md` with `superpowers:writing-plans`.
- **Before Task 1:** back up the repo to the scratchpad (rsync, excluding node_modules and corpus/out), then run
  `npm run corpus`.
- **Build:** native execution, test first, with a ledger in `.superpowers/sdd/<plan>/progress.md`.
- **Close:** bump `BUILD` and update HANDOFF ("Figma colours", paste checks, end-of-run list) and CLAUDE.md (the
  decisions, plus "Unverified in Bricks": the import file and the linked shape with a fallback).
- **Review:** one review on opus, then one fix pass, each fix test first. The ledger then moves to `docs/plans/`.

## Rulings to report to the user (not yet confirmed by them)
- **Fallback names:** hex names (`color-f4c20d`) instead of `color-1, color-2…`, for stability across re-imports.
- **Fallback colours:** opaque colours only; translucent ones stay plain.
- **Default mode only:** a frame set to another mode (e.g. Dark) doesn't link. A Bricks `dark` value is deferred.
- **Library colours:** included only when the selection uses them.
- **No prefix on names:** a site colour with the same name (e.g. `--text`) clashes. The how-to says so.
- **Renaming:** a colour renamed in Figma keeps its id, but pages pasted earlier point at the old name and show their
  fallback colour.
- **A colour at reduced opacity** stays a plain value, even when it is bound to a variable.

## Verification
- **Tests:** `npm run check` passes (typecheck, build, unit and rule tests).
- **Corpus:** `npm run corpus`. Lint and pixel numbers must be **identical** to the run before Task 1, because the
  `var()` fallbacks render the same colours.
- **Replay** hydraulics (37 bound colour variables) and GRO (no named colours → fallback):
  - read `palette.json`;
  - check that every `var()` in `bricks.json` names a palette colour;
  - `npm run snap` at every width shows no change.
- **User round trip, for the end-of-run list.** Put the paste on the clipboard with `pbcopy` and give one action at a
  time:
  1. Paste before the import: colours look right.
  2. Import `palette.json` (Style Manager → Colors → Import): the colours appear, named as in Figma.
  3. Open an element's colour control: the palette swatch is selected.
  4. Change a palette colour: the page follows (builder and saved page).
  5. Copy an element back, to record the shape in `reference/bricks/`.
  6. Send one Colors **Export** from the site as `reference/bricks/color-palette.json`, the canonical sample.
