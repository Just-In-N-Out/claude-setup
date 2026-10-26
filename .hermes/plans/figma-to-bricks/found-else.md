# Things agents found, not fixed yet

One line each, newest first. Offer them to Justin when picking next work; strike them when fixed.

Round 3 ownership (2026-10-22): see `found-batches.md` → `found-batches-round3.md` for exact finding assignments and held/deferred dispositions. Four planners dispatched: found-layout, found-contacts, found-tiles, found-gates. Assignment is NOT a fix/closure. W-B held; Garamond Condensed UNVERIFIED, no substitute or expected-set narrowing. Refused CLAUDE.md writes remain pending, not retried.

## 2026-10-22 — button-link-routing planner
- **SITE FOLLOW-UP:** Header/footer `/services-rods/` and `/services-assembly/` links also return 404. These are separate WordPress template/site links, not the CTA converter fix.
- **DOCS:** Main `CLAUDE.md` build status is stale relative to actual BUILD `2026-10-22.5`; preserve build-order catch-up rules.
- **LOW, legacy link fallback:** Whole-element NODE navigation can fall back to `#` when its target name is unavailable. This was not the observed Services CTA case; keep separate unless implementation evidence connects it.

## 2026-10-22 — found-gates FG-R1 correction (not released)
- P2, same assigned RTL reachability finding: the old range also incorrectly exempted unreachable RTL right/start-side overflow. Finisher reports a causal RED and repair in 693245e, with public-wrapper negative controls retained. This is an extension of FG-R1, not a duplicate new assignment; NEW fresh Sol high review is running. Evidence: `evidence/found-gates/finisher-r1/` (`regression-red.log`, `mutation-results.json`, `verification-summary.json`). No canonical tooling closure or release claim; font and consumer-adoption holds remain.

## 2026-10-22 — pdf-direct-download saved-iovjet diagnosis
- **Test gap, not a demonstrated stripping bug:** existing panel PDF upload/save/removal tests use a separate text-only payload rather than reconverted button attributes at final copy. Four new read-only diagnostic cases through picker/store/reconversion/finaltextarea/copyattempt retain metadata, but native clipboard and installed Bricks remain untested. A future scoped fix needs a regression at the real final boundary, not emitter-only green. Evidence `evidence/pdf-direct-download/live-diagnosis-saved-iovjet/`,24 verified targets; gated plan `pdf-direct-download-live-followup.md`.
- **Missing input, not a root cause:** supplied saved Bricks copy/current matching liveiovjet lack attrs; actual pre-Bricks plugin output is not yet available. Mutabledebug20.6 is unrelated/noPDFassignment; coexisting V1/V2 registration does not prove which running build produced the paste. No speculative code fix authorized.

## 2026-10-22 — pdf-direct-download live check3be FAILED
- **MAJOR, installed/live outcome unresolved:** freshly served Services PDF anchor lacks download/target/rel after user purge/re-paste report; both freshMISS/no-cache responses and isolatedChrome reproduce same-tab viewer/no download. Direct valid200PDF has no redirect. Need ONLY saved Bricks button Copy JSON to distinguish missing pasted settings from Bricks retention/render loss; no root cause guessed or source fix started. Evidence `evidence/pdf-direct-download/live-check-3be/20261022T174106Z/`,48 parent-verified targets. Source22.7 release is not live acceptance.
- **Separate content observation:** current linked PDF contains meeting notes, not inventory. Replacing the file is not a remedy for the missing download attribute; no destination was changed.

## 2026-10-22 — pdf-direct-download integration finisher
- **MINOR, tooling:** normal merge-lock acquisition emitted stat/age diagnostics (`File: unbound variable`, integer expression error) before LOCKED. Actual owner and sibling release were independently read back; own lock later released/read back free. Shared script was not changed. Evidence `evidence/pdf-direct-download/finisher-integration/lock-ownership.json`, `merge-lock-release.json` and retained acquisition output. Separate tooling follow-up, not a PDF correctness finding.

## 2026-10-22 — pdf-direct-download fresh reviewer (released build2026-10-22.7; live acceptance owed)
- ~~**R1 MAJOR, introduced:** default inline-picture mode mapped PDF-linked image elements to Divs; the new predicate incorrectly made pictures download.~~ **Fixed and released in build2026-10-22.7, `977fcce7fc1e2fac834d3721c23050447f61e927`**: semantic image/vector roles retained across both picture modes, vector-only/masked/mosaic and marquee controls; causal RED/GREEN and intended mutations catch it, restored controls pass. NEW independent review and verifier CLEAN/zero findings at0f07f09/base8f538bb. Evidence `evidence/pdf-direct-download/verifier-integrated-0f07f09/` (244 rehashed targets) and `release/`; installed/user acceptance3be remains owed.
- **R2 MINOR, introduced; accepted limitation, NOT fixed:** same-origin PDF302 to another origin can replace the current page without downloading. Reproduced headed/headless; Justin explicitly chose **“Keep direct downloads; accept that redirect limitation.”** Released under that exact direct-file contract in22.7, not universal fallback or a passing historical redirect oracle. No server/script mechanism; historical failing receipts remain in `finisher-r1r2/`, fresh observation/provenance in verifier/release archives.
- ~~**Non-blocking whitespace:** new blank line at EOF in `test/unit/pdf-direct-download.test.ts:137`.~~ **Repaired and released in22.7 (`977fcce`); final `git diff --check` clean.**
- **Existing font gap remains OPEN/UNVERIFIED:** final-design Garamond Condensed is still absent; same18 findings/equal reports do not establish completeness. Justin chose **“Allow this PDF release with that font check marked unverified.”** This waives only the pre-existing named hold for **pdf-direct-download22.7**, with no substitute, expected-set narrowing, weaker test or sibling waiver. Every other required gate remains required; no font fix/green claim.

## 2026-10-22 — pdf-direct-download builder
- **INFO, plan correction:** headless Chrome 155 (`--headless=new`) did not automatically download every PDF in the builder's probe; `_blank` opened the PDF viewer and saved nothing. Correct the planned rules-summary warning rather than preserving the disproved assumption.
- **INFO, browser-test noise:** opening a PDF viewer can leave `downloads.html*.crdownload` stubs without a download event. The feature test keys on download events and the server filename, not the stubs.
- **INFO, host cleanup deferred:** orphaned headless Chrome processes from `card-hover-shift` (parent PID 1, cwd in that worktree) were still running. The pdf-direct-download builder left them alone and killed only its own orphan.

## 2026-10-22 — pdf-direct-download planner
- **MAJOR, live paste contradiction:** `/services/` (modified 2026-10-22T12:26Z) renders PDF Div `brxe-gcolzx` with no `target` or `rel`, although pdf-new-tab build 2026-10-21.18 emits `link.newTab:true` and `rel:noopener`. Either installed Bricks 2.3.9 drops those fields on a linked Div or the page contains an older paste; copy-back check 3ar is still needed to distinguish them. Not fixed by planning.
- **MINOR, stale docs:** `CLAUDE.md:285` still lists the Download full inventory PDF button under Waiting on the user as “plugin needs no change,” although csv-list-pdfs .16 and pdf-new-tab .18 shipped. Update in build order; protected-file approval rules still apply.
- **MINOR, site setting not code:** the Maps Button on `/services/` renders `target=_blank` without `rel=noopener`.
- **INFO, overlap unknown:** no `hero-media-row` plan file existed under `~/.hermes/plans/figma-to-bricks/`, so pdf-direct-download could not verify overlap with it.

