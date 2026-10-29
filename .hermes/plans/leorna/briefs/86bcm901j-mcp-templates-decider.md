# DECIDER brief (read only): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Model: Opus 5.5, xhigh.

## Your role

Justin asked for a fresh agent to **choose the best option for each of the 13 rulings** the build agents made while he was away, plus one open question. You decide; you don't build. **Change nothing:** no edit, commit, push, merge, PR or ClickUp write in any repo. Write only your decisions file (below).

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (skip its Step 1 full context load; read `leorna-workflow.md`'s "Start here" 901j line and `consistency-over-local-fixes.md`, `prefer-small-verified-scope.md` in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`)
2. `engineering-best-practices`
3. `security-best-practices` (required for every role on this story; read its npx/launcher env paragraph)

## Inputs

- **The rulings and the question:** `~/.hermes/plans/leorna/evidence/86bcm901j/handover/rulings-for-justin.md` (13 rulings by builder, fixer 1, fixer 2, fixer 3, and the version-manager question with options A and B).
- **The card and the approved plan:** ClickUp card 86bcm901j (read only: load `mcp__clickup__clickup_get_task` with ToolSearch `select:mcp__clickup__clickup_get_task`); plan `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md` with both "Justin's answers" sections.
- **The code:** worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, head `66449af` (`internal/library/gate/policy.go`, its tests, `internal/library/README.md`, the three content items).
- **Why each ruling was made:** `~/.hermes/plans/leorna/evidence/86bcm901j/INVENTORY.md` (sections per role) and the review/verifier folders `review1/`, `review2/`, `verifier-round1-f368af2/`, `verifier/` (their reports judged every ruling safe; verifier round 2 raised the version-manager question).
- **What changed on main:** GitHub `main` is now `db3406e` (PR #95, 86bcm901b prompts collection, merged). A fixer will merge it in next. Check whether anything on main bears on a ruling (`git -C <worktree> diff 1ee7157 origin/main --stat`, read-only).

## How to decide

For each of the 13 rulings and the question, pick **keep** or **change** (with the exact change in plain words), judged on:
- the card's ACs and the approved plan (secure by default, least privilege, secrets only from the environment, declared and verified tools);
- what engineers using the library actually need (a safe default they can live with, clear failure reasons);
- consistency with the rest of the control plane and the client (`consistency-over-local-fixes.md`), and keeping the story's scope (`prefer-small-verified-scope.md`; no `render/`, OpenAPI, migration, CI or seed changes);
- the cost: every change means a commit, tests and another verifier + auditor round, so change a ruling only when the result is clearly better, not just different.

Rulings 1 and 2 (make and Zig task-local installs) are environment facts, not product choices: say whether anything about them needs to appear in the PR text. For the version-manager question, pick A or B (or a better option, explained).

## Output

Write `~/.hermes/plans/leorna/evidence/86bcm901j/handover/rulings-decided.md`: one section per ruling (number, the ruling in one line, **keep** or **change**, why in one or two lines, and for a change the exact change a fixer must make, with the test that proves it), then the question's answer, then a short "For the fixer" list of every change in build order. Plain words.

## Rules

- **Never touch** other stories' worktrees, branches, databases, evidence or caches; never switch the main checkout's branch. Never print a token.
- **Other bugs:** list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** don't edit any skill or memory file: list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

`{decisions_path, decisions[{n, ruling, choice: keep|change, why, change_detail}], question_choice, changes_for_fixer[], pr_text_notes[], found_else[], skill_lessons[]}`. Plain words.
