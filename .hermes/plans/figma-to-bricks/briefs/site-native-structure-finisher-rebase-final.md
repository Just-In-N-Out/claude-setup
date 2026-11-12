# Role: finisher (the move onto main): site-native-structure — from footer-icon-list's old head onto Build 2026-11-11.9

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`, `test-driven-development`,
`receiving-code-review`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and
the repo `CLAUDE.md` "Finish" step 1; the project skill's `references/testing-pitfalls.md` (stack-move — including other merged jobs'
named-only pins —, rebase-delta, sibling-class lines) and `references/live-site-reading.md` "Code-route paste traps". Read both
`repeat-mistakes.md` files first. Never load any live site; never write to any WordPress site; touch nothing under `~/Downloads`. Commit
to the branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. **No ledger commit.**

## State
site-native-structure is accepted (READY FOR THE USER 14/15) on head `f86ab19deeef19de5a9ed4a1306b0c99d94eb33e` (branch
`site-native-structure-stack7`), built on footer-icon-list's **old** head `731707c5`. footer-icon-list has since merged as Build
2026-11-11.9 from a different (rebased) line. Main now = `5bf71692c98497dd0411e2a42d23cbd93f457769`, holding today's builds 11.4
media-clickable (`background.ts`, `convert.ts`, `render.ts`), 11.5 site-scroll-lock (`classes.ts`, `convert.ts`, `parts.ts`, many pins,
`site-no-revert-main.json`), 11.6 site-menu-motion (`web.ts`, `details.ts`, `opens.ts`, `slide.ts`, `open-paste.ts`, `parts.ts`), 11.7
site-sticky-header (`stay.ts`, `parts.ts`, code-page sums, `tools/site-sticky-header-sums.ts`), 11.8 plugin-header-footer-ticks (`src/ui`,
`normalise/site.ts`, understand notes), 11.9 footer-icon-list (capture readers, `test/unit/site-slide.test.ts` pin edits). Approved plan
(amendment 2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`; state in `…/follow-ups.md`.

## Do
1. Your own worktree: `git checkout -B site-native-structure-final f86ab19d…`; **`git rebase --onto 5bf71692… 731707c5…`** (drops the old
   footer-icon-list commits; only this job's commits replay). Record every conflict and its resolution in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/stack-8/` (`conflicts.md`, `resolutions/`, `range-diff.txt`).
   Keep both sides' meaning: e.g. a lifted part root must still carry the scroll lock and (header) the stay class — decide where those
   classes go when the root is left out (the part's top Sections?) and prove the sticky header still sticks and the page still can't
   scroll sideways; the slide script's Code element and marker under native structure; media-clickable's Background image settings on
   native Sections/Blocks; footer-icon-list's one-name reader. HANDOFF: both sides stay, this job's section first.
2. Where the jobs meet, write a failing test first for any behaviour the move breaks, then fix (commit separately, named "meet").
3. Pins and goldens a merged job or this one moves: each by its own generator with a per-variant or four-tree proof; every merged job's
   named-only pins run by name (site-menu-motion `F2B_SITE_SLIDE_BDRY`, site-sticky-header's sums helper with an absolute tree path
   `--base 5bf71692`, site-scroll-lock's `F2B_BASE_TREE` pins, footer-icon-list's, media-clickable's `F2B_MEDIA_RUN`) and this job's own
   (AC13 `F2B_PIN_BASE=1`, AC14's B-Dry variables per the plan).
4. Gates on the new head: `npm run check` (8G); every AC test of this plan; `test/web/site-sticky-header.test.ts`,
   `site-scroll-lock.test.ts`, `site-slide-proof.test.ts`, `site-native-*`, `site-elementor-*`, B-Dry files (8G); one Chrome suite at a
   time; compare failures with main by name. Write the AC receipt
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/rebase/receipt-<head7>.log` (`HEAD=` first, `EXIT=` last).
5. Re-read `git rev-parse main` after the gates; report the new head, the conflicts (files, how resolved), the meet fixes, pins moved.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sn8/t1`); scripts and progress under
`~/.cache/sn8/s/`; `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (`pgrep -f
'[u]ser-data-dir=<path>'`); memory scopes as `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool, run as `bash <file>`; plain `git` in your own
worktree (never `git -C` the main folder). Use `tail -n 3`. Waits under 115 s; long drivers with `setsid --fork`, waiting on `^EXIT=`.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to
process'` first.

## Report (as text), stop at `ready-for-review`
New head (full SHA) and the main it sits on; conflicts and resolutions; meet fixes (RED/GREEN); pins moved with proofs; gates by name;
receipt path and last line; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
