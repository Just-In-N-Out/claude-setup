# VERIFIER brief, round 1: Leorna story 86bcm928h-per-user-credentials

**Role:** `VERIFIER (read only) for leorna feature "86bcm928h-per-user-credentials"`. You are a fresh agent: Opus 5.5, effort high. You never saw the build, reviews or fixes.
- Change no source and commit nothing.
- Write only into `~/.hermes/plans/leorna/evidence/86bcm928h/verifier/`.
- Scratch goes in `~/.cache/86bcm928h-verifier/`, a short real-disk path (not `/tmp`). Remove it at the end.

**Story:** "Per-user credentials for integrations on the engineer's laptop" (ClickUp 86bcm928h), repo `leorna-client`, security-sensitive. Engineers' integration credentials live only in Windows Credential Manager / DPAPI, never in synced or written config, logs, SQLite or control-plane requests. Written MCP configs refer to the credential by name. Reconnect handles expired or revoked credentials. Leorna opens Claude Code or Codex by their own absolute `.exe`, with the token only in that child's environment.

## Inputs
- **Worktree:** `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`, branch `feat/86bcm928h-per-user-credentials`.
- **Head:** `1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2`. If HEAD differs, stop and report it.
- **Base:** `7a834434d00ec7afae8464f5e7ce6cc17881bb7b` (`git merge-base HEAD origin/main`).
- **Approved plan, the contract:** `~/.hermes/plans/leorna/evidence/86bcm928h/plan-approved.md`. It has ACs AC1–AC8, and AC8 is `(live)`. Justin's answers Q1–Q5 = A are recorded in the plan's status line.
- **Reviews:** `review-1/`, `review-2/` and `review-3/` (`review.json` + `report.md`).
- **Fixer answers:** `fixer-1-report.md` and `fixer-2-report.md`.
- **Builder report:** `builder-report.md`.
- **Follow-ups:** `follow-ups.md` lists the P3s.
- The referee printed `MOVE ON: review-3 at 1f98596 is clean`.

## Skills to load (say so in your first steps)
- `leorna` (VERIFIER)
- `engineering-best-practices`
- `adversarial-verification-loop`: the plan names it, and it ends with a Mandatory Validation and Agent Defect Loop. Re-run its Required Validation Gates yourself; you are its independent verifier.
- `security-best-practices`
- `mutation-testing-discipline`: spot-check that the key guard tests can fail.
- Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → VERIFIER and follow it exactly: the run recipe, base runs in a separate detached copy, one screenshot per AC, the `ac.json` format at the top of `scripts/ac-check.sh`, and the blind self-check.

## The work
1. **Re-run the project's gates yourself** on head and keep the logs in `verifier/`:
   - `make check`
   - `node --test scripts/*-ui.test.cjs`
   - `make lint audit`, with CI's golangci-lint 2.14.0 and govulncheck v1.7.0
   - gitleaks over `7a83443..HEAD`
   - `GOOS=windows go vet` with Zig cgo
   - the native Windows tests (`./login` and `./application` with `LEORNA_TEST_SECURE_STORE=1`; also `LEORNA_TEST_REAL_TOOLS=1` for the read-only real-tool resolution)
   - `.github`/`toolconnector`/`api` diff empty; authors are Justin Issa <justin@leorna.com>; no AI attribution
2. **Confirm every P0–P2 finding is closed:** R1-1, R1-2, R1-3 and R2-1. Look for regressions the fixes caused.
3. **For every AC, run its named test on head and on base,** following ac-verification.md.
   - The test must pass on head and fail on base.
   - Write a log per run and one screenshot per AC: a real UI capture for AC1, AC4 and AC7's panel, and a rendered terminal capture of the run for the non-visual ACs.
   - Use the WSL Chrome for Testing flags in ac-verification.md. A page that calls `window.scrollTo` paints blank, so hide the other content instead.
   - AC8 is `(live)` and owed to Justin: mark it `"accepted": false, "not_run": "live: <why>"`.
4. **Write `verifier/ac.json`** and self-check it blind, as ac-verification.md says: copy the files to scratch and run `ac-check.sh` without `--reviews`.

## Tools and environment
- **Toolchain:** it's off PATH. Use `~/.local/leorna-tools/go/bin` (go1.27.3), `~/.local/leorna-tools/golangci-lint-2.14.0-linux-amd64/` and `~/.local/leorna-tools/bin/govulncheck` on a task-local PATH (first entries), and echo their versions.
- **TMPDIR:** owned and short, under `~/.cache/86bcm928h-verifier/`.
- **Windows cross-build:** `CGO_ENABLED=1 GOOS=windows CC='<zig> cc -target x86_64-windows-gnu'`, with Zig under `~/.local/leorna-tools`. Run native test exes through interop with the package folder as cwd.
- **Windows side:** test credentials only, deleted after each run (Justin's Q3 A). `cmdkey /list` must show no "Leorna Client" entry afterwards. Never launch a real tool with a token, and never change the execution policy or PATH.
- **Mutation runs:** `go test -overlay` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …`, never an edited worktree.
- Never print a token, a server domain or URL, or a tenant ID. Don't push or write to ClickUp.
- **Memory runaway:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before you read it as pass or fail. If it was, rerun that step under the cap.
- **Long waits:** don't end your turn to wait. Use `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` calls with the Bash timeout at 175000.

## found_else and skill_lessons
- If you find any other problem, list it in `found_else` with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`).
  - `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind, what it checks and where it runs.
  - An empty list is the normal answer.

## Return
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], found_else[], skill_lessons[]}`.
- `clean` needs every AC accepted, with AC8 (live) `not_run` set aside.
- End with `MAIN SESSION: check and save these skill_lessons now.`
