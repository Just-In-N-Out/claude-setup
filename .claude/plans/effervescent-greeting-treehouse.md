# Review plan: feat/86bbu3xfg-seed-loader (review only, no commit/push/PR)

## Context
Review of 3 local commits (8da59b4, d505698, baabcd3) on top of main 38fe070 for
ClickUp 86bbu3xfg "Load seed pack into selected DB on setup". Plan mode stopped
the review after the read-only part. What is left runs tests against the local
test Postgres and makes temporary source edits (mutations), so it needs approval.
The tree must end clean (`deploy/local/` was already untracked before, dated Sep 18, not part of the branch).

## Already verified (read-only)
- Diff read in full. Branch changes: `seedBaseError` + `pack.ErrSeedLoad`
  (pack_versions.go:215-271, version.go:14-17), new `TestEnsureSeedBaseWithPostgres`
  with 4 subtests (pack_versions_test.go:118-258), README section, stories.json.
- Only caller outside tests: cmd/control-plane/main.go:74 (startup, after migrations);
  error is logged as "control plane stopped" at main.go:38. README claim is true.
- Race claim is backed by the partial unique index `pack_versions_base_version`
  (migrations/000015_pack_versions.up.sql:12).
- Error messages drop the pg error. No DB internals leak, but the operator also loses
  the root cause (for example permission denied or disk full). main already hid it via orgError.
- stories.json: valid JSON, same `indent=2` format as main (re-dump is byte-identical).
  gh confirms: control-plane #35 MERGED (86bbu3xfp), #37 MERGED (title says 86bbu3xf8,
  adds EnsureSeedBase + main.go call), leorna-client #7 MERGED (86bbu3xfz).
- Commits: author/committer `Justin Issa <justin@leorna.com>` (from ~/.gitconfig-leorna,
  no override), no Co-Authored-By/AI lines, no CLAUDE.md tracked (AGENTS.md is tracked by design).
- No new unit test: only the Postgres integration test was added.
- OpenAPI: no API touched (no web/contracts files in diff) -> N/A.

## Issues found so far (to confirm/report)
1. Introduced: stories.json 86bbu3xfg lists only [37]. This branch's own PR is not
   inventoried (it doesn't exist yet), so the gate could pass without it once it's merged. Add the number when the PR opens.
2. Introduced (scope): commit baabcd3 also adds 86bbu3xfp/86bbu3xfz entries, which are unrelated stories.
   These are docs-only, correct, and harmless, but they are outside this story.
3. Open question: "selected DB" / "Given a ready DB connection". The codebase has
   tenant cloud connections that flip to `ready` (internal/cloud/provision/service.go:127)
   and ConnectExisting (scaleway.go:71). The card note lists "selected/ready database
   integration" as *remaining*. The branch reads it as the control plane's own Postgres
   and states this as fact in the README instead of as an assumption. Needs a card-owner decision.
4. Introduced, minor: "commit failed; nothing was saved" can be false if the connection
   drops after COMMIT is sent. The retry is idempotent, so this is only wording.
5. Introduced, minor: `newUUID` / `DefaultSeed` errors are still returned raw (not ErrSeedLoad).
6. Test robustness, minor: `waitForLockWait` counts any Lock waiter in the DB. Under
   `make test`, internal/web tests share the DB (their own schemas), so it could return early.
   This would give a weaker pass, not a false failure.
7. Pre-existing: story 86bbu3xf8 (PackStore, PR #37) is not in stories.json.
   Idempotency is keyed on seed version only, so a seed.json change without a version bump won't reach existing DBs.

## Steps to run after approval
1. Env: `export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_test?sslmode=disable'`
   (leorna-test-pg is already Up).
2. `go test ./internal/store/postgres -run TestEnsureSeedBaseWithPostgres -count=1 -v`
   Confirm that all 4 subtests show PASS (not SKIP) and capture the "setup reports:" log line.
3. `go test -race ./internal/store/postgres -run TestEnsureSeedBaseWithPostgres -count=20`
4. `make check` (helm/tofu not installed; not part of `check`). Note any tool/network failures separately.
5. `bash ./scripts/test-module-add.sh`, then
   `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, then `go test ./internal/pack/... -count=1`.
6. Mutations. Edit only inside EnsureSeedBase in internal/store/postgres/pack_versions.go.
   Run `-run 'TestEnsureSeedBaseWithPostgres|TestPackVersionStore' -count=1 -v`
   and restore with `git checkout -- internal/store/postgres/pack_versions.go` + `git diff --quiet` after each:
   - (a) line 259 -> `return orgError(err)`. Expect the write-failure subtest to FAIL.
   - (b) line 226 `if exists` -> `if false && exists` AND line 239 23505 branch -> `if false && ...`.
     Expect re-run + race to FAIL (TestPackVersionStore 2nd call too).
   - (c) only the line 239 23505 branch disabled. Expect the race subtest to FAIL and the others to pass.
   - (d) `continue` on the last seed item. Expect happy path, re-run and retry to FAIL.
   - (e) extra: `_ = tx.Commit(ctx)` before the item-failure return. Expect "nothing saved" to FAIL.
7. Final: `git status` + `git diff` + `git diff main..HEAD --stat` unchanged. Confirm the tree is clean
   apart from the pre-existing `deploy/local/`.

## Report format
One-line verdict, AC/DoD table with evidence, commands + real results,
mutation results, and issues labelled introduced/pre-existing with file:line.
