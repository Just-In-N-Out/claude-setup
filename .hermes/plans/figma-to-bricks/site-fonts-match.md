# site-fonts-match: the pasted page's words are drawn with the fonts the old site's visitors see

Planner, 2026-11-11, on main `11f07742` (Build 2026-11-11.5). A bug, asked as Mini. Builder: copy this file to
`docs/plans/2026-11-11-site-fonts-match.md`. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/planner/`
(called `<ev>` below). Nothing was built, committed or loaded from bdryswi.com, staging or any live site.

## Playback

1. Justin pasted his scan of bdryswi.com on B-Dry staging and the words looked like another font than on the official
   page. He asks whether he must import the fonts into WordPress by hand.
2. The cause is found: the official site's own heading font files are broken, so it shows headings in the computer's
   plain sans-serif (Arial, Helvetica); the paste shows real Roboto from Google. Three smaller differences sit beside it.
3. The fix makes every scanned page carry exactly the font files its visitors get, under names Bricks can't swap for
   Google's. He does nothing in WordPress: no font import, no setting.

## Questions (auto-go takes the ⭐ answers; reply "stop" or the letter to change one)

- **Q1. Where the old site's own font file doesn't load (here: its heading font), what should the paste show?**
  - **A ⭐ What the official page shows today**: those words in the next font of the site's list (Arial or Helvetica for
    B-Dry's headings and buttons). Side by side the two pages match. The notes name each broken file in one line.
  - B The font the site's designer meant (real Roboto from Google, as the paste does now). The headings then keep
    looking different from the official page, by choice. Costs nothing extra: it is one default in the same code.
- **Q2. Size.** This is bigger than Mini (7 source files and Q1's decision; Mini is 1 to 3 files and no decision).
  ⭐ Run it as **Full**, with the importer's standing "one review per job" rule. The plan is the same either way.

## What was found (all measured, none guessed)

The site side is Justin's own scan of 2026-11-11 (`~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`, `web.fonts`),
the saved served page and CSS (`evidence/web-code-proof/planner/inputs/bdry-2026-10-29/css2.css`), and a picture of the
real page from 2026-10-26 (`evidence/bdry-source/body-<width>.png`). The paste side is his pastes' CSS drawn as Bricks
2.4.2 prints it, header, page and footer together, with the Google link staging's Bricks adds (copied from the saved
staging page `evidence/footer-icon-list/planner/staging/homev2.html`); each word's font file read with Chrome's
`CSS.getPlatformFontsForNode` (`<ev>/measure.log`). The official site's own files can't be read with a browser here
(rule: never load bdryswi.com), so its side is the scan's record plus the 2026-10-26 picture.

| Words | The official page draws them with | The paste on staging draws them with | Same? |
|---|---|---|---|
| Roboto 600: headings, buttons, menu (35 runs) | the next font in the list, `Sans-serif` (Arial, Helvetica; DejaVu Sans on Linux): the only 600 file is on `growithgro1.wpcomstaging.com` and answers HTTP 403 | Google's Roboto 600 | **No: the difference Justin saw** |
| Roboto 400, 500, 700: paragraphs, links | the accessibility plugin's own Roboto files on bdryswi.com (`Roboto-Regular.woff2` …) | Google's Roboto | Close, not the same file |
| Roboto Flex 600: the slider's headings (7 runs) | its one 400 file, made bold by the browser | Google's real Roboto Flex 600; the paste's own 400 file is never used | No |
| ADLaM Display 400 (3 runs) | the next font in the list (its file is on the same dead address) | Google's ADLaM Display | No |
| elementskit icons | the site's file | the same file, inside the paste | Yes |
| Size, line height, letter spacing, weight asked, stretch | 40px / 52px / normal / 600 / 100% (heading at 1440), 24px / 39.6px (paragraph); 32px and 16px at 390 | the same values; the heading's and paragraph's boxes equal the site's at 1440 (56,1287,619×52 and 56,1359,619×554) | Yes |
| The footer's words | Roboto as above | finds Roboto: Bricks' Google link is for the whole page, also when the footer is in a Footer template | Same as the rows above |
| staging's Theme Style | — | doesn't reach the paste's words (the test theme sets serif headings; the paste's still compute Roboto) | — |

Pictures (site left, paste right, same heading and paragraph): `<ev>/site-vs-paste-1440.png`, `<ev>/site-vs-paste-390.png`.
The paragraph is the same; the heading is the plain sans-serif on the site and Roboto SemiBold in the paste.

## Root cause (file:line)

1. **Bricks adds Google's copy of any family a paste names.** Bricks scans the page's CSS for every Google family name
   and adds it when a rule's `font-family` starts with it, with all its weights (Bricks 2.2 `includes/assets.php`
   L1223-1345, saved at `evidence/site-shared-styles/planner/bricks-2.2/assets.php`; a paste's own `@font-face` rule
   counts too). The paste writes a site-served family under its plain name and as a Typography control
   (`src/core/site/fonts.ts:16-20` `typographyFamilies` takes `site` families; `src/core/site/controls.ts:99`;
   `src/core/site/fonts.ts:80-83` prints `font-family: "Roboto Flex"`). So staging's link holds
   `Roboto:ital,wght@0,100…1,900`, `Roboto+Flex:wght@400;600`, `ADLaM+Display:wght@400`: faces the site never shows.
2. **A face whose file fails on the site is not carried as failed.** The scan's browser recorded Roboto 600 and ADLaM
   Display as `status: "error"`; the paste writes nothing for them, and cause 1 fills them with Google's. In the
   browser, words whose picked face fails go to the next family, never to another weight (`<ev>/measure.log` E1:
   `#a6` drawn with DejaVu Sans Mono; the comment at `src/web/read/fonts.ts:30-31`).
