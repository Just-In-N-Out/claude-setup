# FIXER brief, round 2 (after review 2: REVIEW AGAIN): 86bcm928p connection test for integrations

Role: FIXER (fresh general-purpose agent, Opus 5.5, high effort). Verify the finding, fix it test-first, commit, and stop at `ready-for-next-review`. A fresh delta reviewer, a verifier and an auditor come after you. Don't push, open a PR, post to ClickUp, merge or rebase. Start no other agents.

## Inputs
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`, head `4818a8c1592f603384b24c01d97c883d15944069`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Approved plan (read only): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`. Plan choice 4: 401 is a pass; 403 and every other status is "Not an MCP endpoint (HTTP n)".
- Review 2's record and probes: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-2/` (`review.json`, `mutants/SUMMARY.txt`, `zz_review2_probe_test.go` with the six replies, the `probe-*.log` files).
- Referee lines (`review-check.sh` on review 2):
  ```
  R2-1  P2  internal/integration/connectiontest/prober.go:352  A reply that is not MCP can be reported as a pass with every test green. Four checks in the MCP reply path have no killing test. Each mutant below survives AC1, AC2, the guards test and all 20 connectiontest tests (mutants/SUMMARY.txt). R2M6: the event-stream path takes any data event as the initialize result (prober.go:352). R2M4: a result without protocolVersion counts (:340). R2M5: a reply without jsonrpc 2.0 counts (:340). R2M2: HTTP 403 counts as 'asks for sign-in' (:304), against plan choice 4. Under R2M4, R2M5 and R2M6, realistic replies read 'Connected: … answered the MCP handshake.' (probe-R2M4.log, probe-R2M5.log, probe-R2M6.log): a JSON-RPC error sent as an event stream, a reply to another id, other data, and an LSP-style initialize result. Head classifies all six as Not an MCP endpoint (probe-NONE.log), so the code is right today. Every Not-MCP fixture uses application/json or HTML, and there is no 403 case. Same class as the auditor's AC1 finding: a step can be skipped and success is still reported. Fix (test-only): add these replies as Not-MCP cases (the probe file zz_review2_probe_test.go has all six) plus a 403 case, and ideally one event-stream Not-MCP subtest in the AC2 web test.
  R2-2  P3  internal/integration/connectiontest/prober.go:279  'No proxy from the environment' has no test. With Proxy: http.ProxyFromEnvironment (R2M3), every test passes, because no test sets HTTPS_PROXY. With HTTPS_PROXY=http://127.0.0.1:9, head still passes every test (NONE~HTTPS_PROXY logs), and the mutant fails 3 web tests and 8 connectiontest tests. So one t.Setenv("HTTPS_PROXY", <dead proxy>) case in a prober test would pin it. The code is right today.
  R2-3  P3  internal/web/integration_connection_test.go:439  The AC2 test pins failure messages only for the MCP-endpoint kind. Mutants that report an entered address's DNS or TLS failure as Unreachable, with the endpoint kind unchanged (R2M1, R2M1b), are killed by the AC1 test's new address cases and by TestProbeAddressNamesTheStepThatFailed, not by the AC2 test. The behaviour is pinned by the suite. Only the mapping from AC to test is narrower than AC2's wording, which a verifier or auditor citing only the AC2 test should know.
  REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at 4818a8c: fix them, then review the fix commits
  ```

## What to fix
- **R2-1 (P2), required. Test-only, because the code is right.**
  - Add the six Not-MCP replies from `zz_review2_probe_test.go`, plus an HTTP 403 case, as negative cases in the `connectiontest` prober tests. Each must assert "Not an MCP endpoint" with its exact message.
  - Add an event-stream Not-MCP subtest **inside `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`** (under its unchanged name), so the AC2 test itself kills R2M6. Its existing "saw N distinct failure messages, want 4" logic must stay correct: a second Not-MCP case shares the "Not an MCP endpoint:" kind.
  - Show R2M2, R2M4, R2M5 and R2M6 each fail on their own assertion lines, with at least R2M6 failing in the AC2 test.
- **R2-2 (P3), optional:** add a `t.Setenv("HTTPS_PROXY", "http://127.0.0.1:9")` case if it fits naturally in the same prober test file. Say in your report whether you did.
- **R2-3 (P3), optional:** extending AC2's test with address-kind failures is welcome if cheap. Otherwise leave it as a follow-up and say so.
- Keep every existing assertion. Don't change production code or the plan. If a fix would need production code, stop with `status: stopped` and explain.

## What to do
1. Load skills with the Skill tool, in order, and say so in one line: `leorna`, `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`.
2. **Verify first:** rerun R2M2, R2M4, R2M5 and R2M6 (review 2's `mutants/` has their definitions) via `go test -overlay` against head's tests, and confirm each survives.
3. **RED:** with the new cases written, run each mutant overlaid and show it fails on the new assertion line. On unmutated head the new cases pass (the code is right). Record this in `fixer-2/mutation/red/`.
4. **Gates on the new head**, under the memory cap: AC1, AC2 and the guards test by name; `-race` on connectiontest; `make check` (8G) with the CI-pinned tools from `~/.local/leorna-toolchain`; `bash ./scripts/test-module-add.sh`; `python3 -m unittest scripts/test_release.py`; the Postgres no-skip check. Write the logs to `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/fixer-2/gates-<sha7>.txt` (+ folder).
5. **All mutants on the new head:** the builder's 19, X1, X1c and X1b (fixer 1's harness is `fixer-1/mutation/mutants.py`), and R2M2–R2M6 (plus R2M3 if you did R2-2). Record the kill lines in `fixer-2/mutation/`.
6. **Commit:** `test(86bcm928p): pin Not-MCP replies on both parse paths and 403`. No AI attribution or co-author lines, no author override, and `git log -1 --pretty=format:'%an <%ae>'` must be Justin's Leorna identity. The worktree ends clean (`git status --porcelain --untracked-files=all` empty).

## Rules
- Postgres: the containers `928p-builder-pg` and `928p-builder-ch` are running. Settings are in `~/.cache/86bcm928p-builder/env.sh` and its pg env file (0600, never print the password). Use your own `_test` database names and drop them when done.
- Scratch: your own fresh `~/.cache/86bcm928p-fixer-2/` (`mkdir` without `-p`), never `/tmp`. Remove only that folder, by its literal path.
- Nothing may reach the real internet.
- WSL memory: SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. Mutants run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- When splitting mutant arguments that carry env assignments, don't use `:` as a separator, since proxy URLs contain colons.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- Other bugs go in `found_else`; don't fix them.
- `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section: never edit skills or memory yourself. `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Report
`{status: ready-for-next-review|stopped, summary, finding_disposition[{id, verdict: fixed|rejected|deferred, test, commit, evidence}], last_commit, worktree, gates[], mutants, found_else[], skill_lessons[], stop_reason}`, then end with the line `MAIN SESSION: check and save these skill_lessons now.`
