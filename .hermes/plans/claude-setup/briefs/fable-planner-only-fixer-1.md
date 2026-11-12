# Brief: FIXER 1 — fable-planner-only (after ac-check NOT ACCEPTED)

## Role
You are the fresh **fixer** for Justin's setup story `fable-planner-only`. The blind AC auditor did not accept AC2 and AC3. Fix them test-first, on the story's branch, then stop at `ready-for-next-review`. You don't start other agents, merge, run `sync.sh` or push. Don't change the approved ACs' wording or the plan.

## Skills to load first (say so)
`engineering-best-practices`, `receiving-code-review` (verify each failing case yourself before fixing it; push back with evidence on any you think is wrong), `test-driven-development`, `mutation-testing-discipline`.

**Read before you start:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Inputs
- Worktree `/home/justin/.claude-setup-wt/fable-planner-only`, branch `fable-planner-only`, head `8a7218393d89df453c86d29fd1b7d6f5c854052f`, base `bcfeb5fe9fffcee71870aec1f9349e0c47105741`. Confirm HEAD and a clean `git status --porcelain --untracked-files=all` first.
- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/fable-planner-only/plan-approved.md`.
- The gate's verdict:
  ```
  AC1  ACCEPTED
  AC2  NOT ACCEPTED: auditor did not accept it
  AC3  NOT ACCEPTED: auditor did not accept it
  NOT ACCEPTED: 2 of 3 ACs on 8a72183
  ```
- Both reports: the auditor's `…/evidence/fable-planner-only/auditor/ac.json` (probe logs in `auditor/mutations/`, summary `mutations-8a72183.log`, harness in `auditor/tools/`) and the verifier's `…/verifier/ac.json`. Also review-1's P3s R1-2 and R1-3 in `…/review-1/review.json` (same class of hole).

## What the auditor found (from its report)
Check 7 in `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh` splits clauses at `, ( ) |`, so role and model never share a clause. These single-line additions to a rule file pass `routing_text_agrees` but AC2/AC3 say they must be refused:
- AC2 (Fable on a non-planner role): `7. **Finisher (Fable 5.2 high).** Rebases and merges.` · `| Second reviewer (a fresh opinion) | **Fable 5.2** | **high** |` · `The AC auditor, a fresh agent, runs on Fable 5.2 high.` · `The finisher (a fresh agent) runs on Fable 5.2 high.` · `- Round 1, the full review, runs on Fable 5.2 high.`
- AC2 "names the wrong place": with file:line dropped from check 7's output, `fable_only_plans` still passes (auditor mutant T7) — the test must assert the place.
- AC3: `6. **Verifier (Opus 5.5 xhigh).**` · `- Fixer (Opus 5.5 xhigh): fixes the listed findings.` · `Round 1 is reviewed on Opus 5.5 high.` · `9. **Reviewer, round 1 (Opus 5.5 high).**`

## What to do
1. **Red first:** add those shapes (step, table row, comma aside, paren aside, for each non-planner role, plus plain-high-on-round-1 as a new statement) as cases in `fable_only_plans` and `xhigh_only_where_routed`, each asserting the refusal *and* the file:line in the message. Show them `not ok` on head. Capture to `E/fix-1/red.log`.
2. **Green:** fix check 7 (e.g. judge a whole sentence/line/table row, not single sub-clauses; strip `**`) so all of them are refused, while every legitimate line already on head still passes — `routing_text_agrees` must stay `ok` on head, the planner's Fable lines, dated *Why* history, model lists and board examples must not trip it. Keep it working on macOS `/bin/bash` 3.2 + BSD tools: also run as `PATH=/usr/bin:/bin /bin/bash`.
3. **Mutations:** show the new cases catch mutants of the new check 7 logic (and the auditor's T7). Under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Capture to `E/fix-1/mutations.log`.
4. **Regression:** full `pipeline-rules.test.sh`, `review-check.test.sh`, `ac-check.test.sh` all pass on the new head. One log + one terminal-capture image per AC in `E/fix-1/`.
5. **Commit** only the files you changed (expected: just the test), plain `git commit -m "fable-planner-only: check 7 judges whole lines, so asides and table rows can't hide a wrong pairing"` — no author override, no AI trailer. Scope gate: `git status --porcelain --untracked-files=all` clean after.

Out of scope (follow-ups already): R1-1 memory note, R1-4 temp-folder cleanup — unless the fix touches the same lines anyway.

`E = ~/.hermes/plans/claude-setup/evidence/fable-planner-only/`. Set `TMPDIR=~/.cache/fable-planner-only-fixer1`.

## Rules for every agent
- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if it was, say so and rerun under the cap.
- `grep` in the Bash tool is ugrep and `find` is bfs; use `/usr/bin/grep` and `/usr/bin/find`.
- **skill_lessons:** list reusable lessons as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. Never edit skills or memory yourself.

## Report back
At most 30 lines: `status: ready-for-next-review` (or `stopped` + reason), new head SHA, fix commit(s), each auditor case and its result, any case you pushed back on and why, regression results, `skill_lessons`, and end with:
`MAIN SESSION: check and save these skill_lessons now.`
