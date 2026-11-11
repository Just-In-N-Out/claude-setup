# Brief: REVIEWER 12 (delta, the refusal-fallback fix), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 12** for Justin's setup story `dream-pass`. The story was accepted; its final rebase receipt then failed on the live test AC37 because the real CLI reported a second model (`claude-opus-4-8`) for the editor call and the dream's model check refused it. A fixer found the cause and fixed it in two commits. You review **only those commits**. You **only report**: no source changes, no commits, no other agents, nothing written outside `<evidence>/review-12/` and your scratch folder, never push, sync, merge or install, never run a real dream.

**Be sparing:** Justin's weekly usage limit is nearly spent. You may make **at most 2 real `claude` calls** (one run of AC37's live test), and only if your reading leaves a doubt the fake tests cannot settle.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`, `security-best-practices` (this check guards which model writes Justin's files), `mutation-testing-discipline`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` for the record's format and the severities.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Previous head (your `from`):** `374ac3ec97f786f3836cd4f24e97b60703820110` (the pure rebase of the reviewed `ee17d988`; `review-check.sh` treats it as covered by review 11). **Head:** `6b9dff26a8d7ce7f51c144bfb76208d7a916ec95`. **Base:** `23fd9580f7b9634fef064d24ced1d9908155e332`.
- Review `git -C <worktree> diff 374ac3ec..6b9dff26`: commits `da4d429d` (the fix, its tests, the fake `claude`) and `6b9dff26` (mutant kill sets); 4 files, about 116 added lines.
- **Before you start,** confirm HEAD equals `6b9dff2` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- The plan (`~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`): AC29 (every dream agent call carries `--model claude-opus-5-5 --effort xhigh` and the isolation flags; the preflight stops a run on a missing flag) and AC37 (live: both calls return valid structured output from `claude-opus-5-5`; no transcript; the editor's refused paths are listed). Justin: every dream agent runs on Opus 5.5 at xhigh ("stick to Opus xhigh").
- The fixer's records: `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-10/` (`cause.md`, `call-1-probe.*`, `call-2-tiny.*`, `red-374ac3e.log`, `green.log`, `ac37-live-6b9dff2.log`, `mutants-6b9dff2/report.md`). The failure: `rebase/receipt-374ac3e.log`.

### What the fixer reports
- **Cause** (from the CLI's own changelog and code, not reproduced live): the CLI's refusal fallback. When the model's safeguards flag a message, Claude Code 2.1.322 by default carries the turn on to an older Opus and records it in `modelUsage` under that model; so it was the agent's own work, and the refusal was correct. `~/.claude/cache/changelog.md` line 654 names `CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK=1`; the binary's settings schema has `switchModelsOnFlag` (default on); the result JSON has `safety_stops`.
- **Fix:** every dream call now runs with `CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK=1` (`agents.CALL_ENV`, passed via `call_environ(R)`), and the `--settings` file is `{"hooks": {}, "switchModelsOnFlag": false}` (`agents.CALL_SETTINGS`). `call()` also refuses any result with `safety_stops > 0`. The strict check `used != {model}` is unchanged. A preflight cannot see an environment variable or a setting; AC29's test pins both.
- **Tests:** AC29's test pins the settings file and the environment on every role; new test `test_a_flagged_call_never_goes_on_on_another_model_and_is_refused`; the fake `claude` models the CLI's switch. Mutants X29e–X29i killed (X29e and X29g alone are seen only by AC29's test, since either switch alone turns the fallback off). Dream suite 94 passed; AC37 live passed once on the head.
- **Named limits:** AC37's live probe asks the model to read outside its folder and write "escaped", which may itself get flagged now and then; it then fails as "stopped by safeguards". A second CLI path (usage-limit model substitution, `CLAUDE_CODE_NO_MODEL_FALLBACK=1`) was found and not added, since it was not shown to be involved; the strict model check still refuses such a call.

## Your job
1. **Is the cause right?** Read `cause.md` and check its claims against `~/.claude/cache/changelog.md` and, where it cites the binary, against the strings of `~/.local/share/claude/versions/<installed version>` (read-only). Say what is proven and what is not.
2. **Does the fix keep Justin's rule?** Every call the dream makes (helpers, editor, checker) must carry both switches, through every code path that starts `claude` (not only the one AC37 exercises); no path may accept a result whose own work ran on another model; `safety_stops > 0` is refused with a reason Justin can read in the log and the session-start line. Does the environment the dream passes to `claude` keep everything else it needs (the subscription login, `PATH`, `HOME`), and does it drop nothing the isolation flags relied on?
3. **The second fallback** (`CLAUDE_CODE_NO_MODEL_FALLBACK`): read what the changelog and binary say about it. If a usage-limit substitution would make the dream's own work run on another model and the strict check is the only thing that stops it, say whether leaving the switch out is a gap (with a concrete scenario) or harmless (the strict check refuses it and the run stops cleanly).
4. **Tests can fail:** run the named tests (AC29's, the new test) on a scratch clone of the head, and the mutants X29a–X29i yourself (`.claude/dream/tests/mutants.py`), each killed at an assertion; the whole dream suite under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` with `DREAM_TEST_ROOT` in your scratch.
5. **The AC37 probe's wording** (named limit 1): is a probe that may be flagged at random a test that can fail falsely in normal use (a P2 by the pipeline's scale: "a test that can't fail" is P2, and so is one that fails falsely in normal use if it blocks the pipeline)? Say how often, from the evidence (one flagged run in about 11), and what the smallest change would be. Changing a live test's prompt may be a plan question; say so if it is.
6. Anything else outside these commits is P3.

## Output: `<evidence>/review-12/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-12/review.json`: round 12, scope "delta", from = `374ac3ec97f786f3836cd4f24e97b60703820110`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 23fd9580f7b9634fef064d24ced1d9908155e332 <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on. If it complains that `from` is not a reviewed head, report its line exactly.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-12/` (mkdir without -p); remove it by literal path at the end. Write receipts into `review-12/` as you go.
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], cause_proven: yes|partly|no with evidence, real_calls_used, review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC29 and AC37.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
