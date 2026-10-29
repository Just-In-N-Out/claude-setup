
# PLANNER — leorna-control-plane, story 86bcm902a "One-click quick start (starter pack → team → sync)"

Role: PLANNER (Full pipeline). Write a plan; build nothing.

## Away grant (record it in the plan)
Justin is away from his laptop. His standing instruction for this story (2026-10-29): "just keep everything going and follow what the recommended agent says." So the main session will approve your plan with every ⭐ option as soon as it comes back, with no further check from Justin. Consequences for you:
- Make every ⭐ the safe, scoped choice: the one that keeps existing behaviour where it isn't broken, stays inside this story's files, and needs no permission Justin hasn't given. Never ⭐ an option that pushes, opens a PR, posts to ClickUp, provisions servers, touches Justin's real tool homes or does another open card's work wholesale.
- Write the plan as if every ⭐ were chosen, so the builder can start straight from it.
- Put a short "Away grant" line near the top of the plan quoting Justin's words and saying it covers plan approval and ⭐ answers only. Push, PR, ClickUp posting and merge stay unauthorized.
- If a ⭐ narrows the card's ACs, ships with a stand-in, or builds part of another card's scope (see the open dependency below), say so in a **Flag** line at the very top of the plan and in your summary, so Justin sees it first when he's back.

