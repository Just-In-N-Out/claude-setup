# Brief: REVIEWER 2 (full), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh, full **reviewer 2** for Justin's setup story `dream-pass`. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub;
- never install or start the dream's timer or service, never run a real dream against Justin's real home, and never call the real `claude` (the verifier runs the one live test later).

You never saw the build, round 1's work or the fix. In the Full pipeline round 2 is a full review again: the whole story from the base, not only the fix.

## Skills to load first (Skill tool; say so in one line each)
1. `engineering-best-practices`
2. `requesting-code-review`: use its security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer.
3. `code-review-practice`
4. `security-best-practices`: this job feeds text from transcripts to model calls and then writes Justin's live instruction files without a human reading them.
5. `mutation-testing-discipline`: check that the AC tests and guards can actually fail.

Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git` (main work tree `$HOME`).
- **Candidate head:** `e3c6302a16b63092e1bddecbe4dfa841397fb9ff`. **Base:** `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (= `git -C <worktree> merge-base HEAD main`). Review `git diff 131f9b0...e3c6302`, all 25 commits (75 files, about 8,540 added lines). The first 9 commits are the build (up to `cae6bf88`, the head round 1 reviewed); the 16 after it are the fix round.
- **Before you start,** confirm HEAD equals `e3c6302` and that `git status --porcelain --untracked-files=all` is empty. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only). Its "Justin's answers" section is binding: every recommended option, Q1 (a) through Q9 (a).
- **The rules the job must obey:** `.claude/dream/DREAM.md` in the worktree.
- **ACs:** AC1–AC45. AC39, AC40 and AC41 are `(live)`: mark them `not_run` for that reason. AC37 is a named-only live test (two real model calls): judge its code, don't run it.
- **Earlier records:** `~/.hermes/plans/claude-setup/evidence/dream-pass/review-1/review.json` (31 findings: 3 P1, 11 P2, 17 P3) with `review-1/probes/`; the fixer's answers in `fixer-1/README.md` (each finding mapped to its RED and GREEN logs) and `fixer-1/mutants.md`; the builder's rulings in `builder/INVENTORY.md`.

### The fixer's answer to each round-1 P0–P2 (all 14 reported fixed; none rejected)
R1-1 `cf7e7de5` (a line of NUL bytes is skipped and noted; any other broken line is still an unknown shape; unreadable sessions show in the session-start line and no longer stop review lines or waiting findings). R1-2 `f24558cc` (only finding and order changes may add lines; a duplicate's surviving text must be whole lines present before and after, keeping at least half of the removed line's words and all of its dates). R1-3 `c6317a46` (the allowlist accepts a repeat-mistakes diff equal to the script's own rewrite). R1-4 `1c87c4a1` (a finding listed as applied needs a diff holding its additions). R1-5 `ab5f0ac2` (a stop in the apply step adds no try). R1-6 `bd94180e` (the dream's own files are rebuilt on their current text under the lock, after the pull; if `pending.json` or `tally.json` changed, the run stops with no try). R1-7 `db5ef3aa` (`dream undo` refuses while the library clone or a project file holds unsynced edits). R1-8 `b3e6bdba`, `e3c6302a` (text outside the entries of a repeat-mistakes file cannot change). R1-9 `87add4cd` (orders bounded to the file's room, most frequent first). R1-10 `142b3670` (the first message after a marker keeps Claude's text before it). R1-11 `24abe4ad` (unattributed changes are written after a commit, from the journal). R1-12 `48a5cffe`, `cc1d236a` (a nothing-new run clears a failed or stopped run from `last-run.json`; AC4's test still passes). R1-13 `96220b69` (shape checks on `changes.json`; evidence JSON that is not an object is skipped; a crash writes a failed `last-run.json`). R1-14 `cc334382`, `e3c6302a` (a wiring test per guard and per stop). The fixer reports 105 of 105 mutants killed and the dream suite at 67 passed.

### The fixer's rulings (rule on each: valid, or a finding)
1. **R1-2:** a duplicate or move change may add no text at all. Consequence the fixer names: a no-finding "move" tidy in an over-budget file cannot add a pointer line (`See references/x.md`), so that run stops. `DREAM.md` section 6 says a file over budget may only shrink and that whole sections move to `references/` before any text is cut. Say whether this ruling makes that move impossible in practice, and what the plan's wording supports.
2. **R1-6:** when `pending.json` or `tally.json` changes under the dream, the run stops and drops its copies; implied candidates seen once in that run's sessions are lost.
3. **R1-9:** room per file is 15,000 bytes, with a 400-byte allowance per new entry; once one kind does not fit, no less frequent kind is ordered into that file.
4. **R1-12:** while the dream is off, a failed run still shows in the session-start line, worded "the dream is off, so no run tries again".
5. **R1-13:** a crash writes `last-run.json` and then re-raises.
6. **R1-14:** the fixer also fixed R1-19 (a P3): slash-command text now counts as typed.
7. **`DREAM.md` sections 6, 13 and 14 and `desktop.md` each gained a line** stating the rules these fixes added. `DREAM.md` says it changes only when Justin says so.
8. The builder's rulings from round 1 still stand as round 1 ruled them (ruling 1 is now option (b), fixed as R1-1).

## Focus areas
- Everything in the "Focus areas" section of `~/.hermes/plans/claude-setup/briefs/dream-pass-reviewer-1.md` applies again: read that section and work through it on this head. Do your own probing; don't lean on round 1's conclusions.
- **Do the 14 fixes hold?** Re-run round 1's probes (`review-1/probes/`) on this head, then vary them: for R1-2 especially, try every way to replace or drop a dated rule, a safety line or a "why" without quoted evidence (a duplicate naming a different whole line that shares half the words and the date; a move whose target is elsewhere; a tidy in an over-budget file; a finding that passes the bar but does not concern the line it replaces).
- **Did a fix open something new?** The new allowances are the places to press: the script's own rewrite of a repeat-mistakes file (R1-3), `own_writes()` under the lock (R1-6), the skipped NUL line (R1-1: can real typed text be lost or a different shape be skipped?), the cleared `last-run.json` (R1-12: can a real failure disappear before Justin sees it?), slash-command text as typed (R1-19).
- **Wrong blocks:** a rule so strict the dream stops on every run in normal use (ruling 1 above; a stale state file; two machines).
- **The round-1 P3s** (R1-15 to R1-31, except R1-19) were not fixed and are follow-ups. If you find the same defect, set `repeats` to its id and add a `new_fact` when you have one; don't raise its severity without a concrete real-use scenario round 1 did not have.

## Output: `<evidence>/review-2/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-2/review.json`: round 2, scope "full", from = the base, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases: inputs, configs, git operations, macOS and WSL), anything breaking an AC or the session-start line, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-2/probes/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
The "Environment rules" section of `~/.hermes/plans/claude-setup/briefs/dream-pass-reviewer-1.md` applies unchanged, with your scratch folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-2/` and cache folder `~/.cache/dream-pass-reviewer-2/` (fresh, `mkdir` without `-p`, removed by literal path at the end; give each probe case its own folder rather than removing one named through a shell variable). `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on the base and its `ac7_claude_hooks_unchanged` is flaky: compare by name against two runs.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
