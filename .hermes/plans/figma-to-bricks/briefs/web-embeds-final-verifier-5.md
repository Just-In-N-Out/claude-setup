# VERIFIER (read only): web-embeds (J5: widgets, maps and floating extras), final check after rebase 2

You are a fresh, read-only verifier who never saw the build. Source and tests are read-only; commit nothing.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## Inputs
- Plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md` (AC1–AC13, with **amendment 1**
  of 2026-11-03 at its top: AC2 and rules 2b–2c count only JavaScript, an inline script only when it loads or calls the
  host; the pre-amendment copy is `plan-approved-v1-before-amendment-1.md`, for reference only). AC12 and AC13 are
  `(live)`, owed to Justin: mark them `not_run`.
- Head `a8b83660a2431958d1b20b2e0a2539e3481bc29a` (branch `embeds-final-2`), base `88a6aa49fb617bea4fe4257df9d3392e8bed14d8`
  (main, Build 2026-11-03.1: the website importer's first four jobs plus the DJ Trees phone menu, which changed
  `test/browser/render.ts`, render goldens and `src/core` rules). In your own worktree:
  `git checkout --detach a8b83660a2431958d1b20b2e0a2539e3481bc29a`, confirm `git rev-parse HEAD` and a clean tree.
- This head is the job's accepted work (`c9ce258`, verifier clean, auditor accepted all but AC2's plan text, now amended)
  moved by a rebase onto the new main, plus two records commits (`6e69d340` the amended plan, `a8b83660` a ledger note).
  The rebase had 5 conflicts (`ir.ts`, `emit-nested-links.test.ts`, `adapt/layout.ts`, HANDOFF ×2) and 4 files changed on
  both sides that merged cleanly (`elements.ts`, `style.ts`, `understand.ts`, `test/browser/chrome.ts`). Resolutions and
  proofs: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/final-rebase-2/` (`conflicts.txt` and the rest).
- Earlier accepted checks you may read (don't trust their receipts): `.../web-embeds/verifier-4/` (clean on `c9ce258`).

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.
1. Read the conflict resolutions and the 4 cleanly merged both-sides files above: does each keep both sides' meaning
   (main's phone menu and embeds' widgets/floating extras)? Report any lost rule, field or test as a finding (P0–P2 with a
   real-use scenario), else say so in one line.
2. Gates on head, by test name against the base: both typechecks, `npm test`, the five Figma replays byte-identical, and
   this job's AC files plus AC10's byte-identity receipt and AC11's live check on fresh GET-only captures (the builder's
   `scripts/` in `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/builder/`). Because main changed the
   renderer, also run the embeds browser/web files that render (`test/web/capture-embeds.test.ts` and any AC test under
   `test/browser/`). AC6's part that needed J2's `site.tiers` (Task 11) was never built: judge AC6 by its unconditional text.
3. Every AC's named test on head and on base, a screenshot or terminal image per AC.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-embeds/verifier-5/ac.json` (ac-verification.md format:
   head, base, `ac_status` per AC; AC12, AC13 `not_run`, owed), then self-check with
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a copy of your report.

## Machine
- This machine (WSL): `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` at most 38 characters (`~/.cache/sfv5/tmp`). One
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
