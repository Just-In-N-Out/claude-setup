# REVIEWER only: hero-photo-blend

Fresh reviewer, Sol 6.1 xhigh (Justin moved it off Opus). Load skill_view('figma-to-bricks') (REVIEWER) and skill_view('requesting-code-review') (report only, never auto-fix); say you loaded them.

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/hero-photo-blend, branch worktree-hero-photo-blend, tip 14c202d. Plan ~/.hermes/plans/figma-to-bricks/hero-photo-blend.md (A1 B1 C1). Review `git diff $(git merge-base main HEAD)...HEAD`. Main is now 2026-10-21.15.

Builder claims: new style/picture-shadow.ts; paint.ts boxPaint gets a `picture` flag set on all three picture.ts calls; picture drop shadows → `filter: drop-shadow(...)`, same blur; layer blur chained `blur(..) drop-shadow(..)`; spread/inner shadow stays box-shadow + warning; painted boxes/cards/buttons unchanged. Unit 11 tests; browser edge-step 112 → ≤3; showcase photo still zooms 1.1 and clips. check 1590+6, browser 158/158. Corpus: hydraulics 2 product photos + page-1 5 listing photos change CSS only; page-1 section scores −0.008…−0.012 (page 0.7636→0.7608), no new worse-than-v1, lint/heights same. Debug replay: only Repairs hero picture CSS changes. Paste check 3ap. Shots ~/.hermes/plans/figma-to-bricks/shots/hero-photo-blend/.

Judge 4 rulings: states.ts untouched (picture hover can only change opacity); several drop shadows chained into one filter (each later shadows earlier: is that a visible difference from Figma? measure); one existing test in style.test.ts rewritten to the new form (check it isn't weakened); page-1 score drop counted as no worse (grey stand-ins) — verify with a real see-through image render in Chrome, Figma vs paste, that the drop is a stand-in artefact and not a real visual regression (opaque photos: does drop-shadow look the same as box-shadow? radius corners? a rounded photo with drop-shadow vs box-shadow).

Check hard: filter creates a stacking context/containing block — any absolutely/fixed positioned children or z-index layering on pictures broken? Performance of filter on many listing photos (paint cost on scroll) — note if significant. Safari support of filter drop-shadow with rgba. Showcase zoom ::before with filter on the panel. Rounded corners (radius) and the shadow shape on opaque photos. Run gates yourself, try mutations.

Change nothing: no commit/merge/push; restore anything; no live-site writes. Other agents (csv-list-pdfs finisher, card-link-words builder, layout-floors reviewer) separate. Other bugs: found_else.

Output: verdict pass/request_changes, findings [{id, severity, introduced, claim, evidence}], found_else. Plain words.

- NOTE (main chat): paste check 3ap was taken by csv-list-pdfs (.16) at merge. Renumber this feature's 3ap to the next free number on main at merge, everywhere.
