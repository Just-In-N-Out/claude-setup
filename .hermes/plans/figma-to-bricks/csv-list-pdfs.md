# CSV list PDFs (csv-list-pdfs) — plan for approval

**Approved by Justin 2026-10-21** ("go" = plan + all ⭐: 1A 2A 3A 4A 5A 6A, plus his note below).

Planner: Hermes subagent, `figma-to-bricks` skill in the PLANNER role (rules summary first, then only the CLAUDE.md
sections I needed). No worktree, code or commit made. Base: `main` at build `2026-10-21.12`.
Builder: Opus 5.5 medium (Justin's pick). Reviewer: Opus xhigh. Size: medium, not a cross-pipeline job. It touches
the panel (`src/ui/`) and the list part of `understand/`. emit, adapt and style stay as they are.

## Questions (plan below is written as if every ⭐ is chosen)

**1. Which "Download PDF" links get PDFs?**
- A ⭐ Both: each row's button, and the list's own button
- B Only a button inside each row
- C Only the list's one download button

Why: your real list ("Services Page Final", the parts inventory) has **no button in its rows**. It has one
"Download Full Inventory (PDF)" button under the table. With B alone, your page would get nothing.

**2. How does a row find its PDF?**
- A ⭐ A file-name column first, else the closest name; leftovers named
- B By order: 1st PDF → 1st row
- C Only through a file-name column in the CSV

**3. A row that got no PDF, when other rows did:**
- A ⭐ Leave its download button out on that row
- B Keep the button there, linking nowhere
- C Keep the button, linked to the list's PDF

**4. No WordPress connected:**
- A ⭐ PDF picker greyed out with a note; a CSV column of PDF addresses still works
- B PDF picker greyed out with a note, nothing else
- C Hide PDFs entirely until WordPress is connected

**5. When the panel asks for the PDFs:**
- A ⭐ An "Add PDFs" button shows up after the CSV is saved, with a prompt
- B One picker that takes the CSV and its PDFs together

**6. The PDF's name on WordPress:**
- A ⭐ Its own name plus "-pdf" (e.g. `d8r-sheet-pdf.pdf`), like pictures' "-image"
- B Exactly its own name

Why A: WordPress gives a file nobody attached the address `/<its name>/`, and since WordPress 6.4 that address
opens the file. A PDF named like a page would then take over that page's address. Pictures already get "-image"
for the same reason (rules L1A/L2A).

## Request played back

1. When the panel fills a list from a CSV someone uploads, it should also ask for the PDFs that go with the list.
2. The panel uploads those PDFs to the WordPress media library.
3. On the pasted page, each "Download PDF" link opens its own PDF: one per row, and the list's own download button
   opens its PDF.
4. A row with no PDF is never a dead link, and the panel names which rows and PDFs didn't match.

## What exists today (checked, not guessed)

- **Lists** (build 19.4, HANDOFF "Searchable lists from a spreadsheet"; plan `docs/plans/2026-10-19-lists.md`):
  - `understand/lists.ts` (250 lines) finds rows, pills, search box and count from structure, then calls `rowsFrom`.
  - `understand/list-rows.ts` copies the first drawn row once per CSV line and binds each word to a column. A column
    no word is bound to is "Not shown".
  - The CSV is parsed in the panel (`ui/lists.ts` `parseCsv`) and saved in the Figma file as plugin data `f2b-lists`
    (`plugin/lists.ts`), keyed by the layer id of the rows' box. The next Convert reads it (`normalise/lists.ts`
    `ListData {columns, rows}`), so replay and debug files carry it.
  - Panel: `ui/main.ts` `showLists` (lines 138–176) shows one item per list, with a CSV picker (`accept .csv`) and
    Add / Replace / Remove. After saving, the status says "Click Convert again".
- **Download links today: none are filled.**
  - The lists ledger (`docs/plans/2026-10-19-lists-ledger.md:127`) says: "Download button: no code … no link (the user
    links the PDF)".
  - HANDOFF: "Set Figma's Open link to the PDF's address in the media library, or set the link in Bricks."
  - So the CSV has no file or link column, and nothing ever uploads a PDF.
