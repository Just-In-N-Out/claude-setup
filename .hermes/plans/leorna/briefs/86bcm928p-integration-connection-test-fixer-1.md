# FIXER brief, round 1 (after ac-check NOT ACCEPTED): 86bcm928p connection test for integrations

Role: FIXER (fresh general-purpose agent, Opus 5.5, high effort). Verify the finding, fix it test-first, commit, and stop at `ready-for-next-review`. A fresh reviewer, a verifier and an auditor come after you. Don't push, open a PR, post to ClickUp, merge or rebase. Start no other agents.

## Inputs
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`, head `9da16b86ca2607a1242b745019fa23cf893a02df`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Approved plan (read only): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`. AC1's text is the contract: "…an entered address and its hosted MCP endpoint are both checked…".
- `ac-check.sh` output on 9da16b8:
  ```
  AC1  NOT ACCEPTED: auditor did not accept it
  AC2  ACCEPTED
  REVIEWS  CLEAN: review-1 at 9da16b8 is clean
  NOT ACCEPTED: 1 of 2 ACs on 9da16b8
  ```
- Both reports: the auditor's `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/auditor/` (`REPORT.md`, `ac.json`, `mutants/GRADED.txt`, `mutants/mutants.py` with `PROBE_SRC`, the X1/X1b/X1c logs) and the verifier's `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/verifier/` (`ac.json`; it accepted both ACs).

## The finding (auditor, P2, AC1)
`TestIntegrationConnectionTestAC1ReachabilityWithPostgres` (in `internal/web/integration_connection_test.go`) can't fail when the entered (address-kind) target isn't checked:
- **X1:** the address is never looked up, dialled or certificate-checked. Caught only by the guards test's private-address case.
- **X1c:** looked up but never dialled.
- **X1b:** dialled with no certificate check.

All three keep AC1 green, and the row still says "was found, accepted a connection and has a valid certificate". X1c and X1b survive every test. Every DNS/TLS/refused failure fixture uses MCP targets; `TestProbeAddressStopsAfterTheCertificateCheck` asserts only the label on a healthy fixture.

The head code is correct. The fix is **test-only**: strengthen the AC1 test **under its unchanged name** with address-kind failure cases (an unknown name → `dns_failed`, a closed port → `unreachable`, an untrusted certificate → `tls_failed`), each asserting the address row's own message, plus a healthy control. Use the existing fake resolver/dialer/test-CA fixtures; nothing may reach the real internet. The auditor's probe (`PROBE_SRC`) shows the shape. Add the matching unit cases in the `connectiontest` prober tests too, if that is the natural home for the per-step address checks; the AC1 test itself must kill X1, X1b and X1c.

## What to do
1. Load skills with the Skill tool, in order, and say so in one line: `leorna` (FINISHER-style fix pass), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`.
2. **Verify the finding first:** rerun the auditor's X1, X1b and X1c mutants (or your own equivalents) via `go test -overlay` against head's tests, and confirm each survives AC1.
3. **RED:** write the new cases, then run them with each mutant overlaid and show each fails on its own assertion line. On unmutated head the new cases must pass, since the code is right; that is expected for a test-strengthening fix. Record the mutant runs as your RED.
4. Keep every existing AC1 assertion. Don't change the AC2 test, the code, or the plan.
5. Rerun under the memory cap: AC1 and AC2 by name, the guards test, `go test -race ./internal/integration/connectiontest/`, and the full gates (`make check` with the CI-pinned tools from `~/.local/leorna-toolchain`, `bash ./scripts/test-module-add.sh`, `python3 -m unittest scripts/test_release.py`, and the Postgres no-skip check). Save the logs in `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/fixer-1/`.
6. Rerun the builder's 19 mutants plus X1, X1b and X1c on the new head, and record the kill lines in `fixer-1/mutation/`.
7. Commit: `test(86bcm928p): AC1 checks each step of an entered address`, with no AI attribution or co-author lines and no author override. Check that `git log -1 --pretty=format:'%an <%ae>'` is Justin's Leorna identity. The worktree must end clean (`git status --porcelain --untracked-files=all` empty).

## Rules
- Postgres: the containers `928p-builder-pg` and `928p-builder-ch` are running; settings are in `~/.cache/86bcm928p-builder/env.sh` and its pg env file (0600, never print the password). Use your own `_test` database names, and drop them when done.
- Keep scratch in your own fresh `~/.cache/86bcm928p-fixer-1/` (`mkdir` without `-p`), never `/tmp`. Remove only that folder, by its literal path.
- WSL memory: SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. Run mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, and `make check` may need 8G.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- Evidence images, if you make any, carry no banner or caption about how they were made.
- Other bugs go in `found_else`; don't fix them. The auditor's P3 (a credential reference in an unlisted header is caught only by the supporting unit test) stays a follow-up unless your fix touches it naturally.
- `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section: never edit skills or memory yourself. `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Report
`{status: ready-for-next-review|stopped, summary, finding_disposition[{id, verdict: fixed|rejected, test, commit, evidence}], last_commit, worktree, gates[], mutants, found_else[], skill_lessons[], stop_reason}`, then end with the line `MAIN SESSION: check and save these skill_lessons now.`
