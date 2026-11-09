# Role: planner (plan amendment only): elementor-phone-fit

You are a fresh planner (Opus 5.5, high). Amend the approved plan for one of Justin's decisions; change no source or test,
commit nothing, start no agents. Never edit the main folder or any worktree; never load any live site.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the paragraph "When Justin decides something mid-build that changes an approved AC, a planner amends the plan" — follow it
exactly: Amendments list at the top, changed lines marked, receipts that encode the old expectation named, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id).

## Inputs
- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/plan-approved.md`.
- The in-repo plan at the builder's head: `git show 7b7d345fb0914b97371323294462c0e844a0c928:docs/plans/2026-11-08-elementor-phone-fit.md`
  (branch `elementor-phone-fit-build`, base `7ff9ba4a`), and the AC1 test at that head
  (`git show 7b7d345f:test/web/site-elementor-page-bdry.test.ts`).
- The builder's finding (receipts under `evidence/elementor-phone-fit/builder/`, `ac1/green-head-fresh.log`,
  `ac1/red-base-geometry.log`, `footer-hold/scan.txt`): with the fix, B-Dry's page part is within 1.02 px and the header
  0 px at all 38 widths, but the footer is 51.89 px off at 1025 on head and base alike (widget `f2bd68b`, elementor-map's
  open "Facebook" row: its holder 182 px tall, its `p` 130 px, stretched in a flex row). The AC1 test also needed code
  version ≥ 2 and a fresh v2 stand-in (`builder/ac1/head-fresh/standin-capture.json`).
- **Decision (Justin, 2026-11-08: "Separate job for footer (Recommended)", `builder/justin-ac1.json`):** AC1 becomes:
  header and page part within 2 px at all 38 stand-in widths; the footer within 2 px at every width except that one known
  row (the footer at 1025, widget `f2bd68b`), which must be no worse than base; a separate job (elementor-footer-fit) fixes
  that row.

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/elementor-phone-fit-amended.md` (the whole plan,
   the in-repo text as the base). Don't touch `plan-approved.md`.
2. Say exactly what the AC1 test must change to match (so the builder can align it), and show the regex checks.

## Report (as text)
The amendment, the test change needed, receipts named, the regex check, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
