# BUILDER 2 brief: 86bcxnymy, Client self-update (Part 2: client)

**Role:** BUILDER 2 for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), pipeline **Full**. **Model:** Opus 5.5, effort xhigh.

**The plan is approved; don't re-plan.** Approved copy (read-only, the contract): `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md`. Read it in full first, especially Design (D2, D8–D12), "Tasks — Part 2: client (builder 2)", "Two-repo verification mechanics", "Host prerequisites", "Live checklist for AC8" and "Justin's answers" at the end (every ⭐: Q1–Q8 all A).

## Your scope

Build **Part 2 only** (tasks C1–C11) in `~/Leorna/leorna-client`, test first, and stop at `ready-for-review`. Don't edit the control-plane repo.

**Builder 1's control-plane result (built and ready for review):**
- worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head **`2d640f123d84bb396ef6581f481280628e8a653e`**, base `4ef14ef…`.
- D7 form fields and page markers are exactly as the plan says; to clear the pin post `version=` (empty) for "No pin".
- Its evidence and the dev-mode demo recipe (real device sign-in, check-ins, captures with emails masked): `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/builder-cp/` (INVENTORY.md, `demo-run.log`, `scripts/`). Reuse what helps C1/C7.
- A fresh reviewer is reviewing that control-plane head **right now, in parallel**. Treat that worktree as read-only: build the control-plane binary for your end-to-end tests from a **detached copy** of `2d640f1` (`git -C ~/Leorna/leorna-control-plane worktree add --detach ~/.cache/86bcxnymy-b2/cp 2d640f1`, removed with `git worktree remove --force` on that path at the end; never a repo-wide `git worktree prune`), and copy the contract (C2) from `git show 2d640f1:contracts/control-plane.openapi.yaml`. If a later review fix changes the control plane, the main session will tell you; build against `2d640f1` until then and record that head in your report.

## The ask (rewritten)

The client asks its control plane which version to run (`POST /v1/client/update-check`), downloads that release's `leorna-client.exe` from the approved link, checks it against the SHA-256 the control plane gives, swaps its own running exe and restarts when no Sync, Restore or install is running; a checksum mismatch is refused, the current version kept and the failure reported (`POST /v1/client/update-reports`); if the new version's window never loads on its first launch, the previous version comes back on the next launch; the client moves to whatever version the admin targets, older ones included (rollback). No signing yet; leave the plan's named seam for 86bcm9031. The released exe gets a version stamp. AC1–AC7 are proven by the named tests in this repo; AC8 (live) is owed to Justin.

**Justin's words:** "Client self-update to the admin-approved version, with staged rollout do this clickup story" and, for approval, "start the buiilder after done".

## How to work

1. Load skills in this order and say so: `leorna` (BUILDER role; its Step 1 context load; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `authorized-write-safety`, `api-contract-drift-guard` (ends with "Mandatory Validation and Agent Defect Loop"; the main session runs that loop), `frontend-testing-workflow`. A skill's "spawn a subagent" or "independent reviewer" steps are run by the main session, not you.
2. **Worktree:** check GitHub `main` of leorna-client again (the `leorna` skill's step 7.1 fetch). Fast-forward the main checkout's `main` too when it is on `main` with no tracked changes (memory note "Update main before a Leorna worktree"; it was 33 behind). Create the worktree at `~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update` on branch `feat/86bcxnymy-client-self-update` from that SHA (plan base `a7839b3a…`; if `main` moved, use the new SHA and say so).
3. Start with **C1 (harness proof)**: if the end-to-end harness can't sign in against the dev-mode server, stop and report (the plan names the fallback).
4. One commit per task, `feat(86bcxnymy): …` (C2's snapshot refresh is its own `chore(86bcxnymy): refresh the contract snapshot` commit before the commit that uses the operations), each green. Write each test first and see it fail for the stated reason; each AC test must fail on the base. No `.github/` change, no new module. Identity comes from `~/.gitconfig`'s includeIf; never override it, no AI attribution or session lines in commits, never commit `CLAUDE.md`.
5. **Host:** follow the plan's "Host prerequisites" (Go at `~/.local/leorna-toolchain/go`; client `make check` needs a real, short, non-symlinked `TMPDIR`: `~/.cache/86bcxnymy-b2/tmp`; Chrome `--user-data-dir` short too). Postgres for the dev-mode control plane: `leorna-test-pg` with **your own database name** (the reviewer uses the same container; never drop a database you didn't create). AC7 runs a cgo-free Windows test binary through WSL interop (`CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go test -mod=vendor -c`). Run mutation tests under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; each mutation re-run writes into its own new folder, never an earlier run's.
6. **Evidence:** save gate logs with real exit codes, one log and one screenshot per AC1–AC7 (a terminal capture of the run where nothing is visual) and the contract `cmp` to `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/builder/`. Screenshots show the result only: no URL bar, server domain, tenant ID, token or email visible, and no banner, test name, SHA or redaction note drawn on the image. Open every log before citing it.
7. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in an `INVENTORY.md` in your evidence folder. If it can't be decided safely, or the plan is wrong or missing a decision, stop with `status: stopped` and list the options; don't redesign. A control-plane defect you hit goes in your report (don't fix the other repo).
8. If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
9. Long waits: Claude Code moves a foreground command to the background after about 180 s. Don't end your turn to wait for a background command; poll in the foreground in steps under 3 minutes with the Bash `timeout` set above the bound.

## Rules

- Never push, open a PR, merge or post to ClickUp. Never send a server domain, URL or tenant ID anywhere; never print tokens. Never write into Justin's real `~/.codex` or `~/.claude`; the client runs in a scratch HOME.
- If you find another bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the cap above.

## Return

`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, branch, base, last_commit, control_plane_head_used, shots[], ac_status[{ac, accepted, test, screenshot, evidence}], defect_loop_skills[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
