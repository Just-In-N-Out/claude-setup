# FIXER brief (bring main in, with code changes): 86bcm901r-starter-packs [leorna]

**Role:** FIXER for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). One job: **merge GitHub's new `main` (`e2254e0`, PRs #100 and #101 merged) into the story branch**, make the changes that merge needs to build and keep both stories' behaviour, and prove the merged head with the full gates and all five AC checks. Justin asked for this on 2026-10-29: "update the main branch then rerun AC and verification and everything". A fresh review, verifier and blind auditor follow you, so leave a clean, explained history. **Never push, open a PR, merge into `main`, or post to ClickUp.**

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac.

## Where things stand

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`, local only. First confirm HEAD is `805b6cd04ec95124ebc3ee319bc12774f9ef5f64` and `git status --porcelain` is empty; if not, stop and report.
- **History:** `abc60dc` was ALL ACCEPTED (merge base `dd006b7`). Fixer 4 then merged `b985422` (#99, 86bcm901y) in merge `034156e` (this story's migration renumbered to `000025_starter_packs`, `insertVersionItems(…, false)`, this story's test helper renamed `mintStarterDesktopToken`) and committed docs `805b6cd` (the QA1 README line). On `805b6cd` only gofmt, build, vet and the migration check ran (Justin paused verification); its receipts are in `~/.hermes/plans/leorna/evidence/86bcm901r/main-in-99/`. `034156e` and `805b6cd` are **not reviewed yet**: the next reviewer covers them with your merge.
- **GitHub `main` now:** `e2254e0100a482b9201edf9b96f01936e4486d44` (Merge pull request #101, 86bcm902a quick start), on top of #100 (86bcm9023 item editor live preview). The main checkout's local `main` and `origin/main` are already at `e2254e0` (the main session fetched and fast-forwarded it). Re-check with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`; if it moved again, merge the newest and say so. No sibling PR is open.
- A read-only `git merge-tree` by the main session: one text conflict, `delivery/stories.json`; auto-merged `cmd/control-plane/main.go`, `internal/pack/README.md`, `internal/web/handler.go`. Text-clean is not semantically clean: check every both-sides file.

## What the merge needs (confirm each)

