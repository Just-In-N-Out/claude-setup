# Where dream-pass and dream-trim stand (resume note for the main session)

Updated 2026-11-10 about 18:30 EST by the main session that ran both jobs from the start (session `e126e11b-3efb-4c0a-ba28-710cd6032a81`, 747k tokens of context, on Fable 5.2: over the 300k rule of 2026-11-10 and not on Opus 5.5 high, so a fresh session should take over). Everything below is on disk; nothing depends on that chat.

## What the two jobs are
- **dream-pass** (claude-setup, Full): a twice-daily job that rereads Justin's Claude Code sessions and the pipeline's review findings and updates his skills, `CLAUDE.md` files and memory notes. Rules: `~/.claude/dream/DREAM.md`. Plan: `~/.hermes/plans/claude-setup/dream-pass.md`; approved copy `evidence/dream-pass/plan-approved.md` (its "Justin's answers" section holds every decision he made, in order).
- **dream-trim** (claude-setup, Mini): the one-time trim of four oversized files. Plan: `dream-trim.md`; approved copy `evidence/dream-trim/plan-approved.md`.
- Briefs for every agent that ran: `briefs/dream-pass-*.md`, `briefs/dream-trim-*.md`. Evidence: `evidence/dream-pass/`, `evidence/dream-trim/`.

## dream-trim: pass 1 landed, pass 2 waits for Justin
- Pass 1 is on `main` and on GitHub since 2026-11-10 (landing commit `312a6f82`, by `~/.claude/setup/trim/land.sh`). The four files are under their targets.
- **Pass 2** (6 small edits, about 850 characters) is commit `2bc4495d` on branch `dream-trim` (worktree `~/.claude-setup-wt/dream-trim`). It is AC9 (live): Justin reads `evidence/dream-trim/pass2-summary.md` and `pass2.diff` and says **"land pass 2"**, or names edits to drop. He has been reminded several times and has not answered; don't land it without those words.
- To land it then: `bash .claude/setup/trim/land.sh 2bc4495d --map .claude/setup/trim/maps/dream-trim.json --ledger ~/.hermes/plans/claude-setup/evidence/dream-trim/pass2-ledger.md` from that worktree (a finisher; `sync.sh pull` first, rerun on exit 3, then one `sync.sh`). `ac-check` said `READY FOR THE USER: 8 of 9` on `2bc4495`.
- Follow-ups: `evidence/dream-trim/follow-ups.md`.

## dream-pass: accepted, but the landing stopped on a conflict
- Branch `dream-pass`, worktree `~/.claude-setup-wt/dream-pass`, head **`99bb2f31f8d18ca5dfe18d4d59de61925a64b7b2`**, base `63f09cb6` (51 commits). The worktree is clean.
- Review loop: reviews 1 to 9 (`evidence/dream-pass/review-<n>/review.json`); the referee's last line is `MOVE ON: review-9 at 99bb2f3 is clean`. `review-6/justin.json` holds his "Fix it, review again". Fixers 1 to 7, finisher 1 (the first rebase, one conflict in `CLAUDE.md`, reviewed clean as review 8).
- Verifier (second pass) and blind auditor: both clean on `99bb2f3`. `ac-check.sh … --reviews` printed **`READY FOR THE USER: 42 of 45 ACs proven on 99bb2f3; live ACs owed to the user: AC39 AC40 AC41`**.
- **Finisher 2 (the landing) stopped** (`evidence/dream-pass/finisher-2/stop.txt`, `conflict-CLAUDE.md.diff`): rebasing onto `main` `6aa2c634` conflicts in `.claude/CLAUDE.md` while applying story commit `12f5792e`. `main`'s commit `1cc9837d` (Justin's new model routing of 2026-11-10) rewrote the "Agent models" line; the story adds one sentence to the "Subagents report skill lessons" line beside it ("The dream reads the same skills and never duplicates a saved lesson."). The finisher aborted the rebase and resolved nothing, as briefed. Nothing was merged or installed.
- **A second blocker found right after:** live `~/.claude/CLAUDE.md` is now 31,572 bytes (it was 29,594 before `1cc9837d`). The story's own docs test fails when `CLAUDE.md` is 30,000 bytes or more (`.claude/dream/tests/test_docs.py:91`; the dream's budget row is `.claude/CLAUDE.md 30000` in `.claude/dream/conf/budgets.tsv`, Justin's Q2 (a)). After a rebase the file would be about 31,915 bytes, so the dream suite would fail and the landing cannot pass until the budget, the test or the file changes. **Justin's decision (2026-11-10 about 18:35): raise the budget for the global `CLAUDE.md` to 36,000** (the last paragraph of "Justin's answers" in the plan). He also chose to finish in the same main session rather than a fresh one.

