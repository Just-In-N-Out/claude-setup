# FIXER round 1: dream-trim (claude-setup), Mini pipeline

Role: FIXER. Verify each listed P0–P2 finding first (`receiving-code-review`), fix the valid ones test-first, commit, and stop `ready-for-next-review`. Push back with evidence on any finding you show is wrong. Don't fix the P3s (they go to follow-ups) unless a P2 fix necessarily touches the same lines. Don't rebase onto `main`.

- Approved plan (read-only contract): `~/.hermes/plans/claude-setup/evidence/dream-trim/plan-approved.md` ("Justin's answers" is binding; AC9 is `(live)`).
- Worktree: `/home/justin/.claude-setup-wt/dream-trim` (branch `dream-trim`), head `bac67c3475312e50e3557495a21073b5f61d9f2d`, base `131f9b0ad65dda6a4a157b5aefd829cebecee9be`.
- Evidence folder: `~/.hermes/plans/claude-setup/evidence/dream-trim/` (round-1 record and probes: `review-1/review.json`, `review-1/probes/r1-1-anchor-build-number.log`, `review-1/probes/r1-2-size-gate-blocks-pass2.log`, `review-1/probes/mutants-reviewer-1.log`; the builder's rulings: `builder/INVENTORY.md`).
- Never edit the live `$HOME` files, don't push, don't run the real `sync.sh`, and don't run `land.sh` against the real home.

## Skills (Skill tool), one line each
`receiving-code-review`, `test-driven-development`, `engineering-best-practices`, `mutation-testing-discipline` (the fixes are to a landing guard and a mover map), `git-commit-rules`.

## Keep the branch landable in two steps
The plan lands pass 1 first and pass 2 only after Justin says "land pass 2". The builder kept pass 2 (`bac67c34`) as the last commit so that everything before it can land alone. After your fix, landing everything except pass 2 must still be possible: say in your report exactly which commit to give `land.sh` for pass 1 and which for pass 2. Prefer new commits; if the only way to keep that property is to reorder (as the builder did, with `rebase --onto` plus `cherry-pick` on this branch only), say so, show that pass 2's patch-id is unchanged, and list old and new SHAs so the next reviewer can map them.

## Rules
- A failing test first for each fix, in `.claude/setup/trim/trim.test.sh`, named for the behaviour. The reviewer asks that the size-gate fix be tested both ways: pass 2 lands after a kept line grew past the pass-1 target, and a pass 1 that is over target is still refused. For the anchor fix, a test that the map still applies after the build-number line changes.
- Check the other 93 anchors for text that changes on its own (build numbers, dates, counters) while you are there, and say what you found.
- Re-run the whole `trim.test.sh` suite and AC4's suites after; tallies must match except the new tests. Use the verifier's base tally (`evidence/dream-trim/verifier/base-pins-verifier.txt`) as well as the builder's: the reviewer found one test the builder's tally marked failing that passes on base.
- If a fix changes a rule an AC states, stop and report `plan gap` instead of changing it silently.
- Commits: plain `git commit -m`, repo identity (`Justin <issajustin04@gmail.com>`), no AI or Co-Authored-By trailer, wait for the gate's exit before committing. Tree clean at the end (`git status --porcelain --untracked-files=all`).
- Tests use a scratch home, scratch setup repo and scratch project folder only.
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-trim-fixer-1/` (mkdir, no -p); big things under `~/.cache/dream-trim-fixer-1/`; remove both by literal path.
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop `mkdir` (uutils) isn't atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.

## Report
Return `{status: ready-for-next-review|stopped, head, land_pass1_commit, land_pass2_commit, findings[{id, outcome: fixed|rejected, test, commit, evidence}], suites[{name, tally}], sizes, found_else[], skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`

## The referee's lines (verbatim, from review-check.sh)
R1-1  P2  .claude/setup/trim/maps/dream-trim.json:377  The Status group's parent anchor holds the build number ("- **Current build `2026-11-09.4`** (read …"), so the mover refuses the whole map as soon as the next FigmaToBricks build changes that line. land.sh then stops with "the mover refused main's files" and nothing lands; the cure is a map edit, which ends Justin's Q1(a) condition (reviewed tool and map unchanged). Receipt: probes/r1-1-anchor-build-number.log. A prefix without the number ("- **Current build `") matches one line.
R1-2  P2  .claude/setup/trim/land.sh:122  land.sh applies the pass-1 size targets on every landing, pass 2 included, though the plan lands pass 2 on AC3/AC4/AC6/AC7 only and says pass 2 has no size target. Once a trimmed file grows past its pass-1 target, "land pass 2" stops with "check size: FAILED". The room is 705 (feature-dispatch), 1,359 (figma-to-bricks), 1,751 (leorna) and 2,923 (project CLAUDE.md) characters; the kept lines of those files grew 926, 987, 1,695 and 2,184 characters in the day before the base. Receipt: probes/r1-2-size-gate-blocks-pass2.log. No test reaches a failing check in land.sh (mutants LA, LD, LG, LH survive ac8, probes/mutants-reviewer-1.log), so the fix needs its own test: pass 2 lands after growth, and a pass 1 over its target is still refused.
REVIEW AGAIN: 2 P0-P2 finding(s) in review-1 at bac67c3: fix them, then review again (Full: round 2 reviews the whole story from 131f9b0; Mini: review the fix commits)