## Boundary for this run
- Write exactly one file: the plan at `~/.hermes/plans/leorna/86bcm902a-quick-start.md`. Nothing else on disk changes: no code or test edits, no commits, no worktree or branch creation, no `make`, no test databases, no ClickUp writes.
- The one exception is the base update below (fetch + fast-forward of the main checkout's `main`).
- Read code in the main checkout `~/Leorna/leorna-control-plane` (on `main`, untracked `.claude/` only) at the base SHA, and read-only in `~/Leorna/leorna-client`. Use Read/Grep/Glob, `git log/show/grep`, `gh api`/`gh pr list` GET requests and ClickUp reads. `go doc` and `go list` are fine; don't run tests or builds.
- Never switch the main checkout's branch. Never touch other stories' worktrees under `.claude/worktrees/`, their branches, test databases or evidence folders.

## Base commit
- Local `main` and `origin/main` were at `6c1709e` (Merge PR #96, 86bcm901w create-pack) when the main session looked; that ref may be stale.
- Do the `leorna` skill's Step 1.5: fetch GitHub's `main` over HTTPS through gh (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, URL written out, never in a variable). If the main checkout is on `main` with no tracked changes, run `git merge --ff-only origin/main` there; stop and report if it refuses. Another planner (86bcm901y, another session) may run the same fetch/fast-forward at the same moment: if git reports a lock (`index.lock`, `cannot lock ref`), wait a few seconds and retry once; never delete a lock file. Name the resulting SHA as the plan's base and confirm `main` = `origin/main` = base.
- The builder will create the story worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start` on branch `feat/86bcm902a-quick-start` from that base. Make that the plan's first task.

## The ask (rewritten)
Give a new admin a guided quick start: right after finishing setup on a fresh install, the admin is offered role-based starter packs (e.g. Backend, Frontend, Platform/DevOps, Secure coding), picks one, picks a team, and the quick start creates that pack-to-team assignment, so the team's engineers get the pack on their next sync, within minutes of install. The admin can skip the quick start and resume it later. The card says it extends the existing onboarding wizard / post-install setup.

## Justin's words (verbatim)
> One-click quick startI want you to go into ClickUp and pick out this user story.I won't be on my laptop, so just keep everything going and follow what the recommended agent says.

## The card (ClickUp 86bcm902a, read 2026-10-29)
- **User story:** As a new admin, I want a guided quick start that picks a starter pack and assigns it to a team, so that my engineers are syncing real content within minutes of install.
- **Context:** Extends the existing onboarding wizard / post-install setup.
- **Acceptance criteria (test-backed):**
  1. Given a fresh install, when I finish setup, then the quick start offers role-based starter packs
  2. Given I choose a pack and a team, then the assignment is created and engineers' next sync delivers it
  3. Given the quick start, then it can be skipped and resumed later
- **Verify:** end-to-end demo on a fresh install (recorded).
- **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- **Repo:** control-plane. Size M. List "E11 - Pack Builder", PI-2, priority high.
- **Dependencies:**
  - 86bcm901w "Create a pack by picking library items": **complete**, merged as PR #96.
  - 86bcm901r "Role-based starter packs": **still "to do"** (repo "content"). Its card proposes the mapping "to confirm": Backend = spec-driven-development, planning-and-task-breakdown, incremental-implementation, test-driven-development, api-and-interface-design, code-review-and-quality, debugging-and-error-recovery + /spec /plan /build /test /review; Frontend = frontend-ui-engineering, browser-testing-with-devtools, performance-optimization + web-performance-auditor + /webperf; Platform/DevOps = ci-cd-and-automation, git-workflow-and-versioning, observability-and-instrumentation, shipping-and-launch, deprecation-and-migration + /ship; Secure coding (regulated) = security-and-hardening, code-review-and-quality, doubt-driven-development, documentation-and-adrs, source-driven-development + security-auditor + /review. Read 901r and its own dependencies from ClickUp (read-only).

## Find out before designing
- **The open dependency.** Find out what exists today for starter packs: the merged library/catalog work (9019 curate skills, 901b prompts, 901a agent definitions, 901j MCP templates, 901v catalog browser, 901w create-pack), any seed packs, and whether role-based starter packs exist in any form in the control plane or wherever "repo content" lives. If they don't exist, how this story handles that is a plan question: say plainly what each option builds, which parts of 901r it would take on, and what Justin would see. Keep the ⭐ safe and scoped per the away grant, and flag it at the top (see above).
- **The onboarding wizard / post-install setup.** Find where it lives (admin console, installer, client) and what "finish setup" means there today; the quick start hooks in after it.
- **Team assignment and sync.** How packs are assigned to teams today (API, store, admin console) and how an engineer's sync receives a team's packs (in `~/Leorna/leorna-client`, read-only). AC2 needs a test proving the next sync delivers the assigned pack; say whether that is a control-plane integration test of the sync API or needs client code. If client code changes, say so plainly: the card says control-plane, and a client change means a second branch `feat/86bcm902a-quick-start` in `leorna-client` with its own gates (client `make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit`).
- **Skip and resume.** Where the quick-start state lives (per tenant? per admin?), what "resume later" looks like, and whether that needs a migration.
- **The Verify line.** Decide whether the "end-to-end demo on a fresh install (recorded)" can be done by an agent locally (local control plane, fresh DB, headless capture) or only by Justin; tag it `(live)` only if only Justin can do it.

## What the plan must contain
- **Skills:** load `leorna` (PLANNER role; do its Step 1 context load, and Step 1.5 as adjusted above), then `engineering-best-practices` and `implementation-planning`. Add the control-plane specialists that apply: likely `security-best-practices` and `multi-tenant-auth-management` (admin-only write API; assignments and quick-start state stay inside the tenant), `api-contract-drift-guard` (OpenAPI change) and `backend-data-migrations` (any new table or column). Not a bug, so no `systematic-debugging`. Your report says which skills you loaded. The plan gets a `## Skills` section for the build roles, marking any skill that ends with "Mandatory Validation and Agent Defect Loop" (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`), and naming `mutation-testing-discipline` for the permission and tenant guards.
- **Questions at the top**, right after the title (and the Flag line, if any). At most 4, each with 2–4 lettered options under about 60 characters, ⭐ on the recommended one (see the away grant). Say per question what changes if another option were picked. No question for anything a sensible default settles.
- **Numbered ACs `AC1`, `AC2`, …** near the top. AC1–AC3 in the card's wording (given, not proposed). Any AC you add yourself (the DoD's failure case, admin-console flow details, the fresh-install demo) is marked `(proposed)`. Tag an AC `(live)` only if only Justin can check it, right after its id (`- AC5 (proposed) (live): …`). Each AC has exactly one named test, its whole name on one line (`ac-check.sh` matches plan lines one by one, so a wrapped test name rejects that AC).
- **Per AC:**
  - the test name and the command that runs only that test (e.g. `go test -v -count=1 -run '^TestAC1…$' ./internal/...`, with `LEORNA_TEST_DATABASE_URL` for Postgres tests; `node --test --test-name-pattern=…` for admin-console UI tests);
  - why it fails on the base commit (the "old-code check"), or its `base_exempt` reason (3+ words);
  - its evidence: one screenshot per AC plus a log under `~/.hermes/plans/leorna/evidence/86bcm902a/`. ACs with a visible result get **captures of the real admin console** (the starter-pack choice, the team pick, the created assignment, the skip and the resume); name each capture (`ac<n>-<what>.png`, with `-before`/`-after` where a state changes) and its capture point. ACs with nothing visual get a terminal capture of the test run. **This machine is the Windows desktop's Ubuntu (WSL2), not the Mac:** no `osascript`, `screencapture`, PIL or ImageMagick. Plan captures that work here: the repo's own admin-console browser test driver if it has one, else Chrome for Testing headless (`~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, run under `env -u DISPLAY -u WAYLAND_DISPLAY`); for a terminal capture, render the log in a `<pre>` page and screenshot it. Check what 86bcm901w's evidence used (`~/.hermes/plans/leorna/evidence/86bcm901w/`, read-only) and reuse that recipe.
- **Design** complete enough that the builder doesn't redesign: where the quick start appears and how it is triggered after setup; the API endpoints and request/response shapes (reuse existing pack, team and assignment APIs where they fit rather than adding parallel ones); how starter packs are identified and listed; how the assignment is created (reuse the existing assignment path and its audit, if any); the skip/resume state and its storage and migration; auth and tenant checks; the admin-console changes; and how the next sync delivers the pack. Name the existing helpers to reuse, with paths.
- **OpenAPI and the client:** say whether the spec changes and whether `leorna-client` generates code from it and must regenerate. OpenAPI is the only link between the repos; no cross-repo Go imports.
- **Host prerequisites:** check `command -v go make gcc golangci-lint govulncheck` and `docker ps` (the `leorna-test-pg` container) and list the result; anything missing becomes a plan question, not a builder discovery.
- **Tasks** a context-free builder can follow, test-first, starting with creating the worktree from the base and checking it's clean. The gates: `make check` with `LEORNA_TEST_DATABASE_URL` and the builder's own disposable `_test` database (never a sibling's), `bash ./scripts/test-module-add.sh`, the admin-console UI tests the repo has, and CI's pinned golangci-lint and govulncheck versions bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says. Base-commit baselines run in a separate detached worktree with their own `_test` DB. Evidence capture is a named task per AC, with before-state captures taken before the visible change.
- **A Docs & records task:** the module README note, OpenAPI, `delivery/stories.json` (append this story's entry last, as text), the plan copy, the evidence folder and the `leorna-workflow.md` notes.
- **Sibling stories:** 86bcm901y "Remove and reorder items in a pack version" is being planned right now by another session (plan, once written: `~/.hermes/plans/leorna/86bcm901y-remove-reorder.md`, read-only; branch `feat/86bcm901y-remove-reorder`). Also run `gh pr list -R LeornaAI/leorna-control-plane --state open` and look at the worktrees under `.claude/worktrees/` (names only; don't read inside them). For each open sibling, read its plan if present (`~/.hermes/plans/leorna/<id>-*.md`, read-only) and list under **Risks** the files it probably edits too (at least `delivery/stories.json`; check the pack service, the OpenAPI spec, migrations and the admin console), with how the finisher resolves each at hand-over.
- **Follow-ups, Risks, Assumptions, Other things found.**

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.
- Scratch: none needed in this run. Later roles keep scratch in their own fresh `<scratchpad>/86bcm902a-<role>/` folder (`mkdir` without `-p`) and remove only that folder by its literal absolute path. `/tmp` is a small RAM tmpfs here: big temp files (Go `TMPDIR`, Chrome profiles, binaries) go to `~/.cache/86bcm902a-<role>/`. Put this line in the plan for the builder.
- You can't ask Justin anything and can't start agents: questions go in `questions`, and any skill step that says "spawn a subagent" is run by the main session instead.

## Output (your final message)
1. `plan_path` and the base SHA you planned against (and whether you fast-forwarded local `main`).
2. Playback (1 line) and summary (at most 5 lines), starting with the Flag line if there is one.
3. `questions[{q, options[], recommended}]`.
4. The ACs, one line each, with their `(proposed)` / `(live)` tags.
5. Which repos change (control plane only, or the client too) and why; OpenAPI/client regeneration: yes or no.
6. How the open 86bcm901r dependency is handled.
7. Risks, touches, sibling overlaps, skills loaded.
8. `found_else[]` and `skill_lessons[]`.
9. End with `MAIN SESSION: check and save these skill_lessons now.`
