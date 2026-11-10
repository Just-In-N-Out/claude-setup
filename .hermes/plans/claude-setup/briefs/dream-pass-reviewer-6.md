# Brief: REVIEWER 6 (delta), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 6** for Justin's setup story `dream-pass`. Rounds 1 and 2 were full reviews; every round since reviews only the fix commits since the last review and what they touch. Round 5 found one P2; this round reviews its fix. You **only report**:
- no source changes, no commits, no auto-fixes; no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub;
- never install or start the dream's timer or service, never run a real dream against Justin's real home, and never call the real `claude`.

You never saw the build, the earlier reviews' work or the fixes.

**Be sparing:** Justin's weekly usage limit is nearly spent. Do what this brief asks and no wider exploration. If a request is refused for the limit, stop; your work so far is kept and you will be resumed.

## Skills to load first (Skill tool; say so in one line each)
`engineering-best-practices`, `requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer), `code-review-practice`, `mutation-testing-discipline`.
Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly (delta round; three trees per probe: the oldest tree that has the code, the previous round's head, head).

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Head:** `0288330c0777ecf97b604a28c58409b9bec27655`. **Previous round's head (your `from`):** `d0c216db3e9198b1e2add6143a73a3f40c611f5b`. **Story base:** `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (it has no `.claude/dream`; round 1's head `cae6bf88` is the oldest tree with the code).
- Review `git diff d0c216db..0288330c`: 3 fix commits, 7 files, about 430 added lines, and what they touch. `DREAM.md` is unchanged this round.
- **Before you start,** confirm HEAD equals `0288330` and that `git status --porcelain --untracked-files=all` is empty. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only; "Justin's answers" is binding, its last paragraphs record the 2026-11-10 decisions, option (b) of the retire rule among them). **The rules the job must obey:** `.claude/dream/DREAM.md` in the worktree; section 7 covers the repeat-mistakes files.
- **What the story is:** a twice-daily job that reads what Justin typed in his Claude Code sessions and the pipeline's review findings, has one model helper per session list lessons, one editor change a copy of his skills, `CLAUDE.md` files and memory notes, and scripts decide what may go live as one commit. Part of it keeps three "repeat mistakes" files: a mistake kind seen in two stories is listed, and retires when it has not come back in 10 later stories.
- **Earlier records:** `~/.hermes/plans/claude-setup/evidence/dream-pass/review-5/review.json` and `review-5/probes/` (p05 is R5-1's probe); the fixer's answer in `fixer-5/README.md`, `fixer-5/probes/`, `fixer-5/final/` and `final-2/` (mutants).

### The fixer's answer to each item (all three reported fixed)
- **R5-1** (P2; commit `d78040a2`): at the first live run every past story is new at once and they were counted in folder-name order, so "not seen in 10 later stories" meant "its folder name sorts early". Now a story's date is the modification time of its earliest evidence file (`extract.story_times`), fixed in `tally.story_time` when the story is first counted; stories are inserted by date, also when counted in a later run; `listed_since.seq` moves with each insertion; `last_seen` per project is the time of the newest review file that found the kind, so a late round of a long story is a sighting at that round's date; ties between equally frequent kinds go to the kind seen most recently, then by name; a tally written by the earlier code is migrated at a run's start (`mistakes.migrate`), stories with no evidence left counting as the oldest. Five new tests, 18 mutants (R5a to R5r).
- **R5-3 and R5-4** (rated P3 by review 5, added by the main session; commit `b970cc76`): two sentences in the editor's prompt, no rule change: the safe way to fold (a comma or a full stop and a space before the added words), and the plain-name rule stated where the prompt talks about writing a new memory note. Two tests check each sentence is true against the script's own functions.
- `0288330c` only renames two mutant ids in `tests/mutants.py`.
The fixer reports 251 of 251 in-repo mutants killed and the dream suite at 89 passed.

### The fixer's rulings (rule on each: valid, or a finding)
1. A story's date is its first evidence file's modification time; "later stories" are those that began after the mistake was last seen; a late round of an older story is a sighting at its own date. The fixer reads this as within `DREAM.md`'s "has not come back in 10 later stories" and AC28, with no AC rule changed.
2. Ties are broken by recency, then by name (no AC or `DREAM.md` line set the priority for room).
3. The old tally is migrated, not rebuilt (a rebuild would pay the review helpers again).
4. Named limits: evidence copied with a tool that resets file times would be dated at the copy; a story begun within hours before a listing run, with a clean first round, could produce one extra enforce-backlog proposal line; equal file times keep the walk's order.

## Focus
- **Does R5-1's fix hold on real shapes?** Re-run review 5's p05 on this head (three trees), then measure read-only on Justin's real evidence folders (`~/.hermes/plans/*/evidence`; shapes, dates and counts only, with the head's own functions on in-memory data; nothing written, no model called; don't follow symlinks): is the date the fix picks the story's real start for every story, or do some stories get a wrong date in normal use? Things that happen here every day: a verifier or auditor folder replaced or moved to `superseded-*`; a reviewer rewriting its own `review.json` after a self-check; `follow-ups.md` and other files appended later; nested copies of another story's review; a story folder that holds no `review.json` or `ac.json` yet; evidence restored from a backup or touched by a sync or an editor; the clock after a Windows restart. Say how many real stories, if any, would be misdated and by how much, and whether that changes what is listed.
- **Everything that reads the order:** the retire count (AC28), option (b)'s "already due", the listing boundary used for enforce proposals, ties, the migration of a tally saved by the earlier code (a half-migrated tally, a tally from the other machine, a run killed mid-migration), and a story counted late. This is the fifth round on these rules (R1-9, R2-3, R3-1, R4-3, R5-1), and each earlier fix was right for its case and left a neighbour open: list the other ways to the same failure and probe each before accepting.
- **The two prompt sentences:** are they true of the script (an editor following them is never refused), and do the tests fail when a sentence is removed?
- **Tests:** does each new test fail with its fix removed; do the migration and insertion paths have assertions that can fail.
- **Did the fix break anything earlier rounds covered:** R3-1's bounded orders, R3-2's gone-entry add, option (b)'s cases from round 5 (pR2, pR3, pO1, pO2, pO6), AC27 and AC28's own tests.
- Anything else you notice outside the fix commits and what they touch is P3. Earlier P3s are follow-ups: if you find the same defect, set `repeats` to its id and add a `new_fact` when you have one.

## Output: `<evidence>/review-6/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-6/review.json`: round 6, scope "delta", from = `d0c216db3e9198b1e2add6143a73a3f40c611f5b`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases), anything breaking an AC or the session-start line, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-6/probes/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 131f9b0ad65dda6a4a157b5aefd829cebecee9be <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e7431cef-ff41-40e3-a2ba-ca5cd54b1f13/scratchpad/dream-pass-reviewer-6/` (mkdir without -p); big things under `~/.cache/dream-pass-reviewer-6/`. Remove both by literal path at the end; give each probe case its own fresh folder rather than removing one named through a shell variable.
- Probe on scratch copies: a fake home and a fake `claude` as the tests do, or `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>` (never `worktree add` against the setup repo; never a `git archive` copy for suites that check what git tracks).
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result (a line reading "sending SIGTERM when mem avail <= 5.00%…" with no process name is earlyoom's start banner, not a kill).
- Run the regression gate (`regression.sh` against `evidence/dream-pass/baseline.md`) with nothing else of yours running: `cortexos-memory.test.sh` is timing-sensitive and fails under load. `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on the base.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop coreutils are uutils and `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound. With `--git-dir ~/.claude-setup.git` from a subfolder a pathspec is read relative to that folder: use `:(top)` paths or `git -C <worktree>`.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files. `ac_status` covers the ACs the fix commits touch (AC27, AC28 and any other you find affected); the fresh verifier runs all of them after the loop.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
