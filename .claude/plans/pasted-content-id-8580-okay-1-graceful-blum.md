# Searchable, filterable lists from Figma + a spreadsheet (milestone)

## Context

The user's "Reman cylinders, on the shelf" section is drawn in Figma as:
- a search box ("Search model, cylinder or serial #…");
- filter pills (All, Dozers, Haul Trucks, Loaders, Graders, Excavators), "All" drawn chosen;
- a table header and 6 drawn rows (Model + type, Cylinder group, Brand, Serial number);
- "78 of 78 cylinders shown";
- a "Download full inventory (PDF)" button.

They want it working on the site:
- typing searches the rows;
- a pill shows only that equipment type;
- the count follows;
- the PDF downloads;
- **all** ~78 cylinders from the client's parts sheet appear, not just the 6 drawn.

**User decisions (2026-10-19):**
- **"In the page":** the plugin pastes every row plus a small script. There's no WordPress post type.
- **"Spreadsheet in the panel":** a CSV given in the plugin panel fills the drawn row, one row per line.

The plugin already ships behaviour this way: the card arrows are a Code element whose script finds its parts by class
(`emit/arrows.ts`, `understand/arrows.ts`, `reference/bricks/code-element.json`; Bricks signs pasted code).

**Blocker found:** `figma-to-bricks-debug-page-1.json` (build .3) holds only one stat card ("div.dstat", 368 wide). The
user must re-save it with the whole inventory section (or page frame) selected. Recognition is tuned and verified
against that file.

## How it works (general, never keyed on this file's words or names)

**1. Recognising a filterable list** (`src/core/understand/lists.ts`, new): in one section or box, all three of:
- **rows:** 2+ repeated rows of the same shape (same layer kinds and order, same column x positions within ±2px), one
  under another, holding texts;
- **filter pills:** a row of 2+ pill boxes with one short label each. The one drawn unlike the others (odd one out, as
  `style/form.ts` `chosenOf` does for choices) is the active one;
- **search box:** a field-shaped box (outlined or painted, one text at its left, as `understand/form.ts` `textBox`),
  usually with an icon. It is not part of a recognised form (it has no label and no button).
- **Optional count:** a text in the list holding two equal numbers ("78 of 78 …"). The script rewrites them: shown,
  total.
- A list missing the pills or the search box still works with what it has. Rows alone, with no pills and no search, are
  a plain table (unchanged).

**2. The data** (the panel; saved in the Figma file, so debug files and replay carry it):
- After Convert, the panel lists each recognised list: "Inventory list: 6 rows drawn — Add spreadsheet".
- The user picks a CSV (Excel/Sheets → Save as CSV; no runtime dependencies, so no .xlsx).
- `src/ui/lists.ts` (new, DOM-free) parses it: quotes, commas or semicolons, UTF-8 BOM, a header line.
- The plugin side saves it as document plugin data `f2b-lists` keyed by the list's layer id. This mirrors
  `plugin/alts.ts` `saveAlts`, `extract/dump.ts` `ALTS_KEY` and `Snapshot.alts`, giving `Snapshot.lists` (raw JSON,
  optional: older files convert as before).
- **Column binding:** the first drawn row is the template. Each of its texts is bound to the CSV column whose value
  matches it in some data row (case-insensitive). The drawn row's own words come from the data, so the binding needs no
  header names. Fallback: header names close to the drawn table header, then column order. The panel shows the binding
  ("D8R → Model, Dozer → Type …") and warns about unbound columns.
- **Rows:** understand makes one copy of the template row per data line (`copy:list:<template key>:<i>`, as phone copies
  are made at understand). Each text gets that line's value; the drawn rows are replaced.

**3. The behaviour** (`src/core/emit/lists.ts`, new; one Code element per page, like `arrowScript`, naming no element
ids):
- **Search:** the script puts a real `<input type="search">` into the search box. It takes the drawn placeholder words
  and inherits the drawn font and colour, and the drawn text is hidden. Each row shows when its text contains the query
  (case-insensitive).
- **Pills:**
  - A pill shows the rows with a cell equal to its label, ignoring case and a plural "s"/"es" ("Dozers" ↔ "Dozer").
  - A pill matching no row's cell shows all rows ("All").
  - Search and pill combine.
  - Pills become keyboard buttons with `aria-pressed`.
  - The active look comes from the pill drawn chosen, via the purpose classes `list-pill` and `list-pill.is-active`
    that the style stage makes, so per-element settings don't fight it.
