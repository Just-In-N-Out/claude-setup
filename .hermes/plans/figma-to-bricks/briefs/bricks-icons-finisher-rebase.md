# Role: finisher (rebase + receipt): bricks-icons (M1) onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first. Never load any live site; never write to any WordPress site. Commit to your branch only; don't push; don't
bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never
`git -C` the main folder). **No ledger move** (the after-merge finisher does it).

## State
bricks-icons M1 is accepted: `ac-check.sh` READY FOR THE USER (6 of 7, AC7 live) on head `c78fa0cfcbc7ce9a9b9689613274f633130012ef` (branch
`bricks-icons-fix1`) on base `0248176342c662b821629d462f4d15a2a2a1df98`. Local main has moved 153 commits since (Builds 2026-11-11.4 to
2026-11-12.1: media-clickable, site-scroll-lock, site-menu-motion, site-sticky-header, plugin-header-footer-ticks, footer-icon-list,
media-avif-alt, site-native-structure); read `git rev-parse main` at your start (`56b5076b` or newer). Those touched `src/core/site/`,
`src/web/`, `tools/`, `test/browser/render.ts` (a `_background` printer), `src/ui/` (tick wording), tests and HANDOFF; this job touches
`src/core/understand/icon.ts`, `src/core/model/icon-svg.ts`, `src/core/style/icon.ts`, emit, `src/ui/` (Icons as SVG), `test/browser/render.ts`
and `render-icon.ts`, tests, `reference/bricks/icon-svg.json`, HANDOFF.

## Do
1. Your own worktree: `git checkout -B bricks-icons-final c78fa0cfcbc7ce9a9b9689613274f633130012ef`; `git rebase <main's SHA>`. Record each conflict
   in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/rebase/conflicts.md` and `git range-diff` in `range-diff.txt`.
   HANDOFF/ledger only → both sides word for word, this job's section first. Any source/test conflict → keep both sides' meaning, record
   exactly what you resolved and how, and say so in the report (it then takes a full review).
2. Main's merged jobs may have named-only pins that now fail with this job's files (e.g. `media-avif-untouched`, `site-import-figma-unchanged`
   compare files under `src/`; a byte-for-byte site pin and the panel's pins): run every merged job's named-only pin that reads `src/core`,
   `src/plugin`, `src/ui` or the renderer by name with its variables on the new head; one that fails only because of this job's files is
   updated test-only (allow exactly `git diff --name-status <main>...HEAD -- <the pinned paths>`, keep every other file pinned, a stray-file
   and a one-byte mutant still fail it), RED/GREEN, one commit — and say so.
3. Rerun every agent-run AC test (AC1–AC6 by their plan names in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md`;
   AC3 with `F2B_STORY_PINS=1`, AC4/AC5 in Chrome) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line, `EXIT=` last,
   skipped 0). Then `npm run check` (8G scope), `test/browser/icon-elements.test.ts`, `test/browser/panel.test.ts`, `test/unit/render.test.ts`
   and the five Figma replays with Icons off byte for byte main's (4G, one Chrome suite at a time).
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bifr/t1`); scripts under `~/.cache/bifr/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/
"Killed" may be earlyoom: check first.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
