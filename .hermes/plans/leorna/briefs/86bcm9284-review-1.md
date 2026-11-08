# Brief: 86bcm9284 reviewer, round 1 (full)

**Role:** a fresh REVIEWER, report only, for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). Round 1 is a **full** review of the whole story in both repos. You never saw the build. Change no source, commit nothing, push nothing, write nothing to ClickUp. The only files you may write are the two `review.json` records below, plus scratch in `~/.cache/86bcm9284-review-1/` (never `/tmp`).

## Skills to load (Skill tool), in order
`leorna` (routing and hard rules only; skip the long context load except `leorna-control-plane-workflow.md`), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `api-contract-drift-guard` (if the API changed), `review-fix-cadence` (Justin's severity scale and brakes). Mechanics and the `review.json` format: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Read it.

## What to review
- **Control plane:** worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`, branch `feat/86bcm9284-predefined-integration-tiles`, head `beb53581bc18ab4d1a61a3a74b2330cd4110f228`, base `f0a326b83aae9d181e4f6681645685ae4b1fff91` (GitHub main, 927y merge). Range `f0a326b..beb5358`, 9 commits, 25 files.
- **Client (test fixtures only):** worktree `/home/justin/Leorna/86bcm9284-client-tile-fixtures`, branch `feat/86bcm9284-predefined-integration-tiles`, head `6d3c3c5fc6e49698004fa18f9f93c35f0d743ba8`, base `7a83443` (client GitHub main). 1 commit, 4 files under `toolconnector/testdata/`.
- **The spec:** the approved plan, `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md` (Justin approved every ⭐ answer, Q1 A–Q8 A). Judge the code against it and against the card's ACs:
  - AC1 (done): first three systems recorded.
  - AC2 (live): admin enables a tile → engineers connect with their own sign-in → working MCP config syncs. The live sign-in is owed to Justin; Google's part is a follow-up (Q3 A).
  - AC3: each tile's source, licence, sign-in and scopes are documented and vetted.
  - AC4: each tile passes the content quality gate for every declared tool.
  - AC5: on a fresh install, the three tiles are available.
- Look hard at: the new gate rule that accepts `docker run` with an image pinned by digest (the guard: can an unpinned, tag-plus-digest-spoofed, extra-flag, `--privileged`, volume-mount or env-injection form get through?); the `-tiles` wiring in `cmd/library-gate` and `make library-check` (can CI silently skip tiles?); each tile's scopes and credential handling (no token literals, credential references only, per-engineer sign-in); tenant and team isolation in the AC2 sync path; that each AC's test can actually fail; and that the client fixtures match what the control plane renders (`TestIntegrationTemplatesMatchClientGoldens`, `SOURCE.md`).
- You may run tests and probes in your own scratch copy or overlay (`go test -overlay`), never editing the worktrees. Postgres: your own `_test` DB, never `leorna-pg` or a sibling's. Toolchain: `~/.local/leorna-toolchain`, task-local PATH. Ignore the builder's claims; check them yourself. The builder's evidence is in `~/.hermes/plans/leorna/evidence/86bcm9284/` if you want to see what it saw.

## Severity (Justin's scale)
P0/P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2: a bug a real person or agent could plausibly hit, realistic edge cases included; anything that breaks an AC or the UI; or a test that can't fail. P3: cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Every P0–P2 needs a concrete real-use `scenario` of 5+ words (who does what, and what goes wrong).

## Records (two repos, so two files)
- Control plane: `~/.hermes/plans/leorna/evidence/86bcm9284/review-1/review.json`, `round: 1`, `scope: "full"`, `from: "f0a326b83aae9d181e4f6681645685ae4b1fff91"`, `head: "beb53581bc18ab4d1a61a3a74b2330cd4110f228"`.
- Client: `~/.hermes/plans/leorna/evidence/86bcm9284/leorna-client/review-1/review.json`, `round: 1`, `scope: "full"`, `from: "7a834434d00ec7afae8464f5e7ce6cc17881bb7b"` (verify the full SHA with `git rev-parse 7a83443`), `head: "6d3c3c5fc6e49698004fa18f9f93c35f0d743ba8"`. Empty `findings` if clean.
- Ids are `R1-<k>` in both files (no repo suffix). Self-check each with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence folder for that repo>`. Exit 2 means your file is wrong, so fix it. 0, 1 or 3 is the verdict; don't act on it.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
`verdict` (`clean` or `findings`), every finding (id, severity, file:line, claim, scenario), `ac_status` (one entry per AC: `{ac, status: accepted|not_accepted|not_run, reason}`; AC2's live part is `not_run`), the two review.json paths with their self-check exit codes, and skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
