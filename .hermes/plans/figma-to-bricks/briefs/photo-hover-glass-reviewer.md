# REVIEWER only: photo-hover-glass

Fresh reviewer. Load skill_view('figma-to-bricks') (REVIEWER) and skill_view('requesting-code-review') (report only, never auto-fix); say you loaded them.

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/photo-hover-glass, branch worktree-photo-hover-glass, tip ddd915b. Plan ~/.hermes/plans/figma-to-bricks/photo-hover-glass.md (Justin: A1 B1 C1 — remove only the glare stripe; 110% zoom, clip/isolation, figure tag and card fade-in stay; old pages fixed by re-paste with "replace" in Bricks' class box). Review `git diff $(git merge-base main HEAD)...HEAD`. Main is now 2026-10-21.13.

Builder claims: glare stripe, hover sweeps and showcase-glare keyframes deleted in style/classes.ts; tests red first (3 unit, 4 browser) then green; guard test blocks any ::after / keyframes / hover animation on showcase classes; check 1480 + 6 perf; browser 154/154; corpus full reports equal; 5 pastes differ only by deleted glare CSS lines in showcase classes; showcase-zoom unchanged; rest pictures byte-identical. Shots ~/.hermes/plans/figma-to-bricks/shots/photo-hover-glass/.

Builder rulings to judge: (1) regenerated test/golden/files/convert-sample.json (claims only glare lines removed) — verify the golden diff is exactly that; (2) guard blocks ANY ::after on a showcase frame — check this doesn't block a legitimate existing/future use (e.g. overlays, gradients from Figma on showcase cards) and whether it's too broad; (3) skipped the stale comment in emit/elements.ts:96.

Check hard: zoom still works and still clips (overflow, radius, isolation); no leftover `content:`/pseudo rule now empty or dangling; the card fade-in really unchanged; no other hover behaviour (links, buttons, showcase number above photo) changed; Safari/Chrome flicker not caused by the zoom itself (transform without will-change on a rounded overflow box) — if the zoom alone still flickers in Chrome, report it as a finding with evidence, since Justin's complaint was "flicker". Run gates yourself, try mutations.

Change nothing: no commit/merge/push; restore anything; no live-site writes. Other agents running (layout-floors, csv-list-pdfs, text-link-followups): leave them alone. Other bugs: found_else.

Output: verdict pass/request_changes, findings [{id, severity, introduced, claim, evidence}], found_else. Plain words.