3. **The scan keeps the wrong file for a face.** `usedFaces` looks a face's file up by family, weight and style only
   and the last `@font-face` rule wins (`src/web/read/fonts.ts:115`, `:128-130`). bdryswi.com has two rule sets for
   Roboto 400: the plugin's (loads) and Elementor's nine unicode-range rules on the dead address (fail). The scan
   kept the dead address for 400, 500 and 700, the download answered 403 (`web.notes`: "couldn't be kept (HTTP 403)"),
   so the capture holds no Roboto file and the paste no Roboto `@font-face` (`<ev>/capture-and-paste-fonts.txt`).

Not causes: sizes, spacing and line heights are copied as the site's; the Google stand-in the scan measures failed
faces with (ruling R10) stays, so box measurements stay the same on every computer.

## Fix (general: every scanned site)

**Rule: a family the site serves itself is carried by the paste, face for face, under the page's own name.**

- **Scan (`src/web/read/fonts.ts`).** (a) A face's file is its own rule's: rules and `FontFace`s are paired by family,
  weight, style, stretch and unicode-range (normalised: `normal` = 400, `bold` = 700, no stretch = `100%`, no range =
  `U+0-10FFFF`; Chrome writes both sides the same way, `<ev>/measure.log` "E1 rules"), the k-th face of a key with the
  k-th rule of that key; among the faces font matching picks, the **last loaded one in document order** is the face
  (the one the browser draws Latin with); today's lookup stays for a rule the page can't read. (b) `withFontFiles`
  also asks once for the file of a site face that failed in the scan's browser: served → its bytes are kept (the
  failure was the scan's), refused → none, as today, with today's note. (c) The capture says so: `web.fontsRead: 2`
  (`src/core/snapshot/web.ts`, set where `capture.ts:442` assembles `fonts`).
- **Paste (`src/core/site/fonts.ts`, `convert.ts`, `parts.ts`).** Only for a capture with `fontsRead: 2`:
  - `carriedFamilies(capture, failed)`: a family with a `site` face (and no `google` one) whose every site face has
    bytes or, with `failed: "as-site"` (the default, Q1 A), has `status: "error"`.
  - `renameFamilies(value, page, carried)`: each family of a `font-family` value that is carried becomes
    `"<page>__<Family>"` (the class-name rule of 2026-11-07); the rest of the list and `!important` stay. Applied in
    the one place a paste's values are fixed (`convert.ts:248-253` `fix`, beside the whole-hundred weights), so the
    element's, `::before`/`::after`, inline, state and root-context values all get it.
  - `typographyFamilies` leaves carried families out: they stay custom CSS with the site's whole list.
  - `siteFaces`/`fontFaces` declare each face under that name: a face with bytes as today; a failed face as
    `src: url("data:,")` at its declared weight and style, so words that pick it go to the next family, as on the
    site (`<ev>/measure.log` E1 `#a26`).
  - Notes: one line per failed face (family, weight, address: the site draws the next font, and so does the paste).
  - `ConvertOptions.failedFaces?: "as-site" | "stand-in"` (`convert.ts:49`); `"stand-in"` leaves a family with a failed
    face as before this build.
