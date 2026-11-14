# Role: reviewer (round 1, FULL review of the whole story; report only): short-class-names

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site (every Chrome that draws a site capture or paste
launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site (only `test/fixtures/wp-standin.ts`); touch
nothing under `~/Downloads` (Justin's scan copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). **Importer rule:** one review
per job, P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/short-class-names/plan-approved.md` (AC1–AC17; AC17 live).
  The job (Justin, 2026-11-13: "easy for a Bricks pro"): class names read by purpose with a short site prefix (`bd-heading-1`,
  `bd-button-primary`, `bd-card`) instead of `<page>__…`, the same name and id on every page of a site (a per-site name list), in both tools;
  pages draw exactly as before.
- Branch `short-class-names-build`, head `2d695d3317e5cc3164ef321dcb65fad64ba73a9e`, base **site-shared-styles' reviewed head**
  `7b7501bd082ae44a99985aac4d080c9b70b67c53` (not merged; site-shared-styles is now rebased as `7977b8f8` on main `84722938`): `git checkout
  --detach <head>`; review `git diff 7b7501bd...HEAD`. Builder's evidence: `~/.hermes/plans/figma-to-bricks/evidence/short-class-names/builder/`
  (a head start, not proof); HANDOFF's new top section.
- Builder's found_else to judge:
  1. AC11's look classes are owed at the rebase onto plugin-parity (`emit/looks.ts` isn't on this base) — is the plan's AC11 still provable
     after that rebase as built (`nm.take(purpose, key)` in N4's order)? Say what the rebase must do.
  2. A class's list key is a digest of its rules, which include a picture's WordPress media address: a re-upload that changes the address
     (`--reupload-avif`) gives the class a new name (`bd-x-2`) on the next paste. Is that a P2 Justin hits (he re-uploaded AVIFs on
     2026-11-11), and what should the key be?
  3. N4 deviation: the plugin saves the name list itself in runConvert instead of the panel sending it back.
- Read the standard at the top of the main folder's CLAUDE.md "Decisions the user made" (point 2: names by purpose with a short site prefix,
  the same name and id on every page of a site, never two classes writing one property).

## Check hardest
1. Two pages of one site pasted in turn (Justin's scan and the B-Dry stand-in, both routes; two Figma pages): the same look gets the same name
   and id, a different look never takes another's name; Bricks' class comparison (`test/fixtures/bricks-paste.ts`) asks nothing it shouldn't.
2. The prefix: how it's chosen (site address → `bd`; 127.0.0.1 → `web`), collisions with Bricks' own or a theme's classes, a site without a
   name, the panel's prefix box; the name list's file: where it lives, what a stale or hand-edited list does.
3. Names are inert: every paste draws exactly as before (base vs head in Chrome at 1440 and 390, Bricks 2.4.2 and 2.3.9).
4. Without the list / the switch off, Figma replays and `dist/` as the plan says; every merged job's pins (incl. `F2B_STORY_PINS=1`).
5. Would a Bricks pro find the names logical in the class picker (B-Dry's 34/288/142 classes)?

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/short-class-names/review-1/review.json` (round 1, **scope full**, from `7b7501bd…`; full
SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/short-class-names`. Load `requesting-code-review`
and `code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked)
with `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/scnr1/t1`); scripts under `~/.cache/scnr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start (kill by PID, never `pkill -f` with a pattern
in your own command line); one Chrome suite at a time (B-Dry files 8G) under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0
/bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. A git-archive tree has no repo (set `GIT_DIR` inside a runner
for tests reading `git show`) and no `dist/`. Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait).
After SIGTERM/143/137/"Killed" check earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each found_else: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
