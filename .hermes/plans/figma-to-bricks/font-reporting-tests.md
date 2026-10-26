# font-reporting-tests — bounded autonomous implementation plan

## Outcome / authorization

1. Correct the panel's claims about the numeric weight actually executable in accepted Google face CSS; do not change the design's typography.
2. Cover that result through the actual built panel, its conversion/run boundary, DOM notes and final copied paste, not only Node units.
3. Retain .13 family/style validation and .21 executable/raw-text no-range protection, request policy, Google/site precedence and accepted static CSS bytes.

Justin authorized this named batch's bounded planner → builder → separate fresh reviewer → finisher → verified merge/push loop in `briefs/autonomous-round4-planners.md`. **No routine approval question.** This document is planning only: no repository/source/test changes, branch, worktree, commit or shared-main build were made. Parent owns dispatch and independent review.

**Size/model:** remains **small, Sol 6.1 high** for builder/finisher, separate fresh Sol high reviewer. Two short production files; one isolated unit file and one isolated bundled-browser file. No renderer, layout or new loading capability. Reassess before broadening if this requires a general CSS engine, new parser dependency, family policy, renderer helper or shared panel-harness refactor; do not silently expand under small routing.

## Current baseline and relevant rules

- Inspected main/origin `5e32aec`, BUILD **2026-10-21.22**. Main status: only Justin's modified `figma-to-bricks-debug-page-1.json`; left untouched.
- Main `CLAUDE.md` Start here still says .12. This is a documentation backlog, not the executable baseline. Preserve pending earlier-build edits; finisher must not overwrite them or claim they landed.
- Loaded figma-to-bricks PLANNER, compact rules-summary first, relevant CLAUDE Start here/font rules, memory and systematic-debugging. Relevant predecessors: google-partial-fonts .9 (coverage), google-font-hardening .13 (literal descriptor validation), google-font-range-policy .21 (typed projection + raw safeguards); list-panel .22 owns a large panel file but did not repair these findings.
- The shared brief's canonical owned findings are **`found-else.md:178`** (first/comment-split/repeated weight misreported) and **`:180`** (no bundled Google-font coverage), under the heading at :177. `:179` is an intentional/unsupported keyword/reversed-range note, **not owned**. The font-range ledger :102–105 explicitly deferred both owned findings.
- Existing Google duplication row **found-else :36** remains HELD for live paste proof. No loader removal, font provisioning/Garamond acquisition, casefold or physical-font substitution. No actual WordPress request, login or site mutation.

## Root cause and executed diagnosis

### Exact source trace

- **`src/ui/fonts.ts:64–81`, especially :68–72:** `suppliedFaces` has a separate regex per descriptor. It reads the first literal name after `{` or `;`. A comment before the colon makes a real weight appear absent, incorrectly defaulting to 400. A repeated descriptor returns the first, not the executable last valid literal. A semicolon inside a comment can also trick the regex into reading a fake declaration. A comment following a numeric value instead makes a valid executable weight unconfirmed.
- **`fonts.ts:85–91,103–116`:** both missing classification and projection's `confirm` callback use this reader. Its false 400 affects `missing`, `supplied`, alternative-weight notes, and sometimes whether a projected copy is accepted.
- **`src/ui/google-faces.ts:14–66`:** existing typed scanner already masks comments, preserves spans and handles strings, parentheses and URLs; :25 intentionally rejects repeated family/style/weight descriptors for the **projection** path. Reusing it unchanged cannot fix repeated-weight metadata. Relaxing it globally would weaken .21's unreadable/range policy. Separate scanning mode from projection eligibility narrowly, using this same scanner, not a second regex parser.
- **`google-faces.ts:78–94,103–146`:** raw plain-number mention checks and unreadable-face escape/comment gates are independent protections. Preserve them, strict default `readFace`, range span-only replacement, static precedence and later-range duplicate handling.
- **`src/ui/run.ts:159–167,185`:** already appends Google then site CSS and passes returned missing/supplied data into existing `fontPlan`/notes. **`src/ui/main.ts:173–182`** already displays these rows and copies the resulting payload. Neither consumer needs a production change.
- **`test/browser/panel.test.ts:995–1000`** forces `googleFonts:false` in its font conversion helper; the entire file is **1089 lines**. Search of browser tests finds no enabled Google-font panel scenario. Node tests passing therefore do not establish built-panel integration.

