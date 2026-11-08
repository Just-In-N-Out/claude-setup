# BUILDER brief: 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** BUILDER. Build the approved plan test-first and stop at `ready-for-review`. No push, PR, merge or ClickUp write.
**Model/effort:** Opus 5.5, high (Justin, 2026-11-07).
**Pipeline:** Full.

## What to build
ClickUp card **86bctmuwy**, "Install Agent items into local Claude Code, Codex and Cursor tool directories". The approved plan is the spec:
- Plan (read it whole first): `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`
- Read-only approved copy (what `ac-check.sh` checks; never edit it): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`
- Approved by Justin: plan + answers 1A 2A 3A 4A 5A, 6 = "Add AC12", 7a (Cursor agents stay in `~/.cursor/agents`), 8a (Cursor description on one plain line, multi-line skipped with a warning), ACs AC1–AC13. AC13 is `(live)`: Justin checks the Cursor editor himself; you only prepare its steps and evidence slot.

Follow the plan's tasks T0–T12 (incl. T9b for AC12) in order. **The plan's design is decided: don't redesign.** If the plan is wrong or missing a decision, stop and report it (`status: blocked-on-plan`) instead of improvising.

## Where
- Repo `~/Leorna/leorna-client`. Base: GitHub `main` `7a834434d00ec7afae8464f5e7ce6cc17881bb7b` (re-check it per T0; if main moved, use the new tip and say so).
- T0: fetch main over HTTPS through gh (the `leorna` skill, Doing a story → 7.1), fast-forward the main checkout's `main` when it is on `main` with no tracked changes (memory note `leorna-update-main-before-worktree`), then `git -C ~/Leorna/leorna-client worktree add .claude/worktrees/86bctmuwy-agent-items-install -b feat/86bctmuwy-agent-items-install origin/main`. Branch name exactly `feat/86bctmuwy-agent-items-install`.
- Commits `feat(86bctmuwy): …`, plain `git commit` (identity `Justin Issa <justin@leorna.com>` from `~/.gitconfig`; never override author; no Co-Authored-By or AI attribution lines). Never commit a `CLAUDE.md`; put it in `.git/info/exclude`.

## Skills to load (say so in your first steps)
1. `leorna` (BUILDER role: steps 2–5 and 4b; skip the orchestrator parts)
2. `engineering-best-practices`
3. `test-driven-development`
4. `mutation-testing-discipline` (the existing-file guard and the plan's mutation table M1–M16)
5. the specialists the plan's `## Skills` section names (e.g. `authorized-write-safety`), plus any Agent Defect Loop skills it marks

## Rules
- **Test-first:** a failing test before each change, each RED failing on its assertion. Unexpected failure → `systematic-debugging`, never patch around it.
- **Isolation:** every test and probe uses a throwaway HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR, XDG_CONFIG_HOME, CURSOR_CONFIG_DIR and CURSOR_DATA_DIR. Never read-write the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor`. The real `~/.cursor` does not exist; it must still not exist when you finish (check before and after).
- **Real-tool ACs** run with the binaries set: `LEORNA_TEST_CLAUDE_BIN`, `LEORNA_TEST_CODEX_BIN`, `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent` (exact commands in the plan's Gates section). Don't run `--version` or anything else on a real binary without the isolated env first.
- **Gates** exactly as the plan's Gates section (client `make check` with a real non-symlinked TMPDIR, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's golangci-lint/govulncheck from `~/.local/leorna-toolchain`). Baseline on base first (T0.4).
- **Evidence (one per AC):** `~/.hermes/plans/leorna/evidence/86bctmuwy/builder/` (gate logs `gates-<sha7>.txt` with `EXIT=` lines, `mutations-<sha7>.txt`), screenshots `~/.hermes/plans/leorna/evidence/86bctmuwy/ac<n>-<what>.png` per the plan's evidence table (WSL method the plan names; this is not the Mac, so the osascript Terminal recipe doesn't apply). AC13 is owed to Justin: write its steps, take no fake capture. No server URL, token, email or tenant ID may be visible in any capture; check every PNG's magic bytes and look at it.
- **Memory (WSL desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill — check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as pass/fail. Run every mutant and any heavy test under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- **Long waits:** Claude Code moves a foreground command to the background after ~180 s. Start long gates with `cmd >log 2>&1 & echo pid=$!` and wait with repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000); don't end your turn to wait.
- **Scope:** don't change `toolconnector.Connector`, OpenAPI, `.github/workflows/*` or anything the plan doesn't list. Other bugs you find go in `found_else` (one line each, severity, evidence), not into the code.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Stop at ready-for-review and report
`{status: ready-for-review|blocked-on-plan|blocked, worktree, branch, base_sha, head_sha, commits[], diff_stat, ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], mutations{total, killed, survived[], log}, real_home_untouched_proof, deviations_from_plan[], found_else[], skill_lessons[]}`. `git diff --stat origin/main...HEAD` (three dots) and `git diff --name-only origin/main...HEAD -- .github` (must be empty). End the report with `MAIN SESSION: check and save these skill_lessons now.`
