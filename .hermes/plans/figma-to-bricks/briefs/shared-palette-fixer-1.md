# Role: fixer (fix round 1): shared-palette — a `--colours` file is never destroyed (R1-1), the tool's own edited colour stays linked (R1-2), plus cheap P3s

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

## Findings (review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-1/review.json`; probes `~/.cache/spr1/s/`)
- **R1-1, P2, `tools/lib/site-write.ts:73-77`:** a `palette.json` passed as `--colours` from the out folder itself (allowed by the paste
  check's step 1; `site:import`'s default folder) is removed when nothing is new, or overwritten with only the new colours. Probe
  `probe-a.sh`/`probe-a2.sh`: run 2 removes it, run 3 exits 1 ENOENT; a 5-colour file flips between 3 and 5 colours each run. Fix: never
  remove or overwrite a file named in `--colours` (compare resolved real paths); write the new colours under a free name beside it and say so
  in one line, or say nothing new was written. Same in all four commands (`site`, `replay`, `site:upload`, `site:import`).
- **R1-2, P2, `src/core/site/colours.ts:88-97` and `src/core/normalise/colors.ts:112-118`:** a palette colour the tool itself made (the
  export holds the paste's own id and variable) whose value Justin changed in Bricks is not recognised with the fresh export: the old value
  comes back as `<name>-2` and every setting and CSS link leaves the site colour (importer fixture: 4 settings + 9 CSS links leave `rczolu` /
  `--color-004774`; Figma file: 3 settings leave `kqyvfy` / `--amber`). Fix (reviewer's smallest, ⭐ take it): a site colour that carries
  the paste's own id and variable is that colour whatever its value now, in both tools (one shared rule; the plugin and the importer must
  still write the same id and variable for the same inputs). No file, the pre-edit file and the fresh export must give the same links.
- **Cheap P3s, take them if each is a few lines:** R1-3 (`tools/site.ts:25-33`: `--colours=<file>` silently ignored by `npm run site`;
  accept it as `replay` does, or refuse it with one line); R1-5 (`tools/lib/site-write.ts:58-64`: `styles.txt` also lists the site colours
  the pastes link, apart from the new ones); R1-6 (`tools/replay.ts:60`: replay removes a stale `palette.json` as `site` does, never the
  `--colours` file); R1-7 (`src/ui/index.html:121`: the download help must not say to delete the old palette when site colours are chosen —
  import the further palette beside it). Leave R1-4 and R1-8 as follow-ups unless they fall out of the fix.

## Do
1. Your own worktree: `git checkout -B shared-palette-fix1 9070c50fdbc305a06ebdafbe3bac873e74d2562b` (base `7b7501bd`).
2. Each finding: verify with the reviewer's probe, RED test first (R1-1: the input inside the out folder over three runs of the same
   command; R1-2: change the value in the export, keep id and name, compare no file / old file / fresh export, in the plugin and the
   importer), GREEN, a mutant per new guard (`mutation-testing-discipline`, under a 4G scope). Rerun AC1–AC10 by name; AC3 with `F2B_PIN=1`.
   Pins re-recorded only by their own tools, saying how many moved and why; without `--colours` / site colours both tools stay byte for byte
   as on `9070c50f`.
3. Gates: `npm run check` (8G scope); `test/web/site-cli.test.ts`, the story's CLI tests, `test/browser/panel-site-colours.test.ts`, one
   Chrome suite at a time (4G). Ledger "Fixer 1" and HANDOFF (the shared-palette section: the two rulings in plain words). Stop at
   `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spf1/t1`); scripts under `~/.cache/spf1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A run killed with 137/143/"Killed": check earlyoom and `journalctl --user | grep -E 'oom-kill|OOM killer'` before reading it.
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait).

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; P3s taken or left; pins moved and why; gates; `skill_lessons[{skill, lesson,
evidence, enforce}]` (never edit skills or memory yourself), ending with: `MAIN SESSION: check and save these skill_lessons now.`
