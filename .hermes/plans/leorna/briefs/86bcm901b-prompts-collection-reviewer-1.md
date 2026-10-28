# REVIEWER 1 brief: 86bcm901b-prompts-collection [leorna]

**Role:** REVIEWER 1 (review only) for the Leorna story "86bcm901b-prompts-collection", Full pipeline. You are a fresh agent: you never saw the plan being written or the build. **Report only: change nothing.** No commit, push, merge, PR or ClickUp write; restore anything you touch. After you: a fresh fixer for your valid findings, then a fresh reviewer 2 of the corrected code, a fixer, a verifier and a blind AC auditor.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac. Mac-only recipes in the skills don't apply.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (its review rules; Step 1 context load for the control plane).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`: you **are** the fresh independent reviewer, so skip `requesting-code-review`'s "dispatch an independent reviewer subagent" step and every auto-fix step.
4. `security-best-practices`: untrusted upstream TOML is parsed, and third-party prompt text ships to every install.
5. `mutation-testing-discipline`, for your own mutation checks.

## What to review

- **Repo:** `leorna-control-plane`. **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection`, branch `feat/86bcm901b-prompts-collection`.
- **Range:** base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (GitHub `main` when built) → head **`78f13a7605e72735c2be6b7461422c1926048650`** (8 commits). Review `git diff 1ee7157...78f13a7` in full.
- **Approved plan:** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/plan-approved.md` (read-only; Justin's answers are under "Justin's answers (2026-10-28)": every ⭐, so Q1 A `requires` in item.json, Q2 A `planning`, Q3 A all 9 now, Q4 A user-space PostgreSQL). Review the code against this plan, the card's ACs and the `leorna` skill's rules.
- **The card's ACs:** AC1 the 9 upstream commands exist as `prompt` items with source commit recorded; AC2 each renders natively for Claude Code, Codex and Cursor or is skipped with a reason; AC3 the skills each prompt invokes are in the same starter pack or flagged as a dependency in the pack builder; AC4 each passed the content quality gate; AC5 (live) Justin runs /review and /spec in Claude Code. The plan names one test per AC.
- **Builder's evidence and notes:** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/` (`INVENTORY.md`, `EVIDENCE.md`, AC logs, `mutations-78f13a7.txt`, gate logs, screenshots). Don't trust them: run things yourself.
- **The builder's rulings, each "not yet confirmed"; judge each one** (accept, or a finding):
  1. The plan gave this desktop no C compiler, so `make check` failed on base with `go: -race requires cgo`. It unpacked gcc-15 and libc6-dev in user space into `~/.cache/leorna-86bcm901b/cc` with a `--sysroot` gcc wrapper in `$ENV/bin`, used only on the task PATH. No product code, go.mod, CI or global environment changed.
  2. Screenshots use the plan's method 1 plus `--disable-gpu --disable-software-rasterizer`, because all three planned methods hung.
  3. Mutation M2 as planned narrows instead of widening (killed by `TestParseReadsPromptSource`); it added widening mutants M2b and M8, plus M9. No test changed.
  4. It committed the docs (B11 README, B13 `delivery/stories.json`) before the mutations, captures and gates, so every artifact names the final head.
  5. The plan cites "Justin's sample-config ruling" for the `/constraints` review, but the builder found no record of it; the review note describes what the prompt actually does and cites the plan's ruling by name.
  6. Base and head demo builds ran in turn on the same demo DB, so the head load is a real upgrade (added 9, unchanged 32).

## How to run things

- **Run the gates yourself, try mutations, don't trust summaries.** `make check` (its `contracts-check`) and `scripts/test-module-add.sh` briefly write into the tree they run in, so run them in a detached copy at `78f13a7` in your own scratch folder (`git -C <worktree> worktree add --detach <your scratch>/head 78f13a7`, removed with `git worktree remove` when done), never in the story worktree. `go test` alone is fine in the story worktree; it must end with `git status --porcelain --untracked-files=all` empty. Use `go test -overlay` for mutations so no source file is edited.
- **Toolchain:** this desktop has no system Go, make, gcc or Postgres. Use the story's user-space environment read-only: `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`. The builder's `INVENTORY.md` and `builder-tools/gates.sh` show the exact gate invocations (`GOLANGCI_LINT`, `GOVULNCHECK`, `GITLEAKS` bindings). Don't change anything under `~/.cache/leorna-86bcm901b/` except creating and dropping your own databases.
- **Database:** the story's PostgreSQL 18.6 is running on 127.0.0.1:55400 (`~/.cache/leorna-86bcm901b/pg/pg.env`, password in `pg/password`). Create your own databases named `leorna_86bcm901b_review1_*_test` and drop them when done. Never use or drop the builder's (`leorna_86bcm901b_test`, `_base_test`, `_demo_test`) or any sibling story's database. Never print the password or a full DB URL in logs or your report. Confirm Postgres tests really ran from a `go test -json` stream read per test (the `leorna` skill's step 4).
- **Integration:** fetch `origin/main` (fetch only; it updates the shared remote ref and nothing else) and report whether GitHub `main` moved past `1ee7157`, and if so whether the moved paths overlap this story's files. Don't merge or rebase.
- **Siblings:** other sessions are working in this repo on 86bcm901a (agent definitions), 86bcm901j (MCP templates) and 86bcm901w (pack builder). Never touch their worktrees, branches, databases, environment folders or evidence folders. Shared records (`delivery/stories.json`, `library.json`, `content.lock.json`, the library README, `curation.json`) are reconciled at hand-over; a conflict that would appear there is not a finding against this branch unless the branch's own content is wrong.
- **Shell gotcha:** in this Bash tool `grep` is a function running Claude Code's ugrep: it skips gitignored and binary files, and bounded repeats like `.\{0,200\}` fail. Use `command grep` where it matters.
- **Your output folder:** write your report, logs and probes only in `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/review-1/` (create it). Never write elsewhere in the evidence folder, and never in `verifier/` or `auditor/`.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-reviewer-1/`, created fresh with `mkdir` (no `-p`). The scratchpad is shared with other agents: never read or touch other folders there, and remove only yours at the end.

## Findings

Rate each finding `critical`, `major`, `minor` or `nit`, mark `introduced` (true: this branch caused it; false: pre-existing on base), and give the evidence (file:line, the command and its output, a failing probe). For each AC, return `ac_status` with whether you'd accept it on this head, its test, its screenshot and your evidence; AC5 (live) is `accepted: false, not_run: "live: Justin runs /review and /spec in Claude Code"`.

## Rules

- You can't ask Justin anything, and you can't start other agents.
- If you find any other bug or problem outside this story's scope, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching `{verdict: clean|findings, reviewed_head, findings[{id, severity, introduced, claim, evidence}], rulings[{n, verdict, why}], ac_status[{ac, accepted, test, screenshot, evidence, not_run?}], integration, found_else[], defect_loop_skills[], skill_lessons[]}`, and save the same report as `review-1/report.md`.
