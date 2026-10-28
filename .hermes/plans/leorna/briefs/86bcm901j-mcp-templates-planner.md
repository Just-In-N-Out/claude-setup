# PLANNER brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full** (Justin picked it; don't revisit).

## Your role

You are the **PLANNER** for ClickUp card **86bcm901j** in `leorna-control-plane`. Write a plan Justin will approve. **Don't build anything:** no code, test, branch, worktree or commit changes, no push, no PR, no ClickUp writes. You may read anything and run read-only commands (git log/show/diff, `go list`, `grep`, `gh pr view`, `gh pr list`), and you may run existing tests read-only if they help you understand the code, from your own scratch folder only.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna`: follow it in the **PLANNER** role, including its **Step 1 context load** (the notes, the repo `AGENTS.md`, the topic notes for control-plane code and finishing a story). On this machine the notes folder `$MEM` is `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory` (the `-home-justin-…` paths link to it).
2. `engineering-best-practices`
3. `implementation-planning`
4. `security-best-practices`: Justin requires it for **every role** on this story, because it handles secrets and ships to every install.
5. Check whether the plan needs `multi-tenant-auth-management`, `api-contract-drift-guard` or `backend-data-migrations` (the control-plane specialists); load the ones the change actually touches and name them in the plan's `## Skills` section. Also mark any skill there that ends with a "Mandatory Validation and Agent Defect Loop" section (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`).

## The request, rewritten

Plan story **86bcm901j "Baseline MCP templates + secure tool configs"** in `leorna-control-plane`. Read the card yourself from ClickUp (read only): load the tool with ToolSearch `select:mcp__clickup__clickup_get_task`, then get task `86bcm901j` for its description, acceptance criteria, Verify, DoD and notes. Never write to ClickUp.

What Justin said about the card (his summary; the card is the source of truth where they differ, and say so if they do):
- On this card, "content" means `internal/library/content/` in this repo.
- Today there is **1 MCP template (`github-mcp`) and 2 tool configs**. A **postgres MCP was removed as incompatible**, so the plan must **record which tools each template supports**.
- **Secrets are never embedded** in the content; they come from the user's environment. **gitleaks must pass.**
- **Defaults are least-privilege and documented.**
- **Each template declares its supported tools, and those declarations are verified** (by a test, not just written down).
- **PR #92** (the skills collection, merged) left a **"github-mcp npx pin"** follow-up in its Assumptions. Read it (`gh pr view 92 -R LeornaAI/leorna-control-plane`) and decide whether that follow-up belongs in this card. If it does, plan it with its own AC; if not, say why in the plan and leave it as a follow-up.

If the card has no acceptance criteria, write your own and mark each **proposed** for Justin to approve with the plan.

### Justin's words (verbatim)

