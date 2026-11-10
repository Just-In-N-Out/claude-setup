# Brief: BUILDER, story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the **builder** in Justin's Full pipeline (`~/.claude/CLAUDE.md`, "Bugs and Stories"). You build the approved plan test-first in its worktree and stop at `ready-for-review`. The plan is approved; don't re-plan. You don't:
- review your own work, or start other agents;
- push, merge into `main`, or run the real `~/.claude/setup/sync.sh`;
- write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, `~/.claude/settings.json` or global git config;
- install or start the timer, enable linger, switch the dream to live, or run a real dream against Justin's real files.

Every change goes into the worktree's copies. Installing on this machine is the finisher's and Justin's step.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks (`~/.claude/githooks`) check every commit. A deny or a refusal is the rule, not a bug to work around.

## Skills to load (Skill tool) first, and say so in one line each
- `engineering-best-practices`
- `test-driven-development`: write a failing test before each change.
- `mutation-testing-discipline`: every guard that decides what may reach Justin's live files is a data-integrity guard. Run the plan's named mutants, always under the memory cap.
- If something fails unexpectedly, use `systematic-debugging`; don't patch around it.

## The approved plan
- **Plan:** `~/.hermes/plans/claude-setup/dream-pass.md`. The approved read-only copy, which `ac-check.sh` reads, is `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`. Follow it task by task, in its order.
- **Approval:** Justin said "Continue sorry" after the plan and its nine questions were shown; the main session read that as "go" with every recommended option (recorded under "Justin's answers" at the end of the plan). Don't reopen the questions.
- **ACs:** AC1–AC45. AC39, AC40 and AC41 are `(live)`: they are Justin's; build what they need, don't claim them. Tests the plan marks as named-only (the live call test, AC37) run only when named.
- **Tests:** each AC has exactly one named test. Keep every test name exactly as the plan writes it.
- **The rules file:** `~/.claude/dream/DREAM.md` exists as a draft and `~/.claude/CLAUDE.md` has a "Dream Pass (planned, not running yet)" section. The plan's section "Changes to DREAM.md" lists the edits; make them in the worktree's copies.

## Running alongside: `dream-trim`
A second builder is building `dream-trim` (Mini) now in `~/.claude-setup-wt/dream-trim`. It moves text out of `leorna/SKILL.md`, `figma-to-bricks/SKILL.md`, `feature-dispatch/SKILL.md` and the FigmaToBricks project `CLAUDE.md`, and it lands first. Stay within this plan's files. Add your one pointer line to each of those three `SKILL.md` files last, as the plan orders; the finisher rebases after the trim lands and keeps both changes.

## Where you work
- **Worktree:** create it as the plan says, `git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/dream-pass" -b dream-pass main`.
  - Record the base SHA (`main` at that moment) in your report.
  - Before the first write, check that `git -C ~/.claude-setup-wt/dream-pass rev-parse --show-toplevel` prints the worktree path, not `$HOME`.
- **Commits:** branch `dream-pass` only, with plain `git commit -m "…"`. The identity is `Justin <issajustin04@gmail.com>`.
  - **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one; the commit-msg hook refuses it anyway.
  - No author overrides. Never touch `main`, never push. Never commit or push inside `~/.hermes/skills-library` (the Leorna library clone).
  - Wait for a gate's exit before committing; never send a commit in the same batch of tool calls as the test it depends on.
- **Dirty check:** the repo has `status.showUntrackedFiles=no`, so before reporting check `git status --porcelain --untracked-files=all` and make it clean.
- **Moving `main`:** other sessions' `sync.sh` commits move `main` every few minutes. **Don't rebase**; the finisher does.

## Never touch real state
- Tests use a fake home, a fake `claude`, temp repos and `GIT_CONFIG_GLOBAL`/`HOME` overrides, as the plan says. They must not read Justin's real transcripts into a model, call the real `claude` (except the one named-only live test, if you run it: it makes two tiny calls and must leave no transcript), or touch the real setup repo, the real library clone or the real systemd user units.
- Fixture transcripts are made up by you from the line shapes the plan lists. Never copy Justin's real messages, keys, tokens or pairing codes into a fixture, a test or a commit.

## Evidence
`~/.hermes/plans/claude-setup/evidence/dream-pass/builder/`. For each non-live AC you build:
- the passing run as a log in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`'s format (first line `HEAD=<sha>`, last line `EXIT=<code>`), named `acN-<testname>.txt`;
- one PNG terminal capture of that run. On this desktop, use headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`;
- for each guard, the run showing its test failing against its mutant.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/dream-pass-builder/` folder. Create it fresh with `mkdir` without `-p`, and remove it by its literal absolute path.
- `/tmp` is a shared RAM tmpfs, so point `TMPDIR` and anything large at `~/.cache/dream-pass-builder/`.
- **Memory:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading it as pass or fail; if earlyoom killed it, say so in the report, find what grew, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`, never bare. Mutation runs always use that cap.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` or `/usr/bin/grep`.
  - Coreutils are uutils (`mkdir` is not atomic here), so use `tail -n N` and give `touch -d` an offset.
  - Never `pkill -f`. `$!` after `setsid … &` is setsid's own PID.
  - The evidence folders under `~/.hermes/plans` hold symlinks into `node_modules`: never walk them with a recursive glob that follows links.
  - A foreground Bash command is moved to the background after about 180 s: wait on long runs with repeated polls of under 3 minutes, each with the Bash `timeout` set above its bound.
  - The Claude CLI updates itself; check `claude --help` for a flag before relying on it.

## Rules for you
- You can't ask Justin anything. On a real trade-off, make the ruling and write it down as "My ruling, not yet confirmed" in `rulings[]` and in `evidence/dream-pass/builder/INVENTORY.md`. If it can't be decided safely, stop with `status: stopped` and list the options.
- If you run low on steps, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`, naming the worktree and the last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity).
- Never edit a skill or memory file outside the worktree. Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule (its kind, what it checks, where it runs). An empty list is the normal answer.

## Output contract
Stop when every non-live AC's test passes on the committed head, the existing suites pass as AC38 says, and the tree is clean. Report:
- `status`: `ready-for-review` or `stopped` (with `stop_reason`);
- `worktree`, `branch`, `base_sha`, `head_sha`;
- per AC: test name, pass/fail, and evidence files (`shots[]` for the PNGs);
- `rulings[]`, `steps_for_justin[]` (the install and the three live ACs, as exact commands with the window to run them in);
- `found_else[]`, `skill_lessons[]`.

End the report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
"Continue sorry" (2026-11-09, after the plan and its questions were shown). Earlier the same day: "Just merge to live files. But make sure everything we have now is updated on GitHub with the right GitHub main name in case we need to revert"; "No, you can edit them. I just don't want those edits to be pushed on the GitHub in Liorna. I want them to push on my branch."; "Nonstick to Opus xhigh" (voice slip for "No, stick to Opus xhigh"). If this brief and his words disagree, follow his words.
