# FIXER 4 brief (bring main in + decided changes): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full**, after hand-over. Model: Opus 5.5, xhigh.

## Where the story stands

- **Branch:** `feat/86bcm901j-mcp-templates` in worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`. It is **pushed to GitHub at `66449af`** (upstream `origin/feat/86bcm901j-mcp-templates`) with **no PR yet**. Base `1ee7157`, 19 commits.
- **Acceptance:** `ac-check.sh` printed `ALL ACCEPTED: 5 of 5 ACs on 66449af` (`~/.hermes/plans/leorna/evidence/86bcm901j/ac-check-66449af.txt`). That record stays as it is.
- **GitHub main has moved** to `a8d1465` when last fetched. That includes #95 (86bcm901b prompts), #94 (86bcm9021 item templates, Yan) and #97 (86bcm901a agent definitions). PR #96 (86bcm901w) is still open. `git merge-tree` shows conflicts in `delivery/stories.json`, `internal/library/README.md`, `internal/library/content.lock.json` and `internal/library/content/library.json`. Main's `library.json` is `0.7.0`.
- **Justin's decisions:**
  - He said "make a PR" and chose "bring main in, then PR".
  - A decider picked the rulings for him: keep 12, **change ruling 13**, and answer the version-manager question with **B** (`~/.hermes/plans/leorna/evidence/86bcm901j/handover/rulings-decided.md`).
  - Justin, 2026-10-28: **no verifier, auditor or `ac-check.sh` re-run** for this bring-in, because main moves more than once. You run the gates and each AC test by name on the new head. Memory note: `~/.claude/projects/-home-justin-Leorna/memory/leorna-no-reverify-while-main-moves.md`.

## Your role

You are a fresh **FIXER** with four jobs:
1. Bring GitHub main into the branch with a merge commit.
2. Make the decided changes test-first.
3. Run the gates and the five AC tests on the final head.
4. Refresh the hand-over texts for that head.

Stop with `status: ready-for-pr`. **Never push, open a PR, merge or write to ClickUp**: the main session pushes and opens the PR after you return. Don't rebase, force anything or rewrite the 19 pushed commits. New commits go on top, so the push is a plain fast-forward.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna`. Skip its Step 1 full context load. Read Doing a story → step 7.2 closely: it covers the merge recipe, checking a finished merge, `gitleaks dir` for both-sides files, and the `stories.json` append.
2. `engineering-best-practices`
3. `test-driven-development`
4. `security-best-practices`: required for every role on this story. Read its npx/launcher env paragraph.
5. `mutation-testing-discipline`
6. `git-commit-rules`
7. `systematic-debugging` whenever something fails unexpectedly.

## Inputs

- **Approved plan:** `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`, including both "Justin's answers" sections and the update. A read-only copy is at `…/evidence/86bcm901j/plan-approved.md`: never edit it. AC1–AC5 and their test names stay exactly as approved.
- **Decisions:** `…/86bcm901j/handover/rulings-decided.md`. Its "For the fixer" and "PR text notes" sections are your change list. Two things there are out of date:
  - The decider wrote it for main `db3406e`. Main is now newer.
  - Its step 4 (verifier, auditor, `ac-check.sh`) is cancelled.
- **Merge plan:** `…/86bcm901j/handover/sibling-merge-plan.md`, with its file-by-file resolution and commands, and `sibling-trials/`. The trials were made against each sibling on its own. Main now holds all three, so resolve against the real main and don't reuse a trial patch blindly.
- **History:** `…/86bcm901j/INVENTORY.md` and the hand-over package in `…/86bcm901j/handover/`.

## Tasks, in order

1. **Fetch main fresh.** Fetch over HTTPS through gh (`leorna` 7.1) and record `git rev-parse origin/main`.
   - If main has moved past `a8d1465`, for example because #96 merged, merge the newest main and say which PRs it added.
   - Before your final gates, check again that `origin/main` hasn't moved. If it has, don't merge a second time: report it.
2. **Merge main in**: `git merge origin/main`, then resolve each file:
   - `delivery/stories.json`: take main's file unchanged and append this story's entry last, as text. Then check by value that every earlier entry is unchanged.
   - `internal/library/content/library.json`: take main's file and set the version to **`0.8.0`**, the next minor after main's `0.7.0`. Make the README's library line read "Library **0.8.0** (story 86bcm901j)".
   - `internal/library/content.lock.json`: keep both sides' lines, then rerun `-update-lock` and compare the old entries by value.
   - `internal/library/README.md`: keep both sides' text.
   - Finish with `git commit -m "Merge branch 'main' into feat/86bcm901j-mcp-templates"`. Don't use `--no-edit`, and don't add an AI line.
   - **Check the finished merge** as `leorna` 7.2 says:
     - Every file changed on only one side must equal that side's blob; check deletions with `git ls-tree`.
     - Review the files both sides changed, with an overlay mutant that drops each side's hunk.
     - `gitleaks dir` the both-sides files taken from the merged tree.
     - Grep the branch for stale "until/once … merges" wording and sibling card IDs (`86bcm901a`, `86bcm901b`, `86bcm9021`, `86bcm901w`), and fix any that are now stale.
3. **Main's new content against this story's policy.** Run `make library-check` and the library, gate, pack and web tests on the merged tree. #95, #97 and #94 added items and code with no text conflict, and this story's new policy stage (rules S, P, V, L) may now refuse some of them.
   - If something fails, find the root cause.
   - If the fix belongs inside this story and is safe, make it test-first and record it as "My ruling, not yet confirmed".
   - If it needs another story's code or content changed, or would weaken a policy rule, stop with `status: stopped` and give the options.
   - #94's `gate.CheckTenantItem` not running this policy is a known follow-up (PR text follow-up 3). Leave it, and reword the follow-up now that both stories are on main.
