# Fixed tiles shrinking on tablets — fixed-tile-shrink

Planner: Hermes, 2026-10-21. **Plan only; no repository source/test edits, worktree, commits, build, merge or live writes.** Autonomous bounded-pipeline authorization: `briefs/autonomous-round4-planners.md:3–7,12–13`. Parent reviews this plan before dispatching builder → independent reviewer → test-first finisher.

## Playback and outcome
1. Preserve a compact fixed-both-ways tile's drawn geometry when its row has room, rather than squeezing its width but releasing its drawn height.
2. Fix the generic structure, not a 64px literal, label, ID, page or colour. Preserve existing grid/ALONE decisions, ordinary fluid cards, photo aspect rules and button semantics.
3. Canonical open finding: `~/.hermes/plans/figma-to-bricks/found-else.md:159`. The earlier grow problem at line 96 is already fixed and must not be reopened or claimed again.

**Routing reassessment: in-between, Opus 5.5 medium builder/finisher; independent Opus xhigh reviewer.** Initial small Sol-high routing is insufficient: the confirmed cause crosses shared row allocation and the existing height/floor rule. This is not permission to replace the layout engine, change grid/ALONE policy, or run the deferred wrapped-parent least experiment. Parent must explicitly record this bounded reassessment before build.

## Verified base and boundaries
- Main `5e32aec`, BUILD `2026-10-21.22`, main equals origin/main; only the user's root debug JSON is modified. `CLAUDE.md` still advertises .12: stale/protected pending updates must not be bypassed.
- Mutable root debug read-only metadata: build `2026-10-20.6`, root `Hydraulic Cylinder Repairs Final` (`553:7604`), drawn1728×3948.97998046875. It is Repairs, not the synthetic twoShare fixture; do not conflate them. Corpus manifest lists design/final-design/page-1/hydraulics/gro; the seventh-file matrix means those five plus separately discovered Repairs and Services inputs, not a guessed corpus member.
- Relevant prior work: equal-card-fixes R2; layout-floors Addendum A1a (grow reset); pill-clip P1A/P2A plus F1; reverted wrapped-parent least (`6ad2841` / present main history `a15423c`). See `docs/plans/2026-10-21-layout-floors.md:235–257`, its ledger:65–69, and `docs/plans/2026-10-21-pill-clip-ledger.md:35–41`.
- Active diffs read only: hero owns `style/paint.ts`, `picture.ts`, `picture-shadow.ts`; media owns `ui/site-media.ts`, `site-pages.ts`; phone currently has records/tests only, and reserves contacts/card-title/page-words/page-links. None is owned here. Renderer/font proof helpers remain untouched.

## Executed reproduction / diagnosis
Read canonical original `/Users/justin/.hermes/cache/scratch/ecf-review/probe2.ts:55–85`; reran it against exact current main:

`node /Users/justin/.hermes/cache/scratch/ecf-review/probe2.ts /Users/justin/Documents/FigmaToBricksV2 fixed-tile-main22`

Actual output file `/Users/justin/.hermes/cache/scratch/ecf-review/probe-fixed-tile-main22.json`:
- design1200: tile **64×64**;
- viewport990: **59.0×62.6**;
- viewport768: **51.9×62.6**;
- viewport600: **64×62.6** (old 272px grow is gone).
No rule collisions. This is a generic reviewer fixture, not an identified real-page tile. Do not invent a real-page match.

Read-only stage/CSS probe (no production mutation):
`node /Users/justin/.hermes/cache/scratch/fixed-tile-shrink-planner/probe.ts`
Saved script and full `probe.json` in that directory. Durable originals copied with SHA-256 manifest to `~/.hermes/plans/figma-to-bricks/evidence/fixed-tile-shrink/planner-main22/` (`probe.ts`, `probe.json`, `canonical-original-probe2.ts`, `canonical-main22.json`, `manifest.json`); do not overwrite these historical .22 captures. Programmatic verification: four fixtures,112 captures,28 width+height injected controls all match their own drawn dimensions exactly and show no parent/document overflow. The assertion was against source-main .22; no converter fix was injected. Reproduces fixed 64×64, 48×48, 80×56 and 56×80 boxes. Canonical IR is a flowing `box`, width/height both `fixed`; normalisation infers a one-label column. Base has width64, minWidth50, minHeight64, flexGrow1. Tablet plan: room/width50, least50, row `keep`; landscape room211.5/width64, row `two`; portrait room343/width64, row `stack`.

