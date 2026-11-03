# VERIFIER (read only): web-tiers (J2: tablet and phone layouts read from the site), final check on the stacked head

You are a fresh, read-only verifier who never saw the build. Source and tests are read-only; commit nothing.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## Inputs
- Plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-tiers/plan-approved.md` (AC1–AC15; AC15 is `(live)`, owed to Justin: mark it `not_run`).
- Head `2fd7a95ef4b7c7bacacddef6bf749a65fb032e25` (branch `tiers-merge`), base `12f91267cc4c366728cc0ead47736ecf8b41a1a0` (`address-merge`, the job below it in the merge
  order). In your own worktree: `git checkout --detach 2fd7a95ef4b7c7bacacddef6bf749a65fb032e25`, confirm `git rev-parse HEAD` and a clean tree.
- This head is the job's accepted work moved onto the merge stack (wave 1 → panel → address → tiers → embeds) by a stack
  finisher: real conflicts in `scene.ts`, `normalise.ts`, `rules/index.ts`, `style.ts`, `understand.ts`, `designs.ts`, `wide.ts`, plus a test-only stack fix `2fd7a95` (tiers' AC12 fixture scan skips website-capture snapshots). Resolutions: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/tiers/conflicts.txt`, `stack-fix.txt`. Its receipts: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/tiers/` and `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/heads.txt`.
- Earlier accepted checks you may read (don't trust their receipts): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-tiers/verifier-2/` (clean on ecd7b89) and `auditor/` (found F1, fixed by fixer 2 in 9eb26ab).

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.
1. Read the conflict resolutions and stack fixes above: for each, does it keep both sides' meaning? Report any lost
   rule, field or test as a finding (P0–P2 with a real-use scenario), else say so in one line.
2. Gates on head, by test name against the base: both typechecks, `npm test`, the five Figma replays byte-identical, and
   this job's AC files plus: AC14 live with `F2B_LIVE=1` (GET only); AC8 on real captures with `F2B_REAL_CAPTURES=/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/hostinger`; the fit check (document `scrollWidth` of the contact, home, gallery and letsgro pastes at 320, 390, 478, 767, 991, 1440; known exceptions: 786 at 768, the home's 359 at 320). Not the whole test:web or test:browser suites.
3. Probe the case the panel's stack verifier found: wave 1's `fixedbars` fixture site (a header of a desktop fixed bar plus
   a phone-only fixed bar), captured fresh with head's code (`test/fixtures/web/capture.ts` `captureFixture`): does the
   phone-only bar's words reach the Header paste and show from 767 down, now that `site.tiers` is present? Report it
   (a finding only if an AC's text covers it; else `found_else`).
4. Every AC's named test on head and on base, a screenshot or terminal image per AC.
5. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-tiers/verifier-3/ac.json` (ac-verification.md format: head, base, `ac_status` per AC; AC15 `not_run`, owed),
   then self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a
   copy of your report.

## Machine
- This machine (WSL): `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` at most 38 characters (`~/.cache/stvx/tmp`). One
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