## 2026-10-22 — found-list-head planner
- Low, list layout decision: adapt/rules/list.ts:22 keepsSize lets fixed-width record badges shrink; D1 pins this existing policy. Separate decision, NOT included in head-scoped badge recognition. Evidence evidence/found-list-head/probe-head.out.txt; plan found-list-head.md.
- Info, not reproduced: markColumns dots uses hug-only pilled, so fixed badge after first more column might get a dot before words; fixture did NOT reproduce this. Keep unverified, no fix/closure claim.

## 2026-10-22 — found-gates planner (Round 3)
- Low, tooling audit: font-sensitive browser load helpers request web fonts but lack expected/loaded assertions (pill-holder.test.ts, clipped-pills.test.ts, narrow-buttons.test.ts, peer-sides.test.ts, equal-cards.test.ts, one-line.test.ts, text-link-followups.test.ts; exact locations in found-gates.md Consumer tracing). This proves missing guards, NOT that each currently lacks a font. Broad migration deferred; layout/tiles own guards in their newly changed consumers. Snap's demonstrated missing-style admission gap is assigned to found-gates, corpus completeness already fixed in .3. Evidence: evidence/found-gates/planner/.

## 2026-10-21 (list-panel-followups reviewer/finisher)
- Low (LPF-UTF16, panel, pre-existing reader + newly offered `.txt`): Excel "Unicode Text (*.txt)" saves UTF-16LE with a BOM; the panel reads files with `File.text()` (UTF-8), so a header `Model\tType` becomes NUL-interleaved columns and blank NUL rows (`list-box.ts` pick → `lists.ts parseCsv`). UTF-8 CSV/TSV are read correctly; no decoder was added (not approved). Fix needs a scoped BOM/UTF-16 decode decision. Proof: `evidence/list-panel-followups/reviewer-fresh/probes/utf16-probe.mjs`; branch rerun `.superpowers/sdd/list-panel-followups/fix/utf16-probe-branch.txt` (archived with the finisher evidence).

## 2026-10-21 (phone-recognition-guards builder; unreleased candidate blocker)
- ~~Medium (PHG-CARD; candidate-induced, not shipping): contacts-only P1A/P2A removal of false ID/date dial links unmasks inferred whole-card navigation and makes the captions eligible as titles (`normalise.ts:261–264`, `card-title.ts:30–35`, `page-links.ts:264–270`). Exact .19 versus attempted guards: plain card → `/available-parts/`; equally prominent ID drops intended title; ID/date-only headlines invent `/order-id-0812-473-1900/` / `/updated-2026-10-21/`. Explicit linked-pill control unchanged. Both proposed guards restored out of source; seven baseline consumer regressions committed in the stopped feature worktree, three fail with proposal reapplied. Requires separate dispatcher/card-owner semantic/source-scope decision; canonical recognizer row stays open. Proof: `evidence/phone-recognition-guards/builder/consumer-observations.json`, `consumer-proposed-red.log`, unreleased `proposed-contacts.patch`.~~ ✅ fixed in build 2026-10-21.23 (phone-recognition-guards, P3A: titles/labels/card targets/addresses exclude rejected ID/date data)

## 2026-10-21 (pdf-new-tab reviewer; pre-existing renderer limitations)
- ~~Low (FE1, tooling): `test/browser/render.ts:135` synthesizes `rel="noopener"` from `newTab`, ignoring native `settings.link.rel`; browser-only checks cannot catch missing native rel.~~ ✅ fixed in build 2026-10-22.3 (renderer-proof-hardening, 6a7b744): native rel copied literally, missing/empty stays absent, unit/browser negative controls. Installed Bricks 2.3.9 Button/Div copy-back and actual PDF frontend checks remain owed; schema 2.4.3/local HTML navigation probes are not live compatibility proof.
- ~~Low (FE2, tooling): linked images get `_attributes`/copied `tabindex=-1` on the child image instead of the wrapper anchor (`render.ts:131,142–144`).~~ ✅ fixed in build 2026-10-22.3 (renderer-proof-hardening, 6a7b744): supplied linked img/figure tabindex routes to the actual anchor, real Tab and converted-marquee controls pass. Payload unchanged; no observed live-Bricks defect or installed-version sign-off claimed.

## 2026-10-21 (link-upload-fixes reviewer)
- ~~Medium, pre-existing — LINK-RENAME-COLLISION: an owned upload renamed catalog → catalog-image can occupy another protected link /catalog-image/ while its Match still says picture=false. ui/site-media.ts checks occupancy before the rename but does not re-index the destination. Reproduced offline in both baseline and feature; intentionally not fixed by B2. Evidence: evidence/link-upload-fixes/finisher/reviewer/media-edges-{tip,baseline}.json and finisher/media-edge-probes.json.~~ ✅ fixed in build **2026-10-22.4** (`09337db`, media-rename-collision/Q1A; main/origin/remote verified equal). Deterministic protected-path reservation, actual exact-ID full-set occupancy and independent move history pass fresh review (0 findings, 7 mutants) and final integrated check 2098+6/browser240; 5 exact payloads/HTML and 29 equal width reports. Only Garamond Condensed remains explicitly UNVERIFIED under Justin's narrow M1A release waiver; no stand-in/expectation narrowing. Evidence `evidence/media-rename-collision/finisher-m1a/integration3/`; normal-workflow conversion/paste check **3bc still owed**, not live-site/redirect sign-off.

## 2026-10-21 (emergency-cta-width planner)
- ~~Medium: Info card 'Call Us Now' button label wraps onto 2-3 lines at 768-480 (label gets _widthMin:tablet_portrait 0).~~ ✅ fixed in build 2026-10-21.8 (cta-label-wrap)
- ~~Low: header 'SCHEDULE NOW' (IBM Plex Mono 800) drawn in Times-Bold on Home and Repairs; Google has no Plex Mono 800.~~ ✅ fixed in build 2026-10-21.3 (font-weight-gaps)
- ~~Low: Saira Condensed Thin/ExtraLight uploaded as weights 250/275, so designs using 100/200 don't find them.~~ ✅ fixed in build 2026-10-21.3 (font-weight-gaps)
- ~~Low (tool): npm run snap --sides pairs Figma sections in layer order, not top to bottom (tools/snap.ts ~line 85).~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); visible/wrapped bands sorted top-to-bottom, CLI pixel checks and selector mutations verified.