1. **Text conflict** `delivery/stories.json`: main's file unchanged, this story's entry appended last **as text**; every earlier entry unchanged by value.
2. **Migration renumber:** #101 added `000025_quick_starts`, so this story's pair `000025_starter_packs.{up,down}.sql` becomes **`000026_starter_packs`**. Update every reference to this story's migration number in code, tests, comments and docs on the branch (fixer 4 changed 24→25 in places; find them all). Check `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` is empty and the versions run 1..26 with no gap. Run `backend-data-migrations`' gates for 26 on a fresh database (up, down, up; `TestMigrationRoundTrip`).
3. **Compile and test breaks that merge as text:** build, vet and test everything; fix any break inside the merge commit (e.g. a changed signature from #100's `internal/pack/version_service.go`, `pack_versions.go`, `packs.go`, `handler.go` routes, or #101's `cmd/control-plane/main.go` wiring and `internal/store/postgres/store_test.go`). Keep both sides' behaviour; read both sides' intent and tests before resolving.
4. **#101's stand-in starter list (the important one).** #101 (86bcm902a) ships `internal/onboarding/starters.go`: a stand-in list of this story's four proposed role packs; its quick start creates a company pack (e.g. "Backend starter pack", version 1) from the newest library items through 901w's `CreatePack` when an admin picks one, then makes it the team's default. Its plan (`~/.hermes/plans/leorna/86bcm902a-quick-start.md`, read the Flag line, Q1 and D2) says "When 901r lands, it replaces that one list". **Do not replace it in this merge**: replacing it changes #101's shipped behaviour and is Justin's call (asked separately). Your merge keeps both working as they are. Then **find out, with evidence, how the two meet on one database**, and report each as a fact:
   - Does 901r's startup load (`ensureStarterPacks`, shared versions `starter-<role>-<n>`) and #101's quick start both work on one fresh database? Prove it with a run, not by reading: e.g. #101's end-to-end test `TestQuickStartAC5FreshInstallEndToEndWithPostgres` and its other `TestQuickStart*` tests pass on the merged head (they run in the gates), **and** one scratch run (not committed, in your detached copy or an overlay) where the starter packs are loaded first and then the quick start picks each of the four starters. Does any name, id, unique constraint or slug collide (a shared "Backend starter pack" next to a company "Backend starter pack")? What does an admin see in the catalog, the pack assignments page and the quick start after both?
   - Do the two lists (this story's embedded starter definitions and `internal/onboarding/starters.go`) name the same items per role? List each difference.
   - Does #101's setup "ready" logic or any README sentence now say something false with both merged (e.g. "no role starter pack exists", "901r is still to do", "until 901r")?
   If both work together, keep the merge and report the overlap. If they **break** each other on a real path (an error, a failed test, a constraint violation), fix it only if the fix keeps both stories' behaviour and needs no product decision; otherwise stop with `status: stopped` and describe it with the evidence.
5. **Stale wording:** grep the whole tracked tree for `86bcm902a`, `86bcm9023`, `901r` and this story's card id next to until/once/later/stand-in/"to do" (the `leorna` bring-main-in rule). Fix, in its own small docs commit, only wording this merge makes **false**, in the README's style; list the rest (including the stand-in wording that stays true until Justin decides).

Commit the merge (plain `git merge` by SHA, then resolve; no rebase, no squash) with the conflict resolution and the fixes it needs to build **inside the merge commit**, and any docs rewording as its own commit. Plain `git commit` (no author overrides; nothing named `CLAUDE.md` staged). Report authorship as a result ("author: Leorna identity OK"), **never print the address**.

## Prove it

Follow `leorna`'s bring-main-in checks (the "Integrate" step's merge-tree bullet and everything after it): every file changed on one side only equals that side's blob; review only the both-sides files; overlay mutants that drop each side's hunk in the both-sides files die; `gitleaks dir` on the both-sides files from the merged tree plus `gitleaks git` over `e2254e0..HEAD`; the branch's own commits checked with `git log HEAD ^6c1709e ^e2254e0` (authors, no AI attribution lines).

On the new head, in a **detached copy** for anything that writes into its tree:
- The project's **full gates**: `make check` with CI's tools bound by absolute path (`~/.local/leorna-toolchain`: Go 1.27.3, `GOLANGCI_LINT`, `GOVULNCHECK`; task-local PATH), `bash ./scripts/test-module-add.sh`, the Postgres skip check from a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/onboarding` (`leorna` step 4: only the allowed skips; every story test, #99's, #100's and #101's tests ran), and `TestMigrationRoundTrip`.
- **Each AC check by its own name** on the new head (the approved plan's AC lines, `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md`): AC1, AC2, AC3, AC5 Go tests, and **AC4's agent-run check** (`bash ~/.hermes/plans/leorna/86bcm901r-ac4/run.sh …` exactly as the plan's "AC4's check" says, with its own work, out folder and database; read `run.sh` first and confirm the client can't write into the real `/home/justin`). AC4 must print `ok 1`. If its expected file counts (26/21/26) no longer hold because main changed the library, stop and report it; don't edit `run.sh`.
- Save every log to `~/.hermes/plans/leorna/evidence/86bcm901r/main-in-101/` (create it fresh with `mkdir`, no `-p`; stop if it exists) as `<name>-<head7>.log`, first line `HEAD=<sha>`, last line `EXIT=<code>`. Open each log and read its exit code before citing it.
- `check-story-shippable.py 86bcm901r`: report its last line.

If a conflict can't be resolved without changing behaviour either story relies on, or any gate or AC fails for a reason you can't fix within this merge, stop with `status: stopped` and describe it.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FIXER role; skip its Step 1 full context load; read `$MEM/leorna-control-plane-workflow.md`, `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `backend-data-migrations` (the renumber; its Required Validation Gates for the renumbered migration on a fresh database).
4. `test-driven-development` (if a resolution changes behaviour, a failing test first) and `mutation-testing-discipline` (the both-sides mutants).
5. `git-commit-rules`.

## Database, scratch, siblings

- **Databases:** your own only, prefix `leorna_86bcm901r_mainin101_`, ending `_test` (incl. AC4's), in the `leorna-test-pg` container (port via `docker port leorna-test-pg 5432/tcp`; `psql` through `docker exec`). The password never goes on a command line or into a log. Never another database, never `leorna-pg`. Drop all of yours at the end.
- **Scratch:** `~/.cache/86bcm901r-mainin101/`, made fresh with `mkdir` (no `-p`): TMPDIR, GOTMPDIR, detached copies, AC4 work folders. Nothing big on `/tmp`. At the end `git worktree remove` what you added, stop any server by its verified PID, and `rm -r /home/justin/.cache/86bcm901r-mainin101` by that literal path.
- Never touch the main checkout (its `main` is already updated), another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything.
- If you find any other bug or problem, list it in `found_else` (one line each, evidence, severity P0–P3); don't fix it.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{status: ready|stopped, stage, summary, head, previous_head: "805b6cd…", merged_main, commits[{sha, what}], conflicts[{path, resolution}], code_changes[{path, change, why}], quick_start_overlap{both_work, evidence, collisions[], list_differences[], admin_sees}, merge_checks[], gates[{name, log, exit}], ac_checks[{ac, test, log, exit}], shippable_check, stale_wording[], found_else[], skill_lessons[]}`. `status`, `stage`, `summary` and `head` are required. Plain words.
