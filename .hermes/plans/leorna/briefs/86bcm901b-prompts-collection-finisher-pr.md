# FINISHER (make a PR) brief: 86bcm901b-prompts-collection [leorna]

**Role:** FINISHER for the Leorna story "86bcm901b-prompts-collection" (ClickUp "Curate the reusable prompts collection"), doing exactly the `leorna` skill's **"Doing a story" step 7 ("make a PR")**: re-run the gates on the exact head, push the branch, open the PR. You are fresh.

**Justin's words (2026-10-28, voice note):** "Sure, make it pure, let's do it." The main session reads "make it pure" as **"make a PR"** (he had just been asked to say "make a PR"). Each word authorizes only itself: "make a PR" = push the branch + open the PR. It does **not** authorize merging, "post" (ClickUp), or pushing anything later ("push" for the `stories.json` PR-number commit is a separate word). Never merge.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FINISHER role; step 7 in full, its hard rules on identity and merge policy, and the finishing notes it names).
2. `engineering-best-practices`.
3. `git-commit-rules`.
4. `github` (gh CLI: PR create, view, checks).

## State going in

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection`, branch `feat/86bcm901b-prompts-collection`, head **`63afe554f42e593b545741e453a59d560c49cb22`**, 15 commits on base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`, all by `Justin Issa <justin@leorna.com>`, clean, never pushed.
- **Acceptance:** `ac-check.sh` READY FOR THE USER (AC1–AC4 accepted by a verifier and a blind auditor on `63afe55`); **AC5 (live) accepted by Justin** on 2026-10-28 from an agent-run session (`evidence/86bcm901b/ac5-run/`; the `/spec` gap is recorded). Plan: `~/.hermes/plans/leorna/86bcm901b-prompts-collection.md`.
- **Hand-over pack:** `~/.hermes/plans/leorna/evidence/86bcm901b/handover/` (`pr-text.md` = the PR body draft, also at `~/.hermes/cache/scratch/leorna-pr-86bcm901b-prompts-collection.md`; `sibling-conflicts.md`; `stop-and-show.md`; `README.md`).
- **Siblings in this repo:** 86bcm901a (agent definitions), 86bcm901j (MCP templates), 86bcm901w (pack builder) are in progress in other sessions; Yan's draft PR #94 (86bcm9021) is open. Never touch their worktrees, branches, databases or evidence.

## Steps (`leorna` step 7)

1. **Fresh main:** fetch GitHub `main` over HTTPS through `gh` (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, or plain `git fetch origin main` if the SSH alias works). Record `git rev-parse origin/main` and recheck it before the final gates and before pushing.
2. **Pre-flight:**
   - `git status --porcelain --untracked-files=all` empty; every author in `git log --format='%an <%ae>' 1ee7157..HEAD` is `Justin Issa <justin@leorna.com>`; `git diff --name-only 1ee7157...HEAD -- .github` empty; no `CLAUDE.md` in the diff.
   - `git merge-tree --write-tree --name-only HEAD origin/main` exits 0.
   - **If `origin/main` is still `1ee7157`:** go on.
   - **If `origin/main` moved:** read which PRs merged. If `merge-tree` reports a conflict, or a sibling story (901a, 901j, 901w) merged, **stop with `status: needs-bring-main-in`** and the conflict list: Justin must say "bring main in" first (the hand-over README asks for it), and the merged head then needs re-verification. If the merge is clean and no sibling story merged, a clean merge needs no rebase: still run this story's gates on main's new content (in a scratch copy of the merge result) before pushing, and grep the branch for stale "until/once … merges" wording about anything that merged.
   - Run read-only `merge-tree` against each open sibling PR's head (`gh pr list -R LeornaAI/leorna-control-plane --state open`) and list conflicts for the PR's Assumptions (the hand-over's `sibling-conflicts.md` has the expected ones).
3. **Re-run the gates on the exact head you'll push**, even though they were green before (`evidence/86bcm901b/builder-tools/gates.sh` and the finisher's `SUMMARY-63afe55.txt` show the set): `make -s check` with `GOLANGCI_LINT`, `GOVULNCHECK`, `GITLEAKS` bound and no cached tests, `scripts/test-module-add.sh`, the `go test -json -run WithPostgres` per-test read, the stories unittest (`python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` from the repo root), branch gitleaks, the four AC tests, plus the two network tests. Run `make check` and `test-module-add.sh` in a scratch copy (`git clone --shared` or a detached worktree), never the story worktree. Each gate writes its own log and a `label EXIT=<rc>` line into one `SUMMARY.txt` in `~/.hermes/plans/leorna/evidence/86bcm901b/pr/` (create it). If a gate fails for a reason outside the branch, say so plainly; a real failure in the branch means **stop, don't push**.
   - **Environment:** `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local` and `TMPDIR` on disk (`~/.cache/leorna-86bcm901b/pr-tmp/`, created and removed by you), never `/tmp` (a small shared RAM disk).
   - **PostgreSQL is stopped.** Start the story's server for the gates: `ENV=~/.cache/leorna-86bcm901b; LD_LIBRARY_PATH=$ENV/pg/root/usr/lib/x86_64-linux-gnu $ENV/pg/root/usr/lib/postgresql/18/bin/pg_ctl -D $ENV/pg/data -l $ENV/pg/server.log -o "-c listen_addresses=127.0.0.1 -c port=55400 -c unix_socket_directories=''" -w start` (credentials in `$ENV/pg/pg.env`, `$ENV/pg/password`). Use databases named `leorna_86bcm901b_pr_*_test`, drop them, and stop the server again when you're done. Never print the password or a DB URL.
