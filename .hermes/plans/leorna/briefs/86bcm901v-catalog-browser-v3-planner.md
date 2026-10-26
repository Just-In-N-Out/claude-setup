# PLANNER brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **PLANNER** (Opus 5.5, xhigh). Write a plan Justin will approve. **Don't build anything:** make no worktree, branch, code, test or commit.

## The ask (rewritten)

Build the **Library catalog browser** in the **admin console of `leorna-control-plane`** (ClickUp card `86bcm901v`, epic E11 Pack Builder, PI-2, size M). An admin opens the content library in the admin console and can:
1. filter it by **kind, category, tag and supported tool**, and search it by text;
2. open one item and see its **description, example, version, supported tools and a rendered preview**;
3. keep filtering responsive with **200+ items (<300 ms server time)**.

Done = the three card ACs each pass a named test, with one screenshot per AC, the card's Definition of Done met, and the project gates green. Justin asked specifically for **a screenshot ("photo") for every acceptance criterion**, because they will be uploaded to ClickUp.

This is attempt **v3**. Plan it **from scratch, blind to earlier attempts** (see "Blind to v1 and v2" below).

### Justin's words (verbatim; if this brief and his words disagree, follow his words)

> Hey, I need to do a user story. Make sure that you're taking photos for each acceptance criterion. I'll tell you the user story that you'll do. Just go to Clickup. We have an MCP connection there, right? I'll send you the user story, though, the actual one. Library catalog browser

> do a v3

Then he picked the **Full** pipeline and "Keep going like v2" (see Autonomy).

### The card (verbatim from ClickUp, read 2026-10-24)

```
## User Story
As an admin, I want to browse, search and filter the content library by kind, category and tool, so that I can find what my teams need quickly.

## Context
Today there is no catalog browser; packs are edited as raw items.

## Acceptance Criteria (test-backed)
- [ ] Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text
- [ ] Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview
- [ ] Given 200+ items, then filtering stays responsive (<300 ms server time)

## Verify
UI integration test + manual demo

## Definition of Done
Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.

## Dependencies
Content library format + loader (86bcm9018) — status: complete

## Repo
control-plane

## Size: M
```

Card status in ClickUp shows "in verification": that came from an earlier, superseded attempt. Ignore it; Justin changes ClickUp himself.

## Skills (load them with the Skill tool, in this order, and say so in one line each)

1. `leorna`, in the **PLANNER** role: do its **Step 1 context load** (memory index, `leorna-workflow.md`, `~/Leorna/leorna-control-plane/AGENTS.md`, `leorna-control-plane-workflow.md`, the finishing/evidence notes such as `clickup-evidence.md`, design-call notes) and check reality with git.
2. `engineering-best-practices`.
3. `implementation-planning` (a plan a context-free builder can build without redesigning).
4. Specialists for control-plane work; load each that applies and say which you skipped and why: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` (OpenAPI is touched if the API changes), `backend-data-migrations` (only if storage/schema changes). Add `frontend-ui-repair` or another UI skill only if one exists and fits.

Then check the plan's `## Skills` names for the Agent Defect Loop: `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`, and list matching skills in the plan.

## Blind to v1 and v2

Two earlier attempts exist. **Do not read them**: not their plans, briefs, evidence, branches, worktrees or commits.
- Plans: `~/.hermes/plans/leorna/86bcm901v-library-catalog-browser.md`, `86bcm901v-preview-*.md`.
- Briefs: every `~/.hermes/plans/leorna/briefs/86bcm901v-*` except this file.
- Evidence: `~/.hermes/plans/leorna/evidence/86bcm901v/`, `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v2/`.
- Branches/worktrees: `feat/86bcm901v-library-catalog-browser`, `feat/86bcm901v-catalog-browser-v2`, anything under `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-*`.
- In the shared memory notes (`leorna-workflow.md`, `leorna-control-plane-workflow.md`, `MEMORY.md`), skip the status lines about the earlier 901v / "catalog" attempts. Read everything else normally.

Leave all of those untouched. Plan from the card, the current code on `origin/main` and the project notes.

## Where things go

