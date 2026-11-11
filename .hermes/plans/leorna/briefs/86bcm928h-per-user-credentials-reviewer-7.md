# REVIEWER brief, round 7 (delta, conflict-free bring-main): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, independent REVIEWER, **report only**. You are Opus 5.5 at effort high.

Every rule in the round-1 brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-reviewer-1.md`. Read it first. It is overridden only where this file says something different.

**Load these skills** and say so in your first steps:
- `leorna`
- `engineering-best-practices`
- `requesting-code-review`
- `code-review-practice`

Also read the two `references/repeat-mistakes.md` files if they exist:
- `~/.claude/skills/leorna/references/`
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`

## Scope (delta)
- `from` = `40abddbb3bef5659de72cefb67076026e73dee94`: review-6 found it clean, and it is pushed as PR #33.
- `head` = `eef72c761ad616f50409c1e985e97e039936a772`: "merge: bring main (3f4bad7) into feat/86bcm928h-per-user-credentials". It is local and not pushed.
- Main `3f4bad7` is the merge of PR #34. Its only change is `go.mod` `toolchain go1.27.3` → `go1.27.4`, for GO-2026-6859.
- If HEAD isn't eef72c7, stop and report it.
- Write only into `~/.hermes/plans/leorna/evidence/86bcm928h/review-7/`. Scratch goes in `~/.cache/86bcm928h-review-7/`, removed at the end.

## Check
1. **The merge is honest and conflict-free:**
   - `git merge-tree --write-tree 40abddb 3f4bad7` equals `eef72c7^{tree}`.
   - The only file brought in is `go.mod`.
   - The story's patch is unchanged: `diff(a7839b3..40abddb)` equals `diff(3f4bad7..eef72c7)`.
   - Main brought in nothing else (`git log 40abddb..3f4bad7`).
2. **Go 1.27.4 breaks nothing the story relies on.** Read the fixer's `gates-eef72c7.txt` and `.summary`, and the gate script `fixer-5/gates.sh`. Rerun `make check` and `make audit` yourself with Go 1.27.4 from `~/.local/leorna-toolchain/go1.27.4/bin`, with `GOTOOLCHAIN=local` and an owned TMPDIR under your scratch folder.
3. **Hard rules:**
   - Authorship is Justin Issa <justin@leorna.com>, with no AI attribution lines.
   - The `.github/` diff is empty.
   - GitHub main hasn't moved past 3f4bad7. Check with `gh api repos/LeornaAI/leorna-client/commits/main --jq .sha`.
4. **Justin's instruction:** "do not mention AC8". Leave AC8 out of `ac_status` and the review.

## review.json
- Shape: `{"round": 7, "scope": "delta", "from": "40abddbb3bef5659de72cefb67076026e73dee94", "head": "eef72c761ad616f50409c1e985e97e039936a772", "findings": [...]}`, with ids `R7-<k>`.
- Self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials --base 3f4bad71b3f4cce6b387d167228db167c57c7148 ~/.hermes/plans/leorna/evidence/86bcm928h`. Exit 2 means your file is wrong.
- If a hook stops you writing `report.md`, put the report in your final message.

## Environment
- **Earlyoom:** `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. Run the long tests under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with env assignments quoted.
- **Long waits:** use `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null`. Don't end your turn to wait.

## Return
`{verdict, findings[], ac_status[AC1–AC7], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
