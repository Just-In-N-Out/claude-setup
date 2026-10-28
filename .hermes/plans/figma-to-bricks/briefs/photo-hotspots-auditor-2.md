# Blind AC AUDITOR 2 (read only) — photo-hotspots

You are a fresh, blind AC auditor. Independently prove acceptance from the approved plan and source. Change no source/tests, commit nothing, and do not spawn agents. Never read any other role's reports, receipts, scratch, ledger or HANDOFF, including earlier audits.

## Only feature inputs

- Immutable plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`.
- Later recorded acceptance changes: only "Justin's answers", "Rulings", review-ruling sections and later changed-ruling sections in worktree `docs/plans/2026-10-26-photo-hotspots.md`. Read those plan decisions, not role reports. AC12's live paste check was renumbered 3bo → **3bp**.
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`.
- Candidate: **`6105dde7eb4671f9f74dd77a6ee903ae6b8842a4`**. Confirm HEAD and fully clean `git status --porcelain --untracked-files=all`.
- Base: **`388191d0a00c5cb6d1885b3b734db91acd3b49a7`**. Confirm `merge-base HEAD main`; report unexpected movement.
- Own evidence: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/auditor/round-2/`. Do not read/modify the other files in its parent. Every cited receipt must reside inside your own round-2 directory and come from your execution.

## Skills and work

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its rules summary and relevant rendering-validation reference, plus `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`. Skip any generic context step exposing other role evidence. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the ac.json schema in `scripts/ac-check.sh`.

1. Derive AC1–AC12 and their clauses independently from the immutable plan as qualified by recorded ruling changes. Do not add criteria, live tags, acceptance waivers or changed oracles.
2. Run each non-live AC's exact approved named test alone on head and on a separate pinned-base scratch checkout using head's required test/support/fixture files. Include imported support modules when transplanting tests; a missing test/helper/setup is not a meaningful base failure. One AC at a time: HEAD stamp first, named actual test result, true EXIT last, no skip/TODO. An accepted AC requires head pass and intended base failure, or a justified preservation `base_exempt`.
3. Independently challenge clauses the named test may not exercise. Use fresh generic cases and read-only scratch mutations as needed, preserving every failure and qualifying supplementary versus named-test coverage. Never infer criterion satisfaction merely from a passing test name.
4. Collect a fresh real screenshot per AC: browser result for visual behavior, Chrome screenshot of the actual log for nonvisual checks. Store all receipts inside your own directory; do not copy another role's evidence or inherit its conclusions. Keep capture, replay comparison and mutation exits distinct. AC11 must execute the actual available corpus files in scratch; three v1 Mac files are unavailable, so qualify them rather than claiming they were measured.
5. AC12 is live: `accepted: false`, `not_run: "live: Justin must complete Figma/Bricks/iPhone paste check 3bp and confirm Manual offset"`. Emulation does not prove installed acceptance. A live check actually seen to fail is a failure, not unrun.
6. Write own `round-2/ac.json` and report; self-check blind with `ac-check.sh` against separate scratch copies of your own report/logs/images, no hard links. Correct schema/path/head/pass-line slips without touching source. Preserve the self-check. Clean requires every non-live criterion accepted; report defects for the main session's fixer instead of fixing them.

## Isolation and execution

You are not alone: never revert others' edits, touch sibling worktrees/evidence/processes or reuse another role's scratch. Use `mktemp -d`, then `mkdir` without `-p` for a `photo-hotspots-auditor-2` child. Always specify workdir. The feature worktree stays clean and committed.

Use `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; record actual Node/runtime/PATH and command exits. Track long processes with complete logs and short polling. Keep concise status.txt progress in your own round-2 folder. Setup sync is mounted read-only even with escalation; preserve local records without bypassing it. Codex role: gpt-6.1-sol at xhigh.

Return `{verdict: clean|findings, head, base, findings[], ac_status[], found_else[], skill_lessons[{skill, lesson, evidence}]}`. Do not edit skills/memory; empty lessons are normal. End with `MAIN SESSION: check and save these skill_lessons now.`