- **Your real page** (git's debug file, build 19.4, "Services Page Final"):
  - Rows box `528:3344` is `tbody#inv-body`, 78 rows. Each row is an instance holding only cells: model, type,
    group, brand, serial. There is no button in a row.
  - There is one button, "Download Full Inventory (PDF)" (`Component 6`, in `panel > div.panel__foot`). It sits
    inside the same `panel` that holds the pills, which is the list's root, and it has no link.
  - The root debug file (now "Hydraulic Cylinder Repairs Final", build 20.6) still carries that list's saved CSV
    (`lists["528:3344"]`, file-wide data). Read only.
- **Links:**
  - `emit/elements.ts:106-108` turns any `ir.link` into `settings.link = {type:"external", url}`; a Div or Block
    gets the tag `a`.
  - `normalise/links.ts:20-21`: documents (PDF) are allowed as links; pictures and videos aren't.
  - `site-pages` never rewrites a typed link ("a link typed in Figma never does").
  - So if the right IR node gets `link = <pdf url>`, **emit doesn't change**, and no new Bricks key is needed.
- **Uploads:**
  - `ui/wordpress.ts` `uploadMedia(wp, {blob, mime}, filename, alt, ms)` already sends an explicit slug (the
    filename's stem) and any MIME type.
  - `ui/files.ts` `fingerprint` (same bytes, same upload) and `safeFilename` (adds "-image").
  - The videos lookup is the pattern to copy: the panel finds things, saves them in the file, then converts again
    (`saveVideosInFile`, `finish` in `ui/main.ts`).

## Approach (as if all ⭐)

**Data.** `ListData` gets two optional fields, saved in `f2b-lists` with the CSV. Old saves still parse.
- `files?: ListFile[]`, the PDFs given for the rows: `{ name, url, id }`.
  - `name` is the file name as picked (used for matching).
  - `url` is WordPress's `source_url`; `id` is the media ID.
- `buttons?: Record<string, ListFile>`: the PDF given for each list button outside the rows, keyed by that button's
  layer id.
- Keeping matching out of the saved data means a replaced CSV re-matches the same PDFs. The core stays pure: it
  only reads addresses, and replay equals convert byte for byte.

**Where the links go, found from structure only (no words, no layer names):**
- **Row target:** the template row's Button, or its layer that already carries a link. If there are several, the
  last one (actions sit at the end; my ruling). The copies of the row inherit it as today.
- **List buttons:** each Button inside the list's root that isn't a row, a pill, the search box or the count. The
  panel names each one by its words, and you pick a PDF for it yourself, so the plugin never guesses which button is
  "the download". The same rule covers a "Request a quote" button: it simply gets no PDF unless you give it one.

**Matching rows to PDFs** (new `understand/list-files.ts`, pure, also imported by the panel for its preview):
1. **File-name column:** a column whose cells, with ".pdf" taken off, equal an uploaded file's name (case, spaces,
   punctuation and the "-pdf" suffix ignored) on the most rows, at least one. Matched through that column; one
   PDF may serve many rows.
2. **Else the closest name:** a PDF matches the one row whose cell (folded to a slug) appears as a whole run of
   words in the PDF's name. Example: `d8r-bladelift.pdf` goes to the row whose cells are D8R and Bladelift; the row
   matching most cells wins. A tie, or none, leaves it unmatched. Each PDF goes to one row.
3. **Not matched:** unmatched rows and unused PDFs are listed in the panel and in the conversion notes.
4. **Q4A:** a column whose every filled cell is a web address is used as the row's link instead (it works without
   WordPress). It's shown in the panel as "→ link" rather than "Not shown".

**In the row copies** (`list-rows.ts`): a copy whose row has a PDF gets `link = url` on its target. On a copy with
no PDF, the target is left out (Q3A), but only once the list has at least one PDF. With no PDFs at all, the output
stays byte-identical to today. A list button with a saved PDF gets `link = url`.

**Panel** (new `ui/list-files.ts`; `ui/main.ts` is already 574 lines, so only the wiring goes there):
- `ListInfo` gains:
  - `target`: the row button's words, or null;
  - `buttons: {id, words, file}[]`;
  - `pdfs`: matched, unmatched rows, unused files, and how they were matched.
- After a CSV is saved for a list that has a row target or list buttons, the status asks: "This list has download
  buttons: add their PDFs." The list item shows:
  - "Add PDFs for the rows (n of m matched)": a multi-file picker, `accept .pdf,application/pdf`;
  - per list button, "Add PDF for “<its words>”", with Replace and Remove.
  - A file picker can't be opened by itself after the save finishes, because the browser no longer counts the click.
