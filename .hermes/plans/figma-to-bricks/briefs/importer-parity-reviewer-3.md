# Role: reviewer (round 3, FIX review of fixer 2's commits; report only): importer-parity

You are a fresh reviewer who never saw the build or the fixes (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <absolute path> <sha>`, extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site
(every Chrome that draws a site capture or paste with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site;
touch nothing under `~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`). **Importer rule:** this second look only checks the
fix; P0–P2 only for bugs a real paste hits (a scenario and a measured number). Keep it to about 30 minutes.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live).
- What failed: the verifier (`evidence/importer-parity/verifier/ac.json`, AC13): a pasted Splide slider's arrows drew 0×0 (the svg's bare
  `width: 40; height: 40` spread onto the `::before` after the px size in `src/core/site/slider-look.ts` `drawing()`), while AC13's test
  compared only boxes; and the earlier story's pin `site-shared-styles-off` failed on head.
- Fix 2: branch `importer-parity-fix2`, head **`745578889c56baf81a58110770a5513b6c67c7d4`** (code head `f47c3b80`). Review `git diff
  b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda..74557888` and what it touches. Fixer's evidence: `evidence/importer-parity/fixer-2/` (a head start,
  not proof). Claims: bare svg sizes get px (1e538102); an svg with no declared fill takes its inherited fill (nearest ancestor's declared
  fill, else its shapes' own fill attribute, else black) instead of `currentColor` (f47c3b80); AC13's cited test, under its unchanged name,
  compares each arrow's drawing (size within 2 px, a glyph arrow not 0×0, the colour) at 1440 and 390 on both Bricks versions; a new unit
  test `test/unit/site-slider-look.test.ts`; the pin keeps Milestone 1's 608 with `parity: false` and a second pin of the on-state
  (`test/fixtures/site-shared-styles-parity-pins.json`, `tools/site-shared-styles-parity-golden.ts`); B-Dry's pastes byte for byte b232c9de.

## Check hardest
1. The fill rule against what browsers do for real arrows: an svg inside a coloured button whose path uses `fill="currentColor"`, one with
   `fill` on the svg, on a `<g>`, by a class in the site's CSS, `fill: inherit`/`unset`, a stroked chevron with `fill="none"` — the paste's
   chevron colour matches the site's in every case (both libraries, hover too); no slider that drew right before now draws wrong (the
   Elementor carousels, `site-elementor-slider`, `site-elementor-carousels`, Justin's scan both routes).
2. AC13's cited test fails on b232c9de on its own new assertion and on a mutant restoring the old spread order.
3. The pin change keeps the earlier story's oracle meaningful (test 1 = Milestone 1's 608 with the switch off; test 2 a golden made on this
   tree) and nothing else moved.
4. The fixer's note: the site side of `pictures/parity-natives/sliders-page-390-site-paste.png` draws its slides empty at 390 — a capture
   artefact or a test that hides a real difference?

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/review-3/review.json` (round 3, scope delta from
`b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda`, full SHA `head`), in review-2's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity` and quote its last line; if it
asks for another scope, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipr3/t1`); scripts under `~/.cache/ipr3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill -f` with a pattern in
your own command line); before each Chrome suite check `/proc/loadavg` (above ~40: unit work first); one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`). Use `tail -n 3`.
Waits under 115 s. `cancelled 1` is a timeout. SIGTERM/143/137/"Killed": check earlyoom's log first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
