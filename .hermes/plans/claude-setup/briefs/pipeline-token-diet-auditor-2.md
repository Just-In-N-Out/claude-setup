# Brief: blind AC AUDITOR, story `pipeline-token-diet`

## Role
You are the fresh, blind **AC auditor** for Justin's setup story `pipeline-token-diet`. You prove every acceptance criterion (AC) on your own, from the approved plan and the code alone.
- **Read-only:** change no source, make no commit, start no agents.
- Never write the live `~/.claude`, `~/.hermes/skills`, `~/.codex`, `~/Documents/FigmaToBricksV2`, global git config, any ref or admin file of `~/.claude-setup.git`, or GitHub.
- Write only into your own folder, `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/auditor/` (new and empty), and your scratch folder.
- **Stay blind:**
  - Don't open any other file or folder under `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/` (only `plan-approved.md` and your own `auditor/`; everything else there is other agents' and off limits, `base-tallies/` included).
  - Don't open any brief in `~/.hermes/plans/claude-setup/briefs/` except this one, and not `~/.hermes/plans/claude-setup/pipeline-token-diet.md` (use the approved copy).
  - Don't open other agents' scratch (`~/.cache/pipeline-token-diet-*` other than your own).

## Skills to load first
- `engineering-best-practices`
- `mutation-testing-discipline`: use it to check that a test exercises every clause of its AC.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the live one: this story runs on today's gate scripts until it is merged). It covers the run recipe, the base-commit check, screenshots, the `ac.json` format and the blind self-check. Also read the header of the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which defines the exact `ac.json` format.

## What you get
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/plan-approved.md` (read-only). Read "Amendments", "Justin's answers", "The chosen set", "Acceptance criteria", "Where the rules are stated" and task 0; the analysis sections are background.
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`, a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Head:** `c887b3b4ed19c9198cc0316f2c860f215c672ff0`.
- **Base:** `b5927606c8a0b9de1e62d4565b4a74d1c43e49b1`. Confirm it with `git -C <worktree> merge-base HEAD main`.
- This head is the story rebased onto a newer `main`. Where the plan names an older base commit, the base above is the one that counts.
- **Before you start,** confirm HEAD equals `c887b3b4` and that `git status --porcelain --untracked-files=all` is empty (the repo has `status.showUntrackedFiles=no`). If either check fails, stop and report it.

## The work
- **For every AC (AC1–AC6) in the plan,** decide for yourself whether head meets every clause, and prove it with receipts per `ac-verification.md`:
  - a log of the AC's own named test on head (numbered TAP; `HEAD=` first line, `EXIT=` last line). The tests are under `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/`, in the files the plan names; run one with `bash <file> <test_name>`;
  - the same test on the base commit with head's test file, where it must fail (or carry a `base_exempt` reason for a regression AC);
  - one PNG terminal capture per AC;
  - for any clause the test seems not to exercise, a mutation in your own copy, showing the test fails on that clause.
- **Don't stop at the test.** Probe the clauses wherever the plan's wording claims more than the test shows: read the rule files against the plan's routing table yourself (Full and Mini, every file in "Where the rules are stated"), and try the two changed scripts with real git, real bash and hand-made review records and receipts in a temp folder.
- **The regression AC** (`existing_suites_pass`) runs only when named and needs `PIPELINE_RULES_BASE=<folder of base tallies>`. Make your own base tallies the way the plan's task 0 says, in your own folder.
- **Base and mutation copies:** use `git clone -q ~/.claude-setup.git ~/.cache/pipeline-token-diet-auditor2/<name>` then `git -C … checkout -q --detach <sha>`. Don't use `git worktree add`, which writes admin files into the setup repo.
- **Live AC:** AC6 is `(live)`: `"accepted": false, "not_run": "live: <why>"`.
- Run every suite and mutation run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- **Write the report** to `auditor/ac.json` in the `ac-check.sh` format. Self-check it blind, as `ac-verification.md` says: `cp` your files to a scratch folder and run the live `ac-check.sh` with your report for both report arguments. Then delete the copy.

## Scratch and the desktop
- Scratch, `TMPDIR`, Chrome profiles and anything large in `~/.cache/pipeline-token-diet-auditor2/` (`/tmp` is a shared RAM tmpfs).
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so, find what grew, and rerun under the cap, never bare.
- **Gotchas:** in the Bash tool `grep` is ugrep: use `/usr/bin/grep` (inside `xargs`, `find -exec` or `systemd-run`, `command grep` does not work). Headless Chrome needs `env -u DISPLAY -u WAYLAND_DISPLAY` and `--disable-software-rasterizer`. Never `pkill -f`. `tail -n N`.

## Output (final message)
- `verdict`: `clean` when every non-live AC is accepted; otherwise `not-clean`.
- `ac_status[{ac, accepted, test, log, base_log or base_exempt, screenshot, evidence}]`, the same as `ac.json`.
- `findings[{id, severity, file_line, scenario, problem, evidence}]`. Every P0–P2 finding must name a concrete real-use scenario; without one, it is P3.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
