# PDF links open in a new tab — pdf-new-tab

Approved request, 2026-10-21: every PDF link in a paste opens in a new tab, with noopener; other links stay unchanged. BUILDER uses figma-to-bricks and test-driven-development skills. Base main 96c6824, build 2026-10-21.16 (CLAUDE Start here is stale at .12; HANDOFF and build source are authoritative for current status).

## Playback
1. Download buttons, CSV PDF addresses and Figma PDF links open in another tab.
2. Rich-text PDF links do too, retaining their styles, indices, relinking and copied marquee tabindex.
3. Page, website, phone, email and non-PDF document links behave exactly as before.

## Evidence and pipeline
- normalise/links.ts already validates link safety and excludes media, but does not classify PDFs. Add a separate PDF path predicate; never expand fileAddressKind's blocked-file meaning.
- emit/elements.ts writes native element settings.link; style/typography.ts writes inline anchors.
- Official Link Control Schema https://academy.bricksbuilder.io/developer/schema/controls/link/ documents newTab:boolean and rel:string inside a link control. Official https://academy.bricksbuilder.io/developer/controls/link-control/ passes that setting to set_link_attributes. Fetch/archive exact source before using it; add clearly documented (not Bricks-copied) reference fixture.
- Official resolved schema archived as reference/bricks/link-schema.json (schemaVersion 2.4.3), fetched from https://academy.bricksbuilder.io/schema-resolved/controls/link.json on 2026-10-21; explicitly documented schema, not a Bricks-copied export. Target install is 2.3.9, so the paste check must confirm it there.
- Existing B7 emit/text-links.ts adds copied marquee tabindex; ui/text-links.ts preserves all non-href attributes during B2 relinking. Add regression coverage, not unrelated rewrites.
- Touches: src/core/emit/elements.ts, src/core/normalise/links.ts, src/core/style/typography.ts; new test/unit/pdf-new-tab.test.ts and test/browser/pdf-new-tab.test.ts; existing test/unit/emit-lists.test.ts only the final PDF test's old link-object expectation (line 83), strengthening it to require native newTab and noopener. No tests marked read-only.
- In flight: card-link-words (normalise/label-links.ts and normalise.ts), hero-photo-blend (picture style), layout-floors (adapt). Stay out of those files.

## Tasks and tests
1. Create own worktree; baseline npm run check and corpus. Preserve full report, payloads and HTML outside git. Copy Justin's mutable debug to scratch and replay baseline.
2. Archive official schema and documented link fixture. TDD generic element PDF link (native newTab:true, rel:noopener) through conversion and assertPayload. Non-PDF output unchanged.
3. TDD PDF path detection: case, query/hash, encoded extension, relative addresses; negatives page query mentioning PDF, tel/mail/hash, non-PDF documents. Share predicate between native and inline emission.
4. TDD styled inline PDF anchors and marquee-copy/relink preservation. Reuse existing CSV list fixture to cover list/row PDF links and CSV address links; narrow updates only to assertions that this approved change intentionally changes.
5. Run check, test:browser, corpus. Compare full baseline/final payloads, HTML, lint, font status/heights. Non-PDF corpus and actual debug must be byte-identical. Record before/after href,target,rel as text proof (no visual change).

## Docs & records
Copy plan to docs/plans/2026-10-21-pdf-new-tab.md; keep TDD ledger then move to docs/plans/2026-10-21-pdf-new-tab-ledger.md; update HANDOFF with paste check **3ar** (3aq is layout floors, checked under merge lock). Installed **Bricks 2.3.9** native Button and linked Div paste/copy-back plus **actual PDF** frontend navigation/target/rel/null-opener remain explicitly owed; official schema 2.4.3 and a local HTML destination at a PDF-shaped path are not compatibility proof. Rebased on main **3e1a3b4 (.17)**; check **1677 + 6**, browser **166**, focused **10**, zero failures/skips; five corpus payloads/HTML and all 29-width complete reports identical to fresh exact-main17 baseline, same 17 existing v1 items. Release **2026-10-21.18**. Finisher handles BUILD/build/push and main CLAUDE Start here/Where things stand after merge; exact denied edits go to feature-specific pending file, no retries/bypass, earlier pending files preserved. Pre-existing renderer rel synthesis and linked-image tabindex caveats recorded in found-else, left unfixed. See repository plan/ledger and permanent finisher evidence for verified details.
