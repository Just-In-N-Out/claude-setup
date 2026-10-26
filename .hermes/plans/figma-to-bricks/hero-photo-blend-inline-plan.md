# hero-photo-blend — route 1B same-document SVG plan

**2026-10-21 · PLANNER / investigation only · NOT IMPLEMENTATION APPROVAL**

## Questions / next safe choices

1. **What may proceed next?**
   - **A) Queue exact-install proof; keep code held. ⭐**
   - B) Approve the expanded build, only after all proof gates.
   - C) Defer multiple shadows; preserve the held R1 branch.
2. **Where can installed acceptance be proved?**
   - **A) User-run disposable test on the exact target. ⭐**
   - B) Legitimate local copy with an already usable runtime.
   - C) Hold until either environment is available.
3. **If 1B is separately approved, its routing?**
   - **A) Opus 5.5 xhigh build/review/finish. ⭐**
   - B) Keep Justin's earlier Sol 6.1 xhigh override.

The recommended answers authorize **proof planning/collection only**, not a worktree/source change or a site write. Queue any request until Justin returns; no immediate away-mode action is needed. A later explicit **1B implementation go** must name this expanded source scope. The away-mode recommended-plan authority and earlier “1A / 2 just figure it out” do not waive that boundary. The old explicit Sol override is not silently revoked: Opus is the recommendation for this newly larger capability, pending the dispatcher's/user's routing decision.

## Outcome / status

**Conditionally feasible at the browser-transport level; BLOCKED for implementation/release.** A legitimate existing Code/HTML mechanism can carry definitions without JavaScript, but the exact installed Bricks acceptance, paste-ID rewriting, responsive region/cost contract, full colour fidelity, and all converter paths are not proved. The bounded research stops here; no further speculative probe loop is authorized by this document.

- **Route 1A remains rejected:** actual Safari 26.5 omitted intended shadows for percent/base64 data-URI and same-origin external SVG filters. Keep `hero-photo-blend.md` and `hero-photo-blend-compatibility.md` intact; this plan does not relabel 1B as approved 1A.
- **Route 1B candidate:** a non-layout Code carrier adjacent to each affected picture, with same-document SVG definitions and its own element-specific CSS. Keep the filter ID and every reference inside that carrier's own settings so the historically observed self-ID rewrite can keep them together. This is a **2.4.1-style rewrite hypothesis**, not an installed 2.3.9 guarantee.
- **No implementation performed.** No repo/worktree/source edits, builds, commits, dependency installs, account access, site writes, uploads, signing, execution-enable changes, CSP changes or permission changes.
- Investigation loaded `figma-to-bricks` PLANNER, `feature-dispatch`, `systematic-debugging`, and the current rendering-validation reference. Read main Start here/relevant rules, memory, HANDOFF, samples, IR/style/emit seams and prior proofs. Main observed `9f9b751`, committed BUILD `2026-10-21.19`; Start here's `.12` is stale. Hero remains `46c17a58bbb7d7959f7ffba06038e07f27b876b8`, tracked clean, with its existing untracked `.superpowers/` preserved.

## Playback / preserved decisions

1. Picture shadows must follow the picture's alpha, not draw a rectangular frame.
2. H1B means **each shadow starts from the same original alpha**. A chain that invents a shadow at summed offsets is not equivalent.
3. Preserve R1's Figma/box-shadow blur radius ÷ 2 standard deviation, including fractional radii. Preserve the drawn faint border, opacity/bake handling, existing spread/inner warned fallback, and source-media behaviour.
4. Preserve the approved **fixed colour snapshots for multiple shadows**, even though inline SVG might support palette variables. Zero/single-shadow palette behaviour stays unchanged. A changed multi-shadow colour needs reconversion/re-paste; no covert live-palette upgrade or shared palette resource.
5. No H1A box-shadow fallback, chained-drop-shadow approximation, dropped shadow, new JavaScript, asset preprocessing or new upload may be substituted without another decision. The pale source-image fringe remains separate.

## Evidence and root cause

### Existing source and controls

