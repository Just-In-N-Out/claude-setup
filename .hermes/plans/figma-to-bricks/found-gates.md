# found-gates — Round 3 implementation plan (planning only)

## Questions and recommended answers

1. **How should geometry gates know what is meant to fit?**
   - **A) Explicit row/picture contracts; keep intentional crops. ⭐**
   - B) Infer intent for every corpus layer. **HELD: expanded capability.**
   - Recommendation A is within the named batch. A DOM rectangle cannot establish that an off-edge composition was unintended. Add reusable, opt-in checks to the existing lint entry point, prove them on controlled defects, and have layout/tiles supply their own intended geometry. Do not make every off-edge photograph a global error.
2. **How much default capture expansion now?**
   - **A) Add 1280; probe the complete laptop matrix separately. ⭐**
   - B) Capture five new laptop widths on every corpus run.
   - C) Add global 375/360/320 captures too. **HELD: separate rollout.**
   - A preserves every existing width, adds the representative width proposed in the canonical finding, and measures 1366/1300/1280/1200/1100/1024/992 in lightweight geometry tests. Existing required phone regression matrices still include 375/360/320. No screenshot explosion at ~8 GiB free.
3. **What happens when the new diagnostics expose a missing font?**
   - **A) Save the evidence, mark non-comparable, hold release. ⭐**
   - B) Resolve with the genuine licensed font. **Needs Justin.**
   - No option substitutes a font, drops an expectation, or reuses a historical M1A waiver. The safe autonomous recommendation is A.

The dispatcher may record **1A/2A/3A** under Justin's named-batch autonomous grant. This document authorizes no implementation by this planner. Grant ends when the four named batches finish or Justin cancels. W-B and ALONE remain held/unchanged. No CLAUDE.md write attempts, including retries through another tool or agent.

## Authorized answers — 2026-10-22
Under Justin's explicit Round 3 autonomous grant, dispatcher accepts **1A / 2A / 3A**: opt-in geometry contracts, add1280 plus lightweight matrix, preserve missing-font evidence and hold release if unresolved. Build is approved within this exact allowlist; merge/push/BUILD/cleanup are NOT authorized while a genuine-font release hold remains. No historical M1A extension implied. Gates owns geometry.ts, lint.ts wrapper and snap tooling; siblings own their consumer tests. Consumer adoption may follow on the committed gates branch under written ownership, but release order requires gates before consumers that import it. No CLAUDE write attempts.

## Goal / playback

1. Make a laptop width part of routine lint/snap/corpus coverage without removing any current width.
2. Provide assertions that actually notice a row packed left, a row overrunning its right edge, and a content picture clipped by its section—while preserving intentional cropping and reachable scrolling.
3. Reconcile the font finding against build .3, reuse its corrected implementation, and repair only a demonstrated remaining caller gap.
4. Keep conversion/paste/HTML output and all existing layout/font policies unchanged.

## Current context and source identity

- Repository: `/Users/justin/Documents/FigmaToBricksV2`; main/origin `b4ed333`, release **2026-10-22.5** at inspection. Only main worktree. `git status -sb` shows only the user's modified `figma-to-bricks-debug-page-1.json`; preserve it. Root debug is build 2026-10-20.6, frame `Hydraulic Cylinder Repairs Final`, width 1728—not GRO.
- `CLAUDE.md` Start here still says .12. That is stale protected documentation, not actual source identity. Read its debugging/decision sections together with current HANDOFF and existing pending edits. Never try to repair it in this batch.
- Source paths/lines below are against b4ed333. Main may advance; recheck exact diffs before assigning builders.
- Tool-observed start: **2026-10-22 06:57:09 EDT**. Initial discovery was bounded to read-only source and tiny Chrome probes; checkpoint 07:03:10 showed all three assigned areas localized. Planning forecast at that checkpoint: 8–15 further minutes, medium confidence, including artifact/snippet validation; no application-suite/corpus execution. Completed/validated by **07:09:05 EDT**, **11.94 minutes** measured from the first recorded inspection; faster than that remaining forecast. Three TypeScript fences passed syntax transpilation (contextual test body remains contextual; not typechecking or runtime acceptance). Twelve planner evidence files total **42,447 bytes** before this records update; 18 measured widths are unique. Implementation forecast: 30–60 minutes focused edits/proofs plus separate review/fix/gate time and any genuine-font release wait; not an ETA for release.
- Disk measured **8.0 GiB available**. No worktree, archive, source/test modification, corpus run or full-page corpus capture was made by this planner. One 390px synthetic snap plus JSON geometry probes only.

## Skills

