# Fonts cleanup — keep Figma's weights, skip needless uploads, explain missing faces

Planner only · 2026-10-21 · main `f3d6ed8`, BUILD `2026-10-21.4`.

**Approved by Justin 2026-10-21** (answers 1B 2A).
Loaded `figma-to-bricks` (PLANNER), its rules summary and relevant CLAUDE.md entries, and `systematic-debugging` before investigating. No worktree, branch, application code, commit or site change made. CLAUDE.md's headline build is stale; git and `src/shared/build.ts` are the build authority for execution.

## Open questions

The plan below assumes the ⭐ answers. These are choices for approval, not permission to build now.

**1. The speed-only item needs a real Bricks paste check before removing a font loader.** Both loading paths exist, but that alone does not prove the browser downloads the same font file twice. The site's current native Google link is still broken by an older paste. Removing the plugin's working loader blindly can leave missing fonts.
- **A ⭐ Keep safe loading; split speed-only follow-up.** Finish the small, proven fixes now. Leave the duplicate-loading item open, with a separate Bricks-only proof before changing it.
- B. Include Bricks-only loading after a paste proof.

**2. When an exact weight is missing, how definite should the panel sound?** The plugin can name the weights its paste supplies, but cannot know every font rule the eventual site adds. It must not promise “shows as 700” just because 700 exists somewhere on Google.
- **A ⭐ Name available weights; say the site may differ.** Keep the Figma weight. Say which same-family weights the paste actually supplies, or explicitly say the fallback is unknown.
- B. Choose and load a replacement weight.
- C. Keep today's missing-weight note only.

**No new choice about Figma's weights.** Justin's 3A means each text must keep its own Figma family and weight, not a fixed site-wide weight. The current paste already does this through editable text classes. Keep that working behaviour and add regression checks; do not repeat every class weight on every element just to make the JSON look more explicit.

## The request, played back

1. Avoid making a page load the same Google font through two competing paths, without losing fonts.
2. When Google lacks a requested weight, explain what is available instead rather than only saying “missing”.
3. If a site's variable font already covers a dropped static weight, do not upload the same coverage again.
4. Keep every text's own font weight from Figma. A site's body setting of Saira 800 must not turn a Figma 600 label into 800.

**Recommended scope:** implement 2 and 3; prove and protect 4, which already works in today's paste; split 1 as a speed-only follow-up. This is not four unfixed rendering bugs. Do not report item 1 as fixed at the merge.

## Investigation and tight feedback loops

Read the on-disk Repairs debug file, `corpus/files/hydraulics-home.json`, the font-drop and font-weight-gaps plans/ledgers, and HANDOFF's fonts entries (2391+, 2901+, 3024+). Debug JSON remains untouched.

Ran:
- `node --test test/unit/ui-fonts.test.ts test/unit/ui-font-sources.test.ts test/unit/ui-site-fonts.test.ts` — **40 passed**, no failures. Existing tests do not catch the upload coverage gap.
- `node /Users/justin/.hermes/cache/scratch/fonts-cleanup/probe.mjs` — read-only conversion/browser investigation, plus uploads to an in-memory WordPress stand-in only. Output: `.../fonts-cleanup/evidence.json`.
- Public HTTP GETs of Home, its linked stylesheets and Google's exact requested stylesheet URLs. Saved raw Home/CSS responses under the same scratch directory; no authenticated requests or writes.
- A minimal `node --input-type=module` assertion against the in-memory library failed exactly as required on current main: `RED: covered static must not upload`, actual POST count **1**, expected **0** (exit 1). This is the item's red-capable seam, not a crash or a network failure.

The probe identifies the red conditions for the builder: a covered static upload currently makes one POST (must become zero), and missing-weight notes contain no fallback information. Its already-green control renders both user files against `body {font-family:Saira;font-weight:800}` at 390, 768, 1024, 1440 and 1728px. Schedule Now remains IBM Plex Mono **600** at every width. The permanent tests must use generic fixtures, not these words, ids, fonts or widths as matching logic.

### Item 1 — Google fonts declared through Bricks and the paste

