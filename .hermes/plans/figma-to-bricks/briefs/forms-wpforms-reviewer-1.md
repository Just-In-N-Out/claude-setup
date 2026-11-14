# Role: reviewer (round 1, FULL review of the whole story; report only): forms-wpforms

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site (every Chrome that draws a site capture or paste
launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site (only `test/fixtures/wp-standin.ts` and the
job's WPForms stand-in on 127.0.0.1); touch nothing under `~/Downloads` (a test that clicks a download runs under a scratch HOME with
`.cache/chrome-for-testing` and `.cache/chrome-libs` symlinked in; Justin's scan copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`).
**Importer rule:** one review per job, P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/plan-approved.md` (AC1–AC18; AC17, AC18 live).
  The job (Justin, 2026-11-13: "wpform"): a scanned site's form pastes as a **WPForms** form through Bricks' Shortcode element
  (`[wpforms id="N"]`; Bricks has no WPForms element), the tool writes `wpforms-<name>.json` for Justin to import in WPForms → Tools → Import,
  commands only read the site's form list (GET `wpforms/v1/forms`), messages go to the new site's admin address, never the old site's; the
  old reCAPTCHA key is never copied; the Figma plugin gets a "Forms become: Bricks form / WPForms" option.
- Branch `forms-wpforms-build`, head `6512f7716a6c70513500725dc4a68c7ac9a324b1`, base **importer-parity's fix head** `b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda`
  (not merged; importer-parity is in verification): `git checkout --detach <head>`; review `git diff b232c9de...HEAD`. Builder's evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/builder/` (a head start, not proof); HANDOFF's new top section (W1–W10, Q1–Q10,
  rulings). WPForms source: `reference/wpforms/` (WPForms Lite 2.0.4; memory `wpforms-source-reference`); nothing was run against a real WPForms.
- Builder's found_else: the fixture's body colour isn't pasted (white labels on white in the pictures); B-Dry's Structure shows Block
  "Wpforms" › Block "Box" › "WPForms form" (would a pro fold the inner Box?).

## Check hardest
1. **The import file against WPForms Lite's own import code** (`reference/wpforms/`): would WPForms import it as is, every field type
   (name, email, phone, select, textarea, checkbox, radio) with its label, required, placeholder, choices; the notification to `{admin_email}`
   (never the old site's address, a real paste can't email anyone else); no reCAPTCHA or spam key; a file WPForms would refuse or silently
   drop fields from is P1. Bricks' Shortcode element shape against `reference/bricks/` or Bricks' GPL code.
2. **The id:** the paste before import (`[wpforms id=""]` plus steps), with the read form list (a GET only; no write route anywhere: grep every
   request the tools make), a typed number winning, two forms on a page, a re-import making a new id.
3. **Looks:** the form drawn with WPForms' own CSS as the site (B-Dry's scan both routes, the fixtures, 1440 and 390, Bricks 2.4.2 and 2.3.9,
   at rest, focused, with an error message); the theme settings (WPForms' theme route) vs CSS on the Shortcode's class.
4. **Figma side:** "Forms become" option off = byte for byte the base; on, a drawn form becomes the Shortcode plus the file; the panel's
   single GET.
5. Switch off / no form: byte for byte the base; Figma replays and `dist/` as the plan says; every merged job's pins (`F2B_STORY_PINS=1`).
6. Would a Bricks pro find it logical (the Shortcode labelled, the form editable in WPForms, the notes' steps plain and numbered)?

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/review-1/review.json` (round 1, **scope full**, from `b232c9de…`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda /home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms`. Load `requesting-code-review` and
`code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with
`references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fwr1/t1`); scripts under `~/.cache/fwr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start (kill by PID, never `pkill -f` with a pattern
in your own command line); one Chrome suite at a time (B-Dry files 8G) under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0
/bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. A git-archive tree has no repo (set `GIT_DIR` inside a runner
for tests reading `git show`) and no `dist/`. `cancelled 1` in a test log is a timeout, not a result (`site-controls` needs ~830 s under load).
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's
log and `journalctl --user | grep -E 'oom-kill|OOM killer'`. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each found_else and ruling: holds or not; Bricks-pro notes;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