## 2026-10-21 (phone-side-padding and early-line-breaks builders)
- ~~Low-medium: phone numbers in running text split across lines ('(800)' / '457-3160' in the hydraulics 'Call Us Now' card at 452 on main, from 478 after phone-side-padding). Needs a no-break for phone numbers.~~ ✅ fixed in build 2026-10-21.10 (text-breaks); too-narrow units may wrap internally; partially crossing anchors remain the documented conservative fallback.
- ~~Medium: typed line breaks kept on phones wrap into long+short lines (Services/page-1 Gary Strickland review 'Been with a ton / of companies' at 390); text.breaks only drops ragged breaks.~~ ✅ fixed in build 2026-10-21.10 (text-breaks)
- ~~Low-medium: a wrapping row with divider lines (final-design stats) leaves dividers hanging at line ends on phones, items out of line.~~ ✅ fixed in build 2026-10-21.4 (phone-side-padding)
- ~~Low: the rag test treats a two-line street/city address as a rag, so corpus design's address splits mid-city below the design width ('Suite 100 Fort' / 'Collins, CO 80525').~~ ✅ fixed in build 2026-10-21.10 (text-breaks)
- ~~Low, harmless: text.breaks reads the IR source text, not the emitted words (FAQ placeholder br rule hid nothing).~~ ✅ fixed in build 2026-10-21.2 (early-line-breaks; verified by text-breaks)

## 2026-10-21 (cta-label-wrap and font-weight-gaps planners)
- ~~Medium: Repairs page at 480, the 2-column service grid's card titles squeeze to 31px ('Rods 1″–15″ & Rechroming Rods' on 6 lines); the title's floor (_widthMin:mobile_landscape 0) lets go.~~ ✅ fixed in build 2026-10-21.17 (layout-floors)
  - B7 read-only matched replay also confirms the 479px boundary: “Core Exchanges” (`#brxe-auatwe`, emitted `_widthMin:114`) reaches 486px; neighbouring service titles are 31px wide. Exact 6ba11f5 and B7 replay pastes/full HTML, full findings and geometry agree. No B7 regression/fix; leave with B5 layout-floors triage. Evidence: `evidence/text-link-followups/acceptance-proof.json` width 479 and `debug-final-snap.log` under this plans folder.
- ~~Medium (covered by cta-label-wrap W2A): the design file's pill buttons wrap at laptop widths (style/style.ts:193-196 drops a held label's floor below the design width).~~ ✅ fixed in build 2026-10-21.20 (pill-clip): whole-label rows wrap; all35 services one-line/39px992–1920, header992/1024/1200 no peer overlap. Above-design header/form wraps remain separate.
- Site setting (not code): the Theme Style sets all body text to Saira 800; anything without its own weight inherits it (header button, Figma 600). ⚠️ checked in 2026-10-21.6: fresh pastes keep Figma weights (regression tests added); the header template still needs 600 set by hand in Bricks.
- Low (speed): each pasted page loads its Google fonts twice (Bricks' link with every weight, plus the paste's own @font-face copies).
- ~~Low: the panel note for a weight Google lacks doesn't say which weight shows instead.~~ ✅ fixed in build 2026-10-21.6 (fonts-cleanup); notes name confirmed supplied alternatives or an explicit unknown, not a guaranteed rendered replacement. F1 partial-response classification remains open (fixed in 2026-10-21.9).

## 2026-10-21 rechecks of merged features (full skill set)
### equal-card-heights (build .15): "not safe for every design" (Justin's own files fine)
- ~~MAJOR R1: row-direction cards (icon beside words, centred) shift content down at full width once 3B trims their bottom padding (probe: +26px). 'Nothing moves at the design width' is false for them.~~ ✅ fixed in build 2026-10-21.7 (equal-card-fixes)
- ~~MAJOR R2: on tablets a stretched row card turned column gives free height to a fixed child left with flex-grow 1 (from fillsItsRow); square photo/icon becomes a tall strip (64x64 -> 64x116). Root: rows stacking rule doesn't reset a fixed frame's _flexGrow at tablet.~~ ✅ fixed in build 2026-10-21.7 (equal-card-fixes)
- ~~Minor R3: hugging card with a Figma min height and centred content loses its centring (2A rule assumes no free space).~~ ✅ fixed in build 2026-10-21.7 (equal-card-fixes)
- ~~Minor R4: ~20 more guards with no test (48 mutations, 24 survived; list in the recheck transcript deleg_146cb0ac/task-1.log).~~ ✅ fixed in build 2026-10-21.7 (equal-card-fixes)
- ~~Minor R5: sidesAt adds the outline only when padding was written; outlined box with 0 padding gets 2x outline too much room (main too).~~ ✅ fixed in build 2026-10-21.17 (layout-floors)
- ~~Nits: R6 pills test held by the round rule not the button rule; R7 dead ELLIPSE branch and unreachable space-between exception.~~ ✅ fixed in build 2026-10-21.7 (equal-card-fixes)
- ~~found: size.unpin zeroes _heightMin:tablet_portrait on fixed boxes held open by flow content (photo card collapses to 60px at 990; numbered-step boxes shrink 82->26).~~ ✅ fixed for drawn-shape boxes in build 2026-10-21.17 (layout-floors). ~~Timing tests flaky under load (7/54).~~ ✅ test-runner contention fixed in build 2026-10-21.12 (test-cleanup): serial performance gates still run in check, unchanged 3000ms/800ms limits; host load can still affect timings. The preceding size.unpin drawn-shape defect is fixed; ordinary flowing boxes still intentionally let their heights go.
### link-hrefs (build .14): "safe to keep"
- ~~Minor R1: WordPress names an upload after a JPEG's IPTC/EXIF title, not the file name, so -image doesn't always set the address. Fix: send slug=<stem>-image with the upload.~~ ✅ fixed in build 2026-10-21.11 (link-upload-fixes); explicit transmitted-filename stem slug on every upload/fallback/video route.
- ~~Minor R2: a kept link whose address opens a post can still open someone else's picture (shared slug), and the note says the opposite.~~ ✅ fixed in build 2026-10-21.11 (link-upload-fixes); original and candidate media occupancy determines final href and honest notes.
- ~~Minor R3: repairing old pastes relies on WordPress's loose 404 guess (first LIKE 'x%' match, unordered; SEO plugins can turn it off).~~ ✅ fixed in build 2026-10-21.11 (link-upload-fixes); new pastes use exact canonical hrefs; old saved pages explicitly require re-convert/re-paste, no redirect guarantee.
- ~~Minor R4: browser panel tests still red (test-cleanup fixes).~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); safe upload-name expectations corrected, integrated browser 154/154 with all newer B2 cancellation/payload tests preserved, no skips.
- ~~Minor R5: 11 of 41 mutations survived; main gap: 'a picture attached to no page sits only at /<slug>/' untested.~~ ✅ fixed in build 2026-10-21.11 (link-upload-fixes); coverage gap closed by root/full-path tests and three explicit killed path mutants; not a production fix or claim all 41 were rerun.
- ~~Nits: R6 a refused rename counts as done; R7 some media links pass (?attachment_id=, .ogg/.jfif/.apng/.avi/.mkv); R8 Convert renames media even in 'inside the JSON' mode and after Cancel.~~ ✅ fixed in build 2026-10-21.11 (link-upload-fixes); all R6–R8 verified: exact-ID readback, common media/opaque-ID policy, active WordPress-picture writes only, queued and post-Outcome panel cancellation.
- ~~found: payloadProblems only runs in tests (no call in src/), though CLAUDE.md says it refuses file links.~~ ✅ fixed in build 2026-10-21.11 (link-upload-fixes); assertPayload operational at core/final panel boundaries; invalid paste never copied.

