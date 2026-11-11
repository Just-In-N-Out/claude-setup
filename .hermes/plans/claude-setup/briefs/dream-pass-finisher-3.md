# FINISHER (step 1: rebase and rebase receipt): dream-pass (claude-setup), Full pipeline

Role: FINISHER, step 1 of `~/.claude/CLAUDE.md`'s pipeline step 7. The story is accepted: `ac-check.sh … --reviews` printed `READY FOR THE USER: 42 of 45 ACs proven on ee17d98; live ACs owed to the user: AC39 AC40 AC41` with `REVIEWS  CLEAN: review-11 at ee17d98`. Your job: rebase onto the newest local `main`; if it resolves no conflict, write the **rebase receipt** that `ac-verification.md` step 5 describes; stop and report. You don't merge (the main session does, at once, under the sync lock), don't install, don't push. You fix nothing and decide nothing.

- Read first: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, step 5 ("After the finisher's rebase"): the receipt's exact form.
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head **`ee17d9885d00d3d7ffa1f85bce1d9912980b5c7e`** (call it RH), base `299862e4911cd842f259a79d78d4499192928a43`. Setup repo `~/.claude-setup.git`, work tree `$HOME`; local `main` moves several times an hour (other sessions' `sync.sh`).
- The reports the receipt reuses: `~/.hermes/plans/claude-setup/evidence/dream-pass/verifier/ac.json` and `auditor/ac.json`. Their rows' `command` fields are the commands to run.
- Evidence: write into `~/.hermes/plans/claude-setup/evidence/dream-pass/rebase/` (the receipt) and `finisher-3/` (your notes and logs), as you go: this desktop restarted twice on 2026-11-10 and `/tmp` is a RAM disk.

## Skills (Skill tool), one line each
`engineering-best-practices`, `git-commit-rules`.

## Steps
1. Confirm the worktree's HEAD is RH and `git -C <worktree> status --porcelain --untracked-files=all` is empty. If not, stop and report.
2. Record `main`'s SHA. `git rebase main` in the worktree. On **any** conflict: `git rebase --abort`, stop with `status: stopped`, name the file. (`main` changed `.claude/CLAUDE.md` once since the story's base, at line 54, the "Runaway Memory" section; the story's hunks are at lines 28, 46, 48 and 97, so it should apply cleanly. If it doesn't, stop.)
3. Prove it pure: `git range-diff 299862e4..ee17d988 <main sha>..HEAD`, every pair `=`, 53 commits, no merge commits, same authors and messages. Save it in `finisher-3/`. If any pair isn't `=`, stop and report it (leave the branch as it is; no reset).
4. Write the receipt exactly as step 5 of `ac-verification.md` shows: one log `rebase/receipt-<head7>.log`, first line `HEAD=<new head>`, then every agent-run AC's test command (AC1–AC38 and AC42–AC45; not AC39–AC41, which are live), each `|| rc=1`, last line `EXIT=$rc`. Take each command from the reports' `command` field; run every one under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` with `DREAM_TEST_ROOT` and `TMPDIR` in your own cache folder; a skipped test refuses the receipt, so make sure none skips.
   - **AC37** is the named-only live test: it makes two small real `claude` calls. Run it once. If it is refused for Justin's usage limit, stop and report that; don't retry.
   - **AC38** (`regression_existing_suites_match_the_base_tally`) compares against a base tally. A tally of the old base no longer describes the new base (`main` has gained suite changes since), so record a fresh tally on a `git clone` of the new base with the head's `regression.sh --record` and its root option, from two runs (a test passes on the base when either run passes), and run the compare against that inside the receipt. Some suites have millisecond limits and flip under load: check `uptime` first, wait up to 20 minutes for the 1-minute load to fall under about 6, record the load at each stage, and if the receipt fails only on those suites (`cortexos-memory.test.sh`, or `codex-parity.test.sh`'s `ac7_claude_hooks_unchanged`, which runs it), rerun that suite alone on the new base and on the head to show it is load, then rerun the whole receipt. Give up after 3 receipts and report.
   - The receipt must end `EXIT=0`.
5. Then check `main` again. If it moved since your rebase (it often will), rebase again onto it (step 2), prove it pure against the previous rebased head (step 3), and redo the receipt (step 4; the AC38 tally only needs re-recording if the commits `main` gained touch `.claude/hooks/`, `.claude/setup/`, `.claude/githooks/`, `.codex/` or `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/`). Up to 3 rounds; then report wherever you are.
6. Stop. Report the final head, the `main` it sits on, and the receipt's path. Leave the tree clean. **Don't merge, don't run `sync.sh`, don't install anything.** The main session runs `ac-check.sh --rebase-receipt …` and the `--ff-only` merge at once.

## Hard rules
- Never push, merge, sync, install, start the dream's service or timer, switch it to live or enable linger; never touch `~/Leorna/`; never commit in `~/.hermes/skills-library`.
- Never stash, reset, force, or resolve a conflict. A rebase keeps each commit's author (`Justin <issajustin04@gmail.com>`); no AI or Co-Authored-By trailer.
- **Be sparing:** Justin's weekly usage limit is nearly spent. If a request is refused for the limit, stop cleanly and say where you are (mid-rebase: `git rebase --abort` first).
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-finisher-3/` (mkdir, no -p); big things under `~/.cache/dream-pass-finisher-3/`; remove both by literal path at the end.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`; never `| grep -q` under `pipefail`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound, and don't end your turn while one runs.

## Report
Return `{status: receipt-ready|stopped, rh, final_head, main_sha, rounds, pure: yes|no with evidence, receipt_path, receipt_exit, ac38_baseline, loads[], stop_reason, found_else[], skill_lessons[]}` in plain words.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
