---
name: clickup-evidence
description: "Every finished story gets an evidence comment plus screenshots on its ClickUp card, posted through the ClickUp connector when Justin says \"post\""
metadata:
  node_type: memory
  type: feedback
  originSessionId: hermes
  modified: 2026-10-29T00:02:00.000Z
---

Every story Justin finishes gets **evidence on its ClickUp card**. The evidence is a closing comment plus attached screenshots (gate output included, as screenshots), written so a lead can accept the card without asking.

**Why:** at Sprint 5 close (2026-10-18), Christian wrote the closing summaries for Justin's and Yan's stories himself (e.g. 86bbu3xg8, 86bbu3xhy). Each one ended with "Not recorded: a live/manual run against a real install is not documented in the PR — verification above is tests + CI." On 2026-10-22 he told the team: "Guys, make sure you add enough evidence next time." Justin asked for this to become part of the workflow, including photos through the ClickUp MCP.

**How to apply:**

1. **Collect while building, not at the end.** The builder (or whoever runs the story) saves evidence in `~/.hermes/plans/leorna/evidence/<clickup-id>/`:
   - **Every acceptance criterion gets at least one screenshot (Justin, 2026-10-23: "take a screenshot for each AC because we are going to upload to clickup").** A criterion with nothing visual (a CI/CLI check) gets a real terminal-window capture of its run showing the command, output and exit code, taken as it runs and never rebuilt from a log afterwards. Retake it on the final head if a fix changes the output.
   - **One screenshot per acceptance criterion that has something visible:** the desktop app panel or result, the admin console page, or terminal output of a real tool run. Desktop: `screencapture -x -o -l <windowid>` (one window) or `screencapture -x -R <x,y,w,h>`. Browser: `capture_screenshot()`. Name them `ac<n>-<what>.png`.
   - **Gate output:** `make check`, UI tests, `make lint audit`, and for the control plane `scripts/test-module-add.sh`. Keep the logs locally as `gates-<sha7>.txt` (receipts), but **never upload `.log` or `.txt` log files to ClickUp: attach a screenshot of the log instead** (Justin, 2026-10-24: "it should not upload .log files to clickup rather take a photo of the log file"). Open the log in a Terminal window, scroll to the part that proves the result (the command, the pass lines and the `EXIT=` line), capture it with the step 4b recipe, and name it `gates-<sha7>.png`. Use more than one capture if the proof doesn't fit one screen.
   - **The live/manual run:** the step Christian marks "Not recorded". Run the feature once for real (real Claude Code/Codex, the real desktop app, or Justin's own server, following [[live-server-testing]]) and screenshot the result. If no live run is possible (e.g. no server), the comment says why under NOT VERIFIED.
2. **Privacy check before anything leaves the Mac.** ClickUp is shared with the team. Look at every screenshot (vision) before upload. No server domain, URL bar, tenant ID, token, email or `/dev/login` may be visible: crop or retake. Refer to servers by install date ([[live-server-testing]]). Gate logs must not contain secrets or domains either.
3. **Draft the comment with the hand-over**, next to the PR text and team message (Christian's format, plus the live run):

   ```
   ✅ Closing evidence — <card title> (<clickup-id>)

   WHAT WAS DONE
   - <repo> PR #<n> (merged <date>, merge <sha7>, +<add>/-<del>, <N> files): <one plain line>.

   WHAT WAS VERIFIED
   | Acceptance criterion | Test / evidence | Result |
   | --- | --- | --- |
   | Given … when … then … | `TestName` + ac1-….png | ✅ |
   - Gates on <sha7>: make check ✅ · UI tests <n>/<n> ✅ · lint 0 ✅ · audit ✅ (gates-<sha7>.png)
   - CI on merge: Go quality gates ✅ · Windows client executable ✅ · Clean Windows tool installation ✅ — <Actions run URL>
   - Live run (<date>, <what was run, e.g. real Codex 0.163 / Justin's server from <install date>>): <what was seen> — screenshots attached.

   NOT VERIFIED
   - <honest list, or "nothing left">
   ```

4. **Post only when Justin says "post"** (usually right after merge, before he moves the card on). Steps:
   - `CLICKUP_REQUEST_ATTACHMENT_UPLOAD(task_id, file_name)` for each local file, then upload it as the returned instructions say (`curl` with the returned URL, method and multipart field). Small files (<200 KB) can go through `CLICKUP_ATTACH_TASK_FILE` with base64 instead.
   - `CLICKUP_CREATE_COMMENT(entity_type=task, entity_id=<id>, comment_text=<markdown>)`. The comment names the attached files; attachments show on the card, not inline in the comment. Reading it back, `clickup_get_task_comments` returns `comment_text` as plain text (bullets, backticks and table pipes stripped; a table's last cell runs into the next line), so compare it with the draft word by word, not as a byte diff (86bcm901a).
   - Read it back: `CLICKUP_GET_TASK(include=[attachments])` lists every file, and `CLICKUP_GET_TASK_COMMENTS` shows the comment. Report the card link.
   - Justin still changes the status himself. Never tick acceptance checkboxes or move the card.
5. **Upload path proven 2026-10-24 (Claude Code, 901v-v3, 8 files, all HTTP 200):** `clickup_request_attachment_upload(task_id, file_name)` returns `upload_url` `https://mcp.clickup.com/upload`, a ticket valid about 3 minutes and multipart field `attachment`; upload with `curl -sS -X POST <upload_url> -H 'X-Upload-Ticket: <ticket>' -F 'attachment=@<path>;filename=<name>;type=<mime>'` → JSON `{id, title, url}`. Request the tickets together, then upload inside the 3 minutes. In a subagent, Claude Code's auto-mode classifier can deny an upload ticket as an "External System Write" even after Justin said "post" in the main chat (901v v3 re-post, 2026-10-24: 1 of 7 identical requests denied): get every ticket before the first `curl`, stop on any denial so the card never gets a partial set, and surface it to Justin rather than routing around it. Running the post in the main session after he chose that worked: 7 of 7 tickets granted, uploaded, comment updated in place with `clickup_update_comment`. The denial is intermittent, not systematic: a background finisher subagent got 7 of 7 tickets in one parallel batch and uploaded them in 23 s (86bcm901b post, 2026-10-28), so keep dispatching "post" to a finisher and fall back to the main session only after a denial. Use this route for small files too (`attach_task_file` needs the bytes inline as base64). Comment with `clickup_create_comment(entity_type=task, entity_id=…)` (returns `comment_id`); `clickup_create_task_comment` is deprecated. Read back with `clickup_get_task include=[attachments]` (titles + sizes) and the comments tool. The connector has **no attachment delete** (only `clickup_delete_comment`; checked 2026-10-24): when evidence is replaced, give the new files a head-SHA suffix and list the old ones (title + ID) for Justin to delete in the ClickUp UI.

Related: [[story-done-team-message]], [[stop-and-show-diff]], [[live-server-testing]], [[leorna-workflow]].
