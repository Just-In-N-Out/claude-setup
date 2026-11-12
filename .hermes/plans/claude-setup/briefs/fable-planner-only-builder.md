# Brief: builder — fable-planner-only (Mini)

**Role:** BUILDER. Justin approved the plan with "go" on 2026-11-11. Build it exactly as written; don't redesign. You don't start other agents.

**Approved plan (read first, follow its "Tasks" section step by step):** `~/.hermes/plans/claude-setup/evidence/fable-planner-only/plan-approved.md` (read-only copy; the plan's code blocks — "The test diff" and "The wording edits" — are the exact text to apply).

**Skills to load first (Skill tool):** `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`.

**Read before you start:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` (there is no project skill for the setup repo).

## ACs (all must be green, one log + one terminal-capture image each in the evidence folder)

- AC1: `routing_text_agrees` — every routing file gives round 1 to Opus 5.5 xhigh and Fable to the planner only, Codex `AGENTS.md` built from the checkout included, no retired wording left.
- AC2: `fable_only_plans` — Fable on any non-planner role fails and names the place; an unchanged copy passes.
- AC3: `xhigh_only_where_routed` — "round 1 on Opus 5.5 xhigh" passes check 7; xhigh on a later round, fixer, verifier or main session, or plain high on round 1, fails.

Run each as `bash <worktree>/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh <test>`.

## Where and how

- Worktree `~/.claude-setup-wt/fable-planner-only` on branch `fable-planner-only` from the setup repo's `main` (plan task 1). `main` may have moved since the plan (it was `9b765a25`); if the edit script refuses an old text, stop and report — don't hand-edit around it.
- Evidence folder `E = ~/.hermes/plans/claude-setup/evidence/fable-planner-only/` — put your logs in `E/builder/` (red.log, green logs per AC, mutations.log, captures).
- One commit of exactly the seven files, plain `git commit -m "…"`: no author override, no `-c user.*`, no Co-Authored-By / AI trailer. `CLAUDE.md` is allowed in this repo.
- Stop at `ready-for-review`. Don't merge, run `sync.sh`, or push.

## Rules for every agent

- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if it was, say so and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Mutation runs always use that cap.
- `grep` in the Bash tool is ugrep and `find` is bfs; use `/usr/bin/grep` and `/usr/bin/find`.
- **skill_lessons:** list reusable lessons as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is the normal answer. Never edit skills or memory yourself.

## Report back

At most 30 lines: `status: ready-for-review` (or `stopped` + reason), worktree path, branch, base SHA, head SHA, `git diff --name-only base HEAD`, each AC's result and evidence file, mutations caught (Ta–Tf), `found_else` (anything off you noticed but didn't touch), `skill_lessons`, and end with the line:
`MAIN SESSION: check and save these skill_lessons now.`
