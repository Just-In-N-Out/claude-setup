# Brief: REVIEWER 3 (delta round, Mini) — fable-planner-only

## Role
You are the fresh **reviewer 3** for Justin's setup story `fable-planner-only` (Mini pipeline). You never saw the build or the fix. You **only report**: no source changes, no commits, no auto-fixes, no other agents; never write the live `~/.claude`, `~/.hermes` (except your folder below), `~/.codex`, global git config, `~/.claude-setup.git` refs or GitHub. Write only into `~/.hermes/plans/claude-setup/evidence/fable-planner-only/review-3/` and scratch `~/.cache/fable-planner-only-reviewer3/` (set `TMPDIR` there).

**The story:** Fable 5.2 high only as the planner; round-1 reviewer on Opus 5.5 xhigh; later rounds Opus 5.5 high; rule-text edits in six files plus a consistency test `pipeline-rules.test.sh`. Round 1 was clean. The blind auditor then refused AC2/AC3: the test's check 7 read one clause at a time, so a wrong model written as an aside, a step heading or a new table row slipped through. Fix 1 (`2629ccb0`) added a sentence-level reading and 96 cases. Review 2 then found it falsely refused correct text (R2-1: plain "high" bound to round 1 across a contrast; R2-2: Fable charged to an earlier role, e.g. "Only the planner, not the builder or a reviewer, runs on Fable 5.2 high."). Fix 2 (`9f6d93b8`) binds each model/effort word only to the nearest role before it, with skips for contrast words, quotes, dated parentheses, plan words, names and non-effort "high"; its fixer pushed back on 18 of the reviewer's 25 corpus places as not legitimate under the new routing (see `…/fix-2/corpus-diff.log`).

## Skills to load first (say so)
`engineering-best-practices`, `requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`, `mutation-testing-discipline`.

**Read before you start:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Scope: the fix commit and what it touches
- Worktree `/home/justin/.claude-setup-wt/fable-planner-only`, branch `fable-planner-only`. **Head** `9f6d93b8dd46a7de4e61956a61da35bccb73ebbc`; **from** (last reviewed head) `2629ccb09d9474d0a4fa63f08cd3b6f973e6b994`; story base `bcfeb5fe9fffcee71870aec1f9349e0c47105741`. Review `git diff 2629ccb0..9f6d93b8` (one file) and whatever it affects.
- Confirm HEAD is `9f6d93b8` and `git status --porcelain --untracked-files=all` is empty first.
- Approved plan (read-only) `…/evidence/fable-planner-only/plan-approved.md`, ACs:
  - AC1 `routing_text_agrees`, AC2 `fable_only_plans`, AC3 `xhigh_only_where_routed` (wording in the plan).
- The auditor's refused cases are in `…/auditor/ac.json`. Review 2's findings: `…/review-2/review.json`. Don't treat the fixers' evidence (`…/fix-1/`, `…/fix-2/`) as proof.

## Focus
- Are R2-1 and R2-2 really fixed, and is the fixer's pushback on 18 places right? Did the new skips (contrast, quotes, dates, plan words, "reviewed") open a hole a wrong pairing could plausibly slip through in normal writing (e.g. "Round 1 is reviewed on Fable 5.2 high", "The finisher (2026-11-12) runs on Fable")? Each skip is a place to probe.
- Does the new check 7 refuse every shape the auditor listed, and the AC wording's categories, while **not** refusing any legitimate rule text in the six rule files, the project `CLAUDE.md` copies (`~/.claude/project-docs/*/CLAUDE.md`) and the Codex header? A false refusal would break `routing_text_agrees` for every future story's sync and edit — that's real-use. Think about lines a future agent plausibly writes (contrast asides like the fixer's own known limit "The verifier, unlike round 1, runs on Opus 5.5 high", lists of several roles with one model, history notes).
- Do the new cases and the `<file>:<line>` assertion really fail when they should? Mutate in a scratch clone (`git clone -q ~/.claude-setup.git ~/.cache/fable-planner-only-reviewer3/c && git -C … checkout -q --detach 9f6d93b8`), always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Both machines: macOS `/bin/bash` 3.2 + BSD awk/sed — the fixer only had gawk/mawk/`gawk --posix`. Look for GNU-only constructs (awk `tolower` is fine; watch `gensub`, `\<`, `IGNORECASE`, `sed -E` vs `-r`, `grep -P`, arrays of arrays). Also run as `PATH=/usr/bin:/bin /bin/bash`. Existing suites (`review-check.test.sh`, `ac-check.test.sh`, full `pipeline-rules.test.sh`) still pass.

## Severity (Justin's rule; every P0–P2 needs a concrete real-use scenario of 5+ words, otherwise P3)
- **P0/P1:** a false AC, a gate that lets wrong routing through or wrongly blocks the current rule text, a broken suite.
- **P2:** a bug a real agent could plausibly hit (incl. macOS), a false refusal of plausible legitimate text, or a test that can't fail.
- **P3:** cosmetic, deliberate-only, synonyms nobody uses, or a setup none of Justin's machines has.

## Outputs (required)
`review-3/review.json` in the format of the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`: round 3, scope `delta`, `from` = `2629ccb0…`, `head` = `9f6d93b8…`, findings `R3-<k>`. Self-check with the live referee, save to `review-3/referee.txt`:
`bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/fable-planner-only --base bcfeb5fe9fffcee71870aec1f9349e0c47105741 ~/.hermes/plans/claude-setup/evidence/fable-planner-only`

## Rules for every agent
- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if it was, say so and rerun under the cap.
- `grep` in the Bash tool is ugrep and `find` is bfs; use `/usr/bin/grep` and `/usr/bin/find`.
- **skill_lessons:** list reusable lessons as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. Never edit skills or memory yourself.

## Report back
At most 25 lines: `verdict`, `ac_status` (per AC on head), each finding one line with severity, the referee's last line, `skill_lessons`, and end with:
`MAIN SESSION: check and save these skill_lessons now.`
