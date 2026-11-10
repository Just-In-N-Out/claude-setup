# FIXER round 6: dream-pass (claude-setup), Full pipeline

Role: FIXER. Verify the finding first (`receiving-code-review`), fix it test-first, commit, and stop `ready-for-next-review`. Push back with evidence if you show it is wrong. Fix nothing else. Don't rebase; add commits on top of the head.

You fix one P2 of review 6 (R6-1). The referee stopped the loop on it (`ASK JUSTIN: review-6: 1 P0-P2, no fewer than review-5's 1`) and Justin answered "Fix it, review again" on 2026-11-10.

- Approved plan (read-only contract): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` ("Justin's answers" is binding; AC39, AC40, AC41 are `(live)`). The rules the job must obey: `.claude/dream/DREAM.md` in the worktree (section 7 covers the repeat-mistakes files).
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `0288330c0777ecf97b604a28c58409b9bec27655`, base `131f9b0ad65dda6a4a157b5aefd829cebecee9be`.
- Evidence folder: `~/.hermes/plans/claude-setup/evidence/dream-pass/`. This round's record and probes: `review-6/review.json` (1 P2, 4 P3; read R6-1's full claim there) and `review-6/probes/` (p12 and p14 for R6-1; p07 for the reviewer's mutants). Earlier: `fixer-5/README.md`, `fixer-5/final/` and `final-2/` (mutants).
- Never edit the live `$HOME` files, never push, never run the real `sync.sh`, never install or start the timer or service, never run a real dream against Justin's real home, never call the real `claude`.

## Skills (Skill tool), one line each
`receiving-code-review`, `test-driven-development`, `engineering-best-practices`, `mutation-testing-discipline`, `git-commit-rules`. `systematic-debugging` if something fails unexpectedly.

## The item
**R6-1 (P2, repeats R5-1 with a new fact):** after the backfill a run reads at most 150 new review lines, and they are the first 150 the evidence walk finds (projects by name, then story folders by name: `agents.py:201` `lines[:limit]`, `extract.py:433-462`), not the oldest 150. Stories are placed by date once their lines are read, but the retire rule runs on the stories counted so far and a removal is for good. So when more than 150 lines wait (about 5 days of real lines; a run that fails on login, limits, a sync conflict or no network reads nothing, and so do mode off and dry-run), a listed kind that came back in a story whose lines wait past the first 150 is removed and retired for good; the next run reads the sighting and changes nothing. The same on every earlier tree. Fixer 5's table and its new test's text name "lines that waited for the 150-line limit" as covered; the test covers only the story's place.

The reviewer's two smallest fixes: give the helper the oldest lines first (sort by file time before the cut), or order no removal in a run that left lines unread. Choose what closes the class, and say why: **no decision that is for good (a retire, and anything else you find that cannot be undone by a later run) may be taken while evidence the dream has not read yet could change it.** Look at each place a run can leave review lines unread (the 150-line limit, a failed helper for one project while others answer, the backfill's per-project helpers, lines newer than the walk's start) and at each for-good decision that reads the tally, and probe every pair. R6-2 (a P3: one project's backfill helper fails once, a stale two-project kind is listed in the general file and then retired for good when the other project's stories are read) is the same class from the other side; if your fix for R6-1 closes it, say so and show it; if it does not, leave it and say why.

Before you call it fixed, list the other ways to the same failure and probe each. This is the sixth round on the repeat-mistakes ordering and retiring rules (R1-9, R2-3, R3-1, R4-3, R5-1, R6-1).

## Rules
- A failing test first, named for the behaviour, in the suite the plan uses: more than 150 lines waiting, with a listed kind seen again in a story whose lines sort past the cut, run until nothing is owed with the obeying editor (`tests/obey.py`); the kind stays listed. The test must fail with the fix removed. Fix the text of fixer 5's test that claims the 150-line path if it is still untrue.
- The reviewer's mutants mx3 and mx4 (R6-5, a P3) pass tests named for them; where your fix touches the same functions (`mistakes._last`, `mistakes._place`), don't leave a clause that cannot fail.
- If you rewrite an older test's fixture, rerun that test's registered mutants before committing. Re-run every earlier mutant set on your head under the memory cap (`fixer-5/final/` and `final-2/` list 251; add your own) and report killed and survived. Give every generated fixture line its own text, and give fixture files real, distinct times with `os.utime` where the code reads file times.
- If the fix changes a rule an AC states (AC28's retire rule, AC30's 150 lines per run), or needs a decision that is Justin's, stop and report `plan gap` with lettered options.
- Keep every AC's test name exactly as the plan writes it. Re-run the whole dream suite, both hook suites and `regression.sh` against `evidence/dream-pass/baseline.md` after; tallies must match except the new tests. Run the regression gate with nothing else of yours running (`cortexos-memory.test.sh` is timing-sensitive). `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on the base.
- Commits: plain `git commit -m` with a one-line subject, repo identity (`Justin <issajustin04@gmail.com>`), no AI or Co-Authored-By trailer, wait for a gate's exit before committing. Tree clean at the end (`git status --porcelain --untracked-files=all`).
- Tests use a fake home, a fake `claude`, temp repos and `HOME`/`GIT_CONFIG_GLOBAL` overrides only. No fixture holds Justin's real messages, keys, tokens or story names.
- List every line of `DREAM.md` you add or change in your report: that file changes only when Justin says so, and he is shown each line.
- **Be sparing:** Justin's weekly usage limit is nearly spent. Do what this brief asks, no wider exploration, and if a request is refused for the limit, stop cleanly: commit what passes, leave the tree clean, and say where you stopped.
- Evidence for this round goes in `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-6/`: the RED log and the GREEN log (first line `HEAD=<sha>`, last line `EXIT=<code>`), a README, and the mutant table.
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e7431cef-ff41-40e3-a2ba-ca5cd54b1f13/scratchpad/dream-pass-fixer-6/` (mkdir, no -p); big things under `~/.cache/dream-pass-fixer-6/`; remove both by literal path, one fresh folder per case.
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (a line reading "sending SIGTERM when mem avail <= 5.00%…" with no process name is earlyoom's start banner, not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `xargs`, `find -exec` or `systemd-run`); never `| grep -q` under `pipefail`; never `cmd && fail "msg" && return 1` in a bash test; desktop `mkdir` (uutils) isn't atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.

## What comes after you
Round 7 is a fresh delta review of your fix commits (`0288330c..HEAD`). `dream-trim` pass 1 has landed on `main` since this branch was cut; don't rebase, the finisher does.

## Report
Return `{status: ready-for-next-review|stopped, head, findings[{id, outcome: fixed|rejected|plan gap, test, commit, evidence, other_ways_probed}], dream_md_lines[], mutants{killed, survived[]}, suites[{name, tally}], rulings[], questions[{q, options[], recommended}], found_else[], skill_lessons[]}`.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`

## The referee's lines (verbatim, from review-check.sh; the full text is in review-6/review.json)
R6-1  P2  .claude/dream/lib/dreamlib/agents.py:201  After the backfill a run reads at most 150 new review lines, and they are the first 150 the evidence walk finds: projects by name, then story folders by name (agents.py:201 `lines[:limit]`, extract.py:433-462), not the oldest 150. … a listed kind that came back in a story whose lines wait past the first 150 is judged 'not seen in 10 later stories', its entry is removed and it is retired for good; the next run reads the sighting and changes nothing.
REVIEW AGAIN: 1 P0-P2 finding(s) in review-6 at 0288330: fix them, then review the fix commits
