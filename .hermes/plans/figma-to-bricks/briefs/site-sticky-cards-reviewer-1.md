# Role: reviewer (round 1, FULL review of the whole story; report only): site-sticky-cards

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site (every Chrome that draws a site capture or paste
launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site (only `test/fixtures/wp-standin.ts` and the
local fixture sites on 127.0.0.1); touch nothing under `~/Downloads` (a test that clicks a download runs under a scratch HOME with
`.cache/chrome-for-testing` and `.cache/chrome-libs` symlinked in; Justin's scan copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`).
**Importer rule:** one review per job, P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-cards/plan-approved.md` (AC1–AC13; AC13 live).
  The job: a box Elementor Pro's Sticky script pins inside its parent (Sticky: Top, Stay In Column) pastes as Bricks' own Position: Sticky
  with Top in its class's settings, at the widths the site pins it (Sticky On, per-device offsets); boxes Sticky can't pin as the site does
  stay as before, named once; the header stays over the pinned cards with `overflow-x: hidden` in Additional CSS (a guard class); captures
  without such a box and Figma designs byte for byte as before.
- Branch `site-sticky-cards-build`, head `ba96204b932e13c9e4d7c392e5ce43269b5a4bb1` (code head `4ec898b4`), base **importer-parity's fix-1 head**
  `b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda` (not merged; importer-parity is in its fix round 2, on `src/core/site/slider-look.ts`):
  `git checkout --detach <head>`; review `git diff b232c9de...HEAD`. Builder's evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-sticky-cards/builder/`
  (a head start, not proof); HANDOFF's new top section. Builder's found_else: a box inside a clipped parent that the site's script lifts over
  the header at 390 stays in flow (refusal S7); four older pins fail on base and head alike.

## Check hardest
1. Pinned where and only where the site pins: Justin's scan (`evidence/media-clickable/run/`, both routes) and the fixture, at every Bricks
   tier and the site's own breakpoints, scrolled; nothing pinned on phones the site doesn't pin; the header stays on top; a pop-up's no-scroll
   still holds the page.
2. The refusals: what a real Elementor site sets (Sticky: Bottom, no Stay In Column, a parent that scrolls or clips, Effects Offset) is left
   as before and named once, never half-pinned.
3. A Bricks pro: Position and Top in the class's own Bricks settings (not custom CSS), editable per tier; the guard class short and named.
4. Switch off / no sticky box: byte for byte the base; Figma replays and `dist/` unchanged; every merged job's pins (`F2B_STORY_PINS=1`).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-cards/review-1/review.json` (round 1, **scope full**, from `b232c9de…`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda /home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-cards`. Load `requesting-code-review` and
`code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with
`references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sscr1/t1`); scripts under `~/.cache/sscr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start (kill by PID, never `pkill -f` with a pattern
in your own command line); one Chrome suite at a time (B-Dry files 8G) under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0
/bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. A git-archive tree has no repo (set `GIT_DIR` inside a runner
for tests reading `git show`) and no `dist/`. `cancelled 1` in a test log is a timeout, not a result (`site-controls` needs ~830 s under load).
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's
log and `journalctl --user | grep -E 'oom-kill|OOM killer'`. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each found_else and ruling: holds or not; Bricks-pro notes;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
