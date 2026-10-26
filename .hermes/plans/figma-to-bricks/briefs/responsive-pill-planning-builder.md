# responsive-pill-planning — BUILDER brief (2026-10-21 23:26 EDT)

Opus medium. Approved under Justin's autonomous round-4 grant and his away rule (take the recommended answer). Plan: ~/.hermes/plans/figma-to-bricks/responsive-pill-planning.md — approved including its "Dispatcher ruling" at the top; do not re-plan. Planner evidence: evidence/responsive-pill-planning/planner-main22/.

## Base has moved since the plan (re-baseline!)
Plan was read on main .22 5e32aec. Main is now 5474523 (build .25): .23 phone-recognition-guards (normalise only), .24 hero-photo-blend (picture shadows: style/paint, picture-shadow, picture), .25 fixed-tile-shrink (kinds/shapes/rows/unpin AND a small layout.ts change passing the row to the tile check; listLine export in kinds.ts; F3 row-shape change: non-button compact tile + paragraph + wide column goes two-per-row on tablets). Recompute every line reference and reproduce RED/baselines on 5474523. Re-measure the inspo arrow-row allocation (plan: record the outcome; do not expand scope).

## Scope (from plan)
F3 bounded peer-side equalization (sides.ts / layout.ts child pre-pass + hug slot map / least.ts view() only / space.ts:64-73 SideView). G1 parent-slot room for hug-button phone guards as a SEPARATE droppable commit with corpus-wide ≤2px claims measured. Wrapped-row least = option A DEFER. No blanket ceil. Preserve every numeric least result, grid/row-shape/ALONE decisions, P1A/P2B/L1A. kinds/shapes/rows/unpin are read-only (fixed-tile's). GRO's files (style/place.ts, adapt/rules/compose.ts, and any new rule file its fix pass adds) read-only; GRO is in a fix pass in another worktree.

## Test exceptions (pre-granted by the dispatcher, narrowly)
Existing unit/golden tests that pin exact hug-button phone side values (e.g. '27.5', 'clamp(20px' strings, phoneSide at drawn width) MAY be updated only where the approved F3/G1 change directly contradicts them: list each in the ledger with old → new value and why, replace with stronger assertions of the new behaviour, change nothing else in those files. Anything guarding other behaviour → stop with exact RED and options. The fresh reviewer will judge every exception.

## Rules
1. New worktree .claude/worktrees/responsive-pill-planning, branch worktree-responsive-pill-planning, from main 5474523.
2. Full corpus baseline saved before the first source change; before/after shots incl. phones 375/360/320 (Chrome measurements required by the project skill for any phone padding change) and laptop widths 1024–1440 (gates are blind there — measure row right edges yourself).
3. Stop at ready-for-review: committed; check, test:browser, corpus vs baseline. No merge/push/BUILD/CLAUDE.md. Paste check: next free at merge (3aw/3ax/3ay taken; GRO holds provisional 3az).
4. Other bugs → found_else. Out of steps: commit what passes and stop. Always pass workdir. GRO fix pass runs Chrome in parallel; stagger.
