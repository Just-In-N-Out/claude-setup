# Found-items batches

# Round 3 — authorized 2026-10-22
Additional existing-bug planning assignments: **found-list-head** (Opus medium; corrected finding223 + test-fidelity issue), **found-text-decoding** (Sol high; LPF-UTF16), **found-list-actions** (Sol xhigh; old CSV action-word replacement, reconcile .22 first). Justin explicitly requested these additional agents. Decoder/action shared brief `briefs/found-sol-additions-planner.md`; head brief `briefs/found-list-head-planner.md`. Read-only plans first; action/head/list source overlaps sequence or consolidate before builds. Original Tiles-A now builds independently, Tiles-B owns both empty-shape203 and laptop shrink211; contrary proposed transfer-to-layout superseded. Layout owns nudge/turned label only. All original exclusions persist.
Current queue and ownership matrix: `found-batches-round3.md`. Four read-only planners: found-layout (Opus medium), found-contacts (Sol xhigh), found-tiles (Opus medium), found-gates (Sol high). Autonomous plan → build → fresh review → fixes → verified merge explicitly authorized for these four handoff groups; recommendations accepted within unchanged policies. W-B held; Garamond UNVERIFIED/no substitute/no narrowed expectations; denied CLAUDE writes not retried. Build overlaps resolved after plans; max6 builders/finishers (Justin raised the cap October22; heavy tests separately staggered). Older unrelated findings remain deferred, not closed.

# Historical Round 1 (2026-10-21 ~06:40)

Each batch = 4 agents: planner, builder, fresh reviewer, finisher. Max 2-3 builders at once.

## B1 fonts-cleanup: merged as build 2026-10-21.6; paste check 3ah owed.
- Deferred (Justin: "move on"): fonts loaded twice per page (Bricks link + paste @font-face); needs live paste proof, loader unchanged.
- Fixed: missing-face note names the paste's confirmed supplied weights or says replacement unknown, never promises a physical substitute. F1 (HTTP-200 partial Google response classification) stays open.
- Fixed: addFonts skips a static already covered by a usable same-family/slant variable range; duplicate upload removed, existing CSS already chose one shared-weight rule.
- Verified/protected (Justin 3A): fresh paste already carries Figma weights through own settings and imported typography classes. Regression unit/browser tests added; no blanket per-element duplication or core change. Existing site-owned header template still needs 600 set by hand.
- Fresh review R1 test-only correction completed red/green: normal Google stand-in models partial HTTP 200, combined HTTP-400 retries explicitly failure injection. Check 1358; browser 133/136 (3 known stale tests reproduced on main); corpus 5 pastes byte-identical, lint and same 17 worse-than-v1 identities unchanged.
- Main pushed at b24d56f. CLAUDE.md write blocked; exact pending edits: `fonts-cleanup-claude-md-pending.md`.

## B2 link-upload-fixes: merged and pushed as 2026-10-21.11, 6ba11f5; paste check 3al owed.
- Fixed R1: every upload/fallback/video route explicitly requests the safe transmitted filename stem as slug.
- Fixed R2/R3: media-safe final hrefs and exact matched-page addresses; honest drafts/missing notes; old saved pages require re-convert/re-paste, never automatic redirect promises.
- Closed R5 coverage gap: root/full-path tests and three named killed path mutants, not a claim all historic 41 were rerun.
- Fixed all R6–R8: exact-ID readback verifies moves; shared uncommon-media/opaque-ID policy; only active WordPress-picture mode may write, queue and panel continuation respect Cancel.
- Production assertPayload guards core/final output; invalid paste cannot copy. Fresh review P2 stale video finish and P3 lost second-media note verified/fixed test-first with reverted-fix mutation proof.
- Rebased onto .10 (2dd96eb), check 1472/1472; browser 146/149, exactly three independently reproduced stale upload-name expectations (test-cleanup). Corpus 5/5 pastes/HTML and full lint/fonts/heights at 29 widths equal current main; same 17 worse-than-v1 identities; frozen marquee pixels identical.
- Still open: LINK-RENAME-COLLISION, pre-existing medium, recorded separately; no scope expansion or live-site writes. CLAUDE.md first write denied; exact B2 edits in link-upload-fixes-claude-md-pending.md. Existing .9/.10 pending files untouched and not marked applied.

