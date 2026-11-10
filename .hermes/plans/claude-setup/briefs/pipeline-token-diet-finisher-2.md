# Brief: FINISHER 2 (final rebase, receipt, merge, Figma patch), story `pipeline-token-diet`

## Role
You are the **finisher** for Justin's setup story `pipeline-token-diet`. The story is accepted at head `c887b3b4ed19c9198cc0316f2c860f215c672ff0`: review 3 says `MOVE ON`, and verifier and auditor both proved AC1–AC5 there (`ac-check.sh`: `READY FOR THE USER`, AC6 live). Local `main` keeps moving (other sessions' `sync.sh` commits every few minutes), so the branch must be rebased once more and merged in the same breath.

**Justin's decision (2026-11-10, `…/evidence/pipeline-token-diet/justin-final-merge.md`):** when this last rebase is **pure** (no conflict, the same patches in the same order), no new verifier and auditor run. You rerun every AC's test on the new head, write a rebase receipt, and the **story's own new** `ac-check.sh --rebase-receipt` (the worktree's copy) must accept it with the existing reports. Then you fast-forward `main` at once. A rebase that is not pure stops here and goes back to review.

You don't: push, run `~/.claude/setup/sync.sh` (not even `pull`), stash, reset, force, set git config, change what the story does, or start other agents. The only live files you write are the fast-forward itself and, after it, `~/Documents/FigmaToBricksV2/CLAUDE.md` through the story's patch (step 5).

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks check every commit. A deny or a refusal is the rule, not a bug to work around.

## Skills (Skill tool) first
`engineering-best-practices`, `git-commit-rules`.

## Read first
- In the worktree: `.claude/CLAUDE.md` step 7 and `.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` step 5 (the receipt rule and the receipt's exact format), and the header comment of `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (`--rebase-receipt`).
- `…/evidence/pipeline-token-diet/plan-approved.md`: "Acceptance criteria" (the five named tests) only.
- `…/evidence/pipeline-token-diet/fix-1/README.txt` (the Figma patch) and `…/finisher-1/figma-patch-check.txt`.

## Start state
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`, a linked worktree of `~/.claude-setup.git` (main work tree `$HOME`). HEAD must be `c887b3b4…` and `git status --porcelain --untracked-files=all` empty. If not, stop and report.
- **Evidence folder `E`:** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/`. The accepted reports are `E/verifier/ac.json` and `E/auditor/ac.json` (don't edit them). Your files go in `E/finisher-2/`, one subfolder per round.
- **AC tests** (under `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/`, run one with `bash <file> <test_name>`): AC1 `routing_text_agrees` and AC5 `existing_suites_pass` in `pipeline-rules.test.sh`; AC2 `p2_only_from_round_3_asks_justin` and AC3 `pure_rebase_receipt_accepts_earlier_reports` in `review-check.test.sh`; AC4 `token_report_fixture` in `token-report/token-report.test.sh`. AC5 needs `PIPELINE_RULES_BASE=<base tallies of the new base>`: make them in a clone (`git clone -q ~/.claude-setup.git ~/.cache/pipeline-token-diet-finisher2/base && git -C … checkout -q --detach <M0>`), each suite twice, the way the plan's task 0 says. Everything under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

## The loop (up to 6 rounds or 90 minutes)
1. Record `M0 = git --git-dir=$HOME/.claude-setup.git rev-parse main`.
2. In the worktree: `git rebase main`.
   - **Any conflict:** `git rebase --abort`, stop, `status: needs-review` with the conflicting files and hunks. Don't resolve it.
3. **Pure?** The new head must be a pure rebase of `c887b3b4` by the same test `ac-check.sh` uses (patch ids with `--verbatim`, same order, no merges). If it is not (for example `main` changed text within 3 lines of a story hunk), stop: `status: needs-review`, saying which commit differs. Don't reset the branch back.
4. **Receipt.** Run the five AC tests on the new head and write the rebase receipt exactly as the worktree's `ac-verification.md` step 5 describes (first line `HEAD=<new sha>`, every AC's test passing, last line `EXIT=0`), in `E/finisher-2/round-<n>/` (not inside `verifier/` or `auditor/`). Also run the full `review-check.test.sh`, `ac-check.test.sh`, `pipeline-rules.test.sh` and `token-report.test.sh` once; any failure: stop and report, don't patch around it.
   Then run the **worktree's** checker and save its whole output:
   `bash <worktree>/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base <M0> --plan E/plan-approved.md --reviews E --rebase-receipt <receipt> E/verifier/ac.json E/auditor/ac.json`
   - Last line `ALL ACCEPTED` or `READY FOR THE USER` (AC6 owed): go on. Anything else: stop, `status: not-accepted`, with the output.
5. **Merge at once** if `git --git-dir=$HOME/.claude-setup.git rev-parse main` still equals `M0`:
   `git --git-dir=$HOME/.claude-setup.git --work-tree=$HOME merge --ff-only pipeline-token-diet`
   - If `main` moved (before or in that instant), go back to 1. The previous round's receipt is void: write a new one.
   - If it refuses because of uncommitted changes in `$HOME`, stop and report the files word for word. **Never** stash, commit or discard anyone's changes, and never force.
6. **Right after a successful merge, the Figma patch** (so the next `sync.sh` from any session doesn't put the old text back into the copy):
   - `patch --dry-run ~/Documents/FigmaToBricksV2/CLAUDE.md < E/fix-1/figma-claude-md.patch` (use `E/finisher-1/figma-claude-md.patch` instead if `finisher-1/README.txt` exists and names it as current). If the dry run fails, stop and report: don't touch the file.
   - If it applies, run it for real (no backup or `.orig`/`.rej` file left behind: use `--no-backup-if-mismatch` and check), then `cmp ~/Documents/FigmaToBricksV2/CLAUDE.md ~/.claude/project-docs/figma-to-bricks/CLAUDE.md`. Report the result; if `cmp` differs, show `diff` of the two and stop. Change nothing else in that project and commit nothing there.
7. **After-merge checks** (read-only): `git --git-dir=$HOME/.claude-setup.git log --oneline -8 main` shows the story's 7 commits on top; in `$HOME`, `bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh` ends `# passed 1, failed 0` on the live files; the live `ac-check.sh` header names `--rebase-receipt`; no `setup-sync.lock` of yours is left. **Don't run `sync.sh`**: the main session does, right after your report.
8. Stop and report at once. Keep the report short: the main session must sync quickly.

## Scratch and the desktop
- Scratch, `TMPDIR` and anything large in `~/.cache/pipeline-token-diet-finisher2/` (`/tmp` is a shared RAM tmpfs).
- A foreground Bash command is moved to the background after about 180 s: run long suites with output to a log file and wait in polls under 3 minutes. Don't end your turn while one runs.
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so and rerun under the cap.
- **Gotchas:** in the Bash tool `grep` is ugrep: use `/usr/bin/grep`; `tail -n N`; never `pkill -f`.

## Report (at most 30 lines)
- `status`: `merged`, `needs-review`, `not-accepted`, `no-quiet-window` or `stopped` (with the reason);
- `rounds[{n, M0, new_head, pure, receipt, ac_check_last_line, main_moved}]`;
- `merged_head`, `main_after`;
- `figma_patch`: applied or not, and the `cmp` result;
- `after_merge_checks`;
- `found_else[]`;
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
