# Role: BUILDER — djtrees-faq-art (DJ Trees designer note 10, phones; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks, the one-Chrome rule, ticks as a JSON string, fonts) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faq-art`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commit `f112f678ecbadf717d7bc009d01821f7640ec776`
  on branch `worktree-agent-a65220e19f422f1a2` (adds `docs/plans/2026-11-02-djtrees-faq-art.md` on `1aef12f`).
- **This job builds on djtrees-side-art's `beside()` rule.** That job isn't merged yet: its fixed head
  `e1dc5a6912f7d15c9505148651bc4bc7974f7c84` (branch `worktree-agent-aa58d4397dab2299e`) is in its round-2 review.
  **Task 0:** in your own worktree, `git reset --hard e1dc5a6912f7d15c9505148651bc4bc7974f7c84`, then
  `git cherry-pick f112f678ecbadf717d7bc009d01821f7640ec776` (the plan file only), and check the plan file equals
  `E/plan-approved.md`. Base for AC base runs and comparisons: `e1dc5a6` (side-art's head: the plan says "built on
  job 4's rule"). If side-art's round-2 review changes it, root will have you rebase later; keep your changes in
  named functions so that's easy.
- Read side-art's ledger (`.superpowers/sdd/2026-11-02-djtrees-side-art/progress.md`, its "what a beside art needs"
  notes) and HANDOFF section. The plan's Q1 (the tree showing black) is now fixed by djtrees-faint-picture (separate
  job, not merged yet): don't touch picture opacity.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-faq-art/progress.md` in your worktree (committed).

## Skills

Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (BUILDER role),
`engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the "away" recognition guards:
AC2's controls must each fail with their guard removed), `systematic-debugging`.

## Approved answers

Q1–Q5 ⭐ (Justin: "whatever the planner agent recommends go with it"); Q4's laptop 992–1150 overlap is a follow-up.
AC1–AC6 by test/receipt, AC7 live (3cs).

## Done means

AC1–AC6 proven by their named tests/receipts against base `e1dc5a6`; `npm run check` green; the browser test green with
`skipped 0` (one Chrome on the PC at a time); the six real files (ticks off and on) differ from `e1dc5a6` only in DJ's
"12 FAQ" elements; HANDOFF section with paste check **3cs**; ledger committed; worktree clean; status
`ready-for-review`. Don't rebase onto main.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates, `ac_evidence[]`,
before/after shots in `E/builder/` (the FAQ section at 390, 767, 1440), `found_else`, `skill_lessons`, closing line.
