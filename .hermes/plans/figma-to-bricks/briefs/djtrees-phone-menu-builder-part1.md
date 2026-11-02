# Role: BUILDER (part 1 of 2) — djtrees-phone-menu (DJ Trees designer note 2, phones)

Build the approved plan's **ready** tasks test-first (Tasks 0, 1, 2 and 3 up to its element names), then stop. Don't
re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` (batch rules, git, this
machine's checks) and follow it.

## Why part 1

The phone menu is Bricks' Nav (Nestable), and its sample (`reference/bricks/nav-nested.json`) isn't here yet: Justin
will copy it out of his Bricks when he's back. Tasks 4 and 5 (emitter, renderer, browser tests) and the copy's element
names wait for it; never write them from memory (repo CLAUDE.md "Bricks element shapes come from
`reference/bricks/*.json`"). A second builder (or you, resumed) does Tasks 3's names, 4, 5 and 6 once it arrives. The
planner judged this bigger than Mini (~7 source files); keep each task's commit self-contained and the ledger exact so
the next builder can pick up.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. The planner's commit is
  `c5a94815b735cca964882ab00135ae595f492dab` on branch `worktree-agent-afb31f02cc4ac7b7c` (adds
  `docs/plans/2026-11-02-djtrees-phone-menu.md` on top of `1aef12f`).
- **Task 0 of yours:** in your own worktree, `git merge --ff-only c5a94815b735cca964882ab00135ae595f492dab`; check the
  plan file equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes and shots: `E/planner/` (`scripts/`, `hero-shots.sh` with `NOSETTLE=1` for widths ≥ 992, where
  `snap` stalls on this file).
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-phone-menu/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role.
2. `engineering-best-practices`. 3. `test-driven-development`: a failing test before each code change.
4. `mutation-testing-discipline` for the recognition guards (AC2's negatives must each fail with their guard removed).
5. `systematic-debugging` when a test fails unexpectedly or a byte-identity check moves.

## Approved answers

Q1–Q6 ⭐A (Justin: "whatever the planner agent recommends go with it").

## Done means (part 1)

Tasks 0–3 (3 without element names) committed with their RED→GREEN tests (AC1/AC2 detection and negatives; AC3–AC5
as typed-style rule-unit tests); `npm run check` green; the five other real files and DJ Trees unchanged in payload
(Task 2's styles are not wired into output until the emitter exists, or are, per the plan's "not releasable alone":
say which, and make sure nothing user-visible changes yet); ledger lists exactly what Tasks 3–6 still need from the
sample; worktree clean; status `stopped`, `stop_reason: "waiting for the Nav (Nestable) sample"`.

## Return

`status`, `stop_reason`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with
results, which ACs have tests already and which wait, `found_else`, `skill_lessons`.
