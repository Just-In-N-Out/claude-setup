# cutout-square-box — PLANNER re-plan: detect picture transparency, fix cut-outs only

Role: PLANNER (revise), ChatGPT Sol 6.1 xhigh (Justin's pick for this feature's whole pipeline). Build nothing.

## Read first
- Plan `/Users/justin/.hermes/plans/figma-to-bricks/cutout-square-box.md` (all sections incl. "Scope narrowed by Justin").
- Builder blocker: worktree `~/Documents/FigmaToBricksV2/.claude/worktrees/cutout-square-box` at `923f95d` (production restored to main; safety tests + evidence committed); evidence `evidence/cutout-square-box/resume-narrow-20261022/receipt.json`; broad candidate preserved at `8fe9196`.

## Justin's decisions
1. Scope: **"Only pictures with transparency (cut-outs); opaque photos and banners stay as today."**
2. After the builder found the pipeline has no asset alpha before sizing: **"Quick site fix now: I set that one image to 'contain' in Bricks; re-plan the plugin fix after."** So the live page gets a manual override meanwhile; the plugin fix must still land and must not conflict with that override.

## Plan this
- How the plugin learns whether each exported picture has meaningful transparency **before** the style stage: where pixels/bytes are available (Figma export in the plugin sandbox / panel, AVIF/WebP/PNG encode step, render vs fill assets), how a typed `alpha`/`cutout` fact flows extract → snapshot → normalise → style, and what happens when it's unknown (keep main's output). Prefer edge-alpha evidence (non-opaque pixels at the picture's border, which is what makes a cover crop visible) over "file format supports alpha".
- Then the approved correction for cut-outs only: keep drawn aspect as columns narrow on laptops; opaque photos/banners byte-identical to main; shadows and `will-change` kept.
- Existing protected tests (`content-box.test.ts:162`, `convert.test.ts:24` budget, golden) stay green; list any new pins under Touches.
- Debug-file/corpus implications: the snapshot format may change; say whether old debug JSON files still convert (unknown alpha → main's output).
- Size it (likely in-between/big: several pipeline stages), Skills, Docs & records, overlaps with board features, risks (performance of reading pixels, Figma sandbox limits).
- Add the manual site-override note: once the plugin fix is pasted, Justin can remove his per-element `contain` (say whether leaving it harms anything).
- Questions at top, lettered, ⭐ recommended; write as if ⭐ chosen. Reuse the existing worktree/branch in the plan (ff from main; don't reset).

Revise mode: read the existing plan and the code areas this touches; skip the full Step 1 load; about 20–25 steps. Anything unchecked becomes a builder task. Skills: figma-to-bricks (PLANNER + references/rendering-validation.md), engineering-best-practices, implementation-planning, systematic-debugging, frontend-ui-repair. Always pass `workdir`.

Save over `/Users/justin/.hermes/plans/figma-to-bricks/cutout-square-box.md` (keep the earlier decision sections). Output `{plan_path, summary, size, questions[], risks[], touches[], overlaps, found_else[]}`.
