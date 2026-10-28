# REVIEWER 2 brief: 86bcm901b-prompts-collection [leorna]

**Role:** REVIEWER 2 (review only) for the Leorna story "86bcm901b-prompts-collection", Full pipeline. You are a fresh agent: you never saw the plan being written, the build, review 1 or the fix pass. **Report only: change nothing.** No commit, push, merge, PR or ClickUp write; restore anything you touch. After you: a fresh fixer for your valid findings, then a verifier and a blind AC auditor.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac. Mac-only recipes in the skills don't apply.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (its review rules; Step 1 context load for the control plane).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`: you **are** the fresh independent reviewer, so skip `requesting-code-review`'s "dispatch an independent reviewer subagent" step and every auto-fix step.
4. `security-best-practices`: untrusted upstream TOML is parsed, and third-party prompt text ships to every install.
5. `mutation-testing-discipline`, for your own mutation checks.

## What to review

- **Repo:** `leorna-control-plane`. **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection`, branch `feat/86bcm901b-prompts-collection`.
- **Full review:** base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` → head **`c889a5a168aad92b4c5463e322bd96fa3777f9ef`** (12 commits). Review `git diff 1ee7157...c889a5a` in full: the whole feature, not only the fixes.
- **Focused scrutiny of the fix delta:** `78f13a7..c889a5a` (4 commits by fixer 1). Check that each of review 1's findings is really closed as a class, and that the fixes broke nothing else.
- **Approved plan:** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/plan-approved.md` (read-only). The live plan `/home/justin/.hermes/plans/leorna/86bcm901b-prompts-collection.md` has the same ACs plus, under "Justin's answers (2026-10-28)", every ⭐ answer (Q1 A `requires` in item.json, Q2 A `planning`, Q3 A all 9 now, Q4 A user-space PostgreSQL) and the **Review 1 F4 ruling** (the `/ship` note and `ship/example.md` say only what the body says; this supersedes D4's ship example wording on that point).
- **The card's ACs:** AC1 the 9 upstream commands exist as `prompt` items with source commit recorded; AC2 each renders natively for Claude Code, Codex and Cursor or is skipped with a reason; AC3 the skills each prompt invokes are in the same starter pack or flagged as a dependency in the pack builder; AC4 each passed the content quality gate; AC5 (live) Justin runs /review and /spec in Claude Code.
- **Earlier reports (read them; don't trust them):** review 1 `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/review-1/report.md` (F1 case-variant TOML keys, F2 three surviving guard mutants, F3 escaped NUL, F4 `/ship` wording, F5 constraints citation) and fixer 1 `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/fix-1/report.md` (dispositions, an extra CR LF defect it found, mutation results). Builder's notes: `evidence/86bcm901b/INVENTORY.md`, `EVIDENCE.md`.
- **Fixer 1's rulings, each "not yet confirmed"; judge each one** (accept, or a finding):
  1. An escaped CR LF in a command prompt is refused, not normalised (plan D2: refused rather than guessed); a lone CR round-trips and stays accepted.
  2. Two extra boundary mutants (R3b `>=`, R3c counting bytes) closed with `TestTransformAcceptsACommandDescriptionAtTheLimit`.
  3. F5's premise was partly wrong (the sample-config ruling is on main, commit `4559114`, README checklist safety row); the note now cites that README rule and states the risk.
  4. The item.json and curation.json JSON decoders (encoding/json v1, case-insensitive, deterministic last-key-wins) are not changed: pre-existing shared helpers reading repo-authored files; follow-up logged.
  5. `prompt/ship@1.0.0`'s lock entry was re-recorded with `-update-lock`, not version-bumped, because that version has never been on main.

## How to run things

- **Run the gates yourself, try mutations, don't trust summaries.** `make check` (its `contracts-check`) and `scripts/test-module-add.sh` briefly write into the tree they run in, so run them in a detached copy at `c889a5a` in your own scratch folder (`git -C <worktree> worktree add --detach <your scratch>/head c889a5a`, removed with `git worktree remove` when done), never in the story worktree. `go test` alone is fine in the story worktree; it must end with `git status --porcelain --untracked-files=all` empty. Use `go test -overlay` for mutations so no source file is edited. Fixer 1's probe and harness files were deleted with its scratch; its `mutations-fix1-c889a5a.txt` records each snippet and command if you want to re-run one.
- **Toolchain:** this desktop has no system Go, make, gcc or Postgres. Use the story's user-space environment read-only: `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`. The builder's `INVENTORY.md` and `evidence/86bcm901b/builder-tools/gates.sh` show the exact gate invocations (`GOLANGCI_LINT`, `GOVULNCHECK`, `GITLEAKS` bindings). Don't change anything under `~/.cache/leorna-86bcm901b/` except creating and dropping your own databases.
- **Database:** the story's PostgreSQL 18.6 runs on 127.0.0.1:55400 (`~/.cache/leorna-86bcm901b/pg/pg.env`, password in `pg/password`). Create your own databases named `leorna_86bcm901b_review2_*_test` and drop them when done. Never use or drop the builder's (`leorna_86bcm901b_test`, `_base_test`, `_demo_test`) or any sibling story's database. Never print the password or a full DB URL. Confirm Postgres tests really ran from a `go test -json` stream read per test.
- **Integration:** fetch `origin/main` (fetch only) and report whether GitHub `main` moved past `1ee7157`, and if so whether the moved paths overlap this story's files. Don't merge or rebase.
- **Siblings:** other sessions are working in this repo on 86bcm901a (agent definitions), 86bcm901j (MCP templates) and 86bcm901w (pack builder). Never touch their worktrees, branches, databases, environment folders or evidence folders. Shared records (`delivery/stories.json`, `library.json`, `content.lock.json`, the library README, `curation.json`) are reconciled at hand-over; a conflict there is not a finding against this branch unless the branch's own content is wrong.
- **Shell gotcha:** in this Bash tool `grep` is a function running Claude Code's ugrep: it skips gitignored and binary files, and bounded repeats like `.\{0,200\}` fail. Use `command grep` where it matters.
- **Your output folder:** logs, probes and receipts only in `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/review-2/` (create it). Never write elsewhere in the evidence folder, and never in `verifier/` or `auditor/`. **Don't write a report file** (Claude Code refuses report files from subagents): return the report as your final message; the main session saves it.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-reviewer-2/`, created fresh with `mkdir` (no `-p`). The scratchpad is shared with other agents: never read or touch other folders there, and remove only yours at the end.

## Findings

Rate each finding `critical`, `major`, `minor` or `nit`, mark `introduced` (true: this branch caused it; false: pre-existing on base), and give the evidence (file:line, the command and its output, a failing probe). For each AC, return `ac_status` with whether you'd accept it on this head, its test, its screenshot and your evidence. The builder's screenshots show `78f13a7`; the finisher refreshes them for the final head, so a stale screenshot is not a finding. AC5 (live) is `accepted: false, not_run: "live: Justin runs /review and /spec in Claude Code"`.

## Rules

- You can't ask Justin anything, and you can't start other agents.
- If you find any other bug or problem outside this story's scope, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching `{verdict: clean|findings, reviewed_head, review1_closed[{id, closed, evidence}], findings[{id, severity, introduced, claim, evidence}], rulings[{n, verdict, why}], ac_status[{ac, accepted, test, screenshot, evidence, not_run?}], integration, found_else[], defect_loop_skills[], skill_lessons[]}`.
