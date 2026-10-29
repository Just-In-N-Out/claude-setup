# FIXER brief (bring main in, with code changes): 86bcm901r-starter-packs [leorna]

**Role:** FIXER for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). One job: **merge GitHub's new `main` (`b985422`, PR #99 merged) into the story branch**, make the code changes that merge needs, fix one stale README line, and prove the merged head with the gates and all five AC checks. Justin approved this on 2026-10-29: "Yes, merge it in" (the plan's status lines record it). **Never push, open a PR, merge into `main`, or post to ClickUp**: the main session does the PR step after a review.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac.

## Where things stand

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`, local only. First confirm HEAD is `abc60dc74fc898c43cc9f010aed40e5cb6c29e54` and `git status --porcelain` is empty; if not, stop and report.
- `abc60dc` is **ALL ACCEPTED** (review-1 clean, verifier 2 and blind auditor 2 clean, `ac-check.sh`). Its merge base with GitHub `main` was `dd006b7`.
- **GitHub `main` now:** `b985422cd78a961b8c8e70a9e56fecc51d487858` (Merge pull request #99, 86bcm901y remove/reorder). Re-check with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` before you fetch; if it moved again (PR #100, 86bcm9023, is open and merges cleanly with this head per finisher 2), merge the newest and say so.
- **Finisher 2 already trialled this merge** (a prediction, not a gate): `~/.hermes/plans/leorna/evidence/86bcm901r/hand-over/trial-merge-main-b985422-abc60dc.txt` (what conflicts and why), `trial-merge-main-b985422-resolve.py.txt` (its resolution script) and `trial-merge-main-b985422-expected.patch.txt` (the expected result). Read them; use them as a guide, but resolve and check every hunk yourself.

## What the merge needs (from the trial; confirm each)

1. **Text conflicts:** `delivery/stories.json` (main's file unchanged, this story's entry appended last **as text**; every earlier entry unchanged by value), `internal/pack/README.md` (keep both sides' meaning), `internal/web/library.go` (code: keep both #99's and this story's behaviour; read both sides' intent and tests before resolving).
2. **Migration renumber:** #99 added `000024_pack_item_order`, so this story's pair `000024_starter_packs.{up,down}.sql` becomes **`000025_starter_packs`**. Update every reference to this story's migration number in code, tests, comments and docs on the branch (e.g. the pack README's migration, rollback and "checksum mismatch" lines, test names or messages that say 24, the plan-facing receipts don't count). Check `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` is empty and the versions run 1..25 with no gap.
3. **Compile fixes that merge as text:** #99's `insertVersionItems` takes a 5th argument `ordered bool`; this story's call (`internal/store/postgres/starter_packs.go:140` at `abc60dc`) must pass the right value (the trial used `false`: confirm from #99's code what `ordered` means and that starter versions should be unordered, i.e. keep the order semantics this story's tests expect). `mintDesktopToken` is declared in both `internal/web/pack_items_test.go` (#99) and this story's `internal/web/starter_packs_test.go`: rename **this story's** helper (or reuse #99's if it is identical in behaviour; say which).
4. **QA1 (Justin: "Fix it if a fixer runs"):** the branch's `internal/pack/README.md` line (≈300 at `abc60dc`) "Live: one desktop Sync of a starter pack into Claude Code, Codex and Cursor (owed to Justin)" is stale: AC4 is now an agent-run check (the plan's Amendment 1). Reword it truthfully (what the agent-run check proves; that the Windows window and a real sign-in aren't covered), in the README's style.
5. Grep the whole tracked tree for `86bcm901y` and for this story's card id next to until/once/later (the `leorna` bring-main-in rule) and fix stale wording only in files this merge touches; list the rest.

Commit the merge (plain `git merge` by SHA, then resolve; no rebase, no squash) with the conflict resolutions and the compile fixes **inside the merge commit** where they're needed for the merge to build, and the QA1 README rewording as its own small docs commit. Plain `git commit` (no author overrides; nothing named `CLAUDE.md` staged). Report authorship as a result ("author: Leorna identity OK"), **never print the address**.

## Prove it

Follow `leorna`'s bring-main-in checks (the "Integrate" step's merge-tree bullet and everything after it): every file changed on one side only equals that side's blob; review only the both-sides files; overlay mutants that drop each side's hunk in the both-sides files die; `gitleaks dir` on the both-sides files from the merged tree plus `gitleaks git` over `<main>..HEAD`; the branch's own commits checked with `git log HEAD ^6c1709e ^b985422` (authors, no AI attribution lines).

On the new head, in a **detached copy** for anything that writes into its tree:
- The project's **full gates**: `make check` with CI's tools bound by absolute path (`~/.local/leorna-toolchain`: Go 1.27.3, `GOLANGCI_LINT`, `GOVULNCHECK`; task-local PATH), `bash ./scripts/test-module-add.sh`, the Postgres skip check from a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web` (`leorna` step 4: only the four allowed skips; every story test and #99's tests ran), and `TestMigrationRoundTrip`.
- **Each AC check by its own name** on the new head (the approved plan's AC lines, `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md`): AC1, AC2, AC3, AC5 Go tests, and **AC4's agent-run check** (`bash ~/.hermes/plans/leorna/86bcm901r-ac4/run.sh …` exactly as the plan's "AC4's check" says, with its own work, out folder and database; read `run.sh` first and confirm the client can't write into the real `/home/justin`). AC4 must print `ok 1`.
- Save every log to `~/.hermes/plans/leorna/evidence/86bcm901r/main-in-99/` (create it fresh with `mkdir`, no `-p`; stop if it exists) as `<name>-<head7>.log`, first line `HEAD=<sha>`, last line `EXIT=<code>`. Open each log and read its exit code before citing it.
- `check-story-shippable.py 86bcm901r`: report its last line.

If a conflict can't be resolved without changing behaviour either story relies on, or any gate or AC fails for a reason you can't fix within this merge, stop with `status: stopped` and describe it.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FIXER role; skip its Step 1 full context load; read `$MEM/leorna-control-plane-workflow.md`, `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `backend-data-migrations` (the renumber; its Required Validation Gates for the renumbered migration on a fresh database).
4. `test-driven-development` (if a resolution changes behaviour, a failing test first) and `mutation-testing-discipline` (the both-sides mutants).
5. `git-commit-rules`.

## Database, scratch, siblings

- **Databases:** your own only, prefix `leorna_86bcm901r_mainin99_`, ending `_test` (incl. AC4's), in the `leorna-test-pg` container (port via `docker port leorna-test-pg 5432/tcp`; `psql` through `docker exec`). The password never goes on a command line or into a log. Never another database, never `leorna-pg`. Drop all of yours at the end.
- **Scratch:** `~/.cache/86bcm901r-mainin99/`, made fresh with `mkdir` (no `-p`): TMPDIR, GOTMPDIR, detached copies, AC4 work folders. Nothing big on `/tmp`. At the end `git worktree remove` what you added, stop any server by its verified PID, and `rm -r /home/justin/.cache/86bcm901r-mainin99` by that literal path.
- Never touch the main checkout, another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything.
- If you find any other bug or problem, list it in `found_else` (one line each, evidence, severity P0–P3); don't fix it.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{status: ready|stopped, stage, summary, head, previous_head: "abc60dc…", merged_main, commits[{sha, what}], conflicts[{path, resolution}], code_changes[{path, change, why}], merge_checks[], gates[{name, log, exit}], ac_checks[{ac, test, log, exit}], shippable_check, stale_wording[], found_else[], skill_lessons[]}`. `status`, `stage`, `summary` and `head` are required. Plain words.
