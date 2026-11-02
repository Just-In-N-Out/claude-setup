# Role: BUILDER — djtrees-side-art (DJ Trees designer note 4, phones and tablets; Full, one job)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commit `320ef8237e9166645cd8d372f9d5f3d32cc3c40a`
  on branch `worktree-agent-a67f6eeed4f0938cc` (adds `docs/plans/2026-11-02-djtrees-side-art.md` on `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 320ef8237e9166645cd8d372f9d5f3d32cc3c40a`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes and shots: `E/planner/` (`probe.ts` blast radius, `noband.ts`, `measure.ts`, `live.ts`,
  `sections.ts`; `before/`, `live/`, `others/`). Confirm the planner's flagged witness: its probe took an image-filled
  "24/7" text as section 08's heading.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-side-art/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role. 2. `engineering-best-practices`.
3. `test-driven-development`. 4. `mutation-testing-discipline` for both guards (R1's which-sections test, AC3; R2's
   recognition, AC4: each negative control must fail with its guard removed). 5. `systematic-debugging` when a test
   fails unexpectedly or the witness probe shows a change outside the sections the plan names.

## Approved answers

Q1–Q6 ⭐A (Justin: "whatever the planner agent recommends go with it"): one job, Full (it gets the project's capped
review rounds instead of a single review). AC1–AC9 by test/receipt, AC10 live (3cm). Build R1 (top space) first and
commit it on its own, then R2 (art beside the heading), so each half is reviewable.

## Running beside you

- djtrees-faq-art (note 10, the FAQ tree) is planned to build on your R2 rule after you merge: keep R2's recognition and
  placement in named, exported functions (`compose.ts` `beside`, `rules/art.ts`), and record in the ledger what a
  "beside" art needs, so that job can extend it.
- djtrees-storm-photo adds a rule to `rules/index.ts` (one line each; keep yours one line).
- djtrees-stack-lines/-step-sides edit `rules/rows.ts`/`divided.ts`; avoid them.

## Done means

AC1–AC9 proven by their named tests/receipts (names exactly as the plan's lines); `npm run check` green with the
existing `adapt-unpin` reach test unedited; the browser test green with `skipped 0`; the witness probe as AC9 says;
HANDOFF section with paste check **3cm**; ledger committed; worktree clean; status `ready-for-review`.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with results,
`ac_evidence[]` (AC id, test name, log, screenshot), before/after shots in `E/builder/` (section 02 at 390, 478, 767,
991, 1440; sections 05 and 08 at 390), `found_else`, `skill_lessons`.
