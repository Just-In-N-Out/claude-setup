
# FIXER 1 — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: the first fixer in the Full pipeline (`review-fix-cadence`: review 1 → **fixer 1** → review 2 of the corrected code → fixer 2 → verifier). You act on review 1's findings, then stop at `ready-for-next-review`. No hand-over, no push, no PR, no ClickUp post.

## Inputs
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, clean at the reviewed head **`0bc49417dcc7a1fc30a4936bfb85d22471c3b4b2`**. Base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (GitHub `main`, unchanged at dispatch).
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md` (read-only); working copy `~/.hermes/plans/leorna/86bcm901w-create-pack.md`.
- **Review 1's full receipts:** `~/.hermes/plans/leorna/evidence/86bcm901w/review1/` (`review1.json`, `probe-uppercase-packid.txt`, `probe_uppercase_test.go.txt`, `mutant-R9-all-unique-to-stale`, `mutant-R29-create-form-ticks-not-kept`, `mutations-review1-0bc4941.txt`). Read only; never edit them.
- **Builders' evidence:** `~/.hermes/plans/leorna/evidence/86bcm901w/` (`EVIDENCE.md`, `INVENTORY.md`). Add your own section to `INVENTORY.md`; never edit earlier sections.
- **ACs** (approved; none live): AC1 `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`, AC2 `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`, AC3 `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`, AC4 `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`. All four passed in review 1; keep them green.

## Review 1's findings (verdict `findings`; no P0/P1)
Review 1 accepted all five of the builder's rulings and deviations (port 55432, the `/admin/packs/seed` 4 KiB probe, M2/M6 as equivalents, the deviations, the `379ba8d` capture binary). Don't revisit those.

**R1-F1 · P2 · introduced** — an upper-case pack id hides a save from the pack's audit history.
- Saving from an edit URL whose pack id is upper case files the `pack.version.create` audit record under that upper-case text, so `/admin/audit?target=<packId>` (`ListAudit{Target}`) misses it. `after.packId`, the redirect and the edit links keep the upper case too.
- Cause: `validUUID` accepts A–F; `SavePackVersion` uses the raw `spec.PackID` as the audit target and as `BuiltVersion.PackID` (`internal/store/postgres/pack_builder.go:108,114`; `latestBuiltVersion` `:185`); the HTML handlers pass `r.PathValue("packId")` through unchanged (`internal/web/pack_builder.go:288,344-345,375,390`). The JSON API is not affected (the generated UUID parser makes it lower case).
- Evidence: `review1/probe-uppercase-packid.txt` — history for the canonical id shows only `[pack.create]`; one record is filed under the upper-case id.
- Reviewer's suggestion (verify it; pick the fix that fits the code): take the id from the database (`SELECT id::text, name FROM pack_lineages … FOR UPDATE`) and use it for the audit target and `PackID`; same in `GetPack`. Tests: a store subtest calling `SavePackVersion` with `strings.ToUpper(packID)` expecting the canonical target and `after.packId`; a web test saving through an upper-case edit URL expecting 2 history records for the canonical id.

**R1-F2 · P3 · introduced** — test gap: ticks after a refused form save.
- After a store-side refusal (409 name taken, 400 invalid) the create form re-renders with the ticks kept, but no test checks it: mutant R29 (drop `ticked` from that re-render, `internal/web/pack_builder.go:323`) survives every web test. The edit form's re-render after a refused save (`:383`) isn't checked either; pack-left-empty is tested only through JSON.
- Suggested test: in AC4 `name_already_used` (form), assert only C is ticked; add a form-path pack-left-empty case (untick every shown row) expecting a 400 alert and no row ticked.

**R1-F3 · P3 · introduced** — test gap: version-id collision.
- The store maps a duplicate version id (unique `pack_versions (tenant_id, version)`) to `pack.ErrVersionExists`, which triggers the service's one retry. Mutant R9 (map every unique violation to `ErrStaleParent`, `pack_builder.go:273`) survives all web, store and pack tests; a regression would answer 409 `PACK_CHANGED` instead of retrying.
- Suggested test: call `CreatePack` and `SavePackVersion` with a `Version` that already exists in the tenant (e.g. `backend-1`), expect `errors.Is(err, pack.ErrVersionExists)`, and check nothing was written.

## What to do
1. Load the skills (below). Check the worktree is clean at `0bc4941`.
2. For each finding, follow `receiving-code-review`: verify it yourself first (re-run the probe or mutant from `review1/`), then fix the valid ones **test first** (a failing test, then the change). Push back with evidence on anything you find invalid; don't fix what you can't reproduce.
3. Prove the new tests can fail: R1-F1's test fails on `0bc4941`; R1-F2's and R1-F3's tests kill review 1's mutants R29 and R9 (re-run them through `go test -overlay`, with the mutated copy named by its full repo path). Save the receipts.
4. One commit per finding, `feat(86bcm901w): …` (or `fix(86bcm901w): …` / `test(86bcm901w): …` if that matches the repo's history better). Then run every gate on the new head in a **detached copy at that head**: `make check`, `bash ./scripts/test-module-add.sh`, the `go test -json` Postgres stream, the four AC tests by name (`gates-<sha7>.txt`, `ac<n>-<sha7>.log`). If R1-F1's fix changes what an AC screenshot shows, retake that screenshot; otherwise say why the old one still holds.
5. Update `EVIDENCE.md` (new head, new receipts) and your `INVENTORY.md` section. Stop with `status: ready-for-next-review`.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `~/.cache/86bcm901w-fixer1/` on the real disk (`mkdir` without `-p`, so it fails if it exists) for `TMPDIR`, detached copies and caches; remove only that folder at the end. Not `/tmp` (a small shared tmpfs; `make check` there fails with "no space left on device").
- **Toolchain:** Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 in `~/.local/leorna-toolchain` (read-only); gitleaks 8.30.1 at `/usr/local/bin`; make and gcc from apt. Bind the linters through `GOLANGCI_LINT=`/`GOVULNCHECK=` as the `leorna` skill says; PATH per command only.
- **Postgres:** `leorna-test-pg` on `127.0.0.1:55432` (user `leorna`, password `ci-only-password`). Use `leorna_86bcm901w_test` (the builder's) for the worktree and your own `leorna_86bcm901w_fixer1_test` for detached-copy gates (drop it at the end). Never touch any sibling's database or the `leorna-pg` container on 5432. **Docker** commands run as `/mnt/c/Windows/System32/wsl.exe -e docker …` (strip NULs with `tr -d '\0'`).
- Chrome for Testing, if you retake a screenshot: `~/.cache/chrome-for-testing/chrome-linux64/chrome` with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` and `--disable-gpu --disable-software-rasterizer`; after a submit that redirects, `WaitVisible` the result page before polling. The builder's capture program is `evidence/86bcm901w/capture-main.go`.

