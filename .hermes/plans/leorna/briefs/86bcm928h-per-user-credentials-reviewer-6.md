# REVIEWER brief, round 6 (delta, record commit): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, independent REVIEWER, **report only**. You are Opus 5.5 at effort high. You never saw the build, the earlier reviews or the fixes.

Every rule in the round-1 brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-reviewer-1.md`. Read it first. It is overridden only where this file says something different.

**Load these skills** and say so in your first steps:
- `leorna`
- `engineering-best-practices`
- `requesting-code-review`
- `code-review-practice`

Also read `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` if they exist.

## What's different in round 6
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/review-6/`. Scratch goes in `~/.cache/86bcm928h-review-6/`, removed at the end.
- **Scope:** delta.
  - `from` = `0af447184c884a7e6d74efb4fb98909143e8d2d3`, the head review-5 found clean, which is now pushed as PR #33.
  - `head` = `40abddb` (get the full SHA with `git rev-parse 40abddb`).
  - It is a local, unpushed record commit: "docs(86bcm928h): record per-user integration credentials (client PR #33)".
  - It changes `PROJECT_MEMORY.md` (+11, a line under "What is in the merged code") and `README.md` (−1, deleting the AC8 row of the AC table).
  - If HEAD isn't 40abddb, stop and report it.
- **Justin's instruction (2026-11-11):** "do not mention AC8". Deleting the README's AC8 row is that instruction, so don't report the deletion itself as a finding.
- **What to check:**
  - The new `PROJECT_MEMORY.md` text is true to head's code and READMEs. Check each claim against the code:
    - the token is kept only in Windows Credential Manager
    - configs name the variable
    - Open passes the token only in the started tool's environment
    - Reconnect on 401 or a changed server
    - sign-out deletes the company's tokens
    - SQLite migration **10** with `integration_needs` and `integration_connections`
    - the README section name it cites
  - It follows the file's existing style: placement, wrapping, and PR references like `client PR #<n>`.
  - It names other stories by PR number or title only, never by a bare card ID other than 86bcm928h.
  - It holds no secret, server domain or URL, or tenant ID, and no AC8 or "owed/live" wording.
  - The README table still reads correctly without the row, with nothing dangling that refers to AC8.
  - `git grep -n 'AC8'` over non-vendor tracked files at head.
  - Authorship: Justin Issa <justin@leorna.com>, no AI attribution lines.
  - `make check` and the UI tests pass on 40abddb. The finisher's log is `gates-pr-0af4471.txt`. Rerun `make check` yourself if cheap.
- **review.json:** `{"round": 6, "scope": "delta", "from": "0af447184c884a7e6d74efb4fb98909143e8d2d3", "head": "<full 40abddb sha>", "findings": [...]}`, with ids `R6-<k>`.
  - Self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials --base a7839b3af664efcfa59eb1ed3fe276ec1262a4de ~/.hermes/plans/leorna/evidence/86bcm928h`.
  - Exit 2 means your file is wrong; fix it.
- **Report:** if a hook stops you writing `report.md`, put the whole report in your final message.
- **Earlyoom check:** `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`.

## Return
Same schema as round 1: `{verdict, findings[], ac_status[], found_else[], skill_lessons[]}`.
- In `ac_status`, carry AC1–AC7 from the verifier and auditor runs on 0af4471. The commit touches only docs.
- Leave AC8 out of the `ac_status` list. Justin's instruction is not to mention it in what goes out.

End with `MAIN SESSION: check and save these skill_lessons now.`
