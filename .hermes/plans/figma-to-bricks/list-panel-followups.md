# list-panel-followups — plan (PLANNER, round 3 section D)

Base inspected: `main` 9f9b751 (BUILD 2026-10-21.19), read only. No worktree, code, commit, build or site write.
Builder: Opus 5.5 medium. Reviewer: Opus xhigh (fresh). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/list-panel-followups/`.

## Approved under Justin's away auto-go (2026-10-21 ~16:38 EDT)

**Q1A Q2A Q3A Q4A Q5B Q6C Q7A (all ⭐).** Action labels stay; cooperative PDF cancel as described; truthful Remove statuses; add TSV reading/picker support; defer large-file threshold and multi-list policy; extract only Lists wiring from main.ts. TSV is a small new capability approved via recommended away answers, not an already-shipped bug fix. No network write-policy expansion; in-flight uploads can settle into their existing cache but must not alter a cancelled list/run. Start when a builder slot frees, respecting max-three builders; coordinate media-upload signature with collision batch before code.

## Questions (answered above; ⭐ = recommended)

**Q1. A row's action button and a spreadsheet column nobody drew (the leftover-column bug).**
- A ⭐ A Button, or a box drawn as one, whose words are the same on every drawn row and in no cell is an action. It keeps its words. The column it would have taken is listed under "Not shown". This is the same test the PDF row button already uses (`rowTarget`).
  - Cost: a badge drawn with identical sample words on every row ("Category") now stays as drawn instead of taking a column in order.
- B Fix only the PDF row button, which is what happens today. "Quote" keeps getting a column's value.
- C Leftover columns never fill anything that has no match. This reverses the tested "sample words take the columns in order" rule, so I don't recommend it.

**Q2. Cancel during a long PDF upload.**
- A ⭐ A Cancel button shows while PDFs upload. Clicking it:
  - stops the files not sent yet;
  - lets the one being sent finish in the background, remembered in the PDF cache for next time but not saved to the list;
  - frees Convert and the pickers straight away.
  
  If the same bytes are picked again, the plugin waits for the copy still being sent instead of sending it twice.
- B Abort the request being sent. It's faster, but WordPress may already have the file, which can leave an unknown or duplicate `-pdf-2` media item. That breaks the "never blindly retry an uncertain write" rule.
- C Keep it deferred.

**Q3. Wording after Remove / Remove PDFs.** Today Remove says "Saved … to see every row" and Remove PDFs says "PDFs saved … link them".
- A ⭐ Remove says "Spreadsheet taken out of this Figma file. Click Convert again to show the drawn rows." Add "Its PDFs are kept for the next spreadsheet." when it has some. Remove / Remove PDFs says "PDFs taken out of this Figma file. Click Convert again to unlink them." The buttons stay as they are until the next Convert.
- B Same as A, and the list's controls also swap to "Add spreadsheet" straight away (local state, more code).

**Q4. Tab-separated files (new capability, needs your approval).**
- A ⭐ Read tab as a third separator, using the same rule as semicolons: the header splits more ways by that character. The picker also accepts `.tsv`, `.txt` and `text/tab-separated-values`.
- B Defer.

**Q5. A warning for a very large CSV (new capability, needs a product number from you).**
- A Show a plain, non-blocking warning above N rows. You'd name N.
- B ⭐ Defer. Saving already refuses files over the ~100 kB Figma plugin-data limit with a message (`plugin/lists.ts saveList`). A warning threshold is a product decision I won't make up.

**Q6. Desktop and phone frames converted together give two lists with the same name, each needing its own CSV (multi-list policy).**
- A Panel-only: when two lists share a name, add the frame's name to each, e.g. "Parts card (Phone)". Each keeps its own CSV.
- B One CSV fills both lists when they have the same structure. This is a new data policy and its own feature.
- C ⭐ Defer both to a separate "multi-list" approval. A needs a frame field added to `ListInfo` through `designs.ts` pairing, and B is a policy change.

**Q7. `ui/main.ts` is 581 lines.**
- A ⭐ Stage 1 only, in this batch: move the Lists box wiring (`sendList` and `showLists`, main.ts:140–182) into a new `src/ui/list-box.ts`, with no output change. The new wiring for this batch goes there, which brings main to about 545 lines. Splitting out videos, fonts, alts and settings is a separate, later, approved feature, after B and E merge.
- B No extraction. The new wiring goes into main.ts, which grows.
- C Full split now. Not recommended: it collides with other planners and widens the scope.

## Playback
1. With a spreadsheet, a row's action button (for example "Quote") gets its words replaced by a spreadsheet column no drawn word matches. Since .16 only the PDF row button is protected, and only once PDFs are linked.
2. The PDF pickers decide "connected or not" once, when the Lists box is drawn. Connecting WordPress afterwards leaves them greyed out until you Convert again. A failed re-test or a changed site leaves them enabled, and they upload with whatever is now in the form.
3. A long PDF upload can't be cancelled, and Convert stays blocked until it finishes.
4. After Remove / Remove PDFs the status claims something was saved.
5. Leftover list minors: empty name (already fixed, dropped), two same-named lists (Q6), no large-CSV warning (Q5), TSV (Q4).
6. main.ts size: narrow, staged extraction only (Q7).

Kept as they are:
- .16: actions are never data cells, and no data cell is dropped;
- .18: native PDF links use `newTab:true, rel:"noopener"`, inline links `_blank`;
- nothing picked, or a CSV alone, gives a byte-identical paste;
- the PDF cache stays separate from the picture cache, and cache permissions don't change;
- no live uploads.

## Item mapping
| Item | Status on 9f9b751 | Evidence |
|---|---|---|
| Leftover CSV column overwrites a non-PDF action label | **Ready (T1)**, reproduced | `probe-leftover-main-9f9b751.jsonl`: case A (no PDFs) Quote → "a1.pdf"; C Quote → "note-A1"; D (with PDFs, non-target action) Quote → "note-A1". Twins: B (.16 target with PDFs) and E (no leftover) correct. Cause: `list-rows.ts:59–62`, where `keep` holds only the linked PDF target (`live`), so `bind()` at :36 hands leftover columns to any other unmatched cell, Buttons included. `list-links.ts:59` already holds the action test (`same`) but doesn't share it. |
| Status after Remove (spreadsheet and PDFs) | **Ready (T2)**, reproduced | `probe-panel-text-main-9f9b751.jsonl`: Remove → "Saved in this Figma file. Click Convert again to see every row." Cause: `main.ts:148` `expectSave(id,"csv")` for null too; `list-files.ts:96,108` `expectSave(..,"pdf")` for removals. |
| PDF pickers don't follow the WordPress connection | **Ready (T3)** | `list-files.ts:57` `const wp = deps.wp()` read once; :65 `disabled` fixed at that moment; :66/:70/:77 use the captured object (the live `stored.settings.wp`, so after `readForm` they upload to the edited site even when `connected=false`); `main.ts:459–476` wpTest never refreshes the Lists box. New finding inside this scope: stale enablement after a failed test or site edit. |
| No Cancel during a long PDF upload | **Ready after Q2 (T4)** | `list-files.ts:66–87` no cancel control; `uploads` global counter blocks Convert (`main.ts:447`); `pdf-upload.ts:69` caches before the ownership check (good: a settled upload stays reusable). `net.ts` aborts only on timeout. |
| Empty list name | **Dropped, already fixed** | `list-rows.ts:46` `name: box.label ?? "List"` since 515eec5. `labels.ts:12` returns null, never "". Containers get `label:null` (`node.ts:14`, `section.ts:26`). Same-name duplicates are Q6. |
| Two lists (desktop + phone) | **Deferred → Q6** | `probe-panel-text`: identical titles "Parts card: 3 rows drawn". |
| Large CSV warning | **Deferred → Q5** | `parseCsv` takes 20 000 rows with no warning path; the plugin-data save limit is the only guard. |
| TSV | **Ready only if Q4=A (T5)** | `probe-panel-text`: a TSV parses to one column; `lists.ts:39` separator is `;`/`,` only; `main.ts:157` picker `.csv,text/csv`. |
| main.ts 581 lines | **Stage 1 if Q7=A (T0)**; rest deferred | outline main.ts:140–182 Lists wiring. |

Real files checked: the user's root debug copy has 0 lists. The git debug file's list ("Tbody#inv body", 78 drawn) has no row buttons and no CSV. No corpus file has a list (`probe-debug-lists-main-9f9b751.txt`; csv-list-pdfs ledger). **Expected: byte-identical pastes on every corpus/debug file.** The change shows only in fixtures and in lists that have row actions plus extra columns.

## Tasks (TDD, one commit each; prove each RED test fails with the fix reverted)

**T0 (Q7=A): move the Lists box wiring out of main.ts, no behaviour change.**
- Create `src/ui/list-box.ts` exporting `showLists(lists, deps)` / `sendList`. Deps: `busy`, `post`, `persist`, `stored`, and an element lookup.
- main.ts keeps a call and a `lastLists` reference only.
- Gate: existing `test/browser/panel.test.ts` lists tests and the unit suite pass unchanged. Don't edit any test in this task.

**T1: actions keep their words.**
- RED (`test/unit/understand-lists.test.ts`, or a new `test/unit/list-actions.test.ts`), using probe cases A, C, D:
  - every row's "Quote" label/words stay "Quote";
  - `binding` for that cell is null;
  - the leftover column shows in `listLines(...).detail` as "Not shown: Sheet/Notes".
- Twins / controls:
  - case B: .16 target linked per row, the unmatched row's button dropped, no Sheet in the binding;
  - case E: unchanged;
  - a per-row-varying badge still binds to its column (existing test l.137);
  - a Button whose identical words are a data cell value still binds;
  - sample-words-in-order (l.80, l.126) unchanged;
  - linked icon fallback (no words) unchanged;
  - box-drawn row button (list-pdfs-review F3);
  - `.pdf` URL column still links with `newTab:true, rel:"noopener"` (existing pdf-new-tab tests stay green).
- GREEN:
  - `list-links.ts`: export `rowActions(rows, sheet): number[][]`, the paths of the existing `same` set. `rowTarget` picks from it, so its behaviour doesn't change.
  - `lists.ts` passes the actions to `rowsFrom`.
  - `list-rows.ts`: `keep` = cells inside any action, whether or not anything is linked; `linking` stays as it is.
  - lists.ts is 272 lines: add 1–2 lines only.

**T2 (Q3): saved-answer kinds.**
- `list-files.ts` pending kinds `csv | csv-remove | pdf | pdf-remove`, with savedText wording per Q3.
- `main.ts` (or list-box) `sendList(id,null)` → `csv-remove`.
- Per-button Remove and Remove PDFs → `pdf-remove`.
- RED: `test/unit/ui-list-files.test.ts`, covering queue order with mixed kinds and an error answer still winning.
- Browser: extend `panel.test.ts` l.350 to deliver `listSaved` after Remove and assert the text.

**T3: the pickers follow the connection.**
- `pdfControls` reads `deps.wp()` at click time and at change time.
- An exported `refreshPdfConnection()` re-sets `disabled` and the note on the current round's controls. Each pick captures the WP it started with, so an upload in flight keeps its site.
- The main wpTest (success and failure) and `readForm` (connection reset) call it.
- RED, browser `panel.test.ts`:
  - init disconnected → result with a list → pickers disabled;
  - connect through wpTest with a stubbed fetch → pickers enabled with no Convert;
  - failed re-test → disabled again;
  - a changed site plus readForm → disabled.
- Negative twins:
  - a stale round's controls are untouched;
  - no upload is ever sent while `connected=false`.

**T4 (Q2=A): Cancel.**
- `list-files.ts`: each pick gets a token. While it uploads, a "Cancel upload" button shows. Cancel marks the pick dead (`owns = alive && !cancelled`), releases its `uploads` share exactly once, and shows "Upload cancelled. A PDF already sending finishes and is reused next time."
- `pdf-upload.ts`: an in-flight map keyed by site plus fingerprint, so a re-pick of the same bytes awaits the pending promise instead of sending a second POST.
- RED: `test/unit/ui-pdf-upload.test.ts` with an env.fetch stub holding a deferred POST:
  - cancel → the later files are never POSTed;
  - the settled one is in the cache;
  - no saveListFiles is posted;
  - a re-pick of the same bytes during the flight makes one POST in total;
  - the late finally doesn't decrement twice, so a new pick's counter isn't freed early.
- Browser:
  - Convert works right after Cancel;
  - an empty pick or a cancelled dialog changes nothing (no status, no post).
- Keep the existing panel-cancellation tests green.

**T5 (Q4=A only): TSV.**
- `lists.ts` separator choice adds `\t` (whichever splits the header into more cells wins; tie order `,`, `;`, `\t`). Picker `accept` adds `.tsv,.txt,text/tab-separated-values`.
- RED: `ui-lists.test.ts` TSV parse.
- Twins:
  - a comma CSV with a tab inside a quoted cell stays comma-separated;
  - semicolon Excel files unchanged;
  - BOM handled;
  - a one-column CSV unchanged.

**Gates:**
- `npm run check`;
- `npm run test:browser` (panel, lists, pdf-new-tab suites);
- `npm run corpus` before T0 and after the last task: save the reports and `bricks.json` copies and `cmp` them. Expect byte-identical output;
- replay the git debug file and a scratch copy of the root debug file: identical pastes.

No layout change, so the 375/360/320 width check doesn't apply; say so in the review brief.

Proof for the review: before/after JSON from `probe-leftover.ts` and `probe-panel-text.ts`, run against main and the branch (text proof, no screenshots).

## Touches (builder may edit)
- `src/core/understand/list-links.ts`, `list-rows.ts`, `lists.ts` (1–2 lines)
- `src/ui/list-files.ts`, `src/ui/pdf-upload.ts`, `src/ui/lists.ts` (T5), `src/ui/main.ts` (narrow wiring), new `src/ui/list-box.ts` (T0)
- Tests:
  - `test/unit/understand-lists.test.ts`;
  - new `test/unit/list-actions.test.ts`;
  - `test/unit/ui-list-files.test.ts`: l.9–10 pins the csv wording; csv-add stays, a new remove case is added;
  - `test/unit/ui-pdf-upload.test.ts`, `test/unit/ui-lists.test.ts`;
  - `test/browser/panel.test.ts`: the lists/PDF tests from l.350 on, only the list-related ones;
  - `test/unit/list-pdfs-review.test.ts`: read only unless an assertion pins leftover binding (none found).
- **Not owned:**
  - `test/browser/chrome.ts`, `render.ts` (renderer-proof-hardening);
  - `src/ui/site-media.ts`, `wordpress.ts`, `net.ts`, `run.ts`, `site-pages.ts` (media-rename-collision);
  - font files (google-font-range-policy);
  - `normalise/contacts.ts` (phone-recognition-guards);
  - `plugin/lists.ts`, which needs no change.

## Overlaps
- **B media-rename-collision:** separate files. If B needs `wordpress.ts`, `uploadMedia` or `run.ts`, T4's pdf-upload in-flight map depends only on `uploadMedia`'s signature. Hard dependency if B changes that signature: rebase T4 after B.
- **A renderer-proof-hardening:** `panel.test.ts` imports A's `chrome.ts`. If A changes its API, rebase. Not parallel-safe for `chrome.ts`, and we don't edit it.
- **E google-font-range-policy:** if E edits main.ts (showFonts/sendFonts), it's a textual overlap with T0/T3 wiring. The finishers merge in sequence under the lock. T0 only moves lines 140–182.
- **C, pill-clip, hero-photo-blend, card-link-words (merged):** no shared files (branch diffs checked; none touch ui/lists).
- HANDOFF/BUILD: finisher-serialized as usual.

## Risks
- Q1 A changes which layer gets a column in rare designs where sample-word Buttons are identical on every row. Panel detail shows "stays as drawn" / "Not shown", so it's visible and the user can fix it by drawing real words.
- T4 background sends go on after Cancel; that's the honest cost of not aborting. The iframe must stay open for them to finish (closing the plugin kills them, the same as today).
- T3 must not re-render whole list items: that would lose pick state mid-upload. Toggle disabled and the note in place.

## found_else (outside scope)
- None new outside scope. The stale captured-WP enablement is inside T3.

## Docs & records (finisher)
- Plan copied to `docs/plans/2026-10-21-list-panel-followups.md`; ledger to `docs/plans/2026-10-21-list-panel-followups-ledger.md`.
- `docs/HANDOFF.md`: a new section listing the rulings (Q1–Q7 answers) and the deferred items (large CSV, multi-list, main Stage 2+).
- Panel check owed, the next free number (Figma only, no paste needed):
  1. Convert while disconnected;
  2. connect → pickers enable;
  3. pick a large PDF → Cancel → Convert works;
  4. Remove → status wording;
  5. a TSV if Q4=A.
- A paste check only for a list with a row action and an extra CSV column.
- Bump `BUILD`. The finisher updates main `CLAUDE.md` "Start here" / "Where things stand" (pending file if blocked).
- New rule for the CLAUDE.md lists section and rules-summary: "Row actions (same words every drawn row, in no cell) keep their words; unmatched columns are Not shown."
- Strike in `found-else.md`: "leftover column's value" (csv-list-pdfs builder), the lists minors line (mark which ones are dropped or deferred), the main.ts line (partial, Stage 1).
