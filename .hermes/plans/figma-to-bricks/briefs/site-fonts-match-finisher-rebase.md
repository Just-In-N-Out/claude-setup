# Role: finisher (rebase + receipt): site-fonts-match onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first. **Never load bdryswi.com** or any live site (Google Fonts only as `site:check` does); touch nothing under `~/Downloads`; never write to any WordPress site. Commit to your branch only; don't push; don't
bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never
`git -C` the main folder). **No ledger move** (the after-merge finisher does it).

## State
site-fonts-match is accepted: `ac-check.sh` READY FOR THE USER (8 of 9, AC9 live) on head `dde550599bebc51772b0100a8a27941bd3138a51` (branch
`site-fonts-match-fix1`) on base `e61c0ca091413adfdca3c9b3abe4757ef2fd521f` (Build 2026-11-11.6). Local main has moved 126 commits since
(Builds 11.7–2026-11-12.1: site-sticky-header, plugin-header-footer-ticks, footer-icon-list, media-avif-alt, site-native-structure; maybe
bricks-icons soon); read `git rev-parse main` at your start. Those touched `src/core/site/` (parts.ts, blocks, the Elementor fold, labels),
`src/web/read/`, `tools/`, tests and HANDOFF; this job touches `src/web/read/fonts.ts` and the scan's end, `src/core/site/` (the page-named
family, the fonts class, notes; `parts.ts` imports), `test/web/lib/site-check.ts` (`checkParts`), tests and HANDOFF. Expect the `parts.ts`
import line and HANDOFF to conflict: keep both.

## Do
1. Your own worktree: `git checkout -B site-fonts-match-final dde550599bebc51772b0100a8a27941bd3138a51`; `git rebase <main's SHA>`. Record each conflict
   in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/rebase/conflicts.md` and `git range-diff` in `range-diff.txt`.
   HANDOFF/ledger only → both sides word for word, this job's section first. Any source/test conflict → keep both sides' meaning, record
   exactly what you resolved and how, and say so in the report (it then takes a full review).
2. Main's merged jobs may have named-only pins that now fail with this job's files (e.g. `media-avif-untouched`, `site-import-figma-unchanged`
   compare files under `src/`; a byte-for-byte site pin and the panel's pins): run every merged job's named-only pin that reads `src/core`,
   `src/plugin`, `src/ui` or the renderer by name with its variables on the new head; one that fails only because of this job's files is
   updated test-only (allow exactly `git diff --name-status <main>...HEAD -- <the pinned paths>`, keep every other file pinned, a stray-file
   and a one-byte mutant still fail it), RED/GREEN, one commit — and say so.
3. Rerun every agent-run AC test (AC1–AC8 by their plan names in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/plan-approved.md`,
   with the plan's variables) on the new head into `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/rebase/receipt-<head7>.log`
   (`HEAD=` first, each `ok` line, `EXIT=` last, skipped 0). Then `npm run check` (8G scope); the story's web files and `site-native-*`,
   `site-check-*`, `site-elementor-*` web files (4G, one Chrome suite at a time); Justin's 2026-11-11 scan (`evidence/media-clickable/run/`)
   through main and the new head on both routes: byte for byte (AC7); Figma replays byte for byte main's.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sffr/t1`); scripts under `~/.cache/sffr/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/
"Killed" may be earlyoom: check first.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
