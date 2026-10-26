# FIX PASS: hero-photo-blend — Sol 6.1 xhigh, NOT authorized to merge yet

Existing worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/hero-photo-blend at 14c202d, branch worktree-hero-photo-blend. Approved plan ~/.hermes/plans/figma-to-bricks/hero-photo-blend.md A1 B1 C1 but plan's same-blur assumption proven wrong. Load figma-to-bricks FINISHER, receiving-code-review, test-driven-development, git-commit-rules; systematic-debugging as needed. State loaded.

Fresh reviewer REQUEST CHANGES. Full evidence ~/.hermes/plans/figma-to-bricks/evidence/hero-photo-blend-review/.

HPB-R1 high introduced:
'The filter blur must use half the Figma/box-shadow radius. Copying the same number doubles the Gaussian blur and visibly changes opaque photos.'
Evidence picture-shadow.ts:18 d.blur unchanged. Filter Effects uses std dev; CSS Backgrounds 6.1.2 box-shadow std dev half blur radius. Reviewer saved specifications. Real opaque rounded photo 48px radius: box 0/26/44 vs filter 0/26/44 max difference 36 RGB, 113528 pixels >2; filter 0/26/22 matches within 1 RGB. Five real page-1 images vs Figma all improve at half radius. Existing 8 unit tests pin incorrect numbers; browser tests miss it. Verify reference/evidence, fix mapping TEST FIRST, preserve layer-blur's own semantics, update docs/plan assumptions, add opaque rounded-photo pixel regression and retain transparent cutout regression. Use real photo provenance in evidence. Don't blindly trust earlier plan. Commit correction.

HPB-R2 medium introduced:
'Chained drop-shadow functions can create an extra shadow, not merely a slightly darker version of the drawn shadows.'
Two 80%-black zero-blur shadows offset (70,0) and (0,70) create phantom (70,70): RGB92 where independent SourceAlpha reference white, 854 pixels >2. Unit pins chain/warning, never shape. Evidence multi-current.png, multi-independent.png, measurements.json.
Parent is asking Justin to choose conservative fallback vs independent multi-shadow implementation. While waiting: reproduce R2, create failing generic pixel test, assess minimal options. DO NOT choose fallback or build independent filter architecture without his answer. Keep evidence and commit R1 passing work. If no answer by boundary, stop status awaiting-answer with R1 commit and exact R2 choice needed. Do not merge/push/BUILD/CLAUDE.md/main edits or worktree cleanup. This is fix pass only until R2 approval; independent multi-shadow redesign may require revised plan/review. Never ship chain disguised as minor darkness.

Other reviewer findings: states.ts untouched supported (only opacity picture states), existing test stronger except blur number, page-1 stand-in score drop is valid artifact (real images closer to Figma), no positioned child content/performance regression found. Safari supported but not actually tested. Ranges irrelevant. Main .16+ and paste check 3ap already taken; final finisher later renumbers next free.

Gates after R1: focused and check/browser/corpus as feasible, compare no layout changes/full lint/font; maintain exact evidence. Separate builders pdf-new-tab/card-link-words and layout-floors finisher own other files, no changes there. Return status, R1 last_commit, gate results, R2 evidence/options/scope, found_else. New product decisions require Justin.
