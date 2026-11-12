# Brief: FIXER 2 — fable-planner-only (review-2 REVIEW AGAIN)

## Role
You are the fresh **fixer** for Justin's setup story `fable-planner-only`, round 2. Fix the two P2 findings of review 2 test-first on the story's branch, then stop at `ready-for-next-review`. You don't start other agents, merge, run `sync.sh` or push. Don't change the approved ACs or the plan.

## Skills to load first (say so)
`engineering-best-practices`, `receiving-code-review` (verify each finding yourself first; push back with evidence where it's wrong), `test-driven-development`, `mutation-testing-discipline`.

**Read before you start:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Inputs
- Worktree `/home/justin/.claude-setup-wt/fable-planner-only`, branch `fable-planner-only`, head `2629ccb09d9474d0a4fa63f08cd3b6f973e6b994` (fix 1 on top of `8a721839`; story base `bcfeb5fe`). Confirm HEAD and a clean `git status --porcelain --untracked-files=all` first.
- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/fable-planner-only/plan-approved.md` (AC1 `routing_text_agrees`, AC2 `fable_only_plans`, AC3 `xhigh_only_where_routed`).
- The findings: `…/evidence/fable-planner-only/review-2/review.json` (R2-1, R2-2 are P2; R2-3 is P3, out of scope) and the reviewer's probe files in `~/.cache/fable-planner-only-reviewer2/` (`legit.md`, `legit2.md`, `wrong.md`, `only-new.loc` — the 25 places refused only by fix 1). Earlier context: the auditor's refused shapes in `…/auditor/ac.json`, fix 1's work in `…/fix-1/`.

## The referee's lines
```
R2-1  P2  pipeline-rules.test.sh:194  The new sentence reading binds each model or effort word to every role named since the previous model word, so plain 'high' attaches to round 1 whenever round 1 is named first in a sentence, even when a later role or a contrast sits between them. (e.g. "The verifier, unlike round 1, runs on Opus 5.5 high." / "Round 1 is the expensive one, so later rounds drop to high." / "The round-1 reviewer is the one exception to high: it runs on xhigh.")
R2-2  P2  pipeline-rules.test.sh:179  'planner' is not a role word and nothing marks history inside a sentence, so Fable is charged to any role named earlier in the same sentence or role-table row. (e.g. "Only the planner, not the builder or a reviewer, runs on Fable 5.2 high." / "...a fresh Fable planner re-plans." / a dated Justin quote inside a role row, like SKILL.md at 55182e4f:97)
```

## What to do
The goal: check 7 refuses every auditor shape (F1–F4, F8, C12, E1–E3, T7, upper case) **and** passes every legitimate line in the reviewer's corpus. A simpler, more predictable rule beats a cleverer parser — e.g. bind a model/effort word only to the **nearest** role word (or only the subject of the clause/row's first cell), treat `planner` as a role so Fable bound to it is fine, treat negation/contrast (`not`, `unlike`, `except`, `exception`) and dated quotes/history (`"…"`, `(Justin, 2026-…)`, `*Why`) as breaks. Your choice; justify it in one line.
1. **Red:** add the reviewer's legitimate lines (all 25 `only-new.loc` places' shapes, R2-1's and R2-2's examples) as must-pass controls in `fable_only_plans`/`xhigh_only_where_routed`; show them failing on 2629ccb0. Keep all 77 of fix 1's refusal cases. Capture `E/fix-2/red.log`.
2. **Green:** fix check 7 so all controls pass and all refusal cases still refuse at `<file>:<line>`. Then run the old (8a721839) and new checker over the same correct-text corpus — the six rule files, `~/.claude/project-docs/*/CLAUDE.md`, the Codex header, `~/.hermes/plans/**/*.md`, `~/.claude/projects/*/memory/*.md` — and diff: list any line only the new one refuses, and fix or justify each. Capture `E/fix-2/corpus-diff.log`.
3. **Mutations** of the new logic, under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: each caught. `E/fix-2/mutations.log`.
4. **Regression:** full `pipeline-rules.test.sh`, `review-check.test.sh`, `ac-check.test.sh` on the new head, also as `PATH=/usr/bin:/bin /bin/bash`; no GNU-only awk/sed (no `gensub`, `IGNORECASE`, `\<`, `sed -r`, `grep -P`). One log + one terminal-capture image per AC in `E/fix-2/`.
5. **Commit** only the test file, plain `git commit -m "fable-planner-only: check 7 binds a model to its nearest role, so contrasts and quotes aren't refused"` (adjust to what you did) — no author override, no AI trailer. Tree clean after.

`E = ~/.hermes/plans/claude-setup/evidence/fable-planner-only/`. Set `TMPDIR=~/.cache/fable-planner-only-fixer2`.

## Rules for every agent
- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if it was, say so and rerun under the cap.
- `grep` in the Bash tool is ugrep and `find` is bfs; use `/usr/bin/grep` and `/usr/bin/find`.
- **skill_lessons:** list reusable lessons as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. Never edit skills or memory yourself.

## Report back
At most 30 lines: `status: ready-for-next-review` (or `stopped` + reason), new head SHA, the rule you chose in one line, red/green counts, corpus-diff result, mutations, regression, any pushback, `skill_lessons`, and end with:
`MAIN SESSION: check and save these skill_lessons now.`
