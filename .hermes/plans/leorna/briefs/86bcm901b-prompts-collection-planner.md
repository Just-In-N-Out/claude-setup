# PLANNER brief: 86bcm901b-prompts-collection [leorna]

**Role:** PLANNER for the Leorna story "86bcm901b-prompts-collection". Write a plan Justin will approve. **Plan only: no worktree, branch, code edit or commit.** Pipeline: **Full**, which Justin picked on 2026-10-28. Every later role is a fresh Opus 5.5 xhigh agent: builder → reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → finisher.

**Machine:** this runs on Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Mac-only recipes in the skills (osascript Terminal captures, `screencapture`, Homebrew paths) don't apply here: plan this machine's equivalents (`feature-dispatch/references/ac-verification.md`: "Where no image tool exists (the WSL desktop has no PIL or ImageMagick), render the log in a `<pre>` page and screenshot it with the repo's Chrome driver").

## Skills to load first, in this order (say so in your first steps)

1. `leorna`, in the PLANNER role: do its **Step 1 context load** (`$MEM/MEMORY.md`, `$MEM/leorna-workflow.md`, `~/Leorna/leorna-control-plane/AGENTS.md`, the topic notes, then git reality). Here `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory` (the control-plane memory folder is a link to it).
2. `engineering-best-practices`.
3. `implementation-planning`.
4. Each specialist the work needs. You decide; likely candidates: `security-best-practices` (imported third-party prompt text), `api-contract-drift-guard` if OpenAPI changes, `backend-data-migrations` if storage or schema changes, `multi-tenant-auth-management` if any tenant-facing path changes. Name them in a `## Skills` section of the plan. Mark those that end with "Mandatory Validation and Agent Defect Loop": `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`.

## The ask, rewritten

Do ClickUp story **86bcm901b "Curate the reusable prompts collection"** (PI-2, E10 Content Library, Size M, p2-medium, assigned to Justin, status "to do") in **`leorna-control-plane`**. On the card, "Repo: content" means `internal/library/content/` in this repo.

