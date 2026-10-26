# PDF button opens the PDF in the same tab instead of downloading

## Context

Justin: on the live Services page, clicking "Download Full Inventory (PDF)" takes the visitor away from the page and
shows the PDF. Wanted: the click starts the download and the visitor stays on the page.

## Root cause (proved; no code change expected)

The page in Bricks holds a conversion made by **old plugin code still running in an open Figma panel**, from before
the two PDF builds: 21.18 (PDF links open in a new tab, 2026-10-21 14:24) and 22.7 (PDF buttons download,
2026-10-22 13:13). Figma reads the plugin's files only when the plugin starts, so a panel left open keeps its old code
across builds.

Evidence:
- **Bricks' saved button** (Justin's copy-back of `brxe-iovjet`): `link: {type: "external", url: "…-pdf.pdf"}`, `tag: "a"`.
  There is no `newTab`, no `rel` and no `_attributes`. That shape is exactly what builds 21.16/21.17 wrote for a
  list's PDF button.
- **Today's plugin** (main, build 22.10, the `dist/` Figma loads per `~/Library/Application Support/Figma/settings.json`),
  run on Justin's Services design with the same PDF: `link: {…, newTab: true, rel: "noopener"}` plus
  `_attributes: [{name: "download", value: ""}]`. `test/unit/pdf-direct-download.test.ts` passes 16/16.
- **Bricks 2.3.9 keeps pasted custom attributes:** the live homepage marquee prints the plugin's `tabindex="0"`,
  `role="marquee"`, `aria-label` and `aria-hidden`. Bricks' builder code (`main.min.js`, read from the site) never
  deletes a link's `newTab`/`rel` or an `_attributes` row, and it keeps an empty attribute value as `""`.
- **The PDF** is on the site itself, served directly (HTTP 200, `application/pdf`, no redirect), so `download` works
  once it is on the link.
- **Timing:** Justin converted and pasted again after the plugin uploaded the PDF (media 725, 17:52:55 GMT; page saved
  17:55:35 GMT). The Lists box's PDF pickers exist since 21.16, so the panel ran 21.16–21.17 code.

## Steps

1. **Justin, in Figma:** close the plugin panel, then open it again (Plugins → Development → Figma to Bricks v2 (dev)).
   The panel must say **build 2026-10-22.10**.
2. **Justin:** select "Services Page Final" and click Convert, with WordPress connected as before.
3. **Me, before the paste:** read the clipboard (`pbpaste`) and check that the PDF button's element has `newTab: true`,
   `rel: "noopener"` and the `download` attribute. This proves the panel's copy is right before Bricks touches it.
4. **Justin, in Bricks:** on the Services page, delete the old content, paste, and Save. Then Bricks → Settings →
   Custom code → Regenerate code signatures (for the list's script), and LiteSpeed → Purge All.
5. **Me:** read the live Services page over HTTP. The button must print `target="_blank"`, `rel="noopener"` and
   `download`.
6. **Justin:** on the live page (not the editor), click the button. The PDF downloads and the page stays put.

**Only if step 5 fails after a correct step 3** (Bricks drops it on paste): debug the gap between steps 3 and 5 with a
second copy-back. If Bricks drops only the empty-valued `download`, the fix is to give it the file's own name as its
value. That would be test-first in `test/unit/pdf-direct-download.test.ts` (the `assertDownload` value check) and
`src/core/emit/elements.ts` (the `attrs` line beside `downloadControl`), followed by `npm run check`, corpus, review,
a build bump and a re-paste.

## Records afterwards

- `docs/HANDOFF.md` "PDF buttons download": paste check **3be** result (live attributes and Justin's click), committed
  on main by file.
- Memory (feedback): when a merged feature is missing from a live paste, first have Justin reopen the plugin and read
  the panel's build number, because an open panel keeps its old code across builds.

## Verification

- Step 3 clipboard check and step 5 live HTML check, both read by me (read-only).
- Step 6, Justin's click on the live page.
- No code change, so there's no check or corpus run unless the contingency fires.
