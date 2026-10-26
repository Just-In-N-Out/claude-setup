# pdf-new-tab CLAUDE.md edits pending — build 2026-10-21.18

Target: /Users/justin/Documents/FigmaToBricksV2/CLAUDE.md
Status: the single atomic patch below was denied by the protected-file guard. **None of these edits landed.** No retry or alternative write path was attempted. Existing earlier feature pending files remain untouched. Do not use this pending record as permission to bypass the denial. The build remains stale at .12 in CLAUDE.md; authoritative build source/HANDOFF/main/remote are .18.

Verified release: f2a4a425fba7bf4cba83bbbc2e89973bd33046c7, build 2026-10-21.18, main and origin/main and remote refs/heads/main equal. Check 1677 unit/rule + 6 performance; browser 166; focused 10, zero failures/skips. Five exact-main-.17 vs integration payloads/HTML and complete 29-width reports identical, same 17 existing v1 differences. Paste check **3ar still owed**, not installed-Bricks/PDF sign-off. Rule summary already updated; no CLAUDE.md content change or commit.

## Exact unapplied patch (all sections; build line included atomically)

```diff
*** Begin Patch
*** Update File: /Users/justin/Documents/FigmaToBricksV2/CLAUDE.md
@@
-**Current build `2026-10-21.12`.**
-- **Checks:** `npm run check` 1479/1479 unit/rule plus 6/6 serial performance; browser (`npm run test:browser`)
-  154/154, no skips/failures. The three stale panel upload-name expectations are fixed; all newer B2 tests remain.
-  Five .11/main versus .12 pastes and full HTML byte-identical; full findings/heights/fonts equal at 29 widths.
-  Separately labelled matched-policy recapture gives exactly equal complete reports, same 17 existing v1
-  differences. Legacy moving-animation scores remain non-comparable; budgets/tolerances unchanged.
+**Current build `2026-10-21.18`.**
+- **Checks (.18, pdf-new-tab rebased on main .17):** `npm run check` **1677/1677 unit/rule + 6/6 performance**;
+  browser **166/166**, focused native target/rel/list **10/10**, zero failures/skips; budgets/tolerances unchanged.
+  Five corpus payloads and full HTML plus complete reports equal at **29 widths** against a fresh exact-main-.17
+  archive; same **17** pre-existing v1 differences (expected corpus exit 1). Mutable debug payload/HTML/warnings equal.
+- **PDF links open another tab (21.18):** all PDF-path native and inline links get new-tab/noopener; other URLs stay.
+  Fresh source review PASS. **Paste check 3ar still owed:** installed **Bricks 2.3.9** native Button/linked Div paste
+  and copy-back plus actual PDF frontend target/rel/null-opener/navigation. Official schema **2.4.3**, local renderer
+  and **HTML at a PDF-shaped path** do not establish installed-version or real-PDF compatibility. Renderer rel synthesis
+  and linked-image tabindex limitations remain separate open tooling issues; no live-Bricks bug asserted. .17 layout
+  floors remains paste check 3aq. Earlier pending feature-specific CLAUDE edits stay unapplied unless separately verified.
@@
 **Where things stand (2026-10-19; the entries run in date order):**
 
+- **PDF links open another tab (2026-10-21.18, pdf-new-tab):** shared path classification covers native Button/Div,
+  uploaded list/row PDFs, CSV document-address columns and styled inline/marquee links. Native
+  `settings.link.newTab:true` and `settings.link.rel:"noopener"`; inline target `_blank` and rel noopener. Preserve
+  href/style/order/relinking/copied tabindex. No download/noreferrer, MIME guessing or network classification.
+  Official reference schema 2.4.3 is not a copied installed-2.3.9 export. **3ar owed**, native Button and linked Div
+  copy-back plus an actual PDF/frontend opener check. Source review and integrated gates pass, no installed sign-off.
+  Full evidence under `~/.hermes/plans/figma-to-bricks/evidence/pdf-new-tab/finisher/`; plan/ledger in docs/plans.
+- **Pre-existing renderer limits, not fixed by pdf-new-tab:** render.ts:135 synthesizes noopener instead of reading
+  native rel (unit payload assertions independently verify it); linked-image attributes/tabindex are placed on the
+  image not its outer anchor (131,142–144). Recorded in found-else.md; not observed live-Bricks defects.
+
@@
   - **The whole card is the link,** not the arrow alone.
+  - **Every PDF link opens another tab** (user, 2026-10-21): classify the decoded URL path ending `.pdf`, insensitive
+    to case and query/fragment; leave other URLs unchanged. Native link control newTab/rel, inline `_blank`/noopener;
+    no forced download, noreferrer or network/MIME inference. Bricks 2.3.9 installed paste/copy-back and real-PDF
+    frontend proof stay owed until check 3ar; official schema 2.4.3 and local renderer probes are not substitutes.
*** End Patch
```
