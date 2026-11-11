# VERIFIER brief, round 1: 86bcm928p connection test for integrations (Leorna, leorna-control-plane)

**Role:** fresh, read-only VERIFIER. You never saw the build. Change no source and commit nothing. Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/verifier/` (create it). Keep all scratch in your own fresh folder `~/.cache/86bcm928p-verifier/` (`mkdir` without `-p`), including TMPDIR, Chrome profiles, built binaries and base copies. Never use `/tmp`, which is a small shared RAM disk.
**Model/effort:** Opus 5.5, high.

## Story and inputs
ClickUp 86bcm928p, "Connection test for integrations". An admin clicks **Test connection** on a saved integration in the admin console. The server checks the saved URL / MCP endpoint without credentials and shows the result; a failure names the step that failed (DNS, TLS, unreachable, not an MCP endpoint).
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`.
- Head `9da16b86ca2607a1242b745019fa23cf893a02df`; the review loop said MOVE ON at this head. Base `4ef14efb46da789aec30fad1e5a988d8770140e2` (the story base; GitHub main when the build started).
- Approved plan (read only; its AC list is the contract): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`.
  - AC1: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres` (`internal/web`)
  - AC2: `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres` (`internal/web`)
  - No `(live)` ACs.
- Review record: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-1/review.json`. It has no P0–P2, so there is nothing to confirm closed; its six P3s are follow-ups.
- The plan's "Old-code behaviour" section says what base gives: `[build failed]` (`SetIntegrationConnectionTest undefined`) with the new package copied in, and the plan gives a one-function shim that turns it into each test's own failure line. Per `ac-verification.md`, the `base_log` must show a real failure of the test (its own fail line, or a build failure of the new code). A shim run is labelled in the log's second line.

## Skills to load (say so in your first steps)
`leorna` (VERIFIER role), `engineering-best-practices`, `mutation-testing-discipline`, `security-best-practices` (GO-SSRF-001), `multi-tenant-auth-management`. Then follow `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` exactly: "Folders and the run recipe", then Steps → VERIFIER.

## What to do
1. **Gates:** re-run the project's gates on head yourself, as the plan's Gates section says: `make check` with the CI-pinned golangci-lint and govulncheck from `~/.local/leorna-toolchain` first in PATH (versions echoed); `bash ./scripts/test-module-add.sh` (serially); `python3 -m unittest scripts/test_release.py`; and the Postgres no-skip check. Use your **own** Postgres (and ClickHouse if the plan's gates need it) containers or your own `_test` databases. The builder's containers `928p-builder-pg` and `928p-builder-ch` are running; you may use them with your own database names, and never print the password. Drop what you create.
2. **Every AC:** run only that AC's named test on head and on base, per `ac-verification.md`. Write `verifier/ac<n>-9da16b8.log` and `verifier/ac<n>-base-4ef14ef.log`. Run base in a separate detached copy, never in the worktree, and copy in head's AC test file plus the new `internal/integration/connectiontest/` package the test imports.
   - The test must pass on head (its own pass line, no skip) and fail on base.
   - Before judging an AC, run `git log -p 4ef14ef..HEAD -- <its test files>` and read every changed assertion against the approved AC text.
   - For a clause the test seems not to exercise, prove it with an overlay mutant (`go test -overlay`, under the memory cap).
   - Record each row's exact `command`.
3. **One screenshot per AC, your own,** in `verifier/` (`ac<n>-<what>.png`). Prefer the real page: the plan's opt-in browser test (see its evidence task) writes real page pictures of the Test result. Run it from a scratch copy of head into your own folder, never into the builder's or the evidence root. Otherwise render that AC's head log as a page with Chrome for Testing, as `ac-verification.md` describes for the WSL desktop.
   - **No banner on evidence images** (Justin, 2026-11-10): the image shows the result only, with no caption, label or note about how it was made (no "local rendering", test names, stub, SHA, "lines elided", redaction notes).
   - Check each PNG's magic bytes and look at it. No email, server domain, token or tenant ID may be visible.
4. **`verifier/ac.json`:** write it in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Self-check blind as the guide says: `cp` your `ac.json`, logs and images to a scratch folder, run `ac-check.sh --repo /home/justin/Leorna/86bcm928p-integration-connection-test --base 4ef14efb46da789aec30fad1e5a988d8770140e2 --plan /home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md /home/justin/.hermes/plans/leorna/evidence/86bcm928p/verifier/ac.json <scratch>/ac.json` (no `--reviews`), then remove the copy.

## Rules
- The worktree must stay clean (`git status --porcelain --untracked-files=all` empty) and at head. Don't run a repo-wide `git worktree prune`; remove only your own detached copies with `git worktree remove --force <own path>`.
- Tests must not reach the real internet; the opt-in live run is a gate step, not an AC.
- WSL PATH has entries with spaces (`/mnt/c/Program Files/...`): export PATH in scripts, and never pass `PATH=…:$PATH` unquoted. Read an EXIT=127 as an invocation error.
- Memory (WSL desktop): SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. Run mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (`make check` may need 8G).
- Long commands: start with `cmd >log 2>&1 & echo pid=$!`, then wait with repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- Other bugs go in `found_else` (one line each, with severity and evidence).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], found_else[], skill_lessons[]}`. `clean` requires both ACs accepted. End with `MAIN SESSION: check and save these skill_lessons now.`
