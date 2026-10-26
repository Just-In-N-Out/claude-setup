# FINISHER brief (make a PR + post): 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **FINISHER** for the Leorna story **Content quality gate (CI)**, ClickUp card [86bcm901u](https://app.clickup.com/t/86bcm901u). Model: Opus 5.5, effort xhigh. You are a fresh agent.

**Justin's words (2026-10-24, voice note):** "Post the photos on Clickup and do APR card. pr". The main session reads this as **"make a PR"** plus **"post"**. These two words authorize exactly: push the branch and open the PR (`leorna` → Doing a story step 7), and post the ClickUp closing comment with its attachments (`leorna` step 7.9). Nothing else: **never merge**, never change the card's status, checkboxes or assignees, never push any other branch.

## 1. Skills to load first (say so in your first steps)

1. `leorna`: the **FINISHER** role; follow **Doing a story step 7** ("make a PR") and **7.9** ("post"), plus 4b's rules for anything that leaves the Mac, and the finishing notes it names (`stop-and-show-diff.md`, `clickup-evidence.md`, `review-prompt-for-agent.md`, `~/Leorna/leorna-control-plane/delivery/README.md`).
2. `engineering-best-practices`
3. `git-commit-rules` (authorship, push rules; no AI attribution lines in commits **or the PR body**)
4. `github` (PR creation, read-back, `gh pr checks`)

## 2. The facts

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`f7dff509de5053d647084b2f6171262b91f005c9`** (clean, no upstream, never pushed; 29 commits, all `Justin Issa <justin@leorna.com>`). Base: GitHub `main` `6275a4e`. AC-accepted head: `ac-check.sh` said `READY FOR THE USER: 4 of 5 ACs proven on f7dff50; live ACs owed to the user: AC5`.
- **Hand-over package (read first):** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/handover/` (`README.md`, `pr-text.md` with `<…>` fill-ins, `clickup-comment.md`, `attachments.md` listing the 6 images with sha256, `team-message.md`, `stop-and-show.md`, `r4-a1-source-md.patch`).
- **R4-A1 (`SOURCE.md` doc sentence): Justin didn't choose.** Main session's reading (the safer one): **don't add it**: push the accepted head `f7dff50` as is, and in the PR's Assumptions list it as a known one-sentence doc nit with a ready patch. Fill the PR text's R4-A1 `<…>` accordingly.
- **Story-only CI exception** (memory `no-ci-changes.md`): the branch changes `.github/workflows/ci.yml` (5 added / 0 deleted). That is approved for this story only.
- **Push credentials (checked by the main session just now):** the active `gh` account is `Justin-Leorna` with scopes `gist, read:org, repo` (**no `workflow`**), and the SSH key for `github-leorna` is locked (`Permission denied (publickey)`). GitHub rejects a push that changes a workflow file over HTTPS without `workflow` scope. Justin has been asked to run `gh auth refresh -h github.com -s workflow` (or unlock his SSH key).

## 3. Steps

1. **Pre-flight and gates first** (`leorna` 7.1–7.3), on the exact head `f7dff50`: fresh HTTPS fetch of `main` through `gh`; `git status --porcelain` empty; every author is the Leorna identity; `.github/` paths = `ci.yml` only (story exception); `git merge-tree --write-tree --name-only HEAD origin/main` exits 0 (if GitHub main moved past `6275a4e` with a conflict, stop and report); re-run the gates on this head (CI's golangci-lint 2.14.0 bound by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test`, `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`), logs with exit codes in the hand-over folder as `pr-gates-f7dff50.*`. Disk is tight (check `df -h /`; under 3 GB stop with `blocked: disk`); never run `go clean -cache`.
2. **Push check:** right before pushing, re-check `gh auth status` for the `workflow` scope on `Justin-Leorna`, and `ssh -o BatchMode=yes -T git@github-leorna`. If the scope is present, push over HTTPS through `gh` exactly as `leorna` 7.6 says; else if SSH authenticates as the Leorna account, push to `origin` over SSH. **If neither, stop with `status: blocked-auth`** after the gates, report it, and do nothing further (no post): the main session will resume you once Justin has done his step. **Never** run `gh auth switch`, change a remote URL or credential helper, use the `Just-In-N-Out` account, or pass `--no-verify`/force. If a push would go as anyone but `Justin-Leorna`, stop.
3. **After the push:** fetch the branch back into `refs/remotes/origin/feat/86bcm901u-quality-gate-v3`, `git branch --set-upstream-to=origin/feat/86bcm901u-quality-gate-v3`, and confirm `git rev-parse HEAD origin/feat/86bcm901u-quality-gate-v3` match.
4. **Open the PR** (`leorna` 7.7): `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm901u-quality-gate-v3 --state all` must be empty; fill `pr-text.md`'s `<…>` (pushed head, R4-A1 as above, hosted CI pending) into a final body file in the hand-over folder; **no AI attribution line** in it; check it for any server domain, URL other than GitHub/ClickUp, tenant ID, token or email; then `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm901u-quality-gate-v3 --title "feat(86bcm901u): content quality gate in CI" --body-file <file>`. Read it back with `gh pr view … --json number,url,state,isDraft,headRefOid,mergeable` and `gh pr checks`. Report the URL. Note that the first "Go quality gates" run on the PR is AC5's first half: report its state (running/pass/fail) when you finish; don't wait more than ~15 minutes for it.
5. **stories.json PR number (`leorna` 7.8):** make the small commit adding the PR number to this story's entry in `delivery/stories.json` on the branch (author from git config; no AI lines), but **don't push it**: pushing it needs Justin's word. Say so.
6. **Post (`leorna` 7.9, "post"):** update `clickup-comment.md` with the facts as they now are (PR number and URL, pushed head, the PR's CI run state and URL if it finished; AC5 still NOT VERIFIED: the broken-item hosted run and the merge are pending; not merged). Upload the **6 images listed in `attachments.md`** to the card (re-check each file's sha256 against the list first, and look at each image once more: no token, server domain, URL bar, tenant ID or email). Use `clickup_attach_task_file` for small files or `clickup_request_attachment_upload` (one ticket per file, then the multipart upload it describes) for larger ones; give each a clear `file_name` like `86bcm901u-AC1-validate-render-scan.png`. Then add the comment with `clickup_create_task_comment` (or `clickup_create_comment`). **Read both back** (`clickup_get_task` with `include: ["attachments"]`, `clickup_get_task_comments`) and compare titles and text with what you meant to post. ClickUp has no attachment-delete API: if one goes wrong, upload the right file and tell the main session which one Justin must delete by hand. Never change the card's status.
7. Leave the worktree clean.

## 4. Boundaries

- Only `feat/86bcm901u-quality-gate-v3` is pushed. No merge, no other branch (not the `backup/86bcm901u-v3-pre-rebase*` branches), no force-push, no remote CI dispatch (the AC5 throwaway-branch run is Justin's call), no token or credential change, no ClickUp status/checkbox/assignee change.
- Don't touch: local `main`, other worktrees, DBs and scratch, `deploy/local/`.
- Never print tokens; never put a server domain, URL or tenant ID in the PR, comment or chat.
- **Found something else?** `found_else`, one line each.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## 5. Your report

Return JSON-shaped output: `{name, status: done|blocked-auth|blocked-disk|stopped, summary, head_pushed, pr_url, pr_number, pr_checks, stories_json_commit (local, unpushed), clickup_attachments[{file_name, ok}], clickup_comment_id, readback_ok, gates[{name, log, exit_code}], stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