### Tight loop actually run

Durable evidence: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/font-reporting-tests/planner/`:
`probe.mjs`, `probe.json`, `focused-baseline.tap`, `context.json`, `MANIFEST.sha256`.

```sh
node /Users/justin/.hermes/plans/figma-to-bricks/evidence/font-reporting-tests/planner/probe.mjs
```

**Exit 1, intentionally RED: six assertion groups fail** (five metadata cases plus actual bundled panel), not an import/harness failure. Chrome **155.0.0.0**, `CSSStyleSheet.replaceSync`, unadopted sheets (no physical font download); all loader responses local stubs. The panel part opens the existing on-disk `dist/ui.html` with a fail-closed fetch stub and real init/Convert/result messages. It was not rebuilt in shared main; its exact SHA-256 is in `probe.json`. Builder must exercise a freshly rebuilt worktree bundle.

| Generic response | Chrome executable weight | Current metadata | Current paste / requests |
|---|---|---|---|
| `font-weight: 700` | 700 | 700, not missing | exact input; one GET |
| `font-weight/**/: 700` | 700 | **400; 700 missing** | exact input; one GET |
| `400; font-weight: 700` after initial weight name | 700 | **400; 700 missing** | exact input; one GET |
| `700; font-weight: 400` after initial weight name | 400 | **700; 400 missing** | exact input; one GET |
| `font-weight: 700/*c*/` | 700 | **unconfirmed; 700 missing** | exact input; one GET |
| `/* font-weight: 400; */ font-weight: 700` | 700 | **400; 700 missing** | exact input; one GET |
| weight truly absent | CSSOM empty; omitted-weight default applies | normal 400 | exact input; one GET |
| escaped name `font\\-weight: 700` | 700 | none; honestly missing | omitted by .21; one GET |
| `700 !important` | descriptor dropped | none; honestly missing | omitted by .21; one GET |
| ordinary `100 900`, ask 700 | range in answer, output 700 | 700 | only value span changed; one GET |
| comment-before-colon range, ask 700 | answer range | none | currently omitted because broken `confirm` |
| static plus a raw range mention inside comment | executable 700 | none | omitted by .21 raw protection |

Actual bundled panel reproduction for comment-before-colon 700: **`Sample Sans: 700 missing`**, note **“This paste supplies 400”**, despite a copied payload containing exactly the executable 700 CSS. The only fetch is `https://fonts.googleapis.com/css2?family=Sample+Sans:wght@700&display=swap`, credentials `omit`; no WP requests. Successful copy/status alone is not the acceptance assertion.

Focused existing baseline command:

```sh
node --test test/unit/ui-fonts.test.ts test/unit/ui-google-font-descriptors.test.ts test/unit/ui-google-font-ranges.test.ts test/unit/ui-google-font-escapes.test.ts test/unit/ui-font-sources.test.ts test/unit/ui-run-font-fallbacks.test.ts
```

**223 passed, 0 failed, 0 skipped.** Existing tests include three assertions intentionally pinning the old metadata limitation; list them in the allowlist below, do not stop a builder unexpectedly on them.

### Hypotheses / working twins

1. Separate first-match metadata regex disagrees with executable declarations: **confirmed** by comment/duplicate order reversal and fake-comment twin; direct loader fails without any site/UI.
2. Lost external Google response/retry causes wrong coverage: **ruled out** by stubbed accepted 200, exact preserved CSS and one GET each.
3. UI stale data/site precedence invents 400: **ruled out as root cause** by direct-loader failure, then confirmed as downstream propagation in the real bundle.
4. Existing typed reader can be substituted as-is: **false for repeats**, because strict projection eligibility rejects duplicate weights. Must retain strict projection and expose narrow metadata scanning without that duplicate-weight rejection.

