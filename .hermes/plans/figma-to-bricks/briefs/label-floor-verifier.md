# Brief: VERIFIER (read only) for figma-to-bricks feature "label-floor" (Full pipeline)

You are a fresh, read-only verifier. You never saw the build, the reviews or the fixes being made. Change no source; write only into your own evidence folder.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor`, branch `worktree-label-floor`, **head a0c3b2beaa0b52278d70532140438cfad7803d2a** (clean, rebased onto local main).
- **Base commit:** f46f8a20dec5558ce85b246db48ef83c13ca72d2 (`git -C <worktree> merge-base HEAD main`; local main "Build 2026-10-26.1: faq-answer-space").
- **Approved plan (the contract, read-only):** `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md`. AC1–AC15; **AC9 is `(live)`** (Justin's re-paste of Home): mark it `"accepted": false, "not_run": "live: Justin re-pastes Home after the merge (paste check 3bm)"`.
- Worktree plan copy `docs/plans/2026-10-26-label-floor.md` (its "After approval: the reviews' fixes" section), ledger `docs/plans/2026-10-26-label-floor-ledger.md`, HANDOFF section in `docs/HANDOFF.md`.
- **Your folder:** `~/.hermes/plans/figma-to-bricks/evidence/label-floor/verifier/` (receipts, logs, screenshots, `ac.json`). Every receipt your report cites must be inside it. Keep other scratch in your own `<scratchpad>/verifier-label-floor/` folder and remove only that.

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, VERIFIER role; `references/rules-summary.md`, `references/rendering-validation.md`), `engineering-best-practices`, `mutation-testing-discipline`. Then read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → VERIFIER exactly (the run recipe, the head and base logs, screenshots, the `ac.json` format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, and the blind self-check with a `cp` copy).

## What to do
1. **Re-run the gates yourself:** `npm run check`; the browser suite with `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b` (compare failures by name with main's own run on this machine: 12 font-environment failures, names in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`). `npm run corpus` measures nothing on this machine (Mac paths in corpus.json): in a scratch `git archive` copy of head and of base, re-point corpus.json's hydraulics/gro entries to `corpus/files/` to un-skip the corpus unit tests, and compare by test name. Measure the five files directly (hydraulics-home, gro-home, Repairs = repo-root `figma-to-bricks-debug-page-1.json`, inspo, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) with replay and snap at 1728/1440/1366/1300/1280/1200/1100/1024/992/768/480/390/375/360/320; lint no worse than base.
2. **Confirm the reviews' findings are closed and look for regressions the fixes caused.** Review 1 F1–F4 (rulings: `~/.hermes/plans/figma-to-bricks/briefs/label-floor-fixer-1.md`), review 2 R2-F1–R2-F7 (`~/.hermes/plans/figma-to-bricks/evidence/label-floor/review2/review2.json`; rulings in `~/.hermes/plans/figma-to-bricks/briefs/label-floor-fixer-2.md`). Reproduce each finding's probe on head; it must be fixed as ruled.
3. **AC work (ac-verification.md → VERIFIER):** for each AC, run only its own named test on head (`HEAD=` line, `EXIT=` line, its own pass line, no skip) and on the base commit in a separate detached worktree with head's test files checked in (it must fail there, or fail to build against base; an AC that rightly keeps existing behaviour gets `base_exempt` with a reason). For a browser AC, make sure the run says `skipped 0` (without Chrome every browser test silently skips). AC7/AC14/AC15 name corpus measurements: run them as a script that prints a pass line and exits non-zero on failure, so the receipt is checkable. One screenshot per AC (the real result, or a terminal capture for a non-visual AC).
4. Write `verifier/ac.json` and self-check it blind with `ac-check.sh` on a `cp` copy as the reference describes.

## Rules
- Read only: no edits, commits or checkouts in the worktree; `git status --porcelain` must be empty when you finish. Base runs happen in a separate `git worktree add --detach` copy you remove afterwards.
- Other bugs: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; an empty list is normal).

## Return
`{verdict: clean|findings, head, base, findings[{id, severity, claim, evidence}], reviews_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates{}, found_else[], skill_lessons[]}`. `clean` requires every AC accepted, AC9 aside as `not_run`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
