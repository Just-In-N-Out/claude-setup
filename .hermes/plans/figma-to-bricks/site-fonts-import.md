# site-fonts-import: a scanned site's text fonts become Bricks Custom Fonts, and the pastes name them plainly so Typography shows and changes them

Planner: 2026-11-16 (Fable 5.2 high). Pipeline: Full. Base: `main` at `ebc7b1d9` (Build 2026-11-16.2, photo-box-image merged; the brief's 3ca1a45c is one merge older, the prototype was run on both). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-fonts-import/planner/` (start with `README.txt` and `bricks-reads.txt`). The builder copies this plan to `docs/plans/2026-11-16-site-fonts-import.md`.

## Playback

Justin (2026-11-16): "they are not being imported … yes lets do this job. So they will be imported into the bricks setting and can change them in typography."

1. Today a scanned page's own fonts ride inside every paste: each part's fonts class (`home__site-fonts-<4>`) holds the font files as base64, under page names (`home__Roboto`), and the words name those in Custom CSS. Bricks' Typography box shows nothing for them, and nothing is in Bricks' font list.
2. He wants the site's fonts in Bricks' own font setting, and each text's font shown in Typography, where he can change it.

**What the research found, and it decides the job:** Bricks' Typography lists only Adobe fonts, **Bricks' own Custom Fonts**, Google fonts and seven standard fonts. It never reads WordPress's Font Library (where the Figma panel uploads). A Custom Font can be made only by a person in wp-admin (Bricks → Custom Fonts) or in the builder's Font Manager: there is no REST route, and an Application Password doesn't work there. So **no tool of ours can put a font into Bricks from outside** without a helper plugin on the site. The plan below (answer A to Q1) gets him what he asked for with one hand step per site: the tool writes the font files and exact steps, he adds them in Bricks once (B-Dry: 2 families, 4 files), and the pastes name the fonts plainly in Typography with no file inside. Nothing new is written to WordPress.

## Questions for Justin (⭐ = taken under the standing auto-go unless he says otherwise)

- **Q1. How do the fonts get into Bricks → Custom Fonts?**
  - **A ⭐ You add them, once per site.** With `--fonts` the tool writes a `fonts` folder (the site's own files) and `fonts.txt` (numbered steps: the title to type, each file with its weight and style). About two minutes for B-Dry. Then you paste. No upload, no new permission, no plugin.
  - B. A small helper plugin on each site, so the upload command adds them itself. No hand step after one plugin install per site, but a new write to WordPress, its own security review and a later job (you declined a helper plugin for the Figma panel on 2026-10-20).
  - C. Google's copies instead of the site's files (Bricks' Font Manager downloads a Google font in one click). No files from the old site, but the looks can differ: on B-Dry "Roboto Flex" at 600 would be Google's real 600, not the site's thickened 400, and only Google families work.
- **Q2. A switch or always?** A ⭐ a switch, `--fonts` (and a tick in the importer app); without it every paste is byte for byte as today. B: always on (every paste then needs the fonts added first).
- **Q3. A weight whose file never loads on the old site** (B-Dry's Roboto 600: its words show in the next font there). A ⭐ the paste keeps showing the next font, as on the old site (your site-fonts-match answer, "show what the official page shows"), with a note and one line in `fonts.txt` saying how to make it Roboto. B: leave it to Bricks (the words then draw in the nearest weight you added, Roboto 700: bolder than the old site).
- **Q4. Icon fonts** (ElementsKit's): A ⭐ they stay inside the paste as today (no words are set in them; nothing to pick in Typography). B: also list them for Custom Fonts.
- **Q5. Fonts Bricks' Custom Fonts can't hold as the site serves them** (a variable file declared `100 900`, an `.otf`, a family in several subset files): A ⭐ they stay inside the paste as today, each named with why in `fonts.txt` and the notes. B: convert or split them (a later job).
- **Q6. Should the upload command put the font files in Media too?** A ⭐ no (you would still add each one by hand in Custom Fonts, and WordPress often refuses font files). B: yes.
- **Q7. A second page of the same site:** A ⭐ `fonts.txt` lists that page's fonts again and says to open a family Custom Fonts already shows and add only the weights it lacks, never a second one of the same name. B: the tool reads the new site's front page to see which are there already (a later job).
- **Q8. The Figma plugin's own fonts** (today WordPress's Font Library plus `@font-face` in the paste): A ⭐ a separate job after this one (both tools should end the same; this job is the importer). B: fold it in now.

## What Bricks reads (the facts; sources in `bricks-reads.txt`)

| Fact | Source |
|---|---|
| Typography's font box lists Adobe, Custom Fonts, Google, Standard; never the WordPress Font Library | Bricks 2.2 `builder.php` L610-697; 2.4.2 builder script `fontOptions` at byte 3363478; the script holds no `font-families` or `wp_font_family` |
| The Custom Fonts post type has no REST route; it is made only through wp-admin or admin-ajax with a session nonce | 2.2 `custom-fonts.php` L766-813 (no `show_in_rest`), L31-40, L680-706, L895-925, L1251-1407; 2.4.2 script's Font Manager actions at 1779891, 1762155 |
| Custom Fonts take woff2, woff and ttf only | 2.2 `custom-fonts.php` L510-531 |
| Every Custom Font's `@font-face` (family = its title) is printed on every page | 2.2 `custom-fonts.php` L161-180, L224-314 |
| A Typography `font-family` prints as `"<value>"` plus `, <fallback>`; the 2.4.2 builder does the same | 2.2 `assets.php` L2731-2765; 2.4.2 script at byte 111651 |
| Bricks loads no Google copy of a family whose name a Custom Font has (since 2.0) | 2.2 `assets.php` L1210-1220, L1242-1245 |
| The Font Manager's drop import can misread a woff2's weight (400) and lets two files of one weight overwrite each other | 2.2 `custom-fonts.php` L1251-1407, L1586-1670 |

Bricks 2.4.2 and 2.3.9 PHP isn't available offline: the PHP lines are 2.2's, and the live check proves them on B-Dry staging (2.4.2).

## The rule (general, any site)

With the fonts option on, a family is **left to Bricks** when all of these hold; every other family is written exactly as today:

1. the capture reads fonts as Build 2026-11-12.2 or later does (`web.fontsRead === 2`) and carries the family today (every face `source: "site"`, no subset files: `carriedFamilies`);
2. words are set in it: some words node's computed first family, at any width range, in the page or in a box a button opens (an icon font named only for a `::before` glyph is not);
3. at least one file of it loads on the old site;
4. every loaded file is woff2, woff or ttf (read from the file's first four bytes, not its MIME type), declared by the site at one whole-hundred weight 100–900 and a style of normal, italic or oblique.

For a family left to Bricks the paste writes its **plain name**: in Bricks' Typography `font-family` (with `fallback` = the rest of the site's list) wherever a control fits, as today's Google families are written, and plainly in the Custom CSS that stays. No file of it is in the paste. A face of it that fails on the old site stays one failing `@font-face` under the plain name in the fonts class (Q3 A). Every weight written is one whole hundred, as today.

The paste depends only on the capture and the option, never on what the new site holds. Without the option nothing changes by a byte.

**How this meets the Bricks-pro standard:** point 5 (editable content: a text's font is in Typography, the font itself in Bricks' font list, nothing baked into CSS a person expects in a field), point 3 (a setting before Custom CSS), point 6 (looks stay true: the same files, 0 px moved on B-Dry's home at 1440, 768 and 390).

## Proved on the prototype (`prototype/prototype-on-ebc7b1d9.patch.txt`, three files)

- Justin's home scan (copied to `~/.cache/sfi-pl/home/`, converted offline, `--elementor`): option off, header, page and footer are main's byte for byte, with and without his media map. Option on: **Roboto** (400, 500, 700 woff2; 600 failing kept) and **Roboto Flex** (400 woff2) left to Bricks; ADLaM Display (no file loads) and elementskit (icon font) stay. Pastes 995 → 695 KB, 1287 → 986 KB, 1037 → 736 KB. Typography `font-family`: header 3× Roboto, page 33× Roboto and 2× Roboto Flex, footer 16× Roboto (main: none). No `home__Roboto` left anywhere.
- Drawn offline with the Custom Fonts' CSS printed as Bricks prints it: 626 elements, 0 moved, worst 0 px at 1440, 768 and 390. Control without the Custom Fonts: 364 elements move (worst 424 px), so the comparison can fail.
- The generic fixture (`test/fixtures/site-fonts-code.ts`): Site Sans taken (400, 700), its failing 600 kept, icons left; a variable file, an otf and an older capture left with their reasons; option off, all 18 sums equal main's.
- `npm run typecheck` passes on the prototype; `npm test` on exported trees: 3931 pass and the same 6 fail on base and prototype (tests that need a git checkout or the corpus).

## Acceptance criteria (all proposed; one test each)

- AC1 (proposed): Given a capture whose words are set in a family the site serves in its own woff2, woff or ttf files, when it is converted with the fonts option, then on both routes every part writes that family by its plain name (Typography `font-family` with the rest of the list as `fallback` where a control fits, the plain name in the Custom CSS that stays), no part holds the page-named copy or any file of it, the page result lists the family with one face per weight and style, and every font weight written is one whole hundred. Test: `test/unit/site-fonts-import.test.ts` "AC1 a family words are set in is written by its plain name in Typography and its file leaves the paste"
- AC2 (proposed): Each kind of family is taken or left for its own reason, and a left family is written exactly as without the option: taken (files of one whole-hundred weight each); left because no words are set in it (an icon font), no file of it loads, a file is not woff2/woff/ttf, a file is declared at a weight range or keyword, a file's style isn't normal/italic/oblique, it comes in subset files or partly from Google, or the capture was read before fontsRead 2; a family Google serves is as before and never listed. When nothing is taken the pastes are byte for byte the option-off pastes. Test: `test/unit/site-fonts-import.test.ts` "AC2 each kind of family is taken or left for its own reason, and a left family pastes as before"
- AC3 (proposed): A taken family's face whose file fails on the old site stays one `@font-face` under the plain name with `src: url("data:,")` at its weight in the fonts class, and each part keeps the note that its words show in the next font. Test: `test/unit/site-fonts-import.test.ts` "AC3 a taken family's face that fails on the old site stays a failing face under its plain name"
- AC4 (proposed): The font files written for a taken family are the capture's own bytes, one file per weight and style, named `<Family>-<weight>[-italic|-oblique].<ext>` with every character outside letters, digits and `-` as `-` and two families never sharing a name; `fonts.txt` names each family's title to type, each file with its weight and style, what to do when Custom Fonts already shows the family (open it, add only what it lacks, never a second one), and every left family and failing face with why. Test: `test/unit/site-fonts-out.test.ts` "AC4 the font files are the capture's own bytes and fonts.txt names each with its weight and style"
- AC5 (proposed): Without the option every paste and every note is byte for byte the base's (main `ebc7b1d9`): the 18 sums of the fonts fixture (used, failed and older captures, both routes, three parts) made on the base tree. A story-time pin: it runs only when named (`F2B_PIN_BASE=1`), as forms-wpforms' does. Test: `test/unit/site-fonts-import.test.ts` "AC5 without the fonts option every paste and note is byte for byte the base's"
- AC6 (proposed): `npm run site -- <capture> <out> --fonts` writes `fonts/` and `fonts.txt` beside the pastes, each part's notes carry one `Fonts:` line, and the command prints one line naming `fonts.txt`; without `--fonts` the out folder's file list, every file's bytes and every printed line are as before; with `--section` or `--path` it stops with one plain line and writes nothing. Test: `test/unit/site-fonts-cli.test.ts` "AC6 site --fonts writes the fonts folder and fonts.txt, and without it the folder is as before"
- AC7 (proposed): `site:upload … --fonts` against the WordPress stand-in sends exactly the requests the same run without `--fonts` sends (method and path, in order) and no request body holding a font file; its list before the typed yes says the fonts are added by hand and nothing of them is uploaded; `site:import`'s numbered next steps name the fonts step before the first paste, and the `site:upload` line it prints for a stopped run carries `--fonts`. Test: `test/unit/site-upload-fonts.test.ts` "AC7 an upload run with --fonts sends WordPress nothing for the fonts and names the step before the paste"
- AC8 (proposed): The importer app has one option row for `--fonts` that reaches `site` and `site:upload` and no other command. Test: `test/unit/importer-app-commands.test.ts` "AC8 the app's fonts option reaches site and site:upload as --fonts"
- AC9 (proposed): A fixture site serving its own font files, scanned and pasted with the option, drawn in offline Chrome with the Custom Fonts' CSS printed as Bricks prints it (Bricks 2.4.2 and 2.3.9 front-end CSS; 1440, 768, 390): every element's box equals the option-off paste's within 0.01 px and each line is drawn with the same font file; without the Custom Fonts' CSS the same check fails. Test: `test/web/site-fonts-import-drawn.test.ts` "AC9 a paste with its fonts left to Bricks draws every element as the paste carrying them does"
- AC10 (proposed): Justin's home scan (a copy given by `F2B_SCAN`, never `~/Downloads` itself), converted offline with `--elementor`: Roboto (400, 500, 700; 600 failing kept) and Roboto Flex (400) are left to Bricks and written by their plain names in Typography in header, page and footer; ADLaM Display and elementskit stay with their reasons; no `home__Roboto` is left; drawn offline every element is where the option-off paste draws it at 1440, 768 and 390. The test's own assertions are generic (every taken family of the given scan); its printed lines name the families. Test: `test/web/site-fonts-import-scan.test.ts` "AC10 a saved scan given by F2B_SCAN pastes its taken families by plain name and draws as before"
- AC11 (proposed) (live): Paste check **3fb**. Justin runs his own `npm run site:import -- <bdryswi.com page> <B-Dry staging> --elementor --fonts`, follows `fonts.txt` (Bricks → Custom Fonts: Roboto with 400, 500, 700; Roboto Flex with 400), pastes: Custom Fonts and the Typography font box list Roboto and Roboto Flex; a pasted heading's or text's Typography shows Roboto; in a private window the words look as on bdryswi.com at desktop and phone width; the page source holds no `fonts.googleapis.com` link for Roboto.
- AC12 (proposed) (live): Paste check **3fc**. On that page he changes one shared text class's font in Typography to another font and every element carrying the class changes; he changes it back to Roboto (under Custom Fonts in the box) and the words are Roboto again.

## What is built

**Core (pure, runs in Figma's sandbox: no `Buffer`, `atob`, `URL`, `localeCompare`):**
- `src/core/site/fonts.ts`: `CarriedFonts.plain` (the families left to Bricks, lower case); `siteFaces` skips a plain family's loaded faces and keeps its failed ones under the plain name; `failedFaceNotes` covers plain families; `wordFamilies(code)`; `bricksFonts(capture, words, failed)` returning `BricksFonts { families: BricksFamily[]; left: Array<{ family; why }> }`. Start from the prototype patch, then: sort faces with plain `<` comparisons instead of `localeCompare`; make `left` also name site families that aren't carried (subset files or partly Google: "the scan can't tell its files apart") and, for a capture without `fontsRead 2`, every site family with a file ("scan the page again with this build").
- `src/core/site/convert.ts`: `ConvertOptions.fonts?: "bricks"` (absent: as before).
- `src/core/site/parts.ts`: in `sitePage`, the plain set from `bricksFonts`, taken out of the carried names; `SitePage.fonts`; one `Fonts:` note per part when the option is on (the same line on every part: the families to add with their weights, "fonts.txt beside the pastes", and what stays with why).

**Tools:**
- `tools/lib/site-fonts-out.ts` (new, small): `fontFiles(fonts)` (name and bytes per face, `Buffer.from(base64, "base64")`), `fontsText(fonts, page, host)` (the text of `fonts.txt`, wording below), `fontsLine(fonts, outDir)` (the one printed line).
- `tools/lib/site-write.ts`: `WriteOptions.fonts?: boolean` → `convertOptions` adds `fonts: "bricks"`; `writePastes` writes `fonts.txt` whenever the option is on and `fonts/<name>` for each taken face, and returns the printed line. `writeSection` is untouched.
- `tools/site.ts`: `--fonts` (a switch; with `--section`/`--path` one line "`--fonts` needs the whole page: leave out --section / --path" and exit 1, nothing written); the usage line.
- `tools/lib/site-upload/args.ts` (`SWITCHES`), `flow.ts` (`pick`'s options), `summary.ts` (one line in the list before the question, only with `--fonts`), `tools/site-upload.ts` (usage).
- `tools/lib/site-import/args.ts` (`ImportArgs`, `uploadLine` carries `--fonts`), `next.ts` (`nextSteps` option `fonts?: { families: number; files: number }`: one step after the palette step and before the first copy step), `tools/site-import.ts` (usage).
- `tools/lib/importer-app/commands.ts`: one `OPTIONS` row `{ flag: "--fonts", valued: false, to: ["site", "upload"], label: "Fonts as Bricks Custom Fonts", help: "you add the files in Bricks → Custom Fonts first (fonts.txt)" }`.
- No request to WordPress is added anywhere. `site:check`, `site:live` and the panel get no option (follow-ups).

**`fonts.txt` wording** (plain, one action a step; the labels are Bricks 2.2's Custom Fonts screen, confirmed on 2.4.2 by the live check):

```
Fonts for Bricks: page "home" of bdryswi.com

Add these once on the new site, before you paste. Bricks then lists them in every Typography font box.

1. In WordPress admin open Bricks → Custom Fonts.

"Roboto" (3 files)
2. If the list already shows "Roboto", click it and add only the weights below it lacks. Never make a second "Roboto". Otherwise click Add New and type the title exactly: Roboto
3. Click "Add a font variant". Font weight: 400. Font style: Normal. In the row "WOFF2 file" click Upload and choose fonts/Roboto-400.woff2
4. The same for: 500, Normal, fonts/Roboto-500.woff2
5. The same for: 700, Normal, fonts/Roboto-700.woff2
6. Click Publish (Update for a font that was there).

"Roboto Flex" (1 file)
7. …

Then paste. Until a font is added, its words show Google's copy (a family Google has) or the next font.

Stays in the paste, nothing to do:
- "elementskit": no words are set in it (an icon font)
- "ADLaM Display": no file of it loads on the old site; its words show in the next font, as there
- "Roboto" 600: the old site's file doesn't load, so words at 600 show in the next font, as there. To make them Roboto: add a 600 variant to "Roboto" and delete the Roboto 600 line from the class home__site-fonts-…'s Custom CSS.
```

## Tasks (in order; each test first, each commit green: `npm run check`)

Before Task 1: `npm run corpus` (the repo's rule), and make the base sums: `node ~/.hermes/plans/figma-to-bricks/evidence/site-fonts-import/planner/probes/sfi-planner-sums.ts "$PWD"` on the untouched tree must print `logs/sums-main-ebc7b1d9.json` (if `main` moved, record the new sums and say so in the ledger).

1. **Core, taken families.** Write the three tests for AC1, AC3 and AC5 in `test/unit/site-fonts-import.test.ts`, on `fontsPage()` of `test/fixtures/site-fonts-code.ts`, through `sitePage(capture, { fonts: "bricks" })` only (never import a new helper at the top of the file: on the base the option is ignored, so the tests fail by assertion, not by a missing export). Red: `node --test test/unit/site-fonts-import.test.ts` fails on "Site Sans" missing from the Typography controls and on `page.fonts` being undefined. Apply the prototype patch (`patch -p1 < …/prototype/prototype-on-ebc7b1d9.patch.txt`), replace `localeCompare`. Green. The pin for AC5 reads `test/fixtures/site-fonts-import-main.json` (the base sums) and is skipped unless `F2B_PIN_BASE=1`.
2. **Core, every reason.** The test for AC2 with one fixture variant per outcome (`fontsPage({ fonts })`: a `100 900` file, an `OTTO` file, a family with only a failed face, an oblique-with-angle style, a `subsets` face, a family with one Google face, `read: null`, the icon font, the Google family). Red on the outcomes the prototype doesn't name yet (subset, Google-mixed, older capture). Extend `left`. Green. Add the `Fonts:` note with its assertion in the AC1 test.
3. **The files and the text.** `test/unit/site-fonts-out.test.ts` for AC4 (bytes equal `Buffer.from(file.base64, "base64")`, names, a name collision, every `fonts.txt` line of the wording above from a generic fixture). Red: the module is missing, so this one test file fails to load; say so in the ledger. Write `tools/lib/site-fonts-out.ts`. Green.
4. **`site`.** `test/unit/site-fonts-cli.test.ts` for AC6 (spawn `tools/site.ts` on a fixture capture written to a temp folder, as `site-upload-cli.test.ts` L143 does; file lists and bytes with and without the flag; the section refusal). Red, then `site-write.ts` and `tools/site.ts`. Green.
5. **`site:upload` and `site:import`.** `test/unit/site-upload-fonts.test.ts` for AC7 against `test/fixtures/wp-standin.ts` (two runs, compare `requests` by method and path; no logged body's sha256 equals a font file's; the summary line before the question; `nextSteps` and `uploadLine`). Red, then `args.ts`, `flow.ts`, `summary.ts`, `site-import/args.ts`, `next.ts`, the two usage lines. Green. Existing tests that pin a usage line (`site-import-args.test.ts`, `site-colours-cli.test.ts`, `test/web/site-cli.test.ts`) are updated in the same commit, named in the ledger and HANDOFF.
6. **The app.** The AC8 test in `importer-app-commands.test.ts` and the table of its first test (the pinned `OPTIONS` list gains the row). Red, add the row. Green. Run `importer-app-preview-child.test.ts`: the preview draws a `--fonts` paste with its fonts, because `fontsHead` already prints the capture's faces under plain names.
7. **Drawn.** `test/web/site-fonts-import-drawn.test.ts` for AC9 on the `font-rules` fixture site (`captureFixture("font-rules", …)`, `launchOffline`, `offlineFetch`, as `site-fonts-drawn.test.ts`), the Custom Fonts' CSS built from `page.fonts` as `probes/sfi-planner-draw.ts` builds it, the control without it. The test first asserts the fixture's family is taken (this machine's fixture font must be a ttf, woff or woff2: `test/fixtures/web/serve.ts` `MACHINE_FONTS`; if it is another kind, serve a ttf from that list) so it can't pass on an unchanged paste. Check `/proc/loadavg` first; run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
8. **The saved scan.** `test/web/site-fonts-import-scan.test.ts` for AC10 (skipped without `F2B_SCAN`; the comparison of `probes/sfi-planner-draw.ts`). Run it on a copy of Justin's scan only inside the no-network namespace and an 8G scope; its printed lines are the receipt.
9. **Records.** `docs/HANDOFF.md` section (the rule, the rulings Q1–Q8 as not yet confirmed, paste checks 3fb and 3fc, the tests changed on purpose, the follow-ups below); `reference/bricks/README.md` "Fonts Bricks' Typography lists" (the table above with its sources); the ledger. `npm run corpus` at the close.

One screenshot per AC: terminal captures for the unit ACs; for AC9 and AC10 a side-by-side picture (off, on) at 1440 and 390.

## Tests that change on purpose (nothing else may)

- `test/unit/importer-app-commands.test.ts`: the pinned option table gains `["--fonts", false, "site+upload"]`.
- The usage-line pins in `test/unit/site-import-args.test.ts`, `test/unit/site-colours-cli.test.ts` and `test/web/site-cli.test.ts`, only where they quote a usage line that gains `[--fonts]`.
- No paste pin moves: with the option absent every conversion is byte for byte as before (proved on the fixture's 18 sums and on Justin's scan).

## Risks and limits

- **Bricks 2.4.2's PHP is unread** (2.2's is): that every Custom Font's faces print on every page and that a same-named Custom Font stops the Google load are proved only by AC11. If AC11 fails on either, the fallback is answer C for Google families, a new question for Justin.
- **The wp-admin labels in `fonts.txt` are 2.2's.** If 2.4.2's screen reads differently the text changes (one file, one test).
- **Bricks' builder canvas** may draw Google's Roboto for a plain "Roboto" value while the published page uses the site's file (the control's value is a plain name, not `custom_font_<id>`: an id can't be known from outside). The live check looks at the published page.
- **Pasted before the fonts are added:** a family Google has shows Google's copy, any other the next font. The notes, the printed line and the numbered step say "first".
- **A paste made with `--fonts` and one made without** give shared classes different settings (and so different class names); use the same choice for every page of a site.
- **The Font Manager's drop import** misreads woff2 weights in 2.2's code: `fonts.txt` uses the classic screen, one variant per file with its weight named.
- **ElementsKit's 450 KB icon font stays in every part** (Q4 A).
- **`site:live`** converts without the option; its mapping is by element and its measures are boxes, which don't move. A `--fonts` flag for it is a follow-up if a class comparison needs it.

## Shared files with jobs in flight (names only)

- photo-box-image (merged, `ebc7b1d9`): `src/core/site/convert.ts` (`ConvertOptions`, the line beside `photoBoxes`), `src/core/site/parts.ts`. The prototype is already on it.
- short-class-names (`short-class-names-on-main7`): `src/core/site/convert.ts`, `src/core/site/parts.ts`, `test/unit/site-fonts.test.ts`, `tools/lib/site-write.ts`, `tools/site.ts`, `tools/site-upload.ts`, `tools/site-import.ts`, `tools/lib/site-upload/args.ts`, `tools/lib/site-upload/flow.ts`, `tools/lib/site-import/args.ts`, `tools/lib/site-import/next.ts`. It renames `<page>__` names, the fonts class and the carried family names among them: whichever merges second re-runs the other's font tests.
- fewer-kept-boxes (`fewer-kept-boxes-on-main7`): `src/core/site/convert.ts`, `src/core/site/parts.ts`.
- clean-values (`clean-values-build`): `src/core/site/convert.ts` (and `controls.ts`, which this job doesn't touch).
- link-keeps-name: no local branch found; unknown.

## Follow-ups (not in this job)

- Q1 B: a helper plugin so the upload command adds Custom Fonts itself.
- Q7 B: read the new site's front page for the Custom Fonts it prints, and list only what is missing.
- Q8: the Figma plugin's fonts the same way.
- Q5 B: variable, otf and subset families.
- `--fonts` on `site:check` and `site:live`; a hint line without the flag ("N families can be Bricks Custom Fonts: run again with --fonts"), left out so every printed line without the flag stays as before.

## Completion contract

The builder stops at `ready-for-review` with: every agent-run AC's test passing (the pin of AC5 run with `F2B_PIN_BASE=1`, the scan test of AC10 with `F2B_SCAN` on a copy), `npm run check` and `npm run corpus` clean, the ledger, the HANDOFF section, one receipt per AC in `~/.hermes/plans/figma-to-bricks/evidence/site-fonts-import/`, and `skill_lessons`. It never loads a live site, never runs an upload against anything but `test/fixtures/wp-standin.ts`, and touches nothing under `~/Downloads`. AC11 and AC12 are Justin's.