These are synthetic supported-CSS regressions, not evidence that Google currently serves unusual declarations for discrete requests or that Bricks' raw scanner behavior is known for comments.

## Bounded implementation contract

- Reuse the character scanner in `google-faces.ts` for metadata. A narrowly explicit metadata mode may retain repeated **weight** declarations, in original order, while default/projection mode remains strict. Keep family/style duplicate handling conservative; do not turn this into new family/slant cascade support. One scanner implementation, no CSS regex rewriting, no DOM/CSSOM dependency or unsafe eval in production.
- `suppliedFaces` reads typed executable descriptors, validates with the existing `descriptorFamily`, `descriptorStyle`, `weightBounds`, then uses the last supported literal weight when repeated. Comments cannot create descriptors or turn a present descriptor into a fabricated omitted-400 default. A truly absent weight/style alone retains normal-400 defaults. Preserve .13 unsupported/malformed rejection, Unicode/opposite-quote/multiword-family positive controls and oblique angle rules; do not change `familyKey` or Google keyword policy.
- Do not skip an invalid present descriptor and silently certify its default. If parsing/validation cannot establish the face, it remains unconfirmed; no fallback guessing. For repeated weights with unsupported/malformed values, fail closed rather than expand CSS grammar. Projector raw checks still determine whether such CSS reaches output.
- Accepted static CSS must remain byte-for-byte, including duplicate plain numeric weights and comments. All reported supplied metadata comes only from emitted blocks, never the requests. Request URL/order/count, partial HTTP-200 no-retry behavior, failure-only individual retries and credentials remain unchanged.
- **Important expected test delta, not a new range policy:** fixing the existing `confirm` callback can now confirm `font-weight/**/: 800` after .21 already projected a readable `100 900` range. Such a readable range may consequently produce numeric copies instead of being dropped solely by the metadata defect. This follows .21's existing range projection contract: only weight span changes, no raw/executable range, matching family/slant/request required. Make this output delta explicit in proof and update only the named stale-limit tests. Do not preserve a known false `confirm` through a second legacy regex. Unreadable/escaped ranges, duplicated-range descriptors, word/range comments and `!important` remain rejected as before. If a genuinely broader acceptance change is needed, stop and return that case to the parent instead of treating auto-go as new policy.
- Final `fontPlan`, notes, site priority and design settings change only by consuming corrected evidence. No production `run.ts`, `main.ts`, source-planning or UI wording edit.

## Exact owned files / overlap / size

**Production edits:**
- `src/ui/fonts.ts` (127 lines now): replace only descriptor extraction in metadata; retain validators, loaders and public result API.
- `src/ui/google-faces.ts` (147): narrow scanner-mode change/type support, projection stays strict. No general parser extraction needed at this size.

**Tests:**
- NEW `test/unit/ui-google-font-metadata.test.ts`: isolated generic local fixtures/env stubs; may include `startRun` integration with local typed payload/site data so shared fixture files remain read-only. Target under ~300 lines; split only by purpose if truly necessary and record exact new filename with parent first.
- NEW `test/browser/panel-google-fonts.test.ts`: self-contained real `dist/ui.html` harness, existing `chrome.ts` API read-only; local message/fetch/clipboard stubs. Target under ~300 lines, do not enlarge/refactor `panel.test.ts`.
- Existing `test/unit/ui-google-font-escapes.test.ts` (164): **allowed narrowly** to replace the obsolete comment-range no-confirm assertions at :44–50 and :120–125, and the comment-value missing assertion at :73–79, with stronger emitted-byte/typed-weight/missing/supplied/request assertions. Preserve malformed-family/escaped/unreadable and raw-comment danger controls. Keep the M05 meaningful-unconfirmed test using an actually unsupported/malformed family/slant, not the now-readable comment-colon case.

