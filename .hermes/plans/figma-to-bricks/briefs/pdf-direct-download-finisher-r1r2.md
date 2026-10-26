# FIX-ONLY FINISHER — pdf-direct-download R1/R2

## Role, state and release boundary

You are the test-first FIX-ONLY FINISHER for `pdf-direct-download` in FigmaToBricksV2. This is the automatic corrective pass after a fresh independent review, not permission to release.

- Repository main: `/Users/justin/Documents/FigmaToBricksV2`
- Existing worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/pdf-direct-download`
- Branch: `worktree-pdf-direct-download`
- Reviewed tip: `d2e86e1b388bd36322d051e7d3f3a524acf1bbdc`
- Reviewed base: `b4ed333631dba923b73e1731ad420a4f92d880f1`
- Approved plan: `/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md`
- Fresh review archive: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/reviewer-d2e86e1/`
- Builder archive: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/builder/`

Parent verified the existing branch has no tracked changes, only builder `.superpowers/` evidence. Preserve it. The reviewer changed no repository file. The archive contains 204 hash-verified evidence targets; `archive-manifest.json` maps each exact durable path to the original path. The original scripts can still reference scratch paths; copy/adapt test execution explicitly while preserving original evidence, rather than pretending original absolute paths refer to the archive.

**HARD RELEASE HOLD:** no merge, push, BUILD bump, worktree/branch deletion, or edits to main `CLAUDE.md`. Fixes must return to a NEW FRESH independent reviewer because they change output/semantics. The Agent Defect Loop verifier is also required. Stop at `ready-for-review` when corrected, not merged. If R2 requires an unapproved mechanism or accepting a limitation, stop for a product decision with safe committed R1 work preserved.

## Skills to load, in this order

1. `figma-to-bricks`
2. `engineering-best-practices`
3. `receiving-code-review`
4. `git-commit-rules`
5. `test-driven-development`
6. `systematic-debugging`
7. `frontend-ui-repair`
8. `frontend-cross-browser-matrix`
9. `frontend-testing-workflow`
10. `mutation-testing-discipline`

Say which you loaded. You cannot spawn agents; the parent runs fresh review and verification. Follow the project skill's selective context-loading, personal Git identity, records and evidence rules. Always pass an explicit workdir.

## Approved intent and exclusions

Justin approved 1A/2A/3A/4A with “go” on 2026-10-22:

1. Structural PDF download controls (native Button or linked Div/Block rendered as the anchor) should download same-site PDFs.
2. Other-site PDFs retain new-tab/noopener viewing fallback.
3. Linked words in paragraphs, linked pictures, whole-linked text and non-PDF links remain unchanged.
4. Plugin-only: no server configuration, live-site writes, logins, uploads or new JavaScript/Code element mechanism.

Do not key any fix to words, layer names/IDs, page names, styling, one URL or screenshot. No external write is authorized. An attribute's presence is not proof of behavior.

## Fresh review findings — verbatim

### R1 — major — introduced

Claim: "PDF-linked pictures unexpectedly download in the panel's default inline-picture mode, violating the explicit unchanged-picture scope."

Evidence: "src/core/emit/elements.ts:46-47 checks only element kind. understand/understand.ts:72 changes image elements into Divs for inlinePictures, while ui/settings.ts:16 defaults to that mode. convert(downloadControlsPage(), {inlinePictures:true}) consequently adds download to the Cover picture at /files/cover.pdf. The same-base assertion passes on b4ed333 and fails on d2e86e1. Headed and headless Chrome 155 open a viewer tab on the base but complete cover.pdf with no tab on the candidate. See inline-picture-repro.log and finding-receipts.json (R1) in the evidence paths. Preserve image/vector roles when deciding eligibility and cover both picture modes."

### R2 — minor — introduced; release decision required if not safely fixable

Claim: "A same-origin PDF URL redirecting across origins replaces the current page instead of preserving the promised new-tab fallback."

Evidence: "The download added at src/core/emit/elements.ts:111-119 changes redirect behavior despite retaining target=_blank and rel=noopener. Independent local /redirect-external.pdf returns HTTP 302 to a second-port /files/foreign.pdf served application/pdf without Content-Disposition. On b4ed333 the originating page stays and one no-opener tab opens; on d2e86e1 there are zero completed downloads, zero new page targets, and the originating page navigates to the foreign PDF. Reproduced in headed and headless Chrome 155. See finding-receipts.json (R2) and independent-browser-v2.mjs. Add redirect coverage and resolve the fallback or obtain an explicit scoped limitation; do not silently add server/JavaScript scope."

The exact artifacts now live in the durable archive above. `finding-receipts.json` contains the headed and headless tab/download/current-location receipts; `inline-picture-repro.test.mjs` is the independent same-base R1 regression; `independent-browser-v2.mjs` is the complete browser probe.

## Corrective tasks and scope

1. Verify each finding against actual source and the archived reproductions before editing. Start with focused evidence, not another full corpus restart.
2. R1: add regression tests that are RED on the reviewed source for both inline and native picture modes and relevant image/vector provenance. Make the smallest general eligibility correction in the existing emitter. Preserve intended Button/box downloads and marquee/custom attributes. Do not use emitted element kind alone where the semantic role survives transformation.
3. R2: reproduce and trace the exact browser behavior. Investigate whether a safe HTML/custom-attribute-only correction can keep direct same-origin download, direct cross-origin fallback, and cross-origin-redirect fallback simultaneously within the approved contract. Do not claim success from retaining `target=_blank`. If no proven approved mechanism exists, preserve the failing behavioral receipt and return 2–3 concrete options with one recommendation, including the exact user-visible limitation and whether the Services upload path is affected. Do not silently accept the regression or introduce fetch/JavaScript, a server endpoint/header change, a new Code element or broader network/permission mechanism.
4. Fix the non-blocking whitespace warning `test/unit/pdf-direct-download.test.ts:137` if still present; run `git diff --check`.
5. Commit scoped passing fixes using Justin's personal identity. Preserve an unresolved R2 test/probe as evidence without making required checks falsely green or leaving a red mandatory suite hidden.
6. When behavior is resolved within scope, run focused tests and sensitivity/mutation checks, then the established project check/browser/corpus gates. Preserve exact original/final reports. A full browser run can exceed the 420-second foreground cap: use a tracked background process with process_manage or bounded full-coverage groups. Distinguish Chrome startup contention from a source assertion and clean only your proven orphaned Chrome roots.
7. Refresh text proof and records for the correction. Builder's old claims about unchanged pictures and universal cross-origin fallback are no longer valid. Installed Bricks 2.3.9 paste/save/copy-back, Safari/Firefox/Edge/mobile remain unproved, not passes.
8. Do not silently waive final-design's existing missing Garamond Condensed or narrow expected fonts. Identical reports do not prove font completeness. Any release-specific waiver must come from Justin; this pass is no-release regardless.

The current tracked change area is emitter + feature tests/fixtures + records. If preserving role information actually needs a new production file beyond the plan's allowlist, explain the exact narrow need before expanding it. Do not touch siblings' source/tests. Take the next free paste-check number at actual merge time, not now.

## Records and output

Write corrective evidence under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/finisher-r1r2/`, with a manifest and exact tested base/tip. Append an R1/R2 answer in the worktree's ledger/HANDOFF and return its path. Do not update shared dispatcher board or canonical found ledger yourself.

Return:

- `status`: `ready-for-review` or `stopped`
- `summary`, `worktree`, `last_commit`
- `findings_answers[]`: R1 and R2, each verified/fixed/unresolved with exact evidence
- `rulings[]`, `questions[]`, `stop_reason`
- `gates[]`, `evidence_paths[]`, `text_proof[]`, `found_else[]`
- `defect_loop_skills[]`

Do not mark `ready-for-review` as released. If R2 is a product decision, explicitly preserve the no-merge/no-push/no-BUILD boundary in every record and the return.
