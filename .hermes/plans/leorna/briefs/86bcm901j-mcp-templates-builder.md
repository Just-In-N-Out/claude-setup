# BUILDER brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full**. Model: Opus 5.5, xhigh.

## Your role

You are the **BUILDER**. Build the **approved plan** test-first and stop at `ready-for-review`. The plan is approved: don't re-plan. If the plan turns out wrong or is missing a decision you can't make safely, stop with `status: stopped` and list the options; never redesign on your own.

- **Approved plan (build from this):** `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`. Read it in full, including `## Justin's answers (2026-10-28)` at the end. A read-only copy is at `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`: never edit, move or replace that copy.
- **Acceptance criteria:** AC1–AC5 exactly as the plan states them (AC4 and AC5 were proposed and are now approved; none is live). One test per AC with the plan's exact name, plus the failure cases the plan lists.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna`: follow it in the **BUILDER** role (Doing a story, steps 2–5 and 4b). Skip its Step 1 full context load except what the plan points you to; the planner already did it.
2. `engineering-best-practices`
3. `test-driven-development`: a failing test before each change; prove key assertions catch a deliberate break, then restore.
4. `security-best-practices`: Justin requires it for every role on this story.
5. `mutation-testing-discipline`: the new policy stage is a security guard (secrets, pins, least-privilege floors, tool declarations).
6. `systematic-debugging` whenever a test fails unexpectedly; find the cause, don't patch around it.

## Justin's answers (summary; the plan's section is the source)

- Q1 A, Q2 A, Q3 A, Q4 A: as the plan is written.
- **Q4 / AC5:** real Codex and Claude Code run only in throwaway homes inside your scratch folder, never Justin's real `~/.codex` or `~/.claude`.
- **Q5 A:** install Go and CI's tools (golangci-lint, govulncheck at CI's pinned versions) under `~/.local/leorna-tools` as the plan's Task 0 says. Other sessions (86bcm901a, 86bcm901b, 86bcm901w) may install the same tools at the same path at the same time: check first, reuse a working install whose versions match, never overwrite or delete another session's install, and install atomically (into a temp folder, then rename). **Docker inside Ubuntu is Justin's step and is owed:** while `docker` / `leorna-test-pg` is unavailable, don't stop. Build everything, run every gate that doesn't need Postgres, and record the Postgres gates and anything that needs `leorna-test-pg` as **NOT RUN, owed: Docker WSL integration not enabled yet**. If Docker becomes available while you work (check once near the end), run them then, with the story-owned database named in the plan (`leorna_86bcm901j_test` or the plan's role-specific name).
- **Q6: held for Justin.** Don't run Chrome or anything else outside the sandbox, and don't change permissions or settings. Take screenshots by any route that works inside the current sandbox. If none works, save the logs and mark those screenshots **owed**, naming them in your report.

## Where to work

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`, base `1ee7157` (= `origin/main`, checked by the main session just before dispatch). Always pass absolute paths or `cd` into the worktree in the same command.
- **Never** switch the main checkout's branch (`~/Leorna/leorna-control-plane`, on `main`) or edit anything there. **Never touch** other worktrees, branches, test databases or evidence folders: right now `86bcm901a-agent-definitions` and `86bcm901w-create-pack` worktrees exist, and `86bcm901b` may appear. Stay within this plan's files; shared files (`delivery/stories.json`, `library.json`, `content.lock.json`, `README.md`, the gate tests) are reconciled at hand-over, not now.
- **Commits:** `feat(86bcm901j): …`, plain `git commit` with the repo's config (identity `Justin Issa <justin@leorna.com>`; check with `git log -1 --pretty=format:'%an <%ae>'`). Never override author metadata, never add a `Co-Authored-By` or any AI attribution line, never stage a `CLAUDE.md`. Follow `git-commit-rules`. **Never push, open a PR, merge, or write to ClickUp.**
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901j/` (plan Task E and `leorna` step 4b): one screenshot per AC `ac<n>-<what>.png`, gate logs `gates-<sha7>.txt` with recorded exit codes, and an `INVENTORY.md` (AC → test → log → screenshot, plus owed items). Don't create or write in `verifier/` or `auditor/` there; those belong to later roles.
- **Scratch:** create `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-builder/` with `mkdir` (no `-p`, so it fails if it exists) and keep all scratch there, including throwaway homes and any base-commit worktree. The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folder when done (after `git worktree remove` for any scratch worktree you added).
- **Machine:** the Windows desktop (Ubuntu under WSL), not the Mac. Never put a token, password or DB URL on a command line that gets logged or captured.

## Done means (`ready-for-review`)

- Every task in the plan built, test-first, AC1–AC5 tests passing on the final head, and each AC test shown to fail on the base commit as the plan's base-commit check describes (save those logs too).
- The plan's gates run on the final head with logs saved (Postgres gates NOT RUN and owed if Docker is still missing; gitleaks run).
- Worktree committed and clean (`git status --porcelain --untracked-files=all` empty).
- Docs & records task done for the files the build owns (the README, `delivery/stories.json` entry as the plan says). Notes in `$MEM` and the PR text, team message and ClickUp draft are the finisher's, later.

## Rules

- You can't ask Justin anything. On a real trade-off, make the ruling and write it as "My ruling, not yet confirmed" in `rulings[]` and in `INVENTORY.md`. If it can't be decided safely, stop with `status: stopped` and list the options.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- **Other bugs or problems you find:** don't fix them or fold them in; list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- A loaded skill's "spawn a subagent" or "independent reviewer" step is run by the main session, not by you.
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{name: "86bcm901j-mcp-templates", status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, base, ac_tests[{ac, test, head_log, base_log, screenshot_or_owed}], gates[{name, exit, log}], owed[], shots[], defect_loop_skills[], found_else[], skill_lessons[]}`. Plain words.
