# hero-media-row — VERIFIER round 2 (read only)

Fresh VERIFIER, ChatGPT Sol 6.1 xhigh (Justin's pick). You have never seen this build. **Change nothing** (no commits, push, merge, BUILD, CLAUDE.md, cleanup, live write); isolated mutations must restore exact bytes.

## Inputs
- Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/hero-media-row`, tip `735e725ded9468828b976edc11668e499f9c753e`, rebased onto main `93a5d7a` (build 2026-10-22.8). Verify with git.
- Plan `/Users/justin/.hermes/plans/figma-to-bricks/hero-media-row.md` (approved; Ownership clarification, Acceptance clarification approved by Justin, Justin's answers).
- Earlier review `evidence/hero-media-row/independent-review/` (HMR-R1 P1 fill columns collapse; HMR-R2 P2 natural-break text padding).
- Verifier-1 `evidence/hero-media-row/verifier-1/review.json` (R1 closed; **HMR-V1 P2** fullwidth Latin letters/digits ＡＢＣＤ/１２３４ still collapsed by `normalise/text.ts` whitelist → caption 40→60px, following content +20px).
- Finisher-2 `evidence/hero-media-row/finisher-fix-2/` (commits 012c4ef, 86582bd): repair now requires a closed, audited nonbreaking alphabet; uncertain forms and surrounding separators keep original geometry. Claims check 2230+6, browser 352/352, regressions 25/25, causal revert 17 failures, corpus five payloads/HTML/reports + 29 PNGs identical vs same base (exit 1 pre-existing).
(All paths under `/Users/justin/.hermes/plans/figma-to-bricks/`.)

## Do
1. Load `figma-to-bricks`, `engineering-best-practices`, `frontend-ui-repair` (its Required Validation Gates), `mutation-testing-discipline`, `code-review-practice`. You can't spawn agents.
2. Re-run `npm run check`, `npm run test:browser`, `npm run corpus` (vs same-base main) yourself as tracked background jobs.
3. Confirm R1, R2 and V1 are closed using the reviewer's and verifier-1's original tests, and probe the predicate class yourself (other scripts/characters Chrome can break between, mixed strings, edge punctuation) — and the opposite: Latin words like "Services" must still be repaired.
4. Look for regressions: real debug design at 990/768/600 keeps picture right / text left with whole words; upright phones stack; breadcrumb aligned at desktop and per row when wrapped; no sideways scroll, no clipped text/pictures; laptops (1366–992) unchanged vs main.
5. Garamond Condensed missing (unrelated corpus design) = separate unwaived release hold; report separately, never substitute or narrow.
6. Evidence to `evidence/hero-media-row/verifier-2/` with verified manifest. Always pass `workdir`.

Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], gate_receipts, skills_loaded, outstanding_release_proof, found_else}`.