- **Checks (`tools/site-check.ts`, `test/web/lib/site-check.ts:39-44`).** `site:check` converts with
  `failedFaces: "stand-in"` and its head also asks the font source for a failed face the capture measured with a
  stand-in, so it compares like with like on every computer; it prints one line naming such a family.
- A capture made before this build, a family the site loads from Google, and Figma designs: byte for byte as before.

**Does Justin do anything in WordPress? No.** He scans the page again with this build and pastes; no font import, no
Bricks setting. (After the paste: Regenerate code signatures and LiteSpeed Purge All, as always.)

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a page whose family has two `@font-face` rules of one weight and style, a whole-range rule whose file loads and a later unicode-range rule whose file answers 403, when it is captured, then the face lists the address and bytes of the file that loaded. Test `test/web/capture-fonts.test.ts`: "AC1 a face two rules declare keeps the file of the rule that loaded"
- AC2 (proposed): Given a site face that failed in the scan's browser, when the scan's end asks its file again, then a served font file keeps its bytes and a refused one keeps none and its note; the capture carries `fontsRead: 2`. Test `test/unit/web-fonts.test.ts`: "AC2 a failed site face is asked again at the scan's end: served keeps its bytes, refused keeps none"
- AC3 (proposed): Given a `fontsRead: 2` capture whose site family has every face accounted for, when it is converted (plain and `--elementor`), then every `font-family` of the paste (class CSS, pseudo, inline, state, root) names it `"<page>__<Family>"` with the rest of the site's list kept, no Typography control holds it, and the fonts class declares its faces under that name. Test `test/unit/site-fonts.test.ts`: "AC3 a family the site serves itself is written under the page's name and never as a Typography control"
- AC4 (proposed): Given AC3's paste printed as the test renderer prints it, when Bricks' Google font scan (assets.php L1223-1345, ported in the test) reads that CSS, then it adds no family the site serves itself and still adds a family the site loads from Google. Test `test/unit/site-fonts.test.ts`: "AC4 Bricks' Google font scan adds no family the site serves itself"
- AC5 (proposed): Given a `fontsRead: 2` capture whose site family has a 400 face with bytes and a 600 face that failed, when the paste is drawn in Chrome, then 600 words are drawn with the next family of the site's list, 400 words with the site's file, and words at a weight no face declares (300) with the site's file too. Test `test/web/site-fonts-drawn.test.ts`: "AC5 words whose face the site fails to load go to the next font, as on the site"
- AC6 (proposed): Given AC5's capture, when it is converted, then the notes hold one line per failed face naming the family, the weight and the file's address, and none for a face with bytes. Test `test/unit/site-parts.test.ts`: "AC6 the notes name each font file the site fails to serve"
- AC7 (proposed): Given a capture without `fontsRead` (every capture made before this build), when it is converted, then its pastes are byte for byte what the base tree writes: the family keeps its plain name and its Typography control. Test `test/unit/site-fonts.test.ts`: "AC7 a capture read before this build pastes its fonts as before"
- AC8 (proposed): Given AC5's capture, when `site:check`'s conversion and head are made, then that family keeps its plain name there and the head asks the font source for the failed face at its weight, and a capture with no failed face gets the same pastes as `npm run site`. Test `test/unit/site-check-fonts.test.ts`: "AC8 site:check draws a failed face with the stand-in the capture measured with"
- AC9 (proposed) (live): Justin scans bdryswi.com again with this build (`npm run site:import`), pastes on staging and looks at both pages side by side at desktop and phone width: headings, paragraphs, buttons, the menu and the footer's words look the same.

## Touched files

