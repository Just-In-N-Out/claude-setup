# FINISHER (publish) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **FINISHER** (Opus 5.5, xhigh) for the publication step.

## What Justin authorized (2026-10-24)

Asked what "go" should do, Justin picked **"Make a PR + post"**:
- **make a PR** = re-run the gates on the exact head, push the branch, open the PR (`leorna` skill → Doing a story → step 7, sub-steps 1–7);
- **post** = the ClickUp closing comment plus its attachments on card `86bcm901v` (`leorna` step 7.9 and `clickup-evidence.md`).

**Not authorized:** merging (never), changing the card's status, checkboxes or assignees, `gh auth switch`, changing remotes or credential helpers, any server/cloud action, `.github/` edits. Each word authorizes only itself.

## The candidate

- **Repo / worktree:** `~/Leorna/leorna-control-plane`, worktree `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3` (upstream unset on purpose so nothing pushed to main by accident).
- **Accepted head:** `2c43b3941ced883c8d4aa6f7bad7913a9043c173` on base `6e74ced843642439d1dac9f25673440fb0f285f5`. `ac-check.sh` → `ALL ACCEPTED: 3 of 3 ACs on 2c43b39` (independent verifier + blind auditor). **Push exactly this head.** If the worktree isn't clean at `2c43b39`, stop and report.
- **Hand-over drafts (use them, update only what publishing makes stale):** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/handover/` → `HANDOVER.md`, `stop-and-show.md`, `pr-text.md` (title `feat(86bcm901v): library catalog browser in the admin console`), `review-prompt.md`, `team-message.md`, `clickup-comment.md`, `clickup/` (3 screenshots, one per AC, plus 5 gate/AC logs, all checked by the previous finisher).

## Skills (load with the Skill tool; say so in one line each)

1. `leorna` (FINISHER role): Doing a story → step 7 ("make a PR") and 7.9 ("post"), the Identity and Merge-policy hard rules, step 4's control-plane gates; read `clickup-evidence.md` and `~/Leorna/leorna-control-plane/delivery/README.md`.
2. `engineering-best-practices`.
3. `git-commit-rules` and `github`.

## Steps

1. **One-line status first** in your notes, then the gates take minutes.
2. **Fresh main:** fetch over HTTPS through gh (`leorna` 7.1): `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`. Say whether `origin/main` moved past `6e74ced`.
3. **Pre-flight (7.2):** `git status --porcelain` empty; every author/committer in `git log --format='%an <%ae>' origin/main..HEAD` is `Justin Issa <justin@leorna.com>`; `git diff --name-only origin/main...HEAD -- .github` empty (no CI exception for this story); `git merge-tree --write-tree --name-only HEAD origin/main` exits 0. **On a conflict, stop and report** (no rebase without Justin).
4. **Gates on the exact head (7.3):** in a detached copy of `2c43b39` (leave the worktree clean), with your own DB `leorna_86bcm901v_v3_publish_test` (ends in `_test`; drop it after) and CI's tool versions bound by absolute path (golangci-lint 2.14.0, govulncheck v1.7.0): `make check` with Postgres, a separate verbose `go test -v` run of the story packages, `bash ./scripts/test-module-add.sh`, `make contracts-check`. Logs with `label EXIT=<rc>` in a `SUMMARY.txt` under `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/publish/`. A failure caused by this branch → stop and report. A failure outside the branch → per 7.4, still open the PR and say so in the Test Plan.
5. **PR text (7.5):** start from `handover/pr-text.md`; the Test Plan lists only what ran this session on `2c43b39` (your gate run plus the verifier/auditor receipts, each saying who ran it). Write the final body to `~/.hermes/cache/scratch/leorna-pr-86bcm901v-catalog-browser-v3.md` and a copy in `publish/`. **No AI attribution lines** (Leorna rule: no Co-Authored-By, no "Generated with" footer). No server domain, URL, tenant ID or token.
6. **Check the push identity before pushing:** `gh auth status` must show the active account `Justin-Leorna`. If the push would go as `Just-In-N-Out` or any other account, **stop and report** (never `gh auth switch`).
7. **Push (7.6):** `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm901v-catalog-browser-v3:refs/heads/feat/86bcm901v-catalog-browser-v3`, then fetch it back into `refs/remotes/origin/feat/86bcm901v-catalog-browser-v3`, `git branch --set-upstream-to=origin/feat/86bcm901v-catalog-browser-v3`, and check `git rev-parse HEAD origin/feat/86bcm901v-catalog-browser-v3` match `2c43b39…`.
8. **Open the PR (7.7):** `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm901v-catalog-browser-v3 --state all` must be empty (never a duplicate); `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm901v-catalog-browser-v3 --title "feat(86bcm901v): library catalog browser in the admin console" --body-file <file>`; read back with `gh pr view … --json number,url,state,isDraft,headRefOid,mergeable` and `gh pr checks`. **Never merge.**
9. **Wait for CI** (`gh pr checks --watch`, or poll with a sensible cap of about 20 minutes). Record the "Go quality gates" result and the Actions run URL. If CI fails because of this branch, don't post: stop and report with the failing step. If CI is still running at the cap, continue and say "CI running" with the run URL.
10. **stories.json (7.8):** do **not** commit or push a `delivery/stories.json` change in this step (it would change the accepted head and needs its own push word). Instead write the exact entry it needs (`86bcm901v` with its dependency PRs and the new PR number, in the file's existing format) into `publish/stories-json-entry.md` for Justin.
11. **Post to ClickUp (7.9 + `clickup-evidence.md`):**
    - Update `handover/clickup-comment.md` into `publish/clickup-comment-final.md`: fill in the PR link and number, the CI result and run URL; merge SHA = "not merged yet (Justin merges)". Keep the NOT VERIFIED section.
    - **Before anything leaves the Mac:** open every attachment in `handover/clickup/` and check it visually (no server domain, URL bar with a real host, tenant ID, token, device code or email), and open every log, read its `EXIT=` line and check it for secrets. Drop anything that fails and say so.
    - Upload each attachment to task `86bcm901v`: `clickup_attach_task_file` for files under 200 KB, otherwise `clickup_request_attachment_upload` (one ticket per file, multipart POST as it instructs). Load the ClickUp tool schemas with ToolSearch first.
    - Add the comment with `clickup_create_task_comment` (or the comment tool the server offers for tasks).
    - **Read both back:** `clickup_get_task` with `include: ["attachments"]` and compare titles to your intended list; `clickup_get_task_comments` to confirm the comment text. ClickUp has no attachment delete: if a wrong file goes up, upload the right one and tell the main session which one Justin must delete by hand.
    - Don't change the card's status, checkboxes or assignees.
12. Clean up your detached copy and DB; leave the worktree clean.

## Rules

- Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches, DBs or Terminal windows.
- Shared memory notes and skills are updated by the main session: put anything for them in your report.

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity).

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{status: published|stopped, stop_reason, origin_main, pushed_head, push_account, pr{number, url, state, isDraft, headRefOid, mergeable}, ci{check, conclusion, run_url}, gates[{name, exit_code, log}], clickup{comment_id, attachments_uploaded[], read_back_ok}, stories_json_entry_file, files_written[], found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
