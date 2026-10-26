# hero-photo-blend — H1B independent picture shadows (revised 2026-10-21)

## Dispatcher update — Justin's answers (2026-10-21)
- **1A approved:** snapshot colours for multiple shadows at conversion; single-shadow palette behaviour unchanged.
- **Question 2: "just figure it out"** — investigate and automate compatibility/bounds proof locally and through read-only installed-site evidence where possible. Do not require Justin to perform a manual test as the first step. This is NOT permission to log in, save/publish/edit the site, upload files, relax CSP/signatures or skip the compatibility gate. If the installed roundtrip cannot be proved autonomously, report exactly what remains unverified; do not call local Chrome proof installed-Bricks proof. No production source edits until proof/ownership gates resolved.

## Decisions and current gate — autonomous proof completed

**H1B and 1A are approved choices; compatibility has not passed.** Justin approved snapshotting only multiple-shadow colours and said **“2 just figure it out”**. This authorizes autonomous local/read-only investigation, not the historical 2A user-run paste choice, any live write, a build, or a waived gate.

- **1A — approved but presently blocked:** encoded SVG filter in existing custom CSS; multiple-shadow colours fixed per conversion, single-shadow palette behaviour unchanged. Actual Safari 26.5 fails to draw either intended shadow with this transport, while Chrome 155 passes. See the capability verdict below. Do not implement or ship the failing route.
- **1B — not approved:** a generated inline-definitions carrier has a passing local Chrome/Safari transport control, but adds structure, ID/signature/security/schema obligations. Any expanded source scope or permission requires a separate dispatcher/user decision and revised plan; this is not an automatic fallback.
- **Hold existing branch/R1** until the transport, installed acceptance, bounds and paint ownership gates pass. No manual 1A paste is owed as the first next step: it cannot repair the independently reproduced Safari failure.

If the transport is stripped, blocked by CSP, incompatible with a required browser, or requires expanded upload/code permissions, **stop and return the actual evidence and choices**. Never enable SVG uploads, relax CSP, turn on code execution, add a dependency, change browser coverage or switch to 1B silently.

## Playback, status and scope

1. The original cut-out picture's rectangular box shadow makes a visible square; picture shadows must follow their pixels.
2. Justin chose **H1B**: several shadows must each use the original picture alpha, not earlier shadows. No phantom at summed offsets; **H1A's multiple-shadow box fallback is not selected**.
3. Retain **R1 at `46c17a58bbb7d7959f7ffba06038e07f27b876b8`**: filter sigma = Figma/box-shadow blur radius ÷ 2. Retain the drawn faint border, current spread/inner warned fallback, and re-convert/re-paste policy.

**Routing:** explicit Justin override **Sol 6.1 (`gpt-6.1-sol`), xhigh** for remaining builder, a separate fresh reviewer, and finisher. Do not inherit the former Opus routing.

