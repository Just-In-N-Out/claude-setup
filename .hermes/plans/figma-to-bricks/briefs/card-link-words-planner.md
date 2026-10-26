# Brief: PLANNER for figma-to-bricks feature "card-link-words"

## The ask (rewritten)
Justin's ruling on the frame-text-links review's F4 (build 2026-10-21.5): today, when the words inside a card (its title, or a "Learn more") carry a designer's link — a link to another Figma frame, and already before that a typed web address — the card no longer becomes a whole-card link, and a painted pill whose label words carry the link becomes a Div with a linked text instead of a Bricks Button. Justin wants the **whole card** behaviour back: the card is the link (whole-card link, using the words' link target), and a pill whose label carries the link stays a Button that links there. Done = with a frame link or a typed address in a card's title / "Learn more" / a pill's label, the paste gives a whole-card link and a Button, the same as an un-linked card with a Figma Navigate or arrow, with the words' link deciding the address; no nested links.

Open question to put first: should this apply to typed web-address text links too (they behaved this way before 21.5), or only to frame links? Recommend the option that's consistent with "the whole card is the link" (Justin's standing decision), and say what changes on his pages and in the corpus for each.

Also check the Call/Email case the finisher mentioned: a Call/Email button whose label carries a link keeps it instead of the nearest number. Say what whole-card means there.

Justin's words: "Whole card" (answer to: "when words inside a card link to a frame, only those words are clickable now. Keep it like that? Reply keep or whole card.")

## Evidence to start from
- frame-text-links reviewer F4: "A card whose words are linked to a frame no longer becomes a whole-card link from its title or arrow. A painted pill whose label words carry the link is no longer a Bricks Button: it becomes a Div with a linked text... Typed web-address text links already work this way." Introduced in 2da4ea1 (run links count as links in normalise/page-links.ts:46 and in buttonLabel). Probe: ~/.hermes/cache/scratch/ftl-review/button.ts.
- CLAUDE.md "Where things stand" → "Words linked to another frame" (Behaviour change, not yet confirmed) and the decision "A link never opens a picture" → links to pages; Justin's decisions "the whole card is the link" and "Buttons by shape alone".

## How
1. `skill_view('figma-to-bricks')`, PLANNER role; `references/rules-summary.md` first, then only the CLAUDE.md link / card / button sections. `skill_view('systematic-debugging')` (it's a behaviour bug against his decision): root cause with file/line evidence.
2. No worktree, code or commit. Main is build 2026-10-21.7 (`aa19bae`).
3. Save the plan to `~/.hermes/plans/figma-to-bricks/card-link-words.md`: title, Open questions (lettered, ⭐ recommended, plan written as if ⭐), playback, root cause, approach, tasks (test first), tests (generic fixture), risks, files touched, overlaps, **Docs & records** (incl. updating CLAUDE.md's decision and the "not yet confirmed" lines to Justin's ruling), Other things found.
4. Overlaps to name: text-link-followups (B7, queued, edits understand/page-links.ts, emit/page-addresses.ts, emit/text-links.ts, normalise/contact-links.ts); link-upload-fixes (B2, building: normalise/links.ts, emit/payload.ts, ui/site-*); text-breaks (B3, building). Say which must go first.
5. You can't ask Justin: questions go in `questions` with 2–4 short options and one recommended. Other bugs: `found_else`. Plain words for WhatsApp.
