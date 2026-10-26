# FINISHER (publish the merged head to PR #88) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **FINISHER** (Opus 5.5, xhigh) for one publication step.

## What Justin authorized (2026-10-24)

PR #88 went CONFLICTING after PRs #85 and #89 merged into main. Justin asked to fix it and re-check the ACs, and picked **"Push + update PR text"**: once `ac-check.sh` says ALL ACCEPTED on the merged head, push it to the PR branch (**no force-push**), refresh the PR description and wait for CI.

**Not authorized:** merging (never), force-push, ClickUp writes of any kind (Justin says "post" separately), a `delivery/stories.json` commit (it would move the accepted head; keep it drafted), changing the card, `gh auth switch`, changing remotes or credential helpers, any server/cloud action, `.github/` edits. Each word authorizes only itself.

## The candidate

- **Repo / worktree:** `~/Leorna/leorna-control-plane`, worktree `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3`, upstream `origin/feat/86bcm901v-catalog-browser-v3` = `2c43b39` (what PR #88 shows today).
- **Accepted head:** `cc2048214232264a0e8b34035daefbcb63c17c5b` on base `6275a4e6ae4700ebd23d494bbe0990d22b879760`. `ac-check.sh` → `ALL ACCEPTED: 3 of 3 ACs on cc20482` (run by the main session on the round-2 verifier's and the blind auditor's reports). **Push exactly this head.** If the worktree isn't clean at `cc20482`, stop and report.
- **New commits on top of `2c43b39`** (a fast-forward for the remote branch): `b8052e2` Merge branch 'main' into feat/86bcm901v-catalog-browser-v3; `a09f72f` fix(86bcm901v): name prompts in the library page introduction; `86c16b8` docs(86bcm901v): say how library content reaches library_items now; `cc20482` docs(86bcm901v): say the setup wizard also runs EnsureLibrary.
- **Receipts on `cc20482`** (cite them, each saying who ran it; don't copy them): `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/verifier-merge2/` (round-2 verifier: gates, AC head/base logs, screenshots, mutations) and `auditor-merge/` (blind auditor: AC head/base logs, screenshots, mutations). Earlier context: `fix-merge/`, `verifier-merge/`, `fix-merge2/`.
- **Current PR body:** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/publish/pr-body.md` (what's on GitHub now). Also read `gh pr view 88 -R LeornaAI/leorna-control-plane --json body` and use the live one if they differ.

## Skills (load with the Skill tool; say so in one line each)

1. `leorna` (FINISHER role): Doing a story → step 7 ("make a PR": 7.1 fetch, 7.2 pre-flight, 7.3 gates, 7.5 PR text, 7.6 push, 7.7 read-back), the Identity and Merge-policy hard rules, step 4's control-plane gates; read `~/Leorna/leorna-control-plane/delivery/README.md`.
2. `engineering-best-practices`.
3. `git-commit-rules` and `github`.

## Steps

1. **Fresh main:** fetch over HTTPS through gh (`leorna` 7.1). If `origin/main` moved past `6275a4e`, run `git merge-tree --write-tree --name-only HEAD origin/main`: if it conflicts, **stop and report** (no new merge without Justin); if it's clean, say so and continue (the PR merges cleanly; the ACs were proven on `cc20482`).
2. **Pre-flight (7.2):** `git status --porcelain` empty; `git rev-parse HEAD` = `cc20482…`; `git merge-base --is-ancestor origin/feat/86bcm901v-catalog-browser-v3 HEAD` exits 0 (fast-forward, so **no force-push**); every author/committer in `git log --format='%an <%ae> | %cn <%ce>' origin/main..HEAD` is `Justin Issa <justin@leorna.com>` and no message has Co-Authored-By/AI lines; `git diff --name-only origin/main...HEAD -- .github contracts packages/contracts` empty.
3. **Gates on the exact head (7.3):** in a **detached copy** of `cc20482` (leave the worktree clean; `make check` and `test-module-add.sh` write into the tree they run in), with your own DB `leorna_86bcm901v_v3_publish2_test` (ends in `_test`; drop it after; read the DB password before narrowing PATH) and CI's tool versions bound by absolute path (golangci-lint 2.14.0, govulncheck v1.7.0): `make check` with Postgres, a verbose `go test -v -count=1 ./internal/library/... ./internal/store/postgres/... ./internal/web/... ./cmd/control-plane/...`, `bash ./scripts/test-module-add.sh`, `make contracts-check`. Logs with `label EXIT=<rc>` in a `SUMMARY.txt` under `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/publish-merge/`. A failure caused by this branch → stop and report.
4. **PR text (7.5):** update the current body; write it to `~/.hermes/cache/scratch/leorna-pr-86bcm901v-catalog-browser-v3.md` and a copy `publish-merge/pr-body.md`. Same plain style; **no AI attribution lines** (Leorna rule: no Co-Authored-By, no "Generated with" footer); no server domain, URL, tenant ID or token. Changes:
   - Header: after "Depends on 86bcm9018 (PR #82, merged)." add "Merged with main after PRs #85 (86bcm9016) and #89 (86bcm945u) with a merge commit."
   - Summary: "(skills, agents, configs and MCP templates)" → "(skills, agents, configs, MCP templates and prompts, including the skill imported from an upstream project by 86bcm945u)"; refresh the "2–7 ms" timing from the `cc20482` receipts (verifier and auditor AC3 medians, roughly 2–8 ms).
   - Changes: `internal/web/handler.go` "kept next to main's Third-party content route, field and link"; `cmd/control-plane/main.go` "next to main's `SetContentLibrary`"; `internal/web/library.go` "the list page introduction names every kind, prompts included"; Tests: add `TestLibraryPageIntroNamesEveryKind`; the `preview.go` comment now says the library already includes upstream items; `internal/web/README.md` Limits line says how content reaches `library_items`.
   - **Test Plan:** rewrite for `cc20482` only: your gate run (publish step, detached copy), then the round-2 verifier's and blind auditor's results (AC1–AC3 pass on head, fail to build on base `6275a4e`; AC3 medians; mutation checks; `TestLibraryPageIntroNamesEveryKind` fails without its fix; main's new tests pass on the merged head; manual demo screenshots on 127.0.0.1 with 250 items incl. a Prompt filter), plus the two agent code reviews (on the pre-merge heads; agent reviews, not human approvals). Hosted CI result on `cc20482` once known.
   - **Assumptions:** replace the preview-cost bullet with exactly: "The library item page's Markdown preview has no cost bound: goldmark pads every short table row to the header's column count, so a table's HTML grows with columns × rows (a 16 KB table renders to 80 MB of HTML in about 4 s and allocates 1.8 GiB; a body or example at the 64 KiB limit could need tens of GiB, extrapolated). Accepted for now because content reaches `library_items` only through `EnsureLibrary`, which loads the files under `internal/library/content` compiled into the binary. It runs at startup and again in the setup wizard's starter-pack step; no API, tenant or runtime path writes anything else into the table, and main takes changes to those files only through a pull request. Upstream items imported by 86bcm945u (PR #89, now on main) arrive the same way: `cmd/library-upstream` writes their files, and they ship once that change is committed and merged (the imported `debugging-and-error-recovery` skill renders in about 0.1 ms). A bound on table cells, or an escaped code view as the fallback, is a follow-up that must land before content can reach `library_items` without such a commit (e.g. tenant variants or a runtime import). Recorded under Limits in `internal/web/README.md`." Replace the "When PR #85 (`prompt` kind) merges … empty state" bullet with: "Prompts: since 86bcm9016 (PR #85, now on main) `library_items` can hold prompt items (migration 21). The Kind filter offers \"Prompt\" and shows main's `pr-description` item, whose body renders as Markdown like a skill." Add: "Cosmetic follow-up: the shared admin table style (`td{overflow-wrap:anywhere}`, `internal/web/admin_ui.go`) can break the short \"Prompt\" label mid-word in a narrow Kind column; not changed here because it is shared console CSS." Update the "240 seeded demo items" wording if the new demos used 250 items (10 shipped + 240 seeded).
   - Migration: add "; main's migration 21 added the prompt kind".
   - **Evidence:** head SHA `cc2048214232264a0e8b34035daefbcb63c17c5b`; check "Go quality gates" result and Actions run URL for that head (fill in after CI).
5. **Push identity:** `gh auth status` must show the active account `Justin-Leorna`. Anything else → stop and report (never `gh auth switch`).
6. **Push (7.6), fast-forward only:** `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm901v-catalog-browser-v3:refs/heads/feat/86bcm901v-catalog-browser-v3` (no `--force`, no `+`; if it's rejected as non-fast-forward, stop and report). Fetch it back into `refs/remotes/origin/feat/86bcm901v-catalog-browser-v3` and check `git rev-parse HEAD origin/feat/86bcm901v-catalog-browser-v3` both equal `cc20482…`.
7. **Update the PR body:** `gh pr edit 88 -R LeornaAI/leorna-control-plane --body-file <file>` (title unchanged). Read back `gh pr view 88 … --json number,url,state,isDraft,headRefOid,mergeable,mergeStateStatus` (headRefOid must be `cc20482…`; mergeable not CONFLICTING) and confirm the live body matches your file. **Never merge.**
8. **Wait for CI:** poll `gh run list`/`gh run view` for the run on `cc20482` (don't rely on `gh pr checks --watch`; it dies on a network blip), cap about 20 minutes. Record "Go quality gates" and the run URL, then fill the Evidence block with one more `gh pr edit`. If CI fails because of this branch, report the failing step. If still running at the cap, say "CI running" with the run URL.
9. **Drafts for later (write, don't send or post):**
   - `publish-merge/stories-json-entry.md`: the exact `delivery/stories.json` entry (`86bcm901v` with PRs `[82, 88]`) in the format of main's current `delivery/stories.json` (main changed it since the first draft in `publish/stories-json-entry.md`).
   - **ClickUp re-post draft** for when Justin says "post" (Justin: "if new screenshots are gonna get uploaded to clickup make sure to delete the old ones"): `publish-merge/clickup/` with one screenshot per AC from `verifier-merge2/` or `auditor-merge/` on `cc20482`, named `ac1-library-filters-cc20482.png`, `ac2-item-detail-cc20482.png`, `ac3-filtering-timing-cc20482.png`, plus the matching gate and AC logs named with `-cc20482` (open every file and check it: no host, URL bar with a real host, tenant ID, token, email; logs' `EXIT=` lines; no logs that print the author email). `publish-merge/clickup-comment-updated.md`: the existing comment's text (read it with `clickup_get_task_comments` on task `86bcm901v`, comment id 90140272964839) updated for `cc20482` (merge with main, AC results, gates, CI run, new file names; keep the NOT VERIFIED section). `publish-merge/clickup-old-attachments.md`: the 8 current attachments' titles and IDs from `clickup_get_task include=["attachments"]`, for Justin to delete by hand (the connector has no attachment delete). **Read-only ClickUp calls only** (load the schemas with ToolSearch); no upload, comment or edit.
10. Clean up your detached copy and DB; leave the worktree clean.

## Rules

- Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches, DBs or Terminal windows. Leave the untracked `deploy/local/` in the main checkout alone.
- Keep scratch in your own `<scratchpad>/publish-901v/` folder (the session scratchpad is shared by every agent).
- Shared memory notes and skills are updated by the main session: put anything for them in your report.

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity).

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{status: published|stopped, stop_reason, origin_main, pushed_head, fast_forward, push_account, pr{number, url, state, isDraft, headRefOid, mergeable, mergeStateStatus}, pr_body_updated, ci{check, conclusion, run_url}, gates[{name, exit_code, log}], drafts{stories_json, clickup_comment, clickup_files[], old_attachments[{title, id}]}, files_written[], found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
