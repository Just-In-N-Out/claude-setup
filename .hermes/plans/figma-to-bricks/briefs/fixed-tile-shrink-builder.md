# fixed-tile-shrink — BUILDER brief (2026-10-21 ~20:32 EDT)

Approved under Justin's autonomous grant for the round-4 batches (see briefs/autonomous-round4-planners.md). Plan: ~/.hermes/plans/figma-to-bricks/fixed-tile-shrink.md — the plan is approved; do not re-plan. Follow its TDD tasks 0–4 and its Docs & records task (records in the worktree only).

## The bug
Fixed 64x64 tiles shrink on tablets (to about 59x62.6 at 990 and 51.9x62.6 at 768). They should keep their fixed size. The plan names the exact causal path, the owned files (kinds/shapes/rows/unpin) and the 28 diagnostic controls; those controls are evidence, not implementation.

## Rules
1. New worktree from main 5e32aec (build 2026-10-21.22): .claude/worktrees/fixed-tile-shrink, branch worktree-fixed-tile-shrink (figma-to-bricks Step 2).
2. Keep Justin's ALONE and grid decisions unchanged. General logic only; generic fixtures with varied dimensions; measure in Chrome at 375, 360 and 320 as well as the corpus widths.
3. Save the full corpus baseline (report, pastes, HTML) before the first source change; before/after shots per the project skill.
4. Other running builders: phone-recognition-guards (normalise: address/contacts/titles/page links) and font-reporting-tests (font tests). Stay inside this plan's files. responsive-pill-planning and gro-composition-clipping are queued behind you and share layout outputs: do not touch their files.
5. Stagger heavy Chrome/corpus runs if the browser is busy; re-run a flaky test before calling it a regression; preserve failed raw runs.
6. Stop at ready-for-review: committed, npm run check, npm run test:browser and corpus green vs baseline. No merge, push, BUILD bump or CLAUDE.md edit. Paste check: "next free on main at merge time" only.
7. Other bugs go in found_else, not the fix. Out of steps: commit what passes and stop with the worktree and last commit.
