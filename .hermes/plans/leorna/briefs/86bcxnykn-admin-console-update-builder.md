# BUILDER brief: 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: BUILDER (a fresh general-purpose agent on Opus 5.5, xhigh effort). Pipeline: Full. Build the approved plan test-first and stop at `status: ready-for-review`. Don't re-plan or redesign. If the plan is wrong or missing a decision, stop with `status: stopped` and list the options. Don't review your own work, and start no other agents: the main session runs every role.

- **Approved plan:** `/home/justin/.hermes/plans/leorna/86bcxnykn-admin-console-update.md`. A read-only copy, which is what `ac-check.sh` reads, is at `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Read the whole plan, including "Justin's answers" at the end: every ⭐ option is chosen (Q1 A, Q2 A, Q3 A, Q4 A).
- **Repo:** `/home/justin/Leorna/leorna-control-plane`. Base: GitHub `main` `4ef14efb46da789aec30fad1e5a988d8770140e2`, or newer if main moved; record the SHA you start from.
- **Worktree and branch:** `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`, created from fresh GitHub main. Fetch over HTTPS with gh (the `leorna` skill's step 7.1 command, URL written out, never in a variable). The main checkout's local `main` is about 4 commits behind; if it is on `main` with no tracked changes, fast-forward it with `git merge --ff-only origin/main` (stop and report if it refuses), then add your worktree. Don't touch `.claude/worktrees/*`, other worktrees or other branches, and never run `git worktree prune`.
- **Evidence root:** `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`. You write in `build/` and the files the plan's Evidence section names. Never write in `verifier/`, `auditor/` or `review-*/`.

## The request
Story 86bcxnykn: the admin console shows when a newer stable Leorna release exists, with its release notes, and lets an admin update with one click. The control plane redeploys itself to that release's image digest and runs its forward-only migrations. If the new version fails its health check, the previous digest is redeployed automatically and the admin sees why. Every update and rollback is audited (who, from, to, result).
Justin's words: "Update the control plane in place from the admin console (with rollback) do this clickup story". Then, on approval: "nah keep them working ok" (auto-go with the recommended options).

## Acceptance criteria (from the approved plan; each must have a passing test that fails on the base commit)
- AC1: `TestControlPlaneUpdateAC1OfferWithPostgres`
- AC2: `TestControlPlaneUpdateAC2RedeployWithPostgres`
- AC3: `TestControlPlaneUpdateAC3RollbackWithPostgres`
- AC4: `TestControlPlaneUpdateAC4AuditWithPostgres`
- AC5 (proposed) (live): Justin runs it on his dev server. You don't run it. You write the README "Live check" runbook the plan names.
Read each AC's full line in the plan: those lines are the contract. Don't rename the tests and don't change what they assert.

## Skills: load each one with the Skill tool in this order, and say so in one line
1. `leorna` (BUILDER role: steps 2–5, with evidence as you go in step 4b).
2. `engineering-best-practices`
3. `test-driven-development` (a failing test before each change; one commit per task, each green).
4. `mutation-testing-discipline`: this story has guards (admin-only routes, the store's admin recheck, another tenant's admin refused, digest-only images, never `latest`, no secret in logs). Prove each key assertion catches a deliberate break, then restore it. Run mutation runs under a memory cap: `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
5. Specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`, `authorized-write-safety` (the Scaleway adapter: tests use the fake only, never the real API).
If a test fails unexpectedly, load `systematic-debugging` and find the cause rather than patching around it.

## Rules
- **No real cloud or network writes:** no real Scaleway call, no real GitHub release write, no push, PR or ClickUp write. Fakes only (the plan's `updatetest` package). Don't print tokens or keys.
- No `.github/workflows/*` change, no auth bypass or dev-login shortcut, no repo-wide pattern change (list those as follow-ups). `deploy/local/` stays untouched.
- Commit as the repo's configured identity with plain `git commit -m` (never override the author; no AI attribution lines). Verify with `git log -1 --pretty=format:'%an <%ae>'` (expected `Justin Issa <justin@leorna.com>`). Never commit `CLAUDE.md`.
- Gates: the plan's "Gates" section on your final head, with real output saved to `gates-<sha7>.txt` in the evidence root. Go, golangci-lint and govulncheck are bound by absolute path from `~/.local/leorna-tools/`. `leorna-test-pg` is stopped, so run your own capped Postgres container (named for this story) and record its name. The Postgres no-skip check from the `leorna` skill must pass: no DB test may skip for a missing DSN.
- **Evidence:** one screenshot per AC as the plan's Evidence section says. Real console captures through headless Chrome against a local server with fixtures where the plan says so; otherwise a terminal capture of the AC's run rendered in Chrome (the WSL recipe in `ac-verification.md`). **The images show the result only: no banner, label, test name, "local rendering", stub, SHA or redaction note drawn on the image** (Justin's rule); put that context in the log or an INVENTORY.md beside it. Before saving, check every image for a server domain, URL bar, tenant ID, token or email. Each AC also gets its test log `ac<n>-<head7>.log` (first line `HEAD=<sha>`, last line `EXIT=<rc>`), and its exact command goes in INVENTORY.md.
- **Rulings:** on a real trade-off the plan doesn't settle, make the ruling and write it down as "My ruling, not yet confirmed" in `rulings[]` and in the evidence `INVENTORY.md`. If the ruling changes what an AC says, stop and report instead.
- **Memory (WSL desktop):** follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command that dies with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a test result. Rerun such a check under the memory cap above.
- **Scratch:** keep all scratch in your own `~/.cache/86bcxnykn-builder/` folder, created fresh with `mkdir` (no `-p`). Point `TMPDIR`, Go temp and Chrome profiles there, with short socket paths (for example `~/.cache/86bcxnykn-builder/t`). The session scratchpad on `/tmp` is a small RAM tmpfs shared by every agent.
- Don't end your turn to wait for a background command (the lessons gate treats that as finishing). Wait in the foreground with bounded polls of under 3 minutes each, with the Bash `timeout` set above each poll's bound.
- If you run low on steps, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`, naming the worktree and the last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (its kind, what it checks, where it runs). An empty list is the normal answer.

## Return
`{name, status: ready-for-review|stopped, base_sha, summary, rulings[], steps_for_justin[], stop_reason, worktree, branch, last_commit, gates, ac_status[{ac, test, log, screenshot, passes_on_head, fails_on_base}], shots[], postgres_container, found_else[], defect_loop_skills[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
