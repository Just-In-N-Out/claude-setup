# FINISHER brief (hand-over): 86bcm928p connection test for integrations

Role: FINISHER (a fresh general-purpose agent on Opus 5.5, high effort). The pipeline has accepted the head. Run **only the project's finish step**: the `leorna` skill's stop-and-show and hand-over (Doing a story → steps 5 and 6). **Never push, open a PR, merge or write to ClickUp.** Start no other agents.

**Make no commit to the repo.** Any repo commit would need a fresh review and new AC proof. If you find a record that can only land as a repo commit, or a defect, stop and report it in `found_else`.

- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`, head `ecbd6b5e6ff7eca29ef82c1763b5c2120b292a58`, base `4ef14efb46da789aec30fad1e5a988d8770140e2` (GitHub main when the story started). The branch hasn't been pushed and has no upstream.
- Approved plan (read-only copy): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`. Its "Docs & records" and "Docs text" sections list the records. Justin approved every ⭐ option (Q1 A console form only, no OpenAPI change; Q2 A public addresses only; Q3 A saved settings only).
- Evidence root: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/`. Write your hand-over files only in `finisher/`.

## Pipeline result (verified by the main session; quote it, don't re-prove it)
`ac-check.sh --reviews` on head `ecbd6b5` printed:
```
AC1  ACCEPTED
AC2  ACCEPTED
REVIEWS  CLEAN: review-3 at ecbd6b5 is clean
ALL ACCEPTED: 2 of 2 ACs on ecbd6b5
```
- **Reviews:**
  - Round 1 (Fable 5.2 high, full): clean, with 6 P3s.
  - Verifier 1 accepted both ACs at `9da16b8`, but the blind auditor rejected AC1: the test couldn't fail when an entered address went unchecked. Fixer 1 fixed it, test-only, in `4818a8c`.
  - Round 2 (Opus 5.5 high, full): one P2 (R2-1: Not-MCP replies on the event-stream path and a 403 had no killing test) and 2 P3s. Fixer 2 fixed R2-1 and R2-2, test-only, in `ecbd6b5`, and deferred R2-3.
  - Round 3 (Opus 5.5 high, delta): clean, with 1 P3.
- **Verifier 2** (Opus 5.5 high) and **auditor 2** (Opus 5.5 xhigh): both clean on `ecbd6b5`.
- **AC tests:** `TestIntegrationConnectionTestAC1ReachabilityWithPostgres` and `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`. No `(live)` ACs.
- **Gates on `ecbd6b5`** (`verifier-2/gates-ecbd6b5/`):
  - Everything passes except `make audit`, which fails on **GO-2026-6859** (net/http in go1.27.3, fixed in 1.27.4). It fails on base `4ef14ef` too, so it is outside the story; `make secrets library-check build` pass.
  - Postgres no-skip check: 987 pass, 0 fail.
  - No OpenAPI, migration or `.github/` change.
- **Mutants:** 31 killed by the fixer on `ecbd6b5`. The verifier and auditor ran their own mutants on top.
- **Builder's ruling R1** (`builder/INVENTORY.md`): the `internal/web/README.md` line now says "503 when no tester is wired or the saved settings cannot be read". Review 1 confirmed it true. Justin hasn't confirmed it, so list it under Assumptions as "for Justin to confirm".
- **Follow-ups:** `follow-ups.md` (the P3s from reviews 1–3, the auditor's credential-header P3, and the deferred R2-3).

## What to produce
1. **Stop and show** (leorna step 5):
   - Save `git diff --stat origin/main...HEAD` (three dots) and the key hunks to `finisher/diff-stat-ecbd6b5.txt`. Fetch `origin/main` first with the `leorna` skill's HTTPS recipe, so `origin/main` isn't stale.
   - Show that `git diff --name-only <base>...HEAD` has no `.github/`, `contracts/`, `packages/contracts/` or migration path.
   - Show authorship as "authors: 1 identity, Leorna OK" (compare against `git config user.email`; never print the address), and show there are no AI attribution lines.
   - Re-read GitHub main read-only (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`). If it moved past `4ef14ef`, run `git merge-tree --write-tree --name-only HEAD <new main>` and note the result (`delivery/stories.json` is the expected textual conflict; append-last resolves it).
   - Run the same merge-tree check against each open sibling PR head and each unmerged local `feat/` branch, following the `leorna` skill's hand-over rule. Bring nothing in: that happens at "make a PR".
