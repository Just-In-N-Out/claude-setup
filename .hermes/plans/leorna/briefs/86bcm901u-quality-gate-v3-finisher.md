# FINISHER brief (hand-over only): 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **FINISHER** for the Leorna story **Content quality gate (CI)**, ClickUp card [86bcm901u](https://app.clickup.com/t/86bcm901u), feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. The build is **verified and accepted**: run only the `leorna` skill's **hand-over** (Doing a story, steps 5 and 6, plus 4b's finisher evidence work). **Make no commit**: the head must stay `f7dff50`, the head both AC agents proved. **Never push, open a PR, post to ClickUp or change the card.**

## 1. Skills to load first (say so in your first steps)

1. `leorna`: the **FINISHER** role, with its Step 1 topic notes for finishing a story (`stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md`, and `~/Leorna/leorna-control-plane/delivery/README.md`).
2. `engineering-best-practices`
3. `git-commit-rules` (to check authorship and the no-AI-attribution rule; you won't commit)

## 2. The facts (verified)

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`f7dff509de5053d647084b2f6171262b91f005c9`**, clean, no upstream, never pushed. 29 commits, all `Justin Issa`, no AI attribution lines.
- **Base:** GitHub `main` **`6275a4e`** (includes today's PR #85 for 86bcm9016 prompt kind and PR #89 for 86bcm945u upstream sync; the branch was rebased onto it). Local backups of the pre-rebase heads: `backup/86bcm901u-v3-pre-rebase` (`90407b3`) and `backup/86bcm901u-v3-pre-rebase-2` (`760dc59`), local only.
- **Acceptance:** `ac-check.sh` on the verifier's and the blind auditor's reports: `READY FOR THE USER: 4 of 5 ACs proven on f7dff50; live ACs owed to the user: AC5` (AC1–AC4 ACCEPTED; AC5 NOT VERIFIED, live).
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md` (ACs, design, Docs & records task T8). The live plan `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` has "Justin's answers" (Q1-A … Q5-A), the "Away grant" and "Away-grant picks", which log every review, fix and verify round and every agent ruling made under the grant (all "not yet confirmed" by Justin: list them for him).
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/`: the builder/fixer receipts in the root (`INVENTORY.md` is the index; the current AC captures are `ac1-validate-render-scan-f7dff50.png`, `ac2-broken-item-fails-f7dff50.png`, `ac3-real-library-passes-f7dff50.png`, `ac3-compatibility-report-f7dff50.png`, `ac4-ci-step-added-f7dff50.png`, gate log `gates-f7dff50.txt`/`.json`), plus the independent `verifier/` and `auditor/` folders (each with its own screenshot per AC), `review-1/`, `review-2/`, `verifier-r1/`…`verifier-r3/` (earlier rounds).
- **Story-only CI exception** (memory `no-ci-changes.md`): `.github/` holds only `ci.yml`, 5 added / 0 deleted vs base.
- **Known items to carry into the hand-over:**
  - **R1-F4 (email in receipts):** `gates-a2bc032.*`, `gates-a3a2b23.*` and the harness scripts `fix-*-gates.sh` contain Justin's work email. Never attach them as they are. Don't edit the originals; for any log you pick as an attachment, make a redacted copy (use `perl -pi -e`, not BSD `sed -i`) in the hand-over folder and grep it to confirm no email remains.
  - **R4-A1 (P3 doc nit, not committed on purpose):** a sentence in `internal/library/render/testdata/client/SOURCE.md` says every file below is the same at `ea2b8ab` and `17f7c1b`, but the "Rule sources" table lists files client PR #20 changed. Recommended text: "every fixture file in the next table is the same at ea2b8ab and at 17f7c1b; the rule sources are 17f7c1b's, with PR #20's prompt cases in prompt.go". Put it in the hand-over as a ready one-line doc fix to commit when Justin says "make a PR" (the PR step re-runs the gates on the pushed head); say plainly that committing it changes the head the ACs were proven on.
  - **AC5 (live, owed to Justin):** needs his own auth step to give the `gh` token the `workflow` scope (current scopes: gist, read:org, repo), then "make a PR"; then the hosted "Go quality gates" run must fail on a throwaway branch with the broken item (FAIL line naming `mcp_template/broken-args@1.0.0 codex`) and pass on the real branch with the compatibility table in the job summary. Pushing a throwaway branch is also his call.
  - **Accepted limits** (from "Justin's answers" and the grant picks): agents show as "skipped" and pass (Q1-A); render warnings pass and are listed (Q2-A); failure reasons quote item text (R1-F5, README says so); gitleaks' built-in allowlist drops any real secret containing "false" in every default-rules scan, CI's own included (upstream follow-up); AC4's stated boundary (sabotage inside another CI step's own script is code-review territory).
  - **Follow-ups:** the 86bcm901u entries in `~/.hermes/plans/leorna/found-else.md` (2026-10-24 sections).

## 3. What to produce

Write everything into `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/handover/` (new folder; nothing else in the evidence tree changes):

1. **Stop and show** (`stop-and-show.md`): `git diff --stat 6275a4e..HEAD`, the key hunks (gate core, scan, report, command, the `ci.yml` and Makefile additions), the `.github/` path list, gate results from `gates-f7dff50.*` (open each log and read its recorded exit code before citing it), and the ac-check result line.
2. **PR text** (`pr-text.md`) in Christian's plain style (per `leorna`): a Summary paragraph, one line per file/area, a Test Plan with results that ran on `f7dff50` (say which; hosted CI is NOT VERIFIED), a short Assumptions list (incl. the CI exception, the accepted limits, R4-A1 pending), and the control-plane extras: ClickUp link, security/migration/rollback notes (no migration; rollback = revert the commits / drop the CI step), and an Evidence block (head SHA, check "Go quality gates", Actions run URL: pending).
3. **Review prompt** (`review-prompt.md`): a self-contained prompt for a fresh reviewer, in the format of `review-prompt-for-agent.md`.
4. **ClickUp evidence draft** (`clickup-comment.md` + `attachments.md`), in the format of `clickup-evidence.md`: the closing comment with WHAT WAS DONE / WHAT WAS VERIFIED, an **AC → test → result → screenshot table with one screenshot per AC1–AC4** (Justin: "a screenshot for each AC because we are going to upload to ClickUp"), the gates, AC5 as NOT VERIFIED (owed to Justin, with why), and the list of files to attach. For each AC pick the clearest **real** capture on `f7dff50` (builder/fixer root capture, or the verifier's or auditor's, whichever reads best) and say which you picked. **Inspect every image yourself before listing it**: no token, server domain, URL bar, tenant ID or email may be visible; title bars showing only the macOS username are fine. Attach only redacted copies of any logs. Upload nothing.
5. **Team message draft** (`team-message.md`) per `story-done-team-message.md`, marked "send after merge".
6. **Hand-over summary** (`README.md` in the folder): the AC inventory (AC → test → head log → base log → screenshot, for builder/verifier/auditor), Justin's next steps in order (auth step → "make a PR" → AC5 hosted runs → he merges → `python3 scripts/check-story-shippable.py 86bcm901u` and the stories.json PR number (leorna step 7.8) → "post"), the away-grant rulings he hasn't confirmed yet (one line each, from the live plan), R4-A1, and the follow-ups.

Before finishing: `git -C <worktree> status --porcelain` must be empty and `git rev-parse HEAD` must still be `f7dff50…`.

## 4. Boundaries

- No commit, push, PR, merge, remote CI, token change, ClickUp write, status change or comment. No edits outside `handover/` (don't touch other evidence files, the plans, briefs, memory or skills).
- Don't touch: local `main`, the backup branches, the earlier 901u attempts, other stories' worktrees, DBs and scratch, `deploy/local/`.
- Never print tokens; never write a server domain, URL or tenant ID.
- **Found something else?** `found_else`, one line each; don't fold it in.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## 5. Your report

Return JSON-shaped output: `{name, status: ready|stopped, summary, head, handover_folder, files[], screenshots_chosen[{ac, file, source, inspected: true}], redacted_copies[], justin_steps[], unconfirmed_rulings[], found_else[], skill_lessons[]}` (`status` and `summary` required). `ready` means the hand-over is complete with the live AC5 named as owed (the stage is "code-reviewed and AC-verified; live acceptance pending"). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
