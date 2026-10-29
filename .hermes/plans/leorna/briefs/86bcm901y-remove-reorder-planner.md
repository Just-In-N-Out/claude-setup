
# PLANNER — leorna-control-plane, story 86bcm901y "Remove and reorder items in a pack version"

Role: PLANNER (Full pipeline). Write a plan; build nothing.

## Away grant (record it in the plan)
Justin is away from his laptop. His standing instruction for this story (2026-10-29): "just keep everything going and follow what the recommended agent says." So the main session will approve your plan with every ⭐ option as soon as it comes back, with no further check from Justin. Consequences for you:
- Make every ⭐ the safe, scoped choice: the one that keeps existing behaviour where it isn't broken, stays inside this story's files, and needs no permission Justin hasn't given. Never ⭐ an option that pushes, opens a PR, posts to ClickUp, provisions servers or touches Justin's real tool homes.
- Write the plan as if every ⭐ were chosen, so the builder can start straight from it.
- Put a short "Away grant" line near the top of the plan quoting Justin's words and saying it covers plan approval and ⭐ answers only. Push, PR, ClickUp posting and merge stay unauthorized.

## Boundary for this run
- Write exactly one file: the plan at `~/.hermes/plans/leorna/86bcm901y-remove-reorder.md`. Nothing else on disk changes: no code or test edits, no commits, no worktree or branch creation, no `make`, no test databases, no ClickUp writes.
- The one exception is the base update below (fetch + fast-forward of the main checkout's `main`).
- Read code in the main checkout `~/Leorna/leorna-control-plane` (on `main`, untracked `.claude/` only) at the base SHA, and read-only in `~/Leorna/leorna-client`. Use Read/Grep/Glob, `git log/show/grep`, `gh api`/`gh pr list` GET requests and ClickUp reads. `go doc` and `go list` are fine; don't run tests or builds.
- Never switch the main checkout's branch. Never touch other stories' worktrees under `.claude/worktrees/`, their branches, test databases or evidence folders.

## Base commit
- Local `main` and `origin/main` were at `6c1709e` (Merge PR #96, 86bcm901w create-pack) when the main session looked; that ref may be stale.
- Do the `leorna` skill's Step 1.5: fetch GitHub's `main` over HTTPS through gh (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, URL written out, never in a variable). If the main checkout is on `main` with no tracked changes, run `git merge --ff-only origin/main` there; stop and report if it refuses. Name the resulting SHA as the plan's base and confirm `main` = `origin/main` = base.
- The builder will create the story worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder` on branch `feat/86bcm901y-remove-reorder` from that base. Make that the plan's first task.

## The ask (rewritten)
Let an admin remove items from a pack and change the order of a pack's items, so they can trim or rearrange a pack without starting over. Each remove or reorder saves a new immutable pack version (ParentVersion set to the version it came from) and writes a change-audit record. When engineers next sync, a removed item's files are removed from their tools (or flagged), consistently with the lockfile; a reordered pack syncs in its new order wherever order matters. Today `applyEdit` in `internal/pack/version_service.go` only replaces or appends.

Justin added reordering himself: the card's ACs only cover removal, but reordering is in scope and needs its own AC and test. He also wants the screenshots to **show the items being changed (reordered) and removed**: real captures of the admin console with the pack's item list before and after a reorder, and before and after a removal, not only terminal captures of test runs. If the admin console has no place to remove or reorder items yet, that UI is part of this story.

## Justin's words (verbatim)
> Remove and reorder items in a pack version I want you to go into ClickUp and pick out this user story. I know the acceptance card only says to remove items, but also to reorder items, make sure the photos the agent takes show them changing items and removing items. I won't be on my laptop, so just keep everything going and follow what the recommended agent says.

## The card (ClickUp 86bcm901y, read 2026-10-29)
- **User story:** As an admin, I want to remove or reorder items in a pack, so that I can trim a pack without starting over.
- **Context:** applyEdit today only replaces or appends (`internal/pack/version_service.go`).
- **Acceptance criteria (test-backed):**
  1. Given a pack version, when I remove an item, then a new version is saved without it and audited
  2. Given a removal, when engineers next sync, then the item's files are removed from their tools (or flagged) consistently with the lockfile
- **Verify:** unit tests + client sync integration test.
- **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- **Dependency:** 86bcm901w "Create a pack by picking library items": complete, merged as PR #96. Nothing blocks this card. Repo: control-plane. Size S. List "E11 - Pack Builder", PI-2. Read 86bcm901w and any cards that depend on 901y from ClickUp (read-only) so the API leaves room for them.

## What earlier work already did (find out before designing)
- 86bcm901w's AC2 already lets an admin add or remove library items on an existing pack, saving a new version with ParentVersion set and an audit record. Its plan (`~/.hermes/plans/leorna/86bcm901w-create-pack.md`, read-only) drew a line for what it left to 901y (reorder, removing files on engineers' machines at sync). Read that line and the merged code, and say plainly in the plan what already exists, what 901y adds, and what of it is new code versus a test proving existing behaviour.
- Card AC2 says "client sync integration test". Find out how the client syncs a pack (in `~/Leorna/leorna-client`, read-only): the lockfile, what happens today to files of an item that left the pack, and whether item order reaches the client at all. Decide which repo each change belongs in. If AC2 needs client code, say so plainly: the card says control-plane, and a client change means a second branch `feat/86bcm901y-remove-reorder` in `leorna-client` with its own gates (client `make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit`). If AC2's client behaviour already exists, its test can be `base_exempt` with a reason, or proven by a new integration test; say which, and why.

## What the plan must contain
- **Skills:** load `leorna` (PLANNER role; do its Step 1 context load, and Step 1.5 as adjusted above), then `engineering-best-practices` and `implementation-planning`. Add the control-plane specialists that apply: likely `security-best-practices` and `multi-tenant-auth-management` (admin-only write API; packs and audit rows stay inside the tenant), `api-contract-drift-guard` (OpenAPI change) and `backend-data-migrations` (any new column, e.g. an item position). Not a bug, so no `systematic-debugging`. Your report says which skills you loaded. The plan gets a `## Skills` section for the build roles, marking any skill that ends with "Mandatory Validation and Agent Defect Loop" (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`), and naming `mutation-testing-discipline` for the immutability, permission and tenant guards.
- **Questions at the top**, right after the title. At most 4, each with 2–4 lettered options under about 60 characters, ⭐ on the recommended one (see the away grant). Say per question what changes if another option were picked. No question for anything a sensible default settles.
- **Numbered ACs `AC1`, `AC2`, …** near the top. AC1 and AC2 in the card's wording (given, not proposed). Add reordering as its own AC, tagged `(Justin)` after its id, e.g. `- AC3 (Justin): Given a pack version, when I reorder its items, then a new version is saved in the new order and audited`, worded so it is testable; cover where the order shows (admin console, API, sync/lockfile output) if it does. Any other AC you add yourself (the DoD's failure case, the admin-console remove/reorder flow) is marked `(proposed)`. Tag an AC `(live)` only if only Justin can check it, right after its id (`- AC5 (proposed) (live): …`). Each AC has exactly one named test, its whole name on one line (`ac-check.sh` matches plan lines one by one, so a wrapped test name rejects that AC).
- **Per AC:**
  - the test name and the command that runs only that test (e.g. `go test -v -count=1 -run '^TestAC1…$' ./internal/pack/...`, with `LEORNA_TEST_DATABASE_URL` for Postgres tests; `node --test --test-name-pattern=…` for admin-console UI tests);
  - why it fails on the base commit (the "old-code check"), or its `base_exempt` reason (3+ words);
  - its evidence: one screenshot per AC plus a log under `~/.hermes/plans/leorna/evidence/86bcm901y/`. **Removal and reorder ACs get captures of the real admin console** showing the item list before and after the change (Justin's ask); name each capture (`ac<n>-<what>-before.png` / `-after.png`) and the capture point. ACs with nothing visual get a terminal capture of the test run. **This machine is the Windows desktop's Ubuntu (WSL2), not the Mac:** no `osascript`, `screencapture`, PIL or ImageMagick. Plan captures that work here: the repo's own admin-console browser test driver if it has one, else Chrome for Testing headless (`~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, run under `env -u DISPLAY -u WAYLAND_DISPLAY`); for a terminal capture, render the log in a `<pre>` page and screenshot it. Check what 86bcm901w's evidence used (`~/.hermes/plans/leorna/evidence/86bcm901w/`, read-only) and reuse that recipe.
- **Design** complete enough that the builder doesn't redesign: API endpoints and request/response shapes (extend what 901w added rather than adding a parallel API, if that fits), how a remove or reorder derives a new version from its parent, how order is stored (existing field or new column + migration), how immutability is enforced, the audit record's action and diff for remove and reorder (reuse 901w's audit), auth and tenant checks, the store and migration changes, the admin-console changes (remove control, reorder control, how they save), and the sync/lockfile behaviour for removed items. Name the existing helpers to reuse, with paths.
- **OpenAPI and the client:** say whether the spec changes and whether `leorna-client` generates code from it and must regenerate. OpenAPI is the only link between the repos; no cross-repo Go imports.
- **Host prerequisites:** check `command -v go make gcc golangci-lint govulncheck` and `docker ps` (the `leorna-test-pg` container) and list the result; anything missing becomes a plan question, not a builder discovery.
- **Tasks** a context-free builder can follow, test-first, starting with creating the worktree from the base and checking it's clean. The gates: `make check` with `LEORNA_TEST_DATABASE_URL` and the builder's own disposable `_test` database (never a sibling's), `bash ./scripts/test-module-add.sh`, the admin-console UI tests the repo has, and CI's pinned golangci-lint and govulncheck versions bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says. Base-commit baselines run in a separate detached worktree with their own `_test` DB. Evidence capture is a named task per AC, with before-state captures taken before the visible change.
- **A Docs & records task:** the module README note, OpenAPI, `delivery/stories.json` (append this story's entry last, as text), the plan copy, the evidence folder and the `leorna-workflow.md` notes.
- **Sibling stories:** run `gh pr list -R LeornaAI/leorna-control-plane --state open` and look at the worktrees under `.claude/worktrees/` (names only; don't read inside them). For each open sibling, read its plan if present (`~/.hermes/plans/leorna/<id>-*.md`, read-only) and list under **Risks** the files it probably edits too (at least `delivery/stories.json`; check the pack service, the OpenAPI spec and the admin console), with how the finisher resolves each at hand-over.
- **Follow-ups, Risks, Assumptions, Other things found.**

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.
- Scratch: none needed in this run. Later roles keep scratch in their own fresh `<scratchpad>/86bcm901y-<role>/` folder (`mkdir` without `-p`) and remove only that folder by its literal absolute path. `/tmp` is a small RAM tmpfs here: big temp files (Go `TMPDIR`, Chrome profiles, binaries) go to `~/.cache/86bcm901y-<role>/`. Put this line in the plan for the builder.
- You can't ask Justin anything and can't start agents: questions go in `questions`, and any skill step that says "spawn a subagent" is run by the main session instead.

## Output (your final message)
1. `plan_path` and the base SHA you planned against (and whether you fast-forwarded local `main`).
2. Playback (1 line) and summary (at most 5 lines).
3. `questions[{q, options[], recommended}]`.
4. The ACs, one line each, with their `(Justin)` / `(proposed)` / `(live)` tags.
5. Which repos change (control plane only, or the client too) and why; OpenAPI/client regeneration: yes or no.
6. Risks, touches, sibling overlaps, skills loaded.
7. `found_else[]` and `skill_lessons[]`.
8. End with `MAIN SESSION: check and save these skill_lessons now.`
