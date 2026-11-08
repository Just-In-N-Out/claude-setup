# FINISHER brief: 86bcm928t integration governance and usage (hand-over only)

Role: FINISHER. You are a fresh general-purpose agent (Opus 5.5, high effort).
Do the Leorna hand-over (`leorna` skill, Doing a story step 6, plus step 5's stop-and-show).
**Hand-over only:**
- Don't push, open a PR, post to ClickUp, or merge. Justin hasn't said "push", "make a PR" or "post".
- Start no other agents.

## State (checked by the main session)
- Worktree: `/home/justin/Leorna/86bcm928t-integration-governance-usage`, branch `feat/86bcm928t-integration-governance-usage`.
- Head: `9276c33966aea25c8227ca3efe56a1bdb203012e`. Base: `f0a326b83aae9d181e4f6681645685ae4b1fff91` (GitHub main when built).
- `ac-check.sh --reviews` printed **`ALL ACCEPTED: 3 of 3 ACs on 9276c33`**:
  - review-1 (full) is clean, with 3 P3s;
  - the verifier is clean;
  - the blind auditor is clean.
  - There are no `(live)` ACs.
- Evidence: `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/`.

| Item | Path (under the evidence folder) |
|---|---|
| Approved plan | `plan-approved.md` |
| Builder evidence | `builder/` |
| Review | `review-1/review.json` |
| Verifier report | `verifier/ac.json`, gates in `verifier/gates-9276c33*` |
| Auditor report | `auditor/ac.json`, screenshots in `auditor/screenshots/` |
| Follow-ups | `follow-ups.md`: P3 R1-1..R1-3, plus 2 verifier notes |

- Plan follow-ups and found_else (F1–F4 and the P3s) are in the plan's "Follow-ups" and "Other things found" sections.
- Gate notes:
  - The verifier's first `make check` failed one load-sensitive timing test that this story doesn't touch (`TestQuickStartPickIsBoundedAndReleasesTheLockWithPostgres`, 4.27 s against a 4 s limit at load 20–27). Alone it passed 3/3, and the unchanged `make check` rerun passed. Report both runs honestly in the Test Plan.
  - The builder's gates all passed on 9276c33.

## Skills: load each with the Skill tool and say so in one line
`leorna` (FINISHER role), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`. Read the shared memory notes the `leorna` skill names for finishing:
- `stop-and-show-diff.md`
- `review-prompt-for-agent.md`
- `story-done-team-message.md`
- `clickup-evidence.md`
- `justin-profile.md`
- `~/Leorna/leorna-control-plane/delivery/README.md`

## Do
1. **Don't change the branch.** No new commit unless one is truly required. If something must change (a real defect, or a record the hand-over needs in the repo), stop and report it instead of committing: any new commit needs a fresh review and re-verification. The P3 follow-ups are not to be fixed here.
2. **Main and sibling checks, read only:**
   - Read GitHub main with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`, then fetch over HTTPS through gh with the exact `leorna` step 7.1 command.
   - If main moved past `f0a326b`, run `git merge-tree --write-tree --name-only HEAD origin/main` and report the result. Don't bring main in: that waits for Justin's OK together with "make a PR".
   - List open PRs (`gh pr list -R LeornaAI/leorna-control-plane --state open`). For each, merge-tree against this head.
   - Note the known overlap risks: 86bcm9284 (`internal/integration/README.md`, `stories.json`) and 86bccndx6 (`stories.json`; its canonical-host check, so AC1 must be re-run after bringing it in).
   - Check the migration-number duplicate rule (no migration here).
   - Grep the tracked tree for this card ID next to until/once/later wording (`leorna` step 7.2).
3. **Stop-and-show:**
   - `git diff --stat origin/main...HEAD` (three dots), using the base if main moved.
   - The key hunks.
   - `.github/` paths, which must be none.
   - Commit authors: every one must be Justin's Leorna identity, with no AI attribution lines. Print the check's result, never the address.
4. **Write the hand-over files** into `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/handover/`:
   - **`pr-body.md`**: the PR body only, no `Title:` line. Use Christian's plain style:
     - a Summary paragraph and one line per file or area;
     - a Test Plan listing only what ran on head 9276c33, citing the log paths;
     - a short Assumptions list (the ⭐ answers to Q1–Q4, AC2's "Not measurable" scope, the follow-ups);
     - the ClickUp link;
     - security, migration and rollback notes;
     - an Evidence block with the head SHA. The CI run is pending until a push.
     - Name other stories by PR number or title, never by bare card ID.
     - Also write the suggested title on its own in `pr-title.txt`.
   - **`review-prompt.md`**: a self-contained review prompt for a fresh agent, in the `review-prompt-for-agent.md` format.
   - **`clickup-comment.md`**: the closing-comment draft in `clickup-evidence.md` format.
     - WHAT WAS DONE.
     - WHAT WAS VERIFIED, with an AC → test → result table.
     - Gates.
     - CI pending.
     - Mark the merge facts as pending.
   - **`attachments.txt`**: the attachment list. Images only, one per AC at least, chosen from the verifier's or auditor's screenshots. Before listing a PNG, open it and check it shows what it claims, with no domain, URL bar, tenant ID, token or email (UUIDs redacted). A log becomes a screenshot of the log, never a `.txt`.
   - **`team-message.md`**: a short team message draft (`story-done-team-message.md`), to send after merge.
   - **`hand-over.md`**: one page for Justin.
     - Lead with one line saying it's ready for him to say "make a PR".
     - The diff stat.
     - Gates.
     - AC table.
     - Follow-ups.
     - Sibling and merge-tree results.
     - What he must say next ("push", "make a PR", "post").
5. **Clean up:**
   - Stop and remove the builder's containers `928t-builder-pg` and `928t-builder-ch` (the builder left them for the review roles; all are done). Check with `docker ps -a --filter name=928t-` first, and touch only those two.
   - Remove `~/.cache/86bcm928t-builder/` after copying any script the evidence still lacks into `builder/` as `.txt`.
   - Leave the worktree and branch in place.
6. **Story state:** add a dated status line for 86bcm928t to `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`, covering head, ALL ACCEPTED, hand-over ready, not pushed, and the follow-ups. Update the existing line rather than adding a duplicate.

## Windows desktop: runaway memory
A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

## Report
- Return:
  - `status` (`ready` or the precise remaining stage)
  - `head_sha`, and `main_sha` as read
  - `merge_tree` results, both against main and against siblings
  - the `handover_files[]` paths
  - `diffstat`
  - `found_else[]`
  - `skill_lessons[]`
- If you find another bug, don't fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable, don't edit any skill or memory file, apart from the `leorna-workflow.md` status line above. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section.
  - `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: kind, what it checks, where it runs.
  - An empty list is normal.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls under 3 minutes each.
- End with `MAIN SESSION: check and save these skill_lessons now.`
