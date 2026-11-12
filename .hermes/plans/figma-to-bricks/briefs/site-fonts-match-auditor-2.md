# Role: blind AC auditor (read-only): site-fonts-match (website importer) — on its rebased head

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read the verifier's report or folder** (`evidence/site-fonts-match/verifier/`, `verifier-dde5505/`, `auditor-dde5505/`, `rebase/`, `fixer-2/`, `review-3/`), nor the reviewers', builder's, fixer's or planners'
reports or folders as proof. Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone
(never `git -C` the main folder). **Never load bdryswi.com**, B-Dry staging or any live site (Google Fonts only as `site:check` does); never
write to any WordPress site; touch nothing under `~/Downloads` (Justin's 2026-11-11 scan: read-only copy `evidence/media-clickable/run/`).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/live-site-reading.md` (fonts lines), `references/testing-pitfalls.md` (subset-font, CHROME_PATH, the fixture-as-Google line).
Read both `repeat-mistakes.md` files first.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/plan-approved.md` (AC1–AC9; AC9 live:
  `not_run`). The job: a site's own font family pastes under the page's name with its `@font-face` rules (so Bricks' Google scan doesn't add
  it and the site's own files draw), a refused face's file is asked again at the scan's end, a face that stays failed is named in the notes;
  captures made before this build paste byte for byte as before.
- Head **`c8ad17b88a345eb9f1dbcb7946bca7e236a837c2`** (branch `site-fonts-match-fix2`: the job rebased onto main with source conflicts in
  `src/core/site/convert.ts` and `parts.ts`, a test-only re-pin and a test-only AC7 sums commit), base local main
  **`56b5076b5c1d665abd5bad4bcc78861739cc01e9`** (Build 2026-11-12.1, site-native-structure merged). In your own worktree: `git checkout --detach
  c8ad17b8…`, clean status. Old code: a `git archive` of 56b5076b (`git archive -o <file>`, extract separately) with head's test files and
  fixtures copied in (where a new module doesn't import, prove with a one-line mutant of head).

## Work
Prove every AC yourself: its cited test on head (pass) and on old code, plus one check of your own per AC beyond the cited test — e.g. a
fixture site of your own (not the verifier's names) with a site-served family in two weights, one weight whose file 403s, one family Google
serves and one whole-range plus subset rule pair: the paste's families, its `@font-face`, Bricks' Google scan (AC4's port) and the font
Chrome draws each line with on site and paste at 1440 and 390 (AC5); AC7: count yourself that Justin's scan pastes byte for byte as base on
both routes. Also: where this job meets site-native-structure — a site-served family on a page whose part roots are lifted and one whose header keeps
its root (fonts class on every top element, no plain name in a Typography control, the site's file drawn). A picture per AC. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/auditor/ac.json` and logs there
(it's empty now); self-check with `ac-check.sh` on a copy (`--base 56b5076b5c1d665abd5bad4bcc78861739cc01e9`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sfa2/t1`); scripts under `~/.cache/sfa2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`; never `pkill -f`); one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
