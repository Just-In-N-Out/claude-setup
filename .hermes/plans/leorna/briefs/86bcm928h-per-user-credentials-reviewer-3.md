# REVIEWER brief, round 3 (delta): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, independent REVIEWER, **report only**. Opus 5.5, effort high. You never saw the build, earlier reviews or the fixes.

Every rule in the round-1 brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-reviewer-1.md`. Read it first. That covers the story summary, skills, the security focus, the sandbox and tool rules, earlyoom and long waits, Justin's severity scale, found_else and skill_lessons, and the return schema. It is overridden only where this file says something different:

## What's different in round 3
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/review-3/`. Scratch folder: `~/.cache/86bcm928h-review-3/`, removed at the end.
- **Scope: delta.**
  - `from` = the previous round's head `0e9659624f6577f6a575303337270d7512c64ded`.
  - `head` = `1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2`.
  - Review the fix commit `git diff 0e96596..1f98596` (commit 1f98596) and what it touches.
  - Anything else you notice outside the fix counts as P3.
  - If HEAD has moved past 1f98596, stop and report it.
- **Earlier records:**
  - round 1: `review-1/review.json` + `report.md`, and `fixer-1-report.md`
  - round 2: `review-2/review.json` + `report.md`, and the fixer's answer to each finding in `fixer-2-report.md`
- **Fixer's answers:** R2-1 (P2) fixed, R2-2 and R2-3 (P3) folded in, R2-4 to R2-6 (P3) left for follow-ups.
  - Judge whether each fix holds.
  - When a P0–P2 fix doesn't hold, raise it again at its severity with `"repeats": "R2-<k>"`, plus a `"new_fact"` of 5+ words when you have one.
- **Three trees per probe:** where you probe behaviour, run it on base `7a83443`, the previous head `0e96596` and the head `1f98596`. That tells a regression this fix caused apart from an earlier finding left open.
- **Look hard at the new resolution code** (`npmPrefixes`, the npmrc parsing, `NVM_SYMLINK` / Scoop / WinGet / standalone-Codex candidates, `ToolNotFoundError` and the OpenTool message):
  - It must still give an absolute `.exe` only, checked with `os.Stat` at each Start: no PATH, no `.cmd`/`.bat`/`.ps1`, no PowerShell, nothing executed to find a prefix.
  - The secret only in the child environment.
  - Env-var expansion in npmrc (`${VAR}`): can it point anywhere unsafe, and can a relative or UNC prefix slip through?
  - The not-found message: no secret, no token-holding path.
  - The standalone-Codex-first order.
  - Each cited source: check a sample of them against the installed files on this desktop's Windows side, or against upstream through `gh api 'repos/<o>/<r>/contents/<path>?ref=<tag>' --jq .content | base64 -d`. WebFetch refuses raw.githubusercontent.com.
- The real tools are installed on the Windows side (claude.exe 2.1.310, codex 0.164.0). Read-only `--version` through the resolver is allowed. Never launch them with a token, and never change the execution policy or PATH.
- **review.json:** `{"round": 3, "scope": "delta", "from": "0e9659624f6577f6a575303337270d7512c64ded", "head": "1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2", "findings": [...]}`, with ids `R3-<k>`.
  - Self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials --base 7a834434d00ec7afae8464f5e7ce6cc17881bb7b ~/.hermes/plans/leorna/evidence/86bcm928h`.
  - Exit 2 means your file is wrong, so fix it.

## Return
Same schema as round 1: `{verdict, findings[], ac_status[], found_else[], skill_lessons[]}`. AC8 (live) is `not_run`. End with `MAIN SESSION: check and save these skill_lessons now.`
