# Round 3 — four authorized found-item batches, 2026-10-22

Canonical ledger: found-else.md. Line references below refer to its 252-line dispatch snapshot; use exact text/dated headings if lines move. The four groups in handoff-main-chat.md are the authorized implementation scope. Older unrelated open findings are deferred, NOT silently closed. No live/queued code owners existed at reconciliation; main/origin b4ed333, only main worktree. User debug JSON is modified: preserve it.

## Authorization and boundaries
Justin: "Then batch the open bugs in found-else.md (the 4 groups in the handoff), start a planner for each, and run them autonomously: plan → build → fresh review → fixes → verified merge. Take the recommended answers yourself. Keep W-B held for me, keep Garamond marked unverified (no stand-in fonts), and don't retry the refused CLAUDE.md writes."
Grant ends on completion of these named batches or cancellation. Safe recommendations are auto-approved, not new capabilities, reversed decisions, substitute fonts or approval bypass. Keep existing policy unless a separate explicit decision permits change. Garamond is UNVERIFIED; historical M1A was release-specific, not a blanket gate waiver. No CLAUDE.md write attempts: pending edits only. Max 3 builders/finishers. Each pipeline has a fresh separate reviewer; Agent Defect Loop adds fresh verification before merge. Rendering fixes after review need fresh re-review.

## Ownership matrix (provisional files; planners must verify)

### found-layout — in-between; Opus 5.5 medium planner/builder/finisher, Opus xhigh review/verifier
1. GRO header Let's GRO wraps over hero at 800/768 — lines 236,248.
2. Inferred-row laptop nudge with sliding gaps; TOC fourth picture cut at 992–1200 — 232,235,248 (one symptom/root-cause cluster, not three fixes).
3. G6 turned Vertical locator clips at 480/479 — 179,248.
4. Inspo sideways scroll / Selected-work strip / Industries pills / arrow-content allocation — 64,82,152,158,184,213,241. Diagnose duplicates and intentional scroll boundaries; do not redesign intentional compositions.
5. Fixed tiles shrink on laptops 992–1199 — 211 (tablet/phone fixed already).
6. Tablet inferred-row stepped-gap nudge suggestion R4 — 237,248. Investigate as bounded correction preserving policy; explicitly defer if this reverses a prior decision.
Likely source: adapt/rules/place.ts, space.ts (read-only unless justified), rows.ts, sizing/unpin/icon helpers, adapt/layout planning. Tests: inferred rows, fixed tiles, real-page geometry. Clashes: found-tiles in shared sizing/rows/layout tests; found-gates in browser/render/lint helpers. Planner reports exact files, all callers, emitted-output scope and sequence. Build waits on confirmed non-overlap/ownership; default layout before tiles on shared files.

### found-contacts — small diagnostic bug batch; Sol 6.1 xhigh throughout
1. addressIn keeps same-line bullet Order ID after address — 193.
2. Updated +2026-10-21 10:30 becomes a dial link and leaves Updated :30 in address — 198.
3. Double-spaced View ID label guesses page address — 199.
4. ID before street and separate ID line leave marker in address — 200.
5. page-links allowed() raw-vs-collapsed rejected-data veto inconsistency — 208. Preserve established P1A–P3A no-ID/date-navigation policy. If correction requires a different navigation policy, return held alternatives rather than silently choosing.
Likely source: normalise/contacts.ts, rejected-data helpers, contact-links.ts, card-title.ts, page-links.ts; unit and integration consumer tests. Usually independent of layout/gates. Verify plan size; shared multi-stage policy change must resize to Opus rather than force Sol.

### found-tiles — in-between shared layout-rule batch; Opus 5.5 medium planner/builder/finisher, Opus xhigh review/verifier
1. Single framed past-edge card not grouped (requires 2+ layers) — 219.
2. Wide-photo composed card overflows joining wrapping section <=767 — 220.
3. Icon-row fixed auto-layout tile collapses to label width — 216.
4. Hugging row fixed tile words spill past drawn width — 229.
5. Repairs breadcrumb 1px spill at 320 — 204.
6. Empty fixed drawn box width under-counted in plan — 203.
7. Tracked base padding 27.52 rounds to 28 while phone retains fractional — 242; investigate fractional-floor allegations 156,168, never blanket ceil without RED proof.
8. List with badge:true column-titles Head unrecognized — 223.
9. Related unpin hugging-button-floor allegation — 212; diagnose and close only if proven fixed, otherwise keep unverified.
Likely source: normalise/past-edge.ts, list recognition, adapt least/layout, icons.ts/unpin.ts/compose rule, emit/settings.ts. Tests: past-edge, fixed-tiles, lists, emit/browser geometry. Clashes with found-layout in shared adapt helpers and tests. Plan read-only now; builds sequence by actual diffs. No W-B/widest-item change or ALONE reversal.

### found-gates — small tooling batch; Sol 6.1 high throughout unless plan demonstrates larger scope
1. Laptop coverage 1100–1366 absent (only1024) — 226; earlier narrow-phone coverage remainder 157 is contextual, preserve all current widths.
2. Missing row-right-edge and clipped-picture checks — 226,238,248. Detect real controlled defects without labelling intentional off-edge art as a failure.
3. Always compare expected/loaded family sets, including Yellowtail absent with failed:[] — 244; network-run limitations170 contextual. Inspect renderer-proof-hardening .3 first: completeness already fixed in127; do NOT duplicate, regress, or claim every historical font/network gap remains open. Only add demonstrably missing callers/controls.
Likely files: tools/corpus*, test/browser/render/capture/lint helpers and tests. No production converter changes. Broad tool changes may require Opus resizing. Build can run independently only with explicit test-helper ownership; capture resources staggered.

## Holds and disposition of the rest
- W-B: wrapped-parent least/grid reading width — 150,165,185,243. Held for Justin, no model/agent assigned to implementation.
- Garamond Condensed physical font — 251. UNVERIFIED, no stand-in or narrowed expected set. No physical-font fix assigned.
- Intentional GRO desktop cropping/G4 laptop paragraph policy — 110,166,181,247: non-bug/prior-policy disposition; do not widen layout scope.
- ALONE row-card policy — 93,151: decision-dependent, not authorized to reverse.
- Historical peer-padding rows161/167: inspect .5 responsive-pill-planning before any closure; covered portions already owned/released there, unfixed remainder remains deferred unless precisely within this round's listed geometry.
- Theme Style/site class replacement and installed-Bricks/paste checks: non-code/user verification, not proof of live success.
- All other older open findings (UTF16 input decode, duplicate Google loading, docs/refactor gaps, list-panel minors/action-button data binding, image fringe, missing source exports, browser flakes, form/header above-design wrap, per-element CSS consolidation, external link sample) remain DEFERRED outside these four handoff groups. Planners may flag relevant dependencies but cannot silently absorb or close them.

## Build and release order
All four planners research read-only now. Contacts is provisionally independent. Layout and tiles must resolve shared helpers/test ownership before either concurrent build. Gates must not mutate another branch's harness and must coordinate capture capacity. Maximum six builders/finishers (Justin raised the cap October22); heavy capture admission remains separate. fewer expensive captures simultaneously given only ~8GiB free at dispatch. Recheck disk before cloning/archiving; no speculative cleanup or destructive deletion. Every finding gets exact text in its plan/brief and finisher closes only verified merged items in canonical ledger. Pending CLAUDE edits stay pending. Read actual diffs before each build; merge lock and rebased same-base evidence mandatory.
