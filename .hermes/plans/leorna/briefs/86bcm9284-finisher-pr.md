# Brief: 86bcm9284 PR finisher ("make a PR" + "post", this time only)

**Role:** FINISHER for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). You do the `leorna` skill's "Doing a story" step 7 (make a PR) in both repos, then the ClickUp "post".

## Justin's words (2026-11-09, verbatim)
> "nah that is fine just run the pr if there are no merge conflictsd / run up the pr and do the clickup post / just for this time"

He was told that both GitHub mains had moved overnight and that a full re-check (bring main in, review, verifier, auditor) would run. He declined it for this story, this one time. So:
- **Don't** merge main into the branches and **don't** re-run the full gate suite locally. The heads stay as reviewed and verified: control plane `9b61ff056d191edb060ed60cd3d325d7f4ebd483`, client `6d3c3c5fc6e49698004fa18f9f93c35f0d743ba8`.
- **Do** stop if a merge conflict appears. The main session checked at 2026-11-09 that `git merge-tree` is clean in both repos against control-plane main `8c85050` and client main `7a1f42d`. Recheck right before pushing: if either main moved again and now conflicts, stop and report without pushing.
- **This authorizes only:** pushing these two branches, opening one PR in each repo, and the ClickUp closing comment plus image attachments on card 86bcm9284. Never merge. Never change the card's status or checkboxes. Don't send the team message (that's after merge). Don't send the Christian or Zayd messages (Justin sends those).

## State
- **Control plane:** worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`, branch `feat/86bcm9284-predefined-integration-tiles`. Head `9b61ff0`, made of the story commits, plus merge `cb9dcb0` of main `dadba89`, plus fix `9b61ff0`.
  - Full review round 2 was clean.
  - Verifier 2 and blind auditor 2 both ran on `9b61ff0`, and `ac-check.sh --reviews` printed READY FOR THE USER: AC1, AC3, AC4 and AC5 accepted, AC2 (live) owed.
  - Receipts: `~/.hermes/plans/leorna/evidence/86bcm9284/verifier/` (gates `gates-9b61ff0-*`, AC logs and PNGs) and `auditor/`.
- **Client:** worktree `/home/justin/Leorna/86bcm9284-client-tile-fixtures`, branch `feat/86bcm9284-predefined-integration-tiles`, head `6d3c3c5`.
  - 4 test-fixture files. Review 1 was clean. Verifier 2's client gates are in `verifier/client-6d3c3c5-*`.
- **AC2 live:** `ac2-live-route/run-ac2-live.sh`. On `9b61ff0`, both the verifier and the auditor got 7/9 ok, 0 failed. Checks 6 and 7 (ClickUp in Codex and in Cursor) were `# TODO`, waiting on Justin's sign-in. **Justin has now completed `signin-clickup.sh`**: Codex and Cursor both logged in to ClickUp (`~/.cache/86bcm9284-ac2-signin` exists).
  - Rulings in `ac2-live-route/justin-rulings.md`: the Codex stand-in model counts as live.
  - Cursor's GitHub check reaches only `tools/list` (no Cursor account), so that part stays NOT VERIFIED unless the run shows otherwise.
  - Google's part is deferred (Q3 A).
- **Hand-over drafts** in `~/.hermes/plans/leorna/evidence/86bcm9284/handover/` were written for the old head `beb5358`: `pr-control-plane.md`, `pr-client.md`, `clickup-evidence.md`, `follow-ups.md`. Refresh them.

## Skills to load
`leorna` (step 7, step 4b's finisher, evidence and ClickUp rules, `clickup-evidence.md`, `stop-and-show-diff.md`), `git-commit-rules`, `github`. ClickUp tools: load them with ToolSearch (`mcp__clickup__clickup_request_attachment_upload`, `mcp__clickup__clickup_create_task_comment`, `mcp__clickup__clickup_get_task`, `mcp__clickup__clickup_get_task_comments`).

## Do, in order
1. **Fresh mains and conflicts.** Fetch both mains over HTTPS via gh (the leorna skill's command; never put the URL in a shell variable) and record the SHAs. `git merge-tree --write-tree --name-only HEAD origin/main` must exit 0 in both repos, or stop. Also list open PRs in both repos and merge-tree any sibling PR's head (fetched as `pull/<n>/head`, after checking `FETCH_HEAD` equals `headRefOid`).
2. **Pre-flight (step 7.2), read-only:**
   - `git status --porcelain` is empty in both repos.
   - The branch-only commits (`git log --format='%an <%ae>' HEAD ^origin/main`) all have the identity `Justin Issa <justin@leorna.com>`. Print only "authors: Leorna OK", never the address.
   - No commit body matches `^co-authored-by:|generated with|noreply@anthropic|🤖` (case-insensitive).
   - `.github/` changes: none.
   - CLAUDE.md is not in the diff.
   - `delivery/stories.json`: this story's entry is last and main's entries are unchanged. Judge it against current main by value, reading main's file via `git show origin/main:delivery/stories.json`. If main added entries after this story's, the merge-tree is still clean, so say so in the PR Assumptions.
3. **One AC2 live run** on `9b61ff0`:
   ```
   run-ac2-live.sh --head 9b61ff056d191edb060ed60cd3d325d7f4ebd483 --out ~/.hermes/plans/leorna/evidence/86bcm9284/finisher-pr/ac2-live --work ~/.cache/86bcm9284-finisher-pr/ac2-live
   ```
   It should now run checks 6 and 7 for real. Open every log and check the PNGs. This is a single supporting run by the finisher, not the independent verifier and auditor proof: label it that way in the PR and the ClickUp comment.
4. **PR texts** (Christian's plain style, body only, no `Title:` line). Write `handover/pr-client.md` and `handover/pr-control-plane.md` fresh for these heads:
   - **Test Plan:** list what ran on exactly these heads: verifier 2 and auditor 2 on `9b61ff0`, client gates on `6d3c3c5`, your AC2 live run. Say plainly that main moved after verification (control plane `dadba89` → `8c85050`, client `7a83443` → `7a1f42d`), that merge-tree is clean, that main was not merged in and the local gates were not re-run on the combination (Justin's call), and that CI runs on GitHub's test merge.
   - **AC2:** which live checks are proven, and what stays NOT VERIFIED (Cursor tool call, Google).
   - **Control-plane PR:** say "merge the client PR first" and link it. Note that `SOURCE.md` pins client commit `6d3c3c5`, and that after the client merge a one-line re-pin commit follows (owed, with its own review).
   - Include the ClickUp link, security, migration and rollback notes, and an Evidence block.
   - Name other stories by title or PR number, never by bare card ID.
5. **Push and open, client first** (step 7.6–7.7). Justin's guard (`git-guard.sh`) may ask before each Leorna push; that's expected.
   - Push with `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-client.git feat/86bcm9284-predefined-integration-tiles:refs/heads/feat/86bcm9284-predefined-integration-tiles`.
   - Fetch it back into `refs/remotes/origin/<branch>`, run `--set-upstream-to`, and check that `rev-parse HEAD origin/<branch>` match.
   - `gh pr list --head <branch> --state all` must be empty. Then `gh pr create -R LeornaAI/leorna-client --base main --head <branch> --title "test(86bcm9284): pin the GitHub Enterprise Server image in the integration fixtures" --body-file <pr-client.md>`.
   - Then the control plane, the same way, with the title `feat(86bcm9284): predefined integration tiles for GitHub, Google Workspace and ClickUp`. Put the client PR's number and URL into its body first.
   - Read both back with `gh pr view … --json number,url,state,isDraft,headRefOid,mergeable` and `gh pr checks`.
   - If a push is refused (a permission prompt is denied or auto-refused), stop and report exactly which command was refused. Don't retry another way.
6. **CI:** wait for both PRs' checks to finish. Control-plane CI takes about 15 minutes; poll `gh pr checks` sparingly. Report each check's result. If a check fails, read its log (`gh run view --log-failed`) and report the cause. Don't fix it, and don't push again.
7. **stories.json PR numbers (step 7.8):** make the small commit adding both PR numbers to this story's entry, as text, and prove it by value. **Do not push it**: pushing it would cancel CI on the reviewed head, and Justin pushes it on his word. Report it.
8. **ClickUp post on card 86bcm9284** (`clickup-evidence.md` format, step 7.9, images only):
   - **Comment:** WHAT WAS DONE / WHAT WAS VERIFIED, with an AC → test → result table. Include the gates, both PR links and CI status, the AC2 live results (including your run's checks 6 and 7), and a NOT VERIFIED list (Cursor GitHub tool call, Google's part, and the follow-ups). Say it isn't merged yet.
   - **Attachments:** pick the images from the verifier 2 and auditor 2 folders for head `9b61ff0`, plus your live-run PNGs.
     - Before anything leaves the machine, inspect every image yourself. It must show no server domain, URL bar, tenant ID, token, email, team UUID or DB URL. Leave out any that do.
     - Never upload a `.log` or `.txt`.
     - Request one upload ticket per file, right before uploading it, with readable `file_name`s like `ac1-first-three.png`.
   - Read the card back with attachments (titles and sizes against the local byte counts) and the comments. Never change the status.
9. **Memory:** don't edit memory or skills. Put story facts in your report.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Scratch goes in a fresh `~/.cache/86bcm9284-finisher-pr/`, never `/tmp`; remove it at the end. Never print a token.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
- Both mains and the merge-tree results.
- Both PR numbers and URLs, with their `headRefOid` and CI results.
- The AC2 live TAP lines.
- The ClickUp comment ID and the attachment list, read back.
- The unpushed stories.json commit SHA.
- Anything refused or left undone, and what Justin does next: merge client first, then the `SOURCE.md` re-pin and its review, then the control plane, then the team message.
- `ac_status` per AC, and skill_lessons.

End with `MAIN SESSION: check and save these skill_lessons now.`
