---
name: website-rules-semantics-a11y
description: "Website rules work (build 2026-10-02.1): semantic HTML + WCAG 2.2 AA with no visual change; phases 5 (lists/figure) and 6 (popover) wait for the Bricks check page"
metadata:
  node_type: memory
  type: project
  originSessionId: 78ef296b-f4c7-4c15-b950-27959cb3b6c5
  modified: 2026-10-02T18:09:43.051Z
---

On 2026-10-02 the plugin gained "website rules" (the director pointed at W3Schools' HTML5 semantic elements and W3C WCAG; the user means technical rules, not laws). Done in build 2026-10-02.1: findings panel with Show, audit (contrast, target size, clipped text, words in pictures, endless motion, # links), keyboard ring / reduced motion / pause control / focus-within dropdowns, heading outline, nav landmarks, alt text (annotation → panel-saved plugin data `f2b-alt` → descriptive name), link names, reading order, nesting repairs, paragraphs as `<p>`. Decisions are in project CLAUDE.md ("Website rules").

**2026-10-02, after trying it:** the user got hundreds of findings (a table-heavy website import) and said "I just want to implement these rules". The design check (audit list) is now an option that is off by default (build 2026-10-02.2). They also reported "photos are not loading"; the cause was not found yet and a debug file was requested. The panel's photo thumbnails were removed (memory risk). On that file, table cells showed false contrast errors (1.00:1, white text on a dark row the backdrop walk missed), still to fix from the debug file.

**Pending:** the user pastes the output of `node tests/tools/bricks-check.js` into their Bricks site and reads the live page source. Only after that:
- Phase 5: nav/footer links as `ul`/`li`, rows of 3+ alike cards as lists, optional `figure`/`figcaption`.
- Phase 6: pop-ups and click dropdowns on the built-in `popover` + `popovertarget` (user approved, still no script).

**Open question for the user:** a hover component inside a link keeps its phone tap control. On phones a tap then shows the hover state and the link doesn't open (finding `tapInLink`; 3 such links in final-design.json). It was asked on 2026-10-02 and is unanswered.

**Why:** both phases rely on Bricks keeping custom tags and boolean attributes, which nobody has confirmed in Bricks.

**How to apply:** check whether the Bricks check was reported before starting phase 5 or 6. Use `tests/tools/same-look.js` against a copy of the previous build to prove a change keeps the look.

Related: [[user-means-rules-not-laws]], [[main-component-animations-stage2]].