> Story: ClickUp card 86bcm901j "Baseline MCP templates + secure tool configs". Run the story pipeline from CLAUDE.md with the Full pipeline (already picked, don't ask).
>
> - Repo: leorna-control-plane. On the card, "content" means internal/library/content/ in this repo.
> - Two other sessions are working in this same repo right now, on 86bcm901a (agent definitions) and 86bcm901b (prompts collection). Work only in your own worktree, ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates, on branch feat/86bcm901j-mcp-templates, created from a freshly fetched origin/main. Never switch the main checkout's branch. Never touch the other stories' worktrees, branches, test databases or evidence folders.
> - The planner lists any files the other stories will probably edit too (delivery/stories.json, THIRD_PARTY_NOTICES.md) under Risks. Resolve those conflicts at hand-over.
> - Card details: today there is 1 MCP template (github-mcp) and 2 tool configs. A postgres MCP was removed as incompatible, so record which tools each template supports. Secrets are never embedded (they come from the user's environment) and gitleaks must pass. Defaults are least-privilege and documented. Each template declares its supported tools, and they are verified. PR #92's Assumptions left a "github-mcp npx pin" follow-up: the planner checks whether it belongs in this card.
> - This is security-sensitive: every role also loads security-best-practices.
> - Stop at the plan until I say "go". Never push, open a PR or post to ClickUp unless I say so.

## Where to work

- **Worktree (read code here):** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`, created by the main session at `1ee7157` (fresh `origin/main`, fetched 2026-10-28; includes PR #92 and PR #93). The branch has no upstream on purpose. The main checkout `~/Leorna/leorna-control-plane` is on `main`, fast-forwarded to the same `1ee7157` at Justin's request (2026-10-28); still read code in the worktree, and **never switch the main checkout's branch.**
- **Integration branch:** `origin/main`. The base for AC checks is `git -C <worktree> merge-base HEAD origin/main`.
- **Machine:** this is the Windows desktop (Ubuntu under WSL), not the Mac. There is no `osascript`, Terminal.app or `screencapture`, and no PIL or ImageMagick. For an AC with nothing visual, the evidence screenshot is a terminal capture made by rendering the run's log in a `<pre>` HTML page and screenshotting it with headless Chrome (check what Chrome/Chromium the repo or machine has and name it in the plan). Plan evidence capture with that in mind.
- **Your scratch:** create `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-planner/` with `mkdir` (no `-p`, so it fails if it already exists) and keep all scratch there. The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folder when you finish.

## Sibling stories running in parallel (same repo)

- **86bcm901a** (agent definitions) and **86bcm901b** (prompts collection) are being planned and built by other sessions right now, each in its own worktree and branch, with its own test database and evidence folder (`~/.hermes/plans/leorna/evidence/86bcm901a/`, `…/86bcm901b/`). **Never touch** their worktrees, branches, databases or evidence folders.
- Under **Risks**, list every file this story will probably edit that those stories will probably edit too. Justin already named `delivery/stories.json` and `THIRD_PARTY_NOTICES.md`; check for others (a content index, manifest, catalog, embed list, shared test, docs page, CHANGELOG). Say for each how the conflict resolves at hand-over (the `leorna` skill's step 7.2 describes the `delivery/stories.json` append rule). Those conflicts are resolved at hand-over, not now.
- The plan must name a **story-owned test database** for Postgres tests, with a name containing `86bcm901j` and ending in `_test`, so it never collides with the siblings' databases. Check the fixture's reset guard.

## What the plan must contain

Save it to **`~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`**. Make it self-contained, so a fresh builder with no context can build it without redesigning:

1. **Open questions at the top**, right after the title: each with 2–4 short lettered options (A, B, C…, each under about 60 characters), the recommended one marked ⭐. Write the rest of the plan as if every ⭐ option was chosen, so "go" needs no re-plan.
2. **Playback** of the request in plain words, and the current state with file:line evidence (what templates and tool configs exist, how they are loaded, validated, shipped and tested, what happened to the postgres MCP and why).
3. **Numbered acceptance criteria near the top: `AC1`, `AC2`…** (never `AC2a`), each with **one named test**, the test's name whole on one line (`ac-check.sh` matches names line by line, so a wrapped name rejects that AC). Mark ACs you wrote yourself **proposed** (`- AC3 (proposed): …`). Tag `(live)` right after the id only for an AC that only Justin can check (`- AC3 (live): …`); agents can't run those. Each AC's test must fail on the base commit or carry a stated reason why it rightly passes there (a "keeps existing behaviour" AC).
4. **Approach and tasks**, test-first: files and areas, data shapes and interfaces, decisions you made, and one test per AC plus failure cases. Include how "supported tools" are declared and verified, how secrets are kept out (environment-variable references only), what the least-privilege defaults are and where they are documented, and how gitleaks is run as a gate.
5. **Gates** the builder runs, with exact commands: the control-plane `make check` (with the CI-pinned golangci-lint and govulncheck versions bound by absolute path, as the `leorna` skill describes), `bash ./scripts/test-module-add.sh`, gitleaks (find how CI runs it and its pinned version), and the `delivery/stories.json` check, plus anything the content needs (an embed or schema validation test).
6. **Evidence capture as a named build task:** one screenshot per AC (a real UI capture if anything is visual, otherwise a terminal capture as described above), saved to `~/.hermes/plans/leorna/evidence/86bcm901j/` as `ac<n>-<what>.png`, plus per-head gate logs `gates-<sha7>.txt`.
7. **Risks** (sibling overlaps above, security, supply chain, the npx pin decision), **Assumptions**, and the parts of the code it touches.
8. **`## Skills`** section naming the specialist skills the build needs (always `security-best-practices`), marking those with the Agent Defect Loop.
9. **Docs & records** as the last task: every file the build and hand-over update (plan copy, `delivery/stories.json`, any inventory or docs page, `THIRD_PARTY_NOTICES.md` if it applies, the notes in `$MEM` such as `leorna-workflow.md`, the PR text draft, the ClickUp evidence draft).
10. **Other things found** section at the end (see below).

## Rules

- **Other bugs or problems you find:** don't fix them or fold them in. List them in `found_else` (one line each, with evidence and severity) and in the plan's "Other things found" section.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
- You can't ask Justin anything: put questions in the plan's questions section and in `questions`.
- Never print tokens or secrets, and never put a server domain, URL or tenant ID in the plan.
- Plain words: short sentences, no jargon where a plain word works.

## What to return

A short report (plain words) with these fields:
`{name: "86bcm901j-mcp-templates", plan_path, playback, root_cause (n/a for a story, or the postgres-removal background), summary, choices[], questions[{q, options[], recommended}], acs[{id, proposed, live, one_line, test}], risks[], touches[], overlaps (files shared with 86bcm901a / 86bcm901b), npx_pin_decision, found_else[], skill_lessons[]}`.
