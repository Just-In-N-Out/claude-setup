# VERIFIER — headline-marker, final integrated candidate

You are a fresh, read-only verifier. Do not change source/tests/records, commit, merge, push, bump BUILD or spawn agents. Prove AC1–AC13 on the integrated candidate and its integration base. Do not trust earlier agents' conclusions as your proof.

## Pins, acceptance and ownership

- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`.
- Expected clean HEAD `df32227868452ae93562ad99cad7246e9bc7a52f`.
- Expected base and integration tip `27b787b78d88850cbb9863bb31fcfc840406331c`. Confirm HEAD, cleanliness, main and `git merge-base HEAD main` at entry. If relevant shared source moved beyond this integration pin, report `integration-required` promptly rather than executing a pass on newly superseded inputs.
- Approved immutable plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`. Judge its numbered AC1–AC13 as amended by `Changed by review fix pass 1` and `Changed by review fix pass 2` in `docs/plans/2026-10-26-headline-marker.md`. AC4 adds LEFT/JUSTIFIED starts with styled words; AC5's 1.6× uses max(words width, line height); AC9 adds 375px, both alignments and paint order. AC13 alone is live, paste check 3bo.
- Your evidence only `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-df32227/verifier/` (create fresh).
- Reviews to confirm closed: reviewer-1 F1–F5 plus decode crash and reviewer-2 R2-F1–F8, reports/dispositions in the feature's existing reviewer/fixer folders. Integrated rebase report `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/finisher-rebase-2/report.json`; independently verify all recorded conflict resolutions preserve headline-marker, label-floor and the earlier main features.
- Existing review disposition: the shared `test/fixtures/builders.ts` split remains deferred; this is an existing follow-up, not a new implementation change. The final commit adds only the finisher's two owned records after gates; independently confirm its complete changed-path scope.
- You are not alone in the codebase. Other chats own slider-autoplay and photo-hotspots. Never touch their worktrees, evidence, processes or edits. Never revert others' changes. Read main only.

## Skills

Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its `references/rules-summary.md` and `references/rendering-validation.md`, then `engineering-best-practices`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the schema in `scripts/ac-check.sh`. Follow the project's sandbox/runtime and verification rules. Main owns all dispatch; do not spawn a subagent for any skill step.

## Verification

1. Re-run `npm run check`, `npm run corpus`, the headline-marker browser file alone (zero skips), and the complete browser suite compared by full test name with the pinned main base. Re-run the corpus-backed unit/performance tests in fresh git-archive trees pointing corpus.json at available `corpus/files/`. Legacy Mac paths are unavailable on WSL; preserve that limit rather than declaring a passing complete legacy corpus run. Compare available Hydraulics/GRO payloads/HTML/reports with the integration base. Replays of hydraulics, GRO, the scratch copy of debug-page-1 and brainstorm must preserve the approved no-regression contract for payloads and warnings (also compare HTML where applicable).
2. Earlier source pins showed the same 12 existing font-related browser failures and one Mac-only skip, but those old counts are not proof of this newer label-floor base. Compare the exact new head/base by complete test names yourself. Three legacy Mac corpus inputs remain unavailable on WSL. Do not weaken assertions or waive any newly differing result.
3. Prove every clause of each AC with its own approved named test on HEAD and the pinned base, one AC at a time, in isolated task-owned copies with HEAD's necessary test files. Follow the exact log recipe: `HEAD=<full SHA>` first, named result, `EXIT=<status>` last. Accepted logs contain no skipped/TODO/cancelled tests. Run base checks honestly; use an explicit `base_exempt` reason for unchanged behavior such as sandbox portability whose base test rightly passes.
4. Create one independently generated screenshot per local AC (real browser result for a visual AC; render the actual run log in a pre page and capture PNG for a nonvisual AC). All cited artifacts must be inside your own evidence folder. Source stays unchanged.
5. AC13: `accepted: false`, `not_run: "live: Justin must convert his Figma Trim path test frame, paste and save it in Bricks, then check the live page and phone"`. Do not change live tags or claim installed behavior passed.
6. Write `ac.json` in your own folder, then self-check using an independent copied report/log/image tree in your own scratch and ac-check. Correct format errors while retaining honest results. Clean requires AC1–AC12 accepted; AC13 remains live.

Machine: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Runtime paths/versions and per-gate exits must be recorded. Keep complete long-gate logs and wait for explicit exit markers. Use explicit workdirs. Create all scratch under your own fresh `mktemp -d` root using `mkdir` without `-p`, never reuse any role's scratch, and terminate only processes proven yours. Setup sync is blocked by this session's read-only setup repository even with escalation; do not bypass that boundary.

## Report

Return `{verdict: clean|findings|integration-required, findings: [{id,severity,claim,evidence}], ac_status: [{ac,accepted,test,screenshot,evidence}], head, base, gates, report, skill_lessons: [{skill,lesson,evidence}]}`. Report only new reusable proven lessons, normally an empty list. Never edit skills or memory. Send a concise checkpoint when AC receipts are complete, before a subsequent long gate. End with `MAIN SESSION: check and save these skill_lessons now.`
