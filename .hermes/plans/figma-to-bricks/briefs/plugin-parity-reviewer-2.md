# Role: reviewer (round 2, FIX review of fixer 1's commits after the auditor; report only): plugin-parity

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <file>`, extract separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch
nothing under `~/Downloads`. **Project rule:** a second review only checks the major fix; P0–P2 only for bugs a real paste or normal use hits
(a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live). The
  job: a Figma paste holds no Div, every Section and Block labelled, repeated looks in shared classes (AC6–AC10: one name, id and settings on
  every page; Bricks never asks "Import classes" about a look), drawn exactly as before.
- Review 1 clean on `89e41a0d`; the blind auditor then found AC9/AC10 false (`evidence/plugin-parity/auditor/ac.json`, its `own-*.log`): a
  look's name and id came from typed values while its settings write palette references.
- Fix 1: branch `plugin-parity-fix1`, head `beeacc8f72b1fa4c21d52f9e4ca690bf75a4c9c7` (`git checkout --detach beeacc8f…`); review
  `git diff 89e41a0d..beeacc8f` and what it touches (`src/core/emit/looks.ts`, `src/core/emit/elements.ts`, goldens
  `convert-sample.json` and `cta-names-base.json`, the test-only pin `site-upload-panel-unchanged` through `figmaSum` opts, two new tests).
  Fixer's evidence: `~/.hermes/plans/figma-to-bricks/evidence/plugin-parity/fixer-1/`.
- What fix 1 claims: a look's name and id come from `design|kind|written settings` (emit's own class settings, palette and design width
  included); typed groups that write alike merge into one look (gaps 15.2 and 15 both `15`); ruling: a look whose colour moves to a palette
  variable becomes a new class, the old one stays unused, nothing asked.

## Check hardest
1. Rerun the auditor's probes (`own-pairs`, `own-var-added`, `own-palette-conflict`) on head: 0 look asks.
2. The merge of alike groups: can two looks that draw differently ever merge (rounding hiding a visible difference, a state or tier lost);
   does any element's resolved settings change (AC7)? Draw base 7b7501bd vs head at the design width and 390 on both Bricks versions.
3. The goldens' regeneration: only look ids and names moved (check yourself, reading every class by its settings).
4. The pin change: still proves site-media-upload changed no Figma paste; a stray-file and a one-byte mutant still fail it.
5. The standard: would a Bricks pro find the look class names and the "new class on a colour change" ruling logical?

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/review-2/review.json` (round 2, scope of the fix commits from
`89e41a0d071f25aa2c68c913c0a9b6167fe99557`; full SHA `head`), in review-1's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity` and quote its last line; if it asks for
another scope, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppr2/t1`); scripts under `~/.cache/ppr2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
A git-archive tree has no repo (set `GIT_DIR` to your worktree's gitdir inside a runner for tests reading `git show`) and no `dist/`. Use
`tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's log
and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
