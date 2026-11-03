# Reviewer + verifier brief: web-address (type a website address in the plugin panel), the one review

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-address/review-1/` and `…/web-address/verifier/`. You never saw the build.
This is the job's one review (Mini pipeline: the reviewer also does the verifier's AC work).

**Justin (2026-11-02): "focus on building and not too much of edge cases that will lead us nowhere."** Report as P0–P2
only what normal use would hit: typing an address in Figma desktop, starting the helper with `npm run capture:serve`,
pairing, progress, the capture opening in the capture box, Convert and copy; and any real security hole in the helper (a
local server that reads websites on request: anything that lets a web page or another program on the PC use it without
the pairing code, read local files, or reach WordPress), a false AC, a Figma conversion that changes. Unusual inputs nobody will realistically meet are P3 (they go to follow-ups); don't
spend time hunting them.

**Skills:** load `requesting-code-review`, `code-review-practice` and `security-best-practices` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and `references/testing-pitfalls.md`. Read the
review records and severity scale in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`
("The reviewer's duties", "Records") and the verifier's AC work in
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.

## What to review

- Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-address/plan-approved.md` (AC1–AC13; AC13 is `(live)`,
  owed to Justin (his run in Figma desktop on the Windows desktop)).
- Your worktree starts at `main`: `git checkout --detach 71006122cd8396f3efd803efca9762ee0c7d675a` and confirm
  `git rev-parse HEAD`. Base: `c2f6a160f533a8912727e8fcc4cc9ad5255708e7` (the panel's head). Diff: `git diff c2f6a16..7100612`.
- The builder's evidence (look, don't trust): `~/.hermes/plans/figma-to-bricks/evidence/web-address/builder/` (per-AC
  `ac*-test.txt`, gates in `gates/`, captures in `captures/`, mutants), ledger `.superpowers/sdd/…/progress.md`, HANDOFF's web-address section. Its rulings R10–R15 are not yet confirmed; a ruling is
  a finding only if it breaks normal use. The builder wrote the helper command and the address box before their tests
  (its report says how it compensated: a RED on an archive without the box, mutations M9–M12): check those tests can fail.
- Real captures to compare with: `~/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger/{home,contact,gallery}/capture/`
  and the builder's `captures/`.

## Do

1. Review the diff for real-use bugs (above). For each P0–P2: `file_line`, `claim`, a 5+ word real-use `scenario`.
2. Verifier work: run every AC's named test on head and on base c2f6a16 (base should fail where the AC is new), re-run
   `npm run check` and the test files the diff adds or touches (`test/browser/panel-address.test.ts`, `test/unit/web-helper-*.test.ts`,
   `test/unit/web-address-scope.test.ts` with `F2B_STORY_BASE=c2f6a16`, `test/web/helper-*.test.ts`, and the panel's
   existing browser files `panel.test.ts`, `panel-google-fonts.test.ts`), plus `dist/code.js` identical to base (AC12), and compare by test name with the builder's tallies. Don't re-run the whole `test:web` or
   `test:browser` suites .
3. Write `review-1/review.json` as review-loop.md "Records" says (`"round": 1`, `"scope": "full"`, `"from"`: the base,
   `"head"`: 7100612's full SHA, findings `R1-<k>`), and `verifier/ac.json` with `ac_status` per AC as
   ac-verification.md says (AC13 `owed` to Justin, live).
4. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base c2f6a160f533a8912727e8fcc4cc9ad5255708e7 ~/.hermes/plans/figma-to-bricks/evidence/web-address` (exit 2 means
   your file is wrong: fix it).

## Rules

- bdryswi.com serves a bot-check page to automated Chrome: don't load it. Live reads only of
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
  Never write to any WordPress site; never call alttext.ai or WordPress for real.
- Chrome: at most one Chrome job of your own at a time, closed after each step. Runaway memory: SIGTERM, exit 143/137
  or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun
  under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/waddr-r1/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`.
- Put any summary in your report, not in a separate summary file.

## Report

`verdict`, the findings one line each, `ac_status` (AC1–AC13: holds / doesn't / owed, one line each), then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
