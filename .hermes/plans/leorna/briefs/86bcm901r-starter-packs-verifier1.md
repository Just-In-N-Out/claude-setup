# VERIFIER brief (read only): 86bcm901r-starter-packs [leorna]

**Role:** VERIFIER (read only) for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). You are a fresh agent that never saw the build. You run after the full review cadence (review 1 → fix 1 → review 2 → fix 2), as the independent verifier of the Agent Defect Loop (`backend-data-migrations`) and the first of the two AC proofs (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → VERIFIER). After you, if you return `clean`, a blind AC auditor proves every AC again without seeing your work, and a script compares your two reports.

**Source is read only for you:** no commit, push, merge or file edit in the worktree; restore anything you touch. You write only into `~/.hermes/plans/leorna/evidence/86bcm901r/verifier/` (create it fresh; it must not exist yet).

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Mac-only recipes don't apply; screenshots use `ac-verification.md`'s WSL method (a log rendered in a `<pre>` page, captured with Chrome for Testing: `~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `env -u DISPLAY -u WAYLAND_DISPLAY`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`).

## What you verify

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`.
- **Head:** `398af64906adc26726f79cae81ce4d00355b7092`. **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (= `git merge-base HEAD origin/main`; GitHub `main` was still `6c1709e` at fixer 2's check). First confirm HEAD is `398af64` and `git status --porcelain` is empty; if not, stop and report.
- **Approved plan (the contract, read-only copy):** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (approved 2026-10-29 under Justin's away grant, every ⭐: Q1–Q6 A).

## Acceptance criteria (each needs its own test log on head, a base log, and a screenshot in YOUR folder)

- **AC1:** fresh install → the agreed starter packs are in the catalog. Test `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres` (`./internal/web`).
- **AC2:** assigned to a team → engineers sync it in all three tools. Test `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres` (`./internal/web`).
- **AC3:** library item update → starter packs pick up the new version on the next library release. Test `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres` (`./internal/store/postgres`).
- **AC4 (proposed) (live):** Justin's real desktop Sync. Agents can't run it: `"accepted": false, "not_run": "live: needs Justin's own server installed from this branch and his desktop app"`. Check `ac4-live/CHECKLIST.md` names `398af64` and its file lists match head's AC2 output.
- **AC5 (proposed):** a bad definition or failed write stops the load, writes nothing, a retry works. Test `TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres` (`./internal/store/postgres`).

Follow `ac-verification.md` exactly: run each AC test **by its own name** (`go test -v -count=1 -run '^<Name>$' <pkg>`) on head from the worktree (`go test` alone is safe there), saving `verifier/ac<n>-<head7>.log` with first line `HEAD=<sha>` and last line `EXIT=<code>`; then on base in a **separate detached worktree** at `6c1709e` with head's AC test file copied in (plus the test files of any package the story creates that the test imports, and nothing else), saving `verifier/ac<n>-base-<base7>.log`; it must fail to build or fail there. One screenshot per AC in `verifier/`, taken by you: for AC1 a real capture of the Content library page's Starter packs section from a binary you build at `398af64` on a fresh database of your own (the memory note's recipe, `$MEM/leorna-control-plane-workflow.md`: dev mode, `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`, `/dev/login?next=<encoded page>`); for AC2, AC3, AC5 a rendered capture of your own log. Never copy, link or cite a file from the builder's, fixers' or reviewers' folders as your receipt: every receipt you cite must be inside `verifier/`. Inspect each image (tall ones in bands ≤ 1,300 px) and make sure no URL bar, domain, tenant ID, token or email shows.

Write **`verifier/ac.json`** in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (`head`, then `ac_status[]` with `ac`, `accepted`, `test`, `log`, `base_log`, `screenshot`, `evidence`; AC4 with `not_run`). Before handing back, self-check it as `ac-verification.md` says: `cp` (not `ln`) your `ac.json`, logs and images into a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base 6c1709e… --plan <evidence>/plan-approved.md <evidence>/verifier/ac.json <scratch>/ac.json`, read its last line, then delete the copy. Fix any format, path, head or pass-line slip it shows.

## Gates and the loop's validation (run them yourself)

