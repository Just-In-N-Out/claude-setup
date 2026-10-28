# FINISHER ("post") brief: 86bcm901b-prompts-collection [leorna]

**Role:** FINISHER doing **"post"** for the Leorna story "86bcm901b-prompts-collection" (ClickUp [Curate the reusable prompts collection](https://app.clickup.com/t/86bcm901b), card `86bcm901b`): the `leorna` skill's step 7.9. Upload the evidence screenshots to the card and add the closing comment, then read both back. You are fresh.

**Justin's words (2026-10-28, voice note):** "Okay, I already merged the PR, it's fine, we don't have to do the stories, Jason. What I want you to do though is put Go on ClickUp, and I think that's about it, right?" The main session reads this as: PR #95 merged; **skip the `stories.json` PR-number commit** (local `1c1d276` stays unpushed; don't push it); **"post"** the ClickUp evidence. "Post" authorizes only the evidence comment plus image attachments on card `86bcm901b`. **Never change the card's status, checkboxes, assignees, tags or fields**, and never write to any other card.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`).

## Skills to load first (say so in your first steps)

1. `leorna` (FINISHER; its "Reading ClickUp" rules, step 4b's evidence and upload rules, step 7.9; and the memory note `clickup-evidence.md` it names, for the comment format and the upload recipe).
2. `engineering-best-practices`.

The ClickUp tools are deferred in Claude Code: load them with ToolSearch first (`select:mcp__clickup__clickup_get_task,mcp__clickup__clickup_request_attachment_upload,mcp__clickup__clickup_attach_task_file,mcp__clickup__clickup_create_task_comment,mcp__clickup__clickup_get_task_comments`).

## Facts (main session checked with `gh`, 2026-10-28)

- **PR #95** https://github.com/LeornaAI/leorna-control-plane/pull/95 "feat(86bcm901b): curate the reusable prompts collection": **MERGED** at 2026-10-28T23:45:16Z by Justin-Leorna, merge commit **`db3406e`**, PR head `63afe55`.
- PR CI run **40786509569**: success ("Go quality gates" 7m23s, image publish and admin-portal packaging passed with push/upload skipped on the PR).
- `main` CI run **40789520002** on `db3406e` was **in progress** at 23:45:19Z. Re-read it (`gh run view 40789520002 -R LeornaAI/leorna-control-plane --json status,conclusion,url`). If it has finished, put its result in the comment. If it's still running, wait in bounded polls of under 3 minutes each, for up to about 15 minutes in total (Claude Code moves longer foreground commands to the background). If it's still not done, say "main CI running" in the comment and report it.
- AC1–AC4 accepted by an independent verifier and a blind auditor (`ac-check.sh` READY FOR THE USER on `63afe55`); **AC5 (live) accepted by Justin** on 2026-10-28 from an agent-run interactive Claude Code session; the `/spec` gap (it asked only about stack and features) is recorded.

## Steps

1. Read the card (`clickup_get_task`, `86bcm901b`, include attachments) to see what's already attached, so nothing is uploaded twice.
2. Start from the draft `~/.hermes/plans/leorna/evidence/86bcm901b/handover/clickup-comment.md`. Fill in the merge facts: PR #95 link, merged, merge commit `db3406e`, PR CI run 40786509569 success, and the main CI run result. Keep the AC → test → result table, the AC5 row with its gap line, and the format `clickup-evidence.md` asks for. No server domain, URL bar, tenant ID, token, DB URL or email anywhere. GitHub PR and Actions links are fine. Save the final text as `handover/clickup-comment-posted.md`, leaving the draft as it is.
3. **Images only:** upload exactly the image files the draft's attachment list names (7: the AC1–AC4 and gates `*-63afe55.png` from `evidence/86bcm901b/`, plus `ac5-run/ac5-review.png` and `ac5-run/ac5-spec.png`). Never upload a `.log`, `.txt` or `.json`. **Open and look at every image yourself before uploading it** (no URL bar, domain, tenant ID, token, DB URL, password or email). If one fails that check, leave it out and report it. Give each a clear `file_name` (e.g. `86bcm901b-ac1-third-party-content.png`).
   - Upload recipe (from `clickup-evidence.md` / the leorna skill): request one upload ticket per file right before uploading it (tickets expire within minutes) with `clickup_request_attachment_upload`, then do the multipart POST it describes with `curl`; files under 200 KB may use `clickup_attach_task_file` instead. Never print tokens or ticket secrets in your logs or report.
4. Post the comment with `clickup_create_task_comment` on `86bcm901b`.
5. **Read back:** `clickup_get_task` with attachments: compare the attached titles and each `size` with the local byte counts and the intended list. Then `clickup_get_task_comments`: the new comment is there with the full text. ClickUp has no attachment-delete API: if an upload went wrong, upload the right file and tell Justin which attachment to delete by hand. Don't retry blindly.
6. Run `python3 scripts/check-story-shippable.py 86bcm901b` read-only on a fresh copy of GitHub `main` (fetch, then `git -C ~/Leorna/leorna-control-plane show origin/main:...` or a scratch `git archive` export; never touch the main checkout or any worktree). Report its output. It may pass vacuously because `main`'s `stories.json` doesn't list PR #95 (Justin skipped that commit): say so plainly.
7. Return the team message for Justin to send himself (`handover/team-message.md`, with the merge facts filled in). Don't send it anywhere.

## Boundaries

- No code, commit, push, merge, PR comment or PR change. Don't push `1c1d276`. Don't touch the story worktree, the main checkout's branch or files, or any sibling story.
- Write only `handover/clickup-comment-posted.md` and an upload receipt `handover/clickup-upload-receipt.txt` (titles, sizes, ids: no secrets) in the evidence folder.
- Scratch: `~/.cache/leorna-86bcm901b/post-work/` (create it and remove it at the end); `/tmp` is a small shared RAM disk.
- You can't ask Justin anything and can't start other agents. Claude Code refuses report files from subagents: return your report as your final message.
- Other problems: `found_else`. Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` (an empty list is normal) and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{status: posted|partial|stopped, comment_id, attachments[{file_name, local_bytes, clickup_size, ok}], main_ci{run, status, conclusion}, shippable_check, team_message, workflow_status_line, steps_for_justin[], stop_reason, found_else[], skill_lessons[]}`.
