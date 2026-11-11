# FINISHER brief, "make a PR": Leorna story 86bcm928h-per-user-credentials

**Role:** FINISHER, publishing the PR. You are a fresh agent: Opus 5.5, effort high.

**Skills, said in your first steps:**
- `leorna`: Doing a story → step 7 "make a PR", sub-steps 1–7, and 9 for the post rule. Read its memory notes `stop-and-show-diff.md` and `clickup-evidence.md`.
- `git-commit-rules`
- `github`
- `engineering-best-practices`

## Justin's words (2026-11-11, verbatim)
"do not mention AC8 post a pr and then post flickup"

What this authorizes:
- **"make a PR":** push the branch and open the PR. Never merge.
- **"post":** under the `leorna` rule (step 7.9, Justin 2026-11-08), the ClickUp comment is posted **only once the PR is merged**. The main session posts it then. **You don't post, upload or write to ClickUp.**
- **"do not mention AC8":** take AC8 out of everything that goes out:
  - the PR text
  - the ClickUp comment draft
  - the team message
  - the review prompt
  - the `PROJECT_MEMORY.md` line
  - the repo's `README.md` AC table row at line 685: `| AC8 (live), clean Windows VM with the GitHub tile | manual checklist in the plan (owed) |`

  Don't claim AC8, or the live clean-VM run, passed or was verified, and don't write "7 of 8". The AC tables list AC1–AC7 with their results. Also drop the related "unverified until AC8" or "owed" wording. Where a risk line only said something was unproven until AC8, keep the risk and drop the AC8 reference.

## State
- **Worktree:** `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`
- **Branch:** `feat/86bcm928h-per-user-credentials`
- **Accepted head:** `0af447184c884a7e6d74efb4fb98909143e8d2d3`. `ac-check.sh --reviews` printed READY FOR THE USER and review-5 is clean. If HEAD differs, stop and report it.
- **GitHub main:** `a7839b3af664efcfa59eb1ed3fe276ec1262a4de`, already merged into the branch at a608c1d. If main has moved when you fetch, **stop before pushing** and report it. A new bring-in needs its own review.
- **Branch on GitHub:** none yet (404). Open PRs: #29 only, which trial-merges clean.
- **Drafts** (finisher 2) in `~/.hermes/cache/scratch/`:
  - `leorna-pr-86bcm928h-per-user-credentials.md`
  - `leorna-review-prompt-86bcm928h-per-user-credentials.md`
  - `leorna-clickup-86bcm928h.md`
  - `leorna-team-message-86bcm928h.md`
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm928h/`, including `verifier/`, `auditor/` and `follow-ups.md`.
- **The `PROJECT_MEMORY.md` line** drafted by finisher 2 is in its report, and in the PR text's notes. It goes under "What is in the merged code" and names the PR as `client PR #<n>`, as the existing lines do.

## The work, in order
1. **Fetch and pre-flight** (`leorna` 7.1–7.2):
   - Fetch main over HTTPS through gh, with the URL written out.
   - Check that the tree is clean.
   - Check that the branch's own commits (`HEAD ^7a83443 ^origin/main`) are by Justin Issa <justin@leorna.com> only, with no AI attribution lines.
   - `.github/` diff is empty.
   - `git merge-base HEAD origin/main` equals origin/main.
2. **Re-run the gates on 0af4471** (`leorna` 7.3). Use the same set as `gates-0af4471.txt`, with the toolchain from `~/.local/leorna-tools`:
   - make check
   - UI tests
   - lint and audit
   - gitleaks
   - Windows vet and build
   - the native Windows `./login` and `./application` tests with `LEORNA_TEST_SECURE_STORE=1`, run one binary at a time, test credentials only, with no "Leorna Client" entry in `cmdkey /list` afterwards

   Write `~/.hermes/plans/leorna/evidence/86bcm928h/gates-pr-0af4471.txt` with each gate's exit code. A 1 s timing test from main, `TestSyncEngineCancellationAfterSuccessPersistsPartialAndReturnsCause`, can fail under heavy load. Rerun it alone before you judge it.
3. **Edit the PR text** to remove AC8, as described above. Its Test Plan lists only what ran on 0af4471, and says main was brought in at a7839b3. Body only, no Title line.
4. **Push 0af4471** with `leorna` 7.6: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-client.git feat/86bcm928h-per-user-credentials:refs/heads/feat/86bcm928h-per-user-credentials`
   - Fetch it back into `refs/remotes/origin/feat/86bcm928h-per-user-credentials` and set the upstream.
   - Check that `HEAD` equals `origin/<branch>`.
   - `git-guard.sh` will ask Justin to approve the push. He said "make a PR", so the push is authorized.
5. **Open the PR** (`leorna` 7.7):
   - `gh pr list -R LeornaAI/leorna-client --head feat/86bcm928h-per-user-credentials --state all` must be empty.
   - Then: `gh pr create -R LeornaAI/leorna-client --base main --head feat/86bcm928h-per-user-credentials --title "feat(86bcm928h): per-user credentials for integrations on the engineer's laptop" --body-file <the PR text>`
   - Read it back with `gh pr view <n> --json number,url,state,isDraft,headRefOid,mergeable,mergeStateStatus` and `gh pr checks`.
6. **Make the record commit locally, and don't push it.**
   - Add the `PROJECT_MEMORY.md` line with `client PR #<n>`, with no AC8 wording.
   - Delete the README.md AC8 row.
   - Commit with `git commit -m "docs(86bcm928h): record per-user integration credentials (client PR #<n>)"`: plain git, no author override, no AI lines.
   - **Don't push it.** A fresh review and the PR-head verification go first, and the main session pushes it afterwards.
   - Run `make check` and the UI tests on that commit and add them to the gate log.
7. **CI on the pushed head 0af4471:** wait for `gh pr checks` to finish. Use long-wait polling as below, and give up after about 25 minutes. Report each check's result. If a check fails, read its log with `gh run view --log-failed` and report it. Don't fix it.
8. **Update the other drafts** so they leave out AC8:
   - the ClickUp draft, marked "post after the PR is merged" with the PR number filled in
   - the team message
   - the review prompt

   Keep the image list as it is: AC1–AC7 from `auditor/`, all banner-free.
9. **Records:** update the dated 86bcm928h status line in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`:
   - PR #n opened at 0af4471
   - the record commit is local, waiting for review
   - CI result
   - the post is held until merge

   Set `modified:`. This dated story-status line is yours to write; the "never edit skills or memory" rule covers skills and lessons only.

## Rules
- Never merge, force-push, or change `.github/`. Never override author metadata. No AI attribution lines.
- Never print a token, a server domain or URL, or a tenant ID.
- Don't write to ClickUp.
- **Earlyoom:** a command that dies with exit 137 or 143, or "Killed", may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before you read it as pass or fail. If earlyoom killed it, rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, quoting env assignments.
- **Long waits:** don't end your turn to wait. Use `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` calls with the Bash timeout at 175000. For CI, use repeated `gh pr checks` with sleeps inside a single bounded command.
- **found_else / skill_lessons:** list other problems in `found_else`. Don't edit skills. List reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]`, where `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status, pr{number, url, head, state, mergeStateStatus}, pushed_head, record_commit{sha, files, pushed: false}, gates[{name, exit, log}], ci[{check, result}], drafts_updated[], ac8_removed_from[], records_updated[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
