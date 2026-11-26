# Role: fixer round 2 (Opus 5.5, high): avif-size (Full pipeline) — two small P3s before the AC checks
Load `receiving-code-review`, `test-driven-development`, the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`). Follow the machine and safety rules in `/home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md` (its review.json part doesn't apply). Offline only; every test with a HOME of its own; TMPDIR ~/.cache/asf2. Plain `git commit`, no author override, no AI or Co-Authored-By lines, never CLAUDE.md; don't push; don't bump BUILD; never bare `git stash`; don't rebase. **Keep it short: about 20 minutes.**

## Start
`git checkout -b avif-size-fixer-2 9b7f70168e49a982fc799adf5acbfe726303a020`. Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/avif-size/review-2/review.json` (clean; two P3s). Approved plan (read-only, amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/avif-size/plan-approved.md`.

## Fix
- **R2-2:** the test named for AC9 in `test/unit/ui-photos.test.ts` (~135) uses only landscape photos, so the amended clause "(and 2560 on its long side)" and the width cap aren't proven by AC9's own test (a mutant dropping the panel's 2560 long-side limit passes it). Add portrait cases to that same named test (a tall photo capped at 1920 wide; a very tall one held to 2560 tall), keep its name exactly; prove the mutant now fails it.
- **R2-1:** make the repo's `docs/plans/2026-11-26-avif-size.md` match `plan-approved.md` (copy the approved text: Q2, R3, R6, AC2, AC4, AC9 and the amendment note), so the repo plan equals the approved copy byte for byte.
Then `npm run check` (9G scope) and every AC test (AC1–AC10 by the plan's names, plus the fixer-1 width tests) on the new head into `/home/justin/.hermes/plans/figma-to-bricks/evidence/avif-size/fixer-2/receipt-<head7>.log` (`HEAD=` first, `ok` lines, `EXIT=` last). Stop at **ready-for-next-review**.

## Report (as text)
New head SHA, both fixes with evidence (mutant log), gates; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
