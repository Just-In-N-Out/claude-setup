# Brief: FIXER 1, story `pipeline-token-diet` (Full pipeline)

## Role
You are a fresh **fixer**. Review round 1 found 2 P2 findings; the referee said `REVIEW AGAIN`. You verify each finding, fix the valid ones test-first on the story's branch, and stop at `ready-for-next-review`. You don't:
- review your own work, or start other agents;
- push, merge into `main`, rebase, or run the real `~/.claude/setup/sync.sh`;
- write the live `~/.claude`, `~/.hermes`, `~/.codex`, `~/Documents/FigmaToBricksV2` or global git config. Every change goes into the worktree's copies.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks check every commit. A deny or a refusal is the rule, not a bug to work around.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `receiving-code-review`: verify each finding before fixing it; fix the valid ones test-first; push back with evidence on any that is wrong.
- `test-driven-development`
- `mutation-testing-discipline` (runs always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`)

## Where
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`. HEAD must be `e280aefd9d53a25be71d92ab81d605a6f377b170` with an empty `git status --porcelain --untracked-files=all` when you start; if not, stop and report. Base `e9f160a28694af1557bd94289b5a25d08e110eb4`.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/plan-approved.md` (read-only): "Justin's answers", "The chosen set", "Acceptance criteria", "Where the rules are stated", task 4. AC1 is the one these findings touch.
- **The review:** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/review-1/` (`review.json`, `mutants.txt` with the surviving statements T1–T34 and the controls K1–K10, `probes.txt`).

## The findings to fix
- **R1-1 (P2), `scripts/pipeline-rules.test.sh:100`, `routing_text_agrees`:** the test pins the routing only in the routing sentence, `CLAUDE.md`'s three Agent-tool fragments, the two role tables and 21 exact old phrases. Every other prose statement of a role's model or effort, or of the two changed rules, can be wrong with the test still `ok`: 26 of 26 of the reviewer's prose mutants survived. AC1 says every role has the same model and effort in every file.
  - The reviewer's suggested fixes: pin each prose statement with a `holds` fragment as checks 2 and 4 do; or reword prose to point at the role table so that only the sentence and the tables state a pairing; plus a pairing-shaped negative (no rule-file line outside dated Why/Superseded text pairs a later round, delta review, fixer or verifier with Fable or xhigh).
  - Choose the smallest change that makes the test fail for each statement the reviewer listed. **The meaning of the rule text must not change**, and nothing the plan says stays as today may be weakened. If you reword prose, keep the dated *Why* notes.
  - Done when: every one of the reviewer's 26 surviving mutants is killed by `routing_text_agrees` (rerun them; save the runs), the 10 controls still die, and the test is `ok` on your head.
- **R1-2 (P2), `.claude/project-docs/figma-to-bricks/CLAUDE.md:258` (and line 236):** FigmaToBricksV2's `CLAUDE.md` copy still tells its orchestrator to run verifier → auditor → `ac-check.sh` again whenever HEAD differs after the finish step, and still says "two fresh Opus reviews". It is not in the test's `RULE_FILES`.
  - Fix the copy **in the worktree** so it agrees with the new global rule (a pointer to global step 7 and to the global routing is enough), and add every `.claude/project-docs/*/CLAUDE.md` copy to what `routing_text_agrees` reads for the replaced rules.
  - **Don't change the order of FigmaToBricksV2's own finish steps.** The reviewer says its finisher commits the ledger before the rebase, so the head is not a pure rebase and the receipt can't apply there today. Check that claim; make the text say what is true with today's order; whether to move the ledger commit is Justin's decision, so put it in `found_else`, don't decide it.
  - `sync.sh` overwrites this copy from the project's own file (`~/Documents/FigmaToBricksV2/CLAUDE.md`, byte-identical today). You must not edit that live file. Save the exact same change as a patch the finisher can apply to it after the merge: `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/fix-1/figma-claude-md.patch`, with one line above it in `fix-1/README.txt` saying when and how to apply it. Check the other `project-docs` copies for the same two replaced rules and say what you found.

The P3 findings (R1-3 to R1-9) are not yours: they go to follow-ups.

## Rules
- Each fix: a failing test (or failing mutant run) first, then the change, one commit per finding, each commit green. Plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`, **no `Co-Authored-By` or any AI trailer**, no author overrides.
- Keep every AC test name exactly as the plan writes it. The three script files obey the portability rules at the top of the plan's "Tasks" section (bash 3.2, no GNU-only flags).
- Before reporting: `routing_text_agrees`, `review-check.test.sh`, `ac-check.test.sh`, `token-report.test.sh` and the named run `existing_suites_pass` (with `PIPELINE_RULES_BASE=~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/base-tallies`) all pass on your head, also as `PATH=/usr/bin:/bin /bin/bash`; the tree is clean; refresh AC1's log and PNG in `…/evidence/pipeline-token-diet/builder/` for the new head (first line `HEAD=<sha>`, last line `EXIT=0`), and the logs of any other AC whose test file you changed.
- Evidence in `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/fix-1/`; scratch, `TMPDIR` and anything large in `~/.cache/pipeline-token-diet-fixer1/`.
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so, find what grew, and rerun under the cap.
- **Gotchas:** in the Bash tool `grep` is ugrep: use `/usr/bin/grep` (inside `xargs`, `find -exec` or `systemd-run`, `command grep` does not work); `tail -n N`; never `pkill -f`.

## Output contract
- `status`: `ready-for-next-review` or `stopped` (with `stop_reason`);
- `head_sha`, and the fix commits (sha, finding);
- per finding: `valid` or `pushed back`, what you changed, the test or mutant runs that prove it;
- `found_else`;
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
