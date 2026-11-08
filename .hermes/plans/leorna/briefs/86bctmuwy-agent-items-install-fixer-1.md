# FIXER brief, round 1: 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FIXER (fresh agent). Verify each P0–P2 finding below, fix the valid ones test-first, push back with evidence on any that don't hold, commit, and stop at `ready-for-next-review`. No push, PR, merge, rebase or ClickUp write.
**Model/effort:** Opus 5.5, high.

## Story
ClickUp 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories".
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`, branch `feat/86bctmuwy-agent-items-install` (don't rebase; fixers never rebase)
- Base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`, reviewed head `1a32023c46c6117bae8fa0a2be9901f123c2bda2`
- Approved plan (spec, ACs AC1–AC13; AC13 `(live)` is Justin's): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md` (read-only; never edit). Approved decisions: 1A keep a file Leorna didn't write + warn; 2A skip `tools`-limited agents on Codex/Cursor; 3A skip unreadable bodies only; 4A existing removal rule; 5A skip built-in names; 7a Cursor in `~/.cursor/agents`; 8a Cursor description one plain line. Don't change `toolconnector.Connector`, OpenAPI or CI.
- Review record: `~/.hermes/plans/leorna/evidence/86bctmuwy/review-1/review.json` and summary `review-1/report-summary.md`. Reviewer's probes: `~/.cache/86bctmuwy-review1/zz_review1_probe_test.go`, `zz_review1_reselect_test.go` (overlay tests; reuse them as starting points for your RED tests).

## Referee lines (verbatim) — fix the P2s
```
R1-1  P2  toolconnector/agent.go:102  agentFrontmatterValue refuses any plain value containing ' #', which the control plane accepts (itembuilder/validate.go checks only ': ' and the first character) and which the control plane's own agent editor writes unquoted (item_create.go agentHeaderValue quotes only on ': ', edge spaces or a special first character). Such an agent is skipped for all three tools with the misleading reason 'its frontmatter must open and close with --- lines...', although the client never uses the frontmatter description (it renders item.Description). Probe: description 'Answers questions posted in #support' -> skipped for claude-code, codex and cursor; the same text JSON-quoted installs.
R1-2  P2  application/sync.go:251-262 (baseline chosen only if startedAt >= selection.UpdatedAt) + application/agent_guard.go:90-95  The guard learns that Leorna wrote an agent file only from the selection-bounded baseline. SaveSyncSelection refreshes updated_at even when the same project and folder are chosen again (sync_store.go 'refresh Sync's own selection time'), so after any re-selection every agent Leorna wrote whose new bytes differ is reported 'already exists and was not written by Leorna', is never updated, and never re-enters a baseline, so it stays stuck on every later Sync. This also hits home-scoped Codex and Cursor files when only the remote project changed. Probe (overlay test: Sync v1, SaveSyncSelection with the same project and folder, then serve v2 twice): all three tools keep the v1 bytes on both later Syncs with that warning. AC7's Sync 3 pins the same false 'not written by Leorna' text for Leorna's own file.
R1-3  P3  application/agent_guard.go:95 with toolconnector/nativewrite/check.go:150-151  A symlink anywhere on the path (for example ~/.cursor/agents linked into a dotfiles repo) checks as FileModified with no Actual, so the agent is skipped with '<path> already exists and was not written by Leorna' even when no file exists. The skip itself is safe; only the reason is wrong.
R1-4  P3  toolconnector/cursor/agent.go:33  Decision 8a writes the Cursor description unquoted. The CLI's line parser (proven by AC12) reads that correctly, but the canonical fixture 'Reviews a release: risks & "blockers"' is not valid YAML as a plain scalar. If the Cursor editor parses frontmatter with a YAML library, such agents may not show. Only AC13 (live) can tell, so AC13 should use a description containing ': ' and '"'.
REVIEW AGAIN: 2 P0-P2 finding(s) in review-1 at 1a32023: fix them, then review again (Full: round 2 reviews the whole story from 7a83443; Mini: review the fix commits)
```
P3s are optional: fix R1-3 only if it is a small, safe change (a truthful reason text); leave R1-4 (it goes to Justin's AC13 check; just add the suggested description with `: ` and `"` to `builder/ac13-steps.txt` if trivial). Don't fix anything else.

## Constraints for the fixes
- R1-1: the client must accept every agent the control plane's validator accepts and its editor writes; read the control plane's rule at `~/Leorna/leorna-control-plane` (read only; GitHub main). Keep refusing what really can't be parsed, with a truthful reason.
- R1-2: keep the approved safety promises: never replace a file Leorna didn't write (AC7, including a Leorna file the user edited), update Leorna's own unchanged file (AC8), remove only unchanged files by the existing rule (AC9), startup only for enrolled tools (AC10). Authorship must survive a re-selection with no real change (and the remote-project-only change for home-scoped Codex/Cursor files) without letting a user's own file be taken. If the only correct fix needs a change outside the plan's design (e.g. `toolconnector.Connector`, a DB migration) or changes an approved AC's meaning, stop and report `blocked-on-plan` with the options instead of choosing.
- AC tests must keep passing on head and failing on base; add a regression test per fixed finding, RED first (on the assertion), named after the finding.
- Mutation: for each guard change add a mutant that turns the new test red (overlay, under the memory cap) and record it in `~/.hermes/plans/leorna/evidence/86bctmuwy/fixer-1/mutations-<sha7>.txt`.

## Skills to load (say so in your first steps)
`leorna` (FINISHER/fixer rules; no hand-over yet), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `git-commit-rules`, `mutation-testing-discipline`, `authorized-write-safety`.

## Rules
- Commits `feat(86bctmuwy): …`/`fix(86bctmuwy): …`, plain `git commit` (identity from `~/.gitconfig`; never override; no AI attribution lines; never commit CLAUDE.md).
- Isolation: every test/probe uses throwaway HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR, XDG_CONFIG_HOME, CURSOR_CONFIG_DIR, CURSOR_DATA_DIR. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor`, `~/.config/cursor`.
- Gates on your final head, exactly as the plan's Gates section (`make check` with real non-symlinked TMPDIR; `node --test scripts/*-ui.test.cjs`; `make lint audit` with `~/.local/leorna-toolchain` tools; real-tool AC4/AC5/AC12 with `LEORNA_TEST_CLAUDE_BIN`, `LEORNA_TEST_CODEX_BIN`, `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`). Logs to `~/.hermes/plans/leorna/evidence/86bctmuwy/fixer-1/gates-<sha7>.txt` with `EXIT=` lines. If an AC's screenshot no longer matches the new behaviour, retake it (same filename) and say so.
- Memory (WSL desktop): SIGTERM / exit 143 / 137 / "Killed" may be earlyoom — check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`; mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Long commands: start with `cmd >log 2>&1 & echo pid=$!`, wait with repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000); don't end your turn to wait.
- Other bugs: `found_else`, not code.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report
`{status: ready-for-next-review|blocked-on-plan|blocked, head_sha, commits[], per_finding[{id, verdict: fixed|rejected|not_fixed_p3, test, commit, evidence}], gates[{name, exit, log}], mutations{total, killed, survived[]}, retaken_screenshots[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
