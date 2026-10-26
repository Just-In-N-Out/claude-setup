# hero-media-row — FINISHER fix pass (HMR-R1, HMR-R2), stop at ready-for-verify

Role: FINISHER, ChatGPT Sol 6.1 xhigh (Justin's pick for the whole pipeline). Agent Defect Loop applies (`frontend-ui-repair`): fix, commit, then STOP with `status: ready-for-verify`. **No merge, no push, no BUILD bump, no CLAUDE.md edit, no worktree cleanup, no live-site write.**

## Read first
- Plan: `/Users/justin/.hermes/plans/figma-to-bricks/hero-media-row.md` (incl. Ownership clarification, Acceptance clarification approved by Justin, Justin's answers).
- Review: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/hero-media-row/independent-review/review.md` and `review.json`; the reviewer's tests `fill-sizing.v2.test.mjs`, `natural-wrap.v3.test.mjs`, probes and causal logs in the same folder.
- Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/hero-media-row`, branch `worktree-hero-media-row`, tip `0e2a6b08ff52cafc3c56ded0be0b4b0993940a92`, base `b4ed333`. Main has since moved to `8f538bb` (verify with git).

## Reviewer findings (verbatim summary from the review result)
- **HMR-R1 · P1 · introduced — Fill-sized hero columns can collapse.** `src/core/adapt/hero-pair.ts:12–20,27–31` uses drawn-width shares when emitted CSS uses `flex-basis:0`/grow allocation. At 768px, Media-only FILL produces a 0px picture; Words-only FILL splits "Remanufactured" across 3 lines. At 479px the words column becomes 0px and that word fragments across 14 lines. Original main stacks safely. Evidence: `fill-probes.json`, `fill-sizing.v2.test.mjs`, before/after PNGs, causal-revert logs.
- **HMR-R2 · P2 · introduced — Natural browser breaks are misclassified.** `src/core/normalise/text.ts:182–187` treats CJK, soft-hyphen and zero-width-space content as unbreakable. The Scene collapse causes inferred 10px top/bottom padding, growing a valid 40px caption to 60px and shifting following content 20px. Six unit/Chrome checks pass on main, fail on candidate, pass with only old normalise restored. Spacing finding, not clipping.

## What to do
1. Load skills in order: `figma-to-bricks` (FINISHER role), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`, `systematic-debugging`, `mutation-testing-discipline`, `frontend-ui-repair`. You can't spawn agents; skip any skill's subagent/auto-fix steps.
2. Verify each finding yourself (run the reviewer's tests on the candidate). Fix valid ones **test first**, porting the reviewer's cases into the repo's test tree as generic fixtures:
   - R1: the keep decision and the type room must use the shares Chrome actually gives (FILL/grow `flex-basis:0` allocation, as well as fixed/hug), or the pair must fall back to main's stacking when shares can't be determined safely. Never produce a 0px column or a split word. Retaining main's stacking for the unsafe sizing cases is acceptable and preferred over new policy.
   - R2: narrow the "unbreakable single word" predicate so text a browser can break naturally (CJK/ideographs, soft hyphen U+00AD, zero-width space U+200B, and similar break opportunities) is excluded and keeps main's output. Breadcrumb "Services" fix must still pass.
   - Push back with evidence on anything not valid.
3. Rebase onto current main (`git rebase main`; keep both HANDOFF sections). Then run `npm run check`, `npm run test:browser` and `npm run corpus` on the rebased branch (long gates as tracked background jobs). Corpus: compare against a same-base baseline as the project skill says; corpus exit 1 on main is pre-existing.
4. Re-shoot `after` pictures if output changed, save durable copies under `~/.hermes/plans/figma-to-bricks/shots/hero-media-row/` and evidence under `~/.hermes/plans/figma-to-bricks/evidence/hero-media-row/finisher-fix/` with a verified manifest. Update ledger, plan copy and HANDOFF (paste check: take the next free number on main at merge time; leave as "TBD at merge").
5. **Garamond Condensed** is a pre-existing missing font in an unrelated corpus design: keep it as an explicit, unwaived release-proof hold. No substitution, no narrowing of expected sets, no inferred waiver.
6. Stop at `ready-for-verify` with everything committed. Return: status, summary, per-finding disposition (fixed/pushed back + evidence), gate receipts, worktree, last_commit, shots[], defect_loop_skills, found_else, outstanding release proof.

Always pass `workdir` to terminal calls. Anything else found → `found_else`, not fixed.

## Justin's intent (unchanged)
Picture RIGHT, text LEFT on tablet (≤991) and sideways phones (≤767), like desktop. Upright phones stack; sideways-phone CTAs stay in the band under the hero. Heading may run to three readable lines but never splits words. Breadcrumb may wrap, aligned per row. Header CSS block is a manual deliverable. W-B stays held.
