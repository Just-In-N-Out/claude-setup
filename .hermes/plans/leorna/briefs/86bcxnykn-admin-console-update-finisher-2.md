# FINISHER brief 2 (hand-over refresh after the main bring-in): 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: FINISHER (a fresh general-purpose agent on Opus 5.5, high effort). The pipeline has accepted the new head. Run **only the project's finish step**: the `leorna` skill's stop-and-show and hand-over (Doing a story → steps 5 and 6), refreshing the earlier hand-over for the new head. **Never push, open a PR, merge or write to ClickUp.** Start no other agents. **Make no commit to the repo**; a record that can only land as a commit, or a defect, goes in `found_else`.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`, **head `6517bb18d5ac95ce9f546d9ad992248e081c1d37`**, base `de4da6232114b9ee7107d3e2858481a488ed6165` (GitHub main, brought in by merge on 2026-11-11: `c7595c0` merge of 62c6d7d, `835fb91` migration renumbered 000032 → 000035, `28eb08b` AC3 test reads the newest schema version, `a5ec79c` comment refs, `6517bb1` merge of de4da62). Not pushed, no upstream.
- Approved plan (read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md` (it says 000032; the story's migration is now 000035).
- Evidence root: `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`. Write new hand-over files in `finisher-2/` only. The earlier hand-over (on `b9f1804`) is in `finisher/`: reuse its structure, but every number and SHA must come from the new head's evidence.

## Pipeline result (verified by the main session; quote it, don't re-prove it)
`ac-check.sh --reviews` on head `6517bb1` printed:
```
AC1  ACCEPTED
AC2  ACCEPTED
AC3  ACCEPTED
AC4  ACCEPTED
AC5  NOT VERIFIED (live: the user checks it)
REVIEWS  CLEAN: review-3 at 6517bb1 is clean
READY FOR THE USER: 4 of 5 ACs proven on 6517bb1; live ACs owed to the user: AC5
```
- Reviews: round 1 (Fable high, full) 2 P2 + 8 P3, fixed; round 2 (Opus high, full) clean at b9f1804; round 3 (Opus high, the bring-in delta) clean at 6517bb1 with two P3s (R3-1, R3-2 in `follow-ups.md`).
- Main-merge receipts: `main-merge/` (gates-6517bb1.txt, merge-verify.txt, migration-000035-6517bb1.txt, toolchain.txt).
- Verifier 2 (Opus high): clean, `verifier-2/` (gates/SUMMARY.txt: `make check` EXIT=0 **including `make audit`**, which now passes on go1.27.4; Postgres no-skip 1146 pass / 0 fail; spec additive only, 98 added lines; 000035 real-binary up/down proof). Blind auditor 2 (Opus xhigh): clean, `auditor-2/`.
- AC5 (proposed) (live) is owed to Justin: the "Live check" runbook in `internal/update/README.md`, on his dev Scaleway server, before the PR (Q4 A). Name it **NOT VERIFIED** in every hand-over text.
- Builder's rulings 1 and 2 are still for Justin to confirm (Assumptions). Follow-ups: `follow-ups.md`.

## What to produce
1. **Stop and show** (leorna step 5): save `git diff --stat origin/main...HEAD` and the key hunks to `finisher-2/diff-stat-6517bb1.txt`; show no `.github/` path in `git diff --name-only origin/main...HEAD`; authorship "authors: 1 identity, Leorna OK" (never print the address); no AI attribution lines. Re-fetch GitHub main read-only (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`). If it moved past `de4da62`, fetch with the HTTPS recipe, run `git merge-tree --write-tree --name-only HEAD <new main>`, and say so at the top of your report (bring nothing in). Note the next free migration number. Run the merge-tree check against each open sibling PR head (currently #113) and each unmerged local `feat/` branch, as the `leorna` hand-over rule says.
2. **PR text** in the plain style, rewriting `~/.hermes/cache/scratch/leorna-pr-86bcxnykn-admin-console-update.md` (body only, no title line). Keep a copy of the old one as `finisher-2/pr-text-b9f1804.md` first. Fix: every 000032 → 000035; the migration notes (forward-only, its down file, main's binary refusing "applied migration 35 is missing from embedded migrations" then starting after the down); a Test Plan note that main was brought in at `de4da62` (merge, not rebase) and which gates ran on `6517bb1`; drop the old "make audit fails on GO-2026-6859" assumption (it passes now) and the "000032 still free on 89cc6e8" line. Test Plan only with results recorded on `6517bb1`, AC5 NOT VERIFIED. Evidence block: head `6517bb1`, CI "not yet run, branch not pushed". ClickUp link to [the card](https://app.clickup.com/t/86bcxnykn). Name other stories by PR number or title, never by bare card ID.
3. **Review prompt** for a fresh agent (format: shared memory note `review-prompt-for-agent.md`) at `finisher-2/review-prompt.md`, for head `6517bb1`.
4. **Team message** draft (`story-done-team-message.md` style) at `finisher-2/team-message.md`, and **ClickUp evidence draft** (`clickup-evidence.md` style) at `finisher-2/clickup-evidence.md`: WHAT WAS DONE, WHAT WAS VERIFIED as an AC → test → result table on `6517bb1`, the gates, CI "not run yet", AC5 NOT VERIFIED. Pick the best image per AC from `verifier-2/` and `auditor-2/` PNGs plus one gate-summary screenshot you render yourself (terminal capture recipe in `ac-verification.md`); images only, never `.log`/`.txt`. Open every image and check it shows no domain, URL bar, tenant ID, token or email. The post waits for Justin's "post" and for the PR to be merged.
5. **Records:** replace the "Current xnykn" status line in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` with one dated line: branch, head `6517bb1`, main brought in at `de4da62`, migration 000035, not pushed, READY FOR THE USER with AC5 live owed, next steps. That is the only memory edit allowed. Check `delivery/stories.json`'s entry reads correctly; don't change it.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (FINISHER, hand-over only), `engineering-best-practices`, `git-commit-rules`, `github` (read-only gh calls).

## Rules
- No push, PR, merge, ClickUp write, or real Scaleway or GitHub write.
- Never put server domains, URLs, tenant IDs or tokens in any hand-over text.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`, and check earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`) before reading any killed command as a result.
- Scratch: your own `~/.cache/86bcxnykn-finisher2/`, created fresh with `mkdir` (no `-p`).
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes each.
- Other bugs go in `found_else`. Skill lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section. Never edit skills or memory yourself, apart from the one status line above. `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: ready|stopped, remaining_stage, summary, diff_stat, github_main, merge_tree[], pr_text_path, review_prompt, team_message, clickup_comment, clickup_attachments[], records_changed[], found_else[], skill_lessons[]}`. `status: ready` is not allowed while AC5 is owed: use `remaining_stage: "code-reviewed and verified; live acceptance (AC5) pending"`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
