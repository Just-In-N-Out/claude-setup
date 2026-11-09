# Brief: 86bcm9284 verifier, round 2 (head 9b61ff0, after main was merged in)

**Role:** a fresh, read-only VERIFIER for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). You never saw the build. Review round 2 (full) printed MOVE ON at the control-plane head below, and the client is unchanged since its clean round 1. An earlier verifier accepted the story at head `beb5358`; main `dadba89` has since been merged in (merge `cb9dcb0`, fix `9b61ff0`), so everything is proven again on the new head. Before writing anything, move the earlier verifier files in `verifier/` into `verifier/superseded-beb5358/` (no `rm`). Change no source, commit nothing, push nothing, write nothing to ClickUp. Write only inside `~/.hermes/plans/leorna/evidence/86bcm9284/verifier/` (create it). Scratch goes in a fresh `~/.cache/86bcm9284-verifier/` (create it with `mkdir`, not `-p`; never `/tmp`, a 7.9 GB RAM tmpfs shared by every session). Point `TMPDIR`, Chrome profiles, built binaries and Postgres data there, and remove only that folder, by its literal absolute path, at the end.

## Skills to load (Skill tool), in order
`leorna` (hard rules, the gate recipe in "Doing a story" step 4, and the DB-skip rules; read `leorna-control-plane-workflow.md` too), `engineering-best-practices`. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full and follow its run recipe, and the ac.json format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## What you verify
- **Control plane (the `--repo` for ac-check):** worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`, head `9b61ff056d191edb060ed60cd3d325d7f4ebd483`, base `dadba89ec84aab28c386b3b9ede112471f1f605b` (= `git merge-base HEAD origin/main`; confirm it, and re-fetch GitHub main over HTTPS via gh to make sure it hasn't moved again).
- **Client (supporting receipts only):** worktree `/home/justin/Leorna/86bcm9284-client-tile-fixtures`, head `6d3c3c5fc6e49698004fa18f9f93c35f0d743ba8`, base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`. Test fixtures only.
- **The spec:** `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md` (read-only approved copy, every ⭐ answer approved). ACs and their named tests:
  - AC1 (done): `TestEmbeddedTilesCoverTheFirstThreeSystems`. It passes on base by design, so use `base_exempt` with a reason, after running it on base anyway.
  - AC2 (live): `TestPredefinedTilesAC2EnableAndSyncWithPostgres` on head and base, **plus the live check**. Justin asked that agents run the live part themselves. A runner built an unattended script: read `~/.hermes/plans/leorna/evidence/86bcm9284/ac2-live-route/runbook.md`, then run `run-ac2-live.sh --head 9b61ff0… --out ~/.hermes/plans/leorna/evidence/86bcm9284/verifier/ac2-live --work ~/.cache/86bcm9284-verifier/ac2-live`, after the gates. Don't open the runner's own `run-1/` or `run-2/` receipts. Justin's rulings are in `ac2-live-route/justin-rulings.md`: the Codex stand-in model counts as live. Justin may complete the ClickUp browser sign-in for Codex and Cursor (`signin-clickup.sh`) while you work. If those checks still print `# TODO`, they are owed to him. The Cursor GitHub check reaches only `tools/list` without a Cursor account sign-in.
    - Judge AC2 against the AC text and the plan: given a predefined tile, when an admin enables it, engineers connect with their own sign-in and a working MCP config syncs to their tools (Google deferred by Q3 A).
    - Accept AC2 only if the live checks prove that clause for the declared tools. Otherwise its row is `"accepted": false, "not_run": "live: <exactly which tool × service checks are still owed and why>"`.
    - Either way, cite the live script's TAP lines in `evidence`.
    - GitHub uses Justin's own `gh` login as the engineer's token (never print it), and ClickUp uses each tool's own sign-in.
  - AC3: `TestTileVettingIsDocumented`.
  - AC4: `TestShippedTilesPassTheGate`.
  - AC5: `TestPredefinedTilesAC5FreshInstallWithPostgres`. It passes on base as a characterization test (plan, line ~100): `base_exempt` with a reason, after running it on base. Also prove it can fail (e.g. an overlay dropping one tile from the embed) as a supporting receipt.
- Before judging an AC, run `git log -p <base>..HEAD -- <its test files>` and read every assertion against the approved plan: a test can be narrower than its AC.

## The work
1. **Re-run the gates on head** and keep the real output: control-plane `make check` (CI's linter and govulncheck from `~/.local/leorna-toolchain`, bound task-locally with absolute `GOLANGCI_LINT=`/`GOVULNCHECK=`; your own Postgres container on a free loopback port and your own `_test` DB, never `leorna-pg` or a sibling's), the `go test -json` DB stream with the `leorna` skill's skip rules plus the story's own packages (read each skip reason), `bash ./scripts/test-module-add.sh` run serially, and `make -s library-check` showing every tile × variant × tool. Client: `go test ./toolconnector/...` and `make check` if feasible. `git diff --name-only <base>...HEAD -- .github` must be empty in both repos.
2. **Each AC on head and on base**, per the run recipe: `HEAD=` first line, `EXIT=` last line, `go test -v -count=1 -run '^<Test>$' <pkg>`, with base in a separate detached copy holding head's test files, never in the worktree. Logs are `verifier/ac<n>-<head7>.log` and `verifier/ac<n>-base-<base7>.log`.
3. **One screenshot per AC, taken by you:** a real terminal capture of each AC's run (command, output, exit code). For AC5, also a real capture of the admin Integrations page on an empty `_test` DB with the head binary. Before saving, check that no URL bar, token, email or tenant ID is visible.
4. Write `verifier/ac.json` in ac-check's format (head = the control-plane head). Self-check it blind, as the reference says: `cp` your ac.json and receipts into scratch and run `ac-check.sh --repo <cp worktree> --base <base> --plan <plan-approved.md> <your ac.json> <scratch copy>/ac.json`, without `--reviews`.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result. If earlyoom killed it, say so, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (raise to 8G for `make check` if 4G is too small, and say so).

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
`verdict` (`clean` only when AC1, AC3, AC4 and AC5 are accepted and AC2 is `not_run` live; otherwise `not_clean`, with what failed), `ac_status` per AC, gate results with log paths, the ac.json path and its self-check last line, and skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