Ranked hypotheses and falsification:
1. **Horizontal CSS is allowed to shrink below drawn width**: width-only injection restores 64px at990/768, without overflow; confirmed.
2. **The short planned width releases height for every narrower tier**: height-only injection restores64 tall but leaves59/51.9 wide; confirmed. Width-only still leaves62.6 tall; both minima restore64×64.
3. Padding scale alone is causal: rejected as primary cause; both minima restore drawn dimensions with original padding unchanged. It still explains content-driven residual height once the drawn floor has gone.
4. Old two-per-row grow reset missing: rejected on current main, width64 at600 and emitted grow0 at landscape.

Generic injections at990/768/320 restore each of the four drawn width/height pairs without measured parent/document overflow. These are **CSS causal probes, not implemented converter fixes**. All-size/tier matrix and stage traces are in `probe.json`. An independent assertion against the measured base was executed and exited1 as expected: `canonical tile @990: expected64x64, got59.03125x62.59375`; the tight loop is RED for the exact geometry symptom, not a crash.

**Classification caution:** canonical tile is also `buttonLike` to the current least helper. Do not exclude all `buttonLike` boxes or it disappears from the fix. Native Button roles remain excluded by the box predicate. Compact fixed box-shaped pills can structurally overlap: test them explicitly and document any eligible geometry correction rather than promising every button-like box is byte-identical. Unrelated hug/fill/native CTA behavior must remain unchanged.

### Exact causal path
- `src/core/style/sizing.ts:218–234`: fixed one-label frame gets its label-room floor, not drawn shape width; `fillsItsRow` also gives grow1. Ordinary fixed row boxes deliberately shrink (`:229–232`); do not reverse this globally.
- `src/core/adapt/least.ts:124–144`: button/label minima measure words+sides. `shapes.ts:96–97` `firmAt` only reserves that button floor; no compact fixed-shape reservation. `layout.ts:94–105` uses that held result to allocate a kept row. Hence canonical64 is planned at50 on tablets.
- `src/core/adapt/rules/unpin.ts:70–77`: correctly retains fixed-both-ways height only while planned width remains drawn width. Because plan says50, it emits `_heightMin:tablet_portrait=0`. Cascading keeps the release even when the landscape/portrait plan returns to64; current rule does not reassert drawn height there.
- `unpin.ts:85–99` protects button words, not the structural tile. Payload keeps minWidth50 on tablet, so actual browser widths differ with real viewport (59.03125 and51.875).
- `rows.ts:13–22` already recognizes compact boxes as things not to widen, using existing `BADGE_MAX=96`; `:118–120` already resets grow for two-share. That policy is the bounded precedent, not evidence for a new literal64 branch.

## Bounded correction / ruling
Recommend **extend the existing row compact-item preservation, not generic fixed-box rigidity**:
- Extract/share the existing compact-box bound from `rows.ts` into one adapt helper, with a separate narrowly typed predicate for a flowing, fixed-width AND fixed-height compact `box` that is a direct row item. Reuse the established 96-bound; no new threshold, square-only check or page key. Keep the old `widens` classification equivalent for every pre-existing case (do not silently require fixed sizing in its old exclusion).
- Tablet and narrower only: reserve that eligible item's drawn width during kept-row allocation and emit a matching parent-capped width floor. Make `size.unpin` see the truthful plan, so its existing drawn-height protection remains effective. Keep `grow0` behavior for broken rows; test sufficient-room kept rows for unwanted growth before choosing any additional reset.
- Do not change `least(..., buttons)` semantics globally: it feeds grid and ALONE. The structural hold belongs in row-specific firmness. Do not count all wrapping descendants as one line or alter grid/ALONE constants/branches.
- Keep desktop/fluid behavior as today. If extending `firmAt`, explicitly exclude `fluid` for this new compact hold unless a separately proven same-scope emitter change is approved. Do not lie to laptop `holdLaptop` about a floor CSS does not emit.
- The width floor must cap to the **actual parent**, not the 375px plan sample. Where a nested parent cannot contain the drawn tile, retain the existing safe shrinking/content fallback; no new aspect-ratio/scale-down policy. Do not assert shape preservation where it cannot fit. Builder must prove no overflow at375/360/320 and precise tiny-parent boundary. If the floor cannot be made consistent with that fallback within the owned files, stop for parent scope review rather than introducing a new engine.
- Noncompact boxes, fill/hug sizing, grid cells, sections/containers, placed/free compositions, photos and ordinary CTA pills retain existing handling. Linked tile/pill metadata and paint/clipping remain unchanged.

**Builder prerequisite:** write/read a short final predicate + tier/CSS contract in the ledger, then one vertical RED→GREEN. The exact helper name may follow local naming, but its semantics and callers must be explicit. If root-cause correction requires changing `decideRow`, `gridColumns`, `own/ownCSS`, `least` recursion or global floor policy, do not broaden silently: stop with RED and request parent reassessment.

