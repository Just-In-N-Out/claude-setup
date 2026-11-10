# VERIFIER: dream-trim (claude-setup), Mini pipeline, on the head a clean review covers

Role: fresh VERIFIER, read-only on the source. You never saw the build, the fix or the reviews' work. Edit nothing in the worktree, the plan or `$HOME`; don't commit, push or sync; never run `land.sh` against the real home. Write only in `<evidence>/verifier/` (replace the earlier verifier files there: they are for head `bac67c34`, before the fix round) and your own scratch.

Inputs:
- Approved plan (contract, read-only): `~/.hermes/plans/claude-setup/evidence/dream-trim/plan-approved.md` ("Justin's answers" is binding; AC9 is `(live)`, owed to Justin).
- Worktree `/home/justin/.claude-setup-wt/dream-trim` (branch `dream-trim`), head `2bc4495d583d8b08e4d878f160084f6dcbee259a`.
- Base `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (= `git -C <worktree> merge-base HEAD main`; gitdir `~/.claude-setup.git`).
- On this branch pass 1 is commit `d9217352` and pass 2 is the head; `41bcb24e` is the commit that lands everything except pass 2.
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-trim/`

## Skills (Skill tool), one line each
`engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`. Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` exactly (VERIFIER role).

## Job
- Before you start, confirm HEAD equals the head above and `git -C <worktree> status --porcelain --untracked-files=all` is empty. If not, stop and report it.
- Re-run the gates: the whole `.claude/setup/trim/trim.test.sh` suite and every suite the plan's AC4 names; tallies must match the base by test name. `codex-parity.test.sh` fails `ac4`, `ac19` and `ac21` on the base, and its `ac7_claude_hooks_unchanged` is flaky (one cortexos-memory case): run the base suites twice and compare by name before calling anything a regression.
- For each AC1–AC8: run its named test by name on head and on base (base copy via `git clone -q ~/.claude-setup.git <scratch>/base && git -C <scratch>/base checkout -q --detach <base>` with head's test files copied in; never `worktree add` against the setup repo, never a `git archive` copy for suites that check what git tracks), logs stamped `HEAD=<sha>` on the first line and `EXIT=<code>` on the last, one terminal-capture PNG per AC as its screenshot (headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`). `ac-check.sh` proves only the one test each `ac.json` row cites: cite the test that covers every clause of that AC. Before judging an AC, read `git log -p <base>..HEAD -- <its test files>` against the plan.
- Check the claims yourself, not from the builder's tools alone: that pass 1 changed no byte of any moved line (your own comparison of `d9217352^` and `d9217352`), and that every protected safety line is still in its file after pass 2.
- AC9: `"accepted": false, "not_run": "live: <why>"`.
- Write `verifier/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`; self-check blind as the doc says (copy to scratch, run `ac-check.sh` without `--reviews`, delete the copy).

## Environment
- Scratch: fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-trim-verifier-1/` (mkdir, no -p); big files in `~/.cache/dream-trim-verifier-1/`; remove both by literal path, and give each case its own fresh folder rather than removing a folder named through a shell variable.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound. The AC4 suites take about 3.5 minutes per side.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], verifier_ac_json, found_else[], skill_lessons[]}`. `clean` needs every AC accepted, the `(live)` one marked not_run aside.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
