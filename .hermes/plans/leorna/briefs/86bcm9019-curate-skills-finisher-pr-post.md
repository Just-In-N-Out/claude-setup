# FINISHER (PR + post) brief: 86bcm9019-curate-skills [leorna]

**Role:** fresh FINISHER for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection").

**Justin's words (2026-10-25): "Make a pr and upload to click up"**, which is **"make a PR"** plus **"post"**:
- **"make a PR"** means push the branch and open the PR (the `leorna` skill, Doing a story → step 7, sub-steps 1–8);
- **"post"** means the ClickUp closing comment plus image attachments, read back (step 7.9 and `clickup-evidence.md`).

**Not authorized:** merging, changing the card's status or checkboxes, pushing any later commit (the `stories.json` PR-number commit stays local until Justin says "push"), and any CI/workflow change.

## Skills to load first (say so in your first steps)

1. `leorna`, FINISHER role, Doing a story → step 7. Read its notes `clickup-evidence.md`, `stop-and-show-diff.md` and `story-done-team-message.md` in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`, plus `~/Leorna/leorna-control-plane/delivery/README.md`.
2. `engineering-best-practices`.
3. `git-commit-rules`.
4. `github`: `gh pr create`, `gh pr view`, `gh pr checks`.

## The accepted candidate

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills` (not on GitHub yet).
- **Accepted head: `eab394045b08df247acb23b3a85f109bf02d1a4c`.** Base: `57783506979ae1d721b8ed9539f2b3193ed992c7`. `ac-check.sh` printed `READY FOR THE USER: 5 of 6 ACs proven on eab3940; live ACs owed to the user: AC6`. AC6 is Justin's live check and **is still NOT VERIFIED**: he hasn't done it yet.
- Hand-over folder, already written and image-inspected: `~/.hermes/plans/leorna/evidence/86bcm9019/handover/`. Use its `README.md`, `pr-text.md`, `clickup-comment.md`, `attachments.md`, `team-message.md` and `gates-eab3940.png`.

## Steps (the `leorna` skill's step 7; don't skip any)

1. **One-line status first.** Then fetch a fresh main over HTTPS through gh: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`. Record `git rev-parse origin/main`.
   - If main moved past `5778350`, run `git merge-tree --write-tree --name-only HEAD origin/main`.
     - If it exits non-zero (a conflict), **stop and report**. Don't rebase or merge without Justin's OK.
     - If it is clean, note that the gates in step 3 must also cover main's new content, per the skill: a sibling can add files a strict check refuses even with no text conflict.
2. **Pre-flight:**
   - `git status --porcelain` is empty;
   - every author and committer in `5778350..HEAD` is `Justin Issa <justin@leorna.com>`, with no AI or Co-Authored-By lines;
   - `git diff --name-only 5778350...HEAD -- .github` is empty;
   - HEAD is still `eab3940`;
   - `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm9019-curate-skills --state all` is empty;
   - `gh auth status` shows the active account `Justin-Leorna`. **Never run `gh auth switch`.** If the push would go as `Just-In-N-Out`, stop and report.
3. **Re-run the gates on the exact head you'll push**, from one background script that writes `SUMMARY.txt` with one `label EXIT=<rc>` line per gate. Logs go in `~/.hermes/plans/leorna/evidence/86bcm9019/pr/`. The gates:
   - `make check` with golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path (`GOLANGCI_LINT=… GOVULNCHECK=…`), gitleaks 8.30.1, and `LEORNA_TEST_DATABASE_URL` set to your own DB `leorna_86bcm9019_pr_test`. Read the password through docker, never print it, and drop the DB when done;
   - the Postgres tests, confirmed from a `go test -json -run WithPostgres` stream read per test;
   - `bash ./scripts/test-module-add.sh`;
   - AC1–AC5 by name, AC4 with `LEORNA_TEST_GITLEAKS_BIN`;
   - the network tests (`LEORNA_TEST_UPSTREAM_NETWORK=1`);
   - the lock by value.

   The pinned binaries are in `/private/tmp/claude-501/-Users-justin-Leorna/8269faf7-896a-43a9-8b43-35d27910a4df/scratchpad/builder-86bcm9019/`; check their versions first. A failure caused by something outside the branch gets explained in the Test Plan, never fixed in the branch. If a failure comes from the branch itself, **stop and report**, and don't push.
4. **PR text:** take `handover/pr-text.md`. Update its Test Plan to list only what ran in step 3 on this head, with results, and write it to `~/.hermes/cache/scratch/leorna-pr-86bcm9019-curate-skills.md`.
   - Title: `feat(86bcm9019): curate the skills collection`.
   - **No AI attribution anywhere in the PR body** (no "Generated with" footer): Leorna's rule.
   - Keep AC6 listed as owed to Justin, with V2-1 and the other follow-ups under Assumptions.
   - No server domain, URL or tenant ID.
5. **Push:**
   - `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm9019-curate-skills:refs/heads/feat/86bcm9019-curate-skills`;
   - fetch it back into `refs/remotes/origin/feat/86bcm9019-curate-skills`;
   - run `git branch --set-upstream-to=origin/feat/86bcm9019-curate-skills`;
   - check `git rev-parse HEAD origin/feat/86bcm9019-curate-skills` match.

   Don't change any remote URL or credential helper config.
6. **Open the PR:**
   - `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm9019-curate-skills --title "feat(86bcm9019): curate the skills collection" --body-file <file>`;
   - read it back with `gh pr view <n> -R LeornaAI/leorna-control-plane --json number,url,state,isDraft,headRefOid,mergeable,author` and `gh pr checks`;
   - wait for the checks to finish (`gh pr checks <n> --watch`, in the background if it's long) and record each check's result and the Actions run URL.

   A green "Go quality gates" (with "Check content library quality") is the card's "quality-gate CI run". **Never merge.**
7. **`delivery/stories.json` PR number:**
   - make a small local commit on the same branch that adds the PR number to the 86bcm9019 entry: `chore(86bcm9019): record PR #<n> in delivery/stories.json`, or whatever message style that file's history uses;
   - append and edit as text, then check every other entry is unchanged by value. The file is no longer exactly `json.dumps(indent=2)`;
   - author `Justin Issa <justin@leorna.com>`, no AI lines;
   - **don't push it.** Report it as needing Justin's "push".
