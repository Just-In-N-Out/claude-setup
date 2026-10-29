# PLANNER brief (amend AC4): 86bcm901r-starter-packs [leorna]

**Role:** PLANNER for an amendment to the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). One job: **rewrite AC4 so an agent proves it instead of Justin**, prove by a trial run that the check really works, and update the plan. You don't build the story and you don't change the control-plane or client source.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac.

## Justin's decision (2026-10-29, record it in the plan)

Justin asked "Can't you do AC4 by yourself?", then picked **"Agent does it, counts"**: "The planner rewrites AC4 as an agent check. The verifier and a blind auditor each prove it on the merged commit, so ac-check can say ALL ACCEPTED." What he was told it covers: an agent builds a test server from the branch on a fresh database of its own, does the catalog and assignment steps in a headless browser, runs the desktop client's **real Sync code** from client `main` (`f105e27`), not the app window, with a **throwaway home folder and project** (so nothing lands in his real `~/.agents/skills`, `~/.cursor`, `~/.claude` or `~/.codex`), compares the files with the checklist and takes the screenshots. What it can't cover: the Windows app window itself and his real sign-in.

## Inputs

- **Plan (edit this one):** `~/.hermes/plans/leorna/86bcm901r-starter-packs.md`. The approved read-only copy is `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md`: never edit it; the main session reinstalls it from your plan.
- **Current AC4 and its checklist:** the plan's AC4 lines (search `AC4`), `~/.hermes/plans/leorna/evidence/86bcm901r/ac4-live/CHECKLIST.md` and `hand-over/ac4-steps.md` (the steps, expected file lists per tool, and screenshots).
- **Story worktree (read only for you):** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`, head `398af64`. A fixer is merging GitHub `main` (`dd006b7`, PR #98) into it in parallel, so its HEAD will move to a merge commit; never write there. For your trial run use a detached copy of `398af64` in your scratch.
- **Client:** `/home/justin/Leorna/leorna-client` at `main` `f105e27` (a Go + Wails desktop app: `cmd/`, `application/`, `toolinstall/`, `toolconnector/`, `login/`, `desktop/`). Read only; for any build or run use a detached copy (`git worktree add --detach` into your scratch, or `git archive f105e27`), never the main checkout.
- **How ACs are proven and checked:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (how it reads AC lines, `(live)`, `test` names and receipts; what makes it say ALL ACCEPTED). Read both before designing AC4.
- **Dev-mode recipe** (server build, fresh DB, `/dev/login`, page captures): `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md`, search "admin console screenshots work".

## What to do

1. Load the skills below.
2. **Find the headless route (read the client code, then prove it).** How does the client run Sync without its window: an existing CLI under `cmd/`, the `application` layer's sync entry point called from a small Go driver program you write in scratch (importing the client's packages from the detached copy is fine; a driver lives outside both repos), or another route? How does it sign in to a server headlessly: the device/browser login driven by headless Chrome, a dev-mode desktop token, or a stored-credential path? Note: `go-keyring` on Linux needs a Secret Service; find what the client does without one. **Every client run sets `HOME` (and `XDG_*`, `CODEX_HOME`, and any other config-dir variable the client or its tool connectors read) into your scratch. Before the first run, prove by reading the code that no path can resolve to the real `/home/justin`** (Claude Code's own `~/.claude` lives there).
3. **Trial run end to end (a spike, evidence for the plan):** server built from `398af64` in dev mode on a fresh database, the catalog and assignment of `starter-backend-1` to a team that has a project, the client's Sync into a throwaway project and home, then compare the written files with the checklist's expected lists (26 in `<project>/.claude/commands` + `.claude/skills`, 21 in `~/.agents/skills`, 26 in `~/.cursor/commands` + `~/.cursor/skills`; Codex prompts skipped with the reason; agents reported as not installed). Also run it against **base** `6c1709e` and confirm it fails there (no starter pack to assign). Save the spike's logs to `~/.hermes/plans/leorna/86bcm901r-ac4-spike/` (create fresh with `mkdir`; stop if it exists). If the route is blocked (sign-in can't be done headlessly, Sync can't run without the window), stop, say exactly why, and propose the nearest honest check in `questions`.
4. **Design the check so a verifier and a blind auditor can each run it themselves.** The auditor sees only the approved plan, the worktree, the head, the base and its own folder (never other evidence), so everything it needs must be **in the plan** or in a file the plan names outside the evidence folder (e.g. a driver and run script under `~/.hermes/plans/leorna/86bcm901r-ac4/`, read only to them). Prefer **no change to the control-plane repo** (the head is reviewed; a repo change means a builder and more review rounds). If `ac-check.sh` can only accept AC4 with a repo test, say so, plan the smallest addition, and set `needs_builder: true`. The check must fail on base, and it must not be possible to pass by writing to the real home.
5. **Rewrite the plan:**
   - A status line under the existing approval: "**Amended 2026-10-29: AC4 is agent-run (Justin: "Can't you do AC4 by yourself?" → "Agent does it, counts")**".
   - The AC4 line: drop `(live)` (keep `(proposed)` only if the script expects it; check), name the check and its exact command, and the clauses it proves (catalog, assignment, Sync completes in all three tools, Codex prompts skipped with their reason, agents not installed, the per-tool file lists).
   - Every other place that says AC4 is live or owed to Justin: the evidence table, T7, "Notes for later roles" (verifier and auditor now run AC4 with their own server, database, client copy and home; their DB and scratch names), Risks, the hand-over notes and the playback line. The approved head is now the fixer's merge commit (unknown yet): write "the head named in the brief".
   - What AC4 still doesn't cover (the Windows window and Justin's real sign-in), in one line under Risks.
6. Delete your spike's servers, databases and scratch at the end (keep the spike logs folder and any `86bcm901r-ac4/` files the plan names).

## Skills to load first (say so in your first steps)

1. `leorna` (PLANNER role; skip its Step 1 full context load: the plan already has it).
2. `engineering-best-practices`.
3. `implementation-planning`.

## Database, scratch, siblings

- **Databases:** your own only, prefix `leorna_86bcm901r_plan4_` ending `_test`, in the `leorna-test-pg` container (port via `docker port leorna-test-pg 5432/tcp`; `psql` through `docker exec`). The password never goes on a command line or into a log. Never another database, never `leorna-pg`. Drop all of yours at the end.
- **Tools:** Go toolchain in `~/.local/leorna-toolchain` (not on the default PATH: use a task-local PATH). Chrome for Testing as `ac-verification.md` says.
- **Scratch:** `~/.cache/86bcm901r-plan4/`, made fresh with `mkdir` (no `-p`): worktrees, TMPDIR, GOTMPDIR, caches, binaries, the throwaway HOME and project, Chrome profiles. Nothing big on `/tmp`. At the end: `git worktree remove` what you added, stop any server by its verified PID, `rm -r /home/justin/.cache/86bcm901r-plan4` by that literal path.
- Never touch the main checkouts, the story worktree, another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything. A decision only he can make goes in `questions` with a ⭐ recommendation, at the top of the plan too.
- If you find any other bug or problem (in the story or the client), list it in `found_else` (one line each, evidence, severity); don't fix it.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{status: ready|blocked, summary, plan_path, ac4_line, route{sync, sign_in, home_isolation_proof}, spike{head_result, base_result, logs}, check_files[], needs_builder, not_covered, questions[], found_else[], skill_lessons[]}`. `status`, `summary`, `plan_path` and `ac4_line` are required. Plain words.
