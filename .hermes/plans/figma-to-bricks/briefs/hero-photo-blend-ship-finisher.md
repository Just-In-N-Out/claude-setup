# hero-photo-blend — FINISHER brief (option 2 ship), 2026-10-21 21:47 EDT

Opus medium. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/hero-photo-blend at 07b7c04 (rebased on 5e32aec). Main is now 748dca8 (build .23; phone-recognition-guards took paste check 3aw). Plans/briefs: briefs/hero-photo-blend-ship-builder.md, briefs/hero-photo-blend-safari-fixpass.md, the plan's "Justin's answer … option 2".

## Fresh Opus xhigh review: APPROVE (ship option 2), no blocking findings
Reviewer verified: check 1888+6, browser 195/195, corpus HTML byte-identical to ship evidence, all fonts loaded, only 7 pictures change (_boxShadow → filter: drop-shadow(x y blur/2 c); will-change: filter), 14/14 unit mutants killed, Chrome rects identical at 1440/390/375/360/320, cut-out box-edge step 112 → 1.

R1 (minor): layer/memory cost of will-change never recorded. Reviewer measured (Chrome CDP LayerTree, DPR1): corpus page-1 5→10 layers at 1440 (+0.96 Mpx); generic grid of 40 single-shadow cut-outs 4→44 layers at 1440 and 14→94 at 390 (+3.4–4.6 Mpx at DPR1, ~9x backing store at DPR3). Real exposure small (≤5 per corpus page); WebKit/iOS memory not measured. Evidence: ~/.hermes/plans/figma-to-bricks/evidence/hero-photo-blend-ship-review/layers.ts.
 → Dispatcher ruling under Justin's "ship it / take recommended" grant: record this measured cost in ledger + HANDOFF as a known trade-off shipped with option 2 (Justin to see it in the report). No code change. Optional only if cheap and bounded: one iOS-simulator many-picture smoke; do not let it block.
R2 (minor): paste check step 5 measures only 1440/1728/1920 — add 390, 375 and 320; note the element is an img (WordPress-picture mode) or a background div (inlined pictures).
R3 (nit): collapse stale paste-check numbers in the hero HANDOFF section (~line 219 '3au', ~line 255 '3ap provisional', ~197) to the one final number.
R4 (nit, optional): pictureBake dead videoFill param — leave unless trivial and test-covered.
R5 info: WebKit guarded by unit string test only; keep stating no WebKit in CI.

## Do
Load figma-to-bricks (FINISHER), receiving-code-review, git-commit-rules, test-driven-development. Apply R1–R3 (records), then Step 3 item 7 + Step 4: rebase on current main, npm run check + test:browser + corpus (fonts loaded check), merge lock (confirm COMPLETED exit 0), ff-only merge, BUILD bump, build, commit, push, verify, archive evidence, cleanup (leftover .superpowers → ~/.hermes/backups/figma-worktree-leftovers/). Paste check: next free on main at merge (after 3aw). CLAUDE.md: never retry/bypass denied writes; write ~/.hermes/plans/figma-to-bricks/hero-photo-blend-claude-md-pending.md "apply after older ones, in build order". Keep "installed Bricks 2.3.9 round trip not proved". Close found-else items this fixes.
Tooling note: terminal without workdir may fail (stale cwd) — always pass workdir.