Loaded: `figma-to-bricks` (and rules summary), `engineering-best-practices`, `implementation-planning` (plan-validation reference), `systematic-debugging`, `qa-testing-local-cloud` (detailed reference). Also inspected `feature-dispatch` to reconcile the independent-review/verification contract.

Builder: project + engineering baseline, `test-driven-development`, `systematic-debugging`, `qa-testing-local-cloud`, `mutation-testing-discipline` for checker sensitivity. Reviewer: project + engineering baseline, `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline`, QA specialist. Finisher: project + engineering baseline, `receiving-code-review`, `git-commit-rules`, TDD and QA.

**Agent Defect Loop:** none of the five required specialist/core skill files has the literal mandatory-loop section. `feature-dispatch` defines orchestration rather than being a specialist acceptance gate. Therefore `defect_loop_skills: []` for this plan. Independent fresh review remains mandatory. If a builder/reviewer loads an actual mandatory-loop specialist, return its name; finisher then stops `ready-for-verify` and the dispatcher launches a fresh verifier before merge. A child cannot spawn either role.

## Findings, root causes, actual reproductions and dispositions

Canonical ledger is `/Users/justin/.hermes/plans/figma-to-bricks/found-else.md`; its dispatch snapshot line numbers are locators, not closure authority.

| Assigned finding | Current evidence / root cause | Disposition |
|---|---|---|
| Line 226: “Gates are blind to laptop layout drift: corpus measures only 1024 among laptop widths (1100–1366 never), lint has no row right-edge/trailing-space check.” | `src/shared/breakpoints.ts:39–41` = LINT `[390,768,1024,1440]`, CORPUS adds 1920. `tools/lib/corpus.ts:132` and `tools/snap.ts:68` consume them. Existing `composition-clipping.test.ts:134` already visits 1300/1200/1100/1024/992, **but asserts the old percentage-margin share**, not the resulting right edge. Thus “no laptop tests anywhere” would be false; default corpus coverage and the assertion are the actual gaps. | Implement 1280 default coverage and explicit right-edge probes. The converter fix and old-share assertion replacement belong to found-layout. |
| Lines 238/248: “Lint has no clipped-picture check: a picture cut by its section passes corpus/lint.” | `test/browser/lint.ts:67–125` walks text; `187–205` checks image distortion, not clipping. `46–65` intentionally excludes overflow held by a clipping ancestor. `lint.test.ts:40–42` explicitly pins hidden nontext overflow as clean. Generic controlled native/CSS-background pictures each extend **50px** past a hidden section at 1200; current lint returns `[]`. | Add opt-in picture containment/clipping probes; retain default intentional-overflow control. Do not silently turn all hidden imagery into errors. |
| Line 226 / repeated 248 right-edge remainder | Controlled last item packed left leaves **270px** trailing room; lint returns `[]`. Existing generic inferred-index fixture on current main: at 1280 its last picture right=1248.609375, row right=1216 (**32.609375px past the row**), lint `[]`; at 1200 picture right=1184.96875, row right=1136 (**48.96875px past**), lint `[]`. At 991 trailing gap≈0.03125 and lint `[]`. The measurement distinguishes a row-boundary violation from a section cut. | Tool gap confirmed independently of the layout fix. No claim that adding a width alone detects it. |
| Lines 244/127: Yellowtail absent despite `failed: []`; always compare loaded-family sets | Build **2026-10-22.3**, implementation including `6adb05a`/`d8b0cd0`, already fixes corpus completeness and current-only/empty/absent-baseline CLI admission. `tools/lib/corpus.ts:169–186` checks failed, missing, expected-minus-loaded for every current file and compares observed sets; `tools/corpus.ts:37–39` always calls it. Direct current-main synthetic probe with expected Alpha+Absent, loaded Alpha, `failed:[]`, empty baseline returns a non-comparability diagnostic; complete twin returns `[]`. Existing unit and actual-CLI controls cover it. | **Already fixed for corpus; do not duplicate or re-close row 127.** Do not edit font key/comparator/parser or manufacture another font gate. |
| Remaining concrete caller gap: `snap` | `tools/snap.ts:54,84–102` renders/reloads/settles/lints each width but never calls `fontStatus` or `requestedFontFamilies`, persists no font status and exits 0. Planner ran the actual snap CLI at 390 with an intentionally omitted stylesheet via a process-local render hook: visible AbsentProbe CSS remains, no stylesheet, **exit 0**, stdout `3 elements, 0 warnings\n@390: sections vs Figma 40  lint {}\n`, no font diagnostic. Existing observer on the same absence returns loaded `[]`, failed `[]`, expected/missing `[AbsentProbe]`. This is controlled missing-stylesheet evidence, **not a claim about a live network failure**. | Implement per-width snap font receipt + explicit non-comparable diagnostic and nonzero final exit after saving artifacts. Reuse .3's observer/request expectation. |
| Earlier narrow-phone line 157 | Current globals still begin at 390; several fixture suites already sweep 320–478, and named sibling tests measure 375/360/320. HANDOFF `:225–226` explicitly retains global rollout as open. | Context only: preserve all existing phone coverage and require the sibling matrices. Do not claim this batch implements global narrow-phone rollout. |
| Lines 170/251 network/Garamond | .3 exposes—not repairs—genuine missing Garamond. Old interrupted loaded-empty/Splide runs are non-comparable evidence, not permission to add retries or weaken tests. | **Garamond UNVERIFIED**, expectation retained; network loader/asset repair outside scope. Historical M1A does not authorize this release. |

