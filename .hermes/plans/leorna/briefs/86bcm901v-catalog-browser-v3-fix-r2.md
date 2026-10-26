# FIXER (round 2) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **FIXER** (Opus 5.5, xhigh). Apply review 2's outcome (a small docs change), refresh the AC3 terminal capture on your final head, and stop at `ready-for-verify`. This is **not** the hand-over.

## The candidate

- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3` (local only, upstream unset on purpose).
- **Reviewed head:** `266603e42a98509dd5d29a78171b03a74d277aae`. **Base:** `6e74ced843642439d1dac9f25673440fb0f285f5`.
- **Approved plan (read-only, never edit):** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md`. Justin's later decisions are in the working plan's last sections: `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md` ("Away grant" and "Decisions applied under the away grant").
- **ACs:** AC1 filter by kind, category, tag and supported tool + text search; AC2 item page with description, example, version, supported tools and a rendered preview; AC3 filtering <300 ms server time with 200+ items. Tests `TestLibraryAC1FilterAndSearchWithPostgres`, `TestLibraryAC2ItemDetailWithPostgres`, `TestLibraryAC3FilteringUnder300msWithPostgres` in `internal/web/` (exact commands in the plan).

## Review 2 result (fresh Opus reviewer, on 266603e)

Verdict **clean**: no P0–P2, review 1's F1–F4 all closed, AC1–AC3 accepted, all gates exit 0, 12/12 of its mutants killed. Receipts: `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/review-r2/`.

**P3-1 · Worst-case Markdown bodies make the preview very expensive (follow-up).** `internal/library/preview.go:39-42` (table extension), `preview.go:57-66`, `internal/web/library.go:166,171` (example and body rendered on each item-page request). goldmark pads every short table row with empty cells up to the header's column count (`extension/table.go:247-248`), so output grows with columns × rows. Measured with the real `RenderMarkdown` (`review-r2/render-cost-probe-266603e.txt`): 4 KB table (500×1000) → 5 MB / 0.23 s / 113 MiB; 8 KB (1000×2000) → 20 MB / 0.66 s / 451 MiB; 16 KB (2000×4000) → 80 MB / 4.2 s / 1.8 GiB; 64 KiB of `[a](` → 2.1 s CPU. With the 64 KiB body limit, one item could allocate tens of GiB. P3 today because the only writer of `library_items` is the library embedded in the binary (`internal/store/postgres/library.go:52`, via `EnsureLibrary`); it matters once upstream import (86bcm945u) or tenant variants can write content.

**Decision (Justin's away grant applied the reviewer's recommendation A):** record it as a follow-up now: a "Limits" line in the README section for the library browser (`internal/web/README.md`), saying what the cost is, why it's acceptable today (only Leorna-authored embedded content reaches `library_items`), and that a bound on table cells (or an escaped code-view fallback) must land before content not written by Leorna can reach `library_items` (e.g. 86bcm945u upstream import, tenant variants). **No guard code in this story.** Also tell the finisher's PR text to list it under Assumptions (put that wording in your report).

**Reviewer's evidence note:** the AC3 screenshot `ac3-timing-terminal.png` (evidence root) is labelled `HEAD=1571fcd`; the test is byte-identical on 266603e but its log line moved. **Retake the AC3 Terminal capture on your final head** the same way the builder did (real Terminal window: command, timing lines, `--- PASS`, `ok`, `EXIT=0`; see `EVIDENCE.md` and the `leorna` skill's terminal capture recipe), save it as `fix-r2/ac3-timing-terminal-<sha7>.png` with its log, and check it visually (no host, tenant ID, token or email; the window title may show only the local username).

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (FINISHER role, fix pass only; skip its Step 1 load except `leorna-control-plane-workflow.md`, `clickup-evidence.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `receiving-code-review` (verify the finding's evidence before writing the Limits line; state it accurately, no overstatement).
4. `git-commit-rules`.

## Boundaries

- Docs only: the README "Limits" line. No code, test or dependency change. If you find the README change can't be written accurately without a code change, stop and say why.
- Commit `docs(86bcm901v): …`, plain `git commit -m` (identity from git config; check `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`). No author overrides, no AI attribution or Co-Authored-By lines, never commit `CLAUDE.md`.
- **Leave the worktree committed and clean** (`git status --porcelain` empty, nothing untracked); keep scratch outside it.
- **Your test DB:** `leorna_86bcm901v_v3_fix2_test` (ends in `_test`; create, drop at the end). Never use another agent's or story's DB.
- **Your receipts** go in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/fix-r2/`. Don't modify other files in the evidence folder.
- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/` edits. Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches or DBs.

## Before you stop

1. Re-run the three AC tests alone with the plan's commands on your new head (logs `ac<n>-<sha7>.log` with `HEAD=` and `EXIT=` lines in `fix-r2/`).
2. Re-run `make check` with Postgres and CI's tool versions bound by absolute path (golangci-lint and govulncheck, per the `leorna` skill), plus `make contracts-check`. Logs with real exit codes; read each before citing it.

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity); don't fix it.

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{status: ready-for-verify|stopped, prev_head, head_sha, commits[], readme_limits_text, pr_assumptions_text, ac_status[{ac, test, result, log}], ac3_screenshot, gates[{name, exit_code, log}], found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
