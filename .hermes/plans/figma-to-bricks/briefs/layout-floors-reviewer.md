# REVIEWER only: layout-floors (B5)

Fresh reviewer, Opus xhigh. Load skill_view('figma-to-bricks') (REVIEWER) and skill_view('requesting-code-review') (report only, never auto-fix); say you loaded them.

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/layout-floors, branch worktree-layout-floors, tip 8e1a5ec. Plan ~/.hermes/plans/figma-to-bricks/layout-floors.md (F1A F2A F3A + 2 addenda; equal-card R5). Review `git diff $(git merge-base main HEAD)...HEAD`. Main is now 2026-10-21.13+ (photo-hover-glass / csv-list-pdfs / text-link-followups may land meanwhile).

Builder claims: item 1 Repairs titles 31→163px at 480 via a one-line-width floor `min(<least>px,100%)` in rows.ts; item 2 F1A in unpin.ts: fixed-both-ways box keeps its drawn height (82×82 circle back), photo-painted box keeps aspect-ratio only while its content fits; items 3/4/6/7 + Addendum 2 top/bottom: new adapt/sides.ts single side function for space.ramp and the plan, each side ≤32 on upright phones, cascade counted; Services parts table 24px shorter at 768; twoShare fixed; layout.ts split 115+184+30, byte-identical replays; item 5 dropped (no longer reproduces). check 1493+6; browser 156/156; corpus: same 17 items, lint counts and scores equal, only heights at 390/768 changed. Shots ~/.hermes/plans/figma-to-bricks/shots/layout-floors/.

Judge the builder's 5 rulings: (1) top/bottom on upright phones min(40, max(ramp, min(v,32))) (39→32, 40→32, 64→32, 80→40) — note 80→40 > 32 contradicts "at most 32"?; (2) item 5 no code; (3) photo aspect ratio only while content fits; (4) keep F2A though inspo 390 gets one more clipped text (card sides 20→32); (5) sideways phones never write a side back at its drawn value for every box (wider than before).

Check hard, at real paste widths (renderer + Chrome, measure rects, not just lint): Justin's pages (debug file scratch copy; corpus hydraulics) at 1440/1200/990/768/600/480/390/360/320: nothing newly clipped/overflowing; circles/photos keep shape; the inspo regression is real and whether a general fix exists within the plan; no keying on his names/ids/pixels; only adapt/rules writes breakpoint styles; files <~300 lines. Compare main vs branch element by element (skill pitfall). Run gates yourself, try mutations.

Change nothing: no commit/merge/push; restore anything; no live-site writes. Other agents running (photo-hover-glass finisher, csv-list-pdfs finisher, text-link-followups finisher) are separate; pill-clip builds after this merges (shares least.ts/layout). Other bugs: found_else.

Output: verdict pass/request_changes, findings [{id, severity, introduced, claim, evidence}], found_else. Plain words.
