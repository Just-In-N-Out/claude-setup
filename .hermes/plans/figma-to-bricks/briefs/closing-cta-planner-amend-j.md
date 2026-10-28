# PLANNER (amendment): closing-cta → section rhythm (FigmaToBricksV2)

You are the PLANNER. Make a small amendment to an approved plan so its ACs match a decision Justin made during the build.
Don't build, change no code or test, commit nothing.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta` (branch `worktree-closing-cta`,
  head `8bdfb28`, base `5e2f98b`). Work only there.
- The plan: `docs/plans/2026-10-28-closing-cta.md` in the worktree. Amend it in place. The approved read-only copy it
  must stay consistent with: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md` (the main session
  installs your amended file as the new approved copy).
- What changed, in the worktree: the ledger `.superpowers/sdd/2026-10-28-closing-cta/progress.md` sections "Review 1
  fixes" and "J1 J2", and `docs/HANDOFF.md`'s section rhythm part. Fixer 1's evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/fixer-1/`. Reviewer 1's report: `../reviewer-1/review.json`.

## Justin's decision (2026-10-28)
Asked whether (1) a one-row bar holding a call-to-action button drawn with under 40px space, and (2) a closing section
with a decorative layer placed on it, drawn flush with the footer, should get the page's section space under their
buttons, Justin answered: "I'm not sure how to answer these two questions. I mean, put it in a way where it looks more
aesthetic." The main session ruled: buttons always get the page's section space (J1: a bar holding a call to action is
never a tight strip; J2: a section ending with buttons gets S under them though a layer is placed on it, unless a placed
layer would then land on its words or buttons or leave the edge it was drawn along, in which case it keeps today's
spacing). Fixer 1 built both (commits 5365e9f, 92da725, 8d2e973).

## The amendment
1. Find every line of the plan that J1/J2 or fixer 1's review fixes contradict. Fixer 1 named one: AC8's bullet saying
   the decorated closing (`decor: true`) keeps its `_padding.bottom*` as base; with J2 it gets S (96 / 67 / 48),
   asserted in AC7. Also check R4 (tight), R5 (placed layers), R12, the deferred minors, the Risks, AC5–AC8's
   wording and each AC's named test (fixer 1 added cases and a Chrome test "AC7 hills pinned to the bottom…").
2. Amend only those lines, plainly, marking each changed line "(amended 2026-10-28, Justin J1/J2)" or
   "(amended 2026-10-28, review 1 F<n>)". Keep the AC numbers AC1–AC12 and their `(proposed)` / `(live)` tags. Add no
   new scope: anything fixer 1 ruled that is not J1/J2 stays a ruling "not yet confirmed" in HANDOFF, not an AC, unless
   an AC's existing text already contradicts the built behaviour (then amend that text and say why).
3. Add a short "Amendments" list near the top (date, what changed, why), so the verifier and auditor read the ACs
   against the built behaviour and Justin's decision.
4. Verify each amended AC's named test exists in the worktree and asserts what the amended text says (read the test
   files; don't run gates beyond `node --test <one file>` if you need to confirm a name).

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (PLANNER role; only the parts
   you need). 2. `implementation-planning` (Skill tool), for AC wording: numbered, one named test each.

## Rules
- Plain words: Justin reads short messages. You can't ask Justin anything.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`, heredoc then node, the word git inside a grep pattern). One plain command per call.
- Other bugs: `found_else`. Reusable lessons: `skill_lessons[{skill, lesson, evidence}]` only; never edit skills or
  memory; empty is normal. Don't start other agents.

## Return (your final message)
`{plan_path, amendments[{line_or_ac, old, new, why}], acs_changed[], live_acs[], tests_checked[], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
