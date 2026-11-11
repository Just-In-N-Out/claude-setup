# Role: planner (plan amendment 1, before any build): site-shared-styles — palette names by value (shared-palette Q4 A)

You are a fresh planner (**Fable 5.2, high**). Amend the approved plan; change no source or test, commit nothing, start no
agents; never load any live site. Work under `~/.cache/ssa1/`. Load `implementation-planning`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the plan-amendment paragraph: an
Amendments list at the top, changed lines marked `[amended]`, `ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes run
on old and new with ids, live set and cited test names unchanged unless the amendment says why, no Amendments-list line
starting with an AC id, each cited test name whole on one line).

## Why
site-shared-styles (approved, not yet built; it builds after site-no-div) planned palette colours named per page
(`--<page>-<hex>`, ids `site-color:<page>:<#HEX>`; its Q4 A and AC6). The new job **shared-palette** (approved:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md`, read it) found that one blue then
becomes two or three palette colours on one site (the plugin's `color-<hex>`, the importer's `--home-<hex>`, a second
page's `--about-<hex>`), and Bricks 2.4.2's import never checks a colour id against other palettes. Its Q4 A (Justin's "go
with recommended"): **the importer's naming change lands inside site-shared-styles' build**, so B-Dry's palette is never
imported under `--home-…` first: an unnamed colour is `--color-<hex>` with an id from the hex alone, the same rule the
plugin uses for files without colour names (shared-palette AC1's shape). The palette's own name `<page> (<host>)` and
site-shared-styles' Q5 (every solid colour) stay. Reading the site's existing palette (`--colours`) stays in
shared-palette, not here.

## Amend
- Approved copy (read-only, your base): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md`.
- Change Q4's answer and every line that names `--<page>-<hex>` / `site-color:<page>:…` (AC6's wording, the palette
  design, tasks, examples like `--home-004774`) to the by-value rule, matching shared-palette's id computation exactly
  (read its `planner/ids.ts`/`ids.txt` and the plugin's `src/core/normalise/colors.ts`), so the two plans produce one id
  for one colour. If an AC's cited test name must change, say why in the Amendments list.
- Name the files shared with shared-palette and which job writes which line (shared-palette's Task 2 moves here or
  stays — say which, so neither builds it twice).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/planner-amend-1/plan-amended.md` with the regex
receipts beside it (the main session installs it read-only, keeping the old copy as `plan-approved-v1-before-amendment-1.md`),
and a one-paragraph note `…/planner-amend-1/for-shared-palette.md` saying what shared-palette's builder must now skip.

## Report (as text)
The amended plan's path and sha256; each change in one line; the regex receipts; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
