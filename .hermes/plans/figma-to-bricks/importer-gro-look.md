# importer-gro-look: the importer app's page in GRO's look (Justin's quick job, 2026-11-16)

**Playback.** Justin: "fix the UI of this page? Make it more for like Gro based and nicer and all", "literally no need
for pipeline just plan and build", "Read growithgro.com". The page is `npm run importer`'s own page
(`tools/lib/importer-app/page/`). It works; it looks plain. Make it GRO's: its navy, steel blue and rose, its wordmark,
its rounded cards and strong buttons, clean and modern, while nothing it does changes.

**Brand** (read once from growithgro.com, saved in
`~/.hermes/plans/figma-to-bricks/evidence/importer-gro-look/brand.txt`): navy `#0d1a24`→`#32475b`, steel blue
`#7195b4` (hover `#5f82a1`), rose `#b17873`, salmon `#ef9993`, dark rose `#835551`, cream `#f5efe6`/`#fffbf8`; Inter
for body and buttons; the "GRO" wordmark is an inline SVG on the site.

## What changes

1. `index.html`: the header bar gets the GRO wordmark as an inline `<svg>` (`aria-hidden`, a `<title>`-free decoration;
   the `<h1>` keeps its words "Figma to Bricks: website importer", shown as a small brand line and the title). No new
   control, id, label, script, inline style or style block; every control in the same order.
2. `app.css`: rewritten on GRO tokens. Navy gradient header with the cream wordmark; a cream page; each step a white
   card (radius 16 px, a steel-blue hairline and soft blue shadow) with its number in a navy badge and an uppercase
   eyebrow-style title; navy primary buttons (8 px radius, blue-tinted shadow, hover lift off under reduced motion);
   white secondary buttons with a navy outline; disabled buttons flat grey with a dashed border and full-strength
   (not faded) words, the reason line under them unchanged and readable; inputs 8 px radius with a 3:1 border; a 3 px
   focus ring (navy on light, cream on the header) on every control; the selected saved scan tinted steel blue with a
   navy edge; the facts as chips; the preview in a framed card; the notes in a card; the job panel a card with the
   banner in GRO's gold and the question box rose-edged. Dark scheme: the same tokens on the navy ramp (cheap: tokens
   only). Layout: left column 19–25 rem beside the preview, one column below 900 px (as before); works 1024–1920.
3. `views.ts`/`main.ts`: nothing unless a class the look needs (none planned).

**Not changed:** every control, id, label, step order, button state, prompt, request; the server, guard (CSP
`SHELL_CSP` byte for byte), commands, uploads, preview child, pastes. No font file, no remote file, no new page file.

## Acceptance criteria

- AC1: the page reads as GRO: the header bar is GRO's navy with its cream "GRO" wordmark (the site's own SVG paths), the
  primary buttons are GRO navy, cards and badges use the brand colours of brand.txt. Test: before/after screenshots at
  1440 and 1024 (`before-*.png`, `after-*.png` in the evidence folder), with a scan picked and section 3 filled; and a
  check that index.html holds the wordmark paths and app.css only brand-token colours.
- AC2: nothing it does changes: `git diff` touches only `page/index.html` and `page/app.css` (plus the evidence); every
  id, `for`, `aria-*`, control and its order in index.html is unchanged (a script compares the old and new id/label
  lists); `test/unit/importer-app-*` and `test/web/importer-app-*` all pass.
- AC3: the CSP is unchanged: `guard.ts` untouched; the shell still has one script, no inline style or handler, no style
  block (`importer-app-page-sources.test.ts`), and the page loads no remote or font file (no `url(` / `@import` /
  `@font-face` in app.css).
- AC4: contrast and focus stay AA: `test/web/importer-app-page.test.ts` passes (every text 4.5:1, 3:1 large, in light
  and dark at 1280 and 600; every Tab stop with a visible ring in order; nothing sideways), plus the same page at 1024
  and 1920 has no sideways scroll.
- AC5: `npm run check` green.

## Decisions (no questions to Justin)

- D1: the primary button is navy `#32475b`, not GRO's steel-blue CTA: white on steel blue is 3.15:1, under AA for
  15 px words. Steel blue stays for borders, glows and the selected scan.
- D2: no GRO font file: the page's CSP has no font source and must not be loosened; Inter by name then the system stack.
- D3: dark scheme kept (the AC18 page test checks it) on the navy ramp.