8. **Post to ClickUp** (task `86bcm9019`, `clickup-evidence.md`):
   - Fill `handover/clickup-comment.md` with the facts as they now stand: PR number and URL, state open and **not merged**, head SHA, CI check names and results, Actions run URL. AC6 stays **NOT VERIFIED, owed to Justin**. The hosted CI result is whatever really happened.
   - Before anything leaves the Mac, check the comment text has no server domain, tenant ID, token or email. A PR URL on github.com is fine.
   - **Upload images only**, exactly the 6 in `handover/attachments.md` (5 verifier AC screenshots on `eab3940` plus `gates-eab3940.png`), never a `.log` or `.txt`. Open and look at each image once more before upload.
   - Upload with `mcp__clickup__clickup_request_attachment_upload`: one ticket per file, requested right before its upload because tickets expire within minutes, then the multipart POST it describes (curl). Use `file_name` to give readers clear names (`86bcm9019-ac1-….png`).
   - Then post the comment with `mcp__clickup__clickup_create_task_comment`.
   - **Read back:** `mcp__clickup__clickup_get_task` with `include: ["attachments"]`. Compare each title and `size` with the local byte counts against the intended list, then read the comments back with `mcp__clickup__clickup_get_task_comments`. ClickUp has no attachment-delete API: if an upload goes wrong, upload the right file and report exactly which attachment Justin should delete by hand.
   - **Never change the card's status, assignees or checkboxes.**
9. **Records:** update `handover/README.md` with the PR number and URL, CI results, the ClickUp comment ID and attachment IDs, the local `stories.json` commit, and what's still owed: AC6, "push" for the stories.json commit, merge, `check-story-shippable.py 86bcm9019` after merge (check the entry lists the PR first), and the team message with the PR number.

## Change from Justin (2026-10-25, after dispatch): "Nah don't mention ac6"

The PR body and the ClickUp comment must not mention AC6, the live 3-tool check or anything owed for it: list AC1–AC5 only. Keep AC6 recorded as owed in `handover/README.md` and the local drafts, with a note that it was left out of the PR and the comment at Justin's request.

## Rules

- Keep scratch in the scratchpad's `finisher-pr-86bcm9019/` subfolder and remove only that. Never print tokens.
- Don't write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.
- If any step's precondition fails, **stop at that step** and report exactly what landed and what didn't. Each word authorizes only itself.
- If you find a problem, list it in `found_else`. If you learn something reusable, don't edit skills or memory: list it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section. An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{status, head_pushed, origin_main, pr{number, url, state, isDraft, mergeable, headRefOid},
 ci[{name, result, url}], gates[{name, exit_code, log}],
 stories_json_commit{sha, pushed: false},
 clickup{comment_id, attachments[{title, size, local_size, ok}], status_unchanged},
 owed_to_justin[], found_else[], skill_lessons[]}
```
