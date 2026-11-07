# Role: planner (amendment 1, wording only): elementor-map

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, xhigh). Write one small plan amendment; change no source, test or git
state, commit nothing, start no agents. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills to load:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the amendment rules: Amendments list at the top, marked changed lines, no Amendments-list line starting with an AC id, run
`ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes on the old and new plan and check ids, live set and test-name lines are
unchanged) and the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/live-site-reading.md`.

## The finding
elementor-map's verifier 2 (head `ea3d8817`, worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`,
read-only) accepted AC7 but reports its wording is wrong: the approved plan
(`/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`, lines ~74, ~307, ~849) says the saved
B-Dry stand-in shows **every answer closed** and the paste has no `expandItem`. The saved page actually shows the **first**
answer: `$HOME/.hermes/plans/figma-to-bricks/evidence/web-code-proof/inputs/bdry-2026-10-29/css2.css` (offset ~547118) holds
`.ekit-wid-con .show{display:block!important}` and the first panel's class is ` show collapse`. The AC7 test
(`test/web/site-elementor-bdry.test.ts` in that worktree) reads the stand-in and requires `expandItem` to be the answer it
shows (`"0"`), which follows the plan's own open-item rule. Verify this yourself from those files.

## Work
1. Copy the approved plan to `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/planner/amend1/plan.md` and
   amend only the wording about which answer the stand-in shows open and `expandItem` (AC7 and the lines that support it),
   so the text matches the saved page and the test. Change no AC id, no test name, no live tag, nothing else.
2. Add an "Amendment 1" entry at the top (date 2026-11-07, cause: the verifier's finding, the evidence above; the
   pre-amendment text is `plan-approved.md` as moved aside to `plan-approved-v1.md`).
3. Run the regex checks named above on old and new; save their output in `planner/amend1/checks.log`, and
   `diff old new` in `planner/amend1/diff.txt`.

## Report (as text)
What you verified, the changed lines, the check results, then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is
normal; never edit skills or memory), ending with `MAIN SESSION: check and save these skill_lessons now.`