- In a **detached copy** at `398af64` (`git -C <worktree> worktree add --detach ~/.cache/86bcm901r-verify1/head 398af64`; `make check` and `test-module-add.sh` write into their tree): `make check` with CI's tools bound by absolute path (`~/.local/leorna-toolchain`: Go 1.27.3, `GOLANGCI_LINT`, `GOVULNCHECK`; task-local PATH), `bash ./scripts/test-module-add.sh`, the Postgres skip check from a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web` (`leorna` step 4: only the four allowed skips; every story test ran), and the production image (`docker build --no-cache --file Containerfile --tag 86bcm901r-verify1 .`, both `go build` steps DONE not CACHED, then `docker run --rm --entrypoint /usr/local/bin/gitleaks 86bcm901r-verify1 version` prints `8.30.1`; remove the tag after). Save logs in `verifier/gates-398af64.txt` and read each exit code.
- `backend-data-migrations`' Required Validation Gates for migration 24 (edited in place by fixer 2; it is not on `main`): up/down/up on a fresh database, `TestMigrationRoundTrip`, the CHECKs and UNIQUE key, and that the down file leaves shared rows sane.
- Pre-flight: no `.github/`, `contracts/` or `packages/contracts/` path in `git diff --name-only 6c1709e...398af64`; every commit `Justin Issa <justin@leorna.com>`; no AI attribution lines (`^co-authored-by:|generated with|noreply@anthropic|🤖`, case-insensitive); no tracked `CLAUDE.md`.

## Confirm every finding is closed, and look for regressions the fixes caused

Reviewer 1 (on `aa57092`): F1 column-test gaps (fixed `c545b40`, later moved to the 32/33 bound), F2 actor check unpinned (fixed `3a7377a`), F3 "retry setup" advice (fixed `5a17408`), F4 held vs older binary (fixed `08d438d`, `StarterLoadResult.Older`), F5 rename ignored (fixed `b62de55`, a rename is released like an item change), F6 `main.go` wiring untested (declined, follow-up; the real binary is the proof), F7 Codex prompt warning unchecked in AC2 (fixed `9d0eb2b`).
Reviewer 2 (on `08dac8d`): R2-1 a role over ~40 characters passed every check but stopped startup with an unnamed raw error (fixed `0ebeee1` cap 32 in `StarterPack.Validate` and migration 24, `6bc934f` the load names `check <role> version <n>`), R2-2 catalog name unpinned (fixed `a9e5e0f`, new web test). Docs `08dac8d`, `398af64`.

The fixers' open rulings, for you to judge: F4's `Older` field logged at info; F5's rename-as-change; F3's "restart the control plane to retry" wording; R2-1's cap of 32; the version-check error without restart advice; migration 24 edited in place. For each finding, write one closing test or mutant of your own (overlay or a detached copy, never the story worktree) that would fail if the fix were reverted, and say whether it did. Then look for regressions: re-read the whole `6c1709e...398af64` diff with fresh eyes, not just the deltas.

The earlier roles' receipts (`INVENTORY.md`, `reviewer1/`, `fixer1/`, `reviewer2/`, `fixer2/` in the evidence folder) are claims to check, not proof.

## Database, scratch, siblings

- **Databases:** your own only, `leorna_86bcm901r_verify1_test`, `leorna_86bcm901r_verify1_base_test` and a demo one (e.g. `leorna_86bcm901r_verify1_demo_test`), in `leorna-test-pg`. The password never goes on a command line or into a log. Never another role's, a sibling's or `leorna-pg`. Drop all of yours at the end.
- **Scratch:** everything (detached copies, TMPDIR, GOTMPDIR, caches, binaries, Chrome profiles) in `~/.cache/86bcm901r-verify1/`, made fresh with `mkdir` (no `-p`). Nothing big on `/tmp` (a small shared RAM disk). At the end remove your detached worktrees with `git worktree remove`, stop any server you started by its verified PID, and `rm -r /home/justin/.cache/86bcm901r-verify1` by that literal path.
- Siblings: PR #98 (86bcm901j) is open. Never touch another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (VERIFIER role; skip its Step 1 full context load; read `$MEM/leorna-control-plane-workflow.md`, `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `backend-data-migrations` (the loop skill: run its Required Validation Gates), `mutation-testing-discipline`, `security-best-practices`, `multi-tenant-auth-management`.
4. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full before the AC work. Any loaded skill's "spawn a subagent" step is the main session's job, not yours.

## Rules

- You can't ask Justin anything.
- `verdict: clean` requires every AC except AC4 accepted on `398af64` with its test, head log, base log and screenshot in `verifier/`, the gates green, and no critical or major finding open. Otherwise `findings`, each with severity (critical / major / minor / nit), `introduced`, claim and evidence.
- If you find any other bug or problem outside this story's diff, list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{verdict: clean|findings, head, base, findings[{id, severity, introduced, claim, evidence}], closed[{id, closed, test_or_mutant, evidence}], rulings_judged[{ruling, verdict, why}], ac_status[{ac, accepted, test, screenshot, evidence, not_run}], ac_json, ac_check_self_test, gates[{gate, log, exit}], found_else[], skill_lessons[]}`. `verdict`, `head`, `findings`, `ac_status` and `ac_json` are required. Plain words.
