# cutout-square-box — PLANNER brief (Figma to Bricks V2)

You are the **PLANNER** for the Figma plugin bug **cutout-square-box**. Write a plan Justin will approve. Build nothing: no worktree, branch, code or commit.

## The ask (rewritten)

**Bug:** in the service-page hero, the picture on the right is a transparent cut-out of an orange hydraulic cylinder. On the site, a **faint square box** shows **tightly around the cylinder picture itself**: a subtle rectangle edge where the picture's bounds are, slightly darker or lighter than the truck photo behind it. **In Figma there is no box around the cylinder.**

**Expected:** the cut-out blends into the background with no visible rectangle at any width, while keeping everything else the design draws (the cylinder's own shadow if Figma has one, the hero photo's blend, and the separate large rounded frame around the right column, which Justin did not ask to remove).

**Done looks like:** on the pasted page, no rectangle or seam is visible around the cylinder at desktop, laptop, tablet and phone widths; ordinary pictures and shadows elsewhere are unchanged; the general fix is found from structure, never keyed to this page.

## Screenshot (attached; described)

Live desktop hero of "Remanufactured Hydraulic Cylinders" on Justin's All Type Hydraulic site. Dark grayscale truck photo behind everything. Text column on the left. On the right, a large, very faint rounded frame (that one is drawn in the design; **not** the subject). Inside it, the orange cylinder cut-out, and around the cylinder a faint **square/rectangular box**: Justin's complaint. Zoom on the cylinder's bounding area to see it.

Live page (read only, add `?nocache=<timestamp>`): `https://darksalmon-badger-335429.hostingersite.com/remanufactured-hydraulics-cylinders-final/`. It's unknown whether Justin has already pasted build 2026-10-22.9 (hero-media-row); check what's live vs what main emits.

## History you must read first

- **hero-photo-blend** (merged, build 2026-10-21.24, paste check 3ax, this same hero): Justin chose **option 2: `will-change`**, accepting intermittent iOS loss, caption overlap and extra layer memory. Read `~/.hermes/plans/figma-to-bricks/hero-photo-blend.md` and its evidence. A promoted compositing layer, a blend mode, a filter, or a drop-shadow on that layer can each paint a visible rectangle; find which one does here.
- **hero-media-row** (merged, build 2026-10-22.9): kept this picture beside the text and reshaped its column; its plan says "hero-photo-blend's cut-out filter/shadow is untouched". Confirm.
- Project skill pitfall **"A visible rectangle or seam around a picture"** and `references/rendering-validation.md` in the figma-to-bricks skill: load and follow it. Inspect the emitted shadow first; a box-shadow vs drop-shadow mistake, a background on the picture's wrapper, a non-transparent image encode (alpha lost at upload/format conversion, e.g. AVIF/JPEG), or a layer promoted by `will-change`/blend can all cause it. Compare the Figma data for the cylinder with the emitted CSS and the actual uploaded file's alpha.
- Any change to rendering/compositing needs the compatibility gate in `rendering-validation.md` (browsers, transparent cut-outs **and** opaque rounded photos as controls) in the plan's tests.

## Rules

- Root cause with file/line evidence and a Chrome reproduction (pixel measurement at the box edge, before/after), checked against Figma data from the user's debug JSON (read only; copy to scratch before replaying). The sister "Hydraulic Cylinder Repairs" page uses the same template.
- If the cause is site state (e.g. the uploaded media lost its transparency), say so and give the repair path for already-pasted pages.
- If the fix would change Justin's earlier hero-photo-blend decision, make it a lettered question.
- Open questions at the top (lettered options, ⭐ recommended), plan written as if ⭐ were chosen. Add `## Skills` (mark Agent Defect Loop skills via `grep -l 'Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`). End with a **Docs & records** task. List tests pinning current behaviour under Touches. Name file overlaps with any open board features (`python3 -I ~/.hermes/scripts/dispatch_status.py --all`).
- Say the size (small / in-between / big) in the plan.
- Anything else found → `found_else`, not fixed.

## Output

Save to `~/.hermes/plans/figma-to-bricks/cutout-square-box.md`; evidence to `~/.hermes/plans/figma-to-bricks/evidence/cutout-square-box/`. Plain words for a phone reader.

## Justin's words (verbatim)

> ok perfect the only issue I have right now is you can see around the media on the right there is like a square box around the actual item. Can we remove that box it is subtle but you can see it around the item

Clarified in the desktop app: the box is **"A tighter square right around the orange cylinder"**, and **"on figma it does not show that box around the cylinder"**.
