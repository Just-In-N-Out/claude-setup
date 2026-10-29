# FINISHER ("post") — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FINISHER, a fresh agent. Justin merged PR #97 and said "ok merged go ahead with clickup" (2026-10-28). Earlier he asked: "just put it on ClickUp".

**You are approved for:** the `leorna` skill's step 7.9 "post", meaning the closing evidence comment plus the screenshots on ClickUp card **86bcm901a**, then reading them back. You also do the after-merge step 7.8 check.

**Never:**
- change the card's status, checkboxes, assignees or any field;
- push;
- commit;
- send the team message (draft it only).

## Facts
- **PR #97** `https://github.com/LeornaAI/leorna-control-plane/pull/97`.
  - State: MERGED by `Justin-Leorna` at 2026-10-29T01:18:10Z.
  - Merge commit `a8d14654fd5f93a6cdfb8858a091e1ae7f43d9ad`, which is now GitHub `main`.
  - PR head `829fa9cb4d0a64ee03e132ebba9de95870b9fb41`.
- **CI on the head:** run 40798043149 `https://github.com/LeornaAI/leorna-control-plane/actions/runs/40798043149`, success. All three checks passed: Go quality gates, Publish control-plane image, Package admin-portal distribution.
  - Also find whether a `push` run on `main` for `a8d1465` exists, and give its result (`gh run list -R LeornaAI/leorna-control-plane --branch main --limit 3`).
- **Acceptance on `829fa9c`** (round 3, after main was brought in twice):
  - round-3 verifier clean (`$EV/verifier/`);
  - round-3 blind auditor clean (`$EV/auditor/`);
  - `ac-check.sh`: `READY FOR THE USER: 4 of 5 ACs proven on 829fa9c` (`$EV/ac-check-829fa9c.txt`);
  - AC5 was accepted by Justin on `9c13e02` (`$EV/ac5-live/ACCEPTED.md`, `run-agent/RESULT.md`). The agent bodies are byte-identical at `829fa9c`.
- **Where the receipts are** (`$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a/`):
  - Earlier rounds: `$EV/round1-9c13e02/` and `$EV/round2-55abda3/`.
  - The gates on `829fa9c`: `$EV/gates-829fa9c.txt` and `$EV/verifier/gates-829fa9c/SUMMARY.txt`.
  - The push receipts: `$EV/push-829fa9c/`.
- **The existing draft is stale:** `$EV/hand-over/clickup-evidence.md` (and `INDEX.md`) was written for `9c13e02`. Its attach list points at `verifier/…-9c13e02.png` and `auditor/library-check-9c13e02.png`, which have since moved under `round1-9c13e02/`. It also says library 0.6.0, has no merge facts, and the CI line reads "after PR".

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FINISHER role; do its Step 1 context load; read `clickup-evidence.md` in the notes for the comment format and upload procedure), `github` (read-only `gh`).

## Steps
1. **Confirm the merge.** Run `gh pr view 97 --json state,mergeCommit,mergedAt`, then fetch `main` over HTTPS through gh (`leorna` step 7.1) and check it contains `a8d1465`.
   - The main checkout `~/Leorna/leorna-control-plane` is on `main` with no tracked changes. Fast-forward it with `git merge --ff-only origin/main`. If that refuses, leave it alone and report it.
2. **Run step 7.8's check on fresh main.** From the main checkout, run `python3 -B scripts/check-story-shippable.py 86bcm901a`.
   - First confirm the story's `stories.json` entry on main lists `[97]`, because an empty list passes vacuously.
   - Save the output to `$EV/post/check-story-shippable.txt`.
   - If it reports BLOCKED, say why. Don't fix anything.
3. **Refresh the ClickUp evidence draft** in `$EV/hand-over/clickup-evidence.md`, following the format in `clickup-evidence.md`.
   - **WHAT WAS DONE:** the 4 agents, the code-reviewer 2.0.0 / test-writer retired decisions, `--version`, and library **0.7.0**. Add one plain line on bringing main in after #95 and #94.
   - **WHAT WAS VERIFIED:** the AC → test → result table on `829fa9c`, with AC5 ✅ accepted by Justin.
   - **Gates:** the gates on `829fa9c`.
   - **CI:** the PR run URL and its result; the main run if there is one.
   - **Merge facts:** PR #97, merge commit `a8d1465`, merged 2026-10-29.
   - **NOT VERIFIED:** keep only the existing follow-up line (no tool installs agents yet).
   - Keep it short and plain. The only links allowed are GitHub and the ClickUp card: no server domain, tenant ID, token or email.
4. **The attach list.** Rebuild it from files that exist now, 14 or fewer, preferring the merged head's receipts:
   - AC1–AC4: round-3 `verifier/ac<n>-829fa9c.png`;
   - the round-3 auditor's `auditor/ac4-library-check-829fa9c.png`;
   - a gates image for `829fa9c`, if one exists. Otherwise render `verifier/gates-829fa9c/SUMMARY.txt` to a PNG in `$EV/post/` with Chrome for Testing, following `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, under `env -u DISPLAY -u WAYLAND_DISPLAY`;
   - the two demo captures `demo-library-agents.png` and `demo-third-party-agents.png`. Content is unchanged since `0ab7e6f`; say that in the comment;
   - the 5 AC5 images in `ac5-live/run-agent/`.

   **Privacy check:** open every image, and also grep each image's text source for emails, URLs, tokens and passwords. Never attach Claude Code session transcripts or anything from `~/.claude/projects/`. Use upload names prefixed `86bcm901a-`.
5. **Post.**
   - Upload each file to card `86bcm901a`. Files under 200 KB go through `clickup_attach_task_file`. Larger ones use `clickup_request_attachment_upload` and then the upload it describes. Load the ClickUp tools with ToolSearch first, if they're deferred.
   - Then add the comment with `clickup_create_task_comment` (or the comment tool the notes name).
   - Upload each file once. If an upload fails, retry that file only, and report it.
6. **Read it back:**
   - `clickup_get_task` with attachments: every file is present, with the right names and sizes;
   - `clickup_get_task_comments`: the comment is there, and its text matches your draft;
   - the card's status is unchanged from before you started (record it before posting).

   Save the read-back to `$EV/post/readback.txt`.
7. **Team message.** Refresh `$EV/hand-over/team-message.md` (`story-done-team-message.md` format) with PR #97, the merge commit and what shipped. **Draft only; don't send it.**

## Boundaries
- **Write only to:**
  - `$EV/post/`, created with `mkdir`, no `-p`;
  - `$EV/hand-over/clickup-evidence.md`, `team-message.md` and `INDEX.md`;
  - the ClickUp card 86bcm901a: attachments and one comment only;
  - small scratch in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-post/`, created with `mkdir`, no `-p`, and removed at the end.
- **Never touch:**
  - other cards;
  - other stories' files;
  - any branch or worktree. The main checkout gets the ff-only update and nothing else.
- **ClickUp links:** when you mention a ClickUp task, write it as a markdown link with the task name.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- **Status:** `posted` or `stopped`, with why.
- **Merge facts:** the merge facts and the main CI run.
- **`check-story-shippable`:** its result.
- **ClickUp:** the comment's ID and first line, and every attachment with name, size and the read-back result. Also the card's status before and after (must be the same).
- **Team message:** the path of the draft.
- **Notes text:** the exact text for the main session to put in `leorna-workflow.md` (story delivered: merged, posted).
- **Lists:** `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