- **Upload on pick** (`ui/pdf-upload.ts`):
  - check the `%PDF-` file signature (anything else is refused and named);
  - name: safe stem + "-pdf.pdf", with the explicit slug, through `uploadMedia`, time limit scaled to the file size;
  - same bytes go up once, cached by fingerprint per site in its own record, so the picture repairs that move media
    off page addresses never treat PDFs as pictures;
  - the run owns the panel: a cancelled pick or a replaced list changes no status;
  - then `saveList` with `files`/`buttons` added, then "Convert again" as today.
- **No WordPress connected** (Q4A): the PDF buttons are greyed out with "Connect WordPress to upload PDFs. A CSV
  column of PDF addresses works without it."
- **Remove spreadsheet** keeps the saved PDFs (they still match when a new CSV comes). "Remove PDFs" clears them.
  Files on WordPress are never deleted.

**Bricks side:** no new setting. The link uses the existing `link: {type:"external", url}` that `emit/elements.ts`
already pastes for typed links. There's no `newTab` (that key is unverified in `reference/bricks/`).
`assertPayload` must accept a direct PDF address (the link-upload-fixes rule); a test pins that.

## Tasks (test first; generic fixtures: made-up rows like "Alpha/Beta", made-up PDFs; no names from Justin's file)

0. **Baseline:**
   - `npm run check`;
   - `npm run corpus`, saving the report, `report-v2.json` and the `corpus/out/v2/*/bricks.json` copies;
   - replay a scratch copy of git's debug file and of the root one; keep both pastes.
   - Ledger at `.superpowers/sdd/csv-list-pdfs/progress.md`.
1. **Data** (`normalise/lists.ts`): parse `files`/`buttons` (malformed entries left out; old saves unchanged;
   non-http addresses refused through `safeUrl`). Tests in `normalise-lists`. `plugin/lists.ts`: round trip with
   the new fields, and the 100 kB size error unchanged.
2. **Matching** (`understand/list-files.ts`), tests `understand-list-files`:
   - file-name column;
   - closest name;
   - tie → unmatched;
   - one PDF for several rows through a column;
   - "-pdf" suffix and case ignored;
   - a URL column;
   - no PDFs → nothing.
3. **Targets and links** (`understand/lists.ts` and `list-rows.ts`, both kept under about 300 lines), tests in
   `understand-lists`:
   - a row with one Button → each copy links its own PDF;
   - two Buttons → the last;
   - a row with no Button → no row target, with a note;
   - unmatched copies drop the target (Q3A);
   - the list button outside the rows gets its PDF; pills, search and count never count as list buttons;
   - with no PDFs saved, the IR equals today's (a regression guard).
   - Prove each test fails with its fix reverted.
4. **Notes and ListInfo:** unmatched rows and unused PDFs named once per list, worded as the other conversion notes
   are. Tests: `ui-lists` (`listLines` shows the PDF line, the URL column "→ link", list buttons).
