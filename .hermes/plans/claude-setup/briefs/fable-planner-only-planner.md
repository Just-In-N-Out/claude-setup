# Brief: planner — fable-planner-only (Mini)

**Role:** PLANNER, Mini pipeline. You write one file only: `~/.hermes/plans/claude-setup/fable-planner-only.md`. No edits to skills, scripts, hooks, CLAUDE.md, settings or memory. You don't start other agents.

**Skills to load first (Skill tool):** `engineering-best-practices`, `implementation-planning`.

Mini mode: load only the code/docs sections this touches; skip any full context load; finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## The request (Justin, 2026-11-11)

"In the pipeline, only put Fable 5.2 high as the planner and remove it from the rest." Then, asked how to run it: "do reviewer opus 5.5 xhigh and run mini".

Read as (the main session's reading; put it as a question at the top only if you find it doesn't hold):
- **Planner:** Fable 5.2 high (unchanged). The only Fable role anywhere in the pipeline.
- **Reviewer, round 1:** Fable 5.2 high → **Opus 5.5 xhigh** (Full and Mini).
- **Reviewer, later rounds** (Full's whole-story round 2, the delta rounds, a full round the referee asks for): **unchanged, Opus 5.5 high**.
- Every other role unchanged: builder Opus 5.5 xhigh; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high.

New one-line routing: planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Opus 5.5 xhigh, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high.

## What the plan must cover

1. **Every place the routing is stated**, for Full and Mini. Known hits from a grep for `Fable` (check each, and grep further for `round 1`, `round-1`, `Fable review`, `Fable full review`, `model: "fable"`):
   - `~/.claude/CLAUDE.md`: the pipeline paragraph (`planner and round-1 reviewer \`model: "fable"\``), step 5 (`round 1 on Fable 5.2 high`), the "Agent models" bullet (add a dated *Why* line: user 2026-11-11).
   - `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` (role table, one-line routing, the Mini summary line ~29 "one full fresh Fable review", review order line ~110, line ~278 "a fresh **Fable 5.2 high full review**"), and its `references/mini-pipeline.md`, `review-loop.md`, `model-routing.md`, `away-and-recovery.md`.
   - `~/.hermes/skills/software-development/leorna/SKILL.md` and `review-fix-cadence/SKILL.md` ("fresh Fable full review 1", "Round 1 is a fresh Fable 5.2 high reviewer").
   - Project `CLAUDE.md` copies under `~/.claude/project-docs/*/CLAUDE.md`. Note memory `~/.claude/projects/-home-justin/memory/sync-overwrites-copies.md`: `sync.sh` overwrites a project-docs copy from the project's own `CLAUDE.md`, and rewrites `~/.hermes/skills-library-local.patch` from the `~/.hermes/skills-library` clone. Work out which real file each edit must land in so sync doesn't undo it.
   - `~/.codex/AGENTS.md` is generated from `~/.claude/CLAUDE.md` by `~/.claude/setup/codex/` — regenerated, never hand-edited.
   - Lines that mention Fable for other reasons (the "Only these models" list, Sol-substitute text "Opus or Fable", the Opus-limit question, the *Why* history notes, token-report scripts and their pricing) stay. Say which you're leaving and why.
2. **`feature-dispatch/scripts/pipeline-rules.test.sh`** pins the current wording (ROUTING string, `row ... 'Reviewer, round 1' '**Fable 5.2**'`, the CLAUDE.md pipeline-paragraph phrase, the per-file phrase list, and check #7 "no clause pairs a later round, a fixer, the verifier or the main session with Fable or xhigh"). Plan its update test-first: the test must fail on today's files and pass after the edit. Also make it refuse Fable on any non-planner role (at least round-1 reviewer), and make sure the new `round 1 … xhigh` wording doesn't trip check #7 while a later-round xhigh still does. Name the mutations the builder must show it catches.
3. Numbered ACs AC1…ACn, each with one named test (a command whose terminal capture is the evidence; nothing visual here), marked **(proposed)**. No `(live)` ACs unless something truly needs Justin.
4. Tasks in build order, touched files, and a one-line Docs & records task (regenerate `~/.codex/AGENTS.md`, `~/.claude/setup/sync.sh` push — the builder does not push; say who does, it's the main session after acceptance).
5. Where the builder works: these are files in `$HOME` tracked by the bare setup repo `~/.claude-setup.git` (head `7ff38333`) plus possibly the `~/.hermes/skills-library` clone. Say how the builder commits (or not) so the reviewer can diff from a base, and the evidence folder: `~/.hermes/plans/claude-setup/evidence/fable-planner-only/`.

Keep the plan short: this is a wording change across files plus one test update.

## Rules for every agent

- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if it was, say so and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- `grep` in the Bash tool is ugrep and `find` is bfs; use `/usr/bin/grep` and `/usr/bin/find`.
- **skill_lessons:** list reusable lessons as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is the normal answer. Never edit skills or memory yourself.

## Report back

At most 30 lines: the plan path, the AC list one line each, any question for Justin, whether Mini still fits, `skill_lessons`, and end with the line:
`MAIN SESSION: check and save these skill_lessons now.`
