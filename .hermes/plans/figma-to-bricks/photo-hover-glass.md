# photo-hover-glass: take the glare off photos on hover (bug)

**Approved by Justin 2026-10-21** ("go" = plan + A1 B1 C1 ⭐).

Planner: Opus 5.5. Skills loaded: `figma-to-bricks` (PLANNER), `systematic-debugging`.
Size: **Opus 5.5 medium builder** (Justin's pick), Opus xhigh reviewer. It's a small code change (one file plus
tests), not a site setting. Already-pasted pages need one extra step (question B).

## Questions (plan written as if ⭐ is chosen)

**A. What goes?**
- A1 ⭐ Remove only the glare; photo still zooms 110%
- A2 Remove the glare and the zoom (photo stays still)
- A3 Keep the glare, run it slower/softer

**B. Pages already pasted (Home, Services)?**
- B1 ⭐ Re-paste one page, pick "replace" in Bricks' class box
- B2 You delete the glare lines in 3 classes by hand
- B3 Leave old pages, fix new pastes only

**C. Card fade-in on load (not hover) stays?**
- C1 ⭐ Keep it, it isn't the glare
- C2 Remove it too

## Three facts (for WhatsApp)
1. The "glass" is our own effect: on hover a white see-through stripe slides across the photo once (1 s). Added
   19 Oct from your Staff card sample, "zoom + glare".
2. Fix: the plugin stops emitting the stripe. The photo still zooms; links, buttons, CTAs don't change.
3. Main risk: Home and Services keep the stripe until the site's 3 showcase classes are updated (one re-paste,
   choose "replace").

## Playback
1. When you put the mouse over a photo in a card row or a service/product listing, a shiny "glass" streak crosses it.
2. You don't want that streak on any page, from any design.
3. Everything else about hover stays as it is (the zoom, CTA lift, links, tags).

## Root cause (with evidence)

It's our paste, not Figma and not a Bricks/site setting.

- **Code:** `src/core/style/classes.ts` lines 75–78 and 81–84 (main `9334c37`, build `2026-10-21.12`):
  - `GLARE` (l.75–76) is an `::after` stripe: `position:absolute; left:-50%; width:50%; height:100%; z-index:1;
    background: linear-gradient(120deg, transparent, rgba(255,255,255,.4), transparent)`.
  - `SWEEP` (l.77) `animation: showcase-glare 1s ease-in-out` and `GLARE_KEYFRAMES` (l.78) slide it `left:-50% → 100%`.
  - `frame()` (l.81–84) puts `GLARE` on every showcase frame (`showcase-panel`, `showcase-photo`) and plays `SWEEP` on
    `:hover::after`; `showcaseClass("card")` (l.93–94) plays it again from `.showcase-card:hover`.
  - Which photos get it: `src/core/understand/showcase.ts` `markShowcases` (any row of 2+ photo cards, and 2+
    photo/text listing rows / zigzags). That's why it shows on "media" generally, not on one design.
