# Brief: FINISHER (resume) for figma-to-bricks feature "early-line-breaks"

Earlier finishers died when the connection to the model provider dropped, before changing anything. Do the fix pass on the reviewer's findings, then merge into local main, bump BUILD, push main and update the records. Commit as you go so another drop loses nothing.

Justin approved applying the reviewer's suggested fixes for F1 and F2, which replace builder rulings. Record each in HANDOFF as "My ruling, not yet confirmed (applied under Justin's auto-go)".

## State
- Worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/early-line-breaks`, branch `worktree-early-line-breaks`, last commit `1070b02`. Clean apart from the untracked `.superpowers/`.
- Check that no merge lock is held and no rebase is in progress.
- Main was at `a75ecec` (Build 2026-10-21.1, paste check 3ac). phone-side-padding may merge first (3ad, build .2).
- Plan: `~/.hermes/plans/figma-to-bricks/early-line-breaks.md`.
  - L1A: in fixed-width boxes, a typed break that only copies Figma's wrap becomes a space.
  - L2A: hug boxes keep today's rule.
- The build added `src/core/style/rag.ts` (copiesWrap, WRAP_SHARE 0.9) and a textHtml `soft` flag.
- Verdict: changes requested, nothing blocking. The reported bug is fixed at 1728/1920, and 1440/990/390 match main.

## Reviewer findings
- **F1 (major).** The 90% cut-off in copiesWrap isn't principled.
  - Its slack is 10% of the box, so it grows with box width: about 3 letters at 292px, about 10 at 762px.
  - The real error is only in the guessed letters: the next word, plus the line itself when it isn't the longest. The longest line's width is Figma's measured ink.
  - It drops a real designer's break: user file `figma-to-bricks-debug-design-inspo-brainstorm.json`, node 184:688, "Strategy, brand, web, creative, media, and growth⏎shouldn't live in separate silos." It's an auto-height 524px box whose first line is the longest, measured at 416.5px. The estimate gives 0.957, but in Chrome "…growth shouldn't" fits in 505px, so the break is the designer's.
  - The ledger's "lowest 0.995" is wrong: the corpus page-1 review 528:4289 scores 0.924, on a line that isn't the longest.
  - Real import breaks on longest lines have at most 0.3 letters to spare.
  - **Fix:** count the slack in letters. Allow about 1 letter when the line is the longest (it's measured), and about 10% of the line's guessed length otherwise.
- **F2 (major).** Designer breaks in a tight fixed-width box now go at every width: addresses and opening hours with 30+ character lines and no sentence punctuation.
  - Corpus 'design' footer address (node I646:9344;319:2430, auto-height 292px) at 1728:
    - main: '2133 S Timberline Rd,' / 'Suite 100' / 'Fort Collins, CO 80525'
    - branch: '…Rd,' / 'Suite 100 Fort Collins, CO' / '80525'
  - Probe texts in a 300px box lose all their breaks:
    - 'Monday to Friday: 7:00 AM – 6:00 PM⏎Saturday and Sunday: 8:00 AM – 12:00 PM'
    - '1200 Industrial Parkway, Building 4⏎Springfield, Illinois 62701, USA'
  - Main kept the `<br>`, with nowrap from 1440 up and the br rule below.
  - **Fix:** make breaks soft only in prose, meaning the text contains . ! or ? somewhere. The design footer address must come back to main's three lines at 1728.
- **F3 (minor).** No test pins the cut-off: changing WRAP_SHARE from 0.9 to 1.0 keeps all 1269 tests green, and the hydraulics 'Fill out the form…' line scores 0.995.
  - Add boundary tests: about 99% goes soft; a measured longest line where the next word fits keeps its break; addresses and hours keep their breaks; the inspo-style line keeps its break.
  - Add one for ragBreaks' heading check (`ir.tag === null`) if it's cheap.
- **F4 (nit).** A soft line that starts with typed spaces gives 'Give &nbsp;&nbsp;us'. When soft, skip a line's leading spaces.
- **F5 (nit).** style.ts is at 356 lines. Leave it: test-cleanup splits it.
- **F6 (nit).** After F1 and F2, fix the wrong statements in HANDOFF and the ledger ("lowest 0.995", the address result, "harmless").
- **Optional, if it's one line:** text.breaks/softBreaks judge a node by its Figma text even when its words are replaced (the FAQ placeholder), so skip nodes whose words are replaced. Otherwise list it in `found_else`.

## How
1. Load these skills: `skill_view('figma-to-bricks')` (FINISHER role; read `references/rules-summary.md` first, then only the CLAUDE.md sections you need, never the whole file), `receiving-code-review`, `test-driven-development`, `git-commit-rules`. Verify each finding before fixing it, fix test first, and push back with evidence where a finding is wrong.
2. Re-render in the renderer only (`npm run snap`), never on the live site:
   - the hydraulics Info cards at 1728/1440/390 (should still be fixed)
   - the design footer address at 1728/1440/390 (main's lines)
   - the inspo 184:688 line
3. Run the project skill's Step 3 item 7 and Step 4 in full:
   1. Rebase on main. Keep all HANDOFF sections, and take the next free paste check number.
   2. Re-run `npm run check`, `npm run test:browser` (3 known failures) and `npm run corpus`.
   3. Take the merge lock: `~/.hermes/scripts/merge_lock.sh`. It waits if another agent holds it. Release it on every path, failures included.
   4. Fast-forward merge.
   5. Bump BUILD: read it first, then today's next number.
   6. `npm run build`.
   7. Commit `Build <BUILD>: early line breaks` per git-commit-rules.
   8. Push main.
4. CLAUDE.md:
   - Try the main CLAUDE.md edit once. If it's blocked as protected, don't retry. Write the exact text to `~/.hermes/plans/figma-to-bricks/early-line-breaks-claude-md-pending.md` instead.
   - Update `references/rules-summary.md` if a rule changed.
5. Re-shoot the after pictures from the final code into `~/.hermes/plans/figma-to-bricks/shots/early-line-breaks/`, keeping the same names. Return all paths in `shots[]`.
6. Clean up:
   - Move `.superpowers` to `~/.hermes/backups/figma-worktree-leftovers/`.
   - Remove the worktree and the branch.
   - Kill any headless Chrome you started.
7. If you run out of steps or hit an error, stop with `status: stopped` and a `stop_reason`, and release the lock. Put other bugs in `found_else`.
8. Write the summary in plain words for a WhatsApp reader. Steps for Justin, once the font fixes are also in:
   1. Reload the plugin.
   2. Convert and paste the hydraulics homepage, then Cmd+S.
   3. LiteSpeed → Purge All.
   4. Reply 'pasted <page>'.
