# Brief: REVIEWER 1 (full round), story `pipeline-token-diet`

## Role
You are the fresh, full **reviewer 1** for Justin's setup story `pipeline-token-diet`. You never saw the build. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.codex`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/review-1/` and your scratch folder.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks check every commit. A deny is the guard working.

**What the story is.** It makes Justin's bug/story pipeline cheaper: new model routing per role (Full and Mini), a late-round brake in `review-check.sh` (from round 3 a P2-only round asks Justin), a rebase receipt in `ac-check.sh` (no new verifier and auditor after a pure rebase), a token report tool, and a consistency test over every file that states the rules. The two scripts gate every later story. **This story's own reviews run on today's live gate scripts**, not the worktree's.

## Skills to load first (say so in your first steps)
1. `engineering-best-practices`
2. `requesting-code-review`: skip its "independent reviewer subagent" and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`, a linked worktree of the setup repo `~/.claude-setup.git` (work tree `$HOME`).
- **Candidate head:** `e280aefd9d53a25be71d92ab81d605a6f377b170`. **Base:** `e9f160a28694af1557bd94289b5a25d08e110eb4`. Review all of `git diff e9f160a2...e280aefd` (20 files, about 1,770 lines added).
- **Before you start,** confirm HEAD is `e280aefd` and `git status --porcelain --untracked-files=all` is empty. If either fails, stop and report.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/plan-approved.md` (read-only). Read "Amendments", "Justin's answers", "The chosen set", "Acceptance criteria", "Where the rules are stated", "Tasks, in build order", "Risks" and Appendices A and B; the analysis sections are background. ACs AC1–AC6; AC6 is `(live)`.

### The builder's departures from the plan (rule on each: valid, or a finding)
1. Task 3: the `ac-check.sh` usage line is unchanged (the plan asked to add `[--rebase-receipt <log>]` to it and also for byte-identical output without the option, which `ac11` pins); the option is documented in the header comment.
2. Token report: the default output folder is `~/.cache/token-report`, not the script's own folder (the plan said "today's values as defaults").
3. `report.py` has a new `tokens` section (per-role tokens and API $), pinned by the fixture test.
4. The rules test's check 3 also refuses `xhigh` or `Fable` in the later-round reviewer row and the Finisher row.
5. Mini's round-1 reviewer still does the verifier's AC work (writes `verifier/ac.json`), so Mini's first AC proof stays on Fable 5.2 high while the Verifier row is Opus 5.5 high. The plan didn't change this.
6. Lines appended to the synced plan file `follow-ups-review-loop.md`.
7. The worktree's `.codex/AGENTS.md` was regenerated with `build-codex.sh`; it is git-excluded.

### Focus areas
- **AC truth:** does each named test prove every clause of its AC, and can it fail?
- **The late-round brake (AC2).** Could the referee now print `MOVE ON` with a P0–P2 left, or `ASK JUSTIN` in round 1 or 2, or with a P0/P1 present? Does `"continue": true` in that round's `justin.json` give `REVIEW AGAIN`, and `"accept"` send the P2s to follow-ups? Does it hold for full and delta rounds and realistic records (several rounds, ACCEPTED findings, no-scenario P2s, earlier brakes firing together)?
- **The rebase receipt (AC3).** Can a head pass without proofs that cover it: a rebase that is not pure, a receipt for another head, a failing, skipped or missing AC test in the receipt, a receipt reused after more commits? Is the output without the option really unchanged? Does `--reviews` still refuse an unreviewed head?
- **The rule text (AC1).** Do `CLAUDE.md` (pipeline paragraph, steps 5–7, "Agent models" bullet), feature-dispatch `SKILL.md`, `mini-pipeline.md`, `model-routing.md`, `review-loop.md`, `ac-verification.md`, `main-chat-housekeeping.md`, `review-fix-cadence`, the leorna and figma-to-bricks skills and the Codex header state one routing and one set of rules, Full and Mini, with no old pairing or contradiction left? Is anything the plan says stays unchanged (plan approval, a fresh review of every fix, two AC proofs, two full reviews in Full) weakened by an edit? Do the two changed rules keep a dated *Why* note? Would the consistency test catch a wrong value in each file it lists? Is feature-dispatch `SKILL.md` still under 100,000 characters?
- **The token report (AC4):** counts a repeated message id once; never writes into the synced skill folder; the test touches only its fixture.
- **Both machines:** macOS `/bin/bash` 3.2, BSD tools and jq 1.6; Ubuntu on WSL. Run the script suites again as `PATH=/usr/bin:/bin /bin/bash`.

## Severity (Justin's rule; every P0–P2 needs a concrete real-use scenario of 5+ words, otherwise it is P3)
- **P0/P1:** the gate or referee lets unreviewed, unproven or still-buggy code through, a false AC, a wrong `ASK JUSTIN` or `REVIEW AGAIN` that would stall every story, or a broken existing suite.
- **P2:** a bug a real reviewer, fixer, finisher or orchestrator could plausibly hit, realistic edge cases included, a rule text contradiction an agent would act on, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## How
- Run on head, in the worktree, under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: `scripts/review-check.test.sh`, `scripts/ac-check.test.sh`, `scripts/pipeline-rules.test.sh` and `scripts/token-report/token-report.test.sh` (all under `.hermes/skills/autonomous-ai-agents/feature-dispatch/`), plus the named run `existing_suites_pass` with `PIPELINE_RULES_BASE=~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/base-tallies`.
- Probe the referee and the gate yourself with hand-made record sets in a temp folder. Do mutation checks in a copy outside the worktree (`git clone -q ~/.claude-setup.git ~/.cache/pipeline-token-diet-reviewer1/c && git -C ~/.cache/pipeline-token-diet-reviewer1/c checkout -q --detach e280aefd`), always under the memory cap.
- Don't treat the builder's evidence (`…/evidence/pipeline-token-diet/builder/`) as proof.

## Your round record (required)
Write `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/review-1/review.json` in the format of the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`: round 1, scope `full`, `from` = base, `head` = `e280aefd…`, findings with id `R1-<k>`, severity, `file_line`, `claim` and `scenario`.

Then self-check it with the **live** referee and save its output as `review-1/referee.txt`:
`bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/pipeline-token-diet --base e9f160a28694af1557bd94289b5a25d08e110eb4 ~/.hermes/plans/claude-setup/evidence/pipeline-token-diet`

## Scratch and the desktop
- Scratch, `TMPDIR` and anything large in `~/.cache/pipeline-token-diet-reviewer1/` (`/tmp` is a shared RAM tmpfs).
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so, find what grew, and rerun under the cap, never bare.
- **Gotchas:** in the Bash tool `grep` is ugrep (use `command grep`); use `tail -n N`; never `pkill -f`.

## Output (final message)
- `verdict`: `clean` (no P0–P2) or `changes-needed`.
- `findings[{id, severity, file_line, scenario, claim, evidence, fix}]`.
- `p3[]`.
- `departures[{n, ruling, why}]`.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC6. AC6: `accepted: false, not_run: "live: …"`.
- `referee_last_line`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
