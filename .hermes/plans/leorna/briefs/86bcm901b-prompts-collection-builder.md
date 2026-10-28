# BUILDER brief: 86bcm901b-prompts-collection [leorna]

**Role:** BUILDER for the Leorna story "86bcm901b-prompts-collection": build the approved plan at **`~/.hermes/plans/leorna/86bcm901b-prompts-collection.md`**. The read-only approved copy is `~/.hermes/plans/leorna/evidence/86bcm901b/plan-approved.md`; if the two ever differ, the approved copy wins. **The plan is approved: don't re-plan.** Pipeline: **Full**. After you: reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → finisher, each a fresh Opus 5.5 xhigh agent run by the main session.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac. Mac-only recipes in the skills (osascript Terminal captures, `screencapture`, Homebrew paths) don't apply; the plan's B0 and "Evidence capture per AC" sections give this machine's methods.

## Skills to load first, in this order (say so in your first steps)

1. `leorna`, in the BUILDER role (its "Doing a story" steps 2–5, with its Step 1 context load first).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each code change.
4. `mutation-testing-discipline`: the TOML key guard, the source-path rule and the `requires` checks are guards (plan task B9).
5. `security-best-practices`: untrusted upstream TOML is parsed, and third-party prompt text ships to every install.

Also `systematic-debugging` whenever a test fails unexpectedly or a gate gets worse: find the cause, don't patch around it.

## The ask, rewritten

Build ClickUp story **86bcm901b "Curate the reusable prompts collection"** in `leorna-control-plane` exactly as the approved plan says. Import the 9 agent-skills slash commands (build, code-simplify, constraints, `planning` (the plan command, Q2 ⭐A), review, ship, spec, test, webperf) as `prompt` items through the 945u upstream sync, pinned at `aeac41d`. Each item gets a checked `requires` list (Q1 ⭐A), renders for Claude Code and Cursor with Codex skipped with a reason, and passes the content quality gate. Then write the AC5 live-check folder and checklist for Justin. "Done" means `ready-for-review`: tasks B0–B13 complete; AC1–AC4 tests green on head and RED on base `1ee7157`; mutation checks done; the full gates green on the final head; one screenshot per AC captured (or explicitly owed if B0's screenshot probe found no method); the evidence inventory written; everything committed and the worktree clean.

**Justin's answers (2026-10-28, away grant):** he said "I'm gonna go shower, so just keep this running, okay? Just go with the recommended stuff the agent says, alright?" So every ⭐ answer is chosen: **Q1 A** (`requires` list in item.json), **Q2 A** (`planning`), **Q3 A** (ship all 9; flag skills now, agents after 901a), **Q4 A** (agents run PostgreSQL 18.6 from Ubuntu's packages in user space, or reuse a shared `leorna-test-pg` already answering on 127.0.0.1:5432, with this story's own databases).

Earlier, Justin's story message (verbatim):

> Story: ClickUp card 86bcm901b "Curate the reusable prompts collection". Run the story pipeline from CLAUDE.md with the Full pipeline (already picked, don't ask).
> - Repo: leorna-control-plane. On the card, "content" means internal/library/content/ in this repo.
> - Two other sessions are working in this same repo right now, on 86bcm901a (agent definitions) and 86bcm901j (MCP templates). Work only in your own worktree, ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection, on branch feat/86bcm901b-prompts-collection, created from a freshly fetched origin/main. Never switch the main checkout's branch. Never touch the other stories' worktrees, branches, test databases or evidence folders.
> - … Resolve those conflicts at hand-over. … Never push, open a PR or post to ClickUp unless I say so.

And: "Make sure it pulls the updated main branch." (Fetch from GitHub, fast-forward the main checkout's local `main` with `--ff-only`, then create the worktree from that SHA: plan task B0.1.)

## Boundaries

- **Worktree and branch:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection` on `feat/86bcm901b-prompts-collection`, created by you in B0.1. In the main checkout you may do only B0.1's fetch and `merge --ff-only origin/main` (only when it has no tracked changes; stop if it refuses). Never check out another branch there, never reset, never edit files there.
- **Siblings:** other sessions are working in this repo on 86bcm901a (agent definitions), 86bcm901j (MCP templates; worktree `.claude/worktrees/86bcm901j-mcp-templates`) and 86bcm901w (pack builder; worktree `.claude/worktrees/86bcm901w-create-pack`). Never touch their worktrees, branches, test databases, environment folders or evidence folders. Stay within the plan's files. Shared records (`delivery/stories.json`, `library.json`, `content.lock.json`, the library README, `curation.json`) are resolved at hand-over by the finisher, as the plan's Risks table says: don't wait for the siblings.
- **Environment:** only this story's `~/.cache/leorna-86bcm901b/` (plan B0.2), on a port this story picks, with `_test` databases named for this story. No `sudo`, no global PATH change, no edits to `~/.bashrc`, `~/.profile`, `go.mod`, CI or product code to work around an environment problem. If an environment step fails, stop with `status: stopped` and the exact error.
- **Disk:** check `df -h ~` before B0's downloads. Below about 3 GiB free, commit what passes and stop with `status: stopped`; never delete anything outside your own folders.
- **Git:** let git use the repo's identity (`Justin Issa <justin@leorna.com>`); never pass `-c user.*`, `--author` or AI attribution lines (no `Co-Authored-By`). Commits are `feat(86bcm901b): …`. Never commit a `CLAUDE.md`. Never push, open a PR, merge or write to ClickUp.
- **Evidence:** screenshots and logs go to `~/.hermes/plans/leorna/evidence/86bcm901b/` as the plan names them (`ac<n>-<what>.png`, `gates-<sha7>.txt`). Never write in its `verifier/` or `auditor/` subfolders, and never change `plan-approved.md`. A staged screenshot that claims an unrun check passed never counts: if no method produces a PNG, name the screenshot as owed.
- **Scratch:** keep all scratch in `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-builder/`, created fresh with `mkdir` (no `-p`). The scratchpad is shared with other agents: never read or touch other folders there, and remove only yours at the end.
- **Shell gotcha:** in this Bash tool `grep` is a function running Claude Code's ugrep: it skips gitignored and binary files, and bounded repeats like `.\{0,200\}` fail with "exceeds complexity limits". Use `command grep` (GNU grep) in gate scripts and wherever gitignored files matter.
- You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in your section of `~/.hermes/plans/leorna/evidence/86bcm901b/INVENTORY.md`. If it can't be decided safely, or the plan turns out wrong or missing a decision, stop with `status: stopped` and the options. Never redesign.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- You can't start other agents; a loaded skill's "spawn a subagent" or "independent reviewer" step is the main session's job.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching `{name, status: ready-for-review|stopped, summary, worktree, branch, base, last_commit, commits[], gates[{name, exit}], ac_logs[{ac, head_log, base_log}], mutations[], shots[], evidence_owed[], environment, rulings[], steps_for_justin[], stop_reason, found_else[], defect_loop_skills[], skill_lessons[]}`. `status` and `summary` are required. Follow the plan's **Completion contract** for what the report must hold.
