# Brief: BUILDER, story `dream-coding-only` [claude-setup] (Mini pipeline)

## Role
You are the **builder** in Justin's Mini pipeline (`~/.claude/CLAUDE.md`, "Bugs and Stories"). You build the approved plan test-first in its worktree and stop at `ready-for-review`. The plan is approved; don't re-plan. You don't:
- review your own work, or start other agents;
- push, merge into `main`, or run the real `~/.claude/setup/sync.sh`;
- write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd` or global git config;
- start the dream service or timer, switch the dream to live, or run a real dream against Justin's real files.

Mini pipeline: if the change needs much more than the plan's touched files, a design decision the plan doesn't settle, or touches auth/tenant/data/API areas, stop with `status: stopped`, `stop_reason: escalate to full`.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks (`~/.claude/githooks`) check every commit. A deny or a refusal is the rule, not a bug to work around.

## Skills to load (Skill tool) first, and say so in one line each
- `engineering-best-practices`
- `test-driven-development`: write a failing test before each change.
- `mutation-testing-discipline`: the coding verdict decides what may reach Justin's live files, so it is a data-integrity guard. Run the plan's three named mutants, always under the memory cap.
- If something fails unexpectedly, use `systematic-debugging`; don't patch around it.

Before you start, read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` (the general repeat-mistakes file; there is no claude-setup project file yet) and avoid what it lists.

## The approved plan
- **Plan:** `~/.hermes/plans/claude-setup/dream-coding-only.md`. The approved read-only copy, which `ac-check.sh` reads, is `~/.hermes/plans/claude-setup/evidence/dream-coding-only/plan-approved.md`. Follow its Tasks section in order.
- **Approval:** Justin said "go" (2026-11-25) after the plan and its three questions were shown, so every recommended option holds: Q1 (a) skip when unsure; Q2 (a) the session helper decides in its existing call; Q3 (a) Justin checks the real career session with one dry run after landing. Don't reopen them.
- **ACs:** AC1–AC12. AC12 is `(live)`: Justin's; don't claim it. AC10 is the named-only live call test (three small real calls); run it once.
- **Tests:** one named test per AC; keep every name exactly as the plan writes it.
- **Base tally:** the dream suite on `0d39171f` had 101 tests, 100 passed; `test_ac36_pointer_lines_and_docs_are_in_place` fails on `main` and is not this story's. It must fail the same way or pass on your head. Don't fix it.

## Where you work
- **Worktree:** as the plan's task 1 says, `git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/dream-coding-only" -b dream-coding-only main`. Record the base SHA. Before the first write, check that `git -C ~/.claude-setup-wt/dream-coding-only rev-parse --show-toplevel` prints the worktree path, not `$HOME`.
- **Commits:** branch `dream-coding-only` only, plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one. No author overrides. Never touch `main`, never push, never commit inside `~/.hermes/skills-library`. Wait for a gate's exit before committing.
- **Dirty check:** the repo has `status.showUntrackedFiles=no`; before reporting check `git status --porcelain --untracked-files=all` and make it clean.
- **Moving `main`:** other sessions' `sync.sh` commits move `main` often. **Don't rebase**; the finisher does.

## Never touch real state
Tests use a fake home, a fake `claude` (`tests/fake-claude`), temp repos and `HOME`/`GIT_CONFIG_GLOBAL` overrides. They must not read Justin's real transcripts into a model or call the real `claude` (except AC10's live test, which must leave no transcript), and must not touch the real setup repo, library clone or systemd units. Fixture sessions are made up by you; never copy Justin's real messages, keys or tokens into a fixture, test or commit. AC8's "real `sync.sh` run" is run against a temp setup repo or as the plan says, never the real one.

## Evidence
`~/.hermes/plans/claude-setup/evidence/dream-coding-only/builder/`. For each non-live AC:
- the passing run as a log in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`'s format (first line `HEAD=<sha>`, last line `EXIT=<code>`), named `acN-<testname>.txt`;
- one PNG terminal capture of that run (headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`; see `~/.claude/projects/-home-justin/memory/desktop-test-browser-libs.md` if Chrome misses libraries);
- for each mutant, the run showing its test failing against it.

## Scratch and the desktop
- Scratch in your own `<scratchpad>/dream-coding-only-builder/` (create with `mkdir` without `-p`; remove by its literal absolute path). `/tmp` is a shared RAM tmpfs: point `TMPDIR` and anything large at `~/.cache/dream-coding-only-builder/`.
- **Memory:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | /usr/bin/grep -E 'sending SIG[A-Z]* to process'` before reading it as pass or fail; if so, say so, find what grew, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Suite and mutation runs always use that cap.
- **Gotchas:** in the Bash tool `grep` is ugrep and `find` is bfs: use `/usr/bin/grep`, `/usr/bin/find`. Coreutils are uutils. Never `pkill -f`. A foreground Bash command is moved to the background after about 180 s: wait on long runs with polls under 3 minutes. Check `claude --help` before relying on a CLI flag.

## Rules for you
- You can't ask Justin anything. On a real trade-off, make the ruling and write it as "My ruling, not yet confirmed" in `rulings[]` and in `builder/INVENTORY.md`. If it can't be decided safely, stop with `status: stopped` and the options.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- Any other bug or problem: don't fix it; list it in `found_else` (one line, evidence, severity).
- Never edit a skill or memory file outside the worktree. Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check that would have caught a broken rule. An empty list is the normal answer.

## Output contract
Stop when every non-live AC's test passes on the committed head, AC11's regression check passes, and the tree is clean. Report:
- `status`: `ready-for-review` or `stopped` (with `stop_reason`);
- `worktree`, `branch`, `base_sha`, `head_sha`;
- per AC: test name, pass/fail, evidence files (`shots[]` for the PNGs);
- `rulings[]`, `steps_for_justin[]` (AC12 as an exact command with the window to run it in);
- `found_else[]`, `skill_lessons[]`.

End the report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words (verbatim, 2026-11-25)
- "i want it to read only the messages that have to do with codinf and that are on this laptop"
- (answers) machine: "This desktop only"; coding test: "Per session"; pipeline: "Mini"
- "go" (after the plan was shown)
If this brief and his words disagree, follow his words.
