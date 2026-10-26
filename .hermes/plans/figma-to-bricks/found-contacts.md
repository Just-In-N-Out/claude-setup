# found-contacts — Round 3 implementation plan

## Questions and recommended answers (first)

The October 22, 2026 named-batch grant authorizes the dispatcher to record safe recommendations and advance this batch without asking again. It ends when the four named batches complete or Justin cancels. This document is **planning only**: no builder, worktree, source/test edit or release was performed.

1. **C1 — Should extra horizontal spaces bypass P3A?**
   - **A ⭐ No; apply the existing data veto consistently.**
   - B Keep the raw-only card/label exception.
   - C Hold this portion for a new policy decision.
   - Plan against **A**. It intentionally replaces the historical raw-only preservation assertion in `phone-guards-title.test.ts:53–58`, not the P3A decision itself. The current Round 3 brief explicitly assigns this inconsistency; the original approved P3A says rejected ID/date data cannot name a page or sit inside an inferred target. Do not expand the veto to unrelated ancestor/sibling content or arbitrary identifiers. If the dispatcher interprets that historical exception as a separate binding product decision, **hold C1, do not silently change it, and resize that decision work to Opus**.
2. **C2 — How narrowly should the timestamp phone fix work?**
   - **A ⭐ Valid plus-date + separated valid HH:MM only.**
   - B Reject every number starting with a date.
   - C Add ISO/T/timezone/free-form timestamp parsing.
   - Plan against **A**, including optional `:SS` with valid clock fields as the same complete clock token. Reuse P2A's calendar validity and exact same-separator date grammar; horizontal whitespace separates date and clock. This is an explicit lexical-boundary repair for the assigned timestamp, not approval to blacklist date-like prefixes, malformed dates, other date formats or international numbers. B/C are **held new-policy/capability alternatives**, not autonomous recommendations. Preserve old outcomes for longer date-shaped phones, invalid dates, mixed separators, spaces between date fields, and `ID` on another logical line.
3. **C3 — What should address cleanup remove?**
   - **A ⭐ Only bounded metadata fields beside removed values.**
   - B Guess the address from arbitrary surrounding prose.
   - C Remove every occurrence of ID/Updated words.
   - Plan against **A**: remove a separator-bounded ID/date/contact field and a standalone `ID[:#]?` line immediately attached to an otherwise removed contact/value-only line. Keep actual street/house/postcode/unit content. Do not add identifier vocabulary, NLP, cross-text phone-label association or arbitrary prefix stripping. B/C remain held.

No routine user answer is needed for these A recommendations under this grant. **Release is still conditional on all required gates**; the historical M1A Garamond waiver is not authority for this release.

## Dispatcher approval — 2026-10-22
Approved under Justin's Round 3 autonomous grant: C1A/C2A/C3A. These apply established P1A–P3A consistently, not new navigation/contact policy. Parent inspected phone-guards-title.test.ts:30–61: authorize replacing ONLY old raw-only link/pageLinks expectations at53–58 with no encompassing link/no pageLinks, preserving title assertion52, payload validity59, raw recognizer controls33–37, and adding stronger new positive/negative integration controls. Exact four normalise production files approved. No other old expectations may be weakened. Build may proceed independently of gates within separate files; heavy capture slot initially belongs to gates, so begin lightweight tests and coordinate before corpus/browser gates. Garamond UNVERIFIED release hold, no merge/push/BUILD/cleanup while unresolved. No CLAUDE writes.

## Source review correction authorization — October22
Fresh reviewer oncd1ef6d found F1(P2 preexisting assignedC3): spaced single hash marker `Order ID #` left in decodedmapquery; F2(P2introduced): dateclock rejection interval overlaps accepted numericemail in `😀 Updated +2026-10-21 10:30@workshop.org`. Authorize scoped test-first correction within existing address.ts/contacts.ts and feature-ownedtests, preserve P1A/rawPHONE/email and unsupportedtokenlegacy; no newpolicies. Finisher must stop ready-for-review, NO merge/push/BUILD/cleanup. NEWfreshsemanticrereview required after fix, then missingheavyacceptance. Originalreview evidence retained evidence/found-contacts/reviewer-source-cd1ef6d/. Garamond/W-B/CLAUDEholds persist.

## Playback / finite goal

1. A date and time must not become a telephone number or supply a Call button.
2. IDs and update metadata beside a real address must not get into its map query; the address text itself stays as drawn.
3. Extra horizontal spaces must not turn rejected ID data into a guessed page label or whole-card link.
4. Preserve P1A–P3A, genuine phone/email behavior, exact UTF-16 link ranges, styled-run/designer-link protection, and all unrelated page/card/layout decisions.

## Current context, authority and measured planning work

- Repository: `/Users/justin/Documents/FigmaToBricksV2`; observed `main` and `origin/main` at **`b4ed333631dba923b73e1731ad420a4f92d880f1`**, BUILD **`2026-10-22.5`**. Only main worktree existed at the initial inspection. Root `figma-to-bricks-debug-page-1.json` is the only modified tracked file; preserve it.
- Local tool-observed start: **2026-10-22 06:56:40 EDT**. Planning forecast: roughly **15–25 minutes**, medium confidence, done = current-source reproduction, full shared-consumer trace and saved checked plan; no install/Chrome/network wait assumed. The initial 2–5 minute discovery slice established all assigned failures and source identity; the remaining work is plan/acceptance definition, not implementation. This is a local forecast, not measured historical throughput. Exact end/elapsed are recorded in the scoped `validation.json` evidence.
- At start disk had **8.0 GiB available**. No clones, corpus runs, browser captures, dependency installation or repository artifacts were created. Use bounded probes; stagger later Chrome/performance/corpus gates with sibling batches.
- `CLAUDE.md` Start here still says `.12`; this is stale pending-documentation state, not the actual source/build. Read its Start here, contact/page/maps, general logic, architecture/debugging and relevant Decisions; also current HANDOFF, the historical phone plan/ledger and pending CLAUDE file. No protected write was attempted.
- Debug read-only audit: build `2026-10-20.6`, root **Hydraulic Cylinder Repairs Final**. The nested text/segments scan found none of the assigned ID/update label strings; it does contain a genuine phone sibling, node `553:7955`. Therefore the assigned defects are proved with generic fixtures, not claimed reproduced in Justin's file. Preserve and replay a scratch copy of this modified debug during the build's baseline/final gates.
- Existing policy: P1A recognizes a standalone immediately preceding same-line case-insensitive ID, one optional `:`/`#`, horizontal whitespace only. A separate-line `ID` does **not** change dialability. P2A rejects a complete calendar-valid plus date of the approved dot/hyphen shape, not invalid/mixed/longer forms. P3A forbids inferred names/labels/encompassing targets from rejected data, while designer links remain authoritative. No W-B/grid/ALONE or navigation-scope redesign.