- **Count:** the count text's two numbers become shown and total.
- **Classes** (style stage, purpose-named like `strip-arrows`): `list`, `list-search`, `list-pill`, `list-row`,
  `list-count`.
- **Long lists:** if Figma draws the rows box clipped at a fixed height with vertical prototype scrolling
  (`overflowDirection` VERTICAL), it keeps its drawn height and scrolls (`overflow-y: auto`). Otherwise every row shows.
  This adds `scrollsY` beside `scrollsX` in `normalise.ts`; only if the real file needs it.
- **Download button:** already supported. The designer sets Figma "Open link" to the PDF's address in the WordPress
  media library (`normalise/links.ts` `safeUrl`), or sets the link in Bricks after pasting. Nothing new.
- **Phones:** rows stack as other rows do (the adapt rules). Pills wrap. Check at 390/768.

**4. The client's data (prepared by me):**
- `corpus`-style CSV from the parts sheet, with columns Model, Type, Cylinder group, Brand, Serial number.
- **Type** from the model family: D… Dozer; 740/773/775/777/785/789 Haul truck; 980/988/992 Loader; 16G/16H Grader;
  EX-… Excavator.
- **Brand:** Caterpillar, except EX → Hitachi. These two rulings are to be confirmed by the user.
- The screenshot cuts some D11R rows (hidden by the accessibility button), so I need the original PDF to transcribe
  exactly. The same PDF is the "Download full inventory" file.

## Files

- New: `src/core/understand/lists.ts`, `src/core/style/lists.ts` (classes, active look), `src/core/emit/lists.ts`
  (script), `src/ui/lists.ts` (CSV parse, binding preview), `src/plugin/lists.ts` (save to file data).
- Changed:
  - `src/core/snapshot/schema.ts` (`lists?`);
  - `src/plugin/extract/dump.ts` (`LISTS_KEY`);
  - `src/core/understand/ir.ts` (`IRNode.list` part marker);
  - `src/core/understand/understand.ts` (run after forms, before phone copies);
  - `src/core/emit/elements.ts` (script element);
  - `src/ui/main.ts` and `src/ui/index.html` (list rows + file picker);
  - `src/plugin/main.ts` (`saveList` message);
  - `src/shared/build.ts`.
- Reuse:
  - `understand/form.ts` (`textBox`, `pillBox` via `widgets.ts`);
  - `style/form.ts` odd-one-out idea;
  - `emit/arrows.ts` script pattern;
  - `understand/arrows.ts` script IR (`phoneBox` … `role: "script"`);
  - `plugin/alts.ts` file-data pattern.

## Process (CLAUDE.md milestone)

1. Plan doc `docs/plans/2026-10-19-lists.md` (writing-plans), ledger, backup, `npm run corpus` before.
2. Test first.
3. Opus review, one fix pass.
4. HANDOFF section + paste check, CLAUDE.md decision ("lists in the page, data from a panel spreadsheet").
5. Build `2026-10-19.4`.

## Verification

- **Unit, on generic fixtures** (a section with search box, 5 pills, 3 repeated rows, count text; plus variants:
  - no pills;
  - no search;
  - rows alone;
  - a form's text box isn't a search box):
  - recognition;
  - binding;
  - copies from a 10-line CSV;
  - class names;
  - script text;
  - deterministic ids;
  - CSV parsing (quotes, semicolons, BOM).
- **Browser** (`test/browser/lists.test.ts`):
  - typing "9T" leaves the matching rows;
  - "Dozers" leaves only Dozer rows;
  - search + pill combine;
  - the count reads "n of 10";
  - keyboard Enter on a pill works;
  - no element ids in the script.
- **The user's re-saved file:** replay + snap at 1440/1024/768/390 with the CSV. All 78 rows, the pills and search
  working in Chrome, the count right, the layout matching Figma at the design width.
- **`npm run check`, browser suite, corpus:** pastes byte-identical (no lists in the corpus).
- **Paste check for the user:** paste, sign the code (Bricks → Settings → Custom code → Regenerate code signatures),
  save, then try search, pills, count and download.

## Needs from the user

1. The inventory section's debug file, saved with the whole section or page selected.
2. The parts list PDF (to transcribe exactly, and to upload as the download).
3. Confirm the Type and Brand rulings above.
