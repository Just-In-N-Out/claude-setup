
# FIXER 2 — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: the second fixer in the Full pipeline (`review-fix-cadence`: review 1 → fixer 1 → review 2 → **fixer 2** → verifier). You act on review 2's valid findings, then stop at `ready-for-verify`. No hand-over, no push, no PR, no ClickUp post.

## Inputs
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, clean at review 2's head **`e90cec887af041f0ce7fa1d9e98271ab8a9e9ea8`**. Base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md` (read-only).
- **Review 2's receipts:** `~/.hermes/plans/leorna/evidence/86bcm901w/review2/` (`review2.json`; `probes/zz_review2_probe_test.go.txt`, `probes/zz_review2_member_read_test.go.txt`, `probes/RESULTS-constraints.txt`, `probes/RESULTS-member-reads.txt`; `mutant-overlays/`; `mutations-review2-e90cec8.txt`). Read only; never edit them.
- **Evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm901w/` (`EVIDENCE.md`, `INVENTORY.md`; add your own section, never edit earlier ones). Fixer 1's receipts are in `fixer1/`; put yours in `fixer2/`.
- **ACs** (approved; none live): AC1 `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`, AC2 `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`, AC3 `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`, AC4 `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`. All four passed in review 2; keep them green.

## Review 2's result (verdict `findings`; no P0, P1 or P2)
Review 2 confirmed all three review-1 findings closed for the class (R1-F1 `a0173dc`, R1-F2 `0e2a391`, R1-F3 `e90cec8`), accepted fixer 1's two rulings (the `ToLower` fix; the edit-form tick mutant R29e) and the no-retake screenshot reasoning. Don't revisit those. Its three new findings, all `introduced: true`:

**R2-F1 · P3** — migration 23's database constraints have no test.
- Removing any one of these from `000023` (up and down) leaves every store, web and pack test green (mutants DB1–DB4 survived 73 passes each): `pack_versions_pack_fk` (the composite FK plan D6 names as the database-level tenant guard), `pack_versions_pack_tenant` (the CHECK that stops a built version becoming a tenant-less seed-base version every tenant can read), `pack_versions_pack_pair`, `pack_versions_pack_number_key`. Not a live defect: the app code stays tenant-keyed and is tested.
- Evidence: review 2's direct-SQL probe passes at head and fails exactly the matching subtest under each mutant (23503 `pack_versions_pack_fk`, 23514 `pack_versions_pack_tenant`, 23514 `pack_versions_pack_pair`, 23505 `pack_versions_pack_number_key`) — `review2/probes/RESULTS-constraints.txt`.
- Suggested test: adapt `review2/probes/zz_review2_probe_test.go.txt` as a subtest of `TestPackBuilderStoreWithPostgres` (self-contained fixtures, so it can run alone), asserting `pgErr.Code` and `ConstraintName`.

**R2-F2 · P3** — admin-only JSON reads have no test.
- The store's `GetPack` and `ListPacks` allow any user in the tenant, so the route's `requireAdmin` (`internal/web/handler.go:283-285`) is the only guard for `GET /v1/packs` and `GET /v1/packs/{packId}`. Plan assumption 4 says reads are admin-only; AC4's member case covers only the writes and the edit page.
- Evidence: mutant A1 drops `requireAdmin` from the two GET routes and survives every test; under it a member's `GET /v1/packs` returned 200 with the tenant's pack list. The probe passes at head with 403 — `review2/probes/RESULTS-member-reads.txt`, `member-head.log`, `member-A1.log`.
- Suggested test: add both member GETs to AC4's member case, expecting 403 `ADMIN_REQUIRED` (`review2/probes/zz_review2_member_read_test.go.txt`).

**R2-F3 · P3** — the web README's pack-builder paragraph is wrong for some refusals.
- It says a refused save keeps the ticks "400, or 409 for … a newer version". But the newer-version 409 re-renders the latest version's ticks (`internal/web/pack_builder.go:354`, `:378`), and so do "Nothing changed" and "The form no longer matches the library" (`:368`, `:372`). The code is right (the alert tells the admin to review the ticks). Fix the wording only.

## What to do
1. Load the skills (below). Check the worktree is clean at `e90cec8`.
2. For each finding, follow `receiving-code-review`: verify it first (re-run review 2's probe or mutant through `go test -overlay`), then fix the valid ones; push back with evidence on anything invalid. R2-F1 and R2-F2 are test-only: prove each new test kills review 2's mutants (DB1–DB4; A1) on the same mutated bytes and fails the old oracle's survival (the old tests let them survive). R2-F3 is wording only: match the code's real behaviour per refusal.
3. One commit per finding (`test(86bcm901w): …` / `docs(86bcm901w): …`, matching the branch's history). Then run every gate on the new head in a **detached copy at that head**: `make check`, `bash ./scripts/test-module-add.sh`, the `go test -json` Postgres stream read per test, the four AC tests by name (`gates-<sha7>.txt`, `ac<n>-<sha7>.log`). Re-run the earlier rounds' mutant lists only if production code changed (it shouldn't). Screenshots: say whether any still holds (no production change expected) or retake it.
4. Update `EVIDENCE.md` (new head, new receipts, a "Fix pass 2" table) and your `INVENTORY.md` section. Stop with `status: ready-for-verify`.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `~/.cache/86bcm901w-fixer2/` on the real disk (`mkdir` without `-p`) for `TMPDIR`, detached copies and caches; remove only that folder at the end. Not `/tmp` (a small shared tmpfs; `make check` there fails with "no space left on device"; a WSL restart also wipes it).
- **Toolchain:** Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 in `~/.local/leorna-toolchain` (read-only); gitleaks 8.30.1 at `/usr/local/bin`; make and gcc from apt. Bind the linters through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says; PATH per command only.
- **Postgres:** `leorna-test-pg` on `127.0.0.1:55432` (user `leorna`, password `ci-only-password`). Use `leorna_86bcm901w_test` for the worktree and your own `leorna_86bcm901w_fixer2_test` for detached-copy gates (drop it at the end). Never touch any sibling's database or the `leorna-pg` container on 5432. Plain `docker …` works in this session. If Docker stops answering (a WSL restart), stop and report; don't restart Docker Desktop yourself.
- **Mutations:** `go test -overlay`, each mutated copy named by its full repo path; overlays reach the `//go:embed` SQL migrations, and a migration mutant must change the down file too. A subtest run alone skips its siblings' shared state, so new subtests build their own fixtures.

