# Role: fixer (fix round 2): shared-palette — a Figma colour changed in Figma stays exact with a note (R2-1), plus R2-2 and R2-3

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/testing-pitfalls.md`). Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/repeat-mistakes.md`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`). Keep to the standard at the top of the repo
CLAUDE.md "Decisions the user made" (built like a skilled Bricks builder by hand). Never load bdryswi.com, B-Dry staging or any live site;
never write to any WordPress site; touch nothing under `~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`). Commit to your
branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command; no heredocs that write files — use the
Write tool). If you need to figure something out, research it first; if nothing is found, take your best-reasoned answer and record it as a
ruling in the ledger.

## Findings (review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-2/review.json`; probes and logs beside it: `probe-g.ts`, `probe-g.log`)
- **R2-1, P2, `src/core/model/shared-colour.ts:36-44` (`siteMatches`, via `normalise/colors.ts` `onTheSite`):** fix 1's rule "a site colour
  holding the paste's own id and variable is that colour whatever its value now" is right on the importer (its id comes from the value, so a
  match means the site changed it) but wrong on the Figma route: a Figma-named colour's id comes from its Figma variable, so when the designer
  changes Amber in Figma (`#F4C20D` → `#E0A800`) the paste links to the site's old Amber silently (probe G1: 3 settings on `kqyvfy` with
  `var(--amber, #E0A800)` while the page draws `#F4C20D`; the base wrote exact `--amber-2`).
  **Ruling to build (⭐, under the standard's point 6 "exact wins", not yet confirmed by Justin):** on the **Figma route**, a colour links to a
  site colour of its own id only when the values are the same; when they differ, it stays exact as on the base (`<name>-2` with the design's
  value in the further palette) and one note per such colour, in the warnings and the panel's line, names the colour, the site's value and
  the design's value and says how to link it (change the site's colour in Bricks to the design's value, or the design's to the site's).
  The **importer** keeps fix 1's rule. Keep one shared helper the two routes call with their route's rule, so both tools still write the
  same id and variable for the same inputs where the plan says they agree.
- **R2-2, P3 (take it), `shared-colour.ts:42`:** the own-id match compares the site's variable with the paste's unmoved variable, so a colour
  once moved to `-2`, imported and then edited in Bricks comes back as `-3` (probe G2: 9 links `-2` → `-3`). On the importer match on the own
  id alone (whatever its variable).
- **R2-3, P3 (take it), `src/core/site/share.ts:151`:** when `palette-2.json` is written, each part's notes still say "import palette.json
  once"; name the file actually written, as the console, `styles.txt` and `site:import`'s next steps do.
- R1-4 (a note when a colour moves to `-2`) is now part of R2-1's note on the Figma route; on the importer leave it a follow-up unless it
  falls out.

## Do
1. Your own worktree: `git checkout -B shared-palette-fix2 83c9e07e39e2c2965a57ed168ae7001136a5d657` (base `7b7501bd`).
2. Each finding: verify with the reviewer's probe G (point it at your worktree), RED test first (R2-1: a Figma-named colour changed in Figma
   against an unchanged site file stays exact with its note, and fix 1's case — changed in Bricks — still links on the importer; on the
   Figma route a value changed in Bricks is now exact with the note: say so in HANDOFF), GREEN, a mutant per new guard (under a 4G scope).
   Rerun AC1–AC10 by name; AC3 with `F2B_PIN=1`; review 1's probes A, A2, B on the head. Without `--colours` / site colours both tools stay
   byte for byte as on `9070c50f`.
3. Gates: `npm run check` (8G scope); `test/web/site-cli.test.ts`, the story's CLI tests, `test/browser/panel-site-colours.test.ts`, one
   Chrome suite at a time (4G). Ledger "Fixer 2" and HANDOFF (the ruling in plain words, marked not yet confirmed). Stop at
   `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spf2/t1`); scripts under `~/.cache/spf2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A run killed with 137/143/"Killed": check earlyoom and `journalctl --user | grep -E 'oom-kill|OOM killer'` before reading it.
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait).

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; P3s taken or left; pins moved and why; gates; `skill_lessons[{skill, lesson,
evidence, enforce}]` (never edit skills or memory yourself), ending with: `MAIN SESSION: check and save these skill_lessons now.`
