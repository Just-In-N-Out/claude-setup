# Pending CLAUDE.md update for build 2026-10-21.1 (emergency-cta-width)

The finisher's write to `~/Documents/FigmaToBricksV2/CLAUDE.md` was blocked (protected agent-instruction file; needs
Justin's OK). Everything else is merged and pushed. Apply these three edits once he approves. Re-read the file first.

## 1. "Start here": replace the build line and the Checks bullet (lines 7–11 on 2026-10-21)

Old first line: `**Current build `2026-10-20.15`.**`; in Checks, `1266 pass` becomes `1274 pass`. Then add this entry
right after the Checks bullet, before "Cards drawn the same height (20.15…)":

```
**Current build `2026-10-21.1`.**
- **Checks:** `npm run check` 1274 pass; browser suite (`npm run test:browser`) 131 of 134. (rest of the bullet unchanged)
- **Site fonts kept per family (21.1, emergency-cta-width):**
  - **The user:** on the pasted hydraulics homepage the outlined "Emergency Call 24/7" pill looks too long and loose
    next to Figma, on a computer (phones are full width by his CTA rule, unchanged).
  - **The cause:** the pill is Figma's width, but its words were drawn in **Saira Condensed** (142px against 196).
    WordPress answers `font-families/<id>/font-faces` with every face on the site, so the paste's `@font-face` lines
    (fonts, 20.11) listed the same 13 site files under Archivo, Saira and Saira Condensed, and the last one won.
  - **The user chose (E1A desktop only, E2A, E3A):** fix the fonts; buttons keep Figma's width; he converts and
    pastes the 8 affected pages again (Home, Hydraulic Cylinder Repairs Final, Remanufactured, Contact, Core
    Exchanges, Rods, Services, About; Gallery is clean). A Convert alone repairs nothing on those pages.
  - **What it does:** `src/ui/site-fonts.ts` keeps a family's faces by their `parent` (by their own font family name
    when the answer has none) and reads the list 100 at a time. The panel's "on your site" rows and "Already on your
    site" are right again. `src/core` untouched, corpus pastes byte-identical.
  - Self-reviewed (no separate reviewer, to save plan usage): checked against WordPress trunk and 7 mutations; one
    test added. HANDOFF "Fonts from the site's library mixed between families"; paste check 3ac owed.
```

## 2. "Where things stand": add before "- **Paste checks:**" (after the "Cards drawn the same height" entry)

```
- **Site fonts kept per family** (build `2026-10-21.1`, branch `worktree-emergency-cta-width`, HANDOFF "Fonts from
  the site's library mixed between families"; plan and ledger `docs/plans/2026-10-21-emergency-cta-width*`):
  - **Code:** `src/ui/site-fonts.ts` `readAll` (any WordPress list, 100 at a time, ending at a short page or
    `rest_post_invalid_page_number`; families and faces share it), `isOwn`/`facesOf` (`_fields:
    id,parent,font_face_settings`; a face is the family's when its `parent` is the family's id, or, answered without
    `parent`, when its own `fontFamily` names the family).
  - **Stand-ins:** `test/fixtures/panel.ts` `siteFaces` and the browser `panel.test.ts` `fontLibrary` answer as
    WordPress does: every face of the site under any family, newest first, each with its `parent`, `per_page`/`page`/
    `_fields` honoured; `noParent` drops `parent`; a face keeps its own posted `fontFamily`.
  - **Tests:** `ui-site-fonts` (own faces only; the parent wins over a face's own font family name; no `parent`; more
    than 100 faces; a drop only another family has goes up), `ui-font-sources` (`siteFaceCss`, `fontPlan`), `ui-run`
    (a connected Convert with two site families). All fail with main's `site-fonts.ts` or under a mutation.
  - **Proof** (stand-in rebuilt from the live `post-10.min.css`): Archivo 13 mixed files → its 3 own; Archivo 500 and
    800 come from Google, as Figma draws them.
  - **My rulings, not yet confirmed:** a face without `parent` is matched by its `fontFamily` name; faces are read per
    family, so it stays right on a WordPress that does filter by parent.
  - **Follow-ups:** `addFonts` counts "already there" on an exact weight only (a variable site face gets a static
    uploaded beside it); Saira Condensed Thin/ExtraLight went up as 250/275.
  - Not yet pasted by the user (3ac: the 8 pages again).
```

## 3. New rule under "Working in this repo", after the bullet "A WordPress upload attached to no page owns the address…"

```
- **WordPress's `font-families/<id>/font-faces` answers every face on the site,** whatever its family
  (`wp_font_face` isn't hierarchical, so the posts controller filters by no parent). Keep only the faces whose
  `parent` is the family (`site-fonts.ts`). A stand-in for WordPress answers as WordPress does, read from its code or
  a real answer, never from what the code expects.
```
