# BUILDER brief — 86bcm928t integration governance and usage

Role: BUILDER (fresh general-purpose agent, Opus 5.5, high effort). Pipeline: Full.
Build the approved plan test-first and stop at `ready-for-review`. Don't review your own work as the story's review, and start no other agents: the main session runs every role.

- **Approved plan (build exactly this):** `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/plan-approved.md` (read-only copy; the working copy is `/home/justin/.hermes/plans/leorna/86bcm928t-integration-governance-usage.md`). Justin approved it with every ⭐ option while away ("keep building the user story and go with recommended for the plan as I wont be on"). 927y (PR #112) is merged on main, which met his "builder starts only after 927y is merged" condition.
- **Repo:** `/home/justin/Leorna/leorna-control-plane`. **Base:** GitHub main `f0a326b83aae9d181e4f6681645685ae4b1fff91` as planned. Re-check GitHub main first. If it moved, branch from the new main and say so in your report, listing what the new commits touch that this plan also touches.
- **Branch / worktree:** `feat/86bcm928t-integration-governance-usage` in a dedicated worktree at `/home/justin/Leorna/86bcm928t-integration-governance-usage`.
  - Following the `leorna` skill (Doing a story step 2 and Step 1.5), fast-forward the main checkout's `main` to `origin/main` first, only if it is on `main` with no tracked changes. An untracked `.claude/` is just sibling worktrees.
  - Fetch over HTTPS through gh, with the exact command in the `leorna` skill (step 7.1).
  - Don't touch any sibling worktree or branch: 927y, 9284, ccndx6, or anything under `.claude/worktrees/`. Never run `git worktree prune`.
- **Evidence root:** `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/` (screenshots `ac<n>-<what>.png`, gate logs `gates-<sha7>.txt` with a `.json` receipt holding `exit_code`, mutation receipts). Owned scratch goes on the real disk at `~/.cache/86bcm928t-builder/` (not `/tmp`, which is a small shared tmpfs). Remove scratch you don't need as evidence when you finish.

## Acceptance criteria (from the approved plan; don't change them)
- AC1: Given an integration, then it reaches engineers only through packs assigned to their team/project. Test: `TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres`. It passes on base by design (`base_exempt`), backed by mutants M1/M2.
- AC2: Given the dashboards, then integration usage (which integrations, by team) is shown where measurable. Test: `TestIntegrationGovernanceAC2DashboardByTeamWithPostgres`.
- AC3: Given any integration change, then it appears in the change audit. Test: `TestIntegrationGovernanceAC3ChangeAuditWithPostgres`.
No `(live)` ACs.

## Skills: load each with the Skill tool, in order, and say so in one line
1. `leorna`: the BUILDER role (Doing a story steps 2–5 and 4b evidence). Read the shared memory notes it names, especially `leorna-control-plane-workflow.md`. Its WSL host lines say where Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 live (`~/.local/leorna-toolchain`, off PATH: use a task-local PATH only), plus the Chrome-for-Testing flags, the ClickHouse container recipe and the admin-console capture recipe.
2. `engineering-best-practices`
3. `test-driven-development`: a failing test before each change. Confirm Task 1's base results (AC2/AC3 fail on their own assertions, AC1 passes) before writing any code, and honour the plan's stop conditions.
4. `mutation-testing-discipline` for the guards (M1, M2 and the plan's other mutants). **Every mutation run goes under a memory cap:** `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
5. The control-plane specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. The plan says no API change and no migration. If the build proves otherwise, stop and report rather than adding one.
6. `git-commit-rules` for commits: plain `git commit -m`, never override the author, no AI attribution or Co-Authored-By lines, conventional `feat(86bcm928t): …`. Never stage `CLAUDE.md`.

## How to build
- Follow the plan's tasks in order. The plan includes code; still write each test first and watch it fail for the right reason.
- If a plan step proves wrong on real code, make the smallest fix that keeps every AC's meaning and record it under "Deviations from the plan" in your report. If a fix would change what an AC claims or its test name, stop and report instead, so a planner can amend the plan.
- Gates (from the plan and the `leorna` skill), on the final head, with real logs:
  - `make check` with the CI-pinned linter and govulncheck bound by absolute path.
  - `bash ./scripts/test-module-add.sh`, run serially, never alongside `make check`.
  - `python3 -m unittest scripts/test_release.py`.
  - The Postgres no-skip check from a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`.
  - The five ClickHouse-backed `TestContentUsage*WithPostgres` tests, run locally with the plan's owned ClickHouse container, since this story edits that page.
  - Use the plan's owned containers (`928t-builder-pg`, `928t-builder-ch`, CI's pinned images, `--rm`, memory caps, password in a 0600 env file, never on a command line). Don't use or start the shared `leorna-test-pg`, and never touch `leorna-pg`.
- **Evidence:** one screenshot per AC into the evidence root, as the plan's evidence task says:
  - AC2: the real `/admin/content-usage` "Integrations by team" section.
  - AC3: the real `/admin/audit` page.
  - AC1: a terminal capture of its test run, rendered with headless Chrome and labelled a terminal capture.
  - Look at every PNG before citing it. Check that no domain, tenant ID, token or email is visible.
- Docs & records task: the module READMEs and the `delivery/stories.json` entry (appended last, as text) per the plan. Also add a dated status line for 86bcm928t to `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`: branch, head, `ready-for-review`. Don't push.
- Stop at `ready-for-review`: everything committed, the worktree clean, gates green on the final head.

## Windows desktop: runaway memory
A command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as pass or fail. If earlyoom killed it, say so, find what grew (often a failing assertion diffing huge objects), and rerun that check under the `systemd-run` cap above, never bare.

## Never
Push, open a PR, post or write to ClickUp, merge, change `.github/workflows/*`, add an auth bypass, change repo-wide patterns (list those as follow-ups), or touch other stories' worktrees, branches, DBs or containers.

## Waiting
Don't end your turn to wait for a background command (the lessons gate treats that as finishing). Wait in the foreground with bounded polls under 3 minutes each (`timeout 165 tail --pid=<pid> -f /dev/null`, with the Bash `timeout` set above it).

## Report
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file (the one `leorna-workflow.md` status line above is the exception): list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- Return `{status: "ready-for-review" | "blocked", worktree, branch, base_sha, head_sha, commits[], diffstat, gates[{name, log, exit_code}], ac_evidence[{ac, test, base_result, head_result, screenshot}], mutants[{id, killed, receipt}], deviations[], found_else[], skill_lessons[]}`, then end with the line `MAIN SESSION: check and save these skill_lessons now.`