- **Where it came from:** Justin's Staff card sample `reference/bricks/staff-card.json` (`::before` glare,
  `glare-slide` keyframes); built in 19.9 / 19.11 / 19.13 (HANDOFF "Product and team cards: photo zoom, glare and
  fade-in"; CLAUDE.md "Product and team cards", l.1122–1139: "the user chose New zoom + glare"). Justin is now reversing
  the glare half of that decision. His words ("glass flicker I do not want") are the new ruling.
- **Live site (read only, 2026-10-21):** the stripe is in the published CSS.
  - `/` (home, modified 21 Oct): 16 `showcase-panel`, 16 `showcase-card`, 3 `showcase-photo`; rules
    `.showcase-card:hover .showcase-panel::after { animation: showcase-glare 1s ease-in-out }`,
    `.showcase-panel:hover::after {…}`, `@keyframes showcase-glare { 0% {left:-50%} 100% {left:100%} }`.
  - `/services/`: 10 `showcase-panel`, the same `::after` stripe + keyframes.
  - No other page carries it. No `backdrop-filter`, no Bricks theme or image-element hover rule in the page CSS: the
    only `:hover` rules are our showcase ones and `.cta-motion:hover` (the CTA lift). So no site setting to flip.
- **Why it reads as "flicker":** it restarts every time the pointer enters. The card rule and the frame's own rule both
  trigger it, so moving from card text onto the photo can restart the sweep. Each hover flashes a white band.
- **Not Figma:** the hover is invented by the showcase rule. `understand/hover.ts` drops a showcase card's own Figma
  hover (l.8), so nothing from the design is copied here.
- **Repro:** `test/browser/showcase.test.ts` l.56/67/94/118 assert `animation-name` on `::after` is `showcase-glare`
  under the pointer (red-capable today, the exact symptom). Corpus `hydraulics-home.json` (service cards) and the
  inspo case-study cards are showcases too. Justin's current debug file (build 20.6, "Page 1") has no showcase:
  replay gave 0 `showcase-*` classes, so it can't show it. Couldn't hover the live page in a browser this run (the
  local Chrome profile was locked). The published CSS above is the live proof.

**Likely pages where he sees it:** Home (the card rows: team/services cards), Services (rows 001–005 media panels).

## Approach (A1 + B1 + C1)

Remove the glare from the showcase classes. Keep everything else:
- `showcase-panel` / `showcase-photo` keep `position: relative`, `overflow: hidden`, `isolation: isolate` (they clip
  the zoom; `isolation` holds the `::before` copy at `z-index:-1`).
- Zoom: `scale 0.5s ease` to 1.1 on hover, reduced-motion guard. Card fade-in: unchanged.
- Delete `GLARE`, `SWEEP`, `GLARE_KEYFRAMES` and every `::after` / `:hover::after` entry. No `@keyframes` on these
  classes any more. The `Style.keyframes` field stays (other code uses it).
- General: the change is in the class every showcase shares, so every design, every card row and listing loses it at
  once. No keying on names/pixels.
- Bricks round trip: changed class settings make Bricks' class-import box ask on the next paste
  (`reference/bricks/README.md` l.83–92, settings compared as JSON). Choosing replace updates the global class once,
  and every page using it (Home and Services) loses the stripe. Before choosing, the builder must name in the report
  which classes change (`showcase-card`, `showcase-panel`, `showcase-photo`; `showcase-zoom` stays byte-identical).
  B2 click path if he prefers by hand: Bricks editor → any page → Global classes (Style Manager) → `showcase-panel` /
  `showcase-photo` / `showcase-card` → Custom CSS → delete the `::after` blocks, `:hover::after` lines and
  `@keyframes showcase-glare` → Save. Then LiteSpeed → Purge All.

## Tasks (builder, TDD)

0. Step 1/2 of the skill; worktree `photo-hover-glass`. Save the corpus baseline (report + `corpus/out/v2/*/bricks.json`
   + `report-v2.json`). `npm run snap -- corpus/files/hydraulics-home.json .superpowers/sdd/photo-hover-glass/shots/before --sides`.
1. **RED tests first:**
   - `test/unit/convert-showcase.test.ts`: flip l.39–44, 104–109 to assert **no** `::after`, no `showcase-glare`, no
     `linear-gradient(120deg` in any `showcase-*` class, while the zoom rules (`scale: 1.1`, `transition: scale 0.5s
     ease`), `overflow: hidden`, figure tag and fade-in Interaction are still there. Rename the test titles ("zooms",
     not "zooms and glares").
   - Add one generic test: for any page with showcases, no emitted class or element CSS contains `@keyframes` named
     for a glare, or an `animation` under `:hover` on a showcase frame (guards a comeback).
   - `test/browser/showcase.test.ts` l.56/67/94/118: under the pointer `::after` has `content: none`/no animation
     (`animation-name` `none`), the img/zoom still reaches scale 1.1, the frame doesn't grow.
   - Prove each fails on main.
2. **GREEN:** `src/core/style/classes.ts` l.67–106: delete `GLARE`, `SWEEP`, `GLARE_KEYFRAMES`; `frame()` returns
   `{position, overflow, css:["isolation: isolate"], parts: extra, motionParts: hover}`; the card drops its two
   `::after` lines. Update the comments (l.67–72, l.79–80) and the "glare" wording in
   `src/core/understand/showcase.ts` l.3,6,62, `understand/hover.ts` l.8, `understand/ir.ts` l.75,
   `understand/understand.ts` l.55, `emit/elements.ts` l.96 (comment only), `shared/breakpoints.ts` l.34,
   `style/types.ts` l.75 (the keyframes comment). Comments only outside classes.ts. Note the `emit/elements.ts` edit
   could be skipped to stay clear of text-link-followups: then leave the stale word and list it as a follow-up.
3. `npm run check`, `npm run test:browser`, `npm run corpus`. Expected corpus change: only the showcase classes'
   settings in files with showcases (hydraulics, inspo); everything else `cmp`-equal; lint unchanged (the stripe is
   hover-only, invisible at rest). Snap `after`; copy before/after of a card row to
   `~/.hermes/plans/figma-to-bricks/shots/photo-hover-glass/`. The look at rest doesn't change, so also give a text
   proof: old vs new CSS of `showcase-panel`.
4. Stop at ready-for-review.

## Tests summary
- unit: convert-showcase (no glare, zoom kept), new guard test.
- browser: showcase.test.ts (no `::after` animation, zoom kept).
- corpus no worse; only showcase classes differ.

## Risks
- Old pages keep the stripe until the classes are replaced (B1/B2). If Justin pastes and picks "keep existing" in
  Bricks' box, nothing changes. The report must say "pick replace".
- The class-import box option wording on Bricks 2.3.9 vs 2.4 is unverified. The checker confirms on the live CSS that
  `showcase-glare` is gone from `/` and `/services/` after the paste.
- Reverses a recorded user decision (19 Oct "zoom + glare"). Justin's new words cover it; CLAUDE.md must be updated so
  no agent restores it from the Staff sample.
- If "flicker" actually meant the zoom judder, A1 leaves the zoom. A2 is the fallback.

## Pipeline parts touched
style (`style/classes.ts`), comments in understand/emit/shared; tests. No adapt, no emit logic.

## Overlaps with in-flight work
- **layout-floors** (adapt/layout): no shared files.
- **text-link-followups**: its plan lists `style/classes.ts` as read-only, so it doesn't edit it. Its worktree diff
  touches no showcase files. Shared: `emit/elements.ts` only if task 2's comment edit is kept (skip it to stay
  clear), and HANDOFF/paste-check numbers.
