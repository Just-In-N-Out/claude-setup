# gro-composition-clipping — FINISHER brief (2026-10-22 00:16 EDT)

Opus medium. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/gro-composition-clipping at 80fb4fd, on main 5474523 (.25). Plan + briefs -builder, -fixpass, -rereviewer.

## Fresh Opus xhigh re-review: approve-with-minors (code correct, all gates green, verified laptops identical to main, G2/G3/G5 fixed, no collisions, clean union with responsive-pill branch)
R1 (records): laptop GRO services TOC 4th picture xnpjno is cut by section kcabyv at 992–1200 on main AND branch (992 fully off-screen, overflow 83px; 1024 5px visible; 1200 overflow 14px). HANDOFF 'Kept from main' and found-else say 'nothing cut there' — wrong. DISPATCHER RULING: keeping main's output at ≥992 stays (no regression; the drift fix was worse). Reword HANDOFF/ledger/plan copy: record the laptop TOC picture cut as OPEN, pre-existing (dispatcher already added it to found-else.md — fix the old 'nothing cut' line there too). Tell the 3az checker to expect it at 1024.
R2 (records): G7 is resolved as a side effect of F4 (container gxwsos spans 0..W at 320/340/360; eixorr overflow 336/356/348 → 0). Record G7 resolved; strike it if listed in found-else.
R3 (test): add a unit control: a turned, nudged layer's tablet margin equals calc(-Npx + max(0px, calc(...))) (mutant dropping the turned layer's own margin survives today; probe-turn.ts in reviewer evidence). Test-only; must pass on current source and fail on the mutant.
R4 (suggestion, rendering change): NOT in this release — recorded in found-else as a follow-up.
R5 info: no action.

## Do
Load figma-to-bricks (FINISHER; read references/rules-summary.md), receiving-code-review, git-commit-rules, test-driven-development. Records + R3 test, then Step 3 item 7 + Step 4: rebase on current main, check + test:browser + corpus (fonts loaded), merge lock (confirm COMPLETED exit 0), ff-only, BUILD bump, build, commit, push, verify main=origin, archive evidence with manifest (copy ~/.hermes/cache/scratch/gro-* reviewer evidence if not already archived), cleanup (.superpowers → ~/.hermes/backups/figma-worktree-leftovers/). Paste check: next free at merge (3aw/3ax/3ay taken; provisional 3az). CLAUDE.md: never retry/bypass; write gro-composition-clipping-claude-md-pending.md 'apply after the older ones, in build order'. Close found-else items this fixes (G2, G3, G5, G7). responsive-pill-planning builder is running in another worktree; after you merge it rebases onto you. Always pass workdir.
