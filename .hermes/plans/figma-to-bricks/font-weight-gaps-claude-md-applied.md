# Pending CLAUDE.md edits: font-weight-gaps (build 2026-10-21.3)

The write to `~/Documents/FigmaToBricksV2/CLAUDE.md` was blocked (protected file). Apply these by hand or allow the
write. Re-read the file first: another session may have edited it.

## 1. "Start here": replace the build line

Old:

```
**Current build `2026-10-21.2`.**
```

New (the line, then this entry right under it):

```
**Current build `2026-10-21.3`.**
- **Font weights (21.3, font-weight-gaps):** the user: the header's "SCHEDULE NOW" shows in Times; Saira Condensed
  Thin / ExtraLight went up as 250 / 275.
  - **The cause:** the paste's site `@font-face` lines wrote a variable face as `font-weight: 100 900`; Bricks copies
    every weight beside a Google font into its one Google Fonts link, and Google answers a link holding a range with
    400, so every Google font Bricks loads on the page (header, footer, Theme Style) was lost. `sfnt.ts` took a
    file's OS/2 250 / 275 as they are.
  - **What it does (panel only, `src/core` untouched, corpus pastes byte-identical):** a variable face gets one
    single-weight rule per design weight; weights uploaded or read from the site are whole hundreds (an in-between
    weight takes its style name's, else the nearest hundred, a tie toward 400; a site face stored so with no weight
    word in its file name is left out, and Google fills it).
  - Self-reviewed by the finisher (8 mutations, two tests added). Re-paste the 8 pages (covers 21.1 too) after the
    header button's weight is set to 600 in Bricks. HANDOFF "Weight ranges broke Bricks' Google Fonts link"; paste
    check 3af owed.
```

Also in "Checks:" just below: `npm run check` 1284 → **1298** pass (browser still 131 of 134, the same three).

## 2. "Where things stand" → "Fonts dropped on the panel" → "My rulings, not yet confirmed"

Old:

```
    - every face of a used family goes in the CSS;
```

New:

```
    - every static face of a used family goes in the CSS; a variable face once per design weight of its slant
      (21.3: never a weight range);
```

And add after that entry's "Deferred minors" bullet (before "Not yet tried by the user (3x)."):

```
  - **Font weights** (build `2026-10-21.3`, branch `worktree-font-weight-gaps`, HANDOFF "Weight ranges broke Bricks'
    Google Fonts link; font weights read as standard"; plan and ledger `docs/plans/2026-10-21-font-weight-gaps*`):
    - `src/ui/font-weight.ts` (new) `standardWeight` / `namedWeight`; `sfnt.ts` `readFontInfo` returns the standard
      weight; `site-fonts.ts` `faceOf` reads a stored in-between weight from the file name (`font-files.ts`
      `nameParts`, WordPress's `-<n>` ignored unless a weight) or leaves the face out; `normal`/`bold` → 400/700;
      `font-sources.ts` `siteFaceCss` never writes a range.
    - **My rulings, not yet confirmed:** a round OS/2 hundred wins over the style name; an in-between weight with no
      weight word → nearest hundred on upload (tie toward 400), left out when read from the site; OS/2 above 900 →
      900; "Regular"/"Normal"/"Book"/"Roman" say 400, "Italic" alone none; a weight Google lacks keeps today's note.
    - Paste check 3af owed (needs the header button's weight set to 600 in Bricks first).
```

## 3. "Working in this repo" → Bricks facts: new rules

```
- **Font weights in a paste are single whole hundreds.** Bricks copies every font weight it finds beside a Google font
  in the page, custom CSS included, into its one Google Fonts link (`bricks-google-fonts-css`). Google refuses the
  whole link (HTTP 400) for a range such as `100 900`, and every Google font Bricks loads on that page is lost
  (header, footer, Theme Style). Never write a weight range or a non-number weight in a paste.
- **Font weights the plugin uploads or reads are standard hundreds (100…900).** A file's in-between OS/2 weight
  (a Thin at 250) gives way to its style name.
```
