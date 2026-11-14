# Role: reviewer (round 1, FULL review of the whole story; report only): plugin-parity

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site. P0–P2 for bugs a
real Figma design or normal use hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live). The
  job: the Figma plugin's paste gets what the importer gained — no Div (every frame and shape a Block; only an inlined picture a Div), every
  Section and Block labelled, repeated looks in shared classes (text, button, box, layout; rules S1–S5) decided in emit after adapt, the
  sticky-header guard; nothing moves (0.5 px every tier, Bricks 2.3.9 and 2.4.2); website captures in the panel byte for byte.
- Branch `plugin-parity-build`, head `89e41a0d` (resolve with `git rev-parse plugin-parity-build`; the builder's moved gate head was
  `13d092aa`), base **site-shared-styles' head** `7b7501bd082ae44a99985aac4d080c9b70b67c53` (not merged): `git checkout --detach <head>`; review
  `git diff 7b7501bd...HEAD` (17 commits).
- Builder's rulings (judge each): the sticky guard carries the importer's two `no-scroll` lines; `sectionLabel` in `src/shared/section-label.ts`;
  B2 judged on the element's final look after every style wrapper; childless Blocks "Spacer"/"Shape"; a text's font axes, a background picture
  and an element's own tier display kept on the element, not in a look; three test edit sites outside the plan's list.
- Read the standard at the top of CLAUDE.md "Decisions the user made" (the main folder's): ask "would a Bricks pro find this logical and easy
  to change?". The builder named: former Divs carrying `Width: auto` / `Flex wrap: nowrap` / `Display: block`; layout looks like `column-xxxx` on
  many unrelated Blocks (editing one moves them all); four-letter names; page-wide rules in a sticky header's own CSS; "Spacer"/"Shape" labels.
  Say which are real problems for Justin now (P2) and which later jobs (look-grouping, short-class-names, clean-values) cover.

## Check hardest
1. Real designs: the five real saves and the other saved Figma files (`references/testing-pitfalls.md` lists six more), both picture modes,
   ticks on and off, drawn with Bricks 2.3.9 and 2.4.2 CSS at every tier: anything that moves, hovers differently or loses a phone rule; a look
   class that out-weighs or is out-weighed by an element's own settings or an adapt rule's tier write.
2. Bricks' Import classes on paste (`test/fixtures/bricks-paste.ts`): two pages of one file, a page pasted twice, a page after one sharing looks.
3. The plugin's own paste = replay (`plugin-convert`), sandbox built-ins only; the panel's website route byte for byte.
4. Test edits: no assertion weakened beyond a label-based locator; goldens regenerated honestly.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/review-1/review.json` (round 1, **scope full**, from `7b7501bd`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity`. Load `requesting-code-review` and
`code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` directly (not linked) with
`references/testing-pitfalls.md` and `references/rendering-validation.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppr1/t1`); scripts under `~/.cache/ppr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check both
earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`. If you must figure something out, research first; else best judgment.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each builder's ruling: holds or not; Bricks-pro notes;
`verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