Source: `src/web/read/fonts.ts`, `src/web/capture.ts` (the marker), `src/core/snapshot/web.ts`, `src/core/site/fonts.ts`,
`src/core/site/convert.ts`, `src/core/site/parts.ts`, `tools/site-check.ts`, `test/web/lib/site-check.ts`.
Tests: the five files the criteria name (two new: `test/web/site-fonts-drawn.test.ts`,
`test/unit/site-check-fonts.test.ts`), one fixture page under `test/fixtures/web/sites/` for the two-rule family.
Not touched: the Figma route (`src/core` outside `site/`, `src/plugin`), the panel's font upload (`src/ui`), `readFonts`'
stand-in (R10), the uploader.

## Tasks (test first, one commit each, `npm run check` green after each)

0. Before anything: `npm run check` and `npm run corpus` on the copy; record both tallies in the ledger. Read
   `references/repeat-mistakes.md` of the project skill and of feature-dispatch.
1. Scan, the right file (first criterion). Add the fixture page (a family with a whole-range rule served by the
   fixture and a later `unicode-range: U+0000-00FF` rule whose file the fixture answers 403). Write the test, see it
   red (today the 403 address is kept, no bytes), change `usedFaces` (the pairing and "last loaded"), green. Keep
   `test/unit/web-fonts.test.ts` and the other `capture-fonts` tests green.
2. Scan, the end-of-scan ask and the marker (second criterion). The existing test "a loaded site face keeps its file
   once per address; an error page, a refusal, a failed face or another source's face keeps none" changes on purpose
   in one clause only: a failed face is now asked, and keeps none when refused. Say so in the ledger.
3. Paste, the pure parts (third, sixth and seventh criteria): `carriedFamilies`, `renameFamilies`, the failed face in
   `siteFaces`/`fontFaces`, `typographyFamilies`. `renameFamilies` splits a value as `familiesOf` does (quotes may hold
   commas), matches a family without case, keeps generic names, system families and a trailing `!important`.
4. Paste, wiring (`convert.ts` `fix`, `parts.ts` `familiesNamed`/`fontFaces`, the notes, `failedFaces`). The AC3 fixture
   capture names the family in an element's class, a `::before`, an inline element, a hover look and the root context,
   and once unquoted inside a system list (`-apple-system, …, Roboto, …`). Then the fourth criterion's test: port
   Bricks' scan (for each Google family in a short list the test gives, find it in the CSS, take the enclosing
   `{…}`, strip quotes, cut at the first comma, compare) and run it over the renderer's page.
5. The browser proof (fifth criterion): draw the paste with `renderSitePaste`, read each word's font with
   `page.cdp("CSS.getPlatformFontsForNode")` (the way `<ev>/measure.mjs` does); the 400 face is a real font file from
   the fixtures. One picture of the three lines for the ledger.
6. `site:check` (eighth criterion), then the repo's own pins: run the whole suite; a test that pins a site family's
   plain name in a **fresh fixture capture's** paste (they now carry `fontsRead: 2`) moves to the page name and nothing
   else in it changes; list each in the ledger. `test/fixtures/site-no-revert-main.json`: make it again only if it
   differs, saying why.
7. The byte receipt for the seventh criterion: `npm run site` on the base tree and on the head for every saved capture
   the tests use and for Justin's (`~/Downloads/bdry-test/…capture.json`, read only, `--elementor`), compared by bytes,
   into the ledger; and one screenshot or terminal capture per criterion.
8. Close: `npm run check`, `npm run corpus` (compared with task 0 by name), HANDOFF and ledger.

Stop and report instead of working around it if: `fix` doesn't reach one of the five places task 4 names; Bricks 2.4.2
is found to pick Google families another way than 2.2; a paste of an older capture changes by one byte.

## Limits and follow-ups (recorded, not built)

- The words of a failed face are still measured with Google's copy in the capture (R10), so the capture's boxes for
  them are the intended font's; the paste copies the site's CSS, not those boxes.
- One file per face: a page whose words need two unicode-range files of one face (Latin and Cyrillic) keeps the last
  loaded one. A suspicion until a real scan shows it.
- A family the site loads from Google gets all of Google's weights from Bricks, also ones the site didn't load.
- A font on another address that sends no CORS header loads for the scan's download but not for visitors: the paste
  carries it and draws it.
- The panel's website route and WordPress's Font Library are unchanged.

## Docs & records

HANDOFF: one section "site-fonts-match" (what changed, the table above in short, Q1's ruling, the limits, the live
paste check) and that check at the top of the End-of-run list; the ledger in
`.superpowers/sdd/site-fonts-match/progress.md`.