## What to do next for dream-pass
1. The budget answer is in: 36,000 for `.claude/CLAUDE.md`.
2. Dispatch a **fixer** (Opus 5.5 high under the 2026-11-10 routing; brief it from `briefs/dream-pass-fixer-7.md` for the rules and from this note for the job): rebase the branch onto the newest `main`, resolve the `CLAUDE.md` conflict by keeping `main`'s "Agent models" line exactly and adding the story's one sentence to the lessons line, apply Justin's budget answer test-first (`budgets.tsv`, `test_docs.py`, and any doc line that states the number), run the dream suite, both hook suites and the regression gate with a fresh baseline on the new base. It stops at `ready-for-next-review`.
3. Then the full path, as `CLAUDE.md` step 7 says for a rebase that resolved a conflict: a fresh **review** of the resolution and the budget change (later-round reviewer: Opus 5.5 high; review it as `git range-diff 63f09cb6..99bb2f31 <new base>..HEAD` plus the new commit, `from` = `99bb2f31`), `review-check.sh`, then a fresh **verifier** (Opus 5.5 high; brief from `briefs/dream-pass-verifier-1.md`), a fresh blind **auditor** (Opus 5.5 xhigh; `briefs/dream-pass-auditor-1.md`), then `ac-check.sh … --reviews`.
4. Then the landing (brief from `briefs/dream-pass-finisher-2.md`, updated for the new rule): finisher rebases onto the newest `main`; on a pure rebase it writes a **rebase receipt** (`ac-verification.md`) and the main session reruns `ac-check.sh` with `--rebase-receipt <evidence>/rebase/receipt-<head7>.log`, with no new verifier or auditor (this replaces Justin's one-off "Yes, if the rebase is pure" allowance, which says the same thing). Then `git merge --ff-only dream-pass` on `main` under the sync lock, the plan's after-merge step (`dream install` without `--enable`, `dream init`, `dream status`), one `sync.sh`, and the final check. `main` moves 4 to 16 times an hour, and commits touching the rules lines of `CLAUDE.md` will conflict again, so land promptly once accepted.
5. Hand Justin his three live steps (AC40 dry run and read the diff, AC41 `dream mode live` and one run by hand, AC39 linger and the timer), as exact commands for the Ubuntu window.

## Things Justin was told and should not be surprised by
- Global `CLAUDE.md` has little or no room under its dream budget; the dream is shrink-only on an over-budget file.
- First live run: figma-to-bricks's 272 review lines go to one helper call; if it fails the log shows about 75 review lines read, not about 347, and the repeat-mistakes files wait.
- When the dream holds repeat-mistakes updates (unread review lines, or a failing review helper) nothing tells him yet (review 7's R7-1, a P3): the main session recommended it as the first follow-up story.
- A mistake retired by its rule is never listed again (R5-7, a P3): his call, not asked for.
- The weekly usage limit stopped one Fable agent on 2026-11-10 (reset Nov 13, 6pm New York). The dream's own agents run on Opus.
- The desktop restarted twice on 2026-11-10 (07:07 to 08:17 and 17:10 to 17:12), neither a Linux memory kill.

## Records kept elsewhere
- Follow-ups (P3s): `evidence/dream-pass/follow-ups.md` (reviews 1 to 8; add the verifier's and auditor's notes: the auditor's A1, AC17 and AC27's named tests do not themselves exercise the 2026-11-10 rulings, supporting tests do).
- Check proposals offered: `enforce-backlog.md`, the lines dated 2026-11-09 and 2026-11-10 that name dream-pass or dream-trim.
- Lessons saved from these two jobs are already in the skills and memory (synced); nothing is pending.
- The hand trial of 2026-11-09 (three sessions, scratch only) is not kept; its findings are in the plan.
- Backup tag before the first dream: `pre-dream-2026-11-09` (`fafe0ac3`) on `Just-In-N-Out/claude-setup`.

## Update 2026-11-10 about 19:40
- Fixer 8 done: budget commit made and the branch rebased onto `main` `299862e4`. New head **`2d69e1e42b126b15a534a09d801f3d4cec411ce2`** (52 commits). One conflict, the known one in `.claude/CLAUDE.md`, both sides kept. `CLAUDE.md` is 31,915 bytes on the head (budget now 36,000). Dream suite 93 passed; regression gate ok after one load flake rerun alone. Records: `evidence/dream-pass/fixer-8/`.
- Reviewer 10 (Opus 5.5 high, brief `briefs/dream-pass-reviewer-10.md`) is reviewing the budget commit and the rebase. Next: `review-check.sh --base 299862e4…`, then a fresh verifier (Opus high) and a fresh blind auditor (Opus xhigh) on `2d69e1e4`, `ac-check.sh`, then the landing with a rebase receipt.

## Update 2026-11-10 about 20:40
- Review 10: clean (`MOVE ON: review-10 at 2d69e1e`). Verifier 2 (Opus 5.5 high): clean on `2d69e1e4`, base `299862e4`; AC37's live test passed; its `ac.json` is `evidence/dream-pass/verifier/ac.json`.
- The second blind auditor (Opus 5.5 xhigh, brief `briefs/dream-pass-auditor-2.md`) is running. Next: `ac-check.sh --repo <worktree> --base <merge-base> --plan <evidence>/plan-approved.md --reviews <evidence> <evidence>/verifier/ac.json <evidence>/auditor/ac.json`, then the landing (update `briefs/dream-pass-finisher-2.md` for the rebase-receipt rule in `CLAUDE.md` step 7 and `ac-verification.md`).

## Update 2026-11-10 late evening
- The second blind auditor: 41 of 45 accepted; **AC8 NOT ACCEPTED** (AUD2-1: `test_ac8` never reads `state/pending.json`, so mutant A8p, which drops that write, survives the whole suite; the code itself is right). `ac-check.sh` printed `NOT ACCEPTED: 1 of 45 ACs on 2d69e1e`.
- Fixer 9 (Opus 5.5 high, brief `briefs/dream-pass-fixer-9.md`) is extending `test_ac8`. Next: a fresh review of that commit (Opus high), then the verifier again (resume verifier 2) and the auditor again (resume auditor 2), then `ac-check.sh`, then the landing.
- Justin switched this main session to Opus 5.5 at about this point.

## Update 2026-11-11
- Fixer 9 extended `test_ac8` (head **`ee17d9885d00d3d7ffa1f85bce1d9912980b5c7e`**); review 11 clean; verifier 2 (resumed) clean; auditor 2 (resumed) clean. `ac-check.sh … --reviews` printed **`READY FOR THE USER: 42 of 45 ACs proven on ee17d98`**.
- Finisher 3 (brief `briefs/dream-pass-finisher-3.md`) rebases onto the newest `main` and writes the rebase receipt in `evidence/dream-pass/rebase/`. Then the main session, at once: take `sync.sh`'s lock, check `main` still equals the rebased head's base, run `ac-check.sh … --rebase-receipt <receipt> --reviews <evidence> verifier/ac.json auditor/ac.json`, and on `REBASE  ACCEPTED` `git merge --ff-only dream-pass` from `$HOME`, release the lock; then a finisher for the after-merge step (`dream install` without `--enable`, `dream init`, `dream status`), one `sync.sh`, the final check, and Justin's three commands.

## Update 2026-11-11, later
- Finisher 3: rebase pure (53 of 53 `=`) onto `main` `23fd9580`, head `374ac3ec`; the receipt `evidence/dream-pass/rebase/receipt-374ac3e.log` ended `EXIT=1`: 41 of 42 passed, **AC37's live editor call was refused** (`editor ran on claude-opus-4-8, claude-opus-5-5, not claude-opus-5-5`; `agents.py` requires `modelUsage` keys to be exactly the pinned model). It passed four times before. A production defect too: the dream would refuse its editor run whenever the CLI adds a side model.
- Fixer 10 (Opus 5.5 high, brief `briefs/dream-pass-fixer-10.md`): proves the cause with at most 6 real calls, then fixes test-first while keeping "the dream's own work runs on Opus 5.5"; a plan gap goes to Justin. Then the full path again: review, verifier, auditor, ac-check, rebase receipt, merge.

## Update 2026-11-11, evening
- Fixer 10: the cause was the CLI's refusal fallback (a flagged turn is carried on to claude-opus-4-8); every dream call now sets `CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK=1` and `"switchModelsOnFlag": false`, and refuses `safety_stops > 0`. Review 12: one P2 (the AC37 probe is itself flagged now and then); Justin: "Fix it" (`review-12/justin.json`). Fixer 11: one retry only after a safeguard stop. Review 13: one P2 (the retry checked escapes only in its own folder); Justin: "Fix it" (`review-13/justin.json`). Fixer 12 (the same agent): every attempt's folder checked. Review 14: **clean** at **`ec7943dc3e0d6aa50c75ad9daffefd71c9b67955`**, base `23fd9580`.
- Verifier 2 resumed on `ec7943d` (new base, so base logs and the AC38 tally are redone). Then the auditor 2 resumed, `ac-check.sh`, the rebase receipt (finisher), the merge under the sync lock, the after-merge step, Justin's three commands.
