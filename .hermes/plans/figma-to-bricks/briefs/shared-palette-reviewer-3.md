# Role: reviewer (round 3, FIX review of fixer 2's commits; report only): shared-palette

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <file>`, extract separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch
nothing under `~/Downloads`. **Project rule:** a second review only checks the major fix; P0–P2 only for bugs a real paste or normal use
hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11; AC11 live). The
  job: one colour palette for both tools; the site's own palette exports (`--colours a.json,b.json`, the panel's "Colours already on the
  site") are reused, so the palette file each tool writes holds only colours the site lacks.
- Reviews 1 and 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-1/review.json`, `…/review-2/review.json`
  (review 2's probes `probe-g.ts`, `probe-g.log` beside it; review 1's in `~/.cache/spr1/s/`).
- Fix 2: branch `shared-palette-fix2`, head `7fa1c0e7` (resolve with `git rev-parse shared-palette-fix2`; code ends at `584c8bb2`, then a
  ledger/HANDOFF commit). Review `git diff 83c9e07e..HEAD` and what it touches. Fixer's evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/shared-palette/fixer-2/`. `git checkout --detach <head>` in your worktree.
- What fix 2 claims:
  - R2-1: `siteMatches(site, colours, rule)` in `src/core/model/shared-colour.ts` takes the route's rule: the Figma plugin links a site colour
    of its own id only at the same value, else keeps the design's value exact (`<name>-2` in the further palette, as the base) with one
    note per colour (warnings, `ConvertResult.siteColourNotes`, the panel under the "reused" line); the importer links by its own id
    whatever the value or variable.
  - R2-2: on the importer the own-id match ignores the variable (no `-3`). R2-3: each part's notes name the palette file actually written.
  - Rulings (not yet confirmed): the plugin's rule covers every colour, named or not (an unnamed Figma colour changed in Bricks is now exact
    with a note on the plugin, linked on the importer); the note's label is the Figma name, else the hex; the note shows twice in the panel;
    on the plugin its own id at the same value links whatever its variable.

## Check hardest
1. Rerun review 2's probe G (G1, G2) and review 1's A, A2, B on the head: R2-1 exact with the note, R2-2 gone, R1-1 and R1-2 still hold on
   the importer.
2. The note: right values, right file named, shown once per colour per conversion, never on a paste without site colours; the panel line
   in Chrome (look at `fixer-2/shots/panel-4-colour-note.png` and make your own).
3. Both tools still agree where the plan says they do (AC1, AC7: same id and variable at matching values).
4. Without `--colours` / site colours both tools stay byte for byte as on `9070c50f` (`F2B_PIN=1` AC3 pin; B-Dry's real capture copy plain
   and `--elementor`).
5. The standard: would a Bricks pro find the `-2` colours plus the note logical? This is the job's last review round (project cap: 3):
   P0–P2 only with a real-use scenario and a measured number; everything else P3.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-3/review.json` (round 3, scope of the fix commits from
`83c9e07e39e2c2965a57ed168ae7001136a5d657`; full SHA `head`), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette`. If the script demands a
different scope for round 3, follow what it says and note it. Load `requesting-code-review` and `code-review-practice`; read the project
skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (read it directly; not linked) with `references/testing-pitfalls.md`;
read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spr3/t1`); scripts under `~/.cache/spr3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed"
check both earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
