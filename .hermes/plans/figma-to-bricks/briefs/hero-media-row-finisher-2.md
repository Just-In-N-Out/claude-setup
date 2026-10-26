# hero-media-row — FINISHER fix round 2 (HMR-V1), stop at ready-for-verify

Role: FINISHER, ChatGPT Sol 6.1 xhigh (Justin's pick, whole pipeline). Agent Defect Loop round 2. **No merge, push, BUILD bump, CLAUDE.md edit, cleanup or live write.** Stop at `ready-for-verify`.

Read first: previous brief `briefs/hero-media-row-finisher.md`, plan `hero-media-row.md`, verifier report `evidence/hero-media-row/verifier-1/review.json` (all under `/Users/justin/.hermes/plans/figma-to-bricks/`). Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/hero-media-row`, tip `9a1319b`. Main moved to `977fcce` (build 2026-10-22.7, pdf-direct-download): verify with git.

## Verifier finding (verbatim)
**HMR-V1 · P2 · reopens HMR-R2:** the brokenWord whitelist still collapses naturally wrapped fullwidth Latin letters and digits (`src/core/normalise/text.ts:182-186`). Reproduction: the reviewer's caption fixture with ＡＢＣＤ or １２３４, width 44px, auto-height 40px, 20px Arial / 20px line-height. Both pass the whitelist but render as two natural browser lines. Candidate changes Scene y80/h40 to y90/h20; Chrome adds 10px top/bottom padding, caption frame 40→60px, following content y120→y140. Causal proof: the four-test extension passes 4/4 on base, fails 4/4 on candidate, passes with old normalise.ts only, fails after restoration. Direction: preserve original geometry for these naturally breakable forms and add Scene/Chrome controls while keeping the Services and accented-Latin positives. Evidence: `verifier-1/fullwidth-natural-wrap.test.mjs`, `natural-edge-results.json`, `fullwidth-restored-candidate.log`, `fullwidth-causal-old-normalise.log`.

## Do
1. Load `figma-to-bricks` (FINISHER), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`, `systematic-debugging`, `mutation-testing-discipline`, `frontend-ui-repair`.
2. Fix the **class**, not just the two witnesses: think about which characters Chrome can break between without spaces (fullwidth/halfwidth forms, East Asian Width W/F, other scripts with per-character break opportunities, UAX #14 classes). Prefer the most conservative predicate: apply the one-line repair only where you can prove Chrome has no break opportunity inside the word; otherwise keep the original geometry. Port the verifier's tests plus your own class-level controls into the repo, test first. Keep Services and accented-Latin positives and every earlier R1/R2 test.
3. Rebase onto current main, rerun `npm run check`, `npm run test:browser`, `npm run corpus` (same-base baseline compare; base exit 1 is pre-existing) as tracked background jobs. Re-shoot after pictures if output changed.
4. Evidence under `evidence/hero-media-row/finisher-fix-2/` with a verified manifest; update ledger/plan copy/HANDOFF (paste check TBD at merge).
5. Garamond Condensed stays an explicit unwaived hold (no substitution/narrowing). Pre-existing found_else items (320 fallback scroll, FILL laptop 23px picture) stay out of scope.

Return `{status, summary, findings[{id, disposition, commit, evidence}], worktree, last_commit, shots[], defect_loop_skills, found_else, outstanding}`. Always pass `workdir`.
