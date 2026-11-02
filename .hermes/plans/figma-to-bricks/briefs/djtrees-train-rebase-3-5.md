# Role: TRAIN REBASER — merge-train cars 3, 4 and 5 (three jobs, one after another)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it for each job,
with this difference: you build a chain. Each job is rebased onto the previous car's rebased head, so after you finish
the three heads sit one on top of the other and can merge into `main` in order with fast-forwards.

**Load: the computer crashed twice under load. Run one Chrome at a time, one suite at a time.**

Work in your own worktree, one job after another (reset to the job's head, rebase onto the target, resolve, gate,
note the new SHA on a branch you create, then the next job starts from that SHA as its target):

| car | job | job head (fixed, reviewed) | E (write `E/rebase/`, fresh) | target |
|---|---|---|---|---|
| 3 | djtrees-strip-edge | `3a2f915aeadfd8dd93311cf0d6b513e783880483` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-strip-edge` (its old `rebase/` onto main is `rebase-main-ba83c44/` once you move it) | `b0d8f65fe4d8bb0fc00f940445d1eac4cb92d697` (car 2, storm-photo) |
| 4 | djtrees-top-align | `d5e3eac8ffac0de857c7f10493e889271eb55c86` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align` | car 3's new head |
| 5 | djtrees-faint-picture | `f2e444caa1a1bdee445abd71afd0857a5558d47a` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-faint-picture` | car 4's new head |

- Create a branch per car so each head stays reachable: `git branch train-strip-edge <sha>`, `train-top-align`,
  `train-faint-picture` (local branches only; never push).
- Expected conflicts: `docs/HANDOFF.md` (every section kept, newest on top; every End-of-run check-list entry kept;
  add the job's own check-list entry if it has none: 3cu for strip-edge, 3cn for top-align, 3cv for faint-picture),
  maybe `src/core/adapt/rules/index.ts`. The three jobs touch different source files (strips.ts; shares.ts,
  label-box.ts, widgets.ts; picture*.ts, states.ts, motion.ts, style.ts, form.ts): any source conflict means read
  both commits' intent and say so.
- Gates per car (compare with its target): `npm run check` by name; the plan's AC tests by name (`E/plan-approved.md`
  of each job); for faint-picture and top-align also the six real files' replay diff against the target, ticks off and
  on (`s.site = JSON.stringify({header: true, footer: true})` or `replay --site`): only the job's own expected changes.
- Don't push, merge, bump BUILD or edit CLAUDE.md.

## Return

For each car: old head, new head (full SHA), branch, target, `pure`, conflicts and resolutions, gates with results.
Then `found_else` and `skill_lessons` (normally `[]`). End with `MAIN SESSION: check and save these skill_lessons now.`
