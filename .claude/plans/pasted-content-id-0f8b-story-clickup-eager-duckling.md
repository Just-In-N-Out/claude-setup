# 86bcm901a-agent-definitions [leorna-control-plane] — Full pipeline

Status: **planning** (planner dispatched, read-only because plan mode is on). Nothing builds until Justin approves ("go").

## Orchestrator record
- Story: ClickUp 86bcm901a "Curate agent definitions". Pipeline: **Full** (Justin picked).
- Name: `86bcm901a-agent-definitions`. Plan (after approval): `~/.hermes/plans/leorna/86bcm901a-agent-definitions.md`. Evidence: `~/.hermes/plans/leorna/evidence/86bcm901a/`.
- Worktree (builder creates): `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`, from freshly fetched `origin/main`.
- Routing checks 2026-10-28: origin/main = GitHub main = `1ee7157`; deps merged (9018 #82, 945u #89, 901u #90); main checkout on `main`, 4 behind origin/main; story worktree not created yet; setup repo: remote has nothing newer (local is 2 commits ahead, unpushed).
- Plan mode blocks writes, so this file holds the planner brief; after approval it is saved to `~/.hermes/plans/leorna/briefs/86bcm901a-agent-definitions-planner.md`.

## Planner brief (as dispatched)

# PLANNER — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: PLANNER. Write a plan Justin will approve; build nothing.

## Hard boundary for this run: read-only
The main session is in Claude Code plan mode, so you must change nothing on disk. No Write/Edit, no `git fetch/checkout/switch/worktree/branch/commit`, no `go test/build`, no `make` (they write caches), no mkdir or scratch files, no ClickUp writes. Read with Read/Grep/Glob, `git -C ~/Leorna/leorna-control-plane show|grep|ls-tree|log origin/main …`, and `gh api` GET requests. Don't save the plan: return it whole in your final message (see Output). The main session saves it to `~/.hermes/plans/leorna/86bcm901a-agent-definitions.md`.

## The ask (rewritten)
Import the 4 upstream agent definitions (code-reviewer, security-auditor, test-engineer, web-performance-auditor) from the agent-skills repo's `agents/` folder at commit `aeac41d4d005` into the control plane's content library (`internal/library/content/`; on the card, "content" means that folder). Import them through the upstream sync and licence attribution built in story 86bcm945u. Then decide what happens to Leorna's 2 existing demo agents, code-reviewer and test-writer: replace, keep or merge each. That decision is a ⭐ question for Justin.

## Justin's words (verbatim)
> Story: ClickUp card 86bcm901a "Curate agent definitions". Run the story pipeline from CLAUDE.md with the Full pipeline (already picked, don't ask).
> - Repo: leorna-control-plane. On the card, "content" means internal/library/content/ in this repo.
> - Two other sessions are working in this same repo right now, on 86bcm901b (prompts collection) and 86bcm901j (MCP templates). Work only in your own worktree, ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions, on branch feat/86bcm901a-agent-definitions, created from a freshly fetched origin/main. Never switch the main checkout's branch. Never touch the other stories' worktrees, branches, test databases or evidence folders.
> - The planner lists any files the other stories will probably edit too (delivery/stories.json, the 86bcm945u upstream source and licence attribution, THIRD_PARTY_NOTICES.md) under Risks. Resolve those conflicts at hand-over.
> - Card details: import the 4 agents from agent-skills agents/ at commit aeac41d4d005 (code-reviewer, security-auditor, test-engineer, web-performance-auditor) through the upstream sync built in 86bcm945u. For our 2 demo agents (code-reviewer, test-writer), the planner proposes replace, keep or merge for each as a ⭐ question for me. "One live run per agent in Claude Code" is a (live) AC.
> - Dependencies 86bcm9018, 86bcm901u and 86bcm945u are complete.
> - Stop at the plan until I say "go". Never push, open a PR or post to ClickUp unless I say so.

## The card (ClickUp 86bcm901a, read 2026-10-28)
- **User story:** As an admin, I want ready-made agent definitions, so that engineers can delegate common work consistently.
- **Context:** BASE: agent-skills agents/ - code-reviewer, security-auditor, test-engineer, web-performance-auditor (MIT, commit aeac41d4d005). Today Leorna ships 2 demo agents (code-reviewer, test-writer) - merge: upstream code-reviewer replaces ours, test-engineer supersedes test-writer unless ours adds value.
- **Acceptance criteria (test-backed):**
  1. Given the import, then the 4 upstream agents are in the library with source commit recorded
  2. Given overlapping demo agents, then a decision (replace / keep / merge) is recorded for each
  3. Given each agent, then it renders correctly for every tool that supports agents and is skipped with a reason where unsupported
  4. Given each agent, then it passed the content quality gate
- **Verify:** quality-gate CI run + one live run per agent in Claude Code
- **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- **Dependencies (all merged):** 86bcm9018 Content library format + loader, 86bcm901u Content quality gate, 86bcm945u Upstream content sync + licence attribution. Size M.

## Repo state (checked by the main session, 2026-10-28)
- `origin/main` = `1ee7157` (same as GitHub main). Merged: 9018 (#82), 945u (#89), 901u (#90).
- The main checkout `~/Leorna/leorna-control-plane` is on `main`, 4 commits behind `origin/main`. Read code at `origin/main` (`git show origin/main:<path>`, `git grep … origin/main`, `git ls-tree -r origin/main`), not the checkout's files. Never switch its branch.
- The story worktree doesn't exist yet. The builder's first task creates it: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions` on branch `feat/86bcm901a-agent-definitions`, from a freshly fetched `origin/main` (HTTPS fetch through gh, as in the `leorna` skill, step 7.1).
- 945u's plan, for how the upstream sync and attribution work: `~/.hermes/plans/leorna/86bcm945u-upstream-sync.md`.
- Two sibling stories are running in other sessions in this repo: 86bcm901b (prompts collection) and 86bcm901j (MCP templates). Don't read or touch their worktrees, branches, test DBs or evidence folders. Under **Risks**, list the files they'll probably edit too. That's at least `delivery/stories.json`, the 945u upstream source/manifest and licence-attribution files, and `THIRD_PARTY_NOTICES.md`; check for others. Say how the finisher resolves each conflict at hand-over (for `stories.json`: take main's file and append this story's entry last, as text).

## What the plan must contain
- **Skills:** load `leorna` (PLANNER role; do its Step 1 context load), then `engineering-best-practices` and `implementation-planning`. Add any specialist you find applies, e.g. `security-best-practices` (content secret scanning) or `api-contract-drift-guard` only if the API changes. Not a bug, so no `systematic-debugging`. Your report says which skills you loaded. The plan gets a `## Skills` section for the build roles.
- **Questions at the top**, right after the title. At most 4 questions, each with 2–4 lettered options under about 60 characters, with the recommended one marked ⭐. Include one question per demo agent: **code-reviewer** (replace / keep / merge) and **test-writer** (replace / keep / merge). Base the recommendation on the actual content of ours vs upstream: the card suggests upstream code-reviewer replaces ours and test-engineer supersedes test-writer unless ours adds value. Write the plan as if the ⭐ options were chosen, and say per question what changes in tasks and tests if another option is picked.
- **Numbered ACs `AC1`, `AC2`…** near the top. The card's 4 test-backed ACs are given, so use the card's wording and don't mark them proposed. Justin said the card's Verify "one live run per agent in Claude Code" is a live AC: write it as `- ACn (live): …`, tag right after the id. Any AC you add yourself is marked `(proposed)`. Each automated AC has exactly one named test, its whole name on one line (`ac-check.sh` matches plan lines one by one).
- **Per AC:**
  - the test name and the command that runs only that test (e.g. `go test -v -count=1 -run '^TestAC1…$' ./internal/library/...`);
  - why it fails on the base commit, or its `base_exempt` reason;
  - its evidence: one screenshot per AC (a terminal capture when there's nothing visual) and a log, under `~/.hermes/plans/leorna/evidence/86bcm901a/`.
- **Tasks** a context-free builder can follow without redesigning:
  - files and areas, data shapes, and the existing helpers and sync tooling to reuse (with paths);
  - test-first order;
  - the gates: `make check` with `LEORNA_TEST_DATABASE_URL` and an owned `_test` DB, `bash ./scripts/test-module-add.sh`, the library-check quality gate, and CI's pinned golangci-lint and govulncheck versions.
- **Rendering:** from the existing renderer, find which tools support agents and which don't (those are skipped with a reason).
- **The live AC:** how Justin does one live run per agent in Claude Code: what to install, where, what to type, and what "pass" looks like. Don't plan writes into his real `~/.claude` without his OK; propose an isolated route and make it a question if needed.
- **A Docs & records task:** the module README note, `delivery/stories.json`, attribution / THIRD_PARTY_NOTICES, the plan copy, evidence, and the `leorna-workflow.md` notes.
- **Risks** (including the overlap with 901b/901j), **Assumptions**, and **Other things found**.

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.
- Scratch: none in this read-only run. Later roles keep scratch in their own fresh `<scratchpad>/86bcm901a-<role>/` folder (`mkdir` without `-p`) and remove only that.

## Output (your final message)
1. A short report:
   - playback (1 line) and summary (at most 5 lines);
   - `questions[{q, options[], recommended}]`;
   - the ACs, one line each, with their `(live)` / `(proposed)` tags;
   - risks, touches, overlaps with 901b/901j, skills loaded;
   - `found_else[]` and `skill_lessons[]`.
2. The full plan markdown between a line `=====PLAN START=====` and a line `=====PLAN END=====`. The plan's intended path is `~/.hermes/plans/leorna/86bcm901a-agent-definitions.md`.
3. End with `MAIN SESSION: check and save these skill_lessons now.`

## Justin's standing grant (2026-10-28)
Justin's words: "I'm gonna go shower, so just keep this running, okay? Just go with the recommended stuff the agent says, alright?"
- My reading: this counts as **go** for the plan plus every ⭐ answer, once the plan has numbered ACs. Run the Full pipeline (build, review, fix, review, fix, verify, audit, ac-check, then a hand-over draft) without asking again.
- Unchanged: never push, open a PR or post to ClickUp. Live ACs stay owed to Justin. No writes to his real ~/.claude and no credential changes, even if recommended. A question that needs his permission waits for him.
- Ends when the hand-over is ready or when Justin returns and says otherwise.
