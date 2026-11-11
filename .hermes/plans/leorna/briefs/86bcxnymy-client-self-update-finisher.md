# FINISHER brief: 86bcxnymy, hand-over (no push, no post)

**Role:** FINISHER for Leorna story `86bcxnymy` ([Client self-update to the admin-approved version, with staged rollout](https://app.clickup.com/t/86bcxnymy)), pipeline **Full**. **Model:** Opus 5.5, effort high.

**Verified under the recorded acceptance contract: run only the project's finish step** (the `leorna` skill's steps 5 and 6: stop-and-show diff, PR texts, review prompt, ClickUp evidence draft, team message). `ac-check.sh` printed `READY FOR THE USER: 7 of 8 ACs proven on 76ed828; live ACs owed to the user: AC8` with `REVIEWS CLEAN`, and the control-plane review referee prints `MOVE ON: review-4 at 54c8f1a is clean`. **Never push, open a PR, merge or post.** No code changes: if something needs one, stop and report.

## The two branches

- **Client:** `~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `76ed828f75a4e5e44f65fa021a5b35755e36b996`, base `a7839b3af664efcfa59eb1ed3fe276ec1262a4de`.
- **Control plane:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `54c8f1ae6fcd7a6e88630a69e8840366d34d188b`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`.

## Read

- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md` (ACs, "Assumptions (for the PR texts)", "Follow-ups", "Live checklist for AC8", "Docs & records", "Justin's answers").
- Evidence: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/` — `verifier/ac.json` and `auditor/ac.json` (AC → test → result, screenshots), `verifier/gates-*`, the review records (`review-1/`, `review-2/`, `control-plane/review-1..4/`), `follow-ups.md`, builders' INVENTORY.md (rulings).
- Handoff: `~/.hermes/plans/leorna/briefs/86bcxnymy-handoff.md` (Justin's answers and the bring-main-in notes).

## What to write (into `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/handover/`)

1. **Stop and show** for each repo: `git diff --stat origin/main...HEAD` (three dots), the `.github/` path list (must be empty), the key hunks named in a short list, gate results from the verifier's and auditor's receipts (cite the files; don't re-run the whole suite).
2. **Two PR texts** in the plain style the `leorna` skill describes (Summary paragraph, one line per file/area, Test Plan with results, short Assumptions list; the control-plane one also has the ClickUp link, security/migration/rollback notes and an Evidence block with head SHA; CI run URL "after push"). Body only, no `Title:` line; give the title separately (`feat(86bcxnymy): …`). Save them as `~/.hermes/cache/scratch/leorna-pr-86bcxnymy-client.md` and `…-control-plane.md` too. Include:
   - **Audit note (Justin, 2026-11-11: "If we can merge our prs for now it is fine just add it as a note"):** `make audit` fails on GO-2026-6859 (net/http in go1.27.3, fixed in 1.27.4) on `main` as well, outside this story; every other gate passes. Control-plane `main` has since moved to Go 1.27.4 (#124), so bringing `main` in clears it there; the client still pins go1.27.3.
   - **Migration rollback (control plane):** the README's note (review R1-8): an older server refuses a database that ran migration 000032; roll back with the down file plus `DELETE FROM schema_migrations WHERE version=32` in one transaction (the plan's D3 "old servers ignore the tables" is wrong).
   - **Before "make a PR" (control plane):** GitHub `main` now has `000032_tenant_sso` (#125), so bringing `main` in renumbers this story's migration to `000033`, with conflicts in `delivery/stories.json` and `internal/store/postgres/store_test.go`. Say this needs Justin's OK with "make a PR"; don't do it.
   - Doc drift vs plan D8 to state: `ConfirmStarted` keeps `<exe>.new`; `GuardLaunch` rolls back an approved-SHA file that reports another version as `install_failed`.
   - The builders' rulings worth a reviewer's eye, and the follow-ups (from `follow-ups.md`) as a short list.
   - Name other stories by PR number or title, never by bare card ID (the shippable check reads card IDs in PR texts).
3. **A self-contained review prompt** for a fresh agent, in the format of the shared note `review-prompt-for-agent.md` (memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`).
4. **ClickUp evidence draft** per `clickup-evidence.md`: the closing comment text (WHAT WAS DONE / WHAT WAS VERIFIED with an AC → test → result table, gates, CI run "after push", and AC8 as owed to Justin with the plan's live checklist) and the list of image files to attach (one screenshot per AC from `auditor/` or `verifier/`, gate screenshots if you render any: images only, never `.log`/`.txt`; nothing drawn on the images). Check every image you list for emails, URLs, tenant IDs and tokens. Posting waits until the PR is merged and Justin says "post".
5. **Team message** per `story-done-team-message.md` (draft only; it's sent after merge).
6. A dated status line in the shared notes `leorna-workflow.md` (memory folder above): branches, heads, "reviewed, verified, hand-over ready, not pushed; AC8 live owed to Justin".

## Rules

- Load skills and say so: `leorna` (FINISHER role, steps 5–6; read `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md`), `engineering-best-practices`, `git-commit-rules`, `github` (read-only `gh` checks only).
- Change nothing in either worktree: no commit, push, PR, merge or post; no ClickUp writes.
- Never send a server domain, URL or tenant ID anywhere; never print tokens.
- Anything else you find: `found_else` (one line each, with evidence and severity).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is the normal answer. (The shared notes status line in item 6 is the one notes edit you make.)
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`.

## Return

`{status: ready|stopped, summary, diff_stat{client, control_plane}, pr_titles{client, control_plane}, pr_text_paths[], review_prompt_path, clickup_draft_path, clickup_images[], team_message_path, steps_for_justin[], found_else[], skill_lessons[]}`. `status: ready` means the hand-over is complete with AC8 live owed to Justin (say "code-reviewed and verified; live acceptance pending"). End with `MAIN SESSION: check and save these skill_lessons now.`
