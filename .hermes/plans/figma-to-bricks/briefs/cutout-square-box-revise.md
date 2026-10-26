# cutout-square-box — PLANNER revise (fast)

Revise mode: read your existing plan `/Users/justin/.hermes/plans/figma-to-bricks/cutout-square-box.md` and evidence `evidence/cutout-square-box/` first, then only the code the change touches. Skip the full Step 1 load. Write the revised plan within about 15–20 steps. Anything still unchecked becomes a builder task.

## New lead from the dispatcher (verify it, don't assume it)

Justin's screenshot `/Users/justin/Library/Application Support/Hermes/composer-images/image_00cea0.png` is **2538 px wide**: a Retina capture of a viewport of about **1269 CSS px**, a **laptop width**, not wide desktop. Your desktop probes (1440/1692/1728) found no square, but your own `found_else` says: **at 1300px the square source displays in a 369.28×469 box with `object-fit: cover`, clipping the subject/shadow at its sides; left-edge luminance step 124.31**. And the uploaded media contains a **baked-in soft shadow**. A cover crop that cuts through a baked shadow (alpha not 0 at the cut) draws a straight edge: a faint square around the cylinder. That is very likely Justin's report.

1. Reproduce at Justin's width: live page at 1269/1280/1300 (and 1366/1200/1100/1024/992), DPR 2, measure straight-edge luminance steps at the picture box's four sides, and compare with his screenshot (crop around x 1600–2350, y 250–750 in the 2538-wide image).
2. Find why the picture box isn't the picture's aspect at laptop widths (hero-media-row column shares? the earlier grid 1.2fr/0.8fr? a fixed height with `object-fit: cover`?) with file/line evidence, and whether main before build 22.9 (b4ed333) did the same at those widths.
3. Plan a general fix: a transparent cut-out (or any picture whose edge pixels are non-zero alpha) must not be cover-cropped into a visible edge — e.g. `contain`, keep aspect, or size the box to the picture — found from structure, never this page. Keep the shadow and will-change (Justin's hero-photo-blend choice). Controls: opaque rounded photos that should still `cover`, transparent cut-outs, and laptop widths 1366–992 plus tablet/phone.
4. If you also show the square at desktop, include it; else say desktop is clean.

Questions at top, lettered, ⭐ recommended; size; Skills; Docs & records; Touches incl. tests pinning current behaviour; overlaps. Always pass `workdir`. No worktree/code/commit.

## Justin's words

> ok perfect the only issue I have right now is you can see around the media on the right there is like a square box around the actual item. Can we remove that box it is subtle but you can see it around the item

Clarified: "A tighter square right around the orange cylinder"; "on figma it does not show that box around the cylinder".
