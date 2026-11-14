# Role: reviewer (round 4, FIX review of fixer 3's commits after the verifier; report only): shared-palette

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <file>`, extract separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch
nothing under `~/Downloads`. **Project rule:** a second review only checks the major fix; P0–P2 only for bugs a real paste or normal use
hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11; AC11 live). The
  job: one colour palette for both tools; the site's own palette exports (`--colours a.json,b.json`, the panel's "Colours already on the
  site") are reused, so the palette file each tool writes holds only colours the site lacks.
- Reviews 1–3 and the verifier: `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-{1,2,3}/review.json`, the
  verifier's finding F1 in `…/shared-palette/verifier/finding-F1-seethrough.log` (read the finding only, not its AC proofs).
- Fix 3: branch `shared-palette-fix3`, head `34502f91` (resolve with `git rev-parse shared-palette-fix3`; code `c2ee8dab` + `d3496324`, then a
  ledger/HANDOFF commit). Review `git diff 7fa1c0e7..HEAD` and what it touches. Fixer's evidence: `~/.hermes/plans/figma-to-bricks/evidence/shared-palette/fixer-3/`.
- What fix 3 claims: a see-through site colour is read with its alpha (`palette-files.ts` `lightOf`), colours compare by CSS text so opaque
  never links see-through; `SiteColours.unread` reserves the ids and variables of skipped colours; helpers `siteIds`, `siteNames`,
  `anySite` used by the plugin (`normalise/colors.ts` `onTheSite`), the importer (`site/colours.ts` `siteInk`) and the panel
  (`ui/palette.ts` `keepPalette`, now comparing parsed values); `ui/settings.ts` keeps alpha and `unread`; the real-file round trip
  (`figma-to-bricks-debug-page-1.json` with its own palette) writes no palette file and offers nothing. AC8's test changed with the rule
  (a plan amendment is being written for AC8's wording; review the code, not the AC text).

## Check hardest
1. Rerun the verifier's repro (replay page-1, then with `--colours first/palette.json`): 0 new, no "could not be read", no file; the panel
   offers nothing (Chrome).
2. Alpha edges a real palette hits: `rgba(…, 0.1)` vs `hsla` vs 8-digit hex of the same colour; `0.333` vs `0.33`; fully transparent; an
   opaque and a see-through colour of the same rgb on the site — which links where? Does anything now link a colour to the wrong site colour,
   or reserve a name the paste needs?
3. Without `--colours` / site colours both tools byte for byte as before (`F2B_PIN=1` AC3 pin; B-Dry's real capture copy
   `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`, plain and `--elementor`); review 1–3's probes still hold.
4. This is a fix review after the verifier (the project's review cap counts fix rounds: P0–P2 only with a real-use scenario and a measured
   number; everything else P3).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-4/review.json` (round 4, scope of the fix commits from
`7fa1c0e7292ea0dbfdea020197c562ac590dfefa`; full SHA `head`), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette`. If the script demands a
different scope for round 4, follow what it says and note it. Load `requesting-code-review` and `code-review-practice`; read the project
skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (read it directly; not linked) with `references/testing-pitfalls.md`;
read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spr4/t1`); scripts under `~/.cache/spr4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed"
check both earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
