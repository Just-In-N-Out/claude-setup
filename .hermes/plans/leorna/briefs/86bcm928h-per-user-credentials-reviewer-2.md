# REVIEWER brief, round 2 (full): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, independent REVIEWER, **report only**. Opus 5.5, effort high. You never saw the build, round 1's review or the fix.

Every rule in the round-1 brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-reviewer-1.md`. Read it first. That covers the story summary, skills, what to look for, the sandbox and tool rules, the earlyoom and long-wait rules, Justin's severity scale, the found_else and skill_lessons rules, and the return schema. It is overridden only where this file says something different:

## What's different in round 2
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/review-2/`.
- **Scope: full review of the whole story again.**
  - `from` = base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`, `head` = `0e9659624f6577f6a575303337270d7512c64ded`.
  - Review `git diff 7a83443...0e96596` and everything it touches.
  - If HEAD has moved past 0e96596, stop and report it.
- **Earlier round:** `review-1/review.json` (findings R1-1 to R1-5) and `review-1/report.md`.
- **The fixer's answer to each finding:** `~/.hermes/plans/leorna/evidence/86bcm928h/fixer-1-report.md`. Its commits are a1e5794 (R1-3) and 0e96596 (R1-1 and R1-2). R1-4 and R1-5 are P3 and were left for follow-ups.
- **Check each fix holds.** When a round-1 finding is still open, or the fix broke something, raise it with `"repeats": "R1-<k>"` and a `"new_fact"` of 5+ words when you have one.
- **Look hard at the new Windows launcher** (`application/open_tool_windows.go` and its tests):
  - It must keep the plan's security properties: an absolute executable, the secret in the child environment only, no PATH lookup, no `.cmd`/`.bat`/`.ps1`, no injection.
  - Candidate paths under `%USERPROFILE%` and the npm prefix: think about who can write there, and whether a planted `claude.exe` is a realistic risk on the user's machines or only a deliberate-evasion P3.
  - The `CODEX_MANAGED_BY_NPM=1` env and the arch/triple selection.
  - The AC6 test now copying the test binary to the real default paths: does it clean up, and can it clobber a real install?
- **Judge the fixer's 2 plan deviations** (replacing plan task 5's PowerShell route; the AC6 test rework) in `deviations_ruling`.
- The real tools are installed on this desktop's Windows side (claude.exe 2.1.310, codex 0.164.0). You may run read-only `--version` checks through the resolver. Never launch them with a token, and never change the execution policy or PATH.
- **review.json:** `{"round": 2, "scope": "full", "from": "7a834434d00ec7afae8464f5e7ce6cc17881bb7b", "head": "0e9659624f6577f6a575303337270d7512c64ded", "findings": [...]}`, with ids `R2-<k>`.
  - Self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials --base 7a834434d00ec7afae8464f5e7ce6cc17881bb7b ~/.hermes/plans/leorna/evidence/86bcm928h`.
  - Exit 2 means your file is wrong, so fix it.
- Scratch folder: `~/.cache/86bcm928h-review-2/`. Remove it at the end.

## Return
Same schema as round 1: `{verdict, findings[], deviations_ruling[], ac_status[], found_else[], skill_lessons[]}`. AC8 (live) is `not_run`. End with `MAIN SESSION: check and save these skill_lessons now.`
