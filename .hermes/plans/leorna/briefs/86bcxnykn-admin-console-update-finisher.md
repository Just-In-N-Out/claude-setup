# FINISHER brief (hand-over): 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: FINISHER (a fresh general-purpose agent on Opus 5.5, high effort). The pipeline has accepted the head. Run **only the project's finish step**: the `leorna` skill's stop-and-show and hand-over (Doing a story → steps 5 and 6). **Never push, open a PR, merge or write to ClickUp.** Start no other agents.

**Make no commit to the repo.** Any repo commit would need a fresh review and new AC proof. If you find a record that can only land as a repo commit, or a defect, stop and report it in `found_else`.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`, head `b9f1804631fbf6ffc20d0d0d6e0e103d67dff627`, base `4ef14efb46da789aec30fad1e5a988d8770140e2` (GitHub main when the story started). The branch has not been pushed and has no upstream.
- Approved plan (read-only copy): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Its "Docs & records" section lists the records.
- Evidence root: `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`. Write your hand-over files in `finisher/` only.

## Pipeline result (verified by the main session; quote it, don't re-prove it)
`ac-check.sh --reviews` on head `b9f1804` printed:
```
AC1  ACCEPTED
AC2  ACCEPTED
AC3  ACCEPTED
AC4  ACCEPTED
AC5  NOT VERIFIED (live: the user checks it)
REVIEWS  CLEAN: review-2 at b9f1804 is clean
READY FOR THE USER: 4 of 5 ACs proven on b9f1804; live ACs owed to the user: AC5
```
- Reviews: round 1 (Fable 5.2 high, full) found 2 P2 and 8 P3. Fixer 1 fixed R1-1 and R1-3 in `6035363` and R1-2 in `b9f1804`. Round 2 (Opus 5.5 high, full) was clean, with one P3.
- Verifier (Opus 5.5 high): clean. Blind AC auditor (Opus 5.5 xhigh): clean.
- AC tests: `TestControlPlaneUpdateAC1OfferWithPostgres`, `TestControlPlaneUpdateAC2RedeployWithPostgres`, `TestControlPlaneUpdateAC3RollbackWithPostgres`, `TestControlPlaneUpdateAC4AuditWithPostgres`.
- **AC5 (proposed) (live)** is owed to Justin: the "Live check" runbook in `internal/update/README.md`, run on his dev Scaleway server before the PR (Q4 A). Name it **NOT VERIFIED** in every hand-over text.
- Gates on `b9f1804` (`verifier/gates-b9f1804.txt`):
  - Everything passes except `make audit`, which fails on **GO-2026-6859** (net/http in go1.27.3, fixed in 1.27.4). It fails on base `4ef14ef` too, so it is outside the story; `make secrets library-check build` passes.
  - Postgres no-skip: 1045 passes, 0 fails.
  - The OpenAPI change is additive only.
  - Migration 000032 passed a real-binary up/down proof.
- Follow-ups: `follow-ups.md` (the P3s, outside findings and plan follow-up cards).
- The builder's rulings 1–6 are in `INVENTORY.md`. Both reviewers judged them sound; ruling 3 was narrowed by R1-3. Justin hasn't confirmed them yet, so list rulings 1 and 2 under Assumptions as "for Justin to confirm".

## What to produce
1. **Stop and show** (leorna step 5):
   - Save `git diff --stat origin/main...HEAD` (three dots) and the key hunks to `finisher/diff-stat-b9f1804.txt`.
   - Show that `git diff --name-only origin/main...HEAD` has no `.github/` path.
   - Show authorship as "authors: 1 identity, Leorna OK" (compare against `git config user.email`; never print the address), and show there are no AI attribution lines.
   - Re-fetch GitHub main read-only (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`). If it moved past `4ef14ef`, run `git merge-tree --write-tree --name-only HEAD <new main>` (fetch with the `leorna` skill's HTTPS recipe first) and note the result. Also note the next migration number against the new main.
   - Run the same merge-tree check against each open sibling PR head and each unmerged local `feat/` branch, following the `leorna` skill's hand-over rule. Bring nothing in: that happens at "make a PR".
2. **PR text** in the plain style (leorna step 6) at `~/.hermes/cache/scratch/leorna-pr-86bcxnykn-admin-console-update.md`, body only with no title line. Include:
   - Summary, then one line per file or area.
   - Test Plan: only results recorded on `b9f1804`, with AC5 NOT VERIFIED and the GO-2026-6859 audit note.
   - Assumptions: rulings 1 and 2; CI audit expected to fail until a toolchain bump; private repo means releases need a read token (Q1 A); dev-mode installs.
   - Security notes (admin-only, CSRF, the narrow Containers key, never logged).
   - Migration and rollback notes (000032 forward-only, its down file, the old binary refusing a newer schema and recovering).
   - A ClickUp link to [the card](https://app.clickup.com/t/86bcxnykn).
   - An Evidence block (head SHA; CI run "not yet run, branch not pushed").
   - Name other stories by PR number or title, never by bare card ID.
   - Before writing Assumptions, grep sibling PR texts (`~/.hermes/cache/scratch/leorna-pr-*.md`) and open PRs for this card's ID.
3. **Review prompt** for a fresh agent, in the format in the shared memory note `review-prompt-for-agent.md`. Save it to `finisher/review-prompt.md`, unless Claude Code refuses a prose file from a subagent; then return it in your report.
4. **Team message** draft (`story-done-team-message.md` style) and **ClickUp evidence draft** (`clickup-evidence.md`).
   - The comment text: WHAT WAS DONE, then WHAT WAS VERIFIED as an AC → test → result table, then the gates, CI "not run yet", and AC5 NOT VERIFIED.
   - The list of images to attach: pick the best per AC from the verifier's and auditor's PNGs. Images only, never a `.log` or `.txt`. Show each log as a screenshot of the run instead.
   - Open every image yourself first, and check none shows a domain, URL bar, tenant ID, token or email.
   - The post waits for Justin's "post" and for the PR to be merged.
5. **Records:** add one dated story-status line to the shared `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`. Include the branch and head, "not pushed", "READY FOR THE USER, AC5 live owed", and the next steps. The "never edit skills or memory" rule below covers skills and lessons only, so this status line is allowed. The `delivery/stories.json` entry is already on the branch; check it reads correctly, but don't change it. The PR-number record comes at "make a PR".

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (FINISHER, hand-over only), `engineering-best-practices`, `git-commit-rules`, `github` (read-only gh calls).

## Rules
- No push, PR, merge, ClickUp write, or real Scaleway or GitHub write.
- Never put server domains, URLs, tenant IDs or tokens in any hand-over text.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`, and check earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`) before reading any killed command as a result.
- Scratch: your own `~/.cache/86bcxnykn-finisher/`, created fresh with `mkdir` (no `-p`).
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes each.
- Other bugs go in `found_else`.
- Skill lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section. Never edit skills or memory yourself, apart from the one status line above. `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: ready|stopped, remaining_stage, summary, diff_stat, github_main, merge_tree[], pr_text_path, review_prompt, team_message, clickup_comment, clickup_attachments[], records_changed[], found_else[], skill_lessons[]}`. `status: ready` is not allowed while AC5 is owed, so use `remaining_stage: "code-reviewed and verified; live acceptance (AC5) pending"`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
