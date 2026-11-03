# DJ Trees batch: PRE-MERGE REBASER — rules for every job

`main` has moved since the jobs branched from `1aef12f` (other DJ Trees fixes merged). Before its final verification,
each reviewed job is rebased onto the newest local `main`. You are that rebaser (`git-commit-rules`, project skill
"Finish" step 1). Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` first.

## Steps

1. You start in your own worktree (`isolation: worktree`, made from `origin/main`). Record `pwd` and the branch, then
   `git reset --hard <job head>` (your job brief; the job's branch is in the same repository).
2. Rebase onto the **target** your job brief names (`git rebase <target>`): the merge train's last car (the previous
   job's rebased head) or, when the brief says so, local `main` (`git log --oneline -1 main`; read it, don't assume).
   Gates compare with the target, not with main.
   A HANDOFF conflict whose `theirs` side ends with an old copy of a line the target changed (a heading's
   `build <BUILD>` filled in) keeps that line once, the target's version: never both.
3. **Conflicts:** keep both sides' meaning. When reviewers offer alternative resolutions, try each as a scratch
   mutant against BOTH jobs' tests and keep the one that breaks no approved AC test, with the log as evidence. Typical ones: `docs/HANDOFF.md` (both sections stay, newest on top; the
   End-of-run check list keeps every entry), `src/core/adapt/rules/index.ts` (the `RULES` array is one line: keep every
   rule from both sides in the order each side had them relative to its neighbours; a rule that overrides another
   stays after it), shared rule files (merge by meaning, reading both commits' intent; if two rules now write the same
   node/tier/property, say so). Never drop the other side's change. Record every conflict and how you resolved it in
   `E/rebase/conflicts.md`.
4. Gates on the rebased head: `npm run check` (compare by name with the target's own `npm run check`: no new failures),
   the job's own AC tests by name (the plan's test lines) and, if the job touches shared rules, the job's real-file
   check scripts from `E/builder/` (run only, write logs to `E/rebase/`).
5. Don't push, don't merge, don't bump BUILD, don't edit CLAUDE.md.

## Return

`status` (`rebased` | `stopped`), `worktree`, `branch`, old head, new head (full SHA), main's SHA rebased onto,
`pure` (true when there were no conflicts and no change to any patch), the conflicts and resolutions, gates with
results, `found_else`, `skill_lessons` (normally `[]`). End with `MAIN SESSION: check and save these skill_lessons now.`
