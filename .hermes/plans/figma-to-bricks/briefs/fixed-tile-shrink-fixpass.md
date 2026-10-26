# fixed-tile-shrink — FIX PASS brief (2026-10-21 21:43 EDT)

Opus medium. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/fixed-tile-shrink, tip 667fef0, base 5e32aec. Main has moved to 748dca8 (build .23, phone-recognition-guards took paste check 3aw). Plan ~/.hermes/plans/figma-to-bricks/fixed-tile-shrink.md. Reviewer evidence: ~/.hermes/plans/figma-to-bricks/evidence/fixed-tile-shrink/reviewer-opus/ (phone3.ts, hug-row-label-wrap.txt, probe.ts, mutation hook).

## RELEASE BOUNDARY
Because F1 changes rendering, this pass is FIX ONLY: no merge, push, BUILD bump, CLAUDE.md edit or cleanup. A NEW fresh Opus xhigh reviewer checks the corrected branch, then a finisher merges.

## Fresh Opus xhigh review findings (verbatim essentials)
F1 (medium-high, blocking): one-line label beside an auto-layout tile in a HUGGING row wraps on tablets/sideways phones. Fixture tile() auto:true (56x56 '3', 72x72 '12') beside a 22px one-line label, row with no set width. Main: label 27px one line at 990/768/600/480. Branch: wraps to 55px. Framed tiles with a set _width unaffected.
Cause: unpin.ts:89 writes _widthMin:tablet_portrait = min(Wpx,100%). Auto-layout tiles have no _width, only a px _widthMin, so that px floor was the only thing sizing the tile when the row measures its content; Chrome ignores the 100% part while sizing a hugging row (row 289px instead of 333 at 990). Restoring min-width:56px, or adding width:56px next to the floor, restores 333px and one line.
Fix direction: give the tile a definite px width/basis next to the capped floor whenever it has no set width. Browser test: hugging row + auto-layout tile + one-line label at 990/768/600/480 asserting label height equals main, plus 375/360/320 no-spill.
F2 (medium): rule collision — size.unpin and row.icons both write widthMin at tablet_portrait (framed painted 64x64 tile beside 24px icon; unpainted fixed 90x24 'Read more' frame beside 16px arrow). Main: none. Fix: add !besideIcon to the tile condition (unpin.ts:87-88) as the old step-down did; consider skipping firmAt reservation in icon rows; unit test asserting no collisions.
F3 (low): rows with a non-button compact tile (64x64 photo-painted, 88x88 number-over-caption) beside 210px paragraph + 900px column now go two-per-row on tablets (sharesHold's paragraph/200px checks run once something is held). Arguably better. Pin with a unit test (add a photo-painted tile fixture), note in HANDOFF, and note for responsive-pill-planning to re-baseline.
F4 (low, tests): removing `tier !== "fluid"` guard in shapes.ts firmAt survives all tests — add a test that laptops never reserve; plan-width check in unpin tile condition survives focused tests — add one if cheap.
F5 (info): laptops 992–1199 still shrink (58.9x64 @992, 64 @991). Out of scope; record in HANDOFF as deferred and do not imply laptop is fixed in the paste check.
Builder rulings 1–3 judged sound.

## Do
1. Load figma-to-bricks (FINISHER role for the fix part), receiving-code-review, test-driven-development, systematic-debugging, git-commit-rules. Verify each finding yourself; fix valid ones test-first; push back with evidence otherwise.
2. Also check the reviewer's unverified lead: unpin.ts:106 `min(Npx,100%)` button floors at mobile_portrait in a hugging row may cause the same wrap on phones. If verified AND within the plan's files, fix with the same approach and a test; else record it.
3. Rebase onto current main 748dca8 (keep both HANDOFF sections; paste check = next free after 3aw at merge, keep it provisional). Run npm run check, npm run test:browser, npm run corpus vs saved baseline (cmp pastes; element-diff; measure 375/360/320).
4. Commit, stop at ready-for-review. Update ledger/HANDOFF. Never reset/stash/discard.
