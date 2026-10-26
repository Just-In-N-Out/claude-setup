# PLANNER brief: 86bcm9019-curate-skills [leorna]

**Role:** PLANNER for the Leorna story "86bcm9019-curate-skills". Write a plan Justin will approve. **Plan only: no worktree, branch, code edit or commit.** Pipeline: **Full**, which Justin picked on 2026-10-25. Every later role is a fresh Opus 5.5 xhigh agent: builder → reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → finisher.

## Skills to load first, in this order (say so in your first steps)

1. `leorna`, in the PLANNER role: do its **Step 1 context load** (`$MEM/MEMORY.md`, `$MEM/leorna-workflow.md`, the repo `AGENTS.md`, the topic notes, then git reality).
2. `engineering-best-practices`.
3. `implementation-planning`.
4. Each specialist the work needs. You decide; likely `security-best-practices` for the bundled-script review. Add `api-contract-drift-guard` if OpenAPI changes and `backend-data-migrations` if storage or schema changes. Name them in a `## Skills` section of the plan. Mark those that end with "Mandatory Validation and Agent Defect Loop": `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`.

## The ask, rewritten

Do ClickUp story **86bcm9019 "Curate the skills collection"** (PI-2, E10 Content Library, Size L, p1-high, assigned to Justin, status "to do"). Import the 25 skills from addyosmani/agent-skills (MIT, v0.6.13, commit `aeac41d4d005`) into the Leorna content library. Review each one, and record any Leorna adaptation as a diff against upstream. Security-review bundled scripts and make them Windows-safe (ship with a Windows path, or exclude with a reason). Get every skill through the content quality gate for Claude Code, Codex and Cursor. Replace the 3 current demo skills, or keep them as Leorna-authored skills.

**Justin's words:** "Ok neeed to do this user story it is on clickup Curate the skills collection"

## The card, verbatim

Read it yourself as well: `mcp__clickup__clickup_get_task` with `task_id: 86bcm9019`, `include: ["description","dependencies"]`.

```
## User Story
As an admin, I want a solid set of production-quality skills across common engineering work, so that my teams get real value on day one.

## Context
BASE: addyosmani/agent-skills (MIT) v0.6.13, commit aeac41d4d005 - 25 skills: spec-driven-development, planning-and-task-breakdown, incremental-implementation, test-driven-development, code-review-and-quality, code-simplification, debugging-and-error-recovery, security-and-hardening, api-and-interface-design, frontend-ui-engineering, browser-testing-with-devtools, performance-optimization, observability-and-instrumentation, ci-cd-and-automation, git-workflow-and-versioning, documentation-and-adrs, deprecation-and-migration, shipping-and-launch, context-engineering, source-driven-development, constraint-driven-development, doubt-driven-development, idea-refine, interview-me, using-agent-skills. Same SKILL.md format (name + description frontmatter) Leorna already uses. Import, review, adapt where needed (e.g. Leorna conventions, regulated-industry notes), and replace the 3 demo skills. Shell scripts inside skills (idea-refine.sh) must be reviewed for Windows and security before shipping.

## Acceptance Criteria (test-backed)
- [ ] Given the import, then all 25 upstream skills are in the library with their upstream name, version and source commit recorded
- [ ] Given each imported skill, then it has been reviewed (owner named) and any Leorna adaptation is recorded as a diff against upstream
- [ ] Given skills that bundle scripts, then each script is security-reviewed and either shipped with a Windows-compatible path or excluded with a reason
- [ ] Given each skill, then it has passed the content quality gate in Claude Code, Codex and Cursor
- [ ] Given the 3 current demo skills, then each is either replaced by an upstream equivalent or kept as a Leorna-authored skill

## Verify
quality-gate CI run + manual check of 3 sampled skills in each tool

## Definition of Done
Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.

## Dependencies
Content library format + loader (86bcm9018), Content quality gate (86bcm901u), Multi-file content items (86bcm945q), Upstream content sync + licence attribution (86bcm945u)

## Repo
content

## Size: L
```

