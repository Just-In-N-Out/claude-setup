# Brief: BUILDER for figma-to-bricks feature "photo-hover-glass"

Build the approved plan `~/.hermes/plans/figma-to-bricks/photo-hover-glass.md` (Justin: go = A1 B1 C1: remove only the glare stripe; the 110% zoom, its clip/isolation, the figure tag and the card fade-in stay; already-pasted pages get fixed by one re-paste with "replace" in Bricks' class box). Opus 5.5 medium. Don't re-plan.

- Load `skill_view('figma-to-bricks')` (BUILDER: Step 2 through Step 3, skip item 6), `skill_view('test-driven-development')`, `skill_view('systematic-debugging')` on surprises. Say you loaded them.
- Worktree `.claude/worktrees/photo-hover-glass`, branch `worktree-photo-hover-glass`, from main (build 2026-10-21.12 or newer).
- Before pictures from the untouched copy (a showcase photo on hover, e.g. hydraulics-home or inspo corpus, desktop) and after; pairs to `~/.hermes/plans/figma-to-bricks/shots/photo-hover-glass/`, paths in `shots[]`. A short hover video/frames is fine if a still can't show a sweep: at least one frame mid-hover before and after.
- General rule: no glare/shine/glass ::after on any showcase class; a guard test so it can't come back from the Staff sample. The CLAUDE.md rule text goes in the plan's Docs & records for the finisher; don't edit CLAUDE.md.
- In flight: layout-floors (Opus, adapt/), text-link-followups (Sol: normalise/contact-links, style/rag, emit/page-addresses, emit/elements, ui/site-pages), google-font-hardening (ui/fonts.ts, finishing). Skip the emit/elements.ts comment edit (shared). Whoever merges second rebases, keeps both HANDOFF sections, takes the next free paste check.
- Plan copy, ledger, HANDOFF with the paste check owed (re-paste Home or Services with "replace" in the class box; checker confirms `showcase-glare` is gone from the live CSS). Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`.
- Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser` (should be all green since .12), `npm run corpus` no worse (only showcase class settings may change; list exactly what changed); not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
- Plain words for WhatsApp.