- **google-font-hardening** (ui/fonts.ts): none.
- **card-link-words** planner: reads `emit/elements.ts`, edits none of ours. Shared: HANDOFF/paste-check numbers only.
- Can build in parallel with all of them.

## Docs & records (last task)
- Plan copied to `docs/plans/2026-10-21-photo-hover-glass.md`.
- Ledger moved to `docs/plans/2026-10-21-photo-hover-glass-ledger.md`.
- `docs/HANDOFF.md`: new section "Photo hover glare removed", and a line under "Product and team cards" saying the
  glare was removed by user request. Paste check owed (next free number): re-paste Home or Services, choose replace
  for the showcase classes, Purge All; checker confirms no `showcase-glare` / `::after` stripe in `/` and
  `/services/` CSS and the zoom still runs.
- `BUILD` bumped (finisher).
- Main `CLAUDE.md` "Start here" and "Where things stand" (finisher). **New rule:** in "Product and team cards"
  (l.1122–1139) replace "zoom + glare" with "zoom only. No glare, shine or glass sweep on photo hover (user,
  2026-10-21: 'this glass flicker I do not want'). The Staff sample's glare is not to be copied."
- `rules-summary.md` user-decisions line "zoom 110%+one glare/hover" → "zoom 110% on hover, no glare".
- Corpus baseline/final reports kept in the ledger.

## Found else (not folded in)
- Old `showcase-*` classes on the site only update through Bricks' class-import box. There's no plugin-side way to
  repair classes on pages already pasted (general issue for any future class-style change).

## Justin's answers (2026-10-21)
- **go**: A1 (remove only the glare; zoom stays), B1 (re-paste one page with "replace" in the class box), C1 (keep the fade-in).
