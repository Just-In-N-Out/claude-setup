# Role: reviewer + verifier (Mini round 1, report only): web-human-reload

You are a fresh reviewer who never saw the build. Review only: change no source or test, commit nothing, start no
agents. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** one review per job; report
as P0–P2 only bugs a real site or normal use hits (Justin pressing "I am human" on his client's WordPress.com site, a
normal capture, the panel's address box, `npm run capture --all`), each with a concrete real-use scenario. Edge cases go
in as P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs

- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload/plan-approved.md`
  (AC1–AC8; AC8 `(live)`, Justin's: `not_run`). The job: (A) switch points and the title come from the passed page,
  never a check page (a search runs again in the browser that passed); (B) a pass counts after 2 s of quiet, and a load,
  freeze, search or range read cut by the page's own navigation settles and reads again (3 tries, then one plain line).
- Head `9b163e72be0e041bf618a7d946799f6063e9b37c` (branch `web-human-reload-build`), base `b62b61b5`
  (main, Build 2026-11-04.2; the branch was built on `39d96c98` and rebased: receipts in `builder/rebase/`). In your own worktree: `git checkout --detach 9b163e72be0e041bf618a7d946799f6063e9b37c`,
  confirm `git rev-parse HEAD` and a clean `git status --porcelain --untracked-files=all`. Review `git diff b62b61b5...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload/builder/`.

**Hard rule to check hardest:** nothing may hide that the browser is automated (no
`--disable-blink-features=AutomationControlled`, no patched `navigator.webdriver`, no new user agent, no stealth
script, no product code that clicks, types into or solves a check). Any such thing is a P0.

## Work

Load `requesting-code-review`, `code-review-practice` and `security-best-practices`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`
(the `review.json` format) and `references/ac-verification.md` (the verifier's AC work and `ac.json` format).
1. **Review** the whole diff for real bugs a real capture hits: does every normal site (no check) still capture as on
   main (the 2 s quiet, the retries, the RELOADED note)? **Weigh the builder's ruling R1 (HANDOFF):** a load cut by a
   page's own reload with no check met gets the RELOADED note, which makes the helper's job end "Not the page itself"; is
   that a real-use regression against AC4's "captured instead of failing" for ordinary sites that reload once (a
   cookie-consent or locale redirect)? Also: a second check at a phone range, the search run again, Ctrl+C / closed
   window still close Chrome, nothing hides automation (P0). Write
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload/review-1/review.json`.
2. **Verify every AC** (the verifier's work): each AC's named test on head and on base (a base tree from `git archive -o
   <scratch>/base.tar b62b61b5`, then `tar -xf`, with head's test files and the test-only modules they import copied in),
   a terminal image per AC, `HEAD=` first and `EXIT=` last in each log, skipped 0. Gates by test name against base: both
   typechecks, `npm run check`, the five Figma replays byte-identical, `test/web/human-reload.test.ts`,
   `test/web/human-check.test.ts` and the pinned web files (`capture-not-the-page`, `helper-capture`, `capture-cli`); not the whole `test:web`/`test:browser` (the
   builder's receipts cover them; spot-check one compare file). Write
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload/verifier/ac.json` (AC8 `not_run`, owed), then
   self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a copy.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/whr-r/tmp`); Chrome found by itself (`~/.cache/chrome-for-testing/chrome-f2b`) or `CHROME_PATH` =
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