## Facts you must verify yourself, not trust

- **Dependencies:** ClickUp shows all four (86bcm9018, 86bcm901u, 86bcm945q, 86bcm945u) as **complete**. But the shared notes said on 2026-10-24 that 901u's **PR #90 was still OPEN**, with a local `stories.json` commit not pushed. Check what is actually merged on `origin/main` in each repo (fresh fetch over HTTPS through `gh`, as the `leorna` skill describes; `gh pr view`) before you plan on top of the loader, the quality gate, multi-file items or the upstream-sync/notices code. If something isn't on main yet, say exactly what, and make it a question or a stated dependency in the plan.
- **Which repo:** the card says "Repo: content". Find where the content library actually lives (leorna-control-plane, leorna-client, or both) from the merged code of the dependency stories, and name it.
- **The 3 demo skills:** find them, name them, and propose for each one: replace with an upstream equivalent, or keep as a Leorna-authored skill.
- **Overlap:** check the sibling cards 86bcm901b "Curate the reusable prompts collection" (to do, unassigned) and 86bcm901r "Role-based starter packs" (depends on this card). Say whether this story touches the same files as any open branch or PR.
- **Upstream source:** pin exactly v0.6.13 / `aeac41d4d005`. Plan how the builder fetches it (a clone into the scratch dir, never into a repo) and how name, version and source commit get recorded. Reuse whatever 945u built for this.

## What the plan must contain

Save it to **`~/.hermes/plans/leorna/86bcm9019-curate-skills.md`** and make it self-contained, so a fresh builder can build it without redesigning.

- **Open questions at the top**, right after the title. Each has 2–4 lettered options, each under ~60 characters, with the recommended one marked ⭐. Write the plan as if the ⭐ answers were chosen, so that "go" needs no re-plan.
- **Numbered ACs near the top, AC1–AC5**, mapped one to one to the card's five ACs in card order, each with **one named test** (the exact test function/name and the command that runs only that test). If you add an AC, mark it **proposed**. Tag `(live)` right after the id for any AC only Justin can check: `- AC4 (live): …` or `- AC6 (proposed) (live): …`. The card's Verify includes a "manual check of 3 sampled skills in each tool" (Claude Code, Codex, Cursor), so decide whether that part is a separate `(live)` AC and say why. AC ids are `AC1`, `AC2`… only, never `AC2a`. Each AC's test must fail on the base commit (or fail to build there). An AC that keeps existing behaviour needs a stated `base_exempt` reason.
- The playback, the approach, tasks in build order (test-first), the files and areas touched, the choices you made, assumptions, and risks. Include licence attribution (MIT notice), script exclusions and Windows handling.
- **Evidence capture per AC** as a named build task: what each AC demonstrates, the capture point, and the artifact path under `~/.hermes/plans/leorna/evidence/86bcm9019/` (`ac<n>-<what>.png`, gate logs `gates-<sha7>.txt`). Every AC gets a screenshot; a terminal capture of the run counts when the AC has nothing visual.
- The gates the builder must run, for each repo touched (from the `leorna` skill's step 4).
- Branch name: `feat/86bcm9019-<short-desc>`, from an updated `main`.
- End with a **Docs & records** task naming every file the build and finish will update: the plan copy, `leorna-workflow.md`, the module README note, `delivery/stories.json` if control-plane, `THIRD_PARTY_NOTICES` if touched, and anything else.

## Rules

- You can't ask Justin anything. Questions go in `questions`.
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. If you list any, end your report with the line `MAIN SESSION: check and save these skill_lessons now.`
- Never write to ClickUp. Never push. Never send server domains, URLs or tenant IDs anywhere outside this Mac.
- Keep your scratch in the scratchpad's `planner-86bcm9019/` subfolder and remove only that.

## Output (final message)

Return JSON matching `{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}`. `plan_path` and `summary` are required. Write in plain words.