### Planner evidence (durable, small)

Directory: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/found-gates/planner/`.

- `probe.mjs`, `probe.json`, `probe.log`: current-main Chrome at 18 targeted widths, controlled aligned/packed/clipped/native/background/scroller cases, observer absence receipt. Synthetic geometry uses system fallback and placeholders, so it establishes checker blindness—not a physical-font or real-GRO fidelity verdict.
- `snap-probe.mjs`, `snap-missing/{input.json,hook.mjs,receipt.json,bricks.json,bricks.html,390.png}`: real CLI receipt under deterministic stylesheet omission. No assertion/diagnostic/exit branch was replaced.
- `corpus-reconcile.mjs`, `corpus-reconcile.json`: direct current implementation's missing/complete twins, no corpus conversion/network/capture.
- The scroller negative contains off-edge content reachable inside a real `overflow-x:auto` track. Its raw geometry crosses the outer section, but current lint remains clean intentionally. A universal “picture rectangle outside section = error” would be wrong.

### Ranked hypotheses resolved

1. Default widths lack laptop interior points: confirmed by exported values and consumers.
2. Lint misses painted nontext overflow by construction: confirmed by native/background defect twins.
3. .3 still bypasses missing fonts in corpus: falsified by source, existing actual-CLI regressions and direct current-only probe.
4. Another capture caller bypasses .3's observer: confirmed specifically for snap. Do not generalize this into a new production font failure.

## Architecture / recommended approach

Keep existing lint output exactly unchanged when no geometry contracts are passed. Add a small geometry module under `test/browser/` and an optional third argument to `runLint`. The module measures **caller-declared expectations**, never layer-name rules or guessed source intent. `lintInPage` itself stays self-contained and unchanged.

Contract (new `test/browser/geometry.ts`):

```typescript
export interface GeometryProbes {
  rows?: Array<{ box: string; last: string; expectedGap: number }>;
  pictures?: Array<{ target: string; clip: string }>;
}
```

- Selectors must resolve **exactly one visible positive-size element**. Missing, duplicate, hidden or detached targets reject, not silently skip. `last` must belong to its row; `clip` must contain its picture.
- Row measurement: content right edge = row rect.left + clientLeft + clientWidth − computed paddingRight. Signed trailing room = that edge − last rect.right. Emit `row-right-edge` error when `abs(actual−expectedGap)>1`. This catches both left-packing and overrun; expectedGap comes from the independent intended geometry, never from the same measured last edge. Contract is for a known single line/terminal item; wrapping rows need a caller-specified last item for the intended line, not a universal flex heuristic.
- Picture measurement: the declared target is the **picture frame** (native img/figure or own CSS-background box), not its natural bitmap or zoom child. Compare against the declared effective clip ancestor's inner rectangular clip edges on its hidden/clip axes. Emit one `picture-clipped` error for >1px lost extent, including fully outside pictures. No picture-distortion/object-fit change. For an intervening real scroll container, content reachable by scrolling on that axis is exempt only if that scroll viewport itself fits inside the declared clipping ancestor; demonstrate reachability by scrolling in a negative control.
- Supported proof is axis-aligned rectangular clipping. Reject unsupported transformed clip geometry or an absolute descendant that escapes the declared static clip rather than returning a confident measurement. No clip-path/mask/pseudo-element paint claims. Existing .3 zoom hit/RGBA tests remain the authority for paint clipping; measure frame bounds separately.
- Intentionally cropped art is not selected for a must-fit contract at the cropped tier. Negative controls must show that unchanged default lint continues to permit it; this is not an ID-based suppression list. The same item may have a fit contract after its documented responsive stack point.
- Keep current `LintFinding` structure; new findings use the same `check/severity/el/width/detail` keys. Row finding names the row, picture finding names the clipping box and detail identifies the target and lost extent.
- Add 1280 only to `LINT_WIDTHS`; `CORPUS_WIDTHS` inherits it. No BREAKPOINTS, gutters, contentMin, media queries, style/adapt or converter change.
- Snap: create one shared `pageOptions` object for render and `requestedFontFamilies`; after every reload/settle, call existing `fontStatus(page, expected)`. Persist `snap-report.json` with capture policy plus each requested width's full findings and exact observed/expected/missing fonts. Print named non-comparability errors for missing/failed families. Continue recording all requested widths, then set `process.exitCode=1` if **any** width is font-incomplete. Complete runs keep exit 0. Do not introduce automatic retry, demand physical-family equivalence, or relabel missing as observed failed.

This is a bounded tooling change, **Sol 6.1 high for builder/reviewer/finisher**. If implementation instead requires automatic snapshot→IR→emitted-ID intent classification, source annotations on every node, or broad rewiring of browser suites, stop and resize that expanded work to Opus 5.5 medium (review/verifier xhigh). It is not licensed by recommendation 1A.

## Exact allowlist / Touches

### Gates-owned runtime/tooling edits

1. `src/shared/breakpoints.ts` **only comments and LINT_WIDTHS/CORPUS_WIDTHS testing constants at :38–41**. This is the single narrow source-path exception; production breakpoint values/functions are read-only.
2. `test/browser/geometry.ts` (new, complete self-contained in-page measurement plus Page wrapper; ≤~200 lines).
3. `test/browser/lint.ts` **imports and runLint :255–259 only**: accept optional `GeometryProbes`, preserve old findings, append scoped geometry findings. Existing `lintInPage` remains read-only absent a reviewed need.
4. `tools/snap.ts`: pageOptions reuse at :54, per-width observation/report at :84–102, final receipt/exit. Preserve pictures, side pairing, request order, HTML bytes and motion policy.

### Gates-owned tests

5. `test/unit/breakpoints.test.ts`: add explicit coverage-array test; existing breakpoint/media/key tests unchanged.
6. `test/browser/geometry.test.ts` (new): controlled row/native/background/clipped/reachable/intentional cases, positive visibility/cardinality and mutation assertions. It exercises actual `runLint`, not a detached private checker.
7. `test/browser/snap-fonts.test.ts` (new): actual-CLI missing/failed/complete/mixed-width controls, deterministic local probe font. Read back the saved exact receipt and original output artifacts.
8. `test/browser/lint.test.ts`: **regression execution only**, no edits currently required. Its :40–42 default hidden-content clean assertion remains valid. If the proposed implementation breaks it, fix the scope rather than weakening that test.
9. `test/browser/snap.test.ts`: regression execution only. Existing :29–43 pins stand-ins and section pairing, not font-success admission; preserve it.

### Records (builder/finisher only, not planner)

- `docs/plans/2026-10-22-found-gates.md`, `docs/plans/found-gates-ledger.md`, `docs/HANDOFF.md`.
- Finisher only: `src/shared/build.ts`, rebuilt ignored dist, canonical found ledger entries whose exact scope is verified; dispatcher owns shared assignment sheet/board.
- Pending proposal only: `/Users/justin/.hermes/plans/figma-to-bricks/found-gates-claude-md-pending.md`; no write to main/copy CLAUDE.md.

### Explicitly read-only

`tools/lib/corpus.ts`, `tools/corpus.ts`, `tools/v1.ts`, `test/browser/fonts.ts`, `render.ts`, `chrome.ts`, `shoot.ts`, .3 font/render/showcase tests, every `src/core/**`, font assets/stand-ins, corpus input/config/baseline data, root debug JSON, siblings' fixtures and browser/unit tests. No baseline rewrite on main. If a required behavior cannot be delivered within this allowlist, stop with exact requested additional files.

## Consumer tracing and precise sibling overlaps

| Surface | Existing consumer / old assertion | Owner and sequence |
|---|---|---|
| Coverage arrays | `tools/lib/corpus.ts:132`; `tools/snap.ts:68`; `test/browser/lint.test.ts:29`; `tools/v1.ts:46` indirectly via runCorpus | Gates owns constants. v1 receives the extra width on a future explicitly authorized recapture, not an automatic baseline write now. Re-running only against an old baseline does not compare 1280: see validation below. |
| Lint public entry | corpus :143, snap :95, `composition-clipping.test.ts:88`, `designs.test.ts:31`, `convert.test.ts:112`, marquee suite | Gates changes only backward-compatible optional argument. Layout consumes opt-in geometry; tiles may consume it. Default results unchanged. All callers rerun. |
| `test/browser/composition-clipping.test.ts` | :39–70 measure only row overflow/text positions/card geometry; :79–82 intentionally restrict fit to <=991; :116–139 **pins whole-row margin percentages on laptops**, the old behavior being fixed | **found-layout owns this exact test file** and `test/fixtures/inferred-row-nudges.ts`. Gates must not edit it. Parent must give layout permission to replace only that old-share test with stronger real geometry tests. Retain design exactness :101–114 and nondefective tiers. Layout imports `GeometryProbes` or calls new third argument after gates helper lands. |
| `test/browser/fixed-tiles.test.ts` | :27–32 font-bearing load; :34–52 geo/kept/safe measures width/height/row bounds; :55–61 narrow list omits laptop interior points | Layout owns laptop-shrink portion; **tiles also needs this exact file for icon/hug/empty-box cases**. This is a real layout↔tiles file collision, not merely similar filenames. Dispatcher assigns one writer/sequences layout before tiles. Gates does not edit either fixture or test. |
| `test/browser/layout-floors.test.ts` | :30–35 font-bearing load; :37–41 geometry; :91–98 shape ratio | Potential layout↔tiles collision if either changes these controls. Neither is gates-owned. Require actual diffs before parallel execution. |
| .3 font helpers / corpus comparator | `fonts.ts:30–37`, requested families `render.ts:226–227`; corpus `:149,169–186`; actual CLI `corpus-cli.test.ts` | Reuse unchanged. No corpus diagnostic duplication. Snap is gates' new caller. |
| Other network-font browser consumers | `pill-holder.test.ts:18`, `clipped-pills.test.ts:19,25`, `narrow-buttons.test.ts:44`, `peer-sides.test.ts:26`, `equal-cards.test.ts:34`, `one-line.test.ts:35,57`, `text-link-followups.test.ts:43`, plus fixed-tiles/layout-floors above | Searches show no expected/loaded guards in these files. This is **an audit finding, not proof each is currently missing a font**. Layout/tiles should assert `fontStatus(...requestedFontFamilies(pageOptions))` before their newly changed font-sensitive geometry. Gates does not absorb wholesale migration of these suites. |

**Safest order:** dispatcher approves the narrow ownership above → gates implements/merges helper and 1280/snap tooling first, subject to independent review and font release hold → layout consumes helper and changes its exact old assertions → tiles rebases and changes shared tests. Contacts can be independent. A layout builder may start from current main without gates only if it uses a local probe in its owned tests and the dispatcher records whether subsequent helper adoption is wanted; it cannot invent another shared helper writer. Do not let a missing tool release block bounded layout diagnosis. Expensive Chrome/corpus runs must be staggered irrespective of disjoint source ownership. Shared HANDOFF/BUILD/pending files serialize at merge under the lock.

Sibling plan files did not yet exist during this planner's inspection. The table is verified from current files, not a claim their final plans agreed. Dispatcher must reconcile actual final Touches and diffs before launching builds.

## Ordered implementation tasks (not executed)

### Task 0 — admission, baseline and ownership (5–10 minutes plus corpus wait)

- Confirm recommendations 1A/2A/3A and exact test ownership with dispatcher. Verify current main/dirty debug, disk, live writer diffs and capture slot. No new package/dependency.
- Create only `worktree-found-gates` using the project skill after admission; never edit main. Explicit workdir on every command.
- Before edits save full original reports, logs, five pastes and complete HTML with source SHA/capture policy. Preserve stale root generated reports as historical if inspected; do not claim their optional missing expected fields describe current .3 source.
- Baseline check/browser/corpus per project. Record real exit codes and exact known v1 identities plus Garamond non-comparability. Do not call exit 1 a regression solely by its value.
- Capture no bulk screenshots beyond existing necessary gates; coordinate corpus and performance time with other workers. No full repository archive with 8 GiB free.

### Task 1 — pin and add default 1280 (2–5 minutes editing + focused gate)

Add this complete test to `test/unit/breakpoints.test.ts`; extend its import with LINT_WIDTHS/CORPUS_WIDTHS:

```typescript
test("tool coverage retains the original widths and includes an interior laptop", () => {
  assert.deepEqual(LINT_WIDTHS, [390, 768, 1024, 1280, 1440]);
  assert.deepEqual(CORPUS_WIDTHS, [390, 768, 1024, 1280, 1440, 1920]);
});
```

RED command: `node --test test/unit/breakpoints.test.ts`; intended failure is array equality (1280 absent), not setup. Then change only the two testing-constant lines/comments; same command GREEN. Fixture geometry tests also visit 1366/1300/1280/1200/1100/1024/992 and 991/800/768/600/480/479/390/375/360/320. No reset of phone tiers.

Mutation: process-local omission of 1280 must fail this assertion; restored test must pass. Commit explicit constants/test files only.

### Task 2 — generic geometry controls first (5–15 minutes split into row then picture slices)

New `test/browser/geometry.test.ts` uses the existing Chrome before/after pattern from lint.test.ts. It has a local HTML fixture (body margin 0, 1200-wide hidden section, row x=50 width=1100, 80×80 locally embedded SVG picture). Labels are arbitrary generic selectors, never actual project IDs.

**Row RED test body** (inside a real test with the existing Page initialized):

```typescript
const markup = (left: number) => `<!doctype html><style>
body{margin:0}section{width:1200px;height:100px;overflow:hidden}
#row{position:relative;margin:0 50px;width:1100px;height:80px}
#last{position:absolute;left:${left - 50}px;width:80px;height:80px;background:red}
</style><section><div id="row"><div id="last"></div></div></section>`;
await page.setViewport(1200);
await page.setContent(markup(800));
const probes = { rows: [{ box: "#row", last: "#last", expectedGap: 0 }] };
// During initial Node RED execution the extra argument is intentionally ignored
// by the old implementation; do not import a not-yet-existing module to get RED.
const found = await runLint(page, 1200, probes);
assert.deepEqual(found.filter(f => f.check === "row-right-edge").map(f => f.el), ["#row"]);
```

Run `node --test test/browser/geometry.test.ts`. The old runtime ignores the extra argument, so assertion sees `[]` and fails for the actual blindness. A transient TypeScript arity error is not the proof; the direct Node assertion is. Add the new geometry module and optional runLint argument only after this observed failure. Build the implementation to the exact contract in Architecture; do not export unrelated helpers.

Row controls: aligned left=1070 produces no finding, packed left=800 produces a 270px delta, overrun left=1170 produces −100px trailing gap. Border/padding content edge control, signed gap !=0 control, fractional tolerance below/above 1px, missing/duplicate/hidden target rejection and wrong-parent rejection. Repeat a width-relative fixture at the full matrix without screenshots. Do not infer a row is broken just because it is naturally left-aligned.

**Picture next RED:** same fixture, native inline-data SVG at left=1170, declared `{ pictures:[{ target:"#picture", clip:"#section" }] }`. Assert exactly `picture-clipped` on #section with lost right extent 50px. Repeat CSS background box, fully off-edge target, nested declared clip, vertical loss, unchanged image width/height, object-fit:cover that fills an intact frame and no loss. Add actual screenshot pixel/hit confirmation on the tiny fixture proving the image paints red inside and section background outside; never equate unchanged image/frame dimensions with clipping proof.

Negative controls: intentional crop **without a fit contract** remains the old clean result; reachable scroll-track content receives no picture-clipped finding, and a real scrollLeft change brings it into view; the same track viewport outside the section is not exempt. Keep the existing hidden-overflow default lint test unchanged. Unsupported geometry rejects explicitly.

Focused GREEN: `node --test test/browser/geometry.test.ts test/browser/lint.test.ts`. Mutations must independently defeat row detection (return no row findings), picture detection (return no picture findings), cardinality validation (missing target silently skipped), and scroll reachability exemption (wrongly calls reachable art clipped). Preserve raw failure receipts and restore without touching shared source on main. Use process-local hooks or an isolated tiny scratch module copy, not tracked on-disk mutants; final restored suite green.

### Task 3 — snap caller font admission (5–15 minutes split by missing/complete/multi-width)

New `test/browser/snap-fonts.test.ts` executes actual `tools/snap.ts` in a child, as existing snap.test.ts does. Each test has tiny synthetic input/output under TMPDIR. Reuse local probe-font technique in fonts.test.ts; if using a load hook, change **only the stylesheet transport/returned font CSS**, never fontStatus, expected list, diagnostics, persistence or exit logic.

Test table:

| Case | Expected status | Expected receipt |
|---|---|---|
| Visible Absent Probe + omitted/404 stylesheet | 1 | failed `[]`, missing `[Absent Probe]`, expectation retained |
| Visible Empty Probe + empty 200 stylesheet | 1 | missing, not falsely observed failed |
| Broken font resource | 1 | actual observed failed plus missing |
| Complete locally loaded Probe family | 0 | expected matches loaded using existing Unicode semantics |
| Two widths, first incomplete then complete | 1 | BOTH width receipts remain; later success cannot erase first failure |
| Empty requested family list | 0 | no invented expectations |

Initial RED command: `node --test test/browser/snap-fonts.test.ts`; current snap returns 0 and no report for missing stylesheet. The recorded planner CLI probe is the pre-existing direct reproduction. Ensure assertion failure is the missing receipt/admission, not a fake-font import/setup error.

Minimal changes in `tools/snap.ts`:

- Import `fontStatus` and `FontStatus` from existing fonts helper, `requestedFontFamilies`/`PageOptions` from render, and `CAPTURE_POLICY` from shoot.
- Replace the inline render options literal with one typed pageOptions object used by both renderPage and requestedFontFamilies; do not re-sort requests or rewrite HTML.
- Define a per-width report map with fonts/full lint findings (and captured height if available), plus `capturePolicy: CAPTURE_POLICY`. After each setContent/settle, observe fonts for that exact document. Save artifacts as before. Print exact missing/failed names with “non-comparable”. Accumulate any bad state; do not stop the later widths or overwrite earlier receipts.
- After the loop save `snap-report.json`; exit 1 if any receipt has failed or missing families. Existing lint-only exit behavior is otherwise unchanged. Keep finally cleanup. No external font retry.

GREEN: `node --test test/browser/snap-fonts.test.ts test/browser/snap.test.ts test/browser/fonts.test.ts`. Mutant removing observation must fail missing-style test; mutant checking only failed must fail the `failed:[]` case; mutant overwriting bad state with last width must fail mixed-width test; complete control remains 0. Output pastes/HTML/sides remain byte-identical for matching input, existing stand-ins and options. Only diagnostic JSON/stdout/exit semantics are intentionally added.

### Task 4 — consumer adoption handoff / complete gates (5–10 minutes + scheduled suites)

- Give layout/tiles the actual committed helper interface; dispatcher records exact ownership. Their newly edited font-sensitive load helpers must observe expected/loaded sets before measuring. Tests that intentionally use no web fonts should say so; do not inject a stand-in into real files.
- Gates itself changes no sibling test. Do not close the right-edge regression as a converter fix. Gates may close its tooling portion only once its generic positive/negative controls are proven and the agreed owning consumer uses it; if adoption waits, record the exact remaining integration as partial, not fully fixed.
- Run `npm run check`, `npm run test:browser` and `npm run corpus` in the gates worktree, preserve full outputs. `check` does not include browser tests. Compare matching baseline/final output kinds; replay and corpus use different picture policies.
- Original old-width captures remain. For the new **1280** width, obtain a same-base, same-policy **pre-feature capture** from original saved complete HTML, not from stableJson-reparsed pastes; the latter can reorder CSS. Run lint with the new helper but **no geometry contracts** on BOTH old and new identical HTML, and compare complete findings/heights/font sets at 1280. Label it a **coverage-expanded matched-policy baseline**, not the original baseline. Existing v1 baseline lacks 1280, so regressions' baseline-width traversal alone cannot establish “no worse at 1280”. Do not edit corpus/baseline.json merely to manufacture a comparison.
- Full report comparison includes every finding identity/multiplicity, warning/error counts, section/page scores, heights, unknown settings, capture policy, observed loaded and expected/missing sets. Retain both missing-font originals, do not call matched missing fonts comparable. Report true unresolved Garamond separately, not as numerical regression or green font coverage. No newly missing Yellowtail accepted. No score/performance/tolerance relaxation.
- Reviewer is separate fresh **Sol 6.1 high**, runs required gates/mutations independently. Output-changing corrections require fresh re-review. If a mandatory-loop skill is loaded, follow ready-for-verify/fresh verifier protocol.

## Validation matrix / acceptance

| Requirement | Layer / exact proof | Status at planning handoff |
|---|---|---|
| Laptop default 1280, existing widths retained | breakpoint array unit assertion; real corpus/snap reports enumerate measured widths; all required PNG targets exist | Current gap reproduced; implementation not run |
| Actual row geometry, not CSS percentage | runLint optional probes + generic aligned/left-packed/overrun twins; sibling intended-edge assertions | Current blindness reproduced |
| Native/CSS-background picture clipping | tiny paint/hit proof + lost-extent finding; full-offscreen and vertical twins | Current blindness reproduced |
| Intentional crop/scroller preservation | default lint old test unchanged; declared reachable scroll with actual scroll operation | Original negative control observed; new checker not built |
| Corpus .3 correctness | existing corpus tests/actual CLI fixtures retained; direct missing/complete reconciliation | Existing implementation confirmed, no new fix |
| Snap absent stylesheet with failed:[] | real child CLI exit/report, controlled transport only | Current exit0/no diagnostic reproduced |
| No converter/HTML change | complete payload/HTML byte comparisons for same options/input, baseline/final complete reports | Future gate, not claimed |
| Full laptop/phone fixture matrix | 1366/1300/1280/1200/1100/1024/992/991/800/768/600/480/479/390/375/360/320 | Planner synthetic index measured; sibling real-font proof still owed |
| Physical font completeness | exact expected/loaded observations on each capture; no narrowing/substitution | **Garamond UNVERIFIED; release hold unless separately resolved/decided** |
| Installed Bricks/live site | not applicable to pure tooling output; retain existing user paste checks | No live sign-off claimed |

## Release and stop conditions

- No implementation by this planner. Builder may proceed within accepted recommendations/ownership; missing-font policy blocks release, not read-only diagnosis or tests.
- No wider automatic lint intent classifier, new dependency, production layout/font loading change, W-B/grid/ALONE policy change, stand-in, expectation removal, or protected-file retry.
- If a scoped probe flags intentional art, fix the contract/eligibility against positive controls; do not whitelist actual IDs in the generic checker. If intended geometry cannot be specified independently, return held scope instead of a green assertion derived from observed output.
- If fonts or Splide assets are absent, preserve the first run, verify source and repeat unchanged only after a specific transient condition is distinguished. No unbounded network retries; no green report by dropping missing content.
- Before merge rebase on actual current main, generate same-base before/after proof and rerun check/browser/corpus. Acquire completed merge lock (not just background startup), verify exact tested tip, ff-only merge. Never touch user's debug JSON or another branch's untracked output. Recheck source identity if main moves.
- Corpus/font exit 1 remains **blocked/non-comparable**, not a fully green final gate. Prior M1A was release-specific; dispatcher must resolve any new release hold explicitly. Do not infer a waiver from autonomous recommendations.

## Other things found / not absorbed

- **Low, tooling audit:** several font-sensitive browser-suite load helpers pass requested fonts but do not assert expected/loaded completeness; exact callers are in the overlap table. Source audit establishes missing guards, not a demonstrated current network failure. Newly changed layout/tiles consumers should adopt guards under their owners; untouched suites are a separate follow-up, not broad gates scope.
- **Evidence hygiene, not a converter defect:** root `corpus/report-v2.json` observed during planning has legacy optional font fields and GRO loaded Inter/Montserrat, not a .3 capture receipt. Generated files are stale relative to code. Preserve it, but use newly run source-bound reports for acceptance; never patch its fonts to match assumptions.
- No new production defect proposed. Repeated laptop/picture findings are already owned by layout; no duplicate ledger entry requested. Global phone rollout, loader duplication, Garamond and all unrelated deferred findings remain open.

## Docs & records — final task

1. Builder copies this plan to `docs/plans/2026-10-22-found-gates.md`, starts scoped progress ledger, then moves final ledger to `docs/plans/found-gates-ledger.md` with exact source SHAs, command exits, failed/complete receipts, mutations, ownership/adoption state and original versus expanded-policy comparisons. Do not rewrite existing evidence.
2. Update `docs/HANDOFF.md`: 1280 coverage; contract-scoped geometry (not a universal design-intent detector); snap report/exit semantics; exact unresolved/partial items; Garamond **UNVERIFIED**; W-B held. No user paste check is owed by tooling-only output. Retain all existing checks. If scope later changes to converter output, obtain revised scope and allocate the **next free paste-check number on main at merge**, never a guessed fixed number.
3. Finisher alone bumps `src/shared/build.ts`, rebuilds bundles and commits/pushes after release gates/independent review/any required verification and completed merge lock. Verify main/origin/remote and exact dist artifacts before claiming release. No speculative cleanup; preserve evidence and source identity before worktree removal.
4. Dispatcher/finisher closes only the **verified tooling portions** of the exact canonical findings after merge. The old Yellowtail corpus diagnostic row is already fixed in .3; do not claim a second fix. Geometry consumer adoption incomplete means partial closure with owner, not full closure. Global narrow-phone and physical-font issues remain open.
5. **CLAUDE pending proposals only**, after older pending entries in build order, retaining all earlier files: new Start here entry should say “found-gates: default captures include 1280; explicit geometry probes check declared row/picture expectations; snap records each width's expected/loaded/missing fonts and fails non-comparable captures after saving evidence. No converter or font policy change; Garamond remains UNVERIFIED.” Add a Debugging tools paragraph naming `snap-report.json` and nonzero missing-font behavior, and an explicit caution that intentional cropped art requires a scoped contract rather than global failure. Record exact finished BUILD/check/source/evidence values only once real. **No attempt to patch CLAUDE.md**, no retry through parent/tool/agent, no renaming prior pending files as applied.
