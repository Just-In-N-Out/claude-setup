# BUILDER brief: 86bcm901r-starter-packs [leorna]

**Role:** BUILDER for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). Build the approved plan test-first, then stop at `ready-for-review`. Pipeline: **Full**. After you: reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → finisher, each a fresh Opus 5.5 xhigh agent the main session starts. You never review your own work and you can't start agents.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Mac-only recipes in the skills (osascript, `screencapture`, Homebrew paths) don't apply; the plan's T7 and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` give this machine's screenshot method (log rendered in a `<pre>` page, captured with Chrome for Testing).

## The approved plan

**`~/.hermes/plans/leorna/86bcm901r-starter-packs.md`** (read-only approved copy: `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md`). It is **approved, 2026-10-29, under Justin's away grant**: every ⭐ answer, **Q1 A, Q2 A, Q3 A, Q4 A, Q5 A, Q6 A**, plus the proposed AC4 (live) and AC5. Don't re-plan. Build tasks T0–T9 in order. The plan inlines the production code and tests; they were compiled and linted against `6c1709e` but **never run**, so treat them as a strong draft: run each test red first, then green, and fix what the run shows within the plan's design.

If the plan turns out wrong or missing a decision you can't make safely (a design change, a new file area, an API or OpenAPI change, a different storage model), stop with `status: stopped` and the options. For a smaller real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in your section of `~/.hermes/plans/leorna/evidence/86bcm901r/INVENTORY.md`, and carry on.

### Justin's words (verbatim)

> Role-based starter packs. I want you to go into ClickUp and pick out this user story. I won't be on my laptop, so just keep everything going and follow what the recommended agent says.

The grant covers this story up to the hand-over only: **no push, PR, merge, ClickUp post, CI (`.github/`) change, credential change or server provisioning.** AC4 is owed to Justin: you only write its checklist (T7).

## Skills to load first, in this order (say so in your first steps)

1. `leorna`, in the **BUILDER** role (Doing a story → steps 2–5 and 4b). Skip its Step 1 full context load: the plan already holds it. Read only the notes the plan or a task points to.
2. `engineering-best-practices`.
3. `test-driven-development`.
4. The plan's `## Skills` specialists: `backend-data-migrations` (migration 24, startup load), `mutation-testing-discipline` (T5), `security-best-practices`, `multi-tenant-auth-management`. `backend-data-migrations` ends with "Mandatory Validation and Agent Defect Loop": its spawn steps are run by the main session as pipeline roles; you do its builder-side validation and return `defect_loop_skills[]`.

## Acceptance criteria (from the approved plan; each has one named test, one screenshot)

- **AC1:** fresh install → the agreed starter packs are in the catalog. Test `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres`.
- **AC2:** assigned to a team → engineers sync it in all three tools. Test `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres`.
- **AC3:** library item update → starter packs pick up the new version on the next library release. Test `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres`.
- **AC4 (proposed) (live):** Justin's real desktop Sync of the Backend pack. Not run by agents; you write `ac4-live/CHECKLIST.md`.
- **AC5 (proposed):** a bad definition or failed write stops the load, writes nothing, and a retry works. The plan names its test.

The exact commands are on each AC line of the plan. Each AC test must fail to build on the base commit (record one base run per AC in a **separate detached worktree** with `leorna_86bcm901r_base_test`, never in the story worktree).

## Where you work

- **T0** of the plan: fetch GitHub `main` over HTTPS through `gh`, check whether it moved since `6c1709e` in files the plan touches (if it did, in a way that changes the design, stop and report), fast-forward the main checkout's local `main` with `--ff-only` (check no tracked changes first; stop if it refuses), then create the worktree **`~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`** on branch **`feat/86bcm901r-starter-packs`** from that SHA, and confirm `main`, `origin/main` and the worktree HEAD agree. Never switch the main checkout's branch or edit files there.
- **Databases:** `leorna_86bcm901r_test` (yours), `leorna_86bcm901r_base_test` (base runs), `leorna_86bcm901r_demo_test` (AC1 screenshot), in `leorna-test-pg` only. Never a sibling's database, never `leorna-pg`. The password never goes on a command line or into a log (the plan's T0 env-file recipe).
- **Siblings:** 86bcm901j (PR #98, worktree `.claude/worktrees/86bcm901j-mcp-templates`) is still open; 901a, 901b and 901w are merged. Never touch another story's worktree, branch, database or evidence folder. Stay within this plan's files; shared files (`delivery/stories.json`, `internal/library/README.md`) are resolved at hand-over, not now.
- Commits: `feat(86bcm901r): …`, with git's own identity (never override author; check `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`). No AI attribution lines. Never commit `CLAUDE.md`.

## Evidence (plan T7) and gates (plan T8)

- Folder `~/.hermes/plans/leorna/evidence/86bcm901r/`: you write at the top level only (never `verifier/` or `auditor/`). One screenshot per AC: AC1 a real screenshot of the Content library page's Starter packs section from the dev binary on a fresh demo database; AC2, AC3, AC5 a rendered capture of the test run's log; AC4 its checklist. Every AC log starts `HEAD=<sha>` and ends `EXIT=<code>`. Inspect every screenshot before citing it; no server domain, URL bar, tenant ID, token or email may show.
- Gates on your final head: `make check` with CI's tools bound by absolute path (`GOLANGCI_LINT`, `GOVULNCHECK` from `~/.local/leorna-toolchain`, task-local PATH), `bash ./scripts/test-module-add.sh`, and the Postgres skip check from a `go test -json` stream (`leorna` step 4). Save `gates-<sha7>.txt` + `.png` and read each log's exit code before citing it. Run the mutation checks of T5 and save `mutants.md`.
- The worktree must be committed and clean at the end (`git status --porcelain` empty): `ac-check.sh` fails any untracked file.

## Scratch and temp

Keep everything (TMPDIR, GOTMPDIR, GOCACHE if you need a private one, lint caches, built binaries, Chrome profiles, source exports, the base worktree) in **`~/.cache/86bcm901r-builder/`**, made fresh with `mkdir` (no `-p`, so it fails if it exists). Never put anything big on `/tmp`: it is a small RAM disk shared by every session. Remove only your own folder at the end, by its literal absolute path (`rm -r /home/justin/.cache/86bcm901r-builder`), after removing the detached base worktree with `git worktree remove`. Drop the base and demo databases when done; keep `leorna_86bcm901r_test`.

## Rules

- You can't ask Justin anything.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
- A long command: Claude Code moves a foreground Bash command to the background after about 180 s. Don't end your turn to wait for one (that counts as finishing); poll its log in the foreground in waits of under 3 minutes each.

## Output (final message)

Return JSON: `{name, status: ready-for-review|stopped, summary, head, base, worktree, branch, diff_stat, ac_evidence[{ac, test, head_log, base_log, screenshot}], gates[{gate, log, exit}], rulings[], steps_for_justin[], stop_reason, shots[], defect_loop_skills[], found_else[], skill_lessons[]}`. `status` and `summary` are required. Plain words.
