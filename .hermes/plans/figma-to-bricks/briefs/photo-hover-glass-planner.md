# Brief: PLANNER for figma-to-bricks feature "photo-hover-glass" (bug)

## The ask (rewritten)
Bug: when the mouse hovers over a photo (a media/picture element) on a pasted page, a "glass" flicker effect plays — a shine/sheen/glass sweep or flash over the picture. Justin doesn't want it. Expected: hovering a photo shows no glass/shine flicker. Done = no glass effect on photo hover in new pastes, general rule (every design), nothing else about hover (links, buttons, cards, the showcase "number above photo" hover) changes unless it's the same glass effect.

He didn't send a screenshot or name a page. Find out where the effect comes from:
- Our own output: search the emitter/style code for a hover sheen/shine/glass/backdrop-filter/::before or ::after sweep, a `transition` on pictures, an image hover class or a Bricks interaction the paste adds (src/core/style/picture.ts — just split out of style.ts in build .12 —, style/, emit/, adapt/rules/, global classes). Also check whether Figma designs carry it (a hover/prototype interaction, a glass layer, a background blur) and the plugin copies it.
- Or the site, not the paste: a Bricks theme style / global setting / a Bricks image element's own hover default, or a "glass" effect from Bricks' image element. Read the live site read only (the site is in CLAUDE.md "The user's live site"; published pages over HTTP; never log in or change anything). If it's a site setting, say so and give Justin the click path instead of a code fix.
- Check "flicker": could also be a hover transform/scale or filter causing repaint flicker (e.g. `transform` + `overflow:hidden` + border-radius on Safari/Chrome, backdrop-filter). Reproduce in the real renderer / system Chrome at desktop width with a hover, on the corpus files and Justin's debug file (read-only copy), and on a live page.
- Name 2–3 likely live pages where he'd see it.

Root cause with file/line evidence before planning the fix (systematic-debugging). If the cause is ambiguous between "remove the effect" and "keep the effect but stop the flicker", make that question 1 with lettered options, ⭐ on removing the glass effect (his words: "I do not want").

## Constraints
- Load `skill_view('figma-to-bricks')` (PLANNER) and `skill_view('systematic-debugging')`; say so. rules-summary first, then only the CLAUDE.md sections you need.
- No worktree, code or commit. Plan to `~/.hermes/plans/figma-to-bricks/photo-hover-glass.md`, questions at the top (lettered, ⭐, each option under ~60 chars), plan written as if ⭐ chosen. End with the Docs & records task.
- Size: Opus 5.5 medium builder (Justin's pick), Opus xhigh reviewer. If it turns out a one-line site setting, say so.
- In flight: layout-floors (Opus, adapt/layout, least, unpin, rows, space), text-link-followups (Sol: normalise/contact-links, style/rag, emit/page-addresses, emit/elements, ui/site-pages), google-font-hardening (ui/fonts.ts), card-link-words planner. Name file overlaps with each.
- Other bugs: `found_else`, don't fold in.
- Plain words for WhatsApp.

Justin's words: "We have an issue, when it comes to hovering over a media photo, there is this glass flicker I do not want that can we remove it. Put it on an opus 5.5 medium agent to fix."
