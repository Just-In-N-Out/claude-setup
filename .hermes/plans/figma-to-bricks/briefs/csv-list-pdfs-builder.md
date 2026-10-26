# Brief: BUILDER for figma-to-bricks feature "csv-list-pdfs"

Build the approved plan `~/.hermes/plans/figma-to-bricks/csv-list-pdfs.md` (Justin: go = all ⭐, 1A–6A). Opus 5.5 medium. Don't re-plan.

**Justin's added note (read the plan's "Justin's answers"):** the plugin must find the list's download button in the Figma design by itself (his real case: "Download Full Inventory (PDF)" under the 78-row parts table on Services Page Final, no link today) and link it to the picked PDF. The panel shows which button it found. Detect generally: a Button/pill in the list's section outside the rows, with a download/PDF label or download icon as a tie-breaker under the project's English lexical convention; never key on his words, layer names or ids. None or several plausible: say so in the panel and let him pick. Add this to the plan copy's tasks (test first, generic fixture with 0/1/2 candidate buttons).

- Load `skill_view('figma-to-bricks')` (BUILDER: Step 2 through Step 3, skip item 6), `skill_view('test-driven-development')`, `skill_view('systematic-debugging')` on surprises. Say you loaded them.
- Worktree `.claude/worktrees/csv-list-pdfs`, branch `worktree-csv-list-pdfs`, from main (2026-10-21.12 or newer).
- Respect link-upload-fixes (.11) rules: explicit slug, `-pdf` suffix, media never on a page's address, `assertPayload` allows direct document links, PDFs kept out of picture-repair moves (own cache record, test pinned). Bricks keys only from `reference/bricks/*.json` samples (the external-link sample is missing: say how you handled it, don't invent new keys).
- No PDFs saved → output byte-identical to today (prove with corpus + list fixtures).
- Never write to the live site; WordPress upload tests use stubs.
- In flight: layout-floors (Opus, adapt), photo-hover-glass (Opus, style/classes.ts), text-link-followups (Sol: emit/elements.ts, ui/site-pages.ts, normalise/contact-links, style/rag, emit/page-addresses), google-font-hardening (ui/fonts.ts). Keep `ui/main.ts` edits to wiring lines. Whoever merges second rebases, keeps both HANDOFF sections, takes the next free paste check.
- Text proof (each button → its PDF address, before/after) plus a panel screenshot of the "Add PDFs" step if you can render the panel in the browser tests. Paths in `shots[]`.
- Plan copy, ledger, HANDOFF with the paste check owed (Services: upload the inventory PDF, convert, paste, the Download Full Inventory button opens it). Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`.
- Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse; not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
- Plain words for WhatsApp.