## Skills

Loaded for this planner: `figma-to-bricks` (+ rules-summary), `engineering-best-practices`, `implementation-planning` (+ plan-validation), `systematic-debugging`, `qa-testing-local-cloud` (+ detailed QA reference), `test-driven-development`, `mutation-testing-discipline`, and `feature-dispatch`.

Builder: project + engineering, TDD, systematic-debugging, mutation-testing-discipline, qa-testing-local-cloud. Reviewer: project + engineering, requesting-code-review, code-review-practice, mutation-testing-discipline and this recognition/QA contract; report only. Finisher: project + engineering, receiving-code-review, git-commit-rules and TDD. Children cannot spawn; dispatcher supplies fresh independent roles.

**Agent Defect Loop:** no loaded implementation/testing specialist contains an operative “Mandatory Validation and Agent Defect Loop” section in the inspected installed versions; `feature-dispatch` describes the routing rule rather than creating its own feature-specific loop. Planner `defect_loop_skills = []`. Every later role must return any additional loop skill it actually loads. If one applies, finisher stops at `ready-for-verify` (no merge/BUILD), then a fresh verifier on the reviewer's model re-runs required gates before the finisher is resumed. Separate fresh review is mandatory even if this array stays empty; do not call this planner or the builder the reviewer.

## Size / model / implementation boundary

**Small bounded recognizer/cleanup batch; Sol 6.1 xhigh for builder, separate fresh reviewer, finisher and any verifier.** Four short production files in **normalise only**; style/maps are read-only consumers. Existing title exclusion is already correct. This does not require a cross-stage source/policy rewrite. Keep this routing only while C1–C3 remain within the named grant and no source beyond the allowlist is required. New identifier/date vocabulary, altered card traversal/provenance/selection policy, an IR/emit/style rewrite or a genuine policy reversal is a stop/resize to Opus 5.5 medium with Opus xhigh review, **not** “force Sol” or an implicit scope extension.

## Exact assigned findings, dispositions and root causes

Canonical file: `/Users/justin/.hermes/plans/figma-to-bricks/found-else.md`; the following line numbers are its 252-line dispatch snapshot, not stable identifiers. **All five rows remain open until verified merge; this plan closes none.**

| Row / exact finding | Disposition and current observation | Root cause / owned seam |
|---|---|---|
| 193 — `addressIn` keeps `• Order ID 0812 473 1900` after an address on the SAME line | Confirmed, pre-existing; actual query ends `IN 47725 • Order ID` (digits were removed, not the metadata caption). One address-cleanup cluster with row200, not another phone-policy fix. | `address.ts:24–32` removes only numeric ranges; its residue-drop rule applies to the whole line. The remaining address digits prevent dropping `Order ID`, and EDGES only removes punctuation at the line ends. |
| 198 — `Updated +2026-10-21 10:30` becomes a dial link and leaves `Updated :30` in an address | Confirmed, pre-existing. PHONE returns substring `+2026-10-21 10` at UTF-16 `[8,22)`; `phoneRanges` even includes the colon through23. A Call button wrongly chooses that false number both with no real phone and with a real phone later. Real map query ends `, Updated :30`. | `contacts.ts:11–13,45–53`: greedy PLUS consumes the hour and stops before `:`; `plusDate` at29–35 checks only the entire matched candidate. The candidate is no longer a whole date, so rejection is bypassed. Address residue is downstream, not an emitter invention. |
| 199 — double-spaced `View ID  0812  473  1900 →` guesses `/id-0812-473-1900/` | Confirmed, pre-existing, including a real conversion with a separate section heading/body (not merely a helper return). | `page-words.ts:33` checks only raw rejected ranges; `:34` then collapses spaces and GO extraction names the ID. ZERO/NANP grouping does not admit those raw multi-space groups. |
| 200 — leading `Order ID ...` before street, and separate `ID` line leave markers in address | Confirmed: `Order ID , 12 Market Street, Springfield IL 62704`; and `12 Market Street, Springfield IL 62704, ID`. Both propagate unchanged to an actual emitted map q. | Same numeric-only removal as193. Separate ID line has no found range of its own, so `found.length` condition never drops it. **Do not fix by carrying ID across lines in phone recognition:** current separate-line number remains a genuine phone under P1A. |
| 208 — `page-links.allowed()` raw-vs-collapsed veto inconsistency | Confirmed, pre-existing/currently pinned by a historical test: with a real title, single-spaced ID card is plain, multi-spaced ID card links `/available-parts/`. Equal-sized multi-space ID is already excluded as title, so title ranking is NOT still broken. | `page-links.ts:267–272` checks raw rejected data only, while `card-title.ts:33–38` checks raw and collapsed readings. Apply C1A only to the existing inferred target traversal. |

Companion generic variations already observed: multi-spaced ID address fields also leak their **numeric** value into queries because cleanup scans raw first, only collapses afterward. This is part of the same assigned whitespace/address class, not a new vocabulary or additional ledger closure. No unrelated defect is absorbed.

### Tight reproduction and retained evidence

