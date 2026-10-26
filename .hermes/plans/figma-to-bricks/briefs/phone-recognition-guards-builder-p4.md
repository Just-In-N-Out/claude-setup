# phone-recognition-guards — BUILDER resume (P4, address scope) — 2026-10-21 ~20:20 EDT

Read first: the approved plan ~/.hermes/plans/figma-to-bricks/phone-recognition-guards.md (especially the new section "Ownership clarification — address.ts" at the end) and the previous brief briefs/phone-recognition-guards-builder-p3.md (all its rules still apply).

## Where things are
- Worktree: ~/Documents/FigmaToBricksV2/.claude/worktrees/phone-recognition-guards, branch worktree-phone-recognition-guards, tip 9495238 (source 98b7196, tests-only groundwork d6807e9), based on main .22 5e32aec. Untracked .superpowers/ is the ledger: keep it.
- Main is still 5e32aec (build 2026-10-21.22).
- The four approved files (contacts / card-title / page-words / page-links) are built and green (check 1867+6, corpus/debug byte-identical). Browser suite NOT run yet. A first failed Yellowtail run is preserved; keep it.
- Evidence: ~/.hermes/plans/figma-to-bricks/evidence/phone-recognition-guards/p3-builder/ (address-scope-red.test.ts, address-scope-red.log, link-text-proof.txt).

## Your job
1. Inspect the worktree first (git status, diff vs 9495238); do not reset, stash or discard anything.
2. Promote the RED address tests into the suite and show them failing on the branch.
3. Make the narrow address.ts change: strip the classifier's rejected ID/date ranges as main did. No other address/map policy change.
4. GREEN: npm run check, npm run test:browser (first time on this branch; re-run a single flaky showcase test before calling it a regression; preserve failed raw runs), npm run corpus compared to the saved baseline (cmp pastes, diff lint and Worse-than-v1 list), debug replay byte-compare.
5. Record in the ledger/HANDOFF/plan copy: the address scope grant, the Call-by-name caption tie behaviour change (ID text now caption words, "Call Sales" improves, ambiguous "Call order desk ties" falls to the first number) as a reviewer note, not redesigned.
6. Commit and stop at ready-for-review. No merge, push, BUILD bump or CLAUDE.md edit. Use paste-check number "next free on main at merge time" only.

Rules: no live-site writes, no dependencies, no new Bricks keys. Any other file outside the four owners + address.ts → stop with exact RED and a scope recommendation. Never weaken an existing assertion.
