# Brief: PLANNER (revise mode) for figma-to-bricks feature "card-link-words"

Revise the existing plan `~/.hermes/plans/figma-to-bricks/card-link-words.md` with Justin's answers, which are at its end:
- **A1:** typed web-address links and frame links follow the same rule.
- **B1:** a Call/Email button whose label words carry a link becomes a Button going where its words link.
- **C2** (differs from the old ⭐): a pill / "Learn more" whose label carries the link becomes a **Bricks Button** that links there; the card is **not** linked whole. His words: "I only want learn more to be linked let's say not the whole card".
- **Title only:** a card whose **title** words carry a link: only the title is linked; the card is never a whole-card link because of words' links.

So the change is much smaller than the old plan: no moving a text's link up to the card. What's needed: a painted pill (and an arrow "Learn more" pill) whose label words carry a link (frame or typed) becomes a Bricks Button with that link, its words plain inside (no nested link), instead of today's Div with a linked text; Call/Email per B1; titles stay linked words. Check whether the old plan's card-scope.ts move is still needed (probably not).

Revise mode: read the existing plan first, then only the code it touches (understand/widgets.ts buttonLabel, normalise/contact-links.ts holdsLink, normalise/page-links.ts, emit/page-addresses.ts for the site check of a Button's link). Skip the full Step 1 load (read `references/rules-summary.md` only). Write the revised plan within about 15 steps; anything unchecked becomes a builder task ("check X first"). Keep the open-questions section at the top (lettered, ⭐), with any new question only if truly needed. Keep the Docs & records task (CLAUDE.md: replace the "not yet confirmed" F4 lines with Justin's ruling). Say overlaps with text-link-followups (now BUILDING on Sol: it edits normalise/contact-links.ts, emit/page-addresses.ts, understand/page-links.ts, emit/elements.ts, ui/site-pages.ts). This feature's builder will start only after text-link-followups merges, so plan on top of its changes (read its plan `~/.hermes/plans/figma-to-bricks/text-link-followups.md`; don't read its worktree as final). Main is build 2026-10-21.11+.

Load `skill_view('figma-to-bricks')` (PLANNER role). No worktree, code or commit. Plain words for WhatsApp. Output: plan_path, summary, questions, risks, touches, overlaps, found_else.
