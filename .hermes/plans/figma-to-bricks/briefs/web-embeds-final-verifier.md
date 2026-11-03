# VERIFIER (read only): web-embeds (J5: widgets, maps and floating extras), final check on the stacked head

You are a fresh, read-only verifier who never saw the build. Source and tests are read-only; commit nothing.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## Inputs
- Plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md` (AC1–AC13; AC12 and AC13 are `(live)`, owed to Justin: mark it `not_run`).
- Head `c9ce2583e397993fa8bb7eafa4b919aaf0fa07ec` (branch `embeds-final`), base `9212c477276f12ea4bb0453723619109ca9da4dc` (main, Build 2026-11-02.5: wave 1, panel, address box and tiers merged). In your own worktree: `git checkout --detach c9ce2583e397993fa8bb7eafa4b919aaf0fa07ec`, confirm `git rev-parse HEAD` and a clean tree.
- This head is the job's accepted work (embeds-merge `3a39c11`, accepted READY FOR THE USER) moved by a pure rebase onto main after the other four merged; before that it was moved onto the merge stack (wave 1 → panel → address → tiers → embeds) by a stack
  finisher: real conflicts in `chrome.ts`, `capture.ts`, `assemble.ts`, `normalise.ts`, `style.ts`, `ir.ts`, `understand.ts`, plus three stack fixes: `dbebf8b` (paste check renamed 3cw), `07cd10e` (AC6 test reads the footer rule's own write, written or yielded, since `site.tiers` owns capture layers), `3a39c11` (a real bug: `capture-alts.ts` `layers()` now also walks floating extras). Resolutions: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/embeds/conflicts.txt`, `stack-fix.txt`. Its receipts: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/embeds/` and `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/heads.txt`.
- Earlier accepted checks you may read (don't trust their receipts): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/verifier-2/` and `auditor/` (READY FOR THE USER on 5e3fea8), fix 2 `78c0b9b` (Yoast/data-layer scripts).

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.
1. Read the conflict resolutions and stack fixes above: for each, does it keep both sides' meaning? Report any lost
   rule, field or test as a finding (P0–P2 with a real-use scenario), else say so in one line.
2. Gates on head, by test name against the base: both typechecks, `npm test`, the five Figma replays byte-identical, and
   this job's AC files plus: AC10's byte-identity receipt and AC11's live check on fresh GET-only captures (the builder's `scripts/` in `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/builder/`). AC6's part that needed J2's `site.tiers` (Task 11) was never built: judge AC6 by its unconditional text and note anything the now-present tiers changes. Not the whole test:web or test:browser suites.
3. Every AC's named test on head and on base, a screenshot or terminal image per AC.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/verifier-4/ac.json` (ac-verification.md format: head, base, `ac_status` per AC; AC12, AC13 `not_run`, owed),
   then self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a
   copy of your report.

## Machine
- This machine (WSL): `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` at most 38 characters (`~/.cache/sfvx/tmp`). One
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
`{verdict: clean|findings, head, base, findings[], ac_status[{ac,accepted,test,screenshot,evidence}], gates, found_else[],
skill_lessons[{skill,lesson,evidence,enforce}]}`. Empty skill_lessons is normal; never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
