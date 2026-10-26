# Brief: FINISHER for figma-to-bricks feature "font-weight-gaps" (self-review, then merge)

This is a panel-only fix: no `src/core` change, and the corpus pastes are byte-identical. To save Justin's plan usage there's no separate reviewer agent. You do a careful self-review, then merge into local main, bump BUILD, push main and update the records. Commit as you go: the model connection has been dropping.

## State
- Worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/font-weight-gaps`, branch `worktree-font-weight-gaps`, last commit `340a17b`.
- Plan: `~/.hermes/plans/figma-to-bricks/font-weight-gaps.md`. Approved with answers 1A 2A 3A 4A.
- What the builder reports:
  - The paste never writes a weight range any more: a variable font gets one @font-face line per design weight, all pointing at the same file.
  - Weights are read as standard hundreds: 250 → 100, 275 → 200.
  - Faces already on the site are read from their file names, with nothing written to the site.
  - Gates: check 1287 passes; browser 131 of 134 (the 3 known stale upload-name tests); corpus byte-identical.
  - Proof: Google answered Bricks' link with 400 before the fix and 200 after.
- Builder ruling, not yet confirmed: a weight between hundreds with no weight word in its name goes to the nearest hundred on upload, with a tie going toward 400. The same kind of face already on the site is left out, so Google's copy draws that weight.
- phone-side-padding and early-line-breaks are finishing in parallel and may merge first. Both claimed paste check 3ad, so one will take 3ae. This branch took 3af. Re-check main's HANDOFF right before committing and renumber if needed.
- The untracked `.superpowers/sdd/font-weight-gaps/` holds the corpus baseline and the proof. Use it after the rebase, then move it to `~/.hermes/backups/figma-worktree-leftovers/`.

## How
1. Load `skill_view('figma-to-bricks')` in the FINISHER role. Read `references/rules-summary.md` first, then only the CLAUDE.md sections you need; never the whole file.
2. Also load `requesting-code-review` (its security scan and quality checks on `git diff main...HEAD`), `receiving-code-review`, `test-driven-development` and `git-commit-rules`.
3. Self-review:
   - Check the diff against the plan.
   - Try 4–6 mutations: revert a fix line and check that a test fails. Restore every one.
   - Make sure no `src/core` file changed.
   - Check the variable-font path: one line per design weight, and the fallback when a face has no weight in its name.
   - Fix anything real, test first. In the summary, list what you checked.
4. Run the project skill's Step 3 item 7 and Step 4 in full:
   1. Rebase on the current main.
   2. Re-run `npm run check`, `npm run test:browser` (3 known failures) and `npm run corpus`. Corpus pastes must stay byte-identical against the new main.
   3. Take the merge lock with `~/.hermes/scripts/merge_lock.sh`. Release it on every path, failures included.
   4. Fast-forward merge.
   5. Bump BUILD: read it first, then today's next number.
   6. `npm run build`.
   7. Commit `Build <BUILD>: font weights (no weight ranges; standard weights)` per git-commit-rules.
   8. Push main.
5. CLAUDE.md:
   - The main CLAUDE.md edit may be blocked as a protected file. Try once. If it's blocked, don't retry: write the exact text to `~/.hermes/plans/figma-to-bricks/font-weight-gaps-claude-md-pending.md`.
   - Update `references/rules-summary.md` in the figma-to-bricks skill if a rule changed. A likely new rule: never write a font-weight range in a paste.
6. In `~/.hermes/plans/figma-to-bricks/found-else.md`, mark these fixed as `~~item~~ ✅ fixed in build <BUILD> (font-weight-gaps)`:
   - the 'SCHEDULE NOW' / Times line
   - the Saira Condensed 250/275 line
7. Clean up:
   - Move `.superpowers` to backups.
   - Remove the worktree and the branch.
   - Kill any headless Chrome you started.
8. If you run out of steps or hit an error, stop with `status: stopped` and a `stop_reason`, and release the lock. Put other bugs in `found_else`.
9. Write the summary in plain words for a WhatsApp reader. Steps for Justin:
   1. Bricks → Templates → header → "SCHEDULE NOW" → font weight 600 → Save.
   2. Reload the plugin.
   3. With WordPress connected as an Administrator, Convert and paste the 8 pages (Home, Hydraulic Cylinder Repairs Final, Remanufactured, Contact, Core Exchanges, Rods, Services, About), with Cmd+S on each. This one paste also covers the Emergency button fix.
   4. LiteSpeed → Purge All.
   5. Reply 'pasted <pages>'.