5. **Upload** (`ui/pdf-upload.ts`, `ui/files.ts` `safeDocumentName`), tests:
   - the signature check;
   - name and slug (`-pdf`, never a page's address);
   - MIME `application/pdf`;
   - dedupe by fingerprint;
   - a separate cache record (the media-repair code ignores it; tested against `site-media`);
   - a cancel or replacement mid-upload leaves no stale status (ownership checked after every await);
   - WordPress refusals (type not allowed, too large) named in plain words.
   - All against WordPress stand-ins built from WordPress's real answers.
6. **Panel wiring** (`ui/main.ts`, `ui/list-files.ts`, `shared/messages.ts`): browser test `test/browser/lists`:
   - the prompt appears after a CSV for a list with buttons;
   - greyed out with no WordPress;
   - picking 3 PDFs uploads them and saves `files`;
   - the per-button picker;
   - Remove PDFs.
7. **Emit/guard:** test that a row copy's PDF link emits `{type:"external", url}` and `tag:"a"` on a Div, and that
   `assertPayload` passes. Browser `lists` test: on the replayed page each row's `<a href>` is its own PDF, and
   search and pills still filter the linked rows.
8. **Proof** (no look change, so text proof instead of pictures): a scratch script replays git's debug file with a
   saved `buttons` entry for "Download Full Inventory (PDF)" and a made-up `files` set. It prints old build vs new
   build: each row → href, and the button → href. With nothing saved, the paste is byte-identical (`cmp`).
9. **Close:**
   - `npm run check`, `npm run test:browser`, `npm run corpus`;
   - the five corpus pastes byte-identical (no corpus file has saved PDFs), lint and the "Worse than v1" list
     unchanged;
   - fresh Opus xhigh review, then one fix pass.
10. **Docs & records:**
    - plan copied to `docs/plans/2026-10-21-csv-list-pdfs.md`;
    - ledger moved to `docs/plans/2026-10-21-csv-list-pdfs-ledger.md`;
    - `docs/HANDOFF.md`: new section "PDFs for a list's download links". It covers the rulings to confirm (last
      Button is the row target; PDFs kept when the CSV is removed). The paste check owed, at the next free number
      (3al or later; renumber at merge if taken): in the Lists box, add the inventory PDF to "Download Full
      Inventory (PDF)", Convert, paste, Regenerate code signatures, then click the button on the live page;
    - `BUILD` bumped at the merge (finisher);
    - main `CLAUDE.md` "Start here" and "Where things stand → Lists" updated after the merge (finisher, Step 4
      item 6; a pending file if the write is denied);
    - new `CLAUDE.md` rule: "PDF uploads end in -pdf with an explicit slug, kept in their own cache record; a list's
      download targets come from structure (the row's last Button, list Buttons outside rows/pills/search/count),
      never words." Plus the user decision lines for Q1–Q6 in the rules summary.

## Risks

- **The row target picks the wrong layer:** a row with two Buttons (e.g. "Quote" and "PDF") links the last one.
  The panel shows which words get the PDF, so it's visible before pasting. My ruling, to confirm.
- **Name matching can mismatch near-identical names** (D9R vs D9R-2). Ties stay unmatched and are named, never
  guessed. A file-name column is exact.
- **Large PDFs:** the upload time limit is scaled by size. A Hostinger/WordPress upload limit or a blocked MIME type
  comes back as a plain, named refusal. Nothing is retried blindly.
- **Figma file storage:** `f2b-lists` is capped at about 100 kB. 78 rows' addresses add about 8–10 kB. The
  existing size error stays.
- **The media repair must never move a PDF** (separate cache record). Test pinned.
- **Leaving out a button on unmatched rows** (Q3A) changes those rows' height on phones' cards. The list scripts
  find rows by class, so filtering is unaffected.
- **No `reference/bricks/` sample for `link.type:"external"`.** It is what emit pastes today, so it's unchanged.
  See found_else.

## Files and pipeline parts touched

- normalise: `src/core/normalise/lists.ts`
- understand: `src/core/understand/lists.ts`, `list-rows.ts`, new `list-files.ts`
- panel: `src/ui/lists.ts`, `src/ui/main.ts` (wiring only), new `src/ui/list-files.ts`, new `src/ui/pdf-upload.ts`,
  `src/ui/files.ts`, possibly `src/ui/wordpress.ts` (time limit only)
- shared: `src/shared/messages.ts` (`ListInfo` fields, save message carries files)
- plugin: `src/plugin/lists.ts` (types only)
- tests: `test/*lists*`, new `test/understand-list-files.test.ts`, `test/ui-pdf-upload.test.ts`,
  `test/browser/lists.test.ts`
- Not touched: emit (beyond a test), adapt, style.

## Overlaps and build order

- **text-link-followups** (Sol): touches `emit/elements.ts` and `ui/site-pages.ts`. This plan reads `elements.ts`
  but doesn't edit it, and doesn't touch `site-pages`. It can run in parallel; rebase picks up any change to how
  `link` is emitted.
- **card-link-words** (`normalise/label-links.ts`): no file overlap. Its whole-card link rules don't apply to list
  rows. Parallel.
- **layout-floors** (adapt), **google-font-hardening** (`ui/fonts.ts`), **photo-hover-glass**
  (showcases/style): no overlap. Parallel.
- **Shared hot file:** `ui/main.ts` is edited by panel features. Keep this feature's edit to a few wiring lines.

## Justin's answers (2026-10-21)
- **go** = all ⭐ (1A 2A 3A 4A 5A 6A).
- His note: "on Figma there should be a download button that should be linked to the pdf the plugin should find the download button". Reading: the plugin must **find the list's download button in the Figma design on its own** (e.g. "Download Full Inventory (PDF)" under the parts table) and link it to the PDF the user picks; the user shouldn't have to point at the layer. The panel names the button it found ("PDF for: Download Full Inventory (PDF)") so he can see it's the right one. Detect from structure (a Button/pill inside the list's section, outside the rows) plus the project's existing English lexical-recognition convention for a download/PDF label or a download icon as a tie-breaker; never key on his exact words or layer names. When none or several plausible buttons are found, say so in the panel and let him pick.