## Exact ownership and scheduling
**Proposed production allowlist (no blanket adapt directory ownership):**
- `src/core/adapt/kinds.ts`: one compact-row-item helper / shared old compact bound.
- `src/core/adapt/shapes.ts`: only row-specific `firmAt`/hold integration; preserve ALONE/grid/row-choice algorithms. Changes to a row's selected shape outside the new eligible scope require investigation and parent review.
- `src/core/adapt/rules/unpin.ts`: matching bounded floor and fixed-height preservation at responsive tiers; no photo/placed/unrelated-width policy edits.
- `src/core/adapt/rules/rows.ts`: consume extracted old compact predicate/bound without changing old widens semantics; existing grow reset retained. Additional kept-row grow reset only if its own RED and scoped contract prove it necessary.
**Conditional, not automatically granted:** `layout.ts` and `least.ts`. Read-only under this design. If builder proves a needed edit, parent must revise the exact allowlist before it happens; likewise `adapt/types.ts`, `style/types.ts`, style sizing and any new rule/registration are not owned.

**Owned tests:** new `test/fixtures/fixed-tiles.ts`, `test/unit/adapt-fixed-tiles.test.ts`, `test/browser/fixed-tiles.test.ts`; existing `test/unit/adapt-reflow-grow.test.ts`, `test/unit/adapt-heights.test.ts`, `test/unit/adapt-unpin.test.ts` may receive only directly contradictory compact-tile cases with stronger behavior assertions. Existing `test/browser/layout-floors.test.ts` is a read-only regression gate; do not expand the shared file. `test/unit/style-layout.test.ts:48–56` pins general fixed-box shrinking and remains unchanged/read-only. Generic builders, renderer/font/capture helpers, `adapt-least*.test.ts`, layout test suites are read-only unless parent grants a named assertion exception.

**Sibling responsive-pill-planning** also researches `shapes.ts/firmAt/hold`, `least.ts`, `layout.ts`, `sides.ts`, `adapt/types.ts` and layout fixtures/tests. **GRO** may need row allocation or `unpin.ts`; parent must reconcile its allowlist. Planners remain parallel read-only. Recommended serial implementation: this bounded compact-item fix first, merge/verify, then responsive/GRO rebase/reproduce against that main before source edits. If parent chooses another order, replan current line references and redo exact-main RED/baselines; no simultaneous builders editing any of kinds/shapes/rows/unpin. Shared HANDOFF/found-else allocation serialized at integration. Dedicated fixed-tiles fixture/tests belong only to this batch; siblings consume read-only controls.

## TDD tasks (vertical slices; tests before each change)
### 0. Fresh base and baseline
After parent routing/ownership acceptance, create own worktree per skill. Verify actual main/build and active diffs, copy required ignored inputs; run pre-edit check and full corpus once. Preserve original full reports/logs, payloads AND insertion-order HTML before any converter edit; mark reconstructed or matched-policy recaptures honestly. Read mutable debug build/root metadata; scratch-copy only. Take generic/current-debug before shots via snap, explicit comma-separated widths; verify images exist. Do not run whole corpus during planning.

### 1. Canonical tablet reservation and height, one end-to-end slice
Build the canonical structure in `fixed-tiles.ts`, with independently parameterized tile width/height and placement, label, peer widths, gap and nesting. First unit assertions: normalized/IR fixed-both sizing; parent row keep on tablet, two landscape, stack portrait; plan reserves drawn64 not50; output floor matches draw/actual-parent cap, and height64 is not released when width64 fits. Browser RED on990/768 must compare exact width AND height (tolerance≤1px), not a ratio-only/rounded near-square assertion. Also measure peer bounds, overlap, parent/page horizontal spill. Run RED against clean base, implement minimal shared hold+writer, run GREEN. Desktop1200 and original600 grow behavior are required controls.

### 2. Generic eligibility boundaries and positive/negative twins
Add one RED→GREEN at a time where behavior is missing:
- varied squares and non-square fixed shapes (48×48,64×64,80×56,56×80; plus values just below/at/above existing compact bound); vary names/text/colors without changing policy;
- automatic/inferred flow and explicit auto-layout equivalent; empty/icon-only/short-label compact shapes where supported; a radius is not required, square is not required;
- noncompact fixed200×80 row box must still shrink; widthFill/heightHug controls must not become rigid; normal CTA/word+arrow and photo-painted controls preserve behavior;
- same eligible-looking box placed absolute or inside a grid must stay unaffected; columns must not become globally floored;
- direct/nested row parent with enough room, tiny parent narrower than tile, and cap boundary ±1px; actual375/360/320. Where narrower than drawn, assert safe fallback/no new page scroll, not impossible64px preservation;
- roomy tablet kept row, two-share and stacked rows must neither widen nor vertically stretch compact fixed items accidentally. Preserve old grow0 regression.