Evidence root: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/found-contacts/planner-main-b4ed333/`.

- `probe.mjs`: read-only imports of current main, existing generic fixture builders; writes scoped JSON only.
- `probe-v2.log`, `observations-v2.json`: canonical observations with corrected nested debug-text audit.
- `probe.log`, `observations.json`: original diagnostic capture retained; its debug scanner looked only at a shallow characters field. The corrected audit confirmed the same absence using actual `text.segments`; do not cite the shallow field as that proof.
- `validation.json`: source/debug preservation, case/control counts, source/evidence hashes and plan-snippet static-validation receipt. No GREEN implementation claim.

Run from the exact repo workdir:

```bash
node /Users/justin/.hermes/plans/figma-to-bricks/evidence/found-contacts/planner-main-b4ed333/probe.mjs --assert-fixed
```

Observed **exit1**, seven intended assertion failures: bullet suffix, timestamp dial candidate, multi-space label, leading ID address, separate ID address, timestamp address, multi-space encompassing card. These are symptom failures, not import/setup errors. The probe deliberately asserts the desired corrected outcome; it is not a failing committed application test suite. For post-build comparison use the branch's imports or new branch tests, not this main-bound observer as though it tested the candidate. Avoid overwriting retained planning observations during implementation; use a new evidence directory/version.

Working controls in the actual same-main conversions: eligible no-caption card links normally; intended title remains `Available parts` at equal-ID prominence; sole spaced ID headline cannot title/link a card; independent `View services` control links only itself; designer-linked pill remains `/pricing/` with plain card; normal phone/address/unit/international-street cases remain recognized; payload validation and repeat conversion are clean. This rules out “disable card inference” and “fix title ties again” as valid approaches.

## Shared consumers — complete production trace

Source search for imports/calls found these direct readers; changes are not allowed just because a reader is listed.

| Consumer / source lines | Meaning and proof required |
|---|---|
| `normalise/normalise.ts:261–266` | `linkLabels → linkContacts → linkPages → findMaps`. Removing a false contact can enable later navigation, hence protect P3 consumers before shipping the timestamp change. Do not reorder passes. |
| `contact-links.ts:50–66` shownOn | Only accepted contacts supply phone inventory/Call sources; removal changes false-source selection. Test no-real-phone warning and later real phone selection. |
| `contact-links.ts:69–74` nearCaption | Negative recognition also makes text eligible as caption words. Preserve current accepted-contacts-based ranking, including historical by-name tie limits; do not redesign it in this batch. Record/compare own/nearest/by-name/main/hidden positive controls. |
| `contact-links.ts:95–119` buttonContact | Own number, closest pool, named/main fallback. Test false timestamp alone and mixed with genuine styled number. |
| `contact-links.ts:165–194` linkRuns | UTF-16 intervals intersect styled telephone runs; any designer-linked slice protects full candidate. Timestamp removals must leave characters/styles/designer links and unrelated anchor indices intact. Email containment policy unchanged. |
| `card-title.ts:32–38` nameLike | Already checks accepted/rejected raw **and collapsed** text; leave source unchanged. Regression-check small/equal/sole headlines, real intended title and no-caption control. Do not create a fallback title from words left after stripping data. |
| `page-words.ts:32–47` labelWords; `:52–55` goPhrase | Add only shared raw/horizontal-collapsed data veto before destination/GO extraction. This also feeds page-links naming/trigger selection (`page-links.ts:73–76,93–106,189–202`). No GO/ACTION/slug/pageAddress change. |
| `page-links.ts:267–272` allowed | Same predicate inside existing `every(target)` traversal; no broader ancestor/sibling scan, hidden/absolute traversal redesign, `free()`/`linked()` changes, fake links or global disable. Independent target outside data stays eligible. |
| `address.ts:24–32,61–67` | Remove actual contact/rejected metadata ranges/fields without removing house/unit/postcode digits. This is derived map/address interpretation only; it must not rewrite visible source words. |
| `maps.ts:99–119` | Reads address for place card, single-text nearby address, and two adjacent text lines. Exercise real `convert(mapPage(mapCard(...)))`, decoded emitted q and metadata-only/no-address fallback; keep explicit Maps URL priority, section bounds and place-card priority. No source edit. |
| `style/phone-numbers.ts:9–27` | Accepted ranges feed phone wrappers, closing punctuation and grouped anchors. Called by `style/typography.ts:87` and `style/style.ts:185`; no style source edits. Timestamp should lose false wrapper; genuine styled/protected phones retain behavior. |
| `style/rag.ts:25–27,31–32,71–74` | `addressIn` guards soft/rag breaks, then `style/style.ts:195` and `adapt/rules/breaks.ts:15` consume those guards. Include address-with-metadata and ordinary prose controls; no adapt/style fix is authorized. |

## Proposed minimal implementation

### 1. Keep exact raw contact and rejected-range APIs

`contactsIn(raw): Found[]` and `rejectedIn(raw): Rejected[]` retain UTF-16 offsets into the **raw input**, no dummy href, mode switch or SceneNode metadata. Do **not** globally widen PHONE to multiple spaces merely to fix label/card inference; that would add new dial links and invalidate existing recognition controls.

For the timestamp, recognize a complete `+YYYY.MM.DD`/`+YYYY-MM-DD` token followed by horizontal whitespace and a valid complete `HH:MM` (optional `:SS`). Reuse `plusDate` for the date and validate clock fields; do not use the current year or JS date parsing/timezones. At the existing scan seam, associate an otherwise admissible PHONE candidate inside that token with the **whole timestamp range** and reject it once, reason `date` (same-line ID precedence remains `id` when applicable). Continue scanning subsequent genuine contacts/emails normally. Full timestamp range is important: rejecting only date+hour leaves `:30` and can regress map queries. Do not let an unmatched date-shaped prefix suppress a longer/invalid/mixed phone. `+2026.10.2123`, `+2026-10-2110`, invalid calendar dates and unrelated +country phones keep their old behavior. Reject duplicate/overlapping projected ranges deterministically; keep ordering and `Found`/`Rejected` object keys unchanged.

Only collect this timestamp rejection where the original scanner has an otherwise admissible phone-shaped candidate; this is not approval for generic ISO/T/timezone detection. A T-delimited timestamp currently has no phone candidate; leave that unapproved shape unchanged rather than expanding P3 by accident. Do not match the separator across CR/LF/U+2028/U+2029.

### 2. One inference-only predicate, not duplicate grammar

Add exported `hasRejectedData(words: string): boolean` in `contacts.ts`, returning whether rejection exists in the raw reading or in a reading that collapses **horizontal** whitespace only (`/[\t\p{Zs}]+/gu` → one space). This helper returns no transformed offsets. Use it in `page-words.labelWords` and `page-links.allowed`. Logical line breaks stay logical line breaks; do not flatten text layers or carry ID semantics across them. Existing `card-title` already supplies both raw and its historical fully-collapsed reading; leave its source/legacy contact exclusion intact, and test consistency through real consumers.

### 3. Address-only field cleanup, preserving content and phone policy

Inside `address.ts`:

1. Retain logical lines until metadata cleanup is complete. Collapse horizontal whitespace **before** local contact/rejected scans; this is safe because the returned address is already whitespace-tidied and these local offsets never escape into styled text.
2. Treat comma and existing visual delimiters (`•`, `·`, `|`, `;`) as **field boundaries for removal**, not as a new address grammar. Use actual ranges to establish which field contains removed contact/rejected data. Drop a field left with only its non-address metadata label (`Order ID`, `Updated`, existing Call/Tel residues); retain fields with real surviving address digits/content. Preserve original punctuation/formatting of untouched text; avoid blanket splitting/rejoining that changes clean queries. Retain existing edge/doubled-comma cleanup.
3. Drop standalone `ID` with optional single `:`/`#` only when the next logical line is an otherwise removed contact/value-only line. This is address interpretation only: `contactsIn('ID\n0812 473 1900')` **must still return the real phone**, with its original range/href. Do not mutate the raw text or introduce cross-node label matching.
4. Clean leading/trailing orphan metadata delimiters and remove the full timestamp clock, then feed the existing house/street/postcode/length/count/time guards unchanged. Metadata alone must remain null; a clean supported address and suite/unit must be byte-identical to baseline. If ambiguity requires inferring an arbitrary prefix or changing house/postcode rules, stop rather than guess.

