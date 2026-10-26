# Brief: BUILDER for figma-to-bricks feature "pdf-new-tab" (small, Sol 6.1 high)

## The ask (Justin approved: "every link that is a pdf when clicked should open up a new tab")
Every link in a paste whose target is a PDF file opens in a new browser tab instead of the same tab. That covers: the CSV list download buttons and row buttons from csv-list-pdfs (build .16), a Figma link typed to a .pdf, and a PDF address in a CSV column. Non-PDF links are unchanged (pages, other websites, tel:, mailto:, other documents like .docx stay as today). Done = on the pasted page, clicking any PDF link opens the PDF in a new tab (with rel="noopener"), everything else behaves as before.

## No plan file yet: write a short one first
Write `~/.hermes/plans/figma-to-bricks/pdf-new-tab.md` (playback, where links are emitted, approach, tasks, tests, Docs & records), copy it into the worktree's docs/plans, then build. No need to wait for approval (Justin's message is the go). If a real trade-off appears, rule it ("My ruling, not yet confirmed").

## The Bricks key (the hard part)
CLAUDE.md rule: Bricks emitters only from `reference/bricks/*.json` samples, never from memory. There is no sample with an "open in new tab" link (grep found no `newTab` in reference/bricks or src). Justin didn't send one. So:
1. Look for source-backed evidence of how Bricks stores "open in new tab" on a link control (e.g. `link: {type:'external', url, newTab: true}`): any existing reference sample with a link object, Bricks' official docs/academy, Bricks' public element JSON exports or templates on the web (read only). Record what you find with URLs in the plan.
2. If you find solid evidence, use the link control's own new-tab setting and add a reference sample file built from that evidence (say clearly it's documented, not copied from Bricks).
3. If not: fall back to what the plugin already emits safely (e.g. `_attributes` target="_blank" + rel="noopener noreferrer" if an existing sample shows `_attributes`, or the anchor attributes in text HTML for text links), and say which.
4. Either way, stop and report `status: stopped` with the exact copy-paste sample request if neither is verifiable. Don't invent keys.

## How
- Load `skill_view('figma-to-bricks')` (BUILDER: Step 2 through Step 3, skip item 6), `skill_view('test-driven-development')`, `skill_view('systematic-debugging')` on surprises. Say you loaded them.
- Worktree `.claude/worktrees/pdf-new-tab`, branch `worktree-pdf-new-tab`, from main **2026-10-21.16+**.
- Detect PDF links generally (the URL path ends in .pdf, case-insensitive, query/hash ignored; reuse normalise/links.ts / fileAddressKind classification if it has a document kind). Text links inside rich text (`<a href>` in text HTML) get target="_blank" rel="noopener" too, preserving B7's tabindex on marquee copies and B2's relinking (ui/text-links.ts keeps other attributes).
- assertPayload must still pass; byte-identical output for designs without PDF links (prove on corpus + Justin's debug file).
- In flight: card-link-words (Sol: normalise/label-links.ts, normalise.ts one call), hero-photo-blend worktree (style/ picture shadow), layout-floors worktree (adapt). Stay out of their files; whoever merges second rebases, keeps both HANDOFF sections, takes the next free paste check (3am–3ap taken).
- Text proof: each PDF link before/after (href, target, rel). Plan copy, ledger, HANDOFF with the paste check (Services: Download Full Inventory opens in a new tab). Leave BUILD and CLAUDE.md alone. Other bugs: `found_else`.
- Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse; not merged.
- Plain words for WhatsApp.

Justin's words: "Tell the agent that is on the pdf that when a user clicks the download pdf it should open up a new tab of the pdf and not open it on the same tab." then "No like every link that is a pdf when clicked should open up a new tab give that to an agent."