### 3. Test sensitivity / meaningful mutations
Use isolated copies for mutants, never leave tracked source mutated. Record each expected killing assertion and restore verified source before gates:
- restore old row firmness only: plan-width and990/768 browser tests fail;
- omit matching width floor only: browser width fails even if plan unit stays green;
- force old height release / bypass compact protection only: height assertion fails while width remains correct;
- broaden predicate to every fixed frame or drop fixed-height requirement: noncompact/hug twins fail;
- remove real-parent cap: deliberately tiny nested-parent and320 spill check fails;
- remove old two-share grow0: retained600 regression fails;
- restore exact original changed-source set on the final test tree: original canonical regression fails; positive controls still pass. Do not claim an unexercised/identical mutant killed.

### 4. All-width real/debug and corpus acceptance
Focused browser sweeps: design1200 plus1440/1024/992/991/990/900/800/768/767/766/600/480/479/478/390/375/360/320, exact cap/cliff ±1 and retained design widths. Compare before/after payload changed IDs programmatically; render every changed element and its peer/ancestor chain at paste's actual width (not only frame width). All seven existing real files (five corpus plus Repairs/Services) and scratch-copied current debug need same-base matched-font/motion comparisons. Use source-backed corpus font policy without changing renderer/helpers or acquiring missing fonts; absent expected fonts means non-comparable, not matched.

Require no new full lint finding identity/multiplicity, page widening, clipped labels, photo/circle distortion, changed ALONE/grid columns, or regressions in unrelated subtree geometry. If eligible real tiles improve, list each measured change; if none change, say synthetic canonical fixed and real-page outputs unchanged, rather than fabricating user-page evidence. Preserve original/final reports/pastes/HTML and exact comparison scripts. Corpus exit1 may be baseline v1 differences: compare identities, complete lint/fonts/heights/section scores, not just counts/exit code. Snap before/after sides for generic990/768 and phone320 plus every real affected section. Save selected shots under `~/.hermes/plans/figma-to-bricks/shots/fixed-tile-shrink/`.

### 5. Separate review, test-first fix pass, integration
Builder returns committed ready-for-review only: check/corpus green relative to same base; separate browser suite explicitly run. Parent fresh independent reviewer gets merge-base diff, exact plan, positive controls/mutation records and evidence. Finisher verifies findings before narrow test-first fixes. After rebase rerun check, browser and full corpus/matched changed-node measurements against fresh same base; preserve earlier captures. Respect three-builder cap and stagger Chrome/font-heavy gates. Merge lock, ff-only, build/dist/push/exact target readback per project skill; no live writes.

## Closure criteria
Only after verified merge/push may parent close canonical found-else:159. Must demonstrate canonical64×64 at990/768 AND preserve width64/no grow at600, prove varied-size/aspect controls, real-parent safety375/360/320, no grid/ALONE changes, and no unrelated corpus regression. CSS injections alone do not close it. Earlier grow line96 stays historically closed. Do not claim laptop/fluid fixed-size preservation or global phone-width coverage beyond this scope.

## Docs & records (final task)
- Copy approved plan to `docs/plans/2026-10-21-fixed-tile-shrink.md`; keep TDD/evidence ledger in `.superpowers/sdd/fixed-tile-shrink/progress.md`, then move to `docs/plans/2026-10-21-fixed-tile-shrink-ledger.md`.
- Update HANDOFF with actual outcome, exact predicates/tiers, model reassessment, deferred limits and next-free paste check allocated against actual main; preserve parallel records.
- Close only proven canonical found-else row after verified merge; record any distinct new issue separately and deduplicate.
- Finisher bumps BUILD/rebuilds dist under merge lock, verifies branch/main/origin and push/readback; no planner/builder BUILD change.
- Main CLAUDE Start here/Where things stand updated by finisher in pending build order through permitted path. Existing denied edits are never retried or bypassed; write precise new pending file if blocked. Add rule: compact fixed row geometry is reserved consistently by plan and emitted responsive floor, with actual-parent fallback, without global fixed/grid policy changes. Update compact rules summary only if that rule lands.
- Preserve/hash manifest evidence and before/after paths before worktree cleanup. Installed-Bricks paste check remains owed: reproduce at990/768, narrowed nested375/360/320, save/preview; local renderer is not installed Bricks proof. If existing user designs contain no matching tile, parent must state that rather than naming a fictitious affected page.


## Dispatcher record (2026-10-21 22:32 EDT, Justin away; his rule: take the recommended answer)
F3 ruling (non-button compact tile + 210px paragraph + 900px column goes two-per-row on tablets, tiles keep drawn size; main crushed the tile to 20–36px) — ACCEPTED as the recommended option under Justin's away rule. Show him f3-main/branch-{990,768,600}.png from evidence/fixed-tile-shrink/rereviewer-opus/ in the morning; one word reverts it.