No navigation destination rewriting after emission, no new Bricks keys/classes, no panel/site writes.

## Touches — exact allowlist / existing old expectations

### Production may edit

- `src/core/normalise/contacts.ts` — timestamp boundary classification and inference-only horizontal reading helper.
- `src/core/normalise/page-words.ts` — helper import + label veto only.
- `src/core/normalise/page-links.ts` — helper import + existing target veto only.
- `src/core/normalise/address.ts` — bounded metadata field cleanup only.

### Tests may edit/create

- **New** `test/unit/found-contacts.test.ts` — pure timestamp/label/address cases; Appendix A is complete starter code.
- **New** `test/unit/convert-found-contacts.test.ts` — generic downstream fixtures, Appendix B.
- **Existing** `test/unit/phone-guards-title.test.ts` — **only** the comment/ID-dependent card/link-list expectation at lines53–58 changes under C1A. Replace conditional `/available-parts/` expectation with no encompassing card link/no pageLinks; retain title assertion at52 and all unrelated tests/assertions. Add stronger single/multi-space, small/equal/sole, no-caption and independent-label controls in the new integration test. The test at33–37 still pins raw multi-space recognition absent and collapsed rejection present; **preserve it** because raw PHONE grammar is not widened.
- New `test/browser/found-contacts.test.ts` only if generic saved-HTML/anchor/geometry proof cannot be expressed by reusing existing harness as an uncommitted evidence probe; additions only, no helper changes. Coordinate this owned filename with gates before use.

### Read-only regressions / helpers

`card-title.ts`, `contact-links.ts`, `maps.ts`, normalise.ts, all style/adapt/emit/UI/source files outside the four above; all fixture helpers (`builders.ts`, `page-links.ts`, `maps.ts`, `text-breaks.ts`, `card-link-words.ts`); browser render/capture/lint helpers belong to found-gates. Existing suites to retain and run: `phone-candidate-policy.test.ts`, `phone-recognition-guards.test.ts`, `phone-guards-address.test.ts`, `normalise-contacts.test.ts`, `normalise-contact-runs.test.ts`, `normalise-page-words.test.ts`, `convert-contacts.test.ts`, `normalise-maps.test.ts`, `convert-maps.test.ts`, `style-text-breaks.test.ts`, `convert-page-links.test.ts`, `convert-card-link-words.test.ts`, `convert-text-links.test.ts`; browser text-breaks/text-link-followups/card-link-words suites as part of the complete browser gate.

Particularly binding old controls: `phone-recognition-guards.test.ts:94–100` separate-line ID numbers stay dialable; `:121–130` invalid/mixed/longer plus numbers stay phones; `:242–283` styled runs/designer links; `phone-candidate-policy.test.ts:9–16,27–37` exact raw ranges, reason/no-href shape, independent calls. **Do not edit those policies to make a green timestamp or multi-space test.** A contradictory unlisted assertion/source requirement is a scoped stop with evidence and dispatcher recommendation.

## Overlaps, ownership and safest order

- Contacts has no provisional production overlap with found-layout (adapt/rules/placement), found-tiles (past-edge/least/icons/unpin/list/emit) or found-gates (tool/browser/corpus helpers). Existing source searches support independent building. Recheck **actual** plans and branch diffs before dispatch; a later common helper/test overrides this provisional independence.
- **Do not edit a gates-owned harness.** Use existing fixtures/helper imports read-only and feature-owned test filenames. If found-gates needs a harness change, agree ownership, sequence/rebase onto it, then regenerate proof rather than borrowing a mutated shared file.
- Contacts may build alongside layout/tiles subject to at most three builders/finishers total. Laptop layout-before-tiles ordering is theirs; contacts does not impose a false dependency. All share HANDOFF/build release state and host capture resources, so serialize merge operations and stagger Chrome/corpus/performance captures.
- Internally, establish P3 consumer regressions, then make label/target consistency safe before completing the timestamp contact removal; address cleanup follows the full timestamp range. No intermediate commit is a release. Existing title source is already fixed; do not claim row208 is solved by revisiting title ranking.
- Proposed ownership changes for dispatcher: confirm the four normalise files and two new unit files; grant the exact old-behavior assertion update in `phone-guards-title.test.ts`; reserve optional feature-owned browser filename only. No reassignment of sibling findings, no shared ledger edits by this planner.

## Ordered implementation microtasks (builder, after dispatch)

These are tracer bullets, not a demand to write all tests and then all source. Copy only each task's named test/helpers from the appendices, run intended RED first, implement minimal fix, run unchanged GREEN and relevant controls, and commit the scoped passing task. Typical focused editing/review slice 2–5 minutes; gates and independent roles are additional waits. Forecast builder roughly 35–65 minutes plus corpus/browser/review/resource waits; verify against real time rather than treating this as a guarantee.

