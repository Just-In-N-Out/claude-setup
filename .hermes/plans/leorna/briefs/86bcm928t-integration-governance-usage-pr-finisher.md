# PR FINISHER brief: 86bcm928t integration governance and usage ("make a PR" + "post")

Role: PR FINISHER. You are a fresh general-purpose agent (Opus 5.5, high effort). Start no other agents.

**Justin's words, verbatim (2026-11-08):** "ok lets make a pr and post on clickup".

That authorizes exactly two things, each word only itself (`leorna`: "Each word authorizes only itself"):
- **"make a PR"** = push the branch and open the PR (`leorna` Doing a story step 7, sub-steps 1–7). Never merge.
- **"post"** = the ClickUp closing comment plus its image attachments on card 86bcm928t (step 7.9 and `clickup-evidence.md`).

Never change the card's status, checkboxes or assignees. Never merge. Don't send the team message: it goes after merge.

## State (checked by the main session at 15:34 EST)
- Worktree: `/home/justin/Leorna/86bcm928t-integration-governance-usage`, branch `feat/86bcm928t-integration-governance-usage`. HEAD is `9276c33966aea25c8227ca3efe56a1bdb203012e` and clean.
- GitHub main is `f0a326b83aae9d181e4f6681645685ae4b1fff91`, unchanged; it is the branch's base. The branch isn't on GitHub yet (404), and no PR exists for it.
- One open PR is from another story: **#113** `feat/86bcx2a33-github-mcp-current`. Merge-tree it against this head (read-only `pull/113/head` fetch, checking `FETCH_HEAD` against `headRefOid`), and also against main. Report conflicts that touch this branch's files.
- `ac-check.sh --reviews` printed **ALL ACCEPTED: 3 of 3 ACs on 9276c33**. There are no `(live)` ACs.
- Hand-over drafts are in `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/handover/`:
  - `pr-title.txt` and `pr-body.md`
  - `clickup-comment.md` and `attachments.txt` (7 PNGs, already checked)
  - `review-prompt.md`, `team-message.md` and `hand-over.md`
- **If main moved** past `f0a326b` by the time you push, stop and report. Bringing main in needs Justin's separate OK; see the memory note `leorna-no-reverify-while-main-moves.md` for what that would then involve.

## Skills: load each with the Skill tool and say so in one line
`leorna` (step 7 in full, and `clickup-evidence.md`), `git-commit-rules`, `github`, `engineering-best-practices`.

## Do, in order
1. **Gates first.** Give a one-line note that the gates are running, then re-run step 4's gates on exact head `9276c33` (step 7.3) from a detached copy on the real disk (`~/.cache/86bcm928t-pr/`), never in the worktree:
   - `make check`, with CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path. Toolchain: `~/.local/leorna-toolchain`, on a task-local PATH.
   - Then `bash ./scripts/test-module-add.sh`, serially.
   - `python3 -m unittest scripts/test_release.py`.
   - The Postgres no-skip check.
   - Use your own Postgres and ClickHouse containers (CI's pinned images, `--rm`, memory caps, password in a 0600 file), with names starting `928t-pr-`. The builder's containers are gone. Never touch `leorna-pg` or `leorna-test-pg`.
   - Run nothing else heavy at the same time as `make check`: load makes `TestQuickStartPickIsBoundedAndReleasesTheLockWithPostgres` flaky. If a timing test fails, rerun it alone under `-race`, then the unchanged `make check`, and report every run.
   - Logs and receipts go in `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/pr/`.
   - If a gate fails because of the branch, stop and report: don't push.
2. **Pre-flight (step 7.2):**
   - Porcelain is empty.
   - Authors are only the Leorna identity, and no commit body has AI attribution lines. Print the check's result, never the address.
   - No `.github/` paths.
   - Merge-tree against main exits 0.
   - The #113 check above.
   - The card-ID until/once grep.
3. **PR text.** Update `pr-body.md` so its Test Plan lists only what ran in **your** session on head `9276c33`, with log paths. Keep the earlier verifier note only as clearly labelled history if it is still relevant. Other stories are named by PR number or title, never by bare card ID. No `Title:` line in the body. Save the final body as `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/pr/pr-body.md`.
4. **Push (step 7.6).** Use the `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm928t-integration-governance-usage:refs/heads/feat/86bcm928t-integration-governance-usage` form, with the URL written out, never in a variable.
   - Fetch it back into `refs/remotes/origin/<branch>`, set the upstream, and check that `git rev-parse HEAD origin/<branch>` match.
   - `git-guard.sh` may ask Justin to approve the push: that is expected.
   - Never use `gh auth switch` and never change a remote. If the push would go as `Just-In-N-Out`, stop.
5. **Open the PR (step 7.7).**
   - `gh pr list ... --head <branch> --state all` must be empty first.
   - `gh pr create -R LeornaAI/leorna-control-plane --base main --head <branch> --title "$(cat pr-title.txt)" --body-file <final body>`, as the active gh account `Justin-Leorna`.
   - Read it back with `gh pr view --json number,url,state,isDraft,headRefOid,mergeable`.
   - Watch `gh pr checks` with repeated bounded polls (under 3 minutes each, Bash `timeout` set above the bound) until CI finishes, about 15–17 minutes. Report the real result.
6. **Record the PR (step 7.8).**
   - Add the PR number to this story's `delivery/stories.json` entry as a small commit on the branch, `chore(86bcm928t): record PR #<n> in delivery stories`, plain `git commit -m`.
   - Prove the record by value, and run `scripts/check-story-shippable.py 86bcm928t`, expecting only the PR-state BLOCKED lines.
   - **Don't push this commit:** pushing it would cancel the CI run on the first head, and Justin pushes it when he says so. Report its SHA.
   - Record the PR in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` by updating the existing 86bcm928t status line.
7. **Post to ClickUp (step 7.9, `clickup-evidence.md`).**
   - Fill `clickup-comment.md` with the PR number and URL, the head SHA and the CI run result. Merge facts stay **pending**: the PR isn't merged.
   - Before uploading, re-open each PNG in `attachments.txt` and check again that no domain, URL bar, tenant ID, token or email is visible. Images only, never a `.txt` or `.log`.
   - Upload each with `mcp__clickup__clickup_request_attachment_upload` (one ticket per file, requested right before each upload; tickets expire in minutes) plus the multipart curl it gives. Use `file_name` for readable names.
   - Add the comment with the ClickUp comment tool.
   - Read both back: `clickup_get_task` with `include: ["attachments"]` (compare titles and each `size` with local byte counts), and `clickup_get_task_comments`.
   - If an upload goes wrong, there's no delete API: upload the right file and tell Justin which one to delete by hand.
8. **Clean up:** stop your containers and remove `~/.cache/86bcm928t-pr/`.

## Windows desktop: runaway memory
A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep 'sending SIG'` before reading it as a result. Run heavy checks under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 <cmd>`.

## Report
- Return:
  - `status`
  - `pr {number, url, state, head}` and the `ci` result
  - `gates[{name, log, exit_code}]`
  - `merge_tree` results, against main and #113
  - `stories_commit_sha` (local, unpushed)
  - `clickup {comment_id, attachments[{title, size, local_bytes}]}`
  - `found_else[]`
  - `skill_lessons[]`
- If you find another bug, don't fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable, don't edit any skill or memory file, apart from the `leorna-workflow.md` line above. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section.
  - `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: kind, what it checks, where it runs.
  - An empty list is normal.
- Don't end your turn to wait for a background command or CI. Wait in the foreground with bounded polls.
- End with `MAIN SESSION: check and save these skill_lessons now.`
