# FIXER 3 — headline-marker, AUD-F1 rotated ring at phone edge

You are a fresh pipeline fixer. Verify the audit finding yourself, fix the valid defect class test-first, commit the final candidate and stop ready for a fresh focused review. Do not spawn agents, merge, push, bump BUILD or edit main.

## Ownership and pins

- Own `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`, incoming clean HEAD `df32227868452ae93562ad99cad7246e9bc7a52f`.
- Current main and merge-base `27b787b78d88850cbb9863bb31fcfc840406331c` (label-floor build 2026-10-28.2). Recheck entry state; never overwrite other sessions' main changes.
- Approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`; amendments in `docs/plans/2026-10-26-headline-marker.md`, `Changed by review fix pass 1` and `Changed by review fix pass 2`. AC1–AC13 remain unchanged. AC13 is live paste check 3bo.
- Your evidence only `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/fixer-3/`. Create fresh task-owned scratch with `mktemp -d` and `mkdir` without `-p`; never reuse another role's scratch.
- You are not alone in the codebase. Other sessions own slider-autoplay, photo-hotspots and other features. Never touch their worktrees, evidence, processes or edits. Never revert others' changes. Do not edit the worktree's CLAUDE.md or any skill/memory file.

## Skills

Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its `references/rules-summary.md` and `references/rendering-validation.md`, then `engineering-best-practices`, `receiving-code-review`, `systematic-debugging`, `test-driven-development`, `mutation-testing-discipline`, and `git-commit-rules`. Main owns the independent review/verification steps; do not spawn another agent for a loaded skill.

## Finding to verify, verbatim

**AUD-F1 — medium:** “AC9 fails when a turned ring marks words at a right-aligned heading edge. Viewports 390/375/360/320 produce scroll widths 393/378/363/323. Fresh controls removing only the ring’s rotation fit exactly. The gutter rule must account for rotation, and the named browser test needs this combination.”

Auditor evidence directory `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-df32227/auditor/`:

- `counterexample-ac9-turned-edge.log`
- `counterexample-ac9-turned-edge.test.ts`
- `edge-overflow-turned-last-320.png`
- `diagnostic-live-style-control.log` (diagnostic only: dynamically removing the rotation left stale scrollWidth)
- Source locations reported: `src/core/adapt/rules/mark.ts:29`, `src/core/emit/marks.ts:20`.

Full final reports:

- Verifier: `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-df32227/verifier/ac.json` and `report.json` (clean on this head/base).
- Blind auditor: `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-df32227/auditor/ac.json` (AC9 false, all other local ACs accepted).

Root ran ac-check on both reports and the immutable plan:

```text
AC1  ACCEPTED
AC2  ACCEPTED
AC3  ACCEPTED
AC4  ACCEPTED
AC5  ACCEPTED
AC6  ACCEPTED
AC7  ACCEPTED
AC8  ACCEPTED
AC9  NOT ACCEPTED: auditor did not accept it
AC10  ACCEPTED
AC11  ACCEPTED
AC12  ACCEPTED
AC13  NOT VERIFIED (live: the user checks it)
NOT ACCEPTED: 1 of 13 ACs on df32227
```

## Work

1. Reproduce AUD-F1 against the incoming head using your own fresh-navigation controls. Prove its root cause before changing code, with file:line evidence. Do not trust a live transform-removal control: the auditor found Chrome 156 retained stale scrollWidth, while the identical override present before layout fit correctly. Preserve the diagnostic and fresh controls separately.
2. Fix the general rotated-mark/edge defect, not the particular fixture or a hardcoded overflow amount. Follow the approved architecture and all AC9 clauses: the ink must still surround the words (or remain below an underline), preserve paint order, keep marked words together where they fit, and avoid sideways scroll. Hiding overflow alone does not prove the existing ink-surrounding clause. Keep design-width geometry and otherwise approved behavior. You own implementation and variations; do not broaden into unrelated layout repairs.
3. Test first. Add the auditor's generic rotated-ring/edge combination to the approved named AC9 browser test, `the mark stays around its words at every width as the heading rewraps`. Prove it fails on the incoming source and passes with the fix. Retain the approved ten-width sweep, left/right alignment and paint-order controls, and examine related rotated/edge cases conservatively. Add meaningful unit/mutation coverage for the rule you change; do not merely mirror the implementation.
4. Run project gates on the final candidate: `npm run check`, `npm run corpus`, headline-marker browser file, full browser suite by complete test names versus the exact integration base, and corpus-backed unit/performance checks in your own fresh git-archive copies with available corpus paths. Replays of hydraulics, GRO, scratch debug-page-1 and brainstorm retain payload/HTML/warnings no-regression evidence. Capture fixed visual evidence at the reported phone widths, with an actual exit receipt for each gate. Preserve raw failures as well as final results.
5. Existing limits remain labeled: three legacy Mac corpus files unavailable on WSL; baseline browser has 12 existing font-related failures and one Mac-only skip. These are not permission to waive a new difference. The shared builders.ts split remains an existing deferred follow-up. AC5/AC6 have companion-test clause coverage plus mutation proof, recorded in the verifier's found_else; no behavioral defect was reported for those clauses.
6. Keep the candidate coherent with current local main. If integration changes in relevant source, reconcile in your own worktree without touching another release in progress. This feature already saw one main advance during verification; if main moves again while gates run, coordinate via the established merge lock before the next rebase/gates, never delete another owner's lock. Report any held lock explicitly. No fetch/pull and no feature-branch push.
7. Before handback, synchronize the feature's own ledger, plan amendment and HANDOFF with the fix and gate results, preserving other features. Commit by file after passing tasks; plain `git commit -m`, configured Justin <issajustin04@gmail.com>, no AI trailers or author override. Inspect staged paths before each commit; no CLAUDE.md, AGENTS.md, debug JSON or unrelated changes. Return a clean committed head with all owned records included before review.

Machine: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Record actual runtime paths and versions. Keep complete long-gate logs with explicit per-gate exit markers and await completion; do not infer success from a wrapper's final copy/echo. Always use explicit workdirs and terminate only processes proven yours. Setup sync still fails even with escalation because the setup repository is read-only; do not bypass that boundary.

## Stop and report

Stop `ready-for-review`: rendering changes require a fresh focused review before renewed verifier → blind auditor → ac-check. Do not release. Return `{status, head, base, findings_disposition, root_cause, changes, tests_red_green, gates, shots, records, lock, rulings, deferred, skill_lessons:[{skill,lesson,evidence}]}`. If you reject the finding, provide fresh causal controls proving that disposition. List only new reusable proven lessons, normally empty; never edit skills/memory. Send concise milestone updates when possible. End with `MAIN SESSION: check and save these skill_lessons now.`