1. **Freeze base, authority, resources (2–5min).** Read this plan, current main/build/status/worktrees/diffs, relevant policy and `.worktreeinclude`. Dispatcher records C1A/C2A/C3A and exact ownership. Create only authorized `worktree-found-contacts` / `.claude/worktrees/found-contacts`; never reset/stash/clean main or touch root debug. If source moved, refresh line evidence and characterization. Check disk before APFS clone/evidence work. Establish `npm run check` baseline in the worktree, not main.
2. **Preserve complete before state (capture wait separate).** Before any source change, save complete corpus report, logs, all corpus pastes and exact original full HTML, every width finding/height/font diagnostic, v1 identity list. Corpus overwrites its report: copy it immediately. Save current modified debug to a task-owned scratch/evidence input and replay from worktree. Capture generic before contact/title/label/card/map inventory; preserve original fonts/motion states and raw failed runs. No stand-in/expected-set narrowing to manufacture comparison. This bug changes links and map queries, so text proof is primary; capture affected synthetic visual before state if removal of false phone wrapper changes layout.
3. **C1 label tracer (2–5min).** Add Appendix A's `horizontal spacing cannot create a rejected-data page label` test. RED: raw multi-space label returns a destination. Add the horizontal-only boolean helper in contacts and call it in `labelWords`; ordinary labels and raw contact/rejected-range controls remain unchanged. Run unchanged GREEN plus normalise-page-words, existing phone suites. Do not change PHONE spacing grammar.
4. **C1 target tracer (2–5min).** Add Appendix B's card-scope test with no-caption control and separate heading. RED: multi-space caption still allows `/available-parts/`. Use shared helper within existing `allowed()` target traversal; narrowly update only the historical assertions identified above. GREEN must keep title selected, card plain, independent label/sibling and explicit pill links working; raw recognition characterization still passes. Commit this consistent P3 slice.
5. **Timestamp pure tracer (2–5min).** Add Appendix A timestamp test, varying fixed valid years/separators/clock and exact UTF-16 ranges. RED must be false phone acceptance, not an import failure. Implement complete bounded timestamp classification at `scan`, projecting the full range and preserving non-overlapping later phones/emails. Run old plain-date/invalid/longer/line-break controls unchanged. No broad prefix or ISO parser.
6. **Timestamp downstream tracer (2–5min).** Add Appendix B timestamp styled-run/Call test and card-caption variants. Verify actual removal of false anchors/wrapper and Call false source; with genuine later number, Call selects that number and all real slices retain full href. Data removal must not unmask a page/card destination; no-real-number produces existing named warning. Designer date links, linked parent and frame/provenance controls unchanged. Fix only within allowlist; a new contact caption-ranking policy requirement stops the batch.
7. **Address field tracer (2–5min each small case).** Add Appendix A address cases **one form at a time**: bullet suffix, leading ID comma field, separate ID/number logical lines, full timestamp line, multi-space groups. RED must name actual contaminated query/address. Apply bounded field cleanup; keep phone policy separate. Run Appendix B real-map tests and clean/units/foreign-format controls. Do not replace address detection with arbitrary prose inference.
8. **All-consumer boundary completion (5–10min editing, measurements separate).** Add missing variants for style cuts before/inside marker/date/clock, emoji offsets, horizontal tabs/NBSP/em-space groups, all existing logical separators, independent label/sibling card, typed/frame/designer-linked rejected text/title/pill/ancestor, hidden contact pool and caption selection. Preserve exact run/link indices, note/page-address inventories, payload validity and determinism. New tests should stay under ~300 lines/file; split feature-owned tests only if necessary, obtaining explicit additional filename ownership.
9. **Focused sensitivity (2–5min per selected mutation).** Prefer causal source reverts where observed RED already proves the claim. In isolated task-owned probe copies, restore old timestamp whole-match check; bypass helper only in label; bypass helper only in target; restore old numeric-only address removal; omit separate-ID-line association; broaden timestamp to any valid-looking prefix (must fail longer-phone/invalid-date positive controls); flatten logical breaks for dial suppression (must fail separate-line phone control). Pin exact source/test hashes, one mutation at a time, restore in `finally`, preserve full actual diagnostics and unchanged controls. No mutants in main or a sibling's harness. A survivor requires cause/reachability/duplicate-guard analysis, not changed oracles.
10. **Whole final evidence and gates (runtime wait).** Run focused families, `npm run check`, separate `npm run test:browser`, full `npm run corpus`, then modified-debug replay on the same saved input. Compare baseline/final complete reports, payloads, exact full HTML and native/inline hrefs/map q/anchor scope; not only console totals or old scores. Normal corpus/debug inputs are expected byte-identical unless they really contain the new pattern; explain every diff by element, never assume. Compare raw expected/loaded/missing/failed font sets and motion comparability. Garamond remains UNVERIFIED; preserve its failure and do not apply historical release-specific M1A to this feature. Missing required acceptance is a release hold, not permission to skip or substitute.
11. **Fresh review / fix / verification / merge (dispatcher roles).** Builder stops committed `ready-for-review`; dispatcher starts separate fresh Sol6.1 xhigh reviewer with this plan, exact current-base diff and all original RED/control/mutation evidence. Finisher verifies every finding test-first. A change to rendered output/semantics in fix pass needs fresh focused re-review; Agent Defect Loop skills also require fresh verifier and `ready-for-verify` hold. Before release, rebase onto then-current main; regenerate **same-base** before/after evidence, run check/browser/corpus and any affected targeted measures. Acquire completed merge lock, ff-only, finisher-only BUILD bump/build/push and exact main/origin/dist readback. If main moves twice during gates take lock before next rebase/gates. Never claim a new release waiver; if Garamond blocks release, keep code/review evidence ready and let dispatcher resolve the shared proof question. Allocate next free paste-check on actual main under lock, not a number guessed now.

## Tests / evidence acceptance matrix

