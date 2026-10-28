
# PLANNER — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: PLANNER (Full pipeline, already picked by Justin). Write a plan Justin will approve; build nothing.

## Boundary for this run
- Write exactly one file: the plan at `~/.hermes/plans/leorna/86bcm901w-create-pack.md`. Nothing else on disk changes: no code or test edits, no commits, no branch or worktree changes, no `make`, no test databases, no ClickUp writes.
- Read code in this story's worktree, `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack` (branch `feat/86bcm901w-create-pack`, clean, HEAD = base). Use Read/Grep/Glob, `git log/show/grep`, `gh api` GET requests and ClickUp reads. `go doc` and `go list` are fine; don't run tests or builds.
- Never switch the main checkout's branch, and never touch the other stories' worktrees, branches, test databases or evidence folders (see Sibling stories).

## Base commit
- The main session fetched GitHub's `main` over HTTPS through gh on 2026-10-28. `origin/main` = local `main` = **`1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`** (Merge PR #93, 86bcm902y monthly report). Local `main` was already there, so no fast-forward was needed. The story worktree was created from that SHA.
- The `leorna` skill's Step 1.5 tells you to fetch and fast-forward. Do the fetch as it says. If GitHub's `main` is still `1ee7157`, the plan names `1ee7157` as its base. If it moved: fast-forward the main checkout's `main` only while it is on `main` with no tracked changes (stop and report if `--ff-only` refuses), leave the story worktree alone, name the new SHA as the base, say whether the new commits touch this plan's files, and make the builder's first task `git merge --ff-only origin/main` in the worktree (the branch has no commits yet).

## The ask (rewritten)
Let an admin create a new pack by ticking items on the admin console's library page (built in 86bcm901v) and giving it a name. Saving creates the pack at version 1 with exactly the ticked items. Adding or removing library items on an existing pack saves a new immutable version whose ParentVersion points at the version it came from. Every save writes a change-audit record holding the actor, the action and the diff. Today a pack is made by forking the seed pack and editing items one at a time: `applyEdit` in `internal/pack/version_service.go` only replaces or appends. The work covers the API, pack versions, the audit record and the library page in the admin console. Four later cards build on this one (below), so keep the API easy to extend.

