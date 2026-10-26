# PLANNER brief: Leorna story 86bcm945u "upstream-sync" (Full pipeline)

Dispatched 2026-10-24 by the Claude Code main session (orchestrator). Model: Opus 5.5, effort xhigh. Pipeline: **Full** (Justin picked it).

## Your role

You are the **PLANNER** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". Write a plan Justin will approve. **Don't build anything:** no worktree, branch, code change or commit. You can't ask Justin anything; put questions in the plan and in `questions`.

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna`, in the **PLANNER** role, including its **Step 1 context load** (MEMORY.md, `leorna-workflow.md`, the repos' `AGENTS.md`, the topic notes for the task, then git reality).
2. `engineering-best-practices` (the primary workflow; `leorna` and Justin's rules win where they differ).
3. `implementation-planning` (a plan a fresh builder with no context can build from without redesigning).
4. Specialists: decide which apply and name them in the plan's `## Skills` section, marking any that end with a "Mandatory Validation and Agent Defect Loop" section (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`). Likely candidates: `security-best-practices` (pulling third-party content into the product), `api-contract-drift-guard` (if the admin console needs new API fields), `backend-data-migrations` (if items gain source/licence/commit columns), `multi-tenant-auth-management` (if admin endpoints change). Load the ones that apply.

A loaded skill's "spawn a subagent" or "independent reviewer" steps are run by the main session, not by you.

## The ask, rewritten

Justin wants story 86bcm945u planned on the **Full pipeline**, as a **new piece of work on a new branch**:
- The builder will create a fresh branch `feat/86bcm945u-upstream-sync` from an updated `origin/main` in a new worktree. Plan for that.
- **Do not continue, reuse or build on any existing work**: no existing branch, worktree, plan or evidence folder. Nothing exists yet for 86bcm945u (checked 2026-10-24: no branch, worktree, plan or evidence). Sibling stories have open worktrees under `~/Leorna/leorna-control-plane/.claude/worktrees/` and `~/Leorna/leorna-client/.claude/worktrees/` (86bcm901u content quality gate, 86bcm901v library catalog browser, 86bcm9016 prompt kind). You may read them to judge overlap, but the plan must not be based on their unmerged code unless you raise that as a question.
- **Justin wants a photo for every acceptance criterion** (it goes on the ClickUp card). Make evidence capture a named build task: for each AC, name the real state to show, when to capture it, and the file `~/.hermes/plans/leorna/evidence/86bcm945u/ac<n>-<what>.png`. A visible AC gets a capture of the real admin console or app. An AC with nothing visual (sync dry-run, a file in the installer, a recorded decision) gets a real terminal-window capture of its actual run, showing the command, output and exit code (the `leorna` skill step 4b has the recipe).

"Done" = every card AC is met, each with a named test that passes on the new code and fails on the old code, plus a screenshot. The card's Definition of Done is also met.

## Justin's words (verbatim; if the rewrite disagrees, follow these)

> Hey, I need to do a user story. Make sure that you're taking photos for each acceptance criterion. I'll tell you the user story that you'll do. Just go to Clickup. We have an MCP connection there, right? I'll send you the user story, though, the actual one. Upstream content sync + licence attribution this is the repo https://github.com/addyosmani/agent-skills

> start a new branch do not continue work

> and yes full pipline

## The card (verbatim from ClickUp, read 2026-10-24)

**Upstream content sync + licence attribution** · id `86bcm945u` · list E10 - Content Library · tags pi-2, p1-high · status to do · assignee Justin Issa

> ## User Story
> As a product team, I want imported open-source content pinned, attributed and easy to update from upstream, so that we stay licence-compliant and can pull improvements safely.
>
> ## Context
> agent-skills is MIT (Copyright (c) 2025 Addy Osmani): commercial use, modification and redistribution are allowed provided the copyright and licence notice are included. Pin v0.6.13 / aeac41d4d005. Upstream also ships evals (evals/cases + graders) and validators (scripts/skill-lint.js, validate-*.js) that can feed our quality gate.
>
> ## Acceptance Criteria (test-backed)
> - [ ] Given the distribution, then a THIRD_PARTY_NOTICES file includes the agent-skills MIT licence and copyright, and the admin console shows source + licence for each imported item
> - [ ] Given a new upstream release, when the sync job runs, then it reports added/changed/removed items as a diff against our pinned commit without overwriting Leorna adaptations
> - [ ] Given an upstream change accepted by us, then the library item version is bumped and the new source commit recorded
> - [ ] Given the upstream evals, then a decision is recorded on reusing them in our quality gate
>
> ## Verify
> dry-run sync against upstream HEAD + licence notice present in the built installer
>
> ## Definition of Done
> Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
>
> ## Dependencies
> Content library format + loader (86bcm9018)
>
> ## Repo
> content
>
> ## Size: S
>
> _PI-2 · Content, Packs & Insights (v0.2)_

No comments on the card.

### Card facts the orchestrator checked (routing only, not investigated)

