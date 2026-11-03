# VERIFIER (read only): web-embeds (J5 of the website importer), on the fix head

You are a fresh, read-only verifier who never saw the build. Source and tests are read-only; commit nothing.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## Inputs
- Plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md` (AC1–AC13; AC12 and AC13 `(live)`, owed to Justin; AC6's part needing J2's `site.tiers` was skipped, judge AC6 by
  its unconditional text).
- Head `5e3fea8efa923deaa046725db5bf20b7725bbde4` (branch `web-embeds-fix-1`), base `89022abbef4e3584a93a68cd7118dea69aa93f2b`. In your own worktree: `git checkout --detach 5e3fea8efa923deaa046725db5bf20b7725bbde4`, confirm
  `git rev-parse HEAD` and a clean tree.
- History you may read: the one review `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/review-1/review.json` and its verifier run `…/web-embeds/verifier/` (AC1–AC11 held;
  three real bugs: R1-1 a player frame built by a page's own script pasted empty, R1-2 lazy-loaded frames pasted as
  about:blank, R1-3 boxes a site's script reveals pasted invisible), the fixer's evidence `…/web-embeds/fixer-1/` (RED
  logs, mutants, live shots). Check the three fixes yourself; don't trust the receipts.
- Real captures: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger/{home,contact,gallery}/capture/`.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.
1. Re-run the gates on head, by test name against the review's db801e5 tallies (`…/web-embeds/verifier/gates/`): both
   typechecks, `npm test`, the capture test files the fix touched (`test/web/capture-embeds`, `-floating`, `-file`,
   `-shown`, `-wakers`, `-entrances`), AC10's byte-identity receipt (the builder's `scripts/base-vs-head.ts`) and AC11's
   live check on fresh GET-only captures (`scripts/live-embeds.sh`). Not the whole test:web or test:browser suites.
2. Every AC's named test on head and on base 89022ab (copy head's test files and the test-only modules they import
   into a base tree), plus the R1-1/R1-2/R1-3 tests. A screenshot or terminal image per AC.
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/verifier-2/ac.json` (ac-verification.md format: head, base, `ac_status` per AC; AC16 `not_run`, owed),
   then self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a
   copy of your report.

## Machine
- **This machine (WSL):** `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`/home/justin/.cache/wembeds-<role>/tmp`).
  Chrome: run at most one Chrome job of your own at a time and close Chrome after each step (Justin lifted the shared
  slots; if the main session sends "back to N slots", hold one of `~/.cache/f2b-chrome.lock`, `-2`, `-3`, first N only).
- **Runaway memory (global CLAUDE.md "Windows Desktop: Runaway Memory"):** a command that dies with SIGTERM, exit 143/137
  or "Killed" may be an earlyoom kill, not a test result: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if killed, say so, find what grew, and
  rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Mutation runs always use that cap.
- Worktree guard: write multi-step scripts with Write and run `bash <script>` in their own call; long runs with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`; git commands as separate plain calls; `node --test` options go
  before file paths; a command holding the bare word `source` is refused. For a base run, copy head's test files into a
  base tree (`git archive -o <scratch>/base.tar 89022ab` then `tar -xf` in separate calls).
- Never write to any WordPress site; never call alttext.ai. Live reads GET only of the Hostinger site (`?f2b=<random>`) and
  letsgro.ai; never bdryswi.com. Put any summary in your report, not a separate summary file.

## Report
`{verdict: clean|findings, head, base, findings[], ac_status[{ac,accepted,test,screenshot,evidence}], gates, found_else[],
skill_lessons[{skill,lesson,evidence,enforce}]}`. Empty skill_lessons is normal; never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
