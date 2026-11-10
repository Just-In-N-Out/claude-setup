# Brief: FINISHER 1 (rebase only), story `pipeline-token-diet`

## Role
You are the **finisher** for Justin's setup story `pipeline-token-diet`. The story passed its review loop (`MOVE ON` at review 2), the verifier, the blind auditor and `ac-check.sh` (`READY FOR THE USER: 5 of 6 ACs proven on 0977104; live ACs owed to the user: AC6`). Your job is finish step 1 only: rebase the branch onto the current local `main`, resolve conflicts, run the tests on the rebased branch, and **stop**, reporting the new HEAD. You don't:
- merge into `main`, push, or run `~/.claude/setup/sync.sh` (not even `pull`);
- write the live `~/.claude`, `~/.hermes`, `~/.codex`, `~/Documents/FigmaToBricksV2` or global git config;
- change what the story does, fix follow-ups, or start other agents.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks check every commit. A deny or a refusal is the rule, not a bug to work around. Never stash, reset `main`, or force anything.

## Skills (Skill tool) first
`engineering-best-practices`, `git-commit-rules`.

## Start state
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`, a linked worktree of the setup repo `~/.claude-setup.git` (main work tree `$HOME`). HEAD must be `0977104b5fb74d24c45c66711684ad9a5a86881c` and `git status --porcelain --untracked-files=all` empty. If not, stop and report.
- **Base of the accepted head:** `e9f160a28694af1557bd94289b5a25d08e110eb4`. Local `main` has moved on since (other sessions' `sync.sh` commits, every few minutes).
- **Approved plan (read-only):** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/plan-approved.md`: "Justin's answers", "The chosen set" (the routing table), "Acceptance criteria".
- **Known overlap:** since the base, `main` changed four files the story also changes: `.claude/project-docs/figma-to-bricks/CLAUDE.md`, feature-dispatch `references/ac-verification.md` and `references/review-loop.md`, and `figma-to-bricks/SKILL.md`. Expect conflicts or near misses there.

## Steps
1. Record `M0 = git --git-dir=$HOME/.claude-setup.git rev-parse main`.
2. In the worktree: `git rebase main`.
   - On a conflict, keep **both sides' meaning**: the other session's edit stays, and the story's change stays (the new routing, the round-3 rule, the rebase-receipt rule). Never drop the other session's text. If a conflict can't be resolved without choosing between two meanings, run `git rebase --abort`, stop and report the hunks.
   - Record for each of the story's 7 commits whether it applied cleanly or needed a resolution, and for each resolution the file, the hunk and what you kept.
3. **The consistency test's pins.** `scripts/pipeline-rules.test.sh` pins 56 prose statements word for word and three statements of the Figma copy. If an edit from `main` reworded a pinned line (the meaning of the rule unchanged), update that `prose()` row to the new wording in a separate commit `test(pipeline): re-pin <file> after rebase`, and list each such row in the report. If an edit from `main` put back an old pairing or a replaced rule in a rule file, don't paper over it: report it.
4. **Tests on the rebased head**, in the worktree, under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, plain and as `PATH=/usr/bin:/bin /bin/bash` (all under `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/`): `review-check.test.sh` (want `# passed 17, failed 0`), `ac-check.test.sh` (`all passed`), `pipeline-rules.test.sh` (`# passed 1, failed 0`), `token-report/token-report.test.sh` (`# passed 1, failed 0`); and with the normal PATH the named run `existing_suites_pass`. That one needs base tallies **of the new base** (`main` at `M0`): make them the way the plan's task 0 says, in a clone (`git clone -q ~/.claude-setup.git ~/.cache/pipeline-token-diet-finisher1/base && git -C … checkout -q --detach <M0>`), into `…/evidence/pipeline-token-diet/finisher-1/base-tallies/`. Known and not yours: under the minimal PATH `existing_suites_pass` fails in codex-parity because `codex` and `gitleaks` are not on that PATH.
   - If a test fails for a reason other than a pin from step 3, stop and report; don't patch around it.
5. **The Figma patch.** `…/evidence/pipeline-token-diet/fix-1/figma-claude-md.patch` turns the project's own `~/Documents/FigmaToBricksV2/CLAUDE.md` into the story's copy; it was made before `main`'s copy changed. Check, read-only: does the patch still apply to the live file (`patch --dry-run` on a **copy** in your scratch, never on the live file), and does the result equal the rebased worktree's `.claude/project-docs/figma-to-bricks/CLAUDE.md` byte for byte? If not, write a new patch that does, `…/finisher-1/figma-claude-md.patch`, with one line in `…/finisher-1/README.txt` saying which patch is current.
6. Confirm `git status --porcelain --untracked-files=all` is empty and record `git --git-dir=$HOME/.claude-setup.git rev-parse main` again (it may have moved; that is expected, don't rebase a second time).
7. Stop.

## Evidence and scratch
- Evidence in `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/finisher-1/` (rebase log, resolutions, test logs, base tallies).
- Scratch, `TMPDIR` and anything large in `~/.cache/pipeline-token-diet-finisher1/` (`/tmp` is a shared RAM tmpfs).
- Commits (only the re-pin commit, if needed): plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`, **no `Co-Authored-By` or any AI trailer**, no author overrides.
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so, find what grew, and rerun under the cap.
- **Gotchas:** in the Bash tool `grep` is ugrep: use `/usr/bin/grep`; `tail -n N`; never `pkill -f`. A foreground Bash command is moved to the background after about 180 s: run long suites with output to a log file and wait in polls under 3 minutes.

## Report
- `status`: `rebased` or `stopped` (with `stop_reason`);
- `old_head`, `new_head`, `new_base` (= `M0`), `main_now`;
- `pure_rebase`: yes or no (same patches in the same order, no resolutions, no extra commit);
- `resolutions[{commit, file, what_you_kept}]`, `repinned[{file, old, new}]`;
- test results on the new head, one line each;
- `figma_patch`: which file is current and whether it gives the copy byte for byte;
- `found_else[]`;
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
