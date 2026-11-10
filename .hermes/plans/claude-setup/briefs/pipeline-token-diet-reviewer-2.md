# Brief: REVIEWER 2 (full round), story `pipeline-token-diet`

## Role
You are the fresh, full **reviewer 2** for Justin's setup story `pipeline-token-diet`. You never saw the build, round 1's work or the fix. In the Full pipeline round 2 is a full review again: the whole story from the base, not only the fix. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.codex`, `~/Documents/FigmaToBricksV2`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/review-2/` and your scratch folder.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks check every commit. A deny is the guard working.

**What the story is.** It makes Justin's bug/story pipeline cheaper: new model routing per role (Full and Mini), a late-round brake in `review-check.sh` (from round 3 a P2-only round asks Justin), a rebase receipt in `ac-check.sh` (no new verifier and auditor after a pure rebase), a token report tool, and a consistency test over every file that states the rules. The two scripts gate every later story. **This story's own reviews run on today's live gate scripts**, not the worktree's.

## Skills to load first (say so in your first steps)
1. `engineering-best-practices`
2. `requesting-code-review`: skip its "independent reviewer subagent" and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`, a linked worktree of the setup repo `~/.claude-setup.git` (work tree `$HOME`).
- **Candidate head:** `0977104b5fb74d24c45c66711684ad9a5a86881c`. **Base:** `e9f160a28694af1557bd94289b5a25d08e110eb4`. Review all of `git diff e9f160a2...0977104b`: 7 commits, the first 5 are the build (up to `e280aefd`), the last 2 are fix round 1 (`65f3ae22` for R1-1, `0977104b` for R1-2).
- **Before you start,** confirm HEAD is `0977104b` and `git status --porcelain --untracked-files=all` is empty. If either fails, stop and report.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/plan-approved.md` (read-only). Read "Amendments", "Justin's answers", "The chosen set", "Acceptance criteria", "Where the rules are stated", "Tasks, in build order", "Risks" and Appendices A and B; the analysis sections are background. ACs AC1–AC6; AC6 is `(live)`.
- **Earlier records:** `…/evidence/pipeline-token-diet/review-1/` (`review.json`: 2 P2, 7 P3; `mutants.txt`, `probes.txt`) and the fixer's files in `…/fix-1/` (`README.txt`, mutant runs, `ledger-probe.txt`, `figma-claude-md.patch`). Round 1 ruled the builder's seven departures valid; they are listed in `briefs/pipeline-token-diet-reviewer-1.md`.

### Focus areas
- Everything in the "Focus areas" section of `~/.hermes/plans/claude-setup/briefs/pipeline-token-diet-reviewer-1.md` applies again: read that section and work through it on this head. Do your own probing; don't lean on round 1's conclusions.
- **Do the two fixes hold?**
  - R1-1: `routing_text_agrees` now pins 56 prose statements word for word (check 6), has a pairing-shaped negative with exemptions for dated Why/Superseded notes (check 7), and compares more of `CLAUDE.md` against the built Codex copy. Can a wrong model, effort or rule still be written somewhere the test reads without it failing? Can the exemptions hide a real wrong pairing (a wrong value inside a `*Why…*` note that an agent would act on, a line that only looks dated)? Is any pinned statement itself wrong against the plan's routing table? Does the test fail on correct text (gawk and mawk, bash 3.2, wrapped lines)?
  - R1-2: the FigmaToBricksV2 `CLAUDE.md` copy in `.claude/project-docs/` now points at global step 7 and the global routing, and says its ledger commit before the rebase means the full path there. Is that text true against the worktree's `ac-check.sh` and `CLAUDE.md` step 7, and does it leave that project's other rules as they were? Does `fix-1/figma-claude-md.patch` applied to a copy of `~/Documents/FigmaToBricksV2/CLAUDE.md` give the worktree copy byte for byte, and are the instructions in `fix-1/README.txt` enough for a finisher to apply it before the post-merge sync?
- **Did a fix open something new?** The test is now a tripwire on exact wording: does a normal later edit (a lesson folded into a pinned line, a new project `CLAUDE.md` copy, a dated note added) fail it with a message that says what to do? Does it read files outside the worktree or depend on this machine's paths?
- **The round-1 P3s** (R1-3 to R1-9) were not fixed and are follow-ups. If you find the same defect, set `repeats` to its id and add a `new_fact` when you have one; don't raise its severity without a concrete real-use scenario round 1 did not have.

## Severity (Justin's rule; every P0–P2 needs a concrete real-use scenario of 5+ words, otherwise it is P3)
- **P0/P1:** the gate or referee lets unreviewed, unproven or still-buggy code through, a false AC, a wrong `ASK JUSTIN` or `REVIEW AGAIN` that would stall every story, or a broken existing suite.
- **P2:** a bug a real reviewer, fixer, finisher or orchestrator could plausibly hit, realistic edge cases included, a rule text contradiction an agent would act on, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## How
- Run on head, in the worktree, under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: `scripts/review-check.test.sh`, `scripts/ac-check.test.sh`, `scripts/pipeline-rules.test.sh` and `scripts/token-report/token-report.test.sh` (all under `.hermes/skills/autonomous-ai-agents/feature-dispatch/`), plus the named run `existing_suites_pass` with `PIPELINE_RULES_BASE=~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/base-tallies`. Run the script suites again as `PATH=/usr/bin:/bin /bin/bash`. Known from the fixer, check it yourself: under that minimal PATH `existing_suites_pass` fails in codex-parity because `codex` and `gitleaks` are not on it, the same on the build head.
- Probe the referee and the gate yourself with hand-made record sets in a temp folder. Do mutation checks in a copy outside the worktree (`git clone -q ~/.claude-setup.git ~/.cache/pipeline-token-diet-reviewer2/c && git -C ~/.cache/pipeline-token-diet-reviewer2/c checkout -q --detach 0977104b`), always under the memory cap.
- Don't treat the builder's or the fixer's evidence as proof.

## Your round record (required)
Write `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/review-2/review.json` in the format of the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`: round 2, scope `full`, `from` = base, `head` = `0977104b…`, findings with id `R2-<k>`, severity, `file_line`, `claim` and `scenario` (and `repeats`/`new_fact` where they apply).

Then self-check it with the **live** referee and save its output as `review-2/referee.txt`:
`bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/pipeline-token-diet --base e9f160a28694af1557bd94289b5a25d08e110eb4 ~/.hermes/plans/claude-setup/evidence/pipeline-token-diet`

## Scratch and the desktop
- Scratch, `TMPDIR` and anything large in `~/.cache/pipeline-token-diet-reviewer2/` (`/tmp` is a shared RAM tmpfs).
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so, find what grew, and rerun under the cap, never bare.
- **Gotchas:** in the Bash tool `grep` is ugrep: use `/usr/bin/grep` (inside `xargs`, `find -exec` or `systemd-run`, `command grep` does not work); `tail -n N`; never `pkill -f`.

## Output (final message)
- `verdict`: `clean` (no P0–P2) or `changes-needed`.
- `findings[{id, severity, file_line, scenario, claim, evidence, fix}]`.
- `p3[]`.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC6. AC6: `accepted: false, not_run: "live: …"`.
- `referee_last_line`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