**Read-only discovery:** initial main `f2a4a42`, committed build `2026-10-21.18`; main `CLAUDE.md` Start here still says .12. At final verification another finisher had advanced main to `f6f6600` with card-link-words and a working-tree BUILD change to.19; the committed BUILD was still.18. **Do not call.19 released from this observation.** Refresh git/BUILD before the later build. Existing worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/hero-photo-blend`, branch `worktree-hero-photo-blend`, tip `46c17a5`, tracked clean with untracked `.superpowers/`. Reuse it and its evidence; **no reset, replacement worktree, or discarded R1**. No source/worktree/commit/build was changed by this planner.

Applies generically to the currently supported WordPress Image, inside-JSON picture/background Div, showcase photo and video picture paths. Do not expand picture-hover capabilities or solve source-image fringes. No condition on a page/layer name, ID, source filename, colour or example offset.

## Cause and evidence

- `src/core/style/picture-shadow.ts:18–20` at `46c17a5` reverses the shadow list and concatenates `drop-shadow()` calls. Each filter consumes the previous result; it therefore shadows earlier shadows too. `paint.ts:218–232` selects that path and emits a misleading “slightly darker” warning at line222. The old chain-order assertion is `test/unit/style-picture-shadow.test.ts:78–82`.
- The prior actual-converter repro is preserved in `evidence/hero-photo-blend-fixpass/multi-shadow-regression.mjs` (run `node --test --test-concurrency=1 <absolute-script-path>`). Its two 80%-black, zero-blur shadows at `(70,0)` and `(0,70)` produce RGB92 at the phantom location versus RGB255 for independent shadows, with 854 pixels differing by >2, in both picture modes. See that folder's `result.json` and `multi-shadow-red.log`; this known-red test has not yet joined the default suite.
- R1 is separately established: `evidence/hero-photo-blend-fixpass/result.json` reports outside-box max36 → max1 RGB and no pixels >2 after halving sigma. The existing opaque-photo fixture, fractional-radius, rounded-corner and cut-out regressions must remain. This is not whole-image identity: the curved antialias edge still has a recorded residual.
- New **transport-only scratch experiment**, not converter output and not a Bricks round trip: `evidence/hero-photo-blend-h1b/probe/results.json`, reproducible original script `feasibility.mjs` (writes only to its named scratch directory). Headless Chrome155 rendered both an inline SVG graph and the same graph in a CSS data URI correctly on `<img>` and CSS backgrounds: phantom RGB255; both intended shadow samples RGB51. The chain control produced RGB92 at the phantom. PNGs and exact HTML are saved beside the results.
- The extra palette experiment exposed a real trade-off: a host `--shadow-color:red` made inline definitions produce `[255,51,51,255]`, but the data-URI filter used its black fallback `[51,51,51,255]`. Therefore copying `ink.css()` into that separate resource does **not** preserve palette linkage. Source: `src/core/model/palette.ts:21–48`; 1A explicitly asks permission to snapshot only the multiple-shadow colours.
- Filter Effects documents independent SourceAlpha inputs, filter primitives, merge order, filter regions, colour space and standard-deviation blur; it does not prove Bricks/CSP/browser compatibility.[1] Bricks documents element-specific CSS and separately gates executable Code/SVG output behind execution capability and a valid signature.[2] Existing keys are evidenced by `reference/bricks/code-element.json` (sample version2.4.1) and `emit/maps.ts:18–19`; that sample is **not** an installed2.3.9 round-trip proof, nor approval to add a new SVG element setting.

Original live/alpha/Figma investigation remains at `evidence/hero-photo-blend/` and the prior plan/ledger in the worktree. The saved Repairs sister design establishes the pattern; the actual Remanufactured debug export is still absent. Do not re-label sister-design or grey stand-in evidence as exact-page fidelity.

## Ranked implementation choices

| Route | Fidelity/editability | Runtime and size | Compatibility/security evidence |
|---|---|---|---|
| **1A: SVG filter as CSS data URI** | Independent geometry in Chrome; approved multiple-shadow colour snapshots | O(shadows) primitives/encoded CSS; no extra bitmap or DOM element | Chrome155 img/background passes; **actual Safari26.5 img/background fails** (intended shadows absent). Observed frontend CSP is not blocking; installed paste/save/copy-back remains unproved. No new upload, JS or dependencies. |
| **1B: inline definitions, referenced by CSS** | Independent geometry; same-document palette variables have an earlier Chrome control | O(shadows), potentially reusable defs; extra structural carrier | Local Chrome155 and Safari26.5 transport controls pass. Added IR structure, signatures, duplicate-paste IDs and precise installed round trip still need a separate approved plan. No JavaScript is needed. |
| **Preprocessed shadow assets** | Static-image approximation/resolution choices; not a general solution for live video alpha | Extra generated pixels, bytes and likely assets/cache work | Would span extraction/panel/uploads, MIME/naming/ownership and possibly CORS/encoder policy. **Not selected or authorized**; ask separately before any extra upload. |

**Current recommendation: stop 1A implementation and return to the dispatcher for a revised transport decision.** Its required Safari gate failed. A narrowly scoped 1B investigation is the next proposal, not authorization; local same-document controls do not prove installed acceptance or authorize structural/signature changes.

## Autonomous capability verdict (2026-10-21)

Full report: `hero-photo-blend-compatibility.md`. Reproducible scratch scripts, raw results, HTML/PNGs, headers/CSS and manifest: `/Users/justin/.hermes/cache/scratch/hero-h1b-compat/` (idle-pruned, not a permanent archive). Actual156 browser captures plus8 top-level Safari retries: Chrome155 intended shadows51/phantom255; Safari26.5 data-URI intended shadows255 (absent), inline control51/phantom255. Base64 and same-origin external SVG also fail Safari top-level retries. Required Safari transport gate therefore **fails**, independently of Bricks acceptance. Observed installed frontend CSP is only `upgrade-insecure-requests`; Chrome's controlled CSP test confirms `img-src` can block a data filter but does not explain this Safari result.

Scoped local discovery found historical user exports/versioned schema, not an installed PHP package/local WordPress runtime. Public CSS contains no proposed filter URL. Save sanitization and compiled transport after an actual paste/save/copy-back remain **unproved**, not waived. Chrome bounded-region fixture comparisons pass at320/390/1440, including24×18 and1.1×scale; default regions fail. This establishes only the fixture's size envelope, not every responsive picture/video/showcase path or allocation/performance budget. Safari data-filter bounds comparisons are not valid evidence because the shadows never rendered.

**Minimal next step:** dispatcher decides whether to authorize a revised1B investigation/plan with explicit structural/schema/ID/security/bounds obligations. No automatic switch, site write, install, upload, policy relaxation or source edit. Coordinate after pill-clip's paint ownership; preserve46c17a5/R1. Main observed9f9b751/build2026-10-21.19, superseding the earlier historical discovery snapshot above.

## Composition contract for 1A (retained specification; implementation blocked)

- Leave zero/single-shadow paths unchanged, including R1 fractional `d.blur / 2`. For **2+ outer, zero-spread shadows only**, create one typed, deterministic graph; never concatenate independent `drop-shadow()` functions.
- Every shadow branch starts from the **same unshadowed alpha input**, blurs with its own radius/2, offsets it, floods with the typed colour/alpha and composites that colour through its own mask. Merge branches in the established reversed Figma paint order and merge SourceGraphic last. Set explicit sRGB filter interpolation; preserve alpha and overlapping coloured shadows.[1]
- Keep the existing layer-blur ordering: an unbaked layer's existing `blur(blurPx(...))` feeds the one independent graph; do not halve layer blur twice. Baked render assets already contain their layer blur/opacity/stroke, and baked SVG already contains shadows (`pictureBake`, `picture.ts:54`, `paint.ts:218,231,237`); do not add them again. Check live video alpha as well as its poster path.
- Keep one `filter` declaration and one `_cssCustom` per element. Preserve the existing target/wrapper, opacity, radii, overflow, clipping, picture sizing, hover zoom and reduced motion; no nested replacement picture or additional shadow-copy pseudo-element. Picture-shadow-changing hovers are currently declined (`style-picture-shadow.test.ts:97–113`); do not introduce them.
- Emit only generated, allowlisted filter primitives and finite typed numeric/RGBA values, canonical escaping/URI encoding and deterministic internal resource IDs. No pasted SVG text, layer labels, scripts, event attributes, `foreignObject`, `feImage`, external references or network fetches in the resource. Do not forward `var(...)` into 1A; use the explicitly approved colour snapshot. Do not change asset URLs/cache keys/MIME/media counts.
- **Bounds are an unresolved proof obligation, not a guessed default.** Determine a standards-supported region that encloses all branch offsets and blur support at actual responsive sizes without excessive offscreen surfaces; include negative/large offsets, tiny pictures, zoom and layer blur. Do not ship arbitrary `-50%/200%` padding, the probe's fixed500px region, or assume CSS `calc()` works in an SVG attribute. If correct responsive bounds require breakpoint CSS or shared style types, pause for expanded scope/ownership approval; only `adapt/rules/` may write breakpoints.
- Spread/inner/mixed unsupported shadow sets retain the already approved **existing** rectangular warning fallback. This is distinct from rejected H1A: ordinary 2+ outer zero-spread shadows must use the independent path, not the box fallback. Filled boxes remain unchanged.

## Tasks — test first (12 steps, approval then execution)

1. **Baseline.** Load project/TDD skills; re-check live git/parallel ownership. Reuse46c17a5 without reset. Save check/browser/corpus baseline, full report/payloads/HTML/fonts/findings and same-base before shots at320/390/1440 plus design widths; preserve all R1 evidence. Local commits only.
2. **Transport proof before source edits — autonomous investigation done, gate failed.** See `hero-photo-blend-compatibility.md` and scratch artifacts. Chrome155 passes; Safari26.5 fails percentage-encoded and base64 data filters, including top-level settled retries. GET-only installed-site evidence cannot establish paste/save/copy-back sanitization. Do not ask Justin for a manual 1A paste first or make a site write. Return the failing evidence and obtain a separately scoped transport decision; any new setting requires authoritative versioned schema/sample evidence, never guessed keys.
3. **Bounds feasibility gate — partial local evidence, still blocking.** Chrome scratch controls cover320/390/1440, positive/negative/large offsets, fractional sigma, coloured overlapping alpha, tiny24×18 pictures,2.5px layer blur and1.1× scale. Analytically bounded max-size and min-size-derived normalized regions match an expanded reference within1RGB, but only for the fixture's stated24×18–300×225 size envelope. Default bounds fail. General converter min/max dimensions, ancestor zoom/clipping, actual allocation/runtime and Safari rendered shadows are not proved. No arbitrary region, unsupported `calc()` assumption or new responsive/shared-type source expansion is authorized.
4. **RED, actual converter seam.** Move the existing phantom repro into the normal browser suite. Add generic 0/1/2/3+ cases, independent inputs/order, encoding/determinism/duplicate pastes, finite values, palette snapshot, no box shadow for supported multi, unchanged filled-box/spread/inner controls. Replace only obsolete unit lines78–82; save failure against46c17a5. Synthetic transport HTML is not emitted-output proof.
5. **GREEN.** Small typed SVG serializer/helper, selected from `picture-shadow.ts`/`paint.ts`; remove the misleading chain warning. No new dependency, DOM/asset type, upload/network policy, CSS parsing, random ID or earlier-stage mutation. Exceeding Touches requires approval.
6. **All paths.** Render real `convert → fillAssets → renderPage` output: WP img, embedded Div, both showcase modes, baked/vector and video/poster. Use real alpha media plus fixtures. Prove final asset substitution neither corrupts the URI nor uploads it. Retain R1 rounded opaque controls and the opacity-only state boundary.
7. **Pixels and mutations.** Require phantom white AND intended shadows present; check overlap colour/alpha/order, region cutoff, rectangle seam, layer-blur/filter order, sigma and opacity. Check actual showcase clipping pixels/elementFromPoint during zoom. Widths320/390/1440/1728/1920. Restore old chain and full sigma separately: each dedicated test must fail; restore immediately and retain RED/GREEN.
8. **Replay/corpus/after shots.** Scratch-copy the mutable debug, replay normal widths plus320; compare same-base payload fields, full lint/fonts/geometry and v1 identities. Save complete final reports/HTML and permanent before/after pairs, matching fonts/motion. Explain every changed picture; stand-ins are not alpha proof. No screenshots committed.
9. **Fresh Sol6.1 xhigh review.** Builder returns committed `ready-for-review`, not merged. Dispatcher starts an uninvolved reviewer with project + `requesting-code-review`, this plan/answers, merge-base diff including R1 and all proofs. Reviewer runs gates independently and attacks the above cases plus injection/URI escaping, duplicate IDs, CSP/Safari, video/zoom and cost. Review only; no self-review substitute.
10. **Test-first fix pass.** Sol6.1 xhigh finisher loads receiving-code-review/git/TDD skills, verifies findings and preserves R1. Refresh emitted proofs and independently re-review material transport/appearance corrections. Product/security/browser trade-offs return to Justin; absent installed/bounds proof or an unapproved fallback blocks release.
11. **Integrated release.** Coordinate/rebase against latest parallel work, retain R1, rerun check/browser/no-worse corpus and same-base visual proofs after layout changes. Follow project merge lock (completed acquisition), ff-only merge, actual BUILD read/bump, SES build/commit/push, main=origin/dist verification and lock release on every failure. Clean only this worktree after authorized success; take next-free paste-check, not3ap.
12. **Docs & records.** Complete the exact paths/actions below; report the remaining paste check and any blocked proof honestly.

## Touches / ownership

**Recommended 1A production allowlist:**
- Existing `src/core/style/picture-shadow.ts`, `src/core/style/paint.ts`; new small `src/core/style/picture-shadow-svg.ts` (or equivalently named single-purpose helper).
- `src/core/style/picture.ts` only if narrowly required to pass source/baked information; existing picture modes must otherwise remain unchanged.
- `test/unit/style-picture-shadow.test.ts` including the obsolete chain/stack assertion; `test/unit/style.test.ts` only directly affected expectations, with R1's half-radius assertions retained.
- New `test/browser/picture-shadow-multiple.test.ts` and generic multi-shadow fixture; narrowly extend `test/browser/picture-shadow.test.ts` for multi-path/zoom/video proof and `picture-shadow-blur.test.ts` only for stronger R1 coverage. Preserve `test/fixtures/opaque-photo.{png,md}` provenance.
- Docs/ledger/HANDOFF below. `src/shared/build.ts` only the authorized finisher on main.

**No pre-authorization** for extract/normalise/understand/IR/emit/payload/asset/uploader/embed/manifest/renderer/shared style types/adapt changes. A renderer modification cannot be used to fabricate integration support. 1B requires a separate revised allowlist for structural IR + emitter/schema/ID/security work.

**Current overlaps (read-only git comparison to main):**
- **pill-clip is a real conflict**, not just an adapt neighbour: it currently changes `style/paint.ts`, `style/types.ts`, `style/style.ts`, `style/behaviours.ts`, adapt layout/least/rules/shapes and label tests. Coordinate ownership of paint before either later build. Recommended H1B only after pill-clip's paint edits land, or a dispatcher-approved disjoint hunk allocation; never edit its layout/label/least/orchestrator work. Any responsive-bounds expansion is a fresh overlap decision.
- **card-link-words** currently changes normalise label-links/normalise and its tests, plus shared records; no recommended1A source overlap. Both docs sections/next-free check numbers must survive rebase. If a 1B topology is proposed, re-check linked-picture/card semantics before approval.
- **photo-hover-glass** is already included in hero's ancestry (`5568d94`, build.14); retained showcase zoom must still pass. PDFs have merged as main.18; do not repeat stale “may be building” descriptions.

## Risks and hard acceptance boundaries

- Browser-only transport proof ≠ installed Bricks round trip; primary docs ≠ installed-version support. No unconditional “Bricks-compatible” release claim until copied-back element, compiled CSS, saved frontend and required browsers pass.
- 1A deliberately snapshots multiple-shadow colours; it must be explicitly approved and documented, never disguised as palette preservation. All other palette uses and single shadows stay linked as before.
- Correct primitives can still clip large/blurred/zoomed shadows or create expensive surfaces. Bounds/cost proof is blocking; arbitrary percentages are not a general fix.
- Filters create stacking contexts. Preserve z order, opacity, source-alpha semantics after existing layer blur and intentional ancestor clipping. The existing soft-cutout “show behind” approximation is not broadened or declared solved.
- No other architectural/security/upload trade-off is silently approved. No new SVG/media upload, remote write, external resource, code execution or security-policy relaxation is part of1A.

## Other things found / not folded in

- **Existing visual follow-up:** source cut-out has a pale partially-transparent fringe; source versus AVIF cause remains unproved. Do not fix it here.
- **Existing evidence gap:** actual Remanufactured debug export is missing; sister Repairs/stand-ins are not exact-page Figma evidence.
- **Existing validation limit:** R1's rounded antialias band has a recorded whole-image residual; its outside-box max1 result was not whole-image identity.
- **Records issue:** main `CLAUDE.md` Start here is stale(.12 versus actual.18). Finisher must reconcile newer applied/pending documentation rather than overwrite it with the old status. No CLAUDE edits made here.
- **Scoped finding:** external SVG data-URI filters do not inherit host palette variables in the measured Chrome probe. Justin explicitly approved multiple-shadow colour snapshots via1A; single-shadow palette behaviour remains unchanged. This resolves the colour choice, not the failed Safari gate.

## Justin's answers / preserved history

- Original **go** accepted A1 (picture shadows follow pixels), B1 (keep the faint Figma frame) and C1 (re-convert/re-paste, then LiteSpeed Purge All).
- **H1B**, verbatim: “H1B”. Parent clarification: multiple shadows independently, revised implementation/build and another fresh review; no H1A box fallback. Preserve R1 at46c17a5.
- Explicit remaining-pipeline override: **Sol6.1 xhigh**, reviewer and finisher included.
- **2026-10-21 answers:** “1A / 2 just figure it out”. 1A colour snapshot approved; question2 is autonomous proof investigation, not historical2A and not live-write/build permission. Safari failure now requires a new transport decision, not a repeated request for those answered choices.

## Docs & records — final task

- Copy this approved revision to `docs/plans/2026-10-21-hero-photo-blend.md`; preserve earlier approvals, R1 history and the original screenshots' provenance in the ledger.
- Continue `.superpowers/sdd/hero-photo-blend/progress.md`; move/merge the completed ledger into `docs/plans/2026-10-21-hero-photo-blend-ledger.md`, including new answers, RED/GREEN/mutations, transport/browser/version proof, size/performance, report paths and fresh-review/fix outcomes.
- Update `docs/HANDOFF.md` “Picture shadows that follow the picture”; take the next free paste-check number on main at merge time. State any colour-snapshot exception and the remaining user paste check accurately.
- Finisher reads/bump `src/shared/build.ts` only at authorized merge, rebuilds dist and verifies release. Main `CLAUDE.md` Start here and Where things stand updated after merge with both new shadow rules and current state; no copy's CLAUDE edits. Respect denied protected writes and preserve exact pending edits without retry/bypass.
- Add the confirmed rule to project docs/rules summary: single-shadow sigma radius/2; independent original-alpha multi composition; no chained-shadow approximation; supported transport and explicit palette/policy limits. Update `references/rendering-validation.md` only with verified lessons, not universal support claims.
- Final user steps after release: reload plugin → Convert/copy → re-paste affected page and save → LiteSpeed Purge All → reply **pasted + page name**. Signing is **not** a1A requirement; if1B is later approved, its plan must include signatures explicitly. Checker GET-only verifies saved actual media and no phantom at320/390/1440 and actual design widths, plus intended shadow/zoom/clipping/opacity; no automatic site changes.

## Sources

[1] https://www.w3.org/TR/filter-effects-1
[2] https://academy.bricksbuilder.io/builder/features/custom-code


## Justin's answer (2026-10-21 ~20:40 EDT): option 2 — ship the will-change fix anyway
Justin's words: "You know what, just like ship the fix anyway, it's fine."
Accepted known limitations, to be written in HANDOFF/plan as accepted by Justin: on iOS 18.6 the picture shadow outside the box can be lost intermittently (10 of 22 captures on the cut-out cylinder page), and a picture's shadow paints over a later white caption (F2). No z-index/position rule added. Release still needs a fresh Opus xhigh review and a finisher merge.
