# shared-palette: one colour is one palette colour on a Bricks site, from both tools (plan, Mini, 2026-11-11)

Planner: Fable 5.2 high. Plan only: no source or test changed, nothing committed, no live site loaded.
Evidence (`<E>` below): `~/.hermes/plans/figma-to-bricks/evidence/shared-palette/planner/` (`ids.txt` and `ids.ts`: the
ids each rule gives one colour today; `bricks-import-2.4.2.txt`: Bricks 2.4.2's `importPalettes`, `addColor`,
`deletePalette`, cut from B-Dry staging's saved builder script).

## Questions (⭐ = recommended; Justin's "go with recommended" takes them)

1. **What names a colour both tools found?** ⭐ **A:** its value. A colour Figma doesn't name is `--color-<hex>` with
   an id made from the hex alone, from the plugin and the importer alike (this is already the plugin's rule for a file
   without colour names; the importer takes it in place of `--home-<hex>`). A colour Figma names keeps its Figma name
   and its id exactly as today (your and your manager's 2026-10-14 decision; Bricks has no separate label, the
   variable's name is the only name it shows). So no Figma paste changes by one byte and nothing already pasted on
   your sites loses its link. B: Figma-named colours get their id from the hex too: they'd match the importer's with
   no extra step, but every page already pasted from a Figma file with colour names would lose its palette link until
   pasted again.
2. **How does a later paste use the colours the site already has?** ⭐ **A:** you give the tool the site's colours:
   the palette file(s) Bricks exports (Style Manager → Colors → Export), or simply the `palette.json` an earlier run
   wrote and you imported (it is the same shape, and Bricks keeps its ids). The tool then links every colour of that
   value to the site's own palette colour (its id and its name, in controls and in custom CSS), even one you made by
   hand or one that came from the other tool, and the new palette file holds only the colours the site lacks, under a
   name the site lacks (no file when it lacks none). Without the files it works as today (the whole palette in the
   file). B: no input; the notes only warn that importing a second file doubles the colours two pages share (changing
   the first copy in Bricks then changes nothing). Why not automatic: Bricks' import refuses only a palette **name**
   it has and never looks at colour ids (`<E>/bricks-import-2.4.2.txt`), a paste can't carry colours, and nothing
   outside the builder can read or write the site's palette (`reference/bricks/README.md` "Colour palettes").
3. **Both tools in this job?** ⭐ **A:** yes: the importer's commands take `--colours <file>[,<file>…]` and the
   Figma panel gets "Colours already on the site" (choose the files once; kept for the next conversions). B: the
   importer only now, the panel in a later job.
4. **Where does the importer's naming change land?** ⭐ **A:** as an amendment inside site-shared-styles' build, if its
   Milestone 4 (the palette) isn't built yet when this is approved: three lines of `colours.ts` and one flipped test
   (Task 2 below), so B-Dry's palette is never imported under `--home-…` names first. Otherwise here, after it merges
   (then a palette already imported on staging is healed by Q2 A: pass its `palette.json` as `--colours`).

## Playback

1. Today the same blue becomes two palette colours on one site: the plugin calls it `color-<hex>` (or its Figma name)
   in "<file> (Figma)", the importer plans `--home-<hex>` in "home (bdryswi.com)", and a second scanned page
   (`--about-<hex>`) would make a third (`<E>/ids.txt`: ids `ofglfq`, `jkcbqb`, `pewosr` for one colour).
2. Wanted: one colour is one palette colour, whichever tool or page pasted it, and a later paste uses the palette
   colour the site already has instead of adding one.
3. This plan gives both tools one naming rule (by value), lets both read the site's own palette file so they link to
   what is there and write only what is new, and records what Bricks' import does with an id it already has.

## What Bricks does (read, not guessed)

- **Import** (Bricks 2.4.2 `importPalettes`, `<E>/bricks-import-2.4.2.txt`; 2.4.1 the same, README "Colour
  palettes"): a file whose palette **name** exists is refused; otherwise the palette is added under a new palette id
  with its colours **as given, ids included**. No check of a colour's id or variable against the site's other
  palettes. So importing a file that holds a colour id the site already has leaves two palette colours with one id.
- **Adding by hand** (`addColor`): refused when the variable name exists in any palette or as a Global Variable.
- **Printing** (Bricks 2.2 `assets.php` L742-871, saved at
  `~/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/planner/bricks-2.2/assets.php`): a colour setting
  whose `id` the site's palettes hold prints that palette colour's own `var(--name)`; otherwise its own `raw` (our
  `var(--name, #hex)`, so the page looks right either way). Each palette colour prints `--name: <light>` in `:root`
  in palette order: with one variable in two palettes the later line wins, so editing the first copy changes nothing.
  Hence a file must never hold a colour the site has.
- **Deleting a palette** drops its colours; elements keep `{id, raw, light}` and print their own raw (the fallback).
- A palette colour's fields in 2.4.2: `id, raw, light, dark, darkModeEnabled, utilityClasses`. No label.
- Not seen on a real site: the builder's colour control picking the site's colour for a pasted id it holds (README
  says it finds by `id`); the live criterion proves it.

## Assumed from the plans this builds after

- **site-shared-styles** (`~/.hermes/plans/figma-to-bricks/site-shared-styles.md`): `src/core/site/colours.ts` with
  `siteInk(page, host, colours): SiteInk` (`css`, `setting`, `file`, `names`), `colourOf(tok)`, ids from
  `assignIds(… "site-color:<page>:<#HEX>")`, names `<page>-<hex>`, the file `{ id, name: "<page> (<host>)", colors }`;
  `ConvertOptions` `{ looks, palette }` in `src/core/site/convert.ts`; `sitePage(capture, opts)` returning `{ parts,
  palette, styles }` (`parts.ts`); `tools/lib/site-write.ts` writing `palette.json`, `styles.txt` and the `Colours:`
  note; tests `test/unit/site-palette.test.ts`; the fixture site `shared-looks`. This plan changes its Q4 A (names
  and ids only; the palette's name `<page> (<host>)` and Q5 stay) and the wording `--<page>-<hex>` of its sixth
  criterion to `--color-<hex>`.
- **site-no-div** (`…/site-no-div.md`): nothing of the palette; its fixtures `plain-natives`, `elementor-natives`.
- Base for the build: main after both merged. If Q4 A's amendment was taken, Task 2 is already done: the builder
  checks `grep -n 'site-color' src/core/site/colours.ts` (no hit means done) and skips it.

## Acceptance criteria (all **proposed**)

- AC1 (proposed): Given a Figma snapshot without colour names and a scanned page that both show the same two solid colours, the plugin's palette and the importer's palette hold each colour as the same `{ id, raw: "var(--color-<hex>)", light }` and both pastes' colour settings carry that id and `var(--color-<hex>, <colour>)`. Test `test/unit/shared-colour.test.ts` "a colour Figma does not name is one id and one variable from the plugin and the importer".
- AC2 (proposed): Given two scanned pages of one site with different page names, a colour both show has one id and one variable (`--color-<hex>`), in controls and in custom CSS (a gradient stop and a shadow too). Test `test/unit/site-palette.test.ts` "two pages of one site give a colour one id and one variable".
- AC3 (proposed): Given no site colours, every Figma fixture and corpus page converts byte for byte as on the base (payload and palette file). Test `test/unit/shared-colour-base.test.ts` "without the site's colours every Figma conversion is byte for byte the base's" (runs only when named with `F2B_PIN=1`; its hashes are made on the base by `node tools/shared-colour-golden.ts`).
- AC4 (proposed): Given the site's palette files hold `{ id: "fvnsfn", raw: "var(--amber)", light: "#F4C20D" }` and a colour written as `hsl()` and one as `rgb()`, a Figma conversion that paints those values (one under a Figma name, one unnamed) writes every such setting as `{ id: <the site's>, raw: "var(--<the site's name>, <colour>)", light }` and every custom CSS use as `var(--<the site's name>, <colour>)`; a colour the site lacks is written as without the files. Test `test/unit/site-colours.test.ts` "a Figma colour the site's palette holds takes the site's id and variable in controls and custom CSS".
- AC5 (proposed): Given the same palette files, a scanned page showing those values writes the same (class colour controls, custom CSS, gradient stops, shadows, hover looks), and with files that hold none of its colours it is byte for byte the paste without files. Test `test/unit/site-colours.test.ts` "a scanned page's colour the site's palette holds takes the site's id and variable in controls and custom CSS".
- AC6 (proposed): Given site colours, the palette file each tool writes holds only colours the site lacks (no id and no variable of the site's in it), under a name none of the given palettes has (`<name> 2`, `<name> 3`… when taken), and there is no file when the site lacks none; the notes say how many colours were reused and how many are new. Test `test/unit/site-colours.test.ts` "the palette file holds only what the site lacks, under a free name, and none when nothing is new".
- AC7 (proposed): Given a run's own `palette.json` passed back as the site's colours (Bricks' import keeps its ids), the same page converts to the same paste as before and adds no colour; passed to the other tool, every shared value links to those ids. Test `test/unit/site-colours.test.ts` "a palette file an earlier run wrote is read as the site's colours by both tools".
- AC8 (proposed): Given a file that is not Bricks' palette export (not JSON, or no `id`/`name`/`colors`), the tool stops with one plain line naming the file and writes nothing; a colour in a good file that is not one plain variable of one solid colour (a raw that is no `var(--name)`, a see-through or unreadable `light`) is skipped and counted in the notes; of two site colours with one value, the one whose name is the paste's own wins, else the first. Test `test/unit/site-colours.test.ts` "a file that is not a palette export stops the run, an unusable colour is skipped and named, and the first of two equal colours is used".
- AC9 (proposed): Given `npm run site -- <capture> <outDir> --colours a.json,b.json` and `npm run replay -- <debug> <outDir> --colours a.json`, the pastes, `palette.json` and the notes are the fourth to sixth criteria's; `site:upload` and `site:import` take the same flag (dry run and the stand-in WordPress only) and their usage lines name it. Test `test/unit/site-colours-cli.test.ts` "the commands read --colours and write the linked pastes and the smaller palette file".
- AC10 (proposed): Given the panel, files chosen under "Colours already on the site" reach the conversion (the same bytes as `npm run replay … --colours` for that snapshot), are kept for the next conversion and after a reload, can be cleared, and the download button offers only the new colours (hidden when none) beside a line "<n> of the site's colours reused". Test `test/unit/ui-site-colours.test.ts` "the panel's site colours reach the conversion, stay for the next one and shrink the download".
- AC11 (proposed) (live): Justin, on B-Dry staging: exports his palettes (Bricks → Style Manager → Colors → Export) or takes the `palette.json` he imported, runs `npm run site:import -- <old page> <https://staging> --elementor --colours <those files>`, pastes, and sees in Bricks that a blue heading's colour control shows the palette colour the site already had; he imports the new `palette.json`, no colour is listed twice under Colors, and changing the blue there changes every place on the page. Then in Figma he converts a frame with the same files chosen in the panel, pastes it on that site (or his darksalmon site with its own files) and sees its colours pick the same palette colours.

RED on the base (main plus the two plans): the first and second (ids `ofglfq` against `jkcbqb`/`pewosr`,
`<E>/ids.txt`), the fourth to tenth (no such input). The third is a pin: green on base and head by construction.
Regression: `npm run check` and `npm run corpus` (no worse); the importer's story pins of merged jobs stay env-gated.

## Design

**One rule module, both routes** — new `src/core/model/shared-colour.ts` (built-ins only; `src/core/site` already
imports `src/core/model` and `src/core/emit/ids.ts`):

```ts
import { cssColor, type RGBA } from "./color.ts";

// A solid colour's identity on a Bricks site, from either tool: its value alone
export const valueKey = (c: RGBA): string => `color:${cssColor({ ...c, a: 1 })}`;
export const valueName = (c: RGBA): string => `color-${cssColor({ ...c, a: 1 }).slice(1).toLowerCase()}`;

// One palette colour the site holds, as its export file gives it: id, the variable's name (no "--"), its solid value
export interface OnSite { id: string; name: string; value: RGBA; palette: string }
export interface SiteColours { colours: OnSite[]; names: string[]; skipped: number }
export const NO_SITE_COLOURS: SiteColours = { colours: [], names: [], skipped: 0 };

// files: each one parsed JSON of a Bricks palette export { id, name, colors: [{ id, raw, light }] }.
// Throws Error("<label> is not a Bricks colour palette file …") on another shape.
export function siteColours(files: Array<{ label: string; json: unknown }>): SiteColours;
// the site's colour for a value: the one named `own` when there is one, else the first in file order
export function onSite(site: SiteColours, c: RGBA, own?: string): OnSite | null;
// a palette name none of the site's palettes has: name, "name 2", "name 3"…
export function freeName(site: SiteColours, name: string): string;
```

- `raw` is usable only as exactly `var(--<name>)` (letters, digits, `-`, `_`); `light` only when it reads as one
  opaque colour. The reader is site-shared-styles' own (`src/core/site/value.ts` `parse` + `colours.ts` `colourOf`:
  hex 3/6/8 digits, `rgb()`, `hsl()`, `white`, `black`): one reader, no second parser. Bricks' picker writes `hsl()`
  by default (`colorPickerValue: "hsl(46 100% 65%)"`), so `hsl()` is a must. `dark` values are ignored.
- **Plugin.** `used-colors.ts` L34 and `colors.ts` L87 call `valueKey`/`valueName` (same bytes as today).
  `ConvertOptions.siteColours?: SiteColours` (`src/core/convert.ts`) goes to `normalise(s, { siteColours })` and on to
  `paletteOf(s, pages, site)`: the stage that makes the palette records the match (no later stage edits it). Each
  `PaletteColor` whose value the site holds gets `name = <the site's name>` and a new field `site?: string` (the
  site's id). `model/palette.ts` `inkOf` needs no change (it writes `c.name`); `emit/palette.ts` `idsOf` returns
  `c.site ?? <assigned>` with the site's ids passed to `assignIds` as `reserved`; `paletteFile(p, site)` leaves out
  colours with `site`, names the file's palette `freeName(site, p.name)` and returns null when none is left. Two
  Figma names of one value that the site holds both take the site's one colour. A file with colour names keeps its
  unnamed used colours plain, as today, even when the site holds them (limit, HANDOFF "Deferred").
- **Importer.** `colours.ts` `siteInk(page, host, colours, site = NO_SITE_COLOURS)`: ids `assignIds(valueKey…,
  reserved = the site's ids)`, names `valueName`, and for a value the site holds the site's id and name; `file()`
  leaves those out, names it `freeName(site, "<page> (<host>)")`, null when none is left. `ConvertOptions.siteColours`
  beside `palette` in `src/core/site/convert.ts`; `sitePage` passes it.
- **Commands.** `tools/lib/site-colours.ts` (new): `readSiteColours(list: string | undefined): SiteColours` reads
  each comma-separated path, parses, calls `siteColours`; on an error prints the one line and exits 1 before anything
  is written. `tools/site.ts` (`--colours` added to `VALUED`), `tools/replay.ts`, `tools/site-upload.ts`,
  `tools/site-import.ts` pass it on; usage lines gain `[--colours <palette file>[,<file>…]]`. `site-write.ts`'s
  `Colours:` note becomes `Colours: <p> palette colours, <r> already on the site (linked to them), <n> new: import
  palette.json once …` (the old sentence when no file was given), plus `<k> of the site's colours could not be read`
  when any. `site:import`'s numbered next steps name the export step only in its usage text (no new prompt).
- **Panel.** `src/ui/site-colours.ts` (new, DOM-free): `readChosen(files: Array<{ name: string; text: string }>):
  SiteColours` (a bad file's line goes to the panel's status), `Stored.siteColours?: SiteColours` in
  `ui/settings.ts` (validated on load like `palettes`), sent with the convert message (`shared/messages.ts`), read
  by `src/plugin/convert.ts` into `ConvertOptions.siteColours`. `ui/main.ts` + `ui.html`: in the palette box a file
  input "Colours already on the site (Bricks → Style Manager → Colors → Export)", a line "<n> colours from <m>
  palettes · Clear", and after a conversion "<n> of the site's colours reused". `keepPalette` runs on what
  `paletteFile` returned (already without the site's colours) and is otherwise unchanged. File reading goes through
  `src/ui/env.ts` like the panel's other files.
- **Limits, named in HANDOFF "Deferred":** the tool knows the site's colours only from the files given (stale files
  link to deleted colours: the fallback still shows the right colour); two different colours hashing to one 6-letter
  id (1 in 309 million) are salted per palette as today; a see-through tint never links; a Figma-named colour and the
  importer's same value meet only through the files (Q1 A).

## Tasks (one commit each, test first; `npm run check` green after each)

1. **Rule module + plugin uses it** (third criterion's base). First, on the base tree: write
   `tools/shared-colour-golden.ts` (converts every Figma fixture of `test/fixtures/` that the emit tests list and
   every corpus page the machine has, writes `test/fixtures/shared-colour-base.json`: name → sha256 of
   `JSON.stringify({ payload, palette })`) and `test/unit/shared-colour-base.test.ts` (named-only, `F2B_PIN=1`);
   commit both. Then add `shared-colour.ts` (`valueKey`, `valueName`), switch `used-colors.ts` and `colors.ts`;
   `F2B_PIN=1 node --test test/unit/shared-colour-base.test.ts` stays green.
2. **Importer naming** (second criterion; skip if amended into site-shared-styles). RED: in
   `test/unit/site-palette.test.ts` replace "another page name gives other ids" by the second criterion's test.
   GREEN: `colours.ts` L69-70 `site-color:${page}:${c}` → `valueKey`, the names → `valueName`. Regenerate the
   importer's own golden pins the way site-shared-styles' Task list does (`test/unit/lib/site-pins.ts`), reason "one
   colour name per site"; update `styles.txt` expectations and the HANDOFF line of its Q4.
3. **Cross test** (first criterion): `test/unit/shared-colour.test.ts` with a generic two-colour snapshot fixture and
   the `shared-looks` capture. Green after Tasks 1–2; prove it fails with Task 2 reverted (`git checkout HEAD~1 --
   src/core/site/colours.ts`, then back).
4. **The reader** (eighth criterion): RED `site-colours.test.ts` cases for `siteColours`, `onSite`, `freeName`
   (export shape from README; `fvnsfn` amber from `ExampleBricks`; hsl, rgb, 8-digit hex with `ff`; a `raw` with a
   fallback; a see-through `light`; two equal values; a wrong file). GREEN in `shared-colour.ts`.
5. **Plugin links and file** (fourth, sixth, seventh for the Figma route): RED then `PaletteColor.site`,
   `paletteOf(…, site)`, `idsOf`, `paletteFile(p, site)`, `ConvertOptions.siteColours`, `normalise` option;
   `ConvertResult` gains `siteColoursUsed: number`. Run Task 1's pin again (no option → same bytes).
6. **Importer links and file** (fifth, sixth, seventh for the website route): RED then `siteInk(…, site)`,
   `ConvertOptions.siteColours`, `sitePage`; the result gains `coloursReused: number`.
7. **Commands** (ninth): RED `site-colours-cli.test.ts` (spawns `tools/site.ts` and `tools/replay.ts` on fixtures
   with files in a temp folder; `site-upload`/`site-import` with `--dry-run` and against
   `test/fixtures/wp-standin.ts` only), then `tools/lib/site-colours.ts` and the four tools; update every test that
   pins a usage line of those tools (grep `Usage` under `test/unit/site-*.test.ts`) in the same commit.
8. **Panel** (tenth): RED `ui-site-colours.test.ts` (stand-ins from `test/fixtures/panel.ts`), then
   `ui/site-colours.ts`, `settings.ts`, `messages.ts`, `plugin/convert.ts`, `main.ts`, `ui.html`;
   `test/unit/plugin-convert.test.ts` gains the option case (plugin bytes = replay bytes).
9. **Records**: `reference/bricks/README.md` "Colour palettes" gains "Import and an id the site has" (the facts
   above, with the 2.4.2 source) and "The site's colours as input"; HANDOFF section "One colour, one palette colour"
   (rule, Q1–Q4 with ⭐ not yet confirmed, limits, the live check); the ledger; `npm run corpus` at the close.

Gates before `ready-for-review`: `npm run check`; `npm run corpus` no worse than before Task 1; `F2B_PIN=1` pin
green; one terminal capture per criterion in the evidence folder (nothing visual changes; the tenth gets a panel
screenshot from the panel fixture page if the repo's panel tests have one, else its test run).

## Shared files and order

- With **site-shared-styles** (must be merged first, or Task 2 folded into it): `src/core/site/colours.ts`,
  `src/core/site/convert.ts`, `src/core/site/parts.ts`, `tools/site.ts`, `tools/lib/site-write.ts`,
  `test/unit/site-palette.test.ts`, the importer's golden pins, `reference/bricks/README.md` "Colour palettes".
- With **plugin-parity / importer-parity / bricks-icons**: `src/core/convert.ts` (`ConvertOptions`),
  `src/core/normalise/normalise.ts` (signature), `src/ui/main.ts`, `src/ui/settings.ts`, `src/shared/messages.ts`,
  `src/plugin/convert.ts`, `docs/HANDOFF.md`. Small, additive edits: rebase order is free; build this one **after
  site-shared-styles and before or beside the parity jobs** (it touches no structure code).
- With **media-avif-alt / media-clickable** (`tools/site-upload.ts`, `tools/site-import.ts` flags and usage lines,
  `tools/lib/site-upload/`): one added flag each; whoever merges second re-pins the usage tests.
- No shared file with site-sticky-header, site-scroll-lock, site-menu-motion.

## Risks

- **The builder's control ignores a pasted id the site holds** (unseen on a real site): the page still prints the
  site's variable (assets.php) and looks right; the live criterion shows it; if it fails, Justin reports what the
  control shows and the rule is re-planned from a copied element.
- **Justin skips the files:** nothing breaks; the notes' `Colours:` line says the file holds every colour and that
  importing it beside another page's doubles the shared ones, naming `--colours`.
- **site-shared-styles ships `--home-…` first:** its imported palette keeps working through `--colours` (matched by
  value, its own names and ids reused); only a paste made without the files shows plain fallbacks.

## Report contract

The builder stops at `ready-for-review` with: head SHA, the criteria's test names and runs, pins regenerated and
why, every usage test changed, and `skill_lessons[{skill, lesson, evidence, enforce}]`.
