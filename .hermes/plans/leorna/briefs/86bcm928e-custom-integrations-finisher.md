# FINISHER brief (hand-over): 86bcm928e, custom integrations defined by the admin

Role: FINISHER (a fresh general-purpose agent on Opus 5.5, high effort). The pipeline has accepted the head. Run **only the project's finish step**: the `leorna` skill's stop-and-show and hand-over (Doing a story → steps 5 and 6). **Never push, open a PR, merge or write to ClickUp.** Start no other agents.

**Make no commit to the repo.** Any repo commit would need a fresh review and new AC proof. If you find a record that can only land as a repo commit, or a defect, stop and report it in `found_else`.

- Worktree: `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, head `0a45d39097ae4557409173536a68d852ea13ec6f`, base `4ef14efb46da789aec30fad1e5a988d8770140e2` (GitHub main when the story started). The branch has not been pushed and has no upstream.
- Approved plan (read-only copy): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`. Its records/docs section lists the records.
- Evidence root: `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/`. Write your hand-over files in `finisher/` only.

## Pipeline result (verified by the main session; quote it, don't re-prove it)
`ac-check.sh --reviews` on head `0a45d39` printed:
```
AC1  ACCEPTED
AC2  ACCEPTED
AC3  ACCEPTED
REVIEWS  CLEAN: review-3 at 0a45d39 is clean
ALL ACCEPTED: 3 of 3 ACs on 0a45d39
```
- Reviews: round 1 (Fable 5.2 high, full) found 3 P2 and 6 P3; fixer 1 fixed R1-1..R1-3 in `94fa2ee`. Round 2 (Opus 5.5 high, full) clean, one P3. Verifier 1 clean on `94fa2ee`; blind auditor 1 did not accept AC2 (its cross-tenant pack-builder clause couldn't fail); fixer 2 tightened AC2's test only in `0a45d39`. Round 3 (Opus, delta) clean. Verifier 2 and blind auditor 2 (Opus xhigh) clean on `0a45d39`.
- AC tests (all `./internal/web`): `TestCustomIntegrationAC1DefineSavesTenantOwnedTileWithPostgres`, `TestCustomIntegrationAC2ConfigurePackSyncLikePredefinedWithPostgres`, `TestCustomIntegrationAC3InvalidDefinitionBlockedWithPostgres`. No live ACs.
- Gates on `0a45d39` (`verifier/gates-0a45d39/SUMMARY.txt`, `gates-0a45d39.txt`):
  - Everything passes except `make audit`, which fails on **GO-2026-6859** (net/http in go1.27.3, fixed in 1.27.4). It fails on base `4ef14ef` too, so it is outside the story; GitHub main already fixed it (Go 1.27.4, PR #124), so bringing main in at "make a PR" should clear it. `make secrets library-check build` passes.
  - Postgres no-skip: 965 pass, 0 fail.
  - No OpenAPI/contract change (contracts-check green, no contract path).
  - Migration 000032 passed a real-binary up/down proof; the base binary refuses to start while 32 is applied ("applied migration 32 is missing from embedded migrations") and recovers after the down file plus deleting ledger row 32.
- Follow-ups: `follow-ups.md` (P3s R1-4..R1-9, R2-1, verifier notes). Outside findings also in `/home/justin/.hermes/plans/leorna/found-else.md` (86bcm928e sections).
- Plan deviation to disclose: fix `94fa2ee` added an exported `gate.ServerCredential` (+ `server_credential_test.go`) in `internal/library/gate/`, which the plan lists as "Not touched"; add-only, library gate green, reviews clean. Name it in the PR under Assumptions or a "Plan deviations" line.
- Justin's answers (approved with "go"): 1A only `npx` at an exact version or digest-pinned `docker run`; 2A token variable or OAuth; 3A no delete (follow-up); 4A desktop tile list unchanged (follow-up after 928h); 5A own Postgres. The builder's rulings are in `builder/INVENTORY.md`; list any that change user-visible behaviour under Assumptions as "for Justin to confirm".
- Coordination: unmerged local siblings `feat/86bcxnykn-admin-console-update` and `feat/86bcxnymy-client-self-update` also add migration 32; whichever merges later must renumber.

## What to produce
1. **Stop and show** (leorna step 5):
   - Save `git diff --stat origin/main...HEAD` (three dots) and the key hunks to `finisher/diff-stat-0a45d39.txt`.
   - Show that `git diff --name-only origin/main...HEAD` has no `.github/` path.
   - Show authorship as "authors: 1 identity, Leorna OK" (compare against `git config user.email`; never print the address), and show there are no AI attribution lines.
   - Re-fetch GitHub main read-only (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`). If it moved past `4ef14ef`, fetch with the `leorna` skill's HTTPS recipe and run `git merge-tree --write-tree --name-only HEAD <new main>`; note the result (review 2 expected a `delivery/stories.json` append conflict) and the next free migration number on the new main.
   - Run the same merge-tree check against each open sibling PR head and each unmerged local `feat/` branch, following the `leorna` skill's hand-over rule. Bring nothing in: that happens at "make a PR".
2. **PR text** in the plain style (leorna step 6) at `~/.hermes/cache/scratch/leorna-pr-86bcm928e-custom-integrations.md`, body only with no title line. Include:
   - Summary, then one line per file or area.
   - Test Plan: only results recorded on `0a45d39`, with the GO-2026-6859 audit note.
   - Assumptions: Justin's answers 1A–5A as built, the `gate.ServerCredential` deviation, rulings for Justin to confirm, CI audit expected to fail until main's Go 1.27.4 is brought in.
   - Security notes: admin-only routes with CSRF, tenant-scoped storage, secret scan and launcher policy at define and configure, no secret shown back on refusal, audit records hold names only.
   - Migration and rollback notes (000032, its down file, the old binary refusing a newer schema and recovering).
   - A ClickUp link to [the card](https://app.clickup.com/t/86bcm928e).
   - An Evidence block (head SHA; CI run "not yet run, branch not pushed").
   - Name other stories by PR number or title, never by bare card ID.
   - Before writing Assumptions, grep sibling PR texts (`~/.hermes/cache/scratch/leorna-pr-*.md`) and open PRs for this card's ID.
3. **Review prompt** for a fresh agent, in the format in the shared memory note `review-prompt-for-agent.md`. Save it to `finisher/review-prompt.md`, unless Claude Code refuses a prose file from a subagent; then return it in your report.
4. **Team message** draft (`story-done-team-message.md` style) and **ClickUp evidence draft** (`clickup-evidence.md`).
   - The comment text: WHAT WAS DONE, then WHAT WAS VERIFIED as an AC → test → result table, then the gates and CI "not run yet".
   - The list of images to attach: pick the best per AC from the evidence root's, verifier's and auditor's PNGs. Images only, never a `.log` or `.txt`.
   - Open every image yourself first, and check none shows a domain, URL bar, tenant ID, token or email.
   - The post waits for Justin's "post" and for the PR to be merged.
5. **Records:** add one dated story-status line to the shared `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`. Include the branch and head, "not pushed", "ALL ACCEPTED", and the next steps. The "never edit skills or memory" rule below covers skills and lessons only, so this status line is allowed. Check whether the branch already has its `delivery/stories.json` entry and that it reads correctly; don't change it (if it's missing and the plan requires it, report it in `found_else`). The PR-number record comes at "make a PR".

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (FINISHER, hand-over only), `engineering-best-practices`, `git-commit-rules`, `github` (read-only gh calls).

## Rules
- No push, PR, merge, ClickUp write, or real Scaleway or GitHub write.
- Never put server domains, URLs, tenant IDs or tokens in any hand-over text. Don't write key-shaped example values whole (gitleaks runs on the setup sync).
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`, and check earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`) before reading any killed command as a result.
- Scratch: your own `~/.cache/928e-finisher/`, created fresh with `mkdir` (no `-p`).
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes each.
- Other bugs go in `found_else`.
- Skill lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section. Never edit skills or memory yourself, apart from the one status line above. `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: ready|stopped, remaining_stage, summary, diff_stat, github_main, merge_tree[], pr_text_path, review_prompt, team_message, clickup_comment, clickup_attachments[], records_changed[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
