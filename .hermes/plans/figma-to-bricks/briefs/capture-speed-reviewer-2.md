# Role: reviewer (Full round 2, report only): capture-speed

You are a fresh reviewer who never saw the build (Opus 5.5, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them by absolute path or `git show`). Never load bdryswi.com; never write to any WordPress site; no logins. Nothing may
hide that the importer's Chrome is automated (repo CLAUDE.md).

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** one review per job; report as
P0–P2 only bugs a real site or normal use hits (`npm run capture -- <a real site>`, with or without an "I am human"
check, on home wifi that may drop; then `npm run site` / `site:check` on that capture; Figma designs converting as
before), each with a concrete real-use scenario. Edge cases go in as P3 (follow-ups). A P0–P2 with no concrete real-use
scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/plan-approved.md`
  (AC1–AC11; AC11 live, Justin's). The job: the capture asks Chrome's matched styles once per element and derives the
  rest from descendants (same capture, ~4x fewer asks), reads up to 4 width ranges side by side in separate windows
  (`--windows`), asks the site for the page once per kind of visitor (kept page replayed, public addresses only), loads a
  failed page again in the same tab and stops with one plain line when the connection stays down, asks "I am human" at
  most once per kind, prints a `Took …` line; web-capture-steady's two commits folded in.
- Branch `capture-speed-build` (builder's worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a37633bdd2f67cfdd`,
  read-only), head `e6437fb7004876bcfa25e5ed011ab420dcdca9d8`, base `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (`main`,
  Build 2026-11-08.1, elementor-map merged). In your own worktree: `git checkout --detach e6437fb7004876bcfa25e5ed011ab420dcdca9d8`, confirm
  `git rev-parse HEAD` and a clean `git status --porcelain --untracked-files=all`. Review `git diff 7ff9ba4a...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/builder/`.
  Its deviations from the plan (in HANDOFF "Rulings"): `lang` dropped from the safe-attribute list; a page with no link
  to another page of its site is never kept; only public-address pages are replayed (Local Network Access); the
  `inOrder` leak fix; AC1 compares pictures by pixels with a tolerance; AC6 `passFor: 3`; no extra `about:blank` tab.
  Judge whether each is right for a real site.
- Round 1 (`evidence/capture-speed/review-1/review.json`) found R1-1 (other windows raised over a window waiting for a
  person) and R1-2 (`PageUnreachable` not stopping `--all` with one plain line); fixer 1 rebased onto main (one HANDOFF
  conflict) and fixed both (`aba4ed45`, `178a9a6a`; receipts `evidence/capture-speed/fixer-1/`). Review the whole story
  again, and check those two fixes hold (e.g. `personFree` can't deadlock a capture, every wait releases).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (Access, "Where a capture's minutes go"), the repo `CLAUDE.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the `review.json` format).
1. Review the whole diff for real bugs: a capture that differs from base on a real page (the derive-from-descendants
   step, shadow/pseudo rules), windows racing or leaving Chrome open, a kept page replayed to the wrong kind of visitor or
   holding a check page, a retry that loops or hides a real failure, the human check asked more than it should or never
   ending, the leak, tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373 /home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cs-r2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after.
  The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  4-window runs 6G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
