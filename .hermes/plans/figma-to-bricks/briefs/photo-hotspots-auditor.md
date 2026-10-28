# Blind AC AUDITOR (read only) — photo-hotspots (FigmaToBricksV2)

You are a fresh, blind acceptance-criteria auditor. Prove every criterion yourself from the approved plan and source. Change no source or tests, commit nothing, and do not rebase or merge. Do not read any other role's reports, evidence or scratch directories. The main session owns any later fixer.

## Your only feature inputs

- Approved immutable plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`.
- Its recorded later decisions: only the "Justin's answers", "Rulings", "Rulings added or changed at review round 1", "Review round 2 rulings" and any later changed-ruling sections in worktree file `docs/plans/2026-10-26-photo-hotspots.md`. Read those acceptance changes, without reading reports, the ledger or HANDOFF. The approved plan's live check AC12 was renumbered from 3bo to **3bp**.
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`.
- Candidate head: `55f265aab4befefe9600dafc5c74a69adb25aab2`. Confirm HEAD and a fully clean `git status --porcelain --untracked-files=all` before you begin.
- Base: `388191d0a00c5cb6d1885b3b734db91acd3b49a7`; confirm `git -C <worktree> merge-base HEAD main` and report a changed base before using it.
- Your own evidence folder: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/auditor/`. Every receipt you cite must be your own execution and reside in that folder.

## Skills and proof recipe

Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules summary, then `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`. For this blind role, skip any project-context step that would expose prior role reports. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, and the ac.json schema in the header of its `scripts/ac-check.sh`. Do not spawn agents.

1. Derive AC1–AC12 from the immutable plan as qualified by the recorded ruling changes. Do not add ACs or live tags. Independently assess each clause; a passing named test is not by itself proof of an unexercised clause.
2. Run each non-live AC's exact named approved test alone on head, using a log with `HEAD=<full candidate SHA>` first and the actual test exit last as `EXIT=<n>`. Each accepted AC needs that test's own pass line, no skips/TODOs, and a real screenshot (PNG/JPEG/WebP). Capture the real browser result for visual checks, and screenshot the actual terminal log through Chrome for checks with no UI.
3. Run the same test on the pinned base in a separate scratch checkout using head's required test/fixture files, one AC at a time. Source stays at base. Failure must mean the test ran and caught the intended absence/defect or failed to build against new code; a missing runner/test/setup is not proof. For genuine preservation criteria that rightly pass on base, record a justified `base_exempt`. Use your own scratch mutations to challenge clauses the test may miss; report gaps honestly.
4. AC12 is live: `accepted: false`, `not_run: "live: Justin must complete Figma/Bricks/iPhone paste check 3bp and confirm Manual offset"`. Browser emulation cannot accept it. A live criterion that you actually run and see fail is a failure, not unrun.
5. Write your own `auditor/ac.json` and self-check it blind with `ac-check.sh` against separate copies of your own report/logs/images in scratch outside the evidence tree. No hard links or other role's files. Fix format/path/head/test-line problems yourself; report source/test defects instead of editing them. Preserve your self-check result.

## Isolation and machine

You are not alone in this repository. Own only your auditor folder and a fresh scratch area: create a unique parent using `mktemp -d`, then a `photo-hotspots-auditor` subfolder with `mkdir` without `-p`. Never reuse or extract into an existing role's folder, read other features' trees, revert others' edits, or interfere with their processes. Always pass workdir explicitly. The feature worktree stays clean and committed.

Use `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Record actual Node/runtime and each command's true exit. For long checks use tracked processes with complete logs and short polling waits. The configured corpus contains Mac paths: AC11 must execute over the actual available files in your separate scratch tree, preserving the original configuration and qualifying the three unavailable v1 files. Do not claim unavailable files were measured.

Keep a concise `status.txt` in your own folder with the current stage, completed checks with qualifications, and blockers, so the orchestrator can relay progress without inspecting your logs. Send progress messages at meaningful boundaries. Codex pipeline roles run gpt-6.1-sol at xhigh. Setup sync is unavailable even with escalation because its repository is mounted read-only; retain local records without bypassing it.

## Report

Return `{verdict: clean|findings, head, base, findings[], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], skill_lessons[{skill, lesson, evidence}]}`. Clean requires every non-live AC accepted. Do not edit skills or memory; empty skill_lessons is normal. End with `MAIN SESSION: check and save these skill_lessons now.`
