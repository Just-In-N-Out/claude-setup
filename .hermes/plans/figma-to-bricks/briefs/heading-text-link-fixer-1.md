# Role: fixer round 1 (Opus 5.5, high): heading-text-link (Mini pipeline)
Load `receiving-code-review`, `test-driven-development`, `engineering-best-practices`, the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`, `references/pitfalls.md`). Read both repeat-mistakes files first. Follow the machine and safety rules in `/home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md` (its review.json part doesn't apply). Offline only; every test run with a HOME of its own; TMPDIR ~/.cache/htl-f1. Commit to the branch only (plain `git commit -m` or `-F`, no author override, no AI or Co-Authored-By lines, never CLAUDE.md); don't push; don't bump BUILD; never bare `git stash`; don't rebase.

## Start
In your worktree: `git checkout heading-text-link` (head af434fa4). Plan (read-only, AC7 amended with Justin's go): `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/plan-approved.md`. Findings: `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/review-1/review.json` (with its probe `figma-mixed-probe.ts` and shots there).

## Fix (verify each first; test first)
- **R1-1 (P2):** a Figma heading that is all one link and holds a coloured run (`<span style="color:…">`) draws differently: Bricks' `.brxe-text-link span{display:inline-flex}` makes the span a flex box (space lost at its edge, wraps as one block; 9.47 px at 1440, "repairservices"). Keep spans inside the plugin's Text link inline (a setting or the smallest rule Bricks' own CSS allows; never `display` in an element's own Custom CSS, CLAUDE.md), and add a linked heading with a coloured run, the space inside the run, to `test/fixtures/heading-link-figma.ts` so AC6's receipt covers it (red before the fix, green after). Check the importer side stays 0 px.
- **R1-4 (P3, cheap, do it):** rename the four unit AC tests so their printed names equal the plan's quoted names exactly (drop the `ACn ` prefix): `test/unit/site-heading-link.test.ts` (3) and `test/unit/emit-heading-link.test.ts` (1).
- R1-2, R1-3, R1-5: leave (follow-ups), except correct HANDOFF's wrong sentence (R1-5) since it's one line.
Then `npm run check` (9G scope), AC4 and AC6 browser tests, and every AC test on the new head into `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/fixer-1/receipt-<head7>.log` (`HEAD=` first, each AC's `ok` line, `EXIT=` last). Stop at **ready-for-next-review**.

## Report (as text)
New head SHA, each finding fixed/declined with evidence, red/green of the new test, gates; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
