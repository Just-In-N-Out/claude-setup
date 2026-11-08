# Role: reviewer (round 3, fix commits only, report only): capture-speed

You are a fresh reviewer who never saw the build (Opus 5.5, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them by absolute path or `git show`). Never load bdryswi.com; never write to any WordPress site; no logins. Nothing may
hide that the importer's Chrome is automated (repo CLAUDE.md).

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run capture -- <a real site>`, with or without an "I am human" check, on home wifi
that may drop; then `npm run site` / `site:check` on that capture; Figma designs converting as before), each with a
concrete real-use scenario. Edge cases go in as P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/plan-approved.md`
  (AC5: a failed page load is tried again, then one plain line).
- Branch `capture-speed-build` (worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a37633bdd2f67cfdd`,
  read-only), head `e455130b1149b8f087409e4927d50a3c145a5266`, base `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (`main`).
  In your own worktree: `git checkout --detach e455130b1149b8f087409e4927d50a3c145a5266`, confirm `git rev-parse HEAD`
  and a clean `git status --porcelain --untracked-files=all`.
- **Scope (round 3): only the fix commits since round 2's head and what they touch:** `git diff e6437fb7004876bcfa25e5ed011ab420dcdca9d8..HEAD`
  (`563901bb` fix + tests, `6b254b5e` HANDOFF, `e455130b` ledger), plus the code paths they call or change
  (`src/web/lost.ts`, `session.ts` `openSession`/`down()`, `discover`, the replay's `answerFrom`).
- Round 2 (`evidence/capture-speed/review-2/review.json`) found R2-1 P2: a page load answered from the kept page never
  fails navigation, so a dropped connection during later ranges went unseen. Fixer 2's rule (`lostConnection`): while a
  page load runs, a request counts like a failed navigation when it ends in a network `net::ERR_` (disconnected, name
  not resolved, connection_*, network changed, address unreachable, timed out), goes to the site's own host (typed host
  or main-frame document host, www. aside), and is a Document, Stylesheet, Script, Font, Image or Media; disconnected
  and network-changed count from any request; other sites, subdomains, Fetch/XHR, aborted/blocked and 404s never count.
  Receipts (read, don't trust): `evidence/capture-speed/fixer-2/`.
- Check: does the fix catch a real wifi drop; can it stop a capture of a healthy real site (a site whose pictures live
  on its own host but one fails, a slow font timing out, `Network.enable` changing what is captured or slowing reads);
  does the watcher reset per load, release listeners, and work with several windows and the human check; do the tests
  fail without the fix.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the `review.json` format).
1. Review the scoped diff for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/review-3/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373 /home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cs-r3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after.
  The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
