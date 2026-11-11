# VERIFIER brief, round 3 (PR head): 86bcm928p connection test for integrations (Leorna, leorna-control-plane)

**Role:** fresh, read-only VERIFIER. You never saw the build.
- Change no source and commit nothing.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/verifier-3/` (create it).
- Keep all scratch in your own fresh folder `~/.cache/86bcm928p-verifier-3/` (`mkdir` without `-p`). That includes TMPDIR, Chrome profiles, built binaries and base copies. Never use `/tmp`.

**Model/effort:** Opus 5.5, high.

## Why this round
The story was ALL ACCEPTED on `ecbd6b5`. Since then:
- GitHub main `09924b5` was merged in (merge commit `80491bd`). It brings Go 1.27.4 (#124), #123 and OIDC SSO (#125).
- The PR-number record commit `6eeeb26` was added.
- Review 4 (delta) was clean at `6eeeb26`.
- PR #126 is open with head `6eeeb26`.

Main moved, so this head gets a full recheck (Justin: "After you put out the PR, run verifications to make sure everything's good").

## Story and inputs
ClickUp 86bcm928p, "Connection test for integrations". An admin clicks **Test connection** on a saved integration in the admin console. The server checks the saved URL / MCP endpoint without credentials and shows the result. A failure names the step that failed (DNS, TLS, unreachable, not an MCP endpoint).
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`.
- Head: `6eeeb26692bd3c6f493e2a8de36121e153b75075`.
- **Base for old-code runs:** `09924b5e38473a93d8520cb849441a200ab73761`. This is `git merge-base HEAD origin/main`, i.e. the main that was merged in.
- Approved plan (read only; its AC list is the contract): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`.
  - AC1: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres` (`internal/web`)
  - AC2: `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres` (`internal/web`)
  - No `(live)` ACs.
- The plan's "Old-code behaviour" section says what base gives: `[build failed]` (`SetIntegrationConnectionTest undefined`) with the new package copied in. The plan also gives a one-function shim that turns this into each test's own failure line. Per `ac-verification.md`, the `base_log` must show a real failure of the test: its own fail line, or a build failure of the new code. A shim run is labelled in the log's second line.

## Skills to load (say so in your first steps)
`leorna` (VERIFIER role), `engineering-best-practices`, `mutation-testing-discipline`, `security-best-practices` (GO-SSRF-001), `multi-tenant-auth-management`.

Then follow `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` exactly: first "Folders and the run recipe", then Steps → VERIFIER.

## What to do
1. **Gates:** re-run the project's gates on head yourself, as the plan's Gates section says:
   - `make check`, with `~/.local/leorna-toolchain/go1.27.4/bin` and then `~/.local/leorna-toolchain/bin` (CI-pinned golangci-lint and govulncheck) first in PATH. Echo the versions. `make audit` is expected to pass now.
   - `bash ./scripts/test-module-add.sh`, run serially.
   - `python3 -m unittest scripts/test_release.py`.
   - The Postgres no-skip check.

   Use your **own** Postgres container (and ClickHouse if the gates need it), named `928p-ver3-*`, on loopback ports. Never touch `leorna-pg` or `leorna-test-pg`, and never print a password. Remove your containers when done.
2. **Every AC:** run only that AC's named test on head and on base, per `ac-verification.md`. Write `verifier-3/ac<n>-6eeeb26.log` and `verifier-3/ac<n>-base-09924b5.log`.
   - Run base in a separate detached copy, never in the worktree. Copy in head's AC test file plus the new `internal/integration/connectiontest/` package the test imports.
   - The test must pass on head (its own pass line, no skip) and fail on base.
   - Before judging an AC, run `git log -p 4ef14ef..HEAD -- <its test files>` and read every changed assertion against the approved AC text.
   - For a clause the test seems not to exercise, prove it with an overlay mutant (`go test -overlay`, under the memory cap).
   - Check that main's new SSO code (#125) doesn't change the story's route behaviour, its admin/CSRF guards, or what an admin sees.
   - Record each row's exact `command`.
3. **One screenshot per AC, your own,** in `verifier-3/` (`ac<n>-<what>.png`).
   - Prefer the real page: the plan's opt-in browser test (see its evidence task) writes real page pictures of the Test result. Run it from a scratch copy of head into your own folder.
   - **No banner on evidence images** (Justin, 2026-11-10): the image shows the result only. No caption, label or note about how it was made.
   - Check each PNG's magic bytes and look at it. No email, server domain, token or tenant ID may be visible.
4. **`verifier-3/ac.json`:** write it in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Then self-check blind, as the guide says:
   - `cp` your `ac.json`, logs and images to a scratch folder;
   - run `ac-check.sh --repo /home/justin/Leorna/86bcm928p-integration-connection-test --base 09924b5e38473a93d8520cb849441a200ab73761 --plan /home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md /home/justin/.hermes/plans/leorna/evidence/86bcm928p/verifier-3/ac.json <scratch>/ac.json` (no `--reviews`);
   - then remove the copy.

## Rules
- The worktree must stay clean (`git status --porcelain --untracked-files=all` empty) and at head. Don't run a repo-wide `git worktree prune`. Remove only your own detached copies, with `git worktree remove --force <own path>`.
- Tests must not reach the real internet.
- WSL PATH has entries with spaces: export PATH in scripts, and never pass `PATH=…:$PATH` unquoted. Read an EXIT=127 as an invocation error.
- Memory (WSL desktop): SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. Run mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; `make check` may need 8G.
- Long commands: start with `cmd >log 2>&1 & echo pid=$!`, then wait with repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- Other bugs go in `found_else` (one line each, with severity and evidence).
- **skill_lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line check proposal. An empty list is the normal answer.

## Report (as text)
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], found_else[], skill_lessons[]}`. `clean` requires both ACs to be accepted. End with `MAIN SESSION: check and save these skill_lessons now.`
