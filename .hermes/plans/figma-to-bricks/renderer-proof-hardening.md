# renderer-proof-hardening — PLANNER

## Approved under Justin's away auto-go (2026-10-21 ~16:38 EDT)

**1A 2A (all ⭐):** four tooling fixes together, explicit expected/missing font metadata, incomplete-font captures non-comparable. Showcase flake and global narrow-width rollout remain deferred. Builder waits for a slot (at most three builders) and serializes corpus/browser gates with batch E to avoid host-load false failures; no production-source changes.

## Questions / approval choices (answered above)

**1. Batch boundary:** **A ⭐ — approve the four test/tooling fidelity fixes together**, leaving the unreproduced showcase flake and global narrow-width rollout out. B — split font reporting/comparability into a later tooling batch.

**2. Missing-font wording:** **A ⭐ — record requested-but-not-observed fonts separately (`expected` / `missing`), and mark such captures non-comparable.** Keep `loaded` and `failed` as observed FontFaceSet facts; do not call a missing family a proven network failure. B — report missing families but continue treating captures as comparable (not recommended: preserves the false-green risk).

No conversion, UI, installed-Bricks behavior, referrer policy, layout policy or additional font requests are being approved here. Return to Justin before crossing those boundaries. Planner only; no builder launched.

## Playback

1. The local HTML renderer invents native-link `rel` values, so browser tests can pass when the payload is wrong.
2. A copied linked picture's `tabindex=-1` lands on its image/figure, leaving its anchor reachable by Tab.
3. The showcase test proves a frame stays the same size, not that its enlarged photo is actually clipped.
4. A completely absent external font stylesheet leaves no FontFace entries, making `loaded: [], failed: []` look clean.
5. Fix these measuring tools and their negative controls, not the production converter or the live site.

## Scope and evidence snapshot

