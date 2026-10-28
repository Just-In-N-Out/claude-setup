# FIXER ("bring main in") — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FIXER, a fresh agent. On 2026-10-28, PR #95 (86bcm901b, prompts) merged into `main`. Our PR #97 now conflicts with main. Justin: "PR 95 has been merged. I want you to run the audits again." That approves bringing main into this branch so the verifier, auditor and AC check can run on the new head.

Your job:
- merge `origin/main` into the branch, resolve the conflicts with the tested recipe, and run the gates;
- add PR #97 to `stories.json`;
- stop at `ready-for-review` with the new head.

**Don't push.** Pushing needs Justin's "push". Never merge into main.

## Facts
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- **Accepted head:** `9c13e02c1e6b111d6b33bd415371ac53c025d81b`, which is also on GitHub as PR #97. Old base: `1ee7157`.
- **New `origin/main`:** `db3406eaa72dbf07dcb9c0ca2c828a4377db74e2`, freshly fetched and equal to GitHub. It is "Merge pull request #95", whose second parent is 901b's head `63afe55`.
  - The main checkout's `main` has been fast-forwarded to it.
  - At start, re-fetch over HTTPS through gh (`leorna` step 7.1) and confirm main is still `db3406e`. If it moved, stop and report.
- `git merge-tree --write-tree --name-only HEAD origin/main` conflicts in exactly these files:
  - `cmd/library-upstream/main.go`
  - `delivery/stories.json`
  - `internal/library/README.md`
  - `internal/library/curation.go`
  - `internal/library/curation/curation.json`
  - `internal/library/upstream/importer.go`
- **The tested recipe** for exactly `63afe55`, which is what merged:
  - `~/.hermes/plans/leorna/evidence/86bcm901a/hand-over/merge-notes.md`, the 901b section;
  - the resolved files: `~/.hermes/plans/leorna/evidence/86bcm901a/hand-over/merge-with-901b-63afe55.patch`;
  - the trial's gate log: `hand-over/trial-901b-63afe55-gates.txt`.
  It models 901b merging first, which is what happened.
- `$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a/`. Round 1's verifier and auditor folders were moved to `$EV/round1-9c13e02/`. Don't create `verifier/` or `auditor/`: the next roles do that.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FIXER role; do its Step 1 context load), `engineering-best-practices`, `git-commit-rules`, `test-driven-development` (if any resolution needs a test change).

## Tasks
1. **Merge main in.** In the worktree, after checking HEAD is `9c13e02` and the tree is clean, run `git merge --no-ff origin/main`. That's a merge, not a rebase: PR #97's existing commits stay as they are, so no force-push is ever needed.
2. **Resolve each conflict, following the recipe and keeping both stories' meaning:**
   - **`main.go` and `importer.go`:** keep this story's `--version` flag and 901b's `--requires`, each with its `ImportOptions` field.
   - **`curation.go`:** keep the `Agents`, `DemoAgents` and `Prompts` fields.
   - **`curation.json`:** merge by value with the recipe's script. All versions are canonical `json.dumps(indent=2, ensure_ascii=False) + "\n"`. Take main's `skills` (901b reworded 3 notes), then add this story's `agents`/`demoAgents` and 901b's `prompts`.
   - **README:** keep both stories' sections and both intro lines, and merge the import example.
   - **`delivery/stories.json`:** take main's file unchanged, append this story's entry last as text, and check every earlier entry is unchanged by value.
   - **`internal/library/library.json`:** this file may auto-merge silently because both set 0.6.0. 901b shipped 0.6.0, so this story's library version becomes **0.7.0**, as the recipe says. Check whether anything else names this story's library version (the README, `curation.json` notes, tests or the plan's items), and keep it consistent.
   - **`content.lock.json`:** must auto-merge to the union. Check that no line from main or from this branch was changed or dropped (count them).
   - **Optional nit, folded in:** `main.go:6`'s package comment is missing `[--version V]` on its import line. Add it while you resolve `main.go`.
   - **Leave out:** the follow-ups in the merge notes, adding the agents to `prompt/ship`/`prompt/webperf` `requires` and rewording 901b's "arrive with 86bcm901a" notes. They are Justin's call for a later story.
3. **Commit the merge** with a plain `git commit` (no `-c user.*`, no `--author`, no AI attribution line, never `CLAUDE.md`). Use a clear message in the branch's style, for example `merge(86bcm901a): bring main in after #95 (86bcm901b prompts)`.
4. **Add the PR number** to `delivery/stories.json` (`leorna` step 7.8): add `97` as this story's PR, in the same shape as the other entries' PR fields, edited as text. Check it with CI's command, `python3 -B -m unittest discover -s scripts -p 'test_story_shippable.py'`, and commit it as `docs(86bcm901a): record PR #97 in the delivery inventory` or similar.
5. **Gates on the new head**, the canonical set, run in a detached copy, never in the worktree:
   - `make check` with `LEORNA_TEST_DATABASE_URL`;
   - `bash ./scripts/test-module-add.sh`;
   - the Postgres tests, read per test from a `go test -json` stream over the whole DB packages (`./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`). Fail any skip whose reason names `LEORNA_TEST_DATABASE_URL`;
   - `make library-check`: the agents still show as skipped with their reason, and 901b's prompts pass;
   - this story's AC1–AC4 tests (AC4 with `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`), plus the `--version`, T8 upgrade and curation tests;
   - 901b's own AC tests: find their names in `~/.hermes/plans/leorna/86bcm901b-prompts-collection.md`, read-only.
   - Bind golangci-lint 2.14.0 and govulncheck v1.7.0 through the Make variables, and use a task-local toolchain PATH.
   - Log to `$EV/gates-<newhead7>/` and `$EV/gates-<newhead7>.txt`, with one `label EXIT=<rc>` line per step.
   - `TestSetupWizardWithPostgres` can time out under load. If it fails, run it alone and rerun it, and log both runs.
   - **A real failure:** fix it test-first if it comes from the merge. If it would change behaviour, an AC or a decision, stop and report instead.
6. At the end, the tree is clean (`git status --porcelain --ignored` empty) and `git merge-base HEAD origin/main` = `db3406e`.

## Boundaries
- **Never** push, open or edit a PR, post to ClickUp, or merge into main. Don't touch the main checkout (it's already at `db3406e`).
- **Other stories:** never touch their worktrees, branches, DBs or evidence (86bcm901b, 86bcm901j, 86bcm901w and any other). Reading refs is fine.
- **Postgres:**
  - Reuse `leorna-test-pg` and read its port with `docker port leorna-test-pg 5432`. Never touch `leorna-pg`.
  - Use only your own `leorna_86bcm901a_mainin_test` DB and drop it at the end.
  - Never print a URL or password.
- **Disk:** `/tmp` is a small shared tmpfs.
  - `TMPDIR`, the detached copy and caches go in `~/.cache/86bcm901a-mainin/` (`mkdir`, no `-p`).
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-mainin/` (`mkdir`, no `-p`).
  - Remove both at the end, and remove any `git worktree add` copy with `git worktree remove --force`.
- **Waiting:** a foreground Bash call is moved to the background after 180 s, so split long waits into polls under 170 s each (a bounded `node -e` loop re-reading the log). Ending your turn to wait counts as finishing.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status: `ready-for-review` or `stopped` and why.
- The new HEAD SHA, the commit list since `9c13e02`, the merge base (= `db3406e`), and `git diff --stat origin/main..HEAD`.
- Per conflicted file: how you resolved it and what you checked. The library version decision. The lock-line counts.
- Every gate with its exit code and log path. This story's and 901b's AC test results on the new head.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
