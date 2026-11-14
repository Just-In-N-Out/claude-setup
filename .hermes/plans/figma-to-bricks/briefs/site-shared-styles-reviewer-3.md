# Role: reviewer (round 3, review of the REBASE RESOLUTION onto main 2026-11-14.1 and the fix commits; report only): site-shared-styles

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command; `git archive -o <file> <sha>` then extract
separately; scripts with the Write tool, no heredocs). Never load any live site (every Chrome that draws a site capture or paste launches
with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site; touch nothing under `~/Downloads` (Justin's scan
copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). **Importer rule:** P0–P2 only for bugs a real paste or normal use hits
(a scenario and a measured number); edge cases P3. This is the job's last review round under the project's cap: be complete.

## Scope
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md` (AC1–AC15; AC15 live).
  Reviews 1 and 2 clean on `7b7501bd` (on an early site-no-div head `d915f7dc`); follow-ups in `follow-ups.md` there.
- A fixer rebased the 20 commits onto main `84722938` (Build 2026-11-14.1: site-no-div final, with site-fonts-match and bricks-icons) with two
  source conflicts (`src/core/site/convert.ts` `ConvertOptions` and imports), then added: 73ef8524 (R1-2: look candidates' states through
  prepare's `fonted`), 831d6318 (site-fonts pins, test-only), a5e37647 (R2-1/R2-2 wording in `tools/lib/site-import/next.ts`), 8f8abb0d
  (merged jobs' pins, test-only: `site-no-div-names`, `site-native-unchanged` with 8 allowed pageCode pastes, `LATER_JOBS` + 5 files),
  7977b8f8 (HANDOFF, ledger). Head `7977b8f892339a8d8725bf67cbd30b9a69317171` (branch `site-shared-styles-final`; `git checkout --detach
  7977b8f8…`). Record: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/rebase/` (`conflicts.md`, `range-diff.txt`,
  the R1-2 logs, `draw/`, `pin-mutants/`, `receipt-7977b8f.log`). Review what the reviewed head lacks: `git range-diff d915f7dc..7b7501bd
  84722938..3662fcb3`, the resolutions, and `git diff 3662fcb3..7977b8f8`, and how this job's code meets site-no-div's final rules (lift.ts
  rule S, fold-boxes.ts rule N, natives.ts, labels, structure.ts) and site-fonts-match.

## Check hardest
1. Each resolution keeps both sides' meaning (nothing of main's site-no-div, fonts or Icon code lost; the carried `lift.ts` `plainParts` fix
   — a section root is a Section only when it's a box — kept and right).
2. R1-2 on a real paste: no shared text or Button class, own class or Typography control names a carried family bare; the fixer's ruling
   that a section paste (no fonts class) names families bare as main does; Chrome draw base main vs head (the fixer notes `site:check`'s
   renderer loads captured faces under the plain name, so compare each element's drawn font with main's).
3. The pins: `site-native-unchanged`'s 8 allowed pastes are exactly this job's Q6 A and AC10 moves (reason per key), a revert mutant still
   fails it; `LATER_JOBS` names exactly this job's files; the four pins the fixer says fail on main's own archive too really do.
4. Shared looks meet site-no-div's natives: a Text link, Button, Image, Rich Text and lifted Section carry the right shared class, no two
   classes write one property, the page draws as before (B-Dry's saved page both routes, 1440 and 390, Bricks 2.4.2 and 2.3.9).
5. The standard (repo CLAUDE.md top of "Decisions the user made"): would a Bricks pro find the rebased paste's classes logical?

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/review-3/review.json` (round 3, scope of the resolution and fix
commits, full SHA `head`), in review-2's format; self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
--repo <your worktree> --base 84722938b32c82e2dc5041bda6383ac12bf7793d /home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles`
and quote its last line; if it asks for another scope or base, follow it and say so. Load `requesting-code-review` and
`code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with
`references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sssr3/t1`); scripts under `~/.cache/sssr3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A git-archive tree has no repo (set `GIT_DIR` inside a runner for tests reading `git show`) and no `dist/`. Use `tail -n 3`. Waits
under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's log and `journalctl
--user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each resolution and fix: holds or not; Bricks-pro notes;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
