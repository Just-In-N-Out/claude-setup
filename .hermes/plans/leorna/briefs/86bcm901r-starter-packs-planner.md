# PLANNER brief: 86bcm901r-starter-packs [leorna]

**Role:** PLANNER for the Leorna story "86bcm901r-starter-packs". Write a plan Justin will approve. **Plan only: no worktree, branch, code edit or commit.** Pipeline: **Full** (the recommended pick, taken under Justin's away grant below). Every later role is a fresh Opus 5.5 xhigh agent: builder → reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → finisher.

**Machine:** this runs on Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Mac-only recipes in the skills (osascript Terminal captures, `screencapture`, Homebrew paths) don't apply here: plan this machine's equivalents (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`: "Where no image tool exists (the WSL desktop has no PIL or ImageMagick), render the log in a `<pre>` page and screenshot it with the repo's Chrome driver", plus its Chrome for Testing flags).

## Skills to load first, in this order (say so in your first steps)

1. `leorna`, in the PLANNER role: do its **Step 1 context load** (`$MEM/MEMORY.md`, `$MEM/leorna-workflow.md`, `~/Leorna/leorna-control-plane/AGENTS.md`, the topic notes, then git reality). Here `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory` (the control-plane memory folder is a link to it). If the story turns out to need client changes, also read `~/Leorna/leorna-client/AGENTS.md`.
2. `engineering-best-practices`.
3. `implementation-planning`.
4. Each specialist the work needs. You decide; likely candidates: `backend-data-migrations` (catalog/pack seeding, any schema change), `api-contract-drift-guard` if OpenAPI changes, `multi-tenant-auth-management` + `security-best-practices` if team assignment or any tenant-facing path changes. Name them in a `## Skills` section of the plan. Mark those that end with "Mandatory Validation and Agent Defect Loop": `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`.

## The ask, rewritten

Do ClickUp story **86bcm901r "Role-based starter packs"** (PI-2, E10 Content Library, Size M, p1-high, assigned to Justin, status "to do"). The card says "Repo: content"; on earlier E10 cards that meant `internal/library/content/` in **`leorna-control-plane`**. Confirm which repo(s) the work lands in; if the card's Verify ("assign starter pack → client sync → files present") needs `leorna-client` changes too, say so and plan them (OpenAPI is the only link between the repos; no cross-repo Go imports).

Ship **role-based starter packs**: curated selections of library items (skills, prompts/commands, agents) per role, available in the catalog on a fresh install, assignable to a team so engineers sync them into Claude Code, Codex and Cursor, and kept on the newest library item versions after each library release.

The card proposes this mapping, **marked "to confirm"**:
- **Backend** = spec-driven-development, planning-and-task-breakdown, incremental-implementation, test-driven-development, api-and-interface-design, code-review-and-quality, debugging-and-error-recovery + /spec /plan /build /test /review
- **Frontend** = frontend-ui-engineering, browser-testing-with-devtools, performance-optimization + web-performance-auditor + /webperf
- **Platform/DevOps** = ci-cd-and-automation, git-workflow-and-versioning, observability-and-instrumentation, shipping-and-launch, deprecation-and-migration + /ship
- **Secure coding (regulated)** = security-and-hardening, code-review-and-quality, doubt-driven-development, documentation-and-adrs, source-driven-development + security-auditor + /review

Since the mapping is unconfirmed, make "which packs and which items" a **⭐ question** (recommend the card's mapping, adjusted only where an item doesn't exist on main, and say exactly which). Check every named item against what is actually on `origin/main` (skills from 86bcm9019; the /commands are `prompt` items from 86bcm901b; `web-performance-auditor` and `security-auditor` look like agent definitions from 86bcm901a). For any item not on main yet, say which sibling story brings it and offer options (wait for that merge / ship the pack without it and add later / …) with a ⭐.

Done means the card's three ACs, each proven by a test (and any AC only Justin can check tagged `(live)`), the gates green, and the hand-over pack ready (no push, PR or ClickUp post).

### Justin's words (verbatim)

> Role-based starter packs. I want you to go into ClickUp and pick out this user story. I won't be on my laptop, so just keep everything going and follow what the recommended agent says.

## Justin's away grant (2026-10-29), recorded

Justin is away from his laptop. He said to keep the pipeline running and go with the **recommended (⭐) options**. So: the plan is approved with every ⭐ answer as soon as you return it, without him reading it first. **Pick ⭐ options that are safe, reversible and within the card's scope**; flag at the top of the plan any ⭐ that narrows, reverses or widens a recorded decision. The grant covers plan choices for this story only, up to the hand-over; it does **not** cover push, PR, merge, ClickUp posts, CI changes, credential changes or server provisioning, and it ends when Justin is back. A `(live)` AC stays owed to him.

## The card, verbatim

Read it yourself as well: `mcp__clickup__clickup_get_task` with `task_id: 86bcm901r`, `include: ["description","dependencies"]`.

```
## User Story
As an admin, I want starter packs per role (e.g. Backend, Platform/DevOps, Frontend, Secure coding for regulated teams), so that I can set up a team in minutes.

## Context
Starter packs are curated selections from the library, built on agent-skills. Proposed mapping (to confirm): Backend = spec-driven-development, planning-and-task-breakdown, incremental-implementation, test-driven-development, api-and-interface-design, code-review-and-quality, debugging-and-error-recovery + /spec /plan /build /test /review. Frontend = frontend-ui-engineering, browser-testing-with-devtools, performance-optimization + web-performance-auditor + /webperf. Platform/DevOps = ci-cd-and-automation, git-workflow-and-versioning, observability-and-instrumentation, shipping-and-launch, deprecation-and-migration + /ship. Secure coding (regulated) = security-and-hardening, code-review-and-quality, doubt-driven-development, documentation-and-adrs, source-driven-development + security-auditor + /review.

## Acceptance Criteria (test-backed)
- [ ] Given a fresh install, then the agreed starter packs are available in the catalog
- [ ] Given a starter pack, when assigned to a team, then engineers sync it successfully in all three tools
- [ ] Given a library item update, then starter packs pick up the new version on the next library release

## Verify
integration test: assign starter pack → client sync → files present

## Definition of Done
Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.

## Dependencies
Curate the skills collection (86bcm9019), Content library format + loader (86bcm9018)

## Repo
content

## Size: M
```

Both dependencies (86bcm9018, 86bcm9019) are **complete** in ClickUp. Card **86bcm902a** "One-click quick start (starter pack → team → sync)" (E11 Pack Builder) depends on this one: read it, read only, so this story's data shape doesn't block it, but don't build any of 902a.

## Facts you must verify yourself, not trust

- **Fresh `origin/main` (Justin, 2026-10-28: "Make sure it pulls the updated main branch"):** fetch it from GitHub **before reading any code** (over HTTPS through `gh` as the `leorna` skill's step 7.1 shows, if the SSH key is locked), confirm `origin/main` equals GitHub's `main` (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`), and record that SHA in the plan. Do the same for `leorna-client` if the plan touches it. `refs/remotes/origin/main` is shared with sibling sessions, so record the SHA you planned against. **Never touch the main checkouts** at `~/Leorna/leorna-control-plane` or `~/Leorna/leorna-client`: no `checkout`, `switch`, `pull`, `reset`, `merge` or edits there (other sessions share them). Read `origin/main` with `git show origin/main:<path>` / `git grep … origin/main`, or export it with `git archive origin/main | tar -x -C <your scratch>/src`. If you must run existing tests to understand behaviour, do it in that export.
- **What "pack", "catalog", "team assignment" and "library release" mean in code today:** find the existing pack model (`internal/pack/`, the seed pack in `internal/pack/seed.go` per 86bcm9018), the library loader and catalog (86bcm9018), how a pack is assigned to a team, how the client syncs a pack into Claude Code, Codex and Cursor, and how library item versions flow into packs on an upgrade. Ground every AC's test in those real paths, with file:line evidence.
- **The pack builder sibling, 86bcm901w ("create pack"):** a worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack` on `feat/86bcm901w-create-pack` (at `5a9aa2f` when seen) exists; its plan is `~/.hermes/plans/leorna/86bcm901w-create-pack.md`. Check with `gh pr list -R LeornaAI/leorna-control-plane --state all` whether its PR is open or merged. Read its plan and branch diff, read only. If starter packs should be built on 901w's pack model or API, say how, and make "build on 901w now vs. wait for its merge vs. use main's existing pack model" a ⭐ question if it isn't settled by its merge state. Never touch that worktree or branch.
- **Other siblings in flight in this repo:** 86bcm901a (agent definitions, `feat/86bcm901a-agent-definitions`), 86bcm901b (prompts collection, `feat/86bcm901b-prompts-collection`), 86bcm901j (MCP templates, `feat/86bcm901j-mcp-templates`). Check each one's PR state and whether the items the starter packs need (the /commands, the two agents) are on main or only on a branch. Read their plans (`~/.hermes/plans/leorna/86bcm901a-agent-definitions.md`, `86bcm901b-prompts-collection.md`, `86bcm901j-mcp-templates.md`), read only. Never touch their worktrees, branches, test databases or evidence folders. In **Risks**, list every file this story will edit that they will probably edit too (at least `delivery/stories.json`, plus any shared registry, index, seed or catalog file you find) and how the hand-over resolves it (the `leorna` skill's step 7.2 has the `stories.json` append rule). Justin's rule: such conflicts are resolved at hand-over, not by waiting.
- **"All three tools" (AC2):** find how a synced pack lands in Claude Code, Codex and Cursor today, which item kinds each tool supports (e.g. a kind a tool can't render is skipped with a reason), and what an automated test can prove locally versus what only a live run on Justin's machine/server proves. If any part only Justin can check, put it in its own AC tagged `(live)` right after its id (e.g. `- AC4 (live): …`) so agents mark it `not_run`; keep the card's AC2 itself test-backed.
- **AC3 ("pick up the new version on the next library release"):** find how library versions and pack item versions relate today (pinned versions? latest?), and whether a tenant-customised pack must be left alone (86bcm9018 AC3: "new item versions are added without overwriting tenant customisations"). Propose the behaviour as a ⭐ question if it isn't settled by existing code.
- **Host prerequisites (WSL):** check `command -v go make gcc golangci-lint govulncheck` and `docker ps` (plus the `leorna-test-pg` container), and CI's pinned linter and govulncheck versions. Anything missing becomes a plan question or a named builder setup step, not a builder discovery (`leorna` step 4).
- **Test database:** the builder and later roles need a Postgres test database owned by this story only (the fixture guard requires a name ending `_test`), e.g. `leorna_86bcm901r_test`, plus a separate one for base-commit baselines. Name them in the plan; never a sibling's.
- **Updating main (memory note `leorna-update-main-before-worktree.md`):** the builder's worktree task must first fetch from GitHub, then fast-forward the main checkout's local `main` (`git -C ~/Leorna/leorna-control-plane merge --ff-only origin/main`; check it has no tracked changes first, and stop if ff-only refuses), then create the worktree from that SHA, and confirm `main`, `origin/main` and the worktree HEAD are the same SHA. Put this in the plan's worktree task. You (the planner) still change nothing in the main checkout.

## What the plan must contain

Save it to **`~/.hermes/plans/leorna/86bcm901r-starter-packs.md`** and make it self-contained, so a fresh builder can build it without redesigning.

- **Open questions at the top**, right after the title. Each has 2–4 lettered options, each under ~60 characters, with the recommended one marked ⭐. The pack-mapping question is one of them. Write the plan as if the ⭐ answers were chosen, so no re-plan is needed.
- **Numbered ACs near the top:** AC1–AC3 map one to one to the card's three ACs in card order; any extra AC (a live check, a failure case the DoD asks for) is marked **proposed**, and a live one is tagged `(live)` right after its id. Each AC has **one named test** (the exact test function and the command that runs only that test, e.g. `go test -v -count=1 -run '^TestAC1…$' ./internal/…`), with the AC and its test name whole on one line (`ac-check.sh` matches plan lines one by one, so a wrapped name rejects the AC). AC ids are `AC1`, `AC2`… only, never `AC2a`. Each AC's test must fail on the base commit (or fail to build there); an AC that keeps existing behaviour needs a stated `base_exempt` reason. For Postgres-backed tests, say which need `LEORNA_TEST_DATABASE_URL`.
- The playback, the approach, tasks in build order (test-first), the files and areas touched (with file:line evidence for the existing code they change), the choices you made, assumptions, and risks (including the sibling overlaps above).
- **Worktree and branch for the builder:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs` on branch `feat/86bcm901r-starter-packs`, created by the builder from a freshly fetched `origin/main` (re-fetch at build time and check whether `origin/main` moved in files the plan touches since your SHA). If the client repo is also touched, the matching client worktree and branch with the same name. The main checkouts are never switched.
- **Evidence capture per AC** as a named build task: what each AC demonstrates, the capture point, and the artifact path under `~/.hermes/plans/leorna/evidence/86bcm901r/` (`ac<n>-<what>.png`, gate logs `gates-<sha7>.txt`). Every AC gets a screenshot; a terminal capture of the run counts when the AC has nothing visual (use this machine's method, see **Machine** above). If the admin console shows the catalog, AC1 gets a real screenshot of the starter packs there.
- The gates the builder must run (the `leorna` skill's step 4, control plane; client too if touched), with this story's own test database, and how CI's pinned tool versions are bound.
- End with a **Docs & records** task naming every file the build and finish will update: the plan copy, `leorna-workflow.md`, the module README note, `delivery/stories.json`, and anything else.

## Rules

- You can't ask Justin anything. Questions go in `questions`, each with a ⭐.
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
- Never write to ClickUp. Never push or open a PR. Never put server domains, URLs, tenant IDs or tokens in the plan.
- You can't start other agents; a loaded skill's "spawn a subagent" step is the main session's job.
- Keep all scratch in `/tmp/claude-1000/-home-justin-Leorna/1702e774-4b7c-428b-9deb-e065f8c49562/scratchpad/86bcm901r-planner/`, created fresh with `mkdir` (no `-p`, so it fails if it already exists), and remove only that folder, by its literal absolute path, when you finish. The scratchpad is shared with other agents: never read or touch other folders in it. `/tmp` is a small RAM tmpfs shared by every session: keep only small files there, and point `TMPDIR` (Go build and test temp), source exports and built binaries at `~/.cache/86bcm901r-planner/` (create it fresh the same way, remove it when done).

## Output (final message)

Return JSON matching `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}`. `plan_path` and `summary` are required. Write in plain words.