**Root cause / evidence**
- `src/ui/run.ts:65` starts `loadGoogleFonts`; `153–158` appends its CSS before the site's own CSS.
- `src/ui/fonts.ts:35–53` fetches Google's faces; `58–63` writes them on the first real top-level element.
- Home's public HTML also has `bricks-google-fonts-css`. The downloaded `post-10.min.css` contains 63 `@font-face` declarations, including the plugin's Google/site sources.
- The native Google request still answers **400** and includes `100 900` from an old paste. This is the already-merged font-weight-gaps repair awaiting a fresh paste (HANDOFF 3af), not a new B1 regression.
- Two declarations/stylesheet paths are proven. Two actual downloads of the same binary are **not** proven. CSS registration, selected files and cache reuse are different measurements.

**Recommended disposition (1A)**
Split the speed-only change. Do not remove Google's CSS in this batch, suppress the site's global link with JavaScript, rename font families, change Bricks/site settings, or touch the header/footer to save requests.

**Follow-up fix / proof required**
After the existing range fix is freshly pasted and the native link answers 200, compare cold-cache requests and actual platform fonts with and without the plugin's Google declarations. Cover ordinary text classes, a family used only in a mixed run, italics, a missing weight, a non-Google uploaded face, and the existing header/footer. Only choose Bricks as sole Google loader if every used family/face still resolves in editor and saved page. Preserve the site's own `@font-face` rules and Figma names. If inline-only families are missed, that is a separate registration design, not a guessed Bricks key.

**Test / completion rule**
A local renderer alone cannot prove Bricks' font discovery or duplicate downloads. The follow-up needs a real paste round trip and network/platform-font evidence. Leave this found-else line unstruck until that work is approved, built and checked.

### Item 2 — Missing-weight notes do not explain a fallback

**Root cause / evidence**
- `fonts.ts:35–53` returns only CSS and string labels of missing faces; it does not pass available-face descriptors to the note layer.
- `font-sources.ts:65–79` plans requested faces only. `82–89` prints missing labels plus upload instructions, never the supplied alternative weights.
- A probe with missing `Sample Sans 800` prints just “Not on Google Fonts or your site … Drop their files …”. There is no evidence in that string for what could render instead.

**Fix (2A)**
- Keep requested family, weight and italic in the paste unchanged. This is an explanation change, not automatic substitution.
- Carry a small typed list of confirmed supplied descriptors (family, weight/range, slant, source) alongside the current Google CSS result; combine with the site's usable faces. Deduplicate unicode subsets and do not mix families/slants.
- Parse only the font-response descriptors in the UI font loader; do not regex-rewrite the pipeline's typed CSS or emitted paste. Share numeric range/coverage logic with item 3 where appropriate.
- For a known missing face, retain the upload guidance and add a short line such as: “Requested Sample Sans 800. This paste supplies 400 and 700 in that style; the browser chooses a substitute. Your site's font settings may add other weights.” When no matching supplied face is known: “No replacement weight is confirmed; the browser may use another font. Drop the exact font file to match Figma.”
- Prefer the existing site's exact face: no missing/fallback warning when the site covers it. Google off, a site read error, or a timeout must not be turned into a made-up available weight. Name the uncertainty.
- This plan deliberately does not add all Google weights, make availability-probe network requests or change rendered weight. If Justin wants a chosen guaranteed substitute, use 2B and re-plan that visible behaviour.

**Tests (red first)**
`ui-fonts`, `ui-font-sources` and `ui-run`: known alternative descriptors survive to the note; no duplicate weights for subsets; same-family/slant only; available range covers a requested number; exact site coverage suppresses the warning; no faces/network error/off gives an explicit unknown, never an invented 700. Existing upload/connection instructions remain. Assert the payload's family and requested weight are unchanged.

**Boundary:** a further missing-face detection bug was discovered (Other things found, F1). Do not quietly expand this wording task to fix that separate classification change; notes improve for faces the current loader actually reports missing. Keep F1 explicitly open for separate approval.

### Item 3 — A static file uploads although a variable face covers it

