# BLIND AC AUDITOR (read only): web-panel (J4 of the website importer)

Independently prove the approved acceptance criteria. You have never seen a builder, reviewer, fixer or verifier report.
Stay blind: never open anything under `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/` except `plan-approved.md` and your own `auditor/` folder, nor HANDOFF,
ledgers or session notes. Source and tests are read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/plan-approved.md` (AC1–AC17; AC16 is `(live)`, owed to Justin: mark it `not_run`). Use each exact
  test name the plan gives.
- Head `845e60146f6d3434e96bf44f497f63a98202eb74`, base `89022abbef4e3584a93a68cd7118dea69aa93f2b`, your own folder `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/auditor/` (new).
- Real captures you may use for realistic cases: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger/{home,contact,gallery}/capture/`.

## Your copy
In your own worktree: `git checkout --detach 845e60146f6d3434e96bf44f497f63a98202eb74`, confirm `git rev-parse HEAD` and a clean
`git status --porcelain --untracked-files=all`. Your `ac.json` names this head and base. Never write in any other worktree.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
and `references/rules-summary.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
and the report format at the top of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every
runnable AC make your own head and base runs (log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on
head and fail on base for changed behaviour; a setup failure is not RED; preservation that correctly passes on base is
`base_exempt` with a specific reason) and a screenshot (a real terminal image for a non-visual AC). Write
`auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (no `--reviews`).

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
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC
accepted. Empty skill_lessons is normal; never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
