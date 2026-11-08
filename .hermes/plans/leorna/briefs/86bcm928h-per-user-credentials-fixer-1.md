# FIXER brief, round 1: Leorna story 86bcm928h-per-user-credentials

**Role:** FIXER for review round 1. You are a fresh agent: Opus 5.5, effort high. You fix the P0–P2 findings below test-first, then stop at `ready-for-next-review`. You don't review your own work; a fresh round-2 reviewer does that.

**Story:** "Per-user credentials for integrations on the engineer's laptop" (ClickUp 86bcm928h), repo `leorna-client`. The approved plan is the contract: `~/.hermes/plans/leorna/evidence/86bcm928h/plan-approved.md` (ACs AC1–AC8; Justin's answers Q1–Q5 = A). Builder report: `~/.hermes/plans/leorna/evidence/86bcm928h/builder-report.md`. Full review: `~/.hermes/plans/leorna/evidence/86bcm928h/review-1/review.json` and `review-1/report.md`.

- **Worktree:** `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`
- **Branch:** `feat/86bcm928h-per-user-credentials`
- **Reviewed head:** `e11872ff69bb32ed8bca30cd9075fef312531c09`
- **Base:** `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`

Don't rebase.

## The referee's lines (verbatim). Fix the P0–P2 ones
```
R1-1  P1  application/open_tool_windows.go:193  Open Claude Code / Open Codex start `powershell.exe -NoLogo -NoExit -Command claude|codex`. PowerShell resolves the name to the npm `.ps1` shim first, and under Windows' default execution policy (Restricted) that shim refuses to load, so the tool never starts and the token is never delivered. The Windows test swaps this program for the test binary, so the real command is never run.
R1-2  P2  application/open_tool_windows.go:193  Claude Code is found by name through the PATH that Leorna's own process inherited when it started. Leorna's own install tile puts claude.exe at %USERPROFILE%\.local\bin\claude.exe (toolinstall/run_windows.go:25, toolconnector/available/registry.go:39), and an already running Leorna never sees a later PATH change, so after installing from Leorna, Open Claude Code can't find `claude`.
R1-3  P2  cmd/leorna-client/frontend/dist/integrations.js:53  load() increments `generation` without checking `busy`. When a reload (sync-completed, login-changed, company-changed) lands while an action (Check now, Save token, Disconnect, Open) is pending, act()'s finally skips setBusy(false) because current !== generation. `busy` stays true, so Check now and every rendered button stay disabled until Leorna restarts.
R1-4  P3  application/open_tool.go:98  Open Cursor reports 'Opened Cursor. It can use your GitHub sign-in.' even when Cursor was already running. A second Cursor.exe hands the folder to the running instance and exits, so the token never reaches it. The button says '(close it first)', which is why this is P3.
R1-5  P3  cmd/leorna-client/frontend/dist/integrations.js:170  The panel reloads only on a manual Sync (sync.js dispatches sync-completed only in the manual path). A startup or automatic Sync that records a newly enabled tile leaves the panel on its earlier text until the engineer clicks Check now or something else reloads it.
REVIEW AGAIN: 3 P0-P2 finding(s) in review-1 at e11872f
```
R1-4 and R1-5 are P3. They go to follow-ups, so leave them unless a P0–P2 fix naturally covers them; if one does, say so.

## How to fix
- Load, and say so in your first steps:
  - `leorna` (FINISHER fix pass: hard rules; no Step 1 full load needed)
  - `engineering-best-practices`
  - `receiving-code-review`: verify each finding first, fix the valid ones, and push back with evidence on any that don't hold
  - `test-driven-development`: a failing test that reproduces each finding before its fix
  - `security-best-practices`
  - `git-commit-rules`
  - `mutation-testing-discipline` for the guard tests you add
  - `systematic-debugging` when something fails unexpectedly
- **Security properties the fix must keep**, from the plan and its review:
  - An absolute executable.
  - The secret in the child's environment only: never on a command line, in a file or in a log.
  - No injection through the command.
  - No `.cmd`/`.bat` execution.
  - No auth bypass, stub or plaintext fallback in product code.
- **Loosening PowerShell's execution policy** (`-ExecutionPolicy Bypass`) is a security trade-off. Prefer launching the tool's real executable. If R1-1 or R1-2 can't be fixed without breaking a plan rule, stop with `status: blocked-plan`: name the options and their trade-offs and recommend one. Don't choose a design the plan doesn't allow. One example: Codex may ship only as an npm `.cmd`/`.ps1` shim, with no `.exe`.
- **Prove the real default program on Windows, not only the test-binary swap.** On this desktop's Windows side, run the real resolution and launch path read-only, for example the exact command with `--version`.
  - Justin's Q3 A allows test credentials on the Windows side, deleted after each run. `cmdkey /list` must show no Leorna entry afterwards.
  - Don't put a real token anywhere.
  - Don't change the machine's execution policy or PATH.
- **R1-3:** a UI test, in the repo's node UI harness, that fires a reload event while an action's bridge promise is pending and then checks the buttons are enabled again. It must fail before the fix.
- **Commits:** `fix(86bcm928h): …` or `feat(86bcm928h): …`, one per finding.
  - Never override author metadata, and add no AI attribution or Co-Authored-By lines.
  - Check `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`.
  - Never push, open a PR, merge or write to ClickUp.
  - Don't touch `.github/`, `toolconnector.Connector` or OpenAPI.
- **Docs:** if behaviour or docs change (README, application/README, SECURITY), update them in the same fix commit.

## Gates and evidence
- **Toolchain:** it's off PATH. Use `~/.local/leorna-tools/go/bin` (go1.27.3) and `~/.local/leorna-tools/golangci-lint-2.14.0-linux-amd64/` on a task-local PATH, and echo their versions.
- **TMPDIR:** use `~/.cache/86bcm928h-fixer-1/tmp`, a short real-disk path (not `/tmp`). Remove it at the end.
- **Windows cross-builds** use cgo via Zig: `CGO_ENABLED=1 GOOS=windows CC='<zig> cc -target x86_64-windows-gnu'`, where Zig is under `~/.local/leorna-tools`. Run native Windows test binaries through interop with the package folder as cwd.
- **Gates on the final head:**
  - `make check`
  - `node --test scripts/*-ui.test.cjs`
  - `make lint audit`
  - gitleaks over `7a83443..HEAD`
  - `GOOS=windows go vet` with Zig cgo
  - the native Windows tests (AC6)
  - Save the log as `~/.hermes/plans/leorna/evidence/86bcm928h/gates-<sha7>.txt` with exit codes.
- **Re-render evidence:** if a fix changes an AC's test, re-render that AC's screenshot from the new head (`ac<n>-<what>.png`, overwrite) and its log. AC3 and AC6 cover the launch path; AC1 and AC4 cover the panel.
- **Mutation runs:** always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …`, using `go test -overlay`, never an edited worktree. Record new mutants in `mutants.txt`.

**Memory runaway:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before you read it as pass or fail.
**Long waits:** don't end your turn to wait. Use `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` calls with the Bash timeout at 175000.

## found_else and skill_lessons
- If you find a problem outside these findings, don't fix it. List it in `found_else` with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`).
  - `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind, what it checks and where it runs.
  - An empty list is the normal answer.

## Return
`{status: ready-for-next-review|blocked-plan, head_sha, commits[], findings[{id, verdict: fixed|rejected, test, commit, evidence}], ac_status[{ac, test, result, screenshot}], gates[{name, exit, log}], mutants[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