4. **PR text:** start from `handover/pr-text.md`. The Test Plan lists only what ran in this pass on this head (with results). Assumptions keep the sibling-conflict notes, hosted CI not yet run, the `/spec` gap, and the follow-ups already there. Christian's plain style, not the checkbox template. Control-plane extras: ClickUp link (https://app.clickup.com/t/86bcm901b), security/migration/rollback notes, and an Evidence block (head SHA, required check "Go quality gates", Actions run URL filled in once the run exists). **No AI attribution lines anywhere** (no "Generated with Claude Code", no Co-Authored-By): Justin's rule. Never put a server domain, URL, tenant ID or token in it. Write the final body to `~/.hermes/cache/scratch/leorna-pr-86bcm901b-prompts-collection.md`.
5. **Push** as the Leorna account only. Check `gh auth status` shows `Justin-Leorna` active; never run `gh auth switch` and never change a remote URL or credential helper. Push over HTTPS through `gh` (the SSH key may be locked): `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm901b-prompts-collection:refs/heads/feat/86bcm901b-prompts-collection`. If the push would go as `Just-In-N-Out`, stop and report. Then fetch the branch back into `refs/remotes/origin/feat/86bcm901b-prompts-collection` the same way, `git branch --set-upstream-to=origin/feat/86bcm901b-prompts-collection`, and check `git rev-parse HEAD origin/feat/86bcm901b-prompts-collection` match.
6. **Open the PR:** `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm901b-prompts-collection --state all` must be empty (never a duplicate). Then `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm901b-prompts-collection --title "feat(86bcm901b): curate the reusable prompts collection" --body-file ~/.hermes/cache/scratch/leorna-pr-86bcm901b-prompts-collection.md`. Not a draft. Read it back with `gh pr view <n> -R LeornaAI/leorna-control-plane --json number,url,state,isDraft,headRefOid,mergeable,author` and `gh pr checks`.
7. **CI:** wait for the "CI" workflow's run on the PR (bounded: up to about 25 minutes; use `gh pr checks <n> --watch` or `gh run watch` with a timeout, in the foreground). Then fill the Actions run URL into the PR body's Evidence block with `gh pr edit --body-file`. Report each check's result. If a check fails, read its log (`gh run view --log-failed`), classify it (branch defect vs CI/environment), and stop: don't push fixes in this pass.
8. **stories.json PR number** (`leorna` step 7.8): add the PR number to this story's entry in `delivery/stories.json` as a small local commit on the branch (`chore(86bcm901b): record PR #<n> in stories.json` or the repo's existing wording), check it with `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` from the repo root, and **don't push it**: Justin says "push" for that. Report the new local head.
9. **Don't:** merge, close, approve or comment on any PR; write to ClickUp; touch sibling branches; change `.github/`; change anything in Justin's git or gh config.

## Boundaries

- Commits only as the repo identity (`Justin Issa <justin@leorna.com>`); never `-c user.*` or `--author`; no AI attribution lines. Never commit a `CLAUDE.md`.
- Don't edit memory notes; return a ready-to-paste dated status line for `leorna-workflow.md` (PR number, URL, head, CI result, local unpushed stories.json commit) and the main session applies it.
- **Shell gotcha:** `grep` here is Claude Code's ugrep wrapper (skips gitignored and binary files; bounded repeats fail): use `command grep` in scripts.
- Scratch: `/tmp/claude-1000/-home-justin-Leorna/77db91ea-503b-4eea-89eb-4d64d373a178/scratchpad/86bcm901b-finisher-pr/` for tiny notes only (created with `mkdir`, no `-p`); work copies and temp files under `~/.cache/leorna-86bcm901b/` (yours to create and remove).
- You can't ask Justin anything and can't start other agents. Claude Code refuses report files from subagents: return your report as your final message.
- Other bugs: `found_else`. Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` (an empty list is normal) and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{status: pr-open|needs-bring-main-in|stopped, summary, origin_main, pushed_head, pr_number, pr_url, pr_state, is_draft, pr_author, gates[{name, exit}], ci[{check, result, url}], sibling_pr_conflicts[], stories_json_commit, local_head, workflow_status_line, steps_for_justin[], stop_reason, found_else[], skill_lessons[]}`.
