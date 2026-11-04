# Role: reviewer + verifier (Mini round 1, report only): web-human-check

You are a fresh reviewer who never saw the build. Review only: change no source or test, commit nothing, start no
agents. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** one review per job; report
as P0–P2 only bugs a real site or normal use hits (Justin pressing "I am human" on his client's WordPress.com site, a
normal capture, the panel's address box, `npm run capture --all`), each with a concrete real-use scenario. Edge cases go
in as P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs

- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check/plan-approved.md`
  (AC1–AC8; AC8 `(live)`, Justin's: `not_run`).
- Head `9bb30d436b5511d61c7db0d1a029877a8077a9a3` (branch `web-human-check-build`), base `70be9c09bee3eb2384399fe19972a0e35cddff2a`
  (main, Build 2026-11-03.2). In your own worktree: `git checkout --detach 9bb30d436b5511d61c7db0d1a029877a8077a9a3`,
  confirm `git rev-parse HEAD` and a clean `git status --porcelain --untracked-files=all`. Review `git diff 70be9c09...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check/builder/`.

**Hard rule to check hardest:** nothing may hide that the browser is automated (no
`--disable-blink-features=AutomationControlled`, no patched `navigator.webdriver`, no new user agent, no stealth
script, no product code that clicks, types into or solves a check). Any such thing is a P0.

## Work

Load `requesting-code-review`, `code-review-practice` and `security-best-practices`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`
(the `review.json` format) and `references/ac-verification.md` (the verifier's AC work and `ac.json` format).
1. **Review** the whole diff for real bugs: the check rule (false positives on normal sites: would an ordinary site's
   page ever open a window?), the wait and its exits (Ctrl+C, closed window, timeout: Chrome always closed, the helper
   takes the next capture), the switch to the visible browser, downloads through the tab, `--all`, the driver's
   `TabClosed` change (it affects every driver user), the panel lines, security of the helper (still 127.0.0.1, pairing
   code, no site writes). Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check/review-1/review.json`.
2. **Verify every AC** (the verifier's work): each AC's named test on head and on base (a base tree from `git archive -o
   <scratch>/base.tar 70be9c09`, then `tar -xf`, with head's test files and the test-only modules they import copied in),
   a terminal image per AC, `HEAD=` first and `EXIT=` last in each log, skipped 0. Gates by test name against base: both
   typechecks, `npm run check`, the five Figma replays byte-identical, `test/web/human-check.test.ts` and the pinned web
   files (`capture-not-the-page`, `helper-capture`, `capture-cli`); not the whole `test:web`/`test:browser` (the
   builder's receipts cover them; spot-check one compare file). Write
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check/verifier/ac.json` (AC8 `not_run`, owed), then
   self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a copy.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/whc-r/tmp`); Chrome found by itself (`~/.cache/chrome-for-testing/chrome-f2b`) or `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`. One Chrome job of your own at a
  time, closed after each step. Don't run the opt-in real-window test unless you need to (`F2B_VISIBLE_CHROME=1`); close
  any window you open. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; no redirects or the
  bare word `source` in a command. Never load bdryswi.com; live reads (GET only) only of the Hostinger site (`?f2b=`) and
  letsgro.ai; never write to any WordPress site. Put any summary in your report.

## Report

`{verdict: clean|findings, head, base, findings[{id,severity,claim,scenario,evidence}], ac_status[{ac,accepted,test,
screenshot,evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Empty skill_lessons is
normal; never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
