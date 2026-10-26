# FINISHER brief ("make a PR" + upload photos): Leorna story 86bcm945u "upstream-sync"

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent.

## What Justin authorized (his words, verbatim)

> make a pr and upload photos to clickupo

That authorizes exactly two things:
1. **"make a PR"**: run the `leorna` skill's step 7 for this story. Re-run the gates, push the branch and open the PR as the `Justin-Leorna` account. **Never merge.**
2. **"upload photos to ClickUp"**: upload the 7 AC screenshots as attachments to card `86bcm945u`. **That is all.** Don't add the closing comment (it stays a draft until Justin says "post"), don't upload the gate log, and never change the card's status, checkboxes, assignees or fields.

Nothing else is authorized: no team message, no merge, no pushing a later commit (see step 8 below).

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna` (step 7 "make a PR", step 4b ClickUp upload rules, hard rules).
2. `engineering-best-practices`.
3. `git-commit-rules`.
4. `github` (gh PR creation and checks).

## Inputs

- Repo `~/Leorna/leorna-control-plane`.
- Worktree `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync`.
- Branch `feat/86bcm945u-upstream-sync`.
- **Accepted head `73edc52abd4608923428ff7590dc3259abc60129`** on base `6e74ced843642439d1dac9f25673440fb0f285f5`. `ac-check.sh` printed ALL ACCEPTED 7 of 7 on it. 21 commits, all `Justin Issa <justin@leorna.com>`, not pushed, no upstream tracking.
- Hand-over: `~/.hermes/plans/leorna/evidence/86bcm945u/handover/`:
  - `pr-text.md`;
  - body-only copy `~/.hermes/cache/scratch/leorna-pr-86bcm945u-upstream-sync.md`;
  - `stop-and-show.md`;
  - `upload/` (7 PNGs plus `gates-73edc52.txt`);
  - `attachments.md`;
  - `clickup-comment.md` (draft, not to be posted).
- ClickUp card: `86bcm945u`.

## Part A: make the PR (`leorna` step 7)

Give a one-line status before the gates, because they take minutes.

1. **Fetch a fresh main over HTTPS through gh:** `git -C <repo> -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`.
2. **Pre-flight**, in the worktree:
   - `git status --porcelain --untracked-files=all` is empty.
   - Every author in `git log --format='%an <%ae>' origin/main..HEAD` is Justin's Leorna identity. No `Co-Authored-By` or AI lines. No `CLAUDE.md` in the diff.
   - `git diff --name-only origin/main...HEAD` has no `.github/` paths.
   - `git merge-tree --write-tree --name-only HEAD origin/main` exits 0. A clean merge needs no rebase, so **don't rebase** and keep head `73edc52`. On a conflict, **stop and report**. Don't resolve it.
   - Note whether `origin/main` moved past `6e74ced` and what changed (PR #85 / #88 siblings may have merged).
3. **Re-run the gates on the exact head `73edc52`**, in a background run with one log per gate plus a `SUMMARY.txt` of `label EXIT=<rc>` lines:
   - `make check` (CI's golangci-lint 2.14.0 and govulncheck bound by absolute path; your own Postgres database whose name ends in `_test`; confirm the Postgres tests really ran);
   - `bash ./scripts/test-module-add.sh`;
   - the 7 AC commands from `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md` (AC2 with `LEORNA_TEST_DATABASE_URL`, AC7 with `LEORNA_TEST_UPSTREAM_NETWORK=1`; no skip lines, and ignore your own echoed `$ ` command line when counting).

   If `origin/main` moved, also run `make check` on a scratch merge of head into the new `origin/main` (a detached worktree; nothing pushed). Report the result: a failure there is a real integration problem, so stop and report rather than pushing.

   Save logs in `~/.hermes/plans/leorna/evidence/86bcm945u/pr/`. Check `df -h /` first. A host failure (no space left, go-build cache wiped) isn't a code failure: keep it under a suffixed name and rerun once. A gate failing for a reason outside the branch is reported in the Test Plan, not fixed here.
4. **PR text:** start from the body-only copy. Update its Test Plan to list only what ran in this session on `73edc52` (dates and exit codes from your logs). Keep the plain style, the ClickUp link, the security / migration / rollback notes and the Evidence block. Write the final body to `~/.hermes/plans/leorna/evidence/86bcm945u/pr/pr-body.md`. No server domain, URL, tenant ID, token or email in it.
5. **Account check before pushing:** `gh auth status` must show the active account `Justin-Leorna`. **Never run `gh auth switch`, and never change a remote URL or credential helper.** If the push would go as `Just-In-N-Out`, stop and report.
6. **Push:** `git -C <worktree> -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm945u-upstream-sync:refs/heads/feat/86bcm945u-upstream-sync`. Fetch it back into `refs/remotes/origin/feat/86bcm945u-upstream-sync` the same way, then run `git branch --set-upstream-to=origin/feat/86bcm945u-upstream-sync` and check that `git rev-parse HEAD origin/feat/86bcm945u-upstream-sync` match. Never push to `main`, and never force.
7. **Open the PR:**
   - `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm945u-upstream-sync --state all` must be empty. Never create a duplicate.
   - `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm945u-upstream-sync --title "feat(86bcm945u): upstream content sync + licence attribution" --body-file <pr-body.md>`. Not a draft.
   - Read it back with `gh pr view <n> -R LeornaAI/leorna-control-plane --json number,url,state,isDraft,headRefOid,mergeable` and `gh pr checks <n>`. `headRefOid` must be `73edc52…`.
   - Wait for CI with a bounded watch (about 20 minutes at most).
   - When the "Go quality gates" run finishes, fill the PR's Evidence block with the head SHA, check name, result and Actions run URL via `gh pr edit <n> --body-file <updated body>`. If CI hasn't finished, leave it "pending" and report the run URL.
   - Report anything CI flags. Don't fix CI failures in this pass: report them.
8. **`delivery/stories.json`:** once the PR exists, add this story's entry with the real PR number, in the format `~/Leorna/leorna-control-plane/delivery/README.md` gives, as **one small local commit** on the same branch (`chore(86bcm945u): record PR #<n> in delivery/stories.json`, repo identity, no AI lines).
   - **Don't push it.** Justin says when.
   - Verify that the commit's complete changed-path list is exactly `delivery/stories.json` and that `src`/tests are byte-identical to `73edc52`.
   - Run any records check the README names, and record its exit code.
   - If the README says the entry should come later, or the format is unclear, skip it and say why.