## Skills
Load, in this order, and say so in your first steps: `leorna` (FINISHER role for the fix pass only; skip its Step 1 load and its hand-over step), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `git-commit-rules`, `mutation-testing-discipline`, `multi-tenant-auth-management`, `backend-data-migrations`. Any skill step that says "spawn a subagent" or "independent reviewer" is the main session's job.

## Rules
- Never push, open a PR, merge or post to ClickUp. Commits only on `feat/86bcm901w-create-pack`; let git use the repo's identity (`Justin Issa <justin@leorna.com>`): no `-c user.*`, no `--author`, no AI attribution lines. Never stage a `CLAUDE.md`. Nothing under `.github/`.
- Stay within the findings: no production behaviour change, no redesign, no new scope. If a fix seems to need a production change, stop and report the options instead.
- Sibling stories 86bcm901a, 86bcm901b, 86bcm901j run in other sessions in this repo: never touch their worktrees, branches, databases or evidence. Never run `make fmt-fix`/`make workspace` from the main checkout.
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.

## Output (your final message)
`{name: "86bcm901w-create-pack", status: "ready-for-verify" | "stopped", reviewed_head: "e90cec8…", new_head, commits[], dispositions[{finding, verdict: fixed|pushed-back, test, old_oracle_receipt, new_oracle_receipt}], gates[{name, exit, log}], ac_status[{ac, test, log, screenshot}], rulings[], stop_reason, found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
