# Brief: REVIEWER 10 (delta: one budget commit and a rebase), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 10** for Justin's setup story `dream-pass`. The story was reviewed clean (round 9) and accepted by a verifier and a blind auditor on `99bb2f31`. Its landing then stopped on a rebase conflict, and Justin decided to raise one budget. A fixer made that one change, rebased onto local `main` and resolved the one conflict. You review **only those two things**. You **only report**: no source changes, no commits, no other agents, nothing written outside `<evidence>/review-10/` and your scratch folder, never push, sync, merge or install, never run a real dream or the real `claude`.

**Be sparing:** Justin's weekly usage limit is nearly spent. This is a small, mostly mechanical review: do what the brief asks and stop. If a request is refused for the limit, stop; you will be resumed.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow it: a rebase inside the loop is reviewed as `git range-diff <old base>..<previous head> <new base>..HEAD`, `from` is still the previous round's head, and its "After MOVE ON" section says how to prove a rebase resolution.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git` (work tree `$HOME`).
- **Previous round's head (your `from`):** `99bb2f31f8d18ca5dfe18d4d59de61925a64b7b2`, on old base `63f09cb6ef84c490cc990f07b98bd27d85f5089a`.
- **Head:** `2d69e1e42b126b15a534a09d801f3d4cec411ce2`, on new base `299862e4911cd842f259a79d78d4499192928a43` (= `git -C <worktree> merge-base HEAD main`; `main` has moved on since, which is not your concern). 52 commits: the 51 reviewed ones replayed, plus the budget commit, which is the last one (`2d69e1e4`; it was `12ec2793` before the rebase).
- **Before you start,** confirm HEAD equals `2d69e1e` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only). The last paragraph of "Justin's answers" is his decision: the dream's budget for the global `CLAUDE.md` is 36,000, replacing 30,000 for that file only.
- The fixer's records: `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-8/` (`README.md`, `rebase.txt`, `range-diff.txt`, `claude-md-both-sides.txt`, the RED and GREEN logs, `mutants.md`, the suite and regression logs). Check its claims yourself.

### What the fixer reports
- **The budget commit:** `.claude/dream/conf/budgets.tsv` row `.claude/CLAUDE.md` 30000 → 36000; `.claude/dream/DREAM.md` section 6, "`~/.claude/CLAUDE.md` 30,000;" → "36,000;"; `.claude/dream/tests/test_docs.py` fails at 36,000 bytes or more and now also checks that `DREAM.md` and `budgets.tsv` state 36,000; a new test `test_the_global_claude_md_budget_is_36000_bytes` in `test_guards.py`; five new mutants B36a to B36e in `tests/mutants.py`. `caps.conf`'s `moved = 30000` and every other budget untouched.
- **The rebase:** 51 of 52 pairs are `=`; the one changed pair is `12f5792e` → `a0346bcb`. One conflict, in `.claude/CLAUDE.md`: `main`'s commit `1cc9837d` rewrote the line that begins "- **Agent models (user, …" and the story adds one sentence, "The dream reads the same skills and never duplicates a saved lesson.", to the line that begins "- **Subagents report skill lessons, the main session saves them". The fixer kept `main`'s text of both lines and added the story's sentence after "…that the skill doesn't already say."
- `.claude/CLAUDE.md` is 31,915 bytes on the head. The dream suite is at 93 passed; the regression gate's one mismatch (`codex-parity` `ac7_claude_hooks_unchanged`) passed when rerun alone on head and on `main`.

## Your job
1. **The budget commit** does what Justin decided and nothing else: read its diff. The number is 36,000 everywhere the global `CLAUDE.md`'s budget is stated and nowhere else changed; a `CLAUDE.md` of 36,000 bytes or more still fails the docs test; the guard still refuses an edit that takes the file past 36,000 and still lets an over-budget file only shrink. Run the two tests it touches by name on a scratch clone of the head, and show each can fail (the fixer's mutants B36a to B36e and the existing M8, or your own one-line reversals).
2. **Is the rebase faithful?** Run the range-diff yourself (`git range-diff 63f09cb6..99bb2f31 299862e4..2d69e1e4^` for the replayed commits). Every pair but one must be `=`; nothing added, dropped or reordered; authors and messages unchanged; no merge commits; no AI trailer.
3. **The one resolved conflict:** read the two lines on the old head, on the new base and on the new head. `main`'s "Agent models" line must be byte for byte `main`'s; the lessons line must be `main`'s plus the story's one sentence, unchanged, and must still read correctly. Rebuild the resolution with zero-context patches both ways, as `review-loop.md` now describes.
4. **The files both sides changed** (`git diff --name-only` of both ranges): for each, `main`'s text is kept and the story's addition is in place; the three `SKILL.md` files still carry their one pointer line in the same section; the dream's frozen sections and canary facts (`.claude/dream/conf/protected.tsv`, `conf/canary.tsv`) still match the rebased files. `main`'s `1cc9837d` rewrote pipeline rules in `CLAUDE.md`: if a protected section or a canary fact of the dream names text that commit changed, that is a finding (the dream would stop on its first run, or would freeze text that has moved on). Run `test_ac11…`, `test_ac16…` and `test_ac36…` by name on a scratch clone of the head (`bash .claude/dream/tests/run.sh <name>` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` in your scratch).
5. **What `main` brought that the story's code or tests read** (`settings.json`, the hooks folder, `manifest.txt`, `exclude.txt`, `.claude/setup/codex/`, `feature-dispatch/scripts/`): the story's additions are still in place and in the order its tests require.
6. Don't re-review the story. Anything you notice outside the budget commit and the rebase is P3.

## Output: `<evidence>/review-10/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-10/review.json`: round 10, scope "delta", from = `99bb2f31f8d18ca5dfe18d4d59de61925a64b7b2`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. P0/P1 a guard bypass, a false AC, a lost safety line or a wrong block; P2 a lost or altered line of either side, anything that breaks an AC, or a test that can't fail; P3 cosmetic or outside the scope. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 299862e4911cd842f259a79d78d4499192928a43 <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on. If it says the records do not cover the story from this base, report that line exactly.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-10/` (mkdir without -p); big things under `~/.cache/dream-pass-reviewer-10/`. Remove both by literal path at the end. Write your receipts into `review-10/` as you go (this desktop restarted twice today and `/tmp` is a RAM disk).
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. With `--git-dir ~/.claude-setup.git` from a subfolder a pathspec is read relative to that folder: use `git -C <worktree>`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes.
- Don't run the timing-sensitive regression gate (the verifier does that next).

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rebase_faithful: yes|no with evidence, both_sides_kept: yes|no with evidence, review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC11, AC14, AC16 and AC36.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
