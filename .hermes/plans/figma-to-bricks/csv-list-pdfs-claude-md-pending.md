# csv-list-pdfs — CLAUDE.md edits pending after build 2026-10-21.16

Merged and pushed: `96c6824` (Build 2026-10-21.16: PDFs for CSV lists). Paste check **3ap** owed.

**No CLAUDE.md edits landed.** When this was written, CLAUDE.md still said `.12` and the google-font-hardening (.13),
photo-hover-glass (.14) and text-link-followups (.15) pending files were not applied yet. Patching ahead of them would
have put things out of order, so nothing was attempted. Apply this file **after** those three, re-read the anchors first,
and apply the current-build line LAST. Never roll a newer build or check back.

## 1. Start here: new feature bullet

Insert it before the first existing feature bullet after Checks, above text-link-followups' .15 entry:

```md
- **PDFs for CSV lists (21.16, csv-list-pdfs):** after a list's CSV is saved, the Lists box asks for its PDFs. The
  plugin finds the list's own button itself (Buttons or centred boxes drawn as one, outside rows/pills/search/count;
  the only one, else the one whose words offer a file) and the rows' button (an action, never a data cell: words the
  same on every drawn row and in no CSV cell; download words first, else the last). Picked PDFs upload as
  `<name>-pdf.pdf` (explicit slug, own cache record `pdf <site>`, re-checked against Media, cleared with the image
  cache), are saved in `f2b-lists` (`files`/`buttons`), and the next Convert links them (`link {type:"external"}`).
  Rows match through a file-name column, else by name; with no uploads, a CSV column of **document** addresses links
  rows (4A). Pictures, videos, attachment IDs and web pages never do. Unmatched rows lose the button (3A). With nothing
  picked, saved CSVs convert byte-identically to before (proved on Services Page Final and all 5 corpus files). Fresh
  opus xhigh review: F1/F2 HIGH + F3–F9 fixed test-first. Check 1657 + 6 performance, browser 159/159. HANDOFF "PDFs
  for a list's download links"; paste check **3ap** owed.
```

## 2. Where things stand → Known open bugs and limits → Lists

Below the `- **Deferred minors:** the panel's empty list name, …` sub-bullet (two lines), add:

```md
  - **PDFs (21.16):** no Cancel for a long PDF upload; the PDF pickers read "WordPress connected" when the Lists box is
    drawn (connect, then Convert again). Download-icon tie-breaker not built. No `reference/bricks/` sample for
    `link.type:"external"` (reused from typed links).
```

## 3. Decisions the user made: the Lists entry

After the `- **Lists a visitor searches and filters** (user, 2026-10-19)` bullet, add:

```md
- **PDFs for a list's download links** (user, 2026-10-21: 1A 2A 3A 4A 5A 6A, "the plugin should find the download
  button"): both the rows' button and the list's own button get PDFs; a file-name column first, else the closest
  name, leftovers named; a row with no PDF loses its button; without WordPress, a CSV column of PDF addresses still
  links; "Add PDFs" appears after the CSV is saved; uploads are named `<name>-pdf.pdf`. Rulings **not yet confirmed by
  Justin**:
  - among a row's buttons, the one whose words offer a file, else the last;
  - an address column links only when it holds document addresses (a Website or Photo column never does);
  - a lone list button is the one the PDF goes on, whatever its words (the panel says "the list's button “…”");
  - PDFs stay saved when the spreadsheet is removed ("Remove PDFs" clears them; WordPress files are never deleted);
  - a file column must name more than half the picked PDFs; picking row PDFs again replaces the set;
  - a PDF picked for a button replaces its Figma link.
```

## 4. Current build line (LAST)

Replace `**Current build `2026-10-21.<N>`.**` (whatever the earlier pending files left, at most .15) with:

```md
**Current build `2026-10-21.16`.**
```
