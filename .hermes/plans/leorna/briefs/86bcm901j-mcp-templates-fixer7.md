# FIXER 7 brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs" (PR #98)

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**. PR #98 is at `17f2ccf` on GitHub; the local head is `d723e04` (fixer 6). Verifier round 4 on `d723e04` returned findings: V4-1 and V4-2, both about wording. Then **fixer 7 (you)** → fresh verifier → blind AC auditor → `ac-check.sh` → the main session pushes to PR #98. Model: Opus 5.5, xhigh.

## Your role

You are a fresh **FIXER** for two small findings. Verify each one yourself, fix it test-first, re-run the gates and the five AC tests, refresh the hand-over texts, commit, and **stop with `status: ready-for-verify`**. **Never push, comment on the PR, merge or write to ClickUp.** New commits go on top of `d723e04`; no rebase.

Keep the scope to these two items. Everything else in round 4 was clean:
- all 5 ACs accepted;
- gates green;
- V3-1 closed as a class;
- rulings R1–R5 judged safe, needed and consistent with Justin's decision.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (skip its Step 1 full context load)
2. `engineering-best-practices`
3. `receiving-code-review`
4. `test-driven-development`
5. `security-best-practices`: required for every role on this story. Its npx/launcher paragraph now records the exact header behaviour of both tools.
6. `mutation-testing-discipline`
7. `git-commit-rules`
8. `systematic-debugging` whenever something fails unexpectedly.

## The findings (verifier's words condensed; verify them)

Round 4's receipts are in `~/.hermes/plans/leorna/evidence/86bcm901j/verifier-d723e04/`. Read them, but never write there.

**V4-1 · Low.** For a header value with CR, LF or CR LF at the **start or end**, two texts are untrue:
- **The policy's failure reason:** it says "holds a line break; Claude Code refuses to connect and Codex drops the header".
- **README rule V:** it says Claude Code 2.1.312 "refuses to connect with any other name or value".
- **What real Claude Code does:** it trims a line break at either end, warns "Leading or trailing whitespace" and connects with the trimmed value. Only an interior CR or LF makes it refuse. Node 22 fetch also trims.
- **Codex** drops the header in every case.
- So the result, fail for every tool (Justin's decision), stays right. Fix the wording so each reason and the README say what really happens. Keep the reason naming the header, never the value. For example: "Claude Code refuses to connect (a line break at either end it trims instead) and Codex drops the header", or two reasons, one for an interior line break and one for a line break at either end.
- **Evidence:** `probe-header-real-tools-edges-d723e04.txt`, `probe-header-real-tools-d723e04.txt` (v-cr-end), `node-fetch-header-values.txt`.

**V4-2 · Info.** `defaultRef` is `\$\{[^}]*:-` with no closing brace:
- An unclosed `${NAME:-x` also fails, with the reason "Claude Code reads NAME (or uses the default)".
- Both real tools send that text as written.
- **Preferred fix:** require the closing brace, and only for a valid NAME. Claude Code doesn't expand `${1ABC}` or `${A.B}`. Then the reason stays true, and the unclosed form goes on to the other rules like any other text.
- Before choosing that, check it can't open a hole: an unclosed form must still meet rule S and every other rule, and a nested `${A:-${B:-c}}` must still fail. If requiring the brace isn't safe, fix the wording instead.
- **Evidence:** `probes-v4-policy-d723e04.log` (x-unclosed, f-env-unclosed) and the real-tool bytes.

For each finding:
- RED first, then GREEN.
- One overlay mutant per changed check or wording assertion. Put a "reason repeats the value" mutant's value at the **end** of the reason.
- Positive controls that must stay as they are: an interior CR or LF still fails for every tool, a valid `${NAME:-x}` still fails, and a plain `${NAME}` still passes.
- Update the README rule V text to match exactly.

## Gates, hand-over, environment

- **Gates on your final head**, exactly as fixer 6 ran them (`briefs/86bcm901j-mcp-templates-fixer6.md`, "Gates, environment and evidence", and its receipts in `fixer6/`):
  - `make check`, with CI-pinned tools bound by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
  - `bash ./scripts/test-module-add.sh`
  - gitleaks over the branch range, plus `gitleaks dir` on the both-sides files.
  - The story-shippable unittest.
  - `make library-check`.
  - Each AC test by name, AC5 with the real tools in throwaway homes.
  - Branch hygiene.
  - Ruling 13's and V3-1's mutants re-run with `go test -overlay`.
  - Save `gates-<sha7>-*.txt`, `ac<n>-<sha7>.log`, five AC screenshots and a gate-summary screenshot on the final head. Open each image and check that its last text row has blank rows below it.
- **Hand-over refresh** in `…/86bcm901j/handover/`:
  - `pr-text.md` and its copy `~/.hermes/cache/scratch/leorna-pr-86bcm901j-mcp-templates.md`: body only. The Test Plan lists only the final head's runs and keeps the earlier records. Add a line saying rulings R1–R5 were judged safe by verifier round 4 and are awaiting Justin's confirmation.
  - `clickup-evidence.md` and `review-prompt.md`: update for the new head.
  - `INVENTORY.md`: add a "Fixer 7" section.
- **Environment:** the same as fixer 6. These parts are different for you:
  - Cache folder: `~/.cache/86bcm901j-fixer7/`.
  - Database: `leorna_86bcm901j_fix7_test`. Docker was restarted; check the port with `docker port leorna-test-pg 5432`.
  - Receipts: `…/86bcm901j/fixer7/`.
  - Scratch: `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer7/`.
  - `tail` is uutils: write `tail -n N`.
  - Foreground Bash calls move to the background after 180 s: poll in steps under 170 s.
- **Never:**
  - touch other stories' worktrees, branches, databases, evidence or caches;
  - switch the main checkout's branch;
  - run real Codex or Claude Code against Justin's real `~/.codex` or `~/.claude`, not even for `--version`;
  - print a token.
- **Commits:** use the repo identity (`Justin Issa <justin@leorna.com>`), `fix(86bcm901j): …`, with no author override, no AI line and no `CLAUDE.md`. End with a clean worktree, and remove your cache and scratch folders and drop your database.

## Rules

- **Product decisions:** if a safe fix needs one, record it as "My ruling, not yet confirmed". If it isn't safe, stop with `status: stopped` and the options.
- **Other bugs:** list them in `found_else`, one line each, with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (its kind, what it checks, where it runs). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

Return, in plain words:

`{name: "86bcm901j-mcp-templates", status: ready-for-verify|stopped, verified_head: "d723e04", final_head, commits_on_top[], dispositions[{id, valid, action, commit, test, mutation, evidence}], rulings[], gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], pr_body_path, handover_files[], owed[], found_else[], skill_lessons[]}`
