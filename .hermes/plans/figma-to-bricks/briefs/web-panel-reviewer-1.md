# Reviewer + verifier brief: web-panel (J4 of the website importer), the one review

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-panel/review-1/` and `…/web-panel/verifier/`. You never saw the build.
This is the job's one review (Mini pipeline: the reviewer also does the verifier's AC work).

**Justin (2026-11-02): "focus on building and not too much of edge cases that will lead us nowhere."** Report as P0–P2
only what a real site or normal use of the panel would hit: a captured page that converts wrong, a panel flow that
breaks (open a capture, pick Page/Header/Footer, Convert and copy, pictures, fonts, alt text, ticks), a false AC, a
Figma conversion that changes. Unusual inputs nobody will realistically meet are P3 (they go to follow-ups); don't
spend time hunting them.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and `references/testing-pitfalls.md`. Read the
review records and severity scale in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`
("The reviewer's duties", "Records") and the verifier's AC work in
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.

## What to review

- Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-panel/plan-approved.md` (AC1–AC17; AC16 is `(live)`,
  owed to Justin).
- Your worktree starts at `main`: `git checkout --detach 8c1e84b371d466f8e3d0ed4ac47b3b8360976674` and confirm
  `git rev-parse HEAD`. Base: `89022abbef4e3584a93a68cd7118dea69aa93f2b` (wave 1 combined). Diff: `git diff 89022ab..8c1e84b`.
- The builder's evidence (look, don't trust): `~/.hermes/plans/figma-to-bricks/evidence/web-panel/builder/` (per-AC
  `ac*-test.txt`, gates in `gates/`, captures in `captures/`, mutants), ledger `docs/plans/…web-panel…` or
  `.superpowers/sdd/…/progress.md`, HANDOFF's web-panel section. Its rulings R1, R10, R11 are not yet confirmed; a
  ruling is a finding only if it breaks a real page.
- Real captures to try the panel path on: `~/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger/{home,contact,gallery}/capture/`
  and the builder's `captures/`.

## Do

1. Review the diff for real-use bugs (above). For each P0–P2: `file_line`, `claim`, a 5+ word real-use `scenario`.
2. Verifier work: run every AC's named test on head and on base 89022ab (base should fail where the AC is new), re-run
   `npm run check` and the panel's browser file (`test/browser/panel-capture.test.ts`), and compare by test name with
   the builder's tallies. Don't re-run the whole `test:web` suite (the builder ran it: 132/131/1 skip); run only the
   files the diff touches.
3. Write `review-1/review.json` as review-loop.md "Records" says (`"round": 1`, `"scope": "full"`, `"from"`: the base,
   `"head"`: 8c1e84b's full SHA, findings `R1-<k>`), and `verifier/ac.json` with `ac_status` per AC as
   ac-verification.md says (AC16 `owed` to Justin, live).
4. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 89022abbef4e3584a93a68cd7118dea69aa93f2b ~/.hermes/plans/figma-to-bricks/evidence/web-panel` (exit 2 means
   your file is wrong: fix it).

## Rules

- bdryswi.com serves a bot-check page to automated Chrome: don't load it. Live reads only of
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
  Never write to any WordPress site; never call alttext.ai or WordPress for real.
- This machine (WSL) freezes when several Chrome runs overlap. Before any Chrome-using run:
  `until ! pgrep -f "node --test.*test/(browser|web)" >/dev/null; do sleep 20; done`, then one at a time.
  `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wpanel-r1/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`.
- Put any summary in your report, not in a separate summary file.

## Report

`verdict`, the findings one line each, `ac_status` (AC1–AC17: holds / doesn't / owed, one line each), then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
