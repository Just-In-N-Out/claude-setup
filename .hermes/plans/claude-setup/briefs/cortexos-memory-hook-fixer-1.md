# FIXER round 1: cortexos-memory-hook (claude-setup) — Mini pipeline

Role: FIXER. Verify each listed P0–P2 finding first (`receiving-code-review`), fix the valid ones test-first, commit, and stop
`ready-for-next-review`. Push back with evidence on any finding you show is wrong. Don't fix the P3s (they go to follow-ups) unless
a P2 fix necessarily touches the same lines. Don't rebase.
- Approved plan (read-only contract): ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md
- Worktree: /home/justin/.claude-setup-wt/cortexos-memory-hook (branch cortexos-memory-hook), head 8f168ca6377d60d6cde5745297c9d8007c20665f,
  base dd80ac4a38c74caf156b9e786f299471cf6c513b. Evidence folder: ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/
  (round-1 record and probes: review-1/review.json, review-1/perf-probe.sh, review-1/space-probe.out, review-1/cwd-drift.txt).
- Never edit the live $HOME files, don't push, don't run sync.sh, never write to CortexOS (read-only calls are fine).

## Skills (Skill tool), one line each
`receiving-code-review`, `test-driven-development`, `engineering-best-practices`, `git-commit-rules`.

## The referee's lines (verbatim)
R1-1  P2  .claude/hooks/cortexos-memory.sh:80  search's keyword jq (lines 71-82) scans the whole prompt and de-duplicates every token with index() before keeping 16, which is quadratic: the real head script on a pasted log, pointed at a closed loopback port so only local work counts, took 105 ms at 5 KB, 1106 ms at 51 KB, 8514 ms at 153 KB and 33337 ms at 305 KB (review-1/perf-probe.out). Every prompt over about 100 KB outlives the 3 s hook timeout before any request is made, contradicting the plan's 'the script caps itself at about 1 s' and desktop.md's 'a message waits at most about 1 s'. Fix: cut the prompt before scanning (e.g. .prompt[0:4000]; AC3's fixtures are all shorter) and stop collecting at 16 distinct words.
R1-2  P2  .claude/hooks/cortexos-memory.sh:88  search derives the project space from the payload's current cwd, so once the main session's cwd moves into a project subfolder or worktree, the key has no memory folder and only claude-shared is queried. Real sessions do move: 19 of the 65 most recent main-session transcripts carry more than one cwd on typed prompts, e.g. -home-justin-Documents-FigmaToBricksV2 moving to .claude/worktrees/header-bar. Probe with the real ~/.claude/projects layout (review-1/space-probe.out): cwd FigmaToBricksV2 queries [claude-documents-figmatobricksv2, claude-shared], its worktree queries only [claude-shared]; leorna-client vs leorna-client/frontend the same. Fix: when the cwd key has no memory folder, walk up cwd's parents, then fall back to the key of dirname(transcript_path), which is the session's own project folder.

## Rules
- A failing test first for each fix (in .claude/hooks/tests/cortexos-memory.test.sh), named for the behaviour; keep the early gates
  bash-3.2-safe (the Mac). Re-run the whole offline suite and AC14's suites after; tallies must match except the new tests.
- If a fix changes a rule an AC states, stop and report `plan gap` instead of changing it silently.
- Commits: plain `git commit -m`, repo identity (personal), no AI/Co-Authored-By trailer, no CLAUDE.md.
- Scratch in a fresh `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-fixer-1/` (mkdir, no -p); remove by literal path.
- Run suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM/143/137/"Killed" may be earlyoom:
  check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Desktop mkdir (uutils) isn't atomic.

## Report
Return `{status: ready-for-next-review|stopped, head, findings[{id, outcome: fixed|rejected, test, commit, evidence}], suites[{name, tally}],
found_else[], skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
