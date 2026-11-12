# Brief: REVIEWER 1 (the one full review, Mini) + verifier AC work — fable-planner-only

## Role
You are the fresh, full **reviewer 1** for Justin's setup story `fable-planner-only` (Mini pipeline). You never saw the build. You **only report**: no source changes, no commits, no auto-fixes, no other agents; never write the live `~/.claude`, `~/.hermes` (except the evidence folder below), `~/.codex`, global git config, `~/.claude-setup.git` refs or GitHub. Write only into `~/.hermes/plans/claude-setup/evidence/fable-planner-only/review-1/`, `…/fable-planner-only/verifier/` and your scratch folder `~/.cache/fable-planner-only-reviewer1/`.

**What the story is.** Justin (2026-11-11): Fable 5.2 high only as the planner; the round-1 reviewer moves from Fable 5.2 high to Opus 5.5 xhigh (Full and Mini); later review rounds stay Opus 5.5 high; every other role unchanged. Wording edits in six rule files plus an updated consistency test `pipeline-rules.test.sh`.

## Skills to load first (say so)
`engineering-best-practices`, `requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`, `mutation-testing-discipline`.

**Read before you start:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/fable-planner-only`, branch `fable-planner-only`, a linked worktree of the setup repo `~/.claude-setup.git` (work tree `$HOME`).
- **Head:** `8a7218393d89df453c86d29fd1b7d6f5c854052f`. **Base:** `bcfeb5fe9fffcee71870aec1f9349e0c47105741`. Review all of `git diff bcfeb5fe...8a721839` (7 files).
- First confirm HEAD is `8a721839` and `git status --porcelain --untracked-files=all` is empty; if not, stop and report.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/fable-planner-only/plan-approved.md` (read-only). ACs:
  - AC1 `routing_text_agrees` — every routing file gives round 1 to Opus 5.5 xhigh and Fable to the planner only, Codex `AGENTS.md` built from the checkout included, no retired wording left.
  - AC2 `fable_only_plans` — Fable on any non-planner role fails and names the place; an unchanged copy passes.
  - AC3 `xhigh_only_where_routed` — "round 1 on Opus 5.5 xhigh" passes check 7; xhigh on a later round, fixer, verifier or main session, or plain high on round 1, fails.
- Don't treat the builder's evidence (`…/fable-planner-only/builder/`) as proof.

## Focus
- **Completeness:** grep the head (and `~/.claude/project-docs/*/CLAUDE.md`, the generated Codex header) by meaning for any statement that still gives Fable a non-planner role or still says round 1 runs on high / every reviewer on high. Is anything that should stay unchanged (planner on Fable, later rounds Opus high, finisher, verifier, two proofs) altered? Does the "Agent models" bullet keep a dated *Why* for the 2026-11-11 change? Note: Mini's round-1 reviewer also does the verifier's AC work, so Mini's first AC proof now runs at xhigh — say whether any rule text contradicts that.
- **Test truth:** can each of the three tests fail? Mutate the rule files (and the test) in a scratch clone (`git clone -q ~/.claude-setup.git ~/.cache/fable-planner-only-reviewer1/c && git -C … checkout -q --detach 8a721839`), always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Do the existing suites still pass (`review-check.test.sh`, `ac-check.test.sh`, the full `pipeline-rules.test.sh`)? Both machines: also run as `PATH=/usr/bin:/bin /bin/bash` (macOS ships bash 3.2 + BSD tools).
- The builder's found_else #1 (a failing run leaves `/tmp/pipeline-rules-test.*` folders) — rate it.

## Severity (Justin's rule; every P0–P2 needs a concrete real-use scenario of 5+ words, otherwise P3)
- **P0/P1:** a false AC, a gate that lets wrong routing through, or a broken existing suite.
- **P2:** a bug a real agent or orchestrator could plausibly hit, a rule-text contradiction an agent would act on, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## Outputs (required)
1. `review-1/review.json` in the format of the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`: round 1, scope `full`, `from` = base, `head` = `8a721839…`, findings `R1-<k>` with severity, `file_line`, `claim`, `scenario`. Self-check with the live referee and save its output to `review-1/referee.txt`:
   `bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/fable-planner-only --base bcfeb5fe9fffcee71870aec1f9349e0c47105741 ~/.hermes/plans/claude-setup/evidence/fable-planner-only`
2. **Verifier AC work (Mini):** per the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the VERIFIER part): run every AC's test on head and on base, keep each run's log and a terminal-capture image in `verifier/`, and write `verifier/ac.json` in that file's format.

## Rules for every agent
- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if it was, say so and rerun under the cap above.
- `grep` in the Bash tool is ugrep and `find` is bfs; use `/usr/bin/grep` and `/usr/bin/find`.
- **skill_lessons:** list reusable lessons as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. Never edit skills or memory yourself.

## Report back
At most 30 lines: `verdict` (clean / findings), `ac_status` (per AC: pass/fail on head, base result), each finding one line with severity, the referee's last line, `skill_lessons`, and end with:
`MAIN SESSION: check and save these skill_lessons now.`
