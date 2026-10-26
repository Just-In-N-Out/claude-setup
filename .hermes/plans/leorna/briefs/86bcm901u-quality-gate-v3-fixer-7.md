# FIXER 7 (integration) brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **FIXER 7** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Job: **rebase the branch onto the new GitHub `main`**, resolve the one known conflict, make sure the story still holds on main's new content, re-run everything, retake the evidence, and stop at **`ready-for-verify`**. No push, PR or ClickUp.

## What happened and what Justin decided

- The branch was AC-accepted on head `f7dff509de5053d647084b2f6171262b91f005c9` (base `6275a4e`). Then **PR #88 (86bcm901v, Library catalog browser) merged at 21:23Z**; GitHub `main` is now **`b446a89`** (14 commits, 15 files, +1835/−2: `internal/library/catalog.go`, `preview.go` and tests, web/store changes, `go.mod`/`go.sum` adding `yuin/goldmark v1.7.17`, and its `delivery/stories.json` entry).
- `git merge-tree --write-tree --name-only f7dff50 origin/main` conflicts **only in `delivery/stories.json`**: both stories appended their entry at the end of the stories object (this story's `"86bcm901u"` with `prs: []`, main's `"86bcm901v"` with `prs: [82, 88]`). `go.mod`/`go.sum` auto-merge.
- **Justin's answers (2026-10-24):** "**Rebase onto new main**" and "**Full re-verify**" (a fresh verifier, the blind AC auditor and `ac-check.sh` run on your new head after you).

## 0. Disk and shared machine

About 6 GB free; other sessions write too. Run `df -h /` before heavy gates; under 3 GB stop with `status: stopped`, `stop_reason: disk`. Never run `go clean -cache`. A gate failing with "open …/go-build/…: no such file or directory" across unrelated packages is a host problem: keep that log under a suffixed name and rerun. `refs/remotes/origin/main` is shared by every worktree: record what you rebased onto and recheck GitHub main (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`) before your final gates and captures; if it moved again, say so (and rebase again only if the new commits conflict or touch this story's files).

## 1. Skills to load first (say so in your first steps)

1. `leorna` (fixer rules, gates, step 7.1's HTTPS fetch through `gh`, step 7.2's sibling-merge checks, the Terminal capture recipe in 4b)
2. `engineering-best-practices`
3. `git-commit-rules`: before rebasing.
4. `test-driven-development`
5. `mutation-testing-discipline`

## 2. Steps

1. **Fetch** CP `main` over HTTPS through `gh` (`leorna` 7.1); confirm `origin/main` = `b446a89…`. Don't touch local `main`.
2. **Backup first:** `git branch backup/86bcm901u-v3-pre-rebase-3 f7dff50` (local only).
3. **Rebase** `feat/86bcm901u-quality-gate-v3` (worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`) onto `origin/main`. In `delivery/stories.json` keep **both** entries: main's `86bcm901v` entry exactly as main has it, and this story's `86bcm901u` entry with an empty PR list; keep the JSON valid and in the file's existing order/format (`python3 -m json.tool` it, and run whatever check `delivery/README.md` names). Any other conflict: keep both sides' meaning; a semantic one is resolved in favour of main's behaviour and recorded as a ruling. Keep commit messages and authorship (author from git config only; no `Co-Authored-By` or AI attribution lines).
4. **Sibling checks (`leorna` 7.2):** run this story's own gate on main's new content (`make library-check` on the real library; #88 may add files under `internal/library/` that the layout check or lint now sees); grep the branch for `901v`/`86bcm901v` and "until/once … merges" wording that is now stale. Fix anything the gate or tests reject on main's content, test first, and record it.
5. **Re-run everything on the new head** as the plan's Gates/T10 say: CI's golangci-lint 2.14.0 by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test` (reuse it; #88's migrations, if any, run on it; never drop it or touch any other DB), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, every AC command, and the AC4 test under GNU Make 4.3 in a container as fixers 5 and 6 did, if disk allows. Save `gates-<sha7>.txt` + `.json` (no email in them).
6. **Base runs** on the new base `b446a89`: each AC test must fail (or fail to build) with head's test files copied in (`ac-verification.md` rules); save `base-ac-runs-b446a89.txt`.
7. **Mutations:** re-run the recorded set (fixer 6's `mutations-fix-6-f7dff50.txt`, 59 entries) on the new head; save `mutations-fix-7-<sha7>.txt`.
8. **Evidence for ClickUp (Justin's one-photo-per-AC rule):** retake all four AC1–AC4 Terminal captures on your final head (the `leorna` recipe: clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, wait up to 90 s for the first prompt, commands passed to osascript as argv, nothing secret on the launch line, count `EXIT=` markers after `clear`, check the first command is on screen, close the window by id in a trap, `| cat` with pipefail for any `docker exec`), the AC3 compatibility-report rendering (local goldmark + headless Chrome, labelled "not GitHub"), and a gate-results capture `gates-<sha7>.png` from a redacted copy of the gate log. Inspect each image: no token, domain, URL bar, tenant ID or email. Update `INVENTORY.md`, marking the `f7dff50` captures superseded.
9. **Hand-over refresh:** in `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/handover/`, update `README.md`, `stop-and-show.md`, `pr-text.md` and `attachments.md` for the new head and base (PR #88 now merged; new head; the PR title is `feat(86bcm901u): content library quality gate in CI` as in `pr-text.md`). Leave `clickup-comment.md` for the PR/post finisher (it needs the PR link), but update its head/base facts. Don't reference the verifier's or auditor's new folders yet (they don't exist).

## 3. Boundaries

- Story-only CI exception: `ci.yml` keeps only its one added step and env block vs the new base.
- No push, PR, merge into `main`, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- Don't touch: local `main`, the `backup/*` branches (create only the new one), the earlier 901u attempts, other stories' worktrees, DBs and scratch, `deploy/local/`, the real client checkout.
- Evidence: write in the evidence root and `handover/` only; never `verifier/`, `verifier-r*/`, `auditor*/`, `review-*/`, never `plan-approved.md`.
- **Justin is back**, so the away grant has ended. On a real trade-off you can't settle safely from the plan and his answers, stop with `status: stopped` and list the options with your recommended one marked. A mechanical resolution that keeps both sides isn't a trade-off.
- **Found something else?** `found_else`; don't fold it in.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## 4. Your report

Return JSON-shaped output: `{name, status: ready-for-verify|stopped, summary, old_head: "f7dff50", new_base, last_commit, conflicts[{file, resolution}], sibling_checks, rulings[], gates[{name, log, exit_code}], base_runs, mutations, ac_evidence[{ac, test, log, screenshot}], handover_updated[], disk_free_at_end, stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
