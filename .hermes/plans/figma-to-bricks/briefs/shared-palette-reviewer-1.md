# Role: reviewer (round 1, FULL review of the whole story; report only): shared-palette

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch nothing under
`~/Downloads`. **Importer rule:** one review per job, P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number);
edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11; AC11 live). The
  job: one colour palette for both tools — a colour has one id and one variable across pages and tools; the site's own palette files
  (`--colours a.json,b.json`, the panel's "Colours already on the site") are reused, so the palette file each tool writes holds only colours the
  site lacks; bad files stop with one line; switch off / no site colours = byte for byte as before.
- Branch `shared-palette-build`, head `9070c50f` (resolve with `git rev-parse shared-palette-build`), base **site-shared-styles' head**
  `7b7501bd082ae44a99985aac4d080c9b70b67c53` (not merged): `git checkout --detach <head>`; review `git diff 7b7501bd...HEAD`.
- Builder's rulings (judge each): a new colour whose variable name the site uses for another value → `<name>-2`, never a site id; the
  panel download leaves out site-held colours (`keepPalette`); chooser under the header/footer ticks; nothing new → no palette.json and a stale
  one removed; the `Colours:` note's old sentence without files; bad file → exit 1 in all four commands; styles.txt names colours by variable.
- Read the standard at the top of CLAUDE.md "Decisions the user made" (the main folder's): ask "would a Bricks pro find this palette logical
  and easy to change?" and report where not (the builder named: hex-named colours, `-2` names, "home (site.test) 2" palette names).

## Check hardest
1. Bricks' Colors import with the written palette.json and the site's own export: shape from `reference/bricks/` or Bricks' GPL code
   (`saqib6571/bricksbuilder`), ids kept, a palette name the site has; what a paste shows when the palette isn't imported (the fallback).
2. Both tools: a Figma paste and a website paste of colours the site holds use the site's `var(--x, #HEX)`; a colour the site lacks gets
   one id and variable in both; two pages agree.
3. The panel (Chrome): choosing files, the "reused" line, the download; the plugin's paste = replay with the same files.
4. Every merged and stacked job still holds (site-shared-styles' palette links, media-clickable's Background, the Figma palette file).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-1/review.json` (round 1, **scope full**, from `7b7501bd`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette`. Load `requesting-code-review` and
`code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (read it directly; not linked)
with `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spr1/t1`); scripts under `~/.cache/spr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check both
earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each builder's ruling: holds or not; Bricks-pro notes;
`verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
