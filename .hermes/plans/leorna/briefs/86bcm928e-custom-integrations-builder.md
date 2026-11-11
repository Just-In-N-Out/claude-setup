# BUILDER brief — 86bcm928e custom integrations defined by the admin

Role: BUILDER (fresh general-purpose agent, Opus 5.5, xhigh effort). Pipeline: Full.
Build the approved plan test-first and stop at `ready-for-review`. Don't re-plan or redesign: if the plan is wrong or misses a decision, stop with `status: stopped` and the options. Start no other agents (the main session runs every role; skip any "spawn a subagent / independent reviewer" step in a skill).

- **Approved plan:** `/home/justin/.hermes/plans/leorna/86bcm928e-custom-integrations.md` (read-only copy: `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`). Build exactly its Tasks 0–12.
- **Justin's answers (2026-11-10, bare "go"):** every ⭐ — 1A only `npx` at an exact version or digest-pinned `docker run`; 2A token in a variable or OAuth; 3A no delete; 4A desktop tile list unchanged; 5A your own throwaway Postgres container (`928e-builder-pg`, removed at the end; never touch other containers).
- **Repo:** `/home/justin/Leorna/leorna-control-plane`. Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, from fresh GitHub main (plan Task 0; planned base `4ef14efb46da789aec30fad1e5a988d8770140e2`; if main moved, say so and build on the new SHA). Never touch `.claude/worktrees/*` or the sibling worktrees `/home/justin/Leorna/86bcm92*`, never `git worktree prune`.
- **Evidence root:** `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/` (your files under `builder/`, the per-AC screenshots `ac<n>-*.png` at the root as plan Task 10 says, gate logs `gates-<sha7>.txt`). One test and one screenshot per AC. Screenshots show the result only: no banner, test names, SHA or redaction notes drawn on the image. Look at every image before citing it: no token, e-mail, domain, tenant id or `/dev/login`.

## Justin's words
"Custom integrations defined by the admin do this clickup story" · "yes full pipline i will switch model" · "go"

## Skills: load each with the Skill tool, in order, and say so in one line
1. `leorna` (BUILDER role: steps 2–5 and 4b; skip its Step 1 context load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`, which you read).
2. `engineering-best-practices`
3. `test-driven-development` (a failing test before each code change)
4. `mutation-testing-discipline` (plan Task 8; every mutation run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`)
5. Specialists: `security-best-practices`, `multi-tenant-auth-management`, `backend-data-migrations` (migration 32), `api-contract-drift-guard` (confirm no contract change).
Load `systematic-debugging` when a test fails unexpectedly or a number gets worse; find the cause, don't patch around it.

## Rules
- Identity: plain `git commit -m "feat(86bcm928e): …"`; never pass author flags; no AI attribution or Co-Authored-By lines. Check `git log -1 --pretty=format:'%an <%ae>'` is the Leorna identity before the first commit (don't paste the address into logs or images).
- No push, PR, merge or ClickUp write. No `.github/workflows/*` change, no auth bypass, no repo-wide pattern or `toolconnector.Connector` change. No contract change (plan: API unchanged).
- On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in `<evidence>/builder/INVENTORY.md`. If it can't be decided safely, stop with `status: stopped`.
- Windows desktop (WSL): a command that dies with SIGTERM/143/137/"Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result; if it was, rerun under the memory cap and say so. Use owned disk scratch `~/.cache/928e-builder/` with `TMPDIR` inside; short Chrome profile paths `~/.cache/928e/{t,u}`.
- Don't end your turn to wait for a background command (the lessons gate treats that as finishing). Wait in the foreground with bounded polls under 3 minutes each (Bash `timeout` set above the poll's bound).
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Return
`{name, status: ready-for-review|stopped, summary, base_sha, worktree, branch, last_commit, diff_stat, gates[{label, exit}], ac_tests[{ac, test, red_on_base, green_on_head}], shots[], mutants[], rulings[], stop_reason, found_else[], defect_loop_skills[], skill_lessons[]}`, then end the report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Continuation (2026-11-10, after the first builder was stopped by Justin mid-gates)
The first builder was stopped by the user, not for a code reason, and can't be resumed. You continue its work; don't restart the build:
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, last commit `5fc0826` (11 commits, Tasks 0–10 done per its `builder/INVENTORY.md`). Its container `928e-builder-pg` is still up: reuse it.
- First check `git status`, read `<evidence>/builder/INVENTORY.md` and the existing `gates-*.txt` to see which tasks are done. Check each plan task's completion against the repo and evidence before skipping it; finish any that isn't done.
- Then run Task 11's gates once on the current head, serially, into a fresh `gates-<sha7>.txt`; mark any earlier interrupted run as not the head's result.
- The machine is heavily loaded (load ~45 on 24 cores from other sessions): if a Postgres test times out, rerun it alone before judging. earlyoom kills: `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` (a bare `grep sending` also matches the startup banner).
- Then remove only your own container and stop at `ready-for-review` (Task 12).