4. **Ruling 13, test first:**
   - First, the new AC3 subtest that refuses a NUL in a decoded env, header or arg value (RED).
   - Then the NUL check in `checkTemplate` (GREEN), with a positive control.
   - Then the README sentence.
   - Then the mutation proof: remove the check, and run an env-values-only variant; both must turn the subtest red.
   - Commit as `fix(86bcm901j): …`.
5. **Question B:** make the README rule-P edits from `rulings-decided.md`. The sentence becomes "sets none of these npm, node, corepack, git and shell launch settings", and the version-manager homes are listed as not covered. Run the grep checks the decider names, then commit.
6. **Gates on your final head**, exactly as fixer 3 ran them (`briefs/86bcm901j-mcp-templates-fixer3.md`, "Gates, environment and evidence"):
   - `make check`, with CI-pinned tools bound by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
   - `bash ./scripts/test-module-add.sh`
   - gitleaks over the branch range, plus the `gitleaks dir` from task 2.
   - The story-shippable unittest: `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`.
   - `make library-check`.
   - Each AC test by name: AC1 to AC4, and AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`.
   - Branch hygiene: authors, no AI lines, no `.github/` paths in `git diff --name-only origin/main...HEAD`, no `CLAUDE.md`.
   - Save `gates-<sha7>-*.txt` and `ac<n>-<sha7>.log` with `HEAD=` and `EXIT=` lines, plus five AC screenshots and a gate-summary screenshot on the final head, using the in-sandbox Chrome route in `INVENTORY.md`. Open each one and check that no token, server address or email shows.
   - **Don't** run a verifier, an auditor, base-commit AC runs or `ac-check.sh`.
7. **Refresh the hand-over** in `…/86bcm901j/handover/` for your final head:
   - **`pr-text.md` and its copy `~/.hermes/cache/scratch/leorna-pr-86bcm901j-mcp-templates.md`:**
     - Body only, with **no `Title:` line**.
     - Library `0.5.0 → 0.8.0`, plus the new item and subtest counts.
     - A Test Plan listing only what ran on the final head. State that `ac-check.sh` accepted `66449af` (verifier and blind auditor), and that on the final head the gates and each AC test ran by name after main was brought in.
     - In the follow-ups, remove follow-up 7, add the version-manager follow-up and reword follow-up 3.
     - Hosted CI stays NOT VERIFIED until the PR exists.
   - **`clickup-evidence.md`:** update for the new head and images.
   - **`review-prompt.md`:** the open question is answered (B) and ruling 13 changed.
   - **`rulings-for-justin.md`:** point it at `rulings-decided.md`.
   - **`INVENTORY.md`:** add a "Fixer 4" section.
   - Leave `team-message.md` as it is.
   - Don't add a PR number to `stories.json`: that happens after the PR exists.

## Environment

- **Machine and tools:** the Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` are read-only to you (Go, CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0). gcc 15.2 and make are system-wide. gitleaks 8.30.1 is at `/usr/local/bin/gitleaks`.
- **Disk:** `/tmp` is a small tmpfs shared by every session. Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-fixer4/` (`mkdir`, no `-p`) and remove it at the end.
- **Postgres:** Docker is on and `leorna-test-pg` publishes on 127.0.0.1:55432.
  - Use your own database `leorna_86bcm901j_fix4_test`. Read the container's password first and abort if it's empty.
  - Drop the database at the end, and never touch another session's database.
  - `TestSetupWizardWithPostgres` can time out under load: run it alone and rerun it before calling it a regression.
- **AC5:** real Codex and Claude Code run only in throwaway homes. Never run them against Justin's real `~/.codex` or `~/.claude`, not even for `--version`.
- **Evidence:** everything goes in `~/.hermes/plans/leorna/evidence/86bcm901j/`, with receipts in `…/86bcm901j/fixer4/`. Don't write in `review1/`, `review2/`, `fixer1/` to `fixer3/`, `verifier*/` or `auditor/`, and never touch `plan-approved.md`.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer4/` (`mkdir`, no `-p`), for small notes only. Never touch other folders in it, and remove yours at the end, after `git worktree remove` for any copy.
- **Never touch** other stories' worktrees, branches, databases, evidence folders or `~/.cache/86bcm901*-*` folders, and never switch the main checkout's branch.
- **Commits:** use the repo's own identity (`Justin Issa <justin@leorna.com>`): no author override, no `Co-Authored-By` or AI line, no `CLAUDE.md`. End with a clean worktree.
- **Secrets:** never put a server domain, URL, tenant ID or token in any file you write, and never print a token or password.

## Rules

- If the merge needs a **real code conflict** resolved (not record or docs files), resolve it test-first and flag it in `merge_notes`. The main session will then ask Justin whether to verify again.
- **Other bugs:** list them in `found_else`, one line each, with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- **Out of steps:** if you run low, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`.
- **Long commands:** wait in the foreground with a bounded poll; don't end your turn to wait.

## What to return

Return, in plain words:

`{name: "86bcm901j-mcp-templates", status: ready-for-pr|stopped, origin_main_merged, prs_brought_in[], merge_commit, merge_notes, final_head, commits_on_top[], changes[{item, commit, test, mutation}], rulings[], gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], pr_title, pr_body_path, handover_files[], owed[], found_else[], skill_lessons[]}`

`pr_title` is the `feat(86bcm901j): …` line for `gh pr create --title`.
