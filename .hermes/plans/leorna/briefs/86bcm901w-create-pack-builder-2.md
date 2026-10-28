
# BUILDER (continuation) — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: BUILDER (Full pipeline), continuing a stopped builder. Build the approved plan from where it stopped; don't re-plan.

## Inputs
- **Approved plan:** `~/.hermes/plans/leorna/86bcm901w-create-pack.md` (read-only copy: `~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md`). Read "Justin's answers (2026-10-28)" right under its questions first, including the "Builder 1 result" line.
- **First builder's brief** (its Rules section still applies word for word, except the Scratch line below): `~/.hermes/plans/leorna/briefs/86bcm901w-create-pack-builder.md`.
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`. Builder 1 committed B1 (`479211b`) and B2 (`18ed1b7`); the worktree should be clean at `18ed1b7`.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901w/`. Builder 1 left `tools.txt`, `red-b1.log`, `green-b1.log`, `red-b2.log`, `green-b2.log`, `unit-mutations-18ed1b7.txt`, `unit-mutations-driver.py` and its section of `INVENTORY.md` (B0 table, file list, deviations, what's owed). Read `INVENTORY.md` first and add your own section; never edit builder 1's section.

## Where builder 1 stopped
- Done: B0.1, B0.2, B0.3 (tools reused from `~/.local/leorna-toolchain` and checked: Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0; gitleaks 8.30.1 at `/usr/local/bin`), B0.5 (Chrome), B1, B2.
- Blocked: B0.4 (Docker / `leorna-test-pg`), B0.6 (base baseline), B0.7 (before-screenshot), B3–B12, because `make`, Docker and a C compiler were missing. `make test` runs `go test -race`, which needs cgo and gcc.
- Its additive departures (no ruling needed): `ErrNameTaken` and `ErrStaleParent` landed in B2; three extra tests (`TestDiffItemsEncodesEmptyListsAndOmitsPreviousVersionWhenAdded`, `TestBuilderErrorsAreDistinctConflicts`, `TestItemAsSeedItemCopiesContentOnly`); the invalid-kind refusal case puts a bogus-kind item in the parent.

## What to do
1. Check the worktree is clean at `18ed1b7`, then redo B0.2's fetch check (HTTPS through gh). If GitHub `main` moved past `1ee7157`, follow the plan's B0.2 rule.
2. Check the environment: `command -v make gcc`, `docker version` (the Linux engine, not the Windows stub), and `CGO_ENABLED=1 go env CGO_ENABLED` with the toolchain's Go. **If any is still missing, stop at once** with `status: stopped` and `stop_reason: "blocked: <what's missing>"`. Don't work around it (no user-space make, Postgres or compiler from downloaded packages): the approved route is Justin's.
3. When all work: B0.4, then B0.6 and B0.7 from a **detached copy at `BASE`** (never from the worktree, which holds B1/B2), then B3 to B12 in the plan's order, test-first, and stop at `ready-for-review`.
4. Run every workspace gate (`make check`, `make fmt`, `make workspace`) from the worktree or a detached copy, never from the main checkout: `scripts/verify-workspace.sh` and `scripts/format-workspace.sh` run `find .` and would walk the sibling worktrees under `.claude/worktrees/`.

## Skills
Load, in this order, and say so in your first steps: `leorna` (BUILDER role; skip its Step 1 load, the plan did it), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`, `security-best-practices` (its Go reference, as the plan's Skills table says), `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. The last two end with a Mandatory Validation and Agent Defect Loop: their independent finder and verifier are run by the main session as the reviewers and verifier, so you don't start agents. Any skill step that says "spawn a subagent" or "independent reviewer" is the main session's job.

## Rules
- Every rule in the first builder's brief applies (no push, PR, merge or ClickUp post; commits `feat(86bcm901w): …` with the repo's identity and no AI attribution lines; never stage a `CLAUDE.md`; sibling stories 901a/901b/901j and their worktrees, branches, DBs and evidence untouched; only `leorna_86bcm901w_test` and `leorna_86bcm901w_base_test`; shared `leorna-test-pg` and `~/.local/leorna-toolchain/` reused, never removed or reinstalled over a matching version; no `.github/` changes; rulings written as "My ruling, not yet confirmed" in `rulings[]` and your `INVENTORY.md` section; stop with options if the plan is wrong; evidence per the plan's E1–E3, one screenshot per AC, `gates-<sha7>.txt` with `EXIT=` lines).
- **Scratch:** keep all scratch in a fresh `<your scratchpad>/86bcm901w-builder-2/` (`mkdir` without `-p`, so it fails if it exists) and remove only that folder.
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.

## Output (your final message)
`{name: "86bcm901w-create-pack", status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, commits[], gates[{name, exit, log}], ac_status[{ac, test, red_log, green_log, screenshot}], shots[], defect_loop_skills[], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
