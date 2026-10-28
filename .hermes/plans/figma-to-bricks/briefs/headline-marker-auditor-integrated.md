# AC AUDITOR — headline-marker, final integrated candidate

You are a fresh blind AC auditor, source read-only. Prove the approved acceptance criteria independently. Do not spawn agents. Write no project source, tests, records or commits.

## Inputs and ownership

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`.
- Expected clean HEAD: `df32227868452ae93562ad99cad7246e9bc7a52f`.
- Base: `27b787b78d88850cbb9863bb31fcfc840406331c`; confirm the current `git merge-base HEAD main` before running.
- Expected integration tip: `27b787b78d88850cbb9863bb31fcfc840406331c`. The branch has been rebased onto this integration base. This audit independently proves the integrated candidate.
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md` (read-only). AC1–AC13 and their named tests are authoritative; AC13 alone is live.
- Approved amendments: in `docs/plans/2026-10-26-headline-marker.md`, read only the sections `Changed by review fix pass 1` and `Changed by review fix pass 2` as additions to the approved plan. Judge against the approved wording as amended. In particular, AC4 adds LEFT/JUSTIFIED headings starting with styled words; AC5 measures 1.6× against the larger of words' width and line height; AC9 adds 375px, left/right alignment and paint-order controls. The amendments also define the final style/line-end rules and hover behavior.
- Your evidence folder only: `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-df32227/auditor/` (create it fresh).
- You must not read any other role's reports, receipts, evidence folders, ledgers or summaries. Obtain all proof yourself from the approved plan, amendments and checked-out code.
- You are not alone in the codebase. Other chats own slider-autoplay and photo-hotspots. Do not touch their worktrees, evidence, processes or changes. Never revert others' edits.

## Skills

Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its `references/rules-summary.md` and `references/rendering-validation.md`, then `engineering-best-practices`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the schema at the head of its `scripts/ac-check.sh`. Honor the project rules, sandbox constraints and clean-head requirement. Do not perform skill instructions that would spawn another agent: the main session owns all dispatch.

## Work

1. Check the pins and cleanliness. If main moved beyond the known integration tip in relevant shared source before admission, return `integration-required` with the exact changed paths instead of running an expensive pass against newly superseded integration state.
2. Independently prove every clause of AC1–AC12 using each approved named test, with one test run per AC on HEAD and the old code, one screenshot per AC and complete execution receipts. Read the implementation as needed; a green test alone does not prove clauses it omits. Use read-only scratch overlays or exports for additional probes where needed.
3. Follow the exact AC run recipe: `HEAD=<full SHA>` first line, actual named test result, `EXIT=<status>` last line; no skipped/TODO/cancelled test in an accepted receipt. Run base tests in a new, task-owned isolated copy with HEAD's necessary test files. For an unchanged behavior whose test rightly passes on base, record an explicit `base_exempt` reason rather than claiming a failing base run.
4. Take your own real screenshots of visual results; for a nonvisual AC, render its actual log in Chrome and capture a terminal-style PNG. Every cited artifact must be within your own evidence folder and independently created. Do not copy another role's evidence.
5. AC13 is Justin's live paste check 3bo: `accepted: false`, `not_run: "live: Justin must convert his Figma Trim path test frame, paste and save it in Bricks, then check the live page and phone"`. Do not change live tags or claim it passed.
6. Write `auditor/ac.json` in the exact script schema. Self-check it blind using a copied report/log/image tree in your own scratch folder and ac-check; correct formatting slips while preserving original results.

Machine: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Every scratch folder is newly created with `mkdir` without `-p`, under a fresh `mktemp -d` root; never reuse another role's scratch. Long gates keep complete logs with explicit exit markers and must be awaited to completion. Never terminate any process without proving it is your own. Always use an explicit workdir.

## Report

Return `{verdict: clean|findings|integration-required, findings: [{id, severity, claim, evidence}], ac_status: [{ac, accepted, test, screenshot, evidence}], head, base, report, skill_lessons: [{skill, lesson, evidence}]}`. Clean means AC1–AC12 proven; AC13 remains live. List only new, reusable, proven lessons (an empty list is normal), and never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