## Justin's words (verbatim)
> Story: ClickUp card 86bcm901w "Create a pack by picking library items". Run the story pipeline from CLAUDE.md with the Full pipeline (already picked, don't ask).
> - Repo: leorna-control-plane. That covers the API, pack versions, the audit record and the admin console's library page from 86bcm901v. If the OpenAPI change means the client must regenerate its code, the planner says so in the plan.
> - Start from GitHub's latest main. Fetch origin/main over HTTPS through gh. Fast-forward the main checkout's local main with --ff-only, and only while it is on main with no tracked changes; stop and ask if it refuses. The plan names that SHA as its base.
> - Three other sessions are working in this repo right now: 86bcm901a (agent definitions), 86bcm901b (prompts collection) and 86bcm901j (MCP templates). Work only in your own worktree, ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack, on branch feat/86bcm901w-create-pack, created from that SHA. Never switch the main checkout's branch. Never touch the other stories' worktrees, branches, test databases or evidence folders. Resolve delivery/stories.json conflicts at hand-over.
> - Overlaps to plan around:
>   - 86bcm901b's AC3 wants each prompt's required skills "flagged as a dependency in the pack builder". Don't build that here. The planner names where such a flag would plug in and lists it as a follow-up.
>   - This card's AC2 already removes items from a version. 86bcm901y (next) adds reordering and removing the files on engineers' machines at sync. The planner draws that line clearly.
> - Card details: today a pack is made by forking the seed pack and editing items one at a time; applyEdit in internal/pack/version_service.go only replaces or appends.
>   - AC1: naming a pack and saving the ticked items creates a new pack at version 1 with exactly those items.
>   - AC2: adding or removing items saves a new immutable version with ParentVersion set.
>   - AC3: every save writes an audit record (actor, action, diff).
>   - 86bcm901y and 86bcm902a build on this, so keep the API easy to extend.
> - Its only dependency, 86bcm901v (catalog browser, PR #88), is merged, so nothing blocks this card.
> - Stop at the plan until I say "go". Never push, open a PR or post to ClickUp unless I say so.

## The card (ClickUp 86bcm901w, read 2026-10-28)
- **User story:** As an admin, I want to create a new pack by ticking items in the library and naming it, so that setup takes minutes, not hours.
- **Context:** Today: fork the seed pack and edit/append items one at a time.
- **Acceptance criteria (test-backed):**
  1. Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items
  2. Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set
  3. Given a save, then a change-audit record is written (actor, action, diff)
- **Verify:** unit + integration tests; audit record asserted.
- **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- **Dependency:** 86bcm901v Library catalog browser (merged, PR #88). Size M. List "E11 - Pack Builder", PI-2.
- **Cards that depend on this one** (read each one's text from ClickUp, read-only, so the API and data shapes leave room for them): **86bcm901y**, **86bcm9026**, **86bcm902a**, **86bcm902d**.

## Sibling stories and overlaps
- Running now in other sessions in this repo: **86bcm901a** (agent definitions), **86bcm901b** (prompts collection), **86bcm901j** (MCP templates; worktree `.claude/worktrees/86bcm901j-mcp-templates`). Don't read or touch their worktrees, branches, test DBs or evidence folders. Their plans may appear as `~/.hermes/plans/leorna/86bcm901a-*.md`, `86bcm901b-*.md`, `86bcm901j-*.md`; you may read those files (read-only) to find shared files. Under **Risks**, list the files they will probably edit too. That's at least `delivery/stories.json`; check the library content, the OpenAPI spec, the admin console and anything else. Say how the finisher resolves each at hand-over (for `stories.json`: take main's file unchanged and append this story's entry last, as text, as the `leorna` skill's step 7.2 says).
- **86bcm901b AC3** ("each prompt's required skills flagged as a dependency in the pack builder"): don't build it. Name the exact place (file, type, function, API field) where such a dependency flag would plug in, and list it as a follow-up.
- **86bcm901y**: this card's AC2 removes items from a version on the control plane. 901y adds reordering and removing the files on engineers' machines at sync. Draw that line clearly in the plan: what this card does to item order and to the sync output, and what it leaves for 901y.
- 86bcm901v's plans (`~/.hermes/plans/leorna/86bcm901v-library-catalog-browser.md`, `86bcm901v-catalog-browser-v3.md`) explain the library page this story extends.

## What the plan must contain
- **Skills:** load `leorna` (PLANNER role; do its Step 1 context load, and its "check reality" step as adjusted under Base commit), then `engineering-best-practices` and `implementation-planning`. Add the control-plane specialists that apply: likely `security-best-practices` and `multi-tenant-auth-management` (an admin-only write API; packs and audit rows must stay inside the tenant), `api-contract-drift-guard` (OpenAPI change) and `backend-data-migrations` (any new table or column). Not a bug, so no `systematic-debugging`. Your report says which skills you loaded. The plan gets a `## Skills` section for the build roles, marking any skill that ends with "Mandatory Validation and Agent Defect Loop" (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`), and naming `mutation-testing-discipline` for the immutability, permission and tenant guards.
- **Questions at the top**, right after the title. At most 4, each with 2–4 lettered options under about 60 characters, with the recommended one marked ⭐. Write the plan as if the ⭐ options were chosen, and say per question what changes if another option is picked. No question is needed for anything a sensible default settles.
- **Numbered ACs `AC1`, `AC2`, `AC3`** near the top, in the card's wording (given, so not marked proposed). Any AC you add yourself (for example, the DoD's "1 failure" case or the admin-console ticking flow, if it isn't already inside AC1) is marked `(proposed)`. Tag an AC `(live)` only if just Justin can check it, right after its id (`- AC4 (proposed) (live): …`); the card's Verify suggests none are needed. Each AC has exactly one named test, its whole name on one line (`ac-check.sh` matches plan lines one by one).
- **Per AC:**
  - the test name and the command that runs only that test (e.g. `go test -v -count=1 -run '^TestAC1…$' ./internal/pack/...`, with `LEORNA_TEST_DATABASE_URL` for Postgres tests);
  - why it fails on the base commit `1ee7157` (the "old-code check"), or its `base_exempt` reason;
  - its evidence: one screenshot per AC plus a log under `~/.hermes/plans/leorna/evidence/86bcm901w/`. Where the AC has a visible result (the library page ticking and saving), a capture of the real admin console; otherwise a terminal capture of the test run. **This machine is the Windows desktop's Ubuntu (WSL2), not the Mac:** no `osascript`, `screencapture`, PIL or ImageMagick. Plan captures that work here (headless Chrome via the repo's own browser test driver; for a terminal capture, render the log in a `<pre>` page and screenshot it), and check what the repo's admin-console tests already use.
- **Design** complete enough that the builder doesn't redesign: API endpoints and request/response shapes (extensible for 901y/9026/902a/902d), how a new version is derived from its parent (add/remove by library item id; what happens to order), how immutability is enforced (code and, if fitting, the database), the audit record's shape and where it lives (reuse an existing audit mechanism if the repo has one), auth and tenant checks, the store and migration changes, and the admin-console changes on the library page. Name the existing helpers to reuse, with paths.
- **OpenAPI and the client:** say whether the spec changes, and whether `~/Leorna/leorna-client` (read-only) generates code from it and must regenerate. If it must, say so plainly in the plan as a client follow-up (OpenAPI is the only link between the repos; no cross-repo Go imports).
- **Tasks** a context-free builder can follow, test-first, starting with the worktree check (HEAD = the base, clean). The gates: `make check` with `LEORNA_TEST_DATABASE_URL` and the builder's own disposable `_test` database (never a sibling's), `bash ./scripts/test-module-add.sh`, any admin-console UI tests the repo has, and CI's pinned golangci-lint and govulncheck versions bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says. Base-commit baselines run in a separate detached worktree with their own `_test` DB.
- **A Docs & records task:** the module README note, OpenAPI, `delivery/stories.json`, the plan copy, the evidence folder and the `leorna-workflow.md` notes.
- **Follow-ups:** the 901b dependency-flag plug-in point, the 901y line, any client regeneration.
- **Risks** (including the sibling overlaps), **Assumptions**, and **Other things found**.

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.
- Scratch: none needed in this run. Later roles keep scratch in their own fresh `<scratchpad>/86bcm901w-<role>/` folder (`mkdir` without `-p`) and remove only that.
- You can't ask Justin anything and can't start agents: questions go in `questions`, and any skill step that says "spawn a subagent" is run by the main session instead.

## Output (your final message)
1. `plan_path` and the base SHA you planned against.
2. Playback (1 line) and summary (at most 5 lines).
3. `questions[{q, options[], recommended}]`.
4. The ACs, one line each, with their `(proposed)` / `(live)` tags.
5. OpenAPI/client regeneration: yes or no, and why.
6. Risks, touches, overlaps with 901a/901b/901j and the 901y line, skills loaded.
7. `found_else[]` and `skill_lessons[]`.
8. End with `MAIN SESSION: check and save these skill_lessons now.`
