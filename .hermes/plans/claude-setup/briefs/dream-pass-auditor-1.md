# AC AUDITOR (blind): dream-pass (claude-setup), Full pipeline

Role: fresh AC AUDITOR, read-only on the source. Prove every AC yourself. You get only the inputs below: never open the evidence folder's other subfolders (`verifier/`, `review-*/`, `fixer-*/`, `finisher-*/`, `builder/`) or its other files (`baseline.md`, `follow-ups.md`), or any brief or report. Edit nothing in the worktree, the plan or `$HOME`; don't commit, push or sync; never install or start the dream's timer or service; never run a real dream against Justin's real home.

Inputs:
- Approved plan (contract, read-only): `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`. Its "Justin's answers" section at the end is binding and is part of the contract: every recommended option Q1 (a) to Q9 (a), and his 2026-11-10 decisions (a move may leave one pointer line of a fixed shape; a fold may not change a line's last word or number; option (b): a mistake already due to retire where it would be listed is not added or moved there; plain file names for pointers and new memory notes; his landing allowance). Read each AC together with those answers: AC17 and AC27 in particular are qualified by them.
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`)
- Head: `99bb2f31f8d18ca5dfe18d4d59de61925a64b7b2`
- Base: `63f09cb6ef84c490cc990f07b98bd27d85f5089a` (setup repo gitdir `~/.claude-setup.git`; run its git with `-C <worktree>`). The base has no `.claude/dream` at all: the story adds it.
- Your folder: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/auditor/` (create it; write `auditor/ac.json` and your logs and PNGs here)
- ACs: AC1–AC45. AC39, AC40 and AC41 are `(live)`, owed to Justin.

## Skills (Skill tool), one line each
`engineering-best-practices`, `mutation-testing-discipline`. Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` exactly (AC AUDITOR role).

## Job
- Confirm first that the worktree's HEAD is the head above and `git -C <worktree> status --porcelain --untracked-files=all` is empty. If not, stop and report.
- For each AC1–AC38 and AC42–AC45: run its named test by name on head and on base (base copy via `git clone -q ~/.claude-setup.git <scratch>/base && git -C <scratch>/base checkout -q --detach <base>`, head's test files copied in, as the doc says; never `worktree add` against the setup repo, never a `git archive` copy for suites that check what git tracks), logs whose first line is `HEAD=<sha>` and last line `EXIT=<code>`, one terminal-capture PNG per AC (headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`). Cite the one test per AC that covers every clause. Read `git -C <worktree> log -p <base>..HEAD -- <test files>` against the plan before judging: a test weakened to pass is a finding.
- Because the base has no code for most tests to run on, a base failure there only shows the test is new. For each AC, show its test can fail for the right reason: a one-line mutant of the head's code on a scratch copy that the named test kills at its own assertion (the story keeps a registry in `.claude/dream/tests/mutants.py`; use it where it has one for the AC and write your own where it has none or where you doubt it). Probe any clause the named test seems not to exercise.
- **AC37** is a named-only live test (`test_live_headless_calls_are_isolated_and_confined`): it makes two small real `claude` calls and must leave no transcript, history line or hook state. Run it once, as the test file's header says. If the call is refused for Justin's usage limit (HTTP 429, "weekly limit"), don't retry: record AC37 as not proven with that reason and say so at the top of your report.
- **AC38** (`regression_existing_suites_match_the_base_tally`): take your own base tally in a clone of the base, from two runs, counting a test as passing on the base when either run passes; don't rely on a tally file you did not make. `regression.sh` exists only on the head: read its header for its record mode and its root option, and record the base with the head's script. Some of the existing suites have millisecond limits and flip under load: check `uptime` first, run this gate with nothing else of yours running, wait and poll if the 1-minute load is above about 8, and rerun a failing suite alone on base and head before calling a mismatch a regression.
- AC39, AC40, AC41: `"accepted": false, "not_run": "live: <why>"`.
- Write `auditor/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`; self-check blind (copy to scratch, run `ac-check.sh` without `--reviews` on it, delete the copy).

## Environment
- Scratch: fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-auditor-1/` (mkdir, no -p); big files in `~/.cache/dream-pass-auditor-1/`; remove both by literal path, one fresh folder per case. Set `DREAM_TEST_ROOT` to a scratch folder so the tests write nothing under the live `~/.cache`.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result (a line reading "sending SIGTERM when mem avail <= 5.00%…" with no process name is its start banner, not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `xargs`, `find -exec` or `systemd-run`); never `| grep -q` under `pipefail`; desktop `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.
- **This desktop restarted twice today mid-run.** Write receipts as you go, in your evidence folder, not only in `/tmp` (a RAM disk that a restart clears), so a resumed run can pick up from them.
- **Be sparing:** Justin's weekly usage limit is nearly spent. 42 ACs is a lot of runs: script them (one loop that runs each named test on head and base, stamps the logs and makes the captures) rather than one tool call per AC. If a request of yours is refused for the limit, stop; your work so far is kept and you will be resumed.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], auditor_ac_json, skill_lessons[]}`.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
