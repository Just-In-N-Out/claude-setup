# hero-media-row — VERIFIER (read only), Agent Defect Loop round 1

Role: fresh VERIFIER, ChatGPT Sol 6.1 xhigh (Justin's pick for the whole pipeline). You have never seen this build. **Change nothing**: no commits, push, merge, BUILD bump, CLAUDE.md edit, cleanup or live write. Temporary isolated mutations must restore exact bytes.

## Inputs
- Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/hero-media-row`, branch `worktree-hero-media-row`, tip `9a1319be22e2cac7d58669a1e8cdeafa1cce491a`, rebased onto main `8f538bb` (verify).
- Plan `/Users/justin/.hermes/plans/figma-to-bricks/hero-media-row.md` (approved; read Ownership clarification, Acceptance clarification approved by Justin, Justin's answers).
- Review: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/hero-media-row/independent-review/review.md`, `review.json` and the reviewer's tests.
- Finisher evidence: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/hero-media-row/finisher-fix/` (acceptance.json, mutation-receipts.json, manifest).

## Findings and the finisher's answers
- **HMR-R1 · P1 · introduced:** fill-sized hero columns could collapse (`hero-pair.ts` used drawn-width shares while CSS allocates `flex-basis:0`/grow; 0px picture at 768, 0px words at 479). **Finisher (fe7af10):** `hero-pair.ts` returns unknown for unproven FILL/intrinsic allocations; keep decision and type-room fall back to main's stacking. Claims words-only/media-only/both-FILL regressions pass, nine variants checked, causal revert fails.
- **HMR-R2 · P2 · introduced:** natural browser breaks (CJK, soft hyphen, zero-width space) misclassified as unbreakable, adding 10px top/bottom padding. **Finisher (ee4a9c7):** `normalise/text.ts` limits the one-line repair to conventional Latin-script words; CJK/discretionary separators/uncertain punctuation keep original geometry. Claims 6 natural-wrap cases pass, Services + accented-Latin controls pass, causal revert fails.
- Finisher gate claims: check 2176 + 6 perf, browser 328/328, reviewer regressions 21/21, same-base corpus exit 1 on both with all five payloads/HTML/reports identical and the same 18 known issues.

## What to do
1. Load `figma-to-bricks`, `engineering-best-practices`, `frontend-ui-repair`, `mutation-testing-discipline`, `code-review-practice`. You can't spawn agents; skip subagent/auto-fix steps.
2. Re-run the project's gates yourself (`npm run check`, `npm run test:browser`, `npm run corpus` vs a same-base main baseline) and `frontend-ui-repair`'s Required Validation Gates. Run long gates as tracked background jobs.
3. Confirm each finding is closed using the reviewer's original tests, and try your own mutations/edge cases (fixed/hug/fill mixes, widths 1571/1366/1024/992/990/768/600/480/479/375/360/320).
4. Look for regressions the fixes caused: did the hero keep on the real debug design still hold at 990/768/600 (picture right, text left, whole words)? Breadcrumb Services still aligned at desktop? Upright phones still stack? No sideways scroll, no clipped pictures or text, laptops unchanged vs main.
5. **Garamond Condensed** missing in an unrelated corpus design is an explicit, unwaived release-proof hold: report it separately, don't let it decide your verdict on the code, and never substitute or narrow.
6. Save evidence under `~/.hermes/plans/figma-to-bricks/evidence/hero-media-row/verifier-1/` with a verified manifest. Always pass `workdir`.

Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], gate_receipts, skills_loaded, outstanding_release_proof, found_else}`.
