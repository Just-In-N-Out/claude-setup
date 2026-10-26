# FINISHER: photo-hover-glass

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/photo-hover-glass, branch worktree-photo-hover-glass, tip ddd915b. Plan ~/.hermes/plans/figma-to-bricks/photo-hover-glass.md (A1 B1 C1). Opus 5.5 medium.

Load skill_view('figma-to-bricks') (FINISHER), receiving-code-review, git-commit-rules, test-driven-development; say you loaded them.

## Fresh Opus xhigh reviewer: PASS, 4 lows + 1 nit (verbatim essentials)
- F1 (low, not introduced): the remaining 110% zoom makes no flash, no clip leak; only a GPU "softness pop" (soft at zoom start, sharp snap at end). will-change makes it worse. Not a blocker for A1. **Don't change the zoom** (Justin chose A1); the main chat tells Justin and offers A2.
- F2 (low, ruling 2): the guard blocks any ::after on showcase elements (over-broad) yet misses a ::before stripe moved by a transition (mutation M1) and `filter: brightness(1.3)` on :hover (M6). Suggestion: an **allow-list guard**: showcase :hover rules may change only `scale`, and the only pseudo-element allowed is the zoom copy's ::before. Do this test-first; prove M1 and M6 now fail the guard; keep legitimate future ::after (photo tint, video overlay, card link) out of the guard's scope if they're not showcase hover effects.
- F3 (low): fix the stale comments: src/core/emit/elements.ts:96 ("holds the glare") and reference/bricks/README.md:328 ("zoom and glare"). Comment/doc only; text-link-followups touches elements.ts only at l.17 and l.75, so a l.96 comment edit merges cleanly.
- F4 (low): paste check 3am is taken on main (google-font-hardening .13). Renumber to the next free number on main at merge time, everywhere (HANDOFF, ledger, plan copy, report). Note: csv-list-pdfs' unmerged worktree also uses 3an; take whatever is free on main when you merge, and say which.
- F5 (nit): rewrap src/core/style/classes.ts:70 (214 chars) to ~120.
- Reviewer found_else (record in found-else.md, don't fix): the browser assertion "the zoom is clipped inside the frame" compares getBoundingClientRect, which a child's scale never changes, so it passes even without overflow:hidden.
- Evidence: ~/.hermes/cache/scratch/phg-review/.

## Then finish
Rebase on main (2026-10-21.13 or newer; HANDOFF conflict expected, keep both sections), rerun npm run check, npm run test:browser, npm run corpus (pastes may differ from main only by deleted glare lines in showcase classes), re-shoot after pictures only if output changed. Merge lock, ff-only merge, next BUILD, npm run build, commit `Build <BUILD>: photo hover glare removed`, push, verify main = origin. Release the lock on every path.
CLAUDE.md: standing permission; if denied, don't retry: write exact edits to ~/.hermes/plans/figma-to-bricks/photo-hover-glass-claude-md-pending.md (build line last; new rule: no glare/shine/glass sweep on photo hover, reverses the 19 Oct "zoom + glare" decision; the Staff sample's glare must not be copied). Other pending files (.9–.13) exist: never overwrite them.
Remove worktree/branch after merge. Other agents (layout-floors, csv-list-pdfs reviewer, text-link-followups reviewer) are not yours.
Return status, build, last_commit, summary, paste check number, steps_for_justin, found_else, pending_docs. Plain words.
