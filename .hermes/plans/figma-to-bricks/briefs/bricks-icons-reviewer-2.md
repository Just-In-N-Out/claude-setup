# Role: reviewer (Full round 2, milestone M1, the whole story again after fix round 1 — the Figma plugin; report only): bricks-icons

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no
agents. Plain `git` in your own worktree (never `git -C` the main folder). Never load any live site; never write to any WordPress site.
**Rule:** P0–P2 only for bugs a real Figma file converted in the panel and pasted into Bricks 2.3.9/2.4 hits, each with a concrete
scenario; edge cases P3. Figma's sandbox rules are never an edge case (built-ins only in `src/core`/`src/plugin`/`src/shared`; no
`import` followed by `(`/`//`/`/*`; no `<!--`/`-->`; `src/plugin/convert.ts` ≡ replay).

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md` — review **M1 only**
  (AC1–AC7; AC7 live). The job: with "Pictures go: to WordPress" and "Icons as: SVG", a drawn flat-colour icon up to 96 px (no link, no
  description, no state of its own) becomes Bricks' Icon element pointing at its SVG in the media library (shape from
  `reference/bricks/staff-card.json` / the new `icon-svg.json`), with box rules so nothing moves; with Icons off every paste is byte for
  byte as before.
- Branch `bricks-icons-fix1`, head `c78fa0cf` (full SHA with `git rev-parse bricks-icons-fix1`; last code `0e7b82b5`), base
  `0248176342c662b821629d462f4d15a2a2a1df98` (Build 2026-11-11.3; main has since moved to 11.10 — review against the job's own base).
  Review `git diff 02481763...HEAD`. Builder receipts (read, don't trust): `evidence/bricks-icons/builder/`.

## Check hardest
1. Real designs: an icon inside a Button (button-icons already draws it as ::before/::after — conflict?), in a link, in a component with
   variants/hover, a multi-path icon with one colour, a stroked icon, an icon at 97 px, an icon with an effect (shadow), icons in a slider
   copy (phone copies), a repeated icon (one `svg:<id>` file), dark/light mode colours from the palette.
2. Bricks' Icon element as printed: SVG inlined from the media file (file must start `<svg `, root id/class dropped), Fill/Stroke class,
   width/height; Bricks 2.3.9 and 2.4.2; the renderer only adds icon CSS when a paste holds an Icon.
3. The panel: "Icons as: SVG" with "to WordPress" and a connected site; a site refusing SVG → converts again without Icons and says so;
   the inline-pictures mode never makes Icons.
4. Byte-for-byte with Icons off (AC3), plugin ≡ replay, the bundle check.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/review-2/review.json` (round 2, full SHA), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
0248176342c662b821629d462f4d15a2a2a1df98 /home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons`. Load `requesting-code-review`
and `code-review-practice`; read the project skill with `references/rendering-validation.md` (inline-svg lines) and
`references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bi2/t1`); scripts under `~/.cache/bi2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time, each under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`

## Round 2 notes
Review 1 (`evidence/bricks-icons/review-1/review.json`) found R1-1 (P2: a fixed `min-width` floor kept an Icon's box at its drawn width when
shrunk in Bricks) and R1-2 (Height alone ignored: custom-CSS `height: auto` after the control). Fixer 1 (`35bd55e3`, `0e7b82b5`; receipts
`evidence/bricks-icons/fixer-1/`) replaced the floor with `overflow: clip` (Bricks `_overflow`), wrote `height: auto` at zero weight
(`:where(#brxe-…)` via a new `Style.weightless`), and dropped `aspect-ratio`; AC5's test now shrinks icons three ways against the picture
they replace. Review the **whole story** from `02481763` again; check hardest: the fix holds in every row shape and both Bricks versions;
`:where(#brxe-<id>)` survives Bricks rewriting ids on paste (README "Ids on paste": does Bricks rewrite an id inside `:where(…)` in an
element's own custom CSS? read Bricks' paste code in `reference/bricks/` notes); Safari < 16 (`clip` unsupported) is the recorded limit;
the plan's text (lines ~110–114, ~300) still names the old floor — say whether an amendment is needed for any AC wording.
