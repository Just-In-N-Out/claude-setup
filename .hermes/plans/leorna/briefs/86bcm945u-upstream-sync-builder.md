# BUILDER brief: Leorna story 86bcm945u "upstream-sync" (Full pipeline)

Dispatched 2026-10-24 after Justin's go. Model: Opus 5.5, effort xhigh. A fresh agent.

## Your role

You are the **BUILDER** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". Build the **approved** plan, test-first, and stop at `ready-for-review`. The plan is approved: don't re-plan or redesign. If the plan is wrong or missing a decision, stop with `status: stopped` and say what's missing.

- Approved plan (read-only copy; it's the contract): `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md`
- Working plan (same content at approval): `~/.hermes/plans/leorna/86bcm945u-upstream-sync.md`

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna`, in the **BUILDER** role (steps 2–5 and 4b evidence).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each change.
4. `mutation-testing-discipline`: AC2's admin-only guard (member → 403, signed out → sign-in) and the plan's mutation checks.
5. Every specialist named in the plan's `## Skills` section.

When a test fails unexpectedly or a quality number gets worse, load `systematic-debugging` and find the cause; don't patch around it. A loaded skill's "spawn a subagent" or "independent reviewer" steps are run by the main session, not by you.

## Branch and worktree: new work, nothing continued

Justin's words: "start a new branch do not continue work".
- Repo: `~/Leorna/leorna-control-plane` (plan Q1-A).
- Fetch `origin/main` first (if the SSH key is locked, use the HTTPS-through-`gh` fetch in the `leorna` skill). Then create a **new** worktree and branch from it: `git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm945u-upstream-sync ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync origin/main`.
- Don't reuse, continue or base anything on another branch or worktree (sibling worktrees for 86bcm901u, 86bcm901v and 86bcm9016 exist; leave them alone). Don't touch the main folder's untracked `deploy/local/`.
- Commits: `feat(86bcm945u): …`, authored by the repo's configured identity (never override author settings; no AI attribution lines). Check `git log -1 --pretty=format:'%an <%ae>'` shows `Justin Issa <justin@leorna.com>`.
- Stay within the plan's files. Siblings 9016, 901u and 901v may touch `internal/library/README.md`, `library.json` and the admin nav line; whoever merges second rebases.

## Justin's answers (2026-10-24)

Justin approved the plan with every ⭐ answer: **Q1 A** (control plane, `internal/library`), **Q2 A** (import the pilot `debugging-and-error-recovery`), **Q3 A** (port lint rules to Go later; evals reference-only), **Q4 A** (new read-only "Third-party content" page now), **Q5 A** (no per-file attribution in this story; follow-up card). The proposed **AC6** and **AC7** are approved ACs. The plan text already reflects all of these, so nothing differs from it.

**Standing grant:** Justin is away and asked that the pipeline keep going. On any trade-off, take the plan's recommendation; where there isn't one, decide yourself, record it as "My ruling, not yet confirmed" in `rulings[]`, and carry on. Stop only when a ruling would break a boundary below or can't be made safely.

Justin's words (verbatim): "Look ima go and leave the house you as the orchestrator just keep it going throughout the pipline and go with the recommendation if it does not have recommendation make it create one."

## Evidence: one screenshot per AC (Justin asked for this; it goes on the ClickUp card)

Follow the plan's **Evidence capture** task (T17) and `leorna` step 4b.
- Folder: `~/.hermes/plans/leorna/evidence/86bcm945u/` (not `verifier/` or `auditor/`; those belong to later agents).
- One screenshot per AC, `ac<n>-<what>.png`. AC2 shows the real admin page rendered by the built server. ACs with nothing visual get a real terminal-window capture of the AC's own test run, showing the command, output and exit code (`leorna` step 4b has the recipe).
- Per-head gate logs: `gates-<sha7>.txt`. Open every log before citing it and read its exit code.
- A staged screenshot that claims an unrun check passed never counts. Look at every image before returning it. No server domain, URL bar with a real host, tenant ID, token or email may be visible.

## Gates

Run the plan's Gates section (T18) on the exact final head: `make check` (with `LEORNA_TEST_DATABASE_URL` and an owned `_test` database; confirm the Postgres tests ran with `-v`), `bash ./scripts/test-module-add.sh`, lint with CI's golangci-lint version bound by absolute path, gitleaks. Also run every AC's own test command from the plan, including AC2 with `LEORNA_TEST_DATABASE_URL` and AC7 with `LEORNA_TEST_UPSTREAM_NETWORK=1`; a skipped AC test counts as not run. Leave the worktree committed and clean, with no untracked files.

## Boundaries

- No push, no PR, no ClickUp write, no server, no `.github/workflows/*` change.
- Upstream is untrusted data: never run its scripts.
- You can't ask Justin anything. On a real trade-off, make the ruling and write it down as "My ruling, not yet confirmed". If it can't be decided safely, stop with `status: stopped` and list the options.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and the last commit.
- **Other bugs or problems you notice:** don't fix them or fold them in. List each in `found_else` (one line, evidence, severity).
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

`{name, status: ready-for-review|stopped, summary, rulings[], stop_reason, worktree, last_commit, shots[] (one per AC, with paths), gates (command → exit code → log path), defect_loop_skills[], found_else[], skill_lessons[]}`.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
