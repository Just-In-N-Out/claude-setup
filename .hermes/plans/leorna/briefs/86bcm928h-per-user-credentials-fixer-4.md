# FIXER brief, round 4: Leorna story 86bcm928h-per-user-credentials

**Role:** FIXER for review round 4. You are a fresh agent: Opus 5.5, effort high.

Every rule in the round-1 fixer brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-fixer-1.md`. Read it first. It covers:
- the skills and the security properties the story must keep
- `blocked-plan`
- commits and authorship, and no push, PR or post
- gates and evidence, and mutation runs under the 4G cap
- earlyoom and long waits
- found_else, skill_lessons and the return schema

It is overridden only where this file says something different.

- **Reviewed head:** `9b35bbbfb6b798d1729fd203c37d56cd4a070d56`. It holds the bring-main merge a608c1d of GitHub main a7839b3. Don't rebase, and don't merge main again. If HEAD differs, stop and report it.
- **Earlier records:**
  - `review-4/review.json`
  - `bring-main-3/`
  - the round-3 fixer brief, `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-fixer-3.md`
- **TMPDIR:** `~/.cache/86bcm928h-fixer-4/tmp`
- **Justin's answer:** "Fix now". It is recorded in `review-4/justin.json`.

## The referee's lines (verbatim). Fix the P2
```
R4-1  P2  application/application_test.go:361  The 'version 11 refused' subtest (renumbered by the merge from the story's own 'version 10 refused', added in c4b47f5) cannot fail on the version guard it is named for. Its fixture is `CREATE TABLE run_logs (id INTEGER PRIMARY KEY); PRAGMA user_version=11`, so Open errors at the interrupted-Sync recovery UPDATE (application.go:263, no status column) whether or not `if version != 10` refuses the file. Overlay mutants `version != 10` -> `version < 10` and 'guard deleted' both pass TestMigrationCreatesIntegrationTables, and the deleted-guard mutant passes the whole ./application and ./desktop suites. head's code is correct: a full-schema file set to user_version=11 is refused with 'unsupported local database version 11', and with the guard deleted that same file opens (err=nil).
R4-2  P3  application/application.go:235  A database written by the story's pre-renumber build (user_version 9 = integration tables, no managed_drift_queue) fails to open at head with 'create integration records: table integration_needs already exists'. ... The PR migration notes should say a dev database from the pre-renumber build must be deleted.
REVIEW AGAIN: 1 P0-P2 finding(s) in review-4 at 9b35bbb: fix them, then review the fix commits
```
R4-2 is P3 and is already in `follow-ups.md`; the finisher puts it in the PR's migration notes. Leave the code alone for it.

## The fix for R4-1 (test only, unless the guard itself is wrong)
1. **Build the fixture for real.**
   - Make the version-11 file with a real `Open`, so it has the full current schema.
   - Close it, set `PRAGMA user_version=11`, and reopen it.
   - Assert that Open fails with the guard's own error, naming version 11 ("unsupported local database version 11").
   - Also assert that nothing in the file changed: user_version is still 11, and no table was added or dropped.
2. **Mutation proof, under the 4G cap via `go test -overlay`,** with env assignments quoted (`env "PATH=$PATH" …`). Each of these mutants must now fail the test:
   - `version != 10` → `version < 10`
   - the guard deleted
   - Show RED for each against the old test and GREEN for the real code. Save the logs to `~/.hermes/plans/leorna/evidence/86bcm928h/fixer-4/`.
3. **Check for the same pattern.** Does any other refusal or "unknown version" test in `application/` or `desktop/` use a stub fixture that fails before its guard? Fix any you find in the same way, each with its mutant, and list them.
4. **Commit:** `fix(86bcm928h): the unknown-version test refuses a real database at version 11`. Use plain `git commit`, with no AI attribution lines.
5. **Gates on the final head:**
   - `make check`
   - `node --test scripts/*-ui.test.cjs`
   - `make lint audit` with golangci-lint 2.14.0 and govulncheck v1.7.0
   - gitleaks over `origin/main..HEAD`
   - `GOOS=windows go vet` with Zig cgo
   - the native Windows `./application` tests with `LEORNA_TEST_SECURE_STORE=1`, run one binary at a time, test credentials only, with `cmdkey /list` showing no "Leorna Client" entry afterwards
   - every AC1–AC7 test by name

   Write `~/.hermes/plans/leorna/evidence/86bcm928h/gates-<sha7>.txt`, recording each gate's exit code.
6. **Don't render screenshots.** The verifier and auditor take fresh ones.

## Return
Same schema as round 1, with `status: ready-for-next-review` or `blocked-plan`, plus `new_head`, `mutants[{mutant, before_fix, after_fix}]` and `gates[{name, exit, log}]`. Write `~/.hermes/plans/leorna/evidence/86bcm928h/fixer-4-report.md` with the same content. End with `MAIN SESSION: check and save these skill_lessons now.`
