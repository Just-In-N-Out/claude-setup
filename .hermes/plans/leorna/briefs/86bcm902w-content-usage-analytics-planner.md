
# PLANNER — leorna-control-plane + leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: PLANNER (Full pipeline). Write a plan; build nothing. Justin approves the plan with **go** before any build starts.

## Boundary for this run
- Write exactly one file: the plan at `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md`. Nothing else on disk changes: no code or test edits, no commits, no worktree or branch creation, no `make`, no test databases, no ClickUp writes.
- The one exception is the base update below (fetch + fast-forward of each main checkout's `main`).
- Read code in the main checkouts `~/Leorna/leorna-control-plane` and `~/Leorna/leorna-client` (each on `main`, untracked `.claude/` only) at the base SHAs. Use Read/Grep/Glob, `git log/show/grep` (search with `git grep`, not a recursive `grep -r .`, which also reads sibling stories' worktrees under `.claude/worktrees/`), `gh api`/`gh pr list` GET requests and ClickUp reads. `go doc` and `go list` are fine; don't run tests or builds.
- Reading real tool transcripts for the spike: you may **list** where Claude Code, Codex and Cursor keep transcripts on this machine and read the **structure** (field names, event types) of a few lines, read-only. Never copy transcript contents into the plan, never quote prompts, file contents, paths of other projects or anything secret; describe the shape only (e.g. "a `tool_use` event with `name: \"Skill\"` and an `input.skill` field"). Prefer the tools' public docs and the client's existing parsers and test fixtures over real transcripts.
- Never switch a main checkout's branch. Never touch other stories' worktrees under `.claude/worktrees/`, their branches, test databases or evidence folders.

## Base commits
- Do the `leorna` skill's Step 1.5 for **both** repos: fetch GitHub's `main` over HTTPS through gh, with the URL written out, never in a variable:
  - `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main` (run in `~/Leorna/leorna-control-plane`)
  - `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-client.git main:refs/remotes/origin/main` (run in `~/Leorna/leorna-client`)
- If a main checkout is on `main` with no tracked changes, run `git merge --ff-only origin/main` there; stop and report if it refuses. Another session (the 86bcm901z planner) may run the same fetch/fast-forward at the same moment: if git reports a lock (`index.lock`, `cannot lock ref`), wait a few seconds and retry once; never delete a lock file. Name each resulting SHA as that repo's base and confirm `main` = `origin/main` = base.
- The builder will create a story worktree in each repo that changes: `<repo>/.claude/worktrees/86bcm902w-content-usage-analytics` on branch `feat/86bcm902w-content-usage-analytics` from that repo's base. Make that the plan's first task. If the plan concludes one repo needs no change, say so and drop its worktree.

## The ask (rewritten)
Admins want to see which skills, agents and prompts their engineers actually use, so they keep what works and retire what doesn't. First a short spike: for each AI tool Leorna supports, find out and write down whether a use of one of these items can be detected from that tool's transcripts. Then, for the tools where it can, count item uses and show the counts per pack and per item in the product. For the tools where it can't, the UI says plainly that usage isn't measurable there.

## Justin's words (verbatim)
> Okay, go to ClickUp, you're gonna send it to do. There are two user stories this will have. Let's do the content usage analytics for this one.

(Voice note: "send it to do" = "see it in To Do". The two stories in To Do are 86bcm901z "Customise a shipped item" and this one. Only this story is in scope; 86bcm901z is a separate job in another session.)

## The card (ClickUp 86bcm902w, read 2026-10-29)
- **User story:** As an admin, I want to know which skills, agents and prompts are actually used, so that I keep what works and retire what doesn't.
- **Context:** Needs a way to attribute usage to items; feasibility per tool to be confirmed (spike first).
- **Acceptance criteria (test-backed):**
  1. Given a spike, then we document per tool whether item usage can be detected from transcripts
  2. Given supported tools, then item usage counts are shown per pack and item
  3. Given unsupported tools, then the UI states that usage is not measurable there
- **Verify:** spike write-up + query tests.
- **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- **Repo:** both. Size M. List "E12 - Usage & Cost Intelligence", PI-2, priority normal, tags p2-medium, pillar-context. Assigned to Justin.
- **Dependency:** 86bcm902h "Enrich usage records with team, project and model" (Christian): **complete**. Its card says today's `metric.Event/Row` has tool, user, tokens, actions, cost (`internal/metric/metric.go`) and that story added team, project and model, a migration and a ClickHouse integration test. Find what it actually merged and build on it.

## Find out before designing
- **Which tools the client captures today** and how: the connectors in `leorna-client`, where each reads its transcripts, what it parses and what it sends to the control plane (the usage/metric ingest path that 86bcm902h extended). List every tool the product supports, not only Claude Code, Codex and Cursor.
- **The spike, per tool:** can a use of a skill, an agent (sub-agent / agent definition) and a prompt (slash command / saved prompt) be seen in the transcript, and how reliably? Name the transcript evidence for each yes (event type and field), and the reason for each no. Say whether "detectable" depends on the tool's version. Kinds can differ per tool (e.g. skills yes, prompts no): the UI must then say which kinds are measurable per tool, so plan for per-tool, per-kind support, or say why per-tool is enough.
- **Matching a use to a Leorna item.** How a detected use (a skill name, an agent name, a command name) maps back to the item that a pack delivered through Sync: what name or path Sync writes into each tool's home, and whether that is unique per tenant. What happens when an engineer uses a skill with the same name that Leorna didn't deliver, or when one item is in several packs: where does the count go "per pack"? Where a real product choice exists, make it a plan question; don't settle it silently.
- **Privacy.** What leaves the engineer's machine: only item identifiers and counts, never transcript text, prompt arguments or file contents. Check what the existing ingest already sends and keep this story's addition to the minimum. Check the client's existing consent/opt-in rules for usage capture and follow them.
- **Storage and query.** Where usage lives (Postgres, ClickHouse or both) after 86bcm902h, how item counts are stored (new event field, new table) and the migration, and the query that produces counts per pack and per item for a tenant, over what time window. Say how the "query tests" in Verify run (`LEORNA_TEST_DATABASE_URL`, `LEORNA_TEST_CLICKHOUSE_URL`) and whether ClickHouse is available on this machine for tests (see Host prerequisites).
- **Where the spike write-up lives** (a doc in a repo, which repo and path, and its README link) and what makes AC1 test-backed: e.g. a test that checks the write-up's per-tool table matches the support table the code uses, so the UI and the doc can't drift. Propose the mechanism; don't leave AC1 as "a doc exists".
- **The UI.** Where the counts are shown (admin console in the control plane, and/or the desktop app), per pack and per item, and where and how "not measurable" is shown for unsupported tools. Look at how the admin console shows usage today and reuse that.
- **The "demoable in isolation" DoD:** whether an agent can show the result locally (local control plane, fresh DB, seeded usage, headless admin console). Tag an AC `(live)` only if only Justin can check it.

## What the plan must contain
- **Skills:** load `leorna` (PLANNER role; do its Step 1 context load, and Step 1.5 as adjusted above), then `engineering-best-practices` and `implementation-planning`. Add the specialists that apply: likely `api-contract-drift-guard` (OpenAPI change, both repos regenerate), `backend-data-migrations` (new columns/table), `security-best-practices` and `multi-tenant-auth-management` (admin-only reads; one tenant never sees another's counts; nothing private leaves the machine). Not a bug, so no `systematic-debugging`. Your report says which skills you loaded. The plan gets a `## Skills` section for the build roles, marking any skill that ends with "Mandatory Validation and Agent Defect Loop" (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`), and naming `mutation-testing-discipline` for the tenant and admin guards.
- **Questions at the top**, right after the title. At most 4, each with 2–4 lettered options under about 60 characters, ⭐ on the recommended one. Say per question what changes if another option were picked. No question for anything a sensible default settles. Write the plan as if every ⭐ were chosen, so **go** needs no re-plan.
- **Numbered ACs `AC1`, `AC2`, …** near the top. AC1–AC3 in the card's wording (given, not proposed). Any AC you add yourself (the DoD's failure case, tenant isolation, privacy of what is sent, the client capture per tool, the OpenAPI regeneration) is marked `(proposed)`. Tag an AC `(live)` only if only Justin can check it, right after its id (`- AC5 (proposed) (live): …`). Each AC has exactly one named test, its whole name on one line (`ac-check.sh` matches plan lines one by one, so a wrapped test name rejects that AC). When an AC is proven in both repos, say which repo's test is its one named test and list the other repo's test as supporting.
- **Per AC:**
  - the repo, the test name and the command that runs only that test (e.g. `go test -v -count=1 -run '^TestAC1…$' ./internal/...`, with `LEORNA_TEST_DATABASE_URL` / `LEORNA_TEST_CLICKHOUSE_URL` for DB tests; `node --test --test-name-pattern=…` for UI tests);
  - why it fails on the base commit (the "old-code check"), or its `base_exempt` reason (3+ words);
  - its evidence: one screenshot per AC plus a log under `~/.hermes/plans/leorna/evidence/86bcm902w/`. ACs with a visible result get **captures of the real UI** (counts per pack, counts per item, the "not measurable" state for an unsupported tool, the empty state before any usage); name each capture (`ac<n>-<what>.png`, with `-before`/`-after` where a state changes) and its capture point. The spike AC gets a capture of the rendered write-up's per-tool table. ACs with nothing visual get a terminal capture of the test run. **This machine is the Windows desktop's Ubuntu (WSL2), not the Mac:** no `osascript`, `screencapture`, PIL or ImageMagick. Plan captures that work here: the repo's own browser test driver if it has one, else Chrome for Testing headless (`~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, run under `env -u DISPLAY -u WAYLAND_DISPLAY`); for a terminal capture, render the log in a `<pre>` page and screenshot it. Check what a recent story's evidence used (`~/.hermes/plans/leorna/evidence/86bcm901w/` or `86bcm902a/`, read-only) and reuse that recipe.
- **Design** complete enough that the builder doesn't redesign: the per-tool (and per-kind) support table and where it lives in code; the client-side detection per supported tool and what it sends; the ingest change; the storage and migration; the count query; the API endpoint(s) and response shapes (reuse existing usage APIs where they fit rather than adding parallel ones); the UI; auth and tenant checks. Name the existing helpers to reuse, with paths.
- **OpenAPI and the client:** say whether the spec changes and how each repo regenerates. OpenAPI is the only link between the repos; no cross-repo Go imports. Say the order the two branches must merge in (e.g. control plane first) and what happens if only one merges.
- **Host prerequisites**, for both repos: check `command -v go make gcc golangci-lint govulncheck node` and `docker ps` (the `leorna-test-pg` container, and any ClickHouse test container), plus anything the client's `make check` needs on Linux (Wails/GTK/WebKit dev packages, if its tests need them). List the result; anything missing becomes a plan question, not a builder discovery.
- **Tasks** a context-free builder can follow, test-first, starting with creating the worktree(s) from the base(s) and checking they're clean. The gates:
  - control plane: `make check` with `LEORNA_TEST_DATABASE_URL` and the builder's own disposable `_test` database (never a sibling's), `bash ./scripts/test-module-add.sh`, the admin-console UI tests the repo has, and CI's pinned golangci-lint and govulncheck versions bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says;
  - client: `make check` (with a real, non-symlinked `TMPDIR`), `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's golangci-lint version first on PATH;
  - base-commit baselines run in a separate detached worktree with their own `_test` DB.
  Evidence capture is a named task per AC, with before-state captures taken before the visible change.
- **A Docs & records task:** the spike write-up, the module README note(s), OpenAPI, control-plane `delivery/stories.json` (append this story's entry last, as text), the plan copy, the evidence folder and the `leorna-workflow.md` notes.
- **Sibling stories:** run `gh pr list -R LeornaAI/leorna-control-plane --state open` and `gh pr list -R LeornaAI/leorna-client --state open`, and look at the worktrees under each repo's `.claude/worktrees/` (names only; don't read inside them). Known siblings today: 86bcm901z "Customise a shipped item" (planning in another session; plan, if written, at `~/.hermes/plans/leorna/86bcm901z-customise-shipped-item.md`: company variants of library items, which this story may need to count too), 86bcm901y (PR #99 open, remove/reorder pack items) and 86bcm902a (quick start, awaiting Justin). For each open sibling, read its plan if present (read-only) and list under **Risks** the files it probably edits too (at least `delivery/stories.json`; check the usage/metric code, the pack and library code, the OpenAPI spec, migration numbers, the admin console and the client connectors), with how the finisher resolves each at hand-over.
- **Follow-ups, Risks, Assumptions, Other things found.**

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.
- Scratch: none needed in this run. Later roles keep scratch in their own fresh `<scratchpad>/86bcm902w-<role>/` folder (`mkdir` without `-p`) and remove only that folder by its literal absolute path. `/tmp` is a small RAM tmpfs here: big temp files (Go `TMPDIR`, Chrome profiles, binaries) go to `~/.cache/86bcm902w-<role>/`. Put this line in the plan for the builder.
- You can't ask Justin anything and can't start agents: questions go in `questions`, and any skill step that says "spawn a subagent" is run by the main session instead.

## Output (your final message)
1. `plan_path` and the base SHA per repo you planned against (and whether you fast-forwarded each local `main`).
2. Playback (1 line) and summary (at most 5 lines).
3. `questions[{q, options[], recommended}]`.
4. The ACs, one line each, with their `(proposed)` / `(live)` tags.
5. The spike result in one line per tool (skills / agents / prompts: detectable or not).
6. Which repos change and why; OpenAPI/client regeneration: yes or no; merge order.
7. Risks, touches, sibling overlaps, skills loaded.
8. `found_else[]` and `skill_lessons[]`.
9. End with `MAIN SESSION: check and save these skill_lessons now.`
