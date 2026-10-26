# cutout-square-box — BUILDER brief (Figma to Bricks V2)

You are the **BUILDER** for **cutout-square-box**. The plan is approved: build it, don't re-plan.

- Plan: `/Users/justin/.hermes/plans/figma-to-bricks/cutout-square-box.md` (read it whole: Diagnosis, Proposed general correction (Q1 A), Acceptance contract, Ordered builder tasks, Touches, Docs & records).
- Evidence: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/cutout-square-box/` (incl. `revise-laptop/`).
- Worktree `~/Documents/FigmaToBricksV2/.claude/worktrees/cutout-square-box`, branch exactly `worktree-cutout-square-box`, from local main (`824bb71`, BUILD 2026-10-22.9).
- Model: ChatGPT Sol 6.1 xhigh, whole pipeline (Justin's pick).

## The bug and the approved fix
On laptop widths (~1024–1440px) the plugin caps a flow picture's width as its column narrows but keeps its fixed height (`sizing.ts:236–238,253–256`), and the picture uses `object-fit: cover` (`picture.ts:38,59–64`); the aspect is only restored below 991px (`media.ts:19`). A transparent cut-out with a baked-in soft shadow gets cropped through the shadow, drawing a straight "square box" edge (left-edge luminance steps ≈117/159/142 at 1269/1280/1300; subtle at 1366/1440). Pre-existing (same on b4ed333).

**Justin approved Q1 A:** "Go: keep pictures' drawn shape as columns narrow (shadow + blend kept)". Preserve ordinary flow pictures' drawn aspect as their columns narrow; keep shadows, `will-change` (his hero-photo-blend choice) and intentional cover crops (opaque FILL photographs keep their drawn frame ratio and cover; no blanket `contain`, no switch to natural asset ratio).

## Skills (in order, say so first)
1. `figma-to-bricks` BUILDER role (rules-summary first; also `references/rendering-validation.md` and the "visible rectangle or seam around a picture" pitfall), Step 1–3, skipping Step 3 item 6.
2. `engineering-best-practices`. 3. `test-driven-development`. 4. `systematic-debugging` on surprises. 5. `mutation-testing-discipline` for the new invariant. 6. `frontend-ui-repair` (Agent Defect Loop; you're the implementation agent; skip subagent/auto-fix steps). Return `defect_loop_skills[]`.

## Rules
- Before shots from the untouched copy, after shots at the end (`npm run snap -- <file> <dir> 1728,1440,1366,1300,1280,1269,1200,1100,1024,992,990,768,600,375 --sides`). Copy the hero picture section before/after at 1269, 1366 and 1728 to `~/.hermes/plans/figma-to-bricks/shots/cutout-square-box/`; return paths in `shots[]`.
- Measure the four-side seam steps at every laptop width vs main, plus opaque rounded-photo controls (cover kept) and phones 375/360/320; laptop row right edges vs main.
- Save the corpus report and baseline pastes before Task 1; compare at the close as the skill says (corpus exit 1 on main is pre-existing).
- Garamond Condensed missing in an unrelated corpus design: an explicit, unwaived release-proof hold; no substitution or narrowing.
- Stay within the plan's Touches. If an existing test pinning old behaviour is outside the allowlist, commit what passes and stop naming the assertion.
- General logic only. Always pass `workdir`. No main-folder edits, BUILD bump, push or merge. You can't ask Justin: rulings as "My ruling, not yet confirmed", or stop with options. Out of steps → commit and stop. Anything else → `found_else`.

Stop at **ready-for-review** (committed, `npm run check`, `npm run test:browser` and corpus run and compared). Output: `{name, status, summary, rulings[], worktree, last_commit, shots[], defect_loop_skills[], found_else[], stop_reason}`.

## Justin's words
> ok perfect the only issue I have right now is you can see around the media on the right there is like a square box around the actual item. Can we remove that box it is subtle but you can see it around the item

Clarified: "A tighter square right around the orange cylinder"; "on figma it does not show that box around the cylinder". Approved: "Go: keep pictures' drawn shape as columns narrow (shadow + blend kept)"; model "Sol 6.1 xhigh now, whole pipeline".
