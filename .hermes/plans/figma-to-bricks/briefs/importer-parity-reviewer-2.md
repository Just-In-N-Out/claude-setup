# Role: reviewer (round 2, FIX review of fixer 1's commits; report only): importer-parity

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <file>`, extract separately; scripts with the Write tool, no heredocs). Never load any live site (every Chrome that draws a site capture
or paste launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`; libraries served locally); never write to any WordPress site; touch
nothing under `~/Downloads`. **Importer rule:** a second review only checks the major fix; P0–P2 only for bugs a real paste or normal use
hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live).
- Review 1 (full, at `da538e12`): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/review-1/review.json` (R1-1 Swiper per
  view from live params; R1-2 `slidesPerView: "auto"`; R1-3 Vimeo `h`; R1-4 a Form's looks by `:nth-child`; R1-5 fixed hover wait; R1-6
  YouTube `rel`, Vimeo background).
- Fix 1: branch `importer-parity-fix1`, head `b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda` (`git checkout --detach b232c9de…`); review
  `git diff da538e12..b232c9de` and what it touches. Fixer's evidence: `~/.hermes/plans/figma-to-bricks/evidence/importer-parity/fixer-1/`.
  Its claims: the reader keeps `swiper.originalParams` (`given`), per view and gap from it and its breakpoints, an older capture with
  breakpoints stays static, named; `"auto"` stays static; `vimeoHash`, `youtubeRel`, Vimeo byline/title/portrait set where the site leaves
  them on, `background=1` stays a Code element; the Form's shared looks in its own controls (fieldPadding, fieldBackgroundColor,
  fieldTypography, fieldBorder, labelTypography, fieldMargin, submitButton*), state-changed looks CSS, per-field looks keyed by kind or the
  field's own id, no `:nth-child`; `test/browser/render.ts` prints a Form's Border controls like `_border`; `site-slider-unchanged` sums
  regenerated (the Form changed by design). Rulings 11–14 in HANDOFF (not yet confirmed).

## Check hardest
1. The Form (the major fix): its control keys and shapes against Bricks' GPL `form.php` / `reference/bricks/` (memory `bricks-source-research`);
   a key Bricks ignores or rewrites is P1. Redo review 1's edits (delete, add, move a field) yourself on `parity-form` and on a B-Dry-shaped
   simple form of your own, at 1440 and 390 on Bricks 2.4.2 and 2.3.9; and one more normal edit: change the Field background in Bricks'
   control (does every field follow?). Hover and focus looks still as the site.
2. The renderer change: Bricks really prints `submitButtonBorder` that way (assets.php by control type), so the test isn't made to pass.
3. Swiper: the real library with mobile-first breakpoints, a desktop-first one (`breakpoints` with max widths via `breakpointsBase`?), and
   `"auto"`; Elementor carousels unchanged.
4. Switch off byte for byte the base (608 pastes), Figma replays and `dist/` byte for byte; the regenerated sums move only the Form.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/review-2/review.json` (round 2, scope of the fix commits from
`da538e12b50bb845cc227ff9c5dc93dc8108a60b`; full SHA `head`), in review-1's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity` and quote its last line; if it
asks for another scope, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipr2/t1`); scripts under `~/.cache/ipr2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A git-archive tree has no repo (set `GIT_DIR` inside a runner for tests reading `git show`) and no `dist/`. Use `tail -n 3`. Waits
under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's log and `journalctl
--user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
