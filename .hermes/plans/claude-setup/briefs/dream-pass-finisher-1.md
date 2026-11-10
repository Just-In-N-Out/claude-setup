# FINISHER step 1: dream-pass (claude-setup), Full pipeline: rebase onto local `main`, run the tests, stop

Role: FINISHER, step 1 only. The review loop ended clean (`MOVE ON: review-7 at 698311c is clean`). The verifier and the blind auditor have **not** run yet: to spare Justin's nearly spent weekly usage limit they will run once, on the head you produce. So your job is to bring the branch onto today's local `main`, prove nothing broke, and stop. You don't merge, push, sync or install anything, and you change no behaviour.

- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`.
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `698311c092ba609e41b0558aad2f1d29ea9067ab`, base `131f9b0ad65dda6a4a157b5aefd829cebecee9be`. Local `main` of the setup repo (`~/.claude-setup.git`, work tree `$HOME`) is about 120 commits past that base.
- Evidence folder: `~/.hermes/plans/claude-setup/evidence/dream-pass/`; write yours in `finisher-1/`.

## Skills (Skill tool), one line each
`engineering-best-practices`, `git-commit-rules`.

## Steps
1. Confirm the worktree's HEAD is the head above and `git -C <worktree> status --porcelain --untracked-files=all` is empty. If not, stop and report.
2. Record `main`'s SHA (`git -C <worktree> rev-parse main`). Do **not** run `sync.sh` (it commits to `main` and would move your target).
3. In the worktree: `git rebase main`. Four files were changed on both sides since the base:
   - `.claude/CLAUDE.md`: both sides added to the bullet that begins "**Subagents report skill lessons, the main session saves them**" (`main` added the `~/.claude/setup/trim/` clause; this branch added its own). Keep both clauses. The branch also rewrites the "Dream Pass" section; keep the branch's version of that section.
   - `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`, `.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `.hermes/skills/software-development/leorna/SKILL.md`: `main` moved many lines out to `references/` files (the dream-trim story) and other sessions edited them; this branch adds one pointer line to each telling builders, reviewers and fixers to read the repeat-mistakes files. Keep `main`'s text exactly and add the branch's pointer line where the branch put it (the same section and neighbour lines); if its neighbour lines moved to a `references/` file, put it at the nearest kept line of the same section and say where.
   - On any conflict keep both sides' meaning. Never drop a line of `main`'s to make the rebase pass, never reword either side, and if a conflict is not one of the above or you cannot keep both meanings, stop (`git rebase --abort`) and report it.
4. After the rebase, check and record:
   - `git range-diff 131f9b0a..698311c0 main..HEAD` saved to `finisher-1/range-diff.txt`; list every commit whose patch changed and why.
   - Each conflict you resolved: file, the two sides, what you kept. For each of the four files, prove both sides were kept: `main`'s own change applies cleanly to the old head's file and gives the new head's file (`diff -u <old base file> <new base file> | patch` onto the old head's file, then `cmp` with the new head's file), or say exactly which lines differ and why.
   - `.claude/CLAUDE.md`'s size in bytes against the 30,000 budget in `.claude/dream/conf/budgets.tsv`. If it is over, do not cut anything: stop and report the number.
   - The three `SKILL.md` files' sizes against their budgets in `budgets.tsv`.
5. Run on the rebased head, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, logs in `finisher-1/` with first line `HEAD=<sha>` and last line `EXIT=<code>`:
   - the whole dream suite (`bash .claude/dream/tests/run.sh`);
   - both dream hook suites (`.claude/hooks/tests/dream-ledger.test.sh`, `dream-notice.test.sh`);
   - the trim's suite, since you touched the files it guards (`bash .claude/setup/trim/trim.test.sh`); two of its tests read files in `~/.hermes/plans/claude-setup/evidence/dream-trim/` and find the trim's commits by subject, so say plainly which tests pass and which fail and why, and don't count a failure of that kind as yours without showing the same failure on `main`;
   - the regression gate. `evidence/dream-pass/baseline.md` was recorded on the old base, so it no longer describes `main`: record a fresh baseline on a `git clone` of `main` (never a `git archive` copy), from two runs with nothing else of yours running, counting a test as passing on the base when either run passes, the way `builder/INVENTORY.md` says the first one was recorded; save it as `finisher-1/baseline-rebased.md` (leave the old file alone) and run `bash .claude/dream/tests/regression.sh <that file>` on a clone of your head. `cortexos-memory.test.sh` is timing-sensitive; `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on `main`.
   If a test fails that passed before the rebase, don't fix it: report it with the log.
6. Leave the tree clean (`git status --porcelain --untracked-files=all` empty) and stop.

## Hard rules
- Never `git push`, never `sync.sh`, never `git merge` into `main`, never touch `main` or the live `$HOME` files, never commit in `~/.hermes/skills-library`, never install or start the dream's timer or service, never run a real dream, never call the real `claude`.
- Commits keep the repo identity (`Justin <issajustin04@gmail.com>`); no AI or Co-Authored-By trailer; no author overrides. A rebase keeps each commit's author.
- If `main` moves while you work (other sessions sync every few minutes), finish on the `main` you started from and report both SHAs; don't chase it.
- **Be sparing:** Justin's weekly usage limit is nearly spent. If a request is refused for the limit, stop cleanly and say where you stopped (mid-rebase: `git rebase --abort` first, so the branch is back at the head above).
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e7431cef-ff41-40e3-a2ba-ca5cd54b1f13/scratchpad/dream-pass-finisher-1/` (mkdir, no -p); big things under `~/.cache/dream-pass-finisher-1/`; remove both by literal path.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (a line reading "sending SIGTERM when mem avail <= 5.00%…" with no process name is its start banner).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.

## Report
Return `{status: rebased|stopped, main_sha, old_head, new_head, conflicts[{file, kept}], both_sides_kept: yes|no with evidence, claude_md_bytes, skill_sizes, suites[{name, tally}], regression: ok|not ok, range_diff_changed[], stop_reason, found_else[], skill_lessons[]}` in plain words.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file yourself. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
