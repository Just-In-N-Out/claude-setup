# FIXER round 10: dream-pass (claude-setup), Full pipeline: the live editor call refused on a second model

Role: FIXER, and first a debugger. The story was accepted on `ee17d98`. Its final rebase (pure, onto `main` `23fd9580`, new head `374ac3ec97f786f3836cd4f24e97b60703820110`) wrote a rebase receipt in which 41 of 42 AC tests passed and **AC37 failed**: the live editor call was refused by the dream's own model check with `editor ran on claude-opus-4-8, claude-opus-5-5, not claude-opus-5-5`. The same test passed four times earlier (verifier and auditor, on two heads). This matters beyond the test: in production the dream would refuse its editor run whenever this happens. Find the cause, fix it test-first, commit, stop `ready-for-next-review`.

- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`. AC29: every dream agent call's command line has `--model claude-opus-5-5 --effort xhigh` and the isolation flags; AC37: "both return valid structured output from `claude-opus-5-5`, no transcript file is added …, the editor's refused paths are listed". Justin's words on models: "Nonstick to Opus xhigh" (voice slip for "No, stick to Opus xhigh"): every dream agent runs on Opus 5.5 at xhigh.
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `374ac3ec97f786f3836cd4f24e97b60703820110`, base `23fd9580f7b9634fef064d24ced1d9908155e332`. Work on top of this head; don't rebase.
- The check: `.claude/dream/lib/dreamlib/agents.py` about lines 132–138: `used = set((out.get("modelUsage") or {}).keys())` … `elif used != {model}: res.error = "… ran on …, not …"`.
- The failure's records: `~/.hermes/plans/claude-setup/evidence/dream-pass/rebase/receipt-374ac3e.log` (the AC37 section) and `finisher-3/stop.txt`.
- Evidence for this round: `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-10/`. Write receipts there as you go.
- Never edit the live `$HOME` files, never push, sync, merge or install, never run a real dream against Justin's real home.

## Skills (Skill tool), one line each
`systematic-debugging` first (prove the cause before changing anything), then `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `security-best-practices` (this check is a guard on which model writes Justin's files), `git-commit-rules`.

## 1. Find the cause (no code change yet)
- Read the receipt's AC37 output and the test (`.claude/dream/tests/test_agents.py`, about line 190). What did the CLI's JSON hold for the editor call: every `modelUsage` entry with its input, output and cache tokens and cost? If the receipt does not show it, you need a fresh real call.
- **Real calls are allowed but bounded: at most 6 real `claude -p` calls in this whole round**, each the editor's exact command line as `agents.editor_cmd` builds it, on a scratch folder, with a tiny prompt. Save each call's full JSON output in `fixer-10/` (scrub nothing in it is secret; check with gitleaks before saving). Justin's weekly usage limit is nearly spent: if a call is refused for the limit, stop and report.
- Establish: when does a second model appear (always, only when a permission is denied, only on the first call of a run, only with `--restricted`, only with certain tools, at random)? How many tokens does it account for, and on which turn? Is it a Claude Code side call (for example a permission or auto-mode classifier, a summary, a title) rather than the agent's own turns? Check `claude --help` and the CLI's own documentation available locally for anything that names such a side model or a flag that turns it off or pins it (Claude Code 2.1.322 is installed; the CLI updates itself). Do not guess: say what you proved and what you could not.

## 2. Fix, test-first
- The rule to keep: **every turn of the dream's own agent work runs on the pinned model** (Opus 5.5, at the pinned effort), and a call whose own work ran on anything else is refused. What may change is how the script tells the agent's own work from the CLI's side calls.
- Prefer, in this order: (a) a CLI flag or setting, verified on a real call, that keeps every model call on the pinned model or turns the side call off, added to the isolation flags (AC29's test then pins it, and the preflight stops a run when the flag is missing); (b) if no such flag exists, a check that still refuses any call whose agent turns ran on another model but accepts the CLI's own side model, identified narrowly (by what you proved about it: which model ids, how few tokens, no structured output), and records it in the run's log so Justin can see it.
- **If neither (a) nor (b) can be done without loosening what "runs on Opus 5.5" means**, or the side model is doing real work on Justin's files, stop and report `plan gap` with lettered options and the evidence: that is Justin's decision ("stick to Opus xhigh").
- Tests: a fake-`claude` fixture with the exact `modelUsage` shape you captured (two models), RED on the current head, GREEN after; and the cases that must still be refused (the agent's own output on another model; a second model with a large share of the tokens; no pinned model at all). Register mutants for the new clauses in `.claude/dream/tests/mutants.py` and show them killed. AC29's and AC37's test names stay as the plan writes them.
- Then run AC37's live test once on your fixed head (two real calls, counted in the 6) and show it passes.
- The whole dream suite and both hook suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` and `TMPDIR` in your cache folder.
- One or two commits, plain `git commit -m` with one-line subjects, repo identity (`Justin <issajustin04@gmail.com>`), **no** AI or Co-Authored-By trailer. Tree clean at the end.
- If you change a line of `.claude/dream/DREAM.md`, list it in your report (that file changes only when Justin says so).
- Update nothing outside the worktree; the main session saves any memory note about the CLI's behaviour from your evidence.

## Environment
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-fixer-10/` (mkdir, no -p); big things under `~/.cache/dream-pass-fixer-10/`; remove both by literal path.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`; never `| grep -q` under `pipefail`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes.

## Report
Return `{status: ready-for-next-review|stopped, head, cause: proven|not proven with evidence, real_calls_used, fix: flag|narrow check|plan gap, findings[{id: "AC37-live", outcome, test, commit, evidence}], dream_md_lines[], mutants{killed, survived[]}, suites[{name, tally}], live_ac37: pass|fail, questions[{q, options[], recommended}], found_else[], skill_lessons[]}`.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
