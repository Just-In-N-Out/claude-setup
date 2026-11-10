# Brief: REVIEWER 3 (delta round: the rebase), story `pipeline-token-diet`

## Role
You are the fresh **delta reviewer 3** for Justin's setup story `pipeline-token-diet`. You never saw the build, the earlier rounds or the rebase. You **only report**: no source changes, no commits, no auto-fixes, no other agents; never write the live `~/.claude`, `~/.hermes`, `~/.codex`, `~/Documents/FigmaToBricksV2`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/review-3/` and your scratch folder `~/.cache/pipeline-token-diet-reviewer3/`.

This is a small round: the story was reviewed clean at `0977104b` (review 2, full) and has since only been rebased onto a newer `main`. Keep the work in proportion.

## Skills to load first (say so in your first steps)
1. `engineering-best-practices`
2. `requesting-code-review`: skip its "independent reviewer subagent" and auto-fix steps.
3. `code-review-practice`

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Head:** `c887b3b4ed19c9198cc0316f2c860f215c672ff0`, on base `b5927606c8a0b9de1e62d4565b4a74d1c43e49b1`. **Previous reviewed head:** `0977104b5fb74d24c45c66711684ad9a5a86881c`, on base `e9f160a28694af1557bd94289b5a25d08e110eb4`.
- **Before you start,** confirm HEAD is `c887b3b4` and `git status --porcelain --untracked-files=all` is empty. If either fails, stop and report.
- **Scope:** what the rebase changed, as the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` says for a rebase: review `git range-diff e9f160a2..0977104b b5927606..c887b3b4`, not `from..head`.
- **What the finisher reports** (check it, don't trust it): 6 of the 7 commits are unchanged by the rebase; commit `a017194f` → `9f42aab6` needed one resolution, in `.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`, the one-line paragraph under "## After MOVE ON": `main` had added a clause inside a parenthesis on that line, the story inserts a sentence about a pure rebase on the same line, and the finisher kept both. In the same commit `references/ac-verification.md` and `figma-to-bricks/SKILL.md` merged automatically. Its files: `…/evidence/pipeline-token-diet/finisher-1/` (`range-diff.txt`, `resolutions.txt`, `rebase.log`).
- **Approved plan** (read-only, for the rules the story's text must state): `…/evidence/pipeline-token-diet/plan-approved.md`, "Justin's answers" and "The chosen set".

## What to decide
1. **The resolution keeps both sides' meaning.** Prove it the way `review-loop.md` describes for a docs-only resolution (rebuild it with `git merge-file -p --diff3` on files saved with `git show <sha>:<path>` into scratch, or apply main's own patch to the old head's file and `cmp` with the new head's file). Nothing of `main`'s edit dropped, nothing of the story's change dropped, no stray conflict marker anywhere in the tree.
2. **The automatic merges are right.** In every file both sides changed since the old base (`git diff --name-only e9f160a2 b5927606` against the story's files), the story's own added and removed lines are the same as before the rebase, and no edit from `main` now contradicts the story's rules or puts back an old model pairing or a replaced rule (the new routing, "asked from round 3", the rebase receipt). Read the changed regions; don't rely on the consistency test alone.
3. **Nothing else changed:** `git diff 0977104b c887b3b4` equals `git diff e9f160a2 b5927606` apart from the resolved line.
4. **The suites still pass on this head** (under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`): `scripts/review-check.test.sh`, `scripts/ac-check.test.sh`, `scripts/pipeline-rules.test.sh`, `scripts/token-report/token-report.test.sh` under `.hermes/skills/autonomous-ai-agents/feature-dispatch/`. No mutation runs are needed this round.

Earlier rounds' P3s (in `…/follow-ups.md`) are not yours; if you meet one again, set `repeats` to its id.

## Severity (Justin's rule; every P0–P2 needs a concrete real-use scenario of 5+ words, otherwise it is P3)
- **P0/P1:** the gate or referee lets unreviewed, unproven or still-buggy code through, a false AC, or a broken existing suite.
- **P2:** a bug or a rule-text contradiction a real agent could plausibly hit or act on, another session's edit lost, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only.

## Your round record (required)
Write `…/evidence/pipeline-token-diet/review-3/review.json` in the format of the live `references/review-loop.md`: round 3, scope `delta`, `from` = `0977104b…` (the previous round's head), `head` = `c887b3b4…`, findings with id `R3-<k>`, severity, `file_line`, `claim`, `scenario`.

Then self-check it with the **live** referee and save its output as `review-3/referee.txt`:
`bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/pipeline-token-diet --base b5927606c8a0b9de1e62d4565b4a74d1c43e49b1 ~/.hermes/plans/claude-setup/evidence/pipeline-token-diet`

## Desktop
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if it was, say so and rerun under the cap.
- **Gotchas:** in the Bash tool `grep` is ugrep: use `/usr/bin/grep`; `tail -n N`; never `pkill -f`. `/tmp` is a shared RAM tmpfs: scratch and `TMPDIR` in `~/.cache/pipeline-token-diet-reviewer3/`.

## Output (final message, at most 40 lines)
- `verdict`: `clean` (no P0–P2) or `changes-needed`.
- `findings[{id, severity, file_line, scenario, claim, evidence, fix}]`, `p3[]`.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC6 (AC6: `accepted: false, not_run: "live: …"`).
- `referee_last_line`, `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
