
# PLANNER — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: PLANNER (Full pipeline). Write a plan; build nothing. Justin approves the plan with **go** before any build starts.

## Boundary for this run
- Write exactly one file: the plan at `~/.hermes/plans/leorna/86bcm901z-customise-shipped-item.md`. Nothing else on disk changes: no code or test edits, no commits, no worktree or branch creation, no `make`, no test databases, no ClickUp writes.
- The one exception is the base update below (fetch + fast-forward of the main checkout's `main`).
- Read code in the main checkout `~/Leorna/leorna-control-plane` (on `main`, untracked `.claude/` only) at the base SHA, and read-only in `~/Leorna/leorna-client`. Use Read/Grep/Glob, `git log/show/grep` (search with `git grep`, not a recursive `grep -r .`, which also reads sibling stories' worktrees under `.claude/worktrees/`), `gh api`/`gh pr list` GET requests and ClickUp reads. `go doc` and `go list` are fine; don't run tests or builds.
- Never switch the main checkout's branch. Never touch other stories' worktrees under `.claude/worktrees/`, their branches, test databases or evidence folders.

## Base commit
- Do the `leorna` skill's Step 1.5: fetch GitHub's `main` over HTTPS through gh (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, URL written out, never in a variable). If the main checkout is on `main` with no tracked changes, run `git merge --ff-only origin/main` there; stop and report if it refuses. Another session may run the same fetch/fast-forward at the same moment: if git reports a lock (`index.lock`, `cannot lock ref`), wait a few seconds and retry once; never delete a lock file. Name the resulting SHA as the plan's base and confirm `main` = `origin/main` = base.
- The builder will create the story worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item` on branch `feat/86bcm901z-customise-shipped-item` from that base. Make that the plan's first task.

## The ask (rewritten)
Let an admin make a company-owned copy ("variant") of a shipped library item (a skill, agent or prompt), so they can adapt it while staying close to the original. The variant belongs to the tenant and remembers which library item and which version it came from. When the shipped item later gets a newer version, the admin console shows an "update available" notice with a diff, and the admin can merge the upstream change into the variant or ignore it. Inside packs, a variant can be picked, ordered, assigned and synced exactly like a library item.

## Justin's words (verbatim)
> Okay, go to ClickUp and you should see there are two user stories in To Do: customize the shipped item and content usage analytics. Let's do the customized shipped item user story.

(Only this story. "Content usage analytics" is a separate card and not part of this job.)

## The card (ClickUp 86bcm901z, read 2026-10-29)
- **User story:** As an admin, I want to make a company version of a shipped skill/agent/prompt, so that I can adapt it while staying close to the original.
- **Context:** Variants keep a link to the upstream library item and version.
- **Acceptance criteria (test-backed):**
  1. Given a library item, when I customise it, then a tenant-owned variant is created linked to the upstream item + version
  2. Given a newer upstream version, then the admin sees an 'update available' notice with a diff and can merge or ignore
  3. Given a variant, then it is used in packs exactly like a library item
- **Verify:** unit tests for variant lineage + upstream-diff; UI demo.
- **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- **Repo:** control-plane. Size L. List "E11 - Pack Builder", PI-2, priority high, tag pillar-governance.
- **Dependency:** 86bcm901v "Library catalog browser": **complete**.

## Find out before designing
- **What a library item is today.** The shipped content library and its loader (86bcm9018), the curated kinds (skills 9019, prompts 901b, agent definitions 901a, MCP templates 901j) and the catalog browser (901v): how items are identified, how their versions are stored and compared, and how a newer upstream version reaches a running control plane (a new release's embedded content? a reload?). AC2 depends on this: say concretely how "a newer upstream version" happens and how a test produces one.
- **Which kinds can be customised.** The card says skill/agent/prompt. Say whether MCP templates or other kinds are in or out, and why.
- **How packs reference items today** (901w create-pack, 901y remove/reorder, 901r starter packs, 902a quick start, whichever have merged): the pack item shape, pack versions, assignment to teams, and what the client's sync receives (in `~/Leorna/leorna-client`, read-only). AC3 ("exactly like a library item") needs a test that proves a variant goes through the same pack paths, sync included; say whether that is a control-plane integration test or needs client code. If client code changes, say so plainly: the card says control-plane, and a client change means a second branch with its own gates.
- **Merge and ignore.** What "merge" means for a text item whose company copy and upstream both changed (replace, three-way merge, conflict handling), what "ignore" records (that version only, or all future ones), and what the diff shows and against what. Where a real product choice exists, make it a plan question; don't settle it silently.
- **Tenant ownership and auth.** Who can create, edit, merge and delete a variant; that one tenant can never read or change another's variants; and what happens to packs that use a variant when it is deleted or its upstream item is removed.
- **The Verify line's "UI demo".** Decide whether an agent can capture it locally (local control plane, fresh DB, headless admin console). Tag an AC `(live)` only if only Justin can check it.

## What the plan must contain
- **Skills:** load `leorna` (PLANNER role; do its Step 1 context load, and Step 1.5 as adjusted above), then `engineering-best-practices` and `implementation-planning`. Add the control-plane specialists that apply: likely `security-best-practices` and `multi-tenant-auth-management` (admin-only writes; variants stay inside the tenant), `api-contract-drift-guard` (OpenAPI change) and `backend-data-migrations` (new table/columns). Not a bug, so no `systematic-debugging`. Your report says which skills you loaded. The plan gets a `## Skills` section for the build roles, marking any skill that ends with "Mandatory Validation and Agent Defect Loop" (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`), and naming `mutation-testing-discipline` for the permission and tenant guards.
- **Questions at the top**, right after the title. At most 4, each with 2–4 lettered options under about 60 characters, ⭐ on the recommended one. Say per question what changes if another option were picked. No question for anything a sensible default settles. Write the plan as if every ⭐ were chosen, so **go** needs no re-plan.
- **Numbered ACs `AC1`, `AC2`, …** near the top. AC1–AC3 in the card's wording (given, not proposed). Any AC you add yourself (the DoD's failure case, tenant isolation, the UI demo) is marked `(proposed)`. Tag an AC `(live)` only if only Justin can check it, right after its id (`- AC5 (proposed) (live): …`). Each AC has exactly one named test, its whole name on one line (`ac-check.sh` matches plan lines one by one, so a wrapped test name rejects that AC).
- **Per AC:**
  - the test name and the command that runs only that test (e.g. `go test -v -count=1 -run '^TestAC1…$' ./internal/...`, with `LEORNA_TEST_DATABASE_URL` for Postgres tests; `node --test --test-name-pattern=…` for admin-console UI tests);
  - why it fails on the base commit (the "old-code check"), or its `base_exempt` reason (3+ words);
  - its evidence: one screenshot per AC plus a log under `~/.hermes/plans/leorna/evidence/86bcm901z/`. ACs with a visible result get **captures of the real admin console** (the customise action, the variant with its upstream link and version, the update-available notice with its diff, after merge, after ignore, the variant inside a pack); name each capture (`ac<n>-<what>.png`, with `-before`/`-after` where a state changes) and its capture point. ACs with nothing visual get a terminal capture of the test run. **This machine is the Windows desktop's Ubuntu (WSL2), not the Mac:** no `osascript`, `screencapture`, PIL or ImageMagick. Plan captures that work here: the repo's own admin-console browser test driver if it has one, else Chrome for Testing headless (`~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, run under `env -u DISPLAY -u WAYLAND_DISPLAY`); for a terminal capture, render the log in a `<pre>` page and screenshot it. Check what a recent story's evidence used (`~/.hermes/plans/leorna/evidence/86bcm901w/` or `86bcm902a/`, read-only) and reuse that recipe.
- **Design** complete enough that the builder doesn't redesign: the variant's data model and migration; how lineage (upstream item + version) is stored; the API endpoints and request/response shapes (reuse existing library, pack and assignment APIs where they fit rather than adding parallel ones); how the update-available check and diff are computed; merge and ignore semantics and their storage; how a variant enters packs and sync through the same paths as a library item; auth and tenant checks; and the admin-console changes. Name the existing helpers to reuse, with paths.
- **OpenAPI and the client:** say whether the spec changes and whether `leorna-client` generates code from it and must regenerate. OpenAPI is the only link between the repos; no cross-repo Go imports.
- **Host prerequisites:** check `command -v go make gcc golangci-lint govulncheck` and `docker ps` (the `leorna-test-pg` container) and list the result; anything missing becomes a plan question, not a builder discovery.
- **Tasks** a context-free builder can follow, test-first, starting with creating the worktree from the base and checking it's clean. The gates: `make check` with `LEORNA_TEST_DATABASE_URL` and the builder's own disposable `_test` database (never a sibling's), `bash ./scripts/test-module-add.sh`, the admin-console UI tests the repo has, and CI's pinned golangci-lint and govulncheck versions bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says. Base-commit baselines run in a separate detached worktree with their own `_test` DB. Evidence capture is a named task per AC, with before-state captures taken before the visible change.
- **A Docs & records task:** the module README note, OpenAPI, `delivery/stories.json` (append this story's entry last, as text), the plan copy, the evidence folder and the `leorna-workflow.md` notes.
- **Sibling stories:** run `gh pr list -R LeornaAI/leorna-control-plane --state open` and look at the worktrees under `.claude/worktrees/` (names only; don't read inside them). For each open sibling, read its plan if present (`~/.hermes/plans/leorna/<id>-*.md`, read-only) and list under **Risks** the files it probably edits too (at least `delivery/stories.json`; check the library/catalog code, the pack service, the OpenAPI spec, migration numbers and the admin console), with how the finisher resolves each at hand-over.
- **Follow-ups, Risks, Assumptions, Other things found.**

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.
- Scratch: none needed in this run. Later roles keep scratch in their own fresh `<scratchpad>/86bcm901z-<role>/` folder (`mkdir` without `-p`) and remove only that folder by its literal absolute path. `/tmp` is a small RAM tmpfs here: big temp files (Go `TMPDIR`, Chrome profiles, binaries) go to `~/.cache/86bcm901z-<role>/`. Put this line in the plan for the builder.
- You can't ask Justin anything and can't start agents: questions go in `questions`, and any skill step that says "spawn a subagent" is run by the main session instead.

## Output (your final message)
1. `plan_path` and the base SHA you planned against (and whether you fast-forwarded local `main`).
2. Playback (1 line) and summary (at most 5 lines).
3. `questions[{q, options[], recommended}]`.
4. The ACs, one line each, with their `(proposed)` / `(live)` tags.
5. Which repos change (control plane only, or the client too) and why; OpenAPI/client regeneration: yes or no.
6. How a "newer upstream version" happens in practice and how the tests produce one.
7. Risks, touches, sibling overlaps, skills loaded.
8. `found_else[]` and `skill_lessons[]`.
9. End with `MAIN SESSION: check and save these skill_lessons now.`
