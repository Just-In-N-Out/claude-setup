# Brief: BUILDER, story `pipeline-token-diet` (Full pipeline)

## Role
You are the **builder** in Justin's Full pipeline (`~/.claude/CLAUDE.md`, "Bugs and Stories"). You build the approved plan test-first in its worktree and stop at `ready-for-review`. You don't:
- review your own work, or start other agents;
- push, merge into `main`, rebase, or run the real `~/.claude/setup/sync.sh`;
- write the live `~/.claude`, `~/.hermes`, `~/.codex` or global git config. Every change goes into the worktree's copies. The live rule files change only at the merge.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks (`~/.claude/githooks`) check every commit. A deny or a refusal is the rule, not a bug to work around.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `test-driven-development`: a failing test before each change.
- `mutation-testing-discipline`: for tasks 2 and 3. `review-check.sh` and `ac-check.sh` gate every later story; prove each new rule's test can fail, with the mutants the plan names. Mutation runs always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- If something fails unexpectedly: `systematic-debugging`. Don't patch around it.

## The approved plan
- **Plan:** `~/.hermes/plans/claude-setup/pipeline-token-diet.md`. The approved read-only copy, which `ac-check.sh` reads, is `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/plan-approved.md`. Read "Amendments", "Justin's answers", "The chosen set", "Acceptance criteria", "Where the rules are stated", "Tasks, in build order", "Risks" and Appendices A and B. The analysis sections ("How it was measured" to "Packaged options") are background: skim, don't study.
- **Approval:** Justin approved it on 2026-11-10 ("ok yes change this pipeline everywhere", then "ok do that then and start it"). Don't reopen his answers. Q8 is built as (a), rule text only: **do not change `settings.json`**. Full's second whole-story review is written as Opus 5.5 high, as the plan's routing table says.
- **Routing to write, Full and Mini:** planner Fable 5.2 high | builder Opus 5.5 xhigh | round-1 review Fable 5.2 high | every later review round Opus 5.5 high | fixers Opus 5.5 high | verifier Opus 5.5 high | AC auditor Opus 5.5 xhigh | finisher Opus 5.5 high | pipeline main session Opus 5.5 high. The plan's table in "The chosen set" is the authority if this line and it differ: say so in `found_else`.
- **ACs:** AC1–AC6. AC6 is `(live)`: don't claim it. Each of AC1–AC5 has exactly one named test; keep every test name exactly as the plan writes it, whole on one line, in the file the plan names (numbered TAP, `ok <n> - <name>`).
- Follow the tasks in order, 0 to the last, one commit a task, each commit green. Task 0 (base tallies, and checking the real `/model` and `/effort` command names) comes before any edit. The rule text you write keeps a dated *Why* note for the two rules that change ("once by each model" ends; "no round cap" becomes "asked from round 3"), as the plan's docs task says.
- `~/.codex/AGENTS.md` is generated: regenerate the worktree's copy with the generator under `.claude/setup/codex/`, never edit it by hand.

## Where you work
- **Worktree:** `git --git-dir=$HOME/.claude-setup.git worktree add ~/.claude-setup-wt/pipeline-token-diet -b pipeline-token-diet main`.
  - Record the base SHA (`main` at that moment) in your report.
  - Before the first write, check that `git -C ~/.claude-setup-wt/pipeline-token-diet rev-parse --show-toplevel` prints the worktree path, not `$HOME`.
- **Commits:** branch `pipeline-token-diet` only, plain `git commit -m "…"`. Identity `Justin <issajustin04@gmail.com>`.
  - **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one; the commit-msg hook refuses it.
  - No author overrides. Never touch `main`, never push.
  - The pre-commit hook allows `CLAUDE.md` only in this setup repo; that is expected here.
- **Dirty check:** the repo has `status.showUntrackedFiles=no`, so before reporting run `git status --porcelain --untracked-files=all` and make it clean.
- **Moving `main`:** other sessions' `sync.sh` commits move `main` every few minutes. Don't rebase; the finisher does.

## Known base facts (from the planner; check them in task 0, don't trust them)
- Run from the live home, three suites already fail on the base (`harness-guards` 3, `cortexos-memory` 2, `codex-parity` 3), mostly "git tracks 0 files" because `$HOME` is the bare repo's work tree. Record base tallies **in your worktree**, as task 0 says; AC5 compares test by test.
- `codex-parity` ac21 is pinned to `gpt-6.1-sol/xhigh` and fails on the base. It is not yours to fix: list it in `found_else`.
- The planner's working prototype of tasks 2 and 3 (diffs, mutants) is in `~/.cache/pipeline-token-diet-planner-2/`. Use it as a reference; still build test-first from the plan and prove RED yourself.

## Never touch real state
Tests use temp repos, `GIT_CONFIG_GLOBAL` and `HOME` overrides, and must not touch real repos, the real transcripts under `~/.claude/projects` (the token report's test uses its hand-made fixture only) or the real global config.

## Evidence
`~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/builder/` (base tallies where task 0 says). For each of AC1–AC5:
- the passing run as a log in `ac-verification.md`'s format (first line `HEAD=<sha>`, last line `EXIT=<code>`), named `acN-<testname>.txt`;
- one PNG terminal capture of that log. On this desktop: headless Chrome for Testing under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`;
- for tasks 2 and 3, the runs showing the new test failing against each named mutant.

## Scratch and the desktop
- Scratch in `~/.cache/pipeline-token-diet-builder/`; point `TMPDIR` and anything large there (`/tmp` is a shared RAM tmpfs).
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so in the report, find what grew, and rerun under the `systemd-run` cap above, never bare.
- **Gotchas:** in the Bash tool `grep` is ugrep (use `command grep` or `/usr/bin/grep`); coreutils are uutils (`tail -n N`, give `touch -d` an offset); never `pkill -f`.

## Output contract
Stop when every test of AC1–AC5 passes on the committed head and the tree is clean. Report, briefly:
- `status`: `ready-for-review` or `stopped` (with `stop_reason`);
- `worktree`, `branch`, `base_sha`, `head_sha`;
- per AC: test name, pass/fail, evidence files;
- the real session commands you confirmed in task 0;
- `found_else`: anything off you noticed but didn't fix;
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only (a gotcha, an approach that worked after one failed, a skill step that was wrong or missing); `enforce` is `none` or a one-line check proposal (kind, what it checks, where it runs). An empty list is normal. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