**Read-only regression dependencies:** `test/unit/ui-google-font-descriptors.test.ts`, `ui-google-font-ranges.test.ts`, `ui-fonts.test.ts`, `ui-font-sources.test.ts`, `ui-run-font-fallbacks.test.ts`; `font-coverage.ts`, `font-names.ts`, `font-sources.ts`, `run.ts`, `main.ts`, `settings.ts`, `test/fixtures/panel.ts`, `test/fixtures/wp-collection.ts`, `test/fixtures/google/*`, `test/browser/chrome.ts`. New bundled tests may embed the existing source-backed `wpFontCollection` function for synthetic connected-site read coverage without editing that helper.

**Records:** own plan + ledger and own `docs/HANDOFF.md` section; finisher-only `src/shared/build.ts`, dist rebuild, main CLAUDE/skill rule clarification and external found-item records. No other source/test ownership.

Read-only active worktree diff/status intersection check found **no overlap** with these five production/test paths: hero-photo-blend owns paint/picture; media-rename-collision owns site-media/site-pages; phone-recognition-guards currently committed test groundwork and retains proposed normalise/contact/title/page-word/link scope; renderer-proof-hardening owns render/fonts/corpus and is held at 9c91bed. Leave all those files/helpers alone. Other round4 fixed-tile/GRO/responsive planners own layout/adapt; no planned source overlap. Shared docs/BUILD/main merge are serialized. Recheck actual intersections at builder start. Parent may queue this builder for an available slot (max three); stagger Chrome/corpus gates.

## TDD tasks — 18 bounded steps

### Task 0 — isolation and baseline

1. Parent dispatches builder only after recording bounded choices above; create its own worktree from then-current main using project workflow, copy approved plan, initialize `.superpowers/sdd/font-reporting-tests/progress.md`. Verify live ownership and baseline diff. No shared-main source/build writes.
2. Before code edits, save complete baseline check/browser/corpus logs, `corpus/report-v2.json`, all corpus pastes and original full HTML with exact base SHA. Preserve any network/font failure separately. Do not call a missing expected font matched merely because `failed:[]`; renderer/Garamond issue is out of scope. No corpus gate weakening or silently narrowed expectations.

### Task 1 — RED at the actual metadata seam

3. New unit test reproduces comment-before-colon, comment-after-value, fake descriptor inside comment and repeated valid numeric weights in both orders. Use generic alternate weights/families, uppercase and whitespace, normal/italic twins. Assert exact `supplied`, exact `missing` (including requesting both 400 and 700), unchanged accepted static CSS, one exact combined URL/credentials, no request mutation or uploads.
4. Add positive twins: ordinary single literal, truly omitted weight/style → normal400, multiple Unicode subsets deduplicating metadata only, quoted/opposite-quote/Unicode and valid multiword family cases, wrong slant/family negatives. Preserve .13 tests unchanged. Add malformed present/empty descriptor, escaped descriptor and malformed duplicate-weight controls that cannot turn into default400. No generalized reserved-keyword policy edits.
5. Add local `startRun` regression for ask400+700 with a repeated/commented returned700: rows are missing400/google700; notes may name only confirmed700, requested typography unchanged. Cover exact usable site400 winning, wrong-slant/unusable site400 not winning; Google-off stays unchecked and makes no Google requests. Use valid six-letter IDs and reciprocal tree. Run focused units RED on untouched source, record intended assertion failures.

### Task 2 — RED through the rebuilt bundle

6. Add isolated `panel-google-fonts.test.ts`; build in its own worktree before launching Chrome, skip only when Chrome absent per existing convention (release requires Chrome available/no skips). Stub only environment boundaries: init/result messages, clipboard, Google responses, explicit source-backed synthetic WP GETs where needed. Unknown fetches throw and are logged; assert no writes. Do not mock `loadGoogleFonts`, metadata, `fontPlan`, output or DOM values. Default fixture disconnected, no real font binaries or external network.
7. Enable Google in stored settings and prove actual checkbox true, send Convert/result with nonempty requested fonts. Test plain/comment-colon/repeated-weight responses, partial200, readable range, malformed/escaped face, Google-off, and exact-site-priority controls. Assert visible rows + warning text + parsed output + copied payload equality + exact request traces, not status alone. For same input, compare emitted CSS with expected accepted bytes; preserve any pre-existing `_cssCustom` and avoid spacer attachment. Failure-only retry scenario must be labelled injection and retain existing counts.
8. Independently parse the emitted CSS with **real Chrome `CSSStyleSheet.replaceSync`** in an unadopted sheet and read executable descriptor values/order. Do not use the production parser or a test regex as the CSS oracle; distinguish a genuinely omitted CSSOM weight from numeric400. Pair browser evidence with raw-text protection assertions from .21. Capture RED for actual misreported700 before source edits, not test setup/build errors. Existing planner probe supplies a working minimal harness.

