# djtrees-links: quick plugin fix builder

## Authority and workflow
Justin explicitly says: "Give these two, I don't want the full pipeline again. I know we're doing the full pipeline, but don't do the full pipeline; give it to each agent. Read the cloud.md and all the files you need. I just need a quick plug-in fix, no need for reviews or anything."
This authorizes direct investigation and implementation with tests. No planner, review rounds, verifier/auditor pipeline or formal AC receipts. Do not spawn agents. Finish this quick fix and commit it on your branch; the root session integrates and releases both jobs.

## Location and ownership
Work ONLY in /home/justin/Documents/FigmaToBricksV2/.claude/worktrees/djtrees-links, branch worktree-djtrees-links, base 01b71aa6c878d705b86356970e5c66d07e5bce8a. You are not alone in the codebase: another agent is implementing the other DJ Trees fix in a separate worktree. Do not revert others' edits; accommodate their work. Main stays on main. Do not edit main, bump BUILD, push your branch, or edit CLAUDE.md. Do not edit shared docs/HANDOFF.md in your branch: write your concise handoff to /home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-links/handoff.md for the release step to combine.

## Read and apply
Read the worktree's CLAUDE.md and any applicable AGENTS.md, relevant HANDOFF sections and source/tests/reference samples. Read engineering-best-practices first, systematic-debugging, test-driven-development and git-commit-rules SKILL.md via /home/justin/.agents/skills/. User waiver overrides any review/plan workflow in these skills. Keep this focused and small.
Read /home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md before browser/corpus checks. Use Node 22 and the existing Chrome wrapper. Each agent owns a distinct scratch/evidence folder. /tmp is limited tmpfs: large outputs and Chrome profiles belong under your evidence folder, not shared temp names.

## Inputs
Screenshots and initial debug are in /home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-inputs. Original debug: /mnt/c/Users/Admin/Downloads/figma-to-bricks-debug-landing-page-DJTrees.json. Its build is 2026-10-30.1, page Landing page, selected root Vector 9x4.5. It is PARTIAL: parent chain reaches DJ Tree Service — Homepage (reference-matched), 1440x5121, but only 3 complete text nodes exist. Do not claim this is a full page replay. Inspect what can be reproduced from available actual nodes, and generic fixtures for the general pattern; report the exact missing proof. A replacement full export may arrive; tell root if needed and proceed with independent useful work.

## Required execution
Prove the failing behavior via real plugin conversion with a meaningful generic test, then fix the general rule. No hardcoded DJ Trees labels, IDs, pixel sizes, or names. Keep existing explicit Figma links and visual styles. Run npm run check and appropriate browser/interaction tests; run npm run corpus, documenting missing Mac paths and measuring available local files as the desktop memory requires. Compare known baseline failures rather than calling skipped tests proof. Keep logs concise in /home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-links. Before commit verify correct repo identity and no CLAUDE.md staged; use plain git commit without AI trailers. Stop with code committed, clean worktree, exact SHA and clear handoff (what changed, tests, limitations/live check).
Return skill_lessons [{skill,lesson,evidence,enforce}], normally []: only new reusable proven lessons; never edit skills/memory yourself. End with MAIN SESSION: check and save these skill_lessons now.

## Your responsibility: navigation links and logo
Own the automatic header/footer navigation linking and header logo home-link behavior, plus its focused tests. The FAQ recognition/emitter belongs to the other agent. Communicate any shared-module overlap to root before edits.
The footer screenshot quick-links.png has a title Quick Links then Home, Services, Why Us, Gallery, FAQ, Contact as plain unlinked text. Header screenshot header.png has a tree logo + DJ Tree Service wordmark on the left, and the same six navigation labels horizontally on the right. All menu items should link to their respective website pages and clicking the upper-left logo should go home. Use the existing page-address/site-matching flow. This is a general plugin rule for equivalent navigation groups, not a DJ-specific patch; do not turn arbitrary body labels/headings into links. No mobile navigation redesign.
Justin's words: "First thing we need to fix: do you see these quick links here? I need all these texts hyperlinked to their respective web pages, which the plugin currently doesn't do."
"The third thing we need: the header up, these should all be hyperlinked to their respective pages. Moreover, the DJ Trees logo on the top left should also, when you click it, take you back to the home page."
