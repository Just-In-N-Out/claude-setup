# REVIEWER brief, round 5 (main 297e2de bring-in): 86bcxnykn

Role: REVIEWER (a fresh general-purpose agent on Opus 5.5, high effort). Report only: change no source, commit nothing, restore anything you touch. Start no other agents.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`. **Head: `72e83179603a91713c1e6e44e91c041e6bb5d0fa`**, a merge of GitHub main `297e2de631f03e28c45e346789d6cb26e2b925ee` (#113, 86bcx2a33 GitHub MCP 4.0.0 library item) into `71ef43aad5f437ee2b9a16b293bb192343317fc3` (PR #131's pushed head, review 4 clean). Not pushed yet.
- Approved plan (read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md` (its 000032 is now 000035). ACs AC1–AC5; AC5 live, not run.
- Your folder: `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/review-5/` (create it). Write `review-5/review.json` in the format `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh` reads (read its header; `feature-dispatch/references/review-loop.md`): round 5, scope delta from `71ef43a`, `head` the full SHA above. Self-check with `review-check.sh --repo <worktree> --base 297e2de631f03e28c45e346789d6cb26e2b925ee <evidence root>`.
- The merge fixer's receipts (read them, prove claims yourself): `main-merge-2/` (merge-verify.txt, gates-72e8317.txt, migration-000035-72e8317.txt, AC logs). Deferred P3s: `follow-ups.md`; don't re-raise them.

## Check (the `leorna` skill's bring-in checks, SKILL.md step 7's long merge line, and `code-review-practice`)
1. `72e8317^{tree}` vs the merge's parents: files differing from both parents = the both-sides set (`delivery/stories.json` only); every one-sided file equals its side's blob; `stories.json` is main's file with this story's entry (`prs` `[131]`) appended last, main's entries equal by value and in order.
2. #113's changes vs this story: anything the story reads or renders (library, packs, seeds, routes, the admin nav, audit actions, OpenAPI), stale until/once wording on either card ID, a same-named helper or a route clash (`go test -count=1 ./internal/web/` with no DB URL), duplicate migration versions.
3. `ac_status`: run the four AC tests by name on head yourself (own capped Postgres `xnyk-review5-pg`, `--memory 1g`, CI's pinned image, a `_test` DB, TCP wait loop that fails at 3 minutes; Go by absolute path `~/.local/leorna-tools/go/bin/go`, `GOTOOLCHAIN=local`); log `review-5/ac-72e8317.log`. AC5 (live) not_run.

Severity rules: `~/.claude/CLAUDE.md` pipeline step 5.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna`, `requesting-code-review`, `code-review-practice`, `backend-data-migrations`.

## Rules
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`; check earlyoom before reading a killed command as a result.
- Scratch: `~/.cache/86bcxnykn-review5/`, created fresh with `mkdir` (no `-p`). Never `git worktree prune`. Stop and remove your container when done.
- Don't end your turn to wait for a background command; bounded foreground polls under 3 minutes.
- No writes to GitHub, ClickUp or Scaleway.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, findings[], ac_status[{ac, accepted, test, evidence}], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
