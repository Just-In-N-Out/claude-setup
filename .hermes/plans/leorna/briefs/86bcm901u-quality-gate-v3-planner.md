# PLANNER brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **PLANNER** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature name `86bcm901u-quality-gate-v3`. Write a plan Justin will approve. **Plan only: make no worktree, branch, code change or commit.** Model: Opus 5.5, effort xhigh. You are a fresh agent; this brief is your whole context.

## 1. Skills to load first (say so in your first steps)

Load each with the Skill tool, in this order:
1. `leorna`: follow it in the **PLANNER** role, including its **Step 1 context load** (shared memory `MEMORY.md`, `leorna-workflow.md`, the control-plane `AGENTS.md`, the topic notes it names for control-plane code, CI and finishing a story: `leorna-control-plane-workflow.md`, `no-ci-changes.md`, `clickup-evidence.md`, `stop-and-show-diff.md`).
2. `engineering-best-practices`
3. `implementation-planning`
4. Specialists: `security-best-practices` (the gate secret-scans content), `api-contract-drift-guard` (the DoD says to update OpenAPI if the API is touched), `backend-data-migrations` (confirm whether a migration is needed). Add any other Hermes skill linked in `~/.claude/skills` that fits what you find.

Give the plan a `## Skills` section naming the skills the builder, reviewers and verifier need. Mark the ones that end with the Agent Defect Loop: check with `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.claude/skills/<name>/SKILL.md` (anchor on the heading; a plain grep false-matches `leorna`).

## 2. The ask

**One line:** build Content quality gate (CI) again from scratch in the control plane: in CI, every content-library item is schema-validated, rendered for Claude Code, Codex and Cursor, and secret-scanned. A render failure for a tool the item says it supports fails CI and names the item and the tool. A passing run produces a per-item compatibility report.

