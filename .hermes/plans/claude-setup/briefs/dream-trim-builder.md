# Brief: BUILDER, story `dream-trim` [claude-setup] (Mini pipeline)

## Role
You are the **builder** in Justin's Mini pipeline (`~/.claude/CLAUDE.md`, "Bugs and Stories"). You build the approved plan test-first in its worktree and stop at `ready-for-review`. The plan is approved; don't re-plan. You don't:
- review your own work, or start other agents;
- push, merge into `main`, run the real `~/.claude/setup/sync.sh`, or run `land.sh` against the real home (landing is the finisher's step);
- write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/Documents/FigmaToBricksV2` or global git config.

Every change goes into the worktree's copies.

**Mini pipeline:** if the job turns out to need a design decision, or to be bigger or riskier than the plan says, stop with `status: stopped`, `stop_reason: escalate to full`.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks (`~/.claude/githooks`) check every commit. A deny or a refusal is the rule, not a bug to work around.

## Skills to load (Skill tool) first, and say so in one line each
- `engineering-best-practices`
- `test-driven-development`: write a failing test before each change.
- `mutation-testing-discipline`: the lossless checker (`trim-check.py`) is a data-integrity guard; AC5 proves it can fail. Run mutants under the memory cap.
- If something fails unexpectedly, use `systematic-debugging`; don't patch around it.

## The approved plan
- **Plan:** `~/.hermes/plans/claude-setup/dream-trim.md`. The approved read-only copy, which `ac-check.sh` reads, is `~/.hermes/plans/claude-setup/evidence/dream-trim/plan-approved.md`. Follow it task by task, starting with Task 0 (the baseline tally of the existing pin suites on the base).
- **Approval:** Justin said "Continue sorry" after the plan and its four questions were shown; the main session read that as "go" with every recommended option (recorded under "Justin's answers" at the end of the plan). Don't reopen the questions.
- **ACs:** AC1–AC9. AC9 is `(live)`: Justin reads the pass 2 diff and summary and says "land pass 2". Build pass 2 as its own second commit with `pass2.diff` and `pass2-summary.md` in the evidence folder, written in plain words for him; don't claim AC9.
- **Tests:** each AC has exactly one named test in `.claude/setup/trim/trim.test.sh`. Keep every test name exactly as the plan writes it.
- **Pass 1 moves whole lines without changing a byte.** Pass 2 never rewords or drops a protected safety line (push, authorship, approval, guards, merge policy), and every removal gets its ledger row.

## Running alongside: `dream-pass`
A second builder is building `dream-pass` (Full) now in `~/.claude-setup-wt/dream-pass`. It will add one pointer line and a `references/repeat-mistakes.md` file to `leorna`, `figma-to-bricks` and `feature-dispatch`. Stay within this plan's files. This job lands first.

## Where you work
- **Worktree:** create it as the plan says, `git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/dream-trim" -b dream-trim main`.
  - Record the base SHA (`main` at that moment) in your report.
  - Before the first write, check that `git -C ~/.claude-setup-wt/dream-trim rev-parse --show-toplevel` prints the worktree path, not `$HOME`.
- **Commits:** branch `dream-trim` only, with plain `git commit -m "…"`. The identity is `Justin <issajustin04@gmail.com>`.
  - **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one; the commit-msg hook refuses it anyway.
  - No author overrides. Never touch `main`, never push. Never commit or push inside `~/.hermes/skills-library`.
  - Wait for a gate's exit before committing.
- **Dirty check:** the repo has `status.showUntrackedFiles=no`, so before reporting check `git status --porcelain --untracked-files=all` and make it clean.
- **Moving `main`:** the four files change on `main` many times a day. **Don't rebase**; the mover is re-runnable by anchor so the finisher can rerun it on the newest `main`.

## Never touch real state
- Tests (AC8's landing test included) use a scratch home, a scratch setup repo and a scratch project folder, with `HOME` and `GIT_CONFIG_GLOBAL` overrides. They must not touch the real setup repo, the real project repo or the real sync lock.

## Evidence
`~/.hermes/plans/claude-setup/evidence/dream-trim/builder/` (and `pass2.diff`, `pass2-summary.md`, `base-pins.txt` where the plan names them). For each non-live AC:
- the passing run as a log in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`'s format (first line `HEAD=<sha>`, last line `EXIT=<code>`), named `acN-<testname>.txt`;
- one PNG terminal capture of that run. On this desktop, use headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`;
- for AC5, the runs showing the checker failing on each planted loss.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/dream-trim-builder/` folder. Create it fresh with `mkdir` without `-p`, and remove it by its literal absolute path.
- `/tmp` is a shared RAM tmpfs, so point `TMPDIR` and anything large at `~/.cache/dream-trim-builder/`.
- **Memory:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first; if earlyoom killed it, say so, find what grew, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`, never bare.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` or `/usr/bin/grep`.
  - Coreutils are uutils (`mkdir` is not atomic here), so use `tail -n N` and give `touch -d` an offset.
  - Never `pkill -f` (a pattern can match your own shell). `$!` after `setsid … &` is setsid's own PID.
  - A foreground Bash command is moved to the background after about 180 s: wait on long runs with repeated polls of under 3 minutes, each with the Bash `timeout` set above its bound.
  - `sync.sh` copies a project's own `CLAUDE.md` over the `~/.claude/project-docs/<name>/` copy before every commit; the plan's landing handles this, don't work around it differently.

## Rules for you
- You can't ask Justin anything. On a real trade-off, make the ruling and write it down as "My ruling, not yet confirmed" in `rulings[]` and in `evidence/dream-trim/builder/INVENTORY.md`. If it can't be decided safely, stop with `status: stopped` and list the options.
- If you run low on steps, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`, naming the worktree and the last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity).
- Never edit a skill or memory file outside the worktree. Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none`, or a one-line proposal for a check. An empty list is the normal answer.

## Output contract
Stop when every non-live AC's test passes on the committed head and the tree is clean. Report:
- `status`: `ready-for-review` or `stopped` (with `stop_reason`);
- `worktree`, `branch`, `base_sha`, `head_sha`, and the pass 1 and pass 2 commit SHAs;
- the four files' sizes before and after each pass;
- per AC: test name, pass/fail, and evidence files (`shots[]` for the PNGs);
- `rulings[]`, `steps_for_justin[]`, `found_else[]`, `skill_lessons[]`.

End the report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
"Continue sorry" (2026-11-09, after the plan and its questions were shown). Earlier the same day: "But first we need to trim Md files since they big ye". If this brief and his words disagree, follow his words.
