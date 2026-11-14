# Role: fixer (fix round 1, after the auditor): plugin-parity — a look's name and id follow its settings as written (AC9, AC10)

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

## What failed (ac-check.sh on 89e41a0: `NOT ACCEPTED: 2 of 18 ACs on 89e41a0` — AC9 and AC10; both reports to read in full:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/verifier/ac.json` and `…/plugin-parity/auditor/ac.json` with the auditor's
own logs `own-var-added.log`, `own-pairs.log`, `own-palette-conflict-head.log` beside it)
- **AC9** ("one name, id and settings") and **AC10** (Q4 A: Bricks never asks "Import classes" about a look) are false in a realistic case:
  a look's name and id come from the typed RGBA (`src/core/emit/looks.ts:126`), while its settings are written through `colorOut` as palette
  references. So card-sche has one id on hydraulics and repairs with different settings, card-mokn on hydraulics and services; converting a
  page with no colour variables and again after the designer adds one (Brand/Navy) keeps card-fnvp's and button-ykfb's name and id but
  changes their settings (`var(--color-0f2a3d, …)` → `var(--brand-navy, …)`). Bricks' class comparison (`test/fixtures/bricks-paste.ts`)
  asks 8 times on real page pairs, base 0. Review 1's R1-4 named the same root (P3 then).
- **Fix (⭐):** key a look's name and id on its settings as written (the palette reference included, as Bricks stores them), so equal
  settings share one id and name and different settings never share either; a look whose colour moves to a palette variable becomes a new
  class (the old one stays unused on the site: say so in the notes and HANDOFF). Keep the purpose prefix and every other clause of AC9 (two
  texts of a new look rename nothing; no `{}`) and AC6–AC8, AC16, AC17 as they are. Prove it on the auditor's cases: the real page pairs
  (hydraulics/repairs, hydraulics/services, both orders) and a page converted without `colors`, with an empty palette and with one variable
  added — `bricksClassConflicts` asks 0 about look classes — and add that as a unit test in `npm run check` (e.g.
  `test/unit/emit-class-paste.test.ts`).
- Also, merge prep the verifier named (test-only): `test/unit/site-upload-panel-unchanged.test.ts` "AC13 Figma designs convert byte for byte as
  on main" (`F2B_STORY_PINS=1`) fails on head by design: regenerate `test/fixtures/site-media-base/figma.sha256.json` with its own tool or
  retire the pin, saying why; then run every file that greps `F2B_STORY_PINS` on head and base by name.

## Do
1. Your own worktree: `git checkout -B plugin-parity-fix1 89e41a0d071f25aa2c68c913c0a9b6167fe99557` (base `7b7501bd`).
2. RED first on the auditor's cases, GREEN, a mutant per new guard (under a 4G scope). Rerun AC1–AC17 by name (AC14 with `F2B_STORY_PINS=1`);
   the drawing base vs head on the real saves at the design width and 390 (0 moved; wait past the paste's largest Interaction delay).
3. Gates: `npm run check` (8G scope); the job's browser tests (plugin-blocks, plugin-looks, plugin-sticky-guard, plugin-parity-lint), one
   Chrome suite at a time (4G). Ledger "Fixer 1" and HANDOFF. Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppf1/t1`); scripts under `~/.cache/ppf1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A run killed with 137/143/"Killed": check earlyoom and `journalctl --user | grep -E 'oom-kill|OOM killer'` before reading it.
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait).

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; P3s taken or left; pins moved and why; gates; `skill_lessons[{skill, lesson,
evidence, enforce}]` (never edit skills or memory yourself), ending with: `MAIN SESSION: check and save these skill_lessons now.`
