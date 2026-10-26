# Brief: BUILDER for figma-to-bricks feature "hero-photo-blend"

Build the approved plan `~/.hermes/plans/figma-to-bricks/hero-photo-blend.md` (Justin: go = A1 B1 C1: every shadowed picture uses `filter: drop-shadow(...)` instead of box-shadow, same blur value; keep the faint frame (it's Figma's stroke); old pages fixed by re-convert + re-paste + Purge All). Opus 5.5 medium. Don't re-plan.

Root cause (planner): src/core/style/paint.ts boxPaint l.216–222 (→ _boxShadow via emit/settings.ts l.146–149) is called for every picture from style/picture.ts l.55/57/59, with no picture case; a box-shadow is always a rectangle, so a see-through cut-out (Remanufactured hero cylinder #brxe-tlriak, AVIF 63.6% clear) shows a dark square ring. Evidence ~/.hermes/plans/figma-to-bricks/evidence/hero-photo-blend/.

- Load `skill_view('figma-to-bricks')` (BUILDER: Step 2 through Step 3, skip item 6), `skill_view('test-driven-development')`, `skill_view('systematic-debugging')` on surprises. Say you loaded them.
- Worktree `.claude/worktrees/hero-photo-blend`, branch `worktree-hero-photo-blend`, from main **2026-10-21.14** (photo-hover-glass just merged: showcase classes changed in style/classes.ts; the zoom copy is `.showcase-photo::before` with an allow-list guard test — your `filter` must not break the zoom or trip the guard; check the plan's stacking-layer risk in the browser test).
- Spread or inner shadow on a picture keeps box-shadow + a warning; layer blur merges into the same `filter`; hover states use filter too; blur value unchanged (pin it in test 1). Filled boxes unchanged.
- Before/after pictures: the planner's live reproduction (live-now-1728.png vs fixed) plus a generic fixture via `npm run snap` at 1728/1440/768; pairs to `~/.hermes/plans/figma-to-bricks/shots/hero-photo-blend/`, paths in `shots[]`.
- In flight: layout-floors (reviewing; adapt/), csv-list-pdfs (finishing; lists/ui), text-link-followups (finishing; normalise/emit/rag). None should touch paint.ts/picture.ts/states.ts. Whoever merges second rebases, keeps both HANDOFF sections, takes the next free paste check (3am/3an taken; check main).
- Plan copy, ledger, HANDOFF with the paste check owed (re-paste Remanufactured; checker measures the edge step at the cylinder box is gone). Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else` (the pale fringe under the cylinder is already in found-else; don't fix).
- Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse (list exactly what changed: Home's bento photo CSS expected); not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
- Plain words for WhatsApp.