Import the **9 slash commands** from addyosmani/agent-skills (MIT): `build`, `code-simplify`, `constraints`, `plan`, `review`, `ship`, `spec`, `test`, `webperf`. Upstream ships each one as a Claude Code `.md` and a Gemini/Codex `.toml` form. Each becomes a **`prompt` item** (the content kind added by 86bcm9016), imported **through the 86bcm945u upstream sync** with the **source commit recorded**. Each prompt invokes a matching skill; those skills are already on `main` (86bcm9019, PR #92, merged 2026-10-26).

Done means the card's four ACs plus the live check, each proven by a test (or, for the live one, by Justin), the quality gate passing, and the hand-over pack ready (no push, PR or ClickUp post).

**AC3 needs your proposal.** It says each prompt's skills must be "in the same starter pack or flagged as a dependency in the pack builder". The pack builder (86bcm901w) and the starter packs (86bcm901r) **don't exist yet**. Verify that on `origin/main` and in ClickUp, then propose how to meet AC3 now, as a **⭐ question for Justin** with 2–4 lettered options and your recommendation marked. Write the plan as if your ⭐ option were chosen.

**The live AC:** "live run of /review and /spec in Claude Code" (the card's Verify). Justin named it an AC himself: write it as its own AC tagged `(live)` right after its id, e.g. `- AC5 (live): …`. Agents mark it `not_run`; Justin checks it.

### Justin's words (verbatim)

> Story: ClickUp card 86bcm901b "Curate the reusable prompts collection". Run the story pipeline from CLAUDE.md with the Full pipeline (already picked, don't ask).
>
> - Repo: leorna-control-plane. On the card, "content" means internal/library/content/ in this repo.
> - Two other sessions are working in this same repo right now, on 86bcm901a (agent definitions) and 86bcm901j (MCP templates). Work only in your own worktree, ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection, on branch feat/86bcm901b-prompts-collection, created from a freshly fetched origin/main. Never switch the main checkout's branch. Never touch the other stories' worktrees, branches, test databases or evidence folders.
> - The planner lists any files the other stories will probably edit too (delivery/stories.json, the 86bcm945u upstream source and licence attribution, THIRD_PARTY_NOTICES.md) under Risks. Resolve those conflicts at hand-over.
> - Card details: import the 9 agent-skills slash commands (build, code-simplify, constraints, plan, review, ship, spec, test, webperf) as `prompt` items (the kind added in 86bcm9016) through the 86bcm945u upstream sync, with the source commit recorded. The skills these commands invoke are already on main (86bcm9019, PR #92, merged 2026-10-26).
> - AC3 says each prompt's skills must be "in the same starter pack or flagged as a dependency in the pack builder". The pack builder (86bcm901w) and starter packs (86bcm901r) don't exist yet, so the planner proposes how to meet AC3 now as a ⭐ question for me. "Live run of /review and /spec in Claude Code" is a (live) AC.
> - Stop at the plan until I say "go". Never push, open a PR or post to ClickUp unless I say so.

## The card, verbatim

Read it yourself as well: `mcp__clickup__clickup_get_task` with `task_id: 86bcm901b`, `include: ["description","dependencies"]`.

```
## User Story
As an admin, I want a set of approved reusable prompts, so that teams reuse what works instead of reinventing it.

## Context
BASE: agent-skills slash commands - build, code-simplify, constraints, plan, review, ship, spec, test, webperf (Claude Code .md + Gemini/Codex .toml forms, MIT). These map directly onto the new `prompt` kind: each command is a reusable prompt that invokes the matching skill.

## Acceptance Criteria (test-backed)
- [ ] Given the import, then the 9 upstream commands exist as `prompt` items with source commit recorded
- [ ] Given each prompt, then it renders as the native command/prompt form for Claude Code, Codex and Cursor (or is skipped with a reason)
- [ ] Given each prompt, then the skills it invokes are in the same starter pack or flagged as a dependency in the pack builder
- [ ] Given each prompt, then it passed the content quality gate

## Verify
quality-gate CI run + live run of /review and /spec in Claude Code

## Definition of Done
Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.

## Dependencies
Add 'prompt' as a content item kind (end to end) (86bcm9016), Content quality gate (86bcm901u), Upstream content sync + licence attribution (86bcm945u)

## Repo
content

## Size: M
```

## Facts you must verify yourself, not trust

- **Fresh `origin/main`:** fetch it fresh (over HTTPS through `gh` as the `leorna` skill's step 7.1 shows, if the SSH key is locked) and record its SHA in the plan. `refs/remotes/origin/main` is shared with the two sibling sessions, so record the SHA you planned against. **Never touch the main checkout** at `~/Leorna/leorna-control-plane`: no `checkout`, `switch`, `pull`, `reset` or edits there (it's on `main`, behind origin, and other sessions share it). Read `origin/main` with `git show origin/main:<path>` / `git grep … origin/main`, or export it with `git archive origin/main | tar -x -C <your scratch>/src`. If you must run existing tests to understand behaviour, do it in that export.
- **Dependencies on `main`:** check that 86bcm9016 (prompt kind), 86bcm901u (quality gate), 86bcm945u (upstream sync + licence attribution) and 86bcm9019 (the skills, PR #92) are actually merged on `origin/main` (`gh pr list/view` as the active `Justin-Leorna` account, plus the code itself). If something isn't, say exactly what, and make it a question or a stated dependency.
- **Upstream pin:** 9019 imported the skills from addyosmani/agent-skills v0.6.13, commit `aeac41d4d005`. Find out which commit the 945u sync records for the skills now on main, and pin the commands to a stated commit. Say whether it's the same commit as the skills and why that matters (a command and the skill it invokes must agree). Plan how the builder fetches upstream (a clone into its scratch folder, never into a repo) through the 945u sync path.
- **Command → skill map:** for each of the 9 commands, name the skill(s) it invokes and confirm each is in `internal/library/content/` on main. Flag any command whose skill is missing, renamed or excluded by 9019.
- **Native forms (AC2):** find how 9016 renders a `prompt` for Claude Code, Codex and Cursor, and decide per command whether it renders natively or is skipped with a reason.
- **AC3:** confirm 86bcm901w (pack builder) and 86bcm901r (starter packs) are not built (ClickUp status, branches, code), then write the ⭐ question above.
- **Siblings in this repo:** 86bcm901a (agent definitions) and 86bcm901j (MCP templates) are being planned or built by other sessions right now. Look for their plans (`~/.hermes/plans/leorna/86bcm901a-*.md`, `86bcm901j-*.md`), branches (`feat/86bcm901a-*`, `feat/86bcm901j-*`) and worktrees, read only. Never touch their worktrees, branches, test databases or evidence folders. In **Risks**, list every file this story will edit that they will probably edit too, at least `delivery/stories.json`, the 86bcm945u upstream source/lock and licence-attribution files, and `THIRD_PARTY_NOTICES.md`, plus any shared registry, index or catalog file you find. Say for each how the hand-over resolves it (the `leorna` skill's step 7.2 has the `stories.json` append rule). Justin's rule: those conflicts are resolved at hand-over, not by waiting.
- **Test database:** the builder and later roles need a Postgres test database owned by this story only (the fixture guard requires a name ending `_test`). Name it in the plan; never a sibling's.

## What the plan must contain

Save it to **`~/.hermes/plans/leorna/86bcm901b-prompts-collection.md`** and make it self-contained, so a fresh builder can build it without redesigning.

- **Open questions at the top**, right after the title. Each has 2–4 lettered options, each under ~60 characters, with the recommended one marked ⭐. The AC3 question is one of them. Write the plan as if the ⭐ answers were chosen, so that "go" needs no re-plan.
- **Numbered ACs near the top:** AC1–AC4 map one to one to the card's four ACs in card order, then the live AC (e.g. `- AC5 (live): …`). Each AC has **one named test** (the exact test function/name and the command that runs only that test), with the AC and its test name whole on one line (`ac-check.sh` matches plan lines one by one, so a wrapped name rejects the AC). If you add any other AC, mark it **proposed**. AC ids are `AC1`, `AC2`… only, never `AC2a`. Each AC's test must fail on the base commit (or fail to build there); an AC that keeps existing behaviour needs a stated `base_exempt` reason. Say how the card's "quality-gate CI run" is proven locally and what stays NOT VERIFIED until CI runs.
- The playback, the approach, tasks in build order (test-first), the files and areas touched, the choices you made, assumptions, and risks (including the sibling overlaps above).
- **Worktree and branch for the builder:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection` on branch `feat/86bcm901b-prompts-collection`, created by the builder from a freshly fetched `origin/main` (re-fetch at build time and check whether `origin/main` moved in files the plan touches since your SHA). The main checkout is never switched.
- **Evidence capture per AC** as a named build task: what each AC demonstrates, the capture point, and the artifact path under `~/.hermes/plans/leorna/evidence/86bcm901b/` (`ac<n>-<what>.png`, gate logs `gates-<sha7>.txt`). Every AC gets a screenshot; a terminal capture of the run counts when the AC has nothing visual (use this machine's method, see **Machine** above).
- The gates the builder must run (the `leorna` skill's step 4, control plane), with this story's own test database.
- End with a **Docs & records** task naming every file the build and finish will update: the plan copy, `leorna-workflow.md`, the module README note, `delivery/stories.json`, `THIRD_PARTY_NOTICES.md` and the licence attribution if touched, and anything else.

## Rules

- You can't ask Justin anything. Questions go in `questions`.
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
- Never write to ClickUp. Never push or open a PR. Never put server domains, URLs, tenant IDs or tokens in the plan.
- You can't start other agents; a loaded skill's "spawn a subagent" step is the main session's job.
- Keep all scratch in `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-planner/`, created fresh with `mkdir` (no `-p`, so it fails if it already exists), and remove only that folder when you finish. The scratchpad is shared with other agents: never read or touch other folders in it.

## Output (final message)

Return JSON matching `{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}`. `plan_path` and `summary` are required. Write in plain words.