## B3 text-breaks: small, Sol 6.1 xhigh, Sol reviewer. Clash: frame-text-links edits text HTML, so after it merges.
- phone numbers split across lines: no-break for phone numbers
- typed line breaks on phones wrap into long+short lines (Gary Strickland review at 390)
- rag test treats a two-line address as a rag
- text.breaks reads the IR source text, not the emitted words

## B4 equal-card-fixes: in-between, Opus 5.5 medium, Opus xhigh reviewer. No shared source with cta-label-wrap: builds beside it (planner, Q1A).
- MAJOR R1 row-direction cards shift down at full width (3B bottom-padding trim)
- MAJOR R2 tablet: stretched row card turned column gives flex-grow to a fixed child (64x64 -> 64x116)
- Minor R3 hugging card with min height loses centring
- Minor R4 untested guards (24 of 48 mutations survived) + nits R6 R7

## B5 layout-floors: in-between, Opus 5.5 medium, Opus xhigh reviewer. Clash: cta-label-wrap (unpin.ts) and B4 (adapt), so after B4.
- Repairs 2-col grid titles squeeze to 31px at 480 (title floor lets go)
- size.unpin zeroes _heightMin:tablet_portrait on fixed boxes held open by content (photo card 60px at 990)
- 39/40 cliff in sideAt
- P2B leftover GRO 'Let's talk' sides at the sideways-phone width
- inspo-brainstorm Industries pills strip on phones
- layout plan counts a divided item's padding after the row breaks
- (moved from B4, Justin Q1A) equal-card R5: sidesAt adds 2x outline at 0 padding (now in adapt/least.ts after cta-label-wrap); also un-wraps the Services parts-table cell at 768; plus mutations A4/A5 from equal-card-fixes-tools

## Folded into test-cleanup: merged/pushed as build 2026-10-21.12, 9334c37; no paste check owed.
- Fixed: snap visible/wrapped section pairing/order and configured font stand-ins, with real CLI/mutation proof.
- Fixed: source-backed shared WordPress Font Library collection stand-ins; scoped injections documented, not a complete emulator.
- Fixed: timing gates isolated from parallel workers while check retains unchanged 3000ms/800ms limits. size.unpin remains B5.
- Fixed: page/section animation-score noise via finite-end/infinite-zero captures, no relaxed .005/.02 tolerances; legacy motion non-comparable.
- Fresh review passed with no introduced findings. Rebased onto .11 preserving B2 tests: 1479 unit/rule + 6 performance, browser 154/154, no skips. Five pastes/full HTML byte-identical, complete findings/heights/fonts at 29 widths equal; matched-policy complete reports exactly equal, same 17 known v1 differences.
- Three stale browser expectations fixed, list/marquee/map guards mutation-proven, picture/shape extraction preserves live wide access, three empty root files removed. Nine exact found-else rows/sentence closed; F7/F9/fontStatus remain open.
- CLAUDE.md first write denied; no retry/bypass. Exact .12 edits in test-cleanup-claude-md-pending.md; .9/.10/.11 pending files remain separate and unapplied.

## Not code
- Theme Style sets all body text to Saira 800: Justin's Bricks setting

## Already covered by cta-label-wrap (running)
- Info card 'Call Us Now' label wraps; pill buttons wrap at laptop widths (W2A)

## Order
Now: frame-text-links (Opus xhigh) + cta-label-wrap (Opus medium) building. B1 can build beside them.
After frame-text-links: B2 + B3 side by side.
After cta-label-wrap: B4, then B5.
test-cleanup: after frame-text-links + cta-label-wrap merge.

## Justin's answers (2026-10-21 ~06:45) = go
- 1A: the 4 test/tool items go into test-cleanup.
- 2A: start all 5 planners now; builds follow the order above.
- 3A, with his note: "it depends on Figma what the font is". My reading: every text's weight should come from Figma, so no text silently inherits the Theme Style's Saira 800. Added to B1 as an item: the paste writes an explicit font-weight on every text (and the header button gets 600 from Figma), so the site setting stops mattering. Flagged to Justin as my reading.

# Round 2 (2026-10-21 ~08:20, Justin: "Let's start agents for those 17 fixes")
New found-else items from this session's agents, placed by area so no two builders share files.