### Task 3 — minimal GREEN, known old-test correction

9. Change only the two allowed production files per contract. Use existing typed scanner plus explicit metadata duplicate-weight allowance; default projection scanner stays strict. Keep all validation and raw/escape safeguards. Run the focused six baseline files plus new metadata test.
10. Change the three named stale-limitation expectations in `ui-google-font-escapes.test.ts` test-first: comment-value static now confirmed; readable comment-range gives requested numeric copy, same non-weight bytes, honest metadata. Keep a genuine unconfirmable-copy negative (e.g. invalid style/family) killing removal of `confirm`. Duplication of range descriptors remains rejected; no changed Q1A/Q2A/Q3A rulings. Re-run full focused + new bundled suite GREEN.
11. Emit old/new JSON proof per synthetic case: original/emitted CSS, Chrome executable descriptors, `supplied`, `missing`, row/notes, URLs/count/order and credentials. Existing static cases must have exact CSS identity, only report corrections. Explicitly list the comment-range confirm-unblocking delta and .21 numeric-span-only proof. The ordinary live discrete Google fixtures remain byte-identical; do not call synthetic responses live observations.

### Task 4 — mutation strength

12. Kill the original first-match regex/reverted production-fix mutant with the new units **and rebuilt-panel regression**. Mutate selection to first rather than last weight; ignore comment masking; treat unreadable/present-invalid as omitted400. Each must fail an exact metadata/row assertion. In isolated mutation copies preserve source hashes and restore GREEN after each; never leave a tracked mutant after a timeout.
13. Kill projection-safety mutants: metadata repeated-weight mode accidentally used by projection (duplicate range now leaks/changes accepted policy), raw comment-range check removed, escaped/unreadable or important gate removed, and request-derived metadata replacing returned-face proof. New/retained negative twins must catch them. Keep positive twins proving an over-strict parser that makes every unusual face missing also fails. Record equivalent/out-of-scope mutants honestly, do not report a denominator not actually exercised.

### Task 5 — matched final proof and fresh review

14. `npm run check`, `npm run test:browser`, `npm run corpus` in feature worktree, saving full results. Compare same-base five corpus pastes/HTML, complete lint findings/multiplicities/heights/fonts at all existing widths and exact worse-than-v1 identities; not just console totals/scores. This metadata-only change should leave ordinary corpus output byte-identical. Preserve original reports; use labelled matched-font/motion recaptures only with byte-identical HTML, expected loaded families, and equal policy. No relaxed tolerance, narrowing the expected font set, or renderer helper changes. Any ordinary corpus paste delta is stop-and-explain.
15. Scratch-copy current user's debug JSON, record checksum/build/root/font requests, replay identical before/after base in isolated contexts and compare payload/HTML/palette/warnings bytes. No Figma sibling geometry analysis needed for this synthetic panel metadata bug; debug replay proves core neutrality, not exotic Google coverage. Nonvisual text proof is sufficient; no fabricated before/after screenshots or physical-font claims. If unexpectedly visible real output changes, pause/reassess evidence and capture same-base affected shots before claiming visual improvement.
16. Builder commits bounded passing tasks/records and stops ready-for-review. Parent gives separate fresh Sol high reviewer the exact merge-base diff, this plan, original RED/bundle proof, mutation results, old-test permission and records. Reviewer checks no false400, .13 positives/negatives, strict projection default, raw/executable gates, bundle boundary truth and no helper scope creep. Finisher fixes verified findings test-first on original builder model.

