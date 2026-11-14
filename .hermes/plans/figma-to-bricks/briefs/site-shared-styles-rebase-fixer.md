# Role: fixer (rebase onto main + R1-2, R2-1, R2-2): site-shared-styles

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review`, `test-driven-development`, `git-commit-rules`,
`engineering-best-practices`, `mutation-testing-discipline`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md` and
`references/planning-checks.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). **Never load bdryswi.com** or any live site (Google Fonts only as
`site:check` does); touch nothing under `~/Downloads` (Justin's scan copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`);
never write to any WordPress site. Commit to your branch only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md);
don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command
alone (never `git -C` the main folder; no git piped into another command; `git archive -o <file> <sha>`, extract separately; scripts with the
Write tool, run as `bash <file>`, no heredocs).

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md` (amendment 1).
  Reviews 1 and 2 (`evidence/site-shared-styles/review-1|2/review.json`) and `follow-ups.md` there. Reviewed head `7b7501bd`
  (branch `site-shared-styles-fix1`), 20 commits on an early site-no-div head `d915f7dc`.
- site-no-div is now merged: local main is `cf4f887d` (site-no-div final, on Build 2026-11-12.3) and an after-merge finisher is adding one
  `Build 2026-11-14.N: …` commit (build.ts, HANDOFF, ledger, docs only) on top. **Wait for it:** poll `git log -1 --format=%s main` every
  ~100 s (foreground, never end your turn) until it starts `Build 2026-11-14`; take that SHA as `<main>` (if 40 minutes pass, use `cf4f887d`
  and say so).

## Do
1. `git checkout -B site-shared-styles-final 7b7501bd`; `git rebase --onto <main> d915f7dc` (only this job's 20 commits move). Record every
   conflict and how you resolved it in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/rebase/conflicts.md`, and
   `git range-diff d915f7dc..7b7501bd <main>..HEAD` in `range-diff.txt` there. Keep both sides' meaning: site-no-div's final rules (fix
   rounds 2–3: lift.ts rule S, fold-boxes.ts rule N, natives.ts, labels, structure.ts) AND this job's shared looks. The builder carried a
   site-no-div fix in `src/core/site/lift.ts` `plainParts` (a section root is a Section only when it's a box; a lone `p` root kept its
   words): keep it unless main already does the same, and say which.
2. **R1-2 (code; test first):** a text class's and a Button class's `font-family` must pass through main's site-fonts-match renaming
   (`fonted` / `renameFamilies` in prepare's fix(), `typographyFamilies(capture, extra.fonts)`), so a family the paste carries itself is
   written under the page's name (`"home__Roboto"`), never the bare carried name, in every shared look class; decide sitePage and
   pageLooks (section paste) alike, or record why they differ. RED on the rebased tree without the fix, GREEN with it, a one-line mutant
   killed. Prove on Justin's scan (both routes): 0 Typography controls or look classes naming a bare family the fonts class declares under
   the page's name; the words draw with the site's own faces in Chrome (site:check fonts, base main vs head).
3. **R2-1, R2-2 (wording):** `tools/lib/site-import/next.ts` palette step: an import Bricks refuses by name means those colours are already
   there; skip it unless `styles.txt` lists a colour the palette lacks. The class step and HANDOFF: a changed class shows "Conflict: Name",
   and Accept / Reject are a check-mark and an × icon.
4. Main's merged jobs' named-only pins that read `src/` by file (`media-avif-untouched`, `site-import-figma-unchanged`, `site-scroll-lock-base`,
   `panel-embed-unchanged`, the site byte-for-byte pins, `F2B_STORY_PINS=1` story pins) on the new head; one that fails only because of this
   job's files is updated test-only (allow exactly `git diff --name-status <main>...HEAD -- <pinned paths>`; a stray-file and a one-byte
   mutant still fail it). AC tests whose goldens a merged job moved are regenerated only by their own tool on the new tree — say how many.
5. Gates: `npm run check` (8G scope); every AC1–AC15 agent-run test by its plan name on the new head into
   `evidence/site-shared-styles/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok`, `EXIT=` last); the `site-*`, `site-fonts*`,
   `capture-fonts`, `site-check-*`, `site-no-div-*` web files one Chrome suite at a time (4G; B-Dry 8G), compared with main by name; Figma
   replays (`corpus/files/*`, `figma-to-bricks-debug-page-1.json`) byte for byte main's.
6. Ledger: add a "Rebase onto main + R1-2" section to the job's ledger; HANDOFF's site-shared-styles section (this job's first; main's
   site-no-div section word for word). Stop: the session sends a fresh review.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sssr/t1`); scripts under `~/.cache/sssr/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`); memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on
`^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]*
to process'` and `journalctl --user | grep -E 'oom-kill|OOM killer'` first and rerun alone under a cap. Away rule (Justin is asleep): research
it; if nothing is found, take your best-reasoned answer and record it as a ruling in the ledger and HANDOFF.

## Report (as text)
New head (full SHA), branch and the main it sits on; each conflict and its resolution; R1-2 RED/GREEN/mutant and the scan counts; R2-1/R2-2
lines; pins changed (test-only); receipt path and last line; gates by name; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit
skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
