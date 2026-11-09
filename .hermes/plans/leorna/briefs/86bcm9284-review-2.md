# Brief: 86bcm9284 reviewer, round 2 (full, after bring-main-in)

**Role:** a fresh REVIEWER, report only, for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). Round 2 is a **full** review of the whole story on its new head, after main was merged in. You never saw the build or earlier reviews' work. Change no source, commit nothing, push nothing, write nothing to ClickUp. The only file you may write is the `review.json` below. Scratch goes in a fresh `~/.cache/86bcm9284-review-2/`, never `/tmp`; remove it at the end.

## Skills to load (Skill tool), in order
`leorna` (routing and hard rules, plus step 7.2's merge-proof rules; skip the long context load except `leorna-control-plane-workflow.md`), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `review-fix-cadence`. Mechanics and the `review.json` format: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.

## What to review
- **Control plane:** worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`, branch `feat/86bcm9284-predefined-integration-tiles`, head `9b61ff056d191edb060ed60cd3d325d7f4ebd483`. New base `dadba89ec84aab28c386b3b9ede112471f1f605b` (GitHub main; confirm it with `git merge-base HEAD origin/main`). The story's own changes are `git diff dadba89...HEAD`.
  - The commits since round 1's head `beb5358` are merge `cb9dcb0` (main `dadba89` brought in) and fix `9b61ff0` (`fix(86bcm9284): serve the tiles test's desktop API on its canonical host`).
  - The merge hand-resolved `internal/integration/README.md` (main's 86bcm928t "Governance and usage" section first, then this story's "Predefined tiles" section) and `delivery/stories.json` (this story's entry appended last).
  - The fix applies #115's `discoveryHost`/`BackendUrl` fixture change to this story's `newPredefinedTilesFixture`.
- **Pay particular attention to the interaction with main's new code:** 86bcm928t (integration governance: configured integration items reach engineers only through assigned packs, the older item form excludes them, and Content usage shows integrations) and 86bccndx6 (custom domain: the desktop API answers only on the deployment's canonical host). Does this story's tile work still hold with them? Is the README merge accurate for both? Do the story's tests still prove their ACs, not just pass?
- **Previous round:** `~/.hermes/plans/leorna/evidence/86bcm9284/review-1/review.json` (clean, 4 P3s at `beb5358`). Set `repeats` on any finding that is the same defect.
- **The spec:** `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md`. ACs:
  - AC1 (done) `TestEmbeddedTilesCoverTheFirstThreeSystems`
  - AC2 (live) `TestPredefinedTilesAC2EnableAndSyncWithPostgres`
  - AC3 `TestTileVettingIsDocumented`
  - AC4 `TestShippedTilesPassTheGate`
  - AC5 `TestPredefinedTilesAC5FreshInstallWithPostgres`
- The client branch (`6d3c3c5`, 4 fixture files) is unchanged since round 1's clean client review; you don't need to re-review it, except to confirm the control plane's `SOURCE.md` and goldens still match it.
- You may run tests and probes in your own scratch copy or with `go test -overlay`, never editing the worktree. Use your own Postgres container and `_test` DB, never `leorna-pg` or a sibling's. Toolchain: `~/.local/leorna-toolchain`, on a task-local PATH. The fixer's logs are in `~/.hermes/plans/leorna/evidence/86bcm9284/fixer-1/` if you want them, but check things yourself.

## Severity (Justin's scale)
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit (realistic edge cases included), anything that breaks an AC or the UI, or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.

Every P0–P2 needs a concrete real-use `scenario` of 5+ words.

## Record
Write `~/.hermes/plans/leorna/evidence/86bcm9284/review-2/review.json` with `round: 2`, `scope: "full"`, `from: "dadba89ec84aab28c386b3b9ede112471f1f605b"` and `head: "9b61ff056d191edb060ed60cd3d325d7f4ebd483"`. Ids are `R2-<k>`. Self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm9284-predefined-integration-tiles --base dadba89ec84aab28c386b3b9ede112471f1f605b ~/.hermes/plans/leorna/evidence/86bcm9284`. Exit 2 means your file is wrong, so fix it.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. If Docker's socket dies (a Docker Desktop crash), don't restart it: report it.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
`verdict` (`clean` or `findings`), every finding (id, severity, file:line, claim, scenario, repeats), `ac_status` per AC (AC2's live part is `not_run`), the review.json path and its self-check exit code, and skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
