# found-gates — pending protected-document proposal only

No CLAUDE.md write has been attempted in this batch (main or worktree). Do not retry or route through another agent/tool. Apply only through a future permitted approval path, after older pending entries in build order, and only after verified release. Do not update the BUILD line now: this builder is not authorized to merge/push/bump BUILD. Current source base is b4ed333 / BUILD 2026-10-22.5; implementation commits a3a3ffc, ab19dfa, a2aab7f remain isolated and awaiting independent review.

## Exact proposed Start here bullet (after verified release)

- **found-gates:** default captures include 1280; explicit geometry probes check declared row/picture expectations; snap records each width's expected/loaded/missing fonts and fails non-comparable captures after saving evidence. No converter or font policy change; Garamond remains **UNVERIFIED**. No tooling-only paste check owed. See `docs/plans/found-gates-ledger.md` for source-bound checks and evidence; layout/tiles adoption is independently owned and not claimed complete here.

## Exact proposed Debugging tools paragraph

`snap` writes `snap-report.json` with `capturePolicy` and a `widths` map containing each capture's full lint findings, height and exact `fonts.loaded`, `fonts.failed`, `fonts.expected`, `fonts.missing` observations. It saves all requested widths' artifacts, then exits nonzero if any width is font-incomplete. A missing family is not necessarily an observed failed face: an absent/empty stylesheet can leave `failed: []`. Do not narrow the expected list or substitute a font to obtain a green capture. Routine widths retain 390/768/1024/1440 and the design width, adding 1280; corpus retains 1920 too. Global 375/360/320 rollout remains separate.

## Exact proposed geometry caution

`runLint(page, width, probes?)` accepts explicit `rows: [{box,last,expectedGap}]` and `pictures: [{target,clip}]` contracts, imported as `GeometryProbes` from `test/browser/geometry.ts`. No contracts means unchanged legacy lint behavior. Do not globally fail intentional cropped art: specify independently justified must-fit expectations only at the tiers where they apply. Reachable scrolling is distinct from unintended clipping: horizontal reachability uses the scroller's computed direction and actual scrollLeft, including RTL's negative-origin range. A contained viewport does not exempt unreachable start-side overflow, and a viewport outside the declared clip is not exempt. Unsupported transformed/nonrectangular/escaping clip geometry rejects rather than inventing a measurement. Rectangles do not prove pseudo-element paint or installed-Bricks fidelity.

## FG-R1 corrected candidate / verification state (proposal remains unapplied)

Corrected candidate commit **693245e515885b1f27a6868773d8616a63577013**, isolated on `worktree-found-gates`; not merged/pushed/released. Reviewed predecessor **3dda965481a7564fb5ee159da9b42fa7adfb86b6**.

First independent review of `3dda965481a7564fb5ee159da9b42fa7adfb86b6` found introducedP2 FG-R1. Original public-wrapper RTL fixture reproduced RED; permanent generic direction/range controls preceded the minimal horizontal-only correction. Corrected `test/browser/geometry.ts` SHA256 `f733eb51ae75206ed59c4ba6b0013748af1308ed9fe951c697efa386d83ad4d0`, test SHA256 `e950b4057215d2ffe3e6d98466f90f68b966bc58637acaf22c3a2bb2710aab9d`. Focused33/33, three isolated intended mutation kills, restored13/13, check2113+6 and full browser263/263 pass. Corpus remains exit1 with the same17 historical differences + genuine missing-Garamond diagnostic; five pastes/full HTML and34 complete width observations/file reports equal the reviewed candidate, timestamp separately disclosed. Corrected durable evidence `~/.hermes/plans/figma-to-bricks/evidence/found-gates/finisher-r1/`, manifest SHA256 `246f27c1058c0aac895a70ce9c8a932e2afd3b4cf1b5fdeb4e79d754d127d3ce` (70 files/10,132,413 bytes read-back verified). Raw timeout/first comparator failure and original reviewer evidence retained.

Current stop: **committed ready-for-review**, no release. A **NEW fresh Sol6.1 high review on correction delta and whole branch** is required; prior review cannot approve changed checker semantics. Genuine Garamond remains **UNVERIFIED**, no substitutes, expectation narrowing or historical M1A extension. W-B held, ALONE unchanged; layout/tiles adoption remains partial/separately owned. Future permitted release also requires then-current-main integration gates and genuine-font disposition. No merge/push/BUILD/cleanup, protected write/retry or site writes occurred in this correction. Apply this proposal only through a future permitted path after older pending entries and verified release; do not change the current BUILD line now.

## Verification / release boundary

The source-bound builder records carry actual check/browser/corpus results. The original and final corpus captures retain Garamond Condensed as missing; no historical M1A waiver is reused. W-B remains held; ALONE unchanged. Canonical finding closure and release identity must wait for the independent reviewer/finisher and any required verifier. Preserve all older pending files unchanged.