**Root cause / evidence**
- `font-sources.ts:17–20` and `73` use range coverage for `fontPlan`.
- `site-fonts.ts:168` uses exact string equality for `addFonts` instead.
- In the WordPress stand-in, existing normal `100 900` plus dropped normal `500` yields `added=1`, `already=0`, **one POST**, while `covers(...,500,false)` is true.
- The reported “two CSS rules for 500” is stale on current main: `siteFaceCss:47–57` already prefers the exact static over the variable. The same probe yields **one** 500 rule. The unnecessary upload is still real.

**Fix**
Use one small shared weight-coverage helper in a dependency-neutral UI module (extend `src/ui/font-weight.ts`, or a focused `font-coverage.ts`). Do not import font-sources back into site-fonts and create a cycle.
- A usable existing static or variable face covers a dropped static only within its bounds, same family and slant, with a usable source URL.
- For a dropped variable font, skip only when an existing usable variable face spans its whole range and slant (or is identical). A single static inside the range never covers the whole variable file. Do not infer full continuous coverage from isolated statics.
- Keep one-at-a-time uploads and the in-memory family update so later files in the same drop can use a variable file just added. Do not change drop ordering as incidental cleanup.
- Report a covered dropped file in `already`, no POST. No deletion/repair of redundant files already in WordPress; today's CSS already selects one for their shared weight.

**Tests (red first)**
`ui-site-fonts`: middle and boundary weights covered → zero POSTs; outside/other family/other slant/empty URL → uploads; variable contains variable → skip; partial overlap/static versus variable → uploads; newly added variable covers a later static; repeat drop idempotent. Through `siteFonts` and `fontPlan`, the row agrees with `already`. Keep the real WordPress list semantics (all faces, filter by parent). `ui-font-sources` still emits one numeric rule per weight/slant, no ranges.

### Item 4 — Every text keeps the Figma weight (Justin 3A)

**Root cause finding: not a missing-weight bug in today's paste**
- Figma extraction asks for numeric `fontWeight` (`src/plugin/extract/text.ts:7`). Normalisation keeps it, or derives it from the style name (`normalise/text.ts:63–77`).
- `style/typography.ts:23–25` preserves the run's weight. `style/text-classes.ts:25–46` stores shared typography, including weight, on the Figma text-style class; only differences stay on individual elements.
- `emit/settings.ts:23–27` emits that weight as Bricks' typography control. A class is an explicit declaration on the text, not inheritance from body.
- Repairs: **106 text-like elements, zero without an effective own-or-class weight**. Hydraulics: **202, zero**. Schedule Now's class `ibm-plex-mono-semibold-upper-16-aa7i` carries `font-weight:600`, matching its Figma numeric 600; the generic body-800 renderer probe remains 600 at every tested width.
- The public Home header is a different, existing site template: `post-15.min.css` sets its button's IBM Plex Mono family but no weight, while `theme-style-global.min.css` sets body Saira 800. Fresh page paste cannot change a template excluded by “My site already has its header”. Do not claim B1 will silently repair that site-owned template.

**Fix / disposition**
Keep existing class-based output. Add permanent regression coverage proving Figma-derived weights win over body defaults, with and without a text style and with local overrides. No blanket 600/800, no `!important`, no typography duplication, no extraction/normalisation/HTML change without a genuinely failing fixture.

**Tests**
Generic Figma fixtures: regular 400, semibold 600, bold 700, two weights sharing a text style with a local override, a native Button label, text link, mixed runs and a drawn-phone text style. Assert effective element + class weights, then computed weights under hostile body-800 CSS at desktop/tablet/phone. Preserve mixed-run overrides and editable type-scale classes. Replay the two user files as above.

**Existing header action (not an agent site write)**
To fix the already-made template, Justin still needs the previously recorded step: Bricks → Templates → header → Edit with Bricks → Schedule Now → Style → Typography → Font weight 600 → Save. Alternatively replace the template content with a newly converted Figma header. Do not turn this into an automatic template migration. The 600 here is from this design, not a rule for other designs.

## Tasks — test first