- Model/effort: Small / Sol6.1 high. Pure planner investigation; repository and live site read-only.
- Repository: `/Users/justin/Documents/FigmaToBricksV2`.
- Current tested source: `9f9b7519f2aaaca89b77007b436a742d72043610`, build `2026-10-21.19`; main equals origin/main at final inspection. The mutable debug JSON is the only dirty main file and was not edited. Main advanced from `f6f6600` during planning as card-link-words finished; inspected the intervening diff (records/BUILD only), and ran probes on .19.
- Narrow project context loaded: figma-to-bricks PLANNER/rules-summary, systematic-debugging, CLAUDE Start here/architecture/debugging/decisions, project memory, relevant HANDOFF and photo-hover/test-cleanup/PDF records. CLAUDE Start here still says .12; git/build, not that stale status line, determines this snapshot.
- Durable planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/renderer-proof-hardening/planner/`:
  - `probe.mjs` — small local-only reproduction using current renderer/Chrome; `proof.json` — measured results and exact HEAD.
  - `existing-fonts-showcase.tap` — existing focused suite: **7 pass, 0 fail, 0 skip**.
  - `listing-repeat-1.tap` through `listing-repeat-5.tap`, `listing-repeat-summary.json` — above-photo listing case **5 isolated repeats passed**. This does not establish busy-host reliability.
- Tight reproduction: `node ~/.hermes/plans/figma-to-bricks/evidence/renderer-proof-hardening/planner/probe.mjs`. Its assertions pin the *current diagnostic limitations*, not desired fixed behavior; the builder must add red-capable regressions described below, not reuse these baseline assertions as acceptance tests.
- No debug design comparison or live-site HTTP investigation is necessary: these are generic local tooling defects, not a reported defect in a particular pasted design. Clipping probe uses the real converted team fixture at its rendered 1440 viewport, not guessed Figma-only geometry.

## Root causes, controls, item mapping

| Canonical found-else item | Current cause and exact evidence | Status in this plan |
|---|---|---|
| PDF reviewer FE1 (`found-else.md:6`) | `test/browser/render.ts:134–135,144,181`: `newTab` unconditionally invents `rel="noopener"`; native `link.rel` is never read. Probe: missing rel becomes noopener; explicit `nofollow noopener` loses nofollow; same-tab explicit nofollow disappears. | Ready; still present on .19. Local renderer defect only. |
| PDF reviewer FE2 (`:7`) | `render.ts:131–144`: `_attributes` are serialized onto img/figure, while a separate anchor is created without them. Probe on both shapes: copied child has -1, anchor has no tabindex; real Tab visits original → copy → sentinel. | Ready; emitted payload not implicated. Not an observed Bricks defect. |
| Photo-hover clipping fidelity (`:141`) | `test/browser/showcase.test.ts:58–65`: frame `getBoundingClientRect()` remains `[80,152,300,360]` with overflow hidden **or** visible. Probe at `frame.right+4, midY`: hidden hits DIV; forced visible hits the scaled IMG. Both keep scale 1.1 and pass the old rectangle assertion. | Ready; no production clipping fix warranted. |
| External stylesheet fontStatus omission (`:121`) | `test/browser/fonts.ts:7–11` enumerates only registered faces. A deterministic local 404 stylesheet produces no faces and `{loaded:[],failed:[]}`. Local successful stylesheet + Arial-backed named face produces loaded `Present Probe`. `tools/lib/corpus.ts:148–155,171` has no expected-family check and gates only observed errors. | Ready; fix reporting and gate wiring, not network/font loading policy. |
| Busy-Chrome above-photo listing flake (`:138`) | `showcase.test.ts:46–50,120–124` uses a 650ms wait after pointer movement, with scrolling beforehand. Candidate race, **not confirmed root cause**. Existing suite green and five isolated repeats green. | Investigated, deferred/open; do not claim fixed or relax tolerances. |

Ranked hypotheses tested: (1) rel is synthesized rather than copied — confirmed by three link variations; (2) tabindex is attached to the wrong DOM node — confirmed by DOM plus actual Tab; (3) frame geometry is independent of descendant paint clipping — confirmed by one-variable overflow mutation; (4) missing stylesheet creates no FontFace to enumerate — confirmed by local 200/404 twins. No source change was needed to isolate them.

## Proposed behavior

### Renderer links

- Serialize `target="_blank"` only from existing native `newTab`; serialize escaped explicit nonempty string `link.rel` independently, including on same-tab links. Never synthesize, append, replace or tokenize a missing rel. Missing/empty rel remains absent. Keep URL/text escaping and all payload fields unchanged.
- Apply this same small serializer to native Button/Div and linked-image wrappers. Inline rich-text HTML remains untouched.
- For linked images only, route the **existing tabindex attribute** to the wrapper anchor rather than img/figure; preserve its supplied value, including 0. Leave identity/classes/style/tag, `data-label`, alt/loading and other existing attributes on their current image/figure nodes. Do not migrate every attribute speculatively, add a new focus policy, or rebuild the image wrapper topology.
- On unlinked images, preserve tabindex and other attributes where they already are. Neither production `_attributes` emission nor the Bricks sample schema changes.
- Existing official schema archive (`reference/bricks/link-schema.json`, schema 2.4.3) documents rel/newTab fields; it is not installed Bricks 2.3.9 copy-back proof. Keep PDF paste check 3ar open.

### Clipping proof

- Retain unchanged-frame geometry as its own assertion with honest wording; add an independent paint/hit-test assertion.
- Cover full-bleed native figure/img **and inline-background `::before`** photos. The native case can use measured `elementFromPoint`; pseudo-element paint requires deterministic screenshot RGBA samples outside the frame, not querying a fictional pseudo DOM element.
- Use the existing opaque placeholder and a clear margin: sample 4px beyond the right edge at mid-height, where the 110% image would paint without clipping; assert the scaled content actually crosses that boundary geometrically. Keep the pointer inside its owner, the frame in view, and neighboring art away from the sample. No external images/fonts.
- The **same check must reject** a DOM-only `overflow:visible !important` mutation on the clipping frame, then accept after restoration. Require scale 1.1 as well, so disabling zoom cannot masquerade as successful clipping. Do not alter `src/core/style/classes.ts` or any overflow rule.
- A centered cut-out with ample space inside a larger panel is not a valid clipping-negative control: its 110% scale may never cross the edge. Do not claim product/listing clipping coverage from such a fixture alone.

### Font status / capture comparability

- Add an explicit expected-family input to `fontStatus`; return observed `loaded`/`failed` unchanged plus separately computed `expected` and `missing` sets, unique and sorted. `missing = expected minus observed loaded` is an unconfirmed-request signal, not a diagnosis of why it is absent. A registered-but-unloaded expected face is not declared loaded or an observed network error.
- Derive expected families from the **same family/stand-in mapping used by renderPage's requested stylesheet links**, not hardcoded family names or a CSS regex. Extract/export a small pure `requestedFontFamilies` helper inside render.ts; reuse it for link generation and corpus reporting without changing generated HTML. No document.fonts.load/check call or request retries/substitutions.
- `runCorpus` passes these expected names, preserves `loaded`/`failed` semantics, writes `fonts.expected`/`fonts.missing`, and surfaces missing families in console diagnostics. Existing reports remain untouched. New FileReport fields should be optional when reading legacy reports; new captures always write them.
- `regressions` flags non-comparability for observed failed fonts **or missing expected families in either new report**, even if both runs omit the same family. Also reject unequal observed loaded-family sets for before/after reports rather than trusting `failed: []`; label as font-state mismatch, not converter regression. Legacy reports without expected metadata retain that limitation explicitly; never fabricate their expected sets or backfill old files.
- Do not widen score/height/performance tolerances, hide findings, or treat an unknown/unloaded requested family as a network failure. If a requested but unused/hidden family is unobserved, report uncertainty conservatively; if corpus shows this is routine, stop and present a narrower actual-use policy instead of inventing success.
- Keep `settleCapture`, `Page.goto`, animation policy, global corpus widths, font requests and UI font supply/emission unchanged.

## Tasks and test-first gates

### 0 — Establish isolated baseline after approval

- Builder creates its own worktree from freshly inspected main, respecting all `.worktreeinclude` instructions; no planner worktree exists.
- Before any edit: run `npm run check`, focused browser tests, full corpus. Save exact base SHA, full log/report, all five pastes and original complete HTML in `.superpowers/sdd/renderer-proof-hardening/baseline/`; preserve existing v1-difference identities and font sets. Corpus exit 1 alone is not a regression finding.
- Reserve the file ownership below with dispatcher. No site writes, uploads, user-debug edits or source/UI refactors.

### 1 — Native link fidelity (RED → minimal GREEN)

- Unit matrix in `test/unit/render-links.test.ts`: Button, Div, raw-image and figure-image; newTab+missing rel; empty rel; explicit noopener; multi-token `nofollow noopener`; explicit same-tab rel; ordinary/no-link controls; quote/ampersand escaping. Assert exact attributes, not just that noopener appears somewhere.
- Old code must fail missing/custom/same-tab rel cases. Minimal serializer only in render.ts.
- Update the existing fixture in `test/unit/render.test.ts:17` to supply explicit rel for its intended secure new-tab example; its assertion at :34 currently pins synthesis and **is editable**. Prefer preserving `render-basic.html` byte-for-byte by making the fixture honest. If a golden changes, authorize only exact target/rel-related delta; no bulk golden refresh.
- Browser regression in `test/browser/render-links.test.ts`: removing native rel from a cloned converted PDF payload must remove it from DOM; restoring explicit rel restores it. Keep independent production payload assertions in existing `test/unit/pdf-new-tab.test.ts` read-only.

### 2 — Linked-image focus fidelity (RED → minimal GREEN)

- Extend renderer-link units: raw img and tagged figure; original/copy -1, explicit 0, unlinked -1; no duplicate tabindex on child; preserve child IDs/classes/data/alt/loading and href/rel/target. No wrappers nested or changed dimensions.
- New browser renderer-link test: real Tab sequence is original → sentinel, never copied anchor or copied child. Assert anchor and child separately for both image shapes at 390 and 1440; apply explicit focus reset per case.
- Add a converted `marqueePage(logoStrip({capture:true,link:true}))` path in the same new test file, filling pictures with existing placeholders: original linked logo remains reachable, all copied linked-image anchors have -1 and are skipped; inline ticker browser behavior stays covered by its unchanged existing suite. Synthetic image-pair test must not be the only conversion-path evidence.
- Old renderer must fail focus/anchor assertions. No edits to marquee emission, normalise links, or inline anchor serialization.

### 3 — A real clipping assertion (RED → minimal GREEN)

- In showcase.test.ts (or a small dedicated clipping suite if that keeps responsibilities clearer), add native and inline full-bleed clipping checks described above. Existing rectangle assertion becomes frame-size-only, not removed.
- Demonstrate the old frame-only check passes the missing-overflow mutation; the strengthened checker rejects it, with the same fixture and scale. Capture/store the measured sample values and mutation result as text/JSON, not a visual claim without measurement.
- If adding a settle helper for these tests, use bounded polling of actual terminal scale and valid pointer/viewport coordinates; retain the 1.1 endpoint and a hard timeout. A never-zooming control must fail. Do not globally replace waits or claim the historical listing flake fixed without reproducing it.

### 4 — Missing external stylesheet fidelity (RED → minimal GREEN)

- Extend `test/browser/fonts.test.ts` using local HTTP only: successful stylesheet with named local-backed face; 404 stylesheet for an expected family; empty 200 stylesheet; valid face whose font resource errors; registered unused face; empty expected set; duplicate and quoted/spaced family controls within the helper's supported literal family handling. Assert missing/loaded/failed independently. In particular absent stylesheet has **no observed failed face**, but expected family must be missing.
- `test/unit/render.test.ts` tests shared expected-family mapping: dedup/sort, stand-in substitution and no hardcoded family; HTML request list and helper agree. Existing generated HTML remains byte-identical.
- `test/unit/corpus.test.ts` tests missing metadata causes non-comparable diagnostic on current **and baseline**, both missing still rejects, unequal loaded-family sets rejects, genuine matching loaded sets pass, observed errors still reject, legacy fields absent remain readable and are not invented. Keep existing score/noise/photo-mask tests and thresholds unchanged.
- Wire runCorpus expected/missing recording and console output; verify an actual saved new corpus report's requested sets against the exact generated HTML family links. If genuine remote fetches fail, preserve that report as non-comparable, not green; use matched-policy recapture after success and keep both runs.

### 5 — Integration / no-output-change proof

Run in the builder worktree:

```sh
node --test test/unit/render.test.ts test/unit/render-links.test.ts test/unit/corpus.test.ts
node --test --test-concurrency=1 test/browser/render-links.test.ts test/browser/fonts.test.ts test/browser/showcase.test.ts test/browser/pdf-new-tab.test.ts test/browser/marquee.test.ts
npm run check
npm run test:browser
npm run corpus
```

- Repeat each focused regression with only its fix reverted, restore immediately, and retain failure logs. Mutate absent native rel, copied image anchor tabindex, frame overflow, and missing stylesheet expectations independently; each must be caught for its own reason.
- Compare saved baseline/final **payloads byte-for-byte**: tooling-only must not change any conversion output, including mutable debug replay if the builder uses its scratch copy. Full HTML may differ only at the approved renderer link attributes; enumerate every delta by native link/element, preserving all other bytes/styles/positions. For corpora lacking affected links, require byte-identical HTML.
- Compare full lint/findings/heights, observed font sets, expected/missing, capture policy and v1 identities at every existing width. New metadata is not a converter visual improvement. Preserve originals; never relabel a recapture as original. Re-render byte-identical original HTML under matched font/capture state if needed; retain non-comparable runs separately.
- Native/inline-link and clipping text/JSON proof suffices; any new screenshot comparisons are fixture/tool evidence, not installed Bricks screenshots. No plugin appearance change is intended. Reviewer checks no hidden production source edits or widened budgets.

## Touches / ownership

**Allowed implementation/test files:**

- `test/browser/render.ts` — native link attribute helper, selective image tabindex routing, shared requested-family mapping.
- `test/browser/fonts.ts` — explicit expected/missing reporting only.
- `tools/lib/corpus.ts` — report metadata, invocation and comparability diagnostics; **do not edit width selection**.
- `test/browser/showcase.test.ts` — honest geometry wording + real clipping proof, bounded local helper only as needed.
- `test/browser/fonts.test.ts` — local stylesheet twins.
- **New:** `test/browser/render-links.test.ts`, `test/unit/render-links.test.ts`; optional small dedicated `test/browser/showcase-clipping.test.ts` if necessary (choose one clipping test location, not duplicated suites).
- `test/unit/render.test.ts` — known contradictory rel fixture/assertion :17/:34 and requested-family mapping tests.
- `test/unit/corpus.test.ts` — new optional font metadata and comparability cases.
- `test/golden/files/render-basic.html` — contingent only; prefer no edit as above. No other golden/fixture refresh authorized.

**Read-only dependencies:** production `src/**`, all UI tasks, `test/browser/chrome.ts`, `test/browser/shoot.ts`, `test/browser/marquee.test.ts`, existing PDF units/browser tests, showcase/marquee builders, archived Bricks schema/examples, corpus configuration/baseline/debug data. A newly discovered contradictory test outside this list requires a narrow dispatcher exception before editing it. `src/shared/build.ts` is a later finisher-only release record exception, not a builder production change.

## Exact overlaps / sequencing

Inspected actual main-relative branch file lists and worktree status, not only historical ledgers:

- **pill-clip** (`5a5f845`): adapt layout/least/rows/unpin/shapes, style behaviours/paint/style/types, clipped-pills/label tests. No currently overlapping source/test files. Its overflow handling includes `clip`; our assertions must test actual clipping, not insist only `hidden` is valid. Its visual changes invalidate cross-base corpus comparisons: rerun against final integration base after rebase.
- **hero-photo-blend / H1B** (`46c17a5`): paint/picture/picture-shadow, dedicated shadow browser/fixture/unit tests. No current exact owned-file overlap. Renderer and screenshots are shared read-only infrastructure for that owner; coordinate timing of Chrome-heavy gates and recheck its H1B planner changes before builder starts. Do not change shadow math or use these proofs to settle the source/AVIF fringe.
- **card-link-words**: finished to main .19 while this planner ran; branch/worktree removed. Its emitted links are inputs to our renderer, not an ownership grant to change normalise/label-links. Preserve its paste check **3as** and all linked-pill/independent-destination behavior. Native rel/tabindex HTML-only deltas must be distinguished from its already-merged payload changes.
- **B media-rename-collision**: site-media + isolated tests, no owned-file overlap; no site-pages/run/UI changes here.
- **C phone-recognition-guards**: normalise/contacts + isolated tests, no owned-file overlap; no recogniser changes here.
- **D list-panel-followups**: lists/UI-main tests/wiring, no owned-file overlap; existing panel and PDF browser tests remain read-only regressions.
- **E google-font-range-policy**: UI font loading/emission + associated tests, not our browser fontStatus/corpus reporting. Distinct layers, but require dispatcher to reserve our exact fonts/helper files; if E proposes touching them, **serialize or split ownership**, not claim parallel-safe.
- **Held global 375/360/320 corpus rollout:** **hard dependency on this batch** because it shares `tools/lib/corpus.ts`, renderer and baseline/report policy. Do not start both builders in parallel. This batch adds no global widths; local focus probes at 390/1440 are not narrow-phone coverage closure.
- Shared docs/HANDOFF/BUILD/CLAUDE/found-item closure are finisher-serialized under the merge lock. Chrome-heavy validation should be staggered with other builders, never compensated by relaxed budgets.

## Risks / explicit non-goals

- Renderer focus/rel improvements can expose old browser failures; investigate payload vs tool separately, never patch production to appease a previous fake renderer result.
- Expected-but-not-loaded is uncertainty, including unused/hidden fonts, not evidence of a definite request error. Do not coerce statuses to make a corpus comparable.
- Unknown legacy font expectations limit retrospective claims. Original test-cleanup failed Yellowtail report stays preserved and non-comparable.
- No global corpus width/baseline rollout, duplicate Google-loader removal, range-font emission policy, source image/AVIF work, phone layout policy, production referrer change, live-site write or Bricks compatibility sign-off.
- No claim any canonical finding is fixed until implemented, independently reviewed, merged and exact item closure verified. The busy-host listing flake remains open unless later independently reproduced and resolved in approved scope.

## Docs & records — final task

- Builder copies this approved plan to `docs/plans/2026-10-21-renderer-proof-hardening.md`; keep TDD ledger at `.superpowers/sdd/renderer-proof-hardening/progress.md`, then move it to `docs/plans/2026-10-21-renderer-proof-hardening-ledger.md`.
- HANDOFF records exact source/base, all gates, expected/missing semantics, renderer-only proof boundaries, honest original vs matched-policy report paths, mutation evidence and deferred flake. **No new paste check or user action owed** for this tooling batch; existing installed-Bricks PDF check 3ar and card-link check 3as remain owed.
- Finisher follows the project release procedure: rebase/recheck/browser/corpus, merge lock, BUILD bump/build only at release; update main CLAUDE Start here/Where things stand after permitted write. Preserve existing pending edits; if blocked, save exact pending changes, no bypass.
- Any durable new rule: loaded/failed are observations; expected missing is separate; comparable reports require confirmed matching font state; renderer DOM/navigation is not Bricks integration proof. Refresh rules-summary only if this adds a new rule, not status.
- Dispatcher closes only the four exact canonical tooling rows after verified merge. Do not close the busy-Chrome flake, global width rollout or production/site checks. No new out-of-scope findings found by this bounded investigation.


## Justin's answer M1A (2026-10-22 ~01:30 EDT)
Justin's words: "Now for M1A, just go with A ... Just keep running them."
Release this feature with the Garamond Condensed font check marked explicitly: "UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not available; no stand-in substituted, expected font set NOT narrowed". This waives ONLY the release hold on that one pre-existing font gate, for this release. Every other gate stays (rebase, check, test:browser, corpus vs baseline with loaded-family comparison, merge lock, ff-only, build, push, verify). Record the waiver in HANDOFF, ledger and the report. W-B (wrapped-row least) stays deferred: Justin unsure.
