# BUILDER brief: 86bcm928p connection test for integrations

Role: BUILDER (fresh general-purpose agent, Opus 5.5, xhigh effort). Pipeline: Full. Build the approved plan; don't re-plan, and start no other agents (the main session runs every role).

- **Approved plan:** `/home/justin/.hermes/plans/leorna/86bcm928p-integration-connection-test.md`. Justin approved it on 2026-11-10 with every ⭐ option (Q1 A, Q2 A, Q3 A; see its "Justin's answers"). His words: "start the planner when the planner comes back go with recommended and go". The frozen copy `ac-check.sh` reads is `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`. Don't edit either.
- **Repo:** `leorna-control-plane` only. Branch `feat/86bcm928p-integration-connection-test`, worktree `/home/justin/Leorna/86bcm928p-integration-connection-test`, made from fresh GitHub main exactly as the plan's Task 0 says. The client repo is untouched.
- **Evidence root:** `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/`. Your folder there is `builder/`. Keep scratch in `~/.cache/86bcm928p-builder/` (the plan's paths), never in the shared `/tmp`.
- **ACs (from the approved plan):**
  - AC1: Test on a configured integration checks reachability of the URL / MCP endpoint and shows the result, with no user credentials. Test: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres`.
  - AC2: a failure says what failed (DNS, TLS, unreachable, not an MCP endpoint). Test: `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`.
  - No `(live)` ACs.

## What to do
Follow the plan's Tasks in order, test first: RED, then GREEN, then commit per task, with the commit messages it gives. Stop with `status: ready-for-review` once every task, the gates and the evidence are done and the worktree is committed and clean (`git status --porcelain --untracked-files=all` empty).
- The plan's "Code" section was prototyped by the planner on base `4ef14ef`. If main has moved and something no longer fits, or the plan is wrong or missing a decision, don't redesign. Stop with `status: stopped`, give the evidence and the options, and the main session sends it back to a planner. A small ruling that changes no AC goes in `rulings[]` as "My ruling, not yet confirmed" and in the HANDOFF/evidence `INVENTORY.md`.
- Run the guard mutants the plan lists (`mutation-testing-discipline`), always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Run every gate the plan lists on the final head, and save the logs as `builder/gates-<sha7>.txt`.
- **Evidence:** one real screenshot per AC, as the plan's evidence task says (the browser pictures of the Test result: pass, and each failure kind). **No banner on evidence images** (Justin, 2026-11-10): an image shows the result only, with no caption, label or note about how it was made (no "local rendering", test names, stub, SHA, "lines elided", "N ids redacted"). That information goes in the local log or receipt. No server domain, tenant ID, token or email may be visible. Look at every PNG you produce before you cite it.
- Hand-over only: never push, open a PR, post to ClickUp or merge. Never override the git author. Check `git log -1 --pretty=format:'%an <%ae>'` is Justin's Leorna identity before the first commit. Add no AI attribution or co-author lines. Never commit `CLAUDE.md`.
- Leave sibling worktrees, branches and containers alone. Don't run a repo-wide `git worktree prune`; remove only your own detached copies with `git worktree remove --force <own path>`.

## Skills: load each with the Skill tool, in this order, and say so in one line
1. `leorna` (the BUILDER role: steps 2–5 and 4b; skip the Step 1 context load except the repo's AGENTS.md and `leorna-control-plane-workflow.md`)
2. `engineering-best-practices`
3. `test-driven-development`
4. `mutation-testing-discipline` (the SSRF and admin guards)
5. `security-best-practices` (GO-SSRF-001, GO-HTTPCLIENT-001) and `multi-tenant-auth-management`

Load `systematic-debugging` whenever a test fails unexpectedly; find the cause, don't patch around it.

## Windows desktop rules
- This is WSL. A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a pass or fail. If it was a kill, say so, find what grew, and rerun under the cap.
- Keep all scratch in your own `~/.cache/86bcm928p-builder/` (create it fresh with `mkdir` without `-p`). Remove only that folder, by its literal absolute path. Point `TMPDIR` and Chrome profiles there, with short paths for Chrome sockets.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls of under 3 minutes each, with the Bash `timeout` set above the bound.

## Report rules
- `found_else`: any other bug or problem you find goes in a list (one line each, with evidence and severity). Don't fix it or fold it in.
- `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section: list reusable lessons. Never edit skills or memory yourself. `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs) when the lesson is about a rule that was broken or nearly broken. An empty list is normal.
- Return `{name, status: ready-for-review|stopped, summary, rulings[], worktree, branch, base, last_commit, shots[], gates[], mutants, found_else[], defect_loop_skills[], skill_lessons[], stop_reason}`, then end the report with the line `MAIN SESSION: check and save these skill_lessons now.`
