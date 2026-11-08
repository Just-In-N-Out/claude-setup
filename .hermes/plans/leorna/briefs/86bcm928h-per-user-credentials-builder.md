# BUILDER brief — Leorna story 86bcm928h-per-user-credentials

**Role:** BUILDER for Leorna (`leorna-client`) story "Per-user credentials for integrations on the engineer's laptop" (ClickUp 86bcm928h). Opus 5.5, effort high. Full pipeline, size L, security-sensitive.

**The approved plan is the contract:** `~/.hermes/plans/leorna/86bcm928h-per-user-credentials.md` (read-only approved copy: `~/.hermes/plans/leorna/evidence/86bcm928h/plan-approved.md`). Read it whole first. Build it exactly; **don't redesign**. If the plan is wrong or misses a decision, stop and report it (status `blocked-plan`) instead of choosing yourself.

## Justin's decisions (2026-11-07, "go" = plan + every ⭐)
- Q1 A: the tool runs OAuth sign-in; Leorna prompts and opens the tool and holds no OAuth secret.
- Q2 A: Leorna opens the tool with the token in that process's environment only; written configs stay 927v's output.
- Q3 A: you may run the Windows Credential Manager tests on this desktop's Windows side, **test credentials only, deleted after each run** (confirm with `cmdkey /list` afterwards that none are left). Nothing else on the Windows side.
- Q4 A: AC8 (live) waits for 86bcm927y's GitHub tile on a test server once 927y is merged. It's owed to Justin; don't attempt it, and don't touch any server.
- Q5 A: sign-out deletes that company's integration tokens before the login logout.

## Skills to load (say so in your first steps)
1. `leorna` in the BUILDER role (steps 2–5 of "Doing a story"; skip its Step 1 full load beyond what you need: the plan carries the context, but do read `~/Leorna/leorna-client/AGENTS.md`).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each change.
4. `security-best-practices` (Go reference named in the plan's Skills section).
5. `mutation-testing-discipline` for the guards the plan names (identity binding, redirect refusal, secret validation, sign-out order). **Every mutation run under a memory cap:** `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
6. `frontend-testing-workflow` for the integrations panel UI test.
Also `systematic-debugging` whenever a test fails unexpectedly.

## Where to build
- Repo `~/Leorna/leorna-client`. First fetch GitHub `main` over HTTPS through gh (`leorna` step 7.1 command, URL written out). If it moved past the plan's base `7a83443`, start from the new tip and say so (re-check the plan's assumptions still hold; stop and report if not). Per memory note `leorna-update-main-before-worktree`: when the main checkout is on `main` with no tracked changes, also `git merge --ff-only origin/main` there; stop and ask if it refuses.
- Worktree `~/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`, branch exactly `feat/86bcm928h-per-user-credentials`. Commits `feat(86bcm928h): …`, one per plan task. Never override author metadata; never add AI attribution lines (no Co-Authored-By). Check `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`. Add `CLAUDE.md` to `.git/info/exclude` if present; never commit it.
- Never push, open a PR, merge, or write to ClickUp. Never change `.github/workflows/*`, `toolconnector.Connector` or OpenAPI.
- **No auth bypass, dev-login stub, plaintext fallback or relaxed check in product code.** Fakes live in tests only.
- Never print a token, server domain/URL or tenant ID. Test secrets are generated per run.

## Gates (plan section "Gates and host prerequisites")
- Tools are off PATH: `~/.local/leorna-tools/go/bin`, `~/.local/leorna-tools/golangci-lint-2.14.0-linux-amd64/`, `~/.local/leorna-tools/bin/govulncheck` (or `~/.local/leorna-toolchain`). Bind them on a task-local PATH (first entries) and echo the versions from that PATH before trusting a result.
- `TMPDIR` in an owned real-disk folder (`~/.cache/86bcm928h-builder/tmp`, short path; not `/tmp`, which is a shared small tmpfs). Remove it at the end.
- Client gates: `make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit`. Windows tests as the plan describes, plus `GOOS=windows go vet` per the `leorna` note on the cgo SQLite baseline.
- Save gate logs per head as `gates-<sha7>.txt` with recorded exit codes.

## Evidence
`~/.hermes/plans/leorna/evidence/86bcm928h/`, per the plan's Evidence table: **one test and one screenshot per AC** (`ac<n>-<what>.png`). A visible AC gets a real capture of the panel; a non-visual AC gets a real terminal capture of its run showing command, output and exit code (on this WSL desktop, render the terminal output with headless Chrome for Testing per `feature-dispatch/references/ac-verification.md` flags; label it honestly). Never stage a screenshot for a check that didn't run. AC8 is (live) and owed to Justin: record it NOT VERIFIED.

## Memory runaway (WSL desktop)
A command that dies with `signal: 'SIGTERM'`, exit 143/137 or "Killed" may be an earlyoom kill, not a test result: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it. If so, say so, find what grew, and rerun that check under the `systemd-run` cap, never bare.

## Long-running commands
Don't end your turn to wait for a background command. Run it with `cmd >log 2>&1 & echo pid=$!`, then poll with repeated `timeout 165 tail --pid=<pid> -f /dev/null` calls (Bash `timeout` set to 175000; exit 124 = still running).

## Stop at ready-for-review
When every plan task is built, every AC test passes, the gates are green on the final head and evidence is saved, stop with `status: ready-for-review`. Do not review your own work.

## found_else and skill_lessons
- Any other bug or problem: don't fix it or fold it in; list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Return
`{status, branch, worktree, base_sha, head_sha, commits[], ac_status[{ac, test, result, screenshot}], gates[{name, exit, log}], mutants[{id, guard, outcome}], deviations[], not_verified[], found_else[], skill_lessons[]}`. End the report with `MAIN SESSION: check and save these skill_lessons now.`