- **Plan:** `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md`.
- **Branch (for the builder; you don't create it):** `feat/86bcm901v-catalog-browser-v3` from updated `origin/main`, worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`. Commits `feat(86bcm901v): …`.
- **Evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/` (builder evidence at its root; the later verifier writes only in `verifier/`, the blind AC auditor only in `auditor/`).
- **Code to read:** current `origin/main` of `~/Leorna/leorna-control-plane`. The local `main` checkout is 4 commits behind; you may refresh refs with the HTTPS fetch in the `leorna` skill (Doing a story → step 7.1) and read with `git show origin/main:<path>` / `git grep … origin/main`, or a throwaway detached worktree in your scratchpad that you remove afterwards. Do not check out, switch or modify the main working tree (it has untracked `.claude/` and `deploy/local/`, which stay as they are).

## What the plan must contain

Self-contained, so a builder with no context can build it:
- **Open questions at the top**, right after the title: each with 2–4 short lettered options (A, B, C… under ~60 characters), the recommended one marked ⭐. Write the rest of the plan as if every ⭐ were chosen.
- Playback of the request; the approach; the parts of the code it touches (files/areas, interfaces, data shapes, API/OpenAPI changes); decisions and why; risks; assumptions.
- **Numbered acceptance criteria near the top: AC1, AC2, AC3 = the card's three ACs, verbatim in meaning.** Ids are plain `AC1`, `AC2`… (never `AC2a`). If you think an extra AC is needed, add it as `AC4 (proposed): …`. Tag `(live)` right after the id only for an AC that only Justin can check by hand (for example `- AC4 (proposed) (live): …`); an agent-runnable browser check is not live. Don't tag the card's ACs live unless an agent truly cannot check them locally.
- **One named test per AC**, which the verifier and blind auditor will each run alone, on head and on the base commit, per `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (read its "Folders and the run recipe"). So for each AC give: the test's exact name, its file, and the **exact single-test command** that prints its result by name (e.g. `go test -v -count=1 -run '^TestAC1_…$' ./…`, or the UI test runner's equivalent with a name pattern). It must **fail on the base commit** (new code missing) and pass on head; no skipped/TODO subtests. If it needs Postgres, say how (`LEORNA_TEST_DATABASE_URL`, a disposable DB whose name ends in `_test`, never a sibling's DB).
- The card's DoD: unit + integration tests (happy path + at least one failure case), OpenAPI contract updated if the API is touched, lint/format/gitleaks/golangci-lint green, demoable in isolation, short module README note.
- **Evidence capture as a named build task** (`leorna` step 4b, `clickup-evidence.md`): for each AC, the real state to show, when to capture it, and the file name (`ac<n>-<what>.png` in the evidence folder). A visible AC gets a capture of the real admin-console page; a non-visual one (AC3 timing) gets a real terminal-window capture of its actual run (command, output, exit code) plus its log. Say how the builder runs the admin console locally for the screenshots (seeded 200+ items where relevant), with no real server, domain, tenant ID, token or email visible.
- The project gates the builder and reviewers run (`make check` with Postgres verbose evidence, `bash ./scripts/test-module-add.sh`, CI's golangci-lint version bound as the `leorna` skill says, etc.), with the macOS tool prerequisites from the skill.
- End with a **Docs & records** task naming every file the build and finish will update (plan copy, evidence, `leorna-workflow.md` notes, module README, `delivery/stories.json` only after a PR exists, etc.).

## Other work in the same repo

- **Content quality gate (`86bcm901u`, control-plane)** is active in another session: **`86bcm901u-quality-gate-v3`** started planning 2026-10-24 (branch `feat/86bcm901u-quality-gate-v3`), and its v2 (`feat/86bcm901u-quality-gate-v2`, head `2e8b5cd`) is paused. Say in `overlaps` whether this story touches the same files or areas (content library loader/manifest, CI, shared packages), so they can be built in parallel or one after the other. Never touch either one's worktree, branch or databases.
- Peer Claude Code sessions are running; don't stop, message or change anything they own.

## Rules (hard)

- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/workflows/*` edits (no CI exception for this story).
- No auth bypass or dev-login stub; use test fakes. Don't change repo-wide patterns or `toolconnector.Connector`; list them as follow-ups.
- Never write a server domain, URL, tenant ID or token into the plan.
- OpenAPI is the only link between repos; no cross-repo Go imports.

## Autonomy (Justin's grant for this story)

Justin said "Keep going like v2": every ⭐ answer counts as his, and the pipeline runs on through the finisher hand-over without stopping for **go**. So list your questions as usual, but **pick each ⭐ conservatively**: the small, reversible choice that is consistent with the repo's existing patterns and the card's wording. A choice that needs a product decision only Justin can make (scope beyond the card, a permission, a credential) must say so clearly in `questions` and in `summary`; it will be raised with him.

## Found something else?

If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). An empty list is the normal answer; list only what a future task needs that the skill doesn't already say.

## Your final report

Reply with these fields (plain words, short):
`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], acs[{id, text, tags, test_name, test_command}], risks[], touches[], overlaps, defect_loop_skills[], skills_loaded[], found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
