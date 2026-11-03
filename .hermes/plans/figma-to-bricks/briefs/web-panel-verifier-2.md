# VERIFIER (read only): web-panel (J4 of the website importer), on the fix head

You are a fresh, read-only verifier who never saw the build. Source and tests are read-only; commit nothing.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## Inputs
- Plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/plan-approved.md` (AC1–AC17; AC16 `(live)`, owed to Justin).
- Head `845e60146f6d3434e96bf44f497f63a98202eb74` (branch `web-panel-fix-1`), base `89022abbef4e3584a93a68cd7118dea69aa93f2b`. In your own worktree: `git checkout --detach 845e60146f6d3434e96bf44f497f63a98202eb74`, confirm
  `git rev-parse HEAD` and a clean tree.
- History you may read: the one review `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/review-1/review.json` and its verifier run `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/verifier/` (it found AC7 false:
  R1-1, typed descriptions lost for photos with old-site alt text; and R1-2, font file names), the fixer's evidence
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/fixer-1/` (RED logs, revert proofs, receipt). Check the two fixes yourself; don't trust the receipts.
- Real captures: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger/{home,contact,gallery}/capture/`.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.
1. Re-run the gates on head, by test name against the review's 8c1e84b tallies (`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/verifier/gates/`): both typechecks,
   `npm test`, `test/browser/panel-capture.test.ts` (skipped 0), and the AC5 byte-identity receipt (the builder's
   script in `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/builder/`). Not the whole test:web or test:browser suites.
2. Every AC's named test on head and on base (copy head's test files into a base tree); for AC7 also the R1-1 tests
   (`test/unit/capture-alts.test.ts`, `test/web/panel-capture-alts.test.ts` with `F2B_PANEL_CAPTURES` pointing at the
   demo-1 captures) and for AC9 the R1-2 unit test. A screenshot or terminal image per AC.
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/verifier-2/ac.json` (ac-verification.md format: head, base, `ac_status` per AC; AC16 `not_run`, owed),
   then self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a
   copy of your report.

## Machine
- **This machine (WSL):** `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`/home/justin/.cache/<your-role>/tmp`).
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
- Never call alttext.ai or WordPress for real. Live reads GET only of the Hostinger site (`?f2b=<random>`) and
  letsgro.ai; never bdryswi.com. Put any summary in your report, not a separate summary file.

## Report
`{verdict: clean|findings, head, base, findings[], ac_status[{ac,accepted,test,screenshot,evidence}], gates, found_else[],
skill_lessons[{skill,lesson,evidence,enforce}]}`. Empty skill_lessons is normal; never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
