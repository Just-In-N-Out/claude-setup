# Role: finisher (rebase 2 + receipt): bricks-icons (M1) onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first. Never load any live site; never write to any WordPress site. Commit to your branch only; don't push; don't
bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never
`git -C` the main folder; no git piped into another command). **No ledger move** (the after-merge finisher does it).

## State
bricks-icons M1 is verified clean (verifier 2) on head `643109ec54f2060fdbf66c1db891d2b00505ec18` (branch `bricks-icons-final`) on main
`56b5076b`; its blind auditor is running on that head now. Local main has moved to `6cd6154e` (Build 2026-11-12.2, site-fonts-match: it touched
`src/core/site/` (fonts, convert.ts, parts.ts), `src/web/`, `test/web/lib/site-check.ts`, the pins `media-avif-untouched` and
`site-import-figma-unchanged` (test/fixtures/later-jobs.ts may meet), tests and HANDOFF). Read `git rev-parse main` at your start. Justin's
notes-only rule: if the only conflicts are HANDOFF/ledger and test-only pin lists, the move needs only a short review plus an AC receipt.

## Do
1. Your own worktree: `git checkout -B bricks-icons-final2 643109ec54f2060fdbf66c1db891d2b00505ec18`; `git rebase <main's SHA>`. Record each conflict
   in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/rebase-2/conflicts.md` and `git range-diff` in `range-diff.txt`.
   HANDOFF/ledger only → both sides word for word, this job's section first. Any source/test conflict → keep both sides' meaning, record
   exactly what you resolved and how, and say so in the report (it then takes a full review).
2. Main's merged jobs may have named-only pins that now fail with this job's files (e.g. `media-avif-untouched`, `site-import-figma-unchanged`
   compare files under `src/`; a byte-for-byte site pin and the panel's pins): run every merged job's named-only pin that reads `src/core`,
   `src/plugin`, `src/ui` or the renderer by name with its variables on the new head; one that fails only because of this job's files is
   updated test-only (allow exactly `git diff --name-status <main>...HEAD -- <the pinned paths>`, keep every other file pinned, a stray-file
   and a one-byte mutant still fail it), RED/GREEN, one commit — and say so.
3. Rerun every agent-run AC test (AC1–AC6 by their plan names in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md`;
   AC3 with `F2B_STORY_PINS=1`, AC4/AC5 in Chrome) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/rebase-2/receipt-<head7>.log` (`HEAD=` first, each `ok` line, `EXIT=` last,
   skipped 0). Then `npm run check` (8G scope), `test/browser/icon-elements.test.ts`, `test/browser/panel.test.ts`, `test/unit/render.test.ts`
   and the five Figma replays with Icons off byte for byte main's (4G, one Chrome suite at a time).
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bifr2/t1`); scripts under `~/.cache/bifr2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/
"Killed" may be earlyoom: check first.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
