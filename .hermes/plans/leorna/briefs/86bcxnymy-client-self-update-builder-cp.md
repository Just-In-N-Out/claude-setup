# BUILDER 1 brief: 86bcxnymy, Client self-update (Part 1: control plane)

**Role:** BUILDER 1 for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), pipeline **Full**. **Model:** Opus 5.5, effort xhigh.

**The plan is approved; don't re-plan.** Approved copy (read-only, the contract): `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md`. Working copy: `~/.hermes/plans/leorna/86bcxnymy-client-self-update.md`. Read the plan in full first, especially Design (D2–D7, D11, D12), "Tasks — Part 1: control plane (builder 1)", "Two-repo verification mechanics", "Host prerequisites" and "Justin's answers" at the end.

## Your scope

Build **Part 1 only** (tasks P1–P8) in `~/Leorna/leorna-control-plane`, test first, and stop at `ready-for-review`. Builder 2 builds Part 2 (the client) after you, from your head. Don't touch the client repo.

## The ask (rewritten)

Justin approved the plan with every ⭐ answer (Q1–Q8 all A): download link per approved version (default GitHub Release), groups = teams plus ticked clients, percentage rollout in this story, 30-day count window, admin pastes the SHA-256, two builders in a row. On the control plane that means: migration, `internal/clientupdate` rules, store methods, the two client endpoints in OpenAPI (`POST /v1/client/update-check`, `POST /v1/client/update-reports`), the server-rendered admin page `/admin/client-versions` with audit records, docs and the `delivery/stories.json` entry.

**Justin's words:** "Client self-update to the admin-approved version, with staged rollout do this clickup story" and, for approval, "start the buiilder after done".

## How to work

1. Load skills in this order and say so: `leorna` (BUILDER role; its Step 1 context load; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `authorized-write-safety`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. A skill's "spawn a subagent" or "independent reviewer" steps are run by the main session, not you.
2. **Worktree:** check GitHub `main` again (the `leorna` skill's step 7.1 fetch). Fast-forward the main checkout's `main` too when it's on `main` with no tracked changes (memory note "Update main before a Leorna worktree"). Create the worktree at `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update` on branch `feat/86bcxnymy-client-self-update` from that SHA (plan base `4ef14efb…`; if `main` moved, use the new SHA and say so). Never run a repo-wide `git worktree prune`.
3. **Migration number:** before P2, check the highest migration number on GitHub `main` and on open sibling branches/PRs (`gh pr list -R LeornaAI/leorna-control-plane`, local `feat/` branches). The sibling story 86bcxnykn (control-plane in-place update) is being planned now and may also take `000032`. Use the next free number on `main`; if a sibling's open branch already uses it, keep yours and record the clash in `rulings[]` so the merge-second story renumbers.
4. One commit per task, `feat(86bcxnymy): …`, each green. Write each test first and see it fail for the stated reason. No `.github/` change. Identity comes from `~/.gitconfig`'s includeIf; never override it, no AI attribution lines, never commit `CLAUDE.md`.
5. **Host:** follow the plan's "Host prerequisites" (Go at `~/.local/leorna-toolchain/go`; `docker start leorna-test-pg` for Postgres tests; short real `TMPDIR` at `~/.cache/86bcxnymy-cp/tmp`). Run mutation tests under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
6. **Evidence:** save gate logs with real exit codes and the admin-page screenshots to `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/builder-cp/`. Screenshots show the result only: no URL bar, server domain, tenant ID, token or email visible, and no banner, test name, SHA or redaction note drawn on the image. Open every log before citing it.
7. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in an `INVENTORY.md` in your evidence folder. If it can't be decided safely, or the plan is wrong or missing a decision, stop with `status: stopped` and list the options; don't redesign.
8. If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
9. Long waits: Claude Code moves a foreground command to the background after about 180 s. Don't end your turn to wait for a background command; poll in the foreground in steps under 3 minutes (set the Bash `timeout` above the bound).

## Rules

- Never push, open a PR, merge or post to ClickUp. Never send a server domain, URL or tenant ID anywhere; never print tokens.
- If you find another bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the `systemd-run` cap above.

## Return

`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, branch, base, last_commit, shots[], ac_status[{ac, accepted, test, screenshot, evidence}], defect_loop_skills[], found_else[], skill_lessons[]}` (control-plane supporting receipts for the ACs they back; AC tests themselves live in the client repo, so mark them `not_run`). End with `MAIN SESSION: check and save these skill_lessons now.`