## B6 pill-clip: in-between, Opus 5.5 medium, Opus xhigh reviewer. Builds after cta-label-wrap merges (adapt/least.ts, label.ts, unpin.ts).
- Medium (also on main): design file at 1024, ~10 pill labels cut off (Invisalign, Retainers, Fluoride, Nightguards, Bridges…): pills clip their content (overflow hidden), so wrapped words are cut instead of growing the pill. corpus/report-v2.json design widths.1024.
- Low: GRO 'Let's talk →' pill is 163x76 at 768 (drawn 60), pill with arrow wrapping (likely cta-label-wrap's territory: check on its merged code first).

## B7 text-link-followups: small, Sol 6.1 high, Sol reviewer. Builds after text-breaks AND link-upload-fixes merge.
- Medium: phone numbers crossing styled runs get no automatic dial link; normalise/contact-links.ts:175 requires a match wholly within one run.
- Low: long two-line opening hours also get the break-hiding rule; adapt-breaks.test.ts:81–90 expects it.
- Low: linkNotes names only the first words for an address several links share (ui/site-pages.ts linkNotes, one per address). Also true for element links.
- Low: marquee loop copies give tabindex=-1 only to elements that are links; a link inside a text's HTML in a loop copy is still Tab-reachable (emit/elements.ts marqueeAttributes).

## B8 google-partial-fonts: merged as build 2026-10-21.9; conversion/panel check 3aj, paste check: none owed.
- ~~Low-medium: src/ui/fonts.ts:44–45 treats any nonempty HTTP-200 family response as complete; a real IBM Plex Mono 400+800 request returns only 400, yet loadGoogleFonts reports missing:[] (fonts-cleanup reviewer confirmed: both rows said Google).~~ ✅ fixed in build 2026-10-21.9 (google-partial-fonts)
- Main pushed at 1b21e19. Fresh review passed; check 1430/1430, browser 137/140 (three known stale tests); fresh main/branch corpus pastes, HTML and complete per-width lint/heights/fonts identical; same 17 worse-than-v1 identities.
- CLAUDE.md guard denied the first patch; no edits landed. Exact pending edits: `google-partial-fonts-claude-md-pending.md`. Duplicate loading, old header template and the two pre-existing reviewer follow-ups stay separate.

## Added to layout-floors (B5, queued; addendum in its plan)
- the 39/40 jump on top/bottom padding too (space.ts:47-54)
- stacked row-card section 59–185px off its Figma height at 990/768/600 (fixture rowCentred): investigate, fix if in the same code
- split src/core/adapt/layout.ts (283 lines) before adding to it
- inspo Selected-work sideways strip at 390 (container gaikeu at x -828, no gutter): fix if small and general, else leave listed
- (already there) Services parts-table cell at 768 via R5; twoShare flex-grow; reflow flex-grow

## Added to test-cleanup (closed in build 2026-10-21.12; approved addenda)
- Fixed: corpus section-score capture noise; matched-policy comparison and honest original-score non-comparability, thresholds unchanged.
- Fixed: snap hydraulics section pictures; 13 section pairs produced and CLI tests/mutations verified.

## font-reporting-tests — released 2026-10-22.2, pushed 51bbd2e; conversion/panel 3bb owed
- Closed only the two canonical google-font-range-policy follow-ups (metadata first/commented/repeated weight; no bundled Google coverage). Unsupported keyword/reversed ranges, duplicate loading, physical font and installed-Bricks behavior stay separate.
- Fresh independent Sol high review approved; low EOF nit fixed. Rebased onto29325e4; check2010+6/browser225/focused261/panel18 pass, no failures/skips. Five same-base pastes/full HTML and complete29-width reports equal; same17 existing v1 differences; debug bytes equal.
- M1A: Garamond Condensed **UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not available; no stand-in substituted, expected font set NOT narrowed**. Only that release hold waived; all other gates completed. W-B stays deferred.
- Completed-exit0 merge lock, ff-only merge, BUILD/build, personal commit, main push verified at51bbd2e against origin and remote; both dist bundles match exact in-memory rebuilds. Evidence `evidence/font-reporting-tests/finisher/`; original173 builder targets and1497 reviewer artifacts verified. Main CLAUDE updates queued after older pending files in `font-reporting-tests-claude-md-pending.md`, no protected-write attempt/bypass.