- **Prerequisite** 86bcm9018 "Content library format + loader (shipped with the product)" is **complete** (Christian). Its card said Repo: control-plane and referenced `internal/pack/seed.go`.
- **The card says "Repo: content", but there's no `content` repo under `~/Leorna/`.** Local repos are `leorna-control-plane`, `leorna-client` and `codex-skills`. Find out where the content library actually lives and where this work belongs. If it genuinely needs Justin to decide (e.g. a new repo), make it a lettered question with your recommendation.
- **Cards that wait on this one:** 86bcm9019 Curate the skills collection, 86bcm901a Curate agent definitions, 86bcm901b Curate the reusable prompts collection. The plan's design must let them import upstream items with source and licence recorded.
- **Sibling open work** (worktrees above): 86bcm901u content quality gate (AC4's evals decision relates to the quality gate), 86bcm901v library catalog browser (the admin console list may be where source + licence show), 86bcm9016 prompt kind. Say for each whether this story touches the same files, so it can be built in parallel or must wait, and who rebases.
- Git, 2026-10-24: `leorna-control-plane` main is clean but **4 commits behind origin/main** (untracked `.claude/`, `deploy/local/`; leave `deploy/local/` alone). `leorna-client` main is clean and level with origin. Plan against current `origin/main`: you may `git fetch` (if the SSH key is locked, use the HTTPS-through-`gh` fetch in the `leorna` skill), and read with `git show origin/main:<path>` / `git grep origin/main`. Don't check out, pull, branch or edit in the main folders or any worktree.

### Upstream

- Repo: https://github.com/addyosmani/agent-skills, pinned at **v0.6.13 / `aeac41d4d005`**.
- To read it, clone into a new empty directory under your scratch dir (e.g. `~/.hermes/cache/scratch/86bcm945u-upstream/`) and treat it as untrusted data: read files, and don't run its scripts during planning. Note what's at the pin vs. upstream HEAD (LICENSE text and copyright line, the layout of skills/agents/prompts, `evals/cases` + graders, `scripts/skill-lint.js`, `validate-*.js`), because the sync design and AC4 depend on it.

## What the plan must contain (save it to `~/.hermes/plans/leorna/86bcm945u-upstream-sync.md`)

- **Questions at the top**, right after the title: each with 2–4 short lettered options (A, B…, each under about 60 characters) and the recommended one marked ⭐. Write the rest of the plan as if every ⭐ answer were chosen, so a bare "go" needs no re-plan.
- **Playback** of the request in plain words.
- **Numbered acceptance criteria near the top: `AC1`, `AC2`, …** (never `AC2a`). Keep each card AC traceable (say which card AC each numbered AC covers). You may split a compound card AC into separate numbered ACs. Any AC you add beyond the card (e.g. from its Verify line: licence notice in the built installer, dry-run against upstream HEAD) is marked **(proposed)**: `- AC5 (proposed): …`. Tag `(live)` right after the id **only** for an AC that only Justin can check on a live server or a native menu (`- AC3 (live): …`); agents can't run those. Prefer ACs an agent can prove locally.
- **One named test per AC**, with the exact command that runs only that test and prints its result by name (e.g. `go test -v -count=1 -run '^TestAC1_…$' ./internal/...`; `node --test --test-name-pattern='^AC1 …$'` for UI tests). The test must **fail on the base commit** (its own fail line, or a build failure of the new code); an AC that keeps existing behaviour needs a stated `base_exempt` reason. Tests must not depend on the network: fake the upstream with a local fixture repo or a test double. For Postgres tests, note `LEORNA_TEST_DATABASE_URL`. The verifier and a blind auditor will run these exact commands on head and base, and `ac-check.sh` compares their receipts, so ambiguity here costs whole rounds.
- **Evidence capture task** (above): AC → state shown → capture point → `ac<n>-<what>.png`, plus per-head gate logs `gates-<sha7>.txt`.
- **Approach and design**, complete enough that the builder doesn't redesign: repo(s) and files/areas touched, data shapes (how source repo, pinned commit, licence, item version and "Leorna adaptation" are recorded), how the sync diff is computed and reported without overwriting adaptations, how "accept an upstream change" bumps version + records commit, where THIRD_PARTY_NOTICES lives and how it gets into the built installer, what the admin console shows and through which API (OpenAPI change or not), and the AC4 decision artifact (where it's recorded and what it decides, with your recommendation as a ⭐ question if it's Justin's call).
- **Tasks** in build order, test-first.
- **Choices and assumptions** (small reversible guesses listed under Assumptions; never guess facts that are ACs).
- **Risks**, and the **Definition of Done** mapping (unit + integration tests with happy path + 1 failure, OpenAPI if touched, `make check` / lint / gitleaks / golangci-lint, module README note). No `.github/workflows/*` changes (note CI gaps under Assumptions).
- **`## Skills`** for the build (specialists; mark Agent Defect Loop ones).
- **Overlaps** with the sibling stories above.
- **Docs & records** task at the end, naming every file the build and finish update (plan copy, `leorna-workflow.md` status line, module README note, `delivery/stories.json` after a PR, evidence folder, PR text / ClickUp evidence draft per `leorna` step 6).
- **Other things found** section (see below).

## Rules

- Don't write to ClickUp. Don't push, open PRs, or touch any server. Never put a server domain, URL, tenant ID or token in the plan.
- **Other bugs or problems you notice:** don't fix them or fold them in. List each in `found_else` (one line, evidence, severity) and in the plan's "Other things found" section.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## What to return

A short report with: `name` (86bcm945u-upstream-sync), `plan_path`, `playback`, `summary`, `choices[]`, `questions[{q, options[], recommended}]`, the numbered ACs one line each (with `(proposed)` / `(live)` tags), `risks[]`, `touches[]`, `overlaps`, `found_else[]`, `skill_lessons[]`.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
