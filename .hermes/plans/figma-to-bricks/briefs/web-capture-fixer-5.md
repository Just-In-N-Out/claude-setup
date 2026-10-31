# Fixer brief: web-capture, fix pass 5 (after review round 5)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

`main` has moved on (other sessions' builds), so your agent worktree starts there, not on the story. Put your copy on
the reviewed head without rebasing: `git checkout --detach 8ed231634faa5aa0e959276136ff69ca1dcab30d` then
`git switch -c web-capture-fix-5` (fix pass 4's branch is `web-capture-fix-4`). Fixers don't rebase: your commits go
on top of `8ed2316`, and the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## The finding

Round 5 found the four fix-pass-4 commits clean and raised one P2 outside them; it tripped the review brake and
**Justin chose "Fix it now"** (`review-5/justin.json`). The referee's lines:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-5/referee.txt`; the record `review-5/review.json`; the
reviewer's `bricksfade` probe (Bricks' own rules, the plugin's cta-motion timing), scripts and gates in `review-5/`.
Fix **R5-1**: boxes a Bricks Interaction fades in (Bricks 2.3.9 holds them at opacity 0 via
`:not(.brx-animated)[data-interaction-hidden-on-load]` and `.brx-animated[data-animation*=In]` until the box comes into
view after the animation's delay) are captured at opacity 0, so every call-to-action button the plugin itself makes
pastes invisible (five on the plugin-made home). Undo Bricks' entrance hides from Bricks' own markers, as
`revealOwned` already does for Elementor and AOS, with a fixture built from Bricks' own rules; keep content a site
really shows at partial opacity as it is (ruling F16), and keep closed dropdowns and pop-ups out. **Verify it first**
with `bricksfade` and a live capture of the plugin-made home (the five buttons), fix it test-first as general logic.
R5-2 (two scroll properties still compared: `scroll-axis-lock`, `scroll-target-group`) is a one-line skip-list P3:
add it with its decoy if natural. Other P3s stay follow-ups.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` (the builder's receipts are in
  `evidence/web-capture/builder/gates/`, fix passes 1–4 in `evidence/web-capture/fixer-1/` … `fixer-4/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-5/answers.md`: for R5-1 (and R5-2 if covered), **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