## 2026-10-21 (emergency-cta-width builder)
- ~~Low: site-fonts.ts addFonts (line ~139) counts a dropped font as 'already there' only on an exact weight match, while fontPlan treats a variable range ('100 900') as covering it, so a static 500 is uploaded beside a variable copy and the CSS gets two rules for 500.~~ ✅ fixed in build 2026-10-21.6 (fonts-cleanup); redundant upload fixed. Current CSS already selected one shared-weight rule before this batch.
- ~~Low (test honesty): other WordPress stand-ins in test/fixtures/panel.ts and panel.test.ts STUB were never checked against WordPress's real answers (paging, newest-first, _fields). Worth a pass in test-cleanup.~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); four archived upstream source files audited, shared paging/order/nested-fields font collection helper mutation-proven; scenario-only upload/refusal injections remain explicitly scoped, not a full WP emulator.

## 2026-10-21 (phone-side-padding reviewer)
- ~~Low-medium: the 39/40 cliff in sideAt (pre-existing): any side of 40+ gets capped at 20 on upright phones, but a 39px box keeps 39 (Repairs product box kffcjo). Near-identical designs get very different phone padding.~~ ✅ fixed in build 2026-10-21.17 (layout-floors)
- ~~Low: P2B leftover: GRO 'Let's talk' shows the tablet's 22px sides on sideways phones while the layout plan assumes Figma's 34 there (plan and CSS disagree at that tier).~~ ✅ fixed in build 2026-10-21.17 (layout-floors)
- Low: inspo-brainstorm 'Industries' pills strip (absolute block) has a rough phone layout; longest pill runs past the screen (scrollable).

## 2026-10-21 (phone-side-padding finisher)
- ~~Low: the layout plan still counts a divided item's drawn padding and line after its row breaks (plans slightly less room than the paste gives; safe).~~ ✅ fixed in build 2026-10-21.17 (layout-floors)
- ~~Low (tooling): the hydraulics page score moves up to 0.006 between identical runs (moving logo strip), wider than the ±0.002 noise noted.~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); finite-end/infinite-zero capture policy and honest legacy non-comparability documented; matched-font/motion full reports equal, tolerances unchanged.

## 2026-10-21 (fonts-cleanup planner)
- ~~Low-medium: src/ui/fonts.ts:44–45 treats any nonempty HTTP-200 family response as complete; a real IBM Plex Mono 400+800 request returns only 400, yet loadGoogleFonts reports missing:[].~~ ✅ fixed in build 2026-10-21.9 (google-partial-fonts)

## 2026-10-21 (equal-card-fixes planner)
- ~~Low, Justin's Services page: at 768 a parts-table cell wraps a word that would fit, because the layout plan counts the outlined 0-padding table panel 4px too wide (R5); record row 111px instead of 87 (brxe-kyjtff). Fixing R5 un-wraps it.~~ ✅ fixed in build 2026-10-21.17 (layout-floors)

## 2026-10-21 (text-breaks planner)
- ~~Medium: phone numbers crossing styled runs get no automatic dial link; normalise/contact-links.ts:175 requires a match wholly within one run (generic probe confirmed).~~ ✅ fixed in build 2026-10-21.15 (text-link-followups)
- ~~Low: long two-line opening hours also get the break-hiding rule; adapt-breaks.test.ts:81–90 expects it. Line-item follow-up.~~ ✅ fixed in build 2026-10-21.15 (text-link-followups)

## 2026-10-21 (layout-floors planner)
- ~~Low-medium: the same 39/40 jump on top/bottom padding (39 stays 39 on upright phones, 40 becomes 24), space.ts:47-54.~~ ✅ fixed in build 2026-10-21.17 (layout-floors)
- Low: inspo Selected-work sideways strip (absolute 3147px row feuwkb): at 390 its container gaikeu sits at x -828 and the panel has no gutter.
- Low (historical repro, not a pill-clip release win): GRO 'Let's talk →' was163×76 at768; exact .17 and integrated .20 both331×60 at768. The original geometry changed before this batch; installed paste verification remains3at. Do not credit .20 with fixing that old measurement.

## 2026-10-21 (frame-text-links builder)
- ~~Low: linkNotes names only the first words for an address several links share (ui/site-pages.ts linkNotes uses m.link.words, one per address). Also true for element links.~~ ✅ fixed in build 2026-10-21.15 (text-link-followups)

## 2026-10-21 (frame-text-links reviewer)
- ~~Low (tooling): corpus section scores swing far beyond ±0.002 with byte-identical pastes (hydraulics section 3 structure 0.279 vs 0.587).~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); capture policy freezes before geometry and tiles, matched five complete reports exactly equal; no widened noise allowance.
- ~~Low: marquee loop copies give tabindex=-1 only to elements that are links; a link inside a text's HTML in a loop copy is still Tab-reachable (emit/elements.ts marqueeAttributes).~~ ✅ fixed in build 2026-10-21.15 (text-link-followups)

## 2026-10-21 (equal-card-fixes builder)
- Low-medium: fixture snap shows a stacked row-card section 59–185px off its Figma height at 990/768/600, with words-per-line lint at 768/600 (rowCentred); same before and after B4, likely tablet sizing/space.ramp (layout-floors territory).

## 2026-10-21 (equal-card-fixes reviewer)
- ~~Low-medium: R2's problem also at the 'two per row' stage: row.reflow doesn't reset flex-grow on a fixed item that keeps its size, so a small fixed frame grows sideways (probe twoShare: 64px icon frame 272x63 at 600, 52x63 at 768; same on main). Fits layout-floors (rows.ts).~~ ✅ fixed in build 2026-10-21.17 (layout-floors)
- Low: R2's reset reads only the desktop flex-grow; a divided row that row.reflow gave flexGrow 1 at its 'wrap' stage keeps it once stacked (code reading, not measured).

## 2026-10-21 (cta-label-wrap builder)
- ~~Medium (also on main): design file at1024, pill labels cut off because radius-only overflow:hidden lets them shrink below words.~~ ✅ fixed in build 2026-10-21.20 (pill-clip): service text-clipped1200/1024/9923/8/8→0/0/0; whole pills wrap and corners still clip. Installed Bricks2.3.9 native clip copy-back remains owed3at.
- ~~Low (tooling): `npm run snap -- … --sides` wrote only full-page PNGs for hydraulics-home.json, no Figma-vs-built section pictures.~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); wrapped bands pair correctly, hydraulics 13 real section pairs, real CLI regression/mutation proof.
- ~~Low: src/core/adapt/layout.ts at 283 lines, near the ~300 cap; split before the next change there.~~ ✅ fixed in build 2026-10-21.17 (layout-floors)

## 2026-10-21 (cta-label-wrap reviewer)
- ~~Low (pre-existing): size.unpin judges a surviving button min-width floor against the planned375px phone instead of its real narrower row.~~ ✅ fixed for surviving button floors in build 2026-10-21.20 (pill-clip): cap to actual parent100%; hydraulics320248px in248px row, contained label wrap;375/360 contained. This is not a blanket fix to every min-width rule or global corpus widths.
- ~~Low: three empty stray files l1100.txt, l1280.txt, l1366.txt tracked in the repo root since the first commit (515eec5).~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); verified empty/unused and removed.

