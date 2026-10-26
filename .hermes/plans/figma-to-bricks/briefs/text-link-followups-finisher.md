# FINISHER: text-link-followups (B7)

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/text-link-followups, branch worktree-text-link-followups, tip 5530e82 (on main .13). Plan ~/.hermes/plans/figma-to-bricks/text-link-followups.md (N1A + dispatcher ownership clarification). Sol 6.1 high.

Load skill_view('figma-to-bricks') (FINISHER), receiving-code-review, git-commit-rules, test-driven-development; say you loaded them.

## Fresh Sol reviewer: request_changes, one finding (verbatim essentials)
- **F1 medium, introduced: N1A is incomplete: native Bricks Button labels are omitted from shared-address notes.** src/core/emit/page-addresses.ts:71–74 reads replacement words, text nodes and children, but not ir.text; native Buttons store their label in ir.text (src/core/understand/node.ts:64–67). Two painted Buttons "Pricing details" and "See plans" both navigating to Pricing Final: pageLinks has no labels list and the note names only "Pricing Final". Adding a frame-linked "Compare options" text gives labels:["Compare options"], silently omitting both Button labels. Red tests: /Users/justin/.hermes/cache/scratch/b7-review/test/unit/reviewer-shared-button-labels.test.ts (log b7-review-button-labels-red.log). Fix: collect the native Button's emitted label too, keeping canonical words/name, first-seen order, address counts and relink targets. Add Button-only and mixed Button/text tests.
- **D1 low:** docs/HANDOFF.md:3470–3471 and the ledger's final status still say the 4 legacy expectations are blocking; refresh (main chat applied them in 5530e82, check 1599/1599 passes).
- Reviewer verified: 1599/1599 + 6/6 + 157/157 browser; corpus identical; 6 mutations caught; real Tab traversal fine; `labels:["Gallery"]` justified.

Note: card-link-words (queued, builds after you merge) will turn label-linked pills into Buttons with links, so Button labels in notes matter for it too.

## Then finish
Fix F1 test first, D1 records. Rebase on main (photo-hover-glass / csv-list-pdfs may merge meanwhile; keep all HANDOFF sections; take the next free paste check on main). Rerun npm run check, npm run test:browser, npm run corpus (full comparisons). Merge lock, ff-only merge, next BUILD, npm run build, commit `Build <BUILD>: text and link follow-ups`, push, verify. Release the lock on every path.
CLAUDE.md: standing permission; if denied, don't retry: write ~/.hermes/plans/figma-to-bricks/text-link-followups-claude-md-pending.md (build line last). Never overwrite other pending files.
found-else.md: re-read, then mark exactly the 4 B7 items fixed (`~~…~~ ✅ fixed in build <BUILD> (text-link-followups)`).
Remove worktree/branch after merge. Return status, build, last_commit, summary, paste check, steps_for_justin, shots, found_else, pending_docs. Plain words.
