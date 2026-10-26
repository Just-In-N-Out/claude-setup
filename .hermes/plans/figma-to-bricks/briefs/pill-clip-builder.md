# Brief: BUILDER for figma-to-bricks feature "pill-clip" (B6)

Build the approved plan at `~/.hermes/plans/figma-to-bricks/pill-clip.md` (Justin: P1A P2A P3A). Model: **Sol 6.1 xhigh**, whole pipeline per Justin's explicit override.

## Current baseline and folded items (read before original State)
Prerequisites merged: CTA .8, test-cleanup .12 (style split/tools fixed), layout-floors .17 at 3e1a3b4. Start actual latest main. Re-run EVERY old repro before fixing; plan line numbers/base are stale. layout split is now layout.ts + shapes.ts + kinds.ts; shared side geometry adapt/sides.ts. Preserve L1A conditional narrow-phone sides and wrapped-line top packing, circles/photo-fit guards. Check actual main at 375/360/320 too.
Include the plan's Fold addendum: GRO cut texts at1440 ('Client Name — Lifestyle'), '04' and 'Contact'; laptop992 spill; min-width floor on small phones if same cause. Existing card-link docs pending separate feature: don't reverse its title/pill/no-whole-card decisions.
New related findings to investigate in this batch (test/root cause before changing): least.ts sums a drawn-WRAPPING pill row as if one line, causing early parent stacking; .17 left uneven alike inspo pills open (26/26/28 instead of28/28/28); button floor rounded down279 vs279.15 may wrap, use ceil only if demonstrated in same width path. Only small general same-area fixes; do not balloon into carousel/ALONE/twoShare redesign. Record exact remaining findings rather than calling all fixed.

Other live work: PDF new-tab finisher emit/normalise-links/typography; card-link-words fix pass normalise/label-links; hero-photo-blend fix pass paint/picture-shadow. No planned source overlap; never edit their copies. Shared records/build serialized at merge only. Before screenshots from untouched worktree, then after, all required widths. Preserve raw reports/fonts/motion and complete lint identities, not score-only claims.


## Found items this closes
The 2 lines under "## B6 pill-clip" in `found-batches.md` (originals in `found-else.md`: "cta-label-wrap builder" design pills cut at 1024; "layout-floors planner" GRO 'Let's talk →'), plus the W2A laptop pill line ("Medium (covered by cta-label-wrap W2A): the design file's pill buttons wrap at laptop widths…", marked ⚠️ partly fixed by cta-label-wrap). The finisher marks each `~~item~~ ✅ fixed in build <BUILD> (pill-clip)`.

## State
- Starts only after cta-label-wrap AND layout-floors have merged (P3A: layout-floors splits adapt/layout.ts). Check `git log --oneline -8 main`, `BUILD`, and read both features' HANDOFF sections first; re-run the plan's repro on that main before Task 1 (cta-label-wrap's finisher changed decideRow/least for its F1–F3).
- test-cleanup may be splitting style/style.ts; this plan edits 2 lines there (150–152). Stay within this plan's files; whoever merges second rebases, keeps both HANDOFF sections and takes the next free paste check.

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6). `references/rules-summary.md` first, then only the CLAUDE.md sections you need.
2. `skill_view('test-driven-development')`; `skill_view('systematic-debugging')` on surprises. Say you loaded them.
3. Worktree `.claude/worktrees/pill-clip`, branch `worktree-pill-clip`, from main.
4. Before shots from the untouched copy (design services pills at 1200/1024/992, GRO 'Let's talk' at 768, the design header at 1024), after shots after the last task; pairs to `~/.hermes/plans/figma-to-bricks/shots/pill-clip/`, paths in `shots[]`.
5. `overflow: clip` in Bricks `_overflow` needs a paste round trip: note the paste check in HANDOFF, with `_cssCustom` as the fallback the plan names.
6. Plan copy, ledger, HANDOFF with the next free paste check. Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`.
7. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse; not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
8. Plain words for WhatsApp.
