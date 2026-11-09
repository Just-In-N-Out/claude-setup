# REVIEWER brief, round 5 (delta: fix round 3): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** fresh, independent REVIEWER, report only. You never saw the build. Change no source, commit nothing, write only into `~/.hermes/plans/leorna/evidence/86bctmuwy/review-5/`.
**Model/effort:** Fable 5.2, high.

## What to review
ClickUp card 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories": Sync now installs Agent items into Claude Code `<project>/.claude/agents/<name>.md`, Codex `$CODEX_HOME/agents/<name>.toml` and Cursor `~/.cursor/agents/<name>.md`, skips agents a tool can't express with a visible warning, never replaces a file Leorna didn't write, updates/removes only Leorna's own unchanged files.
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`, branch `feat/86bctmuwy-agent-items-install`
- Range: **delta**: previous reviewed head `f6f957b2249b00d2d7d5ea7929dae85855e5b214` .. head `556dba91e8de28bad56acfb4e49dc99bb90b88a0` (fix round 3: e34c8e8 R4-2, 44df083 R4-1, 556dba9 R4-3 README). Merge base `f3bc96061c74510b4cd9f7a7ee0a14890f087441` (GitHub main, brought in by merge `1fa24d9`); old story base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`.
- Approved plan (the spec; ACs AC1–AC13, AC13 is `(live)` = Justin's Cursor editor check): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`
- Approved decisions: 1A keep a file Leorna didn't write + warn; 2A skip `tools`-limited agents on Codex/Cursor; 3A skip unreadable agent bodies only; 4A existing removal rule; 5A skip built-in names; 7a Cursor stays in `~/.cursor/agents`; 8a Cursor description one plain line, multi-line skipped. 9 (Justin, 2026-11-09, after main's #30 restore came in) "Report + skip": a Sync that keeps a user-edited Leorna agent file keeps it in that tool's evidence with its last recorded hash, so Check files and the drift report show it modified and Restore can put it back after preview; Restore uses the agent guard, leaves out agent paths Leorna doesn't own with Sync's warning in the preview, and restores the rest of the tool (working plan `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md` → Decision 9). Out of scope by decision: changing `toolconnector.Connector`, OpenAPI, CI.
- Do not read the builder's report or `evidence/86bctmuwy/builder/` notes as truth; judge the code and run things yourself. (You may look at the AC screenshots to judge whether they show what they claim.)

## Skills to load (say so in your first steps)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `mutation-testing-discipline` for checking that guard tests can fail, plus `authorized-write-safety` and `security-best-practices` (this writes into users' tool folders). Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't spawn agents. Follow `review-fix-cadence` for the severity scale and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` → "The reviewer's duties" and "Records".

## Look especially at
- Safety of writes into real user tool folders: path building from item names (traversal, separators, case, Windows names), symlinks at the target, the existing-file guard (`application/agent_guard.go`) and its interaction with `nativewrite` backups, updates and removal; anything that could overwrite or delete a user's own file.
- Every skip path really reports a warning and never a false success; warning text matches the plan.
- Rendering correctness per tool (YAML/TOML escaping, Cursor one-line rule incl. CR), and whether the real-tool tests (AC4, AC5, AC12) actually prove loading and can fail.
- Test isolation: no test or probe touches the real HOME / `~/.claude` / `~/.codex` / `~/.cursor` / `~/.config/cursor`.
- Whether each AC's test proves its AC, and tests that can't fail.
- Realistic edge cases on WSL and macOS, and Windows (the client ships there).

## How
- Run the gates yourself on head (exact commands in the plan's Gates section; real non-symlinked TMPDIR, CI's tool versions from `~/.local/leorna-toolchain`), and the real-tool ACs with `LEORNA_TEST_CLAUDE_BIN`, `LEORNA_TEST_CODEX_BIN`, `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`, always with throwaway HOME/config dirs. Probes go in your own scratch folder or via `go test -overlay`; never edit the worktree.
- Memory (WSL desktop): SIGTERM / exit 143 / 137 / "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; run mutants and heavy probes under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Long commands: Claude Code backgrounds a foreground command after ~180 s; start long gates with `cmd >log 2>&1 & echo pid=$!` and wait with repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.

## Output
1. Write `~/.hermes/plans/leorna/evidence/86bctmuwy/review-5/review.json`: `{"round": 5, "scope": "delta", "from": "f6f957b2249b00d2d7d5ea7929dae85855e5b214", "head": "556dba91e8de28bad56acfb4e49dc99bb90b88a0", "findings": [{"id": "R5-1", "severity": "P0|P1|P2|P3", "file_line": "...", "claim": "...", "scenario": "<5+ words: who does what, what goes wrong>"}]}` (empty `findings` when clean). Every P0–P2 needs a concrete real-use `scenario`.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install --base f3bc96061c74510b4cd9f7a7ee0a14890f087441 ~/.hermes/plans/leorna/evidence/86bctmuwy` — exit 2 means your file is wrong: fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Return as text (no other report files): `{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit}], found_else[], skill_lessons[]}`. AC13 is `not_run` (Justin's).
- Other bugs outside this story: `found_else`, one line each with severity and evidence.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- End with `MAIN SESSION: check and save these skill_lessons now.`

## Round 5 (delta) rules
- Scope: only the fix commits `f6f957b..556dba9` and what they touch (`git diff f6f957b 556dba9`). Anything else you notice outside that is P3, and #30's own bugs go in `found_else`.
- Judge whether R4-1 and R4-2 (`review-4/review.json`) are really fixed per decision 9, for all three tools, and whether the fix opens a new hole:
  - Can a carried-forward evidence row ever make a user's own file look like Leorna's, or let Restore or Sync overwrite or remove a file Leorna never wrote? Think of a re-selected or renamed folder, the destination digest, another project, a link swapped in, a removed agent, and runs from before this fix.
  - Is the kept row's hash always Leorna's last written hash, never the edited bytes?
  - Does AC9's removal rule still hold?
  - Does the drift report stay "modified" across repeated Syncs and a startup Sync?
  - Does the preview warning match Sync's text with no absolute path?
  - Is a link never followed?
  - The fixer reports a behaviour change: a kept edited agent that a later version drops now stops that tool with `write_failed`, where before it was silently left and the tool succeeded. Judge whether that's correct under AC9 and decision 9.
- Fixer answers: `~/.hermes/plans/leorna/evidence/86bctmuwy/fixer-3/answers.md`, with mutants in `fixer-3/mutants-*.txt`. Read them, but rerun things yourself. Check that its claimed mutant kills are real, for at least the widening mutants (K5–K7, R5, R13, R14).
- The fixer's own open P3: baseline agent paths that a Sync can't check (a link or an unreadable file) still drop out of the evidence. Say whether you agree it's P3.
- **Three trees per probe:** run each probe on `f3bc960` (main), `f6f957b` (previous reviewed head) and `556dba9`. Set `repeats`/`new_fact` accordingly.
- Re-run the gates and every AC test on head yourself, and report ac_status for all ACs.
- Note: WSL restarted during the last fix run and left some files at 0 bytes. If a file you rely on is empty, say so, don't trust it.
