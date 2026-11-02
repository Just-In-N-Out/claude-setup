# Role: BUILDER — djtrees-stack-lines (DJ Trees designer note 6, phones; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. The planner's commit is
  `10e316e4586fc28f9cd0b10fd84bc5f37a519c34` on branch `worktree-agent-a8436899053f7eaec` (adds
  `docs/plans/2026-11-02-djtrees-stack-lines.md` on top of `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 10e316e4586fc28f9cd0b10fd84bc5f37a519c34`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes and shots: `E/planner/` (`work/live.ts`, `chain.ts`, `scan.ts`, `replay-probe.sh`, `chrome.sh`;
  `live-before/`, `replay-before/`, `work/snap-before/`).
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-stack-lines/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role (and
   `references/rules-summary.md`: an overriding rule writing at a tier must also write at every narrower tier the
   overridden rule writes).
2. `engineering-best-practices`. 3. `test-driven-development`: a failing test before each code change.
4. `mutation-testing-discipline` for the which-rows guard (AC4's controls must each fail with its guard removed).
5. `systematic-debugging` when a test fails unexpectedly or a byte-identity check moves.

## Approved answers

Q1–Q4 ⭐ (Justin: "whatever the planner agent recommends go with it"). AC1–AC7 by test/receipt, AC8 live (paste check
3co). This replaces the CLAUDE.md phone rule's "loses the lines once it … stacks" for rows that stack one per line:
put the new wording in your HANDOFF section as "CLAUDE.md line for the finisher" (don't edit CLAUDE.md).

## Running beside you (same files)

djtrees-step-sides (note 7) is being built now from `1aef12f`: it adds a divided-row kind for items lined along one
edge (`Divided.edge` or similar) in `divided.ts` and writes stacked `_rowGap` in `rules/rows.ts`, with the same midway
rule and the 16px floor (`STACK_MIN_GAP`). Use the same floor name if you add one; keep your change in a named
function (`dividerLooks` export, your tier writes) so the later rebase can merge both. Your made line must skip
edge-lined rows (the plan says how). djtrees-top-align (note 5) and djtrees-stack-gaps (note 9) may also touch these
files.

## Done means

AC1–AC7 each proven by its named test or receipt (names exactly as the plan's lines); `npm run check` green (no
existing assertion changed); the browser fixture test green with `skipped 0`; hydraulics, GRO, Repairs and Services
byte-identical, brainstorm only its index row; DJ Trees diff only in the 3 divided rows at their stacked tiers; HANDOFF
section with paste check **3co**; ledger committed; worktree clean; status `ready-for-review`.

## Return

`status` (`ready-for-review` | `stopped` with `stop_reason`), `worktree`, `branch`, `base`, `last_commit` (full SHA),
commits, files changed, gates with results, `ac_evidence[]` (AC id, test name, log path, screenshot path),
before/after screenshots in `E/builder/` (points and credentials at 390, 478, 767), `found_else`, `skill_lessons`.
Mini: if the fix needs more than ~3 source files or a decision the plan didn't settle, stop with
`stop_reason: escalate to full`.
