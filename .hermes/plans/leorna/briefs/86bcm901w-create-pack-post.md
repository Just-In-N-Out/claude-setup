
# FINISHER ("post" the ClickUp closing evidence) — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: the FINISHER for the `leorna` skill's Doing a story → step 7.8 (after merge) and 7.9 ("post"). Post the closing evidence comment and the screenshots to ClickUp card **86bcm901w**, read them back, and report. **Never change the card's status, assignees or checkboxes.** No team message (Justin hasn't asked for it). No pushes, no PR edits, no code changes.

## Justin's words (2026-10-29)
> Okay PR merged, do the ClickUp thing. Let me know once that's done.

The main session had offered "post" for the ClickUp evidence; this is that "post". It covers the closing comment and its image attachments on card 86bcm901w only.

## Facts (checked by the main session just now)
- **PR #96** (`LeornaAI/leorna-control-plane`) **MERGED** 2026-10-29T07:02:18Z by `Justin-Leorna`, merge commit **`6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`**. The PR's head was **`5a9aa2f6c4c219234b49d9f9bd17e83942790437`** (the story merged with main `a8d1465` after #95, #94 and #97). PR CI run 40804136869 on `5a9aa2f`: all 3 jobs passed.
- **Main's push CI** on `6c1709e`: run **40832867438**, `in_progress` at dispatch. Wait for it in the foreground (bounded poll, loops of about 2 minutes, up to about 25 minutes) with `gh run view 40832867438 -R LeornaAI/leorna-control-plane --json status,conclusion,jobs,url`. If it fails, **stop before posting** and report the failing job and step.
- **Acceptance:** `ac-check.sh` printed `ALL ACCEPTED: 4 of 4 ACs on 5a9aa2f` (base `a8d1465`), from a fresh verifier (`~/.hermes/plans/leorna/evidence/86bcm901w/verifier-5a9aa2f/`) and a blind auditor (`…/auditor-5a9aa2f/`, 20 overlay mutants all killed by the AC tests). Earlier: ALL ACCEPTED on `8a50486` (verifier 39/39 mutants, auditor 15/15) and on `5e29c56`. The story's own files in `5a9aa2f` are byte-identical to `5e29c56` outside the four both-sides merge files (`verifier-5a9aa2f/merge-check-5a9aa2f.txt`).
- **Draft:** `~/.hermes/plans/leorna/86bcm901w-handover/clickup-evidence.md` (written for `8a50486`; its "How to post" section is the procedure). The ACs' wording and the comment format stay; the facts must be brought up to the merged head.

## Steps
1. Load skills (below). Read the draft, `clickup-evidence.md` in the `leorna` skill's references (the format), and the `leorna` skill's step 7.9 text and Upload line (images only; never a `.log`/`.txt`; one ticket per file; read back sizes).
2. **Wait for main's CI** (above). Record each job's result and the run URL.
3. **After-merge check:** from the main checkout (read-only; it's on `main` — fetch GitHub `main` over HTTPS through gh first: `git -C ~/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`; don't change the main checkout's branch or files), run `python3 scripts/check-story-shippable.py 86bcm901w` in a detached scratch copy at `origin/main` (or `git -C` into a `git worktree add --detach` copy you remove afterwards) once main's CI has finished, and report what it says. It's information for the comment ("story shippable: …"), not a gate for posting unless it names a real problem.
4. **Bring the comment up to date** (write it to `~/.hermes/plans/leorna/86bcm901w-handover/clickup-comment-posted.md` first):
   - WHAT WAS DONE: PR #96, merged 2026-10-29, merge `6c1709e`; the PR's net size from `git diff --shortstat a8d1465 5a9aa2f` and files count (recompute; don't reuse +6713/-1420 unless it matches).
   - WHAT WAS VERIFIED: the same AC → test → result table with the screenshot file names you upload; each AC test fails on main before the story (build failure); gates on `5a9aa2f` from the verifier's `verifier-5a9aa2f/SUMMARY-gates-5a9aa2f.txt` (read it; quote numbers only from files you read); mutation: auditor on `5a9aa2f` 20/20, verifier on `8a50486` 39/39 (story files unchanged since); CI: the PR run on `5a9aa2f` and main's push run on `6c1709e` with results and URLs (Actions URLs on github.com are fine; no server domain); story-shippable result; live run: none needed (no live AC), demo on a throwaway local database with a binary built at `5a9aa2f`.
   - NOT VERIFIED: what's true (nothing for AC1–AC4 unless you find otherwise).
   - No server domain, server URL, tenant ID, token, email or `/dev/login` anywhere in the comment.
5. **Pick the images** (images only, PNG): one per AC from the **5a9aa2f** runs — prefer the blind auditor's `auditor-5a9aa2f/ac1-new-pack-version-1.png`, `ac2-pack-version-2.png`, `ac3-audit-history.png`, `ac4-refused-saves-log.png`; use the verifier's `verifier-5a9aa2f/` captures instead for any that fail inspection. Plus one gates image: render the verifier's `verifier-5a9aa2f/gates-make-check-5a9aa2f.txt` (ANSI stripped, `<pre>` page, headless Chrome for Testing per `ac-verification.md`'s Chrome paragraph, scratch `--user-data-dir`) to `~/.hermes/plans/leorna/86bcm901w-handover/gates-5a9aa2f.png`, labelled as a rendering of that log. **Open and inspect every image yourself** before uploading (tall ones in bands of ≤2,000 px; Read scales them down): nothing private on screen (no URL bar, server domain, tenant ID, token, email, `/dev/login`, DB password). Record each file's bytes and pixel size. Upload names: `ac<n>-<what>-5a9aa2f.png`, `gates-5a9aa2f.png`.
6. **Post** per the draft's "How to post": request every upload ticket first (`mcp__clickup__clickup_request_attachment_upload`, task `86bcm901w`, one per file; load the tool with ToolSearch `select:` first), then `curl` each multipart POST; if any ticket is denied, **stop before the first curl** and report (the main session posts instead). Then the comment with `mcp__clickup__clickup_create_comment` (entity task `86bcm901w`).
7. **Read back:** `mcp__clickup__clickup_get_task` with attachments — each title and `size` equals the local bytes, nothing extra from this run; the comments tool — your comment is there, text as written. A wrong upload can't be deleted by API: upload the right file and name the wrong one in your report for Justin to delete by hand.
8. Update `clickup-evidence.md`'s header to say it was posted (date, comment id, attachment titles). Remove any scratch you made.

## Rules
- Card **86bcm901w** only. Never touch other cards. Never change status, assignees, checkboxes, tags or dates. No team message, no WhatsApp, no other ClickUp writes.
- Never send a `.log`, `.txt` or `.json`; never a server domain, URL (other than github.com Actions/PR links), tenant ID or token.
- Sibling stories' evidence and worktrees: read nothing you don't need, change nothing. Never touch `leorna-pg` (5432).
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.
- You can't ask Justin anything and can't start agents.

## Skills
Load, in this order, and say so in your first steps: `leorna` (FINISHER, step 7.8–7.9; skip its Step 1 load), `github`. Any skill step that says "spawn a subagent" is the main session's job.

## Output (your final message)
`{status: "posted" | "stopped", main_ci: {run, url, jobs[{name, result}]}, story_shippable, comment: {id, path_of_text}, attachments[{title, local_path, bytes, clickup_size, match}], card_status_unchanged: true|false, stop_reason, found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