## Skills
Load, in this order, and say so in your first steps: `leorna` (FINISHER role for the fix pass only; skip its Step 1 load and its hand-over step), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `git-commit-rules`, `mutation-testing-discipline`, `security-best-practices` (its Go reference), `multi-tenant-auth-management`. Any skill step that says "spawn a subagent" or "independent reviewer" is the main session's job.

## Rules
- Never push, open a PR, merge or post to ClickUp. Commits only on `feat/86bcm901w-create-pack`; let git use the repo's identity (`Justin Issa <justin@leorna.com>`): no `-c user.*`, no `--author`, no AI attribution lines. Never stage a `CLAUDE.md`. Nothing under `.github/`.
- Stay within the findings: no redesign, no new scope. If a fix needs a decision the plan doesn't make, make the smallest safe ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and your `INVENTORY.md` section, or stop with options if it isn't safe.
- Sibling stories 86bcm901a, 86bcm901b, 86bcm901j run in other sessions in this repo: never touch their worktrees, branches, databases or evidence. Never run `make fmt-fix`/`make workspace` from the main checkout.
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.

## Output (your final message)
`{name: "86bcm901w-create-pack", status: "ready-for-next-review" | "stopped", reviewed_head: "0bc4941…", new_head, commits[], dispositions[{finding, verdict: fixed|pushed-back, test, red_receipt, green_receipt, mutant_receipt}], gates[{name, exit, log}], ac_status[{ac, test, log, screenshot}], rulings[], stop_reason, found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