**The card, verbatim** ([Content quality gate (CI)](https://app.clickup.com/t/86bcm901u); E10 - Content Library, PI-2, p1-high, repo control-plane, size M):

> **User Story:** As a product team, I want every library item validated and rendered for each tool in CI, so that we only ship content we can stand behind.
>
> **Context:** Ties into the existing ConfigTransformer per tool. Reuse ideas (MIT) from agent-skills: scripts/lib/skill-lint.js, validate-skills/commands/reference-links/versions, and its evals (evals/cases + graders) for behavioural checks that a skill actually fires.
>
> **Acceptance Criteria (test-backed)**
> - Given a library change, when CI runs, then every item is schema-validated, rendered for Claude Code, Codex and Cursor, and secret-scanned
> - Given a render failure for a declared-supported tool, then CI fails with the item and tool named
> - Given a passing run, then a per-item compatibility report is produced
>
> **Verify:** CI pipeline run on a deliberately broken item (fails) and the real library (passes)
>
> **Definition of Done:** Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
>
> **Dependencies:** Content library format + loader (`86bcm9018`, complete)

**Justin's words (2026-10-24, voice note), verbatim:** "Hey, I need to do a user story. Make sure that you're taking photos for each acceptance criterion. I'll tell you the user story that you'll do. Just go to Clickup. We have an MCP connection there, right? I'll send you the user story, though, the actual one. Content quality gate (CI)". Then, offered "resume the paused v2 build or start over", Justin picked **Start over (v3)**, and picked the **Full** pipeline.

If this rewrite and Justin's words disagree, follow Justin's words.

## 3. Decisions already made (carry them into the plan)

- **Fresh start, v3.** Two earlier local-only attempts exist; leave them exactly as they are and stay **blind to them**. Don't open, read, reuse or modify:
  - branches `feat/86bcm901u-content-quality-gate` (both repos) and `feat/86bcm901u-quality-gate-v2`, and every worktree whose name starts `86bcm901u-` under `~/Leorna/*/.claude/worktrees/`;
  - plans `~/.hermes/plans/leorna/86bcm901u-content-quality-gate.md` and `86bcm901u-quality-gate-v2.md`, the `86bcm901u-*` briefs other than this one, and `~/.hermes/plans/leorna/evidence/86bcm901u*` (except the v3 folder below);
  - their test databases (any `leorna_86bcm901u*` DB).

  The memory notes mention these attempts in status lines; treat that as history, not design input.
- **Pipeline:** Full, every role a fresh Opus 5.5 xhigh agent: planner → builder → fresh reviewer 1 → fixer → fresh reviewer 2 → fixer → fresh read-only verifier → blind AC auditor + `ac-check.sh` → finisher hand-over. **Loop fixer → verifier until every AC is accepted on one head, with no round cap.**
- **CI exception (story-only, Justin 2026-10-22, recorded in memory `no-ci-changes.md`):** this story may change `.github/workflows/*` as far as the gate needs. Existing security and quality gates must not be weakened or removed. Push, PR, remote CI runs, credentials and permission changes stay behind Justin's own words. The `gh` token was last seen without `workflow` scope, so publishing a workflow change may need a user-side auth step; note it, don't plan around it.
- **One screenshot per AC (Justin, 2026-10-23 and again today: "make sure that you're taking photos for each acceptance criterion"; they go to ClickUp).** Make evidence capture a named build task: for each AC, the real state to show, when it's captured, and its path under `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (`ac<n>-<what>.png`, gate logs `gates-<sha7>.txt` with a `.json` receipt holding the exit code). An AC with nothing visual (CI/CLI output) gets a real terminal-window capture of its actual run showing the command, output and exit code (the `leorna` skill's terminal capture recipe). Markdown or job-summary output gets a real rendering, labelled as a local rendering. Never a staged screenshot. Upload to ClickUp only when Justin says "post".
- **Names:** branch `feat/86bcm901u-quality-gate-v3`, worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, evidence `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/`, commits `feat(86bcm901u): …`, identity from git config (never override it).
- **Base:** the builder branches from a freshly fetched `origin/main` (HTTPS through `gh`, per `leorna` step 7.1). GitHub `main` was `6e74ced` (PR #87 integration tiles merged) on 2026-10-24; local `main` in `~/Leorna/leorna-control-plane` is behind it. Plan against the current `origin/main` and record the SHA you planned on.

## 4. What the plan must contain

Save it to **`~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md`**, self-contained so a builder with no other context can build it without redesigning:
- **Open questions at the top**, right after the title: each with 2–4 lettered options (each under about 60 characters), the recommended one marked. Write the rest of the plan as if the recommended options were chosen, so "go" needs no re-plan. You can't ask Justin anything yourself.
- **Numbered acceptance criteria near the top: AC1, AC2, AC3…** (never `AC2a`). The card has ACs, so use them; if you split or add one, mark the new one **proposed**. Tag `(live)` right after the id (`- AC3 (live): …`) only for an AC that only Justin can check (for example something that needs a push or hosted CI). Each AC names its **one test** and the exact command that runs only that test and prints its result by name (e.g. `go test -v -count=1 -run '^TestAC1…$' ./…`). Each test must fail on the base commit (or fail to build against it), or the AC carries a `base_exempt` reason. Say how the card's **Verify** line (broken item fails, real library passes) is shown locally, and what stays NOT VERIFIED until hosted CI runs.
- Playback, approach and design (files and areas, interfaces, data shapes), the parts of the code it touches, tasks in order (test first), the project gates with exact commands (`make check` with the Postgres test DB on the builder's own `_test` database, `bash ./scripts/test-module-add.sh`, CI's golangci-lint version, gitleaks), choices made, assumptions, risks.
- The **evidence task** above (AC → state to show → capture point → path).
- A **Docs & records** task naming every file the build and finish update (module README note, `delivery/stories.json` timing per `leorna`, the plan copy, `leorna-workflow.md` status line, found-else).
- **Overlaps:** other open control-plane work: `86bcm9016` prompt kind (CP PR #85 and client PR #20 open, not merged; worktree `…/worktrees/86bcm9016-prompt-kind`) and `86bcm901v` catalog browser v2 (worktree `…/worktrees/86bcm901v-catalog-browser-v2`, may be in progress in another session). Say whether this story touches the same files and what order is safe. Don't touch their worktrees or DBs.
- An **Other things found** section and a **Skill lessons** section at the end.

## 5. Boundaries

- Read-only everywhere except your plan file. No push, PR, merge, ClickUp write, status change or comment. Never print tokens; never write a server domain, URL or tenant ID. Leave the control plane's untracked `deploy/local/` alone.
- **Found something else?** Don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in the plan's "Other things found".
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer; list only what a future task needs that the skill doesn't already say.
- Write in plain words for a reader on a phone.

## 6. Your report

Return JSON-shaped output: `{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` (`plan_path` and `summary` required), then end your report with the line `MAIN SESSION: check and save these skill_lessons now.`