0. Builder refreshes git/build/context after approval. Own worktree only. Copy this plan; start `.superpowers/sdd/fonts-cleanup/progress.md`. Run baseline `npm run check`, `npm run test:browser`, `npm run corpus`; save report and corpus pastes before changes. Preserve known baseline failures; do not call corpus exit 1 a new failure by itself.
1. Add generic item-3 failing tests. Introduce shared coverage, update addFonts and existing fontPlan/siteFaceCss callers, prove zero-POST skip and range boundaries; commit passing task.
2. Add item-2 note/descriptor tests, then metadata plumbing and wording; commit passing task. No added substitute-loading behaviour and no F1 classification fix in this scope.
3. Add item-4 unit/browser guards. These should pass before production changes; if they fail, isolate and document the counterexample before any fix. Do not change working typography just to make this a code fix.
4. Replay the current debug file and Hydraulics, compare payloads and effective typography. Re-run scratch proof against the worktree. Approved scope should leave core/corpus pastes byte-identical; panel notes and covered-drop requests change. Return exact old/new text and POST counts. No before/after image change is expected; if a genuine appearance fix is approved later, take `npm run snap -- <debug> <before> --sides` before code and matching after shots, including phone width, per skill.
5. Run `npm run check`, `npm run test:browser`, `npm run corpus`; compare per-file lint, pastes and worse-than-v1 list, not just exit codes. No new worse file/width. Fresh reviewer then one verified, test-first fix pass. Rebase and re-run gates before the finisher merges.
6. Record item 1 as split/deferred, not fixed. Preserve existing fonts paste checks 3x/3ac/3af; new check number allocated at merge so concurrent batches cannot collide.

## Risks and boundaries

- **A partial batch is intentional:** item 1 needs external proof; item 4 already works. Approval should not be sold as four production fixes.
- **Notes cannot promise the eventual physical font.** The site's Bricks loader, templates and synthesis can change the selected face. Say what is supplied, distinguish computed requested weight from actual font file, and give the exact-font upload path.
- **Current live pages are old.** Native Google link 400 remains until prior fixes are pasted again; this plan's local tests do not certify those pages repaired.
- **Shared classes matter:** checking only element `_typography` falsely reports missing weights. Resolve `_cssGlobalClasses` before judging.
- **Font range handling:** no emitted weight range; no cross-family or cross-slant deduplication; no deleting existing font records. Existing exact static preference stays.
- **No unrelated fixes:** no links, line breaks, layout floors/cards, pictures, cache/settings/UI redesign or whole-file refactor.

## Files / pipeline touched

Production: `src/ui/font-weight.ts` or new `src/ui/font-coverage.ts`; `src/ui/site-fonts.ts`; `src/ui/fonts.ts`; `src/ui/font-sources.ts`; font-only lines/types in `src/ui/run.ts`. Preserve `Outcome.fonts` compatibility unless the tests require a typed optional extension.
Tests: `test/unit/ui-site-fonts.test.ts`, `ui-font-sources.test.ts`, `ui-fonts.test.ts`, `ui-run.test.ts`; focused new weight regression unit/browser tests and generic fixture. Reuse `test/fixtures/panel.ts` without changing its unrelated stand-ins.
Pipeline: panel/font-source enrichment after emit. Core extract → normalise → understand → style → adapt → emit remains unchanged under the recommended scope. Read-only coverage of typography/emit; no breakpoint rule writes.

## Overlaps / build order

- **frame-text-links (building):** no planned extraction, normalise/text, page-link or text-HTML edits. It can share `src/ui/run.ts` / `ui-run.test.ts` integration seams if it needs them; coordinate font-only hunks, rebase after its merge.
- **cta-label-wrap (building):** no adapt/layout/least/unpin/label/rules edits; fixtures may render its changed labels after rebase, refresh evidence.
- **test-cleanup (queued):** shared `test/fixtures/panel.ts`, panel tests, possibly browser test infrastructure; avoid editing its general fixtures. No style/style.ts split or tools/snap.ts change here.
- **B2 link-upload-fixes:** potential shared run.ts/ui-run integration tests and panel fixtures; no site-read/pages/uploader edits.
- **B3 text-breaks:** typography tests could overlap; this batch deliberately makes no textHtml/normalise edits. F1 is a separate font follow-up, not B3 work.
- **B4 equal-card-fixes, B5 layout-floors:** no planned production overlap (adapt/layout/rules untouched).
- Earlier font-drop, emergency-cta-width and font-weight-gaps are merged dependencies. Keep their family filtering, read-time weight repair, exact static preference and no-range paste contracts intact.

