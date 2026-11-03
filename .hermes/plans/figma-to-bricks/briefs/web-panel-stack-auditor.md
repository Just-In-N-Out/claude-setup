# BLIND AC AUDITOR (read only): web-panel (J4: open a website capture in the plugin panel), final check on the stacked head

Independently prove the approved acceptance criteria. You have never seen a builder, reviewer, fixer, finisher or
verifier report. Stay blind: never open anything under `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/` except `plan-approved.md` and your own `auditor-2/` folder,
nor `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/`, HANDOFF, ledgers or session notes. Source and tests are read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/plan-approved.md` (AC1–AC17; AC16 is `(live)`, owed to Justin: mark it `not_run`). Use each exact test name the plan
  gives (a name the plan wraps across lines, or one built at run time, goes through a by-name checker).
- Head `293ad1f6b09a486ac8c7843f37915019741e2582`, base `0f9e870be571a961f4b363f72069e0370324d378`, your own folder `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/auditor-2/` (new).
- Supporting facts you may use: AC5's byte-identity receipt (the builder's script in `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-panel/builder/`); `test/web/panel-capture-alts.test.ts` with `F2B_PANEL_CAPTURES` pointing at `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger/*/capture/`.

## Your copy
In your own worktree: `git checkout --detach 293ad1f6b09a486ac8c7843f37915019741e2582`, confirm `git rev-parse HEAD` and a clean
`git status --porcelain --untracked-files=all`. Your `ac.json` names this head and base. Never write in any other worktree.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
and `references/rules-summary.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
and the report format at the top of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every
runnable AC make your own head and base runs (log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on
head and fail on base for changed behaviour; a setup failure is not RED; preservation that correctly passes on base is
`base_exempt` with a specific reason) and a screenshot (a real terminal image for a non-visual AC). Write
`auditor-2/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (no `--reviews`).

## Machine
- This machine (WSL): `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` at most 38 characters (`~/.cache/spax/tmp`). One
  Chrome job of your own at a time, closed after each step; sibling TMPDIRs if you ever run two. A browser or web run
  counts only with `skipped 0`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Worktree guard: write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; no
  redirects or the bare word `source` in a command. For base runs, `git archive -o <scratch>/base.tar <base>` then
  `tar -xf` in separate calls, and copy head's test files plus the test-only modules they import into it.
- Never call alttext.ai or write to any WordPress site; never load bdryswi.com; live reads (GET only) only of
  `https://darksalmon-badger-335429.hostingersite.com/` (`?f2b=<random>`) and `https://www.letsgro.ai/`. Put any summary
  in your report, not a separate summary file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC
accepted. Empty skill_lessons is normal; never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