## 2026-10-21 (pill-clip planner)
- ~~Low (tools): npm run snap renders without the corpus font stand-ins (Mont→Montserrat), so its lint disagrees with corpus/wraps (design @1024: 21 cut vs 8). Fits test-cleanup.~~ ✅ fixed in build 2026-10-21.12 (test-cleanup); configured stand-ins shared, CLI mutation test; design @1024 8 cut, matching corpus.
- Medium, deferred after Fold investigation: GRO @1440, #brxe-eixorr 'Client Name — Lifestyle': four texts cut by an off-edge composition drawn beyond its section, not radius-only pill shrink. Remains open after .20; details below.
- ~~Low: GRO #brxe-kcabyv '04' cut at 991–480, and #brxe-qljtcd 'Contact' at 768, on both builds.~~ ✅ fixed in build 2026-10-22.1 (gro-composition-clipping G2/G3). Laptop TOC 4th picture cut at 992–1200 stays OPEN (see 2026-10-22 00:15).

## 2026-10-21 (card-link-words planner)
- Low (docs): an arrow pill ('Learn more →') in a card with nothing else to click becomes a Div inside the whole-card link, not a Button (intended, no nested links), but CLAUDE.md's Buttons decision doesn't say so.
- Info: Justin's on-disk debug file is build 2026-10-20.6 and has no text links; a re-export is needed to test frame links on his own design.

## 2026-10-21 (cta-label-wrap finisher)
- Low: a drawn input field (painted box, placeholder at its left) counts as a button in adapt/least.ts buttonLike, so its placeholder is held on one line; structure can't tell it from a left-worded painted link box (review F7, ruling).
- Low: held buttons' white-space is per-element _cssCustom; one purpose-named class would be smaller once adapt can add classes (review F9).
- ~~Low: design file at992: service pills spill and clip in their boxes.~~ ✅ fixed in build 2026-10-21.20 (pill-clip); whole pills wrap, one-line39px, no service clipping. Not all unrelated clipping findings are closed.

## 2026-10-21 (google-partial-fonts reviewer)
- ~~Medium (pre-existing): src/ui/fonts.ts:84,89–94 appends Google's returned CSS to _cssCustom unchanged, so a returned `font-weight: 100 900` range would land in a paste (breaks the no-range rule). Synthetic repro in ~/.hermes/cache/scratch/google-partial-fonts-review/review-proof.json edgeCases.range; not seen in a real discrete-weight answer yet.~~ ✅ fixed in build 2026-10-21.21 (google-font-range-policy): ranges paste only as covered design weights; escaped/comment-hidden weights left out. Duplicate loading (Low, speed) stays open/HELD.
- ~~Low (pre-existing): fonts.ts:41–47 descriptor validation accepts malformed values ('oblique nonsense', mismatched family quotes) as confirmed coverage. Hardening only.~~ ✅ fixed in build 2026-10-21.13 (google-font-hardening)

## 2026-10-21 (test-cleanup builder)
- ~~Low (tooling): fontStatus can miss a failed external stylesheet: Yellowtail appeared in neither loaded nor failed arrays during a network-dependent run.~~ ✅ diagnostic gap fixed in build 2026-10-22.3 (renderer-proof-hardening, 6a7b744): expected/missing separate from observed loaded/failed; Unicode-caseless comparisons and all-current/empty/absent-baseline actual-CLI rejection. Original incomplete evidence retained; this does not fix network availability or the genuine missing Garamond Condensed font (UNVERIFIED under M1A, no substitute/expectation narrowing).

## 2026-10-21 (text-breaks reviewer)
- ~~Medium (pre-existing): normalise/contacts.ts:9–30 phone recogniser accepts some non-phone digit strings ('Order ID 0812 473 1900', '+2026.10.21'); prices, years, ZIPs rejected.~~ ✅ fixed in build 2026-10-21.23 (phone-recognition-guards, P1A/P2A: same-line ID marker and calendar-valid plus dates)
- Medium-low (all features): the plugin can't update global classes already on the site; Bricks only replaces them through its class-import box at paste. Any class-style fix needs a re-paste with 'replace' (photo-hover-glass planner).

## 2026-10-21 (csv-list-pdfs planner)
- Low: reference/bricks/ has no sample for link {type:'external', url}; emit/elements.ts:107 writes it from memory (works live; capture a sample).
- Low: src/ui/main.ts is 574 lines, past the ~300-line rule.
- Low: lists feature deferred minors still open: empty list name, two lists with desktop+phone frames, status after Remove, no large-CSV warning, tab-separated files.

## 2026-10-21 (hero-photo-blend planner)
- Low: pale near-white fringe under the Remanufactured hero's orange cylinder (partly clear soft-shadow pixels are light): source cut-out or AVIF q80 colour shift at partial alpha. Check the Figma original; compare a lossless upload.
- Info: the live 'Remanufactured Hydraulic Cylinders' design isn't in the debug file or corpus; an export would let checkers compare with Figma.

## 2026-10-21 (csv-list-pdfs builder)
- ~~Low (pre-existing): with a spreadsheet, a row's action button (e.g. 'Quote') can get its words replaced by a leftover column's value; PDF row buttons now keep their words, other action buttons still don't.~~ ✅ fixed in build 2026-10-21.22 (list-panel-followups, fix9656d5d/release5e32aec). Reconciled on current mainb4ed333 by found-list-actions: source+regression file unchanged, both commits ancestors; parent independently reran9 diagnostic cases and9 action regression tests, all pass. No duplicate implementation/new release. Panel check3av and unrelated findings remain open.
- Low (flake): showcase browser test 'a listing whose number sits above its photo' failed once under a busy Chrome, passed alone.

## 2026-10-21 (photo-hover-glass reviewer)
- ~~Low (test honesty): browser assertion 'the zoom is clipped inside the frame' compares getBoundingClientRect, which a child's scale never changes; passes even without overflow:hidden.~~ ✅ fixed in build 2026-10-22.3 (renderer-proof-hardening, 6a7b744): native hit-test and screenshot RGBA prove actual outside clipping; overflow-visible and never-zooming negative twins fail independently, frame geometry remains separately asserted. Busy-host listing flake above stays open.

## 2026-10-21 (layout-floors builder)
- Low-medium: least.ts sums a drawn-wrapping row's items as if on one line, so a panel holding a wrapping row of pills counts all their widths and its own row stacks early / grid drops columns (from cta-label-wrap). Fits pill-clip.
- Decision (Justin): stacked row-card height (equal-cards rowCentred): three alike row cards stay one row on tablets/sideways phones under the ALONE rule, words get 107px at 768 and 78px at 600. Changing it reverses ALONE; ask Justin.
- Low: inspo Selected-work sideways strip (feuwkb/gaikeu) at 390 still off-screen.
- ~~Low: inspo at 390, card muxfec's 32px phone sides (F2A) worsen a squeeze: qtcwtm 7→10 lines, euwsuo 'explore strategy' clipped.~~ ✅ fixed in build 2026-10-21.17 (layout-floors)

