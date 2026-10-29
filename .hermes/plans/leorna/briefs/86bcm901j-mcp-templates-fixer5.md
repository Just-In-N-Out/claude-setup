# FIXER 5 brief (bring main in after #96): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**, after hand-over. Model: Opus 5.5, xhigh.

## Where the story stands

- **Branch:** `feat/86bcm901j-mcp-templates` in worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`.
  - GitHub still has it at `66449af`.
  - The local head is **`5a74e96`**, made by fixer 4, which merged main `a8d1465` (#95, #94, #97) and added ruling 13 plus the README B change. It isn't pushed yet, and there's no PR.
  - Fixer 4's full report is in `~/.hermes/plans/leorna/evidence/86bcm901j/INVENTORY.md` ("Fixer 4") and `…/86bcm901j/fixer4/`.
- **GitHub main has moved** to `6c1709e`: PR #96 (86bcm901w, create a pack) merged. It is the last sibling. `git merge-tree` shows only one conflict, `delivery/stories.json`.
- **Justin, 2026-10-29:** "update our main again, … build our PR on top of main, and then put a PR", then "After you put out the PR, run verifications".
  - After you return, the main session pushes and opens the PR.
  - Then a fresh verifier, a blind auditor and `ac-check.sh` run on the final head.
  - You don't run those.

## Your role

You are a fresh **FIXER** with three jobs:
1. Bring GitHub main into the branch with a merge commit.
2. Run the gates and the five AC tests on the final head.
3. Refresh the hand-over texts.

Stop with `status: ready-for-pr`. **Never push, open a PR, merge or write to ClickUp.** Don't rebase, force anything or rewrite existing commits: new commits go on top.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna`. Skip its Step 1 full context load. Read Doing a story → step 7.2 closely: the merge recipe, checking a finished merge, `gitleaks dir` for both-sides files, and the `stories.json` append.
2. `engineering-best-practices`
3. `test-driven-development`
4. `security-best-practices`: required for every role on this story.
5. `mutation-testing-discipline`
6. `git-commit-rules`
7. `systematic-debugging` whenever something fails unexpectedly.

## Tasks, in order

1. **Fetch main fresh** over HTTPS through gh (`leorna` 7.1) and record `git rev-parse origin/main`. Expect `6c1709e`. If it has moved past that, merge the newest main and say which PRs it added. Recheck it before your final gates; if it moved again, don't merge a second time: report it.
2. **Merge main in** with `git merge origin/main`. For `delivery/stories.json`, take main's file unchanged and append this story's entry last, as text. Then check by value that every earlier entry is unchanged and that this story's entry is unchanged from `5a74e96`.
   - Any other conflict: keep both sides' meaning. If it's a real code conflict, resolve it test-first and flag it in `merge_notes`.
   - Finish with `git commit -m "Merge branch 'main' into feat/86bcm901j-mcp-templates"`. Don't use `--no-edit`, and don't add an AI line.
   - **Check the finished merge** as `leorna` 7.2 says:
     - Every file changed on only one side must equal that side's blob; check deletions with `git ls-tree`.
     - Review the both-sides files, with an overlay mutant that drops each side's hunk.
     - `gitleaks dir` the both-sides files from the merged tree.
     - Grep the branch's own lines for stale "until/once … merges" wording and the sibling card ID `86bcm901w` (and `#96`), and fix any that are now stale.
3. **#96's content against this story's policy.** #96 added pack-builder code and maybe items with no text conflict, and this story's policy stage (rules S, P, V, L) may refuse some of them.
   - Run `make library-check` and the library, gate, pack, item-builder and web tests on the merged tree.
   - If something fails, find the root cause.
   - If the fix belongs inside this story and is safe, make it test-first and record it as "My ruling, not yet confirmed".
   - If it needs another story's code changed or would weaken a policy rule, stop with `status: stopped` and the options.
4. **Gates on your final head**, exactly as fixer 4 ran them (`briefs/86bcm901j-mcp-templates-fixer4.md` task 6 and its receipts in `fixer4/`):
   - `make check`, with CI-pinned tools bound by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
   - `bash ./scripts/test-module-add.sh`
   - gitleaks over the branch range, plus the `gitleaks dir` from task 2.
   - `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`
   - `make library-check`
   - Each AC test by name, AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`.
   - Branch hygiene: authors, no AI lines, no `.github/` paths in `git diff --name-only origin/main...HEAD`, no `CLAUDE.md`, fast-forward from `66449af`.
   - Save `gates-<sha7>-*.txt` and `ac<n>-<sha7>.log` with `HEAD=` and `EXIT=` lines, plus five AC screenshots and a gate-summary screenshot on the final head. Open each one: no token, server address or email.
5. **Refresh the hand-over** in `…/86bcm901j/handover/` for your final head:
   - **`pr-text.md` and its copy `~/.hermes/cache/scratch/leorna-pr-86bcm901j-mcp-templates.md`:**
     - Body only, no `Title:` line.
     - Main brought in through #96.
     - Test Plan only what ran on the final head, keeping the record that `ac-check.sh` accepted `66449af`.
     - Reword any follow-up or note that says #96 is still open.
     - Hosted CI and the new verification stay NOT VERIFIED; the main session updates them after.
   - **`clickup-evidence.md` and `review-prompt.md`:** update for the new head.
   - **`INVENTORY.md`:** add a "Fixer 5" section.
   - Don't add a PR number to `stories.json`.

## Environment

Same as fixer 4: read "Environment" in `briefs/86bcm901j-mcp-templates-fixer4.md`. These parts are different for you:
- **Cache folder:** `~/.cache/86bcm901j-fixer5/`.
- **Database:** `leorna_86bcm901j_fix5_test`.
- **Receipts:** `…/86bcm901j/fixer5/`.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer5/`.

Everything else is unchanged:
- Never touch other stories' worktrees, branches, databases, evidence or caches.
- Never switch the main checkout's branch.
- Never run real Codex or Claude Code against Justin's real `~/.codex` or `~/.claude`.
- Never print a token.
- Remove your cache and scratch folders and drop your database at the end.

## Rules

- **Other bugs:** list them in `found_else`, one line each, with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- **Out of steps:** if you run low, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`.
- **Long commands:** wait in the foreground with a bounded poll; don't end your turn to wait.

## What to return

Return, in plain words:

`{name: "86bcm901j-mcp-templates", status: ready-for-pr|stopped, origin_main_merged, prs_brought_in[], merge_commit, merge_notes, final_head, commits_on_top[], rulings[], gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], pr_title, pr_body_path, handover_files[], owed[], found_else[], skill_lessons[]}`