### Task 6 — verified finish

17. Finisher rebases current main and repeats integrated check/browser/corpus plus focused metadata/bundle proof. Acquire and await actual merge-lock success, resolve conflicts in own worktree, allocate next free build/check at merge, ff-only merge, bump BUILD/rebuild/push main, verify exact main/origin/remote and dist; preserve live debug changes. Follow protected-CLAUDE pending-edit rules without retry/bypass. Archive/hash original and final evidence before worktree cleanup. No assertion of closure at ready-for-review or before verified merge.

### Task 7 — Docs & records (final mandatory task)

18. Copy plan to `docs/plans/2026-10-21-font-reporting-tests.md` (actual start date if later); move ledger to `docs/plans/2026-10-21-font-reporting-tests-ledger.md`. Record baseline/final SHA, exact RED/GREEN and test counts, metadata-vs-output deltas, mutations, raw gates, independently reviewed verdict, evidence path/verified manifest and held items. Update own HANDOFF section with next-free **conversion/panel** check: reload plugin, Convert, supplied weights/notes agree with accepted returned faces; real ordinary designs stay unchanged. **No installed-Bricks paste check owed for byte-identical ordinary corpus/debug output**, and local Chrome does not prove Bricks comment scanning or physical font selection. Preserve earlier 3au/3av/loader/font-recovery checks. Finisher updates main CLAUDE Start here/Where things stand and a narrow reusable rule in skill summary if needed: typed executable metadata, actual absence defaults, repeated supported weight last-wins, strict/raw projection separate. Apply in build order or save exact pending edits. At verified merge only, close **found-else :178 and :180**, identifying the exact wording/headings after re-read and actual BUILD; update matching batch records narrowly under parent serialization. Leave :179, duplicate loader :36, renderer/fontStatus/Garamond and all layout findings open. Do not rewrite the old .21 ledger's historical findings as though that build fixed these later follow-ups.

## Exact closure / acceptance

- Generic plain/comment-colon/comment-value/fake-comment/repeated-numeric accepted static responses report the executable supported weight and never invent400; order reversal changes the metadata correctly. Truly absent weight still defaults normal400. Wrong family/slant and invalid/unsupported descriptors remain unconfirmed.
- Accepted static CSS bytes unchanged; readable range copies follow existing .21 span-only/no-range projection and old-test deltas are explicit. Escaped/unreadable/range-comment/important/duplicate-range protections remain effective. No changed requests, retry rule, supplied/missing order semantics, design settings or site precedence.
- Freshly rebuilt real panel Google-enabled tests cover actual requests, rows, notes, paste and clipboard; Chrome CSSOM is an independent executable oracle; failure of the original source and meaningful mutants is archived.
- Independent fresh review + final rebased integrated gates + matched corpus/debug no-worse proof + verified merge/push/dist + durable docs/ledger/evidence all completed before the two canonical items are struck. Conversion check may remain owed and is labelled separately, never promoted to live-paste verification.

## Issues / unsupported findings

No implementation blocker found. Existing docs backlog and renderer/font availability issue are separate parent-owned work, not repaired here. Bricks comment scanner behavior, actual downloaded font/glyph identity, normal-bold keyword endpoints, reversed range approval, extra font provisioning and loader duplication remain explicitly unproved/out of scope. Planner ran only focused tests and bounded local Chrome/source probes, not expensive full corpus or shared-main builds.


## Justin's answer M1A (2026-10-22 ~01:30 EDT)
Justin's words: "Now for M1A, just go with A ... Just keep running them."
Release this feature with the Garamond Condensed font check marked explicitly: "UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not available; no stand-in substituted, expected font set NOT narrowed". This waives ONLY the release hold on that one pre-existing font gate, for this release. Every other gate stays (rebase, check, test:browser, corpus vs baseline with loaded-family comparison, merge lock, ff-only, build, push, verify). Record the waiver in HANDOFF, ledger and the report. W-B (wrapped-row least) stays deferred: Justin unsure.
