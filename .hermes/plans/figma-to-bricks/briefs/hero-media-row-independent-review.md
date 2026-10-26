# hero-media-row — fresh independent review candidate (no release)

## Identity and authority
- Worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/hero-media-row`
- Branch/tip: `worktree-hero-media-row` / `0e2a6b08ff52cafc3c56ded0be0b4b0993940a92`.
- Original base: `b4ed333`; previous correction checkpoint: `4ae6bb6`.
- Overall status: **implemented-review-candidate-validation-held**. Local implementation checks are green and review can begin. This is not release-ready/font-complete approval.
- Read the dispatcher plan `/Users/justin/.hermes/plans/figma-to-bricks/hero-media-row.md`, especially **Acceptance clarification approved by Justin**; its tracked copy is identical. Original task text's phrase/no-wrap assertions are superseded only by that explicit clarification.
- Main owns the fresh independent problem-finder, later fix pass and **fresh verifier**, not this builder. `defect_loop_skills: [frontend-ui-repair]`.
- No merge/push/BUILD bump/CLAUDE edit/live write/font substitution/worktree cleanup. No user paste action owed now.

## Approved intent / what changed
Justin explicitly chose **Allow three readable lines; never split words** and **Allow wrapping; align items within each row**. T8 now directly verifies all three words occupy one Range line apiece, remain in the words column and render at ≥16px at **all 19 original widths**, both row/grid. All original no-sideways-scroll, picture-right/overlap, picture usability/containment and upright stacking checks remain. No phrase-fitting rule or extra padding/font substitution.

Breadcrumbs are grouped into rows using their actual flex item boxes, not possibly displaced ink. Short and long-label controls cover all 19 widths, with real natural wrapping exercised, whole Home/Services words, baseline agreement per actual row, contained/non-overlapping visible ink, no sideways scroll, and explicit desktop Home/Services alignment. The original standalone breadcrumb test is unchanged. Existing Arial fixtures are validated through CDP actual platform glyph fonts, not misclassified as missing downloadable faces.

**Additional genuine approved-intent defect found at 320px:** the inherited heading `break-word` remained after portrait stacking, while the ink-based column cap did not; 39px split Remanufactured in the real 288px minimum-phone slot. Public-convert unit and real Chrome RED were preserved first. The only new production change since `4ae6bb6` is in `src/core/adapt/rules/type.ts`: retain the same existing word cap, 8% pad and BODY floor after stacking only for headings previously in a kept hero pair, using the planner's existing smallest-phone width/room. This generic long heading becomes 34px; a shorter heading remains 39px. Tablet/landscape sizes remain 44/26, and three complete-word lines there are not shrunk further. Portrait-stack controls stay unchanged. Please independently assess this scoped repair and inherited responsive/class behavior.

## Inspect
- Whole feature: `git diff b4ed333...0e2a6b08ff52cafc3c56ded0be0b4b0993940a92`.
- This continuation: `git diff 4ae6bb6...0e2a6b08ff52cafc3c56ded0be0b4b0993940a92`.
- Records: `docs/plans/2026-10-22-hero-media-row-ledger.md`, current HANDOFF top section; plan allowlist and original scope exceptions still apply.
- Review actual-word/containment sensitivity, BODY floor, row grouping without baseline-oracle evasion, 320px cap scope and ordinary/non-hero/portrait controls. Do not introduce universal phrase fitting or forced breadcrumb nowrap.

## Executed final author gates (exact final source/test hashes preserved)
- `npm run check`: exit 0, **2121 unit/rule + 6 serial performance**, no skips/failures/cancellations.
- `npm run test:browser`: exit 0, **288/288**, no skips/failures/cancellations (574 seconds; run long gates as tracked background jobs, not a foreground timeout).
- Focused hero unit **7/7**; hero+standalone crumb browser **44/44**.
- Mutation baseline/restored **44/44**; exact old share source rejects row words at 768/480/479, exact old type rule rejects both 320px cases, exact old normalise rejects desktop baseline-per-row in both crumb controls. Current test hashes frozen and exact source/test restoration proven. Parent/subtest records counted separately; no setup error credited as a kill.
- Actual debug replay, **22-width** geometry/expected-font/lint and actual-row breadcrumb checks: green. Desktop/laptop hero geometry matches original base within 1px except the intended Services correction. Picture/phone band/stacking/no-sideways-scroll retained.
- Fresh all-five corpus payloads AND full HTML AND complete per-file reports exactly equal original baseline; identical **18 worse-than-v1 entries**. Actual `npm run corpus` exit **1**, not silently called exit 0.
- All seven requested final snapshots exist: 1571/1366/990/768/600/480/375. New before/after row/grid headings include 320, 768, 480 and 479; real before/after crumb captures include 1571/990/768/600/480/479/375/320.

## Explicit hold — not a source/browser failure and not waived
`final-design` genuinely lacks **Garamond Condensed**: expected includes it; observed loaded is Inter/Playfair Display; missing contains Garamond. No stand-in was added, expected sets were not narrowed, and an earlier other-feature M1A waiver is not assumed to authorize this release. Comparable/font-complete Garamond visual proof remains an explicit **release-proof hold**. Review may investigate now, but must not silently waive or substitute this proof. Installed Bricks paste/header save/cache/live acceptance remains owed only after a separately authorized release.

## Durable evidence
Root: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/hero-media-row/acceptance-aligned-20261022/`
- `acceptance.json`, `classify.log`, `source-pins.json`, `gate-receipts.json`, raw check/browser/corpus logs and original/final reports/HTML/payloads.
- `mutation/receipts.json`, exact variant bytes/pins/logs and `restoration.json`.
- `portrait-unit-red.log`, `portrait-browser-red.log`, focused GREEN, old unchanged original oracles under `original/`.
- `crumbs/receipt.json`, raw original/candidate actual-slot/ink/clip/font measurements; `debug-geometry.json`; `heading/measurements.json`.
- `heading/before-row-320.png`, `heading/after-row-320.png`, `heading/after-row-768.png`, `crumbs/baseline-479.png`, `crumbs/candidate-479.png`; all final snapshot PNGs under `shots-after/`.
- Manifest binds the archived records/candidate and is checked by reading and hashing every exact target, not by assuming a copy succeeded.

Historical `builder-continuation-20261022/` (269 targets) and `acceptance-fix-20261022/` (93 targets) were fully rehashed and preserved unchanged, including the original causal RED and superseded acceptance failures. Renderer stand-in pictures are not real-media fidelity proof. Header CSS remains the prior locally tested, GET-only template-CSS deliverable, not installed code. Existing out-of-scope findings (theme uppercase, media redirect, plugin-owned header stacking, grid-only hero recognition limitation, condensed fallback) remain in the approved plan/ledger.
