# FINISHER: layout-floors (B5)

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/layout-floors, branch worktree-layout-floors, tip 8e1a5ec. Plan ~/.hermes/plans/figma-to-bricks/layout-floors.md (F1A F2A F3A + addenda). Model: as dispatched (Opus 5.5 medium, or Sol 6.1 xhigh if Justin said "sol").

Load skill_view('figma-to-bricks') (FINISHER), receiving-code-review, git-commit-rules, test-driven-development, and systematic-debugging; say you loaded them.

**Justin's answer to L1 (narrow phones): see the "Justin's answers" section at the end of the plan — apply it.**

## Fresh Opus xhigh reviewer: request_changes (verbatim essentials; probes/shots in ~/.hermes/cache/scratch/lf-review/)
- Verified OK: gates (1493+6, browser 156/156), corpus unchanged, item 1 (Repairs title 31→163 at 480, 155→253 at 768), circles 82×82, item 7 (Services row 111→87), layout.ts split byte-identical, no keying on Justin's data, files ≤184 lines.
- **F1 medium (introduced, F2A PHONE_SIDE 32):** on phones narrower than 390 the extra 24px leaves fixed-width content no room. hydraulics "Emergency Call 24/7" (lrdbna, min-width 279, words 197.2px): main one line (57 tall) at 375/360; branch two lines (82) at both; at 320 it reaches x=327, page scrollWidth 320→327, snap lint overflow-x @320 0→1. final-design @320: 12 full-width buttons wrap 56→72 (incl. "call +1 (812) 473-1900"). design @320: "Book your Appointment" cut by photo panel bchack, +8 spills. Shots hyd-{360,320}-{base,branch}.png. Suggested general guard: on upright phones a side gives way (toward 20) when 2×side + content's layout.least + a few px slack > planned width. → apply Justin's L1 answer; test at 375/360/320 in Chrome (add those widths to your own checks; corpus only measures ≥390).
- **F2 medium (introduced, unpin.ts `at` = first narrower tier):** item 2 keeps drawn height where the box is WIDER than drawn too (beyond F1A's "keeps its drawn width"). Services rkcwru "States" (fixed 440×151 wrapping pill row) is 918/696/568 wide × 151 at 990/768/600 (main 98); second pill line ~38px below the first instead of 10. Also boujxo 69→90 at 390, hyinwl +11px. (Wider-keeping helps final-design's team photo cards: keep that.) Fix: pack a wrapped row's lines at the top (align-content:flex-start, as Figma does) and/or let drawn-wrapping rows let go where wider. Test.
- **F3 low (ruling 2):** item 5's uneven alike pills come back (inspo ugzebt pills 26/26/28 at 390 vs 28/28/28 on main) because F2A narrows the column. F3A (approved) would even them: implement if small, else record open.
- **F4 low (ruling 4):** inspo regression is bigger than HANDOFF says: at 390, 5 new spills (udrbuj/qhjfde pill labels 4–9px; euwsuo, dhjoci, ukujcm "explore strategy"), words column 158→134 (qtcwtm 7→10 lines); at 360 2 more; at 320 the column is 64px. Reviewer agrees to keep F2A for inspo (experiment file, already broken on main); correct HANDOFF. Re-check after your F1 guard: it may fix these too.
- **F5 info (ruling 1):** top/bottom rule is sound; CLAUDE.md text must say "left/right at most 32 on upright phones; top/bottom at most 40, never below min(drawn, 32)".
- **F6 low (ruling 5):** sideways phones: stepSide(40)=40 skipped but 48→40 written: inconsistent. Make it consistent (write back or skip by one rule) with a test.
- **F7 low:** surviving mutations M12 (broken divided row's evened side not stepped: no fixture with a divided item side ≥33 on phones — add one) and M14 (wrap floor at every tier, no real difference: note it).
- **F8:** paste checks 3am–3ap are taken on main; take the next free (3aq if free) everywhere. HANDOFF conflict only on rebase.
- Reviewer found_else are in found-else.md (ceil button floors, no <390 checks, align-content stretch, inspo carousel, twoShare at 990/768, hydraulics @320 on main): not yours except where your F1/F2 fix covers them; say which.

## Then finish
Rebase on main (2026-10-21.16+; src changes since base don't touch adapt/). Gates: npm run check, npm run test:browser, npm run corpus, plus your own Chrome checks of Justin's pages (hydraulics, Repairs, Services from the debug file scratch copy) at 375/360/320. Re-shoot after pictures if output changed. Merge lock, ff-only merge, next BUILD, npm run build, commit `Build <BUILD>: layout floors`, push, verify. Release the lock on every path.
CLAUDE.md: if denied, don't retry: ~/.hermes/plans/figma-to-bricks/layout-floors-claude-md-pending.md (build line last; F5 wording; rulings as not yet confirmed). Never overwrite other pending files.
found-else.md: mark exactly the B5 items fixed. Remove worktree/branch after merge. pill-clip (Sol xhigh) builds right after you merge.
Return status, build, last_commit, summary, paste check, steps_for_justin, shots, rulings, found_else, pending_docs. Plain words.