## Part B: upload the 7 photos to ClickUp card 86bcm945u

You can do this while the gates run.

1. Files: exactly the 7 PNGs in `~/.hermes/plans/leorna/evidence/86bcm945u/handover/upload/`, `ac1-…` to `ac7-….png`. Not `gates-73edc52.txt`.
2. **Before anything leaves the Mac, look at each image yourself.** No server domain, real host in a URL bar, tenant ID, token, device code, email or password may be visible. Confirm each file's SHA-256 matches its source in `attachments.md`. If an image fails the check, don't upload it: report it.
3. Read the card first (`clickup_get_task` with `include: ["attachments"]`) and note its existing attachments, so you never upload a duplicate.
4. Upload each file with the ClickUp MCP tools: `clickup_request_attachment_upload` (ticket plus the multipart POST it describes, one ticket per file, keeping the `ac<n>-<what>.png` name) or `clickup_attach_task_file` for small files. Load the tool schemas with ToolSearch first.
5. Read the card back with `include: ["attachments"]` and compare the titles to the intended 7. ClickUp has no attachment-delete API: if a wrong file goes up, upload the right one and report exactly which attachment Justin should delete by hand.
6. Don't add a comment. Don't touch status, checkboxes, assignees or fields.

## Rules

- Never merge, never force-push, never push to `main`, never post the team message.
- Never put a server domain, URL, tenant ID or token in the PR, ClickUp or your report.
- Use `perl -pi`, not `sed -i`, for any in-place edit (BSD sed), then grep to confirm.
- If anything outside these two authorized actions seems needed, stop and report; don't do it.
- **Other problems:** list in `found_else`.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

`{status: done|stopped, summary, origin_main_before, origin_main_now, merge_tree: clean|conflict, gates (command → exit → log), pushed_head, pr {number, url, state, isDraft, headRefOid, mergeable}, ci {check, result, run_url}, pr_body_path, stories_json {commit, pushed: false, check_exit} or skipped_reason, clickup {attachments_before[], uploaded[{file, title, sha256}], attachments_after[], to_delete_by_hand[]}, stop_reason, found_else[], skill_lessons[]}`.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
