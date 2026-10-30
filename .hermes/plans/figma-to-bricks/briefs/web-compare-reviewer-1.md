# Reviewer brief: web-compare, review round 1 (full)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-1/`. You never saw the build.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (and `references/testing-pitfalls.md`,
`references/rendering-validation.md`). Read the review mechanics and Justin's severity scale:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties",
"Records") and the `review-fix-cadence` skill.

## What to review

- Job: `web-compare` (J0 of the website importer): the compare tool `npm run compare` / `compare()`, the renderer's
  opt-in `bricksOrder`, `Page.cdp`, `test:web`.
- Approved plan (the contract): `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` (11 ACs; the
  ⭐ answers were taken under Justin's away grant). The proposal behind it:
  `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` (§7, §11 J0).
- Code: your agent worktree starts at `main`. Run `git checkout --detach 6f4761664de8d1d1c3acda6a7dd5bc1651086f1f`
  (branch `worktree-agent-ac72814ffff3e6cce`). **Full round:** `from` = the story base
  `3ea33bba9cf413d929923992431e0145bac07477` (merge-base with `main`; `main` moved to build 29.2 after planning, so the
  builder cherry-picked the plan onto it: read the plan's `dea6296` as this base). Review `git diff 3ea33bb...6f47616`
  (20 commits).
- The builder's evidence (claims to check, not to trust):
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/builder/` (per-AC test runs, `gates/README.md`, noise floor,
  its rulings R9–R14 in the ledger `.superpowers/sdd/2026-10-29-web-compare/progress.md`).

## What matters most

- **It is the oracle every later importer job is judged by.** A compare that misses a real difference (pairs the wrong
  boxes, mutes too much as noise, a freeze that hides a change, a tolerance that swallows a visible defect) makes every
  later AC false. A compare that cries wolf blocks every job. Probe both, with your own small fixture pages.
- General logic only (repo CLAUDE.md): nothing keyed on bdryswi.com or one site's names, classes or sizes.
- The renderer's default output must stay byte-identical; `src/` must be untouched.
- Tests that can't fail, AC tests that don't prove their AC, and gate claims you can't reproduce.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  a browser/web run counts only with `skipped 0`. Live reads of public sites only (GET).

## Output

1. `review-1/review.json` exactly as `review-loop.md` "Records" says: `"round": 1`, `"scope": "full"`, `"from":
   "3ea33bba9cf413d929923992431e0145bac07477"`, `"head": "6f4761664de8d1d1c3acda6a7dd5bc1651086f1f"`, findings
   `R1-<k>` with severity P0–P3, `file_line`, `claim`, and a 5+ word real-use `scenario` for every P0–P2. Empty
   findings when clean.
2. Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
   worktree> --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-compare`;
   exit 2 means your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (each AC1–AC11: holds / doesn't / unproven, one
   line), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` is `none` or a one-line
   check proposal; empty is normal; never edit skills or memory), ending with:
   `MAIN SESSION: check and save these skill_lessons now.`
