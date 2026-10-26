# gro-composition-clipping — NEW fresh REVIEWER brief (after fix pass), 2026-10-21 23:38 EDT

Review only, Opus xhigh. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/gro-composition-clipping, tip 80fb4fd, rebased on main 5474523 (build .25). Review the whole `git diff main...HEAD` against the plan ~/.hermes/plans/figma-to-bricks/gro-composition-clipping.md, briefs/gro-composition-clipping-builder.md and briefs/gro-composition-clipping-fixpass.md (first review findings F1–F5 + dispatcher ruling (c)). First review evidence: evidence/gro-composition-clipping-review/ (laptop-slack.txt, gro-measure.json, probe-fullphoto.ts, mutation hook). Fix-pass shots: shots/gro-composition-clipping/fixpass/.

## Fix pass claims (verify)
- F1: base nudge back to main's whole-row share; free-space share written ONLY at tablet_portrait by NEW src/core/adapt/rules/nudge.ts (row.nudge; skipped where the row stacks on tablets). GRO rects identical to main at 1440/1300/1200/1100/1024/992; laptop shots byte-identical. G2/G3/G5 still fixed from 991 down.
- F2/F3: footer twin retuned (A1 fails on Footer @768), same-line overlap check (A3), unit controls A4/A5/A7. 10/10 mutants RED.
- F4: a card joining across a section takes calc(100% - 2×gutter) at its tier (only for section/band joins; Container joins keep auto). probe-fullphoto: card height = content at 600/480/390.
- F5 records; paste check 3az adds 1280/1024.
- Gates: check 1971+6, browser 207/207; corpus: other 4 pastes byte-identical; GRO lint errors 615→612; GRO diff vs main = 17 _margin:tablet_portrait + wxjdlj _height/_width tablet/landscape.

## Check especially
1. The new rule file: does row.nudge collide with any other rule writing _margin at tablet_portrait (space.ts, sides, layout)? Declared overrides per project rules; corpus-convert collision test.
2. Tablet_portrait-only output: behaviour at 991–768 vs 767–480 vs phones (tiers below inherit?); 375/360/320 no sideways scroll; GRO sweep at the 23 widths from the first review.
3. F4 width calc at gutter tiers; Container vs section joins; aspect-ratio photos.
4. Element diff main vs branch: corpus + scratch copy of user's debug file + inspo brainstorm.
5. Interaction: responsive-pill-planning builder is now running in another worktree, owning sides.ts/layout.ts/least.ts/space.ts:64-73 — flag any shared-output risk.
Change nothing; restore anything; kill only orphan Chrome; always pass workdir. Other bugs → found_else.