2. **PR text** in the plain style (leorna step 6) at `~/.hermes/cache/scratch/leorna-pr-86bcm928p-integration-connection-test.md`. Body only, no title line. Include:
   - Summary, then one line per file or area.
   - Test Plan: only results recorded on `ecbd6b5`, with the GO-2026-6859 audit note.
   - Assumptions: ruling R1; Q1–Q3 as chosen (no JSON API; private addresses show "Not checked"; only the saved settings are tested); CI audit expected to fail until a toolchain bump PR; no egress-proxy support.
   - Security notes: public addresses only via `domain.PublicAddress`, one resolve with the checked IP dialled, no redirects or proxy, bounds, no credentials sent, admin-only, CSRF, two tests at once.
   - Migration notes: none.
   - A ClickUp link to [the card](https://app.clickup.com/t/86bcm928p).
   - An Evidence block (head SHA; CI "not yet run, branch not pushed").
   - Name other stories by PR number or title, never by bare card ID.
   - Before writing Assumptions, grep sibling PR texts (`~/.hermes/cache/scratch/leorna-pr-*.md`) and open PRs for this card's ID.
3. **Review prompt** for a fresh agent, in the format in the shared memory note `review-prompt-for-agent.md`. Return it in your report (Claude Code refuses prose report files from subagents); save it to `finisher/review-prompt.md` only if the write is allowed.
4. **Team message** draft (`story-done-team-message.md` style) and **ClickUp evidence draft** (`clickup-evidence.md`):
   - The comment text: WHAT WAS DONE, WHAT WAS VERIFIED as an AC → test → result table, the gates, and CI "not run yet".
   - The list of images to attach: pick the best per AC from `verifier-2/` and `auditor-2/` PNGs (the Test result pages: Connected, sign-in required, each failure kind). Images only, never a `.log` or `.txt`.
   - Open every image yourself first. Check none shows a domain, URL bar, tenant ID, token or email, and none carries a banner or caption about how it was made (Justin, 2026-11-10).
   - The post waits for Justin's "post" and for the PR to be merged.
5. **Records:**
   - Add one dated story-status line to the shared `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`: branch and head, "not pushed", "ALL ACCEPTED", and next steps (push / make a PR on Justin's word; the toolchain-bump PR offer). The "never edit skills or memory" rule below covers skills and lessons only, so this status line is allowed.
   - The `delivery/stories.json` entry is already on the branch: check it reads correctly, but don't change it. The PR-number record comes at "make a PR".
6. **Cleanup:** stop and remove the builder's containers `928p-builder-pg` and `928p-builder-ch`, and remove `~/.cache/86bcm928p-builder/`. First check that no agent is using them (`docker ps`; no other `86bcm928p` role is running now). Leave every other container alone.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (FINISHER, hand-over only), `engineering-best-practices`, `git-commit-rules`, `github` (read-only gh calls).

## Rules
- No push, PR, merge, ClickUp write, or real GitHub write.
- Never put server domains, URLs, tenant IDs or tokens in any hand-over text.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`, and check earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`) before reading any killed command as a result.
- Scratch: your own `~/.cache/86bcm928p-finisher/`, created fresh with `mkdir` (no `-p`).
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes each.
- Other bugs go in `found_else`.
- Skill lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section. Never edit skills or memory yourself, apart from the one status line above. `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: ready|stopped, remaining_stage, summary, diff_stat, github_main, merge_tree[], pr_text_path, review_prompt, team_message, clickup_comment, clickup_attachments[], records_changed[], cleanup, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