| Contract | Required evidence | Planning status |
|---|---|---|
| All five exact ledger rows | Pure/convert regressions for the seven observed symptoms; no inferred ID/date/false map target; generic controls | Current-main intended RED observed; fix not implemented |
| P1A/P2A preservation | Raw UTF-16 spans, same-line boundary, samples/emails, invalid/mixed/longer positives, genuine separate-line ID phone | Source/tests inspected; observer controls captured; future GREEN required |
| P3 no unmasking | Card small/equal/sole, no-caption, label-only, independent label/sibling; designer title/pill/ancestor/provenance | Current-main full conversion captures; target/label fail as assigned |
| Contact consumers | Real styled phone before/after, Call none/own/nearest/by-name/main/hidden; warnings/anchor indices | False timestamp Call selection captured; full branch regression required |
| Maps/address/rag | Actual decoded iframe q, place-card/nearby/two-text/explicit Maps link priority, metadata-only fallback; address `<br>`/prose controls | Contaminated q reproduced on real conversion; branch proof required |
| Appearance/tap scope | Text proof of hrefs/map queries; exact screenshot RGBA for unchanged-looking cases; actual anchor rectangles/no nesting at desktop and narrow phones | Not run in planner; builder/reviewer proof required |
| Corpus/debug no worse | Complete baseline/final reports/pastes/full HTML, fonts/motion sets and per-width findings; same-base rebase proof | Not run in planner (bounded probe only) |
| Release/install | Fresh review/fixes, any loop verification, merge/build/push/dist proof; normal workflow paste check | Not run; no source/release claim |

No padding/floor/width change is proposed. For affected synthetic outputs measure Chrome at **1440,1300,1200,1100,1024,992,991,800,768,600,480,479,390,375,360,320** where wrappers/link bounds change; ensure no lost words/overflow/new clipped address/phone text and anchors cover only intended targets. Compare same-source same-font before/after. Preserve main's clean tiers and intentional cropping; do not invent layout changes to satisfy generic lint. All current configured corpus widths remain, plus relevant explicit widths above; coordinate with gates for new helper coverage instead of editing its harness. Map query correctness can be inspected without loading external live map contents. Installed Bricks/paste behavior is a later user check, not proved by local renderer.

### Exact focused commands (future builder; workdir = feature worktree)

```bash
node --test test/unit/found-contacts.test.ts test/unit/convert-found-contacts.test.ts test/unit/phone-guards-title.test.ts
node --test test/unit/phone-candidate-policy.test.ts test/unit/phone-recognition-guards.test.ts test/unit/phone-guards-address.test.ts test/unit/normalise-contacts.test.ts test/unit/normalise-contact-runs.test.ts test/unit/normalise-page-words.test.ts test/unit/convert-contacts.test.ts test/unit/normalise-maps.test.ts test/unit/convert-maps.test.ts test/unit/style-text-breaks.test.ts test/unit/convert-page-links.test.ts test/unit/convert-card-link-words.test.ts test/unit/convert-text-links.test.ts
npm run check
npm run test:browser
npm run corpus
```

Use `node --test --test-name-pattern '<exact test name>' <owned file>` for each tracer's RED/GREEN. The complete command list is required at final/rebase gates, not after every line. `check` does not run browser tests. Corpus exit1 with existing v1 differences/font incompleteness must be attributed from complete reports; it is not a green pass or proof of a new regression by itself. Do not change thresholds/skips/expectations to force exit0.

## Appendix A — complete pure-test starter (future file only)

Target `test/unit/found-contacts.test.ts`; create/append one named tracer at a time. These use existing public exports so intended RED is behavioral, not a missing-helper import. Literal dates are synthetic fixed fixtures, not clock-relative assertions.

```typescript
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { contactsIn, rejectedIn } from '../../src/core/normalise/contacts.ts';
import { addressIn } from '../../src/core/normalise/address.ts';
import { labelWords } from '../../src/core/normalise/page-words.ts';

const plain = '12 Market Street, Springfield IL 62704';

test('horizontal spacing cannot create a rejected-data page label', () => {
  for (const gap of ['  ', '\t\t', '\u00a0\u00a0', '\u2003\u2003']) {
    const words = `View ID${gap}0812${gap}473${gap}1900 →`;
    assert.equal(labelWords(words), null, JSON.stringify(words));
  }
  assert.deepEqual(labelWords('View services'), { dest: 'services', go: true });
  assert.deepEqual(contactsIn('Order ID  0812  473  1900'), []);
  assert.deepEqual(rejectedIn('Order ID  0812  473  1900'), []);
});

test('a valid complete plus date and clock is data with exact raw range', () => {
  for (const stamp of ['+2026-10-21 10:30', '+2024.02.29 23:59', '+2400-02-29\t00:00:59']) {
    const words = `😀 Updated ${stamp} · call 0739 285 6401`;
    const start = words.indexOf('+');
    const phone = words.indexOf('0739');
    assert.deepEqual(rejectedIn(words), [{ start, end: start + stamp.length, reason: 'date' }]);
    assert.deepEqual(contactsIn(words), [{ start: phone, end: phone + '0739 285 6401'.length, kind: 'tel', href: 'tel:07392856401' }]);
  }
  for (const number of ['+2026.10.2123', '+2026-10-2110', '+2026.13.21', '+1900.02.29', '+44.20.7946.0958']) {
    assert.ok(contactsIn(number).some(f => f.kind === 'tel'), number);
    assert.deepEqual(rejectedIn(number), [], number);
  }
  const separate = 'ID\n0812 473 1900';
  assert.deepEqual(contactsIn(separate), [{ start: 3, end: separate.length, kind: 'tel', href: 'tel:08124731900' }]);
});

test('address metadata fields do not contaminate a surviving street', () => {
  for (const words of [
    `${plain} • Order ID 0812 473 1900`,
    `Order ID 0812 473 1900, ${plain}`,
    `${plain}\nID\n0812 473 1900`,
    `${plain}\nUpdated +2026-10-21 10:30`,
    `${plain} • Order ID  0812  473  1900`,
    `${plain}\nOrder ID\t\t0812\t\t473\t\t1900`,
  ]) assert.equal(addressIn(words), plain, JSON.stringify(words));
  for (const words of ['Order ID 0812 473 1900', 'Updated +2026-10-21 10:30', 'ID\n0812 473 1900']) {
    assert.equal(addressIn(words), null, words);
  }
  assert.equal(addressIn(plain), plain);
  assert.equal(addressIn(`${plain}\nSuite 100`), `${plain}, Suite 100`);
  assert.equal(addressIn('221B Baker Street, London'), '221B Baker Street, London');
  assert.equal(addressIn('Unter den Linden 77, 10117 Berlin'), 'Unter den Linden 77, 10117 Berlin');
});
```

