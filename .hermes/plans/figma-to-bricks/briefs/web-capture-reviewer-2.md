# Reviewer brief: web-capture, review round 2 (full)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-2/`. You never saw the build.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (and `references/testing-pitfalls.md`,
`references/rendering-validation.md`, `references/core-constraints.md`). Read the review mechanics and Justin's
severity scale: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's
duties", "Records") and the `review-fix-cadence` skill.

## What to review

- Job: `web-capture` (J1 of the website importer): `npm run capture -- <address>` reads a live page in headless Chrome
  and writes a capture file (a Snapshot with `source: "web"`) that the plugin's unchanged back half converts.
- Approved plan (the contract): `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md` (14 ACs; the ⭐
  answers and rulings R1–R10 were taken under Justin's away grant). The proposal behind it:
  `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` (§2–§4, §10, §11 J1).
- Code: your agent worktree starts at `main`. Run `git checkout --detach 519dab4f5ca94d14ddbf68b05aac4c3df517257f`
  (branch `worktree-agent-a5c3517dbdc6d2bb8`). **Full round:** `from` = the story base
  `3ea33bba9cf413d929923992431e0145bac07477` (merge-base with `main`; the builder rebased onto it, so read the plan's
  `dea6296` as this base). Review `git diff 3ea33bb...519dab4` (32 commits).
- The builder's evidence (claims to check, not to trust):
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/builder/` (per-AC runs, `gates/`, `mutants/`, live captures in
  `corpus/` and `corpus-blocked/`), its rulings B1–B16 in the ledger `.superpowers/sdd/2026-10-29-web-capture/progress.md`.

## What matters most

- **Every later importer job builds on this format.** A capture that records the wrong layer shape, sizes, text runs,
  stretchy values or switch points makes every paste wrong in ways later jobs can't see. Probe with your own small
  fixture pages: different builds of the same look, wrappers, grids, absolute boxes, text with mixed runs, fonts that
  fail, lazy pictures, pages that change after load.
- **Architecture** (repo CLAUDE.md, AC8): `src/web/` is Node-only and never imported by `src/core|plugin|shared|ui` or
  bundled; Figma conversions must stay byte-identical; no stage edits another's output; schema additions stay
  additive (old debug files still load).
- **General logic only:** nothing keyed on one site's names, ids, classes, texts or sizes; site lists only in
  `corpus/web.json`. Readers for Elementor/Bricks must detect by structure, not by one site.
- **Safety:** the ownership question (AC13) can't be skipped silently; captures write only where told; no writes to any
  site.
- Tests that can't fail, AC tests that don't prove their AC, gate claims you can't reproduce, and the TDD gaps the
  builder disclosed.
- **bdryswi.com now serves a bot-check page to automated Chrome. Don't load it.** Never try to hide automation. AC14's
  bdryswi.com part is blocked on Justin allow-listing the capture; judge AC14 on the two other sites and the evidence,
  and say what is owed. Other live reads: the plugin-made Bricks site
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  a browser/web run counts only with `skipped 0`.

## Output

1. `review-2/review.json` exactly as `review-loop.md` "Records" says: `"round": 2`, `"scope": "full"`, `"from":
   "3ea33bba9cf413d929923992431e0145bac07477"`, `"head": "519dab4f5ca94d14ddbf68b05aac4c3df517257f"`, findings
   `R2-<k>` with severity P0–P3, `file_line`, `claim`, and a 5+ word real-use `scenario` for every P0–P2. Empty
   findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-capture`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (each AC1–AC14: holds / doesn't / unproven, one
   line), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
   proposal; empty is normal; never edit skills or memory), ending with:
   `MAIN SESSION: check and save these skill_lessons now.`

## Round 2 specifics (read these before reviewing)

- **Round 2 is still a full review of the whole story** (Justin's Full pipeline: rounds 1 and 2 both review it all):
  `git diff 3ea33bb...519dab4`; `review.json` with `"round": 2`, `"scope": "full"`, `"from":
  "3ea33bba9cf413d929923992431e0145bac07477"`, `"head": "519dab4f5ca94d14ddbf68b05aac4c3df517257f"`, ids `R2-<k>`, in
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-2/`. `main` has since moved to `61bb5fc` (build 29.3,
  header-bar, another session); the story's base stays `3ea33bb` (no rebase inside the loop).
- **Earlier round:** `evidence/web-capture/review-1/review.json` (1 P1, 12 P2, 6 P3), the referee's lines in
  `review-1/referee.txt`, and the fixer's answers `evidence/web-capture/fixer-1/answers.md` (all 13 fixed; rulings
  F1–F11 in the ledger; format additions `web.position: "fixed"`, `web.unread`, a `lands` address in
  `corpus/web.json`). Judge each fix and each ruling; when a finding is the same defect as a round-1 one, set
  `"repeats": "R1-<k>"` and a 5+ word `"new_fact"` when you have one. Round-1 P3s are recorded follow-ups: raise one
  again only with a new fact that makes it P2.
- Probe the fixes the way round 1 found them: same-look/different-build pages and changes to facts no fixed list
  names (the reviewer's probe sites are in `review-1/probe/`).
