# Role: reviewer (Mini, round 3: the fix commits only, report only): site-reviews

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging, an embed host or any live site (local stand-ins and saved
files only); never write to any WordPress site; no logins. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run capture -- <a real site>` then `npm run site` with or without `--elementor`, its
third-party widgets pasted on a Bricks 2.3.9 / 2.4 site; captures and pastes of sites without widgets as before; Figma
designs converting as before), each with a concrete real-use scenario. Edge cases are P3. What may run on Justin's site
after a paste is the thing to check hardest: a P0/P1 if anything beyond a widget's own served code can ride along.
**This is the last review round of this job** (the project caps review rounds at 3): what is not a real-use bug goes to
P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md`.
- Branch `site-reviews-fix2`, head `6fb06ea2b1d3f451d3a3a6c51cd53915fca0b117`, on local `main`
  `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3). In your own worktree: `git checkout --detach
  6fb06ea2b1d3f451d3a3a6c51cd53915fca0b117`, confirm `git rev-parse HEAD` and a clean status.
- **Scope: the fix commits `git diff 77bd97f5506cbb59c53bebffa58e0bc07dbbc1f5..HEAD` and what they touch** (the code
  change is `src/web/read/embeds.ts` `ownPlace`, commit `339c8d82`; new tests `test/web/site-widget-codes.test.ts`,
  `test/web/capture-widget-alone.test.ts` and their fixtures; HANDOFF and ledger).
- Review 2 (the finding this fixes, R2-1, and its probes): `evidence/site-reviews/review-2/review.json`,
  `~/.cache/srv-r2/probes/` and `~/.cache/srv-r2/logs/`. The fixer's receipts (read, don't trust):
  `evidence/site-reviews/fixer-2/` (`verify/`, `red-final/`, `green/`, `mutants/`, `gates/`).
- The fixer's rule: a script tag alone is a widget's whole code only where the capture proves it draws the widget by
  itself — (1) the tag is all the code its box was served with (no other script, style, link or template at any depth;
  a noscript's content doesn't count), (2) the script replaced nothing (the box's live parser-made children, the tag
  aside, are its served children in order), (3) what it drew stands where the tag was served; any doubt keeps the copy.
  One behaviour change from round 1: a box holding the same tag twice is now a copy.
- Check: is R2-1 really closed (the two embed-code shapes and others like them: a tag after its placeholder, a tag
  before it, an inline call before or after its library); does the stricter rule take away a widget that pasted live at
  the reviewed head on a real site (round 1's Trustindex shape on an Elementor page, plain and `--elementor`; a loader
  beside words; a loader in a WordPress post body that also holds unrelated inline scripts or styles — how common, and
  is the copy an acceptable result there); are the new tests able to fail (read the mutant receipts; try one of your
  own); do captures without widgets and older captures still paste byte for byte; the note's words (never "pastes live"
  for a copy).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the embeds lines) and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope for real bugs (three trees per probe where it helps: base, `77bd97f5`, head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/review-3/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/srv-r3/tmp`,
  its own per concurrent Chrome job: two runs sharing one close each other's Chrome);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after.
  Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file written
  with Write; keep probes and logs under `~/.cache/srv-r3/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