- Held hero source `src/core/style/picture-shadow.ts:18–20` reverses shadows into sequential `drop-shadow()` functions. Held `style/paint.ts:218–232` selects the chain and describes only darkness. The real extra silhouette is established by `evidence/hero-photo-blend-fixpass/result.json` and `multi-shadow-regression.mjs`: intended offsets `(70,0)` and `(0,70)` also paint their sum; phantom RGB92 instead of white255. Unit `test/unit/style-picture-shadow.test.ts:78–82` pins the obsolete chain order and must be allowed to change, while R1 assertions remain.
- The previous compatibility manifest was independently hash-checked in this investigation: **295 recorded files, zero mismatches**. Its 164 captures retain actual Chrome155/Safari26.5 provenance. Same-document controls paint both intended black shadows51 and phantom255 in both browsers; data/external failures are versioned observations, not a universal WebKit claim.
- Existing Code shape: `reference/bricks/code-element.json:1`, version **2.4.1**, `name: "code"`, `settings.code`, `executeCode: true`. Do not copy the sample's signature, user ID or time. `reference/bricks/README.md:216–231` explains provenance and signing, and records a later site version than the project's 2.3.9 target. Neither historical statement verifies today's exact installed build.
- Existing HTML emission precedent: `src/core/emit/maps.ts:12–19` emits reviewed HTML in `code` with `executeCode: true`; `emit/elements.ts:85–91` adds the Code settings. HANDOFF:2543–2558 records a real `div.brxe-code` wrapper. This supports choosing an existing mechanism, not this SVG's save/sanitization acceptance.
- `test/fixtures/bricks-paste.ts:20–29` and README:69–79 model **2.4.1**, not 2.3.9: only an element's own serialized JSON is rewritten for its own new ID. A filter defined in one element but referenced by another element's old ID will go stale. `test/browser/render.ts:174–175` inserts Code HTML without checking Bricks signatures: renderer success cannot prove installed acceptance.
- Current public official **Code schema2.4.3** was fetched successfully and saved in scratch: `settings.code` string, `executeCode` boolean, `_cssCustom` string; wrapper metadata `div`, non-nestable. Do not guess fields such as `renderWithoutWrapper` (the newer schema's actual key is `noRoot`, which this proposal does not need). The public **HTML schema2.4.3** documents `name: "html"`, `settings.html` string, but no copied local HTML-element sample or exact-target acceptance establishes its SVG retention/security contract. It is a documented alternative requiring its own proof, **not** an automatic unsigned workaround.

### New bounded local carrier experiment

Scratch root: `/Users/justin/.hermes/cache/scratch/hero-h1b-inline-plan/`.

`carrier-probe.mjs` uses the legitimate Code element envelope with the sample signature omitted, and generates synthetic local HTML for the proposed wrapper/CSS. It simulates the documented 2.4.1 own-JSON rewrite with two distinct generated IDs, not a Bricks installation. The HTML contains no script element or SVG script/event handler. Browser automation is test tooling only. Both local loopback servers and disposable Chrome/Safari sessions were closed.

Tight loop:

```sh
node /Users/justin/.hermes/cache/scratch/hero-h1b-inline-plan/carrier-probe.mjs
node /Users/justin/.hermes/cache/scratch/hero-h1b-inline-plan/object-region-followup.mjs
```

**Both commands exited 1; neither is a blanket green gate.** Their raw JSON, exact HTML/CSS and screenshots are preserved separately. Total **24 captures**, 12/run, six per browser/run. Width is390 in Chrome and1000 in the Safari top-level window: this probe is not the320/390/1440 responsive gate.

1. **Initial fixed-region run:** two200×200 pictures at different page y positions, distinct black/red snapshot graphs, img/background modes, inline/external stylesheet. Chrome's four positives and two stale-reference negatives behave as expected. In Safari the first picture and black shadows render, but the second picture/source disappears under the fixed user-space region; stale-reference controls retain source pixels. This is a new **scratch carrier/bounds failure**, not a newly shipped plugin bug or evidence against all same-document SVG.
2. **One-variable follow-up:** change only region coordinates from user-space fixed bounds to objectBoundingBox bounds `-0.75/-0.75/2.5/2.5`, preserving user-space primitives. In Safari the second source and both intended coloured shadows return, with phantom white; the same result appears with external CSS. This isolates the observed disappearance to the region-coordinate choice for this fixture. It does **not** prove a general region or responsive contract.
3. **Still red:** the colour assertion assumes Chrome-like literal red RGB255/51/51. Safari records238/92/79, while its source orange also differs from Chrome (242/169/59 versus255/165/0). Colour management is a plausible explanation, **not proved**. Do not widen tolerance or declare colour fidelity green: obtain same-browser unfiltered/alpha colour controls and, where necessary, colour-profile-normalized comparison in a separately approved proof pass. Both stale-reference mutations correctly remove intended shadows while retaining white phantom, demonstrating why phantom-only tests are invalid.
4. Every captured page reports zero document scripts, zero-size carriers and four distinct IDs after the simulated rewrite. This demonstrates local non-layout/ID mechanics only; it does not establish no layout side effects in Bricks flex/grid/selectors/editor, true duplicate-paste IDs, components, templates, source substitution, zoom or video.

## Recommended carrier design — conditional, not an emitter implementation

### Minimal supported structure

Use the existing **Code** shape unless an exact-target HTML proof establishes a smaller supported mechanism. For each supported multi-shadow picture, plan a definitions carrier immediately before it in the **same emitted parent**. Carrier content is generated `<svg><defs><filter>…</filter></defs></svg>` only. Retain the Code wrapper; do not invent HTML/SVG settings or enable wrapper-free output. Absolutely positioned zero-size carrier is the locally exercised candidate; it must contribute no flow item, gap, hit target, focus stop, accessibility name or scroll extent. Do not reuse the script node's `display:none` behaviour without an actual Safari proof.

The carrier owns both:
- a filter ID whose namespace embeds **its own deterministic Bricks element ID**, and
- the sole final filter rule in its own `_cssCustom`, using its own `#brxe-ID` plus an adjacency/descendant suffix to reach the immediately following target/actual picture part.

Thus all occurrences that need a paste-time rewrite live in the **same element's settings**. Do not put a reference to this ID into the target's separately serialized settings, use global classes to hold it, or depend on another element's ID. Adjacent selectors and actual wrapper/part mapping must be proved for Image/figure/link wrappers, background Div, showcase pseudo-element and Video/poster. A Code node inserted elsewhere by Bricks would break this contract; exact installed DOM is a gate.

### Pipeline / ID / composition contract

- **Understand plans topology before style/adapt/emit.** Prefer a typed `PageIR` resource-descriptor list (`carrierKey`, `targetKey`, parent/target-part relationship) planned after phone/list/hover copies. It is not a new fake Figma layer or a layout child in PageFacts. Emitter expands the already planned child-ID sequence with the carrier before its target; it does not mutate earlier IR or discover structure from CSS strings. No new scene/extract/asset capability.
- Style records typed physical offsets, sigma, finite RGBA snapshot, layer-blur and target-part information. The serializer runs once in emit. Keep zero/single shadow CSS byte-identical to R1. There must not be an old chain plus a second conflicting filter declaration; the final resource rule composes existing layer blur and the independent graph in the existing order.
- Canonical branches each consume original unshadowed alpha after the existing layer-blur boundary; blur at radius/2, offset, flood and mask independently. Merge reversed Figma paint order; original SourceGraphic last; explicit sRGB interpolation. Preserve overlap alpha, original picture opacity, bake flags and intentional source stroke. Baked SVG does not get its shadows again; rendered sources do not get their baked opacity/blur twice.
- Same conversion produces byte-identical payloads. Two identical pastes require **actual Bricks-generated unique carrier IDs**, with HTML filter IDs and all references remapped together. Two different revisions of one picture must not cross-use old definitions. Distinct pages are distinct documents, but header/footer/templates/components/repeated content can coexist in one document and need explicit tests.
- No global deduplication/reusable defs in this first route: it increases cross-element rewriting and palette-scope risk. Repeating the same approved numeric graph per carrier is acceptable only within a measured size/cost budget. Do not use random/time IDs or a run nonce to hide deterministic collisions. Test raw substring rewrite against serializer keywords/values too; if the allocator cannot avoid a corrupting collision without broader ID changes, stop for a revised scope rather than silently changing `emit/ids.ts`.
- Only allowlisted tags/attributes/primitives and validated finite numeric/RGBA values are serialized. No raw layer names/SVG, PHP opening tokens, Bricks dynamic-data expressions, JS, script/event attributes, foreignObject, feImage, href/URL inputs or external resources in definitions. Canonical HTML/XML/CSS escaping is mandatory. No `javascriptCode`, copied signature/user/time, auto-signing constant or signing bypass.

### Security and installed acceptance gate — unresolved

Official Custom Code documentation requires existing execution settings/capability and valid signatures for executable PHP/HTML; JavaScript-free Code content is not exempt. **This investigation changed none of those settings and signed nothing.** Later proof can use only an environment where those capabilities/workflows are already available. If they are not, stop; do not tell an agent to enable them or switch to another element to evade policy.

The earlier read-only frontend GETs observed only `Content-Security-Policy: upgrade-insecure-requests`; that does not cover authenticated builder policy, SVG retention or every page. No installed PHP/local WordPress runtime/package was found in the prior scoped discovery. Newer schema2.4.3 and user sample2.4.1 do not prove the required2.3.9 acceptance. A copied-back version/current installation must be recorded, not assumed from stale docs.

**Smallest later proof:** on an explicitly authorized disposable draft/test environment at the exact target version, the user imports/pastes two carriers with their img/background targets, reviews only the new HTML, uses the site's existing ordinary signing workflow for those Code entries if required, saves, copies back, and returns copied JSON plus the saved preview and compiled CSS. Repeat-paste once in that same document with a distinct snapshot colour. Confirm all generated SVG primitives/IDs/fragment references survived, the compiled CSS and saved DOM have matching remaps, the intended shadows and source render in Chrome and actual Safari, and no cross-colour binding occurs. Signatures may be verified as valid without publishing their secret value. Do not log in, save, sign, regenerate site-wide signatures, upload or publish automatically. If only a different/newer version is available, label its evidence and keep2.3.9 compatibility open.

## Responsive bounds, layout and cost gates

A fixed scene-coordinate region is not safe merely because one picture at the top of the page works: the new local Safari failure establishes this directly. A normalized region for a declared minimum picture size is only a candidate, not a magic percentage.

Before production edits, state and prove the allowed physical picture minimum/maximum across all supported responsive paths, the per-branch positive/negative offset/blur envelope and layer-blur contribution. Pictures shrinking together explicitly have `widthMin:0` in current `style/picture.ts:45–51`; therefore a global positive24×18 minimum from the old experiment cannot be assumed. Zero/collapsed boxes and arbitrarily small nonzero pictures need a decision if no generally bounded mechanism covers them. Do not silently clamp layout or hide/fallback shadows.

Measure same-document rendered-shadow controls against an expanded reference at320/390/1440 and actual1728/1920 design/wide bounds, multiple page positions, landscape/portrait, resizing both ways, fractional dimensions, zoom and1.1 showcase transition, negative/large offsets and transparent/opaque rounded sources. Require both source and intended shadows present before any pixel-equality result counts. Retain original failed measurements and separate labelled re-captures. Gaussian support needs a declared raster tolerance, not a claim of finite mathematical support.

Calculate region area/bytes/intermediate count with a tool, including DPR/zoom, and separately measure warmed frame/paint/load cost for many simultaneous pictures and a video. Navigation/wait/screenshot wall time is not GPU cost. No arbitrary `-50%/200%`, fixed500px, unsupported SVG `calc()` assumption, unbounded region or broadened layout floor. If bounds require breakpoint writes, **only `adapt/rules/` may write them**; existing proposal excludes those edits and must return for expanded approval.

## Exact proposed source scope / ownership

**This list is a proposed future allowlist, not permission now.** Main lacks R1's new helper: use held hero history and rebase only under subsequent approval.

| Files | Narrow purpose |
|---|---|
| `src/core/understand/ir.ts`, `understand/understand.ts`, new `understand/picture-resources.ts` | Typed page-level carrier/target relationship, planned after copies; no layout-child pollution. |
| `src/core/style/picture-shadow.ts` (held branch), `style/paint.ts`, `style/types.ts` | Retain R1; replace supported multi chain with typed independent-filter data; preserve snapshots and single path. |
| `src/core/style/picture.ts`, `style/behaviours.ts` | Only where needed to carry baked/actual target-part/zoom information without changing existing behaviour. |
| `src/core/emit/elements.ts`, new `emit/picture-filters.ts`, `emit/css.ts` | Assign planned carrier IDs, expand reciprocal parent/child emission, canonical SVG and self-owned final CSS; no cross-element stale ID reference. |
| `reference/bricks/code-schema.json` + provenance note (future archive) | Archive public2.4.3 authority separately from the original copied2.4.1 sample; record exact-target proof distinctly. |
| Existing `test/unit/style-picture-shadow.test.ts`, directly affected `style.test.ts`; new `understand-picture-resources.test.ts`, `emit-picture-filters.test.ts`; existing `emit-paste-ids.test.ts` | Replace obsolete multi-chain assertions only; add stronger independent/scope/remap/security tests. |
| Existing `test/browser/picture-shadow.test.ts`, `picture-shadow-blur.test.ts`; new `picture-shadow-multiple.test.ts` + generic fixture | Real conversion/assets/rendered alpha and all target/zoom/video modes; preserve opaque-photo fixture provenance. |

`style/style.ts`, `emit/ids.ts`, `emit/settings.ts`, `emit/payload.ts`, all adapt/layout/rule/shared breakpoint files, assets/uploads/panel/extract/normalise and renderer are **not automatically writable**. If the typed integration or final target parts cannot be implemented within the listed narrow seams, stop with the precise extra file/rationale; do not retrofit the renderer to manufacture Bricks support. In particular, inspect `style/behaviours.ts` after pill-clip rather than claiming its unknown final shape is already solved.

**Overlap:** pill-clip currently owns `style/paint.ts`, `style/types.ts`, `style/behaviours.ts`, `style/style.ts` and adapt/layout/least/rules/shapes. Wait for that merge (or a written disjoint ownership grant), then refresh the1B scope and same-base evidence. Do not edit its worktree. Other parallel features share records; preserve their HANDOFF sections and take the next free paste-check number at release. Recheck actual diffs before dispatch, not just these historical ownership notes.

**Sizing:** new typed topology/resource planning + style contract + emitter/signature/ID compatibility is a **big capability**, not a1–3-file bug. Recommend Opus5.5 xhigh with a separate fresh Opus reviewer; existing feature-specific Sol override requires explicit reconciliation, not automatic substitution or implementation on this investigating Sol agent.

## Future tasks — bounded and gated (13 steps)

1. **Approval / ownership:** obtain explicit1B scope/routing approval; keep all source held meanwhile. Reconcile pill-clip ownership and preserve R1/old evidence.
2. **Exact-install proof first:** obtain the narrowly authorized environment/proof described above; archive actual copied-back version, generated markup, compiled CSS, policy and Safari/Chrome result. Missing source/runtime/capability remains a stop, not an install or permission request performed by an agent.
3. **Local feasibility closure:** in scratch, finish same-browser colour controls, moved-position/scroll/duplicate/reordered carriers, external stylesheet/base-URL cases and exact saved wrapper mapping. Preserve both current red runs. Stop if no safe self-remap strategy survives.
4. **Bounds/cost decision:** establish the actual min/max support domain and budget, including0/tiny pictures. If not general without new responsive/layout policy, return choices; no code yet and no arbitrary fallback.
5. **Baseline:** only after gates pass, load TDD and create/reuse the approved feature worktree without reset. Save full check/browser/corpus/HTML/font/lint baselines and untouched-source before shots at required widths. Do not rebuild the main folder for investigation.
6. **RED:** add generic actual-converter phantom regression plus resource-plan/no-layout/reciprocal-tree tests. Cover0/1/2/3+ shadows, inner/spread/baked states, two copies/revisions/pages and zero/single payload identity. Update only the old chain expectation; demonstrate known-red on46c17a5.
7. **GREEN structural transport:** plan typed resources before emit, serialize generated-only definitions and self-owned rules using source-evidenced Code controls. No JS/new dependencies/permission/security policy. Test injection/nonfinite values/determinism, malformed resources, duplicate IDs and substring rewrite. Stop on extra scope.
8. **All target paths:** exercise `convert → fillAssets → renderPage` with real cut-out and opaque rounded media in WP img, embedded background, both showcase modes, bake/vector and video/poster paths. Preserve source URLs/MIME/cache/media counts, radius, alpha, opacity, layer blur, links and stacking. Renderer is only local output evidence.
9. **Adversarial browser proof:** actual Safari and Chrome at320/390/1440/design/wide widths, moved y positions, resize/zoom, ancestor clips, transition and reduced motion. Use pixels/elementFromPoint for clipping. Require source + intended shadows + white phantom; compare colour/merge order to same-browser controls. Measure region/cost, not screenshot wall time.
10. **Mutation/gates:** restore old chain, full sigma, broken self-remap, clipped region and missing intended shadows separately; each dedicated test must fail. Restore immediately. Run check/browser/no-worse corpus; preserve complete reports/HTML/fonts and same-base before/after pairs. No v1 worsening or unexplained layout/target/link change.
11. **Fresh independent review / test-first finish:** dispatcher launches the approved fresh reviewer with all R1+1B diff and raw failed/corrected evidence; no builder self-review. Verify valid findings test-first, refresh exact emitted proofs; new product/security/browser trade-offs hold release.
12. **Release only after all gates:** rebase after shared ownership resolves; repeat integrated gates/evidence, completed merge-lock acquisition, ff-only merge, read/bump BUILD, SES build/commit/push/verify main=origin and dist under the normal finisher rules. No automatic release from planning approval or partial local feasibility.
13. **Docs & records:** complete the items below as the final build/finish task.

## Other things found / explicit uncertainties

- **Known1A incompatibility, not a new plugin bug:** Safari26.5 external/data-filter omission remains recorded separately in the old plan/report.
- **New candidate-only risk:** fixed user-space carrier bounds can make a second moved picture disappear in Safari. Object-bounding follow-up restores source/shadows for this fixture; general support still open. Do not file this as a shipped regression.
- **Unresolved local colour check:** second snapshot red differs in Safari screenshots; colour management is a hypothesis. Neither local run is green acceptance.
- **Existing evidence gaps:** no actual Remanufactured debug export; the Repairs sister design/grey corpus stand-ins do not prove exact-page fidelity. Source pale fringe and rounded antialias residual are not solved here.
- **Records/version gap:** main CLAUDE Start here is stale; sample2.4.1/schema2.4.3/target2.3.9 are distinct. Do not silently upgrade compatibility claims from any of them.
- Public extraction/search tooling was unavailable or empty in this session; direct public official GETs succeeded for the Code/HTML schemas and Code documentation. The attempted HTML documentation URL did not yield usable element-specific guidance, so its sanitization/security behaviour remains unknown. No private Bricks/PHP source was fetched.

## Evidence / reproducibility inventory

- Prior decision/report: `/Users/justin/.hermes/plans/figma-to-bricks/hero-photo-blend.md`, `hero-photo-blend-compatibility.md` — unchanged.
- Prior verified raw artifacts: `/Users/justin/.hermes/cache/scratch/hero-h1b-compat/manifest.json`, `browser-results.json`, `safari-followup.json`, `renders/` —295 hashes verified, unchanged.
- New artifacts: `/Users/justin/.hermes/cache/scratch/hero-h1b-inline-plan/carrier-probe.mjs`, `carrier-results.json`, `renders/`; one-variable `object-region-followup.mjs`, generated `object-region/carrier-probe.mjs`, raw `carrier-results.json`, stdout/stderr and `renders/`; schemas/docs with HTTP headers; `manifest.json`. Scratch is idle-pruned, not a permanent archive; authorized archival is still needed before release/cleanup.
- Primary authorities (read-only public documents; newer versions do not establish installed acceptance):
  - Code documentation: `https://academy.bricksbuilder.io/builder/features/custom-code/`
  - Code schema2.4.3: `https://academy.bricksbuilder.io/schema-resolved/elements/code.json`
  - HTML schema2.4.3: `https://academy.bricksbuilder.io/schema-resolved/elements/html.json`
  - Filter Effects primitives/regions: `https://www.w3.org/TR/filter-effects-1/` (prior fetched copy retained in compatibility scratch).

## Docs & records — final task (only after later implementation approval)

- Copy **this separate plan** to `docs/plans/2026-10-21-hero-photo-blend-inline-plan.md`; preserve approved1A history and rejection evidence, not overwrite them.
- Continue/preserve R1's ledger and create the1B gate ledger; finish at `docs/plans/2026-10-21-hero-photo-blend-inline-ledger.md` with source/base, approvals, exact versioned installation evidence, failures, RED/GREEN/mutations, measured bounds/cost, review outcomes and artifact manifests.
- Update `docs/HANDOFF.md` “Picture shadows that follow the picture” with1A unsupported-browser fact distinct from1B proof, snapshot exception, signing dependency and the next-free paste check owed. Do not say local render equals installed save acceptance.
- Authorized finisher only: bump `src/shared/build.ts`, build/commit/push, verify actual release; update main `CLAUDE.md` Start here and Where things stand after merge. Reconcile stale/pending edits; if protected writes are denied, preserve exact pending edits and never retry/bypass through another tool/agent. Do not edit a worktree's CLAUDE snapshot.
- Record verified transport/region/remap lessons in rendering-validation/project rules, retaining version/provenance and no-universal-support wording. Archive originals and final-source proofs separately before cleanup under an authorized path.
- After release only: reload Figma plugin → Convert/copy → re-paste/save affected pages → review/sign only new Code content with the site's existing permitted workflow, if needed → LiteSpeed Purge All → reply **pasted + page name**. GET-only checker verifies saved source/intended shadows/no phantom, exact filter references, geometry/links and clipping at all required widths. No enable-permission, unsigned-execution or agent-site-write instruction is implied.
