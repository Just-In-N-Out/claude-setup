# Brief: FINISHER (resume) for figma-to-bricks feature "phone-side-padding"

Earlier finishers died when the connection to the model provider dropped (03:00 and 05:01). Pick up where they left off: do the fix pass on the reviewer's findings, then merge into local main, bump BUILD, push main and update the records. Commit as you go so another drop loses nothing. Justin's main point for this feature: **padding must look clean on any layout.**

## State
- Worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/phone-side-padding`, branch `worktree-phone-side-padding`, last commit `e327cbb`.
- It has UNCOMMITTED edits in `src/core/adapt/layout.ts` and `test/unit/adapt-rows.test.ts`: a dead finisher's start on the F1 divider-row fix. Read `git diff` first. Keep and finish them if they're sound; otherwise discard them with `git checkout -- <files>`.
- Check that no merge lock is held (`.git/hermes-merge.lock` in the main repo) and no rebase is in progress.
- Main was at `a75ecec` (Build 2026-10-21.1, emergency-cta-width, paste check 3ac). early-line-breaks may merge in parallel.
- Plan: `~/.hermes/plans/figma-to-bricks/phone-side-padding.md`. Answers: P1A; P2B (upright phones only). Review verdict: approve with minors; gates green except 3 known panel failures.

## Reviewer findings
- **F1 (minor).** final-design's stat row (3 icon+label items with divider lines) looks messier at 390–429.
  - It goes from 2+1 to a staircase of 1+1+1. Item 1 is flush left, items 2 and 3 are pushed 32px in, dividers hang mid-screen, and the section is 76px taller. Main already staircases at 360 and 375.
  - Cause: the divider row's padding (0/31, 32/31, 32/0) isn't evened out when the row wraps. The phone rule only evens it out for stacked rows.
  - Shots: `~/.hermes/cache/scratch/psp-review/out/shots/fd-row-{main,br}-390.png`.
  - **Decision already made:** if a small, general fix (evening out divider padding when a divider row wraps) fits in adapt within about one file plus tests, do it test first; the stat row must then look clean at 360–478. If it's bigger, merge without it and record in HANDOFF: "My ruling, not yet confirmed: merged because the staircase is pre-existing; divider-row follow-up queued".
- **F2 (minor).** No test holds P2B.
  - Mutation: changing `space.ts` line 84 to `sideAt(...) ?? d` (every tier) keeps all 1268 tests green.
  - Add a fixture that is squeezed on tablets only and has room on sideways phones. Assert there's no `_padding:mobile_landscape`, and that `_padding:mobile_portrait` equals its own padding.
- **F3 (nit).** The plan copy in the worktree says 478 is a sideways-phone width that stays at 17.
  - In Bricks, `mobile_portrait` is ≤478, so 478 is upright and the fix shows there. The first unchanged width is 479.
  - Fix the plan copy.
- **F4 (nit).** The guard test in `test/unit/adapt-space.test.ts` drops missing corpus files silently. Make it skip with a message, the way `corpus-convert.test.ts` does.

## How
1. Load these skills: `skill_view('figma-to-bricks')` (FINISHER role; read `references/rules-summary.md` first, then only the CLAUDE.md sections you need, never the whole file), `receiving-code-review`, `test-driven-development`, `git-commit-rules`.
2. Run the project skill's Step 3 item 7 and Step 4 in full:
   1. Rebase on main. Keep all HANDOFF sections, and take the next free paste check number (3ad or later; check main's HANDOFF right before committing).
   2. Re-run `npm run check`, `npm run test:browser` (3 known failures) and `npm run corpus`.
   3. Take the merge lock: `~/.hermes/scripts/merge_lock.sh`. Release it on every path, failures included.
   4. Fast-forward merge.
   5. Bump BUILD: read it first, then today's next number.
   6. `npm run build`.
   7. Commit `Build <BUILD>: phone side padding` per git-commit-rules.
   8. Push main.
3. CLAUDE.md: editing the main CLAUDE.md was blocked earlier as a protected file that needs Justin's OK.
   - Try once. If it's blocked, don't retry. Write the exact text to `~/.hermes/plans/figma-to-bricks/phone-side-padding-claude-md-pending.md` instead.
   - Update `references/rules-summary.md` in the figma-to-bricks skill if a rule changed.
4. If the output changed, re-shoot the after pictures into `~/.hermes/plans/figma-to-bricks/shots/phone-side-padding/` (add the stat row if you fixed F1). Return all paths in `shots[]`.
5. Clean up:
   - Move `.superpowers` to `~/.hermes/backups/figma-worktree-leftovers/`.
   - Remove the worktree and the branch.
   - Kill any headless Chrome you started (`pgrep -fl f2b-chrome`).
6. If you run out of steps or hit an error, stop with `status: stopped` and a `stop_reason`, and release the lock. List any other bug you find in `found_else`.
7. Write the summary in plain words for a WhatsApp reader. Steps for Justin:
   1. Reload the plugin.
   2. Convert and paste the hydraulics homepage, then Cmd+S.
   3. LiteSpeed → Purge All.
   4. Check the 3 Info cards on an upright phone.
   5. Reply 'pasted <page>'.