Add calendar/clock invalidity, separator/end boundaries and mixed later-email cases before final acceptance; retain exact old valid-phone tests rather than replacing them with only `some(tel)` checks. The code above is a complete starter, not the entire promised final variation matrix.

## Appendix B — complete integration-test starter (future file only)

Target `test/unit/convert-found-contacts.test.ts`; fixture helpers are existing read-only files. Each card includes a separate section heading and real body so the card is actually inferable in the positive twin. No IDs/text values are used in production logic.

```typescript
import { beforeEach, test } from 'node:test';
import assert from 'node:assert/strict';
import { convert } from '../../src/core/convert.ts';
import { normalise } from '../../src/core/normalise/normalise.ts';
import { titleIn } from '../../src/core/normalise/card-title.ts';
import type { SceneNode } from '../../src/core/normalise/scene.ts';
import { payloadProblems, settingsOf } from '../../src/core/emit/payload.ts';
import { column, resetIds, row, solid, text } from '../fixtures/builders.ts';
import { icon, linkPage, section } from '../fixtures/page-links.ts';
import { mapCard, mapPage } from '../fixtures/maps.ts';
import { pillPage } from '../fixtures/card-link-words.ts';
import { segmented, textPage } from '../fixtures/text-breaks.ts';

beforeEach(resetIds);
const all = (n: SceneNode): SceneNode[] => [n, ...n.children.flatMap(all), ...n.hidden.flatMap(all)];
const inventory = (caption: string | null, size = 14, hasTitle = true, words = 'Learn more') => {
  const control = row('Read control', { gap: 8, align: 'CENTER' }, [text(words, { fontSize: 13, weight: 600 }), icon()]);
  const card = column('Inventory card', { width: 480, padding: 24, gap: 16, fills: [solid('#EEF3F5')] }, [
    ...(hasTitle ? [text('Available parts', { fontSize: 24, weight: 700 })] : []),
    ...(caption === null ? [] : [text(caption, { fontSize: size, weight: 700 })]),
    text('Browse the stock available in this collection.', { fontSize: 15, width: 400, autoResize: 'HEIGHT' }), control,
  ]);
  return { card, control, snap: linkPage(section('Inventory', [text('Browse our stock', { fontSize: 40 }), card])) };
};
const native = (r: ReturnType<typeof convert>, label: string) => settingsOf(r.payload.content.find(e => e.label === label)!).link;
const CAPTIONS = ['Order ID  0812  473  1900', 'Updated +2026-10-21 10:30'];

test('rejected caption scope stays plain while legitimate inference still works', () => {
  for (const caption of CAPTIONS) {
    for (const [size, hasTitle] of [[14, true], [24, true], [24, false]] as const) {
      resetIds();
      const p = inventory(caption, size, hasTitle);
      const nodes = all(normalise(p.snap).pages[0].root);
      const card = nodes.find(n => n.id === p.card.id)!;
      const control = nodes.find(n => n.id === p.control.id)!;
      const parent = (n: SceneNode) => nodes.find(a => a.children.includes(n)) ?? null;
      assert.deepEqual(titleIn(card, { skip: control, anchor: control, label: 13 }, parent), hasTitle ? { words: 'Available parts', question: false } : null);
      const r = convert(p.snap);
      assert.equal(native(r, 'Inventory card'), undefined, caption);
      assert.deepEqual(r.pageLinks, [], caption);
      assert.deepEqual(payloadProblems(r.payload), []);
      assert.deepEqual(r, convert(p.snap));
    }
  }
  resetIds();
  assert.deepEqual(native(convert(inventory(null).snap), 'Inventory card'), { type: 'external', url: '/available-parts/' });
  resetIds();
  const r = convert(inventory(CAPTIONS[0], 14, true, 'View services').snap);
  assert.equal(native(r, 'Inventory card'), undefined);
  assert.deepEqual(native(r, 'Read control'), { type: 'external', url: '/services/' });
});

test('spaced ID labels never guess a page in a card or alone', () => {
  const words = 'View ID  0812  473  1900 →';
  for (const inside of [false, true]) {
    resetIds();
    const snap = inside ? inventory(null, 14, true, words).snap : linkPage(section('Inventory', [
      text('Find your order', { fontSize: 40 }),
      text('Every order is tracked from the bench to your door.', { fontSize: 15, width: 400, autoResize: 'HEIGHT' }),
      row('Read control', { gap: 8, align: 'CENTER' }, [text(words, { fontSize: 13, weight: 600 })]),
    ]));
    const r = convert(snap);
    assert.deepEqual(r.pageLinks, []);
    assert.equal(native(r, 'Read control'), undefined);
    assert.deepEqual(payloadProblems(r.payload), []);
  }
});

test('timestamp supplies no automatic inline wrapper or Call target', () => {
  for (const real of [false, true]) {
    resetIds();
    const date = segmented([{ words: 'Updated +2026-', weight: 700 }, { words: '10-21 10:30', color: '#C02030' }]);
    const phone = segmented([{ words: '0739 ', weight: 700 }, { words: '285 6401' }]);
    const button = row('Call control', { padding: 16, align: 'CENTER', fills: [solid('#295E73')] }, [text('Call Today')]);
    const snap = textPage([date, button, ...(real ? [phone] : [])]);
    const scene = normalise(snap);
    const nodes = all(scene.pages[0].root);
    assert.equal(nodes.find(n => n.id === button.id)!.contact, real ? 'tel:07392856401' : null);
    assert.ok(nodes.find(n => n.id === date.id)!.text!.runs.every(run => run.link === null));
    assert.equal(scene.warnings.some(w => w.includes('a call button, but the page shows no phone number')), !real);
    const r = convert(snap);
    const html = String(settingsOf(r.payload.content.find(e => String(settingsOf(e).text).includes('Updated'))!).text);
    assert.doesNotMatch(html, /<a\b|phone-number|tel:/);
    assert.equal(html.replace(/<[^>]*>/g, ''), 'Updated +2026-10-21 10:30');
    if (real) assert.deepEqual(nodes.find(n => n.id === phone.id)!.text!.runs.map(run => run.link), ['tel:07392856401', 'tel:07392856401']);
    assert.deepEqual(payloadProblems(r.payload), []);
  }
});

test('real map queries omit metadata but visible address words survive', () => {
  const plain = '12 Market Street, Springfield IL 62704';
  for (const words of [`${plain} • Order ID 0812 473 1900`, `Order ID 0812 473 1900, ${plain}`, `${plain}\nID\n0812 473 1900`, `${plain}\nUpdated +2026-10-21 10:30`]) {
    resetIds();
    const r = convert(mapPage(mapCard(words)));
    const map = r.payload.content.find(e => e.label === 'Map');
    assert.ok(map, words);
    const q = String(settingsOf(map).code).match(/q=([^&]+)/)?.[1];
    assert.ok(q, words);
    assert.equal(decodeURIComponent(q), plain, words);
    const rendered = r.payload.content.map(e => String(settingsOf(e).text ?? '')).join(' ');
    assert.match(rendered, words.includes('Updated') ? /Updated/ : /ID/);
    assert.deepEqual(payloadProblems(r.payload), []);
  }
});

test('designer-linked pill remains independent beside spaced data', () => {
  const p = pillPage();
  p.card.children!.push(text(CAPTIONS[0], { fontSize: 28, weight: 700 }));
  const r = convert(p.snap);
  assert.deepEqual(native(r, 'Control'), { type: 'external', url: '/pricing/' });
  assert.equal(native(r, 'Card'), undefined);
  assert.deepEqual(payloadProblems(r.payload), []);
});
```

