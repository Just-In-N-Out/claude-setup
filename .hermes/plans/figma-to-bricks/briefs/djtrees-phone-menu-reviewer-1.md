# Role: REVIEWER, round 1 (full) — djtrees-phone-menu (DJ Trees designer note 2: the phone menu; Full, capped rounds)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them (this job is
Full at its planner's ⭐: a second review may follow a fix; you do round 1). Self-check: run `ac-check` with your own
`E/verifier/ac.json` and a `cp`'d scratch copy (the same file twice exits 2). Fonts: inject the DJ fonts into rendered
pages. **Bound every mutation run** (djtrees-common: 4 GB cap; never `assert.deepEqual` whole IR trees in a probe a
mutant can fail: node's diff of them reached 16 GB today).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu`
- Approved plan: `E/plan-approved.md` (AC1–AC9 by test/receipt; AC10 live, paste check 3ck on DJ staging, which runs
  Bricks **2.4.4**; the renderer follows 2.3.9).
- Builder's worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-afb732edbd2ac1c70`, branch
  `worktree-agent-afb732edbd2ac1c70`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `2153d8d4ba0e4ace4d9df4e12bd81b507ef8086c` (14 commits,
  38 files, +2325/−77; not rebased: judge against its own base).

The request: on phones the site's menu bar showed every menu word; it must fold into Bricks' Nav (Nestable) with its own
mobile menu (CLAUDE.md decision "Interactions use native Bricks elements"). The Nav sample was **researched** at
Justin's request (`E/research/`, `reference/bricks/nav-nested.json`, Bricks' front-end CSS/JS under
`reference/bricks/frontend-2.3.9/`), not copied from his Bricks: hold the emitter strictly to that sample and
Bricks' own code (documented keys only, hidden classes, `mobileMenu` from the Nav's own breakpoint), and name anything
written from memory.

Judge especially:
- **The frosted-bar fix** (5fcb9ce): a box with `backdrop-filter` becomes the containing block of fixed boxes, so the
  blur moves to the box's `::before`/`::after` with `isolation: isolate` and `position: relative`. Does that keep every
  frosted bar looking the same above the fold? Is `::before`/`::after` ever already used by the plugin on such boxes
  (CTA motion, product-card glare, hover layers, sticky header)? Does `position: relative` disturb a pinned/sticky bar?
- **Blast radius:** hydraulics, Repairs and Services now get a Nav (Services is frosted too); a header ticked out but
  drawn inside the hero gets one. Ticks on and off (JSON string), drawn phone designs (fits/shows only), the header
  spacer, the menu-bar-over-hero rule (30.12), links (`page-addresses.ts` relink, nested links, paste ids).
- **The builder's open question for the verifier:** `narrow-column` +1 at 390/768 on hydraulics and Repairs (the lint
  counts the closed panel's words inside the ☰'s 44px box). Lint false positive (follow-up) or a real problem?
- **Rulings not yet confirmed** (HANDOFF): which actions go into the panel; a several-drawing logo keeps its drawn size;
  actions beside the ☰ only on tablets, all or none; a tap on the dim leaves the menu open; the blur moving to `::before`.
- Accessibility basics the plan names (focus, Escape, Tab order, ≥48px rows), reduced motion, and determinism
  (plugin = replay, byte-identical twice).