## 2026-10-21 (layout-floors reviewer)
- Low: cta-label-wrap button floors round to nearest px (hydraulics lrdbna min-width 279 vs content 279.15), so the label wraps when the floor binds; floors should ceil.
- Medium (tooling): nothing checks phones narrower than 390; corpus/lint widths start at 390 and mobile_portrait contentMin 343 assumes 375. 360 is common on Android. **Partly covered in 2026-10-21.17:** layout-floors sweeps every width 320–478 in direct/nested fixtures, with 108 matched-font real-page measurements at nine widths. Global corpus/lint widths and other min-width rules remain open.
- Low: inspo Selected-work carousel [arrow 56, content, arrow 56] stays side by side on phones (content 158px at 390), silhouette photo covers words.
- ~~Low: twoShare 64px tile still shrinks to 59×63 at 990 and 52×63 at 768 (same on main).~~ ✅ fixed by fixed-tile-shrink (tablets/phones; laptops 992–1199 still deferred).
- ~~Low: hydraulics @320:279px CTA wider than its248px row after layout-floors.~~ ✅ fixed in build 2026-10-21.20 (pill-clip):248px action inside248px real row; label wraps inside when it cannot fit one line.375/360 retain their line; no blanket fractional ceil change.
- Low, deferred F3: inspo alike pills in ugzebt still have unequal side padding, including fractional room guards. Sharing a responsive peer minimum needs peer-width planning; not fixed by layout-floors.
- ~~Introduced F2: retained fixed-height wrapping rows spread their lines through the free height.~~ ✅ fixed from tablets down in build 2026-10-21.17 (layout-floors): lines pack at the top; Services States gap 10px at 990/768/600.

## 2026-10-21 (pill-clip builder recovery; not released)
- Low, still open: wrapped-parent `least` cannot safely be changed in isolation. The tested experiment changed hydraulics grid column decisions at 768 and added words-per-line failures; it was reverted in `6ad2841`. Preserve existing grid/ALONE policy until a separately approved width-planning change. Original experiment and full measurements remain under `evidence/pill-clip/`.
- Low, Fold investigated but not same cause: GRO `eixorr` at 1440 clips a group drawn x≈1300–1648 past a 1440 section (absolute right −208); four texts remain cut. GRO `04` at 991–480 is pushed out by an inferred mixed graphic/text row; Contact at 768 is in an inferred footer row whose minima/72px gaps spill its 696px content. GRO's 992 paragraph is squeezed beyond the section by the laptop composition. These are not radius-only label clips; no carousel/composition/footer policy was changed.
- Low, still open: inspo peer pills retain unequal responsive sides (including 27.5/27.52/28 and individual content guards). Peer-width planning remains deferred; original layout-floors F3 is not marked fixed.
- Low, unconfirmed fractional-floor symptom: `.17` hydraulics emits numeric floor279 vs least≈279.32, but actual label remains one line at tablet/375/360. At320 its true248px row needs fallback wrap. No fractional-only same-path wrap demonstrated; blanket ceil remains deferred. The separate actual-row spill is fixed in2026-10-21.20, not this fractional-only hypothesis.
- Low, existing and unchanged by pill-clip: design header label `knlcug` remains two lines at1728/1920 (outside the fluid hold); form submit `cmduwd` and field `dquqjf` remain two lines at992/1024. Laptop services and header992–1600 are fixed; do not report every page button as fixed.
- Medium (tooling/network): an interrupted browser/corpus run can lose external Google stylesheets and Splide assets. Its corpus had loaded:[] and failed:[] for every file, with two null-Splide browser assertions. Raw run retained as non-comparable; clean rerun passes168/168 and matched fonts restore the same17 known v1 differences. This is evidence to check loaded-family sets and retry assets, not a reason to weaken tests.

## 2026-10-21 (pill-clip finisher; released .20)
- ~~F1 medium: laptop wrap emits nowrap but leaves fill holder basis/minimum0, clipping a long generic pill at992/1024/1200.~~ ✅ fixed in build2026-10-21.20 (pill-clip): capped structural fill-holder minimum at the new wrap's proper design-width scope. Exact reviewer3RED/3injectedGREEN; new4RED/1hugcontrol and integrated old-writer mutation4RED/1control; focused15GREEN. No grid/ALONE/twoShare/wrapped-parent-minimum expansion.
- Main19 integration complete; actual release `b5a253f`, main/origin/remote equal, source/build/dist verified. Check1739+6/browser173, same17 corpus v1 identities, no same-base regression;164 matched-font/motion pairs no new findings/multiplicity/distorted circles. Final proof/screenshots/manifest in `evidence/pill-clip/finisher/`; prior443 builder +825 reviewer targets preserved/verified.
- The Fold deferrals above stay open; no claim all B6 findings fixed. Installed nativeclip/save/copy-back3at still owed; proposed CSS fallback also not installed-tested. Protected CLAUDE denial not retried/bypassed; exact `pill-clip-claude-md-pending.md` saved, older pending files untouched. No site writes.

## 2026-10-21 (GRO composition planner; not implemented)
- ✅ fixed in build 2026-10-22.1 (gro-composition-clipping): ~~Medium, assigned gro-composition-clipping G5: off-edge content card retains drawn525px height when composed into phone column, grows past box and wraps final row into clipped second column at390–320. Scratch auto-height control clears390/375/360/320; builder must reproduce/save proof. Evidence: evidence/gro-composition-clipping/, gro-composition-clipping.md.~~
- Low, deferred G6: turned hero 'Vertical locator' text clips at480/479; not owned by current G2/G3/G5 source fix.
- ~~Low, deferred G7: GRO16px horizontal overflow at320 remains a separate diagnosis; not claimed fixed by current composition plan.~~ ✅ resolved in build 2026-10-22.1 as a side effect of gro-composition-clipping F4 (`gxwsos` 0..W at 320/340/360; `eixorr` overflow → 0).
- Disposition update for repeated GRO rows110/111/166: G1 desktop off-edge composition matches intentional Figma cropping (not converter bug, no redesign); G4 paragraph squeeze follows approved laptop P1A (deferred policy). G2/G3 share inferred-row percentage-margin bug and are assigned to bounded place.ts fix. Rows stay open/annotated until verified build; no broad closure.

## 2026-10-21 (responsive-pill-planning planner; not fixed)
- Low-medium: inspo arrow-picture row below768 allocates shrinkable widths in the plan but emitted two56px arrow pictures stay fixed; at375 the pills receive143px actual vs230.9px planned. Outside fixed-tile compact-box scope; remeasure after fixed-tile merges, no duplicate builder. Evidence: evidence/responsive-pill-planning/planner-main22/ and responsive-pill-planning.md.
- Low, unconfirmed coupling: laptop rows lugbjl/rnwkav switched to wrapping in reverted6ad2841 although own widths did not change. Preserve as width-planning investigation, not an independently fixed defect.