## Docs & records — final implementation task

- Builder copies approved plan to `docs/plans/2026-10-21-fonts-cleanup.md`.
- Move ledger to `docs/plans/2026-10-21-fonts-cleanup-ledger.md`.
- Update `docs/HANDOFF.md`: exact scope, no-upload proof, note examples, item-4 class/browser proof, deferred duplicate-loading proof, F1, and a unique paste check. User steps: reload plugin; Convert; drop a covered static and see “Already on your site”; check missing-face wording; paste and Save if testing the page; LiteSpeed → Purge All; check Figma weights survived without changing Theme Style. Regenerate code signatures if the paste contains Code, as usual. Distinguish the separate header-template setting.
- Finisher bumps `BUILD` only at merge, builds dist, updates main CLAUDE.md “Start here” and “Where things stand”. Preserve merge-lock/ff-only/push/cleanup rules. If CLAUDE.md write is blocked, use the skill's pending-edits report, not a bypass.
- Record new rules: **effective text weight includes its imported typography class**; **a usable same-family/slant variable face covers static uploads in its range**; **font notes must distinguish supplied/unknown fallback from guaranteed physical rendering**. Keep no-range/no-nonnumeric paste rule.
- At merge, mark genuinely fixed found-else lines with `~~item~~ ✅ fixed in build <BUILD> (fonts-cleanup)`. Item 2 and item 3 get that mark only after their acceptance checks. For item 3 annotate that duplicate upload was fixed; current CSS already deduplicated the shared weight. For item 4 retain the original site-setting fact and add “paste verified; Figma weights carried by text classes; existing site template needs its own setting”; do not strike it as though agents changed the live template. Leave item 1 open as split, with follow-up prerequisites. Update found-batches status consistently; do not erase the scope decision.

## Other things found — not included

**F1 · Low/medium — Google can silently omit a requested weight while returning HTTP 200, so the panel falsely says it exists.** `src/ui/fonts.ts:44–45` accepts any nonempty family response without checking face coverage. Live GET: IBM Plex Mono 400+800 returns 200 with only 400; `loadGoogleFonts` then returns `missing: []`. A request for 800 alone returns 400. Existing `ui-fonts.test.ts:34–38` assumes the combined unsupported request fails entirely, unlike the real response. This deserves a separate small descriptor-coverage detection fix and a realistic fixture; do not fold it into B1 wording work without separate approval. It also means this batch's improved note only appears for faces today's loader reports missing.

No other new application bug claimed. The old live native-link 400 and missing template weight are existing tracked paste/site actions, not new findings. Search-files failed on the large HANDOFF file; a read-only Python scan plus targeted read_file sections recovered the evidence. Web extraction backend was unavailable; direct public HTTP GETs supplied the live evidence.

## Justin's answers (2026-10-21)
- **1B** (differs from ⭐): include Bricks-only loading, after a paste proof. The proof needs a fresh paste (the native Google link answers 400 until Justin re-pastes for 3af), so item 1 runs in two stages:
  - Stage 1 (this build): items 2, 3, 4 as planned. For item 1, build the change behind nothing yet: write the probe/test harness and a short "item 1 proof steps" section in HANDOFF (exact cold-cache checks to run on the live page), but leave the plugin's Google loader in place. Leave the item-1 found-else line unstruck.
  - Stage 2 (after Justin re-pastes and a CHECKER confirms the native link answers 200 and every family/face resolves with Bricks' loader alone): a follow-up build removes the plugin's duplicate Google declarations.
- **2A** as planned.
