# Role: planner (amendment 1): web-code-page

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, xhigh at Justin's word). Plan only: no product code, no BUILD
bump, no merge, no push, never start other agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never bare `git stash`, leave other worktrees alone. Never load bdryswi.com.

**Skills to load:** the project skill `figma-to-bricks`, `engineering-best-practices`, `implementation-planning`.

## Where you work
The job's copy: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a631038f87d3d7d43`, branch
`web-code-page-build` (tasks 3–6 done: `git log --oneline main..HEAD`). Its plan: `docs/plans/2026-11-04-web-code-page.md`
(approved copy: `~/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md`, AC1–AC12). The job stopped
when Justin's last session ended; it now resumes. Note: local `main` moved since (icon-buttons and rich-text, Build
2026-11-04.8, which touch Rich Text / `emit/rich-text.ts`); say in the plan that the builder rebases on `main` first and
which tasks that affects.

## What changed (Justin, 2026-11-06)
After research (`~/.hermes/plans/figma-to-bricks/evidence/elementor-route/report.md`, read sections 1, 4 and 5), Justin
chose: finish the code method for the whole page, adding two things, then a separate job (elementor-map, its own planner)
builds an Elementor step on top. Add to this plan, as **Amendment 1** with new numbered ACs (AC13, AC14… each with one
named test, marked **proposed**), keeping AC1–AC12 as they are:
1. **The capture keeps Elementor's markers:** the code reader today keeps only a few attributes (`src/core/snapshot/web.ts`
   around line 49, `id href … dir`); it must also keep `class`, `data-id`, `data-element_type`, `data-widget_type` and
   `data-settings` (generic: any `data-*` the plan proves is needed, with a size cap for `data-settings`), so elementor-map
   can join Elementor elements to captured code by id. Nothing in the paste changes because of it (byte-identical paste
   for a capture without them).
2. **The site's alt text comes across** in the code method's paste for every picture (`img alt`, `picture`'s `img`,
   empty alt stays empty = decorative), proven on the generic fixture and on the saved B-Dry page.
Keep the website-importer rules in the repo CLAUDE.md (one real-bug review per job; edge cases to follow-ups). Update the
tasks list so a fresh builder knows what's done and what's next. Commit the plan change on the branch
(`git commit -m "web-code-page plan amendment 1: …"`, no CLAUDE.md staged).

## Return
The plan path and commit, the new ACs one line each, any `(live)` ones, questions with ⭐ answers, `verdict`, `ac_status:
n/a (plan)`.

**skill_lessons rule:** list reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` (enforce: `none` or a
one-line check proposal); never edit skills or memory. Empty is normal. Don't write report files: return text. End with
`MAIN SESSION: check and save these skill_lessons now.`
Desktop memory: SIGTERM/143/137/"Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
sending`); cap heavy runs with `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