## 2026-10-21 (google-font-range-policy reviewer + finisher; pre-existing, not fixed there)
- ~~Low (pre-existing, synthetic): src/ui/fonts.ts `suppliedFaces` (the .13 metadata reader) reads only the first `font-weight` after `{`/`;`, so a commented (`font-weight/**/: 700`) or repeated weight makes the panel say 400 while Chrome 155 uses 700. Bytes stay verbatim and single-number.~~ ✅ fixed in **2026-10-22.2 (font-reporting-tests)**, pushed `51bbd2e`; typed executable metadata, last supported repeat, true-absence defaults. Accepted static CSS/request policy unchanged; strict projection/raw guards separate. Fresh review plus integrated2010+6/browser225/focused261/panel18 pass. Evidence: `evidence/font-reporting-tests/finisher/`, conversion/panel3bb owed. Historical probe: evidence/google-font-range-policy/reviewer/escape-probe.json, finisher/escape-oldnew.txt.
- Info: Chrome 155 rejects `font-weight: normal bold` in @font-face although CSS Fonts 4 allows keyword endpoints; the reader leaves it out (Q3A), so no paste change. Reversed `700 300` Chrome accepts, Q3A deliberately drops (approved).
- ~~Low (tests): the panel's bundled browser suite has no `googleFonts` coverage; Google-face projection is proven in node unit tests only.~~ ✅ fixed in **2026-10-22.2 (font-reporting-tests)**, pushed `51bbd2e`; real rebuilt-panel18/18 Google-enabled cases assert rows/notes/copied payload/clipboard/request trace and independent Chrome CSSOM; full integrated browser225/225. No physical-font or installed-Bricks claim; conversion/panel3bb remains owed.

## 2026-10-21 20:33 — phone-recognition-guards P4 builder
- (minor, pre-existing on main) addressIn keeps "• Order ID 0812 473 1900" when an ID follows an address on the SAME line after a bullet ("12836 Hwy 57, Evansville, IN 47725 • Order ID …"), so a live map query includes it. Evidence: evidence/phone-recognition-guards/p4-builder/. Owner: none yet (address policy; phone-guards grant limited to restoring main).
## 2026-10-21 20:30 — hero-photo-blend fix pass
- (info) iOS 18.6 WebKit loses the filter drop-shadow intermittently on converter pages but not on hand-written pages with the same picture; root cause unknown. Evidence: evidence/hero-photo-blend-safari-fixpass/raw/site/shots/ios186-*. Accepted by Justin (option 2).

## 2026-10-21 20:47 — phone-recognition-guards fresh review (all pre-existing, same on main)
- (minor) "Updated +2026-10-21 10:30" read as phone "+2026-10-21 10" → tel:+2026102110; addressIn keeps "Updated :30" under an address. P2A covered whole-candidate dates only.
- (minor) Double-spaced label "View ID  0812  473  1900 →" guesses /id-0812-473-1900/ (label-side twin of review F1; raw rejectedIn misses multi-space groups).
- (minor) addressIn("Order ID 0812 473 1900, 12 Market Street, …") → "Order ID , 12 Market Street, …"; address then "ID" line then number → "…, ID".

## 2026-10-21 21:07 — fixed-tile-shrink builder (pre-existing)
- (minor) Empty fixed box (drawn shape) in a kept row: layout plan shares less width (66.3px at tablet) than its CSS floor keeps (min(90px,100%)), so neighbours' lost room is under-counted. Repro test/fixtures/fixed-tiles.ts tile('T',{width:90,height:90,auto:true,label:''}) in tileRow peers [420,380].
- (minor) Repairs breadcrumb row ('Home' > 'Services' > 152px fixed text) spills 1px at 320 with or without the fix.
- (info) Desktop: Services' 52px numbered circles and GRO's 14px marks render at their words' width (50–51px, 11px), not drawn width — style sizing.ts.

## 2026-10-21 (phone-recognition-guards finisher)
- Low (consistency, not a regression vs main): `page-links.ts` `allowed()` vetoes a whole-card link only for rejected data in the raw words; a card holding a spaced-out ID (`Order ID  0812  473  1900`) beside a real title still links to the title, exactly as main did (main made no dial link there either). A card with a single-spaced ID stays plain. Fold the collapsed reading into the veto only with a decision on which is wanted.

## 2026-10-21 21:41 — fixed-tile-shrink fresh review
- (low) Fixed tiles still shrink on laptops 992–1199 (58.9x64 @992) then jump to 64 @991 (out of fixed-tile scope).
- (possible, unverified) unpin.ts:106 min(Npx,100%) button floors at mobile_portrait may make a hugging row too narrow and wrap its label on phones (same mechanism as fixed-tile F1) — fixed-tile fix pass checks it.
- (existing) inspo/brainstorm file scrolls sideways at most widths (1440:177, 375:7, 320:62px) — may overlap Selected-work strip/carousel items.

## 2026-10-21 22:31 — fixed-tile-shrink re-review
- (low, main too) Auto-layout tile fixed both ways counted as an icon row's 'words' (88x88 '12' tile beside 24px icon) collapses to its label width on tablets/phones (19.3x88 from 990 to 320): row.icons writes widthMin 0, flexShrink 1 (adapt/rules/icons.ts). Evidence evidence/fixed-tile-shrink/rereviewer-opus/probe2.ts iconPhoto.

## 2026-10-21 22:43 — gro-composition-clipping builder
- (minor) A single framed card drawn past a section's edge (one frame) is never grouped by normalise/past-edge.ts (needs 2+ layers), so compose.stack never moves it into the column: stays absolute and cut at every width.
- (minor) Composed card whose photo fills the card width, joining a wrapping section (≤767 flex-wrap), takes height from its drawn fit-content width before stretch → content overflows (fixture 415px card vs 526px content @480). Not GRO. Needs definite width calc(100% - gutters) or nowrap.

## 2026-10-21 22:53 — fixed-tile-shrink fix pass 2
- (minor, unverified) List fixture with badge:true: column-titles row ('Head') not recognised as a list head (list part null) while records are — possible pre-existing list-recognition gap.

## 2026-10-21 23:10 — gro-composition-clipping review
- (tooling, medium) Gates are blind to laptop layout drift: corpus measures only 1024 among laptop widths (1100–1366 never), lint has no row right-edge/trailing-space check. Suggest a 1280 corpus width and a right-edge-vs-drawn-alignment probe.

## 2026-10-21 23:13 — fixed-tile-shrink delta review
- (low) In a row hugging its items, a fixed auto-layout tile whose words render wider than its drawn width (40x40 'NEW' beside 'Free estimates') is fixed at 40 on tablets/phones; word spills 4.5px (2.1 phones). Main showed it at 44.5/42.1. Known limit of fixed-tile hug-only ruling; evidence evidence/fixed-tile-shrink/delta-reviewer/probe-walk.ts hugWordy. OPEN (low): recorded as a known limit in HANDOFF/ledger/paste check; no source change.

## 2026-10-21 23:37 — gro-composition-clipping fix pass
- (minor, pre-existing on main) At 992–1439 an inferred row's whole-width nudge share beside px items and sliding gaps can overflow the row (fixture index row 1121>1072 @1200; GRO services TOC slack -38 to -143px @992; **correction (re-review R1): its 4th picture IS cut at 992–1200, see 00:15 entry below — OPEN**). Fix needs F to follow the tier's sliding gap (adapt rule beside space.ts) — sequence after responsive-pill-planning.

