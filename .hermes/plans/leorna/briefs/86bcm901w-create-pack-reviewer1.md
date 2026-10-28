
# REVIEWER 1 (review only) — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: the first fresh full REVIEWER in the Full pipeline (`review-fix-cadence`: review 1 → fixer → review 2 of the corrected code → fixer → verifier). You have never seen this code or its build. **Report only:** change nothing in the worktree, commit nothing, push nothing, post nothing; restore anything you touch.

## What to review
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, head **`0bc49417dcc7a1fc30a4936bfb85d22471c3b4b2`** (clean). Base **`1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`** (= GitHub `main` at dispatch, checked 2026-10-28). Review `git diff 1ee7157...0bc4941` (24 files, +6543/−1420) against the plan and the `leorna` skill's rules.
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md` (read-only copy). The working plan `~/.hermes/plans/leorna/86bcm901w-create-pack.md` has the same content plus a "Builder 1 result" note under "Justin's answers".
- **Acceptance criteria** (approved with Justin's go; none is live):
  - AC1: Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items — `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`
  - AC2: Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set — `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`
  - AC3: Given a save, then a change-audit record is written (actor, action, diff) — `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`
  - AC4 (proposed, approved): refused saves (bad input, duplicate name, nothing changed, emptied pack, outdated version, member, bad CSRF, another company's pack) are refused with a clear status and write nothing — `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`
- **Builder's evidence and claims** (verify, don't trust): `~/.hermes/plans/leorna/evidence/86bcm901w/EVIDENCE.md` and `INVENTORY.md` (both builders' sections). Read them, but re-run what matters yourself.

## The builder's rulings and deviations to judge (each: accept, or a finding)
1. `leorna-test-pg` publishes on `127.0.0.1:55432`, because 5432 is held by Justin's own `leorna-pg` (postgres:16, created 2026-10-25, not a story's).
2. `TestAdminFormLimitKeepsFourKiBForOtherForms` probes `POST /admin/packs/seed`, not the plan's `/admin/teams`, because `teamForm` has its own 4 KiB reader and never calls `adminForm`.
3. Mutants M2 (lineage lock not tenant-keyed at one site) and M6 (audit error ignored) survive as documented equivalents; M2-all and M6b were added and killed instead. 13 of 15 killed (`mutations-bede133.txt`; `mutations-7bde221.txt` is a superseded run).
4. Deviations: its own `waitForPackLineageLock` helper; `packBuilderResult` name; `insertVersionItems` refactor keeps `CreateVersion`'s errors; stale form save re-reads the pack and shows the latest version; extra tests (5 KiB edit form, 65 KiB form refused, `TestTicksToChange` cases); screenshots tick shipped library items because the plan's example items don't exist; `GLOSSARY.md` skipped (doesn't exist at base; follow-up F7).
5. The console screenshots came from a binary built at `379ba8d`; it says only a test file differs at `0bc4941`. Check that claim.

## Focus areas (the reasons Justin kept this story on Full)
- **Immutability:** saved versions and their items can never change (code and the migration 23 triggers); a save always makes a new row with ParentVersion set; concurrent saves from the same parent (the row lock, 409 on a stale parent).
- **Audit:** every save writes exactly one record (actor, action, diff) in the same transaction; a failed audit write saves nothing.
- **Auth and tenancy:** admin only, CSRF, body limits, no cross-tenant read or write by id (packs, versions, library items, audit rows).
- **Migration 23:** up/down correctness, existing rows and forks untouched, trigger behaviour, `TestMigrationRoundTrip` and the reset lists, numbering risk if a sibling also adds `000023`.
- **OpenAPI:** additive only, generated code in sync (`make contracts-check`), the contract-kind tests, `roundTripServer` and `Handler` implement every operation; whether the client must regenerate (the plan says no).
- **Console:** checkbox/form behaviour, escaping, error alerts, the edit view; no regressions on the library page from 86bcm901v.
- **Scope:** nothing for 86bcm901y (ordering, client-side removal at sync) or 86bcm901b's dependency flag built here; `delivery/stories.json` earlier entries unchanged by value; no `.github/` changes; commit authors all `Justin Issa <justin@leorna.com>` with no AI attribution lines.

## How to run things (this desktop is WSL Ubuntu)
- Run the gates yourself, try your own mutations, don't trust summaries. Work in a **detached copy at `0bc4941`** (`git -C <worktree> worktree add --detach <your scratch>/head 0bc4941`), never in the story worktree, and remove the copy at the end. Use `go test -overlay` for mutations so no file changes on disk.
- **Scratch:** a fresh `~/.cache/86bcm901w-reviewer1/` on the real disk (`mkdir` without `-p`, so it fails if it exists) for everything: `TMPDIR`, detached copies, caches, notes. Remove only that folder at the end. Not the Claude scratchpad: `/tmp` here is a small tmpfs shared by every session and `make check` with `TMPDIR` there fails with "no space left on device".
- **Toolchain:** Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 in `~/.local/leorna-toolchain` (read-only; never reinstall or change); gitleaks 8.30.1 at `/usr/local/bin`; make 4.4.1 and gcc 15.2 from apt. Bind the linters through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says, and set PATH per command only.
- **Postgres:** reuse the running `leorna-test-pg` on `127.0.0.1:55432` (user `leorna`, password `ci-only-password`). Create and later drop your own database `leorna_86bcm901w_review1_test` (the name must end in `_test`). Never touch `leorna_86bcm901w_test`, `leorna_86bcm901w_base_test`, any sibling's database, or the `leorna-pg` container. **Docker commands** must run as `/mnt/c/Windows/System32/wsl.exe -e docker …` (this process lacks the `docker` group; strip NULs with `tr -d '\0'`); `make check` itself never calls Docker.
- Confirm Postgres tests ran from a `go test -json` stream, as the `leorna` skill says (the two ClickHouse subtests of `TestTeamsAPIWithPostgres` rightly skip).
- Chrome for Testing, if you capture anything: `~/.cache/chrome-for-testing/chrome-linux64/chrome` with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` and `--disable-gpu --disable-software-rasterizer`.
- Sibling stories 86bcm901a, 86bcm901b, 86bcm901j run in other sessions in this repo: never touch their worktrees, branches, databases or evidence folders. Never run `make fmt-fix`/`make workspace` from the main checkout (those scripts walk `.claude/worktrees/`).
- Write your report files only in `~/.hermes/plans/leorna/evidence/86bcm901w/review1/` (create it). Never write in `verifier/` or `auditor/`, and never edit the builder's files.

## Skills
Load, in this order, and say so in your first steps: `leorna` (REVIEWER role; skip its Step 1 load), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline`, `security-best-practices` (its Go reference), `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. You **are** the fresh independent reviewer: skip `requesting-code-review`'s "spawn an independent reviewer subagent" and auto-fix steps. The last two skills end with a Mandatory Validation and Agent Defect Loop: you are its independent problem-finder; the main session runs the fixer and verifier.

## Rules
- Severity per finding: P0 (data loss, security, broken AC), P1 (wrong behaviour), P2 (should fix before merge), P3 (minor). Say for each whether this story introduced it (`introduced: true|false`). Pre-existing problems go in `found_else`, not `findings`.
- `ac_status` per AC: `accepted` true only if you ran its named test on `0bc4941` and saw its own pass line with no fail or skip, and the test really checks the AC's words. Give the evidence (your log path).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", reviewed_head: "0bc4941…", findings[{id, severity, introduced, claim, evidence, suggested_test}], rulings_judged[{ruling, verdict, why}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], found_else[], defect_loop_skills[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
