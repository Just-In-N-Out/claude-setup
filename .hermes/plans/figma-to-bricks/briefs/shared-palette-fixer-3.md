# Role: fixer (fix round 3, after the verifier): shared-palette — see-through site colours are the site's, never re-listed (F1)

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

## Finding (verifier: `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/verifier/ac.json`, `finding-F1-seethrough.log`, `.png`)
- **F1, P2 (makes AC6, AC7, AC10 false):** a Figma file whose palette holds see-through (rgba) colour variables gets them back as "new"
  colours when its own palette file is given as the site's colours. Repro on Justin's real `figma-to-bricks-debug-page-1.json` (repo root):
  `npm run replay -- figma-to-bricks-debug-page-1.json first` writes palette.json (122 colours, 73 rgba); `npm run replay --
  figma-to-bricks-debug-page-1.json again --colours first/palette.json` gives the same paste but also writes "… (Figma) 2" holding all 73 —
  each with the site's own id, variable and value (`{"id":"znigsc","raw":"var(--color-white-10)","light":"rgba(255, 255, 255, 0.1)"}`); the
  notes say "73 new" and "73 of the site's colours could not be read"; the panel offers "Download colour palette (73 colours)". Importing
  that file in Bricks would add 73 duplicate ids and variables (reference/bricks/README.md: a palette file must never hold a colour, id or
  variable the site has).
  Cause: `src/core/site/palette-files.ts` `siteColours` skips a site colour whose light is see-through, so it never enters `site.colours`;
  `normalise/colors.ts` `onTheSite` neither holds nor reserves it; `emit/palette.ts` `paletteFile` and the panel's `keepPalette`
  (`src/ui/palette.ts`) list it again.
  **Fix (⭐):** a see-through site colour is read as the site's (its id, variable and value, alpha kept), so a page colour of the same value
  (and, by each route's own-id rule, the same id) links to it and the palette file never re-lists it; any site colour skipped as unreadable
  still reserves its id and variable so no written colour can take them. The "could not be read" count then covers only colours that truly
  can't be read. Check what the importer does with a see-through site colour too (its palette holds only opaque ones today; keep it byte for
  byte where nothing changes).
- Add a round-trip test on the real file, as the verifier proposed: replay `figma-to-bricks-debug-page-1.json` with its own palette.json as
  `--colours` and assert no palette file, no "new" colours, the panel's download hidden — in `npm run check`.

## Do
1. Your own worktree: `git checkout -B shared-palette-fix3 7fa1c0e7292ea0dbfdea020197c562ac590dfefa` (base `7b7501bd`).
2. Verify with the verifier's repro, RED test first (the real-file round trip; a fixture palette with an rgba colour for the panel), GREEN,
   a mutant per new guard (under a 4G scope). Rerun AC1–AC10 by name; AC3 with `F2B_PIN=1`. Without `--colours` / site colours both tools
   stay byte for byte as on `9070c50f`; review 1–3's probes still hold (`~/.cache/spr1/s/`, `evidence/shared-palette/review-2/`, `review-3/`).
3. Gates: `npm run check` (8G scope); `test/web/site-cli.test.ts`, the story's CLI tests, `test/browser/panel-site-colours.test.ts`, one
   Chrome suite at a time (4G). Ledger "Fixer 3" and HANDOFF. Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spf3/t1`); scripts under `~/.cache/spf3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A run killed with 137/143/"Killed": check earlyoom and `journalctl --user | grep -E 'oom-kill|OOM killer'` before reading it.
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait).

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; P3s taken or left; pins moved and why; gates; `skill_lessons[{skill, lesson,
evidence, enforce}]` (never edit skills or memory yourself), ending with: `MAIN SESSION: check and save these skill_lessons now.`
