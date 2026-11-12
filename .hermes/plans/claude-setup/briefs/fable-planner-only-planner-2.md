# Brief: planner (amendment) — fable-planner-only (Mini)

**Role:** PLANNER, amendment round. You edit one file only: `~/.hermes/plans/claude-setup/fable-planner-only.md`. No edits to skills, scripts, hooks, CLAUDE.md, settings or memory. You don't start other agents.

**Skills to load first (Skill tool):** `engineering-best-practices`, `implementation-planning`.

## Where things stand
Read the plan first, then the evidence in `~/.hermes/plans/claude-setup/evidence/fable-planner-only/`: `auditor/ac.json` (AC2/AC3 refused), `review-2/review.json`, `review-3/review.json`, `fix-1/`, `fix-2/corpus-diff.log`.

- The **rule-text edits are done and correct**: AC1 `routing_text_agrees` has passed on every head and in every review. Keep them exactly as they are.
- The guard test's **check 7** (`.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh`) reads English to decide which role a model word belongs to, and three rounds have chased its tail:
  - head `8a721839` (clause reading): missed wrong models in asides, step headings and new table rows → auditor refused AC2/AC3.
  - fix 1 `2629ccb0` (model binds to every role before it): caught them, but falsely refused correct text (R2-1, R2-2: "The verifier, unlike round 1, runs on Opus 5.5 high.", "Only the planner, not the builder or a reviewer, runs on Fable 5.2 high.").
  - fix 2 `9f6d93b8` (nearest role, with skips): passed correct text again, but let "The verifier, like the AC auditor, runs on Opus 5.5 xhigh." and "**Verifier (Opus 5.5 xhigh, 2026-11-12).**" through (R3-1 P1, R3-2/R3-3 P2).
- Worktree `~/.claude-setup-wt/fable-planner-only`, branch at `9f6d93b8`, story base `bcfeb5fe`.

## Justin's pick (2026-11-12): "Simplify the check"
Replace the sentence reading with a **simple, predictable rule**, and **reword AC2/AC3 to name the shapes the test covers** (`implementation-planning`: a scanner claimed to refuse a whole category needs fixtures in the files' own shapes, otherwise word the AC by the shapes covered). Justin approves the changed ACs.

## What the amendment must hold
1. **The rule.** Something a reader can predict without parsing English, that is fail-closed for the shapes the rule files actually use. Prefer a rule that a correct line can always satisfy by a simple, documented rewording over one that tries to understand every phrasing. Ideas to weigh (pick one, justify in 2–3 lines, with what it gives up): e.g. any line in a scanned rule file that names Fable must also name the planner (or plan/re-plan) or sit in a marked history line (`*Why`, a dated `(user, 2026-…)`/`(Justin, 2026-…)` note, `(Superseded …)`); any line that says xhigh must name only the roles routed to xhigh (builder, AC auditor, round 1); plain "high" next to round 1 without xhigh refuses. Decide whether to keep fix 2's code, fix 1's, head's, or replace check 7 outright — the fixer starts from `9f6d93b8`.
2. **Run it on today's files first** (prototype on a scratch copy of the worktree at `9f6d93b8`): every current rule file, project `CLAUDE.md` copy and the Codex header must pass; list any line that needs a small rewording to satisfy the rule and put those rewordings in the plan as exact edits (they're part of the fix).
3. **AC2/AC3 reworded** by the shapes covered (step heading, table row, comma/paren aside, plain sentence, "like X" remark, dated paren — whichever the rule handles), marked **(amended, Justin approves)**, with the test names unchanged if you can. AC1 unchanged. Old→new wording in one line each.
4. **Test cases:** which of the existing 96+ refusal cases and the must-pass controls (fix 1, fix 2, review 2/3 probes) stay, go or change, and the named mutations the fixer must show caught. Every review-3 wrong line (R3-1, R3-2) must be refused; R3-3's correct lines ("Every round after round 1 runs on Opus 5.5 high.") must pass or be listed as needing a rewording, with that rewording in the rule's doc comment.
5. **A short fixer task list** (test-first, from `9f6d93b8`, one commit, test file plus any rewordings), then the rest of the loop is unchanged: fresh review of the fix commits → verifier → blind auditor → `ac-check.sh`.
6. Add a dated "Amendment 1 (2026-11-12)" section near the top; leave the earlier sections as history.

Keep it short.

## Rules for every agent
- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if it was, say so and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- `grep` in the Bash tool is ugrep and `find` is bfs; use `/usr/bin/grep` and `/usr/bin/find`. Set `TMPDIR=~/.cache/fable-planner-only-planner2`.
- **skill_lessons:** list reusable lessons as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. Never edit skills or memory yourself.

## Report back
At most 30 lines: the rule chosen in one line and what it gives up, the reworded AC2/AC3 (old→new), any rewordings of rule files it needs, prototype result on today's files, any question for Justin, `skill_lessons`, and end with:
`MAIN SESSION: check and save these skill_lessons now.`
