# REVIEWER brief, round 1 (full): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, independent REVIEWER, **report only**. Opus 5.5, effort high. You never saw the build. Change no source, commit nothing, and write only into `~/.hermes/plans/leorna/evidence/86bcm928h/review-1/`.

**Story:** "Per-user credentials for integrations on the engineer's laptop" (ClickUp 86bcm928h), repo `leorna-client`. It's security-sensitive: engineers' integration credentials (GitHub personal token; tool-run OAuth) must live only in the OS credential store (Windows Credential Manager / DPAPI). They must never appear in the synced config, the written MCP config, logs, SQLite or control-plane requests. The written MCP config refers to the credential by name and never embeds it. A reconnect action handles expired or revoked credentials.

## Inputs
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`, branch `feat/86bcm928h-per-user-credentials`.
- **Scope: full review**: `from` = base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`, `head` = `e11872ff69bb32ed8bca30cd9075fef312531c09`. Review `git diff 7a83443...e11872f` and everything it touches. If HEAD has moved past e11872f, stop and report it.
- Approved plan (the contract, with ACs AC1–AC8 and Justin's answers Q1–Q5 = A): `~/.hermes/plans/leorna/evidence/86bcm928h/plan-approved.md`.
- Builder's report, including its 10 deviations from the plan, which you must judge: `~/.hermes/plans/leorna/evidence/86bcm928h/builder-report.md`. Treat its claims as claims; verify them yourself.
- Evidence folder (gate logs, mutants receipt, screenshots): `~/.hermes/plans/leorna/evidence/86bcm928h/`.

## Skills to load (say so in your first steps)
`leorna` (REVIEWER: the hard rules, with no Step 1 full load needed), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices` (Go reference), `mutation-testing-discipline` for spot-checking that guard tests can fail. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## What to look for
- Security first:
  - The secret leaking anywhere: files, SQLite (-wal/-shm), logs, error strings, control-plane requests, values returned to the window, process command lines, or the environment of processes other than the started tool.
  - Credential-store keying and validation, and company scoping.
  - The probe: SSRF, redirects, https-only, timeouts.
  - The server-identity binding (AC7).
  - Windows process start: an absolute executable, no `.cmd`/`.bat`, no injection through the command.
  - Sign-out order.
  - Any auth bypass, stub or plaintext fallback in product code. That is P0/P1; fakes belong only in tests.
- Correctness against every AC. Also watch for a test that can't fail, and for false AC claims.
- Plan conformance, and a ruling on each builder deviation: acceptable or a finding.
- Realistic edge cases on Windows and WSL: a tool that is already running, a missing tool, a token with odd characters, a Sync that fails partway, a migration on an existing DB, and two companies.
- Hard rules: no `.github/`, `toolconnector.Connector` or OpenAPI change; authorship; no AI attribution; no `CLAUDE.md` committed.

You may run tests, vet and your own probes, including `go test -overlay` mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …`. Never edit the worktree. Put scratch in `~/.cache/86bcm928h-review-1/`, a short real-disk path (not `/tmp`), and remove it at the end. The toolchain is off PATH: `~/.local/leorna-tools/go/bin` (go1.27.3) and `~/.local/leorna-tools/golangci-lint-2.14.0-linux-amd64/`. Bind them on a task-local PATH. Use test credentials only on the Windows side, and delete them afterwards (`cmdkey /list` must show no Leorna entry). Never print a token, a server domain or URL, or a tenant ID.

**Memory runaway:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before you read it as pass or fail.
**Long waits:** don't end your turn to wait. Use `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` calls with the Bash timeout at 175000.

## Severity (Justin's scale)
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included (inputs, configs, git operations, macOS and WSL), anything that breaks an AC or the UI, or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of the user's machines has.

Every P0–P2 needs a concrete real-use `scenario` of 5+ words: who does what, and what goes wrong.

## Write `review-1/review.json` (the referee's input)
```json
{"round": 1, "scope": "full", "from": "7a834434d00ec7afae8464f5e7ce6cc17881bb7b", "head": "e11872ff69bb32ed8bca30cd9075fef312531c09",
 "findings": [{"id": "R1-1", "severity": "P2", "file_line": "application/x.go:12", "claim": "…", "scenario": "…"}]}
```
- Ids are `R1-<k>`. Use empty `findings` when clean.
- **Self-check:** run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 7a834434d00ec7afae8464f5e7ce6cc17881bb7b ~/.hermes/plans/leorna/evidence/86bcm928h`. Exit 2 means your file is wrong, so fix it. Exits 0, 1 and 3 are the referee's verdict, not yours to act on.
- Write no other files there. Return your summary as text.

## found_else and skill_lessons
- If you find a problem outside this story's diff, list it in `found_else` with evidence and severity. Don't fold it into the findings.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`).
  - `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind, what it checks and where it runs.
  - An empty list is the normal answer.

## Return
`{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, evidence}], deviations_ruling[{n, ruling, why}], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], skill_lessons[]}`. AC8 (live) is `not_run`. End with `MAIN SESSION: check and save these skill_lessons now.`
