# VERIFIER — headline-marker, final integrated candidate

You are a fresh, read-only verifier. Do not change source/tests/records, commit, merge, push, bump BUILD or spawn agents. Prove AC1–AC13 on the integrated candidate and its integration base. Do not trust earlier agents' conclusions as your proof.

## Pins, acceptance and ownership

- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`.
- Expected clean HEAD `f992469cccbcbd3a33c8355658b359737aa88d95`.
- Expected base and integration tip `70d54085ea034190909846de77ce9e4e57587b1e`. Confirm HEAD, cleanliness, main and `git merge-base HEAD main` at entry. If relevant shared source moved beyond this integration pin, report `integration-required` promptly rather than executing a pass on newly superseded inputs.
- Approved immutable plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`. Judge its numbered AC1–AC13 as amended by `Changed by review fix pass 1` and `Changed by review fix pass 2` in `docs/plans/2026-10-26-headline-marker.md`. AC4 adds LEFT/JUSTIFIED starts with styled words; AC5's 1.6× uses max(words width, line height); AC9 adds 375px, both alignments and paint order. AC13 alone is live, paste check 3bo.
- Your evidence only `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-f992469/verifier/` (create fresh).
- Reviews to confirm closed: reviewer-1 F1–F5 plus decode crash and reviewer-2 R2-F1–F8, reports/dispositions in the feature's existing reviewer/fixer folders. Integrated rebase report `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/finisher-rebase/report.json`; it reports conflict resolution in `src/core/style/style.ts`, `test/unit/sandbox-convert.test.ts`, and `docs/HANDOFF.md`, preserving both features' additions without changed behavior. Verify this independently.
- You are not alone in the codebase. Other chats own slider-autoplay and photo-hotspots. Never touch their worktrees, evidence, processes or edits. Never revert others' changes. Read main only.

## Skills

Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its `references/rules-summary.md` and `references/rendering-validation.md`, then `engineering-best-practices`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the schema in `scripts/ac-check.sh`. Follow the project's sandbox/runtime and verification rules. Main owns all dispatch; do not spawn a subagent for any skill step.

## Verification

1. Re-run `npm run check`, `npm run corpus`, the headline-marker browser file alone (zero skips), and the complete browser suite compared by full test name with the pinned main base. Re-run the corpus-backed unit/performance tests in fresh git-archive trees pointing corpus.json at available `corpus/files/`. Legacy Mac paths are unavailable on WSL; preserve that limit rather than declaring a passing complete legacy corpus run. Compare available Hydraulics/GRO payloads/HTML/reports with the integration base. Replays of hydraulics, GRO, the scratch copy of debug-page-1 and brainstorm must preserve the approved no-regression contract for payloads and warnings (also compare HTML where applicable).
2. Known environment baseline from integration: main browser 360 pass, 12 failures and one skip; candidate adds four passing tests, with exactly the same 12 failure names and skip. Mapped unit head/base 2350/2315 passing, same 36 skips; 35 added passing tests. Performance both 3 pass/3 skips. These are context, never a substitute for your required execution. Do not weaken assertions or waive a newly differing result.
3. Prove every clause of each AC with its own approved named test on HEAD and the pinned base, one AC at a time, in isolated task-owned copies with HEAD's necessary test files. Follow the exact log recipe: `HEAD=<full SHA>` first, named result, `EXIT=<status>` last. Accepted logs contain no skipped/TODO/cancelled tests. Run base checks honestly; use an explicit `base_exempt` reason for unchanged behavior such as sandbox portability whose base test rightly passes.
4. Create one independently generated screenshot per local AC (real browser result for a visual AC; render the actual run log in a pre page and capture PNG for a nonvisual AC). All cited artifacts must be inside your own evidence folder. Source stays unchanged.
5. AC13: `accepted: false`, `not_run: "live: Justin must convert his Figma Trim path test frame, paste and save it in Bricks, then check the live page and phone"`. Do not change live tags or claim installed behavior passed.
6. Write `ac.json` in your own folder, then self-check using an independent copied report/log/image tree in your own scratch and ac-check. Correct format errors while retaining honest results. Clean requires AC1–AC12 accepted; AC13 remains live.

Machine: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Runtime paths/versions and per-gate exits must be recorded. Keep complete long-gate logs and wait for explicit exit markers. Use explicit workdirs. Create all scratch under your own fresh `mktemp -d` root using `mkdir` without `-p`, never reuse any role's scratch, and terminate only processes proven yours. Setup sync is blocked by this session's read-only setup repository even with escalation; do not bypass that boundary.

## Report

Return `{verdict: clean|findings|integration-required, findings: [{id,severity,claim,evidence}], ac_status: [{ac,accepted,test,screenshot,evidence}], head, base, gates, report, skill_lessons: [{skill,lesson,evidence}]}`. Report only new reusable proven lessons, normally an empty list. Never edit skills or memory. Send a concise checkpoint when AC receipts are complete, before a subsequent long gate. End with `MAIN SESSION: check and save these skill_lessons now.`