## 2026-10-22 00:15 — gro-composition-clipping re-review
- (minor, pre-existing on main, OPEN) GRO services TOC 4th picture xnpjno ('TOC · Create') cut by section kcabyv at laptops: 992 fully off-screen (overflow 83px), 1024 5px visible, 1100, 1200 overflow 14px. Needs F to follow the tier's sliding gap (after responsive-pill). Evidence evidence/gro-composition-clipping-rereview/ gro-measure.json, main-cuggpy-992.png.
- (minor, pre-existing) GRO header 'Let's GRO' button (wtqebd) wraps to a second line below the 80px header band over the hero art at 800/768 (main 768–900; GRO fix fixed 900). Row wrap/least area → responsive-pill-planning's area.
- (suggestion) GRO tablet nudge rows pack left (F uses drawn gap): could use the tier's stepped gap in row.nudge without touching space.ts so rows spread as drawn at 991–768.
- (tooling) Lint has no clipped-picture check: a picture cut by its section passes corpus/lint.

## 2026-10-22 00:18 — responsive-pill-planning builder
- (low) inspo arrow-row allocation unchanged on .25: pills' real container 143px at 375 vs plan 230.9 because 56px arrow images keep width in a kept row; pill labels wrap at ≤390. Row-allocation area.
- (low) emit/settings.ts len() rounds a tracked button's base right padding 27.52 → "28" on desktop while phone clamp keeps 27.52.
- (OPEN, needs Justin W-B decision) wrapped-row least sums items; widest-item least changes hydraulics Bento grid box:506:1629 2→3 cols tablet, 1→2 sideways phones; debug grids 553:7783/7606 1→2. Needs grid reading-width policy.
- (tooling) gro baseline corpus runs can silently miss Yellowtail (failed: [] with stylesheet absent) — always compare loaded-family sets.

## 2026-10-22 00:30 — gro-composition-clipping finisher (merged build 2026-10-22.1)
- Closed: G2 ('04' 991–480), G3 ('Contact' 768), G5 (selected-work card on phones), G7 (16px sideways at 320). Row 166's G2/G3 parts are fixed too; its G1 (eixorr ≥992, intentional crop) and the 992 paragraph (G4) stay open.
- Still OPEN: laptop TOC 4th picture cut at 992–1200 (pre-existing, 00:15 entry); G6 turned hero locator 480/479; header 'Let's GRO' wrap 800/768; re-review R4 suggestion (tablet rows could use the tier's stepped gap in row.nudge, a rendering change — follow-up, not in this release); lint has no clipped-picture check.

## 2026-10-22 — font-reporting-tests finisher (released 2026-10-22.2)
- **UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not available; no stand-in substituted, expected font set NOT narrowed:** final-design's expected Garamond Condensed remains absent while `failed: []`. Fresh exact-main29325e4/candidate complete reports and loaded-family sets agree at all29 widths. Justin's **M1A** waives only this release hold for this release, not font completeness or other gates. Genuine-font resolution stays open; do not silently narrow the expectation or provision a replacement. Evidence `evidence/font-reporting-tests/finisher/main-29325e4/comparison.json`; W-B remains deferred separately.
- Only the two canonical metadata/bundled-Google-test rows above close at pushed51bbd2e; unsupported descriptor policy and loader duplication stay open. Conversion/panel3bb owed; no new Bricks paste check. CLAUDE backlog preserved in `font-reporting-tests-claude-md-pending.md` after older pending builds, no write attempt/bypass.


## 2026-10-22 — card-hover-shift planner

### Builder resume findings (b330f86 / records 7e13764)
- **P3** — Direct body-reading `content(..., "fluid")` throws in `PageFacts.wordCap`; not repaired. Diagnostic: `evidence/card-hover-shift/resume-sol-b330f86/` (builder names `candidate/red-reading.tap`). Attribution requires independent review.
- **P3** — Existing hover-cover max-width cap makes copy 2px narrower at tight wrap points; unchanged. Builder's durable original/final archive: `evidence/card-hover-shift/resume-sol-b330f86/`.
- **P3, historical/unverified** — Some collapsed-picture icon recolours reportedly produce no hover copy; unchanged, diagnosis deferred. See builder resume records; not a confirmed introduced defect.

- **P3** — Unhovered service card drops its ↗ arrow onto its own line on tablets: at 990 "Remanufactured Hydraulic Cylinders" (2-line title) puts the arrow on a third line (card 155px vs 112px neighbour); most cards do it at 768/600. Base row-wrap policy, not hover; no current owner. Evidence `evidence/card-hover-shift/main.log` ("own=" rects).
- **P3 (unverified)** — Header text links' hover copies are smaller/offset: copies of `/`, `/about-page-final/`, `/contact-page-final/` are 50/58/79×21 vs own 55/63/87×18, −1 to −3px y at every width. May be the variant's designed line height; check Figma first.
- **P3** — `understand/overlay.ts:56–60`: when an instance changes a text's words, `src.sizing` takes the instance's but `ir.sizing` (read by `style/sizing.ts`) keeps the variant's. card-hover-shift's rule likely aligns it as a side effect; otherwise its own item.
- **Info** — the root debug file is from build 2026-10-20.6; Justin's screenshot shows Service 01/03/04/05 (another page), replay shows 02–05: same component, same cause.

## 2026-10-22 — hero-media-row planner
- **P2 (Medium)** — `/remanufactured-hydraulic-cylinders/` redirects to the media file `/wp-content/uploads/2026/10/remanufactured-hydraulic-cylinders.avif`, and the Services card arrow links there (replay warning). Live page is `/remanufactured-hydraulics-cylinders-final/`. Media-rename / page-link area. Evidence `evidence/hero-media-row/live.json`.
- **P3 (Medium-low)** — Site theme style sets `h1–h6 {text-transform: uppercase}` (theme-style-global.min.css) while Figma is Title Case: every live heading ≈20% wider than the plugin plans. Site state.
- **P3** — Plugin's own header (when "site already has its header" is unticked) splits at tablet into 3 rows (logo / links split left-right / phone+pill); plan row div.wrap 553:8036 is 'two' at tablet, 'stack' at landscape (evidence main-990.png).
- **P3** — `heroOf` counts only flex rows as 'beside' pairs (recognise.ts:145-155): a hero drawn as a 2-cell grid without a photo behind isn't recognised as a hero (no phone band).
- **P3** — `charWidth` 0.72 em/letter fallback for multi-line capitals (facts.ts:50-56) ≈55% too wide for condensed fonts (Saira Condensed caps ≈0.465): type.ramp shrinks such headings on phones more than needed.
- **Info** — In Figma the "Services" crumb text itself shows broken over two lines (component master 30px wide). Designer-side; hero-media-row Part 3 makes the paste draw it as a browser would.

## 2026-10-22 — hero-media-row finisher
- **P3** — Media-only FILL hero on laptops: picture is 23px wide at 992px on exact main and candidate (identical geometry, pre-existing). Evidence `evidence/hero-media-row/finisher-fix/r1-base-992.log`.
- **P3** — Long-heading fallback can overflow at 320px when hero keeping is disabled (reviewer finding, not introduced). Evidence `evidence/hero-media-row/independent-review/`.
