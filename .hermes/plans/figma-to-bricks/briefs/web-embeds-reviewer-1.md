# Reviewer + verifier brief: web-embeds (J5 of the website importer), the one review

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-embeds/review-1/` and `…/web-embeds/verifier/`. You never saw the build.
This is the job's one review (Mini pipeline: the reviewer also does the verifier's AC work).

**Justin (2026-11-02): "focus on building and not too much of edge cases that will lead us nowhere."** Report as P0–P2
only what a real site would hit: an embedded widget, map or floating extra (chat, call button, reviews, cookie bar)
that a real captured page loses, breaks or doubles in the paste, a script that runs where it shouldn't, a false AC, a
Figma conversion that changes. Unusual inputs nobody will realistically meet are P3 (they go to follow-ups); don't
spend time hunting them.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and `references/testing-pitfalls.md`. Read the
review records and severity scale in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`
("The reviewer's duties", "Records") and the verifier's AC work in
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.

## What to review

- Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md` (AC1–AC13; AC12 and AC13 are `(live)`,
  owed to Justin (AC13 also waits for bdryswi.com's allow-list)).
- Your worktree starts at `main`: `git checkout --detach db801e5a6fad9ee9eb81bcb9e151c6f2147b758a` and confirm
  `git rev-parse HEAD`. Base: `89022abbef4e3584a93a68cd7118dea69aa93f2b` (wave 1 combined). Diff: `git diff 89022ab..db801e5`.
- The builder's evidence (look, don't trust): `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/builder/` (per-AC
  `ac*-test.txt`, gates in `gates/`, captures in `captures/`, mutants), ledger `.superpowers/sdd/…/progress.md`, HANDOFF's web-embeds section. Its rulings are not yet confirmed; a ruling is a
  finding only if it breaks a real page. Task 11 (AC6's part that needs J2's `site.tiers`) was skipped because J2 isn't
  merged: judge AC6 by its unconditional text.
- Real captures to try: `~/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger/{home,contact,gallery}/capture/`
  and the builder's `captures/`.

## Do

1. Review the diff for real-use bugs (above). For each P0–P2: `file_line`, `claim`, a 5+ word real-use `scenario`.
2. Verifier work: run every AC's named test on head and on base 89022ab (base should fail where the AC is new), re-run
   `npm run check` and the test files the diff adds or touches (`test/web/capture-embeds.test.ts`, the new unit files,
   `emit-nested-links`), and compare by test name with the builder's tallies. Don't re-run the whole `test:web` or
   `test:browser` suites (the builder ran them: web 139/138/1 skip; browser same 10 failures as base).
3. Write `review-1/review.json` as review-loop.md "Records" says (`"round": 1`, `"scope": "full"`, `"from"`: the base,
   `"head"`: db801e5's full SHA, findings `R1-<k>`), and `verifier/ac.json` with `ac_status` per AC as
   ac-verification.md says (AC12 and AC13 `owed` to Justin, live).
4. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 89022abbef4e3584a93a68cd7118dea69aa93f2b ~/.hermes/plans/figma-to-bricks/evidence/web-embeds` (exit 2 means
   your file is wrong: fix it).

## Rules

- bdryswi.com serves a bot-check page to automated Chrome: don't load it. Live reads only of
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
  Never write to any WordPress site; never call alttext.ai or WordPress for real.
- Chrome: at most one Chrome job of your own at a time, closed after each step. Runaway memory: SIGTERM, exit 143/137
  or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun
  under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wembeds-r1/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`.
- Put any summary in your report, not in a separate summary file.

## Report

`verdict`, the findings one line each, `ac_status` (AC1–AC13: holds / doesn't / owed, one line each), then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
