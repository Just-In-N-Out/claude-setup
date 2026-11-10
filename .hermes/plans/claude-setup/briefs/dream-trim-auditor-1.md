# AC AUDITOR (blind): dream-trim (claude-setup), Mini pipeline

Role: fresh AC AUDITOR, read-only on the source. Prove every AC yourself. You get only the inputs below: never open the evidence folder's other subfolders (`verifier/`, `review-*/`, `fixer-*/`, `builder/`) or its other files, or any brief or report. Edit nothing in the worktree, the plan or `$HOME`; don't commit, push or sync; never run `land.sh` against the real home.

Inputs:
- Approved plan (contract, read-only): `/home/justin/.hermes/plans/claude-setup/evidence/dream-trim/plan-approved.md` ("Justin's answers" is binding; AC9 is `(live)`, owed to Justin).
- Worktree: `/home/justin/.claude-setup-wt/dream-trim` (branch `dream-trim`)
- Head: `2bc4495d583d8b08e4d878f160084f6dcbee259a`
- Base: `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (setup repo gitdir `~/.claude-setup.git`; run its git with `-C <worktree>` or `:/` paths)
- Your folder: `/home/justin/.hermes/plans/claude-setup/evidence/dream-trim/auditor/` (create it; write `auditor/ac.json` and your logs and PNGs here)

## Skills (Skill tool), one line each
`engineering-best-practices`, `mutation-testing-discipline`. Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` exactly (AC AUDITOR role).

## Job
For each AC1–AC8: run its named test by name on head and on base (base copy via `git clone -q ~/.claude-setup.git <scratch>/base && git -C <scratch>/base checkout -q --detach <base>`, head's test files copied in; never `worktree add` against the setup repo, never a `git archive` copy for suites that check what git tracks), logs whose first line is `HEAD=<sha>` and last line `EXIT=<code>`, one terminal-capture PNG per AC (headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`). Cite the one test per AC that covers every clause. Read `git -C <worktree> log -p <base>..HEAD -- <test files>` against the plan before judging. Probe any clause the test seems not to exercise with a mutant on a scratch copy.
- Where an AC compares head with a base tally of existing suites, take that tally yourself in a clone of the base, from two runs, counting a test as passing on the base when either run passes; don't rely on a tally file you did not make.
- AC9: `"accepted": false, "not_run": "live: <why>"`.
- Write `auditor/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`; self-check blind (copy to scratch, run `ac-check.sh` without `--reviews` on it, delete the copy).

## Environment
- Scratch: fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-trim-auditor-1/` (mkdir, no -p); big files in `~/.cache/dream-trim-auditor-1/`; remove both by literal path, and give each case its own fresh folder rather than removing a folder named through a shell variable.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound. The existing suites take about 3.5 minutes per side.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], auditor_ac_json, skill_lessons[]}`.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
