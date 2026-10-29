# FIXER brief (bring main in): 86bcm901r-starter-packs [leorna]

**Role:** FIXER for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). One job: **merge GitHub's new `main` into the story branch**, resolve the record-file conflicts, and prove the merged head with the gates and every automated AC test. Justin approved this bring-in on 2026-10-29 (his pick: "Every option first merges the newer main (PR #98 merged today) into the branch"). **Never push, open a PR, merge into `main`, or post to ClickUp.**

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac.

## Where things stand

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`, local only. First confirm HEAD is `398af64906adc26726f79cae81ce4d00355b7092` and `git status --porcelain` is empty; if not, stop and report.
- **Story base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. **GitHub `main` now:** `dd006b79f9908976e853c57489032bd5d9d471df` (PR #98, 86bcm901j MCP templates, merged 2026-10-29). Re-check it with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` before you fetch; if it moved again, merge the newest and say so.
- `398af64` passed two reviews, a verifier, a blind auditor and `ac-check.sh` (READY FOR THE USER, AC4 owed). The finisher's trial merge with #98's head predicted conflicts only in `delivery/stories.json` and `internal/library/README.md`: `~/.hermes/plans/leorna/evidence/86bcm901r/hand-over/integration.md` and `trial-merge-98-398af64.txt` (read them; #98's final head may differ from the one trialled, so check its tree first as the `leorna` skill says).
- In parallel, a planner is rewriting AC4 in the plan (it becomes an agent-run check). Don't edit the plan or AC4's files.

## What to do

1. Load the skills below. Read `leorna`'s bring-main-in rules (the "Integrate" step: the `git merge-tree` line and everything after it in that bullet, plus 7.1's read-only HTTPS fetch through `gh`) and follow them exactly.
2. Fetch `main` read-only over HTTPS through `gh` (the `leorna` command; never change a remote, credential helper or `gh` account). Check the fetched SHA equals GitHub `main`.
3. `git merge` it into the branch (a merge commit, no rebase, no squash). Resolve:
   - `delivery/stories.json`: take main's file unchanged and append this story's entry last **as text**, then check every earlier entry is unchanged by value.
   - `internal/library/README.md`: keep both sides' meaning.
   - Any other conflict, or a both-sides file that is code: stop with `status: stopped` and describe it. Don't resolve code conflicts.
4. Prove the merge (the `leorna` checks): every file changed on one side only equals that side's blob (deletions with `git ls-tree`); review only the both-sides files; the duplicate-migration check (`ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` must be empty); `gitleaks dir` on the both-sides files from the merged tree as well as `gitleaks git` over `<main>..HEAD`; grep the branch for #98's card id `86bcm901j` and stale "until/once … merges" wording this story wrote, and fix stale wording in the branch only if it's in a record file this merge touches (otherwise list it).
5. Commit the merge with plain `git commit` (no author overrides; nothing named `CLAUDE.md` staged). Check `git log -1 --pretty=format:'%an <%ae>'` matches the Leorna identity, and **report it as a result ("author: Leorna identity OK"), never print the address**.
6. On the merged head, run **the project's full gates** (the ones the plan's "Notes for later roles" and the verifier ran: build, vet, gofmt, `make check` or its equivalent, the whole test suite with Postgres, govulncheck, gitleaks) and **each automated AC test by its own name**: AC1, AC2, AC3 and AC5 from the approved plan (`~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md`, AC lines). Save each to `~/.hermes/plans/leorna/evidence/86bcm901r/main-in/` (create fresh with `mkdir`, no `-p`; stop if it exists) as `<name>-<head7>.log`, first line `HEAD=<sha>`, last line `EXIT=<code>`. Open each log and read its exit code before citing it.
7. Run `check-story-shippable.py 86bcm901r` (find it under `~/Leorna/leorna-control-plane/scripts/` or as `leorna` names it) and report its last line.
8. List hand-over text that this merge made stale (the PR body's integration and Test Plan lines, `hand-over/integration.md`, `followups.md`), with the exact lines. Don't edit the hand-over files: a finisher refreshes them later.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FIXER role; skip its Step 1 full context load).
2. `engineering-best-practices`.
3. `git-commit-rules`.
4. `backend-data-migrations` (only to judge the migration-number check).

## Database, scratch, siblings

- **Databases:** your own only, `leorna_86bcm901r_mainin_test` (plus others with that prefix if a gate needs them), in the `leorna-test-pg` container (port via `docker port leorna-test-pg 5432/tcp`; `psql` through `docker exec`). The password never goes on a command line or into a log. Never another database, never `leorna-pg`. Drop all of yours at the end.
- **Tools:** Go toolchain in `~/.local/leorna-toolchain` (not on the default PATH: use a task-local PATH).
- **Scratch:** `~/.cache/86bcm901r-mainin/`, made fresh with `mkdir` (no `-p`); TMPDIR, GOTMPDIR and any trial worktrees there. Nothing big on `/tmp`. Remove it at the end by its literal path, and any worktree you added with `git worktree remove`.
- Never touch the main checkout, another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything.
- If you find any other bug or problem, list it in `found_else` (one line each, evidence, severity); don't fix it.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{status: ready|stopped, stage, summary, head, previous_head: "398af64…", merged_main, conflicts[{path, resolution}], merge_checks[], gates[{name, log, exit}], ac_tests[{ac, test, log, exit}], shippable_check, stale_handover[], found_else[], skill_lessons[]}`. `status`, `stage`, `summary` and `head` are required. Plain words.
