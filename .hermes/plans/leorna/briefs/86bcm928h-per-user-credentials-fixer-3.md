# FIXER brief, round 3 (bring main in): Leorna story 86bcm928h-per-user-credentials

**Role:** FIXER: bring the new GitHub `main` into the story branch and resolve the conflicts. You are a fresh agent: Opus 5.5, effort high.

Every rule in the round-1 fixer brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-fixer-1.md`. Read it first. It covers:
- the skills and the security properties the story must keep
- `blocked-plan`
- commits and authorship, and no push, PR or post
- gates and evidence, and mutation runs under the 4G cap
- earlyoom and long waits
- found_else, skill_lessons and the return schema

It is overridden only where this file says something different.

## State
- **Worktree:** `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`
- **Branch:** `feat/86bcm928h-per-user-credentials`
- **Accepted head:** `1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2`. `ac-check.sh` printed READY FOR THE USER on it, with AC8 (live) owed to Justin. If HEAD differs, stop and report it.
- **Old base:** `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`.
- **New GitHub main:** `a7839b3af664efcfa59eb1ed3fe276ec1262a4de`, already fetched into `origin/main`. Re-fetch it first, using the `leorna` step 7.1 HTTPS-through-gh command with the URL written out. If main has moved again, use the newer SHA and say so.
- **Main now has these merged PRs:**
  - #30 `86bcryh0w` managed config drift
  - #31 `86bcm9284` predefined integration tiles
  - #32 `86bctmuwy` agent items install
- **Still open:** PR #29 (GitHub MCP fixture on the current server). It touches README.md and `toolconnector/*` tests only. Leave it alone.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm928h/plan-approved.md`, with ACs AC1–AC8 and their named tests.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm928h/`
- **TMPDIR:** `~/.cache/86bcm928h-fixer-3/tmp`

## The work
1. **Merge, don't rebase:** run `git merge origin/main`. That is the repo's convention, as in 1fa24d9 on main. Use the commit message `merge: bring main (<sha7>) into feat/86bcm928h-per-user-credentials`. Keep both sides' meaning on every conflict.
2. **Known text conflicts** (`git merge-tree` against a7839b3):
   - **`application/application.go`, a SQLite migration 9 collision.**
     - Main's #30 made migration 9 the `managed_drift_queue` table, ending in `PRAGMA user_version=9`.
     - This story's integrations migration (`integration_needs`, `integration_connections`) was also 9.
     - Keep main's 9 byte-for-byte. Move the story's migration to a `version == 9` step that ends in `PRAGMA user_version=10`.
     - Check that no released client ever shipped the story's 9. The branch was never pushed, so none should have. Say so in the report.
     - Test first:
       - a database at main's version 9, with a drift queue row, migrates to 10 with the integration tables and keeps the row;
       - a fresh database gets both migrations;
       - every test or assertion that expects user_version 9 for the story's tables now expects 10.
   - **`scripts/sync-ui.test.cjs`:** keep both sides' tests.
3. **Auto-merged files touched by both sides:**
   - `README.md`, `application/README.md`
   - `application/application.go`, `application/application_test.go`, `application/sync.go`
   - `desktop/bridge.go`
   - `cmd/leorna-client/frontend/dist/index.html`, `style.css`, `sync.js`

   Read each merged result for semantic clashes: the Sync hook ordering, the drift and agent-items work in `sync.go`, the bridge methods, and the panel IDs, CSS and script order in the frontend. Even with no text conflict, check that the Integrations panel and main's new panels (drift and restore, agent items) both still work. The story's tests and main's tests must all pass together.
4. **Story properties to keep:**
   - Credentials live only in Windows Credential Manager, never in SQLite, written configs, logs or requests.
   - The Windows launch uses each tool's absolute `.exe`, with the token only in the child's environment.
   - Check that main's agent-items and drift code never writes or reports a credential, or the env var that refers to it, in a way that breaks the story's no-secret tests. That includes drift reports that diff written MCP configs.
5. **If a correct resolution needs a decision the plan doesn't cover, stop with `status: blocked-plan`.** Give lettered options and a recommendation.
6. **Gates on the final head:** every gate from the round-1 fixer brief. That includes `make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with golangci-lint 2.14.0 and govulncheck v1.7.0, gitleaks over `origin/main..HEAD`, `GOOS=windows go vet` with Zig cgo, and the native Windows `./login` and `./application` tests with `LEORNA_TEST_SECURE_STORE=1`.
   - Run native test binaries one at a time, test credentials only.
   - `cmdkey /list` must show no "Leorna Client" entry afterwards.
   - Run each AC1–AC7 test by name as well.
   - Write `~/.hermes/plans/leorna/evidence/86bcm928h/gates-<sha7>.txt`, recording each gate's exit code.
7. **Don't re-render screenshots.** The verifier and auditor that follow will take fresh ones. If you do render an image for your own check, it must show the result only, with no banner, caption or note about how it was made (`ac-verification.md`, "No banner on evidence images").

## Rules
- Never push, open a PR, merge into main, or write to ClickUp. Don't change `.github/` or `toolconnector.Connector`. Never override author metadata. No AI attribution lines.
- Never print a token, a server domain or URL, or a tenant ID.

## Return
Same schema as round 1, with `status: ready-for-next-review` or `blocked-plan`. Also give:
- `merge_commit`, `new_head`, `main_sha`
- `conflicts[{file, resolution}]`
- `semantic_checks[]`
- `migration{main_9, story_now}`
- `gates[{name, exit, log}]`
- `ac_tests[{ac, test, exit}]`

End with `MAIN SESSION: check and save these skill_lessons now.`
