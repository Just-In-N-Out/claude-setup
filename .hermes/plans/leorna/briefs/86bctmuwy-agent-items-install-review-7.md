# REVIEWER brief, round 7 (delta: Windows CI fix): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** fresh, independent REVIEWER, report only. You never saw the build. Change no source, commit nothing, write only into `~/.hermes/plans/leorna/evidence/86bctmuwy/review-7/`.
**Model/effort:** Fable 5.2, high.

## What to review
ClickUp card 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories": Sync now installs Agent items into Claude Code `<project>/.claude/agents/<name>.md`, Codex `$CODEX_HOME/agents/<name>.toml` and Cursor `~/.cursor/agents/<name>.md`, skips agents a tool can't express with a visible warning, never replaces a file Leorna didn't write, updates/removes only Leorna's own unchanged files.
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`, branch `feat/86bctmuwy-agent-items-install`
- Range: **delta**: previous reviewed head `9e2d1cb48fafd600d666c00145ddf4f7e1532aa8` (pushed; PR #32, https://github.com/LeornaAI/leorna-client/pull/32) .. head `d42aa5875d2bb6290ff048cc3a1ae592f65d67b0` (fix round 5, test files only: 20fe7b5, 3514f6e, bf5e6fe, d42aa58), fixing CI run 42741208699's Windows-only failures. Merge base `f3bc96061c74510b4cd9f7a7ee0a14890f087441`.
- Approved plan (the spec; ACs AC1–AC13, AC13 is `(live)` = Justin's Cursor editor check): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`
- Approved decisions: 1A keep a file Leorna didn't write + warn; 2A skip `tools`-limited agents on Codex/Cursor; 3A skip unreadable agent bodies only; 4A existing removal rule; 5A skip built-in names; 7a Cursor stays in `~/.cursor/agents`; 8a Cursor description one plain line, multi-line skipped. 9 (Justin, 2026-11-09, after main's #30 restore came in) "Report + skip": a Sync that keeps a user-edited Leorna agent file keeps it in that tool's evidence with its last recorded hash, so Check files and the drift report show it modified and Restore can put it back after preview; Restore uses the agent guard, leaves out agent paths Leorna doesn't own with Sync's warning in the preview, and restores the rest of the tool (working plan `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md` → Decision 9); 10 (Justin, 2026-11-09, R5-1) "Record removals": each Sync records the agent files it removed; the authorship walk stops at the newest removal of a path in the same destination, so a file written there afterwards is the user's own (never in the evidence, never reported, restored over or blocking a later drop) (→ Decision 10). Out of scope by decision: changing `toolconnector.Connector`, OpenAPI, CI.
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
1. Write `~/.hermes/plans/leorna/evidence/86bctmuwy/review-7/review.json`: `{"round": 7, "scope": "delta", "from": "9e2d1cb48fafd600d666c00145ddf4f7e1532aa8", "head": "d42aa5875d2bb6290ff048cc3a1ae592f65d67b0", "findings": [{"id": "R7-1", "severity": "P0|P1|P2|P3", "file_line": "...", "claim": "...", "scenario": "<5+ words: who does what, what goes wrong>"}]}` (empty `findings` when clean). Every P0–P2 needs a concrete real-use `scenario`.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install --base f3bc96061c74510b4cd9f7a7ee0a14890f087441 ~/.hermes/plans/leorna/evidence/86bctmuwy` — exit 2 means your file is wrong: fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Return as text (no other report files): `{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit}], found_else[], skill_lessons[]}`. AC13 is `not_run` (Justin's).
- Other bugs outside this story: `found_else`, one line each with severity and evidence.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- End with `MAIN SESSION: check and save these skill_lessons now.`

## Round 7 (delta) rules
- Scope: only `9e2d1cb..d42aa58` (`git diff 9e2d1cb d42aa58`); per the fixer, test files only. Confirm no product code or `.github/` changed.
- Judge, with `fixer-5/answers.md` and its logs as leads (rerun things yourself):
  - Were all 5 failures really test bugs? Check the claim that the product hashes one canonical Claude Code folder everywhere: Sync, the authorship walk, Check files, Restore, and `SyncSelection()`'s refusal of a non-canonical saved root.
  - Did any test lose strength? AC7 now compares the file mode with its own earlier value instead of 0o644. The link cases now skip on Windows when `os.Symlink` fails; make sure they still run on Linux and on CI's Windows runner. The new `holdsLocalPath` leak check. The `folderDigest` helper.
  - Is the new characterization test meaningful?
  - Does any test still assume POSIX: paths, modes, open-file removal, CRLF?
- **Windows:** if you can, rerun the five tests and the whole `./application` package natively on Windows with the fixer's recipe. Their scratch folder `C:\Users\Admin\AppData\Local\Temp\86bctmuwy-fixer-5` has `build.bat`, `run.bat` and `vet.bat`. Use your own copy, built from a `git archive` of `d42aa58`, with TMP at an 8.3 short name and throwaway homes. Kill a mutant on each strengthened check, on Windows if you can.
- The fixer's P3 (folder identity for a junction, `\\?\`, UNC and macOS case) is a follow-up. Say only whether you agree it's P3.
- Earlier rounds: `review-1..6/`, `fixer-1..5/answers.md`.
- **Three trees per probe:** run each on `f3bc960`, `9e2d1cb` and `d42aa58` where it applies.
- Re-run the Linux gates and every AC test on head yourself, and report ac_status for all ACs.
- WSL can restart and leave 0-byte files. If a file you rely on is empty, say so, don't trust it.
