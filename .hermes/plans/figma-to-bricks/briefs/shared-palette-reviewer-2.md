# Role: reviewer (round 2, FIX review of fixer 1's commits; report only): shared-palette

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <file>`, extract separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch
nothing under `~/Downloads`. **Project rule:** a second review only checks the major fix; P0–P2 only for bugs a real paste or normal use
hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11; AC11 live). The
  job: one colour palette for both tools; the site's own palette exports (`--colours a.json,b.json`, the panel's "Colours already on the
  site") are reused, so the palette file each tool writes holds only colours the site lacks.
- Review 1 (full, at `9070c50f`): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-1/review.json`, its probes in
  `~/.cache/spr1/s/` (`probe-a.sh`, `probe-a2.sh`, `probe-b.ts`, …).
- Fix 1: branch `shared-palette-fix1`, head `83c9e07e` (resolve with `git rev-parse shared-palette-fix1`; code ends at `8fa6ddb7`, then a
  ledger commit). Review `git diff 9070c50f..HEAD` and what it touches. Fixer's evidence: `~/.hermes/plans/figma-to-bricks/evidence/shared-palette/fixer-1/`.
  `git checkout --detach <head>` in your worktree.
- What fix 1 claims:
  - R1-1: a `--colours` file is never removed or overwritten (compared by device and inode); new colours go to `palette.json` or the first
    free `palette-<n>.json`, one line says so; `site`, `replay`, `site:upload`, `site:import` (its next steps name the written file).
  - R1-2: one shared rule `model/shared-colour.ts siteMatches`, used by `normalise/colors.ts onTheSite` and `site/colours.ts siteInk`: a site
    colour holding the paste's own id and own variable is that colour whatever its value now; otherwise by value. Two old tests were
    rewritten for this (a hand-made colour under the paste's variable but another id still moves to `-2`).
  - P3s taken: R1-3 (`--colours=<file>` in `npm run site`), R1-5 (styles.txt lists linked site colours), R1-6 (replay removes a stale
    palette.json, never a `--colours` file), R1-7 (panel download help). R1-4, R1-8 left as follow-ups.
  - Ruling and known limit: each part's notes still say "import palette.json once" even when the file written is `palette-2.json`.

## Check hardest
1. Rerun review 1's probes A, A2 and B on the head (point them at your worktree): R1-1 and R1-2 gone, in both tools.
2. The new rule's edges a real paste hits: Justin renames a colour in Bricks (same id, other variable), deletes and re-imports a palette,
   gives two exports where one holds the tool's colour at its old value and the other at the new; two pages of one site; the Figma
   panel with site colours. Does anything now link a colour to the wrong site colour?
3. Without `--colours` / site colours both tools stay byte for byte as on `9070c50f` (`F2B_PIN=1` AC3 pin; B-Dry's real capture copy
   `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/` plain and `--elementor`, base vs head out folders).
4. Is the "palette.json" wording in the notes vs `palette-2.json` a P2 a real run hits (Justin imports the wrong file?) or P3?
5. The standard (repo CLAUDE.md top of "Decisions the user made"): would a Bricks pro find the palette files and names logical?

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-2/review.json` (round 2, scope of the fix commits from
`9070c50fdbc305a06ebdafbe3bac873e74d2562b`; full SHA `head`), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette`. If the script demands a
different scope for round 2, follow what it says and note it. Load `requesting-code-review` and `code-review-practice`; read the project
skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (read it directly; not linked) with `references/testing-pitfalls.md`;
read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spr2/t1`); scripts under `~/.cache/spr2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed"
check both earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
