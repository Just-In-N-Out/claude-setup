# Role: REVIEWER, round 2 (full) — djtrees-side-art (Full job, capped rounds)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-reviewer-common.md` first and follow them, with these
differences: this is **round 2**, a full review of the whole story from base after the round-1 fixes. Write
`E/review-2/review.json` (`"round": 2, "scope": "full", "from": <base>, "head": <head>`). Read round 1's
`E/review-1/review.json` and the fixer's answers (`E/fixer-1/`, ledger "Review 1 fixes"): judge each round-1 finding
closed or not (a finding that isn't closed is raised again with `repeats`). The verifier's AC work goes in
`E/verifier/` (fresh; round 1's is in `E/verifier-review1-011e0f9/`). Self-check `ac-check` with your own
`E/verifier/ac.json` and a `cp`'d scratch copy.

**Load: the computer crashed twice under load. One Chrome at a time, one suite at a time, `npm run check` once.**
Ticks are a JSON string (`s.site = JSON.stringify({header: true, footer: true})` or `replay --site`); a ticked DJ
Trees paste has 694 elements vs 758. Inject the DJ fonts (`E/builder/fonts/`) into rendered pages.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art`
- Approved plan: `E/plan-approved.md` (AC1–AC9 by test/receipt; AC10 live, 3cm). AC8 (`E/builder/replay-check.ts`)
  wasn't re-run on the fixed head: run it.
- Fixer's worktree (the job's head): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-aa58d4397dab2299e`,
  branch `worktree-agent-aa58d4397dab2299e`.
- **base** `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`, **head** `e1dc5a6912f7d15c9505148651bc4bc7974f7c84`.

The fixer's rulings to judge: art the rule can't put beside its heading stays where drawn (as on base); the space kept
above an unpainted section beside a left-out header now counts in `section.top`'s padding (96 + 40 stepped as 136);
`beside()` uses `opens()` walking in phone order; `section.top` skips layers with their own composition (wave/hills
stay `art.edge`'s). Probe again: the header/footer ticks (each alone and both), photo-first and eyebrow-first
columns, zigzag rows, waves along the bottom, painted vs unpainted sections, the FAQ section's tree (job 10 builds on
`beside()` next), and 320–991.