Starter snippets are syntax-checked only by the planner; **not executed as new tests** and no implementation GREEN is claimed. Builder must expand/strengthen the noted acceptance cases vertically, inspect run styles from normalized metadata/emitted output rather than assuming a `<strong>` wrapper, and use exact expected href inventories instead of a blanket `doesNotMatch(<a)` in fixtures that deliberately contain designer links.

## Other things found / exclusions / stop conditions

- No additional independent defect is proposed for the canonical ledger. Timestamp Call-source/wrapper contamination and multi-space address variants are direct consequences/controls of assigned rows, not separate closures.
- Existing caption-by-name tie behavior documented in the prior phone ledger is **not** changed. A negative contact classification changes nearby-caption eligibility; preserve/observe it instead of promising every caption inventory is identical.
- ISO/T/timezone/free-form timestamp recognition, arbitrary identifier vocabulary and cross-node metadata association remain unapproved. The observer includes a T-form for boundary characterization; absence of `rejectedIn` there is not authorization to add it.
- **W-B remains held for Justin. Garamond Condensed stays UNVERIFIED.** No new font, stand-in, expected-family narrowing or release-waiver inference. Preserve all prior pending CLAUDE files and root debug. No live-site login/writes or guessed installed-Bricks proof.
- Stop with current committed evidence if required source outside allowlist, a new policy/capability, insufficient disk/capture capacity, unapproved archive/protected-write operation or unreconciled gate failure is necessary. Two focused repair/recheck cycles per unexpected failure within the current slice before narrowing/escalation; do not bury raw failures with rerun-until-green. Scope resize/holds go to dispatcher, not silently into this build.

## Completion / reporting contract

Builder returns actual source/base SHA, named RED→GREEN cases, unchanged-control outcomes, mutations/restoration hashes, complete report/paste/HTML paths, debug proof, actual gate exits, comparability/font limitations, screenshots or text proof, and `ready-for-review` only. No self-review, merge or BUILD bump. Reviewer/finisher/verifier return exact findings and source identities; missing required proof remains explicit.

Final release report distinguishes built, fresh-reviewed, verified-merged/pushed/dist-rebuilt and **live-paste-verified**. Do not close more than rows193/198/199/200/208, and only those actually fixed after verified merge. Previously saved wrong links/maps require re-convert/re-paste; there is no automatic site repair.

## Task 12 — Docs & records (last implementation task)

1. Copy this approved plan to `docs/plans/2026-10-22-found-contacts.md` in the feature worktree. Keep provenance of planning RED and actual later GREEN distinct.
2. Maintain `.superpowers/sdd/found-contacts/progress.md`, then move the complete ledger to `docs/plans/2026-10-22-found-contacts-ledger.md` before final review/release. Include authority C1A/C2A/C3A, exact changed old test, all source/control hashes, failed/raw/font-noncomparable evidence and actual gates.
3. Update `docs/HANDOFF.md` without losing sibling sections: exact scope, intended deltas and retained P1A–P3A, limits, evidence, **next free paste-check at merge**. Preserve existing 3aw and all newer reservations. Paste check: reload plugin, Convert/copy, re-paste/save affected page, regenerate Code signatures if map Code present; compare map destination, genuine/false dial targets, plain card vs independent link boundaries; reply *pasted + page name* for GET-only live checking. Do not call local map q proof a live Google result or installed sign-off.
4. Finisher alone updates `src/shared/build.ts`/BUILD after clean required review/verification and merge lock, builds dist, commits/pushes and verifies exact remote/main identity. **Do not choose a BUILD value now.** Required proof hold means no bump/merge/push/cleanup until resolved.
5. **No CLAUDE.md write attempt.** Preserve exact proposed Start here/contact/map/data-policy/Where things stand/build-line edits in `/Users/justin/.hermes/plans/figma-to-bricks/found-contacts-claude-md-pending.md`, explicitly ordered after all older pending builds; retain `phone-recognition-guards-claude-md-pending.md` and every other pending file. Use actual final gates/build values, name sections already applied (none by this batch), build line last. New documented rule: complete separated date+clock is the assigned P2A boundary case; raw/horizontal-collapsed P3 label/target veto and bounded address-field cleanup do not broaden dial grammar. No routing through another tool/agent to apply refused edits.
6. Dispatcher/finisher, not this planner, updates the canonical found ledger for each **verified merged** assigned row with exact build and feature; leave held/deferred/unverified rows open. No shared batch/board/ledger edit was made in this planning task. If a rule-summary skill change is later warranted, route it through the permitted docs workflow; this read-only planner has no authorization to modify shared skills.
