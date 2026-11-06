# Role: planner: elementor-map (B-Dry's FAQ as a real Bricks Accordion, look from the captured code)

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, xhigh at Justin's word). Plan only: no product code, no BUILD
bump, no merge, no push, never start other agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never bare `git stash`, leave other worktrees alone. Never load bdryswi.com; no login to any site.

**Skills to load:** the project skill `figma-to-bricks`, `engineering-best-practices`, `implementation-planning`.

## Where you work
You start in your own copy of the repo (from `main`). Write the plan at `docs/plans/2026-11-06-elementor-map.md` and
commit it there (`git commit -m "elementor-map plan: …"`, no CLAUDE.md staged). Report your branch name and commit.

## Why (Justin, 2026-11-06)
Research: `~/.hermes/plans/figma-to-bricks/evidence/elementor-route/report.md` (read it all; its section 5 proposes this
job's first step and AC1–AC9). Justin chose: the code method (`src/core/site/`, `npm run site`, `npm run site:check`)
stays the source of the exact look; Elementor's own element ids and widget types (on the rendered page: `data-id`,
`data-element_type`, `data-widget_type`, `data-settings`, `elementor-element-<id>`) add structure and native widgets, so a
pasted page is editable in Bricks. First proof: B-Dry's FAQ section (the report names it: the ElementsKit accordion,
5 questions plus a picture) becomes one native Bricks Accordion (Nestable) (`reference/bricks/` sample) while every width
stays within `site:check`'s 2 px, offline on the saved 2026-10-29 page.

## Depends on
web-code-page (branch `web-code-page-build`, copy `.claude/worktrees/agent-a631038f87d3d7d43`, plan
`docs/plans/2026-11-04-web-code-page.md`) whose Amendment 1 (being planned now, in parallel) makes the capture keep
`class`, `data-id`, `data-element_type`, `data-widget_type`, `data-settings` and the site's alt text. Plan this job to
build on top of web-code-page's head (say which of its tasks must be done first); read that branch read-only.

## Plan rules
General logic, never one-file fixes (repo CLAUDE.md "Build general logic"): recognise widgets by Elementor's widget type
and structure, never B-Dry's ids, words or class names; a widget with no mapping keeps today's code-method output. Numbered
ACs (AC1…, each one named test, marked **proposed**; the export-file one and the live paste one tagged `(live)` or
"needs Justin's export"). Questions at the top with ⭐ answers. Free and local only (Justin: nothing paid, no paid API).
Website-importer rule: one real-bug review per job; edge cases to follow-ups.

## Return
Plan path, branch and commit, the ACs one line each, `(live)` ones, questions with ⭐ answers, `verdict`, `ac_status: n/a
(plan)`.

**skill_lessons rule:** list reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` (enforce: `none` or a
one-line check proposal); never edit skills or memory. Empty is normal. Don't write report files: return text. End with
`MAIN SESSION: check and save these skill_lessons now.`
Desktop memory: SIGTERM/143/137/"Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
sending`); cap heavy runs with `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
